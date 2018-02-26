#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2016
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################


# We define a generic representation for polygonal complexes
DeclareRepresentation("IsGenericPolygonalComplexRep", 
    IsPolygonalComplex and IsAttributeStoringRep, []);

# Define a generic type
BindGlobal( "PolygonalComplexType", 
    NewType( PolygonalComplexFamily, IsGenericPolygonalComplexRep ));



##
## Check whether a polygonal complex is a triangular complex.
##
__SIMPLICIAL_AddPolygonalAttribute( IsTriangularComplex );
InstallMethod( IsTriangularComplex, "for a polygonal complex that has EdgesOfFaces",
    [ IsPolygonalComplex and HasEdgesOfFaces ],
    function( complex )
        local edgeSize;

        edgeSize := List(Faces(complex), f -> Length(EdgesOfFaces(complex)[f]));
        return Length( Filtered( edgeSize, s -> s<>3 ) ) = 0;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "IsTriangularComplex",
    "EdgesOfFaces");


##
## Check whether a polygonal complex is a ramified polygonal surface.
##
__SIMPLICIAL_AddPolygonalAttribute( IsRamifiedPolygonalSurface );
InstallMethod( IsRamifiedPolygonalSurface, 
    "for a polygonal complex that has Edges and FacesOfEdges",
    [ IsPolygonalComplex and HasFacesOfEdges and HasEdges ],
    function( complex )
        local faceSize;
        
        faceSize := List( Edges(complex), e -> Length(FacesOfEdges(complex)[e]) );
        return Length( Filtered( faceSize, s -> s > 2 ) ) = 0;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, 
    "IsRamifiedPolygonalSurface", ["Edges", "FacesOfEdges"] );


##
## Check whether a ramified polygonal surface is a polygonal surface
##
__SIMPLICIAL_AddPolygonalAttribute( IsPolygonalSurface );
InstallMethod( IsPolygonalSurface, 
    "for a ramified polygonal surface with UmbrellaPartitionsOfVertices and Vertices",
    [ IsRamifiedPolygonalSurface and HasUmbrellaPartitionsOfVertices and HasVerticesAttributeOfPolygonalComplex],
    function( ramSurf )
        local paths, pathSize;

        paths := UmbrellaPartitionsOfVertices(ramSurf);
        pathSize := List( VerticesAttributeOfPolygonalComplex(ramSurf), v -> Length(paths[v]) );
        return ForAll(pathSize, s -> s = 1);
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "IsPolygonalSurface",
    ["IsRamifiedPolygonalSurface", "UmbrellaPartitionsOfVertices", "VerticesAttributeOfPolygonalComplex"] );
InstallImmediateMethod( IsPolygonalSurface,
    "for a polygonal complex that is no ramified polygonal surface",
    IsPolygonalComplex and HasIsRamifiedPolygonalSurface, 0,
    function(complex)
        if not IsRamifiedPolygonalSurface(complex) then
            return false;
        fi;
        TryNextMethod();
    end
);

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


# We define a generic representation for polygonal complexes
DeclareRepresentation("IsGenericBendPolygonalComplexRep", 
    IsBendPolygonalComplex and IsAttributeStoringRep, []);

# Define a generic type
BindGlobal( "BendPolygonalComplexType", 
    NewType( BendPolygonalComplexFamily, IsGenericBendPolygonalComplexRep ));



##
## All of the filters
## * IsTriangularComplex
## * IsRamifiedPolygonalSurface
## * IsRamifiedSimplicialSurface
## * IsPolygonalSurface
## * IsSimplicialSurface
## should act like categories
InstallOtherMethod( IsPolygonalComplex, "for an object", [IsObject],
    function(obj)
        if not IsVEFComplex(obj) then
            return false;
        fi;
        # Since IsPolygonalComplex is a category, the above
        # check can't change anything
        TryNextMethod();
    end
);
InstallOtherMethod( IsTriangularComplex, "for an object", [IsObject],
    function(obj)
        if not IsPolygonalComplex(obj) then
            return false;
        fi;
        # Since IsPolygonalComplex is a category, the above
        # check can't change anything
        TryNextMethod();
    end
);
InstallOtherMethod( IsRamifiedPolygonalSurface, "for an object", [IsObject],
    function(obj)
        if not IsPolygonalComplex(obj) then
            return false;
        fi;
        # Since IsPolygonalComplex is a category, the above
        # check can't change anything
        TryNextMethod();
    end
);
InstallOtherMethod( IsPolygonalSurface, "for an object", [IsObject],
    function(obj)
        if not IsPolygonalComplex(obj) then
            return false;
        fi;
        # Since IsPolygonalComplex is a category, the above
        # check can't change anything
        TryNextMethod();
    end
);


##
## Check whether a polygonal complex is a triangular complex.
##
__SIMPLICIAL_AddPolygonalAttribute( IsTriangularComplex );
InstallMethod( IsTriangularComplex, "for a polygonal complex that has EdgesOfFaces",
    [ IsPolygonalComplex and HasEdgesOfFaces ],
    function( complex )
        local f;

        for f in Faces(complex) do
            if Length(EdgesOfFaces(complex)[f]) <> 3 then
                return false;
            fi;
        od;
        return true;
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
        local e;

        for e in Edges(complex) do
            if Length(FacesOfEdges(complex)[e]) > 2 then
                return false;
            fi;
        od;
        return true;
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
        local paths, v;

        paths := UmbrellaPartitionsOfVertices(ramSurf);
        for v in VerticesAttributeOfPolygonalComplex(ramSurf) do
            if Length(paths[v]) <> 1 then
                return false;
            fi;
        od;
        return true;
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

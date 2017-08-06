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


##############################################################################
##
##          Methods for labelled access
##
InstallMethod( Vertices, "for a polygonal complex", [IsPolygonalComplex],
	function(complex)
		return VerticesAttributeOfPolygonalComplex( complex );
	end
);

# methods to compute number of vertices, edges, faces
InstallMethod( NrOfVertices, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
            return Length( Vertices(complex) );
    end
);

InstallMethod( NrOfEdges, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
            return Length( Edges(complex) );
    end
);

InstallMethod( NrOfFaces, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
            return Length( Faces(complex) );
    end
);

##
##              End of labelled access
##
##############################################################################


##############################################################################
##
##          Methods for basic access (*Of*)
##

##
## Connection between labelled access and *Of*-attributes (via scheduler)
##

BindGlobal( "__SIMPLICIAL_BoundEntriesOfList",
    function( list )
	return Filtered( [1..Length(list)], i -> IsBound( list[i] ) );
    end
);

## EdgesOfVertices
InstallMethod( "Edges", 
    "for a polygonal complex with EdgesOfVertices",
    [IsPolygonalComplex and HasEdgesOfVertices],
    function(complex)
        return Union(EdgesOfVertices(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "Edges", "EdgesOfVertices");

InstallMethod( "VerticesAttributeOfPolygonalComplex", 
    "for a polygonal complex with EdgesOfVertices",
    [IsPolygonalComplex and HasEdgesOfVertices],
    function(complex)
        return __SIMPLICIAL_BoundEntriesOfList(EdgesOfVertices(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "VerticesAttributeOfPolygonalComplex", "EdgesOfVertices");


## FacesOfVertices
InstallMethod( "Faces", "for a polygonal complex with FacesOfVertices",
    [IsPolygonalComplex and HasFacesOfVertices],
    function(complex)
        return Union(FacesOfVertices(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "Faces", "FacesOfVertices");

InstallMethod( "VerticesAttributeOfPolygonalComplex", 
    "for a polygonal complex with FacesOfVertices",
    [IsPolygonalComplex and HasFacesOfVertices],
    function(complex)
        return __SIMPLICIAL_BoundEntriesOfList(FacesOfVertices(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "VerticesAttributeOfPolygonalComplex", "FacesOfVertices");


## VerticesOfEdges
InstallMethod( "VerticesAttributeOfPolygonalComplex", 
    "for a polygonal complex with VerticesOfEdges",
    [IsPolygonalComplex and HasVerticesOfEdges],
    function(complex)
        return Union(VerticesOfEdges(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "VerticesAttributeOfPolygonalComplex", "VerticesOfEdges");

InstallMethod( "Edges", "for a polygonal complex with VerticesOfEdges",
    [IsPolygonalComplex and HasVerticesOfEdges],
    function(complex)
        return __SIMPLICIAL_BoundEntriesOfList(VerticesOfEdges(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "Edges", "VerticesOfEdges");


## FacesOfEdges
InstallMethod( "Faces", "for a polygonal complex with FacesOfEdges",
    [IsPolygonalComplex and HasFacesOfEdges],
    function(complex)
        return Union(FacesOfEdges(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "Faces", "FacesOfEdges");

InstallMethod( "Edges", "for a polygonal complex with FacesOfEdges",
    [IsPolygonalComplex and HasFacesOfEdges],
    function(complex)
        return __SIMPLICIAL_BoundEntriesOfList(FacesOfEdges(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "Edges", "FacesOfEdges");


## VerticesOfFaces
InstallMethod( "VerticesAttributeOfPolygonalComplex", 
    "for a polygonal complex with VerticesOfFaces",
    [IsPolygonalComplex and HasVerticesOfFaces],
    function(complex)
        return Union(VerticesOfFaces(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "VerticesAttributeOfPolygonalComplex", "VerticesOfFaces");

InstallMethod( "Faces", "for a polygonal complex with VerticesOfFaces",
    [IsPolygonalComplex and HasVerticesOfFaces],
    function(complex)
        return __SIMPLICIAL_BoundEntriesOfList(VerticesOfFaces(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "Faces", "VerticesOfFaces");



## EdgesOfFaces
InstallMethod( "Edges", "for a polygonal complex with EdgesOfFaces",
    [IsPolygonalComplex and HasEdgesOfFaces],
    function(complex)
        return Union(EdgesOfFaces(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "Edges", "EdgesOfFaces");

InstallMethod( "Faces", "for a polygonal complex with EdgesOfFaces",
    [IsPolygonalComplex and HasEdgesOfFaces],
    function(complex)
        return __SIMPLICIAL_BoundEntriesOfList(EdgesOfFaces(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "Faces", "EdgesOfFaces");

##
##  Implement "faster" access to *Of*-attributes by adding an argument
##

## EdgesOfVertices
InstallMethod("EdgesOfVertexNC", 
    "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        return EdgesOfVertices(complex)[vertex]    
    end
);
InstallMethod("EdgesOfVertex",
    "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        if not vertex in Vertices(complex) then
            Error("EdgesOfVertex: Given vertex does not lie in complex.");
        fi;
        return EdgesOfVertexNC(complex,vertex);
    end
);

## FacesOfVertices
InstallMethod("FacesOfVertexNC", 
    "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        return FacesOfVertices(complex)[vertex]    
    end
);
InstallMethod("FacesOfVertex",
    "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        if not vertex in Vertices(complex) then
            Error("FacesOfVertex: Given vertex does not lie in complex.");
        fi;
        return FacesOfVertexNC(complex,vertex);
    end
);


## VerticesOfEdges
InstallMethod("VerticesOfEdgeNC", 
    "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        return VerticesOfEdges(complex)[edge]    
    end
);
InstallMethod("VerticesOfEdge",
    "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        if not edge in Edges(complex) then
            Error("VerticesOfEdge: Given edge does not lie in complex.");
        fi;
        return VerticesOfEdgeNC(complex,edge);
    end
);


## FacesOfEdges
InstallMethod("FacesOfEdgeNC", 
    "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        return FacesOfEdges(complex)[edge]    
    end
);
InstallMethod("FacesOfEdge",
    "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        if not edge in Edges(complex) then
            Error("FacesOfEdge: Given edge does not lie in complex.");
        fi;
        return FacesOfEdgeNC(complex,edge);
    end
);


## VerticesOfFaces
InstallMethod("VerticesOfFaceNC", 
    "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
        return VerticesOfFaces(complex)[face]    
    end
);
InstallMethod("VerticesOfFace",
    "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
        if not face in Faces(complex) then
            Error("VerticesOfFace: Given face does not lie in complex.");
        fi;
        return VerticesOfFaceNC(complex,face);
    end
);


## EdgesOfFaces
InstallMethod("EdgesOfFaceNC", 
    "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
        return EdgesOfFaces(complex)[edge]    
    end
);
InstallMethod("EdgesOfFace",
    "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
        if not face in Faces(complex) then
            Error("EdgesOfFace: Given face does not lie in complex.");
        fi;
        return EdgesOfFaceNC(complex,face);
    end
);


##
## Methods to inverse the incidence relation.
## They transform A_Of_B to B_Of_A.
##
BindGlobal( "__SIMPLICIAL_InvertIncidence", 
    function( a_labels, a_of_b, b_labels )
        local b_list, b, a_set, a;

        b_list := [];
        for b in b_labels do
            a_set := [];
            for a in a_labels do
                if b in a_of_b[a] then
                    a_set := Union( a_set, [a] );
                fi;
            od;
            b_list[b] := a_set;
        od;

        return b_list;
    end
);

InstallMethod( EdgesOfVertices,
    "for a polygonal complex that has VerticesOfEdges",
    [IsPolygonalComplex and HasVerticesOfEdges],
    function(complex)
        return __SIMPLICIAL_InvertIncidence( Vertices(complex),
            VerticesOfEdges(complex), Edges(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "EdgesOfVertices", "VerticesOfEdges");


InstallMethod( FacesOfVertices,
    "for a polygonal complex that has VerticesOfFaces",
    [IsPolygonalComplex and HasVerticesOfFaces],
    function(complex)
        return __SIMPLICIAL_InvertIncidence( Vertices(complex),
            VerticesOfFaces(complex), Faces(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "FacesOfVertices", "VerticesOfFaces");


InstallMethod( VerticesOfEdges,
    "for a polygonal complex that has EdgesOfVertices",
    [IsPolygonalComplex and HasEdgesOfVertices],
    function(complex)
        return __SIMPLICIAL_InvertIncidence(Edges(complex),
            EdgesOfVertices(complex), Vertices(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "VerticesOfEdges", "EdgesOfVertices");


InstallMethod( FacesOfEdges,
    "for a polygonal complex that has EdgesOfFaces",
    [IsPolygonalComplex and HasEdgesOfFaces],
    function(complex)
        return __SIMPLICIAL_InvertIncidence( Edges(complex),
            EdgesOfFaces(complex), Faces(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "FacesOfEdges", "EdgesOfFaces");


InstallMethod( VerticesOfFaces,
    "for a polygonal complex that has FacesOfVertices",
    [IsPolygonalComplex and HasFacesOfVertices],
    function(complex)
        return __SIMPLICIAL_InvertIncidence( Faces(complex),
            FacesOfVertices(complex), Vertices(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "VerticesOfFaces", "FacesOfVertices");


InstallMethod( EdgesOfFaces,
    "for a polygonal complex that has FacesOfEdges",
    [IsPolygonalComplex and HasFacesOfEdges],
    function(complex)
        return __SIMPLICIAL_InvertIncidence( Faces(complex),
            FacesOfEdges(complex), Edges(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "EdgesOfFaces", "FacesOfEdges");




##
##          End of basic access (*Of*)
##
##############################################################################

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
## Inclusion in the attribute scheduler
##
__SIMPLICIAL_AddPolygonalAttribute( VerticesAttributeOfPolygonalComplex );
__SIMPLICIAL_AddPolygonalAttribute( Edges );
__SIMPLICIAL_AddPolygonalAttribute( Faces );

##
##              End of labelled access
##
##############################################################################


##############################################################################
##
##          Methods for basic access (*Of*)
##
#TODO explain internal structure of *Of*

##
## Inclusion in the attribute scheduler
##
__SIMPLICIAL_AddPolygonalAttribute( EdgesOfVertices );
__SIMPLICIAL_AddPolygonalAttribute( FacesOfVertices );
__SIMPLICIAL_AddPolygonalAttribute( VerticesOfEdges );
__SIMPLICIAL_AddPolygonalAttribute( FacesOfEdges );
__SIMPLICIAL_AddPolygonalAttribute( VerticesOfFaces );
__SIMPLICIAL_AddPolygonalAttribute( EdgesOfFaces );

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
## Methods to combine a_of_b and b_of_c to a_of_c (transitivity).
##
BindGlobal( "__SIMPLICIAL_TransitiveIncidence", 
    function( a_labels, a_of_b, b_labels, b_of_c, c_labels )
        local c, a_of_c, a_in_b, b_in_c;

        a_of_c := [];
        for c in c_labels do
            b_in_c := b_of_c[c];
            a_in_b := List( b_in_c, x -> a_of_b[c] );
            a_of_c[c] := Union(a_in_b);
        od;

        return a_of_c;
    end
);

InstallMethod( VerticesOfFaces,
    "for a polygonal complex with VerticesOfEdges and EdgesOfFaces",
    [IsPolygonalComplex and HasVerticesOfEdges and HasEdgesOfFaces],
    function(complex)
        return __SIMPLICIAL_TransitiveIncidence( Vertices(complex),
            VerticesOfEdges(complex), Edges(complex), EdgesOfFaces(complex),
            Faces(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "VerticesOfFaces", ["VerticesOfEdges", "EdgesOfFaces"]);

InstallMethod( FacesOfVertices,
    "for a polygonal complex with FacesOfEdges and EdgesOfVertices",
    [IsPolygonalComplex and HasFacesOfEdges and HasEdgesOfVertices],
    function(complex)
        return __SIMPLICIAL_TransitiveIncidence( Faces(complex),
            FacesOfEdges(complex), Edges(complex), EdgesOfVertices(complex),
            Vertices(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "FacesOfVertices", ["FacesOfEdges", "EdgesOfVertices"]);



##
##          End of basic access (*Of*)
##
##############################################################################




##############################################################################
##
##          Face-induced order of vertices/edges
##
__SIMPLICIAL_AddPolygonalAttribute(CyclicVertexOrderOfFacesAsPerm);
__SIMPLICIAL_AddPolygonalAttribute(CyclicVertexOrderOfFacesAsList);
__SIMPLICIAL_AddPolygonalAttribute(CyclicEdgeOrderOfFacesAsPerm);
__SIMPLICIAL_AddPolygonalAttribute(CyclicEdgeOrderOfFacesAsList);

# the wrappers
InstallMethod( CyclicVertexOrderOfFaces, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return CyclicVertexOrderOfFacesAsPerm(complex);
    end
);
InstallMethod( CyclicVertexOrderOfFace, 
    "for a polygonal complex and a face (positive integer)",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
        return CyclicVertexOrderOfFace(complex,face);
    end
);
InstallMethod( CyclicVertexOrderOfFaceNC,
    "for a polygonal complex and a face (positive integer)",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
        return CyclicVertexOrderOfFaceAsPermNC(complex, face);
    end
);

InstallMethod( CyclicEdgeOrderOfFaces, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return CyclicEdgeOrderOfFacesAsPerm(complex);
    end
);
InstallMethod( CyclicEdgeOrderOfFace, 
    "for a polygonal complex and a face (positive integer)",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
        return CyclicEdgeOrderOfFace(complex,face);
    end
);
InstallMethod( CyclicEdgeOrderOfFaceNC,
    "for a polygonal complex and a face (positive integer)",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
        return CyclicEdgeOrderOfFaceAsPermNC(complex, face);
    end
);

# write the general methods to compute the cyclic lists
InstallMethod( "CyclicVertexOrderOfFacesAsList",
    "for a polygonal complex with faces, verticesOfFaces, edgesOfFaces, edgesOfVertices and verticesOfEdges",
    [IsPolygonalComplex and HasFaces and HasVerticesOfFaces and 
        HasEdgesOfFaces and HasEdgesOfVertices and HasVerticesOfEdges],
    function(complex)
        local cylicList, f, localVertices, localCycle, adEdges, startVert,
            lastVert, finEdge, nextEdge, lastEdge;

        cylicList := [];
        for f in Faces(complex) do
            localVertices := VerticesOfFaces(complex)[f];
            startVert := Minimum(localVertices);
            adEdges := Intersection( EdgesOfFaces(complex)[f], 
                        EdgesOfVertices(complex)[startVert );
            adVertices := List( adEdges, e -> 
                    OtherVertexOfEdgeNC(complex,startVert,e) );
            Assert(1, Size(adVertices)<>2);
            Assert(1, adVertices[1] <> adVertices[2]);

            if adVertices[1] < adVertices[2] then
                localCycle := [ startVert, adVertices[1] ];
                lastEdge := adEdges[1];
                finEdge := adEdges[2];
            else
                localCycle := [ startVert, adVertices[2] ];
                lastEdge := adEdges[2];
                finEdge := adEdges[1];
            fi;

            while true do
                # find next edge
                lastVert := localCycle[Size(localCycle)];
                nextEdge := OtherEdgeOfVertexInFaceNC( complex, lastVert, lastEdge, f );
                if nextEdge = finEdge then
                    break;
                fi;

                lastEdge := nextEdge;
                Add( localCycle, OtherVertexOfEdgeNC(complex,lastVert,nextEdge) );
            od;

            cylicList[f] := localCycle;
        od;

        return cylicList;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, 
    "CyclicVertexOrderOfFacesAsList", ["Faces", "VerticesOfFaces", "EdgesOfFaces", 
        "VerticesOfEdges", "EdgesOfVertices"] );
InstallMethod( CyclicVertexOrderOfFacesAsList, 
    "for a triangular complex with VerticesOfFaces",
    [IsTriangularComplex and HasVerticesOfFaces],
    function(complex)
        return VerticesOfFaces(complex);
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "CyclicVertexOrderOfFacesAsList", ["IsTriangularComplex", "VerticesOfFaces"]);
    #TODO is this correct?


InstallMethod( "CyclicEdgeOrderOfFacesAsList",
    "for a polygonal complex with faces, verticesOfFaces, edgesOfFaces, edgesOfVertices and verticesOfEdges",
    [IsPolygonalComplex and HasFaces and HasVerticesOfFaces and 
        HasEdgesOfFaces and HasEdgesOfVertices and HasVerticesOfEdges],
    function(complex)
        local cylicList, f, localEdges, localCycle, adVertices, startEdge,
            lastEdge, finVertex, nextVertex, lastVertex;

        cylicList := [];
        for f in Faces(complex) do
            localEdges := EdgesOfFaces(complex)[f];
            startEdge := Minimum(localEdges);
            adVertices := VerticesOfEdges(complex)[startEdge];
            adEdges := List( adVertices, v ->
                    OtherEdgeOfVertexInFaceNC(complex, v, startEdge, f) );
                    OtherVertexOfEdgeNC(complex,startVert,e) );
            Assert(1, Size(adEdges)<>2);
            Assert(1, adEdges[1] <> adEdges[2]);

            if adEdges[1] < adEdges[2] then
                localCycle := [ startEdge, adEdges[1] ];
                lastVertex := adVertices[1];
                finVertex := adVertices[2];
            else
                localCycle := [ startEdge, adEdges[2] ];
                lastVertex := adVertices[2];
                finVertex := adVertices[1];
            fi;

            while true do
                # find next edge
                lastEdge := localCycle[Size(localCycle)];
                nextVertex := OtherVertexOfEdgeNC( complex, lastVertex, lastEdge, f );
                if nextVertex = finVertex then
                    break;
                fi;

                lastVertex := nextVertex;
                Add( localCycle, OtherEdgeOfVertexInFaceNC(complex,nextVertex,lastEdge,f) );
            od;

            cylicList[f] := localCycle;
        od;

        return cylicList;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, 
    "CyclicEdgeOrderOfFacesAsList", ["Faces", "VerticesOfFaces", "EdgesOfFaces", 
        "VerticesOfEdges", "EdgesOfVertices"] );
InstallMethod( CyclicEdgeOrderOfFacesAsList, 
    "for a triangular complex with EdgesOfFaces",
    [IsTriangularComplex and HasEdgesOfFaces],
    function(complex)
        return EdgesOfFaces(complex);
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "CyclicEdgeOrderOfFacesAsList", ["IsTriangularComplex", "EdgesOfFaces"]);
    #TODO is this correct?


##
##	To perform the conversion between VerticesAsList and EdgesAsList we
##	implement a global function (as both conversions are identical from
##	the perspective of incidence geometry). We start with
##		a list of lists (in terms of elements A)
##		an index for the list (in our case that will be the faces)
##		a conversion of A in terms of B
##		a list of sets of all elements of B that are possible (for a given face)
##
BindGlobal( "__SIMPLICIAL_ConversionListsVerticesEdges", 
    function( listOfLists, listIndex, conversion, possibleNewElements )
	local newListOfLists, i, oldList, newList, firstEl, secondEl, 
            intersection, j, currentEl, nextEl;

        if listOfLists = fail then
            return fail;
        fi;

	newListOfLists := [];
	# Iterate over the list index
	for i in listIndex do
		# We want to convert the elements of listOfLists (the 'old lists')
		# into the elements of newListOfLists (the 'new lists')
		oldList := listOfLists[i];
		newList := [];

		# Intersect first and last element of the oldList to obtain the first
		# element of the newList
		firstEl := Set( conversion[ oldList[1] ] );
		secondEl := Set( conversion[ oldList[ Length(oldList) ] ] );
		intersection := Intersection( firstEl, secondEl, 
                        possibleNewElements[i] );
                Assert( 1, Length(intersection)=1 );
		newList[1] := intersection[1];

		# Now we continue for all other elements
		for j in [2..Length(oldList)] do
			currentEl := Set( conversion[ oldList[j-1] ] );
			nextEl := Set( conversion[ oldList[j] ] );
			intersection := Intersection( currentEl, nextEl, 
					        possibleNewElements[i] );
                        Assert(1, Length(intersection)=1);
			newList[j] := intersection[1];
		od;

		newListOfLists[i] := newList;
	od;

	return newListOfLists;
    end
);
InstallMethod( CyclicVertexOrderOfFacesAsList, 
    "for a polygonal complex that has CyclicEdgeOrderOfFacesAsList, Faces, VerticesOfEdges and VerticesOfFaces",
    [IsPolygonalComplex and HasCyclicEdgeOrderOfFacesAsList and HasFaces and
        HasVerticesOfEdges and HasVerticesOfFaces],
    function(complex)
        return __SIMPLICIAL_ConversionListsVerticesEdges(
            CyclicEdgeOrderOfFacesAsList(complex),
            Faces(complex),
            VerticesOfEdges(complex),
            VerticesOfFaces(complex)
        )
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "CyclicVertexOrderOfFacesAsList", ["CyclicEdgeOrderOfFacesAsList", 
        "Faces", "VerticesOfEdges", "VerticesOfFaces"]);
InstallMethod( CyclicEdgeOrderOfFacesAsList, 
    "for a polygonal complex that has CyclicVertexOrderOfFacesAsList, Faces, EdgesOfVertices and EdgesOfFaces",
    [IsPolygonalComplex and HasCyclicVertexOrderOfFacesAsList and HasFaces and
        HasEdgesOfVertices and HasEdgesOfFaces],
    function(complex)
        return __SIMPLICIAL_ConversionListsVerticesEdges(
            CyclicVertexOrderOfFacesAsList(complex),
            Faces(complex),
            EdgesOfVertices(complex),
            EdgesOfFaces(complex)
        )
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "CyclicEdgeOrderOfFacesAsList", ["CyclicVertexOrderOfFacesAsList", 
        "Faces", "EdgesOfVertices", "EdgesOfFaces"]);

#
# conversion between permutation and list representation
# 



#
# convenience methods
#



#
# incidences from cyclic order
# 



##
##          End of face-induced order
##
##############################################################################




##############################################################################
##
##      Edge-Face-Paths around vertices
##



##
##          End of edge-face-paths
##
##############################################################################

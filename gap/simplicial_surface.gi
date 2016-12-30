##############################################################################
##
#W  simplicial_surface.gi          Simplicial               Alice Niemeyer
#W                                                        Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Alice Niemeyer, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##
##  The functions in this file compute with simplicial surfaces.
##
##

#############################################################################
##
#!	@Description
#!	This function returns the number of vertices.
#!	@Returns an integer
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( NrOfVertices, "for a simplicial surfaces",
	[ IsSimplicialSurface ],
	function(simpsurf)
		return Length( Vertices(simpsurf) );
	end
);

#############################################################################
##
#!	@Description
#!	This function returns the number of edges.
#!	@Returns an integer
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( NrOfEdges, "for a simplicial surfaces",
	[ IsSimplicialSurface ],
	function(simpsurf)
		return Length( Edges(simpsurf) );
	end
);

#############################################################################
##
#!	@Description
#!	This function returns the number of faces.
#!	@Returns an integer
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( NrOfFaces, "for a simplicial surfaces",
	[ IsSimplicialSurface ],
	function(simpsurf)
		return Length( Faces(simpsurf) );
	end
);

##
##	It is pretty annoying to implement all of the *By*-methods. Furthermore
##	it is not necessary to implement to many of them manually - the rest just
##	falls into place. For this reason this function exists - it inverts an
##	incidence relation.
##
##	Given are the numbers of edges and faces, together with the relation
##	facesByEdges. It returns the relation edgesByFaces. (The names are used
##	only for illustration.)
##
InvertIncidence := function( edgeNr, faceNr, facesByEdges )
	local edgeList, edge, faceSet, face;

	edgeList := [];
	for edge in edgeNr do
		faceSet := [];
		for face in faceNr do
			if edge in facesByEdges[face] then
				faceSet := Union( faceSet, [face] );
			fi;
		od;
		edgeList[edge] := faceSet;
	od;

	return edgeList;
end;

#############################################################################
##
##
#!  @Description
#!  This function computes the Euler characteristic of a simplicial surface.
#!  The Euler characteristic is |V| - |E| + |F|, where |V| is the number of
#!  vertices, |E| is the number of edges and |F| is the number of faces.
#!  @Returns an integer, which is the Euler characteristic.
#!  @Arguments <simpsurf>, a simplicial surface object as created 
#!  by WildSimplicialSurface
#!
InstallMethod( EulerCharacteristic, "for a simplicial surface",
	[IsSimplicialSurface ],
function (simpsurf)

    local chi;

    if not IsSimplicialSurface(simpsurf) then
        Error("usage: EulerCharacteristic(simpsurf");
        return fail;
    fi;

    if IsBound(simpsurf!.EulerCharacteristic) then
        return simpsurf!.EulerCharacteristic;
    fi;

    chi :=    NrOfVertices(simpsurf)  # V
            - NrOfEdges(simpsurf)     # -E
            + NrOfFaces(simpsurf);    # +F


     simpsurf!.EulerCharacteristic := chi;

     return chi;

end);

#############################################################################
##
#!  @Description
#!	This function returns a list of integers (with holes). For each vertex-
#!	number it contains the number of faces which are incident to that vertex
#!	(the degree of the vertex).
#!  @Returns a list of integers
#!  @Arguments a simplicial surface object simpsurf
#!
InstallMethod( UnsortedDegrees, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local verticesByFaces;

		if IsBound( simpsurf!.unsortedDegrees ) then
			return simpsurf!.unsortedDegrees;
		fi;

		verticesByFaces := VerticesByFaces( simpsurf );
		simpsurf!.unsortedDegrees := List( verticesByFaces, i->Length(i) );
		return simpsurf!.unsortedDegrees;
	end
);

#############################################################################
##
#!  @Description
#!	This function returns a dense sorted list of integers that contains the 
#!	degrees of the vertices (with repetitions)
#!  @Returns a dense sorted list of integers
#!  @Arguments a simplicial surface object simpsurf
#!
InstallMethod( SortedDegrees, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local compact;

		if IsBound( simpsurf!.sortedDegrees ) then
			return simpsurf!.sortedDegrees;
		fi;

		compact := Compacted( UnsortedDegrees( simpsurf ) );
		Sort( compact );
		simpsurf!.sortedDegrees := compact;
		return compact;
	end;
 );

###############################################################################
##
#!  @Description
#!  This function returns the face-anomaly-classes of a simplicial surface.
#!	Two faces are in the same face-anomaly-class if they contain the same
#!	vertices.
#!  @Returns The face-anomaly-classes (as a list of sets)
#!  @Arguments <simpsurf> a simplicial surface
#!
InstallMethod( FaceAnomalyClasses, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local facesByVertices, classes, i, found, cl, j;

		if IsBound( simpsurf!.faceAnomalyClasses ) then
			return simpsurf!.faceAnomalyClasses;
		fi;

		facesByVertices := FacesByVertices(simpsurf);
		classes := [];

		for i in [1..NrOfFaces(simpsurf)] do
			found := false;
			for j in [1..Length(classes)] do
				cl := classes[j];
				if Set( facesByVertices[i] ) = Set( facesByVertices[ cl[1] ] ) then
					classes[j] := Union( cl, [i] );
					found := true;
					break;
				fi;
			od;
			if not found then
				Append( classes, [ [i] ] );
			fi;
		od;

		simpsurf!.faceAnomalyClasses := classes;
		return simpsurf!.faceAnomalyClasses;
	end;
 );

#############################################################################
##
#!	@Description
#!	This function checks if a simplicial surface is connected.
#!	@Returns true if connected, false otherwise
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( IsConnected, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local faces, faceList, points, change, faceNr;

		if IsBound( simpsurf!.isConnected ) then 
			return simpsurf!.isConnected;
		fi;

		faceList := FacesByVertices(simpsurf);
		faces := Faces(simpsurf){ [2..NrOfFaces(simpsurf)] };	# all except one
		points := Set( faceList[ Faces(simpsurf)[1] ] );	# vertices of the first face

		change := true;
		while change do
			change := false;

			for faceNr in faces do
				if Intersection( points, faceList[faceNr] ) <> [] then
					change := true;
					points := Union( points, faceList[faceNr] );
					faces := Difference( faces, [faceNr] );
				fi;
			od;
		od;

		simpsurf!.isConnected := IsEmpty( faces );

		return simpsurf!.isConnected;
end
);

#############################################################################
##
#!  @Description
#!  Return the coloured incidence graph of a simplicial surface.
#!	The vertex set of this graph consists of all vertices, edges and faces
#!	of the simplicial surface. All vertices, all edges and all faces
#!	are in individual colour classes.
#!	The edges are given by vertex-edge and edge-face pairs.
#!  @Returns the coloured incidence graph
#!  @Arguments a simplicial surface object simpsurf
#!
InstallMethod( IncidenceGraph, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local graph, vertices, edges, faces, names, colours, incidence, 
			trivialAction;

		if IsBound( simpsurf!.incidenceGraph ) then
			return simpsurf!.incidenceGraph;
		fi;

		vertices := List( Vertices(simpsurf), i -> [0,i] );
		edges := List( Edges(simpsurf), i -> [1,i] );
		faces := List( Faces(simpsurf), i -> [2,i] );

		names := Union( vertices, edges, faces);
		colours := [vertices,edges, faces];
		incidence := function(x,y)
			if x[1] = 0 and y[1] = 1 then
				return x[2] in EdgesByVertices(simpsurf)[y[2]];
			elif x[1] = 1 and y[1] = 0 then
				return y[2] in EdgesByVertices(simpsurf)[x[2]];

			elif x[1] = 1 and y[1] = 2 then
				return x[2] in FacesByEdges(simpsurf)[y[2]];
			elif x[1] = 2 and y[1] = 1 then
				return y[2] in FacesByEdges(simpsurf)[x[2]];

			else
				return false;
			fi;
		end;

		trivialAction := function( pnt, g )
			return pnt;
		end;

		graph := Graph( Group( () ), names, trivialAction, incidence );
		graph!.colourClasses := colours;

		simpsurf!.incidenceGraph := graph;
		return graph;
end
);


#############################################################################
##
#!  @Description
#!  Check if two simplicial surfaces are isomorphic. This method only checks
#!	if they are isomorphic with respect to the incidence relation. It does
#!	not check if additional structure like a wild coloring is isomorphic (or
#!	even present).
#!  @Returns true or false
#!  @Arguments <s1>, <s2>, two simplicial surface objects
#!
##
InstallMethod( IsIsomorphic, "for two simplicial surfaces",
	[IsSimplicialSurface, IsSimplicialSurface],
	function( s1,s2)
		local graph1, graph2;

		graph1 := IncidenceGraph(s1);
		graph2 := IncidenceGraph(s2);
		return IsIsomorphicGraph(graph1,graph2);
	end
);


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

#############################################################################
##
##				Start of *By*-methods
##
##	It is pretty annoying to implement all of the *By*-methods for each
##	individual representation. As they are interdependent, this is also
##	redundant. Therefore we collect some methods here that allow us to only
##	implement a minimal set of these methods. We rely on the fact that we
##	consider the *By*-objects as attributes which have a corresponding filter
##	which makes it known which of those are already known.
##
##	There are exactly four cases in which we know every information from
##	two of those values:
##		facesByEdges and EdgesByVertices
##		facesByEdges and VerticesByEdges
##		EdgesByFaces and EdgesByVertices
##		EdgesByFaces and VerticesByEdges
##	We will start with an inversion and a transitivity method. These two are
##	sufficient to generate every other combination in at most two steps. Since
##	GAP can't do more than one step, we have to help it a bit at the end...
##
##
##	At first we implement the inversion of an incidence relation. For example
##	we know facesByEdges but want to know edgesByFaces. As this inversion is
##	always the same we implement it in general.
##	Given are the numbers of edges and faces, together with the relation
##	facesByEdges. It returns the relation edgesByFaces. (The names are used
##	only for illustration.)
_SIMPLICIAL_InvertIncidence := function( faceNr, facesByEdges, edgeNr )
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
##
##	With this method we can write inversion methods for all six cases.
InstallMethod( VerticesByEdges, [IsSimplicialSurface and HasEdgesByVertices ],
	function( simpsurf )
		return _SIMPLICIAL_InvertIncidence( Edges(simpsurf),
				EdgesByVertices(simpsurf), Vertices(simpsurf) );
	end
);
InstallMethod( VerticesByFaces, [IsSimplicialSurface and HasFacesByVertices ],
	function( simpsurf )
		return _SIMPLICIAL_InvertIncidence( Faces(simpsurf),
				FacesByVertices(simpsurf), Vertices(simpsurf) );
	end
);
InstallMethod( EdgesByVertices, [IsSimplicialSurface and HasVerticesByEdges ],
	function( simpsurf )
		return _SIMPLICIAL_InvertIncidence( Vertices(simpsurf),
				VerticesByEdges(simpsurf), Edges(simpsurf) );
	end
);
InstallMethod( EdgesByFaces, [IsSimplicialSurface and HasFacesByEdges ],
	function( simpsurf )
		return _SIMPLICIAL_InvertIncidence( Faces(simpsurf),
				FacesByEdges(simpsurf), Edges(simpsurf) );
	end
);
InstallMethod( FacesByVertices, [IsSimplicialSurface and HasVerticesByFaces ],
	function( simpsurf )
		return _SIMPLICIAL_InvertIncidence( Vertices(simpsurf),
				VerticesByFaces(simpsurf), Faces(simpsurf) );
	end
);
InstallMethod( FacesByEdges, [IsSimplicialSurface and HasEdgesByFaces ],
	function( simpsurf )
		return _SIMPLICIAL_InvertIncidence( Edges(simpsurf),
				EdgesByFaces(simpsurf), Faces(simpsurf) );
	end
);
##
##	Next we consider the case of transitivity: From FacesByEdges and 
##	EdgesByVertices we can deduce FacesByVertices
_SIMPLICIAL_TransitiveIncidence := function( faceNr, facesByEdges, edgeNr,
												edgesByVertices, vertexNr )
	local face, facesByVertices, edgesInFace, verticesInEdges;

	facesByVertices := [];
	for face in faceNr do
		edgesInFace := facesByEdges[face];
		verticesInEdges := List( edgesInFace, e -> edgesByVertices[e] );
		faceByVertices[face] := Union( verticesInEdges );
	od;

	return facesByVertices;
end;
##
InstallMethod( FacesByVertices, [IsSimplicialSurface and HasFacesByEdges and
										HasEdgesByVertices ],
	function( simpsurf )
		return _SIMPLICIAL_TransitiveIncidence( Faces(simpsurf),
			FacesByEdges(simpsurf), Edges(simpsurf),
			EdgesByVertices(simpsurf), Vertices(simpsurf) );
	end
);
InstallMethod( VerticesByFaces, [IsSimplicialSurface and HasVerticesByEdges and
										HasEdgesByFaces ],
	function( simpsurf )
		return _SIMPLICIAL_TransitiveIncidence( Vertices(simpsurf),
			VerticesByEdges(simpsurf), Edges(simpsurf),
			EdgesByFaces(simpsurf), Faces(simpsurf) );
	end
);
##
##	Normally we would be finished at this point. But the method selection of
##	GAP is not so intelligent to check for attributes transitively (it only
##	checks if an attribute is set, not if it could be set). Maybe there is an
##	elegant solution to this that I don't know but I will just brute force the
##	solution here by implementing the missing methods and calling the necessary
##	computation manually.
##
##	If both incidences go in the same direction (e.g. FacesByEdges and
##	EdgesByVertices) we get two inverses and one transitive in one step. The
##	opposing transitive is missing. In comparing both ways to compute it, first
##	transitive and then inverting is shorter than twise inverting and then using
##	the transitive.
InstallMethod( VerticesByFaces, [IsSimplicialSurface and HasEdgesByVertices and
											HasFacesByEdges ],
	function( simpsurf )
		FacesByVertices(simpsurf);
		TryNextMethod();
	end
);
InstallMethod( FacesByVertices, [IsSimplicialSurface and HadVerticesByEdges and
											HasEdgesByFaces ],
	function( simpsurf )
		VerticesByFaces( simpsurf );
		TryNextMethod();
	end
);
##
##	If the two incidences don't go in the same direction, things become more
##	complicated. Assume FacesByEdges and VerticesByEdges. We get the inverses
##	directly but we are missing FacesByVertices and VerticesByFaces. To get
##	those we first have to invert one of them and then use transitive.
InstallMethod( VerticesByFaces, [IsSimplicialSurface and FacesByEdges and
											VerticesByEdges ],
	function( simpsurf )
		EdgesByFaces( simpsurf );
		TryNextMethod();
	end
);
InstallMethod( FacesByVertices, [IsSimplicialSurface and FacesByEdges and
											VerticesByEdges ],
	function( simpsurf )
		EdgesByVertices( simpsurf );
		TryNextMethod();
	end
);
##	case EdgesByFaces and EdgesByVertices is similar
InstallMethod( VerticesByFaces, [IsSimplicialSurface and EdgesByFaces and
											EdgesByVertices ],
	function( simpsurf )
		VerticesByEdges( simpsurf );
		TryNextMethod();
	end
);
InstallMethod( FacesByVertices, [IsSimplicialSurface and EdgesByFaces and
											EdgesByVertices ],
	function( simpsurf )
		FacesByEdges( simpsurf );
		TryNextMethod();
	end
);
##
##						End of *By*-Methods
##
#############################################################################

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

		chi := NrOfVertices(simpsurf)  # V
				- NrOfEdges(simpsurf)     # -E
				+ NrOfFaces(simpsurf);    # +F

		return chi;
	end
);

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

		verticesByFaces := VerticesByFaces( simpsurf );
		return List( verticesByFaces, i->Length(i) );
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

		return classes;
	end;
 );

###############################################################################
##
#!  @Description
#!  This function checks whether the simplicial surface is an actual surface.
#!  @Returns true if it is a surface and false else.
#!  @Arguments <simpsurf> a simplicial surface
#!
InstallMethod( IsActualSurface, "for a simplicial surface",
	[IsSimplicialSurface],
	function( simpsurf )
		local face, edgeByFaces, check;

		check := true;
		edgeByFaces := EdgesByFaces( simpsurf );
		check := Filtered( edgeByFaces, i -> Length(i) > 2 );
	
		return IsEmpty(check);
	end
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

		return IsEmpty( faces );
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


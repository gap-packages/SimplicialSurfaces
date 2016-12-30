##############################################################################
##
#W  simplicial_surface.gd     SimplicialSurfaces             Alice Niemeyer
#W														Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Alice Niemeyer, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the declaration part for the wild simplicial surfaces
##	of the Simplicial package.
##
##	A SimplicialSurface consists of vertices, edges and faces. Each of those
##	is enumerated by numbers (not necessarily consecutively). Furthermore we
##	have an incidence relation between them.
##	Sometimes we may impose an additional structure on this surface, by
##	partitioning the set of edges into three subsets such that each face (which
##	we assume to be triangular) is bordered by all three subsets. This allows
##	us to define an involution for each subset. These three involutions are
##	in many cases sufficient to reproduce to original surface.
##

DeclareInfoClass( "InfoSimplicial" );
SetInfoLevel(InfoSimplicial,1);

##
##	Define a new family for simplicial surfaces. The family defines a necessary
##	condition that has to be fulfilled for objects to be equal to each other.
##
SimplicialSurfaceFamily := 
    NewFamily("SimplicialSurfaceFamily",  IsObject, IsComponentObjectRep);

##
##	Categories are used to determine which methods are applicable for a
##	certain object.
##
DeclareCategory( "IsSimplicialSurface", IsComponentObjectRep );

##
##	The property IsActualSurface is true if the SimplicialSurface object
##	actually represents a surface (it might otherwise happen that one edge
##	belongs to three different faces).
##
DeclareProperty( "IsActualSurface", IsSimplicialSurface );

##
##	The property IsWildColored is true if the SimplicialSurface admits a
##	wild coloring. As a precondition for this the SimplicialSurface has to be
##	an actual surface.
##
DeclareProperty( "IsWildColored", IsActualSurface );


#############################################################################
##
##
#!  @Section Basic functions for Simplicial Surfaces
#!
#!
#!


#############################################################################
##
#!	@Description
#!	This function returns the numbers of the vertices as a dense list.
#!	@Returns a dense list of integers
#!	@Arguments a simplicial surface object simpsurf
#!
DeclareOperation( "Vertices", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the number of vertices.
#!	@Returns an integer
#!	@Arguments a simplicial surface object simpsurf
#!
DeclareOperation( "NrOfVertices", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the vertices in terms of the edges. It return a list
#!	with holes and at the position of each vertex-number there is a list of
#!	all edges that are incident to that vertex. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareOperation( "VerticesByEdges", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the vertices in terms of the faces. It return a list
#!	with holes and at the position of each vertex-number there is a list of
#!	all faces that are incident to that vertex. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareOperation( "VerticesByFaces", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the numbers of the edges as a dense list.
#!	@Returns a dense list of integers
#!	@Arguments a simplicial surface object simpsurf
#!
DeclareOperation( "Edges", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the number of edges.
#!	@Returns an integer
#!	@Arguments a simplicial surface object simpsurf
#!
DeclareOperation( "NrOfEdges", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the edges in terms of the vertices. It return a list
#!	with holes and at the position of each edge-number there is a list of
#!	all vertices that are incident to that edge. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareOperation( "EdgesByVertices", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the edges in terms of the faces. It return a list
#!	with holes and at the position of each edge-number there is a list of
#!	all faces that are incident to that edge. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareOperation( "EdgesByFaces", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the numbers of the faces as a dense list.
#!	@Returns a dense list of integers
#!	@Arguments a simplicial surface object simpsurf
#!
DeclareOperation( "Faces", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the number of faces.
#!	@Returns an integer
#!	@Arguments a simplicial surface object simpsurf
#!
DeclareOperation( "NrOfFaces", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the faces in terms of the vertices. It return a list
#!	with holes and at the position of each face-number there is a list of
#!	all vertices that are incident to that face. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareOperation( "FacesByVertices", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the faces in terms of the edges. It return a list
#!	with holes and at the position of each face-number there is a list of
#!	all edges that are incident to that face. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareOperation( "FacesByEdges", [IsSimplicialSurface] );


#############################################################################
##
##
#!  @Section Properties of Simplicial Surfaces
#!
#!
#!


#############################################################################
##
#!	@Description
#!	This function checks if a simplicial surface is orientable. This is only
#!	possible if it is an actual surface.
#!	@Returns true if orientable, false otherwise
#!	@Arguments a simplicial surface object simpsurf
#!
DeclareOperation( "IsOrientable", [IsSimplicialSurface and IsActualSurface] );

#############################################################################
##
#!	@Description
#!	This function checks if a simplicial surface is connected.
#!	@Returns true if connected, false otherwise
#!	@Arguments a simplicial surface object simpsurf
#!
DeclareOperation( "IsConnected", [IsSimplicialSurface] );

#############################################################################
##
#!  @Description
#!  This function computes the Euler characteristic of a simplicial surface.
#!  The Euler characteristic is |V| - |E| + |F|, where |V| is the number of
#!  vertices, |E| is the number of edges and |F| is the number of faces.
#!  @Returns an integer, the Euler characteristic.
#!  @Arguments a simplicial surface object simpsurf
#!
DeclareOperation( "EulerCharacteristic", [IsSimplicialSurface] );

#############################################################################
##
#!  @Description
#!	This function returns a list of integers (with holes). For each vertex-
#!	number it contains the number of faces which are incident to that vertex
#!	(the degree of the vertex). All other positions are unbounded.
#!  @Returns a list of integers
#!  @Arguments a simplicial surface object simpsurf
#!
DeclareOperation( "UnsortedDegrees", [IsSimplicialSurface] );

#############################################################################
##
#!  @Description
#!	This function returns a dense sorted list of integers that contains the 
#!	degrees of the vertices (with repetitions)
#!  @Returns a dense sorted list of integers
#!  @Arguments a simplicial surface object simpsurf
#!
DeclareOperation( "SortedDegrees", [IsSimplicialSurface] );

###############################################################################
##
#!  @Description
#!  This function returns the face-anomaly-classes of a simplicial surface.
#!	Two faces are in the same face-anomaly-class if they contain the same
#!	vertices.
#!  @Returns The face-anomaly-classes (as a list of sets)
#!  @Arguments <simpsurf> a simplicial surface
#!
DeclareOperation( "FaceAnomalyClasses", [IsSimplicialSurface] );



#############################################################################
##
##
#!  @Section Functions for Simplicial Surfaces
#!
#!
#!

#############################################################################
##
#!	@Description
#!	This function removes all ears of the simplicial surface and returns
#!	the resulting surface.
#!	@Returns a simplicial surface object
#!	@Arguments a simplicial surface object simpsurf
#!
DeclareOperation( "SnippOffEars", [IsSimplicialSurface] );

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
DeclareOperation( "IncidenceGraph", [IsSimplicialSurface] );

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
DeclareOperation( "IsIsomorphic", [IsSimplicialSurface, IsSimplicialSurface] );


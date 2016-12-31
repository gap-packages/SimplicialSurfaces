##############################################################################
##
#W  simplicial_surface.gd     SimplicialSurfaces             Alice Niemeyer
#W														Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Alice Niemeyer, Markus Baumeister, 
#Y  Lehrstuhl B für Mathematik, RWTH Aachen
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
##	Categories are used to determine which methods are applicable for a
##	certain object. The category for simplicial surfaces should be able to
##	save attributes once they are computed (this includes properties) and
##	consists of components.
##
DeclareCategory( "IsSimplicialSurface",
			IsComponentObjectRep and IsAttributeStoringRep );

##
##	Define a new family for simplicial surfaces. The family defines a necessary
##	condition that has to be fulfilled for objects to be equal to each other.
##	The argument IsSimplicialSurface guarantees that only objects that lie in
##	this category can be part of the family.
##
SimplicialSurfaceFamily := 
    NewFamily("SimplicialSurfaceFamily",  IsObject, IsSimplicialSurface);

#############################################################################
##
##
#!  @Section Attributes and properties of Simplicial Surfaces
#!
#!

#! @Description
#! Returns the numbers of the vertices as a set.
#! @Arguments a simplicial surface
#! @Returns a dense list of integers
DeclareAttribute( "Vertices", IsSimplicialSurface );

#! @Description
#! Returns the numbers of the edges as a set.
#! @Arguments a simplicial surface
#! @Returns a dense list of integers
DeclareAttribute( "Edges", IsSimplicialSurface );

#! @Description
#! Returns the numbers of the faces as a set.
#! @Arguments a simplicial surface
#! @Returns a dense list of integers
DeclareAttribute( "Faces", IsSimplicialSurface );


#! @Description
#! Returns the number of vertices.
#! @Arguments a simplicial surface
#! @Returns an integers
DeclareAttribute( "NrOfVertices", IsSimplicialSurface );

#! @Description
#! Returns the number of edges.
#! @Arguments a simplicial surface
#! @Returns an integers
DeclareAttribute( "NrOfEdges", IsSimplicialSurface );

#! @Description
#! Returns the number of faces.
#! @Arguments a simplicial surface
#! @Returns an integers
DeclareAttribute( "NrOfFaces", IsSimplicialSurface );


#!	@Description
#!	Return the vertices in terms of the edges. Return a list
#!	with holes and at the position of each vertex-number is a set of
#!	all edges that are incident to that vertex. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareAttribute( "VerticesByEdges", IsSimplicialSurface);

#!	@Description
#!	Return the vertices in terms of the faces. Return a list
#!	with holes and at the position of each vertex-number is a set of
#!	all faces that are incident to that vertex. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareAttribute( "VerticesByFaces", IsSimplicialSurface);

#!	@Description
#!	Return the edges in terms of the vertices. Return a list
#!	with holes and at the position of each edge-number is a set of
#!	all vertices that are incident to that edge. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareAttribute( "EdgesByVertices", IsSimplicialSurface);

#!	@Description
#!	Return the edges in terms of the faces. Return a list
#!	with holes and at the position of each edge-number is a set of
#!	all faces that are incident to that edge. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareAttribute( "EdgesByFaces", IsSimplicialSurface);

#!	@Description
#!	Return the faces in terms of the vertices. Return a list
#!	with holes and at the position of each face-number is a set of
#!	all vertices that are incident to that face. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareAttribute( "FacesByVertices", IsSimplicialSurface);

#!	@Description
#!	Return the faces in terms of the edges. Return a list
#!	with holes and at the position of each face-number is a set of
#!	all edges that are incident to that face. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareAttribute( "FacesByEdges", IsSimplicialSurface);


#!	@Description
#!	The property IsActualSurface is true if the SimplicialSurface object
#!	actually represents a surface (it might otherwise happen that one edge
#!	belongs to three different faces).
#!	@Arguments a simplicial surface
#!	@Returns true if it is a surface and false else.
DeclareProperty( "IsActualSurface", IsSimplicialSurface );

##
##	The property IsWildColored is true if the SimplicialSurface admits a
##	wild coloring. As a precondition for this the SimplicialSurface has to be
##	an actual surface.
##
DeclareProperty( "IsWildColored", IsActualSurface );


#!	@Description
#!	The property IsOrientable is true if the SimplicialSurface object is
#!	orientable. This is only possible if it is an actual surface.
#!	@Arguments a simplicial surface
#!	@Returns true if orientable, false otherwise
DeclareProperty( "IsOrientable", IsSimplicialSurface and IsActualSurface );


#!	@Description
#!	The property IsConnected is true if the SimplicialSurface object is
#!	connected.
#!	@Arguments a simplicial surface
#!	@Returns true if connected, false otherwise
DeclareProperty( "IsConnected", IsSimplicialSurface );


#!  @Description
#!  Return the Euler characteristic of a simplicial surface.
#!  The Euler characteristic is |V| - |E| + |F|, where |V| is the number of
#!  vertices, |E| is the number of edges and |F| is the number of faces.
#!  @Returns an integer, the Euler characteristic.
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "EulerCharacteristic", IsSimplicialSurface );


#!  @Description
#!	Return a list of integers (with holes). For each vertex-
#!	number it contains the number of faces which are incident to that vertex
#!	(the degree of the vertex). All other positions are unbounded.
#!  @Returns a list of integers
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "UnsortedDegrees", IsSimplicialSurface );


#!  @Description
#!	Return a dense sorted list of integers that contains the 
#!	degrees of the vertices (with repetitions)
#!  @Returns a dense sorted list of integers
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "SortedDegrees", IsSimplicialSurface );


#!  @Description
#!  Return the face-anomaly-classes of a simplicial surface.
#!	Two faces are in the same face-anomaly-class if they contain the same
#!	vertices.
#!  @Returns The face-anomaly-classes (as a list of sets)
#!  @Arguments <simpsurf> a simplicial surface
DeclareAttribute( "FaceAnomalyClasses", IsSimplicialSurface );


#!  @Description
#!  Return the coloured incidence graph of a simplicial surface.
#!	The vertex set of this graph consists of all vertices, edges and faces
#!	of the simplicial surface. All vertices, all edges and all faces
#!	are in individual colour classes.
#!	The edges are given by vertex-edge and edge-face pairs.
#!  @Returns the coloured incidence graph
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "IncidenceGraph", IsSimplicialSurface );



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
#!  Check if two simplicial surfaces are isomorphic. This method only checks
#!	if they are isomorphic with respect to the incidence relation. It does
#!	not check if additional structure like a wild coloring is isomorphic (or
#!	even present).
#!  @Returns true or false
#!  @Arguments <s1>, <s2>, two simplicial surface objects
#!
##
DeclareOperation( "IsIsomorphic", [IsSimplicialSurface, IsSimplicialSurface] );


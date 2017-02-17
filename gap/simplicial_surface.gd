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
##  This file contains the declaration part for the simplicial surfaces
##	of the SimplicialSurfaces package.
##
##	A SimplicialSurface consists of vertices, edges and faces. Each of those
##	is enumerated by positive integers (not necessarily consecutively).
##	Furthermore we have an incidence relation between them.
##
##	We additionally require a local orientation for each face - that is we
##	want to distinguish its two sides. Therefore we also need names for both
##	sides. The default naming scheme (which will be applied if the user does
##	not explicitly objects) is that the two sides of the face f will be called
##	+f and -f. With this scheme all positive integers represent the "upper
##	sides" and negative integers the "lower sides". A side effect is that the
##	name of a face and of its upper side coincide. It is usually clear from
##	context which one is meant.
##	Mathematically the local orientation is an cycle of the vertices inside
##	a face such that two adjacent vertices in the cycle are also adjacent in
##	the face.
##
##

DeclareInfoClass( "InfoSimplicial" );
SetInfoLevel(InfoSimplicial,1);
# TODO explain structure of everything in a separate tex-file


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
BindGlobal( "SimplicialSurfaceFamily", 
    NewFamily("SimplicialSurfaceFamily",  IsObject, IsSimplicialSurface) );




#############################################################################
##
##
#!  @Section Constructors for Simplicial Surfaces
#!
#!
#!

##
##	This constructor takes the following information:
##
##	The set of vertices (alternatively a number n that becomes [1..n] )
##	The set of edges (alternatively a number n that becomes [1..n] )
##	The set of faces (alternatively a number n that becomes [1..n] )
##	The list EdgesByVertices
##	The list FacesByEdges.
##
##	The local orientation will be set at random and the face naming scheme will
##	be set to default.
##
##	The NoCheck-function does the same thing but does not test if the
##	arguments are well-defined.
DeclareOperation( "SimplicialSurfaceByDownwardIncidence",
	[ IsSet, IsSet, IsSet, IsList, IsList ] );
DeclareOperation( "SimplicialSurfaceByDownwardIncidenceNC",
	[ IsSet, IsSet, IsSet, IsList, IsList ] );

##
##	This constructor takes the following information:
##
##	The set of vertices (alternatively a number n that becomes [1..n] )
##	The set of edges (alternatively a number n that becomes [1..n] )
##	The set of faces (alternatively a number n that becomes [1..n] )
##	The list EdgesByVertices
##	The list FacesByEdges. Each element of this list (that is bound) has to be
##		a list of edges such that two adjacent edges have one vertex in common.
##		This defines an ordering of the edges and therefore an orientation of
##		the face. If we apply this orientation to the vertices we get the 
##		local orientation of this face. If the edge lists are not given in this
##		way, an error is thrown. 
##	Optional: the list NamesOfFaces. If this is not given, the default
##				naming scheme is used
##		To use the optional argument, write
##		SimplicialSurfaceByDownwardIncidence( arg : NamesOfFaces := ? )
##
##	The NoCheck-function does the same thing but does not test if the
##	arguments are well-defined.
DeclareOperation( "SimplicialSurfaceByDownwardIncidenceWithOrientation",
	[ IsSet, IsSet, IsSet, IsList, IsList ] );
DeclareOperation( "SimplicialSurfaceByDownwardIncidenceWithOrientationNC",
	[ IsSet, IsSet, IsSet, IsList, IsList ] );

##
##	This constructor takes the following information:
##
##	The set of vertices (alternatively a number n that becomes [1..n] )
##	The set of faces (alternatively a number n that becomes [1..n] )
##	The list FacesByVertices.
##
##	Edges are generated as becomes necessary. It is assumed that two faces
##	that share two vertices also share an edge.
##
##	The local orientation will be set at random and the face naming scheme will
##	be set to default.
##
##	The NoCheck-function does the same thing but does not test if the
##	arguments are well-defined.
DeclareOperation( "SimplicialSurfaceByVerticesInFaces", 
	[ IsSet, IsSet, IsList ] );
DeclareOperation( "SimplicialSurfaceByVerticesInFacesNC", 
	[ IsSet, IsSet, IsList ] );



#############################################################################
##
##
#!  @Section Attributes and properties of Simplicial Surfaces
#!
#!

##	The double declaration has the following reason: In grape there is a method
##	Vertices that collides with our usage.

#! @Description
#! Returns the numbers of the vertices as a set. This is a basic method.
#! @Arguments a simplicial surface
#! @Returns a dense list of integers
DeclareAttribute( "VerticesAttributeOfSimplicialSurface", IsSimplicialSurface );
DeclareOperation( "Vertices", [IsSimplicialSurface] );

#! @Description
#! Returns the numbers of the edges as a set. This is a basic method.
#! @Arguments a simplicial surface
#! @Returns a dense list of integers
DeclareAttribute( "Edges", IsSimplicialSurface );

#! @Description
#! Returns the numbers of the faces as a set. This is a basic method.
#! @Arguments a simplicial surface
#! @Returns a dense list of integers
DeclareAttribute( "Faces", IsSimplicialSurface );


#! @Description
#! Returns the number of vertices.
#! @Arguments a simplicial surface
#! @Returns an integers
DeclareAttribute( "NrOfVertices",
		IsSimplicialSurface );

#! @Description
#! Returns the number of edges.
#! @Arguments a simplicial surface
#! @Returns an integers
DeclareAttribute( "NrOfEdges", 
		IsSimplicialSurface );

#! @Description
#! Returns the number of faces.
#! @Arguments a simplicial surface
#! @Returns an integers
DeclareAttribute( "NrOfFaces", 
		IsSimplicialSurface );


#!	@Description
#!	Return the vertices in terms of the edges. Return a list
#!	with holes and at the position of each vertex-number is a set of
#!	all edges that are incident to that vertex. All other positions are
#!	unbounded.
#!	Either this method or EdgesByVertices is basic.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareAttribute( "VerticesByEdges",
		IsSimplicialSurface );

#!	@Description
#!	Return the vertices in terms of the faces. Return a list
#!	with holes and at the position of each vertex-number is a set of
#!	all faces that are incident to that vertex. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareAttribute( "VerticesByFaces", 
		IsSimplicialSurface);

#!	@Description
#!	Return the edges in terms of the vertices. Return a list
#!	with holes and at the position of each edge-number is a set of
#!	all vertices that are incident to that edge. All other positions are
#!	unbounded.
#!	Either this method or VerticesByEdges is basic.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareAttribute( "EdgesByVertices", 
		IsSimplicialSurface);

#!	@Description
#!	Return the edges in terms of the faces. Return a list
#!	with holes and at the position of each edge-number is a set of
#!	all faces that are incident to that edge. All other positions are
#!	unbounded.
#!	Either this method or FacesByEdges is basic.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareAttribute( "EdgesByFaces", 
		IsSimplicialSurface);

#!	@Description
#!	Return the faces in terms of the vertices. Return a list
#!	with holes and at the position of each face-number is a set of
#!	all vertices that are incident to that face. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareAttribute( "FacesByVertices", 
		IsSimplicialSurface);

#!	@Description
#!	Return the faces in terms of the edges. Return a list
#!	with holes and at the position of each face-number is a set of
#!	all edges that are incident to that face. All other positions are
#!	unbounded.
#!	Either this method or EdgesByFaces is basic.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
DeclareAttribute( "FacesByEdges", 
		IsSimplicialSurface);


#!	@Description
#!	The property IsActualSurface is true if the SimplicialSurface object
#!	actually represents a surface (it might otherwise happen that one edge
#!	belongs to three different faces).
#!	@Arguments a simplicial surface
#!	@Returns true if it is a surface and false else.
DeclareProperty( "IsActualSurface", IsSimplicialSurface );


#!	@Description
#!	The property IsTriangleSurface is true if all faces of the SimplicialSurface
#!	object are triangles (i.e. they consist of three edges).
#!	@Arguments a simplicial surface
#!	@Returns true if all faces are triangles and false else.
DeclareProperty( "IsTriangleSurface", IsSimplicialSurface );


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

#!	@Description
#!	Return a list of all connected components of the simplicial surface.
#!	@Arguments a simplicial surface
#!	@Returns a list of simplicial surfaced
DeclareAttribute( "ConnectedComponentsAttributeOfSimplicialSurface", 
		IsSimplicialSurface );
#DeclareOperation( "ConnectedComponents", [IsSimplicialSurface] );
#TODO uncomment as soon as situation with GRAPE is resolved


#!  @Description
#!  Return the Euler characteristic of a simplicial surface.
#!  The Euler characteristic is |V| - |E| + |F|, where |V| is the number of
#!  vertices, |E| is the number of edges and |F| is the number of faces.
#!  @Returns an integer, the Euler characteristic.
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "EulerCharacteristic", 
		IsSimplicialSurface );


#!  @Description
#!	Return a list of integers (with holes). For each vertex-
#!	number it contains the number of faces which are incident to that vertex
#!	(the degree of the vertex). All other positions are unbounded.
#!  @Returns a list of integers
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "UnsortedDegrees", 
		IsSimplicialSurface );


#!  @Description
#!	Return a dense sorted list of integers that contains the 
#!	degrees of the vertices (with repetitions)
#!  @Returns a dense sorted list of integers
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "SortedDegrees", 
		IsSimplicialSurface );

#!  @Description
#!  Return the vertex symbol of a simplicial surface.
#!	The vertex symbol is a list, where the i-th entry counts the number of 
#!	vertices that are incident to exactly i edges. If there are no such
#!	vertices the entry is unbounded.
#!  @Arguments a simplicial surface object simpsurf
#!  @Returns a list of integers
DeclareAttribute( "VertexSymbol", 
		IsSimplicialSurface );


#!  @Description
#!	Return a list of permutations where at the position of each face-number
#!	there is a cycle of all vertices that are incident to this face. This
#!	cycle represents the local orientation of this face. All other positions
#!	are unbounded.
#!	Either this method or LocalOrientationByEdges is basic
#!  @Returns a list of permutations
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "LocalOrientationByVerticesAsPerm", 
		IsSimplicialSurface );
DeclareOperation( "LocalOrientation", [IsSimplicialSurface] );


#!  @Description
#!	Return a list of lists where at the position of each face-number
#!	there is a list of all vertices that are incident to this face. This
#!	list represents the local orientation of this face. All other positions
#!	are unbounded.
#!	Either this method or LocalOrientationByEdges is basic
#!  @Returns a list of lists
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "LocalOrientationByVerticesAsList", 
		IsSimplicialSurface );


#!  @Description
#!	Return a list of permutations where at the position of each face-number
#!	there is a cycle of all edges that are incident to this face. This
#!	cycle represents the local orientation of this face. All other positions
#!	are unbounded.
#!	Either this method or LocalOrientationByVertices is basic
#!  @Returns a list of permutations
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "LocalOrientationByEdgesAsPerm", 
		IsSimplicialSurface );


#!  @Description
#!	Return a list of lists where at the position of each face-number
#!	there is a list of all edges that are incident to this face. This
#!	list represents the local orientation of this face. All other positions
#!	are unbounded.
#!	Either this method or LocalOrientationByEdges is basic
#!  @Returns a list of lists
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "LocalOrientationByEdgesAsList", 
		IsSimplicialSurface );


#!  @Description
#!	Return a list of tuples where at each face-number there is a list with two
#!	entries. The first one is the name of the upper face-side, the second one
#!	the name of the lower face-side (with respect to the local orientation).
#!	All other positions are unbounded.
#!	If IsFaceNamesDefault is false, this method is basic.
#!  @Returns a list of lists of integers
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "NamesOfFaces", 
		IsSimplicialSurface );

#!	@Description
#!	Return if the naming scheme for the faces is the default one, meaning
#!	that the upper side of a face f is called f (a positive integer) and the
#!	lower side -f (a negative integer).
#!	@Returns true if the simplicial surface follows the default naming scheme,
#!	false otherwise
#!	@Arguments a simplicial surface object simpsurf
DeclareProperty( "IsFaceNamesDefault", IsSimplicialSurface );


#!  @Description
#!  Return the face-anomaly-classes of a simplicial surface.
#!	Two faces are in the same face-anomaly-class if they contain the same
#!	vertices.
#!  @Returns The face-anomaly-classes (as a list of sets)
#!  @Arguments <simpsurf> a simplicial surface
DeclareAttribute( "FaceAnomalyClasses", 
		IsSimplicialSurface );


#!  @Description
#!  Return the coloured incidence graph of a simplicial surface.
#!	The vertex set of this graph consists of all vertices, edges and faces
#!	of the simplicial surface. All vertices, all edges and all faces
#!	are in individual colour classes.
#!	The edges are given by vertex-edge and edge-face pairs.
#!  @Returns the coloured incidence graph
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "IncidenceGraph", 
		IsSimplicialSurface );


#!	@Description
#!	Return a string that contains a command to reconstruct this simplicial
#!	surface. It is primarily used in the PrintObj-method.
#!	@Arguments a simplicial surface
#!	@Returns a string
DeclareAttribute( "PrintStringAttributeOfSimplicialSurface", 
		IsSimplicialSurface );


#############################################################################
##
##
#!  @Section Functions for Simplicial Surfaces
#!
#!
#!


##
#!	@Description
#!	This function calls
#!		Objectify( type, rec )
#!	and afterwards copies all attributes and properties of the simplicial
#!	surface modelSurf that are declared in this section to the the new object.
#!	This method has to be overwritten for a specialization of this class.
#!
#!	WARNING: The type can't be checked! Only types that are derived from
#!	IsSimplicialSurface can be used with impunity!
#!
#!	@Arguments a type, a record, a simplicial surface
#!	@Returns an object of type type
DeclareOperation( "ObjectifySimplicialSurface",
		[IsType,IsRecord,IsSimplicialSurface]);

##
#!	@Description
#!	This function returns both names of the given face. The first entry is
#!	the name of the upper side, the second one of the lower side.
#!	The NC-version doesn't check if the given number actually is a face.
#!	@Arguments a simplicial surface object simpsurf, a face number
#!	@Returns a list with two elements
#!
DeclareOperation( "NamesOfFace", [IsSimplicialSurface, IsPosInt] );
DeclareOperation( "NamesOfFaceNC", [IsSimplicialSurface, IsPosInt] );


##
#!	@Description
#!	Return the face-number of the simplicial surface that has the given name
#!	as the name of one of its sides.
#!	@Arguments a simplicial surface object simpsurf, an integer
#!	@Returns a positive integer
#!
DeclareOperation( "FaceByName", [IsSimplicialSurface, IsInt] );


##
#!	@Description
#!	This function returns the simplicial subsurface that is defined by the
#!	given set of faces.
#!	The NC-version does not check if the given faces actually are faces of
#!	the simplicial surface.
#!	@Arguments a simplicial surface object simpsurf, a set of positive integers
#!	@Returns a simplicial surface object
#!
DeclareOperation( "SubsurfaceByFaces", [IsSimplicialSurface, IsSet] );
DeclareOperation( "SubsurfaceByFacesNC", [IsSimplicialSurface, IsSet] );


##
#!	@Description
#!	This function removes all ears of the simplicial surface and returns
#!	the resulting surface.
#!	@Arguments a simplicial surface object simpsurf
#!	@Returns a simplicial surface object
#!
DeclareOperation( "SnippOffEars", [IsSimplicialSurface] );


##
#!	@Description
#!	This function returns the connected component of the given face.
#!	The NC-version doesn't check if the given face actually is one.
#!	@Arguments a simplicial surface object simpsurf, a positive integer
#!	@Returns a simplicial surface object
#!
DeclareOperation( "ConnectedComponentOfFace", [IsSimplicialSurface, IsPosInt] );
DeclareOperation( "ConnectedComponentOfFaceNC", [IsSimplicialSurface, IsPosInt] );

##
#!  @Description
#!  Check if two simplicial surfaces are isomorphic. This method only checks
#!	if they are isomorphic with respect to the incidence relation. It does
#!	not check if additional structure like a wild coloring is isomorphic (or
#!	even present).
#!  @Arguments <s1>, <s2>, two simplicial surface objects
#!  @Returns true or false
#!
DeclareOperation( "IsIsomorphic", [IsSimplicialSurface, IsSimplicialSurface] );



#
###  This program is free software: you can redistribute it and/or modify
###  it under the terms of the GNU General Public License as published by
###  the Free Software Foundation, either version 3 of the License, or
###  (at your option) any later version.
###
###  This program is distributed in the hope that it will be useful,
###  but WITHOUT ANY WARRANTY; without even the implied warranty of
###  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
###  GNU General Public License for more details.
###
###  You should have received a copy of the GNU General Public License
###  along with this program.  If not, see <http://www.gnu.org/licenses/>.
###

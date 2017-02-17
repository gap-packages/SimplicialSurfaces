##############################################################################
##
#W  coloured simplicial_surface.gd          SimplicialSurfaces           Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the declaration part for the coloured simplicial surfaces
##	of the SimplicialSurfaces package.
##
##	A coloured simplicial surface consists of the following information:
##		- a SimplicialSurface that describes the underlying structure
##		- an equivalence relation on vertices, edges and faces that describes
##			which of those are "folded together"
##
##	There are in essence two ways to describe a coloured simplicial surface with
##	(we assume the equivalence classes are numbered):
##	1) Save a set of all equivalence class numbers (e.g. 
##		VertexEquivalenceNumbersAsSet) and save the classes in a list which is
##		indexed by the set of equivalence class numbers (e.g.
##		VertexEquivalenceClassesByNumbers).
##	2) Save the equivalence class numbers and the equivalence classes both
##		in lists which are indexed by the numbers of the elements in those
##		classes (e.g. VertexEquivalenceNumbersByElements and
##		VertexEquivalenceClassesByElements). This corresponds to the natural
##		projection x -> [x].
##
##	To be able to use all methods of this class, one of those two ways has
##	to be defined for vertices, edges and faces (the choice may be done freely
##	for each of those). For example we have these choices to define the
##	vertices uniquely:
##		1) VertexEquivalenceClassesByNumbers
##		2) VertexEquivalenceNumbersByElements
##

DeclareCategory( "IsColouredSimplicialSurface",
					IsComponentObjectRep and IsAttributeStoringRep );


##
##	Define a new family for coloured simplicial surfaces. The family
##	defines a necessary condition that has to be fulfilled for objects to be 
##	equal to each other. The argument IsColouredSimplicialSurface 
##	guarantees that only objects that lie in this category can be part of the 
##	family.
##
BindGlobal( "ColouredSimplicialSurfaceFamily", 
    NewFamily("ColouredSimplicialSurfaceFamily",  IsObject, 
				IsColouredSimplicialSurface) );



#############################################################################
##
##
#!  @Section Constructors for coloured simplicial surfaces
#!
#!
#!

#!	@Description
#!	Return a coloured simplicial surface that is based on the given
#!	simplicial surface. All equivalences are assumed to be trivial.
#!	@Arguments a simplicial surface
#!	@Returns a coloured simplicial surface
DeclareOperation( "ColouredSimplicialSurface", [IsSimplicialSurface]);


#############################################################################
##
##
#!  @Section Attributes and properties of coloured simplicial surfaces
#!
#!


#! @Description
#! Return the underlying simplicial surface.
#! @Arguments a coloured simplicial surface
#! @Returns a simplicial surface
DeclareAttribute( 
	"UnderlyingSimplicialSurface",
	IsColouredSimplicialSurface );

#!	@Description
#!	Return the simplicial surface that we get if we consider each equivalence
#!	class as one point. This method only constructs vertices, edges and faces.
#!	Local orientation and naming scheme are set by default and have no
#!	necessary relation to those of the underlying simplicial surface.
#!	@Arguments a coloured simplicial surface
#!	@Returns a simplicial surface
DeclareAttribute(
	"QuotientSimplicialSurface",
	IsColouredSimplicialSurface);

##
##		Vertices
##

#! @Description
#! Return the vertex equivalence numbers as set. Each vertex equivalence class 
#! has a unique number associated with it.
#! @Arguments a coloured simplicial surface
#! @Returns a dense list of positive integers
DeclareAttribute(
	"VertexEquivalenceNumbersAsSet",
	IsColouredSimplicialSurface);

#! @Description
#! Return the vertex equivalence numbers as list indexed by the vertices of the
#! underlying simplicial surface. Each vertex equivalence class 
#! has a unique number associated with it.
#! @Arguments a coloured simplicial surface
#! @Returns a dense list of positive integers
DeclareAttribute(
	"VertexEquivalenceNumbersByElements",
	IsColouredSimplicialSurface);

#! @Description
#! Return the vertex equivalence classes. They are indexed by the vertex
#! equivalence numbers.
#! @Arguments a coloured simplicial surface
#! @Returns a list of sets of positive integers
DeclareAttribute( 
	"VertexEquivalenceClassesByNumbers",
	IsColouredSimplicialSurface );


#! @Description
#! Return the vertex equivalence classes. They are indexed by the vertices of
#! the underlying simplicial surface.
#! @Arguments a coloured simplicial surface
#! @Returns a list of sets of positive integers
DeclareAttribute( 
	"VertexEquivalenceClassesByElements",
	IsColouredSimplicialSurface );

##
##		Edges
##

#! @Description
#! Return the edge equivalence numbers as set. Each edge equivalence class 
#! has a unique number associated with it.
#! @Arguments a coloured simplicial surface
#! @Returns a dense list of positive integers
DeclareAttribute(
	"EdgeEquivalenceNumbersAsSet",
	IsColouredSimplicialSurface);

#! @Description
#! Return the edge equivalence numbers as list indexed by the edges of the
#! underlying simplicial surface. Each edge equivalence class 
#! has a unique number associated with it.
#! @Arguments a coloured simplicial surface
#! @Returns a dense list of positive integers
DeclareAttribute(
	"EdgeEquivalenceNumbersByElements",
	IsColouredSimplicialSurface);

#! @Description
#! Return the edge equivalence classes. They are indexed by the edge
#! equivalence numbers.
#! @Arguments a coloured simplicial surface
#! @Returns a list of sets of positive integers
DeclareAttribute( 
	"EdgeEquivalenceClassesByNumbers",
	IsColouredSimplicialSurface );


#! @Description
#! Return the edge equivalence classes. They are indexed by the edges of
#! the underlying simplicial surface.
#! @Arguments a coloured simplicial surface
#! @Returns a list of sets of positive integers
DeclareAttribute( 
	"EdgeEquivalenceClassesByElements",
	IsColouredSimplicialSurface );


##
##		Faces
##

#! @Description
#! Return the face equivalence numbers as set. Each face equivalence class 
#! has a unique number associated with it.
#! @Arguments a coloured simplicial surface
#! @Returns a dense list of positive integers
DeclareAttribute(
	"FaceEquivalenceNumbersAsSet",
	IsColouredSimplicialSurface);

#! @Description
#! Return the face equivalence numbers as list indexed by the faces of the
#! underlying simplicial surface. Each face equivalence class 
#! has a unique number associated with it.
#! @Arguments a coloured simplicial surface
#! @Returns a dense list of positive integers
DeclareAttribute(
	"FaceEquivalenceNumbersByElements",
	IsColouredSimplicialSurface);

#! @Description
#! Return the face equivalence classes. They are indexed by the face
#! equivalence numbers.
#! @Arguments a coloured simplicial surface
#! @Returns a list of sets of positive integers
DeclareAttribute( 
	"FaceEquivalenceClassesByNumbers",
	IsColouredSimplicialSurface );


#! @Description
#! Return the face equivalence classes. They are indexed by the faces of
#! the underlying simplicial surface.
#! @Arguments a coloured simplicial surface
#! @Returns a list of sets of positive integers
DeclareAttribute( 
	"FaceEquivalenceClassesByElements",
	IsColouredSimplicialSurface );

#!	@Description
#!	Return the binding relation of the given vertex class (represented by its
#!	number). The binding partition represents the finest partition into which 
#!	the vertex equivalence class may split without contradicting the
#!	consistency with the incidence relation.
#!	@Arguments a coloured simplicial surface, a positive integer
#!	@Returns an equivalence relation
KeyDependentOperation( "VertexBindingRelation", 
	IsColouredSimplicialSurface, IsPosInt, function(x) return true; end);

#!	@Description
#!	Return the binding relation of the given edge class (represented by its
#!	number). The binding partition represents the finest partition into which 
#!	the edge equivalence class may split without contradicting the
#!	consistency with the incidence relation.
#!	@Arguments a coloured simplicial surface, a positive integer
#!	@Returns an equivalence relation
KeyDependentOperation( "EdgeBindingRelation", 
	IsColouredSimplicialSurface, IsPosInt, function(x) return true; end);


#TODO should this attribute also be a KeyDependentOperation? Should all 
#attributes that are currently saved as lists be saved as such?
#!	@Description
#!	Return a list that is indexed by the face-names of the underlying
#!	simplicial surface. At the position of a given face lies the local
#!	orientation in terms of the vertex equivalence classes, i.e. it is a
#!	cyclic permutation of the vertex equivalence class numbers that lie in the
#!	given face.
#!	@Arguments a coloured simplicial surface
#!	@Returns a list of cyclic permutations
DeclareAttribute( "LocalOrientationWRTVertexEquivalenceClasses",
	IsColouredSimplicialSurface );


#############################################################################
##
##
#!  @Section Functions for coloured simplicial surfaces
#!
#!
#!

#! @Description
#! Check if two vertices are equivalent.
#! @Arguments two positive integers
#! @Returns true if they are equivalent, false otherwise
DeclareOperation( "IsEquivalentVertex", 
				[IsColouredSimplicialSurface, IsPosInt, IsPosInt]);

#! @Description
#! Check if two edges are equivalent.
#! @Arguments two positive integers
#! @Returns true if they are equivalent, false otherwise
DeclareOperation( "IsEquivalentEdge", 
				[IsColouredSimplicialSurface, IsPosInt, IsPosInt]);

#! @Description
#! Check if two faces are equivalent.
#! @Arguments two positive integers
#! @Returns true if they are equivalent, false otherwise
DeclareOperation( "IsEquivalentFace", 
				[IsColouredSimplicialSurface, IsPosInt, IsPosInt]);

#!	@Description
#!	Check whether the equivalence classes of the second coloured simplicial
#!	surface are contained in the equivalence classes of the first coloured
#!	simplicial surface. This is only possible if both coloured simplicial
#!	surfaces are based on the same simplicial surface.
#!	This happens for example if the first argument is a folding of the
#!	second argument.
#!	@Arguments two coloured simplicial surfaces
#!	@Returns true or false
DeclareOperation( "IsSubcolouring", 
			[IsColouredSimplicialSurface, IsColouredSimplicialSurface] );


############################################################################
##				START convenience methods

#!	@Description
#!	Return the vertex equivalence number of a given vertex. Each vertex 
#!	equivalence class has a unique number associated with it.
#!	The NC-version doesn't check whether the given vertex lies in the underlying
#!	simplicial surface.
#!	@Arguments a coloured simplicial surface, a positive integer
#!	@Returns a positive integers
DeclareOperation( "VertexEquivalenceNumberOfElement",
		[IsColouredSimplicialSurface, IsPosInt] );
DeclareOperation( "VertexEquivalenceNumberOfElementNC",
		[IsColouredSimplicialSurface, IsPosInt] );

#!	@Description
#!	Return the edge equivalence number of a given edge. Each edge 
#!	equivalence class has a unique number associated with it.
#!	The NC-version doesn't check whether the given edge lies in the underlying
#!	simplicial surface.
#!	@Arguments a coloured simplicial surface, a positive integer
#!	@Returns a positive integers
DeclareOperation( "EdgeEquivalenceNumberOfElement",
		[IsColouredSimplicialSurface, IsPosInt] );
DeclareOperation( "EdgeEquivalenceNumberOfElementNC",
		[IsColouredSimplicialSurface, IsPosInt] );

#!	@Description
#!	Return the face equivalence number of a given face. Each face 
#!	equivalence class has a unique number associated with it.
#!	The NC-version doesn't check whether the given face lies in the underlying
#!	simplicial surface.
#!	@Arguments a coloured simplicial surface, a positive integer
#!	@Returns a positive integers
DeclareOperation( "FaceEquivalenceNumberOfElement",
		[IsColouredSimplicialSurface, IsPosInt] );
DeclareOperation( "FaceEquivalenceNumberOfElementNC",
		[IsColouredSimplicialSurface, IsPosInt] );

#!	@Description
#!	Return the vertex equivalence class of a given vertex.
#!	The NC-version doesn't check whether the given vertex lies in the underlying
#!	simplicial surface.
#!	@Arguments a coloured simplicial surface, a positive integer
#!	@Returns a set of positive integers
DeclareOperation( "VertexEquivalenceClassOfElement",
		[IsColouredSimplicialSurface, IsPosInt] );
DeclareOperation( "VertexEquivalenceClassOfElementNC",
		[IsColouredSimplicialSurface, IsPosInt] );

#!	@Description
#!	Return the edge equivalence class of a given edge.
#!	The NC-version doesn't check whether the given edge lies in the underlying
#!	simplicial surface.
#!	@Arguments a coloured simplicial surface, a positive integer
#!	@Returns a set of positive integers
DeclareOperation( "EdgeEquivalenceClassOfElement",
		[IsColouredSimplicialSurface, IsPosInt] );
DeclareOperation( "EdgeEquivalenceClassOfElementNC",
		[IsColouredSimplicialSurface, IsPosInt] );

#!	@Description
#!	Return the face equivalence class of a given face.
#!	The NC-version doesn't check whether the given face lies in the underlying
#!	simplicial surface.
#!	@Arguments a coloured simplicial surface, a positive integer
#!	@Returns a set of positive integers
DeclareOperation( "FaceEquivalenceClassOfElement",
		[IsColouredSimplicialSurface, IsPosInt] );
DeclareOperation( "FaceEquivalenceClassOfElementNC",
		[IsColouredSimplicialSurface, IsPosInt] );

#!	@Description
#!	Return the vertex equivalence class with a given number.
#!	The NC-version doesn't check whether the given number refers to a vertex
#!	equivalence class.
#!	@Arguments a coloured simplicial surface, a positive integer
#!	@Returns a set of positive integers
DeclareOperation( "VertexEquivalenceClassByNumber",
		[IsColouredSimplicialSurface, IsPosInt] );
DeclareOperation( "VertexEquivalenceClassByNumberNC",
		[IsColouredSimplicialSurface, IsPosInt] );

#!	@Description
#!	Return the edge equivalence class with a given number.
#!	The NC-version doesn't check whether the given number refers to a vertex
#!	equivalence class.
#!	@Arguments a coloured simplicial surface, a positive integer
#!	@Returns a set of positive integers
DeclareOperation( "EdgeEquivalenceClassByNumber",
		[IsColouredSimplicialSurface, IsPosInt] );
DeclareOperation( "EdgeEquivalenceClassByNumberNC",
		[IsColouredSimplicialSurface, IsPosInt] );

#!	@Description
#!	Return the face equivalence class with a given number.
#!	The NC-version doesn't check whether the given number refers to a vertex
#!	equivalence class.
#!	@Arguments a coloured simplicial surface, a positive integer
#!	@Returns a set of positive integers
DeclareOperation( "FaceEquivalenceClassByNumber",
		[IsColouredSimplicialSurface, IsPosInt] );
DeclareOperation( "FaceEquivalenceClassByNumberNC",
		[IsColouredSimplicialSurface, IsPosInt] );

##					END convenience methods
############################################################################


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

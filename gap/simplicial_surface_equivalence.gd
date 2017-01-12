##############################################################################
##
#W  simplicial_surface_equivalence.gd          SimplicialSurfaces           Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the declaration part for the simplicial surfaces with
##	equivalence of the SimplicialSurfaces package.
##
##	A simplicial surface with equivalence consists of the following information:
##		- a SimplicialSurface that describes the underlying structure
##		- an equivalence relation on vertices, edges and faces that describes
##			which of those are "folded together"
##
##	There are in essence two ways to describe a simplicial surface with
##	equivalence (we assume the equivalence classes are numbered):
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
##	for each of those).
##

DeclareCategory( "IsSimplicialSurfaceWithEquivalence",
					IsComponentObjectRep and IsAttributeStoringRep );


##
##	Define a new family for simplicial surfaces with equivalence. The family
##	defines a necessary condition that has to be fulfilled for objects to be 
##	equal to each other. The argument IsSimplicialSurfaceWithEquivalence 
##	guarantees that only objects that lie in this category can be part of the 
##	family.
##
SimplicialSurfaceWithEquivalenceFamily := 
    NewFamily("SimplicialSurfaceWithEquivalenceFamily",  IsObject, 
				IsSimplicialSurfaceWithEquivalence);



#############################################################################
##
##
#!  @Section Constructors for simplicial surfaces with equivalence
#!
#!
#!

#!	@Description
#!	Return a simplicial surface with equivalence that is based on the given
#!	simplicial surface. All equivalences are assumed to be trivial.
#!	@Arguments a simplicial surface
#!	@Returns a simplicial surface with equivalence
DeclareOperation( "SimplicialSurfaceWithEquivalence", [IsSimplicialSurface]);


#############################################################################
##
##
#!  @Section Attributes and properties of simplicial surfaces with equivalence
#!
#!


#! @Description
#! Return the underlying simplicial surface.
#! @Arguments a simplicial surface with equivalence
#! @Returns a simplicial surface
DeclareAttribute( 
	"UnderlyingSimplicialSurfaceAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence );
DeclareOperation( "UnderlyingSimplicialSurface", 
									[IsSimplicialSurfaceWithEquivalence] );

#!	@Description
#!	Return the simplicial surface that we get if we consider each equivalence
#!	class as one point. This method only constructs vertices, edges and faces.
#!	Local orientation and naming scheme are set by default and have no
#!	necessary relation to those of the underlying simplicial surface.
#!	@Arguments a simplicial surface with equivalence
#!	@Returns a simplicial surface
DeclareAttribute(
	"QuotientSimplicialSurfaceAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence);
DeclareOperation( "QuotientSimplicialSurface", 
									[IsSimplicialSurfaceWithEquivalence] );

##
##		Vertices
##

#! @Description
#! Return the vertex equivalence numbers as set. Each vertex equivalence class 
#! has a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
DeclareAttribute(
	"VertexEquivalenceNumbersAsSetAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence);
DeclareOperation( "VertexEquivalenceNumbersAsSet", 
									[IsSimplicialSurfaceWithEquivalence] );

#! @Description
#! Return the vertex equivalence numbers as list indexed by the vertices of the
#! underlying simplicial surface. Each vertex equivalence class 
#! has a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
DeclareAttribute(
	"VertexEquivalenceNumbersByElementsAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence);
DeclareOperation( "VertexEquivalenceNumbersByElements", 
									[IsSimplicialSurfaceWithEquivalence] );

#! @Description
#! Return the vertex equivalence classes. They are indexed by the vertex
#! equivalence numbers.
#! @Arguments a simplicial surface with equivalence
#! @Returns a list of sets of positive integers
DeclareAttribute( 
	"VertexEquivalenceClassesByNumbersAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence );
DeclareOperation( "VertexEquivalenceClassesByNumbers", 
									[IsSimplicialSurfaceWithEquivalence] );


#! @Description
#! Return the vertex equivalence classes. They are indexed by the vertices of
#! the underlying simplicial surface.
#! @Arguments a simplicial surface with equivalence
#! @Returns a list of sets of positive integers
DeclareAttribute( 
	"VertexEquivalenceClassesByElementsAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence );
DeclareOperation( "VertexEquivalenceClassesByElements", 
									[IsSimplicialSurfaceWithEquivalence] );

##
##		Edges
##

#! @Description
#! Return the edge equivalence numbers as set. Each edge equivalence class 
#! has a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
DeclareAttribute(
	"EdgeEquivalenceNumbersAsSetAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence);
DeclareOperation( "EdgeEquivalenceNumbersAsSet", 
									[IsSimplicialSurfaceWithEquivalence] );

#! @Description
#! Return the edge equivalence numbers as list indexed by the edges of the
#! underlying simplicial surface. Each edge equivalence class 
#! has a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
DeclareAttribute(
	"EdgeEquivalenceNumbersByElementsAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence);
DeclareOperation( "EdgeEquivalenceNumbersByElements", 
									[IsSimplicialSurfaceWithEquivalence] );

#! @Description
#! Return the edge equivalence classes. They are indexed by the edge
#! equivalence numbers.
#! @Arguments a simplicial surface with equivalence
#! @Returns a list of sets of positive integers
DeclareAttribute( 
	"EdgeEquivalenceClassesByNumbersAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence );
DeclareOperation( "EdgeEquivalenceClassesByNumbers", 
									[IsSimplicialSurfaceWithEquivalence] );


#! @Description
#! Return the edge equivalence classes. They are indexed by the edges of
#! the underlying simplicial surface.
#! @Arguments a simplicial surface with equivalence
#! @Returns a list of sets of positive integers
DeclareAttribute( 
	"EdgeEquivalenceClassesByElementsAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence );
DeclareOperation( "EdgeEquivalenceClassesByElements", 
									[IsSimplicialSurfaceWithEquivalence] );


##
##		Faces
##

#! @Description
#! Return the face equivalence numbers as set. Each face equivalence class 
#! has a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
DeclareAttribute(
	"FaceEquivalenceNumbersAsSetAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence);
DeclareOperation( "FaceEquivalenceNumbersAsSet", 
									[IsSimplicialSurfaceWithEquivalence] );

#! @Description
#! Return the face equivalence numbers as list indexed by the faces of the
#! underlying simplicial surface. Each face equivalence class 
#! has a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
DeclareAttribute(
	"FaceEquivalenceNumbersByElementsAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence);
DeclareOperation( "FaceEquivalenceNumbersByElements", 
									[IsSimplicialSurfaceWithEquivalence] );

#! @Description
#! Return the face equivalence classes. They are indexed by the face
#! equivalence numbers.
#! @Arguments a simplicial surface with equivalence
#! @Returns a list of sets of positive integers
DeclareAttribute( 
	"FaceEquivalenceClassesByNumbersAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence );
DeclareOperation( "FaceEquivalenceClassesByNumbers", 
									[IsSimplicialSurfaceWithEquivalence] );


#! @Description
#! Return the face equivalence classes. They are indexed by the faces of
#! the underlying simplicial surface.
#! @Arguments a simplicial surface with equivalence
#! @Returns a list of sets of positive integers
DeclareAttribute( 
	"FaceEquivalenceClassesByElementsAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence );
DeclareOperation( "FaceEquivalenceClassesByElements", 
									[IsSimplicialSurfaceWithEquivalence] );


#############################################################################
##
##
#!  @Section Functions for simplicial surfaces with equivalence
#!
#!
#!

#! @Description
#! Check if two vertices are equivalent.
#! @Arguments two positive integers
#! @Returns true if they are equivalent, false otherwise
DeclareOperation( "IsEquivalentVertex", 
				[IsSimplicialSurfaceWithEquivalence, IsPosInt, IsPosInt]);

#! @Description
#! Check if two edges are equivalent.
#! @Arguments two positive integers
#! @Returns true if they are equivalent, false otherwise
DeclareOperation( "IsEquivalentEdge", 
				[IsSimplicialSurfaceWithEquivalence, IsPosInt, IsPosInt]);

#! @Description
#! Check if two faces are equivalent.
#! @Arguments two positive integers
#! @Returns true if they are equivalent, false otherwise
DeclareOperation( "IsEquivalentFace", 
				[IsSimplicialSurfaceWithEquivalence, IsPosInt, IsPosInt]);

#!	@Description
#!	Extend the equivalence relation of the simplicial surface with
#!	equivalence with a simplicial surface identification.
#!
#!	The NC-version does not run the test IsApplicableExtension.
#!
#!	@Arguments a simplicial surface with equivalence, a simplicial surface
#!		identification
#!	@Returns a simplicial surface with equivalence
DeclareOperation( "ExtendByIdentification",
	[IsSimplicialSurfaceWithEquivalence, IsSimplicialSurfaceIdentification] );
DeclareOperation( "ExtendByIdentificationNC",
	[IsSimplicialSurfaceWithEquivalence, IsSimplicialSurfaceIdentification] );


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

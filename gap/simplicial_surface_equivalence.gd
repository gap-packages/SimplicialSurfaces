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

DeclareCategory( "IsSimplicialSurfaceWithEquivalence",
					IsComponentObjectRep and IsAttributeStoringRep );

##	We will use the SimplicialSurface-family. We might decide that a simplicial
##	surface with a trivial equivalence is equal to the underlying simplicial
##	surface.


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

#! @Description
#! Return the simplicial surface that we get if we consider each equivalence
#! class as one point.
#! @Arguments a simplicial surface with equivalence
#! @Returns a simplicial surface
DeclareAttribute(
	"QuotientSimplicialSurfaceAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence);
DeclareOperation( "QuotientSimplicialSurface", 
									[IsSimplicialSurfaceWithEquivalence] );


#! @Description
#! Return the vertex equivalence numbers. Each vertex equivalence class has
#! a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
DeclareAttribute(
	"VertexEquivalenceNumbersAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence);
DeclareOperation( "VertexEquivalenceNumbers", 
									[IsSimplicialSurfaceWithEquivalence] );

#! @Description
#! Return the vertex equivalence classes. They are indexed by the vertex
#! equivalence numbers.
#! @Arguments a simplicial surface with equivalence
#! @Returns a list of sets of positive integers
DeclareAttribute( 
	"VertexEquivalenceClassesAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence );
DeclareOperation( "VertexEquivalenceClasses", 
									[IsSimplicialSurfaceWithEquivalence] );

#! @Description
#! Return the edge equivalence numbers. Each edge equivalence class has
#! a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
DeclareAttribute(
	"EdgeEquivalenceNumbersAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence);
DeclareOperation( "EdgeEquivalenceNumbers", 
									[IsSimplicialSurfaceWithEquivalence] );

#! @Description
#! Return the edge equivalence classes. They are indexed by the edge
#! equivalence numbers.
#! @Arguments a simplicial surface with equivalence
#! @Returns a list of sets of positive integers
DeclareAttribute(
	"EdgeEquivalenceClassesAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence);
DeclareOperation( "EdgeEquivalenceClasses", 
									[IsSimplicialSurfaceWithEquivalence] );

#! @Description
#! Return the face equivalence numbers. Each face equivalence class has
#! a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
DeclareAttribute(
	"FaceEquivalenceNumbersAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence);
DeclareOperation( "FaceEquivalenceNumbers", 
									[IsSimplicialSurfaceWithEquivalence] );

#! @Description
#! Return the face equivalence classes. They are indexed by the face
#! equivalence numbers.
#! @Arguments a simplicial surface with equivalence
#! @Returns a list of sets of positive integers
DeclareAttribute( 
	"FaceEquivalenceClassesAttributeOfSSWE",
	IsSimplicialSurfaceWithEquivalence);
DeclareOperation( "FaceEquivalenceClasses", 
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

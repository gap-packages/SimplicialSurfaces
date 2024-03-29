#! @DoNotReadRestOfFile

##############################################################################
##
#W  simplicial_surface_fan.gd    SimplicialSurfaces           Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the declaration part for the fans that are used in the
##	folding complexes of the SimplicialSurfaces package.
##
##	A fan consists of the following information:
##		- a direction, given by Begin and End (this represents the edge
##			equivalence class numbers)
##		- a cyclical permutation (this permutes the faces that lie around the
##			edge equivalence class).
##		- a set of positive integers, called the corona, on which the
##			permutation operates transitively
##

#!	@Chapter Simplicial Surface Fans

DeclareCategory( "IsSimplicialSurfaceFan",
					IsComponentObjectRep and IsAttributeStoringRep );


BindGlobal( "SimplicialSurfaceFanFamily", 
    NewFamily("SimplicialSurfaceFanFamily",  IsObject, IsSimplicialSurfaceFan) );


#############################################################################
##
##
#!  @Section Constructors for fans
#!
#!
#!

#!	@Description
#!	Return a fan by defining all necessary attributes. Begin and End have to be
#!	different. If the given permutation is trivial, the corona will be empty.
#!
#!	By using the optional argument Corona := ... (separated by a colon from the 
#!	other arguments) the corona can be set manually.
#!	If the permutation is not trivial then this argument has to agree with
#!	MovedPoints of the permutation. 
#!
#!	The NC-version doesn't check if Begin and End are different or if the given
#!	Corona is consistent with the given permutation. 
#!	
#!	@Arguments two positive integers, one cyclic permutation
#!	@Returns a fan
DeclareOperation( "SimplicialSurfaceFan", [IsPosInt, IsPosInt, IsPerm]);
DeclareOperation( "SimplicialSurfaceFanNC", [IsPosInt, IsPosInt, IsPerm]);


#!	@Description
#!	Return the fan of the edge of a simplicial surface. For this to be unique
#!	at most two faces can be incident to the edge (otherwise the permutation
#!	of those is not unique). This is guaranteed to be the case if the simplicial
#!	surface is an actual surface.
#!
#!	@Arguments a simplicial surface, a positive integer
#!	@Returns a fan
DeclareOperation( "SimplicialSurfaceFanByEdgeInSimplicialSurface", 
		[IsSimplicialSurface, IsPosInt]);


#!	@Description
#!	Return the fan of the edge of a coloured simplicial surface. For 
#!	this to be unique at most two faces can be incident to the edge equivalence
#!	class (otherwise the permutation of those is not unique).
#!
#!	@Arguments a coloured simplicial surface, a positive integer
#!	@Returns a fan
DeclareOperation( 
	"SimplicialSurfaceFanByEdgeInColouredSimplicialSurface", 
		[IsColouredSimplicialSurface, IsPosInt]);



#############################################################################
##
##
#!  @Section Attributes and properties of fans
#!
#!

#! @Description
#! Return the begin of the fan (which is one part of the orientation)
#! @Arguments a simplicial surface fan
#! @Returns a positive integers
DeclareAttribute( "BeginOfFan", 
	IsSimplicialSurfaceFan );


#! @Description
#! Return the end of the fan (which is one part of the orientation)
#! @Arguments a simplicial surface fan
#! @Returns a positive integers
DeclareAttribute( "EndOfFan", 
	IsSimplicialSurfaceFan );


#! @Description
#! Return the permutation of the fan.
#! @Arguments a simplicial surface fan
#! @Returns a positive integers
DeclareAttribute( "PermutationOfFan", 
	IsSimplicialSurfaceFan );


#! @Description
#! Return the corona of the fan.
#! @Arguments a simplicial surface fan
#! @Returns a set of positive integers
DeclareAttribute( "CoronaOfFan", 
	IsSimplicialSurfaceFan );


#! @Description
#! Return the inverse of the fan. You get the inverse of a fan by switching
#! Begin and End in addition to inverting the permutation.
#! @Arguments a simplicial surface fan
#! @Returns a positive integers
DeclareAttribute( "InverseOfFan", 
	IsSimplicialSurfaceFan );


#!	@Description
#!	Return the reduct of a given fan with respect to the given set. The reduct
#!	of a fan is another fan with the same Begin and End but a modified
#!	permutation. The permutation is derived from the cycle-presentation of the
#!	permutation by ignoring all values that doesn't lie in the given set. the
#!	set has to be a subset of the corona.
#!
#!	@Arguments a simplicial surface fan, a set of positive integers
#!	@Returns a simplicial surface fan
KeyDependentOperation( "ReducedFan", IsSimplicialSurfaceFan, IsSet, 
	function( set )
		return Size( Filtered( set, el -> not IsPosInt(el) ) ) = 0;
	end
);


#############################################################################
##
##
#!  @Section Functions for fans
#!
#!
#!


#!	@Description
#!	Check if the given fan is the fan of a simplicial surface. This is the case
#!	if there is an edge with Begin and End as vertices and the incident faces
#!	around it are exactly the corona. Then this method returns the correct
#!	edge, otherwise fail.
#!	@Arguments a simplicial surface, a simplicial surface fan
#!	@Returns a positive integer or fail
DeclareOperation( "EdgeForFanOfSimplicialSurface", 
		[IsSimplicialSurface, IsSimplicialSurfaceFan] );


#!	@Description
#!	Check if the given fan is the fan of a given edge of a simplicial surface.
#!	This is the case if the edge has Begin and End as vertices and the incident 
#!	faces around it are exactly the corona. Then this method returns true,
#!	otherwise false.
#!	@Arguments a simplicial surface, a simplicial surface fan, a positive 
#!		integer
#!	@Returns true or false
DeclareOperation( "IsEdgeForFanOfSimplicialSurface", 
		[IsSimplicialSurface, IsSimplicialSurfaceFan, IsPosInt] );


#!	@Description
#!	Check if the given fan is the fan of a coloured simplicial surface. 
#!	This is the case if there is an edge equivalence class with Begin and End
#!	as incident vertex equivalence classes and the incident faces (not 
#!	equivalence classes!) around it are exactly the corona.
#!	Then it returns the edge equivalence class, otherwise fail.
#!	@Arguments a coloured simplicial surface, a simplicial surface fan
#!	@Returns a positive integer or fail
DeclareOperation( "EdgeEquivalenceNumberForFanOfColouredSimplicialSurface", 
		[IsColouredSimplicialSurface, IsSimplicialSurfaceFan] );

#!	@Description
#!	Check if the given fan is the fan of a given edge equivalence class of a 
#!	coloured simplicial surface. This is the case if the edge equivalence class
#!	has Begin and End as vertices and the incident faces (not face equivalence
#!	classes!) around it are exactly the corona. Then this method returns true,
#!	otherwise false.
#!	@Arguments a coloured simplicial surface, a simplicial surface fan, a 
#!		positive integer
#!	@Returns true or false
DeclareOperation( "IsEdgeEquivalenceNumberForFanOfColouredSimplicialSurface", 
		[IsColouredSimplicialSurface, IsSimplicialSurfaceFan, IsPosInt] );


#!	@Description
#!	A fan of a simplicial surface (with colouring) defines an orientation
#!	for an edge (equivalence class). By the right-hand-rule this defines an
#!	orientation for the set of incident faces as well. Since those faces are
#!	oriented as well we can determine which side of the face lies in the 
#!	correct direction.
#!	This method returns +1 if this side is the pre-defined "correctly
#!	oriented" side; and -1 otherwise.
#!	@Arguments a simplicial surface (with colouring), a simplicial surface
#!		fan, a positive integer
#!	@Returns an integer
DeclareOperation( "FaceOrientationInducedByFan", 
	[IsColouredSimplicialSurface, IsSimplicialSurfaceFan, IsPosInt] );


#!	@Description
#!	A fan of a simplicial surface (with colouring) defines an orientation
#!	for an edge (equivalence class). By the right-hand-rule this defines an
#!	orientation for the set of incident faces as well. Since those faces are
#!	oriented as well we can determine which side of the face lies in the 
#!	correct direction.
#!	This method returns the name of this side of the face.
#!	@Arguments a simplicial surface (with colouring), a simplicial surface
#!		fan, a positive integer
#!	@Returns an integer
DeclareOperation( "FaceNameInducedByFan", 
	[IsColouredSimplicialSurface, IsSimplicialSurfaceFan, IsPosInt] );



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

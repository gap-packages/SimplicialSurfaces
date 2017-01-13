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
##		- a 
##

DeclareCategory( "IsSimplicialSurfaceFan",
					IsComponentObjectRep and IsAttributeStoringRep );


SimplicialSurfaceFanFamily := 
    NewFamily("SimplicialSurfaceFanFamily",  IsObject, IsSimplicialSurfaceFan);


#############################################################################
##
##
#!  @Section Constructors for fans
#!
#!
#!

#!	@Description
#!	Return a fan by defining all necessary attributes. Begin and End have to be
#!	different.
#!	The NC-version doesn't check if Begin and End are different.
#!	@Arguments two positive integers, one cyclic permutation
#!	@Returns a fan
DeclareOperation( "SimplicialSurfaceFan", [IsPosInt, IsPosInt, 
	IsPerm and IsCyclic]);
DeclareOperationNC( "SimplicialSurfaceFan", [IsPosInt, IsPosInt, 
	IsPerm and IsCyclic]);


#!	@Description
#!	Return the fan of the edge of a simplicial surface. For this to be unique
#!	at most two faces can be incident to the edge (otherwise the permutation
#!	of those is not unique). This is guaranteed to be the case if the simplicial
#!	surface is an actual surface.
#!	
#!	The NC-version doesn't check if there are at most two 
#!
#!	@Arguments a simplicial surface, a positive integer
#!	@Returns a fan
DeclareOperation( "SimplicialSurfaceFan", [IsSimplicialSurface, IsPosInt]);


#############################################################################
##
##
#!  @Section Attributes and properties of fans
#!
#!



#############################################################################
##
##
#!  @Section Functions for fans
#!
#!
#!



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

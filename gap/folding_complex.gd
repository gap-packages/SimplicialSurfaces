##############################################################################
##
#W  folding_complex.gd          SimplicialSurfaces           Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the declaration part for the folding complexes
##	of the SimplicialSurfaces package.
##
##	A folding complex consists of the following information:
##		- a SimplicialSurface that describes the underlying structure
##		- an equivalence relation on vertices, edges and faces that describes
##			which of those are folded together
##		- a fan for each edge equivalence class, i.e. a cycle of the incident
##			faces that depends on the orientation of the edge
##		- two face sides for each face equivalence class that describe the
##			borders of this equivalence class
##

DeclareCategory( "IsFoldingComplex",
					IsComponentObjectRep and IsAttributeStoringRep );


FoldingComplexFamily := 
    NewFamily("FoldingComplexFamily",  IsObject, IsFoldingComplex);


#############################################################################
##
##
#!  @Section Constructors for folding complexes
#!
#!
#!

#!	@Description
#!	Return a folding complex that is based on the given simplicial surface. All
#!	other properties are uniquely defined if we start with an actual surface.
#!	@Arguments a simplicial surface that is an actual surface
#!	@Returns a folding complex
DeclareOperation( "FoldingComplex", [IsSimplicialSurface and IsActualSurface]);


#!	@Description
#!	Return a folding complex that is based on the given simplicial surface.
#!	Furthermore we give some fans in form of a list that is indexed by the
#!	edges of the simplicial surface. If a fan is not given in this list, we
#!	try to define it uniquely by checking the surface. If this is not possible
#!	we throw an error.
#!	The NC-version doesn't check if the given list consists of fans that match
#!	the surface.
#!	@Arguments a simplicial surface and a list
#!	@Returns a folding complex
DeclareOperation( "FoldingComplex", [IsSimplicialSurface, IsList] );
DeclareOperation( "FoldingComplexNC", [IsSimplicialSurface, IsList] );


#!	@Description
#!	Return a folding complex that is based on the given simplicial surface with
#!	equivalence. Furthermore we give some fans in form of a list that is 
#!	indexed by the edge equivalence class numbers of the simplicial surface
#!	with equivalence. If a fan is not given in this list, we try to define it
#!	uniquely by checking the surface. If this is not possible we throw an error.
#!
#!	The NC-version doesn't check if the given list consists of fans that match
#!	the surface.
#!	@Arguments a simplicial surface with equivalence and a list
#!	@Returns a folding complex
DeclareOperation( "FoldingComplex", 
			[IsSimplicialSurfaceWithEquivalence, IsList] );
DeclareOperation( "FoldingComplexNC", 
			[IsSimplicialSurfaceWithEquivalence, IsList] );



#############################################################################
##
##
#!  @Section Attributes and properties of folding complexes
#!
#!



#############################################################################
##
##
#!  @Section Functions for folding complexes
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

##############################################################################
##
#W  folding_complex.gi          SimplicialSurfaces         Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##
##  The functions in this file compute with folding complexes.
##

##
##	We save the equivalences not by classes but by lists. For example
##	vertexEquivalenceImage is a list that is indiced by Vertices. At each
##	position is a number and the vertices that have the same number are in
##	the same equivalence class.
##
DeclareRepresentation("IsFoldingComplexRep", IsFoldingComplex,
     []);

##	accompanying type
FoldingComplexType := 
    NewType( FoldingComplexFamily, IsFoldingComplexRep );



#############################################################################
#############################################################################
##
##						Start of constructors
##
##
##	We start with the construction from a simplicial surface. For this we have
##	to implement some methods that construct the additional structures from
##	the given one. 
##

##	If the simplicial surface is not already known as an actual surface, we have
##	to check manually.
RedispatchOnCondition( FoldingComplex, true, [IsSimplicialSurface],
	[IsActualSurface], 0);
##
##
##							End of constructors
##
#############################################################################
#############################################################################


#!	@Description
#!	Return the underlying simplicial surface of this folding complex.
#!	@Arguments a folding complex
#!	@Returns a simplicial surface
InstallMethod( UnderlyingSimplicialSurface, "for a folding complex",
	[IsFoldingComplex],
	function( complex )
		return UnderlyingSimplicialSurfaceAttributeOfFoldingComplex(complex);
	end
);
InstallMethod( UnderlyingSimplicialSurfaceAttributeOfFoldingComplex, 
	"for a folding complex",
	[IsFoldingComplex and 
		HasUnderlyingSimplicialSurfaceWithEquivalenceAttributeOfFoldingComplex],
	function( complex )
		return UnderlyingSimplicialSurface(
					UnderlyingSimplicialSurfaceWithEquivalence(complex));
	end
);


#!	@Description
#!	Return the underlying simplicial surface with equivalence of this folding 
#!	complex.
#!	@Arguments a folding complex
#!	@Returns a simplicial surface with equivalence
InstallMethod( UnderlyingSimplicialSurfaceWithEquivalence, 
	"for a folding complex",
	[IsFoldingComplex],
	function( complex )
		return UnderlyingSSWEAttributeOfFoldingComplex(complex);
	end
);


#!	@Description
#!	Return the fans of this folding complex in the form of a list that is
#!	indexed by the edge equivalence class numbers of the underlying simplicial
#!	surface with equivalence.
#!	@Arguments a folding complex
#!	@Returns a list of fans
InstallMethod( Fans, "for a folding complex", [IsFoldingComplex],
	function( complex )
		return FansAttributeOfFoldingComplex(complex);
	end
);


#!	@Description
#!	Return the border pieces of this folding complex in the form of a list that 
#!	is indexed by the face equivalence class numbers of the underlying 
#!	simplicial surface with equivalence.
#!	@Arguments a folding complex
#!	@Returns a list of sets
InstallMethod( BorderPieces, "for a folding complex", [IsFoldingComplex],
	function( complex )
		return BorderPiecesAttributeOfFoldingComplex(complex);
	end
);


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

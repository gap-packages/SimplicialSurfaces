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
DeclareRepresentation("IsFoldingComplexRep", IsFoldingComplex, []);

##	accompanying type
FoldingComplexType := NewType( FoldingComplexFamily, IsFoldingComplexRep );



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
		HasUnderlyingCSSAttributeOfFoldingComplex],
	function( complex )
		return UnderlyingSimplicialSurface(
					UnderlyingColouredSimplicialSurface(complex));
	end
);


#!	@Description
#!	Return the underlying coloured simplicial surface of this folding 
#!	complex.
#!	@Arguments a folding complex
#!	@Returns a coloured simplicial surface
InstallMethod( UnderlyingColouredSimplicialSurface, 
	"for a folding complex",
	[IsFoldingComplex],
	function( complex )
		return UnderlyingCSSAttributeOfFoldingComplex(complex);
	end
);


#!	@Description
#!	Return the fans of this folding complex in the form of a list that is
#!	indexed by the edge equivalence class numbers of the underlying coloured
#!	simplicial surface.
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
#!	coloured simplicial surface.
#!	@Arguments a folding complex
#!	@Returns a list of sets
InstallMethod( BorderPieces, "for a folding complex", [IsFoldingComplex],
	function( complex )
		return BorderPiecesAttributeOfFoldingComplex(complex);
	end
);
# Try to compute border pieces with the specialized method (this might work
# since the specialized method works most of the times if the fans are set).
InstallMethod( BorderPiecesAttributeOfFoldingComplex, "for a folding complex", 
	[IsFoldingComplex],	
	function( complex )
		local borderPieces, faces, face, border;

		faces := FaceEquivalenceNumbersAsSet( 
					UnderlyingColouredSimplicialSurface(complex) );
		borderPieces := [];
		for face in faces do
			# Try to compute the border
			#border := #TODO ( complex, face );
			
		od;

		return borderPieces;
	end
);



#!	@Description
#!	Return the fan of an edge equivalence class of this folding complex.
#!	The NC-version doesn't check if the given number actually represents
#!	a face equivalence class.
#!	@Arguments a folding complex and a positive integer
#!	@Returns a fan
InstallMethod( FanOfEdgeEquivalenceClassNC, 
	"for a folding complex and a positive integer", 
	[IsFoldingComplex, IsPosInt],
	function( complex, edgeClass )
		return Fans(complex)[edgeClass];
	end
);
InstallMethod( FanOfEdgeEquivalenceClass, 
	"for a folding complex and a positive integer", 
	[IsFoldingComplex, IsPosInt],
	function( complex, edgeClass )
		if not edgeClass in EdgeEquivalenceNumbersAsSet( 
				UnderlyingColouredSimplicialSurface( complex ) ) then
			return Error("FanOfEdgeEquivalenceClass: Given number has to represent an edge equivalence class.");
		fi;
		return Fans(complex)[edgeClass];
	end
);


#!	@Description
#!	Return the border pieces of a face equivalence class of this folding 
#!	complex as a set.
#!	The NC-version doesn't check if the given number actually represents
#!	a face equivalence class.
#!	@Arguments a folding complex and a positive integer
#!	@Returns a sets of integers 
InstallMethod( BorderPiecesOfFaceEquivalenceClassNC, 
	"for a folding complex and a positive integer", 
	[IsFoldingComplex, IsPosInt],
	function( complex, faceClass )
		return BorderPieces(complex)[faceClass];
	end
);
InstallMethod( BorderPiecesOfFaceEquivalenceClass, 
	"for a folding complex and a positive integer", 
	[IsFoldingComplex, IsPosInt],
	function( complex, faceClass )
		if not faceClass in FaceEquivalenceNumbersAsSet( 
				UnderlyingColouredSimplicialSurface( complex ) ) then
			return Error("BorderPiecesOfFaceEquivalenceClass: Given number has to represent a face equivalence class.");
		fi;
		return BorderPieces(complex)[faceClass];
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

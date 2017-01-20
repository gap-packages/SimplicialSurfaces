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
##	A central method is the finding of border pieces by using fans.
##	Given are a folding complex and a face equivalence class number. The method
##	checks for each adjacent fan which oriented faces are "recognizes border
##	pieces". It then returns the union of those. In the general case, exactly
##	two border pieces will be found. If the face equivalence class is its own
##	connected component, no border pieces will be found. If more than two
##	border pieces are found, something has gone wrong.
__SIMPLICIAL_RecognizeBorderPieces := function( complex, faceEqNr )
	local colSurf, faceClass, edgeClassNrs, recBorders, edgeNr, orFace, face;

	colSurf := UnderlyingColouredSimplicialSurface( complex );
	faceClass := FaceEquivalenceClassByNumber( colSurf, faceEqNr );
	edgeClassNrs := FacesByEdges(QuotientSimplicialSurface(colSurf))[faceEqNr];

	recBorders := [];
	for edgeNr in edgeClassNrs do
		for face in faceClass do
			for orFace in NamesOfFaceNC( 
					UnderlyingSimplicialSurface( complex ), face ) do
				if not IsEquivalentFace( colSurf, face, 
					ApplyFanToOrientedFaceNC( complex, edgeNr, orFace ) ) then
						Append(recBorders, [orFace]);
				fi;
			od;
		od;
	od;

	return Set(recBorders);
end;

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


#!	@Description
#!	Apply a fan of a folding complex to an oriented face. This is defined
#!	in the following way: Each oriented face defines an orientation around
#!	the adjacent edges. The fan of this edge has a cycle for each such
#!	orientation. We return the image of the given face (not an equivalence
#!	class!) under this cycle.
#!	The NC-version doesn't check if the given numbers refer to an oriented
#!	face and an edge equivalence class.
#!	@Arguments a folding complex, an integer and a positive integer
#!	@Returns a positive integer
InstallMethod( ApplyFanToOrientedFaceNC, 
	"for a folding complex, an edge equivalence class number and an oriented face",
	[IsFoldingComplex, IsPosInt, IsInt],
	function( complex, edgeClassNr, orFace )
		local simpSurf, face, fan, faceOrient;

		simpSurf := UnderlyingSimplicialSurface( complex );
		face := FaceByName( simpSurf, orFace );
		fan := FanOfEdgeEquivalenceClassNC( complex, edgeClassNr );

		# find the correct orientation of the face
		if NamesOfFaceNC(simpSurf,face)[1] = orFace then
			faceOrient := LocalOrientation(simpsurf)[face];
		else
			faceOrient := LocalOrientation(simpsurf)[face]^(-1);
		fi;

		if BeginOfFan(fan)^faceOrient = EndOfFan(fan) then
			return face^PermutationOfFan(fan);
		else
			return face^PermutationOfFan( InverseOfFan( fan ) );
		fi;
		
	end
);
InstallMethod( ApplyFanToOrientedFace, 
	"for a folding complex, an edge equivalence class number and an oriented face",
	[IsFoldingComplex, IsPosInt, IsInt],
	function( complex, edgeClassNr, orFace )
		# Check the edge class
		if not edgeClassNr in EdgeEquivalenceNumbersAsSet( 
						UnderlyingColouredSimplicialSurface( complex ) ) then
			Error("Second number has to be an edge equivalence class number.");
		fi;

		# The oriented face is checked automatically if FaceByName is called
		return ApplyFanToOrientedFace( complex, edgeClassNr, orFace );
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

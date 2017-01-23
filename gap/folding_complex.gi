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

##
##	Furthermore, we need methods to check if fans and border pieces fit
##	together. First we check whether the fans of two edge classes are
##	compatible (see definition 3.18)
__SIMPLICIAL_AreFansCompatible := function( complex, edge1, edge2 )
	local fan1, fan2, corInt;

	fan1 := Fans(complex)[edge1];
	fan2 := Fans(complex)[edge2];

	# First we calculate the intersection between the coronae
	corInt := Intersection( CoronaOfFan(fan1), CoronaOfFan(fan2) );
	if IsEmpty(corInt) then
		return true;	# fans with disjoint coronae are compatible
	fi;

	# Next we have to consider the reducts of the fans to this intersection
	red1 := ReducedFan( fan1, corInt );
	red2 := ReducedFan( fan2, corInt );

	# We have to make sure that both are oriented equally. This interaction
	# can be described if corInt is not empty. We choose one element from this
	# intersection and determine whether both fans define the same surface of
	# this face. If they do, they are compatible if and only if their
	# permutations are equal. If they define different surfaces we have to
	# invert one of them before we make this comparison.
	sur1 := FaceOrientationInducedByFan( 
			UnderlyingColouredSimplicialSurface(complex), fan1, corInt[1] );
	sur2 := FaceOrientationInducedByFan( 
			UnderlyingColouredSimplicialSurface(complex), fan2, corInt[1] );
	if sur1 = sur2 then
		return PermutationOfFan(fan1) = PermutationOfFan(fan2);
	else
		return PermutationOfFan(fan1) = PermutationOfFan( InverseOfFan(fan2) );
	fi;
end;

##
##	The final consistency method checks whether the border pieces that are
##	adjacent to a given fan decompose into pairs of complementary border
##	pieces. Two oriented surfaces are called complementary with respect to
##	a given fan if the application of the fan to one of them gives the other
##	one as a result.
__SIMPLICIAL_AreBorderPiecesComplementary := function( complex, edge )
	local fan, colSurf, faceNumbers, b;

	# Determine the fan
	fan := Fans(complex)[edge];

	# Find the face equivalence numbers that are adjacent to the fan
	colSurf := UnderlyingColouredSimplicialSurface(complex);
	faceNumbers := Set( List( CoronaOfFan(fan), f -> 
								FaceEquivalenceNumberByElement(colSurf, f) ) );
	
	# Find all border pieces that are adjacent to the fan
	borders := Set( List( faceNumbers, n -> BorderPieces(complex)[n] ) );

	# Check whether the border pieces fall into complementary pairs
	surface := UnderlyingSimplicialSurface( complex );
	while not IsEmpty(borders) do
		b := borders[1];
		# Find complement of b
		image := ApplyFanToOrientedFaceNC( complex, edge, b);
		orImages := NamesOfFaceNC( surface, image );
		for im in orImages do
			# One of the sides has to be the complement
			if ApplyFanToOrientedFaceNC( complex, edge, im) = b then
				if not im in borders then
					return false;
				else
					borders := Difference( borders, Set([b,im]) );
				fi;
			fi;
		od;
	od;

	return true;
end;

#!	@Description
#!	Return a folding complex that is based on the given simplicial surface. All
#!	other properties are uniquely defined if we start with an actual surface.
#!	@Arguments a simplicial surface that is an actual surface
#!	@Returns a folding complex
InstallMethod( FoldingComplex, "for a simplicial surface", 
	[IsSimplicialSurface and IsActualSurface],
	function( surface )
		return FoldingComplexByFansNC( surface, [] );
	end
);

##	If the simplicial surface is not already known as an actual surface, we have
##	to check manually.
RedispatchOnCondition( FoldingComplex, true, [IsSimplicialSurface],
	[IsActualSurface], 0);


#!	@Description
#!	Return a folding complex that is based on the given (coloured) simplicial 
#!	surface. Furthermore we give some fans in form of a list that is 
#!	indexed by the edge equivalence class numbers of the coloured simplicial 
#!	surface. If a fan is not given in this list, we try to define it
#!	uniquely by checking the surface. If this is not possible we throw an error.
#!
#!	The NC-version doesn't check if the given list consists of fans that match
#!	the surface.
#!	@Arguments a coloured simplicial surface and a list
#!	@Returns a folding complex
InstallOtherMethod( FoldingComplexByFansNC, 
	"for a simplicial surface and a list of fans",
	[IsSimplicialSurface, IsList],
	function( surface, fanList )
		local complex, edge, fans;

		# Initialize the object
		complex := Objectify( FoldingComplexType, rec() );

		SetUnderlyingSimplicialSurfaceAttributeOfFoldingComplex( complex, 
				surface );

		SetUnderlyingCSSAttributeOfFoldingComplex( complex, 
							ColouredSimplicialSurface( surface ) );
		
		# construct fans
		fans := [];
		for edge in Edges( surface ) do
			if IsBound( fanList[edge] ) then
				fans[edge] := fanList[edge];
			else
				fans[edge] := SimplicialSurfaceFanByEdgeInSimplicialSurface( 
															surface, edge );
			fi;
		od;
		SetFansAttributeOfFoldingComplex( complex, fans );

		# all possible border pieces are border pieces in an actual surface
		SetBorderPiecesAttributeOfFoldingComplex( complex, 
							List( NamesOfFaces(surface), i -> Set(i) ) );

		return complex;
	end
);
InstallOtherMethod( FoldingComplexByFans, 
	"for a simplicial surface and a list of fans",
	[IsSimplicialSurface, IsList],
	function( surface, fanList )
		local edge, fan;

		for edge in Edges(surface) do
			if IsBound( fanList[edge] ) then
				fan := fanList[edge];
	
				if not IsEdgeForFanOfSimplicialSurface( surface, fan, edge ) then
					Error("FoldingComplexByFans: One of the given fans is not valid for this simplicial surface.");
				fi;
			fi;
		od;

		return FoldingComplexByFansNC( surface, fanList );
	end
);
InstallMethod( FoldingComplexByFansNC, 
	"for a coloured simplicial surface and a list of fans",
	[IsColouredSimplicialSurface, IsList],
	function( surface, fanList )
		local complex, edge, fans, borders, face, tryBorder;

		return FoldingComplexByFansAndBordersNC( surface, fanList, [] );
	end
);
InstallMethod( FoldingComplexByFans, 
	"for a coloured simplicial surface and a list of fans",
	[IsColouredSimplicialSurface, IsList],
	function( surface, fanList )
		local edge, fan;

		for edge in EdgeEquivalenceNumbersAsSet(surface) do
			if IsBound( fanList[edge] ) then
				fan := fanList[edge];
	
				if not IsEdgeEquivalenceNumberForFanOfColouredSimplicialSurface(
								 surface, fan, edge ) then
					Error("FoldingComplexByFans: One of the given fans is not valid for this coloured simplicial surface.");
				fi;
			fi;
		od;

		return FoldingComplexByFansNC( surface, fanList );
	end
);

#!	@Description
#!	Return a folding complex that is based on the given coloured simplicial 
#!	surface. Furthermore we give some fans in form of a list that is 
#!	indexed by the edge equivalence class numbers of the coloured simplicial 
#!	surface. If a fan is not given in this list, we try to define it
#!	uniquely by checking the surface. If this is not possible we throw an error.
#!	We also give a list of border pieces, i.e. a list that is indexed by the 
#!	face equivalence classes and consists of sets.
#!
#!	The NC-version doesn't check if the given lists consists of fans that match
#!	the surface or of border pieces that match the fans.
#!	@Arguments a coloured simplicial surface and two lists
#!	@Returns a folding complex
InstallMethod( FoldingComplexByFansAndBordersNC, 
	"for a coloured simplicial surface and a list of fans",
	[IsColouredSimplicialSurface, IsList, IsList],
	function( surface, fanList, borderList )
		local complex, edge, fans, borders, face, tryBorder;

		# Initialize the object
		complex := Objectify( FoldingComplexType, rec() );

		SetUnderlyingCSSAttributeOfFoldingComplex( complex, surface );
		
		# construct fans
		fans := [];
		for edge in EdgeEquivalenceNumbersAsSet( surface ) do
			if IsBound( fanList[edge] ) then
				fans[edge] := fanList[edge];
			else
				fans[edge] := 
					SimplicialSurfaceFanByEdgeInColouredSimplicialSurface( 
															surface, edge );
			fi;
		od;
		SetFansAttributeOfFoldingComplex( complex, fans );

		# try to find the border pieces by using the fans
		borders := [];
		for face in FaceEquivalenceNumbersAsSet( surface ) do
			if IsBound( borderList[face] ) then
				borders[face] := borderList[face];
			else
				tryBorder := __SIMPLICIAL_RecognizeBorderPieces( complex, face );
				if Length( tryBorder ) = 0 then
					Error("FoldingComplexByFansAndBorders: No border pieces detected: Please use FoldingComplexByFansAndBorders instead.");
				elif Length( tryBorder ) <> 2 then
					Error("FoldingComplexByFansAndBorders: Illegal configuration since recognized border pieces are not correct.");
				else
					borders[face] := tryBorder;
				fi;
			fi;
		od;
		SetBorderPiecesAttributeOfFoldingComplex( complex, borders );

		return complex;
	end
);
InstallMethod( FoldingComplexByFansAndBorders, 
	"for a coloured simplicial surface, a list of fans and a list of sets border pieces",
	[IsColouredSimplicialSurface, IsList, IsList],
	function( surface, fanList, borderList )
		local edge, fan, faceClassNr, borders, faceClass, possBorders;

		# Check the fans
		for edge in EdgeEquivalenceNumbersAsSet(surface) do
			if IsBound( fanList[edge] ) then
				fan := fanList[edge];
	
				if not IsEdgeEquivalenceNumberForFanOfColouredSimplicialSurface(
								 surface, fan, edge ) then
					Error("FoldingComplexByFansAndBorders: One of the given fans is not valid for this coloured simplicial surface.");
				fi;
			fi;
		od;

		# Check the border pieces
		for faceClassNr in FaceEquivalenceNumbersAsSet(surface) do
			if IsBound( borderList[faceClassNr] ) then
				borders := borderList[faceClassNr];
				if not IsSet(borders) then
					Error("FoldingComplexByFansAndBorders: One element in the border list is not a set.");
				fi;
				if Length(borders) <> 2 then
					Error("FoldingComplexByFansAndBorders: The sets of borders have to contain exactly two elements.");
				fi;
				# Check if the borders are possible
				faceClass := FaceEquivalenceClassByNumber(surface, faceClassNr);
				possBorders := Union( faceClass, f -> NamesOfFace( 
					UnderlyingSimplicialSurface( surface ), f ) );
				if not IsSubset( possBorders, borders ) then
					Error("FoldingComplexByFansAndBorders: Some borders are incompatible with this coloured simplicial suface.");
				fi;
			fi;
		od;

		return FoldingComplexByFansAndBordersNC(surface, fanList, borderList);
	end
);

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
		local surface, face, fan, faceOrient;

		surface := UnderlyingSimplicialSurface( complex );
		face := FaceByName( surface, orFace );
		fan := FanOfEdgeEquivalenceClassNC( complex, edgeClassNr );

		# find the correct orientation of the face
		if NamesOfFaceNC(surface,face)[1] = orFace then
			faceOrient := LocalOrientation(surface)[face];
		else
			faceOrient := LocalOrientation(surface)[face]^(-1);
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

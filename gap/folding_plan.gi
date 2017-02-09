##############################################################################
##
#W  folding_plan.gi          SimplicialSurfaces           Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the implementation part for the folding plans of the 
##	SimplicialSurfaces package. A folding plan consists of an identification
##	and two oriented faces belongig to the identified faces.
##
##

##
##	We use a representation that doesn't do much.
##
DeclareRepresentation("IsFoldingPlanRep", IsFoldingPlan, []);

##	accompanying type
FoldingPlanType := NewType( FoldingPlanFamily, IsFoldingPlanRep );


#############################################################################
#############################################################################
##
##						Start of constructors
##
##


#!	@Description
#!	Return a folding plan based on an identification and a list of two 
#!	oriented faces (integers).
#!	The NC-version doesn't check whether the list actually consists of exactly
#!	two integers.
#!	@Arguments a simplicial surface identification, a tuple of integers
#!	@Returns a folding plan
InstallMethod( FoldingPlanByIdentificationNC,
	"for a simplicial surface identification and a list of two integers", 
	[IsSimplicialSurfaceIdentification, IsList],
	function( id, orFaceList )
		local plan, source, image, relation, map;

		plan := Objectify( FoldingPlanType, rec() );
		SetIdentificationAttributeOfFoldingPlan( plan, id );

		source := Domain( [ orFaceList[1] ] );
		image := Domain( [ orFaceList[2] ] );
		relation := [ DirectProductElement(orFaceList) ];
		map := GeneralMappingByElements( source, image, relation);

		SetOrientedFaceMapAttributeOfFoldingPlan( plan, map );

		return plan;
	end
);
InstallMethod( FoldingPlanByIdentification,
	"for a simplicial surface identification and a list of two integers", 
	[IsSimplicialSurfaceIdentification, IsList],
	function( id, orFaceList )
		if Length( orFaceList ) <> 2 then
			Error("FoldingPlanByIdentification: List of oriented faces has to contain exactly two faces.");
		fi;
		if not IsInt(orFaceList[1]) or not IsInt(orFaceList[2]) then
			Error("FoldingPlanByIdentification: Oriented faces have to be given as integers.");
		fi;

		return FoldingPlanByIdentificationNC(id, orFaceList);
	end
);

#!	@Description
#!	Return a folding plan based on four maps. The first three define the
#!	identification, the last one is the oriented face map.
#!
#!	The NC-version doesn't check whether the number of elements in these 
#!	maps match (3 vertices, 3 edges, 1 face, 1 oriented face).
#!
#!	@Arguments four bijective maps: for vertices, edges, faces and oriented
#!		faces
#!	@Returns a folding plan
InstallMethod( FoldingPlanByMapsNC, "for four bijective maps", 
	[IsMapping and IsBijective, IsMapping and IsBijective, 
		IsMapping and IsBijective, IsMapping and IsBijective],
	function( vertexMap, edgeMap, faceMap, orFaceMap )
		local id, plan;

		id := SimplicialSurfaceIdentificationNC( vertexMap, edgeMap, faceMap );
		
		plan := Objectify( FoldingPlanType, rec() );
		SetIdentificationAttributeOfFoldingPlan( plan, id );
		SetOrientedFaceMapAttributeOfFoldingPlan( plan, orFaceMap );

		return plan;
	end
);
RedispatchOnCondition( FoldingPlanByMapsNC, true, 
	[IsMapping, IsMapping, IsMapping, IsMapping], 
	[IsBijective, IsBijective, IsBijective, IsBijective], 0 );

InstallMethod( FoldingPlanByMaps, "for four bijective maps", 
	[IsMapping and IsBijective, IsMapping and IsBijective, 
		IsMapping and IsBijective, IsMapping and IsBijective],
	function( vertexMap, edgeMap, faceMap, orFaceMap )
		local id, plan;

		id := SimplicialSurfaceIdentification( vertexMap, edgeMap, faceMap );

		if Length( Source( orFaceMap ) ) <> 1 then
			Error("FoldingPlanByMaps: Only one oriented face");
		fi;
	#TODO check whether orFaceMap really only consists of integers
		
		plan := Objectify( FoldingPlanType, rec() );
		SetIdentificationAttributeOfFoldingPlan( plan, id );
		SetOrientedFaceMapAttributeOfFoldingPlan( plan, orFaceMap );

		return plan;
	end
);
RedispatchOnCondition( FoldingPlanByMaps, true, 
	[IsMapping, IsMapping, IsMapping, IsMapping], 
	[IsBijective, IsBijective, IsBijective, IsBijective], 0 );


#!	@Description
#!	Return a folding plan that is constructed from four lists. The vertex-list 
#!	has the form [[p_1,q_1],[p_2,q_2],[p_3,q_3]] and corresponds to the map 
#!	p_i -> q_i. Analogously for the other three lists.
#!
#!	The NC-version does not check if the lists fulfill this format or if the
#!	number of elements match or if the resulting maps are bijective.
#!
#!	@Arguments three lists of tuples of positive integers, one list of tuples
#!		of integers
#!	@Returns a folding plan
InstallMethod( FoldingPlanByListsNC, "for four lists", 
	[IsList,IsList,IsList,IsList],
	function( vertexList, edgeList, faceList, orFaceList )
		local id, plan;

		id := SimplicialSurfaceIdentificationByListsNC( 
										vertexList, edgeList, faceList );
		
		plan := Objectify( FoldingPlanType, rec() );
		SetIdentificationAttributeOfFoldingPlan( plan, id );
		SetOrientedFaceMapAttributeOfFoldingPlan( plan, 
					__SIMPLICIAL_CreateMapFromListNC(orFaceList, false) );

		return plan;
	end
);
InstallMethod( FoldingPlanByLists, "for four lists", 
	[IsList,IsList,IsList,IsList],
	function( vertexList, edgeList, faceList, orFaceList )
		local id, plan, map;

		id := SimplicialSurfaceIdentificationByLists( 
										vertexList, edgeList, faceList );
		
		plan := Objectify( FoldingPlanType, rec() );
		SetIdentificationAttributeOfFoldingPlan( plan, id );

		# Check whether the list is well defined
		if Length(orFaceList) <> 1 or not IsList( orFaceList[1] ) or
			 Length( orFaceList[1] ) <> 2 or not IsInt( orFaceList[1][1] ) or
			not IsInt(orFaceList[1][2]) then
			Error("FoldingPlanByLists: The list for oriented faces has to consist of a single tuple of integers.");
		fi;

		SetOrientedFaceMapAttributeOfFoldingPlan( plan, 
					__SIMPLICIAL_CreateMapFromListNC(orFaceList, false) );

		return plan;
	end
);



##
##
##							End of constructors
##
#############################################################################
#############################################################################


#!	@Description
#!	Return the oriented face map.
#!	@Arguments a folding plan
#!	@Returns a bijective map
InstallMethod( OrientedFaceMap, "for a folding plan", [IsFoldingPlan],
	function( plan )
		return OrientedFaceMapAttributeOfFoldingPlan(plan);
	end
);


#!	@Description
#!	Return the identification a folding plan is based on.
#!	@Arguments a folding plan
#!	@Returns a simplicial surface identification
InstallMethod( Identification, "for a folding plan", [IsFoldingPlan],
	function( plan )
		return IdentificationAttributeOfFoldingPlan(plan);
	end
);


#!	@Description
#!	Return the vertex map.
#!	@Arguments a folding plan
#!	@Returns a bijective map
InstallMethod( VertexMap, "for a folding plan", [IsFoldingPlan],
	function( plan )
		return VertexMap( Identification( plan ) );
	end
);


#!	@Description
#!	Return the edge map.
#!	@Arguments a folding plan
#!	@Returns a bijective map
InstallMethod( EdgeMap, "for a folding plan", [IsFoldingPlan],
	function( plan )
		return EdgeMap( Identification( plan ) );
	end
);


#!	@Description
#!	Return the face map.
#!	@Arguments a folding plan
#!	@Returns a bijective map
InstallMethod( FaceMap, "for a folding plan", [IsFoldingPlan],
	function( plan )
		return FaceMap( Identification( plan ) );
	end
);


#!	@Description
#!	Return if the given folding plan is well-defined with respect to the given 
#!	simplicial surface.
#!	This method checks if the maps of the identification can be applied to
#!	the vertices, edges and faces of the underlying simplicial surface. It also
#!	checks whether the maps are compatible with each other, i.e. if they
#!	commute with the incidence relation of the simplicial surface.
#!	Finally it checks whether the oriented faces are face names of the given
#!	faces.
#!	@Arguments a folding complex, a folding pla
#!	@Returns true or false
InstallMethod( IsWellDefinedFoldingPlan, 
	"for a simplicial surface and a folding plan", 
	[IsSimplicialSurface, IsFoldingPlan],
	function( surface, plan )
		local faceMap, orFaceMap;

		if not IsWellDefinedIdentification( surface, Identification(plan) ) then
			return false;
		fi;

		faceMap := FaceMap(plan);
		orFaceMap := OrientedFaceMap(plan);
		if not Elements(Source(faceMap))[1] = 
				FaceByName( surface, Elements(Source(orFaceMap))[1] ) then
			return false;
 		fi;
		if not Elements(Range(faceMap))[1] = 
				FaceByName( surface, Elements(Range(orFaceMap))[1] ) then
			return false;
 		fi;

		return true;
	end
);
InstallOtherMethod( IsWellDefinedFoldingPlan, 
	"for a folding complex and a folding plan", 
	[IsFoldingComplex, IsFoldingPlan],
	function( surface, plan )
		return IsWellDefinedFoldingPlan( 
						UnderlyingSimplicialSurface(surface), plan );
	end
);


#!	@Description
#!	Return whether the given folding plan can be applied to the given folding
#!	complex. This method only checks the formal qualifiers from definition
#!	3.71 in my master thesis. It does not check whether the application of
#!	this folding plan actually yields a proper folding complex. TODO fix this
#!
#!	The NC-version does not check whether the given folding plan is well
#!	defined with respect to the given folding complex.
#!
#!	@Arguments a folding complex, a folding plan
#!	@Returns true or false
InstallMethod( IsApplicableFoldingPlan, 
	"for a folding complex and a folding plan", 
	[IsFoldingComplex, IsFoldingPlan],
	function( complex, plan )
		local surface;

		surface := UnderlyingSimplicialSurface(complex);
		if not IsWellDefinedFoldingPlan( surface, plan ) then
			return false;
		fi;

		return IsApplicableFoldingPlanNCWellDefined(complex, plan);
	end
);
InstallMethod( IsApplicableFoldingPlanNCWellDefined, 
	"for a folding complex and a folding plan", 
	[IsFoldingComplex, IsFoldingPlan],
	function( complex, plan )
		local colSurf, id, orFace1, orFace2, face1, face2, faceNr1, faceNr2,
			quotSurf, edgeNrs1, edgeNrs2, edgeNr;
	
		# First we have to check whether the identification of the folding
		# plan leads to a coloured simplicial surface
		colSurf := UnderlyingColouredSimplicialSurface( complex );
		id := Identification(plan);
		if not IsApplicableExtensionNCWellDefined( colSurf, id ) then
			return false;
		fi;

		# We have to check that the elements in the oriented face map are
		# border pieces of the folding complex
		orFace1 := Elements(Source(OrientedFaceMap(plan)))[1];
		orFace2 := Elements(Source(OrientedFaceMap(plan)))[2];

		face1 := Elements(Source(FaceMap(plan)))[1];
		face2 := Elements(Source(FaceMap(plan)))[2];

		faceNr1 := FaceEquivalenceNumberOfElement( colSurf, face1 );
		faceNr2 := FaceEquivalenceNumberOfElement( colSurf, face2 );

		if not orFace1 in BorderPieces(complex)[faceNr1] or 
				not orFace2 in BorderPieces(complex)[faceNr2] then
			return false;
		fi;

		
		# Finally we have to check whether the elements in the oriented face
		# map are complementary with respect to each fan in which they both
		# are present
		quotSurf := QuotientSimplicialSurface(colSurf);
		edgeNrs1 := FacesByEdges(quotSurf)[faceNr1];
		edgeNrs2 := FacesByEdges(quotSurf)[faceNr2];

		for edgeNr in Intersection(edgeNrs1, edgeNrs2 ) do
			if orFace2 <> ComplementaryOrientedFace(complex,edgeNr,orFace1) then
				return false;
			fi;
		od;


		return true;
	end
);

#!	@Description
#!	Apply the folding plan to the folding complex. This method returns fail
#!	if this is not possible or if the application does not yield a proper
#!	folding complex. Otherwise return the new folding complex.
#!
#!	The NC-version does not check IsApplicableFoldingPlan before constructing
#!	the result.
#!
#!	@Arguments a folding complex, a folding plan
#!	@Returns a folding complex or fail
InstallMethod( ApplyFoldingPlan, 
	"for a folding complex and a folding plan", 
	[IsFoldingComplex, IsFoldingPlan],
	function( complex, plan )
		if not IsApplicableFoldingPlan( complex, plan ) then
			return false;
		fi;

		return ApplyFoldingPlanNCApplicable(complex, plan);
	end
);
InstallMethod( ApplyFoldingPlanNCWellDefined, 
	"for a folding complex and a folding plan", 
	[IsFoldingComplex, IsFoldingPlan],
	function( complex, plan )
		if not IsApplicableFoldingPlanNCWellDefined( complex, plan ) then
			return false;
		fi;

		return ApplyFoldingPlanNCApplicable(complex, plan);
	end
);
InstallMethod( ApplyFoldingPlanNCApplicable, 
	"for a folding complex and a folding plan", 
	[IsFoldingComplex, IsFoldingPlan],
	function( complex, plan )
		local newColSurf, newFoldingComplex, colSurf, id, newBorder, faceNr1,	
			faceNr2, oldBorder1, oldBorder2, newFans, testEdges, edgeNr, edgeIm,
			edgeClassNr1, edgeClassNr2, fan1, fan2, face1, orFace1, baseEx1,
			baseEx2, permA, permB, permMix, newFan, goneBorders;

		colSurf := UnderlyingColouredSimplicialSurface( complex );
		id := Identification(plan);
		newColSurf := ExtendByIdentificationNC( colSurf, id );

		# Next we modify the border pieces
		newBorder := ShallowCopy( BorderPieces( complex ) );
		faceNr1 := FaceEquivalenceNumberOfElement( colSurf, 
										Elements(Source(FaceMap(id)))[1] );
		faceNr2 := FaceEquivalenceNumberOfElement( colSurf, 
										Elements(Source(FaceMap(id)))[2] );

		if faceNr1 <> faceNr2 then
			oldBorder1 := BorderPieces(complex)[faceNr1];
			oldBorder2 := BorderPieces(complex)[faceNr2];

			goneBorders := Union( Elements(Source( OrientedFaceMap(plan) ) ), 
									Elements(Range(OrientedFaceMap(plan))) );
			newBorder[ faceNr1 ] := Difference( Union( oldBorder1, oldBorder2 ), 
																goneBorders );
		
			Unbind(newBorder[ faceNr2 ]);
		fi;


		# Finally we modify the fans
		newFans := ShallowCopy( Fans( complex ) );
		testEdges := [];
		for edgeNr in Source( EdgeMap( id ) ) do
			edgeIm := Image( EdgeMap(id), edgeNr );

			edgeClassNr1 := EdgeEquivalenceNumberOfElement(colSurf, edgeNr);
			edgeClassNr2 := EdgeEquivalenceNumberOfElement(colSurf, edgeIm);
			if edgeClassNr1 = edgeClassNr2 then
				continue;
			fi;

			fan1 := Fans(complex)[edgeClassNr1];
			fan2 := Fans(complex)[edgeClassNr2];

			# Check whether these fans have the same orientation
			baseEx1 := VertexEquivalenceClassByNumber( colSurf, 
														BeginOfFan(fan1) )[1];
			baseEx1 := VertexEquivalenceClassByNumber( colSurf, 
														BeginOfFan(fan2) )[1];
			if not IsEquivalentVertex( newColSurf, baseEx1, baseEx2 ) then
				fan2 := InverseOfFan(fan2);
			fi;

			# Check whether the oriented face of the first fan looks in the
			# induced rotation direction of this fan
			face1 := Elements(Source(FaceMap(id)))[1];
			orFace1 := Elements(Source(OrientedFaceMap(plan)))[1];
			if FaceNameInducedByFan(colSurf, fan1, face1 ) <> orFace1 then
				fan1 := InverseOfFan(fan1);
				fan2 := InverseOfFan(fan2);
			fi;

			# Finally we perform the fan summation. Let the permutation of the
			# first fan be (a_1,a_2,...,a_m) and the permutation of the second
			# fan (b_1,b_2,...,b_n). If we sum at the points a_1 and b_1, the 
			# fan sum will have the permutation (a_1,b_1,...,b_n,a_2,...,a_m).
			# To get there we have to calculate the permutation
			# (a_1,...,a_m)*(b_1,...,b_n)*(a_2,b_1) [try example in GAP to see
			# why this ordering is correct].
			permA := PermutationOfFan(fan1);
			permB := PermutationOfFan(fan2);
			permMix := ( face1^permA, Elements(Range(FaceMap(id)))[1] );
	
			# Start and end of the new fan are those from fan1 since their 
			# labels will still be valid after the extension by the 
			# identification
			newFan := SimplicialSurfaceFanNC( BeginOfFan(fan1), EndOfFan(fan1), 
													permA*permB*permMix );

			newFans[ edgeClassNr1 ] := newFan;
			Append( testEdges, [edgeClassNr1] );
			Unbind(newFans[edgeClassNr2] );
		od;


		# Finally we construct the new folding complex
		newFoldingComplex := 
			FoldingComplexByFansAndBordersNC( newColSurf, newFans, newBorder );

		# Unfortunately we have to check whether the fans of this folding
		# complex are compatible with each other. We did not perform this check
		# in the constructor as it is only necessary to do so for the modified
		# fans.
		if not __SIMPLICIAL_IsSetOfFansConsistentColoured( newFoldingComplex,
			testEdges, "") then
			return fail;
		fi;


		return newFoldingComplex;
	end
);

#############################################################################
##
#!  @Description
#!  Check if two folding plans are equal.
#!  @Returns true or false
#!  @Arguments <s1>, <s2>, two folding plan objects
#!
##
InstallMethod( \=, "for two folding plans", IsIdenticalObj, 
  [ IsFoldingPlan, IsFoldingPlan ],
	function( s1, s2 )
		# check all basic attributes

		if Identification(s1) <> Identification(s2) then
			return false;
		fi;
		if OrientedFaceMap(s1) <> OrientedFaceMap(s2) then
			return false;
		fi;

        return true;
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

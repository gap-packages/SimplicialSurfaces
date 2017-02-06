##############################################################################
##
#W  simplicial_surface_identification.gi         SimplicialSurfaces         Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##
##  The functions in this file compute with simplicial surface identifications.
##

##
##	We use a representation that doesn't do much.
##
DeclareRepresentation("IsSimplicialSurfaceIdentificationRep",
	 IsSimplicialSurfaceIdentification, []);

##	accompanying type
SimplicialSurfaceIdentificationType := 
    NewType( SimplicialSurfaceIdentificationFamily,
			IsSimplicialSurfaceIdentificationRep );



#############################################################################
#############################################################################
##
##						Start of constructors
##
##

#!	@Description
#!	Return a simplicial surface identification based on three maps.
#!	@Arguments three bijective maps: for vertices, edges and faces
#!	@Returns a simplicial surface identification
InstallMethod( SimplicialSurfaceIdentificationNC,
	"for three bijective maps", [IsMapping and 
		IsBijective, IsMapping and IsBijective, IsMapping and IsBijective],
	function( vertexMap, edgeMap, faceMap )
		local id;

		id := Objectify( SimplicialSurfaceIdentificationType, rec() );
		SetVertexMapAttributeOfSimplicialSurfaceIdentification( id, vertexMap);
		SetEdgeMapAttributeOfSimplicialSurfaceIdentification( id, edgeMap);
		SetFaceMapAttributeOfSimplicialSurfaceIdentification( id, faceMap);

		return id;
	end
);
RedispatchOnCondition( SimplicialSurfaceIdentificationNC, true, 
	[IsMapping,	IsMapping, IsMapping], 
	[IsBijective, IsBijective, IsBijective], 0 );
RedispatchOnCondition( SimplicialSurfaceIdentificationNC, true, 
	[IsGeneralMapping, IsGeneralMapping, IsGeneralMapping], 
	[IsMapping,	IsMapping, IsMapping], 0 );

InstallMethod( SimplicialSurfaceIdentification,
	"for three bijective maps", [IsMapping and 
		IsBijective, IsMapping and IsBijective, IsMapping and IsBijective],
	function( vertexMap, edgeMap, faceMap )
		
		if Length( Set( Source( vertexMap ) ) ) <> 3 then
			Error("SimplicialSurfaceIdentification: Only three vertices");
		fi;
		if Length( Set( Source( edgeMap ) ) ) <> 3 then
			Error("SimplicialSurfaceIdentification: Only three edges");
		fi;
		if Length( Set( Source( faceMap ) ) ) <> 1 then
			Error("SimplicialSurfaceIdentification: Only one face");
		fi;
	#TODO check whether these maps really only consist of integers

		return SimplicialSurfaceIdentificationNC(vertexMap,edgeMap,faceMap);
	end
);
RedispatchOnCondition( SimplicialSurfaceIdentification, true, 
	[IsMapping,	IsMapping, IsMapping], 
	[IsBijective, IsBijective, IsBijective], 0 );
RedispatchOnCondition( SimplicialSurfaceIdentification, true, 
	[IsGeneralMapping, IsGeneralMapping, IsGeneralMapping], 
	[IsMapping and IsBijective,
		IsMapping and IsBijective,
		IsMapping and IsBijective], 0 );

##
##	To define these maps by lists we need a general method to convert a list
##	into a map. We have to supply two versions of this method.
__SIMPLICIAL_CreateMapFromListNC := function( list, message )
	local source, image, relation, tuple, check, map;

	if message then
		check := Filtered( list, el -> IsList(el) and Length(el) = 2 and 
					IsPosInt(el[1]) and IsPosInt(el[2]) );
		if Length(check) < Length(list) then
			Error("SimplicialSurfaceIdentificationByLists: The maps are given by lists of tuples of positive integers.");
		fi;
	fi;

	source := Domain( List( list, el -> el[1] ) );
	image := Domain( List( list, el -> el[2] ) );
	relation := List( list, el -> DirectProductElement(el) );

	map := GeneralMappingByElements( source, image, relation);
	if message and not IsBijective(map) then
		Error("SimplicialSurfaceIdentificationByLists: The maps have to be bijective.");
	fi;

	return map;
end;

#!	@Description
#!	Return a simplicial surface identification which is constructed from three
#!	lists. The vertex-list has the form [[p_1,q_1],[p_2,q_2],[p_3,q_3]] and
#!	corresponds to the map p_i -> q_i. Analogously for the other two lists.
#!
#!	The NC-version does not check if the lists fulfill this format. It also does
#!	not check if vertexList and edgeList consist of three tuples or if the
#!	faceList only contains one.
#!
#!	@Arguments three lists of tuples of positive integers
#!	@Returns a simplicial surface identification
InstallMethod( SimplicialSurfaceIdentificationByListsNC, "for three lists",
	[IsList,IsList,IsList],
	function( vertexList, edgeList, faceList )
		local vertexMap, edgeMap, faceMap;

		vertexMap := __SIMPLICIAL_CreateMapFromListNC( vertexList, false );
		edgeMap := __SIMPLICIAL_CreateMapFromListNC( edgeList, false );
		faceMap := __SIMPLICIAL_CreateMapFromListNC( faceList, false );

		return SimplicialSurfaceIdentificationNC( vertexMap, edgeMap, faceMap);
	end
);
InstallMethod( SimplicialSurfaceIdentificationByLists, "for three lists",
	[IsList,IsList,IsList],
	function( vertexList, edgeList, faceList )
		local vertexMap, edgeMap, faceMap;

		if Length( vertexList ) <> 3 then
			Error("SimplicialSurfaceIdentificationByLists: Only three vertices");
		fi;
		if Length( edgeList ) <> 3 then
			Error("SimplicialSurfaceIdentificationByLists: Only three edges");
		fi;
		if Length( faceList ) <> 1 then
			Error("SimplicialSurfaceIdentificationByLists: Only one face");
		fi;

		vertexMap := __SIMPLICIAL_CreateMapFromListNC( vertexList, true );
		edgeMap := __SIMPLICIAL_CreateMapFromListNC( edgeList, true );
		faceMap := __SIMPLICIAL_CreateMapFromListNC( faceList, true );

		return SimplicialSurfaceIdentificationNC( vertexMap, edgeMap, faceMap);
	end
);


##
##
##							End of constructors
##
#############################################################################
#############################################################################



#!	@Description
#!	Return the vertex map.
#!	@Arguments a simplicial surface identification
#!	@Returns a bijective map
InstallMethod( VertexMap,
	"for a simplicial surface identification",
	[IsSimplicialSurfaceIdentification],
	function( id )
		return VertexMapAttributeOfSimplicialSurfaceIdentification(id);
	end
);

#!	@Description
#!	Return the edge map.
#!	@Arguments a simplicial surface identification
#!	@Returns a bijective map
InstallMethod( EdgeMap,
	"for a simplicial surface identification",
	[IsSimplicialSurfaceIdentification],
	function( id )
		return EdgeMapAttributeOfSimplicialSurfaceIdentification(id);
	end
);

#!	@Description
#!	Return the face map.
#!	@Arguments a simplicial surface identification
#!	@Returns a bijective map
InstallMethod( FaceMap,
	"for a simplicial surface identification",
	[IsSimplicialSurfaceIdentification],
	function( id )
		return FaceMapAttributeOfSimplicialSurfaceIdentification(id);
	end
);


#!	@Description
#!	Return if the given simplicial surface identification is well-defined
#!	with respect to the given simplicial surface.
#!	This method checks if the maps of the identification can be applied to
#!	the vertices, edges and faces of the simplicial surface. It also
#!	checks whether the maps are compatible with each other, i.e. if they
#!	commute with the incidence relation of the simplicial surface.
#!	@Arguments a simplicial surface, a simplicial surface identification
#!	@Returns true or false
InstallMethod( IsWellDefinedIdentification, 
	"for a simplicial surface and a simplicial surface identification",
	[IsSimplicialSurface, IsSimplicialSurfaceIdentification],
	function( surface, id )
		local faceSource, faceRange;

		# Check first if all maps are well-defined
		if not IsSubset( Vertices( surface ), Source( VertexMap(id) ) ) then
			return false;
		fi;
		if not IsSubset( Vertices( surface ), Range( VertexMap(id) ) ) then
			return false;
		fi;

		if not IsSubset( Edges( surface ), Source( EdgeMap(id) ) ) then
			return false;
		fi;
		if not IsSubset( Edges( surface ), Range( EdgeMap(id) ) ) then
			return false;
		fi;

		if not IsSubset( Faces( surface ), Source( FaceMap(id) ) ) then
			return false;
		fi;
		if not IsSubset( Faces( surface ), Range( FaceMap(id) ) ) then
			return false;
		fi;

		# Now we check the compatibility with the incidence relation
		faceSource := AsList( Source( FaceMap(id) ) )[1];
		if Source( VertexMap(id) ) <> FacesByVertices(surface)[faceSource] then
			return false;
		fi;
		if Source( EdgeMap(id) ) <> FacesByEdges(surface)[faceSource] then
			return false;
		fi;

		faceRange := AsList( Range( FaceMap(id) ) )[1];
		if Range( VertexMap(id) ) <> FacesByVertices(surface)[faceRange] then
			return false;
		fi;
		if Range( EdgeMap(id) ) <> FacesByEdges(surface)[faceRange] then
			return false;
		fi;

		return true;
	end
);
InstallOtherMethod( IsWellDefinedIdentification, 
	"for a coloured simplicial surface and a simplicial surface identification",
	[IsColouredSimplicialSurface, IsSimplicialSurfaceIdentification],
	function( surface, id )
		return IsWellDefinedIdentification( 
				UnderlyingSimplicialSurface(surface), id);
	end
);


#!	@Description
#!	Return if the given simplicial surface identification is constant on the
#!	intersection for the given coloured simplicial surface.
#!	TODO explain what this means
#!	It also checks if the identification is well-defined.
#!	@Arguments a coloured simplicial surface, a simplicial surface 
#!	identification
#!	@Returns true or false
InstallMethod( IsConstantOnIntersectionNCWellDefined, 
	"for a coloured simplicial surface and a simplicial surface identification",
	[IsColouredSimplicialSurface, IsSimplicialSurfaceIdentification],
	function( surface, id )
		local edge1, edge2, edgesSource, edgesRange,
			vertex1, vertex2, verticesSource, verticesRange;

		edgesSource := AsList( Source( EdgeMap( id ) ) );
		edgesRange := AsList( Range( EdgeMap( id ) ) );
		for edge1 in edgesSource do
			for edge2 in edgesRange do
				if IsEquivalentEdge( surface, edge1, edge2 ) then
					if ImageElm( EdgeMap(id), edge1 ) <> edge2 then
						return false;
					fi;
				fi;
			od;
		od;

		verticesSource := AsList( Source( VertexMap( id ) ) );
		verticesRange := AsList( Range( VertexMap( id ) ) );
		for vertex1 in verticesSource do
			for vertex2 in verticesRange do
				if IsEquivalentVertex( surface, vertex1, vertex2 ) then
					if ImageElm( VertexMap(id), vertex1 ) <> vertex2 then
						return false;
					fi;
				fi;
			od;
		od;

		return true;
	end
);
InstallMethod( IsConstantOnIntersection, 
	"for a coloured simplicial surface and a simplicial surface identification",
	[IsColouredSimplicialSurface, IsSimplicialSurfaceIdentification],
	function( surface, id )
		local uSurf;

		uSurf := UnderlyingSimplicialSurface( surface );
		if not IsWellDefinedIdentification( uSurf, id ) then
			return false;
		fi;		

		return IsConstantOnIntersectionNCWellDefined( surface, id );
	end
);


#!	@Description
#!	Return if the given simplicial surface identification can be applied to
#!	the given coloured simplicial surface and result in another
#!	coloured simplicial surface. To be more precise we check the
#!	property of corollary 2.37 in my master thesis in addition to
#!	IsWellDefinedIdentification and IsConstantOnIntersection
#!	@Arguments a coloured simplicial surface, a simplicial surface 
#!	identification
#!	@Returns true or false
InstallMethod( IsApplicableExtensionNCIntersection, 
	"for a coloured simplicial surface and a simplicial surface identification",
	[IsColouredSimplicialSurface, IsSimplicialSurfaceIdentification],
	function( surface, id )
		local vMap, vertex, vertexSource, quot, vertexClasses, edge;

		vMap := VertexMap( id );
		vertexSource := Source( vMap );
		for vertex in vertexSource do
			if not IsEquivalentVertex(surface,vertex,ImageElm(vMap,vertex)) then
				# Verify that there is no edge in which vertex and 
				# Image(vMap,vertex) lie simultaneously (or vertices that are
				# equivalent to those two - there is a mistake in the lemma)

				# We therefore switch to the quotient surface
				quot := QuotientSimplicialSurface( surface );
				vertexClasses := Set( List( [ vertex, ImageElm(vMap,vertex)], 
						v -> VertexEquivalenceNumbersByElements(surface)[v] ) );
				for edge in Edges( quot ) do
					if vertexClasses = EdgesByVertices(quot)[edge] then
						return false;
					fi;
				od;
			fi;
		od;

		return true;
	end
);
InstallMethod( IsApplicableExtension, 
	"for a coloured simplicial surface and a simplicial surface identification",
	[IsColouredSimplicialSurface, IsSimplicialSurfaceIdentification],
	function( surface, id )
		if not IsConstantOnIntersection( surface, id ) then
			return false;
		fi;

		return IsApplicableExtensionNCIntersection( surface, id );
	end
);
InstallMethod( IsApplicableExtensionNCWellDefined, 
	"for a coloured simplicial surface and a simplicial surface identification",
	[IsColouredSimplicialSurface, IsSimplicialSurfaceIdentification],
	function( surface, id )
		if not IsConstantOnIntersectionNCWellDefined( surface, id ) then
			return false;
		fi;

		return IsApplicableExtensionNCIntersection( surface, id );
	end
);



#!	@Description
#!	Extend the equivalence relation of the coloured simplicial surface 
#!	with a simplicial surface identification.
#!
#!	The NC-version does not run the test IsApplicableExtension.
#!
#!	@Arguments a coloured simplicial surface, a simplicial surface
#!		identification
#!	@Returns a coloured simplicial surface
InstallMethod( ExtendByIdentification, 
	"for a coloured simplicial surface and a simplicial surface identification",
	[IsColouredSimplicialSurface, IsSimplicialSurfaceIdentification],
	function( surface, id )
		if not IsApplicableExtension( surface, id ) then
			Error("ExtendByIdentification: The identification has to be applicable.");
		fi;

		return ExtendByIdentificationNC( surface, id );
	end
);
InstallMethod( ExtendByIdentificationNC, 
	"for a coloured simplicial surface and a simplicial surface identification",
	[IsColouredSimplicialSurface, IsSimplicialSurfaceIdentification],
	function( surface, id )
		local ExtendedClassesByNumbers, vertexClassByNr, edgeClassByNr,
				faceClassByNr, ext;

		ExtendedClassesByNumbers := function(map, classByNumbers, nrByElements)
			local source, image, newClassByNumbers, nrSource, nrImage;

			newClassByNumbers := StructuralCopy( classByNumbers );
			for source in AsList( Source( map ) ) do
				image := ImageElm( map, source );
				nrSource := nrByElements[source];
				nrImage := nrByElements[image];
				if nrSource <> nrImage then
					newClassByNumbers[ nrSource ] :=
								Union( classByNumbers[nrSource], 
										classByNumbers[nrImage] );
					Unbind( newClassByNumbers[ nrImage ] );
				fi;
			od;
			return newClassByNumbers;
		end;

		vertexClassByNr := ExtendedClassesByNumbers( VertexMap(id),
			VertexEquivalenceClassesByNumbers(surface),
			VertexEquivalenceNumbersByElements(surface) );
		edgeClassByNr := ExtendedClassesByNumbers( EdgeMap(id),
			EdgeEquivalenceClassesByNumbers(surface),
			EdgeEquivalenceNumbersByElements(surface) );
		faceClassByNr := ExtendedClassesByNumbers( FaceMap(id),
			FaceEquivalenceClassesByNumbers(surface),
			FaceEquivalenceNumbersByElements(surface) );

		ext := Objectify( ColouredSimplicialSurfaceType, rec() );
		SetUnderlyingSimplicialSurfaceAttributeOfCSS( ext, 
			UnderlyingSimplicialSurface(surface) );
		SetVertexEquivalenceClassesByNumbersAttributeOfCSS( ext, 
			vertexClassByNr);
		SetEdgeEquivalenceClassesByNumbersAttributeOfCSS( ext, 
			edgeClassByNr);
		SetFaceEquivalenceClassesByNumbersAttributeOfCSS( ext, 
			faceClassByNr);

		return ext;
	end
);



#!	@Description
#!	Return the neighbour identification of two neighbouring faces of a
#!	(coloured) simplicial surface. By construction this identification is
#!	well-defined and constant on the intersection.
#!
#!	@Arguments a (coloured) simplicial surface, two face numbers (for a coloured
#!		simplicial surface these refer to the underlying simplicial surface).
#!	@Returns a simplicial surface identifaction
#TODO write the method for coloured simplicial surfaces
InstallMethod( NeighbourIdentification, 
	"for a simplicial surface and two faces",
	[IsSimplicialSurface, IsPosInt, IsPosInt],
	function( surface, face1, face2 )
		if face1 in Faces(surface) and face2 in Faces(surface) then
			return NeighbourIdentificationNC(surface, face1, face2);
		fi;

		Error("NeighbourIdentification: The given faces have to be faces of the given simplicial surface.");
	end
);
InstallMethod( NeighbourIdentificationNC, 
	"for a simplicial surface and two faces",
	[IsSimplicialSurface, IsPosInt, IsPosInt],
	function( surface, face1, face2 )
		local commonVertices, vertexList, lastVertex, imageVertex, vertexMap,
			edgeList, edge, vertexImages, possEdge, edgeMap, faceMap, v;

		commonVertices := Intersection( FacesByVertices(surface)[face1], 
										FacesByVertices(surface)[face2] );
		if Length(commonVertices) < 2 then
			Error("NeighbourIdentification: The given faces have to have at least two vertices in common.");
		fi;

		# Construct the vertex map
		vertexList := [];
		for v in commonVertices do
			Append( vertexList, DirectProductElement([v,v]) );
		od;
		# Since we are dealing with triangles, there is at most one additional vertex
		if Length(commonVertices) = 2 then
			lastVertex := Difference( FacesByVertices(surface)[face1], 
														commonVertices )[1];
			imageVertex := Difference( FacesByVertices(surface)[face2], 
														commonVertices )[1];
			Append( vertexList, DirectProductElement([lastVertex,imageVertex]) );
		fi;
		vertexMap := GeneralMappingByElements( 
				Domain( FacesByVertices(surface)[face1] ),
				Domain( FacesByVertices(surface)[face2] ),
				vertexList );


		# Construct the edge map
		edgeList := [];
		for edge in FacesByEdges(surface)[face1] do
			vertexImages := Set( List( EdgesByVertices(surface)[edge], 
											v -> ImageElm( vertexMap, v ) ) );
			for possEdge in FacesByEdges(surface)[face2] do
				if vertexImages = EdgesByVertices(surface)[possEdge] then
					Append( edgeList, DirectProductElement( [edge, possEdge] );
				fi;
			od;
		od;
		edgeMap := GeneralMappingByElements( 
				Domain( FacesByEdges(surface)[face1] ),
				Domain( FacesByEdges(surface)[face2] ),
				edgeList );

		
		# Construct the face map
		faceMap := GeneralMappingByElements( 
				Domain( [face1] ), 
				Domain( [face2] ),
				[ DirectProductElement( [face1,face2] ) ] );

		return SimplicialSurfaceIdentificationNC( vertexMap, edgeMap, faceMap );
	end
);


InstallOtherMethod( NeighbourIdentification, 
	"for a coloured simplicial surface and two faces",
	[IsColouredSimplicialSurface, IsPosInt, IsPosInt],
	function( surface, face1, face2 )
		local quotSurf, faceClass1, faceClass2;

		quotSurf := QuotientSimplicialSurface( surface );
		faceClass1 := FaceEquivalenceNumberOfElement( surface, face1);
		faceClass2 := FaceEquivalenceNumberOfElement( surface, face2);
		if faceClass1 in Faces(quotSurf) and faceClass2 in Faces(quotSurf) then
			return NeighbourIdentificationNC(surface, face1, face2);
		fi;

		Error("NeighbourIdentification: The given faces have to be faces of the underlying simplicial surface of the given coloured simplicial surface.");
	end
);
InstallOtherMethod( NeighbourIdentificationNC, 
	"for a coloured simplicial surface and two faces",
	[IsColouredSimplicialSurface, IsPosInt, IsPosInt],
	function( surface, face1, face2 )
		local quotId, uSurf, faceClass1, faceClass2, vertexMap1, vertexMap2, 
			vertexMap, quotSurf, edgeMap1, edgeMap2, edgeMap, faceMap;

		quotSurf := QuotientSimplicialSurface( surface );
		faceClass1 := FaceEquivalenceNumberOfElement( surface, face1);
		faceClass2 := FaceEquivalenceNumberOfElement( surface, face2);

		quotId := NeighbourIdentificationNC( quotSurf, faceClass1, faceClass2 );
		uSurf := UnderlyingSimplicialSurface( surface );
		
		# Construct the vertices by composing with the bijections that we
		# get if we map a vertex onto its equivalence class
		vertexMap1 := MappingByFunction( 
				Domain( FacesByVertices(uSurf)[face1] ),
				Domain( FacesByVertices(quotSurf)[faceClass1] ),
				function( x )
					return VertexEquivalenceNumberOfElement(surface, x);
				end );
		vertexMap2 := MappingByFunction( 
				Domain( FacesByVertices(uSurf)[face2] ),
				Domain( FacesByVertices(quotSurf)[faceClass2] ),
				function( x )
					return VertexEquivalenceNumberOfElement(surface, x);
				end );
		vertexMap := CompositionMapping( vertexMap1, VertexMap(quotId), Inverse(vertexMap2) );


		# Construct the edges in the same way
		edgeMap1 := MappingByFunction( 
				Domain( FacesByEdges(uSurf)[face1] ),
				Domain( FacesByEdges(quotSurf)[faceClass1] ),
				function( x )
					return EdgeEquivalenceNumberOfElement(surface, x);
				end );
		edgeMap2 := MappingByFunction( 
				Domain( FacesByEdges(uSurf)[face2] ),
				Domain( FacesByEdges(quotSurf)[faceClass2] ),
				function( x )
					return EdgeEquivalenceNumberOfElement(surface, x);
				end );
		edgeMap := CompositionMapping( edgeMap1, EdgeMap(quotId), Inverse(edgeMap2) );


		# Construct the face map (no complications)
		faceMap := GeneralMappingByElements( 
				Domain( [face1] ), 
				Domain( [face2] ),
				[ DirectProductElement( [face1,face2] ) ] );

		return SimplicialSurfaceIdentificationNC( vertexMap, edgeMap, faceMap );
	end
);



##
##  A method to test whether two simplicial surfaces identifications are equal
##
InstallMethod( \=, "for two simplicial surfaces identifications", 
	IsIdenticalObj, 
	[IsSimplicialSurfaceIdentification, IsSimplicialSurfaceIdentification], 0,
	function( id1, id2 )

		if VertexMap(id1) <> VertexMap(id2) then
			return false;
		fi;

		if EdgeMap(id1) <> EdgeMap(id2) then
			return false;
		fi;

		if FaceMap(id1) <> FaceMap(id2) then
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

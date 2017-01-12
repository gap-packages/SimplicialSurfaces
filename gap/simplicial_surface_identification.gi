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
InstallMethod( SimplicialSurfaceIdentification,
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
RedispatchOnCondition( SimplicialSurfaceIdentification, true, [IsMapping,
	IsMapping, IsMapping], [IsBijective, IsBijective, IsBijective], 0 );

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

		return SimplicialSurfaceIdentification( vertexList, edgeList, faceList);
	end
);
InstallMethod( SimplicialSurfaceIdentificationByLists, "for three lists",
	[IsList,IsList,IsList],
	function( vertexList, edgeList, faceList )
		local vertexMap, edgeMap, faceMap;

		vertexMap := __SIMPLICIAL_CreateMapFromListNC( vertexList, true );
		edgeMap := __SIMPLICIAL_CreateMapFromListNC( edgeList, true );
		faceMap := __SIMPLICIAL_CreateMapFromListNC( faceList, true );

		if Length( Source( vertexMap ) ) <> 3 then
			Error("SimplicialSurfaceIdentificationByLists: Only three vertices");
		fi;
		if Length( Source( edgeMap ) ) <> 3 then
			Error("SimplicialSurfaceIdentificationByLists: Only three edges");
		fi;
		if Length( Source( faceMap ) ) <> 1 then
			Error("SimplicialSurfaceIdentificationByLists: Only one face");
		fi;

		return SimplicialSurfaceIdentification( vertexList, edgeList, faceList);
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


#!	@Description
#!	Return if the given simplicial surface identification is constant on the
#!	intersection for the given simplicial surface with equivalence.
#!	TODO explain what this means
#!	It also checks if the identification is well-defined.
#!	@Arguments a simplicial surface with equivalence, a simplicial surface 
#!	identification
#!	@Returns true or false
InstallMethod( IsConstantOnIntersection, 
	"for a simplicial surface with equivalence and a simplicial surface identification",
	[IsSimplicialSurfaceWithEquivalence, IsSimplicialSurfaceIdentification],
	function( surface, id )
		local uSurf, edge1, edge2, edgesSource, edgesRange,
			vertex1, vertex2, verticesSource, verticesRange;

		uSurf := UnderlyingSimplicialSurface( surface );
		if not IsWellDefinedIdentification( uSurf, id ) then
			return false;
		fi;		

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


#!	@Description
#!	Return if the given simplicial surface identification can be applied to
#!	the given simplicial surface with equivalence and result in another
#!	simplicial surface with equivalence. To be more precise we check the
#!	property of corollary 2.37 in my master thesis in addition to
#!	IsWellDefinedIdentification and IsConstantOnIntersection
#!	@Arguments a simplicial surface with equivalence, a simplicial surface 
#!	identification
#!	@Returns true or false
InstallMethod( IsApplicableExtension, 
	"for a simplicial surface with equivalence and a simplicial surface identification",
	[IsSimplicialSurfaceWithEquivalence, IsSimplicialSurfaceIdentification],
	function( surface, id )
		local vMap, vertex, vertexSource, quot, vertexClasses, edge;

		if not IsConstantOnIntersection( surface, id ) then
			return false;
		fi;

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




#!	@Description
#!	Extend the equivalence relation of the simplicial surface with
#!	equivalence with a simplicial surface identification.
#!
#!	The NC-version does not run the test IsApplicableExtension.
#!
#!	@Arguments a simplicial surface with equivalence, a simplicial surface
#!		identification
#!	@Returns a simplicial surface with equivalence
InstallMethod( ExtendByIdentification, 
	"for a simplicial surface with equivalence and a simplicial surface identification",
	[IsSimplicialSurfaceWithEquivalence, IsSimplicialSurfaceIdentification],
	function( surface, id )
		if not IsApplicableExtension( surface, id ) then
			Error("ExtendByIdentification: The identification has to be applicable.");
		fi;

		return ExtendByIdentificationNC( surface, id );
	end
);
InstallMethod( ExtendByIdentificationNC, 
	"for a simplicial surface with equivalence and a simplicial surface identification",
	[IsSimplicialSurfaceWithEquivalence, IsSimplicialSurfaceIdentification],
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

		ext := Objectify( SimplicialSurfaceWithEquivalenceType, rec() );
		SetUnderlyingSimplicialSurfaceAttributeOfSSWE( ext, 
			UnderlyingSimplicialSurface(surface) );
		SetVertexEquivalenceClassesByNumbersAttributeOfSSWE( ext, 
			vertexClassByNr);
		SetEdgeEquivalenceClassesByNumbersAttributeOfSSWE( ext, 
			edgeClassByNr);
		SetFaceEquivalenceClassesByNumbersAttributeOfSSWE( ext, 
			faceClassByNr);

		return ext;
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

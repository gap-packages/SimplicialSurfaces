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

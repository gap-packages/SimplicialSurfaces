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

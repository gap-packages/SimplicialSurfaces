##############################################################################
##
#W  simplicial_surface_fan.gi      SimplicialSurfaces         Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##
##  The functions in this file compute with fans.
##

DeclareRepresentation("IsSimplicialSurfaceFanRep", IsSimplicialSurfaceFan,
     []);

##	accompanying type
SimplicialSurfaceFanType := 
    NewType( SimplicialSurfaceFanFamily, IsSimplicialSurfaceFanRep );



#############################################################################
#############################################################################
##
##						Start of constructors
##
##
##

#!	@Description
#!	Return a fan by defining all necessary attributes. Begin and End have to be
#!	different.
#!	The NC-version doesn't check if Begin and End are different.
#!	@Arguments two positive integers, one cyclic permutation
#!	@Returns a fan
InstallMethod( SimplicialSurfaceFanNC, 
	"for two positive integers and a permutation",
	[IsPosInt, IsPosInt, IsPerm and IsCyclic],
	function( start, fin, perm )
		local fan;

		fan := Objectify( SimplicialSurfaceFanType, rec() );
		SetBeginAttributeOfSimplicialSurfaceFan( fan, start );
		SetEndAttributeOfSimplicialSurfaceFan( fan, fin );
		SetPermutationAttributeOfSimplicialSurfaceFan( fan, perm );

		return fan;
	end
);
InstallMethod( SimplicialSurfaceFan, 
	"for two positive integers and a permutation",
	[IsPosInt, IsPosInt, IsPerm and IsCyclic],
	function( start, fin, perm )
		if start = fin then
			Error("SimplicialSurfaceFan: Begin and End have to be different.");
		fi;

		return SimplicialSurfaceFanNC( start, fin, perm);
	end
);

#!	@Description
#!	Return the fan of the edge of a simplicial surface. For this to be unique
#!	at most two faces can be incident to the edge (otherwise the permutation
#!	of those is not unique). This is guaranteed to be the case if the simplicial
#!	surface is an actual surface.
#!
#!	@Arguments a simplicial surface, a positive integer
#!	@Returns a fan
InstallMethod( SimplicialSurfaceFanByEdgeInSimplicialSurface,
	"for a simplicial surface and a positive integer",
	[IsSimplicialSurface, IsPosInt],
	function( surface, edge )
		local fan, vertices, faces, perm;

		if not edge in Edges(surface) then
			Error("SimplicialSurfaceFanByEdgeInSimplicialSurface: Given edge has to lie in given surface.");
		fi;

		faces := EdgesByFaces(surface)[edge];
		if Size(faces) = 1 then
			perm := ();
		elif Size(faces) = 2 then
			perm := PermListList( faces, Reversed(faces) );
		else
			Error("SimplicialSurfaceFanByEdgeInSimplicialSurface: There have to be at most two faces incident to the given edge.");
		fi;

		vertices := EdgesByVertices(surface)[edge];

		return SimplicialSurface( vertices[1], vertices[2], perm);
	end
);


##
##
##							End of constructors
##
#############################################################################
#############################################################################




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

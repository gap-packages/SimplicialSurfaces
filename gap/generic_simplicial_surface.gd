##############################################################################
##
#W  generic_simplicial_surface.gd      Generic Simplicial Surface       Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the declaration part of the Simplicial package.
##

#############################################################################
##
#!  @Chapter Generic Simplicial Surfaces
##
#!  A simplicial surface is called **generic** if it is given in the
#!  following form ... 
#!
#!

DeclareInfoClass( "InfoSimplicial" );
SetInfoLevel(InfoSimplicial,1);


#############################################################################
##
##
#!  @Section Basic functions for Generic Simplicial Surfaces
#!
#!
#!

#############################################################################
##
##
#!  @Description
#!  This function returns the list of faces of a generic simplicial surface.
#!  Each face of the surface is represented by a number $f$.
#!  @Returns a list
#!  @Arguments simpsurf
#!
DeclareGlobalFunction( "FacesOfGenericSimplicialSurface" );
#############################################################################
##
##
#!  @Description
#!  This function returns the number of faces of a generic simplicial surface.
#!  @Returns an integer
#!  @Arguments simpsurf
#!
DeclareGlobalFunction( "NrOfFacesOfGenericSimplicialSurface" );
#############################################################################
##
##
#!  @Description
#!  This function returns the list of edges of a generic simplicial surface.
#!  Each edge of the surface is represented by a pair of numbers $[f_1,f_2]$,
#!  where $f_1$ and $f_2$ are faces that are incident to the edge $[f_1,f_2]$.
#!  @Returns a list
#!  @Arguments simpsurf
#!
DeclareGlobalFunction( "EdgesOfGenericSimplicialSurface" );
#############################################################################
##
##
#!  @Description
#!  This function returns the number of edges of a generic simplicial surface.
#!  @Returns an integer
#!  @Arguments simpsurf
#!
DeclareGlobalFunction( "NrOfEdgesOfGenericSimplicialSurface" );
#############################################################################
##
##
#!  @Description
#!  This function returns the list of vertices of a generic simplicial surface.
#!  Each vertex of the simplicial surface is represented by a vertex 
#!  defining path.
#!  @Returns a list
#!  @Arguments simpsurf
#!
DeclareGlobalFunction( "VerticesOfGenericSimplicialSurface" );
#############################################################################
##
##
#!  @Description
#!  This function returns the number of vertices of a generic simplicial surface.
#!  @Returns an integer
#!  @Arguments simpsurf
#!
DeclareGlobalFunction( "NrOfVerticesOfGenericSimplicialSurface" );
#############################################################################
##
##
#!  @Description
#!  This function takes as input a simplicial surface and returns a list of 
#!  integers, one for each vertex. The integer for a vertex is the degree of 
#!  this vertex.
#!  @Returns list
#!  @Arguments simpsurf
#!
DeclareGlobalFunction( "DegreesOfGenericSimplicialSurface" );


#############################################################################
##
##
#!  @Section Functions for Generic Simplicial Surfaces
#!
#!
#!

DeclareGlobalFunction( "IsOrientableSimplicialSurface" );
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

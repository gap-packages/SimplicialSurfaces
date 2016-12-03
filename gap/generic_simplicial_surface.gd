##############################################################################
##
#W  generic_simplicial_surface.gd |Generic Simplicial Surface| Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the declaration part for generic simplicial surfaces
##	of the simplicial_surfaces package.
##
##

DeclareInfoClass( "InfoSimplicial" );
SetInfoLevel(InfoSimplicial,1);


#############################################################################
##
#!  @Chapter Generic Simplicial Surfaces
##
#!  A simplicial surface is called **generic** if it is given by the
#!  following data:
#!	1) The number of vertices
#!	2) The number of edges
#!	3) The number of faces
#!	4) For each edge: A list of the two incident vertices
#!	5) For each face: A list of the three indicent edges
#!		The order or these three edges defines the orientation of this face.
#!
#!

##
##	Declare the representation of generic simplicial surfaces.
##
##	Note: We depart from the usual convention to put this declaration into
##		the .gi-file (compare section 79.19 of the GAP-manual) as it is
##		instrumental to know this representation to work with this package.
##
DeclareRepresentation("IsGenericSimplicialSurfaceRep", IsComponentObjectRep,
     ["nrOfVertices","nrOfEdges","nrOfFaces", "edges", "faces"]);

## From now on, we can do "Objectify( SimplicialSurfaceType, re )" 
## for any list re
GenericSimplicialSurfaceType := 
    NewType( SimplicialSurfaceFamily, IsGenericSimplicialSurfaceRep );

## Constructor
DeclareGlobalFunction( "GenericSimplicialSurfaceByList" );



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
#!  Each face of the surface is represented by a list of the edges that lie
#!	in this face.
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
#!  Each edge of the surface is represented by a pair of numbers $[v_1,v_2]$,
#!  where $v_1$ and $v_2$ are vertices that are incident to the edge.
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
#!  Each vertex of the simplicial surface is represented by a number $v$. 
#!  defining path.
#!  @Returns a list
#!  @Arguments simpsurf
#!
DeclareGlobalFunction( "VerticesOfGenericSimplicialSurface" );
#############################################################################
##
##
#!  @Description
#!  This function returns the number of vertices of a generic simplicial 
#!	surface.
#!  @Returns an integer
#!  @Arguments simpsurf
#!
DeclareGlobalFunction( "NrOfVerticesOfGenericSimplicialSurface" );
#############################################################################
##
##
#!  @Description
#!  This function returns the faces of a generic simplicial surface in the
#!	following form: Each face is represented as a list of the vertices that
#!	lie in this face.
#!  @Returns an integer
#!  @Arguments simpsurf
#!
DeclareGlobalFunction( "FacesByVerticesOfGenericSimplicialSurface" );
#############################################################################
##
##
#!  @Description
#!  This function returns the edges of a generic simplicial surface in the
#!	following form: Each edge is represented by the list of all faces that
#!	are incident to this edge (this does not determine these edges uniquely).
#!  @Returns an integer
#!  @Arguments simpsurf
#!
DeclareGlobalFunction( "EdgesByFacesOfGenericSimplicialSurface" );


#############################################################################
##
##
#!  @Description
#!  This function takes as input a simplicial surface and returns a list of 
#!  integers, one for each vertex. The integer for a vertex is the degree of 
#!  this vertex. This list is ordered exactly like the vertex set.
#!  @Returns list
#!  @Arguments simpsurf
#!
DeclareGlobalFunction( "UnsortedDegreesOfGenericSimplicialSurface" );
#############################################################################
##
##
#!  @Description
#!  This function takes as input a simplicial surface and returns a list of 
#!  integers, one for each vertex. The integer for a vertex is the degree of 
#!  this vertex. This list is sorted.
#!  @Returns list
#!  @Arguments simpsurf
#!
DeclareGlobalFunction( "SortedDegreesOfGenericSimplicialSurface" );


#############################################################################
##
##
#!  @Section Functions for Generic Simplicial Surfaces
#!
#!
#!

#############################################################################
##
##
#!  @Description
#!  This function takes as input a generic simplicial surface and returns if
#!  this surface is orientable (it has to be an actual surface).
#!  @Returns true if surface is orientable, false otherwise
#!  @Arguments simpsurf
#!
DeclareGlobalFunction( "IsOrientableGenericSimplicialSurface" );

#############################################################################
##
##
#!  @Description
#!  Return the coloured incidence graph of a generic simplicial surface.
#!	The vertex set of this graph consists of all vertices, edges and faces
#!	of the generic simplicial surface. All vertices, all edges and all faces
#!	are in individual colour classes.
#!  @Returns the coloured incidence graph
#!  @Arguments simpsurf
#!
DeclareGlobalFunction( "IncidenceGraphOfGenericSimplicialSurface" );

#############################################################################
##
#!  @Description
#!  Check if two generic simplicial surfaces are isomorphic.
#!  @Returns true or false
#!  @Arguments <s1>, <s2>, two generic simplicial surface objects as created 
#!  by GenericSimplicialSurface
#!
##
DeclareGlobalFunction( "IsIsomorphicGenericSimplicialSurface" );

#############################################################################
##
#!  @Description
#!  Check if a generic simplicial surfaces is connected.
#!  @Returns true or false
#!  @Arguments <simpsurf>, a generic simplicial surface object as created 
#!  by GenericSimplicialSurface
#!
##
DeclareGlobalFunction( "IsConnectedGenericSimplicialSurface" );

###############################################################################
##
#!  @Description
#!  This function checks whether the generic simplicial surface is an actual
#!	surface. It is, if every edge lies in at most two faces.
#!  @Returns true if it is a surface and false else.
#!  @Arguments <simpsurf> a generic simplicial surface
#!
DeclareGlobalFunction( "IsActualSurfaceGenericSimplicialSurface" );



###############################################################################
##
#!  @Description
#!  This function removes one vertex of a generic simplicial surface
#!  <simpsurf>, along with all edges and faces that are adjacent to the vertex
#!  @Returns a generic simplicial surface without the given vertex.
#!  @Arguments <simpsurf> a generic simplicial surface, <vertex> the vertex to
#!		 be removed
#!
##
DeclareGlobalFunction( "RemoveVertexOfGenericSimplicialSurface" );

###############################################################################
##
#!  @Description
#!  This function recursively removes ears of a generic simplicial surface
#!  <simpsurf>. An ear is a face with one vertex that only lies in that face.
#!  @Returns a generic simplicial surface without ears.
#!  @Arguments <simpsurf> a generic simplicial surface
#!
DeclareGlobalFunction( "SnippOffEarsOfGenericSimplicialSurface" );



#############################################################################
##
##
#!  @Section Conversion functions for Generic Simplicial Surfaces
#!
#!
#!

DeclareGlobalFunction( "GenericSimplicialSurfaceFromFaceVertexPath" );
DeclareGlobalFunction( "FaceVertexPathFromGenericSimplicialSurface" );
DeclareGlobalFunction( "GenericSimplicialSurfaceFromWildSimplicialSurface" );

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

##############################################################################
##
#W  simplicial_surface.gd     SimplicialSurfaces             Alice Niemeyer
#W														Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Alice Niemeyer, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the declaration part for the wild simplicial surfaces
##	of the Simplicial package.
##
##	A SimplicialSurface consists of vertices, edges and faces. Each of those
##	is enumerated by numbers (not necessarily consecutively). Furthermore we
##	have an incidence relation between them.
##	Sometimes we may impose an additional structure on this surface, by
##	partitioning the set of edges into three subsets such that each face (which
##	we assume to be triangular) is bordered by all three subsets. This allows
##	us to define an involution for each subset. These three involutions are
##	in many cases sufficient to reproduce to original surface.
##

DeclareInfoClass( "InfoSimplicial" );
SetInfoLevel(InfoSimplicial,1);

##
##	Define a new family for simplicial surfaces. The family defines a necessary
##	condition that has to be fulfilled for objects to be equal to each other.
##
SimplicialSurfaceFamily := 
    NewFamily("SimplicialSurfaceFamily",  IsObject, IsComponentObjectRep);

##
##	Categories are used to determine which methods are applicable for a
##	certain object.
##
DeclareCategory( "IsSimplicialSurface", IsComponentObjectRep );

##
##	The property IsActualSurface is true if the SimplicialSurface object
##	actually represents a surface (it might otherwise happen that one edge
##	belongs to three different faces).
##
DeclareProperty( "IsActualSurface", IsSimplicialSurface );

##
##	The property IsWildColored is true if the SimplicialSurface admits a
##	wild coloring. As a precondition for this the SimplicialSurface has to be
##	an actual surface.
##
DeclareProperty( "IsWildColored", IsActualSurface );

#############################################################################
##
#!	@Description
#!	This function returns the numbers of the vertices as a dense list.
#!	@Returns a dense list of integers
#!
DeclareOperation( "Vertices", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the number of vertices.
#!	@Returns an integer
#!
DeclareOperation( "NrOfVertices", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the numbers of the edges as a dense list.
#!	@Returns a dense list of integers
#!
DeclareOperation( "Edges", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the number of edges.
#!	@Returns an integer
#!
DeclareOperation( "NrOfEdges", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the numbers of the faces as a dense list.
#!	@Returns a dense list of integers
#!
DeclareOperation( "Faces", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function returns the number of faces.
#!	@Returns an integer
#!
DeclareOperation( "NrOfFaces", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function removes all ears of the simplicial surface and returns
#!	the resulting surface.
#!	@Returns a simplicial surface object
#!	@Arguments a simplicial surface object simpsurf
#!
DeclareOperation( "SnippOffEars", [IsSimplicialSurface] );

#############################################################################
##
#!	@Description
#!	This function checks if a simplicial surface is orientable. This is only
#!	possible if it is an actual surface.
#!	@Returns true if orientable, false otherwise
#!	@Arguments a simplicial surface object simpsurf
#!
DeclareOperation( "IsOrientable", [IsSimplicialSurface and IsActualSurface] );

#############################################################################
##
#!	@Description
#!	This function checks if a simplicial surface is connected.
#!	@Returns true if connected, false otherwise
#!	@Arguments a simplicial surface object simpsurf
#!
DeclareOperation( "IsConnected", [IsSimplicialSurface] );

#############################################################################
##
##
#!  @Description
#!  This function computes the Euler characteristic of a simplicial surface.
#!  The Euler characteristic is |V| - |E| + |F|, where |V| is the number of
#!  vertices, |E| is the number of edges and |F| is the number of faces.
#!  @Returns an integer, the Euler characteristic.
#!  @Arguments simpsurf
#!
DeclareOperation( "EulerCharacteristic", [IsSimplicialSurface]);



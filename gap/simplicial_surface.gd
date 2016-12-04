##############################################################################
##
#W  simplicial_surface.gd          Simplicial             Alice Niemeyer
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

DeclareInfoClass( "InfoSimplicial" );
SetInfoLevel(InfoSimplicial,1);

SimplicialSurfaceFamily := 
    NewFamily("SimplicialSurfaceFamily",  IsObject, IsComponentObjectRep);

DeclareCategory( "IsSimplicialSurface", IsComponentObjectRep );



DeclareOperation( "Vertices", [IsSimplicialSurface] );		# TODO
DeclareOperation( "NrOfVertices", [IsSimplicialSurface] );
DeclareOperation( "Edges", [IsSimplicialSurface] );			# TODO
DeclareOperation( "NrOfEdges", [IsSimplicialSurface] );
DeclareOperation( "Faces", [IsSimplicialSurface] );			# TODO
DeclareOperation( "NrOfFaces", [IsSimplicialSurface] );

DeclareOperation( "SnippOffEars", [IsSimplicialSurface] );
DeclareOperation( "IsOrientable", [IsSimplicialSurface] );
DeclareOperation( "IsConnected", [IsSimplicialSurface] );
DeclareOperation( "IsActualSurface", [IsSimplicialSurface] );

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
DeclareGlobalFunction( "EulerCharacteristic");



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



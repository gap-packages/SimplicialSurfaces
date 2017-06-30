#############################################################################
##
##  read.g                simplicial surface package
##
#Y  Copyright (C) 2016-2017, Alice Niemeyer, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  Reading the implementation part of the simplicial surface package.
##
#############################################################################

##	This has to be read in first since it initializes the global variable
##	METHOD_SELECTION_GRAPH which is responsible for choosing the correct
##	computation path.
Read( "MethodSelectionGraph.gi" );

Read( "simplicial_surface.gi" );
Read( "wild_simplicial_surface.gi" );

Read( "coloured_simplicial_surface.gi" );
Read( "simplicial_surface_identification.gi" );

Read( "simplicial_surface_fan.gi" );
Read( "folding_complex.gi" );
Read( "folding_plan.gi" );

Read( "../surfaces/simplib.gi");




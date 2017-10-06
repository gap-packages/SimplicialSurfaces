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

ReadPackage( "SimplicialSurfaces", "gap/AttributeScheduler/AttributeScheduler.gi" );

ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/main.gi" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/polygonal_hierarchy.gi" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/incidence_geometry.gi" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/constructors.gi" );


# Tests (TODO remove later)
ReadPackage( "SimplicialSurfaces", "unit_tests/PolygonalComplexes/Test_PolygonalComplex.g" );
ReadPackage( "SimplicialSurfaces", "unit_tests/test_main.g" );

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

ReadPackage( "SimplicialSurfaces", "gap/utilities.g" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/main.gi" );
ReadPackage( "SimplicialSurfaces", "gap/Paths/dual_path.gi" );


ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/polygonal_hierarchy.gi" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/incidence_geometry.gi" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/graphs.gi" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/constructors.gi" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/properties.gi" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/embedding.gi" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/drawing.gi" );

ReadPackage( "SimplicialSurfaces", "gap/Paths/paths.gi" );
ReadPackage( "SimplicialSurfaces", "gap/Paths/connectivity.gi" );
ReadPackage( "SimplicialSurfaces", "gap/Paths/orientability.gi" );
 
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/modification.gi" );

ReadPackage( "SimplicialSurfaces", "gap/Library/library.gi" );


ReadPackage( "SimplicialSurfaces", "gap/ColouredComplexes/edgeColouring.gi" );
ReadPackage( "SimplicialSurfaces", "gap/ColouredComplexes/variColouring.gi" );

ReadPackage( "SimplicialSurfaces", "gap/Flags/flags.gi" );

# Tests (TODO remove later)
ReadPackage( "SimplicialSurfaces", "unit_tests/Test_PolygonalComplex.g" );
ReadPackage( "SimplicialSurfaces", "unit_tests/Test_EdgeColouring.g" );
ReadPackage( "SimplicialSurfaces", "unit_tests/test_main.g" );

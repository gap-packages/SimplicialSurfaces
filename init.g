#############################################################################
##
##  init.g                simplicial surface package
##
#Y  Copyright (C) 2016-2017, Alice Niemeyer, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  Reading the declaration part of the simplicial surface package.
##
#############################################################################

ReadPackage( "SimplicialSurfaces", "gap/colours.g" );
ReadPackage( "SimplicialSurfaces", "gap/Paths/dual_path.gd" );

ReadPackage( "SimplicialSurfaces", "gap/categories_families.gd" );

ReadPackage( "SimplicialSurfaces", "gap/Paths/paths.gd" );

ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/main.gd" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/bend_polygonal_complex.gd" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/incidence_geometry.gd" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/constructors.gd" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/properties.gd" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/graphs.gd" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/modification.gd" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/embedding.gd" );

ReadPackage( "SimplicialSurfaces", "gap/Library/library.gd" );

ReadPackage( "SimplicialSurfaces", "gap/ColouredComplexes/edgeColouring.gd" );
ReadPackage( "SimplicialSurfaces", "gap/ColouredComplexes/variColouring.gd" );

ReadPackage( "SimplicialSurfaces", "gap/Flags/flags.gd" );

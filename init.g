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

ReadPackage( "SimplicialSurfaces", "gap/AttributeScheduler/AttributeScheduler.gd" );

ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/main.gd" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/polygonal_hierarchy.gd" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/incidence_geometry.gd" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/constructors.gd" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/properties.gd" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/graphs.gd" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/modification.gd" );
ReadPackage( "SimplicialSurfaces", "gap/PolygonalComplexes/embedding.gd" );

ReadPackage( "SimplicialSurfaces", "gap/Paths/dual_path.gd" );
ReadPackage( "SimplicialSurfaces", "gap/Paths/paths.gd" );

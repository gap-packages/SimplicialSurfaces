LoadPackage("SimplicialSurfaces");
LoadPackage("profiling");

# Copied from maketest.g in the directory above - this is subject to change!
AUTODOC_file_scan_list := [ "../PackageInfo.g", "../doc/ExampleImplementations.xml", "../doc/PolygonalStructuresDefinitions.xml", "../gap/bend_surface.gd", "../gap/bend_surface.gi", "../gap/categories_families.gd", "../gap/coloured_simplicial_surface.gd", "../gap/coloured_simplicial_surface.gi", "../gap/colours.g", "../gap/decorated_surface.gd", "../gap/decorated_surface.gi", "../gap/folding_complex.gd", "../gap/folding_complex.gi", "../gap/folding_plan.gd", "../gap/folding_plan.gi", "../gap/modifying_simplicial_surfaces.g", "../gap/simplicial_surface.gd", "../gap/simplicial_surface.gi", "../gap/simplicial_surface_fan.gd", "../gap/simplicial_surface_fan.gi", "../gap/simplicial_surface_identification.gd", "../gap/simplicial_surface_identification.gi", "../gap/test.g", "../gap/utilities.g", "../gap/wild_simplicial_surface.gd", "../gap/wild_simplicial_surface.gi", "../init.g", "../makedoc.g", "../maketest.g", "../read.g" ];

LoadPackage( "GAPDoc" );

example_tree := ExtractExamples( Directory("../doc/"), "SimplicialSurfaces.xml", AUTODOC_file_scan_list, 500 );

TestCoverage := function()
    SIMPLICIAL_TestAll();
    RunExamples( example_tree, rec( compareFunction := "uptowhitespace" ) );
end;

SIMPLICIAL_COLOURS_ON := false;
LineByLineProfileFunction( TestCoverage, [] );
SIMPLICIAL_COLOURS_ON := true;



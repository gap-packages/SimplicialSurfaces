#
# SimplicialSurfaces: Computation with simplicial surfaces and folding processes.
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "SimplicialSurfaces" );
SIMPLICIAL_TestAll();
SIMPLICIAL_COLOURS_ON := false;



TestDirectory(DirectoriesPackageLibrary( "SimplicialSurfaces", "tst" ),
  rec(exitGAP := true, testOptions:=rec(compareFunction:="uptowhitespace")));

FORCE_QUIT_GAP(1); # if we ever get here, there was an error

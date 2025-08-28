if fail = LoadPackage("AutoDoc", "2019.05.20") then
    Error("AutoDoc version 2019.05.20 or newer is required.");
    QUIT_GAP(1);
fi;

if fail = LoadPackage("GAPDoc", "1.6") then
    Error("GAPDoc version 1.6 or newer is required.");
    QUIT_GAP(1);
fi;

# We load the package since we need it for some computations in the manual
if fail = LoadPackage("SimplicialSurfaces") then
    Error("SimplicialSurfaces package has to be available.");
fi;

# Create binary and index files for the library
__SIMPLICIAL_LibraryConstructBinary();
__SIMPLICIAL_LibraryConstructIndex();

AutoDoc( rec( scaffold := rec(
                    MainPage := false,
                    bib := "SimplicialSurfaces"), 
              dir := "doc/",
              extract_examples := true,
	          autodoc := rec( 
                    files := [ ],
                    scan_dirs := ["doc", "gap", "gap/PolygonalComplexes", "gap/Paths", "gap/Library", "gap/ColouredComplexes", "gap/Flags", "gap/Morphisms"]),
              gapdoc := rec(
                    files := ["doc/PolygonalStructuresDefinitions.xml", "doc/ExampleImplementations.xml"],
                    LaTeXOptions := rec( LateExtraPreamble := "\\input{TikZHeader.tex}\n\n" )
              ))
);

QUIT;

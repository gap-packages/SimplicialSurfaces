if fail = LoadPackage("AutoDoc", "2016.02.16") then
    Error("AutoDoc version 2016.02.16 or newer is required.");
fi;

AutoDoc( rec( scaffold := rec(
                    MainPage := false), 
	      autodoc := rec( 
                    files := [ "doc/TableOfContents.autodoc" ],
                    scan_dirs := ["doc", "gap"]) )
);

QUIT;

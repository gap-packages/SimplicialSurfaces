#############################################################################
##
#W  simpliciallib.gi       GAP simplicial surface library  
##                                                         Markus Baumeister
##                                                         Alice Niemeyer
##                                                         Wilhelm Plesken
##                                                         Ansgar Strzelczyk
##
##
#Y  Copyright (C)  2017,  Lehrstuhl B für Mathematik, RWTH Aachen University 
##
##  This file contains the routines for the simplicial surfaces library
##

BindGlobal( "__SIMPLICIAL_LoadLibrary",
    function()
        local allSurfs, absPaths, relPath, path, allFiles, file, surfs;

        # Otherwise we will fill the library
        # TODO for the moment we just load all surfaces (as we don't have many). This should be improved

        allSurfs := [];

        relPath := "pkg/simplicial-surfaces/surfaces/";
        # Find all possible paths where GAP might be and add the relative directory
        absPaths := List( GAPInfo.RootPaths, p -> Concatenation(p, relPath) );
        absPaths := Filtered( absPaths, IsDirectoryPath ); # check which ones actually exist

        # try to load surfaces from all root paths
        for path in absPaths do
            allFiles := DirectoryContents( path );

            for file in allFiles do
                # Ignore directories
                if IsDirectoryPath( Concatenation(path, file) ) then
                    continue;
                fi;

                # Ignore all unreadable files
                if not IsReadableFile( Concatenation(path, file) ) then
                    continue;
                fi;

                surfs := ReadAsFunction( Concatenation(path, file) )();
                if not IsList(surfs) then
                    Error(Concatenation("Library could not be loaded. File ", file, " should be of form 'return list'."));
                fi;
                if not ForAll(surfs, IsSimplicialSurface) then
                    Error(Concatenation("Library could not be loaded. List from ", file, " should only contain simplicial surfaces."));
                fi;

                Append( allSurfs, surfs );
            od;
        od;

        BindGlobal( "SIMPLICIAL_LIBRARY", allSurfs );
    end
);
__SIMPLICIAL_LoadLibrary();

InstallGlobalFunction( "AllSimplicialSurfaces",
    function( arg )
        local pos, surfs;

        if IsOddInt(Size(arg)) then
            Error("The number of arguments has to be even: function-solution pairs.");
        fi;

        surfs := SIMPLICIAL_LIBRARY;
        for pos in [1..Size(arg)/2] do
            surfs := Filtered( surfs, s -> arg[2*pos-1](s) in arg[2*pos] );
        od;

        return surfs;
    end
);


InstallGlobalFunction( "OneSimplicialSurface",
    function( arg )
        #TODO make this faster
        return CallFuncList(AllSimplicialSurfaces, arg)[1];
    end
);

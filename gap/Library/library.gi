#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2018
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

BindGlobal( "__SIMPLICIAL_LoadLibrary",
    function()
        local allSurfs, absPaths, relPath, path, allFiles, file, surfs;

        # Otherwise we will fill the library
        # TODO for the moment we just load all surfaces (as we don't have many). This should be improved

        allSurfs := [];

        relPath := "pkg/simplicial-surfaces/library/";
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

                # Ignore temporary files TODO
                if ForAny( [".swp", "~"], e -> EndsWith(file,e) ) then
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
                if not ForAll(surfs, IsPolygonalComplex) then
                    Error(Concatenation("Library could not be loaded. List from ", file, " should only contain polygonal complexes."));
                fi;

                Append( allSurfs, surfs );
            od;
        od;

        BindGlobal( "SIMPLICIAL_LIBRARY", allSurfs );
    end
);
__SIMPLICIAL_LoadLibrary();


BindGlobal( "__SIMPLICIAL_ReadLibraryAccessList", 
    function( argList, fctName )
        local trueArg, ind;

        trueArg := [];
        if Length(argList) = 0 then
            return trueArg;
        fi;

        if not IsFunction( argList[1] ) then
            # The first entry is the result of NumberOfFaces
            if not IsPosInt(argList[1]) and not IsList(argList[1]) and not ForAny(argList[1],IsPosInt) then
                Error(Concatenation(fctName, 
                    ": If the first argument is not a function it has to be the",
                    " result of NumberOfFaces, so either a positive integer or",
                    " a list of positive integers."));
            else
                trueArg[1] := NumberOfFaces;
                trueArg[2] := argList[1];
                ind := 2;
            fi;
        else
            ind := 1;
        fi;

        # Now we add pairs of functions and results
        while ind <= Length(argList) do
            if not IsFunction(argList[ind]) then
                Error(Concatenation(fctName,
                    ": The arguments have to alternate between functions and",
                    " their results. On position ", ind, 
                    " a function was expected but not found."));
            fi;
            Add(trueArg, argList[ind]);
            if IsBound(argList[ind+1]) and not IsFunction(argList[ind+1]) then
                # The next position is a result
                Add(trueArg, argList[ind+1]);
                ind := ind+2;
            else
                # The added function should return true
                Add(trueArg, true);
                ind := ind+1;
            fi;
        od;

        return trueArg;
    end
);

BindGlobal( "__SIMPLICIAL_AccessLibrary",
    function(argList)
        local complexes, pos, CheckAtPos;

        complexes := SIMPLICIAL_LIBRARY;
        CheckAtPos := function(complex, pos)
            local checkRes;

            checkRes := argList[2*pos-1](complex);
            return checkRes = argList[2*pos] or ( IsList(argList[2*pos]) and checkRes in argList[2*pos] );
        end;
        for pos in [1..Length(argList)/2] do
            complexes := Filtered( complexes, s -> CheckAtPos(s,pos) );
        od;

        return complexes;
    end
);

InstallGlobalFunction( "AllVEFComplexes",
    function(arg)
        local trueArg;

        trueArg := __SIMPLICIAL_ReadLibraryAccessList(arg, "AllVEFComplexes");
        return __SIMPLICIAL_AccessLibrary(trueArg);
    end
);

InstallGlobalFunction( "AllPolygonalComplexes",
    function(arg)
        local trueArg;

        trueArg := __SIMPLICIAL_ReadLibraryAccessList(arg, "AllPolygonalComplexes");
        return __SIMPLICIAL_AccessLibrary(
            Concatenation([IsPolygonalComplex, true], trueArg) );
    end
);

InstallGlobalFunction( "AllTriangularComplexes",
    function(arg)
        local trueArg;

        trueArg := __SIMPLICIAL_ReadLibraryAccessList(arg, "AllTriangularComplexes");
        return __SIMPLICIAL_AccessLibrary(
            Concatenation([IsPolygonalComplex, true, IsTriangularComplex, true], trueArg) );
    end
);

InstallGlobalFunction( "AllPolygonalSurfaces",
    function(arg)
        local trueArg;

        trueArg := __SIMPLICIAL_ReadLibraryAccessList(arg, "AllPolygonalSurfaces");
        return __SIMPLICIAL_AccessLibrary(
            Concatenation([IsPolygonalSurface, true], trueArg) );
    end
);

InstallGlobalFunction( "AllSimplicialSurfaces",
    function(arg)
        local trueArg;

        trueArg := __SIMPLICIAL_ReadLibraryAccessList(arg, "AllSimplicialSurfaces");
        return __SIMPLICIAL_AccessLibrary(
            Concatenation([IsSimplicialSurface, true], trueArg) );
    end
);



InstallGlobalFunction( "AllBendPolygonalComplexes",
    function(arg)
        local trueArg;

        trueArg := __SIMPLICIAL_ReadLibraryAccessList(arg, "AllBendPolygonalComplexes");
        return __SIMPLICIAL_AccessLibrary(
            Concatenation([IsBendPolygonalComplex, true], trueArg) );
    end
);

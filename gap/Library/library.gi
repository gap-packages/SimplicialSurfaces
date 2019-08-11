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

# Return all possible locations of the library
BindGlobal( "__SIMPLICIAL_LibraryLocation",
    function()
        local relPath, absPaths;

        relPath := "pkg/simplicial-surfaces/library/";
        # Find all possible paths where GAP might be and add the relative directory
        absPaths := List( GAPInfo.RootPaths, p -> Concatenation(p, relPath) );
        absPaths := Filtered( absPaths, IsDirectoryPath ); # check which ones actually exist

        return absPaths;
    end
);

BindGlobal( "__SIMPLICIAL_LoadLibrary",
    function()
        local allSurfs, absPaths, relPath, path, allFiles, file, surfs;

        # Otherwise we will fill the library
        # TODO for the moment we just load all surfaces (as we don't have many). This should be improved

        allSurfs := [];

        absPaths := __SIMPLICIAL_LibraryLocation();

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


# Given: Argument list from AllSimplicialSurfaces
# Returns: List of pairs [function, result OR set of possible results]
BindGlobal( "__SIMPLICIAL_ParseLibraryQuery", 
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
                trueArg[1] := [ NumberOfFaces, argList[1] ];
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
            if IsBound(argList[ind+1]) and not IsFunction(argList[ind+1]) then
                # The next position is a result
                Add(trueArg, [argList[ind], argList[ind+1]]);
                ind := ind+2;
            else
                # The added function should return true
                Add(trueArg, [argLis[ind],true]);
                ind := ind+1;
            fi;
        od;

        return trueArg;
    end
);

# Given a polygonal complex and a query (pair [function, result]),
# check whether the complex satisfies the query
BindGlobal( "__SIMPLICIAL_CheckQuery",
    function(complex, query)
        local checkResult;

        checkResult := query[1](complex);
        return checkResult = query[2] or ( IsList(query[2]) and checkResult in query[2] );
    end
);

BindGlobal( "__SIMPLICIAL_AccessLibraryRecursive",
    function(folder, queryList)
        local allFiles, subfolder, subfolders, subfiles, result,
            subDirName, recogFile, check;

        allFiles := DirectoryContents( folder );
        subfolders := Filtered(allFiles, f -> IsDirectoryPath(Concatenation(folder, f)) );
        subfiles := Filtered(allFiles, f -> 
            not IsDirectoryPath(Concatenation(folder, f)) and 
            ForAll([".swp","~"], e -> not EndsWith(f, e)) and 
            not StartsWith(f, "_") );
        
        result := [];

        # Check all subfolders
        for subfolder in subfolders do
            # Ignore folders whose name starts with "_"
            if StartsWith(subfolder, "_") then
                continue;
            fi;

            # Otherwise we try to figure out whether we need to
            # check this subdirectory
            subDirName := Concatenation(folder, subfolder);
            recogFile := Concatenation( subDirName, "_recog.g");
            if IsExistingFile(recogFile) and IsReadableFile(recogFile) then
                check := ReadAsFunction(recogFile);
                if not check(queryList) then
                    continue;
                fi;
            fi;
            Append(result, __SIMPLICIAL_AccessLibraryRecursive(subDirName, queryList));
        od;


        # Preselect the subfiles by name
        selectFile := Concatenation( folder, "_select.g" );
        if IsExistingFile(selectFile) and IsReadableFile(selectFile) then
            check := ReadAsFunction(selectFile);
            validFiles := check(query, subfiles);
        else
            validFiles := subfiles;
        fi;

        # Try to use index files to reduce the number of surfaces that have to be loaded
        indexUsed := false;
        restrictedList := [];
        indexFile := Concatenation(folder, "_index");
        if IsDirectoryPath(indexFile) then
            for query in queryList do
                queryName := NameFunction( query[1] );
                queryDirectory := Concatenation( indexFile, queryName );
                if IsDirectoryPath(queryDirectory) and not queryName = "unknown" then
                    queryResults := __SIMPLICIAL_LibraryIndexConvertQuery(queryName, query[2]);
                    possFiles := [];
                    for res in queryResults do
                        resFile := Concatenation( queryDirectory, res );
                        # TODO combine all index data into possFiles, then intersect those into restrictedList
                        # Problem: What do we do with links to other parts of the library? When do we ignore/use them?
                    od;
                fi;
            od;
        fi;

    end
);

BindGlobal( "__SIMPLICIAL_AccessLibrary",
    function(queryList)
        local libraryPath;

        libraryPath := __SIMPLICIAL_LibraryLocation();
        if Length(libraryPath) = 0 then
            Error("Surface library cannot be found.");
        fi;
        libraryPath := libraryPath[1]; # Pick just one of them. If this becomes problematic at some point, solve the problem.

        return __SIMPLICIAL_AccessLibraryRecursive(libraryPath, queryList);
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

        trueArg := __SIMPLICIAL_ParseLibraryQuery(arg, "AllVEFComplexes");
        return __SIMPLICIAL_AccessLibrary(trueArg);
    end
);

InstallGlobalFunction( "AllPolygonalComplexes",
    function(arg)
        local trueArg;

        trueArg := __SIMPLICIAL_ParseLibraryQuery(arg, "AllPolygonalComplexes");
        return __SIMPLICIAL_AccessLibrary(
            Concatenation([IsPolygonalComplex, true], trueArg) );
    end
);

InstallGlobalFunction( "AllTriangularComplexes",
    function(arg)
        local trueArg;

        trueArg := __SIMPLICIAL_ParseLibraryQuery(arg, "AllTriangularComplexes");
        return __SIMPLICIAL_AccessLibrary(
            Concatenation([IsPolygonalComplex, true, IsTriangularComplex, true], trueArg) );
    end
);

InstallGlobalFunction( "AllPolygonalSurfaces",
    function(arg)
        local trueArg;

        trueArg := __SIMPLICIAL_ParseLibraryQuery(arg, "AllPolygonalSurfaces");
        return __SIMPLICIAL_AccessLibrary(
            Concatenation([IsPolygonalSurface, true], trueArg) );
    end
);

InstallGlobalFunction( "AllSimplicialSurfaces",
    function(arg)
        local trueArg;

        trueArg := __SIMPLICIAL_ParseLibraryQuery(arg, "AllSimplicialSurfaces");
        return __SIMPLICIAL_AccessLibrary(
            Concatenation([IsSimplicialSurface, true], trueArg) );
    end
);



InstallGlobalFunction( "AllBendPolygonalComplexes",
    function(arg)
        local trueArg;

        trueArg := __SIMPLICIAL_ParseLibraryQuery(arg, "AllBendPolygonalComplexes");
        return __SIMPLICIAL_AccessLibrary(
            Concatenation([IsBendPolygonalComplex, true], trueArg) );
    end
);

# This file selects a certain number of files in which the searched
# polygonal complexes have to lie

# Here: All files start with NumberOfFaces
return function(queryList, files)
    local query, result, possResults;

    result := files;
    for query in queryList do
        if query[1] = NumberOfFaces then
            if IsInt(query[2]) then
                possResults := [query[2]];
            else
                possResults := query[2];
            fi;
            result := Filtered( result, f -> ForAny(possResults, e -> EndsWith(f,String(e))) );
        fi;
    od;

    return result;
end;

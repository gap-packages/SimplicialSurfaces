# This file selects a certain number of files in which the searched
# polygonal complexes have to lie

# Here: All files ARE NumberOfFaces
return function(queryList, files)
    local query, result, possResults, IntResults;

    IntResults := function(res)
        if IsInt(res) then
            return [res];
        else
            return res;
        fi;
    end;
    result := files;
    for query in queryList do
        if query[1] = NumberOfFaces then
            possResults := IntResults(query[2]);
            result := Filtered( result, f -> ForAny(possResults, e -> f = String(e)) );
        fi;
        if query[1] = NumberOfEdges then
            possResults := List(IntResults(query[2]),e -> 2*e/3);
            possResults := Filtered(possResults, r -> IsPosInt(r));
            result := Filtered( result, f -> ForAny(possResults, e -> f = String(e)) );
        fi;
        if query[1] = NumberOfVertices then
            possResults := List(IntResults(query[2]),e -> 2*e-4);
            possResults := Filtered(possResults, r -> IsPosInt(r));
            result := Filtered( result, f -> ForAny(possResults, e -> f = String(e)) );
        fi;
    od;

    return result;
end;

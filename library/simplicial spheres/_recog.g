# This function determines if the given query list excludes the
# directory in which this file is located.

# Here: exclude simplicial spheres
return function( queryList )
    local query;

    for query in queryList do
        # Check EulerCharacteristic
        if query[1] = EulerCharacteristic then
            if IsInt(query[2]) and query[2] <> 2 then
                return false;
            elif IsList(query[2]) and not 2 in query[2] then
                return false;
            fi;
        fi;

        if query[1] = IsTriangularComplex then
            if query[2] = false then
                return false;
            fi;
        fi;
    od;

    return true;
end;

# This function determines if the given query list excludes the
# directory in which this file is located.
# This directory contains all essential simplicial discs on up to 18 faces with
# boundary of length 16 

# Here: exclude simplicial discs
return function( queryList )
    local query, pair;

    for query in queryList do
        # these are properties that the discs in this directory have
        for pair in [
                [EulerCharacteristic,1], 
                [IsTriangularComplex,true],
                [IsClosedComplex,false],
                [IsConnectedComplex, true],
                [IsOrientableComplex, true],
                [IsEssentialDisc, true]
                ] do
            if query[1] = pair[1] and not __SIMPLICIAL_LibraryRecogUniqueResult(pair[2],query[2]) then
                return false;
            fi;
        od;
    od;

    return true;
end;


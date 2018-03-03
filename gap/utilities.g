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


BindGlobal( "__SIMPLICIAL_BoundPositions",
    function( list )
        local res, i;

        res := [];
        for i in [1..Length(list)] do
            if IsBound(list[i]) then
                Add(res, i);
            fi;
        od;
        return res;
    end
);

# This custom command is slightly faster than the regular Union if
# called for lists of sets
BindGlobal( "__SIMPLICIAL_UnionSets",
    function(list)
        local res, x;

        res := [];
        for x in list do
            Append(res,x);
        od;
        return Set(res);
    end
);


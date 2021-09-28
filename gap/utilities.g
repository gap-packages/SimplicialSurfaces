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

BindGlobal( "__SIMPLICIAL_ListToCycle",
    function(list)
        local Shift;

	# local function that shifts each entry of the list to the previous one
	Shift := function( list )
		local newList, i;

		newList := [];
		newList[ Length(list) ] := list[1];
		for i in [2..Length(list)] do
			newList[i-1] := list[i];
		od;
		return newList;
	end;

        return MappingPermListList( list, Shift(list) );
    end
);



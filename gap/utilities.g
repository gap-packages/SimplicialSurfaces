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



#############################################################################
##
#F LexicographicallyLeastDyclet . . . . . . .  lexicographically least dyclet
## 
## A dyclet represents the orbit of a list under the diherdral group of the
## list. Find the lexicographically least representative of the dyclet.
##

# called for lists of sets
BindGlobal( "__SIMPLICIAL_LexicographicallyLeastDyclet",
    function(dyclet)

    local n, min_dyclet, k, perm, mirror_dyclet;

    if (Filtered(dyclet,i-> not IsInt(i))<>[]) or (Length(dyclet)=0) then
        Error("Dyclet must be a list of integers");
        return fail;
    fi;
    n := Size(dyclet);
    # current candidate for minimal dyclet
    min_dyclet := ShallowCopy(dyclet);
    perm := Reversed(dyclet);
    if perm < min_dyclet then min_dyclet := perm; fi;

    # Generate all cyclic permutations and their mirror images
    for k in [1..n-1] do
        perm := Concatenation(dyclet{[1+k..n]}, dyclet{[1..k]});
        mirror_dyclet := Reversed(perm);
        
        if perm < min_dyclet then
            min_dyclet := perm;
        fi;
        
        if mirror_dyclet < min_dyclet then
            min_dyclet := mirror_dyclet;
        fi;
    od;

    return min_dyclet;
end
);

            
#############################################################################
##
#F LtDyclet . . . . . . . . . . . . less than comparisons of dyclets
##
BindGlobal( "__SIMPLICIAL_LtDyclet",
     function( dyc1, dyc2 )

    if __SIMPLICIAL_LexicographicallyLeastDyclet(dyc1)
       < __SIMPLICIAL_LexicographicallyLeastDyclet(dyc2) then return true;
    fi;

    return false;

end
);




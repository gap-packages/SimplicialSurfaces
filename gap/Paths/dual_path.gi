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

DeclareRepresentation( "DualPathRep", IsDualPath and IsAttributeStoringRep, [] );

BindGlobal("DualPathType", NewType( DualPathFamily, DualPathRep ));


InstallMethod(DualPath, "for a list", [IsDenseList],
    function(path)
        local obj;

        if IsEvenInt( Length(path) ) then
            Error("DualPath: The given list has to have odd length.");
        fi;
        if not ForAll( path, IsPosInt ) then
            Error("DualPath: The given list must only contain positive integers.");
        fi;

        obj := Objectify( DualPathType, rec() );
        SetPath(obj, path);

        return obj;
    end
);


InstallMethod( EvenPart, "for a dual path", [IsDualPath],
    function(dualPath)
        local path;

        path := Path(dualPath);
        return path{[2,4..Length(path)-1]};
    end
);

InstallMethod( OddPart, "for a dual path", [IsDualPath],
    function(dualPath)
        local path;

        path := Path(dualPath);
        return path{[1,3..Length(path)]};
    end
);


InstallMethod( IsClosedPath, "for a dual path", [IsDualPath],
    function(dualPath)
        local path;

        path := Path(dualPath);
        return path[1] = path[Length(path)];
    end
);


InstallMethod( IsDuplicateFree, "for a dual path", [IsDualPath],
    function(dualPath)
        local even, odd, oddSet;

        even := EvenPart(dualPath);
        odd := OddPart(dualPath);
        if Size(even) <> Size( Set(even) ) then
            return false;
        fi;
        # No duplicates in even part

        oddSet := Set(odd);
        if Size(odd) = Size(oddSet) then
            return true;
        fi;
        # There has to be a duplication in the odd part

        if not IsClosedPath(dualPath) then
            return false;
        fi;
        # There is at least one duplicate in the odd part

        return Size(odd) = 1 + Size(oddSet);
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


InstallMethod( EvenPartAsPerm, "for a closed, duplicate-free dual path",
    [IsDualPath and IsClosedPath and IsDuplicateFree],
    function(dualPath)
        local even;

        even := EvenPart(dualPath);
        return __SIMPLICIAL_ListToCycle(even);
    end
);
RedispatchOnCondition( EvenPartAsPerm, true, [IsDualPath], [IsClosedPath and IsDuplicateFree], 0 );


InstallMethod( OddPartAsPerm, "for a closed, duplicate-free dual path",
    [IsDualPath and IsClosedPath and IsDuplicateFree],
    function(dualPath)
        local odd;

        odd := OddPart(dualPath);
        return __SIMPLICIAL_ListToCycle(odd);
    end
);
RedispatchOnCondition( EvenPartAsPerm, true, [IsDualPath], [IsClosedPath and IsDuplicateFree], 0 );

InstallMethod( ViewString, "for a dual path", [IsDualPath],
    function(path)
        local str, out;
        str := "";
        out := OutputTextString(str,true);
        PrintTo( out, Path(path) );
        CloseStream(out);
        return str;
    end
);

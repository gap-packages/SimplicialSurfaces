

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
        if Length(even) <> Length( Set(even) ) then
            return false;
        fi;
        # No duplicates in even part

        oddSet := Set(odd);
        if Length(odd) = Length(oddSet) then
            return true;
        fi;
        # There has to be a duplication in the odd part

        if not IsClosedPath(dualPath) then
            return false;
        fi;
        # There is at least one duplicate in the odd part

        return Length(odd) = 1 + Length(oddSet);
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
        return __SIMPLICIAL_ListToCycle(odd{[1..Length(odd)-1]});
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

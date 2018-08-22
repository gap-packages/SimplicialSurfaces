CyclicMin := function( lst )
    local set, i, shift;

    set := [];
    for i in [1..Length(lst)] do
        # Shift the list, it should start at position i
        shift := Concatenation(lst{[i..Length(lst)]}, lst{[1..i-1]});
        Append( set, [shift, Reversed(shift)] );
    od;

    Sort(set);
    return set[1];
end;

MaxDegree := function( bendSurf )
    local umbs, max, umb, len;

    if IsPolygonalComplex(bendSurf) then
        return Maximum( FaceDegreesOfVertices(bendSurf) );
    fi;

    umbs := UmbrellaPathsOfVertices(bendSurf);
    max := 0;
    for umb in umbs do
        len := Length( FacesAsList(umb) );
        if len > max then
            max := len;
        fi;
    od;

    return max;
end;

SortedDegrees := function(surf)
    local deg, umbs;

    if IsPolygonalComplex(surf) then
        deg := ShallowCopy( FaceDegreesOfVertices(surf) );
        Sort(deg);
        return deg;
    fi;

    umbs := UmbrellaPathsOfVertices(surf);
    deg := List(umbs, u -> Length(FacesAsList(u)));
    Sort(deg);
    return deg;
end;

AutLength := function(surf)
    return Size(AutomorphismGroup(surf));
end;

SelfIntersectAbs := function(surf)
    local umbs, res, umb, i, j, count, rep, mins;

    umbs := List( UmbrellaPathsOfVertices(surf), FacesAsList );
    res := [];
    for umb in umbs do
        mins := [];
        for i in [1..Length(umb)] do
            j := i+1;
            count := 1;
            rep := false;
            while not rep do
                if j > Length(umb) then
                    j := 1;
                fi;
                if umb[i] = umb[j] then
                    rep := true;
                    break;
                fi;
                j := j+1;
                count := count+1;
            od;
            Add(mins, count);
        od;
        Add(res,CyclicMin(mins));
    od;

    Sort(res);
    return res;
end;

MinSelfIntersectAbs := function(surf)
    local umbs, res, umb, min, i, j, count, rep;

    umbs := List( UmbrellaPathsOfVertices(surf), FacesAsList );
    res := [];
    for umb in umbs do
        min := Length(umb);
        for i in [1..Length(umb)] do
            j := i+1;
            count := 1;
            rep := false;
            while not rep do
                if j > Length(umb) then
                    j := 1;
                fi;
                if umb[i] = umb[j] then
                    rep := true;
                    break;
                fi;
                j := j+1;
                count := count+1;
            od;
            if count < min then
                min := count;
            fi;
        od;
        Add(res,min);
    od;

    Sort(res);
    return res;
end;

MinSelfIntersectRel := function(surf)
    local umbs, res, umb, min, i, j, count, rep;

    umbs := List( UmbrellaPathsOfVertices(surf), FacesAsList );
    res := [];
    for umb in umbs do
        min := Length(umb);
        for i in [1..Length(umb)] do
            j := i+1;
            count := 1;
            rep := false;
            while not rep do
                if j > Length(umb) then
                    j := 1;
                fi;
                if umb[i] = umb[j] then
                    rep := true;
                    break;
                fi;
                j := j+1;
                count := count+1;
            od;
            if count/Length(umb) < min then
                min := count/Length(umb);
            fi;
        od;
        Add(res,min);
    od;

    Sort(res);
    return res;
end;

CompareAll := function( s1, s2, fctList )
    local f;

    for f in fctList do
        if f(s1) <> f(s2) then
            return false;
        fi;
    od;
    return true;
end;


InvariantCheck := function( lst )
    local res, i, j, found, cmp;

    res := [];
    for i in [1..Length(lst)] do
        found := false;
        for j in [1..Length(res)] do
            cmp := lst[res[j][1]];
            # Candidates: IsOrientable, SortedDegrees, MaxDegree, AutLength, MinSelfIntersectAbs, MinSelfIntersectRel
            if CompareAll(lst[i],cmp, [SelfIntersectAbs]) then
                Add(res[j], i);
                found := true;
                break;
            fi;
        od;
        if not found then
            Add(res, [i]);
        fi;
    od;

    return res;
end;


CombineInvariants := function( lstA, lstB )
    local eqA, eqB, dom, eqBoth;

    dom := Domain( [1..Length(lstA)] );
    eqA := EquivalenceRelationByPartition(dom, InvariantCheck(lstA));
    eqB := EquivalenceRelationByPartition(dom, InvariantCheck(lstB));

    eqBoth := MeetEquivalenceRelations(eqA,eqB);
    return EquivalenceRelationPartition(eqBoth);
end;


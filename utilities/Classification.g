LoadPackage("profiling");
LoadPackage("SimplicialSurfaces");

# Only relevant: Boundary starts with [1,1]
# it continues: ( v1, E1, v2, E4, v4, E5, v3, E3, v1 )
StandardTrianglePair := SimplicialSurfaceByDownwardIncidence( [[1,2],[2,3],[1,3],[2,4],[3,4]], [[1,2,3],[2,4,5]] );

Enlargement := function(surface)
    local autGrp, edgePairs, v, incEdgePairs, orbs, orb, splits, orbRep, splitEdge, bound, join, splitPath;

    # Compute all pairs of edges with one incident vertex that don't lie in a common face
    edgePairs := [];
    for v in VerticesAttributeOfPolygonalComplex(surface) do
        incEdgePairs := Combinations( EdgesOfVertices(surface)[v], 2);
        incEdgePairs := Filtered(incEdgePairs, p -> ForAll(EdgesOfFaces(surface), es -> not IsSubset(es, p)));
        Append(edgePairs, incEdgePairs);
    od;
    edgePairs := Set(edgePairs);

    # Compute the orbits of the automorphism group on these pairs
    autGrp := AutomorphismGroupOnEdges(surface);
    orbs := Orbits(autGrp, edgePairs, OnSets);

    # Compute all enlargements
    splits := [];
    for orb in orbs do
        orbRep := orb[1];
        splitPath := VertexEdgePathByEdgesNC(surface, orbRep);
        splitEdge := SplitEdgePathNC(surface, splitPath);
        # The second component are two vertex-edge-paths in which the cut was separated in
        bound := splitEdge[2][1][1];
        SetIsPolygonalSurface( splitEdge[1], true ); # We know that the result is a simplicial surface in this case
        join := JoinBoundaries(splitEdge[1], PathAsList(bound){[1,2]}, StandardTrianglePair, [1,1]);
        Add(splits, join[1]);
    od;

    return splits;
end;

# Assume list of non-isomorphic surfaces, add 2 faces by enlargement
IncreaseSize := function( surfaceList )
    local newSurfaces, surf;

    newSurfaces := [];
    for surf in surfaceList do
        Append(newSurfaces, Enlargement(surf));
    od;

    return PolygonalComplexIsomorphismRepresentatives(newSurfaces);
end;


CompareLists := function( list1, list2 )
    local union, unionRep;

    if Length(list1) <> Length(list2) then
        return false;
    fi;
    union := Concatenation(list1, list2);
    unionRep := PolygonalComplexIsomorphismRepresentatives(union);
    if Length(unionRep) <> Length(list1) then
        return false;
    else
        return true;
    fi;
end;


librarySurf := List( [8,10..20], i -> AllSimplicialSurfaces(i, EulerCharacteristic, 2) );
VerifyLibraryStep := function( n )
    local libSurfsSmall, libSurfsBig, enlarged;

    libSurfsSmall := librarySurf[n];
    libSurfsBig := librarySurf[n+1];
    enlarged := IncreaseSize(libSurfsSmall);
    
    return CompareLists(libSurfsBig, enlarged);
end;
# Since VerifyLibraryStep(n) for 1 up to 6 is true, exactly the surfaces from the library can be created by this enlargement

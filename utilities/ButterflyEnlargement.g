LoadPackage("SimplicialSurfaces");


# Store the spherical surfaces
spherical := [];
for i in [8,10..20] do
    spherical[i] := Set( AllSimplicialSurfaces(i, EulerCharacteristic, 2) );
od;


# Return the type (= position in list spherical) of the given surface
# (up to isomorphism).
SphericalType := function( surface )
    local pos, nrFaces, lib;

    nrFaces := NumberOfFaces(surface);
    # Load the appropriate surface list
    lib := spherical[nrFaces];

    for pos in [1..Length(lib)] do
        # Isomorphism check
        if IsIsomorphicPolygonalComplex( surface, lib[pos] ) then
            return pos;
        fi;
    od;

    return fail;
end;


# Compute the edge orbits of a surface
EdgeOrbits := function( surface )
    local aut, orb;

    # Compute the automorphism group on the edges
    aut := AutomorphismGroupOnEdges( surface );

    # Compute the orbits
    return Orbits( aut, Edges(surface) );
end;


# For a surface and an edge, remove the two adjacent faces and join
# the created boundaries.
ButterflyRemoval := function( surface, edge )
    local adFaces, adVerts, swapSurf, anomaly, edgeAn;

    # Compute adjacent faces
    adFaces := FacesOfEdge(surface, edge);

    # Compute vertices of the edge (since they have to be combined afterwards)
    adVerts := VerticesOfEdge(surface, edge);

    # Remove the faces
    swapSurf := RemoveFaces(surface, adFaces);

    # Now we have a hole. First we combine the two vertices
    swapSurf := JoinVertices(swapSurf, adVerts)[1];

    # This leaves two holes (made by the edges).
    # These can be fixed by checking the edge anomalies
    edgeAn := EdgeAnomalyClasses(swapSurf);
    for anomaly in edgeAn do
        if Length(anomaly) = 2 then
            # We found a pair of edges to be combined
            swapSurf := JoinEdges(swapSurf, anomaly)[1];
        fi;
    od;

    return swapSurf;
end;



# For a given surface, return a list of pairs:
#   first entry: edge orbit representative
#   second entry: the type of the reduced surface
ButterflyTypes := function( surface )
    local edgeOrb, res, orb, orbRep, butSurf, type;

    res := [];
    # Compute the edge orbits
    edgeOrb := EdgeOrbits( surface );

    for orb in edgeOrb do
        # Take an orbit representative
        orbRep := orb[1];

        # Compute the butterfly removal
        butSurf := ButterflyRemoval(surface, orbRep);
        
        # Compute the type of this surface
        type := SphericalType( butSurf );

        Add( res, [orbRep, type] );
    od;

    return res;
end;


# Two adjacent triangles, used for pasting into a surface with boundary
# Only relevant: Boundary starts with [1,1]
# it continues: ( v1, E1, v2, E4, v4, E5, v3, E3, v1 )
StandardTrianglePair := SimplicialSurfaceByDownwardIncidence( [[1,2],[2,3],[1,3],[2,4],[3,4]], [[1,2,3],[2,4,5]] );

# Compute enlargement by splitting open two adjacent edges (that are not
# incident to a common triangle) and inserting two faces.
Enlargement := function( surface, edgePair )
    local splitPath, splitSurf, boundPath, finalSurf;

    # The two edges define a vertex-edge-path along which the surface
    # should be cut open
    splitPath := VertexEdgePathByEdges(surface, edgePair);

    # Split the surface along this path (including inner vertices, but not 
    # boundary vertices of this path)
    splitSurf := SplitEdgePath(surface, splitPath);

    # The second component of this result are the two vertex-edge-paths in
    # which splitPath was separated
    boundPath := splitSurf[2][1][1];

    # Paste two triangles into that hole
    finalSurf := JoinBoundaries( splitSurf[1], PathAsList(boundPath){[1,2]}, StandardTrianglePair, [1,1] )[1];

    return finalSurf;
end;


# Compute the orbits on the set of edge pairs with:
#   the edges sharing a vertex
#   the edges are not incident to the same face
EdgePairOrbits := function( surface )
    local edgePairs, aut, v, incEdgePairs;

    # Compute the relevant edge pairs
    edgePairs := [];
    for v in Vertices(surface) do
        # First take all edge pairs that are incident to the common vertex v
        incEdgePairs := Combinations( EdgesOfVertices(surface)[v], 2);
        # Then remove those that lie in a common face
        incEdgePairs := Filtered(incEdgePairs, p -> ForAll(EdgesOfFaces(surface), es -> not IsSubset(es, p)));
        Append(edgePairs, incEdgePairs);
    od;
    edgePairs := Set(edgePairs);


    # Compute the automorphism group on the edges
    aut := AutomorphismGroupOnEdges(surface);

    # Compute the orbits
    return Orbits( aut, edgePairs, OnSets );
end;



# For a given surface, return a list of pairs:
#   first entry: edge-pair orbit representative
#   second entry: the type of the enlarged surface
EnlargementTypes := function( surface )
    local edgePairOrb, res, orb, orbRep, enSurf, type;

    res := [];
    # Compute the edge-pair orbits
    edgePairOrb := EdgePairOrbits( surface );

    for orb in edgePairOrb do
        # Take an orbit representative
        orbRep := orb[1];

        # Compute the enlargement
        enSurf := Enlargement(surface, orbRep);
        
        # Compute the type of this surface
        type := SphericalType( enSurf );

        Add( res, [orbRep, type] );
    od;

    return res;
end;



# Find the two spherical surfaces with 20 faces that have the same FaceCounter
allPairs := [];
for i in [1..Length(spherical[20])] do
    for j in [i+1..Length(spherical[20])] do
        if FaceCounter(spherical[20][i]) = FaceCounter(spherical[20][j]) then
            Add(allPairs, [i,j]);
        fi;
    od;
od;

# There should be only one pair
Assert( 0, Length(allPairs) = 1 );

twentyA := spherical[20][allPairs[1][1]];
twentyB := spherical[20][allPairs[1][2]];


# Compute geodesics
geoA := MaximalGeodesics( twentyA );
geoB := MaximalGeodesics( twentyB );

# Their lengths differ
List( geoA, g -> Length( FacesAsList(g) ) );
List( geoB, g -> Length( FacesAsList(g) ) );

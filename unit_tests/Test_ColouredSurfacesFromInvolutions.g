# Tests for AllWildColouredSurfaces and AllTameColouredSurfaces, given by
# three involutions. The surfaces have to be complete objects, so that
# the vertex attributes (and the isomorphism reduction) can be computed.

# Check that every surface in the list is a wild-coloured simplicial
# surface whose faces and colours match the given involutions.
BindGlobal( "__SIMPLICIAL_Test_ColouredSurfacesMatchInvolutions",
    function( surfaces, involutions )
        SIMPLICIAL_TestAssert( ForAll( surfaces, IsWildColouredSurface ) );
        SIMPLICIAL_TestAssert( ForAll( surfaces,
            s -> IsSimplicialSurface( PolygonalComplex(s) ) ) );
        SIMPLICIAL_TestAssert( ForAll( surfaces, s -> ForAll( Faces(s),
            f -> Length( VerticesOfFaces(s)[f] ) = 3 ) ) );
        SIMPLICIAL_TestAssert( ForAll( surfaces, s -> ForAll( Faces(s), f ->
            Set( ColouredEdgesOfFaces(s)[f] ) = EdgesOfFaces(s)[f] and
            List( ColouredEdgesOfFaces(s)[f], e -> ColoursOfEdges(s)[e] ) = [1,2,3] ) ) );
        # each edge of colour c is a cycle of the c-th involution
        SIMPLICIAL_TestAssert( ForAll( surfaces, s -> ForAll( Edges(s), e ->
            FacesOfEdges(s)[e] in
                Orbits( Group( involutions[ ColoursOfEdges(s)[e] ] ), Faces(s) ) ) ) );
    end
);

BindGlobal( "__SIMPLICIAL_Test_ColouredSurfacesFromInvolutions", function()
    local tetInv, octInv, tetInv2, octInv2, all, tet, proj, oct, l;

    # The tetrahedron triple gives the tetrahedron and the projective plane
    # with four faces
    tetInv := [ (1,2)(3,4), (1,3)(2,4), (1,4)(2,3) ];
    all := AllWildColouredSurfaces( tetInv, [], false );
    SIMPLICIAL_TestAssert( Length(all) = 2 );
    __SIMPLICIAL_Test_ColouredSurfacesMatchInvolutions( all, tetInv );
    SIMPLICIAL_TestAssert( SortedList( List( all,
        s -> NumberOfVertices( PolygonalComplex(s) ) ) ) = [ 3, 4 ] );
    SIMPLICIAL_TestAssert( SortedList( List( all, EulerCharacteristic ) ) = [ 1, 2 ] );
    tet := First( all, s -> EulerCharacteristic(s) = 2 );
    SIMPLICIAL_TestAssert( IsIsomorphic( PolygonalComplex(tet), Tetrahedron() ) );
    SIMPLICIAL_TestAssert( LocalSymmetryOfEdgesAsNumbers(tet) = [ 2, 2, 2, 2, 2, 2 ] );
    proj := First( all, s -> EulerCharacteristic(s) = 1 );
    SIMPLICIAL_TestAssert( not IsOrientableSurface( PolygonalComplex(proj) ) );
    SIMPLICIAL_TestAssert( LocalSymmetryOfEdgesAsNumbers(proj) = [ 1, 1, 1, 1, 1, 1 ] );
    # with the isomorphism reduction, and for tame colourings
    SIMPLICIAL_TestAssert( Length( AllWildColouredSurfaces( tetInv ) ) = 2 );
    SIMPLICIAL_TestAssert( Length( AllWildColouredSurfaces( tetInv, [] ) ) = 2 );
    SIMPLICIAL_TestAssert( Length( AllTameColouredSurfaces( tetInv ) ) = 2 );

    # The octahedron triple gives six classes
    octInv := [ (1,3)(2,4)(5,7)(6,8), (1,7)(2,8)(3,5)(4,6), (1,4)(2,3)(5,8)(6,7) ];
    oct := AllWildColouredSurfaces( octInv );
    SIMPLICIAL_TestAssert( Length(oct) = 6 );
    SIMPLICIAL_TestAssert( SortedList( List( oct, EulerCharacteristic ) ) = [ 0, 0, 0, 0, 0, 2 ] );
    SIMPLICIAL_TestAssert( IsIsomorphic( PolygonalComplex( First( oct,
        s -> EulerCharacteristic(s) = 2 ) ), Octahedron() ) );
    SIMPLICIAL_TestAssert( Length( AllWildColouredSurfaces( octInv, [], false ) ) = 26 );

    # The faces do not have to be [1..n]
    tetInv2 := [ (2,5)(7,9), (2,7)(5,9), (2,9)(5,7) ];
    all := AllWildColouredSurfaces( tetInv2, [], false );
    SIMPLICIAL_TestAssert( List( all, Faces ) = [ [ 2, 5, 7, 9 ], [ 2, 5, 7, 9 ] ] );
    __SIMPLICIAL_Test_ColouredSurfacesMatchInvolutions( all, tetInv2 );
    SIMPLICIAL_TestAssert( SortedList( List( all, EulerCharacteristic ) ) = [ 1, 2 ] );
    SIMPLICIAL_TestAssert( List( all, LocalSymmetryOfEdgesAsNumbers ) =
        [ [ 1, 1, 1, 1, 1, 1 ], [ 2, 2, 2, 2, 2, 2 ] ] );
    SIMPLICIAL_TestAssert( Length( AllWildColouredSurfaces( tetInv2 ) ) = 2 );
    SIMPLICIAL_TestAssert( Length( AllTameColouredSurfaces( tetInv2 ) ) = 2 );
    octInv2 := [ (2,6)(4,8)(10,14)(12,16), (2,14)(4,16)(6,10)(8,12),
        (2,8)(4,6)(10,16)(12,14) ];
    SIMPLICIAL_TestAssert( Length( AllWildColouredSurfaces( octInv2 ) ) = 6 );
    SIMPLICIAL_TestAssert( Length( AllWildColouredSurfaces( octInv2, [], false ) ) = 26 );
    SIMPLICIAL_TestAssert( Length( AllTameColouredSurfaces( octInv2 ) ) = 4 );

    # The local symmetry is indexed by the cycles on [1..n]
    l := AllWildColouredSurfaces( octInv, [ [1,2,1,2], 1, 2 ], false );
    SIMPLICIAL_TestAssert( List( l, LocalSymmetryOfEdgesAsNumbers ) =
        [ [ 1, 2, 1, 2, 1, 1, 1, 1, 2, 2, 2, 2 ] ] );
    l := AllWildColouredSurfaces( octInv2, [ [0,1,0,2,0,0,0,1,0,2], 1, 2 ], false );
    SIMPLICIAL_TestAssert( List( l, LocalSymmetryOfEdgesAsNumbers ) =
        [ [ 1, 2, 1, 2, 1, 1, 1, 1, 2, 2, 2, 2 ] ] );
    l := AllWildColouredSurfaces( octInv2, [ [0,2,0,1,0,0,0,2,0,1], 1, 2 ], false );
    SIMPLICIAL_TestAssert( List( l, LocalSymmetryOfEdgesAsNumbers ) =
        [ [ 2, 1, 2, 1, 1, 1, 1, 1, 2, 2, 2, 2 ] ] );
end);

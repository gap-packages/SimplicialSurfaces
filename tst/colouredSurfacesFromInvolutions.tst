# Tests for AllWildColouredSurfaces and AllTameColouredSurfaces, given by
# three involutions. The surfaces have to be complete objects, so that
# the vertex attributes (and the isomorphism reduction) can be computed.
gap> START_TEST("colouredSurfacesFromInvolutions.tst");

# The tetrahedron triple gives the tetrahedron and the projective plane
# with four faces
gap> tetInv := [ (1,2)(3,4), (1,3)(2,4), (1,4)(2,3) ];;
gap> all := AllWildColouredSurfaces( tetInv, [], false );;
gap> Length(all);
2
gap> ForAll( all, IsWildColouredSurface );
true
gap> ForAll( all, s -> IsSimplicialSurface(PolygonalComplex(s)) );
true
gap> SortedList( List( all, s -> NumberOfVertices(PolygonalComplex(s)) ) );
[ 3, 4 ]
gap> SortedList( List( all, EulerCharacteristic ) );
[ 1, 2 ]
gap> ForAll( all, s -> ForAll( Faces(s), f ->
>        Length( VerticesOfFaces(s)[f] ) = 3 ) );
true
gap> ForAll( all, s -> ForAll( Faces(s), f ->
>        Set( ColouredEdgesOfFaces(s)[f] ) = EdgesOfFaces(s)[f] and
>        List( ColouredEdgesOfFaces(s)[f], e -> ColoursOfEdges(s)[e] ) = [1,2,3] ) );
true
gap> ForAll( all, s -> ForAll( Edges(s), e ->
>        FacesOfEdges(s)[e] in Orbits( Group( tetInv[ColoursOfEdges(s)[e]] ), Faces(s) ) ) );
true
gap> tet := First( all, s -> EulerCharacteristic(s) = 2 );;
gap> IsIsomorphic( PolygonalComplex(tet), Tetrahedron() );
true
gap> LocalSymmetryOfEdgesAsNumbers(tet);
[ 2, 2, 2, 2, 2, 2 ]
gap> proj := First( all, s -> EulerCharacteristic(s) = 1 );;
gap> IsOrientableSurface(PolygonalComplex(proj));
false
gap> LocalSymmetryOfEdgesAsNumbers(proj);
[ 1, 1, 1, 1, 1, 1 ]
gap> Length( AllWildColouredSurfaces( tetInv ) );
2
gap> Length( AllWildColouredSurfaces( tetInv, [] ) );
2
gap> Length( AllTameColouredSurfaces( tetInv ) );
2

# The octahedron triple gives six classes
gap> octInv := [ (1,3)(2,4)(5,7)(6,8), (1,7)(2,8)(3,5)(4,6), (1,4)(2,3)(5,8)(6,7) ];;
gap> oct := AllWildColouredSurfaces( octInv );;
gap> Length(oct);
6
gap> SortedList( List( oct, EulerCharacteristic ) );
[ 0, 0, 0, 0, 0, 2 ]
gap> IsIsomorphic( PolygonalComplex( First( oct,
>        s -> EulerCharacteristic(s) = 2 ) ), Octahedron() );
true
gap> Length( AllWildColouredSurfaces( octInv, [], false ) );
26

#
gap> STOP_TEST("colouredSurfacesFromInvolutions.tst");

# Tests for AdjacencyMatrixOfEdgeGraph, AllThreeWaistsOfComplex and
# IsThreeWaistFree

BindGlobal( "__SIMPLICIAL_Test_AdjacencyMatrixOfEdgeGraph", function()
    local triangle, doubleJanus, disjoint;

    SIMPLICIAL_TestAssert( AdjacencyMatrixOfEdgeGraph( Tetrahedron() ) =
        [ [0,1,1,1], [1,0,1,1], [1,1,0,1], [1,1,1,0] ] );

    # Rows belong to the positions in Vertices
    triangle := SimplicialSurfaceByVerticesInFaces( [ [2,5,7] ] );
    SIMPLICIAL_TestAssert( AdjacencyMatrixOfEdgeGraph( triangle ) =
        [ [0,1,1], [1,0,1], [1,1,0] ] );

    # Several edges between the same vertices are counted
    doubleJanus := SimplicialSurfaceByDownwardIncidence(
        [[3,4],[1,3],[1,4],[2,3],[2,4],[3,4]], [[1,2,3],[1,4,5],[4,5,6],[2,3,6]]);
    SIMPLICIAL_TestAssert( AdjacencyMatrixOfEdgeGraph( doubleJanus ) =
        [ [0,0,1,1], [0,0,1,1], [1,1,0,2], [1,1,2,0] ] );

    # Disconnected complexes and isolated vertices
    disjoint := SimplicialComplexByVerticesInFaces( [7], [ [1,2,3], [4,5,6] ] );
    SIMPLICIAL_TestAssert( AdjacencyMatrixOfEdgeGraph( disjoint ) =
        [ [0,1,1,0,0,0,0], [1,0,1,0,0,0,0], [1,1,0,0,0,0,0],
          [0,0,0,0,1,1,0], [0,0,0,1,0,1,0], [0,0,0,1,1,0,0],
          [0,0,0,0,0,0,0] ] );

    # Polygonal complexes
    SIMPLICIAL_TestAssert( Sum( AdjacencyMatrixOfEdgeGraph( Cube() ), Sum ) =
        2 * NumberOfEdges( Cube() ) );
end);

BindGlobal( "__SIMPLICIAL_Test_IsThreeWaistFree", function()
    local tripleTetra, doubleJanus, umbdesc, complex, surf, surfs;

    # Closed vertex-faithful surfaces use the adjacency matrix count
    SIMPLICIAL_TestAssert( IsThreeWaistFree( Tetrahedron() ) );
    SIMPLICIAL_TestAssert( IsThreeWaistFree( Octahedron() ) );
    SIMPLICIAL_TestAssert( IsThreeWaistFree( Icosahedron() ) );
    tripleTetra := SimplicialSurfaceByVerticesInFaces(
        [[1,3,5],[2,5,6],[2,3,5],[2,3,6],[1,4,5],[3,4,6],[1,3,4],[4,5,6]]);
    SIMPLICIAL_TestAssert( not IsThreeWaistFree( tripleTetra ) );

    # A known list of 3-waists is used directly
    tripleTetra := SimplicialSurfaceByVerticesInFaces(
        [[1,3,5],[2,5,6],[2,3,5],[2,3,6],[1,4,5],[3,4,6],[1,3,4],[4,5,6]]);
    SIMPLICIAL_TestAssert( List( AllThreeWaistsOfComplex( tripleTetra ),
        PathAsList ) = [ [4,7,3,8,5,10,4], [5,8,3,9,6,12,5] ] );
    SIMPLICIAL_TestAssert( not IsThreeWaistFree( tripleTetra ) );

    # Surfaces with boundary: a triangle with a boundary edge is not a 3-waist
    SIMPLICIAL_TestAssert( IsThreeWaistFree( SimplicialUmbrella(3) ) );
    SIMPLICIAL_TestAssert( IsThreeWaistFree( SimplicialUmbrella(5) ) );
    SIMPLICIAL_TestAssert( AllThreeWaistsOfComplex( SimplicialUmbrella(3) ) = [] );

    # Surfaces that are not vertex-faithful
    SIMPLICIAL_TestAssert( IsThreeWaistFree( JanusHead() ) );
    doubleJanus := SimplicialSurfaceByDownwardIncidence(
        [[3,4],[1,3],[1,4],[2,3],[2,4],[3,4]], [[1,2,3],[1,4,5],[4,5,6],[2,3,6]]);
    SIMPLICIAL_TestAssert( IsThreeWaistFree( doubleJanus ) );
    umbdesc := SimplicialSurfaceByUmbrellaDescriptor(
        [ (1,4,6,7,5,3), (1,7,5,8,2,3), (1,7,6,8,2,4), (2,4,6,8,5,3) ]);
    SIMPLICIAL_TestAssert( not IsThreeWaistFree( umbdesc ) );
    SIMPLICIAL_TestAssert( Length( AllThreeWaistsOfComplex( umbdesc ) ) = 8 );

    # Simplicial complexes that are not surfaces
    complex := SimplicialComplexByVerticesInFaces(
        Concatenation( VerticesOfFaces( tripleTetra ), [ [1,7,8] ] ) );
    SIMPLICIAL_TestAssert( not IsThreeWaistFree( complex ) );
    SIMPLICIAL_TestAssert( Length( AllThreeWaistsOfComplex( complex ) ) = 2 );
    # An edge with three faces is not inner
    complex := SimplicialComplexByVerticesInFaces(
        [ [1,2,3], [1,2,4], [1,2,5], [1,3,4] ] );
    SIMPLICIAL_TestAssert( IsThreeWaistFree( complex ) );

    # Both methods for AllThreeWaistsOfComplex agree on library surfaces,
    # and the property agrees with them. The property is computed first on
    # a fresh copy, so the counting is used where it applies.
    surfs := Concatenation( AllSimplicialSurfaces( NumberOfFaces, [1..10] ),
        AllSimplicialSpheresEssential( NumberOfFaces, [4..18] ) );
    for surf in surfs do
        SIMPLICIAL_TestAssert( AllThreeWaistsOfComplex( surf ) =
            __SIMPLICIAL_AllThreeWaistsByInnerEdgeTriples( surf ) );
        SIMPLICIAL_TestAssert( IsThreeWaistFree(
            SimplicialSurfaceByDownwardIncidence( VerticesOfEdges(surf),
                EdgesOfFaces(surf) ) ) = IsEmpty( AllThreeWaistsOfComplex( surf ) ) );
    od;

    # Essential spheres have no 3-waists
    for surf in AllSimplicialSpheresEssential( NumberOfFaces, [4..18] ) do
        SIMPLICIAL_TestAssert( IsThreeWaistFree( surf ) );
    od;
end);

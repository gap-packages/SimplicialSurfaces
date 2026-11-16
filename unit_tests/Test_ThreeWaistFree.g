# Tests for AdjacencyMatrixOfEdgeGraph, AdjacencyMatrixBooleanOfEdgeGraph,
# AllThreeWaistsOfComplex and IsThreeWaistFree

# Reference for AllThreeWaistsOfComplex: check all triples of inner edges.
# This was the method before the adjacency matrix of the edge graph was used.
BindGlobal( "__SIMPLICIAL_Test_AllThreeWaistsByInnerEdgeTriples",
    function( surface )
        local w,voe1,voe2,voe3,v1,v2,v3,waists,verticesOfEdges,facesOfEdges,temp;
         verticesOfEdges:=VerticesOfEdges(surface);
         facesOfEdges:=FacesOfEdges(surface);
         waists:=Combinations(InnerEdges(surface),3);
         waists:=Filtered(waists,w->Length(Union(verticesOfEdges{w}))=3);
         waists:=Filtered(waists,w->Length(Union(facesOfEdges{w}))=6);
         temp:=waists;
         waists:=[];
         for w in temp do
            voe1:=verticesOfEdges[w[1]];
            voe2:=verticesOfEdges[w[2]];
            voe3:=verticesOfEdges[w[3]];
            v1:=Intersection(voe1,voe2)[1];
            v2:=Intersection(voe2,voe3)[1];
            v3:=Intersection(voe1,voe3)[1];
            if Length(Set([v1,v2,v3]))=3 then
                Add(waists,[v3,w[1],v1,w[2],v2,w[3],v3]);
            fi;
         od;
         return List(waists,w->VertexEdgePathNC(surface,w));
end
);

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

BindGlobal( "__SIMPLICIAL_Test_AdjacencyMatrixBooleanOfEdgeGraph", function()
    local doubleJanus, disjoint, B, complex;

    B := AdjacencyMatrixBooleanOfEdgeGraph( Octahedron() );
    SIMPLICIAL_TestAssert( ForAll( B, IsBlistRep ) );
    SIMPLICIAL_TestAssert( B[1] = [ false, true, true, true, true, false ] );
    SIMPLICIAL_TestAssert( SizeBlist( IntersectionBlist( B[1], B[6] ) ) = 4 );

    # Several edges between the same vertices give a single true
    doubleJanus := SimplicialSurfaceByDownwardIncidence(
        [[3,4],[1,3],[1,4],[2,3],[2,4],[3,4]], [[1,2,3],[1,4,5],[4,5,6],[2,3,6]]);
    SIMPLICIAL_TestAssert( AdjacencyMatrixBooleanOfEdgeGraph( doubleJanus ) =
        List( AdjacencyMatrixOfEdgeGraph( doubleJanus ), row -> List( row, x -> x > 0 ) ) );

    # Isolated vertices give rows without true
    disjoint := SimplicialComplexByVerticesInFaces( [7], [ [1,2,3], [4,5,6] ] );
    SIMPLICIAL_TestAssert( SizeBlist( AdjacencyMatrixBooleanOfEdgeGraph( disjoint )[7] ) = 0 );

    # Agreement with the integer matrix
    for complex in Concatenation( [ Cube(), JanusHead() ],
            AllSimplicialSurfaces( NumberOfFaces, [1..8] ) ) do
        SIMPLICIAL_TestAssert( AdjacencyMatrixBooleanOfEdgeGraph( complex ) =
            List( AdjacencyMatrixOfEdgeGraph( complex ), row -> List( row, x -> x > 0 ) ) );
    od;
end);

BindGlobal( "__SIMPLICIAL_Test_IsThreeWaistFree", function()
    local tripleTetra, doubleJanus, umbdesc, complex, hidden, threeJanus, surf, surfs;

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

    # A complex that is not vertex-faithful: the faces 1 and 2 form a Janus
    # head, and its edge 1 together with the edges 4 and 5 is a 3-waist
    # through the ramified vertices 1 and 2
    hidden := PolygonalComplexByDownwardIncidence(
        [ [1,2], [1,3], [2,3], [1,4], [2,4], [1,5], [4,5], [1,6], [4,6],
          [2,7], [4,7], [2,8], [4,8] ],
        [ [1,2,3], [1,2,3], [4,6,7], [4,8,9], [5,10,11], [5,12,13] ] );
    SIMPLICIAL_TestAssert( not IsSimplicialSurface( hidden ) );
    SIMPLICIAL_TestAssert( List( AllThreeWaistsOfComplex( hidden ), PathAsList )
        = [ [2,1,1,4,4,5,2] ] );
    SIMPLICIAL_TestAssert( not IsThreeWaistFree( hidden ) );

    # Three Janus heads glued together at three vertices
    threeJanus := PolygonalComplexByDownwardIncidence(
        [ [1,2], [2,3], [1,3], [1,4], [2,4], [2,5], [3,5], [3,6], [1,6] ],
        [ [1,4,5], [1,4,5], [2,6,7], [2,6,7], [3,8,9], [3,8,9] ] );
    SIMPLICIAL_TestAssert( List( AllThreeWaistsOfComplex( threeJanus ), PathAsList )
        = [ [1,1,2,2,3,3,1] ] );
    SIMPLICIAL_TestAssert( not IsThreeWaistFree( threeJanus ) );

    # Both methods agree on complexes that are not vertex-faithful and on
    # polygonal complexes
    for complex in [ JanusHead(), doubleJanus, umbdesc, hidden, threeJanus, Cube(),
            Octahedron(), tripleTetra ] do
        SIMPLICIAL_TestAssert( AllThreeWaistsOfComplex( complex ) =
            __SIMPLICIAL_Test_AllThreeWaistsByInnerEdgeTriples( complex ) );
    od;

    # Both methods for AllThreeWaistsOfComplex agree on library surfaces,
    # and the property agrees with them. The property is computed first on
    # a fresh copy, so the counting is used where it applies.
    surfs := Concatenation( AllSimplicialSurfaces( NumberOfFaces, [1..10] ),
        AllSimplicialSpheresEssential( NumberOfFaces, [4..18] ) );
    for surf in surfs do
        SIMPLICIAL_TestAssert( AllThreeWaistsOfComplex( surf ) =
            __SIMPLICIAL_Test_AllThreeWaistsByInnerEdgeTriples( surf ) );
        SIMPLICIAL_TestAssert( IsThreeWaistFree(
            SimplicialSurfaceByDownwardIncidence( VerticesOfEdges(surf),
                EdgesOfFaces(surf) ) ) = IsEmpty( AllThreeWaistsOfComplex( surf ) ) );
    od;

    # Essential spheres have no 3-waists
    for surf in AllSimplicialSpheresEssential( NumberOfFaces, [4..18] ) do
        SIMPLICIAL_TestAssert( IsThreeWaistFree( surf ) );
    od;
end);

# Every test covers a file


BindGlobal( "__SIMPLICIAL_Test_Properties", function()
    local tet, tet_verts, tet_vertsOfEdges, tet_edges, tet_faces,
        tet_edgesOfFaces;

    tet_verts := [1..4];
    tet_edges := [1..6];
    tet_faces := [1..4];
    tet_vertsOfEdges := [[1,2],[2,3],[1,3],[2,4],[3,4],[1,4]];
    tet_edgesOfFaces := [[1,2,3],[1,4,6],[2,4,5],[3,5,6]];

    # Test the IsClosedSurface-method for general polygonal complexes
    tet := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfEdges(tet, tet_vertsOfEdges);
    SetEdgesOfFaces(tet, tet_edgesOfFaces);
    Assert(0, IsClosedSurface(tet));


    # Test the InnerVertices-method for the general case
    tet := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfEdges(tet, tet_vertsOfEdges);
    SetEdgesOfFaces(tet, tet_edgesOfFaces);
    Assert(0, InnerVertices(tet) = tet_verts);
    
    # Test the InnerVertices-method for the closed surface case
    tet := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfEdges(tet, tet_vertsOfEdges);
    SetEdgesOfFaces(tet, tet_edgesOfFaces);
    SetIsClosedSurface(tet, true);
    Assert(0, InnerVertices(tet) = tet_verts);


    # Test the BoundaryVertices-method for the general case
    tet := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfEdges(tet, tet_vertsOfEdges);
    SetEdgesOfFaces(tet, tet_edgesOfFaces);
    Assert(0, BoundaryVertices(tet) = []);

    # Test the BoundaryVertices-method for the closed surface case
    tet := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfEdges(tet, tet_vertsOfEdges);
    SetEdgesOfFaces(tet, tet_edgesOfFaces);
    SetIsClosedSurface(tet, true);
    Assert(0, BoundaryVertices(tet) = []);

    #TODO tests for other kinds of vertices and edges, preferably with more
    # complicated examples

end);


BindGlobal( "__SIMPLICIAL_Test_PolygonalHierarchy", function()
    local x;

    x := 5;
    Assert(0, not IsPolygonalComplex(x));
    Assert(0, not IsTriangularComplex(x));
    Assert(0, not IsRamifiedPolygonalSurface(x));
    Assert(0, not IsRamifiedSimplicialSurface(x));
    Assert(0, not IsPolygonalSurface(x));
    Assert(0, not IsSimplicialSurface(x));
end);



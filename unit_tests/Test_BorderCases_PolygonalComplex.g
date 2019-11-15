# Every test covers a file


BindGlobal( "__SIMPLICIAL_Test_Properties", function()
    local tet, tet_verts, tet_vertsOfEdges, tet_edges, tet_faces,
        tet_edgesOfFaces, triforce, paperAirplane, doubleTetrahedron;

    ################################
    # Case Tetrahedron
    tet_verts := [1..4];
    tet_edges := [1..6];
    tet_faces := [1..4];
    tet_vertsOfEdges := [[1,2],[2,3],[1,3],[2,4],[3,4],[1,4]];
    tet_edgesOfFaces := [[1,2,3],[1,4,6],[2,4,5],[3,5,6]];

    # Test the IsClosedSurface-method for general polygonal complexes
    tet := Objectify( TwistedPolygonalComplexType, rec() );
    SetVerticesOfEdges(tet, tet_vertsOfEdges);
    SetEdgesOfFaces(tet, tet_edgesOfFaces);
    SIMPLICIAL_TestAssert(IsClosedSurface(tet));


    # Test the InnerVertices-method for the general case
    tet := Objectify( TwistedPolygonalComplexType, rec() );
    SetVerticesOfEdges(tet, tet_vertsOfEdges);
    SetEdgesOfFaces(tet, tet_edgesOfFaces);
    SIMPLICIAL_TestAssert(InnerVertices(tet) = tet_verts);
    
    # Test the InnerVertices-method for the closed surface case
    tet := Objectify( TwistedPolygonalComplexType, rec() );
    SetVerticesOfEdges(tet, tet_vertsOfEdges);
    SetEdgesOfFaces(tet, tet_edgesOfFaces);
    SetIsClosedSurface(tet, true);
    SIMPLICIAL_TestAssert(InnerVertices(tet) = tet_verts);


    # Test the BoundaryVertices-method for the general case
    tet := Objectify( TwistedPolygonalComplexType, rec() );
    SetVerticesOfEdges(tet, tet_vertsOfEdges);
    SetEdgesOfFaces(tet, tet_edgesOfFaces);
    SIMPLICIAL_TestAssert(BoundaryVertices(tet) = []);

    # Test the BoundaryVertices-method for the closed surface case
    tet := Objectify( TwistedPolygonalComplexType, rec() );
    SetVerticesOfEdges(tet, tet_vertsOfEdges);
    SetEdgesOfFaces(tet, tet_edgesOfFaces);
    SetIsClosedSurface(tet, true);
    SIMPLICIAL_TestAssert(BoundaryVertices(tet) = []);

    #TODO tests for other kinds of vertices and edges, preferably with more
    # complicated examples
	
    ############################

    # Case PaperAirplane
    paperAirplane:= PolygonalComplexByDownwardIncidence(
        [,,,,,[1,5],[5,2],[2,3],[3,5],[5,4],[4,2],[2,1]],
        [[6,12,7],[7,9,8],[11,10,7]]);  

    # Test Inner Edges
    SIMPLICIAL_TestAssert(IsInnerEdge(paperAirplane,9)=false);
    SIMPLICIAL_TestAssert(IsInnerEdgeNC(paperAirplane,7)=false); 
    SIMPLICIAL_TestAssert(InnerEdges(paperAirplane)=[]);

    # Test Boundary Edges
    SIMPLICIAL_TestAssert(IsBoundaryEdge(paperAirplane,9)=true);
    SIMPLICIAL_TestAssert(IsBoundaryEdge(paperAirplane,7)=false);
    SIMPLICIAL_TestAssert(BoundaryEdges(paperAirplane)=[ 6, 8, 9, 10, 11, 12 ]);

    # Test Ramified Edges
    SIMPLICIAL_TestAssert(IsRamifiedEdge(paperAirplane,9)=false);
    SIMPLICIAL_TestAssert(IsRamifiedEdgeNC(paperAirplane,7)=true);
    SIMPLICIAL_TestAssert(RamifiedEdges(paperAirplane)=[ 7 ]);

    # Test Inner Vertex
    SIMPLICIAL_TestAssert(IsInnerVertex(paperAirplane,3)=false);
    SIMPLICIAL_TestAssert(IsInnerVertexNC(paperAirplane,5)=false);
    SIMPLICIAL_TestAssert(InnerVertices(paperAirplane)=[]);

    # Test Boundary Vertex
    SIMPLICIAL_TestAssert(IsBoundaryVertex(paperAirplane,3)=true);
    SIMPLICIAL_TestAssert(IsBoundaryVertexNC(paperAirplane,5)=false);
    SIMPLICIAL_TestAssert(BoundaryVertices(paperAirplane)=[1,3,4]);

    # Test Ramified Vertex
    SIMPLICIAL_TestAssert(IsRamifiedVertex(paperAirplane,3)=false);
    SIMPLICIAL_TestAssert(IsRamifiedVertexNC(paperAirplane,5)=false);
    SIMPLICIAL_TestAssert(RamifiedVertices(paperAirplane)=[]);

    # Test Chaotic Vertex
    SIMPLICIAL_TestAssert(IsChaoticVertex(paperAirplane,3)=false);
    SIMPLICIAL_TestAssert(IsChaoticVertexNC(paperAirplane,5)=true);
    SIMPLICIAL_TestAssert(ChaoticVertices(paperAirplane)=[2,5]);

    ########################################
 
    # Case triforce
    triforce:= PolygonalComplexByDownwardIncidence(
        [,,,,,,[1,2],[1,3],[2,3],[3,6],[6,5],[5,4],[4,2],[2,5],[5,3]],
        [[7,8,9],[10,11,15],[12,13,14]]);

    # Test Inner Edges
    SIMPLICIAL_TestAssert(IsInnerEdge(triforce,7)=false);
    SIMPLICIAL_TestAssert(IsInnerEdgeNC(triforce,10)=false); 
    SIMPLICIAL_TestAssert(InnerEdges(triforce)=[]);

    # Test Boundary Edges
    SIMPLICIAL_TestAssert(IsBoundaryEdge(triforce,7)=true);
    SIMPLICIAL_TestAssert(IsBoundaryEdge(triforce,10)=true);
    SIMPLICIAL_TestAssert(BoundaryEdges(triforce)=[ 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);

    # Test Ramified Edges
    SIMPLICIAL_TestAssert(IsRamifiedEdge(triforce,9)=false);
    SIMPLICIAL_TestAssert(IsRamifiedEdgeNC(triforce,10)=false);
    SIMPLICIAL_TestAssert(RamifiedEdges(triforce)=[]);

    # Test Inner Vertex
    SIMPLICIAL_TestAssert(IsInnerVertex(triforce,3)=false);
    SIMPLICIAL_TestAssert(IsInnerVertexNC(triforce,6)=false);
    SIMPLICIAL_TestAssert(InnerVertices(triforce)=[]);

    # Test Boundary Vertex
    SIMPLICIAL_TestAssert(IsBoundaryVertex(triforce,3)=false);
    SIMPLICIAL_TestAssert(IsBoundaryVertexNC(triforce,6)=true);
    SIMPLICIAL_TestAssert(BoundaryVertices(triforce)=[1,4,6]);

    # Test Ramified Vertex
    SIMPLICIAL_TestAssert(IsRamifiedVertex(triforce,3)=true);
    SIMPLICIAL_TestAssert(IsRamifiedVertexNC(triforce,6)=false);
    SIMPLICIAL_TestAssert(RamifiedVertices(triforce)=[ 2, 3, 5 ]);

    # Test Chaotic Vertex
    SIMPLICIAL_TestAssert(IsChaoticVertex(triforce,3)=false);
    SIMPLICIAL_TestAssert(IsChaoticVertexNC(triforce,6)=false);
    SIMPLICIAL_TestAssert(ChaoticVertices(triforce)=[]);

    ########################################

    # Case DoubleTetrahedron
    doubleTetrahedron := PolygonalComplexByDownwardIncidence(
        [,,,,,,,[1,6],[1,5],[5,6],[2,6],[2,5],[1,2],[2,7],[4,7],[3,7],[2,4],
          [4,3],[2,3]],
        [[8,9,10],[10,11,12],[9,12,13],[8,13,11],[14,17,15],[15,18,16],
          [17,19,18],[14,16,19]]); 

    # Test Inner Edges
    SIMPLICIAL_TestAssert(IsInnerEdge(doubleTetrahedron,11)=true);
    SIMPLICIAL_TestAssert(IsInnerEdgeNC(doubleTetrahedron,16)=true); 
    SIMPLICIAL_TestAssert(InnerEdges(doubleTetrahedron)=[ 8, 9, 10, 11, 12, 13, 14, 15,
         16, 17, 18, 19 ]);

    # Test Boundary Edges
    SIMPLICIAL_TestAssert(IsBoundaryEdge(doubleTetrahedron,11)=false);
    SIMPLICIAL_TestAssert(IsBoundaryEdge(doubleTetrahedron,16)=false);
    SIMPLICIAL_TestAssert(BoundaryEdges(doubleTetrahedron)=[]);

    # Test Ramified Edges
    SIMPLICIAL_TestAssert(IsRamifiedEdge(doubleTetrahedron,11)=false);
    SIMPLICIAL_TestAssert(IsRamifiedEdgeNC(doubleTetrahedron,16)=false);
    SIMPLICIAL_TestAssert(RamifiedEdges(doubleTetrahedron)=[]);

    # Test Inner Vertex
    SIMPLICIAL_TestAssert(IsInnerVertex(doubleTetrahedron,2)=false);
    SIMPLICIAL_TestAssert(IsInnerVertexNC(doubleTetrahedron,7)=true);
    SIMPLICIAL_TestAssert(InnerVertices(doubleTetrahedron)=[ 1, 3, 4, 5, 6, 7 ]);

    # Test Boundary Vertex
    SIMPLICIAL_TestAssert(IsBoundaryVertex(doubleTetrahedron,2)=false);
    SIMPLICIAL_TestAssert(IsBoundaryVertexNC(doubleTetrahedron,7)=false);
    SIMPLICIAL_TestAssert(BoundaryVertices(doubleTetrahedron)=[]);

    # Test Ramified Vertex
    SIMPLICIAL_TestAssert(IsRamifiedVertex(doubleTetrahedron,2)=true);
    SIMPLICIAL_TestAssert(IsRamifiedVertexNC(doubleTetrahedron,7)=false);
    SIMPLICIAL_TestAssert(RamifiedVertices(doubleTetrahedron)=[ 2 ]);

    # Test Chaotic Vertex
    SIMPLICIAL_TestAssert(IsChaoticVertex(doubleTetrahedron,2)=false);
    SIMPLICIAL_TestAssert(IsChaoticVertexNC(doubleTetrahedron,7)=false);
    SIMPLICIAL_TestAssert(ChaoticVertices(doubleTetrahedron)=[]);


end);


BindGlobal( "__SIMPLICIAL_Test_PolygonalHierarchy", function()
    local x;

    x := 5;
    SIMPLICIAL_TestAssert(not IsPolygonalComplex(x));
    SIMPLICIAL_TestAssert(not IsTriangularComplex(x));
    SIMPLICIAL_TestAssert(not IsPolygonalSurface(x));
    SIMPLICIAL_TestAssert(not IsSimplicialSurface(x));
end);

BindGlobal( "__SIMPLICIAL_Test_SplitEdge", function()
    local oct, split, split2, split3, triangle, eye, eye1, eye2, hourglass, hourglass1;

    #Test repeated spliting
    oct := Octahedron();
    split := SplitEdge(oct, 1);
    SIMPLICIAL_TestAssert(split[2] = [13, 14]);
    SIMPLICIAL_TestAssert(split = SplitEdgeNC(oct, 1));

    split2 := SplitEdge(split[1], 2);
    SIMPLICIAL_TestAssert(split2[2] = [15, 16]);
    SIMPLICIAL_TestAssert(split2 = SplitEdgeNC(split[1], 2));

    split3 := SplitEdge(split2[1], 5);
    SIMPLICIAL_TestAssert(split3[2] = [17, 18]);
    SIMPLICIAL_TestAssert(split3 = SplitEdgeNC(split2[1], 5));

    #Test if spliting outer edge changes anything
    triangle := SimplicialSurfaceByDownwardIncidence([[1,2], [1,3], [2,3]], [[1,2,3]]);
    split := SplitEdge(triangle, 3);
    SIMPLICIAL_TestAssert(split[2] = [3]);
    SIMPLICIAL_TestAssert(split = SplitEdgeNC(triangle, 3));

    #
    eye := PolygonalComplexByDownwardIncidence([[1,2], [2,3], [3,4], [4,1], [1,3], [1,3]], [[1,2,5], [5, 6], [3,4,6]]);
    eye1 := PolygonalComplexByDownwardIncidence([[1,2], [2,3], [3,4], [4,1],, [1,3], [1,3], [1,3]], [[1,2,7], [8, 6], [3,4,6]]);
    eye2 := PolygonalComplexByDownwardIncidence([[1,2], [2,3], [3,4], [4,1],,, [1,3], [1,3], [1,3], [1,3]], [[1,2,7], [8, 9], [3,4,10]]);
    SIMPLICIAL_TestAssert(SplitEdge(eye, 5)[1] = eye1);
    SIMPLICIAL_TestAssert(SplitEdgeNC(eye, 5)[1] = eye1);
    SIMPLICIAL_TestAssert(SplitEdge(eye1, 6)[1] = eye2);
    SIMPLICIAL_TestAssert(SplitEdgeNC(eye1, 6)[1] = eye2);

    #
    hourglass := PolygonalComplexByDownwardIncidence([[1,2], [2,3], [1,3], [3,2], [3,1]], [[1,2,3], [4,5,1]]);
    hourglass1 := PolygonalComplexByDownwardIncidence([, [2,3], [1,3], [3,2], [3,1], [1,2], [1,2]], [[6,2,3], [4,5,7]]);
    SIMPLICIAL_TestAssert(SplitEdge(hourglass, 1) = [hourglass1, [6,7]]);
    SIMPLICIAL_TestAssert(SplitEdgeNC(hourglass, 1) = [hourglass1, [6,7]]);

end);

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
	
    ############################

    # Case PaperAirplane
    paperAirplane:= PolygonalComplexByDownwardIncidence(
        [,,,,,[1,5],[5,2],[2,3],[3,5],[5,4],[4,2],[2,1]],
        [[6,12,7],[7,9,8],[11,10,7]]);  

    # Test Inner Edges
    Assert(0,IsInnerEdge(paperAirplane,9)=false);
    Assert(0,IsInnerEdgeNC(paperAirplane,7)=false); 
    Assert(0,InnerEdges(paperAirplane)=[]);

    # Test Boundary Edges
    Assert(0,IsBoundaryEdge(paperAirplane,9)=true);
    Assert(0,IsBoundaryEdge(paperAirplane,7)=false);
    Assert(0,BoundaryEdges(paperAirplane)=[ 6, 8, 9, 10, 11, 12 ]);

    # Test Ramified Edges
    Assert(0,IsRamifiedEdge(paperAirplane,9)=false);
    Assert(0,IsRamifiedEdgeNC(paperAirplane,7)=true);
    Assert(0,RamifiedEdges(paperAirplane)=[ 7 ]);

    # Test Inner Vertex
    Assert(0,IsInnerVertex(paperAirplane,3)=false);
    Assert(0,IsInnerVertexNC(paperAirplane,5)=false);
    Assert(0,InnerVertices(paperAirplane)=[]);

    # Test Boundary Vertex
    Assert(0,IsBoundaryVertex(paperAirplane,3)=true);
    Assert(0,IsBoundaryVertexNC(paperAirplane,5)=false);
    Assert(0,BoundaryVertices(paperAirplane)=[1,3,4]);

    # Test Ramified Vertex
    Assert(0,IsRamifiedVertex(paperAirplane,3)=false);
    Assert(0,IsRamifiedVertexNC(paperAirplane,5)=false);
    Assert(0,RamifiedVertices(paperAirplane)=[]);

    # Test Chaotic Vertex
    Assert(0,IsChaoticVertex(paperAirplane,3)=false);
    Assert(0,IsChaoticVertexNC(paperAirplane,5)=true);
    Assert(0,ChaoticVertices(paperAirplane)=[2,5]);

    ########################################
 
    # Case triforce
    triforce:= PolygonalComplexByDownwardIncidence(
        [,,,,,,[1,2],[1,3],[2,3],[3,6],[6,5],[5,4],[4,2],[2,5],[5,3]],
        [[7,8,9],[10,11,15],[12,13,14]]);

    # Test Inner Edges
    Assert(0,IsInnerEdge(triforce,7)=false);
    Assert(0,IsInnerEdgeNC(triforce,10)=false); 
    Assert(0,InnerEdges(triforce)=[]);

    # Test Boundary Edges
    Assert(0,IsBoundaryEdge(triforce,7)=true);
    Assert(0,IsBoundaryEdge(triforce,10)=true);
    Assert(0,BoundaryEdges(triforce)=[ 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);

    # Test Ramified Edges
    Assert(0,IsRamifiedEdge(triforce,9)=false);
    Assert(0,IsRamifiedEdgeNC(triforce,10)=false);
    Assert(0,RamifiedEdges(triforce)=[]);

    # Test Inner Vertex
    Assert(0,IsInnerVertex(triforce,3)=false);
    Assert(0,IsInnerVertexNC(triforce,6)=false);
    Assert(0,InnerVertices(triforce)=[]);

    # Test Boundary Vertex
    Assert(0,IsBoundaryVertex(triforce,3)=false);
    Assert(0,IsBoundaryVertexNC(triforce,6)=true);
    Assert(0,BoundaryVertices(triforce)=[1,4,6]);

    # Test Ramified Vertex
    Assert(0,IsRamifiedVertex(triforce,3)=true);
    Assert(0,IsRamifiedVertexNC(triforce,6)=false);
    Assert(0,RamifiedVertices(triforce)=[ 2, 3, 5 ]);

    # Test Chaotic Vertex
    Assert(0,IsChaoticVertex(triforce,3)=false);
    Assert(0,IsChaoticVertexNC(triforce,6)=false);
    Assert(0,ChaoticVertices(triforce)=[]);

    ########################################

    # Case DoubleTetrahedron
    doubleTetrahedron := PolygonalComplexByDownwardIncidence(
        [,,,,,,,[1,6],[1,5],[5,6],[2,6],[2,5],[1,2],[2,7],[4,7],[3,7],[2,4],
          [4,3],[2,3]],
        [[8,9,10],[10,11,12],[9,12,13],[8,13,11],[14,17,15],[15,18,16],
          [17,19,18],[14,16,19]]); 

    # Test Inner Edges
    Assert(0,IsInnerEdge(doubleTetrahedron,11)=true);
    Assert(0,IsInnerEdgeNC(doubleTetrahedron,16)=true); 
    Assert(0,InnerEdges(doubleTetrahedron)=[ 8, 9, 10, 11, 12, 13, 14, 15,
         16, 17, 18, 19 ]);

    # Test Boundary Edges
    Assert(0,IsBoundaryEdge(doubleTetrahedron,11)=false);
    Assert(0,IsBoundaryEdge(doubleTetrahedron,16)=false);
    Assert(0,BoundaryEdges(doubleTetrahedron)=[]);

    # Test Ramified Edges
    Assert(0,IsRamifiedEdge(doubleTetrahedron,11)=false);
    Assert(0,IsRamifiedEdgeNC(doubleTetrahedron,16)=false);
    Assert(0,RamifiedEdges(doubleTetrahedron)=[]);

    # Test Inner Vertex
    Assert(0,IsInnerVertex(doubleTetrahedron,2)=false);
    Assert(0,IsInnerVertexNC(doubleTetrahedron,7)=true);
    Assert(0,InnerVertices(doubleTetrahedron)=[ 1, 3, 4, 5, 6, 7 ]);

    # Test Boundary Vertex
    Assert(0,IsBoundaryVertex(doubleTetrahedron,2)=false);
    Assert(0,IsBoundaryVertexNC(doubleTetrahedron,7)=false);
    Assert(0,BoundaryVertices(doubleTetrahedron)=[]);

    # Test Ramified Vertex
    Assert(0,IsRamifiedVertex(doubleTetrahedron,2)=true);
    Assert(0,IsRamifiedVertexNC(doubleTetrahedron,7)=false);
    Assert(0,RamifiedVertices(doubleTetrahedron)=[ 2 ]);

    # Test Chaotic Vertex
    Assert(0,IsChaoticVertex(doubleTetrahedron,2)=false);
    Assert(0,IsChaoticVertexNC(doubleTetrahedron,7)=false);
    Assert(0,ChaoticVertices(doubleTetrahedron)=[]);


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

BindGlobal( "__SIMPLICIAL_Test_SplitEdge", function()
    local oct, split, split2, split3, triangle, eye, eye1, eye2, hourglass, hourglass1;

    #Test repeated spliting
    oct := Octahedron();
    split := SplitEdge(oct, 1);
    Assert(0, split[2] = [13, 14]);
    Assert(0, split = SplitEdgeNC(oct, 1));

    split2 := SplitEdge(split[1], 2);
    Assert(0, split2[2] = [15, 16]);
    Assert(0, split2 = SplitEdgeNC(split[1], 2));

    split3 := SplitEdge(split2[1], 5);
    Assert(0, split3[2] = [17, 18]);
    Assert(0, split3 = SplitEdgeNC(split2[1], 5));

    #Test if spliting outer edge changes anything
    triangle := SimplicialSurfaceByDownwardIncidence([[1,2], [1,3], [2,3]], [[1,2,3]]);
    split := SplitEdge(triangle, 3);
    Assert(0, split[2] = [3]);
    Assert(0, split = SplitEdgeNC(triangle, 3));

    #
    eye := PolygonalComplexByDownwardIncidence([[1,2], [2,3], [3,4], [4,1], [1,3], [1,3]], [[1,2,5], [5, 6], [3,4,6]]);
    eye1 := PolygonalComplexByDownwardIncidence([[1,2], [2,3], [3,4], [4,1],, [1,3], [1,3], [1,3]], [[1,2,7], [8, 6], [3,4,6]]);
    eye2 := PolygonalComplexByDownwardIncidence([[1,2], [2,3], [3,4], [4,1],,, [1,3], [1,3], [1,3], [1,3]], [[1,2,7], [8, 9], [3,4,10]]);
    Assert(0, SplitEdge(eye, 5)[1] = eye1);
    Assert(0, SplitEdgeNC(eye, 5)[1] = eye1);
    Assert(0, SplitEdge(eye1, 6)[1] = eye2);
    Assert(0, SplitEdgeNC(eye1, 6)[1] = eye2);

    #
    hourglass := PolygonalComplexByDownwardIncidence([[1,2], [2,3], [1,3], [3,2], [3,1]], [[1,2,3], [4,5,1]]);
    hourglass1 := PolygonalComplexByDownwardIncidence([, [2,3], [1,3], [3,2], [3,1], [1,2], [1,2]], [[6,2,3], [4,5,7]]);
    Assert(0, SplitEdge(hourglass, 1) = [hourglass1, [6,7]]);
    Assert(0, SplitEdgeNC(hourglass, 1) = [hourglass1, [6,7]]);

end);

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
    SIMPLICIAL_TestAssert(IsClosedSurface(tet));


    # Test the InnerVertices-method for the general case
    tet := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfEdges(tet, tet_vertsOfEdges);
    SetEdgesOfFaces(tet, tet_edgesOfFaces);
    SIMPLICIAL_TestAssert(InnerVertices(tet) = tet_verts);
    
    # Test the InnerVertices-method for the closed surface case
    tet := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfEdges(tet, tet_vertsOfEdges);
    SetEdgesOfFaces(tet, tet_edgesOfFaces);
    SetIsClosedSurface(tet, true);
    SIMPLICIAL_TestAssert(InnerVertices(tet) = tet_verts);


    # Test the BoundaryVertices-method for the general case
    tet := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfEdges(tet, tet_vertsOfEdges);
    SetEdgesOfFaces(tet, tet_edgesOfFaces);
    SIMPLICIAL_TestAssert(BoundaryVertices(tet) = []);

    # Test the BoundaryVertices-method for the closed surface case
    tet := Objectify( PolygonalComplexType, rec() );
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

BindGlobal( "__SIMPLICIAL_Test_JoinEdges", function()
     local eye,closeEye, triple, tripleTogether, tripleDoubleTogether, 
           falseTriforce, fT1, fT2, fT3, fT4, fT5, fT6, s, s1;

     #Test Close Eye

      eye := PolygonalComplexByDownwardIncidence(
              [[1,2],[2,3],[1,3],[2,4],[3,4],[2,3]],
              [[1,2,3],[4,5,6]]);;

      closeEye := JoinEdges( eye, 2, 6 );;
      Assert(0,InnerEdges(closeEye[1])=[7]);

      #Test Triple

      triple := PolygonalComplexByDownwardIncidence(
              [[1,2],[2,3],[3,1],[1,3],[3,4],[4,1],[1,3],[3,5],[5,1]],
              [[1,2,3],[4,5,6],[7,8,9]]);

      tripleTogether := JoinEdges(triple, [3,4])[1];
      tripleDoubleTogether:=JoinEdges(tripleTogether,[7,10])[1];

      Assert(0,InnerEdges(tripleTogether)=[10]);
      Assert(0,InnerEdges(tripleDoubleTogether)=[]);
      Assert(0,RamifiedEdges(tripleDoubleTogether)=[11]);

      # Test False Triforce

      falseTriforce := PolygonalComplexByDownwardIncidence(
               [[1,2],[2,3],[3,1],[3,4],[4,1],[1,3],[4,2],[2,1],[1,4],[2,3],
               [3,4],[4,2]],
              [[1,2,3],[4,5,6],[7,8,9],[10,11,12]]);

      fT1 := JoinEdgesNC(falseTriforce,[2,10])[1];
      fT2 := JoinEdgesNC(fT1,4,11)[1];
      fT3 := JoinEdges(fT2,[7,12])[1];
      fT4 := JoinEdges(fT3,1,8)[1];
      fT5 := JoinEdges(fT4,[3,6],99)[1];
      fT6 := JoinEdges(fT5,5,9,100)[1];

      Assert(0,InnerEdges(fT1) = [13]);
      Assert(0,EdgesOfFace(fT3,4) = [ 13, 14, 15 ]);
      Assert(0,InnerEdges(fT6)=[ 13, 14, 15, 16, 99, 100]);

      s:=PolygonalComplexByDownwardIncidence([[1,2],[1,3],[2,3],[1,2],[2,4],[1,4],[1,2],[2,5],[1,5]],[[1,2,3],[4,5,6],[7,8,9]]);
      s1:=JoinEdges(s,[1,4,7]);
      Assert(0,FacesOfEdge(s1[1],10)=[1,2,3]);
 end);

BindGlobal( "__SIMPLICIAL_Test_SplitVertex", function()
    local ramSurf,split1,hex,edgeSplit,vertSplit,triangle,split2,fiveGon,split3;

    #two umbrella partitions
    ramSurf := PolygonalComplexByDownwardIncidence([ ,,,,,,,,,,,,[6,5],[1,5],[5,7],[6,1],[6,7],[1,7],[1,8],[1,10],[1,12],[8,10],[10,12]],
		[,[14,15,18],[13,14,16],[16,17,18],,,,,[19,22,20],,[20,21,23]]);
    split1 := SplitVertex(ramSurf, 1);
    SIMPLICIAL_TestAssert(split1[2] = [13, 14]);
    SIMPLICIAL_TestAssert(split1 = SplitVertexNC(ramSurf, 1));

    hex := SimplicialSurfaceByDownwardIncidence([ [1,7],[2,7],[3,7],[4,7],[5,7],[6,7],[1,2],[2,3],[3,4],[4,5],[5,6],[1,6] ],
		[ [1,2,7],[2,3,8],[3,4,9],[4,5,10],[5,6,11],[1,6,12] ]);
    edgeSplit := SplitEdge(hex, 1);
    vertSplit := SplitVertex( edgeSplit[1], 1 );
    SIMPLICIAL_TestAssert(vertSplit[2] = [8,9]);
    SIMPLICIAL_TestAssert(vertSplit = SplitVertexNC(edgeSplit[1], 1));

    #Test if spliting outer vertices changes anything
    triangle := SimplicialSurfaceByDownwardIncidence([[1,2], [1,3], [2,3]], [[1,2,3]]);
    split2 := SplitVertex(triangle, 3);
    SIMPLICIAL_TestAssert(split2[2] = [3]);
    SIMPLICIAL_TestAssert(split2 = SplitVertexNC(triangle, 3));

    #Test if spliting vertices with one umbrella partition changes anything
    fiveGon:=SimplicialSurfaceByDownwardIncidence([[2,6], [2,3], [3,4], [4,5], [5,6], [1,2], [1,6], [1,3], [1,4], [1,5]],
		[[1,6,7], [2,6,8], [3,8,9], [4,9,10], [5,7,10]]);
    split3 := SplitVertex(fiveGon, 1);
    SIMPLICIAL_TestAssert(split3[2] = [1]);
    SIMPLICIAL_TestAssert(split3 = SplitEdgeNC(fiveGon, 1));
 end);

 BindGlobal( "__SIMPLICIAL_Test_JoinVertices", function()
     local doubleTriangle, openDoubleTriangle, isomorph, doubleSquare, 
 	doubleSquare1, doubleSquare2, doubleSquare3;

     #Test Double Triangle

     doubleTriangle := PolygonalComplexByDownwardIncidence(
 	[[1,2],[2,3],[3,4],[4,1],[4,2]],
 	[[1,4,5],[2,3,5]]); 

     openDoubleTriangle := JoinVertices(doubleTriangle,1,3)[1];

     Assert(0,BoundaryVertices(openDoubleTriangle) = [2,4]);
     Assert(0,RamifiedVertices(openDoubleTriangle) = [5]);

     #Test Moebius Band

     doubleSquare := PolygonalComplexByDownwardIncidence(
 	[[1,2],[2,3],[3,4],[4,5],[5,6],[6,1],[2,5]],
 	[[2,3,4,7],[1,5,6,7]]);
     doubleSquare1 := JoinVerticesNC(doubleSquare,[1,4])[1];
     doubleSquare2 := JoinVertices(doubleSquare1,[3,6])[1];
     doubleSquare3 := JoinEdges(doubleSquare2, 3,6)[1];    

     isomorph := PolygonalComplexByDownwardIncidence(
 	[[1,2],[2,4],[3,4],[3,1],[1,4],[2,3]],
 	[[1,2,3,4],[1,3,5,6]]);    

    Assert(0,IsIsomorphic(isomorph,doubleSquare3)=true);

 end);


BindGlobal( "__SIMPLICIAL_Test_JoinVertexEdgePaths", function()
    local triangle,path1,join1,tripleJoin,butterfly,path2,path3,join2,path4,path5,join3;

	triangle := SimplicialSurfaceByDownwardIncidence( [[1,2],[1,3],[2,3]],[[1,2,3]] );
	path1 := VertexEdgePathByVertices(triangle, [1,2]);
	join1 := JoinVertexEdgePaths(triangle, path1, triangle, path1);
	SIMPLICIAL_TestAssert(join1[2] = VertexEdgePathByVertices(join1[1], [7,8]));
	SIMPLICIAL_TestAssert(join1 = JoinVertexEdgePathsNC(triangle, path1, triangle, path1));
	
	tripleJoin := JoinVertexEdgePaths(join1[1],join1[2],triangle,path1);
	SIMPLICIAL_TestAssert(tripleJoin[2] = VertexEdgePathByVertices(tripleJoin[1], [12,13]));
	SIMPLICIAL_TestAssert(tripleJoin = JoinVertexEdgePathsNC(join1[1],join1[2],triangle,path1));
	
	
	butterfly:=SimplicialSurfaceByDownwardIncidence([[1,3],[1,4],[3,4],[2,3],[2,4]],[[1,2,3],[3,4,5]]);
	path2:=VertexEdgePathByVertices(butterfly,[3,1,4]);
	path3:=VertexEdgePathByVertices(butterfly,[3,2,4]);
	join2:=JoinVertexEdgePaths(butterfly,path2,path3);
	SIMPLICIAL_TestAssert(IsIsomorphic(join2[1],JanusHead()));
	SIMPLICIAL_TestAssert(join2[2] = VertexEdgePathByVertices(join2[1], [3,6,4]));

	path4:=VertexEdgePathByVertices(butterfly,[1,3,2]);
	path5:=VertexEdgePathByVertices(butterfly,[1,4,2]);
	join3:=JoinVertexEdgePaths(butterfly,path4,path5);
	SIMPLICIAL_TestAssert(join3 = fail);
end);

BindGlobal( "__SIMPLICIAL_Test_SplitVertexEdgePath", function()
    local hex,cutPath1,hexCut,triangle,butterfly,cutPath2,split;

	hex := SimplicialSurfaceByDownwardIncidence([ [1,7],[2,7],[3,7],[4,7],[5,7],[6,7],[1,2],[2,3],[3,4],[4,5],[5,6],[1,6] ],
			[ [1,2,7],[2,3,8],[3,4,9],[4,5,10],[5,6,11],[1,6,12] ]);
	cutPath1 := VertexEdgePath(hex, [4,4,7,1,1]);
	hexCut := SplitVertexEdgePath( hex, cutPath1 );
	SIMPLICIAL_TestAssert(NumberOfConnectedComponents(hexCut[1])=2);
	SIMPLICIAL_TestAssert(hexCut = SplitVertexEdgePathNC( hex, cutPath1 ));
	
	triangle := SimplicialSurfaceByDownwardIncidence( [[1,2],[1,3],[2,3]],[[1,2,3]] );
	butterfly:=SimplicialSurfaceByDownwardIncidence([[1,3],[1,4],[3,4],[2,3],[2,4]],[[1,2,3],[3,4,5]]);
	cutPath2:=VertexEdgePathByVertices(butterfly,[3,4]);
	split:=SplitVertexEdgePath(butterfly,cutPath2);
	SIMPLICIAL_TestAssert(IsIsomorphic(split[1],DisjointUnion(triangle,triangle)[1]));
	SIMPLICIAL_TestAssert(split[2] = [[VertexEdgePathByVertices(split[1], [5,7]),cutPath2],
	[VertexEdgePathByVertices(split[1], [6,8]),cutPath2]]);
end);

BindGlobal( "__SIMPLICIAL_Test_SplitEdgePath", function()
    local hex,cutPath1,hexOpen,butterfly,cutPath2,split;

	hex := SimplicialSurfaceByDownwardIncidence([ [1,7],[2,7],[3,7],[4,7],[5,7],[6,7],[1,2],[2,3],[3,4],[4,5],[5,6],[1,6] ],
			[ [1,2,7],[2,3,8],[3,4,9],[4,5,10],[5,6,11],[1,6,12] ]);
	cutPath1 := VertexEdgePath(hex, [4,4,7,1,1]);
	hexOpen := SplitEdgePath( hex, cutPath1 );;
	SIMPLICIAL_TestAssert(NumberOfConnectedComponents(hexOpen[1])=1);
	SIMPLICIAL_TestAssert(hexOpen = SplitEdgePathNC( hex, cutPath1 ));
	
	butterfly:=SimplicialSurfaceByDownwardIncidence([[1,3],[1,4],[3,4],[2,3],[2,4]],[[1,2,3],[3,4,5]]);
	cutPath2:=VertexEdgePathByVertices(butterfly,[3,4]);
	split:=SplitEdgePath(butterfly,cutPath2);
	SIMPLICIAL_TestAssert(NumberOfConnectedComponents(split[1])=1);
	SIMPLICIAL_TestAssert(split = SplitEdgePathNC( butterfly, cutPath2 ));
end);

BindGlobal( "__SIMPLICIAL_Test_Smaller", function()
    local butterfly, geodesic, s, triangle1, triangle2, triangle3;

	#different number of faces
	SIMPLICIAL_TestAssert((JanusHead()<Tetrahedron())=true);
	
	#same number of faces, different number of vertices
	butterfly:=SimplicialSurfaceByDownwardIncidence([[1,3],[1,4],[3,4],[2,3],[2,4]],[[1,2,3],[3,4,5]]);
	SIMPLICIAL_TestAssert((JanusHead()<butterfly)=true);
	
	#same number of faces and same number of vertices but different vertex counters
	geodesic:=SimplicialSurfaceByDownwardIncidence([[1,2],[2,4],[1,4],[1,3],[3,4],[2,3],[2,4],[1,3]],[[1,2,3],[3,4,5],[5,6,7],[1,6,8]]);
	s:=SimplicialSurfaceByDownwardIncidence([[1,2],[1,3],[2,3],[1,3],[3,4],[1,4],[1,3]],[[1,2,3],[3,4,1],[4,5,6],[5,6,7]]);
	SIMPLICIAL_TestAssert((s<geodesic)=true);

	#same isomorphism class

	#different EdgesOfFaces
	triangle1 := SimplicialSurfaceByDownwardIncidence( [[1,2],[1,3],[2,3]],[[1,2,3]] );
	triangle2 := SimplicialSurfaceByDownwardIncidence( [[1,2],[1,3],,[2,3]],[[1,2,4]] );
	SIMPLICIAL_TestAssert((triangle1<triangle2)=true);

	#different VerticesOfEdges
	triangle3 := SimplicialSurfaceByDownwardIncidence( [[1,2],[1,4],[2,4]],[[1,2,3]] );
	SIMPLICIAL_TestAssert((triangle1<triangle3)=true);
	
end);

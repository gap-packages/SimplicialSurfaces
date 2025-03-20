BindGlobal( "__SIMPLICIAL_Test_VEF_SpecialisedIncidence",
    function()
        local torus, torus_ve, torus_vf, torus_ef, ball, ball_ve, ball_vf, 
            ball_ef, torus_umb, ball_umb;

        torus_ve := [[2],[2],,[2]];
        torus_vf := [[2],,[2]];
        torus_ef := [[1,2,4],,[1,2,4]];
        torus := TwistedPolygonalComplexByChamberRelations(
            [2,2,2,2,2,2,,,2,2,2,2,2,2],
            [4,1,1,2,2,4,,,1,2,2,4,4,1],
            [1,1,1,1,1,1,,,3,3,3,3,3,3],
            (1,6)(2,3)(4,5)(9,14)(10,11)(12,13),
            [[1,2],[3,4],[5,6],[9,10],[11,12],[13,14]],
            (1,12)(2,9)(3,14)(4,11)(5,10)(6,13) );
        SIMPLICIAL_TestAssert(VerticesOfEdges(torus)=torus_ve);
        SIMPLICIAL_TestAssert(EdgesOfFaces(torus)=torus_ef);
        SIMPLICIAL_TestAssert(VerticesOfFaces(torus)=torus_vf);

        ball_ve := [,[1,2],[2],[2,4]];
        ball_vf := [[1,2],,[2,4]];
        ball_ef := [[2,3],,[3,4]];
        ball := TwistedPolygonalComplexByChamberRelations(
            [1,1,2,2,2,2,,,2,2,2,2,4,4],
            [2,2,2,2,3,3,,,3,3,4,4,4,4],
            [1,1,1,1,1,1,,,3,3,3,3,3,3],
            [[1,3],[2,4],[5,6],[9,10],[13,11],[14,12]],
            (1,2)(3,5)(4,6)(9,11)(12,10)(14,13),
            [[1,2],[3,4],[5,9],[10,6],[12,11],[13,14]] );
        SIMPLICIAL_TestAssert(VerticesOfEdges(ball)=ball_ve);
        SIMPLICIAL_TestAssert(EdgesOfFaces(ball)=ball_ef);
        SIMPLICIAL_TestAssert(VerticesOfFaces(ball)=ball_vf);

        # EdgeInFaceByVertices
        SIMPLICIAL_TestAssert(EdgeInFaceByVertices(torus,1,[2])=fail);
        SIMPLICIAL_TestAssert(EdgesInFaceByVertices(torus,1,[2])=[1,2,4]);
        SIMPLICIAL_TestAssert(EdgesInFaceByVertices(torus,1,[2,2])=[1,2,4]);

        SIMPLICIAL_TestAssert(EdgeInFaceByVertices(ball, 1, [1,2])=2);
        SIMPLICIAL_TestAssert(EdgeInFaceByVertices(ball, 1, [2,2])=3);
        SIMPLICIAL_TestAssert(EdgesInFaceByVertices(ball, 1, [2])=[3]);

        # OtherEdgeOfVertexInFace
        SIMPLICIAL_TestAssert(OtherEdgeOfVertexInFace(torus, 2, 1,1) = fail);
        SIMPLICIAL_TestAssert(OtherEdgesOfVertexInFace(torus, 2, 1,1) = [2,4]);

        SIMPLICIAL_TestAssert(OtherEdgeOfVertexInFace(ball, 1,2,1)=fail);
        SIMPLICIAL_TestAssert(OtherEdgeOfVertexInFace(ball, 2,2,1)=3);
        SIMPLICIAL_TestAssert(OtherEdgesOfVertexInFace(ball, 1,2,1)=[]);

        # OtherVertexOfEdge
        SIMPLICIAL_TestAssert(OtherVertexOfEdge(torus, 2,4) = 2);
        SIMPLICIAL_TestAssert(OtherVertexOfEdge(ball, 2,3) = 2);
        SIMPLICIAL_TestAssert(OtherVertexOfEdge(ball, 4,4) = 2);

        # NeighbourFaceByEdge
        SIMPLICIAL_TestAssert(NeighbourFaceByEdge(torus,1,2)=3);
        SIMPLICIAL_TestAssert(NeighbourFacesByEdge(torus,1,2)=[3]);
        SIMPLICIAL_TestAssert(NeighbourFaceByEdge(ball,1,2)=1);

        # Orientation
        SIMPLICIAL_TestAssert(IsOrientable(torus));
        SIMPLICIAL_TestAssert(IsOrientable(ball));

        # Euler-characteristic
        SIMPLICIAL_TestAssert(EulerCharacteristic(torus)=0);
        SIMPLICIAL_TestAssert(EulerCharacteristic(ball)=2);

        # IsClosedSurface
        SIMPLICIAL_TestAssert(IsClosedComplex(torus));
        SIMPLICIAL_TestAssert(IsClosedComplex(ball));

        # EdgeDegrees
        SIMPLICIAL_TestAssert(EdgeDegreeOfVertex(torus,2)=3);
        SIMPLICIAL_TestAssert(EdgeDegreesOfVertices(ball)=[1,3,,1]);

        # FaceDegrees
        SIMPLICIAL_TestAssert(FaceDegreeOfVertex(torus,2) = 2);
        SIMPLICIAL_TestAssert(FaceDegreesOfVertices(ball)=[1,2,,1]);

        # VertexCounter
        SIMPLICIAL_TestAssert(ListCounter(CounterOfVertices(torus))=[ [2,1] ]);
        SIMPLICIAL_TestAssert(ListCounter(CounterOfVertices(ball))=[ [1,2], [2,1] ]);

        # IsFaceHomogeneous
        SIMPLICIAL_TestAssert(IsFaceHomogeneous(torus));
        SIMPLICIAL_TestAssert(IsTriangular(torus));
        SIMPLICIAL_TestAssert(not IsQuadrangular(torus));
        SIMPLICIAL_TestAssert(IsFaceHomogeneous(ball));
        SIMPLICIAL_TestAssert(IsTriangular(ball));
        SIMPLICIAL_TestAssert(not IsQuadrangular(ball));
    end
);

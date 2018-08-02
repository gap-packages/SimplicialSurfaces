BindGlobal( "__SIMPLICIAL_Test_VEF_SpecialisedIncidence",
    function()
        local torus, torus_ve, torus_vf, torus_ef, ball, ball_ve, ball_vf, 
            ball_ef;

        torus_ve := [[2],[2],,[2]];
        torus_vf := [[2],,[2]];
        torus_ef := [[1,2,4],,[1,2,4]];
        torus := BendPolygonalComplexBySignedFacePerimeters(
            [[2,1,2,4,2,2],,[2,-2,2,-1,2,-4]]);
        Assert(0, VerticesOfEdges(torus)=torus_ve);
        Assert(0, EdgesOfFaces(torus)=torus_ef);
        Assert(0, VerticesOfFaces(torus)=torus_vf);

        ball_ve := [,[1,2],[2],[2,4]];
        ball_vf := [[1,2],,[2,4]];
        ball_ef := [[2,3],,[3,4]];
        ball := BendPolygonalComplexBySignedFacePerimeters(
            [[2,3,2,2,1,-2],,[2,3,2,4,4,-4]] );
        Assert(0, VerticesOfEdges(ball)=ball_ve);
        Assert(0, EdgesOfFaces(ball)=ball_ef);
        Assert(0, VerticesOfFaces(ball)=ball_vf);

        # EdgeInFaceByVertices
        Assert(0, EdgeInFaceByVertices(torus,1,[2])=fail);
        Assert(0, EdgesInFaceByVertices(torus,1,[2])=[1,2,4]);
        Assert(0, EdgesInFaceByVertices(torus,1,[2,2])=[1,2,4]);

        Assert(0, EdgeInFaceByVertices(ball, 1, [1,2])=2);
        Assert(0, EdgeInFaceByVertices(ball, 1, [2,2])=3);
        Assert(0, EdgesInFaceByVertices(ball, 1, [2])=[3]);

        # OtherEdgeOfVertexInFace
        Assert(0, OtherEdgeOfVertexInFace(torus, 2, 1,1) = fail);
        Assert(0, OtherEdgesOfVertexInFace(torus, 2, 1,1) = [2,4]);

        Assert(0, OtherEdgeOfVertexInFace(ball, 1,2,1)=fail);
        Assert(0, OtherEdgeOfVertexInFace(ball, 2,2,1)=3);
        Assert(0, OtherEdgesOfVertexInFace(ball, 1,2,1)=[]);

        # OtherVertexOfEdge
        Assert(0, OtherVertexOfEdge(torus, 2,4) = 2);
        Assert(0, OtherVertexOfEdge(ball, 2,3) = 2);
        Assert(0, OtherVertexOfEdge(ball, 4,4) = 2);

        # NeighbourFaceByEdge
        Assert(0, NeighbourFaceByEdge(torus,1,2)=3);
        Assert(0, NeighbourFacesByEdge(torus,1,2)=[3]);
        Assert(0, NeighbourFaceByEdge(ball,1,2)=1);

        # PerimetersOfFaces
        Assert(0, PerimeterOfFace(torus,1)=VertexEdgePath(torus,[2,1,2,2,2,4,2]));
        Assert(0, PerimeterOfFace(torus,3)=VertexEdgePath(torus,[2,1,2,2,2,4,2]));
        Assert(0, PerimetersOfFaces(ball)[1]=VertexEdgePath(ball,[1,2,2,3,2,2,1]));
        Assert(0, PerimetersOfFaces(ball)[3]=VertexEdgePath(ball,[2,3,2,4,4,4,2]));

    end
);

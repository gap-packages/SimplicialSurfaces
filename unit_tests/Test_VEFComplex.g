BindGlobal( "__SIMPLICIAL_Test_VEF_SpecialisedIncidence",
    function()
        local torus, torus_ve, torus_vf, torus_ef, ball, ball_ve, ball_vf, 
            ball_ef;

        torus_ve := [[2],[2],,[2]];
        torus_vf := [[2],,[2]];
        torus_ef := [[1,2,4],,[1,2,4]];
        torus := Objectify(BendPolygonalComplexType, rec());
        SetVerticesOfEdges(torus, torus_ve);
        SetEdgesOfFaces(torus, torus_ef);
        Assert(0, VerticesOfFaces(torus)=torus_vf);

        ball_ve := [,[1,2],[2],[2,4]];
        ball_vf := [[1,2],,[2,4]];
        ball_ef := [[2,3],,[3,4]];
        ball := Objectify(BendPolygonalComplexType, rec());
        SetVerticesOfEdges(ball, ball_ve);
        SetEdgesOfFaces(ball, ball_ef);
        Assert(0, VerticesOfFaces(ball)=ball_vf);


        Assert(0, EdgeInFaceByVertices(torus,1,[2])=fail);
        Assert(0, EdgesInFaceByVertices(torus,1,[2])=[1,2,4]);
        Assert(0, EdgesInFaceByVertices(torus,1,[2,2])=[1,2,4]);

        Assert(0, EdgeInFaceByVertices(ball, 1, [1,2])=2);
        Assert(0, EdgeInFaceByVertices(ball, 1, [2,2])=3);
        Assert(0, EdgesInFaceByVertices(ball, 1, [2])=[3]);


        Assert(0, OtherEdgeOfVertexInFace(torus, 2, 1,1) = fail);
        Assert(0, OtherEdgesOfVertexInFace(torus, 2, 1,1) = [2,4]);

        Assert(0, OtherEdgeOfVertexInFace(ball, 1,2,1)=fail);
        Assert(0, OtherEdgeOfVertexInFace(ball, 2,2,1)=3);
        Assert(0, OtherEdgesOfVertexInFace(ball, 1,2,1)=[]);


        Assert(0, OtherVertexOfEdge(torus, 2,4) = 2);
        Assert(0, OtherVertexOfEdge(ball, 2,3) = 2);
        Assert(0, OtherVertexOfEdge(ball, 4,4) = 2);
    end
);

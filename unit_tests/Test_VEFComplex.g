BindGlobal( "__SIMPLICIAL_Test_VEF_SpecialisedIncidence",
    function()
        local torus, torus_ve, torus_vf, torus_ef, ball, ball_ve, ball_vf, 
            ball_ef, torus_umb, ball_umb;

        torus_ve := [[2],[2],,[2]];
        torus_vf := [[2],,[2]];
        torus_ef := [[1,2,4],,[1,2,4]];
        torus := BendPolygonalComplexBySignedFacePerimeters(
            [[2,1,2,4,2,2],,[2,-2,2,-1,2,-4]]);
        __SIMPLICIAL_BendPolygonalComplex_SufficientInformation(torus);
        Assert(0, VerticesOfEdges(torus)=torus_ve);
        Assert(0, EdgesOfFaces(torus)=torus_ef);
        Assert(0, VerticesOfFaces(torus)=torus_vf);

        ball_ve := [,[1,2],[2],[2,4]];
        ball_vf := [[1,2],,[2,4]];
        ball_ef := [[2,3],,[3,4]];
        ball := BendPolygonalComplexBySignedFacePerimeters(
            [[2,3,2,2,1,-2],,[2,3,2,4,4,-4]] );
        __SIMPLICIAL_BendPolygonalComplex_SufficientInformation(ball);
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

        # PerimetersOfFaces (defined by local vertices/edges)
        Assert(0, PathAsList(PerimeterPathOfFace(torus,1))=[2,1,2,2,2,4,2]);
        Assert(0, PathAsList(PerimeterPathOfFace(torus,3))=[2,2,2,4,2,1,2]);
        Assert(0, PathAsList(PerimeterPathsOfFaces(ball)[1])=[1,2,2,3,2,2,1]);
        Assert(0, PathAsList(PerimeterPathsOfFaces(ball)[3])=[2,3,2,4,4,4,2]);

        # UmbrellaPathsOfVertices
        torus_umb := UmbrellaPathsOfVertices(torus);
        ball_umb := UmbrellaPathsOfVertices(ball);
        Assert(0, torus_umb[2] <> fail);
        Assert(0, IsUmbrellaPath(torus_umb[2]));
        Assert(0, Length(PathAsList(torus_umb[2]))=13);
        Assert(0, fail <> ball_umb[2]);
        Assert(0, ForAll(ball_umb, IsUmbrellaPath));
        Assert(0, Length(PathAsList(ball_umb[2]))=9);

        # MaximalGeodesicPaths
        Assert(0, Length(MaximalGeodesicPaths(torus))=3);
        Assert(0, Length(MaximalGeodesicPaths(ball))=1);

        # Orientation
        Assert(0, IsOrientable(torus));
        Assert(0, IsOrientable(ball));

        # Euler-characteristic
        Assert(0, EulerCharacteristic(torus)=0);
        Assert(0, EulerCharacteristic(ball)=2);

        # IsClosedSurface
        Assert(0, IsClosedSurface(torus));
        Assert(0, IsClosedSurface(ball));

        # EdgeDegrees
        Assert(0, EdgeDegreeOfVertex(torus,2)=3);
        Assert(0, EdgeDegreesOfVertices(ball)=[1,3,,1]);

        # FaceDegrees
        Assert(0, FaceDegreeOfVertex(torus,2) = 2);
        Assert(0, FaceDegreesOfVertices(ball)=[1,2,,1]);

        # VertexCounter
        Assert(0, VertexCounter(torus)=[ [2,1] ]);
        Assert(0, VertexCounter(ball)=[ [1,2], [2,1] ]);

        # IsFaceHomogeneous
        Assert(0, IsFaceHomogeneous(torus));
        Assert(0, IsTriangular(torus));
        Assert(0, not IsQuadrangular(torus));
        Assert(0, IsFaceHomogeneous(ball));
        Assert(0, IsTriangular(ball));
        Assert(0, not IsQuadrangular(ball));
    end
);

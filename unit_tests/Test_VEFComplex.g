BindGlobal( "__SIMPLICIAL_Test_VEF_SpecialisedIncidence",
    function()
        local torus, torus_ve, torus_vf, torus_ef;

        torus_ve := [[2],[2],,[2]];
        torus_vf := [[2],,[2]];
        torus_ef := [[1,2,4],,[1,2,4]];
        torus := Objectify(BendPolygonalComplexType, rec());
        SetVerticesOfEdges(torus, torus_ve);
        SetEdgesOfFaces(torus, torus_ef);
        Assert(0, VerticesOfFaces(torus)=torus_vf);

        Assert(0, EdgeInFaceByVertices(torus,1,[2])=fail);
        Assert(0, EdgesInFaceByVertices(torus,1,[2])=[1,2,4]);
        Assert(0, EdgesInFaceByVertices(torus,1,[2,2])=[1,2,4]);
    end
);

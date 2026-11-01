
# Compute the edges of the 2-waists of a complex from the definition:
# all pairs of inner edges with the same vertices that are not incident
# to a common face.
BindGlobal( "__SIMPLICIAL_EdgesOfTwoWaistsByDefinition", function(complex)
    local edges, waists, i, j;

    edges:=Edges(complex);
    waists:=[];
    for i in [1..Length(edges)] do
        for j in [i+1..Length(edges)] do
            if VerticesOfEdge(complex,edges[i])=VerticesOfEdge(complex,edges[j]) and
                    IsInnerEdge(complex,edges[i]) and IsInnerEdge(complex,edges[j]) and
                    Intersection(FacesOfEdge(complex,edges[i]),FacesOfEdge(complex,edges[j]))=[] then
                Add(waists,edges{[i,j]});
            fi;
        od;
    od;
    return waists;
end);

# Check that AllTwoWaistsOfComplex agrees with the definition and,
# for polygonal complexes, with IsWaist.
BindGlobal( "__SIMPLICIAL_Test_TwoWaistsOfComplex", function(complex)
    local waists, edges, i, j, path;

    waists:=AllTwoWaistsOfComplex(complex);
    SIMPLICIAL_TestAssert(List(waists,EdgesAsList)=
        __SIMPLICIAL_EdgesOfTwoWaistsByDefinition(complex));
    if not IsPolygonalComplex(complex) then
        # Vertex-edge-paths are only defined for polygonal complexes
        return;
    fi;
    SIMPLICIAL_TestAssert(ForAll(waists, w->IsWaist(complex,w)));

    # Every closed vertex-edge-path of length two that is a waist is found
    edges:=Edges(complex);
    for i in [1..Length(edges)] do
        for j in [i+1..Length(edges)] do
            if VerticesOfEdge(complex,edges[i])=VerticesOfEdge(complex,edges[j]) then
                path:=VertexEdgePathByEdges(complex,edges{[i,j]});
                SIMPLICIAL_TestAssert(IsWaist(complex,path)=(path in waists));
            fi;
        od;
    od;
end);

BindGlobal( "__SIMPLICIAL_Test_AllTwoWaistsOfComplex", function()
    local voe, eof, doubleJanus, openJanus, twoTriangles, triple,
        twisted, complexes, surf, waists;

    # Examples from the manual
    voe:=[[3,4],[1,3],[1,4],[2,3],[2,4],[3,4]];
    eof:=[[1,2,3],[1,4,5],[4,5,6],[2,3,6]];
    doubleJanus:=SimplicialSurfaceByDownwardIncidence(voe,eof);
    waists:=AllTwoWaistsOfComplex(doubleJanus);
    SIMPLICIAL_TestAssert(List(waists,PathAsList)=[[3,1,4,6,3]]);

    # Edge 6 is a boundary edge
    openJanus:=SimplicialSurfaceByDownwardIncidence(voe,eof{[1..3]});
    SIMPLICIAL_TestAssert(AllTwoWaistsOfComplex(openJanus)=[]);

    # Two boundary edges between the same vertices
    twoTriangles:=PolygonalComplexByDownwardIncidence(
        [[1,2],[2,3],[1,3],[1,2],[2,4],[1,4]], [[1,2,3],[4,5,6]]);
    SIMPLICIAL_TestAssert(AllTwoWaistsOfComplex(twoTriangles)=[]);

    # Three inner edges 1, 2, 3 between the vertices 1 and 2, each lying in
    # two triangles with the vertices 3 and 4
    triple:=PolygonalComplexByDownwardIncidence(
        [[1,2],[1,2],[1,2],[1,3],[2,3],[1,4],[2,4]],
        [[1,4,5],[1,6,7],[2,4,5],[2,6,7],[3,4,5],[3,6,7]]);
    waists:=AllTwoWaistsOfComplex(triple);
    SIMPLICIAL_TestAssert(List(waists,EdgesAsList)=[[1,2],[1,3],[2,3]]);

    # A twisted polygonal surface
    twisted:=TwistedPolygonalSurfaceByChamberInvolutions(
        (1,2)(3,4)(5,6)(7,8)(9,10)(11,12)(13,14)(15,16)(17,18),
        (1,6)(2,3)(4,5)(7,12)(8,9)(10,11)(13,18)(14,15)(16,17),
        (3,8)(4,7)(5,18)(6,17)(9,14)(10,13));

    complexes:=[ JanusHead(), doubleJanus, openJanus, twoTriangles,
        triple, twisted, Tetrahedron(), Octahedron(),
        Icosahedron(), Cube(), Dodecahedron() ];
    Append(complexes, AllSimplicialSurfaces(NumberOfFaces,[2..12]));
    for surf in complexes do
        __SIMPLICIAL_Test_TwoWaistsOfComplex(surf);
    od;
end);

if IsPackageMarkedForLoading( "Digraphs", ">=1.9.0" ) and IsPackageMarkedForLoading("NautyTracesInterface", ">=0") then
    # AllClosedVertexEdgePaths has to return all closed paths of length 2,
    # not only the 2-waists.
    BindGlobal( "__SIMPLICIAL_Test_ClosedVertexEdgePathsOfLengthTwo", function()
        local voe, openJanus, paths;

        voe:=[[3,4],[1,3],[1,4],[2,3],[2,4],[3,4]];
        openJanus:=SimplicialSurfaceByDownwardIncidence(voe,[[1,2,3],[1,4,5],[4,5,6]]);
        paths:=Filtered(AllClosedVertexEdgePaths(openJanus), p->Length(EdgesAsList(p))=2);
        SIMPLICIAL_TestAssert(List(paths,EdgesAsList)=[[1,6]]);
        SIMPLICIAL_TestAssert(AllTwoWaistsOfComplex(openJanus)=[]);
    end);
else
    BindGlobal( "__SIMPLICIAL_Test_ClosedVertexEdgePathsOfLengthTwo", function() end);
fi;

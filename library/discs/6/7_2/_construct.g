ConstructSevenTwoA := function( verticesOfEdges, edgesOfFaces )
    local maxVert, maxEdge, maxFace, i;

    maxEdge := Length(verticesOfEdges);
    maxFace := Length(edgesOfFaces);
    maxVert := maxEdge - maxFace + 1; # From Euler-characteristic = 1

    for i in [1..7] do
        # Spokes of the ring
        verticesOfEdges[maxEdge+6+2*i] := [maxVert+i, maxVert+i+7];
    od;
    for i in [1..6] do
        # "Horizontal" edges in the ring
        verticesOfEdges[maxEdge+i] := [maxVert+i,maxVert+i+1];
        verticesOfEdges[maxEdge+21+i] := [maxVert+i+7,maxVert+i+8];
    od;
    verticesOfEdges[maxEdge+7] := [maxVert+1,maxVert+7];
    verticesOfEdges[maxEdge+28] := [maxVert+8,maxVert+14];
    # Diagonal "up"-edges
    for i in [1,2] do
        verticesOfEdges[maxEdge+7+2*i] := [maxVert+i,maxVert+i+8];
        edgesOfFaces[maxFace+2*i-1] := [maxEdge+2*i+6,maxEdge+2*i+7,maxEdge+i+21];
        edgesOfFaces[maxFace+2*i] := [maxEdge+i,maxEdge+2*i+7,maxEdge+2*i+8];
    od;
    # Diagonal "down"-edges
    for i in [3,4,5,6] do
        verticesOfEdges[maxEdge+7+2*i] := [maxVert+i+1,maxVert+i+7];
        edgesOfFaces[maxFace+2*i-1] := [maxEdge+2*i+6,maxEdge+2*i+7,maxEdge+i];
        edgesOfFaces[maxFace+2*i] := [maxEdge+i+21,maxEdge+2*i+7,maxEdge+2*i+8];
    od;
    verticesOfEdges[maxEdge+21] := [maxVert+1,maxVert+14];

    edgesOfFaces[maxFace+13] := [maxEdge+7,maxEdge+20,maxEdge+21];
    edgesOfFaces[maxFace+14] := [maxEdge+8,maxEdge+21,maxEdge+28];

    return SimplicialSurfaceByDownwardIncidence(verticesOfEdges, edgesOfFaces);
end;

ConstructSevenTwoB := function( verticesOfEdges, edgesOfFaces )
    local maxVert, maxEdge, maxFace, i;

    maxEdge := Length(verticesOfEdges);
    maxFace := Length(edgesOfFaces);
    maxVert := maxEdge - maxFace + 1; # From Euler-characteristic = 1

    for i in [1..7] do
        # Spokes of the ring
        verticesOfEdges[maxEdge+6+2*i] := [maxVert+i, maxVert+i+7];
    od;
    for i in [1..6] do
        # "Horizontal" edges in the ring
        verticesOfEdges[maxEdge+i] := [maxVert+i,maxVert+i+1];
        verticesOfEdges[maxEdge+21+i] := [maxVert+i+7,maxVert+i+8];
    od;
    verticesOfEdges[maxEdge+7] := [maxVert+1,maxVert+7];
    verticesOfEdges[maxEdge+28] := [maxVert+8,maxVert+14];
    # Diagonal "up"-edges
    for i in [1,3] do
        verticesOfEdges[maxEdge+7+2*i] := [maxVert+i,maxVert+i+8];
        edgesOfFaces[maxFace+2*i-1] := [maxEdge+2*i+6,maxEdge+2*i+7,maxEdge+i+21];
        edgesOfFaces[maxFace+2*i] := [maxEdge+i,maxEdge+2*i+7,maxEdge+2*i+8];
    od;
    # Diagonal "down"-edges
    for i in [2,4,5,6] do
        verticesOfEdges[maxEdge+7+2*i] := [maxVert+i+1,maxVert+i+7];
        edgesOfFaces[maxFace+2*i-1] := [maxEdge+2*i+6,maxEdge+2*i+7,maxEdge+i];
        edgesOfFaces[maxFace+2*i] := [maxEdge+i+21,maxEdge+2*i+7,maxEdge+2*i+8];
    od;
    verticesOfEdges[maxEdge+21] := [maxVert+1,maxVert+14];

    edgesOfFaces[maxFace+13] := [maxEdge+7,maxEdge+20,maxEdge+21];
    edgesOfFaces[maxFace+14] := [maxEdge+8,maxEdge+21,maxEdge+28];

    return SimplicialSurfaceByDownwardIncidence(verticesOfEdges, edgesOfFaces);
end;

ConstructSevenTwoC := function( verticesOfEdges, edgesOfFaces )
    local maxVert, maxEdge, maxFace, i;

    maxEdge := Length(verticesOfEdges);
    maxFace := Length(edgesOfFaces);
    maxVert := maxEdge - maxFace + 1; # From Euler-characteristic = 1

    for i in [1..7] do
        # Spokes of the ring
        verticesOfEdges[maxEdge+6+2*i] := [maxVert+i, maxVert+i+7];
    od;
    for i in [1..6] do
        # "Horizontal" edges in the ring
        verticesOfEdges[maxEdge+i] := [maxVert+i,maxVert+i+1];
        verticesOfEdges[maxEdge+21+i] := [maxVert+i+7,maxVert+i+8];
    od;
    verticesOfEdges[maxEdge+7] := [maxVert+1,maxVert+7];
    verticesOfEdges[maxEdge+28] := [maxVert+8,maxVert+14];
    # Diagonal "up"-edges
    for i in [1,4] do
        verticesOfEdges[maxEdge+7+2*i] := [maxVert+i,maxVert+i+8];
        edgesOfFaces[maxFace+2*i-1] := [maxEdge+2*i+6,maxEdge+2*i+7,maxEdge+i+21];
        edgesOfFaces[maxFace+2*i] := [maxEdge+i,maxEdge+2*i+7,maxEdge+2*i+8];
    od;
    # Diagonal "down"-edges
    for i in [2,3,5,6] do
        verticesOfEdges[maxEdge+7+2*i] := [maxVert+i+1,maxVert+i+7];
        edgesOfFaces[maxFace+2*i-1] := [maxEdge+2*i+6,maxEdge+2*i+7,maxEdge+i];
        edgesOfFaces[maxFace+2*i] := [maxEdge+i+21,maxEdge+2*i+7,maxEdge+2*i+8];
    od;
    verticesOfEdges[maxEdge+21] := [maxVert+1,maxVert+14];

    edgesOfFaces[maxFace+13] := [maxEdge+7,maxEdge+20,maxEdge+21];
    edgesOfFaces[maxFace+14] := [maxEdge+8,maxEdge+21,maxEdge+28];

    return SimplicialSurfaceByDownwardIncidence(verticesOfEdges, edgesOfFaces);
end;

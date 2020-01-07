ConstructFourTwo := function( verticesOfEdges, edgesOfFaces )
    local maxVert, maxEdge, maxFace, i;

    maxEdge := Length(verticesOfEdges);
    maxFace := Length(edgesOfFaces);
    maxVert := maxEdge - maxFace + 1; # From Euler-characteristic = 1

    for i in [1..4] do
        # Spokes of the ring
        verticesOfEdges[maxEdge+3+2*i] := [maxVert+i, maxVert+i+4];
    od;
    for i in [1..3] do
        # "Horizontal" edges in the ring
        verticesOfEdges[maxEdge+i] := [maxVert+i,maxVert+i+1];
        verticesOfEdges[maxEdge+12+i] := [maxVert+i+4,maxVert+i+5];
    od;
    verticesOfEdges[maxEdge+4] := [maxVert+1,maxVert+4];
    verticesOfEdges[maxEdge+16] := [maxVert+5,maxVert+8];
    # Diagonal "up"-edges
    for i in [2] do
        verticesOfEdges[maxEdge+4+2*i] := [maxVert+i,maxVert+i+5];
        edgesOfFaces[maxFace+2*i-1] := [maxEdge+2*i+3,maxEdge+2*i+4,maxEdge+i+12];
        edgesOfFaces[maxFace+2*i] := [maxEdge+i,maxEdge+2*i+4,maxEdge+2*i+5];
    od;
    # Diagonal "down"-edges
    for i in [1,3] do
        verticesOfEdges[maxEdge+4+2*i] := [maxVert+i+1,maxVert+i+4];
        edgesOfFaces[maxFace+2*i-1] := [maxEdge+2*i+3,maxEdge+2*i+4,maxEdge+i];
        edgesOfFaces[maxFace+2*i] := [maxEdge+i+12,maxEdge+2*i+4,maxEdge+2*i+5];
    od;
    # Final edge is an "up"-edge
    verticesOfEdges[maxEdge+12] := [maxVert+4,maxVert+5];
    edgesOfFaces[maxFace+7] := [maxEdge+16,maxEdge+11,maxEdge+12];
    edgesOfFaces[maxFace+8] := [maxEdge+5,maxEdge+12,maxEdge+4];

    return SimplicialSurfaceByDownwardIncidence(verticesOfEdges, edgesOfFaces);
end;


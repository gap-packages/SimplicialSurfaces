ConstructSixZero := function( verticesOfEdges, edgesOfFaces )
    local maxVert, maxEdge, maxFace, i;

    maxEdge := Length(verticesOfEdges);
    maxFace := Length(edgesOfFaces);
    maxVert := maxEdge - maxFace + 1; # From Euler-characteristic = 1

    for i in [1..5] do
        verticesOfEdges[maxEdge+i] := [maxVert+i, maxVert+i+1];
        verticesOfEdges[maxEdge+6+2*i] := [maxVert+i+1, maxVert+i+6];
        verticesOfEdges[maxEdge+18+i] := [maxVert+i+6, maxVert+i+7];
    od;
    verticesOfEdges[maxEdge+6] := [maxVert+1,maxVert+6];
    verticesOfEdges[maxEdge+18] := [maxVert+1, maxVert+12];
    verticesOfEdges[maxEdge+24] := [maxVert+7, maxVert+12];
    for i in [1..6] do;
        verticesOfEdges[maxEdge+5+2*i] := [maxVert+i, maxVert+i+6];
    od;


    for i in [1..5] do
        edgesOfFaces[maxFace+2*i-1] := [maxEdge+i, maxEdge+5+2*i, maxEdge+6+2*i];
        edgesOfFaces[maxFace+2*i] := [maxEdge+6+2*i, maxEdge+7+2*i, maxEdge+18+i];
    od;
    edgesOfFaces[maxFace+11] := [maxEdge+6, maxEdge+17, maxEdge+18];
    edgesOfFaces[maxFace+12] := [maxEdge+7, maxEdge+18, maxEdge+24];

    return SimplicialSurfaceByDownwardIncidence(verticesOfEdges, edgesOfFaces);
end;

gap> s:=PolygonalComplexByDownwardIncidence([[1,2],[1,3],[2,3],[1,2],[2,4],[1,4],[1,2],[2,5],[1,5]],[[1,2,3],[4,5,6],[7,8,9]]);
triangular complex (5 vertices, 9 edges, and 3 faces)
gap> JoinEdges(s,[1,4,7]);
[ triangular complex (5 vertices, 7 edges, and 3 faces), 10 ]
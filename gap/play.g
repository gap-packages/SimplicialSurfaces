LoadPackage("grape");
Read("simplicial_surface.gd");
Read("simplicial_surface.gi");

Read("wild_simplicial_surface.gd");
Read("wild_simplicial_surface.gi");

Read("simplicial_surface_equivalence.gd");
Read("simplicial_surface_equivalence.gi");

Read("simplicial_surface_identification.gd");
Read("simplicial_surface_identification.gi");

edgesByVertices := [ [1,2],[1,3],[2,3],[3,4],[2,4],[2,5],[4,5] ];
facesByEdges := [ [1,3,2], [3,5,4], [5,6,7] ];
surf := SimplicialSurfaceByDownwardIncidence( 5,7,3,edgesByVertices,facesByEdges);

LoadPackage("NautyTracesInterface");
#LoadPackage("Orb");
#LoadPackage("Digraphs");


g := NautyColoredGraphWithNodeLabels(
 [ [ 1, 5 ], [ 2, 5 ], [ 1, 6 ], [ 3, 6 ], [ 1, 7 ], [ 4, 7 ], [ 2, 8 ], [ 3, 8 ], [ 2, 9 ], [ 4, 9 ], [ 3, 10 ], [ 4, 10 ], [ 5, 11 ], 
      [ 6, 11 ], [ 8, 11 ], [ 5, 12 ], [ 7, 12 ], [ 9, 12 ], [ 8, 13 ], [ 9, 13 ], [ 10, 13 ], [ 6, 14 ], [ 7, 14 ], [ 10, 14 ] ], [ 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2 ], 
  [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 ] 
);

AutomorphismGroup(g);
#AutomorphismGroup( UnderlyingNautyGraph(g) );

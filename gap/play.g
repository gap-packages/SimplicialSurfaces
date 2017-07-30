LoadPackage("grape");
LoadPackage("NautyTracesInterface");
LoadPackage("Digraph");

Read( "init.g" );
Read( "read.g" );

Read( "test.g" );

D := SimplicialSurfaceByVerticesInFaces(3,1,[[1,2,3]]);
T := Tetrahedron();
CC := CommonCover( D,T, [1,1,2], [2,2,2,1,1,1] );;

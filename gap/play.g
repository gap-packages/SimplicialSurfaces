LoadPackage("grape");
LoadPackage("NautyTracesInterface");
LoadPackage("Digraph");

Read( "init.g" );
Read( "read.g" );

Read( "test.g" );

J := Janushead();
CC := CommonCover( J,J, [2,2,1], [1,1,2] );;

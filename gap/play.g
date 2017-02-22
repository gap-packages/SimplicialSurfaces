LoadPackage("grape");
Read( "init.g" );
Read( "read.g" );

Read( "test.g" );


	surf := Objectify( WildSimplicialSurfaceType, rec() );
	SetEdges( surf, [1..6] );
	SetFaces( surf, [1..4] );
	#SetFacesOfEdges( surf, [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 2 ], [ 2 .. 4 ], [ 3, 4 ] ] );
	SetEdgesOfFaces( surf, [[1,2,3],[1,4,5],[2,5,6],[3,5,6]] );


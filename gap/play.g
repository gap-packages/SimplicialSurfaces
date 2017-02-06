LoadPackage("grape");
Read( "init.g" );
Read( "read.g" );

Read( "test.g" );


	surf := SimplicialSurfaceByDownwardIncidence( [1,2,3,4], 5, [1,4],
		[ [1,2],[1,3],[3,2],[4,3],[2,4] ],
		[ [1,2,3], , , [3,5,4] ] );
	surf := ColouredSimplicialSurface( surf );


	# Try a correct identification by maps
	vertexMap := GeneralMappingByElements( Domain( [1,2,3] ), Domain( [2,3,4] ), 
		[ DirectProductElement([1,4]), DirectProductElement([2,2]), DirectProductElement([3,3]) ]);
	edgeMap := GeneralMappingByElements( Domain( [1,2,3] ), Domain( [3,4,5] ), 
		[ DirectProductElement([1,4]), DirectProductElement([2,5]), DirectProductElement([3,3]) ]);
	faceMap := GeneralMappingByElements( Domain( [1] ), Domain( [4] ), 
		[ DirectProductElement([1,4]) ]);
	id := SimplicialSurfaceIdentification( vertexMap, edgeMap, faceMap );

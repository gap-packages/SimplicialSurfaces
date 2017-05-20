################################################################################
################################################################################
#####					Test two connected triangles
################################################################################
################################################################################


TestIsomorphicTwoConTri := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( [1,2,3,4], 5, [1,4],
		[ [1,2],[1,3],[3,2],[4,3],[2,4] ],
		[ [1,2,3], , , [3,5,4] ] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to two connected triangles.\n");
	fi;
end;


##
##	Test whether a simplicial surface is isomorphic to two connected triangles.
##
TestIsTwoConnectedTriangles := function( surface, messageSurfaceOrigin )
	local snipp;

	TestSimplicialSurfaceAttributes( surface, messageSurfaceOrigin, rec(
		vertexNr := 4, 		# number of vertices
		edgeNr := 5, 		# number of edges
		faceNr := 2,		# number of faces
		isEdgesLikeSurface := true,	# do the edges look like on a surface?
		isVerticesLikeSurface := true,	# do the vertices look like on a surface?
		isTriangleSurface := true,	# is every face a triangle?
		isClosedSurface := false,	# is it closed?
		isOrientable := true,	# is it orientable?
		isConnected := true, 	# is it connected?
		sortDeg := [1,1,2,2],		# the sorted degrees
		vertexSym := [,2,2],			# the vertex symbol
		faceAnomalyClassNr := 2,		# the number of anomaly classes
		isSnippable := true	# does ear-removal reduce the surface?
            )
	);
	

	snipp := SnippOffEars(surface);
	if NrOfVertices(snipp) > 0 or NrOfEdges(snipp) > 0 or NrOfFaces(snipp) > 0 then
		Print( messageSurfaceOrigin );
		Print( " should be destroyed by removal of ears.\n");
	fi;

	TestIsomorphicTwoConTri( surface, messageSurfaceOrigin);

end;



##########################################################################
## This method tests the functionality for the example of two connected 
## triangles and the representation of a simplicial surface
TestTwoConnectedTriangles := function()
	local surf, name;

	name := "TwoConTri";

	surf := SimplicialSurfaceByVerticesInFaces( 4,2, [[1,2,3],[3,2,4]] );

	TestIsTwoConnectedTriangles( surf, Concatenation(name," definition") );

	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );
end;


##
##	Test whether a wild simplicial surface is a tetrahedron.
##
TestIsWildTwoConnectedTriangles := function( surface, messageSurfaceOrigin )
	local vertexGroup, invGroup;

	# Check if it fulfills the criteria of a janus head (necessary to check
	# since some methods might have been overwritten).
	TestIsTwoConnectedTriangles( surface, messageSurfaceOrigin );
	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	#TODO how to check?


	# Check vertex group
	vertexGroup := VertexGroup(surface);
	vertexGroup := vertexGroup[1] / vertexGroup[2];
	# TODO this is an infinite group - how to test this?


	# Check group generated from the involutions
	invGroup := GroupOfWildSimplicialSurface( surface );
	if Size( invGroup ) <> 2 then
		Print( messageSurfaceOrigin );
		Print( " should have generated group C_2.\n");
	fi;
end;


##########################################################################
## This method tests the functionality for the example of a tetrahedron
## and the representation as a wild simplicial surface
TestWildTwoConnectedTriangles := function()
	local surf, name;

	name := "TwoConTri (wild)";

	
	# Constructor by downward incidence and edge colouring
	surf := WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring( [1,2,3,4],
		 5, [1,4], [ [1,2],[1,3],[3,2],[4,3],[2,4] ],
		[ [1,2,3], , , [3,5,4] ],[ 1, 2, 3, 2, 1 ] );
	TestIsWildTwoConnectedTriangles( surf, Concatenation(name," by downward incidence with edge colouring") );


	# Constructor by extending simplicial surface with edge colouring
	surf := SimplicialSurfaceByDownwardIncidence( [1,2,3,4], 5, [1,4],
		[ [1,2],[1,3],[3,2],[4,3],[2,4] ],
		[ [1,2,3], , , [3,5,4] ] );
	surf := WildSimplicialSurfaceExtensionByEdgeColouring( surf, [ 1, 2, 3, 2, 1 ] );
	TestIsWildTwoConnectedTriangles( surf, Concatenation(name," by extension with edge colouring") );


	# Constructor by face-edge-paths and edge colouring
	surf := WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring( 4,5,2,
		[ [[1,1,2]] , [[5,2,3,1,1]], [[4,2,3,1,2]], [[4,2,5]] ], [1,2,3,1,2] );
	TestIsWildTwoConnectedTriangles( surf, Concatenation(name," by faceEdgePaths and edge colouring") );
	

	# Constructor by coloured face-edge-paths
	surf := WildSimplicialSurfaceByColouredFaceEdgePaths( 4,2,
		[ [1,1,2] , [2,2,3,1,1], [1,2,3,1,2], [1,2,2] ]);
	TestIsWildTwoConnectedTriangles( surf, Concatenation(name," by colouredFaceEdgePaths") );
	
end;


##
##	Test simplicial surface identifications
##
TestTwoConnectedTrianglesIdentification := function()
	local surf, name, id, vertexMap, edgeMap, faceMap;

	surf := SimplicialSurfaceByDownwardIncidenceWithOrientation( [1,2,3,4], 5, [1,4],
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
	TestSimplicialSurfaceIdentificationConsistency( id, "Unique identification of TwoConTri (by maps)" );
	TestColouredIdentificationConsistency( surf, id, "Unique identification of TwoConTri (by maps) and TwoConTri" );

	# Try an incorrect identification by maps
	vertexMap := GeneralMappingByElements( Domain( [1,2,4] ), Domain( [2,3,4] ), 
		[ DirectProductElement([1,4]), DirectProductElement([2,2]), DirectProductElement([4,3]) ]);
	edgeMap := GeneralMappingByElements( Domain( [1,2,3] ), Domain( [3,4,5] ), 
		[ DirectProductElement([1,4]), DirectProductElement([2,5]), DirectProductElement([3,3]) ]);
	faceMap := GeneralMappingByElements( Domain( [1] ), Domain( [4] ), 
		[ DirectProductElement([1,4]) ]);
	id := SimplicialSurfaceIdentification( vertexMap, edgeMap, faceMap );
	TestSimplicialSurfaceIdentificationConsistency( id, "Incorrect identification of TwoConTri (by maps)" );
	TestColouredIdentificationConsistency( surf, id, "Incorrect identification of TwoConTri (by maps) and TwoConTri" );

	# Try a correct identification by lists
	id := SimplicialSurfaceIdentificationByLists( [ [1,4],[2,2],[3,3] ], [ [1,4],[2,5],[3,3] ], [ [1,4] ] );
	TestSimplicialSurfaceIdentificationConsistency( id, "Unique identification of TwoConTri (by lists)" );
	TestColouredIdentificationConsistency( surf, id, "Unique identification of TwoConTri (by lists) and TwoConTri" );

	# Try an incorrect identification by lists
	id := SimplicialSurfaceIdentificationByLists( [ [1,4],[2,2],[3,3] ], [ [1,4],[2,5],[3,3] ], [ [1,2] ] );
	TestSimplicialSurfaceIdentificationConsistency( id, "Incorrect identification of TwoConTri (by lists)" );
	TestColouredIdentificationConsistency( surf, id, "Incorrect identification of TwoConTri (by lists) and TwoConTri" );
end;


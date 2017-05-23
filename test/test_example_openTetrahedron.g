################################################################################
################################################################################
#####					Test an open tetrahedron
################################################################################
################################################################################



TestIsomorphicOpenTetrahedron := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( 4,6,3, 
		[[1,4],[2,1],[2,4],[2,3],[4,3],[1,3]], [[1,2,3],[1,6,5],[4,5,3]] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to an open tetrahedron.\n");
	fi;
end;

##
##	Test whether a simplicial surface is an open tetrahedron, that is a
##	tetrahedron that is missing one face
##
TestIsOpenTetrahedron := function( surface, messageSurfaceOrigin )

	TestSimplicialSurfaceAttributes( surface, messageSurfaceOrigin, rec(
		vertexNr := 4, 		# number of vertices
		edgeNr := 6, 	# number of edges
		faceNr := 3,		# number of faces
		isEdgesLikeSurface := true,	# do the edges look like on a surface?
		isVerticesLikeSurface := true,	# do the vertices look like on a surface?
		isTriangleSurface := true,	# is every face a triangle?
		isClosedSurface := false,	# is it closed?
		isOrientable := true,	# is it orientable?
		connectedComponentNr := 1, 	# is it connected?
                pathConnectedComponentNr := 1,
		sortDeg := [2,2,2,3],		# the sorted degrees
		vertexSym := [,,4],			# the vertex counter
                edgeSym := [[0,0,0],[0,0,0],[0,0,6]],   # the edge counter
		faceAnomalyClassNr := 3,		# the number of anomaly classes
                edgeAnomalyClassNr := 6,
		isSnippable := false	# does ear-removal reduce the surface?
            )
	);
	
	TestIsomorphicOpenTetrahedron( surface, messageSurfaceOrigin );
	
end;



##########################################################################
## This method tests the functionality for the example of a tetrahedron
## and the representation of a simplicial surface
TestOpenTetrahedron := function()
	local surf, name;

	name := "Open Tetrahedron";

	surf := SimplicialSurfaceByVerticesInFaces( 4,3, [[1,2,3],[1,3,4],[3,2,4]] );

	TestIsOpenTetrahedron( surf, Concatenation(name," definition") );
	
	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );

end;


##
##	Test whether a wild simplicial surface is an open tetrahedron.
##
TestIsWildOpenTetrahedron := function( surface, messageSurfaceOrigin )
	local vertexGroup, invGroup;

	# Check if it fulfills the criteria of an open tetrahedron (necessary to check
	# since some methods might have been overwritten).
	TestIsOpenTetrahedron( surface, messageSurfaceOrigin );
	TestWildSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	#TODO how to check?

	vertexGroup := VertexGroup(surface);
	vertexGroup := vertexGroup[1] / vertexGroup[2];
	if not IsDihedralGroup( vertexGroup ) or Size( vertexGroup ) <> 4 then
		Print( messageSurfaceOrigin );
		Print( " should have vertex group V_4.\n");
	fi;

	# Check group generated from the involutions
	invGroup := GroupOfWildSimplicialSurface( surface );
	if not IsDihedralGroup( invGroup ) or Size( invGroup ) <> 6 then
		Print( messageSurfaceOrigin );
		Print( " should have generated group D_6.\n");
	fi;
end;


##########################################################################
## This method tests the functionality for the example of an open tetrahedron
## and the representation as a wild simplicial surface
TestWildOpenTetrahedron := function()
	local surf, name, sig1, sig2, sig3, gens;

	name := "Open tetrahedron (wild)";

	sig1 := (1,2);
	sig2 := (2,3);
	sig3 := (1,3);

	gens := [sig1,sig2,sig3];


	# Constructor by downward incidence and edge colouring
	surf := WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring( 4,6,3, 
		[[1,4],[2,1],[2,4],[2,3],[4,3],[1,3]], [[1,2,3],[1,6,5],[4,5,3]],
		[ 1, 2, 3, 1, 2, 3 ] );
	TestIsWildOpenTetrahedron( surf, Concatenation(name," by downward incidence with edge colouring") );

	
	# Constructor by downward incidence and generators
	surf := WildSimplicialSurfaceByDownwardIncidenceAndGenerators( 4,6,3, 
		[[1,4],[2,1],[2,4],[2,3],[4,3],[1,3]], [[1,2,3],[1,6,5],[4,5,3]],
		gens );
	TestIsWildOpenTetrahedron( surf, Concatenation(name," by downward incidence with generators") );


	# Constructor by extending simplicial surface with edge colouring
	surf := SimplicialSurfaceByDownwardIncidence( 4,6,3, 
		[[1,4],[2,1],[2,4],[2,3],[4,3],[1,3]], [[1,2,3],[1,6,5],[4,5,3]] );
	surf := WildSimplicialSurfaceExtensionByEdgeColouring( surf, [ 1, 2, 3, 1, 2, 3 ] );
	TestIsWildOpenTetrahedron( surf, Concatenation(name," by extension with edge colouring") );


	# Constructor by extending simplicial surface with generators
	surf := SimplicialSurfaceByDownwardIncidence( 4,6,3, 
		[[1,4],[2,1],[2,4],[2,3],[4,3],[1,3]], [[1,2,3],[1,6,5],[4,5,3]] );
	surf := WildSimplicialSurfaceExtensionByGenerators( surf, gens );
	TestIsWildOpenTetrahedron( surf, Concatenation(name," by extension with generators") );


	# Constructor by face-edge-paths and edge colouring
	surf := WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring( [1,2,3,5],
		[2,3,5,6,10,15], [17,23,31],
		[ [[3,23,5,17,2]] , [[6,31,10,17,2]] , [[3,23,15,31,6]], , [[10,31,15,23,5,17]] ],
		[,1,2,,3,3,,,,2,,,,,1] );
	TestIsWildOpenTetrahedron( surf, Concatenation(name," by faceEdgePaths and edge colouring") );
	

	# Constructor by coloured face-edge-paths
	surf := WildSimplicialSurfaceByColouredFaceEdgePaths( [1,2,3,5],[10,20,30],
		[ [2,20,3,10,1] , [3,30,2,10,1] , [2,20,1,30,3], , [2,30,1,20,3,10] ]);
	TestIsWildOpenTetrahedron( surf, Concatenation(name," by colouredFaceEdgePaths") );
	
end;


##
##	Test simplicial surface fans
##
TestOpenTetrahedronFan := function()
	local surf, colSurf, fan, name, edge;

	surf := SimplicialSurfaceByDownwardIncidence( 4,6,3, 
		[[1,4],[2,1],[2,4],[2,3],[4,3],[1,3]], [[1,2,3],[1,6,5],[4,5,3]] );
	colSurf := ColouredSimplicialSurface( surf );

	name := "Fan for open tetrahedron";

	# Construct one fan explicitly that works
	fan := SimplicialSurfaceFan( 1, 2, () : Corona := [1] );
	TestFanAttributes( fan, name, 1, 2, (), [1] );
	TestFanEdge( fan, name, surf, 2, colSurf, 2 );
	
	fan := SimplicialSurfaceFan( 4, 2, (1,3) );
	TestFanAttributes( fan, name, 4, 2, (1,3), [1,3] );
	TestFanEdge( fan, name, surf, 3, colSurf, 3 );

	# Construct some fans explicitly that do not work
	fan := SimplicialSurfaceFan( 1, 2, () );
	TestFanAttributes( fan, name, 1, 2, (), [] );
	TestFanEdge( fan, name, surf, fail, colSurf, fail );

	
	# Construct some fans with direct reference to the (coloured) simplicial surface
	fan := SimplicialSurfaceFanByEdgeInSimplicialSurface( surf, 6 );
	TestFanAttributes( fan, name, 1, 3, (), [2] );
	TestFanEdge( fan, name, surf, 6, colSurf, 6 );

	fan := SimplicialSurfaceFanByEdgeInColouredSimplicialSurface( colSurf, 5 );
	TestFanAttributes( fan, name, 3, 4, (3,2), [2,3] );
	TestFanEdge( fan, name, surf, 5, colSurf, 5 );
end;


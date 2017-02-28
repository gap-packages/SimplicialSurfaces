################################################################################
################################################################################
#####		Test a projective plane build from four triangles
################################################################################
################################################################################


ExampleProjectivePlaneFour := function()
	return SimplicialSurfaceByDownwardIncidence( 3,6,4, 
		[[1,2],[2,3],[3,1],[1,2],[1,3],[2,3]],
		[[1,6,3],[3,2,4],[5,6,4],[5,1,2]]  );
end;



TestIsomorphicProjectivePlaneFour := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( [1..3],6,[1..4], 
		[[1,2],[2,3],[3,1],[1,2],[1,3],[2,3]],
		[[1,6,3],[3,2,4],[5,6,4],[5,1,2]]  );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to a projective plane.\n");
	fi;
end;


##
##	Test whether a simplicial surface is a projective plane build from four 
##	triangles.
##
TestIsProjectivePlaneFour := function( surface, messageSurfaceOrigin )
	
	TestSimplicialSurfaceAttributes( surface, messageSurfaceOrigin,
		3, 		# number of vertices
		6, 	# number of edges
		4,		# number of faces
		true,	# do the edges look like on a surface?
		true,	# do the vertices look like on a surface?
		true,	# is every face a triangle?
		true,	# is it closed?
		false,	# is it orientable?
		true, 	# is it connected?
		[4,4,4],		# the sorted degrees
		[,,,3],			# the vertex symbol
		1,		# the number of anomaly classes
		false	# does ear-removal reduce the surface?
	);
	
	TestIsomorphicProjectivePlaneFour( surface, messageSurfaceOrigin );
	
end;



##########################################################################
## This method tests the functionality for the example of a projective plane
## with four triangles and the representation of a simplicial surface
TestProjectivePlaneFour := function()
	local surf, name;

	name := "Projective plane with four triangles";

	surf := ExampleProjectivePlaneFour();

	TestIsProjectivePlaneFour( surf, Concatenation(name," definition") );

	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );
end;


##
##	Test whether a wild simplicial surface is a projective plane.
##
TestIsWildProjectivePlaneFour := function( surface, messageSurfaceOrigin )
	local vertexGroup, invGroup;

	# Check if it fulfills the criteria of a projective plane (necessary to check
	# since some methods might have been overwritten).
	TestIsProjectivePlaneFour( surface, messageSurfaceOrigin );
	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	#TODO how to check?


	# Check vertex group
	vertexGroup := VertexGroup(surface);
	vertexGroup := vertexGroup[1] / vertexGroup[2];
	if Size( vertexGroup ) <> 8 or Exponent( vertexGroup ) <> 2  then
		Print( messageSurfaceOrigin );
		Print( " should have vertex group C_2^3.\n");
	fi;


	# Check group generated from the involutions
	invGroup := GroupOfWildSimplicialSurface( surface );
	if not IsDihedralGroup( invGroup ) or Size( invGroup ) <> 4 then
		Print( messageSurfaceOrigin );
		Print( " should have generated group V_4.\n");
	fi;
end;


##########################################################################
## This method tests the functionality for the example of a tetrahedron
## and the representation as a wild simplicial surface
TestWildProjectivePlaneFour := function()
	local surf, name, sig1, sig2, sig3, gens;

	name := "Projective plane four (wild)";

	sig1 := (1,4)(2,3);
	sig2 := (1,3)(2,4);
	sig3 := (1,2)(4,3);

	gens := [sig1,sig2,sig3];


	# Constructor by downward incidence and edge colouring
	surf := WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring( 3,6,4, 
		[[1,2],[2,3],[3,1],[1,2],[1,3],[2,3]],
		[[1,6,3],[3,2,4],[5,6,4],[5,1,2]],
		[ 1, 2, 3, 1, 3, 2 ] );
	TestIsWildProjectivePlaneFour( surf, Concatenation(name," by downward incidence with edge colouring") );

	
	# Constructor by downward incidence and generators
	surf := WildSimplicialSurfaceByDownwardIncidenceAndGenerators( 3,6,4, 
		[[1,2],[2,3],[3,1],[1,2],[1,3],[2,3]],
		[[1,6,3],[3,2,4],[5,6,4],[5,1,2]], gens );
	TestIsWildProjectivePlaneFour( surf, Concatenation(name," by downward incidence with generators") );


	# Constructor by extending simplicial surface with edge colouring
	surf := SimplicialSurfaceByDownwardIncidence( 3,6,4, 
		[[1,2],[2,3],[3,1],[1,2],[1,3],[2,3]],
		[[1,6,3],[3,2,4],[5,6,4],[5,1,2]] );
	surf := WildSimplicialSurfaceExtensionByEdgeColouring( surf, [ 1, 2, 3, 1, 3, 2 ] );
	TestIsWildProjectivePlaneFour( surf, Concatenation(name," by extension with edge colouring") );


	# Constructor by extending simplicial surface with generators
	surf := SimplicialSurfaceByDownwardIncidence( 3,6,4, 
		[[1,2],[2,3],[3,1],[1,2],[1,3],[2,3]],
		[[1,6,3],[3,2,4],[5,6,4],[5,1,2]] );
	surf := WildSimplicialSurfaceExtensionByGenerators( surf, gens );
	TestIsWildProjectivePlaneFour( surf, Concatenation(name," by extension with generators") );


	# Constructor by face-edge-paths and edge colouring
	surf := WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring( 3,6,4,
		[ [[1,1,3,2,4,3,5,4]] , [[1,4,2,2,4,3,6,1]] , [[3,1,6,3,5,4,2,2]] ],
		[ 1, 2, 3, 1, 3, 2 ] );
	TestIsWildProjectivePlaneFour( surf, Concatenation(name," by faceEdgePaths and edge colouring") );
	

	# Constructor by coloured face-edge-paths
	surf := WildSimplicialSurfaceByColouredFaceEdgePaths( 3,[11,12,13,14],
		[ [1,11,3,12,1,13,3,14] , [1,14,2,12,1,13,2,11] , [3,11,2,13,3,14,2,12] ]);
	TestIsWildProjectivePlaneFour( surf, Concatenation(name," by colouredFaceEdgePaths") );
	
end;



##
##	Test simplicial surface fans
##
TestProjectivePlaneFourFan := function()
	local surf, colSurf, fan, name, edge;

	surf := ExampleProjectivePlaneFour();
	colSurf := ColouredSimplicialSurface( surf );

	name := "Fan for projective plane with four triangles";

	
	# Construct some fans with direct reference to the (coloured) simplicial surface
	for edge in Edges(surf) do
		fan := SimplicialSurfaceFanByEdgeInSimplicialSurface( surf, edge );
		TestFanEdge( fan, name, surf, edge, colSurf, edge );
	od;

	for edge in EdgeEquivalenceNumbersAsSet(colSurf) do
		fan := SimplicialSurfaceFanByEdgeInColouredSimplicialSurface( colSurf, edge );
		TestFanEdge( fan, name, surf, edge, colSurf, edge );
	od;
end;


################################################################################
################################################################################
#####							Test a janus head
################################################################################
################################################################################


##
##	Generate an example janus head as a simplicial surface
##
ExampleJanusHead := function()
	return SimplicialSurfaceByDownwardIncidence( 3, 3, 2, [[1,2],[2,3],[3,1]], 
		[[1,2,3],[1,2,3]] );
end;


TestIsomorphicJanus := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( [2,3,5], [3,6,9], [3,7],
		[ , , [2,3], , , [3,5], , , [2,5] ],
		[ , , [3,6,9], , , , [6,3,9] ] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to a janus head.\n");
	fi;
end;

##
##	Test whether a simplicial surface is a janus head.
##
TestIsJanusHead := function( surface, messageSurfaceOrigin )

	TestSimplicialSurfaceAttributes( surface, messageSurfaceOrigin,
		3, 		# number of vertices
		3, 		# number of edges
		2,		# number of faces
		true,	# do the edges look like on a surface?
		true,	# do the vertices look like on a surface?
		true,	# is every face a triangle?
		true,	# is it closed?
		true,	# is it orientable?
		true, 	# is it connected?
		[2,2,2],		# the sorted degrees
		[,3],			# the vertex symbol
		1,		# the number of anomaly classes
		false	# does ear-removal reduce the surface?
	);
	
	TestIsomorphicJanus( surface, messageSurfaceOrigin );
	
end;


	


##########################################################################
## This method tests the functionality for the example of a janus head
## and the representation of a simplicial surface
TestJanusHead := function()
	local surf, name;

	name := "Janus head";

	surf := ExampleJanusHead();

	TestIsJanusHead( surf, Concatenation(name," definition") );

	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );
end;



##
##	Test whether a wild simplicial surface is a janus head.
##
TestIsWildJanusHead := function( surface, messageSurfaceOrigin )
	local vertexGroup, invGroup;

	# Check if it fulfills the criteria of a janus head (necessary to check
	# since some methods might have been overwritten).
	TestIsJanusHead( surface, messageSurfaceOrigin );
	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	#TODO how to check?

	vertexGroup := VertexGroup(surface);
	vertexGroup := vertexGroup[1] / vertexGroup[2];
	if Size( vertexGroup ) <> 2 then
		Print( messageSurfaceOrigin );
		Print( " should have vertex group C_2.\n");
	fi;

	# Check group generated from the involutions
	invGroup := GroupOfWildSimplicialSurface( surface );
	if Size( invGroup ) <> 2 then
		Print( messageSurfaceOrigin );
		Print( " should have generated group C_2.\n");
	fi;

end;


##########################################################################
## This method tests the functionality for the example of a janus head
## and the representation as a wild simplicial surface
TestWildJanusHead := function()
	local surf, name, sig1, sig2, sig3, gens;

	name := "Janus head (wild)";

	sig1 := (1,2);
	sig2 := (1,2);
	sig3 := (1,2);

	gens := [sig1,sig2,sig3];


	# TODO
	
	# Constructor by downward incidence and edge colouring
	surf := WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring( [2,3,5], 
		[3,6,9], [3,7],	[ , , [2,3], , , [3,5], , , [2,5] ],
		[ , , [3,6,9], , , , [6,3,9] ], [ , , 1, , , 2, , , 3 ] );
	TestIsWildJanusHead( surf, Concatenation(name," by downward incidence with edge colouring") );

	
	# Constructor by downward incidence and generators
	surf := WildSimplicialSurfaceByDownwardIncidenceAndGenerators( 
		[2,3,5], [3,6,9], 2, [ , , [2,3], , , [3,5], , , [2,5] ], 
		[[3,6,9], [6,3,9] ], gens );
	TestIsWildJanusHead( surf, Concatenation(name," by downward incidence with generators") );


	# Constructor by extending simplicial surface with edge colouring
	surf := SimplicialSurfaceByDownwardIncidence( 3, 3, 2, [[1,2],[2,3],[3,1]], 
		[[1,2,3],[1,2,3]] );
	surf := WildSimplicialSurfaceExtensionByEdgeColouring( surf, [ 1, 2, 3 ] );
	TestIsWildJanusHead( surf, Concatenation(name," by extension with generators") );


	# Constructor by extending simplicial surface with generators
	surf := SimplicialSurfaceByDownwardIncidence( 3, 3, 2, [[1,2],[2,3],[3,1]], 
		[[1,2,3],[1,2,3]] );
	surf := WildSimplicialSurfaceExtensionByGenerators( surf, gens );
	TestIsWildJanusHead( surf, Concatenation(name," by extension with generators") );


	# Constructor by face-edge-paths and edge colouring
	surf := WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring( [2,3,5], 
		[3,6,9], [3,7],
		[ ,[[3,3,6,7]] , [[3,7,9,3]] ,, [[6,3,9,7]] ],
		[ , , 1, , , 2, , , 3 ] );
	TestIsWildJanusHead( surf, Concatenation(name," by faceEdgePaths and edge colouring") );
	

	# Constructor by coloured face-edge-paths
	surf := WildSimplicialSurfaceByColouredFaceEdgePaths( [2,3,5], [3,7],
		[ ,[1,3,2,7] , [1,7,3,3] ,, [2,3,3,7] ]);
	TestIsWildJanusHead( surf, Concatenation(name," by colouredFaceEdgePaths") );

end;


##
##	Test simplicial surface identifications
##
TestJanusHeadIdentification := function()
	local surf, id, colSurf;

	surf := ExampleJanusHead();
	colSurf := ColouredSimplicialSurface( surf );


	# Try a definition of neighbour identification
	id := NeighbourIdentification( surf, 1, 2 );
	if id <> NeighbourIdentification( colSurf, 1, 2) then
		Error("Can't define janus head neighbour identification independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id, "Neighbour identification of janus head" );
	TestColouredIdentificationConsistency( colSurf, id, "Neighbour identification of janus head and janus head" );
	if not IsConstantOnIntersection(colSurf, id) then
		Error("Neighbour identification of janus head should be constant on intersection.");
	fi;
	if not IsApplicableExtension( colSurf, id ) then
		Error("Neighbour identification of janus head should be applicable.");
	fi;
end;


##
##	Test simplicial surface fans
##
TestJanusHeadFan := function()
	local surf, colSurf, fan, name;

	surf := ExampleJanusHead();
	colSurf := ColouredSimplicialSurface( surf );

	name := "Fan for janus head";

	# Construct one fan explicitly that works
	fan := SimplicialSurfaceFan( 1, 2, (1,2) : Corona := [1,2] );
	TestFanAttributes( fan, name, 1, 2, (1,2), [1,2] );
	TestFanEdge( fan, name, surf, 1, colSurf, 1 );
	
	fan := SimplicialSurfaceFan( 3, 2, (1,2) );
	TestFanAttributes( fan, name, 3, 2, (1,2), [1,2] );
	TestFanEdge( fan, name, surf, 2, colSurf, 2 );

	# Construct some fans explicitly that do not work
	fan := SimplicialSurfaceFan( 1, 2, (1,3) );
	TestFanAttributes( fan, name, 1, 2, (1,3), [1,3] );
	TestFanEdge( fan, name, surf, fail, colSurf, fail );
	
	fan := SimplicialSurfaceFan( 4, 2, (1,2) );
	TestFanAttributes( fan, name, 4, 2, (1,2), [1,2] );
	TestFanEdge( fan, name, surf, fail, colSurf, fail );

	
	# Construct some fans with direct reference to the (coloured) simplicial surface
	fan := SimplicialSurfaceFanByEdgeInSimplicialSurface( surf, 3 );
	TestFanAttributes( fan, name, 1, 3, (1,2), [1,2] );
	TestFanEdge( fan, name, surf, 3, colSurf, 3 );

	fan := SimplicialSurfaceFanByEdgeInColouredSimplicialSurface( colSurf, 2 );
	TestFanAttributes( fan, name, 2, 3, (1,2), [1,2] );
	TestFanEdge( fan, name, surf, 2, colSurf, 2 );
end;

################################################################################
################################################################################
#####							Test a tetrahedron
################################################################################
################################################################################


TestIsomorphicTetrahedron := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( [2,3,5,7], [1..6], [1..4],
		[ [2,3],[5,2],[2,7],[5,3],[5,7],[7,3] ],
		[ [1,2,4], [1,3,6], [5,2,3], [6,5,4] ] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to a tetrahedron.\n");
	fi;
end;

##
##	Test whether a simplicial surface is a tetrahedron.
##
TestIsTetrahedron := function( surface, messageSurfaceOrigin )

	TestSimplicialSurfaceAttributes( surface, messageSurfaceOrigin,
		4, 		# number of vertices
		6, 	# number of edges
		4,		# number of faces
		true,	# do the edges look like on a surface?
		true,	# do the vertices look like on a surface?
		true,	# is every face a triangle?
		true,	# is it closed?
		true,	# is it orientable?
		true, 	# is it connected?
		[3,3,3,3],		# the sorted degrees
		[,,4],			# the vertex symbol
		4,		# the number of anomaly classes
		false	# does ear-removal reduce the surface?
	);
	
	TestIsomorphicTetrahedron( surface, messageSurfaceOrigin );
end;



##########################################################################
## This method tests the functionality for the example of a tetrahedron
## and the representation of a simplicial surface
TestTetrahedron := function()
	local surf, name;

	name := "Tetrahedron";

	surf := SimplicialSurfaceByVerticesInFaces( 4,4, [[1,2,3],[1,3,4],[3,2,4],[1,4,2]] );

	TestIsTetrahedron( surf, Concatenation(name," definition") );

	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );
end;


##
##	Test whether a wild simplicial surface is a tetrahedron.
##
TestIsWildTetrahedron := function( surface, messageSurfaceOrigin )
	local vertexGroup, invGroup;

	# Check if it fulfills the criteria of a tetrahedron (necessary to check
	# since some methods might have been overwritten).
	TestIsTetrahedron( surface, messageSurfaceOrigin );
	TestWildSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	#TODO how to check?


	# Check vertex group
	vertexGroup := VertexGroup(surface);
	vertexGroup := vertexGroup[1] / vertexGroup[2];
	if not IsDihedralGroup( vertexGroup ) or Size( vertexGroup ) <> 4 then
		Print( messageSurfaceOrigin );
		Print( " should have vertex group V_4.\n");
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
TestWildTetrahedron := function()
	local surf, name, sig1, sig2, sig3, gens;

	name := "Tetrahedron (wild)";

	sig1 := (1,3)(2,4);
	sig2 := (1,2)(3,4);
	sig3 := (1,4)(2,3);

	gens := [sig1,sig2,sig3];


	# Constructor by downward incidence and edge colouring
	surf := WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring( 
		[2,3,5,7], [1..6], [1,3,5,7],
		[ [2,3],[5,2],[2,7],[5,3],[5,7],[7,3] ],
		[ [1,2,4],, [1,3,6],, [5,2,3],, [6,5,4] ],
		[ 1, 2, 3, 3, 1, 2 ] );
	TestIsWildTetrahedron( surf, Concatenation(name," by downward incidence with edge colouring") );

	
	# Constructor by downward incidence and generators
	surf := WildSimplicialSurfaceByDownwardIncidenceAndGenerators( 
		[2,3,5,7], [1..6], [1,2,3,4],
		[ [2,3],[5,2],[2,7],[5,3],[5,7],[7,3] ],
		[ [1,2,4], [1,3,6], [5,2,3], [6,5,4] ],
		gens );
	TestIsWildTetrahedron( surf, Concatenation(name," by downward incidence with generators") );


	# Constructor by extending simplicial surface with edge colouring
	surf := SimplicialSurfaceByDownwardIncidence( [2,3,5,7], [1..6], [1..4],
		[ [2,3],[5,2],[2,7],[5,3],[5,7],[7,3] ],
		[ [1,2,4], [1,3,6], [5,2,3], [6,5,4] ] );
	surf := WildSimplicialSurfaceExtensionByEdgeColouring( surf, [ 1, 2, 3, 3, 1, 2 ] );
	TestIsWildTetrahedron( surf, Concatenation(name," by extension with edge colouring") );


	# Constructor by extending simplicial surface with generators
	surf := SimplicialSurfaceByVerticesInFaces( 4,4, [[1,2,3],[1,3,4],[3,2,4],[1,4,2]] );
	surf := WildSimplicialSurfaceExtensionByGenerators( surf, gens );
	TestIsWildTetrahedron( surf, Concatenation(name," by extension with generators") );


	# Constructor by face-edge-paths and edge colouring
	surf := WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring( 4,6,4,
		[ [[1,1,4,2,2,4]] , [[1,1,5,3,3,4]] , [[2,2,6,3,3,4]] , [[4,1,5,3,6,2]] ],
		[ 1, 2, 3, 3, 2, 1 ] );
	TestIsWildTetrahedron( surf, Concatenation(name," by faceEdgePaths and edge colouring") );
	

	# Constructor by coloured face-edge-paths
	surf := WildSimplicialSurfaceByColouredFaceEdgePaths( 4,4,
		[ [1,1,3,2,2,4] , [1,1,2,3,3,4] , [2,2,1,3,3,4] , [3,1,2,3,1,2] ]);
	TestIsWildTetrahedron( surf, Concatenation(name," by colouredFaceEdgePaths") );
end;


##
##	Test simplicial surface identifications
##
TestTetrahedronIdentification := function()
	local surf, id, colSurf;

	surf := SimplicialSurfaceByVerticesInFaces( 4,4, [[1,2,3],[1,3,4],[3,2,4],[1,4,2]] );
	colSurf := ColouredSimplicialSurface( surf );


	# Try a definition of neighbour identification
	id := NeighbourIdentification( surf, 1, 2 );
	if id <> NeighbourIdentification( colSurf, 1, 2) then
		Error("Can't define tetrahedron neighbour identification (1,2) independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id, "Neighbour identification (1,2) of tetrahedron" );
	TestColouredIdentificationConsistency( colSurf, id, "Neighbour identification (1,2) of tetrahedron and tetrahedron" );
	if not IsConstantOnIntersection(colSurf, id) then
		Error("Neighbour identification (1,2) of tetrahedron should be constant on intersection.");
	fi;
	if IsApplicableExtension( colSurf, id ) then
		Error("Neighbour identification (1,2) of tetrahedron should not be applicable.");
	fi;

	id := NeighbourIdentification( surf, 4, 2 );
	if id <> NeighbourIdentification( colSurf, 4, 2) then
		Error("Can't define tetrahedron neighbour identification (4,2) independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id, "Neighbour identification (4,2) of tetrahedron" );
	TestColouredIdentificationConsistency( colSurf, id, "Neighbour identification (4,2) of tetrahedron and tetrahedron" );
	if not IsConstantOnIntersection(colSurf, id) then
		Error("Neighbour identification (1,2) of tetrahedron should be constant on intersection.");
	fi;
	if IsApplicableExtension( colSurf, id ) then
		Error("Neighbour identification (1,2) of tetrahedron should not be applicable.");
	fi;
end;




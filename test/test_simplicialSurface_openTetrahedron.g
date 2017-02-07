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

	TestSimplicialSurfaceAttributes( surface, messageSurfaceOrigin,
		4, 		# number of vertices
		6, 	# number of edges
		3,		# number of faces
		true,	# is it an actual surface?
		true,	# is it orientable?
		true, 	# is it connected?
		[2,2,2,3],		# the sorted degrees
		[,,4],			# the vertex symbol
		3,		# the number of anomaly classes
		false	# does ear-removal reduce the surface?
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
	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

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
	local surf, name, sig1, sig2, sig3, mrType, gens;

	name := "Open tetrahedron (wild)";

	sig1 := (1,2);
	sig2 := (2,3);
	sig3 := (1,3);
	mrType := AllEdgesOfSameType( 3, 2);

	gens := [sig1,sig2,sig3];


	# First try to extend a simplicial surface
	surf := SimplicialSurfaceByVerticesInFaces( 4,3, [[1,2,3],[1,3,4],[3,2,4]] );
	surf := WildSimplicialSurfaceExtension( surf, gens );

	TestIsWildOpenTetrahedron( surf, Concatenation(name," by extension") );


	# Next we try to define it from scratch
	surf := WildSimplicialSurface( gens, mrType );

	TestIsWildOpenTetrahedron( surf, Concatenation(name," by mrType") );
	
end;


##
##	Test simplicial surface fans
##
TestOpenTetrahedronFan := function()
	local surf, colSurf, fan, name, edge;

	surf := SimplicialSurfaceByDownwardIncidence( 4,6,3, 
		[[1,4],[2,1],[2,4],[2,3],[4,3],[1,3]], [[1,2,3],[1,6,5],[4,5,3]] );;
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


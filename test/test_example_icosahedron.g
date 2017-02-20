################################################################################
################################################################################
#####						Test an icosahedron
################################################################################
################################################################################


##
##	Generate an example icosahedron as a simplicial surface
##
ExampleIcosahedron := function()
	return SimplicialSurfaceByDownwardIncidence( 12,30, 20, 
		[ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ], [ 1, 4 ], [ 2, 4 ], 
			[ 1, 5 ], [ 4, 5 ], [ 5, 6 ], [ 1, 6 ], [ 3, 6 ], 
			[ 2, 7 ], [ 3, 7 ], [ 2, 8 ], [ 4, 8 ], [ 4, 9 ], 
			[ 5, 9 ], [ 5, 10 ], [ 6, 10 ], [ 6, 11 ], [ 3, 11 ], 
			[ 7, 8 ], [ 8, 9 ], [ 9, 10 ], [ 10, 11 ], [ 7, 11 ], 
			[ 8, 12 ], [ 7, 12 ], [ 9, 12 ], [ 10, 12 ], [ 11, 12 ] ],
		[ [ 1, 2, 3 ], [ 1, 4, 5 ], [ 4, 6, 7 ], [ 6, 8, 9 ], 
			[ 2, 9, 10 ], [ 3, 11, 12 ], [ 5, 13, 14 ], [ 7, 15, 16 ], 
			[ 8, 17, 18 ], [ 10, 19, 20 ], [ 11, 13, 21 ], [ 14, 15, 22 ], 
			[ 16, 17, 23 ], [ 18, 19, 24 ], [ 12, 20, 25 ], [ 21, 26, 27 ],
	        [ 22, 26, 28 ], [ 23, 28, 29 ], [ 24, 29, 30 ], [ 25, 27, 30 ] ] );
end;


TestIsomorphicIcosahedron := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByVerticesInFaces(12,20,
		[ 	[1,2,3], [1,2,4], [1,4,5], [1,5,6],
			[1,3,6], [2,3,7], [2,4,8], [4,9,5],
			[5,6,10], [3,6,11], [2,7,8], [4,8,9],
			[5,9,10], [6,10,11], [3,11,7], [7,8,12],
			[8,9,12], [9,10,12], [10,11,12], [7,11,12]
		] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to an icosahedron.\n");
	fi;
end;


##
##	Test whether a simplicial surface is an icosahedron.
##
TestIsIcosahedron := function( surface, messageSurfaceOrigin )

	TestSimplicialSurfaceAttributes( surface, messageSurfaceOrigin,
		12, 		# number of vertices
		30, 	# number of edges
		20,		# number of faces
		true,	# is it an actual surface?
		true,	# is every face a triangle?
		true,	# is it closed?
		true,	# is it orientable?
		true, 	# is it connected?
		List([1..12],i->5),		# the sorted degrees
		[,,,,12],			# the vertex symbol
		20,		# the number of anomaly classes
		false	# does ear-removal reduce the surface?
	);

	TestIsomorphicIcosahedron( surface, messageSurfaceOrigin );
	
end;


		

##########################################################################
## This method tests the functionality for the example of an icosahedron
## and the representation of a simplicial surface
TestIcosahedron := function()
	local surf, name;

	name := "Icosahedron";

	surf := ExampleIcosahedron();


	TestIsIcosahedron( surf, Concatenation(name," definition") );

	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );

end;


##
##	Test simplicial surface fans
##
TestIcosahedronFan := function()
	local surf, colSurf, fan, name, edge;

	surf := ExampleIcosahedron();
	colSurf := ColouredSimplicialSurface( surf );

	name := "Fan for icosahedron";

	
	# Construct some fans with direct reference to the (coloured) simplicial surface
	edge := 15;
	fan := SimplicialSurfaceFanByEdgeInSimplicialSurface( surf, edge );
	TestFanEdge( fan, name, surf, edge, colSurf, edge );

	edge := 22;
	fan := SimplicialSurfaceFanByEdgeInColouredSimplicialSurface( colSurf, edge );
	TestFanEdge( fan, name, surf, edge, colSurf, edge );
end;



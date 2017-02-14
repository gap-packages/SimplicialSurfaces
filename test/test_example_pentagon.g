################################################################################
################################################################################
#####							Test a pentagon
################################################################################
################################################################################


TestIsomorphicPentagon := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( [1,2,3,4,5,10], 10, 5,
		[ [1,10],[2,10],[3,10],[4,10],[5,10],[1,2],[2,3],[3,4],[4,5],[5,1] ],
		[ [1,2,6], [2,3,7], [3,4,8], [9,5,4], [10,1,5] ] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to a pentagon.\n");
	fi;
end;

##
##	Test whether a simplicial surface is a pentagon.
##
TestIsPentagon := function( surface, messageSurfaceOrigin )

	TestSimplicialSurfaceAttributes( surface, messageSurfaceOrigin,
		6, 		# number of vertices
		10, 	# number of edges
		5,		# number of faces
		true,	# is it an actual surface?
		true,	# is every face a triangle?
		true,	# is it orientable?
		true, 	# is it connected?
		[2,2,2,2,2,5],		# the sorted degrees
		[,,5,,1],			# the vertex symbol
		5,		# the number of anomaly classes
		false	# does ear-removal reduce the surface?
	);
	
	TestIsomorphicPentagon( surface, messageSurfaceOrigin );
end;



##########################################################################
## This method tests the functionality for the example of a pentagon
## and the representation of a simplicial surface
TestPentagon := function()
	local surf, name;

	name := "Pentagon";

	surf := SimplicialSurfaceByVerticesInFaces( 6,5, 
							[[1,2,6],[2,3,6],[3,6,4],[6,4,5],[1,6,5]] );

	TestIsPentagon( surf, Concatenation(name," definition") );

	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );
end;



##
##	Test simplicial surface identifications
##
TestPentagonIdentification := function()
	local surf, colSurf, id12, id23, id43, exA, exB, exC, exAB, exBC;

	surf := SimplicialSurfaceByVerticesInFaces( 6,5, 
							[[1,2,6],[2,3,6],[3,6,4],[6,4,5],[1,6,5]] );
	colSurf := ColouredSimplicialSurface( surf );


	# Try a definition of neighbour identification
	id12 := NeighbourIdentification( surf, 1, 2 );
	if id12 <> NeighbourIdentification( colSurf, 1, 2) then
		Error("Can't define pentagon neighbour identification (1,2) independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id12, "Neighbour identification (1,2) of pentagon" );
	TestColouredIdentificationConsistency( colSurf, id12, "Neighbour identification (1,2) of pentagon and pentagon" );
	if not IsConstantOnIntersection(colSurf, id12) then
		Error("Neighbour identification (1,2) of pentagon should be constant on intersection.");
	fi;
	if not IsApplicableExtension( colSurf, id12 ) then
		Error("Neighbour identification (1,2) of pentagon should be applicable.");
	fi;


	id23 := NeighbourIdentification( surf, 2, 3 );
	if id23 <> NeighbourIdentification( colSurf, 2, 3) then
		Error("Can't define pentagon neighbour identification (2,3) independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id23, "Neighbour identification (2,3) of pentagon" );
	TestColouredIdentificationConsistency( colSurf, id23, "Neighbour identification (2,3) of pentagon and pentagon" );
	if not IsConstantOnIntersection(colSurf, id23) then
		Error("Neighbour identification (2,3) of pentagon should be constant on intersection.");
	fi;
	if not IsApplicableExtension( colSurf, id23 ) then
		Error("Neighbour identification (2,3) of pentagon should be applicable.");
	fi;


	id43 := NeighbourIdentification( surf, 4, 3 );
	if id43 <> NeighbourIdentification( colSurf, 4, 3) then
		Error("Can't define pentagon neighbour identification (4,3) independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id43, "Neighbour identification (4,3) of pentagon" );
	TestColouredIdentificationConsistency( colSurf, id43, "Neighbour identification (4,3) of pentagon and pentagon" );
	if not IsConstantOnIntersection(colSurf, id43) then
		Error("Neighbour identification (4,3) of pentagon should be constant on intersection.");
	fi;
	if not IsApplicableExtension( colSurf, id43 ) then
		Error("Neighbour identification (4,3) of pentagon should be applicable.");
	fi;


	exA := ExtendByIdentification( colSurf, id12 );
	exB := ExtendByIdentification( colSurf, id23 );
	exC := ExtendByIdentification( colSurf, id43 );

	exAB := ExtendByIdentification( exA, id23 );
	exBC := ExtendByIdentification( exB, id43 );

	if not IsConstantOnIntersection( exA, id43 ) then
		Error("Neighbour identification (4,3) should be constant on intersection after extending pentagon by (1,2).");
	fi;
	if IsApplicableExtension( exA, id43 ) then
		Error("Neighbour identification (4,3) should not be applicable after extending pentagon by (1,2).");
	fi;

	if not IsConstantOnIntersection( exC, id12 ) then
		Error("Neighbour identification (1,2) should be constant on intersection after extending pentagon by (4,3).");
	fi;
	if IsApplicableExtension( exC, id12 ) then
		Error("Neighbour identification (1,2) should not be applicable after extending pentagon by (4,3).");
	fi;



	if not IsConstantOnIntersection( exAB, id43 ) then
		Error("Neighbour identification (4,3) should be constant on intersection after extending pentagon by (1,2) and (2,3).");
	fi;
	if IsApplicableExtension( exAB, id43 ) then
		Error("Neighbour identification (4,3) should not be applicable after extending pentagon by (1,2) and (2,3).");
	fi;

	if not IsConstantOnIntersection( exBC, id12 ) then
		Error("Neighbour identification (1,2) should be constant on intersection after extending pentagon by (2,3) and (4,3).");
	fi;
	if IsApplicableExtension( exBC, id12 ) then
		Error("Neighbour identification (1,2) should not be applicable after extending pentagon by (2,3) and (4,3).");
	fi;
end;


##
##	Test simplicial surface fans
##
TestPentagonFan := function()
	local surf, colSurf, fan, name, edge;

	surf := SimplicialSurfaceByDownwardIncidence( [1,2,3,4,5,10], 10, 5,
		[ [1,10],[2,10],[3,10],[4,10],[5,10],[1,2],[2,3],[3,4],[4,5],[5,1] ],
		[ [1,2,6], [2,3,7], [3,4,8], [9,5,4], [10,1,5] ] );
	colSurf := ColouredSimplicialSurface( surf );

	name := "Fan for pentagon";
	
	# Construct some fans with direct reference to the (coloured) simplicial surface
	fan := SimplicialSurfaceFanByEdgeInSimplicialSurface( surf, 1 );
	TestFanAttributes( fan, name, 1, 10, (1,5), [1,5] );
	TestFanEdge( fan, name, surf, 1, colSurf, 1 );

	fan := SimplicialSurfaceFanByEdgeInColouredSimplicialSurface( colSurf, 10 );
	TestFanAttributes( fan, name, 1, 5, (), [5] );
	TestFanEdge( fan, name, surf, 10, colSurf, 10 );
end;

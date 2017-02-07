################################################################################
################################################################################
#####		Test three triangles that have exactly one edge in common
################################################################################
################################################################################


TestIsomorphicThreeTrianglesOnEdge := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( 5, 7, [2,3,4],
		[ [1,2],[1,3],[2,3],[1,4],[2,4],[1,5],[2,5] ],
		[ , [1,3,2], [1,4,5], [1,6,7] ] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to three triangles with a common edge.\n");
	fi;
end;

##
##	Test whether a simplicial surface consists of three triangles that have 
##	exactly one edge in common.
##
TestIsThreeTrianglesOnEdge := function( surface, messageSurfaceOrigin )
	local snipp;

	TestSimplicialSurfaceAttributes( surface, messageSurfaceOrigin,
		5, 		# number of vertices
		7, 	# number of edges
		3,		# number of faces
		false,	# is it an actual surface?
		false,	# is it orientable?
		true, 	# is it connected?
		[1,1,1,3,3],		# the sorted degrees
		[,3,,2],			# the vertex symbol
		3,		# the number of anomaly classes
		true	# does ear-removal reduce the surface?
	);

	snipp := SnippOffEars(surface);
	if NrOfVertices(snipp) > 0 or NrOfEdges(snipp) > 0 or NrOfFaces(snipp) > 0 then
		Print( messageSurfaceOrigin );
		Print( " should be destroyed by removal of ears.\n");
	fi;

	
	TestIsomorphicThreeTrianglesOnEdge( surface, messageSurfaceOrigin );
	
end;



##########################################################################
## This method tests the functionality for the example of three triangles that
## have exactly one edge in common and its representation as simplicial surface
TestThreeTrianglesOnEdge := function()
	local surf, name;

	name := "ThreeTrianglesOnEdge";

	surf := SimplicialSurfaceByVerticesInFaces( 5,3, [[1,2,3],[1,2,4],[1,2,5]] );

	TestIsThreeTrianglesOnEdge( surf, Concatenation(name," definition") );

	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );
end;



##
##	Test simplicial surface identifications
##
TestThreeTrianglesOnEdgeIdentification := function()
	local surf, id12, id23, id13, colSurf, exA, exB, exC, exAB, exAC, exBC;

	surf := SimplicialSurfaceByVerticesInFaces( 5,3, [[1,2,3],[1,2,4],[1,2,5]] );
	colSurf := ColouredSimplicialSurface( surf );


	# Try a definition of neighbour identification
	id12 := NeighbourIdentification( surf, 1, 2 );
	if id12 <> NeighbourIdentification( colSurf, 1, 2) then
		Error("Can't define three triangles on edge neighbour identification (1,2) independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id12, "Neighbour identification (1,2) of three triangles on edge" );
	TestColouredIdentificationConsistency( colSurf, id12, "Neighbour identification (1,2) of three triangles on edge and three triangles on edge" );
	if not IsConstantOnIntersection(colSurf, id12) then
		Error("Neighbour identification (1,2) of three triangles on edge should be constant on intersection.");
	fi;
	if not IsApplicableExtension( colSurf, id12 ) then
		Error("Neighbour identification (1,2) of three triangles on edge should be applicable.");
	fi;


	id23 := NeighbourIdentification( surf, 2, 3 );
	if id23 <> NeighbourIdentification( colSurf, 2, 3) then
		Error("Can't define three triangles on edge neighbour identification (2,3) independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id23, "Neighbour identification (2,3) of three triangles on edge" );
	TestColouredIdentificationConsistency( colSurf, id23, "Neighbour identification (2,3) of three triangles on edge and three triangles on edge" );
	if not IsConstantOnIntersection(colSurf, id23) then
		Error("Neighbour identification (2,3) of three triangles on edge should be constant on intersection.");
	fi;
	if not IsApplicableExtension( colSurf, id23 ) then
		Error("Neighbour identification (2,3) of three triangles on edge should be applicable.");
	fi;


	id13 := NeighbourIdentification( surf, 1, 3 );
	if id13 <> NeighbourIdentification( colSurf, 1, 3) then
		Error("Can't define three triangles on edge neighbour identification (1,3) independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id13, "Neighbour identification (1,3) of three triangles on edge" );
	TestColouredIdentificationConsistency( colSurf, id13, "Neighbour identification (1,3) of three triangles on edge and three triangles on edge" );
	if not IsConstantOnIntersection(colSurf, id13) then
		Error("Neighbour identification (1,3) of three triangles on edge should be constant on intersection.");
	fi;
	if not IsApplicableExtension( colSurf, id13 ) then
		Error("Neighbour identification (1,3) of three triangles on edge should be applicable.");
	fi;


	exA := ExtendByIdentification( colSurf, id12 );
	exB := ExtendByIdentification( colSurf, id23 );
	exC := ExtendByIdentification( colSurf, id13 );

	exAB := ExtendByIdentification( exA, id23 );
	exAC := ExtendByIdentification( exA, id13 );
	exBC := ExtendByIdentification( exB, id13 );

	if not IsApplicableExtension( exAB, id13 ) then
		Error("Neighbour identification (1,3) should be applicable after extending by (1,2) and (2,3) for three triangles on edge");
	fi;
	if exAB <> ExtendByIdentificationNC( exAB, id13 ) then
		Error("Neighbour identification (1,3) should not change three triangles on edge after extending by (1,2) and (2,3).");
	fi;
	if not IsApplicableExtension( exAC, id23 ) then
		Error("Neighbour identification (2,3) should be applicable after extending by (1,3) and (1,2) for three triangles on edge");
	fi;
	if exAC <> ExtendByIdentificationNC( exAC, id23 ) then
		Error("Neighbour identification (2,3) should not change three triangles on edge after extending by (1,3) and (1,2).");
	fi;
	if not IsApplicableExtension( exBC, id12 ) then
		Error("Neighbour identification (1,2) should be applicable after extending by (1,3) and (2,3) for three triangles on edge");
	fi;
	if exBC <> ExtendByIdentificationNC( exBC, id12 ) then
		Error("Neighbour identification (1,2) should not change three triangles on edge after extending by (1,3) and (2,3).");
	fi;
	
end;



##
##	Test simplicial surface fans
##
TestThreeTrianglesOnEdgeFan := function()
	local surf, colSurf, fan, name, edge;

	surf := SimplicialSurfaceByDownwardIncidence( 5, 7, [2,3,4],
		[ [1,2],[1,3],[2,3],[1,4],[2,4],[1,5],[2,5] ],
		[ , [1,3,2], [1,4,5], [1,6,7] ] );
	colSurf := ColouredSimplicialSurface( surf );

	name := "Fan for three triangles on edge";

	# Construct some fans that works
	fan := SimplicialSurfaceFan( 1, 3, () : Corona := [1] );
	TestFanAttributes( fan, name, 1, 3, (), [1] );
	TestFanEdge( fan, name, surf, 2, colSurf, 2 );
	
	fan := SimplicialSurfaceFan( 1, 2, (2,3,4) );
	TestFanAttributes( fan, name, 1, 2, (2,3,4), [2,3,4] );
	TestFanEdge( fan, name, surf, 1, colSurf, 1 );

	# Construct some fans explicitly that do not work
	fan := SimplicialSurfaceFan( 1, 2, (4,2) );
	TestFanAttributes( fan, name, 1, 2, (4,2), [2,4] );
	TestFanEdge( fan, name, surf, fail, colSurf, fail );

	
	# Construct some fans with direct reference to the (coloured) simplicial surface
	fan := SimplicialSurfaceFanByEdgeInSimplicialSurface( surf, 1 );
	TestFanAttributes( fan, name, 1, 2, (2,3,4), [2,3,4] );
	TestFanEdge( fan, name, surf, 1, colSurf, 1 );

	fan := SimplicialSurfaceFanByEdgeInColouredSimplicialSurface( colSurf, 5 );
	TestFanAttributes( fan, name, 2, 4, (), [3] );
	TestFanEdge( fan, name, surf, 5, colSurf, 5 );
end;


################################################################################
################################################################################
#####							Test an icosahedron
################################################################################
################################################################################


##########################################################################
## This method tests the functionality for the example of an icosahedron
## and the representation of a generic simplicial surface
TestIcosahedronGeneric := function()
	local surf, newSurf, graph, snipp;

	surf := GenericSimplicialSurfaceByList( [ 12, 30, 20, 
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
        [ 22, 26, 28 ], [ 23, 28, 29 ], [ 24, 29, 30 ], [ 25, 27, 30 ] ] ]);

	TestGenericConsistency( surf, "Icosahedron definition (generic)" );

	# Test the elementary properties
	if NrOfVertices(surf) <> 12 then
		Print( "Failed: Icosahedron has wrong number of vertices.\n" );
	fi;

	if NrOfEdges(surf) <> 30 then
		Print( "Failed: Icosahedron has wrong number of edges.\n" );
	fi;

	if NrOfFaces(surf) <> 20 then
		Print( "Failed: Icosahedron has wrong number of faces.\n" );
	fi;

	# Test some advanced properties
	if EulerCharacteristic(surf) <> 2 then
		Print( "Icosahedron has wrong Euler-Characteristic.\n" );
	fi;

	if Length( FaceAnomalyClassesOfGenericSimplicialSurface( surf ) ) <> 20 then
		Print( "Failed: ");
		Print( name );
		Print( " should not have a face-anomaly.\n");
	fi;

	if UnsortedDegreesOfGenericSimplicialSurface(surf) <> List([1..12],i->5) or 
		SortedDegreesOfGenericSimplicialSurface(surf) <> List([1..12],i->5) then
		Print( "Failed: Icosahedron vertex degrees are incorrect.\n");
    else
		Print( "  Passed: Icosahedron has correct vertex degrees.\n");
	fi;

	if not IsConnectedGenericSimplicialSurface(surf) then
		Print( "Failed: Icosahedron should be connected.\n" );
    else
		Print( "  Passed: Icosahedron is connected.\n" );
	fi;

	if not IsOrientableGenericSimplicialSurface(surf) then
		Print( "Failed: Icosahedron should be orientable.\n" );
    else
		Print( "  Passed: Icosahedron is orientable.\n" );
	fi;

	if  surf <> SnippOffEars(surf)  then
		Print( "Failed: Icosahedron should not have ears.\n");
    else
		Print( "  Passed: Icosahedron has no ears.\n");
	fi;

	# Check incidence graph
	graph := IncidenceGraphOfGenericSimplicialSurface(surf);
	if not IsGraph(graph) then
		Print( "Failed: Incidence graph is not a graph.\n");
	fi;
	if OrderGraph(graph) <> 62 then
		Print( "Failed: Number of vertices in incidence graph is wrong.\n");
	fi;
	if IsLoopy(graph) then
		Print( "Failed: Incidence graph should not be loopy.\n");
	fi;
	if not IsSimpleGraph(graph) then
		Print( "Failed: Incidence graph is not simple.\n");
	fi;
	if not IsConnectedGraph(graph) then
		Print( "Failed: Incidence graph is not connected.\n");
	fi;
	if not IsBipartite(graph) then
		Print( "Failed: Incidence graph is not bipartite.\n");
	fi;



	newSurf := RemoveVertexOfGenericSimplicialSurface( surf, 1);
	TestGenericConsistency( newSurf, "Icosahedron after removel of one vertex");
	if NrOfVertices(newSurf) <> 11 then
		Print( "Failed: Icosahedron has wrong number of vertices after removing one vertex.\n" );
	fi;
	if NrOfEdges(newSurf) <> 25 then
		Print( "Failed: Icosahedron has wrong number of edges after removing one vertex.\n" );
	fi;
	if NrOfFaces(newSurf) <> 15 then
		Print( "Failed: Icosahedron has wrong number of faces after removing one vertex.\n" );
	fi;

	snipp := SnippOffEars( newSurf );
	if snipp <> newSurf then
		Print( "Failed: Icosahedron after removal of one vertex doesn't have ears." );
	fi;
	

end;


# Test everything
TestIcosahedron := function()
	TestIcosahedronGeneric();
end;

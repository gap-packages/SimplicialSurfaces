################################################################################
################################################################################
#####							Test a janus head
################################################################################
################################################################################


##
##	Test whether a simplicial surface is a janus head.
##
TestIsJanusHead := function( surface, messageSurfaceOrigin )
	local conCom, janus;

	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	if NrOfVertices(surface) <> 3 then
		Print( messageSurfaceOrigin );
		Print( " does not have 3 vertices.\n");
	fi;
	if NrOfEdges(surface) <> 3 then
		Print( messageSurfaceOrigin );
		Print( " does not have 3 edges.\n");
	fi;
	if NrOfFaces(surface) <> 2 then
		Print( messageSurfaceOrigin );
		Print( " does not have 2 faces.\n");
	fi;
	if EulerCharacteristic(surface) <> 2 then
		Print( messageSurfaceOrigin );
		Print( " does not have Euler-Characteristic 2.\n");
	fi;


	# The janus head is an actual surface
	if not IsActualSurface( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must be an actual surface.\n" );
	fi;

	# The janus head is orientable
	if not IsOrientable( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must be orientable.\n");
	fi;

	# The janus head is connected
	if not IsConnected( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must be connected.\n");
	fi;

	# TODO also test for different orders of function calls
	conCom := ConnectedComponentsAttributeOfSimplicialSurface( surface );
	if Length(conCom) <> 1 then
		Print( messageSurfaceOrigin );
		Print( " must have exactly one connected component.\n" );
	fi;
	if conCom[1] <> surface then
		Print( messageSurfaceOrigin );
		Print( " should equal its one connected component.\n");
	fi;

	if SortedDegrees(surface) <> [2,2,2] then
		Print( messageSurfaceOrigin );
		Print( " does not have degrees [2,2,2].\n");
	fi;

	if VertexSymbol(surface) <> [ ,3] then
		Print( messageSurfaceOrigin );
		Print( " does not have the vertex symbol [,3].\n");
	fi;

	if Length( FaceAnomalyClasses(surface) ) <> 1 then
		Print( messageSurfaceOrigin );
		Print( " should have exactly one face anomaly class.\n");
	fi;

	if surface <> SnippOffEars(surface) then
		Print( messageSurfaceOrigin );
		Print( " should not be changed by removal of ears.\n");
	fi;

	janus := SimplicialSurfaceByDownwardIncidence( [2,3,5], [3,6,9], [3,7],
		[ , , [2,3], , , [3,5], , , [2,5] ],
		[ , , [3,6,9], , , , [6,3,9] ] );
	if not IsIsomorphic( surface, janus ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to a janus head.\n");
	fi;
	
end;




##########################################################################
## This method tests the functionality for the example of a janus head
## and the representation of a generic simplicial surface
TestJanusHead := function()
	local surf, newSurf, graph, name, anomalies;

	name := "Janus head";

	surf := SimplicialSurfaceByDownwardIncidence( 3, 3, 2, [[1,2],[2,3],[3,1]], 
		[[1,2,3],[1,2,3]] );

	TestIsJanusHead( surf, Concatenation(name," definition") );


	# Check incidence graph
	graph := ShallowCopy( IncidenceGraph(surf) );
	if not IsGraph(graph) then
		Print( "Failed: Incidence graph is not a graph.\n");
	fi;
	if OrderGraph(graph) <> 8 then
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

end;



################################################################################
################################################################################
#####							Test a janus head
################################################################################
################################################################################


##
##	Test whether a simplicial surface is a janus head.
##
TestIsJanusHead := function( surface, messageSurfaceOrigin )
	local conCom, janus, vertexNr, edgeNr, faceNr, euler, sortDeg, vertexSym,
		anomalyClassCount;

	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	vertexNr := 3;
	edgeNr := 3;
	faceNr := 2;

	if NrOfVertices(surface) <> vertexNr then
		Print( messageSurfaceOrigin );
		Print( " does not have " );
		Print( vertexNr );
		Print( " vertices.\n");
	fi;
	if NrOfEdges(surface) <> edgeNr then
		Print( messageSurfaceOrigin );
		Print( " does not have " );
		Print( edgeNr );
		Print( " edges.\n");
	fi;
	if NrOfFaces(surface) <> faceNr then
		Print( messageSurfaceOrigin );
		Print( " does not have " );
		Print( faceNr );
		Print( " faces.\n");
	fi;
	euler := vertexNr - edgeNr + faceNr;
	if EulerCharacteristic(surface) <> euler then
		Print( messageSurfaceOrigin );
		Print( " does not have Euler-Characteristic " );
		Print( euler );
		Print( ".\n");
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

	sortDeg := [2,2,2];
	if SortedDegrees(surface) <> sortDeg then
		Print( messageSurfaceOrigin );
		Print( " does not have degrees " );
		Print( sortDeg );
		Print( ".\n");
	fi;

	vertexSym := [,3];
	if VertexSymbol(surface) <> vertexSym then
		Print( messageSurfaceOrigin );
		Print( " does not have the vertex symbol " );
		Print( vertexSym );
		Print( ".\n");
	fi;

	anomalyClassCount := 1;
	if Length( FaceAnomalyClasses(surface) ) <> anomalyClassCount then
		Print( messageSurfaceOrigin );
		Print( " should have exactly " );
		Print( anomalyClassCount );
		Print( " face anomaly class(es).\n");
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
## and the representation of a simplicial surface
TestJanusHead := function()
	local surf, name;

	name := "Janus head";

	surf := SimplicialSurfaceByDownwardIncidence( 3, 3, 2, [[1,2],[2,3],[3,1]], 
		[[1,2,3],[1,2,3]] );

	TestIsJanusHead( surf, Concatenation(name," definition") );

end;



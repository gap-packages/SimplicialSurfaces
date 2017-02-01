################################################################################
################################################################################
#####					Test two connected triangles
################################################################################
################################################################################


TestIsomorphicTwoConTri := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( [1,2,3,4], 5, [1,4],
		[ [1,2],[1,3],[3,2],[4,3],[2,4] ],
		[ [1,2,3], , , [3,5,4] ] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to two connected triangles.\n");
	fi;
end;


##
##	Test whether a simplicial surface is isomorphic to two connected triangles.
##
TestIsTwoConnectedTriangles := function( surface, messageSurfaceOrigin )
	local conCom, vertexNr, edgeNr, faceNr, euler, sortDeg, 
		vertexSym, anomalyClassCount, snipp;

	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	vertexNr := 4;
	edgeNr := 5;
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


	# The twoConTri is an actual surface
	if not IsActualSurface( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must be an actual surface.\n" );
	fi;

	# The twoConTri is orientable
	if not IsOrientable( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must be orientable.\n");
	fi;

	# The twoConTri is connected
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

	sortDeg := [1,1,2,2];
	if SortedDegrees(surface) <> sortDeg then
		Print( messageSurfaceOrigin );
		Print( " does not have degrees " );
		Print( sortDeg );
		Print( ".\n");
	fi;

	vertexSym := [,2,2];
	if VertexSymbol(surface) <> vertexSym then
		Print( messageSurfaceOrigin );
		Print( " does not have the vertex symbol " );
		Print( vertexSym );
		Print( ".\n");
	fi;

	anomalyClassCount := 2;
	if Length( FaceAnomalyClasses(surface) ) <> anomalyClassCount then
		Print( messageSurfaceOrigin );
		Print( " should have exactly " );
		Print( anomalyClassCount );
		Print( " face anomaly class(es).\n");
	fi;

	snipp := SnippOffEars(surface);
	if NrOfVertices(snipp) > 0 or NrOfEdges(snipp) > 0 or NrOfFaces(snipp) > 0 then
		Print( messageSurfaceOrigin );
		Print( " should be destroyed by removal of ears.\n");
	fi;

	TestIsomorphicTwoConTri( surface, messageSurfaceOrigin);

end;



##########################################################################
## This method tests the functionality for the example of two connected 
## triangles and the representation of a simplicial surface
TestTwoConnectedTriangles := function()
	local surf, name;

	name := "TwoConTri";

	surf := SimplicialSurfaceByVerticesInFaces( 4,2, [[1,2,3],[3,2,4]] );

	TestIsTwoConnectedTriangles( surf, Concatenation(name," definition") );

end;



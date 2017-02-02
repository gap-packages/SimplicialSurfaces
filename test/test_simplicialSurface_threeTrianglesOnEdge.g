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
	local conCom, vertexNr, edgeNr, faceNr, euler, sortDeg, vertexSym,
		anomalyClassCount, snipp;

	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	vertexNr := 5;
	edgeNr := 7;
	faceNr := 3;

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


	# Three triangles that have exactly one edge in common are not an actual surface
	if IsActualSurface( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must not be an actual surface.\n" );
	fi;

	# Three triangles that have exactly one edge in common are connected
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

	sortDeg := [1,1,1,3,3];
	if SortedDegrees(surface) <> sortDeg then
		Print( messageSurfaceOrigin );
		Print( " does not have degrees " );
		Print( sortDeg );
		Print( ".\n");
	fi;

	vertexSym := [,3,,2];
	if VertexSymbol(surface) <> vertexSym then
		Print( messageSurfaceOrigin );
		Print( " does not have the vertex symbol " );
		Print( vertexSym );
		Print( ".\n");
	fi;

	anomalyClassCount := 3;
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



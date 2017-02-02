################################################################################
################################################################################
#####						Test an icosahedron
################################################################################
################################################################################


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
	local conCom, vertexNr, edgeNr, faceNr, euler, sortDeg, vertexSym,
		anomalyClassCount;

	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	vertexNr := 12;
	edgeNr := 30;
	faceNr := 20;

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


	# The icosahedron is an actual surface
	if not IsActualSurface( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must be an actual surface.\n" );
	fi;

	# The icosahedron is orientable
	if not IsOrientable( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must be orientable.\n");
	fi;

	# The icosahedron is connected
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

	sortDeg := List([1..12],i->5);
	if SortedDegrees(surface) <> sortDeg then
		Print( messageSurfaceOrigin );
		Print( " does not have degrees " );
		Print( sortDeg );
		Print( ".\n");
	fi;

	vertexSym := [,,,,12];
	if VertexSymbol(surface) <> vertexSym then
		Print( messageSurfaceOrigin );
		Print( " does not have the vertex symbol " );
		Print( vertexSym );
		Print( ".\n");
	fi;

	anomalyClassCount := 20;
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

	TestIsomorphicIcosahedron( surface, messageSurfaceOrigin );
	
end;


		

##########################################################################
## This method tests the functionality for the example of an icosahedron
## and the representation of a simplicial surface
TestIcosahedron := function()
	local surf, name;

	name := "Icosahedron";

	surf := SimplicialSurfaceByDownwardIncidence( 12,30, 20, 
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


	TestIsIcosahedron( surf, Concatenation(name," definition") );

	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );

end;



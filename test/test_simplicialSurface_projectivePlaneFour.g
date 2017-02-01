################################################################################
################################################################################
#####		Test a projective plane build from four triangles
################################################################################
################################################################################

##
##	Test whether a simplicial surface is a projective plane build from four 
##	triangles.
##
TestIsProjectivePlaneFour := function( surface, messageSurfaceOrigin )
	local conCom, vertexNr, edgeNr, faceNr, euler, sortDeg, vertexSym,
		anomalyClassCount;

	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	vertexNr := 3;
	edgeNr := 6;
	faceNr := 4;

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


	# The projective plane is an actual surface
	if not IsActualSurface( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must be an actual surface.\n" );
	fi;

	# The projective plane is not orientable
	if IsOrientable( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must not be orientable.\n");
	fi;

	# The projective plane is connected
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

	sortDeg := [4,4,4];
	if SortedDegrees(surface) <> sortDeg then
		Print( messageSurfaceOrigin );
		Print( " does not have degrees " );
		Print( sortDeg );
		Print( ".\n");
	fi;

	vertexSym := [,,,3];
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

	
	TestIsomorphicProjectivePlane( surface, messageSurfaceOrigin );
	
end;

TestIsomorphicProjectivePlane := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( [1..3],6,[1..4], 
		[[1,2],[2,3],[3,1],[1,2],[1,3],[2,3]],
		[[1,6,3],[3,2,4],[5,6,4],[5,1,2]]  );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to a projective plane.\n");
	fi;
end;

##########################################################################
## This method tests the functionality for the example of a projective plane
## with four triangles and the representation of a simplicial surface
TestProjectivePlaneFour := function()
	local surf, name;

	name := "Projective plane with four triangles";

	surf := SimplicialSurfaceByDownwardIncidence( 3,6,4, 
		[[1,2],[2,3],[3,1],[1,2],[1,3],[2,3]],
		[[1,6,3],[3,2,4],[5,6,4],[5,1,2]]  );

	TestIsProjectivePlaneFour( surf, Concatenation(name," definition") );

end;



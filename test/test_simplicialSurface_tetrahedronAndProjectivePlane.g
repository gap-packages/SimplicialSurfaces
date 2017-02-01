################################################################################
################################################################################
#####		Test the disjoint union of a tetrahedron and a projective plane
################################################################################
################################################################################


TestIsomorphicTetrahedronAndProjectivePlane := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( 7, 12, 8,
		[ [2,3],[5,2],[2,7],[5,3],[5,7],[7,3],
			[1,4],[4,6],[6,1],[1,4],[1,6],[4,6] ],
		[ [1,2,4], [1,3,6], [5,2,3], [6,5,4],
			[7,12,9],[9,8,10],[11,12,10],[11,7,8] ] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to a tetrahedron.\n");
	fi;
end;

##
##	Test whether a simplicial surface is the disjoint union of a tetrahedron 
##	and a projective plane.
##
TestIsTetrahedronAndProjectivePlane := function( surface, messageSurfaceOrigin )
	local conCom, vertexNr, edgeNr, faceNr, euler, sortDeg, vertexSym,
		anomalyClassCount;

	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	vertexNr := 7;
	edgeNr := 12;
	faceNr := 8;

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


	# This disjoint union is an actual surface
	if not IsActualSurface( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must be an actual surface.\n" );
	fi;

	# This disjoint union is not orientable
	if IsOrientable( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must not be orientable.\n");
	fi;

	# This disjoint union is not connected
	if IsConnected( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must not be connected.\n");
	fi;

	# TODO also test for different orders of function calls
	conCom := ConnectedComponentsAttributeOfSimplicialSurface( surface );
	if Length(conCom) <> 2 then
		Print( messageSurfaceOrigin );
		Print( " must have exactly two connected component.\n" );
	fi;
	if IsOrientable( conCom[1] ) then
		# has to be the tetrahedron
		IsIsomorphicTetrahedron( conCom[1], "Orientable component of tetrahedronAndProjectivePlane" );
		IsIsomorphicProjectivePlaneFour( conCom[2], "Non-orientable component of tetrahedronAndProjectivePlane" );
	else
		IsIsomorphicTetrahedron( conCom[2], "Orientable component of tetrahedronAndProjectivePlane" );
		IsIsomorphicProjectivePlaneFour( conCom[1], "Non-orientable component of tetrahedronAndProjectivePlane" );
	fi;

	sortDeg := [3,3,3,3,4,4,4];
	if SortedDegrees(surface) <> sortDeg then
		Print( messageSurfaceOrigin );
		Print( " does not have degrees " );
		Print( sortDeg );
		Print( ".\n");
	fi;

	vertexSym := [,,4,3];
	if VertexSymbol(surface) <> vertexSym then
		Print( messageSurfaceOrigin );
		Print( " does not have the vertex symbol " );
		Print( vertexSym );
		Print( ".\n");
	fi;

	anomalyClassCount := 5;
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

	
	TestIsomorphicTetrahedronAndProjectivePlane( surface, messageSurfaceOrigin );
	
end;



##########################################################################
## This method tests the functionality for the example of the disjoint union
## of a tetrahedron and a projective plane, as well as their representation as
## a simplicial surface
TestTetrahedronAndProjectivePlane := function()
	local surf, name;

	name := "Tetrahedron";

	surf := SimplicialSurfaceByDownwardIncidence( 7,12,8, 
		[ [1,2],[1,3],[3,2],[2,3],[3,1],[1,2],[6,7],[5,7],[4,7],[6,5],[4,5],[4,6] ],
		[ [1,2,4],[4,5,6],[1,3,5],[6,2,3],[7,8,10],[10,11,12],[8,9,11],[12,7,9] ] );

	TestIsTetrahedronAndProjectivePlane( surf, Concatenation(name," definition") );

end;



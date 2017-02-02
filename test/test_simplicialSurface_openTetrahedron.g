################################################################################
################################################################################
#####					Test an open tetrahedron
################################################################################
################################################################################



TestIsomorphicOpenTetrahedron := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( 4,6,3, 
		[[1,4],[2,1],[2,4],[2,3],[4,3],[1,3]], [[1,2,3],[1,6,5],[4,5,3]] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to an open tetrahedron.\n");
	fi;
end;

##
##	Test whether a simplicial surface is an open tetrahedron, that is a
##	tetrahedron that is missing one face
##
TestIsOpenTetrahedron := function( surface, messageSurfaceOrigin )
	local conCom, vertexNr, edgeNr, faceNr, euler, sortDeg, vertexSym,
		anomalyClassCount;

	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	vertexNr := 4;
	edgeNr := 6;
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


	# The tetrahedron is an actual surface
	if not IsActualSurface( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must be an actual surface.\n" );
	fi;

	# The tetrahedron is orientable
	if not IsOrientable( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must be orientable.\n");
	fi;

	# The tetrahedron is connected
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

	sortDeg := [2,2,2,3];
	if SortedDegrees(surface) <> sortDeg then
		Print( messageSurfaceOrigin );
		Print( " does not have degrees " );
		Print( sortDeg );
		Print( ".\n");
	fi;

	vertexSym := [,,4];
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

	if surface <> SnippOffEars(surface) then
		Print( messageSurfaceOrigin );
		Print( " should not be changed by removal of ears.\n");
	fi;

	
	TestIsomorphicOpenTetrahedron( surface, messageSurfaceOrigin );
	
end;



##########################################################################
## This method tests the functionality for the example of a tetrahedron
## and the representation of a simplicial surface
TestOpenTetrahedron := function()
	local surf, name;

	name := "Open Tetrahedron";

	surf := SimplicialSurfaceByVerticesInFaces( 4,3, [[1,2,3],[1,3,4],[3,2,4]] );

	TestIsOpenTetrahedron( surf, Concatenation(name," definition") );
	
	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );

end;


##
##	Test whether a wild simplicial surface is an open tetrahedron.
##
TestIsWildOpenTetrahedron := function( surface, messageSurfaceOrigin )
	local vertexGroup, invGroup;

	# Check if it fulfills the criteria of an open tetrahedron (necessary to check
	# since some methods might have been overwritten).
	TestIsOpenTetrahedron( surface, messageSurfaceOrigin );
	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	#TODO how to check?

	vertexGroup := VertexGroup(surf);
	vertexGroup := vertexGroup[1] / vertexGroup[2];
	if not IsDihedralGroup( vertexGroup ) or Size( vertexGroup ) <> 4 then
		Print( messageSurfaceOrigin );
		Print( " should have vertex group V_4.\n");
	fi;

	# Check group generated from the involutions
	invGroup := GroupOfWildSimplicialSurface( surface );
	if not IsDihedralGroup( invGroup ) or Size( invGroup ) <> 6 then
		Print( messageSurfaceOrigin );
		Print( " should have generated group D_6.\n");
	fi;
end;


##########################################################################
## This method tests the functionality for the example of an open tetrahedron
## and the representation as a wild simplicial surface
TestWildOpenTetrahedron := function()
	local surf, name, sig1, sig2, sig3, mrType, gens;

	name := "Open tetrahedron (wild)";

	sig1 := (1,2);
	sig2 := (2,3);
	sig3 := (1,3);
	mrType := AllEdgesOfSameType( 3, 2);

	gens := [sig1,sig2,sig3];


	# First try to extend a simplicial surface
	surf := SimplicialSurfaceByVerticesInFaces( 4,3, [[1,2,3],[1,3,4],[3,2,4]] );
	surf := WildSimplicialSurfaceExtension( surf, gens );

	TestIsWildOpenTetrahedron( surf, Concatenation(name," by extension") );


	# Next we try to define it from scratch
	surf := WildSimplicialSurface( gens, mrType );

	TestIsWildOpenTetrahedron( surf, Concatenation(name," by mrType") );
	
end;


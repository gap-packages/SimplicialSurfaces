################################################################################
################################################################################
#####							Test a janus head
################################################################################
################################################################################



TestIsomorphicJanus := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( [2,3,5], [3,6,9], [3,7],
		[ , , [2,3], , , [3,5], , , [2,5] ],
		[ , , [3,6,9], , , , [6,3,9] ] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to a janus head.\n");
	fi;
end;

##
##	Test whether a simplicial surface is a janus head.
##
TestIsJanusHead := function( surface, messageSurfaceOrigin )
	local conCom, vertexNr, edgeNr, faceNr, euler, sortDeg, vertexSym,
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

	
	TestIsomorphicJanus( surface, messageSurfaceOrigin );
	
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

	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );
end;



##
##	Test whether a wild simplicial surface is a janus head.
##
TestIsWildJanusHead := function( surface, messageSurfaceOrigin )
	local vertexGroup, invGroup;

	# Check if it fulfills the criteria of a janus head (necessary to check
	# since some methods might have been overwritten).
	TestIsJanusHead( surface, messageSurfaceOrigin );
	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	#TODO how to check?

	vertexGroup := VertexGroup(surface);
	vertexGroup := vertexGroup[1] / vertexGroup[2];
	if Size( vertexGroup ) <> 2 then
		Print( messageSurfaceOrigin );
		Print( " should have vertex group C_2.\n");
	fi;

	# Check group generated from the involutions
	invGroup := GroupOfWildSimplicialSurface( surface );
	if Size( invGroup ) <> 2 then
		Print( messageSurfaceOrigin );
		Print( " should have generated group C_2.\n");
	fi;

end;


##########################################################################
## This method tests the functionality for the example of a janus head
## and the representation as a wild simplicial surface
TestWildJanusHead := function()
	local surf, name, sig1, sig2, sig3, mrType, gens;

	name := "Janus head (wild)";

	sig1 := (1,2);
	sig2 := (1,2);
	sig3 := (1,2);
	mrType := AllEdgesOfSameType( 2, 1);

	gens := [sig1,sig2,sig3];


	# First try to extend a simplicial surface
	surf := SimplicialSurfaceByDownwardIncidence( 3, 3, 2, [[1,2],[2,3],[3,1]], 
		[[1,2,3],[1,2,3]] );
	surf := WildSimplicialSurfaceExtension( surf, gens );

	TestIsWildJanusHead( surf, Concatenation(name," by extension") );


	# Next we try to define it from scratch
	surf := WildSimplicialSurface( gens, mrType );

	TestIsWildJanusHead( surf, Concatenation(name," by mrType") );
	
end;




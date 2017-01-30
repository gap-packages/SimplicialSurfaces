################################################################################
################################################################################
#####							Test a janus head
################################################################################
################################################################################


##
##	Test whether a simplicial surface is a janus head.
##
TestIsJanusHead := function( surface, messageSurfaceOrigin )
	local conCom;

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
	
end;


################################################################################
## This method tests the functionality for the example of a janus head
## and the representation of a wild coloured simplicial surface
TestJanusHeadWild := function()
	local sig1,sig2,sig3, mrType, surfaces, surf, VertexGroup, generic,
		consistency, name;

	name := "Janus head";

	sig1 := (1,2);
	sig2 := (1,2);
	sig3 := (1,2);
	mrType := AllEdgesOfSameType( 2, 1);

	surfaces := AllWildSimplicialSurfaces( sig1, sig2, sig3,mrType  );
	if Length(surfaces) <> 1 then
		Print( "Failed: ");
		Print( name );
		Print( " can't be defined by wild coloring.\n" );
	fi;

	surf := surfaces[1];

	# Test the elementary properties
	if NrOfVerticesOfWildSimplicialSurface(surf) <> 3 then
		Print( "Failed: ");
		Print(name);
		Print( " has wrong number of vertices.\n" );
	fi;

	if NrOfEdgesOfWildSimplicialSurface(surf) <> 3 then
		Print( "Failed: ");
		Print(name);
		Print( " has wrong number of edges.\n" );
	fi;

	if NrOfFacesOfWildSimplicialSurface(surf) <> 2 then
		Print( "Failed: ");
		Print(name);
		Print( " has wrong number of faces.\n" );
	fi;

	if MrTypeOfWildSimplicialSurface(surf) <> mrType then
		Print( "Failed: ");
		Print(name);
		Print( " has wrong number mr-type.\n" );
	fi;

	# Test some advanced properties
	if EulerCharacteristic(surf) <> 2 then
		Print( "Failed: ");
		Print(name);
		Print( " has wrong number Euler-Characteristic.\n" );
	fi;

	VertexGroup := VertexGroupOfWildSimplicialSurface(surf);
	VertexGroup := VertexGroup[1] / VertexGroup[2];
	if Size( VertexGroup ) <> 2 then
		Print( "Failed: ");
		Print(name);
		Print( " vertex group is not C_2.\n");
    else
		Print( "  Passed: ");
		Print(name);
		Print( " has correct vertex group C_2.\n");
	fi;

	if DegreesOfWildSimplicialSurface(surf) <> [2,2,2] then
		Print( "Failed: ");
		Print(name);
		Print( " vertex degrees are incorrect.\n");
    else
		Print( "  Passed: ");
		Print(name);
		Print( " has correct vertex degrees.\n");
	fi;

	if not IsConnectedWildSimplicialSurface(surf) then
		Print( "Failed: ");
		Print(name);
		Print( " should be connected.\n" );
    else
		Print( "  Passed: ");
		Print(name);
		Print( " is connected.\n" );
	fi;

	if not IsOrientableWildSimplicialSurface(surf) then
		Print( "Failed: ");
		Print(name);
		Print( " should be orientable.\n" );
    else
		Print( "  Passed: ");
		Print(name);
		Print( " is orientable.\n" );
	fi;

	if  surf <> SnippOffEars(surf)  then
		Print( "Failed: ");
		Print(name);
		Print( " should not have ears.\n");
    else
		Print( "  Passed: ");
		Print( name );
		Print( " has no ears.\n");
	fi;

end;

##########################################################################
## This method tests the functionality for the example of a tetrahedron
## and the representation of a generic simplicial surface
TestJanusHeadGeneric := function()
	local surf, newSurf, graph, name, anomalies;

	name := "Janus head";

	surf := GenericSimplicialSurface( rec( 
		nrOfVertices := 3,
		nrOfEdges := 3,
		nrOfFaces := 2,
		edges := [[1,2],[2,3],[3,1]], 
		faces := [[1,2,3],[1,2,3]] ) );

	TestGenericConsistency( surf, Concatenation(name," definition (generic)") );

	# Test the elementary properties
	if NrOfVerticesOfGenericSimplicialSurface(surf) <> 3 then
		Print( "Failed: ");
		Print( name );
		Print( " has wrong number of vertices.\n" );
	fi;

	if NrOfEdgesOfGenericSimplicialSurface(surf) <> 3 then
		Print( "Failed: ");
		Print( name );
		Print( " has wrong number of edges.\n" );
	fi;

	if NrOfFacesOfGenericSimplicialSurface(surf) <> 2 then
		Print( "Failed: ");
		Print( name );
		Print( " has wrong number of faces.\n" );
	fi;

	# Test some advanced properties
	if EulerCharacteristic(surf) <> 2 then
		Print( "Failed: ");
		Print( name);
		Print( " has wrong Euler-Characteristic.\n" );
	fi;

	anomalies := FaceAnomalyClassesOfGenericSimplicialSurface( surf );
	if Length( anomalies ) <> 1	or Length( anomalies[1] ) <> 2 then
		Print( "Failed: ");
		Print( name );
		Print( " should have a face-anomaly.\n");
	fi;

	if UnsortedDegreesOfGenericSimplicialSurface(surf) <> [2,2,2] or 
		SortedDegreesOfGenericSimplicialSurface(surf) <> [2,2,2] then
		Print( "Failed: ");
		Print(name);
		Print( " vertex degrees are incorrect.\n");
    else
		Print( "  Passed: ");
		Print(name);
		Print( " has correct vertex degrees.\n");
	fi;

	if not IsConnectedGenericSimplicialSurface(surf) then
		Print( "Failed: ");
		Print(name);
		Print( " should be connected.\n" );
    else
		Print( "  Passed: ");
		Print(name);
		Print( " is connected.\n" );
	fi;

	if not IsOrientableGenericSimplicialSurface(surf) then
		Print( "Failed: ");
		Print( name );
		Print( " should be orientable.\n" );
    else
		Print( "	Passed: ");
		Print( name );
		Print( " is orientable.\n" );
	fi;

	if  surf <> SnippOffEarsOfGenericSimplicialSurface(surf)  then
		Print( "Failed: ");
		Print(name);
		Print( " should not have ears.\n");
    else
		Print( "  Passed: ");
		Print( name );
		Print( " has no ears.\n");
	fi;

	# Check incidence graph
	graph := IncidenceGraphOfGenericSimplicialSurface(surf);
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


##########################################################################
## This method tests the functionality for the example of a janus head
## and the conversion between different representations
TestJanusHeadConversion := function()
	local generic, faceToGeneric, wildToGeneric, wild, genToFaceToGen,
		genToWildToGen, genericToFace, genericToWild, face, faceToWildToGen,
		faceToWild, name;

	name := "janus head";

	## Test all converters to generic
	generic := GenericSimplicialSurface( rec( 
		nrOfVertices := 3,
		nrOfEdges := 3,
		nrOfFaces := 2,
		edges := [[1,2],[2,3],[3,1]], 
		faces := [[1,2,3],[1,2,3]] ) );

	wild := AllWildSimplicialSurfaces( 
		(1,2), 
		(1,2), 
		(1,2),
		AllEdgesOfSameType(2, 1) )[1];


	wildToGeneric := GenericSimplicialSurfaceFromWildSimplicialSurface( wild );
	if not IsIsomorphicGenericSimplicialSurface( generic, wildToGeneric ) then
		Print( "Failed: Conversion wild to generic of ");
		Print( name );
		Print( " failed.\n" );
	else
		Print( "	Passed: Conversion wild to generic of ");
		Print( name );
		Print( ".\n" );
	fi;

## Test the generic to wild converter
	genericToWild := WildSimplicialSurfacesFromGenericSurface( generic );
	if Length( genericToWild ) <> 1 then
		Print( "Failed: Conversion generic to wild of ");
		Print( name );
		Print( " has wrong number of possibilities.\n" );
	fi;
	genToWildToGen := GenericSimplicialSurfaceFromWildSimplicialSurface( genericToWild[1] );
	if not IsIsomorphicGenericSimplicialSurface( generic, genToWildToGen ) then
		Print( "Failed: Conversion generic to wild of ");
		Print( name );
		Print( " failed.\n" );
	else
		Print( "	Passed: Conversion generic to wild of ");
		Print( name );
		Print( ".\n" );
	fi;

end;


# Test everything
TestJanusHead := function()
	TestJanusHeadWild();
	TestJanusHeadGeneric();
	TestJanusHeadConversion();
end;

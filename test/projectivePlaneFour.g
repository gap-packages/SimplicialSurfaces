################################################################################
################################################################################
#####		Test a projective plane build from four triangles
################################################################################
################################################################################

################################################################################
## This method tests the functionality for the example of a projective plane
## and the representation of a wild coloured simplicial surface
TestProjectivePlaneFourWild := function()
	local sig1,sig2,sig3, mrType, surfaces, surf, VertexGroup, generic,
		consistency, name;

	name := "Projective plane (4)";

	sig1 := (1,4)(2,3);
	sig2 := (1,3)(2,4);
	sig3 := (1,2)(4,3);
	mrType := AllEdgesOfSameType( 4, 1);

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

	if NrOfEdgesOfWildSimplicialSurface(surf) <> 6 then
		Print( "Failed: ");
		Print(name);
		Print( " has wrong number of edges.\n" );
	fi;

	if NrOfFacesOfWildSimplicialSurface(surf) <> 4 then
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
	if EulerCharacteristic(surf) <> 1 then
		Print( "Failed: ");
		Print(name);
		Print( " has wrong number Euler-Characteristic.\n" );
	fi;

	VertexGroup := VertexGroupOfWildSimplicialSurface(surf);
	VertexGroup := VertexGroup[1] / VertexGroup[2];
	if Size( VertexGroup ) <> 8 or Exponent( VertexGroup ) <> 2 then
		Print( "Failed: ");
		Print(name);
		Print( " vertex group is not C_2^3.\n");
    else
		Print( "  Passed: ");
		Print(name);
		Print( " has correct vertex group C_2^3.\n");
	fi;

	if DegreesOfWildSimplicialSurface(surf) <> [4,4,4] then
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

	if IsOrientableWildSimplicialSurface(surf) then
		Print( "Failed: ");
		Print( name );
		Print( " should not be orientable.\n" );
    else
		Print( "  Passed: ");
		Print( name );
		Print( " is not orientable.\n" );
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
## This method tests the functionality for the example of a projective plane
## and the representation of a generic simplicial surface
TestProjectivePlaneFourGeneric := function()
	local surf, newSurf, graph, name, anomalies;

	name := "Projective plane (4)";

	surf := GenericSimplicialSurface( rec( 
		nrOfVertices := 3,
		nrOfEdges := 6,
		nrOfFaces := 4,
		edges := [[1,2],[2,3],[3,1],[1,2],[1,3],[2,3]], 
		faces := [[1,6,3],[3,2,4],[5,6,4],[5,1,2]] ) );

	TestGenericConsistency( surf, Concatenation( name, " definition (generic)") );

	# Test the elementary properties
	if NrOfVerticesOfGenericSimplicialSurface(surf) <> 3 then
		Print( "Failed: ");
		Print( name );
		Print( " has wrong number of vertices.\n" );
	fi;

	if NrOfEdgesOfGenericSimplicialSurface(surf) <> 6 then
		Print( "Failed: ");
		Print( name );
		Print( " has wrong number of edges.\n" );
	fi;

	if NrOfFacesOfGenericSimplicialSurface(surf) <> 4 then
		Print( "Failed: ");
		Print( name );
		Print( " has wrong number of faces.\n" );
	fi;

	# Test some advanced properties
	if EulerCharacteristic(surf) <> 1 then
		Print( "Failed: ");
		Print( name);
		Print( " has wrong Euler-Characteristic.\n" );
	fi;

	anomalies := FaceAnomalyClassesOfGenericSimplicialSurface( surf );
	if Length( anomalies ) <> 1	or Length( anomalies[1] ) <> 4 then
		Print( "Failed: ");
		Print( name );
		Print( " should have a face-anomaly.\n");
	fi;

	if UnsortedDegreesOfGenericSimplicialSurface(surf) <> [4,4,4] or 
		SortedDegreesOfGenericSimplicialSurface(surf) <> [4,4,4] then
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

	if IsOrientableGenericSimplicialSurface(surf) then
		Print( "Failed: ");
		Print( name );
		Print( " should not be orientable.\n" );
    else
		Print( "  Passed: ");
		Print( name );
		Print( " is not orientable.\n" );
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
	if OrderGraph(graph) <> 13 then
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
## This method tests the functionality for the example of a projective plane
## and the conversion between different representations
TestProjectivePlaneFourConversion := function()
	local generic, faceToGeneric, wildToGeneric, wild, genToFaceToGen,
		genToWildToGen, genericToFace, genericToWild, face, faceToWildToGen,
		faceToWild, name;

	name := "projective plane (4)";

	## Test all converters to generic
	generic := GenericSimplicialSurface( rec( 
		nrOfVertices := 3,
		nrOfEdges := 6,
		nrOfFaces := 4,
		edges := [[1,2],[2,3],[3,1],[1,2],[1,3],[2,3]], 
		faces := [[1,6,3],[3,2,4],[5,6,4],[5,1,2]] ) );

	wild := AllWildSimplicialSurfaces( 
		(1,4)(2,3),
		(1,3)(2,4),
		(1,2)(4,3),
		AllEdgesOfSameType( 4, 1) )[1];

	## Test the wild to generic converter
	wildToGeneric := GenericSimplicialSurfaceFromWildSimplicialSurface( wild );
	if not IsIsomorphicGenericSimplicialSurface( generic, wildToGeneric ) then
		Print( "Failed: Conversion wild to generic of ");
		Print( name );
		Print( " failed.\n" );
	else
		Print( "  Passed: Conversion wild to generic of ");
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
		Print( "  Passed: Conversion generic to wild of ");
		Print( name );
		Print( ".\n" );
	fi;
end;


# Test everything
TestProjectivePlaneFour := function()
	TestProjectivePlaneFourWild();
	TestProjectivePlaneFourGeneric();
	TestProjectivePlaneFourConversion();
end;

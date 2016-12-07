################################################################################
################################################################################
#####							Test a tetrahedron
################################################################################
################################################################################

################################################################################
## This method tests the functionality for the example of a tetrahedron
## and the representation of a wild coloured simplicial surface
TestTetrahedronWild := function()
	local sig1,sig2,sig3, mrType, surfaces, surf, VertexGroup, generic,
		consistency, name;

	name := "Tetrahedron";

	sig1 := (1,3)(2,4);
	sig2 := (1,2)(3,4);
	sig3 := (1,4)(2,3);
	mrType := AllEdgesOfSameType( 4, 2);

	surfaces := AllWildSimplicialSurfaces( sig1, sig2, sig3,mrType  );
	if Length(surfaces) <> 1 then
		Print( "Failed: ");
		Print( name );
		Print( " can't be defined by wild coloring.\n" );
	fi;

	surf := surfaces[1];

	# Test the elementary properties
	if NrOfVerticesOfWildSimplicialSurface(surf) <> 4 then
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
	if EulerCharacteristic(surf) <> 2 then
		Print( "Failed: ");
		Print(name);
		Print( " has wrong number Euler-Characteristic.\n" );
	fi;

	VertexGroup := VertexGroupOfWildSimplicialSurface(surf);
	VertexGroup := VertexGroup[1] / VertexGroup[2];
	if not IsDihedralGroup( VertexGroup ) or Size( VertexGroup ) <> 4 then
		Print( "Failed: ");
		Print(name);
		Print( " vertex group is not V_4.\n");
    else
		Print( "  Passed: ");
		Print(name);
		Print( " has correct vertex group V_4.\n");
	fi;

	if DegreesOfWildSimplicialSurface(surf) <> [3,3,3,3] then
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
		Print( name );
		Print( " should be orientable.\n" );
    else
		Print( "	Passed: ");
		Print( name );
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
TestTetrahedronGeneric := function()
	local surf, newSurf, graph, name;

	name := "Tetrahedron";

	surf := GenericSimplicialSurface( rec( 
		nrOfVertices := 4,
		nrOfEdges := 6,
		nrOfFaces := 4,
		edges := [[1,2],[2,3],[3,1],[1,4],[4,2],[4,3]], 
		faces := [[1,2,3],[5,1,4],[3,6,4],[5,6,2]] ) );

	TestGenericConsistency( surf, Concatenation( name, " definition (generic)") );

	# Test the elementary properties
	if NrOfVerticesOfGenericSimplicialSurface(surf) <> 4 then
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
	if EulerCharacteristic(surf) <> 2 then
		Print( "Failed: ");
		Print( name);
		Print( " has wrong Euler-Characteristic.\n" );
	fi;

	if Length( FaceAnomalyClassesOfGenericSimplicialSurface( surf ) ) <> 4 then
		Print( "Failed: ");
		Print( name );
		Print( " should not have a face-anomaly.\n");
	fi;

	if UnsortedDegreesOfGenericSimplicialSurface(surf) <> [3,3,3,3] or 
		SortedDegreesOfGenericSimplicialSurface(surf) <> [3,3,3,3] then
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
	if OrderGraph(graph) <> 14 then
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



	newSurf := RemoveVertexOfGenericSimplicialSurface( surf, 1);
	TestGenericConsistency( newSurf, 
		Concatenation( name, " after removel of one vertex"));
	if NrOfVerticesOfGenericSimplicialSurface(newSurf) <> 3 then
		Print( "Failed: " );
		Print( name );
		Print(" has wrong number of vertices after removing one vertex.\n" );
	fi;
	if NrOfEdgesOfGenericSimplicialSurface(newSurf) <> 3 then
		Print( "Failed: " );
		Print( name );
		Print(" has wrong number of edges after removing one vertex.\n" );
	fi;
	if NrOfFacesOfGenericSimplicialSurface(newSurf) <> 1 then
		Print( "Failed: " );
		Print( name );
		Print(" has wrong number of faces after removing one vertex.\n" );
	fi;

end;


##########################################################################
## This method tests the functionality for the example of a tetrahedron
## and the conversion between different representations
TestTetrahedronConversion := function()
	local generic, faceToGeneric, wildToGeneric, wild, genToFaceToGen,
		genToWildToGen, genericToFace, genericToWild, face, faceToWildToGen,
		faceToWild, name;

	name := "tetrahedron";

	## Test all converters to generic
	generic := GenericSimplicialSurface( rec( 
		nrOfVertices := 4,
		nrOfEdges := 6,
		nrOfFaces := 4,
		edges := [[1,2],[2,3],[3,1],[1,4],[4,2],[4,3]], 
		faces := [[1,2,3],[5,1,4],[3,6,4],[5,6,2]] ) );

	wild := AllWildSimplicialSurfaces( 
		(1,3)(2,4), 
		(1,2)(3,4), 
		(1,4)(2,3),
		AllEdgesOfSameType(4, 2) )[1];

	face := [ [1,2,3,1], [2,3,4,2], [3,1,4,3], [1,4,2,1] ];

	faceToGeneric := GenericSimplicialSurfaceFromFaceVertexPath( face );
	if not IsIsomorphicGenericSimplicialSurface( generic, faceToGeneric ) then
		Print( "Failed: Conversion facePath to generic of ");
		Print( name );
		Print( " failed.\n" );
	else
		Print( "	Passed: Conversion facePath to generic of ");
		Print( name );
		Print( ".\n" );
	fi;

	## Test the wild to generic converter
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


	## Test the generic to face converter
	genericToFace := FaceVertexPathFromGenericSimplicialSurface( generic );
	genToFaceToGen := GenericSimplicialSurfaceFromFaceVertexPath( genericToFace );
	if not IsIsomorphicGenericSimplicialSurface( generic, genToFaceToGen ) then
		Print( "Failed: Conversion generic to facePath of ");
		Print( name );
		Print( " failed.\n" );
	else
		Print( "	Passed: Conversion generic to facePath of ");
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

	## Test the face to wild converter
	faceToWild := WildSimplicialSurfacesFromFacePath( face );
	if Length( faceToWild ) <> 1 then
		Print( "Failed: Conversion face to wild of ");
		Print( name );
		Print( " has wrong number of possibilities." );
	fi;
	faceToWildToGen := GenericSimplicialSurfaceFromWildSimplicialSurface( faceToWild[1] );
	if not IsIsomorphicGenericSimplicialSurface( faceToGeneric, faceToWildToGen ) then
		Print( "Failed: Conversion facePath to wild of ");
		Print( name );
		Print( " failed.\n" );
	else
		Print( "	Passed: Conversion facePath to wild of ");
		Print( name );
		Print( ".\n" );
	fi;
end;


# Test everything
TestTetrahedron := function()
	TestTetrahedronWild();
	TestTetrahedronGeneric();
	TestTetrahedronConversion();
end;

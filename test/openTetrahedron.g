################################################################################
################################################################################
#####				Test an open tetrahedron
################################################################################
################################################################################

# This method tests the functionality for the example of a tetrahedron that
# is missing one face
TestOpenTetrahedronWild := function()
	local sig1,sig2,sig3, mrType, surfaces, surf, VertexGroup, Degrees, generic;

	sig1 := (1,2);
	sig2 := (2,3);
	sig3 := (1,3);
	mrType := AllEdgesOfSameType( 3, 2);

	surfaces := AllWildSimplicialSurfaces( sig1, sig2, sig3,mrType  );
	if Length(surfaces) <> 1 then
		Print( "Failed: Open Tetrahedron can't be defined.\n" );
	fi;

	surf := surfaces[1];

	# Test the elementary properties
	if NrOfVerticesOfWildSimplicialSurface(surf) <> 4 then
		Print( "Failed: Open Tetrahedron has wrong number of vertices.\n" );
	fi;

	if NrOfEdgesOfWildSimplicialSurface(surf) <> 6 then
		Print( "Failed: Open Tetrahedron has wrong number of edges.\n" );
	fi;

	if NrOfFacesOfWildSimplicialSurface(surf) <> 3 then
		Print( "Failed: Open Tetrahedron has wrong number of faces.\n" );
	fi;

	if MrTypeOfWildSimplicialSurface(surf) <> mrType then
		Print( "Failed: Open Tetrahedron has wrong mr-type.\n" );
	fi;

	# Test some advanced properties
	if EulerCharacteristic(surf) <> 1 then
		Print( "Failed: Open Tetrahedron has wrong Euler-Characteristic.\n" );
	fi;

	VertexGroup := VertexGroupOfWildSimplicialSurface(surf);
	VertexGroup := VertexGroup[1] / VertexGroup[2];
	if not IsDihedralGroup( VertexGroup ) or Size( VertexGroup ) <> 4 then
		Print( "Failed: Open Tetrahedron vertex group is not V_4.\n");
    else
		Print( "  Passed: Open Tetrahedron has correct vertex group V_4.\n");
	fi;

	Degrees := DegreesOfWildSimplicialSurface(surf);
	if Set(Degrees) <> [2,3] or Length(Degrees) <> 4 or 
		Length( Filtered( Degrees, i->i=2) ) <> 3 then
		Print( "Failed: Open Tetrahedron vertex degrees are incorrect.\n");
    else
		Print( "  Passed: Open Tetrahedron has correct vertex degrees.\n");
	fi;

	if not IsConnectedWildSimplicialSurface(surf) then
		Print( "Failed: Open Tetrahedron should be connected.\n" );
    else
		Print( "  Passed: Open Tetrahedron is connected.\n" );
	fi;

	if not IsOrientableWildSimplicialSurface(surf) then
		Print( "Failed: Open Tetrahedron should be orientable.\n" );
    else
		Print( "  Passed: Open Tetrahedron is orientable.\n" );
	fi;

	if  surf <> SnippOffEars(surf)  then
		Print( "Failed: Open Tetrahedron should not have ears.\n");
    else
		Print( "  Passed: Open Tetrahedron has no ears.\n");
	fi;

end;

TestOpenTetrahedronGeneric := function()
		local surf, consistency, newSurf, graph;

	surf := GenericSimplicialSurface( rec( 
		nrOfVertices := 4,
		nrOfEdges := 6,
		nrOfFaces := 3,
		edges := [[1,4],[2,1],[2,4],[2,3],[4,3],[1,3]], 
		faces := [[1,2,3],[1,6,5],[4,5,3]] ) );

	TestGenericConsistency( surf, "Open Tetrahedron definition (generic)");

	# Test the elementary properties
	if NrOfVerticesOfGenericSimplicialSurface(surf) <> 4 then
		Print( "Failed: Open Tetrahedron has wrong number of vertices.\n" );
	fi;

	if NrOfEdgesOfGenericSimplicialSurface(surf) <> 6 then
		Print( "Failed: Open Tetrahedron has wrong number of edges.\n" );
	fi;

	if NrOfFacesOfGenericSimplicialSurface(surf) <> 3 then
		Print( "Failed: Open Tetrahedron has wrong number of faces.\n" );
	fi;

	# Test some advanced properties
	if EulerCharacteristic(surf) <> 1 then
		Print( "Open Tetrahedron has wrong Euler-Characteristic.\n" );
	fi;

	if Length( FaceAnomalyClassesOfGenericSimplicialSurface( surf ) ) <> 3 then
		Print( "Failed: ");
		Print( name );
		Print( " should not have a face-anomaly.\n");
	fi;

	if UnsortedDegreesOfGenericSimplicialSurface(surf) <> [2,2,2,3] or 
		SortedDegreesOfGenericSimplicialSurface(surf) <> [2,2,2,3] then
		Print( "Failed: Open Tetrahedron vertex degrees are incorrect.\n");
    else
		Print( "  Passed: Open Tetrahedron has correct vertex degrees.\n");
	fi;

	if not IsConnectedGenericSimplicialSurface(surf) then
		Print( "Failed: Open Tetrahedron should be connected.\n" );
    else
		Print( "  Passed: Open Tetrahedron is connected.\n" );
	fi;

	if not IsOrientableGenericSimplicialSurface(surf) then
		Print( "Failed: Open Tetrahedron should be orientable.\n" );
    else
		Print( "  Passed: Open Tetrahedron is orientable.\n" );
	fi;

	if  surf <> SnippOffEarsOfGenericSimplicialSurface(surf)  then
		Print( "Failed: Open Tetrahedron should not have ears.\n");
    else
		Print( "  Passed: Open Tetrahedron has no ears.\n");
	fi;

	# Check incidence graph
	graph := IncidenceGraphOfGenericSimplicialSurface(surf);
	if not IsGraph(graph) then
		Print( "Failed: Incidence graph of open tetrahedron is not a graph.\n");
	fi;
	if OrderGraph(graph) <> 13 then
		Print( "Failed: Number of vertices in incidence graphof open tetrahedron  is wrong.\n");
	fi;
	if IsLoopy(graph) then
		Print( "Failed: Incidence graph of open tetrahedron should not be loopy.\n");
	fi;
	if not IsSimpleGraph(graph) then
		Print( "Failed: Incidence graph of open tetrahedron is not simple.\n");
	fi;
	if not IsConnectedGraph(graph) then
		Print( "Failed: Incidence graph of open tetrahedron is not connected.\n");
	fi;
	if not IsBipartite(graph) then
		Print( "Failed: Incidence graph of open tetrahedron is not bipartite.\n");
	fi;



	newSurf := RemoveVertexOfGenericSimplicialSurface( surf, 1);	# Leave one triangle
	TestGenericConsistency( newSurf, "Open Tetrahedron after removel of one border vertex");
	if NrOfVerticesOfGenericSimplicialSurface(newSurf) <> 3 then
		Print( "Failed: Open Tetrahedron has wrong number of vertices after removing one border vertex.\n" );
	fi;
	if NrOfEdgesOfGenericSimplicialSurface(newSurf) <> 3 then
		Print( "Failed: Open Tetrahedron has wrong number of edges after removing one border vertex.\n" );
	fi;
	if NrOfFacesOfGenericSimplicialSurface(newSurf) <> 1 then
		Print( "Failed: Open Tetrahedron has wrong number of faces after removing one border vertex.\n" );
	fi;

	newSurf := RemoveVertexOfGenericSimplicialSurface( surf, 4);	# Leave three edges
	TestGenericConsistency( newSurf, "Open Tetrahedron after removel of one central vertex");
	if NrOfVerticesOfGenericSimplicialSurface(newSurf) <> 3 then
		Print( "Failed: Open Tetrahedron has wrong number of vertices after removing one central vertex.\n" );
	fi;
	if NrOfEdgesOfGenericSimplicialSurface(newSurf) <> 3 then
		Print( "Failed: Open Tetrahedron has wrong number of edges after removing one central vertex.\n" );
	fi;
	if NrOfFacesOfGenericSimplicialSurface(newSurf) <> 0 then
		Print( "Failed: Open Tetrahedron has wrong number of faces after removing one central vertex.\n" );
	fi;

end;

TestOpenTetrahedronConversion := function()
	local generic, faceToGeneric, wildToGeneric, wild, genToFaceToGen,
		genToWildToGen, genericToFace, genericToWild, face, faceToWildToGen,
		faceToWild;

	## Test all converters to generic
	generic := GenericSimplicialSurface( rec( 
		nrOfVertices := 4,
		nrOfEdges := 6,
		nrOfFaces := 3,
		edges := [[1,4],[2,1],[2,4],[2,3],[4,3],[1,3]], 
		faces := [[1,2,3],[1,6,5],[4,5,3]] ) );

	wild := AllWildSimplicialSurfaces( 
		(1,2), 
		(2,3), 
		(1,3),
		AllEdgesOfSameType(3, 2) )[1];

	face := [ [1,2,3,1], [2,3,4,2], [3,1,4,3] ];

	faceToGeneric := GenericSimplicialSurfaceFromFaceVertexPath( face );
	if not IsIsomorphicGenericSimplicialSurface( generic, faceToGeneric ) then
		Print( "Failed: Conversion facePath to generic of open tetrahedron failed.\n" );
	else
		Print( "	Passed: Conversion facePath to generic of open tetrahedron.\n" );
	fi;

	wildToGeneric := GenericSimplicialSurfaceFromWildSimplicialSurface( wild );
	if not IsIsomorphicGenericSimplicialSurface( generic, wildToGeneric ) then
		Print( "Failed: Conversion wild to generic of open tetrahedron failed.\n" );
	else
		Print( "	Passed: Conversion wild to generic of open tetrahedron.\n" );
	fi;


	## Test the generic to face converter
	genericToFace := FaceVertexPathFromGenericSimplicialSurface( generic );
	genToFaceToGen := GenericSimplicialSurfaceFromFaceVertexPath( genericToFace );
	if not IsIsomorphicGenericSimplicialSurface( generic, genToFaceToGen ) then
		Print( "Failed: Conversion generic to facePath of open tetrahedron failed.\n" );
	else
		Print( "	Passed: Conversion generic to facePath of open tetrahedron.\n" );
	fi;

	## Test the generic to face converter
	genericToWild := WildSimplicialSurfacesFromGenericSurface( generic );
	if Length( genericToWild ) <> 1 then
		Print( "Failed: Conversion generic to wild of open tetrahedron has wrong number of possibilities.\n" );
	fi;
	genToWildToGen := GenericSimplicialSurfaceFromWildSimplicialSurface( genericToWild[1] );
	if not IsIsomorphicGenericSimplicialSurface( generic, genToWildToGen ) then
		Print( "Failed: Conversion generic to wild of open tetrahedron failed.\n" );
	else
		Print( "	Passed: Conversion generic to wild of open tetrahedron.\n" );
	fi;

	## Test the face to wild converter
	faceToWild := WildSimplicialSurfacesFromFacePath( face );
	if Length( faceToWild ) <> 1 then
		Print( "Failed: Conversion face to wild of open tetrahedron has wrong number of possibilities." );
	fi;
	faceToWildToGen := GenericSimplicialSurfaceFromWildSimplicialSurface( faceToWild[1] );
	if not IsIsomorphicGenericSimplicialSurface( faceToGeneric, faceToWildToGen ) then
		Print( "Failed: Conversion facePath to wild of open tetrahedron failed." );
	else
		Print( "	Passed: Conversion facePath to wild of open tetrahedron." );
	fi;
end;


# Test everything
TestOpenTetrahedron := function()
	TestOpenTetrahedronWild();
	TestOpenTetrahedronGeneric();
	TestOpenTetrahedronConversion();
end;

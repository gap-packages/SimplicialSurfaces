################################################################################
################################################################################
#####				Test two connected triangles
################################################################################
################################################################################

################################################################################
##	This method tests the functionality for the example of two connected 
##	triangles and the representation of a wild coloured simplicial surface
TestTwoConnectedTrianglesWild := function()
	local sig1,sig2,sig3, mrType, surfaces, surf, VertexGroup, generic,
		consistency, name;

	name := "TwoConTriangles";

	sig1 := (1,2);
	sig2 := ();
	sig3 := ();

	# The edge at sig1 can be either mirror or rotation, all other edges
	# have to be mirror edges: [ [?,?], [1,1], [1,1] ]
	surfaces := AllWildSimplicialSurfaces( sig1, sig2, sig3  );
	if Length(surfaces) <> 2 then
		Print( "Failed: ");
		Print( name );
		Print( " can't be defined by wild coloring.\n" );
	fi;
	for surf in surfaces do
		TestWildConsistency( surf, name );
	od;

	surf := surfaces[1];

	# Test the elementary properties
	if NrOfVerticesOfWildSimplicialSurface(surf) <> 4 then
		Print( "Failed: ");
		Print(name);
		Print( " has wrong number of vertices.\n" );
	fi;

	if NrOfEdgesOfWildSimplicialSurface(surf) <> 5 then
		Print( "Failed: ");
		Print(name);
		Print( " has wrong number of edges.\n" );
	fi;

	if NrOfFacesOfWildSimplicialSurface(surf) <> 2 then
		Print( "Failed: ");
		Print(name);
		Print( " has wrong number of faces.\n" );
	fi;

	if MrTypeOfWildSimplicialSurface(surf)[2] <> [1,1] or
		MrTypeOfWildSimplicialSurface(surf)[3] <> [1,1] then
		Print( "Failed: ");
		Print(name);
		Print( " has wrong mr-type.\n" );
	fi;

	# Test some advanced properties
	if EulerCharacteristic(surf) <> 1 then
		Print( "Failed: ");
		Print(name);
		Print( " has wrong number Euler-Characteristic.\n" );
	fi;

	VertexGroup := VertexGroupOfWildSimplicialSurface(surf);
	VertexGroup := VertexGroup[1] / VertexGroup[2];
	if Size( VertexGroup ) <> 2 then
		Print( "Failed: ");
		Print(name);
		Print( " vertex group is not V_2.\n");
    else
		Print( "  Passed: ");
		Print(name);
		Print( " has correct vertex group V_2.\n");
	fi;

	if DegreesOfWildSimplicialSurface(surf) <> [1,1,2,2] then
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

	surf := SnippOffEars( surf );
	TestWildConsistency( surf, Concatenation(name," after snipping"));
	if NrOfVertices( surf ) + NrOfEdges(surf) + NrOfFaces( surf ) > 0 then
		Print( "Failed: " );
		Print( name );
		Print( " after snipping is not empty.\n");
	fi;

end;

##########################################################################
## This method tests the functionality for the example of a twoConTriangle
## and the representation of a generic simplicial surface
TestTwoConnectedTrianglesGeneric := function()
	local surf, newSurf, graph, name;

	name := "TwoConTriangle";

	surf := GenericSimplicialSurface( rec( 
		nrOfVertices := 4,
		nrOfEdges := 5,
		nrOfFaces := 2,
		edges := [[1,2],[1,3],[3,2],[4,2],[4,3]], 
		faces := [[1,2,3],[3,5,4]] ) );

	TestGenericConsistency( surf, Concatenation( name," definition (generic)") );

	# Test the elementary properties
	if NrOfVerticesOfGenericSimplicialSurface(surf) <> 4 then
		Print( "Failed: ");
		Print( name );
		Print( " has wrong number of vertices.\n" );
	fi;

	if NrOfEdgesOfGenericSimplicialSurface(surf) <> 5 then
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
	if EulerCharacteristic(surf) <> 1 then
		Print( "Failed: ");
		Print( name);
		Print( " has wrong Euler-Characteristic.\n" );
	fi;

	if Length( FaceAnomalyClassesOfGenericSimplicialSurface( surf ) ) <> 2 then
		Print( "Failed: ");
		Print( name );
		Print( " should not have a face-anomaly.");
	fi;

	if UnsortedDegreesOfGenericSimplicialSurface(surf) <> [1,2,2,1] or 
		SortedDegreesOfGenericSimplicialSurface(surf) <> [1,1,2,2] then
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
		Print( "  Passed: ");
		Print( name );
		Print( " is orientable.\n" );
	fi;

	newSurf := SnippOffEars( surf );
	TestGenericConsistency( newSurf, Concatenation(name," after snipping") );
	if NrOfVertices( newSurf ) + NrOfEdges( newSurf ) + NrOfFaces( newSurf ) > 0 then
		Print( "Failed: " );
		Print( name );
		Print( " after snipping is not empty.\n");
	fi;

	# Check incidence graph
	graph := IncidenceGraphOfGenericSimplicialSurface(surf);
	if not IsGraph(graph) then
		Print( "Failed: Incidence graph is not a graph.\n");
	fi;
	if OrderGraph(graph) <> 11 then
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
## This method tests the functionality for the example of a tetrahedron
## and the conversion between different representations
TestTwoConnectedTrianglesConversion := function()
	local generic, faceToGeneric, wildToGeneric, wild, genToFaceToGen,
		genToWildToGen, genericToFace, genericToWild, face, faceToWildToGen,
		faceToWild, name;

	name := "twoConTriangle";

	## Test all converters to generic
	generic := GenericSimplicialSurface( rec( 
		nrOfVertices := 4,
		nrOfEdges := 5,
		nrOfFaces := 2,
		edges := [[1,2],[1,3],[3,2],[4,2],[4,3]], 
		faces := [[1,2,3],[3,5,4]] ) );

	wild := AllWildSimplicialSurfaces( (1,2), (), () )[1];

	face := [ [1,2,3,1], [2,3,4,2] ];

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

	## Test the generic to face converter
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
TestTwoConnectedTriangles := function()
	TestTwoConnectedTrianglesWild();
	TestTwoConnectedTrianglesGeneric();
	TestTwoConnectedTrianglesConversion();
end;

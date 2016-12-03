################################################################################
## This document contains some tests for the functionality in simplicial.gi
## and generic_simplicial_surface.gi
################################################################################

# This method supports the definition of a consistent colouring.
AllEdgesOfSameType := function( n, type )
	return List( [1,2,3], i -> List( [1..n], j -> type ) );
end;

################################################################################
# Check if a generic simplicial surface is self consistent
# Return a list of three elements: 
# 	First comes the result as a bool
#	Second comes a comment that explains the failure (if applicable)
#	Third comes the reason that prompted the comment (if applicable)
IsGenericSimplicialSurfaceSelfConsistent := function( generic )
	local edge, vert, face, verticesInFace;

	if not IsGenericSimplicialSurfaceRep(generic) then
		Error("usage: IsGenericSimplicialSurfaceSelfConsistent(generic)");
		return fail;
	fi;

	# Check if number of edges and faces match
	if Length( EdgesOfGenericSimplicialSurface(generic) ) <> 
			NrOfEdgesOfGenericSimplicialSurface(generic) then
		return [false, "Wrong number of edges.",];
	fi;
	if Length( FacesOfGenericSimplicialSurface(generic) ) <> 
			NrOfFacesOfGenericSimplicialSurface(generic) then
		return [false, "Wrong number of faces.",];
	fi;

	# Check individual edges
	for edge in EdgesOfGenericSimplicialSurface(generic) do
		if Length(edge) <> 2 or Length( Set( edge ) ) <> 2 then
			return [false, 
				"There exists an edge that does not consist of two vertices.",
				edge];
		fi;
		for vert in edge do
			if vert < 1 or vert > NrOfVerticesOfGenericSimplicialSurface(generic) then
				return [false, 
					"There exists an edge with a non-existent vertex.", edge];
			fi;
		od;
	od;

	# Check individual faces
	for face in FacesOfGenericSimplicialSurface(generic) do
		if Length( face ) <> Length( Set( face ) ) then
			return [false, "There exists a face with repeated edges.", face];
		fi;

		verticesInFace := [];
		for edge in face do
			if edge < 1 or edge > NrOfEdgesOfGenericSimplicialSurface(generic) then
				return [false, 
					"There exists a face with a non-existent edge.", face];
			fi;
			Append( verticesInFace, EdgesOfGenericSimplicialSurface(generic)[edge] );
		od;
		if Length( Set( verticesInFace ) ) <> Length( face ) then
			return [false, 
				"There exists a face with an incorrect number of vertices.", 
				face];
		fi;
	od;

	return [true, "", ];
end;

###############################################################################
## Test the consistency of a generic simplicial surface
## the objectDescription will be printed if this test fails
TestGenericConsistency := function( generic, objectDescription )
	local consistency;

	consistency := IsGenericSimplicialSurfaceSelfConsistent( generic );
	if not consistency[1] then
		Print( "Failed: ");
		Print( objectDescription );
		Print( " is not self consistent: ");
		Print( consistency[2] );
		Print( consistency[3] );
		Print( "\n" );
	fi;
end;

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
		consistency;

	sig1 := (1,3)(2,4);
	sig2 := (1,2)(3,4);
	sig3 := (1,4)(2,3);
	mrType := AllEdgesOfSameType( 4, 2);

	surfaces := AllSimplicialSurfaces( sig1, sig2, sig3,mrType  );
	if Length(surfaces) <> 1 then
		Print( "Failed: Tetrahedron can't be defined by wild coloring.\n" );
	fi;

	surf := surfaces[1];

	# Test the elementary properties
	if NrOfVerticesOfSimplicialSurface(surf) <> 4 then
		Print( "Failed: Tetrahedron has wrong number of vertices.\n" );
	fi;

	if NrOfEdgesOfSimplicialSurface(surf) <> 6 then
		Print( "Failed: Tetrahedron has wrong number of edges.\n" );
	fi;

	if NrOfFacesOfSimplicialSurface(surf) <> 4 then
		Print( "Failed: Tetrahedron has wrong number of faces.\n" );
	fi;

	if MrTypeOfSimplicialSurface(surf) <> mrType then
		Print( "Failed: Tetrahedron has wrong mr-type.\n" );
	fi;

	# Test some advanced properties
	if EulerCharacteristic(surf) <> 2 then
		Print( "Failed: Tetrahedron has wrong Euler-Characteristic.\n" );
	fi;

	VertexGroup := VertexGroupOfSimplicialSurface(surf);
	VertexGroup := VertexGroup[1] / VertexGroup[2];
	if not IsDihedralGroup( VertexGroup ) or Size( VertexGroup ) <> 4 then
		Print( "Failed: Tetrahedron vertex group is not V_4.\n");
    else
		Print( "  Passed: Tetrahedron has correct vertex group V_4.\n");
	fi;

	if DegreesOfSimplicialSurface(surf) <> [3,3,3,3] then
		Print( "Failed: Tetrahedron vertex degrees are incorrect.\n");
    else
		Print( "  Passed: Tetrahedron has correct vertex degrees.\n");
	fi;

	if not IsConnectedSimplicialSurface(surf) then
		Print( "Failed: Tetrahedron should be connected.\n" );
    else
		Print( "  Passed: Tetrahedron is connected.\n" );
	fi;

	if not IsOrientableSimplicialSurface(surf) then
		Print( "Failed: Tetrahedron should be orientable.\n" );
    else
		Print( "  Passed: Tetrahedron is orientable.\n" );
	fi;

	if  surf <> SnippOffEars(surf)  then
		Print( "Failed: Tetrahedron should not have ears.\n");
    else
		Print( "  Passed: Tetrahedron has no ears.\n");
	fi;

end;

##########################################################################
## This method tests the functionality for the example of a tetrahedron
## and the representation of a generic simplicial surface
TestTetrahedronGeneric := function()
	local surf, newSurf, graph;

	surf := GenericSimplicialSurface( rec( 
		nrOfVertices := 4,
		nrOfEdges := 6,
		nrOfFaces := 4,
		edges := [[1,2],[2,3],[3,1],[1,4],[4,2],[4,3]], 
		faces := [[1,2,3],[5,1,4],[3,6,4],[5,6,2]] ) );

	TestGenericConsistency( surf, "Tetrahedron definition (generic)" );

	# Test the elementary properties
	if NrOfVerticesOfGenericSimplicialSurface(surf) <> 4 then
		Print( "Failed: Tetrahedron has wrong number of vertices.\n" );
	fi;

	if NrOfEdgesOfGenericSimplicialSurface(surf) <> 6 then
		Print( "Failed: Tetrahedron has wrong number of edges.\n" );
	fi;

	if NrOfFacesOfGenericSimplicialSurface(surf) <> 4 then
		Print( "Failed: Tetrahedron has wrong number of faces.\n" );
	fi;

	# Test some advanced properties
#	if EulerCharacteristic(surf) <> 2 then
#		Print( "Tetrahedron has wrong Euler-Characteristic.\n" );
#	fi;

	if UnsortedDegreesOfGenericSimplicialSurface(surf) <> [3,3,3,3] or 
		SortedDegreesOfGenericSimplicialSurface(surf) <> [3,3,3,3] then
		Print( "Failed: Tetrahedron vertex degrees are incorrect.\n");
    else
		Print( "  Passed: Tetrahedron has correct vertex degrees.\n");
	fi;

	if not IsConnectedGenericSimplicialSurface(surf) then
		Print( "Failed: Tetrahedron should be connected.\n" );
    else
		Print( "  Passed: Tetrahedron is connected.\n" );
	fi;

	if not IsOrientableGenericSimplicialSurface(surf) then
		Print( "Failed: Tetrahedron should be orientable.\n" );
    else
		Print( "  Passed: Tetrahedron is orientable.\n" );
	fi;

	if  surf <> SnippOffEarsOfGenericSimplicialSurface(surf)  then
		Print( "Failed: Tetrahedron should not have ears.\n");
    else
		Print( "  Passed: Tetrahedron has no ears.\n");
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
	TestGenericConsistency( newSurf, "Tetrahedron after removel of one vertex");
	if NrOfVerticesOfGenericSimplicialSurface(newSurf) <> 3 then
		Print( "Failed: Tetrahedron has wrong number of vertices after removing one vertex.\n" );
	fi;
	if NrOfEdgesOfGenericSimplicialSurface(newSurf) <> 3 then
		Print( "Failed: Tetrahedron has wrong number of edges after removing one vertex.\n" );
	fi;
	if NrOfFacesOfGenericSimplicialSurface(newSurf) <> 1 then
		Print( "Failed: Tetrahedron has wrong number of faces after removing one vertex.\n" );
	fi;

end;


##########################################################################
## This method tests the functionality for the example of a tetrahedron
## and the conversion between different representations
TestTetrahedronConversion := function()
	local generic, faceToGeneric, wildToGeneric, wild, genToFaceToGen,
		genToWildToGen, genericToFace, genericToWild, face, faceToWildToGen,
		faceToWild;

	## Test all converters to generic
	generic := GenericSimplicialSurface( rec( 
		nrOfVertices := 4,
		nrOfEdges := 6,
		nrOfFaces := 4,
		edges := [[1,2],[2,3],[3,1],[1,4],[4,2],[4,3]], 
		faces := [[1,2,3],[5,1,4],[3,6,4],[5,6,2]] ) );

	wild := AllSimplicialSurfaces( 
		(1,3)(2,4), 
		(1,2)(3,4), 
		(1,4)(2,3),
		AllEdgesOfSameType(4, 2) )[1];

	face := [ [1,2,3,1], [2,3,4,2], [3,1,4,3], [1,4,2,1] ];

	faceToGeneric := GenericSimplicialSurfaceFromFaceVertexPath( face );
	if not IsIsomorphicGenericSimplicialSurface( generic, faceToGeneric ) then
		Print( "Failed: Conversion facePath to generic of tetrahedron failed.\n" );
	else
		Print( "	Passed: Conversion facePath to generic of tetrahedron.\n" );
	fi;

	wildToGeneric := GenericSimplicialSurfaceFromWildSimplicialSurface( wild );
	if not IsIsomorphicGenericSimplicialSurface( generic, wildToGeneric ) then
		Print( "Failed: Conversion wild to generic of tetrahedron failed.\n" );
	else
		Print( "	Passed: Conversion wild to generic of tetrahedron.\n" );
	fi;


	## Test the generic to face converter
	genericToFace := FaceVertexPathFromGenericSimplicialSurface( generic );
	genToFaceToGen := GenericSimplicialSurfaceFromFaceVertexPath( genericToFace );
	if not IsIsomorphicGenericSimplicialSurface( generic, genToFaceToGen ) then
		Print( "Failed: Conversion generic to facePath of tetrahedron failed.\n" );
	else
		Print( "	Passed: Conversion generic to facePath of tetrahedron.\n" );
	fi;

	## Test the generic to face converter
	genericToWild := WildSimplicialSurfacesFromGenericSurface( generic );
	if Length( genericToWild ) <> 1 then
		Print( "Failed: Conversion generic to wild of tetrahedron has wrong number of possibilities.\n" );
	fi;
	genToWildToGen := GenericSimplicialSurfaceFromWildSimplicialSurface( genericToWild[1] );
	if not IsIsomorphicGenericSimplicialSurface( generic, genToWildToGen ) then
		Print( "Failed: Conversion generic to wild of tetrahedron failed.\n" );
	else
		Print( "	Passed: Conversion generic to wild of tetrahedron.\n" );
	fi;

	## Test the face to wild converter
	faceToWild := WildSimplicialSurfacesFromFacePath( face );
	if Length( faceToWild ) <> 1 then
		Print( "Failed: Conversion face to wild of tetrahedron has wrong number of possibilities." );
	fi;
	faceToWildToGen := GenericSimplicialSurfaceFromWildSimplicialSurface( faceToWild[1] );
	if not IsIsomorphicGenericSimplicialSurface( faceToGeneric, faceToWildToGen ) then
		Print( "Failed: Conversion facePath to wild of tetrahedron failed." );
	else
		Print( "	Passed: Conversion facePath to wild of tetrahedron." );
	fi;
end;


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

	surfaces := AllSimplicialSurfaces( sig1, sig2, sig3,mrType  );
	if Length(surfaces) <> 1 then
		Print( "Failed: Open Tetrahedron can't be defined.\n" );
	fi;

	surf := surfaces[1];

	# Test the elementary properties
	if NrOfVerticesOfSimplicialSurface(surf) <> 4 then
		Print( "Failed: Open Tetrahedron has wrong number of vertices.\n" );
	fi;

	if NrOfEdgesOfSimplicialSurface(surf) <> 6 then
		Print( "Failed: Open Tetrahedron has wrong number of edges.\n" );
	fi;

	if NrOfFacesOfSimplicialSurface(surf) <> 3 then
		Print( "Failed: Open Tetrahedron has wrong number of faces.\n" );
	fi;

	if MrTypeOfSimplicialSurface(surf) <> mrType then
		Print( "Failed: Open Tetrahedron has wrong mr-type.\n" );
	fi;

	# Test some advanced properties
	if EulerCharacteristic(surf) <> 1 then
		Print( "Failed: Open Tetrahedron has wrong Euler-Characteristic.\n" );
	fi;

	VertexGroup := VertexGroupOfSimplicialSurface(surf);
	VertexGroup := VertexGroup[1] / VertexGroup[2];
	if not IsDihedralGroup( VertexGroup ) or Size( VertexGroup ) <> 4 then
		Print( "Failed: Open Tetrahedron vertex group is not V_4.\n");
    else
		Print( "  Passed: Open Tetrahedron has correct vertex group V_4.\n");
	fi;

	Degrees := DegreesOfSimplicialSurface(surf);
	if Set(Degrees) <> [2,3] or Length(Degrees) <> 4 or 
		Length( Filtered( Degrees, i->i=2) ) <> 3 then
		Print( "Failed: Open Tetrahedron vertex degrees are incorrect.\n");
    else
		Print( "  Passed: Open Tetrahedron has correct vertex degrees.\n");
	fi;

	if not IsConnectedSimplicialSurface(surf) then
		Print( "Failed: Open Tetrahedron should be connected.\n" );
    else
		Print( "  Passed: Open Tetrahedron is connected.\n" );
	fi;

	if not IsOrientableSimplicialSurface(surf) then
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
#	if EulerCharacteristic(surf) <> 1 then
#		Print( "Open Tetrahedron has wrong Euler-Characteristic.\n" );
#	fi;

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

	wild := AllSimplicialSurfaces( 
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
TestTetrahedron := function()
	TestTetrahedronWild();
	TestTetrahedronGeneric();
	TestTetrahedronConversion();
end;

TestOpenTetrahedron := function()
	TestOpenTetrahedronWild();
	TestOpenTetrahedronGeneric();
	TestOpenTetrahedronConversion();
end;

TestAll := function()
	TestTetrahedron();
	TestOpenTetrahedron();
end;

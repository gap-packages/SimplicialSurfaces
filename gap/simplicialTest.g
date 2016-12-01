#################################################################################
## This document contains some tests for the functionality in simplicial.gi
## and generic_simplicial_surface.gi
#################################################################################

# This method supports the definition of a consistent colouring.
AllEdgesOfSameType := function( n, type )
	return List( [1,2,3], i -> List( [1..n], j -> type ) );
end;

###################################################################################
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
	if Length( EdgesOfGenericSimplicialSurface(generic) ) <> NrOfEdgesOfGenericSimplicialSurface(generic) then
		return [false, "Wrong number of edges.",];
	fi;
	if Length( FacesOfGenericSimplicialSurface(generic) ) <> NrOfFacesOfGenericSimplicialSurface(generic) then
		return [false, "Wrong number of faces.",];
	fi;

	# Check individual edges
	for edge in EdgesOfGenericSimplicialSurface(generic) do
		if Length(edge) <> 2 or Length( Set( edge ) ) <> 2 then
			return [false, "There exists an edge that does not consist of two vertices.", edge];
		fi;
		for vert in edge do
			if vert < 1 or vert > NrOfVerticesOfGenericSimplicialSurface(generic) then
				return [false, "There exists an edge with a non-existent vertex.", edge];
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
				return [false, "There exists a face with a non-existent edge.", face];
			fi;
			Append( verticesInFace, EdgesOfGenericSimplicialSurface(generic)[edge] );
		od;
		if Length( Set( verticesInFace ) ) <> Length( face ) then
			return [false, "There exists a face with an incorrect number of vertices.", face];
		fi;
	od;

	return [true, "", ];
end;

#########################################################################################
#########################################################################################
#####							Test a tetrahedron
#########################################################################################
#########################################################################################

##########################################################################
## This method tests the functionality for the example of a tetrahedron
## and the representation of a wild colored simplicial surface
TestTetrahedronWildColored := function()
	local sig1,sig2,sig3, mrType, surfaces, surf, VertexGroup, generic, consistency;

	sig1 := (1,3)(2,4);
	sig2 := (1,2)(3,4);
	sig3 := (1,4)(2,3);
	mrType := AllEdgesOfSameType( 4, 2);

	surfaces := AllSimplicialSurfaces( sig1, sig2, sig3,mrType  );
	if Length(surfaces) <> 1 then
		Print( "Tetrahedron can't be defined by wild coloring.\n" );
	fi;

	surf := surfaces[1];

	# Test the elementary properties
	if NrOfVerticesOfSimplicialSurface(surf) <> 4 then
		Print( "Tetrahedron has wrong number of vertices.\n" );
	fi;

	if NrOfEdgesOfSimplicialSurface(surf) <> 6 then
		Print( "Tetrahedron has wrong number of edges.\n" );
	fi;

	if NrOfFacesOfSimplicialSurface(surf) <> 4 then
		Print( "Tetrahedron has wrong number of faces.\n" );
	fi;

	if MrTypeOfSimplicialSurface(surf) <> mrType then
		Print( "Tetrahedron has wrong mr-type.\n" );
	fi;

	# Test some advanced properties
	if EulerCharacteristic(surf) <> 2 then
		Print( "Tetrahedron has wrong Euler-Characteristic.\n" );
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
	local surf, consistency, newSurf;

	surf := GenericSimplicialSurface( rec( 
		nrOfVertices := 4,
		nrOfEdges := 6,
		nrOfFaces := 4,
		edges := [[1,2],[2,3],[3,1],[1,4],[4,2],[4,3]], 
		faces := [[1,2,3],[5,1,4],[3,6,4],[5,6,2]] ) );

	consistency := IsGenericSimplicialSurfaceSelfConsistent( surf );
	if not consistency[1] then
		Print( Concatenation( "Tetrahedron definition (generic) is not self consistent: ", consistency[2]) );
		Print( consistency[3] );
		Print( "\n" );
	fi;

	# Test the elementary properties
	if NrOfVerticesOfGenericSimplicialSurface(surf) <> 4 then
		Print( "Tetrahedron has wrong number of vertices.\n" );
	fi;

	if NrOfEdgesOfGenericSimplicialSurface(surf) <> 6 then
		Print( "Tetrahedron has wrong number of edges.\n" );
	fi;

	if NrOfFacesOfGenericSimplicialSurface(surf) <> 4 then
		Print( "Tetrahedron has wrong number of faces.\n" );
	fi;

	# Test some advanced properties
#	if EulerCharacteristic(surf) <> 2 then
#		Print( "Tetrahedron has wrong Euler-Characteristic.\n" );
#	fi;

	if UnsortedDegreesOfGenericSimplicialSurface(surf) <> [3,3,3,3] or SortedDegreesOfGenericSimplicialSurface(surf) <> [3,3,3,3] then
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

	newSurf := RemoveVertexOfGenericSimplicialSurface( surf, 1);
	consistency := IsGenericSimplicialSurfaceSelfConsistent( newSurf );
	if not consistency[1] then
		Print( Concatenation( "Tetrahedron after removel of one vertex is not self consistent: ", consistency[2]) );
		Print( consistency[3] );
		Print( "\n" );
	fi;
	if NrOfVerticesOfGenericSimplicialSurface(newSurf) <> 3 then
		Print( "Tetrahedron has wrong number of vertices after removing one vertex.\n" );
	fi;
	if NrOfEdgesOfGenericSimplicialSurface(newSurf) <> 3 then
		Print( "Tetrahedron has wrong number of edges after removing one vertex.\n" );
	fi;
	if NrOfFacesOfGenericSimplicialSurface(newSurf) <> 1 then
		Print( "Tetrahedron has wrong number of faces after removing one vertex.\n" );
	fi;

end;


##########################################################################
## This method tests the functionality for the example of a tetrahedron
## and the conversion between different representations
TestTetrahedronConversion := function()
	## Testing face path surface to wild simplicial surface converter
#	surfaces := WildSimplicialSurfacesFromFacePath( [[1..4], [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]],[[1,3,2,1],[2,4,1,2],[1,3,4,1],[3,4,2,3]] ]);
#	if Length(surfaces) <> 1 then
#		Print( "Failed: Tetrahedron can't be defined by face-paths.\n" );
 #   else 
	#	Print( "  Passed: Tetrahedron can be defined by face-paths.\n" );
#	fi;
#	if  Length(surfaces) = 0 or surf <> surfaces[1] then
#		Print( "Failed: Tetrahedron by face-paths is not equal to standard construction.\n");
 #    else
#		Print( "  Passed: Tetrahedron by face-paths is not equal to standard construction.\n");
#	fi;

    ## Testing generic surface to wild simplicial surface converter
#	surfaces := WildSimplicialSurfacesFromGenericSurface( [ 4,6,4, [[1,2],[2,3],[3,1],[1,4],[4,2],[4,3]], [[1,2,3],[5,1,4],[3,6,4],[5,6,2]] ] );
#	if Length(surfaces) <> 1 then
#		Print( "Failed: Tetrahedron can't be defined by generic construction.\n" );
#    else
#		Print( "  Passed: Tetrahedron can be defined by generic construction.\n" );
#	fi;
#	if  Length(surfaces) = 0 or surf <> surfaces[1]  then
#		Print( "Failed: Tetrahedron by generic construction is not equal to standard construction.\n");
#	else
#		Print( "  Passed: Tetrahedron by generic construction is equal to standard construction.\n");
#	fi;
#
	## Testing wild simplicial surface to generic surface converter
#	generic := GenericSurfaceFromWildSimplicialSurface( surf );
#	if generic[1] <> 4 then
#		Print( "Tetrahedron has wrong number of vertices in conversion to generic surface.\n" );
#	fi;
#	if generic[2] <> 6 then
#		Print( "Tetrahedron has wrong number of edges in conversion to generic surface.\n" );
#	fi;
#	if generic[3] <> 4 then
#		Print( "Tetrahedron has wrong number of faces in conversion to generic surface.\n" );
#	fi;

#	consistency := IsGenericSimplicialSurfaceSelfConsistent( generic );
#	if not consistency[1] then
#		Print( Concatenation( "Tetrahedron conversion to generic is not self consistent: ", consistency[2]) );
#		Print( consistency[3] );
#		Print( "\n" );
#	fi;
	#TODO more tests
end;


#########################################################################################
#########################################################################################
#####				Test an open tetrahedron
#########################################################################################
#########################################################################################

# This method tests the functionality for the example of a tetrahedron that is missing one face
TestOpenTetrahedron := function()
	local sig1,sig2,sig3, mrType, surfaces, surf, VertexGroup, Degrees, generic, consistency;

	sig1 := (1,2);
	sig2 := (2,3);
	sig3 := (1,3);
	mrType := AllEdgesOfSameType( 3, 2);

	surfaces := AllSimplicialSurfaces( sig1, sig2, sig3,mrType  );
	if Length(surfaces) <> 1 then
		Print( "Open Tetrahedron can't be defined.\n" );
	fi;

	surf := surfaces[1];

	# Test the elementary properties
	if NrOfVerticesOfSimplicialSurface(surf) <> 4 then
		Print( "Open Tetrahedron has wrong number of vertices.\n" );
	fi;

	if NrOfEdgesOfSimplicialSurface(surf) <> 6 then
		Print( "Open Tetrahedron has wrong number of edges.\n" );
	fi;

	if NrOfFacesOfSimplicialSurface(surf) <> 3 then
		Print( "Open Tetrahedron has wrong number of faces.\n" );
	fi;

	if MrTypeOfSimplicialSurface(surf) <> mrType then
		Print( "Open Tetrahedron has wrong mr-type.\n" );
	fi;

	# Test some advanced properties
	if EulerCharacteristic(surf) <> 1 then
		Print( "Open Tetrahedron has wrong Euler-Characteristic.\n" );
	fi;

	VertexGroup := VertexGroupOfSimplicialSurface(surf);
	VertexGroup := VertexGroup[1] / VertexGroup[2];
	if not IsDihedralGroup( VertexGroup ) or Size( VertexGroup ) <> 4 then
		Print( "Failed: Open Tetrahedron vertex group is not V_4.\n");
    else
		Print( "  Passed: Open Tetrahedron has correct vertex group V_4.\n");
	fi;

	Degrees := DegreesOfSimplicialSurface(surf);
	if Set(Degrees) <> [2,3] or Length(Degrees) <> 4 or Length( Filtered( Degree, i->i=2) ) <> 3 then
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

	# Test equality with other constructions

	## Testing face path surface to wild simplicial surface converter
	surfaces := WildSimplicialSurfacesFromFacePath( [[1,2,3], [[1,2],[1],[1,3],[3],[2,3],[2]],[[1,2],[3,1],[3,2],[2,3,1,2]] ]);
	if Length(surfaces) <> 1 then
		Print( "Failed: Open Tetrahedron can't be defined by face-paths.\n" );
    else 
		Print( "  Passed: Open Tetrahedron can be  defined by face-paths.\n" );
	fi;
	if  Length(surfaces) = 0 or surf <> surfaces[1] then
		Print( "Failed: Open Tetrahedron by face-paths is not equal to standard construction.\n");
     else
		Print( "  Passed: Open Tetrahedron by face-paths is not equal to standard construction.\n");
	fi;

    ## Testing generic surface to wild simplicial surface converter
	surfaces := WildSimplicialSurfacesFromGenericSurface( [ 4,6,3, [[1,4],[2,1],[2,4],[2,3],[4,3],[1,3]], [[1,2,3],[1,6,5],[4,5,3]] ] );
	if Length(surfaces) <> 1 then
		Print( "Failed: Open Tetrahedron can't be defined by generic construction.\n" );
    else
		Print( "  Passed: Open Tetrahedron can be defined by generic construction.\n" );
	fi;
	if  Length(surfaces) = 0 or surf <> surfaces[1]  then
		Print( "Failed: Open Tetrahedron by generic construction is not equal to standard construction.\n");
    else
		Print( "  Passed: Open Tetrahedron by generic construction is equal to standard construction.\n");
	fi;
	
	## Testing wild simplicial surface to generic surface converter
	generic := GenericSurfaceFromWildSimplicialSurface( surf );
	if generic[1] <> 4 then
		Print( "Tetrahedron has wrong number of vertices in conversion to generic surface.\n" );
	fi;
	if generic[2] <> 6 then
		Print( "Tetrahedron has wrong number of edges in conversion to generic surface.\n" );
	fi;
	if generic[3] <> 3 then
		Print( "Tetrahedron has wrong number of faces in conversion to generic surface.\n" );
	fi;
	
	consistency := IsGenericSimplicialSurfaceSelfConsistent( generic );
	if not consistency[1] then
		Print( Concatenation( "Open Tetrahedron conversion to generic is not self consistent: ", consistency[2]) );
		Print( consistency[3] );
		Print( "\n" );
	fi;
	#TODO more tests

end;


# Test everything
TestTetrahedron := function()
	TestTetrahedronWildColored();
	TestTetrahedronGeneric();
	TestTetrahedronConversion();
end;

TestAll := function()
	TestTetrahedron();
	TestOpenTetrahedron();
end;

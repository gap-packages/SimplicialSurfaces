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
	local conCom;

	TestSimplicialSurfaceAttributes( surface, messageSurfaceOrigin, rec( 
		vertexNr := 7, 		# number of vertices
		edgeNr := 12, 	# number of edges
		faceNr := 8,		# number of faces
		isEdgesLikeSurface := true,	# do the edges look like on a surface?
		isVerticesLikeSurface := true,	# do the vertices look like on a surface?
		isTriangleSurface := true,	# is every face a triangle?
		isClosedSurface := true,	# is it closed?
		isOrientable := false,	# is it orientable?
		connectedComponentNr := 2, 	# is it connected?
                pathConnectedComponentNr := 2,
		sortDeg := [3,3,3,3,4,4,4],		# the sorted degrees
		vertexSym := [,,4,3],			# the vertex symbol
		faceAnomalyClassNr := 5,		# the number of anomaly classes
                edgeAnomalyClassNr := 9,
		isSnippable := false	# does ear-removal reduce the surface?
            )
	);
	
	# Test connected components
	# TODO also test for different orders of function calls
	conCom := ConnectedComponentsAttributeOfSimplicialSurface( surface );
	if Length(conCom) <> 2 then
		Print( messageSurfaceOrigin );
		Print( " must have exactly two connected component.\n" );
	fi;
	if IsOrientable( conCom[1] ) then
		# has to be the tetrahedron
		TestIsomorphicTetrahedron( conCom[1], "Orientable component of tetrahedronAndProjectivePlane" );
		TestIsomorphicProjectivePlaneFour( conCom[2], "Non-orientable component of tetrahedronAndProjectivePlane" );
	else
		TestIsomorphicTetrahedron( conCom[2], "Orientable component of tetrahedronAndProjectivePlane" );
		TestIsomorphicProjectivePlaneFour( conCom[1], "Non-orientable component of tetrahedronAndProjectivePlane" );
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

	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );
end;



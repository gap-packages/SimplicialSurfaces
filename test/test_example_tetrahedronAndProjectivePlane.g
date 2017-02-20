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

	TestSimplicialSurfaceAttributes( surface, messageSurfaceOrigin,
		7, 		# number of vertices
		12, 	# number of edges
		8,		# number of faces
		true,	# is it an actual surface?
		true,	# is every face a triangle?
		true,	# is it closed?
		false,	# is it orientable?
		false, 	# is it connected?
		[3,3,3,3,4,4,4],		# the sorted degrees
		[,,4,3],			# the vertex symbol
		5,		# the number of anomaly classes
		false	# does ear-removal reduce the surface?
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



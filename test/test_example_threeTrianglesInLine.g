################################################################################
################################################################################
#####		Test three triangles that coincide in exactly one vertex
#####		First and second triangle meet in an edge, second and third
#####		one as well. First and third only meet in one vertex.
################################################################################
################################################################################


TestIsomorphicThreeTrianglesInLine := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( 5, [3..9], [3,5,6],
		[ , , [1,2],[1,3],[2,3],[2,4],[2,5],[3,5],[4,5] ],
		[ , , [3,4,5], , [7,8,5], [9,6,7] ] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to three triangles in line.\n");
	fi;
end;

##
##	Test whether a simplicial surface consists of three triangles that lie in
##	a line.
##
TestIsThreeTrianglesInLine := function( surface, messageSurfaceOrigin )
	local snipp;

	TestSimplicialSurfaceAttributes( surface, messageSurfaceOrigin,
		5, 		# number of vertices
		7, 	# number of edges
		3,		# number of faces
		true,	# is it an actual surface?
		true,	# is every face a triangle?
		false,	# is it closed?
		true,	# is it orientable?
		true, 	# is it connected?
		[1,1,2,2,3],		# the sorted degrees
		[,2,2,1],			# the vertex symbol
		3,		# the number of anomaly classes
		true	# does ear-removal reduce the surface?
	);

	snipp := SnippOffEars(surface);
	if NrOfVertices(snipp) > 0 or NrOfEdges(snipp) > 0 or NrOfFaces(snipp) > 0 then
		Print( messageSurfaceOrigin );
		Print( " should be destroyed by removal of ears.\n");
	fi;

	
	TestIsomorphicThreeTrianglesInLine( surface, messageSurfaceOrigin );
	
end;



##########################################################################
## This method tests the functionality for the example of three triangles that
## lie in a line and its representation as simplicial surface
TestThreeTrianglesInLine := function()
	local surf, name;

	name := "ThreeTrianglesInLine";

	surf := SimplicialSurfaceByVerticesInFaces( 5,3, [[1,2,3],[2,5,3],[2,4,5]] );

	TestIsThreeTrianglesInLine( surf, Concatenation(name," definition") );

	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );
end;


##
##	Test this example as a folding complex
##
TestFoldingComplexThreeTrianglesInLine := function()
	local surf, complex, name;

	surf := SimplicialSurfaceByVerticesInFaces( 5,3, [[1,2,3],[2,5,3],[2,4,5]] );
	
	# Construct the folding complex
	complex := FoldingComplex( surf ); # relies on the fact that this is the first edge
	name := "Folding complex of three triangles in line";
	TestFoldingComplexConsistency( complex, name );
	
end;


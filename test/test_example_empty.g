################################################################################
################################################################################
#####							Test an empty surface
################################################################################
################################################################################


TestIsomorphicEmpty := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( [],[],[],[],[] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to an empty surface.\n");
	fi;
end;

##
##	Test whether a simplicial surface is empty.
##
TestIsEmpty := function( surface, messageSurfaceOrigin )

	TestSimplicialSurfaceAttributes( surface, messageSurfaceOrigin, rec(
		vertexNr := 0, 		# number of vertices
		edgeNr := 0, 	# number of edges
		faceNr := 0,		# number of faces
		isEdgesLikeSurface := true,	# do the edges look like on a surface?
		isVerticesLikeSurface := true,	# do the vertices look like on a surface?
		isTriangleSurface := true,	# is every face a triangle?
		isClosedSurface := true,	# is it closed?
		isOrientable := true,	# is it orientable?
		connectedComponentNr := 1, 	# is it connected?
                pathConnectedComponentNr := 1,
		sortDeg := [],		# the sorted degrees
		vertexSym := [],			# the vertex symbol
		faceAnomalyClassNr := 0,		# the number of anomaly classes
                edgeAnomalyClassNr := 0,
		isSnippable := false	# does ear-removal reduce the surface?
            )
	);
	
	TestIsomorphicEmpty( surface, messageSurfaceOrigin );
end;



##########################################################################
## This method tests the functionality for the example of an empty surface
## and the representation of a simplicial surface
TestEmpty := function()
	local surf, name;

	name := "EmptySurface";

	surf := SimplicialSurfaceByVerticesInFaces( [],[], [] );

	TestIsEmpty( surf, Concatenation(name," definition") );

	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );
end;


##
##	Test whether a wild simplicial surface is empty.
##
TestIsWildEmpty := function( surface, messageSurfaceOrigin )
	local vertexGroup, invGroup;

	# Check if it fulfills the criteria of a tetrahedron (necessary to check
	# since some methods might have been overwritten).
	TestIsEmpty( surface, messageSurfaceOrigin );
	TestWildSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	#TODO how to check?

        #TODO how to check vertex group?


	# Check group generated from the involutions
	invGroup := GroupOfWildSimplicialSurface( surface );
	if Size(invGroup) <> 1 then
		Print( messageSurfaceOrigin );
		Print( " should generate the trivial group.\n");
	fi;
end;


##########################################################################
## This method tests the functionality for the example of an empty surface
## and the representation as a wild simplicial surface
TestWildEmpty := function()
	local surf, name, sig1, sig2, sig3, gens;

	name := "Empty surface (wild)";

	sig1 := ();
	sig2 := ();
	sig3 := ();

	gens := [sig1,sig2,sig3];


	# Constructor by downward incidence and edge colouring
	surf := AllWildSimplicialSurfaces( gens );
        if Size(surf) <> 2 then
            Print("TestWildEmpty: There should be exactly two surfaces with trivial generators.\n");
        fi;

	
	# Constructor by downward incidence and generators
	surf := WildSimplicialSurfaceByDownwardIncidenceAndGenerators( 
                [], [], [], [], [], gens );
	TestIsWildEmpty( surf, Concatenation(name," by downward incidence with generators") );


	# Constructor by extending simplicial surface with edge colouring
	surf := SimplicialSurfaceByDownwardIncidence( [],[],[],[],[] );
	surf := WildSimplicialSurfaceExtensionByEdgeColouring( surf, [] );
	TestIsWildEmpty( surf, Concatenation(name," by extension with edge colouring") );


	# Constructor by extending simplicial surface with generators
	surf := SimplicialSurfaceByVerticesInFaces( [],[], [] );
	surf := WildSimplicialSurfaceExtensionByGenerators( surf, gens );
	TestIsWildEmpty( surf, Concatenation(name," by extension with generators") );

end;



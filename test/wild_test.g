


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
end;


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

end;


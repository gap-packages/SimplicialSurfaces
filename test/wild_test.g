################################################################################
## This method tests the functionality for the example of a janus head
## and the representation of a wild coloured simplicial surface
TestJanusHeadWild := function()
	local sig1,sig2,sig3, mrType, surfaces, surf, VertexGroup, generic,
		consistency, name;

	name := "Janus head";

	sig1 := (1,2);
	sig2 := (1,2);
	sig3 := (1,2);
	mrType := AllEdgesOfSameType( 2, 1);

	surfaces := AllWildSimplicialSurfaces( sig1, sig2, sig3,mrType  );
	if Length(surfaces) <> 1 then
		Print( "Failed: ");
		Print( name );
		Print( " can't be defined by wild coloring.\n" );
	fi;

	surf := surfaces[1];

end;


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


end;

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

	VertexGroup := VertexGroupOfWildSimplicialSurface(surf);
	VertexGroup := VertexGroup[1] / VertexGroup[2];
	if not IsDihedralGroup( VertexGroup ) or Size( VertexGroup ) <> 4 then
		Print( "Failed: Open Tetrahedron vertex group is not V_4.\n");
    else
		Print( "  Passed: Open Tetrahedron has correct vertex group V_4.\n");
	fi;
end;


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



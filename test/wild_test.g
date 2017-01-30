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

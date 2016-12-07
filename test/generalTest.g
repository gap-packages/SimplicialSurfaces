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

###############################################################################
## Test the consistency of a wild simplicial surface. We check if the mrtype
## is consistently defined.
## the objectDescription will be printed if this test fails
TestWildConsistency := function( wild, objectDescription )
	local mrType, gens, i, mrList, moved, p;

	mrType := MrTypeOfWildSimplicialSurface( wild );
	gens := GeneratorsOfWildSimplicialSurface( wild );
	
	for i in [1..Length(gens)] do
		mrList := mrType[i];
		moved := MovedPoints( gens[i] );
		for p in moved do
			if mrList[p] <> mrList[p^gens[i]] then
				Print( "Failed: ");
				Print( objectDescription );
				Print( " has no consistent mr-type, compare generator " );
				Print( gens[i] );
				Print( " at edge number " );
				Print( p );
				Print (".\n");
				return;
			fi; 
		od;		
	od;
end;

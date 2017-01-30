# This method supports the definition of a consistent colouring.
AllEdgesOfSameType := function( n, type )
	return List( [1,2,3], i -> List( [1..n], j -> type ) );
end;


##
##	Test the general consistency of a simplicial surface.
##	
TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin )
	local;

	if not IsSimplicialSurface( surface ) then
		Print( messageSurfaceOrigin );
		Print( " is not a simplicial surface.\n");
	fi;

	# Test the vertices
	if Vertices(surface) <> VerticesAttributeOfSimplicialSurface(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent vertices.\n");
	fi;

	# Test the edges
	if Edges(surface) <> EdgesAttributeOfSimplicialSurface(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent edges.\n");
	fi;

	# Test the faces
	if Faces(surface) <> FacesAttributeOfSimplicialSurface(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent faces.\n");
	fi;

	# Test the number of vertices
	if NrOfVertices(surface) <> NrOfVerticesAttributeOfSimplicialSurface(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent number of vertices.\n");
	fi;
	if NrOfVertices(surface) <> Length(Vertices(surface)) then
		Print( messageSurfaceOrigin );
		Print( ": Vertices and number of vertices don't match.\n");
	fi;

	# Test the number of edges
	if NrOfEdges(surface) <> NrOfEdgesAttributeOfSimplicialSurface(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent number of edges.\n");
	fi;
	if NrOfEdges(surface) <> Length(Edges(surface)) then
		Print( messageSurfaceOrigin );
		Print( ": Edges and number of edges don't match.\n");
	fi;

	# Test the number of faces
	if NrOfFaces(surface) <> NrOfFacesAttributeOfSimplicialSurface(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent number of faces.\n");
	fi;
	if NrOfFaces(surface) <> Length(Faces(surface)) then
		Print( messageSurfaceOrigin );
		Print( ": Faces and number of faces don't match.\n");
	fi;







end;

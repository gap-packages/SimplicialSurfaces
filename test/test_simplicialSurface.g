
#TODO test names of simplicial surfaces

##
##	Test the general consistency of a simplicial surface.
##	
TestSimplicialSurfaceConsistency := function( surface, messageSurfaceOrigin )
	local i, degrees, graph, name, refElements, testElements, faceAn,
            edgeAn, j, classI, classJ, class;

	if not IsSimplicialSurface( surface ) then
		Print( messageSurfaceOrigin );
		Print( " is not a simplicial surface.\n");
	fi;


	# Test the number of vertices
	if NrOfVertices(surface) <> Length(Vertices(surface)) then
		Print( messageSurfaceOrigin );
		Print( ": Vertices and number of vertices don't match.\n");
	fi;

	# Test the number of edges
	if NrOfEdges(surface) <> Length(Edges(surface)) then
		Print( messageSurfaceOrigin );
		Print( ": Edges and number of edges don't match.\n");
	fi;

	# Test the number of faces
	if NrOfFaces(surface) <> Length(Faces(surface)) then
		Print( messageSurfaceOrigin );
		Print( ": Faces and number of faces don't match.\n");
	fi;

	# Test EdgesOfVertices
	for i in [1..Length(EdgesOfVertices(surface))] do
		if i in Vertices(surface) then
			if not IsBound( EdgesOfVertices(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": EdgesOfVertices should have an entry at " );
				Print( i );
				Print( ".\n");
			elif not IsSubset( Edges(surface), EdgesOfVertices(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": Entry " );
				Print( i );
				Print( " of EdgesOfVertices should be a set of edges.\n");
			fi;
		else
			if IsBound( EdgesOfVertices(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": EdgesOfVertices should not have an entry at " );
				Print( i );
				Print( ".\n");
			fi;
		fi;
	od;

	# Test FacesOfVertices
	for i in [1..Length(FacesOfVertices(surface))] do
		if i in Vertices(surface) then
			if not IsBound( FacesOfVertices(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": FacesOfVertices should have an entry at " );
				Print( i );
				Print( ".\n");
			elif not IsSubset( Faces(surface), FacesOfVertices(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": Entry " );
				Print( i );
				Print( " of FacesOfVertices should be a set of faces.\n");
			fi;
		else
			if IsBound( FacesOfVertices(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": FacesOfVertices should not have an entry at " );
				Print( i );
				Print( ".\n");
			fi;
		fi;
	od;

	# Test VerticesOfEdges
	for i in [1..Length(VerticesOfEdges(surface))] do
		if i in Edges(surface) then
			if not IsBound( VerticesOfEdges(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": VerticesOfEdges should have an entry at " );
				Print( i );
				Print( ".\n");
			elif not IsSubset( Vertices(surface), VerticesOfEdges(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": Entry " );
				Print( i );
				Print( " of VerticesOfEdges should be a set of vertices.\n");
			fi;
		else
			if IsBound( VerticesOfEdges(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": VerticesOfEdges should not have an entry at " );
				Print( i );
				Print( ".\n");
			fi;
		fi;
	od;

	# Test FacesOfEdges
	for i in [1..Length(FacesOfEdges(surface))] do
		if i in Edges(surface) then
			if not IsBound( FacesOfEdges(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": FacesOfEdges should have an entry at " );
				Print( i );
				Print( ".\n");
			elif not IsSubset( Faces(surface), FacesOfEdges(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": Entry " );
				Print( i );
				Print( " of FacesOfEdges should be a set of faces.\n");
			fi;
		else
			if IsBound( FacesOfEdges(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": FacesOfEdges should not have an entry at " );
				Print( i );
				Print( ".\n");
			fi;
		fi;
	od;

	# Test VerticesOfFaces
	for i in [1..Length(VerticesOfFaces(surface))] do
		if i in Faces(surface) then
			if not IsBound( VerticesOfFaces(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": VerticesOfFaces should have an entry at " );
				Print( i );
				Print( ".\n");
			elif not IsSubset( Vertices(surface), VerticesOfFaces(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": Entry " );
				Print( i );
				Print( " of VerticesOfFaces should be a set of vertices.\n");
			fi;
		else
			if IsBound( VerticesOfFaces(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": VerticesOfFaces should not have an entry at " );
				Print( i );
				Print( ".\n");
			fi;
		fi;
	od;

	# Test EdgesOfFaces
	for i in [1..Length(EdgesOfFaces(surface))] do
		if i in Faces(surface) then
			if not IsBound( EdgesOfFaces(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": EdgesOfFaces should have an entry at " );
				Print( i );
				Print( ".\n");
			elif not IsSubset( Edges(surface), EdgesOfFaces(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": Entry " );
				Print( i );
				Print( " of EdgesOfFaces should be a set of edges.\n");
			fi;
		else
			if IsBound( EdgesOfFaces(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": EdgesOfFaces should not have an entry at " );
				Print( i );
				Print( ".\n");
			fi;
		fi;
	od;


	# Test Euler-Characteristic
	if NrOfVertices(surface) - NrOfEdges(surface) + NrOfFaces(surface) <> EulerCharacteristic(surface) then
		Print( messageSurfaceOrigin );
		Print( " has incorrect Euler-characteristic.\n");
	fi;


	# Test sorted degrees
	degrees := Compacted( UnsortedDegrees(surface) );
	Sort(degrees);
	if degrees <> SortedDegrees(surface) then
		Print( messageSurfaceOrigin );
		Print( ": Sorted and unsorted degrees do not match.\n");
	fi;



	# Test local orientation
	if LocalOrientation(surface) <> LocalOrientationByVerticesAsPerm(surface) then
		Print( messageSurfaceOrigin );
		Print( " has an inconsistent default local orientation.\n");
	fi;

	for i in Faces(surface) do
		refElements := VerticesOfFaces(surface)[i];
		testElements := LocalOrientationByVerticesAsPerm(surface)[i];
		if refElements <> MovedPoints( testElements ) then
			Print( messageSurfaceOrigin );
			Print( " has an inconsistent local orientation at face " );
			Print( i );
			Print( " since the vertices are " );
			Print( refElements );
			Print( " but the permutation is " );
			Print( testElements );
			Print( ".\n" );
		fi;
	od;

	for i in Faces(surface) do
		refElements := VerticesOfFaces(surface)[i];
		testElements := LocalOrientationByVerticesAsList(surface)[i];
		if refElements <> Set( testElements ) then
			Print( messageSurfaceOrigin );
			Print( " has an inconsistent local orientation at face " );
			Print( i );
			Print( " since the vertices are " );
			Print( refElements );
			Print( " but the given list is " );
			Print( testElements );
			Print( ".\n" );
		fi;
	od;

	for i in Faces(surface) do
		refElements := EdgesOfFaces(surface)[i];
		testElements := LocalOrientationByEdgesAsPerm(surface)[i];
		if refElements <> MovedPoints( testElements ) then
			Print( messageSurfaceOrigin );
			Print( " has an inconsistent local orientation at face " );
			Print( i );
			Print( " since the edges are " );
			Print( refElements );
			Print( " but the permutation is " );
			Print( testElements );
			Print( ".\n" );
		fi;
	od;

	for i in Faces(surface) do
		refElements := EdgesOfFaces(surface)[i];
		testElements := LocalOrientationByEdgesAsList(surface)[i];
		if refElements <> Set( testElements ) then
			Print( messageSurfaceOrigin );
			Print( " has an inconsistent local orientation at face " );
			Print( i );
			Print( " since the edges are " );
			Print( refElements );
			Print( " but the given list is " );
			Print( testElements );
			Print( ".\n" );
		fi;
	od;


	# Test names of faces
	for i in Faces(surface) do
		if NamesOfFaces(surface)[i] <> NamesOfFace(surface, i) then
			Print( messageSurfaceOrigin );
			Print( " has inconsistent face name for face " );
			Print( i );
			Print( ".\n" );
		fi;
		if NamesOfFace(surface,i) <> NamesOfFaceNC(surface,i) then
			Print( messageSurfaceOrigin );
			Print( " has inconsistent NC-face name for face " );
			Print( i );
			Print( ".\n" );
		fi;
		for name in NamesOfFace(surface,i) do
			if FaceByName(surface,name) <> i then
				Print( messageSurfaceOrigin );
				Print( " can't find face " );
				Print( i );
				Print( " with its name " );
				Print( name );
				Print( ".\n" );
			fi;
		od;
	od;
	if IsFaceNamesDefault(surface) then
		for i in Faces(surface) do
			if [i,-i] <> NamesOfFaces(surface)[i] then
				Print( messageSurfaceOrigin );
				Print( " does not respect the default face naming convention for face ");
				Print( i );
				Print( " and gives their names as " );
				Print( NamesOfFaces(surface)[i] );
				Print( ".\n" );
			fi;
		od;
	fi;


	# Check incidence graph
	graph := ShallowCopy( IncidenceGraph(surface) );
	if not IsGraph(graph) then
		Print( messageSurfaceOrigin );
		Print( ": Incidence graph is not a graph.\n");
	fi;
	if OrderGraph(graph) <> NrOfVertices(surface)+NrOfEdges(surface)+NrOfFaces(surface) then
		Print( messageSurfaceOrigin );
		Print( ": Number of vertices in incidence graph is wrong.\n");
	fi;
	if IsLoopy(graph) then
		Print( messageSurfaceOrigin );
		Print( ": Incidence graph should not be loopy.\n");
	fi;
	if not IsSimpleGraph(graph) then
		Print( messageSurfaceOrigin );
		Print( ": Incidence graph is not simple.\n");
	fi;
	if IsConnectedGraph(graph) <> IsConnected(surface) then
		Print( messageSurfaceOrigin );
		Print( ": Incidence graph is not connected.\n");
	fi;
	if not IsBipartite(graph) then
		Print( messageSurfaceOrigin );
		Print( ": Incidence graph is not bipartite.\n");
	fi;


        # Check anomalies
        faceAn := FaceAnomalyClasses( surface );
        for class in faceAn do
            for i in [1..Size(class)] do
                for j in [i+1..Size(class)] do
                    if VerticesOfFaces(surface)[class[i]] <> VerticesOfFaces(surface)[class[j]] then
                        Print( messageSurfaceOrigin );
                        Print( ": The faces " );
                        Print( i );
                        Print( " (with vertices " );
                        Print( VerticesOfFaces(surface)[i] );
                        Print( ") and " );
                        Print( j );
                        Print( " (with vertices " );
                        Print( VerticesOfFaces(surface)[j] );
                        Print( ") should not be in the same face anomaly class.\n");
                    fi;
                od;
            od;
        od;
        for i in [1..Size(faceAn)] do
            for j in [i+1..Size(faceAn)] do
                for classI in faceAn[i] do
                    for classJ in faceAn[j] do
                        if VerticesOfFaces(surface)[classI] = VerticesOfFaces(surface)[classJ] then
                            Print( messageSurfaceOrigin );
                            Print( ": The faces " );
                            Print( classI );
                            Print( " (with vertices " );
                            Print( VerticesOfFaces(surface)[classI] );
                            Print( ") and " );
                            Print( classJ );
                            Print( " (with vertices " );
                            Print( VerticesOfFaces(surface)[classJ] );
                            Print( ") should be in the same face anomaly class.\n" );
                        fi;
                    od;
                od;
            od;
        od;
        
        edgeAn := EdgeAnomalyClasses( surface );
        for class in edgeAn do
            for i in [1..Size(class)] do
                for j in [i+1..Size(class)] do
                    if VerticesOfEdges(surface)[class[i]] <> VerticesOfEdges(surface)[class[j]] then
                        Print( messageSurfaceOrigin );
                        Print( ": The edges " );
                        Print( i );
                        Print( " (with vertices " );
                        Print( VerticesOfEdges(surface)[i] );
                        Print( ") and " );
                        Print( j );
                        Print( " (with vertices " );
                        Print( VerticesOfEdges(surface)[j] );
                        Print( ") should not be in the same edge anomaly class.\n");
                    fi;
                od;
            od;
        od;
        for i in [1..Size(edgeAn)] do
            for j in [i+1..Size(edgeAn)] do
                for classI in edgeAn[i] do
                    for classJ in edgeAn[j] do
                        if VerticesOfEdges(surface)[classI] = VerticesOfEdges(surface)[classJ] then
                            Print( messageSurfaceOrigin );
                            Print( ": The edges " );
                            Print( classI );
                            Print( " (with vertices " );
                            Print( VerticesOfEdges(surface)[classI] );
                            Print( ") and " );
                            Print( classJ );
                            Print( " (with vertices " );
                            Print( VerticesOfEdges(surface)[classJ] );
                            Print( ") should be in the same edge anomaly class.\n" );
                        fi;
                    od;
                od;
            od;
        od;

        if IsAnomalyFree(surface) then
            if Size(faceAn) <> NrOfFaces(surface) then
                Print( messageSurfaceOrigin );
                Print( " can't be anomaly free with face anomalies ");
                Print( faceAn );
                Print( "\n");
            fi;
            if Size(edgeAn) <> NrOfEdges(surface) then
                Print( messageSurfaceOrigin );
                Print( " can't be anomaly free with edge anomalies " );
                Print( edgeAn );
                Print( "\n" );
            fi;
        else
            if Size(faceAn) = NrOfFaces(surface) and Size(edgeAn) = NrOfEdges(surface) then
                Print( messageSurfaceOrigin );
                Print( " should be anomaly free if it has neither face nor edge anomalies.\n" );
            fi;
        fi;
        if IsAnomalyFree(surface) <> IsVertexFaithful(surface) then
            Print(messageSurfaceOrigin);
            Print( ": Difference between IsAnomalyFree and IsVertexFaithful.\n");
        fi;
        

        # Check connectivity
        if IsConnected(surface) then
            if Size(ConnectedComponentsAttributeOfSimplicialSurface(surface)) <> 1 then
                Print( messageSurfaceOrigin );
                Print( " can't be connected if it has several connected components.\n" );
            fi;
        else
            if IsPathConnected(surface) then
                Print( messageSurfaceOrigin );
                Print( " can't be path connected if it is not connected.\n" );
            fi;
            if Size( ConnectedComponentsAttributeOfSimplicialSurface(surface)) = 1 then
                Print( messageSurfaceOrigin );
                Print( " should be connected if it has only one connected component.\n" );
            fi;
        fi;
        if IsPathConnected(surface) then
            if Size(PathConnectedComponents(surface)) <> 1 then
                Print( messageSurfaceOrigin );
                Print( " can't be path connected if it has several path connected components.\n" );
            fi;
        else
            if Size( PathConnectedComponents(surface)) = 1 then
                Print( messageSurfaceOrigin );
                Print( " should be path connected if it has only one path connected component.\n" );
            fi;
        fi;



end;



##
##	Test attributes of simplicial surfaces using a record with the
##      following entrie:
##	vertexNr	number of vertices
##	edgeNr		number of edges
##	faceNr		number of faces
##	isEdgesLikeSurface			do the edges look like on a surface
##	isVerticesLikeSurface		do the vertices look like on a surface
##	isTriangleSurface	is every face of the simplicial surface a triangle?
##	isClosedSurface		is the simplicial surface closed?
##	isOrientable		is the simplicial surface orientable?
##	connectedComponentNr    the number of connected components
##      pathConnectedComponentNr    the number of path connected components
##	sortDeg		the sorted degrees (vertexByFaces)
##	vertexSym	the vertex counter (vertexByEdges)
##	faceAnomalyClassNr		the number of face anomaly classes
##      edgeAnomalyClassNr          the number of edge anomaly classes
##	isSnippable			does recursively snipping off ears reduce the surface?
##
TestSimplicialSurfaceAttributes := function(surface, messageSurfaceOrigin,
        testRecord )

    local moreTests;

    # Test whether the given record contains information that will not be
    # tested in this method
    moreTests := Difference( Set( RecNames( testRecord ) ),
        Set( [ "vertexNr", "edgeNr", "faceNr", "isEdgesLikeSurface",
            "isVerticesLikeSurface", "isTriangleSurface", "isClosedSurface",
            "isOrientable", "connectedComponentNr", "sortDeg", "vertexSym", 
            "faceAnomalyClassNr", "isSnippable", "pathConnectedComponentNr",
            "edgeAnomalyClassNr"] ) );
    if not IsEmpty( moreTests ) then
        Print( messageSurfaceOrigin );
        Print( " has more information that is not tested: " );
        Print( moreTests );
        Print( " \n" );
    fi;

    TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

    if IsBound( testRecord.vertexNr ) then
	if NrOfVertices(surface) <> testRecord.vertexNr then
		Print( messageSurfaceOrigin );
		Print( " does not have " );
		Print( testRecord.vertexNr );
		Print( " vertices.\n");
	fi;
    fi;

    if IsBound( testRecord.edgeNr ) then
	if NrOfEdges(surface) <> testRecord.edgeNr then
		Print( messageSurfaceOrigin );
		Print( " does not have " );
		Print( testRecord.edgeNr );
		Print( " edges.\n");
	fi;
    fi;

    if IsBound( testRecord.faceNr ) then
	if NrOfFaces(surface) <> testRecord.faceNr then
		Print( messageSurfaceOrigin );
		Print( " does not have " );
		Print( testRecord.faceNr );
		Print( " faces.\n");
	fi;
    fi;

    # edges like surface check
    if IsBound( testRecord.isEdgesLikeSurface ) then
        if IsEdgesLikeSurface( surface ) <> testRecord.isEdgesLikeSurface then
		Print( messageSurfaceOrigin );
		if testRecord.isEdgesLikeSurface then
			Print( " must have edges like that on a surface.\n" );
		else
			Print( " must have an edge unlike that on a surface.\n" );
		fi;
	fi;
    fi;

    # vertices like surface check
    if IsBound( testRecord.isVerticesLikeSurface ) then
	if IsVerticesLikeSurface( surface ) <> testRecord.isVerticesLikeSurface then
                Print( messageSurfaceOrigin );
		if testRecord.isVerticesLikeSurface then
			Print( " must have vertices like that on a surface.\n" );
		else
			Print( " must have a vertex unlike that on a surface.\n" );
		fi;
	fi;
    fi;

    # triangle surface check
    if IsBound( testRecord.isTriangleSurface ) then
	if IsTriangleSurface( surface ) <> testRecord.isTriangleSurface then
		Print( messageSurfaceOrigin );
		if testRecord.isTriangleSurface then
			Print( " must only consist of triangles.\n" );
		else
			Print( " must not only consist of triangles.\n" );
		fi;
	fi;
    fi;

    # closed check (only makes sense if it is an actual surface)
    if IsBound( testRecord.isClosedSurface ) then
	if IsEdgesLikeSurface(surface) and IsClosedSurface( surface ) <> testRecord.isClosedSurface then
		Print( messageSurfaceOrigin );
		if testRecord.isClosedSurface then
			Print( " must be a closed surface.\n");
		else
			Print( " must not be closed.\n");
		fi;
	fi;
    fi;

    # orientable check (only makes sense if it is an actual surface)
    if IsBound( testRecord.isOrientable) then
	if IsEdgesLikeSurface(surface) and IsOrientable( surface ) <> testRecord.isOrientable then
		Print( messageSurfaceOrigin );
		if testRecord.isOrientable then
			Print( " must be orientable.\n");
		else
			Print( " must not be orientable.\n");
		fi;
	fi;
    fi;

    # connected check
    if IsBound( testRecord.connectedComponentNr ) then
	if Size( ConnectedComponentsAttributeOfSimplicialSurface( surface ) )
                    <> testRecord.connectedComponentNr then
		Print( messageSurfaceOrigin );
                Print( " has the wrong number of connected components: found " );
                Print( Size( ConnectedComponentsAttributeOfSimplicialSurface(surface) ) );
                Print( " but expected " );
                Print( testRecord.connectedComponentNr );
	fi;
    fi;

    if IsBound( testRecord.pathConnectedComponentNr ) then
	if Size( PathConnectedComponents( surface ) )
                    <> testRecord.pathConnectedComponentNr then
		Print( messageSurfaceOrigin );
                Print( " has the wrong number of path connected components: found " );
                Print( Size( PathConnectedComponents(surface) ) );
                Print( " but expected " );
                Print( testRecord.pathConnectedComponentNr );
	fi;
    fi;

    # check sorted degrees
    if IsBound( testRecord.sortDeg ) then
	if SortedDegrees(surface) <> testRecord.sortDeg then
		Print( messageSurfaceOrigin );
		Print( " does not have degrees " );
		Print( testRecord.sortDeg );
		Print( ".\n");
	fi;
    fi;

    # check vertex counter
    if IsBound( testRecord.vertexSym ) then
	if VertexCounter(surface) <> testRecord.vertexSym then
		Print( messageSurfaceOrigin );
		Print( " does not have the vertex counter " );
		Print( testRecord.vertexSym );
		Print( ".\n");
	fi;
    fi;

    # check anomaly classes
    if IsBound( testRecord.faceAnomalyClassNr ) then
	if Length( FaceAnomalyClasses(surface) ) <> testRecord.faceAnomalyClassNr then
		Print( messageSurfaceOrigin );
		Print( " should have exactly " );
		Print( testRecord.faceAnomalyClassNr );
		Print( " face anomaly class(es).\n");
	fi;
    fi;

    if IsBound( testRecord.edgeAnomalyClassNr ) then
	if Length( EdgeAnomalyClasses(surface) ) <> testRecord.edgeAnomalyClassNr then
		Print( messageSurfaceOrigin );
		Print( " should have exactly " );
		Print( testRecord.edgeAnomalyClassNr );
		Print( " edge anomaly class(es).\n");
	fi;
    fi;


    # check snippability
    if IsBound( testRecord.isSnippable ) then
	if testRecord.isSnippable then
		if surface = SnippOffEarsRecursive(surface) then
			Print( messageSurfaceOrigin );
			Print( " should be changed by removal of ears.\n");
		fi;
	else
		if surface <> SnippOffEarsRecursive(surface) then
			Print( messageSurfaceOrigin );
			Print( " should not be changed by removal of ears.\n");
		fi;
	fi;
    fi;
end;



##
## This method supports the definition of a consistent colouring.
##
AllEdgesOfSameType := function( n, type )
	return List( [1,2,3], i -> List( [1..n], j -> type ) );
end;


##
##	Test the general consistency of a wild simplicial surface.
##	
TestWildSimplicialSurfaceConsistency := function( surface, messageSurfaceOrigin )
	local gens, g, i, col;

	# Since a wild simplicial surface also has to be a simplicial surface:
	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	if not IsWildSimplicialSurface( surface ) then
		Print( messageSurfaceOrigin );
		Print( " is not a wild simplicial surface.\n");
	fi;


	# Test the generators
	gens := Generators( surface );
	if not IsList(gens) then
		Print( messageSurfaceOrigin );
		Print( ": Generators should be saved as list.\n");
	fi;
	if Length(gens) <> 3 then
		Print( messageSurfaceOrigin );
		Print( " should have exactly three generators.\n");
	fi;
	for g in gens do
		if not IsPerm(g) then
			Print( messageSurfaceOrigin );
			Print( ": Generator ");
			Print( g );
			Print( " is not a permutation.\n" );
		fi;
	od;


	# Test the group that is generated by the generators
	if GroupOfWildSimplicialSurface(surface) <> Group( Generators( surface ) ) then
		Print( messageSurfaceOrigin );
		Print( ": Generated group and generators don't match.\n");
	fi;


	# Test the vertex group
	if not IsFreeGroup( VertexGroup( surface )[1] ) then
		Print( messageSurfaceOrigin );
		Print( ": First component of vertex group is not a free group.\n");
	fi;
	if not IsList( VertexGroup(surface)[2] ) then
		Print( messageSurfaceOrigin );
		Print( ": Second component of vertex group has to be a list of relations.\n");
	fi;


	# Test ColoursOfEdges
	for i in [1..Length(ColoursOfEdges(surface))] do
		if i in Edges(surface) then
			if not IsBound( ColoursOfEdges(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": ColoursOfEdges should have an entry at " );
				Print( i );
				Print( ".\n");
			elif not ColoursOfEdges(surface)[i] in [1,2,3] then
				Print( messageSurfaceOrigin );
				Print( ": Entry " );
				Print( i );
				Print( " of ColoursOfEdges should lie in [1,2,3] but is actually ");
				Print( ColoursOfEdges(surface)[i] );
				Print( ".\n");
			else
				# Test associated convenience methods
				if ColoursOfEdges(surface)[i] <> ColourOfEdge(surface,i) then
					Print( messageSurfaceOrigin );
					Print( ": ColoursOfEdges is not consistent with ColourOfEdge at edge " );
					Print( i );
					Print( ".\n");
				elif ColoursOfEdges(surface)[i] <> ColourOfEdgeNC(surface,i) then
					Print( messageSurfaceOrigin );
					Print( ": ColoursOfEdges is not consistent with ColourOfEdgeNC at edge " );
					Print( i );
					Print( ".\n");
				fi;
			fi;
		else
			if IsBound( ColoursOfEdges(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": ColoursOfEdges should not have an entry at " );
				Print( i );
				Print( ".\n");
			fi;
		fi;
	od;


	# Test ColouredEdgesOfFaces
	for i in [1..Length(ColouredEdgesOfFaces(surface))] do
		if i in Faces(surface) then
			if not IsBound( ColouredEdgesOfFaces(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": ColouredEdgesOfFaces should have an entry at " );
				Print( i );
				Print( ".\n");
			elif not IsDenseList( ColouredEdgesOfFaces(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": ColouredEdgesOfFaces should have a dense list at position " );
				Print( i );
				Print( ".\n");
			elif Length( ColouredEdgesOfFaces(surface)[i] ) <> 3 then
				Print( messageSurfaceOrigin );
				Print( ": ColouredEdgesOfFaces should have a list of length 3 at position " );
				Print( i );
				Print( ".\n");
			elif EdgesOfFaces(surface)[i] <> Set( ColouredEdgesOfFaces(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": ColouredEdgesOfFaces of face " );
				Print( i );
				Print( " should be the edges of this face.\n");
			else
				# Test associated convenience methods
				for col in [1..3] do
					if ColouredEdgesOfFaces(surface)[i][col] <> ColouredEdgeOfFace( surface, i, col ) then
						Print( messageSurfaceOrigin );
						Print( ": ColouredEdgesOfFaces is incompatible with ColouredEdgeOfFace at face " );
						Print( i );
						Print( " and colour " );
						Print( col );
						Print( ".\n" );
					elif ColouredEdgesOfFaces(surface)[i][col] <> ColouredEdgeOfFaceNC( surface, i, col ) then
						Print( messageSurfaceOrigin );
						Print( ": ColouredEdgesOfFaces is incompatible with ColouredEdgeOfFaceNC at face " );
						Print( i );
						Print( " and colour " );
						Print( col );
						Print( ".\n" );
					fi;
				od;
			fi;
		else
			if IsBound( ColouredEdgesOfFaces(surface)[i] ) then
				Print( messageSurfaceOrigin );
				Print( ": ColouredEdgesOfFaces should not have an entry at " );
				Print( i );
				Print( ".\n");
			fi;
		fi;
	od;
	


	#TODO other tests.
end;

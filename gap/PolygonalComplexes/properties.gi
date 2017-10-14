#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2016
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################


#######################################
##
##      Invariants
##
InstallMethod( EulerCharacteristic, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return NrOfVertices(complex) - NrOfEdges(complex) + NrOfFaces(complex);
    end
);

InstallMethod( IsClosedSurface, "for a ramified polygonal surface",
    [IsRamifiedPolygonalSurface],
    function( ramSurf )
        return ForAll( List( FacesOfEdges(ramSurf), Size ), i -> i=2 );
    end
);
InstallOtherMethod( IsClosedSurface, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        if not IsRamifiedPolygonalSurface(complex) then
            Error("IsClosed: Given polygonal complex is not a ramified polygonal surface.");
        fi;
        return IsClosed(complex); # Call the function above
    end
);

##
##      End of invariants
##
#######################################


#######################################
##
##      Degree-based properties
##

InstallMethod( EdgeDegreesOfVertices, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return List( EdgesOfVertices(complex), Size );
    end
);
InstallMethod( EdgeDegreeOfVertexNC, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function( complex, vertex )
        return EdgeDegreesOfVertices(complex)[vertex];
    end
);
InstallMethod( EdgeDegreeOfVertex, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function( complex, vertex )
        __SIMPLICIAL_CheckVertex(complex, vertex, "EdgeDegreeOfVertex");
        return EdgeDegreeOfVertexNC(complex, vertex);
    end
);


InstallMethod( FaceDegreesOfVertices, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return List( FacesOfVertices(complex), Size );
    end
);
InstallMethod( FaceDegreeOfVertexNC, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function( complex, vertex )
        return FaceDegreesOfVertices(complex)[vertex];
    end
);
InstallMethod( FaceDegreeOfVertex, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function( complex, vertex )
        __SIMPLICIAL_CheckVertex(complex, vertex, "FaceDegreeOfVertex");
        return FaceDegreeOfVertexNC(complex, vertex);
    end
);


InstallMethod( VertexCounter, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local edgeDegrees, maxDeg, sym, d, pos;

        edgeDegrees := List( EdgesOfVertices(complex), Size );
        maxDeg := Maximum(edgeDegrees);
        sym := [];
        for d in [1..maxDeg] do
            pos := Size( Positions(edgeDegrees, d) );
            if pos <> 0 then
                sym[d] := pos;
            fi;
        od;

        return sym;
    end
);
InstallMethod( VertexCounter, "for a polygonal complex with computed EdgeCounter",
    [IsPolygonalComplex and HasEdgeCounter],
    function(complex)
        local symbol, i, j, edgeCounter, sum;

        symbol := [];
        edgeCounter := EdgeCounter(complex);
        for i in [1..Size(edgeCounter)] do
            sum := edgeCounter[i][i];   # This is counted twice
            for j in [1..Size(edgeCounter)] do
                sum := sum + edgeCounter[i][j];
            od;
            sum := sum/i;
            if sum <> 0 then
                symbol[i] := sum;
            fi;
        od;

        return symbol;
    end
);

InstallMethod( EdgeCounter, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local edgeDegrees, max, edge, symbol, degs;

        edgeDegrees := List( EdgesOfVertices(complex), Size );
        if NrOfEdges(complex) = 0 then
            return [];
        fi;
        max := Maximum( edgeDegrees ); # bigger than zero since edges exist

        # Set up the matrix
        symbol := List( [1..max], i -> List( [1..max], j -> 0 ) );
        for edge in Edges(complex) do
            degs := List( VerticesOfEdges(complex)[edge], v -> edgeDegrees[v] );
            symbol[ degs[1] ][ degs[2] ] := symbol[degs[1]][degs[2]] + 1;
            if degs[1] <> degs[2] then
                symbol[ degs[2] ][ degs[1] ] := symbol[degs[2]][degs[1]] + 1;
            fi;
        od;

        return symbol;
    end
);

##
##      End of degrees
##
#######################################


#######################################
##
##      Connectivity
##



##
##      End of connectivity
##
#######################################



#######################################
##
##      Orientability
##



##
##      End of orientability
##
#######################################




#######################################
##
##      Types of edges
##

InstallMethod( InnerEdges, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local facesOfEdges;

        facesOfEdges := FacesOfEdges(complex);
        return Filtered( Edges(complex), e -> Size(facesOfEdges[e]) = 2 );
    end
);
InstallMethod( IsInnerEdgeNC, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        return edge in InnerEdges(complex);
    end
);
InstallMethod( IsInnerEdge, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "IsInnerEdge");
        return IsInnerEdgeNC(complex, edge);
    end
);


InstallMethod( BoundaryEdges, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local facesOfEdges;

        facesOfEdges := FacesOfEdges(complex);
        return Filtered( Edges(complex), e -> Size(facesOfEdges[e]) = 1 );
    end
);
InstallMethod( IsBoundaryEdgeNC, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        return edge in BoundaryEdges(complex);
    end
);
InstallMethod( IsBoundaryEdge, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "IsBoundaryEdge");
        return IsBoundaryEdgeNC(complex, edge);
    end
);


InstallMethod( RamifiedEdges, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local facesOfEdges;

        facesOfEdges := FacesOfEdges(complex);
        return Filtered( Edges(complex), e -> Size(facesOfEdges[e]) > 2 );
    end
);
InstallMethod( IsRamifiedEdgeNC, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        return edge in RamifiedEdges(complex);
    end
);
InstallMethod( IsRamifiedEdge, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "IsRamifiedEdge");
        return IsRamifiedEdgeNC(complex, edge);
    end
);


##
##      End of edge types
##
#######################################

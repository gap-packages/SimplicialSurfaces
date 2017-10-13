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

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

# This file contains tests for the integrity of the edge coloured polygonal 
# complex category

BindGlobal( "__SIMPLICIAL_Test_EdgeColours", function()
    local edgesOfColours, coloursOfEdges, colComplex, complex;

    complex := SimplicialSurfaceByDownwardIncidence( 
        [[1,2],[1,3],[1,5],,[2,3],[2,5],[3,5]], 
        [[1,2,5],[2,3,7],[1,3,6],[5,6,7]] );
    coloursOfEdges := [1,2,4,,4,2,1];
    edgesOfColours := [[1,7],[2,6],,[3,5]];

    # ColoursOfEdges -> EdgesOfColours
    colComplex := Objectify( EdgeColouredPolygonalComplexType, rec() );
    SetPolygonalComplex(colComplex, complex);
    SetColoursOfEdges(colComplex, coloursOfEdges );
    SIMPLICIAL_TestAssert(EdgesOfColours(colComplex) = edgesOfColours);

    # EdgesOfColours -> ColoursOfEdges
    colComplex := Objectify( EdgeColouredPolygonalComplexType, rec() );
    SetPolygonalComplex(colComplex, complex);
    SetEdgesOfColours(colComplex, edgesOfColours );
    SIMPLICIAL_TestAssert(ColoursOfEdges(colComplex) = coloursOfEdges);
end);

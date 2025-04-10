#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2025
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

# This file contains tests for the integrity of the polygonal complex category



BindGlobal( "__SIMPLICIAL_Test_SourceRange", function()
    local mor, surf, cplx;

    surf := Cube();
    cplx := TriangularComplexByVerticesInFaces( [[1,2,3],[1,2,4],[1,2,5]] );

    # Source
    mor := Objectify( PolygonalComplexMorphismType, rec() );
    SetSourceSurface(mor, surf);
    SIMPLICIAL_TestAssert(SourceComplex(mor) = surf);

    mor := Objectify( PolygonalComplexMorphismType, rec() );
    SetSourceComplex(mor, surf);
    SIMPLICIAL_TestAssert(SourceSurface(mor) = surf);

    mor := Objectify( PolygonalComplexMorphismType, rec() );
    SetSourceComplex(mor, cplx);
    SIMPLICIAL_TestAssert(SourceSurface(mor) = fail);

    # Range
    mor := Objectify( PolygonalComplexMorphismType, rec() );
    SetRangeSurface(mor, surf);
    SIMPLICIAL_TestAssert(RangeComplex(mor) = surf);

    mor := Objectify( PolygonalComplexMorphismType, rec() );
    SetRangeComplex(mor, surf);
    SIMPLICIAL_TestAssert(RangeSurface(mor) = surf);

    mor := Objectify( PolygonalComplexMorphismType, rec() );
    SetRangeComplex(mor, cplx);
    SIMPLICIAL_TestAssert(RangeSurface(mor) = fail);
end);

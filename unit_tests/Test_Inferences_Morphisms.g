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

# This file contains tests for the integrity of the polygonal complex category



BindGlobal( "__SIMPLICIAL_Test_SourceRange", function()
    local mor, surf, cplx;

    surf := Cube();
    cplx := TriangularComplexByVerticesInFaces( [[1,2,3],[1,2,4],[1,2,5]] );

    # Source
    mor := Objectify( PolygonalComplexMorphismType, rec() );
    SetSourceSurface(mor, surf);
    Assert(0, SourceComplex(mor) = surf);

    mor := Objectify( PolygonalComplexMorphismType, rec() );
    SetSourceComplex(mor, surf);
    Assert(0, SourceSurface(mor) = surf);

    mor := Objectify( PolygonalComplexMorphismType, rec() );
    SetSourceComplex(mor, cplx);
    Assert(0, SourceSurface(mor) = fail);

    # Range
    mor := Objectify( PolygonalComplexMorphismType, rec() );
    SetRangeSurface(mor, surf);
    Assert(0, RangeComplex(mor) = surf);

    mor := Objectify( PolygonalComplexMorphismType, rec() );
    SetRangeComplex(mor, surf);
    Assert(0, RangeSurface(mor) = surf);

    mor := Objectify( PolygonalComplexMorphismType, rec() );
    SetRangeComplex(mor, cplx);
    Assert(0, RangeSurface(mor) = fail);
end);

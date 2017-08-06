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


##############################################################################
##
##            Attribute scheduler tests
##

##
## Test whether the connections between labelled access and *Of*-attributes
## are working properly.
##
BindGlobal("__SIMPLICIAL_Test_ConnectionLabelStarOfStar", function()
    local complex;

    # EdgesOfVertices
    complex := Objectify( PolygonalComplexType, rec() );
    SetEdgesOfVertices( complex, [[1,2], , [4,5,8], [2]] );
    Assert(0, Edges(complex)=[1,2,4,5,8]);
    Assert(0, Vertices(complex)=[1,3,4]);

    # FacesOfVertices
    complex := Objectify( PolygonalComplexType, rec() );
    SetFacesOfVertices( complex, [[1,2], , [4,5,8], [2]] );
    Assert(0, Faces(complex)=[1,2,4,5,8]);
    Assert(0, Vertices(complex)=[1,3,4]);

    # VerticesOfEdges
    complex := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfEdges( complex, [[1,2], , [4,5,8], [2]] );
    Assert(0, Vertices(complex)=[1,2,4,5,8]);
    Assert(0, Edges(complex)=[1,3,4]);

    # FacesOfEdges
    complex := Objectify( PolygonalComplexType, rec() );
    SetFacesOfEdges( complex, [[1,2], , [4,5,8], [2]] );
    Assert(0, Faces(complex)=[1,2,4,5,8]);
    Assert(0, Edges(complex)=[1,3,4]);

    # VerticesOfFaces
    complex := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfFaces( complex, [[1,2], , [4,5,8], [2]] );
    Assert(0, Vertices(complex)=[1,2,4,5,8]);
    Assert(0, Faces(complex)=[1,3,4]);

    # EdgesOfFaces
    complex := Objectify( PolygonalComplexType, rec() );
    SetEdgesOfFaces( complex, [[1,2], , [4,5,8], [2]] );
    Assert(0, Edges(complex)=[1,2,4,5,8]);
    Assert(0, Faces(complex)=[1,3,4]);
end;

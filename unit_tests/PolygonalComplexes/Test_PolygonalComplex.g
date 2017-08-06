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
end);

BindGlobal( "__SIMPLICIAL_Test_InvertIncidence", function()
    local complex, inc, invInc;

    inc := [ [1,2], , [2,3,5], [1], , [2,3] ];
    invInc := [ [1,4], [1,3,6], [3,6], , [3] ];

    # EdgesOfVertices
    complex := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfEdges(complex, inc);
    Assert(0, EdgesOfVertices(complex)=invInc);

    # FacesOfVertices
    complex := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfFaces(complex, inc);
    Assert(0, FacesOfVertices(complex)=invInc);

    # VerticesOfEdges
    complex := Objectify( PolygonalComplexType, rec() );
    SetEdgesOfVertices(complex, inc);
    Assert(0, VerticesOfEdges(complex)=invInc);

    # FacesOfEdges
    complex := Objectify( PolygonalComplexType, rec() );
    SetEdgesOfFaces(complex, inc);
    Assert(0, FacesOfEdges(complex)=invInc);

    # VerticesOfFaces
    complex := Objectify( PolygonalComplexType, rec() );
    SetFacesOfVertices(complex, inc);
    Assert(0, VerticesOfFaces(complex)=invInc);

    # EdgesOfFaces
    complex := Objectify( PolygonalComplexType, rec() );
    SetFacesOfEdges(complex, inc);
    Assert(0, EdgesOfFaces(complex)=invInc);
end);

BindGlobal( "__SIMPLICIAL_Test_TransitiveIncidence", function()
    local complex, a_of_b, b_of_c, a_of_c;

    a_of_b := [ , [1,3], [3,5,7], , [5,7] ];
    b_of_c := [ [2], [2,3,5], , [3,5], [2,5] ];
    a_of_c := [ [1,3], [1,3,5,7], , [3,5,7], , [1,3,5,7] ];

    # VerticesOfFaces
    complex := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfEdges( complex, a_of_b );
    SetEdgesOfFaces( complex, b_of_c);
    Assert(0, VerticesOfFaces(complex)=a_of_c);

    # FacesOfVertices
    complex := Objectify( PolygonalComplexType, rec() );
    SetFacesOfEdges( complex, a_of_b );
    SetEdgesOfVertices( complex, b_of_c );
    Assert(0, FacesOfVertices(complex)=a_of_c);
end);

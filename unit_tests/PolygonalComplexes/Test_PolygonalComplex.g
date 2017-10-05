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
    local complex, list, union, pos;

    list := [[1,2],,[4,5,8], [2]];
    union := [1,2,4,5,8];
    pos := [1,3,4];

    # EdgesOfVertices
    complex := Objectify( PolygonalComplexType, rec() );
    SetEdgesOfVertices( complex, list );
    Assert(0, Edges(complex)=union);
    Assert(0, Vertices(complex)=pos);

    # FacesOfVertices
    complex := Objectify( PolygonalComplexType, rec() );
    SetFacesOfVertices( complex, list );
    Assert(0, Faces(complex)=union);
    Assert(0, Vertices(complex)=pos);

    # VerticesOfEdges
    complex := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfEdges( complex, list );
    Assert(0, Vertices(complex)=union);
    Assert(0, Edges(complex)=pos);

    # FacesOfEdges
    complex := Objectify( PolygonalComplexType, rec() );
    SetFacesOfEdges( complex, list );
    Assert(0, Faces(complex)=union);
    Assert(0, Edges(complex)=pos);

    # VerticesOfFaces
    complex := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfFaces( complex, list );
    Assert(0, Vertices(complex)=union);
    Assert(0, Faces(complex)=pos);

    # EdgesOfFaces
    complex := Objectify( PolygonalComplexType, rec() );
    SetEdgesOfFaces( complex, list );
    Assert(0, Edges(complex)=union);
    Assert(0, Faces(complex)=pos);
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
    a_of_c := [ [1,3], [1,3,5,7], , [3,5,7], [1,3,5,7] ];

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

##
##  Test whether the inferences with cyclic orders work
##  Complex:          8
##                 2/   \3
##        1        /     \
##  9 ---------- 4        3
##  |            |        |
##  |5    I      |6  III  |7
##  |            |        |
##  1 ---------- 7        6
##        9        \     /
##                10\   /11
##                    2
BindGlobal( "__SIMPLICIAL_Test_CyclicOrderInferences", function()
    local complex, faces, verticesOfFaces, edgesOfFaces, verticesOfEdges, 
        edgesOfVertices, cyclicVertAsPerm, cyclicVertAsList, 
        cyclicEdgeAsPerm, cyclicEdgeAsList;

    faces := [1,3];
    verticesOfFaces := [ [1,4,7,9], , [2,3,4,6,7,8] ];
    edgesOfFaces := [ [1,5,6,9], , [2,3,6,7,10,11] ];
    verticesOfEdges := [ [4,9], [4,8], [3,8], , [1,9], [4,7], [3,6], , [1,7], [2,7], [2,6] ];
    edgesOfVertices := [ [5,9], [10,11], [3,7], [1,2,6], , [7,11], [6,9,10], [2,3], [1,5] ];
    
    cyclicVertAsList := [ [1,7,4,9], , [2,6,3,8,4,7] ];
    cyclicVertAsPerm := [ (1,7,4,9), , (2,6,3,8,4,7) ];
    cyclicEdgeAsList := [ [1,5,9,6], , [2,3,7,11,10,6] ];
    cyclicEdgeAsPerm := [ (1,5,9,6), , (2,3,7,11,10,6) ];

    #
    # generic computation
    #
    complex := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfFaces( complex, verticesOfFaces );
    SetEdgesOfFaces( complex, edgesOfFaces );
    SetVerticesOfEdges( complex, verticesOfEdges );
    SetEdgesOfVertices( complex, edgesOfVertices );
    Assert(0, CyclicVertexOrderOfFacesAsList(complex)=cyclicVertAsList);

    complex := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfFaces( complex, verticesOfFaces );
    SetEdgesOfFaces( complex, edgesOfFaces );
    SetVerticesOfEdges( complex, verticesOfEdges );
    SetEdgesOfVertices( complex, edgesOfVertices );
    Assert(0, CyclicEdgeOrderOfFacesAsList(complex)=cyclicEdgeAsList);

    #
    # conversion between vertices and edges
    #
    complex := Objectify( PolygonalComplexType, rec() );
    SetCyclicEdgeOrderOfFacesAsList( complex, cyclicEdgeAsList );
    SetVerticesOfEdges( complex, verticesOfEdges );
    SetVerticesOfFaces( complex, verticesOfFaces );
    Assert(0, CyclicVertexOrderOfFacesAsList(complex)=cyclicVertAsList);

    complex := Objectify( PolygonalComplexType, rec() );
    SetCyclicVertexOrderOfFacesAsList( complex, cyclicVertAsList );
    SetEdgesOfVertices( complex, edgesOfVertices );
    SetEdgesOfFaces( complex, edgesOfFaces );
    Assert(0, CyclicEdgeOrderOfFacesAsList(complex)=cyclicEdgeAsList);

    #
    # conversion between perm and list representations
    #
    complex := Objectify( PolygonalComplexType, rec() );
    SetCyclicVertexOrderOfFacesAsList( complex, cyclicVertAsList );
    Assert(0, CyclicVertexOrderOfFacesAsPerm(complex)=cyclicVertAsPerm);

    complex := Objectify( PolygonalComplexType, rec() );
    SetCyclicVertexOrderOfFacesAsPerm( complex, cyclicVertAsPerm );
    Assert(0, CyclicVertexOrderOfFacesAsList(complex)=cyclicVertAsList);

    complex := Objectify( PolygonalComplexType, rec() );
    SetCyclicEdgeOrderOfFacesAsList( complex, cyclicEdgeAsList );
    Assert(0, CyclicEdgeOrderOfFacesAsPerm(complex)=cyclicEdgeAsPerm);

    complex := Objectify( PolygonalComplexType, rec() );
    SetCyclicEdgeOrderOfFacesAsPerm( complex, cyclicEdgeAsPerm );
    Assert(0, CyclicEdgeOrderOfFacesAsList(complex)=cyclicEdgeAsList);


    #
    # inferences about *OfFaces
    #
    complex := Objectify( PolygonalComplexType, rec() );
    SetCyclicVertexOrderOfFacesAsList(complex, cyclicVertAsList);
    Assert(0, VerticesOfFaces(complex)=verticesOfFaces);

    complex := Objectify( PolygonalComplexType, rec() );
    SetCyclicEdgeOrderOfFacesAsList( complex, cyclicEdgeAsList );
    Assert(0, EdgesOfFaces(complex)=edgesOfFaces);

    #
    # inferences about Faces
    #
    complex := Objectify( PolygonalComplexType, rec() );
    SetCyclicEdgeOrderOfFacesAsList(complex, cyclicEdgeAsList);
    Assert(0, Faces(complex) = faces);

    complex := Objectify( PolygonalComplexType, rec() );
    SetCyclicEdgeOrderOfFacesAsPerm(complex, cyclicEdgeAsPerm);
    Assert(0, Faces(complex) = faces);

    complex := Objectify( PolygonalComplexType, rec() );
    SetCyclicVertexOrderOfFacesAsList(complex, cyclicVertAsList);
    Assert(0, Faces(complex)=faces);

    complex := Objectify( PolygonalComplexType, rec() );
    SetCyclicVertexOrderOfFacesAsPerm(complex, cyclicVertAsPerm);
    Assert(0, Faces(complex)=faces);
end);

##
## Test whether the inferences with edge-face-paths work
##

## single case
## Surface is the one from the manual.
BindGlobal( "__SIMPLICIAL_Test_EdgeFacePathSwitch", function()
    local paths, partitions, complex;
    
    paths := [ [ 11, 2, 12, 3, 13, 4, 14, 5 ], , , , , [ 15, 2, 11, 5, 19 ], [ 15, 2, 12, 3, 16 ],
        [ 16, 3, 17 ], [ 17, 3, 13, 4, 18 ], [ 18, 4, 14, 5, 19 ] ];
    partitions := [ [[ 11, 2, 12, 3, 13, 4, 14, 5 ]], , , , , [[ 15, 2, 11, 5, 19 ]], [[ 15, 2, 12, 3, 16 ]],
        [[ 16, 3, 17 ]], [[ 17, 3, 13, 4, 18 ]], [[ 18, 4, 14, 5, 19 ]] ];

    # from partitions to paths (first direct test, then check whether type can be inferred)
    complex := Objectify( PolygonalComplexType, rec() );
    SetEdgeFacePathPartitionsOfVertices( complex, partitions );
    SetIsPolygonalSurface( complex, true );
    Assert(0, EdgeFacePathsOfVertices(complex)=paths);

    complex := Objectify( PolygonalComplexType, rec() );
    SetEdgeFacePathPartitionsOfVertices( complex, partitions );
    Assert(0, EdgeFacePathsOfVertices(complex)=paths);

    # from paths to partitions (first direct test, then check whether type can be inferred)
    complex := Objectify( PolygonalComplexType, rec() );
    SetEdgeFacePathsOfVertices( complex, paths );
    SetIsRamifiedPolygonalSurface( complex, true );
    Assert(0, EdgeFacePathPartitionsOfVertices(complex)=partitions);

    complex := Objectify( PolygonalComplexType, rec() );
    SetEdgeFacePathsOfVertices( complex, paths );
    Assert(0, EdgeFacePathPartitionsOfVertices(complex)=partitions);

end);

## partition case
## Surface from manual
BindGlobal( "__SIMPLICIAL_Test_EdgeFacePathImplications", function()
    local paths, vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
        complex;

    vertices := [1,5,6,7,8,10,12];
    edges := [13,14,15,16,17,18,19,20,21,22,23];
    faces := [2,3,4,9,11];
    verticesOfEdges := [ ,,,,,,,,,,,,[5,6],[1,5],[5,7],[1,6],[6,7],[1,7],[1,8],[1,10],[1,12],[8,10],[10,12] ];
    edgesOfFaces := [ , [14,15,18],[13,14,16],[16,17,18],,,,,[19,20,22],,[20,21,23] ];
    paths := [ [ [ 14, 2, 18, 4, 16, 3 ], [ 19, 9, 20, 11, 21 ] ], , , ,
        [ [ 13, 3, 14, 2, 15 ] ], [ [ 13, 3, 16, 4, 17 ] ], [ [ 15, 2, 18, 4, 17 ] ],
        [ [ 19, 11, 22 ] ], , [ [ 22, 9, 20, 11, 23 ] ], , [ [ 21, 11, 23 ] ] ];

    complex := Objectify( PolygonalComplexType, rec() );
    SetEdgeFacePathPartitionsOfVertices( complex, paths );
    Assert(0, Vertices(complex)=vertices);
    Assert(0, Edges(complex)=edges);
    Assert(0, Faces(complex)=faces);
    Assert(0, VerticesOfEdges(complex)=verticesOfEdges);
    Assert(0, EdgesOfFaces(complex)=edgesOfFaces);

    complex := Objectify( PolygonalComplexType, rec() );
    SetVerticesOfEdges(complex, verticesOfEdges);
    SetEdgesOfFaces(complex, edgesOfFaces);
    Assert(0, EdgeFacePathPartitionsOfVertices(complex)=paths);
end);

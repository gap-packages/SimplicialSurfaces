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

## This chapter contains many diverse aspects of polygonal complexes.
## The current order may not be optimal, depending on what the future holds
#TODO current plan:
# 1) Invariants
# 2) connectivity
# 3) orientability
# 4) automorphism/isomorphism?
# 5) Properties of vertices
# 6) Properties of edges
# 7) Properties of faces (?);

#! @Chapter Properties of surfaces and complexes
#! @ChapterLabel Properties
#! 
#! TODO Introduction

#! @Section Invariants
#! @SectionLabel Properties_Invariants
#!
#! This section collects invariants of polygonal complexes.
#!
#! TODO

#! @Description
#! Return the <E>Euler-characteristic</E> of the given polygonal complex.
#! The Euler-characteristic is computed as
#! @BeginLogSession
#! gap> NrOfVertices(complex) - NrOfEdges(complex) + NrOfFaces(complex);
#! @EndLogSession
#! As an example, consider the following simplicial surface:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex};
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> complex := SimplicialSurfaceByVerticesInFaces( 6, 5, 
#! >                [ [1,2,3], [1,3,4], [1,4,5], [1,5,6], [1,2,6] ] );;
#! gap> NrOfVertices(complex);
#! 6
#! gap> NrOfEdges(complex);
#! 10
#! gap> NrOfFaces(complex);
#! 5
#! gap> EulerCharacteristic(complex);
#! 1
#! @EndExampleSession
#! 
#! @Returns an integer
#! @Arguments complex
DeclareAttribute( "EulerCharacteristic", IsPolygonalComplex );


#! @Description
#! Return the <E>vertex counter</E> of the given polygonal complex.
#! The vertex counter is a list that counts how many vertices are incident
#! to how many edges. If the entry at position <A>pos</A> is bound, it
#! contains the number of vertices that are incident to exactly <A>pos</A>
#! edges.
#!
#! As an example, consider the following simplicial surface:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex};
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> complex := SimplicialSurfaceByVerticesInFaces( 6, 5, 
#! >                [ [1,2,3], [1,3,4], [1,4,5], [1,5,6], [1,2,6] ] );;
#! gap> List( EdgesOfVertices(complex), Size );
#! [ 5, 3, 3, 3, 3, 3 ]
#! gap> VertexCounter(complex);
#! [ , , 5, , 1 ]
#! @EndExampleSession
#!
#! @Returns a list of positive integers
#! @Arguments complex
DeclareAttribute( "VertexCounter", IsPolygonalComplex );


#! @Description
#! Return the <E>edge counter</E> of the given polygonal complex.
#! The edge counter is a symmetric matrix <M>M</M> such that the entry
#! <M>M[i,j]</M> counts the number of edges such that the two vertices
#! of the edge are respectively incident to <M>i</M> and <M>j</M> edges.
#!
#! As an example, consider the following simplicial surface:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex};
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> complex := SimplicialSurfaceByVerticesInFaces( 6, 5, 
#! >                [ [1,2,3], [1,3,4], [1,4,5], [1,5,6], [1,2,6] ] );;
#! gap> EdgeCounter(complex);
#! [ [ , , , , ], [ , , , , ], [ , , 5, , 5 ], [ , , , , ], [ , , 5, , ] ]
#! @EndExampleSession
#!
#! @Returns a matrix of positive integers
#! @Arguments complex
DeclareAttribute( "EdgeCounter", IsPolygonalComplex );

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
#!
#! We will showcase these properties on several examples. One of them is the
#! <E>five-star</E>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!     \input{Image_FiveTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> fiveStar := SimplicialSurfaceByVerticesInFaces( [1,2,3,5,7,11], 5,
#! >                [ [1,2,3], [1,3,5], [1,5,7], [1,7,11], [1,2,11] ] );;
#! @EndExampleSession
#TODO projective plane on four faces?

#! @Section Invariants
#! @SectionLabel Properties_Invariants
#!
#! This section collects invariants of polygonal complexes.
#!
#! TODO
#!

#! @Description
#! Return the <E>Euler-characteristic</E> of the given polygonal complex.
#! The Euler-characteristic is computed as
#! @BeginLogSession
#! gap> NrOfVertices(complex) - NrOfEdges(complex) + NrOfFaces(complex);
#! @EndLogSession
#! As an example, consider the five-star that was introduced at the
#! start of chapter <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> NrOfVertices(fiveStar);
#! 6
#! gap> NrOfEdges(fiveStar);
#! 10
#! gap> NrOfFaces(fiveStar);
#! 5
#! gap> EulerCharacteristic(fiveStar);
#! 1
#! @EndExampleSession
#! 
#! @Returns an integer
#! @Arguments complex
DeclareAttribute( "EulerCharacteristic", IsPolygonalComplex );


#! @Description
#! Check whether the given ramified polygonal surface is <E>closed</E>.
#! A ramified surface is closed if every edge is incident to <E>exactly</E> 
#! two
#! faces (whereas a polygonal complex is a ramified polygonal surface if 
#! every edge is incident to <E>at most</E> two faces).
#!
#! For example, the platonic solids are closed.
#! @ExampleSession
#! gap> IsClosed( Octahedron() );
#! true
#! gap> IsClosed( Dodecahedron() );
#! true
#! @EndExampleSession
#! In contrast, the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/> is not closed.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> IsClosed(fiveStar);
#! false
#! @EndExampleSession
#!
#! @Arguments ramSurf
DeclareProperty( "IsClosedSurface", IsRamifiedPolygonalSurface );
## We can't use IsClosed since this is blocked by the orb-package


#! @Section Degree-based properties and invariants
#! @SectionLabel Properties_Degrees

#TODO there is no good place for degrees, it seems.
# separating them into an own section feels weird, but putting them under 
# vertex properties feels weird as well (since there are methods like 
# InnerVertices etc. that feel too connected to separate them by the degrees..);

#TODO intro
#! This section contains properties and invariants that are based on the
#! degrees of the vertices. We have to distinguish two different definitions
#! for the degree of a vertex - we can either count the number of incident
#! edges of the number of incident faces.
#!
#! These two definitions are distinguished by calling them 
#! <K>EdgeDegreesOfVertices</K> and <K>FaceDegreesOfVertices</K>.
#! 
#TODO explain sorted/unsorted
#TODO mention vertexCounter, edgeCounter


#! @BeginGroup
#! @Description
#! The method <K>EdgeDegreeOfVertex</K>(<A>complex</A>, <A>vertex</A>) 
#! returns the <E>edge-degree</E> of the given vertex in the given
#! polygonal complex, i.e. the number of incident edges. The NC-version does
#! not check whether <A>vertex</A> is a vertex of <A>complex</A>.
#!
#! The attribute <K>EdgeDegreesOfVertices</K>(<A>complex</A>) collects all of
#! these degrees in a list that is indexed by the vertices, i.e.
#! <K>EdgeDegreesOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>EdgeDegreeOfVertex</K>(<A>complex</A>, <A>vertex</A>). All other
#! positions of this list are not bound.
#!
#! As an example, consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!    \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!       \input{Image_FiveTrianglesInCycle.tex}
#!    \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> EdgeDegreeOfVertex( fiveStar, 1 );
#! 5
#! gap> EdgeDegreeOfVertex( fiveStar, 5 );
#! 3
#! gap> EdgeDegreesOfVertices( fiveStar );
#! [ 5, 3, 3, , 3, , 3, , , , 3 ]
#! @EndExampleSession
#!
#! @Returns a list of positive integers
#! @Arguments complex
DeclareAttribute( "EdgeDegreesOfVertices", IsPolygonalComplex );
#! @Returns a positive integer
#! @Arguments complex, vertex
DeclareOperation( "EdgeDegreeOfVertex", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "EdgeDegreeOfVertexNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup
#! @Description
#! The method <K>FaceDegreeOfVertex</K>(<A>complex</A>, <A>vertex</A>) 
#! returns the <E>face-degree</E> of the given vertex in the given
#! polygonal complex, i.e. the number of incident faces. The NC-version does
#! not check whether <A>vertex</A> is a vertex of <A>complex</A>.
#!
#! The attribute <K>FaceDegreesOfVertices</K>(<A>complex</A>) collects all of
#! these degrees in a list that is indexed by the vertices, i.e.
#! <K>FaceDegreesOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>FaceDegreeOfVertex</K>(<A>complex</A>, <A>vertex</A>). All other
#! positions of this list are not bound.
#!
#! As an example, consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!    \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!       \input{Image_FiveTrianglesInCycle.tex}
#!    \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> FaceDegreeOfVertex( fiveStar, 1 );
#! 5
#! gap> FaceDegreeOfVertex( fiveStar, 5 );
#! 2
#! gap> EdgeDegreesOfVertices( fiveStar );
#! [ 5, 2, 2, , 2, , 2, , , , 2 ]
#! @EndExampleSession
#!
#! @Returns a list of positive integers
#! @Arguments complex
DeclareAttribute( "FaceDegreesOfVertices", IsPolygonalComplex );
#! @Returns a positive integer
#! @Arguments complex, vertex
DeclareOperation( "FaceDegreeOfVertex", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "FaceDegreeOfVertexNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup




#! @Description
#! Return the <E>vertex counter</E> of the given polygonal complex.
#! The vertex counter is a list that counts how many vertices are incident
#! to how many edges. If the entry at position <A>pos</A> is bound, it
#! contains the number of vertices that are incident to exactly <A>pos</A>
#! edges.
#!
#! As an example, consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> List( EdgesOfVertices(complex), Size );
#! [ 5, 3, 3, , 3, , 3, , , , 3 ]
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
#! As an example, consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> EdgeCounter(complex);
#! [ [ , , , , ], [ , , , , ], [ , , 5, , 5 ], [ , , , , ], [ , , 5, , ] ]
#! @EndExampleSession
#!
#! @Returns a matrix of positive integers
#! @Arguments complex
DeclareAttribute( "EdgeCounter", IsPolygonalComplex );


#! @Section Connectivity
#! @SectionLabel Properties_Connectivity
#!
#! This section contains methods that deal with the connectivity of polygonal
#! complexes (a generalisation of simplicial surfaces, compare chapter 
#! <Ref Chap="PolygonalStructures"/>). More specifically it contains these
#! capabilities:
#! * Determine if a polygonal complex is (strongly) connected TODO ref
#! * Determine the (strongly) connected components of a polygonal complex TODO ref
#!
#! It is important to note that there are actually two different notions of
#! connectivity (for non-surfaces), as can be seen in the following example:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_ButterflyOfTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> butterfly := RamifiedSimplicialSurface( 7, 4,
#! > [ [1,2,3], [1,6,7], [1,3,4], [1,5,6] ]);;
#! @EndExampleSession
#! Under the usual definition of connectivity (i.e. the incidence graph from
#! TODO is connected) this example is
#! connected.
#! @ExampleSession
#! gap> IsConnected( butterfly );
#! true
#! @EndExampleSession
#! But in several situations it is convenient to regard this
#! example as disconnected, with the following connected components:
#! <Alt Only="TikZ">
#!    \begin{tikzpicture}[scale=2, vertexStyle, edgeStyle=nolabels, faceStyle]
#!       \def\swapColors{1}
#!       \input{Image_ButterflyOfTriangles.tex}
#!    \end{tikzpicture}
#! </Alt>
#! This notion of connectivity is called <E>strong connectivity</E>. 
#! A polygonal complex is strongly connected if and only if the polygonal 
#! complex without
#! its vertices is connected.
#! @ExampleSession
#! gap> IsStronglyConnected( butterfly );
#! false
#! @EndExampleSession
#!

#TODO examples for ConnectedComponents

#! @BeginGroup IsConnected
#! @Description
#! Check whether the given polygonal complex is connected. A polygonal complex
#! is connected if and only if its incidence graph (compare TODO) is 
#! connected.
#!
#! For example, consider the ramified simplicial surface from the start of 
#! section <Ref Sect="Section_Properties_Connectivity"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle, edgeStyle=nolabels, faceStyle]
#!     \input{Image_ButterflyOfTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> IsConnected( butterfly );
#! true
#! @EndExampleSession
#! 
#! @Arguments complex
DeclareProperty( "IsConnected", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup ConnectedComponents
#! @Description
#! Return a list of the connected components of the given polygonal complex 
#! (as polygonal complexes). They correspond to the connected components
#! of the incidence graph (compare TODO).
#!
#! If a face of the polygonal complex is given as an additional argument,
#! only the connected component containing that face is returned. The 
#! NC-version does not check if <A>face</A> is a face of <A>complex</A>.
#!
#! @Returns a list of polygonal complexes
#! @Arguments complex
DeclareOperation( "ConnectedComponentsOfComplex", [IsPolygonalComplex] );
#! @Arguments complex
DeclareAttribute( "ConnectedComponentsAttributeOfPolygonalComplex", IsPolygonalComplex );
#! @Returns a polygonal complex
#! @Arguments complex, face
DeclareOperation( "ConnectedComponentOfFace", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "ConnectedComponentOfFaceNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup IsStronglyConnected
#! @Description
#! Check whether the given polygonal complex is strongly connected. A polygonal 
#! complex
#! is strongly connected if and only if one of the following equivalent 
#! conditions hold:
#! * It is still connected after removal of all vertices. 
#! * For each pair of faces there is an edge-face-path (compare section 
#!   <Ref Sect="Section_Access_OrderedVertexAccess"/>) that connects them.
#!
#! For example, consider the ramified simplicial surface from the start of 
#! section <Ref Sect="Section_Properties_Connectivity"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle, edgeStyle=nolabels, faceStyle]
#!     \input{Image_ButterflyOfTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> IsStronglyConnected( butterfly );
#! false
#! @EndExampleSession
#! 
#! @Arguments complex
DeclareProperty( "IsStronglyConnected", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup StronglyConnectedComponents
#! @Description
#! Return a list of the strongly connected components of the given polygonal 
#! complex 
#! (as polygonal complexes).
#!
#! If a face of the polygonal complex is given as an additional argument,
#! only the strongly connected component containing that face is returned. The 
#! NC-version does not check if <A>face</A> is a face of <A>complex</A>.
#!
#! @Returns a list of polygonal complexes
#! @Arguments complex
DeclareOperation( "StronglyConnectedComponents", [IsPolygonalComplex] );
#! @Arguments complex
DeclareAttribute( "StronglyConnectedComponentsAttributeOfPolygonalComplex", IsPolygonalComplex );
#! @Returns a polygonal complex
#! @Arguments complex, face
DeclareOperation( "StronglyConnectedComponentOfFace", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "StronglyConnectedComponentOfFaceNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#TODO orientability

#TODO automorphism/isomorphism
# automorphism group
# isomorphism test
# refer back to incidence graph

#! @Section Types of vertices
#! @SectionLabel Properties_VertexTypes
#! 
#TODO improve this description
#! The vertices of a polygonal complex (defined in 
#! <Ref Sect="PolygonalStructures_complex"/>) can be in different local
#! positions. This can be seen in the example of the five-star (which was
#! introduced at the start of chapter <Ref Chap="Chapter_Properties"/>):
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!     \input{Image_FiveTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! The vertex 1 is the only vertex that is completely surrounded by faces. It
#! is called an <E>inner vertex</E> while the other vertices of the five-star
#! are <E>boundary vertices</E>. This classifies all vertices of a polygonal
#! surface.
#!
#! In general there are more than these two possibilities. In the case
#TODO what are RamifiedVertices? More than one edge-face-path (even if some of them are open/closed);
# or more general: vertex of a ramified edge? Should the vertex of a ramified edge
# be ramified (probably not). How should it be called?
#TODO to make this possible, we have to generalize EdgeFacePaths -> also allow fail

# TODO properties edges

#! @Section Types of edges
#! @SectionLabel Properties_EdgeTypes
#!
#TODO improve
#! The edges of a polygonal complex (defined in 
#! <Ref Sect="PolygonalStructures_complex"/>) can be in different local
#! positions. This can be seen in the example of the five-star (which was
#! introduced at the start of chapter <Ref Chap="Chapter_Properties"/>):
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! The edges that are incident to the vertex 1 are different from the other 
#! edges since they lie "inside" the surface. Edges with two incident faces
#! are called <E>inner edges</E> while edges with only one incident face are
#! called <E>boundary edges</E>.
#!
#! For ramified polygonal surfaces, only those two edge types can appear
#! (by definition there are one or two faces incident to each edge). For
#! general polygonal complexes there might appear a third case (more than
#! two faces incident to an edge). This is exemplified in the following
#! example:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle=nolabels, edgeStyle=nolabels, faceStyle=nolabels]
#!     \input{Image_ThreeBranchingTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! Edges with more than two incident faces are called <E>ramified edges</E>.
#!

#! @BeginGroup
#! @Description
#! Return the set of all <E>inner edges</E> of the given polygonal complex.
#! An inner edge is an edge that is incident to exactly two faces.
#!
#! The method <K>IsInnerEdge</K> checks whether the given edge is an inner
#! edge of the given polygonal complex. The NC-version does not check whether
#! <A>edge</A> is an edge of <A>complex</A>.
#!
#! Consider the five-star from the start of chapter 
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_FiveTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> IsInnerEdge( fiveStar, 4 );
#! true
#! gap> IsInnerEdge( fiveStar, 10 );
#! false
#! gap> InnerEdges( fiveStar );
#! [ 1, 2, 3, 4, 5 ]
#! @EndExampleSession
#!
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "InnerEdges", IsPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, edge
DeclareOperation( "IsInnerEdge", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, edge
DeclareOperation( "IsInnerEdgeNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup
#! @Description
#! Return the set of all <E>boundary edges</E> of the given polygonal complex.
#! A boundary edge is an edge that is incident to exactly one face.
#!
#! The method <K>IsBoundaryEdge</K> checks whether the given edge is a 
#! boundary
#! edge of the given polygonal complex. The NC-version does not check whether
#! <A>edge</A> is an edge of <A>complex</A>.
#!
#! Consider the five-star from the start of chapter 
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_FiveTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> IsBoundaryEdge( fiveStar, 4 );
#! false
#! gap> IsBoundaryEdge( fiveStar, 10 );
#! true
#! gap> BoundaryEdges( fiveStar );
#! [ 6, 7, 8, 9, 10 ]
#! @EndExampleSession
#!
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "BoundaryEdges", IsPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, edge
DeclareOperation( "IsBoundaryEdge", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, edge
DeclareOperation( "IsBoundaryEdgeNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! Return the set of all <E>ramified edges</E> of the given polygonal complex.
#! A ramified edge is an edge that is incident to at least three faces.
#!
#! The method <K>IsRamifiedEdge</K> checks whether the given edge is a 
#! ramified
#! edge of the given polygonal complex. The NC-version does not check whether
#! <A>edge</A> is an edge of <A>complex</A>.
#!
#! TODO example?
#!
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "RamifiedEdges", IsPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, edge
DeclareOperation( "IsRamifiedEdge", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, edge
DeclareOperation( "IsRamifiedEdgeNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup

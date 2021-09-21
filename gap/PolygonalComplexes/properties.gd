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

#######
## This has to be after the incidence chapter since it heavily relies on it.
## Since it consists of disconnected ideas it is no big issue if it comes
## after the constuctors-chapter that inclines the reader to skipping.
#######

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
#!
#! Another one is the <E>triforce</E>:
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_Triforce.tex}
#!  \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> triforce := PolygonalComplexByVerticesInFaces([[1,2,3],[2,4,5],[3,5,6]]);;
#! @EndExampleSession
#TODO projective plane on four faces?

#! @Section Invariants
#! @SectionLabel Properties_Invariants
#!
#! This section collects invariants of (twisted) polygonal complexes.
#!
#! TODO
#!

#! @BeginGroup EulerCharacteristic
#! @Description
#! Return the <E>Euler-characteristic</E> of the given twisted polygonal complex.
#! The Euler-characteristic is computed as
#! @BeginLogSession
#! gap> NumberOfVertices(complex) - NumberOfEdges(complex) + NumberOfFaces(complex);
#! @EndLogSession
#! As an example, consider the five-star that was introduced at the
#! start of chapter <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> NumberOfVertices(fiveStar);
#! 6
#! gap> NumberOfEdges(fiveStar);
#! 10
#! gap> NumberOfFaces(fiveStar);
#! 5
#! gap> EulerCharacteristic(fiveStar);
#! 1
#! @EndExampleSession
#! 
#! @Returns an integer
#! @Arguments complex
DeclareAttribute( "EulerCharacteristic", IsTwistedPolygonalComplex );
#! @EndGroup


#! @BeginGroup IsClosedSurface
#! @Description
#! Check whether the given twisted polygonal complex without edge ramifications is 
#! <E>closed</E>.
#! A twisted polygonal complex without edge ramifications is closed if every edge is 
#! incident to <E>exactly</E> 
#! two
#! faces (whereas the absence of edge ramifications only means that
#! every edge is incident to <E>at most</E> two faces).
#!
#! For example, the platonic solids are closed.
#! @ExampleSession
#! gap> IsClosedSurface( Octahedron() );
#! true
#! gap> IsClosedSurface( Dodecahedron() );
#! true
#! @EndExampleSession
#! In contrast, the five-star and the triforce from the start of chapter
#! <Ref Chap="Chapter_Properties"/> are not closed.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> IsClosedSurface(fiveStar);
#! false
#! @EndExampleSession
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_Triforce.tex}
#!  \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> IsClosedSurface(triforce);
#! false
#! @EndExampleSession
#!
#! @Arguments ramSurf
DeclareProperty( "IsClosedSurface", IsTwistedPolygonalComplex and IsNotEdgeRamified );
## We can't use IsClosed since this is blocked by the orb-package
#! @EndGroup


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
#TODO mention vertexCounter, edgeCounter


#! @BeginGroup EdgeDegreesOfVertices
#! @Description
#! The method <K>EdgeDegreeOfVertex</K>(<A>complex</A>, <A>vertex</A>) 
#! returns the <E>edge-degree</E> of the given vertex in the given
#! twisted polygonal complex, i.e. the number of incident edges. The NC-version does
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
#! [ 5, 3, 3,, 3,, 3,,,, 3 ]
#! @EndExampleSession
#!
#! @Returns a list of positive integers
#! @Arguments complex
DeclareAttribute( "EdgeDegreesOfVertices", IsTwistedPolygonalComplex );
#! @Returns a positive integer
#! @Arguments complex, vertex
DeclareOperation( "EdgeDegreeOfVertex", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "EdgeDegreeOfVertexNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup FaceDegreesOfVertices
#! @Description
#! The method <K>FaceDegreeOfVertex</K>(<A>complex</A>, <A>vertex</A>) 
#! returns the <E>face-degree</E> of the given vertex in the given
#! twisted polygonal complex, i.e. the number of incident faces. The NC-version does
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
#! gap> FaceDegreesOfVertices( fiveStar );
#! [ 5, 2, 2,, 2,, 2,,,, 2 ]
#! gap> DegreesOfVertices( fiveStar );
#! [ 5, 2, 2,, 2,, 2,,,, 2 ]
#! @EndExampleSession
#!
#! For convenience, these methods can also be called by the names
#! <K>DegreesOfVertices</K> and <K>DegreeOfVertex</K>.
#!
#! @Returns a list of positive integers
#! @Arguments complex
DeclareAttribute( "FaceDegreesOfVertices", IsTwistedPolygonalComplex );
#! @Returns a positive integer
#! @Arguments complex, vertex
DeclareOperation( "FaceDegreeOfVertex", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "FaceDegreeOfVertexNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Returns a list of positive integers
#! @Arguments complex
DeclareAttribute( "DegreesOfVertices", IsTwistedPolygonalComplex );
#! @Returns a positive integer
#! @Arguments complex, vertex
DeclareOperation( "DegreeOfVertex", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "DegreeOfVertexNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup TotalDefect
#! @Description
#! Return the <E>total (inner) defect</E> of the given simplicial surface.
#! The defect of an inner vertex is <M>6 - faceDegree</M> and the defect of
#! a boundary vertex is <M>3 - faceDegree</M>.
#!
#! The <E>total defect</E> is the sum over all defects.
#! The <E>total inner defect</E> is the sum over the defects of all inner 
#! vertices.
#! As an example, consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!    \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!       \input{Image_FiveTrianglesInCycle.tex}
#!    \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> TotalDefect( fiveStar );
#! 6
#! gap> TotalInnerDefect( fiveStar );
#! 1
#! @EndExampleSession
#!
#! @Returns an integer
#! @Arguments surface
DeclareAttribute( "TotalDefect", IsSimplicialSurface );
#! @Arguments surface
DeclareAttribute( "TotalInnerDefect", IsSimplicialSurface );
#! @EndGroup




#! @BeginGroup VertexCounter
#! @Description
#! Return the <E>vertex counter</E> of the given twisted polygonal complex.
#! The vertex counter is a list that counts how many vertices are incident
#! to how many faces. It is a list of pairs <E>[degree, number]</E>, where
#! <E>number</E> counts the number of vertices with exactly <E>degree</E>
#! incident faces.
#!
#! As an example, consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> List( FacesOfVertices(fiveStar), Size );
#! [ 5, 2, 2,, 2,, 2,,,, 2 ]
#! gap> VertexCounter(fiveStar);
#! [ [ 2, 5 ], [ 5, 1 ] ]
#! @EndExampleSession
#!
#! @Returns a list of pairs of positive integers
#! @Arguments complex
DeclareAttribute( "VertexCounter", IsTwistedPolygonalComplex );
#! @EndGroup


#! @Description
#! Return the <E>edge counter</E> of the given twisted polygonal complex.
#! The edge counter is a list of pairs <E>[degreeList, number]</E>,
#! where <E>number</E> counts the number of edges whose vertices
#! are incident to <E>degreeList[1]</E> and <E>degreeList[2]</E> faces,
#! respectively. The list <E>degreeList</E> is always sorted but may
#! contain duplicates.
#!
#! As an example, consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> EdgeCounter(fiveStar);
#! [ [ [ 2, 2 ], 5 ], [ [ 2, 5 ], 5 ] ]
#! @EndExampleSession
#!
#! @Returns a list of pairs
#! @Arguments complex
DeclareAttribute( "EdgeCounter", IsTwistedPolygonalComplex );


#! @Description
#! Return the <E>face counter</E> of the given twisted polygonal complex.
#! The face counter is a list of pairs <E>[degreeList, number]</E>,
#! where <E>number</E> counts the number of faces whose vertes degrees
#! match <E>degreeList</E>, i.e. for every vertex there is exactly one
#! entry of <E>degreeList</E> such that the vertex is incident this 
#! number of faces.
#!
#! The <E>degreeList</E> is always sorted but may contain duplicates.
#!
#! As an example, consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> FaceCounter(fiveStar);
#! [ [ [ 2, 2, 5 ], 5 ] ]
#! @EndExampleSession
#!
#! @Returns a list of pairs
#! @Arguments complex
DeclareAttribute( "FaceCounter", IsTwistedPolygonalComplex );


#! @Section Types of faces
#! @SectionLabel Properties_FaceTypes
#!
#! The faces in a (twisted) polygonal complex are (twisted) polygons. In
#! particular there can be polygons with different numbers of vertices,
#! i.e. triangle, quadrangles, and so on.
#!
#! TODO examples


#! @Description
#! Check whether all polygons in this twisted polygonal complex have the same number
#! of vertices.
#! @Arguments complex
DeclareProperty( "IsFaceHomogeneous", IsTwistedPolygonalComplex );


#! @BeginGroup IsTriangular
#! @Description
#! Check whether all polygons in this twisted polygonal complex are triangles.
#! @Arguments complex
DeclareProperty( "IsTriangular", IsTwistedPolygonalComplex );
InstallTrueMethod(IsFaceHomogeneous, IsTriangular);
#! @EndGroup


#! @Description
#! Check whether all polygons in this twisted polygonal complex are quadrangles.
#! @Arguments complex
DeclareProperty( "IsQuadrangular", IsTwistedPolygonalComplex );
InstallTrueMethod(IsFaceHomogeneous, IsQuadrangular);



#! @Section Types of edges
#! @SectionLabel Properties_EdgeTypes
#!
#TODO improve
#! The edges of a twisted polygonal complex (defined in 
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
#! If edge ramifications are not allowed, only those two edge types can appear
#! (by definition there are one or two faces incident to each edge). In 
#! general there might appear a third case (more than
#! two faces incident to an edge). This is exemplified in the following
#! example:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexPlain=nolabels, edgeStyle=nolabels, faceStyle=nolabels]
#!      \def\emphEdge{1}
#!      \input{Image_ThreeBranchingTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! Edges with more than two incident faces are called <E>ramified edges</E>.
#!

#! @BeginGroup InnerEdges
#! @Description
#! Return the set of all inner edges of the given twisted polygonal complex.
#! An <E>inner edge</E> is an edge that is incident to exactly two faces.
#!
#! The method <K>IsInnerEdge</K> checks whether the given edge is an inner
#! edge of the given twisted polygonal complex. The NC-version does not check whether
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
DeclareAttribute( "InnerEdges", IsTwistedPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, edge
DeclareOperation( "IsInnerEdge", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, edge
DeclareOperation( "IsInnerEdgeNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup BoundaryEdges
#! @Description
#! Return the set of all boundary edges of the given twisted polygonal complex.
#! A <E>boundary edge</E> is an edge that is incident to exactly one face.
#!
#! The method <K>IsBoundaryEdge</K> checks whether the given edge is a 
#! boundary
#! edge of the given twisted polygonal complex. The NC-version does not check whether
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
DeclareAttribute( "BoundaryEdges", IsTwistedPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, edge
DeclareOperation( "IsBoundaryEdge", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, edge
DeclareOperation( "IsBoundaryEdgeNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @BeginGroup RamifiedEdges
#! @Description
#! Return the set of all ramified edges of the given twisted polygonal complex.
#! A <E>ramified edge</E> is an edge that is incident to at least three faces.
#!
#! The method <K>IsRamifiedEdge</K> checks whether the given edge is a 
#! ramified
#! edge of the given twisted polygonal complex. The NC-version does not check whether
#! <A>edge</A> is an edge of <A>complex</A>.
#!
#! We illustrate it on the following triangular complex:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle, edgeStyle, faceStyle]
#!      \input{Image_ThreeBranchingTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> branch := TriangularComplexByDownwardIncidence(
#! >        [[2,3],[1,3],[2,4],[1,4],[2,5],[1,5],[1,2]], 
#! >        [[1,2,7],[3,4,7],[5,6,7]]);;
#! gap> IsRamifiedEdge(branch, 1);
#! false
#! gap> IsRamifiedEdge(branch, 7);
#! true
#! gap> RamifiedEdges(branch);
#! [ 7 ]
#! @EndExampleSession
#!
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "RamifiedEdges", IsTwistedPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, edge
DeclareOperation( "IsRamifiedEdge", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, edge
DeclareOperation( "IsRamifiedEdgeNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @Section Types of vertices
#! @SectionLabel Properties_VertexTypes
#! 
#TODO improve this description
#! The vertices of a twisted polygonal complex (defined in 
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
#! are <E>boundary vertices</E>. This classifies all vertices of a twisted polygonal surface.
#!
#! In general there are more than these two possibilities. In the case of
#! vertex ramifications (defined in <Ref Sect="PolygonalStructures_surface"/>)
#! there can be 
#! <E>ramified vertices</E>:
#! <Alt Only="TikZ">
#!    \begin{tikzpicture}[vertexPlain=nolabels, edgeStyle=nolabels, faceStyle=nolabels]
#!      \def\emphVertex{1}
#!      \input{Image_TwoJoinedTetrahedrons.tex}
#!    \end{tikzpicture}
#! </Alt>
#!
#! In the case of edge ramifications (also defined in 
#! <Ref Sect="PolygonalStructures_surface"/>) there might be edges that are 
#! incident to more than two faces.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexNormal=nolabels, edgeStyle=nolabels, faceStyle=nolabels]
#!      \def\emphVertex{1}
#!      \input{Image_ThreeBranchingTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! Vertices that are incident to such an edge are called 
#! <E>chaotic vertices</E>.

#! @BeginGroup InnerVertices
#! @Description
#! Return the set of all inner vertices. 
#! 
#! A vertex is an inner vertex if and only if there is exactly
#! one closed umbrella-path around it (compare section 
#! <Ref Sect="Section_Access_OrderedVertexAccess"/> for the definition of
#! umbrella-paths).
#!
#! The method <K>IsInnerVertex</K> checks whether the given vertex is an inner
#! vertex of the given twisted polygonal complex. The NC-version does not check whether
#! <A>vertex</A> is an vertex of <A>complex</A>.
#! 
#! Consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex}
#!  \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> IsInnerVertex( fiveStar, 1 );
#! true
#! gap> IsInnerVertex( fiveStar, 3 );
#! false
#! gap> InnerVertices( fiveStar );
#! [ 1 ]
#! @EndExampleSession
#! 
#! For the special case of a twisted polygonal surface the inner vertices have an
#! easier characterisation: a vertex is
#! an inner vertex if and only if every incident edge is incident to exactly
#! two faces (that is, if it only incident to inner edges 
#! (<Ref Subsect="InnerEdges"/>)).
#! 
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "InnerVertices", IsTwistedPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, vertex
DeclareOperation( "IsInnerVertex", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "IsInnerVertexNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @BeginGroup BoundaryVertices
#! @Description
#! Return the set of all boundary vertices.
#!
#! A vertex is a boundary vertex if and only if there is exactly
#! one non-closed umbrella-path around it (compare section
#! <Ref Sect="Section_Access_OrderedVertexAccess"/> for the definition of
#! umbrella-paths).
#!
#! The method <K>IsBoundaryVertex</K> checks whether the given vertex is a 
#! boundary
#! vertex of the given twisted polygonal complex. The NC-version does not check whether
#! <A>vertex</A> is an vertex of <A>complex</A>.
#!
#! Consider the triforce from the start of section
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_Triforce.tex}
#!  \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> IsBoundaryVertex( triforce, 6 );
#! true
#! gap> IsBoundaryVertex( triforce, 2 );
#! false
#! gap> BoundaryVertices( triforce );
#! [ 1, 4, 6 ]
#! @EndExampleSession
#!
#! For twisted polygonal surfaces the boundary vertices can be described more
#! easily: a vertex is a boundary vertex if and only if it
#! is incident to at least one edge that is incident to exactly one face 
#! (i.e. if it is 
#! incident to a boundary edge (<Ref Subsect="BoundaryEdges"/>)).
#!
#! Consider the five-star from the start of section 
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex}
#!  \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> IsBoundaryVertex( fiveStar, 5 );
#! true
#! gap> IsBoundaryVertex( fiveStar, 1 );
#! false
#! gap> BoundaryVertices( fiveStar );
#! [ 2, 3, 5, 7, 11 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "BoundaryVertices", IsTwistedPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, vertex
DeclareOperation( "IsBoundaryVertex", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "IsBoundaryVertexNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @BeginGroup RamifiedVertices
#! @Description
#! Return the set of all ramified vertices.
#!
#! A vertex is ramified if and only if there is a well-defined
#! umbrella-path partition around it (compare 
#! <Ref Subsect="UmbrellaPathPartitionsOfVertices"/>) and there are at least two
#! umbrella-paths in this partition.
#!
#! The method <K>IsRamifiedVertex</K> checks whether the given vertex is a
#! ramified
#! vertex of the given twisted polygonal complex. The NC-version does not check whether
#! <A>vertex</A> is an vertex of <A>complex</A>.
#!
#! Consider the triforce from the start of section
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_Triforce.tex}
#!  \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> IsRamifiedVertex( triforce, 3 );
#! true
#! gap> IsRamifiedVertex( triforce, 4 );
#! false
#! gap> RamifiedVertices( triforce );
#! [ 2, 3, 5 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "RamifiedVertices", IsTwistedPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, vertex
DeclareOperation( "IsRamifiedVertex", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "IsRamifiedVertexNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup ChaoticVertices
#! @Description
#! Return the set of all chaotic vertices.
#!
#! A vertex is chaotic if and only if it is incident to an edge that is
#! incident to at least three faces. In other words, there is no well-defined
#! umbrella-path partition (<Ref Subsect="UmbrellaPathPartitionsOfVertices"/>) around 
#! a chaotic vertex.
#!
#! The method <K>IsChaoticVertex</K> checks whether the given vertex is a 
#! chaotic
#! vertex of the given twisted polygonal complex. The NC-version does not check whether
#! <A>vertex</A> is an vertex of <A>complex</A>.
#!
#! As an example, we consider the following triangular complex:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle, edgeStyle, faceStyle]
#!      \input{Image_ThreeBranchingTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> branch := TriangularComplexByDownwardIncidence(
#! >        [[2,3],[1,3],[2,4],[1,4],[2,5],[1,5],[1,2]], 
#! >        [[1,2,7],[3,4,7],[5,6,7]]);;
#! gap> IsChaoticVertex(branch, 1);
#! true
#! gap> IsChaoticVertex(branch, 3);
#! false
#! gap> ChaoticVertices(branch);
#! [ 1, 2 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "ChaoticVertices", IsTwistedPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, vertex
DeclareOperation( "IsChaoticVertex", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "IsChaoticVertexNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @Section Face-colouring 
#! @SectionLabel Properties_FaceColouring 
#!
#! @BeginGroup FaceTwoColouring
#! @Description
#! The method returns a 2-face-colouring of a given polygonal complex if it exists
#! or fail if it doesn't.
#!
#! A 2-face-colouring of a polygonal complex is a colouring of the faces with exactly
#! two colours, whereby two neighbouring faces have to be coloured different. 
#!
#! As an example, consider the octahedron.
#!
#! @ExampleSession
#! gap> FaceTwoColouring(Octahedron());
#! [ [ 1, 2, 5, 6 ], [ 3, 4, 7, 8 ] ]
#! @EndExampleSession
#! <Alt Only="TikZ">
#!      \input{Image_TwoColouredOctahedron.tex}
#! </Alt>
#! @Returns a pair where the first and second entry are sets of faces or fail
#! @Arguments complex
DeclareAttribute( "FaceTwoColouring", IsPolygonalComplex );
#! @EndGroup


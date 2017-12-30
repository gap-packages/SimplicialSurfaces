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
#! gap> IsClosedSurface( Octahedron() );
#! true
#! gap> IsClosedSurface( Dodecahedron() );
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
#! gap> IsClosedSurface(fiveStar);
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


#! @BeginGroup EdgeDegreesOfVertices
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
#! [ 5, 3, 3,, 3,, 3,,,, 3 ]
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
#! gap> FaceDegreesOfVertices( fiveStar );
#! [ 5, 2, 2,, 2,, 2,,,, 2 ]
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




#! @BeginGroup VertexCounter
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
#! gap> List( EdgesOfVertices(fiveStar), Size );
#! [ 5, 3, 3,, 3,, 3,,,, 3 ]
#! gap> VertexCounter(fiveStar);
#! [ ,, 5,, 1 ]
#! @EndExampleSession
#!
#! @Returns a list of positive integers
#! @Arguments complex
DeclareAttribute( "VertexCounter", IsPolygonalComplex );
#! @EndGroup


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
#! gap> EdgeCounter(fiveStar);
#! [ [ 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0 ], [ 0, 0, 5, 0, 5 ], 
#!   [ 0, 0, 0, 0, 0 ], [ 0, 0, 5, 0, 0] ]
#! @EndExampleSession
#!
#! @Returns a matrix of positive integers
#! @Arguments complex
DeclareAttribute( "EdgeCounter", IsPolygonalComplex );


#! @Section Connectivity
#! @SectionLabel Properties_Connectivity
#!
#! This section contains methods that deal with the (strong) connectivity of 
#! polygonal
#! complexes (which were introduced in chapter 
#! <Ref Chap="PolygonalStructures"/> as a generalisation of simplicial 
#! surfaces). More specifically it contains these
#! capabilities:
#! * Determine if a polygonal complex is (strongly) connected 
#!   (<Ref Subsect="IsConnected"/> and <Ref Subsect="IsStronglyConnected"/>).
#! * Determine the (strongly) connected components of a polygonal complex 
#!   (<Ref Subsect="ConnectedComponents"/> and 
#!   <Ref Subsect="StronglyConnectedComponents"/>).
#!
#! The distinction between <E>connectivity</E> and <E>strong connectivity</E> 
#! is only
#! relevant for polygonal complexes that are not also polygonal surfaces.
#! This can be seen in this example:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_ButterflyOfTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> butterfly := RamifiedSimplicialSurfaceByVerticesInFaces( 7, 4,
#! > [ [1,2,3], [1,6,7], [1,3,4], [1,5,6] ]);;
#! @EndExampleSession
#! This example is connected since its incidence graph (see TODO) is 
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
#! For example, consider the ramified simplicial surface from the start of
#! section <Ref Sect="Section_Properties_Connectivity"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle, edgeStyle=nolabels, faceStyle]
#!     \input{Image_ButterflyOfTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> comp := ConnectedComponentsOfComplex( butterfly );;
#! gap> Size(comp);
#! 1
#! gap> comp[1] = butterfly;
#! true
#! @EndExampleSession
#TODO better example..
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
#! For example, consider the ramified simplicial surface from the start of 
#! section <Ref Sect="Section_Properties_Connectivity"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle, edgeStyle=nolabels, faceStyle]
#!     \input{Image_ButterflyOfTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> comp := StronglyConnectedComponents(butterfly);;
#! gap> Size(comp);
#! 2
#! gap> Faces( comp[1] );
#! [ 1, 3 ]
#! gap> Faces( comp[2] );
#! [ 2, 4 ]
#! gap> comp[1] = StronglyConnectedComponentOfFace(butterfly, 1);
#! true
#! gap> comp[2] = StronglyConnectedComponentOfFace(butterfly, 4);
#! true
#! @EndExampleSession
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


#! @BeginGroup NumberOfConnectedComponents
#! @Description
#! Return the number of (strongly) connected components of the given polygonal
#! complex.
#!
#! TODO explain definitions
#!
#! For example consider the ramified simplicial surface from the start of
#! section <Ref Sect="Section_Properties_Connectivity"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle=nolabels, edgeStyle=nolabels, faceStyle=nolabels]
#!      \input{Image_ButterflyOfTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> NumberOfConnectedComponents(butterfly);
#! 1
#! gap> NumberOfStronglyConnectedComponents(butterfly);
#! 2
#! @EndExampleSession
#!
#! @Returns a positive integer
#! @Arguments complex
DeclareAttribute( "NumberOfConnectedComponents", IsPolygonalComplex );
#! @Arguments complex
DeclareAttribute( "NumberOfStronglyConnectedComponents", IsPolygonalComplex );
#! @EndGroup


#! @Section Orientability
#! @SectionLabel Orientability
#! 
#! This section contains methods that deal with the orientability of ramified 
#! polygonal surfaces (which were defined in section
#! <Ref Sect="PolygonalStructures_ramified"/>). For general polygonal 
#! complexes the concept of orientability is not defined since there is no
#! proper way to deal with edges that are incident to more than two faces.
#TODO more explanation needed?
#!
#! A polygonal orientation is defined by choosing a direction along the 
#! perimeter of each polygon such that for each edge with exactly two 
#! incident faces both directions are defined.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexPlain=nolabels, edgePlain=nolabels, faceStyle=nolabels]
#!     \def\orientation{1}
#!     \input{Image_ConstructorExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! A ramified polygonal surface is <E>orientable</E> if such a choice of
#! directions is possible.
#!
#! For a given ramified polygonal surface this orientation can be computed.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexPlain, edgePlain, faceStyle]
#!      \input{Image_ConstructorExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> surface := PolygonalSurfaceByDownwardIncidence(
#! > [,[3,5],,,,[3,7],,[3,11],,[7,11],,[5,13],,[7,13],[11,13]],
#! > [ [2,6,12,14],,, [6,8,10],,,,, [10,14,15] ]);;
#! gap> IsOrientable(surface);
#! true
#! @EndExampleSession
#!
#! The orientation of each face can be given in two different ways:
#! * As a cyclic permutation of the incident vertices (e.g. (3,7,15,13) for the
#!   quadrangular face)
#! * As a cyclic permutation of the incident edges (e.g. (2,6,14,12) for the
#!   quadrangular face)
#!
#! Additionally, the permutations can be replaced by lists, e.g. 
#! <M>(3,7,15,13)</M> would be replaced by <M>[3, 7, 15, 13]</M>.
#! @ExampleSession
#! gap> OrientationByVerticesAsPerm( surface );
#! [ (3,5,13,7),,, (3,7,11),,,,, (7,13,11) ]
#! gap> OrientationByEdgesAsList( surface );
#! [ [ 2, 12, 14, 6 ],,, [ 6, 10, 8 ],,,,, [ 10, 14, 15 ] ]
#! @EndExampleSession
#! 
#! This does not define the orientation uniquely. If the orientation for
#! one face is given, this defines the orientations for the strongly
#! connected component (compare <Ref Subsect="StronglyConnectedComponents"/>)
#! of this face. Therefore the following convention is followed:
#! * For each strongly connected component there is a face with 
#!   minimal number.
#! * The orientation of this face (with respect to the vertices) is minimal 
#!   according to the criteria from
#!   section <Ref Sect="Section_Access_OrderedFaceAccess"/>.
#! * The orientation with respect to the edges is the same as with respect
#!   to the vertices. In particular they do not necessarily conform to the
#!   minimality condition from before.
#!

#! @Description
#! Return whether the given ramified polygonal surface is orientable.
#!
#! A ramified polygonal surface is orientable if it is possible to choose a 
#! direction along the perimeter of each face such that each pair of adjacent
#! faces defines opposite directions on the shared edge.
#!
#! As an example, consider the polygonal surface from the start of section
#! <Ref Sect="Section_Orientability"/>:
#! <Alt Only="TikZ">
#!    \begin{tikzpicture}[vertexStyle=nolabels, edgeStyle=nolabels, faceStyle]
#!       \input{Image_ConstructorExample.tex}
#!    \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> IsOrientable( surface );
#! true
#! @EndExampleSession
#! TODO other example?
#! @Arguments ramSurf
DeclareProperty( "IsOrientable", IsRamifiedPolygonalSurface );

#! @BeginGroup
#! @Description
#! Return the orientation of the given ramified polygonal surface, if
#! it exists (otherwise return fail). The orientation is given as a list
#! with the faces of <A>ramSurf</A> as indices.
#!
#! For each face, this list contains a permutation/list of the vertices that
#! are incident to this face.
#! 
#! TODO describe properly
#!
#! For example, consider the polygonal surface from the start of section
#! <Ref Sect="Section_Orientability"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_ConstructorExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> OrientationByVerticesAsPerm( surface );
#! [ (3,5,13,7),,, (3,7,11),,,,, (7,13,11) ]
#! gap> OrientationByVerticesAsList( surface );
#! [ [3, 5, 13, 7],,, [3, 7, 11],,,,, [7, 13, 11] ]
#! @EndExampleSession
#! 
#! @Returns a list of permutations
#! @Arguments ramSurf
DeclareAttribute( "OrientationByVerticesAsPerm", IsRamifiedPolygonalSurface );
#! @Arguments ramSurf
DeclareOperation( "OrientationByVertices", [IsRamifiedPolygonalSurface] );
#! @Returns a list of lists
#! @Arguments ramSurf
DeclareAttribute( "OrientationByVerticesAsList", IsRamifiedPolygonalSurface );
#! @EndGroup

#! @BeginGroup
#! @Description
#! Return the orientation of the given ramified polygonal surface, if
#! it exists (otherwise return fail). The orientation is given as a list
#! with the faces of <A>ramSurf</A> as indices.
#!
#! For each face, this list contains a permutation/list of the edges that
#! are incident to this face. 
#! 
#! TODO describe properly
#!
#! For example, consider the polygonal surface from the start of section
#! <Ref Sect="Section_Orientability"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle=nolabels, edgeStyle, faceStyle]
#!      \input{Image_ConstructorExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> OrientationByEdgesAsPerm( surface );
#! [ (2,12,14,6),,, (6,10,8),,,,, (10,14,15) ]
#! gap> OrientationByEdgesAsList( surface );
#! [ [ 2, 12, 14, 6 ],,, [ 6, 10, 8 ],,,,, [ 10, 14, 15 ] ]
#! @EndExampleSession
#! 
#! @Returns a list of permutations
#! @Arguments ramSurf
DeclareAttribute( "OrientationByEdgesAsPerm", IsRamifiedPolygonalSurface );
#! @Arguments ramSurf
DeclareOperation( "OrientationByEdges", [IsRamifiedPolygonalSurface] );
#! @Returns a list of lists
#! @Arguments ramSurf
DeclareAttribute( "OrientationByEdgesAsList", IsRamifiedPolygonalSurface );
#! @EndGroup



#! @Section Automorphism group
#! @SectionLabel Automorphisms
#!
#! As long as the package <K>NautyTracesInterface</K> is available 
#! the automorphism groups of polygonal complexes can be computed with the
#! method <K>AutomorphismGroup</K> (<Ref Subsect="AutomorphismGroup"/>) as the
#! automorphism groups of the corresponding incidence graphs (see section
#! <Ref Sect="Section_Access_IncidenceGraph"/> for details).
#!
#! Unfortunately it is not completely trivial to work with the automorphis
#! group of a polygonal complex in &GAP;. This can already be seen on the
#! example of a tetrahedron.
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Tetrahedron_constructor.tex}
#! </Alt>
#! @ExampleSession
#! gap> tetra := Tetrahedron();;
#! gap> aut := AutomorphismGroup(tetra);
#! Group([ (3,4)(6,7)(8,9)(11,12), (1,2)(6,8)(7,9)(13,14), (2,3)(5,6)(9,10)(12,14) ])
#! @EndExampleSession
#! The generators of this group seem very complicated in comparison to
#! the size of the automorphism group - it is just a symmetric group
#! on four elements.
#! @ExampleSession
#! gap> Size(aut);
#! 24
#! gap> IsSymmetricGroup(aut);
#! true
#! @EndExampleSession
#! Furthermore there are labels (like 14) that don't appear as labels
#! of the tetrahedron.
#!
#! This complication appears because there are surfaces where it is
#! necessary to describe the action on vertices, edges and faces 
#! separately. One such example is the janus-head, two triangles 
#! combined along all their edges.
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Janus_constructor.tex}
#! </Alt>
#! If the automorphism group would be determined by the action on
#! the vertices (or edges) alone, it would be a subgroup of the
#! symmetric group on 3 elements. Then it would have at most 6
#! elements. If it were determined by the action on the faces, it
#! would have at most 2 elements. But it actually has 12 elements.
#! @ExampleSession
#! gap> autJan := AutomorphismGroup( JanusHead() );
#! Group([ (7,8), (2,3)(4,5), (1,2)(5,6) ])
#! gap> Size(autJan);
#! 12
#! @EndExampleSession
#! 
#! The labels for vertices, edges and faces in polygonal complexes
#! may overlap. Then the automorphisms can't be represented as permutations
#! over the integers - which is important for fast performance in &GAP;.
#! Therefore the edges and faces are relabelled for the purpose of the
#! automorphisms.
#! * The vertex labels stay the same
#! * The edge labels are shifted upwards by the maximal vertex label.
#! * The face labels are shifted upwards by the sum of maximal vertex
#!   label and maximal edge label.
#! To see the action on the original labels, the method
#! <K>DisplayAsAutomorphism</K> (<Ref Subsect="DisplayAsAutomorphism"/>) can 
#! be used.
#! @ExampleSession
#! gap> DisplayAsAutomorphism( tetra, (3,4)(6,7)(8,9)(11,12) );
#! [ (3,4), (2,3)(4,5), (1,2) ]
#! @EndExampleSession
#! The first component describes the action on the vertices, the
#! second component shows the action on the edges and the final
#! component represents the action on the faces.

#! @BeginGroup AutomorphismGroup
#! @Description
#! Compute the automorphism group of the polygonal complex <A>complex</A> as
#! a permutation group.
#! 
#! The automorphisms see the labels of <A>complex</A> in the following way:
#! * The vertex labels stay the same.
#! * The edge labels are shifted upwards by the maximal vertex label.
#! * The face labels are shifted upwards by the sum of the maximal vertex
#!   label and the maximal edge label.
#! For a more exhaustive explanation (and the reason for this) see section
#! <Ref Sect="Section_Automorphisms"/>.
#! 
#! To see the action on the original labels, use the method 
#! <K>DisplayAsAutomorphism</K>(<Ref Subsect="DisplayAsAutomorphism"/>).
#!
#! For example, the automorphism group of an icosahedron 
#! (<Ref Subsect="Icosahedron"/>) is the direct product of a cyclic group
#! of order 2 and an alternating group of order 60.
#! @ExampleSession
#! gap> autIco := AutomorphismGroup( Icosahedron() );;
#! gap> Size(autIco);
#! 120
#! gap> StructureDescription(autIco);
#! "C2 x A5"
#! @EndExampleSession
#TODO example with picture? or more of them? Is this really necessary for the kind of people who look at this method..
#!
#! @Arguments complex
#! @Returns a permutation group
DeclareAttribute( "AutomorphismGroup", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup DisplayAsAutomorphism
#! @Description
#! Display an automorphism of the given <A>complex</A> by its individual
#! action on vertices, edges and faces. If this is not possible (because
#! the given permutation is not an automorphism) fail is returned.
#!
#! An explanation for the necessity of this method is given in section
#! <Ref Sect="Section_Automorphisms"/>.
#!
#! We illustrate this on the example of a tetrahedron.
#! <Alt Only="TikZ">
#!  \input{_TIKZ_Tetrahedron_constructor.tex}
#! </Alt>
#! @ExampleSession
#! gap> tetra := Tetrahedron();;
#! gap> aut := AutomorphismGroup( tetra );
#! Group([ (3,4)(6,7)(8,9)(11,12), (1,2)(6,8)(7,9)(13,14), (2,3)(5,6)(9,10)(12,14) ])
#! gap> DisplayAsAutomorphism( tetra, (3,4)(6,7)(8,9)(11,12) );
#! [ (3,4), (2,3)(4,5), (1,2) ]
#! gap> DisplayAsAutomorphism( tetra, (1,2)(6,8)(7,9)(13,14) );
#! [ (1,2), (2,4)(3,5), (3,4) ]
#! gap> DisplayAsAutomorphism( tetra, (2,3)(5,6)(9,10)(12,14) );
#! [ (2,3), (1,2)(5,6), (2,4) ]
#! gap> DisplayAsAutomorphism( tetra, (1,5) );
#! fail
#! @EndExampleSession
#! 
#! @Arguments complex, perm
#! @Returns A list of three permutations or fail
DeclareOperation( "DisplayAsAutomorphism", [IsPolygonalComplex, IsPerm] );
#! @EndGroup


#! TODO explain restrictions to vertices etc., when are they sufficient (anomalies?)?



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

#! @BeginGroup InnerEdges
#! @Description
#! Return the set of all inner edges of the given polygonal complex.
#! An <E>inner edge</E> is an edge that is incident to exactly two faces.
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


#! @BeginGroup BoundaryEdges
#! @Description
#! Return the set of all boundary edges of the given polygonal complex.
#! A <E>boundary edge</E> is an edge that is incident to exactly one face.
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
#! Return the set of all ramified edges of the given polygonal complex.
#! A <E>ramified edge</E> is an edge that is incident to at least three faces.
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
#! In general there are more than these two possibilities. In the case of 
#! ramified polygonal surfaces (defined in 
#! <Ref Sect="PolygonalStructures_ramified"/>) there can be 
#! <E>ramified vertices</E>:
#! <Alt Only="TikZ">
#!    \begin{tikzpicture}[vertexPlain=nolabels, edgeStyle=nolabels, faceStyle=nolabels]
#!       \input{Image_TwoJoinedTetrahedrons.tex}
#!    \end{tikzpicture}
#! </Alt>
#!
#! For general polygonal complexes (defined in 
#! <Ref Sect="PolygonalStructures_complex"/>) there might be edges that are 
#! incident to more than two faces.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexPlain=nolabels, edgeStyle=nolabels, faceStyle=nolabels]
#!     \input{Image_ThreeBranchingTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! Vertices that are incident to such an edge are called 
#! <E>chaotic vertices</E>.

#! @BeginGroup
#! @Description
#! Return the set of all inner vertices. 
#! 
#! In a polygonal surface a vertex is
#! an inner vertex if and only if every incident edge is incident to exactly
#! two faces (that is, if it only incident to inner edges 
#! (<Ref Subsect="InnerEdges"/>)).
#!
#! In general a vertex is an inner vertex if and only if there is exactly
#! one closed edge-face-path around it (compare section 
#! <Ref Sect="Section_Access_OrderedVertexAccess"/> for the definition of
#! edge-face-paths).
#!
#! The method <K>IsInnerVertex</K> checks whether the given vertex is an inner
#! vertex of the given polygonal complex. The NC-version does not check whether
#! <A>vertex</A> is an vertex of <A>complex</A>.
#!
#! TODO example
#! 
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "InnerVertices", IsPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, vertex
DeclareOperation( "IsInnerVertex", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "IsInnerVertexNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! Return the set of all boundary vertices.
#!
#! In a polygonal surface a vertex is a boundary vertex if and only if it
#! is incident to one edge that is incident to only one face (if it is 
#! incident to a boundary edge (<Ref Subsect="BoundaryEdges"/>)).
#!
#! In general a vertex is a boundary vertex if and only if there is exactly
#! one non-closed edge-face-path around it (compare section
#! <Ref Sect="Section_Access_OrderedVertexAccess"/> for the definition of
#! edge-face-paths).
#!
#! The method <K>IsBoundaryVertex</K> checks whether the given vertex is a 
#! boundary
#! vertex of the given polygonal complex. The NC-version does not check whether
#! <A>vertex</A> is an vertex of <A>complex</A>.
#!
#! TODO example
#! 
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "BoundaryVertices", IsPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, vertex
DeclareOperation( "IsBoundaryVertex", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "IsBoundaryVertexNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! Return the set of all ramified vertices.
#!
#! A vertex is ramified if and only if there is a well-defined
#! edge-face-path partition around it (compare 
#! <Ref Subsect="EdgeFacePathPartition"/>) and there are at least two
#! elements in this partition.
#!
#! The method <K>IsRamifiedVertex</K> checks whether the given vertex is a
#! ramified
#! vertex of the given polygonal complex. The NC-version does not check whether
#! <A>vertex</A> is an vertex of <A>complex</A>.
#!
#! TODO example
#! 
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "RamifiedVertices", IsPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, vertex
DeclareOperation( "IsRamifiedVertex", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "IsRamifiedVertexNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! Return the set of all chaotic vertices.
#!
#! A vertex is chaotic if and only if it is incident to an edge that is
#! incident to at least three faces. In other words, there is no well-defined
#! edge-face-path partition (<Ref Subsect="EdgeFacePathPartition"/>) around 
#! a chaotic vertex.
#!
#! The method <K>IsChaoticVertex</K> checks whether the given vertex is a 
#! chaotic
#! vertex of the given polygonal complex. The NC-version does not check whether
#! <A>vertex</A> is an vertex of <A>complex</A>.
#!
#! TODO example
#! 
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "ChaoticVertices", IsPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, vertex
DeclareOperation( "IsChaoticVertex", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "IsChaoticVertexNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


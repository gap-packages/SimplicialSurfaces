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

#! @Chapter Access to the incidence geometry
#! @ChapterLabel AccessIncidenceGeometry
#! 

####
# No matter what, a chapter should start with a short description of its
# contents, together with necessary references to previous material (if
# someone does not read the chapters in order).
####

#! In section <Ref Sect="PolygonalStructures_complex"/> we introduced 
#! incidence geometries to describe polygonal complexes.
#! This chapter describes several different ways to access these
#! incidence structures.
#! <P/>

####
# Since the structure of this chapter was subject to a lot of revisions, I
# will explain my choice here. First of all, what are the design goals? What
# are the probable expectations of people reading this part of the manual?
# 1) This is a very important chapter since it explains the core mechanic
#    of the *Of*-methods. This is the reason why it has to be an early 
#    chapter.
# 2) Since it is an early chapter, its tone should not deviate too much
#    from the earlier chapters. It should not be offputting to someone
#    who is reading through the manual in order (which was encouraged up
#    to this point).
# 3) At the same time, many people will skip to this chapter to find
#    answers about their problems (most likely something about access, if
#    we consider the title). They usually want an easy way to find
#    what they are searching.
#
# As usually, (2) and (3) oppose each other. This is especially critical
# because of the chapter content:
# A) Explain that vertices, edges and faces are stored as sets of natural
#    numbers.
# B) Explain the *Of*-methods
# C) Explain the possibilities for ordered access:
#   C1) Order of vertices/edges in a face
#   C2) Order of faces around an edge
#   C3) Order of edges and faces around a vertex
#
# Unfortunately the structure of this presentation is not usable: GAPDoc
# represents mansections internally as subsections and is not able to
# distinguish between those when it outputs its documentation. Therefore only
# section remains as a separator between chapter and mansection.
#
# Simultaneously there is a different conflict: (B) is the core mechanic while
# the methods in (C) are more specialized. That means that user (2) does not
# have to read (C) but user (3) should be able to find them quickly.
#
# A possible compromise would be to write a short summary of the chapter at
# the start to point (3) to the correct sections. In practice this does
# remove a lot of legibility for user (2) and even for (3) if they are not
# experienced with our formalism.
#
# 
# To make finding (C) easier, the names are choosen in an expressive way. If
# that is not sufficient, a short mentioning of them (without going into any 
# details) will have to be sufficient.
#
# The individual sections all have the same problems: Many very similar 
# methods with very similar documentation. Since we should give a picture
# in each of them (to aid understanding in the situation of a focused
# look-up) this amounts to quite a lot of pages.
# -> To make it easier to skip over the similar methods, we use the same
#    picture (essentially) in all of them
# -> Each section has its own "signature picture" that allows the user to
#    visually recognize how far they are skipping ahead (which can't be
#    avoided in these sections)
####

#! In section <Ref Sect="Section_Access_LabelAccess"/> the labeling
#! conventions for vertices, edges and faces are explained. The central
#! incidence relations between them are described in section
#! <Ref Sect="Section_Access_BasicAccess"/>. Some more specialized
#! applications for incidence can be found in section
#! <Ref Sect="Section_Access_SpecializedAccess"/>.
#! 
#! Finally the sections <Ref Sect="Section_Access_OrderedFaceAccess"/> 
#! and <Ref Sect="Section_Access_OrderedVertexAccess"/>
#! deal with variations of incidence that are usually not needed by the 
#! standard user.
#TODO how to improve this introduction to give more information but
# not burden the reader too much?

#! @Section Labels of vertices, edges and faces
#! @SectionLabel Access_LabelAccess
#!
#! In polygonal complexes (the most general supported incidence structure,
#! compare chapter <Ref Chap="PolygonalStructures"/>) all vertices, edges
#! and faces are labelled by positive integers.
#!
#! These labels do not have to be consecutive or disjoint, as shown in 
#! the following example:
#! <Alt Only="TikZ">
#!      \input{Image_LabellingExample.tex}
#! </Alt>
#TODO give a reference to the constructor
#! @ExampleSession
#! gap> complex := PolygonalComplexByDownwardIncidence( 
#! >        [ , [2,3], [2,5], , [3,7], [5,7] ], 
#! >        [ , , [2,3,5,6] ] );;
#! @EndExampleSession
#
#! We can access the sets of
#! all those labels by <K>Vertices</K>, <K>Edges</K> and <K>Faces</K>.
#! If only the number of vertices is relevant, we can use 
#! <K>NumberOfVertices</K>
#! instead (likewise for edges and faces).

#! @BeginGroup
## TODO check if grape has changed their definition of Vertices
#! @Description
#! Return the set/number of vertices.
#! 
#! As an example consider the polygonal complex from the beginning of section
#! <Ref Sect="Section_Access_LabelAccess"/>:
#! <Alt Only="TikZ">
#!      \input{Image_LabellingExample.tex}
#! </Alt>
#! @ExampleSession
#! gap> Vertices(complex);
#! [ 2, 3, 5, 7 ]
#! gap> NumberOfVertices(complex);
#! 4
#! @EndExampleSession
#! 
#! We have separated the operation <K>Vertices</K> from the corresponding
#! attribute because there is a naming clash with the package grape.
#! @Arguments complex
#! @Returns A set of positive integers/a non-negative integer
DeclareOperation( "Vertices", [IsPolygonalComplex] );
#! @Arguments complex
DeclareAttribute( "VerticesAttributeOfPolygonalComplex", IsPolygonalComplex );
#! @Arguments complex
DeclareAttribute( "NumberOfVertices", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup
#! @Description
#! Return the set/number of edges.
#! 
#! As an example consider the polygonal complex from the beginning of section
#! <Ref Sect="Section_Access_LabelAccess"/>:
#! <Alt Only="TikZ">
#!      \input{Image_LabellingExample.tex}
#! </Alt>
#! @ExampleSession
#! gap> Edges(complex);
#! [ 2, 3, 5, 6 ]
#! gap> NumberOfEdges(complex);
#! 4
#! @EndExampleSession
#
#! @Arguments complex
#! @Returns A set of positive integers/a non-negative integer
DeclareAttribute( "Edges", IsPolygonalComplex );
#! @Arguments complex
DeclareAttribute( "NumberOfEdges", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup
#! @Description
#! Return the set/number of faces.
#! 
#! As an example consider the polygonal complex from the beginning of section
#! <Ref Sect="Section_Access_LabelAccess"/>:
#! <Alt Only="TikZ">
#!      \input{Image_LabellingExample.tex}
#! </Alt>
#! @ExampleSession
#! gap> Faces(complex);
#! [ 3 ]
#! gap> NumberOfFaces(complex);
#! 1
#! @EndExampleSession
#
#! @Arguments complex
#! @Returns A set of positive integers/a non-negative integer
DeclareAttribute( "Faces", IsPolygonalComplex );
#! @Arguments complex
DeclareAttribute( "NumberOfFaces", IsPolygonalComplex );
#! @EndGroup


#! @Section Incidence between vertices, edges and faces
#! @SectionLabel Access_BasicAccess
#!
#! With the labels of vertices, edges and faces (which we can access by the
#! methods of section <Ref Sect="Section_Access_LabelAccess"/>) we can 
#! describe the incidence structure by lists of sets.
#! All those methods have the form *Of*, e.g. <K>VerticesOfFaces</K> and 
#! <K>EdgesOfVertices</K>.
#! 
#! We will illustrate the general pattern of these methods by showcasing
#! these two methods. For that we will use the following polygonal complex:

####
# The picture and its labels are choosen very deliberately. They fulfill these
# conditions:
# 1) There are faces with different numbers of vertices. Especially one 
#    triangle and one non-triangle.
# 2) The structure of the example is easy to grasp, yet not completely trivial
# 3) The labels are disjoint. While this is not necessary for our structures
#    it makes it easier to distinguish the labels - as every label is unique
#    a reader can see immediately if it is a vertex, an edge or a face.
# 4) The non-triangular face is not labelled cyclically. While we do not draw
#    special attention to this fact here, this is important for those people
#    that search for this application (they see that it has to be somewhere
#    else instead of wondering). It could be said that an attentive reader
#    might notice this fact nevertheless, but this seems too infrequent to
#    completely base a design choice on.
# 5) The labels of vertices, edges and faces are not numbered consecutively.
#    By doing this we make this possibility very clear. Furthermore it makes
#    the structure of the incidence methods more apparent.
####

#TODO Text-version is crucial here, compare the picture in Image_StarOfStar
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!       \input{Image_StarOfStarExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#!
#TODO give a reference to the constructor
#! @ExampleSession
#! gap> complex := PolygonalComplexByDownwardIncidence( 
#! >    [ , , , , , [2,5], , [2,3], [3,5], [11,5], , [3,7], [7,11] ], 
#! >    [[6,8,9], , , [9,10,12,13]]);;
#! gap> Vertices(complex);
#! [ 2, 3, 5, 7, 11 ]
#! gap> Edges(complex);
#! [ 6, 8, 9, 10, 12, 13 ]
#! gap> Faces(complex);
#! [ 1, 4 ]
#! @EndExampleSession
#!
#! The method <K>VerticesOfFaces</K> tells us, which vertices are incident
#! to which faces.
#! @ExampleSession
#! gap> VerticesOfFaces(complex);
#! [ [ 2, 3, 5 ],,, [ 3, 5, 7, 11 ] ]
#! @EndExampleSession
#! The first entry of this list contains a set of all vertices that are
#! incident to face I. The second and third entries are not bound since
#! there are no faces II and III. Finally, the fourth entry contains all
#! vertices that are incident to face IV.
#! 
#! So we have a list that contains sets of vertices and is indexed by the 
#! face labels.
#! 
#! The method <K>EdgesOfVertices</K> works in the same way: It returns a list
#! that contains sets of edges and is indexed by the vertex labels.
#! @ExampleSession
#! gap> EdgesOfVertices(complex);
#! [ , [ 6, 8 ], [ 8, 9, 12 ],, [ 6, 9, 10 ],, [ 12, 13 ],,,, [ 10, 13 ] ]
#! @EndExampleSession
#! For example, if we consider the third entry of this list, we find the
#! set [ 8, 9, 12 ]. Those are all edges that are incident to the vertex 3.
#! 
#! In the same way all other *Of*-methods are defined.


#TODO mention 'ordered' access
#! @BeginGroup EdgesOfVertices
#! @Description
#! The method <K>EdgesOfVertex</K>(<A>complex</A>, <A>vertex</A>) returns the
#! set of all edges that are incident to <A>vertex</A>. The NC-version does
#! not check whether the given <A>vertex</A> is a vertex of <A>complex</A>.
#! 
#! The attribute <K>EdgesOfVertices</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the vertex labels, i.e.
#! <K>EdgesOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>EdgesOfVertex</K>(<A>complex</A>, <A>vertex</A>).
#! All other positions of this list are not bound.
#! 
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle=nolabels]
#!       \input{Image_StarOfStarExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> EdgesOfVertex(complex, 2);
#! [ 6, 8 ]
#! gap> EdgesOfVertex(complex, 5);
#! [ 6, 9, 10 ]
#! gap> EdgesOfVertices(complex);
#! [ , [ 6, 8 ], [ 8, 9, 12 ],, [ 6, 9, 10 ],, [ 12, 13 ],,,, [ 10, 13 ] ]
#! @EndExampleSession
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "EdgesOfVertices", IsPolygonalComplex );
#! @Arguments complex, vertex
DeclareOperation( "EdgesOfVertex", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "EdgesOfVertexNC", [IsPolygonalComplex, IsPosInt]);
#! @EndGroup


#TODO mention 'ordered' access
#! @BeginGroup FacesOfVertices
#! @Description
#! The method <K>FacesOfVertex</K>(<A>complex</A>, <A>vertex</A>) returns the
#! set of all faces that are incident to <A>vertex</A>. The NC-version does
#! not check whether the given <A>vertex</A> is a vertex of <A>complex</A>.
#! 
#! The attribute <K>FacesOfVertices</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the vertex labels, i.e.
#! <K>FacesOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>FacesOfVertex</K>(<A>complex</A>, <A>vertex</A>).
#! All other positions of this list are not bound.
#! 
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!     \input{Image_StarOfStarExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> FacesOfVertex(complex, 2);
#! [ 1 ]
#! gap> FacesOfVertex(complex, 5);
#! [ 1, 4 ]
#! gap> FacesOfVertices(complex);
#! [ , [ 1 ], [ 1, 4 ],, [ 1, 4 ],, [ 4 ],,,, [ 4 ] ]
#! @EndExampleSession
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "FacesOfVertices", IsPolygonalComplex );
#! @Arguments complex, vertex
DeclareOperation( "FacesOfVertex", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "FacesOfVertexNC", [IsPolygonalComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup VerticesOfEdges
#! @Description
#! The method <K>VerticesOfEdge</K>(<A>complex</A>, <A>edge</A>) returns the
#! set of all vertices that are incident to <A>edge</A>. The NC-version does
#! not check whether the given <A>edge</A> is an edge of <A>complex</A>.
#! 
#! The attribute <K>VerticesOfEdges</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the edge labels, i.e.
#! <K>VerticesOfEdges</K>(<A>complex</A>)[<A>edge</A>] = 
#! <K>VerticesOfEdge</K>(<A>complex</A>, <A>edge</A>).
#! All other positions of this list are not bound.
#! 
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle=nolabels]
#!     \input{Image_StarOfStarExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> VerticesOfEdge(complex, 8);
#! [ 2, 3 ]
#! gap> VerticesOfEdge(complex, 12);
#! [ 3, 7 ]
#! gap> VerticesOfEdges(complex);
#! [ ,,,,, [ 2, 5 ],, [ 2, 3 ], [ 3, 5 ], [ 5, 11 ],, [ 3, 7 ],
#!   [ 7, 11 ] ]
#! @EndExampleSession
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "VerticesOfEdges", IsPolygonalComplex );
#! @Arguments complex, edge
DeclareOperation( "VerticesOfEdge", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, edge
DeclareOperation( "VerticesOfEdgeNC", [IsPolygonalComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup FacesOfEdges
#! @Description
#! The method <K>FacesOfEdge</K>(<A>complex</A>, <A>edge</A>) returns the
#! set of all faces that are incident to <A>edge</A>. The NC-version does
#! not check whether the given <A>edge</A> is an edge of <A>complex</A>.
#! 
#! The attribute <K>FacesOfEdges</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the edge labels, i.e.
#! <K>FacesOfEdges</K>(<A>complex</A>)[<A>edge</A>] = 
#! <K>FacesOfEdge</K>(<A>complex</A>, <A>edge</A>).
#! All other positions of this list are not bound.
#! 
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle=nolabels, edgeStyle, faceStyle]
#!     \input{Image_StarOfStarExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> FacesOfEdge(complex, 9);
#! [ 1, 4 ]
#! gap> FacesOfEdge(complex, 10);
#! [ 4 ]
#! gap> FacesOfEdges(complex);
#! [ ,,,,, [ 1 ],, [ 1 ], [ 1, 4 ], [ 4 ],, [ 4 ], [ 4 ] ]
#! @EndExampleSession
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "FacesOfEdges", IsPolygonalComplex );
#! @Arguments complex, edge
DeclareOperation( "FacesOfEdge", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, edge
DeclareOperation( "FacesOfEdgeNC", [IsPolygonalComplex, IsPosInt]);
#! @EndGroup


#TODO mention ordered access
#! @BeginGroup VerticesOfFaces
#! @Description
#! The method <K>VerticesOfFace</K>(<A>complex</A>, <A>face</A>) returns the
#! set of all vertices that are incident to <A>face</A>. The NC-version does
#! not check whether the given <A>face</A> is a face of <A>complex</A>.
#! 
#! The attribute <K>VerticesOfFaces</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the face labels, i.e.
#! <K>VerticesOfFaces</K>(<A>complex</A>)[<A>face</A>] = 
#! <K>VerticesOfFace</K>(<A>complex</A>, <A>face</A>).
#! All other positions of this list are not bound.
#! 
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!     \input{Image_StarOfStarExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> VerticesOfFace(complex, 1);
#! [ 2, 3, 5 ]
#! gap> VerticesOfFace(complex, 4);
#! [ 3, 5, 7, 11 ]
#! gap> VerticesOfFaces(complex);
#! [ [ 2, 3, 5 ],,, [ 3, 5, 7, 11 ] ]
#! @EndExampleSession
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "VerticesOfFaces", IsPolygonalComplex );
#! @Arguments complex, face
DeclareOperation( "VerticesOfFace", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, face
DeclareOperation( "VerticesOfFaceNC", [IsPolygonalComplex, IsPosInt]);
#! @EndGroup


#TODO mention ordered access
#! @BeginGroup EdgesOfFaces
#! @Description
#! The method <K>EdgesOfFace</K>(<A>complex</A>, <A>face</A>) returns the
#! set of all edges that are incident to <A>faces</A>. The NC-version does
#! not check whether the given <A>face</A> is a face of <A>complex</A>.
#! 
#! The attribute <K>EdgesOfFaces</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the face labels, i.e.
#! <K>EdgesOfFaces</K>(<A>complex</A>)[<A>face</A>] = 
#! <K>EdgesOfFace</K>(<A>complex</A>, <A>face</A>).
#! All other positions of this list are not bound.
#! 
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle=nolabels, edgeStyle, faceStyle]
#!     \input{Image_StarOfStarExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> EdgesOfFace(complex, 1);
#! [ 6, 8, 9 ]
#! gap> EdgesOfFace(complex, 4);
#! [ 9, 10, 12, 13 ]
#! gap> EdgesOfFaces(complex);
#! [ [ 6, 8, 9 ],,, [ 9, 10, 12, 13 ] ]
#! @EndExampleSession
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "EdgesOfFaces", IsPolygonalComplex );
#! @Arguments complex, face
DeclareOperation( "EdgesOfFace", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, face
DeclareOperation( "EdgesOfFaceNC", [IsPolygonalComplex, IsPosInt]);
#! @EndGroup


#TODO How to integrate this section properly?
#! @Section Specialized access to the incidence structure
#! @SectionLabel Access_SpecializedAccess
#!
#! The methods from section <Ref Sect="Section_Access_BasicAccess"/> are
#! sufficient to answer all questions about the incidence structure of a given
#! polygonal complex - in principle. In practice this may be quite cumbersome.
#! Therefore we provide some specialized methods that are used quite often.
#! We will exemplify them with the following example.
#! 
#! <Alt Only="TikZ">
#!   \input{Image_EyeStone.tex}
#! </Alt>
#! @ExampleSession
#! gap> complex := PolygonalComplexByDownwardIncidence( 
#! >        [[1,2],[2,5],[2,6],[2,6],[1,6],[5,6],[1,7],[6,8],[5,9],[7,8],[8,9]],
#! >        [[1,3,5],[5,7,8,10],,[6,8,9,11],[2,4,6]]);;
#! @EndExampleSession
#!
#! This section contains the following methods:
#! * <K>EdgeInFaceByVertices</K> (<Ref Subsect="EdgeInFaceByVertices"/>) 
#!   returns the edge of a face that is defined by
#!   its two vertices.
#! @ExampleSession
#! gap> EdgeInFaceByVertices( complex, 5, [2,6] );
#! 4
#! @EndExampleSession
#! * <K>OtherEdgeOfVertexInFace</K> (<Ref Subsect="OtherEdgeOfVertexInFace"/>) 
#!   returns the other edge of a given vertex
#!   with respect to the given face.
#! @ExampleSession
#! gap> OtherEdgeOfVertexInFace( complex, 1, 5, 2 );
#! 7
#! @EndExampleSession
#! * <K>OtherVertexOfEdge</K> (<Ref Subsect="OtherVertexOfEdge"/>) returns the 
#!   other vertex of the given edge
#! @ExampleSession
#! gap> OtherVertexOfEdge( complex, 7, 10 );
#! 8
#! @EndExampleSession
#! * <K>NeighbourFaceByEdge</K> (<Ref Subsect="NeighbourFaceByEdge"/>) returns 
#!   the face that is adjacent to the
#!   given face (with respect to the given edge)
#! @ExampleSession
#! gap> NeighbourFaceByEdge( complex, 2, 8 );
#! 4
#! @EndExampleSession
#! 

#! @BeginGroup EdgeInFaceByVertices
#! @Description
#! Given a face and a list of two vertices of a polygonal complex, return the 
#! edge that
#! lies in the given face and is incident to the given vertices.
#! 
#! If there is no such edge (because the given vertices are not incident to
#! the given face or because they are not connected by an edge of the face),
#! return <K>fail</K>.
#! 
#! The NC-version does not check if <A>face</A> is a face of the given
#! polygonal complex.
#! 
#! As an example consider the polygonal complex from the start of section
#! <Ref Sect="Section_Access_SpecializedAccess"/>:
#! <Alt Only="TikZ">
#!   \input{Image_EyeStone.tex}
#! </Alt>
#! @ExampleSession
#! gap> EdgeInFaceByVertices(complex, 5, [2,6]);
#! 4
#! gap> EdgeInFaceByVertices(complex, 1, [2,1]);
#! 1
#! gap> EdgeInFaceByVertices(complex, 1, [2,6]);
#! 3
#! gap> EdgeInFaceByVertices(complex, 2, [1,2]);
#! fail
#! gap> EdgeInFaceByVertices(complex, 4, [5,8]);
#! fail
#! @EndExampleSession
#!
#! @Returns a positive integer
#! @Arguments complex, face, verts
DeclareOperation("EdgeInFaceByVertices", [IsPolygonalComplex, IsPosInt, IsList]);
#! @Arguments complex, face, verts
DeclareOperation("EdgeInFaceByVerticesNC", 
        [IsPolygonalComplex, IsPosInt, IsList]);
#! @EndGroup


#! @BeginGroup OtherEdgeOfVertexInFace
#! @Description
#! If a vertex is incident to a face in a polygonal complex, there are exactly
#! two edges that are incident to both vertex and face. If one of those is
#! given to this method, it will return the other one.
#! 
#! The NC-version does not check whether the given vertex, edge an face
#! actually lie in the complex and are incident to each other.
#! 
#! As an example consider the polygonal complex that was introduced at the
#! start of section
#! <Ref Sect="Section_Access_SpecializedAccess"/>:
#! <Alt Only="TikZ">
#!   \input{Image_EyeStone.tex}
#! </Alt>
#! @ExampleSession
#! gap> OtherEdgeOfVertexInFace(complex, 1, 5, 2);
#! 7
#! gap> OtherEdgeOfVertexInFace(complex, 5, 9, 4);
#! 6
#! gap> OtherEdgeOfVertexInFace(complex, 1, 5, 1);
#! 1
#! @EndExampleSession
#!
#! @Returns a positive integer
#! @Arguments complex, vertex, edge, face
DeclareOperation("OtherEdgeOfVertexInFace", 
        [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt]);
#! @Arguments complex, vertex, edge, face
DeclareOperation("OtherEdgeOfVertexInFaceNC",
        [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt]);
#! @EndGroup


#! @BeginGroup OtherVertexOfEdge
#! @Description
#! Every edge in a polygonal complex is incident to exactly two vertices.
#! Given one of them, this method returns the other one.
#! 
#! The NC-version does not check whether the given <A>edge</A> is an edge of 
#! the
#! polygonal complex and whether the given <A>vertex</A> is incident to it.
#! 
#! As an example consider the polygonal complex that was introduced at the
#! start of section
#! <Ref Sect="Section_Access_SpecializedAccess"/>:
#! <Alt Only="TikZ">
#!   \input{Image_EyeStone.tex}
#! </Alt>
#! @ExampleSession
#! gap> OtherVertexOfEdge(complex, 7, 10);
#! 8
#! gap> OtherVertexOfEdge(complex, 1, 5);
#! 6
#! gap> OtherVertexOfEdge(complex, 6, 8);
#! 8
#! @EndExampleSession
#!
#! @Returns a positive integer
#! @Arguments complex, vertex, edge
DeclareOperation("OtherVertexOfEdge", [IsPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, vertex, edge
DeclareOperation("OtherVertexOfEdgeNC", 
        [IsPolygonalComplex, IsPosInt, IsPosInt]);
#! @EndGroup



#! @BeginGroup NeighbourFaceByEdge
#! @Description
#! If an edge is incident to exactly two faces and one of those is given,
#! this method returns the other one.
#! 
#! If this method is called for a boundary edge or a branching edge, it 
#! returns <K>fail</K>.
#! 
#! The NC-version does not check whether the given <A>edge</A> is an edge of
#! the polygonal complex and whether the given <A>face</A> is an incident face
#! of the complex.
#! 
#! As an example consider the polygonal complex that was introduced at the
#! start of section
#! <Alt Only="TikZ">
#!   \input{Image_EyeStone.tex}
#! </Alt>
#! @ExampleSession
#! gap> NeighbourFaceByEdge(complex, 2, 8);
#! 4
#! gap> NeighbourFaceByEdge(complex, 1, 5);
#! 2
#! gap> NeighbourFaceByEdge(complex, 4, 6);
#! 5
#! gap> NeighbourFaceByEdge(complex, 1, 3);
#! fail
#! gap> NeighbourFaceByEdge(complex, 4, 11);
#! fail
#! @EndExampleSession
#!
#! @Returns a positive integer or <K>fail</K>
#! @Arguments complex, face, edge
DeclareOperation("NeighbourFaceByEdge", 
        [IsPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, face, edge
DeclareOperation("NeighbourFaceByEdgeNC",
        [IsPolygonalComplex, IsPosInt, IsPosInt]);
#! @EndGroup


#! @Section Face-induced order of incident vertices/edges
#! @SectionLabel Access_OrderedFaceAccess
#!
#! In section <Ref Sect="Section_Access_BasicAccess"/> we
#! introduced the methods <K>VerticesOfFace</K>
#! (<Ref Subsect="VerticesOfFaces"/>) and <K>EdgesOfFace</K>
#! (<Ref Subsect="EdgesOfFaces"/>) to
#! determine the vertices and edges of a given face. A drawback of those
#! methods is that they always return sets.
#! This might not be sufficient in the case of non-triangular faces, as
#! shown in
#! the following example.
#! <Alt Only="TikZ">
#!   \input{Image_PentagonCyclicOrder.tex}
#! </Alt>
#! @ExampleSession
#! gap> pentagon := PolygonalSurfaceByDownwardIncidence( 
#! >    [,[3,9],[2,6],[1,9],,[2,3],,[1,6]], 
#! >    [, [2,3,4,6,8]] );;
#! gap> VerticesOfFace(pentagon,2);
#! [ 1, 2, 3, 6, 9 ]
#! gap> EdgesOfFace(pentagon,2);
#! [ 2, 3, 4, 6, 8 ]
#! @EndExampleSession
#! If we want to know in which order the vertices (or edges) are
#! arranged around the perimeter of the given face, the previous methods 
#! are quite clumsy. For that reason the method 
#! <K>PerimeterOfFace</K> was written.
#! 
#! @ExampleSession
#! gap> perim := PerimeterOfFace( pentagon, 2 );
#! ( v1, E8, v6, E3, v2, E6, v3, E2, v9, E4, v1 )
#! @EndExampleSession
#!
#! It returns the perimeter as a vertex-edge-path, not a list (all available
#! methods for vertex-edge-paths can be found in section 
#! <Ref Sect="Section_Paths_VertexEdge"/>).
#! @BeginExampleSession
#! gap> IsList(perim);
#! false
#! gap> IsVertexEdgePath(perim);
#! true
#! @EndExampleSession
#!
#! @InsertChunk Definition_VertexEdgePath
#!
#! The order of vertices and edges is best described by a cyclic permutation.
#! @ExampleSession
#! gap> VerticesAsPerm(perim);
#! (1,6,2,3,9)
#! gap> EdgesAsPerm(perim);
#! (2,4,8,3,6)
#! @EndExampleSession
#!
#! There are two possible cyclic permutations of vertices and edges
#! (clockwise and 
#! counter-clockwise). Since the method has to return a unique value,
#! one of them has to be picked as a convention. We choose this one, 
#! since the vertex permutation has the smaller image under 1 (the
#! smallest of the vertices).
#!
#! While the permutation representation is most natural, in many cases
#! a list would be more convenient (be careful, the first vertex is 
#! repeated at the end!).
#! @ExampleSession
#! gap> VerticesAsList(perim);
#! [ 1, 6, 2, 3, 9, 1 ]
#! gap> EdgesAsList(perim);
#! [ 8, 3, 6, 2, 4 ]
#! @EndExampleSession
#! While the vertex list starts with the smallest vertex, the edge list
#! will start with an edge incident to the smallest vertex (the other
#! end is the smaller of the two adjacent vertices).

#! @BeginGroup PerimetersOfFaces
#! @Description
#! The operation 
#! <K>PerimeterOfFaces</K>(<A>complex</A>,<A>face</A>) returns a closed
#! vertex-edge-path (for the exact definition compare 
#! <Ref Subsect="VertexEdgePath"/> and 
#! <Ref Subsect="VertexEdge_IsClosedPath"/>) of
#! all vertices and edges incident to the given <A>face</A>.
#!
#! Since this condition does not define the path uniquely, we further 
#! stipulate that the smallest vertex is followed by the smallest possible
#! vertex. If that is not unique (for a face with only two vertices), the
#! smallest vertex is followed by the smallest possible edge.
#! 
#! The attribute <K>PerimetersOfFaces</K>(<A>complex</A>) 
#! collects all of those vertex-edge-paths in a list that is indexed by the face 
#! labels, i.e. 
#! <K>PerimetersOfFaces</K>(<A>complex</A>)[<A>face</A>]
#! = <K>PerimeterOfFace</K>(<A>complex</A>, <A>face</A>). All
#! other positions of this list are not bound.
#! 
#! The NC-version does not check if the given <A>face</A> is a face of the
#! given <A>complex</A>.
#! The operations
#! 
#! As an example consider the polygonal complex that was introduced at the
#! start of section
#! <Ref Sect="Section_Access_OrderedFaceAccess"/>:
#! <Alt Only="TikZ">
#!   \input{Image_PentagonCyclicOrder.tex}
#! </Alt>
#! @ExampleSession
#! gap> perim := PerimeterOfFace(pentagon, 2);
#! ( v1, E8, v6, E3, v2, E6, v3, E2, v9, E4, v1 )
#! gap> PathAsList(perim);
#! [ 1, 8, 6, 3, 2, 6, 3, 2, 9, 4, 1 ]
#! gap> VerticesAsList(perim);
#! [ 1, 6, 2, 3, 9, 1 ]
#! gap> EdgesAsList(perim);
#! [ 8, 3, 6, 2, 4 ]
#! gap> VerticesAsPerm(perim);
#! (1,6,2,3,9)
#! gap> EdgesAsPerm(perim);
#! (2,4,8,3,6)
#! gap> PerimetersOfFaces(pentagon);
#! [ , ( v1, E8, v6, E3, v2, E6, v3, E2, v9, E4, v1 ) ]
#! @EndExampleSession
#! 
#! @Arguments complex
#! @Returns a list of vertex-edge-paths
DeclareAttribute( "PerimetersOfFaces", IsPolygonalComplex );
#! @Arguments complex, face
DeclareOperation( "PerimeterOfFace", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "PerimeterOfFaceNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @Section Circular path of edges and faces around a vertex
#! @SectionLabel Access_OrderedVertexAccess
#!
##
## We have to be careful here since people might see this section very
## early (if they are led by the headings). Therefore we can't assume that
## they know the polygonal hierarchy.
##
## WARNING: We have to be careful with our examples - it should always be
## obvious whether we start with an edge or with a face. There should never
## be an example where the first three (better: two) elements of the path might be
## [face, edge, face], since this might cause confusion in readers.
## Why "never"? Because if someone has this question, it should be answered
## immediately. This is a wonderful way of using an example since the question
## will be answered by looking at any example.
##
## Right now, this can't happen since the labels are all different (this is
## useful to find the appropriate numbers more effectively - especially if
## some of the are roman numerals).
##
#! In section <Ref Sect="Section_Access_BasicAccess"/> the methods 
#! <K>EdgesOfVertex</K> (<Ref Subsect="EdgesOfVertices"/>) and
#! <K>FacesOfVertex</K> (<Ref Subsect="FacesOfVertices"/>) were introduced. 
#! They
#! allow access to the edges and faces incident to a vertex but they don't
#! give any information about the relationship between them
#!
#!         For polygonal surfaces (that were introduced in section
#!         <Ref Sect="PolygonalStructures_surface"/>) there is a natural 
#!         ordering of the edges and 
#!         faces that are incident to a vertex. It is achieved by "travelling 
#!         around the vertex" while staying on the surface. 
#! This order is called <E>umbrella</E> and we formalize it
#! by <E>edge-face-paths</E> (section <Ref Sect="Section_Paths_EdgeFace"/>
#! contains the methods to access those paths).
#!         <Alt Only="TikZ">
#!           \input{Image_EdgeFacePath.tex}
#!         </Alt>
#! 
#! <#Include Label="Umbrella_Definition">
#! 
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle];
#!      \input{Image_EdgeFacePath_open.tex}
#!   \end{tikzpicture}
#! </Alt>
#! In the image above we have two umbrellas that contain all edges and
#! faces that are incident to the vertex <M>V</M>, namely
#! <M>(e_1,f_1,e_2,f_2,e_3,f_3,e_4)</M> and 
#! <M>(e_4,f_3,e_3,f_2,e_2,f_1,e_1)</M>. Both of them encode the same
#! information. By convention, we will choose the umbrella with the smaller first 
#! entry
#! (<M>e_1</M> or <M>e_4</M>) to be <E>the</E> umbrella of <M>V</M>.
#!
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle];
#!     \input{Image_EdgeFacePath_closed.tex}
#!   \end{tikzpicture}
#! </Alt>
#! In this image we have ten different closed umbrellas that contain all
#! edges and faces that are incident to the vertex <M>V</M>, like
#!  <M>(e_1, f_1, e_2, f_2, e_3, f_3, e_4, f_4, e_5, f_5, e_1)</M> and 
#! <M>(e_3, f_2, e_2, f_1, e_1, f_5, e_5, f_4, e_4, f_3, e_3)</M>. Up to cyclic 
#! permutation
#! and inversion they are equivalent (they form an orbit under the dihedral 
#! group of order
#! 10).
#! 
#! If we have to pick one by convention, we will choose the first entry to be
#! minimal, say <M>e_2</M>. This leaves us with the two paths
#! <M>(e_2,f_2,\ldots)</M> and <M>(e_2,f_1,\ldots)</M>. Of those, we pick the one
#! with the smallest second entry (<M>f_2</M> or <M>f_1</M>).
#TODO is this a good convention?
#! 
    
#! @BeginGroup UmbrellasOfVertices
#! @Description
#! The method <K>UmbrellaOfVertex</K>(<A>surface</A>,<A>vertex</A>)
#! returns an umbrella around <A>vertex</A> (as defined in section
#! <Ref Sect="Section_Access_OrderedVertexAccess"/>) that contains all edges
#! and faces incident to <A>vertex</A>, with the following 
#! conventions:
#! * The first entry of the umbrella is minimal.
#! * In the case of a closed umbrella, after restricting with the
#!   first convention, the second entry of the umbrella is minimal.
#! 
#! If such an umbrella does not exist (might happen for general
#! polygonal complexes) or is not unique (might happen for general ramified
#! polygonal surfaces), <K>fail</K> is returned. To access the contents
#! of the umbrellas, the methods from section 
#! <Ref Sect="Section_Paths_EdgeFace"/> can be used.
#! 
#! The attribute <K>UmbrellasOfVertices</K>(<A>surface</A>) collects all
#! of those umbrellas in a list that is indexed by the vertex labels,
#! i.e. <K>UmbrellasOfVertices</K>(<A>surface</A>)[<A>vertex</A>] = 
#! <K>UmbrellaOfVertex</K>(<A>surface</A>, <A>vertex</A>). All other 
#! positions of this list are not bound.
#! 
#! The NC-version does not check whether the given <A>vertex</A> lies in the
#! given <A>surface</A>.
#! 
#! Since for ramified polygonal surfaces the umbrellas around a vertex
#! are
#! not unique, there are the methods from
#! <Ref Subsect="UmbrellaPartitionsOfVertices"/> that return all of
#! those umbrellas.
#! 
#! As example consider the following polygonal surface:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \def\dist{1.8}
#!     \coordinate (P2) at (0,0);
#!     \coordinate (PEE) at (2*\dist,0);
#!     \coordinate (PSE) at (\dist,-\dist);
#!     \coordinate (PSW) at (-\dist,-\dist);
#!     \coordinate (PNW) at (-\dist,\dist);
#!     \coordinate (PNE) at (\dist,\dist);
#!
#!     \draw[edge, face]
#!       (P2) -- (PNE) -- node[edgeLabel]{16} (PEE) -- node[edgeLabel]{17} (PSE) -- cycle
#!       (P2) -- node[edgeLabel]{13} (PSE) -- node[edgeLabel]{18} (PSW) -- cycle
#!       (P2) -- node[edgeLabel]{14} (PSW) -- node[edgeLabel]{19} (PNW) -- cycle
#!       (P2) -- node[edgeLabel]{11} (PNW) -- node[edgeLabel]{15} (PNE) -- node[edgeLabel]{12} cycle;
#!     \node[faceLabel] at (barycentric cs:P2=1,PNE=1,PEE=1,PSE=1) {$III$};
#!     \node[faceLabel] at (barycentric cs:P2=1,PSE=1,PSW=1) {$IV$};
#!     \node[faceLabel] at (barycentric cs:P2=1,PSW=1,PNW=1) {$V$};
#!     \node[faceLabel] at (barycentric cs:P2=1,PNW=1,PNE=1) {$II$};
#!
#!     \foreach \p/\r/\n in {P2/right/1, PEE/right/8, PSE/below/9, PSW/below/10, PNW/above/6, PNE/above/7}{
#!       \vertexLabelR{\p}{\r}{\n}
#!     }
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> surface := PolygonalSurfaceByDownwardIncidence( 
#! >    [,,,,,,,,,, [1,6],[1,7],[1,9],[1,10],[6,7],[7,8],[8,9],[9,10],[10,6]],
#! >    [,[11,12,15],[12,13,16,17],[14,13,18],[11,19,14]] );;
#! gap> um1 := UmbrellaOfVertex(surface, 1);
#! ( e11, F2, e12, F3, e13, F4, e14, F5, e11 )
#! gap> EdgesAsList(um1);
#! [ 11, 12, 13, 14, 11 ]
#! gap> EdgesAsPerm(um1);
#! (11,12,13,14)
#! gap> um7 := UmbrellaOfVertex(surface, 7);
#! | e15, F2, e12, F3, e16 |
#! gap> EdgesAsList(um7);
#! [ 15, 12, 16 ]
#! gap> FacesAsList(um7);
#! [ 2, 3 ]
#! gap> UmbrellasOfVertices(surface);
#! [ ( e11, F2, e12, F3, e13, F4, e14, F5, e11 ),,,,, | e15, F2, e11, F5, e19 |, 
#!      | e15, F2, e12, F3, e16 |, | e16, F3, e17 |, 
#!      | e17, F3, e13, F4, e18 |, | e18, F4, e14, F5, e19 | ]
#! @EndExampleSession
#! 
#! @Returns a list of edge-face-paths
#! @Arguments surface
DeclareAttribute( "UmbrellasOfVertices", IsPolygonalComplex );
#! @Returns an edge-face-path
#! @Arguments surface, vertex
DeclareOperation( "UmbrellaOfVertex", [IsPolygonalComplex, IsPosInt] );
#! @Arguments surface, vertex
DeclareOperation( "UmbrellaOfVertexNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#! For ramified polygonal surfaces it might happen that there is no single
#! umbrella that contains all edges and faces that are incident to one
#! vertex.
#! <Alt Only="TikZ">
#!   \input{Image_EdgeFacePath_ramified.tex}
#! </Alt>
#! But there is a set of umbrellas that <E>partitions</E> the incident
#! edges and faces (i.e. every incident edge or face appears in exactly one
#! of the umbrellas). In the above image, the umbrella-partition of
#! the vertex 1 is
#! <M>[ [ 14, 2, 18, 4, 16, 3, 14 ], [ 19, 9, 20, 11, 21 ] ]</M>.


#! @BeginGroup UmbrellaPartitionsOfVertices
#! @Description
#! The method 
#! <K>UmbrellaPartitionOfVertex</K>(<A>ramSurf</A>, <A>vertex</A>) returns
#! a set of umbrellas around <A>vertex</A> (as defined in section
#! <Ref Sect="Section_Access_OrderedVertexAccess"/>). The edges
#! and faces incident to <A>vertex</A> are partitioned by these umbrellas
#! (i.e. each of them appears in exactly
#! one umbrella).
#! 
#! The result is determined as follows:
#! * The partition of edges and faces is unique (reachability by 
#!   umbrellas around <A>vertex</A>).
#! * Every set in this partition consists of the elements of exactly
#!   one umbrella. For each set there are several options. We choose
#!   one of those by this convention:
#!   * The first entry of the returned umbrella will be as small as
#!     possible.
#!   * The second entry of the returned umbrella will be as small as
#!     possible (after having minimized the first entry). This condition is
#!     non-trivial only for closed umbrellas.
#!
#! If there is no such set of umbrellas (which can happen for general polygonal
#! complexes), <K>fail</K> is returned instead.
#! 
#! The attribute <K>UmbrellaPartitionsOfVertices</K>(<A>ramSurf</A>)
#! collects these partitions in a list (indexed by the vertex
#! labels), i.e. 
#! <K>UmbrellaPartitionsOfVertices</K>(<A>ramSurf</A>)[<A>vertex</A>] =
#! <K>UmbrellaPartitionOfVertex</K>(<A>ramSurf</A>, <A>vertex</A>).
#! All other positions of this list are not bound.
#! 
#! For a <E>polygonal surface</E>, all partitions will only consist of
#! one element. In this case, the methods
#! in <Ref Subsect="UmbrellasOfVertices"/> will only return these unique 
#! umbrellas.
#! 
#! The NC-version does not check whether <A>vertex</A> lies in <A>ramSurf</A>.
#! 
#! As example consider the following ramified polygonal surface.
#! <Alt Only="TikZ">
#!   \input{Image_EdgeFacePath_ramified.tex}
#! </Alt>
#! @ExampleSession
#! gap> ramSurf := RamifiedPolygonalSurfaceByDownwardIncidence(
#! >    [ ,,,,,,,,,,,,[6,5],[1,5],[5,7],[6,1],[6,7],[1,7],
#! >        [1,8],[1,10],[1,12],[8,10],[10,12] ],
#! >    [ , [14,15,18],[13,14,16],[16,17,18],,,,,[19,22,20],,[20,21,23] ]);;
#! gap> UmbrellaPartitionOfVertex(ramSurf, 1);
#! [ ( e14, F2, e18, F4, e16, F3, e14 ), | e19, F9, e20, F11, e21 | ]
#! gap> UmbrellaPartitionOfVertex(ramSurf, 5);
#! [ | e13, F3, e14, F2, e15 | ]
#! gap> UmbrellaPartitionsOfVertices(ramSurf);
#! [ [ ( e14, F2, e18, F4, e16, F3, e14 ), | e19, F9, e20, F11, e21 | ],,,,
#!   [ | e13, F3, e14, F2, e15 | ], [ | e13, F3, e16, F4, e17 | ],
#!   [ | e15, F2, e18, F4, e17 | ], [ | e19, F9, e22 | ],,
#!   [ | e22, F9, e20, F11, e23 | ],, [ | e21, F11, e23 | ] ]
#! @EndExampleSession
#!
#! @Returns a list of sets of edge-face-paths
#! @Arguments ramSurf
DeclareAttribute( "UmbrellaPartitionsOfVertices", 
        IsPolygonalComplex );
#! @Returns a set of edge-face-paths
#! @Arguments ramSurf, vertex
DeclareOperation( "UmbrellaPartitionOfVertex",
        [ IsPolygonalComplex, IsPosInt ]);
#! @Arguments ramSurf, vertex
DeclareOperation( "UmbrellaPartitionOfVertexNC",
        [ IsPolygonalComplex, IsPosInt ]);
#! @EndGroup


#! @Section Perimeter around holes in surfaces
#! @SectionLabel Access_OrderedHoleAccess
#!
#! If a polygonal surface (introduced in 
#! <Ref Sect="PolygonalStructures_surface"/>) is not closed, it has at least
#! one "hole". For example the open pyramid and the open bag each have
#! one hole:
#!
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexPlain=nolabels,edgeStyle=nolabels,faceStyle=nolabels]
#!     \begin{scope}[scale=2,xshift=0cm]
#!       \input{Image_OpenPyramid.tex}
#!     \end{scope}
#!     \begin{scope}[scale=0.9,xshift=8cm]
#!       \input{Image_OpenBag.tex}
#!     \end{scope}
#!   \end{tikzpicture}
#! </Alt>
#!
#! Informally, a hole can be characterised by the vertices and edges along its
#! perimeter. These can be given as an alternating path of vertices and edges
#! that starts and stops with the same vertex. This notion is formalized by
#! <E>vertex-edge-paths</E> which are defined in more detail in section
#! <Ref Sect="Section_Paths_VertexEdge"/>.
#!
#! TODO example with access to vertices and edges
#! TODO These examples should include holes of different sizes: at least 2, 3 and 4 edges
#!

#! @Description
#! Return a set of closed vertex-edge-paths (compare 
#! <Ref Subsect="VertexEdgePath"/> and <Ref Subsect="VertexEdge_IsClosedPath"/> for
#! the exact definitions) that represent the holes in the given polygonal
#! surface.
#!
#! For each hole there is a unique perimeter of boundary vertices and edges.
#! To each of these we associate a unique closed vertex-edge-path by the 
#! following conventions:
#! * It starts with the smallest vertex on the perimeter
#! * After using the first condition, the next vertex is as small as possible
#! * After using the first two conditions, the first edge is minimal
#!
#! All of those vertex-edge-paths are returned as a set.
#! TODO example
#!
#! @Arguments surface
#! @Returns a set of closed vertex-edge-paths
DeclareAttribute( "PerimeterOfHoles", IsPolygonalSurface );

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

#! In most cases the methods of section
#! <Ref Sect="Section_Access_BasicAccess"/> (that return incident elements
#! as a set) are sufficient. The subsequent sections contain more specific
#! access methods.
#TODO badly written as it is

#! @Section Labels of vertices, edges and faces
#! @SectionLabel Access_LabelAccess
#!
#! In polygonal complexes (the most general supported incidence structure,
#! compare chapter <Ref Chap="PolygonalStructures"/>) all vertices, edges
#! and faces are labelled by positive integers.
#! These labels do not have to be disjoint as shown in the following example:
#! <Alt Only="TikZ">
#!     {
#!         \def\allLabels{1}
#!         \input{Image_LabellingExample.tex}
#!     }
#! </Alt>
#TODO give a reference to the constructor
#! @BeginExample
complex := PolygonalComplexByDownwardIncidence( 4, 4, 1,
    [ , [2,3], [2,5], , [3,7], [5,7] ], [ , , [2,3,5,6] ] );;
#! @EndExample
#
#! We can access the sets of
#! all those labels by <K>Vertices</K>, <K>Edges</K> and <K>Faces</K>.
#! If only the number of vertices is relevant, we can use <K>NrOfVertices</K>
#! instead (likewise for edges and faces).

#! @BeginGroup
## TODO check if grape has changed their definition of Vertices
#! @Description
#! Return the set/number of vertices.
#! <Par/>
#! As an example consider the polygonal complex from the beginning of section
#! <Ref Sect="Section_Access_LabelAccess"/>:
#! <Alt Only="TikZ">
#!      {
#!          \def\allLabels{1}
#!          \input{Image_LabellingExample.tex}
#!      }
#! </Alt>
#! @BeginExample
Vertices(complex);
#! [ 2, 3, 5, 7 ]
NrOfVertices(complex);
#! 4
#! @EndExample
#! <Par/>
#! We have separated the operation <K>Vertices</K> from the corresponding
#! attribute because there is a naming clash with the package grape.
#! @Arguments complex
#! @Returns A set of positive integers/a non-negative integer
DeclareOperation( "Vertices", [IsPolygonalComplex] );
#! @Arguments complex
DeclareAttribute( "VerticesAttributeOfPolygonalComplex", IsPolygonalComplex );
#! @Arguments complex
DeclareAttribute( "NrOfVertices", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup
#! @Description
#! Return the set/number of edges.
#! <Par/>
#! As an example consider the polygonal complex from the beginning of section
#! <Ref Sect="Section_Access_LabelAccess"/>:
#! <Alt Only="TikZ">
#!      {
#!          \def\allLabels{1}
#!          \input{Image_LabellingExample.tex}
#!      }
#! </Alt>
#! @BeginExample
Edges(complex);
#! [ 2, 3, 5, 6 ]
NrOfEdges(complex);
#! 4
#! @EndExample
#
#! @Arguments complex
#! @Returns A set of positive integers/a non-negative integer
DeclareAttribute( "Edges", IsPolygonalComplex );
#! @Arguments complex
DeclareAttribute( "NrOfEdges", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup
#! @Description
#! Return the set/number of faces.
#! <Par/>
#! As an example consider the polygonal complex from the beginning of section
#! <Ref Sect="Section_Access_LabelAccess"/>:
#! <Alt Only="TikZ">
#!      {
#!          \def\allLabels{1}
#!          \input{Image_LabellingExample.tex}
#!      }
#! </Alt>
#! @BeginExample
Faces(complex);
#! [ 3 ]
NrOfFaces(complex);
# 1
#! @EndExample
#
#! @Arguments complex
#! @Returns A set of positive integers/a non-negative integer
DeclareAttribute( "Faces", IsPolygonalComplex );
#! @Arguments complex
DeclareAttribute( "NrOfFaces", IsPolygonalComplex );
#! @EndGroup


#! @Section Incidence between vertices, edges and faces
#! @SectionLabel Access_BasicAccess
#!
#! With the labels of vertices, edges and faces (which we can access by the
#! methods of section <Ref Sect="Section_Access_LabelAccess"/>) we can 
#! describe the incidence structure by lists of sets.
#! All those methods have the form *Of*, e.g. <K>VerticesOfFaces</K> and 
#! <K>EdgesOfVertices</K>.
#! <Par/>
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
#! {
#! \def\allLabels{1}
#! \input{Image_StarOfStarExample.tex}
#! }
#! </Alt>
#!
#TODO give a reference to the constructor
#! @BeginExample
complex := PolygonalComplexByDownwardIncidence( 5, 6, 2, 
    [ , , , , , [2,5], , [2,3], [3,5], [11,5], , [3,7], [7,11] ], 
    [[6,8,9], , , [9,10,12,13]]);;
Vertices(complex);
#! [ 2, 3, 5, 7, 11 ]
Edges(complex);
#! [ 6, 8, 9, 10, 12, 13 ]
Faces(complex);
#! [ 1, 4 ]
#! @EndExample
#!
#! The method <K>VerticesOfFaces</K> tells us, which vertices are incident
#! to which faces.
#! @BeginExample
VerticesOfFaces(complex);
#! [ [ 2, 3, 5 ], , , [ 3, 5, 7, 11 ] ];
#! @EndExample
#! The first entry of this list contains a set of all vertices that are
#! incident to face I. The second and third entries are not bounded since
#! there are no faces II and III. Finally, the fourth entry contains all
#! vertices that are incident to face IV.
#! <Par/>
#! So we have a list that contains sets of vertices and is indexed by the 
#! face labels.
#! <Par/>
#! The method <K>EdgesOfVertices</K> works in the same way: It returns a list
#! that contains sets of edges and is indexed by the vertex labels.
#! @BeginExample
EdgesOfVertices(complex);
#! [ , [ 6, 8 ], [ 8, 9, 12 ], , [ 6, 9, 10 ], , [ 12, 13 ], , , , [ 10, 13 ] ]
#! @EndExample
#! For example, if we consider the third entry of this list, we find the
#! set [ 8, 9, 12 ]. Those are all edges that are incident to the vertex 3.
#! <Par/>
#! In the same way all other *Of*-methods are defined.


#TODO mention 'ordered' access
#! @BeginGroup
#! @Description
#! The method <K>EdgesOfVertex</K>(<A>complex</A>, <A>vertex</A>) returns the
#! set of all edges that are incident to <A>vertex</A>. The NC-version does
#! not check whether the given <A>vertex</A> is a vertex of <A>complex</A>.
#! <Par/>
#! The attribute <K>EdgesOfVertices</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the vertex labels, i.e.
#! <K>EdgesOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>EdgesOfVertex</K>(<A>complex</A>, <A>vertex</A>).
#! All other positions of this list are not bounded.
#! <Par/>
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   {
#!     \def\vertexLabels{1}
#!     \def\edgeLabels{1}
#!     \input{Image_StarOfStarExample.tex}
#!   }
#! </Alt>
#! @BeginExample
EdgesOfVertex(complex, 2);
#! [ 6, 8 ]
EdgesOfVertex(complex, 5);
#! [ 6, 9, 10 ]
EdgesOfVertices(complex);
#! [ , [ 6, 8 ], [ 8, 9, 12 ], , [ 6, 9, 10 ], , [ 12, 13 ], , , [ 10, 13 ] ]
#! @EndExample
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
#! @BeginGroup
#! @Description
#! The method <K>FacesOfVertex</K>(<A>complex</A>, <A>vertex</A>) returns the
#! set of all faces that are incident to <A>vertex</A>. The NC-version does
#! not check whether the given <A>vertex</A> is a vertex of <A>complex</A>.
#! <Par/>
#! The attribute <K>FacesOfVertices</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the vertex labels, i.e.
#! <K>FacesOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>FacesOfVertex</K>(<A>complex</A>, <A>vertex</A>).
#! All other positions of this list are not bounded.
#! <Par/>
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   {
#!     \def\vertexLabels{1}
#!     \def\faceLabels{1}
#!     \input{Image_StarOfStarExample.tex}
#!   }
#! </Alt>
#! @BeginExample
FacesOfVertex(complex, 2);
#! [ 1 ]
FacesOfVertex(complex, 5);
#! [ 1, 4 ]
FacesOfVertices(complex);
#! [ , [ 1 ], [ 1, 4 ], , [ 1, 4 ], , [ 4 ], , , [ 4 ] ]
#! @EndExample
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "FacesOfVertices", IsPolygonalComplex );
#! @Arguments complex, vertex
DeclareOperation( "FacesOfVertex", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "FacesOfVertexNC", [IsPolygonalComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup
#! @Description
#! The method <K>VerticesOfEdge</K>(<A>complex</A>, <A>edge</A>) returns the
#! set of all vertices that are incident to <A>edge</A>. The NC-version does
#! not check whether the given <A>edge</A> is an edge of <A>complex</A>.
#! <Par/>
#! The attribute <K>VerticesOfEdges</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the edge labels, i.e.
#! <K>VerticesOfEdges</K>(<A>complex</A>)[<A>edge</A>] = 
#! <K>VerticesOfEdge</K>(<A>complex</A>, <A>edge</A>).
#! All other positions of this list are not bounded.
#! <Par/>
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   {
#!     \def\vertexLabels{1}
#!     \def\edgeLabels{1}
#!     \input{Image_StarOfStarExample.tex}
#!   }
#! </Alt>
#! @BeginExample
VerticesOfEdge(complex, 8);
#! [ 2, 3 ]
VerticesOfEdge(complex, 12);
#! [ 3, 7 ]
VerticesOfEdges(complex);
#! [ , , , , , [ 2, 5 ], , [ 2, 3 ], [ 3, 5 ], [ 5, 11 ], , [ 3, 7 ], [ 7, 11 ] ]
#! @EndExample
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "VerticesOfEdges", IsPolygonalComplex );
#! @Arguments complex, edge
DeclareOperation( "VerticesOfEdge", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, edge
DeclareOperation( "VerticesOfEdgeNC", [IsPolygonalComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup
#! @Description
#! The method <K>FacesOfEdge</K>(<A>complex</A>, <A>edge</A>) returns the
#! set of all faces that are incident to <A>edge</A>. The NC-version does
#! not check whether the given <A>edge</A> is an edge of <A>complex</A>.
#! <Par/>
#! The attribute <K>FacesOfEdges</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the edge labels, i.e.
#! <K>FacesOfEdges</K>(<A>complex</A>)[<A>edge</A>] = 
#! <K>FacesOfEdge</K>(<A>complex</A>, <A>edge</A>).
#! All other positions of this list are not bounded.
#! <Par/>
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   {
#!     \def\edgeLabels{1}
#!     \def\faceLabels{1}
#!     \input{Image_StarOfStarExample.tex}
#!   }
#! </Alt>
#! @BeginExample
FacesOfEdge(complex, 9);
#! [ 1, 4 ]
FacesOfEdge(complex, 10);
#! [ 4 ]
FacesOfEdges(complex);
#! [ , , , , , [ 1 ], , [ 1 ], [ 1, 4 ], [ 4 ], , [ 4 ], [ 4 ] ]
#! @EndExample
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
#! @BeginGroup
#! @Description
#! The method <K>VerticesOfFace</K>(<A>complex</A>, <A>face</A>) returns the
#! set of all vertices that are incident to <A>face</A>. The NC-version does
#! not check whether the given <A>face</A> is a face of <A>complex</A>.
#! <Par/>
#! The attribute <K>VerticesOfFaces</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the face labels, i.e.
#! <K>VerticesOfFaces</K>(<A>complex</A>)[<A>face</A>] = 
#! <K>VerticesOfFace</K>(<A>complex</A>, <A>face</A>).
#! All other positions of this list are not bounded.
#! <Par/>
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   {
#!     \def\vertexLabels{1}
#!     \def\faceLabels{1}
#!     \input{Image_StarOfStarExample.tex}
#!   }
#! </Alt>
#! @BeginExample
VerticesOfFace(complex, 1);
#! [ 2, 3, 5 ]
VerticesOfFace(complex, 4);
#! [ 3, 5, 7, 11 ]
VerticesOfFaces(complex);
#! [ [ 2, 3, 5 ], , , [ 3, 5, 7, 11 ] ]
#! @EndExample
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
#! @BeginGroup
#! @Description
#! The method <K>EdgesOfFace</K>(<A>complex</A>, <A>face</A>) returns the
#! set of all edges that are incident to <A>faces</A>. The NC-version does
#! not check whether the given <A>face</A> is a face of <A>complex</A>.
#! <Par/>
#! The attribute <K>EdgesOfFaces</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the face labels, i.e.
#! <K>EdgesOfFaces</K>(<A>complex</A>)[<A>face</A>] = 
#! <K>EdgesOfFace</K>(<A>complex</A>, <A>face</A>).
#! All other positions of this list are not bounded.
#! <Par/>
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   {
#!     \def\edgeLabels{1}
#!     \def\faceLabels{1}
#!     \input{Image_StarOfStarExample.tex}
#!   }
#! </Alt>
#! @BeginExample
EdgesOfFace(complex, 1);
#! [ 6, 8, 9 ]
EdgesOfFace(complex, 4);
#! [ 9, 10, 12, 13 ]
EdgesOfFaces(complex);
#! [ [ 6, 8, 9 ], , , [ 9, 10, 12, 13 ] ]
#! @EndExample
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
#! @BeginExample
complex := PolygonalComplexByDownwardIncidence( 
        [[1,2],[2,5],[2,6],[2,6],[1,6],[5,6],[1,7],[6,8],[5,9],[7,8],[8,9]],
        [[1,3,5],[5,7,8,10],,[6,8,9,11],[2,4,6]]);;
#! @EndExample
#!
#! This section contains the following methods:
#! * <K>EdgeInFaceByVertices</K> returns the edge of a face that is defined by
#!   its two vertices.
#! @BeginExample
EdgeInFaceByVertices( complex, 5, [2,6] );
#! 4
#! @EndExample
#! * <K>OtherEdgeOfVertexInFace</K> returns the other edge of a given vertex
#!   with respect to the given face.
#! @BeginExample
OtherEdgeOfVertexInFace( complex, 1, 5, 2 );
#! 7
#! @EndExample
#! * <K>OtherVertexOfEdge</K> returns the other vertex of the given edge
#! @BeginExample
OtherVertexOfEdge( complex, 7, 10 );
#! 8
#! @EndExample
#! * <K>NeighbourFaceByEdge</K> returns the face that is adjacent to the
#!   given face (with respect to the given edge)
#! @BeginExample
NeighbourFaceByEdge( complex, 2, 8 );
#! 4
#! @EndExample
#! 
#TODO link these descriptions to the manpages

#! @BeginGroup
#! @Description
#! Given a face and a list of two vertices of a polygonal complex, return the 
#! edge that
#! lies in the given face and is incident to the given vertices.
#! <Par/>
#! If there is no such edge (because the given vertices are not incident to
#! the given face or because they are not connected by an edge of the face),
#! return <K>fail</K>.
#! <Par/>
#! The NC-version does not check if <A>face</A> is a face of the given
#! polygonal complex.
#! <Par/>
#! As an example consider the polygonal complex from the start of section
#! <Ref Sect="Section_Access_SpecializedAccess"/>:
#! <Alt Only="TikZ">
#!   \input{Image_EyeStone.tex}
#! </Alt>
#! @BeginExample
EdgeInFaceByVertices(complex, 5, [2,6]);
#! 4
EdgeInFaceByVertices(complex, 1, [2,1]);
#! 1
EdgeInFaceByVertices(complex, 1, [2,6]);
#! 3
EdgeInFaceByVertices(complex, 2, [1,2]);
#! fail
EdgeInFaceByVertices(complex, 4, [5,8]);
#! fail
#! @EndExample
#!
#! @Returns a positive integer
#! @Arguments complex, face, verts
DeclareOperation(EdgeInFaceByVertices, [IsPolygonalComplex, IsPosInt, IsList]);
#! @Arguments complex, face, verts
DeclareOperation(EdgeInFaceByVerticesNC, 
        [IsPolygonalComplex, IsPosInt, IsList]);
#! @EndGroup


#! @BeginGroup
#! @Description
#! If a vertex is incident to a face in a polygonal complex, there are exactly
#! two edges that are incident to both vertex and face. If one of those is
#! given to this method, it will return the other one.
#! <Par/>
#! The NC-version does not check whether the given vertex, edge an face
#! actually lie in the complex and are incident to each other.
#! <Par/>
#! As an example consider the polygonal complex that was introduced at the
#! start of section
#! <Ref Sect="Section_Access_SpecializedAccess"/>:
#! <Alt Only="TikZ">
#!   \input{Image_EyeStone.tex}
#! </Alt>
#! @BeginExample
OtherEdgeOfVertexInFace(complex, 1, 5, 2);
#! 7
OtherEdgeOfVertexInFace(complex, 5, 9, 4);
#! 6
OtherEdgeOfVertexInFace(complex, 1, 5, 1);
#! 1
#! @EndExample
#!
#! @Returns a positive integer
#! @Arguments complex, vertex, edge, face
DeclareOperation(OtherEdgeOfVertexInFace, 
        [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt]);
#! @Arguments complex, vertex, edge, face
DeclareOperation(OtherEdgeOfVertexInFaceNC,
        [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt]);
#! @EndGroup


#! @BeginGroup
#! @Description
#! Every edge in a polygonal complex is incident to exactly two vertices.
#! Given one of them, this method returns the other one.
#! <Par/>
#! The NC-version does not check whether the given <A>edge</A> is an edge of 
#! the
#! polygonal complex and whether the given <A>vertex</A> is incident to it.
#! <Par/>
#! As an example consider the polygonal complex that was introduced at the
#! start of section
#! <Ref Sect="Section_Access_SpecializedAccess"/>:
#! <Alt Only="TikZ">
#!   \input{Image_EyeStone.tex}
#! </Alt>
#! @BeginExample
OtherVertexOfEdge(complex, 7, 10);
#! 8
OtherVertexOfEdge(complex, 1, 5);
#! 6
OtherVertexOfEdge(complex, 6, 8);
#! 8
#! @EndExample
#!
#! @Returns a positive integer
#! @Arguments complex, vertex, edge
DeclareOperation(OtherVertexOfEdge, [IsPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, vertex, edge
DeclareOperation(OtherVertexOfEdgeNC, 
        [IsPolygonalComplex, IsPosInt, IsPosInt]);
#! @EndGroup



#! @BeginGroup
#! @Description
#! If an edge is incident to exactly two faces and one of those is given,
#! this method returns the other one.
#! <Par/>
#! If this method is called for a boundary edge or a branching edge, it 
#! returns <K>fail</K>.
#! <Par/>
#! The NC-version does not check whether the given <A>edge</A> is an edge of
#! the polygonal complex and whether the given <A>face</A> is an incident face
#! of the complex.
#! <Par/>
#! As an example consider the polygonal complex that was introduced at the
#! start of section
#! <Alt Only="TikZ">
#!   \input{Image_EyeStone.tex}
#! </Alt>
#! @BeginExample
NeighbourFaceByEdge(complex, 2, 8);
#! 4
NeighbourFaceByEdge(complex, 1, 5);
#! 2
NeighbourFaceByEdge(complex, 4, 6);
#! 5
NeighbourFaceByEdge(complex, 1, 3);
#! fail
NeighbourFaceByEdge(complex, 4, 11);
#! fail
#! @EndExample
#!
#! @Returns a positive integer or fail
#! @Arguments complex, face, edge
DeclareOperation(NeighbourFaceByEdge, 
        [IsPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, face, edge
DeclareOperation(NeighbourFaceByEdgeNC,
        [IsPolygonalComplex, IsPosInt, IsPosInt]);
#! @EndGroup


#! @Section Face-induced order of incident vertices/edges
#! @SectionLabel Access_OrderedFaceAccess
#!
#! In section <Ref Sect="Section_Access_BasicAccess"/> we
#! introduced the methods <K>VerticesOfFace</K> and <K>EdgesOfFace</K> to
#! determine the vertices and edges of a given face. A drawback of those
#! methods is that they always return sets.
#! This might not be sufficient in the case of non-triangular faces, as
#! shown in
#! the following example.
#! <Alt Only="TikZ">
#!   \input{Image_PentagonCyclicOrder.tex}
#! </Alt>
#! @BeginExample
pentagon := PolygonalSurfaceByDownwardIncidence( 
    [,[3,6],[2,9],[1,6],,[2.3],,[1,9]], [, [2,3,4,6,8]] );;
VerticesOfFace(pentagon,2);
#! [ 1, 2, 3, 6, 9 ]
EdgesOfFace(pentagon,2);
#! [ 2, 3, 4, 6, 8 ]
#! @EndExample
#! If we want to know in which order the vertices (or edges) are
#! arranged around the boundary of the given face, the previous methods 
#! are quite clumsy. For that reason the methods 
#! <K>CyclicVertexOrderOfFace</K> and <K>CyclicEdgeOrderOfFace</K>
#! were written.
#! <Par/>
#! The cyclic order of the vertices is naturally represented by one of
#! the permutations (1,6,3,2,9) or (1,9,2,3,6).
#TODO put a link to permutations in the GAP-Manual here
#! Since the operation should return a unique value, we have to pick
#! one of these as a convention. We choose (1,6,3,2,9), since it has
#! the smallest image under 1 (the smallest of the vertices).
#! <Par/>
#! Likewise we have the permutations (2,6,3,8,4) and (2,4,8,3,6) for
#! the cyclic order of the edges. With the same convention we choose
#! (2,4,8,3,6) as the designated return value. 
#! <Par/>
#! @BeginExample
CyclicVertexOrderOfFace( pentagon, 2 );
#! ( 1, 6, 3, 2, 9 )
CyclicEdgeOrderOfFace( pentagon, 2 );
#! ( 2, 4, 8, 3, 6 )
#! @EndExample
#!
#! While the permutation representation is most natural, in many cases
#! a list would be more convenient. For this reason the permutations
#! (1,6,3,2,9) and (2,4,8,3,6) can also be given as the lists
#! [1,6,3,2,9] and [2,4,8,3,6].
#! @BeginExample
CyclicVertexOrderOfFaceAsList( pentagon, 2 );
#! [ 1, 6, 3, 2, 9 ];
CyclicEdgeOrderOfFaceAsList( pentagon, 2 );
#! [ 2, 4, 8, 3, 6 ];
#! @EndExample
#!
#! Since it might be confusing to remember whether the permutation or
#! the list representation is the default one, we also offer the operations
#! <K>CyclicVertexOrderOfFaceAsPerm</K> and
#! <K>CyclicEdgeOrderOfFaceAsPerm</K>.
#!
#! @BeginExample
CyclicVertexOrderOfFaceAsPerm( pentagon, 2 );
#! ( 1, 6, 3, 2, 9 )
CyclicEdgeOrderOfFaceAsPerm( pentagon, 2 );
#! ( 2, 4, 8, 3, 6 )
#! @EndExample
#!

#! @BeginGroup
#! @Description
#! The operation 
#! <K>CyclicVertexOrderOfFaceAsPerm</K>(<A>complex</A>,<A>face</A>) 
#! returns a cyclic permutation of all vertices in the given <A>face</A> such 
#! that the images of every pair of vertices that are connected by an edge of 
#! the given <A>face</A> will also be connected by an edge of <A>face</A>.
#! <Par/>
#! This condition does not define the cyclic permutation uniquely, so we 
#! stipulate that the image of the smallest vertex is minimal for the retuned
#! permutation.
#! <Par/>
#! The attribute <K>CyclicVertexOrderOfFacesAsPerm</K>(<A>complex</A>) 
#! collects all of those permutations in a list that is indexed by the face 
#! labels, i.e. 
#! <K>CyclicVertexOrderOfFacesAsPerm</K>(<A>complex</A>)[<A>face</A>]
#! = <K>CyclicVertexOrderOfFaceAsPerm</K>(<A>complex</A>, <A>face</A>). All
#! other positions of this list are not bounded.
#! <Par/>
#! The NC-version does not check if the given <A>face</A> is a face of the
#! given <A>complex</A>.
#! The operations
#! <K>CyclicVertexOrderOfFace</K>(<A>complex</A>, <A>face</A>) and
#! <K>CyclicVertexOrderOfFaces</K>(<A>complex</A>) are wrappers for the
#! corresponding <K>*AsPerm</K>-methods.
#! <Par/>
#! As an example consider the polygonal complex that was introduced at the
#! start of section
#! <Ref Sect="Section_Access_OrderedFaceAccess"/>:
#! <Alt Only="TikZ">
#!   \input{Image_PentagonCyclicOrder.tex}
#! </Alt>
#! @BeginExample
CyclicVertexOrderOfFaceAsPerm(pentagon, 2);
#! ( 1, 6, 3, 2, 9 )
CyclicVertexOrderOfFace(pentagon, 2);
#! ( 1, 6, 3, 2, 9 )
CyclicVertexOrderOfFacesAsPerm(pentagon);
#! [ , ( 1, 6, 3, 2, 9 ) ]
CyclicVertexOrderOfFaces(pentagon);
#! [ , ( 1, 6, 3, 2, 9 ) ]
#! @EndExample
#! 
#! @Arguments complex
#! @Returns a list of permutations/a permutation
DeclareAttribute( "CyclicVertexOrderOfFacesAsPerm", IsPolygonalComplex );
#! @Arguments complex
DeclareOperation( "CyclicVertexOrderOfFace", [IsPolygonalComplex] );
#! @Arguments complex, face
DeclareOperation( "CyclicVertexOrderOfFaceAsPerm", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "CyclicVertexOrderOfFace", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "CyclicVertexOrderOfFaceAsPermNC", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "CyclicVertexOrderOfFaceNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup
#! @Description
#! The operation 
#! <K>CyclicVertexOrderOfFaceAsList</K>(<A>complex</A>,<A>face</A>) 
#! returns a list of all vertices in the given <A>face</A> such 
#! that every two vertices that are connected by an edge of 
#! the given <A>face</A> will be adjacent in the list (for this purpose,
#! the first and the last entry of the list are adjacent).
#! <Par/>
#! This condition does only define the list up to cyclic permutation, so we 
#! stipulate that the first element of the list is the smallest vertex and
#! the second element of the list is as small as possible.
#! <Par/>
#! The attribute <K>CyclicVertexOrderOfFacesAsList</K>(<A>complex</A>) 
#! collects all of those lists in a list that is indexed by the face 
#! labels, i.e. 
#! <K>CyclicVertexOrderOfFacesAsList</K>(<A>complex</A>)[<A>face</A>]
#! = <K>CyclicVertexOrderOfFaceAsList</K>(<A>complex</A>, <A>face</A>). All
#! other positions of this list are not bounded.
#! <Par/>
#! The NC-version does not check if the given <A>face</A> is a face of the
#! given <A>complex</A>.
#! <Par/>
#! As an example consider the polygonal complex that was introduced at the
#! start of section
#! <Ref Sect="Section_Access_OrderedFaceAccess"/>:
#! <Alt Only="TikZ">
#!   \input{Image_PentagonCyclicOrder.tex}
#! </Alt>
#! @BeginExample
CyclicVertexOrderOfFaceAsList(pentagon, 2);
#! [ 1, 6, 3, 2, 9 ]
CyclicVertexOrderOfFacesAsList(pentagon);
#! [ , [ 1, 6, 3, 2, 9  ] ]
#! @EndExample
#! 
#! @Arguments complex
#! @Returns a list of lists/a list
DeclareAttribute( "CyclicVertexOrderOfFacesAsList", IsPolygonalComplex );
#! @Arguments complex, face
DeclareOperation( "CyclicVertexOrderOfFaceAsList", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "CyclicVertexOrderOfFaceAsListNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup



#! @BeginGroup
#! @Description
#! The operation 
#! <K>CyclicEdgeOrderOfFaceAsPerm</K>(<A>complex</A>,<A>face</A>) 
#! returns a cyclic permutation of all edges in the given <A>face</A> such 
#! that the images of every pair of edges that share a vertex of 
#! the given <A>face</A> will also share a vertex of <A>face</A>.
#! <Par/>
#! This condition does not define the cyclic permutation uniquely, so we 
#! stipulate that the image of the smallest edge is minimal for the retuned
#! permutation.
#! <Par/>
#! The attribute <K>CyclicEdgeOrderOfFacesAsPerm</K>(<A>complex</A>) 
#! collects all of those permutations in a list that is indexed by the face 
#! labels, i.e. 
#! <K>CyclicEdgeOrderOfFacesAsPerm</K>(<A>complex</A>)[<A>face</A>]
#! = <K>CyclicEdgeOrderOfFaceAsPerm</K>(<A>complex</A>, <A>face</A>). All
#! other positions of this list are not bounded.
#! <Par/>
#! The NC-version does not check if the given <A>face</A> is a face of the
#! given <A>complex</A>.
#! The operations
#! <K>CyclicEdgeOrderOfFace</K>(<A>complex</A>, <A>face</A>) and
#! <K>CyclicEdgeOrderOfFaces</K>(<A>complex</A>) are wrappers for the
#! corresponding <K>*AsPerm</K>-methods.
#! <Par/>
#! As an example consider the polygonal complex that was introduced at the
#! start of section
#! <Ref Sect="Section_Access_OrderedFaceAccess"/>:
#! <Alt Only="TikZ">
#!   \input{Image_PentagonCyclicOrder.tex}
#! </Alt>
#! @BeginExample
CyclicEdgeOrderOfFaceAsPerm(pentagon, 2);
#! ( 2, 4, 8, 3, 6 )
CyclicEdgeOrderOfFace(pentagon, 2);
#! ( 2, 4, 8, 3, 6 )
CyclicEdgeOrderOfFacesAsPerm(pentagon);
#! [ , ( 2, 4, 8, 3, 6 ) ]
CyclicEdgeOrderOfFaces(pentagon);
#! [ , ( 2, 4, 8, 3, 6 ) ]
#! @EndExample
#! 
#! @Arguments complex
#! @Returns a list of permutations/a permutation
DeclareAttribute( "CyclicEdgeOrderOfFacesAsPerm", IsPolygonalComplex );
#! @Arguments complex
DeclareOperation( "CyclicEdgeOrderOfFace", [IsPolygonalComplex] );
#! @Arguments complex, face
DeclareOperation( "CyclicEdgeOrderOfFaceAsPerm", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "CyclicEdgeOrderOfFace", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "CyclicEdgeOrderOfFaceAsPermNC", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "CyclicEdgeOrderOfFaceNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup
#! @Description
#! The operation 
#! <K>CyclicEdgeOrderOfFaceAsList</K>(<A>complex</A>,<A>face</A>) 
#! returns a list of all edges in the given <A>face</A> such 
#! that every two edges that share a vertex of 
#! the given <A>face</A> will be adjacent in the list (for this purpose,
#! the first and the last entry of the list are adjacent).
#! <Par/>
#! This condition does only define the list up to cyclic permutation, so we 
#! stipulate that the first element of the list is the smallest edge and
#! the second element of the list is as small as possible.
#! <Par/>
#! The attribute <K>CyclicEdgeOrderOfFacesAsList</K>(<A>complex</A>) 
#! collects all of those lists in a list that is indexed by the face 
#! labels, i.e. 
#! <K>CyclicEdgeOrderOfFacesAsList</K>(<A>complex</A>)[<A>face</A>]
#! = <K>CyclicEdgeOrderOfFaceAsList</K>(<A>complex</A>, <A>face</A>). All
#! other positions of this list are not bounded.
#! <Par/>
#! The NC-version does not check if the given <A>face</A> is a face of the
#! given <A>complex</A>.
#! <Par/>
#! As an example consider the polygonal complex that was introduced at the
#! start of section
#! <Ref Sect="Section_Access_OrderedFaceAccess"/>:
#! <Alt Only="TikZ">
#!   \input{Image_PentagonCyclicOrder.tex}
#! </Alt>
#! @BeginExample
CyclicEdgeOrderOfFaceAsList(pentagon, 2);
#! [ 2, 4, 8, 3, 6 ]
CyclicEdgeOrderOfFacesAsList(pentagon);
#! [ , [ 2, 4, 8, 3, 6  ] ]
#! @EndExample
#! 
#! @Arguments complex
#! @Returns a list of lists/a list
DeclareAttribute( "CyclicEdgeOrderOfFacesAsList", IsPolygonalComplex );
#! @Arguments complex, face
DeclareOperation( "CyclicEdgeOrderOfFaceAsList", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "CyclicEdgeOrderOfFaceAsListNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @Section Circular path of edges and faces around vertex
#! @SectionLabel Access_OrderedVertexAccess
#! 
#!         For polygonal surfaces (that were introduced in section
#!         <Ref Sect="PolygonalStructures_surface"/>) there is a natural 
#!         ordering of the edges and 
#!         faces that are incident to a vertex. It is achieved by "travelling 
#!         around the vertex" while staying on the surface. We formalize this
#! by <E>edge-face-paths</E>.
#!         <Alt Only="TikZ">
#!           \input{Image_EdgeFacePath.tex}
#!         </Alt>
#! <Par/>
#! <#Include Label="EdgeFacePath_Definition">
#! <Par/>
#! <Par/>
#! In the image above we have the closed edge-face-path 
#! <M>(e_1, f_1, e_2, f_2, e_3, f_3, e_4, f_4)</M> and 
#! the non-closed face-edge-path 
#! <M>(e_1, f_1, e_2, f_2, e_3, f_3, e_4)</M>.
#! 
    

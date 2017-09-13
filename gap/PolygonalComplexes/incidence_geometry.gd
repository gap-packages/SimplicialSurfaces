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
#! Return the set of vertices.
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
#! @EndExample
#! <Par/>
#! We have separated the operation <K>Vertices</K> from the corresponding
#! attribute because there is a naming clash with the package grape.
#! @Arguments complex
#! @Returns A set of positive integers
DeclareOperation( "Vertices", [IsPolygonalComplex] );
#! @Arguments complex
DeclareAttribute( "VerticesAttributeOfPolygonalComplex", IsPolygonalComplex );
#! @EndGroup

#! @Description
#! Return the set of edges.
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
#! @EndExample
#
#! @Arguments complex
#! @Returns A set of positive integers
DeclareAttribute( "Edges", IsPolygonalComplex );

#! @Description
#! Return the set of faces.
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
#! @EndExample
#
#! @Arguments complex
#! @Returns A set of positive integers
DeclareAttribute( "Faces", IsPolygonalComplex );

#! @BeginGroup
#TODO why can't you give a custom header to the group?
#! @Description
#! Return the number of vertices, edges or faces.
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
NrOfVertices(complex);
#! 4
NrOfEdges(complex);
#! 4
NrOfFaces(complex);
#! 1
#! @EndExample
#
#! @Returns a non-negative integer
#! @Arguments complex
DeclareAttribute( "NrOfVertices", IsPolygonalComplex );
#! @Arguments complex
DeclareAttribute( "NrOfEdges", IsPolygonalComplex );
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
    [,[3,6],[2,9],[1,6],,[2.3],,[1,9] ], [[2,3,4,6,8]] );;
VerticesOfFace(pentagon,1);
#! [ 1, 2, 3, 6, 9 ]
EdgesOfFace(pentagon,1);
#! [ 2, 3, 4, 6, 8 ]
#! @EndExample
#! If we want to know in which order the vertices (or edges) are
#! arranged around the boundary of the given face, the previous methods 
#! are quite clumsy. For that reason the methods 
#! <K>CyclicVertexOrderOfFace</K> and <K>CyclicEdgeOrderOfFace</K>
#! were written.
#! <Par/>
#! The cyclic order of the vertices is naturally represented by a 
#! permutation like (1,6,3,2,9) or (1,9,2,3,6).
#TODO put a link to permutations in the GAP-Manual
#! Since the operation should return a unique value, we have to pick
#! one of these as a convention. We choose (1,6,3,2,9), since it has
#! the smallest image under 1 (the smallest of the vertices).
#! <Par/>
#! Likewise we have the permutations (2,6,3,8,4) and (2,4,8,3,6) for
#! the cyclic order of the edges. With the same convention we choose
#! (2,4,8,3,6) as the designated return value.
#! <Par/>
#! We remark that the induced orientations of the face by those two
#! permutations may be different (like in this example).
#! 
#TODO

#! @Section Circular path of edges and faces around vertex
#! @SectionLabel Access_OrderedVertexAccess
#TODO
#! <Enum>
#!   <Item><E>Ordering around a vertex</E>
#!         <Par/>
#!         For polygonal surfaces (that were introduced in section
#!         <Ref Sect="PolygonalStructures_surface"/>) there is a natural 
#!         ordering of the edges and 
#!         faces that are incident to a vertex. It is achieved by "travelling 
#!         around the vertex" while staying on the surface.
#!         <Alt Only="TikZ">
#!           \input{Image_EdgeFacePath.tex}
#!         </Alt>
#!         This is captured in the concept of an <E>edge-face-path</E>, which
#!         is defined in subsection
#!         <Ref Subsect="Definition_EdgeFacePath_Vertex"/>.
#!    </Item>
#! </Enum>

    

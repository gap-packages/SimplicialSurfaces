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

#! @Chapter Access to twisted polygonal complexes
#! @ChapterLabel AccessTwistedPolygonalComplex
#! 

####
# No matter what, a chapter should start with a short description of its
# contents, together with necessary references to previous material (if
# someone does not read the chapters in order).
####

#! In section <Ref Sect="PolygonalStructures_twisted"/> we introduced 
#! the concept of <K>TwistedPolygonalComplex</K> that went further than
#! a pure incidence geometry. This chapter describes this additional
#! structure and how to access it.
#!
#! Section <Ref Sect="Section_AccessTwisted_Incidence"/> covers the extension of
#! the incidence structure for polygonal complexes (compare
#! Section <Ref Sect="Section_Access_BasicAccess"/>) to chambers.
#! Section <Ref Sect="Section_AccessTwisted_Adjacency"/> covers the adjacency
#! structure of those chambers. Finally, Section
#! <Ref Sect="Section_AccessTwisted_Constructors"/> presents some methods
#! to construct twisted polygonal complexes. Finally, Section
#! <Ref Sect="Section_AccessTwisted_Polygonal"/> explores the relation
#! between polygonal complexes and twisted polygonal complexes.
#! 

#! @Section Chamber incidence
#! @SectionLabel AccessTwisted_Incidence
#!
#! Polygonal complexes only focus on the incidence between
#! vertices, edges, and faces. In contrast, twisted polygonal
#! complexes also care about <E>chambers</E>, which can be interpreted
#! as the "small triangles" in a barycentric subdivision.
#!
#! Each of these chambers is incident to exactly one vertex, one edge,
#! and one face. Thus, we can use *Of*-methods, similar as in Section
#! <Ref Sect="Section_Access_BasicAccess"/>.
#! As an example, we use the following twisted polygonal complex:
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!      \def\chambers{1}
#!      \input{Image_StarOfStarChamberExample.tex}
#!  \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> complex := TwistedPolygonalComplexByChamberRelations(
#! >        [3,5,5,5,5,3,5,5,5,7,7,7,7,5],
#! >        [2,2,4,4,2,2,4,4,6,6,8,8,6,6],
#! >        [1,1,1,1,1,1,9,9,9,9,9,9,9,9],
#! >        (1,2)(3,4)(5,6)(7,8)(9,10)(11,12)(13,14),
#! >        (1,6)(2,3)(4,5)(7,14),(8,9)(10,11)(12,13),
#! >        [[1,6],[2,5],[3,8],[4,7],[9,14],[10,13],[11],[12]]);
#! twisted polygonal complex (3 vertices, 4 edges, 2 faces, and 14 chambers)
#! @EndExampleSession

#! The chambers are represented by a set of positive integers.
#! @BeginGroup
#! @Description
#! Return the set/number of chambers
#! 
#! As an example consider the twisted polygonal complex from the beginning of Section
#! <Ref Sect="Section_AccessTwisted_Incidence"/>:
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle=nolabels, edgeStyle=nolabels, faceStyle=nolabels]
#!      \def\chambers{1}
#!      \input{Image_StarOfStarChamberExample.tex}
#!  \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> Chambers(complex);
#! [ 1 .. 14 ]
#! gap> NumberOfChambers(complex);
#! 14
#! @EndExampleSession
#
#! @Arguments complex
#! @Returns A set of positive integers/a non-negative integer
DeclareAttribute( "Chambers", IsTwistedPolygonalComplex );
#! @Arguments complex
DeclareAttribute( "NumberOfChambers", IsTwistedPolygonalComplex );
#! @EndGroup


#! @BeginGroup VerticesOfChambers
#! @Description
#! The method <K>VertexOfChamber</K>(<A>complex</A>, <A>chamber</A>) returns the
#! vertex that is incident to <A>chamber</A>. The NC-version does
#! not check whether the given <A>chamber</A> is a chamber of <A>complex</A>.
#! 
#! The attribute <K>VerticesOfChambers</K>(<A>complex</A>) collects all of those
#! vertices in a list that is indexed by the chamber labels, i.e.
#! <K>VerticesOfChambers</K>(<A>complex</A>)[<A>chamber</A>] = 
#! <K>VertexOfChamber</K>(<A>complex</A>, <A>chamber</A>).
#! All other positions of this list are not bound.
#! 
#! As an example consider the twisted polygonal complex from the beginning of Section
#! <Ref Sect="Section_AccessTwisted_Incidence"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle=nolabels]
#!       \def\chambers{1}
#!       \input{Image_StarOfStarChamberExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> VertexOfChamber(complex, 2);
#! 5
#! gap> VertexOfChamber(complex, 12);
#! 7
#! gap> VerticesOfChambers(complex);
#! [ 3, 5, 5, 5, 5, 3, 5, 5, 5, 7, 7, 7, 7, 5 ]
#! @EndExampleSession
#! 
#! @Returns a list of positive integers / a positive integers
#! @Arguments complex
DeclareAttribute( "VerticesOfChambers", IsTwistedPolygonalComplex );
#! @Arguments complex, chamber
DeclareOperation( "VertexOfChamber", [IsTwistedPolygonalComplex, IsPosInt]);
#! @Arguments complex, chamber
DeclareOperation( "VertexOfChamberNC", [IsTwistedPolygonalComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup ChambersOfVertices
#! @Description
#! The method <K>ChambersOfVertex</K>(<A>complex</A>, <A>vertex</A>) returns the
#! set of chambers that are incident to <A>vertex</A>. The NC-version does
#! not check whether the given <A>vertex</A> is a vertex of <A>complex</A>.
#! 
#! The attribute <K>ChambersOfVertices</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the vertex labels, i.e.
#! <K>ChambersOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>ChambersOfVertex</K>(<A>complex</A>, <A>vertex</A>).
#! All other positions of this list are not bound.
#! 
#! As an example consider the twisted polygonal complex from the beginning of Section
#! <Ref Sect="Section_AccessTwisted_Incidence"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle=nolabels]
#!       \def\chambers{1}
#!       \input{Image_StarOfStarChamberExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> ChambersOfVertex(complex, 3);
#! [ 1, 6 ]
#! gap> ChambersOfVertex(complex, 7);
#! [ 10, 11, 12, 13 ]
#! gap> ChambersOfVertices(complex);
#! [ ,, [ 1, 6 ],, [ 2, 3, 4, 5, 7, 8, 9, 14],, [ 10, 11, 12, 13 ] ]
#! @EndExampleSession
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "ChambersOfVertices", IsTwistedPolygonalComplex );
#! @Arguments complex, vertex
DeclareOperation( "ChambersOfVertex", [IsTwistedPolygonalComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "ChambersOfVertexNC", [IsTwistedPolygonalComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup EdgesOfChambers
#! @Description
#! The method <K>EdgeOfChamber</K>(<A>complex</A>, <A>chamber</A>) returns the
#! edge that is incident to <A>chamber</A>. The NC-version does
#! not check whether the given <A>chamber</A> is a chamber of <A>complex</A>.
#! 
#! The attribute <K>EdgesOfChambers</K>(<A>complex</A>) collects all of those
#! edges in a list that is indexed by the chamber labels, i.e.
#! <K>EdgesOfChambers</K>(<A>complex</A>)[<A>chamber</A>] = 
#! <K>EdgeOfChamber</K>(<A>complex</A>, <A>chamber</A>).
#! All other positions of this list are not bound.
#! 
#! As an example consider the twisted polygonal complex from the beginning of Section
#! <Ref Sect="Section_AccessTwisted_Incidence"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle=nolabels, edgeStyle, faceStyle=nolabels]
#!       \def\chambers{1}
#!       \input{Image_StarOfStarChamberExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> EdgeOfChamber(complex, 2);
#! 2
#! gap> EdgeOfChamber(complex, 12);
#! 8
#! gap> EdgesOfChambers(complex);
#! [ 2, 2, 4, 4, 2, 2, 4, 4, 6, 6, 8, 8, 6, 6 ]
#! @EndExampleSession
#! 
#! @Returns a list of positive integers / a positive integers
#! @Arguments complex
DeclareAttribute( "EdgesOfChambers", IsTwistedPolygonalComplex );
#! @Arguments complex, chamber
DeclareOperation( "EdgeOfChamber", [IsTwistedPolygonalComplex, IsPosInt]);
#! @Arguments complex, chamber
DeclareOperation( "EdgeOfChamberNC", [IsTwistedPolygonalComplex, IsPosInt]);
#! @EndGroup

#! @BeginGroup ChambersOfEdges
#! @Description
#! The method <K>ChambersOfEdge</K>(<A>complex</A>, <A>edge</A>) returns the
#! set of chambers that are incident to <A>edge</A>. The NC-version does
#! not check whether the given <A>edge</A> is an edge of <A>complex</A>.
#! 
#! The attribute <K>ChambersOfEdges</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the edge labels, i.e.
#! <K>ChambersOfEdges</K>(<A>complex</A>)[<A>edge</A>] = 
#! <K>ChambersOfEdge</K>(<A>complex</A>, <A>edge</A>).
#! All other positions of this list are not bound.
#! 
#! As an example consider the twisted polygonal complex from the beginning of Section
#! <Ref Sect="Section_AccessTwisted_Incidence"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle=nolabels, edgeStyle, faceStyle=nolabels]
#!       \def\chambers{1}
#!       \input{Image_StarOfStarChamberExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> ChambersOfEdge(complex, 4);
#! [ 3, 4, 7, 8 ]
#! gap> ChambersOfEdge(complex, 6);
#! [ 9, 10, 13, 14 ]
#! gap> ChambersOfEdges(complex);
#! [ , [ 1, 2, 5, 6 ],, [ 3, 4, 7, 8 ],, [ 9, 10, 13, 14],, [ 11, 12 ] ]
#! @EndExampleSession
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "ChambersOfEdges", IsTwistedPolygonalComplex );
#! @Arguments complex, edge
DeclareOperation( "ChambersOfEdge", [IsTwistedPolygonalComplex, IsPosInt]);
#! @Arguments complex, edge
DeclareOperation( "ChambersOfEdgeNC", [IsTwistedPolygonalComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup FacesOfChambers
#! @Description
#! The method <K>FaceOfChamber</K>(<A>complex</A>, <A>chamber</A>) returns the
#! face that is incident to <A>chamber</A>. The NC-version does
#! not check whether the given <A>chamber</A> is a chamber of <A>complex</A>.
#! 
#! The attribute <K>FacesOfChambers</K>(<A>complex</A>) collects all of those
#! faces in a list that is indexed by the chamber labels, i.e.
#! <K>FacesOfChambers</K>(<A>complex</A>)[<A>chamber</A>] = 
#! <K>FaceOfChamber</K>(<A>complex</A>, <A>chamber</A>).
#! All other positions of this list are not bound.
#! 
#! As an example consider the twisted polygonal complex from the beginning of Section
#! <Ref Sect="Section_AccessTwisted_Incidence"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle=nolabels, edgeStyle=nolabels, faceStyle]
#!       \def\chambers{1}
#!       \input{Image_StarOfStarChamberExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> FaceOfChamber(complex, 2);
#! 1
#! gap> FaceOfChamber(complex, 12);
#! 9
#! gap> VerticesOfChambers(complex);
#! [ 1, 1, 1, 1, 1, 1, 9, 9, 9, 9, 9, 9, 9, 9 ]
#! @EndExampleSession
#! 
#! @Returns a list of positive integers / a positive integers
#! @Arguments complex
DeclareAttribute( "FacesOfChambers", IsTwistedPolygonalComplex );
#! @Arguments complex, chamber
DeclareOperation( "FaceOfChamber", [IsTwistedPolygonalComplex, IsPosInt]);
#! @Arguments complex, chamber
DeclareOperation( "FaceOfChamberNC", [IsTwistedPolygonalComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup ChambersOfFaces
#! @Description
#! The method <K>ChambersOfFace</K>(<A>complex</A>, <A>face</A>) returns the
#! set of chambers that are incident to <A>face</A>. The NC-version does
#! not check whether the given <A>face</A> is a face of <A>complex</A>.
#! 
#! The attribute <K>ChambersOfFaces</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the face labels, i.e.
#! <K>ChambersOfFaces</K>(<A>complex</A>)[<A>face</A>] = 
#! <K>ChambersOfFace</K>(<A>complex</A>, <A>face</A>).
#! All other positions of this list are not bound.
#! 
#! As an example consider the twisted polygonal complex from the beginning of Section
#! <Ref Sect="Section_AccessTwisted_Incidence"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle=nolabels, edgeStyle=nolabels, faceStyle]
#!       \def\chambers{1}
#!       \input{Image_StarOfStarChamberExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> ChambersOfFace(complex, 9);
#! [ 7, 8, 9, 10, 11, 12, 13, 14 ]
#! gap> ChambersOfFaces(complex);
#! [ [ 1, 2, 3, 4, 5, 6 ],,,,,,, [ 7, 8, 9, 10, 11, 12, 13, 14 ] ]
#! @EndExampleSession
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "ChambersOfFaces", IsTwistedPolygonalComplex );
#! @Arguments complex, face
DeclareOperation( "ChambersOfFace", [IsTwistedPolygonalComplex, IsPosInt]);
#! @Arguments complex, face
DeclareOperation( "ChambersOfFaceNC", [IsTwistedPolygonalComplex, IsPosInt]);
#! @EndGroup



#! @Section Chamber adjacency
#! @SectionLabel AccessTwisted_Adjacency
#!
#! By focussing on chambers, twisted polygonal complexes are
#! much more expressive than polygonal complexes. Thus,
#! chamber manipulation is of paramount importance when
#! dealing with twisted polygonal complexes. The most important
#! aspects of chambers is their adjacency, which we illustrate
#! with the following twisted polygonal complex:
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle=nolabels,edgeStyle=nolabels, faceStyle=nolabels]
#!          \def\chambers{1}
#!          \input{Image_TwistedMedal.tex}
#!      \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> complex := TwistedPolygonalComplexByChamberAdjacencies(
#! >    (1,2)(3,4)(5,6)(7,8)(9,10)(11,12)(13,14)(15,16)(17,18)(19,20)(21,22)(23,24)(25,26),
#! >    (1,6)(2,3)(4,5)(7,14)(8,9)(10,11)(12,13)(15,20)(16,17)(18,19)(21,26)(22,23)(24,25),
#! >    [[1,6],[2,5],[3,8],[4,7],[9,14,22],[10,13,21],[11,16],[12,15],[17,20],[18,19],[23],[24],[25],[26]]);
#! twisted polygonal complex (5 vertices, 7 edges, 4 faces, and 26 chambers)
#! @EndExampleSession

#! There are three kinds of chamber adjacencies: 0-adjacent, 1-adjacent, and
#! 2-adjacent. We can calculate each of those:
#! @ExampleSession
#! gap> ZeroAdjacentChamber(complex, 9);
#! 10
#! gap> OneAdjacentChamber(complex, 9);
#! 8
#! gap> TwoAdjacentChambers(complex,9);
#! [ 14, 22 ]
#! @EndExampleSession
#! For each chamber, there is exactly one 0-adjacent chamber and
#! exactly one 1-adjacent chamber. However, there may be an
#! arbitrary number of 2-adjacent chambers.
#! @ExampleSession
#! gap> TwoAdjacentChambers(complex, 12);
#! [ 15 ]
#! gap> TwoAdjacentChambers(complex, 23);
#! []
#! @EndExampleSession
#! We can also work with all adjacencies simultaneously. Currently, 
#! three different options are supported:
#! * An equivalence relation on the set of chambers
#! @BeginExampleSession
#! gap> e0 := ZeroAdjacencyRelation(complex);
#! <equivalence relation on <object> >
#! gap> EquivalenceClasses(e0);
#! [ {1}, {3}, {5}, {7}, {9}, {11}, {13}, {15}, {17}, {19}, {21}, {23}, {25} ]
#! gap> e1 := OneAdjacencyRelation(complex);
#! <equivalence relation on <object> >
#! gap> EquivalenceClasses(e1);
#! [ {1}, {2}, {4}, {7}, {8}, {10}, {12}, {15}, {16}, {18}, {21}, {22}, {24} ]
#! gap> e2 := TwoAdjacencyRelation(complex);
#! <equivalence relation on <object> >
#! gap> EquivalenceClasses(e2);
#! [ {1}, {2}, {3}, {4}, {9}, {10}, {11}, {12}, {17}, {18}, {23}, {24}, {25}, {26} ]
#! @EndExampleSession
#! * A set of equivalence classes
#! @ExampleSession
#! gap> ZeroAdjacencyClasses(complex);
#! [ [ 1, 2 ], [ 3, 4 ], [ 5, 6 ], [ 7, 8 ], [ 9, 10 ], [ 11, 12 ], [ 13, 14 ], 
#!   [ 15, 16 ], [ 17, 18 ], [ 19, 20 ], [ 21, 22 ], [ 23, 24 ], [ 25, 26 ] ]
#! gap> OneAdjacencyClasses(complex);
#! [ [ 1, 6 ], [ 2, 3 ], [ 4, 5 ], [ 7, 14 ], [ 8, 9 ], [ 10, 11 ], [ 12, 13 ],
#!   [ 15, 20 ], [ 16, 17 ], [ 18, 19 ], [ 21, 26 ], [ 22, 23 ], [ 24, 25 ]]
#! gap> TwoAdjacencyClasses(complex);
#! [ [ 1, 6 ], [ 2, 5 ], [ 3, 8 ], [ 4, 7 ], [ 9, 14, 22 ], [ 10,13 ,21 ],
#!   [ 11, 16 ], [ 12, 15 ], [ 17, 20 ], [ 18, 19 ], [ 23 ], [ 24 ], [ 25 ], [ 26 ] ]
#! @EndExampleSession
#! * An involution (element of the symmetric group on the chambers). This is
#!   always possible for 0-adjacency and 1-adjacency. For 2-adjacency, it
#!   works if and only if we have a twisted polygonal surface.
#! @ExampleSession
#! gap> ZeroAdjacencyInvolution(complex);
#! (1,2)(3,4)(5,6)(7,8)(9,10)(11,12)(13,14)(15,16)(17,18)(19,20)(21,22)(23,24)(25,26)
#! gap> OneAdjacencyInvolution(complex);
#! (1,6)(2,3)(4,5)(7,14)(8,9)(10,11)(12,13)(15,20)(16,17)(18,19)(21,26)(22,23)(24,25)
#! @EndExampleSession
#! 


#! @BeginGroup StarAdjacentChamber
#! @Description
#! Given a chamber of a twisted polygonal complex <A>complex</A>, these methods return
#! the adjacent chambers:
#! * <K>ZeroAdjacentChamber</K>(<A>complex</A>, <A>chamber</A>) returns the
#!   unique chamber that is 0-adjacent to <A>chamber</A>.
#! * <K>OneAdjacentChamber</K>(<A>complex</A>, <A>chamber</A>) returns the
#!   unique chamber that is 1-adjacent to <A>chamber</A>.
#! * <K>TwoAdjacentChambers</K>(<A>complex</A>, <A>chamber</A>) returns the
#!   set of chambers that are 2-adjacent to <A>chamber</A>. If this set contains
#!   exactly one element, the method <K>TwoAdjacentChamber</K>
#!   is also applicable (otherwise, it returns <K>fail</K>).
#! The NC-version does not check whether <A>chamber</A> is a chamber of
#! <A>complex</A>. In the case of <K>TwoAdjacentChamberNC</K>, it also
#! does not check the number of 2-adjacent chambers.
#! 
#! As an example, consider the twisted polygonal complex from the beginning of Section
#! <Ref Sect="Section_AccessTwisted_Adjacency"/>:
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle=nolabels,edgeStyle=nolabels, faceStyle=nolabels]
#!          \def\chambers{1}
#!          \input{Image_TwistedMedal.tex}
#!      \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> ZeroAdjacentChamber(complex, 4);
#! 3
#! gap> OneAdjacentChamber(complex, 4);
#! 5
#! gap>
#! gap> TwoAdjacentChamber(complex, 4);
#! 7
#! gap> TwoAdjacentChambers(complex, 4);
#! [ 7 ]
#! gap> TwoAdjacentChamber(complex, 14);
#! fail
#! gap> TwoAdjacentChambers(complex, 14);
#! [ 9, 22 ]
#! gap> TwoAdjacentChamber(complex, 23);
#! fail
#! gap> TwoAdjacentChambers(complex, 23);
#! []
#! @EndExampleSession
#! 
#! @Returns a positive integer, a list of positive integers, or <K>fail</K>
#! @Arguments complex, chamber
DeclareOperation( "ZeroAdjacentChamber", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, chamber
DeclareOperation( "ZeroAdjacentChamberNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, chamber
DeclareOperation( "OneAdjacentChamber", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, chamber
DeclareOperation( "OneAdjacentChamberNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, chamber
DeclareOperation( "TwoAdjacentChamber", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, chamber
DeclareOperation( "TwoAdjacentChamberNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, chamber
DeclareOperation( "TwoAdjacentChambers", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, chamber
DeclareOperation( "TwoAdjacentChambersNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup IsStarAdjacentChambers
#! @Description
#! Given two chambers of a twisted polygonal complex <A>complex</A>, these methods
#! check whether they are 0-adjacent, 1-adjacent, or 2-adjacent.
#! 
#! The NC-version does not check whether <A>chamberA</A> and
#! <A>chamberB</A> are chambers of
#! <A>complex</A>. 
#! 
#! As an example, consider the twisted polygonal complex from the beginning of Section
#! <Ref Sect="Section_AccessTwisted_Adjacency"/>:
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle=nolabels,edgeStyle=nolabels, faceStyle=nolabels]
#!          \def\chambers{1}
#!          \input{Image_TwistedMedal.tex}
#!      \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> IsZeroAdjacentChambers(complex, 4,3);
#! true
#! gap> IsZeroAdjacentChambers(complex, 9, 22);
#! false
#! gap> IsOneAdjacentChambers(complex, 8, 9);
#! true
#! gap> IsOneAdjacentChambers(complex, 11, 20);
#! false
#! gap> IsTwoAdjacentChambers(complex, 12, 15);
#! true
#! gap> IsTwoAdjacentChambers(complex, 13, 21);
#! true
#! gap> IsTwoAdjacentChambers(complex, 1, 5);
#! false
#! @EndExampleSession
#! 
#! @Returns <K>true</K> or <K>false</K>
#! @Arguments complex, chamberA, chamberB
DeclareOperation( "IsZeroAdjacentChambers", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt] );
#! @Arguments complex, chamberA, chamberB
DeclareOperation( "IsZeroAdjacentChambersNC", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt] );
#! @Arguments complex, chamberA, chamberB
DeclareOperation( "IsOneAdjacentChambers", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt] );
#! @Arguments complex, chamberA, chamberB
DeclareOperation( "IsOneAdjacentChambersNC", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt] );
#! @Arguments complex, chamberA, chamberB
DeclareOperation( "IsTwoAdjacentChambers", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt] );
#! @Arguments complex, chamberA, chamberB
DeclareOperation( "IsTwoAdjacentChambersNC", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt] );
#! @EndGroup




#! @BeginGroup StarAdjacencyInvolution
#! @Description
#! Given a twisted polygonal complex <A>complex</A>, these methods return
#! the involutions that encode adjacency of chambers. The method
#! <K>ZeroAdjacencyInvolution</K> returns an involution whose action on
#! a chamber produces the unique chamber that is 0-adjacent to the first
#! one. The method <K>OneAdjacencyInvolution</K> does the same for
#! 1-adjacency.
#!
#! For 2-adjacency, each chamber may have an arbitrary number of 
#! 2-adjacent chambers. If each chamber has at most one 2-adjacent
#! chamber (i.e. if <A>complex</A> is a twisted polygonal surface),
#! <K>TwoAdjacencyInvolution</K> returns the corresponding involution.
#! Otherwise, it returns <K>fail</K>.
#! 
#! As an example, consider the twisted polygonal complex from the beginning of Section
#! <Ref Sect="Section_AccessTwisted_Adjacency"/>:
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle=nolabels,edgeStyle=nolabels, faceStyle=nolabels]
#!          \def\chambers{1}
#!          \input{Image_TwistedMedal.tex}
#!      \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> ZeroAdjacencyInvolution(complex);
#! (1,2)(3,4)(5,6)(7,8)(9,10)(11,12)(13,14)(15,16)(17,18)(19,20)(21,22)(23,24)(25,26)
#! gap> OneAdjacencyInvolution(complex);
#! (1,6)(2,3)(4,5)(7,14)(8,9)(10,11)(12,13)(15,20)(16,17)(18,19)(21,26)(22,23)(24,25)
#! gap> TwoAdjacencyInvolution(complex);
#! fail
#! @EndExampleSession
#! 
#! @Returns a positive integer, a list of positive integers, or <K>fail</K>
#! @Arguments complex
DeclareAttribute( "ZeroAdjacencyInvolution", IsTwistedPolygonalComplex);
#! @Arguments complex
DeclareAttribute( "OneAdjacencyInvolution", IsTwistedPolygonalComplex);
#! @Arguments complex
DeclareAttribute( "TwoAdjacencyInvolution", IsTwistedPolygonalComplex);
#! @EndGroup


#! @BeginGroup StarAdjacencyClasses
#! @Description
#! Given a twisted polygonal complex <A>complex</A>, these methods return
#! a set of sets encoding the adjacency of chambers.
#!
#! The method <K>ZeroAdjacencyClasses</K> returns a set of pairs, such
#! that the elements of each pair are 0-adjacent. The method
#! <K>OneAdjacencyClasses</K> does the same for 1-adjacency.
#!
#! The method <K>TwoAdjacencyClasses</K> is similar, but it returns a set
#! of sets. Every pair of chambers in one of the contained sets
#! is 2-adjacent.
#! 
#! As an example, consider the twisted polygonal complex from the beginning of Section
#! <Ref Sect="Section_AccessTwisted_Adjacency"/>:
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle=nolabels,edgeStyle=nolabels, faceStyle=nolabels]
#!          \def\chambers{1}
#!          \input{Image_TwistedMedal.tex}
#!      \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> ZeroAdjacencyClasses(complex);
#! [ [ 1, 2 ], [ 3, 4 ], [ 5, 6 ], [ 7, 8 ], [ 9, 10 ], [ 11, 12 ], [ 13, 14 ], 
#!   [ 15, 16 ], [ 17, 18 ], [ 19, 20 ], [ 21, 22 ], [ 23, 24 ], [ 25, 26 ] ]
#! gap> OneAdjacencyClasses(complex);
#! [ [ 1, 6 ], [ 2, 3 ], [ 4, 5 ], [ 7, 14 ], [ 8, 9 ], [ 10, 11 ], [ 12, 13 ],
#!   [ 15, 20 ], [ 16, 17 ], [ 18, 19 ], [ 21, 26 ], [ 22, 23 ], [ 24, 25 ]]
#! gap> TwoAdjacencyClasses(complex);
#! [ [ 1, 6 ], [ 2, 5 ], [ 3, 8 ], [ 4, 7 ], [ 9 , 14, 22 ], [ 10 ,13 ,21 ],
#!   [ 11, 16 ], [ 12 , 15 ], [ 17, 20 ], [ 18, 19 ], [ 23 ], [ 24 ], [ 25 ], [ 26 ] ]
#! @EndExampleSession
#! 
#! @Returns a set of sets of positive integers
#! @Arguments complex
DeclareAttribute( "ZeroAdjacencyClasses", IsTwistedPolygonalComplex);
#! @Arguments complex
DeclareAttribute( "OneAdjacencyClasses", IsTwistedPolygonalComplex);
#! @Arguments complex
DeclareAttribute( "TwoAdjacencyClasses", IsTwistedPolygonalComplex);
#! @EndGroup


#! @BeginGroup StarAdjacencyRelation
#! @Description
#! Given a twisted polygonal complex <A>complex</A>, these methods return
#! an equivalence relation encoding the adjacency of chambers.
#!
#! The method <K>ZeroAdjacencyRelation</K> returns an equivalence relation
#! on the set of chambers, such
#! that two chambers are equivalent if and only if they are 0-adjacent or
#! identical.
#!
#! The methods <K>OneAdjacencyRelation</K> and <K>TwoAdjacencyRelation</K>
#! do the same for 1-adjacency and 2-adjacency.
#! 
#! As an example, consider the twisted polygonal complex from the beginning of Section
#! <Ref Sect="Section_AccessTwisted_Adjacency"/>:
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle=nolabels,edgeStyle=nolabels, faceStyle=nolabels]
#!          \def\chambers{1}
#!          \input{Image_TwistedMedal.tex}
#!      \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> e0 := ZeroAdjacencyRelation(complex);
#! <equivalence relation on <object> >
#! gap> EquivalenceClasses(e0);
#! [ {1}, {3}, {5}, {7}, {9}, {11}, {13}, {15}, {17}, {19}, {21}, {23}, {25} ]
#! gap> e1 := OneAdjacencyRelation(complex);
#! <equivalence relation on <object> >
#! gap> EquivalenceClasses(e1);
#! [ {1}, {2}, {4}, {7}, {8}, {10}, {12}, {15}, {16}, {18}, {21}, {22}, {24} ]
#! gap> e2 := TwoAdjacencyRelation(complex);
#! <equivalence relation on <object> >
#! gap> EquivalenceClasses(e2);
#! [ {1}, {2}, {3}, {4}, {9}, {10}, {11}, {12}, {17}, {18}, {23}, {24}, {25}, {26} ]
#! @EndExampleSession
#! 
#! @Returns an equivalence relation
#! @Arguments complex
DeclareAttribute( "ZeroAdjacencyRelation", IsTwistedPolygonalComplex);
#! @Arguments complex
DeclareAttribute( "OneAdjacencyRelation", IsTwistedPolygonalComplex);
#! @Arguments complex
DeclareAttribute( "TwoAdjacencyRelation", IsTwistedPolygonalComplex);
#! @EndGroup


#! @Section Constructors
#! @SectionLabel AccessTwisted_Constructors
#!
#! Twisted polygonal complexes can be constructed in several different ways.
#! This section explores several different possible constructions.
#! * <K>TwistedPolygonalComplexByChamberRelations</K> 
#!   (<Ref Subsect="TwistedPolygonalComplexByChamberRelations"/>) constructs
#!   a twisted polygonal complex from the vertices, edges, and faces that
#!   are incident to each chamber, together with the three adjacency relations.
#! * <K>TwistedPolygonalComplexByChamberAdjacencies</K>
#!   (<Ref Subsect="TwistedPolygonalComplexByChamberAdjacencies"/>) constructs
#!   a twisted polygonal complex purely from its chamber adjacencies. The vertices,
#!   edges, and faces are deduced from them.
#! * <K>TwistedPolygonalSurfaceByChamberInvolutions</K>
#!   (<Ref Subsect="TwistedPolygonalSurfaceByChamberInvolutions"/>) constructs
#!   a twisted polygonal surface from its chamber adjacencies, that have to be
#!   given as involutions.
#!
#! To exemplify these methods, all of them construct the twisted polygonal
#! surface illustrated here:
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle=nolabels,edgeStyle=nolabels,faceStyle=nolabels]
#!          \def\chambers{1}
#!          \input{Image_TwistedThreeStrip.tex}
#!      \end{tikzpicture}
#! </Alt>
#!

#! @BeginGroup TwistedPolygonalComplexByChamberRelations
#! @Description
#! This method constructs a twisted polygonal complex 
#! (<Ref Sect="PolygonalStructures_twisted"/>). It is based on
#! the set of chambers, which is represented as a set of positive integers.
#! The method takes the following
#! parameters:
#! * <A>verticesOfChambers</A>: A list that has an entry for each chamber
#!  (a positive integer). The entry is the unique vertex (a positive integer)
#!  that is incident to that chamber.
#! * <A>edgesOfChambers</A>: A list that has an entry for each chamber
#!  (a positive integer). The entry is the unique edge (a positive integer)
#!  that is incident to that chamber.
#! * <A>facesOfChambers</A>: A list that has an entry for each chamber
#!  (a positive integer). The entry is the unique face (a positive integer)
#!  that is incident to that chamber.
#! * <A>zeroAdjacency</A>: This parameter encodes which chambers are
#!  0-adjacent. It can be given as an involution without fixed points
#!  or as a list of pairs of chambers.
#! * <A>oneAdjacency</A>: This parameter encodes which chambers are
#!  1-adjacent. It can be given as an involution without fixed points
#!  or as a list of pairs of chambers.
#! * <A>twoAdjacency</A>: This parameter encodes which chambers are
#!  1-adjacent. It can be given as an involution (only possible for
#!  twisted polygonal surfaces)
#!  or as a list of lists of chambers.
#!
#! All of these parameters rely on the set of chambers:
#! * For <A>verticesOfChambers</A>, <A>edgesOfChambers</A>, and
#!   <A>facesOfChambers</A>, the set of chambers is the set of
#!   bound positions.
#! * If <A>zeroAdjacency</A> or <A>oneAdjacency</A> are given as
#!   involutions, the set of chambers is the set of moved points.
#! * If <A>twoAdjacency</A> is given as involution, the set of
#!   chambers is a superset of the set of moved points.
#! * If <A>zeroAdjacency</A>, <A>oneAdjacency</A>, or
#!   <A>twoAdjacency</A> are given as list of lists, they define
#!   a partition of the set of chambers.
#! The NC-version does not check the consistency of this information.
#!
#! As an example, we construct the following twisted polygonal surface:
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!          \def\chambers{1}
#!          \input{Image_TwistedThreeStrip.tex}
#!      \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> TwistedPolygonalComplexByChamberRelations(
#! >    [3,7,7,5,5,3,5,7,7,5,5,5,5,7,7,3,3,5],
#! >    [4,4,6,6,2,2,6,6,10,10,8,8,10,10,12,12,2,2],
#! >    [1,1,1,1,1,1,9,9,9,9,9,9,11,11,11,11,11,11],
#! >    [[1,2],[3,4],[5,6],[7,8],[9,10],[11,12],[13,14],[15,16],[17,18]],
#! >    (1,6)(2,3)(4,5)(7,12)(8,9)(10,11)(13,18)(14,15)(16,17),
#! >    [[1],[2],[3,8],[4,7],[5,18],[6,17],[9,14],[10,13],[11],[12],[15],[16]]);
#! twisted polygonal surface (3 vertices, 6 edges, 3 faces, and 18 chambers)
#! @EndExampleSession
#!
#! @Returns a twisted polygonal complex
#! @Arguments verticesOfChambers, edgesOfChambers, facesOfChambers, 
#!    zeroAdjacency, oneAdjacency, twoAdjacency
DeclareOperation("TwistedPolygonalComplexByChamberRelations", [IsList, IsList, IsList, IsList, IsList, IsList]);
#! @Arguments verticesOfChambers, edgesOfChambers, facesOfChambers, 
#!    zeroAdjacency, oneAdjacency, twoAdjacency
DeclareOperation("TwistedPolygonalComplexByChamberRelationsNC", [IsList, IsList, IsList, IsList, IsList, IsList]);
#! @Arguments verticesOfChambers, edgesOfChambers, facesOfChambers, 
#!    zeroAdjacency, oneAdjacency, twoAdjacency
DeclareOperation("TwistedPolygonalSurfaceByChamberRelations", [IsList, IsList, IsList, IsList, IsList, IsList]);
#! @Arguments verticesOfChambers, edgesOfChambers, facesOfChambers, 
#!    zeroAdjacency, oneAdjacency, twoAdjacency
DeclareOperation("TwistedPolygonalSurfaceByChamberRelationsNC", [IsList, IsList, IsList, IsList, IsList, IsList]);
#! @EndGroup

#! @BeginGroup TwistedPolygonalComplexByChamberAdjacencies
#! @Description
#! This method constructs a twisted polygonal complex 
#! (<Ref Sect="PolygonalStructures_twisted"/>). It is based on
#! the set of chambers, which is represented as a set of positive integers.
#! The method takes the following
#! parameters:
#! * <A>zeroAdjacency</A>: This parameter encodes which chambers are
#!  0-adjacent. It can be given as an involution without fixed points
#!  or as a list of pairs of chambers.
#! * <A>oneAdjacency</A>: This parameter encodes which chambers are
#!  1-adjacent. It can be given as an involution without fixed points
#!  or as a list of pairs of chambers.
#! * <A>twoAdjacency</A>: This parameter encodes which chambers are
#!  1-adjacent. It can be given as an involution (only possible for
#!  twisted polygonal surfaces)
#!  or as a list of lists of chambers.
#!
#! Vertices, edges, and faces are constructed automatically.
#!
#! All of these parameters rely on the set of chambers:
#! * If <A>zeroAdjacency</A> or <A>oneAdjacency</A> are given as
#!   involutions, the set of chambers is the set of moved points.
#! * If <A>twoAdjacency</A> is given as involution, the set of
#!   chambers is a superset of the set of moved points.
#! * If <A>zeroAdjacency</A>, <A>oneAdjacency</A>, or
#!   <A>twoAdjacency</A> are given as list of lists, they define
#!   a partition of the set of chambers.
#! The NC-version does not check the consistency of this information.
#!
#! As an example, we construct the following twisted polygonal 
#! surface (the labels of vertices, edges, and faces are the default ones):
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!          \def\chambers{1}
#!          \def\default{1}
#!          \input{Image_TwistedThreeStrip.tex}
#!      \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> complex := TwistedPolygonalComplexByChamberAdjacencies(
#! >    [[1,2],[3,4],[5,6],[7,8],[9,10],[11,12],[13,14],[15,16],[17,18]],
#! >    (1,6)(2,3)(4,5)(7,12)(8,9)(10,11)(13,18)(14,15)(16,17),
#! >    [[1],[2],[3,8],[4,7],[5,18],[6,17],[9,14],[10,13],[11],[12],[15],[16]]);
#! twisted polygonal surface (3 vertices, 6 edges, 3 faces, and 18 chambers)
#! gap> ChambersOfVertices(complex);
#! [ [ 1, 6, 16, 17 ], [ 2, 3, 8, 9, 14, 15 ], [ 4, 5, 7, 10, 11, 12, 13, 18 ] ]
#! gap> ChambersOfEdges(complex);
#! [ [ 1, 2 ], [ 3, 4, 7, 8 ], [ 5, 6 ], [ 9, 10, 13, 14 ], [ 11, 12 ], [ 15, 16 ], [ 17, 18 ] ]
#! gap> ChambersOfFaces(complex);
#! [ [ 1, 2, 3, 4, 5, 6 ], [ 7, 8, 9, 10, 11, 12 ], [ 13, 14, 15, 16, 17, 18 ] ]
#! @EndExampleSession
#!
#! @Returns a twisted polygonal complex
#! @Arguments zeroAdjacency, oneAdjacency, twoAdjacency
DeclareOperation("TwistedPolygonalComplexByChamberAdjacencies", [IsList, IsList, IsList]);
#! @Arguments zeroAdjacency, oneAdjacency, twoAdjacency
DeclareOperation("TwistedPolygonalComplexByChamberAdjacenciesNC", [IsList, IsList, IsList]);
#! @Arguments zeroAdjacency, oneAdjacency, twoAdjacency
DeclareOperation("TwistedPolygonalSurfaceByChamberAdjacencies", [IsList, IsList, IsList]);
#! @Arguments zeroAdjacency, oneAdjacency, twoAdjacency
DeclareOperation("TwistedPolygonalSurfaceByChamberAdjacenciesNC", [IsList, IsList, IsList]);
#! @EndGroup

#! @BeginGroup TwistedPolygonalSurfaceByChamberInvolutions
#! @Description
#! This method constructs a twisted polygonal surface 
#! (<Ref Sect="PolygonalStructures_twisted"/>). It is based on
#! the set of chambers, which is represented as a set of positive integers.
#! The method takes the following
#! parameters:
#! * <A>zeroAdjacency</A>: This parameter encodes which chambers are
#!  0-adjacent, given as an involution without fixed points.
#! * <A>oneAdjacency</A>: This parameter encodes which chambers are
#!  1-adjacent, given as an involution without fixed points.
#! * <A>twoAdjacency</A>: This parameter encodes which chambers are
#!  2-adjacent, given as an involution.
#!
#! Vertices, edges, and faces are constructed automatically.
#!
#! All of these parameters rely on the set of chambers:
#! * For <A>zeroAdjacency</A> and <A>oneAdjacency</A>, the set of
#!   moved points is the set of chambers.
#! * For <A>twoAdjacency</A>, the set of
#!   chambers is a superset of the set of moved points.
#! The NC-version does not check the consistency of this information.
#!
#! As an example, we construct the following twisted polygonal 
#! surface (the labels of vertices, edges, and faces are the default ones):
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!          \def\chambers{1}
#!          \def\default{1}
#!          \input{Image_TwistedThreeStrip.tex}
#!      \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> complex := TwistedPolygonalSurfaceByChamberInvolutions(
#! >    (1,2)(3,4)(5,6)(7,8)(9,10)(11,12)(13,14)(15,16)(17,18),
#! >    (1,6)(2,3)(4,5)(7,12)(8,9)(10,11)(13,18)(14,15)(16,17),
#! >    (3,8)(4,7)(5,18)(6,17)(9,14)(10,13));
#! twisted polygonal surface (3 vertices, 6 edges, 3 faces, and 18 chambers)
#! gap> ChambersOfVertices(complex);
#! [ [ 1, 6, 16, 17 ], [ 2, 3, 8, 9, 14, 15 ], [ 4, 5, 7, 10, 11, 12, 13, 18 ] ]
#! gap> ChambersOfEdges(complex);
#! [ [ 1, 2 ], [ 3, 4, 7, 8 ], [ 5, 6 ], [ 9, 10, 13, 14 ], [ 11, 12 ], [ 15, 16 ], [ 17, 18 ] ]
#! gap> ChambersOfFaces(complex);
#! [ [ 1, 2, 3, 4, 5, 6 ], [ 7, 8, 9, 10, 11, 12 ], [ 13, 14, 15, 16, 17, 18 ] ]
#! @EndExampleSession
#!
#! @Returns a twisted polygonal surface
#! @Arguments zeroAdjacency, oneAdjacency, twoAdjacency
DeclareOperation("TwistedPolygonalSurfaceByChamberInvolutions", [IsPerm, IsPerm, IsPerm]);
#! @Arguments zeroAdjacency, oneAdjacency, twoAdjacency
DeclareOperation("TwistedPolygonalSurfaceByChamberInvolutionsNC", [IsPerm, IsPerm, IsPerm]);
#! @EndGroup


#! @Section Relation to polygonal complexes
#! @SectionLabel AccessTwisted_Polygonal
#!
#! Every polygonal complex can be interpreted as a twisted polygonal
#! complex. However, the formalism of polygonal complexes does not
#! mention chambers at all. Thus, if we construct a polygonal complex
#! with one of the methods from Chapter 
#! <Ref Chap="Chapter_Constructors"/>, we do not immediately know
#! the chambers. Consider the following polygonal complex:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!       \input{Image_FlagComplexExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> complex := PolygonalComplexByDownwardIncidence( 
#! >    [ , , , , , [2,5], , [2,3], [3,5], [11,5], , [3,7], [7,11] ], 
#! >    [[6,8,9], , , [9,10,12,13]]);
#! polygonal surface (5 vertices, 6 edges, and 2 faces)
#! @EndExampleSession
#! It turns out that it already contains information about its
#! chambers.
#! @ExampleSession
#! gap> Chambers(complex);
#! [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 ]
#! gap> VerticesOfChambers(complex);
#! [ 2, 2, 3, 3, 3, 3, 5, 5, 5, 5, 7, 7, 11, 11 ]
#! gap> EdgesOfChambers(complex);
#! [ 6, 8, 8, 9, 9, 12, 6, 9, 9, 10, 12, 13, 10, 13 ]
#! gap> FacesOfChambers(complex);
#! [ 1, 1, 1, 1, 4, 4, 1, 1, 4, 4, 4, 4, 4, 4 ]
#! @EndExampleSession
#! Thus, the chambers can be illustrated like this:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!       \def\chambers{1}
#!       \input{Image_FlagComplexExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! Although the labels seem random at first, there is a
#! pattern here. In polygonal complexes, each chamber corresponds
#! to exactly one flag (a triple of vertex, edge, face, that are
#! all incident). The flags are given by
#! @ExampleSession
#! gap> Flags(complex);
#! [ [ 2, 6, 1 ], [ 2, 8, 1 ], [ 3, 8, 1 ], [ 3, 9, 1 ], [ 3, 9, 4 ], 
#!   [ 3, 12, 4 ], [ 5, 6, 1 ], [ 5, 9, 1 ], [ 5, 9, 4 ], [ 5, 10, 4 ],
#!   [ 7, 12, 4 ], [ 7, 13, 4 ], [ 11, 10, 4 ], [ 11, 13, 4 ]]
#! @EndExampleSession
#! Notably, a chamber <A>c</A> corresponds to the flag with position
#! <A>c</A>.
#! @ExampleSession
#! gap> VerticesOfChambers(complex) = List(Flags(complex), f -> f[1]);
#! true
#! gap> EdgesOfChambers(complex) = List(Flags(complex), f -> f[2]);
#! true
#! gap> FacesOfChambers(complex) = List(Flags(complex), f -> f[3]);
#! true
#! @EndExampleSession
#! Polygonal complexes whose chambers are given in this fashion 
#! have the property <K>IsDefaultChamberSystem</K>.
#! @ExampleSession
#! gap> IsDefaultChamberSystem(complex);
#! true
#! @EndExampleSession


#! @BeginGroup IsDefaultChamberSystem
#! @Description
#! A twisted polygonal complex <A>complex</A> has the property <K>IsDefaultChamberSystem</K>
#! if it is a polygonal complex and the chambers correspond to the flags,
#! in the following sense:
#!
#! @BeginLog
#! gap> VertexOfChamber(complex, chamber) = Flags(complex)[chamber][1];
#! gap> EdgeOfChamber(complex, chamber) = Flags(complex)[chamber][2];
#! gap> FaceOfChamber(complex, chamber) = Flags(complex)[chamber][3];
#! @EndLog
#!
#! More detail can be found at the start of Section
#! <Ref Sect="Section_AccessTwisted_Polygonal"/>.
#!
#! @Returns true or false
#! @Arguments complex
DeclareProperty( "IsDefaultChamberSystem", IsTwistedPolygonalComplex );
#! @EndGroup

InstallTrueMethod(IsPolygonalComplex, IsDefaultChamberSystem);

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
#! <Ref Sect="Section_AccessTwisted_Constrctors"/> presents some methods
#! to construct twisted polygonal complexes. Finally, Section
#! <Ref Sect="Section_AccessTwisted_Polygonal"/> explores the relation
#! between polygonal complexes and twisted polygonal complexes.
#! 

#! Section Chamber incidence
#! SectionLabel AccessTwisted_Incidence
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



#! Section Chamber adjacency
#! SectionLabel AccessTwisted_Adjacency
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
#! [ [ 1, 6 ], [ 2, 5 ], [ 3, 8 ], [ 4, 7 ], [ 9 , 14, 22 ], [ 10 ,13 ,21 ],
#!   [ 11, 16 ], [ 12 , 15 ], [ 17, 20 ], [ 18, 19 ], [ 23 ], [ 24 ], [ 25 ], [ 26 ] ]
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




#! TODO restructure this chapter after more information about correct access design is obtained

#! @Section Local flags
#! @SectionLabel AccessBend_LocalFlags

#! The main difference in contrast to a polygonal complex is an additional
#! structure on the flags of the bend polygonal complex. Since these flags
#! are different from the flags of the incidence structure, we denote them
#! as <E>local flags</E>, i.e. flags of the single polygons (before any
#! identifications took place).
#!
#! We will identify the set of local flags with a set of positive integers.
#! The attribute <K>LocalFlags</K> returns this set. In addition there are
#! two other structures:
#! <Enum>
#!     <Item>The interaction of the local flags with the incidence geometry,
#!           encoded by the attributes <K>VerticesOfLocalFlags</K> or
#!           <K>LocalFlagsOfVertices</K>.</Item>
#!     <Item>The neighbouring relations between the local flags. Generically
#!           they are given by the attribute <K>LocalFlagVertexPartition</K> 
#!           but if all classes have at most two elements, 
#!           <K>LocalFlagVertexInvolution</K> can be used instead.</Item>
#! </Enum>
#!
 
#! @Description
#! Return the set of local flags of the given bend polygonal complex.
#!
#! @Arguments bendComplex
#! @Returns A set of positive integers
DeclareAttribute( "LocalFlags", IsBendPolygonalComplex );


#! @BeginGroup
#! @Description
#! Return lists mapping a local flag (represented by its position
#! in <K>LocalFlags</K>(<A>bendComplex</A>)) to the global
#! vertex/edge/face they belong to.
#!
#! @Returns A list of positive integers
#! @Arguments bendComplex
DeclareAttribute( "VerticesOfLocalFlags", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "EdgesOfLocalFlags", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "FacesOfLocalFlags", IsBendPolygonalComplex );
#! @EndGroup


#! @BeginGroup
#! @Description
#! Return lists mapping a global vertex/edge/face to the set of 
#! local flags surrounding it.
#!
#! @Returns A list of sets of positive integers
#! @Arguments bendComplex
DeclareAttribute( "LocalFlagsOfVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalFlagsOfEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalFlagsOfFaces", IsBendPolygonalComplex );
#! @EndGroup


#! @BeginGroup
#! @Description
#! Return the sets of local vertices, local edges, and half-edges.
#!
#! @Returns a set of positive integers
#! @Arguments bendComplex
DeclareAttribute( "LocalVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "HalfEdges", IsBendPolygonalComplex );
#! @EndGroup


#! @BeginGroup
#! @Description
#! Return the set of partitions of the local flags with regard to the
#! vertex/edge/face-equivalence relation. The local flags are given by
#! their positions in <K>LocalFlags</K>(<A>bendComplex</A>).
#!
#! @Returns A set of sets
#! @Arguments bendComplex
DeclareAttribute("LocalFlagsOfLocalVertices", IsBendPolygonalComplex);
#! @Arguments bendComplex
DeclareAttribute("LocalFlagsOfLocalEdges", IsBendPolygonalComplex);
#! @Arguments bendComplex
DeclareAttribute("LocalFlagsOfHalfEdges", IsBendPolygonalComplex);
#! @EndGroup


#! @BeginGroup
#! @Description
#! TODO
#!
#! @Returns A list of positive integers
#! @Arguments bendComplex
DeclareAttribute( "LocalVerticesOfLocalFlags", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalEdgesOfLocalFlags", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "HalfEdgesOfLocalFlags", IsBendPolygonalComplex );
#! @EndGroup


#! @BeginGroup
#! @Description
#!
#! TODO
#!
#! @Returns 
#! @Arguments bendComplex
DeclareAttribute( "LocalVerticesOfFaces", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalEdgesOfFaces", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "HalfEdgesOfFaces", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "FacesOfLocalVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "FacesOfLocalEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "FacesOfHalfEdges", IsBendPolygonalComplex );

#! @Arguments bendComplex
DeclareAttribute( "VerticesOfLocalEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalEdgesOfVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "VerticesOfLocalVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalVerticesOfVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "VerticesOfHalfEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "HalfEdgesOfVertices", IsBendPolygonalComplex );

#! @Arguments bendComplex
DeclareAttribute( "EdgesOfLocalEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalEdgesOfEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "EdgesOfHalfEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "HalfEdgesOfEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "EdgesOfLocalVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalVerticesOfEdges", IsBendPolygonalComplex );

#! @Arguments bendComplex
DeclareAttribute( "LocalVerticesOfHalfEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "HalfEdgesOfLocalVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalEdgesOfHalfEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "HalfEdgesOfLocalEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalEdgesOfLocalVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalVerticesOfLocalEdges", IsBendPolygonalComplex );
#! @EndGroup


#! @BeginGroup
#! @Description
#! Return the partitions of the local flags with regard to the
#! vertex/edge/face-equivalence relation as involutions. 
#! The local flags are given by
#! their positions in <K>LocalFlags</K>(<A>bendComplex</A>).
#! 
#! If this is not possible, <K>fail</K> is returned instead.
#!
#! @Returns An involution or <K>fail</K>
#! @Arguments bendComplex
DeclareAttribute("LocalFlagVertexInvolution", IsBendPolygonalComplex);
#! @Arguments bendComplex
DeclareAttribute("LocalFlagEdgeInvolution", IsBendPolygonalComplex);
#! @Arguments bendComplex
DeclareAttribute("LocalFlagFaceInvolution", IsBendPolygonalComplex);
#! @EndGroup


#! @BeginGroup
#! @Description
#! TODO
#!
#! @Returns true or false
#! @Arguments bendComplex, flag1, flag2
DeclareOperation("IsLocalFlagsVertexEquivalent", [IsBendPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments bendComplex, flag1, flag2
DeclareOperation("IsLocalFlagsEdgeEquivalent", [IsBendPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments bendComplex, flag1, flag2
DeclareOperation("IsLocalFlagsFaceEquivalent", [IsBendPolygonalComplex, IsPosInt, IsPosInt]);
#! @EndGroup

#! @Description
#! TODO
#! @Returns a local flag
#! @Arguments bendComplex, localVertex, localEdge, face
DeclareOperation("LocalFlagByLocalVertexLocalEdgeFace", [IsBendPolygonalComplex, IsPosInt, IsPosInt, IsPosInt]);




#! @Description
#! Construct a bend polygonal complex from signed face perimeters, i.e.
#! a list (bound entries indexed by the faces) such that we have a list
#! of the following form for each face:
#! * Alternating vertex and edge numbers (the vertex-edge-path of the
#!   face perimeter) where each edge number might be multiplied with -1
#!
#! This is interpreted in the following way:
#! * The length of this list defines how many vertices the polygon for this
#!   face will have. (Length 6 = triangle)
#! * Every two adjacent elements define a flag. The flags of the first face
#!   are numbered from 1 to the length of the list. This gives all of the
#!   edges an implicit orientation
#! * If two edges have the same absolute value, they are identified. If
#!   their signs agree, they are identified with the same orientation,
#!   otherwise reversed.
#!
#! @Returns a bend polygonal complex
#! @Arguments signedFacePerimeter
DeclareOperation( "BendPolygonalComplexBySignedFacePerimeters", [IsList] );

#! @Description
#! Construct a bend polygonal surface from the coset action of a group.
#! There are some stipulations the arguments have to fulfill:
#! * The group <A>G</A> has to have three generators, denoted by <M>a</M>,
#!   <M>b</M> and <M>c</M>. 
#! * The index of the subgroup <A>H</A> in <A>G</A>
#!   has to be finite.
#! * All three generators have to act like involutions on the cosets.
#! * The action of <M>a</M> and <M>b</M> can't have fixed points on the 
#!   cosets.
#! * The orbits of <M>a</M> and <M>b</M> on the cosets have to have
#!   at least length 6.
#!
#! If these conditions are met, the bend polygonal surface is constructed
#! as follows:
#! * The set of flags is the set of moved points
#! * The orbits of <M>a</M> become the local edges
#! * The orbits of <M>b</M> become the local vertices
#! * The orbits of <M>c</M> become the half-edges
#! * The orbits of <M>a,b</M> become the faces
#! * The orbits of <M>a,c</M> become the edges
#! * The orbits of <M>b,c</M> become the vertices
#!
#! @Returns a bend polygonal surface
#! @Arguments G, H
DeclareOperation( "BendPolygonalSurfaceByCosetAction", [IsGroup, IsGroup] );

#! @Description
#! Construct a bend polygonal complex by all incidence relations that
#! start from local flags.
#!
#! @Returns a bend polygonal complex
#! @Arguments localVerticesOfLocalFlags, localEdgesOfLocalFlags, halfEdgesOfLocalFlags, verticesOfLocalFlags, edgesOfLocalFlags, facesOfLocalFlags
DeclareOperation( "BendPolygonalComplexByLocalFlagsNC", [IsList, IsList, IsList, IsList, IsList, IsList] );


#! @Section Bend faces and edges
#! @SectionLabel AccessBend_BendFacesEdges
#!
#! 


#! @BeginGroup
#! @Description
#! For a given face of a bend polygonal complex, return the polygonal
#! complex of this single polygon (the local vertices and edges of
#! <A>bendComplex</A> become the vertices and edges of the returned 
#! polygonal complex).
#!
#! The NC-version does not check whether <A>face</A> is a face of
#! <A>bendComplex</A>.
#!
#! @Returns a polygonal complex
#! @Arguments bendComplex, face
DeclareOperation("LocalFace", [IsBendPolygonalComplex, IsPosInt]);
#! @Arguments bendComplex, face
DeclareOperation("LocalFaceNC", [IsBendPolygonalComplex, IsPosInt]);
#! @EndGroup

#! @Description
#! Return the set of all rigid faces in the given bend polygonal
#! complex. These are the faces whose vertices are not identified.
#!
#! @Returns a set of positive integers
#! @Arguments bendComplex
DeclareAttribute("RigidFaces", IsBendPolygonalComplex);

#! @Description
#! Return the set of all bend faces in the given bend polygonal
#! complex. These are the faces in which vertices are identified.
#!
#! @Returns a set of positive integers
#! @Arguments bendComplex
DeclareAttribute("BendFaces", IsBendPolygonalComplex);

#! @Section Constructions
#! @SectionLabel AccessBend_Constructions

#! @BeginGroup
#! @Description
#! Construct a polygonal complex from the given bend polygonal
#! complex, if possible. Otherwise return <K>fail</K>.
#!
#! The labels of vertices, edges and faces are retained.
#!
#! @Returns a polygonal complex or <K>fail</K>
#! @Arguments bendComplex
DeclareAttribute("PolygonalComplex", IsBendPolygonalComplex);
#! @Arguments bendComplex
DeclareAttribute("PolygonalSurface", IsBendPolygonalComplex);
#! @Arguments bendComplex
DeclareAttribute("SimplicialSurface", IsBendPolygonalComplex);
#! @EndGroup


#! @Description
#! Construct a bend polygonal complex from the given polygonal complex.
#! The additional labels are defined as follows:
#! * The position of the 3-flags in <K>ThreeFlags</K> defines the labels
#!   of the local flags.
#! * The position of the 2-flags in <K>VertexEdgeFlags</K> defines the
#!   labels of the half-edges.
#! * The position of the 2-flags in <K>VertexFaceFlags</K> defines the
#!   labels of the local vertices.
#! * The position of the 2-flags in <K>EdgeFaceFlags</K> defines the
#!   labels of the local edges.
#!
#! @Returns a bend polygonal complex
#! @Arguments polyComplex
DeclareAttribute("BendPolygonalComplex", IsPolygonalComplex);


#! @BeginGroup GeodesicDual
#! @Description
#! Construct the geodesic dual of the given bend polygonal surface.
#! If a polygonal surface is given, it is silently converted into
#! a bend polygonal complex by the previous method.
#!
#! TODO
#! 
#! @Returns a bend polygonal surface
#! @Arguments bendSurface
DeclareAttribute( "GeodesicDual", IsBendPolygonalSurface );
#! @Arguments polySurface
DeclareAttribute( "GeodesicDual", IsPolygonalSurface );
#! @EndGroup

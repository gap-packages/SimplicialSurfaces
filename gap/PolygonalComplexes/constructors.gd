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

#######
## This constructor chapter has to be after the incidence geometry chapter 
## and the polygonal structures chapter to make sense.
##
## It might hinder the reading flow => all strictly necessary chapters 
## should be before this one.
##
## In comparison with the other constructor chapters (modifying existing
## surfaces and getting existing surfaces) this is the first one as it is
## the most general and should be the one that people know (if they only
## know one of them):
## -> modifications need an understanding of the structure
## -> predefined surfaces only offer some limited options
#######

#! @Chapter Constructing surfaces by their incidence structure
#! @ChapterLabel Constructors
#!
#! In chapter <Ref Chap="PolygonalStructures"/> we introduced polygonal
#! complexes (as a generalization of simplicial surfaces). They are based
#! on incidence structures, which were analysed in chapter
#! <Ref Chap="Chapter_AccessIncidenceGeometry"/>.
#! 
#! This chapter deals with the construction of custom polygonal complexes
#! and simplicial surfaces.

#######
## We have a problem in this section:
## Our constructors have the structure
## <Type>By<Method><Check?>
## => 6 * 2 = 12 operations for each method
## This is too much for one documentation group (especially since the names
## are too long to fit in a single line).
##
## Therefore we will do one method per section. We will therefore eschew the
## surface database constructors here - they are too important to be
## unnoticed here (which they will be as most readers will be inclined to
## skim this chapter).
##
## To keep a skimming reader's attention we will do a different surface example
## for each documentation group. Ideally they will epitomize different types
## of structures that might appear.
#######

#! This package offers three different ways to construct a polygonal complex
#! "from scratch":
#! * Choose from a few standard example (like platonic solids). This is covered
#!   in the later sections of chapter <Ref Chap="Chapter_Library"/>.
#! * Define it directly by its incidence structure (this will be the main
#!   content of this chapter).
#! * Use the surface database to find appropriate complexes. This will be 
#!   handled in the first section of chapter <Ref Chap="Chapter_Library"/>.
#!
#! For simplicial surfaces another and more convenient constructor is
#! the constructor
#! * <K>SimplicialSurfaceByUmbrellaDescriptor</K>( <A>edgeFacePaths</A> ).
#! All other constructures which work for general polygonal complexes
#! are structured like [Type]By[Method](args), e.g.
#! * <K>PolygonalComplexByDownwardIncidence</K>( <A>verticesOfEdges</A>, <A>edgesOfFaces</A> )
#!
#! They are mainly distinguished by the different attributes they need to 
#! construct the incidence structures:
#! * <E>DownwardIncidence</E>
#!   (<Ref Sect="Section_Constructors_DownwardIncidence"/>): 
#!   <K>VerticesOfEdges</K> (<Ref Subsect="VerticesOfEdges"/>),
#!   <K>EdgesOfFaces</K> (<Ref Subsect="EdgesOfFaces"/>)
#! * <E>UpwardIncidence</E>
#!   (<Ref Sect="Section_Constructors_UpwardIncidence"/>):
#!   <K>EdgesOfVertices</K> (<Ref Subsect="EdgesOfVertices"/>), 
#!   <K>FacesOfEdges</K> (<Ref Subsect="FacesOfEdges"/>)
#! * <E>VerticesInFaces</E>
#!   (<Ref Sect="Section_Constructors_VerticesInFaces"/>):
#!   <K>VerticesOfFaces</K> (<Ref Subsect="VerticesOfFaces"/>)
# * <E>UmbrellaPaths</E>
#   (<Ref Sect="Section_Constructors_Umbrellas"/>):
#   <K>UmbrellaPathsOfVertices</K> (<Ref Subsect="UmbrellaPathsOfVertices"/>)
#!

#TODO explain name of constructor very early
#! @Section DownwardIncidence
#! @SectionLabel Constructors_DownwardIncidence
#!
#! The <E>DownwardIncidence</E>-constructors are based on
#! the attributes <K>VerticesOfEdges</K> (<Ref Subsect="VerticesOfEdges"/>) 
#! and <K>EdgesOfFaces</K> (<Ref Subsect="EdgesOfFaces"/>). From these
#! any polygonal structure from chapter <Ref Chap="PolygonalStructures"/> can
#! be build.
#!
#! To use the constructor, we need to describe two incidence relations:
#! * incidence between vertices and edges (the argument <A>verticesOfEdges</A>)
#! * incidence between edges and faces (the argument <A>edgesOfFaces</A>)
#!
#! As an example, consider the following polygonal surface:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-1-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-1.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#!
#! Both of the incidence relations described above are given as lists. The list
#! <A>verticesOfEdges</A> contains an entry for each edge of the polygonal
#! surface. This entry contains the set
#! of all vertices that are incident to that edge.
#! @ExampleSession
#! gap> verticesOfEdges := 
#! >          [,[3,5],,,,[3,7],,[3,11],,[7,11],,[5,13],,[7,13],[11,13]];
#! [ , [ 3, 5 ],,,, [ 3, 7 ],, [ 3, 11 ],, [ 7, 11 ],, [ 5, 13 ],, 
#!   [ 7, 13 ], [ 11, 13 ] ]
#! @EndExampleSession
#! Similarly the list <A>edgesOfFaces</A> has an entry for each face with the
#! set of incident edges.
#! @ExampleSession
#! gap> edgesOfFaces := [ [2,6,12,14], , , [6,8,10], , , , , [10,14,15] ];
#! [ [ 2, 6, 12, 14 ],,, [ 6, 8, 10 ],,,,, [ 10, 14, 15 ] ]
#! @EndExampleSession
#! With these two lists we can construct the desired polygonal surface.
#! @ExampleSession
#! gap> PolygonalSurfaceByDownwardIncidence( verticesOfEdges, edgesOfFaces );;
#! @EndExampleSession
#! 
#! The <E>DownwardIncidence</E>-constructors also allow the optional arguments 
#! <A>vertices</A>,
#! <A>edges</A> and <A>faces</A>. If those sets are given, the incidence
#! information is checked for compatibility with them, that is 
#! (1) the integers in <A>faces</A> correspond to the bound positions of 
#! <A>edgesOfFaces</A>, (2) the integers in <A>edges</A> are those occurring 
#! in the entries of <A>edgesOfFaces</A> and also correspond to the bound 
#! entries of <A>verticesOfEdges</A> and 
#! (3) the integers in <A>verties</A> are those occurring
#! in the entries of <A>verticesOfEdges</A>. This is not strictly 
#! necessary since this information can be deduced from the lists
#! <A>verticesOfEdges</A> and <A>edgesOfFaces</A>.
#!
#! In practice it is common to make mistakes in manually giving these lists.
#! Especially in such situations it is recommended to use the optional 
#! arguments as they might catch some mistakes.
#!
#! To make giving these lists easier, each of these sets can be replaces by
#! a positive integer <A>n</A>, which will be interpreted as the set
#! <M>[1,...,n]</M>.
#! @ExampleSession
#! gap> PolygonalSurfaceByDownwardIncidence( [3,5,7,11,13], [2,6,8,10,12,14,15], 
#! >     [1,4,9], verticesOfEdges, edgesOfFaces );;
#! @EndExampleSession
#! 
#! The name <E>DownwardIncidence</E> stems from the fact that the incidence
#! relation is given by referring to structures of lower dimension  - an edge
#! (dimension 1) is defined by two vertices (dimension 0) and a face 
#! (dimension 2) is defined by edges.

#TODO should the presentation be changed?
# Problem: optional argument types unclear (because complicated..)
# Problem: Name too long for one line and breaks at bad point

#TODO should we introduce a "similar methods"-part at the end of
# some methods? This might become too long..

#TODO 4 examples for the constructors (to showcase how each method
# handles it).
# TODO for visual distinguishing make the face colours slightly
# different: yellow, cyan, green, light red, etc...
# This needs styles and appropriate code


## Here we write part of the documentation that is the same over the 
## different versions
#! @BeginChunk Documentation_DownwardIncidence
#! where vertices, edges and faces are represented by positive integers.
#! It is based on the attributes
#! <K>VerticesOfEdges</K> (<Ref Subsect="VerticesOfEdges"/>) and 
#! <K>EdgesOfFaces</K> (<Ref Subsect="EdgesOfFaces"/>) and takes these
#! arguments:
#! <Enum>
#!   <Item>OPTIONAL: Each of the optional arguments <A>vertices</A>, 
#!          <A>edges</A> and <A>faces</A> is either a set of positive
#!          integers or a positive integer. In the latter case, an integer
#!          <M>n</M> represents the set <M>[1,...,n]</M>.
#!          
#!          Although these arguments can be deduced from the non-optional
#!          arguments, their use is recommended to catch mistakes in these
#!          other arguments.</Item>
#!   <Item> <K>verticesOfEdges</K>: A list that has an entry for each edge (a
#!          positive integer).
#!          This entry has to be a list of the two 
#!          vertices (as positive integers) of this edge.</Item>
#!   <Item> <K>edgesOfFaces</K>: A list that has an entry for each face (a
#!          positive integer).
#!          This entry has to be a list of the edges 
#!          (as positive integers) of this face.</Item>
#! </Enum>
#!
#! The method checks whether the
#! answer to each of the following questions is true. None of these checks 
#! will be
#! performed by the NC-version.
#! * Are the optional arguments <A>vertices</A>, <A>edges</A> and <A>faces</A>
#!   either positive integers or sets of positive integers?
#! * Are <A>verticesOfEdges</A> and <A>edgesOfFaces</A> lists where the 
#!   entries are lists of positive integers?
#! * Is every bound entry of <A>verticesOfEdges</A> a list with exactly two 
#!   entries that are different?
#! * Does every bound entry of <A>edgesOfFaces</A> contain at least two 
#!   elements?
#! * If <A>vertices</A> is given, is 
#!   <K>Union</K>(<A>verticesOfEdges</A>) = <A>vertices</A>?
#! * Are the bound positions of <A>verticesOfEdges</A> equal to 
#!   <K>Union</K>(<A>edgesOfFaces</A>)? If <A>edges</A> is given, is it equal 
#!   to those two sets?
#! * If <A>faces</A> is given, is it equal to the bound positions of 
#!   <A>edgesOfFaces</A>?
#! @EndChunk

#! @BeginGroup
#! @Description
#! This method constructs a polygonal complex 
#! (<Ref Sect="PolygonalStructures_complex"/>)
#! @InsertChunk Documentation_DownwardIncidence
#! 
#! As an example consider the following net of a polygonal complex (note, there
#! are both vertex and edge ramifications):
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-2-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-2.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> complex := PolygonalComplexByDownwardIncidence(
#! >        [[1,2],[2,3],[1,3],[3,6],[1,6],[6,5],[2,5],[1,5]],
#! >        [[1,7,8],[1,7,8],[2,4,6,7],[2,4,6,7],[3,4,5],[3,4,5]]);;
#! gap> RamifiedVertices(complex);
#! [ 1 ]
#! gap> ChaoticVertices(complex);
#! [ 2, 3, 5, 6 ]
#! @EndExampleSession
#!
#! @Returns a polygonal complex
#! @Arguments verticesOfEdges, edgesOfFaces
DeclareOperation( "PolygonalComplexByDownwardIncidence", [IsList, IsList] );
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces
DeclareOperation( "PolygonalComplexByDownwardIncidence", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @Arguments verticesOfEdges, edgesOfFaces
DeclareOperation( "PolygonalComplexByDownwardIncidenceNC", [IsList, IsList] );
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces
DeclareOperation( "PolygonalComplexByDownwardIncidenceNC", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @EndGroup


#! @BeginGroup
#! @Description
#! This method constructs a polygonal surface
#! (<Ref Sect="PolygonalStructures_surface"/>)
#! @InsertChunk Documentation_DownwardIncidence
#!
#! As an example consider the following net of a simplicial surface:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-3-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-3.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> surf := PolygonalSurfaceByDownwardIncidence(
#! >      [[1,2],[2,3],[3,4],[4,5],[5,1],
#! >       [1,6],[2,7],[2,8],[3,9],[3,10],[4,11],[4,12],[5,13],[5,14],[1,15],
#! >       [6,15],[6,7],[7,8],[8,9],[9,10],[10,11],[11,12],[12,13],[13,14],[14,15]],
#! >      [[6,15,16],[1,6,7,17],[7,8,18],[2,8,9,19],[9,10,20],[3,10,11,21],
#! >       [11,12,22],[4,12,13,23],[13,14,24],[5,14,15,25]]);;
#! gap> IsClosedSurface(surf);
#! false
#! gap> PerimeterOfHoles(surf);
#! [ (v1, E1, v2, E2, v3, E3, v4, E4, v5, E5, v1), 
#!   (v6, E16, v15, E25, v14, E24, v13, E23, v12, E22, v11, E21, 
#!             v10, E20, v9, E19, v8, E18, v7, E17, v6) ]
#! @EndExampleSession
#!
#! @Returns a polygonal surface
#! @Arguments verticesOfEdges, edgesOfFaces
DeclareOperation( "PolygonalSurfaceByDownwardIncidence", [IsList, IsList] );
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces
DeclareOperation( "PolygonalSurfaceByDownwardIncidence", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @Arguments verticesOfEdges, edgesOfFaces
DeclareOperation( "PolygonalSurfaceByDownwardIncidenceNC", [IsList, IsList] );
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces
DeclareOperation( "PolygonalSurfaceByDownwardIncidenceNC", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! This method constructs a triangular complex
#! (<Ref Sect="PolygonalStructures_complex"/>)
#! @InsertChunk Documentation_DownwardIncidence
#!
#! As an example consider the following net of a triangular complex (at the
#! vertices and edges marked red, there are ramifications):
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-4-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-4.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> complex := TriangularComplexByDownwardIncidence(
#! >        [[1,7],[2,7],[3,7],[4,7],[5,7],[6,7],
#! >         [1,9],[8,9],[3,9],[4,9],[9,10],[6,9],
#! >         [1,12],[11,12],[3,12],[4,12],[12,13],[6,12],
#! >         [1,2],[2,3],[3,4],[4,5],[5,6],,[1,8],[3,8],
#! >         [4,10],[6,10],[1,11],[3,11],[4,13],[6,13]],
#! >        [[1,2,19],[2,3,20],[3,4,21],[4,5,22],[5,6,23],
#! >         [7,8,25],[8,9,26],[9,10,21],[10,11,27],[11,12,28],
#! >         [13,14,29],[14,15,30],[15,16,21],[16,17,31],[17,18,32]]);;
#! gap> UmbrellaPathPartitionOfVertex(complex, 1);
#! [ | e1, F1, e19 |, | e7, F6, e25 |, | e13, F11, e29 | ]
#! gap> UmbrellaPathPartitionOfVertex(complex, 6);
#! [ | e6, F5, e23 |, | e12, F10, e28 |, | e18, F15, e32 | ]
#! gap> FacesOfEdge(complex, 21);
#! [ 3, 8, 13 ]
#! @EndExampleSession
#!
#! @Returns a triangular complex
#! @Arguments verticesOfEdges, edgesOfFaces
DeclareOperation( "TriangularComplexByDownwardIncidence", [IsList, IsList] );
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces
DeclareOperation( "TriangularComplexByDownwardIncidence", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @Arguments verticesOfEdges, edgesOfFaces
DeclareOperation( "TriangularComplexByDownwardIncidenceNC", [IsList, IsList] );
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces
DeclareOperation( "TriangularComplexByDownwardIncidenceNC", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @EndGroup


#! @BeginGroup
#! @Description
#! This method constructs a simplicial surface
#! (<Ref Sect="PolygonalStructures_surface"/>)
#! @InsertChunk Documentation_DownwardIncidence
#!
#! As an example consider the following net of a simplicial surface:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-5-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-5.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> surf := SimplicialSurfaceByDownwardIncidence(
#! >      [[1,5],[2,5],[5,6],[5,9],[4,5],,[1,4],[1,2],[2,6],,
#! >       [1,7],[2,7],[6,7],[7,10],[4,7],,[6,9],[4,9],[6,10],[4,10],,[9,10]],
#! >      [[1,5,7],[1,2,8],[2,3,9],[3,4,17],[4,5,18],,,,[17,19,22],
#! >       [18,20,22],[7,11,15],[8,11,12],[9,12,13],[13,14,19],[14,15,20]]);;
#! gap> Vertices(surf);
#! [ 1, 2, 4, 5, 6, 7, 9, 10 ]
#! gap> Edges(surf);
#! [ 1, 2, 3, 4, 5, 7, 8, 9, 11, 12, 13, 14, 15, 17, 18, 19, 20, 22 ]
#! gap> Faces(surf);
#! [ 1, 2, 3, 4, 5, 9, 10, 11, 12, 13, 14, 15 ]
#! gap> EulerCharacteristic(surf);
#! 2
#! gap> IsClosedSurface(surf);
#! true
#! @EndExampleSession
#!
#! @Returns a simplicial surface
#! @Arguments verticesOfEdges, edgesOfFaces
DeclareOperation( "SimplicialSurfaceByDownwardIncidence", [IsList, IsList] );
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces
DeclareOperation( "SimplicialSurfaceByDownwardIncidence", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @Arguments verticesOfEdges, edgesOfFaces
DeclareOperation( "SimplicialSurfaceByDownwardIncidenceNC", [IsList, IsList] );
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces
DeclareOperation( "SimplicialSurfaceByDownwardIncidenceNC", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @EndGroup
#TODO remark that most of these constructors also check for some properties


#! @Section UpwardIncidence
#! @SectionLabel Constructors_UpwardIncidence
#!
#! The <E>UpwardIncidence</E>-constructors are based on
#! the attributes <K>EdgesOfVertices</K> (<Ref Subsect="EdgesOfVertices"/>) 
#! and <K>FacesOfEdges</K> (<Ref Subsect="FacesOfEdges"/>). From these
#! any polygonal structure from chapter <Ref Chap="PolygonalStructures"/> can
#! be build.
#!
#! To use the constructor, we need to describe two incidence relations:
#! * incidence between edges and vertices (the argument <A>edgesOfVertices</A>)
#! * incidence between faces and edges (the argument <A>facesOfEdges</A>)
#!
#! As an example, consider the following polygonal surface:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-6-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-6.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#!
#! Both of the incidence relations described above are given as lists. The list
#! <A>edgesOfVertices</A> contains an entry for each vertex of the polygonal
#! surface. This entry contains the set
#! of all edges that are incident to that vertex.
#! @ExampleSession
#! gap> edgesOfVertices := 
#! >         [,, [2,6,8],, [2,12],, [6,10,14],,,, [8,10,15],, [12,14,15] ];
#! [ ,,  [ 2, 6, 8 ],, [ 2, 12 ],, [ 6, 10, 14 ],,,, [ 8, 10, 15 ],, 
#!     [ 12, 14, 15 ] ]
#! @EndExampleSession
#! Similarly the list <A>facesOfEdges</A> has an entry for each edge with the
#! set of incident faces.
#! @ExampleSession
#! gap> facesOfEdges := [ , [1], , , , [1,4], , [4], , [4,9], , [1], , [1,9], [9] ];
#! [ , [ 1 ],,,, [ 1, 4 ],, [ 4 ],, [ 4, 9 ],, [ 1 ],, [ 1, 9 ], [ 9 ] ]
#! @EndExampleSession
#! With these two lists we can construct the desired polygonal surface.
#! @ExampleSession
#! gap> PolygonalSurfaceByUpwardIncidence( edgesOfVertices, facesOfEdges );;
#! @EndExampleSession
#! 
#! The <E>UpwardIncidence</E>-constructors also allow the optional arguments 
#! <A>vertices</A>,
#! <A>edges</A> and <A>faces</A>. If those sets are given, the incidence
#! information is checked for compatibility with them. This is not strictly 
#! necessary since this information can be deduced from the lists
#! <A>edgesOfVertices</A> and <A>facesOfEdges</A>.
#!
#! In practice it is common to make mistakes in manually giving these lists.
#! Especially in such situations it is recommended to use the optional 
#! arguments as they might catch some mistakes.
#!
#! To make giving these lists easier, each of these sets can be replaces by
#! a positive integer <A>n</A>, which will be interpreted as the set
#! <M>[1,...,n]</M>.
#! @ExampleSession
#! gap> PolygonalSurfaceByUpwardIncidence( [3,5,7,11,13], [2,6,8,10,12,14,15], 
#! >     [1,4,9], edgesOfVertices, facesOfEdges );;
#! @EndExampleSession
#! 
#! The name <E>UpwardIncidence</E> stems from the fact that the incidence
#! relation is given by referring to structures of higher dimension  - a vertex
#! (dimension 0) is defined by its edges (dimension 1) and an edge 
#! is defined by faces (dimension 2).

#TODO should the presentation be changed? (See above TODO);


## Here we write part of the documentation that is the same over the 
## different versions
#! @BeginChunk Documentation_UpwardIncidence
#! where vertices, edges and faces are represented by positive integers.
#! It is based on the attributes
#! <K>EdgesOfVertices</K> (<Ref Subsect="EdgesOfVertices"/>) and 
#! <K>FacesOfEdges</K> (<Ref Subsect="FacesOfEdges"/>) and takes these
#! arguments:
#! <Enum>
#!   <Item>OPTIONAL: Each of the optional arguments <A>vertices</A>, 
#!          <A>edges</A> and <A>faces</A> is either a set of positive
#!          integers or a positive integer. In the latter case, an integer
#!          <M>n</M> represents the set <M>[1,...,n]</M>.
#!          
#!          Although these arguments can be deduced from the non-optional
#!          arguments, their use is recommended to catch mistakes in these
#!          other arguments.</Item>
#!   <Item> <K>edgesOfVertices</K>: A list that has an entry for each vertex (a
#!          positive integer).
#!          This entry has to be a list of the incident
#!          edges (as positive integers) of this vertex.</Item>
#!   <Item> <K>facesOfEdges</K>: A list that has an entry for each edge (a
#!          positive integer).
#!          This entry has to be a list of the incident faces 
#!          (as positive integers) of this edge.</Item>
#! </Enum>
#!
#! The method checks whether the
#! answer to each of the following questions is true. None of these checks 
#! will be
#! performed by the NC-version.
#! * Are the optional arguments <A>vertices</A>, <A>edges</A> and <A>faces</A>
#!   either positive integers or sets of positive integers?
#! * Are <A>edgesOfVertices</A> and <A>facesOfEdges</A> lists where the 
#!   entries are lists of positive integers?
#! * Does every edge of the resulting polygonal complex has exactly two
#!   incident vertices?
#! * Does every face of the resulting polygonal complex has at least two
#!   incident edges?
#! * Does every bound entry of <A>edgesOfFaces</A> contain at least two 
#!   elements?
#! * If <A>vertices</A> is given, is it equal to the bound positions of
#!   <A>edgesOfVertices</A>?
#! * Are the bound positions of <A>facesOfEdges</A> equal to 
#!   <K>Union</K>(<A>edgesOfVertices</A>)? If <A>edges</A> is given, is it equal 
#!   to those two sets?
#! * If <A>faces</A> is given, is it equal to 
#!   <K>Union</K>(<A>facesOfEdges</A>)?
#! @EndChunk

#! @BeginGroup
#! @Description
#! This method constructs a polygonal complex 
#! (<Ref Sect="PolygonalStructures_complex"/>)
#! @InsertChunk Documentation_UpwardIncidence
#! 
#! As an example consider the following net of a polygonal complex (note, there
#! are both vertex and edge ramifications):
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-7-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-7.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> complex := PolygonalComplexByUpwardIncidence(
#! >        [[1,8,3,5],[1,2,7],[2,3,4],,[6,7,8],[4,5,6]],
#! >        [[1,2],[3,4],[5,6],[3,4,5,6],[5,6],[3,4],[1,2,3,4],[1,2]]);;
#! gap> RamifiedVertices(complex);
#! [ 1 ]
#! gap> ChaoticVertices(complex);
#! [ 2, 3, 5, 6 ]
#! @EndExampleSession
#!
#! @Returns a polygonal complex
#! @Arguments edgesOfVertices, facesOfEdges
DeclareOperation( "PolygonalComplexByUpwardIncidence", [IsList, IsList] );
#! @Arguments vertices, edges, faces, edgesOfVertices, facesOfEdges
DeclareOperation( "PolygonalComplexByUpwardIncidence", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @Arguments edgesOfVertices, facesOfEdges
DeclareOperation( "PolygonalComplexByUpwardIncidenceNC", [IsList, IsList] );
#! @Arguments vertices, edges, faces, edgesOfVertices, facesOfEdges
DeclareOperation( "PolygonalComplexByUpwardIncidenceNC", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! This method constructs a polygonal surface
#! (<Ref Sect="PolygonalStructures_surface"/>)
#! @InsertChunk Documentation_UpwardIncidence
#!
#! As an example consider the following net of a simplicial surface:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-8-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-8.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> surf := PolygonalSurfaceByUpwardIncidence(
#! >      [[1,5,6,15],[1,2,7,8],[2,3,9,10],[3,4,11,12],[4,5,13,14],
#! >       [6,16,17],[7,17,18],[8,18,19],[9,19,20],[10,20,21],[11,21,22],
#! >       [12,22,23],[13,23,24],[14,24,25],[15,16,25]],
#! >      [[2],[4],[6],[8],[10],[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],
#! >       [8,9],[9,10],[1,10],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10]]);;
#! gap> IsClosedSurface(surf);
#! false
#! gap> PerimeterOfHoles(surf);
#! [ (v1, E1, v2, E2, v3, E3, v4, E4, v5, E5, v1), 
#!   (v6, E16, v15, E25, v14, E24, v13, E23, v12, E22, v11, E21, 
#!             v10, E20, v9, E19, v8, E18, v7, E17, v6) ]
#! @EndExampleSession
#!
#! @Returns a polygonal surface
#! @Arguments edgesOfVertices, facesOfEdges
DeclareOperation( "PolygonalSurfaceByUpwardIncidence", [IsList, IsList] );
#! @Arguments vertices, edges, faces, edgesOfVertices, facesOfEdges
DeclareOperation( "PolygonalSurfaceByUpwardIncidence", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @Arguments edgesOfVertices, facesOfEdges
DeclareOperation( "PolygonalSurfaceByUpwardIncidenceNC", [IsList, IsList] );
#! @Arguments vertices, edges, faces, edgesOfVertices, facesOfEdges
DeclareOperation( "PolygonalSurfaceByUpwardIncidenceNC", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! This method constructs a triangular complex
#! (<Ref Sect="PolygonalStructures_complex"/>)
#! @InsertChunk Documentation_UpwardIncidence
#!
#! As an example consider the following net of a triangular complex (at the
#! vertices and edges marked red, there are ramifications):
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-9-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-9.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> complex := TriangularComplexByUpwardIncidence(
#! >        [[1,19,7,25,13,29],[2,19,20],
#! >         [20,3,21,9,26,15,30],[22,4,21,10,27,16,31],
#! >         [23,5,22],[6,23,12,28,18,32],[1,2,3,4,5,6],[26,8,25],
#! >         [7,8,9,10,11,12],[27,11,28],[30,14,29],[13,14,15,16,17,18],
#! >         [31,17,32]],
#! >        [[1],[1,2],[2,3],[3,4],[4,5],[5],
#! >         [6],[6,7],[7,8],[8,9],[9,10],[10],
#! >         [11],[11,12],[12,13],[13,14],[14,15],[15],
#! >         [1],[2],[3,8,13],[4],[5],,[6],[7],[9],[10],[11],[12],[14],[15]]);;
#! gap> UmbrellaPathPartitionOfVertex(complex, 1);
#! [ | e1, F1, e19 |, | e7, F6, e25 |, | e13, F11, e29 | ]
#! gap> UmbrellaPathPartitionOfVertex(complex, 6);
#! [ | e6, F5, e23 |, | e12, F10, e28 |, | e18, F15, e32 | ]
#! gap> FacesOfEdge(complex, 21);
#! [ 3, 8, 13 ]
#! @EndExampleSession
#
#! @Returns a triangular complex
#! @Arguments edgesOfVertices, facesOfEdges
DeclareOperation( "TriangularComplexByUpwardIncidence", [IsList, IsList] );
#! @Arguments vertices, edges, faces, edgesOfVertices, facesOfEdges
DeclareOperation( "TriangularComplexByUpwardIncidence", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @Arguments edgesOfVertices, facesOfEdges
DeclareOperation( "TriangularComplexByUpwardIncidenceNC", [IsList, IsList] );
#! @Arguments vertices, edges, faces, edgesOfVertices, facesOfEdges
DeclareOperation( "TriangularComplexByUpwardIncidenceNC", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @EndGroup


#! @BeginGroup
#! @Description
#! This method constructs a simplicial surface
#! (<Ref Sect="PolygonalStructures_surface"/>)
#! @InsertChunk Documentation_UpwardIncidence
#!
#! As an example consider the following net of a simplicial surface:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-10-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-10.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> surf := SimplicialSurfaceByUpwardIncidence(
#! >      [[1,7,8,11],[2,8,9,12],,[5,7,15,18,20],[1,2,3,4,5],
#! >       [3,9,13,17,19],[11,12,13,14,15],,[4,17,18,22],[14,19,20,22]],
#! >      [[1,2],[2,3],[3,4],[4,5],[1,5],,[1,11],[2,12],[3,13],,
#! >       [11,12],[12,13],[13,14],[14,15],[11,15],,
#! >       [4,9],[5,10],[9,14],[10,15],,[9,10]]);;
#! gap> Vertices(surf);
#! [ 1, 2, 4, 5, 6, 7, 9, 10 ]
#! gap> Edges(surf);
#! [ 1, 2, 3, 4, 5, 7, 8, 9, 11, 12, 13, 14, 15, 17, 18, 19, 20, 22 ]
#! gap> Faces(surf);
#! [ 1, 2, 3, 4, 5, 9, 10, 11, 12, 13, 14, 15 ]
#! gap> EulerCharacteristic(surf);
#! 2
#! gap> IsClosedSurface(surf);
#! true
#! @EndExampleSession
#!
#! @Returns a simplicial surface
#! @Arguments edgesOfVertices, facesOfEdges
DeclareOperation( "SimplicialSurfaceByUpwardIncidence", [IsList, IsList] );
#! @Arguments vertices, edges, faces, edgesOfVertices, facesOfEdges
DeclareOperation( "SimplicialSurfaceByUpwardIncidence", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @Arguments edgesOfVertices, facesOfEdges
DeclareOperation( "SimplicialSurfaceByUpwardIncidenceNC", [IsList, IsList] );
#! @Arguments vertices, edges, faces, edgesOfVertices, facesOfEdges
DeclareOperation( "SimplicialSurfaceByUpwardIncidenceNC", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @EndGroup
#TODO remark that most of these constructors also check for some properties



## It has to be remembered that these sections are primary candidates for
## skipping targets - many people are probably interested in constructions.
## Therefore they have to be mostly self-contained.

#! @Section VerticesInFaces
#! @SectionLabel Constructors_VerticesInFaces
#!
#! The <E>VerticesInFaces</E>-constructors are based on
#! the attribute <K>VerticesOfFaces</K> (<Ref Subsect="VerticesOfFaces"/>)
#! for triangular faces and an oriented version of it for non-triangular 
#! ones.
#! 
#! To use the constructor we need to know the incidence relation between 
#! vertices and faces (the edge information has to be deduced from that).
#! Therefore it is assumed that every edge is uniquely identified by its
#! incident vertices. Apart from this restriction, every polygonal structure
#! from chapter <Ref Chap="PolygonalStructures"/> can be build.
#!
#! Consider the following polygonal surface:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-11-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-11.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#!
#! The face with number <M>4</M> is incident to the vertices <M>[3,7,11]</M>.
#! Since the edges of a triangle are uniquely determined by its vertices, the 
#! constructor will assume that the edges <M>[3,7]</M>, <M>[3,11]</M> and
#! <M>[7,11]</M> exist. 
#!
#! The face <M>9</M> with the incident vertices 
#! <M>[7,11,13]</M> is handled in the same way. This triangle also 
#! contains an edge with vertices <M>7</M> and <M>11</M>, which is assumed to 
#! be the same edge <M>[7,11]</M> of the face <M>4</M>.
#!
#! This deduction of edges does not work if a face is incident to more than
#! three vertices. Here the face with number <M>1</M> is incident to four
#! different vertices: <M>[3,5,7,13]</M>. As it is not obvious which of these
#! are connected by edges, the method needs additional information. If the 
#! vertices are given as the list <M>[3,5,13,7]</M>, the edges can be defined
#! by adjacent entries in this list (the first and last entry count as 
#! adjacent).
#!
#! The full rules for the edge deduction are:
#! * An edge is uniquely identified by its incident vertices.
#! * If a face is given by the vertex list <M>[v_1, v_2, ..., v_k]</M> then
#!   adjacent vertices in the list are assumed to form an edge of the face
#!   (first and last vertex count as adjacent). In this case we would have the edges
#!   <M>[v_1,v_2]</M>, <M>[v_2,v_3]</M>, ..., <M>[v_k,v_1]</M>.
#!
#! The incidence information is given as a list that has an entry for each
#! face. For every face this entry is a list of the incident vertices, where
#! the order of the vertices in the list determines the edges (if there are
#! more than three vertices).
#! @ExampleSession
#! gap> verticesInFaces := [ [3,5,13,7], , , [3,11,7], , , , , [7,11,13] ];
#! [ [ 3, 5, 13, 7 ],,, [ 3, 11, 7 ],,,,, [ 7, 11, 13 ] ]
#! gap> PolygonalSurfaceByVerticesInFaces( verticesInFaces );;
#! @EndExampleSession
#! 
#! The <E>VerticesInFaces</E>-constructors also allow the optional arguments 
#! <A>vertices</A>
#! and <A>faces</A>. If those sets are given, the incidence
#! information is checked for compatibility with them. This is very useful
#! in practice to notice typos in the incidence relations. 
#! As this can be deduced from the argument <A>verticesInFaces</A> it is not
#! necessary to give these optional arguments.
#!
#! In practice it is common to make mistakes in manually typing this list.
#! Especially in a situation like this it is recommended to use the optional
#! arguments to catch some mistakes. 
#!
#! To make this easier, each of these
#! optional arguments can be replaced by a positive integer <A>n</A> (which
#! will be interpreted as the set <M>[1,...,n]</M>).
#! @ExampleSession
#! gap> PolygonalSurfaceByVerticesInFaces( [3,5,7,11,13], [1,4,9], verticesInFaces );;
#! @EndExampleSession
#! 

#! @BeginChunk Documentation_VerticesInFaces
#! where vertices, edges and faces are represented by positive integers.
#! It is based on the attributes
#! <K>VerticesOfFaces</K> (<Ref Subsect="VerticesOfFaces"/>) and 
#! requires that the edges be uniquely defined by their incident vertices.
#! It takes the following arguments:
#! <Enum>
#!   <Item>OPTIONAL: Each of the optional arguments <A>vertices</A>, 
#!          <A>edges</A> and <A>faces</A> is either a set of positive
#!          integers or a positive integer. In the latter case, an integer
#!          <M>n</M> represents the set <M>[1,...,n]</M>.
#!          
#!          Although these arguments can be deduced from the non-optional
#!          arguments, their use is recommended to catch mistakes in these
#!          other arguments.</Item>
#!   <Item> <K>verticesInFaces</K>: A list that has an entry for each positive
#!          integer corresponding to a face. This entry is a list of positive
#!          integers <M>[v_1, v_2 , ..., v_k ]</M>, each corresponding to
#!          a vertex incident to the face. Moreover, two consecutive vertices
#!          in this list are the vertices of an edge incident to the face  
#!          (here the first and last vertex count as consecutive). 
#!   </Item>
#! </Enum>
#!
#! The method checks whether the
#! answer to each of the following questions is true. None of these checks 
#! will be performed by the NC-version.
#! * Are the optional arguments <A>vertices</A>, <A>edges</A> and <A>faces</A>
#!   either positive integers or sets of positive integers?
#! * Is <A>verticesInFaces</A> a list whose entries are lists of pairwise
#!   different positive integers?
#! * Does every bound entry of <A>verticesInFaces</A> contain at least two 
#!   elements?
#! * If <A>vertices</A> is given, is 
#!   <K>Union</K>(<A>verticesInFaces</A>) = <A>vertices</A>?
#! * If <A>faces</A> is given, is it equal to the bound positions of 
#!   <A>verticesInFaces</A>?
#! @EndChunk

#TODO explain how the edge numbers are chosen (such that VerticesOfEdges is a set);


#! @BeginGroup
#! @Description
#! This method constructs a polygonal complex 
#! (<Ref Sect="PolygonalStructures_complex"/>)
#! @InsertChunk Documentation_VerticesInFaces
#!
#! As an example consider the following net of a polygonal complex (note, there
#! are both vertex and edge ramifications):
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-12-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-12.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> complex := PolygonalComplexByVerticesInFaces(
#! >        [[1,2,5],[1,2,5],[2,3,6,5],[2,3,6,5],[1,6,3],[1,3,6]]);;
#! gap> RamifiedVertices(complex);
#! [ 1 ]
#! gap> ChaoticVertices(complex);
#! [ 2, 3, 5, 6 ]
#! @EndExampleSession
#! 
#! @Returns a polygonal complex
#! @Arguments verticesInFaces
DeclareOperation( "PolygonalComplexByVerticesInFaces", [IsList] );
#! @Arguments vertices, faces, verticesInFaces
DeclareOperation( "PolygonalComplexByVerticesInFaces", [IsSet, IsSet, IsList] );
#! @Arguments verticesInFaces
DeclareOperation( "PolygonalComplexByVerticesInFacesNC", [IsList] );
#! @Arguments vertices, faces, verticesInFaces
DeclareOperation( "PolygonalComplexByVerticesInFacesNC", [IsSet, IsSet, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! This method constructs a polygonal surface
#! (<Ref Sect="PolygonalStructures_surface"/>)
#! @InsertChunk Documentation_VerticesInFaces
#!
#! As an example consider the following net of a simplicial surface:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-13-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-13.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> surf := PolygonalSurfaceByVerticesInFaces(
#! >      [[1,6,15],[1,2,7,6],[2,7,8],[2,3,9,8],[3,9,10],[3,4,11,10],[4,11,12],
#! >       [4,5,13,12],[5,13,14],[1,5,14,15]]);;
#! gap> IsClosedSurface(surf);
#! false
#! @EndExampleSession
#! 
#! @Returns a polygonal surface
#! @Arguments verticesInFaces
DeclareOperation( "PolygonalSurfaceByVerticesInFaces", [IsList] );
#! @Arguments vertices, faces, verticesInFaces
DeclareOperation( "PolygonalSurfaceByVerticesInFaces", [IsSet, IsSet, IsList] );
#! @Arguments verticesInFaces
DeclareOperation( "PolygonalSurfaceByVerticesInFacesNC", [IsList] );
#! @Arguments vertices, faces, verticesInFaces
DeclareOperation( "PolygonalSurfaceByVerticesInFacesNC", [IsSet, IsSet, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! This method constructs a triangular complex 
#! (<Ref Sect="PolygonalStructures_complex"/>)
#! @InsertChunk Documentation_VerticesInFaces
#!
#! As an example consider the following net of a triangular complex (at the
#! vertices and edges marked red, there are ramifications):
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-14-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-14.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> complex := TriangularComplexByVerticesInFaces(
#! >        [[1,2,7],[2,3,7],[3,4,7],[4,5,7],[5,6,7],
#! >         [1,8,9],[3,8,9],[3,4,9],[4,10,9],[6,10,9],
#! >         [1,11,12],[3,11,12],[3,4,12],[4,13,12],[6,13,12]]);;
#! @EndExampleSession
#!
#! @Returns a triangular complex
#! @Arguments verticesInFaces
DeclareOperation( "TriangularComplexByVerticesInFaces", [IsList] );
#! @Arguments vertices, faces, verticesInFaces
DeclareOperation( "TriangularComplexByVerticesInFaces", [IsSet, IsSet, IsList] );
#! @Arguments verticesInFaces
DeclareOperation( "TriangularComplexByVerticesInFacesNC", [IsList] );
#! @Arguments vertices, faces, verticesInFaces
DeclareOperation( "TriangularComplexByVerticesInFacesNC", [IsSet, IsSet, IsList] );
#! @EndGroup


#! @BeginGroup
#! @Description
#! This method constructs a simplicial surface
#! (<Ref Sect="PolygonalStructures_surface"/>)
#! @InsertChunk Documentation_VerticesInFaces
#! 
#! As an example consider the following net of a simplicial surface:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-15-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-15.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> surf := SimplicialSurfaceByVerticesInFaces(
#! >      [[1,4,5],[1,2,5],[2,5,6],[5,6,9],[4,5,9],,,,
#! >       [6,9,10],[4,9,10],[1,4,7],[1,2,7],[2,6,7],[6,7,10],[4,7,10]]);;
#! gap> Vertices(surf);
#! [ 1, 2, 4, 5, 6, 7, 9, 10 ]
#! gap> NumberOfEdges(surf);
#! 18
#! gap> Faces(surf);
#! [ 1, 2, 3, 4, 5, 9, 10, 11, 12, 13, 14, 15 ]
#! gap> EulerCharacteristic(surf);
#! 2
#! gap> IsClosedSurface(surf);
#! true
#! @EndExampleSession
#! 
#! @Returns a simplicial surface
#! @Arguments verticesInFaces
DeclareOperation( "SimplicialSurfaceByVerticesInFaces", [IsList] );
#! @Arguments vertices, faces, verticesInFaces
DeclareOperation( "SimplicialSurfaceByVerticesInFaces", [IsSet, IsSet, IsList] );
#! @Arguments verticesInFaces
DeclareOperation( "SimplicialSurfaceByVerticesInFacesNC", [IsList] );
#! @Arguments vertices, faces, verticesInFaces
DeclareOperation( "SimplicialSurfaceByVerticesInFacesNC", [IsSet, IsSet, IsList] );
#! @EndGroup

#! @Section Umbrella Descriptors
#!
#! A very useful way of describing surfaces is by listing the umbrella paths around
#! each vertex. Formally, 
#! @InsertChunk Documentation_UmbrellaDescriptor
#!
#! @SectionLabel Constructors_Umbrellas
#!
#! @BeginChunk Documentation_UmbrellaDescriptor
#! an umbrella descriptor of a simplicial surface is a list <A>umbdesc</A>, 
#! describing a simplicial surface.  The bound entries in <A>umbdesc</A> are
#! cyclic permutations or lists of integers. The set of faces of the surface
#! is the set of points which either are moved by a cyclic permutation or 
#! occur in a list in <A>umbdesc</A>. The edges of the surface correspond to
#! pairs of faces <M>(i,j)</M>, where either some cycle in <A>umbdesc</A> maps
#! <M>i</M> to  <M>j</M> or <M>i</M> and <M>j</M> occur as neighbours in a 
#! list. The vertices of the surface are the positive integers
#! corresponding to the bound positions of <A>umbdesc</A>.
#! If position <M>i</M> of <A>umbdesc</A> is bound, then the 
#! <M>i</M>-th entry represents the vertex with name <M>i</M>.  If the vertex 
#! named <M>i</M> is inner,  then the <M>i</M>-th entry in <A>umbdesc</A> 
#! is a cyclic permutation of the faces in the umbrella path around the 
#! vertex, mapping a face to an adjacent face.  The order of the permutation
#! is equal to the degree of the vertex. If the vertex named <M>i</M> is a 
#! boundary vertex, then the <M>i</M>-th entry in <A>umbdesc</A> is a list 
#! consisting of the faces in the umbrella path of the vertex such that 
#! adjacent faces are consecutive and the two faces with boundary edges 
#! are the first and the  last entry of the list. The length of the list is 
#! equal to the degree of the vertex.
#! @EndChunk 
#!
#! @BeginGroup
#! @Description
#!  Let <A>surf</A> be a simplicial surface. This method returns an
#!  umbrella descriptor of <A>surf</A>, where
#! @InsertChunk Documentation_UmbrellaDescriptor
#!
#! As an example consider the following net of a simplicial surface.
#! Note that the surface has boundary edges. Moreover, the vertices 
#! 1,2,3, and 4 are inner vertices, while 5,6,7,8,9, and 10 are not.
#! Accordingly, the umbrella descriptor of the surface will consist of
#! cyclic permutations for the vertices 1,2,3, and 4 and of lists for
#! the remaining vertices.
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-16-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-16.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> surf := SimplicialSurfaceByVerticesInFaces( [ [ 1, 2, 5 ], [ 1, 3, 5 ],
#! >      [ 1, 3, 6 ], [ 1, 4, 6 ], [ 1, 4, 7 ], [ 1, 2, 7 ], [ 2, 7, 8 ], 
#! >      [ 2, 5, 8 ], [ 3, 5, 9 ], [ 3, 6, 9 ], [ 4, 6, 10 ], [ 4, 7, 10 ] ]);;
#! gap> UmbrellaDescriptorOfSurface(surf);
#! [ (1,2,3,4,5,6), (1,8,7,6), (2,9,10,3), (4,11,12,5), [ 8, 1, 2, 9 ],
#!  [ 10, 3, 4, 11 ], [ 7, 6, 5, 12 ], [ 8, 7 ], [ 9, 10 ], [ 11, 12 ] ]
#! @EndExampleSession
#! @Returns a list 
#! @Arguments surface 
DeclareOperation( "UmbrellaDescriptorOfSurface", [IsSimplicialSurface] );
#! @EndGroup
#
#! @BeginChunk Documentation_UmbrellaTipDescriptor
#! an umbrella tip descriptor of a simplicial surface is a list <A>umbtipdesc</A>, 
#! describing a simplicial surface.  The bound entries in <A>umbtipdesc</A> are
#! cyclic permutations or lists of integers. The set of vertices of the surface
#! is the set of points which either are moved by a cyclic permutation or 
#! occur in a list in <A>umbtipdesc</A>. The edges of the surface correspond to
#! pairs of vertices <M>(i,j)</M>, where <M>i</M> is the bound position of a cycle or list 
#! in <A>umbtipdesc</A> and <M>j</M> is a vertex that is moved by that cycle or in that list
#! with position <M>i</M> in <A>umbtipdesc</A>.
#! The faces correspond to tuples of vertices <M>(i,j,k)</M>, where <M>i</M> is the bound position 
#! in <A>umbtipdesc</A> of a cycle or list and either that cycle maps <M>j</M> to <M>k</M>
#! or <M>j</M> and <M>k</M> occur in that list as neighbours.
#! The vertices of the surface can also be described as the positive integers
#! corresponding to the bound positions of <A>umbtipdesc</A>.
#! If position <M>i</M> of <A>umbtipdesc</A> is bound, then the 
#! <M>i</M>-th entry represents the vertex with name <M>i</M>.  
#! An umbrella tip path of a vertex is the umbrella path of a vertex, but instead
#! of an edge-face path, one obtains the outer vertices of that edge path.  If the vertex 
#! named <M>i</M> is inner, then the <M>i</M>-th entry in <A>umbtipdesc</A> 
#! is a cyclic permutation of the vertices in the umbrella tip path around the 
#! vertex, mapping a vertex to an adjacent vertex.  The order of the permutation
#! is equal to the vertex- and edge-degree of the vertex. If the vertex named <M>i</M> is a 
#! boundary vertex, then the <M>i</M>-th entry in <A>umbtipdesc</A> is a list 
#! consisting of the vertices in the umbrella tip path of the vertex such that 
#! adjacent vertices are consecutive and the two vertices with boundary edges 
#! are the first and the  last entry of the list. The length of the list is 
#! equal to the vertex- and edge-degree of the vertex.
#! @EndChunk 
#!
#! @BeginGroup
#! @Description
#! Let <A>surf</A> be a vertex faithful simplicial surface. This method returns an umbrella tip descriptor
#! of <A>surf</A>, where
#! @InsertChunk Documentation_UmbrellaTipDescriptor
#! 
#! As an example consider the following net of a simplicial surface.
#! Note that the surface has boundary edges. Moreover, the vertices 
#! 1,2,3, and 4 are inner vertices, while 5,6,7,8,9, and 10 are not.
#! Accordingly, the umbrella tip descriptor of the surface will consist of
#! cyclic permutations for the vertices 1,2,3, and 4 and of lists for
#! the remaining vertices.
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-17-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-17.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> surf := SimplicialSurfaceByVerticesInFaces( [ [ 1, 2, 5 ], [ 1, 3, 5 ],
#! >      [ 1, 3, 6 ], [ 1, 4, 6 ], [ 1, 4, 7 ], [ 1, 2, 7 ], [ 2, 7, 8 ], 
#! >      [ 2, 5, 8 ], [ 3, 5, 9 ], [ 3, 6, 9 ], [ 4, 6, 10 ], [ 4, 7, 10 ] ]);;
#! gap> UmbrellaTipDescriptorOfSurface(surf);
#! [ (2,5,3,6,4,7), (1,5,8,7), (1,5,9,6), (1,6,10,7), [ 8, 2, 1, 3, 9 ], 
#!  [ 9, 3, 1, 4, 10 ], [ 8, 2, 1, 4, 10 ], [ 5, 2, 7 ], [ 5, 3, 6 ], 
#!  [ 6, 4, 7 ] ]
#! @EndExampleSession
#! @Returns a list 
#! @Arguments surface 
DeclareOperation( "UmbrellaTipDescriptorOfSurface", [IsSimplicialSurface] );
#! @EndGroup
#
#! @BeginGroup
#! @Description
#! This method takes as input a list <A>umbdesc</A>, which is an
#! umbrella descriptor of a simplicial surface, see
#! (<Ref Sect="Section_Constructors_Umbrellas"/>).
#! If the list  <A>umbdesc</A> is the umbrella descriptor of a surface 
#! <A>surf</A>, the method returns <A>surf</A>. Otherwise it returns 
#! <A>false</A>.
#!  
#!
#!
#! As an example consider the following net of a simplicial surface.
#! Note that the surface has boundary edges. Moreover, the vertices 
#! 1,2,3, and 4 are inner vertices, while 5,6,7,8,9, and 10 are not.
#! Accordingly, the umbrella descriptor of the surface will consist of
#! cyclic permutations for the vertices 1,2,3, and 4 and of lists for
#! the remaining vertices, namely the umbrella descriptor is:
#! [ (1,2,3,4,5,6), (1,8,7,6), (2,9,10,3), (4,11,12,5), [8,1,2,9],
#! [10,3,4,11], [7,6,5,12], [8,7], [9,10], [11,12] ].
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-18-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-18.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> surf := SimplicialSurfaceByUmbrellaDescriptor( 
#! > [ (1,2,3,4,5,6), (1,8,7,6), (2,9,10,3), (4,11,12,5), [ 8, 1, 2, 9 ],
#! >  [ 10, 3, 4, 11 ], [ 7, 6, 5, 12 ], [ 8, 7 ], [ 9, 10 ], [ 11, 12 ] ]);
#! simplicial surface (10 vertices, 21 edges, and 12 faces)
#! gap> NumberOfFaces(surf);
#! 12
#! gap>  Vertices(surf);
#! [ 1 .. 10 ]
#! gap> NumberOfEdges(surf);
#! 21
#! gap> Faces(surf);
#! [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]
#! gap> EulerCharacteristic(surf);
#! 1
#! gap> IsClosedSurface(surf);
#! false
#! @EndExampleSession
#! @Returns a simplicial surface
#! @Arguments surface 
DeclareOperation( "SimplicialSurfaceByUmbrellaDescriptor", [IsList] );
#! @EndGroup
#!
#!
#! @BeginGroup
#! @Description
#!  A normed umbrella descriptor is a special umbrella descriptor of a
#!  surface, where an umbrella descriptor is described in 
#! (<Ref Sect="Section_Constructors_Umbrellas"/>).
#!  The normed umbrella descriptor of a given umbrella descriptor <A>umdesc</A>
#!  for the face <A>face</A> and an optional list of neighbours <A>neighbours</A> 
#!  of <A>face</A>  is an umbrella descriptor <A>normedumdesc</A> for an 
#!  isomorphic surface. This new surface is obtained from the original surface
#!  described by <A>umdesc</A> by a renumbering <A>f</A> of the faces, where
#!  <A>f</A> is a bijection from the faces of the original surface  to
#!  [1,..,<M>n</M>], where <M>n</M> is the number of faces. This renumbering
#!  is initialised follows:   <A>f(face) = 1</A>. The neighbours 
#!  of <A>face</A> are assigned the numbers 2, 3, ... If the optional 
#!  argument <A>neighbours</A> is present, it must be a subset of the neighbours
#!  of <A>face</A>  and <A>f(neighbours[i]) = i+1</A>  and <A>f(F)=infty</A> for
#!  all other faces <A>F</A>. Next the umbrellas of the original surface 
#!  are sorted  lexicographically, that is umbrella <A>u</A> is
#!  less than umbrella <A>v</A> if the image <A>f(u)</A>  is lexicographically 
#!  less that <A>f(v)</A>  as dihedral sequences. Each step takes the
#!  lexicographically least umbrella <A>u</A> still containing a face <A>F</A>
#!  for which <A>f(F)=infty</A> and renumbers each  such face in the umbrella
#!  consecutively in the order in which they occur in  <A>u</A> with
#!  numbers in [1,..,<M>n</M>] not yet used, that is <A>f(F)=j</A> for some <A>j</A> 
#!  in [1,..,<M>n</M>]. 
#!
#!   Consider the surface on 10 faces consisting of exactly two inner vertices
#!   of degree 5 and having vertex counter $v_2^6v_3^2v_5^2.$ Its umbrella
#!   descriptor is given in the example below. 
#!   We initialise renumbering of the faces such that <A>f(3)=1</A>  and the
#!   neighbours of 3, namely 2, 4, and 11  such that <A>f(2)=2</A>,
#!   <A>f(4)=3</A>  and <A>f(11)=4,</A> and <A>f(F) = infty</A> for the
#!   faces <A>F</A> in [1,5,6,7,8,10]. The 
#!   lexicographically least umbrella is the umbrella containing the faces
#!   with new numbers 1, 2, and 3. This is the umbrella 
#!   <A>u=(2,3,4,10,6,8)=(3,4,10,6,8,2)</A> as 
#!   <A>f(u) = (1,2,infty,infty,infty,3)</A>. We rename the three face numbers
#!   10, 6, 8 mapped to infty with the smallest consecutive numbers in 
#!   [1..10] not yet used. Thus we set <A>f(10)=5</A>, <A>f(6)=6</A>, 
#!   <A>f(8)=7</A>, that is we rename faces 8, 6 and 10 in this umbrella to 
#!   5, 6, and 7. The lexicographically least umbrella whose image under 
#!   <A>f</A> contains infty is <A>v = (1,5,2,3,11,7) = (3,2,5,1,7,11)</A> as
#!   <A>f(v) = (1,2,infty,infty,infty,4)</A>.  Thus we renumber the faces 
#!   5, 1, and 7 to  8, 9, 10. This defines <A>f</A> on all faces and  yields 
#!   the normed umbrella descriptor:
#!
#! @BeginExampleSession
#! gap>  ud := [ (1,5,2,3,11,7), (2,3,4,10,6,8),
#! >   [ 4, 3, 11 ], [ 5, 2, 8 ], [ 1, 5 ], [ 1, 7 ], [ 7, 11 ], 
#! >   [ 4, 10 ], [ 6, 10 ], [ 6, 8 ] ];;
#! gap>  nud := NormedUmbrellaDescriptor( ud, 3, [2,4,11]);
#! [ [ 3, 1, 4 ], (1,2,5,6,7,3), (1,2,8,9,10,4), [ 3, 7 ], [ 4, 10 ], 
#!  [ 5, 2, 8 ], [ 5, 6 ], [ 6, 7 ], [ 8, 9 ], [ 9, 10 ] ]
#! @EndExampleSession
#!
#!   The original surface is depicted on the left, the surface of the normed umbrella
#!   descriptor is depicted on the right.
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_constructors-19-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_constructors-19.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#!
#! As an example consider the following umbrella descriptor of a simplicial surface
#! on 18 faces.
#! @BeginExampleSession
#! gap> ud1 := [ (4,21,20,25), (5,7,8,6), (5,9,10,6), (7,11,12,8), (5,9,13,14,11,7), 
#! > (6,10,15,16,12,8), (9,13,17,21,20,15,10), (4,25,16,12,11,14,18),
#! > (13,17,18,14), (15,16,25,20), (4,21,17,18) ];;
#! gap> surf1 := SimplicialSurfaceByUmbrellaDescriptor(ud1);;
#! gap> ud2 := NormedUmbrellaDescriptor(ud1, 7, [11, 8, 5]);
#! [ (1,2,5,3), (1,2,6,7,8,4), (1,3,9,4), (2,5,10,11,12,13,6), (3,5,10,14,15,9),
#!   (4,8,15,9), (6,7,16,13), (7,8,15,14,17,18,16), 
#!   (10,11,17,14), (11,12,18,17), (12,13,16,18) ]
#! gap>  surf2 := SimplicialSurfaceByUmbrellaDescriptor(ud2);;
#! gap> IsIsomorphic(surf1,surf2);
#! true
#! @EndExampleSession
#! Note that this function can also be applied to umbrella descriptors of surfaces
#! which are not closed.
#! @BeginExampleSession
#! gap> ud1 := [ (1,2,3,4,5), (1,8,7,6,5), (1,8,19,20,9,2), (2,9,10,11,3), 
#! >  (3,11,12,13,4), (4,13,14,15,6,5), (6,15,16,17,7), (7,17,18,19,8),
#! > [ 10, 9, 20 ], [ 10, 11, 12 ], [ 12, 13, 14 ],
#! > [ 14, 15, 16 ], [ 16, 17, 18 ], [ 18, 19, 20 ] ];;
#! gap> surf1 := SimplicialSurfaceByUmbrellaDescriptor(ud1);;
#! gap> ud2 := NormedUmbrellaDescriptor(ud1, 1, [2, 5, 8]);
#! [ (1,2,5,6,3), (1,2,7,8,9,4), (1,3,10,11,4), (2,5,12,13,7), (3,6,14,15,16,10),
#!   (4,9,17,18,11),   (5,6,14,19,12), [ 8, 7, 13 ], [ 8, 9, 17 ], (10,11,18,20,16),
#!   [ 13, 12, 19 ],    [ 15, 14, 19 ], [ 15, 16, 20 ], [ 17, 18, 20 ] ]
#! gap>  surf2 := SimplicialSurfaceByUmbrellaDescriptor(ud2);;
#! gap> IsIsomorphic(surf1,surf2);
#! true
#! @EndExampleSession
#! @Returns a list 
#! @Arguments umbrelladescriptor, face 
DeclareOperation( "NormedUmbrellaDescriptor",[IsList,IsPosInt]);
#! @Arguments umbrelladescriptor, face, neighbours
DeclareOperation( "NormedUmbrellaDescriptor",[IsList,IsPosInt,IsList]);
#! @EndGroup


#! @BeginGroup
#! @Description
#!  Suppose that <A>umdesc</A> is a valid umbrella descriptor of a surface
#!  <M>S</M>, see (<Ref Sect="Section_Constructors_Umbrellas"/>).
#!   The degree sequence of <A>umdesc</A>
#!  is a list <E>degseq</E>. If the <M>i</M>-th entry of <A>umdesc</A> is
#!  bound, then this entry corresponds to a vertex of <M>S</M>  and 
#!  the <M>i</M>-th entry of <A>degseq</A> is a list <M>[d,b]</M>, where
#!  <M>d</M>  is the degree of the <M>i</M>-th vertex,  and the boolean
#!  <M>b</M> is  true, if the <M>i</M>-th vertex is inner and false else.
#!
#! @BeginExampleSession
#! gap> vf := [ [ 1, 3, 4 ], [ 1, 2, 4 ], [ 2, 4, 5 ], [ 2, 5, 6 ],
#!> [ 1, 2, 6 ], [ 1, 6, 7 ], [ 1, 7, 8 ], [ 1, 3, 8 ], [ 3, 4, 9 ],
#!> [ 4, 9, 10 ], [ 4, 5, 10 ], [ 5, 10, 11 ], [ 5, 6, 11 ], [ 6, 11, 12 ],
#!> [ 6, 7, 12 ], [ 7, 12, 13 ], [ 7, 8, 13 ], [ 8, 13, 14 ], [ 3, 8, 14 ],
#!> [ 3, 9, 14 ] ];;
#! gap> surf := SimplicialSurfaceByVerticesInFaces(vf);
#! simplicial surface (14 vertices, 33 edges, and 20 faces)
#! gap> ud := UmbrellaDescriptorOfSurface(surf);
#! [ (1,8,7,6,5,2), (2,3,4,5), (1,9,20,19,8), (1,9,10,11,3,2), (3,11,12,13,4), 
#!   (4,13,14,15,6,5), (6,15,16,17,7), (7,17,18,19,8), [ 10, 9, 20 ], 
#!   [ 10, 11, 12 ], [ 12, 13, 14 ], [ 14, 15, 16 ], [ 16, 17, 18 ], 
#!   [ 20, 19, 18 ] ]
#! gap> DegreeSequenceOfUmbrellaDescriptor(ud);
#! [ [ 6, true ], [ 4, true ], [ 5, true ], [ 6, true ], [ 5, true ], 
#!   [ 6, true ], [ 5, true ], [ 5, true ], [ 3, false ], [ 3, false ], 
#!   [ 3, false ], [ 3, false ], [ 3, false ], [ 3, false ] ]
#! @EndExampleSession
#!
#! @Returns a list 
#! @Arguments umbdesc
DeclareOperation( "DegreeSequenceOfUmbrellaDescriptor",[IsList]);
#! @EndGroup

#! @BeginGroup
#! @Description
#!  Given a DegreeSequence of a normed UmbrellaDescriptor for a closed
#!  simplicial surface which has no vertices of degree 2, this function
#!  returns the umbrella descriptors of all simplicial surfaces which
#!  have a normed umbrella descriptor  matching this degree sequence.

#!
#! @BeginExampleSession
#! gap> ud :=
#! > [ (1,6,16,5), (1,6,15,4), (2,21,22,3), (9,11,12,10), (11,17,18,12), 
#! >  (7,9,10,8), (7,13,14,8), (1,4,2,3,5), (17,23,21,22,24,18), 
#! >  (3,22,24,20,16,5), (2,21,23,19,15,4), (6,16,20,14,13,19,15), 
#! >  (7,13,19,23,17,11,9), (8,14,20,24,18,12,10) ];;
#! gap> surf := SimplicialSurfaceByUmbrellaDescriptor( ud );
#! simplicial surface (14 vertices, 36 edges, and 24 faces)
#! gap> nud := NormedUmbrellaDescriptor(ud, 1 );
#! [ (1,2,5,6,3), (1,2,7,4), (1,3,8,4), (2,5,9,10,11,7), (3,6,12,13,14,8), 
#!   (4,7,11,15,16,14,8), (5,6,12,9), (9,10,17,18,13,12), 
#!   (10,11,15,19,20,21,17), (13,14,16,22,23,24,18), (15,16,22,19), 
#!   (17,18,24,21), (19,20,23,22), (20,21,24,23) ]
#! gap> ds := DegreeSequenceOfUmbrellaDescriptor(nud);
#! [ [ 5, true ], [ 4, true ], [ 4, true ], [ 6, true ], [ 6, true ], 
#!   [ 7, true ], [ 4, true ], [ 6, true ], [ 7, true ], [ 7, true ], 
#!   [ 4, true ], [ 4, true ], [ 4, true ], [ 4, true ] ]
#! gap> AllUmbrellaDescriptorsOfDegreeSequence( ds );
#! [ [ (1,2,5,6,3), (1,2,7,4), (1,3,8,4), (2,5,9,10,11,7), (3,6,12,13,14,8), 
#!       (4,7,11,15,16,14,8), (5,6,12,9), (9,10,17,18,13,12), 
#!       (10,11,15,19,20,21,17), (13,14,16,22,23,24,18), (15,16,22,19), 
#!       (17,18,24,21), (19,20,23,22), (20,21,24,23) ] ]
#! @EndExampleSession
#!
#! @Returns a list 
#! @Arguments degreeseq
DeclareOperation( "AllUmbrellaDescriptorsOfDegreeSequence",[IsList]);
#! @EndGroup


#! @Section Constructing surfaces via their Dress Group 
#!
#! In some constructions a surface may arrise from the knowledge
#! of its Dress Group, see Section <Ref Sect="Section_Flags_DressGroup"/>.
#! In this case, the surface can be reconstructed from its Dress group
#! <M>D = \langle \theta_0, \theta_1, \theta_2\rangle</M> by computing the
#! orbits of the dihedral subgroups
#! <M>D_0 = \langle \theta_1, \theta_2\rangle</M>,
#! <M>D_1 = \langle \theta_0, \theta_2\rangle</M>,
#! <M>D_2 = \langle \theta_0, \theta_1\rangle</M>,
#! where $\theta_0, \theta_1, \theta_2$ are the  Dress Involutions, 
#! see <Ref Subsect="DressInvolutions"/>. In particular, 
#! the vertices correspond to the orbits of <M>D_0</M>,
#! the edges correspond to the orbits of <M>D_1</M>,
#! the faces correspond to the orbits of <M>D_2</M>, and
#! incidence is given by non-empty set-intersection.
#!
#! @SectionLabel Constructors_DressGroup
#!
#! @BeginGroup
#! @Description
#! This method takes as input a permutation group <A>dress</A>,  and tests,
#! whether <A>dress</A> is the Dress Group of a simplicial surface <A>surf</A>,
#! see Section <Ref Sect="Section_Flags_DressGroup"/>.
#! If this is the case, <A>surf</A> is constructed and returned. 
#!
#! @BeginExampleSession
#! gap> tet := Tetrahedron();;
#! gap> dress := DressGroup(tet);
#! Group([(1,7)(2,8)(3,13)(4,14)(5,19)(6,20)(9,15)(10,16)(11,21)(12,22)(17,23)(18,24), 
#!   (1,3)(2,5)(4,6)(7,9)(8,11)(10,12)(13,15)(14,18)(16,17)(19,21)(20,24)(22,23), 
#!   (1,2)(3,4)(5,6)(7,8)(9,10)(11,12)(13,14)(15,16)(17,18)(19,20)(21,22)(23,24) ])
#! gap> surf  := SimplicialSurfaceByDressGroup(dress);
#! simplicial surface (4 vertices, 6 edges, and 4 faces)
#! gap>  IsIsomorphic(surf, tet);
#! true
#! @EndExampleSession
#!
#! If the permutation group <A>dress</A> passed as an argument does not
#! satisfy the conditions of being a dress group of a surface, 
#! <A>false</A> is returned.
#! @BeginExampleSession
#! gap> SetInfoLevel(InfoSimplicial,3);
#! gap> grp:=Group([(1,2)(3,4)(5,6)(7,8),(1,2)(3,5)(4,7)(6,8),(1,3)(2,4)(5,7)(6,8)]);  
#! Group([ (1,2)(3,4)(5,6)(7,8), (1,2)(3,5)(4,7)(6,8), (1,3)(2,4)(5,7)(6,8) ])
#! gap> SimplicialSurfaceByDressGroup(grp);
#! #I  the dress relations are not satisfied.
#! false
#! gap> gens := [ ( 1, 6)( 2, 5)( 3, 4)( 7,12)( 8,11)( 9,10), 
#! >   ( 1, 8)( 2, 7)( 3,12)( 4, 5)( 6, 9)(10,11), 
#! >   ( 1,12)( 2,11)( 3,10)( 4, 9)( 5, 8)( 6, 7) ];
#! [ (1,6)(2,5)(3,4)(7,12)(8,11)(9,10), (1,8)(2,7)(3,12)(4,5)(6,9)(10,11), 
#!  (1,12)(2,11)(3,10)(4,9)(5,8)(6,7) ]
#! gap> SimplicialSurfaceByDressGroup(Group(gens));
#! #I  Faces and vertices can have only 2 common flags
#! false
#! @EndExampleSession
#! @Returns a simplicial surface or false 
#! @Arguments dress
DeclareOperation( "SimplicialSurfaceByDressGroup",[IsPermGroup]);
#! @EndGroup

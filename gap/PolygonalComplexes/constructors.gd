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
#! All general constructors are structured like [Type]By[Method](args), e.g.
#! * <K>PolygonalComplexByDownwardIncidence</K>( <A>verticesOfEdges</A>, <A>edgesOfFaces</A> )
# * <K>SimplicialSurfaceByUmbrellas</K>( <A>edgeFacePaths</A> )
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
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle, face/.default=\faceColorFirst]
#!     \input{Image_ConstructorExample.tex}
#!   \end{tikzpicture}
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
#! information is checked for compatibility with them. This is not strictly 
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
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle, face/.default=\faceColorFirst]
#!          \input{Image_Constructor_PolygonalComplex.tex}
#!      \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle,face/.default=\faceColorFirst]
#!          \input{Image_Constructor_PolygonalSurface.tex}
#!      \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle, face/.default=\faceColorFirst]
#!          \input{Image_Constructor_TriangularComplex.tex}
#!      \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle,face/.default=\faceColorFirst]
#!          \input{Image_Constructor_SimplicialSurface.tex}
#!      \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle, face/.default=\faceColorSecond]
#!     \input{Image_ConstructorExample.tex}
#!   \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle, face/.default=\faceColorSecond]
#!          \input{Image_Constructor_PolygonalComplex.tex}
#!      \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle,face/.default=\faceColorSecond]
#!          \input{Image_Constructor_PolygonalSurface.tex}
#!      \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle, face/.default=\faceColorSecond]
#!          \input{Image_Constructor_TriangularComplex.tex}
#!      \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle, face/.default=\faceColorSecond]
#!          \input{Image_Constructor_SimplicialSurface.tex}
#!      \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle, face/.default=\faceColorThird]
#!     \input{Image_ConstructorExample.tex}
#!   \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle=nolabels,faceStyle, face/.default=\faceColorThird]
#!          \input{Image_Constructor_PolygonalComplex.tex}
#!      \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle=nolabels,faceStyle,face/.default=\faceColorThird]
#!          \input{Image_Constructor_PolygonalSurface.tex}
#!      \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle=nolabels,faceStyle, face/.default=\faceColorThird]
#!          \input{Image_Constructor_TriangularComplex.tex}
#!      \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle=nolabels,faceStyle, face/.default=\faceColorThird]
#!          \input{Image_Constructor_SimplicialSurface.tex}
#!      \end{tikzpicture}
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

#! @Section UmbrellaDescriptor 
#! @SectionLabel UmbrellaDescriptor
#!
#! @BeginChunk Documentation_UmbrellaDescriptor
#! an umbrella descriptor of a simplicial surface a list <A>umbdesc</A>, 
#! describing the vertices of the surface such that the vertices are the 
#! positive integers corresponding to the bound positions of <A>umbdesc</A>.
#! If position <M>i</M> of <A>umbdesc</A> is bound, then the 
#! <M>i</M>-th entry represents the vertex <M>i</M>. 
#! If vertex <M>i</M> is inner,  then the <M>i</M>-th entry in <A>umbdesc</A> 
#! is a cyclic permutation of the faces in the umbrella path around the 
#! vertex, mapping a face to an adjacent face.  The order of the permutation
#!  is equal to the degree of the vertex. If vertex <M>i</M> is a 
#! boundary vertex, then the <M>i</M>-th entry in <A>umbdesc</A> is a list 
#! consisting of the faces in the umbrella path of the vertex such that 
#! adjacent faces are consecutive and the two faces with boundary edges 
#! are the first and the  last entry of the list. The length of the list is 
#! equal to the degree of the vertex.
#! @EndChunk 
#!
#! @BeginGroup
#! @Description
#!  Let <A>surf</A> be a simplicial surface. This method returns a list 
#!  <A>umbdesc</A> of length equal to the number of vertices of <A>surf</A>. 
#!  The list <A>umbdesc</A> is an umbrella descriptor of <A>surf</A>, where
#! @InsertChunk Documentation_UmbrellaDescriptor
#!
#! As an example consider the following net of a simplicial surface.
#! Note that the surface has boundary edges. Moreover, the vertices 
#! 1,2,3, and 4 are inner vertices, while 5,6,7,8,9, and 10 are not.
#! Accordingly, the umbrella descriptor of the surface will consist of
#! cyclic permutations for the vertices 1,2,3, and 4 and of lists for
#! the remaining vertices.
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle, face/.default=\faceColorSecond,scale=1.5]
#!          \input{Image_Constructor_Umbrella.tex}
#!      \end{tikzpicture}
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
#! @BeginGroup
#! @Description
#! This method takes as input a list <A>umbdesc</A>, which is an
#! umbrella descriptor of a simplicial surface, where
#! @InsertChunk Documentation_UmbrellaDescriptor
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
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle, face/.default=\faceColorSecond,scale=1.5]
#!          \input{Image_Constructor_Umbrella.tex}
#!      \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> surf := SimplicialSurfaceByUmbrellaDescriptor( 
#! > [ (1,2,3,4,5,6), (1,8,7,6), (2,9,10,3), (4,11,12,5), [ 8, 1, 2, 9 ],
#! >  [ 10, 3, 4, 11 ], [ 7, 6, 5, 12 ], [ 8, 7 ], [ 9, 10 ], [ 11, 12 ] ]);
#! simplicial surface (10 vertices, 21 edges, and 12 faces)
#! gap> NumberOfFaces(surf);
#! 12
#! gap>  Vertices(surf);
#! [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
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

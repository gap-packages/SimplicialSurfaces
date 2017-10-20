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
## To keep a skimming readers attention we will do a different surface example
## for each documentation group. Ideally they will epitomize different types
## of structures that might appear.
#######

#! This package offers three different ways to construct a polygonal complex
#! "from scratch":
#! * Choose from a few standard example (like platonic solids) in section
#!   <Ref Sect="Section_Constructors_Examples"/>.
#! * Define it directly by its incidence structure (this will be the main
#!   content of this chapter)
#! * Use the surface database to find appropriate complexes. This will be 
#!   handled in chapter TODO
#!
#! As the list of some small standard examples in section
#! <Ref Sect="Section_Constructors_Examples"/>
#! does not warrant much 
#! explanation (except noting that all platonic solids are implemented), we will
#! now explain the structure of the more general constructors.
#! 
#! All general constructors are structured like [Type]By[Method](args), e.g.
#! * <K>PolygonalComplexByDownwardIncidence</K>( <A>verticesOfEdges</A>, <A>edgesOfFaces</A> )
#! * <K>SimplicialSurfaceByEdgeFacePaths</K>( <A>edgeFacePaths</A> )
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
#! * <E>EdgeFacePaths</E>
#!   (<Ref Sect="Section_Constructors_EdgeFacePaths"/>):
#!   <K>EdgeFacePathsOfVertices</K> (<Ref Subsect="EdgeFacePathSingle"/>)
#!

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

#TODO 6 examples for the constructors (to showcase how each method
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
#! TODO example
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
#! This method constructs a ramified polygonal surface
#! (<Ref Sect="PolygonalStructures_ramified"/>)
#! @InsertChunk Documentation_DownwardIncidence
#!
#! TODO example
#! @Returns a ramified polygonal surface
#! @Arguments verticesOfEdges, edgesOfFaces
DeclareOperation( "RamifiedPolygonalSurfaceByDownwardIncidence", [IsList, IsList] );
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces
DeclareOperation( "RamifiedPolygonalSurfaceByDownwardIncidence", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @Arguments verticesOfEdges, edgesOfFaces
DeclareOperation( "RamifiedPolygonalSurfaceByDownwardIncidenceNC", [IsList, IsList] );
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces
DeclareOperation( "RamifiedPolygonalSurfaceByDownwardIncidenceNC", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! This method constructs a polygonal surface
#! (<Ref Sect="PolygonalStructures_surface"/>)
#! @InsertChunk Documentation_DownwardIncidence
#!
#! TODO example
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
#! TODO example
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
#! This method constructs a ramified simplicial surface
#! (<Ref Sect="PolygonalStructures_ramified"/>)
#! @InsertChunk Documentation_DownwardIncidence
#!
#! TODO example
#! @Returns a ramified simplicial surface
#! @Arguments verticesOfEdges, edgesOfFaces
DeclareOperation( "RamifiedSimplicialSurfaceByDownwardIncidence", [IsList, IsList] );
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces
DeclareOperation( "RamifiedSimplicialSurfaceByDownwardIncidence", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @Arguments verticesOfEdges, edgesOfFaces
DeclareOperation( "RamifiedSimplicialSurfaceByDownwardIncidenceNC", [IsList, IsList] );
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces
DeclareOperation( "RamifiedSimplicialSurfaceByDownwardIncidenceNC", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! This method constructs a simplicial surface
#! (<Ref Sect="PolygonalStructures_surface"/>)
#! @InsertChunk Documentation_DownwardIncidence
#!
#! TODO example
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
#! TODO example
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
#! This method constructs a ramified polygonal surface
#! (<Ref Sect="PolygonalStructures_ramified"/>)
#! @InsertChunk Documentation_UpwardIncidence
#!
#! TODO example
#! @Returns a ramified polygonal surface
#! @Arguments edgesOfVertices, facesOfEdges
DeclareOperation( "RamifiedPolygonalSurfaceByUpwardIncidence", [IsList, IsList] );
#! @Arguments vertices, edges, faces, edgesOfVertices, facesOfEdges
DeclareOperation( "RamifiedPolygonalSurfaceByUpwardIncidence", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @Arguments edgesOfVertices, facesOfEdges
DeclareOperation( "RamifiedPolygonalSurfaceByUpwardIncidenceNC", [IsList, IsList] );
#! @Arguments vertices, edges, faces, edgesOfVertices, facesOfEdges
DeclareOperation( "RamifiedPolygonalSurfaceByUpwardIncidenceNC", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! This method constructs a polygonal surface
#! (<Ref Sect="PolygonalStructures_surface"/>)
#! @InsertChunk Documentation_UpwardIncidence
#!
#! TODO example
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
#! TODO example
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
#! This method constructs a ramified simplicial surface
#! (<Ref Sect="PolygonalStructures_ramified"/>)
#! @InsertChunk Documentation_UpwardIncidence
#!
#! TODO example
#! @Returns a ramified simplicial surface
#! @Arguments edgesOfVertices, facesOfEdges
DeclareOperation( "RamifiedSimplicialSurfaceByUpwardIncidence", [IsList, IsList] );
#! @Arguments vertices, edges, faces, edgesOfVertices, facesOfEdges
DeclareOperation( "RamifiedSimplicialSurfaceByUpwardIncidence", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @Arguments edgesOfVertices, facesOfEdges
DeclareOperation( "RamifiedSimplicialSurfaceByUpwardIncidenceNC", [IsList, IsList] );
#! @Arguments vertices, edges, faces, edgesOfVertices, facesOfEdges
DeclareOperation( "RamifiedSimplicialSurfaceByUpwardIncidenceNC", [IsSet, IsSet, IsSet, IsList, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! This method constructs a simplicial surface
#! (<Ref Sect="PolygonalStructures_surface"/>)
#! @InsertChunk Documentation_UpwardIncidence
#!
#! TODO example
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
#! the attribute <K>CyclicVertexOrderOfFacesAsList</K> 
#! (<Ref Subsect="CyclicVertexOrderOfFacesAsList"/>) which generalizes
#! the attribute <K>VerticesOfFaces</K> (<Ref Subsect="VerticesOfFaces"/>) for
#! non-triangular faces. 
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
#! TODO
#! @EndChunk

#TODO explain how the edge numbers are choosen (such that VerticesOfEdges is a set);


#! @BeginGroup
#! @Description
#! This method constructs a polygonal complex 
#! (<Ref Sect="PolygonalStructures_complex"/>)
#! @InsertChunk Documentation_VerticesInFaces
#! 
#! TODO example
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
#! This method constructs a ramified polygonal surface
#! (<Ref Sect="PolygonalStructures_ramified"/>)
#! @InsertChunk Documentation_VerticesInFaces
#! 
#! TODO example
#! @Returns a ramified polygonal surface
#! @Arguments verticesInFaces
DeclareOperation( "RamifiedPolygonalSurfaceByVerticesInFaces", [IsList] );
#! @Arguments vertices, faces, verticesInFaces
DeclareOperation( "RamifiedPolygonalSurfaceByVerticesInFaces", [IsSet, IsSet, IsList] );
#! @Arguments verticesInFaces
DeclareOperation( "RamifiedPolygonalSurfaceByVerticesInFacesNC", [IsList] );
#! @Arguments vertices, faces, verticesInFaces
DeclareOperation( "RamifiedPolygonalSurfaceByVerticesInFacesNC", [IsSet, IsSet, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! This method constructs a polygonal surface
#! (<Ref Sect="PolygonalStructures_surface"/>)
#! @InsertChunk Documentation_VerticesInFaces
#! 
#! TODO example
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
#! This method constructs a triagonal complex 
#! (<Ref Sect="PolygonalStructures_complex"/>)
#! @InsertChunk Documentation_VerticesInFaces
#! 
#! TODO example
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
#! This method constructs a ramified simplicial surface
#! (<Ref Sect="PolygonalStructures_ramified"/>)
#! @InsertChunk Documentation_VerticesInFaces
#! 
#! TODO example
#! @Returns a ramified simplicial surface
#! @Arguments verticesInFaces
DeclareOperation( "RamifiedSimplicialSurfaceByVerticesInFaces", [IsList] );
#! @Arguments vertices, faces, verticesInFaces
DeclareOperation( "RamifiedSimplicialSurfaceByVerticesInFaces", [IsSet, IsSet, IsList] );
#! @Arguments verticesInFaces
DeclareOperation( "RamifiedSimplicialSurfaceByVerticesInFacesNC", [IsList] );
#! @Arguments vertices, faces, verticesInFaces
DeclareOperation( "RamifiedSimplicialSurfaceByVerticesInFacesNC", [IsSet, IsSet, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! This method constructs a simplicial surface
#! (<Ref Sect="PolygonalStructures_surface"/>)
#! @InsertChunk Documentation_VerticesInFaces
#! 
#! TODO example
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


##TODO print nets of the structures in the example section (made with DrawSurfaceToTikZ)
##TODO better name for this section
#! @Section Pre-defined structures
#! @SectionLabel Constructors_Examples
#! 
#! The previous sections explained how polygonal structures can be constructed
#! in general. As the usage of these methods is a bit inconvenient (they need
#! a lot of data) this section offers shortcuts for some common structures,
#! e.g. platonic solids.
#!
#! The example structures are ordered by their number of faces. Since it might
#! be useful to see the incidence at a glance, every one of those methods will
#! feature a net of the constructed polygonal structure (if possible). Those
#! nets are constructed by the method <K>DrawSurfaceToTikZ</K> 
#! (TODO reference).

#TODO should we do something more with the surfaces in the examples? Give some
# incidence relations?
#! @Description
#! Return a <E>Janus-Head</E> as a simplicial surface. A Janus-Head consists
#! of two triangular faces that share three edges.
#! 
#! TODO picture
#!
#! @ExampleSession
#! gap> janus := JanusHead();;
#! @EndExampleSession
#! 
#! TODO net
#! @Returns a simplicial surface
DeclareOperation( "JanusHead", [] );

#! @Description
#! Return a <E>tetrahedron</E> as a simplicial surface. A tetrahedron is the
#! platonic solid with four triangular faces. 
#! 
#! TODO picture
#!
#! @ExampleSession
#! gap> tetra := Tetrahedron();;
#! @EndExampleSession
#! 
#! TODO net
#! @Returns a simplicial surface
DeclareOperation( "Tetrahedron", [] );

#! @Description
#! Return a <E>cube</E> as a polygonal surface. A cube is the platonic
#! solid with six square faces.
#! 
#! TODO picture
#!
#! @ExampleSession
#! gap> cube := Cube();;
#! @EndExampleSession
#! 
#! TODO net
#! @Returns a polygonal surface
DeclareOperation( "Cube", [] );

#! @Description
#! Return an <E>octahedron</E> as a simplicial surface. An octahedron is the
#! platonic solid with eight triangular faces.
#! 
#! TODO picture
#!
#! @ExampleSession
#! gap> octa := Octahedron();;
#! @EndExampleSession
#! 
#! TODO net
#! @Returns a simplicial surface
DeclareOperation( "Octahedron", [] );


#! @Description
#! Return a <E>dodecahedron</E> as a polygonal surface. A dodecahedron ist the
#! platonic solid with 12 pentagon faces.
#! 
#! TODO picture
#!
#! @ExampleSession
#! gap> dode := Dodecahedron();;
#! @EndExampleSession
#! 
#! TODO net
#! @Returns a polygonal surface
DeclareOperation( "Dodecahedron", [] );

#! @Description
#! Return an <E>icosahedron</E> as a simplicial surface. An icosahedron is the
#! platonic solid with 20 triangular faces.
#! 
#! TODO picture
#!
#! @ExampleSession
#! gap> ico := Icosahedron();;
#! @EndExampleSession
#! 
#! TODO net
#! @Returns a simplicial surface
DeclareOperation( "Icosahedron", [] );

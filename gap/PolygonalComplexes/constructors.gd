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

#! @Chapter Constructing surfaces
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
#! * Choose from a few standard example (like platonic solids) in section TODO
#! * Define it directly by its incidence structure (this will be the main
#!   content of this chapter)
#! * Use the surface database to find appropriate complexes. This will be 
#!   handled in chapter TODO
#!
#! As the list of some small standard examples in section TODO 
#! does not warrant much 
#! explanation (except noting that all platonic solids are there), we will
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
#! As an example, consider the following polygonal surface:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle, face/.default=\faceColorFirst]
#!     \input{Image_ConstructorExample.tex};
#!   \end{tikzpicture}
#! </Alt>
#!
#! To use the constructor, we need the lists <K>VerticesOfEdges</K> and
#! <K>EdgesOfFaces</K>. For each edge there is an entry in 
#! <K>VerticesOfEdges</K> that consists of the incident vertices (as set).
#! @ExampleSession
#! gap> verticesOfEdges := [,[3,5],,,,[3,7],,[3,11],,[7,11],,[5,13],,[7,13],[11,13]];
#! [ , [ 3, 5 ], , , , [ 3, 7 ], , [ 3, 11 ], , [ 7, 11 ], , [ 5, 13 ], , [ 7, 13 ], [ 11, 13 ] ]
#! @EndExampleSession
#! Similarly the list <K>EdgesOfFaces</K> has an entry for each face with the
#! set of incident edges.
#! @ExampleSession
#! gap> edgesOfFaces := [ [3,5,7,13], , , [3,7,11], , , , , [7,11,13] ];
#! [ [ 3, 5, 7, 13 ], , , [ 3, 7, 11 ], , , , , [ 7, 11, 13 ] ]
#! @EndExampleSession
#! These lists are sufficient to reconstruct the polygonal surface.
#! @ExampleSession
#! gap> PolygonalSurfaceByDownwardIncidence( verticesOfEdges, edgesOfFaces );;
#! @EndExampleSession
#! 
#! These constructors also allow the optional arguments <A>vertices</A>,
#! <A>edges</A> and <A>faces</A>. If those sets are given, the incidence
#! information is checked for compatibility with them. This is very useful
#! in practice to notice typos in the incidence relations. It is also possible
#! to give a positive integer <A>n</A> - it will be converted into the list
#! <M>[1,...,n]</M>.
#! @ExampleSession
#! gap> PolygonalSurfaceByDownwardIncidence( [3,5,7,11,13], [2,6,8,10,12,14,15], 
#!      [1,4,9], verticesOfEdges, edgesOfFaces );;
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



#! @Section VerticesInFaces
#! @SectionLabel Constructors_VerticesInFaces
#!
#! The <E>VerticesInFaces</E>-constructors are based on
#! the attribute <K>VerticesOfFaces</K> (<Ref Subsect="VerticesOfFaces"/>)
#! and can construct any polygonal structure from chapter
#! <Ref Chap="PolygonalStructures"/>.
#!
#! This constructor is only based on the incidence relation between vertices
#! and faces. Since it takes no edge information, it has to construct the
#! edges in some way.
#! This is done according to two rules:
#! * An edge is uniquely identified by its incident vertices.
#! * If a face is given by the vertex list <M>[v_1, v_2, ..., v_k]</M> then
#!   adjacent vertices in the list are assumed to form an edge of the face
#!   (first and last vertex count as adjacent). In this case we would have the edges
#!   <M>[v_1,v_2]</M>, <M>[v_2,v_3]</M>, ..., <M>[v_k,v_1]</M>.
#!
#! Consider the following polygonal surface:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle, face/.default=\faceColorThird]
#!     \input{Image_ConstructorExample.tex};
#!   \end{tikzpicture}
#! </Alt>
#! To accurately transcribe this surface we need to know which vertices are
#! incident to which faces. This information is given as a list with an entry
#! for each face. The entry for a given face is a list of the incident 
#! vertices that allows reconstruction of the edges as specified above. In this
#! example the following list does the job:
#! @ExampleSession
#! gap> verticesInFaces := [ [3,5,13,7], , , [3,11,7], , , , , [7,11,13] ];
#! [ [ 3, 5, 13, 7 ], , , [ 3, 11, 7 ], , , , , [ 7, 11, 13 ] ]
#! @EndExampleSession
#! According to our rules, the list <M>[3, 5, 13, 7]</M> defines the four edges
#! <M>[3,5]</M>, <M>[5,13]</M>, <M>[7,13]</M> and <M>[3,7]</M> (like in the 
#! picture).
#!
#! Had we given the set <M>[3, 5, 7, 13]</M> we would have gotten different
#! edges - the method would believe that <M>[5,7]</M> is an edge although 
#! this is not the case in the surface we want to describe. Therefore the
#! order of the vertices in those lists is very important if the associated
#! face has more than three vertices.
#!
#! @ExampleSession
#! gap> PolygonalSurfaceByVerticesInFaces( verticesInFaces );;
#! @EndExampleSession
#! 
#! These constructors also allow the optional arguments <A>vertices</A>
#! and <A>faces</A>. If those sets are given, the incidence
#! information is checked for compatibility with them. This is very useful
#! in practice to notice typos in the incidence relations. It is also possible
#! to give a positive integer <A>n</A> - it will be converted into the list
#! <M>[1,...,n]</M>.
#! @ExampleSession
#! gap> PolygonalSurfaceByVerticesInFaces( [3,5,7,11,13], [1,4,9], verticesInFaces );;
#! @EndExampleSession
#! 

#! @BeginChunk Documentation_VerticesInFaces
#! TODO
#! @EndChunk


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


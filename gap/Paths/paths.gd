#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2018
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################


#! @Chapter Paths and orientations
#! @ChapterLabel Paths
#!
#! In sections 
#! <Ref Sect="Section_Access_OrderedFaceAccess"/> and 
#! <Ref Sect="Section_Access_OrderedVertexAccess"/> the concepts of 
#! vertex-edge-paths and 
#! edge-face-paths were introduced. This chapter documents which methods
#! are available for these paths (in sections 
#! <Ref Sect="Section_Paths_VertexEdge"/> and 
#! <Ref Sect="Section_Paths_EdgeFace"/>). Then it
#! discusses applications of these paths, namely connectivity 
#! (<Ref Sect="Section_Paths_Connectivity"/>) and
#! orientability (<Ref Sect="Section_Orientability"/>).


#! @Section Vertex-Edge-Paths
#! @SectionLabel Paths_VertexEdge
#!
#! This section describes all methods for vertex-edge-paths. Intuitively,
#! vertex-edge-paths describe all paths that are realized by walking only on
#! the vertices and edges of a (bend) polygonal complex.
#!
#! We will illustrate several properties with vertex-edge-paths that are
#! defined on this simplicial surface:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle,edgePlain,faceStyle]
#!     \input{Image_SixTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> hex := SimplicialSurfaceByDownwardIncidence( 
#! >      [ [1,7],[2,7],[3,7],[4,7],[5,7],[6,7],[1,2],[2,3],[3,4],[4,5],[5,6],[1,6] ],
#! >      [ [1,2,7],[2,3,8],[3,4,9],[4,5,10],[5,6,11],[1,6,12] ]);;
#! @EndExampleSession

#! @BeginChunk Definition_VertexEdgePath
#! A <E>vertex-edge-path</E> in a polygonal complex is a tuple
#! <M>(v_1, e_1, v_2, e_2, \ldots ,v_n, e_n, v_{{n+1}})</M> such that
#! * The <M>v_i</M> are vertices of the polygonal complex
#! * The <M>e_j</M> are edges of the polygonal complex
#! * For the edge <M>e_j</M> the set of incident vertices is <M>\{v_j,v_{{j+1}}}\}</M>
#! @EndChunk

#! <ManSection Label="VertexEdgePath">
#!   <Oper Name="VertexEdgePath" Arg="complex, path" 
#!      Label="for IsVEFComplex and IsDenseList"
#!      Comm="Construct a vertex-edge-path from a VEF-complex and a list"/>
#!   <Oper Name="VertexEdgePathNC" Arg="complex, path" 
#!      Label="for IsVEFComplex and IsDenseList"
#!      Comm="Construct a vertex-edge-path from a VEF-complex and a list"/>
#!   <Returns>A VertexEdgePath-&GAP;-object</Returns>
#!   <Filt Name="IsVertexEdgePath" Arg="object" Label="for IsObject" Type="category"
#!      Comm="Check whether a given object is a VertexEdgePath"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!     The method <K>VertexEdgePath</K> constructs a new vertex-edge-path from
#!     a VEF-complex and a dense list of positive integers (alternating
#!     vertices and edges). The
#!     method <K>IsVertexEdgePath</K> checks if a given &GAP;-object
#!     represents such a path.
#!
#!     We illustrate this with two paths on the simplicial surface that was
#!     introduced at the start of section 
#!     <Ref Sect="Section_Paths_VertexEdge"/>.
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_AlphaAndOmega.tex}
#!     </Alt>
#!     @ExampleSession
#! gap> alphaPath := VertexEdgePath(hex, [2,2,7,5,5,10,4,9,3,3,7,6,6]);
#! | v2, E2, v7, E5, v5, E10, v4, E9, v3, E3, v7, E6, v6 |
#! gap> omegaPath := VertexEdgePath(hex, [3,9,4,10,5,5,7,6,6,12,1,7,2]);
#! | v3, E9, v4, E10, v5, E5, v7, E6, v6, E12, v1, E7, v2 |
#!     @EndExampleSession
#!
#!     @InsertChunk Definition_VertexEdgePath
#!
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_CircleAndClover.tex}
#!     </Alt>
#!     @ExampleSession
#! gap> circlePath := VertexEdgePath( hex, [1,7,2,8,3,9,4,10,5,11,6,12,1] );
#! ( v1, E7, v2, E8, v3, E9, v4, E10, v5, E11, v6, E12, v1 )
#! gap> cloverPath := VertexEdgePath( hex, [1,7,2,2,7,5,5,11,6,6,7,3,3,9,4,4,7,1,1] );
#! ( v1, E7, v2, E2, v7, E5, v5, E11, v6, E6, v7, E3, v3, E9, v4, E4, v7, E1, v1 )
#!     @EndExampleSession
#!
#!     The elements of a vertex-edge-path can be accessed by using the methods
#!     <K>PathAsList</K> (<Ref Subsect="VertexEdge_PathAsList"/>), 
#!     <K>VerticesAsList</K> (<Ref Subsect="VertexEdge_VerticesAsList"/>) and 
#!     <K>EdgesAsList</K> (<Ref Subsect="VertexEdge_EdgesAsList"/>).
#!
#!     Some shorter (but more ambigous) constructors are 
#!     <K>VertexEdgePathByVertices</K> 
#!     (<Ref Subsect="VertexEdgePathByVertices"/>) and
#!     <K>VertexEdgePathByEdges</K> (<Ref Subsect="VertexEdgePathByEdges"/>).
#!
#!     The NC-version does not check if the
#!     given <A>path</A> is a list 
#!     <M>[v_1,e_1,v_2,e_2,\ldots,v_n,e_n,v_{{n+1}}]</M> that fulfills these
#!     conditions.
#!   </Description>
#! </ManSection>
# No AutoDoc-documentation since the order of the next two entries should
# be switched
DeclareOperation( "VertexEdgePath", [IsVEFComplex, IsDenseList] );
DeclareOperation( "VertexEdgePathNC", [IsVEFComplex, IsDenseList] );


#! @BeginGroup VertexEdgePathByVertices
#! @Description
#! Construct a new vertex-edge-path (<Ref Subsect="VertexEdgePath"/>) from a
#! VEF-complex and a dense list of vertices. Every two adjacent vertices
#! have to be connected by an edge. If there are multiple such edges, the one
#! with the smallest label is used. If the given <A>vertexList</A> is empty,
#! <K>fail</K> is returned.
#!
#! With this the paths from <Ref Subsect="VertexEdgePath"/> can be defined
#! more compactly:
#! @BeginExampleSession
#! gap> newAlpha := VertexEdgePathByVertices( hex, [2,7,5,4,3,7,6] );
#! | v2, E2, v7, E5, v5, E10, v4, E9, v3, E3, v7, E6, v6 |
#! gap> alphaPath = newAlpha;
#! true
#! gap> newOmega := VertexEdgePathByVertices( hex, [3,4,5,7,6,1,2] );
#! | v3, E9, v4, E10, v5, E5, v7, E6, v6, E12, v1, E7, v2 |
#! gap> omegaPath = newOmega;
#! true
#! @EndExampleSession
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_AlphaAndOmega.tex}
#!     </Alt>
#! 
#! TODO ambiguous examples
#!
#! The NC-version does not check whether the given <A>vertexList</A> consists
#! of vertices in <A>complex</A> and whether every two adjacent vertices are
#! connected by an edge.
#!
#! @Returns a vertex-edge-path or <K>fail</K>
#! @Arguments complex, vertexList
DeclareOperation( "VertexEdgePathByVertices", [IsVEFComplex, IsDenseList] );
#! @Arguments complex, vertexList
DeclareOperation( "VertexEdgePathByVerticesNC", [IsVEFComplex, IsDenseList] );
#! @EndGroup


#! @BeginGroup VertexEdgePathByEdges
#! @Description
#! Construct a new vertex-edge-path (<Ref Subsect="VertexEdgePath"/>) from a
#! VEF-complex and a dense list of edges. Every two adjacent edges
#! have to be connected by a vertex. If any vertex position is ambigous (for
#! example if only one edge is given), the smallest possible vertex is chosen
#! to be traversed first.
#!
#! With this the paths from <Ref Subsect="VertexEdgePath"/> can be defined
#! more compactly:
#! @BeginExampleSession
#! gap> newAlpha := VertexEdgePathByEdges( hex, [2,5,10,9,3,6] );
#! | v2, E2, v7, E5, v5, E10, v4, E9, v3, E3, v7, E6, v6 |
#! gap> alphaPath = newAlpha;
#! true
#! gap> newOmega := VertexEdgePathByEdges( hex, [9,10,5,6,12,7] );
#! | v3, E9, v4, E10, v5, E5, v7, E6, v6, E12, v1, E7, v2 |
#! gap> omegaPath = newOmega;
#! true
#! @EndExampleSession
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_AlphaAndOmega.tex}
#!     </Alt>
#! 
#! TODO ambiguous examples
#!
#! The NC-version does not check whether the given <A>edgeList</A> consists
#! of edges in <A>complex</A>.
#!
#! @Returns a vertex-edge-path
#! @Arguments complex, edgeList
DeclareOperation( "VertexEdgePathByEdges", [IsVEFComplex, IsDenseList] );
#! @Arguments complex, edgeList
DeclareOperation( "VertexEdgePathByEdgesNC", [IsVEFComplex, IsDenseList] );
#! @EndGroup


#! @BeginGroup VertexEdge_PathAsList
#! @Description
#!   Return the complete vertex-edge-path as a list (with vertices and
#!   edges alternating), starting with a vertex.
#!   
#!   For the examples from <K>VertexEdgePath</K> 
#!   (<Ref Subsect="VertexEdgePath"/>) in the simplicial surface from the 
#!   start of section <Ref Sect="Section_Paths_VertexEdge"/>:
#!   @ExampleSession
#! gap> PathAsList( alphaPath );
#! [ 2, 2, 7, 5, 5, 10, 4, 9, 3, 3, 7, 6, 6 ]
#! gap> PathAsList( omegaPath );
#! [ 3, 9, 4, 10, 5, 5, 7, 6, 6, 12, 1, 7, 2 ]
#! gap> PathAsList( circlePath );
#! [ 1, 7, 2, 8, 3, 9, 4, 10, 5, 11, 6, 12, 1 ]
#! gap> PathAsList( cloverPath );
#! [ 1, 7, 2, 2, 7, 5, 5, 11, 6, 6, 7, 3, 3, 9, 4, 4, 7, 1, 1 ]
#!   @EndExampleSession
#TODO should we execute the original paths again?
#! @Arguments vertexEdgePath
#! @Returns a list of positive integers
DeclareAttribute( "PathAsList", IsVertexEdgePath );
#! @EndGroup

#! @BeginGroup VertexEdge_VerticesAsList
#! @Description
#!   Return the vertices of the vertex-edge-path as a list.
#!
#!   For the examples from <K>VertexEdgePath</K> 
#!   (<Ref Subsect="VertexEdgePath"/>) in the simplicial surface from the 
#!   start of section <Ref Sect="Section_Paths_VertexEdge"/>:
#!   @ExampleSession
#! gap> VerticesAsList( alphaPath );
#! [ 2, 7, 5, 4, 3, 7, 6 ]
#! gap> VerticesAsList( omegaPath );
#! [ 3, 4, 5, 7, 6, 1, 2 ]
#! gap> VerticesAsList( circlePath );
#! [ 1, 2, 3, 4, 5, 6, 1 ]
#! gap> VerticesAsList( cloverPath );
#! [ 1, 2, 7, 5, 6, 7, 3, 4, 7, 1 ]
#!   @EndExampleSession
#! @Arguments vertexEdgePath
#! @Returns a list of positive integers
DeclareAttribute( "VerticesAsList", IsVertexEdgePath );
#! @EndGroup

#! @BeginGroup VertexEdge_EdgesAsList
#! @Description
#!     Return the edges of the vertex-edge-path as a list.
#!
#!   For the examples from <K>VertexEdgePath</K> 
#!   (<Ref Subsect="VertexEdgePath"/>) in the simplicial surface from the 
#!   start of section <Ref Sect="Section_Paths_VertexEdge"/>:
#!   @ExampleSession
#! gap> EdgesAsList( alphaPath );
#! [ 2, 5, 10, 9, 3, 6 ]
#! gap> EdgesAsList( omegaPath );
#! [ 9, 10, 5, 6, 12, 7 ]
#! gap> EdgesAsList( circlePath );
#! [ 7, 8, 9, 10, 11, 12 ]
#! gap> EdgesAsList( cloverPath );
#! [ 7, 2, 5, 11, 6, 3, 9, 4, 1 ]
#!   @EndExampleSession
#! @Arguments vertexEdgePath
#! @Returns a list of positive integers
DeclareAttribute( "EdgesAsList", IsVertexEdgePath );
#! @EndGroup


#! <ManSection Label="VertexEdge_IsClosedPath">
#!   <Prop Name="IsClosedPath" Arg="vertexEdgePath"
#!     Label="for IsVertexEdgePath"
#!     Comm="Return whether the given path is closed"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!     Check whether the given vertex-edge-path is closed, i.e. whether
#!     the first and last vertex in this path are equal.
#!
#!     From the example paths (introduced in 
#!     <Ref Subsect="VertexEdgePath"/> (<K>VertexEdgePath</K>)) only two
#!     are closed:
#!     @ExampleSession
#! gap> IsClosedPath( alphaPath );
#! false
#! gap> IsClosedPath( omegaPath );
#! false
#! gap> IsClosedPath( circlePath );
#! true
#! gap> IsClosedPath( cloverPath );
#! true
#!     @EndExampleSession
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_CircleAndClover.tex}
#!     </Alt>
#!   </Description>
#! </ManSection>
# This is documentation for a declaration in dual_path.gd

#! @Description
#! Return the inverse vertex-edge-path to the given path.
#!
#! TODO example
#!
#! @Arguments vertexEdgePath
#! @Returns a vertex-edge-path
DeclareAttribute( "Inverse", IsVertexEdgePath );


#! <ManSection Label="VertexEdge_IsDuplicateFree">
#!   <Prop Name="IsDuplicateFree" Arg="vertexEdgePath"
#!     Label="for IsVertexEdgePath"
#!     Comm="Return whether the given path is duplicate-free"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!     Check whether the given vertex-edge-path is duplicate-free.
#!
#!     A vertex-edge-path is duplicate-free if no vertices or edges
#!     appear twice in it - with one exception: if the path is closed
#!     (see <Ref Subsect="VertexEdge_IsClosedPath"/>) it does not matter that the
#!     first and last vertex are the same.
#!
#!     From the example paths (introduced in 
#!     <Ref Subsect="VertexEdgePath"/> (<K>VertexEdgePath</K>)) only two
#!     are duplicate-free:
#!     @ExampleSession
#! gap> IsDuplicateFree( alphaPath );
#! false
#! gap> IsDuplicateFree( omegaPath );
#! true
#! gap> IsDuplicateFree( circlePath );
#! true
#! gap> IsDuplicateFree( cloverPath );
#! false
#!     @EndExampleSession
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_CircleAndOmega.tex}
#!     </Alt>
#!   </Description>
#! </ManSection>
# This is documentation for a declaration in dual_path.gd


#! @BeginGroup VertexEdge_VerticesAsPerm
#! @Description
#!     If a vertex-edge-path is closed and duplicate-free, it induces
#!     a cyclic permutation on its vertices. This method returns that
#!     permutation.
#! 
#!     We illustrate this with
#!     the circle path from <K>VertexEdgePath</K> 
#!     (<Ref Sect="VertexEdgePath"/>).
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_Circle.tex}
#!     </Alt>
#!     @ExampleSession
#! gap> circlePath;
#! ( v1, E7, v2, E8, v3, E9, v4, E10, v5, E11, v6, E12, v1 )
#! gap> VerticesAsPerm(circlePath);
#! (1,2,3,4,5,6)
#!     @EndExampleSession
#! @Arguments vertexEdgePath
#! @Returns a permutation
DeclareAttribute( "VerticesAsPerm", IsVertexEdgePath );
#! @EndGroup


#! @BeginGroup VertexEdge_EdgesAsPerm
#! @Description
#!     If a vertex-edge-path is closed and duplicate-free, it induces
#!     a cyclic permutation on its edges. This method returns that
#!     permutation.
#!
#!     We illustrate this with
#!     the circle path from <K>VertexEdgePath</K> 
#!     (<Ref Sect="VertexEdgePath"/>).
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_Circle.tex}
#!     </Alt>
#!     @ExampleSession
#! gap> circlePath;
#! ( v1, E7, v2, E8, v3, E9, v4, E10, v5, E11, v6, E12, v1 )
#! gap> EdgesAsPerm(circlePath);
#! (7,8,9,10,11,12)
#!     @EndExampleSession
#! @Arguments vertexEdgePath
#! @Returns a permutation
DeclareAttribute( "EdgesAsPerm", IsVertexEdgePath );
#! @EndGroup


#! @BeginGroup
#! @Description
#! Return the VEF-complex for which the given vertex-edge-path is
#! defined.
#!
#! @Returns a VEF-complex
#! @Arguments vertexEdgePath
DeclareAttribute( "AssociatedVEFComplex", IsVertexEdgePath );
#! @EndGroup



##
## Coloured output-attributes
DeclareAttribute( "ViewInformation", IsVertexEdgePath );


#! @Section Edge-Face-Paths
#! @SectionLabel Paths_EdgeFace
#!
#! This section describes all methods for edge-face-paths. Intuitively,
#! edge-face-paths describe all paths that are realized by walking
#! from face to face on a polygonal complex, while only passing edges.
#!
#! We will illustrate them on this simplicial surface:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!     \input{Image_ThinTorus.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> thinTorus := SimplicialSurfaceByDownwardIncidence(
#! >      [[1,2],[2,3],[1,3],[1,4],[1,5],[2,5],[2,6],[3,6],[3,4],
#! >        [4,5],[5,6],[4,6],[1,4],[1,5],[2,5],[2,6],[3,6],[3,4]],
#! >      [[4,5,10],[1,5,6],[6,7,11],[2,7,8],[8,9,12],[3,4,9],
#! >        [10,13,14],[1,14,15],[11,15,16],[2,16,17],[12,17,18],[3,13,18]]);;
#! @EndExampleSession

#TODO replace old definition by this
#! @BeginChunk Definition_EdgeFacePath
#! An <E>edge-face-path</E> in a polygonal complex is a tuple
#! <M>(e_1, f_1, e_2, f_2, \ldots ,e_n, f_n, e_{{n+1}})</M> such that
#! * The <M>e_i</M> are edges of the polygonal complex
#! * The <M>f_j</M> are faces of the polygonal complex
#! * Every face <M>f_j</M> is incident to the edges <M>e_j</M> and <M>e_{{j+1}}</M>
#! * The edges <M>e_j</M> and <M>e_{{j+1}}</M> are different
#! @EndChunk

#! <ManSection Label="EdgeFacePath">
#!   <Oper Name="EdgeFacePath" Arg="complex, path" 
#!      Label="for IsPolygonalComplex and IsDenseList"
#!      Comm="Construct an edge-face-path from a polygonal complex and a list"/>
#!   <Oper Name="EdgeFacePathNC" Arg="complex, path" 
#!      Label="for IsPolygonalComplex and IsDenseList"
#!      Comm="Construct an edge-face-path from a polygonal complex and a list"/>
#!   <Returns>An EdgeFacePath-&GAP;-object</Returns>
#!   <Filt Name="IsEdgeFacePath" Arg="object" Label="for IsObject" Type="category"
#!      Comm="Check whether a given object is an EdgeFacePath"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!     The method <K>EdgeFacePath</K> constructs a new edge-face-path from
#!     a polygonal complex and a dense list of positive integers. The
#!     method <K>IsEdgeFacePath</K> checks if a given &GAP;-object
#!     represents such a path.
#!
#!     We illustrate this with a path on the simplicial surface that was 
#!     introduced at the start of section
#!     <Ref Sect="Section_Paths_EdgeFace"/>.
#!     <Alt Only="TikZ">
#!       \begin{tikzpicture}[vertexStyle=nolabels,edgePlain,faceStyle]
#!         \def\edgeFacePath{1}
#!         \input{Image_ThinTorus.tex}
#!       \end{tikzpicture}
#!     </Alt>
#!
#!     @InsertChunk Definition_EdgeFacePath
#!
#!     @ExampleSession
#! gap> edgeFacePath := EdgeFacePath( thinTorus, [13,7,14,8,15,9,11,3,7,4,8,5,9] );
#! | e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e9 |
#! gap> IsEdgeFacePath(edgeFacePath);
#! true
#! gap> IsList(edgeFacePath);
#! false
#! gap> IsEdgeFacePath( [13,7,14,8,15,9,11,3,7,4,8,5,9] );
#! false
#!     @EndExampleSession
#!  
#!     The elements of a vertex-edge-path can be accessed by using the methods
#!     <K>PathAsList</K> (<Ref Subsect="EdgeFace_PathAsList"/>),
#!     <K>EdgesAsList</K> (<Ref Subsect="EdgeFace_EdgesAsList"/>) and 
#      <K>FacesAsList</K> (<Ref Subsect="EdgeFace_FacesAsList"/>).
#!
#!     The NC-version does not check if the
#!     given <A>path</A> is a list 
#!     <M>[e_1,f_1,e_2,f_2,\ldots,e_n,f_n,e_{{n+1}}]</M> that fulfills these
#!     conditions.
#!   </Description>
#! </ManSection>
# No AutoDoc-documentation since the order of the next two entries should
# be switched
DeclareOperation( "EdgeFacePath", [IsPolygonalComplex, IsDenseList] );
DeclareOperation( "EdgeFacePathNC", [IsPolygonalComplex, IsDenseList] );


#! @BeginGroup EdgeFace_PathAsList
#! @Description
#!   Return the complete edge-face-path as a list (with edges and
#!   faces alternating), starting with an edge.
#!   
#!   For the examples from <K>EdgeFacePath</K> 
#!   (<Ref Subsect="EdgeFacePath"/>) in the simplicial surface from the 
#!   start of section <Ref Sect="Section_Paths_EdgeFace"/>:
#!   @ExampleSession
#! gap> edgeFacePath;
#! | e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e9 |
#! gap> PathAsList( edgeFacePath );
#! [ 13, 7, 14, 8, 15, 9, 11, 3, 7, 4, 8, 5, 9 ]
#!   @EndExampleSession
#! @Arguments edgeFacePath
#! @Returns a list of positive integers
DeclareAttribute( "PathAsList", IsEdgeFacePath );
#! @EndGroup

#! @BeginGroup EdgeFace_EdgesAsList
#! @Description
#!   Return the edges of the edge-face-path as a list.
#!
#!   For the examples from <K>EdgeFacePath</K> 
#!   (<Ref Subsect="EdgeFacePath"/>) in the simplicial surface from the 
#!   start of section <Ref Sect="Section_Paths_EdgeFace"/>:
#!   @ExampleSession
#! gap> edgeFacePath;
#! | e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e9 |
#! gap> EdgesAsList( edgeFacePath );
#! [ 13, 14, 15, 11, 7, 8, 9 ]
#!   @EndExampleSession
#! @Arguments edgeFacePath
#! @Returns a list of positive integers
DeclareAttribute( "EdgesAsList", IsEdgeFacePath );
#! @EndGroup

#! @BeginGroup EdgeFace_FacesAsList
#! @Description
#!     Return the faces of the edge-face-path as a list.
#!
#!   For the examples from <K>EdgeFacePath</K> 
#!   (<Ref Subsect="EdgeFacePath"/>) in the simplicial surface from the 
#!   start of section <Ref Sect="Section_Paths_EdgeFace"/>:
#!   @ExampleSession
#! gap> edgeFacePath;
#! | e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e9 |
#! gap> FacesAsList( edgeFacePath );
#! [ 7, 8, 9, 3, 4, 5 ]
#!   @EndExampleSession
#! @Arguments edgeFacePath
#! @Returns a list of positive integers
DeclareAttribute( "FacesAsList", IsEdgeFacePath );
#! @EndGroup


#! <ManSection Label="EdgeFace_IsClosedPath">
#!   <Prop Name="IsClosedPath" Arg="edgeFacePath"
#!     Label="for IsEdgeFacePath"
#!     Comm="Return whether the given path is closed"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!     Check whether the given edge-face-path is closed, i.e. whether
#!     the first and last vertex in this path are equal.
#!
#! The example from <K>EdgeFacePath</K>
#! (<Ref Subsect="EdgeFacePath"/>) is not closed but an extended version
#! of the path is.
#! <Alt Only="TikZ">
#!   \input{Image_ThinTorus_longPath.tex}
#! </Alt>
#! @ExampleSession
#! gap> edgeFacePath;
#! | e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e9 |
#! gap> IsClosedPath(edgeFacePath);
#! false
#! gap> longPath := EdgeFacePath( thinTorus,
#! >                 [13,7,14,8,15,9,11,3,7,4,8,5,12,11,18,12,13]);
#! ( e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e12, F11, e18, F12, e13 )
#! gap> IsClosedPath(longPath);
#! true
#! @EndExampleSession
#!   </Description>
#! </ManSection>
# This is documentation for a declaration in dual_path.gd


#! @Description
#! Return the inverse edge-face-path to the given path.
#!
#! TODO example
#!
#! @Arguments edgeFacePath
#! @Returns a edge-face-path
DeclareAttribute( "Inverse", IsEdgeFacePath );



#! <ManSection Label="EdgeFace_IsDuplicateFree">
#!   <Prop Name="IsDuplicateFree" Arg="edgeFacePath"
#!     Label="for IsEdgeFacePath"
#!     Comm="Return whether the given path is duplicate-free"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!     Check whether the given edge-face-path is duplicate-free.
#!
#!     An edge-face-path is duplicate-free if no edges or faces
#!     appear twice in it - with one exception: if the path is closed
#!     (see <Ref Subsect="EdgeFace_IsClosedPath"/>) it does not matter that the
#!     first and last edge are the same.
#!
#!     Both the path from <K>EdgeFacePath</K>
#!     (<Ref Subsect="EdgeFacePath"/>) and the longer one from
#!     <K>IsClosedPath</K> (<Ref Subsect="EdgeFace_IsClosedPath"/>)
#!     are duplicate-free.
#!     @ExampleSession
#! gap> IsDuplicateFree( edgeFacePath );
#! true
#! gap> IsDuplicateFree( longPath );
#! true
#!     @EndExampleSession
#! 
#! TODO example where non-central edges are double. Execute other paths again?
#!   </Description>
#! </ManSection>
# This is documentation for a declaration in dual_path.gd


#! @BeginGroup EdgeFace_EdgesAsPerm
#! @Description
#!     If an edge-face-path is closed and duplicate-free, it induces
#!     a cyclic permutation on its edges. This method returns that
#!     permutation.
#! 
#! We illustrate this on the long path from <K>IsClosed</K>
#! (<Ref Subsect="EdgeFace_IsClosedPath"/>).
#! <Alt Only="TikZ">
#!  \input{Image_ThinTorus_longPath.tex}
#! </Alt>
#! @ExampleSession
#! gap> longPath;
#! ( e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e12, F11, e18, F12, e13 )
#! gap> EdgesAsPerm(longPath);
#! (7,8,12,18,13,14,15,11)
#! @EndExampleSession
#! 
#! @Arguments edgeFacePath
#! @Returns a permutation
DeclareAttribute( "EdgesAsPerm", IsEdgeFacePath );
#! @EndGroup


#! @BeginGroup EdgeFace_FacesAsPerm
#! @Description
#!     If an edge-face-path is closed and duplicate-free, it induces
#!     a cyclic permutation on its faces. This method returns that
#!     permutation.
#!
#! We illustrate this on the long path from <K>IsClosed</K>
#! (<Ref Subsect="EdgeFace_IsClosedPath"/>).
#! <Alt Only="TikZ">
#!  \input{Image_ThinTorus_longPath.tex}
#! </Alt>
#! @ExampleSession
#! gap> longPath;
#! ( e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e12, F11, e18, F12, e13 )
#! gap> FacesAsPerm(longPath);
#! (3,4,5,11,12,7,8,9)
#! @EndExampleSession
#!
#! @Arguments edgeFacePath
#! @Returns A permutation
DeclareAttribute( "FacesAsPerm", IsEdgeFacePath );
#! @EndGroup


#! @Description
#! Return the polygonal complex for which the given edge-face-path is
#! defined.
#! @Arguments edgeFacePath
#! @Returns a polygonal complex
DeclareAttribute( "AssociatedPolygonalComplex", IsEdgeFacePath );


##
## Coloured output-attributes
DeclareAttribute( "ViewInformation", IsEdgeFacePath );

#! @Section Geodesics and umbrellas
#! @SectionLabel Paths_Geodesics
#!
#! Section <Ref Sect="Section_Paths_EdgeFace"/> introduced the concept of
#! edge-face-paths. This section deals with two specific types of 
#! edge-face-paths, namely umbrellas and geodesics.
#!
#! This will be illustrated on the following torus:
#! <Alt Only="TikZ">
#!   \input{Image_Geodesics.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> torus := SimplicialSurfaceByDownwardIncidence(
#! >     [ [1,2],[1,2],[1,3],[2,3],[2,4],[1,4],[3,4],[3,4],[1,3],[1,4],[2,4],[2,3] ],
#! >     [ [1,3,4],[4,5,7],[2,5,6],[3,6,8],[7,9,10],[1,10,11],[8,11,12],[2,9,12] ]);;
#! @EndExampleSession
#! 

#! @Description
#! Check whether the given edge-face-path is an umbrella, i.e. whether
#! there is one vertex such that all edges and faces of the edge-face-path
#! are incident to it.
#!
#! As an illustration consider the torus from the start of section
#! <Ref Sect="Section_Paths_Geodesics"/>:
#! <Alt Only="TikZ">
#!   {
#!      \def\pathFive{1}
#!      \def\pathSix{1}
#!      \def\pathSeven{1}
#!      \def\pathFour{1}
#!      \input{Image_Geodesics.tex}
#!   }
#! </Alt>
#! @BeginExampleSession
#! gap> umb := EdgeFacePath( torus, [7,5,10,6,11,7,8,4,6] );
#! | e7, F5, e10, F6, e11, F7, e8, F4, e6 |
#! gap> IsUmbrella(umb);
#! true
#! @EndExampleSession
#!
#! @Arguments edgeFacePath
DeclareProperty( "IsUmbrella", IsEdgeFacePath );


#! @BeginGroup IsGeodesic
#! @Description
#! Check whether the given edge-face-path is a geodesic, i.e. whether each
#! vertex (except those of the first and last edge) is incident to exactly
#! three faces of the path.
#! 
#! As an illustration consider the torus from the start of section
#! <Ref Sect="Section_Paths_Geodesics"/>:
#! <Alt Only="TikZ">
#!  {
#!      \def\pathOne{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \def\pathFour{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> closedGeo := EdgeFacePath( torus, [3,1,4,2,5,3,6,4,3] );
#! ( e3, F1, e4, F2, e5, F3, e6, F4, e3 )
#! gap> IsGeodesic(closedGeo);
#! true
#! @EndExampleSession
#! Geodesics do not have to be closed (<Ref Subsect="IsClosedGeodesic"/>):
#! <Alt Only="TikZ">
#!  {
#!      \def\pathFive{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> openGeo := EdgeFacePath( torus, [9,5,7,2,5,3,2] );
#! | e9, F5, e7, F2, e5, F3, e2 |
#! gap> IsGeodesic(openGeo);
#! true
#! @EndExampleSession
#! 
#! @Arguments edgeFacePath
DeclareProperty( "IsGeodesic", IsEdgeFacePath );
#! @EndGroup

#! @Description
#! For every geodesic (<Ref Subsect="IsGeodesic"/>) there is an interwoven
#! vertex-edge-path with the same edges. All vertices of the geodesic appear
#! in this vertex-edge-path.
#! 
#! TODO explain, draw picture of this zig-zagging vertex-edge-path
#!
#! As an illustration consider the two geodesics from 
#! <Ref Subsect="IsGeodesic"/>:
#! <Alt Only="TikZ">
#!  {
#!      \def\pathOne{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \def\pathFour{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> VertexEdgePath(closedGeo);
#! ( v1, E3, v3, E4, v2, E5, v4, E6, v1 )
#! @EndExampleSession
#! <Alt Only="TikZ">
#!  {
#!      \def\pathFive{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> VertexEdgePath(openGeo);
#! ( v1, E9, v3, E7, v4, E5, v2, E2, v1 )
#! @EndExampleSession
#! 
#!
#! @Returns a vertex-edge-path
#! @Arguments geodesic
DeclareAttribute( "VertexEdgePath", IsEdgeFacePath and IsGeodesic );
#TODO is this a good name?

#! @BeginGroup MaximalGeodesics
#! @Description
#! Compute the set of all maximal geodesics of <A>ramSurf</A>, i.e. the
#! set of all geodesics that can not be extended further.
#!
#! The operation <K>MaximalGeodesicOfFlag</K>(<A>ramSurf</A>, <A>flag</A>)
#! returns the unique maximal geodesic that is defined by the given
#! <A>flag</A>. The NC-version does not check whether the given <A>flag</A>
#! is actually a flag of <A>ramSurf</A>.
#!
#! As an illustration consider the torus from the start of section
#! <Ref Sect="Section_Paths_Geodesics"/>:
#! <Alt Only="TikZ">
#!      \input{Image_Geodesics.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> MaximalGeodesics(torus);
#! [ ( e1, F1, e4, F2, e7, F5, e10, F6, e1 ), 
#!  ( e1, F6, e11, F7, e8, F4, e3, F1, e1 ), 
#!  ( e2, F3, e5, F2, e7, F5, e9, F8, e2 ), 
#!  ( e2, F8, e12, F7, e8, F4, e6, F3, e2 ), 
#!  ( e3, F1, e4, F2, e5, F3, e6, F4, e3 ), 
#!  ( e9, F8, e12, F7, e11, F6, e10, F5, e9 ) ]
#! @EndExampleSession
#! TODO more explanation and example with boundaries?
#!
#! TODO If there are multiple ways to write a geodesic, which is picked?
#!
#! @Returns a set of edge-face-paths
#! @Arguments ramSurf
DeclareAttribute( "MaximalGeodesics", IsRamifiedPolygonalSurface );
#! @Returns an edge-face-path
#! @Arguments ramSurf, flag
DeclareOperation( "MaximalGeodesicOfFlag", [IsRamifiedPolygonalSurface, IsList] );
#! @Arguments ramSurf, flag
DeclareOperation( "MaximalGeodesicOfFlagNC", [IsRamifiedPolygonalSurface, IsList] );
#! @EndGroup

#! @BeginGroup IsClosedGeodesic
#! @Description
#! Check whether the given edge-face-path is a closed geodesic, i.e. whether
#! is is a geodesic (<Ref Subsect="IsGeodesic"/>) where first and last edge
#! coincide, such that all vertices are incident to exactly three faces of
#! the path.
#!
#! As an illustration consider the two geodesics from 
#! <Ref Subsect="IsGeodesic"/>:
#! <Alt Only="TikZ">
#!  {
#!      \def\pathOne{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \def\pathFour{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> IsClosedGeodesic(closedGeo);
#! true
#! @EndExampleSession
#! <Alt Only="TikZ">
#!  {
#!      \def\pathFive{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> IsClosedGeodesic(openGeo);
#! false
#! @EndExampleSession
#!
#! @Arguments edgeFacePath
DeclareProperty( "IsClosedGeodesic", IsEdgeFacePath );
#! @EndGroup
InstallTrueMethod( IsGeodesic, IsClosedGeodesic );

#! @Description
#! Return the defining flags of the given geodesic 
#! (<Ref Subsect="IsGeodesic"/>) as a list.
#!
#! Consider the geodesic
#! <M>[e_1,f_1,e_2,f_2,e_3,f_3,e_4,f_4,e_1]</M>.
#! <Alt Only="TikZ">
#!      \input{Image_DefiningFlags.tex}
#! </Alt>
#! The defining flags can be illustrated as follows:
#! <Alt Only="TikZ">
#!  {
#!      \def\normal{1}
#!      \input{Image_DefiningFlags.tex}
#!  }
#! </Alt>
#! 
#! As an illustration consider the two geodesics from
#! <Ref Subsect="IsGeodesic"/>.
#! <Alt Only="TikZ">
#!  {
#!      \def\pathOne{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \def\pathFour{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> DefiningFlags(closedGeo);
#! [ [ 1, 3, 1 ], [ 3, 4, 2 ], [ 2, 5, 3 ], [ 4, 6, 4 ] ]
#! @EndExampleSession
#! <Alt Only="TikZ">
#!  {
#!      \def\pathFive{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> DefiningFlags(openGeo);
#! [ [ 1, 9, 5 ], [ 3, 7, 2 ], [ 4, 5, 3 ] ]
#! @EndExampleSession
#!
#! @Returns a list of flags
#! @Arguments geodesic
DeclareAttribute( "DefiningFlags", IsEdgeFacePath and IsGeodesic );
#TODO good name?


#! @BeginGroup MaximalDuplicateFreeGeodesics
#! @Description
#! For a given <A>flag</A> return the maximal duplicate-free geodesic
#! defined by this flag, i.e. it is extended in positive direction until one
#! face-duplication arises. Then it is extended in negative direction.
#!
#! The method <K>MaximalDuplicateFreeGeodesics</K>(<A>ramSurf</A>) returns
#! the set of all those geodesics.
#!
#! TODO examples
#!
#! @Returns a set of duplicate-free geodesics
#! @Arguments ramSurf
DeclareAttribute( "MaximalDuplicateFreeGeodesics", IsRamifiedPolygonalSurface );
#! @Returns a duplicate-free geodesic
#! @Arguments ramSurf, flag
DeclareOperation( "MaximalDuplicateFreeGeodesicOfFlag", [IsRamifiedPolygonalSurface, IsList] );
#! @Arguments ramSurf, flag
DeclareOperation( "MaximalDuplicateFreeGeodesicOfFlagNC", [IsRamifiedPolygonalSurface, IsList] );
#! @EndGroup

#! @Description
#! For a closed geodesic (<Ref Subsect="IsClosedGeodesic"/>) construct the
#! <E>geodesic flag cycle</E>. This is a permutation on the 3-flags
#! (<Ref Subsect="Flags"/>). It can also be obtained as one cycle of
#! the product of the Dress involutions (<Ref Subsect="DressInvolutions"/>),
#! by first applying the one for vertices, then edges and finally faces.
#!
#! TODO explain properly with picture
#!
#! @Returns a permutation
#! @Arguments closedGeodesic
DeclareAttribute( "GeodesicFlagCycle", IsEdgeFacePath and IsClosedGeodesic );
#TODO is this a good name?


#! @Section Connectivity
#! @SectionLabel Paths_Connectivity
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
#! This example is connected since its incidence graph (see section
#! <Ref Sect="Section_Graphs_Incidence"/>) is 
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
#! is connected if and only if its incidence graph (compare section 
#! <Ref Sect="Section_Graphs_Incidence"/>) is 
#! connected.
#!
#! For example, consider the ramified simplicial surface from the start of 
#! section <Ref Sect="Section_Paths_Connectivity"/>:
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
#! of the incidence graph (compare section 
#! <Ref Sect="Section_Graphs_Incidence"/>).
#!
#! If a face of the polygonal complex is given as an additional argument,
#! only the connected component containing that face is returned. The 
#! NC-version does not check if <A>face</A> is a face of <A>complex</A>.
#!
#! For example, consider the ramified simplicial surface from the start of
#! section <Ref Sect="Section_Paths_Connectivity"/>:
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
#! section <Ref Sect="Section_Paths_Connectivity"/>:
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
#! section <Ref Sect="Section_Paths_Connectivity"/>:
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
#! section <Ref Sect="Section_Paths_Connectivity"/>:
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
#! The orientation of a face is given as a vertex-edge-path (compare section
#! <Ref Sect="Section_Paths_VertexEdge"/>) in which vertices and edges are
#! alternating. For the quadrangular face we could represent one of these
#! paths as <M>[3,6,7,14,13,12,5,2,3]</M>. From the paths we can also
#! compute the corresponding permutations of vertices and edges alone.
#!
#! @ExampleSession
#! gap> orient := Orientation( surface );
#! [ (v3,E2,v5,E12,v13,E14,v7,E6,v3),,, (v3,E6,v7,E10,v11,E8,v3),,,,, (v7,E14,v13,E15,v11,E10,v7) ]
#! gap> List(orient, VerticesAsPerm);
#! [ (3,5,13,7),,, (3,7,11),,,,, (7,13,11) ]
#! gap> List(orient, VerticesAsList);
#! [ [3,5,13,7,3],,, [3,7,11,3],,,,, [7,13,11,7] ]
#! gap> List(orient, EdgesAsPerm);
#! [ (2,12,14,6),,, (6,10,8),,,,, (10,14,15) ]
#! gap> List(orient, EdgesAsList);
#! [ [2,12,14,6],,, [6,10,8],,,,, [14,15,10] ]
#! @EndExampleSession
#!
#! If the orientation for one face is given, this defined the orientations
#! for the strongly connected component (compare
#! <Ref Subsect="StronglyConnectedComponents"/>) of this face. The convention
#! for returning an orientation is as follows:
#! * For each strongly connected component there is a face with 
#!   minimal number.
#! * The orientation of this face is equal to <K>PermeterOfFace</K>
#!   (<Ref Subsect="PerimetersOfFaces"/>) of this face.
#!

#! @BeginGroup IsOrientable
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
#! @EndGroup

#! @BeginGroup Orientation
#! @Description
#! Return the orientation of the given ramified polygonal surface, if
#! it exists (otherwise return <K>fail</K>). The orientation is given as a list
#! with the faces of <A>ramSurf</A> as indices.
#!
#! For each face, this list contains a vertex-edge-path (see 
#! <Ref Subsect="VertexEdgePath"/> for the precise definition) of this face.
#! To access vertex-edge-paths the methods of section
#! <Ref Sect="Section_Paths_VertexEdge"/> can be used.
#! 
#! TODO describe properly
#!
#! For example, consider the polygonal surface from the start of section
#! <Ref Sect="Section_Orientability"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!      \input{Image_ConstructorExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> orient := Orientation( surface );
#! [ (v3,E2,v5,E12,v13,E14,v7,E6,v3),,, (v3,E6,v7,E10,v11,E8,v3),,,,, (v7,E14,v13,E15,v11,E10,v7) ]
#! gap> List(orient, VerticesAsPerm);
#! [ (3,5,13,7),,, (3,7,11),,,,, (7,13,11) ]
#! gap> List(orient, VerticesAsList);
#! [ [3,5,13,7,3],,, [3,7,11,3],,,,, [7,13,11,7] ]
#! gap> List(orient, EdgesAsPerm);
#! [ (2,12,14,6),,, (6,10,8),,,,, (10,14,15) ]
#! gap> List(orient, EdgesAsList);
#! [ [2,12,14,6],,, [6,10,8],,,,, [14,15,10] ]
#! @EndExampleSession
#! 
#! @Returns a list of vertex-edge-paths
#! @Arguments ramSurf
DeclareAttribute( "Orientation", IsRamifiedPolygonalSurface );
#! @EndGroup


#! @Description
#! Compute the <E>orientation cover</E> of a ramified polygonal surface
#! <A>ramSurf</A>.
#! It is defined as TODO
#!
#! The resulting polygonal surface is always closed 
#! (<Ref Subsect="IsClosedSurface"/>) and orientable 
#! (<Ref Subsect="IsOrientable"/>). If the original <A>ramSurf</A> was
#! orientable, it has two connected components, otherwise just one.
#!
#! @BeginExampleSession
#! gap> tetCov := OrientationCover(Tetrahedron())[1];;
#! gap> NumberOfVertices(tetCov);
#! 8
#! gap> NumberOfEdges(tetCov);
#! 12
#! gap> NumberOfFaces(tetCov);
#! 8
#! gap> NumberOfConnectedComponents(tetCov);
#! 2
#! gap> 
#! @EndExampleSession
#! TODO more varied examples
#! 
#! @Returns a list, where the first entry is a polygonal surface and the
#! subsequent entries are its vertices, edges and faces
#! @Arguments ramSurf
DeclareOperation("OrientationCover", [IsRamifiedPolygonalSurface]);



##
## Undocumented stuff for edge-coloured edge-face-paths
DeclareAttribute("AssociatedEdgeColouredPolygonalComplex", IsEdgeColouredEdgeFacePath);

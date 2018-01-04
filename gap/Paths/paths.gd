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
#! In sections TODO and TODO the concepts of vertex-edge-paths and 
#! edge-face-paths were introduced. This chapter documents which methods
#! are available for these paths (in sections 
#! <Ref Sect="Section_Paths_VertexEdge"/> and 
#! <Ref Sect="Section_Paths_EdgeFace"/>). Then it
#! discusses applications of these paths, namely connectivity (TODO) and
#! orientability (TODO).


#! @Section Vertex-Edge-Paths
#! @SectionLabel Paths_VertexEdge
#!
#! This section describes all methods for vertex-edge-paths. Intuitively,
#! vertex-edge-paths describe all paths that are realized by walking only on
#! the vertices and edges of a polygonal complex.
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
#! * Every edge <M>e_j</M> is incident to the vertices <M>v_j</M> and <M>v_{{j+1}}</M>
#! * The vertices <M>v_j</M> and <M>v_{{j+1}}</M> are different
#! @EndChunk

#TODO is there a way to tell that a filter is a category?
#! <ManSection Label="VertexEdgePath">
#!   <Oper Name="VertexEdgePath" Arg="complex, path" 
#!      Label="for IsPolygonalComplex and IsDenseList"
#!      Comm="Construct a vertex-edge-path from a polygonal complex and a list"/>
#!   <Oper Name="VertexEdgePathNC" Arg="complex, path" 
#!      Label="for IsPolygonalComplex and IsDenseList"
#!      Comm="Construct a vertex-edge-path from a polygonal complex and a list"/>
#!   <Returns>A VertexEdgePath-&GAP;-object</Returns>
#!   <Filt Name="IsVertexEdgePath" Arg="object" Label="for IsObject"
#!      Comm="Check whether a given object is a VertexEdgePath"/>
#!   <Returns>true or false</Returns>
#!   <Description>
#!     The method <K>VertexEdgePath</K> constructs a new vertex-edge-path from
#!     a polygonal complex and a dense list of positive integers. The
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
#! [ 2, 2, 7, 5, 5, 10, 4, 9, 3, 3, 7, 6, 6 ]
#! gap> omegaPath := VertexEdgePath(hex, [3,9,4,10,5,5,7,6,6,12,1,7,2]);
#! [ 3, 9, 4, 10, 5, 5, 7, 6, 6, 12, 1, 7, 2 ]
#!     @EndExampleSession
#!
#!     @InsertChunk Definition_VertexEdgePath
#!
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_CircleAndClover.tex}
#!     </Alt>
#!     @ExampleSession
#! gap> circlePath := VertexEdgePath( hex, [1,7,2,8,3,9,4,10,5,11,6,12,1] );
#! [ 1, 7, 2, 8, 3, 9, 4, 10, 5, 11, 6, 12, 1 ]
#! gap> cloverPath := VertexEdgePath( hex, [1,7,2,2,7,5,5,11,6,6,7,3,3,9,4,4,7,1,1] );
#! [ 1, 7, 2, 2, 7, 5, 5, 11, 6, 6, 7, 3, 3, 9, 4, 4, 7, 1, 1 ]
#!     @EndExampleSession
#!
#!     The NC-version does not check if the
#!     given <A>path</A> is a list 
#!     <M>[v_1,e_1,v_2,e_2,\ldots,v_n,e_n,v_{{n+1}}]</M> that fulfills these
#!     conditions.
#!   </Description>
#! </ManSection>
# No AutoDoc-documentation since the order of the next two entries should
# be switched
DeclareCategory( "IsVertexEdgePath", IsDualPath );
BindGlobal( "VertexEdgePathFamily", 
    NewFamily("VertexEdgePathFamily", IsObject, IsVertexEdgePath) );
DeclareOperation( "VertexEdgePath", [IsPolygonalComplex, IsDenseList] );
DeclareOperation( "VertexEdgePathNC", [IsPolygonalComplex, IsDenseList] );


#! The elements of a vertex-edge-path can be accessed by using the methods
#! <K>PathAsList</K>, <K>Vertices</K> and <K>Edges</K>.

#! <ManSection>
#!   <Attr Name="PathAsList" Arg="vertexEdgePath" 
#!     Label="for IsVertexEdgePath" Comm="Return the complete path as list"/>
#!   <Returns>A list of positive integers</Returns>
#!   <Description>
#!   Return the complete vertex-edge-path as a list (with vertices and
#!   edges alternating).
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
#!   </Description>
#! </ManSection>
# No AutoDoc since we use a synonym
DeclareSynonym( "PathAsList", Path );

#! <ManSection>
#!   <Attr Name="VerticesAsList" Arg="vertexEdgePath"
#!     Label="for IsVertexEdgePath" 
#!     Comm="Return the odd entries of the path as list"/>
#!   <Returns>A list of positive integers</Returns>
#!   <Description>
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
#!   </Description>
#! </ManSection>
# No AutoDoc since we use a synonym
DeclareSynonym( "VerticesAsList", OddPart );

#! <ManSection>
#!   <Attr Name="EdgesAsList" Arg="vertexEdgePath"
#!     Label="for IsVertexEdgePath" 
#!     Comm="Return the odd entries of the path as list"/>
#!   <Returns>A list of positive integers</Returns>
#!   <Description>
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
#!   </Description>
#! </ManSection>
# No AutoDoc since we use a synonym
DeclareSynonym( "EdgesAsList", EvenPart );


#! <ManSection Label="IsClosedPath">
#!   <Prop Name="IsClosedPath" Arg="vertexEdgePath"
#!     Label="for IsVertexEdgePath"
#!     Comm="Return whether the given path is closed"/>
#!   <Returns>true or false</Returns>
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


#! <ManSection Label="IsDuplicateFree">
#!   <Prop Name="IsDuplicateFree" Arg="vertexEdgePath"
#!     Label="for IsVertexEdgePath"
#!     Comm="Return whether the given path is duplicate-free"/>
#!   <Returns>true or false</Returns>
#!   <Description>
#!     Check whether the given vertex-edge-path is duplicate-free.
#!
#!     A vertex-edge-path is duplicate-free if no vertices or edges
#!     appear twice in it - with one exception: if the path is closed
#!     (see <Ref Subsect="IsClosedPath"/>) it does not matter that the
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


#! <ManSection Label="VerticesAsPerm">
#!   <Attr Name="VerticesAsPerm" Arg="vertexEdgePath"
#!     Label="for IsVertexEdgePath and IsClosed and IsDuplicateFree" 
#!     Comm="Return the vertices of the given vertex-edge-path as permutation"/>
#!   <Returns>A permutation</Returns>
#!   <Description>
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
#! [ 1, 7, 2, 8, 3, 9, 4, 10, 5, 11, 6, 12, 1 ]
#! gap> VerticesAsPerm(circlePath);
#! (1,2,3,4,5,6)
#!     @EndExampleSession
#!   </Description>
#! </ManSection>
# No AutoDoc since it is a synonym
DeclareSynonym( "VerticesAsPerm", OddPartAsPerm );


#! <ManSection Label="EdgesAsPerm">
#!   <Attr Name="EdgesAsPerm" Arg="vertexEdgePath"
#!     Label="for IsVertexEdgePath and IsClosed and IsDuplicateFree" 
#!     Comm="Return the edges of the given vertex-edge-path as permutation"/>
#!   <Returns>A permutation</Returns>
#!   <Description>
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
#! [ 1, 7, 2, 8, 3, 9, 4, 10, 5, 11, 6, 12, 1 ]
#! gap> EdgesAsPerm(circlePath);
#! (7,8,9,10,11,12)
#!     @EndExampleSession
#!   </Description>
#! </ManSection>
# No AutoDoc since it is a synonym
DeclareSynonym( "EdgesAsPerm", EvenPartAsPerm );


#! @Description
#! Return the polygonal complex for which the given vertex-edge-path is
#! defined.
#! @Arguments vertexEdgePath
#! @Returns a polygonal complex
DeclareAttribute( "AssociatedPolygonalComplex", IsVertexEdgePath );




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

#TODO is there a way to tell that a filter is a category?
#! <ManSection Label="EdgeFacePath">
#!   <Oper Name="EdgeFacePath" Arg="complex, path" 
#!      Label="for IsPolygonalComplex and IsDenseList"
#!      Comm="Construct an edge-face-path from a polygonal complex and a list"/>
#!   <Oper Name="EdgeFacePathNC" Arg="complex, path" 
#!      Label="for IsPolygonalComplex and IsDenseList"
#!      Comm="Construct an edge-face-path from a polygonal complex and a list"/>
#!   <Returns>An EdgeFacePath-&GAP;-object</Returns>
#!   <Filt Name="IsEdgeFacePath" Arg="object" Label="for IsObject"
#!      Comm="Check whether a given object is an EdgeFacePath"/>
#!   <Returns>true or false</Returns>
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
#!
#!     @InsertChunk Definition_EdgeFacePath
#!
#!     @ExampleSession
#! gap> edgeFacePath := EdgeFacePath( thinTorus, [13,7,14,8,15,9,11,3,7,4,8,9] );
#! [ 13, 7, 14, 8, 15, 9, 11, 3, 7, 4, 8, 9 ]
#! gap> IsEdgeFacePath(edgeFacePath);
#! true
#! gap> IsList(edgeFacePath);
#! false
#! gap> IsEdgeFacePath( [13,7,14,8,15,9,11,3,7,4,8,9] );
#! false
#!     @EndExampleSession
#!
#!     The NC-version does not check if the
#!     given <A>path</A> is a list 
#!     <M>[e_1,f_1,e_2,f_2,\ldots,e_n,f_n,e_{{n+1}}]</M> that fulfills these
#!     conditions.
#!   </Description>
#! </ManSection>
# No AutoDoc-documentation since the order of the next two entries should
# be switched
DeclareCategory( "IsEdgeFacePath", IsDualPath );
BindGlobal( "EdgeFacePathFamily", 
    NewFamily("EdgeFacePathFamily", IsObject, IsVertexEdgePath) );
DeclareOperation( "EdgeFacePath", [IsPolygonalComplex, IsDenseList] );
DeclareOperation( "EdgeFacePathNC", [IsPolygonalComplex, IsDenseList] );



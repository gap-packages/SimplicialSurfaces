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
#! are available for these paths (in sections TODO and TODO). Then it
#! discusses applications of these paths, namely connectivity (TODO) and
#! orientability (TODO).

#! @Section Vertex-Edge-Paths
#! @SectionLabel Paths_VertexEdge
#!
#! This section describes all methods for vertex-edge-paths. Intuitively,
#! vertex-edge-paths describe all paths that are realized by walking only on
#! the vertices and edges of a polygonal complex.
#!
#!

#! @BeginChunk Definition_VertexEdgePath
#! A <E>vertex-edge-path</E> in a polygonal complex is a tuple
#! <M>(v_1, e_1, v_2, e_2, \ldots ,v_n, e_n, v_{{n+1}})</M> such that
#! * The <M>v_i</M> are vertices of the polygonal complex
#! * The <M>e_j</M> are edges of the polygonal complex
#! * Every edge <M>e_j</M> is incident to the vertices <M>v_j</M> and <M>v_{{j+1}}</M>
#! * The vertices <M>v_j</M> and <M>v_{{j+1}}</M> are different
#! @EndChunk

#! <ManSection>
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
#!     TODO picture
#!
#!     @InsertChunk Definition_VertexEdgePath
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
#!   TODO example
#!   </Description>
#! </ManSection>
# No AutoDoc since we use a synonym
DeclareSynonym( "PathAsList", "Path" );

#! <ManSection>
#!   <Attr Name="Vertices" Arg="vertexEdgePath"
#!     Label="for IsVertexEdgePath" 
#!     Comm="Return the odd entries of the path as list"/>
#!   <Returns>A list of positive integers</Returns>
#!   <Description>
#!   Return the vertices of the vertex-edge-path as a list.
#!
#!   TODO example
#!   </Description>
#! </ManSection>
# No AutoDoc since we use a synonym
DeclareSynonym( "Vertices", "OddPart" );

#! <ManSection>
#!   <Attr Name="Edges" Arg="vertexEdgePath"
#!     Label="for IsVertexEdgePath" 
#!     Comm="Return the odd entries of the path as list"/>
#!   <Returns>A list of positive integers</Returns>
#!   <Description>
#!     Return the edges of the vertex-edge-path as a list.
#!
#!     TODO example
#!   </Description>
#! </ManSection>
# No AutoDoc since we use a synonym
DeclareSynonym( "Edges", "EvenPart" );


#! <ManSection Label="IsClosedPath">
#!   <Prop Name="IsClosedPath" Arg="vertexEdgePath"
#!     Label="for IsVertexEdgePath"
#!     Comm="Return whether the given path is closed"/>
#!   <Returns>true or false</Returns>
#!   <Description>
#!     Check whether the given vertex-edge-path is closed, i.e. whether
#!     the first and last vertex in this path are equal.
#!
#!     TODO example
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
#!     TODO example
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
#! TODO example
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
#! TODO example
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

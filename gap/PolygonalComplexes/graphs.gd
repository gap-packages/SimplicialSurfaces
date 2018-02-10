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

#! @BeginChunk Graphs_Packages
#! <K>Digraphs</K>, <K>GRAPE</K> and <K>NautyTracesInterface</K>.
#! @EndChunk

#! @BeginChunk Graphs_LabelShift
#! <List>
#!   <Item>The vertex labels stay the same</Item>
#!   <Item>The edge labels are shifted upwards by the maximal vertex label
#!     </Item>
#!   <Item>The face labels are shifted upwards by the sum of the maximal
#!     vertex label and the maximal edge label</Item>
#! </List>
#! @EndChunk

#! @Chapter Graphs and isomorphisms
#! @ChapterLabel Graphs
#! 
#! All polygonal structures from chapter <Ref Chap="PolygonalStructures"/>
#! can be completely described by their incidence structure. Therefore the
#! isomorphism problem reduces to the graph isomorphism problem. This chapter
#! explains the associated functionality.
#!
#! Most of the methods in this chapter need access to one of the graph 
#! packages in &GAP;. Currently supported are the packages
#! @InsertChunk Graphs_Packages
#! A discussion of their 
#! individual merits is postponed to section 
#! <Ref Sect="Section_Graphs_Discussion"/>.
#!
#! In section <Ref Sect="Section_Graphs_Incidence"/> the concept of incidence
#! graphs is introduced. While this is the backbone of the isomorphism testing
#! and automorphism group computation, it may be skipped at first.
#!
#! Section <Ref Sect="Section_Graphs_Isomorphism"/> contains the method
#! <K>IsIsomorphicPolygonalComplex</K> 
#! (<Ref Subsect="IsIsomorphicPolygonalComplex"/>).
#!
#! Section <Ref Sect="Section_Graphs_Automorphisms"/> explains in detail
#! how to use the automorphism group of polygonal complexes.

#! @Section Incidence graph
#! @SectionLabel Graphs_Incidence
#! 
#! The incidence relation (which is central to our concept of polygonal 
#! complexes, compare chapter <Ref Chap="PolygonalStructures"/>) can be interpreted
#! as a coloured undirected graph, the <E>incidence graph</E> of the polygonal
#! complex.
#!
#! The vertices of this incidence graph consist of all vertices (colour 0), 
#! edges (colour 1) and 
#! faces (colour 2) of the polygonal complex. The edges of the incidence graph are given
#! by pairs of vertices-edges and edges-faces that are incident to each other.
#! 
#! As an example, consider the polygonal surface from section
#! <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!    \input{Image_IncidenceGraph.tex}
#! </Alt>
#!
#! Unfortunately the vertex labels of the graph in &GAP; have to be distinct, 
#! which is not guaranteed in general.
#! Therefore we shift the labels of the edges by the maximal vertex label and
#! the face labels by the sum of the maximal vertex and edge labels. In the
#! example above the maximal vertex label is 11 and the maximal edge label 
#! is 13. It would be modified like this:
#! <Alt Only="TikZ">
#!   {
#!      \def\shiftLabels{1}
#!      \input{Image_IncidenceGraph.tex}
#!   }
#! </Alt>
#!
#! The incidence graph is given as a &GAP;-graph. Currently these packages
#! are supported:
#! @InsertChunk Graphs_Packages
#!

#! @BeginGroup IncidenceGraph
#! @Description
#! Return the incidence graph (a coloured, undirected graph) of the given 
#! polygonal complex. The incidence
#! graph is defined as follows:
#! <List>
#!   <Item>The <E>vertices</E> are the vertices (colour 0), edges (colour 1) and 
#!     faces (colour 2) of <A>complex</A>. The labels are shifted in the
#!     following way:
#! @InsertChunk Graphs_LabelShift
#!     </Item>
#!   <Item>The <E>edges</E> are vertex-edge-pairs or edge-face-pairs such that the
#!     elements of the pair are incident in <A>complex</A>.
#!     </Item>
#! </List>
#!
#! The returned graph can be given in three different formats, corresponding
#! to different graph packages: 
#! @InsertChunk Graphs_Packages
#!
#! TODO example
#!
#! @Returns a graph as defined in the package <K>Digraphs</K>
#! @Arguments complex
DeclareAttribute( "IncidenceDigraphsGraph", IsPolygonalComplex );
#! @Returns a graph as defined in the package <K>GRAPE</K>
#! @Arguments complex
DeclareAttribute( "IncidenceGrapeGraph", IsPolygonalComplex );
#! @Returns a graph as defined in the package <K>NautyTracesInterface</K>
#! @Arguments complex
DeclareAttribute( "IncidenceNautyGraph", IsPolygonalComplex );
#! @EndGroup


#! @Section Isomorphism testing
#! @SectionLabel Graphs_Isomorphism
#!
#! Since all polygonal structures (from polygonal complexes to simplicial 
#! surfaces) from chapter <Ref Chap="PolygonalStructures"/> are completely
#! described by their incidence structure, the isomorphism problem for
#! those reduces to the graph isomorphism problem.
#!
#! The graph isomorphism problem is solved by <K>Nauty/Bliss</K>, depending
#! on the available packages. As long as one of the graph packages of &GAP;
#! is loaded, the isomorphism testing can be executed. The supported packages
#! are 
#! @InsertChunk Graphs_Packages 

#! @BeginGroup IsIsomorphicPolygonalComplex
#! @Description
#! Return whether the given polygonal complexes are isomorphic. They are
#! isomorphic if their incidence graphs (compare 
#! <Ref Subsect="Section_Graphs_Incidence"/>) are isomorphic.
#!
#! @ExampleSession
#! gap> IsIsomorphicPolygonalComplex( Cube(), Octahedron() );
#! false
#! @EndExampleSession
#!
#! @Returns true or false
#! @Arguments complex1, complex2
DeclareOperation( "IsIsomorphicPolygonalComplex", 
    [IsPolygonalComplex, IsPolygonalComplex] );
#! @EndGroup


#! @Section Automorphism group
#! @SectionLabel Graphs_Automorphisms
#!
#! This section explains how to compute automorphism groups of polygonal
#! complexes. Since the incidence graph is necessary for the computation,
#! at least one of the following packages has to be available:
#! @InsertChunk Graphs_Packages
#!
#! Working with the automorphism group of a polygonal complex is complicated
#! since any automorphism acts on vertices, edges and faces simultaneously.
#! In general it is not possible to define an automorphism by defining it just
#! on the vertices (or edges, or faces). If that is possible, the situation
#! becomes much easier. This happens for example with the tetrahedron:
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Tetrahedron_constructor.tex}
#! </Alt>
#! @ExampleSession
#! gap> tetra := Tetrahedron();;
#! gap> IsAutomorphismDefinedByFaces(tetra);
#! true
#! gap> AutomorphismGroupOnFaces(tetra);
#! Group( [ (1,2), (3,4), (2,4) ] )
#! @EndExampleSession
#!
#! For the janus-head this is not possible.
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Janus_constructor.tex}
#! </Alt>
#! @ExampleSession
#! gap> janus := JanusHead();;
#! gap> IsAutomorphismDefinedByVertices(janus);
#! false
#! gap> IsAutomorphismDefinedByEdges(janus);
#! false
#! gap> IsAutomorphismDefinedByFaces(janus);
#! false
#! @EndExampleSession
#! Therefore it is necessary to consider the action on vertices, edges and 
#! faces simultaneously.
#!
#! Since some labels are used multiple times (for example, the label 3 appears
#! as vertex and edge in the janus-head), some labels have to change to make
#! the automorphism group a permutation group (which is necessary for efficient
#! computations). For this purpose the labels are changed:
#! @InsertChunk Graphs_LabelShift
#! @ExampleSession
#! gap> AutomorphismGroup(janus);
#! Group([ (7,8), (2,3)(4,5), (1,2)(5,6) ])
#! gap> Size( last );
#! 12
#! @EndExampleSession
#!
#! Unfortunately this makes it more complicated to understand the 
#! automorphisms at a glance. To see the individual action on vertices,
#! edges and faces, the method <K>DisplayAsAutomorphism</K>
#! (<Ref Subsect="DisplayAsAutomorphism"/>) can be used.
#! @ExampleSession
#! gap> AutomorphismGroup(tetra);
#! Group([ (3,4)(6,7)(8,9)(11,12), (1,2)(6,8)(7,9)(13,14), (2,3)(5,6)(9,10)(12,14) ])
#! gap> DisplayAsAutomorphism( tetra, (3,4)(6,7)(8,9)(11,12) );
#! [ (3,4), (2,3)(4,5), (1,2) ]
#! @EndExampleSession
#! The first component describes the action on the vertices, the
#! second component shows the action on the edges and the final
#! component represents the action on the faces.
#! 
#! Most times, it can be avoided to calculate with this big group
#! representation since the automorphism are usually defined by
#! vertices, edges or faces. For example, consider the open bag.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_OpenBag.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> openBag := SimplicialSurfaceByDownwardIncidence(
#! >        [[1,2],[1,3],[2,3],[2,3]], [[1,2,4],[1,2,3]]);;
#! gap> IsAutomorphismDefinedByVertices(openBag);
#! false
#! gap> IsAutomorphismDefinedByEdges(openBag);
#! true
#! gap> IsAutomorphismDefinedByFaces(openBag);
#! false
#! @EndExampleSession
#! Therefore the automorphism group is best represented by its action on
#! the edges.
#! @ExampleSession
#! gap> AutomorphismGroupOnEdges(openBag);
#! Group( [ (3,4), (1,2) ] )
#! @EndExampleSession

#! @BeginGroup AutomorphismGroup
#! @Description
#! Compute the automorphism group of the polygonal complex <A>complex</A> as
#! a permutation group. For an introduction into the usage and conventions
#! of the <K>SimplicialSurface</K>-package, compare the start of section
#! <Ref Sect="Section_Graphs_Automorphisms"/>.
#! 
#! The automorphisms see the labels of <A>complex</A> in the following way:
#! @InsertChunk Graphs_LabelShift
#! 
#! To see the action on the original labels, use the method 
#! <K>DisplayAsAutomorphism</K>(<Ref Subsect="DisplayAsAutomorphism"/>).
#!
#! To compute just the action on vertices, edges or faces individually, use
#! the methods <K>AutomorphismGroupOnVertices</K> 
#! (<Ref Subsect="AutomorphismGroupOnVertices"/>), 
#! <K>AutomorphismGroupOnEdges</K>
#! (<Ref Subsect="AutomorphismGroupOnEdges"/>) and
#! <K>AutomorphismGroupOnFaces</K>
#! (<Ref Subsect="AutomorphismGroupOnFaces"/>).
#!
#! For example, the automorphism group of an icosahedron 
#! (<Ref Subsect="Icosahedron"/>) is the direct product of a cyclic group
#! of order 2 and an alternating group of order 60.
#! @ExampleSession
#! gap> autIco := AutomorphismGroup( Icosahedron() );;
#! gap> Size(autIco);
#! 120
#! gap> StructureDescription(autIco);
#! "C2 x A5"
#! @EndExampleSession
#TODO example with picture? or more of them? Is this really necessary for the kind of people who look at this method..
#!
#! @Arguments complex
#! @Returns a permutation group
DeclareAttribute( "AutomorphismGroup", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup DisplayAsAutomorphism
#! @Description
#! Display an automorphism of the given <A>complex</A> by its individual
#! action on vertices, edges and faces. If this is not possible (because
#! the given permutation is not an automorphism) fail is returned.
#!
#! An explanation for the necessity of this method is given in section
#! <Ref Sect="Section_Graphs_Automorphisms"/>.
#!
#! We illustrate this on the example of a tetrahedron.
#! <Alt Only="TikZ">
#!  \input{_TIKZ_Tetrahedron_constructor.tex}
#! </Alt>
#! @ExampleSession
#! gap> tetra := Tetrahedron();;
#! gap> aut := AutomorphismGroup( tetra );
#! Group([ (3,4)(6,7)(8,9)(11,12), (1,2)(6,8)(7,9)(13,14), (2,3)(5,6)(9,10)(12,14) ])
#! gap> DisplayAsAutomorphism( tetra, (3,4)(6,7)(8,9)(11,12) );
#! [ (3,4), (2,3)(4,5), (1,2) ]
#! gap> DisplayAsAutomorphism( tetra, (1,2)(6,8)(7,9)(13,14) );
#! [ (1,2), (2,4)(3,5), (3,4) ]
#! gap> DisplayAsAutomorphism( tetra, (2,3)(5,6)(9,10)(12,14) );
#! [ (2,3), (1,2)(5,6), (2,4) ]
#! gap> DisplayAsAutomorphism( tetra, (1,5) );
#! fail
#! @EndExampleSession
#! 
#! @Arguments complex, perm
#! @Returns A list of three permutations or fail
DeclareOperation( "DisplayAsAutomorphism", [IsPolygonalComplex, IsPerm] );
#! @EndGroup

#! @BeginGroup AutomorphismGroupOnVertices
#! @Description
#! The method <K>AutomorphismGroupOnVertices</K> returns the action of the 
#! automorphism group of <A>complex</A> on its vertices. If 
#! <K>IsAutomorphismDefinedByVertices</K>(<A>complex</A>) is true, this is
#! isomorphic to the full automorphism group.
#! 
#! For the cube (<Ref Subsect="Cube"/>) we get:
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Cube_constructor.tex}
#! </Alt>
#! @ExampleSession
#! gap> cube := Cube();;
#! gap> IsAutomorphismDefinedByVertices(cube);
#! true
#! gap> AutomorphismGroupOnVertices(cube);
#! Group( [ (1,2)(3,4)(5,6)(7,8), (3,6)(4,5), (1,2,3,4)(5,6,7,8) ] )
#! @EndExampleSession
#! 
#! @Arguments complex
#! @Returns a permutation group
DeclareAttribute( "AutomorphismGroupOnVertices", IsPolygonalComplex );
#! @Arguments complex
DeclareProperty( "IsAutomorphismDefinedByVertices", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup AutomorphismGroupOnEdges
#! @Description
#! The method <K>AutomorphismGroupOnEdges</K> returns the action of the 
#! automorphism group of <A>complex</A> on its edges. If 
#! <K>IsAutomorphismDefinedByEdges</K>(<A>complex</A>) is true, this is
#! isomorphic to the full automorphism group.
#! 
#! For the cube (<Ref Subsect="Cube"/>) we get:
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Cube_constructor.tex}
#! </Alt>
#! @ExampleSession
#! gap> cube := Cube();;
#! gap> IsAutomorphismDefinedByEdges(cube);
#! true
#! gap> AutomorphismGroupOnEdges(cube);
#! Group( [ (2,4)(5,8)(6,7)(9,11), (2,5)(3,12)(4,8)(6,9)(7,11), 
#!             (1,2,3,4)(5,6,7,8)(9,10,11,12) ] )
#! @EndExampleSession
#! 
#! @Arguments complex
#! @Returns a permutation group
DeclareAttribute( "AutomorphismGroupOnEdges", IsPolygonalComplex );
#! @Arguments complex
DeclareProperty( "IsAutomorphismDefinedByEdges", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup AutomorphismGroupOnFaces
#! @Description
#! The method <K>AutomorphismGroupOnFaces</K> returns the action of the 
#! automorphism group of <A>complex</A> on its faces. If 
#! <K>IsAutomorphismDefinedByFaces</K>(<A>complex</A>) is true, this is
#! isomorphic to the full automorphism group.
#! 
#! For the cube (<Ref Subsect="Cube"/>) we get:
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Cube_constructor.tex}
#! </Alt>
#! @ExampleSession
#! gap> cube := Cube();;
#! gap> IsAutomorphismDefinedByFaces(cube);
#! true
#! gap> AutomorphismGroupOnFaces(cube);
#! Group( [ (3,4), (1,2)(5,6), (2,3,5,4) ] )
#! @EndExampleSession
#! 
#! @Arguments complex
#! @Returns a permutation group
DeclareAttribute( "AutomorphismGroupOnFaces", IsPolygonalComplex );
#! @Arguments complex
DeclareProperty( "IsAutomorphismDefinedByFaces", IsPolygonalComplex );
#! @EndGroup


#! @Section Which graph package should be used?
#! @SectionLabel Graphs_Discussion
#! 
#! The <K>SimplicialSurface</K>-package supports three different graph 
#! packages:
#! @InsertChunk Graphs_Packages
#!
#! They have different benefits and disadvantages and are therefore 
#! recommended for different uses:
#! <List>
#!  <Item><K>NautyTracesInterface</K>: This package is designed for the single
#!   purpose of enabling a fast
#!   interface to <K>Nauty/Traces</K>. In this measure it excells. On almost
#!   all
#!   other measures it does not compete.
#!
#!   Therefore it is recommended to have this package available to make
#!   isomorphism testing and automorphism computation fast. For other
#!   purposes it is not recommended.</Item>
#!  <Item><K>GRAPE</K>: This package is designed to work with graphs that have
#!   large automorphism groups. Unfortunately it is written in a way that
#!   is not fully compatible with modern &GAP;. Therefore it is often
#!   necessary to perform <K>ShallowCopy</K> on a graph before any 
#!   methods can be applied to it.
#!
#!   Its main advantage is that it works out of the box.</Item>
#!  <Item><K>Digraphs</K>: This package has the goal of becoming the leading
#!   graph package in &GAP;. It is still developed further but there are
#!   sometimes problems with its installation.
#! 
#!   If the installation is working though, it is recommended to use 
#!   <K>Digraphs</K> instead of <K>GRAPE</K>.</Item>
#! </List>

#! @Section Other graphs
#! @SectionLabel Graphs_Others
#! 
#! For some purposes it is useful to work with other associated graphs of
#! polygonal complexes. These are collected in this section. All of them are
#! implemented for all supported graph packages:
#! @InsertChunk Graphs_Packages
#!

#! @BeginGroup EdgeGraph
#! @Description 
#! Return the edge graph of the given polygonal complex. The vertices of the
#! edge graph are the vertices of <A>complex</A> and for every edge in
#! <A>complex</A> there is a corresponding edge in the edge graph.
#!
#! TODO example
#!
#! @Arguments complex
#! @Returns a graph as defined in the package <K>Digraphs</K>
DeclareAttribute( "EdgeDigraphsGraph", IsPolygonalComplex );
#! @Arguments complex
#! @Returns a graph as defined in the package <K>GRAPE</K>
DeclareAttribute( "EdgeGrapeGraph", IsPolygonalComplex );
#! @Arguments complex
#! @Returns a graph as defined in the package <K>NautyTracesInterface</K>
DeclareAttribute( "EdgeNautyGraph", IsPolygonalComplex );
#! @EndGroup

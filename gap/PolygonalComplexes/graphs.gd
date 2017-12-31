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
#!   <Item>The vertex labels stay the same.</Item>
#!   <Item>The edge labels are shifted upwards by the maximal vertex label.
#!     </Item>
#!   <Item>The face labels are shifted upwards by the sum of the maximal
#!     vertex label and the maximal edge label.</Item>
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
#! <K>IsIsomorphicIncidenceStructure</K> 
#! (<Ref Subsect="IsIsomorphicIncidenceStructure"/>).
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

#! @BeginGroup IsIsomorphicIncidenceStructure
#! @Description
#! Return whether the given polygonal complexes are isomorphic. They are
#! isomorphic if their incidence graphs (compare 
#! <Ref Subsect="Section_Graphs_Incidence"/>) are isomorphic.
#!
#! @ExampleSession
#! gap> IsIsomorphicIncidenceStructure( Cube(), Octahedron() );
#! false
#! @EndExampleSession
#!
#! @Returns true or false
#! @Arguments complex1, complex2
DeclareOperation( "IsIsomorphicIncidenceStructure", 
    [IsPolygonalComplex, IsPolygonalComplex] );
#TODO Combine with fining-method?
#! @EndGroup


#! @Section Automorphism group
#! @SectionLabel Graphs_Automorphisms
#!
#! As long as one of the graph packages (
#! @InsertChunk Graphs_Packages
#! ) is available 
#! the automorphism groups of polygonal complexes can be computed with the
#! method <K>AutomorphismGroup</K> (<Ref Subsect="AutomorphismGroup"/>) as the
#! automorphism groups of the corresponding incidence graphs (see section
#! <Ref Sect="Section_Graphs_Incidence"/> for details).
#!
#! Unfortunately it is not completely trivial to work with the automorphism
#! group of a polygonal complex in &GAP;. This can already be seen on the
#! example of a tetrahedron.
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Tetrahedron_constructor.tex}
#! </Alt>
#! @ExampleSession
#! gap> tetra := Tetrahedron();;
#! gap> aut := AutomorphismGroup(tetra);
#! Group([ (3,4)(6,7)(8,9)(11,12), (1,2)(6,8)(7,9)(13,14), (2,3)(5,6)(9,10)(12,14) ])
#! @EndExampleSession
#! The generators of this group seem very complicated in comparison to
#! the size of the automorphism group - it is just a symmetric group
#! on four elements.
#! @ExampleSession
#! gap> Size(aut);
#! 24
#! gap> IsSymmetricGroup(aut);
#! true
#! @EndExampleSession
#! Furthermore there are labels (like 14) that don't appear as labels
#! of the tetrahedron.
#!
#! This complication appears because there are surfaces where it is
#! necessary to describe the action on vertices, edges and faces 
#! separately. One such example is the janus-head, two triangles 
#! combined along all their edges.
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Janus_constructor.tex}
#! </Alt>
#! If the automorphism group would be determined by the action on
#! the vertices (or edges) alone, it would be a subgroup of the
#! symmetric group on 3 elements. Then it would have at most 6
#! elements. If it were determined by the action on the faces, it
#! would have at most 2 elements. But it actually has 12 elements.
#! @ExampleSession
#! gap> autJan := AutomorphismGroup( JanusHead() );
#! Group([ (7,8), (2,3)(4,5), (1,2)(5,6) ])
#! gap> Size(autJan);
#! 12
#! @EndExampleSession
#! 
#! The labels for vertices, edges and faces in polygonal complexes
#! may overlap. Then the automorphisms can't be represented as permutations
#! over the integers - which is important for fast performance in &GAP;.
#! Therefore the edges and faces are relabelled for the purpose of the
#! automorphisms.
#! @InsertChunk Graphs_LabelShift
#! To see the action on the original labels, the method
#! <K>DisplayAsAutomorphism</K> (<Ref Subsect="DisplayAsAutomorphism"/>) can 
#! be used.
#! @ExampleSession
#! gap> DisplayAsAutomorphism( tetra, (3,4)(6,7)(8,9)(11,12) );
#! [ (3,4), (2,3)(4,5), (1,2) ]
#! @EndExampleSession
#! The first component describes the action on the vertices, the
#! second component shows the action on the edges and the final
#! component represents the action on the faces.

#! @BeginGroup AutomorphismGroup
#! @Description
#! Compute the automorphism group of the polygonal complex <A>complex</A> as
#! a permutation group.
#! 
#! The automorphisms see the labels of <A>complex</A> in the following way:
#! @InsertChunk Graphs_LabelShift
#! For a more exhaustive explanation (and the reason for this) see section
#! <Ref Sect="Section_Automorphisms"/>.
#! 
#! To see the action on the original labels, use the method 
#! <K>DisplayAsAutomorphism</K>(<Ref Subsect="DisplayAsAutomorphism"/>).
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
#! <Ref Sect="Section_Automorphisms"/>.
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


#! TODO explain restrictions to vertices etc., when are they sufficient (anomalies?)?






#! @Section Which graph package should be used?
#! @SectionLabel Graphs_Discussion
#! TODO


#! * <K>Digraphs</K> (method <K>IncidenceDigraphsGraph</K>).
#!   This is returned if <K>IncidenceGraph</K> is called.
#! * <K>GRAPE</K> (method <K>IncidenceGrapeGraph</K>). Since <K>GRAPE</K>
#!   stores its graphs as records that are changed if some properties are
#!   computed, the result of <K>IncidenceGrapeGraph</K> usually can't be
#!   used immediately (since it is immutable). Therefore 
#!   <K>ShallowCopy</K>(<K>IncidenceGrapeGraph</K>(<A>complex</A>)) has
#!   to be used.
#! * <K>NautyTracesInterface</K> (method <K>IncidenceNautyGraph</K>).

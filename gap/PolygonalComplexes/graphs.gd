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
#!   <Item>The vertex numbers are not modified</Item>
#!   <Item>The edge numbers are shifted upwards by the maximal vertex number
#!     </Item>
#!   <Item>The face numbers are shifted upwards by the sum of the maximal
#!     vertex number and the maximal edge number</Item>
#! </List>
#! @EndChunk
#! @BeginChunk Graphs_LabelShiftLocal
#! <List>
#!   <Item>The local vertex numbers are not modified</Item>
#!   <Item>The local edge numbers are shifted upwards by the maximal local 
#!      vertex number</Item>
#!   <Item>The half-edge numbers are shifted upwards by the sum of the maximal
#!     local vertex number and the maximal local edge number</Item>
#! </List>
#! @EndChunk

#! @Chapter Graphs and isomorphisms
#! @ChapterLabel Graphs
#! 
#! The structures from chapter <Ref Chap="PolygonalStructures"/>
#! can be completely described by their incidence structure (in the case of
#! polygonal complexes) or their local flag structure (for bend polygonal
#! complexes). Both of these structures can equivalently be described as
#! graphs. Therefore the
#! isomorphism problem for VEF-complexes reduces to the graph isomorphism 
#! problem. This chapter
#! explains the associated functionality.
#!
#! Most of the methods in this chapter need access to one of the graph 
#! packages in &GAP; (check the method descriptions to see whether a
#! certain graph package is sufficient to execute the method). 
#! Currently supported are the packages
#! @InsertChunk Graphs_Packages
#! A discussion of their 
#! individual merits is postponed to section 
#! <Ref Sect="Section_Graphs_Discussion"/>.
#!
#! In section <Ref Sect="Section_Graphs_Incidence"/> the concept of incidence
#! graphs is introduced. While this is the backbone of the isomorphism testing
#! and automorphism group computation, it may be skipped at first.
#!
#! In section <Ref Sect="Section_Graphs_LocalIncidence"/> the incidence
#! of local flags (for bend polygonal complexes) is discussed.
#!
#! Section <Ref Sect="Section_Graphs_Isomorphism"/> contains the isomorphism 
#! method
#! <K>IsIsomorphic</K> 
#! (<Ref Subsect="IsIsomorphic"/>).
#!
#! Section <Ref Sect="Section_Graphs_Automorphisms_Polygonal"/> explains in detail
#! how to use the automorphism group of polygonal complexes and section
#! <Ref Sect="Section_Graphs_Automorphisms_Bend"/> does the same for bend polygonal
#! complexes.

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


#! @Section Local incidence graph
#! @SectionLabel Graphs_LocalIncidence
#! 
#! Bend polygonal complexes (explained in section 
#! <Ref Sect="PolygonalStructures_bend"/>) are not described by their 
#! incidence structure alone but by their local incidence structure,
#! consisting of local vertices, local edges and half-edges.
#!
#! The vertices of the local incidence graph consist of all local vertices 
#! (colour 0), 
#! local edges (colour 1) and 
#! half-edges (colour 2) of the bend polygonal complex. The edges of the
#! local incidence graph are defined by the local flags: If a local vertex
#! and a local edge are incident to the same local flag, they will be 
#! connected by an edge (similar for the other pairs).
#! 
#!
#! Unfortunately the vertex labels of the graph in &GAP; have to be distinct, 
#! which is not guaranteed in general.
#! Therefore the labels have to be shifted.
#!
#! The local incidence graph is given as a &GAP;-graph. Currently these packages
#! are supported:
#! @InsertChunk Graphs_Packages
#!

#! @BeginGroup LocalIncidenceGraph
#! @Description
#! Return the local incidence graph (a coloured, undirected graph) of the given 
#! bend polygonal complex. The local incidence
#! graph is defined as follows:
#! <List>
#!   <Item>The <E>vertices</E> are the local vertices (colour 0), local edges 
#!     (colour 1) and 
#!     half-edges (colour 2) of <A>complex</A>. The labels are shifted in the
#!     following way:
#! @InsertChunk Graphs_LabelShiftLocal
#!     </Item>
#!   <Item>The <E>edges</E> are pairs of vertices such that the same local
#!     flag is incident to both elements of the pair (excluding loops).
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
DeclareAttribute( "LocalIncidenceDigraphsGraph", IsBendPolygonalComplex );
#! @Returns a graph as defined in the package <K>GRAPE</K>
#! @Arguments complex
DeclareAttribute( "LocalIncidenceGrapeGraph", IsBendPolygonalComplex );
#! @Returns a graph as defined in the package <K>NautyTracesInterface</K>
#! @Arguments complex
DeclareAttribute( "LocalIncidenceNautyGraph", IsBendPolygonalComplex );
#! @EndGroup


#! @Section Isomorphism testing
#! @SectionLabel Graphs_Isomorphism
#!
#! The structures from chapter <Ref Chap="PolygonalStructures"/> (polygonal
#! complex and bend polygonal complexes) can be described by some kind
#! of incidence structure (compare sections 
#! <Ref Sect="Section_Graphs_Incidence"/> and
#! <Ref Sect="Section_Graphs_LocalIncidence"/>). Since these can
#! be modelled as graphs, the isomorphism problem for (bend) polygonal 
#! complexes reduces to the graph isomorphism problem.
#!
#! The graph isomorphism problem is solved by <K>Nauty/Bliss</K>, depending
#! on the available packages. As long as one of the graph packages of &GAP;
#! is loaded, the isomorphism testing can be executed. The supported packages
#! are 
#! @InsertChunk Graphs_Packages 


#! @BeginGroup IsIsomorphic
#! @Description
#! Return whether the given VEF-complexes are isomorphic. Here we have
#! several cases to consider:
#! * Two polygonal complexes are isomorphic if and only if their incidence
#!   graphs (compare 
#!   <Ref Subsect="Section_Graphs_Incidence"/>) are isomorphic.
#! * Two bend polygonal complexes are isomorphic if and only if their
#!   local incidence graphs (compare 
#!   <Ref Subsect="Section_Graphs_LocalIncidence"/>) are isomorphic.
#! * A polygonal complex is isomorphic to a bend polygonal complex, if and
#!   only if the bend polygonal complex can be defined as a polygonal complex
#!   and is isomorphic to the other polygonal complex.
#!
#! The isomorphism check needs the package <K>NautyTracesInterface</K> or
#! <K>Digraphs</K> to work.
#!
#! @ExampleSession
#! gap> IsIsomorphic( Cube(), Octahedron() );
#! false
#! @EndExampleSession
#!
#! @Returns <K>true</K> or <K>false</K>
#! @Arguments complex1, complex2
DeclareOperation( "IsIsomorphic", 
    [IsVEFComplex, IsVEFComplex] );
#! @EndGroup


#! @Description
#! The method <K>IsomorphismRepresentatives</K> takes a list of VEF-complexes 
#! and returns a reduced list in which no two entries are 
#! isomorphic.
#!
#! @BeginExampleSession
#! gap> complexList := [ Cube(), JanusHead(), Cube(), Cube() ];;
#! gap> Size(complexList);
#! 4
#! gap> repList := IsomorphismRepresentatives(complexList);;
#! gap> Size(repList);
#! 2
#! gap> Cube() in repList;
#! true
#! gap> JanusHead() in repList;
#! true
#! @EndExampleSession
#!
#! @Returns a list of VEF-complexes
#! @Arguments complexList
DeclareOperation( "IsomorphismRepresentatives", [IsList] );

#! In many cases it is enough to know whether two polygonal complexes are
#! isomorphic. In some cases it is useful to know the concrete isomorphism
#! between them.
#! TODO can something be done about this? Currently the returned isomorphism does not match the labels (and group actions are hard to define);


#! @Section Automorphism groups of polygonal complexes
#! @SectionLabel Graphs_Automorphisms_Polygonal
#!
#! This section explains how to compute automorphism groups of polygonal
#! complexes. Since the incidence graph is necessary for the computation,
#! at least one of the following packages has to be available:
#! @InsertChunk Graphs_Packages
#!
#! Working with the automorphism group of a polygonal complex is complicated
#! since any automorphism acts on vertices, edges and faces simultaneously.
#! In general it is not possible to define an automorphism by defining it just
#! on the vertices (or edges, or faces). Whenever this is possible, the situation
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
#! Since vertices, edges and faces are represented by numbers and some numbers
#! are used multiple times (for example, the label 3 appears
#! as vertex and edge in the janus-head), some numbers have to change to make
#! the automorphism group a permutation group (which is necessary for efficient
#! computations). Therefore the following numbers are used:
#! @InsertChunk Graphs_LabelShift
#!
#! For the tetrahedron we get the following numbering:
#! * The vertex numbers are <M>[1,2,3,4]</M> and stay that way.
#! * The edge numbers are <M>[1,2,3,4,5,6]</M>. They are shifted upwards by
#!   the maximal vertex number, i.e. <M>4</M>. Therefore the numbers
#!   <M>[5,6,7,8,9,10]</M> are representing the edges.
#! * The face numbers <M>[1,2,3,4]</M> are shifted by both the maximal vertex
#!   number (4) and the maximal edge number (6), for a total of 10. Then
#!   the numbers <M>[11,12,13,14]</M> represent the faces.
#! <Alt Only="TikZ">
#!      \input{_TIKZ_Tetrahedron_constructor_labelShift.tex}
#! </Alt>
#! @ExampleSession
#! gap> AutomorphismGroup(tetra);
#! Group([ (3,4)(6,7)(8,9)(11,12), (1,2)(6,8)(7,9)(13,14), (2,3)(5,6)(9,10)(12,14) ])
#! gap> Size(last);
#! 24
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
#!
#! For example the first generator of the tetrahedron automorphism group
#! is <M>(3,4)(6,7)(8,9)(11,12)</M>, which can be displayed like this:
#! @ExampleSession
#! gap> DisplayAsAutomorphism( tetra, (3,4)(6,7)(8,9)(11,12) );
#! [ (3,4), (2,3)(4,5), (1,2) ]
#! @EndExampleSession
#! The first component describes the action on the vertices, the
#! second component shows the action on the edges and the final
#! component represents the action on the faces.
#! 
#! Often, it can be avoided to calculate with such a big group
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
#! a permutation group on the vertices, edges and faces of <A>complex</A>. For an 
#! introduction into the usage and conventions of automorphism groups in
#! the <K>SimplicialSurface</K>-package, compare the start of section
#! <Ref Sect="Section_Graphs_Automorphisms_Polygonal"/>.
#! 
#! As vertices, edges and faces can be denoted by the same numbers in 
#! <A>complex</A>, they have to be distinguished for the description of
#! the automorphism group. The automorphisms act on the following numbers:
#! @InsertChunk Graphs_LabelShift
#! 
#! For the tetrahedron this gives the following result:
#! @BeginExampleSession
#! gap> tetra := Tetrahedron();;
#! gap> Vertices(tetra);
#! [ 1, 2, 3, 4 ]
#! gap> Edges(tetra);
#! [ 1, 2, 3, 4, 5, 6 ]
#! gap> Faces(tetra);
#! [ 1, 2, 3, 4 ]
#! gap> aut := AutomorphismGroup(tetra);
#! Group([ (3,4)(6,7)(8,9)(11,12), (1,2)(6,8)(7,9)(13,14), (2,3)(5,6)(9,10)(12,14) ])
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Tetrahedron_constructor.tex}
#! </Alt>
#! 
#! To see the action on the original labels, use the method 
#! <K>DisplayAsAutomorphism</K> (<Ref Subsect="DisplayAsAutomorphism"/>).
#! @BeginExampleSession
#! gap> DisplayAsAutomorphism( tetra, aut.1 );
#! [ (3,4), (2,3)(4,5), (1,2) ]
#! gap> DisplayAsAutomorphism( tetra, aut.2 );
#! [ (1,2), (2,4)(3,5), (3,4) ]
#! gap> DisplayAsAutomorphism( tetra, aut.3 );
#! [ (2,3), (1,2)(5,6), (2,4) ]
#! @EndExampleSession
#!
#! To compute the action on vertices, edges or faces individually, use
#! the methods <K>AutomorphismGroupOnVertices</K> 
#! (<Ref Subsect="AutomorphismGroupOnVertices"/>), 
#! <K>AutomorphismGroupOnEdges</K>
#! (<Ref Subsect="AutomorphismGroupOnEdges"/>) or
#! <K>AutomorphismGroupOnFaces</K>
#! (<Ref Subsect="AutomorphismGroupOnFaces"/>).
#! @BeginExampleSession
#! gap> AutomorphismGroupOnVertices(tetra);
#! Group( [ (3,4), (1,2), (2,3) ] )
#! gap> AutomorphismGroupOnEdges(tetra);
#! Group( [ (2,3)(4,5), (2,4)(3,5), (1,2)(5,6) ] )
#! gap> AutomorphismGroupOnFaces(tetra);
#! Group( [ (1,2), (3,4), (2,4) ] )
#! @EndExampleSession
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
#! the given permutation is not an automorphism) <K>fail</K> is returned.
#!
#! An explanation for the necessity of this method is given in section
#! <Ref Sect="Section_Graphs_Automorphisms_Polygonal"/>.
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
#! @Returns A list of three permutations or <K>fail</K>
DeclareOperation( "DisplayAsAutomorphism", [IsPolygonalComplex, IsPerm] );
#! @EndGroup

#! @BeginGroup AutomorphismGroupOnVertices
#! @Description
#! The method <K>AutomorphismGroupOnVertices</K> returns the action of the 
#! automorphism group of <A>complex</A> on its vertices. If 
#! <K>IsAutomorphismDefinedByVertices</K>(<A>complex</A>) is <K>true</K>, 
#! this is
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
#! <K>IsAutomorphismDefinedByEdges</K>(<A>complex</A>) is <K>true</K>, 
#! this is
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
#! <K>IsAutomorphismDefinedByFaces</K>(<A>complex</A>) is <K>true</K>, 
#! this is
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

#TODO AutomorphismGroupOnFlags


#! @Section Automorphism groups of bend polygonal complexes
#! @SectionLabel Graphs_Automorphisms_Bend
#!
#! Section <Ref Sect="Section_Graphs_Automorphisms_Polygonal"/> was concerned
#! with the automorphism groups of polygonal complexes.
#! For the automorphism group of bend polygonal complexes similar concerns
#! arise. Since a bend polygonal complex is not uniquely defined by its
#! vertices, edges, and faces, its automorphisms won't be as well.
#! Therefore the automorphisms are given as permutations of the 
#! <E>local flags</E>.
#!
#! 

#! @BeginGroup
#! @Description
#! Return the automorphism group of the given bend polygonal complex.
#! This automorphism group is given as a permutation in the local flags
#! of <A>bendComplex</A>.
#!
#! @ExampleSession
#! gap> bendTet := BendPolygonalComplex( Tetrahedron() );;
#! gap> aut := AutomorphismGroup(bendTet);;
#! gap> Size(aut);
#! 24
#! gap> aut = AutomorphismGroupOnLocalFlags(bendTet);
#! true
#! @EndExampleSession
#!
#! @Returns a permutation group
#! @Arguments bendComplex
DeclareAttribute("AutomorphismGroup", IsBendPolygonalComplex);
#! @Arguments bendComplex
DeclareAttribute("AutomorphismGroupOnLocalFlags", IsBendPolygonalComplex);
#! @EndGroup

#TODO AutomorphismGroupOn* for the others


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




#!	@Description
#!	Find the canonical representative of a polygonal surface, i.e. an isomorphic surface with the following properties:
#!	- The vertices are numbered consecutively from 1 to the number of vertices (and similarly for edges and faces)
#!	- For any isomorphic surface, the same unique representative is returned in each case.
#!	Also provides a map between the elements of the original surface and the canonical surface.

#! The following example illustrates the use of the <K>CanonicalRepresentativeOfPolygonalSurface</K>
#! command. We define the cube, but with a labelling of larger than necessary integers.  
#! <K>CanonicalRepresentativeOfPolygonalSurface</K> is then used to return both the canonical 
#! representative of the cube and the maps between the cube and its canonical representative. The faces, edges 
#! and vertices are displayed and are clearly now lex least in their ordering. Some 
#! checks reveal that the cube is not identical to its canonical representative, it is however isomorphic, and 
#! mapping the canonical representative under its preimage map returns the cube again.

#! @ExampleSession
#! gap> faces := [ 20, 21, 22, 23, 24, 25 ];;
#! gap> edges := [ 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ];;
#! gap> vertices := [ 12, 13, 14, 15, 16, 17, 18, 19 ];;
#! gap> edgesOfFaces := [ ,,,,,,,,,,,,,,,,,,, [ 4, 5, 6, 7 ], [ 4, 8, 11, 15 ], 
#! >        [ 5, 8, 9, 12 ], [ 7, 10, 11, 14 ], [ 6, 9, 10, 13 ], [ 12, 13, 14, 15 ] ];;
#! gap> verticesOfEdges := [ ,,, [ 12, 13 ], [ 13, 14 ], [ 14, 15 ], [ 12, 15 ], 
#! >        [ 13, 17 ], [ 14, 18 ], [ 15, 19 ], [ 12, 16 ], [ 17, 18 ], [ 18, 19 ], 
#! >        [ 16, 19 ], [ 16, 17 ] ];;
#! gap> cube := PolygonalSurfaceByDownwardIncidence(vertices, edges, faces, 
#! verticesOfEdges, edgesOfFaces);;
#! gap> canonicalCube:=CanonicalRepresentativeOfPolygonalSurface(cube);;
#! gap> canon:=canonicalCube[1];;
#! gap> preimage:=MappingOfSurfaces(canon, canonicalCube[2][1], canonicalCube[2][2], 
#! >        canonicalCube[2][3]);;
#! gap> Faces(canon);
#! [ 1, 2, 3, 4, 5, 6 ]
#! gap> Edges(canon);
#! [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]
#! gap> Vertices(canon);
#! [ 1, 2, 3, 4, 5, 6, 7, 8 ]
#! gap> EdgesOfFaces(canon);
#! [ [ 1, 2, 3, 4 ], [ 5, 6, 7, 8 ], [ 1, 5, 9, 10 ], [ 3, 7, 9, 11 ], 
#! [ 4, 8, 10, 12 ], [ 2, 6, 11, 12 ] ]
#! gap> VerticesOfEdges(canon);
#! [ [ 1, 2 ], [ 3, 4 ], [ 1, 3 ], [ 2, 4 ], [ 5, 6 ], [ 7, 8 ], [ 5, 7 ], [ 6, 8 ], 
#! [ 1, 5 ], [ 2, 6 ], [ 3, 7 ], [ 4, 8 ] ]
#! gap> canon=cube;
#! false
#! gap> IsIsomorphicPolygonalComplex(cube, canon);
#! true
#! gap> preimage=cube;
#! true
#! @EndExampleSession

#!	@Arguments surface
#!	@Returns A list containing the canonical form of the surface and maps from the new
#!	face, edge and vertex set respectively, to the old face, edge and vertex set.
DeclareOperation( "CanonicalRepresentativeOfPolygonalSurface", [IsPolygonalSurface]);

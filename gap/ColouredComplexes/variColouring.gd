

#! @Chapter Edge vari-colourings
#! @ChapterLabel EdgeVariColouring
#! 
#! In Chapter <Ref Chap="Chapter_EdgeColouring"/>, the concept of edge 
#! colourings was introduced in general. This chapter is concerned with
#! a specific type of edge colourings, where every edge of a given face has to
#! have a different colour (so it is <E>varicoloured</E> on each face).
#!
#! In Section <Ref Sect="Section_EdgeVariColouring_Definition"/>,
#! the concept of the edge vari-colouring is defined. In addition,
#! some access
#! functions made possible by the colouring are described.
#! Section <Ref Sect="Section_EdgeVariColouring_Permutations"/> represents
#! the edge vari-colouring of polygonal complexes without edge ramifications 
#! as permutations, the
#! <K>ColourInvolutions</K> (<Ref Subsect="ColourInvolutions"/>).
#!
#! After these general properties, Section
#! <Ref Sect="Section_EdgeVariColouring_Wild"/> deals with a special
#! subclass of vari-colourings: <E>edge exact-colourings</E>, in
#! which the number of colours is minimal (for example, in a simplicial
#! surface there are exactly three colours). Simplicial surfaces with
#! such a colouring are called <E>wild-coloured surfaces</E>
#! (<Ref Subsect="IsWildColouredSurface"/>). The section describes how
#! to uniquely reconstruct a wild-coloured surface from its colour
#! involutions by introducing the <E>local symmetries</E>
#! (<Ref Subsect="LocalSymmetryOfEdges"/>).
#!
#! Section <Ref Sect="Section_EdgeVariColouring_Wild"/> also
#! describes some methods to construct wild-coloured and
#! tame-coloured surfaces (<Ref Subsect="AllWildColouredSurfaces"/>)
#! and coverings of simplicial surfaces
#! (<Ref Subsect="SixFoldCover"/> and <Ref Oper="CommonCover"
#! Label="for IsSimplicialSurface, IsSimplicialSurface, IsList, IsList"/>).
#!

#TODO maybe add example of a simplicial surface without a vari-colouring

#! @Section Definition and elementary properties
#! @SectionLabel EdgeVariColouring_Definition
#! This section defines the concept of edge vari-colourings
#! (<Ref Subsect="IsEdgeVariColouring"/>) and introduces
#! the coloured version of this method:
#! * <K>ColouredEdgesOfFaces</K> (<Ref Subsect="ColouredEdgesOfFaces"/>) 
#!   extends <K>EdgesOfFaces</K> (<Ref Subsect="EdgesOfFaces"/>).
#! 
#! @InsertChunk Example_ColouredPrism


#! @BeginGroup IsEdgeVariColouring
#! @Description
#! The property <K>IsEdgeVariColouring</K> checks if the edges of each
#! face are vari-coloured by the given edge colouring.
#! This is
#! the case if and only if all edges of each face have different colours.
#!
#! For each face there have to be at least as many colours as there are
#! incident edges. Therefore the maximal number of edges in a face is a lower
#! bound on the number of colours in such a colouring. If this lower bound
#! is obtained, we call the colouring <E>exact</E>, which is checked by
#! the property <K>IsEdgeExactColouring</K>. For a simplicial
#! surface this means that there are exactly three colours.
#!
#! We illustrate this on the prism that was introduced at the start of
#! Section <Ref Sect="Section_EdgeVariColouring_Definition"/>.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Prism_coloured-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Prism_coloured.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! The given edge colouring is a vari-colouring but not an exact-colouring.
#! @BeginExampleSession
#! gap> EdgesOfColours( colPrism );
#! [ [ 1, 4 ], [ 3, 6 ], [ 9 ], [ 2, 7 ], [ 5, 8 ] ]
#! gap> IsEdgeVariColouring( colPrism );
#! true
#! gap> IsEdgeExactColouring( colPrism );
#! false
#! @EndExampleSession
#! 
#! Since there are faces with four
#! incident edges, any colouring with less than four colours can't be
#! a vari-colouring. Conversely, a colouring with more than four colours
#! can't be exact.
#! 
#! In fact, there is no exact vari-colouring for this polygonal surface.
#! TODO refer to comparison with simplicial surface (prove this result there);
#!
#! @Arguments colComplex
DeclareProperty("IsEdgeVariColouring", IsEdgeColouredPolygonalComplex);
#! @Arguments colComplex
DeclareProperty("IsEdgeExactColouring", IsEdgeColouredPolygonalComplex);
#! @EndGroup
InstallTrueMethod( IsEdgeVariColouring, IsEdgeExactColouring );


#! @BeginGroup ColouredEdgesOfFaces
#! @Description
#! For an edge vari-coloured polygonal complex
#! the method <K>ColouredEdgesOfFace</K>(<A>rbComp</A>, <A>face</A>) returns a
#! list of the incident edges of <A>face</A> such that the <E>i</E>-th entry has the
#! colour <E>i</E>. The NC-version does not check whether the given <A>face</A>
#! is an actual face of the coloured complex.
#!
#! The attribute <K>ColouredEdgesOfFaces</K> collects all of these lists in 
#! a list indexed by the face labels, i.e.
#! <K>ColouredEdgesOfFaces</K>(<A>rbComp</A>)[<A>face</A>] =
#! <K>ColouredEdgesOfFace</K>(<A>rbComp</A>, <A>face</A>). All other positions
#! are unbound.
#!
#! Consider the prism example from the start of Section 
#! <Ref Sect="Section_EdgeVariColouring_Definition"/>.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Prism_coloured-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Prism_coloured.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> ColoursOfEdges(colPrism);
#! [ 1, 4, 2, 1, 5, 2, 4, 5, 3 ]
#! gap> ColouredEdgesOfFace(colPrism, 1);
#! [ 1, 3,, 2 ]
#! gap> ColouredEdgesOfFace(colPrism, 4);
#! [ 1, 6,, 7, 5 ]
#! gap> ColouredEdgesOfFaces(colPrism);
#! [ [ 1, 3,, 2 ],, [ 4, 3, 9,, 5 ], [ 1, 6,, 7, 5 ], [ 4, 6,, 2, 8 ],, [ ,, 9, 7, 8 ] ]
#! @EndExampleSession
#!
#! @Returns a list of (lists of) positive integers
#! @Arguments rbComp
DeclareAttribute( "ColouredEdgesOfFaces", 
    IsEdgeColouredPolygonalComplex and IsEdgeVariColouring );
#! @Arguments rbComp, face
DeclareOperation( "ColouredEdgesOfFace",
    [IsEdgeColouredPolygonalComplex and IsEdgeVariColouring, IsPosInt]);
#! @Arguments rbComp, face
DeclareOperation( "ColouredEdgesOfFaceNC",
    [IsEdgeColouredPolygonalComplex and IsEdgeVariColouring, IsPosInt]);
#! @EndGroup




#! @Section Permutation description
#! @SectionLabel EdgeVariColouring_Permutations
#!
#! While Section <Ref Sect="Section_EdgeVariColouring_Definition"/> dealt
#! with general edge vari-colourings, this section is restricted to
#! edge vari-colourings of polygonal complexes without edge ramifications. 
#! For those there are
#! at most two faces incident to an edge.
#!
#! Therefore every colour can be interpreted as an involution on the set of 
#! faces
#! (which swaps two faces that are connected by an edge of that colour).
#!
#! @InsertChunk Example_ColouredDisk

#! @BeginGroup ColourInvolutions
#! @Description
#! For an edge vari-coloured (<Ref Subsect="IsEdgeVariColouring"/>) 
#! polygonal complex without edge ramifications 
#! (<Ref Subsect="IsNotEdgeRamified"/>),
#! return the colour involutions. 
#!
#! The attribute <K>ColourInvolutions</K>(<A>rcRamSurf</A>) returns a list
#! of involutions (the position <A>col</A> is bound if and only if <A>col</A>
#! is a colour of the underlying polygonal complex without edge ramifications).
#!
#! For a given colour <A>col</A> the colour involution encodes the 
#! neighbouring relation
#! of the faces that is induced by the edges of the colour <A>col</A>. A 
#! boundary edge induces a fixed point.
#! 
#! @InsertChunk Example_ColouredDisk_ColourInvolutions
#! @Returns a list of involutions
#! @Arguments rcRamSurf
DeclareAttribute("ColourInvolutions", 
    IsEdgeColouredPolygonalComplex and IsNotEdgeRamified and IsEdgeVariColouring);
#! @EndGroup

#! @Section Wild coloured surfaces
#! @SectionLabel EdgeVariColouring_Wild
#!
#! While the previous sections dealt with general edge vari-colourings,
#! this section focuses exclusively on edge exact-coloured
#! simplicial surfaces, i.e. simplicial surfaces whose edges are coloured
#! with three colours such that the edges of each face have different colours.
#! Since these are quite important structures, we will denote them by
#! <E>wild-coloured surfaces</E> (<Ref Subsect="IsWildColouredSurface"/>).
#! More theory on wild-coloured surfaces can be found in <Cite Key="Brakhage2017"/>.
#!
#! In this situation there is an additional local symmetry structure on the
#! edges. For every inner edge (<Ref Subsect="InnerEdges"/>) there are two
#! possible colourings of the two adjacent faces, which can be described by a
#! symmetry with respect to the edge between them. The colours can either be
#! mirrored or rotated into each other: In the first case, the two other
#! edges of the faces that share a given vertex of the inner edge have the
#! same colour, in the second case they have different colours.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_LocalSymmetry-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_LocalSymmetry.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! The first type is called <E>mirror</E> and the second one <E>rotation</E>.
#! Accordingly, an inner edge is called a <E>mirror-edge</E> (or
#! <E>m-edge</E>) or a <E>rotation-edge</E> (or <E>r-edge</E>).
#! Together with the <E>boundary</E>-type for the boundary edges
#! (<Ref Subsect="BoundaryEdges"/>) this defines the <K>LocalSymmetryOfEdges</K>
#! (<Ref Subsect="LocalSymmetryOfEdges"/>).
#!
#! Together with the edge colouring, the local symmetry determines the underlying
#! simplicial surface.

#! @BeginGroup IsWildColouredSurface
#! @Description
#! Check if an edge-coloured polygonal complex is a 
#! <E>wild-coloured surface</E>, i.e.
#! * It is a simplicial surface (<Ref Prop="IsSimplicialSurface"/>)
#! * It has an edge exact-colouring (<Ref Subsect="IsEdgeVariColouring"/>), 
#!   i.e. the edges are coloured by three colours and the edges of every
#!   face have different colours.
#!
#! @InsertChunk Example_ColouredTetrahedron_IsWildColoured
#!
#! @Arguments colSurf
DeclareProperty( "IsWildColouredSurface", IsEdgeColouredPolygonalComplex );
#! @EndGroup
InstallTrueMethod( IsEdgeExactColouring, IsWildColouredSurface );
InstallTrueMethod( IsEdgeColouredSimplicialSurface, IsWildColouredSurface );


#! @BeginGroup ColouredUmbrellasOfVertices
#! @Description
#! For a wild-coloured surface (<Ref Subsect="IsWildColouredSurface"/>) the method 
#! <K>ColouredUmbrellaOfVertex</K>(<A>wildSurf</A>, <A>vertex</A>) returns an edge-coloured 
#! edge-face path for the umbrella-path around <A>vertex</A>. All of these 
#! umbrella-paths
#! are collected in the attribute
#! <K>ColouredUmbrellasOfVertices</K>(<A>wildSurf</A>), i.e.
#! <K>ColouredUmbrellasOfVertices</K>(<A>wildSurf</A>)[<A>vertex</A>]
#! = <K>ColouredUmbrellaOfVertex</K>(<A>wildSurf</A>, <A>vertex</A>).
#!
#! This method extends <K>UmbrellaPathsOfVertices</K> 
#! (<Ref Subsect="UmbrellaPathsOfVertices"/>). The edge-coloured edge-face-paths
#! behave exactly as regular edge-face-paths but are displayed differently.
#! 
#! The NC-version does not check whether the given <A>vertex</A> actually
#! is a vertex of <A>wildSurf</A>.
#!
#! @Returns a list of coloured edge-face-paths
#! @Arguments wildSurf
DeclareAttribute( "ColouredUmbrellasOfVertices", IsWildColouredSurface );
#! @Returns a coloured edge-face-path
#! @Arguments wildSurf, vertex
DeclareOperation( "ColouredUmbrellaOfVertex", [IsWildColouredSurface, IsPosInt] );
#! @Returns a coloured edge-face-path
#! @Arguments wildSurf, vertex
DeclareOperation( "ColouredUmbrellaOfVertexNC", [IsWildColouredSurface, IsPosInt] );
#! @EndGroup


#! @BeginGroup LocalSymmetryOfEdges
#! @Description
#! Return the local symmetry of the edges in <A>colSurf</A>, i.e. whether the 
#! colours in the adjacent faces of a given inner edge are mirrored or rotated.
#!
#! The edges of the edge coloured surface <A>colSurf</A> have a local 
#! symmetry. For every inner coloured edge (<Ref Subsect="InnerEdges"/>)
#! there are two possible colourings of the adjacent faces, which can be
#! described by a symmetry with respect to the edge between them.
#! The colours can either be  mirrored or rotated into each other.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_LocalSymmetry-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_LocalSymmetry.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! The first type is called <E>mirror</E> (a <E>mirror-edge</E> or
#! <E>m-edge</E>) and the second one <E>rotation</E> (a <E>rotation-edge</E>
#! or <E>r-edge</E>).
#! Together with the <E>boundary</E>-type for the boundary edges
#! (<Ref Subsect="BoundaryEdges"/>) this defines the <K>LocalSymmetryOfEdges</K>.
#! 
#! This function returns a list whose <E>i</E>th entry is "mirror" if the
#! <E>i</E>th edge of <A>colSurf</A> is a mirror-edge (m-edge), or "rotation" if the
#! <E>i</E>th edge of <A>colSurf</A> is a rotation-edge (r-edge), or "boundary" if the
#! <E>i</E>th edge of <A>colSurf</A> is a boundary edge. 
#! The method <K>LocalSymmetryOfEdgesAsNumbers</K> encodes the same
#! information by 1 (mirror), 2 (rotation) and 0 (boundary).
#! @BeginExampleSession
#! gap> oct := Octahedron();;
#! gap> oct := AllWildColouredSurfaces(oct);;
#! gap> LocalSymmetryOfEdges(oct[1]);
#! [ "mirror", "mirror", "mirror", "mirror", "mirror", "mirror", "mirror",
#!  "mirror", "mirror", "mirror", "mirror", "mirror" ]
#! gap> LocalSymmetryOfEdges(oct[2]);
#! [ "mirror", "rotation", "mirror", "rotation", "mirror", "mirror", "mirror",
#!  "mirror", "rotation", "mirror", "mirror", "rotation" ]
#! @EndExampleSession
#! The butterfly has four boundary edges and one inner edge. It has two
#! wild colourings: in the first one, the inner edge is a mirror-edge (m-edge), in
#! the second one, it is a rotation-edge (r-edge).
#! @BeginExampleSession
#! gap> butterfly := AllWildColouredSurfaces( Butterfly() );;
#! gap> LocalSymmetryOfEdges( butterfly[1] );
#! [ "boundary", "mirror", "boundary", "boundary", "boundary" ]
#! gap> LocalSymmetryOfEdgesAsNumbers( butterfly[1] );
#! [ 0, 1, 0, 0, 0 ]
#! gap> LocalSymmetryOfEdges( butterfly[2] );
#! [ "boundary", "rotation", "boundary", "boundary", "boundary" ]
#! @EndExampleSession
#!
#! @Returns a list of strings
#! @Arguments colSurf
DeclareAttribute( "LocalSymmetryOfEdges", IsWildColouredSurface );
#! @Returns a list of non-negative integers
#! @Arguments colSurf
DeclareAttribute( "LocalSymmetryOfEdgesAsNumbers", IsWildColouredSurface ); 
#! @EndGroup


#! Of particular interest are those colourings where the local symmetry is equal
#! for each edge of the same colour. In comparison to the wild-coloured 
#! surfaces these colourings are much better behaved. Therefore they are 
#! called <E>tame-coloured surfaces</E>.
#! @BeginGroup IsTameColouredSurface
#! @Description
#! Check whether the local symmetry (<Ref Subsect="LocalSymmetryOfEdges"/>) of
#! a wild-coloured surface is equal
#! for all inner edges of the same colour.
#!
#! For a tame-coloured surface, the method <K>LocalSymmetryOfColours</K>
#! returns a list of local symmetries that is
#! indexed by the colours. The method <K>LocalSymmetryOfColoursAsNumbers</K>
#! encodes them by 1 (mirror), 2 (rotation) and 0 (if all edges of this
#! colour are boundary edges).
#! 
#! @InsertChunk Example_TameColoured
#! 
#! @Arguments colSurf
DeclareProperty( "IsTameColouredSurface", IsEdgeColouredPolygonalComplex);
#! @Returns a list of strings
#! @Arguments colSurf
DeclareAttribute( "LocalSymmetryOfColours", IsTameColouredSurface);
#! @Returns a list of non-negative integers
#! @Arguments colSurf
DeclareAttribute( "LocalSymmetryOfColoursAsNumbers", IsTameColouredSurface);
#! @EndGroup
InstallTrueMethod( IsWildColouredSurface, IsTameColouredSurface );


#! @BeginGroup AllWildColouredSurfaces
#! @Description
#! This method computes all wild-coloured surfaces up to isomorphism
#! based on the given information.
#! If the optional parameter <A>noIsom</A> is set to false, the method computes all
#! wild-coloured surfaces. This means the returned list contains
#! isomorphic edge-coloured surfaces. By default, <A>noIsom</A> is true.
#! The information can be given in one of two forms:
#! <Enum>
#!   <Item>A simplicial surface (<Ref Prop="IsSimplicialSurface"/>).
#!      The optional argument <A>localSymmetry</A> is a list that encodes
#!      the local symmetry (<Ref Subsect="LocalSymmetryOfEdges"/>) of some
#!      edges:
#!      <List>
#!        <Item>If <A>localSymmetry</A>[<A>edge</A>] = 1, then <A>edge</A> will
#!           become a mirror-edge (m-edge).</Item>
#!        <Item>If <A>localSymmetry</A>[<A>edge</A>] = 2, then <A>edge</A> will
#!           become a rotation-edge (r-edge).</Item>
#!        <Item>Unbound positions and the value 0 are ignored, all other entries
#!           will throw errors. </Item>
#!      </List>
#!   </Item>
#!   <Item>A list of three involutions that will become the colour involutions
#!       (<Ref Subsect="ColourInvolutions"/>) of all returned wild-coloured 
#!       surfaces. The involutions can also be given individually (with 
#!       colours 1, 2, 3) or as generators of a group.
#!       The faces of the returned surfaces are the points from 1 to the
#!       largest point moved by the involutions; fixed points of an
#!       involution correspond to boundary edges. If all three involutions
#!       are trivial, the result is the one-face (<Ref Oper="OneFace"/>).
#! 
#!       The optional argument <A>localSymmetry</A> is a list that
#!       encodes the local symmetry (<Ref Subsect="IsTameColouredSurface"/>)
#!       of the colours. The entry <A>localSymmetry</A>[<A>colour</A>] can be
#!       given in one of two forms (all others will throw errors):
#!       <Enum>
#!         <Item>If the entry <A>localSymmetry</A>[<A>colour</A>] is 1, then all edges 
#!            with colour <A>colour</A> will be
#!            mirror-edges (m-edges). If it is 2, they will be
#!            rotation-edges (r-edges). If the
#!            entry is 0 or unbound, no information is given.</Item>
#!         <Item>If the entry <A>localSymmetry</A>[<A>colour</A>] is again
#!            a list, it has to be indexed by the cycles of the
#!            involution <A>invList</A>[<A>colour</A>], i.e. the entry at 
#!            position <A>k</A> encodes the local symmetry of the k-th cycle
#!            (counted in 
#!            <K>Cycles</K>(<A>invList</A>[<A>colour</A>], <A>[1..n]</A>), 
#!            where <A>n</A> is the highest point moved by the involutions). 
#!            As usual, 1 means mirror and 2 means rotation.</Item>
#!       </Enum>
#!   </Item>
#! </Enum>
#!
#! The method <K>AllTameColouredSurfaces</K> works identically, except that it
#! only returns the tame-coloured surfaces 
#! (<Ref Subsect="IsTameColouredSurface"/>).
#!
#! @BeginExampleSession
#! gap> tetWild := AllWildColouredSurfaces(Tetrahedron());;
#! gap> Size(tetWild);
#! 1
#! gap> tetTame := AllTameColouredSurfaces(Tetrahedron());;
#! gap> Size(tetTame);
#! 1
#! gap> octTame := AllTameColouredSurfaces(Octahedron());;
#! gap> Size(octTame);
#! 2
#! gap> octTameIsom := AllTameColouredSurfaces(Octahedron(),false);;
#! gap> Size(octTameIsom);
#! 4
#! @EndExampleSession
#!
#! The local symmetry of some edges can be prescribed. For example, there
#! are two wild colourings of the octahedron in which the first edge is a
#! mirror-edge (m-edge), but only one in which it is a rotation-edge
#! (r-edge).
#! @BeginExampleSession
#! gap> Size( AllWildColouredSurfaces( Octahedron(), [1] ) );
#! 2
#! gap> octRot := AllWildColouredSurfaces( Octahedron(), [2] );;
#! gap> Size(octRot);
#! 1
#! gap> LocalSymmetryOfEdgesAsNumbers( octRot[1] );
#! [ 2, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1 ]
#! @EndExampleSession
#! If the colour involutions are given, a local symmetry for each colour
#! determines the surface. For the colour involutions of the octahedron
#! we can change the local symmetry of the first colour to obtain a 
#! tame-coloured surface with four vertices instead of six.
#! @BeginExampleSession
#! gap> invs := ColourInvolutions( octTame[1] );
#! [ (1,3)(2,4)(5,7)(6,8), (1,7)(2,8)(3,5)(4,6), (1,4)(2,3)(5,8)(6,7) ]
#! gap> AllWildColouredSurfaces( invs, [1,1,1] );
#! [ tame coloured surface (MMM with 6 vertices, 12 edges and 8 faces) ]
#! gap> AllWildColouredSurfaces( invs, [2,1,1] );
#! [ tame coloured surface (RMM with 4 vertices, 12 edges and 8 faces) ]
#! @EndExampleSession
#!
#! @Returns a list of wild-coloured surfaces 
#! @Arguments simpSurf[, localSymmetry, noIsom]
DeclareOperation( "AllWildColouredSurfaces", [IsSimplicialSurface, IsList, IsBool] );
#! @Arguments simpSurf[, localSymmetry, noIsom]
DeclareOperation( "AllTameColouredSurfaces", [IsSimplicialSurface, IsList, IsBool] );
#! @Arguments invList[, localSymmetry, noIsom]
DeclareOperation( "AllWildColouredSurfaces", [IsList, IsList, IsBool] );
#! @Arguments invList[, localSymmetry, noIsom]
DeclareOperation( "AllTameColouredSurfaces", [IsList, IsList, IsBool] );
#! @EndGroup


#! @BeginGroup SixFoldCover
#! @Description
#! Construct the <E>six fold cover</E> of a simplicial surface, which may
#! have boundary. The optional
#! argument <A>localSymmetry</A> is a list with three entries, all of them
#! being 1 (mirror) or 2 (rotation). By default, it is <K>[1,1,1]</K>.
#! 
#! The <E>six fold cover</E> of a simplicial surface is a tame-coloured
#! surface (<Ref Subsect="IsTameColouredSurface"/>) that covers the original
#! surface six times.
#!
#! It is constructed in the following way:
#! * For each face <M>F</M> of <A>simpSurf</A> (with edges <M>e_a</M>,
#!   <M>e_b</M> and <M>e_c</M>) there are six faces in the cover. These
#!   have the form <M>(F, (e_1, e_2, e_3))</M> with 
#!   <M>\{e_1,e_2,e_3\} = \{e_a,e_b,e_c\}</M>, i.e. they correspond to the
#!   orderings of the edges of <M>F</M>. In the cover, the edge
#!   <M>e_i</M> of such a face lifts to an edge of colour <M>i</M>.
#! * For each face of the six fold cover and each <M>i\in\{1,2,3\}</M> 
#!   the neighbour along the edge of colour <M>i</M> is defined.
#!   For example, if <M>i = 2</M> and the face is
#!   <M>(F,(e_x,e_y,e_z))</M>, we construct the neighbour in the following way:
#!   <Par/>
#!   If <M>e_y</M> is a boundary edge of <A>simpSurf</A>, the lifted edge is
#!   a boundary edge of the cover. Otherwise, let <M>G</M> be the neighbour
#!   of <M>F</M> with respect to <M>e_y</M>. The neighbour in the six fold
#!   cover will be of the form
#!   <M>(G,(?,e_y,?))</M>. The content of the <M>?</M> depends on the argument
#!   <A>localSymmetry</A>.
#!   Assume <M>G</M> has the edges <M>\{e_y,e_v,e_w\}</M>, where 
#!   <M>e_x,e_y,e_v</M> share a vertex in <A>simpSurf</A>. If 
#!   <A>localSymmetry</A>[<M>i</M>] = 1, we perform a <E>mirroring</E>, so the
#!   neighbour will be <M>(G,(e_v,e_y,e_w))</M>.
#!   If <A>localSymmetry</A>[<M>i</M>] = 2,
#!   we perform a <E>rotation</E>, so the neighbour will be
#!   <M>(G,(e_w,e_y,e_v))</M>.
#! * Consequently, all inner edges of colour <M>i</M> have the local symmetry
#!   (<Ref Subsect="LocalSymmetryOfEdges"/>)
#!   <A>localSymmetry</A>[<M>i</M>] (mirror if it is 1, rotation if it is 2).
#!   The boundary edges of the cover are exactly the lifts of the boundary
#!   edges of <A>simpSurf</A>. In the colour involutions, they correspond
#!   to fixed points.
#!   Together with the colour involutions defined by these neighbourhoods,
#!   this determines the vertices of the cover
#!   (compare <Ref Subsect="AllWildColouredSurfaces"/>).
#!
#! The method returns a pair. The first entry is the six fold cover.
#! The second entry is a record whose component <K>Faces</K> stores the
#! faces of the cover in the form <K>[F, [e_1, e_2, e_3]]</K> described
#! above, i.e. the <M>j</M>-th entry describes the <M>j</M>-th face of
#! the cover. The component <K>Description</K> describes this encoding.
#! In the following example, the first face of the tetrahedron has the
#! edges 1, 2 and 4.
#!
#! @ExampleSession
#! gap> tetra := Tetrahedron();;
#! gap> EdgesOfFaces(tetra);
#! [ [ 1, 2, 4 ], [ 1, 3, 5 ], [ 4, 5, 6 ], [ 2, 3, 6 ] ]
#! gap> SixFoldCover(tetra);
#! [ tame coloured surface (MMM with 12 vertices, 36 edges and 24 faces), 
#!   rec( Description := "[oldFace, [edges of the oldFace]]", 
#!     Faces := [ [ 1, [ 1, 2, 4 ] ], [ 1, [ 1, 4, 2 ] ], [ 1, [ 2, 1, 4 ] ], 
#!               [ 1, [ 2, 4, 1 ] ], [ 1, [ 4, 1, 2 ] ], [ 1, [ 4, 2, 1 ] ], 
#!               [ 2, [ 1, 3, 5 ] ], [ 2, [ 1, 5, 3 ] ], [ 2, [ 3, 1, 5 ] ], 
#!               [ 2, [ 3, 5, 1 ] ], [ 2, [ 5, 1, 3 ] ], [ 2, [ 5, 3, 1 ] ], 
#!               [ 3, [ 4, 5, 6 ] ], [ 3, [ 4, 6, 5 ] ], [ 3, [ 5, 4, 6 ] ], 
#!               [ 3, [ 5, 6, 4 ] ], [ 3, [ 6, 4, 5 ] ], [ 3, [ 6, 5, 4 ] ], 
#!               [ 4, [ 2, 3, 6 ] ], [ 4, [ 2, 6, 3 ] ], [ 4, [ 3, 2, 6 ] ], 
#!               [ 4, [ 3, 6, 2 ] ], [ 4, [ 6, 2, 3 ] ], [ 4, [ 6, 3, 2 ] ] ] ) ]
#! gap> NumberOfConnectedComponents(last[1]);
#! 1
#! gap> SixFoldCover(Tetrahedron(), [2,2,2] );
#! [ tame coloured surface (RRR with 24 vertices, 36 edges and 24 faces), 
#!   rec( Description := "[oldFace, [edges of the oldFace]]", 
#!    Faces := [ [ 1, [ 1, 2, 4 ] ], [ 1, [ 1, 4, 2 ] ], [ 1, [ 2, 1, 4 ] ], 
#!               [ 1, [ 2, 4, 1 ] ], [ 1, [ 4, 1, 2 ] ], [ 1, [ 4, 2, 1 ] ], 
#!               [ 2, [ 1, 3, 5 ] ], [ 2, [ 1, 5, 3 ] ], [ 2, [ 3, 1, 5 ] ], 
#!               [ 2, [ 3, 5, 1 ] ], [ 2, [ 5, 1, 3 ] ], [ 2, [ 5, 3, 1 ] ], 
#!               [ 3, [ 4, 5, 6 ] ], [ 3, [ 4, 6, 5 ] ], [ 3, [ 5, 4, 6 ] ], 
#!               [ 3, [ 5, 6, 4 ] ], [ 3, [ 6, 4, 5 ] ], [ 3, [ 6, 5, 4 ] ], 
#!               [ 4, [ 2, 3, 6 ] ], [ 4, [ 2, 6, 3 ] ], [ 4, [ 3, 2, 6 ] ], 
#!               [ 4, [ 3, 6, 2 ] ], [ 4, [ 6, 2, 3 ] ], [ 4, [ 6, 3, 2 ] ] ] ) ]
#! gap> NumberOfConnectedComponents(last[1]);
#! 6
#! @EndExampleSession
#!
#! For a surface with boundary, like the butterfly
#! (<Ref Oper="Butterfly"/>), the boundary edges lift to boundary edges.
#! Here, the six fold cover consists of six butterflies.
#! @ExampleSession
#! gap> cover := SixFoldCover( Butterfly() );;
#! gap> cover[1];
#! tame coloured surface (MMM with 24 vertices, 30 edges and 12 faces)
#! gap> Length( BoundaryEdges( cover[1] ) );
#! 24
#! gap> comps := ConnectedComponents( PolygonalComplex( cover[1] ) );;
#! gap> Length( comps );
#! 6
#! gap> ForAll( comps, c -> IsIsomorphic( c, Butterfly() ) );
#! true
#! @EndExampleSession
#!
#! @Returns a pair of a tame-coloured surface and a record
#! @Arguments simpSurf[, localSymmetry]
DeclareOperation( "SixFoldCover", [IsSimplicialSurface, IsList] );
#! @EndGroup


#! @Description
#! Compute the <E>common cover</E> of the two simplicial surfaces
#! <A>surf1</A> and <A>surf2</A> with respect to the given local
#! symmetries. The arguments <A>localSym1</A> and <A>localSym2</A> are
#! lists indexed by the edges of <A>surf1</A> and <A>surf2</A>,
#! respectively. Every entry for an inner edge has to be 1 (mirror) or
#! 2 (rotation), compare <Ref Subsect="LocalSymmetryOfEdges"/>. The entries
#! for boundary edges are ignored, they may be 0 (as in
#! <K>LocalSymmetryOfEdgesAsNumbers</K>).
#!
#! The common cover is constructed as follows:
#! * Its faces are the triples <M>(F, G, \beta)</M>, where <M>F</M> is
#!   a face of <A>surf1</A>, <M>G</M> is a face of <A>surf2</A> and
#!   <M>\beta</M> is a bijection from the vertices of <M>F</M> to the
#!   vertices of <M>G</M>. In particular, the number of faces of the
#!   common cover is six times the product of the numbers of faces of
#!   <A>surf1</A> and <A>surf2</A>.
#! * Each edge <M>e_1</M> of <M>F</M> is mapped by <M>\beta</M> to an
#!   edge <M>e_2</M> of <M>G</M>. If <M>e_1</M> or <M>e_2</M> is a
#!   boundary edge, the edge of <M>(F, G, \beta)</M> that lies over
#!   <M>e_1</M> and <M>e_2</M> is a boundary edge of the common cover.
#!   Otherwise, let <M>F'</M> be the neighbour of
#!   <M>F</M> along <M>e_1</M> in <A>surf1</A> and <M>G'</M> the neighbour
#!   of <M>G</M> along <M>e_2</M> in <A>surf2</A>. Let <M>\tau_1</M> be the bijection
#!   from the vertices of <M>F</M> to the vertices of <M>F'</M> that fixes
#!   the vertices of <M>e_1</M> if <M>e_1</M> is a mirror-edge (m-edge),
#!   and interchanges them if <M>e_1</M> is a rotation-edge (r-edge).
#!   Define <M>\tau_2</M> from the vertices of <M>G</M> to the vertices of
#!   <M>G'</M> in the same way, using <M>e_2</M>. Then the face
#!   <M>(F, G, \beta)</M> is adjacent to the face
#!   <M>(F', G', \tau_2 \circ \beta \circ \tau_1^{-1})</M> along a common
#!   edge that lies over <M>e_1</M> and <M>e_2</M>.
#! * The vertices are glued along these edges: if <M>e_1</M> and <M>e_2</M>
#!   have the same local symmetry, the vertex of <M>(F, G, \beta)</M>
#!   corresponding to a vertex <M>v</M> of <M>e_1</M> is identified with
#!   the vertex of the adjacent face corresponding to <M>v</M>. Otherwise,
#!   it is identified with the vertex corresponding to the other vertex
#!   of <M>e_1</M>.
#!
#! The method returns a pair. The first entry is the common cover. The
#! second entry is a record that describes its faces, edges and vertices
#! in terms of the original surfaces:
#! * <K>Faces</K>: The <M>j</M>-th entry describes the <M>j</M>-th face as
#!   <K>[[F, G], [vertsF, vertsG]]</K>, where the bijection
#!   <M>\beta</M> maps the
#!   <M>k</M>-th entry of the set <K>vertsF</K> of vertices of <M>F</M>
#!   to the <M>k</M>-th entry of <K>vertsG</K>.
#! * <K>Edges</K>: The <M>j</M>-th entry describes the <M>j</M>-th edge as
#!   <K>[[e_1, e_2], faces]</K>, where <K>faces</K> is the set of
#!   incident faces of the cover.
#! * <K>Vertices</K>: The <M>j</M>-th entry is the list of all pairs
#!   <K>[face, v]</K> that are identified to form the <M>j</M>-th vertex,
#!   where <K>face</K> is a face of the cover and <K>v</K> is a vertex of
#!   <A>surf1</A>.
#! * <K>DescriptionFaces</K>, <K>DescriptionEdges</K>,
#!   <K>DescriptionVertices</K>: Short descriptions of these encodings.
#!
#! For example, if both tetrahedra are mirror-coloured, the common cover
#! consists of 24 tetrahedra. If one of them is rotation-coloured instead,
#! the common cover is connected.
#! @BeginExampleSession
#! gap> tet := Tetrahedron();;
#! gap> mirror := [1,1,1,1,1,1];; rotation := [2,2,2,2,2,2];;
#! gap> cover := CommonCover( tet, tet, mirror, mirror );;
#! gap> cover[1];
#! simplicial surface (96 vertices, 144 edges, and 96 faces)
#! gap> NumberOfConnectedComponents( cover[1] );
#! 24
#! gap> cover[2].Faces[1];
#! [ [ 1, 1 ], [ [ 1, 2, 3 ], [ 1, 2, 3 ] ] ]
#! gap> cover := CommonCover( tet, tet, mirror, rotation );;
#! gap> cover[1];
#! simplicial surface (24 vertices, 144 edges, and 96 faces)
#! gap> NumberOfConnectedComponents( cover[1] );
#! 1
#! gap> EulerCharacteristic( cover[1] );
#! -24
#! @EndExampleSession
#!
#! The common cover of two butterflies (<Ref Oper="Butterfly"/>)
#! consists of 4 butterflies (the inner edges are mapped to each other)
#! and 16 isolated triangles.
#! @BeginExampleSession
#! gap> but := Butterfly();;
#! gap> cover := CommonCover( but, but, [0,1,0,0,0], [0,2,0,0,0] );;
#! gap> cover[1];
#! simplicial surface (64 vertices, 68 edges, and 24 faces)
#! gap> NumberOfConnectedComponents( cover[1] );
#! 20
#! gap> Length( BoundaryEdges( cover[1] ) );
#! 64
#! @EndExampleSession
#!
#! @Returns a pair of a simplicial surface and a record that stores
#! vertices, edges and faces of it
#! @Arguments surf1, surf2, localSym1, localSym2
DeclareOperation( "CommonCover", [IsSimplicialSurface, IsSimplicialSurface, IsList, IsList] );


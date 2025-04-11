

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
#! After these general properties, section 
#! <Ref Sect="Section_EdgeVariColouring_Wild"/> deals with a special
#! subclass of a vari-colouring: <E>edge exact-colourings</E>, in
#! which the number of colours is minimal (for example, in a simplicial 
#! surface there can only be three colours). It describes a method to
#! uniquely reconstruct an exact-coloured surface from its permutation (by 
#! introducing the <E>local symmetries</E> 
#! (<Ref Subsect="LocalSymmetryOfEdges"/>)).
#!
#! Section <Ref Sect="Section_EdgeVariColouring_Wild"/> also
#! describes some methods to construct vari-coloured
#! and exact-coloured
#! surfaces.
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
#!
#! In this situation there is an additional local symmetry structure on the
#! edges. For every inner edge (<Ref Subsect="InnerEdges"/>) there are two
#! possible colourings of the adjacent faces, which can be described by a 
#! symmetry with respect to the edge between them. The colours can either be
#! mirrored or rotated into each other.
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
#! * It is a simplicial surface (<Ref Subsect="IsSimplicialSurface"/>)
#! * It has an edge-exact colouring (<Ref Subsect="IsEdgeVariColouring"/>), 
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
#! For a wild coloured surface (<Ref Subsect="IsWildColouredSurface"/>) the method 
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
#! there are two  possible colourings of the adjacent faces, which can be
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
#! The first type is called <E>mirror</E> and the second one <E>rotation</E>.
#! Together with the <E>boundary</E>-type for the boundary edges
#! (<Ref Subsect="BoundaryEdges"/>) this defines the <K>LocalSymmetryOfEdges</K>.
#! 
#! This function returns a list whose <E>i</E>th entry is "mirror" if the
#! <E>i</E>th edge of <A>colSurf</A> is a mirror edge,  or "rotation" if the
#! <E>i</E>th edge of <A>colSurf</A> is a rotation edge, or "boundary" if the
#! <E>i</E>th edge of <A>colSurf</A> is a boundary edge. 
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
#!
#! @Returns a list of strings
#! @Arguments colSurf
DeclareAttribute( "LocalSymmetryOfEdges", IsWildColouredSurface );
#! @Returns a list of positive integers
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
#! for all edges of the same colour.
#!
#! The method <K>LocalSymmetryOfColours</K> returns a list of local symmetries that is
#! indexed by the colours.
#! 
#! @InsertChunk Example_TameColoured
#! 
#! @Arguments colSurf
DeclareProperty( "IsTameColouredSurface", IsEdgeColouredPolygonalComplex);
#! @Returns a list of strings
#! @Arguments colSurf
DeclareAttribute( "LocalSymmetryOfColours", IsTameColouredSurface);
#! @Returns a list of positive integers
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
#!   <Item>A simplicial surface (<Ref Subsect="IsSimplicialSurface"/>).
#!      The optional argument <A>localSymmetry</A> is a list that encodes
#!      the local symmetry (<Ref Subsect="LocalSymmetryOfEdges"/>) of some
#!      edges:
#!      <List>
#!        <Item>If <A>localSymmetry</A>[<A>edge</A>] = 1, then <A>edge</A> will
#!           become a mirror-edge.</Item>
#!        <Item>If <A>localSymmetry</A>[<A>edge</A>] = 2, then <A>edge</A> will
#!           become a rotation-edge.</Item>
#!        <Item>Unbound positions and the value 0 are ignored, all other entries
#!           will throw errors. </Item>
#!      </List>
#!   </Item>
#!   <Item>A list of three involutions that will become the colour involutions
#!       (<Ref Subsect="ColourInvolutions"/>) of all returned wild-coloured 
#!       surfaces. The involutions can also be given individually (with 
#!       colours 1, 2, 3) or as generators of a group.
#! 
#!       The optional argument <A>localSymmetry</A> is a list that
#!       encodes the local symmetry (<Ref Subsect="IsTameColouredSurface"/>)
#!       of the colours. The entry <A>localSymmetry</A>[<A>colour</A>] can be
#!       given in one of two forms (all others will throw errors):
#!       <Enum>
#!         <Item>If the entry <A>localSymmetry</A>[<A>colour</A>] is 1, then all edges 
#!            with colour <A>colour</A> will be
#!            mirror edges. If it is 2, they will be rotation edges. If the
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
#! The method <K>AllTameColouredSurfaces</K> works identical, except that it
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
#! TODO examples that use local symmetries -> what is interesting (but small)?
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


#! @Description
#! Construct the <E>six fold cover</E> of a simplicial surface. The argument
#! <A>localSymmetry</A> is a list with three entries, all of them being 
#! 1 (mirror) or 
#! 2 (rotation).
#! 
#! The <E>six fold cover</E> of a simplicial surface is a tame coloured
#! simplicial surface that covers the original surface six times.
#!
#! It is constructed in the following way:
#! * For each face <M>f</M> of <A>simpSurf</A> (with edges <M>e_a</M>,
#!   <M>e_b</M> and <M>e_c</M>) there are six faces in the cover. These
#!   have the form <M>(f, e_1, e_2, e_3)</M> with 
#!   <M>\{e_1,e_2,e_3\} = \{e_a,e_b,e_c\}</M>. Formally they represent the map
#!   <M>e_a \to e_1</M>, <M>e_b \to e_2</M>, <M>e_c \to e_3</M>.
#! * For each face of the six fold cover and each <M>i\in\{1,2,3\}</M> 
#!   an edge of this face
#!   is defined. For example, if <M>i = 2</M> and the face is
#!   <M>(f,e_x,e_y,e_z)</M>, we construct the neighbour in the following way:
#!   <Par/>
#!   Find the neighbour of <M>f</M> with respect to <M>e_y</M>, denoted by
#!   <M>g</M>. The neighbour in the six fold cover will be of the form
#!   <M>(g,?,e_y,?)</M>. The content of the <M>?</M> depends on the argument
#!   <A>localSymmetry</A>.
#!   Assume <M>g</M> has the edges <M>\{e_y,e_v,e_w\}</M>, where 
#!   <M>e_x,e_y,e_v</M> share a vertex in <A>simpSurf</A>. If 
#!   <A>localSymmetry[i] = 1</A>, we perform a <E>mirroring</E>, so the
#!   neighbour will be <M>(g,e_v,e_y,e_w)</M>. If <A>localSymmetry[i]=2</A>,
#!   we perform a <E>rotation</E>, so the neighbour will be
#!   <M>(g,e_w,e_y,e_v)</M>.
#! * To define the vertices, <A>localSymmetry</A> is used. All edges with
#!   <M>i=2</M> in the preceding explanation will get the local symmetry
#!   <A>localSymmetry[2]</A> (mirror if it is 1, rotation if it is 2).
#!
#! @ExampleSession
#! gap> tetra := Tetrahedron();;
#! gap> SixFoldCover(tetra);
#! [ tame coloured surface (MMM with 12 vertices, 36 edges and 24 faces), 
#!   rec( Description := "[oldFace, [vertices of the oldFace]]", 
#!     Faces := [ [ 1, [ 1, 2, 4 ] ], [ 1, [ 1, 4, 2 ] ], [ 1, [ 2, 1, 4 ] ], 
#!               [ 1, [ 2, 4, 1 ] ], [ 1, [ 4, 1, 2 ] ], [ 1, [ 4, 2, 1 ] ], 
#!               [ 2, [ 1, 3, 5 ] ], [ 2, [ 1, 5, 3 ] ], [ 2, [ 3, 1, 5 ] ], 
#!               [ 2, [ 3, 5, 1 ] ], [ 2, [ 5, 1, 3 ] ], [ 2, [ 5, 3, 1 ] ], 
#!               [ 3, [ 4, 5, 6 ] ], [ 3, [ 4, 6, 5 ] ], [ 3, [ 5, 4, 6 ] ], 
#!               [ 3, [ 5, 6, 4 ] ], [ 3, [ 6, 4, 5 ] ], [ 3, [ 6, 5, 4 ] ], 
#!               [ 4, [ 2, 3, 6 ] ], [ 4, [ 2, 6, 3 ] ], [ 4, [ 3, 2, 6 ] ], 
#!               [ 4, [ 3, 6, 2 ] ], [ 4, [ 6, 2, 3 ] ],[ 4, [ 6, 3, 2 ] ] ] ) ]
#! gap> NumberOfConnectedComponents(last[1]);
#! 1
#! gap> SixFoldCover(Tetrahedron(), [2,2,2] );
#! [ tame coloured surface (RRR with 24 vertices, 36 edges and 24 faces), 
#!   rec( Description := "[oldFace, [vertices of the oldFace]]", 
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
#! @Returns a tame coloured surface
#! @Arguments simpSurf, localSymmetry
DeclareOperation( "SixFoldCover", [IsSimplicialSurface, IsList] );


#! @Description
#! Compute the <E>common cover</E> of two simplicial surfaces.
#!
#! TODO
#!
#! @Returns a pair of a simplicial surface and a record that stores
#! vertices, edges and faces of it
#! @Arguments surf1, surf2, localSym1, localSym2
DeclareOperation( "CommonCover", [IsSimplicialSurface, IsSimplicialSurface, IsList, IsList] );


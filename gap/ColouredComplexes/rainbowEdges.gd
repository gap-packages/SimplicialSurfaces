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

#! @Chapter Rainbow Edge colourings
#! @ChapterLabel RainbowEdgeColouring
#! 
#! In chapter <Ref Chap="Chapter_EdgeColouring"/> the concept of edge 
#! colourings was introduced in general. This chapter is concerned with
#! a specific type of edge colourings, where every edge of a given face has to
#! have a different colour (so it is a rainbow colouring on each face).
#!
#! In section <Ref Sect="Section_RainbowEdgeColouring_Definition"/> 
#! the concept of the rainbow edge colouring is defined. In addition,
#! some access
#! functions made possible by the colouring are described.
#!
#! Section <Ref Sect="Section_RainbowEdgeColouring_Permutations"/> represents
#! the edge colouring of ramified polygonal complexes as permutations, the
#! <K>ColourInvolutions</K> (<Ref Subsect="ColourInvolutions"/>).
#!
#! After these general properties, section 
#! <Ref Sect="Section_RainbowEdgeColouring_Perfect"/> deals with a special
#! subclass of a rainbow colouring: a <E>perfect</E> rainbow colouring in
#! which the number of colours is minimal (for example, in a simplicial 
#! surface there can only be three colours). It describes a method to
#! uniquely reconstruct a coloured surface from its permutation (by 
#! introducing the MR-Type).
#!
#! Finally section TODO describes some methods to construct rainbow coloured
#! surfaces.
#!

#! @Section Definition and elementary properties
#! @SectionLabel RainbowEdgeColouring_Definition
#! This section defines the concept of rainbow edge colourings
#! (<Ref Subsect="IsFaceRainbowEdgeColouring"/>) and introduces
#! the coloured versions of these methods:
#! * <K>ColouredEdgesOfFaces</K> (<Ref Subsect="ColouredEdgesOfFaces"/>) 
#!   extends <K>EdgesOfFaces</K> (<Ref Subsect="EdgesOfFaces"/>).
#TODO should we also implement NeighbourFaceByColour?
#! * <K>EdgeColouredUmbrellasOfVertices</K> 
#!   (<Ref Subsect="EdgeColouredUmbrellasOfVertices"/>) extends
#!   <K>UmbrellasOfVertices</K> (<Ref Subsect="UmbrellasOfVertices"/>).
#! 
#! @InsertChunk Example_ColouredPrism


#! @BeginGroup IsFaceRainbowEdgeColouring
#! @Description
#! The property <K>IsFaceRainbowEdgeColouring</K>
#! checks if the colouring of the given edge coloured polygonal complex is
#! a rainbow colouring if it is restricted to the edges of a face. This is
#! the case if and only if all edges of each face have different colours.
#!
#! For each face there have to be at least as many colours as there are
#! incident edges. Therefore the maximal number of edges in a face is a lower
#! bound on the number of colours in such a colouring. If this lower bound
#! is obtained, we call the colouring <E>perfect</E>, which is checked by
#! the property <K>IsPerfectFaceRainbowEdgeColouring</K>. For a simplicial
#! surface this means that there are exactly three colours.
#!
#! We illustrate this on the prism that was introduced at the start of
#! section <Ref Sect="Section_RainbowEdgeColouring_Definition"/>.
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Prism_coloured.tex}
#! </Alt>
#! The given edge colouring is a non-perfect rainbow colouring.
#! @BeginExampleSession
#! gap> EdgesOfColours( colPrism );
#! [ [ 1, 4 ], [ 3, 6 ], [ 9 ], [ 2, 7 ], [ 5, 8 ] ]
#! gap> IsFaceRainbowEdgeColouring( colPrism );
#! true
#! gap> IsPerfectFaceRainbowEdgeColouring( colPrism );
#! false
#! @EndExampleSession
#! 
#! Since there are faces with four
#! incident edges, any colouring with less than four colours can't be
#! a rainbow colouring. Conversely, a colouring with more than four colours
#! can't be perfect.
#! 
#! In fact, there is no perfect rainbow colouring for this polygonal surface.
#! TODO refer to comparison with simplicial surface (prove this result there);
#!
#! @Arguments colComplex
DeclareProperty("IsFaceRainbowEdgeColouring", IsEdgeColouredPolygonalComplex);
#! @Arguments colComplex
DeclareProperty("IsPerfectFaceRainbowEdgeColouring", IsEdgeColouredPolygonalComplex);
#! @EndGroup
InstallTrueMethod( IsFaceRainbowEdgeColouring, IsPerfectFaceRainbowEdgeColouring );


#! @BeginGroup ColouredEdgesOfFaces
#! @Description
#! For a rainbow edge coloured polygonal complex
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
#! Consider the prism example from the start of section 
#! <Ref Sect="Section_RainbowEdgeColouring_Definition"/>.
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Prism_coloured.tex}
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
    IsEdgeColouredPolygonalComplex and IsFaceRainbowEdgeColouring );
#! @Arguments rbComp, face
DeclareOperation( "ColouredEdgesOfFace",
    [IsEdgeColouredPolygonalComplex and IsFaceRainbowEdgeColouring, IsPosInt]);
#! @Arguments rbComp, face
DeclareOperation( "ColouredEdgesOfFaceNC",
    [IsEdgeColouredPolygonalComplex and IsFaceRainbowEdgeColouring, IsPosInt]);
#! @EndGroup

#TODO implement EdgeColouredEdgeFacePaths as subcategory of EdgeFacePaths -> only difference is View??. Do we actually need this subcategory then?
#TODO for colouredEdgeFacePaths -> how to denote colours? we can use  a,b,c,d,e,... but is this better than the numbers of the colours?


#! @Section Permutation description
#! @SectionLabel RainbowEdgeColouring_Permutations
#!
#! While section <Ref Sect="Section_RainbowEdgeColouring_Definition"/> dealt
#! with general rainbow edge colourings, this section is restricted to
#! rainbow edge colourings of ramified polygonal surfaces. For those there are
#! at most two faces incident to an edge.
#!
#! Therefore every colour can be interpreted as an involution on the set of 
#! faces
#! (which swaps two faces that are connected by an edge of that colour).
#!
#! @InsertChunk Example_ColouredDisk

#! @BeginGroup ColourInvolutions
#! @Description
#! For a rainbow edge coloured (<Ref Subsect="IsFaceRainbowEdgeColouring"/>) 
#! ramified polygonal surface (<Ref Subsect="IsRamifiedPolygonalSurface"/>),
#! return the colour involutions. If the underlying polygonal complex is
#! not a ramified polygonal surface, <K>fail</K> is returned.
#!
#! The attribute <K>ColourInvolutions</K>(<A>rcRamSurf</A>) returns a list
#! of involutions (the position <A>col</A> is bound if and only if <A>col</A>
#! is a colour of the underlying ramified polygonal surface).
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
    IsEdgeColouredPolygonalComplex and IsFaceRainbowEdgeColouring);
#! @EndGroup

#TODO Is this relabelling ok?

#! @Section Perfect rainbow colouring
#! @SectionLabel RainbowEdgeColouring_Perfect
#!
#! While the previous sections dealt with general rainbow edge-colourings,
#! this section focuses exclusively on perfect rainbow edge-coloured
#! simplicial surfaces, i.,e. simplicial surfaces whose edges are coloured
#! with three colours such that the edges of each face have different colours.
#!
#! In this situation there is an additional local symmetry structure on the
#! edges. For every inner edge (<Ref Subsect="InnerEdges"/>) there are two
#! possible colourings of the adjacent faces, which can be described by a 
#! symmetry with respect to the edge between them. The colours can either be
#! mirrored or rotated into each other.
#! <Alt Only="TikZ">
#!   \input{Image_MRType.tex}
#! </Alt>
#! The first type is called <E>mirror</E> and the second one <E>rotation</E>.
#! Together with the <E>boundary</E>-type for the boundary edges
#! (<Ref Subsect="BoundaryEdges"/>) this defines the <K>MRTypeOfEdges</K>
#! (<Ref Subsect="MRTypeOfEdges"/>).
#!
#! Together with the edge colouring, the MR-type determines the underlying
#! simplicial surface.

#! @BeginGroup MRTypeOfEdges
#! @Description
#! Return the MR-type of the edges in <A>colSurf</A>. If the underlying
#! polygonal complex is not a simplicial surface, <K>fail</K> is returned.
#!
#! TODO explain after name is fixed
#!
#! TODO tests
#!
#! @Returns a list of strings
#! @Arguments colSurf
DeclareAttribute( "MRTypeOfEdges", IsEdgeColouredPolygonalComplex and 
    IsPerfectFaceRainbowEdgeColouring );
#! @Returns a list of positive integers
#! @Arguments colSurf
DeclareAttribute( "MRTypeOfEdgesAsNumbers", IsEdgeColouredPolygonalComplex and 
    IsPerfectFaceRainbowEdgeColouring );
#! @EndGroup


#! Of particular interest are those colourings where the MR-type is equal
#! for each edge of the same colour.
#! @BeginGroup IsMRTypeColourInvariant
#! @Description
#! Return whether the MR-type (<Ref Subsect="MRTypeOfEdges"/>) is equal
#! for all edges of the same colour.
#!
#! If the underlying polygonal complex is not a simplicial surface, <K>fail</K> is returned.
#!
#! The method <K>MRTypeOfColours</K> returns a list of MR-types that is
#! indexed by the colours.
#! 
#! TODO a lot of tests (how should this interact with other options?);
#! 
#! @Arguments colSurf
DeclareProperty( "IsMRTypeColourInvariant", IsEdgeColouredPolygonalComplex and 
    IsPerfectFaceRainbowEdgeColouring);
#! @Returns a list of strings
#! @Arguments colSurf
DeclareAttribute( "MRTypeOfColours", IsEdgeColouredPolygonalComplex and
    IsMRTypeColourInvariant);
#! @Returns a list of positive integers
#! @Arguments colSurf
DeclareAttribute( "MRTypeOfColoursAsNumbers", IsEdgeColouredPolygonalComplex and
    IsMRTypeColourInvariant);
#! @EndGroup

#Section Rainbow colouring
    #construction: All..., SixfoldCover, (DoubleCover);


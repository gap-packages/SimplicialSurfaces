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

#! @Chapter Edge vari-colourings
#! @ChapterLabel EdgeVariColouring
#! 
#! In chapter <Ref Chap="Chapter_EdgeColouring"/> the concept of edge 
#! colourings was introduced in general. This chapter is concerned with
#! a specific type of edge colourings, where every edge of a given face has to
#! have a different colour (so it is varicoloured on each face).
#!
#! In section <Ref Sect="Section_EdgeVariColouring_Definition"/> 
#! the concept of the edge vari-colouring is defined. In addition,
#! some access
#! functions made possible by the colouring are described.
#!
#! Section <Ref Sect="Section_EdgeVariColouring_Permutations"/> represents
#! the edge vari-colouring of ramified polygonal complexes as permutations, the
#! <K>ColourInvolutions</K> (<Ref Subsect="ColourInvolutions"/>).
#!
#! After these general properties, section 
#! <Ref Sect="Section_EdgeVariColouring_Exact"/> deals with a special
#! subclass of a vari-colouring: <E>edge exact-colourings</E>, in
#! which the number of colours is minimal (for example, in a simplicial 
#! surface there can only be three colours). It describes a method to
#! uniquely reconstruct an exact-coloured surface from its permutation (by 
#! introducing the <E>local symmetries</E> 
#! (<Ref Subsect="LocalSymmetryOfEdges"/>)).
#!
#! Finally section TODO describes some methods to construct vari-coloured
#! and exact-coloured
#! surfaces.
#!

#! @Section Definition and elementary properties
#! @SectionLabel EdgeVariColouring_Definition
#! This section defines the concept of edge vari-colourings
#! (<Ref Subsect="IsEdgeVariColouring"/>) and introduces
#! the coloured versions of these methods:
#! * <K>ColouredEdgesOfFaces</K> (<Ref Subsect="ColouredEdgesOfFaces"/>) 
#!   extends <K>EdgesOfFaces</K> (<Ref Subsect="EdgesOfFaces"/>).
#TODO should we also implement NeighbourFaceByColour?
#! * <K>EdgeColouredUmbrellasOfVertices</K> 
#!   (<Ref Subsect="EdgeColouredUmbrellasOfVertices"/>) extends
#!   <K>UmbrellasOfVertices</K> (<Ref Subsect="UmbrellasOfVertices"/>).
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
#! section <Ref Sect="Section_EdgeVariColouring_Definition"/>.
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Prism_coloured.tex}
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
#! Consider the prism example from the start of section 
#! <Ref Sect="Section_EdgeVariColouring_Definition"/>.
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
    IsEdgeColouredPolygonalComplex and IsEdgeVariColouring );
#! @Arguments rbComp, face
DeclareOperation( "ColouredEdgesOfFace",
    [IsEdgeColouredPolygonalComplex and IsEdgeVariColouring, IsPosInt]);
#! @Arguments rbComp, face
DeclareOperation( "ColouredEdgesOfFaceNC",
    [IsEdgeColouredPolygonalComplex and IsEdgeVariColouring, IsPosInt]);
#! @EndGroup

#TODO implement EdgeColouredEdgeFacePaths as subcategory of EdgeFacePaths -> only difference is View??. Do we actually need this subcategory then?
#TODO for colouredEdgeFacePaths -> how to denote colours? we can use  a,b,c,d,e,... but is this better than the numbers of the colours?


#! @Section Permutation description
#! @SectionLabel EdgeVariColouring_Permutations
#!
#! While section <Ref Sect="Section_EdgeVariColouring_Definition"/> dealt
#! with general edge vari-colourings, this section is restricted to
#! edge vari-colourings of ramified polygonal surfaces. For those there are
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
#! ramified polygonal surface (<Ref Subsect="IsRamifiedPolygonalSurface"/>),
#! return the colour involutions. 
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
    IsEdgeColouredRamifiedPolygonalSurface and IsEdgeVariColouring);
#! @EndGroup

#TODO Is this relabelling ok?

#! @Section Edge exact colourings
#! @SectionLabel EdgeVariColouring_Exact
#!
#! While the previous sections dealt with general edge vari-colourings,
#! this section focuses exclusively on edge exact-coloured
#! simplicial surfaces, i.,e. simplicial surfaces whose edges are coloured
#! with three colours such that the edges of each face have different colours.
#!
#! In this situation there is an additional local symmetry structure on the
#! edges. For every inner edge (<Ref Subsect="InnerEdges"/>) there are two
#! possible colourings of the adjacent faces, which can be described by a 
#! symmetry with respect to the edge between them. The colours can either be
#! mirrored or rotated into each other.
#! <Alt Only="TikZ">
#!   \input{Image_LocalSymmetry.tex}
#! </Alt>
#! The first type is called <E>mirror</E> and the second one <E>rotation</E>.
#! Together with the <E>boundary</E>-type for the boundary edges
#! (<Ref Subsect="BoundaryEdges"/>) this defines the <K>LocalSymmetryOfEdges</K>
#! (<Ref Subsect="LocalSymmetryOfEdges"/>).
#!
#! Together with the edge colouring, the local symmetry determines the underlying
#! simplicial surface.

#! @BeginGroup LocalSymmetryOfEdges
#! @Description
#! Return the local symmetry of the edges in <A>colSurf</A>, i.e. whether the 
#! colours in the adjacent faces of a given inner edge are mirrored or rotated.
#!
#! TODO explanation
#!
#! TODO tests
#!
#! @Returns a list of strings
#! @Arguments colSurf
DeclareAttribute( "LocalSymmetryOfEdges", IsEdgeColouredSimplicialSurface and 
    IsEdgeExactColouring );
#! @Returns a list of positive integers
#! @Arguments colSurf
DeclareAttribute( "LocalSymmetryOfEdgesAsNumbers", IsEdgeColouredSimplicialSurface and 
    IsEdgeExactColouring );
#! @EndGroup


#! Of particular interest are those colourings where the local symmetry is equal
#! for each edge of the same colour.
#! @BeginGroup IsMRTypeColourInvariant
#! @Description
#! Return whether the local symmetry (<Ref Subsect="LocalSymmetryOfEdges"/>) is equal
#! for all edges of the same colour.
#!
#! The method <K>LocalSymmetryOfColours</K> returns a list of local symmetries that is
#! indexed by the colours.
#! 
#! TODO a lot of tests (how should this interact with other options?);
#! 
#! @Arguments colSurf
DeclareProperty( "IsMRTypeColourInvariant", IsEdgeColouredSimplicialSurface and 
    IsEdgeExactColouring);
#! @Returns a list of strings
#! @Arguments colSurf
DeclareAttribute( "LocalSymmetryOfColours", IsEdgeColouredSimplicialSurface and
    IsMRTypeColourInvariant);
#! @Returns a list of positive integers
#! @Arguments colSurf
DeclareAttribute( "LocalSymmetryOfColoursAsNumbers", IsEdgeColouredSimplicialSurface and
    IsMRTypeColourInvariant);
#! @EndGroup

#Section Rainbow colouring
    #construction: All..., SixfoldCover, (DoubleCover);


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

#! @Chapter Edge isosceles-colourings
#! @ChapterLabel EdgeIsoscelesColouring
#! 
#! In Chapter <Ref Chap="Chapter_EdgeColouring"/> the concept of edge 
#! colourings was introduced in general. This chapter is concerned with
#! a specific type of edge colourings, namely isosceles colourings.
#! For an isosceles colouring we colour the edges of a surface with
#! two colours, one which we call the <E>leg</E> colour and one we
#! call the <E>base</E> colour. The edges of every face are coloured 
#! such that two edges are coloured in the leg colour and one
#! in the base colour.
#!
#! In Section <Ref Sect="Section_EdgeTwoColouring_Definition"/>,
#! the concept of an edge two-colouring is defined. In addition,
#! functions to give access to information on the colours of edges
#! are described.
#!
#!
#! After these general properties, Section 
#! <Ref Sect="Section_EdgeIsoscelesColouring_Wild"/> deals with a special
#! subclass of a two-colouring for simplicial surfaces:
#! <E>edge isosceles-colourings</E>. An edge isosceles coloured simplicial
#! surface is a two-coloured simplicial surface such that one of these
#! two colours is the colour of two edges of each face.
#! It describes a method to
#! uniquely reconstruct an exact-coloured surface from its permutation (by 
#! introducing the <E>local symmetries</E> 
#! (<Ref Subsect="LocalSymmetryOfEdgesTwoCol"/>)).
#!
#! Section <Ref Sect="Section_EdgeIsoscelesColouring_Permutations"/> represents
#! the edge isosceles-colouring of simplicial surfaces
#! as permutations, the
#! <K>ColourInvolutions</K> (<Ref Subsect="ColourInvolutionsTwoCol"/>) of
#! the wild coloured surface obtained by subdividing each face into two
#! such that the two leg coloured edges lie in different faces.
#!
#!
#! Section <Ref Sect="Section_EdgeIsoscelesColouring_Wild"/> also
#! describes some methods to construct isosceles-coloured
#! simplicial surfaces.
#!

#! @Section Definition and elementary properties
#! @SectionLabel EdgeTwoColouring_Definition
#! This section defines the concept of edge two-colourings
#! (<Ref Subsect="IsEdgeTwoColouring"/>) and introduces
#! the coloured version of this method:
#! * <K>ColouredEdgesOfFaces</K> (<Ref Subsect="ColouredEdgesOfFacesTwoCol"/>) 
#!   extends <K>EdgesOfFaces</K> (<Ref Subsect="EdgesOfFaces"/>).
#! 
#! @InsertChunk Example_ColouredCube


#! @BeginGroup IsEdgeTwoColouring
#! @Description
#! The property <K>IsEdgeTwoColouring</K> applies to edge-coloured polygonal
#! complexes. It checks if the edges of each face are two-coloured by the
#! given edge colouring.
#! This is the case if and only if there are two colours such that
#! all edges of each face have one of these two colours and both colours
#! occur among the edges of each face.
#!
#! We illustrate this on the cube that was introduced at the start of
#! Section <Ref Sect="Section_EdgeTwoColouring_Definition"/>.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Cube_twocoloured-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Cube_twocoloured.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! The given edge colouring is a two-colouring.
#! @BeginExampleSession
#! gap> EdgesOfColours( colCube );
#! [ [ 1, 5, 6, 7, 8, 10 ], [ 2, 3, 4, 9, 11, 12 ] ]
#! gap> IsEdgeTwoColouring( colCube );
#! true
#! @EndExampleSession
#! 
#! @Arguments colComplex
DeclareProperty("IsEdgeTwoColouring", IsEdgeColouredPolygonalComplex);
#! @EndGroup


#! @BeginGroup ColouredEdgesOfFacesTwoCol
#! @Description
#! For an edge two-coloured polygonal complex
#! the method <K>ColouredEdgesOfFace</K>(<A>rbComp</A>, <A>face</A>) returns a
#! list <M>L</M> such that <M>L[i]</M> is a list of all incident edges
#! of <A>face</A> with colour <E>i</E>.
#! The NC-version does not check whether the given <A>face</A>
#! is an actual face of the coloured complex.
#!
#! The attribute <K>ColouredEdgesOfFaces</K> collects all of these lists in 
#! a list indexed by the face labels, i.e.
#! <K>ColouredEdgesOfFaces</K>(<A>rbComp</A>)[<A>face</A>] =
#! <K>ColouredEdgesOfFace</K>(<A>rbComp</A>, <A>face</A>). All other positions
#! are unbound.
#!
#! Consider the cube example from the start of Section 
#! <Ref Sect="Section_EdgeTwoColouring_Definition"/>.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Cube_twocoloured-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Cube_twocoloured.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> ColoursOfEdges(colCube);
#! [ 1, 2, 2, 2, 1, 1, 1, 1, 2, 1, 2, 2 ]
#! gap> ColouredEdgesOfFace(colCube, 1);
#! [ [ 1 ], [ 2, 3, 4 ] ]
#! gap> ColouredEdgesOfFace(colCube, 4);
#! [ [ 7, 8 ], [ 4, 11 ] ]
#! gap> ColouredEdgesOfFaces(colCube);
#! [ [ [ 1 ], [ 2, 3, 4 ] ], [ [ 1, 5, 8 ], [ 12 ] ], [ [ 5, 6 ], [ 2, 9 ] ],
#! [ [ 7, 8 ], [ 4, 11 ] ],   [ [ 6, 7, 10 ], [ 3 ] ], [ [ 10 ], [ 9, 11, 12 ] ] ]
#! @EndExampleSession
#!
#! @Returns a list of lists of positive integers
#! @Arguments rbComp
DeclareAttribute( "ColouredEdgesOfFaces", 
    IsEdgeColouredPolygonalComplex and  IsEdgeTwoColouring );
#! @Arguments rbComp, face
DeclareOperation( "ColouredEdgesOfFace",
    [IsEdgeColouredPolygonalComplex and IsEdgeTwoColouring, IsPosInt]);
#! @Arguments rbComp, face
DeclareOperation( "ColouredEdgesOfFaceNC",
    [IsEdgeColouredPolygonalComplex and IsEdgeTwoColouring, IsPosInt]);
#! @EndGroup


#! @Section Isosceles coloured surfaces
#! @SectionLabel EdgeIsoscelesColouring_Wild
#!
#! While the previous sections dealt with general edge two-colourings,
#! this section focuses exclusively on edge two-coloured
#! simplicial surfaces. Moreover, we require that the simplicial surfaces
#! are <E>isosceles-coloured</E>.
#! For an isosceles colouring we colour the edges of a surface in
#! two colours, one which we call the <E>leg</E> colour and one we
#! call the <E>base</E> colour. The edges of every face are coloured 
#! such that two edges are coloured in the leg colour and one
#! in the base colour.

#! Since these are quite important structures, we will denote them by
#! <E>isosceles-coloured surfaces</E> (<Ref Subsect="IsIsoscelesColouredSurface"/>).
#!
#! In this situation there is an additional local symmetry structure on the
#! edges. For every leg coloured edge (<Ref Subsect="InnerEdges"/>) there are two
#! possible colourings of the adjacent faces, which can be described by a 
#! symmetry with respect to the edge between them. The colours can either be
#! mirrored or rotated into each other. For every base coloured edge, the
#! local symmetry is mirrored.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_LocalLegSymmetry-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_LocalLegSymmetry.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! The first type is called <E>mirror</E> and the second one <E>rotation</E>.
#! Together with the <E>boundary</E>-type for the boundary edges
#! (<Ref Subsect="BoundaryEdges"/>) this defines the <K>LocalSymmetryOfEdges</K>
#! (<Ref Subsect="LocalSymmetryOfEdgesTwoCol"/>).
#!

#! @BeginGroup IsIsoscelesColouredSurface
#! @Description
#! Check if an edge-coloured polygonal complex is an
#! <E>isosceles-coloured surface</E>, i.e.
#! * It is a simplicial surface (<Ref Subsect="IsSimplicialSurface"/>)
#! * It has an edge-two colouring (<Ref Subsect="IsEdgeTwoColouring"/>),
#!   i.e. the edges are coloured by two colours
#! * if one face has two edges of a particular colour,  then so do all faces

#! @InsertChunk Example_IsoscelesOctahedron

#!
#! @Arguments colSurf
DeclareProperty( "IsIsoscelesColouredSurface", IsEdgeColouredPolygonalComplex);
#! @Arguments object
#! @EndGroup
InstallTrueMethod( IsEdgeColouredSimplicialSurface, IsIsoscelesColouredSurface );


#! @Section Functions for isosceles coloured Simplicial Surfaces
#! @SectionLabel Isosceles_Useful
#!
#! This section describes some usful functions for isosceles coloured
#! Simplicial surfaces
#!
#! @BeginGroup ApexVertexOfFace
#! @Description
#! For an isosceles coloured surface (<Ref Subsect="IsIsoscelesColouredSurface"/>) the method 
#! <K>ApexVertexOfFace</K>(<A>isosSurf</A>, <A>face</A>) returns the 
#! vertex at the apex of the face <A>face</A>. The
#! apex vertex of a face is the vertex which is
#! incident to two leg coloured edges of the face.
#!
#! @Returns a positive integer
#! @Arguments isosSurf, face
DeclareOperation( "ApexVertexOfFace", [IsIsoscelesColouredSurface, IsPosInt] );
#! @EndGroup
#! Consider the example of the isosceles coloured octahedron from the start of Section 
#! <Ref Sect="Section_Isosceles_Useful"/>.
#! @BeginExampleSession
#! gap> oct := Octahedron();;
#! gap> colOct := EdgeColouredPolygonalComplex( oct, [1,1,1,1,2,2,1,2,1,2,1,1]);;
#! gap> ApexVertexOfFace( colOct, 4 ); 
#! 6
#! @EndExampleSession

#! @BeginGroup BaseEdgeOfFace
#! @Description
#! For an isosceles coloured surface (<Ref Subsect="IsIsoscelesColouredSurface"/>) the method 
#! <K>BaseEdgeOfFace</K>(<A>isosSurf</A>, <A>face</A>) returns the 
#! edge of the face which is coloured in the base
#! colour. In particular  the face <A>face</A> has one incident edge in the base colour
#! and two in the leg colour.
#! @Returns a positive integer
#! @Arguments isosSurf, face
#!
DeclareOperation( "BaseEdgeOfFace", [IsIsoscelesColouredSurface, IsPosInt] );
#! @EndGroup
#! Consider the example of the isosceles coloured octahedron from the start of Section 
#! <Ref Sect="Section_Isosceles_Useful"/>.
#! @BeginExampleSession
#! gap> oct := Octahedron();;
#! gap> colOct := EdgeColouredPolygonalComplex( oct, [1,1,1,1,2,2,1,2,1,2,1,1]);;
#! gap> BaseEdgeOfFace( colOct, 4 ); 
#! 5
#! @EndExampleSession




#! @BeginGroup ColouredUmbrellasOfVerticesTwoCol
#! @Description
#! For an isosceles coloured surface (<Ref Subsect="IsIsoscelesColouredSurface"/>) the method 
#! <K>ColouredUmbrellaOfVertex</K>(<A>isosSurf</A>, <A>vertex</A>) returns an edge-coloured 
#! edge-face path for the umbrella-path around <A>vertex</A>. All of these 
#! umbrella-paths
#! are collected in the attribute
#! <K>ColouredUmbrellasOfVertices</K>(<A>isosSurf</A>), i.e.
#! <K>ColouredUmbrellasOfVertices</K>(<A>isosSurf</A>)[<A>vertex</A>]
#! = <K>ColouredUmbrellaOfVertex</K>(<A>isosSurf</A>, <A>vertex</A>).
#!
#! This method extends <K>UmbrellaPathsOfVertices</K> 
#! (<Ref Subsect="UmbrellaPathsOfVertices"/>). The edge-coloured edge-face-paths
#! behave exactly as regular edge-face-paths but are displayed differently.
#! 
#! The NC-version does not check whether the given <A>vertex</A> actually
#! is a vertex of <A>isosSurf</A>.
#!
#! @Returns a list of coloured edge-face-paths
#! @Arguments isosSurf
DeclareAttribute( "ColouredUmbrellasOfVertices", IsIsoscelesColouredSurface );
#! @Returns a coloured edge-face-path
#! @Arguments isosSurf, vertex
DeclareOperation( "ColouredUmbrellaOfVertex", [IsIsoscelesColouredSurface, IsPosInt] );
#! @Returns a coloured edge-face-path
#! @Arguments isosSurf, vertex
DeclareOperation( "ColouredUmbrellaOfVertexNC", [IsIsoscelesColouredSurface, IsPosInt] );
#! @EndGroup
#! Consider the example of the isosceles coloured octahedron from the start of section 
#! <Ref Sect="Section_Isosceles_Useful"/>.
#! @BeginExampleSession
#! gap> oct := Octahedron();;
#! gap> colOct := EdgeColouredPolygonalComplex( oct, [1,1,1,1,2,2,1,2,1,2,1,1]);;
#! gap> ColouredUmbrellasOfVertices( colOct );
#! [ ( e1, F1, e2, F7, e3, F5, e4, F3, e1 )
#!     , ( e1, F1, e5, F4, e7, F2, e6, F3, e1 )
#!     , ( e2, F1, e5, F4, e9, F6, e8, F7, e2 )
#!     , ( e3, F5, e10, F8, e11, F6, e8, F7, e3 )
#!     , ( e4, F3, e6, F2, e12, F8, e10, F5, e4 )
#!     , 
#!   ( e7, F2, e12, F8, e11, F6, e9, F4, e7 ) 
#!  ]
#! @EndExampleSession
#! QUESTION: HOW DO W GET THE COLOURS DISPLAYED? (Need to ask Frank)

#! @Section Permutation description
#! @SectionLabel EdgeIsoscelesColouring_Permutations
#!
#! For an isosceles coloured simplicial surface, the edges of each face are coloured
#! in one of two colours, the <A>leg</A> colour and the <A>base</A> colour, such that
#! two edges are coloured in the leg colour and one in the base colour. 
#!
#! Therefore the base coloured edges can be interpreted as an involution on the set of 
#! faces, interchanging two faces incident to  a given base coloured edge. We 
#! need to subdivide the faces in order to be able to interpret the
#! leg coloured edges as involutions. This yields a wild coloured surface on twice the
#! number of faces, see (<Ref Subsect="IsWildColouredSurface"/>).
#!

#! @BeginGroup WildColouredSurfaceOfIsoscelesColouredSurface
#! @Description
#! From an edge isosceles-coloured simplicial surface
#! (<Ref Subsect="IsIsoscelesColouredSurface"/>) one can obtain a
#! wild coloured simplicial surface (<Ref Subsect="IsWildColouredSurface"/>) on twice
#! the number of faces by subdividing each triangle by an edge through the apex
#! and the midpoint of the base. It is constructed as follows:
#!
#! Let <E>m</E> denote the maximum value of a face-name in <A>isosSurf</A>.
#! A new edge passes from the apex of a face <E>F</E> to the mid point of the
#! base edge of <E>F</E> and thus each face <E>F</E> of <A>isosSurf</A>
#! is subdivided into two faces, namely <E> F</E> and <E> m + F</E>.
#! We use the convention that <E>F</E> is incident to the smaller vertex
#! of the base edge and <E>m+F</E> is incident to the larger vertex
#! of the base edge.
#!
#! @InsertChunk Example_WildIsosceles 
#! 
#! @Arguments isosSurf
#! @Returns a wild coloured simplicial surface on twice the number of faces
DeclareAttribute( "WildColouredSurfaceOfIsoscelesColouredSurface", IsIsoscelesColouredSurface );
#! @EndGroup


#! @BeginGroup ColourInvolutionsTwoCol
#! @Description
#! For an edge isosceles-coloured simplicial surface
#! (<Ref Subsect="IsIsoscelesColouredSurface"/>) 
#! return the colour involutions of the edge-wild-coloured surface
#! obtained by subdividing each triangle by an edge through the apex
#! and the midpoint of the base, constructed by 
#! <A>WildColouredSurfaceOfIsoscelesColouredSurface</A>
#! (<Ref Subsect="WildColouredSurfaceOfIsoscelesColouredSurface"/>).
#!
#! The attribute <K>ColourInvolutions</K>(<A>isosSurf</A>) returns a list
#! of three involutions. These involutions are the colour involutions of
#! a wild-coloured simplicial surface obtained as follows:
#! The three
#! colours arise by colouring the subdivided base edges in the colour of the
#! original base edges, the leg edges in the colour of the original leg
#! edges and the new edges introduced by the subdivision in a third colour. The
#! colour involutions of this latter wild coloured surface are the
#! colour involutions associated to <A>isosSurf</A>. The involutions are
#! arranged in such a way that the first two involutions correspond to the
#! involutions of the subdivided base edges and leg edges, according to their
#! positions in ColoursOfEdges and the last involution corresponds to the
#! edges introduced by the subdivision. Thereby, the colour
#! involutions encode the  neighbouring relations of the faces
#! of the subdivided wild coloured surface that is induced by the edges of the colour. A 
#! boundary edge induces a fixed point.
#! 
#! @InsertChunk Example_Isosceles_ColourInvolutions
#! @Returns a list of involutions
#! @Arguments isosSurf
DeclareAttribute("ColourInvolutions", IsIsoscelesColouredSurface);
#! @EndGroup




#! @BeginGroup LocalSymmetryOfEdgesTwoCol
#! @Description
#! Return the local symmetry of the edges in <A>colSurf</A>, i.e. whether the 
#! colours in the adjacent faces of a given inner edge are mirrored or rotated.
#!
#! The edges of the isosceles coloured surface <A>colSurf</A> have a local 
#! symmetry. For every inner leg coloured edge (<Ref Subsect="InnerEdges"/>) there are two
#! possible colourings of the adjacent faces, which can be described by a 
#! symmetry with respect to the edge between them. The colours can either be
#! mirrored or rotated into each other. For every inner base coloured edge, the
#! local symmetry is mirrored.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_LocalLegSymmetry-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_LocalLegSymmetry.pdf}
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
#! gap> oct := AllIsoscelesColouredSurfaces(oct);;
#! gap> LocalSymmetryOfEdges(oct[2]);
#!  [ "rotation", "mirror", "rotation", "mirror", "mirror", "mirror",
#!  "rotation", "mirror", 
#!    "mirror", "mirror", "rotation", "mirror" ]
#! @EndExampleSession
#!
#! Here is an example of a surface with boundary:
#! @BeginExampleSession
#! gap> fourGon := SimplicialSurfaceByDownwardIncidence(
#! >        [[1,2],[1,3],[1,4],[1,5],[2,3],[3,4],[4,5],[2,5]], 
#! >         [[1,2,5],[2,3,6],[3,4,7],[1,4,8]] );;
#! gap> fiw := AllIsoscelesColouredSurfaces(fourGon);;
#! gap> LocalSymmetryOfEdges( fiw[1] );
#! [ "mirror", "mirror", "mirror", "mirror", "boundary", "boundary", "boundary", "boundary" 
#!  ]
#! @EndExampleSession
#! @Returns a list of strings
#! @Arguments colSurf
DeclareAttribute( "LocalSymmetryOfEdges", IsIsoscelesColouredSurface );
#! @Returns a list of positive integers
#! @Arguments colSurf
DeclareAttribute( "LocalSymmetryOfEdgesAsNumbers", IsIsoscelesColouredSurface ); 
#! @EndGroup


#! @BeginGroup AllIsoscelesColouredSurfaces
#! @Description
#! This method computes all isosceles-coloured surfaces up to isomorphism
#! based for a given simplicial surface (<Ref Subsect="IsSimplicialSurface"/>).
#! If the optional parameter <A>noIsom</A> is set to false, the method computes all
#! isosceles-coloured surfaces. This means the returned list contains
#! isomorphic edge-coloured surfaces. By default, <A>noIsom</A> is true.
#!
#! @Returns a list of isosceles-coloured surfaces 
#! @Arguments simpSurf [, noIsom]
DeclareOperation( "AllIsoscelesColouredSurfaces", [IsSimplicialSurface, IsBool] );
#! @EndGroup
#! @InsertChunk Example_All_Isosceles 

#! @BeginGroup VertexCounterByAngle
#! @Description
#! The function VertexCounterByAngle is a refinement of the function
#! VertexCounter: For an edge coloured simplicial surface which is either
#! edge vari-coloured or isosceles coloured it determines
#! for every vertex how many faces are incident to that vertex at a given
#! angle. In both cases, the angle of a face at a particular vertex is determined by
#! the colour of the opposite edge. The function VertexCounterByAngle returns a
#! list. The entries of this lists are lists of the form <A>[s,i]</A>, where 
#! <A>i</A> is a number counting how often the vertex angle described by the 
#! list <A>s</A> is encountered.
#! The entry <A>s</A> is itself a list which describes the angles around a vertex by
#! recording pairs <A>[a,j],</A> where <A>a</A> is the colour of an edge opposite 
#! the vertex and
#! <A>j</A> counts how many times this angle was counted.
#! @Returns a list 
#! @Arguments colSimSurf
DeclareOperation( "VertexCounterByAngle", [IsEdgeColouredSimplicialSurface]);
#! @EndGroup
#! @InsertChunk Example_IsoscelesIcosahedron
##

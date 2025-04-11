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

#! @Chapter Flags
#! @ChapterLabel Flags
#! 
#! This chapter is concerned with the <E>flags</E> of a polygonal complex. 
#! A flag is a triple <M>(V,E,F)</M> of vertex <M>V</M>, an edge <M>E</M>,
#! and a face <M>F</M> that are incident to each other. They can be computed
#! with the command <K>Flags</K> (<Ref Subsect="Flags"/>).
#! The chambers (<Ref Sect="Section_AccessTwisted_Adjacency"/>) for a polygonal complex are equivalent
#! to the flags of the polygonal complex
#!
#! The elementary flag access functions are described in section
#! <Ref Sect="Section_Flags_Definition"/>.
#!
#! Section <Ref Sect="Section_Flags_DressGroup"/> uses the knowledge of the 
#! flags to compute the <K>DressGroup</K>
#! (<Ref Subsect="DressInvolutions"/>)
#! of a polygonal complex without edge ramifications.
#!
#! In Section <Ref Sect="Section_Flags_FlagComplex"/> defines a triangular
#! complex whose faces are given by the flags and describes some special
#! functionality for these kinds of complexes.
#!

#! @Section Computation
#! @SectionLabel Flags_Definition
#!
#! This section deals with all different types of flags. In general, a flag
#! is a tuple consisting of incident elements of different dimensions, for
#! example a vertex-edge-pair, a vertex-face-pair or a 
#! vertex-edge-face-triple.
#! 
#! For example, consider the following polygonal surface:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> complex := PolygonalComplexByDownwardIncidence( 
#! >    [ , , , , , [2,5], , [2,3], [3,5], [11,5], , [3,7], [7,11] ], 
#! >    [[6,8,9], , , [9,10,12,13]]);;
#! @EndExampleSession
#!
#! Most apparent are the flags that consist of a vertex, an edge, and a face,
#! called <E>3-flags</E> or <E>flags</E> for short.
#! @BeginExampleSession
#! gap> ThreeFlags(complex);
#! [ [ 2, 6, 1 ], [ 2, 8, 1 ], [ 3, 8, 1 ], [ 3, 9, 1 ], [ 3, 9, 4 ], 
#!   [ 3, 12, 4 ], [ 5, 6, 1 ], [ 5, 9, 1 ], [ 5, 9, 4 ], [ 5, 10, 4 ],
#!   [ 7, 12, 4 ], [ 7, 13, 4 ], [ 11, 10, 4 ], [ 11, 13, 4 ]]
#! gap> Flags(complex) = last;
#! true
#! @EndExampleSession
#!
#! It is also possible to compute flags of length 2, for example the
#! vertex-face-flags:
#! @BeginExampleSession
#! gap> VertexFaceFlags(complex);
#! [ [ 2, 1 ], [ 3, 1 ], [ 3, 4 ], [ 5, 1 ], [ 5, 4 ], [ 7, 4 ], [ 11, 4 ] ]
#! @EndExampleSession
#!
#! Sometimes it is necessary to have a standardized set of all flags that
#! consist of two elements. For that reason the command <K>TwoFlags</K>
#! (<Ref Subsect="TwoFlags"/>) exists.
#!
#! Since flags of length 1 are just vertices, edges, and faces, the usual
#! access functions of Section <Ref Sect="Section_Access_LabelAccess"/> are 
#! sufficient most of the time. If they are needed in a combined format,
#! the command <K>OneFlags</K> (<Ref Subsect="OneFlags"/>) is available.
#!

#! @BeginGroup Flags
#! @Description
#! Return the set of all flags of <A>complex</A>. Every flag is a triple
#! [<A>vertex</A>,<A>edge</A>,<A>face</A>] of a vertex, an edge and a face
#! of <A>complex</A> that are all incident to each other.
#!
#! As an example consider the polygonal surface from the start of section 
#! <Ref Sect="Section_Flags_Definition"/>.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> Flags(complex);
#! [ [ 2, 6, 1 ], [ 2, 8, 1 ], [ 3, 8, 1 ], [ 3, 9, 1 ], [ 3, 9, 4 ], 
#!   [ 3, 12, 4 ], [ 5, 6, 1 ], [ 5, 9, 1 ], [ 5, 9, 4 ], [ 5, 10, 4 ],
#!   [ 7, 12, 4 ], [ 7, 13, 4 ], [ 11, 10, 4 ], [ 11, 13, 4 ]]
#! gap> Flags(complex) = ThreeFlags(complex);
#! true
#! @EndExampleSession
#!
#! @Returns a set of flags
#! @Arguments complex
DeclareAttribute( "Flags", IsPolygonalComplex );
#! @Arguments complex
DeclareAttribute( "ThreeFlags", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup VertexEdgeFlags
#! @Description
#! Return the set of all vertex-edge-flags of <A>complex</A>. Such a flag
#! is a tuple [<A>vertex</A>, <A>edge</A>] of a vertex and an edge of
#! <A>complex</A> that are incident.
#!
#! As an example consider the polygonal surface from the start of section 
#! <Ref Sect="Section_Flags_Definition"/>.
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_flags-1-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_flags-1.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> VertexEdgeFlags(complex);
#! [ [ 2, 6 ], [ 2, 8 ], [ 3, 8 ], [ 3, 9 ], [ 3, 12 ], [ 5, 6 ], 
#!   [ 5, 9 ], [ 5, 10 ], [ 7, 12 ], [ 7, 13 ], [ 11, 10 ], [ 11, 13 ] ]
#! @EndExampleSession
#!
#! @Returns a set of vertex-edge-flags
#! @Arguments complex
DeclareAttribute( "VertexEdgeFlags", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup VertexFaceFlags
#! @Description
#! Return the set of all vertex-face-flags of <A>complex</A>. Such a flag
#! is a tuple [<A>vertex</A>, <A>face</A>] of a vertex and a face of
#! <A>complex</A> that are incident.
#!
#! As an example consider the polygonal surface from the start of section 
#! <Ref Sect="Section_Flags_Definition"/>.
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_flags-2-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_flags-2.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> VertexFaceFlags(complex);
#! [ [ 2, 1 ], [ 3, 1 ], [ 3, 4 ], [ 5, 1 ], [ 5, 4 ], [ 7, 4 ], [ 11, 4 ] ]
#! @EndExampleSession
#!
#! @Returns a set of vertex-face-flags
#! @Arguments complex
DeclareAttribute( "VertexFaceFlags", IsPolygonalComplex );
#! @EndGroup 

#! @BeginGroup EdgeFaceFlags
#! @Description
#! Return the set of all edge-face-flags of <A>complex</A>. Such a flag
#! is a tuple [<A>edge</A>, <A>face</A>] of an edge and a face of
#! <A>complex</A> that are incident.
#!
#! As an example consider the polygonal surface from the start of section 
#! <Ref Sect="Section_Flags_Definition"/>.
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_flags-3-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_flags-3.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> EdgeFaceFlags(complex);
#! [ [ 6, 1 ], [ 8, 1 ], [ 9, 1 ], [ 9, 4 ], [ 10, 4 ], [ 12, 4 ], [ 13, 4 ] ]
#! @EndExampleSession
#!
#! @Returns a set of edge-face-flags
#! @Arguments complex
DeclareAttribute( "EdgeFaceFlags", IsPolygonalComplex );
#! @EndGroup


#! @BeginGroup TwoFlags
#! @Description
#! Return a set of all flags of length 2, i.e. all pairs of vertices, edges
#! and faces that are incident to each other. Since the labels of vertices
#! edges and faces might overlap, special care has to be taken to make sure
#! that every entry of the returned set corresponds to exactly one flag
#! of length 2.
#!
#! If it is not necessary to have all of the different flags in one set, one
#! should use the methods <K>VertexEdgeFlags</K> 
#! (<Ref Subsect="VertexEdgeFlags"/>), <K>VertexFaceFlags</K> 
#! (<Ref Subsect="VertexFaceFlags"/>) and <K>EdgeFaceFlags</K>
#! (<Ref Subsect="EdgeFaceFlags"/>) instead.
#!
#! To make the flags of different types disjoint in the result, every flag
#! is wrapped into a pair containing an index and the flag:
#! * The vertex-edge-flag [<A>vertex</A>,<A>edge</A>] is wrapped into
#!   [ 1, [<A>vertex</A>, <A>edge</A>] ].
#! * The vertex-face-flag [<A>vertex</A>,<A>face</A>] is wrapped into
#!   [ 2, [<A>vertex</A>, <A>face</A>] ].
#! * The edge-face-flag [<A>edge</A>,<A>face</A>] is wrapped into
#!   [ 3, [<A>edge</A>, <A>face</A>] ].
#!
#! As an example consider the polygonal surface from the start of section 
#! <Ref Sect="Section_Flags_Definition"/>.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> TwoFlags(complex);
#! [ [ 1, [ 2, 6 ] ], [ 1, [ 2, 8 ] ], [ 1, [ 3, 8 ] ], [ 1, [ 3, 9 ] ], 
#!   [ 1, [ 3, 12  ] ], [ 1, [ 5, 6 ] ], [ 1, [ 5, 9 ] ], [ 1, [ 5, 10  ] ], 
#!   [ 1, [ 7, 12 ] ], [ 1, [ 7, 13 ] ], [ 1, [ 11, 10 ] ], [ 1, [ 11, 13 ] ],
#!   [ 2, [ 2, 1 ] ], [ 2, [ 3, 1 ] ], [ 2, [ 3, 4 ] ], [ 2, [ 5, 1 ] ], 
#!   [ 2, [ 5, 4 ] ], [ 2, [ 7, 4 ] ], [ 2, [ 11, 4 ] ], [ 3, [ 6, 1 ] ], 
#!   [ 3, [ 8, 1 ] ], [ 3, [ 9, 1 ] ], [ 3, [ 9, 4 ] ], [ 3, [ 10, 4 ] ], 
#!   [ 3, [ 12, 4 ] ], [ 3, [ 13, 4 ] ] ]
#! @EndExampleSession
#! 
#! @Returns a set of wrapped two-flags
#! @Arguments complex
DeclareAttribute( "TwoFlags", IsPolygonalComplex );
#! @EndGroup


#! @BeginGroup OneFlags
#! @Description
#! Return a set of all flags of length 1, i.e. all vertices, edges
#! and faces. Since the labels of vertices
#! edges and faces might overlap, special care has to be taken to make sure
#! that every entry of the returned set corresponds to exactly one of them.
#!
#! For that reason vertices, edges and faces are wrapped into a list:
#! * The vertex <A>v</A> is wrapped into [ 0, <A>v</A> ].
#! * The edge <A>e</A> is wrapped into [ 1, <A>e</A> ].
#! * The face <A>f</A> is wrapped into [ 2, <A>f</A> ].
#!
#! As an example consider the polygonal surface from the start of section 
#! <Ref Sect="Section_Flags_Definition"/>.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> OneFlags(complex);
#! [ [ 0, 2 ], [ 0, 3 ], [ 0, 5 ], [ 0, 7 ], [ 0, 11 ], [ 1, 6 ], [ 1, 8 ],
#!   [ 1, 9 ], [ 1, 10 ], [ 1, 12 ], [ 1, 13 ], [ 2, 1 ], [ 2, 4 ] ]
#! @EndExampleSession
#! 
#! @Returns a set of wrapped one-flags
#! @Arguments complex
DeclareAttribute( "OneFlags", IsPolygonalComplex );
#! @EndGroup



#! @Section Dress group
#! @SectionLabel Flags_DressGroup
#!
#! While flags can be defined for any polygonal complex (as was done in
#! section <Ref Sect="Section_Flags_Definition"/>), they have additional
#! structure for polygonal complexes without edge ramifications.
#! <Enum>
#!   <Item>For every flag <M>[v,e,f]</M> there is exactly one other vertex 
#!         <M>X</M> such that <M>[X,e,f]</M> is also a flag.</Item>
#!   <Item>For every flag <M>[v,e,f]</M> there is exactly one other edge
#!         <M>X</M> such that <M>[v,X,f]</M> is also a flag.</Item>
#!   <Item>For every flag <M>[v,e,f]</M> there is <E>at most</E> one other
#!         face <M>X</M> such that <M>[v,e,X]</M> is also a flag.</Item>
#! </Enum>
#! Each of these observations divides the flags into partitions of at most
#! two elements. Therefore it possible to define involutions that swap these
#! elements. They are called <E>Dress involutions</E>.
#!
#! To represent them in &GAP; the flags have to be encoded as positive 
#! integers. The set of flags from <K>Flags</K> (<Ref Subsect="Flags"/>)
#! serves this purpose: Every flag is identified with its position in this
#! set.

#! @BeginGroup DressInvolutions
#! @Description
#! Return the three <E>Dress involutions</E> of <A>complex</A> as a list
#! or as the generators of a group. The Dress involutions act on the set
#! of flags of <A>complex</A>.
#!
#! The flags of <A>complex</A> are identified with their position in the
#! set <K>Flags</K>(<A>complex</A>). Assuming this identification the 
#! Dress involutions are defined as follows:
#! <Enum>
#!   <Item>The first Dress involution maps the flag <M>[v,e,f]</M> to
#!         the flag <M>[X,e,f]</M> where <M>X</M> is the unique vertex
#!         different from <M>v</M> such that <M>[X,e,f]</M> is a flag.
#!     </Item>
#!   <Item>The second Dress involution maps the flag <M>[v,e,f]</M> to
#!         the flag <M>[v,X,f]</M> where <M>X</M> is the unique edge
#!         different from <M>e</M> such that <M>[v,X,f]</M> is a flag.
#!     </Item>
#!   <Item>The third Dress involution maps the flag <M>[v,e,f]</M> to
#!         the flag <M>[v,e,X]</M> if there is a face <M>X</M> different
#!         from <M>f</M> such that <M>[v,e,X]</M> is a flag. Otherwise
#!         it fixes this flag.
#!     </Item>
#! </Enum>
#! If <K>DressGroup</K> is called, its generators <M>G.1</M>, <M>G.2</M>
#! and <M>G.3</M> are the Dress involutions.
#!
#! As an example consider the following polygonal surface:
#! @BeginExampleSession
#! gap> complex := PolygonalComplexByDownwardIncidence(
#! >    [ , , , , , [2,5], , [2,3], [3,5], [11,5], , [3,7], [7,11] ],
#! >    [[6,8,9], , , [9,10,12,13]]);;
#! @EndExampleSession
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> dressInv:=DressInvolutions(complex);
#! [ (1,7)(2,3)(4,8)(5,9)(6,11)(10,13)(12,14),
#!   (1,2)(3,4)(5,6)(7,8)(9,10)(11,12)(13,14),
#!   (4,5)(8,9) ]
#! gap> Flags(complex)[1];
#! [2,6,1]
#! gap> Flags(complex)[7];
#! [5,6,1]
#! @EndExampleSession
#! This means, for example, that the first dress involution maps the flag <M>[2,6,1]</M> to the flag <M>[5,6,1]</M>.
#! The dress involutions are equal to the adjacency involution acting on the chamber:
#! @BeginExampleSession
#! gap> dressInv[1]=ZeroAdjacencyInvolution(complex);
#! true
#! gap> dressInv[2]=OneAdjacencyInvolution(complex);
#! true
#! gap> dressInv[3]=TwoAdjacencyInvolution(complex);
#! true
#! @EndExampleSession
#! 
#! @Returns a list of three involutions
#! @Arguments complex
DeclareAttribute( "DressInvolutions", IsPolygonalComplex and IsNotEdgeRamified );
#! @Returns a group
#! @Arguments complex
DeclareAttribute( "DressGroup", IsPolygonalComplex and IsNotEdgeRamified );

#! @Section Flag complex / Barycentric subdivision
#! @SectionLabel Flags_FlagComplex
#!
#! The flags of a polygonal complex can be used to define a subdivision of
#! the polygonal complex, where each face is split into several triangles.
#! <Enum>
#!   <Item>The vertices are given by the <K>OneFlags</K> 
#!         (<Ref Subsect="OneFlags"/>), i.e. there is a new vertex for every
#!         original vertex, in the middle of each edge and in the center
#!         of gravity for each face.</Item>
#!   <Item>The edges are given by the <K>TwoFlags</K>
#!         (<Ref Subsect="TwoFlags"/>), e.g. for each incident
#!          edge-face-pair there is a new edge between the middle
#!          of the edge and the center of gravity of the face. There
#!          are also new edges for the vertex-edge- and vertex-face-pairs.</Item>
#!   <Item>The faces are given by the <K>ThreeFlags</K> 
#!         (<Ref Subsect="Flags"/>), i.e. for every flag <M>(V,E,F)</M>
#!          there is a new face between <M>V</M>, the middle of <M>E</M>
#!          and the center of gravity of <M>F</M>.</Item>
#! </Enum>
#! 
#! @InsertChunk Example_FlagComplex
#!
#! The flag complex is an edge coloured triangular complex. The polygonal
#! hierarchy (compare to chapter 
#! <Ref Chap="PolygonalStructures"/>) is unchanged otherwise, e.g. the flag 
#! complex of a 
#! polygonal complex is always a simplicial surface.
#!
#! For the flag complex of a polygonal complex without edge ramifications 
#! the Dress involutions
#! (<Ref Subsect="DressInvolutions"/>) are the colour involutions for the
#! colouring (compare <Ref Subsect="ColourInvolutions"/>).

#! @BeginGroup FlagComplex
#! @Description
#! Return the flag complex of <A>complex</A>. The flag complex is an
#! edge-coloured (<Ref Chap="Chapter_EdgeColouring"/>) twisted triangular complex
#! (<Ref Subsect="IsTriangular"/>).
#!
#! Its vertices are given by the <K>OneFlags</K> (<Ref Subsect="OneFlags"/>),
#! its edges by the <K>TwoFlags</K> (<Ref Subsect="TwoFlags"/>) and its faces
#! by the <K>ThreeFlags</K> (<Ref Subsect="Flags"/>).
#!
#! @InsertChunk Example_FlagComplex_Construction
#!
#! The more specific command requires <A>complex</A> to be
#! a twisted polygonal surface (<Ref Subsect="IsPolygonalSurface"/>).
#!
#! @Returns a flag complex
#! @Arguments complex
DeclareAttribute("FlagComplex", IsTwistedPolygonalComplex);
#! @Returns a flag surface
#! @Arguments surf
DeclareOperation("FlagSurface", [IsTwistedPolygonalSurface]);
#! @EndGroup

#! @BeginGroup IsFlagComplex
#! @Description
#! Check whether the given <A>complex</A> is a flag complex. Every flag
#! complex is also an edge-coloured polygonal complex. Besides access to
#! the uncoloured flag complex via <K>PolygonalComplex</K>
#! (<Ref Subsect="EdgeColouring_TwistedPolygonalComplex"/>) it also allows access
#! to the original polygonal complex by <K>OriginalComplex</K>
#! (<Ref Subsect="OriginalComplex"/>).
#!
#! This will also return <K>true</K> if the original complex would just be a <E>twisted</E> complex.
#!
#! The additional property check if the underlying polygonal complex
#! is a polygonal surface.
#!
#! For example, consider the complex from the start of this section (<Ref Sect="Section_Flags_FlagComplex"/>).
#! @BeginExampleSession
#! gap> IsFlagComplex(flagComp);
#! true
#! gap> IsFlagComplex(complex);
#! false
#! @EndExampleSession
#!
#! @Arguments object
DeclareCategory( "IsFlagComplex", IsEdgeColouredTwistedPolygonalComplex );
#! @Arguments flagComp
DeclareProperty( "IsFlagSurface", IsFlagComplex );
#! @EndGroup
InstallTrueMethod( IsEdgeColouredTwistedPolygonalComplex and IsNotEdgeRamified and IsNotVertexRamified, IsFlagSurface );
InstallTrueMethod( IsFlagSurface, IsEdgeColouredTwistedPolygonalComplex and IsNotEdgeRamified and IsNotVertexRamified and IsFlagComplex );

#! @BeginGroup OriginalComplex
#! @Description
#! Return the original twisted polygonal complex of the given flag complex
#! <A>flagComp</A>, i.e.
#! the unique twisted polygonal complex <A>complex</A> such that 
#! <K>FlagComplex</K>(<A>complex</A>) = <A>flagComp</A>.
#!
#! The more specific command requires the original complex to be
#! a twisted polygonal surface
#! (<Ref Subsect="IsPolygonalSurface"/>).
#!
#! @Returns a twisted polygonal complex
#! @Arguments flagComp
DeclareAttribute("OriginalComplex", IsFlagComplex);
#! @Returns a twisted polygonal surface
#! @Arguments flagSurf
DeclareOperation("OriginalSurface", [IsFlagSurface]);
#! @EndGroup

#! @BeginGroup OriginalVertices
#! @Description
#! Return the set of all vertices contained in the original twisted polygonal
#! complex of the given flag complex <A>flagComp</A>, i.e. the vertices
#! of the unique twisted polygonal complex <A>complex</A> satisfying 
#! <K>FlagComplex</K>(<A>complex</A>) = <A>flagComp</A>.

#! As an example consider the polygonal complex from 
#! <Ref Sect="Section_Flags_Definition"/> and its barycentric subdivision
#! from <Ref Subsect="FlagComplex"/>.
#!
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> OriginalVertices(flagComp);
#! [ 2, 3, 5, 7, 11 ]
#! @EndExampleSession
#!
#! @Returns a set of positive integers
#! @Arguments flagComp
DeclareOperation("OriginalVertices",[IsFlagComplex]);
#! @EndGroup


#! @BeginGroup OriginalEdges
#! @Description
#! Return the set of all edges contained in the original twisted polygonal
#! complex of the given flag complex <A>flagComp</A>, i.e. the edges
#! of the unique twisted polygonal complex <A>complex</A> satisfying 
#! <K>FlagComplex</K>(<A>complex</A>) = <A>flagComp</A>.

#! As an example consider the polygonal complex from 
#! <Ref Sect="Section_Flags_Definition"/> and its barycentric subdivision
#! from <Ref Subsect="FlagComplex"/>.
#!
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> OriginalEdges(flagComp);
#! [ 6, 8, 9, 10, 12, 13 ]
#! @EndExampleSession
#!
#! @Returns a set of positive integers
#! @Arguments flagComp
DeclareOperation("OriginalEdges",[IsFlagComplex]);
#! @EndGroup


#! @BeginGroup OriginalFaces
#! @Description
#! Return the set of all faces contained in the original twisted polygonal
#! complex of the given flag complex <A>flagComp</A>, i.e. the faces
#! of the unique twisted polygonal complex <A>complex</A> satisfying 
#! <K>FlagComplex</K>(<A>complex</A>) = <A>flagComp</A>.

#! As an example consider the polygonal complex from 
#! <Ref Sect="Section_Flags_Definition"/> and its barycentric subdivision
#! from <Ref Subsect="FlagComplex"/>.
#!
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> OriginalFaces(flagComp);
#! [ 1, 4 ]
#! @EndExampleSession
#!
#! @Returns a set of positive integers
#! @Arguments flagComp
DeclareOperation("OriginalFaces",[IsFlagComplex]);
#! @EndGroup


#! @BeginGroup OriginalOneFlag
#! @Description
#! Return a flag of length 1 of the original twisted polygonal complex of the
#! given flag complex which corresponds to <A>vertex</A> in <A>flagComp</A>,
#! i.e. the flag <A>oneflag</A> of the unique twisted polygonal complex
#! <A>complex</A> satisfying <K>OneFlags</K>(<A>complex</A>)[<K>vertex</K>] =
#! <A>oneflag</A>.

#! As an example consider the polygonal complex from 
#! <Ref Sect="Section_Flags_Definition"/> and its barycentric subdivision
#! from <Ref Subsect="FlagComplex"/>.
#!
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> OneFlags(complex);
#! [ [ 0, 2 ], [ 0, 3 ], [ 0, 5 ], [ 0, 7 ], [ 0, 11 ], [ 1, 6 ], [ 1, 8 ],
#!   [ 1, 9 ], [ 1, 10 ], [ 1, 12 ], [ 1, 13 ], [ 2, 1 ], [ 2, 4 ] ]
#! gap> OriginalOneFlag(flagComp,4);
#! [ 0, 7 ]
#! @EndExampleSession
#!
#! @Returns a wrapped one-flag
#! @Arguments flagComp, vertex
DeclareOperation("OriginalOneFlag",[IsFlagComplex,IsPosInt]);
#! @EndGroup


#! @BeginGroup OriginalTwoFlag
#! @Description
#! Return a flag of length 2 of the original twisted polygonal complex of
#! the given flag complex which corresponds to <A>edge</A> in <A>flagComp</A>
#! i.e. the flag <A>twoflag</A> of the unique twisted polygonal complex
#! <A>complex</A> satisfying <K>TwoFlags</K>(<A>complex</A>)[<K>edge</K>] =
#! <A>twoflag</A>.

#! As an example consider the polygonal complex from 
#! <Ref Sect="Section_Flags_Definition"/> and its barycentric subdivision
#! from <Ref Subsect="FlagComplex"/>.
#!
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> TwoFlags(complex);
#! [ [ 1, [ 2, 6 ] ], [ 1, [ 2, 8 ] ], [ 1, [ 3, 8 ] ], [ 1, [ 3, 9 ] ], 
#!   [ 1, [ 3, 12  ] ], [ 1, [ 5, 6 ] ], [ 1, [ 5, 9 ] ], [ 1, [ 5, 10  ] ], 
#!   [ 1, [ 7, 12 ] ], [ 1, [ 7, 13 ] ], [ 1, [ 11, 10 ] ], [ 1, [ 11, 13 ] ],
#!   [ 2, [ 2, 1 ] ], [ 2, [ 3, 1 ] ], [ 2, [ 3, 4 ] ], [ 2, [ 5, 1 ] ], 
#!   [ 2, [ 5, 4 ] ], [ 2, [ 7, 4 ] ], [ 2, [ 11, 4 ] ], [ 3, [ 6, 1 ] ], 
#!   [ 3, [ 8, 1 ] ], [ 3, [ 9, 1 ] ], [ 3, [ 9, 4 ] ], [ 3, [ 10, 4 ] ], 
#!   [ 3, [ 12, 4 ] ], [ 3, [ 13, 4 ] ] ]
#! gap> OriginalTwoFlag(flagComp,5);
#! [ 1, [ 3, 12 ] ]
#! @EndExampleSession
#!
#! @Returns a wrapped two-flag 
#! @Arguments flagComp, edge
DeclareOperation("OriginalTwoFlag",[IsFlagComplex,IsPosInt]);
#! @EndGroup


#! @BeginGroup OriginalThreeFlag
#! @Description
#! Return a flag of length 3 of the original twisted polygonal complex of the 
#! given flag complex which corresponds to <A>face</A> in <A>flagComp</A>
#! i.e. the flag <A>threeflag</A> of the unique twisted polygonal complex
#! <A>complex</A> satisfying <K>ThreeFlags</K>(<A>complex</A>)[<K>face</K>] =
#! <A>threeflag</A>.

#! As an example consider the polygonal complex from 
#! <Ref Sect="Section_Flags_Definition"/> and its barycentric subdivision
#! from <Ref Subsect="FlagComplex"/>.
#!
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> ThreeFlags(complex);
#! [ [ 2, 6, 1 ], [ 2, 8, 1 ], [ 3, 8, 1 ], [ 3, 9, 1 ], [ 3, 9, 4 ], 
#!   [ 3, 12, 4 ], [ 5, 6, 1 ], [ 5, 9, 1 ], [ 5, 9, 4 ], [ 5, 10, 4 ],
#!   [ 7, 12, 4 ], [ 7, 13, 4 ], [ 11, 10, 4 ], [ 11, 13, 4 ]]
#! gap> OriginalThreeFlag(flagComp,10);
#! [ 5, 10, 4 ]
#! @EndExampleSession
#! @Returns a wrapped three-flag
#! @Arguments flagComp, face
DeclareOperation("OriginalThreeFlag",[IsFlagComplex,IsPosInt]);
#! @EndGroup


#! @BeginGroup BarycentreOfVertex
#! @Description
#! Return the vertex of the flag complex of <A>complex</A> which corresponds
#! to the flag [0,<A>vertex</A>] of the given twisted polygonal complex, i.e.
#! the vertex <A>v</A> of the flag complex <A>flagComp</A> satisfying
#! <K>OneFlags</K>(<A>complex</A>)[<K>v</K>] = [0,<A>vertex</A>].

#! As an example consider the polygonal complex from 
#! <Ref Sect="Section_Flags_Definition"/> and its barycentric subdivision
#! from <Ref Subsect="FlagComplex"/>.
#!
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> OneFlags(complex);
#! [ [ 0, 2 ], [ 0, 3 ], [ 0, 5 ], [ 0, 7 ], [ 0, 11 ], [ 1, 6 ], [ 1, 8 ],
#!   [ 1, 9 ], [ 1, 10 ], [ 1, 12 ], [ 1, 13 ], [ 2, 1 ], [ 2, 4 ] ]
#! gap> BarycentreOfVertex(complex,3);
#! 2
#! @EndExampleSession
#!
#! @Returns positive integer
#! @Arguments complex, vertex
DeclareOperation("BarycentreOfVertex",[IsTwistedPolygonalComplex,IsPosInt]);
#! @EndGroup


#! @BeginGroup BarycentreOfEdge
#! @Description
#! Return the edge of the flag complex of <A>complex</A> which corresponds
#! to the flag [1,<A>edge</A>] of the given twisted polygonal complex, i.e.
#! the edge <A>e</A> of the flag complex <A>flagComp</A> satisfying
#! <K>OneFlags</K>(<A>complex</A>)[<K>e</K>] = [1,<A>edge</A>].
#! As an example consider the polygonal complex from 
#! <Ref Sect="Section_Flags_Definition"/> and its barycentric subdivision
#! from <Ref Subsect="FlagComplex"/>.
#!
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> OneFlags(complex);
#! [ [ 0, 2 ], [ 0, 3 ], [ 0, 5 ], [ 0, 7 ], [ 0, 11 ], [ 1, 6 ], [ 1, 8 ],
#!   [ 1, 9 ], [ 1, 10 ], [ 1, 12 ], [ 1, 13 ], [ 2, 1 ], [ 2, 4 ] ]
#! gap> BarycentreOfEdge(complex,12); 
#! 10
#! @EndExampleSession
#!
#! @Returns a positive integer
#! @Arguments complex, edge
DeclareOperation("BarycentreOfEdge",[IsTwistedPolygonalComplex,IsPosInt]);
#! @EndGroup


#! @BeginGroup BarycentreOfFace
#! @Description
#! Return the face of the flag complex of <A>complex</A> which corresponds
#! to the flag [2,<A>face</A>] of the given twisted polygonal complex, i.e.
#! the face <A>f</A> of the flag complex <A>flagComp</A> satisfying
#! <K>OneFlags</K>(<A>complex</A>)[<K>f</K>] = [2,<A>face</A>].

#! As an example consider the polygonal complex from 
#! <Ref Sect="Section_Flags_Definition"/> and its barycentric subdivision
#! from <Ref Subsect="FlagComplex"/>.
#!
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> OneFlags(complex);
#! [ [ 0, 2 ], [ 0, 3 ], [ 0, 5 ], [ 0, 7 ], [ 0, 11 ], [ 1, 6 ], [ 1, 8 ],
#!   [ 1, 9 ], [ 1, 10 ], [ 1, 12 ], [ 1, 13 ], [ 2, 1 ], [ 2, 4 ] ]
#! gap> BarycentreOfFace(complex,4);
#! 13
#! @EndExampleSession
#!
#! @Returns a positive integer
#! @Arguments complex, face
DeclareOperation("BarycentreOfFace",[IsTwistedPolygonalComplex,IsPosInt]);
#! @EndGroup

#! @BeginGroup IsomorphicFlagSurface
#! @Description
#! Construct a flag surface (<Ref Subsect="FlagComplex"/>) that is
#! isomorphic to the given tame-coloured surface, if possible (the first
#! colour involution will become the vertex involution, etc.). It returns:
#! * a flag surface, if successful
#! * <K>false</K> if this is not possible
#! * <K>fail</K> if the given <A>tameSurface</A> is not a MMM-surface.
#!
#! For example, consider the one face and the corresponding flag surface:
#! @BeginExampleSession
#! gap> oneFace:=SimplicialSurfaceByVerticesInFaces([[1,2,3]]);;
#! gap> flagSurf:=FlagComplex(oneFace);;
#! gap> IsIsomorphic(IsomorphicFlagSurface(flagSurf),flagSurf);
#! true
#! @EndExampleSession
#!
#! @Returns a flag surface, <K>false</K> or <K>fail</K>
#! @Arguments tameSurface
DeclareAttribute("IsomorphicFlagSurface", IsTameColouredSurface);
#! @EndGroup


#! @BeginGroup DrawSurfaceToTikz_FlagComplex
#! @Description
#! Draw the net of the given flag complex that is also a polygonal complex
#! without edge ramifications 
#! into a tex-file (using 
#! TikZ). The method for flag complexes is the same as the one for 
#! edge coloured polygonal complexes without edge ramifications
#! (<Ref Subsect="DrawSurfaceToTikz_EdgeColoured"/>) except for one feature:
#! * If no edge lengths are given in the printing record, the default edge
#!   lengths are set in such a way that the faces are drawn as the
#!   barycentric subdivision of the original complex.
#! * If there are faces with different numbers of edges, the default edge 
#!   lengths will not be colour invariant. In this case the value
#!   <E>edgeColourClassActive</E> will be set to <K>false</K>.
#! 
#! An example is given at the beginning of this section (<Ref Sect="Section_Flags_FlagComplex"/>).
#!
#! @Returns a record
#! @Arguments flagSurf, fileName[, printRecord]
DeclareOperation( "DrawSurfaceToTikz", [IsFlagComplex and IsNotEdgeRamified, IsString, IsRecord] );
#! @EndGroup

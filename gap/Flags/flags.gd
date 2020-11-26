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
#!
#! The elementary flag access functions are described in section
#! <Ref Sect="Section_Flags_Definition"/>.
#!
#! Section <Ref Sect="Section_Flags_DressGroup"/> uses the knowledge of the 
#! flags to compute the <K>DressGroup</K>
#! (<Ref Subsect="DressInvolutions"/>)
#! of a polygonal complex without edge ramifications.
#!
#! In section <Ref Sect="Section_Flags_FlagComplex"/> defines a triangular
#! complex whose faces are given by the flags and describes some special
#! functionality for these kinds of complexes.
#!

#! @Section Computation
#! @SectionLabel Flags_Definition
#!
#! This section deals with all different types of flags. In general a flag
#! is a tuple consisting of incident elements of different dimensions, for
#! example a vertex-edge-pair, a vertex-face-pair or a 
#! vertex-edge-face-triple.
#! 
#! For example consider the following polygonal surface:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!       \input{Image_FlagComplexExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> complex := PolygonalComplexByDownwardIncidence( 
#! >    [ , , , , , [2,5], , [2,3], [3,5], [11,5], , [3,7], [7,11] ], 
#! >    [[6,8,9], , , [9,10,12,13]]);;
#! @EndExampleSession
#!
#! Most apparent are the flags that consist of a vertex, an edge and a face,
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
#! Since flags of length 1 are just vertices, edges and faces, the usual
#! accesss functions of section <Ref Sect="Section_Access_LabelAccess"/> are 
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
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!       \input{Image_FlagComplexExample.tex}
#!   \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle=nolabels]
#!       \input{Image_FlagComplexExample.tex}
#!   \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!       \input{Image_FlagComplexExample.tex}
#!   \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle=nolabels, edgeStyle, faceStyle]
#!       \input{Image_FlagComplexExample.tex}
#!   \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!       \input{Image_FlagComplexExample.tex}
#!   \end{tikzpicture}
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
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!       \input{Image_FlagComplexExample.tex}
#!   \end{tikzpicture}
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
#! TODO example
#! 
#! @Returns a list of three involutions
#! @Arguments complex
DeclareAttribute( "DressInvolutions", IsVEFComplex and IsNotEdgeRamified );
#! @Returns a group
#! @Arguments complex
DeclareAttribute( "DressGroup", IsVEFComplex and IsNotEdgeRamified );

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

#! @BeginGroup IsFlagComplex
#! @Description
#! Check whether the given <A>colComplex</A> is a flag complex. Every flag
#! complex is also an edge-coloured polygonal complex. Besides access to
#! the uncoloured flag complex via <K>PolygonalComplex</K>
#! (<Ref Subsect="EdgeColouring_VEFComplex"/>) it also allows access
#! to the original polygonal complex by <K>OriginalComplex</K>
#! (<Ref Subsect="OriginalComplex"/>).
#!
#! This will also return <K>true</K> if the original complex would be a <E>bend</E> complex.
#!
#! The additional property check if the underlying polygonal complex
#! is a polygonal surface.
#!
#! TODO example?
#!
#! @Arguments object
DeclareCategory( "IsFlagComplex", IsEdgeColouredPolygonalComplex );
#! @Arguments flagComp
DeclareProperty( "IsFlagSurface", IsFlagComplex );
#! @EndGroup
InstallTrueMethod( IsEdgeColouredPolygonalComplex and IsNotEdgeRamified and IsNotVertexRamified, IsFlagSurface );
InstallTrueMethod( IsFlagSurface, IsEdgeColouredPolygonalComplex and IsNotEdgeRamified and IsNotVertexRamified and IsFlagComplex );


#! @BeginGroup FlagComplex
#! @Description
#! Return the flag complex of <A>complex</A>. The flag complex is an 
#! edge-coloured (<Ref Chap="Chapter_EdgeColouring"/>) triangular complex
#! (<Ref Subsect="IsTriangular"/>).
#!
#! Its vertices are given by the <K>OneFlags</K> (<Ref Subsect="OneFlags"/>),
#! its edges by the <K>TwoFlags</K> (<Ref Subsect="TwoFlags"/>) and its faces
#! by the <K>ThreeFlags</K> (<Ref Subsect="Flags"/>).
#!
#! @InsertChunk Example_FlagComplex_Construction
#!
#! The more specific command require <A>complex</A> to be
#! a polygonal surface (<Ref Subsect="IsPolygonalSurface"/>), respectively.
#!
#! @Returns a flag complex
#! @Arguments complex
DeclareAttribute("FlagComplex", IsPolygonalComplex);
#! @Returns a flag surface
#! @Arguments surf
DeclareOperation("FlagSurface", [IsPolygonalSurface]);
#! @EndGroup




#! @BeginGroup OriginalComplex
#! @Description
#! Return the original polygonal complex of the given flag complex
#! <A>flagComp</A>, i.e.
#! the unique polygonal complex <A>complex</A> such that 
#! <K>FlagComplex</K>(<A>complex</A>) = <A>flagComp</A>.
#!
#! If the returned polygonal complex would be <E>bend</E>, <K>fail</K> is returned.
#!
#! The more specific command require the original complex to be
#! a polygonal surface
#! (<Ref Subsect="IsPolygonalSurface"/>).
#!
#! @Returns a polygonal complex
#! @Arguments flagComp
DeclareAttribute("OriginalComplex", IsFlagComplex);
#! @Returns a polygonal surface
#! @Arguments flagSurf
DeclareOperation("OriginalSurface", [IsFlagSurface]);
#! @EndGroup


#! @BeginGroup IsomorphicFlagSurface
#! @Description
#! Construct a flag surface (<Ref Subsect="FlagComplex"/>) that is
#! isomorphic to the given tame-coloured surface, if possible (the first
#! colour involution will become the vertex involution, etc.). It returns:
#! * a flag surface, if successful
#! * <K>true</K> if the given <A>tameSurface</A> is isomorphic to a flag surface
#!   but the original surface (<Ref Subsect="OriginalComplex"/>) is bend.
#! * <K>false</K> if this is not possible
#! * <K>fail</K> if the given <A>tameSurface</A> is not a MMM-surface.
#!
#! TODO example
#!
#! @Returns a flag surface, <K>true</K>, <K>false</K> or <K>fail</K>
#! @Arguments tameSurface
DeclareAttribute("IsomorphicFlagSurface", IsTameColouredSurface);
#! @EndGroup


#! @BeginGroup DrawSurfaceToTikz_FlagComplex
#! @Description
#! Draw the net of the given flag complex without edge ramifications 
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
#! TODO example
#!
#! @Returns a record
#! @Arguments flagSurf, fileName[, printRecord]
DeclareOperation( "DrawSurfaceToTikz", [IsFlagComplex and IsNotEdgeRamified, IsString, IsRecord] );
#! @EndGroup
#!
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!       \input{try.tex}
#!   \end{tikzpicture}
#! </Alt>


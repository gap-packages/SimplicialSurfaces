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
#! A flag is a triple <M>(V,E,F)</M> of vertex <M>V</M>m an edge <M>E</M>
#! and a face <M>F</M> that are incident to each other. They can be computed
#! with the command <K>Flags</K> (<Ref Subsect="Flags"/>).
#!
#! The elementary flag access functions are described in section
#! <Ref Sect="Section_Flags_Definition"/>.
#!
#! Section <Ref Sect="Section_Flags_DressGroup"/> uses the knowledge of the 
#! flags to compute the <K>DressGroup</K>
#! (<Ref Subsect="DressGroup"/>)
#! of a ramified polygonal surface.
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
#!       \input{Image_StarOfStarExample.tex}
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
#!       \input{Image_StarOfStarExample.tex}
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
#!       \input{Image_StarOfStarExample.tex}
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
#!       \input{Image_StarOfStarExample.tex}
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
#!       \input{Image_StarOfStarExample.tex}
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
#!       \input{Image_StarOfStarExample.tex}
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
#! * The edge <A>e</A> is wrapped into [ 0, <A>e</A> ].
#! * The face <A>f</A> is wrapped into [ 0, <A>f</A> ].
#!
#! As an example consider the polygonal surface from the start of section 
#! <Ref Sect="Section_Flags_Definition"/>.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!       \input{Image_StarOfStarExample.tex}
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
#! 

#! @Section Flag complex
#! @SectionLabel Flags_FlagComplex
#!
#! 

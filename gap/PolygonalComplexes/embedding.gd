#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2016
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

#! @Chapter Nets and embeddings
#! @ChapterLabel Embeddings
#!
#! One of the central questions about polygonal complexes and simplicial
#! surfaces (for the detailed definitions see chapter 
#! <Ref Chap="PolygonalStructures"/>) is whether they can be embedded into
#! <M>&RR;^3</M>. This is a very hard question and can
#! currently only be solved for small examples.
#!
#! Therefore the <K>SimplicialSurface</K>-package does not contain methods to
#! compute general embeddings. This chapter contains some prerequesite methods
#! in the direction of the general embedding-problem.
#!
#! Section <Ref Sect="Section_Embeddings_Anomalies"/> deals with properties 
#! that make embeddings impossible. Section
#! <Ref Sect="Section_Embeddings_DrawTikz"/> contains a method to draw the net 
#! of a polygonal complex.

#######
## This breaks with our convention of not telling what a chapter contains.
## 
## As there are only two options and the chapter title makes it not completely
## clear what it contains, this seems ok here.
#######

#! @Section Anomalies
#! @SectionLabel Embeddings_Anomalies
#!
#! If an embedding of a polygonal complex maps edges to straight lines, it is
#! defined by the images of its vertices alone. This restricts the possible
#! incidence structures:
#!
#! Two edges that are incident to
#! the same vertices would be mapped to the same line, contradicting the
#! injectivity of the embedding. The same argument applies to two faces
#! with the same vertices.
#!
#! Those cases are called <E>edge-anomalies</E> and <E>face-anomalies</E>.
#! Both are appearing in the example of an open bag:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!      \input{Image_OpenBag.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> bag := SimplicialSurfaceByUpwardIncidence( [ [1,2], [1,3,4], [2,3,4] ],
#! >               [ [1,2], [1,2], [2], [1] ]);;
#! gap> IsAnomalyFree( bag );
#! false
#! gap> EdgeAnomalyClasses( bag );
#! [ [ 1 ], [ 2 ], [ 3, 4 ] ]
#! gap> FaceAnomalyClasses( bag );
#! [ [ 1, 2 ] ]
#! @EndExampleSession
#!


#! <ManSection> 
#!   <Prop Name="IsAnomalyFree" Arg="complex" Label="for IsPolygonalComplex"
#!      Comm="Checks whether a given polygonal complex contains anomalies"/>
#!   <Filt Name="IsVertexFaithful" Arg="complex" Type="property"
#!      Comm="Checks whether a given polygonal complex contains anomalies"/>
#!   <Returns>true or false</Returns>
#!   <Description>
#!     Check whether the given polygonal complex contains anomalies, i.e.
#!     pairs of edges or pairs of faces that are incident to the same 
#!     vertices.
#!     <P/>
#!     As examples, consider a tetrahedron (without any anomalies) and the
#!     open bag from the start of section 
#!     <Ref Sect="Section_Embeddings_Anomalies"/> (with anomalies):
#! @ExampleSession
#! gap> IsAnomalyFree( Tetrahedron() );
#! true
#! gap> IsAnomalyFree( bag );
#! false
#! 
#! gap> IsVertexFaithful( Tetrahedron() );
#! true
#! gap> IsVertexFaithful( bag );
#! false
#! @EndExampleSession
#!   </Description>
#! </ManSection>
# here no AutoDoc documentation since synonyms can't be handled automatically
DeclareProperty( "IsAnomalyFree", IsPolygonalComplex );
DeclareSynonym( "IsVertexFaithful", IsAnomalyFree );


#! @BeginGroup EdgeAnomalies
#! @Description
#! Return the set of all edge-anomaly-classes of the given polygonal complex.
#! Two edges of <A>complex</A> lie in the same <E>edge-anomaly-class</E> if
#! they are incident to the same vertices.
#!
#! The method <K>EdgeAnomalyClassOfEdge</K> only returns the 
#! edge-anomaly-class of the given edge (as set). The NC-version does not
#! check if <A>edge</A> is an edge of <A>complex</A>.
#!
#! Consider the open bag from the start of section 
#! <Ref Sect="Section_Embeddings_Anomalies"/>:
#! <Alt Only="TikZ">
#!    \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!       \input{Image_OpenBag.tex}
#!    \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> EdgeAnomalyClassOfEdge( bag, 1 );
#! [ 1 ]
#! gap> EdgeAnomalyClassOfEdge( bag, 3 );
#! [ 3, 4 ]
#! gap> EdgeAnomalyClasses( bag );
#! [ [ 1 ], [ 2 ], [ 3, 4 ] ]
#! @EndExampleSession
#!
#! @Returns a set of sets of positve integers
#! @Arguments complex
DeclareAttribute( "EdgeAnomalyClasses", IsPolygonalComplex );
#! @Returns a set of positive integers
#! @Arguments complex, edge
DeclareOperation( "EdgeAnomalyClassOfEdge", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, edge
DeclareOperation( "EdgeAnomalyClassOfEdgeNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup FaceAnomalies
#! @Description
#! Return the set of all face-anomaly-classes of the given polygonal complex.
#! Two faces of <A>complex</A> lie in the same <E>face-anomaly-class</E> if
#! they are incident to the same vertices.
#!
#! The method <K>FaceAnomalyClassOfFace</K> only returns the 
#! face-anomaly-class of the given face (as set). The NC-version does not
#! check if <A>face</A> is a face of <A>complex</A>.
#!
#! Consider the open bag from the start of section 
#! <Ref Sect="Section_Embeddings_Anomalies"/>:
#! <Alt Only="TikZ">
#!    \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!       \input{Image_OpenBag.tex}
#!    \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> FaceAnomalyClassOfFace( bag, 1 );
#! [ 1, 2 ]
#! gap> FaceAnomalyClasses( bag );
#! [ [ 1, 2 ] ]
#! @EndExampleSession
#!
#! @Returns a set of sets of positve integers
#! @Arguments complex
DeclareAttribute( "FaceAnomalyClasses", IsPolygonalComplex );
#! @Returns a set of positive integers
#! @Arguments complex, face
DeclareOperation( "FaceAnomalyClassOfFace", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "FaceAnomalyClassOfFaceNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @Section Drawing a net in TikZ
#! @SectionLabel Embeddings_DrawTikz
#!
#! While it is very hard to compute an embedding into <M>&RR;^3</M> it is
#! quite easy to draw the net of a ramified polygonal surface into a
#! plane.
#!
#! For example, the net of an octahedron can be drawn like this:
#! @ExampleSession
#! gap> oct := Octahedron();;
#! gap> DrawSurfaceToTikz( oct, "Octahedron" );;
#! @EndExampleSession
#!
#! This will write a file <E>Octahedron.tex</E> that contains the net of
#! the octahedron, written in <K>TikZ</K>:
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Octahedron.tex}
#! </Alt>
#!
#! To customize this drawing, a record is used (called the <A>printRecord</A>).
#! Each call of the drawing method creates one of those:
#! @ExampleSession
#! gap> pr := DrawSurfaceToTikz( oct, "Octahedron" );;
#! @EndExampleSession
#!
#! Maybe the edges should not be labelled. Then they can be turned off:
#! @ExampleSession
#! gap> pr.edgeLabelsActive := false;;
#! gap> DrawSurfaceToTikz( oct, "Octahedron_noEdgeLabels", pr );;
#! @EndExampleSession
#! After compiling we get the following net.
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Octahedron_noEdgeLabels.tex}
#! </Alt>
#!
#! The colours can also be changed very easily (especially if all colours
#! should be changed at once). For example, let's make all vertices green:
#! @ExampleSession
#! gap> pr.vertexColours := "green";;
#! @EndExampleSession
#! Since it is impractical to always call &LaTeX; for every customization
#! we can call it directly from within &GAP;:
#! @ExampleSession
#! gap> pr.compileLaTeX := true;;
#! gap> DrawSurfaceToTikz( oct, "Octahedron_recoloured.tex", pr );;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Octahedron_recoloured.tex}
#! </Alt>
#! 
#! It should be mentioned that all of these calls modify their 
#! <A>printRecord</A>.
#!
#! Still the picture looks quite small. To see how big it currently is, we
#! can look at the parameter <A>scale</A>:
#! @ExampleSession
#! gap> pr.scale;
#! 2
#! @EndExampleSession
#! So the default <A>scale</A> is 2. Since there is a lot of space left,
#! we can set the <A>scale</A> to 3.
#! @ExampleSession
#! gap> pr.scale := 3;;
#! gap> DrawSurfaceToTikz( oct, "Octahedron_customized.tex", pr );;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Octahedron_customized.tex}
#! </Alt>
#! 
#! TODO
DeclareOperation( "DrawSurfaceToTikz", [IsPolygonalSurface, IsString, IsRecord] );

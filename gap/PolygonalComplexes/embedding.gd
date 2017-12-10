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
#! @InsertChunk DrawSurfaceToTikz_Tutorial
#!
#! @BeginGroup DrawSurfaceToTikz
#! @Description
#! Draw the net of the given <A>ramSurf</A> into a tex-file (using TikZ).
#! An introduction to the use of this method (along with several examples) 
#! can be found at the start of section 
#! <Ref Sect="Section_Embeddings_DrawTikz"/>.
#!
#! * If the given <A>fileName</A> does not end in <E>.tex</E> the ending 
#!   <E>.tex</E> will be added to it. 
#! * The given file will be overwritten without asking if it already exists.
#!   If you don't have permission to write in that file, this method will
#!   throw an error.
#! * The particulars of the drawing are determined by the 
#!   given <A>printRecord</A>. If this is not given, the default settings are 
#!   used. 
#! * The <A>printRecord</A> will be modified and returned by this method.
#!   It contains the data to recreate the drawing of the surface.
#TODO give option to draw with just the record
#! 
#! There are several parameters to change the output of this method, from 
#! cosmetic changes to exactly controlling in which order the faces are drawn.
#! There are the following classes of parameters:
#! * <E>Colours</E> 
#!   (<Ref Subsect="Subsection_DrawSurfaceToTikz_Colours"/>): Change the 
#!   colours of vertices, edges and faces.
#! * <E>Labels</E>
#!   (<Ref Subsect="Subsection_DrawSurfaceToTikz_Labels"/>): Modify the labels
#!   of vertices, edges and faces.
#! * <E>Lengths and angles</E> 
#!   (<Ref Subsect="Subsection_DrawSurfaceToTikz_LengthsAndAngles"/>): These
#!   parameters control the size and shape of the drawing and the individual 
#!   faces.
#! * <E>Draw order</E> 
#!   (<Ref Subsect="Subsection_DrawSurfaceToTikz_DrawOrder"/>): They control 
#!   the order in which the faces are drawn.
#! * <E>Output control</E> 
#!   (<Ref Subsect="Subsection_DrawSurfaceToTikz_Output"/>): Modify how the
#!   &LaTeX;-output behaves and how much information is printed to the 
#!   console.
#! * <E>Data representation</E> 
#!   (<Ref Subsect="Subsection_DrawSurfaceToTikz_Data"/>): These
#!   parameters can't be influenced by the user and contain the information to
#!   recreate the drawing.
#! 
#! @Returns a record
#! @Arguments ramSurf, fileName[, printRecord]
DeclareOperation( "DrawSurfaceToTikz", [IsRamifiedPolygonalSurface, IsString, IsRecord] );
#! @EndGroup

#! @Subsection Colours
#! @SubsectionLabel DrawSurfaceToTikz_Colours
#! @InsertChunk DrawSurfaceToTikz_Colours
#!
#! @Subsection Labels
#! @SubsectionLabel DrawSurfaceToTikz_Labels
#! @InsertChunk DrawSurfaceToTikz_Labels
#!
#! @Subsection Lengths and angles
#! @SubsectionLabel DrawSurfaceToTikz_LengthsAndAngles
#! @InsertChunk DrawSurfaceToTikz_LengthsAndAngles
#! 
#! @Subsection Draw order
#! @SubsectionLabel DrawSurfaceToTikz_DrawOrder
#! @InsertChunk DrawSurfaceToTikz_DrawOrder
#!
#! @Subsection Output control
#! @SubsectionLabel DrawSurfaceToTikz_Output
#! @InsertChunk DrawSurfaceToTikz_Output
#!
#! @Subsection Data representation
#! @SubsectionLabel DrawSurfaceToTikz_Data
#! @InsertChunk DrawSurfaceToTikz_Data

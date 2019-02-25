#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2019
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

#! @Chapter Homomorphisms
#! @ChapterLabel Morphisms
#!
#! This chapter is concerned with morphisms between different polygonal
#! complexes (morphisms between bend polygonal complexes are not implemented
#! so far).
#!
#! A morphism between two polygonal complexes <M>(V_1,E_1,F_1)</M> and
#! <M>(V_2,E_2,F_2)</M> consists of maps <M>V_1 \to V_2</M>, <M>E_1 \to E_2</M>,
#! and <M>F_1 \to F_2</M>, such that incident elements remain incident.
#!
#! TODO: these maps can be represented as lists, or as mappings (in GAP)
#! TODO: example with constructors for the two
#!
#! TODO a lot of introduction

#idea: polygonal morphisms are maps between sets: vertices+edges+faces, where edges
# are shifted by MaxVertex and faces are shifted by MaxVertex+MaxEdge
DeclareCategory("IsGeneralPolygonalMorphism", IsNonSPGeneralMapping);
DeclareSynonym("IsPolygonalMorphism", IsGeneralPolygonalMorphism and IsTotal and IsSingleValued);
# TODO are the names good? Or should we be more specific, e.g. IsPolygonalComplexMorphism, IsPolygonalSurfaceMorphism?


BindGlobal( "GeneralPolygonalMorphismFamily", 
    NewFamily( "GeneralPolygonalMorphismFamily", IsGeneralMapping, IsGeneralPolygonalMorphism ) );

#! @Section Consistent labels for vertices, edges, and faces
#! @SectionLabel VEFLabels
#!
#! We have defined VEF-complexes in a way such that the labels for vertices,
#! edges, and faces do not have to be distinct. While this is more convenient
#! for the casual user, it is sometimes practical to enforce distinct labels.
#! Notably, these cases include morphisms and automorphism groups.
#!
#! The distinct label set is called <K>VEFLabels</K>. Consider the following
#! polygonal surface:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!     \input{Image_VEFLabelsExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> cat := PolygonalSurfaceByUpwardIncidence(
#! >        [[1,2,4,5],, [1,7], [2,7,8], [8,9], [4,9,10], [5,10]],
#! >        [[1], [1,2],, [2,4], [4],, [1], [2], [2], [4]]);;
#! gap> Vertices(cat);
#! [ 1, 3, 4, 5, 6, 7 ]
#! gap> Edges(cat);
#! [ 1, 2, 4, 5, 7, 8, 9, 10 ]
#! gap> Faces(cat);
#! [ 1, 2, 4 ]
#! gap> Intersection( Vertices(cat), Edges(cat) );
#! [ 1, 4, 5, 7 ]
#! @EndExampleSession
#! Using the VEF-labels shifts the labels of edges and faces upwards to
#! avoid intersections.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!     \def\veflabels{1}
#!     \input{Image_VEFLabelsExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> VEFLabels(cat);
#! [ 1, 3, 4, 5, 6, 7, 8, 9, 11, 12, 14, 15, 16, 17, 18, 19, 21 ]
#! gap> VEFLabelsOfVertices(cat);
#! [ 1,, 3, 4, 5, 6, 7 ]
#! gap> VEFLabelsOfEdges(cat);
#! [ 8, 9,, 11, 12,, 14, 15, 16, 17 ]
#! gap> VEFLabelsOfFaces(cat);
#! [ 18, 19,, 21 ]
#! @EndExampleSession



#! @BeginGroup VEFLabels
#! @Description
#! Return the set of VEF-labels for the given VEF-complex. The
#! VEF-labels are a set of labels that distinguish vertices,
#! edges, and faces. It is constructed as follows:
#! * The vertex labels stay the same
#! * The edge labels are shifted upwards by the maximal vertex label
#! * The face labels are shifted upwards by the sum of maximal vertex
#!   label and maximal edge label
#!
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_VEFLabels_SideBySide.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> Vertices(cat);
#! [ 1, 3, 4, 5, 6, 7 ]
#! gap> Edges(cat);
#! [ 1, 2, 4, 5, 7, 8, 9, 10 ]
#! gap> Faces(cat);
#! [ 1, 2, 4 ]
#! gap> VEFLabels(cat);
#! [ 1, 3, 4, 5, 6, 7, 8, 9, 11, 12, 14, 15, 16, 17, 18, 19, 21 ]
#! @EndExampleSession
#! @Arguments complex
#! @Returns a set of positive integers
DeclareAttribute( "VEFLabels", IsVEFComplex );
#! @EndGroup


#! @BeginGroup VEFLabelsOfVertices
#! @Description
#! The method <K>VEFLabelOfVertex</K>(<A>complex</A>, <A>vertex</A>) returns the
#! VEF-label of <A>vertex</A>. The NC-version does
#! not check whether the given <A>vertex</A> is a vertex of <A>complex</A>.
#! 
#! The attribute <K>VEFLabelsOfVertices</K>(<A>complex</A>) collects all of those
#! labels in a list that is indexed by the vertex labels, i.e.
#! <K>VEFLabelsOfOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>VEFLabelOfVertex</K>(<A>complex</A>, <A>vertex</A>).
#! All other positions of this list are not bound.
#! 
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_VEFLabels_SideBySide.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> VEFLabelOfVertex(cat, 3);
#! 3
#! gap> VEFLabelOfVertex(cat, 6);
#! 6
#! gap> VEFLabelsOfVertices(cat);
#! [ 1,, 3, 4, 5, 6, 7 ]
#! @EndExampleSession
#! 
#! @Returns a list of positive integers / a positive integer
#! @Arguments complex
DeclareAttribute( "VEFLabelsOfVertices", IsVEFComplex );
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfVertex", [IsVEFComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfVertexNC", [IsVEFComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup VEFLabelsOfEdges
#! @Description
#! The method <K>VEFLabelOfEdge</K>(<A>complex</A>, <A>edge</A>) returns the
#! VEF-label of <A>edge</A>. The NC-version does
#! not check whether the given <A>edge</A> is an edge of <A>complex</A>.
#! 
#! The attribute <K>VEFLabelsOfEdges</K>(<A>complex</A>) collects all of those
#! labels in a list that is indexed by the edge labels, i.e.
#! <K>VEFLabelsOfOfEdges</K>(<A>complex</A>)[<A>edge</A>] = 
#! <K>VEFLabelOfEdge</K>(<A>complex</A>, <A>edge</A>).
#! All other positions of this list are not bound.
#! 
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_VEFLabels_SideBySide.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> VEFLabelOfEdge(cat, 2);
#! 9
#! gap> VEFLabelOfEdge(cat, 10);
#! 17
#! gap> VEFLabelsOfEdges(cat);
#! [ 8, 9,, 11, 12,, 14, 15, 16, 17 ]
#! @EndExampleSession
#! 
#! @Returns a list of positive integers / a positive integer
#! @Arguments complex
DeclareAttribute( "VEFLabelsOfEdges", IsVEFComplex );
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfEdge", [IsVEFComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfEdgeNC", [IsVEFComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup VEFLabelsOfFaces
#! @Description
#! The method <K>VEFLabelOfFace</K>(<A>complex</A>, <A>face</A>) returns the
#! VEF-label of <A>face</A>. The NC-version does
#! not check whether the given <A>face</A> is a face of <A>complex</A>.
#! 
#! The attribute <K>VEFLabelsOfFaces</K>(<A>complex</A>) collects all of those
#! labels in a list that is indexed by the face labels, i.e.
#! <K>VEFLabelsOfOfFaces</K>(<A>complex</A>)[<A>face</A>] = 
#! <K>VEFLabelOfFace</K>(<A>complex</A>, <A>face</A>).
#! All other positions of this list are not bound.
#! 
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_VEFLabels_SideBySide.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> VEFLabelOfFace(cat, 2);
#! 19
#! gap> VEFLabelOfFace(cat, 4);
#! 21
#! gap> VEFLabelsOfFaces(cat);
#! [ 18, 19,, 21 ]
#! @EndExampleSession
#! 
#! @Returns a list of positive integers / a positive integer
#! @Arguments complex
DeclareAttribute( "VEFLabelsOfFaces", IsVEFComplex );
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfFace", [IsVEFComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfFaceNC", [IsVEFComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup VertexOfVEFLabel
#! @Description
#! Given a VEF-complex <A>complex</A> and a VEF-label <A>label</A>, the
#! method <K>VertexOfVEFLabel</K>(<A>complex</A>, <A>label</A>) returns
#! the vertex associated to <A>label</A>.
#!
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_VEFLabels_SideBySide.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> VertexOfVEFLabel(cat, 1);
#! 1
#! gap> VertexOfVEFLabel(cat, 2);
#! fail
#! gap> VertexOfVEFLabel(cat, 7);
#! 7
#! gap> VertexOfVEFLabel(cat, 8);
#! fail
#! @EndExampleSession
#!
#! The NC-version does not check whether the given <A>label</A> is valid.
#! The normal version checks this and returns <K>fail</K> if <A>label</A>
#! is not valid.
#! @Returns a positive integer or <K>fail</K>
#! @Arguments complex, label
DeclareOperation( "VertexOfVEFLabel", [IsVEFComplex, IsPosInt] );
#! @Arguments complex, label
DeclareOperation( "VertexOfVEFLabelNC", [IsVEFComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup EdgeOfVEFLabel
#! @Description
#! Given a VEF-complex <A>complex</A> and a VEF-label <A>label</A>, the
#! method <K>EdgeOfVEFLabel</K>(<A>complex</A>, <A>label</A>) returns
#! the edge associated to <A>label</A>.
#!
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_VEFLabels_SideBySide.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> EdgeOfVEFLabel(cat, 7);
#! fail
#! gap> EdgeOfVEFLabel(cat, 9);
#! 2
#! gap> EdgeOfVEFLabel(cat, 10);
#! fail
#! gap> EdgeOfVEFLabel(cat, 16);
#! 9
#! gap> EdgeOfVEFLabel(cat, 18);
#! fail
#! @EndExampleSession
#!
#! The NC-version does not check whether the given <A>label</A> is valid.
#! The normal version checks this and returns <K>fail</K> if <A>label</A>
#! is not valid.
#! @Returns a positive integer or <K>fail</K>
#! @Arguments complex, label
DeclareOperation( "EdgeOfVEFLabel", [IsVEFComplex, IsPosInt] );
#! @Arguments complex, label
DeclareOperation( "EdgeOfVEFLabelNC", [IsVEFComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup FaceOfVEFLabel
#! @Description
#! Given a VEF-complex <A>complex</A> and a VEF-label <A>label</A>, the
#! method <K>FaceOfVEFLabel</K>(<A>complex</A>, <A>label</A>) returns
#! the face associated to <A>label</A>. 
#!
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_VEFLabels_SideBySide.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> FaceOfVEFLabel(cat, 17);
#! fail
#! gap> FaceOfVEFLabel(cat, 18);
#! 1
#! gap> FaceOfVEFLabel(cat, 20);
#! fail
#! gap> FaceOfVEFLabel(cat, 21);
#! 4
#! gap> FaceOfVEFLabel(cat, 22);
#! fail
#! @EndExampleSession
#!
#! The NC-version does not check whether the given <A>label</A> is valid.
#! The normal version checks this and returns <K>fail</K> if <A>label</A>
#! is not valid.
#! @Returns a positive integer of <K>fail</K>
#! @Arguments complex, label
DeclareOperation( "FaceOfVEFLabel", [IsVEFComplex, IsPosInt] );
#! @Arguments complex, label
DeclareOperation( "FaceOfVEFLabelNC", [IsVEFComplex, IsPosInt] );
#! @EndGroup



#! @Section Construction of Morphisms
#! @SectionLabel Morphisms_Construction
#!
#! In this section, we give several different ways to construct morphisms
#! from scratch.

#! @BeginGroup
#! @Description
#! Construct a polygonal morphism by three lists. The necessary arguments
#! are
#! * <A>sourceComplex</A>: The polygonal complex that become the source
#!   of the polygonal morphism.
#! * <A>rangeComplex</A>: The polygonal complex that becomes the range
#!   of the polygonal morphism.
#! * <A>vertexMap</A>: A list, such that for each vertex <A>v</A> in
#!   <A>sourceComplex</A>, the element <A>vertexMap[v]</A> is a vertex
#!   in <A>rangeComplex</A>, representing the image under the polygonal
#!   morphism.
#! * <A>edgeMap</A>: A list, such that for each edge <A>e</A> in
#!   <A>sourceComplex</A>, the element <A>edgeMap[v]</A> is an edge
#!   in <A>rangeComplex</A>, representing the image under the polygonal
#!   morphism.
#! * <A>faceMap</A>: A list, such that for each face <A>f</A> in
#!   <A>sourceComplex</A>, the element <A>faceMap[v]</A> is a face
#!   in <A>rangeComplex</A>, representing the image under the polygonal
#!   morphism.
#!
#! TODO example
#!
#! The NC-version does not check whether:
#! * The individual argument lists map every vertex/edge/face of
#!   <A>sourceComplex</A> to a vertex/edge/face of <A>rangeComplex</A>.
#! * The incidence structure is preserved by the mapping.
#!
#! @Returns a polygonal mapping
#! @Arguments sourceComplex, rangeComplex, vertexMap, edgeMap, faceMap
DeclareOperation( "PolygonalMorphismByLists", 
    [IsPolygonalComplex, IsPolygonalComplex, IsList, IsList, IsList] );
DeclareOperation( "PolygonalMorphismByListsNC", 
    [IsPolygonalComplex, IsPolygonalComplex, IsList, IsList, IsList] );
#! @EndGroup


# TODO implement IdentityMapping

# TODO implement InverseMapping/InverseMorphism (for appropriate...)

# TODO overload CompositionMapping2

#! @Section Elementary properties
#! @SectionLabel Morphisms_Properties

# TODO document some of the generic properties like IsInjective, IsSurjective, ...


#! @Section Images and pre-images
#! @SectionLabel Morphisms_Images
#!
#! This section contains the functionality to compute images and
#! preimages.
#!
#! TODO introduction
#!
#! We illustrate it on the following polygonal morphism.
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!    \input{Image_PolygonalMorphism_Square.tex}
#!  \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> source := PolygonalComplexByDownwardIncidence(
#! >                [[1,2],, [2,4],, [4,5], [5,6],, [6,8],, [8,10],, 
#! >                 [10,12],, [1,12], [2,12], [4,10], [4,6]],
#! >                [[1,14,15], [3,16,12,15],, [16,17,8,10], [5,6,17]]);;
#! gap> range := PolygonalComplexByDownwardIncidence( 
#! >  [[1,2], [2,3], [3,4], [4,5], [5,6],, [6,8],, [8,1], [2,8], [2,4], [4,6]],
#! >  [[1,10,9], [2,3,11],, [11,12,7,10], [4,5,12]]);;
#! gap> polMor := PolygonalMorphismByLists( source, range, 
#! >      [ 1, 2,, 4, 3, 2,, 8,, 6,, 8 ],
#! >      [ 1,, 11,, 3, 2,, 10,, 7,, 7,, 9, 10, 12, 11 ], [ 1, 4,, 4, 2 ]);;
#! @EndExampleSession


#! @BeginGroup ImageOfVertex
#! @Description
#! Given a polygonal morphism <A>polMor</A> and a vertex <A>v</A>,
#! return the image of <A>v</A> under <A>polMor</A>. If the given
#! <A>v</A> is not a vertex of the source complex (compare
#! <Ref Subsect="SourceComplex"/>)
#! of <A>polMor</A>,
#! an error is raised. The NC-version does not check whether <A>v</A>
#! is a vertex of the source complex.
#!
#! Consider the polygonal morphism from the start of section
#! <Ref Sect="Section_Morphisms_Images"/> as illustration.
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!    \input{Image_PolygonalMorphism_Square.tex}
#!  \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> ImageOfVertex(polMor, 1);
#! 1
#! gap> ImageOfVertex(polMor, 5);
#! 3
#! gap> ImageOfVertex(polMor, 6);
#! 2
#! @EndExampleSession
#!
#! @Returns a positive integer
#! @Arguments polMor, v
DeclareOperation( "ImageOfVertex", [IsPolygonalMorphism, IsPosInt] );
#! @Arguments polMor, v
DeclareOperation( "ImageOfVertexNC", [IsPolygonalMorphism, IsPosInt] );
#! @EndGroup


#! @BeginGroup ImageOfEdge
#! @Description
#! Given a polygonal morphism <A>polMor</A> and an edge <A>e</A>,
#! return the image of <A>e</A> under <A>polMor</A>. If the given
#! <A>e</A> is not an edge of the source complex (compare
#! <Ref Subsect="SourceComplex"/>)
#! of <A>polMor</A>,
#! an error is raised. The NC-version does not check whether <A>e</A>
#! is an edge of the source complex.
#!
#! Consider the polygonal morphism from the start of section
#! <Ref Sect="Section_Morphisms_Images"/> as illustration.
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!    \input{Image_PolygonalMorphism_Square.tex}
#!  \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> ImageOfEdge(polMor, 1);
#! 1
#! gap> ImageOfEdge(polMor, 5);
#! 3
#! gap> ImageOfEdge(polMor, 8);
#! 10
#! @EndExampleSession
#!
#! @Returns a positive integer
#! @Arguments polMor, e
DeclareOperation( "ImageOfEdge", [IsPolygonalMorphism, IsPosInt] );
#! @Arguments polMor, e
DeclareOperation( "ImageOfEdgeNC", [IsPolygonalMorphism, IsPosInt] );
#! @EndGroup


#! @BeginGroup ImageOfFace
#! @Description
#! Given a polygonal morphism <A>polMor</A> and a face <A>f</A>,
#! return the image of <A>f</A> under <A>polMor</A>. If the given
#! <A>f</A> is not a face of the source complex (compare
#! <Ref Subsect="SourceComplex"/>)
#! of <A>polMor</A>,
#! an error is raised. The NC-version does not check whether <A>f</A>
#! is a face of the source complex.
#!
#! Consider the polygonal morphism from the start of section
#! <Ref Sect="Section_Morphisms_Images"/> as illustration.
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!    \input{Image_PolygonalMorphism_Square.tex}
#!  \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> ImageOfFace(polMor, 1);
#! 1
#! gap> ImageOfFace(polMor, 5);
#! 2
#! gap> ImageOfFace(polMor, 4);
#! 4
#! @EndExampleSession
#!
#! @Returns a positive integer
#! @Arguments polMor, f
DeclareOperation( "ImageOfFace", [IsPolygonalMorphism, IsPosInt] );
#! @Arguments polMor, f
DeclareOperation( "ImageOfFaceNC", [IsPolygonalMorphism, IsPosInt] );
#! @EndGroup


#! @BeginGroup PreImagesOfVertex
#! @Description
#! Given a polygonal morphism <A>polMor</A> and a vertex <A>v</A> of
#! the range complex (compare
#! <Ref Subsect="RangeComplex"/>), 
#! return the set of all preimages of <A>v</A> under
#! <A>polMor</A>. If the given vertex <A>v</A> is not a vertex of the
#! range complexi, an error is raised.
#!
#! The NC-version does not check whether <A>v</A> is a vertex of the
#! range complex.
#!
#! Consider the polygonal morphism from the start of section
#! <Ref Sect="Section_Morphisms_Images"/> as illustration.
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!    \input{Image_PolygonalMorphism_Square.tex}
#!  \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> PreImagesOfVertex(polMor, 1);
#! [ 1 ]
#! gap> PreImagesOfVertex(polMor, 2);
#! [ 2, 6 ]
#! gap> PreImagesOfVertex(polMor, 5);
#! [ ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments polMor, v
DeclareOperation( "PreImagesOfVertex", [IsPolygonalMorphism, IsPosInt] );
#! @Arguments polMor, v
DeclareOperation( "PreImagesOfVertexNC", [IsPolygonalMorphism, IsPosInt] );
#! @EndGroup


#! @BeginGroup PreImagesOfEdge
#! @Description
#! Given a polygonal morphism <A>polMor</A> and an edge <A>e</A> of
#! the range complex (compare
#! <Ref Subsect="RangeComplex"/>), 
#! return the set of all preimages of <A>e</A> under
#! <A>polMor</A>. If the given edge <A>e</A> is not an edge of the
#! range complexi, an error is raised.
#!
#! The NC-version does not check whether <A>e</A> is an edge of the
#! range complex.
#!
#! Consider the polygonal morphism from the start of section
#! <Ref Sect="Section_Morphisms_Images"/> as illustration.
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!    \input{Image_PolygonalMorphism_Square.tex}
#!  \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> PreImagesOfEdge(polMor, 2);
#! [ 6 ]
#! gap> PreImagesOfEdge(polMor, 11);
#! [ 3, 17 ]
#! gap> PreImagesOfEdge(polMor, 4);
#! [ ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments polMor, e
DeclareOperation( "PreImagesOfEdge", [IsPolygonalMorphism, IsPosInt] );
#! @Arguments polMor, e
DeclareOperation( "PreImagesOfEdgeNC", [IsPolygonalMorphism, IsPosInt] );
#! @EndGroup


#! @BeginGroup PreImagesOfFace
#! @Description
#! Given a polygonal morphism <A>polMor</A> and a face <A>f</A> of
#! the range complex (compare
#! <Ref Subsect="RangeComplex"/>), 
#! return the set of all preimages of <A>f</A> under
#! <A>polMor</A>. If the given face <A>f</A> is not a face of the
#! range complexi, an error is raised.
#!
#! The NC-version does not check whether <A>f</A> is a face of the
#! range complex.
#!
#! Consider the polygonal morphism from the start of section
#! <Ref Sect="Section_Morphisms_Images"/> as illustration.
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!    \input{Image_PolygonalMorphism_Square.tex}
#!  \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> PreImagesOfFace(polMor, 2);
#! [ 5 ]
#! gap> PreImagesOfFace(polMor, 4);
#! [ 2, 4 ]
#! gap> PreImagesOfFace(polMor, 5);
#! [ ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments polMor, f
DeclareOperation( "PreImagesOfFace", [IsPolygonalMorphism, IsPosInt] );
#! @Arguments polMor, f
DeclareOperation( "PreImagesOfFaceNC", [IsPolygonalMorphism, IsPosInt] );
#! @EndGroup


#TODO
# document Image
# document PreImage


#! @Section Components of a morphism
#! @SectionLabel Morphisms_Components
#!
#! This section contains the ingredients within a polygonal morphism.
#! TODO


#! @BeginGroup SourceComplex
#! @Description
#! Return the polygonal complex (or surface) that is the source
#! of the general polygonal mapping <A>polMap</A>.
#!
#! If the source is not a polygonal surface, then <K>SourceSurface</K>
#! will return <K>fail</K>.
#!
#! @Returns a polygonal complex
#! @Arguments polMap
DeclareAttribute( "SourceComplex", IsGeneralPolygonalMorphism );
#! @Returns a polygonal surface of <K>fail</K>
#! @Arguments polMap
DeclareAttribute( "SourceSurface", IsGeneralPolygonalMorphism );
#! @EndGroup


#! @BeginGroup RangeComplex
#! @Description
#! Return the polygonal complex (or surface) that is the range
#! of the general polygonal mapping <A>polMap</A>.
#!
#! If the range is not a polygonal surface, then <K>RangeSurface</K>
#! will return <K>fail</K>.
#!
#! @Returns a polygonal complex
#! @Arguments polMap
DeclareAttribute( "RangeComplex", IsGeneralPolygonalMorphism );
#! @Returns a polygonal surface of <K>fail</K>
#! @Arguments polMap
DeclareAttribute( "RangeSurface", IsGeneralPolygonalMorphism );
#! @EndGroup


#! @BeginGroup VertexMapAsImageList
#! @Description
#! Given a polygonal morphism <A>polMor</A>, return the restriction
#! of the mapping to the vertices. The result is a list <A>vMap</A>,
#! such that <A>vMap[v]</A> is the image of the vertex <A>v</A> under
#! the polygonal morphism <A>polMor</A>. All other list entries are
#! not bound.
#!
#! TODO example
#!
#! @Returns a list
#! @Arguments polMor
DeclareAttribute( "VertexMapAsImageList", IsPolygonalMorphism );
#! @EndGroup


#! @BeginGroup EdgeMapAsImageList
#! @Description
#! Given a polygonal morphism <A>polMor</A>, return the restriction
#! of the mapping to the edges. The result is a list <A>eMap</A>,
#! such that <A>eMap[e]</A> is the image of the edge <A>e</A> under
#! the polygonal morphism <A>polMor</A>. All other list entries are
#! not bound.
#!
#! TODO example
#!
#! @Returns a list
#! @Arguments polMor
DeclareAttribute( "EdgeMapAsImageList", IsPolygonalMorphism );
#! @EndGroup


#! @BeginGroup FaceMapAsImageList
#! @Description
#! Given a polygonal morphism <A>polMor</A>, return the restriction
#! of the mapping to the faces. The result is a list <A>fMap</A>,
#! such that <A>fMap[f]</A> is the image of the face <A>f</A> under
#! the polygonal morphism <A>polMor</A>. All other list entries are
#! not bound.
#!
#! TODO example
#!
#! @Returns a list
#! @Arguments polMor
DeclareAttribute( "FaceMapAsImageList", IsPolygonalMorphism );
#! @EndGroup


#! @BeginGroup VEFLabelMapAsImageList
#! @Description
#! A polygonal morphism <A>polMor</A> can be described by a map
#! between the VEF-labels of source and target complex. This method
#! returns this map as an image list, i.e. it returns a list 
#! <A>vefMap</A>, such that <A>vefMap[x]</A> is the image of
#! the VEF-label <A>x</A>. All other list entries are not bound.
#!
#! TODO example
#!
#! @Returns a list
#! @Arguments polMor
DeclareAttribute( "VEFLabelMapAsImageList", IsPolygonalMorphism );
#! @EndGroup


#List of TODO:
# attribute VertexMapping
# attribute EdgeMapping
# attribute FaceMapping

#TODO
# Use attributes VertexMapAsImageList, EdgeMapAsImageList, FaceMapAsImageList, VEFLabelMapAsImageList
# (and their inverses, if appropriate) to define Image, PreImage etc.


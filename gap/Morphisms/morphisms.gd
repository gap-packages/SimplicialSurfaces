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
#! complexes (morphisms between twisted polygonal complexes are not implemented
#! so far).
#!
#! A morphism between two polygonal complexes <M>(V_1,E_1,F_1)</M> and
#! <M>(V_2,E_2,F_2)</M> consists of maps <M>V_1 \to V_2</M>, <M>E_1 \to E_2</M>,
#! and <M>F_1 \to F_2</M>, such that
#! * incident elements remain incident
#! * the two vertices of an edge are mapped to two different vertices
#! * different vertices/edges of a face are mapped to different vertices/edges
#!   (for example, a face with six edges cannot be mapped to a face with three edges)
#!
#! Since polygonal morphisms are stored as mappings (in the GAP-sense), all
#! methods available for mappings (in particular those from
#! section 
#! <Ref Sect="Properties and Attributes of (General) Mappings" BookName="Reference"/>) 
#! are available for polygonal
#! morphisms. In particular, <K>IsInjective</K>, <K>IsSurjective</K>,
#! <K>IsBijective</K>.
#! <!-- The reference can be found at doc/ref/mapping.xml within GAP -->
#!
#! If the edges and faces of the polygonal complexes are uniquely defined
#! by their vertices (which can be tested by <K>IsAnomalyFree</K>, compare
#! <Ref Subsect="IsAnomalyFree"/>), the polygonal morphism can be defined
#! by the vertex map (the more flexible constructor in 
#! <Ref Subsect="PolygonalMorphismByLists"/> requires all three maps). 
#! Consider the following example, in which the face 2 is mapped to the face 2,
#! and both the faces 3 and 4 are mapped to the face 3:
#! @ExampleSession
#! gap> source := PolygonalSurfaceByDownwardIncidence( 
#! >      [[1,2],[2,3],[3,4],,[1,6],,[2,7],[3,7],[4,7],,,[6,7]],
#! >      [,[1,7,12,5],[2,7,8],[3,8,9]]);;
#! gap> range := PolygonalSurfaceByDownwardIncidence(
#! >      [[1,2],[2,3],,[1,5],[2,5],,[3,6],[3,7],,,[5,6],[6,7]],
#! >      [[1,4,5],[2,5,11,7],[7,8,12]]);;
#! @EndExampleSession
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_PolygonalMorphism_Strip-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_Image_PolygonalMorphism_Strip.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> polMor := PolygonalMorphismByVertexImages(source,range, [5,6,7,6,,2,3]);
#! <polygonal morphism>
#! @EndExampleSession
#! The most important aspect of a morphism is determining images and
#! preimages of vertices, edges, and faces.
#! @ExampleSession
#! gap> ImageOfEdge(polMor, 12);
#! 2
#! gap> ImageOfFace(polMor, 4);
#! 3
#! gap> PreImagesOfEdge(polMor, 12);
#! [ 2, 3 ]
#! gap> PreImagesOfFace(polMor, 1);
#! [  ]
#! @EndExampleSession
#! 

#idea: polygonal morphisms are maps between sets: vertices+edges+faces, where edges
# are shifted by MaxVertex and faces are shifted by MaxVertex+MaxEdge
DeclareCategory("IsGeneralPolygonalMorphism", IsNonSPGeneralMapping);
DeclareSynonym("IsPolygonalMorphism", IsGeneralPolygonalMorphism and IsTotal and IsSingleValued);
# TODO are the names good? Or should we be more specific, e.g. IsPolygonalComplexMorphism, IsPolygonalSurfaceMorphism?




#! @Section Construction of Morphisms
#! @SectionLabel Morphisms_Construction
#!
#! In this section, we give several different ways to construct morphisms
#! from scratch.

#! @BeginGroup PolygonalMorphismByLists
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
#! As an illustration we define a polygonal morphisms from a 6-umbrella
#! to a 3--umbrella.
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_morphisms-1-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_morphisms-1.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> six := SimplicialSurfaceByDownwardIncidence(
#! >     [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1],,[1,8],[2,8],[3,8],[4,8],[5,8],[6,8]],
#! >     [[1,8,9],[2,9,10],[3,10,11],[4,11,12],[5,12,13],[6,13,8]]);;
#! gap> three := SimplicialSurfaceByDownwardIncidence(
#! >     [[1,2],[2,3],[3,1],,[1,5],[2,5],[3,5]], [[1,5,6],[2,6,7],[3,7,5]]);;
#! gap> vertexMap := [1,2,3,1,2,3,,5];
#! [ 1, 2, 3, 1, 2, 3,, 5 ]
#! gap> edgeMap := [1,2,3,1,2,3,,5,6,7,5,6,7];
#! [ 1, 2, 3, 1, 2, 3,, 5, 6, 7, 5, 6, 7 ]
#! gap> faceMap := [1,2,3,1,2,3];
#! [ 1, 2, 3, 1, 2, 3 ]
#! gap> polMor := PolygonalMorphismByLists(six, three, 
#! >                        vertexMap, edgeMap, faceMap);;
#! gap> SourceComplex(polMor) = six;
#! true
#! gap> RangeComplex(polMor) = three;
#! true
#! gap> VertexMapAsImageList(polMor) = vertexMap;
#! true
#! gap> EdgeMapAsImageList(polMor) = edgeMap;
#! true
#! gap> FaceMapAsImageList(polMor) = faceMap;
#! true
#! @EndExampleSession
#!
#! The NC-version does not check whether:
#! * The individual argument lists map every vertex/edge/face of
#!   <A>sourceComplex</A> to a vertex/edge/face of <A>rangeComplex</A>.
#! * The incidence structure is preserved by the mapping.
#! * The vertices incident to an edge are mappped to different vertices.
#! * A polygon is mapped to a polygon with the same number of sides.
#! * The edges incident to a face are mapped to different edges.
#! * The vertices incident to a face are mapped to different vertices.
#!
#! @Returns a polygonal mapping
#! @Arguments sourceComplex, rangeComplex, vertexMap, edgeMap, faceMap
DeclareOperation( "PolygonalMorphismByLists", 
    [IsPolygonalComplex, IsPolygonalComplex, IsList, IsList, IsList] );
#! @Arguments sourceComplex, rangeComplex, vertexMap, edgeMap, faceMap
DeclareOperation( "PolygonalMorphismByListsNC", 
    [IsPolygonalComplex, IsPolygonalComplex, IsList, IsList, IsList] );
#! @EndGroup

#! @BeginGroup PolygonalMorphismByVertexImages
#! @Description
#! Given two vertex-faithful (<Ref Subsect="IsAnomalyFree"/>)
#! polygonal complexes and a map between their
#! vertices, construct a polygonal morphism extending the vertex map.
#! The arguments are:
#! * <A>sourceComplex</A>: The vertex-faithful 
#!   polygonal complex that become the source
#!   of the polygonal morphism.
#! * <A>rangeComplex</A>: The vertex-faithful 
#!   polygonal complex that becomes the range
#!   of the polygonal morphism.
#! * <A>vertexMap</A>: A list, such that for each vertex <A>v</A> in
#!   <A>sourceComplex</A>, the element <A>vertexMap[v]</A> is a vertex
#!   in <A>rangeComplex</A>, representing the image under the polygonal
#!   morphism.
#!
#! As an illustration we define a polygonal morphisms from a 6-umbrella
#! to a 3--umbrella.
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_morphisms-2-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_morphisms-2.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> six := SimplicialSurfaceByDownwardIncidence(
#! >     [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1],,[1,8],[2,8],[3,8],[4,8],[5,8],[6,8]],
#! >     [[1,8,9],[2,9,10],[3,10,11],[4,11,12],[5,12,13],[6,13,8]]);;
#! gap> three := SimplicialSurfaceByDownwardIncidence(
#! >     [[1,2],[2,3],[3,1],,[1,5],[2,5],[3,5]], [[1,5,6],[2,6,7],[3,7,5]]);;
#! gap> vertexMap := [1,2,3,1,2,3,,5];
#! [ 1, 2, 3, 1, 2, 3,, 5 ]
#! gap> polMor := PolygonalMorphismByVertexImages(six, three, vertexMap);;
#! gap> SourceComplex(polMor) = six;
#! true
#! gap> RangeComplex(polMor) = three;
#! true
#! gap> VertexMapAsImageList(polMor) = vertexMap;
#! true
#! gap> EdgeMapAsImageList(polMor);
#! [ 1, 2, 3, 1, 2, 3,, 5, 6, 7, 5, 6, 7 ]
#! gap> FaceMapAsImageList(polMor);
#! [ 1, 2, 3, 1, 2, 3 ]
#! @EndExampleSession
#!
#! The NC-version does not check whether:
#! * The list <A>vertexMap</A> maps every vertex of
#!   <A>sourceComplex</A> to a vertex of <A>rangeComplex</A>.
#! * The incidence structure is preserved by the mapping.
#! * The vertices incident to an edge are mappped to different vertices.
#! * A polygon is mapped to a polygon with the same number of sides.
#! * The vertices incident to a face are mapped to different vertices.
#!
#! @Returns a polygonal mapping
#! @Arguments sourceComplex, rangeComplex, vertexMap
DeclareOperation( "PolygonalMorphismByVertexImages", 
    [IsPolygonalComplex and IsAnomalyFree, IsPolygonalComplex and IsAnomalyFree, IsList] );
#! @Arguments sourceComplex, rangeComplex, vertexMap
DeclareOperation( "PolygonalMorphismByVertexImagesNC", 
    [IsPolygonalComplex and IsAnomalyFree, IsPolygonalComplex and IsAnomalyFree, IsList] );
#! @EndGroup



#! @Description
#! Given a polygonal complex, return the polygonal morphism that
#! sends this complex to itself (the identity morphism).
#!
#! As an example, consider the tetrahedron:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_morphisms-3-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_morphisms-3.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> tetra := Tetrahedron();;
#! gap> id := PolygonalIdentityMorphism(tetra);;
#! gap> SourceComplex(id) = tetra;
#! true
#! gap> RangeComplex(id) = tetra;
#! true
#! gap> VertexMapAsImageList(id);
#! [ 1, 2, 3, 4 ]
#! gap> EdgeMapAsImageList(id);
#! [ 1, 2, 3, 4, 5, 6 ]
#! gap> FaceMapAsImageList(id);
#! [ 1, 2, 3, 4 ]
#! @EndExampleSession
#!
#! @Returns a polygonal mapping
#! @Arguments complex
DeclareOperation( "PolygonalIdentityMorphism", [IsPolygonalComplex] );


#! <ManSection Label="CompositionMapping">
#!   <Oper Name="CompositionMapping" Arg="mapLast, mapSecondToLast, ..." 
#!      Label="for IsPolygonalMorphism, IsPolygonalMorphism, ..."
#!      Comm="Construct the composite map from the given polygonal morphisms"/>
#!   <Oper Name="CompositionMapping2" Arg="map2, map1" 
#!      Label="for two polygonal morphisms"
#!      Comm="Construct the composite map from the given polygonal morphisms"/>
#!   <Returns>A polygonal morphism</Returns>
#!   <Description>
#!     Compose several polygonal morphisms. The method
#!     <K>CompositionMapping2</K> returns the polygonal morphisms that
#!     is obtained by first applying <A>map1</A> and then applying
#!     <A>map2</A>.
#!
#!     The method <K>CompositionMapping</K> can compose an arbitrary number
#!     of polygonal morphisms. Note that the first argument is the last map
#!     used in the composition. In
#!     addition, it also respects <K>IsInjective</K> and <K>IsSurjective</K>,
#!     if applicable.
#!
#!     If the range of the <M>i</M>-th map is not equal to the source of the 
#!     <M>(i+1)</M>th
#!     map, an error is raised.
#!
#!     We use a map from a six-umbrella to a three-umbrella as illustration.
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_morphisms-1-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_morphisms-1.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @ExampleSession
#! gap> six := SimplicialSurfaceByDownwardIncidence(
#! >     [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1],,[1,8],[2,8],[3,8],[4,8],[5,8],[6,8]],
#! >     [[1,8,9],[2,9,10],[3,10,11],[4,11,12],[5,12,13],[6,13,8]]);;
#! gap> three := SimplicialSurfaceByDownwardIncidence(
#! >     [[1,2],[2,3],[3,1],,[1,5],[2,5],[3,5]], [[1,5,6],[2,6,7],[3,7,5]]);;
#! gap> mor_6_to_6 := PolygonalIdentityMorphism(six);;
#! gap> mor_3_to_3 := PolygonalMorphismByLists(three, three,
#! >       [2,3,1,,5], [2,3,1,,6,7,5], [2,3,1]);;
#! gap> mor_6_to_3 := PolygonalMorphismByLists(six, three, 
#! >    [1,2,3,1,2,3,,5], [1,2,3,1,2,3,,5,6,7,5,6,7], [1,2,3,1,2,3]);;
#! gap> comp := CompositionMapping2(mor_3_to_3, mor_6_to_3);;
#! gap> VertexMapAsImageList(comp);
#! [ 2, 3, 1, 2, 3, 1,, 5 ]
#! gap> EdgeMapAsImageList(comp);
#! [ 2, 3, 1, 2, 3, 1,, 6, 7, 5, 6, 7, 5 ]
#! gap> FaceMapAsImageList(comp);
#! [ 2, 3, 1, 2, 3, 1 ]
#! gap> CompositionMapping2(mor_6_to_3, mor_6_to_6) = mor_6_to_3;
#! true
#! gap> CompositionMapping(mor_3_to_3, mor_6_to_3, mor_6_to_6) = comp;
#! true
#! @EndExampleSession
#!
#!   </Description>
#! </ManSection>



#! <ManSection Label="InversePolygonalMorphism">
#!   <Attr Name="InversePolygonalMorphism" Arg="isoMor" 
#!      Label="for IsPolygonalMorphism and IsBijective"
#!      Comm="Construct the inverse polygonal morphism from a bijective polygonal morphism"/>
#!   <Oper Name="Inverse" Arg="autoMor" 
#!      Label="for a bijective polygonal morphisms with identical source and range"
#!      Comm="Construct the inverse polygonal morphism from a bijective polygonal morphism with identical source and range"/>
#!   <Attr Name="InverseGeneralMapping" Arg="isoMor" 
#!      Label="for a bijective polygonal morphism"
#!      Comm="Construct the inverse polygonal morphism from a bijective polygonal morphism"/>
#!   <Returns>A polygonal morphism</Returns>
#!   <Description>
#!     Given a bijective polygonal morphism, one can define its inverse,
#!     i.e. a polygonal morphism, in which <K>SourceComplex</K>
#!     (<Ref Subsect="SourceComplex"/>) and <K>RangeComplex</K>
#!     (<Ref Subsect="RangeComplex"/>) are switched.
#!     
#!     Due to the way in which GAP handles inverses and mappings (compare the
#!     introduction of section 
#!     <Ref Sect="Arithmetic Operations for General Mapping" BookName="Reference"/>), 
#!     the different 
#!     methods perform subtly different tasks:
#!     * <K>InversePolygonalMorphism</K>(<A>isoMor</A>) 
#!       constructs the expected inverse
#!       map, from <K>RangeComplex</K>(<A>isoMor</A>) to
#!       <K>SourceComplex</K>(<A>isoMor</A>).
#!     * <K>Inverse</K>(<A>autoMor</A>) <E>only</E> constructs this inverse, if 
#!       <K>SourceComplex</K>(<A>autoMor</A>) and
#!       <K>RangeComplex</K>(<A>autoMor</A>) coincide.
#!     * <K>InverseGeneralMapping</K> does the same
#!       as <K>InversePolygonalMorphism</K>, but might be subject to future
#!       change, if inverses are defined for non-bijective morphisms in
#!       the future.
#!
#!     All of the methods throw errors if their requirements are not met.
#!
#!     To illustrate, we use a relabelling of a five-umbrella.
#!      <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_PolygonalMorphism_FiveUmbrella-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_Image_PolygonalMorphism_FiveUmbrella.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> left := SimplicialSurfaceByDownwardIncidence( 
#! >         [[1,2],[1,3],[1,4],[1,5],[1,6],[2,3],[3,4],[4,5],[5,6],[6,2]],
#! >         [[1,2,6],[2,3,7],[3,4,8],[4,5,9],[1,5,10]]);;
#! gap> right := SimplicialSurfaceByDownwardIncidence(
#! >         [,[1,3],[1,4],[1,5],[1,6],[1,7],,[3,4],[4,5],[5,6],[6,7],[3,7]],
#! >         [,,[2,3,8],[3,4,9],[4,5,10],[5,6,11],[2,6,12]]);;
#! gap> morph := PolygonalMorphismByLists(left, right,
#! >     [1,3,4,5,6,7], [2,3,4,5,6,8,9,10,11,12], [3,4,5,6,7]);;
#! gap> inv := InversePolygonalMorphism(morph);;
#! gap> SourceComplex(inv) = right;
#! true
#! gap> RangeComplex(inv) = left;
#! true
#! gap> VertexMapAsImageList(inv);
#! [ 1,, 2, 3, 4, 5, 6 ]
#! gap> EdgeMapAsImageList(inv);
#! [ , 1, 2, 3, 4, 5,, 6, 7, 8, 9, 10 ]
#! gap> FaceMapAsImageList(inv);
#! [,, 1, 2, 3, 4, 5 ]
#! @EndExampleSession
#!
#!   </Description>
#! </ManSection>
#
DeclareAttribute( "InversePolygonalMorphism", IsPolygonalMorphism and IsBijective );


#! @Section Images and pre-images
#! @SectionLabel Morphisms_Images
#!
#! This section contains the functionality to compute images and
#! preimages. Since polygonal morphisms connect two polygonal
#! complexes, it is often necessary to make this connection
#! explicit. For that reason, methods to compute images and preimages
#! are provided.
#! 
#! Currently, the following methods are implemented:
#! * For vertices: <K>ImageOfVertex</K> (<Ref Subsect="ImageOfVertex"/>)
#!   and <K>PreImagesOfVertex</K> (<Ref Subsect="PreImagesOfVertex"/>).
#! * For edges: <K>ImageOfEdge</K> (<Ref Subsect="ImageOfEdge"/>)
#!   and <K>PreImagesOfEdge</K> (<Ref Subsect="PreImagesOfEdge"/>).
#! * For faces: <K>ImageOfFace</K> (<Ref Subsect="ImageOfFace"/>)
#!   and <K>PreImagesOfFace</K> (<Ref Subsect="PreImagesOfFace"/>).
#!
#! We illustrate these methods on the following polygonal morphism.
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_morphisms-4-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_morphisms-4.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_morphisms-5-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_morphisms-5.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_morphisms-6-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_morphisms-6.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_morphisms-7-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_morphisms-7.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_morphisms-8-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_morphisms-8.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_morphisms-9-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_morphisms-9.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_morphisms-10-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_morphisms-10.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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


#! @Section Consistent labels for vertices, edges, and faces
#! @SectionLabel VEFLabels
#!
#! We have defined polygonal complexes in a way such that the labels for vertices,
#! edges, and faces do not have to be distinct. While this is more convenient
#! for the casual user, it is sometimes practical to enforce distinct labels.
#! Notably, these cases include morphisms and automorphism groups.
#!
#! The distinct label set is called <K>VEFLabels</K>. Consider the following
#! polygonal surface:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_morphisms-11-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_morphisms-11.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_morphisms-12-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_morphisms-12.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
#! Return the set of VEF-labels for the given polygonal complex. The
#! VEF-labels are a set of labels that distinguish vertices,
#! edges, and faces. It is constructed as follows:
#! * The vertex labels stay the same
#! * The edge labels are shifted upwards by the maximal vertex label
#! * The face labels are shifted upwards by the sum of maximal vertex
#!   label and maximal edge label
#!
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_VEFLabels_SideBySide-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_VEFLabels_SideBySide.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
DeclareAttribute( "VEFLabels", IsPolygonalComplex );
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
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_VEFLabels_SideBySide-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_VEFLabels_SideBySide.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
DeclareAttribute( "VEFLabelsOfVertices", IsPolygonalComplex );
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfVertex", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfVertexNC", [IsPolygonalComplex, IsPosInt]);
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
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_VEFLabels_SideBySide-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_VEFLabels_SideBySide.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
DeclareAttribute( "VEFLabelsOfEdges", IsPolygonalComplex );
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfEdge", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfEdgeNC", [IsPolygonalComplex, IsPosInt]);
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
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_VEFLabels_SideBySide-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_VEFLabels_SideBySide.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
DeclareAttribute( "VEFLabelsOfFaces", IsPolygonalComplex );
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfFace", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfFaceNC", [IsPolygonalComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup VertexOfVEFLabel
#! @Description
#! Given a polygonal complex <A>complex</A> and a VEF-label <A>label</A>, the
#! method <K>VertexOfVEFLabel</K>(<A>complex</A>, <A>label</A>) returns
#! the vertex associated to <A>label</A>.
#!
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_VEFLabels_SideBySide-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_VEFLabels_SideBySide.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
DeclareOperation( "VertexOfVEFLabel", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, label
DeclareOperation( "VertexOfVEFLabelNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup EdgeOfVEFLabel
#! @Description
#! Given a polygonal complex <A>complex</A> and a VEF-label <A>label</A>, the
#! method <K>EdgeOfVEFLabel</K>(<A>complex</A>, <A>label</A>) returns
#! the edge associated to <A>label</A>.
#!
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_VEFLabels_SideBySide-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_VEFLabels_SideBySide.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
DeclareOperation( "EdgeOfVEFLabel", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, label
DeclareOperation( "EdgeOfVEFLabelNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup FaceOfVEFLabel
#! @Description
#! Given a polygonal complex <A>complex</A> and a VEF-label <A>label</A>, the
#! method <K>FaceOfVEFLabel</K>(<A>complex</A>, <A>label</A>) returns
#! the face associated to <A>label</A>. 
#!
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_VEFLabels_SideBySide-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_VEFLabels_SideBySide.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
DeclareOperation( "FaceOfVEFLabel", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, label
DeclareOperation( "FaceOfVEFLabelNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup



#! @Section Components of a morphism
#! @SectionLabel Morphisms_Components
#!
#! This section contains the ingredients within a polygonal morphism, 
#! i.e. source and range complex, as well as the maps on vertices, edges,
#! and faces.
#!
#! We will illustrate them on the following polygonal morphism (on the
#! sides are the VEF-labels):
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_PolygonalMorphism_Strip-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_Image_PolygonalMorphism_Strip.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> source := PolygonalSurfaceByDownwardIncidence( 
#! >      [[1,2],[2,3],[3,4],,[1,6],,[2,7],[3,7],[4,7],,,[6,7]],
#! >      [,[1,7,12,5],[2,7,8],[3,8,9]]);;
#! gap> range := PolygonalSurfaceByDownwardIncidence(
#! >      [[1,2],[2,3],,[1,5],[2,5],,[3,6],[3,7],,,[5,6],[6,7]],
#! >      [[1,4,5],[2,5,11,7],[7,8,12]]);;
#! gap> polMor := PolygonalMorphismByLists(source,range,
#! >      [5,6,7,6,,2,3], [11,12,12,,5,,7,8,7,,,2], [,2,3,3]);;
#! @EndExampleSession
#! 


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
#! We illustrate this on the polygonal morphism from the start of
#! section <Ref Sect="Section_Morphisms_Components"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_PolygonalMorphism_Strip-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_Image_PolygonalMorphism_Strip.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> VertexMapAsImageList(polMor);
#! [ 5, 6, 7, 6,, 2, 3 ]
#! @EndExampleSession
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
#! We illustrate this on the polygonal morphism from the start of
#! section <Ref Sect="Section_Morphisms_Components"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_PolygonalMorphism_Strip-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_Image_PolygonalMorphism_Strip.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> EdgeMapAsImageList(polMor);
#! [ 11, 12, 12,, 5,, 7, 8, 7,,, 2 ]
#! @EndExampleSession
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
#! We illustrate this on the polygonal morphism from the start of
#! section <Ref Sect="Section_Morphisms_Components"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_PolygonalMorphism_Strip-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_Image_PolygonalMorphism_Strip.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> FaceMapAsImageList(polMor);
#! [ , 2, 3, 3 ]
#! @EndExampleSession
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
#! We illustrate this on the polygonal morphism from the start of
#! section <Ref Sect="Section_Morphisms_Components"/> (the VEF-labels
#! are drawn on the sides).
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_morphisms-13-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_morphisms-13.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @ExampleSession
#! gap> VEFLabelMapAsImageList(polMor);
#! [ 5, 6, 7, 6,, 2, 3, 18, 19, 19,, 12,, 14, 15, 14,,, 9,, 21, 22, 22 ]
#! @EndExampleSession
#!
#! @Returns a list
#! @Arguments polMor
DeclareAttribute( "VEFLabelMapAsImageList", IsPolygonalMorphism );
#! @EndGroup


#List of TODO:
# attribute VertexMapping
# attribute EdgeMapping
# attribute FaceMapping



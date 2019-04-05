

#! @Chapter Distances
#! @ChapterLabel Distances

#! This chapter introduces methods to compute distances between vertices () and faces () of a polygonal complex.
#! Although the two concepts are very similar to each other, they will be treated in different sections, to make the explanations more readable and do not let the examples become too long.
#! 
#! In section <Ref Sect="Section_Distances_Vertices"/> distances between vertices in a polygonal complex are defined. A definition for distances between faces can be found in section <Ref Sect="Section_Distances_Faces"/>.
#! 
#! 
#! Most of the examples are platonic solids. They are already sufficiently complex to illustrate the methods, while remaining conceptually simple to make it easy to follow manipulations on them.

#! @Section Calculating the distance between vertices
#! @SectionLabel Distances_Vertices


#! This section contains the methods to compute distances between vertices in a polygonal complex (). It also contains methods building on the distance calculation, for example to construct neighbourhoods of vertices ().



#! @BeginGroup DistanceOfVertices

#! @Description
#! This method computes the distance of two vertices in a polygonal complex by determining the length of a minimal vertex-edge-path <Ref Sect="Section_Paths_VertexEdge"/> between the given two vertices ( The length is the number of edges).
#! 
#! If there does not exist any vertex-edge-path between <A>vertex1</A> and <A>vertex2</A>, which means that the vertices are located in different connected components of <A>polygonalComplex</A>, -1 will be returned.
#! If the vertices are identical, their distance is defined as 0.
#! 
#! The NC-Version does not check whether <A>vertex1</A> and <A>vertex2</A> are vertices of <A>polygonalComplex</A>.
#!
#! @ExampleSession
#! gap> cube := Cube();;
#! gap> DistanceOfVertices(cube,1,9);
#! Error, At least one of the vertices 1 and 9 does not lie in the given complex.
#! gap> DistanceOfVertices(cube,1,3);
#! 2 
#! gap> tet := Tetrahedron();;
#! gap> DistanceOfVertices(tet,1,1);
#! 0
#! gap> TwoDisjointTriangles := SimplicialSurfaceByDownwardIncidence([[1,2],
#! > [2,3],[1,3],[4,5],[5,6],[4,6]],[[1,2,3],[4,5,6]]);;
#! gap> IsPolygonalComplex(TwoDisjointTriangles);
#! true
#! gap> DistanceOfVertices(TwoDisjointTriangles,3,4);
#! -1
#! @EndExampleSession
#!
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{TwoDisjointTriangles_picture.pdf}
#! \end{center}
#! </Alt>
#!
#! @Returns a non-negative integer, or -1.
#! @Arguments polygonalComplex, vertex1, vertex2
DeclareOperation( "DistanceOfVertices", [ IsPolygonalComplex, IsPosInt, IsPosInt ] );
DeclareOperation( "DistanceOfVerticesNC", [ IsPolygonalComplex, IsPosInt, IsPosInt] );
#! @EndGroup

#! @BeginGroup NeighbourVerticesOfVertex

#! @Description

#! Given a polygonal complex <A>polygonalComplex</A> and a vertex, this method return a list of all vertices of <A>polygonalComplex</A>, which are connected to <A>vertex</A> by an edge, i.e. all neighbour-vertices of <A>vertex</A>.
#!
#! The NC-Version does not check whether <A>vertex</A> is a vertex of <A>polygonalComplex</A>.
#!
#! @ExampleSession
#! gap> cube := Cube();;
#! gap> NeighbourVerticesOfVertex(cube,3);
#! [ 2, 4, 7 ]
#! gap> NeighbourVerticesOfVertex(cube,8);
#! [ 4, 7, 5 ]
#! gap> NeighbourVerticesOfVertex(cube,9);
#! Error, The vertex 9 does not lie in the given complex.
#! @EndExampleSession

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{Cube_picture.pdf}
# \input{_TIKZ_Cube_constructor.tex}
#! \end{center}
#! </Alt>

#! @ExampleSession
#! gap> tet:=Tetrahedron();;
#! gap> NeighbourVerticesOfVertex(tet,1);
#! [ 2, 3, 4 ]
#! @EndExampleSession
#!
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{Tetrahedron_picture.pdf}
#! \end{center}
#! </Alt>
#!
#! @Returns a list of positive integers
#! @Arguments polygonalComplex, vertex
DeclareOperation( "NeighbourVerticesOfVertex", [IsPolygonalComplex, IsPosInt] );
#! @Arguments polygonalComplex, vertex
DeclareOperation( "NeighbourVerticesOfVertexNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @Section Calculating the distance between faces
#! @SectionLabel Distances_Faces

#! Analogously to section <Ref Sect="Section_Distances_Vertices"/>, distance-concept for faces will be treated.

#! @BeginGroup DistanceOfFaces

#! @Description
#! This method computes the distance of two faces in a polygonal complex, by determining the length of a minimal face-edge-path <Ref Sect="Section_Paths_EdgeFace"/> between the given two faces (The length is the number of edges).
#! If there does not exist any face-edge-path between <A>face1</A> and <A>face2</A>, which means that the faces are located in different connected components of <A>polygonalComplex</A>, -1 will be returned.
#! If <A>face1</A> and <A>face2</A> are identical, their distance is defined as 0.
#! 
#! The NC-Version does not check whether <A>face1</A> and <A>face2</A> are faces of <A>polygonalComplex</A>.
#!
#! @ExampleSession
#! gap> cube := Cube();;
#! gap> DistanceOfFaces(cube,1,6);
#! 2
#! gap> DistanceOfFaces(cube,1,5);
#! 1
#! gap> DistanceOfFaces(cube,1,1);
#! 0
#! @EndExampleSession

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{Cube_picture.pdf}
#! \end{center}
#! </Alt>

#! @ExampleSession
#! gap> TwoDisjointTriangles := SimplicialSurfaceByDownwardIncidence([[1,2],
#! > [2,3],[1,3],[4,5],[5,6],[4,6]],[[1,2,3],[4,5,6]]);;
#! gap> DistanceOfFaces(TwoDisjointTriangles,1,3);
#! Error, At least one of the faces 1 and 3 does not lie in the given complex.
#! gap> DistanceOfFaces(TwoDisjointTriangles,1,2);
#! -1
#! @EndExampleSession
#!
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{TwoDisjointTriangles_picture.pdf}
#! \end{center}
#! </Alt>
#!
#! @Returns a non-negative integer, or -1.
#! @Arguments polygonalComplex, face1, face2
DeclareOperation( "DistanceOfFaces", [ IsPolygonalComplex, IsPosInt, IsPosInt ] );
DeclareOperation( "DistanceOfFacesNC", [ IsPolygonalComplex, IsPosInt, IsPosInt] );
#! @EndGroup

#! @BeginGroup NeighbourFacesOfFace

#! @Description
#! This method computes the list of all faces of <A>polygonalComplex</A>, which share an edge with <A>face</A>.
#! 
#! The NC-Version does not check whether <A>face</A> is a face of <A>polygonalComplex</A>.

#!
#! @ExampleSession
#! gap> cube := Cube();;
#! gap> NeighbourFacesOfFace(cube,7);
#! Error, The face 7 does not lie in the given complex.
#! gap> NeighbourFacesOfFace(cube,4);
#! [ 1, 5, 2, 6 ]
#! @EndExampleSession

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{Cube_picture.pdf}
#! \end{center}
#! </Alt>

#! @ExampleSession
#! gap> tet:=Tetrahedron();;
#! gap> NeighbourFacesOfFace(tet,1);
#! [ 2, 4, 3 ]
#! @EndExampleSession

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{Tetrahedron_picture.pdf}
#! \end{center}
#! </Alt>

#! @ExampleSession
#! gap> Triangle := SimplicialSurfaceByDownwardIncidence([[1,2],
#! > [2,3],[1,3]],[[1,2,3]]);;
#! gap> NeighbourFacesOfFace(Triangle,2);
#! Error, The face 2 does not lie in the given complex.
#! gap> NeighbourFacesOfFace(Triangle,1);
#! [ ]
#! @EndExampleSession
#! 

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{Triangle_picture.pdf}
#! \end{center}
#! </Alt>

#! @Returns a list of positive integers
#! @Arguments polygonalComplex, face

DeclareOperation( "NeighbourFacesOfFace", [IsPolygonalComplex, IsPosInt] );
DeclareOperation( "NeighbourFacesOfFaceNC", [IsPolygonalComplex, IsPosInt] );

#! @EndGroup

#! @Section Restricting polygonal complexes
#! @SectionLabel Restriction_Neighbourhoods

#! In this section introduces methods to restrict polygonal complexes to sub-complexes. It contains the following methods: 
#! + Given a polygonal complex, a distance, and some faces of the polygonal complex, compute a new polygonal complex, where every face has distance at most given <A>dist</A> to one of the given faces
#! + Given a polygonal complex, a distance, and some vertices of the polygonal complex, compute a new polygonal complex, where every vertex has distance at most given <A>dist</A> to one of the given vertices.
#! 

#! @BeginGroup RestrictionToNeighbourhoodOfFaces


#! @Description
#! Given a polygonal complex and a list of faces <A>listOfFaces</A>, this method restricts <A>polygonalComplex</A> to a neighbourhood of these faces, defined by dist. It is constructed from all faces, that have distance at most <A>dist</A> to one of the faces in <A>listOfFaces</A>. The distance of two faces is measured by the length of a minimal face-edge-path between these faces.
#! 
#! The NC-Version does not check whether the given faces lie in the polygonal complex.
#!
#! @ExampleSession
#! gap> cube := Cube();;
#! @EndExampleSession

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{Cube_picture.pdf}
#! \end{center}
#! </Alt>

#! @ExampleSession
#! gap> RestrictionToNeighbourhoodOfFaces( cube, 2, [1,2,3]) = cube;
#! true
#! gap> RestrictionToNeighbourhoodOfFaces( cube, 2, [3,7,22]);
#! Error, The faces in [ 7, 22 ] do not lie in the given complex.
#! gap> restrSurf := RestrictionToNeighbourhoodOfFaces(cube,1,[1]);;
#! gap> Faces(restrSurf);
#! [ 1, 2, 3, 4, 5 ]
#! gap> Edges(restrSurf);
#! [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]
#! gap> Vertices(restrSurf);
#! [ 1, 2, 3, 4, 5, 6, 7, 8 ]
#! @EndExampleSession

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{RestrictedCube_picture.pdf}
#! \end{center}
#! </Alt>

#! It is easy to see that **restrSurf** is a cube, where one face (face 6) is missing.

#! @ExampleSession
#! gap> ico := Icosahedron();;
#! @EndExampleSession

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{Icosahedron_picture.pdf}
#! \end{center}
#! </Alt>

#! @ExampleSession
#! gap> restrico := RestrictionToNeighbourhoodOfFaces(ico,1,[4]);;
#! gap> IsSimplicialSurface(restrico);
#! true
#! gap> Faces(restrico);
#! [ 3, 4, 5, 9 ]
#! gap> restrico := RestrictionToNeighbourhoodOfFaces(ico,2,[4]);;
#! gap> Faces(restrico);
#! [ 1, 2, 3, 4, 5, 8, 9, 10, 13, 14 ]
#! @EndExampleSession

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{NeueReihenfolgeRestrIco_picture.pdf}
#! \end{center}
#! </Alt>
#!
#! @Returns a polygonal complex
#! @Arguments polygonalComplex, dist, listOfFaces

DeclareOperation( "RestrictionToNeighbourhoodOfFaces", [ IsPolygonalComplex, IsPosInt, IsList ] );
DeclareOperation( "RestrictionToNeighbourhoodOfFacesNC", [ IsPolygonalComplex, IsPosInt, IsList ] );

#! @EndGroup


#! @BeginGroup RestrictionToNeighbourhoodOfVertices

#! @Description

#! This method restricts a triangular complex to a sub-complex. This sub-complex consists of:
#! * all vertices that have distance at most <A>dist</A> to one of the given vertices in <A>listOfVertices</A>, where distance is measured as in DistanceOfVertices () <Ref Section="Sect_Distances_Vertices"/>.
#! * all edges that connect two included vertices, and
#! * all faces whose incident edges and vertices are included.
#! 
#! The NC-Version does not check whether <A>listOfVertices</A> is a list of vertices of <A>triangularComplex</A>.

#! @ExampleSession
#! gap> octa := Octahedron();;
#! @EndExampleSession

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{Octahedron_picture.pdf}
#! \end{center}
#! </Alt>

#! @ExampleSession
#! gap> restrocta:=RestrictionToNeighbourhoodOfVertices(octa,1,[1]);;
#! gap> IsSimplicialSurface(restrocta);
#! true
#! gap> Faces(restrocta);
#! [ 1, 3, 5, 7 ]
#! gap> Edges(restrocta);
#! [ 1, 2, 3, 4, 5, 6, 8, 10 ]
#! gap> Vertices(restrocta);
#! [ 1, 2, 3, 4, 5 ]
#! 
#! @EndExampleSession
#!
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{RestrictedOctahedron_picture.pdf}
#! \end{center}
#! </Alt>

#! @ExampleSession
#! gap> ico := Icosahedron();;
#! @EndExampleSession

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{Icosahedron_picture.pdf}
#! \end{center}
#! </Alt>

#! @ExampleSession
#! gap> restricoOne := RestrictionToNeighbourhoodOfVerticesNC(ico,1,[4]);;
#! gap> IsSimplicialSurface(restricoOne);
#! true
#! gap> Faces(restricoOne);
#! [ 2, 3, 7, 8, 12 ]
#! @EndExampleSession

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{RestrictedIcosahedronByVerticesDistOne_picture.pdf}
#! \end{center}
#! </Alt>

#! @ExampleSession
#! gap> restricoTwo := RestrictionToNeighbourhoodOfVertices(ico,2,[4]);;
#! gap> IsSimplicialSurface(restricoTwo);
#! true
#! gap> Faces(restricoTwo);
#! [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 16, 17, 18 ]
#! @EndExampleSession

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{RestrictedIcosahedronByVerticesDistTwo_picture_newordered.pdf}
#! \end{center}
#! </Alt>

#! @ExampleSession
#! gap> tet := Tetrahedron();;
#! gap> tet=RestrictionToNeighbourhoodOfVerticesNC(tet,1,[1]);
#! true
#! @EndExampleSession

#! @Returns a triangular complex
#! @Arguments triangularComplex, dist, listOfVertices

DeclareOperation( "RestrictionToNeighbourhoodOfVertices", [ IsTriangularComplex, IsPosInt, IsList ] );
DeclareOperation( "RestrictionToNeighbourhoodOfVerticesNC", [ IsTriangularComplex, IsPosInt, IsList ] );

#! @EndGroup


#! The method <K>RestrictionToNeighbourhoodOfVertices</K> is only defined for triangular complexes. The reason can be seen easily when looking at a small example: Consider a square.

#! @ExampleSession
#! gap> MySquare := PolygonalSurfaceByDownwardIncidence([[1,2],
#! > [2,3],[3,4],[4,1]],[[1,2,3,4]]);;
#! @EndExampleSession

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{Square_picture.pdf}
#! \end{center}
#! </Alt>

#! When restricting the square to a neighbourhood of the vertex 1 with maximal distance 1, the vertices 2 and 4 need to lie in the polygonal complex. Unfortunately, vertex 3 does not lie in the restriction, so face 1 can not be part of the restriction and so the vertices 2 and 4 are not incident to any face in the restricted polygonal complex, which is not possible.

#! @Section Application of distance-calculations
#! @SectionLabel Distance_Vertices_Application


#! This section contains some application for the method <K>DistanceOfVertices</K> on polygonal complexes. Therefore polygonal complexes can be treated as graphs where the vertices are the nodes and the edges are the edges of the graph. The presented methods compute the eccentricity of a vertex, the diameter, the radius and the center of a polygonal complex. In the examples the following polygonal complexes are used:

#! @ExampleSession
#! gap> Bat:=SimplicialSurfaceByDownwardIncidence([[1,2],[1,3],[2,3],[2,4],[3,4],
#! > [3,5],[4,5],[5,6],[4,6],[4,7],[6,7],[6,8],[7,8]],[[1,2,3],[3,4,5],[5,6,7],
#! > [7,8,9],[9,10,11],[11,12,13]]);;
#! gap> TwoDisjointTriangles := SimplicialSurfaceByDownwardIncidence([[1,2],
#! > [2,3],[1,3],[4,5],[5,6],[4,6]],[[1,2,3],[4,5,6]]);;
#! @EndExampleSession

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{Bat_picture.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{TwoDisjointTriangles_picture.pdf}
#! \end{center}
#! </Alt>

#! @BeginGroup EccentricityOfVertex
#! @Description
#! This method computes the **eccentricity** of a vertex in a polygonal complex. The eccentricity of a vertex is the maximal distance <A>vertex</A> has to any other vertex in the polygonal complex. If some vertices have infinite distance to each other, then the eccentricity is defined as -1.
#!
#!The NC-Version does not check whether the given vertex lies in the polygonal complex.
#! @ExampleSession
#! gap> Bat:=SimplicialSurfaceByDownwardIncidence([[1,2],[1,3],[2,3],[2,4],[3,4],
#! > [3,5],[4,5],[5,6],[4,6],[4,7],[6,7],[6,8],[7,8]],[[1,2,3],[3,4,5],[5,6,7],
#! > [7,8,9],[9,10,11],[11,12,13]]);;
#! gap> EccentricityOfVertex(Bat,3);
#! 3
#! gap> EccentricityOfVertex(Bat,9);
#! Error, The given vertex 9 does not lie in the given polygonal complex.
#! gap> TwoDisjointTriangles := SimplicialSurfaceByDownwardIncidence([[1,2],
#! > [2,3],[1,3],[4,5],[5,6],[4,6]],[[1,2,3],[4,5,6]]);;
#! gap> EccentricityOfVertex(TwoDisjointTriangles,1);
#! -1
#! @EndExampleSession

#! @Returns a non-negative integer or -1
#! @Arguments  polygonalComplex,vertex

DeclareOperation( "EccentricityOfVertex", [ IsPolygonalComplex, IsPosInt ] );
DeclareOperation( "EccentricityOfVertexNC", [ IsPolygonalComplex, IsPosInt ] );

#! @EndGroup

#! @Description
#! This method computes the **diameter** of a polygonal complex. The diameter of a polygonal complex is the maximal distance of any two vertices in the polygonal complex.
#! If some vertices have infinite distance to each other (that is when the eccentricity of one vertex is -1, then the diameter is defined as -1, too.
#! @ExampleSession
#! gap> Bat:=SimplicialSurfaceByDownwardIncidence([[1,2],[1,3],[2,3],[2,4],[3,4],
#! > [3,5],[4,5],[5,6],[4,6],[4,7],[6,7],[6,8],[7,8]],[[1,2,3],[3,4,5],[5,6,7],
#! > [7,8,9],[9,10,11],[11,12,13]]);;
#! gap> DiameterOfPolygonalComplex(Bat);
#! 4
#! gap> TwoDisjointTriangles := SimplicialSurfaceByDownwardIncidence([[1,2],
#! > [2,3],[1,3],[4,5],[5,6],[4,6]],[[1,2,3],[4,5,6]]);;
#! gap> DiameterOfPolygonalComplex(TwoDisjointTriangles);
#! -1
#! @EndExampleSession

#! @Returns a non-negative integer or -1
#! @Arguments  polygonalComplex

DeclareAttribute( "DiameterOfPolygonalComplex", IsPolygonalComplex );

#! @Description
#! The method computes the **radius** of a polygonal complex. The radius is the minimal eccentricity of all vertices in the polygonal complex.
#! If some vertices have infinite distance to each other (that is when the eccentricity of one vertex is -1), then the radius is definded as -1, too.
#! @ExampleSession
#! gap> Bat:=SimplicialSurfaceByDownwardIncidence([[1,2],[1,3],[2,3],[2,4],[3,4],
#! > [3,5],[4,5],[5,6],[4,6],[4,7],[6,7],[6,8],[7,8]],[[1,2,3],[3,4,5],[5,6,7],
#! > [7,8,9],[9,10,11],[11,12,13]]);;
#! gap> RadiusOfPolygonalComplex(Bat);
#! 2
#! gap> TwoDisjointTriangles := SimplicialSurfaceByDownwardIncidence([[1,2],
#! > [2,3],[1,3],[4,5],[5,6],[4,6]],[[1,2,3],[4,5,6]]);;
#! gap> RadiusOfPolygonalComplex(TwoDisjointTriangles);
#! -1
#! @EndExampleSession

#! @Returns a non-negative integer or -1
#! @Arguments  polygonalComplex

DeclareAttribute( "RadiusOfPolygonalComplex", IsPolygonalComplex );

#! @Description
#! This method computes the **center** of a polygonal complex. The center of a polygonal complex is the set of all vertices of <A>polygonalComplex</A>, whose eccentricity is equal to the radius of <A>polygonalComplex</A>.
#! If some vertices have infinite distance to each other, then the center is definded as the empty set [ ].
#!
#! @ExampleSession
#! gap> Bat:=SimplicialSurfaceByDownwardIncidence([[1,2],[1,3],[2,3],[2,4],[3,4],
#! > [3,5],[4,5],[5,6],[4,6],[4,7],[6,7],[6,8],[7,8]],[[1,2,3],[3,4,5],[5,6,7],
#! > [7,8,9],[9,10,11],[11,12,13]]);;
#! gap> CenterOfPolygonalComplex(Bat);
#! [ 4, 5 ]
#! gap> TwoDisjointTriangles := SimplicialSurfaceByDownwardIncidence([[1,2],
#! > [2,3],[1,3],[4,5],[5,6],[4,6]],[[1,2,3],[4,5,6]]);;
#! gap> CenterOfPolygonalComplex(TwoDisjointTriangles);
#! [ ]
#! @EndExampleSession

#! @Returns a set of positive integers or the empty set
#! @Arguments  polygonalComplex

DeclareAttribute( "CenterOfPolygonalComplex", IsPolygonalComplex );



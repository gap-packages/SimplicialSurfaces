

#! @Chapter Distances

#! In this first section we will introduce some methods to compute distances of vertices and faces in polygonal complexes. Although the two concepts are very similar to each other, we will look at them in different sections, to make the explanations more readable and do not let the examples become too long.
#! 
#! First we will have a look at distances between vertices in a polygonal complex. The distance of two vertices is measured by the length of a shortest vertex-edge-path between these vertices. In other words we we can look at polygonal complexes as labeled graphs, where every edge has length one.
#! 
#! Secondly we study the distance concept for faces in a polygonal complexes. Analogously, we define the **distance** of two faces as the length of a shortest face-edge-path between these two faces.
#! 
#! Most of our examples are platonic solids. They are already sufficiently complex to illustrate the methods, while remaining conceptually simple to make it easy to follow manipulations on them.

#! @Section Calculating the distance between vertices 

#! Before we come to the announced methods for distance-calculations we first look at a method, which is the basis of distance-calculations on polygonal complexes and gives us an idea about what we want to attain within this paper, i.e. constructing **sub-complex** of polygonal complexes, whose vertices/faces have a limited (given) distance to each other.


#! @BeginGroup NeighbourVerticesOfVertex

#! @Description

#!The output will be a list of all vertices of the polygonal complex <A>polygonalComplex</A>, which are connected to <A>vertex</A> by an edge, i.e. all neighbour-vertices of the vertex <A>vertex</A>.
#!
#! The NC-Version does **not** check whether the vertex <A>vertex</A> is part of the given polygonal complex <A>polygonalComplex</A>. If this is not the case for a call to <K>NeighbourVerticesOfVertex</K>, then an error will be raised.
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
#! @Arguments polygonalComplex, vertex
#! @Returns a list of positive integers.
DeclareOperation( "NeighbourVerticesOfVertex", [IsPolygonalComplex, IsPosInt] );
#!
#! @Arguments polygonalComplex, vertex
#! @Returns a list of positive integers.
DeclareOperation( "NeighbourVerticesOfVertexNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup DistanceOfVertices

#! @Description
#! The method computes the distance of two vertices in a polygonal complex by determining the length of a minimal vertex-edge-path between the given two vertices ( where every edge is of length 1).
#! 
#! If there does not exist any vertex-edge-path between <A>vertex1</A> and <A>vertex2</A>, which means that the vertices are located in different connected components of <A>polygonalComplex</A>, a -1 will be returned.
#! If the vertices are the same, their distance is defined as 0.
#! 
#! The NC-Version <K>DistanceOfVerticesNC</K> does **not** check whether the two given vertices are part of the polygonal complex <A>polygonalComplex</A>. If that is not true for a call to <K>DistanceOfVertices</K>, an error will be raised.
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
#! @Arguments polygonalComplex, vertex1, vertex2
#! @Returns a non-negative integer, or -1.
DeclareOperation( "DistanceOfVertices", [ IsPolygonalComplex, IsPosInt, IsPosInt ] );
#! @Arguments polygonalComplex, vertex1, vertex2
#! @Returns a non-negative integer, or -1.
DeclareOperation( "DistanceOfVerticesNC", [ IsPolygonalComplex, IsPosInt, IsPosInt] );
#! @EndGroup


#! @Section Calculating the distance between faces
#! Analogously to section 1.1, we now look at the distance-concept for faces.
#! 
#! Therefore we will first consider a method which gives us the immediate neighbour-faces of a face in a polygonal complex.
#! 
#! Secondly we will introduce the concept of distances between faces and how to compute them.


#! @BeginGroup NeighbourFacesOfFace

#! @Description
#! The method <K>NeighbourFacesOfFace</K> computes the list of all faces of <A>polygonalComplex</A>, which share an edge with the face <A>face</A>. So the function gives us all neighbour-faces of the face <A>face</A>.
#! 
#! The NC-Version does **not** check whether the face <A>face</A> is part of the given polygonal complex <A>polygonalComplex</A>. If this condition does not hold for a call to <K>NeighbourFacesOfFace</K> an error will be raised.

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


#! @Arguments polygonalComplex, face
#! @Returns a list of positive integers
DeclareOperation( "NeighbourFacesOfFace", [IsPolygonalComplex, IsPosInt] );
#! @Arguments polygonalComplex, face
#! @Returns a list of positive integers.
DeclareOperation( "NeighbourFacesOfFaceNC", [IsPolygonalComplex, IsPosInt] );

#! @EndGroup


#! @BeginGroup DistanceOfFaces

#! @Description
#! This function computes the distance of two faces in a polygonal complex, by determining the length of a minimal face-edge-path between the given two faces. Every edge has length 1.
#! If there does not exist any face-edge-path between <A>face1</A> and <A>face2</A>, which means that the faces are located in different connected-components of <A>polygonalComplex</A>, a -1 will be returned.
#! If the faces <A>face1</A> and <A>face2</A> are the same, their distance is defined as 0.
#! 
#! The NC-Version <K>DistanceOfFacesNC</K> does **not** check whether the two given faces are part of the polygonal complex <A>polygonalComplex</A>. If they are not, then a call to <K>DistanceOfFaces</K> will lead to an error.
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
#! @Arguments polygonalComplex, face1, face2
#! @Returns a non-negative integer, or -1.
DeclareOperation( "DistanceOfFaces", [ IsPolygonalComplex, IsPosInt, IsPosInt ] );
#! @Arguments polygonalComplex, face1, face2
#! @Returns a non-negative integer, or -1.
DeclareOperation( "DistanceOfFacesNC", [ IsPolygonalComplex, IsPosInt, IsPosInt] );

#! @EndGroup

#! @Section Restricting polygonal complexes

#! In this section we will introduce methods to restrict polygonal complexes to sub-complexes. To be precise, we want to do the following: Given a polygonal complex, a distance, and some given faces (or given vertices) of the polygonal complex, we want to compute a new polygonal complex, where every face (resp. vertex) has distance at most given <A>distance</A> to one of the given faces (resp. given vertices)
#! 
#! 

#! We begin with the restriction of polygonal complexes to neighbourhoods of faces.

#! @BeginGroup RestrictionToNeighbourhoodOfFaces


#! @Description
#! This method restricts a polygonal complex to a neighbourhood of given faces, i.e. all faces, that have distance of at most given <A>distance</A> to one of the given 'starting-faces'. The distance of two faces is measured as the length of a minimal face-edge-path between these faces.
#! 
#! The NC-Version does **not** check whether the given faces lie in the polygonal complex, and if the given distance <A>distance</A> is a positive integer. If one these conditions does not hold for a call to <K>RestrictionToNeighbourhoodOfFaces</K>, an error will be raised.
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

#! We can see that **restrSurf** is a cube, where one face (face 6) is missing.

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
#! @Arguments polygonalComplex, distance, listOfFaces
#! @Returns a polygonal complex
DeclareOperation( "RestrictionToNeighbourhoodOfFaces", [ IsPolygonalComplex, IsPosInt, IsList ] );
#! @Arguments polygonalComplex, distance, listOfFaces
#! @Returns a polygonal complex
DeclareOperation( "RestrictionToNeighbourhoodOfFacesNC", [ IsPolygonalComplex, IsPosInt, IsList ] );

#! @EndGroup



#! The following method restricts a triangular complex to a sub-complex.
#! 
#! @BeginGroup RestrictionToNeighbourhoodOfVertices

#! @Description

#! This method restricts a polygonal complex, whose faces are all of triangular type (i.e. a triangular complex), to a sub-complex. This sub-complex contains of:
#! * all vertices, that have distance of at most given <A>distance</A> to one of the given vertices (the of two vertices is measured by the length of a minimal vertex-edge-path between these vertices),
#! * all edges, that connect two included vertices, and
#! * all faces, for which holds, that all incident edges and vertices are part of the sub-complex.
#! 
#! The NC-Version does **not** check whether the given vertices lie in the triangular complex, and if the given <A>distance</A> is a positive integer. If one of these conditions does not hold for a call to <K>RestrictionToNeighbourhoodOfVertices</K>, an error will be raised.

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

#! @Arguments triangularComplex, distance, listOfVertices
#! @Returns a triangular complex
DeclareOperation( "RestrictionToNeighbourhoodOfVertices", [ IsTriangularComplex, IsPosInt, IsList ] );
#! @Arguments triangularComplex, distance, listOfVertices
#! @Returns a triangular complex
DeclareOperation( "RestrictionToNeighbourhoodOfVerticesNC", [ IsTriangularComplex, IsPosInt, IsList ] );

#! @EndGroup

#!
#!
#! The method <K>RestrictionToNeighbourhoodOfVertices</K> is only defined for triangular complexes. We see the reason easily when looking at a small example: Consider a square.

#! @ExampleSession
#! gap> MySquare := PolygonalSurfaceByDownwardIncidence([[1,2],
#! > [2,3],[3,4],[4,1]],[[1,2,3,4]]);;
#! @EndExampleSession

#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{Square_picture.pdf}
#! \end{center}
#! </Alt>

#! When we want to restrict the square to a neighbourhood of the vertex 1 with maximal distance 1, the vertices 2 and 4 need to lie in the polygonal complex. Unfortunately, vertex 3 does not lie in the restriction, so face 1 can not be part of the restriction and so the vertices 2 and 4 are not incident to any face in the restricted polygonal complex, which is not possible.

#! @Section Application of distance-calculations


#! In this section we will have a look at some application for the method <K>DistanceOfVertices</K> on polygonal complexes. Therefore we can see polygonal complexes as graphs where the vertices are the nodes and the edges are the edges of the graph. We put our attention on the eccentricity of a vertex, the diameter, the radius and the center of a polygonal complex. For our examples we will look at the following polygonal complexes:

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
#! The method computes the **eccentricity** of a vertex in a polygonal complex. The eccentricity of a vertex is defined by the maximal distance the vertex <A>vertex</A> has to any other vertex in the polygonal complex. If some vertices have infinite distance to each other, then the eccentricity is definded as -1.
#!
#!The NC-Version does not check, whether the given vertex lies in the polygonal complex.
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
#! @Arguments  polygonalComplex,vertex
#! @Returns a non negative integer or -1
DeclareOperation( "EccentricityOfVertex", [ IsPolygonalComplex, IsPosInt ] );
#! @Arguments  polygonalComplex,vertex
#! @Returns a non negative integer or -1
DeclareOperation( "EccentricityOfVertexNC", [ IsPolygonalComplex, IsPosInt ] );

#! @EndGroup

#! @Description
#! The method computes the **diameter** of a polygonal complex. The diameter of a polygonal complex is defined as the maximal distance of any two vertices in the polygonal complex.
#! If some vertices have infinite distance to each other (that is when the eccentricity of one vertex(and such all vertices) is -1, then the diameter is definded as -1, too.
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
#! @Arguments  polygonalComplex
#! @Returns a non negative integer or -1
DeclareOperation( "DiameterOfPolygonalComplex", [ IsPolygonalComplex ] );

#! @Description
#! The method computes the **radius** of a polygonal complex. The radius is defined by the minimal eccentricity of all vertices in the polygonal complex.
#! If some vertices have infinite distance to each other (that is when the eccentricity of one vertex(and such all vertices) is -1, then the radius is definded as -1, too.
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
#! @Arguments  polygonalComplex
#! @Returns a non negative integer or -1
DeclareOperation( "RadiusOfPolygonalComplex", [ 
IsPolygonalComplex ] );

#! @Description
#! The method computes the **center** of a polygonal complex. The center of a polygonal complex is definded by the set of all vertices of <A>polygonalComplex</A>, whose eccentricity is equal to the radius of <A>polygonalComplex</A>.
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
#! @Arguments  polygonalComplex
#! @Returns a set of positive integers or the empty set
DeclareOperation( "CenterOfPolygonalComplex", [
IsPolygonalComplex ] );




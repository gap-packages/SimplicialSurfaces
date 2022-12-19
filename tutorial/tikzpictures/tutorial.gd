####################################################################
##
##  SimplicialSurface Package
##
##  Copyright 2012-2018
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen Univertiy
##
## Licensed under the GPL 3 or later.
##
#####################################################################

#! @Chapter Tutorial
#! This chapter deals with the targeted use of the <K>SimplicialSurfaces</K> 
#! package to solve certain problems of interest. The aim of this tutorial is to 
#! demonstrate the power of the package by combining several functions provided in
#! the package. It should enable users to find routines for their tasks quickly 
#! without prior knowledge of the functions' names and also help users to
#! familiarise themselves with the package without having to read the entire
#! reference manual.
#!
#! @Section Parallelelepiped
#! @SectionLabel Parallelelepiped
#!
#! <M>Problems:</M>
#!  Construction of the simplicial parallelepiped
#! <Enum>
#!  <Item> from a cube </Item>
#!  <Item> from an octahedron and two tetrahedra via vertices in faces</Item>
#!  <Item> from an octahedron and two tetrahedra via surface constructions </Item>
#!  <Item> from a double-6-gon using edge-turns </Item>
#!  <Item> from a barycentric subdivision using edge-turns</Item>
#!  <Item> using the powerset of [1,2,3] as vertices</Item>
#! </Enum>
#! <M>Theoretical</M> <M>background</M>
#! - Vertex-faithful surfaces and boolean operations
#!
#! <M>Frequently</M> <M>used</M> <M>commands</M>  
#! - ConnectedFaceSum() (<Ref Subsect="ConnectedFaceSum"/>)
#! - EdgesOfFaces() (local version: EdgesOfFace()) (<Ref Subsect="EdgesOfFaces"/>)
#! - EdgesOfVertices() (local version: Edges) (<Ref Subsect="EdgesOfVertices"/>)
#! - EulerCharacteristic() (<Ref Subsect="EulerCharacteristic"/>)
#! - FaceDegreesOfVertices() (local version: FaceDegreeOfVertex)(<Ref Subsect="FaceDegreesOfVertices"/>)
#! - FacesOfVertices() (local version: FacesOfVertex()) (<Ref Subsect="FacesOfVertices"/>)
#! - Flags() (<Ref Subsect="Flags"/>)
#! - IsIsomorphic() (<Ref Subsect="IsIsomorphic"/>)
#! - JoinBoundaries() (<Ref Subsect="JoinBoundaries"/>)
#! - NeighbourVerticesOfVertex() (<Ref Subsect="NeighbourVerticesOfVertex"/>),
#! - SimplicialSurfaceByVerticesInFaces() (works for vertex-faithful surfaces only) (<Ref Subsect="PolygonalStructures_surface"/>)
#! - SubcomplexByFaces() (<Ref Subsect="SubcomplexByFaces"/>)
#! - VertexCounter() (local version: DegreeOfVertex()) (<Ref Subsect="VertexCounter"/>)
#! - VerticesOfEdges() (local Version: VerticesOfEdge()) (<Ref Subsect="VerticesOfEdges"/>)
#! - VerticesOfFaces() (local Version: VerticesOfFace()) (<Ref Subsect="VerticesOfFaces"/>)
#! - UmbrellaPathsOfVertices() (local version: UmbrellaPathOfVertex()) (<Ref Subsect="UmbrellaPathsOfVertices"/>)
## ! - FlagSurface() (<Ref Subsect="BarycentricSubdivision"/>)
#! <M>Less</M> <M>frequently</M> <M>used</M> <M>commands</M>
#! - Cube() (<Ref Subsect="Cube"/>)
#! - JanusHead() (<Ref Subsect="JanusHead"/>)
#!
#! <M> Mathematical</M> <M>details:</M>
#!
#! A parallelepiped is a three dimensional convex body.
## ! In this exercise we shall differentiate between the combinatorial  
## ! and the simplicial parallelepiped. The combinatorial parallelepiped 
## ! is a polyhedron with 6 faces, where each face is a parallelogram.
#! In this exercise we shall deal with its surface which we shall refer to as 
#! the ordinary
#! parallelepiped, and with a triangulation of it, which we shall call the
#! simplicial parallelepiped. Both are treated from a combinatorial point of
#! view.

#! <Alt Only="TikZ">
#!     \input{Image_Parallelepiped.tex}
#! </Alt>

#! We use a tetrahedron to triangulate the surface of a ordinary parallelepiped.
#! In this way each face is subdivided into 2 triangles and thus a  simplicial
#! parallelepiped with 12 faces is constructed. So after triangulating,
#! the simplicial parallelepiped has more embeddings into three dimensional
#! space, since the original faces might be bent along the new edges.
 
#! <Alt Only="TikZ">
#!     \input{Image_ParallelepipedTriangulated.tex}
#! </Alt>

#! Given a set of three linearly independent vectors in real 3-space, we can see that 
#! they define a parallelepiped as well as a tetrahedron.
#!
#! Note: Since we are only interested
#! in surfaces, we shall refer to terms like tetrahedron, parallelepiped, 
#! octahedron etc. as the boundary surfaces of these three dimensional bodies, or rather to 
#! the combinatorial devices describing their combinatorial structure.
#! So instead of working with an embedding of those structures, we see them as abstract surfaces
#!  represented by their incidence geometry.    
 
#! <Alt Only="TikZ">
#!     \input{Image_CubeP.tex}
#! </Alt>

#! Note:  The <K>SimplicialSurfaces</K> package also contains functionalities to deal with 
#! polygonal complexes like the cube and the ordinary parallelepiped. 
#! But since their combinatorial structures do not differ, the simplicial 
#! parallelepiped is of greater interest to us.
#!
#! @BeginExampleSession
#! gap> PE:=PolygonalComplexByVerticesInFaces([[1,2,3,4],[5,6,7,8],[1,2,5,6],
#! [2,3,6,7],[3,4,7,8],[1,4,5,8]]);
#! polygonal surface (8 vertices, 12 edges, and 6 faces)  
#! gap> IsIsomorphic(PE,Cube());
#! true
#! gap> VerticesOfFaces(Cube());
#! [ [ 1, 2, 3, 4 ], [ 1, 2, 5, 6 ], [ 2, 3, 6, 7 ], [ 1, 4, 5, 8 ], 
#!  [ 3, 4, 7, 8 ], [ 5, 6, 7, 8 ] ]
#! gap> VerticesOfFaces(PE);
#! [ [ 1, 2, 3, 4 ], [ 5, 6, 7, 8 ], [ 1, 2, 5, 6 ], [ 2, 3, 6, 7 ], 
#!  [ 3, 4, 7, 8 ], [ 1, 4, 5, 8 ] ]
#! @EndExampleSession
#!
#! @Subsection Construction from a cube
#!
#! <M>Idea</M> <M>behind</M> <M>the</M> <M>construcion</M>
#!
#! We construct a simplicial parallelepiped out of the combinatorial structure
#! of a  cube and two tetrahedra. Superimposing two disjoint tetrahedra onto
#! the cube results in dividing each cube face into two triangles. This gives
#! rise to new edges which were not edges of the cube beforehand. In that way
#! we obtain the simplicial parallelepiped as a subdivision of the cube. 

#! <Alt Only="TikZ">
#!     \input{Image_ConstructionParallelepiped.tex}
#! </Alt>

#! @BeginExampleSession
#! gap> PE:=Cube()
#! polygonal surface ( 8 vertices, 12 edges, 6 faces)
#! gap> VerticesOfFaces(PE);
#! [ [ 1, 2, 3, 4 ], [ 1, 2, 5, 6 ], [ 2, 3, 6, 7 ], [ 1, 4, 5, 8 ]
#! [ 3, 4, 7, 8 ], [ 5, 6, 7, 8 ] ]
#! @EndExampleSession
#!
#!
#! There are two disjoint tetrahedra contained in this cube with the following
#! property: Each tetrahedron's faces subdivide three faces of the cube and the
#! tetrahedron's vertices are also vertices of the cube.
#!
#! How can we find them? 
#! First we list each vertex together with  its neighbour vertices, so that
#! we can find a pair of disjoint sets among them:
#!
#! @BeginExampleSession
#! gap> List([1..8], i-> NeighbourVerticesOfVertex(PE,i));
#! [ [ 2, 4, 5 ], [ 1, 3, 6 ], [ 2, 4, 7 ], [ 3, 1, 8 ], [ 1, 8, 6 ], 
#!  [ 2, 7, 5 ], [ 3, 6, 8 ], [ 4, 7, 5 ] ]
#! gap> SS:=List([1..8], i->Union([i],last[i]));
#! [ [ 1, 2, 4, 5 ], [ 1, 2, 3, 6 ], [ 2, 3, 4, 7 ], [ 1, 3, 4, 8 ], 
#!  [ 1, 5, 6, 8 ], [ 2, 5, 6, 7 ], [ 3, 6, 7, 8 ], [ 4, 5, 7, 8 ] ]                                                ^
#! gap> Filtered([1..8],i->Intersection(SS[1],SS[i])=[]);
#! [ 7 ]
#! gap> T1:=SS[1]; T2:=SS[7];
#! [ 1, 2, 4, 5 ]
#! [ 3, 6, 7, 8 ]
#! @EndExampleSession
#!
#! Construct the corresponding tetrahedra:
#!
#! @BeginExampleSession
#! gap> Combinations(T1,3);
#! [ [ 1, 2, 4 ], [ 1, 2, 5 ], [ 1, 4, 5 ],[ 2, 4, 5]];
#! gap> T1:=SimplicialSurfaceByVerticesInFaces(last);
#! simplicial surface (4 vertices, 6 edges, 4  faces)                
#!
#! gap> Combinations(T2,3);
#! [ [ 3, 6, 7 ], [ 3, 6, 8 ], [ 3, 6, 8 ], [ 6, 7, 8 ] ]
#! gap> T1:=SimplicialSurfaceByVerticesInFaces(last);
#! simplicial surface (4 vertices, 6 edges, 4  faces) 
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_TetraederEmb.tex}
#! </Alt>
#!
#! Before proceeding with further computations, verify that the two simplcial
#! surfaces constructed are indeed isomorphic to the tetrahedron.
#!
#! @BeginExampleSession
#! gap> IsIsomorphic(T1,Tetrahedron());
#! true
#! gap> IsIsomorphic(T2,Tetrahedron());
#! true
#! @EndExampleSession
#!
#! Now use the edges of the tetrahedra T1 and T2 to subdivide the cube's faces. 
#! More precisely  take the edges of T1 and T2 not containing vertex 1 resp. 7
#! as diagonals of the faces of PE in which they lie to subdivide each of these
#! faces into two triangular faces:
#!
#! @BeginExampleSession
#! gap>  VerticesOfFaces(PE);
#! [ [ 1, 2, 3, 4 ], [ 1, 2, 5, 6 ], [ 2, 3, 6, 7 ], [ 1, 4, 5, 8 ], 
#!   [ 3, 4, 7, 8 ], [ 5, 6, 7, 8 ] ]
#! gap> VerticesOfEdges(T1);
#! [ [ 1, 2 ], [ 1, 4 ], [ 1, 5 ], [ 2, 4 ], [ 2, 5 ], [ 4, 5 ] ]
#! gap> VerticesOfEdges(T2);
#! [ [ 3, 6 ], [ 3, 7 ], [ 3, 8 ], [ 6, 7 ], [ 6, 8 ], [ 7, 8 ] ]
#! gap> neEd:= Union(Filtered(VerticesOfEdges(T1),r->not 1 in
#! > r),Filtered(VerticesOfEdges(T2),r->not 7 in r));
#! [ [ 2, 4 ], [ 2, 5 ], [ 3, 6 ], [ 3, 8 ], [ 4, 5 ], [ 6, 8 ] ]
#!
#! gap> neEd:=List(VerticesOfFaces(PE), r->Filtered(neEd,s->IsSubset(r,s))[1]);
#! [ [ 2, 4 ], [ 2, 5 ], [ 3, 6 ], [ 4, 5 ], [ 3, 8 ], [ 6, 8 ] ]
#! gap> List([1..6], i->IsSubset(VerticesOfFaces(PE)[i],neEd[i]));
#! [ true, true, true, true, true, true ]
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_CubeSubdivision.tex}
#! </Alt>
#! Now use the set <K>neEd</K> defined above to subdivide the cube's faces
#! with the following function:
#!
#! @BeginExampleSession
#! gap> part:=function(Q,E)
#! # Q set of vertices of old faces 
#! # E diagonal Edges
#! > local ne;
#! > ne:=Difference(Q,E); 
#! > return [Union(E,[ne[1]]),Union(E,[ne[2]])];
#! > end;
#! function( Q, E ) ... end
#! @EndExampleSession
#!
#! Construct the simplicial parallelepiped by defining the faces represented
#! by their sets of vertices. Note, this works only because the parallelepiped is
#! vertex-faithful.
#!
#! @BeginExampleSession
#! gap> List([1..6],i->part(VerticesOfFaces(PE)[i],neEd[i]));
#! [ [ [ 1, 2, 4 ], [ 2 .. 4 ] ], [ [ 1, 2, 5 ], [ 2, 5, 6 ] ],
#!  [ [ 2, 3, 6 ], [ 3, 6, 7 ] ], [ [ 1, 4, 5 ], [ 4, 5, 8 ] ], 
#!  [ [ 3, 4, 8 ], [ 3, 7, 8 ] ], [ [ 5, 6, 8 ], [ 6 .. 8 ] ] ]
#!
#! gap> Union(last);
#! [ [ 1, 2, 4 ], [ 1, 2, 5 ], [ 1, 4, 5 ], [ 2 .. 4 ], [ 2, 3, 6 ],
#!  [ 2, 5, 6 ], [ 3, 4, 8 ], [ 3, 6, 7 ], [ 3, 7, 8 ], [ 4, 5, 8 ], 
#!  [ 5, 6, 8 ], [ 6 .. 8 ] ]
#!
#! gap> PE:=SimplicialSurfaceByVerticesInFaces(last);
#! simplicial surface ( 8 vertices, 18 edges, 12 faces )
#! @EndExampleSession
#!
#! We show that the surface has Euler characteristic 2 and 
#! vertex counter $v_3^2 v_5^6$.
#!
#! @BeginExampleSession
#! gap> EulerCharacteristic(PE);
#! 2
#! gap> FacesOfVertices(PE);
#! [ [ 1, 2, 3 ], [ 1, 2, 4, 5, 6 ], [ 4, 5, 7, 8, 9 ], [ 1, 3, 4, 7, 10 ],
#!   [ 2, 3, 6, 10, 11 ], [ 5, 6, 8, 11, 12 ], [ 8, 9, 12 ],
#!  [ 7, 9, 10, 11, 12 ] ];
#! gap> VertexCounter(PE);
#! [ [ 3, 2 ], [ 5, 6 ] ]
#! @EndExampleSession
#!
#! Computing the set of vertices connected to a given vertex via an edge with the
#! command <K>NeighbourVerticesOfVertex</K>
#!
#! @BeginExampleSession
#! gap> NeighbourVerticesOfVertex(PE,1);
#! [ 2, 4, 5 ]
#! gap> NeighbourVerticesOfVertex(PE,2);NeighbourVerticesOfVertex(PE,4);
#! [ 1, 3, 4, 5, 6 ]
#! [ 1, 2, 3, 5, 8 ]
#! gap> NeighbourVerticesOfVertex(PE,7);
#! [ 3, 6, 8 ]
#! @EndExampleSession
#!
## ! Computing the <K>UmbrellaDescriptorOfSurface</K>:
#! Therefore we see that the simplicial surface <K>PE</K> is a sphere with
#! the following umbrella descriptor.
#!
#! @BeginExampleSession
#! gap> List(UmbrellaPathsOfVertices(PE),r->FacesAsPerm(r));
#! [ (1,3,2), (1,4,5,6,2), (4,7,9,8,5), (1,4,7,10,3), (2,6,11,10,3),
#! (5,8,12,11,6), (8,12,9), (7,10,11,12,9) ]
#! @EndExampleSession
#!
## ! Therefore we see that the surface is a closed surface with Umbrella descriptor
## ! $\{ ((1,3,2)), ((1,4,5,6,2)), ((4,7,9,8,5)), ((1,4,7,10,3)), ((2,6,11,10,3)),
## ! ((5,8,12,11,6))$, $((8,12,9)), ((7,10,11,12,9))\}$


#! @Subsection Construction from an octahedron 
#!
#! <M>Idea</M> <M>behind</M> <M>the</M> <M>construcion</M>
#!
#! We want to construct the simplicial parallelepiped using tetrahedrial extensions. 
#! Starting from an octahedron we subdivide two disjoint faces into 3-gons,
#! whereby the faces of the surfaces are represented by their sets of vertices. 
#! Subdividing a face of a simplicial surface gives rise to a new 
#! surface which can be seen as subdivision of the given surface.
#!  

#! <Alt Only="TikZ">
#!     \input{Image_TetraExt.tex}
#! </Alt>

#! @BeginExampleSession
#! gap> O1:=Octahedron();
#! simplicial surface ( 6 vertices, 12 edges, 8 faces )
#!
#! gap> VO1:=VerticesOfFaces(O1);
#! [ [ 1, 2, 3 ], [ 2, 5, 6 ], [ 1, 2, 5 ], [ 2, 3, 6 ], [ 1, 4, 5 ],
#!  [ 3, 4, 6 ], [ 1, 3, 4 ], [ 4, 5, 6 ] ]
#! @EndExampleSession
#!
#! 
## ! <Alt Only="TikZ">
## !     \input{Image_OctahedronEmbOrg.tex}
## ! </Alt>
#!
#! Determine the faces which will be replaced by attaching the tetrahedra. 
#! Therefore search for two faces that share no common vertex.
#!
#! @BeginExampleSession
#! gap> Filtered(VO1,r->Intersection(VO1[1],r)=[]);
#! [ [ 4, 5, 6 ] ]
#! @EndExampleSession
#!  
#! <Alt Only="TikZ">
#!     \input{Image_OctahedronEmb.tex}
#! </Alt>
#!
#! Compute the tetrahedra's vertices of faces so that the octahedron and each 
#! tetrahedron have exactly three vertices in common.
#!
#! @BeginExampleSession
#! gap> FT1:=Combinations([1,2,3,7],3);
#! [ [ 1, 2, 3 ], [ 1, 2, 7 ], [ 1, 3, 7 ], [ 2, 3, 7 ] ]
#! gap> FT2:=Combinations([4,5,6,8],3);
#! [ [ 4, 5, 6 ], [ 4, 5, 8 ], [ 4, 6, 8 ], [ 5, 6, 8 ] ]
#! @EndExampleSession
#!
#! Define the symmetric difference `sydif()` of sets A and B
#!
#! @BeginExampleSession
#! gap> symdif:=function(A,B)
#! > return Difference(Union(A,B),Intersection(A,B));
#! > end;
#! function( A, B ) ... end
#! @EndExampleSession
#!
#! Why is the symmetric difference helpful for the solution of this problem? 
#!
#! The symmetric difference of the set of faces of the octahedron and the set
#! of faces of one of the above tetrahedra removes
#! the face <K>[1,2,3]</K> resp. <K>[4,5,6]</K> which the octahedron and the
#! tetrahedron have in common and replaces it
#! with the three remaining faces of the tetrahedron.
#! So by using the symmetric difference we obtain the vertices of faces
#! of the desired simplicial parallelepiped.
#!
#! @BeginExampleSession
#! gap> symdif(VO1,FT1);
#! [ [ 1, 2, 5 ], [ 1, 2, 7 ], [ 1, 3, 4 ], [ 1, 3, 7 ], [ 1, 4, 5 ],
#! [ 2, 3, 6 ], [ 2, 3, 7 ], [ 2, 5, 6 ], [ 3, 4, 6 ], [ 4, 5, 6 ] ]
#! gap> symdif(last,FT2);
#! [ [ 1, 2, 5 ], [ 1, 2, 7 ], [ 1, 3, 4 ], [ 1, 3, 7 ], [ 1, 4, 5 ],
#!  [ 2, 3, 6 ], [ 2, 3, 7 ], [ 2, 5, 6 ], [ 3, 4, 6 ], [ 4, 5, 8 ],
#!  [ 4, 6, 8 ], [ 5, 6, 8 ] ]
#! @EndExampleSession
#!
#! Finally construct the simplicial parallelepiped
#! 
#! @BeginExampleSession
#! gap> PEn:=SimplicialSurfaceByVerticesInFaces(last);
#! simplicial surface ( vertices, 18 edges, 12 faces )
#! @EndExampleSession
#! <Alt Only="TikZ">
#!     \input{Image_ParallelepipedTriangulated.tex}
#! </Alt>
#!
#! If the first and second construction were carried out correctly, the constructed 
#! simplicial surfaces must be isomorphic.
#!
#! @BeginExampleSession
#! gap> IsIsomorphic(PE,PEn);
#! true
#! @EndExampleSession




#! @Subsection Construction from an octahedron (2)
#!
#! <M>Idea</M> <M>behind</M> <M>the</M> <M>construcion</M>
#!
#! As seen in the previous construction two tetrahedra can be attached 
#! to an octahedron to construct the simplical parallelepiped.
#! In this subsection we present an alternative construction.
#! The required simplicial surfaces are computed directly instead of
#! manipulating their vertices in faces to create the simplicial
#! parallelepiped. This is achieved by using flags. A flag is a 
#! triple [ V, E, F ] satisfying the following conditions:
#! - the vertex V is incident to the edge E
#! - the edge E is incident to the face F
#! - the vertex V is incident to the face F.
#!
#! We can compute flags by calling 
#! @BeginExampleSession
#! gap> Flags(Tetrahedron());
#! [ [ 1, 1, 1 ], [ 1, 1, 2 ], [ 1, 2, 1 ], [ 1, 2, 4 ], [ 1, 3, 2 ], 
#!  [ 1, 3, 4 ], [ 2, 1, 1 ], [ 2, 1, 2 ], [ 2, 4, 1 ], [ 2, 4, 3 ], 
#!  [ 2, 5, 2 ], [ 2, 5, 3 ], [ 3, 2, 1 ], [ 3, 2, 4 ], [ 3, 4, 1 ], 
#!  [ 3, 4, 3 ], [ 3, 6, 3 ], [ 3, 6, 4 ], [ 4, 3, 2 ], [ 4, 3, 4 ], 
#!  [ 4, 5, 2 ], [ 4, 5, 3 ], [ 4, 6, 3 ], [ 4, 6, 4 ] ]
#! @EndExampleSession
#! 
#! Use these flags to attach the tetrahedron to the octahedron with
#! the function <K>ConnectedFaceSum()</K>
#! 
#! @BeginExampleSession
#! gap> PE3:=ConnectedFaceSum(Tetrahedron(),[1,1,1],Octahedron(),[1,1,1]);
#! [simplicial surface (7 vertices, 15 edges, 10 faces)]
#! @EndExampleSession
#!
#!
#! <Alt Only="TikZ">
#!     \input{Image_Octahedron_TetraExtension.tex}
#! </Alt>
#!
#! We have to find the face which has to be replaced by the second tetrahedron.
#! How do we find it?
#! The vertices of this face are not incident to the already attached
#! tetrahedron, thus their face degree must be 4.
#!
#! @BeginExampleSession
#! gap> FaceDegreesOfVertices(PE3);
#! [ ,,, 3,,,,,, 4, 4, 4, 5, 5, 5 ]
#! gap> Vertices(PE3);
#! [ 4, 10, 11, 12, 13, 14, 15 ]
#! gap> Intersection(List([10,11,12],i->FacesOfVertex(PE3,i)));
#! [ 14 ]
#! @EndExampleSession
#!
#! Find the edge E of the corresponding flag <K>[10, E, 14]</K> to compute the 
#! simplicial parallelepiped
#!
#! @BeginExample
#! gap> Intersection(EdgesOfFace(PE3,14),EdgesOfVertex(PE3,10));
#! [ 16, 17 ]
#! gap> PE3:=ConnectedFaceSum(Tetrahedron(),[1,1,1],PE3,[10,16,14]);
#! simplicial surface (8 vertices, 18 edges, 12 faces)
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_ParallelepipedTriangulated.tex}
#! </Alt>
#!
#! The vertex counter verifies that the constructed 
#! surface is indeed the simplicial parallelepiped 
#!
#! @BeginExampleSession
#! gap> VertexCounter(PE3);
#! [ [ 3, 2 ], [ 5, 6 ] ]
#! @EndExampleSession
#!
#! The numbering of the vertices etc. can and should be improved in the sense
#! that
#! - the vertices of the surface are given by the set [1..8] 
#! - the edges of the surface are given by the set [1..18]
#! - the faces of the surface are given by the set [1..12]
#! This can be achieved by mapping each vertex to their position in <K>Vertices(PE3)</K>
#! @BeginExampleSession
#! gap> VV:=Vertices(PE3);
#! [ 4, 10, 19, 20, 21, 22, 23, 24 ]
#! gap> LL:=VerticesOfFaces(PE3);
#! [ , [ 4, 22, 23 ], [ 4, 23, 24 ], [ 4, 22, 24 ],,,, [ 10, 19, 20 ], 
#!  [ 10, 20, 21 ], [ 10, 19, 21 ],,,, [ 20, 23, 24 ], [ 19, 20, 23 ], 
#!  [ 20, 21, 24 ], [ 19, 22, 23 ], [ 21, 22, 24 ], [ 19, 21, 22 ] ]
#! gap> LL:=Set(LL);
#! [ [ 4, 22, 23 ], [ 4, 22, 24 ], [ 4, 23, 24 ], [ 10, 19, 20 ], 
#!  [ 10, 19, 21 ], [ 10, 20, 21 ], [ 19, 20, 23 ], [ 19, 21, 22 ], 
#!  [ 19, 22, 23 ], [ 20, 21, 24 ], [ 20, 23, 24 ], [ 21, 22, 24 ] ]
#! gap> LL:=List(LL,r->List(r,i->Position(VV,i)));
#! [ [ 1, 6, 7 ], [ 1, 6, 8 ], [ 1, 7, 8 ], [ 2, 3, 4 ], [ 2, 3, 5 ], 
#!  [ 2, 4, 5 ], [ 3, 4, 7 ], [ 3, 5, 6 ], [ 3, 6, 7 ], [ 4, 5, 8 ], 
#!  [ 4, 7, 8 ], [ 5, 6, 8 ] ]
#! gap> PE3:=SimplicialSurfaceByVerticesInFaces(LL);
#! simplicial surface ( 8 vertices, 18 edges, 12 faces)
#! gap> Vertices(PE3);
#! [ 1, 2, 3, 4, 5, 6, 7, 8 ]
#! @EndExampleSession
#! 
#! Verify that the resulting sphere is still isomorphic to the parallelepiped
#!
#! @BeginExampleSession
#! gap> FaceDegreesOfVertices(PE3);
#! [ 3, 3, 5, 5, 5, 5, 5, 5 ]
#! gap> IsIsomorphic(PE3, PEn);
#! true
#! @EndExampleSession
#!
#! @Subsection Construction from double-6-gon via butterfly turning (1) 
#! <M>idea</M> <M>behind</M> <M>the</M> <K>construction</K>
#!
#! This construction uses the concept of edge-turns. If an inner edge e gives
#! rise to a butterfly (e.g. if the surface is vertex faithful), a new surface
#! can be created by turning the inner edge e. This amounts to replacing e by
#! a new edge e' connecting the other two vertices of the butterfly.
#! So it has the same number of faces, edges and vertices, but the vertex
#! degrees in four positions will change by +-1 i.e. the vertex degrees of the
#! vertices incidient to e decrease and the degrees of the vertices incident to
#! e' increase by 1. We shall refer to the edge e' as the orthogonal edge.
#! In this construction we perform edge-turns on the double-6-gon to obtain
#! the simplicial parallelepiped.

#! <Alt Only="TikZ">
#!     \input{Image_Edgeturn.tex}
#! </Alt>

#! Construct the double-6-gon by specifying its faces via its incident vertices
#!
#! @BeginExampleSession
#! gap> VertInFacDouble6gon:= [ [ 1, 2, 7 ], [ 2, 7, 8 ], [ 1, 2, 3 ], [ 2, 3, 8 ],
#! > [ 1, 3, 4 ], [ 3, 4, 8 ], [ 1, 4, 5 ], [ 4, 5, 8 ], [ 1, 5, 6 ], [ 5, 6, 8 ],
#! > [ 1, 6, 7 ], [ 6, 7, 8 ] ];;
#! gap> PE:=SimplicialSurfaceByVerticesInFaces(last);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! @EndExampleSession
#! 
#! <Alt Only="TikZ">
#!     \input{Image_Double6gon.tex}
#! </Alt>
#!
#! Construction of a butterfly
#!
#! @BeginExampleSession
#! gap> bufl:=function()
#! > return SimplicialSurfaceByVerticesInFaces([[1,2,3],[2,3,4]]);
#! > end;
#! function(  ) ... end
#! gap> bufl();
#! simplicial surface ( 4 vertices, 5 edges, 2 faces)
#! @EndExampleSession
#! 
#!
#! <Alt Only="TikZ">
#!     \input{Image_Butterfly.tex}
#! </Alt>
##  ! Usually an inner edge of a surface gives rise to a butterfly.
#! Define the function `checkbufl()` which checks whether a given edge
#! is an inner edge giving rise to a butterfly in the surface.
#!
#! @BeginExampleSession
#! gap> checkbufl:=function(S,e)
#! > local sS;
#! > if not (e in InnerEdges(S)) then Error("not inner");fi;
#! > sS:=FacesOfEdge(S,e);
#! > sS:=SubcomplexByFaces(S,sS);
#! > return IsIsomorphic(bufl(),sS);
#! > end;
#! function( S, e ) ... end
#! 
#! gap> checkbufl(PE,2);
#! true
#! @EndExampleSession
#!
#! If the function returns true, the butterfly of the edge e can be turned.
## ! In this way a new surface is created through turning the edge e.
## ! It has the same number of faces, edges and vertices, but the vertex degrees
## ! in four positions will change by +-1.
#! Here the program to perform an edgeturn is introduced:
#! @BeginExampleSession
#! gap> turnedge:=function(S,e)
#! > local sS,sB,v,ee;
#! > sB:=SubcomplexByFaces(S,FacesOfEdge(S,e));
#! > ee:=Difference(Edges(sB),[e]);
#! > v:=Intersection(VerticesOfEdge(sB,ee[1]),VerticesOfEdge(S,e))[1];
#! > sS:=Difference(Faces(S),FacesOfEdge(S,e));
#! > sS:=SubcomplexByFaces(S,sS);
#! > return JoinBoundaries(sS,[v,ee[1]],sB,
#! > [Difference(VerticesOfEdge(sB,ee[1]),[v])[1],ee[1]]);
#! > end;
#! function( S, e ) ... end
#! @EndExampleSession
#! 
#!
#############################################################
############################################################

##  @BeginExampleSession
##  gap> turnedge(PE,1);
##  [ simplicial surface (8 vertices, 18 edges, 12 faces)
##     , [0m( v24, E25, v25, E26, v26, E27, v27, E28, v24 ), 18 ]
##  
##  gap> nnn:=turnedge(PE,1);
##  [ simplicial surface ( 8 vertices, 18 edges, 12 faces)
##     , ( v24, E25, v25, E26, v26, E27, v27, E28, v24 )
##     , 18 ]
##  gap> FacesOfVertices(nnn[1]);
##  [ ,, [ 4, 5, 7, 8, 9 ],,, [ 5, 6, 8, 11, 12 ], [ 8, 9, 12 ], 
##   [ 7, 9, 10, 11, 12 ],,,,,,,,,,,,,,,, [ 3, 19 ], [ 3, 4, 7, 10, 19, 20 ], 
##   [ 4, 5, 6, 20 ], [ 3, 6, 10, 11, 19, 20 ] ]
##  @EndExampleSession 
########################################
##########################################
#! The vertex-counter of the simplicial parallelepiped is [[3,2],[5,6]]. So turn an edge 
#! incident to vertex 1 to create a vertex of degree 3 and vertices of degree 5.
#! @BeginExampleSession
#! gap> VerticesOfEdges(PE);
#! [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 1, 6 ], [ 1, 7 ], [ 2, 3 ], [ 2, 7 ], 
#!  [ 2, 8 ], [ 3, 4 ], [ 3, 8 ], [ 4, 5 ], [ 4, 8 ], [ 5, 6 ], [ 5, 8 ], [ 6, 7 ], 
#!  [ 6, 8 ], [ 7, 8 ] ]
#! gap> turnedge(PE,1);
#! [ simplicial surface (8 vertices, 18 edges, and 12 faces)
#!    , ( v26, E27, v27, E28, v28, E29, v29, E30, v26 )
#!    , 18 ]
#! gap> PE1:=last[1];
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! @EndExampleSession
#!
## ! <Alt Only="TikZ">
## !     \input{Image_ParallelepipedTriangulated.tex}
## ! </Alt>
#! 
#!
#! Compute the face degrees of the vertices  
#! @BeginExampleSession
#! gap> FaceDegreesOfVertices(PE1);
#! [ ,,, 4, 4, 4,, 6,,,,,,,,,,,,,,,,,, 5, 5, 3, 5 ]
#! @EndExampleSession
#! 
#! Since the face degrees of the vertices 4,5,6 and 8 is neither 3 or 5,
#! we need to find an inner edge so that the resulting butterfly contains the
#! vertices [4,5,6,8].
#!
#! @BeginExampleSession
#! gap> Filtered(Faces(PE1),f->IsSubset([4,5,6,8],VerticesOfFace(PE1,f)));
#! [ 8, 10 ]
#! gap> Intersection(EdgesOfFace(PE1,8),EdgesOfFace(PE1,10));
#! [ 15 ]
#! @EndExampleSession
#!
#! From this information we can compute the simplicial parallelepiped by turning edge 15
#!
#! @BeginExampleSession
#! gap> turnedge(PE1,15);
#! [ simplicial surface (8 vertices, 18 edges, and 12 faces)
#!    , ( v39, E48, v40, E49, v41, E50, v42, E51, v39 )
#!    , 30 ]
#! gap> PE3:=last[1];
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! @EndExampleSession
#!
#! By calling the vertex counter we see that the sphere is indeed isomorphic to the 
#! simplicial parallelepiped.
#!
#! @BeginExampleSession
#! gap> VertexCounter(PE3);
#! [ [ 3, 2 ], [ 5, 6 ] ]
#! @EndExampleSession




#! @Subsection Construction using the barycentric subdivision and edge-turns
#! 
#! <M>Idea</M> <M>behind</M> <M>the</M> <M>construcion</M>
#!
#! The Janus Head is a closed simplicial surface with 2 faces whose barycentric
#! subdivision is a sphere with 12 faces. From this information we can deduce
#! that performing edgeturns on the resulting surface gives rise to
#! a simplicial parallelepiped.
#!
#! <Alt Only="TikZ">
#!     \input{Image_JanusHead.tex}
#! </Alt>
#!
#! Compute the Janus Head 
#!
#! @BeginExampleSession
#! gap> J:=JanusHead();
#! simplicial surface ( 3 vertices, 3 edges, 2 faces)
#! gap> Checkbufl(J,1);
#! false
#! @EndExampleSession
#!
#! Constructing the Janus-Head's barycentric subdivision
#!
#! @BeginExampleSession
#! gap> BJ:=FlagSurface(J);
#! coloured surface (MMM with 8 vertices, 18 edges and 12 faces)
#! gap> FaceDegreesOfVertices(BJ);
#! [ 4, 4, 4, 4, 4, 4, 6, 6 ]
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_FlagsurfaceJanusHead.tex}
#! </Alt>
#!
#! Which edges have to be turned to obtain the parallelepiped?
#! The vertex counter of the surface <K>BJ</K> is <K>[[4,6],[6,4]]</K>. To create a
#! sphere with the vertex counter <K>[[3,2],[5,6]]</K>, we first have to find an edge
#! incident to vertices with degree 6 and 4. Their degree will decrease by 1 and the vertex degrees 
#! of the vertices incident to the orthogonal edge will increase by 1.
#!
#! @BeginExampleSession
#! VerticesOfEdges(BJ);
#! [ [ 1, 4 ], [ 1, 5 ], [ 2, 4 ], [ 2, 6 ], [ 3, 5 ], [ 3, 6 ], [ 1, 7 ], 
#!  [ 1, 8 ], [ 2, 7 ], [ 2, 8 ], [ 3, 7 ], [ 3, 8 ], [ 4, 7 ], [ 4, 8 ], 
#!  [ 5, 7 ], [ 5, 8 ], [ 6, 7 ], [ 6, 8 ] ]
#! gap> BJ1:=turnedge(BJ,18)[1];
#! simplicial surface (8 vertices, 18 edges, 12 faces)
#! @EndExampleSession
#!
#! Computing face degrees of the vertices 
#!
#! @BeginExampleSession
#! gap> FaceDegreesOfVertices(BJ1);
#! [ 4,,, 4, 4,, 6,,,,,,,,,,,,,,,,,,, 3, 5, 5, 5 ]
#! @EndExampleSession
#!
#! Find an edge incident to a vertex with face degree 4 and another 
#! vertex with degree 6. For that we may use
#!
#! @BeginExampleSession
#! gap> VerticesOfEdges(BJ1);
#! [ [ 1, 4 ], [ 1, 5 ], [ 4, 27 ],, [ 5, 29 ],, [ 1, 7 ], [ 1, 28 ], [ 7, 27 ],
#!  , [ 7, 29 ],, [ 4, 7 ], [ 4, 28 ], [ 5, 7 ], [ 5, 28 ], [ 7, 26 ],,,,,,,,,,
#!  ,,,,,,,, [ 27, 29 ], [ 26, 27 ], [ 27, 28 ], [ 28, 29 ], [ 26, 29 ] ]
#! gap> Position(last,[1,7]);
#! 7
#! gap> JB2:=turnedge(BJ1,7)[1];
#! simplicial surface (8 vertices, 18 edges, 12 faces)
#! gap> FaceDegreesOfVertices(JB2);
#! [ ,,,,,,,,,,,,,,,,,,,,,,,,, 3, 5, 5, 5,,,,,,,,,,,,,,,,,, 3, 5, 5, 5 ]
#! @EndExampleSession
#!
#! Check whether the constructed surface is isomorphic to the simplicial
#! parallelepiped
#!
#! @BeginExampleSession
#! gap> IsIsomorphic(JB2,PEs);
#! true
#! @EndExampleSession
#!
#! The surface is vertex-faithful. Hence we easily can clean up the sets of vertices, 
#! edges and faces 
#!
#! @BeginExampleSession
#! gap> V:=Vertices(JB2);
#! [ 26, 27, 28, 29, 47, 48, 49, 50 ]
#! gap> FF:=VerticesOfFaces(JB2);
#! [ , [ 28, 47, 48 ],, [ 28, 47, 50 ], [ 27, 48, 49 ], [ 27, 28, 48 ], 
#!  [ 26, 27, 49 ],, [ 29, 49, 50 ], [ 28, 29, 50 ], [ 26, 29, 49 ],,,,,,,,,,,,
#!  ,, [ 26, 27, 29 ],,,, [ 27, 28, 29 ],,,,,,,,,,, [ 47, 48, 50 ],, 
#!  [ 48, 49, 50 ] ]
#! gap> FF:=Set(FF);
#! [ [ 26, 27, 29 ], [ 26, 27, 49 ], [ 26, 29, 49 ], [ 27, 28, 29 ], 
#!  [ 27, 28, 48 ], [ 27, 48, 49 ], [ 28, 29, 50 ], [ 28, 47, 48 ], 
#!  [ 28, 47, 50 ], [ 29, 49, 50 ], [ 47, 48, 50 ], [ 48, 49, 50 ] ]
#! gap> FF:=List(FF,r->List(r,i->Position(V,i)));
#! [ [ 1, 2, 4 ], [ 1, 2, 7 ], [ 1, 4, 7 ], [ 2, 3, 4 ], [ 2, 3, 6 ], 
#!  [ 2, 6, 7 ], [ 3, 4, 8 ], [ 3, 5, 6 ], [ 3, 5, 8 ], [ 4, 7, 8 ], 
#!  [ 5, 6, 8 ], [ 6, 7, 8 ] ]
#! gap> PEt:=SimplicialSurfaceByVerticesInFaces(FF);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! gap> FaceDegreesOfVertices(PEt);
#! [ 3, 5, 5, 5, 3, 5, 5, 5 ]
#! gap> Vertices(PEt);
#! [ 1, 2, 3, 4, 5, 6, 7, 8 ]
#! @EndExampleSession
#!
#! We want to understand the barycentric subdivision of the Janus head better.
#! Indeed we shall see that it is isomorphic to the double 6-gon.
#!
#! Define a function that creates a n-gon
#!
#! @BeginExampleSession
#! gap> ngon:=function(n)
#! > local c,L;
#! > c:=CycleFromList([1..n]);
#! > L:=List([1..n],i->[i,i^c,n+1]);
#! > return SimplicialSurfaceByVerticesInFaces(L);
#! > end;
#! function( n ) ... end
#! @EndExampleSession
#!
#! Compute the 4-gon
#!
#! @BeginExampleSession
#! gap> ngon(4);
#! simplicial surface (5 vertices, 8 edges, and 4 faces)
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_4Gon.tex}
#! </Alt>
#!	
#! Define a function to create a double-n-gon
#!
#! @BeginExampleSession
#! gap> Doublengon:=function(n)
#! > local c,L1,L2;
#! > c:=CycleFromList([1..n]);
#! > L1:=List([1..n],i->[i,i^c,n+1]);
#! > L2:=List([1..n],i->[i,i^c,n+2]);
#! > L1:=Union(L1,L2);
#! > return SimplicialSurfaceByVerticesInFaces(L1);
#! > end;
#! function( n ) ... end
#! @EndExampleSession
#!
#! Verify that the barycentric subdivision of the Janus Head is isomorphic to the 
#! double-6-gon
#!
#! @BeginExampleSession
#! gap> Doublengon(4);
#! simplicial surface (6 vertices, 12 edges, and 8 faces)
#! gap> IsIsomorphic(Doublengon(4),Octahedron());
#! true
#! gap> IsIsomorphic(Doublengon(6),BJ);
#! true
#! gap> FaceDegreesOfVertices(Doublengon(7));
#! [ 4, 4, 4, 4, 4, 4, 4, 7, 7 ]
#! @EndExampleSession




#! @Subsection Construction using power sets
#!
#! <M>Idea</M> <M>behind</M> <M>the</M> <M>construcion</M>
#!
#! The construction of the simplicial parallelepiped can be achieved by using
#! the power set of <K>[1,2,3].</K>
#! The power set forms the set of vertices of the parallelepiped. So we refer to the 
#! different subsets of [1,2,3] as vertices.
#! Since the surface is vertex-faithful, we see that constructing the surface
#! can be achieved by determining the vertices of faces. 
#! The set of vertices of a face can be written as [V1,V2,V3] where the subsets V1
#! and V2 have the same cardinalty and V3 is either the intersection or the union of 
#! V1 and V2.
#!
#! <Alt Only="TikZ">
#!     \input{Image_ParallelepipedPowerset.tex}
#! </Alt>
#!
#! Compute the ordered power set such that we can easily access subsets of a
#! given size.
#! @BeginExampleSession
#! gap> powset:=List([0..3],i->Combinations([1,2,3],i));
#! [ [ [  ] ], [ [ 1 ], [ 2 ], [ 3 ] ], [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ] ], 
#!  [ [ 1, 2, 3 ] ] ]
#! @EndExampleSession 
#!
#! To compute the faces incident to exactly two vertices of cardinality 1, we have
#! to tell GAP to compute the union and intersection of those sets
#!
#! @BeginExampleSession
#! gap> t1:=List(Combinations(C[2],2),r->Union(r, [Intersection(r)]));
#! [ [ [  ], [ 1 ], [ 2 ] ], [ [  ], [ 1 ], [ 3 ] ], [ [  ], [ 2 ], [ 3 ] ] ]
#! gap> t2:=List(Combinations(C[2],2),r->Union(r, [Union(r)]));
#! [ [ [ 1 ], [ 1, 2 ], [ 2 ] ], [ [ 1 ], [ 1, 3 ], [ 3 ] ], 
#!  [ [ 2 ], [ 2, 3 ], [ 3 ] ] ]
#! @EndExampleSession
#!
#! Conpute the faces incident to exactly two vertices of cardinality 2
#! 
#! @BeginExampleSession
#! gap> t3:=List(Combinations(C[3],2),r->Union(r, [Intersection(r)]));
#! [ [ [ 1 ], [ 1, 2 ], [ 1, 3 ] ], [ [ 1, 2 ], [ 2 ], [ 2, 3 ] ], 
#!  [ [ 1, 3 ], [ 2, 3 ], [ 3 ] ] ]
#! gap> t4:=List(Combinations(C[3],2),r->Union(r, [Union(r)]));
#! [ [ [ 1, 2 ], [ 1 .. 3 ], [ 1, 3 ] ], [ [ 1, 2 ], [ 1 .. 3 ], [ 2, 3 ] ], 
#!  [ [ 1 .. 3 ], [ 1, 3 ], [ 2, 3 ] ] ]
#! @EndExampleSession
#!
#! Compute the set of faces represented by their set of vertices
#! 
#! @BeginExampleSession
#! gap> t:=Union([t1,t2,t3,t4]);
#! [ [ [  ], [ 1 ], [ 2 ] ], [ [  ], [ 1 ], [ 3 ] ], [ [  ], [ 2 ], [ 3 ] ], 
#!  [ [ 1 ], [ 1, 2 ], [ 1, 3 ] ], [ [ 1 ], [ 1, 2 ], [ 2 ] ], 
#!  [ [ 1 ], [ 1, 3 ], [ 3 ] ], [ [ 1, 2 ], [ 1 .. 3 ], [ 1, 3 ] ], 
#!  [ [ 1, 2 ], [ 1 .. 3 ], [ 2, 3 ] ], [ [ 1, 2 ], [ 2 ], [ 2, 3 ] ], 
#!  [ [ 1 .. 3 ], [ 1, 3 ], [ 2, 3 ] ], [ [ 1, 3 ], [ 2, 3 ], [ 3 ] ], 
#!  [ [ 2 ], [ 2, 3 ], [ 3 ] ] ]
#! @EndExampleSession
#!
#! From this information we can already reclaim the simplicial parallelepiped,
#! but we notice that the vertices' labelling can be improved by calling 
#!
#! @BeginExampleSession
#! gap> powset:=C[1];
#! [ [  ] ]
#! gap> Append(powset,C[2]);
#! gap> Append(powset,C[3]);
#! gap> Append(powset,C[4]);
#! gap> powset; #powset is the power set
#! [ [  ], [ 1 ], [ 2 ], [ 3 ], [ 1, 2 ], [ 1, 3 ], [ 2, 3 ], [ 1, 2, 3 ] ]
#! gap> verticesinfaces:=List(t,r->List(r,i->Position(powset,i)));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 5, 6 ], [ 2, 5, 3 ], 
#!  [ 2, 6, 4 ], [ 5, 8, 6 ], [ 5, 8, 7 ], [ 5, 3, 7 ], [ 8, 6, 7 ], 
#!  [ 6, 7, 4 ], [ 3, 7, 4 ] ]
#! @EndExampleSession
#!
#! Construct the simplicial parallelepiped
#!
#! @BeginExampleSession
#! gap> PEs:=SimplicialSurfaceByVerticesInFaces(verticesinfaces);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! gap> VertexCounter(PEs);
#! [ [ 3, 2 ], [ 5, 6 ] ]
#! @EndExampleSession
#!
#! Note, this construction can be generalised to other sets.
#! For the powerset of [1,2], the resulting surface is isomorphic to the butterfly.
#!

#######################################################################################
############################################################################


#! @Section Facegraph of simplicial surfaces
#!
#! @SectionLabel facegraph
#!
#! <M>Problems:</M>
#!  - Analyse the face graph of
#! <Enum>
#!  <Item> a tetrahedron </Item>
#!  <Item> an octahedron </Item>
#! </Enum>
#! <M>Theoretical</M> <M>background</M>
#! - Vertex-faithful surfaces and boolean operations


#! <M>Frequently</M> <M>used</M> <M>commands</M> 
#! - AutomorphismGroup() (<Ref Subsect="AutomorphismGroup"/>)
#! - AutomorphismGroupOnEdges() (<Ref Subsect="AutomorphismGroupOnEdges"/>)
#! - AutomorphismGroupOnFaces() (<Ref Subsect="AutomorphismGroupOnFaces"/>)
#! - EdgesOfFaces() (local version: EdgesOfFace()) (<Ref Subsect="EdgesOfFaces"/>)
#! - EdgesOfVertices() (local version: Edges) (<Ref Subsect="EdgesOfVertices"/>)
#! - EulerCharacteristic() (<Ref Subsect="EulerCharacteristic"/>)
#! - FacesOfEdges() (local version: FacesOfEdge()) (<Ref Subsect="FacesOfEdges"/>)
#! - ImageOfVertex() (<Ref Subsect="ImageOfVertex"/>)
#! - IsOrientable() (<Ref Subsect="IsOrientable"/>)
#! - PolygonalComplexByDownwardIncidence() (<Ref Subsect="PolygonalStructures_surface"/>)
#! - UmbrellaPathsOfVertices() (<Ref Subsect="UmbrellaPathsOfVertices"/>)
#! - VertexCounter() (local version: DegreeOfVertex()) (<Ref Subsect="VertexCounter"/>),
#! - VerticesOfEdges() (local Version: VerticesOfEdge()) (<Ref Subsect="VerticesOfEdges"/>)
#! - VerticesOfFaces() (local Version: VerticesOfFace()) (<Ref Subsect="VerticesOfFaces"/>)
#! <M>Less</M> <M>frequently</M> <M>used</M> <M>commands</M>
#! - Tetrahedron() (<Ref Subsect="Tetrahedron"/>)
#! - Octahedron() (<Ref Subsect="Octahedron"/>)
#!
#! <M> Mathematical</M> <M>details:</M>
#!
#! In this chapter we shall familiarize ourselves with the face graph of a simplicial
#! surface. The face graph has the set of faces of the simplicial surface as it's set
#! of vertices and the set of edges of the simplicial surface as it's edges. Two 
#! vertices F,F' of the face
#! graph are connected through an edge if and only if the corresponding faces 
#! form a set [F,F'] which is an element of the set containing the faces incident to an 
#! edge.
#!
#! <Alt Only="TikZ">
#!     \input{Image_ExampleFacegraph.tex}
#! </Alt>
#!
#! For example the face graph of the one-face is given by a graph with one vertex and 
#! three loops and the face graph of the Janus-Head is a graph with two vertices which 
#! are connected through three edges. 
#! Note, the map resulting through mapping a simplicial surface on it's face 
#! graph is not bijective, since non-isomorphic surfaces can have isomorphic face
#! graphs. But restricting the map to spheres only delivers a bijection.   
#! We shall refer to two faces of a simplicial surface as opposite if they share no 
#! common vertex.
#! By looking at the cube as an example, we see that the faces 1 and 6, 2 and 5, 3,4 
#! form pairs of opposite faces.
## ! gap> #We want to familiarize us with face graphs of surfaces
## ! gap> #We start with the very simple example of a tetrahedron.
#!
#! @Subsection Face graph of a tetrahedron
#!
#! For the purpose of handling face graphs of simplicial we start with the tetrahedron 
#! as an example. 
#!
#! <Alt Only="TikZ">
#!     \input{Image_TetraederEmb.tex}
#! </Alt>
#!
#! Compute a tetrahedron
#!
#! @BeginExampleSession
#! gap> T:=Tetrahedron();
#! simplicial surface (4 vertices, 6 edges, and 4 faces)
#! @EndExampleSession
#!
## ! gap> #The symbol of T can be obtained as follows:
#! Define a function to compute the ordinal symbol of a simplicial surface 
#!
#! @BeginExampleSession
#! gap> Symbol:=function(S)
#! > return [Size(Vertices(S)),Size(Edges(S)),Size(Faces(S))
#! ,VerticesOfEdges(S),EdgesOfFaces(S)];
#! > end;
#! function( S ) ... end
#! @EndExampleSession
#! 
#! Compute the symbol of the Tetrahedron
#!
#! @BeginExampleSession
#! gap> Symbol(T);
#! [ 4, 6, 4, [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 2, 4 ], [ 3, 4 ] ], 
#!  [ [ 1, 2, 4 ], [ 1, 3, 5 ], [ 4, 5, 6 ], [ 2, 3, 6 ] ] ]
#! @EndExampleSession
#!
#! Note, we can always replace a simplicial surface with n vertices, k edges and m 
#! faces by an isomorphic surface where the set of vertices is given by [1..n], the set 
#! of edges is given by [1..k] and the set of faces is given by [1..m] by using the 
#! function CanonicalRepresentativeOfPolygonalSurface()
## ! Note if the numberings for the vertices etc. are strange, i.e. with gaps,
## ! one could or often should replace the surface by its canonical representative
#!
#! @BeginExampleSession
#! gap> XX:=CanonicalRepresentativeOfPolygonalSurface(T);
#! [ simplicial surface (4 vertices, 6 edges, and 4 faces)
#!    , <polygonal morphism> ]
#! gap> Symbol(XX[1]);
#! [ 4, 6, 4, [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ], [ 1, 4 ], [ 2, 4 ], [ 3, 4 ] ], 
#!  [ [ 1, 2, 3 ], [ 1, 4, 5 ], [ 2, 4, 6 ], [ 3, 5, 6 ] ] ]
#! @EndExampleSession
#! 
#! Compute the images of the vertices of T under the isomorphism mapping T on XX
#!
#! @BeginExampleSession
#! gap> List(Vertices(XX[1]),i->ImageOfVertex(XX[2],i));
#! [ 2, 1, 3, 4 ]
#! @EndExampleSession
#!
#! We could do the same for the edges and faces, but since the vertices, etc are already
#! given by [1..4] etc. we shall continue our examinations with T.
#! The face graph can be constructed from the ordinal symbol of T
#! We already know that the set of vertices is given by the set of faces [1,2,3,4] and 
#! we can compute the edges of the face graph by calling
#!
#! @BeginExampleSession
#! gap> FacesOfEdges(T);
#! [ [ 1, 2 ], [ 1, 4 ], [ 2, 4 ], [ 1, 3 ], [ 2, 3 ], [ 3, 4 ] ]
#! @EndExampleSession
#!
#! Note, the edges of the face graph are also determined by the following list:
#!
#! @BeginExampleSession
#! gap> EdgesOfFaces(T);
#! [ [ 1, 2, 4 ], [ 1, 3, 5 ], [ 4, 5, 6 ], [ 2, 3, 6 ] ]
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_FacegraphOfTetrahedron.tex}
#! </Alt>
#!
#! Both lists are partual information of the ordinal symbol of the sphere. 
#! We simply omitted the information for the vertices. But we can obtain the vertices 
#! from the face graph closed edge-face-paths containing exactly three faces and three
#! edges. 
#!
#! @BeginExampleSession
#! gap> VerticesOfEdges(T);
#! [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 2, 4 ], [ 3, 4 ] ]
#! gap> UmbrellaPathsOfVertices(T);
#! [ ( e1, F1, e2, F4, e3, F2, e1 )
#!    , ( e1, F1, e4, F3, e5, F2, e1 )
#!    , ( e2, F1, e4, F3, e6, F4, e2 )
#!    , ( e3, F2, e5, F3, e6, F4, e3 ) 
#! ]
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_FacegraphOfTetrahedron2.tex}
#! </Alt>
#!
#! Note, here the vertices are given in terms of edges and faces, i.e. only in terms
#! of the face graph.
#!
#! Compute the corresponding closed edge-paths
#!
#! @BeginExampleSession
#! gap> List(last,r->EdgesAsList(r));
#! [ [ 1, 2, 3, 1 ], [ 1, 4, 5, 1 ], [ 2, 4, 6, 2 ], [ 3, 5, 6, 3 ] ]
#! @EndExampleSession
#!
#! 
#! How can we reconstruct the VerticesOfEdges with knowledge of the face-graph?
#! Let the number of the vertices be encoded in the position of the closed paths in
#! the above list. So for example vertex 1 is incident to the edges 1, 2 and 3. 
#! This helps us to compute the desired set.
#!
#! Furthermore define the function <K>Umbre2VeOfEd</K> which has a list of closed 
#! edge-face-paths as input and returns the corresponding vertices of edges of a
#! given surface.
#! 
#! @BeginExampleSession
#! gap> Umbre2VeOfEd:=function(R)
#! > local L,ne,nv,i,j,rr;
#! > ne:=Size(Union(R));#Number of edges
#! > nv:=Size(R);#Number of vertices
#! > L:=List([1..ne],i->[]);
#! > for i in [1..nv] do
#! > for j in R[i] do
#! > L[j]:=Union(L[j],[i]);
#! > od;
#! > od;
#! > return L;
#! > end;
#! function( R ) ... end
#! @EndExampleSession
#!
#! Now compute the vertices of edges of the tetrahedron <K>T</K> by using the function 
#! defined above
#!
#! @BeginExampleSession
#! gap> UmbrellaPathsOfVertices(T);
#! [ ( e1, F1, e2, F4, e3, F2, e1 )
#!    , ( e1, F1, e4, F3, e5, F2, e1 )
#!    , ( e2, F1, e4, F3, e6, F4, e2 )
#!    , ( e3, F2, e5, F3, e6, F4, e3 )
#! ]
#! gap> List(last,r->EdgesAsList(r));
#! [ [ 1, 2, 3, 1 ], [ 1, 4, 5, 1 ], [ 2, 4, 6, 2 ], [ 3, 5, 6, 3 ] ]
#! gap> Umbre2VeOfEd(last);
#! [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 2, 4 ], [ 3, 4 ] ]
#! @EndExampleSession
#!
#! Let us verify, that this set is indeed the vertices of edges of T
#! 
#! @BeginExampleSession
#! gap> VerticesOfEdges(T);
#! [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 2, 4 ], [ 3, 4 ] ]
#! @EndExampleSession
##########################################################
#! Let us see whether there exists another simplicial surface <K>X</K> so that 
#! <K>X</K> and <K>T</K> have the same face graph.
#! gap> #T has 6 edges and hence contains 6 butterflies. The butterflies come
#! gap> #in pairs which have the same boundary. This gives us a net of
#! gap> #three vertex defining paths (why?) 

#! We want to examine the face that two non isomorphic simplicial surfaces can have 
#! isomorphic face graphs. So we will construct a simplicial surface which has
#! the same face graph as our tetrahedron T.
#!
#! Idea behind the construction
#!
#! Since there exist 6 edges belonging to the sphere <K>T</K>, there are 6 butterflies
#! contained in the tetrahedron. The butterflies can be sorted into three pairs so
#! that the two butterflies of the corresponding pair of edges share the same
#! boundary vertex-edge path.
#!
#! <Alt Only="TikZ">
#!     \input{Image_MultipleTetrahedron.tex}
#! </Alt>
#!
#! By interpreting the vertices of those paths as faces, we obtain three vertex 
#! defining paths. 
#!
#! @BeginExampleSession
#! gap> L:=List(Edges(T),r->Difference(Union(List(FacesOfEdge(T,r),f->EdgesOfFace(T,f))),[r]));
#! [ [ 2, 3, 4, 5 ], [ 1, 3, 4, 6 ], [ 1, 2, 5, 6 ], [ 1, 2, 5, 6 ], 
#!  [ 1, 3, 4, 6 ], [ 2, 3, 4, 5 ] ]
#! gap> L:=Set(L);
#! [ [ 1, 2, 5, 6 ], [ 1, 3, 4, 6 ], [ 2, 3, 4, 5 ] ]
#! gap> Umbre2VeOfEd(last);
#! [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ], [ 2, 3 ], [ 1, 3 ], [ 1, 2 ] ]
#! gap> nn:=last;;
#! @EndExampleSession
#!
#! Note that the elements of L are not stricly paths but the sets of edges
#! that occur in a relevant path. But that is enough for our purpose of constructing
#! the desired simplicial surface.
#!
#! @BeginExampleSession
#! gap> TT:=PolygonalComplexByDownwardIncidence(nn,EdgesOfFaces(T));
#! simplicial surface (3 vertices, 6 edges, and 4 faces)
#! gap> EulerCharacteristic(TT);
#! 1
#! gap> IsOrientable(TT);
#! false
#! @EndExampleSession
#!
#! Since the Euler-Characteristic of the surfaces differ and the constructed surface is
#! not orientable it cannot be isomorphic to an tetrahedron
#!
#! Of course it would be desiralbe to compute all simplicial surfaces having the same 
#! face graph up to isomorphism.
########################################################################
#!
#! @Subsection Face graph of an octahedron
#!
#! Let us analyse the face graph of an octahedron as second example.
#!
#! @BeginExampleSession
#! gap> ok:=Octahedron();
#! simplicial surface (6 vertices, 12 edges, and 8 faces)
#! @EndExampleSession
#!
#! Compute the octahedron's symbol
#!
#! @BeginExampleSession
#! gap> Symbol(ok);
#! [ 6, 12, 8, 
#!  [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 2, 3 ], [ 2, 5 ], [ 2, 6 ], 
#!      [ 3, 4 ], [ 3, 6 ], [ 4, 5 ], [ 4, 6 ], [ 5, 6 ] ], 
#!  [ [ 1, 2, 5 ], [ 6, 7, 12 ], [ 1, 4, 6 ], [ 5, 7, 9 ], [ 3, 4, 10 ], 
#!      [ 8, 9, 11 ], [ 2, 3, 8 ], [ 10, 11, 12 ] ] ]
#! gap> okc:=FacesOfEdges(ok);
#! [ [ 1, 3 ], [ 1, 7 ], [ 5, 7 ], [ 3, 5 ], [ 1, 4 ], [ 2, 3 ], [ 2, 4 ], 
#!  [ 6, 7 ], [ 4, 6 ], [ 5, 8 ], [ 6, 8 ], [ 2, 8 ] ]
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_FacegraphOfOctahedron.tex}
#! </Alt>
#!
#! Note the edge graph of a simplicial surface is the graph resulting from the vertices
#! and edges of the surfaces being the vertices and edges of the graph. Two vertices
#! V1,V2 connected through an edge in the graph if they are incident vertices in the
#! surface.
#! The face graph of an octahedron is isomorphic to the edge graph of a cube.
#!
#! <Alt Only="TikZ">
#!     \input{Image_CubeN.tex}
#! </Alt>
#!
#! The vertices of the octahedron are determined by the closed paths containing
#! exactly four faces and edges. 
#!   
#! @BeginExampleSession
#! gap> UmbrellaPathsOfVertices(ok);
#! [ ( e1, F1, e2, F7, e3, F5, e4, F3, e1 )
#!    , ( 1, F1, e5, F4, e7, F2, e6, F3, e1 )
#!    , ( e2, F1, e5, F4, e9, F6, e8, F7, e2 )
#!    , ( e3, F5, e10, F8, e11, F6, e8, F7, e3 )
#!    , ( e4, F3, e6, F2, e12, F8, e10, F5, e4 )
#!    ,  ( e7, F2, e12, F8, e11, F6, e9, F4, e7) 
#! ]
#! gap> List(last,r->EdgesAsList(r));
#! [ [ 1, 2, 3, 4, 1 ], [ 1, 5, 7, 6, 1 ], [ 2, 5, 9, 8, 2 ], 
#!  [ 3, 10, 11, 8, 3 ], [ 4, 6, 12, 10, 4 ], [ 7, 12, 11, 9, 7 ] ]
#! gap> List(last2,r->FacesAsList(r));
#! [ [ 1, 7, 5, 3 ], [ 1, 4, 2, 3 ], [ 1, 4, 6, 7 ], [ 5, 8, 6, 7 ], 
#!   [ 3, 2, 8, 5 ], [ 2, 8, 6, 4 ] ]
#! @EndExampleSession
#!
#! Compute the opposite faces of the octahedron ok
#!
#! @BeginExampleSession
#! gap> VV:=VerticesOfFaces(ok);
#! [ [ 1, 2, 3 ], [ 2, 5, 6 ], [ 1, 2, 5 ], [ 2, 3, 6 ], [ 1, 4, 5 ], 
#!  [ 3, 4, 6 ], [ 1, 3, 4 ], [ 4, 5, 6 ] ]
#! gap> List([1..8],i->Filtered([1..8],r->Intersection(VV[i],VV[r])=[]));
#! [ [ 8 ], [ 7 ], [ 6 ], [ 5 ], [ 4 ], [ 3 ], [ 2 ], [ 1 ] ]
#! @EndExampleSession
#!
#! Hence the pairs of opposite faces are [1,8], [2,7], [3,6] and [4,5].
#! gap> # Those vertex-edge-paths avoiding the vertices of such a diagonal
#! gap> # are all in one dihedral class. Taken together they correspond to the vertices of
#! gap> # of a surface in the same edge-face-class as ok:
#!
#! @BeginExampleSession
#! gap> List([1,8],i->EdgesOfFace(ok,i));
#! [ [ 1, 2, 5 ], [ 10, 11, 12 ] ]
#! gap> z1:=Difference(Edges(ok),Union(last));
#! [ 3, 4, 6, 7, 8, 9 ]
#! gap> List([2,7],i->EdgesOfFace(ok,i));
#! [ [ 6, 7, 12 ], [ 2, 3, 8 ] ]
#! gap> z2:=Difference(Edges(ok),Union(last));
#! [ 1, 4, 5, 9, 10, 11 ]
#! gap> List([3,6],i->EdgesOfFace(ok,i));
#! [ [ 1, 4, 6 ], [ 8, 9, 11 ] ]
#! gap> z3:=Difference(Edges(ok),Union(last));
#! [ 2, 3, 5, 7, 10, 12 ]
#! gap> List([4,5],i->EdgesOfFace(ok,i));
#! [ [ 5, 7, 9 ], [ 3, 4, 10 ] ]
#! gap> z4:=Difference(Edges(ok),Union(last));
#! [ 1, 2, 6, 8, 11, 12 ]
#! gap> Umbre2VeOfEd([z1,z2,z3,z4]);
#! [ [ 2, 4 ], [ 3, 4 ], [ 1, 3 ], [ 1, 2 ], [ 2, 3 ], [ 1, 4 ], [ 1, 3 ], 
#!   [ 1, 4 ], [ 1, 2 ], [ 2, 3 ], [ 2, 4 ], [ 3, 4 ] ]
#! gap> nok:=PolygonalComplexByDownwardIncidence(last,EdgesOfFaces(ok));
#! simplicial surface (4 vertices, 12 edges, and 8 faces)
#! @EndExampleSession
#!
#! Compute elementary to verify that nok is not isomorphic to the octahedron ok
#!
#! @BeginExampleSession
#! gap> EulerCharacteristic(nok);
#! 0
#! gap> VertexCounter(nok);
#! [ [ 6, 4 ] ]
#! gap> IsOrientable(nok);
#! true
#! @EndExampleSession
#!
#! gap> #Hence it is a torus. One can easily recover it from a hexagonal
#! gap> #in the plane by cutting out a rhombus of appropriate size and
#! gap> #identify opposite sides. A nice challenge in paperfolding:
#! gap> #Embed the barycentric subdivision of this gadget into 3-space in
#! gap> #such a way that all the smaller triangles lie in one plane.
#! gap> 
#! gap> #We finish this worksheet by visalizing TT, the projective plane above.
#!
#! @BeginExampleSession
#! gap> TT;
#! simplicial surface (3 vertices, 6 edges, and 4 faces)
#! gap> IsOrientable(TT);
#! false
#! gap> EulerCharacteristic(TT);
#! 1
#! @EndExampleSession
#!
#! gap> #We shall construct a 2-fold covering of TT by the octahedron
#!
#! @BeginExampleSession
#! gap> VertexCounter (TT);
#! [ [ 4, 3 ] ]
#! gap> AutomorphismGroup(TT);
#! Group([ (1,2)(5,6)(7,8)(10,11), (1,2)(5,7)(6,8)(12,13), (2,3)(4,5)(8,9)
#! (11,13) ])
#! gap> StructureDescription(last);
#! "S4"
#! gap> G:=AutomorphismGroup(ok);
#! Group([ (1,2)(4,6)(8,11)(9,13)(10,12)(14,15)(16,18)(20,23)(22,25), (3,5)
#! (8,10)(11,12)(14,16)(15,18)(19,21)(20,22)(23,25)(24,26), (2,3)(4,5)(7,8)
#! (9,10)(12,14)(13,15)(17,18)(20,24)(21,25) ])
#! gap> StructureDescription(G);
#! "C2 x S4"
#! gap> C:=Center(G);
#! Group([ (1,6)(2,4)(3,5)(7,17)(8,18)(9,13)(10,15)(11,16)(12,14)(19,26)(20,25)
#! (21,24)(22,23) ])
#! gap> Orbits(C,Vertices(ok));
#! [ [ 1, 6 ], [ 2, 4 ], [ 3, 5 ] ]
#! gap> Orbits(C,Edges(ok));
#! [ [ 1, 6 ], [ 2, 4 ], [ 3, 5 ], [ 7, 17 ], [ 8, 18 ], [ 9, 13 ], [ 10, 15 ], 
#!  [ 11, 16 ], [ 12, 14 ] ]
#! @EndExampleSession
#!
#! gap> #The numbering gets confusing. We do edges and faces by themselves each
#! 
#! @BeginExampleSession
#! gap> Ge:=AutomorphismGroupOnEdges(ok);
#! Group([ (2,5)(3,7)(4,6)(8,9)(10,12), (2,4)(5,6)(8,10)(9,12), (1,2)(3,4)(6,8)
#! (7,9)(11,12) ])
#! gap> Ce:=Center(Ge);
#! Group([ (1,11)(2,12)(3,7)(4,9)(5,10)(6,8) ])
#! gap> Orbits(Ge,Edges(ok));
#! [ [ 1, 2, 5, 4, 6, 3, 8, 7, 9, 10, 12, 11 ] ]
#! gap> Orbits(Ce,Edges(ok));
#! [ [ 1, 11 ], [ 2, 12 ], [ 3, 7 ], [ 4, 9 ], [ 5, 10 ], [ 6, 8 ] ]
#! gap> Gf:=AutomorphismGroupOnFaces(ok);
#! Group([ (2,5)(4,7), (1,3)(2,4)(5,7)(6,8), (2,6)(3,7) ])
#! gap> Cf:=Center(Gf);
#! Group([ (1,8)(2,7)(3,6)(4,5) ])
#! gap> Fo:=Orbits(Cf,Faces(ok));
#! [ [ 1, 8 ], [ 2, 7 ], [ 3, 6 ], [ 4, 5 ] ]
#! gap> Eo:=Orbits(Ce,Edges(ok));
#! [ [ 1, 11 ], [ 2, 12 ], [ 3, 7 ], [ 4, 9 ], [ 5, 10 ], [ 6, 8 ] ]
#! gap> Vo:=Orbits(C,Vertices(ok));
#! [ [ 1, 6 ], [ 2, 4 ], [ 3, 5 ] ]
#! gap> List([1,2,3],i->EdgesOfFace(ok,i));
#! [ [ 1, 2, 5 ], [ 6, 7, 12 ], [ 1, 4, 6 ] ]
#! gap> List([6,4,5],i->EdgesOfFace(ok,i));
#! [ [ 8, 9, 11 ], [ 5, 7, 9 ], [ 3, 4, 10 ] ]
#! gap> Eo;
#! [ [ 1, 11 ], [ 2, 12 ], [ 3, 7 ], [ 4, 9 ], [ 5, 10 ], [ 6, 8 ] ]
#! gap> Fo;
#! [ [ 1, 8 ], [ 2, 7 ], [ 3, 6 ], [ 4, 5 ] ]
#! gap> List([1,2,3,4],i->EdgesOfFace(ok,i));
#! [ [ 1, 2, 5 ], [ 6, 7, 12 ], [ 1, 4, 6 ], [ 5, 7, 9 ] ]
#! gap> List([8,7,6,5],i->EdgesOfFace(ok,i));
#! [ [ 10, 11, 12 ], [ 2, 3, 8 ], [ 8, 9, 11 ], [ 3, 4, 10 ] ]
#! gap> Eo;
#! [ [ 1, 11 ], [ 2, 12 ], [ 3, 7 ], [ 4, 9 ], [ 5, 10 ], [ 6, 8 ] ]
#! gap> EoF:=[[1,2,5],[2,3,6],[1,4,6],[3,4,5]];
#! [ [ 1, 2, 5 ], [ 2, 3, 6 ], [ 1, 4, 6 ], [ 3, 4, 5 ] ]
#! @EndExampleSession
#!
#! gap> #Now the vertices of Edges:
#!
#! @BeginExampleSession
#! gap> Eo;
#! [ [ 1, 11 ], [ 2, 12 ], [ 3, 7 ], [ 4, 9 ], [ 5, 10 ], [ 6, 8 ] ]
#! gap> Eo1:=List(Eo,i->i[1]);
#! [ 1, 2, 3, 4, 5, 6 ]
#! gap> Eo2:=List(Eo,i->i[2]);
#! [ 11, 12, 7, 9, 10, 8 ]
#! gap> List(Eo1,i->VerticesOfEdge(ok,i));
#! [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 2, 3 ], [ 2, 5 ] ]
#! gap> List(Eo2,i->VerticesOfEdge(ok,i));
#! [ [ 4, 6 ], [ 5, 6 ], [ 2, 6 ], [ 3, 6 ], [ 4, 5 ], [ 3, 4 ] ]
#! gap> Vo;
#! [ [ 1, 6 ], [ 2, 4 ], [ 3, 5 ] ]
#! gap> VoE:=[[1,2],[1,3],[1,2],[1,3],[2,3],[2,3]];
#! [ [ 1, 2 ], [ 1, 3 ], [ 1, 2 ], [ 1, 3 ], [ 2, 3 ], [ 2, 3 ] ]
#! gap> Okmod:=PolygonalComplexByDownwardIncidence(VoE,EoF);
#! simplicial surface (3 vertices, 6 edges, and 4 faces)
#! gap> IsIsomorphic(Okmod,TT);
#! true
#! @EndExampleSession






############################################################################
#########################################################################




#! @Section Vertex-faithful surfaces
#! @SectionLabel vertex-faithful surfaces
#!
#! <M>Problems:</M>
#!  - Construction of multi-tetrahedral spheres
## ! <Enum>
## !  <Item>  </Item>
## ! </Enum>
#! <M>Theoretical</M> <M>background</M>
#! - Vertex-faithful surfaces and boolean operations


#! <M>Frequently</M> <M>used</M> <M>commands</M> 
#! - AllSimplicialSpheres() (<Ref Subsect="AllSimplicialSpheres"/>) 
#! - AutomorphismGroupOnEdges() (<Ref Subsect="AutomorphismGroupOnEdges"/>)
#! - AutomorphismGroupOnFaces() (<Ref Subsect="AutomorphismGroupOnFaces"/>)
#! - EdgesOfFaces() (local version: EdgesOfFace()) (<Ref Subsect="EdgesOfFaces"/>)
#! - EdgesOfVertices() (local version: Edges) (<Ref Subsect="EdgesOfVertices"/>)
#! - FaceDegreesOfVertices() (local version: FaceDegreeOfVertex)(<Ref Subsect="FaceDegreesOfVertices"/>)
#! - FacesOfEdges() (local version: FacesOfEdge()) (<Ref Subsect="FacesOfEdges"/>)
#! - IsIsomorphic() (<Ref Subsect="IsIsomorphic"/>)
#! - SimplicialSurfaceByVerticesInFaces() (works for vertex-faithful surfaces only) (<Ref Subsect="PolygonalStructures_surface"/>)
#! - VertexCounter() (local version: DegreeOfVertex()) (<Ref Subsect="VertexCounter"/>),
#! - VerticesOfFaces() (local Version: VerticesOfFace()) (<Ref Subsect="VerticesOfFaces"/>)
#! <M>Less</M> <M>frequently</M> <M>used</M> <M>commands</M>
#! - Tetrahedron() (<Ref Subsect="Tetrahedron"/>)
#!
#!
#! <M> Mathematical</M> <M>details:</M>
#!
#! This section deals with vertex-faithful surfaces. A simplicial surface is
#! vertex-faithful if and only if the map resulting by mapping an edge resp.
#! face on it's set of incident vertices is injective. An example of a non
#! vertex-faithful sphere is the Janus-Head.
#!
#! <Alt Only="TikZ">
#!     \input{Image_JanusHead.tex}
#! </Alt>
#!
#! @BeginExampleSession
#! gap> JanusHead();
#! simplicial surface (3 vertices, 3 edges, and 2 faces)
#! gap> VerticesOfFaces(last);
#! [ [ 1, 2, 3 ], [ 1, 2, 3 ] ]
#! @EndExampleSession
#!
#! In this exercise we construct multi-tetrahedral spheres.
#! A multi-tetrahedral sphere is a vertex-faithful sphere 
#! constructed through tetrahedral extensions. Starting from a tetrahedron we  
#! iteratively replace faces by 3-gons to obtain the desired spheres. We 
#! have already seen examples of multi-tetrahedral spheres, namely the 
#! tetrahedron and the double-tetrahedron.
#!
#! <Alt Only="TikZ">
#!     \input{Image_TetraederEmb.tex}
#! </Alt>
#!
#! In this exercise we shall refer to a vertex of face degree 3 together
#! with it's incident faces and edges as tetrahedron.
#! Furthermore we say that a tetrahedron is attached resp. a tetrahedron 
#! is removed, if we replace a face by a 3-gon resp. a 3-gon by a face.
#!
#! <Alt Only="TikZ">
#!     \input{Image_TetraExt.tex}
#! </Alt> 
#!
#! We can construct a new sphere out of a vertex-faithful sphere
#! by removing all attached tetrahedra. So in other words, a vertex-faithful sphere is
#! a multi-tetrahedral sphere if and only if iteratively removing all tetrahedra from 
#! the constructed spheres leads to the tetrahedron or the double-tetrahedron.
#! Since we are 
#! only interested in surfaces we shall refer to terms like tetrahedron, double-
#! tetrahedron, etc. as the combinatorial devices describing their combinatorial 
#! structure. So we will work with their incidence geometry and view them as abstract 
#! surfaces. 
#! Note, constructing a new sphere by replacing a face by a tetrahedron can be seen
#! as a subdivision of a surface.
#! 
## This worksheet constructs vertex-faitful surfaces
## Iterated connected sums of tetrahedra (amalgamated over one face)
#!
#! @Subsection Multi-tetrahedral spheres
#!
#! <M>Idea</M> <M>behind</M> <M>the</M> <M>construcion</M>
#!
#! We construct multi-tetrahedral spheres with up to 12 faces by using their sets 
#! of vertices in faces. Tetrahedral extensions can be achieved by computing the
#! symmetric difference of a given multi-tetrahedral sphere and a tetrahedron, both 
#! represented by their vertices in faces. Note, although spheres are constructed by
#! replacing different faces of a sphere by tetrahedra, the resulting spheres
#! can still be isomorphic.
#!
#! @BeginExampleSession
#! gap> t1:=Combinations([1,2,3,4],3);
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 4 ] ]
#! gap> T:=SimplicialSurfaceByVerticesInFaces(t1);
#! simplicial surface (4 vertices, 6 edges, and 4 faces)
#! @EndExampleSession
#! 
#! <Alt Only="TikZ">
#!     \input{Image_Tetrahedron.tex}
#! </Alt>
#!
#! Replace face [2,3,4] by a tetrahedron
#! 
#! @BeginExampleSession
#! gap> t11:=Combinations([2,3,4,5],3);
#! [ [ 2, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], [ 3, 4, 5 ] ]
#! gap> Sydi(t1,t11);
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ],
#!   [ 2, 4, 5 ], [ 3, 4, 5 ] ]
#! gap> T11:=SimplicialSurfaceByVerticesInFaces(last);
#! simplicial surface (5 vertices, 9 edges, and 6 faces)
#! @EndExampleSession
#! 
#!  Replace face [1,2,3] by a tetrahedron
#!
#! @BeginExampleSession
#! gap> t12:=Combinations([1,2,3,5],3);
#! [ [ 1, 2, 3 ], [ 1, 2, 5 ], [ 1, 3, 5 ], [ 2, 3, 5 ] ]
#! gap> Sydi(t1,t12);
#! [ [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 4 ], [ 1, 2, 5 ],
#!   [ 1, 3, 5 ], [ 2, 3, 5 ] ]
#! gap> T12:=SimplicialSurfaceByVerticesInFaces(last);
#! simplicial surface (5 vertices, 9 edges, and 6 faces)
#! @EndExampleSession
#!
#! Replace face [1,2,4] by a tetrahedron
#!
#! @BeginExampleSession
#! gap> t13:=Combinations([1,2,4,5],3);
#! [ [ 1, 2, 4 ], [ 1, 2, 5 ], [ 1, 4, 5 ], [ 2, 4, 5 ] ]
#! gap> Sydi(t1,t13);
#! [ [ 1, 2, 3 ], [ 1, 3, 4 ], [ 2, 3, 4 ], [ 1, 2, 5 ],
#!   [ 1, 4, 5 ], [ 2, 4, 5 ] ]
#! gap> T13:=SimplicialSurfaceByVerticesInFaces(last);
#! simplicial surface (5 vertices, 9 edges, and 6 faces)
#! @EndExampleSession
#!
#! Replace face [1,3,4] by a tetrahedron 
#!
#! @BeginExampleSession
#! gap> t14:=Combinations([1,3,4,5],3);
#! [ [ 1, 3, 4 ], [ 1, 3, 5 ], [ 1, 4, 5 ], [ 3, 4, 5 ] ]
#! gap> Sydi(t1,t14);
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 2, 3, 4 ], [ 1, 3, 5 ],
#!   [ 1, 4, 5 ], [ 3, 4, 5 ] ]
#! gap> T14:=SimplicialSurfaceByVerticesInFaces(last);
#! simplicial surface (5 vertices, 9 edges, and 6 faces)
#! @EndExampleSession
#!
#! Check whether the constructed surfaces are isomorphic 
#!
#! @BeginExampleSession
#! gap> List([T12,T13,T14],S->IsIsomorphic(T11,S));
#! [ true, true, true ]
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_DoubleTetrahedronEmb.tex}
#! </Alt>
#!
#! So special care has to be taken to the choice of faces. Furthermore we
#! introduce some terminology for the purpose of having an easy way to refer to the constructed spheres. 
#! Let X be a multi-tetrahedral sphere. We shall refer to surfaces obtained through 
#! a tetrahedral extension on X as children of X. So the double-tetrahedron is a child 
#! of the tetrahedron.   
#!
#! Start by defining the function <K>Te()</K> which returns the set of vertices in faces 
#! of a tetrahedron whereby the four vertices are given by <K>a,b,c,d</K>
#!
#! @BeginExampleSession
#! gap> Te:=function(a,b,c,d)
#! > return Combinations([a,b,c,d],3);
#! > end;
#! function( a, b, c, d ) ... end
#! @EndExampleSession
#! 
#! Up to isomorphism there is exactly one multi-tetrahedral sphere with 4 faces.
#! Compute the vertices in faces of the first tetrahedron T1:
#!
#! <Alt Only="TikZ">
#!     \input{Image_Tetrahedron.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> T1:=Te(1,2,3,4);
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 4 ] ]
#! gap> VerticesOfFaces(Tetrahedron());
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 2, 3, 4 ], [ 1, 3, 4 ] ]
#! gap> Te(2,3,4,5);
#! [ [ 2, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], [ 3, 4, 5 ] ]
#! @EndExampleSession

##gap> Sydi:=function(A,B)
##> return Difference(Union(A,B),Intersection(A,B));
##> end;
##function( A, B ) ... end
#!
#! As seen in previous computations, there is exactly one multi-tetrahedral sphere with 6 
#! faces up to isomorphism, namely the double-tetrahedron.
#!
#! @BeginExampleSession
#! gap> T2:=Sydi(T1,Te(2,3,4,5));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], 
#!  [ 3, 4, 5 ] ]
#! gap> t2:=SimplicialSurfaceByVerticesInFaces(T2);
#! simplicial surface (5 vertices, 9 edges, and 6 faces)
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_DoubleTetrahedron.tex}
#! </Alt>
#!
#! How do we find all children of t2?
#! We could simply replace every possible face by a tetrahedron and gather the 
#! constructed spheres up to isomorphism.
#! But we want to keep the number of tetrahedral extensions thus the expenses to a 
#! minimum. Therefore we will use the automorphism group on the faces of our spheres to
#! determine the minimum number of faces and also the faces which have to be replaced 
#! to obtain all children of t2.
#!
#! @BeginExampleSession
#! gap> a2:=AutomorphismGroupOnFaces(t2);
#! Group([ (1,2)(4,5), (2,3)(5,6), (1,4)(2,5)(3,6) ])
#! gap> Orbits(a2);
#! [ [ 1, 2, 4, 3, 5, 6 ] ]
#! gap> T3:=Sydi(T2,Te(3,4,5,6));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], 
#!  [ 3, 4, 6 ], [ 3, 5, 6 ], [ 4, 5, 6 ] ]
#! @EndExampleSession
#!
#! So there is exactly one multi-tetrahedral sphere with 8 faces. 
#! <Alt Only="TikZ">
#!     \input{Image_MultiTetraeder8faces.tex}
#! </Alt>
#! Note, we can find the automorphism group of a simplicial surface with n faces  
#! with the help of the symmetric group of degree n. It is easy to see that the 
#! symmetric group acts on the set M, whereby an element A of M has a cardinality
#! of n. The elements of A are subsets of the set of vertices of our surface
#! containing exactly three vertices.
## !whereby M is the set of sets containing exactly 8 
## ! subsets of the set of vertices with three elements. 
#! Then the automorphism group on faces can be identified as the stabilizer of
#! the set of vertices in faces of our multi-tetrahedral sphere under the described 
#! group action.
#!
#! @BeginExampleSession
#! gap> A3:=Stabilizer(SymmetricGroup(6),T3,OnSetsSets);
#! Group([ (3,4), (1,6)(2,5) ])
#! gap> Orbits(A3,T3,OnSets);
#! [ [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 3, 5, 6 ], [ 4, 5, 6 ] ], 
#!  [ [ 1, 3, 4 ], [ 3, 4, 6 ] ], [ [ 2, 3, 5 ], [ 2, 4, 5 ] ] ]
#! @EndExampleSession
#!
#! So there are exactly three multi-tetrahedral spheres with 10 faces which
#! at the same time are all 
#! children of the same multi-tetrehedral sphere. They are represented by the following 
#! set of faces represented by their vertices in faces. 
#!
#! @BeginExampleSession
#! gap> O3:=last;
#! [ [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 3, 5, 6 ], [ 4, 5, 6 ] ], 
#!  [ [ 1, 3, 4 ], [ 3, 4, 6 ] ], [ [ 2, 3, 5 ], [ 2, 4, 5 ] ] ]
#! gap> T4x1:=Sydi(T3,Te(4,5,6,7));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], 
#!  [ 3, 4, 6 ], [ 3, 5, 6 ], [ 4, 5, 7 ], [ 4, 6, 7 ], [ 5, 6, 7 ] ]
#! gap> T4x2:=Sydi(T3,Te(3,4,6,7));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], 
#!  [ 3, 4, 7 ], [ 3, 5, 6 ], [ 3, 6, 7 ], [ 4, 5, 6 ], [ 4, 6, 7 ] ]
#! gap> T4x3:=Sydi(T3,Te(2,4,5,7));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 7 ], 
#!  [ 2, 5, 7 ], [ 3, 4, 6 ], [ 3, 5, 6 ], [ 4, 5, 6 ], [ 4, 5, 7 ] ]
#! @EndExampleSession
#!
#! Comparing their vertex counters shows that they are indeed not isomorpic.
#! 
#! @BeginExampleSession
#! gap> SimplicialSurfaceByVerticesInFaces(T4x1); VertexCounter(last);
#! simplicial surface (7 vertices, 15 edges, and 10 faces)
#! [ [ 3, 2 ], [ 4, 2 ], [ 5, 2 ], [ 6, 1 ] ]
#! gap> SimplicialSurfaceByVerticesInFaces(T4x2); VertexCounter(last);
#! simplicial surface (7 vertices, 15 edges, and 10 faces)
#! [ [ 3, 2 ], [ 4, 3 ], [ 6, 2 ] ]
#! gap> SimplicialSurfaceByVerticesInFaces(T4x3); VertexCounter(last);
#! simplicial surface (7 vertices, 15 edges, and 10 faces)
#! [ [ 3, 3 ], [ 5, 3 ], [ 6, 1 ] ]
#! @EndExampleSession
#!
#! Computing the children of t4x1:
#!
#! @BeginExampleSession
#! gap> A4x1:=Stabilizer(SymmetricGroup(7),T4x1,OnSetsSets);
#! Group([ (1,7)(2,6)(3,5) ])
#! gap> O4x1:=Orbits(A4x1,T4x1,OnSets);
#! [ [ [ 1, 2, 3 ], [ 5, 6, 7 ] ], [ [ 1, 2, 4 ], [ 4, 6, 7 ] ], 
#!  [ [ 1, 3, 4 ], [ 4, 5, 7 ] ], [ [ 2, 3, 5 ], [ 3, 5, 6 ] ], 
#!  [ [ 2, 4, 5 ], [ 3, 4, 6 ] ] ]
#! gap> T5x1:=Sydi(T4x1,Te(5,6,7,8));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], 
#!  [ 3, 4, 6 ], [ 3, 5, 6 ], [ 4, 5, 7 ], [ 4, 6, 7 ], [ 5, 6, 8 ], 
#!  [ 5, 7, 8 ], [ 6, 7, 8 ] ]
#! gap> T5x2:=Sydi(T4x1,Te(4,6,7,8));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], 
#!  [ 3, 4, 6 ], [ 3, 5, 6 ], [ 4, 5, 7 ], [ 4, 6, 8 ], [ 4, 7, 8 ], 
#!  [ 5, 6, 7 ], [ 6, 7, 8 ] ]
#! gap> T5x3:=Sydi(T4x1,Te(4,5,7,8));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], 
#!  [ 3, 4, 6 ], [ 3, 5, 6 ], [ 4, 5, 8 ], [ 4, 6, 7 ], [ 4, 7, 8 ], 
#!  [ 5, 6, 7 ], [ 5, 7, 8 ] ]
#! gap> T5x4:=Sydi(T4x1,Te(3,5,6,8));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], 
#!  [ 3, 4, 6 ], [ 3, 5, 8 ], [ 3, 6, 8 ], [ 4, 5, 7 ], [ 4, 6, 7 ], 
#!  [ 5, 6, 7 ], [ 5, 6, 8 ] ]
#! gap> T5x5:=Sydi(T4x1,Te(3,4,6,8));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], 
#!  [ 3, 4, 8 ], [ 3, 5, 6 ], [ 3, 6, 8 ], [ 4, 5, 7 ], [ 4, 6, 7 ], 
#!  [ 4, 6, 8 ], [ 5, 6, 7 ] ]
#! @EndExampleSession
#!
#! Hence we have 5 non isomorphic descendents of t4x1.
#!
#! Computing their vertex counter:
#! 
#! @BeginExampleSession
#! gap> SimplicialSurfaceByVerticesInFaces(T5x1); VertexCounter(last);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! [ [ 3, 2 ], [ 4, 2 ], [ 5, 2 ], [ 6, 2 ] ]
#! gap> SimplicialSurfaceByVerticesInFaces(T5x2); VertexCounter(last);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! [ [ 3, 2 ], [ 4, 2 ], [ 5, 3 ], [ 7, 1 ] ]
#! gap> SimplicialSurfaceByVerticesInFaces(T5x3); VertexCounter(last);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! [ [ 3, 2 ], [ 4, 3 ], [ 5, 1 ], [ 6, 1 ], [ 7, 1 ] ]
#! gap> SimplicialSurfaceByVerticesInFaces(T5x4); VertexCounter(last);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! [ [ 3, 3 ], [ 4, 1 ], [ 5, 1 ], [ 6, 3 ] ]
#! gap> SimplicialSurfaceByVerticesInFaces(T5x5); VertexCounter(last);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! [ [ 3, 3 ], [ 4, 1 ], [ 5, 2 ], [ 6, 1 ], [ 7, 1 ] ]
#! @EndExampleSession 
#!
#! Note, non isomorphic multi-tetrahedral spheres can still have isomorphic
#! children. But the vertex counter indicates whether two spheres are non
#! isomorphic. This is the case, if their vertex counters do differ.
#! If they have the same vertex counters we have to
#! check whether there exists an isomorphism mapping one to the other.
#!
#! Compute the children of t4x2:
#! @BeginExampleSession
#! gap> A4x2:=Stabilizer(SymmetricGroup(7),T4x2,OnSetsSets);
#! Group([ (3,4), (1,7)(2,6) ])
#! gap> O4x2:=Orbits(A4x2,T4x2,OnSets);
#! [ [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 3, 6, 7 ], [ 4, 6, 7 ] ], 
#!  [ [ 1, 3, 4 ], [ 3, 4, 7 ] ], 
#!  [ [ 2, 3, 5 ], [ 2, 4, 5 ], [ 3, 5, 6 ], [ 4, 5, 6 ] ] ]
#! gap> T5x6:=Sydi(T4x2,Te(4,6,7,8));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], 
#!  [ 3, 4, 7 ], [ 3, 5, 6 ], [ 3, 6, 7 ], [ 4, 5, 6 ], [ 4, 6, 8 ], 
#!  [ 4, 7, 8 ], [ 6, 7, 8 ] ]
#! gap> SimplicialSurfaceByVerticesInFaces(T5x6); VertexCounter(last);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! [ [ 3, 2 ], [ 4, 3 ], [ 5, 1 ], [ 6, 1 ], [ 7, 1 ] ]
#! gap> T5x6 in Orbit(SymmetricGroup(8),T5x3,OnSetsSets);
#! true
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_Child_t4x1andt4x2.tex}
#! </Alt>
#!
#! So the sphere represented by T5x6 is a child of t4x1 and t4x2.
#! Alternatively the isomorphism check can be done by constructing the spheres
#! and using <K>IsIsomorphic()</K> 
#!
#! Compute the remaining children of t4x2:
#! 
#! @BeginExampleSession
#! gap> T5x6:=Sydi(T4x2,Te(3,4,7,8));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], 
#!   [ 3, 4, 8 ], [ 3, 5, 6 ], [ 3, 6, 7 ], [ 3, 7, 8 ], [ 4, 5, 6 ], 
#!   [ 4, 6, 7 ], [ 4, 7, 8 ] ]
#! gap> SimplicialSurfaceByVerticesInFaces(T5x6); VertexCounter(last);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! [ [ 3, 2 ], [ 4, 4 ], [ 7, 2 ] ]
#! gap> T5x7:=Sydi(T4x2,Te(4,5,6,8));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], 
#!   [ 3, 4, 7 ], [ 3, 5, 6 ], [ 3, 6, 7 ], [ 4, 5, 8 ], [ 4, 6, 7 ], 
#!   [ 4, 6, 8 ], [ 5, 6, 8 ] ]
#! gap> SimplicialSurfaceByVerticesInFaces(T5x6); VertexCounter(last);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! [ [ 3, 2 ], [ 4, 4 ], [ 7, 2 ] ]
#! gap> SimplicialSurfaceByVerticesInFaces(T5x7); VertexCounter(last);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! [ [ 3, 3 ], [ 4, 1 ], [ 5, 2 ], [ 6, 1 ], [ 7, 1 ] ]
#! gap> SimplicialSurfaceByVerticesInFaces(T5x5); VertexCounter(last);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! [ [ 3, 3 ], [ 4, 1 ], [ 5, 2 ], [ 6, 1 ], [ 7, 1 ] ]
#! gap> T5x7 in Orbit(SymmetricGroup(8),T5x5,OnSetsSets);
#! true
#! @EndExampleSession
#!
#! So computing the children of t4x2 gives rise to three non isomorphic multi-
#! tetrahedral spheres of which two are also children of t4x1.
#!  
#! Constructing the children of t4x3:
#! 
#! @BeginExampleSession
#! gap> A4x3:=Stabilizer(SymmetricGroup(7),T4x3,OnSetsSets);
#! Group([ (2,3)(6,7), (1,7)(3,5) ])
#! gap> O4x3:=Orbits(A4x3,T4x3,OnSets);
#! [ [ [ 1, 2, 3 ], [ 3, 5, 6 ], [ 2, 5, 7 ] ], 
#!   [ [ 1, 2, 4 ], [ 3, 4, 6 ], [ 4, 5, 7 ], [ 1, 3, 4 ], [ 2, 4, 7 ], 
#!       [ 4, 5, 6 ] ], [ [ 2, 3, 5 ] ] ]
#! @EndExampleSession
#! 
#! Hence the multitetradral-sphere T4x3 has exactly three children.  
#! 
#! @BeginExampleSession
#! gap> T5x7:=Sydi(T4x3,Te(2,5,7,8));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 7 ], 
#!   [ 2, 5, 8 ], [ 2, 7, 8 ], [ 3, 4, 6 ], [ 3, 5, 6 ], [ 4, 5, 6 ], 
#!   [ 4, 5, 7 ], [ 5, 7, 8 ] ]
#! gap> SimplicialSurfaceByVerticesInFaces(T5x7); VertexCounter(last);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! [ [ 3, 3 ], [ 4, 1 ], [ 5, 1 ], [ 6, 3 ] ]
#! gap> T5x7 in Orbit(SymmetricGroup(8),T5x4,OnSetsSets);
#! true
#! gap> T5x7:=Sydi(T4x3,Te(4,5,6,8));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 7 ], 
#!   [ 2, 5, 7 ], [ 3, 4, 6 ], [ 3, 5, 6 ], [ 4, 5, 7 ], [ 4, 5, 8 ], 
#!   [ 4, 6, 8 ], [ 5, 6, 8 ] ]
#! gap> SimplicialSurfaceByVerticesInFaces(T5x7); VertexCounter(last);
#! simplicial surface (8 vertices, 18 edges, [0mand [32m12 faces[0m)[0m
#! [ [ 3, 3 ], [ 4, 1 ], [ 5, 2 ], [ 6, 1 ], [ 7, 1 ] ]
#! gap> T5x7 in Orbit(SymmetricGroup(8),T5x5,OnSetsSets);
#! true
#! gap> T5x7:=Sydi(T4x3,Te(2,3,5,8));
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 8 ], [ 2, 4, 7 ], 
#!   [ 2, 5, 7 ], [ 2, 5, 8 ], [ 3, 4, 6 ], [ 3, 5, 6 ], [ 3, 5, 8 ], 
#!   [ 4, 5, 6 ], [ 4, 5, 7 ] ]
#! gap> SimplicialSurfaceByVerticesInFaces(T5x7); VertexCounter(last);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! [ [ 3, 4 ], [ 6, 4 ] ]
#! gap> VC5:=List([T5x1,T5x2,T5x3,T5x4,T5x5,T5x6,T5x7],r- 
#! >VertexCounter(SimplicialSurfaceByVerticesInFaces(r)));
#! [ [ [ 3, 2 ], [ 4, 2 ], [ 5, 2 ], [ 6, 2 ] ], 
#!   [ [ 3, 2 ], [ 4, 2 ], [ 5, 3 ], [ 7, 1 ] ], 
#!   [ [ 3, 2 ], [ 4, 3 ], [ 5, 1 ], [ 6, 1 ], [ 7, 1 ] ], 
#!   [ [ 3, 3 ], [ 4, 1 ], [ 5, 1 ], [ 6, 3 ] ], 
#!   [ [ 3, 3 ], [ 4, 1 ], [ 5, 2 ], [ 6, 1 ], [ 7, 1 ] ], 
#!   [ [ 3, 2 ], [ 4, 4 ], [ 7, 2 ] ], [ [ 3, 4 ], [ 6, 4 ] ] ]
#! @EndExampleSession
#!
#! So out of the three children two are also children of t4x2.
#! So in total there are exactly seven multi-tetrahedral spheres with 12
#! faces up to isomorphism. The last sphere with vertex counter
#! <K>[[3,4],[6,4]]</K> is of greater interest to us.
#!
#! <Alt Only="TikZ">
#!     \input{Image_Multitetraeder12faces.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> t5x7:=SimplicialSurfaceByVerticesInFaces(T5x7);
#! simplicial surface (8 vertices, 18 edges, and 12 faces)
#! gap> FaceCounter(t5x7);
#! [ [ [ 3, 6, 6 ], 12 ] ]
#! @EndExampleSession
#!
#! One could get the idea that this is a multi-tetrahedral sphere obtained from a 
#! tetrahedron where every face is subdivided due to tetrahedral extension
#!
#! @BeginExampleSession
#! gap> Filtered(Vertices(t5x7),r->FaceDegreeOfVertex(t5x7,r)=3);
#! [ 1, 6, 7, 8 ]
#! gap> List(last,i->NeighbourVerticesOfVertex(t5x7,i));
#! [ [ 2, 3, 4 ], [ 3, 4, 5 ], [ 2, 4, 5 ], [ 2, 3, 5 ] ]
#! gap> Te(2,3,4,5);
#! [ [ 2, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], [ 3, 4, 5 ] ]
#! gap> Set(last2)=last;
#! true 
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_Tetrahedron_4Extensions.tex}
#! </Alt>
#!
#!
#!






































#! @Section Isosceles coloured Surfaces
#! @SectionLabel IsoscelescolouredSurfaces
#!
#! <M>Problems:</M>
#!  Analysing Isosceles coloured surfaces  
#!
#! <M>Theoretical</M> <M>background</M>
#! - isosceles coloured surfaces and boolean operations
#!
#! <M>Frequently</M> <M>used</M> <M>commands</M>
#! - AllIsoscelesColouredSurfaces() (<Ref Subsect="AllIsoscelesColouredSurfaces"/>) 
#! - AllSimplicialSpheres() (<Ref Subsect="AllSimplicialSpheres"/>)
#! - EdgesOfFaces() (local version: EdgesOfFace()) (<Ref Subsect="EdgesOfFaces"/>)
#! - FaceDegreesOfVertices() (local version: FaceDegreeOfVertex) (<Ref Subsect="FaceDegreesOfVertices"/>)
## ! - Faces() (<Ref Subsect="Faces"/>)
#! - NeighbourVerticesOfVertex() (<Ref Subsect="NeighbourVerticesOfVertex"/>),
#! - SubcomplexByFaces() (<Ref Subsect="SubcomplexByFaces"/>)
#! - VertexCounter() (local version: DegreeOfVertex()) (<Ref Subsect="VertexCounter"/>),
#! - VerticesOfFaces() (local Version: VerticesOfFace()) (<Ref Subsect="VerticesOfFaces"/>)
#! - UmbrellaPathsOfVertices() (local version: UmbrellaPathOfVertex()) (<Ref Subsect="UmbrellaPathsOfVertices"/>)

#! <M> Mathematical</M> <M>details:</M>
#! 
#! Most of what has been said in the previous exercises applies for arbitrary 
#! simplicial surfaces and simplicial surfaces of equiangular triangles. This chapter
#! deals with the combinatorial side of simplicial surfaces of congruent isoscles 
#! triangules. More precisely we
#! want to investigate those simplicial surfaces whose isosceles triangules are not 
#! equiangular.
#!
#! <Alt Only="TikZ">
#!     \input{Image_ExampleTriangles.tex}
#! </Alt> 
#!
#! Therefore we define the base selection or simply base of a simplicial surface as a 
#! subset of the edges underlying the condition that every face of the surface is 
#! incident to exactly one edge of the base. We shall refer to an edge as base edge if 
#! it is contained in the base and as a leg if it is not. 
#! This gives rise to two types of vertices of a face. If a vertex of a face is
#! incident to the two legs of the face, then we call it apex vertex or simply apex.
#! So each face is incident to exactly one apex.
#!
#! <Alt Only="TikZ">
#!     \input{Image_IsoscelesColouredTriangle.tex}
#! </Alt> 
#! 
#! We handle simplical surfaces of isosceles triangles in the package by introducing
#! a colouring for edges and 
#! call the resulting structures isosceles coloured simplicial surfaces.
#! For example up to isomorphism there is exactly one isosceles coloured surface 
#! resulting from the tetrahedron.
#!
#! @BeginExampleSession
#! gap> pr:=rec(edgeColourClassColours:=["red","blue"]);;
#! gap> AllIsoscelesColouredSurfaces(T);
#! [ isosceles coloured surface (4 vertices, 6 edges and 4 faces) ]
#! gap> DrawSurfaceToTikz(last[1],"Image_IsoscelesColouredTetrahedron1.tex",pr);
#! Picture written in TikZ.
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_IsoscelesColouredTetrahedron1.tex}
#! </Alt> 
#! 
#! In this exercise we want to examine the apex vertices of a surface. We want to check in how many 
#! isosceles coloured surfaces a given vertex can be an
#! apex vertex, whereby the coloured surfaces all result from a given surface. We gather those coloured surfaces up to isomorphism  
## ! gap> #For some sphere S we check in how many ways a given vertex
## ! gap> #can be apex of all its adjacent faces
## ! gap> #Recall apex is the common vertex of the two leg-edges of 
## ! gap> #an isosceles triangle
## ! gap> 
## ! gap> #Here is the sphere we choose:
#! 
#! For the purpose of this exercise we choose the following surface.
#! @BeginExampleSession
#! gap> S:=AllSimplicialSpheres(20)[5];
#! simplicial surface (12 vertices, 30 edges, and 20 
#! faces)
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_ExampleIsosceles.tex}
#! </Alt> 
#!
#! Compute elementary properties of <K>S</K>
#!
#! @BeginExampleSession
#! gap> VertexCounter(S);
#! [ [ 4, 4 ], [ 5, 4 ], [ 6, 4 ] ]
#! gap> FaceDegreesOfVertices(S);
#! [ 4, 4, 5, 5, 6, 6, 6, 6, 5, 5, 4, 4 ]
#! @EndExampleSession
#!
#! We choose vertex 1 for our examinations and compute the neighbour vertices of this 
#! vertex
#!
#! @BeginExampleSession
#! gap> NeighbourVerticesOfVertex(S,1);
#! [ 8, 9, 10, 11 ]
#! @EndExampleSession
#!
#! Compute all isosceles coloured surfaces of <K>S</K>
#!
#! @BeginExampleSession
#! gap> ss:=AllIsoscelesColouredSurfaces(S);
#! [ isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#!    , isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#!    , isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#!    , isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#!    , isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#!    , isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#!    , isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#!    , isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#!    , isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#!    , isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#!    , isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#!    , isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#!    , isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#!    , isosceles coloured surface (12 vertices, 30 edges and 20 faces) 
#!  ]
#! @EndExampleSession
#!
#! So introducing the isosceles colouring results in 14 isosceles coloured surfaces.
#! Display all elementary properties of the first surface in the list <K>ss</K>
#!
#! @BeginExampleSession
#! gap> Display(ss[1]);
#! Isosceles coloured surface ( closed, orientable, Euler-characteristic 2)
#!     Vertices (12): [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]
#!     Edges (30): [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,  
#! 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 ]
#!     Faces (20): [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 
#! 18, 19, 20 ]
#!     VerticesOfEdges: [ [ 1, 8 ], [ 1, 9 ], [ 1, 10 ], [ 1, 11 ], [ 2, 3 ], 
#! [ 2, 4 ], [ 2, 6 ], [ 2, 12 ], [ 3, 5 ], 
#! [ 3, 6 ], [ 3, 7 ], [ 3, 12 ],
#! [ 4, 5 ], [ 4, 6 ], [ 4, 8 ], [ 4, 12 ], 
#! [ 5, 7 ], [ 5, 8 ], [ 5, 9 ], [ 5, 12 ], [ 6, 7 ], [ 6, 8 ], [ 6, 10 ], 
#! [ 7, 9 ], [ 7, 10 ], [ 7, 11 ], [ 8, 9 ], [ 8, 10 ], [ 9, 11 ], [ 10, 11 ] ]
#!    VerticesOfFaces: [ [ 1, 8, 9 ], [ 1, 8, 10 ], [ 1, 9, 11 ], [ 1, 10, 11 ], 
#! [ 2, 3, 6 ], [ 2, 3, 12 ], [ 2, 4, 6 ], [ 2, 4, 12 ], [ 3, 5, 7 ], [ 3, 5, 12 ], 
#! [ 3, 6, 7 ], [ 4, 5, 8 ], [ 4, 5, 12 ], [ 4, 6, 8 ], [ 5, 7, 9 ], [ 5, 8, 9 ], 
#! [ 6, 7, 10 ], [ 6, 8, 10 ], [ 7, 9, 11 ], [ 7, 10, 11 ] ]
#!     EdgesOfFaces: [ [ 1, 2, 27 ], [ 1, 3, 28 ], [ 2, 4, 29 ],
#! [ 3, 4, 30 ], [ 5, 7, 10 ], [ 5, 8, 12 ], [ 6, 7, 14 ], 
#! [ 6, 8, 16 ], [ 9, 11, 17 ], [ 9, 12, 20 ], [ 10, 11, 21 ], [ 13, 15, 18 ],
#! [ 13, 16, 20 ], [ 14, 15, 22 ], [ 17, 19, 24 ], [ 18, 19, 27 ], [ 21, 23, 25 ], 
#! [ 22, 23, 28 ], [ 24, 26, 29 ], [ 25, 26, 30  ]
#!    Umbrella-paths: [ ( e1, F1, e2, F3, e4, F4, e3, F2, e1 ),
#! ( e5, F5, e7, F7, e6, F8, e8, F6, e5 ),
#! ( e5, F5, e10, F11, e11, F9, e9, F10, e12, F6, e5 ),
#! ( e6, F7, e14, F14, e15, F12, e13, F13, e16, F8, e6 ),
#! ( e9, F9, e17, F15, e19, F16, e18, F12, e13, F13, e20, F10, e9 ),
#! ( e7, F5, e10, F11, e21, F17, e23, F18, e22, F14, e14, F7, e7 ),
#! ( e11, F9, e17, F15, e24, F19, e26, F20, e25, F17, e21, F11, e11 ),
#! ( e1, F1, e27, F16, e18, F12, e15, F14, e22, F18, e28, F2, e1 ),
#! ( e2, F1, e27, F16, e19, F15, e24, F19, e29, F3, e2 ),
#! ( e3, F2, e28, F18, e23, F17, e25, F20, e30, F4, e3 ),
#! ( e4, F3, e29, F19, e26, F20, e30, F4, e4 ),
#! ( e8, F6, e12, F10, e20, F13, e16, F8, e8 ) ]
#!    EdgesOfColours: [  [ 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 13, 14, 18, 19, 20, 22,  
#! 23, 24, 25, 26 ], [ 7, 12, 15, 16, 17, 21, 27, 28, 29, 30 ] ]
#!    LocalSymmetry: [ mirror, mirror, mirror, mirror, rotation, rotation, mirror, 
#! mirror, rotation, mirror, mirror, mirror, mirror, rotation, mirror, mirror,  
#! mirror, mirror, rotation, mirror, mirror, mirror, rotation, rotation, rotation,  
#! mirror, mirror, mirror, mirror, mirror ]
#! @EndExampleSession
#!
#! Compute the automorphism group permutating the edges of <K>S</K>
#!
#! @BeginExampleSession
#! gap> A:=AutomorphismGroupOnEdges(S);
#! Group([ (1,26)(2,29)(3,30)(5,6)(9,13)(10,14)(11,15)(12,16)(17,18)(21,22)
#!   (24,27)(25,28), (2,3)(5,12)(6,16)(7,20)(9,10)(13,14)(17,21)(18,22)(19,23)
#!   (24,25)(27,28)(29,30), (1,7)(2,5)(3,6)(4,8)(9,24)(10,27)(11,19)(12,29)
#!   (13,25)(14,28)(15,23)(16,30)(18,21)(20,26) ])
#! gap> Size(A);
#! 8
#! @EndExampleSession
#! 
#! For vertex 1 being an apex, all edges incident to the vertex 1 have to be legs and 
#! the remaining edges of the faces incident to our vertex have to be base edges.
#!
#! Compute the the edges which have to be base edges
#! 
#! @BeginExampleSession
#! gap> S1:=SubcomplexByFaces(S,FacesOfVertex(S,1));
#! simplicial surface ( 5 vertices, 8 edges, and 4 faces)
#! gap> bb:=BoundaryEdges(S1);
#! [ 27, 28, 29, 30 ]
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_IsoscelesUmbrella.tex}
#! </Alt> 
#!
#! Hence we have to find all base-selections containing <K>bb</K> or the set resulting from 
#! manipulating bb with the help of an isomorphism of the automorphism group on the
#! edges.
#!
#! First we have to compute the base-selections of the sufaces in the <K>ss</K>.
#! @BeginExampleSession
#! gap> ss:=List(ss,r->Set(List(Faces(r),f->BaseEdgeOfFace(r,f))));
#! [ [ 7, 12, 15, 16, 17, 21, 27, 28, 29, 30 ], 
#!   [ 7, 8, 15, 17, 20, 21, 27, 28, 29, 30 ], 
#!   [ 3, 6, 10, 12, 13, 17, 22, 25, 27, 29 ], 
#!   [ 4, 8, 9, 10, 13, 14, 24, 25, 27, 28 ], 
#!   [ 4, 7, 12, 15, 16, 17, 21, 26, 27, 28 ], 
#!   [ 4, 7, 11, 12, 15, 16, 24, 25, 27, 28 ], 
#!   [ 4, 7, 8, 15, 17, 20, 21, 26, 27, 28 ], 
#!   [ 4, 7, 8, 11, 15, 20, 24, 25, 27, 28 ], 
#!   [ 2, 3, 7, 12, 16, 17, 18, 21, 22, 26 ], 
#!   [ 2, 3, 7, 11, 12, 15, 16, 19, 23, 26 ], 
#!   [ 2, 3, 7, 8, 17, 18, 20, 21, 22, 26 ], 
#!   [ 2, 3, 7, 8, 11, 15, 19, 20, 23, 26 ], 
#!   [ 1, 4, 7, 8, 17, 18, 20, 21, 22, 26 ], 
#!   [ 1, 4, 7, 8, 11, 15, 19, 20, 23, 26 ] ]
#! gap> Size(ss);
#! 14
#! @EndExampleSession 
#! 
#! Check whether <K>bb</K> is contained in one of the base selections
#!
#! @BeginExampleSession
#! gap> obb:=Orbit(A,bb,OnSets);
#! [ [ 27, 28, 29, 30 ], [ 2, 3, 24, 25 ], [ 10, 12, 14, 16 ], [ 5, 6, 9, 13 ] ]
#! gap> Filtered([1..14],i->IsSubset(ss[i],obb[1]));
#! [ 1, 2 ]
#! gap> Filtered([1..14],i->IsSubset(ss[i],obb[2]));
#! [  ]
#! gap> Filtered([1..14],i->IsSubset(ss[i],obb[3]));
#! [  ]
#! gap> Filtered([1..14],i->IsSubset(ss[i],obb[4]));
#! [  ]
#! @EndExampleSession
#!
#! So at first glance it looks like there are only two possibilities. But there are 
#! more. We obtain this observatin by manipulating the base selection of the first 
#! isoscoles coloured surface in the list <K>ss</K>.
#!
#! @BeginExampleSession
#! gap> ss1:=Orbit(A,ss[1],OnSets);
#! [ [ 7, 12, 15, 16, 17, 21, 27, 28, 29, 30 ], 
#!   [ 2, 3, 7, 11, 12, 16, 18, 22, 24, 25 ], 
#!   [ 5, 6, 15, 17, 20, 21, 27, 28, 29, 30 ], 
#!   [ 1, 10, 12, 14, 16, 17, 18, 23, 29, 30 ], 
#!   [ 2, 3, 5, 6, 11, 18, 20, 22, 24, 25 ], 
#!   [ 1, 5, 6, 9, 13, 19, 21, 22, 29, 30 ], 
#!   [ 2, 3, 10, 12, 14, 16, 17, 18, 23, 26 ], 
#!   [ 2, 3, 5, 6, 9, 13, 19, 21, 22, 26 ] ]
#! gap> Filtered(ss1,r->IsSubset(r,bb));
#! [ [ 7, 12, 15, 16, 17, 21, 27, 28, 29, 30 ], 
#!   [ 5, 6, 15, 17, 20, 21, 27, 28, 29, 30 ] ]
#!gap> ss2:=Orbit(A,ss[2],OnSets);
#! [ [ 7, 8, 15, 17, 20, 21, 27, 28, 29, 30 ], 
#!   [ 2, 3, 7, 8, 11, 18, 20, 22, 24, 25 ], 
#!   [ 1, 4, 10, 12, 14, 16, 17, 18, 23, 26 ], 
#!   [ 1, 4, 5, 6, 9, 13, 19, 21, 22, 26 ] ]
#! gap> Filtered(ss2,r->IsSubset(r,bb));
#! [ [ 7, 8, 15, 17, 20, 21, 27, 28, 29, 30 ] ]
#! @EndExampleSession
#!
#! Hence we have at least three possibilities for an isosceles 
#! coloured simplicial suface resulting from <K>S</K> and having vertex 1 as apex. Indeed 
#! there exactly three such surfaces. Let us now visualise these edge coloured surfaces.
## ! gap> 
## ! gap> #To draw planar developments of the three, we have to 
## ! gap> #turn the base sets into isosceles spheres again:
#!
#!
#! Compute the isosceles coloured surfaces with the constructed base selections
#! @BeginExampleSession
#! gap> SS1:=List([1..30],i->1);
#! [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
#!  1, 1, 1, 1, 1 ]
#! gap> for i in ss1[1] do SS1[i]:=2;od;
#! gap> SS1:=EdgeColouredPolygonalComplex(S,SS1);
#! isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#! gap> SS2:=List([1..30],i->1);
#! [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
#!   1, 1, 1, 1, 1 ]
#! gap> for i in ss1[3] do SS2[i]:=2;od;
#! gap> SS2:=EdgeColouredPolygonalComplex(S,SS2);
#! isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#! gap> SS3:=List([1..30],i->1);
#! [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
#!   1, 1, 1, 1, 1 ]
#! gap> for i in ss2[1] do SS3[i]:=2;od;
#! gap> SS3:=EdgeColouredPolygonalComplex(S,SS3);
#! isosceles coloured surface (12 vertices, 30 edges and 20 faces)
#! @EndExampleSession
#!
#! Draw the net of the surface <K>SS1</K> into a tex-file using TikZ
#!
#! @BeginExampleSession 
#! gap> pr:=rec(edgeColourClassColours:=["red","blue"],
#! > edgeColourClassLengths:=[1.2, 0.8]);;
#! gap> pr.compileLaTeX:=true;
#! true
#! gap> pr:=DrawSurfaceToTikz(SS1,"Zwa1",pr);;
#! DrawSurfaceToTikz: Could not find intersection-free continuation. Draw face 
#! 17 via edge 21 instead.
#! Picture written in TikZ.Start LaTeX-compilation (type 'x' and press ENTER to
#! abort).
#! Picture rendered (with pdflatex).
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_Zwa1.tex}
#! </Alt> 
#!
#! Draw the net of the surface <K>SS2</K> into a tex-file using TikZ
#!
#! @BeginExampleSession 
#! gap> pr:=rec(edgeColourClassColours:=["red","blue"],
#! > edgeColourClassLengths:=[1.2, 0.8], compileLaTeX:=true);;
#! gap> pr:=DrawSurfaceToTikz(SS2,"Zwa2",pr);;
#! DrawSurfaceToTikz: Could not find intersection-free continuation. Draw face 
#! 18 via edge 22 instead.
#! Picture written in TikZ.Start LaTeX-compilation (type 'x' and press ENTER to
#! abort).
#! Picture rendered (with pdflatex).
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_Zwa1.tex}
#! </Alt> 
#!
#! Draw the net of the surface <K>SS3</K> into a tex-file using TikZ
#!
#! @BeginExampleSession 
#! gap> pr:=rec(edgeColourClassColours:=["red","blue"],
#! > edgeColourClassLengths:=[1.2, 0.8], compileLaTeX:=true);;
#! gap> pr:=DrawSurfaceToTikz(SS3,"Zwa3",pr);;
#! DrawSurfaceToTikz: Could not find intersection-free continuation. Draw face 
#! 17 via edge 21 instead.
#! Picture written in TikZ.Start LaTeX-compilation (type 'x' and press ENTER to
#! abort).
#! Picture rendered (with pdflatex).
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!     \input{Image_Zwa3.tex}
#! </Alt> 
#!




#! @Section Butterfly-Deletion
#! @SectionLabel Butterfly-Deletion
#!
#! <M>Problems:</M>
#!  Construction of spheres via butterfly-deletions on the icosahedron
#!
#! <M>Theoretical</M> <M>background</M>
#! - Vertex-faithful surfaces and boolean operations
#! - Umbrella descriptor of simplicial surfaces
#!
#! <M>Frequently</M> <M>used</M> <M>commands</M>
#! - AutomorphismGroupOnFaces() (<Ref Subsect="AutomorphismGroupOnFaces"/>)
#! - UmbrellaDescriptorOfSurface() (<Ref Subsect="UmbrellaDescriptorOfSurface"/>) 
#!
#! <M>Less</M> <M>frequently</M> <M>used</M> <M>commands</M>
#! - Icosahedron() (<Ref Subsect="Icosahedron"/>)
#! - DistanceOfFaces() (<Ref Subsect="DistanceOfFaces"/>)

#! <M> Mathematical</M> <M>details:</M>
#! The butterfly deletion constructs a simplicial surface by removing a butterfly of a
#! given simplicial surface. To apply the butterfly deletion we need an inner edge of 
#! the surface not belonging to a 2-Waist. The resulting simplicial surface can
#! be defined in two steps.
#! <Enum>
#!  <Item> The two faces incident to the given inner edge are removed from the surface
#!  by applying cuts along the four edges incident to exactly one of the two faces.
#!  </Item>
#!  <Item> Step 1 gives rise to four new boundary edges and two boundary vertices
#!  which were incident to exactly one of the removed faces. By applying mender
#!  operations so that each pair of edges incident to the same boundary vertex get
#!  identified, the simplicial surfac resulting from the butterfly deletion is
#!  constructed.
#!  </Item>
#! </Enum> 
#! Clearly the butterfly deletion can be reversed, namely by using the butterfly
#! insertion.
#!
#! <Alt Only="TikZ">
#!     \input{Image_ButterflyManipulation.tex}
#! </Alt> 
#!
#! In this chapter we will familliarize ourselves with the butterfly deletion. We want
#! to compute the simplicial surfaces constructed up to isomorphism by
#! applying at most two butterfly deletions to the icosahedron. Note, applying the
#! butterfly deletion to a simplicial surface does not affect the Euler-Characteristic.
#!
#! <Alt Only="JavaScript">
#!     Ico.html
#! </Alt> 
#! 
#! Since a given simplicial surface can be uniquly reconstructed from it's umbrella 
#! descriptor, we shall use this structure to examine the butterfly deletion in this
#! exercise. 
#! Note, it is also possible to define this construction by manipulating the incidence
#! structure, namely the edges of faces and the vertices of edges. 
#!
#! Let us start by defining a function that omits a given face from a simplicial surface
#! represented by its umbrella descriptor.
#!
#! <Alt Only="TikZ">
#!     \input{Image_Omitface.tex}
#! </Alt> 
#!
#! @BeginExampleSession
#! gap> Omit:=function ( Z, i )
#!    local a, b;
#!    if i ^ Z = i then
#!        return Z;
#!    fi;
#!    a := Orbit( Group( Z ), i );
#!    b := List( [ 2 .. Size( a ) ], function ( i )
#!            return a[i];
#!        end );
#!    return CycleFromList( b );
#! end
#! @EndExampleSession
#!
#! Given the umbrella descriptor of a simplicial surface, the butterfly
#! deletion can be applied by using the folllowing function.
#!
#! @BeginExampleSession
#! gap>Zus:=function ( ZZ, i, j )
#!     local ZZ1, r, k;
#!     ZZ1 := Filtered( ZZ, function ( r )
#!             return not (i ^ r = j or j ^ r = i);
#!        end );
#!     ZZ1 := List( ZZ1, function ( r )
#!            return Omit( r, i );
#!        end );
#!    ZZ1 := List( ZZ1, function ( r )
#!            return Omit( r, j );
#!         end );
#!     r := Filtered( ZZ, function ( r )
#!             return i ^ r = j or j ^ r = i;
#!         end );
#!     if i ^ r[1] <> j then
#!         r[1] := r[1] ^ -1;
#!     fi;
#!     if j ^ r[2] <> i then
#!         r[2] := r[2] ^ -1;
#!     fi;
#!     r[1] := Orbit( Group( r[1] ), i );
#!     r[2] := Orbit( Group( r[2] ), j );
#!     r[1] := List( [ 3 .. Size( r[1] ) ], function ( k )
#!             return r[1][k];
#!         end );
#!     r[2] := List( [ 3 .. Size( r[2] ) ], function ( k )
#!             return r[2][k];
#!         end );
#!     for k in r[2] do
#!         Add( r[1], k );
#!     od;
#!     Add( ZZ1, CycleFromList( r[1] ) );
#!     return ZZ1;
#! end
#! @EndExampleSession
#! 
#! Let us compute the icosahedron and it's umbrella descriptor.
#!
#! @BeginExampleSession
#! gap> Ik:=Icosahedron();
#! simplicial surface (12 vertices, 30 edges, and 20 faces)
#! gap> UIk:=UmbrellaDescriptorOfSurface(Ik);
#! [ (1,5,4,3,2), (1,6,11,7,2), (1,6,15,10,5), (2,7,12,8,3), (3,8,13,9,4), 
#!   (4,9,14,10,5), (6,15,20,16,11), (7,12,17,16,11), (8,13,18,17,12), 
#!   (9,14,19,18,13), (10,14,19,20,15), (16,17,18,19,20) ]
#! @EndExampleSession 
#!
#! <Alt Only="TikZ">
#!     \input{Image_Icosahedron.tex}
#! </Alt> 
#!
#! Up to isomorphism there is exactly one sphere resulting from applying
#! exactly one butterfly deletion to the icosahedron.
#! We obtain this sphere represented by it's umbrella descriptor by removing the
#! butterfly containing the faces 1 and 2.
#!
#! @BeginExampleSession
#! gap> U1:=Zus(UIK,1,2);
#! [ (5,6,15,10), (3,7,12,8), (3,8,13,9,4), (4,9,14,10,5), (6,15,20,16,11), 
#!   (7,12,17,16,11), (8,13,18,17,12), (9,14,19,18,13), (10,14,19,20,15), 
#!   (16,17,18,19,20), (3,4,5,6,11,7) ]
#! gap> List(U1,Order);
#! [ 4, 5, 5, 4, 5, 5, 5, 5, 5, 5, 6 ]
#! gap> Collected(last);
#! [ [ 4, 2 ], [ 5, 8 ], [ 6, 1 ] ]
#! @EndExampleSession
#!
#! Note, applying the butterfly deletion gives rise to the butterflies [3,7] and [5,6]. 
#! But since we are only interested in butterflies which are also  contained in the 
#! icosahadron, those butterflies can be ignored.
#!
#! <Alt Only="TikZ">
#!     \input{Image_ButterflyDeletionOnIcosahedron.tex}
#! </Alt> 
#!
#! For further computations the automorphism group on the faces of the
#! icosahedron will be helpful. 
#!
#! @BeginExampleSession 
#! gap> GK:=AutomorphismGroupOnFaces(Ik);
#! Group([ (1,2)(3,5)(6,7)(8,10)(12,15)(13,14)(17,20)(18,19), (1,2)(3,6)(4,11)
#!   (5,7)(8,15)(9,16)(10,12)(13,20)(14,17)(18,19), (1,5,4,3,2)(6,10,9,8,7)
#!   (11,15,14,13,12)(16,20,19,18,17) ])
#! @EndExampleSession
#!
#! Since a butterfly can be seen as the set of two neighbouring faces in the umbrella
#! of a vertex, the set of butterflies of the icosahedron can be computed by using the 
#! cycles given by the umbrella descriptor.
#!
#! @BeginExampleSession
#! Bu:=List([1..20],i->List(UIk,g->Set([i,i^g])); 
#! gap> Bu:=List([1..20],i->List(UIk,g->Set([i,i^g])));
#! [ [ [ 1, 5 ], [ 1, 6 ], [ 1, 6 ], [ 1 ], [ 1 ], [ 1 ], [ 1 ], [ 1 ], [ 1 ], 
#!      [ 1 ], [ 1 ], [ 1 ] ], 
#!  [ [ 1, 2 ], [ 1, 2 ], [ 2 ], [ 2, 7 ], [ 2 ], [ 2 ], [ 2 ], [ 2 ], [ 2 ], 
#!      [ 2 ], [ 2 ], [ 2 ] ], 
#!  [ [ 2, 3 ], [ 3 ], [ 3 ], [ 2, 3 ], [ 3, 8 ], [ 3 ], [ 3 ], [ 3 ], [ 3 ], 
#!      [ 3 ], [ 3 ], [ 3 ] ], 
#!  [ [ 3, 4 ], [ 4 ], [ 4 ], [ 4 ], [ 3, 4 ], [ 4, 9 ], [ 4 ], [ 4 ], [ 4 ], 
#!      [ 4 ], [ 4 ], [ 4 ] ], 
#!  [ [ 4, 5 ], [ 5 ], [ 1, 5 ], [ 5 ], [ 5 ], [ 4, 5 ], [ 5 ], [ 5 ], [ 5 ], 
#!      [ 5 ], [ 5 ], [ 5 ] ], 
#!  [ [ 6 ], [ 6, 11 ], [ 6, 15 ], [ 6 ], [ 6 ], [ 6 ], [ 6, 15 ], [ 6 ], 
#!      [ 6 ], [ 6 ], [ 6 ], [ 6 ] ], 
#!  [ [ 7 ], [ 2, 7 ], [ 7 ], [ 7, 12 ], [ 7 ], [ 7 ], [ 7 ], [ 7, 12 ], 
#!      [ 7 ], [ 7 ], [ 7 ], [ 7 ] ], 
#!  [ [ 8 ], [ 8 ], [ 8 ], [ 3, 8 ], [ 8, 13 ], [ 8 ], [ 8 ], [ 8 ], 
#!      [ 8, 13 ], [ 8 ], [ 8 ], [ 8 ] ], 
#!  [ [ 9 ], [ 9 ], [ 9 ], [ 9 ], [ 4, 9 ], [ 9, 14 ], [ 9 ], [ 9 ], [ 9 ], 
#!      [ 9, 14 ], [ 9 ], [ 9 ] ], 
#!  [ [ 10 ], [ 10 ], [ 5, 10 ], [ 10 ], [ 10 ], [ 5, 10 ], [ 10 ], [ 10 ], 
#!      [ 10 ], [ 10 ], [ 10, 14 ], [ 10 ] ], 
#!  [ [ 11 ], [ 7, 11 ], [ 11 ], [ 11 ], [ 11 ], [ 11 ], [ 6, 11 ], [ 7, 11 ], 
#!      [ 11 ], [ 11 ], [ 11 ], [ 11 ] ], 
#!  [ [ 12 ], [ 12 ], [ 12 ], [ 8, 12 ], [ 12 ], [ 12 ], [ 12 ], [ 12, 17 ], 
#!      [ 8, 12 ], [ 12 ], [ 12 ], [ 12 ] ], 
#!  [ [ 13 ], [ 13 ], [ 13 ], [ 13 ], [ 9, 13 ], [ 13 ], [ 13 ], [ 13 ], 
#!      [ 13, 18 ], [ 9, 13 ], [ 13 ], [ 13 ] ], 
#!  [ [ 14 ], [ 14 ], [ 14 ], [ 14 ], [ 14 ], [ 10, 14 ], [ 14 ], [ 14 ], 
#!      [ 14 ], [ 14, 19 ], [ 14, 19 ], [ 14 ] ], 
#!  [ [ 15 ], [ 15 ], [ 10, 15 ], [ 15 ], [ 15 ], [ 15 ], [ 15, 20 ], [ 15 ], 
#!      [ 15 ], [ 15 ], [ 10, 15 ], [ 15 ] ], 
#!  [ [ 16 ], [ 16 ], [ 16 ], [ 16 ], [ 16 ], [ 16 ], [ 11, 16 ], [ 11, 16 ], 
#!      [ 16 ], [ 16 ], [ 16 ], [ 16, 17 ] ], 
#!  [ [ 17 ], [ 17 ], [ 17 ], [ 17 ], [ 17 ], [ 17 ], [ 17 ], [ 16, 17 ], 
#!      [ 12, 17 ], [ 17 ], [ 17 ], [ 17, 18 ] ], 
#!  [ [ 18 ], [ 18 ], [ 18 ], [ 18 ], [ 18 ], [ 18 ], [ 18 ], [ 18 ], 
#!      [ 17, 18 ], [ 13, 18 ], [ 18 ], [ 18, 19 ] ], 
#!  [ [ 19 ], [ 19 ], [ 19 ], [ 19 ], [ 19 ], [ 19 ], [ 19 ], [ 19 ], [ 19 ], 
#!      [ 18, 19 ], [ 19, 20 ], [ 19, 20 ] ], 
#!  [ [ 20 ], [ 20 ], [ 20 ], [ 20 ], [ 20 ], [ 20 ], [ 16, 20 ], [ 20 ], 
#!      [ 20 ], [ 20 ], [ 15, 20 ], [ 16, 20 ] ] ]
#! gap> Bu:=Union(Bu);
#! [ [ 1 ], [ 1, 2 ], [ 1, 5 ], [ 1, 6 ], [ 2 ], [ 2, 3 ], [ 2, 7 ], [ 3 ], 
#!  [ 3, 4 ], [ 3, 8 ], [ 4 ], [ 4, 5 ], [ 4, 9 ], [ 5 ], [ 5, 10 ], [ 6 ], 
#!  [ 6, 11 ], [ 6, 15 ], [ 7 ], [ 7, 11 ], [ 7, 12 ], [ 8 ], [ 8, 12 ], 
#!  [ 8, 13 ], [ 9 ], [ 9, 13 ], [ 9, 14 ], [ 10 ], [ 10, 14 ], [ 10, 15 ], 
#!  [ 11 ], [ 11, 16 ], [ 12 ], [ 12, 17 ], [ 13 ], [ 13, 18 ], [ 14 ], 
#!  [ 14, 19 ], [ 15 ], [ 15, 20 ], [ 16 ], [ 16, 17 ], [ 16, 20 ], [ 17 ], 
#!  [ 17, 18 ], [ 18 ], [ 18, 19 ], [ 19 ], [ 19, 20 ], [ 20 ] ]
#! gap> Bu:=Filtered(Bu, r->Size(r)=2);
#! [ [ 1, 2 ], [ 1, 5 ], [ 1, 6 ], [ 2, 3 ], [ 2, 7 ], [ 3, 4 ], [ 3, 8 ], 
#!  [ 4, 5 ], [ 4, 9 ], [ 5, 10 ], [ 6, 11 ], [ 6, 15 ], [ 7, 11 ], [ 7, 12 ], 
#!  [ 8, 12 ], [ 8, 13 ], [ 9, 13 ], [ 9, 14 ], [ 10, 14 ], [ 10, 15 ], 
#!  [ 11, 16 ], [ 12, 17 ], [ 13, 18 ], [ 14, 19 ], [ 15, 20 ], [ 16, 17 ], 
#!  [ 16, 20 ], [ 17, 18 ], [ 18, 19 ], [ 19, 20 ] ]
#! gap> Size(Bu);
#! 30
#! @EndExampleSession
#! 
#! Note, up to isomorphism there exists exactly one butterfly in the icosahedron. 
#! 
#! Assuming the butterfly containing the faces 1 and 2 has already been omitted, then 
#! the stabilizer of the butterfly [1,2] will be of greater interest. The stabilizer 
#! will identify which pairs of butterflies will construct isomorphic spheres by 
#! checking which pairs are contained in the same orbit.
#! 
#! @BeginExampleSession
#! gap> SK:=Stabilizer(GK,[1,2],OnSets);
#! Group([ (3,7)(4,11)(5,6)(8,12)(9,16)(10,15)(13,17)(14,20), (1,2)(3,5)(6,7)
#!  (8,10)(12,15)(13,14)(17,20)(18,19), (1,2)(3,6)(4,11)(5,7)(8,15)(9,16)
#!  (10,12)(13,20)(14,17)(18,19) ])
#! gap> Size(SK);
#! 4
#! @EndExampleSession
#!
#! <Alt Only="JavaScript">
#!    Ico.html
#! </Alt> 
#! 
#! How exactly can the spheres arising from exactly two butterfly deletions can be
#! determined?
#! Because of omitting the faces 1 and 2 from the icosahedron in the first step, 
#! the butterflies containing one of those faces can be ignored.
#! 
#! @BeginExampleSession
#! gap> BuSel:=Filtered(Bu,r->Intersection([1,2],r)=[]);
#! [ [ 3, 4 ], [ 3, 8 ], [ 4, 5 ], [ 4, 9 ], [ 5, 10 ], [ 6, 11 ], [ 6, 15 ], 
#!  [ 7, 11 ], [ 7, 12 ], [ 8, 12 ], [ 8, 13 ], [ 9, 13 ], [ 9, 14 ], 
#!  [ 10, 14 ], [ 10, 15 ], [ 11, 16 ], [ 12, 17 ], [ 13, 18 ], [ 14, 19 ], 
#!  [ 15, 20 ], [ 16, 17 ], [ 16, 20 ], [ 17, 18 ], [ 18, 19 ], [ 19, 20 ] ]
#! @EndExampleSession
#!
#! Among the remaining butterflies we will compute the orbits under the automorphism 
#! group to find candidates for the second butterfly for the butterfly deletion.
#!
#! @BeginExampleSession
#! gap> BeSelOr:=Orbits(SK,BuSel,OnSets);
#! [ [ [ 3, 4 ], [ 7, 11 ], [ 4, 5 ], [ 6, 11 ] ], 
#!   [ [ 3, 8 ], [ 7, 12 ], [ 5, 10 ], [ 6, 15 ] ], [ [ 4, 9 ], [ 11, 16 ] ], 
#!   [ [ 8, 12 ], [ 10, 15 ] ], [ [ 8, 13 ], [ 12, 17 ], [ 10, 14 ], [ 15, 20 ] 
#!      ], [ [ 9, 13 ], [ 16, 17 ], [ 9, 14 ], [ 16, 20 ] ], 
#!   [ [ 13, 18 ], [ 17, 18 ], [ 14, 19 ], [ 19, 20 ] ], [ [ 18, 19 ] ] ]
#! gap> List(BeSelOr,Size);
#! [ 4, 4, 2, 2, 4, 4, 4, 1 ]
#! gap> Kand:=List( BeSelOr,r->Set([Set([1,2]),r[1]]));
#! [ [ [ 1, 2 ], [ 3, 4 ] ], [ [ 1, 2 ], [ 3, 8 ] ], [ [ 1, 2 ], [ 4, 9 ] ], 
#!   [ [ 1, 2 ], [ 8, 12 ] ], [ [ 1, 2 ], [ 8, 13 ] ], [ [ 1, 2 ], [ 9, 13 ] ], 
#!   [ [ 1, 2 ], [ 13, 18 ] ], [ [ 1, 2 ], [ 18, 19 ] ] ]
#! @EndExampleSession
#!
#! Since different pairs of butterflies in the above set can still construct 
#! isomorphic spheres, we determine the orbits of the automorphism group on this set to
#! check which pairs construct isomorphic spheres.
#!
#! @BeginExampleSession
#! gap> kand:=List(Kand,r->Orbit(GK,r,OnSetsSets));;
#! gap> Size(Set(kand));
#! 8
#! gap> Size(Set(List(kand,r->Set(r))));
#! 7
#! @EndExampleSession
#!
#! So two pairs of butterflies appear in the same orbit. This can also be verified by 
#! examining the corresponding stabilizers.
#!
#! @BeginExampleSession
#! gap> Filtered(Kand, r->IsSubgroup(SK,Stabilizer(GK,r,OnSetsSets)));
#! [ [ [ 1, 2 ], [ 4, 9 ] ], [ [ 1, 2 ], [ 8, 12 ] ] ]
#! @EndExampleSession
#!
#! Compute the resulting set of pairs of butterflies
#!
#! @BeginExampleSession
#! gap> Filtered(Kand, r-> r<>[ [ 1, 2 ], [ 8, 12 ] ]);
#! [ [ [ 1, 2 ], [ 3, 4 ] ], [ [ 1, 2 ], [ 3, 8 ] ], [ [ 1, 2 ], [ 4, 9 ] ], 
#!  [ [ 1, 2 ], [ 8, 13 ] ], [ [ 1, 2 ], [ 9, 13 ] ], [ [ 1, 2 ], [ 13, 18 ] ],
#!  [ [ 1, 2 ], [ 18, 19 ] ] ]
#! gap> Kand:=last;
#! [ [ [ 1, 2 ], [ 3, 4 ] ], [ [ 1, 2 ], [ 3, 8 ] ], [ [ 1, 2 ], [ 4, 9 ] ], 
#!  [ [ 1, 2 ], [ 8, 13 ] ], [ [ 1, 2 ], [ 9, 13 ] ], [ [ 1, 2 ], [ 13, 18 ] ],
#!  [ [ 1, 2 ], [ 18, 19 ] ] ]
#! @EndExampleSession
#!
#! Now use these pairs to finally obtain the simplicial surfaces constructed 
#! from the icosahedron
#!
#! @BeginExampleSession
#! gap> Fl:=List(Kand,r->Zus(Zus(UIk,r[1,1],r[1,2]),r[2,1],r[2,2]));
#! [ [ (5,6,15,10), (7,12,8), (5,9,14,10), (6,15,20,16,11), (7,12,17,16,11), 
#!      (8,13,18,17,12), (9,14,19,18,13), (10,14,19,20,15), (16,17,18,19,20), 
#!      (5,9,13,8,7,11,6) ], 
#!  [ (5,6,15,10), (4,9,14,10,5), (6,15,20,16,11), (7,12,17,16,11), 
#!      (12,13,18,17), (9,14,19,18,13), (10,14,19,20,15), (16,17,18,19,20), 
#!      (4,5,6,11,7), (4,9,13,12,7) ], 
#!  [ (5,6,15,10), (3,7,12,8), (6,15,20,16,11), (7,12,17,16,11), 
#!      (8,13,18,17,12), (13,14,19,18), (10,14,19,20,15), (16,17,18,19,20), 
#!      (3,5,6,11,7), (3,5,10,14,13,8) ], 
#!  [ (5,6,15,10), (3,7,12), (4,9,14,10,5), (6,15,20,16,11), (7,12,17,16,11), 
#!      (9,14,19,18), (10,14,19,20,15), (16,17,18,19,20), (3,4,5,6,11,7), 
#!      (3,12,17,18,9,4) ], 
#!  [ (5,6,15,10), (3,7,12,8), (4,14,10,5), (6,15,20,16,11), (7,12,17,16,11), 
#!      (8,18,17,12), (10,14,19,20,15), (16,17,18,19,20), (3,4,5,6,11,7), 
#!      (3,4,14,19,18,8) ], 
#!  [ (5,6,15,10), (3,7,12,8), (3,8,9,4), (4,9,14,10,5), (6,15,20,16,11), 
#!      (7,12,17,16,11), (10,14,19,20,15), (16,17,19,20), (3,4,5,6,11,7), 
#!      (8,9,14,19,17,12) ], 
#!  [ (5,6,15,10), (3,7,12,8), (3,8,13,9,4), (4,9,14,10,5), (6,15,20,16,11), 
#!      (7,12,17,16,11), (8,13,17,12), (10,14,20,15), (3,4,5,6,11,7), 
#!      (9,13,17,16,20,14) ] ]
#! gap> List(Fl,r->Collected(List(r,Order)));
#! [ [ [ 3, 1 ], [ 4, 2 ], [ 5, 6 ], [ 7, 1 ] ], [ [ 4, 2 ], [ 5, 8 ] ], 
#!  [ [ 4, 3 ], [ 5, 6 ], [ 6, 1 ] ], 
#!  [ [ 3, 1 ], [ 4, 2 ], [ 5, 5 ], [ 6, 2 ] ], 
#!  [ [ 4, 4 ], [ 5, 4 ], [ 6, 2 ] ], [ [ 4, 4 ], [ 5, 4 ], [ 6, 2 ] ], 
#!  [ [ 4, 4 ], [ 5, 4 ], [ 6, 2 ] ] ]
#! gap> VerCou:=last;;
#! @EndExampleSession
#!
#! Those pairs can also be identified by computing the distances of the faces contained 
#! in a pair of butterlfies.
#! 
#! @BeginExampleSession
#! gap> List(Kand, r->List(r[1],i->List(r[2],j->DistanceOfFaces(Ik,i,j))));
#! [ [ [ 2, 2 ], [ 1, 2 ] ], [ [ 2, 3 ], [ 1, 2 ] ], [ [ 2, 3 ], [ 2, 3 ] ], 
#!  [ [ 3, 4 ], [ 2, 3 ] ], [ [ 3, 4 ], [ 3, 3 ] ], [ [ 4, 5 ], [ 3, 4 ] ], 
#!  [ [ 5, 4 ], [ 4, 5 ] ] ]
#! @EndExampleSession
#!
#! This identification can be simplified by computing the distances of the faces of
#! the butterflies to the face 1.
#!
#! @BeginExampleSession
#! gap> Collected(List([1..20],i->DistanceOfFaces(Ik,1,i)));
#! [ [ 0, 1 ], [ 1, 3 ], [ 2, 6 ], [ 3, 6 ], [ 4, 3 ], [ 5, 1 ] ]
#! @EndExampleSession




 

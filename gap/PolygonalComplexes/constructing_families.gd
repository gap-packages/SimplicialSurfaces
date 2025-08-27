#! @Chapter Generating certain simplicial surfaces
#! @ChapterLabel Generating

#! This chapter introduces methods to find all simplicial surfaces with certain
#! restrictions. 
#! 

#! @Section Essential discs
#! @SectionLabel Discs_Essential

#! This section contains the methods to compute all essential simplicial discs.

#! @BeginGroup IsEssentialDisc
#! @Description
#! This function returns true if  <A>disc</A> is an essential disc and false else. A
#! simplicial surface
#! <A>disc</A> is called an <E>essential disc</E> if <A>disc</A> is a connected
#! simplicial surfaces of Euler characteristic 1  and every circular
#! vertex-edge path of length 3 bounds a face of <A>disc</A>, and every
#! boundary vertex has degree at least <A>2</A> and and no inner edge joins
#! two boundary vertices.
#!
#! @BeginExampleSession
#! gap> disc := SimplicialSurfaceByDownwardIncidence(
#! >  [ [ 1, 3 ], [ 1, 2 ], [ 2, 3 ], [ 3, 4 ], [ 1, 4 ], [ 1, 5 ], [ 1, 6 ],
#! >    [ 2, 6 ], [ 2, 7 ], [ 3, 7 ], [ 4, 7 ], [ 4, 8 ], [ 4, 5 ], [ 5, 6 ],
#! >    [ 6, 7 ], [ 7, 8 ], [ 5, 8 ] ],
#! >  [ [ 1, 2, 3 ], [ 1, 4, 5 ], [ 6, 7, 14 ], [ 2, 7, 8 ], [ 8, 9, 15 ],
#! >    [ 3, 9, 10 ], [ 4, 10, 11 ], [ 11, 12, 16 ], [ 12, 13, 17 ],
#! >    [ 5, 6, 13 ] ] );
#! simplicial surface (8 vertices, 17 edges, and 10 faces)
#! gap> IsConnectedSurface(disc);
#! true
#! gap> EulerCharacteristic(disc);
#! 1
#! gap> CounterOfVertices(disc);
#! counter of vertices ([ 2, 3, 4, 5 ] degrees, and [ 1, 2, 3, 2 ] multiplicities)
#! gap> IsEssentialDisc(disc);
#! true
#! @EndExampleSession
#! @Arguments disc
#! @Returns true or false
DeclareOperation( "IsEssentialDisc", [IsTwistedPolygonalComplex] );
#! @EndGroup

#! @BeginGroup AllSimplicialSurfacesByEssentialButterflyInsertion
#! @Description
#! This function computes representatives of the isomorphism classes of
#! all simplicial surfaces that can be obtained from
#! the input surface <A>surf</A> by an essential butterfly insertion.
#! An essential butterfly insertion is a butterfly insertion that does not
#! create a 3-waist.
#!
#! @BeginLogSession
#! gap> surface := SimplicialSurfaceByDownwardIncidence(
#! > [ [ 1, 3 ], [ 1, 2 ], [ 2, 3 ], [ 3, 4 ], [ 1, 4 ], [ 1, 5 ], [ 1, 6 ],
#! > [ 2, 6 ], [ 2, 7 ], [ 3, 7 ], [ 3, 8 ], [ 4, 8 ], [ 4, 5 ],  [ 5, 6 ],
#! > [ 6, 7 ], [ 7, 8 ], [ 5, 8 ] ],
#! > [ [1, 2, 3], [1, 4, 5], [6, 7, 14], [2, 7, 8], [8, 9, 15],
#! > [3, 9, 10], [10, 11, 16], [4, 11, 12], [12, 13, 17], [5, 6, 13] ]);
#! simplicial surface (8 vertices, 17 edges, and 10 faces)
#! gap> IsConnectedSurface(surface);
#! true
#! gap> EulerCharacteristic(surface);
#! 1
#! gap> AllSimplicialSurfacesByEssentialButterflyInsertion(surface);
#! [ simplicial surface (9 vertices, 20 edges, and 12 faces),
#! simplicial surface (9 vertices, 20 edges, and 12 faces)
#!     , simplicial surface (9 vertices, 20 edges, and 12 faces), 
#!  simplicial surface (9 vertices, 20 edges, and 12 faces) ]
#! @EndLogSession
#! @Arguments surface
#! @Returns a list of simplicial surfaces
DeclareOperation( "AllSimplicialSurfacesByEssentialButterflyInsertion", [IsSimplicialSurface] );
#! @EndGroup



#! @Section Edge-Face equivalent simplicial surfaces
#! @SectionLabel Edge_Face_Equivalent

#! This section contains method to compute edge-face equivalent simplicial surfaces.
#! Two simplicial surfaces are called edge-face equivalent if their face-graphs are isomorphic.

#! @BeginGroup AllSimplicialSurfacesOfDigraph 
#! @Description 
#! Return all (vertex-faithful) simplicial surfaces, that have <K>digraph</K> as face graph. 
#! If <K>digraph</K> is not a face graph of a (vertex-faithful) simplicial surface, the empty list is returned.
#! The parameter <K>vertexfaithful</K> indicates whether only vertex-faithful simplicial surfaces are searched. 
#! The parameter <K>vertexfaithful</K> is by default false.
#! <K>digraph</K> must be a cubic, connected, symmetric and simple digraph. The vertices of a simplicial 
#! surface can be identified with certain cycles in the face graph. This method searches possible combinations of cycles, 
#! with the cycles corresponding to the vertices of a simplicial surface.
#!
#!
#! For example, consider the complete graph on four nodes:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FaceGraphTetra-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FaceGraphTetra.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!
#! @BeginLogSession
#! gap> digraph:=CompleteDigraph(4);;
#! gap> tet1 := AllSimplicialSurfacesOfDigraph(digraph,true);
#! [ simplicial surface (4 vertices, 6 edges, and 4 faces) ]
#! gap> IsIsomorphic(tet1[1],Tetrahedron());
#! true
#! @EndLogSession
#! So the only vertex-faithful simplicial surface of the digraph is the tetrahedron. 
#! But there is another simplicial surface, which is not vertex-faithful:
#! @BeginLogSession
#! gap> list := AllSimplicialSurfacesOfDigraph(digraph,false);
#! [ simplicial surface (4 vertices, 6 edges, and 4 faces), 
#! simplicial surface (3 vertices, 6 edges, and 4 faces)]
#! gap> tet2 := Filtered(list,IsVertexFaithful);
#! [ simplicial surface (4 vertices, 6 edges, and 4 faces) ]
#! gap> IsIsomorphic(tet2[1],Tetrahedron());
#! true
#! @EndLogSession
#!
#! Since it takes a long time to compute all cycles, you should only call the method for digraphs with twelve or less nodes for <K>vertexfaithful</K> false.
#! For <K>vertexfaithful</K> true, the method needs to consider only chordless and non-separating cycles. This makes the method fast for digraphs up to 28 nodes.
#! In general, it is much faster to only look for vertex-faithful simplicial surfaces.
#! 
#! @Arguments digraph[, vertexfaithful]
#! @Returns a list
DeclareOperation( "AllSimplicialSurfacesOfDigraph", [IsDigraph, IsBool]);
#! @EndGroup

#! @BeginGroup Reembedding
#! @Description
#! The method <K>ReembeddingsOfSimplicialSphere</K> computes all edge-face equivalent simplicial surfaces
#! of the given vertex-faithful simplicial sphere <K>surf</K> with the given genus <K>g</K> if these
#! simplicial surfaces are orientable or not is given by <K>oriented</K>. Note that two simplicial surfaces are edge-face equivalent
#! if the corresponding face graphs are isomorphic (see <Ref Subsect="FaceGraph"/> for a definition of the face graph).
#! The method <K>ReembeddingsOfDigraph</K> computes for a 3-connected cubic planar graph all simplicial surfaces with the
#! given genus <K>g</K> and if these simplicial surfaces are orientable or not is given by <K>oriented</K> that
#! have <K>digraph</K> as their face graph. We call this a re-embedding of a digraph or a simplicial sphere.
#! If <K>surf</K> is not a vertex-faithful simplicial sphere or <K>digraph</K> is not planar and cubic, an error is printed.
#! It is not checked whether <K>digraph</K> is a 3-connected graph.
#!
#! Note that, non-orientable surfaces of genus one are projective planes, orientable surfaces of genus one are tori
#! and non-orientable surfaces of genus two are Klein bottles.
#!
#! For example, consider the complete graph on four vertices:
#! @BeginLogSession
#! gap> digraph:=CompleteDigraph(4);;
#! gap> ReembeddingsOfDigraph(digraph,1,false);
#! [ simplicial surface (3 vertices, 6 edges, and 4 faces) ]
#! gap> ReembeddingsOfDigraph(digraph,1,true);
#! [ ]
#! gap> ReembeddingsOfDigraph(digraph,2,false);
#! [ ]
#! @EndLogSession
#! So the complete graph on four vertices has exactly one re-embedding on a projective plane but no
#! re-embedding on the torus or the Klein bottle. Note that the complete graph on four vertices is the face graph
#! of the tetrahedron.
#! The octahedron has for example no edge-face equivalent projective plane but three edge-face equivalent tori
#! and two edge-face equivalent Klein bottles.
#! @BeginLogSession
#! gap> oct:=Octahedron();;
#! gap> ReembeddingsOfSimplicialSphere(Octahedron(),1,false);
#! [ ]
#! gap> ReembeddingsOfSimplicialSphere(Octahedron(),1,true);
#! [ simplicial surface (4 vertices, 12 edges, and 8 faces), 
#!   simplicial surface (4 vertices, 12 edges, and 8 faces),
#!   simplicial surface (4 vertices, 12 edges, and 8 faces) ]
#! gap> ReembeddingsOfSimplicialSphere(Octahedron(),2,false);
#! [ simplicial surface (4 vertices, 12 edges, and 8 faces),
#!   simplicial surface (4 vertices, 12 edges, and 8 faces) ]
#! @EndLogSession
#! 
#! @Arguments digraph, g, oriented
#! @Returns a list
DeclareOperation( "ReembeddingsOfDigraph", [IsDigraph, IsInt, IsBool]);
#! @Arguments  surf, g, oriented
#! @Returns a list
DeclareOperation( "ReembeddingsOfSimplicialSphere", [IsSimplicialSurface, IsInt, IsBool]);
#! @EndGroup
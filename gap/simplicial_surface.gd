##############################################################################
##
#W  simplicial_surface.gd     SimplicialSurfaces             Alice Niemeyer
#W							Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Alice Niemeyer, Markus Baumeister, 
#Y  Lehrstuhl B für Mathematik, RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the declaration part for the simplicial surfaces
##	of the SimplicialSurfaces package.
##

#!
#!	@Chapter Simplicial Surfaces
#!
#! A SimplicialSurface-object in GAP represents mathematical objects that are
#! a generalization of simplicial surfaces. On the most basic level it
#! consists of vertices, edges and faces, together with an incidence relation
#! between them. This information is saved in the following form:
#! * the vertices are represented by a set of positive integers
#! * the edges are represented by a set of positive integers
#! * the faces are represented by a set of positive integers
#! * the incidence relation between vertices and edges (that is, which
#!   vertices lie in which edges) is represented by a list VerticesOfEdges.
#!   For each edge e the entry VerticesOfEdges[e] is a set of all vertices
#!   that are incident to the edge e.
#! * the incidence relation between edges and faces (that is, which
#!   edges lie in which faces) is represented by a list EdgesOfFaces. For
#!   each face f the entry EdgesOfFaces[f] is a set of all edges that are
#!   incident to the face f.
#!
#! Every other incidence (like VerticesOfFaces or EdgesOfVertices) is 
#! represented in an analogous fashion.
#!
#! Furthermore we impose some restrictions onto these incidence relations:
#! * Every edge is incident to exactly two vertices
#! * Every face is incident to the same number of vertices and edges (at least
#!   three). Additionally these are cyclically oriented (to represent an 
#!   n-gon)
#! * The incidence relations are transitive
#! * Every vertex and every edge is incident to at least one face
#!
#! Note that it is allowed for an edge to be incident to more than two faces.
#!
#!  
#! In addition it is sometimes necessary to distinguish between the two
#! sides of a single face. If this is irrelevant to your application, you
#! can completely ignore this (it will be handled in the background).
#! To use this distinction each side of a face f gets a name - the defaults
#! are +f and -f (but you can give them custom names if you want to). To 
#! distinguish which side is which (not only by a name, but geometrically)
#! we save a cyclic ordering of the vertices (or edges) of each face which
#! we associate with the side +f. (In an embedding to $\mathbb{R}^3$ we could
#! associate the cyclic ordering with the normal vector of the face that is
#! defined by the right-hand-rule from physics.)


DeclareInfoClass( "InfoSimplicial" );
SetInfoLevel(InfoSimplicial,1);
# TODO explain structure of everything in a separate tex-file

#TODO remove LocalOrientation from simplicial surfaces (separate incidence 
# geometry and orientation). Then add CyclicVertexOrderAsPerm or something
# like that. Does this work in the bigger context??

##
##	Categories are used to determine which methods are applicable for a
##	certain object. The category for simplicial surfaces should be able to
##	save attributes once they are computed (this includes properties) and
##	consists of components.
##
DeclareCategory( "IsSimplicialSurface",
			IsComponentObjectRep and IsAttributeStoringRep );

##
##	Define a new family for simplicial surfaces. The family defines a necessary
##	condition that has to be fulfilled for objects to be equal to each other.
##	The argument IsSimplicialSurface guarantees that only objects that lie in
##	this category can be part of the family.
##
BindGlobal( "SimplicialSurfaceFamily", 
    NewFamily("SimplicialSurfaceFamily",  IsObject, IsSimplicialSurface) );




#############################################################################
##
##
#!  @Section Constructors for Simplicial Surfaces
#!
#!
#!


#! @Description
#! Return a simplicial surface that represents a tetrahedron.
#! @Returns a simplicial surface
DeclareOperation( "Tetrahedron", [] );

#! @Description
#! Return a simplicial surface that represents a cube
#! @Returns a simplicial surface
DeclareOperation( "Cube", [] );

#! @Description
#! Return a simplicial surface that represents a octahedron.
#! @Returns a simplicial surface
DeclareOperation( "Octahedron", [] );

#! @Description
#! Return a simplicial surface that represents a dodecahedron.
#! @Returns a simplicial surface
DeclareOperation( "Dodecahedron", [] );

#! @Description
#! Return a simplicial surface that represents a icosahedron.
#! @Returns a simplicial surface
DeclareOperation( "Icosahedron", [] );


#! @BeginGroup
#! @Description
#! This constructor of a simplicial surface uses the following information:
#! * The set of vertices (alternatively a positive integer n, which will be
#!   interpreted as the set [1..n])
#! * The set of edges (alternatively a positive integer n, which will be
#!   interpreted as the set [1..n])
#! * The set of faces (alternatively a positive integer n, which will be
#!   interpreted as the set [1..n])
#! * The list edgesOfVertices. For each vertex v the entry edgesOfVertices[v]
#!   is a set of all edges that are incident to the vertex v.
#! * The list facesOfEdges. For each edge e the entry facesOfEdges[e]
#!   is a set of all faces that are incident to the edge e.
#!
#! In this constructor there is no way of distinguishing the sides of each
#! face, so this selection will be made randomly.
#!
#! The NC-version does not check whether the given input follows the following
#! criteria:
#! * vertices, edges and faces have to be either positive integers or sets of
#!   positive integers.
#! * For each vertex v the entry edgesOfVertices[v] has to be a subset of the
#!   set of edges.
#! * Every edge has to be in one of the sets in the list edgesOfVertices.
#! * For each edge e the entry facesOfEdges[e] has to be a subset of the set
#!   of faces.
#! * Each face has to be in one of the sets in the list facesOfEdges.
#!
#! @Arguments vertices, edges, faces, edgesOfVertices, facesOfEdges
#! @Returns a simplicial surface
DeclareOperation( "SimplicialSurfaceByUpwardIncidence",
	[ IsSet, IsSet, IsSet, IsList, IsList ] );
#! @Arguments vertices, edges, faces, edgesOfVertices, facesOfEdges
DeclareOperation( "SimplicialSurfaceByUpwardIncidenceNC",
	[ IsSet, IsSet, IsSet, IsList, IsList ] );
#! @EndGroup


#! @BeginGroup
#! @Description
#! This constructor of a simplicial surface uses the following information:
#! * The set of vertices (alternatively a positive integer n, which will be
#!   interpreted as the set [1..n])
#! * The set of edges (alternatively a positive integer n, which will be
#!   interpreted as the set [1..n])
#! * The set of faces (alternatively a positive integer n, which will be
#!   interpreted as the set [1..n])
#! * The list verticesOfEdges. For each edge e the entry verticesOfEdges[e]
#!   is a set of all vertices that are incident to the edge e.
#! * The list edgesOfFaces. For each face f the entry edgesOfFaces[f]
#!   is a set of all edges that are incident to the face f.
#!
#! This constructor does not distinguish different sides of each face, so this
#! selection will be made randomly.
#!
#! The NC-version does not check whether the given input follows the following
#! criteria:
#! * vertices, edges and faces have to be either positive integers or sets of
#!   positive integers.
#! * For each edge e the entry verticesOfEdges[e] has to be a subset of the
#!   set of vertices.
#! * Every vertex has to be in one of the sets in the list verticesOfEdges.
#! * For each face f the entry edgesOfFaces[f] has to be a subset of the set
#!   of edges.
#! * Each edge has to be in one of the sets in the list edgesOfFaces.
#!
#! @Returns a simplicial surface
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces
DeclareOperation( "SimplicialSurfaceByDownwardIncidence",
	[ IsSet, IsSet, IsSet, IsList, IsList ] );
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces
DeclareOperation( "SimplicialSurfaceByDownwardIncidenceNC",
	[ IsSet, IsSet, IsSet, IsList, IsList ] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! This constructor of a simplicial surface uses the following information:
#! * The set of vertices (alternatively a positive integer n, which will be
#!   interpreted as the set [1..n])
#! * The set of edges (alternatively a positive integer n, which will be
#!   interpreted as the set [1..n])
#! * The set of faces (alternatively a positive integer n, which will be
#!   interpreted as the set [1..n])
#! * The list verticesOfEdges. For each edge e the entry verticesOfEdges[e]
#!   is a set of all vertices that are incident to the edge e.
#! * The list edgesOfFaces. For each face f the entry edgesOfFaces[f]
#!   is a list of all edges that are incident to the face f. This list has to
#!   have the property that two adjacent edges in this list (where we count the
#!   first and the last entry to be adjacent) have one vertex in common (this
#!   is always the case if the face is a triangle).
#! * The optional argument namesOfFaces. This is a list and for each face f
#!   it has an entry namesOfFaces[f] that is a list with exactly two elements.
#!   The first element will be the name of the primary side of the face, the
#!   second element will be the name of the secondary side of the face. If this
#!   argument is not given, the default naming scheme (+f for primary and -f
#!   for secondary) is used.
#!
#! The ordering of the edges in the list edgesOfFaces defines which side of the
#! the simplicial surface will consider as primary.
#!
#! The NC-version does not check whether the given input follows the following
#! criteria:
#! * vertices, edges and faces have to be either positive integers or sets of
#!   positive integers.
#! * For each edge e the entry verticesOfEdges[e] has to be a subset of the
#!   set of vertices.
#! * Every vertex has to be in one of the sets in the list verticesOfEdges.
#! * For each face f the entry edgesOfFaces[f] has to be a subset of the set
#!   of edges.
#! * Each edge has to be in one of the sets in the list edgesOfFaces.
#! * The edge lists in the components of edgesOfFaces conform to the adjacency
#!   condition from before.
#! * For each face f the list namesOfFaces[f] has exactly two elements that are
#!   both integers.
#!
#! @Returns a simplicial surface
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces[, namesOfFaces]
DeclareOperation( "SimplicialSurfaceByDownwardIncidenceWithOrientation",
	[ IsSet, IsSet, IsSet, IsList, IsList ] );
#! @Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces[, namesOfFaces]
DeclareOperation( "SimplicialSurfaceByDownwardIncidenceWithOrientationNC",
	[ IsSet, IsSet, IsSet, IsList, IsList ] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! This constructor of a simplicial surface uses the following information:
#! * The set of vertices (alternatively a positive integer n, which will be
#!   interpreted as the set [1..n])
#! * The set of faces (alternatively a positive integer n, which will be
#!   interpreted as the set [1..n])
#! * The list verticesOfFaces. For each face f the entry verticesOfFaces[f]
#!   is a set of all vertices that are incident to the face f.
#! * The optional argument namesOfFaces. This is a list and for each face f
#!   it has an entry namesOfFaces[f] that is a list with exactly two elements.
#!   The first element will be the name of the primary side of the face, the
#!   second element will be the name of the secondary side of the face. If this
#!   argument is not given, the default naming scheme (+f for primary and -f
#!   for secondary) is used.
#!
#! We assume that two vertices that are adjacent in a list verticesOfFaces[f]
#! (where the first and the last entry are adjacent) will have an edge between
#! them. These edges will be constructed automatically.
#!
#! This constructor does not distinguish different sides of each face, so this
#! selection will be made randomly.
#!
#! The NC-version does not check whether the given input follows the following
#! criteria:
#! * vertices and faces have to be either positive integers or sets of
#!   positive integers.
#! * For each face f the entry verticesOfFaces[f] has to be a subset of the set
#!   of vertices.
#! * For each face f the list verticesOfFaces[f] has to contain at least three
#!   different vertices.
#! * For each face f the list namesOfFaces[f] has exactly two elements that are
#!   both integers.
#!
#! @Arguments vertices, faces, verticesOfFaces[, namesOfFaces]
#! @Returns a simplicial surface
DeclareOperation( "SimplicialSurfaceByVerticesInFaces", 
	[ IsSet, IsSet, IsList ] );
#! @Arguments vertices, faces, verticesOfFaces[, namesOfFaces]
DeclareOperation( "SimplicialSurfaceByVerticesInFacesNC", 
	[ IsSet, IsSet, IsList ] );
#TODO also allow IsList as only argument
#TODO after the split with constructor SimplicialSurfaceBy.. write an error message that recommends the more general constructor.
#! @EndGroup


#############################################################################
##
##
#!  @Section Access to the incidence structure
#!
#!

#! @BeginGroup
##	The double declaration has the following reason: In grape there is a method
##	Vertices that collides with our usage.

#! @Description
#! Returns the vertices as a set. The vertices are positive integers.
#! @Arguments simpSurf
#! @Returns the set of vertices, a set of positive integers
DeclareOperation( "Vertices", [IsSimplicialSurface] );
#! @Arguments simpSurf
DeclareAttribute( "VerticesAttributeOfSimplicialSurface", IsSimplicialSurface );
#! @EndGroup

#! @Description
#! Returns the edges as a set. The edges are positive integers.
#! @Arguments simpSurf
#! @Returns the set of edges, a set of positive integers
DeclareAttribute( "Edges", IsSimplicialSurface );

#! @Description
#! Returns the faces as a set. The faces are positive integers.
#! @Arguments simpSurf
#! @Returns the set of faces, a set of positive integers
DeclareAttribute( "Faces", IsSimplicialSurface );


#! @Description
#! Returns the number of vertices.
#! @Arguments simpSurf
#! @Returns a non-negative integer
DeclareAttribute( "NrOfVertices", IsSimplicialSurface );

#! @Description
#! Returns the number of edges.
#! @Arguments simpSurf
#! @Returns a non-negative integer
DeclareAttribute( "NrOfEdges", IsSimplicialSurface );

#! @Description
#! Returns the number of faces.
#! @Arguments simpSurf
#! @Returns a non-negative integer
DeclareAttribute( "NrOfFaces", IsSimplicialSurface );


#! @Description
#! Return a list edgesOfVertices such that
#! * if v is a vertex then edgesOfVertices[v] is the set of all edges that are
#!   incident to v.
#! * if v is not a vertex then edgesOfVertices[v] is not bound.
#!
#! @Arguments simpSurf
#! @Returns a list of sets of positive integers
DeclareAttribute( "EdgesOfVertices", IsSimplicialSurface );

#! @Description
#! Return a list facesOfVertices such that
#! * if v is a vertex then facesOfVertices[v] is the set of all faces that are
#!   incident to v.
#! * if v is not a vertex then facesOfVertices[v] is not bound.
#!
#! @Arguments simpSurf
#! @Returns a list of sets of positive integers
DeclareAttribute( "FacesOfVertices", IsSimplicialSurface);

#! @Description
#! Return a list verticesOfEdges such that
#! * if e is an edge then verticesOfEdges[e] is the set of all vertices that are
#!   incident to e.
#! * if e is not an edge then verticesOfEdges[e] is not bound.
#!
#! @Arguments simpSurf
#! @Returns a list of sets of positive integers
DeclareAttribute( "VerticesOfEdges", IsSimplicialSurface);

#! @Description
#! Return a list facesOfEdges such that
#! * if e is an edge then facesOfEdges[e] is the set of all faces that are
#!   incident to e.
#! * if e is not an edge then facesOfEdges[e] is not bound.
#!
#! @Arguments simpSurf
#! @Returns a list of sets of positive integers
DeclareAttribute( "FacesOfEdges", IsSimplicialSurface);

#! @Description
#! Return a list verticesOfFaces such that
#! * if f is a face then verticesOfFaces[f] is the set of all vertices that are
#!   incident to v.
#! * if f is not a face then verticesOfFaces[f] is not bound.
#!
#! @Arguments simpSurf
#! @Returns a list of sets of positive integers
DeclareAttribute( "VerticesOfFaces", IsSimplicialSurface);

#! @Description
#! Return a list edgesOfFaces such that
#! * if f is a face then edgesOfFaces[f] is the set of all edges that are
#!   incident to v.
#! * if f is not a face then edgesOfFaces[f] is not bound.
#!
#! @Arguments simpSurf
#! @Returns a list of sets of positive integers
DeclareAttribute( "EdgesOfFaces", IsSimplicialSurface);


#! @Description
#! Return the edge of the given face that is incident to the given vertices.
#! @Arguments simpSurf, face, vertexList
#! @Returns the edge
DeclareOperation( "EdgeInFaceByVertices", 
        [IsSimplicialSurface, IsPosInt, IsList] );



#############################################################################
##
##
#!  @Section Basic properties of simplicial surfaces
#!
#!

#!  @Description
#!  Return the Euler characteristic of the given simplicial surface.
#!  The Euler characteristic is $|V| - |E| + |F|$, where $|V|$ is the number of
#!  vertices, $|E|$ is the number of edges and $|F|$ is the number of faces.
#!  @Returns an integer, the Euler characteristic.
#!  @Arguments simpSurf
DeclareAttribute( "EulerCharacteristic", IsSimplicialSurface );

#! @Description
#! The property IsTriangleSurface is true if all faces of the simplicial
#! surface are triangles (i.e. they consist of three edges).
#! @Arguments simpSurf
DeclareProperty( "IsTriangleSurface", IsSimplicialSurface );


#TODO write chapter (or section) to explain connectivity

#! @Description
#! If the simplicial surface is path connected (i.e. if every two faces are
#! connected by a face-edge-path) this method returns true, otherwise false.
#! @Arguments simpSurf
DeclareProperty( "IsPathConnected", IsSimplicialSurface );
#TODO This property is also known as StronglyConnected -> change or allow both?


#! @BeginGroup
#! @Description
#! Return a list of all path-connected components of the simplicial surface.
#! <P/>
#! If a face is given additionally the path-connected component of this face is
#! returned. The NC-version does not check if the given face actually lies
#! in the simplicial surface.
#! @Arguments simpSurf
#! @Returns a list of simplicial surfaces
DeclareAttribute( "PathConnectedComponents", IsSimplicialSurface );
#! @Arguments simpSurf, face
DeclareOperation( "PathConnectedComponentOfFace", [IsSimplicialSurface, IsPosInt] );
#! @Arguments simpSurf, face
DeclareOperation( "PathConnectedComponentOfFaceNC", [IsSimplicialSurface, IsPosInt] );
#! @EndGroup



#! @Description
#! Return if a simplicial surface is connected. If two faces share at least one
#! vertex they are considered to be connected.
#! @Arguments simpSurf
DeclareProperty( "IsConnected", IsSimplicialSurface );
InstallTrueMethod( IsConnected, IsPathConnected );

#! @BeginGroup
#! @Description
#! Return a list of all connected components of the simplicial surface.
#! <P/>
#! If a face is given additionally the connected component of this face is
#! returned. The NC-version does not check if the given face actually lies
#! in the simplicial surface.
#! @Arguments simpSurf
#! @Returns a list of simplicial surfaces
DeclareAttribute( "ConnectedComponentsAttributeOfSimplicialSurface", 
		IsSimplicialSurface );
#DeclareOperation( "ConnectedComponents", [IsSimplicialSurface] );
#TODO uncomment as soon as situation with GRAPE is resolved

#! @Arguments simpSurf, face
DeclareOperation( "ConnectedComponentOfFace", [IsSimplicialSurface, IsPosInt] );
#! @Arguments simpSurf, face
DeclareOperation( "ConnectedComponentOfFaceNC", [IsSimplicialSurface, IsPosInt] );
#! @EndGroup


#! @Description
#! Return a list unsortedDegrees with the following property:
#! For each vertex v the entry unsortedDegrees[v] contains the number
#! of faces that are incident to that vertex (this is called the degree
#! of the vertex).
#! @Arguments simpSurf
#! @Returns a list of positive integers
DeclareAttribute( "UnsortedDegrees", IsSimplicialSurface );

#! @Description
#! Return a sorted list sortedDegrees such that the degree of each vertex
#! (which is defined as the number of incident faces) is contained in the
#! list (counting repetitions).
#! @Arguments simpSurf
#! @Returns a sorted list of positive integers
DeclareAttribute( "SortedDegrees", IsSimplicialSurface );

#! @Description
#! Return the vertex counter of a simplicial surface.
#! The vertex counter is defined as a list vertexSym, where vertexSym[i]
#! counts the number of vertices that are incident to exactly i edges. If there
#! are no vertices with i incident edges, this entry is unbounded.
#! @Arguments simpSurf
#! @Returns a list of positive integers
DeclareAttribute( "VertexCounter", IsSimplicialSurface );

#!
#!  @Description
#!  Return the edge counter of a simplicial surface. The edge counter is a
#!  symmetric matrix M such that M[i,j] counts the number of edges such that
#!  the two vertices of the edge have edge-degrees i and j.
#!  @Arguments simpSurf
#!  @Returns a matrix of integers
DeclareAttribute( "EdgeCounter", IsSimplicialSurface );

#! @Description
#! Return the face-anomaly-classes of a simplicial surface.
#! <P/>
#! Two faces are in the same face-anomaly-class if they contain the same
#! vertices.
#! @Returns The face-anomaly-classes (as a list of sets)
#! @Arguments  simpSurf
DeclareAttribute( "FaceAnomalyClasses", IsSimplicialSurface );

#! @Description
#! Return the edge-anomaly-classes of a simplicial surface (two edges are in
#! the same edge-anomaly-class if they contain the same vertices).
#! @Returns The edge-anomaly-classes (as a list of sets)
#! @Arguments simpSurf
DeclareAttribute( "EdgeAnomalyClasses", IsSimplicialSurface ); 

#! @Description
#! Return whether the simplicial surface contains no anomalies (of faces or
#! edges). This property is also known as vertex faithful. A simplicial
#! surface is vertex faithful if all face and edge anomaly classes are trivial.
#! @Returns true or false
#! @Arguments simpSurf
DeclareProperty( "IsAnomalyFree", IsSimplicialSurface );
#
DeclareSynonym( "IsVertexFaithful", IsAnomalyFree );

#! @Description
#! Return the coloured incidence graph of a simplicial surface.
#! * The vertex set of this graph consists of all vertices, edges and faces
#!   of the simplicial surface. All vertices, all edges and all faces
#!   are in individual colour classes.
#! * The edges are given by vertex-edge and edge-face pairs.
#! @Returns the coloured incidence graph
#! @Arguments  simpSurf
DeclareAttribute( "IncidenceGraph", IsSimplicialSurface );


#############################################################################
##
##
#!  @Section Functions for simplicial surfaces
#!
#!


#! @BeginGroup
#! @Description
#! Return the subsurface of a simplicial surface that is defined by the given
#! set of faces.
#! <P/>
#! The NC-version does not check if the given faces actually are faces of the
#! simplicial surface.
#! @Arguments simpSurf, faces
#! @Returns a simplicial surface
DeclareOperation( "SubsurfaceByFaces", [IsSimplicialSurface, IsSet] );
#! @Arguments simpSurf, faces
DeclareOperation( "SubsurfaceByFacesNC", [IsSimplicialSurface, IsSet] );
#! @EndGroup


#! @BeginGroup
#! @Description
#! Remove all ears of the simplicial surface and return the resulting surface.
#! An ear is a face that has at most two vertices in common with all other
#! faces.
#! <P/>
#! The recursive-version applies this method recursively until the resulting
#! simplicial surface has no more ears.
#! @Returns a simplicial surface
#! @Arguments simpSurf
DeclareOperation( "SnippOffEars", [IsSimplicialSurface] );
#! @Arguments simpSurf
DeclareOperation( "SnippOffEarsRecursive", [IsSimplicialSurface] );
#! @EndGroup


#! @Description
#! Check if two simplicial surfaces are isomorphic. This method only checks
#! if they are isomorphic with respect to the incidence relation. It does
#! not check if additional structure like a wild coloring is isomorphic (or
#! even present).
#! @Arguments s1, s2
#! @Returns true or false
DeclareOperation( "IsIsomorphic", [IsSimplicialSurface, IsSimplicialSurface] );
#TODO change name to IsIsomorphicSimplicialSurfaces? To distinguish it from
# IsIsomorphicWildSimplicialSurfaces. Or is there a better way?


#! @Description
#! Add a vertex into an edge. This only works if there are exactly two
#! faces adjacent to the edge.
#! @Arguments simpSurf, edge
#! @Returns the modified simplicial surface
DeclareOperation( "AddVertexIntoEdge", [IsSimplicialSurface, IsPosInt] );





#############################################################################
##
##
#!  @Section Advanced properties of simplicial surfaces
#!
#!
#! Since the SimplicialSurface-objects in GAP can represent more general
#! structures than just surfaces there is a property that checks whether a
#! generic SimplicialSurface-objects represents an actual surface (the property
#! IsActualSurface).
#!
#! To check whether a generic SimplicialSurface-object represents an actual
#! surface we have to check the edges and the vertices.
#! * In an actual surface every edge is incident to at most two faces. This
#!   property is checked by IsEdgesLikeSurface.
#! * If each edge is incident to at most two faces, we can define
#!   face-edge-paths around each vertex. A face-edge-path around a vertex $v$
#!   is a list $(e_1,f_1,e_2,f_2,\dots,e_n,f_n)$ or 
#!   $(e_1,f_1,e_2,f_2,\dots,e_n,f_n,e_{n+1})$ such that
#!   - all $e_i$ are pairwise distinct edges incident to the vertex $v$
#!   - all $f_i$ are pairwise distinct faces incident to the vertex $v$
#!   - if two elements are adjacent in a face-edge-path, they are incident in
#!     the simplicial surface
#!   - if the face-edge-path has even length (the first case), we require that
#!     $e_1$ and $f_n$ are incident (this represents a closed path)
#!   - if the face-edge-path has odd length (the second case), we require that
#!     both $e_1$ and $e_{n+1}$ are only incident to one face (this represents
#!     an open path)
#!
#TODO why does this list structure not work? Can be fixed by using HTML-lists
# Start with <List>, end with </List> and use <Item> and </Item> to delineate the items
#!   In general there may be many of those paths around a vertex (they 
#!   partition the edges and faces incident to each vertex) but in an actual
#!   surface there is only one such path. The property IsVerticesLikeSurface
#!   checks this property.
#!

#! @Description
#! Under the assumption that every edge is incident to at most two faces (which
#! allows the definition of face-edge-paths) the property IsVerticesLikeSurface
#! holds if there is only one face-edge-path (up to description) around each
#! vertex.
#! @Arguments simpSurf
DeclareProperty( "IsVerticesLikeSurface", IsSimplicialSurface );

#! @Description
#! The property IsEdgesLikeSurface holds if every edge of the simplicial
#! surface is incident to at most two faces.
#! @Arguments simpSurf
DeclareProperty( "IsEdgesLikeSurface", IsSimplicialSurface );


#TODO AutoDoc can't handle synonyms at the moment.
#TODO Should this be renamed? Maybe to "IsSurface"?
DeclareSynonym( "IsActualSurface", 
		IsVerticesLikeSurface and IsEdgesLikeSurface );
InstallTrueMethod( IsPathConnected, IsConnected and IsActualSurface );
                
#! @Description
#!  The property IsActualSurface is true if both IsEdgesLikeSurface and
#!  IsVerticesLikeSurface are true.
#! @Arguments simpSurf


#! @Description
#! If we have a simplicial surface where every edge is incident to at most two
#! faces, this method checks if the surface is closed. (A simplicial surface
#! is closed if every edge is incident to exactly two faces.)
#! @Arguments simpSurf
DeclareProperty( "IsClosedSurface", 
			IsSimplicialSurface and IsEdgesLikeSurface );

#! @BeginGroup
#! @Description
#! Return a list fep with the following conditions:
#! * for each vertex v the entry fep[v] contains a list of all face-edge-paths
#!   of this vertex. If there are several possible ways to describe a
#!   face-edge-path we choose the representative where the first face is
#!   minimal among all faces in the path. If this is not unique we choose
#!   the edge between the first and second face to be minimal among all 
#!   remaining choices.
#! * every other entry of fep is not bounded.
#!
#! If a vertex is given additionally, return only a list of face-edge-paths
#! around this vertex. The NC-version does not check whether the given vertex
#! actually is a vertex of the simplicial surface.
#! @Arguments simpSurf
#! @Returns a list of lists of face-edge-paths
DeclareAttribute( "FaceEdgePathsOfVertices", 
		IsSimplicialSurface and IsEdgesLikeSurface );
#! @Arguments simpSurf, vertex
DeclareOperation( "FaceEdgePathsOfVertex", 
		[IsSimplicialSurface and IsEdgesLikeSurface, IsPosInt] );
#! @Arguments simpSurf, vertex
DeclareOperation( "FaceEdgePathsOfVertexNC", 
		[IsSimplicialSurface and IsEdgesLikeSurface, IsPosInt] );
#! @EndGroup


#############################################################################
##
##
#!  @Section Local and global orientations
#!
#! If we consider an embedding of a simplicial surface, each face gets mapped
#! onto a polygon (usually a triangle). For each such polygon there are exactly
#! two normal vectors that define the two "sides" of the polygon. Via the
#! right-hand-rule from physics we can identify each normal vector with a
#! cyclic permutation of the vertices in the polygon. For example, if a given
#! face is incident to the vertices $\{1,2,3\}$, then the possible cyclic
#! permutations are (1,2,3) and (1,3,2). If the polygon has more than three
#! vertices then adjacent vertices in these permutations have to be connected
#! by an edge.
#! <P/>
#! The same construction can be used to derive a cyclic permutation of the
#! incident edges. In addition it is sometimes useful to encode these
#! permutations as lists, for example the permutation (1,2,3) corresponds to
#! the list [1,2,3] (the first entry has to be the smallest one to make this
#! choice of list unique).
#! <P/>
#! A **local orientation** of a given face can now be described in four
#! equivalent ways:
#! * ByVerticesAsPerm
#!   <P/>
#!   This is a cyclic permutation p of all vertices incident to the face such
#!   that v and p(v) are incident to an edge of the face (for each vertex v
#!   in the face).
#! * ByVerticesAsList
#!   <P/>
#!   This is a list of all vertices indicent to the face that encodes the
#!   permutation of **ByVerticesAsPerm**. The first entry is the smallest
#!   vertex among those incident to the face.
#! * ByEdgesAsPerm
#!   <P/>
#!   This is a cyclic permutation p of all edges incident to the face such
#!   that e and p(e) are incident to an edge of the face (for each edge e
#!   in the face).
#! * ByEdgesAsList
#!   <P/>
#!   This is a list of all edges indicent to the face that encodes the
#!   permutation of **ByEdgesAsPerm**. The first entry is the smallest
#!   edge among those incident to the face.
#! 
#! A standard local orientation is used to distinguish the different sides for
#! each face. There is no necessary connection between local orientations of
#! different faces. It is possible to give the sides different names. If
#! no special measures are taken, the side that is distinguished by the standard
#! local orientation is known as f, whereas the other side is known as -f.
#! <P/>
#! <P/>
#! If the simplicial surface is orientable (which is only well-defined if the 
#! property IsEdgesLikeSurface is true), we can assign a global orientation.
#! More specifically there are $2^c$ different global orientations, where $c$
#! denotes the number of path-connected components of the simplicial surface
#! (two faces are path-connected if there exists a face-edge-path between them
#! that is not necessarily incident to only one vertex).
#! <P/>
#! To return a unique global orientation we pick the smallest face in each
#! path-connected component and assign the standard local orientation to
#! this face.
#! <P/>
#! To describe the distinguished global orientation we have the same options
#! as in the local case.
#!

#! @BeginGroup
#! @Description
#! Return a list localOr with the following properties:
#! * For each face f the entry localOr[f] consists of a cycle with all vertices
#!   that are incident to f. Adjacent vertices have an edge of the face in
#!   common.
#! * All other positions are not bounded.
#! 
#! This is the default interpretation for the method LocalOrientation.
#! @Returns a list of permutations
#! @Arguments simpSurf
DeclareAttribute( "LocalOrientationByVerticesAsPerm", IsSimplicialSurface );
#! @Arguments simpSurf
DeclareOperation( "LocalOrientation", [IsSimplicialSurface] );
#! @EndGroup

#! @Description
#! Return a list localOr with the following properties:
#! * For each face f the entry localOr[f] consists of a list with all vertices
#!   that are incident to f. Adjacent vertices have an edge of the face in
#!   common.
#! * All other positions are not bounded.
#! @Returns a list of lists
#! @Arguments simpSurf
DeclareAttribute( "LocalOrientationByVerticesAsList", IsSimplicialSurface );

#! @Description
#! Return a list localOr with the following properties:
#! * For each face f the entry localOr[f] consists of a cycle with all edges
#!   that are incident to f. Adjacent edges have an vertex of the face in
#!   common.
#! * All other positions are not bounded.
#! @Returns a list of permutations
#! @Arguments simpSurf
DeclareAttribute( "LocalOrientationByEdgesAsPerm", IsSimplicialSurface );

#! @Description
#! Return a list localOr with the following properties:
#! * For each face f the entry localOr[f] consists of a list with all edges
#!   that are incident to f. Adjacent edges have an vertex of the face in
#!   common.
#! * All other positions are not bounded.
#! @Returns a list of permutations
#! @Arguments simpSurf
DeclareAttribute( "LocalOrientationByEdgesAsList", IsSimplicialSurface );


#! @BeginGroup
#! @Description
#! Return alist names with the following properties:
#! * For each face f the entry names[f] is a list of two integers. The first
#!   integer is the name of the upper face-side, the second one is the name
#!   of the lower face-side (with respect to the local orientation).
#! * all other entries are unbounded.
#! 
#! If a face is given in addition, the corresponding entry of this list is
#! returned. The NC-version does not throw an error if a non-face is given.
#! @Returns a list of lists of integers
#! @Arguments simpSurf
DeclareAttribute( "NamesOfFaces", IsSimplicialSurface );
#! @Arguments simpSurf, face
DeclareOperation( "NamesOfFace", [IsSimplicialSurface, IsPosInt] );
#! @Arguments simpSurf, face
DeclareOperation( "NamesOfFaceNC", [IsSimplicialSurface, IsPosInt] );
#! @EndGroup


#! @Description
#! Return the face of the simplicial surface that has the given name
#! as the name of one of its sides.
#! @Arguments simpSurf, name
#! @Returns a positive integer
DeclareOperation( "FaceByName", [IsSimplicialSurface, IsInt] );


#! @Description
#! Return whether the naming scheme for the faces is the default one,
#! meaning that the upper side of a face f is called f (a positive integer) and
#! the lower side -f (a negative integer).
#! @Arguments simpSurf
DeclareProperty( "IsFaceNamesDefault", IsSimplicialSurface );


#! @Description
#! If we have a simplicial surface where every edge is incident to at most two
#! faces, this method checks if the surface is orientable. (A simplicial surface
#! is orientable if we can assign a side for each face such that for every two
#! adjacent sides either both or none are assigned.
#! @Arguments simpSurf
DeclareProperty( "IsOrientable", IsSimplicialSurface and IsEdgesLikeSurface );


#! @BeginGroup
#! @Description
#! Return the distinguished global orientation if the simplicial surface is 
#! orientable. Warning: The returned orientation depends on the chosen local
#! orientation of the simplicial surface. This might not be equal even if the
#! incidence structure is.
#! <P/>
#! The orientation is returned as a list globalOr. For each face f the entry
#! globalOr[f] contains a cycle of the vertices that are incident in the face f.
#! The order of this cycle corresponds to the orientation of the face f with
#! respect to the global orientability.
#! <P/>
#! This method returns fail if the given surface is not orientable.
#!
#! @Arguments simpSurf
#! @Returns a list of permutations or fail
DeclareAttribute( "GlobalOrientationByVerticesAsPerm", 
    IsSimplicialSurface and IsEdgesLikeSurface );
#! @Arguments simpSurf
DeclareOperation( "GlobalOrientation",
    [ IsSimplicialSurface and IsEdgesLikeSurface ] );
#! @EndGroup

#! @Description
#! Return the distinguished global orientation if the simplicial surface is 
#! orientable. Warning: The returned orientation depends on the chosen local
#! orientation of the simplicial surface. This might not be equal even if the
#! incidence structure is.
#! <P/>
#! The orientation is returned as a list globalOr. For each face f the entry
#! globalOr[f] contains a list of the vertices that are incident in the face f.
#! The order of this list corresponds to the orientation of the face f with
#! respect to the global orientability.
#! <P/>
#! This method returns fail if the given surface is not orientable.
#!
#! @Arguments simpSurf
#! @Returns a list of lists or fail
DeclareAttribute( "GlobalOrientationByVerticesAsList", 
    IsSimplicialSurface and IsEdgesLikeSurface );

#! @Description
#! Return the distinguished global orientation if the simplicial surface is 
#! orientable. Warning: The returned orientation depends on the chosen local
#! orientation of the simplicial surface. This might not be equal even if the
#! incidence structure is.
#! <P/>
#! The orientation is returned as a list globalOr. For each face f the entry
#! globalOr[f] contains a cycle of the edges that are incident in the face f.
#! The order of this cycle corresponds to the orientation of the face f with
#! respect to the global orientability.
#! <P/>
#! This method returns fail if the given surface is not orientable.
#!
#! @Arguments simpSurf
#! @Returns a list of permutations or fail
DeclareAttribute( "GlobalOrientationByEdgesAsPerm", 
    IsSimplicialSurface and IsEdgesLikeSurface );

#! @Description
#! Return the distinguished global orientation if the simplicial surface is 
#! orientable. Warning: The returned orientation depends on the chosen local
#! orientation of the simplicial surface. This might not be equal even if the
#! incidence structure is.
#! <P/>
#! The orientation is returned as a list globalOr. For each face f the entry
#! globalOr[f] contains a list of the edges that are incident in the face f.
#! The order of this list corresponds to the orientation of the face f with
#! respect to the global orientability.
#! <P/>
#! This method returns fail if the given surface is not orientable.
#!
#! @Arguments simpSurf
#! @Returns a list of lists or fail
DeclareAttribute( "GlobalOrientationByEdgesAsList", 
    IsSimplicialSurface and IsEdgesLikeSurface );


###############################################################################
##
##
#!  @Section Technical functions (for development)
#!
#! This section contains methods that concern the internal structure of
#! simplicial surfaces. You only have to read this section if you want to
#! understand the underlying implementation better or if you want to develop
#! code that is derived from this.
#!
#! There are three unique features in the implementation of simplicial surfaces
#! that especially concern the definition of specializes simplicial surfaces:
#! - The use of a method selection graph
#! - A general methods to help defining specialized classes
#! - A guide for easier initialization
#!
#! Since the method selection graph is the most salient feature we will cover
#! it first. It derives from a simple observation: If you know either
#! VerticesOfEdges or EdgesOfVertices, you can calculate the other. If you 
#! additionally know either of EdgesOfFaces or FacesOfEdges, you can calculate
#! all six of these attributes. This could have been implemented by a lot of
#! specialized methods but the number of these methods rised exponentially
#! with the number of attributes that are connected.
#!
#! Instead we only implement methods for the ``difficult'' parts (where work
#! has to be done) and delegate the ``easy'' parts (if we can calculate B from
#! A and C from B, we can also calculate C from A) into a method selection
#! graph. If an attribute should be part of the method selection graph (which
#! it only should if you can calculate information inside the method selection
#! graph from this attribute) you have to make two modifications:
#! - There has to be a method to calculate this attribute by the method
#!   selection graph, like
#! @BeginCode TODO Including code does not work if it is read normally
#! InstallMethod( VerticesOfFaces, "for a simplicial surface", 
#!    [ IsSimplicialSurface ],
#!    function( surf )
#!        return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
#!                VerticesOfFaces, surf);
#!    end
#! );
#! @EndCode
#! - For each ``difficult'' method there has to be a call that adds this 
#!   possibility into the method selection graph, like
#! @BeginCode
#! AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
#!	"VerticesOfFaces", ["EdgesOfFaces", "VerticesOfEdges"] );
#! @EndCode
#!
#! 
#! Secondly we guarantee unique methods for specialization. To consider a 
#! specific example, imagine we want to give certain simplicial surfaces an
#! edge colouring. If one simplicial surface may have different edge colourings
#! we can't implement this as an attribute of the simplicial surface. Instead
#! we define a new type for this situation (as a subtype of 
#! SimplicialSurfaceType).
#!
#! The disadvantage of this procedure is that is becomes harder to take a
#! simplicial surface as input and add an edge colouring (type changes are
#! frowned upon in GAP). For this reason we offer a special method that does
#! just that - it copies many attributes of the simplicial surface into an
#! object of the new type.

#! @Description
#! This function calls
#! @BeginCode
#! Objectify( type, rec )
#! @EndCode
#! and afterwards copies all attributes and properties of the simplicial
#! surface modelSurf that are declared in this section to the the new object.
#!	
#! This method has to be overwritten for a specialization of this class.
#!
#! WARNING: The type can't be checked! Only types that are derived from
#! IsSimplicialSurface can be used with impunity!
#!
#! @Arguments type, record, simpSurf
#! @Returns an object of type type
DeclareOperation( "ObjectifySimplicialSurface",
		[IsType,IsRecord,IsSimplicialSurface]);



#! Finally we consider the constructors. Simplicial surfaces are defined by
#! an incidence structure **and** a local orientation (with face names).
#! However, only the incidence structure has to be given - the local
#! orientation can be derived (in the sense that there are several possibilites
#! and one of them will be picked). To facilitate this procedure we offer a
#! method which can be called **after** the incidence structure is defined.

#! @BeginGroup
#! @Description
#! This is a method which should only be used in code development. It should
#! not be called by a normal user as it presupposes knowledge of the internal
#! attribute storing system.
#!
#! A simplicial surface consists of two separate sets of attributes: One set
#! of attributes to save the incidence geometry (Vertices, Edges, Faces,
#! EdgesOfFaces, etc.), the other to save the local orientation of the faces
#! (LocalOrientationOfVerticesAsPerm, NamesOfFaces, etc.). While the second
#! set of attributes may be crucial for some applications (like folding), it
#! is easy to ignore it in other applications.
#! 
#! This is usually managed by a judicious constructor call that will handle
#! the necessary overhead without burdening the user. If - for whatever 
#! reason - no constructor should be called (for example for a subcategory
#! of IsSimplicialSurface) this method can be used to initialize all necessary
#! attributes of the second set.
#! 
#! This method will throw an error if some of these attributes are already set.
#! It will only check the attributes
#! - LocalOrientationByVerticesAsPerm
#! - LocalOrientationByVerticesAsList
#! - LocalOrientationByEdgesAsPerm
#! - LocalOrientationByEdgesAsList
#! - IsFaceNamesDefault
#! - NamesOfFaces
#! If other attributes interfere with these, they will not be checked! For
#! this reason this method should only be called if one knows exactly which
#! attributes are already set.
#!
#! The NC-version doesn't check whether attributes are set (it is therefore
#! even more dangerous to use).
#!
#! @Arguments simpSurf
#! @Returns nothing
DeclareOperation( "DeriveLocalOrientationAndFaceNamesFromIncidenceGeometry",
	[IsSimplicialSurface] );
DeclareOperation( "DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC",
	[IsSimplicialSurface] );
#! @EndGroup


#! @Description
#! Return the string that is printed by the PrintObj-method. This method is
#! used since it may be expensive to compute the string.
#! @Arguments simpSurf
#! @Returns a string
DeclareAttribute( "PrintStringAttributeOfSimplicialSurface", 
		IsSimplicialSurface );

#
###  This program is free software: you can redistribute it and/or modify
###  it under the terms of the GNU General Public License as published by
###  the Free Software Foundation, either version 3 of the License, or
###  (at your option) any later version.
###
###  This program is distributed in the hope that it will be useful,
###  but WITHOUT ANY WARRANTY; without even the implied warranty of
###  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
###  GNU General Public License for more details.
###
###  You should have received a copy of the GNU General Public License
###  along with this program.  If not, see <http://www.gnu.org/licenses/>.
###

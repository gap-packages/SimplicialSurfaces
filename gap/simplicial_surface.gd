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


#! @Description
#! Return if a simplicial surface is connected. If two faces share at least one
#! vertex they are considered to be connected.
#! @Arguments simpSurf
DeclareProperty( "IsConnected", IsSimplicialSurface );

#! @BeginGroup
#! @Description
#! Return a list of all connected components of the simplicial surface.
#! @Arguments simpSurf
#! @Returns a list of simplicial surfaces
DeclareAttribute( "ConnectedComponentsAttributeOfSimplicialSurface", 
		IsSimplicialSurface );
#DeclareOperation( "ConnectedComponents", [IsSimplicialSurface] );
#TODO uncomment as soon as situation with GRAPE is resolved

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
#! Return the vertex symbol of a simplicial surface.
#! The vertex symbol is defined as a list vertexSym, where vertexSym[i]
#! counts the number of vertices that are incident to exactly i edges. If there
#! are no vertices with i incident edges, this entry is unbounded.
#! @Arguments simpSurf
#! @Returns a list of positive integers
DeclareAttribute( "VertexSymbol", IsSimplicialSurface );




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
DeclareSynonym( "IsActualSurface", 
		IsVerticesLikeSurface and IsEdgesLikeSurface );
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


#! @Description
#! Return a list fep with the following conditions:
#! * for each vertex v the entry fep[v] contains a list of all face-edge-paths
#!   of this vertex. If there are several possible ways to describe a
#!   face-edge-path we choose the representative where the first face is
#!   minimal among all faces in the path. If this is not unique we choose
#!   the edge between the first and second face to be minimal among all 
#!   remaining choices.
#! * every other entry of fep is not bounded.
#! @Arguments simpSurf
#! @Returns a list of lists of face-edge-paths
DeclareAttribute( "FaceEdgePathsOfVertices", 
		IsSimplicialSurface and IsEdgesLikeSurface );
#! @BeginGroup
#! @Description
#! Return a list of all face-edge-paths around a given vertex.
#! <P/>
#! The NC-version does not check whether the vertex lies in the simplicial
#! surface.
#! @Arguments simpSurf, vertex
#! @Returns a list of face-edge-paths
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
#TODO write methods for path-connected components
#! <P/>
#! To return a unique global orientation we pick the smallest face in each
#! path-connected component and assign the standard local orientation to
#! this face.
#! <P/>
#! To describe the distinguished global orientation we have the same options
#! as in the local case.
#!

#! @Description
#! If we have a simplicial surface where every edge is incident to at most two
#! faces, this method checks if the surface is orientable. (A simplicial surface
#! is orientable if we can assign a side for each face such that for every two
#! adjacent sides either both or none are assigned.
#! @Arguments simpSurf
DeclareProperty( "IsOrientable", IsSimplicialSurface and IsEdgesLikeSurface );


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
DeclareAttribute( "GlobalOrientationByVertices", 
    IsSimplicialSurface and IsEdgesLikeSurface );

#!  @Description
#!	Return a list of permutations where at the position of each face-number
#!	there is a cycle of all vertices that are incident to this face. This
#!	cycle represents the local orientation of this face. All other positions
#!	are unbounded.
#!	Either this method or LocalOrientationByEdges is basic
#!  @Returns a list of permutations
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "LocalOrientationByVerticesAsPerm", IsSimplicialSurface );
DeclareOperation( "LocalOrientation", [IsSimplicialSurface] );


#!  @Description
#!	Return a list of lists where at the position of each face-number
#!	there is a list of all vertices that are incident to this face. This
#!	list represents the local orientation of this face. All other positions
#!	are unbounded.
#!	Either this method or LocalOrientationByEdges is basic
#!  @Returns a list of lists
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "LocalOrientationByVerticesAsList", 
		IsSimplicialSurface );


#!  @Description
#!	Return a list of permutations where at the position of each face-number
#!	there is a cycle of all edges that are incident to this face. This
#!	cycle represents the local orientation of this face. All other positions
#!	are unbounded.
#!	Either this method or LocalOrientationByVertices is basic
#!  @Returns a list of permutations
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "LocalOrientationByEdgesAsPerm", 
		IsSimplicialSurface );


#!  @Description
#!	Return a list of lists where at the position of each face-number
#!	there is a list of all edges that are incident to this face. This
#!	list represents the local orientation of this face. All other positions
#!	are unbounded.
#!	Either this method or LocalOrientationByEdges is basic
#!  @Returns a list of lists
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "LocalOrientationByEdgesAsList", 
		IsSimplicialSurface );


#!  @Description
#!	Return a list of tuples where at each face-number there is a list with two
#!	entries. The first one is the name of the upper face-side, the second one
#!	the name of the lower face-side (with respect to the local orientation).
#!	All other positions are unbounded.
#!	If IsFaceNamesDefault is false, this method is basic.
#!  @Returns a list of lists of integers
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "NamesOfFaces", 
		IsSimplicialSurface );

#!	@Description
#!	Return if the naming scheme for the faces is the default one, meaning
#!	that the upper side of a face f is called f (a positive integer) and the
#!	lower side -f (a negative integer).
#!	@Returns true if the simplicial surface follows the default naming scheme,
#!	false otherwise
#!	@Arguments a simplicial surface object simpsurf
DeclareProperty( "IsFaceNamesDefault", IsSimplicialSurface );


#!  @Description
#!  Return the face-anomaly-classes of a simplicial surface.
#!	Two faces are in the same face-anomaly-class if they contain the same
#!	vertices.
#!  @Returns The face-anomaly-classes (as a list of sets)
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "FaceAnomalyClasses", 
		IsSimplicialSurface );


#!  @Description
#!  Return the coloured incidence graph of a simplicial surface.
#!	The vertex set of this graph consists of all vertices, edges and faces
#!	of the simplicial surface. All vertices, all edges and all faces
#!	are in individual colour classes.
#!	The edges are given by vertex-edge and edge-face pairs.
#!  @Returns the coloured incidence graph
#!  @Arguments a simplicial surface object simpsurf
DeclareAttribute( "IncidenceGraph", 
		IsSimplicialSurface );


#!	@Description
#!	Return a string that contains a command to reconstruct this simplicial
#!	surface. It is primarily used in the PrintObj-method.
#!	@Arguments a simplicial surface
#!	@Returns a string
DeclareAttribute( "PrintStringAttributeOfSimplicialSurface", 
		IsSimplicialSurface );


#############################################################################
##
##
#!  @Section Functions for Simplicial Surfaces
#!
#!
#!


##
#!	@Description
#!	This function calls
#!		Objectify( type, rec )
#!	and afterwards copies all attributes and properties of the simplicial
#!	surface modelSurf that are declared in this section to the the new object.
#!	This method has to be overwritten for a specialization of this class.
#!
#!	WARNING: The type can't be checked! Only types that are derived from
#!	IsSimplicialSurface can be used with impunity!
#!
#!	@Arguments a type, a record, a simplicial surface
#!	@Returns an object of type type
DeclareOperation( "ObjectifySimplicialSurface",
		[IsType,IsRecord,IsSimplicialSurface]);


##
#!	@Description
#!	This is a method which should only be used in code development. It should
#!	not be called by a normal user as it presupposes knowledge of the internal
#!	attribute storing system.
#!
#!	A simplicial surface consists of two separate sets of attributes: One set
#!	of attributes to save the incidence geometry (Vertices, Edges, Faces,
#!	EdgesOfFaces, etc.), the other to save the local orientation of the faces
#!	(LocalOrientationOfVerticesAsPerm, NamesOfFaces, etc.). While the second
#!	set of attributes may be crucial for some applications (like folding), it
#!	is easy to ignore it in other applications.
#!	This is usually managed by a judicious constructor call that will handle
#!	the necessary overhead without burdening the user. If - for whatever 
#!	reason - no constructor should be called (for example for a subcategory
#!	of IsSimplicialSurface) this method can be used to initialize all necessary
#!	attributes of the second set.
#! 
#!	This method will throw an error if some of these attributes are already set.
#!	It will only check the attributes
#!		- LocalOrientationByVerticesAsPerm
#!		- LocalOrientationByVerticesAsList
#!		- LocalOrientationByEdgesAsPerm
#!		- LocalOrientationByEdgesAsList
#!		- IsFaceNamesDefault
#!		- NamesOfFaces
#!	If other attributes interfere with these, they will not be checked! For
#!	this reason this method should only be called if one knows exactly which
#!	attributes are already set.
#!
#!	The NC-version doesn't check whether attributes are set (it is therefore
#!	even more dangerous to use).
#!
#!	@Arguments a simplicial surface
#!	@Returns nothing
DeclareOperation( "DeriveLocalOrientationAndFacesNamesFromIncidenceGeometry",
	[IsSimplicialSurface] );
DeclareOperation( "DeriveLocalOrientationAndFacesNamesFromIncidenceGeometryNC",
	[IsSimplicialSurface] );

##
#!	@Description
#!	This function returns both names of the given face. The first entry is
#!	the name of the upper side, the second one of the lower side.
#!	The NC-version doesn't check if the given number actually is a face.
#!	@Arguments a simplicial surface object simpsurf, a face number
#!	@Returns a list with two elements
#!
DeclareOperation( "NamesOfFace", [IsSimplicialSurface, IsPosInt] );
DeclareOperation( "NamesOfFaceNC", [IsSimplicialSurface, IsPosInt] );


##
#!	@Description
#!	Return the face-number of the simplicial surface that has the given name
#!	as the name of one of its sides.
#!	@Arguments a simplicial surface object simpsurf, an integer
#!	@Returns a positive integer
#!
DeclareOperation( "FaceByName", [IsSimplicialSurface, IsInt] );


##
#!	@Description
#!	This function returns the simplicial subsurface that is defined by the
#!	given set of faces.
#!	The NC-version does not check if the given faces actually are faces of
#!	the simplicial surface.
#!	@Arguments a simplicial surface object simpsurf, a set of positive integers
#!	@Returns a simplicial surface object
#!
DeclareOperation( "SubsurfaceByFaces", [IsSimplicialSurface, IsSet] );
DeclareOperation( "SubsurfaceByFacesNC", [IsSimplicialSurface, IsSet] );


##
#!	@Description
#!	This function removes all ears of the simplicial surface and returns
#!	the resulting surface.
#!	@Arguments a simplicial surface object simpsurf
#!	@Returns a simplicial surface object
#!
DeclareOperation( "SnippOffEars", [IsSimplicialSurface] );

##
#!	@Description
#!	This function removes all ears of the simplicial surface. If the resulting
#!	surface still has ears, it removes them as well (and so on). The final
#!	surface is returned..
#!	@Arguments a simplicial surface object simpsurf
#!	@Returns a simplicial surface object
#!
DeclareOperation( "SnippOffEarsRecursive", [IsSimplicialSurface] );

##
#!	@Description
#!	This function returns the connected component of the given face.
#!	The NC-version doesn't check if the given face actually is one.
#!	@Arguments a simplicial surface object simpsurf, a positive integer
#!	@Returns a simplicial surface object
#!
DeclareOperation( "ConnectedComponentOfFace", [IsSimplicialSurface, IsPosInt] );
DeclareOperation( "ConnectedComponentOfFaceNC", [IsSimplicialSurface, IsPosInt] );

##
#!  @Description
#!  Check if two simplicial surfaces are isomorphic. This method only checks
#!	if they are isomorphic with respect to the incidence relation. It does
#!	not check if additional structure like a wild coloring is isomorphic (or
#!	even present).
#!  @Arguments two simplicial surface objects s1 and s2
#!  @Returns true or false
#!
DeclareOperation( "IsIsomorphic", [IsSimplicialSurface, IsSimplicialSurface] );



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

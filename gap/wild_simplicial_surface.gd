# @DoNotReadRestOfFile

##############################################################################
##
#W  wild_simplicial_surface.gd     SimplicialSurfaces     Alice Niemeyer
#W														Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Alice Niemeyer, Markus Baumeister, 
#Y  Lehrstuhl B für Mathematik, RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the declaration part for the wild simplicial surfaces
##	of the SimplicialSurfaces package.
##
##	TODO description of wild coloured simplicial surfaces
##
##  There are several ways of inputting a wild coloured simplicial surface.
##
##  A wild coloured simplicial surface is created by the function 
##  WildSimplicialSurface and is a GAP object. Simplicial surfaces can be 
##  obtained as follows:
##
##  1) Given a triple gens of involutions, the function
##     AllWildSimplicialSurfaces(gens)  computes  all wild coloured simplicial 
##     surfaces whose faces are the moved points of the generators and whose
##     edges are determined by the 2-cycles of the generators.
##  2) Input a surface by first listing the faces, 
##     then pairs of faces making up the edges, 
##     then the face-paths for  each vertex.  A face-path is simply
##     a list of the faces in the order in which they occur around a vertex.
##     The function WildSimplicialSurfacesFromFacePath takes this input
##     and returns all wild coloured simplicial surfaces matching the
##     description
##  3) Input a wild coloured surface by the following data structure, 
##     called the *generic-surface* data structure. The generic-surface
##     data structure is the most general data structure to describe
##     surfaces and is not restricted to wild coloured surfaces only.
##     The generic-surface data structure is a list of
##      the number of vertices, edges and faces
##      then pairs of vertices making up the edges, 
##      then triples of edges making up the faces, e.g.
##      ( |V|, |E|, |F|, [ [v1,v2],...],  [[e1,e2,e3],... ] )
##       here ei is a number, which is a position in the list of edges,
##       so that the list of vertex pairs can be indexed by ei to find
##       the two vertex numbers of edges ei.
##     
##
##
##    As GAP objects, certain general methods are installed for 
##    simplicial surface objects, such as Print and Display and "=".
##
##    The mr-type of a wild coloured simplicial surface simpsurf
##    can be determined with the function MrTypeOfWildSimplicialSurface.
##
##    As Simplicial surfaces are GAP objects, they cannot be 
##    accessed like records.
##
##    An action of a permutation on a simplicial surface is installed, 
##    allowing us to compute the orbits of a group acting on a set of
##    simplicial surfaces.
##    
##


#TODO DoubleCover, SixfoldCover, CommonCover

#!	@Chapter Wild Simplicial Surfaces

##
##	Wild simplicial surfaces are simplicial surfaces that have additional
##	structure. Since not every simplicial surface admits a unique wild 
##	colouring, we don't define it as an attribute but rather as a separate
##	object (which is encoded as a category).
##
DeclareCategory( "IsWildSimplicialSurface", IsSimplicialSurface and
									 IsActualSurface and IsTriangleSurface );


#############################################################################
##
##
#!	  @Section Constructors for wild simplicial surfaces
#!
#!
#!

##
#!	@Description
#!	This is a constructor for a wild simplicial surface based on the following
#!	information:
#!
#!	- vertices	A set of vertices (a positive integer n may represent [1..n])
#!	- edges		A set of edges (a positive integer n may represent [1..n])
#!	- faces		A set of faces (a positive integer n may represent [1..n])
#!	- verticesOfEdges	A list of sets, where a set of two vertices is given
#!						for each edge
#!	- edgesOfFaces		A list of sets, where a set of three edges is given
#!						for each face
#!	- coloursOfEdges	A list that contains the numbers 1,2,3. For each edge
#!						the colour of this edge is given. There have to be an
#!						equal amount of edges for each colour and the edges of
#!						each face have to have different colours.
#!
#!	The NC-version doesn't check whether the given information is consistent.
#!
#!	@Arguments vertices, edges, faces, verticesOfEdges, edgesOfFaces,
#!		coloursOfEdges
#!	@Returns a wild simplicial surface
#!
DeclareOperation( "WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring",
	[ IsSet, IsSet, IsSet, IsList, IsList, IsList] );
DeclareOperation( "WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouringNC",
	[ IsSet, IsSet, IsSet, IsList, IsList, IsList] );

##
#!	@Description
#!	This is a constructor for a wild simplicial surface based on the following
#!	information:
#!
#!	- vertices	A set of vertices (a positive integer n may represent [1..n])
#!	- edges		A set of edges (a positive integer n may represent [1..n])
#!	- faces		A set of faces (a positive integer n may represent [1..n])
#!	- verticesOfEdges	A list of sets, where a set of two vertices is given
#!						for each edge
#!	- edgesOfFaces		A list of sets, where a set of three edges is given
#!						for each face
#!	- generators		A list of three involutions whose cycles define the
#!						edge colouring. If this is not unique (that is, if there
#!						is are two edges that are incident to the same two 
#!						faces, then an error is thrown).
#!
#!	The NC-version doesn't check whether the given information is consistent.
#!
DeclareOperation( "WildSimplicialSurfaceByDownwardIncidenceAndGenerators",
	[ IsSet, IsSet, IsSet, IsList, IsList, IsList] );
DeclareOperation( "WildSimplicialSurfaceByDownwardIncidenceAndGeneratorsNC",
	[ IsSet, IsSet, IsSet, IsList, IsList, IsList] );

##
#!	@Description
#!	This is a constructor for a wild simplicial surface based on the following
#!	information:
#!
#!	- surface	A simplicial surface which consists only of triangles and is an
#!				actual surface.
#!	- coloursOfEdges	A list that contains the numbers 1,2,3. For each edge
#!						the colour of this edge is given. There have to be an
#!						equal amount of edges for each colour and the edges of
#!						each face have to have different colours.
#!
#!	The NC-version doesn't check whether the given information is consistent.
#!
DeclareOperation( "WildSimplicialSurfaceExtensionByEdgeColouring",
	[ IsSimplicialSurface and IsActualSurface and IsTriangleSurface, IsList ] );
DeclareOperation( "WildSimplicialSurfaceExtensionByEdgeColouringNC",
	[ IsSimplicialSurface and IsActualSurface and IsTriangleSurface, IsList ] );

##
#!	@Description
#!	This is a constructor for a wild simplicial surface based on the following
#!	information:
#!
#!	- surface	A simplicial surface which consists only of triangles and is an
#!				actual surface.
#!	- generators		A list of three involutions whose cycles define the
#!						edge colouring. If this is not unique (that is, if there
#!						is are two edges that are incident to the same two 
#!						faces, then an error is thrown).
#!
#!	The NC-version doesn't check whether the given information is consistent.
#!
DeclareOperation( "WildSimplicialSurfaceExtensionByGenerators",
	[ IsSimplicialSurface and IsActualSurface and IsTriangleSurface, IsList ] );
DeclareOperation( "WildSimplicialSurfaceExtensionByGeneratorsNC",
	[ IsSimplicialSurface and IsActualSurface and IsTriangleSurface, IsList ] );


##
#!	@Description
#!	This is a constructor for a wild simplicial surface based on the following
#!	information:
#!
#!	- vertices	A set of vertices (a positive integer n may represent [1..n])
#!	- edges		A set of edges (a positive integer n may represent [1..n])
#!	- faces		A set of faces (a positive integer n may represent [1..n])
#!	- faceEdgePaths		A list of the face-edge-paths for each vertex.
#!	- coloursOfEdges	A list that contains the numbers 1,2,3. For each edge
#!						the colour of this edge is given. There have to be an
#!						equal amount of edges for each colour and the edges of
#!						each face have to have different colours.
#!
#!	The NC-version doesn't check whether the given information is consistent.
#!
DeclareOperation( "WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring",
	[ IsSet, IsSet, IsSet, IsList, IsList ] );
DeclareOperation( "WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouringNC",
	[ IsSet, IsSet, IsSet, IsList, IsList ] );

##
#!	@Description
#!	This is a constructor for a wild simplicial surface based on the following
#!	information (the edges will be constructed internally):
#!
#!	- vertices	A set of vertices (a positive integer n may represent [1..n])
#!	- faces		A set of faces (a positive integer n may represent [1..n])
#!	- colfaceEdgePaths		A list of the coloured face-edge-paths for each 
#!							vertex.
#!
#!	The NC-version doesn't check whether the given information is consistent.
#!
DeclareOperation( "WildSimplicialSurfaceByColouredFaceEdgePaths",
	[ IsSet, IsSet, IsList] );
DeclareOperation( "WildSimplicialSurfaceByColouredFaceEdgePathsNC",
	[ IsSet, IsSet, IsList] );


#############################################################################
##
##
#!  @Section Attributes and properties of wild coloured simplicial surfaces
#!
#!

#! @Description
#! Returns the generators of the wild simplicial surface in a list.
#! @Arguments a wild simplicial surface
#! @Returns a dense list of permutations
DeclareAttribute( "Generators", IsWildSimplicialSurface );

#! @Description
#! Return the group that is generated by the generators of the wild simplicial
#! surface.
#! @Arguments a wild simplicial surface
#! @Returns a group
DeclareAttribute( "GroupOfWildSimplicialSurface", IsWildSimplicialSurface );


#! @Description Given a wild coloured simplicial surface simpsurf, this
#!  function determines the vertex group of the simplicial surface.
#!  The vertex group of the simplicial surface simpsurf is defined to be
#!  $F_3/R$, where $F_3$ is the free group on three generators and $R$ is 
#!  the set of relations given by the vertex defining paths of the inner
#!  vertices.
#!  @Returns finitely presented group.
DeclareAttribute( "VertexGroup", IsWildSimplicialSurface );


#!	@Description
#!	Return the edge colors. We return a list which has unbounded entries for
#!	all edges (and only those). At the position 'edge' the colour of this
#!	edge is saved - that is, to which generator this edge belongs.
#!	@Arguments a wild simplicial surface
#!	@Returns a list
DeclareAttribute( "ColoursOfEdges", IsWildSimplicialSurface );
DeclareOperation( "ColourOfEdge", [IsWildSimplicialSurface, IsPosInt] );
DeclareOperation( "ColourOfEdgeNC", [IsWildSimplicialSurface, IsPosInt] );


#!	@Description
#!	Return a list which is indexed by the faces. For each face we get a list of
#!	the incident edges such that the first entry corresponds to the edge of
#!	the first colour, the second entry to the edge of the second colour and the
#!	third entry to the edge of the third colour.
#!	@Arguments a wild simplicial surface
#!	@Returns a list
DeclareAttribute( "ColouredEdgesOfFaces", IsWildSimplicialSurface );
DeclareOperation( "ColouredEdgeOfFace", 
		[IsWildSimplicialSurface, IsPosInt, IsPosInt] );
DeclareOperation( "ColouredEdgeOfFaceNC", 
		[IsWildSimplicialSurface, IsPosInt, IsPosInt] );


#! @Description
#!  A coloured face edge path of an inner vertex v of a wild
#!  simplicial surface is   
#!  a list  $[c_1,f_1,c_2,f_2,...,c_n,f_n]$, where f1,...,fn are the faces incident
#!  to v and c1,..,cn are colours such that the edges of  face fi with 
#!  ci and c(i+1) are those incident to v and c(n+1)=c1. 
#!  A coloured face edge path of a boundary vertex v of a wild
#!  simplicial surface is   
#!  a list  [c1,f1,c2,f2,...,cn,fn, c(n+1)], where f1,...,fn are the
#!  faces incident 
#!  to v and c1,..,c(n+1) are colours such that the edges of  face fi with 
#!  ci and c(i+1) are those incident to v and the edges of f1 and fn
#!  with colours   c1 and  c(n+1), respectively, are boundary edges.
#! @Arguments a wild simplicial surface
#! @Returns a list
DeclareAttribute( "ColouredFaceEdgePathsOfVertices", IsWildSimplicialSurface );
DeclareOperation( "ColouredFaceEdgePathOfVertex", 
		[IsWildSimplicialSurface,IsPosInt] );
DeclareOperation( "ColouredFaceEdgePathOfVertexNC", 
		[IsWildSimplicialSurface,IsPosInt] );


#!	@Description
#!	Return a list of three sets, where the first set consists of all edges of
#!	the first colour, and so on.
#!	@Arguments a wild simplicial surface
#!	@Returns a list of sets of edges
DeclareAttribute( "EdgesOfColours", IsWildSimplicialSurface );
DeclareOperation( "EdgesOfColour", [IsWildSimplicialSurface, IsPosInt] ); 
DeclareOperation( "EdgesOfColourNC", [IsWildSimplicialSurface, IsPosInt] );



#!  @Description 
#!	Given a wild coloured simplicial surface simpsurf, this
#!  function determines the mr-type of each of the edges of simpsurf.
#!  The mr-type of an edge of simpsurf is either "m" (for mirror) or 
#!  "r" (for rotation). It is defined as followed. 
#!  Suppose the edge  $e$ is incident to the vertices $v_1$ and 
#!  $v_2$ and to the two faces $F$ and $F'$. Let $x$ and $y$ be the edges of
#!  incident  incident to $F$ and $F'$ and to the same vertex $v_1$, say.
#!  Then $e$ is of type $m$ if both $x$ and $y$ have the same colour, and $e$
#!  is of type $r$ if $x$ and $y$ are different. As we assume the surface to
#!  be wild coloured, this means that the colours of the other edges incident 
#!  to $e$ and both faces $F$ and $F'$ are then also determined. As the # $'$
#!  edges of the simplicial surface are pairs of points, the mr-type of 
#!  the simplicial surface simpsurf can be encoded as a list of length 3. 
#!   Each of the
#!  entries is in turn  a list encoding the mr-type of all edges of a 
#!  certain colour. Suppose that mrtype[1] is the list encoding the mr-type
#!  of the red edges. Then mrtype[1][i] = 0 if the mr-type of the red edge
#!  incident to the vertex i is unknown, mrtype[1][i] = 1 if the mr-type of 
#!  the red edge incident to the vertex i is "m", and mrtype[1][i] = 2 if 
#!  the mr-type of the red edge incident to the vertex i is "r".
#!  @Arguments simpsurf, a simplicial surface object as created 
#!  by WildSimplicialSurface 
#!  @Returns a list of three lists, each of which contains the 
#!  entries 0, 1 or 2.
DeclareAttribute( "MRTypeOfEdges", IsWildSimplicialSurface);
DeclareAttribute( "MRTypeOfEdgesAsNumbers", IsWildSimplicialSurface);

#! @Description
#! If the mr-types of all edges with the same colour are identical, we call
#! this a structure of the surface. This property checks whether this is
#! the case.
#! @Arguments wildSurf
#! @Returns true or false
DeclareProperty( "IsSurfaceWithStructure", IsWildSimplicialSurface );

#! @Description
#! Return the MR-type of a surface with structure in the form of a list
#! [type of first colour, type of second colour, type of third colour].
#! @Arguments wildSurf
#! @Returns a list
DeclareAttribute( "MRTypeOfSurfaceWithStructure", 
    IsWildSimplicialSurface and IsSurfaceWithStructure );


#############################################################################
##
##
#!  @Section Functions for wild coloured simplicial surfaces
#!
#!
#!


#!	@Description
#!	Given a set of faces and a colour, return the edge such that the set of
#!	faces is the set of faces incident to the edge and that the edge has the
#!	given colour.
#!
#!	The NC-version doesn't check if the given colour is valid.
#!
#!	@Arguments wildSimplicialSurface, setOfFaces, colour
#!	@Returns an edge
DeclareOperation( "EdgeByFacesAndColour", 
	[ IsWildSimplicialSurface, IsSet, IsPosInt ] );
DeclareOperation( "EdgeByFacesAndColourNC", 
	[ IsWildSimplicialSurface, IsSet, IsPosInt ] );



#############################################################################
##
#!   @Description
#!   The function SixFoldCover takes as input a generic description of
#!   a simplicial surface.  The six fold cover of a simplicial surface is
#!   the following surface.
#!   If f is a face of the original face with edge numbers e_a, e_b and
#!   e_c, then the face is covered by the six faces of the form
#!   (f, e1, e2, e3), for which {e1, e2, e3}  = {e_a, e_b, e_c}.
#!   See Proposition 3.XX in the paper.
#!   @Arguments
#!
#!   If the optional argument mrtype is given, it has to be a list of length 
#!   3 and each entry has to be  $1$, or $2$. In this case the six fold cover 
#!   will treat the position $i$ for $i\in\{1,2,3\}$ of the three
#!   edges around a faces either as a   reflection (mirror), if the entry 
#!   in position $i$ of mrtype is 1, or as a rotation, if the entry in 
#!   position $i$ is 2. That is, the cover surface is generated by three
#!   transpositions $\sigma_i$ for $i=1,2,3$. For $i=1$, suppose $f$ and 
#!   $f'$ are faces of the surface surf such that the edges of $f$ are 
#!   $e_1, e_2$  and $e_3$ and the edges of $f'$ are  $e_1, e_a, e_b$ are 
#!   the edges $e_1, e_2$ and $e_a$ intersect in a common vertex and 
#!   the edges $e_1, e_3$ and $e_b$ intersect in a common vertex.
#!   For $i=1$ and  mrtype of position $1$ being  mirror (i.e. $1$), then 
#!   $$\sigma_1(f,e_1,e_2,e_3) = (f', e_1, e_a, e_b),$$ whereas if the 
#!   mrtype of position $1$ is a reflection (i.e. $2$), then 
#!   $$\sigma_1(f,e_1,e_2,e_3) = (f', e_1, e_b, e_a).$$ The definition
#!   of $\sigma_2$ and $\sigma_3$ are analogous, with $e_2$, respectively
#!   $e_3$ taking the role of the common edge $e_1.$
#!
#!   
#!   If the optional argument mredges is given, and mredges is a list of 
#!   length equal to the number of edges of the surface **surf** and an
#!   entry for an edge e is either 1 or 2. If the entry is 1 then 
#!   the six fold cover will treat the edge as a reflection (mirror) and 
#!   if the entry is 2  then the edge is treated as a rotation. 
#!
#!   The six fold cover is always a wild colourable simplicial surface.
#!   @Returns a wild coloured simplicial surface
#!   @Arguments surface, mrtype, bool
#!   if bool is true or not given, the mrtype specifies the behaviour of 
#!   the $\sigma_i$, if bool is false, the mrtype specifies the behaviour
#!   of the edges.
#!
DeclareOperation( "SixFoldCover", [IsSimplicialSurface, IsList] );


#!
#!  @Description
#!  Compute the action of a permutation on the faces of a wild simplicial
#!  surface. The permutation acts on the faces, while the names of vertices
#!  and edges may change.
#!  @Arguments surface, perm
#!  @Returns The new wild simplicial surface
DeclareOperation( "ImageWildSimplicialSurface", 
        [IsWildSimplicialSurface, IsPerm] );

#! @DoNotReadRestOfFile
#TODO modify the following declarations so that they work in AutoDoc

#############################################################################
##
##  AllWildSimplicialSurfaces( gens[, mrtype] ) . . . . all simplicial surfaces
##  AllWildSimplicialSurfaces( grp[, mrtype] )
##  AllWildSimplicialSurfaces( sig1, sig2, sig3[, mrtype] )
##
##
#!  @Description
#!  This function computes all wild-coloured simplicial surfaces generated
#!  by a triple of involutions as specified in the input. If the optional
#!  argument mrtype is present, only those wit a predefined mrtype are
#!  constructed.
#!  The involution triple can be given to the function in various ways.
#!  Either they are input as a list gens of three involutions, or as
#!  a group grp whose generators are the tree involutions, or they can
#!  be input into the function as three arguments, one for each involution.
#! 
#!  In case the optional argument mrtype  is present, it can be used to
#!  restrict to wild-colourings for which some or all edges have a predefined
#!  colour. This is equivalent to marking the cycles of the three involutions
#!  as follows. If the edge $(j, j^\sigma_i)$ of the involution $\sigma_i$ is
#!  to be a reflection (mirror) let $k=1$, if it is to be a rotation, let 
#!  $k=2$ and if it can be either let $k=0.$ Then set $mrtype[i][j] = k$.
#!  @Returns a list of all wild-coloured simplicial surfaces with generating
#!  set given by three involutions.
#!  The function AllWildSimplicialSurfaces when called with the optional argument
#!  mrtype now returns all wild-coloured simplicial surfaces whose edges
#!  are coloured according to the restrictions imposed by mrtype.
#!  @Arguments gens,  a list of three involutions
#!
DeclareOperation( "AllWildSimplicialSurfaces", [IsList,IsList] ); 

##############################################################################
##
#!	@Description
#!	For a given list of wild simplicial surfaces this method returns all of
#!	them where edges with the same colour have the same MR-type.
#!
#!	@Arguments wildSimplicialSurfaceList
#!	@Returns a list of wild simplicial surfaces
DeclareOperation( "FilteredStructuresWildSimplicialSurface", [IsList] );


#############################################################################
##
#!	@Description
#!	Possible inputs are:
#!	- a group
#!	- a list with three involutions
#!	- three involutions
#!	This method returns all wild simplicial surfaces that can be defined
#!	on the basis of these three involutions.
#!
#!	@Arguments listOfInvolutions
#!	@Returns a list of wild simplicial surfaces
DeclareOperation( "AllStructuresWildSimplicialSurface", [IsList] );


#############################################################################
##
#!  @Description
#!  This function takes as input a list of pairs of integers. Suppose the
#!  integers occurring in this list of pairs is the set faces. Then this
#!  function computes all triples of involutions acting on the set faces.
#!  @Returns a list of lists, which are involution triples.
#!  @Arguments a list of lists, which is a list of pairs of integers
#!
DeclareOperation( "GeneratorsFromFacePairs",  [IsList] );



#############################################################################
##
#!  @Description
#!  This function takes as input a ``face"- description of a surface. 
#!  A ``face"-description of a surface is as  follows.
#!
#!  A list surf with three entries:
#!  * a list of integers, the faces, 
#!  * a list of  pairs of faces making up the edges, 
#!  * a list of  face-paths, one face-path for  each vertex. 
#!  A face-path is a list of on a vertex in the order in which they occur
#!  in the vertex. Note that in this representation it is critical that a 
#!  closed face-path is represented by a list of faces that repeats the 
#!  starting face at the end! That means  the first and last face in the
#!  list of faces for the given face-path **must** be equal, otherwise 
#!  the face-path is assumed to be a path from a face with boundary to 
#!  another face with boundary around a fixed vertex.
#!   Thus the ``face"-description has the form
#!  surf := [ [f1, f2, ..., fn, f1],  [ [f1,f2],...],  [[f1,f2,f3,...],... ];
#!  This is a very simple way of inputting a simplicial surface by just 
#!  reading off the face numbers of each  vertex.
#!
#!
#!  @BeginExample the tetrahedron is represented as
#!    tetra := [ [1..4], [[1,2],[1,3],[1,4],[2,3],[3,4],[2,4]],
#!             [[1,2,3,1], [1,3,4,1],[1,2,4,1],[2,3,4,2]]];
#!  AllWildSimplicialSurfacesFromFacePath(tetra[1],tetra[2],tetra[3]);
#!  
#!             where the triple [1,2,3,1] encodes a closed face path
#!              around one vertex.
#!  @EndExample
#!
#!  @Returns  the list of all wild coloured simplicial surfaces with these 
#!  specifications.
#!  @Arguments a list of lists, representing a ``face"-description of a surface
#! 
DeclareOperation( "AllWildSimplicialSurfacesFromFacePath", [IsList,IsList,IsList]);


#!
#!  @Description
#!  Try to draw the wild simplicial surface. The output will be a
#!  two-dimensional net, written into a TikZ-file.
#!  To facilitate the drawing, we make use of a print-record that saves
#!  information about the drawing. This method returns a print record that
#!  allows it to reconstruct the drawing. If a print record is given, its
#!  information supersede the default style.
#!
#!  The print record contains the following information:
#!  startingFaces: A list of faces (one for each path-connected component)
#!      that are printed first in the drawing. If this information is not
#!      given, the faces with the smallest indices in each component will
#!      be choosen. For example, 1 is always drawn first.
#!  edgeDrawOrder: A list of lists of edges. For each connected component
#!      this list tells the order in which the edges are drawn. If an edge is
#!      drawn, precisely one of its adjacent faces has to exist in the drawing.
#!      The other one will be drawn. This list will miss exactly those edges
#!      that are not (necessarily) inner edges of the drawing, since those
#!      may be drawn twice if the angle sum at certain vertices is not flat.
#!  edgeColours: A list of three colours (given as strings) that determine in
#!      which colour each edge class is to be drawn.
#!  noFaceColours: If true, turns off the face colouring.
#!  faceColours: A list of two colours (given as strings) that determine in 
#!      which colours the faces are drawn. This only works for orientable
#!      surfaces. If a face is drawn with the same orientation as the starting
#!      face, it gets the first colour. Otherwise it will be drawn in the
#!      second colour.
#!  faceLabelling: Control whether the faces are labelled by name. This is
#!      turned on by default.
#!  edgeLengths: A list of three positive numbers that determine the length of
#!      the three edge classes in the drawing.
#!  edgeLabelling: Control whether the edges are labelled in the drawing. The
#!      default is false to not clutter the drawing. To find an edgeDrawOrder
#!      that avoids intersections this might be useful.
#!  vertexLabelling: Control whether the vertices are labelled in the drawing.
#!      The default is true, but you might decide to not draw the vertices.
#!  vertexColour: The colour of the vertices (default is orange).
#!  edgeThickness: Determines the thickness of the edges. The edges are drawn
#!      with two parallel lines (and colour in between). This parameter gives
#!      the distance between the parallel lines (in pt). The default is 1.
#!  globalScale: The scaling factor in the tikz-picture. The default is the
#!      smallest edge length divided by 2.
#!  compileLaTeX: If true, LaTeX will compile the written file automatically.
#!      Since this may take some time or there might be strange compiling
#!      error, this flag is turned false per default.
#!  
#!  
#!
#!  @Arguments wildSurf, fileName [, printRecord ]
#!  @Returns a print record. As a side effect it writes a tikz-file
DeclareOperation( "DrawSurfaceToTikz", 
        [IsWildSimplicialSurface, IsString, IsRecord]);



#!  @Description
#!  Return the wild incidence graph for usage in the nauty-interface.
#!  @Arguments wildSurf
#!  @Returns the wild incidence graph
DeclareAttribute( "WildIncidenceGraph", IsWildSimplicialSurface );

#!
#! @Description
#! Return the automorphism group of this wild simplicial surface. The
#! automorphism group allows the switching of colour classes.
#! @Arguments wildSurf
#! @Returns a group
DeclareAttribute( "AutomorphismGroup", IsWildSimplicialSurface );

#!
#! @Description
#! Check whether two wild coloured simplicial surfaces are isomorphic. It is
#! allowed to switch the colours.
#! @Arguments ws1, ws2
#! @Returns true or false
DeclareOperation( "IsIsomorphicWildSimplicialSurface",
    [ IsWildSimplicialSurface, IsWildSimplicialSurface ] );

#! @Description
#! Given a list of wild simplicial surfaces, return a sublist of those
#! such that no two of those are isomorphic (as wild simplicial surfaces) and
#! that every isomorphism class is represented.
#! @Arguments wildList
#! @Returns a list of wild simplicial surfaces
DeclareOperation( "WildIsomorphismRepresentatives", [IsList] );

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

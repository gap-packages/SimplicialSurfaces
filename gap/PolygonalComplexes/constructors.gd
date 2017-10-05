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

#! @Chapter Constructing surfaces
#! @ChapterLabel Constructors
#!
#! In chapter <Ref Chap="PolygonalStructures"/> we introduced polygonal
#! complexes (as a generalization of simplicial surfaces). They are based
#! on incidence structures, which were analysed in chapter
#! <Ref Chap="Chapter_AccessIncidenceGeometry"/>.
#! <Par/>
#! This chapter deals with the construction of custom polygonal complexes
#! and simplicial surfaces.

#######
## We have a problem in this section:
## Our constructors have the structure
## <Type>By<Method><Check?>
## => 6 * 2 = 12 operations for each method
## This is too much for one documentation group (especially since the names
## are too long to fit in a single line).
##
## Therefore we will do one method per section. We will therefore eschew the
## surface database constructors here - they are too important to be
## unnoticed here (which they will be as most readers will be inclined to
## skim this chapter).
##
## To keep a skimming readers attention we will do a different surface example
## for each documentation group. Ideally they will epitomize different types
## of structures that might appear.
#######

#! This package offers three different ways to construct a polygonal complex
#! "from scratch":
#! * Choose from a few standard example (like platonic solids) in section TODO
#! * Define it directly by its incidence structure (this will be the main
#!   content of this chapter)
#! * Use the surface database to find appropriate complexes. This will be 
#!   handled in chapter TODO
#!
#! As the list of some small standard examples in section TODO 
#! does not warrant much 
#! explanation (except noting that all platonic solids are there), we will
#! now explain the structure of the more general constructors.
#! <Par/>
#! All general constructors are structured like [Type]By[Method](args), e.g.
#! * <K>PolygonalComplexByDownwardIncidence</K>( <A>verticesOfEdges</A>, <A>edgesOfFaces</A> )
#! * <K>SimplicialSurfaceByEdgeFacePaths</K>( <A>edgeFacePaths</A> )
#!
#! They are mainly distinguished by the different attributes they need to 
#! construct the incidence structures:
#! * <E>DownwardIncidence</E>
#!   (<Ref Sect="Section_Constructors_DownwardIncidence"/>): 
#!   <K>VerticesOfEdges</K> (<Ref Subsect="VerticesOfEdges"/>),
#!   <K>EdgesOfFaces</K> (<Ref Subsect="EdgesOfFaces"/>)
#! * <E>UpwardIncidence</E>
#!   (<Ref Sect="Section_Constructors_UpwardIncidence"/>):
#!   <K>EdgesOfVertices</K> (<Ref Subsect="EdgesOfVertices"/>), 
#!   <K>FacesOfEdges</K> (<Ref Subsect="FacesOfEdges"/>)
#! * <E>VerticesInFaces</E>
#!   (<Ref Sect="Section_Constructors_VerticesInFaces"/>):
#!   <K>VerticesOfFaces</K> (<Ref Subsect="VerticesOfFaces"/>)
#! * <E>EdgeFacePaths</E>
#!   (<Ref Sect="Section_Constructors_EdgeFacePaths"/>):
#!   <K>EdgeFacePathsOfVertices</K> (<Ref Subsect="EdgeFacePathSingle"/>)
#!

#! @Section DownwardIncidence
#! @SectionLabel Constructors_DownwardIncidence
#!
#! The constructors that are based on <E>DownwardIncidence</E> are based on
#! the attributes <K>VerticesOfEdges</K> (<Ref Subsect="VerticesOfEdges"/>) 
#! and <K>EdgesOfFaces</K> (<Ref Subsect="EdgesOfFaces"/>). From these
#! any polygonal structure from chapter <Ref Chap="PolygonalStructures"/> can
#! be build.
#! <Par/>
#! These constructors also allow the optional arguments <A>vertices</A>,
#! <A>edges</A> and <A>faces</A>. If those sets are given, the incidence
#! information is checked for compatibility with them. This is very useful
#! in practice to notice typos in the incidence relations. It is also possible
#! to give a positive integer <A>n</A> - it will be converted into the list
#! <M>[1,...,n]</M>.
#! <Par/>
#! The name <E>DownwardIncidence</E> stems from the fact that the incidence
#! relation is given by referring to structures of lower dimension  - an edge
#! (dimension 1) is defined by two vertices (dimension 0) and a face 
#! (dimension 2) is defined by edges.

#TODO should the presentation be changed?
# Problem: optional argument types unclear (because complicated..)
# Problem: Name too long for one line and breaks at bad point

#TODO should we introduce a "similar methods"-part at the end of
# some methods? This might become too long..

#! @BeginGroup
#! @Description
#! This method constructs a polygonal complex 
#! (<Ref Sect="PolygonalStructures_complex"/>) based on the attributes
#! <K>VerticesOfEdges</K> (<Ref Subsect="VerticesOfEdges"/>) and 
#! <K>EdgesOfFaces</K> (<Ref Subsect="EdgesOfFaces"/>). It takes these
#! arguments:
#! * OPTIONAL: The sets of vertices, edges and faces (i.e. sets of positive 
#!   integers).
#!   If a positive integer <M>n</M> is given, it is interpreted as the set
#!   <M>[1,...,n]</M>. Although these arguments are redundant, their use is
#!   recommended to catch mistakes in the other arguments.
#! * <K>verticesOfEdges</K>: A list that has an entry for each edge of the
#!   polygonal complex. This entry has to be a list with the two
#!   vertices (as positive integers) of this edge.
#! * <K>edgesOfFaces</K>: A list that has an entry for each face of the 
#!   polygonal complex. This entry has to be a list with the edges
#!   (as positive integers) of this face.
#!
#! The following checks will be performed. <E>Emphasized</E> checks are also
#! performed by the NC-version:
#! * Are the optional arguments <A>vertices</A>, <A>edges</A> and <A>faces</A>
#!   either positive integers or sets of positive integers?
#! * Are <A>verticesOfEdges</A> and <A>edgesOfFaces</A> lists where the entries
#!   are lists of positive integers?
#! * Is every bounded entry of <A>verticesOfEdges</A> a list with exactly two entries
#!   that are different?
#! * Does every bounded entry of <A>edgesOfFaces</A> contain at least one element?
#! * If <A>vertices</A> is given, is 
#!   <K>Union</K>(<A>verticesOfEdges</A>) = <A>vertices</A>?
#! * Are the bound positions of <A>verticesOfEdges</A> equal to 
#!   <K>Union</K>(<A>edgesOfFaces</A>)? If <A>edges</A> is given, is it equal
#!   to those two sets?
#! * If <A>faces</A> is given, is it equal to the bound positions of 
#!   <A>edgesOfFaces</A>?
#!
#! TODO example
#! @Returns a polygonal complex
#! @Arguments [vertices, edges, faces,] verticesOfEdges, edgesOfFaces
DeclareOperation( "PolygonalComplexByDownwardIncidence", [IsList, IsList] );
#! @Arguments [vertices, edges, faces,] verticesOfEdges, edgesOfFaces
DeclareOperation( "PolygonalComplexByDownwardIncidenceNC", [IsList, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! bla
#! @Returns a ramified polygonal surface
#! @Arguments [vertices, edges, faces,] verticesOfEdges, edgesOfFaces
DeclareOperation( "RamifiedPolygonalSurfaceByDownwardIncidence", [IsList, IsList] );
#! @Arguments [vertices, edges, faces,] verticesOfEdges, edgesOfFaces
DeclareOperation( "RamifiedPolygonalSurfaceByDownwardIncidenceNC", [IsList, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! bla
#! @Returns a polygonal surface
#! @Arguments [vertices, edges, faces,] verticesOfEdges, edgesOfFaces
DeclareOperation( "PolygonalSurfaceByDownwardIncidence", [IsList, IsList] );
#! @Arguments [vertices, edges, faces,] verticesOfEdges, edgesOfFaces
DeclareOperation( "PolygonalSurfaceByDownwardIncidenceNC", [IsList, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! bla
#! @Returns a triangular complex
#! @Arguments [vertices, edges, faces,] verticesOfEdges, edgesOfFaces
DeclareOperation( "TriangularComplexByDownwardIncidence", [IsList, IsList] );
#! @Arguments [vertices, edges, faces,] verticesOfEdges, edgesOfFaces
DeclareOperation( "TriangularComplexByDownwardIncidenceNC", [IsList, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! bla
#! @Returns a ramified simplicial surface
#! @Arguments [vertices, edges, faces,] verticesOfEdges, edgesOfFaces
DeclareOperation( "RamifiedSimplicialSurfaceByDownwardIncidence", [IsList, IsList] );
#! @Arguments [vertices, edges, faces,] verticesOfEdges, edgesOfFaces
DeclareOperation( "RamifiedSimplicialSurfaceByDownwardIncidenceNC", [IsList, IsList] );
#! @EndGroup

#! @BeginGroup
#! @Description
#! bla
#! @Returns a simplicial surface
#! @Arguments [vertices, edges, faces,] verticesOfEdges, edgesOfFaces
DeclareOperation( "SimplicialSurfaceByDownwardIncidence", [IsList, IsList] );
#! @Arguments [vertices, edges, faces,] verticesOfEdges, edgesOfFaces
DeclareOperation( "SimplicialSurfaceByDownwardIncidenceNC", [IsList, IsList] );
#! @EndGroup


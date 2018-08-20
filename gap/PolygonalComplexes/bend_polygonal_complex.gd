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

#! @Chapter Access to bend polygonal complexes
#! @ChapterLabel AccessBendPolygonalComplex
#! 

####
# No matter what, a chapter should start with a short description of its
# contents, together with necessary references to previous material (if
# someone does not read the chapters in order).
####

#! In section <Ref Sect="PolygonalStructures_bend"/> we introduced 
#! the concept of <K>BendPolygonalComplex</K> that went further than
#! a pure incidence geometry. This chapter describes this additional
#! structure and how to access it.
#! 

#! TODO restructure this chapter after more information about correct access design is obtained

#! @Section Local flags
#! @SectionLabel AccessBend_LocalFlags

#! The main difference in contrast to a polygonal complex is an additional
#! structure on the flags of the bend polygonal complex. Since these flags
#! are different from the flags of the incidence structure, we denote them
#! as <E>local flags</E>, i.e. flags of the single polygons (before any
#! identifications took place).
#!
#! We will identify the set of local flags with a set of positive integers.
#! The attribute <K>LocalFlags</K> returns this set. In addition there are
#! two other structures:
#! <Enum>
#!     <Item>The interaction of the local flags with the incidence geometry,
#!           encoded by the attributes <K>VerticesOfLocalFlags</K> or
#!           <K>LocalFlagsOfVertices</K>.</Item>
#!     <Item>The neighbouring relations between the local flags. Generically
#!           they are given by the attribute <K>LocalFlagVertexPartition</K> 
#!           but if all classes have at most two elements, 
#!           <K>LocalFlagVertexInvolution</K> can be used instead.</Item>
#! </Enum>
#!
 
#! @Description
#! Return the set of local flags of the given bend polygonal complex.
#!
#! @Arguments bendComplex
#! @Returns A set of positive integers
DeclareAttribute( "LocalFlags", IsBendPolygonalComplex );


#! @BeginGroup
#! @Description
#! Return lists mapping a local flag (represented by its position
#! in <K>LocalFlags</K>(<A>bendComplex</A>)) to the global
#! vertex/edge/face they belong to.
#!
#! @Returns A list of positive integers
#! @Arguments bendComplex
DeclareAttribute( "VerticesOfLocalFlags", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "EdgesOfLocalFlags", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "FacesOfLocalFlags", IsBendPolygonalComplex );
#! @EndGroup


#! @BeginGroup
#! @Description
#! Return lists mapping a global vertex/edge/face to the set of 
#! local flags surrounding it.
#!
#! @Returns A list of sets of positive integers
#! @Arguments bendComplex
DeclareAttribute( "LocalFlagsOfVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalFlagsOfEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalFlagsOfFaces", IsBendPolygonalComplex );
#! @EndGroup


#! @BeginGroup
#! @Description
#! Return the sets of local vertices, local edges, and half-edges.
#!
#! @Returns a set of positive integers
#! @Arguments bendComplex
DeclareAttribute( "LocalVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "HalfEdges", IsBendPolygonalComplex );
#! @EndGroup


#! @BeginGroup
#! @Description
#! Return the set of partitions of the local flags with regard to the
#! vertex/edge/face-equivalence relation. The local flags are given by
#! their positions in <K>LocalFlags</K>(<A>bendComplex</A>).
#!
#! @Returns A set of sets
#! @Arguments bendComplex
DeclareAttribute("LocalFlagsOfLocalVertices", IsBendPolygonalComplex);
#! @Arguments bendComplex
DeclareAttribute("LocalFlagsOfLocalEdges", IsBendPolygonalComplex);
#! @Arguments bendComplex
DeclareAttribute("LocalFlagsOfHalfEdges", IsBendPolygonalComplex);
#! @EndGroup


#! @BeginGroup
#! @Description
#! TODO
#!
#! @Returns A list of positive integers
#! @Arguments bendComplex
DeclareAttribute( "LocalVerticesOfLocalFlags", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalEdgesOfLocalFlags", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "HalfEdgesOfLocalFlags", IsBendPolygonalComplex );
#! @EndGroup


#! @BeginGroup
#! @Description
#!
#! TODO
#!
#! @Returns 
#! @Arguments bendComplex
DeclareAttribute( "LocalVerticesOfFaces", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalEdgesOfFaces", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "HalfEdgesOfFaces", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "FacesOfLocalVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "FacesOfLocalEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "FacesOfHalfEdges", IsBendPolygonalComplex );

#! @Arguments bendComplex
DeclareAttribute( "VerticesOfLocalEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalEdgesOfVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "VerticesOfLocalVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalVerticesOfVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "VerticesOfHalfEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "HalfEdgesOfVertices", IsBendPolygonalComplex );

#! @Arguments bendComplex
DeclareAttribute( "EdgesOfLocalEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalEdgesOfEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "EdgesOfHalfEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "HalfEdgesOfEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "EdgesOfLocalVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalVerticesOfEdges", IsBendPolygonalComplex );

#! @Arguments bendComplex
DeclareAttribute( "LocalVerticesOfHalfEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "HalfEdgesOfLocalVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalEdgesOfHalfEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "HalfEdgesOfLocalEdges", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalEdgesOfLocalVertices", IsBendPolygonalComplex );
#! @Arguments bendComplex
DeclareAttribute( "LocalVerticesOfLocalEdges", IsBendPolygonalComplex );
#! @EndGroup


#! @BeginGroup
#! @Description
#! Return the partitions of the local flags with regard to the
#! vertex/edge/face-equivalence relation as involutions. 
#! The local flags are given by
#! their positions in <K>LocalFlags</K>(<A>bendComplex</A>).
#! 
#! If this is not possible, <K>fail</K> is returned instead.
#!
#! @Returns An involution or <K>fail</K>
#! @Arguments bendComplex
DeclareAttribute("LocalFlagVertexInvolution", IsBendPolygonalComplex);
#! @Arguments bendComplex
DeclareAttribute("LocalFlagEdgeInvolution", IsBendPolygonalComplex);
#! @Arguments bendComplex
DeclareAttribute("LocalFlagFaceInvolution", IsBendPolygonalComplex);
#! @EndGroup


#! @BeginGroup
#! @Description
#! TODO
#!
#! @Returns true or false
#! @Arguments bendComplex, flag1, flag2
DeclareOperation("IsLocalFlagsVertexEquivalent", [IsBendPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments bendComplex, flag1, flag2
DeclareOperation("IsLocalFlagsEdgeEquivalent", [IsBendPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments bendComplex, flag1, flag2
DeclareOperation("IsLocalFlagsFaceEquivalent", [IsBendPolygonalComplex, IsPosInt, IsPosInt]);
#! @EndGroup

#! @Description
#! TODO
#! @Returns a local flag
#! @Arguments bendComplex, localVertex, localEdge, face
DeclareOperation("LocalFlagByLocalVertexLocalEdgeFace", [IsBendPolygonalComplex, IsPosInt, IsPosInt, IsPosInt]);




#! @Description
#! Construct a bend polygonal complex from signed face perimeters, i.e.
#! a list (bound entries indexed by the faces) such that we have a list
#! of the following form for each face:
#! * Alternating vertex and edge numbers (the vertex-edge-path of the
#!   face perimeter) where each edge number might be multiplied with -1
#!
#! This is interpreted in the following way:
#! * The length of this list defines how many vertices the polygon for this
#!   face will have. (Length 6 = triangle)
#! * Every two adjacent elements define a flag. The flags of the first face
#!   are numbered from 1 to the length of the list. This gives all of the
#!   edges an implicit orientation
#! * If two edges have the same absolute value, they are identified. If
#!   their signs agree, they are identified with the same orientation,
#!   otherwise reversed.
#!
#! @Returns a bend polygonal complex
#! @Arguments signedFacePerimeter
DeclareOperation( "BendPolygonalComplexBySignedFacePerimeters", [IsList] );


#! @Section Bend faces and edges
#! @SectionLabel AccessBend_BendFacesEdges
#!
#! 


#! @BeginGroup
#! @Description
#! For a given face of a bend polygonal complex, return the polygonal
#! complex of this single polygon (the local vertices and edges of
#! <A>bendComplex</A> become the vertices and edges of the returned 
#! polygonal complex).
#!
#! The NC-version does not check whether <A>face</A> is a face of
#! <A>bendComplex</A>.
#!
#! @Returns a polygonal complex
#! @Arguments bendComplex, face
DeclareOperation("LocalFace", [IsBendPolygonalComplex, IsPosInt]);
#! @Arguments bendComplex, face
DeclareOperation("LocalFaceNC", [IsBendPolygonalComplex, IsPosInt]);
#! @EndGroup

#! @Description
#! Return the set of all rigid faces in the given bend polygonal
#! complex. These are the faces whose vertices are not identified.
#!
#! @Returns a set of positive integers
#! @Arguments bendComplex
DeclareAttribute("RigidFaces", IsBendPolygonalComplex);

#! @Description
#! Return the set of all bend faces in the given bend polygonal
#! complex. These are the faces in which vertices are identified.
#!
#! @Returns a set of positive integers
#! @Arguments bendComplex
DeclareAttribute("BendFaces", IsBendPolygonalComplex);


#! @Description
#! Construct a polygonal complex from the given bend polygonal
#! complex, if possible. Otherwise return <K>fail</K>.
#!
#! The labels of vertices, edges and faces are retained.
#!
#! @Returns a polygonal complex or <K>fail</K>
#! @Arguments bendComplex
DeclareAttribute("PolygonalComplex", IsBendPolygonalComplex);


#! @Description
#! Construct a bend polygonal complex from the given polygonal complex.
#! The additional labels are defined as follows:
#! * The position of the 3-flags in <K>ThreeFlags</K> defines the labels
#!   of the local flags.
#! * The position of the 2-flags in <K>VertexEdgeFlags</K> defines the
#!   labels of the half-edges.
#! * The position of the 2-flags in <K>VertexFaceFlags</K> defines the
#!   labels of the local vertices.
#! * The position of the 2-flags in <K>EdgeFaceFlags</K> defines the
#!   labels of the local edges.
#!
#! @Returns a bend polygonal complex
#! @Arguments polyComplex
DeclareAttribute("BendPolygonalComplex", IsPolygonalComplex);

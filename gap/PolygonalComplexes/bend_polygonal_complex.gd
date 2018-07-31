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
#! <P/>

#! TODO restructure this chapter after more information about correct access design is obtained

#! @Section Local flags
#! @SectionLabel AccessBend_LocalFlags

#! @Description
#! Return the set of local flags of the given bend polygonal complex.
#! A local flag is a tuple <M>[face, [vertex,edge]]</M>, where <A>face</A>
#! is a face of <A>complex</A> and <A>vertex,edge</A> are a local vertex and
#! a local edge of <A>face</A>, which are incident.
#!
#! @Arguments bendComplex
#! @Returns A set of local flags
DeclareAttribute( "LocalFlags", [IsBendPolygonalComplex] );
##TODO allow holes in the set of local flags (for connected components)


#! @BeginGroup
#! @Description
#! Return lists mapping a local flag (represented by its position
#! in <K>LocalFlags</K>(<A>bendComplex</A>)) to the global
#! vertex/edge/face they belong to.
#!
#! @Returns A list of positive integers
#! @Arguments bendComplex
DeclareAttribute( "GlobalVerticesOfLocalFlags", [IsBendPolygonalComplex] );
#! @Arguments bendComplex
DeclareAttribute( "GlobalEdgesOfLocalFlags", [IsBendPolygonalComplex] );
#! @Arguments bendComplex
DeclareAttribute( "GlobalFacesOfLocalFlags", [IsBendPolygonalComplex] );
#! @EndGroup


#! @BeginGroup
#! @Description
#! Return lists mapping a global vertex/edge/face to the set of 
#! local flags surrounding it.
#!
#! @Returns A list of sets of positive integers
#! @Arguments bendComplex
DeclareAttribute( "LocalFlagsOfGlobalVertices", [IsBendPolygonalComplex] );
#! @Arguments bendComplex
DeclareAttribute( "LocalFlagsOfGlobalEdges", [IsBendPolygonalComplex] );
#! @Arguments bendComplex
DeclareAttribute( "LocalFlagsOfGlobalFaces", [IsBendPolygonalComplex] );
#! @EndGroup


#! @BeginGroup
#! @Description
#! Return the set of partitions of the local flags with regard to the
#! vertex/edge/face-equivalence relation. The local flags are given by
#! their positions in <K>LocalFlags</K>(<A>bendComplex</A>).
#!
#! @Returns A set of sets
#! @Arguments bendComplex
DeclareAttribute("LocalFlagVertexPartition", [IsBendPolygonalComplex]);
#! @Arguments bendComplex
DeclareAttribute("LocalFlagEdgePartition", [IsBendPolygonalComplex]);
#! @Arguments bendComplex
DeclareAttribute("LocalFlagFacePartition", [IsBendPolygonalComplex]);
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
DeclareAttribute("LocalFlagVertexInvolution", [IsBendPolygonalComplex]);
#! @Arguments bendComplex
DeclareAttribute("LocalFlagEdgeInvolution", [IsBendPolygonalComplex]);
#! @Arguments bendComplex
DeclareAttribute("LocalFlagFaceInvolution", [IsBendPolygonalComplex]);
#! @EndGroup

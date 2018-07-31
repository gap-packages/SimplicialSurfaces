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


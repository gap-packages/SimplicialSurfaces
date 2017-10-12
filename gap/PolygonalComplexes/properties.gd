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

## This chapter contains many diverse aspects of polygonal complexes.
## The current order may not be optimal, depending on what the future holds
#TODO current plan:
# 1) Invariants
# 2) connectivity
# 3) orientability
# 4) automorphism/isomorphism?
# 5) Properties of vertices
# 6) Properties of edges
# 7) Properties of faces (?);

#! @Chapter Properties of surfaces and complexes
#! @ChapterLabel Properties
#! 
#! TODO Introduction

#! @Section Invariants
#! @SectionLabel Properties_Invariants
#!
#! TODO intro

#TODO is an example needed? Does the code speak for its own?
#! @Description
#! Return the Euler-characteristic of the given polygonal complex.
#! The Euler-characteristic is computed as
#! @BeginLogSession
#! gap> NrOfVertices(complex) - NrOfEdges(complex) + NrOfFaces(complex);
#! @EndLogSession
#! 
#! @Returns an integer
#! @Arguments complex
DeclareAttribute( "EulerCharacteristic", IsPolygonalComplex );

#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2019
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

#! @Chapter Navigating the incidence structure
#! @ChapterLabel Navigation
#!
#! Chapter <Ref Chap="Chapter_AccessIncidenceGeometry"/> introduces the 
#! elementary
#! access operations for the incidence geometry. But if one works with
#! those geometries in practice, one notices that some tasks are quite
#! cumbersome with those tools, for example:
#! * Given a face and an incident edge, what is the other face incident
#!   to the edge?
#! * Given a triangular face and an incident vertex, which edge is
#!   opposite to that vertex?
#! * For which pairs of adjacent vertices do both of the vertices
#!   fulfill some property?
#! 
#! All of the methods in this chapter only require a few lines of code
#! with the tools of chapter <Ref Chap="Chapter_AccessIncidenceGeometry"/>.
#! Nevertheless, having them makes programming a bit simpler as one can
#! focus on higher-order structures. In addition, each method will
#! feature an explanation how the desired result can be achieved with
#! the tools from chapter <Ref Chap="Chapter_AccessIncidenceGeometry"/>,
#! so that each user can adapt them for their own special circumstances.
#!
#! TODO overview of sections
#!
#! We will use the following polygonal complex to exemplify the methods
#! in this chapter:
#! <Alt Only="TikZ">
#!   \input{Image_EyeStone.tex}
#! </Alt>
#! @ExampleSession
#! gap> complex := PolygonalComplexByDownwardIncidence( 
#! >        [[1,2],[2,5],[2,6],[2,6],[1,6],[5,6],[1,7],[6,8],[5,9],[7,8],[8,9],
#! >         [8,12],[2,13],[13,14]],
#! >        [[1,3,5],[5,7,8,10],,[6,8,9,11],[2,4,6],[2,9,11,12,13,14]]);;
#! @EndExampleSession
#

#! @Section Moving along edges
#! @SectionLabel Navigation_Edges
#!
#! 

#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2018
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

#! @BeginChunk Example_ColouredPrism
#! We will illustrate all of these on a prism with triangular base.
#! @BeginExample
prism := PolygonalSurfaceByDownwardIncidence( 
    [[2,3],[1,3],[1,2],[1,7],[2,8],[3,9],[8,9],[7,9],[7,8]],
    [[1,3,2],,[3,5,9,4],[1,6,7,5],[2,4,8,6],,[7,8,9]]);;
colPrism := EdgeColouredPolygonalComplex(prism, [1,4,2,1,5,2,4,5,3]);;
#! @EndExample
#! This can be drawn by <K>DrawSurfaceToTikz</K> 
#! (<Ref Subsect="DrawSurfaceToTikz_EdgeColoured"/>).
#! @BeginLog
pr := rec( edgeDrawOrder := [1,5,6,7], 
    edgeColourClassColours :=  ["magenta", "cyan", "olive", "lime", "pink"] );;
DrawSurfaceToTikz(colPrism, "Prism_coloured", pr );;
#! @EndLog
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Prism_coloured.tex}
#! </Alt>
#! @EndChunk

#! @BeginChunk Example_ColouredPrism_NonPerfect
#! We illustrate this on the prism that was introduced at the start of
#! section <Ref Sect="Section_RainbowEdgeColouring_Definition"/>.
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Prism_coloured.tex}
#! </Alt>
#! The given edge colouring is a non-perfect rainbow colouring.
#! @BeginExample
EdgesOfColours( colPrism );
#! [ [ 1, 4 ], [ 3, 6 ], [ 9 ], [ 2, 7 ], [ 5, 8 ] ]
IsFaceRainbowEdgeColouring( colPrism );
#! true
IsPerfectFaceRainbowEdgeColouring( colPrism );
#! false
#! @EndExample
#! 
#! Since there are faces with four
#! incident edges, any colouring with less than four colours can't be
#! a rainbow colouring. Conversely, a colouring with more than four colours
#! can't be perfect.
#! 
#! In fact, there is no perfect rainbow colouring for this polygonal surface.
#! TODO refer to comparison with simplicial surface (prove this result there);
#! @EndChunk

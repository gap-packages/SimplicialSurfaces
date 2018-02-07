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


pr := rec( scale := 2.5, edgeColours := ["red","blue","green","green","blue","red"] );
DrawSurfaceToTikz( Tetrahedron(), "Tetrahedron_coloured", pr );
#! @BeginChunk Example_Coloured_Tetrahedron
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Tetrahedron_coloured.tex}
#! </Alt>
#! @EndChunk

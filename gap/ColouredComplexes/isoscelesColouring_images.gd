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

#! @BeginChunk Example_ColouredCube
#! We will illustrate all of these on a cube.
#! @BeginExample
cube := Cube();;
colCube := EdgeColouredPolygonalComplex(cube, [1,2,2,2,1,1,1,1,2,1,2,2]);;
#! @EndExample
#! This can be drawn by <K>DrawSurfaceToTikz</K> 
#! (<Ref Subsect="DrawSurfaceToTikz_EdgeColoured"/>).
#! @BeginLog
 pr := rec( edgeDrawOrder := [5,6,7,2,9],
 edgeColourClassColours := ["red", "blue"] );;
DrawSurfaceToTikz(colCube, "Cube_twocoloured", pr );;
#! @EndLog
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Cube_twocoloured.tex}
#! </Alt>
#! @EndChunk


#! @BeginChunk Example_IsoscelesOctahedron
#!#! @BeginExample
oct := Octahedron();;
colOct := EdgeColouredPolygonalComplex(oct, [1,2,2,2,1,1,1,1,2,1,2,2]);;
#! @EndExample
#! This can be drawn by <K>DrawSurfaceToTikz</K> 
#! (<Ref Subsect="DrawSurfaceToTikz_EdgeColoured"/>).
#! @BeginLog
pr := rec( edgeColourClassColours := ["red", "blue"],
  edgeColourClassLengths := [1.2,0.8] );;
DrawSurfaceToTikz(colOct, "Oct_isosccoloured", pr );;
#! @EndLog
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Oct_isosccoloured.tex}
#! </Alt>
#! @EndChunk




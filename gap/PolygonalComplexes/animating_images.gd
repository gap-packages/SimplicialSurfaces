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

# The examples consist of a picture in 3D (if advisable), the GAP-code to 
# create the surface and the image of the net.

#! @BeginChunk Example_OctahedronAnimating
#! @BeginExample
oct := Octahedron();;
#! @EndExample
verticesPositions := [ [ 0, 0, Sqrt(2.) ],[ 1, 1, 0 ],[ 1, -1, 0 ],[ -1, -1, 0 ],[ -1, 1, 0 ],[ 0, 0, -Sqrt(2.) ] ];;
printRecord := SetVertexCoordiantes3D(oct, verticesPositions, rec());;
DrawSurfaceToJavaScript(oct, "Octahedron_animated.html", printRecord);;
#! <Alt Only="JavaScript">
#!     \input{_HTML_Octahedron.tex}
#! </Alt>
#! @EndChunk

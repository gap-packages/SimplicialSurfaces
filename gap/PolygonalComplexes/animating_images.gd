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
#! Octahedron_animated.html
#! </Alt>
#! @EndChunk



#! @BeginChunk Example_OctahedronAnimatingWithoutVertices
verticesPositions := [ [ 0, 0, Sqrt(2.) ],[ 1, 1, 0 ],[ 1, -1, 0 ],[ -1, -1, 0 ],[ -1, 1, 0 ],[ 0, 0, -Sqrt(2.) ] ];;
printRecord := SetVertexCoordiantes3D(oct, verticesPositions, rec());;
printRecord := DeactivateVertices(oct, printRecord);
DrawSurfaceToJavaScript(oct, "Octahedron_animatedWithoutVertices.html", printRecord);;
#! <Alt Only="JavaScript">
#! Octahedron_animatedWithoutVertices.html
#! </Alt>
#! @EndChunk


#! @BeginChunk Example_OctahedronAnimatingWithoutSomeVertices
verticesPositions := [ [ 0, 0, Sqrt(2.) ],[ 1, 1, 0 ],[ 1, -1, 0 ],[ -1, -1, 0 ],[ -1, 1, 0 ],[ 0, 0, -Sqrt(2.) ] ];;
printRecord := SetVertexCoordiantes3D(oct, verticesPositions, rec());;
printRecord := DeactivateVertices(oct, printRecord);;
printRecord := ActivateVertex(oct, 2, printRecord);;
printRecord := ActivateVertex(oct, 3, printRecord);;
DrawSurfaceToJavaScript(oct, "Octahedron_animatedWithoutSomeVertices.html", printRecord);;
#! <Alt Only="JavaScript">
#! Octahedron_animatedWithoutSomeVertices.html
#! </Alt>
#! @EndChunk


#! @BeginChunk Example_OctahedronEdgeColors
oct := Octahedron();;
verticesPositions := [ [ 0, 0, Sqrt(2.) ],[ 1, 1, 0 ],[ 1, -1, 0 ],[ -1, -1, 0 ],[ -1, 1, 0 ],[ 0, 0, -Sqrt(2.) ] ];;
printRecord := SetVertexCoordiantes3D(oct, verticesPositions, rec());;
printRecord := SetVertexColours(oct,ListWithIdenticalEntries(NumberOfVertices(oct), "green"), printRecord);;
printRecord := SetVertexColour(oct, 3, "red", printRecord);;
DrawSurfaceToJavaScript(oct, "Octahedron_EdgeColors.html", printRecord);;
#! <Alt Only="JavaScript">
#! Octahedron_EdgeColors.html
#! </Alt>
#! @EndChunk

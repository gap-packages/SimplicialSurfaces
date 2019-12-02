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


#! @BeginChunk Example_OctahedronPositionMirrored
oct := Octahedron();;
verticesPositions := [ [ 0, 0, Sqrt(2.) ],[ 1, 1, 0 ],[ 1, -1, 0 ],[ -1, -1, 0 ],[ -1, 1, 0 ],[ 0, 0, -Sqrt(2.) ] ];;
verticesPositionsMirrored := -verticesPositions;;
printRecord := SetVertexCoordiantes3D(oct, verticesPositions, rec());;
printRecord := CalculateParametersOfEdges(oct, printRecord);;
printRecord := SetVertexCoordiantes3D(oct, verticesPositionsMirrored,printRecord);;
printRecord := CalculateParametersOfEdges(oct, printRecord);;
DrawSurfaceToJavaScript(oct, "Octahedron_PositionMirrored.html", printRecord);;
#! <Alt Only="JavaScript">
#! Octahedron_PositionMirrored.html
#! </Alt>
#! @EndChunk


#! @BeginChunk Example_OctahedronInnerCircle
oct := Octahedron();;
verticesPositions := [ [ 0, 0, Sqrt(2.) ],[ 1, 1, 0 ],[ 1, -1, 0 ],[ -1, -1, 0 ],[ -1, 1, 0 ],[ 0, 0, -Sqrt(2.) ] ];;
printRecord := SetVertexCoordiantes3D(oct, verticesPositions, rec());;
printRecord := ActivateInnerCircles(oct,printRecord);
DrawSurfaceToJavaScript(oct, "Octahedron_InnerCircle.html", printRecord);;
#! <Alt Only="JavaScript">
#! Octahedron_InnerCircle.html
#! </Alt>
#! @EndChunk


#! @BeginChunk Example_OctahedronInnerCircleWithoutFaces
oct := Octahedron();;
verticesPositions := [ [ 0, 0, Sqrt(2.) ],[ 1, 1, 0 ],[ 1, -1, 0 ],[ -1, -1, 0 ],[ -1, 1, 0 ],[ 0, 0, -Sqrt(2.) ] ];;
printRecord := SetVertexCoordiantes3D(oct, verticesPositions, rec());;
printRecord := ActivateInnerCircles(oct,printRecord);
printRecord := DeactivateFaces(oct,printRecord);
DrawSurfaceToJavaScript(oct, "Octahedron_InnerCircleWithoutFaces.html", printRecord);;
#! <Alt Only="JavaScript">
#! Octahedron_InnerCircleWithoutFaces.html
#! </Alt>
#! @EndChunk


#! @BeginChunk Example_OctahedronNormalesOfInnerCircle
oct := Octahedron();;
verticesPositions := [ [ 0, 0, Sqrt(2.) ],[ 1, 1, 0 ],[ 1, -1, 0 ],[ -1, -1, 0 ],[ -1, 1, 0 ],[ 0, 0, -Sqrt(2.) ] ];;
printRecord := SetVertexCoordiantes3D(oct, verticesPositions, rec());;
printRecord := ActivateNormalOfInnerCircles(oct,printRecord);
DrawSurfaceToJavaScript(oct, "Octahedron_NormalesOfInnerCircle.html", printRecord);;
#! <Alt Only="JavaScript">
#! Octahedron_NormalesOfInnerCircle.html
#! </Alt>
#! @EndChunk


#! @BeginChunk Example_OctahedronNormalesOfInnerCircleWithoutFaces
oct := Octahedron();;
verticesPositions := [ [ 0, 0, Sqrt(2.) ],[ 1, 1, 0 ],[ 1, -1, 0 ],[ -1, -1, 0 ],[ -1, 1, 0 ],[ 0, 0, -Sqrt(2.) ] ];;
printRecord := SetVertexCoordiantes3D(oct, verticesPositions, rec());;
printRecord := ActivateNormalOfInnerCircles(oct,printRecord);
printRecord := DeactivateFaces(oct,printRecord);
DrawSurfaceToJavaScript(oct, "Octahedron_NormalesOfInnerCircleWithoutFaces.html", printRecord);;
#! <Alt Only="JavaScript">
#! Octahedron_NormalesOfInnerCircleWithoutFaces.html
#! </Alt>
#! @EndChunk

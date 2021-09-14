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

##
## WARNING: This file should NOT be read if the package is loaded.
## It contains examples for the manual and should only be used then.
##
if not __SIMPLICIAL_MANUAL_MODE then
    Error("The file 'library_images.gd' should only be read to generate the manual.");
fi;

# The examples consist of a picture in 3D (if advisable), the GAP-code to 
# create the surface and the image of the net.

#! @BeginChunk Example_JanusHead
#! @BeginExample
janus := JanusHead();;
#! @EndExample
pr := rec( scale := 2.5, edgeDrawOrder := [3] );
DrawSurfaceToTikz(janus, "Janus_constructor", pr);;
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Janus_constructor.tex}
#! </Alt>
#! @EndChunk

#! @BeginChunk Example_Tetrahedron
#! @BeginExample
tetra := Tetrahedron();;
#! @EndExample
pr := rec( scale := 2.5 );
DrawSurfaceToTikz(tetra, "Tetrahedron_constructor", pr);;
pr := rec( scale := 2.5, vertexLabels:=[1,2,3,4], edgeLabels:=[5,6,7,8,9,10], faceLabels:=[11,12,13,14] );
DrawSurfaceToTikz(tetra, "Tetrahedron_constructor_labelShift", pr);
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Tetrahedron_constructor.tex}
#! </Alt>
#! @EndChunk

#! @BeginChunk Example_Cube
#! @BeginExample
cube := Cube();;
#! @EndExample
pr := rec();
DrawSurfaceToTikz(cube, "Cube_constructor", pr);;
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Cube_constructor.tex}
#! </Alt>
#! @EndChunk

#! @BeginChunk Example_Octahedron
#! @BeginExample
octa := Octahedron();;
#! @EndExample
pr := rec( scale := 2.5 );
DrawSurfaceToTikz(octa, "Octahedron_constructor", pr);;
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Octahedron_constructor.tex}
#! </Alt>
#! @EndChunk

#! @BeginChunk Example_Dodecahedron
#! @BeginExample
dode := Dodecahedron();;
#! @EndExample
pr := rec( edgeDrawOrder := [1,2,4,6,8,22,18,12,15,19,28] );
DrawSurfaceToTikz(dode, "Dodecahedron_constructor", pr);;
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Dodecahedron_constructor.tex}
#! </Alt>
#! @EndChunk

#! @BeginChunk Example_Icosahedron
#! @BeginExample
ico := Icosahedron();;
#! @EndExample
pr := rec( scale := 2.5, edgeDrawOrder := [1,7,9,21,23,3,4,16,19,28,5,20,8,22,13,14,25,18,29] );
DrawSurfaceToTikz(ico, "Icosahedron_constructor", pr);;
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Icosahedron_constructor.tex}
#! </Alt>
#! @EndChunk

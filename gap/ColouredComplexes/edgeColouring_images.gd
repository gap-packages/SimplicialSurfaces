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


##
## WARNING: This file should NOT be read if the package is loaded.
## It contains examples for the manual and should only be used then.
##
if not __SIMPLICIAL_MANUAL_MODE then
    Error("The file 'edgeColouring_images.gd' should only be read to generate the manual.");
fi;


#! @BeginChunk Example_Coloured_Pyramid
#! As an illustration we consider a pyramid with square base.
#! @BeginExample
pyr := PolygonalSurfaceByDownwardIncidence(
    [ , [1,2], [2,3], [3,4], [1,4], [2,10], [3,10], [4,10], [1,10] ],
    [ [2,3,4,5], , [2,6,9], [3,6,7], [4,7,8], [5,8,9] ] );;
#! @EndExample
#! We would like to colour the edges in the following way:
pr := rec( scale := 2.5, edgeColours := [,"blue","red","red","blue","green","red","green","blue"] );
DrawSurfaceToTikz( pyr, "Pyramid_coloured", pr );
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Pyramid_coloured-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_Pyramid_coloured.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! To do that we describe the colours by positive integers (for example 1,2,4).
#! We can encode the edge colouring in two ways:
#! <Enum>
#!   <Item>We can give a list that encodes which edge has which colour.
#! @BeginExample
colOfEdges := [,2,1,1,2,4,1,4,2];
#! [ , 2, 1, 1, 2, 4, 1, 4, 2 ]
#! @EndExample
#!   The entry at position <A>edge</A> denotes the colour of <A>edge</A>.
#!   </Item>
#!   <Item>We can give a edge colour class for each colour (as list).
#! @BeginExample
colClasses := [ [ 3, 4, 7 ], [ 2, 5, 9 ],, [ 6, 8 ] ];
#! [ [ 3, 4, 7 ], [ 2, 5, 9 ],, [ 6, 8 ] ]
#! @EndExample
#!   </Item>
#! </Enum>
#!
#! Both of those can be used to construct the edge coloured polygonal complex:
#! @BeginExample
colPyr := EdgeColouredPolygonalComplex( pyr, colOfEdges );;
colPyrAlt := EdgeColouredPolygonalComplex( pyr, colClasses );;
colPyr = colPyrAlt;
#! true
#! @EndExamples
#! Both the polygonal surface and the colouring can be accessed.
#! @BeginExample
PolygonalComplex(colPyr) = pyr;
#! true
ColoursOfEdges(colPyr) = colOfEdges;
#! true
EdgesOfColours(colPyr) = colClasses;
#! true
#! @EndExample
#! A quick access to the used colours is also available:
#! @BeginExample
Colours(colPyr);
#! [ 1, 2, 4 ]
#! @EndExample
#! @EndChunk

 
#! @BeginChunk Example_TwiceColoured_Pyramid
#! As illustration we colour the pyramid from the start of section
#! <Ref Sect="Section_EdgeColouring_Definition"/> in two different ways and
#! use both ways of encoding the colouring.
#! @BeginExample
pyr := PolygonalSurfaceByDownwardIncidence(
    [ , [1,2], [2,3], [3,4], [1,4], [2,10], [3,10], [4,10], [1,10] ],
    [ [2,3,4,5], , [2,6,9], [3,6,7], [4,7,8], [5,8,9] ] );;
#! @EndExample
DrawSurfaceToTikz( pyr, "Pyramid_uncoloured", rec(scale:=2.5, edgeColours:="black") );
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Pyramid_uncoloured-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_Pyramid_uncoloured.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! We use the first method of encoding the colouring (based on the edges):
#! @BeginExample
colPyr1 := EdgeColouredPolygonalComplex(pyr, [,2,1,1,2,3,1,3,2]);;
#! @EndExample
DrawSurfaceToTikz( colPyr1, "Pyramid_coloured_1", rec(scale:=2.5, edgeColourClassColours:=["red","blue","green"]) );
#! <Alt Only="TikZ">
#!  \input{_TIKZ_Pyramid_coloured_1.tex}
#! </Alt>
#! We can also pick a different colouring which we will define by the
#! second method of encoding:
#! @BeginExample
colPyr2 := EdgeColouredPolygonalComplex(pyr, [[2,6],[3,7],,[4,8],[5,9]]);;
#! @EndExample
DrawSurfaceToTikz( colPyr2, "Pyramid_coloured_2", rec(scale:=2.5, edgeColourClassColours:=["red","cyan",,"olive","green"]) );
#! <Alt Only="TikZ">
#!  \input{_TIKZ_Pyramid_coloured_2.tex}
#! </Alt>
#! @EndChunk


#! @BeginChunk Example_ColoursOfEdges_Pyramid
#! For example consider the coloured pyramid from the start of section
#! <Ref Sect="Section_EdgeColouring_Definition"/>.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Pyramid_coloured-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_Pyramid_coloured.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExample
ColourOfEdge( colPyr, 2 );
#! 2
ColourOfEdge( colPyr, 7);
#! 1
ColoursOfEdges( colPyr );
#! [ , 2, 1, 1, 2, 4, 1, 4, 2 ]
#! @EndExample
#! @EndChunk


#! @BeginChunk Example_EdgesOfColours_Pyramid
#! For example consider the coloured pyramid from the start of section
#! <Ref Sect="Section_EdgeColouring_Definition"/>.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Pyramid_coloured-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_Pyramid_coloured.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExample
EdgesOfColour( colPyr, 1 );
#! [ 3, 4, 7 ]
EdgesOfColour( colPyr, 4);
#! [ 6, 8 ]
EdgesOfColour( colPyr, 5 );
#! []
EdgesOfColours( colPyr );
#! [ [ 3, 4, 7 ], [ 2, 5, 9 ],, [ 6, 8 ] ]
#! @EndExample
#! @EndChunk


#! @BeginChunk Example_EdgeColouring_Drawing
#! The drawing functionality for ramified polygonal surfaces
#! in section <Ref Sect="Section_Embeddings_DrawTikz"/> can also be used
#! for edge coloured polygonal complexes (as long as the underlying
#! polygonal complex is a ramified polygonal surface).
#!
#! The main difference to the previous method is that it is much more
#! convenient to change edge lengths and colours. Consider for example
#! a coloured tetrahedron.
#! @BeginLog
tetra := Tetrahedron();;
colTetra := EdgeColouredPolygonalComplex(tetra, [1,2,3,3,2,1]);;
pr := DrawSurfaceToTikz( colTetra, "ColouredTetrahedron", rec(scale:=2.5) );;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_ColouredTetrahedron-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_ColouredTetrahedron.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! If we now want to change edge lengths (such that edges of the same
#! colour have the same length), we can do this very easily:
#! @BeginLog
pr.edgeColourClassLengths := [5,4,3];;
pr.scale := 1;;
DrawSurfaceToTikz( colTetra, "ColouredTetrahedron_rectangular", pr );;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_ColouredTetrahedron_rectangular-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_ColouredTetrahedron_rectangular.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! The colours can also be changed in the same fashion.
#! @BeginLog
pr.edgeColourClassColours := ["cyan","olive","magenta"];
DrawSurfaceToTikz( colTetra, "ColouredTetrahedron_coloured", pr );
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_ColouredTetrahedron_coloured-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_ColouredTetrahedron_coloured.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!
#! While it is very easy to modify all edges of the same colour 
#! simultaneously, it becomes harder to change them individually.
#! For example we can't just make the first and fourth edge longer.
#! @BeginLog
pr.edgeLengths;
#! [ 5, 4, 3, 3, 4, 5 ]
pr.edgeLengths := [4,4,3,4,4,5];;
DrawSurfaceToTikz( colTetra, "ColouredTetrahedron_modLengths", pr );
pr.edgeLengths;
#! [ 5, 4, 3, 3, 4, 5 ]
#! @EndLog
#! To change individual edges the colour connection has to be ignored.
#! This is possible by using the entry <A>edgeColourClassActive</A>.
#! @BeginLog
pr.edgeColourClassActive := false;;
pr.edgeLengths := [4,4,3,4,4,5];;
DrawSurfaceToTikz( colTetra, "ColouredTetrahedron_modLengths", pr );
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_ColouredTetrahedron_modLengths-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_ColouredTetrahedron_modLengths.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @EndChunk

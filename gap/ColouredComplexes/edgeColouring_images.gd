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
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Pyramid_coloured.tex}
#! </Alt>
#! To do that we encode the colours as positive integers (for example 1,2,3).
#! Then we need a list that encodes which edge has which colour.
#! @BeginExample
colOfEdges := [,2,1,1,2,3,1,3,2];
#! [ , 2, 1, 1, 2, 3, 1, 3, 2 ]
#! @EndExample
#! The entry at position <A>edge</A> denotes the colour of <A>edge</A>.
#!
#! The edge coloured polygonal complex can be constructed as follows:
#! @BeginExample
colPyr := EdgeColouredPolygonalComplex( pyr, colOfEdges );;
#! @EndExamples
#! Both the polygonal surface and the colouring can be accessed.
#! @BeginExample
PolygonalComplex(colPyr) = pyr;
#! true
ColoursOfEdges(colPyr) = colOfEdges;
#! true
#! @EndExample
#! We can even look at the equivalence classes of edges with the
#! same colour.
#! @BeginExample
EdgesOfColours(colPyr);
#! [ [ 3, 4, 7 ], [ 2, 5, 9 ], [ 6, 8 ] ]
#! @EndExample
#! @EndChunk


#! @BeginChunk Example_TwiceColoured_Pyramid
#! As illustration we colour the pyramid from the start of section
#! <Ref Sect="Section_EdgeColouring_Definition"/> in two different ways.
#! @BeginExample
pyr := PolygonalSurfaceByDownwardIncidence(
    [ , [1,2], [2,3], [3,4], [1,4], [2,10], [3,10], [4,10], [1,10] ],
    [ [2,3,4,5], , [2,6,9], [3,6,7], [4,7,8], [5,8,9] ] );;
#! @EndExample
DrawSurfaceToTikz( pyr, "Pyramid_uncoloured", rec(scale:=2.5) );
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Pyramid_uncoloured.tex}
#! </Alt>
#! @BeginExample
colPyr1 := EdgeColouredPolygonalComplex(pyr, [,2,1,1,2,3,1,3,2]);;
#! @EndExample
DrawSurfaceToTikz( colPyr1, "Pyramid_coloured_1", rec(scale:=2.5, edgeColourClassColours:=["red","blue","green"]) );
#! <Alt Only="TikZ">
#!  \input{_TIKZ_Pyramid_coloured_1.tex}
#! </Alt>
#! @BeginExample
colPyr2 := EdgeColouredPolygonalComplex(pyr, [,1,2,3,4,1,2,3,4]);;
#! @EndExample
DrawSurfaceToTikz( colPyr2, "Pyramid_coloured_2", rec(scale:=2.5, edgeColourClassColours:=["red","cyan","green","purple"]) );
#! <Alt Only="TikZ">
#!  \input{_TIKZ_Pyramid_coloured_2.tex}
#! </Alt>
#! @EndChunk


#! @BeginChunk Example_ColoursOfEdges_Pyramid
#! For example consider the coloured pyramid from the start of section
#! <Ref Sect="Section_EdgeColouring_Definition"/>.
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Pyramid_coloured.tex}
#! </Alt>
#! @BeginExample
ColourOfEdge( colPyr, 2 );
#! 2
ColourOfEdge( colPyr, 7);
#! 1
ColoursOfEdges( colPyr );
#! [ , 2, 1, 1, 2, 3, 1, 3, 2 ]
#! @EndExample
#! @EndChunk


#! @BeginChunk Example_EdgesOfColours_Pyramid
#! For example consider the coloured pyramid from the start of section
#! <Ref Sect="Section_EdgeColouring_Definition"/>.
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Pyramid_coloured.tex}
#! </Alt>
#! @BeginExample
EdgesOfColour( colPyr, 1 );
#! [ 3, 4, 7 ]
EdgesOfColour( colPyr, 3);
#! [ 6, 8 ]
EdgesOfColour( colPyr, 5 );
#! []
EdgesOfColours( colPyr );
#! [ [ 3, 4, 7 ], [ 2, 5, 9 ], [ 6, 8 ] ]
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
#! <Alt Only="TikZ">
#!   \input{_TIKZ_ColouredTetrahedron.tex}
#! </Alt>
#! If we now want to change edge lengths (such that edges of the same
#! colour have the same length), we can do this very easily:
#! @BeginLog
pr.edgeColourClassLengths := [5,4,3];;
pr.scale := 1;;
DrawSurfaceToTikz( colTetra, "ColouredTetrahedron_rectangular", pr );;
#! @EndLog
#! <Alt Only="TikZ">
#!   \input{_TIKZ_ColouredTetrahedron_rectangular.tex}
#! </Alt>
#! The colours can also be changed in the same fashion.
#! @BeginLog
pr.edgeColourClassColours := ["cyan","olive","violet"];
DrawSurfaceToTikz( colTetra, "ColouredTetrahedron_coloured", pr );
#! @EndLog
#! <Alt Only="TikZ">
#!   \input{_TIKZ_ColouredTetrahedron_coloured.tex}
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
#! This is possible by using the entry <A>edgeColourClassIgnored</A>.
#! @BeginLog
pr.edgeColourClassActive := false;;
pr.edgeLengths := [4,4,3,4,4,5];;
DrawSurfaceToTikz( colTetra, "ColouredTetrahedron_modLengths", pr );
#! @EndLog
#! <Alt Only="TikZ">
#!   \input{_TIKZ_ColouredTetrahedron_modLengths.tex}
#! </Alt>
#! @EndChunk

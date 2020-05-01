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
#! @BeginLog
oct := Octahedron();;
colOct := EdgeColouredPolygonalComplex( oct, [1,1,1,1,2,2,1,2,1,2,1,1]);;
IsIsoscelesColouredSurface(colOct);
#! @EndLog
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



#! @BeginChunk Example_Isosceles_ColourInvolutions
#! We consider again the isosceles coloured octahedron from the start of the section.
#! @BeginLog
ColourInvolutions( colOct );
#! @EndLog
#! The involutions correspond to a wild coloured surface on twice as many faces.
#! Note that the first involution encodes the base coloured edges of this wild coloured surface,
#! the second involution encodes the leg coloured edges and the 
#! the third involution encodes the edges coloured in a third colour. These edges subdivide
#! the original faces.
#! @EndChunk

#! @BeginChunk Example_WildIsosceles
#! We consider again the isosceles coloured octahedron from the start of the section.
#! @BeginExample
oct := Octahedron();;
colOct := EdgeColouredPolygonalComplex( oct, [1,1,1,1,2,2,1,2,1,2,1,1]);;
wildOct := WildColouredSurfaceOfIsoscelesColouredSurface(colOct);
#! @EndExample
#! This subdivided surface be drawn with <K>DrawSurfaceToTikz</K> 
#! (<Ref Subsect="DrawSurfaceToTikz_EdgeColoured"/>).
#! @BeginLog
pr := rec( edgeColourClassColours := ["red", "blue", "green"],
edgeColourClassLengths := [1.2,0.4,1.13137],
edgeLabelsActive := false );;
DrawSurfaceToTikz(wildOct, "Octahedron_WildIsosceles", pr );;
#! @EndLog
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Octahedron_WildIsosceles.tex}
#! </Alt>
#! @EndChunk


#! @BeginChunk Example_All_Isosceles 
#! We determine all possible isosceles colourings of a surface with 10 faces
#! @BeginLog
surf := SimplicialSurfaceByVerticesInFaces( [ [ 1, 4, 5 ], [ 1, 4, 6 ], [ 1, 5, 7 ],
[ 1, 6, 7 ], [ 2, 3, 5 ], [ 2, 3, 6 ], [ 2, 4, 5 ], [ 2, 4, 6 ], [ 3, 5, 7 ], [ 3, 6, 7 ] ] );
isosceles := AllIsoscelesColouredSurfaces(surf);
#! @EndLog
#! We now see that not all of these arise from wild colourings. For this we also
#! determine the wild colourings and compare them
#! @BeginLog
wilds := AllWildColouredSurfaces(surf);
wild := wilds[1];
#! @EndLog
#! To see why there is only one wild colouring, we draw the surfaces
#! @BeginLog
pr := rec( edgeColourClassColours := ["red", "blue"],
 edgeColourClassLengths := [1.2,0.8] );;
pr := DrawSurfaceToTikz( isosceles[1], "Surf10_Isosc1", pr );;
pr := rec( edgeColourClassColours := ["red", "blue"],
 edgeColourClassLengths := [1.2,0.8] );;
 pr := DrawSurfaceToTikz( isosceles[2], "Surf10_Isosc2", pr );;
pr := rec( edgeColourClassColours := ["red", "blue"],
 edgeColourClassLengths := [1.2,0.8] );;
 pr := DrawSurfaceToTikz( isosceles[3], "Surf10_Isosc3", pr );;
pr := rec( edgeColourClassColours := ["red", "blue", "green"]);
pr := DrawSurfaceToTikz( wild, "Surf10_Wild", pr );;
#! @EndLog
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Surf10_Isosc1.tex}
#!   \input{_TIKZ_Surf10_Isosc2.tex}
#! </Alt>
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Surf10_Isosc3.tex}
#!   \input{_TIKZ_Surf10_Wild.tex}
#! </Alt>
#! It can easily be seen that the third isosceles coloured surface cannot arise
#! from identifying two colours of a wild coloured surface: Note that vertex 5 has
#! degree 5 and all edges of this vertex are coloured red. If this isosceles colouring had
#! arisen from a wild colouring, then two of the wild colours would have had to be
#! identified to become the red colour. However, there is no assignment of
#! two colours to a vertex of degree 5 that arises from a wild colouring, as in a
#! wild colouring the two colours have to alternate.
#! @EndChunk



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
#! @BeginExample
oct := Octahedron();;
colOct := EdgeColouredPolygonalComplex( oct, [1,1,1,1,2,2,1,2,1,2,1,1]);;
IsIsoscelesColouredSurface(colOct);
#! true
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


#! @BeginChunk Example_WildIsosceles
#! We consider again the isosceles coloured octahedron from the start of the section.
#! @BeginExampleSession
#! gap> oct := Octahedron();;
#! gap> colOct := EdgeColouredPolygonalComplex( oct, [1,1,1,1,2,2,1,2,1,2,1,1]);;
#! gap> wildOct := WildColouredSurfaceOfIsoscelesColouredSurface(colOct);
#! tame coloured surface (MMM with 10 vertices, 24 edges and 16 faces)
#! @EndExampleSession
#! This subdivided surface be drawn with <K>DrawSurfaceToTikz</K> 
#! (<Ref Subsect="DrawSurfaceToTikz_EdgeColoured"/>).
#! @BeginLog
oct := Octahedron();;
colOct := EdgeColouredPolygonalComplex( oct, [1,1,1,1,2,2,1,2,1,2,1,1]);;
wildOct := WildColouredSurfaceOfIsoscelesColouredSurface(colOct);;
pr := rec( edgeColourClassColours := ["red", "blue", "green"],
edgeColourClassLengths := [1.2,0.4,1.13137],
edgeLabelsActive := false );;
DrawSurfaceToTikz(wildOct, "Octahedron_WildIsosceles", pr );;
#! @EndLog
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Octahedron_WildIsosceles.tex}
#! </Alt>
#! @EndChunk


#! @BeginChunk Example_Isosceles_ColourInvolutions
#! We consider again the isosceles coloured octahedron from the start of the section.
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Oct_isosccoloured.tex}
#! </Alt>
#! @BeginExample
ColourInvolutions( colOct );
#! [ (1,4)(2,3)(5,8)(6,7)(9,12)(10,11)(13,16)(14,15), 
#!  (1,3)(2,4)(5,15)(6,12)(7,9)(8,14)(10,16)(11,13), 
#!  (1,9)(2,10)(3,11)(4,12)(5,13)(6,14)(7,15)(8,16) ]
#! @EndExample
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Octahedron_WildIsosceles.tex}
#! </Alt>
#! The involutions correspond to a wild coloured surface on twice as many faces.
#! Note that the first involution encodes the base coloured edges of this wild coloured surface,
#! the second involution encodes the leg coloured edges and the 
#! the third involution encodes the edges coloured in a third colour. These edges subdivide
#! the original faces.
#! @EndChunk



#! @BeginChunk Example_All_Isosceles 
#! We determine up to isomorphism all possible isosceles colourings of a surface with 
#! 10 faces.
#! @BeginExample
surf := SimplicialSurfaceByVerticesInFaces( [ [ 1, 4, 5 ], 
[ 1, 4, 6 ], [ 1, 5, 7 ], [ 1, 6, 7 ], [ 2, 3, 5 ], [ 2, 3, 6 ], 
[ 2, 4, 5 ], [ 2, 4, 6 ], [ 3, 5, 7 ], [ 3, 6, 7 ] ] );;
isosceles := AllIsoscelesColouredSurfaces(surf);;
isosceles := EdgeColouredPolygonalComplexIsomorphismRepresentatives(isosceles);;
Size(isosceles);
#! 3
#! @EndExample
#! Given a wild coloured surface, one can find an isosceles coloured surface by
#! identifying two of the three colours. However, not every isosceles coloured
#! surface arises in this way from a wild coloured surface. 
#! For this we also determine the wild colourings and compare them.
#! @BeginExample
wilds := AllWildColouredSurfaces(surf);;
wilds := EdgeColouredPolygonalComplexIsomorphismRepresentatives(wilds);;
Size(wilds);
#! 1
wild := wilds[1];
#! wild coloured surface (7 vertices, 15 edges and 10 faces)
#! @EndExample
#! To see why there is only one wild colouring, but three isosceles colourings, 
#! we draw the surfaces:
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
#! It can easily be seen that the first and third isosceles coloured surface cannot arise
#! from identifying two colours of a wild coloured surface: Note that each has a vertex of 
#! degree 5 and all edges of this vertex are coloured red. If this isosceles colouring had
#! arisen from a wild colouring, then two of the wild colours would have had to be
#! identified to become the red colour. However, there is no assignment of
#! two colours to a vertex of degree 5 that arises from a wild colouring, as in a
#! wild colouring the two colours have to alternate.
#! @EndChunk


#! @BeginChunk Example_IsoscelesIcosahedron
#! @BeginExample
ico := Icosahedron();;
colIco := AllIsoscelesColouredSurfaces(ico)[1];;
VertexCounterByAngle( colIco );
#! [ [ [ [ 1, 4 ], [ 2, 1 ] ], 10 ], [ [ [ 2, 5 ] ], 2 ] ]
#! @EndExample
#! This can be drawn by <K>DrawSurfaceToTikz</K> 
#! (<Ref Subsect="DrawSurfaceToTikz_EdgeColoured"/>).
#! @BeginLog
pr := rec( edgeColourClassColours := ["red", "blue"],
edgeColourClassLengths := [1.2,0.8] );;
DrawSurfaceToTikz(colIco, "Ico_isosccoloured", pr );;
#! @EndLog
#!  The example shows that there are two types of vertices in the given colouring
#! of the icosahedron. Vertices of the first type contain 4 angles between
#! edges whose opposite edge has colour "1" (red) and one angle whose opposite
#! edge has colour "2" (blue).  Vertex 2 is an example of such a vertex.
#! The vertices of the second type contain five equal angles and the opposite edges 
#! have colour "2" (blue). Vertex 1 is an example of such a vertex.
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Ico_isosccoloured.tex}
#! </Alt>
#! @EndChunk



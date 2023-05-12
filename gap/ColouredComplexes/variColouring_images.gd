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
    Error("The file 'variColouring_images.gd' should only be read to generate the manual.");
fi;


#! @BeginChunk Example_ColouredPrism
#! We will illustrate all of these on a prism with triangular base.
#! @BeginExample
prism := PolygonalSurfaceByDownwardIncidence( 
    [[2,3],[1,3],[1,2],[1,7],[2,8],[3,9],[8,9],[7,9],[7,8]],
    [[1,3,2],,[3,5,9,4],[1,6,7,5],[2,4,8,6],,[7,8,9]]);;
colPrism := EdgeColouredPolygonalComplex(prism, [1,4,2,1,5,2,4,5,3]);;
#! @EndExample
#! This can be drawn by <K>DrawSurfaceToTikz</K> 
#! (<Ref Subsect="DrawSurfaceToTikz_EdgeColoured"/>).
#! @BeginLog
pr := rec( edgeDrawOrder := [1,5,6,7], 
    edgeColourClassColours :=  ["magenta", "cyan", "olive", "lime", "pink"] );;
DrawSurfaceToTikz(colPrism, "Prism_coloured", pr );;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Prism_coloured-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_Prism_coloured.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @EndChunk


#! @BeginChunk Example_ColouredDisk
#! For example, consider a coloured disk (that has a boundary).
#! @BeginExample
disk := PolygonalSurfaceByDownwardIncidence(
    [[1,4],[1,2],[2,3],[3,4],[1,5],[1,6],[2,7],[2,8],[3,9],[3,10],
        [4,11],[4,12],[5,6],[6,7],[7,8],[8,9],[9,10],[10,11],[11,12],[5,12]],
    [[13,6,5],[14,7,2,6],[15,8,7],[5,1,12,20],[2,3,4,1],
        [8,16,9,3],[12,11,19],[4,10,18,11],[9,17,10]] );;
IsClosedSurface(disk);
#! false
colDisk := EdgeColouredPolygonalComplex(disk, 
    [[13,15,17,19],,[5,2,8,18],[14,12,4,9],[20,7,3,10],[6,1,11,16]] );;
IsEdgeVariColouring(colDisk);
#! true
#! @EndExample
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_ColouredDisk-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_ColouredDisk.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
DrawSurfaceToTikz( colDisk, "ColouredDisk", rec(
    edgeColourClassColours := ["green",,"red","pink","teal","cyan"],
    edgeColourClassLengths := [Hypothenuse(1.,1.),,1,1,1,1],
    scale := 2) );
#! The colour 3 (red in the picture) corresponds to the involution
#! <M>(1,4)(2,5)(3,6)</M>, while the colour 1 (green in the picture) induces
#! the trivial permutation since all of its edges are boundary edges. The 
#! permutations can be accessed by the <K>ColourInvolutions</K>-methods
#! (<Ref Subsect="ColourInvolutions"/>):
#! @BeginExample
ColourInvolutions(colDisk);
#! [ (),, (1,4)(2,5)(3,6), (4,7)(5,8)(6,9), (2,3)(5,6)(8,9), (1,2)(4,5)(7,8) ]
#! @EndExample
#! @EndChunk

#! @BeginChunk Example_ColouredDisk_ColourInvolutions
#! This can be seen on the example from the start of section 
#! <Ref Sect="Section_EdgeVariColouring_Permutations"/>.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_ColouredDisk-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_ColouredDisk.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExample
ColourInvolutions(colDisk);
#! [ (),, (1,4)(2,5)(3,6), (4,7)(5,8)(6,9), (2,3)(5,6)(8,9), (1,2)(4,5)(7,8) ]
#! @EndExample
#! @EndChunk

#! @BeginChunk Example_ColouredTetrahedron_IsWildColoured
#! For example, consider the tetrahedron. This colouring is a wild colouring of the tetrahedron:
#! @BeginExample
wildColTetra:=EdgeColouredSimplicialSurface(Tetrahedron(),[1,2,3,3,2,1]);;
IsWildColouredSurface(wildColTetra);
#! true
#! @EndExample
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_WildColTetra-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_WildColTetra.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
DrawSurfaceToTikz( wildColTetra, "WildColTetra", rec(
   edgeColourClassColours := ["green","red","blue"],
           scale := 2) );
#! This colouring of the tetrahedron is an example for a coloring that is not a wild colouring:
#! @BeginExample
colTetra:=EdgeColouredSimplicialSurface(Tetrahedron(),[1,2,3,3,2,2]);;
IsWildColouredSurface(colTetra);
#! false
#! @EndExample
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_NotWildColTetra-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_NotWildColTetra.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
DrawSurfaceToTikz( colTetra, "NotWildColTetra", rec(
    edgeColourClassColours := ["green","red","blue"],
            scale := 2) );
#! Using four colours leads to a colouring that is not a wild colouring:
#! @BeginExample
colFourTetra:=EdgeColouredSimplicialSurface(Tetrahedron(),[1,2,3,3,2,4]);;
IsWildColouredSurface(colFourTetra);
#! false
#! @EndExample
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_NotWildColTetraFour-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_NotWildColTetraFour.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
DrawSurfaceToTikz( colFourTetra, "NotWildColTetraFour", rec(
    edgeColourClassColours := ["green","red","blue","pink"],
            scale := 2) );
#! @EndChunk

#! @BeginChunk Example_TameColoured
#! For example, consider the octahedron:
#! @BeginExample
oct := AllWildColouredSurfaces(Octahedron());;
IsTameColouredSurface(oct[1]);
#! true
LocalSymmetryOfColours(oct[1]);
#! [ "mirror", "mirror", "mirror" ]
LocalSymmetryOfEdgesAsNumbers(oct[1]);
#! [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
IsTameColouredSurface(oct[1]);
#! true
LocalSymmetryOfColours(oct[2]);
#! [ "mirror", "rotation", "mirror" ]
LocalSymmetryOfEdgesAsNumbers(oct[2]);
#! [ 1, 2, 1, 2, 1, 1, 1, 1, 2, 1, 1, 2 ]
#! @EndExample
#! Consider the following edge coloured surface:
#! @BeginExample
surface:=SimplicialSurfaceByDownwardIncidence(
  [[1,2],[1,3],[2,3],[2,4],[3,4],[3,5],[4,5],[2,4],[2,5],[1,5]],
  [[1,2,3],[3,4,5],[5,6,7],[7,8,9],[9,10,1]]);;
colSurface:=EdgeColouredSimplicialSurface(surface,[1,2,3,2,1,3,2,1,3,2]);;
IsTameColouredSurface(colSurface);
#! false
#! @EndExample
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_NotTameCol-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_NotTameCol.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
DrawSurfaceToTikz( colSurface, "NotTameCol", rec(
    edgeColourClassColours := ["green","red","blue"],
                scale := 2) );
#! This is an example for a surface which is not tame coloured, since the blue edges do not have the same symmetry.
#! @EndChunk

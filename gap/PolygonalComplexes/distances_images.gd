
##
## WARNING: This file should NOT be read if the package is loaded.
## It contains examples for the manual and should only be used then.
##
if not __SIMPLICIAL_MANUAL_MODE then
    Error("The file 'distances_images.gd' should only be read to generate the manual.");
fi;



#! @BeginChunk Example_TwoDisjointTriangles
#! 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_theTwoDisjointTriangles-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_theTwoDisjointTriangles.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
DrawSurfaceToTikz(SimplicialSurfaceByDownwardIncidenceNC([[1,2],
[2,3],[1,3],[4,5],[5,6],[4,6]],[[1,2,3],[4,5,6]]),"theTwoDisjointTriangles");
#! @EndChunk

#! @BeginChunk Example_Triangle
#! 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_theTriangle-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_theTriangle.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
DrawSurfaceToTikz(SimplicialSurfaceByDownwardIncidenceNC([[1,2],[2,3],[1,3]],
[[1,2,3]]),"theTriangle");
#! @EndChunk

#! @BeginChunk Example_RestrSurf
#! 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_theRestrSurf-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_theRestrSurf.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
DrawSurfaceToTikz(RestrictionToNeighbourhoodOfFacesNC(Cube(),1,[1]),"theRestrSurf");
#! @EndChunk

#! @BeginChunk Example_RestrIco
#! 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_theRestrIco-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_theRestrIco.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
restrictionOne := RestrictionToNeighbourhoodOfFacesNC(Icosahedron(),2,[4]);;
pr.edgeDrawOrder := [4,3,13,5,2,10,16,18,19];
DrawSurfaceToTikz(restrictionOne,"theRestrIco",pr);
#! @EndChunk

#! @BeginChunk Example_RestrOcta
#! 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_theRestrOcta-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_theRestrOcta.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
DrawSurfaceToTikz(RestrictionToNeighbourhoodOfVerticesNC(Octahedron(),1,[1]),"theRestrOcta");
#! @EndChunk

#! @BeginChunk Example_RestrIcoOne
#! 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_theRestrIcoOne-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_theRestrIcoOne.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
DrawSurfaceToTikz(RestrictionToNeighbourhoodOfVerticesNC(Icosahedron(),1,[4]),"theRestrIcoOne");
#! @EndChunk

#! @BeginChunk Example_RestrIcoTwo
#! 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_theRestrIcoTwo-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_theRestrIcoTwo.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
restrictionTwo := RestrictionToNeighbourhoodOfVerticesNC(Icosahedron(),2,[4]);;
pr.edgeDrawOrder := [3,7,13,14,17,4,1,9,24,26,16,2,8,25];
DrawSurfaceToTikz(restrictionTwo,"theRestrIcoTwo",pr);
#! @EndChunk

#! @BeginChunk Example_Square
#! 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_theSquare-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_theSquare.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExample
mySquare := PolygonalSurfaceByDownwardIncidenceNC([[1,2],[2,3],[3,4],[4,1]],
[[1,2,3,4]]);;
#! @EndExample
DrawSurfaceToTikz(mySquare,"theSquare");
#! @EndChunk

#! @BeginChunk Example_Bat
#! 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_theBat-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_theBat.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
DrawSurfaceToTikz(SimplicialSurfaceByDownwardIncidenceNC([[1,2],[1,3],[2,3],[2,4],[3,4],
[3,5],[4,5],[5,6],[4,6],[4,7],[6,7],[6,8],[7,8]],[[1,2,3],[3,4,5],[5,6,7],
[7,8,9],[9,10,11],[11,12,13]]),"theBat");
#! @EndChunk

#! @BeginChunk Example_TwoDisjointTriangles
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theTwoDisjointTriangles.tex}
#! </Alt>
DrawSurfaceToTikz(SimplicialSurfaceByDownwardIncidenceNC([[1,2],
[2,3],[1,3],[4,5],[5,6],[4,6]],[[1,2,3],[4,5,6]]),"theTwoDisjointTriangles");
#! @EndChunk

#! @BeginChunk Example_Triangle
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theTriangle.tex}
#! </Alt>
DrawSurfaceToTikz(SimplicialSurfaceByDownwardIncidenceNC([[1,2],[2,3],[1,3]],
[[1,2,3]]),"theTriangle");
#! @EndChunk

#! @BeginChunk Example_RestrSurf
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theRestrSurf.tex}
#! </Alt>
DrawSurfaceToTikz(RestrictionToNeighbourhoodOfFacesNC(Cube(),1,[1]),"theRestrSurf");
#! @EndChunk

#! @BeginChunk Example_RestrIco
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theRestrIco.tex}
#! </Alt>
restrictionOne := RestrictionToNeighbourhoodOfFacesNC(Icosahedron(),2,[4]);;
pr.edgeDrawOrder := [4,3,13,5,2,10,16,18,19];
DrawSurfaceToTikz(restrictionOne,"theRestrIco",pr);
#! @EndChunk

#! @BeginChunk Example_RestrOcta
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theRestrOcta.tex}
#! </Alt>
DrawSurfaceToTikz(RestrictionToNeighbourhoodOfVerticesNC(Octahedron(),1,[1]),"theRestrOcta");
#! @EndChunk

#! @BeginChunk Example_RestrIcoOne
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theRestrIcoOne.tex}
#! </Alt>
DrawSurfaceToTikz(RestrictionToNeighbourhoodOfVerticesNC(Icosahedron(),1,[4]),"theRestrIcoOne");
#! @EndChunk

#! @BeginChunk Example_RestrIcoTwo
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theRestrIcoTwo.tex}
#! </Alt>
restrictionTwo := RestrictionToNeighbourhoodOfVerticesNC(Icosahedron(),2,[4]);;
pr.edgeDrawOrder := [3,7,13,14,17,4,1,9,24,26,16,2,8,25];
DrawSurfaceToTikz(restrictionTwo,"theRestrIcoTwo",pr);
#! @EndChunk

#! @BeginChunk Example_Square
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theSquare.tex}
#! </Alt>
#! @BeginExample
mySquare := PolygonalSurfaceByDownwardIncidenceNC([[1,2],[2,3],[3,4],[4,1]],
[[1,2,3,4]]);;
#! @EndExample
DrawSurfaceToTikz(mySquare,"theSquare");
#! @EndChunk

#! @BeginChunk Example_Bat
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theBat.tex}
#! </Alt>
DrawSurfaceToTikz(SimplicialSurfaceByDownwardIncidenceNC([[1,2],[1,3],[2,3],[2,4],[3,4],
[3,5],[4,5],[5,6],[4,6],[4,7],[6,7],[6,8],[7,8]],[[1,2,3],[3,4,5],[5,6,7],
[7,8,9],[9,10,11],[11,12,13]]),"theBat");
#! @EndChunk

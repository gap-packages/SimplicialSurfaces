#! @BeginChunk Example_TwoDisjointTriangles
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theTwoDisjointTriangles.tex}
#! </Alt>
#! @BeginExample
twoDisjointTriangles := SimplicialSurfaceByDownwardIncidence([[1,2],[2,3],[1,3],[4,5],[5,6],[4,6]],[[1,2,3],[4,5,6]]);;
#! @EndExample
DrawSurfaceToTikz(twoDisjointTriangles,"theTwoDisjointTriangles");
#! @EndChunk

#! @BeginChunk Example_Triangle
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theTriangle.tex}
#! </Alt>
#! @BeginExample
triangle := SimplicialSurfaceByDownwardIncidence([[1,2],[2,3],[1,3]],[[1,2,3]]);;
#! @EndExample
DrawSurfaceToTikz(triangle,"theTriangle");
#! @EndChunk

#! @BeginChunk Example_RestrSurf
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theRestrSurf.tex}
#! </Alt>
#! @BeginExample
restrSurf := RestrictionToNeighbourhoodOfFaces(Cube(),1,[1]);;
#! @EndExample
DrawSurfaceToTikz(restrSurf,"theRestrSurf");
#! @EndChunk

#! @BeginChunk Example_RestrIco
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theRestrIco.tex}
#! </Alt>
#! @BeginExample
restrIco := RestrictionToNeighbourhoodOfFaces(ico,2,[4]);;
#! @EndExample
DrawSurfaceToTikz(restrIco,"theRestrIco");
#! @EndChunk

#! @BeginChunk Example_RestrOcta
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theRestrOcta.tex}
#! </Alt>
#! @BeginExample
restrOcta:=RestrictionToNeighbourhoodOfVertices(Octahedron(),1,[1]);;
#! @EndExample
DrawSurfaceToTikz(restrOcta,"theRestrOcta");
#! @EndChunk

#! @BeginChunk Example_RestrIcoOne
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theRestrIcoOne.tex}
#! </Alt>
#! @BeginExample
restrIcoOne := RestrictionToNeighbourhoodOfVerticesNC(Icosahedron(),1,[4]);;
#! @EndExample
DrawSurfaceToTikz(restrIcoOne,"theRestrIcoOne");
#! @EndChunk

#! @BeginChunk Example_RestrIcoTwo
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theRestrIcoTwo.tex}
#! </Alt>
#! @BeginExample
restrIcoTwo := RestrictionToNeighbourhoodOfVertices(Icosahedron(),2,[4]);;
#! @EndExample
DrawSurfaceToTikz(restrIcoTwo,"theRestrIcoTwo");
#! @EndChunk

#! @BeginChunk Example_Square
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theSquare.tex}
#! </Alt>
#! @BeginExample
mySquare := PolygonalSurfaceByDownwardIncidence([[1,2],[2,3],[3,4],[4,1]],[[1,2,3,4]]);;
#! @EndExample
DrawSurfaceToTikz(mySquare,"theSquare");
#! @EndChunk

#! @BeginChunk Example_Bat
#! 
#! <Alt Only="TikZ">
#!   \input{_TIKZ_theBat.tex}
#! </Alt>
#! @BeginExample
bat:=SimplicialSurfaceByDownwardIncidence([[1,2],[1,3],[2,3],[2,4],[3,4],[3,5],[4,5],[5,6],[4,6],[4,7],[6,7],[6,8],[7,8]],[[1,2,3],[3,4,5],[5,6,7],[7,8,9],[9,10,11],[11,12,13]]);;
#! @EndExample
DrawSurfaceToTikz(bat,"theBat");
#! @EndChunk

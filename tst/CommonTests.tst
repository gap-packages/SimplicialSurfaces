
gap> CommonVerticesOfEdges(Tetrahedron(),1,2);
[ 1 ]
gap> CommonVerticesOfEdges(JanusHead(),1,2);
[ 1 ]
gap>  openBag := SimplicialSurfaceByDownwardIncidence(
> [[1,2],[1,3],[2,3],[2,3]], [[1,2,4],[1,2,3]]);;
gap> CommonVerticesOfEdges(openBag,3,4);
[ 2, 3 ]
gap> complex := PolygonalComplexByDownwardIncidence(
> [ , , , , , [2,5], , [2,3], [3,5], [11,5], , [3,7], [7,11] ],
> [[6,8,9], , , [9,10,12,13]]);;
gap> CommonVerticesOfEdges(complex,8,9);
[ 3 ]

gap> CommonVerticesOfEdges(Tetrahedron(),[1,2,3]);
[ 1 ]
gap>  openBag := SimplicialSurfaceByDownwardIncidence(
> [[1,2],[1,3],[2,3],[2,3]], [[1,2,4],[1,2,3]]);;
gap> CommonVerticesOfEdges(openBag,[1,3,4]);
[ 2 ]
gap> CommonVerticesOfEdges(complex,[8,9,12]);
[ 3 ]




gap> CommonEdgesOfFaces(Tetrahedron(),1,2);
[ 1 ]
gap> CommonEdgesOfFaces(JanusHead(),1,2);
[ 1, 2, 3 ]

gap> CommonEdgesOfFaces(Tetrahedron(),[1,2]);
[ 1 ]
gap> complex := PolygonalComplexByDownwardIncidence(
> [ , , , , , [2,5], , [2,3], [3,5], [11,5], , [3,7], [7,11] ],
> [[6,8,9], , , [9,10,12,13]]);;
gap> CommonEdgesOfFaces(complex,[1,4]);
[ 9 ]



gap> CommonVerticesOfFaces(Tetrahedron(),1,2);
[ 1, 2 ]
gap> CommonVerticesOfFaces(JanusHead(),1,2);
[ 1, 2, 3 ]
gap> openBag := SimplicialSurfaceByDownwardIncidence(
> [[1,2],[1,3],[2,3],[2,3]], [[1,2,4],[1,2,3]]);;
gap> CommonVerticesOfFaces(openBag,1,2);
[ 1, 2, 3 ]
gap> complex := PolygonalComplexByDownwardIncidence(
> [ , , , , , [2,5], , [2,3], [3,5], [11,5], , [3,7], [7,11] ],
> [[6,8,9], , , [9,10,12,13]]);;
gap> CommonVerticesOfFaces(complex,1,4);
[ 3, 5 ]


gap> CommonVerticesOfFaces(Tetrahedron(),[1,2,3]);
[ 2 ]
gap> CommonVerticesOfFaces(Tetrahedron(),[2,3,4]);
[ 4 ]


gap> CommonEdgesOfVertices(Tetrahedron(),1,2);
[ 1 ]
gap> openBag := SimplicialSurfaceByDownwardIncidence(
> [[1,2],[1,3],[2,3],[2,3]], [[1,2,4],[1,2,3]]);;
gap> CommonEdgesOfVertices(openBag,2,3);
[ 3, 4 ]
gap> complex := PolygonalComplexByDownwardIncidence(
> [ , , , , , [2,5], , [2,3], [3,5], [11,5], , [3,7], [7,11] ],
> [[6,8,9], , , [9,10,12,13]]);;
gap> CommonEdgesOfVertices(complex,3,5);
[ 9 ]


gap> CommonFacesOfEdges(Tetrahedron(),1,2);
[ 1 ]
gap> CommonFacesOfEdges(JanusHead(),1,2);
[ 1, 2 ]
gap> openBag := SimplicialSurfaceByDownwardIncidence(
> [[1,2],[1,3],[2,3],[2,3]], [[1,2,4],[1,2,3]]);;
gap> CommonFacesOfEdges(openBag,1,2);
[ 1, 2 ]
gap> CommonFacesOfEdges(openBag,1,3);
[ 2 ]
gap> complex := PolygonalComplexByDownwardIncidence(
> [ , , , , , [2,5], , [2,3], [3,5], [11,5], , [3,7], [7,11] ],
> [[6,8,9], , , [9,10,12,13]]);;
gap> CommonFacesOfEdges(complex,9,12);
[ 4 ]


gap> CommonFacesOfEdges(Tetrahedron(),[1,2,3]);
[  ]
gap> CommonFacesOfEdges(JanusHead(),[1,2,3]);
[ 1, 2 ]
gap> openBag := SimplicialSurfaceByDownwardIncidence(
> [[1,2],[1,3],[2,3],[2,3]], [[1,2,4],[1,2,3]]);;
gap> CommonFacesOfEdges(openBag,[1,2,3]);
[ 2 ]
gap> CommonFacesOfEdges(complex,[9,10,12,13]);
[ 4 ]

gap> CommonFacesOfVertices(Tetrahedron(),1,2);
[ 1, 2 ]
gap> CommonFacesOfVertices(JanusHead(),1,2);
[ 1, 2 ]
gap> complex := PolygonalComplexByDownwardIncidence(
> [ , , , , , [2,5], , [2,3], [3,5], [11,5], , [3,7], [7,11] ],
> [[6,8,9], , , [9,10,12,13]]);;
gap> CommonFacesOfVertices(complex,3,5);
[ 1, 4 ]


gap> CommonFacesOfVertices(Tetrahedron(),[1,2,3]);
[ 1 ]
gap> CommonFacesOfVertices(JanusHead(),[1,2,3]);
[ 1, 2 ]
gap> complex := PolygonalComplexByDownwardIncidence(
> [ , , , , , [2,5], , [2,3], [3,5], [11,5], , [3,7], [7,11] ],
> [[6,8,9], , , [9,10,12,13]]);;
gap> CommonFacesOfVertices(complex,[3,5,7,11]);
[ 4 ]

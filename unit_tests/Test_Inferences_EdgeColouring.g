

# This file contains tests for the integrity of the edge coloured polygonal 
# complex category

# Wild-coloured surfaces constructed from colour involutions have to know
# their vertices (they were not computable before)
BindGlobal( "__SIMPLICIAL_Test_WildColouredByInvolutions", function()
    local invs, wild;

    # colour involutions of the mirror-coloured octahedron
    invs := [ (1,3)(2,4)(5,7)(6,8), (1,7)(2,8)(3,5)(4,6), (1,4)(2,3)(5,8)(6,7) ];

    wild := AllWildColouredSurfaces( invs, [1,1,1] );
    SIMPLICIAL_TestAssert( Length(wild) = 1 );
    SIMPLICIAL_TestAssert( NumberOfVertices(wild[1]) = 6 );
    SIMPLICIAL_TestAssert( IsSimplicialSurface(PolygonalComplex(wild[1])) );
    SIMPLICIAL_TestAssert( ColourInvolutions(wild[1]) = invs );

    wild := AllWildColouredSurfaces( invs, [2,1,1] );
    SIMPLICIAL_TestAssert( Length(wild) = 1 );
    SIMPLICIAL_TestAssert( NumberOfVertices(wild[1]) = 4 );

    # without (complete) local symmetry, isomorphic surfaces are removed,
    # which needs the vertices
    SIMPLICIAL_TestAssert( Length(AllWildColouredSurfaces(invs)) = 6 );
    SIMPLICIAL_TestAssert( Length(AllTameColouredSurfaces(invs)) = 4 );
    SIMPLICIAL_TestAssert( Length(AllWildColouredSurfaces(invs, [0,2,0])) = 5 );

    # SixFoldCover uses this construction
    SIMPLICIAL_TestAssert(
        NumberOfVertices(SixFoldCover(Tetrahedron())[1]) = 12 );
end);

BindGlobal( "__SIMPLICIAL_Test_EdgeColours", function()
    local edgesOfColours, coloursOfEdges, colComplex, complex, colIncDigr, digEdges, edge, vertex, edges, faces, coloursOfEdges1, colComplex1, 
	coloursOfEdges2, colComplex2;

    complex := SimplicialSurfaceByDownwardIncidence( 
        [[1,2],[1,3],[1,5],,[2,3],[2,5],[3,5]], 
        [[1,2,5],[2,3,7],[1,3,6],[5,6,7]] );
    coloursOfEdges := [1,2,4,,4,2,1];
    edgesOfColours := [[1,7],[2,6],,[3,5]];

    # ColoursOfEdges -> EdgesOfColours
    colComplex := Objectify( EdgeColouredTwistedPolygonalComplexType, rec() );
    SetPolygonalComplex(colComplex, complex);
    SetColoursOfEdges(colComplex, coloursOfEdges );
    SIMPLICIAL_TestAssert(EdgesOfColours(colComplex) = edgesOfColours);

    # EdgesOfColours -> ColoursOfEdges
    colComplex := Objectify( EdgeColouredTwistedPolygonalComplexType, rec() );
    SetPolygonalComplex(colComplex, complex);
    SetEdgesOfColours(colComplex, edgesOfColours );
    SIMPLICIAL_TestAssert(ColoursOfEdges(colComplex) = coloursOfEdges);

    # basic functions
    colComplex:=EdgeColouredTwistedPolygonalComplex(complex,coloursOfEdges);
    SIMPLICIAL_TestAssert(PolygonalComplex(colComplex) = complex);
    SIMPLICIAL_TestAssert(EdgesOfColours(colComplex) = edgesOfColours);
    SIMPLICIAL_TestAssert(ColoursOfEdges(colComplex) = coloursOfEdges);
    SIMPLICIAL_TestAssert(Colours(colComplex)=[1,2,4]);
	
    # ColourIncidenceGraphDigraphs
    colIncDigr:=ColourIncidenceGraphDigraphs(colComplex)[1];
    digEdges:=ShallowCopy(DigraphEdges(colIncDigr));
        
    for edge in [1..Length(digEdges)] do
        digEdges[edge]:=[DigraphVertexLabel(colIncDigr,digEdges[edge][1]),DigraphVertexLabel(colIncDigr,digEdges[edge][2])];
    od;
        
    for vertex in EdgesOfVertices(colComplex) do
        for edges in vertex do
            SIMPLICIAL_TestAssert([Position(EdgesOfVertices(colComplex),vertex),edges+Last(Vertices(colComplex))] in digEdges);
        od;
    od;
            
    for edge in FacesOfEdges(colComplex) do
        for faces in edge do
            SIMPLICIAL_TestAssert([Position(FacesOfEdges(colComplex),edge)+Last(Vertices(colComplex)),
            faces+Last(Vertices(colComplex))+Last(Edges(colComplex))] in digEdges);
        od;
    od;
        
    for edge in Edges(colComplex) do
        SIMPLICIAL_TestAssert([edge+Last(Vertices(colComplex)),ColourOfEdge(colComplex,edge)+Last(Vertices(colComplex))+Last(Edges(colComplex))+
        Last(Faces(colComplex))] in digEdges);
    od;
end);

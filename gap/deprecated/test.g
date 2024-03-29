################################################################################
## This document contains some tests for the functionality of the package
## simplicial_surface
################################################################################

Read("../test/test_simplicialSurface.g");
Read("../test/test_colSimpSurf.g");
Read("../test/test_foldingComplex.g");

Read("../test/test_example_janusHead.g");
Read("../test/test_example_tetrahedron.g");
Read("../test/test_example_openTetrahedron.g");
Read("../test/test_example_twoConTriangles.g");
Read("../test/test_example_projectivePlaneFour.g");
Read("../test/test_example_icosahedron.g");
Read("../test/test_example_threeTrianglesOnEdge.g");
Read("../test/test_example_tetrahedronAndProjectivePlane.g");
Read("../test/test_example_pentagon.g");
Read("../test/test_example_threeTrianglesInLine.g");
Read("../test/test_example_empty.g");




##	Apply the tests for simplicial surfaces
TestSimplicialSurface := function()
	TestJanusHead();
	TestTetrahedron();
	TestOpenTetrahedron();
	TestTwoConnectedTriangles();
	TestProjectivePlaneFour();
	TestIcosahedron();
	TestThreeTrianglesOnEdge();
	TestTetrahedronAndProjectivePlane();
	TestPentagon();
	TestThreeTrianglesInLine();
        TestEmpty();
end;


##	Apply the tests for simplicial surfaces
TestWildSimplicialSurface := function()
	TestWildJanusHead();
	TestWildTetrahedron();
	TestWildOpenTetrahedron();
	TestWildTwoConnectedTriangles();
	TestWildProjectivePlaneFour();
        #TestWildEmpty(); #TODO fix problems at some point
end;


##	Apply the tests for simplicial surface identifications
TestSimplicialSurfaceIdentification := function()
	TestTwoConnectedTrianglesIdentification();
	TestTetrahedronIdentification();
	TestJanusHeadIdentification();
	TestThreeTrianglesOnEdgeIdentification();
	TestPentagonIdentification();
end;


##	Apply the tests for simplicial surface fans
TestSimplicialSurfaceFan := function()
	TestJanusHeadFan();
	TestIcosahedronFan();
	TestOpenTetrahedronFan();
	TestPentagonFan();
	TestProjectivePlaneFourFan();
	TestThreeTrianglesOnEdgeFan();
end;


##	Apply the tests for folding complexes
TestFoldingComplex := function()
	TestFoldingComplexThreeTrianglesOnEdge();
	TestFoldingComplexThreeTrianglesInLine();
end;


##	Apply all tests
TestAll := function()
	TestSimplicialSurface();
	TestWildSimplicialSurface();
	TestSimplicialSurfaceIdentification();
	TestSimplicialSurfaceFan();
	TestFoldingComplex();
end;

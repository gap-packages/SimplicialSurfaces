################################################################################
## This document contains some tests for the functionality of the package
## simplicial_surface
################################################################################

Read("../test/test_simplicialSurface.g");

Read("../test/test_simplicialSurface_janusHead.g");
Read("../test/test_simplicialSurface_tetrahedron.g");
Read("../test/test_simplicialSurface_openTetrahedron.g");
Read("../test/test_simplicialSurface_twoConTriangles.g");
Read("../test/test_simplicialSurface_projectivePlaneFour.g");
Read("../test/test_simplicialSurface_icosahedron.g");
Read("../test/test_simplicialSurface_threeTrianglesOnEdge.g");
Read("../test/test_simplicialSurface_tetrahedronAndProjectivePlane.g");


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
end;


##	Apply the tests for simplicial surfaces
TestWildSimplicialSurface := function()
	TestWildJanusHead();
	TestWildTetrahedron();
	TestWildOpenTetrahedron();
	TestWildTwoConnectedTriangles();
	TestWildProjectivePlaneFour();
	#TestIcosahedron();
	#TestTetrahedronAndProjectivePlane();
end;


##	Apply all tests
TestAll := function()
	TestSimplicialSurface();
	#TestWildSimplicialSurface();
end;

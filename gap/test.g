################################################################################
## This document contains some tests for the functionality of the package
## simplicial_surface
################################################################################

Read("../test/generalTest.g");

Read("../test/test_simplicialSurface_janusHead.g");
Read("../test/test_simplicialSurface_tetrahedron.g");
Read("../test/test_simplicialSurface_openTetrahedron.g");
Read("../test/test_simplicialSurface_twoConTriangles.g");

TestAll := function()
	TestJanusHead();
	TestTetrahedron();
	TestOpenTetrahedron();
	TestTwoConnectedTriangles();
end;

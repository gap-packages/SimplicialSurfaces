################################################################################
## This document contains some tests for the functionality of the package
## simplicial_surface
################################################################################

Read("../test/generalTest.g");

Read("../test/tetrahedron.g");
Read("../test/openTetrahedron.g");
Read("../test/icosahedron.g");
Read("../test/janusHead.g");
Read("../test/twoConnectedTriangles.g");
Read("../test/projectivePlaneFour.g");

TestAll := function()
	TestTetrahedron();
	TestOpenTetrahedron();
	TestIcosahedron();
	TestJanusHead();
	TestTwoConnectedTriangles();
	TestProjectivePlaneFour();
end;

################################################################################
## This document contains some tests for the functionality of the package
## simplicial_surface
################################################################################

Read("../test/generalTest.g");
Read("../test/tetrahedron.g");
Read("../test/openTetrahedron.g");
Read("../test/icosahedron.g");

TestAll := function()
	TestTetrahedron();
	TestOpenTetrahedron();
	TestIcosahedron();
end;

################################################################################
## This document contains some tests for the functionality of the package
## simplicial_surface
################################################################################

Read("../test/generalTest.g");

Read("../test/test_simplicialSurface_janusHead.g");
Read("../test/test_simplicialSurface_tetrahedron.g");

TestAll := function()
	TestJanusHead();
	TestTetrahedron();
end;

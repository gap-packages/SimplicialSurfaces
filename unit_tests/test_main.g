#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2016
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

# This is the document that manages all other tests

BindGlobal( "SIMPLICIAL_TestAll", function()

    # Polygonal complex
    __SIMPLICIAL_Test_ConnectionLabelStarOfStar();
    __SIMPLICIAL_Test_InvertIncidence();
end;

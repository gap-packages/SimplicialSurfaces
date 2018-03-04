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
    __SIMPLICIAL_Test_TransitiveIncidence();
    __SIMPLICIAL_Test_PerimeterInferences();
    __SIMPLICIAL_Test_UmbrellaSwitch();
    __SIMPLICIAL_Test_UmbrellaImplications();
    __SIMPLICIAL_Test_ConnectivityImplications();
    __SIMPLICIAL_Test_OrientabilityImplications();

    __SIMPLICIAL_Test_Properties();
    __SIMPLICIAL_Test_PolygonalHierarchy();

    # Edge coloured polygonal complex
    __SIMPLICIAL_Test_EdgeColours();
end);

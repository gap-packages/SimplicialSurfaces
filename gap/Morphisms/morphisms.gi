#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2019
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

DeclareRepresentation( "PolygonalComplexMorphismRep", 
    IsGeneralPolygonalMorphism and IsAttributeStoringRep, [] );

BindGlobal( "PolygonalComplexMorphismType", 
    NewType( GeneralPolygonalMorphismFamily, PolygonalComplexMorphismRep ) );

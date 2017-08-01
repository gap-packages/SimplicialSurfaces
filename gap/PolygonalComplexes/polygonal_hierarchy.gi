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


# We define a generic representation for polygonal complexes
DeclareRepresentation("IsGenericPolygonalComplexRep", IsPolygonalComplex, []);

# Define a generic type
PolygonalComplexType := 
    NewType( PolygonalComplexFamily, IsGenericPolygonalComplexRep );

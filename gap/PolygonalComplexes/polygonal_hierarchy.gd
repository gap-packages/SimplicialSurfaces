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


##
## All documentation is done in doc/PolygonalStructures.xml

# The custom info class
DeclareInfoClass( "InfoPolygonalComplex" );


# Define the main category
# [Categories are used to determine which operations can be used]
DeclareCategory( "IsPolygonalComplex", 
    IsComponentObjectRep and IsAttributeStoringRep );

# Define the family
# [For two object to be equal, they have to lie in the same family]
BindGlobal( "PolygonalComplexFamily", 
    NewFamily("PolygonalComplexFamily", IsObject, IsPolygonalComplex));


# Define all secondary categories
DeclareCategory( "IsTriangularComplex", 
    IsPolygonalComplex and IsFacesTriangular );
    # TODO is it necessary to have a separate flag for IsFacesTriangular?


DeclareCategory( "IsRamifiedPolygonalSurface", IsPolygonalComplex);
DeclareCategory( "IsRamifiedSimplicialSurface", 
    IsRamifiedPolygonalSurface and IsTriangularComplex );

DeclareCategory( "IsPolygonalSurface", IsRamifiedPolygonalSurface );
DeclareCategory( "IsSimplicialSurface",
    IsPolygonalSurface and IsTriangularComplex);

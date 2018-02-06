#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2018
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################



#######################################
##
##      PolygonalComplex-part
##
## All documentation is done in doc/PolygonalStructures.xml

# Define the main category
# [Categories are used to determine which operations can be used]
DeclareCategory( "IsPolygonalComplex", IsObject );

# Define the family
# [For two object to be equal, they have to lie in the same family]
BindGlobal( "PolygonalComplexFamily", 
    NewFamily("PolygonalComplexFamily", IsObject, IsPolygonalComplex));


# Define all secondary categories
DeclareProperty( "IsTriangularComplex", IsPolygonalComplex);
InstallTrueMethod( IsPolygonalComplex, IsTriangularComplex );

DeclareProperty( "IsRamifiedPolygonalSurface", IsPolygonalComplex);
InstallTrueMethod( IsPolygonalComplex, IsRamifiedPolygonalSurface );
DeclareSynonym( "IsRamifiedSimplicialSurface", 
    IsRamifiedPolygonalSurface and IsTriangularComplex);

# The next property is a subproperty of IsRamifiedPolygonalSurface
# We define it for general polygonal complexes so that it can
# be tested anyway
DeclareProperty( "IsPolygonalSurface", IsPolygonalComplex );
InstallTrueMethod( IsRamifiedPolygonalSurface, IsPolygonalSurface );
DeclareSynonym( "IsSimplicialSurface", 
    IsPolygonalSurface and IsTriangularComplex );


#######################################
##
##      Paths-part
##
## documented in gap/Paths/paths.gd

DeclareCategory( "IsVertexEdgePath", IsDualPath );
BindGlobal( "VertexEdgePathFamily", 
    NewFamily("VertexEdgePathFamily", IsObject, IsVertexEdgePath) );


DeclareCategory( "IsEdgeFacePath", IsDualPath );
BindGlobal( "EdgeFacePathFamily", 
    NewFamily("EdgeFacePathFamily", IsObject, IsVertexEdgePath) );



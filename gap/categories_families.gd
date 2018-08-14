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
##      Incidence geometry part
##

# This filter captures the "surface"-qualities of PolygonalComplex and BendPolygonalComplex
DeclareFilter( "IsVEFComplex", IsObject );



#######################################
##
##      PolygonalComplex-part
##
## All documentation is done in doc/PolygonalStructures.xml


# Define the main category
# [Categories are used to determine which operations can be used]
# [For two object to be equal, they have to lie in the same family]
DeclareCategory( "IsPolygonalComplex", IsVEFComplex );
BindGlobal( "PolygonalComplexFamily",
    NewFamily("PolygonalComplexFamily", IsObject, IsPolygonalComplex));

DeclareCategory( "IsBendPolygonalComplex", IsVEFComplex );
BindGlobal( "BendPolygonalComplexFamily",
    NewFamily("BendPolygonalComplexFamily", IsObject, IsBendPolygonalComplex));

## Define all secondary categories


# Ramifications
DeclareProperty( "IsNotEdgeRamified", IsVEFComplex );
DeclareProperty( "IsNotVertexRamified", IsVEFComplex );
InstallTrueMethod(IsNotEdgeRamified, IsNotVertexRamified);


DeclareSynonym( "IsVEFSurface", IsVEFComplex and IsNotEdgeRamified and IsNotVertexRamified );
DeclareSynonym( "IsPolygonalSurface", IsPolygonalComplex and IsVEFSurface );
DeclareSynonym( "IsBendPolygonalSurface", IsBendPolygonalComplex and IsVEFSurface );


DeclareProperty( "IsTriangular", IsVEFComplex );    #TODO this is currently twice declared (also in properties.gd)
DeclareSynonym( "IsTriangularComplex", IsPolygonalComplex and IsTriangular );
DeclareSynonym( "IsSimplicialSurface", IsPolygonalSurface and IsTriangular );


DeclareProperty( "IsRamifiedPolygonalSurface", IsPolygonalComplex); #TODO replace by surface def
InstallTrueMethod( IsPolygonalComplex, IsRamifiedPolygonalSurface );
DeclareSynonym( "IsRamifiedSimplicialSurface", 
    IsRamifiedPolygonalSurface and IsTriangularComplex);



#######################################
##
##      Paths-part
##
## documented in gap/Paths/paths.gd

DeclareCategory( "IsVertexEdgePath", IsDualPath );
BindGlobal( "VertexEdgePathFamily", 
    NewFamily("VertexEdgePathFamily", IsObject, IsVertexEdgePath) );

DeclareCategory( "IsPerimeterPath", IsVertexEdgePath and IsClosedPath );
BindGlobal( "PerimeterPathFamily",
    NewFamily("PerimeterPathFamily", IsObject, IsPerimeterPath));


DeclareCategory( "IsEdgeFacePath", IsDualPath );
BindGlobal( "EdgeFacePathFamily", 
    NewFamily("EdgeFacePathFamily", IsObject, IsEdgeFacePath) );

DeclareCategory( "IsEdgeColouredEdgeFacePath", IsEdgeFacePath );
BindGlobal( "EdgeColouredEdgeFacePathFamily",
    NewFamily("EdgeColouredEdgeFacePathFamily", IsObject, IsEdgeColouredEdgeFacePath));


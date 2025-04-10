#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2025
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################


#######################################
##
##      TwistedPolygonalComplex-part
##
## All documentation is done in doc/PolygonalStructures.xml


# Define the main category
# [Categories are used to determine which operations can be used]
# [For two object to be equal, they have to lie in the same family]
DeclareCategory( "IsTwistedPolygonalComplex", IsObject );
BindGlobal( "TwistedPolygonalComplexFamily",
    NewFamily("TwistedPolygonalComplexFamily", IsObject, IsTwistedPolygonalComplex));

DeclareProperty("IsPolygonalComplex", IsTwistedPolygonalComplex);

## Define all secondary categories


# Ramifications
DeclareProperty( "IsNotEdgeRamified", IsTwistedPolygonalComplex );
DeclareProperty( "IsNotVertexRamified", IsTwistedPolygonalComplex );
InstallTrueMethod(IsNotEdgeRamified, IsNotVertexRamified);


DeclareSynonym( "IsTwistedPolygonalSurface", IsTwistedPolygonalComplex and IsNotEdgeRamified and IsNotVertexRamified );
DeclareSynonym( "IsPolygonalSurface", IsPolygonalComplex and IsTwistedPolygonalSurface );


DeclareProperty( "IsTriangular", IsTwistedPolygonalComplex );    #TODO this is currently twice declared (also in properties.gd)
DeclareSynonym( "IsTriangularComplex", IsPolygonalComplex and IsTriangular );
DeclareSynonym( "IsSimplicialSurface", IsPolygonalSurface and IsTriangular );



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



#######################################
##
##      Counters-part
##
## documented in gap/PolygonalComplexes/properties.gd
DeclareCategory("IsCounter",IsObject);

DeclareCategory( "IsCounterOfVertices", IsCounter);
BindGlobal( "CounterOfVerticesFamily",
    NewFamily("CounterOfVerticesFamily", IsObject, IsCounterOfVertices));
DeclareAttribute("CounterOfVertices",IsTwistedPolygonalComplex);

DeclareCategory( "IsCounterOfEdges", IsCounter);
BindGlobal( "CounterOfEdgesFamily",
    NewFamily("CounterOfEdgesFamily", IsObject, IsCounterOfEdges));
DeclareAttribute("CounterOfEdges",IsTwistedPolygonalComplex);

DeclareCategory( "IsCounterOfFaces", IsCounter);
BindGlobal( "CounterOfFacesFamily",
    NewFamily("CounterOfFacesFamily", IsObject, IsCounterOfFaces));
DeclareAttribute("CounterOfFaces",IsTwistedPolygonalComplex);

DeclareCategory( "IsCounterOfButterflies", IsCounter);
BindGlobal( "CounterOfButterfliesFamily",
    NewFamily("CounterOfButterliesFamily", IsObject, IsCounterOfButterflies));
DeclareAttribute("CounterOfButterflies",IsSimplicialSurface);

DeclareCategory( "IsCounterOfUmbrellas", IsCounter);
BindGlobal( "CounterOfUmbrellasFamily",
    NewFamily("CounterOfUmbrellasFamily", IsObject, IsCounterOfUmbrellas));

DeclareCategory( "IsCounterOfThreeFaces", IsCounter);
BindGlobal( "CounterOfThreeFacesFamily",
    NewFamily("CounterOfThreeFacesFamily", IsObject, IsCounterOfThreeFaces));
DeclareAttribute("CounterOfThreeFaces",IsSimplicialSurface);

#######################################
##
##      Global variables
##
DeclareGlobalVariable( "SIMPLICIAL_ENABLE_SURFACE_REDISPATCH" );
MakeReadWriteGlobal("SIMPLICIAL_ENABLE_SURFACE_REDISPATCH");
SIMPLICIAL_ENABLE_SURFACE_REDISPATCH := true; # true is default, false should only be used for debugging/profiling

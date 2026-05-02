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

## Properties
#
DeclareProperty( "IsPolygonalComplex",  IsTwistedPolygonalComplex );
DeclareProperty( "IsFacePure",          IsTwistedPolygonalComplex );    #TODO this is currently twice declared (also in properties.gd)
DeclareProperty( "IsTriangular",        IsTwistedPolygonalComplex );    #TODO this is currently twice declared (also in properties.gd)
# Ramifications
DeclareProperty( "IsNotEdgeRamified",   IsTwistedPolygonalComplex );
DeclareProperty( "IsNotVertexRamified", IsTwistedPolygonalComplex );
#
## Property Implications
InstallTrueMethod(IsNotEdgeRamified, IsNotVertexRamified);    # IsNotVertexRamified implies IsNotEdgeRamified

## Secondary categories
#
DeclareSynonym( "IsTwistedPolygonalSurface", IsTwistedPolygonalComplex and IsFacePure and IsNotEdgeRamified and IsNotVertexRamified );
DeclareSynonym( "IsPolygonalSurface", IsPolygonalComplex and IsTwistedPolygonalSurface );
#
DeclareSynonym( "IsTriangularComplex", IsPolygonalComplex and IsTriangular );
DeclareSynonym( "IsSimplicialSurface", IsPolygonalSurface and IsTriangular );
DeclareSynonym( "IsSimplicialComplex", IsTriangularComplex and IsNotVertexRamified );


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




# We define a generic representation for twisted polygonal complexes
DeclareRepresentation("IsGenericTwistedPolygonalComplexRep", 
    IsTwistedPolygonalComplex and IsAttributeStoringRep, []);

# Define a generic type
BindGlobal( "TwistedPolygonalComplexType", 
    NewType( TwistedPolygonalComplexFamily, IsGenericTwistedPolygonalComplexRep ));

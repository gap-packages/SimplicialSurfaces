DeclareCategory( "IsBendSurface", IsObject );
BindGlobal( "BendSurfaceFamily", 
    NewFamily("BendSurfaceFamily",  IsObject, IsBendSurface) );


DeclareAttribute( "VerticesAttributeOfBendSurface", IsBendSurface );
DeclareOperation( "Vertices", [IsBendSurface] );

DeclareAttribute( "Edges", IsBendSurface );
DeclareAttribute( "Faces", IsBendSurface );
DeclareAttribute( "EdgeSign", IsBendSurface );
DeclareAttribute( "VertexMap", IsBendSurface );
DeclareAttribute( "EdgeMap", IsBendSurface );

DeclareOperation( "BendSurface", [IsList, IsList, IsList, IsList, IsList, IsList] );
DeclareOperation( "BendSurface", [IsSimplicialSurface] );

DeclareAttribute( "RigidFaces", IsBendSurface );
DeclareAttribute( "BendFaces", IsBendSurface );

DeclareProperty( "IsRigidFaced", IsBendSurface );


DeclareAttribute( "Geodesics", IsBendSurface );
DeclareAttribute( "GeodesicDual", IsBendSurface );

DeclareOperation( "SourceOfLocalEdge", [IsPosInt] );
DeclareOperation( "TargetOfLocalEdge", [IsPosInt] );

DeclareOperation( "LocalEdgeIntersection", [IsPosInt, IsPosInt] );


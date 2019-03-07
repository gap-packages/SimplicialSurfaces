
DeclareOperation( "SetVertexCoordiantes3DNC", [IsDenseList, IsRecord] );
DeclareOperation( "SetVertexCoordiantes3D", [IsPolygonalComplex and IsNotEdgeRamified, IsDenseList, IsRecord] );
DeclareOperation( "GetVertexCoordiantes3DNC", [IsRecord, IsCyclotomic] );
DeclareOperation( "GetVertexCoordiantes3D", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord, IsCyclotomic] );

DeclareOperation( "DrawSurfaceToJavaScript", [IsPolygonalComplex and IsNotEdgeRamified, IsString, IsRecord] );

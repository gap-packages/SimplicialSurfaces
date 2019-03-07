
DeclareOperation( "SetVertexCoordiantes3DNC", [IsDenseList, IsRecord] );
DeclareOperation( "SetVertexCoordiantes3D", [IsPolygonalComplex and IsNotEdgeRamified, IsDenseList, IsRecord] );
DeclareOperation( "GetVertexCoordiantes3DNC", [IsRecord, IsCyclotomic] );
DeclareOperation( "GetVertexCoordiantes3D", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord, IsCyclotomic] );

DeclareOperation( "CalculateParametersOfInnerCircle", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "ActivateInnerCircle", [IsRecord] );
DeclareOperation( "DeactivateInnerCircle", [IsRecord] );
DeclareOperation( "IsInnerCircleActive", [IsRecord] );

DeclareOperation( "DrawSurfaceToJavaScript", [IsPolygonalComplex and IsNotEdgeRamified, IsString, IsRecord] );

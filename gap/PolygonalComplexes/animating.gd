
DeclareOperation( "SetVertexCoordiantes3DNC", [IsDenseList, IsRecord] );
DeclareOperation( "SetVertexCoordiantes3D", [IsPolygonalComplex and IsNotEdgeRamified, IsDenseList, IsRecord] );
DeclareOperation( "GetVertexCoordiantes3DNC", [IsRecord, IsCyclotomic] );
DeclareOperation( "GetVertexCoordiantes3D", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord, IsCyclotomic] );

DeclareOperation( "CalculateParametersOfInnerCircle", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "ActivateInnerCircles", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "DeactivateInnerCircles", [IsRecord] );
DeclareOperation( "ActivateInnerCircle", [IsCyclotomic, IsRecord] );
DeclareOperation( "DeactivateInnerCircle", [IsCyclotomic, IsRecord] );
DeclareOperation( "IsInnerCircleActive", [IsCyclotomic, IsRecord] );

DeclareOperation( "CalculateParametersOfEdges", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "ActivateEdges", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "DeactivateEdges", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "ActivateEdge", [IsCyclotomic, IsRecord] );
DeclareOperation( "DeactivateEdge", [IsCyclotomic, IsRecord] );
DeclareOperation( "IsEdgeActive", [IsCyclotomic, IsRecord] );

DeclareOperation( "SetFaceColour", [IsCyclotomic, IsString, IsRecord] );
DeclareOperation( "GetFaceColour", [IsCyclotomic, IsRecord] );
DeclareOperation( "SetFaceColours", [IsDenseList, IsRecord] );
DeclareOperation( "GetFaceColours", [IsRecord] );

DeclareOperation( "SetVertexColour", [IsCyclotomic, IsString, IsRecord] );
DeclareOperation( "GetVertexColour", [IsCyclotomic, IsRecord] );
DeclareOperation( "SetVertexColours", [IsDenseList, IsRecord] );
DeclareOperation( "GetVertexColours", [IsRecord] );

DeclareOperation( "SetEdgeColour", [IsCyclotomic, IsString, IsRecord] );
DeclareOperation( "GetEdgeColour", [IsCyclotomic, IsRecord] );
DeclareOperation( "SetEdgeColours", [IsDenseList, IsRecord] );
DeclareOperation( "GetEdgeColours", [IsRecord] );

DeclareOperation( "SetCircleColour", [IsCyclotomic, IsString, IsRecord] );
DeclareOperation( "GetCircleColour", [IsCyclotomic, IsRecord] );
DeclareOperation( "SetCircleColours", [IsDenseList, IsRecord] );
DeclareOperation( "GetCircleColours", [IsRecord] );

DeclareOperation( "DrawSurfaceToJavaScript", [IsPolygonalComplex and IsNotEdgeRamified, IsString, IsRecord] );

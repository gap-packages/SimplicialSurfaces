
DeclareOperation( "SetVertexCoordiantes3DNC", [IsDenseList, IsRecord] );
DeclareOperation( "SetVertexCoordiantes3D", [IsPolygonalComplex and IsNotEdgeRamified, IsDenseList, IsRecord] );
DeclareOperation( "GetVertexCoordiantes3DNC", [IsCyclotomic, IsRecord] );
DeclareOperation( "GetVertexCoordiantes3D", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );

DeclareOperation( "CalculateParametersOfInnerCircle", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "ActivateInnerCircles", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "DeactivateInnerCircles", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "ActivateInnerCircle", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
DeclareOperation( "DeactivateInnerCircle", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
DeclareOperation( "IsInnerCircleActive", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );

DeclareOperation( "CalculateParametersOfEdges", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "ActivateEdges", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "DeactivateEdges", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "ActivateEdge", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
DeclareOperation( "DeactivateEdge", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
DeclareOperation( "IsEdgeActive", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );

DeclareOperation( "ActivateFaces", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "DeactivateFaces", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "ActivateFace", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
DeclareOperation( "DeactivateFace", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
DeclareOperation( "IsFaceActive", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );

DeclareOperation( "ActivateVertices", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "DeactivateVertices", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
DeclareOperation( "ActivateVertex", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
DeclareOperation( "DeactivateVertex", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
DeclareOperation( "IsVertexActive", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );

DeclareOperation( "SetFaceColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsString, IsRecord] );
DeclareOperation( "GetFaceColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
DeclareOperation( "SetFaceColours", [IsPolygonalComplex and IsNotEdgeRamified, IsDenseList, IsRecord] );
DeclareOperation( "GetFaceColours", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );

DeclareOperation( "SetVertexColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsString, IsRecord] );
DeclareOperation( "GetVertexColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
DeclareOperation( "SetVertexColours", [IsPolygonalComplex and IsNotEdgeRamified, IsDenseList, IsRecord] );
DeclareOperation( "GetVertexColours", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );

DeclareOperation( "SetEdgeColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsString, IsRecord] );
DeclareOperation( "GetEdgeColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
DeclareOperation( "SetEdgeColours", [IsPolygonalComplex and IsNotEdgeRamified, IsDenseList, IsRecord] );
DeclareOperation( "GetEdgeColours", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );

DeclareOperation( "SetCircleColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsString, IsRecord] );
DeclareOperation( "GetCircleColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
DeclareOperation( "SetCircleColours", [IsPolygonalComplex and IsNotEdgeRamified, IsDenseList, IsRecord] );
DeclareOperation( "GetCircleColours", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );

DeclareOperation( "DrawSurfaceToJavaScript", [IsPolygonalComplex and IsNotEdgeRamified, IsString, IsRecord] );

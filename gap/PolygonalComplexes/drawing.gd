
DeclareOperation( "DrawSurfaceToTikz", [IsPolygonalSurface, IsString, IsRecord] );

# mods
DeclareOperation( "PrintRecordADDMOD", [ IsString, IsRecord ] );


# drawing order
DeclareOperation( "PrintRecordDrawingOrderInit", [ IsRecord, IsPolygonalSurface ] );
DeclareOperation( "PrintRecordDrawingOrderCleanup", [IsRecord, IsPolygonalSurface] );
DeclareOperation( "PrintRecordDrawingOrderStartingFace", [IsRecord, IsPolygonalComplex, IsList] );


# metric data
DeclareOperation( "PrintRecordMetricDataInit", [IsRecord, IsPolygonalSurface] );
DeclareOperation( "PrintRecordMetricDataCleanup", [IsRecord, IsPolygonalSurface] );
DeclareOperation( "PrintRecordMetricDataComputeFace", [IsRecord, IsPolygonalSurface, IsPosInt] );
DeclareOperation( "PrintRecordMetricDataComputeFace", [IsRecord, IsPolygonalSurface, IsPosInt, IsList] );


# coordinates
DeclareOperation( "PrintRecordCoordinatesInit", [IsRecord, IsPolygonalSurface] );
DeclareOperation( "PrintRecordCoordinatesCleanup", [IsRecord, IsPolygonalSurface] );
DeclareOperation( "PrintRecordCoordinatesAddFace", [IsRecord, IsList, IsList] );


# drawing style
DeclareOperation( "PrintRecordDrawingStyleInit", [IsRecord, IsPolygonalSurface] );
DeclareOperation( "PrintRecordDrawingStyleCleanup", [IsRecord, IsPolygonalSurface] );



# colouring
DeclareOperation( "PrintRecordColouringInit", [IsRecord, IsPolygonalSurface] );
DeclareOperation( "PrintRecordColouringCleanup", [IsRecord, IsPolygonalSurface] );

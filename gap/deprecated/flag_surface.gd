##
## We want to give flag surfaces information about the original
## surface. We try making them into their own category.
##
DeclareCategory( "IsFlagSurface", IsSimplicialSurface );

DeclareAttribute( "OriginalSurface", IsFlagSurface );

DeclareAttribute( "FlagsVertices", IsFlagSurface );
DeclareAttribute( "FlagsEdges", IsFlagSurface );
DeclareAttribute( "FlagsFaces", IsFlagSurface );

DeclareOperation( "FlagSurface", [IsSimplicialSurface] );

DeclareOperation( "VertexByFlag", [IsFlagSurface, IsList] );
DeclareOperation( "EdgeByFlag", [IsFlagSurface, IsList] );
DeclareOperation( "FaceByFlag", [IsFlagSurface, IsList] );


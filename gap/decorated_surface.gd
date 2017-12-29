DeclareCategory( "IsDecoratedSurface", IsObject );
BindGlobal( "DecoratedSurfaceFamily", NewFamily( "DecoratedSurfaceFamily", IsObject, IsDecoratedSurface ) );

DeclareAttribute( "UnderlyingSurface", IsDecoratedSurface );
DeclareAttribute( "QuotientSurface", IsDecoratedSurface );
DeclareAttribute( "UnderlyingFlagSurface", IsDecoratedSurface );


DeclareAttribute( "EquivalenceLabelsOfVertices", IsDecoratedSurface );
DeclareAttribute( "EquivalenceLabelsOfEdges", IsDecoratedSurface );
DeclareAttribute( "EquivalenceLabelsOfFaces", IsDecoratedSurface );

DeclareAttribute( "EquivalenceLabelsOfFlagVertices", IsDecoratedSurface );
DeclareAttribute( "EquivalenceLabelsOfFlagEdges", IsDecoratedSurface );
DeclareAttribute( "EquivalenceLabelsOfFlagFaces", IsDecoratedSurface );


DeclareOperation( "DecoratedSurface", [IsSimplicialSurface] );

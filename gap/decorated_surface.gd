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


DeclareOperation( "IdentifyVertices", [IsDecoratedSurface, IsPosInt, IsPosInt] );
DeclareOperation( "IdentifyVertexClassLabels", [IsDecoratedSurface, IsPosInt, IsPosInt] );

DeclareOperation( "IdentifyEdges", [IsDecoratedSurface, IsList, IsList] );
DeclareOperation( "IdentifyEdgeClassLabels", [IsDecoratedSurface, IsList, IsList] );

DeclareOperation( "IdentifyFaces", [IsDecoratedSurface, IsList, IsList] );
DeclareOperation( "IdentifyFaceClassLabels", [IsDecoratedSurface, IsList, IsList] );

##
## Maybe later implement convenience access:
## EquivalenceClassesOfVertices
## VertexEquivalenceClasses [indexed by labels]
## VertexEquivalenceLabels [set]
##
## all also with flags -> automatic implementation necessary

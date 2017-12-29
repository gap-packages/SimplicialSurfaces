DeclareRepresentation( "IsDecoratedSurfaceRep", IsDecoratedSurface and IsAttributeStoringRep and IsComponentObjectRep );

DecoratedSurfaceType := NewType( DecoratedSurfaceFamily, IsDecoratedSurfaceRep );


InstallMethod( DecoratedSurface, "", [IsSimplicialSurface],
    function(complex)
        local dec, flags;

        flags := FlagSurface(complex);

        dec := Objectify( DecoratedSurfaceType, rec() );
        SetUnderlyingSurface(dec, complex);
        SetUnderlyingFlagSurface( dec, flags );
        SetEquivalenceLabelsOfVertices( dec, Vertices(complex) );
        SetEquivalenceLabelsOfEdges( dec, Edges(complex) );
        SetEquivalenceLabelsOfFaces( dec, Faces(complex) );
        SetEquivalenceLabelsOfFlagVertices( dec, Vertices(flags) );
        SetEquivalenceLabelsOfFlagEdges( dec, Edges(flags) );
        SetEquivalenceLabelsOfFlagFaces( dec, Faces(flags) );

        return dec;
    end
);



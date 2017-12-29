DeclareRepresentation( "IsDecoratedSurfaceRep", IsDecoratedSurface and IsAttributeStoringRep and IsComponentObjectRep, [] );

DecoratedSurfaceType := NewType( DecoratedSurfaceFamily, IsDecoratedSurfaceRep );


InstallMethod( DecoratedSurface, "", [IsSimplicialSurface],
    function(complex)
        local dec, flags;

        flags := FlagSurface(complex);

        dec := Objectify( DecoratedSurfaceType, rec() );
        SetUnderlyingSurface(dec, complex);
        SetUnderlyingFlagSurface( dec, flags );
        SetQuotientSurface(dec, complex);
        SetEquivalenceLabelsOfVertices( dec, Vertices(complex) );
        SetEquivalenceLabelsOfEdges( dec, Edges(complex) );
        SetEquivalenceLabelsOfFaces( dec, Faces(complex) );
        SetEquivalenceLabelsOfFlagVertices( dec, Vertices(flags) );
        SetEquivalenceLabelsOfFlagEdges( dec, Edges(flags) );
        SetEquivalenceLabelsOfFlagFaces( dec, Faces(flags) );

        return dec;
    end
);


InstallMethod( QuotientSurface, "", [IsDecoratedSurface],
    function(dec)
        local complex, vertices, edges, faces, verticesOfEdges,
            edgesOfFaces, edge, edgeClass, incVerts, verts,
            face, faceClass, incEdges, eds, quot, i;

        vertices := Set(EquivalenceLabelsOfVertices(dec));
        edges := Set(EquivalenceLabelsOfEdges(dec));
        faces := Set(EquivalenceLabelsOfFaces(dec));

        verticesOfEdges := [];
        for edge in edges do
            edgeClass := Positions( EquivalenceLabelsOfEdges(dec), edge );
            incVerts := List( edgeClass, e -> 
                Set( EquivalenceLabelsOfVertices(dec){
                    VerticesOfEdges(UnderlyingSurface(dec))[e] } ) );
            if ForAny(incVerts, v -> Size(v) <> 2) then
                return fail;
            fi;

            verts := Set( Flat(incVerts) );
            if Size(verts) <> 2 then
                return fail;
            fi;
            verticesOfEdges[edge] := verts;
        od;

        edgesOfFaces := [];
        for face in faces do
            faceClass := Positions( EquivalenceLabelsOfFaces(dec), face );
            incEdges := List( faceClass, f ->
                Set( EquivalenceLabelsOfEdges(dec){
                    EdgesOfFaces(UnderlyingSurface(dec))[f]
                } ));

            for i in [1..Size(incEdges)] do
                if Size(EdgesOfFaces(UnderlyingSurface(dec))[faceClass[i]]) <> Size( incEdges[i] ) then
                    return fail;
                fi;
            od;
            eds := Set( Flat( incEdges ) );
            if Size(eds) <> Size( EdgesOfFaces(UnderlyingSurface(dec))[faceClass[1]] ) then
                return fail;
            fi;
            edgesOfFaces[face] := eds; #TODO make a constructor version that checks for those and does not throw an error
        od;

        quot := Objectify( SimplicialSurfaceType, rec() ); #TODO problem if opposite vertices in a square are identified
        SetVerticesAttributeOfSimplicialSurface(quot, vertices);
        SetEdges(quot,edges);
        SetFaces(quot, faces);
        SetVerticesOfEdges(quot, verticesOfEdges);
        SetEdgesOfFaces(quot, edgesOfFaces);
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(quot);

        return quot;
    end
);

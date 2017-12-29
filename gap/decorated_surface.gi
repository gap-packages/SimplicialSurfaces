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

InstallMethod( UnderlyingFlagSurface, "", [IsDecoratedSurface],
    function(dec)
        return FlagSurface(UnderlyingSurface(dec));
    end
);

InstallMethod( IdentifyVertices, "", [IsDecoratedSurface, IsPosInt, IsPosInt],
    function(dec, v1, v2)
        local vl1, vl2;

        vl1 := EquivalenceLabelsOfVertices(dec)[v1];
        vl2 := EquivalenceLabelsOfVertices(dec)[v2];
        if vl1 = vl2 then
            return dec;
        else
            return IdentifyVertexClassLabels(dec,vl1,vl2);
        fi;
    end
);

BindGlobal( "__SIMPLICIAL_ReplaceValueInList", 
    function( list, oldValue, newValue )
        local i, res;

        res := ShallowCopy(list);

        for i in [1..Size(res)] do
            if IsBound(res[i]) and res[i] = oldValue then
                res[i] := newValue;
            fi;
        od;

        return res;
    end
);

InstallMethod( IdentifyVertexClassLabels, "", [IsDecoratedSurface, IsPosInt, IsPosInt],
    function(dec, label1, label2)
        local comp, vertexEq, flagVertexEq, verts1, verts2, flagLabel1, flagLabel2;

        vertexEq := __SIMPLICIAL_ReplaceValueInList( EquivalenceLabelsOfVertices(dec), label2, label1 );

        # Find the corresponding labels for the flag surface
        verts1 := Positions( EquivalenceLabelsOfVertices(dec), label1 );
        verts2 := Positions( EquivalenceLabelsOfVertices(dec), label2 );
        flagLabel1 := EquivalenceLabelsOfFlagVertices(dec)[ VertexByFlag( UnderlyingFlagSurface(dec), [0,verts1[1]] ) ];
        flagLabel2 := EquivalenceLabelsOfFlagVertices(dec)[ VertexByFlag( UnderlyingFlagSurface(dec), [0,verts2[1]] ) ];
        flagVertexEq := __SIMPLICIAL_ReplaceValueInList( EquivalenceLabelsOfFlagVertices(dec), flagLabel1, flagLabel2 );

        comp := Objectify( DecoratedSurfaceType, rec() );
        SetUnderlyingSurface(comp, UnderlyingSurface(dec));
        SetEquivalenceLabelsOfEdges(comp, EquivalenceLabelsOfEdges(dec));
        SetEquivalenceLabelsOfFlagEdges(comp, EquivalenceLabelsOfFlagEdges(dec));
        SetEquivalenceLabelsOfFaces(comp, EquivalenceLabelsOfFaces(dec));
        SetEquivalenceLabelsOfFlagFaces(comp, EquivalenceLabelsOfFlagFaces(dec));

        SetEquivalenceLabelsOfVertices(comp, vertexEq);
        SetEquivalenceLabelsOfFlagVertices(comp, flagVertexEq);

        return comp;
    end
);

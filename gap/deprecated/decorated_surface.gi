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


DeclareGlobalFunction( "__SIMPLICIAL_PairIdentificationsInList" );
#TODO has this to be declared before (since it is recursive)?
InstallGlobalFunction( "__SIMPLICIAL_PairIdentificationsInList",
    function( list, pairs )
        local res;

        if Size(pairs) = 0 then
            return list;
        fi;

        res := __SIMPLICIAL_ReplaceValueInList(list, pairs[1][2], pairs[1][1]);
        return __SIMPLICIAL_PairIdentificationsInList( res, 
            List( pairs{[2..Size(pairs)]}, 
                p -> __SIMPLICIAL_ReplaceValueInList(p, pairs[1][2], pairs[1][1]) ));
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

InstallMethod( IdentifyEdgeClassLabels, "", [IsDecoratedSurface, IsList, IsList],
    function(dec, edge1, edge2)
        local v1, e1, v2, e2;

        v1 := Position( EquivalenceLabelsOfVertices(dec), edge1[1] );
        v2 := Position( EquivalenceLabelsOfVertices(dec), edge2[1] );
        e1 := Position( EquivalenceLabelsOfEdges(dec), edge1[2] );
        e2 := Position( EquivalenceLabelsOfEdges(dec), edge2[2] );

        return IdentifyEdges( dec, [v1,e1], [v2,e2] );
    end
);

InstallMethod( IdentifyEdges, "", [IsDecoratedSurface, IsList, IsList],
    function(dec, flag1, flag2)
        local comp, v1, v2, e1, e2, w1, w2, v1L, v2L, e1L, e2L, w1L, w2L,
            vertexEq, edgeEq, flagVertexEq, flagEdgeEq, flagSurf,
            v1F,v2F,w1F,w2F,e1F,e2F,ve1F,ve2F,we1F,we2F;

        v1 := flag1[1];
        v2 := flag2[1];
        e1 := flag1[2];
        e2 := flag2[2];
        w1 := OtherVertexOfEdge( UnderlyingSurface(dec), v1, e1 );
        w2 := OtherVertexOfEdge( UnderlyingSurface(dec), v2, e2 );

        # Identification on the surface
        v1L := EquivalenceLabelsOfVertices(dec)[v1];
        v2L := EquivalenceLabelsOfVertices(dec)[v2];
        e1L := EquivalenceLabelsOfEdges(dec)[e1];
        e2L := EquivalenceLabelsOfEdges(dec)[e2];
        w1L := EquivalenceLabelsOfVertices(dec)[w1];
        w2L := EquivalenceLabelsOfVertices(dec)[w2];

        vertexEq := __SIMPLICIAL_PairIdentificationsInList( 
            EquivalenceLabelsOfVertices(dec),
            [
                [ v2L, v1L ], [w2L, w1L]
            ]);
        edgeEq := __SIMPLICIAL_ReplaceValueInList( EquivalenceLabelsOfEdges(dec), e2L, e1L );

        # Identification on the flag surface
        flagSurf := UnderlyingFlagSurface(dec);
        v1F := VertexByFlag( flagSurf, [0,v1] );
        v2F := VertexByFlag( flagSurf, [0,v2] );
        w1F := VertexByFlag( flagSurf, [0,w1] );
        w2F := VertexByFlag( flagSurf, [0,w2] );
        e1F := VertexByFlag( flagSurf, [1,e1] );
        e2F := VertexByFlag( flagSurf, [1,e2] );
        ve1F := EdgeByFlag( flagSurf, [1,[v1,e1]] );
        ve2F := EdgeByFlag( flagSurf, [1,[v2,e2]] );
        we1F := EdgeByFlag( flagSurf, [1,[w1,e1]] );
        we2F := EdgeByFlag( flagSurf, [1,[w2,e2]] );

        flagVertexEq := __SIMPLICIAL_PairIdentificationsInList(
            EquivalenceLabelsOfFlagVertices(dec),
            [
                [ EquivalenceLabelsOfFlagVertices(dec)[v2F], EquivalenceLabelsOfFlagVertices(dec)[v1F] ],
                [ EquivalenceLabelsOfFlagVertices(dec)[w2F], EquivalenceLabelsOfFlagVertices(dec)[w1F] ],
                [ EquivalenceLabelsOfFlagVertices(dec)[e2F], EquivalenceLabelsOfFlagVertices(dec)[e1F] ]
            ]
        );
        flagEdgeEq := __SIMPLICIAL_PairIdentificationsInList(
            EquivalenceLabelsOfFlagEdges(dec),
            [
                [ EquivalenceLabelsOfFlagEdges(dec)[ve2F], EquivalenceLabelsOfFlagEdges(dec)[ve1F] ],
                [ EquivalenceLabelsOfFlagEdges(dec)[we2F], EquivalenceLabelsOfFlagEdges(dec)[we1F] ],
            ]
        );


        comp := Objectify( DecoratedSurfaceType, rec() );
        SetUnderlyingSurface( comp, UnderlyingSurface(dec) );
        SetEquivalenceLabelsOfFaces(comp, EquivalenceLabelsOfFaces(dec));
        SetEquivalenceLabelsOfFlagFaces(comp, EquivalenceLabelsOfFlagFaces(dec));

        SetEquivalenceLabelsOfVertices(comp, vertexEq);
        SetEquivalenceLabelsOfEdges(comp, edgeEq);
        SetEquivalenceLabelsOfFlagVertices(comp, flagVertexEq);
        SetEquivalenceLabelsOfFlagEdges(comp, flagEdgeEq);

        return comp;
    end
);

InstallMethod( IdentifyFaceClassLabels, "", [IsDecoratedSurface, IsList, IsList],
    function(dec, flag1, flag2)
        local v1, e1, f1, v2, e2, f2;

        v1 := Position( EquivalenceLabelsOfVertices(dec), flag1[1] );
        v2 := Position( EquivalenceLabelsOfVertices(dec), flag2[1] );
        e1 := Position( EquivalenceLabelsOfEdges(dec), flag1[2] );
        e2 := Position( EquivalenceLabelsOfEdges(dec), flag2[2] );
        f1 := Position( EquivalenceLabelsOfFaces(dec), flag1[3] );
        f2 := Position( EquivalenceLabelsOfFaces(dec), flag2[3] );

        return IdentifyFaces( dec, [v1,e1,f1], [v2,e2,f2] );
    end
);

InstallMethod( IdentifyFaces, "", [IsDecoratedSurface, IsList, IsList],
    function(dec, flag1, flag2)
        local v1, v2, e1, e2, f1, f2, surf, flagSurf, surfVerts, surfEdges,
            surfFaces, flagVerts, flagEdges, flagFaces, i, comp, vertexEq,
            edgeEq, faceEq, flagVertexEq, flagEdgeEq, flagFaceEq;

        v1 := flag1[1];
        e1 := flag1[2];
        f1 := flag1[3];
        v2 := flag2[1];
        e2 := flag2[2];
        f2 := flag2[3];

        surf := UnderlyingSurface(dec);
        flagSurf := UnderlyingFlagSurface(dec);

        if Size( EdgesOfFaces(surf)[f1] ) <> Size( EdgesOfFaces(surf)[f2] ) then
            Error("Identified faces have to have the same number of vertices.");
        fi;

        surfVerts := [];
        surfEdges := [];
        surfFaces := [ [f1,f2] ];
        flagVerts := [ [ [2,f1], [2,f2] ] ];
        flagEdges := [];
        flagFaces := [];
        for i in [1..Size(EdgesOfFaces(surf)[f1])] do
            # Register the pairs for this flag
            if IsOddInt(i) then
                Add(surfVerts, [v1,v2]);
                Add(flagVerts, [[0,v1],[0,v2]]);
                Add(flagEdges, [[2,[v1,f1]],[2,[v2,f2]]]);
            else
                Add(surfEdges, [e1,e2]);
                Add(flagVerts, [[1,e1],[1,e2]]);
                Add(flagEdges, [[3,[e1,f1]],[3,[e2,f2]]]);
            fi;
            Add(flagEdges, [ [1,[v1,e1]],[1,[v2,e2]] ]);
            Add(flagFaces, [ [v1,e1,f1],[v2,e2,f2] ]);

            # Find the next flag
            if IsOddInt(i) then
                v1 := OtherVertexOfEdge(surf, v1, e1);
                v2 := OtherVertexOfEdge(surf, v2, e2);
            else
                e1 := OtherEdgeOfVertexInFace(surf, v1, e1, f1);
                e2 := OtherEdgeOfVertexInFace(surf, v2, e2, f2);
            fi;
        od;

        # Convert the flag pairs into numbers
        flagVerts := List( flagVerts, p -> List( p, v -> VertexByFlag(flagSurf, v) ) );
        flagEdges := List( flagEdges, p -> List( p, e -> EdgeByFlag(flagSurf, e) ) );
        flagFaces := List( flagFaces, p -> List( p, f -> FaceByFlag(flagSurf, f) ) );

        vertexEq := __SIMPLICIAL_PairIdentificationsInList( 
            EquivalenceLabelsOfVertices(dec), surfVerts);
        edgeEq := __SIMPLICIAL_PairIdentificationsInList(
            EquivalenceLabelsOfEdges(dec), surfEdges);
        faceEq := __SIMPLICIAL_PairIdentificationsInList(
            EquivalenceLabelsOfFaces(dec), surfFaces);

        flagVertexEq := __SIMPLICIAL_PairIdentificationsInList(
            EquivalenceLabelsOfFlagVertices(dec), flagVerts);
        flagEdgeEq := __SIMPLICIAL_PairIdentificationsInList(
            EquivalenceLabelsOfFlagEdges(dec), flagEdges);
        flagFaceEq := __SIMPLICIAL_PairIdentificationsInList(
            EquivalenceLabelsOfFlagFaces(dec), flagFaces);

        comp := Objectify( DecoratedSurfaceType, rec() );
        SetUnderlyingSurface(comp, surf);
        SetEquivalenceLabelsOfVertices(comp, vertexEq);
        SetEquivalenceLabelsOfEdges(comp, edgeEq);
        SetEquivalenceLabelsOfFaces(comp, faceEq);
        SetEquivalenceLabelsOfFlagVertices(comp, flagVertexEq);
        SetEquivalenceLabelsOfFlagEdges(comp, flagEdgeEq);
        SetEquivalenceLabelsOfFlagFaces(comp, flagFaceEq);

        return comp;
    end
);

DeclareRepresentation( "IsFlagSurfaceRep", IsFlagSurface, [] );

FlagSurfaceType := NewType( SimplicialSurfaceFamily, IsFlagSurfaceRep );


InstallMethod( FlagSurface, "for a simplicial surface", [IsSimplicialSurface],
    function(complex)
        local oneFlags, twoFlags, threeFlags, verticesOfEdges, edgesOfFaces, flagComplex, i, tF;

        threeFlags := AllFlags(complex);
        oneFlags := Concatenation(
            List( Vertices(complex), v -> [0,v] ),
            List( Edges(complex), e -> [1,e] ),
            List( Faces(complex), f -> [2,f] )
        );
        twoFlags := Concatenation( 
            List( Set( List( threeFlags, f -> [ f[1], f[2] ] ) ), s -> [1,s] ),
            List( Set( List( threeFlags, f -> [ f[1], f[3] ] ) ), s -> [2,s] ),
            List( Set( List( threeFlags, f -> [ f[2], f[3] ] ) ), s -> [3,s] )
        );

        verticesOfEdges := [];
        edgesOfFaces := [];

        for i in [1..Size(twoFlags)] do
            tF := twoFlags[i];
            if tF[1] = 1 then
                # Vertex-Edge-Flag
                verticesOfEdges[i] := [ Position(oneFlags, [0,tF[2][1]]), Position(oneFlags, [1,tF[2][2]]) ];
            elif tF[1] = 2 then
                # Vertex-Face-Flag
                verticesOfEdges[i] := [ Position(oneFlags, [0,tF[2][1]]), Position(oneFlags, [2,tF[2][2]]) ];
            elif tF[1] = 3 then
                # Edge-Face-Flag
                verticesOfEdges[i] := [ Position(oneFlags, [1,tF[2][1]]), Position(oneFlags, [2,tF[2][2]]) ];
            else
                Error("InternalError");
            fi;
        od;

        for i in [1..Size(threeFlags)] do
            tF := threeFlags[i];
            edgesOfFaces[i] := [
                Position( twoFlags, [1, [tF[1],tF[2]]] ),
                Position( twoFlags, [2, [tF[1],tF[3]]] ),
                Position( twoFlags, [3, [tF[2],tF[3]]] )
            ];
        od;

        flagComplex := Objectify( FlagSurfaceType, rec() );
        SetVerticesOfEdges(flagComplex, verticesOfEdges);
        SetEdgesOfFaces(flagComplex, edgesOfFaces);
		DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(flagComplex);

        SetOriginalSurface(flagComplex, complex);
        SetFlagsVertices(flagComplex, oneFlags);
        SetFlagsEdges(flagComplex, twoFlags);
        SetFlagsFaces(flagComplex, threeFlags);

        return flagComplex;
    end
);

InstallMethod( VertexByFlag, "", [IsFlagSurface, IsList],
    function(fs, flag)
        return Position(FlagsVertices(fs), flag  );
    end
);
InstallMethod( EdgeByFlag, "", [IsFlagSurface, IsList],
    function(fs, flag)
        return Position(FlagsEdges(fs), flag  );
    end
);
InstallMethod( FaceByFlag, "", [IsFlagSurface, IsList],
    function(fs, flag)
        return Position(FlagsFaces(fs), flag  );
    end
);

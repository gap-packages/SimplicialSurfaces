#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2018
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################


#######################################
##
##      General flags
##
InstallMethod( Flags, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        local flags, v, e, f;

        flags := [];
        for e in Edges(complex) do
            for v in VerticesOfEdges(complex)[e] do
                for f in FacesOfEdges(complex)[e] do
                    Add(flags, [v,e,f]);
                od;
            od;
        od;

        return Set(flags);
    end
);
InstallMethod( ThreeFlags, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        return Flags(complex);
    end
);

InstallMethod( VertexEdgeFlags, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        local flags, v, e;
        
        flags := [];
        for e in Edges(complex) do
            for v in VerticesOfEdges(complex)[e] do
                Add(flags,[v,e]);
            od;
        od;
    
        return Set(flags);
    end
);
InstallMethod( VertexFaceFlags, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        local flags, v, f;
        
        flags := [];
        for v in Vertices(complex) do
            for f in FacesOfVertices(complex)[v] do
                Add(flags,[v,f]);
            od;
        od;
    
        return Set(flags);
    end
);
InstallMethod( EdgeFaceFlags, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        local flags, f, e;
        
        flags := [];
        for e in Edges(complex) do
            for f in FacesOfEdges(complex)[e] do
                Add(flags,[e,f]);
            od;
        od;
    
        return Set(flags);
    end
);
InstallMethod( TwoFlags, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        local ve, vf, ef, flags;

        ve := VertexEdgeFlags(complex);
        vf := VertexFaceFlags(complex);
        ef := EdgeFaceFlags(complex);

        flags := [];
        Append( flags, List(ve, f -> [1,f]) );
        Append( flags, List(vf, f -> [2,f]) );
        Append( flags, List(ef, f -> [3,f]) );

        return flags;
    end
);


InstallMethod( OneFlags, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        local flags;

        flags := [];
        Append(flags, List(Vertices(complex), v -> [0,v]));
        Append(flags, List(Edges(complex), e -> [1,e]));
        Append(flags, List(Faces(complex), f -> [2,f]));

        return flags;
    end
);


##
##      End of general flags
##
#######################################



#######################################
##
##      Dress involutions
##
InstallMethod( DressInvolutions, "for a ramified polygonal surface", 
    [IsRamifiedPolygonalSurface],
    function(complex)
        local inv, flags, i, vPerm, ePerm, fPerm, fl;

        inv := [];
        flags := Flags(complex);

        vPerm := [];
        ePerm := [];
        fPerm := [];
        for i in [1..Size(flags)] do
            fl := flags[i];
            vPerm[i] := Position( flags, [ OtherVertexOfEdgeNC(complex,fl[1],fl[2]), fl[2], fl[3] ] );
            ePerm[i] := Position( flags, [ fl[1], OtherEdgeOfVertexInFaceNC(complex, fl[1], fl[2], fl[3]), fl[3] ] );
            if IsBoundaryEdge(complex, fl[2]) then
                fPerm[i] := i;
            else
                fPerm[i] := Position( flags, [ fl[1], fl[2], NeighbourFaceByEdgeNC(complex, fl[3], fl[2]) ] );
            fi;
        od;
        inv[1] := PermList(vPerm);
        inv[2] := PermList(ePerm);
        inv[3] := PermList(fPerm);

        return inv;
    end
);

InstallMethod( DressGroup, "for a ramified polygonal surface",
    [IsRamifiedPolygonalSurface],
    function(complex)
        return Group( DressInvolutions(complex) );
    end
);
##
##      End of Dress involutions
##
#######################################



#######################################
##
##      Flag complexes
##
InstallMethod( IsRamifiedFlagSurface, 
    "for an edge coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComp)
        return IsEdgeColouredRamifiedPolygonalSurface(colComp) and IsFlagComplex(colComp);
    end
);
InstallMethod( IsFlagSurface, 
    "for an edge coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComp)
        return IsEdgeColouredPolygonalSurface(colComp) and IsFlagComplex(colComp);
    end
);



InstallMethod( FlagComplex, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        local oneFlags, twoFlags, threeFlags, verticesOfEdges, facesOfEdges,
            cols, e, incVert, v, f, incFaces, colComp, newComp;

        oneFlags := OneFlags(complex);
        twoFlags := TwoFlags(complex);
        threeFlags := ThreeFlags(complex);

        verticesOfEdges := [];
        facesOfEdges := [];
        cols := [];
        for e in [1..Length(twoFlags)] do
            # Compute colour
            cols[e] := twoFlags[e][1];

            # Compute VerticesOfEdges
            incVert := [];
            for v in [1..Length(oneFlags)] do
                if oneFlags[v][1] = 0 then # oneFlag is vertex
                    if twoFlags[e][1] = 1 and oneFlags[v][2] = twoFlags[e][2][1] then
                        Add(incVert, v);
                    elif twoFlags[e][1] = 2 and oneFlags[v][2] = twoFlags[e][2][1] then
                        Add(incVert, v);
                    fi;
                elif oneFlags[v][1] = 1 then # oneFlag is edge
                    if twoFlags[e][1] = 1 and oneFlags[v][2] = twoFlags[e][2][2] then
                        Add(incVert, v);
                    elif twoFlags[e][1] = 3 and oneFlags[v][2] = twoFlags[e][2][1] then
                        Add(incVert, v);
                    fi;
                else # oneFlag is face
                    if twoFlags[e][1] = 2 and oneFlags[v][2] = twoFlags[e][2][2] then
                        Add(incVert, v);
                    elif twoFlags[e][1] = 3 and oneFlags[v][2] = twoFlags[e][2][2] then
                        Add(incVert, v);
                    fi;
                fi;
            od;
            verticesOfEdges[e] := incVert;

            # Compute FacesOfEdges
            incFaces := [];
            for f in [1..Length(threeFlags)] do
                if twoFlags[e][1] = 1 and twoFlags[e][2][1] = threeFlags[f][1] and twoFlags[e][2][2] = threeFlags[f][2] then
                    Add(incFaces, f);
                elif twoFlags[e][1] = 2 and twoFlags[e][2][1] = threeFlags[f][1] and twoFlags[e][2][2] = threeFlags[f][3] then
                    Add(incFaces, f);
                elif twoFlags[e][1] = 3 and twoFlags[e][2][1] = threeFlags[f][2] and twoFlags[e][2][2] = threeFlags[f][3] then
                    Add(incFaces, f);
                fi;
            od;
            facesOfEdges[f] := incFaces;
        od;

        newComp := Objectify(PolygonalComplexType, rec());
        SetVerticesOfEdges(newComp, verticesOfEdges);
        SetFacesOfEdges(newComp, facesOfEdges);

        colComp := EdgeColouredPolygonalComplex(newComp, cols);
        SetOriginalComplex(colComp, complex);
        SetIsFlagComplex(colComp, true);

        return colComp;
    end
);

InstallMethod( IsRamifiedFlagSurface,
    "for a ramified polygonal surface", [IsRamifiedPolygonalSurface],
    function(ramSurf)
        return FlagComplex(ramSurf);
    end
);
RedispatchOnCondition( IsRamifiedFlagSurface, true, [IsPolygonalComplex],
    [IsRamifiedPolygonalSurface], 0);
InstallMethod( IsFlagSurface,
    "for a polygonal surface", [IsPolygonalSurface],
    function(surf)
        return FlagComplex(surf);
    end
);
RedispatchOnCondition( IsFlagSurface, true, [IsPolygonalComplex],
    [IsPolygonalSurface], 0);





InstallMethod( OriginalRamifiedSurface, "for a ramified flag surface", 
    [IsRamifiedFlagSurface],
    function(flagComp)
        return OriginalComplex(flagComp);
    end
);
RedispatchOnCondition( OriginalRamifiedSurface, true, [IsFlagComplex],
    [IsRamifiedFlagSurface], 0);
InstallMethod( OriginalSurface, "for a flag surface", 
    [IsFlagSurface],
    function(flagComp)
        return OriginalComplex(flagComp);
    end
);
RedispatchOnCondition( OriginalSurface, true, [IsFlagComplex],
    [IsFlagSurface], 0);

##
##      End of flag complexes
##
#######################################

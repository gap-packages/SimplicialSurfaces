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
        for v in VerticesAttributeOfVEFComplex(complex) do
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
        Append(flags, List(VerticesAttributeOfVEFComplex(complex), v -> [0,v]));
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
InstallMethod( DressInvolutions, 
    "for a polygonal complex without edge ramifications", 
    [IsPolygonalComplex and IsNotEdgeRamified],
    function(complex)
        local inv, flags, i, vPerm, ePerm, fPerm, fl;

        inv := [];
        flags := Flags(complex);

        vPerm := [];
        ePerm := [];
        fPerm := [];
        for i in [1..Length(flags)] do
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

InstallMethod( DressGroup, "for a VEF-complex without edge ramifications",
    [IsVEFComplex and IsNotEdgeRamified],
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
DeclareRepresentation("FlagComplexRep", IsFlagComplex and IsAttributeStoringRep, []);
BindGlobal("FlagComplexType", NewType(EdgeColouredPolygonalComplexFamily, FlagComplexRep));

InstallMethod( IsFlagSurface, 
    "for an edge coloured polygonal complex",
    [IsFlagComplex],
    function(colComp)
        return IsEdgeColouredPolygonalComplex(colComp) and IsNotEdgeRamified(colComp) and IsNotVertexRamified(colComp) and IsFlagComplex(colComp);
    end
);



InstallMethod( FlagComplex, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        local oneFlags, twoFlags, threeFlags, verticesOfEdges, facesOfEdges,
            cols, e, incVert, v, f, incFaces, newComp, flagComp;

        oneFlags := OneFlags(complex);
        twoFlags := TwoFlags(complex);
        threeFlags := ThreeFlags(complex);

        verticesOfEdges := [];
        facesOfEdges := [];
        cols := [];
        for e in [1..Length(twoFlags)] do
            # Compute colour
            cols[e] := 4 - twoFlags[e][1];

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
            facesOfEdges[e] := incFaces;
        od;

        newComp := Objectify(PolygonalComplexType, rec());
        SetVerticesOfEdges(newComp, verticesOfEdges);
        SetFacesOfEdges(newComp, facesOfEdges);

        flagComp := Objectify(FlagComplexType,rec());
        SetOriginalComplex(flagComp, complex);
        SetPolygonalComplex(flagComp, newComp);
        SetColoursOfEdges(flagComp, cols);

        return flagComp;
    end
);

InstallMethod( FlagSurface,
    "for a polygonal surface", [IsPolygonalSurface],
    function(surf)
        return FlagComplex(surf);
    end
);
RedispatchOnCondition( FlagSurface, true, [IsPolygonalComplex],
    [IsPolygonalSurface], 0);



# Assume that this attribute is set if it is known that the complex
# is a flag complex
RedispatchOnCondition( OriginalComplex, true, 
    [IsEdgeColouredPolygonalComplex], [IsFlagComplex], 0 );

InstallMethod( OriginalSurface, "for a flag surface", 
    [IsFlagSurface],
    function(flagComp)
        return OriginalComplex(flagComp);
    end
);
RedispatchOnCondition( OriginalSurface, true, [IsFlagComplex],
    [IsFlagSurface], 0);


InstallMethod( IsomorphicFlagSurface, "for a tame coloured surface", 
    [IsTameColouredSurface],
    function(tameSurf)
        local perms, bound, i, origVerts, origEdges, origFaces, verticesOfEdges,
            edgesOfFaces, flags, m, vert, edge, face, surf;

        if 2 in LocalSymmetryOfColours(tameSurf) then
            return fail; # has to be MMM-surface
        fi;

        perms := [];
        bound := __SIMPLICIAL_BoundPositions(ColourInvolutions(tameSurf));
        for i in [1..Length(bound)] do
            perms[i] := ColourInvolutions(tameSurf)[bound[i]];
        od;

        # Check the order conditions
        if (perms[1]*perms[2])^3 <> () then
            return false;
        fi;
        if (perms[1]*perms[3])^2 <> () then
            return false;
        fi;


        # Reconstruct the flags of the original surface
        origFaces := Orbits( Group( perms[1], perms[2] ), Faces(PolygonalComplex(tameSurf)) );
        origEdges := Orbits( Group( perms[1], perms[3] ), Faces(PolygonalComplex(tameSurf)) );
        origVerts := Orbits( Group( perms[2], perms[3] ), Faces(PolygonalComplex(tameSurf)) );

        verticesOfEdges := List( [1..Length(origEdges)], i->[] );
        edgesOfFaces := List( [1..Length(origFaces)], i -> [] );

        flags := [];
        for m in Faces(PolygonalComplex(tameSurf)) do
            vert := PositionProperty( origVerts, v -> m in v );
            edge := PositionProperty( origEdges, e -> m in e );
            face := PositionProperty( origFaces, f -> m in f );
            flags[m] := [vert,edge,face];
            verticesOfEdges[edge] := Union( verticesOfEdges[edge], [vert] );
            edgesOfFaces[face] := Union( edgesOfFaces[face], [edge] );
        od;
        
        # Check if the flags belong to a simplicial surface (there might be a problem if two edges of the same face are identified).
        if Length( Set(flags) ) < Number(flags) then
            # There is a problem
            return true;
        fi;

        surf := SimplicialSurfaceByDownwardIncidenceNC( Length(origVerts), Length(origEdges), Length(origFaces),
            verticesOfEdges, edgesOfFaces); #TODO constructor by flags
        return FlagSurface(surf);
    end
);
RedispatchOnCondition(IsomorphicFlagSurface, true, [IsEdgeColouredPolygonalComplex], [IsTameColouredSurface], 0);


InstallOtherMethod( DrawSurfaceToTikz, 
    "for a flag complex without edge ramifications, a file name and a print record",
    [IsFlagComplex and IsNotEdgeRamified, IsString, IsRecord],
    function(flagSurf, file, printRecord)
        local complex, faceSizes, twoFlag, n, e;

        complex := PolygonalComplex(flagSurf);

        if not IsBound(printRecord.edgeLengths) and not IsBound(printRecord.edgeColourClassLengths) then
            # no length information given
            faceSizes := List( VerticesOfFaces(OriginalComplex(flagSurf)), Length );
            if Length( Set(faceSizes) ) <> 1 or ( IsBound(printRecord.edgeColourClassActive) and not printRecord.edgeColourClassActive ) then
                # edge lengths not colour invariant
                printRecord.edgeColourClassActive := false;
                printRecord.edgeLengths := [];
                printRecord.edgeColours := [];
                for e in Edges(complex) do
                    twoFlag := TwoFlags(OriginalComplex(flagSurf))[e];
                    if twoFlag[1] = 1 then # vertex-edge-flag
                        printRecord.edgeLengths[e] := 1;
                        printRecord.edgeColours[e] := "blue";
                    elif twoFlag[1] = 2 then # vertex-face-flag
                        n := faceSizes[twoFlag[2][2]];
                        printRecord.edgeLengths[e] := 1/Sin(FLOAT.PI/n);
                        printRecord.edgeColours[e] := "green";
                    else # edge-face-flag
                        n := faceSizes[twoFlag[2][2]];
                        printRecord.edgeLengths[e] := 1/Tan(FLOAT.PI/n);
                        printRecord.edgeColours[e] := "red";
                    fi;
                od;
            else
                # edge lengths colour invariant
                n := faceSizes[1];
                printRecord.edgeColourClassLengths := [ 1/Tan(FLOAT.PI/n), 1/Sin(FLOAT.PI/n), 1 ];
            fi;
        fi;

        TryNextMethod();
    end
);
RedispatchOnCondition( DrawSurfaceToTikz, true, 
    [IsFlagComplex, IsString, IsRecord], [IsNotEdgeRamified], 0 );

##
##      End of flag complexes
##
#######################################

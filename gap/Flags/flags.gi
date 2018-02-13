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

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

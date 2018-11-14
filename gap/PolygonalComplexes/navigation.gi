#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2019
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################


#######################################
##
##      Moving along edges
##
InstallMethod( IsVerticesAdjacentNC, "for a VEF-complex and two vertices",
    [IsVEFComplex, IsPosInt, IsPosInt],
    function(complex, v1, v2)
        if v1 < v2 then
            return [v1,v2] in VerticesOfEdges(complex);
        else
            return [v2,v1] in VerticesOfEdges(complex);
        fi;
    end
);
InstallMethod( IsVerticesAdjacent, "for a VEF-complex and two vertices",
    [IsVEFComplex, IsPosInt, IsPosInt],
    function(complex, v1, v2)
        local name;

        name := "IsVerticesAdjacent";
        __SIMPLICIAL_CheckVertex(complex, v1, name);
        __SIMPLICIAL_CheckVertex(complex, v2, name);

        return IsVerticesAdjacentNC(complex, v1, v2);
    end
);

InstallMethod( EdgesBetweenVerticesNC, "for a VEF-complex and two vertices",
    [IsVEFComplex, IsPosInt, IsPosInt],
    function(complex, v1, v2)
        local res, e1, e2, e;

        res := [];
        e1 := EdgesOfVertices(complex)[v1];
        e2 := EdgesOfVertices(complex)[v2];
        for e in e1 do
            if e in e2 then
                Add(res,e);
            fi;
        od;

        return res;
    end
);
InstallMethod( EdgesBetweenVertices, "for a VEF-complex and two vertices",
    [IsVEFComplex, IsPosInt, IsPosInt],
    function(complex, v1, v2)
        local name;

        name := "EdgesBetweenVertices";
        __SIMPLICIAL_CheckVertex(complex, v1, name);
        __SIMPLICIAL_CheckVertex(complex, v2, name);

        return EdgesBetweenVerticesNC(complex, v1, v2);
    end
);

InstallMethod( EdgeBetweenVerticesNC, "for a VEF-complex and two vertices",
    [IsVEFComplex, IsPosInt, IsPosInt],
    function(complex, v1, v2)
        local edges;

        edges := EdgesBetweenVerticesNC(complex, v1, v2);
        if Length(edges) = 1 then
            return edges[1];
        else
            return fail;
        fi;
    end
);
InstallMethod( EdgeBetweenVertices, "for a VEF-complex and two vertices",
    [IsVEFComplex, IsPosInt, IsPosInt],
    function(complex, v1, v2)
        local name;

        name := "EdgeBetweenVertices";
        __SIMPLICIAL_CheckVertex(complex, v1, name);
        __SIMPLICIAL_CheckVertex(complex, v2, name);

        return EdgeBetweenVerticesNC(complex,v1,v2);
    end
);


InstallMethod( OtherVertexOfEdgeNC,
    "for a polygonal complex, a vertex, and an edge",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function( complex, vertex, edge )
        local possVert;
        
        possVert := VerticesOfEdges(complex)[edge];
        if vertex = possVert[1] then
            return possVert[2];
        else
            return possVert[1];
        fi;
    end
);
InstallMethod( OtherVertexOfEdgeNC,
    "for a bend polygonal complex, a vertex, and an edge",
    [IsBendPolygonalComplex, IsPosInt, IsPosInt],
    function( complex, vertex, edge )
        local possVert;
        
        possVert := VerticesOfEdges(complex)[edge];
        if Length(possVert) = 1 then
            return possVert[1];
        fi;

        if vertex = possVert[1] then
            return possVert[2];
        else
            return possVert[1];
        fi;
    end
);
InstallMethod( OtherVertexOfEdge,
    "for a VEF-complex, a vertex, and an edge",
    [IsVEFComplex, IsPosInt, IsPosInt],
    function( complex, vertex, edge )
        local name;
        
        name := "OtherVertexOfEdge";
        __SIMPLICIAL_CheckEdge(complex, edge, name);
        __SIMPLICIAL_CheckIncidenceVertexEdge(complex, vertex, edge, name);
        return OtherVertexOfEdgeNC(complex, vertex, edge);
    end
);



#######################################
##
##      Moving within faces
##
InstallMethod( EdgesInFaceByVerticesNC,
    "for a VEF-complex, a face, and a set of two vertices",
    [IsVEFComplex, IsPosInt, IsSet],
    function( complex, face, vertSet )
        return Filtered( EdgesOfFaces(complex)[face], e ->
            VerticesOfEdges(complex)[e] = vertSet);
    end
);
InstallMethod( EdgesInFaceByVerticesNC,
    "for a VEF-complex, a face, and a list of two vertices",
    [IsVEFComplex, IsPosInt, IsList],
    function( complex, face, vertList )
        return EdgesInFaceByVerticesNC(complex, face, Set(vertList));
    end
);
InstallMethod( EdgesInFaceByVertices,
    "for a VEF-complex, a face, and a set of two vertices",
    [IsVEFComplex, IsPosInt, IsSet],
    function( complex, face, vertSet )
        __SIMPLICIAL_CheckFace(complex, face, "EdgesInFaceByVertices");
        return EdgesInFaceByVerticesNC(complex, face, vertSet);
    end
);
InstallMethod( EdgesInFaceByVertices,
    "for a VEF-complex, a face, and a list of two vertices",
    [IsVEFComplex, IsPosInt, IsList],
    function( complex, face, vertList )
        return EdgesInFaceByVertices(complex, face, Set(vertList));
    end
);


InstallMethod( EdgeInFaceByVerticesNC, 
    "for a VEF-complex, a face, and a set of two vertices",
    [IsVEFComplex, IsPosInt, IsSet],
    function( complex, face, vertSet )
        local possEdges;

        possEdges := EdgesInFaceByVerticesNC(complex, face, vertSet);
        if Length(possEdges) = 0  or Length(possEdges) > 1 then
            return fail;
        fi;
        return possEdges[1];
    end
);
InstallMethod( EdgeInFaceByVerticesNC,
    "for a VEF-complex, a face, and a list of two vertices",
    [IsVEFComplex, IsPosInt, IsList],
    function( complex, face, vertList )
        return EdgeInFaceByVerticesNC(complex, face, Set(vertList));
    end
);
InstallMethod( EdgeInFaceByVertices,
    "for a VEF-complex, a face, and a set of two vertices",
    [IsVEFComplex, IsPosInt, IsSet],
    function( complex, face, vertSet )
        __SIMPLICIAL_CheckFace(complex, face, "EdgeInFaceByVertices");
        return EdgeInFaceByVerticesNC(complex, face, vertSet);
    end
);
InstallMethod( EdgeInFaceByVertices,
    "for a VEF-complex, a face, and a list of two vertices",
    [IsVEFComplex, IsPosInt, IsList],
    function( complex, face, vertList )
        return EdgeInFaceByVertices(complex, face, Set(vertList));
    end
);


######

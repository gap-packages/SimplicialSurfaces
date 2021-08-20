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
InstallMethod( IsVerticesAdjacentNC, "for a twisted polygonal complex and two vertices",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, v1, v2)
        if v1 < v2 then
            return [v1,v2] in VerticesOfEdges(complex);
        else
            return [v2,v1] in VerticesOfEdges(complex);
        fi;
    end
);
InstallMethod( IsVerticesAdjacent, "for a twisted polygonal complex and two vertices",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, v1, v2)
        local name;

        name := "IsVerticesAdjacent";
        __SIMPLICIAL_CheckVertex(complex, v1, name);
        __SIMPLICIAL_CheckVertex(complex, v2, name);

        return IsVerticesAdjacentNC(complex, v1, v2);
    end
);

InstallMethod( EdgesBetweenVerticesNC, "for a twisted polygonal complex and two vertices",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
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
InstallMethod( EdgesBetweenVertices, "for a twisted polygonal complex and two vertices",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, v1, v2)
        local name;

        name := "EdgesBetweenVertices";
        __SIMPLICIAL_CheckVertex(complex, v1, name);
        __SIMPLICIAL_CheckVertex(complex, v2, name);

        return EdgesBetweenVerticesNC(complex, v1, v2);
    end
);

InstallMethod( EdgeBetweenVerticesNC, "for a twisted polygonal complex and two vertices",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
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
InstallMethod( EdgeBetweenVertices, "for a twisted polygonal complex and two vertices",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
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
    "for a twisted polygonal complex, a vertex, and an edge",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
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
    "for a twisted polygonal complex, a vertex, and an edge",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
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
    "for a twisted polygonal complex, a face, and a set of two vertices",
    [IsTwistedPolygonalComplex, IsPosInt, IsSet],
    function( complex, face, vertSet )
        return Filtered( EdgesOfFaces(complex)[face], e ->
            VerticesOfEdges(complex)[e] = vertSet);
    end
);
InstallMethod( EdgesInFaceByVerticesNC,
    "for a twisted polygonal complex, a face, and a list of two vertices",
    [IsTwistedPolygonalComplex, IsPosInt, IsList],
    function( complex, face, vertList )
        return EdgesInFaceByVerticesNC(complex, face, Set(vertList));
    end
);
InstallMethod( EdgesInFaceByVertices,
    "for a twisted polygonal complex, a face, and a set of two vertices",
    [IsTwistedPolygonalComplex, IsPosInt, IsSet],
    function( complex, face, vertSet )
        __SIMPLICIAL_CheckFace(complex, face, "EdgesInFaceByVertices");
        return EdgesInFaceByVerticesNC(complex, face, vertSet);
    end
);
InstallMethod( EdgesInFaceByVertices,
    "for a twisted polygonal complex, a face, and a list of two vertices",
    [IsTwistedPolygonalComplex, IsPosInt, IsList],
    function( complex, face, vertList )
        return EdgesInFaceByVertices(complex, face, Set(vertList));
    end
);


InstallMethod( EdgeInFaceByVerticesNC, 
    "for a twisted polygonal complex, a face, and a set of two vertices",
    [IsTwistedPolygonalComplex, IsPosInt, IsSet],
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
    "for a twisted polygonal complex, a face, and a list of two vertices",
    [IsTwistedPolygonalComplex, IsPosInt, IsList],
    function( complex, face, vertList )
        return EdgeInFaceByVerticesNC(complex, face, Set(vertList));
    end
);
InstallMethod( EdgeInFaceByVertices,
    "for a twisted polygonal complex, a face, and a set of two vertices",
    [IsTwistedPolygonalComplex, IsPosInt, IsSet],
    function( complex, face, vertSet )
        __SIMPLICIAL_CheckFace(complex, face, "EdgeInFaceByVertices");
        return EdgeInFaceByVerticesNC(complex, face, vertSet);
    end
);
InstallMethod( EdgeInFaceByVertices,
    "for a twisted polygonal complex, a face, and a list of two vertices",
    [IsTwistedPolygonalComplex, IsPosInt, IsList],
    function( complex, face, vertList )
        return EdgeInFaceByVertices(complex, face, Set(vertList));
    end
);


######


InstallMethod( OtherEdgesOfVertexInFaceNC,
    "for a twisted polygonal complex, a vertex, an edge, and a face",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt, IsPosInt],
    function( complex, vertex, edge, face )
        local possEdges, poss, verts, res;

        possEdges := EdgesOfFaces(complex)[face];
        res := [];
        for poss in possEdges do
            if poss <> edge then
                verts := VerticesOfEdges(complex)[poss];
                if vertex in verts then # Should this be done manually for polygonal complexes?
                    Add(res, poss);
                fi;
            fi;
        od;

        return res;
    end
);
InstallMethod( OtherEdgesOfVertexInFace,
    "for a twisted polygonal complex, a vertex, an edge, and a face",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt, IsPosInt],
    function( complex, vertex, edge, face )
        local name;

        name := "OtherEdgesOfVertexInFace";
        __SIMPLICIAL_CheckVertex(complex, vertex, name);
        __SIMPLICIAL_CheckEdge(complex, edge, name);
        __SIMPLICIAL_CheckFace(complex, face, name);
        __SIMPLICIAL_CheckIncidenceVertexEdge(complex, vertex, edge, name);
        __SIMPLICIAL_CheckIncidenceEdgeFace(complex, edge, face, name);

        return OtherEdgesOfVertexInFaceNC(complex, vertex, edge, face);
    end
);


InstallMethod( OtherEdgeOfVertexInFaceNC,
    "for a polygonal complex, a vertex, an edge, and a face",
    [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt],
    function( complex, vertex, edge, face )
        local possEdges, poss, verts;

        possEdges := EdgesOfFaces(complex)[face];
        for poss in possEdges do
            if poss <> edge then
                verts := VerticesOfEdges(complex)[poss];
                if vertex = verts[1] or vertex = verts[2] then
                    return poss;
                fi;
            fi;
        od;

        Error("OtherEdgeOfVertexInFaceNC: No valid edge found.");
    end
);
InstallMethod( OtherEdgeOfVertexInFaceNC,
    "for a twisted polygonal complex, a vertex, an edge, and a face",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt, IsPosInt],
    function( complex, vertex, edge, face )
        local possEdges;

        possEdges := OtherEdgesOfVertexInFaceNC(complex,vertex,edge,face);
        if Length(possEdges) <> 1 then
            return fail;
        else
            return possEdges[1];
        fi;
    end
);
InstallMethod( OtherEdgeOfVertexInFace,
    "for a twisted polygonal complex, a vertex, an edge, and a face",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt, IsPosInt],
    function( complex, vertex, edge, face )
        local name;

        name := "OtherEdgeOfVertexInFace";
        __SIMPLICIAL_CheckVertex(complex, vertex, name);
        __SIMPLICIAL_CheckEdge(complex, edge, name);
        __SIMPLICIAL_CheckFace(complex, face, name);
        __SIMPLICIAL_CheckIncidenceVertexEdge(complex, vertex, edge, name);
        __SIMPLICIAL_CheckIncidenceEdgeFace(complex, edge, face, name);

        return OtherEdgeOfVertexInFaceNC(complex, vertex, edge, face);
    end
);


###########

InstallMethod( OppositeVertexOfEdgeInTriangleNC,
    "for a polygonal complex, an edge, and a face",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, edge, face)
        local vFace, vEdge, v;

        vFace := VerticesOfFaces(complex)[face];
        vEdge := VerticesOfEdges(complex)[edge];
        for v in vFace do
            if not v in vEdge then
                return v;
            fi;
        od;

        Error("OppositeVertexOfEdgeInTriangleNC: Illegal input. Please don't use the NC-version.");
    end
);
InstallMethod( OppositeVertexOfEdgeInTriangle,
    "for a polygonal complex, an edge, and a face",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, edge, face)
        local name, len;

        name := "OppositeVertexOfEdgeInTriangle";
        __SIMPLICIAL_CheckEdge(complex, edge, name);
        __SIMPLICIAL_CheckFace(complex, face, name);
        __SIMPLICIAL_CheckIncidenceEdgeFace(complex, edge, face, name);
        len := Length( EdgesOfFaces(complex)[face] );
        if len <> 3 then
            Error(Concatenation(name, ": Given face", String(face), 
                    " should be a triangle, but has ", String(len), " edges." ));
        fi;

        return OppositeVertexOfEdgeInTriangleNC(complex, edge, face);
    end
);


InstallMethod( OppositeEdgeOfVertexInTriangleNC,
    "for a polygonal complex, a vertex, and a face",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, vertex, face)
        local eFace, eVertex, e;

        eFace := EdgesOfFaces(complex)[face];
        eVertex := EdgesOfVertices(complex)[vertex];
        for e in eFace do
            if not e in eVertex then
                return e;
            fi;
        od;

        Error("OppositeEdgexOfVertexInTriangleNC: Illegal input. Please don't use the NC-version.");
    end
);
InstallMethod( OppositeEdgeOfVertexInTriangle,
    "for a polygonal complex, a vertex, and a face",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, vertex, face)
        local name, len;

        name := "OppositeEdgeOfVertexInTriangle";
        __SIMPLICIAL_CheckVertex(complex, vertex, name);
        __SIMPLICIAL_CheckFace(complex, face, name);
        __SIMPLICIAL_CheckIncidenceVertexFace(complex, vertex, face, name);
        len := Length( EdgesOfFaces(complex)[face] );
        if len <> 3 then
            Error(Concatenation(name, ": Given face", String(face), 
                    " should be a triangle, but has ", String(len), " edges." ));
        fi;

        return OppositeEdgeOfVertexInTriangleNC(complex, vertex, face);
    end
);


#######################################
##
##      Moving between faces
##
InstallMethod( IsFacesAdjacentNC, "for a twisted polygonal complex and two faces",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, f1, f2)
        if f1 < f2 then
            return [f1,f2] in FacesOfEdges(complex);
        else
            return [f2,f1] in FacesOfEdges(complex);
        fi;
    end
);
InstallMethod( IsFacesAdjacent, "for a twisted polygonal complex and two faces",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, f1, f2)
        local name;

        name := "IsFacesAdjacent";
        __SIMPLICIAL_CheckFace(complex, f1, name);
        __SIMPLICIAL_CheckFace(complex, f2, name);

        return IsFacesAdjacentNC(complex, f1, f2);
    end
);

InstallMethod( EdgesBetweenFacesNC, "for a twisted polygonal complex and two faces",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, f1, f2)
        local res, e1, e2, e;

        res := [];
        e1 := EdgesOfFaces(complex)[f1];
        e2 := EdgesOfFaces(complex)[f2];
        for e in e1 do
            if e in e2 then
                Add(res,e);
            fi;
        od;

        return res;
    end
);
InstallMethod( EdgesBetweenFaces, "for a twisted polygonal complex and two faces",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, f1, f2)
        local name;

        name := "EdgesBetweenFaces";
        __SIMPLICIAL_CheckFace(complex, f1, name);
        __SIMPLICIAL_CheckFace(complex, f2, name);

        return EdgesBetweenFacesNC(complex, f1, f2);
    end
);

InstallMethod( EdgeBetweenFacesNC, "for a twisted polygonal complex and two faces",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, f1, f2)
        local edges;

        edges := EdgesBetweenFacesNC(complex, f1, f2);
        if Length(edges) = 1 then
            return edges[1];
        else
            return fail;
        fi;
    end
);
InstallMethod( EdgeBetweenFaces, "for a twisted polygonal complex and two faces",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, f1, f2)
        local name;

        name := "EdgeBetweenFaces";
        __SIMPLICIAL_CheckFace(complex, f1, name);
        __SIMPLICIAL_CheckFace(complex, f2, name);

        return EdgeBetweenFacesNC(complex,f1,f2);
    end
);

############

InstallMethod( NeighbourFacesByEdgeNC,
    "for a polygonal complex, a face, and an edge",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function(complex,face,edge)
        local possFaces;

        possFaces := FacesOfEdges(complex)[edge];
        if Length(possFaces) = 1 then
            return [];
        fi;

        if Length(possFaces) = 2 then
            if possFaces[1] = face then
                return [possFaces[2]];
            else
                return [possFaces[1]];
            fi;
        fi;

        return Difference(possFaces, [face]);
    end
);
InstallMethod( NeighbourFacesByEdgeNC,
    "for a twisted polygonal complex, a face, and an edge",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, face, edge)
        local possChambers, neigh, faces;

        # Which chambers are incident to this face-edge-pair?
        possChambers := Intersection( ChambersOfFaces(complex)[face], ChambersOfEdges(complex)[edge] );

        neigh := TwoAdjacentChambersNC(complex, possChambers[1]);

        faces := List(neigh, n -> FacesOfChambers(complex)[n]);
        return Set(faces);
    end
);

InstallMethod( NeighbourFaceByEdgeNC,
    "for a polygonal complex, a face, and an edge",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function( complex, face, edge )
        local possFaces;
        
        possFaces := FacesOfEdges(complex)[edge];
        if Length(possFaces) <> 2 then
            return fail;
        fi;

        if possFaces[1] = face then
            return possFaces[2];
        else
            return possFaces[1];
        fi;
    end
);
InstallMethod( NeighbourFaceByEdgeNC,
    "for a twisted polygonal complex, a face, and an edge",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, face, edge)
        local poss;

        poss := NeighbourFacesByEdgeNC(complex,face,edge);
        if Length(poss) = 1 then
            return poss[1];
        else
            return fail;
        fi;
    end
);


InstallMethod( NeighbourFaceByEdge,
    "for a twisted polygonal complex, a face, and an edge",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function( complex, face, edge )
        local name;
        
        name := "NeighbourFaceByEdge";
        __SIMPLICIAL_CheckEdge(complex,edge, name);
        __SIMPLICIAL_CheckFace(complex, face, name);
        __SIMPLICIAL_CheckIncidenceEdgeFace(complex, edge, face, name);
        
        return NeighbourFaceByEdgeNC(complex, face, edge);
    end
);
InstallMethod( NeighbourFacesByEdge,
    "for a twisted polygonal complex, a face, and an edge",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function( complex, face, edge )
        local name;
        
        name := "NeighbourFacesByEdge";
        __SIMPLICIAL_CheckEdge(complex,edge, name);
        __SIMPLICIAL_CheckFace(complex, face, name);
        __SIMPLICIAL_CheckIncidenceEdgeFace(complex, edge, face, name);
        
        return NeighbourFacesByEdgeNC(complex, face, edge);
    end
);


#######################################
##
##      Localising substructures
##

BindGlobal("__SIMPLICIAL_WrapProperty",
    function( complex, prop )
        # We assume that the 1-argument case is more common
        if NumberArgumentsFunction(prop) = 1 then
            return prop;
        elif NumberArgumentsFunction(prop) = 2 then
            return x -> prop(complex, x);
        else
            return fail;
        fi;
    end
);

InstallMethod( AdjacentVerticesWithProperty, 
    "for a twisted polygonal complex and a function", [IsTwistedPolygonalComplex, IsFunction],
    function( complex, prop )
        local testProp, result, pairs, pair;

        # put the property in a standard format
        # (we assume that the 1-argument case is more common)
        testProp := __SIMPLICIAL_WrapProperty(complex, prop);
        if testProp = fail then
            Error("AdjacentVerticesWithProperty: Given function can only take one or two arguments.");
        fi;


        pairs := VerticesOfEdges(complex);
        result := [];
        for pair in pairs do
            if testProp(pair[1]) and testProp(pair[2]) then
                Add(result, pair);
            fi;
        od;

        return result;
    end
);

InstallMethod( AdjacentVerticesWithProperties, 
    "for a twisted polygonal complex and two functions", 
    [IsTwistedPolygonalComplex, IsFunction, IsFunction],
    function( complex, prop1, prop2 )
        local testProp1, testProp2, result, pairs, pair;

        # put the property in a standard format
        # (we assume that the 1-argument case is more common)
        testProp1 := __SIMPLICIAL_WrapProperty(complex, prop1);
        if testProp1 = fail then
            Error("AdjacentVerticesWithProperties: First given function can only take one or two arguments.");
        fi;

        testProp2 := __SIMPLICIAL_WrapProperty(complex, prop2);
        if testProp2 = fail then
            Error("AdjacentVerticesWithProperties: Second given function can only take one or two arguments.");
        fi;


        pairs := VerticesOfEdges(complex);
        result := [];
        for pair in pairs do
            if testProp1(pair[1]) and testProp2(pair[2]) then
                Add(result, pair);
            fi;
            if testProp2(pair[1]) and testProp1(pair[2]) then
                Add(result, [pair[2], pair[1]]);
            fi;
        od;

        return Set(result);
    end
);
InstallMethod( AdjacentVerticesWithProperties,
    "for a twisted polygonal complex and a list of two functions",
    [IsTwistedPolygonalComplex, IsList],
    function( complex, propList )
        local name, prop1, prop2;

        name := "AdjacentVerticesWithProperties: ";
        if Length(propList) <> 2 then
            Error(Concatenation(name, "Given property list has to have length 2."));
        fi;
        prop1 := propList[1];
        prop2 := propList[2];
        if not IsFunction(prop1) then
            Error(Concatenation(name, "First entry of the property list is not a function."));
        fi;
        if not IsFunction(prop2) then
            Error(Concatenation(name, "Second entry of the property list is not a function."));
        fi;

        return AdjacentVerticesWithProperties(complex, prop1, prop2);
    end
);


#########


InstallMethod( EdgesWithVertexProperty, 
    "for a twisted polygonal complex and a function", [IsTwistedPolygonalComplex, IsFunction],
    function( complex, prop )
        local testProp, result, pair, e;

        # put the property in a standard format
        testProp := __SIMPLICIAL_WrapProperty(complex, prop);
        if testProp = fail then
            Error("EdgesWithVertexProperty: Given function can only take one or two arguments.");
        fi;

        result := [];
        for e in Edges(complex) do
            pair := VerticesOfEdges(complex)[e];
            if testProp(pair[1]) and testProp(pair[2]) then
                Add(result, e);
            fi;
        od;

        return result;
    end
);

InstallMethod( EdgesWithVertexProperties, 
    "for a twisted polygonal complex and two functions", 
    [IsTwistedPolygonalComplex, IsFunction, IsFunction],
    function( complex, prop1, prop2 )
        local testProp1, testProp2, result, pair, e;

        # put the property in a standard format
        testProp1 := __SIMPLICIAL_WrapProperty(complex, prop1);
        if testProp1 = fail then
            Error("EdgesWithVertexProperties: First given function can only take one or two arguments.");
        fi;

        testProp2 := __SIMPLICIAL_WrapProperty(complex, prop2);
        if testProp2 = fail then
            Error("EdgesWithVertexProperties: Second given function can only take one or two arguments.");
        fi;


        result := [];
        for e in Edges(complex) do
            pair := VerticesOfEdges(complex)[e];
            if testProp1(pair[1]) and testProp2(pair[2]) then
                Add(result, e);
            fi;
            if testProp2(pair[1]) and testProp1(pair[2]) then
                Add(result, e);
            fi;
        od;

        return Set(result);
    end
);
InstallMethod( EdgesWithVertexProperties,
    "for a twisted polygonal complex and a list of two functions",
    [IsTwistedPolygonalComplex, IsList],
    function( complex, propList )
        local name, prop1, prop2;

        name := "EdgesWithVertexProperties: ";
        if Length(propList) <> 2 then
            Error(Concatenation(name, "Given property list has to have length 2."));
        fi;
        prop1 := propList[1];
        prop2 := propList[2];
        if not IsFunction(prop1) then
            Error(Concatenation(name, "First entry of the property list is not a function."));
        fi;
        if not IsFunction(prop2) then
            Error(Concatenation(name, "Second entry of the property list is not a function."));
        fi;

        return EdgesWithVertexProperties(complex, prop1, prop2);
    end
);



#########

BindGlobal( "__SIMPLICIAL_WrapPropertyList",
    function(name, complex, propList)
        local testList, i, test;

        testList := [];
        for i in [1..Length(propList)] do
            if IsBound(propList[i]) then
                if not IsFunction(propList[i]) then
                    Error( Concatenation( name, "The entry at position ", String(i), " is not function." ) );
                else
                    test := __SIMPLICIAL_WrapProperty(complex, propList[i]);
                    if test = fail then
                        Error( Concatenation( name, "The function at position ", String(i), " should only take one or two arguments." ) );
                    fi;
                    testList[i] := test;
                fi;
            else
                testList[i] := x -> true;
            fi;
        od;

        return testList;
    end
);


InstallMethod( FacesWithVertexProperty, "for a twisted polygonal complex and a function",
    [IsTwistedPolygonalComplex, IsFunction],
    function(complex, prop)
        local testProp, res, f, verts, exclude, v;

        testProp := __SIMPLICIAL_WrapProperty(complex, prop);
        if testProp = fail then
            Error("FacesWithVertexProperty: Given function can only take one or two arguments.");
        fi;

        res := [];
        for f in Faces(complex) do
            verts := VerticesOfFaces(complex)[f];
            exclude := false;
            for v in verts do
                if not testProp(v) then
                    exclude := true;
                    break;
                fi;
            od;
            if not exclude then
                Add(res, f);
            fi;
        od;

        return res;
    end
);

InstallMethod( FacesWithVertexProperties, 
    "for a twisted polygonal complex and a list of functions",
    [IsTwistedPolygonalComplex, IsList],
    function(complex, propList)
        local name, testList, i, res, f, verts, arr, exclude;

        name := "FacesWithVertexProperties: ";

        # Fix the list
        testList := __SIMPLICIAL_WrapPropertyList(name, complex, propList);

        res := [];
        for f in Faces(complex) do
            verts := VerticesOfFaces(complex)[f];
            if Length(verts) = Length(testList) then
                
                for arr in Arrangements( [1..Length(verts)], Length(verts) ) do
                    exclude := false;
                    for i in [1..Length(verts)] do
                        if not testList[i](verts[arr[i]]) then
                            exclude := true;
                            break;
                        fi;
                    od;

                    if not exclude then
                        Add(res, f);
                        break;
                    fi;
                od;
            
            fi;
        od;

        return res;
    end
);



InstallMethod( FacesWithEdgeProperty, "for a twisted polygonal complex and a function",
    [IsTwistedPolygonalComplex, IsFunction],
    function(complex, prop)
        local testProp, res, f, verts, exclude, v;

        testProp := __SIMPLICIAL_WrapProperty(complex, prop);
        if testProp = fail then
            Error("FacesWithEdgeProperty: Given function can only take one or two arguments.");
        fi;

        res := [];
        for f in Faces(complex) do
            verts := EdgesOfFaces(complex)[f];
            exclude := false;
            for v in verts do
                if not testProp(v) then
                    exclude := true;
                    break;
                fi;
            od;
            if not exclude then
                Add(res, f);
            fi;
        od;

        return res;
    end
);

InstallMethod( FacesWithEdgeProperties, 
    "for a twisted polygonal complex and a list of functions",
    [IsTwistedPolygonalComplex, IsList],
    function(complex, propList)
        local name, testList, i, res, f, verts, arr, exclude;

        name := "FacesWithEdgeProperties: ";

        # Fix the list
        testList := __SIMPLICIAL_WrapPropertyList(name, complex, propList);

        res := [];
        for f in Faces(complex) do
            verts := EdgesOfFaces(complex)[f];
            if Length(verts) = Length(testList) then
                
                for arr in Arrangements( [1..Length(verts)], Length(verts) ) do
                    exclude := false;
                    for i in [1..Length(verts)] do
                        if not testList[i](verts[arr[i]]) then
                            exclude := true;
                            break;
                        fi;
                    od;

                    if not exclude then
                        Add(res, f);
                        break;
                    fi;
                od;
            
            fi;
        od;

        return res;
    end
);


#######################################
###
###      Common Methods
###
InstallMethod(CommonVerticesOfEdgesNC,
	"for a polygonal complex and two positive integers",
	[IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
	function(complex,edge1,edge2)
		return Intersection(VerticesOfEdge(complex,edge1),VerticesOfEdge(complex,edge2));
	end
);

InstallMethod(CommonVerticesOfEdges,
	"for a polygonal complex and two positive integers",
	[IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
	function(complex,edge1,edge2)
		__SIMPLICIAL_CheckEdge( complex, edge1, "CommonVerticesOfEdges" );
		__SIMPLICIAL_CheckEdge( complex, edge2, "CommonVerticesOfEdges" );
		return CommonVerticesOfEdgesNC(complex,edge1,edge2);
	end
);

InstallMethod(CommonVerticesOfEdgesNC,
	"for a polygonal complex and a list",
	[IsTwistedPolygonalComplex,IsList],
	function(complex,edgeList)
		local vertices,e,comb,vertex;
		if Length(edgeList)>0 then
			vertices:=VerticesOfEdgeNC(complex,edgeList[1]);
			for e in [2..Length(edgeList)] do
				vertices:=Intersection(vertices,VerticesOfEdgeNC(complex,edgeList[e]));
			od;
			return vertices;
		else
			return [];
		fi;
	end
);

InstallMethod(CommonVerticesOfEdges,
	"for a polygonal complex and a list",
	[IsTwistedPolygonalComplex,IsList],
	function(complex,edgeList)
		local e;
		for e in edgeList do
			__SIMPLICIAL_CheckEdge( complex, e, "CommonVerticesOfEdges" );
		od;
		return CommonVerticesOfEdgesNC(complex, edgeList);
	end
);

InstallMethod(CommonEdgesOfFacesNC,
	"for a polygonal complex and two positive integers",
	[IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
	function(complex,face1,face2)
		return Intersection(EdgesOfFace(complex,face1),EdgesOfFace(complex,face2));
	end
);

InstallMethod(CommonEdgesOfFaces,
	"for a polygonal complex and two positive integers",
	[IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
	function(complex,face1,face2)
		__SIMPLICIAL_CheckFace( complex, face1, "CommonEdgesOfFaces" );
		__SIMPLICIAL_CheckFace( complex, face2, "CommonEdgesOfFaces" );
		return CommonEdgesOfFacesNC(complex,face1,face2);
	end
);


InstallMethod(CommonEdgesOfFacesNC,
	"for a polygonal complex and a list",
	[IsTwistedPolygonalComplex,IsList],
	function(complex,faceList)
		local edges,comb,f;
		if Length(faceList)>0 then
			edges:=EdgesOfFaceNC(complex,faceList[1]);
			for f in [2..Length(faceList)] do
				edges:=Intersection(edges,EdgesOfFaceNC(complex,faceList[f]));
			od;
			return edges;
		else
			return [];
		fi;
	end
);

InstallMethod(CommonEdgesOfFaces,
	"for a polygonal complex and a list",
	[IsTwistedPolygonalComplex,IsList],
	function(complex,faceList)
		local f;
		for f in faceList do
			__SIMPLICIAL_CheckFace( complex, f, "CommonEdgesOfFaces" );
		od;
		return CommonEdgesOfFacesNC(complex,faceList);
	end
);

InstallMethod(CommonVerticesOfFacesNC,
	"for a polygonal complex and two positive integers",
	[IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
	function(complex,face1,face2)
		return Intersection(VerticesOfFace(complex,face1),VerticesOfFace(complex,face2));
	end
);

InstallMethod(CommonVerticesOfFaces,
	"for a polygonal complex and two positive integers",
	[IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
	function(complex,face1,face2)
		__SIMPLICIAL_CheckFace( complex, face1, "CommonVerticesOfFaces" );
		__SIMPLICIAL_CheckFace( complex, face2, "CommonVerticesOfFaces" );
		return CommonVerticesOfFacesNC(complex,face1,face2);
	end
);

InstallMethod(CommonVerticesOfFacesNC,
	"for a polygonal complex and a list",
	[IsTwistedPolygonalComplex,IsList],
	function(complex,faceList)
		local vertices,comb,f;
		if Length(faceList)>0 then
			vertices:=VerticesOfFaceNC(complex,faceList[1]);
			for f in [1..Length(faceList)] do
				vertices:=Intersection(vertices,VerticesOfFaceNC(complex,faceList[f]));
			od;
			return vertices;
		else
			return [];
		fi;
	end
);

InstallMethod(CommonVerticesOfFaces,
	"for a polygonal complex and a list",
	[IsTwistedPolygonalComplex,IsList],
	function(complex,faceList)
		local f;
		for f in faceList do
			__SIMPLICIAL_CheckFace( complex, f, "CommonVerticesOfFaces" );
		od;
		return CommonVerticesOfFacesNC(complex,faceList);
	end
);


InstallMethod(CommonEdgesOfVerticesNC,
	"for a polygonal complex and two positive integers",
	[IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
	function(complex,vertex1,vertex2)
		return Intersection(EdgesOfVertex(complex,vertex1),EdgesOfVertex(complex,vertex2));
	end
);

InstallMethod(CommonEdgesOfVertices,
	"for a polygonal complex and two positive integers",
	[IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
	function(complex,vertex1,vertex2)
		__SIMPLICIAL_CheckVertex( complex, vertex1, "CommonEdgesOfVertices" );
		__SIMPLICIAL_CheckVertex( complex, vertex2, "CommonEdgesOfVertices" );
		return CommonEdgesOfVerticesNC(complex,vertex1,vertex2);
	end
);


InstallMethod(CommonFacesOfEdgesNC,
	"for a polygonal complex and two positive integers",
	[IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
	function(complex,edge1,edge2)
		return Intersection(FacesOfEdge(complex,edge1),FacesOfEdge(complex,edge2));
	end
);

InstallMethod(CommonFacesOfEdges,
	"for a polygonal complex and two positive integers",
	[IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
	function(complex,edge1,edge2)
		__SIMPLICIAL_CheckEdge( complex, edge1, "CommonFacesOfEdges" );
		__SIMPLICIAL_CheckEdge( complex, edge2, "CommonFacesOfEdges" );
		return CommonFacesOfEdgesNC(complex,edge1,edge2);
	end
);

InstallMethod(CommonFacesOfEdgesNC,
	"for a polygonal complex and a list",
	[IsTwistedPolygonalComplex,IsList],
	function(complex,edgeList)
		local faces,comb,e;
		if Length(edgeList)>0 then
			faces:=FacesOfEdgeNC(complex,edgeList[1]);
			for e in [2..Length(edgeList)] do
				faces:=Intersection(faces,FacesOfEdgeNC(complex,edgeList[e]));
			od;
			return faces;
		else
			return [];
		fi;
	end
);

InstallMethod(CommonFacesOfEdges,
	"for a polygonal complex and a list",
	[IsTwistedPolygonalComplex,IsList],
	function(complex,edgeList)
		local e;
		for e in edgeList do
			__SIMPLICIAL_CheckEdge( complex, e, "CommonFacesOfEdges" );
		od;
		return CommonFacesOfEdgesNC(complex,edgeList);
	end
);

InstallMethod(CommonFacesOfVerticesNC,
	"for a polygonal complex and two positive integers",
	[IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
	function(complex,vertex1,vertex2)
		return Intersection(FacesOfVertex(complex,vertex1),FacesOfVertex(complex,vertex2));
	end
);

InstallMethod(CommonFacesOfVertices,
	"for a polygonal complex and two positive integers",
	[IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
	function(complex,vertex1,vertex2)
		__SIMPLICIAL_CheckVertex( complex, vertex1, "CommonFacesOfVertices" );
		__SIMPLICIAL_CheckVertex( complex, vertex2, "CommonFacesOfVertices" );
		return CommonFacesOfVerticesNC(complex,vertex1,vertex2);
	end
);

InstallMethod(CommonFacesOfVerticesNC,
	"for a polygonal complex and a list",
	[IsTwistedPolygonalComplex,IsList],
	function(complex,vertexList)
		local faces,comb,v;
		if Length(vertexList)>0 then
			faces:=FacesOfVertexNC(complex,vertexList[1]);
			for v in [2..Length(vertexList)] do
				faces:=Intersection(faces,FacesOfVertexNC(complex,vertexList[v]));
			od;
			return faces;
		else
			return [];
		fi;
	end
);

InstallMethod(CommonFacesOfVertices,
	"for a polygonal complex and a list",
	[IsTwistedPolygonalComplex,IsList],
	function(complex,vertexList)
		local v;
		for v in vertexList do
			__SIMPLICIAL_CheckVertex( complex, v, "CommonFacesOfVertices" );
		od;
		return CommonFacesOfVerticesNC(complex,vertexList);
	end
);

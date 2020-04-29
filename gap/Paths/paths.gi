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
##      Vertex-Edge-Paths
##
DeclareRepresentation("VertexEdgePathRep", IsVertexEdgePath and IsAttributeStoringRep, []);
BindGlobal("VertexEdgePathType", NewType(VertexEdgePathFamily, VertexEdgePathRep));


InstallMethod( VertexEdgePathNC, "for a VEF-complex and a list",
    [IsVEFComplex, IsDenseList],
    function(complex, path)
        local obj;

        obj := Objectify( VertexEdgePathType, rec() );
        SetPath(obj, path);
        SetAssociatedVEFComplex(obj, complex);

        return obj;
    end
);
RedispatchOnCondition( VertexEdgePathNC, true, [IsVEFComplex,IsList],[,IsDenseList],0 );
InstallMethod( VertexEdgePath, "for a VEF-complex and a list",
    [IsVEFComplex, IsDenseList],
    function(complex, path)
        local i;

        if not ForAll(path, IsPosInt) then
            Error("VertexEdgePath: All entries of the path have to be positive integers.");
        fi;
        if IsEvenInt(Length(path)) then
            Error("VertexEdgePath: The given list has to have odd length.");
        fi;

        for i in [1..Length(path)] do
            if IsOddInt(i) then
                if not path[i] in VerticesAttributeOfVEFComplex(complex) then
                    Error( Concatenation( "VertexEdgePath: The number ",
                        String(path[i]), " (position ", String(i),  
                        ") is not a vertex of the given complex.") );
                fi;
            else
                if not path[i] in Edges(complex) then
                    Error( Concatenation( "VertexEdgePath: The number ", 
                        String(path[i]), " (position ", String(i), 
                        ") is not an edge of the given complex." ) );
                fi;
                if Set( [path[i-1], path[i+1]] ) <> VerticesOfEdges(complex)[path[i]] then
                    Error( Concatenation( "VertexEdgePath: The numbers ",
                        String(path[i-1]), " and ", String(path[i+1]), 
                        " are not all incident vertices to the edge ", String(path[i]),
                        " (position ", String(i), ") in the given complex.") );
                fi;
            fi;
        od;

        return VertexEdgePathNC(complex, path);
    end
);
RedispatchOnCondition( VertexEdgePath, true, [IsVEFComplex,IsList],[,IsDenseList],0 );

InstallMethod( VertexEdgePathByVerticesNC, 
    "for a VEF-complex and a list of vertices",
    [IsVEFComplex, IsDenseList],
    function(complex, vertexList)
        local path, i;

        if vertexList = [] then
            return fail;
        fi;
        path := [ vertexList[1] ];
        for i in [2..Length(vertexList)] do
            path[2*i-2] := Position( VerticesOfEdges(complex), Set([vertexList[i-1],vertexList[i]]) );
            path[2*i-1] := vertexList[i];
        od;

        return VertexEdgePathNC(complex, path);
    end
);
RedispatchOnCondition( VertexEdgePathByVerticesNC, true, [IsVEFComplex,IsList],[,IsDenseList],0 );

InstallMethod( VertexEdgePathByVertices, 
    "for a VEF-complex and a list of vertices",
    [IsVEFComplex, IsDenseList],
    function(complex, vertexList)
        local path, i, pos;

        if vertexList = [] then
            return fail;
        fi;
        __SIMPLICIAL_CheckVertex(complex, vertexList[1], "VertexEdgePathByVertices");
        path := [ vertexList[1] ];
        for i in [2..Length(vertexList)] do
            __SIMPLICIAL_CheckVertex(complex, vertexList[i], "VertexEdgePathByVertices");
            pos := Position( VerticesOfEdges(complex), Set([vertexList[i-1],vertexList[i]]) );
            if pos = fail then
                Error(Concatenation("VertexEdgePathByVertices: The vertices ", 
                    String(vertexList[i-1]), " (position ", String(i-1), ") and ", 
                    String(vertexList[i]), " (position ", String(i), 
                    ") are not connected by an edge in the given VEF-complex."));
            fi;
            path[2*i-2] := pos;
            path[2*i-1] := vertexList[i];
        od;

        return VertexEdgePathNC(complex, path);
    end
);
RedispatchOnCondition( VertexEdgePathByVertices, true, [IsVEFComplex,IsList],[,IsDenseList],0 );


InstallMethod( VertexEdgePathByEdgesNC, 
    "for a VEF-complex and a list of edges",
    [IsVEFComplex, IsDenseList],
    function(complex, edgeList)
        local path, firstDefinedPos, i, verts;
         
        if edgeList = [] then
            return VertexEdgePathNC(complex, 
                [Minimum(VerticesAttributeOfVEFComplex(complex))]);
        fi;

        firstDefinedPos := 0;
        for i in [2..Length(edgeList)] do
            if VerticesOfEdges(complex)[edgeList[i-1]] <> VerticesOfEdges(complex)[edgeList[i]] then
                firstDefinedPos := i;
                break;
            fi;
        od;

        if firstDefinedPos = 0 then
            # all edges have the same edges
            verts := VerticesOfEdges(complex)[edgeList[1]];
            path := [verts[1]];
            for i in [1..Length(edgeList)] do
                path[2*i] := edgeList[i];
                if IsEvenInt(i) then
                    path[2*i+1] := verts[1];
                else
                    path[2*i+1] := verts[2];
                fi;
            od;
            return VertexEdgePathNC(complex, path);
        fi;

        # the vertex between first-1 and first is unique
        path := [];
        path[2*firstDefinedPos-1] := Intersection( 
            VerticesOfEdges(complex)[edgeList[firstDefinedPos-1]],
            VerticesOfEdges(complex)[edgeList[firstDefinedPos]])[1];
        for i in [firstDefinedPos, firstDefinedPos+1..Length(edgeList)] do
            path[2*i] := edgeList[i];
            path[2*i+1] := OtherVertexOfEdgeNC(complex, path[2*i-1], path[2*i]);
        od;
        for i in [firstDefinedPos-1, firstDefinedPos-2..1] do
            path[2*i] := edgeList[i];
            path[2*i-1] := OtherVertexOfEdgeNC(complex, path[2*i+1], path[2*i]);
        od;
        return VertexEdgePathNC(complex, path);
    end
);
RedispatchOnCondition( VertexEdgePathByEdgesNC, true, [IsVEFComplex, IsList],[,IsDenseList],0 );

InstallMethod( VertexEdgePathByEdges,
    "for a VEF-complex and a list of edges",
    [IsVEFComplex, IsDenseList],
    function(complex, edgeList)
        local i;

        if Length(edgeList) > 0 then
            __SIMPLICIAL_CheckEdge(complex, edgeList[1], "VertexEdgePathByEdges");
            for i in [2..Length(edgeList)] do
                __SIMPLICIAL_CheckEdge(complex, edgeList[i], "VertexEdgePathByEdges");
                if Length( Intersection(
                    VerticesOfEdges(complex)[edgeList[i-1]], 
                    VerticesOfEdges(complex)[edgeList[i]]) ) = 0 then
                        Error(Concatenation(
                            "VertexEdgePathByEdges: The edges ",
                            String(edgeList[i-1]), " (position ",
                            String(i-1), ") and ",
                            String(edgeList[i]), " (position ",
                            String(i), 
                            ") do not share a vertex in the given VEF-complex."));
                fi;
            od;
        fi;

        return VertexEdgePathByEdgesNC(complex, edgeList);
    end
);
RedispatchOnCondition( VertexEdgePathByEdges, true, [IsVEFComplex, IsList],[,IsDenseList],0 );


InstallMethod( IsPolygonalComplexPath, "for a vertex-edge-path",
    [IsVertexEdgePath],
    function(path)
        return IsPolygonalComplex(AssociatedVEFComplex(path));
    end
);
InstallMethod( IsBendPolygonalComplexPath, "for a vertex-edge-path",
    [IsVertexEdgePath],
    function(path)
        return IsBendPolygonalComplex(AssociatedVEFComplex(path));
    end
);


InstallMethod( String, "for a vertex-edge-path", [IsVertexEdgePath],
    function(path)
        local str, out;
        
        str := "";
        out := OutputTextString(str,true);

        PrintTo(out, "VertexEdgePathNC( ");
        PrintTo(out, AssociatedVEFComplex(path));
        PrintTo(out, ", ");
        PrintTo(out, PathAsList(path));
        PrintTo(out, ")");

        CloseStream(out);
        return str;
    end
);

InstallMethod( ViewInformation, "for a vertex-edge-path", [IsVertexEdgePath],
    function(path)
        local strList, i;

        strList := [];
        if IsClosedPath(path) then
            Add( strList, [ "( ", 0 ] );
        else
            Add( strList, [ "| ", 0 ] );
        fi;
        for i in [1..Length(PathAsList(path))] do
            if IsEvenInt(i) then
                Add( strList, ["E", 2] );
                Add( strList, [String(Path(path)[i]), 2] );
            else
                Add( strList, ["v", 1] );
                Add( strList, [String(Path(path)[i]), 1] );
            fi;
            Add( strList, [", ", 0] );
        od;
        # Remove trailing ","
        Remove(strList);
        if IsClosedPath(path) then
            Add( strList, [ " )", 0 ] );
        else
            Add( strList, [ " |", 0 ] );
        fi;

        return strList;
    end
);
InstallMethod( ViewString, "for a vertex-edge-path", [IsVertexEdgePath],
    function(path)
        return __SIMPLICIAL_ColourString( ViewInformation(path), 
            [ SIMPLICIAL_COLOURS_VERTICES_DEFAULT, SIMPLICIAL_COLOURS_EDGES_DEFAULT, SIMPLICIAL_COLOURS_FACES_DEFAULT ]);
    end
);
InstallMethod( ViewObj, "for a vertex-edge-path", [IsVertexEdgePath],
    function(path)
        if SIMPLICIAL_COLOURS_ON then
            __SIMPLICIAL_PrintColourString( ViewInformation(path), 
                [ SIMPLICIAL_COLOURS_VERTICES, SIMPLICIAL_COLOURS_EDGES, SIMPLICIAL_COLOURS_FACES ]);
        else
            Print(__SIMPLICIAL_UncolouredString( ViewInformation(path) ));
        fi;
    end
);


InstallMethod( \=, "for two vertex-edge-paths", IsIdenticalObj,
    [IsVertexEdgePath, IsVertexEdgePath],
    function(path1, path2)
        return PathAsList(path1) = PathAsList(path2) and 
            AssociatedVEFComplex(path1) = AssociatedVEFComplex(path2);
    end
);


InstallMethod( PathAsList, "for a vertex-edge-path", [IsVertexEdgePath],
    function(path)
        return Path(path);
    end
);
InstallMethod( \<, "for two vertex-edge-paths", 
    [IsVertexEdgePath, IsVertexEdgePath],
    function(path1, path2)
        return PathAsList(path1) < PathAsList(path2);
    end
);

InstallMethod( VerticesAsList, "for a vertex-edge-path", [IsVertexEdgePath],
    function(path)
        return OddPart(path);
    end
);

InstallMethod( EdgesAsList, "for a vertex-edge-path", [IsVertexEdgePath],
    function(path)
        return EvenPart(path);
    end
);

InstallMethod( Inverse, "for a vertex-edge-path", [IsVertexEdgePath],
    function(path)
        return VertexEdgePathNC( AssociatedVEFComplex(path),
            Reversed(Path(path)));
    end
);

InstallMethod( VerticesAsPerm, "for a vertex-edge-path", [IsVertexEdgePath],
    function(path)
        return OddPartAsPerm(path);
    end
);

InstallMethod( EdgesAsPerm, "for a vertex-edge-path", [IsVertexEdgePath],
    function(path)
        return EvenPartAsPerm(path);
    end
);


#######################################
##
##      Edge-Face-Paths
##
DeclareRepresentation("EdgeFacePathRep", IsEdgeFacePath and IsAttributeStoringRep, []);
BindGlobal("EdgeFacePathType", NewType(EdgeFacePathFamily, EdgeFacePathRep));


InstallMethod( EdgeFacePathNC, "for a VEF-complex and a dense list",
    [IsVEFComplex, IsDenseList],
    function(complex, path)
        local obj;

        obj := Objectify( EdgeFacePathType, rec() );
        SetPath(obj, path);
        SetAssociatedVEFComplex(obj, complex);
        # for bend polygonal complexes this relies on the fact
        # that the edge-face-path-elements can be computed

        return obj;
    end
);
RedispatchOnCondition( EdgeFacePathNC, true, [IsVEFComplex,IsList],[,IsDenseList],0 );
InstallMethod( EdgeFacePathNC, "for a bend polygonal complex and two dense lists",
    [IsBendPolygonalComplex, IsDenseList, IsDenseList],
    function(complex, path, elements)
        local obj;

        obj := Objectify( EdgeFacePathType, rec() );
        SetPath(obj, path);
        SetAssociatedVEFComplex(obj, complex);
        SetEdgeFacePathElements(obj, elements);

        return obj;
    end
);
RedispatchOnCondition( EdgeFacePathNC, true, [IsBendPolygonalComplex,IsList,IsList],[,IsDenseList,IsDenseList],0 );

BindGlobal( "__SIMPLICIAL_EdgeFacePath_EdgeCheck",
    function(position, element, edges)
        if not element in edges then
            Error( Concatenation( "EdgeFacePath: The number ",
                String(element), " (position ", String(position),  
                ") is not an edge of the given complex.") );
        fi;
    end
);
BindGlobal( "__SIMPLICIAL_EdgeFacePath_FaceCheck",
    function(position, element, faces)
        if not element in faces then
            Error( Concatenation( "EdgeFacePath: The number ",
                String(element), " (position ", String(position),  
                ") is not a face of the given complex.") );
        fi;
    end
);
BindGlobal( "__SIMPLICIAL_EdgeFacePath_IncidenceCheck",
    function(posE, edge, posF, face, complex)
        if not edge in EdgesOfFaces(complex)[face] then
            Error( Concatenation( "EdgeFacePath: The edge ", 
                String(edge), " (position ", String(posE), 
                ") is not incident to the face ", String(face), 
                " (position ", String(posF), ") in the given complex." ) );
        fi;
    end
);
InstallMethod( EdgeFacePath, "for a polygonal complex and a dense list",
    [IsPolygonalComplex, IsDenseList],
    function(complex, path)
        local i;

        if not ForAll(path, IsPosInt) then
            Error("EdgeFacePath: All entries of the path have to be positive integers.");
        fi;
        if IsEvenInt(Length(path)) then
            Error("EdgeFacePath: The given list has to have odd length.");
        fi;

        for i in [1..Length(path)] do
            if IsOddInt(i) then
                __SIMPLICIAL_EdgeFacePath_EdgeCheck(i, path[i], Edges(complex));
            else
                __SIMPLICIAL_EdgeFacePath_FaceCheck(i, path[i], Faces(complex));
                __SIMPLICIAL_EdgeFacePath_IncidenceCheck(i-1, path[i-1], i, path[i], complex);

                if path[i-1] = path[i+1] then
                    Error( Concatenation( 
                        "EdgeFacePath: The two adjacent edges at positions ", 
                        String(i-1), " and ", String(i), 
                        " must not be equal." ) );
                fi;

                __SIMPLICIAL_EdgeFacePath_IncidenceCheck(i+1, path[i+1], i, path[i], complex);
            fi;
        od;

        return EdgeFacePathNC(complex, path);
    end
);
BindGlobal( "__SIMPLICIAL_EdgeFacePath_FindLocalEdge",
    function( path, posE, posF, complex )
        local face, edge, locEdge, found, res, loc;

        edge := path[posE];
        face := path[posF];
        locEdge := LocalEdgesOfFaces(complex)[face];
        found := false;
        res := 0;
        for loc in locEdge do
            if EdgesOfLocalEdges(complex)[loc] = edge then
                # We found a match
                if found then
                    # This is the second match
                    Error(Concatenation(
                        "EdgeFacePath: There are several different local edges for the edge ", 
                        String(edge), " (position ", String(posE), 
                        ") of the face ", String(face), "(position ", 
                        String(posF), ")."));
                else
                    found := true;
                    res := loc;
                fi;
            fi;
        od;

        if not found then
            # We found no match
            Error(Concatenation(
                "EdgeFacePath: There is no local edge for the edge ", 
                String(edge), " (position ", String(posE), ") of the face ",
                String(face), "(position ", String(posF), ")."));
        fi;

        return res;
    end
);
InstallMethod( EdgeFacePath, "for a bend polygonal complex and a dense list",
    [IsBendPolygonalComplex, IsDenseList],
    function(complex, path)
        local i, elements;

        if not ForAll(path, IsPosInt) then
            Error("EdgeFacePath: All entries of the path have to be positive integers.");
        fi;
        if IsEvenInt(Length(path)) then
            Error("EdgeFacePath: The given list has to have odd length.");
        fi;

        elements := [];
        for i in [1..Length(path)] do
            if IsOddInt(i) then
                __SIMPLICIAL_EdgeFacePath_EdgeCheck(i, path[i], Edges(complex));
            else
                __SIMPLICIAL_EdgeFacePath_FaceCheck(i, path[i], Faces(complex));
                __SIMPLICIAL_EdgeFacePath_IncidenceCheck(i-1, path[i-1], i, path[i], complex);
                if path[i-1] <> path[i] then
                    __SIMPLICIAL_EdgeFacePath_IncidenceCheck(i+1, path[i+1], i, path[i], complex);
                fi;

                # We also have to compute the edge-face-path-elements
                Add(elements, [path[i], 
                    [ __SIMPLICIAL_EdgeFacePath_FindLocalEdge(path, i-1,i, complex),
                        __SIMPLICIAL_EdgeFacePath_FindLocalEdge(path,i+1,i,complex)]]);

            fi;
        od;

        return EdgeFacePathNC(complex, path, elements);
    end
);
RedispatchOnCondition( EdgeFacePath, true, [IsVEFComplex,IsList],[,IsDenseList],0 );

                # TODO allow to define a path only by the elements
InstallMethod( EdgeFacePath, "for a bend polygonal complex and two dense lists",
    [IsBendPolygonalComplex, IsDenseList, IsDenseList],
    function(complex, path, elements)
        local i, el;

        if not ForAll(path, IsPosInt) then
            Error("EdgeFacePath: All entries of the path have to be positive integers.");
        fi;
        if IsEvenInt(Length(path)) then
            Error("EdgeFacePath: The given list has to have odd length.");
        fi;
        if (Length(path)-1)/2 <> Length(elements) then
            Error("EdgeFacePath: The second list must have as many elements as there a faces in the first list.");
        fi;

        for i in [1..Length(path)] do
            if IsOddInt(i) then
                __SIMPLICIAL_EdgeFacePath_EdgeCheck(i, path[i], Edges(complex));
            else
                __SIMPLICIAL_EdgeFacePath_FaceCheck(i, path[i], Faces(complex));
                __SIMPLICIAL_EdgeFacePath_IncidenceCheck(i-1, path[i-1], i, path[i], complex);
                if path[i-1] <> path[i] then
                    __SIMPLICIAL_EdgeFacePath_IncidenceCheck(i+1, path[i+1], i, path[i], complex);
                fi;

                el := elements[i/2];
                if not IsList(el) or Length(el)<>2 or not IsPosInt(el[1]) or 
                    not IsList(el[2]) or Length(el[2]) <> 2 or 
                    not IsPosInt(el[2][1]) or not IsPosInt(el[2][2]) then
                        Error(Concatenation(
                            "EdgeFacePath: the edge-face-path-element at position ", 
                            String(i/2), 
                            " must have the form [face, [local edge, local edge]]."));
                fi;
                if path[i] <> el[1] then
                    Error(Concatenation(
                        "EdgeFacePath: The face of the edge-face-path element ", 
                        String(el), " (position ", String(i/2), 
                        ") is not equal to the face ", String(path[i]), 
                        " (position ", String(i), ")."));
                fi;
                if el[2][1] = el[2][2] then
                    Error(Concatenation(
                        "EdgeFacePath: The local edges of the edge-face-path element ",
                        String(el), " (position ", String(i/2), 
                        ") have to be different."));
                fi;
                if not IsSubset(LocalEdgesOfFaces(complex)[path[i]], el[2]) then
                    Error(Concatenation(
                        "EdgeFacePath: The local edges of the edge-face-path element ",
                        String(el), " (position ", String(i/2), 
                        ") are not the local edges of the face ", 
                        String(path[i]), " (these would be ", 
                        String(LocalEdgesOfFaces(complex)[path[i]]), ")."));
                fi;
            fi;
        od;

        return EdgeFacePathNC(complex, path, elements);
    end
);
RedispatchOnCondition( EdgeFacePath, true, [IsBendPolygonalComplex,IsList,IsList],[,IsDenseList,IsDenseList],0 );

InstallMethod( IsPolygonalComplexPath, "for an edge-face-path",
    [IsEdgeFacePath],
    function(path)
        return IsPolygonalComplex(AssociatedVEFComplex(path));
    end
);
InstallMethod( IsBendPolygonalComplexPath, "for an edge-face-path",
    [IsEdgeFacePath],
    function(path)
        return IsBendPolygonalComplex(AssociatedVEFComplex(path));
    end
);

InstallMethod( EdgeFacePathElements, 
    "for an edge-face-path on a polygonal complex",
    [IsEdgeFacePath and IsPolygonalComplexPath],
    function(path)
        return fail;
    end
);
RedispatchOnCondition( EdgeFacePathElements, true, [IsEdgeFacePath], [IsPolygonalComplexPath], 0 );
InstallMethod( EdgeFacePathElements,
    "for an edge-face-path on a bend polygonal complex", 
    [IsEdgeFacePath and IsBendPolygonalComplexPath],
    function(path)
        local complex, pathAsList, k, res, edge_in, edge_out, flags, inv,
            orbs, first, second, orb;

        complex := AssociatedVEFComplex(path);

        res := [];
        # go through all faces in order
        pathAsList := PathAsList(path);
        for k in [2,4..Length(pathAsList)-1] do
            edge_in := pathAsList[k-1];
            edge_out := pathAsList[k+1];

            #TODO very inefficient. What is necessary to improve? LocalEdgesOfFaces?
            flags := LocalFlagsOfFaces(complex)[pathAsList[k]];
            inv := LocalFlagEdgeInvolution(complex);
            orbs := Orbits(inv, flags);
            for orb in orbs do
                if EdgesOfLocalFlags(complex)[orb[1]] = edge_in then
                    first := LocalEdgesOfLocalFlags(complex)[orb[1]];
                fi;
                if EdgesOfLocalFlags(complex)[orb[1]] = edge_out then
                    second := LocalEdgesOfLocalFlags(complex)[orb[1]];
                fi;
            od;
            Add(res, [pathAsList[k],[first,second]]);
        od;
        return res;
    end
);
RedispatchOnCondition( EdgeFacePathElements, true, [IsEdgeFacePath], [IsBendPolygonalComplexPath], 0 );


InstallMethod( String, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        local str, out;
        
        str := "";
        out := OutputTextString(str,true);

        PrintTo(out, "EdgeFacePathNC( ");
        PrintTo(out, AssociatedVEFComplex(path));
        PrintTo(out, ", ");
        PrintTo(out, PathAsList(path));
        PrintTo(out, ")");

        CloseStream(out);
        return str;
    end
);

InstallMethod( ViewInformation, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        local strList, i;

        strList := [];
        if IsClosedPath(path) then
            Add( strList, [ "( ", 0 ] );
        else
            Add( strList, [ "| ", 0 ] );
        fi;
        for i in [1..Length(PathAsList(path))] do
            if IsEvenInt(i) then
                Add( strList, ["F", 3] );
                Add( strList, [String(Path(path)[i]), 3] );
            else
                Add( strList, ["e", 2] );
                Add( strList, [String(Path(path)[i]), 2] );
            fi;
            Add( strList, [", ", 0] );
        od;
        # Remove trailing ","
        Remove(strList);
        if IsClosedPath(path) then
            Add( strList, [ " )", 0 ] );
        else
            Add( strList, [ " |", 0 ] );
        fi;

        return strList;
    end
);
InstallMethod( ViewString, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        return __SIMPLICIAL_ColourString( ViewInformation(path), 
            [ SIMPLICIAL_COLOURS_VERTICES_DEFAULT, SIMPLICIAL_COLOURS_EDGES_DEFAULT, SIMPLICIAL_COLOURS_FACES_DEFAULT ]);
    end
);
InstallMethod( ViewObj, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        if SIMPLICIAL_COLOURS_ON then
            __SIMPLICIAL_PrintColourString( ViewInformation(path), 
                [ SIMPLICIAL_COLOURS_VERTICES, SIMPLICIAL_COLOURS_EDGES, SIMPLICIAL_COLOURS_FACES ]);
        else
            Print(__SIMPLICIAL_UncolouredString( ViewInformation(path) ));
        fi;
    end
);

;

InstallMethod( \=, "for two edge-face-paths", IsIdenticalObj,
    [IsEdgeFacePath, IsEdgeFacePath],
    function(path1, path2)
        return PathAsList(path1) = PathAsList(path2) and 
            EdgeFacePathElements(path1) = EdgeFacePathElements(path2) and
            AssociatedVEFComplex(path1) = AssociatedVEFComplex(path2);
    end
);

InstallMethod( PathAsList, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        return Path(path);
    end
);
InstallMethod( \<, "for two edge-face-paths on polygonal complexes", 
    [IsEdgeFacePath and IsPolygonalComplexPath, IsEdgeFacePath and IsPolygonalComplexPath],
    function(path1, path2)
        return PathAsList(path1) < PathAsList(path2);
    end
);
RedispatchOnCondition(\<, true, [IsEdgeFacePath,IsEdgeFacePath], [IsPolygonalComplexPath,IsPolygonalComplexPath], 0);
InstallMethod( \<, "for two edge-face-paths on bend polygonal complexes", 
    [IsEdgeFacePath and IsBendPolygonalComplexPath, IsEdgeFacePath and IsBendPolygonalComplexPath],
    function(path1, path2)
        if PathAsList(path1) = PathAsList(path2) then
            return EdgeFacePathElements(path1) < EdgeFacePathElements(path2);
        else
            return PathAsList(path1) < PathAsList(path2);
        fi;
    end
);
RedispatchOnCondition(\<, true, [IsEdgeFacePath,IsEdgeFacePath], [IsBendPolygonalComplexPath,IsBendPolygonalComplexPath], 0);

InstallMethod( EdgesAsList, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        return OddPart(path);
    end
);

InstallMethod( FacesAsList, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        return EvenPart(path);
    end
);

InstallMethod( Inverse, "for a edge-face-path on a polygonal complex", 
    [IsEdgeFacePath and IsPolygonalComplexPath],
    function(path)
        return EdgeFacePathNC( AssociatedVEFComplex(path), Reversed(Path(path)));
    end
);
RedispatchOnCondition(Inverse, true, [IsEdgeFacePath], [IsPolygonalComplexPath], 0);
InstallMethod( Inverse, "for a edge-face-path on a bend polygonal complex", 
    [IsEdgeFacePath and IsBendPolygonalComplexPath],
    function(path)
        local Rev, complex, rev, i, efElements, el;

        complex := AssociatedVEFComplex(path);
        efElements := EdgeFacePathElements(path);
        rev := [];
        for i in [1..Length(efElements)] do
            el := efElements[Length(efElements)+1-i];
            rev[i] := [ el[1], [ el[2][2], el[2][1] ] ];
        od;
        return EdgeFacePathNC( complex, Reversed(Path(path)), rev );
    end
);
RedispatchOnCondition(Inverse, true, [IsEdgeFacePath], [IsBendPolygonalComplexPath], 0);


InstallMethod( EdgesAsPerm, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        return OddPartAsPerm(path);
    end
);

InstallMethod( FacesAsPerm, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        return EvenPartAsPerm(path);
    end
);




InstallMethod( IsUmbrellaPath, "for an edge-face-path on a polygonal complex", 
    [IsEdgeFacePath and IsPolygonalComplexPath],
    function(path)
        local complex, commonEdgeVertex, commonFaceVertex, commonVertex;

        complex := AssociatedVEFComplex(path);

        commonEdgeVertex := Intersection( VerticesOfEdges(complex){EdgesAsList(path)} );
        commonFaceVertex := Intersection( VerticesOfFaces(complex){FacesAsList(path)} );
        commonVertex := Intersection( commonEdgeVertex, commonFaceVertex );
        return Length(commonVertex) <> 0;
    end
);
RedispatchOnCondition(IsUmbrellaPath, true, [IsEdgeFacePath], [IsPolygonalComplexPath], 0);

InstallMethod( IsUmbrellaPath, "for an edge-face-path on a bend polygonal complex", 
    [IsEdgeFacePath and IsBendPolygonalComplexPath],
    function(path)
        local commonFaceVertex, commonEdgeVertex, commonVertex, complex,
            vertex, el, flags1, flags2, vert1, vert2, int, vFlags, v,
            part, found, i, j, flagList;

        complex := AssociatedVEFComplex(path);

        flagList := [];
        for el in EdgeFacePathElements(path) do
            flags1 := LocalFlagsOfLocalEdges(complex)[el[2][1]];
            flags2 := LocalFlagsOfLocalEdges(complex)[el[2][2]];
            vert1 := LocalVerticesOfLocalFlags(complex){flags1};
            vert2 := LocalVerticesOfLocalFlags(complex){flags2};
            int := Intersection(vert1, vert2);
            if int = [] then
                return false;
            elif Length(int) >= 2 then
                Error("IsUmbrellaPath: Internal error.");
            fi;
            vFlags := LocalFlagsOfLocalVertices(complex)[int[1]];
            Add(flagList, [Intersection(flags1,vFlags)[1], Intersection(flags2,vFlags)[1]]);
        od;
        for i in [1..Length(flagList)-1] do
            found := false;
            for part in LocalFlagsOfHalfEdges(complex) do
                if IsSubset( part, [flagList[i][2],flagList[i+1][1]] ) then
                    found := true;
                    break;
                fi;
            od;
            if not found then
                return false;
            fi;
        od;
        return true;
    end
);
RedispatchOnCondition(IsUmbrellaPath, true, [IsEdgeFacePath], [IsBendPolygonalComplexPath], 0);



BindGlobal( "__SIMPLICIAL_ZigZagPath",
    function(com, efPath)
        local veList, pathAsList, i, e1, e2, vertex, firstVertex, lastEdge, 
            vePath;

        pathAsList := Path(efPath);
        veList := [];
        for i in [2,4..Length(pathAsList)-1] do
            e1 := pathAsList[i-1];
            e2 := pathAsList[i+1];
            vertex := Intersection( VerticesOfEdges(com){[e1,e2]} );
            Assert(1, Length(vertex) = 1);
            vertex := vertex[1];
            Append(veList, [e1,vertex]);
            if i > 2 and veList[Length(veList)] = veList[Length(veList)-2] then
                SetIsGeodesicPath(efPath, false);
                return fail;
            fi;
        od;

        SetIsGeodesicPath(efPath, true);
        # Complete the first vertex
        firstVertex := OtherVertexOfEdgeNC( com, veList[2], veList[1] );
        lastEdge := OtherEdgeOfVertexInFaceNC(com, veList[Length(veList)], veList[Length(veList)-1], pathAsList[Length(pathAsList)-1]);
        if lastEdge = veList[1] and firstVertex = veList[Length(veList)] then
            # closed geodesic path
            SetIsClosedGeodesicPath(efPath, true);
            vePath := VertexEdgePathNC(com, Concatenation([firstVertex], veList));
            SetIsClosedPath(vePath, true);
        else
            # open geodesic path
            SetIsClosedGeodesicPath(efPath, false);
            # Complete last vertex
            vePath := VertexEdgePathNC(com, Concatenation([firstVertex], veList, [lastEdge, OtherVertexOfEdgeNC(com, veList[Length(veList)], lastEdge)]));
        fi;
        SetVertexEdgePath(efPath, vePath);
    end
);
InstallMethod( IsGeodesicPath, 
    "for an edge-face-path on a polygonal complex", 
    [IsEdgeFacePath and IsPolygonalComplexPath],
    function(path)
        __SIMPLICIAL_ZigZagPath( AssociatedVEFComplex(path), path );
        return IsGeodesicPath(path);
    end
);
RedispatchOnCondition(IsGeodesicPath, true, [IsEdgeFacePath], [IsPolygonalComplexPath], 0);

BindGlobal("__SIMPLICIAL_DefiningLocalFlags",
    function(path)
        local flagList, complex, el, vert1, vert2, int, flag, oldFlag,
            vFlag, evFlag, v;

        complex := AssociatedVEFComplex(path);
        for el in EdgeFacePathElements(complex) do
            vert1 := LocalVerticesOfLocalEdges(complex)[el[2][1]];
            vert2 := LocalVerticesOfLocalEdges(complex)[el[2][2]];
            int := Intersection(vert1, vert2);
            if Length(int) <> 1 then
                return fail;
            fi;
            if int[1] = vert1[1] then
                v := vert1[2];
            else
                v := vert1[1];
            fi;
            flag := LocalFlagByLocalVertexLocalEdgeFace(v, el[2][1], el[1]);

            if Length(flagList) > 0 then
                oldFlag := flagList[Length(flagList)];
                # Check whether we have a geodesic
                vFlag := oldFlag^LocalFlagEdgeInvolution(complex);
                evFlag := vFlag^LocalFlagVertexInvolution(complex);
                if flag = evFlag or not IsLocalFlagsFaceEquivalent(complex, evFlag, flag) then
                    return fail;
                fi;
            fi;
            Add(flagList, flag);
        od;

        return flagList;
    end
);
InstallMethod( IsGeodesicPath, 
    "for an edge-face-path on a bend polygonal complex", 
    [IsEdgeFacePath and IsBendPolygonalComplexPath],
    function(path)
        local def;

        def := __SIMPLICIAL_DefiningLocalFlags(path);
        if def = fail then
            # no geodesic path
            return false;
        fi;

        SetDefiningLocalFlags(path, def);
        return true;
   end
);
RedispatchOnCondition(IsGeodesicPath, true, [IsEdgeFacePath], [IsBendPolygonalComplexPath], 0);



InstallMethod( VertexEdgePath, "for a geodesic path on a polygonal complex", 
    [IsEdgeFacePath and IsPolygonalComplexPath and IsGeodesicPath],
    function(geo)
        __SIMPLICIAL_ZigZagPath( AssociatedVEFComplex(geo), geo );
        return VertexEdgePath(geo);
    end
);
RedispatchOnCondition(VertexEdgePath, true, [IsEdgeFacePath], [IsPolygonalComplexPath and IsGeodesicPath], 0);

InstallMethod( VertexEdgePath, 
    "for a geodesic path on a bend polygonal complex",
    [IsEdgeFacePath and IsBendPolygonalComplexPath and IsGeodesicPath],
    function(geo)
        local complex, def, vePath, flag, edge, vertex, vLast,
            lastFlag, vevLast;

        complex := AssociatedVEFComplex(geo);
        def := DefiningLocalFlags(geo);

        vePath := [];
        for flag in def do
            edge := EdgesOfLocalFlags(complex)[flag];
            vertex := VerticesOfLocalFlags(complex)[flag];
            Append(vePath, [edge, vertex]);
        od;

        lastFlag := def[Length(def)];
        vLast := lastFlag^LocalFlagEdgeInvolution(complex);
        Add(vePath, VerticesOfLocalFlags(complex)[vLast]);

        if IsClosedGeodesicPath(geo) then
            # The path is finished
            return VertexEdgePathNC(complex, vePath);
        else
            # We have to add an edge and a vertex to finish the path
            vevLast := (vLast^LocalFlagVertexInvolution(complex))^LocalFlagEdgeInvolution(complex);
            edge := EdgesOfLocalFlags(complex)[vevLast];
            vertex := VerticesOfLocalFlags(complex)[vevLast];
            Append(vePath, [edge, vertex]);
            return VertexEdgePathNC(complex, vePath);
        fi;
    end
);
RedispatchOnCondition(VertexEdgePath, true, [IsEdgeFacePath], [IsBendPolygonalComplexPath and IsGeodesicPath], 0);


InstallMethod( IsClosedGeodesicPath, 
    "for an edge-face-path on a polygonal complex", 
    [IsEdgeFacePath and IsPolygonalComplexPath],
    function(path)
        if not IsGeodesicPath(path) then
            return false;
        fi;

        return IsClosedPath(path) and IsClosedPath( VertexEdgePath(path) );
    end
);
RedispatchOnCondition(IsClosedPath, true, [IsEdgeFacePath], [IsPolygonalComplexPath], 0);
InstallMethod( IsClosedGeodesicPath,
    "for an edge-face-path on a bend polygonal complex",
    [IsEdgeFacePath and IsBendPolygonalComplexPath],
    function(path)
        local def, complex, first, last, vLast, evLast;

        def := DefiningLocalFlags(path);
        complex := AssociatedVEFComplex(path);

        first := def[1];
        last := def[Length(def)];
        vLast := last^LocalFlagEdgeInvolution(complex);
        evLast := vLast^LocalFlagVertexInvolution(complex);

        return first <> evLast and IsLocalFlagsFaceEquivalent(complex, first, evLast);
    end
);
RedispatchOnCondition(IsClosedPath, true, [IsEdgeFacePath], [IsBendPolygonalComplexPath], 0);


InstallMethod( DefiningFlags, "for a geodesic path on a polygonal complex", 
    [IsEdgeFacePath and IsPolygonalComplexPath and IsGeodesicPath],
    function(geo)
        local vePath, efPath, flags, i;

        vePath := Path(VertexEdgePath(geo));
        efPath := Path(geo);
        flags := [];
        for i in [2,4..Length(efPath)-1] do
            Add(flags, [ vePath[i-1], vePath[i], efPath[i] ]);
        od;

        return flags;
    end
);
RedispatchOnCondition( DefiningFlags, true, [IsEdgeFacePath], [IsPolygonalComplexPath and IsGeodesicPath], 0 );

InstallMethod( DefiningLocalFlags, 
    "for a geodesic path on a bend polygonal complex",
    [IsEdgeFacePath and IsBendPolygonalComplexPath and IsGeodesicPath],
    function(geo)
        return __SIMPLICIAL_DefiningLocalFlags(geo);
    end
);
RedispatchOnCondition( DefiningFlags, true, [IsEdgeFacePath], [IsBendPolygonalComplexPath and IsGeodesicPath], 0 );


InstallMethod( MaximalGeodesicPathOfFlagNC, 
    "for a polygonal complex without edge ramifications and a flag",
    [IsPolygonalComplex and IsNotEdgeRamified, IsList],
    function(ramSurf, flag)
        local maxGeo, geo, inv;

        maxGeo := MaximalGeodesicPaths(ramSurf);
        for geo in maxGeo do
            if flag in DefiningFlags(geo) then
                return geo;
            fi;
            inv := Inverse(geo);
            if flag in DefiningFlags(inv) then
                return inv;
            fi;
        od;

        Error("MaximalGeodesicPathOfFlagNC: The given flag was not valid!");
    end
);
InstallMethod( MaximalGeodesicPathOfFlag,
    "for a polygonal complex without edge ramifications and a flag",
    [IsPolygonalComplex and IsNotEdgeRamified, IsList],
    function(ramSurf, flag)
        if not flag in Flags(ramSurf) then
            Error(Concatenation("MaximalGeodesicPathOfFlag: Second argument ", 
                String(flag), 
                " is not a flag of the given polygonal complex."));
        fi;
        return MaximalGeodesicPathOfFlagNC(ramSurf, flag);
    end
);

InstallMethod( MaximalGeodesicPathOfLocalFlagNC, 
    "for a bend polygonal complex without edge ramifications and a local flag",
    [IsBendPolygonalComplex and IsNotEdgeRamified, IsPosInt],
    function(ramSurf, flag)
        local maxGeo, geo, inv;

        maxGeo := MaximalGeodesicPaths(ramSurf);
        for geo in maxGeo do
            if flag in DefiningLocalFlags(geo) then
                return geo;
            fi;
            inv := Inverse(geo);
            if flag in DefiningLocalFlags(inv) then
                return inv;
            fi;
        od;

        Error("MaximalGeodesicPathOfLocalFlagNC: The given flag was not valid!");
    end
);
InstallMethod( MaximalGeodesicPathOfLocalFlag,
    "for a bend polygonal complex without edge ramifications and a local flag",
    [IsBendPolygonalComplex and IsNotEdgeRamified, IsPosInt],
    function(ramSurf, flag)
        if not flag in LocalFlags(ramSurf) then
            Error(Concatenation("MaximalGeodesicPathOfLocalFlag: Second argument ", 
                String(flag), 
                " is not a local flag of the given bend polygonal complex."));
        fi;
        return MaximalGeodesicPathOfLocalFlagNC(ramSurf, flag);
    end
);


BindGlobal( "__SIMPLICIAL_DuplicateFreeGeodesic",
    function( ramSurf, geo, flag )
        local defFlags, indices, faces, pos, startPos;
    
        defFlags := DefiningFlags(geo);
        startPos := Position(defFlags, flag);
        indices := [ startPos ];
        faces := [ flag[3] ];

        pos := startPos;
        while true do
            pos := pos + 1;
            if pos > Length(defFlags) or defFlags[pos][3] in faces then
                break;
            else
                Add(indices, pos);
                Add(faces, defFlags[pos][3]);
            fi;
        od;
        pos := startPos;
        while true do
            pos := pos - 1;
            if pos = 0 or defFlags[pos][3] in faces then
                break;
            else
                indices := Concatenation( [pos], indices );
                Add(faces, defFlags[pos][3]);
            fi;
        od;

        # Now indices encodes the smaller geodesic
        # flag number k represents positions 2*k-1, 2*k
        return EdgeFacePathNC( ramSurf, Path(geo){[2*indices[1]-1..2*indices[Length(indices)]+1]} );
    end
);
InstallMethod( MaximalDuplicateFreeGeodesicPathOfFlag,
    "for a polygonal complex without edge ramifications and a flag",
    [IsPolygonalComplex and IsNotEdgeRamified, IsList],
    function(ramSurf, flag)
        if not flag in Flags(ramSurf) then
            Error(Concatenation("MaximalDuplicateFreeGeodesicPathOfFlag: Second argument ", 
                String(flag), 
                " is not a flag of the given ramified polygonal surface."));
        fi;
        return MaximalDuplicateFreeGeodesicPathOfFlagNC(ramSurf, flag);
    end
);
RedispatchOnCondition( MaximalDuplicateFreeGeodesicPathOfFlag, true,
    [IsPolygonalComplex, IsList], [IsNotEdgeRamified], 0);
InstallMethod( MaximalDuplicateFreeGeodesicPathOfFlagNC,
    "for a polygonal complex without edge ramifications and a flag",
    [IsPolygonalComplex and IsNotEdgeRamified, IsList],
    function(ramSurf, flag)
        local geo;

        geo := MaximalGeodesicPathOfFlagNC(ramSurf, flag);
        return __SIMPLICIAL_DuplicateFreeGeodesic(ramSurf, geo, flag);
    end
);
RedispatchOnCondition( MaximalDuplicateFreeGeodesicPathOfFlagNC, true,
    [IsPolygonalComplex, IsList], [IsNotEdgeRamified], 0);
InstallMethod( MaximalDuplicateFreeGeodesicPaths,
    "for a polygonal complex without edge ramifications", [IsPolygonalComplex and IsNotEdgeRamified],
    function(ramSurf)
        local maxGeo, geo, flag, inv, localGeo;

        maxGeo := [];
        for geo in MaximalGeodesicPaths(ramSurf) do
            localGeo := [];
            for flag in DefiningFlags(geo) do
                localGeo := Union( localGeo, [__SIMPLICIAL_DuplicateFreeGeodesic(ramSurf, geo, flag)] );
            od;
            inv := Inverse(geo);
            for flag in DefiningFlags(inv) do
                localGeo := Union( localGeo, [__SIMPLICIAL_DuplicateFreeGeodesic(ramSurf, inv, flag)] );
            od;
            Append(maxGeo, localGeo);
        od;

        return Set(maxGeo);
    end
);
RedispatchOnCondition( MaximalDuplicateFreeGeodesicPaths, true,
    [IsPolygonalComplex], [IsNotEdgeRamified], 0);


InstallMethod( GeodesicFlagCycle, 
    "for a closed geodesic path on a polygonal complex", 
    [IsEdgeFacePath and IsPolygonalComplexPath and IsClosedGeodesicPath],
    function(closedGeo)
        local vePath, flagPath, i, vertex, edge, face, flagPerm;

        vePath := VertexEdgePath(closedGeo);
        flagPath := [];
        for i in [1,3..Length(Path(vePath))-2] do
            vertex := Path(vePath)[i];
            edge := Path(closedGeo)[i];
            face := Path(closedGeo)[i+1];
            Add(flagPath, Position(Flags(AssociatedVEFComplex(closedGeo)), [vertex,edge,face]));
        od;

        flagPerm := [1..Length(Flags(AssociatedVEFComplex(closedGeo)))];
        for i in [1..Length(flagPath)-1] do
            flagPerm[flagPath[i]] := flagPath[i+1];
        od;
        flagPerm[flagPath[Length(flagPath)]] := flagPath[1];
        return PermList(flagPerm);
    end
);
RedispatchOnCondition( GeodesicFlagCycle, true, [IsEdgeFacePath], [IsPolygonalComplexPath and IsClosedGeodesicPath], 0 );
InstallMethod( GeodesicFlagCycle,
    "for a closed geodesic path on a bend polygonal complex",
    [IsEdgeFacePath and IsBendPolygonalComplexPath and IsClosedGeodesicPath],
    function(closedGeo)
        local def;

        def := DefiningLocalFlags(closedGeo);
        return __SIMPLICIAL_ListToCycle(def);
    end
);
RedispatchOnCondition( GeodesicFlagCycle, true, [IsEdgeFacePath], [IsBendPolygonalComplexPath and IsClosedGeodesicPath], 0 );


InstallMethod( MaximalGeodesicPaths, 
    "for a polygonal complex without edge ramifications",
    [IsPolygonalComplex and IsNotEdgeRamified],
    function(ramSurf)
        local geos, flags, dressVertex, dressEdge, dressFace, boundary,
            dressVEF, dressVEV, todoFlags, start, flagList, invList, i,
            fin, lastFlag, almostNext, next, closed, geo, vePath, efPath,
            flag, lastFlagInv, geoFlags, invFlags;

        flags := Flags(ramSurf);
        dressVertex := DressInvolutions(ramSurf)[1];
        dressEdge := DressInvolutions(ramSurf)[2];
        dressFace := DressInvolutions(ramSurf)[3];
        boundary := BoundaryEdges(ramSurf);

        dressVEV := dressVertex * dressEdge * dressVertex;
        dressVEF := dressVertex * dressEdge * dressFace;

        geos := [];
        todoFlags := ShallowCopy(flags);
        while Length(todoFlags) > 0 do
            # Start with a boundary edge if possible
            start := First( todoFlags, f -> f[2] in boundary );
            if start = fail then
                start := todoFlags[1];
            fi;

            flagList := [ Position(flags, start) ];
            fin := false;
            while not fin do
                lastFlag := flagList[Length(flagList)];
                almostNext := (lastFlag^dressVertex)^dressEdge;
                next := almostNext^dressFace;
                if next = almostNext then
                    # We found another boundary
                    fin := true;
                    closed := false;
                elif next = flagList[1] then
                    # The geodesic path closes
                    fin := true;
                    closed := true;
                else
                    # Continue the geodesic path
                    Add( flagList, next );
                fi;
            od;

            # Compute the flags of the inverse geodesic path
            invList := [];
            invList[1] := flagList[Length(flagList)]^dressVEV;
            for i in [2..Length(flagList)] do
                Add(invList, invList[Length(invList)]^dressVEF);
            od;

            # Write geodesic path and zig-zag-path
            vePath := [];
            efPath := [];
            for i in [1..Length(flagList)] do
                flag := flags[flagList[i]];
                Add( vePath, flag[1] );
                Add( vePath, flag[2] );
                Add( efPath, flag[2] );
                Add( efPath, flag[3] );
            od;
            if closed then
                Add(vePath, vePath[1]);
                Add(efPath, efPath[1]);
            else
                Add(vePath, OtherVertexOfEdgeNC(ramSurf, vePath[Length(vePath)-1], vePath[Length(vePath)]));
                lastFlagInv := flags[invList[1]];
                Add(vePath, lastFlagInv[2]);
                Add(vePath, lastFlagInv[1]);
                Add(efPath, lastFlagInv[2]);
            fi;

            geo := EdgeFacePathNC(ramSurf, efPath);
            SetIsGeodesicPath(geo, true);
            SetIsClosedGeodesicPath(geo, closed);
            SetVertexEdgePath(geo, VertexEdgePathNC(ramSurf, vePath));

            geoFlags := flags{flagList};
            SetDefiningFlags(geo, geoFlags);
            invFlags := flags{invList};
            SetDefiningFlags(Inverse(geo), invFlags);

            Add( geos, geo );
            todoFlags := Difference( todoFlags, Concatenation( geoFlags, invFlags ) );
        od;

        return Set(geos);
    end
);

InstallMethod( MaximalGeodesicPaths, 
    "for a bend polygonal complex without edge ramifications",
    [IsBendPolygonalComplex and IsNotEdgeRamified],
    function(ramSurf)
        local flags, dressVertex, dressEdge, dressFace, dressVEV, dressVEF,
            boundaryEdges, boundaryFlags, geos, todoFlags, start, flagList,
            fin, lastFlag, almostNext, next, closed, invList, i, v, e, f,
            vePath, efPath, elPath, localEdgeOut, localEdgeIn, oppFlag,
            vLastFlag, geo;

        flags := LocalFlags(ramSurf);
        dressVertex := LocalFlagEdgeInvolution(ramSurf);
        dressEdge := LocalFlagVertexInvolution(ramSurf);
        dressFace := LocalFlagFaceInvolution(ramSurf);

        boundaryEdges := BoundaryEdges(ramSurf);
        boundaryFlags := Union( LocalFlagsOfEdges(ramSurf){boundaryEdges} );

        dressVEV := dressVertex * dressEdge * dressVertex;
        dressVEF := dressVertex * dressEdge * dressFace;

        geos := [];
        todoFlags := ShallowCopy(flags);
        while Length(todoFlags) > 0 do
            # Start with a boundary edge if possible
            start := First( todoFlags, f -> f in boundaryFlags );
            if start = fail then
                start := todoFlags[1];
            fi;

            flagList := [ start ];
            fin := false;
            while not fin do
                lastFlag := flagList[Length(flagList)];
                almostNext := (lastFlag^dressVertex)^dressEdge;
                next := almostNext^dressFace;
                if next = almostNext then
                    # We found another boundary
                    fin := true;
                    closed := false;
                elif next = flagList[1] then
                    # The geodesic path closes
                    fin := true;
                    closed := true;
                else
                    # Continue the geodesic path
                    Add( flagList, next );
                fi;
            od;

            # Compute the flags of the inverse geodesic path
            invList := [];
            invList[1] := flagList[Length(flagList)]^dressVEV;
            for i in [2..Length(flagList)] do
                Add(invList, invList[Length(invList)]^dressVEF);
            od;


            # Write geodesic path and zig-zag-path
            vePath := [];
            efPath := [];
            elPath := [];
            for i in [1..Length(flagList)] do
                v := VerticesOfLocalFlags(ramSurf)[flagList[i]];
                e := EdgesOfLocalFlags(ramSurf)[flagList[i]];
                f := FacesOfLocalFlags(ramSurf)[flagList[i]];
                localEdgeIn := LocalEdgesOfLocalFlags(ramSurf)[flagList[i]];
                localEdgeOut := LocalEdgesOfLocalFlags(ramSurf)[flagList[i]^dressVEV];


                Add( vePath, v );
                Add( vePath, e );
                Add( efPath, e );
                Add( efPath, f );
                Add( elPath, [f, [localEdgeIn, localEdgeOut]] );
            od;
            if closed then
                Add(vePath, vePath[1]);
                Add(efPath, efPath[1]);
            else
                lastFlag := flagList[Length(flagList)];
                vLastFlag := lastFlag^dressVertex;
                oppFlag := lastFlag^dressVEV;

                v := VerticesOfLocalFlags(ramSurf)[oppFlag];
                e := EdgesOfLocalFlags(ramSurf)[oppFlag];
                Add(vePath, VerticesOfLocalFlags(ramSurf)[vLastFlag]);
                Add(vePath, e);
                Add(vePath, v);

                Add(efPath, e);
            fi;

            geo := EdgeFacePathNC(ramSurf, efPath, elPath);
            SetIsGeodesicPath(geo, true);
            SetIsClosedGeodesicPath(geo, closed);
            SetVertexEdgePath(geo, VertexEdgePathNC(ramSurf, vePath));

            SetDefiningLocalFlags(geo, flagList);
            SetDefiningFlags(Inverse(geo), invList);

            Add( geos, geo );
            todoFlags := Difference( todoFlags, Concatenation( flagList, invList ) );
        od;

        return Set(geos);
    end
);



#######################################
##
##      edge coloured Edge-Face-Paths
##
DeclareRepresentation("EdgeColouredEdgeFacePathRep", 
    IsEdgeColouredEdgeFacePath and IsAttributeStoringRep, []);
BindGlobal("EdgeColouredEdgeFacePathType", 
    NewType(EdgeColouredEdgeFacePathFamily, EdgeColouredEdgeFacePathRep));

# We could do some inferences between the associated polygonal
# complex and the associated edge-coloured polygonal complex but
# there is no need for that right now (as they are only used for

InstallMethod( ViewInformation, "for an edge-coloured edge-face-path", 
    [IsEdgeColouredEdgeFacePath],
    function(path)
        local strList, i, posOfColour, col, edge, compl;
        
        compl := AssociatedEdgeColouredPolygonalComplex(path);
        posOfColour := [];
        for i in [1..Length(Colours(compl)) ] do
            posOfColour[Colours(compl)[i]] := i;
        od;

        strList := [];
        if IsClosedPath(path) then
            Add( strList, [ "( ", 0 ] );
        else
            Add( strList, [ "| ", 0 ] );
        fi;
        for i in [1..Length(PathAsList(path))] do
            if IsEvenInt(i) then
                Add( strList, [ Concatenation( "F", String(Path(path)[i]) ), 0 ] );
            else
                edge := Path(path)[i];
                col := ColoursOfEdges(AssociatedEdgeColouredPolygonalComplex(path))[edge];
                Add(strList, [ Concatenation( "e", String(edge) ), posOfColour[col] ]);
            fi;
            Add( strList, [", ", 0] );
        od;
        # Remove trailing ","
        Remove(strList);
        if IsClosedPath(path) then
            Add( strList, [ " )", 0 ] );
        else
            Add( strList, [ " |", 0 ] );
        fi;

        return strList;
    end
);
InstallMethod( ViewString, "for an edge-coloured edge-face-path", 
    [IsEdgeColouredEdgeFacePath],
    function(path)
        return __SIMPLICIAL_ColourString( ViewInformation(path), 
            [ SIMPLICIAL_COLOURS_WILD_1_DEFAULT, SIMPLICIAL_COLOURS_WILD_2_DEFAULT, SIMPLICIAL_COLOURS_WILD_3_DEFAULT ]);
    end
);
InstallMethod( ViewObj, "for an edge-coloured edge-face-path", 
    [IsEdgeColouredEdgeFacePath],
    function(path)
        if SIMPLICIAL_COLOURS_ON then
            __SIMPLICIAL_PrintColourString( ViewInformation(path), 
                [ SIMPLICIAL_COLOURS_WILD_1, SIMPLICIAL_COLOURS_WILD_2, SIMPLICIAL_COLOURS_WILD_3 ]);
        else
            Print(__SIMPLICIAL_UncolouredString( ViewInformation(path) ));
        fi;
    end
);

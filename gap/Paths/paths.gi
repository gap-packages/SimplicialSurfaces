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


InstallMethod( VertexEdgePathNC, "for a polygonal complex and a list",
    [IsPolygonalComplex, IsDenseList],
    function(complex, path)
        local obj;

        obj := Objectify( VertexEdgePathType, rec() );
        SetPath(obj, path);
        SetAssociatedPolygonalComplex(obj, complex);

        return obj;
    end
);
RedispatchOnCondition( VertexEdgePathNC, true, [IsPolygonalComplex,IsList],[,IsDenseList],0 );
InstallMethod( VertexEdgePath, "for a polygonal complex and a list",
    [IsPolygonalComplex, IsDenseList],
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
                if not path[i] in Vertices(complex) then
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
RedispatchOnCondition( VertexEdgePath, true, [IsPolygonalComplex,IsList],[,IsDenseList],0 );

InstallMethod( VertexEdgePathByVerticesNC, 
    "for a polygonal complex and a list of vertices",
    [IsPolygonalComplex, IsDenseList],
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
RedispatchOnCondition( VertexEdgePathByVerticesNC, true, [IsPolygonalComplex,IsList],[,IsDenseList],0 );

InstallMethod( VertexEdgePathByVertices, 
    "for a polygonal complex and a list of vertices",
    [IsPolygonalComplex, IsDenseList],
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
                    ") are not connected by an edge in the given polygonal complex."));
            fi;
            path[2*i-2] := pos;
            path[2*i-1] := vertexList[i];
        od;

        return VertexEdgePathNC(complex, path);
    end
);
RedispatchOnCondition( VertexEdgePathByVertices, true, [IsPolygonalComplex,IsList],[,IsDenseList],0 );


InstallMethod( VertexEdgePathByEdgesNC, 
    "for a polygonal complex and a list of edges",
    [IsPolygonalComplex, IsDenseList],
    function(complex, edgeList)
        local path, firstDefinedPos, i, verts;
         
        if edgeList = [] then
            return VertexEdgePathNC(complex, [Minimum(Vertices(complex))]);
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
RedispatchOnCondition( VertexEdgePathByEdgesNC, true, [IsPolygonalComplex, IsList],[,IsDenseList],0 );

InstallMethod( VertexEdgePathByEdges,
    "for a polygonal complex and a list of edges",
    [IsPolygonalComplex, IsDenseList],
    function(complex, edgeList)
        local i;

        if Length(edgeList) > 0 then
            __SIMPLICIAL_CheckEdge(complex, edgeList[1], "VertexEdgePathByEdges");
            for i in [2..Length(edgeList)] do
                __SIMPLICIAL_CheckEdge(complex, edgeList[i], "VertexEdgePathByEdges");
                if IsEmpty( Intersection(
                    VerticesOfEdges(complex)[edgeList[i-1]], 
                    VerticesOfEdges(complex)[edgeList[i]]) ) then
                        Error(Concatenation(
                            "VertexEdgePathByEdges: The edges ",
                            String(edgeList[i-1]), " (position ",
                            String(i-1), ") and ",
                            String(edgeList[i]), " (position ",
                            String(i), 
                            ") do not share a vertex in the given polygonal complex."));
                fi;
            od;
        fi;

        return VertexEdgePathByEdgesNC(complex, edgeList);
    end
);
RedispatchOnCondition( VertexEdgePathByEdges, true, [IsPolygonalComplex, IsList],[,IsDenseList],0 );



InstallMethod( String, "for a vertex-edge-path", [IsVertexEdgePath],
    function(path)
        local str, out;
        
        str := "";
        out := OutputTextString(str,true);

        PrintTo(out, "VertexEdgePathNC( ");
        PrintTo(out, AssociatedPolygonalComplex(path));
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
            AssociatedPolygonalComplex(path1) = AssociatedPolygonalComplex(path2);
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
        return VertexEdgePathNC( AssociatedPolygonalComplex(path),
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


InstallMethod( EdgeFacePathNC, "for a polygonal complex and a list",
    [IsPolygonalComplex, IsDenseList],
    function(complex, path)
        local obj;

        obj := Objectify( EdgeFacePathType, rec() );
        SetPath(obj, path);
        SetAssociatedPolygonalComplex(obj, complex);

        return obj;
    end
);
RedispatchOnCondition( EdgeFacePathNC, true, [IsPolygonalComplex,IsList],[,IsDenseList],0 );
InstallMethod( EdgeFacePath, "for a polygonal complex and a list",
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
                if not path[i] in Edges(complex) then
                    Error( Concatenation( "EdgeFacePath: The number ",
                        String(path[i]), " (position ", String(i),  
                        ") is not an edge of the given complex.") );
                fi;
            else
                if not path[i] in Faces(complex) then
                    Error( Concatenation( "EdgeFacePath: The number ", 
                        String(path[i]), " (position ", String(i), 
                        ") is not a face of the given complex." ) );
                fi;
                if path[i-1] = path[i+1] then
                    Error( Concatenation( 
                        "EdgeFacePath: Two adjacent edges can't be equal (positions ", 
                        String(i-1), " and ", String(i+1), ")." ) );
                fi;
                if not path[i-1] in EdgesOfFaces(complex)[path[i]] then
                    Error( Concatenation( "EdgeFacePath: The edge ", 
                        String(path[i-1]), " (position ", String(i-1), 
                        ") is not incident to the face ", String(path[i]), 
                        " (position ", String(i), ") in the given complex." ) );
                fi;
                if not path[i+1] in EdgesOfFaces(complex)[path[i]] then
                    Error( Concatenation( "EdgeFacePath: The edge ", 
                        String(path[i+1]), " (position ", String(i+1), 
                        ") is not incident to the face ", String(path[i]), 
                        " (position ", String(i), ") in the given complex." ) );
                fi;
            fi;
        od;

        return EdgeFacePathNC(complex, path);
    end
);
RedispatchOnCondition( EdgeFacePath, true, [IsPolygonalComplex,IsList],[,IsDenseList],0 );


InstallMethod( String, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        local str, out;
        
        str := "";
        out := OutputTextString(str,true);

        PrintTo(out, "EdgeFacePathNC( ");
        PrintTo(out, AssociatedPolygonalComplex(path));
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
InstallMethod( ViewString, "for an edge-fae-path", [IsEdgeFacePath],
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
            AssociatedPolygonalComplex(path1) = AssociatedPolygonalComplex(path2);
    end
);

InstallMethod( PathAsList, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        return Path(path);
    end
);
InstallMethod( \<, "for two edge-face-paths", 
    [IsEdgeFacePath, IsEdgeFacePath],
    function(path1, path2)
        return PathAsList(path1) < PathAsList(path2);
    end
);

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




InstallMethod( IsUmbrella, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        local commonFaceVertex, commonEdgeVertex, commonVertex;

        commonEdgeVertex := Intersection( VerticesOfEdges(AssociatedPolygonalComplex(path)){EdgesAsList(path)} );
        commonFaceVertex := Intersection( VerticesOfFaces(AssociatedPolygonalComplex(path)){FacesAsList(path)} );
        commonVertex := Intersection( commonEdgeVertex, commonFaceVertex );
        return Length(commonVertex) <> 0;
    end
);


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
                SetIsGeodesic(efPath, false);
                return fail;
            fi;
        od;

        SetIsGeodesic(efPath, true);
        # Complete the first vertex
        firstVertex := OtherVertexOfEdgeNC( com, veList[2], veList[1] );
        lastEdge := OtherEdgeOfVertexInFaceNC(com, veList[Length(veList)], veList[Length(veList)-1], pathAsList[Length(pathAsList)-1]);
        if lastEdge = veList[1] and firstVertex = veList[Length(veList)] then
            # closed geodesic
            SetIsClosedGeodesic(efPath, true);
            vePath := VertexEdgePathNC(com, Concatenation([firstVertex], veList));
            SetIsClosedPath(vePath, true);
        else
            # open geodesic
            SetIsClosedGeodesic(efPath, false);
            # Complete last vertex
            vePath := VertexEdgePathNC(com, Concatenation([firstVertex], veList, [lastEdge, OtherVertexOfEdgeNC(com, veList[Length(veList), lastEdge])]));
        fi;
        SetVertexEdgePath(efPath, vePath);
    end
);
InstallMethod( IsGeodesic, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        __SIMPLICIAL_ZigZagPath( AssociatedPolygonalComplex(path), path );
        return IsGeodesic(path);
    end
);

InstallMethod( VertexEdgePath, "for a geodesic", 
    [IsEdgeFacePath and IsGeodesic],
    function(geo)
        __SIMPLICIAL_ZigZagPath( AssociatedPolygonalComplex(geo), geo );
        return VertexEdgePath(geo);
    end
);
RedispatchOnCondition(VertexEdgePath, true, [IsEdgeFacePath], [IsGeodesic], 0);

InstallMethod( IsClosedGeodesic, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        if not IsGeodesic(path) then
            return false;
        fi;

        return IsClosedPath(path) and IsClosedPath( VertexEdgePath(path) );
    end
);

InstallMethod( DefiningFlags, "for a geodesic", [IsEdgeFacePath and IsGeodesic],
    function(geo)
        local vePath, efPath, flags, i;

        vePath := VertexEdgePath(geo);
        efPath := Path(geo);
        flags := [];
        for i in [2,4..Length(efPath)-1] do
            Add(flags, [ vePath[i-1], vePath[i], efPath[i] ]);
        od;

        return flags;
    end
);
RedispatchOnCondition( DefiningFlags, true, [IsEdgeFacePath], [IsGeodesic], 0 );


InstallMethod( MaximalGeodesicOfFlagNC, 
    "for a ramified polygonal surface and a flag",
    [IsRamifiedPolygonalSurface, IsList],
    function(ramSurf, flag)
        local maxGeo, geo, inv;

        maxGeo := MaximalGeodesics(ramSurf);
        for geo in maxGeo do
            if flag in DefiningFlags(geo) then
                return geo;
            fi;
            inv := Inverse(geo);
            if flag in DefiningFlags(inv) then
                return inv;
            fi;
        od;

        Error("MaximalGeodesicOfFlagNC: The given flag was not valid!");
    end
);
InstallMethod( MaximalGeodesicOfFlag,
    "for a ramified polygonal surface and a flag",
    [IsRamifiedPolygonalSurface, IsList],
    function(ramSurf, flag)
        if not flag in Flags(ramSurf) then
            Error(Concatenation("MaximalGeodesicOfFlag: Second argument ", 
                String(flag), 
                " is not a flag of the given ramified polygonal surface."));
        fi;
        return MaximalGeodesicOfFlagNC(ramSurf, flag);
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
InstallMethod( MaximalDuplicateFreeGeodesicOfFlag,
    "for a ramified polygonal surface and a flag",
    [IsRamifiedPolygonalSurface, IsList],
    function(ramSurf, flag)
        if not flag in Flags(ramSurf) then
            Error(Concatenation("MaximalDuplicateFreeGeodesicOfFlag: Second argument ", 
                String(flag), 
                " is not a flag of the given ramified polygonal surface."));
        fi;
        return MaximalDuplicateFreeGeodesicOfFlagNC(ramSurf, flag);
    end
);
RedispatchOnCondition( MaximalDuplicateFreeGeodesicOfFlag, true,
    [IsPolygonalComplex, IsList], [IsRamifiedPolygonalSurface], 0);
InstallMethod( MaximalDuplicateFreeGeodesicOfFlagNC,
    "for a ramified polygonal surface and a flag",
    [IsRamifiedPolygonalSurface, IsList],
    function(ramSurf, flag)
        local geo;

        geo := MaximalGeodesicOfFlagNC(ramSurf, flag);
        return __SIMPLICIAL_DuplicateFreeGeodesic(ramSurf, geo, flag);
    end
);
RedispatchOnCondition( MaximalDuplicateFreeGeodesicOfFlagNC, true,
    [IsPolygonalComplex, IsList], [IsRamifiedPolygonalSurface], 0);
InstallMethod( MaximalDuplicateFreeGeodesics,
    "for a ramified polygonal surface", [IsRamifiedPolygonalSurface],
    function(ramSurf)
        local maxGeo, geo, flag, inv, localGeo;

        maxGeo := [];
        for geo in MaximalGeodesics(ramSurf) do
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
RedispatchOnCondition( MaximalDuplicateFreeGeodesics, true,
    [IsPolygonalComplex], [IsRamifiedPolygonalSurface], 0);


InstallMethod( GeodesicFlagCycle, "for a closed geodesic", 
    [IsEdgeFacePath and IsClosedGeodesic],
    function(closedGeo)
        local vePath, flagPath, i, vertex, edge, face, flagPerm;

        vePath := VertexEdgePath(closedGeo);
        flagPath := [];
        for i in [1,3..Length(Path(vePath))-2] do
            vertex := Path(vePath)[i];
            edge := Path(closedGeo)[i];
            face := Path(closedGeo)[i+1];
            Add(flagPath, Position(Flags(AssociatedPolygonalComplex(closedGeo)), [vertex,edge,face]));
        od;

        flagPerm := [1..Length(Flags(AssociatedPolygonalComplex(closedGeo)))];
        for i in [1..Length(flagPath)-1] do
            flagPerm[flagPath[i]] := flagPath[i+1];
        od;
        flagPerm[flagPath[Length(flagPath)]] := flagPath[1];
        return PermList(flagPerm);
    end
);
RedispatchOnCondition( GeodesicFlagCycle, true, [IsEdgeFacePath], [IsClosedGeodesic], 0 );


InstallMethod( MaximalGeodesics, "for a ramified polygonal surface",
    [IsRamifiedPolygonalSurface],
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
        while not IsEmpty(todoFlags) do
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
                    # The geodesic closes
                    fin := true;
                    closed := true;
                else
                    # Continue the geodesic
                    Add( flagList, next );
                fi;
            od;

            # Compute the flags of the inverse geodesic
            invList := [];
            invList[1] := flagList[Length(flagList)]^dressVEV;
            for i in [2..Length(flagList)] do
                Add(invList, invList[Length(invList)]^dressVEF);
            od;

            # Write geodesic and zig-zag-path
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
            SetIsGeodesic(geo, true);
            SetIsClosedGeodesic(geo, closed);
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

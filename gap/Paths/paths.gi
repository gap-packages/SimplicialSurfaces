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
RedispatchOnCondition( VertexEdgePathNC, true, [IsTwistedPolygonalComplex,IsList],[IsPolygonalComplex,IsDenseList],0 );
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
                if not path[i] in VerticesAttributeOfComplex(complex) then
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
RedispatchOnCondition( VertexEdgePath, true, [IsTwistedPolygonalComplex,IsList],[IsPolygonalComplex,IsDenseList],0 );

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
RedispatchOnCondition( VertexEdgePathByVerticesNC, true, [IsTwistedPolygonalComplex,IsList],[IsPolygonalComplex,IsDenseList],0 );

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
RedispatchOnCondition( VertexEdgePathByVertices, true, [IsTwistedPolygonalComplex,IsList],[IsPolygonalComplex,IsDenseList],0 );


InstallMethod( VertexEdgePathByEdgesNC, 
    "for a polygonal complex and a list of edges",
    [IsPolygonalComplex, IsDenseList],
    function(complex, edgeList)
        local path, firstDefinedPos, i, verts;
         
        if edgeList = [] then
            return VertexEdgePathNC(complex, 
                [Minimum(VerticesAttributeOfComplex(complex))]);
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
RedispatchOnCondition( VertexEdgePathByEdgesNC, true, [IsTwistedPolygonalComplex, IsList],[IsPolygonalComplex,IsDenseList],0 );

InstallMethod( VertexEdgePathByEdges,
    "for a polygonal complex and a list of edges",
    [IsPolygonalComplex, IsDenseList],
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
                            ") do not share a vertex in the given polygonal complex."));
                fi;
            od;
        fi;

        return VertexEdgePathByEdgesNC(complex, edgeList);
    end
);
RedispatchOnCondition( VertexEdgePathByEdges, true, [IsTwistedPolygonalComplex, IsList],[IsPolygonalComplex,IsDenseList],0 );


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

InstallMethod(ConcatenationOfPaths, "for a twisted polygonal complex and two vertex-edge paths", 
    [IsTwistedPolygonalComplex, IsVertexEdgePath, IsVertexEdgePath],
    function(surface, path1, path2)
	local edges;
	if Last(VerticesAsList(path1))<>VerticesAsList(path2)[1] then
		Error("ConcatenationOfPaths: The last vertex of the first path has to be the first vertex of the second path");
	fi;
	edges:=Union(EdgesAsList(path1), EdgesAsList(path2));
	return VertexEdgePathByEdges(surface, edges);
	end
);

InstallMethod(ShiftCyclicPathNC,
	"for a vertex-edge path, a vertex and an edge",
	[IsVertexEdgePath,IsPosInt,IsPosInt],
	function(path,vertex,edge)
            local vPos, ePos, i, complex;
            
            complex:=AssociatedPolygonalComplex(path);
	    path:=PathAsList(path);
			
	    if path[1] = vertex and path[2] = edge then
                return VertexEdgePath(complex,path);
            fi;
			
            if path[Length(path)] = vertex and path[Length(path)-1] = edge then
                return VertexEdgePath(complex,Reversed(path));
            fi;

            vPos := 0;
            for i in [3,5..Length(path)-2] do
                if path[i] = vertex then
                    vPos := i;
                fi;
            od;
            Assert(0, vPos > 0);

            ePos := 0;
            for i in [2,4..Length(path)-1] do
                if path[i] = edge then
                    ePos := i;
                fi;
            od;
            Assert(0, ePos > 0);

            if vPos + 1 = ePos then
                return VertexEdgePath(complex, Concatenation( path{[vPos..Length(path)-1]}, path{[1..vPos]} ));
            elif ePos + 1 = vPos then
                return VertexEdgePath(complex, Reversed( Concatenation( path{[vPos..Length(path)]}, path{[2..vPos]} ) ));
            fi;
            Error("ShiftCyclicPath: Internal Error");
	end
);

InstallMethod(ShiftCyclicPath,
        "for a vertex-edge path, a vertex and an edge",
        [IsVertexEdgePath,IsPosInt,IsPosInt],
        function(path,vertex,edge)
            if not IsClosedPath(path) then
                Error(Concatenation("ShiftCyclicPath: Given vertex-edge-path ",String(path)," is not closed."));
            fi;

            if not IsDuplicateFree(path) then
                Error(Concatenation("ShiftCyclicPath: Given vertex-edge-path ",String(path)," is not duplicate free."));
            fi;
        return ShiftCyclicPathNC(path,vertex,edge);
        end
);

#######################################
##
##      Edge-Face-Paths
##
DeclareRepresentation("EdgeFacePathRep", IsEdgeFacePath and IsAttributeStoringRep, []);
BindGlobal("EdgeFacePathType", NewType(EdgeFacePathFamily, EdgeFacePathRep));


InstallMethod( EdgeFacePathNC, "for a polygonal complex and a dense list",
    [IsPolygonalComplex, IsDenseList],
    function(complex, path)
        local obj;

        obj := Objectify( EdgeFacePathType, rec() );
        SetPath(obj, path);
        SetAssociatedPolygonalComplex(obj, complex);
        return obj;
    end
);
RedispatchOnCondition( EdgeFacePathNC, true, [IsTwistedPolygonalComplex,IsList],[IsPolygonalComplex,IsDenseList],0 );

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


InstallMethod( EdgeFacePathByEdgesNC, 
    "for a polygonal complex and a list of edges",
    [IsPolygonalComplex, IsDenseList],
    function(complex, edgeList)
        local path, i;

        if edgeList = [] then
            return fail;
        fi;
        path := [ edgeList[1] ];
        for i in [2..Length(edgeList)] do
            path[2*i-2] := Intersection(FacesOfEdge(complex,edgeList[i-1]),FacesOfEdge(complex,edgeList[i]))[1];
            path[2*i-1] := edgeList[i];
        od;

        return EdgeFacePathNC(complex, path);
    end
);
RedispatchOnCondition( EdgeFacePathByEdgesNC, true, [IsTwistedPolygonalComplex,IsList],[IsPolygonalComplex,IsDenseList],0 );

InstallMethod( EdgeFacePathByEdges, 
    "for a polygonal complex and a list of edges",
    [IsPolygonalComplex, IsDenseList],
    function(complex, edgeList)
        local path, i, pos;

        if edgeList = [] then
            return fail;
        fi;
        __SIMPLICIAL_CheckEdge(complex, edgeList[1], "EdgeFacePathByEdges");
        path := [ edgeList[1] ];
        for i in [2..Length(edgeList)] do
            __SIMPLICIAL_CheckEdge(complex, edgeList[i], "EdgeFacePathByEdges");
            pos := Intersection(FacesOfEdge(complex,edgeList[i-1]),FacesOfEdge(complex,edgeList[i]))[1];
            if pos = fail then
                Error(Concatenation("EdgeFacePathByEdges: The edges ", 
                    String(edgeList[i-1]), " (position ", String(i-1), ") and ", 
                    String(edgeList[i]), " (position ", String(i), 
                    ") are not connected by an face in the given polygonal complex."));
            fi;
            path[2*i-2] := pos;
            path[2*i-1] := edgeList[i];
        od;

        return EdgeFacePathNC(complex, path); 
    end
);
RedispatchOnCondition( EdgeFacePathByEdges, true, [IsTwistedPolygonalComplex,IsList],[IsPolygonalComplex,IsDenseList],0 );


InstallMethod( EdgeFacePathByFacesNC, 
    "for a polygonal complex, a list of faces, the first edge and the last edge",
    [IsPolygonalComplex, IsDenseList, IsPosInt, IsPosInt],
    function(complex, faceList, firstEdge, lastEdge)
        local path, firstDefinedPos, i, edges;
         
        if faceList = [] then
            return fail;
        fi;

        firstDefinedPos := 0;
        for i in [2..Length(faceList)] do
            if EdgesOfFaces(complex)[faceList[i-1]] <> EdgesOfFaces(complex)[faceList[i]] then
                firstDefinedPos := i;
                break;
            fi;
        od;

        if firstDefinedPos = 0 then
            # all faces have the same edges
            edges := EdgesOfFaces(complex)[faceList[1]];
            path := [edges[1]];
            for i in [1..Length(faceList)] do
                path[2*i] := faceList[i];
                if IsEvenInt(i) then
                    path[2*i+1] := edges[1];
                else
                    path[2*i+1] := edges[2];
                fi;
            od;
            return EdgeFacePathNC(complex, path);
        fi;

        # the edge between first-1 and first is unique
        path := [];
        path[2*firstDefinedPos-1] := Intersection( 
            EdgesOfFaces(complex)[faceList[firstDefinedPos-1]],
            EdgesOfFaces(complex)[faceList[firstDefinedPos]])[1];
        for i in [firstDefinedPos, firstDefinedPos+1..Length(faceList)-1] do
            path[2*i] := faceList[i];
            path[2*i+1] := Intersection( 
            EdgesOfFaces(complex)[faceList[i]],
            EdgesOfFaces(complex)[faceList[i+1]])[1];
        od;
	path[2*Length(faceList)] := Last(faceList);
	path[2*Length(faceList)+1] := lastEdge;
        for i in [firstDefinedPos-1, firstDefinedPos-2..2] do
            path[2*i] := faceList[i];
            path[2*i-1] := Intersection( 
            EdgesOfFaces(complex)[faceList[i]],
            EdgesOfFaces(complex)[faceList[i-1]])[1];
        od;
	path[1] := firstEdge;
	path[2] := First(faceList);
		
        return EdgeFacePathNC(complex, path);
    end
);
RedispatchOnCondition( EdgeFacePathByFacesNC, true, [IsTwistedPolygonalComplex, IsList],[IsPolygonalComplex,IsDenseList],0 );

InstallMethod( EdgeFacePathByFaces,
    "for a polygonal complex, a list of faces, the first edge and the last edge",
    [IsPolygonalComplex, IsDenseList, IsPosInt, IsPosInt],
    function(complex, faceList, firstEdge, lastEdge)
        local i;

	 __SIMPLICIAL_CheckEdge(complex, firstEdge, "EdgeFacePathByFaces");
	 __SIMPLICIAL_CheckFace(complex, lastEdge, "EdgeFacePathByFaces");
        if Length(faceList) > 0 then
            __SIMPLICIAL_CheckFace(complex, faceList[1], "EdgeFacePathByFaces");
            for i in [2..Length(faceList)] do
                __SIMPLICIAL_CheckFace(complex, faceList[i], "EdgeFacePathByFaces");
                if Length( Intersection(
                    EdgesOfFaces(complex)[faceList[i-1]], 
                    EdgesOfFaces(complex)[faceList[i]]) ) = 0 then
                        Error(Concatenation(
                            "EdgeFacePathByFaces: The faces ",
                            String(faceList[i-1]), " (position ",
                            String(i-1), ") and ",
                            String(faceList[i]), " (position ",
                            String(i), 
                            ") do not share an edge in the given polygonal complex."));
                fi;
            od;
        fi;

        return EdgeFacePathByFacesNC(complex, faceList, firstEdge, lastEdge);
    end
);
RedispatchOnCondition( EdgeFacePathByFaces, true, [IsTwistedPolygonalComplex, IsList],[IsPolygonalComplex,IsDenseList],0 );

InstallOtherMethod( EdgeFacePathByFacesNC, 
    "for a polygonal complex and a list of faces",
    [IsPolygonalComplex, IsDenseList],
    function(complex, faceList)
        local firstEdges, firstEdgesInner, firstEdge, lastEdges, lastEdgesInner, lastEdge;
         
		firstEdges:=Intersection(EdgesOfFace(complex,faceList[1]),EdgesOfFace(complex,faceList[2]));
		if Length(firstEdges)<>3 then
			firstEdgesInner:=Filtered(Difference(EdgesOfFace(complex,faceList[1]),firstEdges),e->IsInnerEdge(complex,e));
			if firstEdgesInner<>[] then
				firstEdge:=firstEdgesInner[1];
			else
				firstEdge:=Difference(EdgesOfFace(complex,faceList[1]),firstEdges)[1];
			fi;
		else
			firstEdgesInner:=Filtered(firstEdges,e->IsInnerEdge(complex,e));
			if firstEdgesInner<>[] then
				firstEdge:=firstEdgesInner[1];
			else
				firstEdge:=EdgesOfFace(complex,faceList[1])[1];
			fi;
		fi;
		
		lastEdges:=Intersection(EdgesOfFace(complex,faceList[Length(faceList)-1]),EdgesOfFace(complex,Last(faceList)));
		if Length(lastEdges)<>3 then
			lastEdgesInner:=Filtered(Difference(EdgesOfFace(complex,Last(faceList)),lastEdges),e->IsInnerEdge(complex,e));
			if lastEdgesInner<>[] then
				lastEdge:=lastEdgesInner[1];
			else
				lastEdge:=Difference(EdgesOfFace(complex,Last(faceList)),lastEdges)[1];
			fi;
		else
			lastEdgesInner:=Filtered(lastEdges,e->IsInnerEdge(complex,e));
			if lastEdgesInner<>[] then
				lastEdge:=lastEdgesInner[1];
			else
				lastEdge:=EdgesOfFace(complex,Last(faceList))[1];
			fi;
		fi;
		
        return EdgeFacePathByFacesNC(complex, faceList, firstEdge, lastEdge);
    end
);
RedispatchOnCondition( EdgeFacePathByFacesNC, true, [IsTwistedPolygonalComplex, IsList],[IsPolygonalComplex,IsDenseList],0 );

InstallOtherMethod( EdgeFacePathByFaces,
    "for a polygonal complex and a list of faces",
    [IsPolygonalComplex, IsDenseList],
    function(complex, faceList)
        local i, firstEdge, lastEdge;

        if Length(faceList) > 0 then
            __SIMPLICIAL_CheckFace(complex, faceList[1], "EdgeFacePathByFaces");
            for i in [2..Length(faceList)] do
                __SIMPLICIAL_CheckFace(complex, faceList[i], "EdgeFacePathByFaces");
                if Length( Intersection(
                    EdgesOfFaces(complex)[faceList[i-1]], 
                    EdgesOfFaces(complex)[faceList[i]]) ) = 0 then
                        Error(Concatenation(
                            "EdgeFacePathByFaces: The faces ",
                            String(faceList[i-1]), " (position ",
                            String(i-1), ") and ",
                            String(faceList[i]), " (position ",
                            String(i), 
                            ") do not share an edge in the given polygonal complex."));
                fi;
            od;
        fi;

        return EdgeFacePathByFacesNC(complex, faceList);
    end
);
RedispatchOnCondition( EdgeFacePathByFaces, true, [IsTwistedPolygonalComplex, IsList],[IsPolygonalComplex,IsDenseList],0 );

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
            AssociatedPolygonalComplex(path1) = AssociatedPolygonalComplex(path2);
    end
);

InstallMethod( PathAsList, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        return Path(path);
    end
);
InstallMethod( \<, "for two edge-face-paths on polygonal complexes", 
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

InstallMethod( Inverse, "for a edge-face-path on a polygonal complex", 
    [IsEdgeFacePath],
    function(path)
        return EdgeFacePathNC( AssociatedPolygonalComplex(path), Reversed(Path(path)));
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

InstallMethod(ConcatenationOfPaths, "for a twisted polygonal complex and two edge-face paths", 
	[IsTwistedPolygonalComplex, IsEdgeFacePath, IsEdgeFacePath],
	function(surface, path1, path2)
		local pathL1, pathL2;
		if Last(EdgesAsList(path1))<>EdgesAsList(path2)[1] then
			Error("ConcatenationOfPaths: The last edge of the first path has to be the first edge of the second path");
		fi;
		pathL1:=ShallowCopy(PathAsList(path1));
		Remove(pathL1);
		pathL2:=PathAsList(path2);
		Append(pathL1,pathL2);	
		return EdgeFacePath(surface, pathL1);
	end
);

InstallMethod(ShiftCyclicPathNC,
	"for an edge-face path, an edge and a face",
	[IsEdgeFacePath,IsPosInt,IsPosInt],
	function(path,edge,face)
            local ePos, fPos, i, complex;

	    complex:=AssociatedPolygonalComplex(path);
	    path:=PathAsList(path);

            if path[1] = edge and path[2] = face then
                return EdgeFacePath(complex,path);
            fi;
			
            if path[Length(path)] = edge and path[Length(path)-1] = face then
                return EdgeFacePath(complex,Reversed(path));
            fi;

            ePos := 0;
            for i in [3,5..Length(path)-2] do
                if path[i] = edge then
                    ePos := i;
                fi;
            od;
            Assert(0, ePos > 0);

            fPos := 0;
            for i in [2,4..Length(path)-1] do
                if path[i] = face then
                    fPos := i;
                fi;
            od;
            Assert(0, fPos > 0);

            if ePos + 1 = fPos then
                return EdgeFacePath(complex,Concatenation( path{[ePos..Length(path)-1]}, path{[1..ePos]} ));
            elif fPos + 1 = ePos then
                return EdgeFacePath(complex, Reversed( Concatenation( path{[ePos..Length(path)]}, path{[2..ePos]} ) ));
            fi;
            Error("ShiftCyclicPath: Internal Error");
	end
);

InstallMethod(ShiftCyclicPath,
        "for an edge-face path, an edge and a face",
        [IsEdgeFacePath,IsPosInt,IsPosInt],
        function(path,edge,face)
            local ePos, fPos, i, complex;

            if not IsClosedPath(path) then
                Error(Concatenation("ShiftCyclicPath: Given edge-face-path ",String(path)," is not closed."));
            fi;

            if not IsDuplicateFree(path) then
                Error(Concatenation("ShiftCyclicPath: Given edge-face-path ",String(path)," is not duplicate free."));
            fi;
	    return ShiftCyclicPathNC(path,edge,face);
        end
);


InstallMethod( IsUmbrellaPath, "for an edge-face-path on a polygonal complex", 
    [IsEdgeFacePath],
    function(path)
        local complex, commonEdgeVertex, commonFaceVertex, commonVertex;

        complex := AssociatedPolygonalComplex(path);

        commonEdgeVertex := Intersection( VerticesOfEdges(complex){EdgesAsList(path)} );
        commonFaceVertex := Intersection( VerticesOfFaces(complex){FacesAsList(path)} );
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
    [IsEdgeFacePath],
    function(path)
        __SIMPLICIAL_ZigZagPath( AssociatedPolygonalComplex(path), path );
        return IsGeodesicPath(path);
    end
);


InstallMethod( VertexEdgePath, "for a geodesic path on a polygonal complex", 
    [IsEdgeFacePath and IsGeodesicPath],
    function(geo)
        __SIMPLICIAL_ZigZagPath( AssociatedPolygonalComplex(geo), geo );
        return VertexEdgePath(geo);
    end
);
RedispatchOnCondition(VertexEdgePath, true, [IsEdgeFacePath], [IsGeodesicPath], 0);


InstallMethod( IsClosedGeodesicPath, 
    "for an edge-face-path on a polygonal complex", 
    [IsEdgeFacePath],
    function(path)
        if not IsGeodesicPath(path) then
            return false;
        fi;

        return IsClosedPath(path) and IsClosedPath( VertexEdgePath(path) );
    end
);


InstallMethod( DefiningFlags, "for a geodesic path on a polygonal complex", 
    [IsEdgeFacePath and IsGeodesicPath],
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
RedispatchOnCondition( DefiningFlags, true, [IsEdgeFacePath], [IsGeodesicPath], 0 );



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
    [IsEdgeFacePath and IsClosedGeodesicPath],
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
RedispatchOnCondition( GeodesicFlagCycle, true, [IsEdgeFacePath], [IsClosedGeodesicPath], 0 );


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


#######################################
##
##      Waists
##

InstallMethod( AllTwoWaistsOfComplex, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function( surface )
	local waists,i,j,edges,voe1,voe2;
	waists:=[];
	edges:=Edges(surface);
	for i in [1..NumberOfEdges(surface)] do
		for j in [i+1..NumberOfEdges(surface)] do 
			voe1:=VerticesOfEdge(surface,edges[i]);
			voe2:=VerticesOfEdge(surface,edges[j]);
			if voe1=voe2 then
				Add(waists,VertexEdgePathByEdges(surface,edges{[i,j]}));
			fi;
		od;
	od;
	return waists;
end
);

InstallMethod( AllThreeWaistsOfComplex, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function( surface )
        local w,eof,waists;
        waists:=Combinations(Edges(surface),3);
        waists:=Filtered(waists,w->Length(Union(VerticesOfEdges(surface){w}))=3);
        waists:=Filtered(waists,w->Filtered(EdgesOfFaces(surface),
        eof->Length(Intersection(w,eof))>=2)=[]);
        return List(waists,w->VertexEdgePathByEdges(surface,w));
end
);

##
##      End of waists
##
#######################################


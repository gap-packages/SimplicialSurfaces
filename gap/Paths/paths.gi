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

InstallMethod( ViewString, "for a vertex-edge-path", [IsVertexEdgePath],
    function(path)
        local str, out, i;
        
        str := "";
        out := OutputTextString(str,true);

        if IsClosedPath(path) then
            PrintTo(out, "(");
        else
            PrintTo(out, "|");
        fi;
        for i in [1..Length(PathAsList(path))] do
            if i>1 then
                PrintTo(out, ", ");
            fi;
            if IsEvenInt(i) then
                PrintTo(out, "E");
            else
                PrintTo(out, "v");
            fi;
            PrintTo(out, PathAsList(path)[i]);
        od;
        if IsClosedPath(path) then
            PrintTo(out, ")");
        else
            PrintTo(out, "|");
        fi;

        CloseStream(out);
        return str;
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

InstallMethod( ViewString, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        local str, out, i;
        
        str := "";
        out := OutputTextString(str,true);

        if IsClosedPath(path) then
            PrintTo(out, "(");
        else
            PrintTo(out, "|");
        fi;
        for i in [1..Length(PathAsList(path))] do
            if i>1 then
                PrintTo(out, ", ");
            fi;
            if IsEvenInt(i) then
                PrintTo(out, "F");
            else
                PrintTo(out, "e");
            fi;
            PrintTo(out, PathAsList(path)[i]);
        od;
        if IsClosedPath(path) then
            PrintTo(out, ")");
        else
            PrintTo(out, "|");
        fi;

        CloseStream(out);
        return str;
    end
);

#TODO what is important for a display-function?

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
        return Size(commonVertex) <> 0;
    end
);


InstallMethod( IsGeodesic, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        local vertexList, com, i, vertex;

        # Geodesics are exactly those edge-face-paths that also define a vertex-edge-path
        com := AssociatedPolygonalComplex(path);
        vertexList := [];

        for i in [2,4..Length(Path(path))-1] do
            vertex := Intersection( VerticesOfEdges(com){Path(path){[i-1,i+1]}} );
            if Size(vertex) <> 1 then
                Error("IsGeodesic: Internal Error.");
            fi;
            vertex := vertex[1];
            vertexList[i/2] := vertex;
            if i > 2 and vertexList[i/2] = vertexList[i/2-1] then
                return false;
            fi;
        od;

        return true;
    end
);

InstallMethod( IsClosedGeodesic, "for an edge-face-path", [IsEdgeFacePath],
    function(path)
        local start, fin, com, len;

        if not IsGeodesic(path) then
            return false;
        fi;

        com := AssociatedPolygonalComplex(path);
        start := Intersection( VerticesOfEdges(com){Path(path){[1,3]}} )[1];
        len := Length(Path(path));
        fin := Intersection( VerticesOfEdges(com){Path(path){[len-2,len]}} )[1];

        return start <> fin;
    end
);

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
                        path[i], " (position ", i,  
                        ") is not a vertex of the given complex.") );
                fi;
            else
                if not path[i] in Edges(complex) then
                    Error( Concatenation( "VertexEdgePath: The number ", 
                        path[i], " (position ", i, 
                        ") is not an edge of the given complex." ) );
                fi;
                if Set( [path[i-1], path[i+1]] ) <> VerticesOfEdges(complex)[path[i]] then
                    Error( Concatenation( "VertexEdgePath: The numbers ",
                        path[i-1], " and ", path[i+1], 
                        " are not all incident vertices to the edge ", path[i],
                        " (position ", i, ") in the given complex.") );
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



#######################################
##
##      Edge-Face-Paths
##
DeclareRepresentation("EdgefacePathRep", IsEdgeFacePath and IsAttributeStoringRep, []);
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
                        path[i], " (position ", i,  
                        ") is not an edge of the given complex.") );
                fi;
            else
                if not path[i] in Faces(complex) then
                    Error( Concatenation( "EdgeFacePath: The number ", 
                        path[i], " (position ", i, 
                        ") is not a face of the given complex." ) );
                fi;
                if path[i-1] = path[i+1] then
                    Error( Concatenation( 
                        "EdgeFacePath: Two adjacent edges can't be equal (positions ", 
                        i-1, " and ", i+1, ")." ) );
                fi;
                if not path[i-1] in EdgesOfFaces(complex)[path[i]] then
                    Error( Concatenation( "EdgeFacePath: The edge ", 
                        path[i-1], " (position ", i-1, 
                        ") is not incident to the face ", path[i], 
                        " (position ", i, ") in the given complex." ) );
                fi;
                if not path[i+1] in EdgesOfFaces(complex)[path[i]] then
                    Error( Concatenation( "EdgeFacePath: The edge ", 
                        path[i+1], " (position ", i+1, 
                        ") is not incident to the face ", path[i], 
                        " (position ", i, ") in the given complex." ) );
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



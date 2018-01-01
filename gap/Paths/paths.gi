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
InstallMethod( VertexEdgePath, "for a polygonal complex and a list",
    [IsPolygonalComplex, IsDenseList],
    function(complex, path)
        local i;

        if not ForAll(path, IsPosInt) then
            Error("VertexEdgePath: All entries of the path have to be positive integers.");
        fi;
        if IsEvenInt(Length(path)) then
            Error("VertexEdgePath: The given path has to have odd length.");
        fi;

        for i in [1..Length(path)] do
            if IsOddInt(path[i]) then
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
                if Set( path[i-1], path[i+1] ) <> VerticesOfEdges(complex)[path[i]] then
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

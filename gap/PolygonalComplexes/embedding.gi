


#######################################
##
##      Anomalies
##
# Partition elements into classes of elements with equal map value.
# Each class is sorted and the classes are sorted by their smallest element.
# The elements are grouped by their map value by sorting, so that the
# running time does not grow quadratically with the number of elements.
BindGlobal( "__SIMPLICIAL_ComputeClasses",
function( elements, map )
    local keys, classes, start, stop;

    keys := List( elements, i -> [ map[i], i ] );
    Sort( keys );
    classes := [];
    start := 1;
    while start <= Length(keys) do
        stop := start;
        while stop < Length(keys) and keys[stop+1][1] = keys[start][1] do
            stop := stop + 1;
        od;
        Add( classes, List( keys{[start..stop]}, k -> k[2] ) );
        start := stop + 1;
    od;
    # The classes are disjoint, so this sorts them by smallest element
    Sort( classes );

    return classes;
end);


##
## freedom
##
InstallMethod( IsAnomalyFree, "for a twisted polygonal complex", [IsTwistedPolygonalComplex],
    function(complex)
        return NumberOfEdges(complex) = Length(EdgeAnomalyClasses(complex))
            and NumberOfFaces(complex) = Length(FaceAnomalyClasses(complex));
    end
);

##
## edges
##
InstallMethod( EdgeAnomalyClasses, "for a polyonal complex",
    [IsPolygonalComplex],
    function(complex)
        return __SIMPLICIAL_ComputeClasses( Edges(complex), 
                VerticesOfEdges(complex) );
    end
);
InstallMethod( EdgeAnomalyClassOfEdgeNC, 
    "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        local cl;

        for cl in EdgeAnomalyClasses(complex) do
            if edge in cl then
                return cl;
            fi;
        od;

        Error(Concatenation("EdgeAnomalyClassOfEdge: Given edge ", String(edge), " not found."));
    end
);
InstallMethod( EdgeAnomalyClassOfEdge,
    "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "EdgeAnomalyClassOfEdge");
        return EdgeAnomalyClassOfEdgeNC(complex, edge);
    end
);

##
## face
##
InstallMethod( FaceAnomalyClasses, "for a polyonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        return __SIMPLICIAL_ComputeClasses( Faces(complex),
                VerticesOfFaces(complex));
    end
);
InstallMethod( FaceAnomalyClassOfFaceNC, 
    "for a twisted polygonal complex and a face",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, face)
        local cl;

        for cl in FaceAnomalyClasses(complex) do
            if face in cl then
                return cl;
            fi;
        od;

        Error(Concatenation("FaceAnomalyClassOfFace: Given face ", String(face), " not found."));
    end
);
InstallMethod( FaceAnomalyClassOfFace,
    "for a twisted polygonal complex and an face",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, face)
        __SIMPLICIAL_CheckFace(complex, face, "FaceAnomalyClassOfFace");
        return FaceAnomalyClassOfFaceNC(complex, face);
    end
);
##
##      End of anomalies
##
#######################################




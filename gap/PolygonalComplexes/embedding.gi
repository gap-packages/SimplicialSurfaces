


#######################################
##
##      Anomalies
##
BindGlobal( "__SIMPLICIAL_ComputeClasses",
    function( elements, map )
        local classes, i, found, cl, j;

        classes := [];
        for i in elements do
            found := false;
            for j in [1..Length(classes)] do
		cl := classes[j];
		if map[i] = map[cl[1]] then
                    classes[j] := Union( cl, [i] );
		    found := true;
		    break;
		fi;
	    od;
	    if not found then
		Append( classes, [ [i] ] );
	    fi;
	od;

	return classes;
    end
);


##
## freedom
##
InstallMethod( IsAnomalyFree, "for a polygonal complex", [IsPolygonalComplex],
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
    [IsPolygonalComplex],
    function(complex)
        return __SIMPLICIAL_ComputeClasses( Faces(complex),
                VerticesOfFaces(complex));
    end
);
InstallMethod( FaceAnomalyClassOfFaceNC, 
    "for a polygonal complex and a face",
    [IsPolygonalComplex, IsPosInt],
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
    "for a polygonal complex and an face",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
        __SIMPLICIAL_CheckFace(complex, face, "FaceAnomalyClassOfFace");
        return FaceAnomalyClassOfFaceNC(complex, face);
    end
);
##
##      End of anomalies
##
#######################################




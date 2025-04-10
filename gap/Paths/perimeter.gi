#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2025
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################


DeclareRepresentation("PerimeterPathRep", 
    IsPerimeterPath and IsAttributeStoringRep, []);
BindGlobal("PerimeterPathType", 
    NewType(PerimeterPathFamily, PerimeterPathRep));

BindGlobal("__SIMPLICIAL_PerimeterPath_PossibleFaces",
    function(vePath)
        local complex, edges;

        complex := AssociatedPolygonalComplex(vePath);
        edges := EdgesAsList(vePath);

        return Intersection( FacesOfEdges(complex){edges} );
    end
);

InstallMethod(PerimeterPath, "for a vertex-edge-path", [IsVertexEdgePath],
    function(vePath)
        local poss;

        if not IsClosedPath(vePath) then
            Error("PerimeterPath: Given vertex-edge-path has to be closed.");
        fi;

        poss := __SIMPLICIAL_PerimeterPath_PossibleFaces(vePath);
        if Length(poss) = 0 then
            Error("PerimeterPath: No faces incident to all edges of the given vertex-edge-path.");
        fi;
        if Length(poss) > 1 then
            Error(Concatenation(
                "PerimeterPath: There should be only one face that is incident to all edges of the given vertex-edge-path, but ", 
                poss, " were found."));
        fi;

        if Set(EdgesAsList(vePath)) <> EdgesOfFaces(AssociatedPolygonalComplex(vePath))[poss[1]] then
            Error("PerimeterPath: Not all edges of the reconstructed face are traversed.");
        fi;

        return PerimeterPathNC(vePath, poss[1]);
    end
);
InstallMethod(PerimeterPath, "for a vertex-edge-path and a face",
    [IsVertexEdgePath, IsPosInt],
    function(vePath, face)
        local poss;

        if not IsClosedPath(vePath) then
            Error("PerimeterPath: Given vertex-edge-path has to be closed.");
        fi;

        if Set(EdgesAsList(vePath)) <> EdgesOfFaces(AssociatedPolygonalComplex(vePath))[poss[1]] then
            Error("PerimeterPath: Not all edges of the given face are traversed.");
        fi;

        __SIMPLICIAL_CheckFace(AssociatedPolygonalComplex(vePath), face, "PerimeterPath");
        if not face in __SIMPLICIAL_PerimeterPath_PossibleFaces(vePath) then
            Error("PerimeterPath: Given face is not incident to all edges of the vertex-edge-path");
        fi;

        return PerimeterPathNC(vePath, face);
    end
);
InstallMethod( PerimeterPathNC, "for a vertex-edge-path and a face",
    [IsVertexEdgePath, IsPosInt],
    function(vePath, face)
        local obj, localPath;

        obj := Objectify(PerimeterPathType, rec());
        SetAssociatedPolygonalComplex(obj, AssociatedPolygonalComplex(vePath));
        SetPath(obj, PathAsList(vePath));
        SetFace(obj, face);

        return obj;
    end
);



InstallMethod( \=, "for two perimeter paths", IsIdenticalObj, 
    [IsPerimeterPath, IsPerimeterPath],
    function(path1, path2)
        return Face(path1) = Face(path2) and 
            Path(path1) = Path(path2) and
            AssociatedPolygonalComplex(path1) = AssociatedPolygonalComplex(path2);
    end
);


InstallMethod( ReversedPath, "for a perimeter path", [IsPerimeterPath],
    function(path)
        local obj;

        obj := Objectify(PerimeterPathType, rec());
        SetPath(obj, Reversed(Path(path)));
        SetAssociatedPolygonalComplex(obj, AssociatedPolygonalComplex(path));
        SetFace(obj, Face(path));

        return obj;
    end
);



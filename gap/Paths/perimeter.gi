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


DeclareRepresentation("PerimeterPathRep", 
    IsPerimeterPath and IsAttributeStoringRep, []);
BindGlobal("PerimeterPathType", 
    NewType(PerimeterPathFamily, PerimeterPathRep));

BindGlobal("__SIMPLICIAL_PerimeterPath_PossibleFaces",
    function(vePath)
        local complex, edges;

        complex := AssociatedVEFComplex(vePath);
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
                "PerimeterPath: There should be only one face that is incident to alle edges of the given vertex-edge-path, but ", 
                poss, " were found."));
        fi;

        if Set(EdgesAsList(vePath)) <> EdgesOfFaces(AssociatedVEFComplex(vePath))[poss[1]] then
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

        if Set(EdgesAsList(vePath)) <> EdgesOfFaces(AssociatedVEFComplex(vePath))[poss[1]] then
            Error("PerimeterPath: Not all edges of the given face are traversed.");
        fi;

        __SIMPLICIAL_CheckFace(AssociatedVEFComplex(vePath), face, "PerimeterPath");
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
        SetAssociatedVEFComplex(obj, AssociatedVEFComplex(vePath));
        SetPathAsList(obj, PathAsList(vePath));
        SetFace(obj, face);

        if IsBendPolygonalComplexPath(obj) then
            localPath := LocalPath(obj);
            if localPath = fail then
                Error("PerimeterPathNC: The given vertex-edge-path does not translate to a local path.");
            fi;
        fi;

        return obj;
    end
);


InstallMethod( LocalPath, "for a perimeter path", [IsPerimeterPath],
    function(perimPath)
        local complex, poly, vePath, path, e, poss;

        complex := AssociatedVEFComplex(perimPath);
        if not IsBendPolygonalComplex(complex) then
            return fail;
        fi;

        poly := LocalFace(complex, Face(perimPath));
        path := [];
        for e in EdgesAsList(perimPath) do
            # Assume that every edge has a unique local edge in the face
            poss := Intersection( Edges(poly), LocalEdgesOfEdges(complex)[e] );
            if Length(poss) <> 1 then
                return fail;
            fi;
            Append(path, poss);
        od;
        vePath := VertexEdgePathByEdgesNC(poly, path);
        return PerimeterPathNC(vePath, Face(perimPath));
    end
);


InstallMethod( PerimeterPathByLocalPathNC, 
    "for a bend polygonal complex and a perimeter path",
    [IsBendPolygonalComplex, IsPerimeterPath],
    function(bendComplex, perimPath)
        local obj, path, locPath, i;

        obj := Objectify(PerimeterPathType, rec());
        SetLocalPath(obj, perimPath);
        SetFace(obj, Face(perimPath));
        SetAssociatedVEFComplex(obj, bendComplex);

        # Construct PathAsList
        path := [];
        locPath := PathAsList(perimPath);
        for i in [1..Length(locPath)] do
            if IsOddInt(i) then
                # local vertex
                Add(path, VerticesOfLocalVertices(bendComplex)[locPath[i]]);
            else
                # local edge
                Add(path, EdgesOfLocalEdges(bendComplex)[locPath[i]]);
            fi;
        od;
        SetPathAsList(obj, path);

        return obj;
    end
);
InstallMethod( PerimeterPathByLocalPath, 
    "for a bend polygonal complex and a perimeter path",
    [IsBendPolygonalComplex, IsPerimeterPath],
    function(bendComplex, perimPath)
        local locEdges, edges;

        if not Face(perimPath) in Faces(bendComplex) then
            Error("PerimerterPathByLocalPath: Face of local path does not belong to given bend polygonal complex.");
        fi;

        if LocalFaceNC(bendComplex, Face(perimPath)) <> AssociatedVEFComplex(perimPath) then
            Error("PerimeterPathByLocalPath: Associated complex of local path is not a local face.");
        fi;

        if not IsClosedPath(perimPath) then
            Error("PerimeterPathByLocalPath: Local path is not closed.");
        fi;

        locEdges := LocalEdgesOfFaces(bendComplex)[Face(perimPath)];
        edges := EdgesAsList(perimPath);
        if locEdges <> Set(edges) then
            Error("PerimeterPathByLocalPath: Local path is not complete.");
        fi;

        if Length(locEdges) <> Length(edges) then
            Error("PerimeterPathByLocalPath: Local path has different length than number of edges in the polygon.");
        fi;

        #TODO forgot anything?

        return PerimeterPathByLocalPathNC(bendComplex, perimPath);
    end
);

InstallMethod( \=, "for two perimeter paths", IsIdenticalObj, 
    [IsPerimeterPath, IsPerimeterPath],
    function(path1, path2)
        return Face(path1) = Face(path2) and 
            AssociatedVEFComplex(path1) = AssociatedVEFComplex(path2) and
            LocalPath(path1) = LocalPath(path2);
    end
);


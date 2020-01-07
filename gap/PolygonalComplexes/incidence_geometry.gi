#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2016
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################


##############################################################################
##
##          Methods for labelled access
##

# methods to compute number of vertices, edges, faces
InstallMethod( NumberOfVertices, "for a polygonal complex", [IsVEFComplex],
    function(complex)
            return Length( VerticesAttributeOfVEFComplex(complex) );
    end
);

InstallMethod( NumberOfEdges, "for a polygonal complex", [IsVEFComplex],
    function(complex)
            return Length( Edges(complex) );
    end
);

InstallMethod( NumberOfFaces, "for a polygonal complex", [IsVEFComplex],
    function(complex)
            return Length( Faces(complex) );
    end
);


##
##              End of labelled access
##
##############################################################################


##############################################################################
##
##          Methods for basic access (*Of*)
##
#TODO explain internal structure of *Of*

##
##  Implement "faster" access to *Of*-attributes by adding an argument
##

## EdgesOfVertices
InstallMethod(EdgesOfVertexNC, 
    "for a polygonal complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, vertex)
        return EdgesOfVertices(complex)[vertex];
    end
);
InstallMethod(EdgesOfVertex,
    "for a polygonal complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, vertex)
        __SIMPLICIAL_CheckVertex( complex, vertex, "EdgesOfVertex" );
        return EdgesOfVertexNC(complex,vertex);
    end
);

## FacesOfVertices
InstallMethod(FacesOfVertexNC, 
    "for a polygonal complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, vertex)
        return FacesOfVertices(complex)[vertex];
    end
);
InstallMethod(FacesOfVertex,
    "for a polygonal complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, vertex)
        __SIMPLICIAL_CheckVertex( complex, vertex, "FacesOfVertex" );
        return FacesOfVertexNC(complex,vertex);
    end
);


## VerticesOfEdges
InstallMethod(VerticesOfEdgeNC, 
    "for a polygonal complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, edge)
        return VerticesOfEdges(complex)[edge];  
    end
);
InstallMethod(VerticesOfEdge,
    "for a polygonal complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge( complex, edge, "VerticesOfEdge" );
        return VerticesOfEdgeNC(complex,edge);
    end
);


## FacesOfEdges
InstallMethod(FacesOfEdgeNC, 
    "for a polygonal complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, edge)
        return FacesOfEdges(complex)[edge]; 
    end
);
InstallMethod(FacesOfEdge,
    "for a polygonal complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge( complex, edge, "FacesOfEdge" );
        return FacesOfEdgeNC(complex,edge);
    end
);


## VerticesOfFaces
InstallMethod(VerticesOfFaceNC, 
    "for a polygonal complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, face)
        return VerticesOfFaces(complex)[face];
    end
);
InstallMethod(VerticesOfFace,
    "for a polygonal complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, face)
        __SIMPLICIAL_CheckFace( complex, face, "VerticesOfFace" );
        return VerticesOfFaceNC(complex,face);
    end
);


## EdgesOfFaces
InstallMethod(EdgesOfFaceNC, 
    "for a polygonal complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, face)
        return EdgesOfFaces(complex)[face];    
    end
);
InstallMethod(EdgesOfFace,
    "for a polygonal complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, face)
        __SIMPLICIAL_CheckFace( complex, face, "EdgesOfFace" );
        return EdgesOfFaceNC(complex,face);
    end
);


##
##          End of basic access (*Of*)
##
##############################################################################



##############################################################################
##
##          Face-induced order of vertices/edges
##
__SIMPLICIAL_AddVEFAttribute(PerimeterPathsOfFaces);


# the wrappers
InstallMethod( PerimeterPathOfFaceNC, 
    "for a VEF-complex and a face (positive integer)",
    [IsVEFComplex, IsPosInt],
    function(complex, face)
        return PerimeterPathsOfFaces(complex)[face];
    end
);
InstallMethod( PerimeterPathOfFace,
    "for a VEF-complex and a face (positive integer)",
    [IsVEFComplex, IsPosInt],
    function(complex, face)
        __SIMPLICIAL_CheckFace(complex, face, "PerimeterPathOfFace");
        return PerimeterPathOfFaceNC(complex, face);
    end
);


# main computation method
InstallMethod( PerimeterPathsOfFaces, "for a polygonal complex", 
    [IsPolygonalComplex],
    function(complex)
        local paths, f, localVertices, startVert, adEdges,
            i, localPath, len, perim;

        paths := [];
        perim := [];
        for f in Faces(complex) do
            localVertices := VerticesOfFaces(complex)[f];
            startVert := Minimum(localVertices);
            adEdges := Intersection( EdgesOfFaces(complex)[f],
                        EdgesOfVertices(complex)[startVert]);
            Assert(1, adEdges[1]<>adEdges[2]);

            if adEdges[1] < adEdges[2] then
                localPath := [ startVert, adEdges[1], OtherVertexOfEdgeNC(complex,startVert,adEdges[1]) ];
            else
                localPath := [ startVert, adEdges[2], OtherVertexOfEdgeNC(complex,startVert,adEdges[2]) ];
            fi;
            

            for i in [2..Length(localVertices)] do # How long will the path be?
                len := Length(localPath);
                Add( localPath, OtherEdgeOfVertexInFaceNC(complex,
                        localPath[len],localPath[len-1],f) );
                Add( localPath, OtherVertexOfEdgeNC(complex,
                        localPath[len],localPath[len+1]) );
            od;
            Assert(1, localPath[1] = localPath[Length(localPath)]);
            paths[f] := VertexEdgePathNC(complex, localPath);
            perim[f] := PerimeterPathNC(paths[f], f);
        od;

        return perim;
    end
);

AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "PerimeterPathsOfFaces", ["Faces", "VerticesOfFaces", "EdgesOfFaces", 
        "VerticesOfEdges", "EdgesOfVertices"], ["IsPolygonalComplex"]);

# TODO document ordering
InstallMethod( PerimeterPathsOfFaces,
    "for a bend polygonal complex with Faces, VerticesOfFaces, LocalVerticesOfVertices, LocalVerticesOfFaces, EdgesOfLocalEdges, VerticesOfLocalVertices",
    [IsBendPolygonalComplex and HasFaces and HasVerticesOfFaces and 
        HasLocalVerticesOfVertices and HasLocalVerticesOfFaces and
        HasEdgesOfLocalEdges and HasVerticesOfLocalVertices],
    function(bendComplex)
        local perim, f, localFace, verts, startVert, locVerts, startLoc, obj,
            locEdges, edges, localPath, path, i, len, localVE, localPerim;

        perim := [];
        for f in Faces(bendComplex) do
            localFace := LocalFace(bendComplex, f);

            # Find the starting vertex
            verts := VerticesOfFaces(bendComplex)[f];
            startVert := Minimum(verts);
            locVerts := Intersection( 
                LocalVerticesOfVertices(bendComplex)[startVert],
                LocalVerticesOfFaces(bendComplex)[f] );
            startLoc := Minimum(locVerts);

            # Find the next edge
            locEdges := EdgesOfVertices(localFace)[startLoc];
            edges := EdgesOfLocalEdges(bendComplex){locEdges};

            if edges[1] = edges[2] then
                # tie-breaker by local edges
                if locEdges[1] < locEdges[2] then
                    localPath := [ startLoc, locEdges[1] ];
                    path := [ startVert, edges[1] ];
                else
                    localPath := [ startLoc, locEdges[2] ];
                    path := [ startVert, edges[2] ];
                fi;
            elif edges[1] < edges[2] then
                localPath := [ startLoc, locEdges[1] ];
                path := [ startVert, edges[1] ];
            else
                localPath := [ startLoc, locEdges[1] ];
                path := [ startVert, edges[1] ];
            fi;
            Add(localPath, OtherVertexOfEdgeNC(localFace, localPath[1], localPath[2]));
            Add(path, VerticesOfLocalVertices(bendComplex)[localPath[3]]);


            for i in [2..NumberOfEdges(localFace)] do # How long will the path be?
                len := Length(localPath);

                Add( localPath, OtherEdgeOfVertexInFaceNC(localFace, 
                    localPath[len], localPath[len-1],f) );
                Add( localPath, OtherVertexOfEdgeNC(localFace, 
                    localPath[len], localPath[len+1]) );

                Add( path, EdgesOfLocalEdges(bendComplex)[localPath[len+1]] );
                Add( path, VerticesOfLocalVertices(bendComplex)[localPath[len+2]] );
            od;
            Assert(1, localPath[1] = localPath[Length(localPath)]);

            localVE := VertexEdgePathNC(localFace, localPath);
            localPerim := PerimeterPathNC(localVE, f);

            obj := Objectify( PerimeterPathType, rec() );
            SetPath(obj, path);
            SetLocalPath( obj, localPerim );
            SetAssociatedVEFComplex(obj, bendComplex);
            SetFace(obj, f);

            perim[f] := obj;
        od;

        return perim;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "PerimeterPathsOfFaces", 
    ["Faces", "VerticesOfFaces", "LocalVerticesOfVertices", 
        "LocalVerticesOfFaces", "EdgesOfLocalEdges", 
        "VerticesOfLocalVertices"],
    ["IsBendPolygonalComplex"]);


# inferences from the perimeter path
InstallMethod( VerticesOfFaces, 
    "for a VEF-complex with PerimeterPathsOfFaces",
    [IsVEFComplex and HasPerimeterPathsOfFaces],
    function(complex)
        return List( PerimeterPathsOfFaces(complex), p -> Set(VerticesAsList(p)) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, 
    "VerticesOfFaces", ["PerimeterPathsOfFaces"] );


InstallMethod( EdgesOfFaces, 
    "for a VEF-complex with PerimeterPathsOfFaces",
    [IsVEFComplex and HasPerimeterPathsOfFaces],
    function(complex)
        return List( PerimeterPathsOfFaces(complex), p -> Set(EdgesAsList(p)) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, 
    "EdgesOfFaces", ["PerimeterPathsOfFaces"] );


InstallMethod( Faces,
    "for a VEF-complex that has PerimeterPathsOfFaces",
    [IsVEFComplex and HasPerimeterPathsOfFaces],
    function(complex)
        return __SIMPLICIAL_BoundPositions( PerimeterPathsOfFaces(complex) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "Faces", "PerimeterPathsOfFaces");

##
##          End of face-induced order
##
##############################################################################




##############################################################################
##
##      Umbrella-paths around vertices
##
__SIMPLICIAL_AddVEFAttribute(UmbrellaPathPartitionsOfVertices);
__SIMPLICIAL_AddVEFAttribute(UmbrellaPathsOfVertices);

##
## Implement the immediate methods for inferences about the complex
##
InstallImmediateMethod( IsNotVertexRamified, 
    "for a VEF-complex that has UmbrellaPathsOfVertices",
    IsVEFComplex and HasUmbrellaPathsOfVertices, 0,
    function(complex)
        return not fail in UmbrellaPathsOfVertices(complex);
    end
);
AddPropertyIncidence(SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "IsNotVertexRamified", "UmbrellaPathsOfVertices");

InstallImmediateMethod( IsNotEdgeRamified,
    "for a VEF-complex that has UmbrellaPathPartitionsOfVertices",
    IsVEFComplex and HasUmbrellaPathPartitionsOfVertices, 0,
    function(complex)
        return not fail in UmbrellaPathPartitionsOfVertices(complex);
    end
);
AddPropertyIncidence(SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "IsNotEdgeRamified", "UmbrellaPathPartitionsOfVertices");

##
## We will implement the connections between singular paths and partitions
## first. Afterward we will connect the partitions with everything else.
##

InstallMethod( UmbrellaPathsOfVertices,
    "for a VEF-surface that has UmbrellaPathPartitionsOfVertices",
    [IsVEFSurface and HasUmbrellaPathPartitionsOfVertices],
    function( surface )
        local umbPart, v, res;

        res := [];
        umbPart := UmbrellaPathPartitionsOfVertices(surface);
        for v in VerticesAttributeOfVEFComplex(surface) do
            res[v] := umbPart[v][1];
        od;
        return res;
    end
);

InstallMethod( UmbrellaPathsOfVertices,
    "for a VEF-complex that has UmbrellaPathPartitionsOfVertices",
    [IsVEFComplex and HasUmbrellaPathPartitionsOfVertices],
    function(ramSurf)
        local FirstOrFail;

        FirstOrFail := function(list)
            if list = fail then
                return fail;
            elif Length(list) = 1 then
                return list[1];
            else
                return fail;
            fi;
        end;

        return List( UmbrellaPathPartitionsOfVertices(ramSurf), FirstOrFail );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, 
    "UmbrellaPathsOfVertices", 
    ["UmbrellaPathPartitionsOfVertices"]);



InstallImmediateMethod( UmbrellaPathPartitionsOfVertices,
    "for a VEF-complex without edge ramifications that has UmbrellaPathsOfVertices",
    IsVEFComplex and IsNotEdgeRamified and HasUmbrellaPathsOfVertices, 0,
    function( ramSurf )
        return List( UmbrellaPathsOfVertices(ramSurf), p -> [p] );
    end
);


## Methods for one single vertex
InstallMethod( UmbrellaPathOfVertexNC, "for a VEF-complex and a vertex",
    [IsVEFComplex, IsPosInt],
    function( surface, vertex )
        return UmbrellaPathsOfVertices(surface)[vertex];
    end
);
InstallMethod( UmbrellaPathOfVertex, "for a VEF-complex and a vertex",
    [IsVEFComplex, IsPosInt],
    function( surface, vertex )
        __SIMPLICIAL_CheckVertex(surface,vertex, "UmbrellaPathOfVertex");
        return UmbrellaPathOfVertexNC(surface, vertex);
    end
);

InstallMethod( UmbrellaPathPartitionOfVertexNC,
    "for a VEF-complex and a vertex",
    [IsVEFComplex, IsPosInt],
    function( ramSurf, vertex )
        return UmbrellaPathPartitionsOfVertices(ramSurf)[vertex];
    end
);
InstallMethod( UmbrellaPathPartitionOfVertex,
    "for a VEF-complex and a vertex",
    [IsVEFComplex, IsPosInt],
    function( ramSurf, vertex )
        __SIMPLICIAL_CheckVertex(ramSurf, vertex, "UmbrellaPathPartitionOfVertex");
        return UmbrellaPathPartitionOfVertexNC(ramSurf, vertex);
    end
);

##
## Implications from UmbrellaPathPartitionsOfVertices (only to *Of*, since 
## implications to vertices, edges and faces follow from that)
##

#TODO It might be useful to compute IsNotEdgeRamified for the possibility of simplifying the calculations
InstallMethod( EdgesOfVertices, 
    "for a VEF-complex without edge ramifications that has UmbrellaPathPartitionsOfVertices", 
    [IsVEFComplex and IsNotEdgeRamified and HasUmbrellaPathPartitionsOfVertices],
    function(complex)
        return List( UmbrellaPathPartitionsOfVertices(complex), part ->
            __SIMPLICIAL_UnionSets( List( part, EdgesAsList ) ));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "EdgesOfVertices", 
    ["UmbrellaPathPartitionsOfVertices"], ["IsNotEdgeRamified"]);

InstallMethod( FacesOfVertices,
    "for a VEF-complex without edge ramifications that has UmbrellaPathPartitionsOfVertices",
    [IsVEFComplex and IsNotEdgeRamified and HasUmbrellaPathPartitionsOfVertices],
    function(complex)
        return List( UmbrellaPathPartitionsOfVertices(complex), part ->
            __SIMPLICIAL_UnionSets( List( part, FacesAsList ) ));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "FacesOfVertices", 
    ["UmbrellaPathPartitionsOfVertices"], ["IsNotEdgeRamified"]);

InstallMethod( FacesOfEdges,
    "for a VEF-complex without edge ramifications that has UmbrellaPathPartitionsOfVertices and VerticesAttributeOfVEFComplex",
    [IsVEFComplex and IsNotEdgeRamified and HasUmbrellaPathPartitionsOfVertices and HasVerticesAttributeOfVEFComplex],
    function(complex)
        local facesOfEdges, parts, v, p, even, ind, i, edge, incFaces, path;

        parts := UmbrellaPathPartitionsOfVertices(complex);

        facesOfEdges := [];
        for v in VerticesAttributeOfVEFComplex(complex) do
            for p in parts[v] do
                path := PathAsList(p);

                for i in [1..(Length(path)+1)/2] do
                    edge := path[2*i-1];
                    if IsBound(facesOfEdges[edge]) then
                        # Since the complex is ramified, the incident faces should be the same
                        continue;
                    fi;

                    if i = 1 and IsClosedPath(p) then
                        incFaces := Set([ path[2], path[Length(path)-1] ]);
                    elif i = 1 then
                        incFaces := [path[2]];
                    elif not IsClosedPath(p) and 2*i = Length(path)+1 then
                        incFaces := [path[Length(path)-1]];
                    else
                        incFaces := Set( [path[2*i-2],path[2*i]] );
                    fi;
                    facesOfEdges[edge] := incFaces;
                od;
            od;
        od;

        return facesOfEdges;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "FacesOfEdges", 
    ["UmbrellaPathPartitionsOfVertices", "VerticesAttributeOfVEFComplex"], 
    ["IsNotEdgeRamified"]);


InstallMethod( UmbrellaPathPartitionsOfVertices, 
    "for a polygonal complex that has VerticesAttributeOfVEFComplex, EdgesOfVertices, EdgesOfFaces, FacesOfEdges, VerticesOfEdges and RamifiedEdges",
    [IsPolygonalComplex and HasVerticesAttributeOfVEFComplex and 
        HasEdgesOfVertices and HasEdgesOfFaces and HasFacesOfEdges and 
        HasVerticesOfEdges and HasRamifiedEdges],
    function(ramSurf)
        local faceEdgePathPart, vertex, incidentEdges, paths,
            edgeStart, possFaces, rightFinished, leftFinished, backFace, path,
            nextEdge, nextFace, usedEdges;

        faceEdgePathPart := [];

        for vertex in VerticesAttributeOfVEFComplex(ramSurf) do
            incidentEdges := EdgesOfVertices(ramSurf)[vertex];
            paths := [];

            while Length(incidentEdges) > 0 do
                # If the path is not closed, we can't hope to find the correct 
                # start immediately. If the path is closed, the correct start 
                # is the smallest edge.
                edgeStart := incidentEdges[1]; # minimal since we have a set
                incidentEdges := incidentEdges{[2..Length(incidentEdges)]};
                possFaces := FacesOfEdges(ramSurf)[edgeStart];

                # We use two bools to check if we are done
                rightFinished := false;
                leftFinished := false;
                if Length(possFaces) > 2 then
                    # break completely - no edge-face-path partition exists
                    paths := fail;
                    break;
                elif Length(possFaces) = 1 then
                    # very rare special case, where our first pick for a 
                    # non-closed path was lucky
                    leftFinished := true;
                    backFace := fail;
                else
                    # In the hope for a closed path, we continue with the 
                    # smaller face (and store the other one)
                    backFace := possFaces[2];
                fi;
                path := [edgeStart, possFaces[1]];


                # As we may have to traverse both directions (non-closed case)
                # and those traversals are completely equal we use one loop
                # for both
                usedEdges := [];
                while not rightFinished or not leftFinished do
                    # Try to extend the path beyond the last face
                    nextEdge := OtherEdgeOfVertexInFaceNC(ramSurf, vertex, 
                            path[Length(path)-1], path[Length(path)]); 
                            # calls EdgesOfFaces and VerticesOfEdges
                    Add(usedEdges, nextEdge);

                    nextFace := NeighbourFaceByEdgeNC(ramSurf, 
                        path[Length(path)], nextEdge); # calls FacesOfEdges
                    if nextFace = fail then
                        # check if we had a branch
                        if nextEdge in RamifiedEdges(ramSurf) then
                            path := fail;
                            break;
                        fi;
                        # we found an end
                        Add(path, nextEdge);
                        if leftFinished then
                            # We have finished right, but left is already 
                            # finished - we were lucky!
                            rightFinished := true;
                        elif rightFinished then
                            # Now we have finished both sides
                            if path[Length(path)] < path[1] then
                                path := Reversed(path);
                            fi;
                            leftFinished := true;
                        else
                            # We were unlucky - now we have to extend the path
                            # to the left
                            rightFinished := true;
                            path := Reversed(path);
                            Add(path, backFace);
                        fi;
                        continue;
                    fi;

                    # Otherwise we continue
                    Append(path, [nextEdge, nextFace]);
                    if nextFace = backFace then
                        # we have closed the path
                        leftFinished := true;
                        rightFinished := true;
                    fi;
                od;

                # if one of the paths breaks down, there is no partition
                if path = fail then
                    paths := fail;
                    break;
                fi;

                if IsEvenInt( Length(path) ) then
                    # It is a closed path
                    Add(path, path[1]);
                fi;
                Add(paths, EdgeFacePathNC(ramSurf,path));
                incidentEdges := Difference( incidentEdges, usedEdges );
            od;

            faceEdgePathPart[vertex] := paths;
        od;

        return faceEdgePathPart;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, 
    "UmbrellaPathPartitionsOfVertices", 
    ["VerticesAttributeOfVEFComplex", "EdgesOfVertices", "EdgesOfFaces", 
        "FacesOfEdges", "VerticesOfEdges", "RamifiedEdges"], ["IsPolygonalComplex"]);

#TODO compute properly
BindGlobal("__SIMPLICIAL_ConstructUmbrellaBend",
    function(bendComplex, vertex, halfEdge, flag, face)
        local usedHalfEdges, efPath, pathElements, vertexInv, flagList, fin,
            lastHalfEdge, locFlags, lastFlag, nextFlag, furtherFlag, 
            nextHalfEdge, obj;

        vertexInv := LocalFlagVertexInvolution(bendComplex);
        flagList := [ [flag, flag^vertexInv] ];
        usedHalfEdges := [ halfEdge, HalfEdgesOfLocalFlags(bendComplex)[flagList[1][2]] ];
        efPath := [ EdgesOfHalfEdges(bendComplex)[usedHalfEdges[1]], face, EdgesOfHalfEdges(bendComplex)[usedHalfEdges[2]] ];
        pathElements := [ [ face, LocalEdgesOfLocalFlags(bendComplex){flagList[1]}] ];

        fin := false;
        while not fin do
            lastHalfEdge := usedHalfEdges[Length(usedHalfEdges)];
            locFlags := LocalFlagsOfHalfEdges(bendComplex)[lastHalfEdge];
            if lastHalfEdge = usedHalfEdges[1] or Length(locFlags) = 1 then
                fin := true;
                break;
            fi;

            # Continue path
            lastFlag := flagList[Length(flagList)][2];
            if lastFlag = locFlags[1] then
                nextFlag := locFlags[2];
            else
                nextFlag := locFlags[1];
            fi;
            furtherFlag := nextFlag^vertexInv;

            Add(flagList, [nextFlag, furtherFlag]);
            nextHalfEdge := HalfEdgesOfLocalFlags(bendComplex)[furtherFlag];
            Add(usedHalfEdges, nextHalfEdge);
            face := FacesOfLocalFlags(bendComplex)[nextFlag];
            Add(efPath, face);
            Add(efPath, EdgesOfLocalFlags(bendComplex)[furtherFlag]);
            Add(pathElements, [ face, LocalEdgesOfLocalFlags(bendComplex){[nextFlag,furtherFlag]}  ]);
        od;

        # path lists are written, path object has to be constructed
        obj := EdgeFacePathNC(bendComplex, efPath, pathElements);

        return [obj, usedHalfEdges];
    end
);

InstallMethod( UmbrellaPathPartitionsOfVertices, 
    Concatenation("for a bend polygonal complex that has ",
        "VerticesAttributeOfVEFComplex and HalfEdgesOfVertices and ",
        "LocalEdgesOfHalfEdges and EdgesOfHalfEdges and FacesOfEdges and ",
        "LocalFlagsOfHalfEdges and LocalEdgesOfLocalFlags and ",
        "FacesOfLocalFlags and EdgesOfLocalFlags and HalfEdgesOfLocalFlags",
        " and LocalFlagsOfLocalVertices"),
    [IsBendPolygonalComplex and HasVerticesAttributeOfVEFComplex and 
        HasHalfEdgesOfVertices and HasLocalEdgesOfHalfEdges and
        HasEdgesOfHalfEdges and HasFacesOfEdges and HasLocalFlagsOfHalfEdges
        and HasLocalEdgesOfLocalFlags and HasFacesOfLocalFlags and
        HasEdgesOfLocalFlags and HasHalfEdgesOfLocalFlags and 
        HasLocalFlagsOfLocalVertices],
    function(bendComplex)
        local umbrellaPart, v, umbs, umb, halfEdges, innerEdge, boundaryEdge,
            e, locEdge, halfEdge, edge, ed, face, flag, usedHE, locFlags,
            locEdges, faces, i;

        umbrellaPart := [];
        for v in VerticesAttributeOfVEFComplex(bendComplex) do
            umbs := [];

            # Find out which edges are inner and which are boundary
            halfEdges := HalfEdgesOfVertices(bendComplex)[v];
            innerEdge := [];
            boundaryEdge := [];
            for e in halfEdges do #TODO write internal method to compute all types of edges if one of them is asked for
                locEdge := LocalEdgesOfHalfEdges(bendComplex)[e];
                if Length(locEdge) = 2 then
                    Add(innerEdge, e);
                elif Length(locEdge) = 1 then
                    Add(boundaryEdge, e);
                else
                    umbrellaPart[v] := fail;
                    break;
                fi;
            od;
            if IsBound(umbrellaPart[v]) then
                # was set to fail
                continue;
            fi;

            # Start by extending the boundary edges
            while Length(boundaryEdge) > 0 do
                # Find smallest edge here
                halfEdge := 0;
                edge := 0;
                for e in boundaryEdge do
                    ed := EdgesOfHalfEdges(bendComplex)[e];
                    if edge = 0 or ed < edge then
                        halfEdge := e;
                        edge := ed;
                    fi;
                od;
                Assert(1, edge <> 0);

                # Initialise start of umbrella path
                face := FacesOfEdges(bendComplex)[edge][1];
                flag := LocalFlagsOfHalfEdges(bendComplex)[halfEdge][1];
                umb := __SIMPLICIAL_ConstructUmbrellaBend(bendComplex, v, halfEdge, face);
                Add(umbs, umb[1]);
                usedHE := umb[2];
                boundaryEdge := Difference(boundaryEdge, [usedHE[1], usedHE[Length(usedHE)]]);
                innerEdge := Difference(innerEdge, usedHE{[2..Length(usedHE)-1]});
            od;

            # Continue with the inner edges
            while Length(innerEdge) > 0 do
                # Find smallest edge
                halfEdge := 0;
                edge := 0;
                for e in innerEdge do
                    ed := EdgesOfHalfEdges(bendComplex)[e];
                    if edge = 0 or ed < edge then
                        halfEdge := e;
                        edge := ed;
                    fi;
                od;
                Assert(1, edge <> 0);

                # Initialise start of umbrella-path
                locFlags := LocalFlagsOfHalfEdges(bendComplex)[halfEdge];
                locEdges := LocalEdgesOfLocalFlags(bendComplex){locFlags};
                faces := FacesOfLocalFlags(bendComplex){locFlags};
                if faces[1] < faces[2] then
                    i := 1;
                elif faces[1] > faces[2] then
                    i := 2;
                else
                    # Tiebreaker by local edges
                    if locEdges[1] < locEdges[2] then
                        i := 1;
                    else
                        i := 2;
                    fi;
                fi;

                umb := __SIMPLICIAL_ConstructUmbrellaBend(bendComplex, v, halfEdge, locFlags[i], faces[i]);
                Add(umbs, umb[1]);
                innerEdge := Difference( innerEdge, umb[2] );
            od;

            umbrellaPart[v] := Set(umbs);
        od;

        return umbrellaPart;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, 
    "UmbrellaPathPartitionsOfVertices", 
    ["VerticesAttributeOfVEFComplex", "HalfEdgesOfVertices", 
        "LocalEdgesOfHalfEdges", "EdgesOfHalfEdges", "FacesOfEdges",
        "LocalFlagsOfHalfEdges", "LocalEdgesOfLocalFlags",
        "FacesOfLocalFlags", "EdgesOfLocalFlags", "HalfEdgesOfLocalFlags",
        "LocalFlagsOfLocalVertices"], ["IsBendPolygonalComplex"]);
#
##
##          End of edge-face-paths
##
##############################################################################


##############################################################################
##
##          Start of HolePerimeter
##
InstallMethod( PerimeterOfHoles, "for a VEF-surface",
    [IsVEFSurface], 
    function(surface)
        local boundVerts, boundEdges, res, transVert, e, incVert,
            transEdge, v, umb, path, incEdges, adVertex, i, lastEdge,
            lastVertex, nextEdge, nextVertex, vePath, incEdge;

        # Find all boundary edges and encode the incident vertices
        # as transpositions
        boundEdges := BoundaryEdges(surface);
        transVert := [];

        boundVerts := BoundaryVertices(surface);
        transEdge := [];
        incEdge := [];
        for v in boundVerts do
            incEdge[v] := [];
        od;

        for e in boundEdges do
            incVert := VerticesOfEdges(surface)[e];
            transVert[e] := (incVert[1],incVert[2]);
            Add( incEdge[incVert[1]], e );
            Add( incEdge[incVert[2]], e );
        od;

        # Find all boundary vertices and encode the incident boundary
        # edges as transpositions
        for v in boundVerts do
            transEdge[v] := (incEdge[v][1],incEdge[v][2]);
        od;


        res := [];
        while Length(boundVerts) <> 0 do
            path := [ boundVerts[1] ];
            incEdges := incEdge[path[1]];
            if incEdges[1] < incEdges[2] then
                i := 1;
            else
                i := 2;
            fi;
            adVertex := path[1]^transVert[incEdges[i]];
            Append(path, [incEdges[i], adVertex]);

            lastEdge := path[2];
            lastVertex := path[3];
            while path[1] <> path[ Length(path) ] do
                nextEdge := lastEdge^transEdge[lastVertex];
                nextVertex := lastVertex^transVert[nextEdge];
                
                Append(path, [nextEdge, nextVertex]);
                
                lastEdge := nextEdge;
                lastVertex := nextVertex;
            od;

            vePath := VertexEdgePathNC(surface, path);
            Add(res, vePath);
            boundVerts := Difference( boundVerts, VerticesAsList(vePath) );
        od;

        return Set(res);
    end
);
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( PerimeterOfHoles, true, [IsVEFComplex], [IsVEFSurface], 0 );
fi;

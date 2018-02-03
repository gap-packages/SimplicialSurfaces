DeclareRepresentation( "IsBendSurfaceRep", IsBendSurface and IsAttributeStoringRep and IsComponentObjectRep, ["vertexMap", "edgeMap"] );

BendSurfaceType := NewType( BendSurfaceFamily, IsBendSurfaceRep );

InstallMethod( BendSurface, "", [IsList, IsList, IsList, IsList, IsList, IsList],
    function(vertices, edges, faces, vertexMap, edgeMap, edgeSign)
        local obj;

        obj := Objectify( BendSurfaceType, rec( vertexMap := vertexMap, edgeMap := edgeMap ) );
        SetVerticesAttributeOfBendSurface( obj, Set(vertices) );
        SetEdges(obj, Set(edges));
        SetFaces(obj, Set(faces));
        SetEdgeSign(obj, edgeSign);

        return obj;
    end
);

InstallMethod( Vertices, "", [IsBendSurface],
    function(surf)
        return VerticesAttributeOfBendSurface(surf);
    end
);

InstallMethod( BendSurface, "", [IsSimplicialSurface],
    function(surf)
        local vertexMap, edgeMap, f, edges, verts, p, q, r, edgeSign, e, 
            p1,p2,q1,q2,up1,up2, adFaces, v1, v2;

        if not IsClosedSurface(surf) then
            Error("Bend surface currently only supported for closed simpSurfs");
        fi;
        if not IsTriangleSurface(surf) then
            Error("BendSurface only defined for IsTriangleSurface");
        fi;

        vertexMap := VerticesOfFaces(surf);
        edgeMap := [];
        for f in Faces(surf) do
            edges := EdgesOfFaces(surf)[f];
            verts := List( edges, e -> VerticesOfEdges(surf)[e] );
            p := Position( verts, Set( [vertexMap[f][1],vertexMap[f][2]] ) );
            q := Position( verts, Set( [vertexMap[f][2],vertexMap[f][3]] ) );
            r := Position( verts, Set( [vertexMap[f][3],vertexMap[f][1]] ) );
            edgeMap[f] := List([p,q,r], i->edges[i]);
        od;

        edgeSign := [];
        for e in Edges(surf) do
            adFaces := FacesOfEdges(surf)[e];
            verts := VerticesOfEdges(surf)[e];
            v1 := VerticesOfFaces(surf)[adFaces[1]];
            v2 := VerticesOfFaces(surf)[adFaces[2]];

            p1 := Position( v1, verts[1] );
            q1 := Position( v1, verts[2] );
            if p1 + 1 = q1 or (p1=3 and q1 = 1) then
                up1 := true;
            else
                up1 := false;
            fi;

            p2 := Position( v2, verts[1] );
            q2 := Position( v2, verts[2] );
            if p2 + 1 = q2 or (p2=3 and q2 = 1) then
                up2 := true;
            else
                up2 := false;
            fi;

            if up1 = up2 then
                edgeSign[e] := 1;
            else
                edgeSign[e] := -1;
            fi;
        od;

        return BendSurface( Vertices(surf), Edges(surf), Faces(surf), vertexMap, edgeMap, edgeSign );
    end
);

InstallMethod( SimplicialSurface, "", [IsBendSurface],
    function(bend)
        local verts, edge, surf, vertsOfEdges, edgesOfFaces,
            incVerts, f, incEdges, i;

        surf := Objectify( SimplicialSurfaceType, rec() );
        SetVerticesAttributeOfSimplicialSurface(surf, Vertices(bend));
        SetEdges(surf, Edges(bend));
        SetFaces(surf, Faces(bend));

        vertsOfEdges := [];
        edgesOfFaces := [];
        for f in Faces(bend) do
            incEdges := EdgeMap(bend)[f];
            if Size(Set(incEdges)) <> Size(incEdges) then
                return fail;
            fi;
            edgesOfFaces[f] := Set(incEdges);

            incVerts := VertexMap(bend)[f];
            for i in [1..Size(incEdges)] do
                edge := incEdges[i];
                if i = Size(incEdges) then
                    verts := [ incVerts[1], incVerts[i] ];
                else
                    verts := [ incVerts[i], incVerts[i+1] ];
                fi;
                if IsBound( vertsOfEdges[edge] ) then
                    if vertsOfEdges[edge] <> Set(verts) then
                        return fail;
                    fi;
                else
                    if Size(Set(verts)) <> Size(verts) then
                        return fail;
                    fi;
                    vertsOfEdges[edge] := Set(verts);
                fi;
            od;
        od;

        SetVerticesOfEdges(surf, vertsOfEdges);
        SetEdgesOfFaces(surf, edgesOfFaces);


        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(surf);
        return surf;
    end
);

InstallMethod( VertexMap, "", [IsBendSurface],
    function(surf)
        return surf!.vertexMap;
    end
);

InstallMethod( EdgeMap, "", [IsBendSurface],
    function(surf)
        return surf!.edgeMap;
    end
);

InstallMethod( SourceOfLocalEdge, "", [IsPosInt],
    function(edge)
        return edge;
    end
);
InstallMethod( TargetOfLocalEdge, "", [IsPosInt],
    function(edge)
        if edge = 3 then
            return 1;
        else
            return edge+1;
        fi;
    end
);
InstallMethod( LocalEdgeIntersection, "", [IsPosInt, IsPosInt],
    function(e1, e2)
        local sum;
        sum := e1 + e2;
        if sum = 3 then
            return 2;
        elif sum = 4 then
            return 1;
        elif sum = 5 then
            return 3;
        else
            Error("Invalid sum");
        fi;
    end
);

InstallMethod( Geodesics, "", [IsBendSurface],
    function(surf)
        local localVertices, geos, geo, f, locEdges, pair, last, lastEdge,
            lastLocalVertex, pos, otherFace, ePos, nextLocalVertex, nextLocalEdge;

        localVertices := [];
        for f in Faces(surf) do
            for pair in Combinations([1,2,3], 2) do
                Add( localVertices, [ pair[1], f, pair[2] ] );
            od;
        od;
        Sort(localVertices);

        geos := [];

        while not IsEmpty(localVertices) do
            geo := [ localVertices[1] ];
            localVertices := localVertices{[2..Size(localVertices)]};

            while true do
                # consider the last part of the geodesic
                last := geo[ Size(geo) ];
                # we need the global edge where the geodesic ended
                lastEdge := EdgeMap(surf)[last[2]][last[3]];

                if lastEdge = EdgeMap(surf)[geo[1][2]][geo[1][1]] then
                    break;
                fi;

                # last local vertex
                lastLocalVertex := LocalEdgeIntersection( last[1], last[3] );
                # find next face
                pos := PositionsProperty( EdgeMap(surf), e -> lastEdge in e );
                if Size(pos) = 2 then
                    otherFace := Difference( pos, [last[2]] )[1];
                    ePos := Position( EdgeMap(surf)[otherFace], lastEdge );

                    # Where is the next local vertex?
                    if lastLocalVertex = SourceOfLocalEdge(last[3]) then
                        if EdgeSign(surf)[lastEdge] = -1 then
                            nextLocalVertex := SourceOfLocalEdge(ePos);
                        else
                            nextLocalVertex := TargetOfLocalEdge(ePos);
                        fi;
                    else
                        if EdgeSign(surf)[lastEdge] = -1 then
                            nextLocalVertex := TargetOfLocalEdge(ePos);
                        else
                            nextLocalVertex := SourceOfLocalEdge(ePos);
                        fi;
                    fi;

                    # Where is the next local edge?
                    if nextLocalVertex = SourceOfLocalEdge(ePos) then
                        if ePos = 1 then
                            nextLocalEdge := 3;
                        else
                            nextLocalEdge := ePos - 1;
                        fi;
                    else
                        if ePos = 3 then
                            nextLocalEdge := 1;
                        else
                            nextLocalEdge := ePos + 1;
                        fi;
                    fi;

                    Add( geo, [ePos, otherFace, nextLocalEdge] );
                    localVertices := Difference( localVertices, [ [ePos,otherFace,nextLocalEdge], [nextLocalEdge,otherFace,ePos] ] );
                else
                    otherFace := pos[1];
                    Error("Do I really have to implement this geodesic?");
                fi;
            od;

            Add( geos, geo );
        od;

        return Set( geos );
    end
);
InstallMethod( GeodesicsLength, "", [IsBendSurface],
    function(surf)
        return List( Geodesics(surf), Size );
    end
);

InstallMethod( GeodesicDual, "", [IsBendSurface],
    function(surf)
        local geos, vertexMap, edgeMap, edgeSign, f, map, p1, p2, pos, pair;

        geos := Geodesics(surf);
        edgeSign := -1 * EdgeSign(surf);
        edgeMap := EdgeMap(surf);

        vertexMap := [];
        for f in Faces(surf) do
            map := [];
            for pair in [ [1,3], [1,2], [2,3] ] do
                p1 := PositionsProperty( geos, g -> [pair[1],f,pair[2]] in g );
                p2 := PositionsProperty( geos, g -> [pair[2],f,pair[1]] in g );
                pos := Union(p1,p2)[1];
                Add(map, pos);
            od;
            vertexMap[f] := map;
        od;

        return BendSurface( [1..Size(geos)], Edges(surf), Faces(surf), vertexMap, edgeMap, edgeSign );
    end
);

InstallMethod( EulerCharacteristic, "", [IsBendSurface],
    function(surf)
        return Size(Vertices(surf)) - Size(Edges(surf)) + Size(Faces(surf));
    end
);


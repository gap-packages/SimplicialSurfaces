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


#######################################
##
##      Start splitting methods
##


## Splitting edges
InstallOtherMethod( SplitEdge, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        if not edge in Edges(complex) then
            Error(Concatenation("SplitEdge: Given edge ", String(edge), 
                " is not one of the edges ", String(Edges(complex)), 
                " of the given polygonal complex." ) );
        fi;
        return SplitEdgeNC(complex, edge);
    end
);
InstallOtherMethod( SplitEdgeNC, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        local nrIncFaces, max;

        nrIncFaces := Length(FacesOfEdges(complex)[edge]);
        if nrIncFaces = 1 then
            return SplitEdgeNC(complex, edge, [edge]);
        else
            max := Edges(complex)[NumberOfEdges(complex)];
            return SplitEdgeNC(complex, edge, [1..nrIncFaces]+max);
        fi;
    end
);

InstallMethod( SplitEdge, "for a polygonal complex, an edge and a list",
    [IsPolygonalComplex, IsPosInt, IsList],
    function(complex, edge, newEdgeLabels)
        local intersect;

        if not edge in Edges(complex) then
            Error(Concatenation("SplitEdge: Given edge ", String(edge), 
                " is not one of the edges ", String(Edges(complex)), 
                " of the given polygonal complex." ) );
        fi;

        if ForAny(newEdgeLabels, e -> not IsPosInt(e)) then
            Error(Concatenation(
                "SplitEdge: The new edge labels have to be positive integers, but are ", 
                String(newEdgeLabels), "."));
        fi;

        if Length( Set(newEdgeLabels) ) <> Length(FacesOfEdges(complex)[edge]) then
            Error(Concatenation(
                "SplitEdge: The number of new edge labels has to be equal to the number of incident faces."
            ));
        fi;

        intersect := Intersection( Edges(complex), newEdgeLabels );
        if Length(intersect) = 0 or (Length(intersect)=1 and intersect[1] = edge) then
            return SplitEdgeNC(complex, edge, newEdgeLabels);
        else
            Error(Concatenation("SplitEdge: The new edge labels ", 
                String(newEdgeLabels), 
                " have to be disjoint from the existing edge labels ", 
                String(Edges(complex)) ));
        fi;
    end
);
InstallMethod( SplitEdgeNC, "for a polygonal complex, an edge and a list",
    [IsPolygonalComplex, IsPosInt, IsList],
    function(complex, edge, newEdgeLabels)
        local newVertsOfEdges, newFacesOfEdges, verts, l, incFaces, obj, i;

        newEdgeLabels := Set(newEdgeLabels);

        newVertsOfEdges := ShallowCopy( VerticesOfEdges(complex) );
        newFacesOfEdges := ShallowCopy( FacesOfEdges(complex) );
        verts := newVertsOfEdges[edge];
        Unbind(newVertsOfEdges[edge]);
        for l in newEdgeLabels do
            newVertsOfEdges[l] := verts;
        od;

        incFaces := newFacesOfEdges[edge];
        Unbind(newFacesOfEdges[edge]);
        for i in [1..Length(incFaces)] do
            newFacesOfEdges[newEdgeLabels[i]] := [incFaces[i]];
        od;

        obj := Objectify( PolygonalComplexType, rec() );
        SetVerticesOfEdges(obj, newVertsOfEdges);
        SetFacesOfEdges(obj, newFacesOfEdges);
        if HasVerticesOfFaces(complex) then
            SetVerticesOfFaces(obj, VerticesOfFaces(complex));
        fi;
        if HasFacesOfVertices(complex) then
            SetFacesOfVertices(obj, FacesOfVertices(complex));
        fi;
        if HasVerticesAttributeOfPolygonalComplex(complex) then
            SetVerticesAttributeOfPolygonalComplex(obj, 
                VerticesAttributeOfPolygonalComplex(complex));
        fi;
        if HasNumberOfVertices(complex) then
            SetNumberOfVertices(obj, NumberOfVertices(complex));
        fi;
        if HasFaces(complex) then
            SetFaces(obj, Faces(complex));
        fi;
        if HasNumberOfFaces(complex) then
            SetNumberOfFaces(obj, NumberOfFaces(complex));
        fi;
        if HasNumberOfEdges(complex) then
            SetNumberOfEdges(obj, NumberOfEdges(complex) - 1 + Length(newEdgeLabels));
        fi;
        if HasIsTriangularComplex(complex) then
            SetIsTriangularComplex(obj, IsTriangularComplex(complex));
        fi;

        return [obj, newEdgeLabels];
    end
);


## Splitting vertices
BindGlobal( "__SIMPLICIAL_ConnectedStarComponents",
    function(complex, vertex)
        local faces, edges, edgeOfFaces, f, comp, conn;

        faces := FacesOfVertices(complex)[vertex];
        edges := EdgesOfVertices(complex)[vertex];
        edgeOfFaces := [];
        for f in faces do
            edgeOfFaces[f] := Intersection( edges, EdgesOfFaces(complex)[f] );
        od;

        comp := [];
        while Length(faces) > 0 do
            conn := __SIMPLICIAL_AbstractConnectedComponent( 
                faces, edgeOfFaces, faces[1] );
            Add( comp, [ conn, __SIMPLICIAL_UnionSets(edgeOfFaces{conn}) ] );
            faces := Difference(faces, conn);
        od;

        return comp;
    end
);
BindGlobal( "__SIMPLICIAL_SplitVertexWithStarComponent",
    function(complex, vertex, newVertexLabels, starComp)
        local newEdgesOfVertices, i, obj;

        newEdgesOfVertices := ShallowCopy(EdgesOfVertices(complex));
        Unbind(newEdgesOfVertices[vertex]);
        for i in [1..Length(newVertexLabels)] do
            newEdgesOfVertices[newVertexLabels[i]] := starComp[i][2];
        od;

        obj := Objectify( PolygonalComplexType, rec() );
        SetEdgesOfVertices(obj, newEdgesOfVertices);

        if HasFacesOfEdges(complex) then
            SetFacesOfEdges(obj, FacesOfEdges(complex));
        else
            SetEdgesOfFaces(obj, EdgesOfFaces(complex));
        fi;
        if HasEdges(complex) then
            SetEdges(obj, Edges(complex));
        fi;
        if HasNumberOfEdges(complex) then
            SetNumberOfEdges(obj, NumberOfEdges(complex));
        fi;
        if HasFaces(complex) then
            SetFaces(obj, Faces(complex));
        fi;
        if HasNumberOfFaces(complex) then
            SetNumberOfFaces(obj, NumberOfFaces(complex));
        fi;
        if HasNumberOfVertices(complex) then
            SetNumberOfVertices(obj, NumberOfVertices(complex) - 1 + Length(newVertexLabels));
        fi;
        if HasIsTriangularComplex(complex) then
            SetIsTriangularComplex(obj, IsTriangularComplex(complex));
        fi;
        return [obj, newVertexLabels];
    end
);
BindGlobal( "__SIMPLICIAL_SplitVertexWithStar",
    function(complex, vertex, starComp)
        local max;

        if Length(starComp) = 1 then
            return __SIMPLICIAL_SplitVertexWithStarComponent(complex, vertex, [vertex], starComp);
        else
            max := VerticesAttributeOfPolygonalComplex(complex)[NumberOfVertices(complex)];
            return __SIMPLICIAL_SplitVertexWithStarComponent(complex, vertex, [1..Length(starComp)]+max, starComp);
        fi;
    end
);
InstallOtherMethod( SplitVertex, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        if not vertex in VerticesAttributeOfPolygonalComplex(complex) then
            Error(Concatenation("SplitVertex: Given vertex ", String(vertex), 
                " is not one of the vertices ", String(Vertices(complex)), 
                " of the given polygonal complex." ) );
        fi;
        return SplitVertexNC(complex, vertex);
    end
);
InstallOtherMethod( SplitVertexNC, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        local nrIncStars, max, starComp;

        starComp := __SIMPLICIAL_ConnectedStarComponents(complex, vertex);
        nrIncStars := Length(starComp);
        if nrIncStars = 1 then
            return __SIMPLICIAL_SplitVertexWithStarComponent(complex, vertex, [vertex], starComp);
        else
            max := VerticesAttributeOfPolygonalComplex(complex)[ NumberOfVertices(complex) ];
            return __SIMPLICIAL_SplitVertexWithStarComponent(complex, vertex, [1..nrIncStars]+max, starComp);
        fi;
    end
);

InstallMethod( SplitVertex, "for a polygonal complex, a vertex and a list",
    [IsPolygonalComplex, IsPosInt, IsList],
    function(complex, vertex, newVertexLabels)
        local intersect, starComp;

        if not vertex in VerticesAttributeOfPolygonalComplex(complex) then
            Error(Concatenation("SplitVertex: Given vertex ", String(vertex), 
                " is not one of the vertices ", String(Vertices(complex)), 
                " of the given polygonal complex." ) );
        fi;

        if ForAny(newVertexLabels, v -> not IsPosInt(v)) then
            Error(Concatenation(
                "SplitVertex: The new vertex labels have to be positive integers, but are ", 
                String(newVertexLabels), "."));
        fi;

        starComp := __SIMPLICIAL_ConnectedStarComponents(complex, vertex);
        if Length( Set(newVertexLabels) ) <> Length(starComp) then
            Error(Concatenation(
                "SplitVertex: The number of new vertex labels has to be equal to the number of incident stars.TODO"
            ));
        fi;

        intersect := Intersection( VerticesAttributeOfPolygonalComplex(complex), 
            newVertexLabels );
        if Length(intersect) = 0 or (Length(intersect)=1 and intersect[1] = vertex) then
            return __SIMPLICIAL_SplitVertexWithStarComponent(complex, vertex, newVertexLabels, starComp);
        else
            Error(Concatenation("SplitVertex: The new vertex labels ", 
                String(newVertexLabels), 
                " have to be disjoint from the existing vertex labels ", 
                String(Vertices(complex)) ));
        fi;
    end
);
InstallMethod( SplitVertexNC, "for a polygonal complex, a vertex and a list",
    [IsPolygonalComplex, IsPosInt, IsList],
    function(complex, vertex, newVertexLabels)
        local starComp;
        
        starComp := __SIMPLICIAL_ConnectedStarComponents(complex, vertex);

        return __SIMPLICIAL_SplitVertexWithStarComponent(complex, vertex, newVertexLabels, starComp);
    end
);

## Splitting vertex-edge-paths
BindGlobal( "__SIMPLICIAL_ComputeNewVertexEdgePaths",
    function(oldComplex, vePath, newComplex, labelList)
        local partialPaths, i, newPaths, p, pNew, pOld, newEdge, used, 
            newVertex, resPaths;

        partialPaths := [ [[],[]] ];
        for i in [1..Length(labelList)] do
            # Try to extend every partial path in as many ways as possible
            if IsEvenInt(i) then
                # We have to add an edge => paths can't start here
                newPaths := [];
                for p in partialPaths do
                    pNew := p[1];
                    pOld := p[2];
                    for newEdge in labelList[i] do
                        if pNew[Length(pNew)] in VerticesOfEdges(newComplex)[newEdge] then
                            Add(newPaths, [ 
                                Concatenation(pNew, [newEdge]), 
                                Concatenation(pOld, [PathAsList(vePath)[i]]) 
                            ] );
                        fi;
                    od;
                od;
                partialPaths := newPaths;
            else
                # We have to add a vertex => paths can start here
                newPaths := [];
                for newVertex in labelList[i] do
                    used := false;
                    for p in partialPaths do
                        pNew := p[1];
                        pOld := p[2];
                        if Length(pNew) = 0 or pNew[Length(pNew)] in EdgesOfVertices(newComplex)[newVertex] then
                            Add(newPaths, [
                                Concatenation(pNew, [newVertex]),
                                Concatenation(pOld, [PathAsList(vePath)[i]])
                            ]);
                            used := true;
                        fi;
                    od;
                    if not used then
                        Add(newPaths, 
                            [ [newVertex], [PathAsList(vePath)[i]] ]);
                    fi;
                od;
                partialPaths := newPaths;
            fi;
        od;

        resPaths := [];
        for i in [1..Length(newPaths)] do
            resPaths[i] := [ VertexEdgePathNC(newComplex, newPaths[i][1]), VertexEdgePathNC(oldComplex, newPaths[i][2]) ];
        od;
        return resPaths;
    end
);


InstallMethod( SplitVertexEdgePath,
    "for a polygonal complex and a duplicate-free vertex-edge-path",
    [IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree],
    function(complex, vePath)
        if not complex = AssociatedPolygonalComplex(vePath) then
            Error("SplitVertexEdgePath: Given vertex-edge-path has to match the given polygonal complex.");
        fi;
        return SplitVertexEdgePathNC(complex, vePath);
    end
);
RedispatchOnCondition( SplitVertexEdgePath, true, 
    [IsPolygonalComplex, IsVertexEdgePath], [,IsDuplicateFree], 0 );

InstallMethod( SplitVertexEdgePathNC,
    "for a polygonal complex and a duplicate-free vertex-edge-path",
    [IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree],
    function(complex, vePath)
        local newLabelList, swapComplex, newComplex, i, edgeSplit, 
            vertexSplit, size;

        newLabelList := [];
        swapComplex := complex;
        # Split the edges
        for i in [1..Length(EdgesAsList(vePath))] do
            edgeSplit := SplitEdge(swapComplex, EdgesAsList(vePath)[i]);
            swapComplex := edgeSplit[1];
            newLabelList[2*i] := edgeSplit[2];
        od;
        # Split the vertices
        for i in [1..Length(VerticesAsList(vePath))-1] do
            vertexSplit := SplitVertex(swapComplex, VerticesAsList(vePath)[i]);
            swapComplex := vertexSplit[1];
            newLabelList[2*i-1] := vertexSplit[2];
        od;
        size := Length(VerticesAsList(vePath));
        if IsClosedPath(vePath) then
            # The last vertex has already be splitted!
            newLabelList[2*size-1] := newLabelList[1];
        else
            vertexSplit := SplitVertex(swapComplex, VerticesAsList(vePath)[size]);
            swapComplex := vertexSplit[1];
            newLabelList[2*size-1] := vertexSplit[2];
        fi;
        newComplex := swapComplex;

        return [newComplex, __SIMPLICIAL_ComputeNewVertexEdgePaths(
                    complex,vePath, newComplex, newLabelList)];
    end
);
RedispatchOnCondition( SplitVertexEdgePathNC, true, 
    [IsPolygonalComplex, IsVertexEdgePath], [,IsDuplicateFree], 0 );


#####


InstallMethod( SplitEdgePath,
    "for a polygonal complex and a duplicate-free vertex-edge-path",
    [IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree],
    function(complex, vePath)
        if not complex = AssociatedPolygonalComplex(vePath) then
            Error("SplitEdgePath: Given vertex-edge-path has to match the given polygonal complex.");
        fi;
        return SplitEdgePathNC(complex, vePath);
    end
);
RedispatchOnCondition( SplitEdgePath, true, 
    [IsPolygonalComplex, IsVertexEdgePath], [,IsDuplicateFree], 0 );

InstallMethod( SplitEdgePathNC, "for a polygonal complex and a duplicate-free vertex-edge-path",
    [IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree],
    function(complex, vePath)
        local newLabelList, swapComplex, newComplex, i, edgeSplit, 
            vertexSplit;

        newLabelList := [];
        swapComplex := complex;
        # Split the edges
        for i in [1..Length(EdgesAsList(vePath))] do
            # Repeated edge splits are "relatively cheap" since they only
            # modify VerticesOfEdges and FacesOfEdges
            edgeSplit := SplitEdgeNC(swapComplex, EdgesAsList(vePath)[i]);
            swapComplex := edgeSplit[1];
            newLabelList[2*i] := edgeSplit[2];
        od;
        
        # Split the vertices
        newLabelList[1] := [VerticesAsList(vePath)[1]];
        for i in [2..Length(VerticesAsList(vePath))-1] do
            vertexSplit := SplitVertexNC(swapComplex, VerticesAsList(vePath)[i]);

            swapComplex := vertexSplit[1];
            newLabelList[2*i-1] := vertexSplit[2];
        od;
        Add(newLabelList, [VerticesAsList(vePath)[Length(VerticesAsList(vePath))]]);
        newComplex := swapComplex;

        return [newComplex, __SIMPLICIAL_ComputeNewVertexEdgePaths(
                    complex,vePath, newComplex, newLabelList)];
    end
);
RedispatchOnCondition( SplitEdgePathNC, true, 
    [IsPolygonalComplex, IsVertexEdgePath], [,IsDuplicateFree], 0 );


##
##      End splitting methods
##
#######################################


#######################################
##
##      Face removal
##
InstallMethod( SubcomplexByFaces, "for a polygonal complex and a set of faces",
    [IsPolygonalComplex, IsSet],
    function(complex, subfaces)
	if not IsSubset( Faces(complex), subfaces ) then
	    Error("SubcomplexByFaces: there are not only faces given.");
	fi;

	return SubcomplexByFacesNC( complex, subfaces );
    end
);
InstallOtherMethod( SubcomplexByFaces, 
    "for a polygonal complex and a list of faces",
    [ IsPolygonalComplex, IsList ],
    function(complex, subfaces)
        return SubcomplexByFaces(complex, Set(subfaces));
    end
);
InstallMethod( SubcomplexByFacesNC, "for a polygonal complex and a set of faces",
    [IsPolygonalComplex, IsSet],
    function(complex, subfaces)
	local subVertices, subEdges, newVerticesOfEdges, newEdgesOfFaces, e, f;


        subEdges := __SIMPLICIAL_UnionSets( EdgesOfFaces(complex){subfaces} );
        subVertices := __SIMPLICIAL_UnionSets( VerticesOfEdges(complex){subEdges} );

	newVerticesOfEdges := [];
	for e in subEdges do
	    newVerticesOfEdges[e] := VerticesOfEdges(complex)[e];
	od;

	newEdgesOfFaces := [];
	for f in subfaces do
	    newEdgesOfFaces[f] := EdgesOfFaces(complex)[f];
	od;

	return PolygonalComplexByDownwardIncidenceNC( subVertices, subEdges,
			subfaces, newVerticesOfEdges, newEdgesOfFaces );
    end
);
InstallOtherMethod( SubcomplexByFacesNC, 
    "for a polygonal complex and a list of faces",
    [ IsPolygonalComplex, IsList ],
    function(complex, subfaces)
        return SubcomplexByFacesNC(complex, Set(subfaces));
    end
);

####

InstallMethod( RemoveFaces, "for a polygonal complex and a set of faces",
    [IsPolygonalComplex, IsSet],
    function(complex, subfaces)
	if not IsSubset( Faces(complex), subfaces ) then
	    Error("RemoveFaces: there are not only faces given.");
	fi;

	return RemoveFacesNC( complex, subfaces );
    end
);
InstallOtherMethod( RemoveFaces, 
    "for a polygonal complex and a list of faces",
    [ IsPolygonalComplex, IsList ],
    function(complex, subfaces)
        return RemoveFaces(complex, Set(subfaces));
    end
);
InstallMethod( RemoveFacesNC, "for a polygonal complex and a set of faces",
    [IsPolygonalComplex, IsSet],
    function(complex, subfaces)
        return SubcomplexByFacesNC(complex, Difference(Faces(complex), subfaces));
    end
);
InstallOtherMethod( RemoveFacesNC, 
    "for a polygonal complex and a list of faces",
    [ IsPolygonalComplex, IsList ],
    function(complex, subfaces)
        return RemoveFacesNC(complex, Set(subfaces));
    end
);

InstallMethod( RemoveFace, "for a polygonal complex and a face",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
        if not face in Faces(complex) then
            Error(Concatenation("RemoveFace: The given face ", String(face), 
                " is not a face of the given complex: ", 
                String(Faces(complex)), ".") );
        fi;
        return RemoveFaceNC(complex, face);
    end
);
InstallMethod( RemoveFaceNC, "for a polygonal complex and a face",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
        return RemoveFaces(complex,[face]);
    end
);


##
##      End of face removal
##
#######################################


#######################################
##
##      Disjoint Union
##

InstallOtherMethod(DisjointUnion, "for two polygonal complexes",
    [IsPolygonalComplex, IsPolygonalComplex],
    function(complex1, complex2)
        return DisjointUnion(complex1, complex2, 0);
    end
);
InstallMethod(DisjointUnion, "for two polygonal complexes and an integer",
    [IsPolygonalComplex, IsPolygonalComplex, IsInt],
    function(complex1, complex2, shift)
        local realShift, newVerticesOfEdges, newFacesOfEdges, obj, e, 
            newEdges, vMax, eMax, fMax;

        if Length( Intersection(
                    VerticesAttributeOfPolygonalComplex(complex1), 
                    VerticesAttributeOfPolygonalComplex(complex2)) ) = 0 and
            Length( Intersection(Edges(complex1), Edges(complex2)) ) = 0 and
            Length( Intersection(Faces(complex1), Faces(complex2)) ) = 0 then
                realShift := 0;
        else
            vMax := VerticesAttributeOfPolygonalComplex(complex1)[ NumberOfVertices(complex1) ];
            eMax := Edges(complex1)[NumberOfEdges(complex1)];
            fMax := Faces(complex1)[NumberOfFaces(complex1)];
            realShift := Maximum( [vMax, eMax, fMax] );
        fi;

        if shift > realShift then
            realShift := shift;
        fi;

        newVerticesOfEdges := ShallowCopy( VerticesOfEdges(complex1) );
        newFacesOfEdges := ShallowCopy( FacesOfEdges(complex1) );
        newEdges := ShallowCopy( Edges(complex1) );
        for e in Edges(complex2) do
            newVerticesOfEdges[e + realShift] := VerticesOfEdges(complex2)[e] + realShift;
            newFacesOfEdges[e + realShift] := FacesOfEdges(complex2)[e] + realShift;
            Add(newEdges, e + realShift);
        od;

        obj := Objectify( PolygonalComplexType, rec() );
        SetVerticesOfEdges(obj, newVerticesOfEdges);
        SetFacesOfEdges(obj, newFacesOfEdges);
        SetEdges(obj, newEdges);
        if HasIsTriangularComplex(complex1) and HasIsTriangularComplex(complex2) then
            SetIsTriangularComplex(obj, IsTriangularComplex(complex1) and IsTriangularComplex(complex2));
        fi;

        return [obj, realShift];
    end
);


##
##      End of disjoint union
##
#######################################


#######################################
##
##      Joining methods
##


## Vertices
InstallMethod( JoinVertices, "for two polygonal complexes and two vertices",
    [IsPolygonalComplex, IsPosInt, IsPolygonalComplex, IsPosInt],
    function(complex1, v1, complex2, v2)
        if not v1 in VerticesAttributeOfPolygonalComplex(complex1) then
            Error(Concatenation("JoinVertices: The first vertex ", String(v1), 
                " is not one of the vertices in the first polygonal complex: ", 
                String(Vertices(complex1)), "."));
        fi;
        if not v2 in VerticesAttributeOfPolygonalComplex(complex2) then
            Error(Concatenation("JoinVertices: The second vertex ", String(v2), 
                " is not one of the vertices in the second polygonal complex: ", 
                String(Vertices(complex2)), "."));
        fi;
        return JoinVerticesNC(complex1,v1,complex2,v2);
    end
);
InstallMethod( JoinVerticesNC, "for two polygonal complexes and two vertices",
    [IsPolygonalComplex, IsPosInt, IsPolygonalComplex, IsPosInt],
    function(complex1, v1, complex2, v2)
        local disjoint, join;

        disjoint := DisjointUnion(complex1, complex2);
        join := JoinVerticesNC( disjoint[1], v1, v2+disjoint[2] );
        if join = fail then
            return fail;
        fi;
        Add(join, disjoint[2]);
        return join;
    end
);

InstallOtherMethod( JoinVertices, 
    "for a polygonal complex and a list of two vertices",
    [IsPolygonalComplex, IsList],
    function(complex, vertList)
        local vertSet, label;

        vertSet := Set(vertList);
        if Length(vertSet) = 1 then
            label := vertSet[1];
        else
            label := VerticesAttributeOfPolygonalComplex(complex)[NumberOfVertices(complex)] + 1;
        fi;
        return JoinVertices(complex, vertSet, label);
    end
);
InstallOtherMethod( JoinVerticesNC,
    "for a polygonal complex and a list of two vertices",
    [IsPolygonalComplex, IsList],
    function(complex, vertList)
        local vertSet, label;

        vertSet := Set(vertList);
        if Length(vertSet) = 1 then
            label := vertSet[1];
        else
            label := VerticesAttributeOfPolygonalComplex(complex)[NumberOfVertices(complex)] + 1;
        fi;
        return JoinVerticesNC(complex, vertSet, label);
    end
);

InstallMethod( JoinVertices, 
    "for a polygonal complex, a list of two vertices and a new vertex label",
    [IsPolygonalComplex, IsList, IsPosInt],
    function(complex, vertList, newVertexLabel)
        local vertSet;

        vertSet := Set(vertList);
        if Length(vertSet) > 2 then
            Error(Concatenation("JoinVertices: Given vertex list ", String(vertList), 
                " contains more than two different elements."));
        fi;
        if not IsSubset(VerticesAttributeOfPolygonalComplex(complex), vertSet) then
            Error(Concatenation("JoinVertices: Given vertex list ", String(vertList),
                " is not a subset of the vertices of the given complex: ",
                String(Vertices(complex)), "."));
        fi;
        if not newVertexLabel in vertSet and 
                newVertexLabel in VerticesAttributeOfPolygonalComplex(complex) then
            Error(Concatenation("JoinVertices: Given new vertex label ", 
                String(newVertexLabel), " conflicts with existing vertices: ", 
                String(Vertices(complex)), "."));
        fi;

        if Length(vertSet) = 2 then
            return JoinVerticesNC(complex, vertSet[1], vertSet[2], newVertexLabel);
        else
            return JoinVerticesNC(complex, vertSet[1], vertSet[1], newVertexLabel);
        fi;
    end
);
InstallMethod( JoinVerticesNC,
    "for a polygonal complex, a list of two vertices and a new vertex label",
    [IsPolygonalComplex, IsList, IsPosInt],
    function(complex, vertList, newVertexLabel)
        local vertSet;

        vertSet := Set(vertList);
        if Length(vertSet) = 2 then
            return JoinVerticesNC(complex, vertSet[1], vertSet[2], newVertexLabel);
        else
            return JoinVerticesNC(complex, vertSet[1], vertSet[1], newVertexLabel);
        fi;
    end
);

InstallOtherMethod( JoinVertices,
    "for a polygonal complex and two vertices",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, v1, v2)
        local label;

        if v1 = v2 then
            label := v1;
        else
            label := VerticesAttributeOfPolygonalComplex(complex)[NumberOfVertices(complex)]+1;
        fi;
        return JoinVertices(complex, v1, v2, label);
    end
);
InstallOtherMethod( JoinVerticesNC,
    "for a polygonal complex and two vertices",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, v1, v2)
        local label;

        if v1 = v2 then
            label := v1;
        else
            label := VerticesAttributeOfPolygonalComplex(complex)[NumberOfVertices(complex)]+1;
        fi;
        return JoinVerticesNC(complex, v1, v2, label);
    end
);

InstallMethod( JoinVertices,
    "for a polygonal complex, two vertices and a new vertex label",
    [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt],
    function(complex, v1, v2, newVertexLabel)
        __SIMPLICIAL_CheckVertex(complex, v1, "JoinVertices");
        __SIMPLICIAL_CheckVertex(complex, v2, "JoinVertices");
        if newVertexLabel <> v1 and newVertexLabel <> v2 and 
                newVertexLabel in VerticesAttributeOfPolygonalComplex(complex) then
            Error(Concatenation("JoinVertices: Given new vertex label ", 
                String(newVertexLabel), " conflicts with existing vertices: ", 
                String(Vertices(complex)), "."));
        fi;

        return JoinVerticesNC(complex, v1, v2, newVertexLabel);
    end
);
InstallMethod( JoinVerticesNC,
    "for a polygonal complex, two vertices and a new vertex label",
    [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt],
    function(complex, v1, v2, newVertexLabel)
        local newEdgesOfVertices, newEdges, obj, vSet, verts;

        if v1 = v2 and v1 = newVertexLabel then
            return [complex, newVertexLabel];
        fi;

        if v1 <> v2 then
            if IsTriangularComplex(complex) then
                vSet := Set([v1,v2]);
                for verts in VerticesOfEdges(complex) do
                    if verts = vSet then
                        return fail;
                    fi;
                od;
            else
                if ForAny( VerticesOfFaces(complex), verts -> IsSubset(verts,[v1,v2]) ) then
                    return fail;
                fi;
            fi; 
        fi;

        newEdgesOfVertices := ShallowCopy(EdgesOfVertices(complex));
        newEdges := __SIMPLICIAL_UnionSets( [newEdgesOfVertices[v1],newEdgesOfVertices[v2]] );
        Unbind(newEdgesOfVertices[v1]);
        Unbind(newEdgesOfVertices[v2]);
        newEdgesOfVertices[newVertexLabel] := newEdges;

        obj := Objectify(PolygonalComplexType, rec());
        SetEdgesOfVertices(obj, newEdgesOfVertices);
        if HasEdgesOfFaces(complex) then
            SetEdgesOfFaces(obj, EdgesOfFaces(complex));
        else
            SetFacesOfEdges(obj, FacesOfEdges(complex));
        fi;
        if HasEdges(complex) then
            SetEdges(obj, Edges(complex));
        fi;
        if HasFaces(complex) then
            SetFaces(obj, Faces(complex));
        fi;
        if HasIsTriangularComplex(complex) then
            SetIsTriangularComplex(obj, IsTriangularComplex(complex));
        fi;

        return [obj, newVertexLabel];
    end
);



## Edges
InstallOtherMethod( JoinEdges, 
    "for a polygonal complex and a list of two edges",
    [IsPolygonalComplex, IsList],
    function(complex, edgeList)
        return JoinEdges(complex, edgeList, Edges(complex)[NumberOfEdges(complex)] +1);
    end
);
InstallOtherMethod( JoinEdgesNC, 
    "for a polygonal complex and a list of two edges",
    [IsPolygonalComplex, IsList],
    function(complex, edgeList)
        return JoinEdgesNC(complex, edgeList, Edges(complex)[NumberOfEdges(complex)] + 1);
    end
);
InstallMethod( JoinEdges,
    "for a polygonal complex, a list of two edges and a new edge label",
    [IsPolygonalComplex, IsList, IsPosInt],
    function(complex, edgeList, newEdgeLabel)
         local edgeSet;

        edgeSet := Set(edgeList);
        if Length(edgeSet) <> 2 then
            Error(Concatenation("JoinEdges: Given edge list ", String(edgeList), 
                " contains more than two different elements."));
        fi;
        if not IsSubset(Edges(complex), edgeSet) then
            Error(Concatenation("JoinEdges: Given edge list ", String(edgeList),
                " is not a subset of the edges of the given complex: ",
                String(Edges(complex)), "."));
        fi;
        if not newEdgeLabel in edgeSet and newEdgeLabel in Edges(complex) then
            Error(Concatenation("JoinEdges: Given new edge label ", 
                String(newEdgeLabel), " conflicts with existing edges: ", 
                String(Edges(complex)), "."));
        fi;

        return JoinEdges(complex, edgeSet[1], edgeSet[2], newEdgeLabel);
    end
);
InstallMethod( JoinEdgesNC,
    "for a polygonal complex, a list of two edges and a new edge label",
    [IsPolygonalComplex, IsList, IsPosInt],
    function(complex, edgeList, newEdgeLabel)
        local edgeSet;

        edgeSet := Set(edgeList);
        return JoinEdgesNC(complex, edgeSet[1], edgeSet[2], newEdgeLabel);
    end
);

InstallOtherMethod( JoinEdges, "for a polygonal complex and two edges",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, e1, e2)
        return JoinEdges(complex, e1, e2, Edges(complex)[NumberOfEdges(complex)]+1);
    end
);
InstallOtherMethod( JoinEdgesNC, "for a polygonal complex and two edges",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, e1, e2)
        return JoinEdgesNC(complex, e1, e2, Edges(complex)[NumberOfEdges(complex)]+1);
    end
);

InstallMethod( JoinEdges, 
    "for a polygonal complex, two edges and a new edge label",
    [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt],
    function(complex, e1, e2, newEdgeLabel)
        __SIMPLICIAL_CheckEdge(complex, e1, "JoinEdges");
        __SIMPLICIAL_CheckEdge(complex, e2, "JoinEdges");
        if e1 = e2 then
            Error(Concatenation("JoinEdges: Given edges are identical: ", String(e1), "."));
        fi;
        if newEdgeLabel <> e1 and newEdgeLabel <> e2 and newEdgeLabel in Edges(complex) then
            Error(Concatenation("JoinEdges: Given new edge label ", 
                String(newEdgeLabel), " conflicts with existing edges: ", 
                String(Edges(complex)), "."));
        fi;
        if VerticesOfEdges(complex)[e1] <> VerticesOfEdges(complex)[e2] then
            Error(Concatenation(
                "JoinEdges: The two given edges are incident to different vertices, namely ",
                String(VerticesOfEdges(complex)[e1]), " and ",
                String(VerticesOfEdges(complex)[e2]), "."));
        fi;

        return JoinEdgesNC(complex, e1, e2, newEdgeLabel);
    end
);
InstallMethod( JoinEdgesNC,
    "for a polygonal complex, two edges and a new edge label",
    [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt],
    function(complex, e1, e2, newEdgeLabel)
        local obj, newVerticesOfEdges, newFacesOfEdges, faces, verts;

        newVerticesOfEdges := ShallowCopy( VerticesOfEdges(complex) );
        newFacesOfEdges := ShallowCopy( FacesOfEdges(complex) );

        verts := newVerticesOfEdges[e1];
        Unbind(newVerticesOfEdges[e1]);
        Unbind(newVerticesOfEdges[e2]);
        newVerticesOfEdges[newEdgeLabel] := verts;

        faces := __SIMPLICIAL_UnionSets( newFacesOfEdges{[e1,e2]} );
        Unbind(newFacesOfEdges[e1]);
        Unbind(newFacesOfEdges[e2]);
        newFacesOfEdges[newEdgeLabel] := faces;

        obj := Objectify( PolygonalComplexType, rec() );
        SetVerticesOfEdges(obj, newVerticesOfEdges);
        SetFacesOfEdges(obj, newFacesOfEdges);
        if HasVerticesOfFaces(complex) then
            SetVerticesOfFaces(obj, VerticesOfFaces(complex));
        fi;
        if HasFacesOfVertices(complex) then
            SetFacesOfVertices(obj, FacesOfVertices(complex));
        fi;
        if HasVerticesAttributeOfPolygonalComplex(complex) then
            SetVerticesAttributeOfPolygonalComplex(obj, 
                VerticesAttributeOfPolygonalComplex(complex));
        fi;
        if HasFaces(complex) then
            SetFaces(obj, Faces(complex));
        fi;
        if HasIsTriangularComplex(complex) then
            SetIsTriangularComplex(obj, IsTriangularComplex(complex));
        fi;
        return [obj, newEdgeLabel];
    end
);




## VertexEdgePaths
InstallMethod( JoinVertexEdgePaths, 
    "for two polygonal complexes and two duplicate-free vertex-edge-paths",
    [IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree, 
        IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree],
    function(complex1, vePath1, complex2, vePath2)
        if complex1 <> AssociatedPolygonalComplex(vePath1) then
            Error(Concatenation("JoinVertexEdgePaths: The first path ", 
                String(vePath1), " does not belong to the first polygonal complex."));
        fi;
        if complex2 <> AssociatedPolygonalComplex(vePath2) then
            Error(Concatenation("JoinVertexEdgePaths: The second path ", 
                String(vePath2), " does not belong to the first polygonal complex."));
        fi;

        if Length(VerticesAsList(vePath1)) <> Length(VerticesAsList(vePath2)) then
            Error(Concatenation("JoinVertexEdgePaths: The given paths ",
                String(vePath1), " and ", String(vePath2), " have different lengths."));
        fi;

        return JoinVertexEdgePathsNC(complex1, vePath1, complex2, vePath2);
    end
);
RedispatchOnCondition( JoinVertexEdgePaths, true, 
    [IsPolygonalComplex, IsVertexEdgePath, IsPolygonalComplex, IsVertexEdgePath],
    [,IsDuplicateFree,,IsDuplicateFree], 0);

InstallMethod( JoinVertexEdgePathsNC, 
    "for two polygonal complexes and two duplicate-free vertex-edge-paths",
    [IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree, 
        IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree],
    function(complex1, vePath1, complex2, vePath2)
        local disjoint, join;

        disjoint := DisjointUnion(complex1, complex2);
        join := JoinVertexEdgePathsNC(disjoint[1], vePath1, 
            VertexEdgePath(disjoint[1], List(PathAsList(vePath2), x -> x+disjoint[2]) ) );
        if join = fail then
            return fail;
        fi;

        Add(join, disjoint[2]);
        return join;
    end
);
RedispatchOnCondition( JoinVertexEdgePathsNC, true, 
    [IsPolygonalComplex, IsVertexEdgePath, IsPolygonalComplex, IsVertexEdgePath],
    [,IsDuplicateFree,,IsDuplicateFree], 0);

InstallMethod( JoinVertexEdgePaths, 
    "for a polygonal complexes and two duplicate-free vertex-edge-paths",
    [IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree, 
        IsVertexEdgePath and IsDuplicateFree],
    function(complex, vePath1, vePath2)
        if complex <> AssociatedPolygonalComplex(vePath1) then
            Error(Concatenation("JoinVertexEdgePaths: The first path ", 
                String(vePath1), " does not belong to the polygonal complex."));
        fi;
        if complex <> AssociatedPolygonalComplex(vePath2) then
            Error(Concatenation("JoinVertexEdgePaths: The second path ", 
                String(vePath2), " does not belong to the polygonal complex."));
        fi;

        if Length(VerticesAsList(vePath1)) <> Length(VerticesAsList(vePath2)) then
            Error(Concatenation("JoinVertexEdgePaths: The given paths ",
                String(vePath1), " and ", String(vePath2), " have different lengths."));
        fi;

        return JoinVertexEdgePathsNC(complex, vePath1, vePath2);
    end
);
RedispatchOnCondition( JoinVertexEdgePaths, true, 
    [IsPolygonalComplex, IsVertexEdgePath, IsVertexEdgePath],
    [,IsDuplicateFree,IsDuplicateFree], 0);

InstallMethod( JoinVertexEdgePathsNC, 
    "for a polygonal complexes and two duplicate-free vertex-edge-paths",
    [IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree, 
        IsVertexEdgePath and IsDuplicateFree],
    function(complex, vePath1, vePath2)
        local swapComplex, labelList, i, join, v1, v2, size;

        swapComplex := complex;
        labelList := [];

        # Identify vertices
        for i in [1..Length(VerticesAsList(vePath1))-1] do;
            join := JoinVerticesNC( swapComplex, VerticesAsList(vePath1)[i], VerticesAsList(vePath2)[i] );
            if join = fail then
                return fail;
            fi;
            labelList[2*i-1] := join[2];
            swapComplex := join[1];
        od;
        # The last step has to be handled differently if the paths are closed
        size := Length(VerticesAsList(vePath1));
        if IsClosedPath(vePath1) then
            v1 := labelList[1];
        else
            v1 := VerticesAsList(vePath1)[size];
        fi;
        if IsClosedPath(vePath2) then
            v2 := labelList[1];
        else
            v2 := VerticesAsList(vePath2)[size];
        fi;
        join := JoinVerticesNC( swapComplex, v1, v2 );
        if join = fail then
            return fail;
        fi;
        labelList[2*size-1] := join[2];
        swapComplex := join[1];


        # Identify edges
        for i in [1..Length(EdgesAsList(vePath1))] do
            join := JoinEdgesNC( swapComplex, EdgesAsList(vePath1)[i], EdgesAsList(vePath2)[i] );
            labelList[2*i] := join[2];
            swapComplex := join[1];
        od;

        return [swapComplex, VertexEdgePath(swapComplex, labelList)];
    end
);
RedispatchOnCondition( JoinVertexEdgePathsNC, true, 
    [IsPolygonalComplex, IsVertexEdgePath, IsVertexEdgePath],
    [,IsDuplicateFree,IsDuplicateFree], 0);


## Boundaries
InstallMethod(JoinBoundaries,
    "for two polygonal surfaces and two 2-flags",
    [IsPolygonalSurface, IsList, IsPolygonalSurface, IsList],
    function(surface1, flag1, surface2, flag2)
        local disjoint, join;

        disjoint := DisjointUnion(surface1, surface2);
        join := JoinBoundaries( disjoint[1], flag1, flag2 + disjoint[2] );
        if join = fail then
            return fail;
        fi;
        Add(join, disjoint[2]);
        return join;
    end
);
RedispatchOnCondition( JoinBoundaries, true, [IsPolygonalComplex, IsList, IsPolygonalComplex, IsList], [IsPolygonalSurface,,IsPolygonalSurface], 0 );
InstallMethod(JoinBoundaries,
    "for a polygonal surface and two 2-flags",
    [IsPolygonalSurface, IsList, IsList],
    function(surface, flag1, flag2)
        local perims, perim1, perim2, bound1, bound2, Reorient, p, join;

        if Length(flag1) < 2 then
            Error(Concatenation("JoinBoundaries: First 2-flag should contain two elements, but actually has ", String(Length(flag1)),"."));
        fi;
        if Length(flag2) < 2 then
            Error(Concatenation("JoinBoundaries: Second 2-flag should contain two elements, but actually has ", String(Length(flag2)),"."));
        fi;
        if not flag1[1] in BoundaryVertices(surface) then
            Error(Concatenation("JoinBoundaries: Vertex ", String(flag1[1]), " of first flag is not a boundary vertex."));
        fi;
        if not flag2[1] in BoundaryVertices(surface) then
            Error(Concatenation("JoinBoundaries: Vertex ", String(flag2[1]), " of second flag is not a boundary vertex."));
        fi;
        if not flag1[2] in BoundaryEdges(surface) then
            Error(Concatenation("JoinBoundaries: Edge ", String(flag1[2]), " of first flag is not a boundary edge."));
        fi;
        if not flag2[2] in BoundaryEdges(surface) then
            Error(Concatenation("JoinBoundaries: Edge ", String(flag2[2]), " of second flag is not a boundary edge."));
        fi;
        if not flag1[1] in VerticesOfEdges(surface)[flag1[2]] then
            Error(Concatenation("JoinBoundaries: First list ", String(flag1), " should be a flag of a vertex and an edge."));
        fi;
        if not flag2[1] in VerticesOfEdges(surface)[flag2[2]] then
            Error(Concatenation("JoinBoundaries: Second list ", String(flag2), " should be a flag of a vertex and an edge."));
        fi;

        perims := PerimeterOfHoles(surface);
        # Each edge can be in only one boundary path
        #TODO could this become another VertexEdgePath-Constructor?
        perim1 := [];
        perim2 := [];
        for p in perims do
            if flag1[2] in EdgesAsList(p) then
                Add(perim1, p);
            fi;
            if flag2[2] in EdgesAsList(p) then
                Add(perim2, p);
            fi;
        od;
        Assert(0, Length(perim1) = 1);
        Assert(0, Length(perim2) = 1);
        perim1 := perim1[1];
        perim2 := perim2[1];

        # We have to reorient the paths correctly
        # TODO this could be a separate method
        Reorient := function( path, vertex, edge )
            local vPos, ePos, i;

            if path[1] = vertex and path[2] = edge then
                return path;
            fi;
            if path[Length(path)] = vertex and path[Length(path)-1] = edge then
                return Reversed(path);
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
                # right direction
                return Concatenation( path{[vPos..Length(path)-1]}, path{[1..vPos]} );
            elif ePos + 1 = vPos then
                # wrong direction
                return Reversed( Concatenation( path{[vPos..Length(path)]}, path{[2..vPos]} ) );
            fi;
            Error("JoinBoundaries: Internal Error");
        end;

        bound1 := VertexEdgePathNC( surface, Reorient( PathAsList(perim1), flag1[1], flag1[2] ) );
        bound2 := VertexEdgePathNC( surface, Reorient( PathAsList(perim2), flag2[1], flag2[2] ) );
        return JoinVertexEdgePathsNC(surface, bound1, bound2);
        #join := JoinVertexEdgePathsNC(surface, bound1, bound2);
        #if join = fail then
        #    return fail;
        #fi;
        # Joining boundaries always produces polygonal surfaces
        #SetIsPolygonalSurface( join[1], true );
        #if HasIsTriangularComplex( surface ) then
        #    SetIsTriangularComplex( join[1], IsTriangularComplex(surface) );
        #fi;
        #return join;
    end
);
RedispatchOnCondition( JoinBoundaries, true, [IsPolygonalComplex, IsList, IsList], [IsPolygonalSurface], 0 );



##
##      End of joining
##
#######################################


#######################################
##
##      Applications
##

InstallMethod( ConnectedFaceSum, "for two polygonal surfaces and two flags",
    [IsPolygonalSurface, IsList, IsPolygonalSurface, IsList],
    function(surface1, flag1, surface2, flag2)
        local rem1, rem2;

        if not flag1 in Flags(surface1) then
            Error(Concatenation("ConnectedFaceSum: The first list ", 
                String(flag1), 
                " is not a flag of the first polygonal surface."));
        fi;
        if not flag2 in Flags(surface2) then
            Error(Concatenation("ConnectedFaceSum: The second list ", 
                String(flag1), 
                " is not a flag of the second polygonal surface."));
        fi;

        if ForAny( EdgesOfFaces(surface1)[flag1[3]], e -> IsBoundaryEdgeNC(surface1, e) ) then
            return fail;
        fi;
        if ForAny( EdgesOfFaces(surface2)[flag2[3]], e -> IsBoundaryEdgeNC(surface2, e) ) then
            return fail;
        fi;

        rem1 := RemoveFaceNC( surface1, flag1[3] );
        rem2 := RemoveFaceNC( surface2, flag2[3] );
        return JoinBoundaries( rem1, flag1{[1,2]}, rem2, flag2{[1,2]} )[1];
    end
);
RedispatchOnCondition( ConnectedFaceSum, true, 
    [IsPolygonalComplex, IsList, IsPolygonalComplex, IsList], 
    [IsPolygonalSurface,,IsPolygonalSurface], 0 );


InstallMethod( SnippOffEars, "for a simplicial surface", [IsSimplicialSurface],
    function(surface)
        local facePairs, commonEdges, snippPairs, joinEdges, remFaces, 
            swapSurf, pair, join;

        facePairs := Combinations(Faces(surface), 2);
        commonEdges := List(facePairs, p -> [p[1],p[2],
            Intersection( EdgesOfFaces(surface)[p[1]], EdgesOfFaces(surface)[p[2]] )]);
        snippPairs := Filtered(commonEdges, c -> Length(c[3]) = 2);

        joinEdges := List( snippPairs, p -> [ 
            Difference(EdgesOfFaces(surface)[p[1]], p[3])[1], 
            Difference(EdgesOfFaces(surface)[p[2]], p[3])[1] ] );

        remFaces := Set( Flat( List( snippPairs, p -> [p[1],p[2]] ) ) );
        swapSurf := RemoveFacesNC(surface, remFaces);

        for pair in joinEdges do
            if IsSubset( Edges(swapSurf), pair ) then
                join := JoinEdgesNC(swapSurf, pair);
                swapSurf := join[1];
            fi;
        od;

        return swapSurf;
    end
);
RedispatchOnCondition( SnippOffEars, true, [IsPolygonalComplex], [IsSimplicialSurface], 0 );

InstallMethod( SplitAllVertices, "for a polygonal complex", 
    [IsPolygonalComplex],
    function(complex)
        local swapComplex, v;

        swapComplex := complex;
        for v in VerticesAttributeOfPolygonalComplex(complex) do
            swapComplex := SplitVertexNC(swapComplex, v)[1];
        od;

        return swapComplex;
    end
);

##
##      End Applications
##
#######################################




#######################################
##
##      Cut/Mend
##

InstallMethod( CraterCuttableEdges, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local innerEdges;

        innerEdges := InnerEdges(complex);
        return Filtered(innerEdges, e -> ForAll( VerticesOfEdges(complex)[e], v -> IsInnerVertexNC(complex, v) ));
    end
);
InstallMethod( CraterCut, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        if not edge in CraterCuttableEdges(complex) then
            Error(Concatenation("CraterCut: The second argument ", 
                String(edge), 
                " is not a crater-cuttable edge of the given polygonal complex." ));
        fi;
        return SplitEdgeNC(complex, edge)[1];
    end
);

InstallMethod( CraterMendableEdgePairs, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local edgeAnom, edgePairs;

        edgeAnom := List( EdgeAnomalyClasses(complex), 
            cl -> Filtered( cl, 
                e -> IsBoundaryEdgeNC(complex, e) and 
                    ForAll( VerticesOfEdges(complex)[e], 
                        v -> IsBoundaryVertexNC(complex, v) ) ) );
        edgePairs := Combinations(edgeAnom, 2);
        return Union(edgePairs);
    end
);
InstallMethod( CraterMend, "for a polygonal complex and a pair of edges",
    [IsPolygonalComplex, IsList],
    function(complex, edgePair)
        if not Set(edgePair) in CraterMendableEdgePairs(complex) then
            Error(Concatenation("CraterMend: The second argument ",
                String(edgePair), 
                " is not a crater-mendable edge pair of the given polygonal complex."));
        fi;
        return JoinEdgesNC(complex, edgePair)[1];
    end
);

InstallMethod( RipCuttableEdges, "for a polygonal complex", 
    [IsPolygonalComplex],
    function(complex)
        local CheckInnerBound;

        CheckInnerBound := function(e)
            local verts;

            verts := VerticesOfEdges(complex)[e];
            return ( IsInnerVertexNC(complex, verts[1]) and 
                        IsBoundaryVertexNC(complex, verts[2]) ) 
                or ( IsInnerVertexNC(complex, verts[2]) and 
                        IsBoundaryVertexNC(complex, verts[1]) );
        end;
        return Filtered(InnerEdges(complex), CheckInnerBound );
    end
);
InstallMethod( RipCut, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        if not edge in RipCuttableEdges(complex) then
            Error(Concatenation("RipCut: Second argument ",
                String(edge), " is not a rip-cuttable edge of the given polygonal complex."));
        fi;
        return SplitVertexEdgePathNC(complex, VertexEdgePathByEdgesNC([edge]));
    end
);

InstallMethod( RipMendableEdgePairs, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local pairs, v, boundEdges, edgePairs;

        pairs := [];
        for v in BoundaryVertices(complex) do
            boundEdges := Filtered( EdgesOfVertices(complex), 
                e -> IsBoundaryEdgeNC(complex, e) );
            edgePairs := Combinations(boundEdges, 2);
            Append(pairs, Filtered(edgePairs, p -> 
                OtherVertexOfEdgeNC(complex,v,p[1]) <> 
                    OtherVertexOfEdgeNC(complex,v,p[2])));
        od;

        return Set(pairs);
    end
);
InstallMethod( RipMend, "for a polygonal complex and a pair of edges",
    [IsPolygonalComplex, IsList],
    function(complex, edgePair)
        local commonVertex, path1, path2, join;

        if not edgePair in RipMendableEdgePairs(complex) then
            Error(Concatenation("RipMend: Second argument ",
                String(edgePair), 
                " is not a rip-mendable edge pair of the given polygonal complex."));
        fi;
        commonVertex := Intersection( 
            VerticesOfEdges(complex, edgePair[1]), 
            VerticesOfEdges(complex, edgePair[2]) )[1];
        path1 := VertexEdgePathNC(complex, [commonVertex, edgePair[1], 
                OtherVertexOfEdgeNC(complex, commonVertex, edgePair[1])]);
        path2 := VertexEdgePathNC(complex, [commonVertex, edgePair[2], 
                OtherVertexOfEdgeNC(complex, commonVertex, edgePair[2])]);

        join := JoinVertexEdgePathsNC(complex, path1, path2)[1];
        if join = fail then
            return fail;
        else
            return join[1];
        fi;
    end
);


InstallMethod( SplitCuttableEdges, "for a polygonal complex", 
    [IsPolygonalComplex],
    function(complex)
        return Filtered(InnerEdges(complex), 
            e -> ForAll(VerticesOfEdges(complex)[e], 
                v -> IsBoundaryVertexNC(complex, v)));
    end
);
InstallMethod( SplitCut, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        if not edge in SplitCuttableEdges(complex) then
            Error(Concatenation("SplitCut: Second argument ", 
                String(edge),
                " is not a split-cuttable edge of the given polygonal complex"));
        fi;
        return SplitVertexEdgePathNC(complex, VertexEdgePathByEdgesNC(complex, [edge]));
    end
);


InstallMethod( SplitMendableFlagPairs, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local boundPairs, flagPairs, verts1, verts2, pair;

        flagPairs := [];
        boundPairs := Combinations( BoundaryEdges(complex), 2 );
        for pair in boundPairs do
            verts1 := VerticesOfEdges(complex)[pair[1]];
            verts2 := VerticesOfEdges(complex)[pair[2]];
            if Length(Intersection(verts1, verts2)) = 0 then
                Append( flagPairs, [ 
                    Set( [ [ verts1[1], pair[1] ], [ verts2[1], pair[2] ] ] ),
                    Set( [ [ verts1[1], pair[1] ], [ verts2[2], pair[2] ] ] ),
                    Set( [ [ verts1[2], pair[1] ], [ verts2[1], pair[2] ] ] ),
                    Set( [ [ verts1[2], pair[1] ], [ verts2[2], pair[2] ] ] )] );
            fi;
        od;

        return Set(flagPairs);
    end
);
InstallMethod( SplitMend, 
    "for a polygonal complex and a pair of vertex-edge-flags",
    [IsPolygonalComplex, IsList],
    function(complex, flagPair)
        local path1, path2, join;

        if not flagPair in SplitMendableFlagPairs(complex) then
            Error(Concatenation("SplitMend: Second argument ", 
                String(flagPair),
                " is not a split-mendable flag pair."));
        fi;

        path1 := VertexEdgePathNC(complex, [ flagPair[1][1], flagPair[1][2],
            OtherVertexOfEdgeNC(complex, flagPair[1][1], flagPair[1][2])]);
        path2 := VertexEdgePathNC(complex, [ flagPair[2][1], flagPair[2][2],
            OtherVertexOfEdgeNC(complex, flagPair[2][1], flagPair[2][2])]);
        join := JoinVertexEdgePathsNC(complex, path1, path2);
        if join = fail then
            return fail;
        else
            return join[1];
        fi;
    end
);


##
##      End of Cut/Mend
##
#######################################


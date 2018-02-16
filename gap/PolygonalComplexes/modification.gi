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
            Error(Concatenation("SplitEdge: Given edge ", edge, 
                " is not one of the edges ", Edges(complex), 
                " of the given polygonal complex." ) );
        fi;
        return SplitEdgeNC(complex, edge);
    end
);
InstallOtherMethod( SplitEdgeNC, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        local nrIncFaces;

        nrIncFaces := Size(FacesOfEdges(complex)[edge]);
        if nrIncFaces = 1 then
            return SplitEdgeNC(complex, edge, [edge]);
        else
            return SplitEdgeNC(complex, edge, 
                List([1..nrIncFaces], i -> Maximum(Edges(complex))+i));
        fi;
    end
);

InstallMethod( SplitEdge, "for a polygonal complex, an edge and a list",
    [IsPolygonalComplex, IsPosInt, IsList],
    function(complex, edge, newEdgeLabels)
        local intersect;

        if not edge in Edges(complex) then
            Error(Concatenation("SplitEdge: Given edge ", edge, 
                " is not one of the edges ", Edges(complex), 
                " of the given polygonal complex." ) );
        fi;

        if ForAny(newEdgeLabels, e -> not IsPosInt(e)) then
            Error(Concatenation(
                "SplitEdge: The new edge labels have to be positive integers, but are ", 
                newEdgeLabels, "."));
        fi;

        if Size( Set(newEdgeLabels) ) <> Size(FacesOfEdges(complex)[edge]) then
            Error(Concatenation(
                "SplitEdge: The number of new edge labels has to be equal to the number of incident faces."
            ));
        fi;

        intersect := Intersection( Edges(complex), newEdgeLabels );
        if Size(intersect) = 0 or (Size(intersect)=1 and intersect[1] = edge) then
            return SplitEdgeNC(complex, edge, newEdgeLabels);
        else
            Error(Concatenation("SplitEdge: The new edge labels ", 
                newEdgeLabels, 
                " have to be disjoint from the existing edge labels ", 
                Edges(complex)));
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
        for i in [1..Size(incFaces)] do
            newFacesOfEdges[newEdgeLabels[i]] := [incFaces[i]];
        od;

        obj := Objectify( PolygonalComplexType, rec() );
        SetVerticesOfEdges(obj, newVertsOfEdges);
        SetFacesOfEdges(obj, newFacesOfEdges);

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
        while Size(faces) > 0 do
            conn := __SIMPLICIAL_AbstractConnectedComponent( 
                faces, edgeOfFaces, faces[1] );
            Add( comp, [ conn, Union(edgeOfFaces{conn}) ] );
            faces := Difference(faces, conn);
        od;

        return comp;
    end
);
InstallOtherMethod( SplitVertex, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        if not vertex in Vertices(complex) then
            Error(Concatenation("SplitVertex: Given vertex ", vertex, 
                " is not one of the vertices ", Vertices(complex), 
                " of the given polygonal complex." ) );
        fi;
        return SplitVertexNC(complex, vertex);
    end
);
InstallOtherMethod( SplitVertexNC, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        local nrIncStars;

        nrIncStars := Size(__SIMPLICIAL_ConnectedStarComponents(complex, vertex));
        if nrIncStars = 1 then
            return SplitVertexNC(complex, vertex, [vertex]);
        else
            return SplitVertexNC(complex, vertex, 
                List([1..nrIncStars], i -> Maximum(Vertices(complex))+i));
        fi;
    end
);

InstallMethod( SplitVertex, "for a polygonal complex, a vertex and a list",
    [IsPolygonalComplex, IsPosInt, IsList],
    function(complex, vertex, newVertexLabels)
        local intersect;

        if not vertex in Vertices(complex) then
            Error(Concatenation("SplitVertex: Given vertex ", vertex, 
                " is not one of the vertices ", Vertices(complex), 
                " of the given polygonal complex." ) );
        fi;

        if ForAny(newVertexLabels, v -> not IsPosInt(v)) then
            Error(Concatenation(
                "SplitVertex: The new vertex labels have to be positive integers, but are ", 
                newVertexLabels, "."));
        fi;

        if Size( Set(newVertexLabels) ) <> Size(__SIMPLICIAL_ConnectedStarComponents(complex, vertex)) then
            Error(Concatenation(
                "SplitVertex: The number of new vertex labels has to be equal to the number of incident stars.TODO"
            ));
        fi;

        intersect := Intersection( Vertices(complex), newVertexLabels );
        if Size(intersect) = 0 or (Size(intersect)=1 and intersect[1] = vertex) then
            return SplitVertexNC(complex, vertex, newVertexLabels);
        else
            Error(Concatenation("SplitVertex: The new vertex labels ", 
                newVertexLabels, 
                " have to be disjoint from the existing vertex labels ", 
                Vertices(complex)));
        fi;
    end
);
InstallMethod( SplitVertexNC, "for a polygonal complex, a vertex and a list",
    [IsPolygonalComplex, IsPosInt, IsList],
    function(complex, vertex, newVertexLabels)
        local newEdgesOfVertices, starComp, i, obj;

        newEdgesOfVertices := ShallowCopy(EdgesOfVertices(complex));
        starComp := __SIMPLICIAL_ConnectedStarComponents(complex, vertex);
        Unbind(newEdgesOfVertices[vertex]);
        for i in [1..Size(newVertexLabels)] do
            newEdgesOfVertices[newVertexLabels[i]] := starComp[i][2];
        od;

        obj := Objectify( PolygonalComplexType, rec() );
        SetEdgesOfVertices(obj, newEdgesOfVertices);
        SetEdgesOfFaces(obj, EdgesOfFaces(complex));
        return [obj, newVertexLabels];
    end
);

## Splitting vertex-edge-paths
BindGlobal( "__SIMPLICIAL_ComputeNewVertexEdgePaths",
    function(oldComplex, vePath, newComplex, labelList)
        local partialPaths, i, newPaths, p, pNew, pOld, newEdge, used, 
            newVertex;

        partialPaths := [ [[],[]] ];
        for i in [1..Size(labelList)] do
            # Try to extend every partial path in as many ways as possible
            if IsEvenInt(i) then
                # We have to add an edge => paths can't start here
                newPaths := [];
                for p in partialPaths do
                    pNew := p[1];
                    pOld := p[2];
                    for newEdge in labelList[i] do
                        if pNew[Size(pNew)] in VerticesOfEdges(newComplex)[newEdge] then
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
                        if Size(pNew) = 0 or pNew[Size(pNew)] in EdgesOfVertices(newComplex)[newVertex] then
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

        return newPaths;
    end
);

InstallMethod( SplitVertexEdgePath, 
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, pathAsList)
        local path;

        path := VertexEdgePath(complex, pathAsList);
        if not IsDuplicateFree(path) then
            Error("SplitVertexEdgePath: Given list of vertices and edges has to represent a duplicate-free vertex-edge-path");
        fi;
        return SplitVertexEdgePathNC(complex, path);
    end
);
InstallMethod( SplitVertexEdgePathNC,
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, pathAsList)
        return SplitVertexEdgePathNC(complex, VertexEdgePath(complex, pathAsList));
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
            vertexSplit;

        newLabelList := [];
        swapComplex := complex;
        # Split the edges
        for i in [1..Size(EdgesAsList(vePath))] do
            edgeSplit := SplitEdge(swapComplex, EdgesAsList(vePath)[i]);
            swapComplex := edgeSplit[1];
            newLabelList[2*i] := edgeSplit[2];
        od;
        # Split the vertices
        for i in [1..Size(VerticesAsList(vePath))] do
            vertexSplit := SplitVertex(swapComplex, VerticesAsList(vePath)[i]);
            swapComplex := vertexSplit[1];
            newLabelList[2*i-1] := vertexSplit[2];
        od;
        newComplex := swapComplex;

        return [newComplex, __SIMPLICIAL_ComputeNewVertexEdgePaths(
                    complex,vePath, newComplex, newLabelList)];
    end
);
RedispatchOnCondition( SplitVertexEdgePathNC, true, 
    [IsPolygonalComplex, IsVertexEdgePath], [,IsDuplicateFree], 0 );


#####



InstallMethod( SplitEdgePath, 
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, pathAsList)
        local path;

        path := VertexEdgePath(complex, pathAsList);
        if not IsDuplicateFree(path) then
            Error("SplitEdgePath: Given list of vertices and edges has to represent a duplicate-free vertex-edge-path");
        fi;
        return SplitEdgePathNC(complex, path);
    end
);
InstallMethod( SplitEdgePathNC,
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, pathAsList)
        return SplitEdgePathNC(complex, VertexEdgePath(complex, pathAsList));
    end
);

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

InstallMethod( SplitEdgePathNC,
    "for a polygonal complex and a duplicate-free vertex-edge-path",
    [IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree],
    function(complex, vePath)
        local newLabelList, swapComplex, newComplex, i, edgeSplit, 
            vertexSplit;

        newLabelList := [];
        swapComplex := complex;
        # Split the edges
        for i in [1..Size(EdgesAsList(vePath))] do
            edgeSplit := SplitEdge(swapComplex, EdgesAsList(vePath)[i]);
            swapComplex := edgeSplit[1];
            newLabelList[2*i] := edgeSplit[2];
        od;
        # Split the vertices
        newLabelList[1] := [VerticesAsList(vePath)[1]];
        for i in [2..Size(VerticesAsList(vePath))-1] do
            vertexSplit := SplitVertex(swapComplex, VerticesAsList(vePath)[i]);
            swapComplex := vertexSplit[1];
            newLabelList[2*i-1] := vertexSplit[2];
        od;
        Add(newLabelList, [VerticesAsList(vePath)[Size(VerticesAsList(vePath))]]);
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

InstallMethod( SubcomplexByFaces, "for a polygonal complex and a set of faces",
    [IsPolygonalComplex, IsSet],
    function(complex, subfaces)
	local subVertices, subEdges, newVerticesOfEdges, newEdgesOfFaces, e, f;

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


	subEdges := Union( List( subfaces, f -> EdgesOfFaces(complex)[f] ));
	subVertices := Union( List( subEdges, e -> VerticesOfEdges(complex)[e] ) );

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



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
RedispatchOnCondition( SplitEdge, true, [IsTwistedPolygonalComplex,IsPosInt], [IsPolygonalComplex], 0 );
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
RedispatchOnCondition( SplitEdgeNC, true, [IsTwistedPolygonalComplex,IsPosInt], [IsPolygonalComplex], 0 );

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
RedispatchOnCondition( SplitEdge, true, [IsTwistedPolygonalComplex,IsPosInt,IsList], [IsPolygonalComplex], 0 );
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

        obj := Objectify( TwistedPolygonalComplexType, rec() );
        SetVerticesOfEdges(obj, newVertsOfEdges);
        SetFacesOfEdges(obj, newFacesOfEdges);
        SetIsPolygonalComplex(obj, true);
        SetIsDefaultChamberSystem(obj, true);
        if HasVerticesOfFaces(complex) then
            SetVerticesOfFaces(obj, VerticesOfFaces(complex));
        fi;
        if HasFacesOfVertices(complex) then
            SetFacesOfVertices(obj, FacesOfVertices(complex));
        fi;
        if HasVerticesAttributeOfComplex(complex) then
            SetVerticesAttributeOfComplex(obj, 
                VerticesAttributeOfComplex(complex));
        fi;
        if HasFaces(complex) then
            SetFaces(obj, Faces(complex));
        fi;
        if HasIsTriangular(complex) then
            SetIsTriangular(obj, IsTriangular(complex));
        fi;

        return [obj, newEdgeLabels];
    end
);
RedispatchOnCondition( SplitEdgeNC, true, [IsTwistedPolygonalComplex,IsPosInt,IsList], [IsPolygonalComplex], 0 );


## Splitting vertices
BindGlobal( "__SIMPLICIAL_ConnectedStarComponents",
    function(complex, vertex)
        local faces, edges, edgeOfFaces, f, comp, conn;

        # Compute some data in advance to avoid attribute scheduling
        VerticesAttributeOfComplex(complex);
        Edges(complex);
        Faces(complex);

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

        obj := Objectify( TwistedPolygonalComplexType, rec() );
        SetEdgesOfVertices(obj, newEdgesOfVertices);
        SetIsPolygonalComplex(obj, true);
        SetIsDefaultChamberSystem(obj, true);

        if HasFacesOfEdges(complex) then
            SetFacesOfEdges(obj, FacesOfEdges(complex));
        else
            SetEdgesOfFaces(obj, EdgesOfFaces(complex));
        fi;
        if HasEdges(complex) then
            SetEdges(obj, Edges(complex));
        fi;
        if HasFaces(complex) then
            SetFaces(obj, Faces(complex));
        fi;
        if HasIsTriangular(complex) then
            SetIsTriangular(obj, IsTriangular(complex));
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
            max := VerticesAttributeOfComplex(complex)[NumberOfVertices(complex)];
            return __SIMPLICIAL_SplitVertexWithStarComponent(complex, vertex, [1..Length(starComp)]+max, starComp);
        fi;
    end
);
InstallOtherMethod( SplitVertex, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        if not vertex in VerticesAttributeOfComplex(complex) then
            Error(Concatenation("SplitVertex: Given vertex ", String(vertex), 
                " is not one of the vertices ", String(Vertices(complex)), 
                " of the given polygonal complex." ) );
        fi;
        return SplitVertexNC(complex, vertex);
    end
);
RedispatchOnCondition( SplitVertex, true, [IsTwistedPolygonalComplex,IsPosInt], [IsPolygonalComplex], 0 );
InstallOtherMethod( SplitVertexNC, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        local nrIncStars, max, starComp;

        starComp := __SIMPLICIAL_ConnectedStarComponents(complex, vertex);
        nrIncStars := Length(starComp);
        if nrIncStars = 1 then
            return __SIMPLICIAL_SplitVertexWithStarComponent(complex, vertex, [vertex], starComp);
        else
            max := VerticesAttributeOfComplex(complex)[ NumberOfVertices(complex) ];
            return __SIMPLICIAL_SplitVertexWithStarComponent(complex, vertex, [1..nrIncStars]+max, starComp);
        fi;
    end
);
RedispatchOnCondition( SplitVertexNC, true, [IsTwistedPolygonalComplex,IsPosInt], [IsPolygonalComplex], 0 );

InstallMethod( SplitVertex, "for a polygonal complex, a vertex and a list",
    [IsPolygonalComplex, IsPosInt, IsList],
    function(complex, vertex, newVertexLabels)
        local intersect, starComp;

        if not vertex in VerticesAttributeOfComplex(complex) then
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
                "SplitVertex: The number of new vertex labels has to be equal to the length of the umbrella partition."
            ));
        fi;

        intersect := Intersection( VerticesAttributeOfComplex(complex), 
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
RedispatchOnCondition( SplitVertex, true, [IsTwistedPolygonalComplex,IsPosInt,IsList], [IsPolygonalComplex], 0 );
InstallMethod( SplitVertexNC, "for a polygonal complex, a vertex and a list",
    [IsPolygonalComplex, IsPosInt, IsList],
    function(complex, vertex, newVertexLabels)
        local starComp;
        
        starComp := __SIMPLICIAL_ConnectedStarComponents(complex, vertex);

        return __SIMPLICIAL_SplitVertexWithStarComponent(complex, vertex, newVertexLabels, starComp);
    end
);
RedispatchOnCondition( SplitVertexNC, true, [IsTwistedPolygonalComplex,IsPosInt,IsList], [IsPolygonalComplex], 0 );

## Splitting vertex-edge-paths
BindGlobal( "__SIMPLICIAL_ComputeNewVertexEdgePaths",
    function(oldComplex, vePath, newComplex, labelList)
        local partialPaths, i, newPaths, p, pNew, pOld, newEdge, used, 
            newVertex, resPaths, extNew, extOld, finishedParts,new;

        VerticesAttributeOfComplex(newComplex); # Compute this once to avoid scheduling
	finishedParts:=[];
	new:=0;

        partialPaths := [ [[],[]] ];
        for i in [1..Length(labelList)] do
            # Try to extend every partial path in as many ways as possible
            if IsEvenInt(i) then
                # We have to add an edge => paths can't start here
                newPaths := [];
                for p in partialPaths do
		    used := false;
                    pNew := p[1];
                    pOld := p[2];
                    for newEdge in labelList[i] do
                        if pNew[Length(pNew)] in VerticesOfEdges(newComplex)[newEdge] then
                            # Extend old and new path
                            extNew := ShallowCopy(pNew);
                            Add(extNew, newEdge);
                            extOld := ShallowCopy(pOld);
                            Add(extOld, PathAsList(vePath)[i]);

                            Add(newPaths, [ extNew, extOld ]);
			
			    used:=true;
                        fi;
                    od;
		    if new>=Position(partialPaths,p) and not used then
			Add(finishedParts,p);
		    fi;
                od;
		new:=0;
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
                            # Extend old and new path
                            extNew := ShallowCopy(pNew);
                            Add(extNew, newVertex);
                            extOld := ShallowCopy(pOld);
                            Add(extOld, PathAsList(vePath)[i]);

                            Add(newPaths, [ extNew, extOld ]);
                            used := true;
                        fi;
                    od;
                    if not used then
			# If there is no way to add the new vertex to the partial paths,
			# a new path will start at the vertex 
			if i>1 then
                             new:=Length(partialPaths);
                        fi;
                        Add(newPaths, 
                            [ [newVertex], [PathAsList(vePath)[i]] ]);
		    fi;
                od;
                partialPaths := newPaths;
            fi;
	    
        od;
	Append(newPaths,finishedParts);

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
    [IsTwistedPolygonalComplex, IsVertexEdgePath], [IsPolygonalComplex,IsDuplicateFree], 0 );

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
            edgeSplit := SplitEdgeNC(swapComplex, EdgesAsList(vePath)[i]);
            swapComplex := edgeSplit[1];
            newLabelList[2*i] := edgeSplit[2];
        od;
        # Split the vertices
        for i in [1..Length(VerticesAsList(vePath))-1] do
            vertexSplit := SplitVertexNC(swapComplex, VerticesAsList(vePath)[i]);
            swapComplex := vertexSplit[1];
            newLabelList[2*i-1] := vertexSplit[2];
        od;
        size := Length(VerticesAsList(vePath));
        if IsClosedPath(vePath) then
            # The last vertex has already be splitted!
            newLabelList[2*size-1] := newLabelList[1];
        else
            vertexSplit := SplitVertexNC(swapComplex, VerticesAsList(vePath)[size]);
            swapComplex := vertexSplit[1];
            newLabelList[2*size-1] := vertexSplit[2];
        fi;
        newComplex := swapComplex;
        return [newComplex, __SIMPLICIAL_ComputeNewVertexEdgePaths(
                    complex,vePath, newComplex, newLabelList)];
    end
);
RedispatchOnCondition( SplitVertexEdgePathNC, true, 
    [IsTwistedPolygonalComplex, IsVertexEdgePath], [IsPolygonalComplex,IsDuplicateFree], 0 );


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
    [IsTwistedPolygonalComplex, IsVertexEdgePath], [IsPolygonalComplex,IsDuplicateFree], 0 );

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
    [IsTwistedPolygonalComplex, IsVertexEdgePath], [IsPolygonalComplex,IsDuplicateFree], 0 );


##
##      End splitting methods
##
#######################################


#######################################
##
##      Face removal
##
InstallMethod( SubcomplexByFaces, "for a twisted polygonal complex and a set of faces",
    [IsTwistedPolygonalComplex, IsSet],
    function(complex, subfaces)
	if not IsSubset( Faces(complex), subfaces ) then
	    Error("SubcomplexByFaces: there are not only faces given.");
	fi;

	return SubcomplexByFacesNC( complex, subfaces );
    end
);
InstallOtherMethod( SubcomplexByFaces, 
    "for a twisted polygonal complex and a list of faces",
    [ IsTwistedPolygonalComplex, IsList ],
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
InstallMethod( SubcomplexByFacesNC, 
    "for a twisted polygonal complex and a set of faces",
    [IsTwistedPolygonalComplex, IsSet],
    function(complex, subfaces)
        local remChambers, vofC, eofC, fofC, c, zeroClass, oneClass,
            twoClass, cl;

        remChambers := Union( ChambersOfFaces(complex){subfaces} );
        vofC := [];
        eofC := [];
        fofC := [];
        for c in remChambers do
            vofC[c] := VerticesOfChambers(complex)[c];
            eofC[c] := EdgesOfChambers(complex)[c];
            fofC[c] := FacesOfChambers(complex)[c];
        od;

        zeroClass := Filtered( ZeroAdjacencyClasses(complex), cl -> IsSubset(remChambers, cl) );
        oneClass := Filtered( OneAdjacencyClasses(complex), cl -> IsSubset(remChambers, cl) );
        twoClass := List( TwoAdjacencyClasses(complex), cl -> Intersection(cl, remChambers) );
        twoClass := Set(twoClass);
        twoClass := Difference(twoClass, [[]]);
        
        return TwistedPolygonalComplexByChamberRelationsNC( vofC, eofC, fofC, zeroClass, oneClass, twoClass );
    end
);
InstallOtherMethod( SubcomplexByFacesNC, 
    "for a twisted polygonal complex and a list of faces",
    [ IsTwistedPolygonalComplex, IsList ],
    function(complex, subfaces)
        return SubcomplexByFacesNC(complex, Set(subfaces));
    end
);

InstallMethod( SubsurfaceByFaces, "for a twisted polygonal surface and a set of faces",
    [IsTwistedPolygonalSurface, IsSet],
    function(complex, subfaces)
        local sub;

        sub := SubcomplexByFaces(complex, subfaces);
        if not IsTwistedPolygonalSurface(sub) then
            return fail;
        fi;

        return sub;
    end
);
InstallOtherMethod( SubsurfaceByFaces, 
    "for a twisted polygonal surface and a list of faces",
    [ IsTwistedPolygonalSurface, IsList ],
    function(complex, subfaces)
        return SubsurfaceByFaces(complex, Set(subfaces));
    end
);
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( SubsurfaceByFaces, true, [IsTwistedPolygonalComplex, IsList], [IsTwistedPolygonalSurface], 0 );
fi;
InstallOtherMethod( SubsurfaceByFacesNC, 
    "for a twisted polygonal surface and a set of faces",
    [ IsTwistedPolygonalSurface, IsSet ],
    function(complex, subfaces)
        local sub;

        sub := SubcomplexByFacesNC(complex, subfaces);
        SetIsNotVertexRamified(sub, true);
        SetIsNotEdgeRamified(sub, true);

        return sub;
    end
);
InstallOtherMethod( SubsurfaceByFacesNC, 
    "for a twisted polygonal surface and a list of faces",
    [ IsTwistedPolygonalSurface, IsList ],
    function(complex, subfaces)
        return SubsurfaceByFacesNC(complex, Set(subfaces));
    end
);
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( SubsurfaceByFacesNC, true, [IsTwistedPolygonalComplex, IsList], [IsTwistedPolygonalSurface], 0 );
fi;



####

InstallMethod( RemoveFaces, "for a twisted polygonal complex and a set of faces",
    [IsTwistedPolygonalComplex, IsSet],
    function(complex, subfaces)
	if not IsSubset( Faces(complex), subfaces ) then
	    Error("RemoveFaces: there are not only faces given.");
	fi;

	return RemoveFacesNC( complex, subfaces );
    end
);
InstallOtherMethod( RemoveFaces, 
    "for a twisted polygonal complex and a list of faces",
    [ IsTwistedPolygonalComplex, IsList ],
    function(complex, subfaces)
        return RemoveFaces(complex, Set(subfaces));
    end
);
InstallMethod( RemoveFacesNC, "for a twisted polygonal complex and a set of faces",
    [IsTwistedPolygonalComplex, IsSet],
    function(complex, subfaces)
        return SubcomplexByFacesNC(complex, Difference(Faces(complex), subfaces));
    end
);
InstallOtherMethod( RemoveFacesNC, 
    "for a twisted polygonal complex and a list of faces",
    [ IsTwistedPolygonalComplex, IsList ],
    function(complex, subfaces)
        return RemoveFacesNC(complex, Set(subfaces));
    end
);

InstallMethod( RemoveFace, "for a twisted polygonal complex and a face",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, face)
        if not face in Faces(complex) then
            Error(Concatenation("RemoveFace: The given face ", String(face), 
                " is not a face of the given complex: ", 
                String(Faces(complex)), ".") );
        fi;
        return RemoveFaceNC(complex, face);
    end
);
InstallMethod( RemoveFaceNC, "for a twisted polygonal complex and a face",
    [IsTwistedPolygonalComplex, IsPosInt],
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
RedispatchOnCondition( DisjointUnion, true, [IsTwistedPolygonalComplex,IsTwistedPolygonalComplex], [IsPolygonalComplex,IsPolygonalComplex], 0 );
InstallMethod(DisjointUnion, "for two polygonal complexes and an integer",
    [IsPolygonalComplex, IsPolygonalComplex, IsInt],
    function(complex1, complex2, shift)
        local realShift, newVerticesOfEdges, newFacesOfEdges, obj, e, 
            newEdges, vMax, eMax, fMax;

        if Length( Intersection(
                    VerticesAttributeOfComplex(complex1), 
                    VerticesAttributeOfComplex(complex2)) ) = 0 and
            Length( Intersection(Edges(complex1), Edges(complex2)) ) = 0 and
            Length( Intersection(Faces(complex1), Faces(complex2)) ) = 0 then
                realShift := 0;
        else
            vMax := VerticesAttributeOfComplex(complex1)[ NumberOfVertices(complex1) ];
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

        obj := Objectify( TwistedPolygonalComplexType, rec() );
        SetVerticesOfEdges(obj, newVerticesOfEdges);
        SetFacesOfEdges(obj, newFacesOfEdges);
        SetEdges(obj, newEdges);
        SetIsPolygonalComplex(obj, true);
        SetIsDefaultChamberSystem(obj, true);

        if HasIsTriangular(complex1) and HasIsTriangular(complex2) then
            SetIsTriangular(obj, IsTriangular(complex1) and IsTriangular(complex2));
        fi;

        if HasIsNotEdgeRamified(complex1) and HasIsNotEdgeRamified(complex2) then
            SetIsNotEdgeRamified(obj, IsNotEdgeRamified(complex1) and IsNotEdgeRamified(complex2));
        fi;

        if HasIsNotVertexRamified(complex1) and HasIsNotVertexRamified(complex2) then
            SetIsNotVertexRamified(obj, IsNotVertexRamified(complex1) and IsNotVertexRamified(complex2));
        fi;

        return [obj, realShift];
    end
);
RedispatchOnCondition( DisjointUnion, true, [IsTwistedPolygonalComplex,IsTwistedPolygonalComplex,IsInt], [IsPolygonalComplex,IsPolygonalComplex], 0 );


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
        if not v1 in VerticesAttributeOfComplex(complex1) then
            Error(Concatenation("JoinVertices: The first vertex ", String(v1), 
                " is not one of the vertices in the first polygonal complex: ", 
                String(Vertices(complex1)), "."));
        fi;
        if not v2 in VerticesAttributeOfComplex(complex2) then
            Error(Concatenation("JoinVertices: The second vertex ", String(v2), 
                " is not one of the vertices in the second polygonal complex: ", 
                String(Vertices(complex2)), "."));
        fi;
        return JoinVerticesNC(complex1,v1,complex2,v2);
    end
);
RedispatchOnCondition( JoinVertices, true, 
    [IsTwistedPolygonalComplex,IsPosInt,IsTwistedPolygonalComplex,IsPosInt], 
    [IsPolygonalComplex,,IsPolygonalComplex], 0 );
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
RedispatchOnCondition( JoinVerticesNC, true, 
    [IsTwistedPolygonalComplex,IsPosInt,IsTwistedPolygonalComplex,IsPosInt], 
    [IsPolygonalComplex,,IsPolygonalComplex], 0 );

InstallOtherMethod( JoinVertices, 
    "for a polygonal complex and a list of two vertices",
    [IsPolygonalComplex, IsList],
    function(complex, vertList)
        local vertSet, label;

        vertSet := Set(vertList);
        if Length(vertSet) = 1 then
            label := vertSet[1];
        else
            label := VerticesAttributeOfComplex(complex)[NumberOfVertices(complex)] + 1;
        fi;
        return JoinVertices(complex, vertSet, label);
    end
);
RedispatchOnCondition( JoinVertices, true, 
    [IsTwistedPolygonalComplex,IsList],
    [IsPolygonalComplex], 0 );
InstallOtherMethod( JoinVerticesNC,
    "for a polygonal complex and a list of two vertices",
    [IsPolygonalComplex, IsList],
    function(complex, vertList)
        local vertSet, label;

        vertSet := Set(vertList);
        if Length(vertSet) = 1 then
            label := vertSet[1];
        else
            label := VerticesAttributeOfComplex(complex)[NumberOfVertices(complex)] + 1;
        fi;
        return JoinVerticesNC(complex, vertSet, label);
    end
);
RedispatchOnCondition( JoinVerticesNC, true, 
    [IsTwistedPolygonalComplex,IsList],
    [IsPolygonalComplex], 0 );

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
        if not IsSubset(VerticesAttributeOfComplex(complex), vertSet) then
            Error(Concatenation("JoinVertices: Given vertex list ", String(vertList),
                " is not a subset of the vertices of the given complex: ",
                String(Vertices(complex)), "."));
        fi;
        if not newVertexLabel in vertSet and 
                newVertexLabel in VerticesAttributeOfComplex(complex) then
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
RedispatchOnCondition( JoinVertices, true, 
    [IsTwistedPolygonalComplex,IsList,IsPosInt],
    [IsPolygonalComplex], 0 );
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
RedispatchOnCondition( JoinVerticesNC, true, 
    [IsTwistedPolygonalComplex,IsList,IsPosInt],
    [IsPolygonalComplex], 0 );

InstallOtherMethod( JoinVertices,
    "for a polygonal complex and two vertices",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, v1, v2)
        local label;

        if v1 = v2 then
            label := v1;
        else
            label := VerticesAttributeOfComplex(complex)[NumberOfVertices(complex)]+1;
        fi;
        return JoinVertices(complex, v1, v2, label);
    end
);
RedispatchOnCondition( JoinVertices, true, 
    [IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
    [IsPolygonalComplex], 0 );
InstallOtherMethod( JoinVerticesNC,
    "for a polygonal complex and two vertices",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, v1, v2)
        local label;

        if v1 = v2 then
            label := v1;
        else
            label := VerticesAttributeOfComplex(complex)[NumberOfVertices(complex)]+1;
        fi;
        return JoinVerticesNC(complex, v1, v2, label);
    end
);
RedispatchOnCondition( JoinVerticesNC, true, 
    [IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
    [IsPolygonalComplex], 0 );

InstallMethod( JoinVertices,
    "for a polygonal complex, two vertices and a new vertex label",
    [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt],
    function(complex, v1, v2, newVertexLabel)
        __SIMPLICIAL_CheckVertex(complex, v1, "JoinVertices");
        __SIMPLICIAL_CheckVertex(complex, v2, "JoinVertices");
        if newVertexLabel <> v1 and newVertexLabel <> v2 and 
                newVertexLabel in VerticesAttributeOfComplex(complex) then
            Error(Concatenation("JoinVertices: Given new vertex label ", 
                String(newVertexLabel), " conflicts with existing vertices: ", 
                String(Vertices(complex)), "."));
        fi;

        return JoinVerticesNC(complex, v1, v2, newVertexLabel);
    end
);
RedispatchOnCondition( JoinVertices, true, 
    [IsTwistedPolygonalComplex,IsPosInt,IsPosInt,IsPosInt],
    [IsPolygonalComplex], 0 );
InstallMethod( JoinVerticesNC,
    "for a polygonal complex, two vertices and a new vertex label",
    [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt],
    function(complex, v1, v2, newVertexLabel)
        local newEdgesOfVertices, newEdges, obj, vSet, verts, edgeOfVert, e;

        if v1 = v2 and v1 = newVertexLabel then
            return [complex, newVertexLabel];
        fi;

        if v1 <> v2 then
            if IsTriangular(complex) then
                # Since we need EdgesOfVertices later, there is no harm in 
                # using it here as well
                edgeOfVert := EdgesOfVertices(complex);
                # Manually check for intersection
                for e in edgeOfVert[v1] do
                    if e in edgeOfVert[v2] then
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

        obj := Objectify(TwistedPolygonalComplexType, rec());
        SetEdgesOfVertices(obj, newEdgesOfVertices);
        SetIsPolygonalComplex(obj, true);
        SetIsDefaultChamberSystem(obj, true);
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
        if HasIsTriangular(complex) then
            SetIsTriangular(obj, IsTriangular(complex));
        fi;

        return [obj, newVertexLabel];
    end
);
RedispatchOnCondition( JoinVerticesNC, true, 
    [IsTwistedPolygonalComplex,IsPosInt,IsPosInt,IsPosInt],
    [IsPolygonalComplex], 0 );



## Edges
InstallOtherMethod( JoinEdges, "for a polygonal complex and two edges",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, e1, e2)
        local label;
		
	if e1 = e2 then
		label := e1;
	else
		label := Last(Edges(complex))+1;
	fi;
        return JoinEdges(complex, e1, e2, label);
    end
);
RedispatchOnCondition( JoinEdges, true, 
    [IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
    [IsPolygonalComplex], 0 );
InstallOtherMethod( JoinEdgesNC, "for a polygonal complex and two edges",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, e1, e2)
        local label;
		
	if e1 = e2 then
		label := e1;
	else
		label := Last(Edges(complex))+1;
	fi;
        return JoinEdgesNC(complex, e1, e2, label);
    end
);
RedispatchOnCondition( JoinEdgesNC, true, 
    [IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
    [IsPolygonalComplex], 0 );

InstallMethod( JoinEdges, 
    "for a polygonal complex, two edges and a new edge label",
    [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt],
    function(complex, e1, e2, newEdgeLabel)
        __SIMPLICIAL_CheckEdge(complex, e1, "JoinEdges");
        __SIMPLICIAL_CheckEdge(complex, e2, "JoinEdges");
        if e1 = e2 and e1 = newEdgeLabel then
            return [complex, newEdgeLabel];
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
RedispatchOnCondition( JoinEdges, true, 
    [IsTwistedPolygonalComplex,IsPosInt,IsPosInt,IsPosInt],
    [IsPolygonalComplex], 0 );
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

        obj := Objectify( TwistedPolygonalComplexType, rec() );
        SetVerticesOfEdges(obj, newVerticesOfEdges);
        SetFacesOfEdges(obj, newFacesOfEdges);
        SetIsPolygonalComplex(obj, true);
        SetIsDefaultChamberSystem(obj, true);
        if HasVerticesOfFaces(complex) then
            SetVerticesOfFaces(obj, VerticesOfFaces(complex));
        fi;
        if HasFacesOfVertices(complex) then
            SetFacesOfVertices(obj, FacesOfVertices(complex));
        fi;
        if HasVerticesAttributeOfComplex(complex) then
            SetVerticesAttributeOfComplex(obj, 
                VerticesAttributeOfComplex(complex));
        fi;
        if HasFaces(complex) then
            SetFaces(obj, Faces(complex));
        fi;
        if HasIsTriangular(complex) then
            SetIsTriangular(obj, IsTriangular(complex));
        fi;
        return [obj, newEdgeLabel];
    end
);
RedispatchOnCondition( JoinEdgesNC, true, 
    [IsTwistedPolygonalComplex,IsPosInt,IsPosInt,IsPosInt],
    [IsPolygonalComplex], 0 );

InstallOtherMethod(JoinEdges,
	"for a polygonal complex and a list",
	[IsPolygonalComplex,IsList],
	function(complex,edgeList)
		local edgeSet, label;
		
		edgeSet := Set(edgeList);
		if Length(edgeSet) = 1 then
			label := edgeSet[1];
		else
			label := Last(Edges(complex))+1;
		fi;
		return JoinEdges(complex,edgeList,label);
	end
);
RedispatchOnCondition( JoinEdges, true, 
    [IsTwistedPolygonalComplex,IsList],
    [IsPolygonalComplex], 0 );

InstallOtherMethod(JoinEdgesNC,
	"for a polygonal complex and a list",
	[IsPolygonalComplex,IsList],
	function(complex,edgeList)
		local edgeSet, label;
		
		edgeSet := Set(edgeList);
		if Length(edgeSet) = 1 then
			label := edgeSet[1];
		else
			label := Last(Edges(complex))+1;
		fi;
		return JoinEdgesNC(complex,edgeList,label);
	end
);
RedispatchOnCondition( JoinEdgesNC, true, 
    [IsTwistedPolygonalComplex,IsList],
    [IsPolygonalComplex], 0 );

InstallMethod(JoinEdges,
	"for a polygonal complex, a list and a new edge label",
	[IsPolygonalComplex,IsList,IsPosInt],
	function(complex,edgeList,newEdgeLabel)
		local edgeSet,newEdge,newComplex,e,res;
		edgeSet := Set(edgeList);
	
		if not IsSubset(Edges(complex), edgeSet) then
			Error(Concatenation("JoinEdges: Given edge list ", 
			String(edgeList)," is not a subset of the edges of the given complex: ",
                	String(Edges(complex)), "."));
		fi;
	
		if not newEdgeLabel in edgeSet and newEdgeLabel in Edges(complex) then
            		Error(Concatenation("JoinEdges: Given new edge label ", 
			String(newEdgeLabel), " conflicts with existing edges: ", 
			String(Edges(complex)), "."));
		fi;
	
		return JoinEdgesNC(complex,edgeList,newEdgeLabel);
		
	end
);
RedispatchOnCondition( JoinEdges, true, 
    [IsTwistedPolygonalComplex,IsList,IsPosInt],
    [IsPolygonalComplex], 0 );

InstallMethod(JoinEdgesNC,
	"for a polygonal complex, a list and a new edge label",
	[IsPolygonalComplex,IsList,IsPosInt],
	function(complex,edgeList,newEdgeLabel)
		local edgeSet,newEdge,newComplex,e,res;
		newEdge:=edgeList[1];
		newComplex:=complex;
		for e in [2..Length(edgeList)-1] do
			res:=JoinEdgesNC(newComplex,newEdge,edgeList[e],newEdge);
			newComplex:=res[1];
		od;
		return JoinEdgesNC(newComplex,newEdge,Last(edgeList),newEdgeLabel);
	end
);
RedispatchOnCondition( JoinEdgesNC, true, 
    [IsTwistedPolygonalComplex,IsList,IsPosInt],
    [IsPolygonalComplex], 0 );

## Faces
InstallOtherMethod( JoinFaces, "for a polygonal complex and two faces",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, F1, F2)
	local label;
		
	if F1 = F2 then
		label := F1;
	else
		label := Last(Faces(complex))+1;
	fi;
        return JoinFaces(complex, F1, F2, label);
    end
);
RedispatchOnCondition( JoinFaces, true, 
    [IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
    [IsPolygonalComplex], 0 );
	
InstallOtherMethod( JoinFacesNC, "for a polygonal complex and two faces",
    [IsPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, F1, F2)
	local label;

        if F1 = F2 then
                label := F1;
        else
                label := Last(Faces(complex))+1;
        fi;
        return JoinFacesNC(complex, F1, F2, label);
    end
);
RedispatchOnCondition( JoinFacesNC, true, 
    [IsTwistedPolygonalComplex,IsPosInt,IsPosInt],
    [IsPolygonalComplex], 0 );

InstallMethod( JoinFaces, 
    "for a polygonal complex, two faces and a new face label",
    [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt],
	function(complex, F1, F2, newFaceLabel)
		__SIMPLICIAL_CheckFace(complex, F1, "JoinFaces");
		__SIMPLICIAL_CheckFace(complex, F2, "JoinFaces");
		if F1 = F2 and F1 = newFaceLabel then
			return [complex, newFaceLabel];
		fi;
		if newFaceLabel <> F1 and newFaceLabel <> F2 and newFaceLabel in Faces(complex) then
			Error(Concatenation("JoinFaces: Given new face label ", 
				String(newFaceLabel), " conflicts with existing faces: ", 
				String(Faces(complex)), "."));
		fi;
		if EdgesOfFaces(complex)[F1] <> EdgesOfFaces(complex)[F2] then
			Error(Concatenation(
				"JoinFaces: The two given faces are incident to different edges, namely ",
				String(EdgesOfFaces(complex)[F1]), " and ",
				String(EdgesOfFaces(complex)[F2]), "."));
		fi;

		return JoinFacesNC(complex, F1, F2, newFaceLabel);
	end
);
RedispatchOnCondition( JoinFaces, true, 
    [IsTwistedPolygonalComplex,IsPosInt,IsPosInt,IsPosInt],
    [IsPolygonalComplex], 0 );

InstallMethod( JoinFacesNC,
    "for a polygonal complex, two faces and a new face label",
    [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt],
	function(complex, F1, F2, newFaceLabel)
		local newEdgesOfFaces, newVerticesOfFaces, verts, edges, obj;
		newVerticesOfFaces:=ShallowCopy(VerticesOfFaces(complex));
		newEdgesOfFaces:=ShallowCopy(EdgesOfFaces(complex));
		
		verts:=newVerticesOfFaces[F1];
		Unbind(newVerticesOfFaces[F1]);
		Unbind(newVerticesOfFaces[F2]);
		newVerticesOfFaces[newFaceLabel] := verts;
		
		edges := __SIMPLICIAL_UnionSets( newEdgesOfFaces{[F1,F2]} );
		Unbind(newEdgesOfFaces[F1]);
		Unbind(newEdgesOfFaces[F2]);
		newEdgesOfFaces[newFaceLabel] := edges;
		
		obj := Objectify( TwistedPolygonalComplexType, rec() );
		SetVerticesOfFaces(obj, newVerticesOfFaces);
		SetEdgesOfFaces(obj, newEdgesOfFaces);
		SetIsPolygonalComplex(obj, true);
		SetIsDefaultChamberSystem(obj, true);
		if HasVerticesOfEdges(complex) then
			SetVerticesOfEdges(obj, VerticesOfEdges(complex));
		fi;
		if HasVerticesAttributeOfComplex(complex) then
			SetVerticesAttributeOfComplex(obj, 
				VerticesAttributeOfComplex(complex));
		fi;
		if HasEdges(complex) then
			SetEdges(obj, Edges(complex));
		fi;
		if HasIsTriangular(complex) then
			SetIsTriangular(obj, IsTriangular(complex));
		fi;
		return [obj, newFaceLabel];
	end
);
RedispatchOnCondition( JoinFacesNC, true, 
    [IsTwistedPolygonalComplex,IsPosInt,IsPosInt,IsPosInt],
    [IsPolygonalComplex], 0 );

InstallOtherMethod(JoinFaces,
	"for a polygonal complex and a list",
	[IsPolygonalComplex,IsList],
	function(complex,faceList)
		local faceSet, label;
		
		faceSet := Set(faceList);
		if Length(faceSet) = 1 then
			label := faceSet[1];
		else
			label := Last(Faces(complex))+1;
		fi;
		return JoinFaces(complex,faceList,label);
	end
);
RedispatchOnCondition( JoinFaces, true, 
    [IsTwistedPolygonalComplex,IsList],
    [IsPolygonalComplex], 0 );

InstallOtherMethod(JoinFacesNC,
	"for a polygonal complex and a list",
	[IsPolygonalComplex,IsList],
	function(complex,faceList)
		local faceSet, label;

                faceSet := Set(faceList);
                if Length(faceSet) = 1 then
                        label := faceSet[1];
                else
                        label := Last(Faces(complex))+1;
                fi;
                return JoinFacesNC(complex,faceList,label);
	end
);
RedispatchOnCondition( JoinFacesNC, true, 
    [IsTwistedPolygonalComplex,IsList],
    [IsPolygonalComplex], 0 );

InstallMethod(JoinFaces,
	"for a polygonal complex, a list and a new face label",
	[IsPolygonalComplex,IsList,IsPosInt],
	function(complex,faceList,newFaceLabel)
		local faceSet;
		faceSet := Set(faceList);
	
		if not IsSubset(Faces(complex), faceSet) then
			Error(Concatenation("JoinFaces: Given face list ", 
			String(faceList)," is not a subset of the faces of the given complex: ",
                	String(Faces(complex)), "."));
		fi;
	
		if not newFaceLabel in faceSet and newFaceLabel in Faces(complex) then
            		Error(Concatenation("JoinFaces: Given new face label ", 
			String(newFaceLabel), " conflicts with existing faces: ", 
			String(Faces(complex)), "."));
		fi;
	
		return JoinFacesNC(complex,faceList,newFaceLabel);
		
	end
);
RedispatchOnCondition( JoinFaces, true, 
    [IsTwistedPolygonalComplex,IsList,IsPosInt],
    [IsPolygonalComplex], 0 );

InstallMethod(JoinFacesNC,
	"for a polygonal complex, a list and a new face label",
	[IsPolygonalComplex,IsList,IsPosInt],
	function(complex,faceList,newFaceLabel)
		local faceSet,newFace,newComplex,F,res;
		newFace:=faceList[1];
		newComplex:=complex;
		for F in [2..Length(faceList)-1] do
			res:=JoinFacesNC(newComplex,newFace,faceList[F],newFace);
			newComplex:=res[1];
		od;
		return JoinFacesNC(newComplex,newFace,Last(faceList),newFaceLabel);
	end
);
RedispatchOnCondition( JoinFacesNC, true, 
    [IsTwistedPolygonalComplex,IsList,IsPosInt],
    [IsPolygonalComplex], 0 );

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
    [IsTwistedPolygonalComplex, IsVertexEdgePath, IsTwistedPolygonalComplex, IsVertexEdgePath],
    [IsPolygonalComplex,IsDuplicateFree,IsPolygonalComplex,IsDuplicateFree], 0);

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
    [IsTwistedPolygonalComplex, IsVertexEdgePath, IsTwistedPolygonalComplex, IsVertexEdgePath],
    [IsPolygonalComplex,IsDuplicateFree,IsPolygonalComplex,IsDuplicateFree], 0);

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
    [IsTwistedPolygonalComplex, IsVertexEdgePath, IsVertexEdgePath],
    [IsPolygonalComplex,IsDuplicateFree,IsDuplicateFree], 0);

InstallMethod( JoinVertexEdgePathsNC, 
    "for a polygonal complexes and two duplicate-free vertex-edge-paths",
    [IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree, 
        IsVertexEdgePath and IsDuplicateFree],
    function(complex, vePath1, vePath2)
        local swapComplex, labelList, i, join, v1, v2, size, maxEdge, maxVert;

        swapComplex := complex;
        labelList := [];

        # Identify vertices
        maxVert := VerticesAttributeOfComplex(swapComplex)[NumberOfVertices(swapComplex)];
        for i in [1..Length(VerticesAsList(vePath1))-1] do;
            v1 := VerticesAsList(vePath1)[i];
            v2 := VerticesAsList(vePath2)[i];
            if v1 = v2 then
                # no change
                labelList[2*i-1] := v1;
            else
                # this will possibly skip some labels
                join := JoinVerticesNC( swapComplex, v1, v2, maxVert+i );
                if join = fail then
                    return fail;
                fi;
                labelList[2*i-1] := join[2];
                swapComplex := join[1];
            fi;
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

        if v1 = v2 then
            labelList[2*size-1] := v1;
        else
            join := JoinVerticesNC( swapComplex, v1, v2, maxVert+size );
            if join = fail then
                return fail;
            fi;
            labelList[2*size-1] := join[2];
            swapComplex := join[1];
        fi;


        # Identify edges
        maxEdge := Edges(swapComplex)[NumberOfEdges(swapComplex)];
        for i in [1..Length(EdgesAsList(vePath1))] do
            join := JoinEdgesNC( swapComplex, EdgesAsList(vePath1)[i], EdgesAsList(vePath2)[i], maxEdge+i );
            labelList[2*i] := join[2];
            Assert(1, maxEdge + i = join[2]);
            swapComplex := join[1];
        od;

        return [swapComplex, VertexEdgePathNC(swapComplex, labelList)];
    end
);
RedispatchOnCondition( JoinVertexEdgePathsNC, true, 
    [IsTwistedPolygonalComplex, IsVertexEdgePath, IsVertexEdgePath],
    [IsPolygonalComplex,IsDuplicateFree,IsDuplicateFree], 0);


## Boundaries
InstallOtherMethod(JoinBoundaries,
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
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( JoinBoundaries, true, 
        [IsTwistedPolygonalComplex, IsList, IsTwistedPolygonalComplex, IsList], 
        [IsPolygonalSurface,,IsPolygonalSurface], 0 );
fi;


InstallOtherMethod(JoinBoundariesNC,
    "for two polygonal surfaces and two 2-flags",
    [IsPolygonalSurface, IsList, IsPolygonalSurface, IsList],
    function(surface1, flag1, surface2, flag2)
        local disjoint, join;

        disjoint := DisjointUnion(surface1, surface2);
        join := JoinBoundariesNC( disjoint[1], flag1, flag2 + disjoint[2] );
        if join = fail then
            return fail;
        fi;
        Add(join, disjoint[2]);
        return join;
    end
);
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( JoinBoundariesNC, true,
        [IsTwistedPolygonalComplex, IsList, IsTwistedPolygonalComplex, IsList],
        [IsPolygonalSurface,,IsPolygonalSurface], 0 );
fi;

InstallMethod(JoinBoundaries,
    "for two polygonal surfaces, two 2-flags and an integer",
    [IsPolygonalSurface, IsList, IsPolygonalSurface, IsList, IsInt],
    function(surface1, flag1, surface2, flag2, length)
        local disjoint, join;

        disjoint := DisjointUnion(surface1, surface2);
        join := JoinBoundaries( disjoint[1], flag1, flag2 + disjoint[2], length);
        if join = fail then
            return fail;
        fi;
        Add(join, disjoint[2]);
        return join;
    end
);
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( JoinBoundaries, true,
        [IsTwistedPolygonalComplex, IsList, IsTwistedPolygonalComplex, IsList, IsInt],
        [IsPolygonalSurface,,IsPolygonalSurface], 0 );
fi;

InstallMethod(JoinBoundariesNC,
    "for two polygonal surfaces, two 2-flags and an integer",
    [IsPolygonalSurface, IsList, IsPolygonalSurface, IsList, IsInt],
    function(surface1, flag1, surface2, flag2, length)
        local disjoint, join;

        disjoint := DisjointUnion(surface1, surface2);
        join := JoinBoundariesNC( disjoint[1], flag1, flag2 + disjoint[2], length);
        if join = fail then
            return fail;
        fi;
        Add(join, disjoint[2]);
        return join;
    end
);
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( JoinBoundariesNC, true,
        [IsTwistedPolygonalComplex, IsList, IsTwistedPolygonalComplex, IsList, IsInt],
        [IsPolygonalSurface,,IsPolygonalSurface], 0 );
fi;


InstallMethod(JoinBoundaries,
    "for a polygonal surface, two 2-flags and an integer",
    [IsPolygonalSurface, IsList, IsList, IsInt],
    function(surface, flag1, flag2, length)
        local perims, perim1, perim2, bound1, bound2, Reorient, p, join, i;

        if Length(flag1) < 2 then
            Error(Concatenation("JoinBoundaries: First 2-flag should contain two elements, but actually has ", String(Length(flag1)),"."));
        fi;
        if Length(flag2) < 2 then
            Error(Concatenation("JoinBoundaries: Second 2-flag should contain two elements, but actually has ", String(Length(flag2)),"."));
        fi;
        if not flag1[2] in BoundaryEdges(surface) then
            Error(Concatenation("JoinBoundaries: Edge ", String(flag1[2]), " of first flag is not a boundary edge."));
        fi;
        if not flag2[2] in BoundaryEdges(surface) then
            Error(Concatenation("JoinBoundaries: Edge ", String(flag2[2]), " of second flag is not a boundary edge."));
        fi;
        if not flag1[1] in BoundaryVertices(surface) then
            Error(Concatenation("JoinBoundaries: Vertex ", String(flag1[1]), " of first flag is not a boundary vertex."));
        fi;
        if not flag2[1] in BoundaryVertices(surface) then
            Error(Concatenation("JoinBoundaries: Vertex ", String(flag2[1]), " of second flag is not a boundary vertex."));
        fi;
        if not flag1[1] in VerticesOfEdges(surface)[flag1[2]] then
            Error(Concatenation("JoinBoundaries: First list ", String(flag1), " should be a flag of a vertex and an edge."));
        fi;
        if not flag2[1] in VerticesOfEdges(surface)[flag2[2]] then
            Error(Concatenation("JoinBoundaries: Second list ", String(flag2), " should be a flag of a vertex and an edge."));
        fi;

        return JoinBoundariesNC(surface, flag1, flag2, length);
    end
);
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( JoinBoundaries, true,
        [IsTwistedPolygonalComplex, IsList, IsList, IsInt], [IsPolygonalSurface], 0 );
fi;
	
InstallMethod(JoinBoundariesNC,
    "for a polygonal surface, two 2-flags and an integer",
    [IsPolygonalSurface, IsList, IsList, IsInt],
    function(surface, flag1, flag2, length)
        local perim1, perim2, bound1, bound2, Reorient, p, join, i;

        perim1 := PerimeterOfHoles(surface,flag1[2]);
        perim2 := PerimeterOfHoles(surface,flag2[2]);
        
	perim1:=ShiftCyclicPath(perim1,flag1[1],flag1[2]);
        perim2:=ShiftCyclicPath(perim2, flag2[1], flag2[2]);
 
	perim1:=ShallowCopy(EdgesAsList(perim1));
        perim2:=ShallowCopy(EdgesAsList(perim2));
                
        if length<Length(perim1) or length<Length(perim2) then
        	Error("JoinBoundaries: length has to be smaller then the boundary");
        fi;
          
        for i in [length+1..Length(perim1)] do
                Remove(perim1);
        od;

	for i in [length+1..Length(perim2)] do
                Remove(perim2);
        od;


        bound1:=VertexEdgePathByEdgesNC(surface,perim1);
        bound2:=VertexEdgePathByEdgesNC(surface,perim2);

        join := JoinVertexEdgePathsNC(surface, bound1, bound2);
        if join = fail then
            return fail;
        fi;

        # Joining boundaries always produces polygonal surfaces
        SetIsNotEdgeRamified( join[1], true );
        SetIsNotVertexRamified( join[1], true );
        if HasIsTriangular( surface ) then
            SetIsTriangular( join[1], IsTriangular(surface) );
        fi;
        return join;
    end
);
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( JoinBoundariesNC, true,
        [IsTwistedPolygonalComplex, IsList, IsList, IsInt], [IsPolygonalSurface], 0 );
fi;

InstallOtherMethod(JoinBoundaries,
    "for a polygonal surface and two 2-flags",
    [IsPolygonalSurface, IsList, IsList],
    function(surface, flag1, flag2)
	local perims, perim, p;
	perims := PerimeterOfHoles(surface);
        perim := [];
        for p in perims do
          	if flag1[2] in EdgesAsList(p) then
                	Add(perim, p);
            	fi;
        od;
        Assert(0, Length(perim) = 1);
	return JoinBoundaries(surface,flag1,flag2,Length(EdgesAsList(perim[1])));
    end
);
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( JoinBoundaries, true, 
        [IsTwistedPolygonalComplex, IsList, IsList], [IsPolygonalSurface], 0 );
fi;

InstallOtherMethod(JoinBoundariesNC,
    "for a polygonal surface and two 2-flags",
    [IsPolygonalSurface, IsList, IsList],
    function(surface, flag1, flag2)
        local perims, perim, p;
        perims := PerimeterOfHoles(surface);
        perim := [];
        for p in perims do
                if flag1[2] in EdgesAsList(p) then
                        Add(perim, p);
                fi;
        od;
        Assert(0, Length(perim) = 1);
        return JoinBoundariesNC(surface,flag1,flag2,Length(EdgesAsList(perim[1])));
    end
);
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( JoinBoundariesNC, true,
        [IsTwistedPolygonalComplex, IsList, IsList], [IsPolygonalSurface], 0 );
fi;

InstallMethod(JoinBoundary, "for a polygonal surface and a vertex", [IsPolygonalSurface, IsPosInt],
	function(complex, vertex)
		local path, boundaryPath, path1, path2,n;
		if not IsBoundaryVertex(complex,vertex) then
			Error(Concatenation("JoinBoundary: Vertex ", String(vertex), " is not a boundary vertex."));
		fi;
		for path in PerimeterOfHoles(complex) do
			if vertex in VerticesAsList(path) then
				boundaryPath:=EdgesAsList(path);
			fi;
		od;
		n:=Length(boundaryPath);
		if IsOddInt(n) then
			Error(Concatenation("JoinBoundary: The boundary path with edges ", String(boundaryPath), " has not even length."));
		fi;
		return JoinBoundaryNC(complex, vertex);
end);
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( JoinBoundary, true,
        [IsTwistedPolygonalComplex, IsList, IsList], [IsPolygonalSurface], 0 );
fi;

InstallMethod(JoinBoundaryNC, "for a polygonal surface and a vertex", [IsPolygonalSurface, IsPosInt],
	function(complex, vertex)
		local path, boundaryPath, path1, path2, n;
		for path in PerimeterOfHoles(complex) do
			if vertex in VerticesAsList(path) then
				boundaryPath:=EdgesAsList(path);
			fi;
		od;
		n:=Length(boundaryPath);
		path1:=VertexEdgePathByEdges(complex,boundaryPath{[1..n/2]});
		path2:=VertexEdgePathByEdges(complex,Reversed(boundaryPath{[n/2+1..n]}));
		return JoinVertexEdgePaths(complex,path1,path2);
end);
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( JoinBoundaryNC, true,
        [IsTwistedPolygonalComplex, IsList, IsList], [IsPolygonalSurface], 0 );
fi;
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
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( ConnectedFaceSum, true, 
        [IsTwistedPolygonalComplex, IsList, IsTwistedPolygonalComplex, IsList], 
        [IsPolygonalSurface,,IsPolygonalSurface], 0 );
fi;


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
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( SnippOffEars, true, [IsTwistedPolygonalComplex], [IsSimplicialSurface], 0 );
else
    # This redispatch will not check whether we have a surface
    RedispatchOnCondition( SnippOffEars, true, [IsTwistedPolygonalComplex], [IsTriangularComplex], 0 );
fi;

InstallMethod( SplitAllVertices, "for a polygonal complex", 
    [IsPolygonalComplex],
    function(complex)
        local swapComplex, v;

        swapComplex := complex;
        for v in VerticesAttributeOfComplex(complex) do
            swapComplex := SplitVertexNC(swapComplex, v)[1];
        od;

        return swapComplex;
    end
);
RedispatchOnCondition( SplitAllVertices, true, [IsTwistedPolygonalComplex], [IsPolygonalComplex], 0 );

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
        return EdgesWithVertexProperty(complex, v -> IsInnerVertexNC(complex, v));
    end
);
RedispatchOnCondition( CraterCuttableEdges, true, [IsTwistedPolygonalComplex], [IsPolygonalComplex], 0 );
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
RedispatchOnCondition( CraterCut, true, [IsTwistedPolygonalComplex,IsPosInt], [IsPolygonalComplex], 0 );

InstallMethod( CraterMendableEdgePairs, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local edgeAnom, edgePairs;

        edgeAnom := List( EdgeAnomalyClasses(complex), 
		cl -> Filtered( cl, e -> IsBoundaryEdgeNC(complex, e)));
 	edgePairs:=List(edgeAnom,cl->Combinations(cl, 2));
        return Union(edgePairs);
    end
);
RedispatchOnCondition( CraterMendableEdgePairs, true, [IsTwistedPolygonalComplex], [IsPolygonalComplex], 0 );
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
RedispatchOnCondition( CraterMend, true, [IsTwistedPolygonalComplex,IsList], [IsPolygonalComplex], 0 );

InstallMethod( RipCuttableEdges, "for a polygonal complex", 
    [IsPolygonalComplex],
    function(complex)
        return EdgesWithVertexProperties(complex,v->IsInnerVertexNC(complex,v), v->IsBoundaryVertexNC(complex,v));
    end
);
RedispatchOnCondition( RipCuttableEdges, true, [IsTwistedPolygonalComplex], [IsPolygonalComplex], 0 );
InstallMethod( RipCut, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        if not edge in RipCuttableEdges(complex) then
            Error(Concatenation("RipCut: Second argument ",
                String(edge), " is not a rip-cuttable edge of the given polygonal complex."));
        fi;
        return SplitVertexEdgePathNC(complex, VertexEdgePathByEdgesNC(complex, [edge]))[1];
    end
);
RedispatchOnCondition( RipCut, true, [IsTwistedPolygonalComplex,IsPosInt], [IsPolygonalComplex], 0 );

InstallMethod( RipMendableEdgePairs, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local pairs, v, boundEdges, edgePairs;

        pairs := [];
        for v in BoundaryVertices(complex) do
            boundEdges := Filtered( EdgesOfVertices(complex)[v], 
                e -> IsBoundaryEdgeNC(complex, e) );
            edgePairs := Combinations(boundEdges, 2);
            Append(pairs, Filtered(edgePairs, p -> 
                OtherVertexOfEdgeNC(complex,v,p[1]) <> 
                    OtherVertexOfEdgeNC(complex,v,p[2])));
        od;

        return Set(pairs);
    end
);
RedispatchOnCondition( RipMendableEdgePairs, true, [IsTwistedPolygonalComplex], [IsPolygonalComplex], 0 );
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
            VerticesOfEdge(complex, edgePair[1]), 
            VerticesOfEdge(complex, edgePair[2]) )[1];
        path1 := VertexEdgePathNC(complex, [commonVertex, edgePair[1], 
                OtherVertexOfEdgeNC(complex, commonVertex, edgePair[1])]);
        path2 := VertexEdgePathNC(complex, [commonVertex, edgePair[2], 
                OtherVertexOfEdgeNC(complex, commonVertex, edgePair[2])]);

        join := JoinVertexEdgePathsNC(complex, path1, path2);
        if join = fail then
            return fail;
        else
            return join[1];
        fi;
    end
);
RedispatchOnCondition( RipMend, true, [IsTwistedPolygonalComplex,IsList], [IsPolygonalComplex], 0 );


InstallMethod( SplitCuttableEdges, "for a polygonal complex", 
    [IsPolygonalComplex],
    function(complex)
        return Intersection(InnerEdges(complex), EdgesWithVertexProperty(complex, v -> IsBoundaryVertexNC(complex, v)));
    end
);
RedispatchOnCondition( SplitCuttableEdges, true, [IsTwistedPolygonalComplex], [IsPolygonalComplex], 0 );
InstallMethod( SplitCut, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        if not edge in SplitCuttableEdges(complex) then
            Error(Concatenation("SplitCut: Second argument ", 
                String(edge),
                " is not a split-cuttable edge of the given polygonal complex"));
        fi;
        return SplitVertexEdgePathNC(complex, VertexEdgePathByEdgesNC(complex, [edge]))[1];
    end
);
RedispatchOnCondition( SplitCut, true, [IsTwistedPolygonalComplex,IsPosInt], [IsPolygonalComplex], 0 );


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
RedispatchOnCondition( SplitMendableFlagPairs, true, [IsTwistedPolygonalComplex], [IsPolygonalComplex], 0 );
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
RedispatchOnCondition( SplitMend, true, [IsTwistedPolygonalComplex,IsList], [IsPolygonalComplex], 0 );


##
##      End of Cut/Mend
##
#######################################



#######################################
##
##      TetrahedralExtension
##
InstallOtherMethod(TetrahedralExtension, 
    "for a simplicial surface and a face",
    [IsSimplicialSurface,IsPosInt],
    function(surface,face)
        return TetrahedralExtension(surface,face,Maximum(Vertices(surface))+1);
    end
);

InstallMethod( TetrahedralExtension,
    "for a simplicial surface and a face",
    [IsSimplicialSurface, IsPosInt,IsPosInt],
    function(surface, face, vertex)
	local voe,eof,nE,nV,g,L,M,VOE,EOF,edges,e,vof,rem;
	rem:=function(L,g)
	    local temp,i;
	    temp:=[];
	    for i in Difference([1..Length(L)],[g]) do
		if IsBound(L[i]) then
			temp[i]:=L[i];
		fi;
	    od;
	    return temp;
	end;
	VOE:=ShallowCopy(VerticesOfEdges(surface));
	EOF:=ShallowCopy(EdgesOfFaces(surface));
	nE:=Length(VOE);

	nV:=vertex-1;
	vof:=VerticesOfFace(surface,face);
	Add(VOE,[vof[1],nV+1]);
        Add(VOE,[vof[2],nV+1]);
        Add(VOE,[vof[3],nV+1]);
	eof:=EOF[face];
	for e in eof do 
		voe:=VerticesOfEdge(surface,e);
		edges:=Filtered([nE+1,nE+2,nE+3],g->
		Intersection(VOE[g],VerticesOfEdge(surface,e))<>[]);
		Add(EOF,[e,edges[1],edges[2]]);
	od;
        EOF:=rem(EOF,face);
	return SimplicialSurfaceByDownwardIncidence(VOE,EOF);
end
);

InstallMethod( TetrahedralReduction,
    "for a simplicial surface and a vertex",
    [IsSimplicialSurface, IsPosInt],
    function(surface, vertex)
	local f,eof,voe,i,L,ind,faces,remElm,edges,verts,g;
	remElm:=function(L,ind)
		local i,res;
		res:=[];
		for i in [1..Length(L)] do
			if IsBound(L[i]) and i <> ind then 
				res[i]:=L[i];
			fi;
		od; 
		return res;
	end;

	eof:=ShallowCopy(EdgesOfFaces(surface));
	voe:=ShallowCopy(VerticesOfEdges(surface));
	faces:=FacesOfVertex(surface,vertex);
	## remove faces and replace the resulting 3-waist with a face
	if Length(faces)=3 and IsInnerVertex(surface,vertex) then
		for f in faces do
			eof:=remElm(eof,f);
		od;
                verts:=Union(VerticesOfFace(surface,faces[1]),VerticesOfFace(surface,faces[2]));
                verts:=Difference(verts,[vertex]);
		edges:=[];
		for i in [1,2,3] do
			edges[i]:=Filtered(EdgesOfFace(surface,faces[i]),
				g->VerticesOfEdge(surface,g) in Combinations(verts,2))[1];
		od;
                eof[Maximum(Faces(surface))+1]:=Set(edges);
		for g in EdgesOfVertex(surface,vertex) do
			voe:=remElm(voe,g);
		od;
	else
		return fail;
	fi;
	
	return SimplicialSurfaceByDownwardIncidence(voe,eof);
end
);

InstallMethod( InnerMultiTetrahedralSphere, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        local v,vert,comp;
	comp:=complex;
        vert:=Filtered(Vertices(comp),v->FaceDegreeOfVertex(comp,v)=3);
        if IsMultiTetrahedralSphere(comp) then
                if not CounterList(CounterOfVertices(comp)) in [[[3,4]],[[3,2],[4,3]]] then
                        for v in vert do
                               comp:=TetrahedralReduction(comp,v);
                        od;
                fi;
		return comp;
	else
	        return fail;
	fi;
end
);

BindGlobal("__SIMPLICIAL_helpNameFacesAndVertices",
    function(surf,idFOT,idVOT)
	local idf,f,temp,newV,oldF,vertexIDs,faceIDs,idOfOldFace,idOfnewV,
	newFaceIDs,idOfNeighVert,newVertIDs;
## idFOT is list [t1,t2,t3,...] where ti is a tetrahedron represented by
## the list. [[id1,f1],[id2,f2],[id3,f3],[id4,f4]] so that idj=1,2,3,4 is the
## identification of face fj of surf idVOT is list [t1,t2,t3,...] where ti is
## a tetrahedron represented by the list [[id1,v1],[id2,v2],[id3,v3],[id4,v4]]
## so that idj=1,2,3,4 is the identification of vertex vj of surf
	temp:=List(Union(idVOT),tup->tup[2]); 
	newV:=Difference(Vertices(surf),temp)[1];
	temp:=List(Union(idFOT),tup->tup[2]);
	oldF:=Difference(temp,Faces(surf))[1];

	vertexIDs:=Union(idVOT);
	faceIDs:=Union(idFOT);
	idOfNeighVert:=Filtered(vertexIDs,id->id[2] in NeighbourVerticesOfVertex(surf,newV));
	idOfOldFace:=Filtered(faceIDs,id->id[2]=oldF)[1];
	idOfnewV:=[idOfOldFace[1],newV];
	newVertIDs:=Union([idOfnewV],idOfNeighVert);
	Add(idVOT,Union([idOfnewV],newVertIDs));

	newFaceIDs:=[];
	for f in FacesOfVertex(surf,newV) do
	    idf:=Filtered(newVertIDs,id->not id[2] in VerticesOfFace(surf,f))[1][1];
	    Add(newFaceIDs,[idf,f]);
	od;
	Add(idFOT,Union(newFaceIDs,[idOfOldFace]));
	return [idFOT,idVOT];
    end
);

InstallMethod( MultiTetrahedralSphereByTetrahedralSymbol, 
    "for a dense list",
    [IsDenseList],
    function(symbol)
	local idenFaces,idenVertices,temp,tup,face,surf;

	surf:=SimplicialSurfaceByVerticesInFaces([[2,3,4],[1,3,4],
						[1,2,4],[1,2,3]]);
	idenVertices:=[[[1,1],[2,2],[3,3],[4,4]]];
	idenFaces:=[[[1,1],[2,2],[3,3],[4,4]]];

	for tup in symbol do
		face:=idenFaces[tup[1]][tup[2]][2];
		surf:=TetrahedralExtension(surf,face);
		temp:=__SIMPLICIAL_helpNameFacesAndVertices(surf,idenFaces,idenVertices);
		idenFaces:=temp[1];
		idenVertices:=temp[2];
	od;
	return surf;
    end
);


InstallMethod( MultiTetrahedralSymbolOfComplex,
    "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
	local helpNextVertex,v,i,f,symbol,temp,idenVertices,idenFaces,surf,vertices,neigh;

	## surf is the bigger surface and vert the remaining vertices which are not yet
	##identified
	helpNextVertex:=function(surf,visitedVert)
		local neighbours,v;
		for v in Difference(Vertices(surf),visitedVert) do
			neighbours:=NeighbourVerticesOfVertex(surf,v);
			neighbours:=Intersection(neighbours,visitedVert);
			if Length(neighbours)=3 then 
				return [v,neighbours];
			fi;
		od;
		return fail;
	end;
	if IsMultiTetrahedralSphere(complex) then 
		symbol:=[];
		v:=Position(FaceDegreesOfVertices(complex),3);
		neigh:=NeighbourVerticesOfVertex(complex,v);
		vertices:=[v,neigh[1],neigh[2],neigh[3]];
		surf:=SimplicialSurfaceByVerticesInFaces([[v,neigh[1],neigh[2]],
							  [v,neigh[1],neigh[3]],
							  [v,neigh[2],neigh[3]],
							  [neigh[1],neigh[2],neigh[3]]]);
		idenVertices:=[[[1,vertices[4]],[2,vertices[3]],[3,vertices[2]],[4,vertices[1]]]];

		idenFaces:=[[[1,1],[2,2],[3,3],[4,4]]];
	## construct the sphere by attaching the tetrahedra with respect to the
	## identified faces and vertices
		while not IsIsomorphic(complex,surf) do
			temp:=helpNextVertex(complex,Vertices(surf));
			f:=Position(VerticesOfFaces(surf),temp[2]);
			v:=temp[1];
			for i in [1,2,3,4] do
				temp:=Filtered(idenFaces,tut->[i,f] in tut);
				if temp<>[] then 
					Add(symbol,[Position(idenFaces,temp[1]),i]);
				fi;
			od;
			surf:=TetrahedralExtension(surf,f,v);
			temp:=__SIMPLICIAL_helpNameFacesAndVertices(surf,idenFaces,idenVertices);
			idenFaces:=temp[1];
			idenVertices:=temp[2];
		od;
		return symbol;
	else 
		return fail;
	fi;
end
);
##
##      End of TetrahedralExtension
##
#######################################

#######################################
##
##      Edgeturn
##

InstallOtherMethod(EdgeTurn, "for a simplicial surface and an inner edge",
    [IsSimplicialSurface,IsPosInt],
    function(surface,edge)
        return EdgeTurn(surface,edge,edge);
    end
);
InstallMethod( EdgeTurn, "for a simplicial surface and an edge",
    [IsSimplicialSurface,IsPosInt,IsPosInt],
    function(surface,edge,newedge)
	local eof,voe,edges1,edges2,foe,vof, g;
	if newedge in Edges(surface) and newedge<>edge then 
		return fail;
	fi;
	foe:=FacesOfEdge(surface,edge);
	if Length( Union(VerticesOfFace(surface,foe[1]),VerticesOfFace(surface,foe[2])))=4 then	
		edges1:=Filtered(EdgesOfFace(surface,foe[1]),g->not(g=edge));
		edges2:=Filtered(EdgesOfFace(surface,foe[2]),g->not(g=edge));
		vof:=Union(VerticesOfFace(surface,foe[1]),VerticesOfFace(surface,foe[2]));
		voe:=[];
		for g in Difference(Edges(surface),[edge]) do
			voe[g]:=VerticesOfEdge(surface,g);
		od;
		voe[newedge]:=Filtered(vof,g-> not(g in VerticesOfEdge(surface,edge)));
		eof:=ShallowCopy(EdgesOfFaces(surface));
		if Length(Intersection(VerticesOfEdge(surface,edges1[1]),VerticesOfEdge(surface,edges2[1])))>0 and 
		IsSubsetSet(VerticesOfEdge(surface,edge),Intersection(VerticesOfEdge(surface,edges1[1]),VerticesOfEdge(surface,edges2[1]))) then
			eof[foe[1]]:=[newedge,edges1[1],edges2[1]];
			eof[foe[2]]:=[newedge,edges1[2],edges2[2]];
		else
			eof[foe[1]]:=[newedge,edges1[2],edges2[1]];
			eof[foe[2]]:=[newedge,edges1[1],edges2[2]];
		fi;
		return SimplicialSurfaceByDownwardIncidence(voe,eof);
	else
		return fail;
	fi;
end
);
##
##      End of Edgeturn
##
#######################################


InstallMethod( BuildingBlocks, "for a simplicial surface",
    [IsSimplicialSurface],
    function( surface )
        local w,bound,surf,vof1,vof2,waists,v;
        if not (IsClosedSurface(surface) and EulerCharacteristic(surface)=2 
		and IsVertexFaithful(surface)) then
                return false;
        fi;
        surf:=surface;
        waists:=AllThreeWaistsOfComplex(surface);
        while waists<>[] do
                w:=EdgesAsList(waists[1]);
		surf:=SplitVertexEdgePath(surface,waists[1])[1];
                bound:=BoundaryVertices(surf);
                vof1:=Intersection(bound,NeighbourVerticesOfVertex(surf,bound[1]));
                vof1:=Union([bound[1]],vof1);
                vof2:=Difference(bound,vof1);
                surf:=SimplicialSurfaceByVerticesInFaces(Union(VerticesOfFaces(surf),[vof1,vof2]));
                waists:=AllThreeWaistsOfComplex(surf);
        od;
        return ConnectedComponents(surf);
end
);


#######################################
##
##      Tori construction
##


InstallMethod( AllToriOfSimplicialSphere, 
    "for a simplicial surface",
    [IsSimplicialSurface],
    function(surface)
        local help_FaceMender,help_MendableEdgeAssignments,res,ee,ff,combFaces,edgesOfFaces,
        orb,autGroup,faces,mendEdges,verticesOfFaces;
        ## this method mends two faces of surface and removes the resulting face
        ## from the constructed triangular complex to give rise to a simplicial surface 
        help_FaceMender:=function(surface,faces,edges) 
	    local surf,i,vertex1,vertex2,newEdges,newPartition,temp,joinF;
	    surf:=surface;
            # mending of vertices
	    for i in [[1,2],[1,3],[2,3]] do 
	        vertex1:=Intersection(VerticesOfEdges(surf){edges[1]{i}})[1];
	        vertex2:=Intersection(VerticesOfEdges(surf){edges[2]{i}})[1];
	        if vertex1<>vertex2 then
	            surf:=JoinVertices(surf,vertex1,vertex2)[1];
	        fi;
            od;
            # mending of edges
            for i in [1,2,3] do
	        if edges[1][i]<> edges[2][i] then 
	            surf:=JoinEdges(surf,edges[1][i],edges[2][i])[1];
	        fi;
            od;
            # mending of faces
	    joinF:=JoinFaces(surf,faces[1],faces[2]);
            return RemoveFaceNC(joinF[1],joinF[2]);
        end;

	## given a surface and the edges of faces of two faces in the in given surface
	## this function returns a list of possible identifications of the given edges. 

        help_MendableEdgeAssignments:=function(surface,edgesOfFaces)
            local g,edgeAssign,vof1,vof2,inter,arrangements,eov1,eov2,i,
            edge1,edge2,ee,eof,help,res,help2,help1,v;

	    arrangements:=Arrangements(edgesOfFaces[2],3);
	    edgeAssign:=List([1..6],i->[edgesOfFaces[1],arrangements[i]]);
	    res:=[];
	    ## identified edges gives rise to an identification of the incident vertices
	    ## edges can only be identified if and only if there exists no
            help1:=function(surface,ee)
	        local i,v1,v2;
	        for i in [[1,2],[1,3],[2,3]] do 
	            v1:=Intersection(VerticesOfEdges(surface){ee[1]{i}})[1];
	            v2:=Intersection(VerticesOfEdges(surface){ee[2]{i}})[1];
	            if Set([v1,v2]) in VerticesOfEdges(surface) then 
		        return false; 
	            fi;
	        od;
	        return true;
            end;
            return Filtered(edgeAssign,ee->help1(surface,ee));
	end;
	if EulerCharacteristic(surface) <> 2 or not IsClosedSurface(surface) then 
	    return fail;
	fi;
        res:=[];
        faces:=Faces(surface);
        edgesOfFaces:=EdgesOfFaces(surface);
        verticesOfFaces:=VerticesOfFaces(surface);
        combFaces:=Combinations(faces,2);
        combFaces:=Filtered(combFaces,ff->Intersection(verticesOfFaces{ff})=[]);
        autGroup:=AutomorphismGroupOnFaces(surface);
        orb:=Orbits(autGroup,combFaces,OnSets);
        combFaces:=List(orb,g->g[1]);
        for ff in combFaces do
	    mendEdges:=help_MendableEdgeAssignments(surface,edgesOfFaces{ff});
	    Append(res,IsomorphismRepresentatives(List(mendEdges,ee->help_FaceMender(surface,ff,ee))));	
        od; 
        return res;
    end
);
##
##      End of tori construction
##
#######################################



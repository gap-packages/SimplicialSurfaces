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
InstallMethod( NumberOfVertices, "for a twisted polygonal complex", [IsTwistedPolygonalComplex],
    function(complex)
            return Length( VerticesAttributeOfComplex(complex) );
    end
);

InstallMethod( NumberOfEdges, "for a twisted polygonal complex", [IsTwistedPolygonalComplex],
    function(complex)
            return Length( Edges(complex) );
    end
);

InstallMethod( NumberOfFaces, "for a twisted polygonal complex", [IsTwistedPolygonalComplex],
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
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, vertex)
        return EdgesOfVertices(complex)[vertex];
    end
);
InstallMethod(EdgesOfVertex,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, vertex)
        __SIMPLICIAL_CheckVertex( complex, vertex, "EdgesOfVertex" );
        return EdgesOfVertexNC(complex,vertex);
    end
);

## FacesOfVertices
InstallMethod(FacesOfVertexNC, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, vertex)
        return FacesOfVertices(complex)[vertex];
    end
);
InstallMethod(FacesOfVertex,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, vertex)
        __SIMPLICIAL_CheckVertex( complex, vertex, "FacesOfVertex" );
        return FacesOfVertexNC(complex,vertex);
    end
);


## VerticesOfEdges
InstallMethod(VerticesOfEdgeNC, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, edge)
        return VerticesOfEdges(complex)[edge];  
    end
);
InstallMethod(VerticesOfEdge,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge( complex, edge, "VerticesOfEdge" );
        return VerticesOfEdgeNC(complex,edge);
    end
);


## FacesOfEdges
InstallMethod(FacesOfEdgeNC, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, edge)
        return FacesOfEdges(complex)[edge]; 
    end
);
InstallMethod(FacesOfEdge,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge( complex, edge, "FacesOfEdge" );
        return FacesOfEdgeNC(complex,edge);
    end
);


## VerticesOfFaces
InstallMethod(VerticesOfFaceNC, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, face)
        return VerticesOfFaces(complex)[face];
    end
);
InstallMethod(VerticesOfFace,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, face)
        __SIMPLICIAL_CheckFace( complex, face, "VerticesOfFace" );
        return VerticesOfFaceNC(complex,face);
    end
);


## EdgesOfFaces
InstallMethod(EdgesOfFaceNC, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, face)
        return EdgesOfFaces(complex)[face];    
    end
);
InstallMethod(EdgesOfFace,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
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
__SIMPLICIAL_AddPolygonalAttribute(PerimeterPathsOfFaces);


# the wrappers
InstallMethod( PerimeterPathOfFaceNC, 
    "for a polygonal complex and a face (positive integer)",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
        return PerimeterPathsOfFaces(complex)[face];
    end
);
RedispatchOnCondition( PerimeterPathOfFace, true, [IsTwistedPolygonalComplex,IsPosInt], [IsPolygonalComplex], 0 );
InstallMethod( PerimeterPathOfFace,
    "for a polygonal complex and a face (positive integer)",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
        __SIMPLICIAL_CheckFace(complex, face, "PerimeterPathOfFace");
        return PerimeterPathOfFaceNC(complex, face);
    end
);
RedispatchOnCondition( PerimeterPathOfFace, true, [IsTwistedPolygonalComplex,IsPosInt], [IsPolygonalComplex], 0 );


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
RedispatchOnCondition( PerimeterPathsOfFaces, true, [IsTwistedPolygonalComplex], [IsPolygonalComplex], 0 );

AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "PerimeterPathsOfFaces", ["Faces", "VerticesOfFaces", "EdgesOfFaces", 
        "VerticesOfEdges", "EdgesOfVertices"], ["IsPolygonalComplex"]);



# inferences from the perimeter path
InstallMethod( VerticesOfFaces, 
    "for a polygonal complex with PerimeterPathsOfFaces",
    [IsPolygonalComplex and HasPerimeterPathsOfFaces],
    function(complex)
        return List( PerimeterPathsOfFaces(complex), p -> Set(VerticesAsList(p)) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, 
    "VerticesOfFaces", ["PerimeterPathsOfFaces"], ["IsPolygonalComplex"] );


InstallMethod( EdgesOfFaces, 
    "for a polygonal complex with PerimeterPathsOfFaces",
    [IsPolygonalComplex and HasPerimeterPathsOfFaces],
    function(complex)
        return List( PerimeterPathsOfFaces(complex), p -> Set(EdgesAsList(p)) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, 
    "EdgesOfFaces", ["PerimeterPathsOfFaces"], ["IsPolygonalComplex"] );


InstallMethod( Faces,
    "for a polygonal complex that has PerimeterPathsOfFaces",
    [IsPolygonalComplex and HasPerimeterPathsOfFaces],
    function(complex)
        return PositionsBound( PerimeterPathsOfFaces(complex) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "Faces", "PerimeterPathsOfFaces", ["IsPolygonalComplex"]);

##
##          End of face-induced order
##
##############################################################################




##############################################################################
##
##      Umbrella-paths around vertices
##
__SIMPLICIAL_AddPolygonalAttribute(UmbrellaPathPartitionsOfVertices);
__SIMPLICIAL_AddPolygonalAttribute(UmbrellaPathsOfVertices);

##
## Implement the immediate methods for inferences about the complex
##
InstallImmediateMethod( IsNotVertexRamified, 
    "for a polygonal complex that has UmbrellaPathsOfVertices",
    IsPolygonalComplex and HasUmbrellaPathsOfVertices, 0,
    function(complex)
        return not fail in UmbrellaPathsOfVertices(complex);
    end
);
AddPropertyIncidence(SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "IsNotVertexRamified", "UmbrellaPathsOfVertices", ["IsPolygonalComplex"]);

InstallImmediateMethod( IsNotEdgeRamified,
    "for a polygonal complex that has UmbrellaPathPartitionsOfVertices",
    IsPolygonalComplex and HasUmbrellaPathPartitionsOfVertices, 0,
    function(complex)
        return not fail in UmbrellaPathPartitionsOfVertices(complex);
    end
);
AddPropertyIncidence(SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "IsNotEdgeRamified", "UmbrellaPathPartitionsOfVertices", ["IsPolygonalComplex"]);

##
## We will implement the connections between singular paths and partitions
## first. Afterward we will connect the partitions with everything else.
##

InstallMethod( UmbrellaPathsOfVertices,
    "for a polygonal surface that has UmbrellaPathPartitionsOfVertices",
    [IsPolygonalSurface and HasUmbrellaPathPartitionsOfVertices],
    function( surface )
        local umbPart, v, res;

        res := [];
        umbPart := UmbrellaPathPartitionsOfVertices(surface);
        for v in VerticesAttributeOfComplex(surface) do
            res[v] := umbPart[v][1];
        od;
        return res;
    end
);

InstallMethod( UmbrellaPathsOfVertices,
    "for a polygonal complex that has UmbrellaPathPartitionsOfVertices",
    [IsPolygonalComplex and HasUmbrellaPathPartitionsOfVertices],
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
    ["UmbrellaPathPartitionsOfVertices"], ["IsPolygonalComplex"]);



InstallImmediateMethod( UmbrellaPathPartitionsOfVertices,
    "for a polygonal complex without edge ramifications that has UmbrellaPathsOfVertices",
    IsPolygonalComplex and IsNotEdgeRamified and HasUmbrellaPathsOfVertices, 0,
    function( ramSurf )
        return List( UmbrellaPathsOfVertices(ramSurf), p -> [p] );
    end
);


## Methods for one single vertex
InstallMethod( UmbrellaPathOfVertexNC, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function( surface, vertex )
        return UmbrellaPathsOfVertices(surface)[vertex];
    end
);
InstallMethod( UmbrellaPathOfVertex, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function( surface, vertex )
        __SIMPLICIAL_CheckVertex(surface,vertex, "UmbrellaPathOfVertex");
        return UmbrellaPathOfVertexNC(surface, vertex);
    end
);

InstallMethod( UmbrellaPathPartitionOfVertexNC,
    "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function( ramSurf, vertex )
        return UmbrellaPathPartitionsOfVertices(ramSurf)[vertex];
    end
);
InstallMethod( UmbrellaPathPartitionOfVertex,
    "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
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
    "for a polygonal complex without edge ramifications that has UmbrellaPathPartitionsOfVertices", 
    [IsPolygonalComplex and IsNotEdgeRamified and HasUmbrellaPathPartitionsOfVertices],
    function(complex)
        return List( UmbrellaPathPartitionsOfVertices(complex), part ->
            __SIMPLICIAL_UnionSets( List( part, EdgesAsList ) ));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "EdgesOfVertices", 
    ["UmbrellaPathPartitionsOfVertices"], ["IsNotEdgeRamified", "IsPolygonalComplex"]);

InstallMethod( FacesOfVertices,
    "for a polygonal complex without edge ramifications that has UmbrellaPathPartitionsOfVertices",
    [IsPolygonalComplex and IsNotEdgeRamified and HasUmbrellaPathPartitionsOfVertices],
    function(complex)
        return List( UmbrellaPathPartitionsOfVertices(complex), part ->
            __SIMPLICIAL_UnionSets( List( part, FacesAsList ) ));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "FacesOfVertices", 
    ["UmbrellaPathPartitionsOfVertices"], ["IsNotEdgeRamified", "IsPolygonalComplex"]);

InstallMethod( FacesOfEdges,
    "for a polygonal complex without edge ramifications that has UmbrellaPathPartitionsOfVertices and VerticesAttributeOfComplex",
    [IsPolygonalComplex and IsNotEdgeRamified and HasUmbrellaPathPartitionsOfVertices and HasVerticesAttributeOfComplex],
    function(complex)
        local facesOfEdges, parts, v, p, even, ind, i, edge, incFaces, path;

        parts := UmbrellaPathPartitionsOfVertices(complex);

        facesOfEdges := [];
        for v in VerticesAttributeOfComplex(complex) do
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
    ["UmbrellaPathPartitionsOfVertices", "VerticesAttributeOfComplex"], 
    ["IsNotEdgeRamified", "IsPolygonalComplex"]);


InstallMethod( UmbrellaPathPartitionsOfVertices, 
    "for a polygonal complex that has VerticesAttributeOfComplex, EdgesOfVertices, EdgesOfFaces, FacesOfEdges, VerticesOfEdges and RamifiedEdges",
    [IsPolygonalComplex and HasVerticesAttributeOfComplex and 
        HasEdgesOfVertices and HasEdgesOfFaces and HasFacesOfEdges and 
        HasVerticesOfEdges and HasRamifiedEdges],
    function(ramSurf)
        local faceEdgePathPart, vertex, incidentEdges, paths,
            edgeStart, possFaces, rightFinished, leftFinished, backFace, path,
            nextEdge, nextFace, usedEdges;

        faceEdgePathPart := [];

        for vertex in VerticesAttributeOfComplex(ramSurf) do
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
    ["VerticesAttributeOfComplex", "EdgesOfVertices", "EdgesOfFaces", 
        "FacesOfEdges", "VerticesOfEdges", "RamifiedEdges"], ["IsPolygonalComplex"]);


InstallMethod(StarNC, "for a polygonal surface and an integer", [IsPolygonalSurface, IsInt],
	function(surface, vertex)
	
		return Star(surface)[vertex];
	
end);

InstallMethod(Star, "for a polygonal surface and an integer", [IsPolygonalSurface, IsInt],
	function(surface, vertex)
	
		__SIMPLICIAL_CheckVertex(surface,vertex, "Star");
		return StarNC(surface,vertex);
	
end);

InstallOtherMethod(Star, "for a polygonal surface", [IsPolygonalSurface],
	function(surface)
	
		local vertex, list, faces;
		list:=[];
		for vertex in Vertices(surface) do
			faces:=FacesOfVertex(surface,vertex);
			Add(list, SubsurfaceByFaces(surface,faces));
		od;
		return list;
	
end);

InstallMethod(LinkNC, "for a polygonal surface and an integer", [IsPolygonalSurface, IsInt],
	function(surface, vertex)
	
		return Link(surface)[vertex];
	
end);

InstallMethod(Link, "for a polygonal surface and an integer", [IsPolygonalSurface, IsInt],
	function(surface, vertex)
	
		__SIMPLICIAL_CheckVertex(surface,vertex, "Link");
		return LinkNC(surface,vertex);
	
end);

InstallOtherMethod(Link, "for a polygonal surface", [IsPolygonalSurface],
	function(surface)
	
		local vertex, list, path, faces, edges, face;
		list:=[];
		for vertex in Vertices(surface) do
			path:=UmbrellaPathOfVertex(surface, vertex);
			faces:=FacesAsList(path);
			edges:=[];
			for face in faces do
				Add(edges,OppositeEdgeOfVertexInTriangle(surface, vertex, face));
			od;
			Add(list, VertexEdgePathByEdges(surface,edges));
		od;
		return list;
	
end);
##
##          End of Umbrella-paths around vertices 
##
##############################################################################


##############################################################################
##
##          Start of HolePerimeter
##
InstallMethod( PerimeterOfHoles, "for a twisted polygonal surface",
    [IsTwistedPolygonalSurface], 
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
    RedispatchOnCondition( PerimeterOfHoles, true, [IsTwistedPolygonalComplex], [IsTwistedPolygonalSurface], 0 );
fi;

#! @DoNotReadRestOfFile

#############################################################################
##
#!	@Description
#!	Return a list of tuples where at each face-number there is a list with two
#!	entries. The first one is the name of the upper face-side, the second one
#!	the name of the lower face-side (with respect to the local orientation).
#!	All other positions are unbounded.
#!  @Returns a list of lists of integers
#!  @Arguments a simplicial surface object simpsurf
InstallMethod( NamesOfFaces,
	"for a simplicial surface with default face naming convention",
	[IsSimplicialSurface and IsFaceNamesDefault],
	function(simpsurf)
		local faceNames, face;

		faceNames := [];
		for face in Faces( simpsurf ) do
			faceNames[face] := [face, -1*face];
		od;
	
		return faceNames;
	end
);

#############################################################################
##
#!	@Description
#!	Return if the naming scheme for the faces is the default one, meaning
#!	that the upper side of a face f is called f (a positive integer) and the
#!	lower side -f (a negative integer).
#!	@Returns true if the simplicial surface follows the default naming scheme,
#!	false otherwise
#!	@Arguments a simplicial surface object simpsurf
InstallMethod( IsFaceNamesDefault, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local faceNames, face;

		faceNames := NamesOfFaces(simpsurf);
		for face in Faces( simpsurf ) do
			if not faceNames[face] = [face, -1*face] then
				return false;
			fi;
		od;
	
		return true;
	end
);

#############################################################################
##
#!	@Description
#!	This function returns both names of the given face. The first entry is
#!	the name of the upper side, the second one of the lower side.
#!	The NC-version doesn't check if the given number actually is a face.
#!	@Arguments a simplicial surface object simpsurf, a face number
#!	@Returns a list with two elements
InstallMethod( NamesOfFaceNC, "for a simplicial surface",
	[IsSimplicialSurface, IsPosInt],
	function(simpsurf, face)
		return NamesOfFaces(simpsurf)[face];
	end
);
InstallMethod( NamesOfFace, "for a simplicial surface",
	[IsSimplicialSurface, IsPosInt],
	function(simpsurf, face)
		if not face in Faces( simpsurf ) then
			Error("NamesOfFace[generic]: Face doesn't lie in surface.");
		fi;
		return NamesOfFaces(simpsurf)[face];
	end
);

#############################################################################
##
#!	@Description
#!	This function returns both names of the given face. The first entry is
#!	the name of the upper side, the second one of the lower side.
#!	The NC-version doesn't check if the given number actually is a face.
#!	@Arguments a simplicial surface object simpsurf, a face number
#!	@Returns a list with two elements
InstallMethod( NamesOfFaceNC,
	"for a simplicial surface with default face naming convention",
	[IsSimplicialSurface and IsFaceNamesDefault, IsPosInt],
	function(simpsurf, face)
		return [face, -1*face];
	end
);
InstallMethod( NamesOfFace,
	"for a simplicial surface with default face naming convention",
	[IsSimplicialSurface and IsFaceNamesDefault, IsPosInt],
	function(simpsurf, face)
		if not face in Faces( simpsurf ) then
			Error("NamesOfFace[default]: Face doesn't lie in surface.");
		fi;
		return [face, -1*face];
	end
);

#############################################################################
##
#!	@Description
#!	Return the face-number of the simplicial surface that has the given name
#!	as the name of one of its sides.
#!	@Arguments a simplicial surface object simpsurf, an integer
#!	@Returns a positive integer
InstallMethod( FaceByName, "for a simplicial surface",
	[IsSimplicialSurface, IsInt],
	function(simpsurf, face)
		local faceNames, faceNr;

		faceNames := NamesOfFaces(simpsurf);
		for faceNr in Faces(simpsurf) do
			if face in faceNames[faceNr] then
				return faceNr;
			fi;
		od;
		Error("FaceByName[generic]: Given face side name doesn't exist.");
	end
);

#############################################################################
##
#!	@Description
#!	Return the face-number of the simplicial surface that has the given name
#!	as the name of one of its sides.
#!	@Arguments a simplicial surface object simpsurf, an integer
#!	@Returns a positive integer
InstallMethod( FaceByName,
	"for a simplicial surface with default face naming convention",
	[IsSimplicialSurface and IsFaceNamesDefault, IsInt],
	function(simpsurf, face)
		local result;

		result := AbsInt(face);
		if not result in Faces(simpsurf) then
			Error("FaceByName[default]: Given face side name doesn't exist.");
		fi;
		return result;
	end
);

#TODO this is a method for the incidence geometry - no connection to local orientation
InstallMethod( AddVertexIntoEdge,
    "for a simplicial surface and an edge that is incident to exactly two faces.",
    [IsSimplicialSurface, IsPosInt],
    function( surf, edge )
        local oldVertices, v1,v2,v3,v4, oldFaces, f1,f2, newEdgesOfFaces, V, 
            newVerticesOfEdges, maxEdge, maxFaces;

        # Picture
        #             v3
        #            /  \
        #           / f1 \
        #          v1----v2
        #           \ f2 /
        #            \  /
        #             v4
        oldVertices := VerticesOfEdges(surf)[edge]; # [v1,v2]
        v1 := oldVertices[1];
        v2 := oldVertices[2];

        oldFaces := FacesOfEdges(surf)[edge]; # [f1,f2]
        if Size(oldFaces) <> 2 then
            Error("The edge has to be an inner edge.");
        fi;
        f1 := oldFaces[1];
        f2 := oldFaces[2];

        # find the other two vertices that are incident to the two faces but
        # not to the edge
        v3 := Difference( VerticesOfFaces(surf)[f1], oldVertices )[1];
        v4 := Difference( VerticesOfFaces(surf)[f2], oldVertices )[1];


        # We modify the picture to become
        #
        #                v3
        #              /  |  \
        #             /   |   \
        #            /   e+3   \
        #           / f+1 | f+2 \
        #          /      |      \
        #         v1-e+1--V-e+2---v2
        #          \      |      /
        #           \ f+3 | f+4 /
        #            \   e+4   /
        #             \   |   /
        #              \  |  /
        #                v4
        V := Maximum(Vertices(surf)) + 1;
        newVerticesOfEdges := ShallowCopy( VerticesOfEdges(surf) );
        Unbind( newVerticesOfEdges[edge] );
        maxEdge := Maximum( Edges(surf) );
        newVerticesOfEdges[maxEdge+1] := [v1,V];
        newVerticesOfEdges[maxEdge+2] := [V,v2];
        newVerticesOfEdges[maxEdge+3] := [v3,V];
        newVerticesOfEdges[maxEdge+4] := [V,v4];

        newEdgesOfFaces := ShallowCopy( EdgesOfFaces(surf) );
        Unbind( newEdgesOfFaces[f1] );
        Unbind( newEdgesOfFaces[f2] );
        maxFaces := Maximum(Faces(surf));
        newEdgesOfFaces[maxFaces+1] := 
            [ maxEdge+1, maxEdge+3, EdgeInFaceByVertices(surf, f1, [v1,v3]) ]; 
        newEdgesOfFaces[maxFaces+2] :=
            [ maxEdge+2, maxEdge+3, EdgeInFaceByVertices(surf, f1, [v2,v3]) ];
        newEdgesOfFaces[maxFaces+3] := 
            [ maxEdge+1, maxEdge+4, EdgeInFaceByVertices(surf, f2, [v1,v4]) ];
        newEdgesOfFaces[maxFaces+4] :=
            [ maxEdge+2, maxEdge+4, EdgeInFaceByVertices(surf, f2, [v2,v4]) ];

        return SimplicialSurfaceByDownwardIncidence( 
            Union( [V], Vertices(surf) ),
            Union( List([1,2,3,4],i->maxEdge+i), Difference(Edges(surf),[edge]) ),
            Union( List([1,2,3,4],i->maxFaces+i), Difference(Faces(surf),[f1,f2]) ),
            newVerticesOfEdges,
            newEdgesOfFaces );
    end
);




InstallMethod( AlternativeNames, "for a simplicial surface",
    [IsSimplicialSurface],
    function(simpSurf)
        return rec();
    end
);

InstallOtherMethod( MaximalStripEmbedding, "",
    [IsSimplicialSurface and IsEdgesLikeSurface and IsTriangleSurface,
        IsPosInt, IsPosInt],
    function( surf, vertex, face )
        local edges;

        if not vertex in Vertices(surf) then
            Error("Given vertex is not a vertex of the surface.");
        fi;
        if not face in Faces(surf) then
            Error("Given face is not a face of the surface.");
        fi;

        edges := Intersection( EdgesOfFaces(surf)[face], EdgesOfVertices(surf)[vertex] );

        if IsEmpty(edges) then
            Error("Given vertex and face have no edge between them.");
        fi;

        return MaximalStripEmbedding(surf, vertex, edges[1], face);
    end
);
    RedispatchOnCondition( MaximalStripEmbedding, true,
        [IsSimplicialSurface, IsPosInt, IsPosInt],
        [IsTriangleSurface and IsEdgesLikeSurface,,], 0);

InstallMethod( MaximalStripEmbedding, "", 
    [IsSimplicialSurface and IsEdgesLikeSurface and IsTriangleSurface, 
        IsPosInt, IsPosInt, IsPosInt],
    function( surf, vertex, edge, face )
        local path, len, neighbour, pivotVert, newBorderEdge, 
            traversedFaces, reversed;

        if not vertex in Vertices(surf) then
            Error("Given vertex is not a vertex of the surface.");
        fi;
        if not edge in Edges(surf) then
            Error("Given edge is not an edge of the surface.");
        fi;
        if not face in Faces(surf) then
            Error("Given face is not a face of the surface.");
        fi;

        if not vertex in VerticesOfEdges(surf)[edge] then
            Error("Given vertex does not lie in given edge.");
        fi;
        if not edge in EdgesOfFaces(surf)[face] then
            Error("Given edge does not lie in given face.");
        fi;

        # Idea:
        # Construct the edge-face-path in the variable path
        # Extend the right-hand-side until it goes no further
        # Then extend the left-hand-side

        # Initialize the system
        path := [ OtherEdgeOfVertexInFaceNC(surf, vertex, edge, face), face, edge ];
        traversedFaces := [face];
        pivotVert := vertex;

        reversed := false; # Used for the direction of the extension
        while( true ) do
            # Try to extend the path
            len := Size(path);
            neighbour := NeighbourFaceByEdgeNC(surf, path[len-1], path[len]);
            if neighbour in traversedFaces or neighbour = fail then
                if reversed then
                    break;
                else
                    reversed := true;
                    path := Reversed(path);
                    pivotVert := vertex; # Reset to original vertex
                    continue;
                fi;
            fi;

            pivotVert := OtherVertexOfEdgeNC(surf, pivotVert, path[len]);
            newBorderEdge := OtherEdgeOfVertexInFaceNC(surf,pivotVert,path[len],neighbour);
            Append( path, [neighbour, newBorderEdge] );
            Add( traversedFaces, neighbour );
        od;

        # We have to invert the path at the end (so it is oriented properly)
        path := Reversed(path);

        return [path, SubsurfaceByFacesNC(surf, Set(traversedFaces))];
    end
);
    RedispatchOnCondition( MaximalStripEmbedding, true,
        [IsSimplicialSurface, IsPosInt, IsPosInt, IsPosInt],
        [IsTriangleSurface and IsEdgesLikeSurface,,,], 0);

InstallMethod( Geodesic,
    "for a simplicial surface, a vertex, an edge and a face",
    [IsSimplicialSurface and IsTriangleSurface and IsEdgesLikeSurface,
    IsPosInt, IsPosInt, IsPosInt],
    function(surf,vertex,edge,face)
        local path, len, neighbour, pivotVert, newBorderEdge, other, 
            traversedFaces, reversed, minpos, permList, invPermList, swapList;
            #TODO copy of code above (with modifications) -> unify?

        if not vertex in Vertices(surf) then
            Error("Given vertex is not a vertex of the surface.");
        fi;
        if not edge in Edges(surf) then
            Error("Given edge is not an edge of the surface.");
        fi;
        if not face in Faces(surf) then
            Error("Given face is not a face of the surface.");
        fi;

        if not vertex in VerticesOfEdges(surf)[edge] then
            Error("Given vertex does not lie in given edge.");
        fi;
        if not edge in EdgesOfFaces(surf)[face] then
            Error("Given edge does not lie in given face.");
        fi;

        # Idea:
        # Construct the edge-face-path in the variable path
        # Extend the right-hand-side until it meets up again
        # or stops at a boundary. In that case reverse course.

        # Initialize the system
        other := OtherEdgeOfVertexInFaceNC(surf, vertex, edge, face);
        path := [ other, face, edge ];
        traversedFaces := [face];
        pivotVert := vertex;

        invPermList := [ Position(AllFlags(surf), [vertex,edge,face]) ];
        permList := [ Position(AllFlags(surf), [vertex,other,face]) ];

        # minpos[1] is the position of the edge of the minimal face
        # minpos[2] is the direction +1 means go right
        if path[1] < path[3] then 
            minpos := [3,-1]; 
        else 
            minpos := [1,1]; 
        fi;

        reversed := false; # Used for the direction of the extension
        while( true ) do
            # Try to extend the path
            len := Size(path);
            neighbour := NeighbourFaceByEdgeNC(surf, path[len-1], path[len]);
            pivotVert := OtherVertexOfEdgeNC(surf, pivotVert, path[len]);
            if neighbour <> fail then
                newBorderEdge := OtherEdgeOfVertexInFaceNC(
                                 surf,pivotVert,path[len],neighbour);
            fi;


            if neighbour <> fail then
                if neighbour < path[minpos[1]+minpos[2]] then
                    if path[len] < newBorderEdge then
                        minpos := [ len+2, -1 ];
                    else
                        minpos := [ len, 1 ];
                    fi;
                elif neighbour = path[minpos[1]+minpos[2]] then
                    if path[len] < newBorderEdge then
                        if path[len] < path[minpos[1]+2*minpos[2]] then
                            minpos := [len+2,-1];
                        elif path[len] = path[minpos[1]+2*minpos[2]] then
                            if newBorderEdge < path[minpos[1]] then
                                minpos := [len+2,-1];
                            fi;
                        fi;
                    else
                        if newBorderEdge < path[minpos[1]+2*minpos[2]] then
                            minpos := [len,1];
                        elif newBorderEdge = path[minpos[1]+2*minpos[2]] then
                            if path[len] < path[minpos[1]] then
                                minpos := [len,1];
                            fi;
                        fi;
                    fi;
                fi;
            fi;
            

            if neighbour = fail then
                if reversed then
                    path := Reversed(path);
                    permList := Reversed(permList);
                    invPermList := Reversed( invPermList );
                    swapList := invPermList;
                    invPermList := permList;
                    permList := swapList;
                    break;
                else
                    reversed := true;
                    path := Reversed(path);
                    permList := Reversed(permList);
                    invPermList := Reversed(invPermList);
                    swapList := invPermList;
                    invPermList := permList;
                    permList := swapList;
                    pivotVert := vertex; # Reset to original vertex
                    continue;
                fi;
            elif path[len] = path[1] and neighbour = path[2] and newBorderEdge = path[3] then
                # finished
                break;
            elif Size(path) > 6*NrOfFaces(surf) then
                Error("Geodesic: Inconsistent surface input.");
            fi;

            Append( path, [neighbour, newBorderEdge] );
            Add( traversedFaces, neighbour );
            invPermList := Concatenation( [Position(AllFlags(surf), [pivotVert, newBorderEdge, neighbour])], invPermList );
            Add(permList, Position(AllFlags(surf), [pivotVert, path[len], neighbour ] ) );
        od;

        # minimise the geodesic
        if reversed then
            # the path is not closed
            if path[2] < path[Length(path)-1] then
                #continue;
            elif path[2] > path[Length(path)-1] then
                path := Reversed(path);
            elif  path[3] < path[Length(path)-2] then
                #continue;
            elif  path[3] > path[Length(path)-2] then
                path := Reversed(path);
            elif path[1] > path[Length(path)] then
                path := Reversed(path);
            fi;
        else
            # the path is closed
            if minpos[2] = 1 then
               path := Concatenation(path{[minpos[1]..Length(path)]},
                        path{[2..minpos[1]-1]}, [ path[minpos[1]] ]);
            else
               path := Concatenation( [ path[minpos[1]] ], path{[minpos[1]+1..Length(path)]},
                        path{[2..minpos[1]]});
               path := Reversed(path);
            fi;
        fi;


        return [path, SubsurfaceByFacesNC(surf, Set(traversedFaces)), __SIMPLICIAL_TranslateListsIntoCycles([permList, invPermList])];
    end
);
    RedispatchOnCondition( Geodesic, true,
        [IsSimplicialSurface,IsPosInt, IsPosInt,IsPosInt],
        [IsTriangleSurface and IsEdgesLikeSurface,,,], 0);

InstallOtherMethod( Geodesic,
    "for a simplicial surface, a vertex and a face",
    [IsSimplicialSurface and IsTriangleSurface and IsEdgesLikeSurface,
    IsPosInt, IsPosInt],
    function(surf, vertex, face)
        local edges;
        
        if not vertex in Vertices(surf) then
            Error("Given vertex does not lie in surface.");
        fi;
        if not face in Faces(surf) then
            Error("Given face does not lie in surface.");
        fi;
        
        edges := Intersection( EdgesOfFaces(surf)[face], EdgesOfVertices(surf)[vertex] );
        if IsEmpty(edges) then
            Error("Given vertex is not incident to given face.");
        fi;
        
        return Geodesic(surf, vertex, edges[1], face);
    end
 );
    RedispatchOnCondition( Geodesic, true,
        [IsSimplicialSurface, IsPosInt, IsPosInt],
        [IsTriangleSurface and IsEdgesLikeSurface, ,], 0);

InstallMethod( Geodesics, "for a simplicial surface",
        [IsSimplicialSurface and IsTriangleSurface and IsEdgesLikeSurface],
        function(surface)
            local triples, tr, geodesics, vertex, geo, vertOfEdge, allFlags,
                NormaliseFlag, allGeos, bigPerm, g;

            triples := Union( List( Faces(surface),
                f -> List( Combinations(EdgesOfFaces(surface)[f],2),
                              c -> [c[1],f,c[2]] ) ) );
            vertOfEdge := VerticesOfEdges(surface);

            geodesics := [];
            while Size(triples) > 0 do
               tr := triples[1];
               geo := Geodesic( surface, 
                  Intersection(vertOfEdge[tr[1]], vertOfEdge[tr[3]] )[1],
                  tr[3], tr[2] );
                  #TODO write this as alternative input
               Add(geodesics,geo);
               # remove all flags
               allFlags := List( [1..(Length(geo[1])-1)/2], i ->
                           geo[1]{[2*i-1,2*i,2*i+1]} );
               NormaliseFlag := function(x)
                   if x[1] > x[3] then
                       return [x[3],x[2],x[1]];
                   else
                       return x;
                   fi;
               end;
               allFlags := List( allFlags, NormaliseFlag );
               triples := Difference( triples, allFlags);

            od;

            allGeos := Set(geodesics);
            bigPerm := ();
            for g in allGeos do
                bigPerm := bigPerm * g[3][1] * g[3][2];
            od;
            SetGeodesicFlagPermutation(surface, bigPerm);

            return Set(geodesics);
        end
);
InstallMethod( GeodesicFlagPermutation, "", [IsSimplicialSurface],
    #TODO
    function(complex)
        Geodesics(complex);
        return GeodesicFlagPermutation(complex);
    end
);


InstallMethod( AllMaximalStripEmbeddings, "for a geodesic", [IsList],
    function(geo)
        local res, max, start, seenFaces, rPos, nextFace, nextEdge, lPos, i;

        #TODO how to check if geodesic is closed?
        res := [];
        for i in [2,4..Size(geo[1])-1] do
            start := geo[1][i];
            seenFaces := [start];
            max := geo[1]{[i-1,i,i+1]};

            # go to the right
            rPos := i;
            while(true) do
                # increase rPos
                if rPos = Size(geo[1])-1 then
                    rPos := 2;
                else
                    rPos := rPos + 2;
                fi;

                # add face and edge
                nextFace := geo[1][rPos];
                nextEdge := geo[1][rPos+1];
                Append( max, [nextFace, nextEdge] );

                if nextFace in seenFaces then
                    break;
                else
                    Add(seenFaces, nextFace);
                fi;
            od;

            # go to the left
            lPos := i;
            while(true) do
                # decrase lPos
                if lPos = 2 then
                    lPos := Size(geo[1]);
                else
                    lPos := lPos - 2;
                fi;

                # add face and edge
                nextFace := geo[1][lPos];
                nextEdge := geo[1][lPos-1];
                
                max := Concatenation( [nextEdge, nextFace], max );
                if nextFace in seenFaces then
                    break;
                else
                    Add(seenFaces, nextFace);
                fi;
            od;

            Add(res, [max, Set(seenFaces)]);
        od;

        res := Set(res);
        return List( res, m -> [m[1], SubsurfaceByFacesNC(geo[2], m[2])] );
    end
);



InstallMethod( FlagSurface, "", [IsPerm, IsPerm, IsPerm], 
    function( vertexPerm, edgePerm, facePerm )
        local moved, CycleDegrees, mr, wild, origVerts, origEdges, origFaces,
            flags, m, vert, edge, face, surf, verticesOfEdges, edgesOfFaces;

        if not IsPerm(vertexPerm) or not IsPerm(edgePerm) or not IsPerm(facePerm) then
            Error("Input has to be three involutions.");
        fi;
        if vertexPerm^2 <> () or edgePerm^2 <> () or facePerm^2 <> () then
            Error("The given permutations have to have degree 2");
        fi;
        moved := MovedPoints( Group(vertexPerm, edgePerm, facePerm) );
        CycleDegrees := function( perm, moved )
            local orbs, lengths;

            orbs := Orbits( Group(perm), moved );
            lengths := List( orbs, Size );
            return Set(lengths);
        end;
        if CycleDegrees(vertexPerm,moved) <> [2] or CycleDegrees(edgePerm,moved) <> [2] or CycleDegrees(facePerm,moved) <> [2] then
            Error("Given involutions are not allowed to have fixed points.");
        fi;

        # The barycentric subdivision is just a mmm--coloured surface where 
        # the vertex/edge-product has degree 3 and the vertex/face-product
        # has degree 2
        if CycleDegrees( vertexPerm*edgePerm, moved ) <> [3] then
            Error("Product of first and second involution only consists of cycles of length 3.");
        fi;
        if CycleDegrees( vertexPerm*facePerm, moved ) <> [2] then
            Error("Product of first and third involution only consists of cycles of length 2.");
        fi;

        mr := List( [1..Maximum(moved)], i->1 );
        wild := AllWildSimplicialSurfaces( vertexPerm,edgePerm,facePerm, [mr,mr,mr] );
        if Size(wild) <> 1 then
            Error("Internal error: No mmm-surface found.");
        fi;

        # Reconstruct the flags of the original surface
        origFaces := Orbits( Group( vertexPerm, edgePerm ), moved );
        origEdges := Orbits( Group( vertexPerm, facePerm ), moved );
        origVerts := Orbits( Group( edgePerm, facePerm ), moved );

        verticesOfEdges := List( [1..Size(origEdges)], i->[] );
        edgesOfFaces := List( [1..Size(origFaces)], i -> [] );

        flags := [];
        for m in moved do
            vert := PositionProperty( origVerts, v -> m in v );
            edge := PositionProperty( origEdges, e -> m in e );
            face := PositionProperty( origFaces, f -> m in f );
            flags[m] := [vert,edge,face];
            verticesOfEdges[edge] := Union( verticesOfEdges[edge], [vert] );
            edgesOfFaces[face] := Union( edgesOfFaces[face], [edge] );
        od;
        
        # Check if the flags belong to a simplicial surface (there might be a problem if two edges of the same face are identified).
        if Size( Set(flags) ) < Number(flags) then
            # There is a problem
            return [ flags, fail, wild ];
        fi;

        surf := SimplicialSurfaceByDownwardIncidenceNC( Size(origVerts), Size(origEdges), Size(origFaces),
            verticesOfEdges, edgesOfFaces); #TODO constructor by flags

        return [ flags, surf, wild ];
    end
);



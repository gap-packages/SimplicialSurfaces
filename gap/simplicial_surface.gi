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



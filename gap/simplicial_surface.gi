#! @DoNotReadRestOfFile


#############################################################################
##
#!	@Description
#!	This function returns the simplicial subsurface that is defined by the
#!	given set of faces.
#!	The NC-version does not check if the given faces actually are faces of
#!	the simplicial surface.
#!	@Arguments a simplicial surface object simpsurf, a set of positive integers
#!	@Returns a simplicial surface object
InstallMethod( SubsurfaceByFaces, "for a simplicial surface",
	[IsSimplicialSurface, IsSet],
	function(simpsurf, subfaces)
		local subVertices, subEdges, newVerticesOfEdges, newEdgesOfFaces, e, f;

		if not IsSubset( Faces(simpsurf), subfaces ) then
			Error("SubsurfaceByFaces: there are not only faces given.");
		fi;

		return SubsurfaceByFacesNC( simpsurf, subfaces );
	end
);
	RedispatchOnCondition( SubsurfaceByFaces, true, 
		[IsSimplicialSurface, IsList], [,IsSet], 0);
InstallMethod( SubsurfaceByFacesNC, "for a simplicial surface",
	[IsSimplicialSurface, IsSet],
	function(simpsurf, subfaces)
		local subVertices, subEdges, newVerticesOfEdges, newEdgesOfFaces, e, f;


		subEdges := Union( List( subfaces, f -> EdgesOfFaces(simpsurf)[f] ));
		subVertices := Union( List( subEdges, e -> 
											VerticesOfEdges(simpsurf)[e] ) );

		newVerticesOfEdges := [];
		for e in subEdges do
			newVerticesOfEdges[e] := VerticesOfEdges(simpsurf)[e];
		od;

		newEdgesOfFaces := [];
		for f in subfaces do
			newEdgesOfFaces[f] := EdgesOfFaces(simpsurf)[f];
		od;

		return SimplicialSurfaceByDownwardIncidenceNC( subVertices, subEdges,
			subfaces, newVerticesOfEdges, newEdgesOfFaces );
	end
);
	RedispatchOnCondition( SubsurfaceByFacesNC, true, 
		[IsSimplicialSurface, IsList], [,IsSet], 0);

#############################################################################
##
##		SnippOffEars - methods
##

BindGlobal( "__SIMPLICIAL_SnippOffEarsOfSimplicialSurface",
	function(simpsurf)
		local vertexDegree, ears, newSurface, facesToRemove, 
		    adFaces, opEdges, remainingFaces, singleEars, doubleEars, v;

		# Find ears
		vertexDegree := UnsortedDegrees( simpsurf );
		singleEars := Filtered( Vertices(simpsurf), i -> vertexDegree[i] = 1);
		doubleEars := Filtered( Vertices(simpsurf), i -> vertexDegree[i] = 2);

		if IsEmpty( singleEars ) and IsEmpty( doubleEars ) then
			return simpsurf;
		fi;

		facesToRemove := Union( List( singleEars, i->FacesOfVertices(simpsurf)[i]) );
		remainingFaces := Difference( Faces(simpsurf), facesToRemove );
		newSurface := SubsurfaceByFacesNC( simpsurf, remainingFaces );

                for v in doubleEars do
                    adFaces := FacesOfVertices(simpsurf)[v];
                    opEdges := List( adFaces, f -> Difference(EdgesOfFaces(newSurface)[f],EdgesOfVertices(newSurface)[v])[1] );
                    # Identify opEdges
                    newSurface := SubsurfaceByFacesNC( newSurface, Difference(Faces(newSurface),adFaces) );
                    newSurface := CraterMend( newSurface, opEdges[1], opEdges[2] );
                od;
	
		return newSurface;
	end
);

InstallMethod( SnippOffEars, "for a simplicial surface", [IsSimplicialSurface],
	__SIMPLICIAL_SnippOffEarsOfSimplicialSurface );


InstallMethod( SnippOffEarsRecursive, "for a simplicial surface", 
	[IsSimplicialSurface], function( simpsurf )
		local newSurface;

		newSurface := SnippOffEars( simpsurf );
		# Use a simplified equality test
		if NrOfFaces(newSurface) = NrOfFaces(simpsurf) then
			return simpsurf;
		fi;

		return SnippOffEarsRecursive(newSurface);
	end
);

##
###############################################################################

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

InstallMethod( CommonCover, 
    "for two simplicial surfaces and mr-types of edges",
    [IsSimplicialSurface and IsEdgesLikeSurface and IsTriangleSurface,
    IsSimplicialSurface and IsEdgesLikeSurface and IsTriangleSurface,
    IsList, IsList],
    function( surf1, surf2, mrType1, mrType2 )
        local facePairs, newFaces, pair, vert1, vert2, allImages,
            TauByMR, taus1, taus2, tau1, tau2, e, e1, e2, vertOfE2,
            vertexBaseSet, vertexBasePositionsByFace, facePos,
            newFace, foundPairs, adjacencyList, AdjacentFace,
            edgePair, adFace1, adFace2, otherIso, bothFaces, otherFace,  
            found, j, baseVertPos1, baseVertPos2, baseVertA1, baseVertA2,
            baseVertB1, baseVertB2, vertOfEdge,
            vertexGraph, connComp, edgeDescription, i, edge, 
            surface, altNames, simpFaces, simpEdges, simpVertices,
            simpVerticesOfEdges, simpFacesOfEdges;

        # The new faces are given by all isomorphisms between faces
        # of the original two surfaces
        # We encode those as 
        # [first face, second face, bijection between first and second vertices]
        # The first vertices are ordered, the second vertices are arbitrary
        facePairs := Cartesian(Faces(surf1),Faces(surf2));
        newFaces := [];
        for pair in facePairs do
            vert1 := VerticesOfFaces(surf1)[pair[1]];
            vert2 := VerticesOfFaces(surf2)[pair[2]];
            allImages := Arrangements(vert2, Size(vert2));
            Append( newFaces, List(allImages, im -> 
                [pair[1], pair[2], GeneralMappingByElements( 
                    Domain(vert1), 
                    Domain(vert2),
                    List([1,2,3], i-> DirectProductElement([vert1[i],im[i]]))
                    # we only have triangular faces
                )]
            ));
        od;

        # We will now proceed this way:
        # 1) Define the set from which the vertices will be derived
        # 2) Iterate over all edge combinations (and construct adjacent faces)
        #   2.1) Those define the new edges
        #   2.2) They define the incidence to the faces
        #   2.3) They define the equivalence between vertices

        # Before we do this we need to define the maps tau that mirror or
        # rotate the vertices of a face along an edge (as given in the mrtype)
        TauByMR := function( surf, edge, mr )
            local vertsOfEdge, adjacentFaces, thirdVertices;

            vertsOfEdge := VerticesOfEdges(surf)[edge];
            adjacentFaces := FacesOfEdges(surf)[edge];
            thirdVertices := Difference( Union( List(adjacentFaces, 
                f -> VerticesOfFaces(surf)[f]) ), vertsOfEdge );

            if mr = 1 then # mirror
                if Size(thirdVertices) = 1 then
                    return ();
                else
                    return (thirdVertices[1],thirdVertices[2]);
                fi;
            elif mr = 2 then # rotation
                if Size(thirdVertices) = 1 then
                    return (vertsOfEdge[1],vertsOfEdge[2]);
                else
                    return (vertsOfEdge[1],vertsOfEdge[2])(thirdVertices[1],thirdVertices[2]);
                fi;
            else
                Error("CommonCover: Given MRType not complete.");
            fi;
        end;
        taus1 := [];
        for e in Edges(surf1) do
            taus1[e] := TauByMR(surf1, e, mrType1[e]);            
        od;
        taus2 := [];
        for e in Edges(surf2) do
            taus2[e] := TauByMR(surf2, e, mrType2[e]);
        od;

        # 1) 
        # The equivalence relation is defined on the set of pairs
        # [newFace, vertex], where the vertex is a vertex of the first
        # surface and lies in the face of the first surface that is 
        # defined by the newFace.
        vertexBaseSet := [];
        vertexBasePositionsByFace := [];
        for facePos in [1..Size(newFaces)] do
            vertexBasePositionsByFace[facePos] := 
                [Size(vertexBaseSet)+1..Size(vertexBaseSet)+3];
            newFace := newFaces[facePos];
            Append(vertexBaseSet, List(VerticesOfFaces(surf1)[newFace[1]], 
                v -> [facePos,v] ));
        od;


        # We will need a helper function to compute the adjacent face to
        # a given face. If the face is on the boundary, it will be returned.
        # Otherwise its neighbour will be returned.
        # TODO make this into a separate method for IsEdgesLikeSurface
        AdjacentFace := function( surf, face, edge )
            local allFaces;

            allFaces := FacesOfEdges(surf)[edge];
            if Size(allFaces) = 1 then
                return allFaces[1];
            else
                return Difference(allFaces, [face])[1];
            fi;
        end;
        
        # 2)
        # We iterate over the new edges. We represent a new edge as
        # [first edge, second edge, {adjacent new faces} ]
        # Since not all of those combinations are valid, we calculate
        # the adjacent face manually by using the tau-mappings:
        # If tau1 is the  mr-transfer of the first edge and tau2 is the 
        # mr-transfer of the second edge, we have
        # tau2 \circ iso1 = iso2 \circ tau1
        foundPairs := [];
        adjacencyList := [];    # List of adjacencies for the digraph package
        for facePos in [1..Size(newFaces)] do
            newFace := newFaces[facePos];
            # Consider all pairs of possible edges
            for e1 in EdgesOfFaces(surf1)[newFace[1]] do
                # Find the partner edge
                vertOfE2 := List( VerticesOfEdges(surf1)[e1], 
                        v -> Image(newFace[3],v) );
                e2 := EdgeInFaceByVertices(surf2, newFace[2], vertOfE2);
                edgePair := [e1,e2];

                # We need to find the adjacent faces
                adFace1 := AdjacentFace(surf1, newFace[1], edgePair[1]);
                adFace2 := AdjacentFace(surf2, newFace[2], edgePair[2]);
                # Define tau2 and tau1^(-1)
                tau2 := MappingByFunction( Range(newFace[3]), 
                    Domain(VerticesOfFaces(surf2)[adFace2]),
                    function(x) return x^taus2[edgePair[2]]; end );
                tau1 := MappingByFunction( 
                    Domain(VerticesOfFaces(surf1)[adFace1]),
                    Source( newFace[3] ), 
                    function(x) return x^taus1[edgePair[1]]; end );
                # Now we can compute the composition mapping
                otherIso := CompositionMapping( tau2, newFace[3], tau1);
                otherFace := [adFace1, adFace2, otherIso];
                bothFaces := Set( [newFace, otherFace] );

                # Check whether we already found this combination
                found := false;
                for j in [1..Size(foundPairs)] do
                    if edgePair = foundPairs[j][1] and 
                                bothFaces = foundPairs[j][2] then
                        foundPairs[j][3] := Union( foundPairs[j][3], [facePos] );
                        found := true;
                        break;
                    fi;
                od;
                if not found then
                    # We have to add this pair. At this point we also calculate
                    # the vertices.

                    # Compute the pairs of equivalent vertices
                    baseVertPos1 := vertexBasePositionsByFace[facePos];
                    baseVertPos2 := vertexBasePositionsByFace[
                            Position(newFaces, otherFace)];

                    vertOfEdge := VerticesOfEdges(surf1)[edgePair[1]];
                    # Localize the vertices on the common edge
                    baseVertA1 := Filtered( baseVertPos1, p ->
                        vertexBaseSet[p][2] = vertOfEdge[1])[1];
                    baseVertA2 := Filtered( baseVertPos2, p ->
                        vertexBaseSet[p][2] = vertOfEdge[1])[1];
                
                    baseVertB1 := Filtered( baseVertPos1, p ->
                        vertexBaseSet[p][2] = vertOfEdge[2])[1];
                    baseVertB2 := Filtered( baseVertPos2, p ->
                        vertexBaseSet[p][2] = vertOfEdge[2])[1];


                    # Since the isomorphism already connects the faces with
                    # respect to their mr-type, the vertices just have to care
                    # about what is happening on one simplicial surface

                    # The situation for the first surface is:
                    #       baseVertA1 . baseVertA2
                    #                / | \
                    #               /  |  \
                    #              . F1|F2 .
                    #               \  |  /
                    #                \ | /
                    #       baseVertB1 . baseVertB2

                    # Since the vertices of the two surfaces are connected by
                    # their isomorphism, we only work with the vertices of one
                    # surface. But it is easier to imagine that we work with the
                    # pair of vertices in the common cover (instead of a single
                    # vertex in one surface).

                    # If we have an mm or rr-edge-pair, A1 and A2 are identified
                    # Otherwise A1 and B2 are identified.
                    if IsOddInt( mrType1[edgePair[1]] + mrType2[edgePair[2]] ) then
                        # The inverted case
                        Append( adjacencyList,
                            [[baseVertA1,baseVertB2], [baseVertB1, baseVertA2]]);
                    else
                        Append( adjacencyList, 
                            [[baseVertA1, baseVertA2], [baseVertB1, baseVertB2]]);
                    fi;
                    
                    # Finally we add the pair to our list
                    Add(foundPairs, [edgePair, bothFaces, [facePos], 
                        [baseVertA1, baseVertA2, baseVertB1, baseVertB2]]);
                fi;
                #TODO can this be implemented more efficiently?

            od;
        od;

        # Now we have to compute the true vertices by finding the connected
        # components of the graph that we defined with out adjacencyList.
        vertexGraph := DigraphByEdges(adjacencyList);
        connComp := DigraphConnectedComponents(vertexGraph);

        # Now we translate all this information into a simplicial surface.
        # Simultaneously we define the alternative names.
        altNames := rec();

        # Faces
        simpFaces := [1..Size(newFaces)];
        altNames.Faces := List(newFaces, f -> [[f[1],f[2]], 
            [Elements(Source(f[3])), List(Elements(Source(f[3])),
                                e->Image(f[3],e))]]);
        altNames.DescriptionFaces := 
            "[[old face 1, old face 2], bijection of vertices by elements]";

        # Edges and FacesOfEdges and VerticesOfEdges from foundPairs
        simpEdges := [1..Size(foundPairs)];
        altNames.DescriptionEdges := 
            "[ [old edge 1, old edge 2], set of adjacent new faces (as numbers) ]";
        edgeDescription := [];
        simpFacesOfEdges := [];
        simpVerticesOfEdges := [];
        for i in [1..Size(foundPairs)] do
            edge := foundPairs[i];
            edgeDescription[i] := [edge[1],edge[3]];
            simpFacesOfEdges[i] := edge[3];
            simpVerticesOfEdges[i] := Set( List(edge[4], v -> connComp.id[v]) );
        od;
        altNames.Edges := edgeDescription;

        # Vertices from connComp
        simpVertices := [1..Size(connComp.comps)];
        altNames.Vertices := List(connComp.comps, cc ->
            List( cc, pos -> vertexBaseSet[pos] ) );
        altNames.DescriptionVertices :=
            "list of equivalence classes of [new face (as number), old vertex]-pairs";

        # Construct the new simplicial surface
        surface := Objectify( SimplicialSurfaceType, rec() );
        SetVerticesAttributeOfSimplicialSurface(surface, simpVertices);
        SetEdges(surface, simpEdges);
        SetFaces(surface, simpFaces);
        SetFacesOfEdges(surface, simpFacesOfEdges);
        SetVerticesOfEdges(surface, simpVerticesOfEdges);
        SetAlternativeNames(surface, rec( commonCover := altNames) );
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(surface);

        return surface;
    end
);
    RedispatchOnCondition( CommonCover, true, 
	[IsSimplicialSurface, IsSimplicialSurface, IsList, IsList], 
        [IsTriangleSurface and IsEdgesLikeSurface, 
            IsTriangleSurface and IsEdgesLikeSurface,,], 0);


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



##
##           cuts and mends
##
InstallMethod( CraterCuttableEdges, "for an actual surface",
    [IsSimplicialSurface],
    function(surf)
        local innerEdges, innerVertices;

        innerEdges := InnerEdges(surf);
        innerVertices := InnerVertices(surf);
        return Filtered( innerEdges, e -> ForAll( VerticesOfEdges(surf)[e], v -> v in innerVertices ) );
    end
);
InstallMethod(CraterCut, "for an actual surface and an inner edge",
    [IsSimplicialSurface and IsActualSurface, IsPosInt],
    function(surf, edge)
        local verts, verticesOfEdges, facesOfEdges, maxEdge, adFaces, adVerts, obj;

        # Check whether the edge is an inner edge
        verts := VerticesOfEdges(surf)[edge];
        if not verts[1] in InnerVertices(surf) or not verts[2] in InnerVertices(surf) then
            Error("CraterCut: Given edge has to be an inner edge where both vertices are inner.");
        fi;

        verticesOfEdges := ShallowCopy(VerticesOfEdges(surf));
        facesOfEdges := ShallowCopy(FacesOfEdges(surf));
        maxEdge := Maximum(Edges(surf));

        # replace edge by maxEdge+1 and maxEdge+2
        adFaces := facesOfEdges[edge];
        Unbind( facesOfEdges[edge] );
        facesOfEdges[maxEdge+1] := [adFaces[1]];
        facesOfEdges[maxEdge+2] := [adFaces[2]];

        adVerts := verticesOfEdges[edge];
        Unbind( verticesOfEdges[edge] );
        verticesOfEdges[maxEdge+1] := adVerts;
        verticesOfEdges[maxEdge+2] := adVerts;

        obj := Objectify( SimplicialSurfaceType, rec() );
        SetVerticesOfEdges(obj, verticesOfEdges);
        SetFacesOfEdges(obj, facesOfEdges);
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(obj);

        return obj;
    end
);
RedispatchOnCondition( CraterCut, true, [IsSimplicialSurface, IsPosInt], [IsActualSurface], 0 );

InstallMethod( CraterMendableEdgePairs, "for an actual surface",
    [IsSimplicialSurface],
    function(surf)
        local edgeAnomalies, comb;

        edgeAnomalies := List( EdgeAnomalyClasses(surf), cl -> Filtered(cl, e -> IsBoundaryEdge(surf, e)) );
        comb := List( edgeAnomalies, a -> Combinations(a,2) );
        return Union(comb);
    end
);
InstallMethod( CraterMend, "for an actual surface and two edges that form an edge anomaly",
    [IsSimplicialSurface and IsActualSurface, IsPosInt, IsPosInt],
    function(surf, e1, e2)
        local verticesOfEdges, facesOfEdges, obj;

        if VerticesOfEdges(surf)[e1] <> VerticesOfEdges(surf)[e2] then
            Error("CraterMend: Given edges have to form an edge anomaly.");
        fi;

        verticesOfEdges := ShallowCopy( VerticesOfEdges(surf) );
        Unbind(verticesOfEdges[e2]);

        facesOfEdges := ShallowCopy( FacesOfEdges(surf) );
        facesOfEdges[e1] := Union( facesOfEdges[e1], facesOfEdges[e2] );
        Unbind(facesOfEdges[e2]);

        obj := Objectify(SimplicialSurfaceType, rec());
        SetVerticesOfEdges(obj, verticesOfEdges);
        SetFacesOfEdges(obj, facesOfEdges);
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(obj);

        return obj;
    end
);
RedispatchOnCondition( CraterMend, true, [IsSimplicialSurface, IsPosInt, IsPosInt], [IsActualSurface], 0 );


InstallMethod( RipCuttableEdges, "for an actual surface", [IsSimplicialSurface],
    function(surf)
        local innerEdges, innerVertices, boundVertices;

        innerEdges := InnerEdges(surf);
        innerVertices := InnerVertices(surf);
        boundVertices := BoundaryVertices(surf);
        return Filtered( innerEdges, e -> 
            Size( Intersection( innerVertices, VerticesOfEdges(surf)[e] )) = 1
            and Size( Intersection( boundVertices, VerticesOfEdges(surf)[e] ) ) = 1);
    end
);
InstallMethod( RipCut, "for an actual surface and an inner edge where one vertex is inner and one is on the boundary",
    [IsSimplicialSurface and IsActualSurface, IsPosInt],
    function(surf, edge)
        local verts, in1, in2, maxVert, maxEdge, edgesOfVertices, 
            facesOfEdges, innerVert, boundVert, path, pos, edges1,
            edges2, obj;

        verts := VerticesOfEdges(surf)[edge];
        in1 := verts[1] in InnerVertices(surf);
        in2 := verts[2] in InnerVertices(surf);
        if in1 = in2 then
            Error("RipCut: Vertices of given edge have to be one on the boundary, one inner");
        fi;

        maxVert := Maximum(Vertices(surf));
        maxEdge := Maximum(Edges(surf));
        edgesOfVertices := ShallowCopy( EdgesOfVertices(surf) );
        facesOfEdges := ShallowCopy( FacesOfEdges(surf) );

        if in1 then
            innerVert := verts[1];
            boundVert := verts[2];
        else
            innerVert := verts[2];
            boundVert := verts[1];
        fi;

        # Replace boundVert by maxVertex+1 and maxVertex+2
        # Replace edge by maxEdge+1 and maxEdge+2
        edgesOfVertices[innerVert] := Union( [maxEdge+1,maxEdge+2], Difference(edgesOfVertices[innerVert], [edge]) );
        
        # We traverse the path around the vertex and separate the edges
        path := FaceEdgePathsOfVertex(surf, boundVert)[1];
        pos := Positions(path, edge);
        pos := Filtered( pos, IsOddInt );
        Assert(0, Size(pos)=1);
        pos := pos[1];

        # edge is at position pos
        edges1 := List([1..(pos-1)/2], i -> path[2*i-1]);
        edges2 := List([(pos+3)/2..(Size(path)+1)/2], i -> path[2*i-1]);
        Unbind( edgesOfVertices[boundVert] );
        edgesOfVertices[maxVert+1] := Union( edges1, [maxEdge+1] );
        edgesOfVertices[maxVert+2] := Union( edges2, [maxEdge+2] );

        Unbind( facesOfEdges[edge] );
        facesOfEdges[maxEdge+1] := [ path[pos-1] ];
        facesOfEdges[maxEdge+2] := [ path[pos+1] ];

        
        obj := Objectify( SimplicialSurfaceType, rec() );
        SetEdgesOfVertices( obj, edgesOfVertices);
        SetFacesOfEdges( obj, facesOfEdges );
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(obj);

        return obj;
    end
);
RedispatchOnCondition( RipCut, true, [IsSimplicialSurface, IsPosInt], [IsActualSurface], 0 );


InstallMethod( RipMendableEdgePairs, "for an actual surface", [IsSimplicialSurface],
    function(surf)
        local boundEdges, e1, e2, pairs;

        pairs := [];
        boundEdges := BoundaryEdges(surf);
        for e1 in [1..Size(boundEdges)] do
            for e2 in [e1+1..Size(boundEdges)] do
                if Size( Intersection( VerticesOfEdges(surf)[boundEdges[e1]], VerticesOfEdges(surf)[boundEdges[e2]] ) ) = 1 then
                    Add( pairs, [boundEdges[e1], boundEdges[e2]] );
                fi;
            od;
        od;

        return pairs;
    end
);
InstallMethod( RipMend, "for an actual surface and two boundary edges that share a vertex",
    [IsSimplicialSurface and IsActualSurface, IsPosInt, IsPosInt],
    function(surface, e1, e2)
        local commonVertices, commonVertex, v1, v2, obj, edgesOfVertices, facesOfEdges;

        if not e1 in BoundaryEdges(surface) or not e2 in BoundaryEdges(surface) then
            Error("RipMend: The given edges have to be boundary edges.");
        fi;

        commonVertices := Intersection( VerticesOfEdges(surface)[e1], VerticesOfEdges(surface)[e2] );
        if Size(commonVertices) <> 1 then
            Error("RipMend: The given edges should have exactly one vertex in common.");
        fi;

        commonVertex := commonVertices[1];
        v1 := Difference( VerticesOfEdges(surface)[e1], commonVertices )[1];
        v2 := Difference( VerticesOfEdges(surface)[e2], commonVertices )[1];

        edgesOfVertices := ShallowCopy( EdgesOfVertices(surface) );
        edgesOfVertices[v1] := Difference( Union( edgesOfVertices[v1], edgesOfVertices[v2] ), [e2] );
        Unbind( edgesOfVertices[v2] );
        edgesOfVertices[commonVertex] := Difference( edgesOfVertices[commonVertex], [e2] );

        facesOfEdges := ShallowCopy( FacesOfEdges(surface) );
        facesOfEdges[e1] := Union( facesOfEdges[e1], facesOfEdges[e2] );
        Unbind(facesOfEdges[e2]);

        obj := Objectify( SimplicialSurfaceType, rec() );
        SetEdgesOfVertices(obj, edgesOfVertices);
        SetFacesOfEdges(obj, facesOfEdges);
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(obj);
        return obj;
    end
);
RedispatchOnCondition( RipMend, true, [IsSimplicialSurface, IsPosInt, IsPosInt], [IsActualSurface], 0 );


InstallMethod( SplitCuttableEdges, "for an actual surface", [IsSimplicialSurface],
    function(surf)
        local innerEdges, boundVert;

        innerEdges := InnerEdges(surf);
        boundVert := BoundaryVertices(surf);

        return Filtered( innerEdges, e -> IsSubset( boundVert, VerticesOfEdges(surf)[e] ) );
    end
);
InstallMethod( SplitCut, "for an actual surface and an edge whose two vertices are boundary vertices",
    [IsSimplicialSurface and IsActualSurface, IsPosInt],
    function(surf, edge)
        local verts, maxEdge, maxVertex, path1, path2, pos1, pos2,
            edgesOfVertices, facesOfEdges, face1, face2, obj;

        if not edge in Edges(surf) then
            Error("SplitCut: Given edge has to be an edge of the surface.");
        fi;
        verts := VerticesOfEdges(surf)[edge];
        if verts[1] in InnerVertices(surf) or verts[2] in InnerVertices(surf) then
            Error("SplitCut: Vertices of given edge can't be inner vertices.");
        fi;

        maxVertex := Maximum( Vertices(surf) );
        maxEdge := Maximum( Edges(surf) );

        path1 := FaceEdgePathsOfVertex(surf,verts[1])[1];
        path2 := FaceEdgePathsOfVertex(surf,verts[2])[1];
        pos1 := Filtered( Positions(path1, edge), IsOddInt )[1];
        pos2 := Filtered( Positions(path2, edge), IsOddInt )[1];

        edgesOfVertices := ShallowCopy( EdgesOfVertices(surf) );
        facesOfEdges := ShallowCopy( FacesOfEdges(surf) );

        face1 := path1[pos1-1];
        face2 := path1[pos1+1];

        facesOfEdges[maxEdge+1] := [face1];
        facesOfEdges[maxEdge+2] := [face2];
        Unbind(facesOfEdges[edge]);

        edgesOfVertices[verts[1]] := Set( Concatenation( [maxEdge+1], List( [1..(pos1-1)/2], i -> path1[2*i-1] ) ) );
        edgesOfVertices[maxVertex+1] := Set( Concatenation( [maxEdge+2], List( [(pos1+3)/2..(Length(path1)+1)/2], i -> path1[2*i-1] ) ) );

        if path2[pos2-1] = face2 then
            path2 := Reversed(path2);
            pos2 := Length(path2) + 1 - pos2;
        fi;
        edgesOfVertices[verts[2]] := Set( Concatenation( [maxEdge+1], List( [1..(pos2-1)/2], i -> path2[2*i-1] ) ) );
        edgesOfVertices[maxVertex+2] := Set( Concatenation( [maxEdge+2], List( [(pos2+3)/2..(Length(path2)+1)/2], i -> path2[2*i-1] ) ) );

        
        obj := Objectify( SimplicialSurfaceType, rec() );
        SetEdgesOfVertices( obj, edgesOfVertices );
        SetFacesOfEdges( obj, facesOfEdges );
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(obj);
        return obj;
    end
);
RedispatchOnCondition( SplitCut, true, [IsSimplicialSurface,IsPosInt], [IsActualSurface], 0 );


InstallMethod( SplitMendableFlagPairs, "for an actual surface", [IsSimplicialSurface],
    function(surf)
        local boundEdges, i, j, e1, e2, verts1, verts2, flagPairs, v;

        boundEdges := BoundaryEdges(surf);
        flagPairs := [];
        for i in [1..Size(boundEdges)] do
            for j in [i+1..Size(boundEdges)] do
                e1 := boundEdges[i];
                e2 := boundEdges[j];
                verts1 := VerticesOfEdges(surf)[e1];
                verts2 := VerticesOfEdges(surf)[e2];
                if IsEmpty( Intersection( verts1, verts2 ) ) then
                    for v in verts2 do
                        if IsEmpty( Intersection( EdgesOfVertices(surf)[verts1[1]], EdgesOfVertices(surf)[v] ) ) then
                            Add( flagPairs, [ [verts1[1], e1], [v, e2] ] );
                        fi;
                    od;
                fi;
            od;
        od;

        return flagPairs;
    end
);
InstallMethod( SplitMend, "for an actual surface and two 2-flags of vertices-edges",
    [IsSimplicialSurface and IsActualSurface, IsList, IsList],
    function(surf, flag1, flag2)
        local obj, check, edgesOfVertices, facesOfEdges, oV1, oV2;

        check := function( flag )
            if Length(flag) <> 2 then
                Error("SplitMend: Flag has to consist of a vertex and an edge.");
            fi;
            if not flag[1] in Vertices(surf) then
                Error("SplitMend: First entry of flag is not a vertex.");
            fi;
            if not flag[2] in Edges(surf) then
                Error("SplitMend: Second entry of flag is not an edge.");
            fi;

            if not flag[2] in BoundaryEdges(surf) then
                Error("SplitMend: Given edges have to be boundary edges.");
            fi;
        end;
        check(flag1);
        check(flag2);

        edgesOfVertices := ShallowCopy(EdgesOfVertices(surf));
        facesOfEdges := ShallowCopy( FacesOfEdges(surf) );

        if not IsEmpty( Intersection( edgesOfVertices[flag1[1]], edgesOfVertices[flag2[1]] ) ) then
            return fail;
            Error("SplitMend: Given vertices are connected by an edge.");
        fi;
        edgesOfVertices[flag1[1]] := Difference( Union( edgesOfVertices[flag1[1]], edgesOfVertices[flag2[1]] ), [flag2[2]] );
        Unbind( edgesOfVertices[ flag2[1] ] );
        oV1 := Difference( VerticesOfEdges(surf)[flag1[2]], [flag1[1]] )[1];
        oV2 := Difference( VerticesOfEdges(surf)[flag2[2]], [flag2[1]] )[1];
        if not IsEmpty( Intersection( edgesOfVertices[oV1], edgesOfVertices[oV2] ) ) then
            return fail;
            Error("SplitMend: Other vertices of given edges are connected by an edge.");
        fi;
        edgesOfVertices[oV1] := Difference( Union( edgesOfVertices[oV1], edgesOfVertices[oV2] ), [flag2[2]] );
        Unbind( edgesOfVertices[oV2] );
        
        facesOfEdges[flag1[2]] := Union( facesOfEdges[flag1[2]], facesOfEdges[flag2[2]] );
        Unbind( facesOfEdges[flag2[2]] );


        obj := Objectify( SimplicialSurfaceType, rec() );
        SetEdgesOfVertices( obj, edgesOfVertices );
        SetFacesOfEdges( obj, facesOfEdges );
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(obj);
        return obj;
    end
);
RedispatchOnCondition( SplitMend, true, [IsSimplicialSurface, IsList, IsList], [IsActualSurface], 0 );


## Connected sum
InstallMethod( ConnectedSum, "", [IsSimplicialSurface, IsList, IsSimplicialSurface, IsList],
    function( s1, flag1, s2, flag2 )
        local IsFlag, maxVert1, maxEdge1, maxFace1, verticesOfEdges, 
            edgesOfFaces, obj, e, f, verts2, edges2, vertPairs, edgePairs, 
            v2, v2Alt, e1, e1Alt, oldVertices, oldEdges, pair, otherFace; 

        IsFlag := function( surf, flag )
            if Size(flag) <> 3 then
                Error("ConnectedSum: Flag should consist of a vertex, an edge and a face.");
            fi;
            if not flag[1] in Vertices(surf) then
                Error("First element of flag is not a vertex.");
            fi;
            if not flag[2] in Edges(surf) then
                Error("Second element of flag is not an edge.");
            fi;
            if not flag[3] in Faces(surf) then
                Error("Third element of flag is not a face.");
            fi;
            if not flag[1] in VerticesOfEdges(surf)[flag[2]] then
                Error("Vertex is not in edge");
            fi;
            if not flag[2] in EdgesOfFaces(surf)[flag[3]] then
                Error("Edge is not in face");
            fi;
        end;
        IsFlag( s1, flag1 );
        IsFlag( s2, flag2 );

        maxVert1 := Maximum( Vertices(s1) );
        maxEdge1 := Maximum( Edges(s1) );
        maxFace1 := Maximum( Faces(s1) );

        verticesOfEdges := ShallowCopy( VerticesOfEdges(s1) );
        edgesOfFaces := ShallowCopy( EdgesOfFaces(s1) );

        verts2 := VerticesOfEdges(s2);
        edges2 := EdgesOfFaces(s2);

        for e in Edges(s2) do
            verticesOfEdges[maxEdge1+e] := List( verts2[e], x -> x + maxVert1 );
        od;
        for f in Faces(s2) do
            edgesOfFaces[maxFace1+f] := List( edges2[f], x -> x + maxEdge1 );
        od;

        # Now we have the disjoint union

        vertPairs := [];
        edgePairs := [];
        Add(vertPairs, [flag1[1], flag2[1]]);
        Add(edgePairs, [flag1[2], flag2[2]]);
        
        v2 := OtherVertexOfEdgeNC(s1, flag1[1], flag1[2]);
        v2Alt := OtherVertexOfEdgeNC( s2, flag2[1], flag2[2] );
        Add(vertPairs, [v2, v2Alt]);

        e1 := OtherEdgeOfVertexInFaceNC(s1, v2, flag1[2], flag1[3]);
        e1Alt := OtherEdgeOfVertexInFace( s2, v2Alt, flag2[2], flag2[3] );
        Add(edgePairs, [e1, e1Alt]);

        Add( vertPairs, [ OtherVertexOfEdgeNC(s1, v2, e1) , OtherVertexOfEdgeNC(s2, v2Alt, e1Alt) ] );
        Add( edgePairs, [ OtherEdgeOfVertexInFaceNC(s1, flag1[1], flag1[2], flag1[3]), OtherEdgeOfVertexInFaceNC( s2, flag2[1], flag2[2], flag2[3] ) ] );

        Unbind( edgesOfFaces[flag1[3]] );
        for e in EdgesOfFaces(s1)[flag1[3]] do
            otherFace := Difference( FacesOfEdges(s1)[e], [flag1[3]] )[1];
            oldEdges := edgesOfFaces[otherFace];
            for pair in edgePairs do
                if pair[1] in oldEdges then
                    oldEdges := Difference( oldEdges, [pair[1]] );
                    oldEdges := Union( oldEdges, [pair[2]] );
                fi;
            od;
            edgesOfFaces[otherFace] := oldEdges;
        od;
        for e in Edges(s1) do
            oldVertices := verticesOfEdges[e];
            for pair in vertPairs do
                if pair[1] in oldVertices then
                    oldVertices := Difference( oldVertices, [pair[1]] );
                    oldVertices := Union(oldVertices, [pair[2]]);
                fi;
            od;
            verticesOfEdges[e] := oldVertices;
        od;

        obj := Objectify( SimplicialSurfaceType, rec() );
        SetEdgesOfFaces(obj, edgesOfFaces);
        SetVerticesOfEdges(obj, verticesOfEdges);
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(obj);
        return obj;
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



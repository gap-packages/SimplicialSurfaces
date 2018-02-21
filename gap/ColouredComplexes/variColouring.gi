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

InstallMethod( IsEdgeVariColouring, 
    "for an edge coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComp)
        local edges, colours;

        edges := EdgesOfFaces( PolygonalComplex(colComp) );
        colours := List(edges, edg -> List(edg, e -> ColoursOfEdges(colComp)[e]));
        return ForAll(colours, IsDuplicateFree);
    end
);

InstallMethod( IsEdgeExactColouring,
    "for an edge coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComp)
        local nrCol, edges, nrEdges;

        if not IsEdgeVariColouring(colComp) then
            return false;
        fi;

        nrCol := Size( Set( ColoursOfEdges(colComp) ) );
        edges := EdgesOfFaces( PolygonalComplex(colComp) );
        nrEdges := List(edges, Size);
        return nrCol = Maximum(nrEdges);
    end
);


#######################################
##
##      ColouredEdgesOfFaces
##
InstallMethod( ColouredEdgesOfFaceNC,
    "for an edge vari-coloured polygonal complex and a face",
    [IsEdgeColouredPolygonalComplex and IsEdgeVariColouring, IsPosInt],
    function(rbComp, face)
        return ColouredEdgesOfFaces(rbComp)[face];
    end
);
    RedispatchOnCondition( ColouredEdgesOfFaceNC, true, 
        [IsEdgeColouredPolygonalComplex, IsPosInt], 
        [IsEdgeVariColouring,], 0 );

InstallMethod( ColouredEdgesOfFace,
    "for an edge vari-coloured polygonal complex and a face",
    [IsEdgeColouredPolygonalComplex and IsEdgeVariColouring, IsPosInt],
    function(rbComp, face)
        __SIMPLICIAL_CheckFace( PolygonalComplex(rbComp), face, "ColouredEdgesOfFace" );
        return ColouredEdgesOfFaceNC(rbComp,face);
    end
);
    RedispatchOnCondition( ColouredEdgesOfFace, true, 
        [IsEdgeColouredPolygonalComplex,IsPosInt], 
        [IsEdgeVariColouring,], 0 );

InstallMethod( ColouredEdgesOfFaces,
    "for an edge vari-coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex and IsEdgeVariColouring],
    function(rbComp)
        local edges, colEdgesOfFaces, face, edgesOfCol, e;

        colEdgesOfFaces := [];
        for face in Faces( PolygonalComplex(rbComp) ) do
            edges := EdgesOfFaces(PolygonalComplex(rbComp))[face];
            edgesOfCol := [];
            for e in edges do
                edgesOfCol[ ColoursOfEdges(rbComp)[e] ] := e;
            od;
            colEdgesOfFaces[face] := edgesOfCol;
        od;
                
        return colEdgesOfFaces;
    end
);
    RedispatchOnCondition( ColouredEdgesOfFaces, true, 
        [IsEdgeColouredPolygonalComplex], 
        [IsEdgeVariColouring], 0 );


InstallMethod( ColourInvolutions,
    "for an edge vari-coloured ramified polygonal surface",
    [IsEdgeColouredRamifiedPolygonalSurface and IsEdgeVariColouring],
    function(rbComp)
        local invs, cols, col, toList, edges, edge, facesOfEdge;


        invs := [];
        cols := Set( ColoursOfEdges(rbComp) );

        for col in cols do
            # Find edges of this colour
            edges := EdgesOfColours(rbComp)[col];

            # Construct the permutation from a list
            toList := [1..Maximum(Faces(PolygonalComplex(rbComp)))];

            for edge in edges do
                facesOfEdge := FacesOfEdges(PolygonalComplex(rbComp))[edge];
                if Length(facesOfEdge) = 2 then
                    toList[ facesOfEdge[1] ] := facesOfEdge[2];
                    toList[ facesOfEdge[2] ] := facesOfEdge[1];
                fi;
            od;

            invs[col] := PermList( toList );
        od;

        return invs;
    end
);
    RedispatchOnCondition( ColourInvolutions, true, 
        [IsEdgeColouredPolygonalComplex], 
        [IsEdgeVariColouring and IsEdgeColouredRamifiedPolygonalSurface], 0 );


#######################################
##
##      LocalSymmetryOfEdges
##

InstallMethod( IsWildColouredSurface, 
    "for an edge-coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComp)
        return IsEdgeColouredSimplicialSurface(colComp) and IsEdgeExactColouring(colComp);
    end
);

InstallMethod( LocalSymmetryOfEdgesAsNumbers, 
    "for an edge exact-coloured simplicial surface",
    [IsWildColouredSurface],
    function(colSurf)
        local mr, surf, r, verts, faces, e1, e2, e;

        surf := PolygonalComplex(colSurf);

        mr := [];
        for e in Edges(surf) do
            if IsBoundaryEdge(surf,e) then
                mr[e] := 0; # boundary
            else
                verts := VerticesOfEdges(surf)[e];
                faces := FacesOfEdges(surf)[e];
                e1 := OtherEdgeOfVertexInFaceNC(surf,verts[1],e,faces[1]);
                e2 := OtherEdgeOfVertexInFaceNC(surf,verts[1],e,faces[2]);
                if ColoursOfEdges(colSurf)[e1] = ColoursOfEdges(colSurf)[e2] then
                    mr[e] := 1; # mirror
                else
                    mr[e] := 2; # rotation
                fi;
            fi;
        od;

        return mr;
    end
);
    RedispatchOnCondition( LocalSymmetryOfEdgesAsNumbers, true, 
        [IsEdgeColouredPolygonalComplex], 
        [IsWildColouredSurface], 0 );

BindGlobal( "__SIMPLICIAL_LocalSymmetryNamesOfNumber",
    function( e )
        if e = 0 then 
            return "boundary";
        elif e = 1 then 
            return "mirror";
        elif e = 2 then 
            return "rotation";
        else 
            Error("__SIMPLICIAL_LocalSymmetryNamesOfNumber: unknown mr type number");
        fi;
    end
);
InstallMethod( LocalSymmetryOfEdges, 
    "for an edge-coloured simplicial surface",
    [IsWildColouredSurface], 
    function(colSurf)
        local mr;

        mr := LocalSymmetryOfEdgesAsNumbers(colSurf);
        return List(mr, __SIMPLICIAL_LocalSymmetryNamesOfNumber );
    end
);
    RedispatchOnCondition( LocalSymmetryOfEdges, true, 
        [IsEdgeColouredPolygonalComplex], 
        [IsWildColouredSurface], 0 );

InstallMethod( IsTameColouredSurface,
    "for an edge-coloured simplicial surface",
    [IsEdgeColouredPolygonalComplex],
    function(colSurf)
        local mr, c, ind_mr, mrCol;

        if not IsWildColouredSurface(colSurf) then
            return false;
        fi;

        mr := LocalSymmetryOfEdgesAsNumbers(colSurf);

        mrCol := [];
        for c in Colours(colSurf) do
            ind_mr := Set( mr{EdgesOfColours(colSurf)[c]} );
            if 1 in ind_mr and 2 in ind_mr then
                return false;
            fi;
            # Set the colour mr-type
            if 1 in ind_mr then
                mrCol[c] := 1;
            elif 2 in ind_mr then
                mrCol[c] := 2;
            else
                mrCol[c] := 0;
            fi;
        od;
        SetLocalSymmetryOfColoursAsNumbers(colSurf, mrCol);

        return true;
    end
);

InstallMethod( LocalSymmetryOfColoursAsNumbers,
    "for a tame-coloured surface",
    [IsTameColouredSurface],
    function(colSurf)
        return LocalSymmetryOfColoursAsNumbers(colSurf); # The previous check should set the attribute
    end
);
    RedispatchOnCondition( LocalSymmetryOfColoursAsNumbers, true,
        [IsEdgeColouredPolygonalComplex],
        [IsTameColouredSurface], 0);

InstallMethod( LocalSymmetryOfColours,
    "for a tame-coloured surface",
    [IsTameColouredSurface],
    function(colSurf)
        local mr;

        mr := LocalSymmetryOfColoursAsNumbers(colSurf);

        return List(mr, __SIMPLICIAL_LocalSymmetryNamesOfNumber );
    end
);
    RedispatchOnCondition( LocalSymmetryOfColours, true,
        [IsEdgeColouredPolygonalComplex],
        [IsTameColouredSurface], 0);



#######################################
##
##      AllWild...
##

## Surface-variation
InstallOtherMethod( AllWildColouredSurfaces, "for a simplicial surface",
    [IsSimplicialSurface],
    function(simpSurf)
        return AllWildColouredSurfaces(simpSurf, []);
    end
);
    RedispatchOnCondition(AllWildColouredSurfaces, true, [IsPolygonalComplex], [IsSimplicialSurface], 0);
InstallOtherMethod( AllTameColouredSurfaces, "for a simplicial surface",
    [IsSimplicialSurface],
    function(simpSurf)
        return AllTameColouredSurfaces(simpSurf, []);
    end
);
    RedispatchOnCondition(AllTameColouredSurfaces, true, [IsPolygonalComplex], [IsSimplicialSurface], 0);

BindGlobal( "__SIMPLICIAL_WildTameSurface_FixLocalSymmetry",
    function(surface, localSymmetry, name)
        local e, newSym;

        for e in Edges(surface) do
            if IsBound(localSymmetry[e]) then
                if not localSymmetry[e] in [0,1,2] then
                    Error(Concatenation(name, 
                        ": The local symmetry may only take values 0, 1 and 2, but at position ", 
                        String(e), " is a ", 
                        String(localSymmetry[e]), "."));
                fi;
            else
                localSymmetry[e] := 0;
            fi;
        od;

        return localSymmetry;
    end
);

InstallMethod( AllWildColouredSurfaces, "for a simplicial surface and a list",
    [IsSimplicialSurface, IsList],
    function(simpSurf, localSymmetry)
        #local;

        # Initialize localSymmetry
        localSymmetry := __SIMPLICIAL_WildTameSurface_FixLocalSymmetry(simpSurf, localSymmetry, "AllWildColouredSurfaces");

        Error("TODO");
    end
);
    RedispatchOnCondition(AllWildColouredSurfaces, true, [IsPolygonalComplex, IsList], [IsSimplicialSurface], 0);
InstallMethod( AllWildColouredSurfaces, "for a simplicial surface and a list",
    [IsSimplicialSurface, IsList],
    function(simpSurf, localSymmetry)
        #local ;

        # Initialize localSymmetry
        localSymmetry := __SIMPLICIAL_WildTameSurface_FixLocalSymmetry(simpSurf, localSymmetry, "AllTameColouredSurfaces");
        
        Error("TODO");
    end
);
    RedispatchOnCondition(AllTameColouredSurfaces, true, [IsPolygonalComplex,IsList], [IsSimplicialSurface], 0);

## Involution-variation
InstallOtherMethod( AllWildColouredSurfaces, "for three involutions",
    [IsPerm, IsPerm, IsPerm],
    function(gen1, gen2, gen3)
        return AllWildColouredSurfaces( [gen1,gen2,gen3] );
    end
);
InstallOtherMethod( AllTameColouredSurfaces, "for three involutions",
    [IsPerm, IsPerm, IsPerm],
    function(gen1, gen2, gen3)
        return AllTameColouredSurfaces( [gen1,gen2,gen3] );
    end
);

InstallOtherMethod( AllWildColouredSurfaces, 
    "for three involutions and a list", [IsPerm, IsPerm, IsPerm, IsList],
    function(gen1,gen2,gen3, localSymmetry)
        return AllWildColouredSurfaces( [gen1,gen2,gen3], localSymmetry );
    end
);
InstallOtherMethod( AllTameColouredSurfaces, 
    "for three involutions and a list", [IsPerm, IsPerm, IsPerm, IsList],
    function(gen1,gen2,gen3, localSymmetry)
        return AllTameColouredSurfaces( [gen1,gen2,gen3], localSymmetry );
    end
);

InstallOtherMethod( AllWildColouredSurfaces, 
    "for a group with three generators", [IsGroup],
    function(grp)
        return AllWildColouredSurfaces(grp, []);
    end
);
InstallOtherMethod( AllTameColouredSurfaces, 
    "for a group with three generators", [IsGroup],
    function(grp)
        return AllTameColouredSurfaces(grp, []);
    end
);

InstallOtherMethod( AllWildColouredSurfaces, 
    "for a group with three generators and a list", [IsGroup, IsList],
    function(grp, localSymmetry)
        local gens;

        gens := GeneratorsOfGroup(grp);
        if Size(gens) <> 3 then
            Error("AllWildColouredSurfaces: Given group has to have exactly three generators.");
        fi;
        return AllWildColouredSurfaces( gens, localSymmetry );
    end
);
InstallOtherMethod( AllTameColouredSurfaces, 
    "for a group with three generators and a list", [IsGroup, IsList],
    function(grp, localSymmetry)
        local gens;

        gens := GeneratorsOfGroup(grp);
        if Size(gens) <> 3 then
            Error("AllTameColouredSurfaces: Given group has to have exactly three generators.");
        fi;
        return AllTameColouredSurfaces( gens, localSymmetry );
    end
);

InstallOtherMethod( AllWildColouredSurfaces,
    "for a list with three involutions", [IsList],
    function(invList)
        return AllWildColouredSurfaces(invList, []);
    end
);
InstallOtherMethod( AllTameColouredSurfaces,
    "for a list with three involutions", [IsList],
    function(invList)
        return AllTameColouredSurfaces(invList, []);
    end
);

BindGlobal("__SIMPLICIAL_WildTameInvolutions_FixLocalSymmetry",
    function(invList, localSymmetry, name)
        local moved, maxMoved, cycles, newSym, bound, b, n, cycList;

        if Number(invList) <> 3 then
            Error( Concatenation( name,
                ": Given list of involutions has to contain 3 involutions, but actually only has ",
                String(Size(invList)), " elements.") );
        fi;
        if ForAny(invList, i -> not IsPerm(i)) then
            Error( Concatenation( name, 
                ": Elements of given list of involutions have to satisy IsPerm." ) );
        fi;
        if ForAny(invList, g -> not g^2 = One(g)) then
            Error( Concatenation( name,
                ": The first list has to consist of involutions.") );
        fi;

        moved := MovedPoints( invList );
        maxMoved := Maximum(moved);
        moved := [1..maxMoved];

        cycles := List(invList, i -> Cycles(i, moved));
        newSym := [];

        bound := BoundPositions(invList);
        for b in bound do
            # Check the given localSymmetry
            if not IsBound(localSymmetry[b]) or localSymmetry[b] = 0 then
                newSym[b] := List( cycles[b], i -> 0 );
            elif localSymmetry[b] = 1 or localSymmetry[b] = 2 then
                newSym[b] := List( cycles[b], i -> localSymmetry[b] );
            elif IsList(localSymmetry[b]) then
                cycList := [];
                for n in [1..Size(cycles[b])] do
                    if not IsBound(localSymmetry[b][n]) or localSymmetry[b][n] = 0 then
                        cycList[n] := 0;
                    elif localSymmetry[b][n] in [1,2] then
                        cycList[n] := localSymmetry[b][n];
                    else
                        Error(Concatenation(name, 
                            ": The local symmetry list at position ", 
                            String(b), " has the invalid entry ", 
                            String(localSymmetry[b][n]), " at position ", 
                            String(n), 
                            " (entries may only be 0, 1, 2 or unbound.)"));
                    fi;
                od;
                newSym[b] := cycList;
            else
                Error( Concatenation(name, 
                    ": The local symmetry at position ", String(b), 
                    " is neither unbound, 0, 1, 2 or a list.") );
            fi;
        od;

        return newSym;
    end
);

InstallMethod( AllWildColouredSurfaces,
    "for a list with three involutions and a list", [IsList, IsList],
    function(invList, localSymmetry)
        #local;

        localSymmetry := __SIMPLICIAL_WildTameInvolutions_FixLocalSymmetry(
                        invList, localSymmetry, "AllWildColouredSurfaces");
        Error("TODO");
    end
);
InstallMethod( AllTameColouredSurfaces,
    "for a list with three involutions and a list", [IsList, IsList],
    function(invList, localSymmetry)
        #local;

        localSymmetry := __SIMPLICIAL_WildTameInvolutions_FixLocalSymmetry(
                        invList, localSymmetry, "AllTameColouredSurfaces");
        Error("TODO");
    end
);

##
##      End of AllWild...
##
#######################################



#######################################
##
##      Common Cover
##


InstallMethod( CommonCover, 
    "for two simplicial surfaces and local symmetries of edges",
    [IsSimplicialSurface, IsSimplicialSurface, IsList, IsList],
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
                Error("CommonCover: Given LocalSymmetry not complete.");
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
        # components of the graph that we defined with our adjacencyList.
        vertexGraph := DigraphByEdges(adjacencyList);
        connComp := DigraphConnectedComponents(vertexGraph);
        #TODO can GRAPE work with unbound entries in lists?

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
        surface := Objectify( PolygonalComplexType, rec() );
        SetFacesOfEdges(surface, simpFacesOfEdges);
        SetVerticesOfEdges(surface, simpVerticesOfEdges);
        #SetAlternativeNames(surface, rec( commonCover := altNames) );

        return surface;
    end
);
RedispatchOnCondition( CommonCover, true, 
    [IsPolygonalComplex, IsPolygonalComplex, IsList, IsList], 
    [IsSimplicialSurface, IsSimplicialSurface], 0 );



##
##  End of Common Cover
##
#######################################

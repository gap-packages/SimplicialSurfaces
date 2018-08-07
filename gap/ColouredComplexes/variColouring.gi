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

        nrCol := Length( Colours(colComp) );
        edges := EdgesOfFaces( PolygonalComplex(colComp) );
        nrEdges := List(edges, Length);
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
##      ColouredUmbrellasOfVertices
##
InstallMethod( ColouredUmbrellaOfVertexNC,
    "for a wild coloured surface and a vertex",
    [IsWildColouredSurface, IsPosInt],
    function(wildSurf, vertex)
        return ColouredUmbrellasOfVertices(wildSurf)[vertex];
    end
);
    RedispatchOnCondition( ColouredUmbrellaOfVertexNC, true, 
        [IsEdgeColouredPolygonalComplex, IsPosInt], 
        [IsWildColouredSurface], 0 );

InstallMethod( ColouredUmbrellaOfVertex,
    "for a wild coloured surface and a vertex",
    [IsWildColouredSurface, IsPosInt],
    function(wildSurf, vertex)
        __SIMPLICIAL_CheckVertex( PolygonalComplex(wildSurf), vertex, "ColouredUmbrellaOfVertex" );
        return ColouredUmbrellaOfVertexNC(wildSurf,vertex);
    end
);
    RedispatchOnCondition( ColouredUmbrellaOfVertex, true, 
        [IsEdgeColouredPolygonalComplex,IsPosInt], 
        [IsWildColouredSurface], 0 );

InstallMethod( ColouredUmbrellasOfVertices,
    "for a wild coloured surface",
    [IsWildColouredSurface],
    function(wildSurf)
        local umb, colUmb, complex, colUmbs, v;

        complex := PolygonalComplex(wildSurf);
        umb := UmbrellasOfVertices( complex );
        colUmbs := [];
        for v in VerticesAttributeOfVEFComplex(complex) do
            colUmb := Objectify( EdgeColouredEdgeFacePathType, rec() );
            SetPath( colUmb, Path(umb[v]) );
            SetAssociatedVEFComplex( colUmb, complex);
            SetAssociatedEdgeColouredPolygonalComplex(colUmb, wildSurf);
            colUmbs[v] := colUmb;
        od;
        return colUmbs;
    end
);
RedispatchOnCondition( ColouredUmbrellasOfVertices, true,
    [IsEdgeColouredPolygonalComplex], [IsWildColouredSurface], 0);


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
            Error("__SIMPLICIAL_LocalSymmetryNamesOfNumber: unknown local symmetry type number");
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

BindGlobal( "__SIMPLICIAL_AllWildTameColouredSurfaces_SurfaceRecursion",
    function(simpSurf, localSymmetry, onlyTame)
        local edgePosition, i, facePosition, NextBestFacePos, ExtendColouring,
            SetEdgeToColour, colEdgePos, todoFacePos, allColSurfaces, 
            generators, colEdgesOfFaces, startingFace, edges, edgeColSurfaces,
            info, coloursOfEdges, obj, symOfColour;

        # Initialize localSymmetry (ony for onlyTame-case)
        symOfColour := [0,0,0];

        edgePosition := [];
        for i in [1..Length(Edges(simpSurf))] do
            edgePosition[Edges(simpSurf)[i]] := i;
        od;
        facePosition := [];
        for i in [1..Length(Faces(simpSurf))] do
            facePosition[Faces(simpSurf)[i]] := i;
        od;
    

        NextBestFacePos := function( colEdgesOfFaces, todoFacePos, localSymOfEdges )
            local foundPos, f;

            foundPos := 0;
            for f in [1..Length(todoFacePos)] do
                if todoFacePos[f] then
                    # check colEdgesOfFaces at positions
                    # 3*f - 2, 3*f - 1, 3*f
                    if colEdgesOfFaces[3*f - 1] <> 0 then
                        return f;
                    elif localSymOfEdges[colEdgesOfFaces[3*f-2]] <> 0 then
                        return f;
                    # todoFaces only contains faces with at least one colour
                    else
                        if foundPos = 0 then
                            foundPos := f;
                        fi;
                    fi;
                fi;
            od;

            return foundPos;
        end;

        ExtendColouring := function( colEdgesOfFaces, todoFacePos, 
                localSymOfEdges, generators, colEdgePos, symOfColour)
            local nextFacePos, CheckEdgeColour, face, perimeter, neighbour,
                neighEdge, colEdgePos_c, colEdgesOfFaces_c, generators_c,
                localSym_c, edge, edge1, edge2, edgeA, edgeB, commVert,
                todoFacePos_c, colNeigh, colEdge, verts, lastCol, lastEdge,
                edgePerm, vertsA, vertsB, symOfColour_c;

            nextFacePos := NextBestFacePos( colEdgesOfFaces, todoFacePos,
                localSymOfEdges);
#Print( "Call ExtendColouring with nextFacePos ", nextFacePos, "\n" );

            if nextFacePos = 0 then
                # colouring complete
                Add( allColSurfaces, [generators, colEdgePos, localSymOfEdges] );
#Print( "    Finished\n" );
                return;
            fi;
            face := Faces(simpSurf)[nextFacePos];

            CheckEdgeColour := function( face, edge, incVertex, incEdge )
                local neighbour, neighEdge, colEdge;

#Print( "        Call CheckEdgeColour for edge ", edge, "\n" );
                neighbour := face^generators[colEdgePos[edgePosition[edge]]];
                # By construction this can't be a boundary edge
                neighEdge := OtherEdgeOfVertexInFaceNC(simpSurf, incVertex, edge, neighbour);
                colEdge := colEdgePos[ edgePosition[edge] ];
                if colEdgePos[ edgePosition[neighEdge] ] = colEdgePos[ edgePosition[incEdge] ] then
#Print( "            Mirror case (edge ", edge, " with colour ", colEdge, "): " );
                    # mirror case
                    if localSymOfEdges[edge] = 2 or 
                            (onlyTame and symOfColour[colEdge] = 2) then # only bad case
#Print( "break with localSymOfEdges ", localSymOfEdges, " and symOfColour ", symOfColour, ".\n" );
                        return false;
                    fi;
                    localSymOfEdges[edge] := 1;
                    if onlyTame then
                        symOfColour[colEdge] := 1;
                    fi;
#Print( "success\n" );
                else
                    # rotation case
#Print( "            Rotation case (edge ", edge, " with colour ", colEdge, "): " );
                    if localSymOfEdges[edge] = 1  or 
                            (onlyTame and symOfColour[colEdge] = 1) then # only bad case
#Print( "break with localSymOfEdges ", localSymOfEdges, " and symOfColour ", symOfColour, ".\n" );
                        return false;
                    fi;
                    localSymOfEdges[edge] := 2;
                    if onlyTame then
                        symOfColour[colEdge] := 2;
                    fi;
#Print( "success\n" );
                fi;
                return true;
            end;

            if colEdgesOfFaces[3*nextFacePos] <> 0 then
#Print( "    3 edges already coloured:\n" );
                # all three edges are already coloured
                # check for consistency (assume that coloured edges don't have their
                # local symmetry defined)
                # we also assume that the three colours are different (checked
                # in the extension of the generators)
                perimeter := PathAsList(PerimetersOfFaces(simpSurf)[face]);
                # Since we have only triangles, PathAsList is a list with 7 entries
                if not CheckEdgeColour( face, perimeter[2], perimeter[3], perimeter[4] ) then
                    return;
                fi;
                if not CheckEdgeColour( face, perimeter[4], perimeter[5], perimeter[6] ) then
                    return;
                fi;
                if not CheckEdgeColour( face, perimeter[6], perimeter[1], perimeter[2] ) then
                    return;
                fi;

                todoFacePos[nextFacePos] := false;
#Print( "          symOfColour: ", symOfColour, "\n" );
                ExtendColouring(colEdgesOfFaces, todoFacePos, localSymOfEdges, generators, colEdgePos, symOfColour);
            elif colEdgesOfFaces[3*nextFacePos - 1] <> 0 then
#Print( "    2 edges are already coloured:\n" );
                # two edges are already coloured
                edgeA := colEdgesOfFaces[3*nextFacePos-2];
                edgeB := colEdgesOfFaces[3*nextFacePos-1];
                # find intersecting vertex
                vertsA := VerticesOfEdges(simpSurf)[edgeA];
                vertsB := VerticesOfEdges(simpSurf)[edgeB];
                if vertsA[1] = vertsB[1] or vertsA[1] = vertsB[2] then
                    commVert := vertsA[1];
                else
                    commVert := vertsA[2];
                fi;

                if not CheckEdgeColour( face, edgeA, commVert, edgeB ) then
                    return;
                fi;
                if not CheckEdgeColour( face, edgeB, commVert, edgeA ) then
                    return;
                fi;

                lastCol := 6 - colEdgePos[edgePosition[edgeA]] - colEdgePos[edgePosition[edgeB]];
                # find last edge via edge permutation
                edgePerm := EdgesAsPerm( PerimetersOfFaces(simpSurf)[face] );
                lastEdge := edgeA^edgePerm;
                if lastEdge = edgeB then
                    lastEdge := edgeB^edgePerm;
                fi;
                if SetEdgeToColour( edgePosition[lastEdge], nextFacePos, 
                    lastCol, colEdgesOfFaces, todoFacePos, generators,
                    colEdgePos) then
                    # Unique extension
                    todoFacePos[nextFacePos] := false;
#Print( "          symOfColour: ", symOfColour, "\n" );
                    ExtendColouring(colEdgesOfFaces, todoFacePos, localSymOfEdges, generators, colEdgePos, symOfColour);
                else
                    return;
                fi;
            elif colEdgesOfFaces[3*nextFacePos-2] <> 0 then
#Print( "    1 edge is already coloured:\n" );
                # only one edge already coloured
                edge := colEdgesOfFaces[3*nextFacePos-2];
                colEdge := colEdgePos[edgePosition[edge]];
                verts := VerticesOfEdges(simpSurf)[edge];
                neighbour := face^generators[colEdge];
                neighEdge := OtherEdgeOfVertexInFaceNC(simpSurf, verts[1], edge, neighbour);
                colNeigh := colEdgePos[edgePosition[neighEdge]];

                edge1 := OtherEdgeOfVertexInFaceNC(simpSurf, verts[1], edge, face);
                edge2 := OtherEdgeOfVertexInFaceNC(simpSurf, verts[2], edge, face);

                if localSymOfEdges[edge] <> 2 and (not onlyTame or symOfColour[colEdge] <> 2) then
#Print( "        Mirror is possible for facePos ", nextFacePos, ": \n" );
                    # mirror is possible
                    colEdgesOfFaces_c := ShallowCopy(colEdgesOfFaces);
                    todoFacePos_c := ShallowCopy(todoFacePos);
                    localSym_c := ShallowCopy(localSymOfEdges);
                    generators_c := ShallowCopy(generators);
                    colEdgePos_c := ShallowCopy(colEdgePos);
                    symOfColour_c := ShallowCopy(symOfColour);

                    # edge1 becomes the same colour as neighEdge
                    if SetEdgeToColour( edgePosition[edge1], nextFacePos, 
                        colNeigh, colEdgesOfFaces_c, todoFacePos_c,
                        generators_c, colEdgePos_c) and
                       SetEdgeToColour( edgePosition[edge2], nextFacePos, 
                        6-colNeigh-colEdge, colEdgesOfFaces_c, todoFacePos_c,
                        generators_c, colEdgePos_c) then
                        # continue this colouring
                        todoFacePos_c[nextFacePos] := false;
                        localSym_c[edge] := 1;
                        if onlyTame then
                            symOfColour_c[colEdge] := 1;
#Print( "          symOfColour: ", symOfColour_c, "\n" );
                        fi;
                        ExtendColouring(colEdgesOfFaces_c, todoFacePos_c, localSym_c, generators_c, colEdgePos_c, symOfColour_c);
                    fi;
                fi;
                if localSymOfEdges[edge] <> 1 and (not onlyTame or symOfColour[colEdge] <> 1) then
#Print( "        Rotation is possible for facePos ", nextFacePos, ": \n" );
                    # rotation is possible
                    colEdgesOfFaces_c := ShallowCopy(colEdgesOfFaces);
                    todoFacePos_c := ShallowCopy(todoFacePos);
                    localSym_c := ShallowCopy(localSymOfEdges);
                    generators_c := ShallowCopy(generators);
                    colEdgePos_c := ShallowCopy(colEdgePos);
                    symOfColour_c := ShallowCopy(symOfColour);

                    # edge2 becomes the same colour as neighEdge
                    if SetEdgeToColour( edgePosition[edge2], nextFacePos, 
                        colNeigh, colEdgesOfFaces_c, todoFacePos_c,
                        generators_c, colEdgePos_c) and
                       SetEdgeToColour( edgePosition[edge1], nextFacePos, 
                        6-colNeigh-colEdge, colEdgesOfFaces_c, todoFacePos_c,
                        generators_c, colEdgePos_c) then
                        # continue this colouring
                        todoFacePos_c[nextFacePos] := false;
                        localSym_c[edge] := 2;
                        if onlyTame then
                            symOfColour_c[colEdge] := 2;
#Print( "          symOfColour: ", symOfColour_c, "\n" );
                        fi;
                        ExtendColouring(colEdgesOfFaces_c, todoFacePos_c, localSym_c, generators_c, colEdgePos_c, symOfColour_c);
                    fi;
                fi;
            else
                # This should not have happened if the surface was connected
                Error("AllWildColouredSurfaces: Surface not connected.");
            fi;

        end;

        SetEdgeToColour := function( edgePos, lastFacePos, colour, colEdgesOfFaces, 
                todoFacePos, generators, colEdgePos)
            local neighbour, neighbourPos, lastFace, gen, basePos;
#Print("            Call SetEdgeToColour for edge position ", edgePos, " and colour ", colour, ": " );

            neighbour := NeighbourFaceByEdgeNC( simpSurf, 
                Faces(simpSurf)[lastFacePos], Edges(simpSurf)[edgePos] );
            colEdgePos[edgePos] := colour;
            if neighbour <> fail then
                # inner edge
                neighbourPos := facePosition[neighbour];
                todoFacePos[neighbourPos] := true;
                lastFace := Faces(simpSurf)[lastFacePos];

                # Add the face transposition to the generator
                # Check whether the generator already moves neighbour
                gen := generators[colour];
                if lastFace^gen = lastFace and neighbour^gen = neighbour then
                    # Transposition is new
                    gen := gen * (lastFace, neighbour);
                else
#Print( "fail\n" );
                    return false;
                fi;
                generators[colour] := gen;

                # Add the edge to colEdgesOfFaces
                basePos := 3*neighbourPos - 2;
                if colEdgesOfFaces[basePos] = 0 then
                    colEdgesOfFaces[basePos] := Edges(simpSurf)[edgePos];
                elif colEdgesOfFaces[basePos + 1] = 0 then
                    colEdgesOfFaces[basePos+1] := Edges(simpSurf)[edgePos];
                else
                    colEdgesOfFaces[basePos+2] := Edges(simpSurf)[edgePos];
                fi;

            fi; # Otherwise boundary edge, nothing to do
#Print( "success\n" );
            return true;
        end;

        # store which edge positions are coloured how
        colEdgePos := List(Edges(simpSurf), i -> 0);
        # store the coloured edges for each face:
        # [ colEdge1 of face 1, colEdge2 of face 1, colEdge3 of face 1, colEdge1 of face 2, ... ]
        # the list is dense (indexed by facePositions)
        # entry is 0 if edge is not coloured
        # entry is number of coloured edge if it is coloured
        # entries for each face are not necessarily sorted
        # smaller indices are filled first
        colEdgesOfFaces := ListWithIdenticalEntries(3*Length(Faces(simpSurf)),0);

        startingFace := Faces(simpSurf)[1];
        edges := EdgesOfFaces(simpSurf)[startingFace];
        todoFacePos := List(Faces(simpSurf), i -> false);
        generators := [ (),(),() ];

        # Initialise colours for first face
        for i in [1,2,3] do
            SetEdgeToColour( edgePosition[edges[i]], 
                facePosition[startingFace], i, colEdgesOfFaces, todoFacePos,
                generators, colEdgePos);
        od;

        allColSurfaces := [];
        ExtendColouring( colEdgesOfFaces, todoFacePos, localSymmetry, generators, colEdgePos, symOfColour);

        # transform the colour information into edge coloured surfaces
        edgeColSurfaces := [];
        for info in allColSurfaces do
            obj := Objectify( EdgeColouredPolygonalComplexType, rec() );
            SetPolygonalComplex(obj, simpSurf);
            SetIsWildColouredSurface(obj, true);
            SetColourInvolutions(obj, info[1]);

            colEdgePos := info[2];
            coloursOfEdges := [];
            for i in [1..Length(Edges(simpSurf))] do
                coloursOfEdges[Edges(simpSurf)[i]] := colEdgePos[i];
            od;
            SetColoursOfEdges(obj, coloursOfEdges);

            SetLocalSymmetryOfEdgesAsNumbers(obj, info[3]);

            Add( edgeColSurfaces, obj );
        od;
    
        return edgeColSurfaces;
    end
);

InstallMethod( AllWildColouredSurfaces, "for a simplicial surface and a list",
    [IsSimplicialSurface, IsList],
    function(simpSurf, localSymmetry);
        # Initialize localSymmetry
        localSymmetry := __SIMPLICIAL_WildTameSurface_FixLocalSymmetry(simpSurf, localSymmetry, "AllWildColouredSurfaces");
        return __SIMPLICIAL_AllWildTameColouredSurfaces_SurfaceRecursion(simpSurf, localSymmetry, false);
    end
);
    RedispatchOnCondition(AllWildColouredSurfaces, true, [IsPolygonalComplex, IsList], [IsSimplicialSurface], 0);
InstallMethod( AllTameColouredSurfaces, "for a simplicial surface and a list",
    [IsSimplicialSurface, IsList],
    function(simpSurf, localSymmetry)
        # Initialize localSymmetry
        localSymmetry := __SIMPLICIAL_WildTameSurface_FixLocalSymmetry(simpSurf, localSymmetry, "AllTameColouredSurfaces");
        return __SIMPLICIAL_AllWildTameColouredSurfaces_SurfaceRecursion(simpSurf, localSymmetry, true);
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
        if Length(gens) <> 3 then
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
        if Length(gens) <> 3 then
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
    function(invList, localSymmetry, name, onlyTame)
        local moved, maxMoved, cycles, newSym, bound, b, n, cycList, cycSet;

        if Number(invList) <> 3 then
            Error( Concatenation( name,
                ": Given list of involutions has to contain 3 involutions, but actually only has ",
                String(Length(invList)), " elements.") );
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

        bound := __SIMPLICIAL_BoundPositions(invList);
        for b in bound do
            # Check the given localSymmetry
            if not IsBound(localSymmetry[b]) or localSymmetry[b] = 0 then
                newSym[b] := List( cycles[b], i -> 0 );
            elif localSymmetry[b] = 1 or localSymmetry[b] = 2 then
                newSym[b] := List( cycles[b], i -> localSymmetry[b] );
            elif IsList(localSymmetry[b]) then
                cycList := [];
                for n in [1..Length(cycles[b])] do
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
                cycSet := Set(cycList);
                if onlyTame and 1 in cycSet and 2 in cycSet then
                    Error(Concatenation(name,
                        ": The local symmetry for colour ",
                        String(b), 
                        " has to be unique for a tame colouring."));
                fi;
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
BindGlobal( "__SIMPLICIAL_AllWildTameColouredSurfaces_InvolutionSetup",
    function(invList, localSymmetry)
        local faces, facePosition, facesOfEdges, coloursOfEdges,
            invOfEdges, edgesOfFacesByColour, p, cyc, i, f, edgesOfFaces, vertexNames;
        
        faces := MovedPoints( Group(invList) );
        # The faces can have holes, but we still want to have fast access 
        # to the position of a face in this list
        facePosition := [];
        for i in [1..Length(faces)] do
            facePosition[faces[i]] := i;
        od;

        facesOfEdges := [];
        coloursOfEdges := [];
        invOfEdges := [];
        edgesOfFacesByColour := List(facePosition, i -> []);
        for p in __SIMPLICIAL_BoundPositions(invList) do
            cyc := Cycles( invList[p], faces );
            # Loop over all edges of colour p
            for i in [1..Length(cyc)] do
                for f in cyc[i] do
                    # Problem: The numbers "i" start at 1, NOT at the
                    # appropriate position in facesOfEdges. Therefore
                    # we shift the edges in iterations > 1 by the number
                    # of edges from the previous colours
                    edgesOfFacesByColour[f][p] := Length(facesOfEdges) + i;
                od;
            od;
            Append( coloursOfEdges, List(cyc, c -> p) );
            Append(facesOfEdges, cyc );
            Append( invOfEdges, List(cyc, c -> invList[p]) );
        od;

        edgesOfFaces := __SIMPLICIAL_InvertIncidence_ManyOfMany(faces, facesOfEdges, [1..Length(facesOfEdges)]);
        vertexNames := Concatenation( List( faces, f -> 
            List( Combinations(edgesOfFaces[f],2), c -> [f,c[1],c[2]] ) ) );

        return [faces, facePosition, coloursOfEdges, facesOfEdges, invOfEdges,
            edgesOfFacesByColour, edgesOfFaces, vertexNames];
   end
);

BindGlobal( "__SIMPLICIAL_AllWildTameColouredSurfaces_InvolutionRecursion",
    function( invList, localSymmetry, setup )
        local faces, facePosition, coloursOfEdges, localSymOfEdges, invOfEdges,
            edgesOfFacesByColour, edgesOfFaces, vertexNames, allWildSurfaces,
            BestNextVertex, ExtendColouring, FindWildColouredSurface,
            AddUmbrellaStep, LoopOneVertex, facesOfEdges, allUmbrellas;

        faces := setup[1];
        facePosition := setup[2];
        coloursOfEdges := setup[3];
        facesOfEdges := setup[4];
        invOfEdges := setup[5];
        edgesOfFacesByColour := setup[6];
        edgesOfFaces := setup[7];
        vertexNames := setup[8];

        localSymOfEdges := Concatenation(localSymmetry);

        # Since the algorithm works recursively by constructing umbrellas, it 
        # is optimal if the next face is adjacent to the previously constructed
        # umbrellas.
        BestNextVertex := function( usedVertexNames, finVertsInFaces )
            local face, v, pos;

            face := Position( finVertsInFaces, 2 );
            if face = fail then
                face := Position( finVertsInFaces, 1 );
                if face = fail then
                    face := Position( finVertsInFaces, 0 );
                    if face = fail then
                        return false; # All faces are completed
                    fi;
                fi;
            fi;
            # face should be the face with highest number of already existing vertices

            # The vertices in the face "face" are at positions
            # 3*facePos[face]-3 + {1,2,3}
            pos := 3*facePosition[face]-2;
            for v in [pos, pos+1, pos+2] do
                if not usedVertexNames[v] then
                    return v;
                fi;
            od;
        end;

        FindWildColouredSurface := function( finUmbrellas, usedVertexNames, 
                    finVertsInFaces, partialLocalSym )
            local nextPos, next, face, facePos, e1, e2, umbrella, allUmbrellas_c,
                umbInfo, finVertsInFaces_c, finUmbrellas_c, 
                usedVertexNames_c, obj, partialLocalSym_c, colSurf, knownFaces;

            nextPos := BestNextVertex( usedVertexNames, finVertsInFaces );
            if nextPos = false then
                # no more free vertices
                
                # construction of the simplicial surface
                obj := Objectify( PolygonalComplexType, rec() );
                SetFacesOfEdges(obj, facesOfEdges);
                SetFaces(obj, faces);
                SetEdgesOfFaces(obj, edgesOfFaces);
                SetUmbrellasOfVertices(obj, 
                    List(finUmbrellas, ls -> EdgeFacePathNC(obj,ls)));

                # construction of the coloured surface
                colSurf := Objectify( EdgeColouredPolygonalComplexType, rec() );
                SetColoursOfEdges(colSurf, coloursOfEdges);
                SetLocalSymmetryOfEdgesAsNumbers(colSurf, partialLocalSym);
                SetColouredEdgesOfFaces(colSurf, edgesOfFacesByColour);
                SetPolygonalComplex(colSurf, obj);
                
                Add( allWildSurfaces, colSurf );
                return;
            fi;
            next := vertexNames[nextPos];

            # Compute all possible umbrellas
            face := next[1];
            facePos := facePosition[face];
            e1 := next[2];
            e2 := next[3];
            umbrella := [e1, face, e2];
            usedVertexNames[nextPos] := true;
            finVertsInFaces[face] := finVertsInFaces[face] + 1;
            knownFaces := List(faces, x -> false);
            knownFaces[facePos] := true;
            

            # Recursive computation
            allUmbrellas := [];
            LoopOneVertex( umbrella, knownFaces, usedVertexNames, 
                finVertsInFaces, partialLocalSym );


            # For convenience "allUmbrellas" is a general global variable 
            # and WILL be changed in the following loop
            allUmbrellas_c := ShallowCopy(allUmbrellas);
            for umbInfo in allUmbrellas_c do
                finUmbrellas_c := ShallowCopy(finUmbrellas);
                Add(finUmbrellas_c, umbInfo[1]);
                usedVertexNames_c := ShallowCopy(umbInfo[2]);
                finVertsInFaces_c := ShallowCopy(umbInfo[3]);
                partialLocalSym_c := ShallowCopy(umbInfo[4]);
                FindWildColouredSurface( finUmbrellas_c, usedVertexNames_c, 
                    finVertsInFaces_c, partialLocalSym_c );
            od;
        end;

        AddUmbrellaStep := function( umbrella, lastEdge, nextFace, nextEdge, 
            knownFaces, usedVertexNames, finVertsInFaces, partialLocalSym)

            local basePos, pos, umbrella_c, knownFaces_c, finVertsInFaces_c,
                usedVertexNames_c;

            umbrella_c := Concatenation(umbrella, [nextFace, nextEdge]);
            knownFaces_c := ShallowCopy(knownFaces);
            knownFaces_c[facePosition[nextFace]] := true;
            finVertsInFaces_c := ShallowCopy(finVertsInFaces);
            finVertsInFaces_c[nextFace] := finVertsInFaces_c[nextFace] + 1;
            Assert(1, finVertsInFaces_c[nextFace] <= 3);
            usedVertexNames_c := ShallowCopy(usedVertexNames);

            # find [ nextFace, lastEdge, nextEdge ] in vertexNames
            # its position has to be 3*facePosition[nextFace]-3 + {1,2,3}
            basePos := 3*facePosition[nextFace] - 3;
            if lastEdge < nextEdge then
                for pos in [basePos + 1, basePos + 2, basePos + 3] do
                    if vertexNames[pos] = [ nextFace, lastEdge, nextEdge ] then
                        Assert(1, usedVertexNames_c[pos] = false);
                        usedVertexNames_c[pos] := true;
                        break;
                    fi;
                od;
            else
                for pos in [basePos + 1, basePos + 2, basePos + 3] do
                    if vertexNames[pos] = [ nextFace, nextEdge, lastEdge ] then
                        Assert(1, usedVertexNames_c[pos] = false);
                        usedVertexNames_c[pos] := true;
                        break;
                    fi;
                od;
            fi;
            LoopOneVertex( umbrella_c, knownFaces_c, usedVertexNames_c, 
                finVertsInFaces_c, partialLocalSym );
        end;

        # LoopOneVertex does not return anything but modifies the variable
        # allUmbrellas in the above function.
        # It will write the following information in that list:
        # [ umbrella, usedVertexNames, finVertsInFaces ]
        LoopOneVertex := function( umbrella, 
            knownFaces, usedVertexNames, finVertsInFaces, partialLocalSym )

            local firstEdge, localSym, lastEdge, lastFace, nextFace, prevEdge,
                prevCol, lastCol, nextCol, nextEdge, partial_c;

#Print("Call LoopOneVertex with umbrella ", umbrella, "\n");
            if umbrella[1] = umbrella[Length(umbrella)] then
                # The umbrella closes
                # We check which LocalSymmetry the first/last edge should
                # have and compare this with the actual value (if available)
                firstEdge := umbrella[1];
                if coloursOfEdges[umbrella[3]] = 
                    coloursOfEdges[umbrella[Length(umbrella)-2]] then
                        localSym := 1;
                else
                    localSym := 2;
                fi;
#Print("     Umbrella closes.\n");

                if partialLocalSym[firstEdge] = 0 or 
                    partialLocalSym[firstEdge] = localSym then
                        partialLocalSym[firstEdge] := localSym;
                        Add(allUmbrellas, [umbrella, usedVertexNames, 
                            finVertsInFaces, partialLocalSym]);
#Print("         Add ", umbrella, "\n");
                fi;
                # Otherwise this does not work out
                return;
            fi;

            lastFace := umbrella[Length(umbrella)-1];
            lastEdge := umbrella[Length(umbrella)];
            nextFace := lastFace^invOfEdges[lastEdge];

            if lastFace = nextFace then
                # boundary edge
                partialLocalSym[lastEdge] := 0; #MB should this rather throw an error?

#Print("     Found boundary edge.\n");
                # check first if the umbrella is complete
                if Length(facesOfEdges[umbrella[1]]) = 1 then
                    # The other side of the umbrella is also a boundary edge
                    Add(allUmbrellas, [umbrella, usedVertexNames, 
                        finVertsInFaces, partialLocalSym]);
#Print("         Add ", umbrella, "\n");
                    return;
                fi;

                # We have to reverse course
#Print("         Reverse course.\n");
                LoopOneVertex( Reversed(umbrella), knownFaces, 
                    usedVertexNames, finVertsInFaces, partialLocalSym );
                return;
            elif knownFaces[nextFace] then
#Print("         Illegal continuation. Abort.\n");
                # this is an error since we never construct a face of an umbrella twice
                return;
            else
#Print("         Continue constructing along edge ", lastEdge, ".\n");
                # continue construction of umbrella
                prevEdge := umbrella[Length(umbrella)-2];
                prevCol := coloursOfEdges[prevEdge];
                lastCol := coloursOfEdges[lastEdge];
                # For more than two local symmetries this will not work
                if partialLocalSym[lastEdge] <> 2 then
                    # mirror is possible
#Print("             Try out mirror.\n");
                    nextCol := prevCol;
                    nextEdge := edgesOfFacesByColour[nextFace][nextCol];
                    partial_c := ShallowCopy(partialLocalSym);
                    partial_c[lastEdge] := 1;
                    AddUmbrellaStep(umbrella, lastEdge, nextFace, nextEdge, 
                        knownFaces, usedVertexNames, finVertsInFaces, partial_c);
                fi;
                if partialLocalSym[lastEdge] <> 1 then
                    # rotation is possible
#Print("             Try out rotation.\n");
                    nextCol := 6 - lastCol - prevCol;
                    nextEdge := edgesOfFacesByColour[nextFace][nextCol];
                    partial_c := ShallowCopy(partialLocalSym);
                    partial_c[lastEdge] := 2;
                    AddUmbrellaStep(umbrella, lastEdge, nextFace, nextEdge, 
                        knownFaces, usedVertexNames, finVertsInFaces, partial_c);
                fi;
            fi;
        end;
        
        allWildSurfaces := [];
        FindWildColouredSurface( [], List( vertexNames, n -> false ), 
            List( faces, f -> 0 ), localSymOfEdges );

        return allWildSurfaces;
    end
);

InstallMethod( AllWildColouredSurfaces,
    "for a list with three involutions and a list", [IsList, IsList],
    function(invList, localSymmetry)
        local faces, facesOfEdges, coloursOfEdges, allWildSurfaces,
            allUmbrellas, BestNextVertex, LoopOneVertex, FindWildColouredSurface,
            facePosition, localSymOfEdges, invOfEdges, edgesOfFacesByColour,
            vertexNames, AddUmbrellaStep, edgesOfFaces, setup;

        localSymmetry := __SIMPLICIAL_WildTameInvolutions_FixLocalSymmetry(
                        invList, localSymmetry, "AllWildColouredSurfaces", false);
        setup := __SIMPLICIAL_AllWildTameColouredSurfaces_InvolutionSetup(invList, localSymmetry);
        return __SIMPLICIAL_AllWildTameColouredSurfaces_InvolutionRecursion(
            invList, localSymmetry, setup);
    end
);

InstallMethod( AllTameColouredSurfaces,
    "for a list with three involutions and a list", [IsList, IsList],
    function(invList, localSymmetry)
        local setup, possTameSym, b, set, i, bound, poss, sym, allTameSurf;

        localSymmetry := __SIMPLICIAL_WildTameInvolutions_FixLocalSymmetry(
                        invList, localSymmetry, "AllTameColouredSurfaces", true);
        setup := __SIMPLICIAL_AllWildTameColouredSurfaces_InvolutionSetup(invList, localSymmetry);

        bound := __SIMPLICIAL_BoundPositions(invList);

        possTameSym := [];
        for i in [1..Length(bound)] do
            b := bound[i];
            set := Set(localSymmetry[b]);
            if 1 in set or 2 in set then
                # only one option
                possTameSym[i] := [ localSymmetry[b] ];
            else
                # two options
                possTameSym[i] := [ List(localSymmetry[b], i -> 1), List(localSymmetry[b], i -> 2) ];
            fi;
        od;
        
        allTameSurf := [];
        # Combine the possible local symmetries
        possTameSym := Cartesian( possTameSym );
        for poss in possTameSym do
            # Reconvert into actual bound positions
            sym := [];
            for i in [1..Length(bound)] do
                sym[bound[i]] := poss[i];
            od;

            Append(allTameSurf, 
                __SIMPLICIAL_AllWildTameColouredSurfaces_InvolutionRecursion(
                    invList, sym, setup));
        od;

        return allTameSurf;
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

# From a directed adjacency list (each pair is a set) compute the connected
# components of the associated undirected graph.
# The components are returned as a record with two entries:
# id: A list, for each vertex it gives the number of its connected component
# comps: A list, which stores the connected components as lists of vertices
if IsPackageMarkedForLoading( "Digraphs", "0.10.1" ) then
    BindGlobal( "__SIMPLICIAL_ComputeConnectedComponents",
        function(adjacencyList)
            local digraph;

            digraph := DigraphByEdges(adjacencyList);
            return DigraphConnectedComponents(digraph);
        end
    );
elif IsPackageMarkedForLoading( "GRAPE", "4.7" ) then
    BindGlobal( "__SIMPLICIAL_ComputeConnectedComponents",
        function(adjacencyList)
            local symAd, graph, max, pos, pair,
                comps, compRec, v, id;

            max := 0;
            symAd := [];
            pos := 1;
            for pair in adjacencyList do
                # Each pair is a set
                if pair[2] > max then
                    max := pair[2];
                fi;
                symAd[pos] := pair;
                symAd[pos+1] := [pair[2],pair[1]];
                pos := pos+2;
            od;
            graph := EdgeOrbitsGraph( Group(()), symAd, max );

            comps := ConnectedComponents(graph);
            # This is a list of vertex lists
            compRec := rec();
            compRec.comps := comps;
            id := [];
            for v in Vertices(graph) do
                id[v] := PositionProperty(comps, c -> v in c);
            od;
            compRec.id := id;
            return compRec;
        end
    );
else
    BindGlobal( "__SIMPLICIAL_ComputeConnectedComponents",
        function(adjacencyList)
            Error("CommonCover: Neither Digraphs nor GRAPE are loaded.");
        end
    );
fi;

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
            connComp, edgeDescription, i, edge, 
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
            allImages := Arrangements(vert2, Length(vert2));
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
        if Length(thirdVertices) = 1 then
        return ();
        else
        return (thirdVertices[1],thirdVertices[2]);
        fi;
        elif mr = 2 then # rotation
        if Length(thirdVertices) = 1 then
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
        for facePos in [1..Length(newFaces)] do
        vertexBasePositionsByFace[facePos] := 
        [Length(vertexBaseSet)+1..Length(vertexBaseSet)+3];
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
        if Length(allFaces) = 1 then
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
        for facePos in [1..Length(newFaces)] do
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
        for j in [1..Length(foundPairs)] do
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
        connComp := __SIMPLICIAL_ComputeConnectedComponents(adjacencyList);

        # Now we translate all this information into a simplicial surface.
        # Simultaneously we define the alternative names.
        altNames := rec();

        # Faces
        simpFaces := [1..Length(newFaces)];
        altNames.Faces := List(newFaces, f -> [[f[1],f[2]], 
            [Elements(Source(f[3])), List(Elements(Source(f[3])),
                                e->Image(f[3],e))]]);
        altNames.DescriptionFaces := 
            "[[old face 1, old face 2], bijection of vertices by elements]";

        # Edges and FacesOfEdges and VerticesOfEdges from foundPairs
        simpEdges := [1..Length(foundPairs)];
        altNames.DescriptionEdges := 
            "[ [old edge 1, old edge 2], set of adjacent new faces (as numbers) ]";
        edgeDescription := [];
        simpFacesOfEdges := [];
        simpVerticesOfEdges := [];
        for i in [1..Length(foundPairs)] do
            edge := foundPairs[i];
            edgeDescription[i] := [edge[1],edge[3]];
            simpFacesOfEdges[i] := edge[3];
            simpVerticesOfEdges[i] := Set( List(edge[4], v -> connComp.id[v]) );
        od;
        altNames.Edges := edgeDescription;

        # Vertices from connComp
        simpVertices := [1..Length(connComp.comps)];
        altNames.Vertices := List(connComp.comps, cc ->
            List( cc, pos -> vertexBaseSet[pos] ) );
        altNames.DescriptionVertices :=
            "list of equivalence classes of [new face (as number), old vertex]-pairs";

        # Construct the new simplicial surface
        surface := Objectify( PolygonalComplexType, rec() );
        SetFacesOfEdges(surface, simpFacesOfEdges);
        SetVerticesOfEdges(surface, simpVerticesOfEdges);

        return [surface, altNames];
    end
);
RedispatchOnCondition( CommonCover, true, 
    [IsPolygonalComplex, IsPolygonalComplex, IsList, IsList], 
    [IsSimplicialSurface, IsSimplicialSurface], 0 );



##
##  End of Common Cover
##
#######################################


#######################################
##
##  SixFoldCover
##

InstallMethod( SixFoldCover, "for a simplicial surface and a list",
    [IsSimplicialSurface, IsList],
    function(simpSurf, localSymmetry)
        local cfaces, f, cSym, wild, altNames, cyc, cgens, cSymCyc,
            i, j, moved, perm, sigi, img, arrange, f1, f2, e1, e2,
            ind1, ind2, remed, edge1, edge2, verts, cf, e, neigh;

        # first we compute the faces of the cover
        # faces are given by the three edges incident to the face
        # Arrangements( [1,2,3], 3) are the images of the map beta in
        # definition of six-fold cover 
        cfaces := [];
        for f in Faces(simpSurf) do
            Append( cfaces, List( Arrangements( EdgesOfFaces(simpSurf)[f], 3),
                a-> [f,a] ));
        od;

        # We store the local symmetry 
        # store for every colour (1,2,3) whether the appropriate
        # edge of face f is a mirror or a rotation
        cSym := List( [1,2,3], j -> List(cfaces, i -> 0) );
        cSym := List( [1,2,3], j -> ListWithIdenticalEntries(Length(cfaces),0) );

        # now we have to compute the edges
        # Starting from (f,(e_x, e_y, e_z)) the generator sigma_1
        # maps (f,(e_x, e_y, e_z)) to (f,(e_x, e_y, e_z)) if $e_x$ is a
        # boundary edge and to (g,(e_x, e_u, e_v)) if $e_x$ is an inner
        # edge such that (f,g) are the two faces incident to e_x and
        # e_y, e_u, e_x are incident to a common vertex and
        # e_z, e_v, e_x are incident to a common vertex, if
        # (f,g) is a mirror-cycle of sigma_1 and
        # to (g,(e_x, e_v, e_u)) otherwise.

  
        cgens := [];
        for i in [1..3]  do
            sigi := []; # define generator sigma_i
            for j in [1..Length(cfaces)] do
                cf := cfaces[j]; # work out the image of cf under sigi
                # e.g. cf = [1, [2, 3, 1]] means face 1, edges 2,3,1
                # if i=2 we have to map along the edge in position 2 (i.e. 3)
                # and need to find the neighbour of cf along this edge
                # cf[2][k] is the edge  along which to map
  #	      k := cf[2],i);
  	      # the face numbers of  the neighbouring faces
                neigh := NeighbourFaceByEdgeNC(simpSurf, cf[1], cf[2][i]);
                                      
                if neigh = fail then
                    img := ShallowCopy(cf); # boundary edge
                else
                    img := [neigh];
                    e := EdgesOfFaces(simpSurf)[neigh]; # the edges of neigh
  		    arrange := [];
  		    arrange[i] := cf[2][i]; # this edge remains fixed
  
                    # all faces are triangles
                    if cf[2][i] = e[1] then
                        remed := [e[2],e[3]];
                    elif cf[2][i] = e[2] then
                        remed := [e[1],e[3]];
                    else
                        remed := [e[1],e[2]];
                    fi;
  
                    #
  		    #                 /|\
  		    #                / | \
  		    #               /  |  \
  		    #              e1  |   f1
  		    #             /    |    \
  		    #             \    |    /
  		    #              e2  |   f2
  		    #               \  |  /
  		    #                \ | /
  		    #                 \|/
                    if i = 1 then
                        ind1 := 2;
                        ind2 := 3;
                    elif i = 2 then
                        ind1 := 1;
                        ind2 := 3;
                    else
                        ind1 := 1;
                        ind2 := 2;
                    fi;
  
                    e1 := cf[2][ind1];
                    e2 := cf[2][ind2];
  
                    verts := VerticesOfEdges(simpSurf)[cf[2][i]];
                    edge1 := EdgesOfVertices(simpSurf)[verts[1]];
                    edge2 := EdgesOfVertices(simpSurf)[verts[2]];
                    if ( e1 in edge1 and remed[1] in edge1 ) or 
                        ( e1 in edge2 and remed[1] in edge2 ) then
                            f1 := remed[1];
                            f2 := remed[2];
                    else
                            f1 := remed[2];
                            f2 := remed[1];
                    fi;
  
                    if localSymmetry[i] = 1 then
                           # \sigma_i is mirror
                           arrange[ind1] := f1;
                           arrange[ind2] := f2;
  
                           cSym[i][j] := 1;
                    else
                          # rotation
                          arrange[ind1] := f2;
                          arrange[ind2] := f1;
  
                          cSym[i][j] := 2;
                    fi;
  		
                    img[2] := arrange;
                    sigi[j] := Position( cfaces, img );
                    #TODO make this faster by calculating which position it will
                    # end up being: For each face there are exactly 6 arrangements
                    # => by knowing the position we only have to check 6 entries
                    # Since the arrangements are ordered as well, we can use the
                    # information from this loop to find the correct position
                    # (left as an exercise :P).
                 fi;
              od;
  
              perm := PermList(sigi);
              if perm = fail then 
                  Info( InfoSimplicial, 1, "Surface does not exist");
                  Error("Internal Error (SixfoldCover): No permutation defined.");
                return false;
            fi;
            Add( cgens, perm );
        od;

        # Rewrite cSym in terms of permutation cycles
        cSymCyc := [[],[],[]];
        moved := MovedPoints( cgens );
        for i in [1,2,3] do
            cyc := Cycles(cgens[i],moved);
            for j in [1..Length(cyc)] do
                cSymCyc[i][j] := cSym[i][cyc[j][1]];
            od;
        od;
    
        wild := AllWildColouredSurfaces( cgens, cSymCyc );
        Assert(1, Length(wild)=1);
  
        # Set the alternative names
        altNames := rec( Faces := cfaces,
          Description := "[oldFace, [vertices of the oldFace]]");
        
        return [wild[1], altNames];
    end
);
RedispatchOnCondition( SixFoldCover, true, [IsPolygonalComplex, IsList], [IsSimplicialSurface], 0 );

InstallOtherMethod( SixFoldCover, "for a simplicial surface", 
    [IsSimplicialSurface],
    function(simpSurf)
        return SixFoldCover(simpSurf, [1,1,1]);
    end
);
RedispatchOnCondition( SixFoldCover, true, [IsPolygonalComplex], [IsSimplicialSurface], 0 );

##
##  End of SixFoldCover
##
#######################################

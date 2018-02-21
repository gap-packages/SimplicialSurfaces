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

        nrCol := Length( Set( ColoursOfEdges(colComp) ) );
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

BindGlobal( "__SIMPLICIAL_GeneratorsFromFacePairs",
    function(facepairs)
        local gens, g, i,  cycs, cycs_c, gens_c, faces, fixedpoints_c, c,
              AllGenSets, NextFace, fixedpoints, IsEligible, check;

        if Length(facepairs) = 0 then return [ (), (), () ]; fi;
        check := Filtered( facepairs, i-> not IsList(i) or 
                           not Length(i) in [1,2] or not IsPosInt(i[1]) or 
                           Length( Filtered(i, j-> not IsPosInt(j)) ) > 0 );
        if Length(check)<> 0 then 
            Error("__SIMPLICIAL_GeneratorsFromFacePairs: ", 
                  "input not a list of pairs of positive integers");
        fi;

        facepairs := Compacted(facepairs);
        faces := Set( Flat(facepairs) );
        
        cycs := ShallowCopy(facepairs);

        c := First( cycs, i-> Length(i) = 2 );
        if c = fail then return [ (), (), () ]; fi;
        Remove(cycs,Position(cycs,c));
        Sort(cycs);
        

        cycs_c := ShallowCopy(cycs);
        # the first cycle has to be somewhere so it might as well
        # be on the first generator
        gens_c := [ (c[1], c[2]), (), () ];


        # here we record which fixed points we have used in which
        # generator so far
        fixedpoints := [];
        fixedpoints[1] := List( [1..Length(faces)], i-> false );
        fixedpoints[2] := List( [1..Length(faces)], i-> false );
        fixedpoints[3] := List( [1..Length(faces)], i-> false );

        # a global variable to store the results
        AllGenSets := [];


        # test whether g can be extended with the cycle c
        IsEligible := function (g,i, c, fix )
              
            if Length(c) = 2 then
                # first we have to ensure that neither c[1] nor c[2] are
                # fixed points of g
                if fix[i][c[1]] = false and fix[i][c[2]] = false and
                   c[1]^g = c[1] and c[2]^g = c[2] then
                    return true; # the 2-cycle is not in gens[i] yet
                else return false;
                fi;
            else # c is a 1-cycle
                # if it has not yet been used in g and g fixes it, return true
                if fix[i][c[1]] = false and c[1]^g=c[1] then return true; fi;
            fi;

            return false;

        end;

        # find all possibilities of moving face f
        NextFace := function( gens, cycs, fixedpoints )
            local g, i, c, nf;

        
            # choose the first cycle that contains f
            c := cycs[1];

            # now we try to add c to each of the generators
            for i in [ 1 .. 3 ] do
                g := gens[i];
                if IsEligible(g,i,c, fixedpoints) then
                    # this generator does not already move the 
                    # points in c, hence we can extend it by c.
                    gens_c := ShallowCopy(gens);
                    cycs_c := ShallowCopy(cycs);
                    fixedpoints_c := 
                        List(fixedpoints, x -> ShallowCopy(x));
                    if Length(c) = 2 then 
                        # if c is a 2-cycle, extend g
                        gens_c[i] := g * (c[1],c[2]);
                    else
                        # if c is a 1-cycle record its use in g
                        fixedpoints_c[i][c[1]] := true;
                    fi;
                    Remove( cycs_c, Position(cycs_c,c) );

                    if Length(cycs_c) = 0 then
                        # there are no more points to move 
                        # hence we found a valid assignment
                        Sort( gens_c );
                        Add(AllGenSets, gens_c);
                    else
                        NextFace( gens_c,cycs_c,fixedpoints_c);
                    fi;
                fi;
            od;

        end;

        NextFace( gens_c, cycs_c, fixedpoints );

        return Set(AllGenSets);
    end
);

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
    function(invList, localSymmetry, name)
        local moved, maxMoved, cycles, newSym, bound, b, n, cycList;

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

        bound := BoundPositions(invList);
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
        local faces, facesOfEdges, coloursOfEdges, cyc, allWildSurfaces,
            allUmbrellas, BestNextVertex, LoopOneVertex, FindWildColouredSurface,
            facePosition, localSymOfEdges, invOfEdges, edgesOfFacesByColour,
            vertexNames, AddUmbrellaStep, edgesOfFaces, i, f, p;

        localSymmetry := __SIMPLICIAL_WildTameInvolutions_FixLocalSymmetry(
                        invList, localSymmetry, "AllWildColouredSurfaces");

        faces := MovedPoints( Group(invList) );
        # The faces can have holes, but we still want to have fast access 
        # to the position of a face in this list
        facePosition := [];
        for i in [1..Length(faces)] do
            facePosition[faces[i]] := i;
        od;

        facesOfEdges := [];
        coloursOfEdges := [];
        localSymOfEdges := [];
        invOfEdges := [];
        edgesOfFacesByColour := List(facePosition, i -> []);
        for p in BoundPositions(invList) do
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
            Append(localSymOfEdges, localSymmetry[p]);
            Append( invOfEdges, List(cyc, c -> invList[p]) );
        od;

        edgesOfFaces := __SIMPLICIAL_InvertIncidence(faces, facesOfEdges, [1..Length(facesOfEdges)]);
        vertexNames := Concatenation( List( faces, f -> 
            List( Combinations(edgesOfFaces[f],2), c -> [f,c[1],c[2]] ) ) );

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
                usedVertexNames_c, obj, partialLocalSym_c, colSurf;

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

            # Recursive computation
            allUmbrellas := [];
            LoopOneVertex( umbrella, [face], usedVertexNames, 
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
            knownFaces_c := Concatenation(knownFaces, [nextFace]);
                #MB is this faster than putting it into a set?
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
            elif nextFace in knownFaces then
#Print("         Illegal continuation. Abort.\n");
                # this is an error since we never construct a face of an umbrella twice
                return;
            else
#Print("         Continue constructing along edge ", lastEdge, ".\n");
                # continue construction of umbrella
                prevEdge := umbrella[Length(umbrella)-2];
                prevCol := coloursOfEdges[prevEdge];
                lastCol := coloursOfEdges[lastEdge];
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
    vertexGraph := DigraphByEdges(adjacencyList);
    connComp := DigraphConnectedComponents(vertexGraph);
    #TODO can GRAPE work with unbound entries in lists?

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

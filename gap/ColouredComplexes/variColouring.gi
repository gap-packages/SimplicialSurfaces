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

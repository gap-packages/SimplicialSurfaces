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

InstallMethod( LocalSymmetryOfEdgesAsNumbers, 
    "for an edge exact-coloured simplicial surface",
    [IsEdgeColouredSimplicialSurface and IsEdgeExactColouring],
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
        [IsEdgeExactColouring and IsEdgeColouredSimplicialSurface], 0 );

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
    "for an edge exact-coloured simplicial surface",
    [IsEdgeColouredSimplicialSurface and IsEdgeExactColouring], 
    function(colSurf)
        local mr;

        mr := LocalSymmetryOfEdgesAsNumbers(colSurf);
        return List(mr, __SIMPLICIAL_LocalSymmetryNamesOfNumber );
    end
);
    RedispatchOnCondition( LocalSymmetryOfEdges, true, 
        [IsEdgeColouredPolygonalComplex], 
        [IsEdgeExactColouring and IsEdgeColouredSimplicialSurface], 0 );

InstallMethod( IsMRTypeColourInvariant,
    "for an edge exact-coloured simplicial surface",
    [IsEdgeColouredSimplicialSurface and IsEdgeExactColouring],
    function(colSurf)
        local mr, c, ind_mr, mrCol;

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
    RedispatchOnCondition( IsMRTypeColourInvariant, true,
        [IsEdgeColouredPolygonalComplex],
        [IsEdgeExactColouring and IsEdgeColouredSimplicialSurface], 0);

InstallMethod( LocalSymmetryOfColoursAsNumbers,
    "TODO for a perfect rainbow edge coloured simplicial surface",
    [IsEdgeColouredSimplicialSurface and IsMRTypeColourInvariant],
    function(colSurf)
        return LocalSymmetryOfColoursAsNumbers(colSurf); # The previous check should set the attribute
    end
);
    RedispatchOnCondition( LocalSymmetryOfColoursAsNumbers, true,
        [IsEdgeColouredPolygonalComplex],
        [IsMRTypeColourInvariant and IsEdgeColouredSimplicialSurface], 0);

InstallMethod( LocalSymmetryOfColours,
    "TODO for a perfect rainbow edge coloured simplicial surface",
    [IsEdgeColouredSimplicialSurface and IsMRTypeColourInvariant],
    function(colSurf)
        local mr;

        mr := LocalSymmetryOfColoursAsNumbers(colSurf);

        return List(mr, __SIMPLICIAL_LocalSymmetryNamesOfNumber );
    end
);
    RedispatchOnCondition( LocalSymmetryOfColours, true,
        [IsEdgeColouredPolygonalComplex],
        [IsMRTypeColourInvariant and IsEdgeColouredSimplicialSurface], 0);


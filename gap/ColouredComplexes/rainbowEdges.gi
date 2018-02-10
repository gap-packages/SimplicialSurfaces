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

InstallMethod( IsFaceRainbowEdgeColouring, 
    "for an edge coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComp)
        local edges, colours;

        edges := EdgesOfFaces( PolygonalComplex(colComp) );
        colours := List(edges, edg -> List(edg, e -> ColoursOfEdges(colComp)[e]));
        return ForAll(colours, IsDuplicateFree);
    end
);

InstallMethod( IsPerfectFaceRainbowEdgeColouring,
    "for an edge coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComp)
        local nrCol, edges, nrEdges;

        if not IsFaceRainbowEdgeColouring(colComp) then
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
    "for a rainbow edge coloured polygonal complex and a face",
    [IsEdgeColouredPolygonalComplex and IsFaceRainbowEdgeColouring, IsPosInt],
    function(rbComp, face)
        return ColouredEdgesOfFaces(rbComp)[face];
    end
);

InstallMethod( ColouredEdgesOfFace,
    "for a rainbow edge coloured polygonal complex and a face",
    [IsEdgeColouredPolygonalComplex and IsFaceRainbowEdgeColouring, IsPosInt],
    function(rbComp, face)
        __SIMPLICIAL_CheckFace( PolygonalComplex(rbComp), face, "ColouredEdgesOfFace" );
        return ColouredEdgesOfFaceNC(rbComp,face);
    end
);

InstallMethod( ColouredEdgesOfFaces,
    "for a rainbow edge coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex and IsFaceRainbowEdgeColouring],
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


InstallMethod( ColourInvolutions,
    "for a rainbow edge coloured ramified polygonal surface",
    [IsEdgeColouredPolygonalComplex and IsFaceRainbowEdgeColouring],
    function(rbComp)
        local invs, cols, col, toList, edges, edge, facesOfEdge;

        if not IsRamifiedPolygonalSurface(PolygonalComplex(rbComp)) then
            return fail;
        fi;

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

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

DeclareRepresentation( "EdgeColouredPolygonalComplexRep", 
    IsEdgeColouredPolygonalComplex and IsAttributeStoringRep, [] );
BindGlobal("EdgeColouredPolygonalComplexType", 
    NewType(EdgeColouredPolygonalComplexFamily, EdgeColouredPolygonalComplexRep));


InstallMethod( EdgeColouredPolygonalComplexNC, 
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, edgeColours)
        local obj;

        obj := Objectify( EdgeColouredPolygonalComplexType, rec() );
        SetPolygonalComplex(obj, complex);
        SetColoursOfEdges(obj,edgeColours);

        return obj;
    end
);
InstallMethod( EdgeColouredPolygonalComplex,
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, edgeColours)
        local edges, bound, diff, nonPos;

        edges := Edges(complex);
        bound := BoundPositions(edgeColours);

        diff := Difference(edges, bound);
        if not IsEmpty( diff ) then
            Error(Concatenation( 
                "EdgeColouredPolygonalComplex: There are no colours for the edges in ", 
                diff, "." ));
        fi;

        diff := Difference(bound, edges);
        if not IsEmpty( diff ) then
            Error(Concatenation( 
                "EdgeColouredPolygonalComplex: The positions in ", 
                diff, " do not correspond to any edge." ));
        fi;

        nonPos := Filtered(edgeColours, i -> not IsPosInt(i));
        if not IsEmpty(nonPos) then
            Error(Concatenation(
                "EdgeColouredPolygonalComplex: The following entries are not positive integers: ", 
                nonPos, "."));
        fi;
        
        return EdgeColouredPolygonalComplexNC(complex, edgeColours);
    end
);

#######################################
##
##      Access to colouring
##

InstallMethod( ColourOfEdgeNC, 
    "for an edge coloured polygonal complex and an edge",
    [IsEdgeColouredPolygonalComplex, IsPosInt],
    function(colComplex, edge)
        return ColoursOfEdges(colComplex)[edge];
    end
);
InstallMethod( ColourOfEdge,
    "for an edge coloured polygonal complex and an edge",
    [IsEdgeColouredPolygonalComplex, IsPosInt],
    function(colComplex, edge)
        __SIMPLICIAL_CheckEdge( PolygonalComplex(colComplex), edge, "ColourOfEdge" );
        return ColourOfEdgeNC(colComplex, edge);
    end
);




InstallMethod( EdgesOfColour,
    "for an edge coloured polygonal complex and a colour",
    [IsEdgeColouredPolygonalComplex, IsPosInt],
    function(colComplex, colour)
        local edges;
        
        edges := EdgesOfColours(colComplex);
        if IsBound(edges[colour]) then
            return edges[colour];
        else
            return [];
        fi;
    end
);


# Since we only have to attributes, the usage of the AttributeScheduler is
# not necessary
InstallMethod( ColoursOfEdges,
    "for an edge coloured polygonal complex that has EdgesOfColours",
    [IsEdgeColouredPolygonalComplex and HasEdgesOfColours],
    function(colComplex)
        local colEdge, edgeCol, col, edge;

        edgeCol := EdgesOfColours(colComplex);
        colEdge := [];
        for col in BoundPositions(edgeCol) do
            for edge in edgeCol[col] do
                colEdge[edge] := col;
            od;
        od;

        return colEdge;
    end
);

InstallMethod( EdgesOfColours,
    "for an edge coloured polygonal complex that has ColoursOfEdges",
    [IsEdgeColouredPolygonalComplex and HasColoursOfEdges],
    function(colComplex)
        local colEdge, edgeCol, col;

        colEdge := ColoursOfEdges(colComplex);
        edgeCol := [];
        for col in Set(colEdge) do
            edgeCol[col] := Filtered( Edges(PolygonalComplex(colComplex)), e -> colEdge[e] = col );
        od;

        return edgeCol;
    end
);


##
##      End access to colouring
##
#######################################
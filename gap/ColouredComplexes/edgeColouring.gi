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

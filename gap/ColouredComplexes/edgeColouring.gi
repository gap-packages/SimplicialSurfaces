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
    function(complex, colouring)
        local obj;

        obj := Objectify( EdgeColouredPolygonalComplexType, rec() );
        SetPolygonalComplex(obj, complex);
        if ForAll(colouring, IsPosInt) then
            SetColoursOfEdges(obj, colouring);
        else
            SetEdgesOfColours(obj, List(colouring, Set));
        fi;

        return obj;
    end
);
InstallMethod( EdgeColouredPolygonalComplex,
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, colouring)
        local edges, bound, diff, nonPos, i, j, inter, foundEdges;

        edges := Edges(complex);
        bound := BoundPositions(colouring);
        if ForAll(colouring, IsPosInt) then
            # We should have a list edge->colour

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
        elif ForAll(colouring, IsList) then
            # The entries should be lists of positive integers
            foundEdges := Union(colouring);

            # Check equality of edges
            diff := Difference(edges, foundEdges);
            if not IsEmpty(diff) then
                Error(Concatenation(
                    "EdgeColouredPolygonalComplex: The edges in ", diff, 
                    " do not appear in any colour class."));
            fi;

            diff := Difference(foundEdges, edges);
            if not IsEmpty(diff) then
                Error(Concatenation(
                    "EdgeColouredPolygonalComplex: The numbers in ", diff, 
                    " appear in colour classes but don't correspond to edges."));
            fi;

            # Check if the classes are disjoint
            for i in [1..Size(bound)] do
                for j in [i+1..Size(bound)] do
                    inter := Intersection( 
                        colouring[bound[i]], colouring[bound[j]] );
                    if not IsEmpty(inter) then
                        Error(Concatenation(
                            "EdgeColouredPolygonalComplex: The colour classes at positions ",
                            bound[i], " and ", bound[j], " are not disjoint."));
                    fi;
                od;
            od;
        else
            # This should not have happened
            Error("EdgeColouredPolygonalComplex: The edge colouring should be either a list of positive integers or a list of sets of positive integers.");
        fi;

        return EdgeColouredPolygonalComplexNC(complex, colouring);
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

InstallMethod( \=, "for two edge coloured polygonal complexes", 
    IsIdenticalObj, 
    [IsEdgeColouredPolygonalComplex, IsEdgeColouredPolygonalComplex],
    function(ec1, ec2)
        return ColoursOfEdges(ec1) = ColoursOfEdges(ec2) and 
            PolygonalComplex(ec1) = PolygonalComplex(ec2);
    end
);


#######################################
##
##      Drawing method
##

InstallOtherMethod( DrawSurfaceToTikz, 
    "for an edge coloured polygonal complex and a file name",
    [IsEdgeColouredPolygonalComplex, IsString],
    function(colComp, file)
        return DrawSurfaceToTikz(colComp, file, rec());
    end
);

InstallMethod( DrawSurfaceToTikz,
    "for an edge coloured polygonal complex, a file name and a print record",
    [IsEdgeColouredPolygonalComplex, IsString, IsRecord],
    function(colComp,file,printRecord)
        local classLen, classCol, e, edgeLen, edgeCol;

        if not IsRamifiedPolygonalSurface(PolygonalComplex(colComp)) then
            Error("DrawSurfaceToTikz: The underlying polygonal complex has to be a ramified polygonal surface.");
        fi;

        if not IsBound(printRecord.edgeColourClassActive) then
            printRecord.edgeColourClassActive := true;
        fi;

        if printRecord.edgeColourClassActive then
            if IsBound(printRecord.edgeColourClassLengths) then
                classLen := printRecord.edgeColourClassLengths;
                if not IsList(classLen) then
                    Print("Warning: edgeColourClassLengths should be a list.");
                else
                    # We require that all colours are given
                    #TODO change that and allow partial information
                    if not BoundPositions(classLen) = Set(ColoursOfEdges(colComp)) then
                        Error("DrawSurfaceToTikz: In edgeColourClassLengths there has to be a length for every colour (and only for the appearing colours).");
                    fi;
                    edgeLen := [];
                    for e in Edges(PolygonalComplex(colComp)) do
                        edgeLen[e] := classLen[ColourOfEdgeNC(colComp, e)];
                    od;
                    printRecord.edgeLengths := edgeLen;
                fi;
            fi;

            if not IsBound(printRecord.edgeColourClassColours) and Size(Set(ColoursOfEdges(colComp))) = 3 then
                printRecord.edgeColourClassColours := ["red","blue","green"];
            fi; #TODO this is a special case for 3 colours - what can be done in general?
            if IsBound(printRecord.edgeColourClassColours) then
                classCol := printRecord.edgeColourClassColours;
                if not IsList(classCol) then
                    Print("Warning: edgeColourClassColours should be a list.");
                else
                    # We require that all colours are given
                    #TODO change that and allow partial information
                    if not BoundPositions(classCol) = Set(ColoursOfEdges(colComp)) then
                        Error("DrawSurfaceToTikz: In edgeColourClassColours there has to be a colour for every colour (and only for the appearing colours).");
                    fi;
                    edgeCol := [];
                    for e in Edges(PolygonalComplex(colComp)) do
                        edgeCol[e] := classCol[ColourOfEdgeNC(colComp, e)];
                    od;
                    printRecord.edgeColours := edgeCol;
                fi;
            fi;
        fi;

        return DrawSurfaceToTikz( PolygonalComplex(colComp), file, printRecord );
    end
);

##
##      End of drawing method
##
#######################################

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

InstallMethod( IsEdgeColouredTriangularComplex,
    "for an edge-coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComplex)
        return IsTriangularComplex( PolygonalComplex(colComplex) );
    end
);
InstallMethod( IsEdgeColouredRamifiedPolygonalSurface,
    "for an edge-coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComplex)
        return IsRamifiedPolygonalSurface( PolygonalComplex(colComplex) );
    end
);
InstallMethod( IsEdgeColouredRamifiedSimplicialSurface,
    "for an edge-coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComplex)
        return IsRamifiedSimplicialSurface( PolygonalComplex(colComplex) );
    end
);
InstallMethod( IsEdgeColouredPolygonalSurface,
    "for an edge-coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComplex)
        return IsPolygonalSurface( PolygonalComplex(colComplex) );
    end
);
InstallMethod( IsEdgeColouredSimplicialSurface,
    "for an edge-coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComplex)
        return IsSimplicialSurface( PolygonalComplex(colComplex) );
    end
);


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
            if Length( diff ) > 0 then
                Error(Concatenation( 
                    "EdgeColouredPolygonalComplex: There are no colours for the edges in ", 
                    String(diff), "." ));
            fi;

            diff := Difference(bound, edges);
            if Length( diff ) > 0 then
                Error(Concatenation( 
                    "EdgeColouredPolygonalComplex: The positions in ", 
                    String(diff), " do not correspond to any edge." ));
            fi;
        elif ForAll(colouring, IsList) then
            # The entries should be lists of positive integers
            foundEdges := Union(colouring);

            # Check equality of edges
            diff := Difference(edges, foundEdges);
            if Length(diff) > 0 then
                Error(Concatenation(
                    "EdgeColouredPolygonalComplex: The edges in ", String(diff), 
                    " do not appear in any colour class."));
            fi;

            diff := Difference(foundEdges, edges);
            if Length(diff) > 0 then
                Error(Concatenation(
                    "EdgeColouredPolygonalComplex: The numbers in ", String(diff), 
                    " appear in colour classes but don't correspond to edges."));
            fi;

            # Check if the classes are disjoint
            for i in [1..Length(bound)] do
                for j in [i+1..Length(bound)] do
                    inter := Intersection( 
                        colouring[bound[i]], colouring[bound[j]] );
                    if Length(inter) > 0 then
                        Error(Concatenation(
                            "EdgeColouredPolygonalComplex: The colour classes at positions ",
                            String(bound[i]), " and ", String(bound[j]), " are not disjoint."));
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
# triangular complex
InstallMethod( EdgeColouredTriangularComplexNC, 
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, colouring)
        SetIsTriangularComplex( complex, true );
        return EdgeColouredPolygonalComplexNC(complex, colouring);
    end
);
InstallMethod( EdgeColouredTriangularComplex,
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, colouring)
        if not IsTriangularComplex(complex) then
            Error("EdgeColouredTriangularComplex: Given complex is not a triangular complex.");
        fi;
        return EdgeColouredPolygonalComplex(complex, colouring);
    end
);
# ramified polygonal surface
InstallMethod( EdgeColouredRamifiedPolygonalSurfaceNC, 
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, colouring)
        SetIsRamifiedPolygonalSurface( complex, true );
        return EdgeColouredPolygonalComplexNC(complex, colouring);
    end
);
InstallMethod( EdgeColouredRamifiedPolygonalSurface,
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, colouring)
        if not IsRamifiedPolygonalSurface(complex) then
            Error("EdgeColouredTriangularComplex: Given complex is not a ramified polygonal surface.");
        fi;
        return EdgeColouredPolygonalComplex(complex, colouring);
    end
);
# ramified simplicial surface
InstallMethod( EdgeColouredRamifiedSimplicialSurfaceNC, 
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, colouring)
        SetIsTriangularComplex( complex, true );
        SetIsRamifiedPolygonalSurface( complex, true );
        return EdgeColouredPolygonalComplexNC(complex, colouring);
    end
);
InstallMethod( EdgeColouredRamifiedSimplicialSurface,
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, colouring)
        if not IsRamifiedSimplicialSurface(complex) then
            Error("EdgeColouredTriangularComplex: Given complex is not a ramified simplicial surface.");
        fi;
        return EdgeColouredPolygonalComplex(complex, colouring);
    end
);
# polygonal surface
InstallMethod( EdgeColouredPolygonalSurfaceNC, 
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, colouring)
        SetIsPolygonalSurface( complex, true );
        return EdgeColouredPolygonalComplexNC(complex, colouring);
    end
);
InstallMethod( EdgeColouredPolygonalSurface,
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, colouring)
        if not IsPolygonalSurface(complex) then
            Error("EdgeColouredTriangularComplex: Given complex is not a polygonal surface.");
        fi;
        return EdgeColouredPolygonalComplex(complex, colouring);
    end
);
# simplicial surface
InstallMethod( EdgeColouredSimplicialSurfaceNC, 
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, colouring)
        SetIsTriangularComplex( complex, true );
        SetIsPolygonalSurface( complex, true );
        return EdgeColouredPolygonalComplexNC(complex, colouring);
    end
);
InstallMethod( EdgeColouredSimplicialSurface,
    "for a polygonal complex and a list of positive integers",
    [IsPolygonalComplex, IsList],
    function(complex, colouring)
        if not IsSimplicialSurface(complex) then
            Error("EdgeColouredTriangularComplex: Given complex is not a simplicial surface.");
        fi;
        return EdgeColouredPolygonalComplex(complex, colouring);
    end
);


InstallMethod( TriangularComplex, "for an edge coloured triangular complex",
    [IsEdgeColouredTriangularComplex],
    function(colComplex)
        return PolygonalComplex(colComplex);
    end
);
RedispatchOnCondition( TriangularComplex, true, [IsEdgeColouredPolygonalComplex], [IsEdgeColouredTriangularComplex], 0 );

InstallMethod( RamifiedPolygonalSurface, "for an edge coloured ramified polygonal surface",
    [IsEdgeColouredRamifiedPolygonalSurface],
    function(colComplex)
        return PolygonalComplex(colComplex);
    end
);
RedispatchOnCondition( RamifiedPolygonalSurface, true, [IsEdgeColouredPolygonalComplex], [IsEdgeColouredRamifiedPolygonalSurface], 0 );

InstallMethod( RamifiedSimplicialSurface, "for an edge coloured ramified simplicial surface",
    [IsEdgeColouredRamifiedSimplicialSurface],
    function(colComplex)
        return PolygonalComplex(colComplex);
    end
);
RedispatchOnCondition( RamifiedSimplicialSurface, true, [IsEdgeColouredPolygonalComplex], [IsEdgeColouredRamifiedSimplicialSurface], 0 );

InstallMethod( PolygonalSurface, "for an edge coloured polygonal surface",
    [IsEdgeColouredPolygonalSurface],
    function(colComplex)
        return PolygonalComplex(colComplex);
    end
);
RedispatchOnCondition( PolygonalSurface, true, [IsEdgeColouredPolygonalComplex], [IsEdgeColouredPolygonalSurface], 0 );

InstallMethod( SimplicialSurface, "for an edge coloured simplicial surface",
    [IsEdgeColouredSimplicialSurface],
    function(colComplex)
        return PolygonalComplex(colComplex);
    end
);
RedispatchOnCondition( SimplicialSurface, true, [IsEdgeColouredPolygonalComplex], [IsEdgeColouredSimplicialSurface], 0 );

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


InstallMethod( Colours, "for an edge coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComplex)
        return Set(ColoursOfEdges(colComplex));
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
##      Print, View, Display
##
InstallMethod( String, "for an edge coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex], 
    function(colComplex)
        local out, str;

        str := "";
        out := OutputTextString(str, true);
        PrintTo( out, "EdgeColoured" );
        PrintTo( out, __SIMPLICIAL_PolygonalComplexName( PolygonalComplex(colComplex), true ) );
        PrintTo( out, "NC( " );
        PrintTo( out, String(PolygonalComplex(colComplex)) );
        PrintTo( out, ", " );
        PrintTo( out, String(ColoursOfEdges(colComplex)) );
        PrintTo( out, " )" );

        CloseStream(out);
        return str;
    end
);

BindGlobal( "__SIMPLICIAL_TameSurfaceType",
    function(colComp)
        local strList, p, col, localSym;

        strList := [];
        # only three colours in a tame coloured surface
        for p in [1,2,3] do
            col := Colours(colComp)[p];
            localSym := LocalSymmetryOfColoursAsNumbers(colComp)[col];
            if localSym = 1 then
                Add(strList, ["M", p]);
            elif localSym = 2 then
                Add(strList, ["R", p]);
            else
                # boundary
                Add(strList, ["B", p]);
            fi;
        od;
        return strList;
    end
);

InstallMethod( ViewInformation, "for an edge coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComp)
        local strList, str, out;

        strList := [];
        str := "";
        out := OutputTextString(str, true);
        if IsWildColouredSurface(colComp) then
            if IsTameColouredSurface(colComp) then
                Add(strList, ["tame coloured surface (", 0]);
                Append(strList, __SIMPLICIAL_TameSurfaceType(colComp));
                Add(strList, [" with ", 0]);
            else
                Add(strList, ["wild coloured surface (", 0]);
            fi;
        else
            PrintTo( out, "edge coloured " );
            PrintTo( out, __SIMPLICIAL_PolygonalComplexName( PolygonalComplex(colComp), false ) );
            PrintTo( out, " (" );
            Add( strList, [ str, 0 ] );
            str := "";
        fi;

        PrintTo( out, String( NumberOfVertices( PolygonalComplex(colComp) ) ) );
        PrintTo( out, " vertices, " );
        PrintTo( out, String( NumberOfEdges( PolygonalComplex(colComp) ) ) );
        PrintTo( out, " edges" );
        if IsWildColouredSurface(colComp) then
            PrintTo( out, " and " );
        else
            PrintTo( out, ", " );
        fi;
        PrintTo( out, String( NumberOfFaces( PolygonalComplex(colComp) ) ) );
        PrintTo( out, " faces" );
        if not IsWildColouredSurface(colComp) then
            PrintTo( out, " and " );
            PrintTo( out, String( Length( Colours(colComp) ) ) );
            PrintTo( out, " colours" );
        fi;
        PrintTo( out, ")" );
        CloseStream(out);
        Add( strList, [ str, 0 ] );

        return strList;
    end
);
InstallMethod( ViewString, "for an edge coloured polygonal complex", 
    [IsEdgeColouredPolygonalComplex],
    function(complex)
        return __SIMPLICIAL_ColourString( ViewInformation(complex), 
            [ SIMPLICIAL_COLOURS_WILD_1_DEFAULT, SIMPLICIAL_COLOURS_WILD_2_DEFAULT, SIMPLICIAL_COLOURS_WILD_3_DEFAULT ]);
    end
);
InstallMethod( ViewObj, "for an edge coloured polygonal complex", 
    [IsEdgeColouredPolygonalComplex],
    function(complex)
        if SIMPLICIAL_COLOURS_ON then
            __SIMPLICIAL_PrintColourString( ViewInformation(complex), 
                [ SIMPLICIAL_COLOURS_WILD_1, SIMPLICIAL_COLOURS_WILD_2, SIMPLICIAL_COLOURS_WILD_3 ]);
        else
            Print(__SIMPLICIAL_UncolouredString( ViewInformation(complex) ));
        fi;
    end
);



# Display
InstallMethod( DisplayInformation, "for an edge coloured polygonal complex", 
    [IsEdgeColouredPolygonalComplex],
    function(colComp)
        local strList, x, umb, set, str, out, i, edge, complex, posOfColour, c;

        complex := PolygonalComplex(colComp);
        
        strList := [];
        str := "";
        out := OutputTextString(str, true);

        # make a colour list
        posOfColour := [];
        if IsWildColouredSurface(colComp) then
            for i in [1,2,3] do
                posOfColour[Colours(colComp)[i]] := i;
            od;
        else
            for c in Colours(colComp) do
                posOfColour[c] := 0;
            od;
        fi;


        # Set the most specific name
        if IsWildColouredSurface(colComp) then
            if IsTameColouredSurface(colComp) then
                Add(strList, ["Tame coloured surface (", 0]);
                Append(strList, __SIMPLICIAL_TameSurfaceType(colComp));
                Add(strList, [", ", 0]);
            else
                Add(strList, ["Wild coloured surface (", 0]);
            fi;
        else
            PrintTo( out, "Edge coloured " );
            PrintTo( out, __SIMPLICIAL_PolygonalComplexName( PolygonalComplex(colComp), false ) );
            if IsPolygonalSurface( PolygonalComplex(colComp) ) then
                PrintTo( out, " (" );
            fi;
            Add( strList, [ str, 0 ] );
            str := "";
        fi;

        # Special information for edge coloured polygonal surfaces
        if IsPolygonalSurface(PolygonalComplex(colComp)) then # more information
            if IsClosedSurface(complex) then
                PrintTo(out, "closed, ");
            fi;
            
            if IsOrientable(complex) then
                PrintTo(out, "orientable, ");
            else
                PrintTo(out, "non-orientable, ");
            fi;

            if IsConnected(complex) then
                PrintTo(out, "Euler-characteristic ", EulerCharacteristic(complex) );
            else
                PrintTo(out,  NumberOfConnectedComponents(complex), " connected components" );
            fi;
            PrintTo(out,  ")");
        fi;
        PrintTo(out, "\n");
        CloseStream(out);
        Add( strList, [ str, 0 ] );

        # Vertices
        Add( strList, [
            Concatenation( "    Vertices (", 
                String(NumberOfVertices(complex)), "): ", 
                String(VerticesAttributeOfVEFComplex(complex)), "\n" ), 0 ] );

        # Edges
        if IsWildColouredSurface(colComp) then
            Add( strList, [ Concatenation( "    Edges (", String(NumberOfEdges(complex)), "): [ " ), 0 ] );
            for x in Edges(complex) do
                Add( strList, [ String(x), posOfColour[ColoursOfEdges(colComp)[x]] ] );
                Add( strList, [ ", ", 0 ] );
            od;
            Remove(strList);
            Add(strList, [" ]\n", 0]);
        else
            Add( strList, [ Concatenation( "    Edges (", String(NumberOfEdges(complex)), "): ", String(Edges(complex)), "\n" ), 0 ] );
        fi;


        # Faces
        Add( strList, [
            Concatenation( "    Faces (", 
                String(NumberOfFaces(complex)), "): ", 
                String(Faces(complex)), "\n" ), 0 ] );


        # VerticesOfEdges
        Add( strList, [ "    VerticesOfEdges: [", 0] );
        for i in [1..Length(VerticesOfEdges(complex))] do
            if IsBound(VerticesOfEdges(complex)[i]) then
                set := VerticesOfEdges(complex)[i];
                Add( strList, [ String(set), posOfColour[ColoursOfEdges(colComp)[i]] ] );
            fi;
            Add( strList, [", ", 0] );
        od;
        # Remove final ","
        Remove(strList);
        Add( strList, [ " ]\n", 0 ] );

        
        # VerticesOfFaces
        Add( strList, [ Concatenation("    VerticesOfFaces: ", String(VerticesOfFaces(complex)), "\n"), 0 ] );


        # EdgesOfFaces
        Add( strList, [ "    EdgesOfFaces: [ ", 0 ] );
        for i in [1..Length(EdgesOfFaces(complex))] do
            if IsBound(EdgesOfFaces(complex)[i]) then
                set := EdgesOfFaces(complex)[i];
                Add( strList, [ "[ ", 0 ] );
                for x in set do
                    Add( strList, [ String(x), posOfColour[ColoursOfEdges(colComp)[x]] ] );
                    Add( strList, [ ", ", 0 ] );
                od;
                # Replace last "," by "]"
                Remove(strList);
                Add( strList, [" ]", 0] );
            fi;
            Add( strList, [", ", 0] );
        od;
        # Remove final ","
        Remove(strList);
        Add( strList, [ " ]\n", 0 ] );
        

        # UmbrellasOfVertices
        Add( strList, [ "    Umbrellas: [ ", 0 ] );
        if IsWildColouredSurface(colComp) then
            for i in [1..Length(ColouredUmbrellasOfVertices(colComp))] do
                if IsBound(ColouredUmbrellasOfVertices(colComp)[i]) then
                    umb := ColouredUmbrellasOfVertices(colComp)[i];
                    Append( strList, ViewInformation(umb) );
                fi;
                Add( strList, [", ", 0] );
            od;
        else
            for i in [1..Length(UmbrellasOfVertices(complex))] do
                if IsBound(UmbrellasOfVertices(complex)[i]) then
                    umb := UmbrellasOfVertices(complex)[i];
                    Add(strList, [__SIMPLICIAL_UncolouredString(ViewInformation(umb)), 0]);
                fi;
                Add( strList, [", ", 0] );
            od;
        fi;
        Remove(strList);
        Add( strList, [ " ]\n", 0 ] );


        # EdgesOfColours
        Add( strList, ["    EdgesOfColours: [ ", 0] );
        for i in [1..Length(EdgesOfColours(colComp))] do
            if IsBound(EdgesOfColours(colComp)[i]) then
                Add( strList, [String(EdgesOfColours(colComp)[i]), posOfColour[i]] );
            fi;
            Add(strList, [", ", 0]);
        od;
        Remove(strList);
        Add( strList, [" ]\n", 0] );


        # ColourInvolutions
        if IsWildColouredSurface(colComp) then
            Add(strList, ["    ColourInvolutions: [ ", 0]);
            for i in [1..Length(ColourInvolutions(colComp))] do
                if IsBound(ColourInvolutions(colComp)[i]) then
                    Add( strList, [ String(ColourInvolutions(colComp)[i]), posOfColour[i] ] );
                fi;
                Add( strList, [", ", 0] );
            od;
            Remove(strList);
            Add(strList, [" ]\n", 0]);
        fi;


        # LocalSymmetry
        if IsWildColouredSurface(colComp) then
            Add(strList, ["    LocalSymmetry: [ ", 0]);
            for i in [1..Length(LocalSymmetryOfEdges(colComp))] do
                if IsBound(LocalSymmetryOfEdges(colComp)[i]) then
                    Add( strList, [ LocalSymmetryOfEdges(colComp)[i], posOfColour[ColoursOfEdges(colComp)[i]] ] );
                fi;
                Add( strList, [", ", 0] );
            od;
            Remove(strList);
            Add( strList, [" ]\n", 0] );
        fi;

        return strList;
    end
);
InstallMethod( DisplayString, "for an edge coloured polygonal complex", 
    [IsEdgeColouredPolygonalComplex],
    function(complex)
        return __SIMPLICIAL_ColourString( DisplayInformation(complex),
            [SIMPLICIAL_COLOURS_WILD_1_DEFAULT, SIMPLICIAL_COLOURS_WILD_2_DEFAULT, SIMPLICIAL_COLOURS_WILD_3_DEFAULT]);
    end
);
InstallMethod( Display, "for an edge coloured polygonal complex", 
    [IsEdgeColouredPolygonalComplex],
    function(complex)
        if SIMPLICIAL_COLOURS_ON then
            __SIMPLICIAL_PrintColourString( DisplayInformation(complex), 
                [ SIMPLICIAL_COLOURS_WILD_1, SIMPLICIAL_COLOURS_WILD_2, SIMPLICIAL_COLOURS_WILD_3 ]);
        else
            Print(__SIMPLICIAL_UncolouredString( DisplayInformation(complex) ));
        fi;
    end
);



##
##      End Print, View, Display
##
#######################################


#######################################
##
##      Drawing method
##

InstallOtherMethod( DrawSurfaceToTikz, 
    "for an edge coloured polygonal complex and a file name",
    [IsEdgeColouredRamifiedPolygonalSurface, IsString],
    function(colComp, file)
        return DrawSurfaceToTikz(colComp, file, rec());
    end
);
RedispatchOnCondition( DrawSurfaceToTikz, true, 
    [IsEdgeColouredPolygonalComplex, IsString], 
    [IsEdgeColouredRamifiedPolygonalSurface], 0 );

InstallMethod( DrawSurfaceToTikz,
    "for an edge coloured polygonal complex, a file name and a print record",
    [IsEdgeColouredRamifiedPolygonalSurface, IsString, IsRecord],
    function(colComp,file,printRecord)
        local classLen, classCol, e, edgeLen, edgeCol;

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

            if not IsBound(printRecord.edgeColourClassColours) and Length(Set(ColoursOfEdges(colComp))) = 3 then
                printRecord.edgeColourClassColours := ["red","green","blue"];
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
RedispatchOnCondition( DrawSurfaceToTikz, true, 
    [IsEdgeColouredPolygonalComplex, IsString, IsRecord], 
    [IsEdgeColouredRamifiedPolygonalSurface], 0 );

##
##      End of drawing method
##
#######################################



#######################################
##
##      Isomorphism testing
##

if IsPackageMarkedForLoading( "Digraphs", ">=0.10.1" ) then
    InstallMethod( ColourIncidenceDigraphsGraph, 
        "for an edge coloured polygonal complex",
        [IsEdgeColouredPolygonalComplex],
        function( colComplex )
            return Digraph( ColourIncidenceGrapeGraph(colComplex) );
            #TODO is there a better way?
        end
    );
fi;

if IsPackageMarkedForLoading( "GRAPE", ">=0" ) then
    InstallMethod( ColourIncidenceGrapeGraph, 
        "for an edge coloured polygonal complex",
        [IsEdgeColouredPolygonalComplex],
        function(colComplex)
 	    local graph, vertices, edges, faces, names, colours, incidence, 
	        trivialAction, maxVert, maxEdge, maxFace, complex, cols;

            complex := PolygonalComplex(colComplex);

            maxVert := VerticesAttributeOfVEFComplex(complex)[NumberOfVertices(complex)];
            maxEdge := Edges(complex)[NumberOfEdges(complex)];
            maxFace := Faces(complex)[NumberOfFaces(complex)];
            vertices := ShallowCopy( VerticesAttributeOfVEFComplex(complex) );
            edges := List( Edges(complex), e -> e + maxVert );
            faces := List( Faces(complex), f -> f + maxVert + maxEdge );
            cols := List( Colours(colComplex), c -> c + maxVert + maxEdge + maxFace );

            names := Union( vertices, edges, faces, cols);
	    colours := [vertices,edges, faces,cols];
	    incidence := function(x,y)
                if x in vertices and y in edges then
                    return x in VerticesOfEdges(complex)[y-maxVert];
                elif x in edges and y in vertices then
                    return y in VerticesOfEdges(complex)[x-maxVert];
                elif x in edges and y in faces then
                    return x-maxVert in EdgesOfFaces(complex)[y-maxVert-maxEdge];
                elif x in faces and y in edges then
                    return y-maxVert in EdgesOfFaces(complex)[x-maxVert-maxEdge];
                elif x in edges and y in cols then
                    return y-maxVert-maxEdge-maxFace = ColoursOfEdges(colComplex)[x-maxVert];
                elif x in cols and y in edges then
                    return x-maxVert-maxEdge-maxFace = ColoursOfEdges(colComplex)[y-maxVert];
                else
		    return false;
	        fi; 
	    end;

	    trivialAction := function( pnt, g )
	        return pnt;
	    end;

	    graph := Graph( Group( () ), names, trivialAction, incidence );
	    graph!.colourClasses := colours;

	    return graph;   
        end
    );
fi;

if IsPackageMarkedForLoading("NautyTracesInterface", ">=0") then
    InstallMethod( ColourIncidenceNautyGraph, 
        "for an edge coloured polygonal complex",
        [IsEdgeColouredPolygonalComplex],
        function(colComplex)
            local maxVertex, maxEdge, maxFace, edgeList, colourList, v, e, f,
                colSet, vertexList, complex, c;

            complex := PolygonalComplex(colComplex);

            maxVertex := VerticesAttributeOfVEFComplex(complex)[NumberOfVertices(complex)];
            maxEdge := Edges(complex)[NumberOfEdges(complex)];
            maxFace := Faces(complex)[NumberOfFaces(complex)];

            vertexList := ShallowCopy( VerticesAttributeOfVEFComplex(complex) );
            edgeList := [];
            colourList := ListWithIdenticalEntries( NumberOfVertices(complex), 0 );

            for e in Edges(complex) do
                Add(colourList, 1);
                Append(edgeList, List( VerticesOfEdges(complex)[e], 
                    v -> [v, maxVertex + e] ) );
                Add(vertexList, maxVertex + e);
            od;

            for f in Faces(complex) do
                Add(colourList, 2);
                Add(vertexList, maxVertex + maxEdge + f);
                Append(edgeList, List( EdgesOfFaces(complex)[f], 
                    e -> [maxVertex + e, maxVertex + maxEdge + f] ) );
            od;

            for c in Colours(colComplex) do
                Add(colourList, 3);
                Add(vertexList, maxVertex + maxEdge + maxFace + c);
                Append(edgeList, List( EdgesOfColours(colComplex)[c],
                   e -> [maxVertex + e, maxVertex + maxEdge + maxFace + c] ));
            od;

            return NautyColoredGraphWithNodeLabels( edgeList, colourList, vertexList );
        end
    );
fi;

## The order of installation describes which of these functions is
## preferred - the last one has highest priority.
InstallMethod( IsIsomorphicEdgeColouredPolygonalComplex, 
    "for two edge coloured polygonal complexes",
    [IsEdgeColouredPolygonalComplex, IsEdgeColouredPolygonalComplex],
    function(complex1, complex2)
        Error("IsIsomorphicEdgeColouredPolygonalComplex: One of the packages NautyTracesInterface or GRAPE has to be available.");
    end
);

if IsPackageMarkedForLoading("GRAPE", ">=0") then
    InstallMethod( IsIsomorphicEdgeColouredPolygonalComplex, 
        "for two edge coloured polygonal complexes",
        [IsEdgeColouredPolygonalComplex, IsEdgeColouredPolygonalComplex],
        function(complex1, complex2)
            return IsIsomorphicGraph(
                ShallowCopy( ColourIncidenceGrapeGraph(complex1) ),
                ShallowCopy( ColourIncidenceGrapeGraph(complex2) ) );
        end
    );
fi;

if IsPackageMarkedForLoading("Digraphs", ">=0") and not ARCH_IS_WINDOWS() then

#TODO install the digraphs function as soon as it is available
fi;

if IsPackageMarkedForLoading("NautyTracesInterface", ">=0") then
    InstallMethod( IsIsomorphicEdgeColouredPolygonalComplex, 
        "for two edge coloured polygonal complexes", 
        [IsEdgeColouredPolygonalComplex, IsEdgeColouredPolygonalComplex],
        function(complex1, complex2)
            return IsomorphismGraphs( 
                UnderlyingNautyGraph( ColourIncidenceNautyGraph(complex1) ),
                UnderlyingNautyGraph( ColourIncidenceNautyGraph(complex2) )) <> fail;
        end
    );
fi;

InstallMethod( EdgeColouredPolygonalComplexIsomorphismRepresentatives,
    "for a list of edge colorued polygonal complexes", [IsList],
    function(ls)
        local newList, p;

        if ForAny(ls, x -> not IsEdgeColouredPolygonalComplex(x)) then
            Error("EdgeColouredPolygonalComplexIsomorphismRepresentatives: Argument has to be a list of edge coloured polygonal complexes.");
        fi;

        newList := [];
        for p in ls do
            if ForAll( newList, q -> not IsIsomorphicEdgeColouredPolygonalComplex(p,q) ) then
                Add(newList, p);
            fi;
        od;

        return newList;
    end
);



##
##      End of isomorphism testing
##
#######################################

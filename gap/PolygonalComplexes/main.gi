

# Set up the attribute scheduler
BindGlobal( "SIMPLICIAL_ATTRIBUTE_SCHEDULER", AttributeSchedulerGraph([]) );

# Set up a global variable to check if the manual is currently built
BindGlobal( "__SIMPLICIAL_MANUAL_MODE", false );
MakeReadWriteGlobal( "__SIMPLICIAL_MANUAL_MODE" );


# Methods to add attributes into the attribute scheduler
BindGlobal( "__SIMPLICIAL_AddTwistedAttribute", 
    function( attr )
        AddAttribute( SIMPLICIAL_ATTRIBUTE_SCHEDULER, attr, IsTwistedPolygonalComplex, "for a twisted polygonal complex" );
    end
);
BindGlobal( "__SIMPLICIAL_AddPolygonalAttribute", 
    function( attr )
        AddAttribute( SIMPLICIAL_ATTRIBUTE_SCHEDULER, attr, IsPolygonalComplex, "for a polygonal complex" );

        # Add a method that gives an error if executed for twisted polygonal complexes
        InstallOtherMethod( attr, "for a twisted polygonal complex",
            [IsTwistedPolygonalComplex],
            function(complex)
                if not IsPolygonalComplex(complex) then
                    Error( Concatenation( "The attribute ", NameFunction(attr), 
                        " can only be computed for polygonal complexes." ) );
                fi;
                TryNextMethod();
            end
        );
    end
);

BindGlobal( "__SIMPLICIAL_AddRamifiedAttribute",
    function( attr )
        InstallMethod(attr, "for a twisted polygonal complex without edge ramifications",
            [IsTwistedPolygonalComplex and IsNotEdgeRamified],
            function( ramSurf )
                return ComputeProperty(SIMPLICIAL_ATTRIBUTE_SCHEDULER,
                    attr, ramSurf);
            end);

        InstallOtherMethod(attr, "for a twisted polygonal complex (to check for edge ramifications)",
            [IsTwistedPolygonalComplex],
            function(complex)
                if HasIsNotEdgeRamified(complex) and IsNotEdgeRamified(complex) then
                    TryNextMethod();
                fi;
                if not IsNotEdgeRamified(complex) then
                    Error("Given twisted polygonal complex contains edge ramifications.");
                fi;
                return attr(complex);
            end
        );
    end
);

BindGlobal( "__SIMPLICIAL_AddRamifiedPolygonalAttribute",
    function( attr )
        InstallMethod(attr, "for a polygonal complex without edge ramifications",
            [IsPolygonalComplex and IsNotEdgeRamified],
            function( ramSurf )
                return ComputeProperty(SIMPLICIAL_ATTRIBUTE_SCHEDULER,
                    attr, ramSurf);
            end);

        InstallOtherMethod(attr, "for a twisted polygonal complex (to check for edge ramifications and polygonal complex)",
            [IsTwistedPolygonalComplex],
            function(complex)
                if not IsPolygonalComplex(complex) then
                    Error( Concatenation( "The attribute ", NameFunction(attr), 
                        " can only be computed for polygonal complexes without edge ramifications." ) );
                fi;
                if HasIsNotEdgeRamified(complex) and IsNotEdgeRamified(complex) then
                    TryNextMethod();
                fi;
                if not IsNotEdgeRamified(complex) then
                    Error( Concatenation( "The attribute ", NameFunction(attr), 
                        " can only be computed for polygonal complexes without edge ramifications." ) );
                fi;
                return attr(complex);
            end
        );
    end
);

BindGlobal( "__SIMPLICIAL_AddSurfaceAttribute",
    function( attr )
        InstallMethod(attr, "for a twisted polygonal surface",
            [IsTwistedPolygonalSurface],
            function( surface )
                return ComputeProperty(SIMPLICIAL_ATTRIBUTE_SCHEDULER,
                    attr, surface);
            end);

        InstallOtherMethod(attr, "for a twisted polygonal complex (to check if it is a surface)",
            [IsTwistedPolygonalComplex],
            function(complex)
                if HasIsNotEdgeRamified(complex) and IsNotEdgeRamified(complex) and
                    HasIsNotVertexRamified(complex) and IsNotVertexRamified(complex) then
                    TryNextMethod();
                fi;
                if not IsTwistedPolygonalSurface(complex) then
                    Error("Given twisted polygonal complex is not a twisted polygonal surface.");
                fi;
                return attr(complex);
            end
        );
    end
);


##
## General check methods
#TODO should those be made into actual methods?
##
BindGlobal( "__SIMPLICIAL_CheckVertex", 
    function( complex, vertex, name )
        local mes;

        if not vertex in VerticesAttributeOfComplex(complex) then
            mes := Concatenation( name, ": Given vertex ", String(vertex), 
                " does not lie in the given complex." );
            Error(mes);
        fi;
    end
);
BindGlobal( "__SIMPLICIAL_CheckEdge",
    function( complex, edge, name )
        local mes;

        if not edge in Edges(complex) then
            mes := Concatenation( name, ": Given edge ", String(edge), 
                " does not lie in the given complex." );
            Error(mes);
        fi;
    end
);
BindGlobal( "__SIMPLICIAL_CheckFace", 
    function( complex, face, name )
        local mes;

        if not face in Faces(complex) then
            mes := Concatenation( name, ": Given face ", String(face), 
                " does not lie in the given complex." );
            Error(mes);
        fi;
    end
);
BindGlobal( "__SIMPLICIAL_CheckChamber", 
    function( complex, chamber, name )
        local mes;

        if not chamber in Chambers(complex) then
            mes := Concatenation( name, ": Given chamber ", String(chamber), 
                " does not lie in the given complex." );
            Error(mes);
        fi;
    end
);

BindGlobal( "__SIMPLICIAL_CheckIncidenceVertexEdge",
    function( complex, vertex, edge, name )
        local mes;
        
        if not vertex in VerticesOfEdges(complex)[edge] then
            mes := Concatenation( name, ": Given vertex ", String(vertex),
                " does not lie in given edge ", String(edge),
                " of the given complex.");
            Error(mes);
        fi;
    end
);
BindGlobal( "__SIMPLICIAL_CheckIncidenceEdgeFace",
    function( complex, edge, face, name )
        local mes;
        
        if not edge in EdgesOfFaces(complex)[face] then
            mes := Concatenation( name, ": Given edge ", String(edge),
                " does not lie in given face ", String(face),
                " of the given complex.");
            Error(mes);
        fi;
    end
);
BindGlobal( "__SIMPLICIAL_CheckIncidenceVertexFace",
    function( complex, vertex, face, name )
        local mes;
        
        if not vertex in VerticesOfFaces(complex)[face] then
            mes := Concatenation( name, ": Given vertex ", String(vertex),
                " does not lie in given face ", String(face),
                " of the given complex.");
            Error(mes);
        fi;
    end
);

##
## Equality and display methods
##

## Equality test
InstallMethod( \=, "for two twisted polygonal complexes with default chamber systems", IsIdenticalObj,
    [IsTwistedPolygonalComplex and IsDefaultChamberSystem, IsTwistedPolygonalComplex and IsDefaultChamberSystem],
    function(c1, c2)
        return VerticesOfEdges(c1) = VerticesOfEdges(c2) and 
            EdgesOfFaces(c1) = EdgesOfFaces(c2);
    end
);
InstallMethod( \=, "for two twisted polygonal complexes", IsIdenticalObj,
    [IsTwistedPolygonalComplex, IsTwistedPolygonalComplex],
    function(c1, c2)
        return VerticesOfChambers(c1) = VerticesOfChambers(c2) and
            EdgesOfChambers(c1) = EdgesOfChambers(c2) and
            FacesOfChambers(c1) = FacesOfChambers(c2) and
            ZeroAdjacencyInvolution(c1) = ZeroAdjacencyInvolution(c2) and
            OneAdjacencyInvolution(c1) = OneAdjacencyInvolution(c2) and
            TwoAdjacencyClasses(c1) = TwoAdjacencyClasses(c2);
    end
);


##
## We implement the display/view/print-methods as recommended in the GAP-manual

BindGlobal( "__SIMPLICIAL_PolygonalComplexName",
    function(complex, big)
        local nameList;

        if big then
            nameList := ["SimplicialSurface", "PolygonalSurface", 
                "TriangularComplex", "PolygonalComplex",
                "TwistedPolygonalComplex", "TwistedPolygonalSurface"];
        else
            nameList := ["simplicial surface", "polygonal surface", 
                "triangular complex", "polygonal complex",
                "twisted polygonal complex", "twisted polygonal surface"];
        fi;

        if IsSimplicialSurface(complex) then
            return nameList[1];
        elif IsPolygonalSurface(complex) then
            return nameList[2];
        elif IsTriangularComplex(complex) then
            return nameList[3];
        elif IsPolygonalComplex(complex) then
            return nameList[4];
        elif IsTwistedPolygonalSurface(complex) then
            return nameList[6];
        else
            return nameList[5];
        fi;
    end
);

# Print (via String)
InstallMethod( String, "for a twisted polygonal complex", [IsTwistedPolygonalComplex],
    function(complex)
        local str, out;

        str := "";
        out := OutputTextString(str, true);
        # Since EdgeColouredComplexes are derived, we need to handle them
        # as well
        if IsEdgeColouredTwistedPolygonalComplex(complex) then
            PrintTo( out, "EdgeColoured" );
            PrintTo( out, __SIMPLICIAL_PolygonalComplexName( PolygonalComplex(complex), true ) );
            PrintTo( out, "NC( " );
            PrintTo( out, String(TwistedPolygonalComplex(complex)) );
            PrintTo( out, ", " );
            PrintTo( out, String(ColoursOfEdges(complex)) );
            PrintTo( out, " )" );
        else
            PrintTo(out,  __SIMPLICIAL_PolygonalComplexName(complex, true) );
            if IsPolygonalComplex(complex) and IsDefaultChamberSystem(complex) then
                PrintTo( out, "ByDownwardIncidenceNC(" );
                PrintTo( out, VerticesOfEdges(complex) );
                PrintTo( out, ", " );
                PrintTo( out, EdgesOfFaces(complex) );
            else
                PrintTo( out, "ByChamberRelationsNC(" );
                PrintTo( out, VerticesOfChambers(complex) );
                PrintTo( out, ", " );
                PrintTo( out, EdgesOfChambers(complex) );
                PrintTo( out, ", " );
                PrintTo( out, FacesOfChambers(complex) );
                PrintTo( out, ", " );
                PrintTo( out, ZeroAdjacencyInvolution(complex) );
                PrintTo( out, ", " );
                PrintTo( out, OneAdjacencyInvolution(complex) );
                PrintTo( out, ", " );
                if IsNotEdgeRamified(complex) then
                    PrintTo( out, TwoAdjacencyInvolution(complex) );
                else
                    PrintTo( out, TwoAdjacencyClasses(complex) );
                fi;
            fi;
            PrintTo( out, ")" );
        fi;

        CloseStream(out);

        return str;
    end
);

# View

# To avoid recomputing the view-information every time the colour scheme
# changes, this method was created
InstallMethod( ViewInformation, "for a twisted polygonal complex", 
    [IsTwistedPolygonalComplex],
    function(complex)
        local strList, str, out;

        strList := [];
        str := "";
        out := OutputTextString(str,true);
        PrintTo( out, __SIMPLICIAL_PolygonalComplexName(complex, false) );
        PrintTo(out, " (");
        CloseStream(out);
        Add( strList, [str, 0] );

        Add( strList, [Concatenation(String(NumberOfVertices(complex)), " vertices"), 1] );
        Add( strList, [", ", 0] );
        Add( strList, [Concatenation(String(NumberOfEdges(complex)), " edges"), 2] );
        if IsPolygonalComplex(complex) then
            Add( strList, [", and ", 0] );
        else
            Add( strList, [", ", 0] );
        fi;
        Add( strList, [Concatenation(String(NumberOfFaces(complex)), " faces"), 3] );
        if not IsPolygonalComplex(complex) then
            Add( strList, [", and ", 0] );
            Add( strList, [Concatenation(String(NumberOfChambers(complex)), " chambers"), 0] );
        fi;
        Add( strList, [")", 0] );

        return strList;
    end
);
InstallMethod( ViewString, "for a twisted polygonal complex", [IsTwistedPolygonalComplex],
    function(complex)
        # We have to distinguish coloured and uncoloured complexes
        if IsEdgeColouredTwistedPolygonalComplex(complex) then
             return __SIMPLICIAL_ColourString( ViewInformationEdgeColoured(complex), 
                [ SIMPLICIAL_COLOURS_WILD_1_DEFAULT, 
                    SIMPLICIAL_COLOURS_WILD_2_DEFAULT, 
                    SIMPLICIAL_COLOURS_WILD_3_DEFAULT ]);
        else
            return __SIMPLICIAL_ColourString( ViewInformation(complex), 
                [ SIMPLICIAL_COLOURS_VERTICES_DEFAULT, 
                    SIMPLICIAL_COLOURS_EDGES_DEFAULT, 
                    SIMPLICIAL_COLOURS_FACES_DEFAULT ]);
        fi; 
    end
);
InstallMethod( ViewObj, "for a twisted polygonal complex", [IsTwistedPolygonalComplex],
    function(complex)
        # We have to distinguish coloured and uncoloured complexes
        if IsEdgeColouredTwistedPolygonalComplex(complex) then
             if SIMPLICIAL_COLOURS_ON then
                __SIMPLICIAL_PrintColourString( ViewInformationEdgeColoured(complex), 
                    [ SIMPLICIAL_COLOURS_WILD_1, 
                        SIMPLICIAL_COLOURS_WILD_2, 
                        SIMPLICIAL_COLOURS_WILD_3 ]);
            else
                Print(__SIMPLICIAL_UncolouredString( ViewInformationEdgeColoured(complex) ));
            fi;
        else
            if SIMPLICIAL_COLOURS_ON then
                __SIMPLICIAL_PrintColourString( ViewInformation(complex), 
                    [ SIMPLICIAL_COLOURS_VERTICES, 
                        SIMPLICIAL_COLOURS_EDGES, 
                        SIMPLICIAL_COLOURS_FACES ]);
            else
                Print(__SIMPLICIAL_UncolouredString( ViewInformation(complex) ));
            fi;
        fi;
    end
);


# Display
InstallMethod( DisplayInformation, "for a twisted polygonal complex", 
    [IsTwistedPolygonalComplex],
    function(complex)
        local strList, x, umb, set, str, out, i;

        strList := [];
        str := "";
        out := OutputTextString(str, true);
        PrintTo(out, __SIMPLICIAL_PolygonalComplexName(complex, true) );
        if IsPolygonalSurface(complex) then # more information
            PrintTo(out,  " (" );
            if IsClosedComplex(complex) then
                PrintTo(out, "closed, ");
            fi;
            
            if IsOrientableComplex(complex) then
                PrintTo(out, "orientable, ");
            else
                PrintTo(out, "non-orientable, ");
            fi;

            if IsConnectedComplex(complex) then
                PrintTo(out, "Euler-characteristic ", EulerCharacteristic(complex) );
            else
                PrintTo(out,  NumberOfConnectedComponents(complex), " connected components" );
            fi;
            PrintTo(out,  ")\n");
        fi;
        Add( strList, [ str, 0 ] );

        # Vertices
        Add( strList, [ Concatenation(
            "    Vertices (", String(NumberOfVertices(complex)), "): ", 
            String(VerticesAttributeOfComplex(complex)), "\n"), 1 ] );
        # Edges
        Add( strList, [ Concatenation(
            "    Edges (", String(NumberOfEdges(complex)), "): ", 
            String(Edges(complex)), "\n"), 2 ] );
        # Faces
        Add( strList, [ Concatenation(
            "    Faces (", String(NumberOfFaces(complex)), "): ", 
            String(Faces(complex)), "\n"), 3 ] );

        if not IsPolygonalComplex(complex) then
            # Chambers
            Add( strList, [ Concatenation(
                "    Chambers (", String(NumberOfChambers(complex)), "): ",
                String(Chambers(complex)), "\n"), 0]);
        fi;

        # VerticesOfEdges
        Add( strList, [ "    Vertices", 1 ] );
        Add( strList, [ "of", 0 ] );
        Add( strList, [ "Edges", 2 ] );
        Add( strList, [ ": [ ", 0 ] );
        for i in [1..Length(VerticesOfEdges(complex))] do
            if IsBound( VerticesOfEdges(complex)[i] ) then
                set := VerticesOfEdges(complex)[i];
                Add( strList, [ "[ ", 2 ] );
                Add( strList, [ String(set[1]), 1 ] );
                Add( strList, [ ", ", 0 ] );
                Add( strList, [ String(set[2]), 1 ] );
                Add( strList, [ " ]", 2 ] );
            fi;
            Add( strList, [", ", 0] );
        od;
        # Remove final ","
        Remove(strList);
        Add( strList, [ " ]\n", 0 ] );

        
        # VerticesOfFaces
        Add( strList, [ "    Vertices", 1 ] );
        Add( strList, [ "of", 0 ] );
        Add( strList, [ "Faces", 3 ] );
        Add( strList, [ ": [ ", 0 ] );
        for i in [1..Length(VerticesOfFaces(complex))] do
            if IsBound(VerticesOfFaces(complex)[i]) then
                set := VerticesOfFaces(complex)[i];
                Add( strList, [ "[ ", 3 ] );
                for x in set do
                    Add( strList, [ String(x), 1 ] );
                    Add( strList, [ ", ", 0 ] );
                od;
                # Replace last "," by "]"
                Remove(strList);
                Add( strList, [" ]", 3] );
            fi;
            Add( strList, [", ", 0] );
        od;
        # Remove final ","
        Remove(strList);
        Add( strList, [ " ]\n", 0 ] );
        
        
        # EdgesOfFaces
        Add( strList, [ "    Edges", 2 ] );
        Add( strList, [ "of", 0 ] );
        Add( strList, [ "Faces", 3 ] );
        Add( strList, [ ": [ ", 0 ] );
        for i in [1..Length(EdgesOfFaces(complex))] do
            if IsBound(EdgesOfFaces(complex)[i]) then
                set := EdgesOfFaces(complex)[i];
                Add( strList, [ "[ ", 3 ] );
                for x in set do
                    Add( strList, [ String(x), 2 ] );
                    Add( strList, [ ", ", 0 ] );
                od;
                # Replace last "," by "]"
                Remove(strList);
                Add( strList, [" ]", 3] );
            fi;
            Add( strList, [", ", 0] );
        od;
        # Remove final ","
        Remove(strList);
        Add( strList, [ " ]\n", 0 ] );

        
        if IsPolygonalSurface(complex) then
            # UmbrellaPathsOfVertices
            Add( strList, [ "    Umbrella-paths: [ ", 0 ] );
            for i in [1..Length(UmbrellaPathsOfVertices(complex))] do
                if IsBound(UmbrellaPathsOfVertices(complex)[i]) then
                    umb := UmbrellaPathsOfVertices(complex)[i];
                    Append( strList, ViewInformation(umb) );
                fi;
                Add( strList, [", ", 0] );
            od;
            Remove(strList);
            Add( strList, [ " ]\n", 0 ] );
        fi;

        return strList;
    end
);
#TODO better support for twisted polygonal complexes
InstallMethod( DisplayString, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        # We have to distinguish coloured and uncoloured complexes
        if IsEdgeColouredPolygonalComplex(complex) then
            return __SIMPLICIAL_ColourString( DisplayInformationEdgeColoured(complex),
                [SIMPLICIAL_COLOURS_WILD_1_DEFAULT, 
                    SIMPLICIAL_COLOURS_WILD_2_DEFAULT, 
                    SIMPLICIAL_COLOURS_WILD_3_DEFAULT]);
 
        else
            return __SIMPLICIAL_ColourString( DisplayInformation(complex),
                [SIMPLICIAL_COLOURS_VERTICES_DEFAULT, 
                    SIMPLICIAL_COLOURS_EDGES_DEFAULT, 
                    SIMPLICIAL_COLOURS_FACES_DEFAULT]);
        fi;
    end
);
InstallMethod( Display, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        # We have to distinguish coloured and uncoloured complexes
        if IsEdgeColouredPolygonalComplex(complex) then
            if SIMPLICIAL_COLOURS_ON then
                __SIMPLICIAL_PrintColourString( DisplayInformationEdgeColoured(complex), 
                    [ SIMPLICIAL_COLOURS_WILD_1, 
                        SIMPLICIAL_COLOURS_WILD_2, 
                        SIMPLICIAL_COLOURS_WILD_3 ]);
            else
                Print(__SIMPLICIAL_UncolouredString( DisplayInformationEdgeColoured(complex) ));
            fi;
        else
            if SIMPLICIAL_COLOURS_ON then
                __SIMPLICIAL_PrintColourString( DisplayInformation(complex), 
                    [ SIMPLICIAL_COLOURS_VERTICES, SIMPLICIAL_COLOURS_EDGES, SIMPLICIAL_COLOURS_FACES ]);
            else
                Print(__SIMPLICIAL_UncolouredString( DisplayInformation(complex) ));
            fi;
        fi;
    end
);


##
## <
##
BindGlobal("__SIMPLICIAL_LexicographicCounterComparison",
    function(count1, count2)
        local i, l1, l2, min;
    
	count1:=ListCounter(count1);
	count2:=ListCounter(count2);
        l1 := Length(count1);
        l2 := Length(count2);
        if l1 < l2 then
            min := l1;
        else
            min := l2;
        fi;

        for i in [ 1 .. min] do
            if count1[i][1] <> count2[i][1] then
                return count1[i][1] < count2[i][1];
            elif count1[i][2] <> count2[i][2] then
                return count1[i][2] > count2[i][2];  #first one has more 
            fi;
        od;
        # now we know that up to the minimum of their lengths equality holds
        return l1 < l2;   
    end
);
InstallMethod( \<, "for two polygonal complexes", 
    [IsPolygonalComplex, IsPolygonalComplex],
    function(complex1, complex2)
        # First compare the number of faces
        if NumberOfFaces(complex1) <> NumberOfFaces(complex2) then
            return NumberOfFaces(complex1) < NumberOfFaces(complex2);
        fi;

        # Then compare the number of vertices
        if NumberOfVertices(complex1) <> NumberOfVertices(complex2) then
            return NumberOfVertices(complex1) < NumberOfVertices(complex2);
        fi;

        # Compare VertexCounters lexicographically
        if ListCounter(CounterOfVertices(complex1)) <> ListCounter(CounterOfVertices(complex2)) then
            return __SIMPLICIAL_LexicographicCounterComparison(CounterOfVertices(complex1), CounterOfVertices(complex2));
        fi;

        # Compare FaceCounters lexicographically
        if ListCounter(CounterOfFaces(complex1)) <> ListCounter(CounterOfFaces(complex2)) then
            return __SIMPLICIAL_LexicographicCounterComparison(CounterOfFaces(complex1), CounterOfFaces(complex2));
        fi;

        ###############################
        # above are comparisons for isomorphism classes
        #
        # below are internal comparisons
        ###############################
        if EdgesOfFaces(complex1) <> EdgesOfFaces(complex2) then
            return EdgesOfFaces(complex1) < EdgesOfFaces(complex2);
        fi;
        if VerticesOfEdges(complex1) <> VerticesOfEdges(complex2) then
            return VerticesOfEdges(complex1) < VerticesOfEdges(complex2);
        fi;
    end
);





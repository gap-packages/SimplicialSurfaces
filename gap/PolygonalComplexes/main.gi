#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2016
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

# Set up the attribute scheduler
BindGlobal( "SIMPLICIAL_ATTRIBUTE_SCHEDULER", AttributeSchedulerGraph([]) );

# Set up a global variable to check if the manual is currently built
BindGlobal( "__SIMPLICIAL_MANUAL_MODE", false );
MakeReadWriteGlobal( "__SIMPLICIAL_MANUAL_MODE" );


# Methods to add attributes into the attribute scheduler
BindGlobal( "__SIMPLICIAL_AddVEFAttribute", 
    function( attr )
        AddAttribute( SIMPLICIAL_ATTRIBUTE_SCHEDULER, attr, IsVEFComplex, "for a VEF-complex" );
    end
);
BindGlobal( "__SIMPLICIAL_AddPolygonalAttribute", 
    function( attr )
        AddAttribute( SIMPLICIAL_ATTRIBUTE_SCHEDULER, attr, IsPolygonalComplex, "for a polygonal complex" );

        # Add a method that gives an error if executed for bend polygonal complexes
        InstallOtherMethod( attr, "for a bend polygonal complex",
            [IsBendPolygonalComplex],
            function(bendComplex)
                Error( Concatenation( "The attribute ", NameFunction(attr), 
                    " can only be computed for polygonal complexes." ) );
            end
        );
    end
);
BindGlobal( "__SIMPLICIAL_AddBendPolygonalAttribute", 
    function( attr )
        AddAttribute( SIMPLICIAL_ATTRIBUTE_SCHEDULER, attr, IsBendPolygonalComplex, "for a bend polygonal complex" );

        # Add a method that gives an error if executed for polygonal complexes
        InstallOtherMethod( attr, "for a polygonal complex",
            [IsPolygonalComplex],
            function(complex)
                Error( Concatenation( "The attribute ", NameFunction(attr), 
                    " can only be computed for bend polygonal complexes." ) );
            end
        );
    end
);

BindGlobal( "__SIMPLICIAL_AddRamifiedAttribute",
    function( attr )
        InstallMethod(attr, "for a ramified polygonal surface",
            [IsRamifiedPolygonalSurface],
            function( ramSurf )
                return ComputeProperty(SIMPLICIAL_ATTRIBUTE_SCHEDULER,
                    attr, ramSurf);
            end);

        InstallOtherMethod(attr, "for a polygonal complex (to check if ramified)",
            [IsPolygonalComplex],
            function(complex)
                if HasIsRamifiedPolygonalSurface(complex) and IsRamifiedPolygonalSurface(complex) then
                    TryNextMethod();
                fi;
                if not IsRamifiedPolygonalSurface(complex) then
                    Error("Given polygonal complex is not a ramified polygonal surface");
                fi;
                return attr(complex);
            end
        );
    end
);

BindGlobal( "__SIMPLICIAL_AddSurfaceAttribute",
    function( attr )
        InstallMethod(attr, "for a polygonal surface",
            [IsPolygonalSurface],
            function( surface )
                return ComputeProperty(SIMPLICIAL_ATTRIBUTE_SCHEDULER,
                    attr, surface);
            end);

        InstallOtherMethod(attr, "for a polygonal complex (to check if surface)",
            [IsPolygonalComplex],
            function(complex)
                if HasIsPolygonalSurface(complex)and IsPolygonalSurface(complex) then
                    TryNextMethod();
                fi;
                if not IsPolygonalSurface(complex) then
                    Error("Given polygonal complex is not a polygonal surface.");
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

        if not vertex in VerticesAttributeOfVEFComplex(complex) then
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

##
## Equality and display methods
##

## Equality test
InstallMethod( \=, "for two polygonal complexes", IsIdenticalObj,
    [IsPolygonalComplex, IsPolygonalComplex],
    function(c1, c2)
        return VerticesOfEdges(c1) = VerticesOfEdges(c2) and EdgesOfFaces(c1) = EdgesOfFaces(c2);
    end
);


##
## We implement the display/view/print-methods as recommended in the GAP-manual

BindGlobal( "__SIMPLICIAL_PolygonalComplexName",
    function(complex, big)
        local nameList;

        if big then
            nameList := ["SimplicialSurface", "PolygonalSurface", 
                "RamifiedSimplicialSurface", "RamifiedPolygonalSurface", 
                "TriangularComplex", "PolygonalComplex"];
        else
            nameList := ["simplicial surface", "polygonal surface", 
                "ramified simplicial surface", "ramified polygonal surface", 
                "triangular complex", "polygonal complex"];
        fi;

        if IsSimplicialSurface(complex) then
            return nameList[1];
        elif IsPolygonalSurface(complex) then
            return nameList[2];
        elif IsRamifiedSimplicialSurface(complex) then
            return nameList[3];
        elif IsRamifiedPolygonalSurface(complex) then
            return nameList[4];
        elif IsTriangularComplex(complex) then
            return nameList[5];
        else
            return nameList[6];
        fi;
    end
);

# Print (via String)
InstallMethod( String, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        local str, out;

        str := "";
        out := OutputTextString(str, true);
        PrintTo(out,  __SIMPLICIAL_PolygonalComplexName(complex, true) );

        PrintTo( out, "ByDownwardIncidenceNC(" );
        PrintTo( out, VerticesOfEdges(complex) );
        PrintTo( out, ", " );
        PrintTo( out, EdgesOfFaces(complex) );
        PrintTo( out, ")" );

        CloseStream(out);

        return str;
    end
);

# View

# To avoid recomputing the view-information every time the colour scheme
# changes, this method was created
InstallMethod( ViewInformation, "for a polygonal complex", 
    [IsPolygonalComplex],
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
        Add( strList, [Concatenation(String(NumberOfEdges(complex)), " edges "), 2] );
        Add( strList, ["and ", 0] );
        Add( strList, [Concatenation(String(NumberOfFaces(complex)), " faces"), 3] );
        Add( strList, [")", 0] );

        return strList;
    end
);
InstallMethod( ViewString, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        return __SIMPLICIAL_ColourString( ViewInformation(complex), 
            [ SIMPLICIAL_COLOURS_VERTICES_DEFAULT, SIMPLICIAL_COLOURS_EDGES_DEFAULT, SIMPLICIAL_COLOURS_FACES_DEFAULT ]);
    end
);
InstallMethod( ViewObj, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        if SIMPLICIAL_COLOURS_ON then
            __SIMPLICIAL_PrintColourString( ViewInformation(complex), 
                [ SIMPLICIAL_COLOURS_VERTICES, SIMPLICIAL_COLOURS_EDGES, SIMPLICIAL_COLOURS_FACES ]);
        else
            Print(__SIMPLICIAL_UncolouredString( ViewInformation(complex) ));
        fi;
    end
);


# Display
InstallMethod( DisplayInformation, "for a polygonal complex", 
    [IsPolygonalComplex],
    function(complex)
        local strList, x, umb, set, str, out, i;

        strList := [];
        str := "";
        out := OutputTextString(str, true);
        PrintTo(out, __SIMPLICIAL_PolygonalComplexName(complex, true) );
        if IsPolygonalSurface(complex) then # more information
            PrintTo(out,  " (" );
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
            PrintTo(out,  ")\n");
        fi;
        Add( strList, [ str, 0 ] );

        # Vertices
        Add( strList, [ Concatenation(
            "    Vertices (", String(NumberOfVertices(complex)), "): ", 
            String(VerticesAttributeOfVEFComplex(complex)), "\n"), 1 ] );
        # Edges
        Add( strList, [ Concatenation(
            "    Edges (", String(NumberOfEdges(complex)), "): ", 
            String(Edges(complex)), "\n"), 2 ] );
        # Faces
        Add( strList, [ Concatenation(
            "    Faces (", String(NumberOfFaces(complex)), "): ", 
            String(Faces(complex)), "\n"), 3 ] );

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
            # UmbrellasOfVertices
            Add( strList, [ "    Umbrellas: [ ", 0 ] );
            for i in [1..Length(UmbrellasOfVertices(complex))] do
                if IsBound(UmbrellasOfVertices(complex)[i]) then
                    umb := UmbrellasOfVertices(complex)[i];
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
InstallMethod( DisplayString, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        return __SIMPLICIAL_ColourString( DisplayInformation(complex),
            [SIMPLICIAL_COLOURS_VERTICES_DEFAULT, SIMPLICIAL_COLOURS_EDGES_DEFAULT, SIMPLICIAL_COLOURS_FACES_DEFAULT]);
    end
);
InstallMethod( Display, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        if SIMPLICIAL_COLOURS_ON then
            __SIMPLICIAL_PrintColourString( DisplayInformation(complex), 
                [ SIMPLICIAL_COLOURS_VERTICES, SIMPLICIAL_COLOURS_EDGES, SIMPLICIAL_COLOURS_FACES ]);
        else
            Print(__SIMPLICIAL_UncolouredString( DisplayInformation(complex) ));
        fi;
    end
);


##
## <
##
BindGlobal("__SIMPLICIAL_LexicographicCounterComparison",
    function(count1, count2)
        local i, l1, l2;
    
        l1 := Length(count1);
        l2 := Length(count2);

        for i in [ 1 .. Minimum(l1,l2)] do
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
        if VertexCounter(complex1) <> VertexCounter(complex2) then
            return __SIMPLICIAL_LexicographicCounterComparison(VertexCounter(complex1), VertexCounter(complex2));
        fi;

        # Compare FaceCounters lexicographically
        if FaceCounter(complex1) <> FaceCounter(complex2) then
            return __SIMPLICIAL_LexicographicCounterComparison(FaceCounter(complex1), FaceCounter(complex2));
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

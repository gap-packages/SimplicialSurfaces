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


#TODO make this method a native part of the attribute scheduler
BindGlobal( "__SIMPLICIAL_AddPolygonalAttribute", 
    function( attr )
        AddAttribute( SIMPLICIAL_ATTRIBUTE_SCHEDULER, attr, IsPolygonalComplex, "for a polygonal complex" );
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

        if not vertex in Vertices(complex) then
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

BindGlobal( "__SIMPLICIAL_BoundEntriesOfList",
    function( list )
	return Filtered( [1..Length(list)], i -> IsBound( list[i] ) );
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

BindGlobal( "__SIMPLICIAL_PrintTo_Name",
    function(complex, nameList)
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
        PrintTo(out,  __SIMPLICIAL_PrintTo_Name(complex,
            ["SimplicialSurface", "PolygonalSurface", 
            "RamifiedSimplicialSurface", "RamifiedPolygonalSurface", 
            "TriangularComplex", "PolygonalComplex"]) );

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
        PrintTo( out, __SIMPLICIAL_PrintTo_Name(complex,
            ["simplicial surface", "polygonal surface", 
            "ramified simplicial surface", "ramified polygonal surface", 
            "triangular complex", "polygonal complex"]));
        PrintTo(out, " (");
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
            Print(__SIMPLICIAL_ColourString( ViewInformation(complex), 
                [ SIMPLICIAL_COLOURS_VERTICES, SIMPLICIAL_COLOURS_EDGES, SIMPLICIAL_COLOURS_FACES ]));
        else
            Print(__SIMPLICIAL_UncolouredString( ViewInformation(complex) ));
        fi;
    end
);


# Display
InstallMethod( DisplayInformation, "for a polygonal complex", 
    [IsPolygonalComplex],
    function(complex)
        local strList, x, umb, set, str, out;

        strList := [];
        str := "";
        out := OutputTextString(str, true);
        PrintTo(out, __SIMPLICIAL_PrintTo_Name(complex,
            ["SimplicialSurface", "PolygonalSurface", 
            "RamifiedSimplicialSurface", "RamifiedPolygonalSurface", 
            "TriangularComplex", "PolygonalComplex"]) );
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
            String(Vertices(complex)), "\n"), 1 ] );
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
        for set in VerticesOfEdges(complex) do
            Add( strList, [ "[ ", 2 ] );
            Add( strList, [ String(set[1]), 1 ] );
            Add( strList, [ ", ", 0 ] );
            Add( strList, [ String(set[2]), 1 ] );
            Add( strList, [ " ]", 2 ] );
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
        for set in VerticesOfFaces(complex) do
            Add( strList, [ "[ ", 3 ] );
            for x in set do
                Add( strList, [ String(x), 1 ] );
                Add( strList, [ ", ", 0 ] );
            od;
            # Replace last "," by "]"
            Remove(strList);
            Add( strList, [" ]", 3] );
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
        for set in EdgesOfFaces(complex) do
            Add( strList, [ "[ ", 3 ] );
            for x in set do
                Add( strList, [ String(x), 2 ] );
                Add( strList, [ ", ", 0 ] );
            od;
            # Replace last "," by "]"
            Remove(strList);
            Add( strList, [" ]", 3] );
            Add( strList, [", ", 0] );
        od;
        # Remove final ","
        Remove(strList);
        Add( strList, [ " ]\n", 0 ] );

        
        # UmbrellasOfVertices
        Add( strList, [ "    Umbrellas: [ ", 0 ] );
        for umb in UmbrellasOfVertices(complex) do
            Append( strList, ViewInformation(umb) );
            Add( strList, [", ", 0] );
        od;
        Remove(strList);
        Add( strList, [ " ]\n", 0 ] );

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
            Print(__SIMPLICIAL_ColourString( DisplayInformation(complex), 
                [ SIMPLICIAL_COLOURS_VERTICES, SIMPLICIAL_COLOURS_EDGES, SIMPLICIAL_COLOURS_FACES ]));
        else
            Print(__SIMPLICIAL_UncolouredString( DisplayInformation(complex) ));
        fi;
    end
);


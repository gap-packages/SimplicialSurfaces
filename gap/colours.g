# This file contains the colour control for the package

# General on/off switch
BindGlobal( "SIMPLICIAL_COLOURS_ON", true );
MakeReadWriteGlobal( "SIMPLICIAL_COLOURS_ON" );


# Colours for vertices, edges and faces
BindGlobal( "SIMPLICIAL_COLOURS_VERTICES_DEFAULT", "\033[31m" );
BindGlobal( "SIMPLICIAL_COLOURS_VERTICES", SIMPLICIAL_COLOURS_VERTICES_DEFAULT );
MakeReadWriteGlobal( "SIMPLICIAL_COLOURS_VERTICES" );

BindGlobal( "SIMPLICIAL_COLOURS_EDGES_DEFAULT", "\033[34m" );
BindGlobal( "SIMPLICIAL_COLOURS_EDGES", SIMPLICIAL_COLOURS_EDGES_DEFAULT );
MakeReadWriteGlobal( "SIMPLICIAL_COLOURS_EDGES" );

BindGlobal( "SIMPLICIAL_COLOURS_FACES_DEFAULT", "\033[32m" );
BindGlobal( "SIMPLICIAL_COLOURS_FACES", SIMPLICIAL_COLOURS_FACES_DEFAULT );
MakeReadWriteGlobal( "SIMPLICIAL_COLOURS_FACES" );


# Colours for wild coloured surfaces
BindGlobal( "SIMPLICIAL_COLOURS_WILD_1_DEFAULT", "\0331[m\033[31m" );
BindGlobal( "SIMPLICIAL_COLOURS_WILD_1", SIMPLICIAL_COLOURS_WILD_1_DEFAULT );
MakeReadWriteGlobal( "SIMPLICIAL_COLOURS_WILD_1" );

BindGlobal( "SIMPLICIAL_COLOURS_WILD_2_DEFAULT", "\0331[m\033[34m" );
BindGlobal( "SIMPLICIAL_COLOURS_WILD_2", SIMPLICIAL_COLOURS_WILD_2_DEFAULT );
MakeReadWriteGlobal( "SIMPLICIAL_COLOURS_WILD_2" );

BindGlobal( "SIMPLICIAL_COLOURS_WILD_3_DEFAULT", "\0331[m\033[32m" );
BindGlobal( "SIMPLICIAL_COLOURS_WILD_3", SIMPLICIAL_COLOURS_WILD_3_DEFAULT );
MakeReadWriteGlobal( "SIMPLICIAL_COLOURS_WILD_3" );



# Method to read out a coloured string-list as an uncoloured string
BindGlobal( "__SIMPLICIAL_UncolouredString",
    function(colList)
        local justStrings;

        justStrings := List( colList, i -> i[1] );
        return Concatenation(justStrings);
    end
);
# Method to return a coloured string, based on a colour list
# In colList the colour 0 represents a reset
# In colList the colour i stands in "colours"
BindGlobal( "__SIMPLICIAL_ColourString", 
    function(colList, colours)
        local out, str, pair;

        str := "";
        out := OutputTextString(str, true);
        for pair in colList do
            if pair[2] = 0 then
                # reset colouring
                PrintTo(out, "\033[0m");
            else
                # define a colouring
                PrintTo(out, colours[pair[2]]);
            fi;
            PrintTo(out, pair[1]);
        od;
        # end with a colour reset
        PrintTo(out, "\033[0m");

        return str;
    end
);

#TODO the automatical row wrap makes some of the colour commands visible -> should be avoided

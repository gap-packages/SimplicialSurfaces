
# general method
InstallMethod( DrawSurfaceToTikz, 
    "for a polygonal surface, a filename and a record",
    [IsPolygonalSurface, IsString, IsRecord],
    function(surf, fileName, printRecord)
        local file, output;

        # If no mods are set as active, define the default
        if not IsBound( printRecord!.defaultMods ) then
            printRecord!.defaultMods := ["drawingOrder", "coordinates", "metricData", "drawingStyle"];
        fi;
        if not IsBound( printRecord!.activeMods ) then
            printRecord!.activeMods := [];
        fi;

        # Try to open the given file
        file := Filename( DirectoryCurrent(), fileName ); #TODO allow absolute paths
        output := OutputTextFile( file, false ); # override other files
        if output = fail then
            Error(Concatenation("File ", String(file), " can't be opened.") );
        fi;
        SetPrintFormattingStatus( output, false );

        # Initialize the functions for the main method
        initFct := [];
        cleanFct := [];
        checkFct := [];
        computeFct := [];
        recognizeFct := [];
        addFct := [];
        startFct := [];
        coordFct := [];
        nextFct := [];
        drawVertexFct := [];
        drawEdgeFct := [];
        drawFaceFct := [];
        generalHeaderFct := [];
        tikzHeaderFct := [];
        beginDocFct := [];
        endDocFct := [];
        picOptFct := [];

        addAppendFunction := function( rec, modName, key, fct )
            local comp;

            if IsBound( rec!.(modName)!.(key) ) then
                comp := rec!.(modName)!.(key);
                if IsList(comp) then
                    Append( fct, comp );
                else
                    Add(fct, comp);
                fi;#TODO add tests
            fi;
        end;

        for modName in Concatenation( printRecord!.activeMods, printRecord!.defaultMods ) do 
            if IsBound( __SIMPLICIAL_MODLIST!.(modName) ) then
                # Initialize this mod
                if not IsBound( printRecord!.(modName) ) then
                    printRecord!.(modName) := __SIMPLICIAL_MODLIST!.(modName);
                else
                    for rname in RecNames(__SIMPLICIAL_MODLIST!.(modName)) do
                        printRecord!.(modName)!.(rname) := __SIMPLICIAL_MODLIST!.(modName)!.(rname);
                    od;
                fi;
            fi;

            # add the mods to the functions
            if not IsBound( printRecord!.(modName) ) then
                Error(Concatenation("The mod ", modName, " is not installed or given."));
            fi;

            addAppendFunction( printRecord, modName, "init", initFct );
            addAppendFunction( printRecord, modName, "cleanup", cleanFct );
            addAppendFunction( printRecord, modName, "checkFace", checkFct );
            addAppendFunction( printRecord, modName, "computeFace", computeFct );
            addAppendFunction( printRecord, modName, "recognizeVertices", recognizeFct );
            addAppendFunction( printRecord, modName, "addFace", addFct );
            addAppendFunction( printRecord, modName, "nextEdge", nextFct );
            addAppendFunction( printRecord, modName, "tikzVertex", drawVertexFct );
            addAppendFunction( printRecord, modName, "tikzEge", drawEdgeFct );
            addAppendFunction( printRecord, modName, "tikzFace", drawFaceFct );
            addAppendFunction( printRecord, modName, "startFace", startFct );
            addAppendFunction( printRecord, modName, "vertexCoords", coordFct );
            addAppendFunction( printRecord, modName, "generalHeader", generalHeaderFct );
            addAppendFunction( printRecord, modName, "tikzHeader", tikzHeaderFct );
            addAppendFunction( printRecord, modName, "beginDocument", beginDocFct );
            addAppendFunction( printRecord, modName, "endDocument", endDocFct );
            addAppendFunction( printRecord, modName, "tikzOptions", picOptFct );
        od;
        if IsBound( printRecord!.checkFaceOrder ) then
            checkFct := printRecord!.checkFaceOrder;
        fi;
        
        if IsBound( printRecord!.nextEdgeOrder ) then
            nextFct := printRecord!.nextEdgeOrder;
        else
            nextFct := List( nextFct, f -> [f,infinity] );
        fi;

        if IsBound( printRecord!.startFaceOrder ) then
            startFct := printRecord!.startFaceOrder;
        fi;

        # Initialize the record
        for i in initFct do
            ValueGlobal(i)(printRecord);
        od;
        
        EvaluateFunctionList := function( list, args )
            local i, res;

            res := fail;
            for i in [1..Size(list)] do
                res := CallFuncList( ValueGlobal(list[i]), args );
                if res <> fail then
                    return res;
                fi;
            od;

            if res = fail then
                Error("Function list could not be evaluated.");
            fi;
        end;

        # Start the actual method
        unplacedFaces := Faces(surface);
        strongComponents := [];
        while not IsEmpty(unplacedFaces) do
            # Find the starting face
            start := EvaluateFunctionList(startFct, [printRecord, surface, unplacedFaces]);
            vertexEdgePath := EvaluateFunctionList( computeFct, [printRecord, surface, start] );
            EvaluateFunctionList( addFct, [printRecord, vertexEdgePath, []] );
            unplacedFaces := Difference( unplacedFaces, [start] );

            comp := [start];

            # This is an infinite loop to extend all edges - bounded from above by the number of edges
            for k in [1..NumberOfEdges(surface)] do
                # Find the next edge
                nextEdge := fail;
                firstEdge := fail; # Fallback if all edges fail some test
                rejected := [];
                repeatData := [];
                for i in [1..Size(nextFct)] do
                    tries := 1;
                    if tries > nextFct[i][2] then
                        continue;
                    fi;
                    proposedEdge := ValueGlobal( nextFct[i][1] )(printRecord, rejected);
                    if firstEdge = fail then
                        firstEdge := proposedEdge;
                    fi;

                    # every edge is used at most once (if there could be ambiguity, the edge has more than 2 incident faces)
                    # for each edge we store
                    # 1) the adjacent face
                    # 2) the vertexEdgePath of the face
                    # 3) the recognized vertices
                    # 4) a list with the results of the checks
                    if IsBound( repeatData[proposedEdge] ) then
                        # Take data from storage
                        adFace := repeatData[proposedEdge][1];
                        vertexEdgePath := repeatData[proposedEdge][2];
                        recVertices := repeatData[proposedEdge][3];
                        testResults := repeatData[proposedEdge][4];
                    else
                        adFace := Intersection( FacesOfEdges(surface)[proposedEdge], unplacedFaces )[1];
                        vertexEdgePath := EvaluateFunctionList( computeFct, [printRecord, surface, adFace, proposedEdge ] );
                        recVertices := EvaluateFunctionList( recognizeFct, [printRecord, vertexEdgePath] );
                        testResults := [];
                    fi;

                    # do tests
                    success := true;
                    for j in [1..Size(checkFct)] do
                        if IsBound( testResults[j] ) then
                            # there was a test before
                            testResults[j] := ValueGlobal( checkFct[j] )(printRecord, vertexEdgePath, recVertices, testResults[j]);
                        else
                            testResults[j] := ValueGlobal( checkFct[j] )(printRecord, vertexEdgePath, recVertices, []);
                        fi;

                        if testResults[j][1] = false then
                            success := false;
                            break;
                        fi;
                    od;
                
                    # Store data since it is either needed to avoid recomputation or to continue
                    repeatData[proposedEdge] := [ adFace, vertexEdgePath, recVertices, testResults ];

                    if not success then
                        Add(rejected, proposedEdge);
                        proposedEdge := fail;
                        continue;
                    else
                        nextEdge := proposedEdge;
                        break;
                    fi;
                od;
                if proposedEdge = fail then
                    # take the first edge instead
                    proposedEdge = firstEdge;
                fi;

                # if there is no edge at all, we are done
                if firstEdge = fail then
                    Add( strongComponents, comp );
                    break;
                fi;

    
                # Add the new face
                EvaluateFunctionList( addFct, [printRecord, repeatData[proposedEdge][2], repeatData[proposedEdge][3]] );
                Add( comp, repeatData[proposedEdge][1] );
            od;
        od;

        # Set the strongly connected components (if not already done)
        if not HasStronglyConnectedComponents( surface ) then
            SetStronglyConnectedComponents( surface, List( strongComponents, c -> SubsurfaceByFacesNC(surface, c) ) );
        fi;


        # Write this data into the file
        AppendTo( output, EvaluateFunctionList( generalHeaderFct, [printRecord] ) );
        AppendTo( output, EvaluateFunctionList( tikzHeaderFct, [printRecord] ) );
        AppendTo( output, EvaluateFunctionList( beginDocFct, [printRecord] ) );
        for comp in StronglyConnectedComponents(surface) do
            # Start the picture
            AppendTo( output, "\n\\begin{tikzpicture}[", EvaluateFunctionList( picOptFct, [printRecord] ), "]\n" );

            # Define coordinates of vertices
            for v in Vertices(comp) do
                vertexCoords := EvaluateFunctionList( coordFct, [printRecord, surface, v] );
                for i in [1..Size(vertexCoords)] do
                    AppendTo( output, "\\coordinate (V", v, "_", i, ") at (", vertexCoords[i][1], ", ", vertexCoords[i][2], ");\n" );
                od;
            od;
            AppendTo(output, "\n\n");

            # Draw faces
            for f in Faces(comp) do
                facePath := EvaluateFunctionList(  ); #TODO
            od;

            # End the picture
            AppendTo( output, "\n\\end{tikzpicture}" );
        od;
        AppendTo( output, EvaluateFunctionList( endDocFct ) );
            

        # Clean up the record
        for i in cleanFct do
            ValueGlobal(i)(printRecord);
        od;

        return printRecord;
    end
);



# mods

BindGlobal( "__SIMPLICIAL_MODLIST", rec() );

InstallMethod( PrintRecordADDMOD, 
    "for the name of a mod and its record of essential components",
    [IsString, IsRecord],
    function(name, rec)
        # Check if this mod was already added
        if IsBound( __SIMPLICIAL_MODLIST!.(name) ) then
            Error("PrintRecordADDMOD: This mod is already defined.");
        fi;

        # Otherwise add this mod
        __SIMPLICIAL_MODLIST!.(name) := rec;
    end
);

# drawingOrder



# coordinates



# metricData



# drawingStyle



# colouring

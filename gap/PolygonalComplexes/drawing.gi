
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
        initFct := ["init"];
        cleanupFct := ["cleanup"];
        checkFaceFct := ["checkFace"];
        computeFaceFct := ["computeFace"];
        recognizeVerticesFct := ["recognizeVertices"];
        addFaceFct := ["addFace"];
        startFaceFct := ["startFace"];
        vertCoordFct := ["vertexCoords"];
        facePerimeterFct := ["facePerimeter"];
        edgeEndpointsFct := ["edgeEndpoints"];
        nextEdgeFct := ["nextEdge"];
        drawVertexFct := ["tikzVertex"];
        drawEdgeFct := ["tikzEdge"];
        drawFaceFct := ["tikeFace"];
        generalHeaderFct := ["generalHeader"];
        tikzHeaderFct := ["tikzHeader"];
        beginDocFct := ["beginDocument"];
        endDocFct := ["endDocument"];
        pictureOptionsFct := ["tikzOptions"];

        allFcts := [ initFct, cleanupFct, checkFaceFct, computeFaceFct, 
            recognizeVerticesFct, addFaceFct, startFaceFct, vertCoordFct,
            facePerimeterFct, edgeEndpointsFct, nextEdgeFct, drawVertexFct,
            drawEdgeFct, drawFaceFct, generalHeaderFct, tikzHeaderFct, 
            beginDocFct, endDocFct, pictureOptionsFct];

        addAppendFunction := function( rec, modName, fct )
            local comp, key;

            key := fct[1];
            fct := [];

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
            
            for fct in allFcts do
                addAppendFunction( printRecord, modName, fct );
            od;
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
            vertexEdgePath := EvaluateFunctionList( computeFaceFct, [printRecord, surface, start] );
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
                        vertexEdgePath := EvaluateFunctionList( computeFaceFct, [printRecord, surface, adFace, proposedEdge ] );
                        recVertices := EvaluateFunctionList( recognizeVerticesFct, [printRecord, vertexEdgePath] );
                        testResults := [];
                    fi;

                    # do tests
                    success := true;
                    for j in [1..Size(checkFct)] do
                        if IsBound( testResults[j] ) then
                            # there was a test before
                            testResults[j] := ValueGlobal( checkFaceFct[j] )(printRecord, vertexEdgePath, recVertices, testResults[j]);
                        else
                            testResults[j] := ValueGlobal( checkFaceFct[j] )(printRecord, vertexEdgePath, recVertices, []);
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
        TikzCoordFromVertexPosition := function( vertPos )
            return Concatenation( "(V", vertPos[1], "_", vertPos[2], ")" );
        end;
        allVertexCoords := EvaluateFunctionList( vertCoordFct, [printRecord, surface] );
        for comp in StronglyConnectedComponents(surface) do
            # Start the picture
            AppendTo( output, "\n\\begin{tikzpicture}[", EvaluateFunctionList( picOptFct, [printRecord] ), "]\n" );

            # Define coordinates of vertices
            for v in Vertices(comp) do
                for i in [1..Size(vertexCoords)] do
                    AppendTo( output, "\\coordinate ", TikzCoordFromVertexPosition([v,i]), " at (", allVertexCoords[v][i][1], ", ", allVertexCoords[v][i][2], ");\n" );
                od;
            od;
            AppendTo(output, "\n\n");

            # Draw faces
            for f in Faces(comp) do
                facePath := EvaluateFunctionList( facePerimeterFct, [printRecord, surface, f] );
                vertexPositions := List( [1..Size(facePath)/2], i -> facePath[2*i-1] );
                AppendTo( output, EvaluateFunctionList( drawFaceFct, 
                    [printRecord, surface, f, 
                        List(vertexPositions, TikzCoordFromVertexPosition), 
                        List(vertexPositions, p -> allVertexCoords[p[1]][p[2]])] ) );
            od;

            AppendTo( output, "\n\n" );
            # Draw edges
            for e in Edges(comp) do
                ends := EvaluateFunctionList( edgeEndpointsFct, [printRecord, surface, e] );
                for i in [1..Size(ends)] do
                    AppendTo( output, EvaluateFunctionList( drawEdgeFct, [printRecord, surface, e, 
                        List( ends[i], TikzCoordFromVertexPosition ),
                        List( ends[i], p -> allVertexCoords[p[1]][p[2]] )] ) );
                od;
            od;

            AppendTo( output, "\n\n" );
            # Draw vertices
            for v in Vertices(comp) do
                positions := allVertexCoords[v];
                for i in [1..Size(positions)] do
                    AppendTo(output, EvaluateFunctionList( drawVertexFct, [printRecord, surface, v, TikzCoordFromVertexPosition([v,i]), allVertexCoords[v][i]] ));
                od;
            od;
            

            # End the picture
            AppendTo( output, "\n\\end{tikzpicture}" );
        od;
        AppendTo( output, EvaluateFunctionList( endDocFct ) );
        CloseStream(output);
        Print( "Picture written in TikZ." );


        #TODO compile?
            

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

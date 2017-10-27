
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
        startFaceFct := ["startingFace"];
        vertCoordFct := ["vertexCoordinates"];
        facePerimeterFct := ["facePerimeter"];
        edgeEndpointsFct := ["edgeEndpoints"];
        nextEdgeFct := ["nextEdge"];
        drawVertexFct := ["tikzVertex"];
        drawEdgeFct := ["tikzEdge"];
        drawFaceFct := ["tikzFace"];
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
            ValueGlobal(i)(printRecord, surface);
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
InstallMethod( PrintRecordDrawingOrderInit, 
    "for a print record and a polygonal surface", 
    [IsRecord, IsPolygonalSurface],
    function(printRecord, surface)
        if not IsBound( printRecord!.drawingOrder ) then
            printRecord!.drawingOrder := rec();
        fi;

        printRecord!.computedStartingFaces := [];

        # TODO initialize data
    end
);
InstallMethod( PrintRecordDrawingOrderCleanup, 
    "for a print record and a polygonal surface", 
    [IsRecord, IsPolygonalSurface],
    function(printRecord, surface)

        printRecord!.startingFaces := printRecord!.computedStartingFaces;
        Unbind(printRecord!.computedStartingFaces);
        # TODO cleanup
    end
);
InstallMethod( PrintRecordDrawingOrderStartingFace, 
    "for a print record, a polygonal complex and a list of possible faces",
    [IsRecord, IsPolygonalComplex, IsList],
    function(printRecord, complex, possFaces)
        local res;

        res := Minimum( possFaces );
        Add( printRecord!.computedStartingFaces, res );
        return res;    
    end
);



# coordinates
InstallMethod( PrintRecordCoordinatesInit, 
    "for a print record and a polygonal surface", 
    [IsRecord, IsPolygonalSurface],
    function(printRecord, surface)
        if not IsBound( printRecord!.coordinates ) then
            printRecord!.coordinates := rec();
        fi;

        # TODO initialize data
    end
);
InstallMethod( PrintRecordCoordinatesCleanup, 
    "for a print record and a polygonal surface", 
    [IsRecord, IsPolygonalSurface],
    function(printRecord, surface)
        # TODO cleanup
    end
);


BindGlobal( "__SIMPLICIAL_GuaranteeExistence",
    function(record, name, default)
        if not IsBound(record!.(name)) then
            record!.(name) := default;
        fi;
    end
);

BindGlobal("__SIMPLICIAL_EqualFloats",
    function(x,y, eps)
        return (x-y)^2 < eps;
    end
);

# metricData
InstallMethod( PrintRecordMetricDataInit, 
    "for a print record and a polygonal surface", 
    [IsRecord, IsPolygonalSurface],
    function(printRecord, surface)
        local lengths, angles, edges, vertices;

        __SIMPLICIAL_GuaranteeExistence( printRecord, "metricData", rec() );

        # Check the consistency of the length/angle-information
        __SIMPLICIAL_GuaranteeExistence( printRecord!.metricData, "edgeLengths", [] );
        __SIMPLICIAL_GuaranteeExistence( printRecord!.metricData, "angles", [] );
    
        lengths := printRecord!.metricData!.edgeLengths;
        angles := printRecord!.metricData!.angles;
        printRecord!.metricData!.givenEdgeLengths := lengths;
        printRecord!.metricData!.givenAngles := angles;

        #TODO allow different way to give angles

        # each angle is stored as a pair of floats [sin(alpha), cos(alpha)]
        for f in Faces(surface) do
            edges := EdgesOfFaces(surface)[f];
            vertices := VerticesOfFaces(surface)[f];
            if not IsBound(angles[f]) then
                angles[f] := [];
            fi;
            # Case all values are set
            if ForAll(edges, e -> IsBound(lengths[e])) and ForAll(vertices, v -> IsBound(angles[f][v])) then
                # Check inner angle sum
                radAngles := List( vertices, v -> Atan2(angles[f][v][1], angles[f][v][2]) );
                angleSum := Sum( radAngles );
                if __SIMPLICIAL_EqualFloats( angleSum, ( Size(edges) - 2 )/Size(edges)*FLOAT.PI, printRecord!.floatAccuracy ) then
                    # Check whether the polygon closes
                    #TODO do so with an vertexEdge-path around the perimeter
                fi;
                #TODO check for consistency and "continue" if successful
            fi;

            # Case triangle
            if Size(edges) = 3 and ForAll(edges, e -> IsBound(lengths[e])) then
                for i in [1,2,3] do
                    # find opposing vertex
                    oppVert := Difference(vertices, VerticesOfEdges(surface)[edges[i]])[1];
                    j := i mod 3 + 1;
                    k := (i+1) mod 3 + 1;
                    cos := Float( (lengths[edges[i]]^2 - lengths[edges[j]]^2 - lengths[edges[k]]^2) / ( -2*lengths[j]*lengths[k] );
                    sin := Sqrt(1 - cos^2);
                    # TODO test validity of edge lengths
                    angles[f][oppVert] := [sin, cos];
                od;
                continue;
            fi;

            # Define everything to be a regular polygon with side length 1
            for e in edges do
                lengths[e] := 1;
            od;
            regAngle := SinCos( (Size(edges) - 2) / Size(edges) * FLOAT.PI );
            for v in vertices do
                angles[v] := regAngle;
            od;
        od;

        # TODO initialize data

    end
);
InstallMethod( PrintRecordMetricDataCleanup, 
    "for a print record and a polygonal surface", 
    [IsRecord, IsPolygonalSurface],
    function(printRecord, surface)
        # TODO cleanup
    end
);
InstallMethod( PrintRecordMetricDataComputeFace,
    "for a print record, a polygonal surface and a face",
    [IsRecord, IsPolygonalSurface, IsPosInt],
    function(printRecord, surface, face)
        local edges;

        edges := EdgesOfFaces(surface)[face];
        len := printRecord!.metricData!.edgeLengths[edges[1]];
        verts := VerticesOfEdges(surface)[edges[1]];
        return PrintRecordMetricDataComputeFace(printRecord, surface, face, 
            [ edges[1], [ verts[1], [0.,0.] ], [verts[2], [Float(len),0.]] ]);
    end
);
InstallMethod( PrintRecordMetricDataComputeFace,
    "for a print record, a polygonal surface, a face and an edge (given as list of vertex coordinates)",
    [IsRecord, IsPolygonalSurface, IsPosInt, IsList],
    function(printRecord, surface, face, edge)
        local vertexEdgePath;#TODO

        vertexEdgePath := [edge[2], edge[1], edge[3]];
        usedEdges := [edge[1]];
        while Size(vertexEdgePath) < ;
    end
);



# drawingStyle
InstallMethod( PrintRecordDrawingStyleInit, 
    "for a print record and a polygonal surface", 
    [IsRecord, IsPolygonalSurface],
    function(printRecord, surface)
        if not IsBound( printRecord!.drawingStyle ) then
            printRecord!.drawingStyle := rec();
        fi;

        # TODO initialize data
    end
);
InstallMethod( PrintRecordDrawingStyleCleanup, 
    "for a print record and a polygonal surface", 
    [IsRecord, IsPolygonalSurface],
    function(printRecord, surface)
        # TODO cleanup
    end
);




# colouring
InstallMethod( PrintRecordDrawingOrderInit, "for a print record", [IsRecord],
    function(printRecord)
        if not IsBound( printRecord!.drawingOrder ) then
            printRecord!.drawingOrder := rec();
        fi;

        # TODO initialize data
    end
);
InstallMethod( PrintRecordDrawingOrderCleanup, "for a print record", [IsRecord],
    function(printRecord)
        # TODO cleanup
    end
);



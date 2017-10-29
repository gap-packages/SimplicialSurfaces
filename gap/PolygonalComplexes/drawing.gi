BindGlobal("__SIMPLICIAL_EqualFloats",
    function(x,y, eps)
        return (x-y)^2 < eps;
    end
);


BindGlobal( "__SIMPLICIAL_PrintRecordInit",
    function(rec)
        local givenStarts;

        # Starting faces
        if IsBound(rec!.startingFaces) then
            if IsPosInt(rec!.startingFaces) then
                givenStarts := [ rec!.startingFaces ];
            elif IsList( rec!.startingFaces ) and ForAll( rec!.startingFaces, IsPosInt ) then
                givenStarts := rec!.startingFaces;
            else
                Print("Given starting faces are neither a list of faces nor a single face.");
            fi;
        else
            rec!.givenStartingFaces := [];
        fi;
        rec!.givenStartingFaces := givenStarts;
        rec!.startingFaces := [];


        # edge lengths and angles
        if not IsBound( rec!.edgeLengths ) then
            rec!.edgeLengths := [];
        fi;
        rec!.givenEdgeLengths := rec!.edgeLengths;

        if not IsBound( rec!.angles ) then
            rec!.angles := [];
        fi;
        rec!.givenAngles := rec!.angles;

        # float accuracy
        if not IsBound( rec!.floatAccuracy ) then
            rec!.floatAccuracy := 0.001;
        fi;

        # coordinates (always recomputed)
        rec!.vertexCoordinates := [];
        rec!.edgeEndpints := [];
        rec!.faceVertices := [];

        #
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordCleanup",
    function(rec)
        
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordInitializePolygons",
    function(rec, surface)
        local lengths, angles, edges, vertices;

        lengths := rec!.edgeLengths;
        angles := rec!.angles;

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
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordStartingFace",
    function(rec, surface, unplacedFaces)
        local f;

        # Try to find a starting face in the givenStartingFaces
        for f in rec!.givenStartingFaces do
            if f in unplacedFaces then
                return f;
            fi;
        od;

        # Otherwise return the smallest remaining face
        return Minimum(unplacedFaces);
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordComputeFirstFace",
    function(printRecord, surface, face)
        local edges;

        edges := EdgesOfFaces(surface)[face];
        len := printRecord!.edgeLengths[edges[1]];
        verts := VerticesOfEdges(surface)[edges[1]];

        # Save those coordinates
        printRecord!.vertexCoordinates[verts[1]] := [ [0.,0.] ];
        printRecord!.vertexCoordinates[verts[2]] := [ [Float(len),0.] ];
        printRecord!.edgeEndpoints[edges[1]] := [ [ verts[1], 1 ], [ verts[2], 2 ] ];
        return __SIMPLICIAL_PrintRecordComputeFace( printRecord, surface, face, [edges[1],1] );
    end
);
BindGlobal( "__SIMPLICIAL_PrintRecordComputeFace",
    function(printRecord, surface, face, edge)
        local vertexEdgePath, usedEdges, len, lastEdge, lastVertex, vector, 
            nextEdge, nextVertex, angle, newVector, nextVertexCoords;

        lastVertex := printRecord!.edgeEndpoints[edge[1]][edge[2]][1];
        currentVertex := printRecord!.edgeEndpoints[edge[1]][edge[2]][2];
        lastEdge := edge[1];
        computedVertices := [ lastVertex[1], currentVertex[1] ];
        while Size(computedVertices) < Size(VerticesOfFaces(surface)[face]) - 1 do
            vector := printRecord!.vertexCoordinates[lastVertex[1]][lastVertex[2]] - printRecord!.vertexCoordinates[currentVertex[1]][currentVertex[2]];

            nextEdge := OtherEdgeOfVertexInFace( surface, lastVertex[1], lastEdge, face );
            nextVertex := OtherVertexOfEdge(surface, lastVertex[1], nextEdge);

            # rescale the vector
            vector := vector * Float( printRecord!.edgeLengths[nextEdge] / printRecord!.edgeLengths[lastEdge] );

            # rotate the vector
            angle := printRecord!.angles[face][lastVertex[1]];
            newVector := [ angle[2]*vector[1]+angle[1]*vector[2], -angle[1]*vector[1]+angle[2]*vector[2] ];

            nextVertexCoords := printRecord!.vertexCoordinates[currentVertex[1]][currentVertex[2]] + newVector;

            # Check if this vertex coordinates already appear somewhere
            newVertexPosition := 0;
            if not IsBound( printRecord!.vertexCoordinates[nextVertex] ) then
                printRecord!.vertexCoordinates[nextVertex] := [nextVertexCoords];
                newVertexPosition := 1;
            else
                for i in [1..Length(printRecord!.vertexCoordinates[nextVertex])] do
                    compareCoords := printRecord!.vertexCoordinates[nextVertex][i];
                    if __SIMPLICIAL_EqualFloats( 0., (compareCoords[1]-nextVertexCoords[1])^2 + (compareCoords[2]-nextVertexCoords[2])^2, printRecord!.floatAccuracy ) then
                        pos := i;
                        break;
                    fi;
                od;
                if newVertexPosition = 0 then # no match found
                    Add( printRecord!.vertexCoordinates[nextVertex], nextVertexCoords );
                    pos := Size(printRecord!.vertexCoordinates[nextVertex]);
                fi;
            fi;

            Add( computedVertices, nextVertex );
            lastVertex := currentVertex;
            currentVertex := [nextVertex, pos];
            lastEdge := nextEdge;
        od;
    end
);


# general method
InstallMethod( DrawSurfaceToTikz, 
    "for a polygonal surface, a filename and a record",
    [IsPolygonalSurface, IsString, IsRecord],
    function(surf, fileName, printRecord)
        local file, output;

        # Try to open the given file
        file := Filename( DirectoryCurrent(), fileName ); #TODO allow absolute paths
        output := OutputTextFile( file, false ); # override other files
        if output = fail then
            Error(Concatenation("File ", String(file), " can't be opened.") );
        fi;
        SetPrintFormattingStatus( output, false );


        __SIMPLICIAL_PrintRecordInit(printRecord);
        __SIMPLICIAL_PrintRecordInitializePolygons(printRecord, surface);

        # Start the actual method
        unplacedFaces := Faces(surface);
        strongComponents := [];
        while not IsEmpty(unplacedFaces) do
            # Find the starting face
            start := __SIMPLICIAL_PrintRecordStartingFace( printRecord, surface, unplacedFaces );
            Add( printRecord!.startingFaces, start );
            __SIMPLICIAL_PrintRecordComputeFirstFace( printRecord, surface, start );
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



# Basic concept:
# 
# The drawing method relies on the following separation: First, a complex
# is divided into its strongly connected components. Then, each of these
# components is split into several "drawing blocks" (depending on the
# concrete edge lengths). Each of these drawing blocks is assigned a "drawIndex".
#
# The general method starts with one face of a strongly connected
# component and draws this face.


BindGlobal("__SIMPLICIAL_EqualFloats",
    function(x,y, eps)
        return (x-y)^2 < eps;
    end
);
BindGlobal( "__SIMPLICIAL_EqualPoints",
    function( p, q, eps )
        return (p[1]-q[1])^2 + (p[2]-q[2])^2 < eps;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordInitStringList",
    function(printRecord, entry, indices)
        local ls, i;

        if not IsBound(printRecord!.(entry)) then
            printRecord!.(entry) := [];
            return;
        fi;

        if printRecord!.(entry) = [] then
            return;
        fi;

        if IsString( printRecord!.(entry) ) then
            ls := [];
            for i in indices do
                ls[i] := printRecord!.(entry);
            od;
            printRecord!.(entry) := ls;
            return;
        fi;

        if not IsList( printRecord!.(entry) ) then
            printRecord!.(entry) := [];
        fi;

        printRecord!.(entry) := List( printRecord!.(entry), String );
    end
);
BindGlobal( "__SIMPLICIAL_PrintRecordInitBool",
    function(printRecord, entry, default)
        if not IsBound(printRecord!.(entry)) or not IsBool(printRecord!.(entry)) then
            printRecord!.(entry) := default;
        fi;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordInit",
    function(printRecord, surface)
        local givenStarts, v, e, givenEdgeDrawOrder, i, col, f;

        # Starting faces
        if not IsBound(printRecord.startingFaces) and IsBound(printRecord.startingFace) then
            # If someone spells startingFace instead of startingFaces, we are lenient..
            printRecord.startingFaces := printRecord.startingFace;
            Unbind(printRecord.startingFace);
        fi;
        if IsBound(printRecord!.startingFaces) then
            if IsPosInt(printRecord!.startingFaces) then
                givenStarts := [ printRecord!.startingFaces ];
            elif IsList( printRecord!.startingFaces ) and ForAll( printRecord!.startingFaces, IsPosInt ) then
                givenStarts := printRecord!.startingFaces;
            else
                Print("Given starting faces are neither a list of faces nor a single face.");
                givenStarts := [];
            fi;
        else
            givenStarts := [];
        fi;
        printRecord!.givenStartingFaces := givenStarts;
        printRecord!.startingFaces := [];
        
        # Edge draw order
        if IsBound(printRecord.edgeDrawOrder) then
            givenEdgeDrawOrder := printRecord.edgeDrawOrder;
            if not IsList(givenEdgeDrawOrder) then
                givenEdgeDrawOrder := [];
            elif ForAll( givenEdgeDrawOrder, IsPosInt ) then
                givenEdgeDrawOrder := [ givenEdgeDrawOrder ];
            fi;
            #TODO more checks and warnings?
        else
            givenEdgeDrawOrder := [];
        fi;
        printRecord!.givenEdgeDrawOrder := givenEdgeDrawOrder;
        printRecord!.edgeDrawOrder := [];

        # Draw components and drawing indices
        printRecord.drawComponents := [];
        printRecord.drawIndices := [];

        # edge lengths and angles
        if not IsBound( printRecord!.edgeLengths ) then
            printRecord!.edgeLengths := [];
        fi;
        printRecord!.givenEdgeLengths := printRecord!.edgeLengths;

        if not IsBound( printRecord!.angles ) then
            printRecord!.angles := [];
        fi;
        printRecord!.givenAngles := printRecord!.angles;

        # float accuracy
        if not IsBound( printRecord!.floatAccuracy ) then
            printRecord!.floatAccuracy := 0.001;
        fi;

        # coordinates (always recomputed)
        printRecord!.vertexCoordinates := [];
        for v in VerticesAttributeOfComplex(surface) do
            printRecord!.vertexCoordinates[v] := [];
        od;
        printRecord!.edgeEndpoints := [];
        for e in Edges(surface) do
            printRecord!.edgeEndpoints[e] := [];
        od;
        printRecord!.faceVertices := [];
        for f in Faces(surface) do
            printRecord.faceVertices[f] := [];
        od;

        # openEdges
        printRecord!.openEdges := [];


        # drawing options
        __SIMPLICIAL_PrintRecordInitBool( printRecord, "vertexLabelsActive", true );
        __SIMPLICIAL_PrintRecordInitStringList( printRecord, "vertexLabels", 
            VerticesAttributeOfComplex(surface) );

        __SIMPLICIAL_PrintRecordInitBool( printRecord, "edgeLabelsActive", true );
        __SIMPLICIAL_PrintRecordInitStringList( printRecord, "edgeLabels", Edges(surface) );

        __SIMPLICIAL_PrintRecordInitBool( printRecord, "faceLabelsActive", true );
        __SIMPLICIAL_PrintRecordInitStringList( printRecord, "faceLabels", Faces(surface) );
        
        if not IsBound( printRecord!.scale ) then
            printRecord!.scale := 2;
        fi;
        __SIMPLICIAL_PrintRecordInitBool(printRecord, "avoidIntersections", true);

        # colours
        __SIMPLICIAL_PrintRecordInitStringList(printRecord, "vertexColours", 
            VerticesAttributeOfComplex(surface));
        __SIMPLICIAL_PrintRecordInitStringList(printRecord, "edgeColours", Edges(surface));
        __SIMPLICIAL_PrintRecordInitStringList(printRecord, "faceColours", Faces(surface));
        # if the faceColours are custom given, we check for errors
        for i in [1..Length(printRecord!.faceColours)] do
            if IsBound( printRecord!.faceColours[i] ) then
                col := printRecord!.faceColours[i];
                if StartsWith( col, "\\faceColour" ) then
                    Remove(col,10);
                    printRecord!.faceColours[i] := col;
                fi;
            fi;
        od;
#        if not IsBound( printRecord!.faceSwapColoursActive ) then
#            printRecord!.faceSwapColoursActive := false;
#        fi;


        # automatic compilation
        __SIMPLICIAL_PrintRecordInitBool( printRecord, "compileLaTeX", false );
        # only write the tikzpicture (this will not be able to compile on its own!)
        __SIMPLICIAL_PrintRecordInitBool( printRecord, "onlyTikzpicture", false );
        if printRecord!.compileLaTeX and printRecord!.onlyTikzpicture then
            Error("DrawSurfaceToTikz: The options 'compileLaTeX' and 'onlyTikzpicture' can't be true simultaneously.");
        fi;

        if not IsBound(printRecord.latexDocumentclass) then
            printRecord.latexDocumentclass := "article";
        fi;

        __SIMPLICIAL_PrintRecordInitBool(printRecord, "noOutput", false);
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordCleanup",
    function(printRecord)
        Unbind( printRecord!.openEdges );
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordInitializePolygons",
    function(printRecord, surface)
        local lengths, angles, edges, vertices, f, v, e, regAngle, sin, cos,
            radAngles, angleSum, i, oppVert, j, k;

        lengths := printRecord!.edgeLengths;
        angles := printRecord!.angles;

        #TODO allow different way to give angles

        # each angle is stored as a pair of floats [sin(alpha), cos(alpha)]
        for f in Faces(surface) do
            edges := EdgesOfFaces(surface)[f];
            vertices := VerticesOfFaces(surface)[f];
            if not IsBound(angles[f]) then
                angles[f] := [];
            fi;

#TODO can we do something to avoid recomputing angles every time?

            # Case triangle (this will overwrite the angle information!)
            if Length(edges) = 3 and ForAll(edges, e -> IsBound(lengths[e])) then
                for i in [1,2,3] do
                    # find opposing vertex
                    oppVert := Difference(vertices, VerticesOfEdges(surface)[edges[i]])[1];
                    j := i mod 3 + 1;
                    k := (i+1) mod 3 + 1;
                    cos := Float( (lengths[edges[i]]^2 - lengths[edges[j]]^2 - lengths[edges[k]]^2) / ( -2*lengths[edges[j]]*lengths[edges[k]] ) );
                    sin := Sqrt(1 - cos^2);
                    # TODO test validity of edge lengths
                    angles[f][oppVert] := [sin, cos];
                od;
                continue;
            fi;


            # Case all values are set (only relevant for non-triangles because of case before)
            if ForAll(edges, e -> IsBound(lengths[e])) and ForAll(vertices, v -> IsBound(angles[f][v])) then
                # Check inner angle sum
                radAngles := List( vertices, v -> Atan2(angles[f][v][1], angles[f][v][2]) );
                angleSum := Sum( radAngles );
                if not __SIMPLICIAL_EqualFloats( angleSum, ( Length(edges) - 2 )*FLOAT.PI, printRecord!.floatAccuracy ) then
                    Error(Concatenation("Wrong angles for face ", String(f), " given."));
                else
                    continue; # We don't check whether the face closes since this is checked in __SIMPLICIAL_PrintRecordComputeFace
                fi;
            fi;

            # Define everything to be a regular polygon with side length 1
            for e in edges do
                lengths[e] := 1;
            od;
            regAngle := SinCos( (Length(edges) - 2) / Length(edges) * FLOAT.PI );
            for v in vertices do
                angles[f][v] := regAngle;
            od;
        od;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordStartingFace",
    function(printRecord, surface, unplacedFaces)
        local f;

        # Try to find a starting face in the givenStartingFaces
        for f in printRecord!.givenStartingFaces do
            if f in unplacedFaces then
                return f;
            fi;
        od;

        # Otherwise return the smallest remaining face
        return Minimum(unplacedFaces);
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordFindVertex",
    function(printRecord, prVertex, drawIndex)
        local i, pos, compareCoords;

        pos := 0;
        for i in [1..Length(printRecord!.vertexCoordinates[prVertex[1]])] do
            compareCoords := printRecord!.vertexCoordinates[prVertex[1]][i];
            if compareCoords[3] <> drawIndex then
                continue;
            fi;

            # The test only checks the first two entries
            if __SIMPLICIAL_EqualPoints( compareCoords, prVertex[2], printRecord!.floatAccuracy ) then
                pos := i;
                break;
            fi;
        od;

        return pos;
    end
);

# The return value of compute face is complicated since we want to perform 
# some checks after the computation but before we save the data.
# 
# It returns a list with two components:
# 1. A list of vertices around the face, stored either as [v, pos] or [v, coord]
# 2. A list of edges around the face (correctly oriented), stored as
#       [e, vertexPair], where vertexPair consists of two vertex-numbers
#       The initial edge is not part of this list.
BindGlobal( "__SIMPLICIAL_PrintRecordComputeFace",
    function(printRecord, surface, face, edge, drawIndex)
        local givenEdge, givenPRVertexFirst, givenPRVertexSecond, 
            returnedVertices, returnedEdges, lastVertex, lastVertexCoord, 
            currentVertex, currentVertexCoord, lastEdge, vector, nextEdge,
            nextVertex, newVector, angle, nextVertexCoords, pos, i, 
            compareCoords, givenSpecEdge;

        givenEdge := edge;
        # Pick the first edge with the correct drawIndex
        givenSpecEdge := Filtered( printRecord.edgeEndpoints[edge], x -> x[3] = drawIndex )[1];
        givenPRVertexFirst := givenSpecEdge[1];
        givenPRVertexSecond := givenSpecEdge[2];

        returnedVertices := [ givenPRVertexSecond ];
        returnedEdges := [];

        lastVertex := givenPRVertexFirst[1];
        lastVertexCoord := printRecord!.vertexCoordinates[lastVertex][givenPRVertexFirst[2]]{[1,2]};
        currentVertex := givenPRVertexSecond[1];
        currentVertexCoord := printRecord!.vertexCoordinates[currentVertex][givenPRVertexSecond[2]]{[1,2]};
        lastEdge := givenEdge;

        while Length(returnedVertices) < Length(VerticesOfFaces(surface)[face]) do
            vector := lastVertexCoord - currentVertexCoord;

            nextEdge := OtherEdgeOfVertexInFace( surface, currentVertex, lastEdge, face );
            nextVertex := OtherVertexOfEdge( surface, currentVertex, nextEdge );

            # rescale the vector
            vector := vector * Float( printRecord!.edgeLengths[nextEdge] / printRecord!.edgeLengths[lastEdge] );

            # rotate the vector
            angle := printRecord!.angles[face][currentVertex];
            newVector := [ angle[2]*vector[1]+angle[1]*vector[2], -angle[1]*vector[1]+angle[2]*vector[2] ];

            nextVertexCoords := currentVertexCoord + newVector;

            # Check if this vertex coordinates already appear somewhere
            pos := __SIMPLICIAL_PrintRecordFindVertex( printRecord, [nextVertex, nextVertexCoords], drawIndex );
            if pos = 0 then
                Add( returnedVertices, [nextVertex, nextVertexCoords] );
            else
                Add( returnedVertices, [nextVertex, pos] );
            fi;
            Add( returnedEdges, [nextEdge, [nextVertex, currentVertex]]  );

            lastVertex := currentVertex;
            lastVertexCoord := currentVertexCoord;
            currentVertex := nextVertex;
            currentVertexCoord := nextVertexCoords;
            lastEdge := nextEdge;
        od;

        # Check if the face was closed
        lastVertex := returnedVertices[ Length(returnedVertices) ];
        if lastVertex <> givenPRVertexFirst then
            Error("Face does not close.");
        fi;

        return [returnedVertices, returnedEdges];
    end
);
BindGlobal( "__SIMPLICIAL_PrintRecordComputeFirstFace",
    function(printRecord, surface, face, drawIndex)
        local edges, len, verts, res, v1, v2;

        edges := EdgesOfFaces(surface)[face];
        len := printRecord!.edgeLengths[edges[1]];
        verts := VerticesOfEdges(surface)[edges[1]];

        # Save those coordinates
        Add( printRecord!.vertexCoordinates[verts[1]], [0.,0.,drawIndex] );
        Add( printRecord!.vertexCoordinates[verts[2]], [Float(len),0.,drawIndex] );
        v1 := [ verts[1], Length(printRecord.vertexCoordinates[verts[1]]) ];
        v2 := [ verts[2], Length(printRecord.vertexCoordinates[verts[2]]) ];
        Add( printRecord!.edgeEndpoints[edges[1]], [ v1, v2, drawIndex ] );

        res := __SIMPLICIAL_PrintRecordComputeFace( printRecord, surface, face, edges[1], drawIndex );
        printRecord!.edgeEndpoints[edges[1]][Length(printRecord.edgeEndpoints[edges[1]])] := [ v2, v1, drawIndex ];
        return res;
    end
);

BindGlobal( "__SIMPLICIAL_IsFloatZero",
    function( fl, accuracy )
        if AbsoluteValue(fl) < accuracy then
            return 0.;
        else
            return fl;
        fi;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordAddFace",
    function( printRecord, surface, returnedVertices, returnedEdges, face, drawIndex )
        local vertexPositions, prVertex, pos, prEdge, vertices, i, 
            draw, specificVerts, generalVerts, first, second;

        # We store the position of the vertex coordinates
        vertexPositions := [];
        for prVertex in returnedVertices do
            if IsPosInt( prVertex[2] ) then
                vertexPositions[prVertex[1]] := prVertex[2];
            else
                # Try to find this vertex
                pos := __SIMPLICIAL_PrintRecordFindVertex( printRecord, prVertex, drawIndex );
                if pos = 0 then
                    # It is new
                    first := __SIMPLICIAL_IsFloatZero(prVertex[2][1], printRecord.floatAccuracy);
                    second := __SIMPLICIAL_IsFloatZero(prVertex[2][2], printRecord.floatAccuracy);

                    Add( printRecord!.vertexCoordinates[prVertex[1]], [first, second, drawIndex] );
                    pos := Length( printRecord!.vertexCoordinates[prVertex[1]] );
                fi;
                vertexPositions[prVertex[1]] := pos;
            fi;
        od;

        # Add the edges
        for prEdge in returnedEdges do
            vertices := List( prEdge[2], v -> [v, vertexPositions[v]] );
            # Check if the (drawn) edge already exists
            pos := 0;
            draw := true;
            for i in [1..Length(printRecord!.edgeEndpoints[prEdge[1]])] do
                specificVerts := Set( printRecord!.edgeEndpoints[prEdge[1]][i]{[1,2]} );
                generalVerts := List( specificVerts, m -> m[1] );
                if generalVerts = Set( prEdge[2] ) then
                    # This edge has been added before
                    pos := i;
                    # Check if it has been drawn before
                    if specificVerts = Set(vertices) then
                        draw := false;
                    fi;
                    break;
                fi;
            od;
            if draw then
                Add( printRecord!.edgeEndpoints[prEdge[1]], [vertices[1],vertices[2],drawIndex] );
            fi;
        od;


        # Add the face
        printRecord!.faceVertices[face][drawIndex] := List( returnedVertices, v -> [ v[1], vertexPositions[v[1]] ] );
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordNextEdge",
    function( printRecord, rejected )
        local diff;
        #TODO implement more involved methods
        # Naive method that returns the minimum open edge
        diff := Difference( printRecord!.openEdges, rejected );
        if Length(diff) = 0 then
            return fail;
        else
            return diff[1];
        fi;
    end
);
BindGlobal( "__SIMPLICIAL_PrintRecordNextEdgeByDrawOrder",
    function( printRecord, rejected )
        local currentCompNr, order, i, tryEdge;

        # The number of starting faces corresponds to the number of the current component
        currentCompNr := Length( printRecord!.startingFaces );

        if IsBound( printRecord!.givenEdgeDrawOrder[currentCompNr] ) then
            order := printRecord!.givenEdgeDrawOrder[currentCompNr];
            for i in [1..Length(order)] do
                tryEdge := order[i];
                if IsPosInt(tryEdge) and tryEdge in printRecord!.openEdges and not tryEdge in rejected then
                    return order[i];
                fi;
            od;
        fi;
        return fail;
    end
);


# We use the answer of
# https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
# to compute the intersection of two line segments
BindGlobal( "__SIMPLICIAL_IntersectingLineSegments",
    function( edgeCoords1, edgeCoords2, eps )
        local Cross, vtx1, vtx2, det, diff, factor1, factor2, min, max;

        Cross := function( v, w )
            return v[1]*w[2] - v[2]*w[1];
        end;

        # Rewrite the lines into p + t * v
        vtx1 := edgeCoords1[2] - edgeCoords1[1];
        vtx2 := edgeCoords2[2] - edgeCoords2[1];

        # Check first if the lines are parallel
        det := Cross( vtx1, vtx2 );
        diff := edgeCoords2[1] - edgeCoords1[1];
        if __SIMPLICIAL_EqualFloats(det, 0., eps) then
            # parallel case:
            # We have to check if the lines coincide
            # For that we check if the vector between the two base
            # points is parallel to the line directions
            if not __SIMPLICIAL_EqualFloats( Cross( vtx1, diff ), Float(0), eps) then
                return false;
            fi;
            
            # Now we know that the associated lines coincide
            # Determine factor1 such that
            # p_2 = p_1 + factor1 * vtx_1
            # and factor2 such that
            # p_2 + vtx_2 = p_1 + factor * vtx_1
            if not __SIMPLICIAL_EqualFloats( vtx1[1], Float(0) , eps) then
                factor1 := diff[1]/vtx1[1];
                factor2 := factor1 + vtx2[1]/vtx1[1];
            else
                factor1 := diff[2]/vtx1[2];
                factor2 := factor1 + vtx2[2]/vtx1[2];
            fi;
            
            # The segments intersect if the segment between the factors
            # intersects (0,1)
            min := Minimum( factor1, factor2 );
            max := Maximum( factor1, factor2 );
            if min <= Float(0) and max > Float(0) then
                return true;
            elif min > Float(1) and max < Float(1) then
                return true;
            else
                return false;
            fi;
        else
            # the associated lines intersect
            factor1 := Cross( diff, vtx2 ) / det;
            factor2 := Cross( diff, vtx1 ) / det;
            if factor1 < Float(0) or factor1 > Float(1) then
                return false;
            elif factor2 < Float(0) or factor2 > Float(1) then
                return false;
            elif ( __SIMPLICIAL_EqualFloats(factor1,0., eps) or __SIMPLICIAL_EqualFloats(factor1,1., eps) )
                and ( __SIMPLICIAL_EqualFloats(factor2,0., eps) or __SIMPLICIAL_EqualFloats(factor2,1., eps) ) then
                return false;
            else
                return true;
            fi;
        fi;
    end
);


BindGlobal("__SIMPLICIAL_PrintRecordNoIntersection",
    function( printRecord, surface, vertexData, edgeData, drawIndex, testResults )
        local cleanEdges, edge, edgePos, edgeEndpoints, vertex1, vertex2,
            vertex1Coord, vertex2Coord, newEdge, newVertex1Name, newVertex2Name,
            correspondenceMatrix, newVertex1Coord, newVertex2Coord, vertexInfo,
            pair;

        # If there were intersections before, there are so now
        if testResults <> [] and testResults[1] = false then
            return testResults;
        fi;

        # If intersections should be ignored, return true
        if not printRecord!.avoidIntersections then
            return [true, []];
        fi;

        # Convert the vertexData into a list v -> second entry
        vertexInfo := [];
        for pair in vertexData do
            vertexInfo[pair[1]] := pair[2];
        od;

        # We only have to check if there are new intersections
        # For that reason we store the checked edges in testResults
        if testResults = [] then
            cleanEdges := [];
        else
            cleanEdges := testResults[2];
        fi;
        for edge in Edges(surface) do
            if Length(printRecord.edgeEndpoints[edge]) = 0 then
                continue;
            fi;
            for edgePos in [1..Length(printRecord!.edgeEndpoints[edge])] do
                if printRecord.edgeEndpoints[edge][edgePos][3] <> drawIndex then
                    continue;
                fi;
                if [edge, edgePos] in cleanEdges then
                    continue;
                fi;

                # We have not checked this edge before
                edgeEndpoints := printRecord!.edgeEndpoints[edge][edgePos];
                vertex1 := edgeEndpoints[1];
                vertex2 := edgeEndpoints[2];
                vertex1Coord := printRecord!.vertexCoordinates[ vertex1[1] ][ vertex1[2] ];
                vertex2Coord := printRecord!.vertexCoordinates[ vertex2[1] ][ vertex2[2] ];

                for newEdge in edgeData do
                    newVertex1Name := newEdge[2][1];
                    newVertex2Name := newEdge[2][2];

                    # if vertex(i) = newVertex(j) then position [i][j] = 1
                    correspondenceMatrix := [ [0,0], [0,0] ];

                    #TODO get rid of code duplication
                    if IsPosInt(vertexInfo[newVertex1Name]) then
                        newVertex1Coord := printRecord!.vertexCoordinates[newVertex1Name][vertexInfo[newVertex1Name]];
                        # compare directly with original vertices
                        if vertex1{[1,2]} = [newVertex1Name, vertexInfo[newVertex1Name]] then #TODO can it happen that the new vertex v is identified with the old vertex w??
                            correspondenceMatrix[1][1] := 1;
                        elif vertex2{[1,2]} = [newVertex1Name, vertexInfo[newVertex1Name]] then
                            correspondenceMatrix[2][1] := 1;
                        fi;
                    else
                        # compare coordinates
                        newVertex1Coord := vertexInfo[newVertex1Name];
                        if __SIMPLICIAL_EqualPoints( vertex1Coord, vertexInfo[newVertex1Name], printRecord!.floatAccuracy ) then
                            if newVertex1Name <> vertex1[1] then
                                # Conflict with two different vertices at the same position
                                return [false, cleanEdges];
                            else
                                correspondenceMatrix[1][1] := 1;
                            fi;
                        elif __SIMPLICIAL_EqualPoints( vertex2Coord, vertexInfo[newVertex1Name], printRecord!.floatAccuracy) then
                            if newVertex1Name <> vertex2[1] then
                                return [false, cleanEdges];
                            else
                                correspondenceMatrix[2][1] := 1;
                            fi;
                        fi;
                    fi;

                    if IsPosInt(vertexInfo[newVertex2Name]) then
                        newVertex2Coord := printRecord!.vertexCoordinates[newVertex2Name][vertexInfo[newVertex2Name]];
                        # compare directly with original vertices
                        if vertex1{[1,2]} = [newVertex2Name, vertexInfo[newVertex2Name]] then 
                            correspondenceMatrix[1][2] := 1;
                        elif vertex2{[1,2]} = [newVertex2Name, vertexInfo[newVertex2Name]] then
                            correspondenceMatrix[2][2] := 1;
                        fi;
                    else
                        newVertex2Coord := vertexInfo[newVertex2Name];
                        # compare coordinates
                        if __SIMPLICIAL_EqualPoints( vertex1Coord, vertexInfo[newVertex2Name], printRecord!.floatAccuracy ) then
                            if newVertex2Name <> vertex1[1] then
                                # Conflict with two different vertices at the same position
                                return [false, cleanEdges];
                            else
                                correspondenceMatrix[1][2] := 1;
                            fi;
                        elif __SIMPLICIAL_EqualPoints( vertex2Coord, vertexInfo[newVertex2Name], printRecord!.floatAccuracy) then
                            if newVertex2Name <> vertex2[1] then
                                return [false, cleanEdges];
                            else
                                correspondenceMatrix[2][2] := 1;
                            fi;
                        fi;
                    fi;

                    # We now have constructed a correspondence matrix such that 
                    # in every row and every column there is at most one 1.
                    if Sum(Sum(correspondenceMatrix)) = 2 then
                        # We only have to compare the edge numbers
                        if edge <> newEdge[1] then
                            return [false, cleanEdges];
                        fi;
                    else
                        # Compute the intersection normally
                        if __SIMPLICIAL_IntersectingLineSegments( [vertex1Coord, vertex2Coord], [newVertex1Coord, newVertex2Coord], printRecord.floatAccuracy ) then
                            return [false, cleanEdges];
                        fi;
                    fi;
 
                od;
            od;
            Add( cleanEdges, [edge, edgePos] );
        od;

        return [true, Set(cleanEdges)];
    end
);


BindGlobal("__SIMPLICIAL_PrintRecordGeneralHeader",
    function(printRecord)
        local res;

        res := Concatenation(
            "\\documentclass{", printRecord.latexDocumentclass, "}\n\n" );

        if printRecord.latexDocumentclass <> "standalone" then
            res := Concatenation( res,
            "\\usepackage[inner=0.5cm,outer=0.5cm,top=1cm,bottom=0.5cm]{geometry}\n\n");
        fi;

        res := Concatenation( res, "\\pagestyle{empty}\n");

        return res;
    end
);

BindGlobal( "__SIMPLICIAL_ReadTemplateFromFile",
    function(relPath)
        local path, input, content;

        path := Filename(DirectoriesPackageLibrary("SimplicialSurfaces", "doc"), relPath);
        if path <> fail then
            input := InputTextFile( path );
            content := ReadAll(input);
            CloseStream(input);
            return content;
        fi;

        Error("Internal Error: ", relPath, " not found in GAP root directories.");
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordTikzHeader",
    function(printRecord)
        return __SIMPLICIAL_ReadTemplateFromFile("TikZHeader.tex");
    end
);


BindGlobal( "__SIMPLICIAL_PrintRecordDrawVertex",
    function( printRecord, surface, vertex, vertexTikzCoord, vertexCoord )
        local res;

        res := "\\vertexLabelR";
        if IsBound( printRecord!.vertexColours[vertex] ) then
            res := Concatenation(res, "[", printRecord!.vertexColours[vertex],"]");
        fi;

        res := Concatenation( res, "{", vertexTikzCoord, "}{left}{$");
        if IsBound(printRecord!.vertexLabels[vertex]) then
            Append(res, printRecord!.vertexLabels[vertex]);
        else
            #Append( res, "v_{" );
            Append( res, String(vertex) );
            #Append( res, "}" );
        fi;
        Append(res,"$}\n" );

        return res;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordDrawEdge",
    function( printRecord, surface, edge, vertexTikzCoord, vertexCoord )
        local res;

        res := "\\draw[edge";
        if IsBound( printRecord!.edgeColours[edge] ) then
            res := Concatenation(res, "=", printRecord!.edgeColours[edge]);
        fi;

        res := Concatenation(res, "] (", vertexTikzCoord[1], ") -- node[edgeLabel] {$");
        if IsBound(printRecord!.edgeLabels[edge]) then
            Append(res, printRecord!.edgeLabels[edge]);
        else
            #Append( res, "e_{" );
            Append( res, String(edge) );
            #Append( res, "}" );
        fi;
        res := Concatenation(res, "$} (", vertexTikzCoord[2], ");\n" );

        return res;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordDrawFace",
    function( printRecord, surface, face, vertexTikzCoord, vertexCoord )
        local res, i, coord;

        res := "";
        Append(res, "\\fill[");
    #TODO this does not make sense without mirror/rotation edges -> revisit this problem then
        # Determine if the swap colour is used
#        if IsOrientable(surface) and printRecord!.faceVertices[face][2][1]^OrientationByVerticesAsPerm(surface)[face] = printRecord!.faceVertices[face][1][1] then
#            Append(res, "faceSwap");
#        else
            Append(res, "face");
#        fi;

        if IsBound( printRecord!.faceColours[face] ) then
            Append( res, "=" );
            Append( res, printRecord!.faceColours[face] );
        fi;
        Append(res, "] ");

        for coord in vertexTikzCoord do
            Append(res, " (");
            Append(res, coord);
            Append(res, ") --");
        od;
        Append(res, " cycle;\n");
        Append(res, "\\node[faceLabel] at (barycentric cs:");
        for i in [1..Length(vertexTikzCoord)] do
            if i > 1 then
                Append(res, ",");
            fi;
            Append(res, vertexTikzCoord[i]);
            Append(res, "=1");
        od;
        Append(res, ") {$");
        if IsBound( printRecord!.faceLabels[face] ) then
            Append(res, printRecord!.faceLabels[face]);
        else
            #Append(res, "f_{");
            Append(res, String(face));
            #Append(res, "}");
        fi;
        Append(res, "$};\n" );

        return res;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordTikzOptions",
    function(printRecord, surface)
        local res;

        res := "";
        # Add the vertex style
        Append( res, "vertexBall" );
        if printRecord!.vertexLabelsActive = false then
            Append( res, "=nolabels" );
        fi;
        Append( res, ", " );

        # Add the edge style
        Append( res, "edgeDouble" );
        if printRecord!.edgeLabelsActive = false then
            Append( res, "=nolabels" );
        fi;
        Append( res, ", " );

        # Add the face style
        Append( res, "faceStyle" );
        if printRecord!.faceLabelsActive = false then
            Append( res, "=nolabels" );
        fi;
        Append( res, ", " );

        # Scale the picture
        Append( res, "scale=" );
        Append( res, String(printRecord!.scale) );

        return res;
    end
);


# general method
InstallMethod( DrawSurfaceToTikz, 
    "for a polygonal complex without edge ramifications, a filename and a record",
    [IsPolygonalComplex and IsNotEdgeRamified, IsString, IsRecord],
    function(surface, fileName, printRecord)
        local file, output, f, v, i, positions, comp, 
            allVertexCoords, TikzCoordFromVertexPosition, unplacedFaces,
            strongComponents, start, computedFace, nextFct, checkFct, k,
            nextEdge, firstEdge, rejected, repeatData, tries, proposedEdge,
            adFace, vertexData, edgeData, testResults, e, ends, facePath,
            vertexEdgeData, success, j, vertexCoords, vertexPositions, 
            lastOrder, nextFctIndex, oldFace, pos, strongComp, drawComp,
            drawIndex, ind, drawIndices, strongCompNumber;

        # Do something different for the manual
        if __SIMPLICIAL_MANUAL_MODE then
            printRecord!.onlyTikzpicture := true;
            printRecord!.compileLaTeX := false;
            printRecord!.noOutput := true;
            fileName := Concatenation( "doc/_TIKZ_", fileName );
        fi;

        # Make the file end with .tex
        if not EndsWith( fileName, ".tex" ) then
            fileName := Concatenation( fileName, ".tex" );
        fi;

        # Try to open the given file
        file := Filename( DirectoryCurrent(), fileName ); #TODO allow absolute paths
        output := OutputTextFile( file, false ); # override other files
        if output = fail then
            Error(Concatenation("File ", String(file), " can't be opened.") );
        fi;
        SetPrintFormattingStatus( output, false );


        __SIMPLICIAL_PrintRecordInit(printRecord, surface);
        __SIMPLICIAL_PrintRecordInitializePolygons(printRecord, surface);

        # Start the actual method
        unplacedFaces := Faces(surface);
        strongComponents := [];
        drawIndex := 0;
        while Length(unplacedFaces) > 0 do
            # Find the starting face
            start := __SIMPLICIAL_PrintRecordStartingFace( printRecord, surface, unplacedFaces );
            Add( printRecord!.startingFaces, start );
            Add( printRecord.edgeDrawOrder,  [] );

            comp := [[start]];
            drawIndex := drawIndex + 1;
            drawIndices := [drawIndex];
            #drawIndex := 1;
            computedFace := __SIMPLICIAL_PrintRecordComputeFirstFace( printRecord, surface, start, drawIndex );
            __SIMPLICIAL_PrintRecordAddFace(printRecord, surface, computedFace[1], computedFace[2], start, drawIndex);
            unplacedFaces := Difference( unplacedFaces, [start] );
            printRecord.openEdges := Filtered( EdgesOfFaces(surface)[start], e -> Length( Intersection(unplacedFaces, FacesOfEdges(surface)[e]) ) > 0 );

            nextFct := [ ["__SIMPLICIAL_PrintRecordNextEdgeByDrawOrder", infinity], ["__SIMPLICIAL_PrintRecordNextEdge", infinity] ];
            checkFct := [ "__SIMPLICIAL_PrintRecordNoIntersection" ];
            repeatData := [];
            # This is an infinite loop to extend all edges - bounded from above by the number of edges
            for k in [1..NumberOfEdges(surface)] do
                if Length(printRecord!.openEdges) = 0 then
                    break;
                fi;
                # Find the next edge
                nextEdge := fail;
                firstEdge := fail; # Fallback if all edges fail some test
                rejected := [];
                nextFctIndex := 1;
                tries := 1;
                for i in [1..Length(printRecord!.openEdges)+Length(nextFct)] do
                    if nextFctIndex > Length(nextFct) then
                        break;
                    fi;
                    if tries > nextFct[nextFctIndex][2] then
                        nextFctIndex := nextFctIndex + 1;
                        tries := 1;
                        continue;
                    fi;
                    proposedEdge := ValueGlobal( nextFct[nextFctIndex][1] )(printRecord, rejected);
                    tries := tries + 1;
                    if proposedEdge = fail then # TODO code duplication with lines above
                        nextFctIndex := nextFctIndex + 1;
                        tries := 1;
                        continue;
                    fi;
                    if firstEdge = fail then
                        firstEdge := proposedEdge;
                    fi;
                    # every edge is used at most once (if there could be ambiguity, the edge has more than 2 incident faces)
                    # for each edge we store
                    # 1) the adjacent face
                    # 2) the computed vertex data
                    # 3) the computed edge data
                    # 4) a list with the results of the checks
                    if IsBound( repeatData[proposedEdge] ) then
                        # Take data from storage
                        adFace := repeatData[proposedEdge][1];
                        vertexData := repeatData[proposedEdge][2];
                        edgeData := repeatData[proposedEdge][3];
                        testResults := repeatData[proposedEdge][4];
                    else
                        adFace := Intersection( FacesOfEdges(surface)[proposedEdge], unplacedFaces )[1];
                        vertexEdgeData := __SIMPLICIAL_PrintRecordComputeFace(printRecord, surface, adFace, proposedEdge, drawIndex);
                        vertexData := vertexEdgeData[1];
                        edgeData := vertexEdgeData[2];
                        testResults := [];
                    fi;

                    # do tests
                    # we rely on the fact that computed faces of a previous 
                    # drawing component will keep being false (otherwise
                    # the tried addition will produce an error).
                    success := true;
                    for j in [1..Length(checkFct)] do
                        if IsBound( testResults[j] ) then
                            # there was a test before
                            testResults[j] := ValueGlobal( checkFct[j] )(printRecord, surface, vertexData, edgeData, drawIndex, testResults[j]);
                        else
                            testResults[j] := ValueGlobal( checkFct[j] )(printRecord, surface, vertexData, edgeData, drawIndex, []);
                        fi;

                        if testResults[j][1] = false then
                            success := false;
                            break;
                        fi;
                    od;
                
                    # Store data since it is either needed to avoid recomputation or to continue
                    repeatData[proposedEdge] := [ adFace, vertexData, edgeData, testResults ];

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
                    proposedEdge := firstEdge;
                    drawIndex := drawIndex + 1;
                    Add(drawIndices, drawIndex);
                    Add( comp, [repeatData[proposedEdge][1]]  );
                    computedFace := __SIMPLICIAL_PrintRecordComputeFirstFace( printRecord, surface, repeatData[proposedEdge][1], drawIndex );
                    __SIMPLICIAL_PrintRecordAddFace(printRecord, surface, computedFace[1], computedFace[2], repeatData[proposedEdge][1], drawIndex);

                    Print("DrawSurfaceToTikz: Could not find intersection-free continuation. Draw face ", repeatData[proposedEdge][1], " via edge ", firstEdge, " instead.\n");
                else
                    __SIMPLICIAL_PrintRecordAddFace( printRecord, surface, repeatData[proposedEdge][2], repeatData[proposedEdge][3], repeatData[proposedEdge][1], drawIndex );
                    # We will be in this case until we can't continue any edge without failing some test.
                    # Therefore this case will always add in the component that was last modified
                    Add( comp[Length(comp)], repeatData[proposedEdge][1] );
                fi;

                # Add the new face and remove initial edge from openEdges
                unplacedFaces := Difference( unplacedFaces, [ repeatData[proposedEdge][1] ]);
                for e in EdgesOfFaces(surface)[repeatData[proposedEdge][1]] do
                    if Length( Intersection(unplacedFaces, FacesOfEdges(surface)[e]) ) = 0 then
                        printRecord.openEdges := Difference( printRecord.openEdges, [e] );
                    else
                        printRecord.openEdges := Union( printRecord.openEdges, [e] );
                    fi;
                od;

                # Modify the edge draw order
                lastOrder := printRecord.edgeDrawOrder[Length(printRecord.edgeDrawOrder)];
                Add(lastOrder, proposedEdge);
            od;
            Add( printRecord.drawComponents, comp );
            Add( printRecord.drawIndices, drawIndices );
        od;

        # Set the strongly connected components (if not already done)
        if not HasStronglyConnectedComponentsAttributeOfComplex( surface ) then
            SetStronglyConnectedComponentsAttributeOfComplex( surface, List( printRecord.drawComponents, c -> SubcomplexByFacesNC(surface, Union(c) ) ));
        fi;

        # Write this data into the file
        if not printRecord!.onlyTikzpicture then
            AppendTo( output, __SIMPLICIAL_PrintRecordGeneralHeader(printRecord) );
            AppendTo( output, __SIMPLICIAL_PrintRecordTikzHeader(printRecord) );
            AppendTo( output, "\n\n\\begin{document}\n\n" );
        
            if IsBound(printRecord!.caption) then
            AppendTo( output,
                "\\subsection*{", printRecord!.caption, "}\n \\bigskip\n");
            fi;
        fi;
        
        TikzCoordFromVertexPosition := function( vertPos )
            return Concatenation( "V", String(vertPos[1]), "_", String(vertPos[2]), "" );
        end;
        allVertexCoords := printRecord!.vertexCoordinates;
        for strongCompNumber in [1..Length(printRecord.drawComponents)] do
            strongComp := printRecord.drawComponents[strongCompNumber];
            for ind in [1..Length(strongComp)] do;
                drawComp := strongComp[ind];
                comp := SubcomplexByFacesNC(surface,drawComp);
                drawIndex := printRecord.drawIndices[strongCompNumber][ind];

                # Start the picture
                AppendTo( output, "\n\n\\begin{tikzpicture}[", __SIMPLICIAL_PrintRecordTikzOptions(printRecord, comp), "]\n\n" );
                # Activate alternative face colours
    #            if printRecord!.faceSwapColoursActive then
    #                AppendTo( output, "\\def\\swapColors{1}\n\n" );
    #            fi;

                # Define coordinates of vertices
                AppendTo( output, "% Define the coordinates of the vertices\n" );
                for v in VerticesAttributeOfComplex(comp) do
                    for i in [1..Length(allVertexCoords[v])] do
                        if allVertexCoords[v][i][3] = drawIndex then
                            AppendTo( output, "\\coordinate (", TikzCoordFromVertexPosition([v,i]), ") at (", allVertexCoords[v][i][1], ", ", allVertexCoords[v][i][2], ");\n" );
                        fi;
                    od;
                od;
                AppendTo(output, "\n\n");

                # Draw faces
                AppendTo( output, "% Fill in the faces\n" );
                for f in Faces(comp) do
                    vertexPositions := printRecord!.faceVertices[f][drawIndex];
                    AppendTo( output, __SIMPLICIAL_PrintRecordDrawFace(printRecord, surface, f, 
                        List(vertexPositions, TikzCoordFromVertexPosition), List(vertexPositions, p -> allVertexCoords[p[1]][p[2]])) );
                od;
                AppendTo( output, "\n\n" );

                # Draw edges
                AppendTo( output, "% Draw the edges\n" );
                for e in Edges(comp) do
                    ends := printRecord!.edgeEndpoints[e];
                    for i in [1..Length(ends)] do
                        if ends[i][3] = drawIndex then
                            AppendTo( output, __SIMPLICIAL_PrintRecordDrawEdge( printRecord, surface, e,
                                List( ends[i]{[1,2]}, TikzCoordFromVertexPosition ),
                                List( ends[i]{[1,2]}, p -> allVertexCoords[p[1]][p[2]] ) ) );
                        fi;
                    od;
                od;
                AppendTo( output, "\n\n" );
                
                # Draw vertices
                AppendTo( output, "% Draw the vertices\n" );
                for v in VerticesAttributeOfComplex(comp) do
                    positions := allVertexCoords[v];
                    for i in [1..Length(positions)] do
                        if allVertexCoords[v][i][3] = drawIndex then
                            AppendTo( output, __SIMPLICIAL_PrintRecordDrawVertex( printRecord, surface, v, TikzCoordFromVertexPosition([v,i]), allVertexCoords[v][i] ));
                        fi;
                    od;
                od;
                
                # End the picture
                AppendTo( output, "\n\\end{tikzpicture}" );
            od;
        od;
        if not printRecord!.onlyTikzpicture then
            AppendTo( output, "\n\\end{document}\n");
        fi;
        CloseStream(output);
        if not printRecord!.noOutput then
            Print( "Picture written in TikZ." );
        fi;


        if printRecord.compileLaTeX then
            if not printRecord!.noOutput then
                Print( "Start LaTeX-compilation (type 'x' and press ENTER to abort).\n" );
            fi;

            # Run pdfLaTeX on the file (without visible output)
            Exec( "pdflatex ", file, " > /dev/null" );
            if not printRecord!.noOutput then
                Print( "Picture rendered (with pdflatex).\n");
            fi;
        fi;


        # Clean up the record
        __SIMPLICIAL_PrintRecordCleanup(printRecord);

        return printRecord;
    end
);
RedispatchOnCondition( DrawSurfaceToTikz, true, [IsTwistedPolygonalComplex,IsString,IsRecord], [IsPolygonalComplex and IsNotEdgeRamified], 0  );

InstallOtherMethod( DrawSurfaceToTikz, 
    "for a polygonal complex without edge ramifications and a file name",
    [IsPolygonalComplex and IsNotEdgeRamified, IsString],
    function(surface, file)
        return DrawSurfaceToTikz(surface, file, rec());
    end
);
RedispatchOnCondition( DrawSurfaceToTikz, true, [IsTwistedPolygonalComplex,IsString], [IsPolygonalComplex and IsNotEdgeRamified], 0  );

############################################################

BindGlobal( "__SIMPLICIAL_PrintRecordDrawFaceFG",
    function( printRecord, surface, face, faceTikzCoord)
        local res;

        res := "\\vertexLabelR";
        if IsBound( printRecord!.faceColours[face] ) then
            res := Concatenation(res, "[", printRecord!.faceColours[face],"]");
        fi;

        res := Concatenation( res, "{", faceTikzCoord, "}{left}{$");
        if IsBound(printRecord!.faceLabels[face]) then
            Append(res, printRecord!.faceLabels[face]);
        else
            Append( res, String(face) );
        fi;
        Append(res,"$}\n" );

        return res;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordDrawVertexFG",
    function( printRecord, surface, vertex,vertexCoord )
        local res, i, coord;

        res := "";
        Append(res, "\\node[faceLabel] at (");
	Append(res,String(vertexCoord[1]));
	Append(res,",");
	Append(res,String(vertexCoord[2]));
        Append(res, ") {$");
        if IsBound( printRecord!.vertexLabels[vertex] ) then
            Append(res, printRecord!.vertexLabels[vertex]);
        else
            Append(res, String(vertex));
        fi;
        Append(res, "$};\n" );

        return res;
    end
);

InstallMethod( SetFaceCoordinates2D,
    "for a simplicial surface, a list of face coordinates and a record",
    [IsSimplicialSurface, IsList, IsRecord],
    function(surface, faceCoordinates, printRecord)
	local i,temp;
	temp:=Filtered([1..Length(faceCoordinates)], i-> IsBound(faceCoordinates[i]));
	if Filtered(temp,i->Length(faceCoordinates[i])=2)<>Faces(surface) then 
	    Error( " invalid coordinate format " );
        fi;
	return SetFaceCoordinates2DNC(surface,faceCoordinates,printRecord);
    end
);

InstallOtherMethod( SetFaceCoordinates2D,
    "for a simplicial surface and a list of coordinates",
    [IsSimplicialSurface, IsList],
    function(surface, faceCoordinates)
        return SetFaceCoordinates2D(surface, faceCoordinates, rec());
    end
);

InstallMethod( SetFaceCoordinates2DNC,
    "for a simplicial surface, a list of coordinates and a record",
    [IsSimplicialSurface, IsList, IsRecord],
    function(surface, faceCoordinates, printRecord)
        printRecord.faceCoordinates2D := faceCoordinates;
        return printRecord;
    end
);

InstallOtherMethod( SetFaceCoordinates2DNC,
    "for a simplicial surface, a list of coordinates and a record",
    [IsSimplicialSurface, IsList],
    function(surface, faceCoordinates)
        return rec(faceCoordinates2D := faceCoordinates);
    end
);

BindGlobal( "__SIMPLICIAL_IsCoordinates2D",
    function(surface, coordinates)
        local coord;
        if not IsList(coordinates) then
            return false;
        fi;
        if Filtered([1..Length(coordinates)],i->IsBound(coordinates[i])) <> Faces(surface) then
            return false;
	fi;
        # Check whether all coordinates are 2D-coordinates
        for coord in coordinates do
            if not IsDenseList(coord) then
                return false;
            fi;
            if Length(coord) <> 2 then
                return false;
            fi;
        od;
        return true;
    end
);


#######################################

    ## this help function takes a positive integer as input and returns a list of 2D-
    ## coordinates, situated on a square with the vertices [0,0],[n,0],[n,n],[0,n]
    ## so that each side has exactly n/4 or n/4+1 vertices
BindGlobal( "__SIMPLICIAL_StartPositions",
    function(n)
	local k,startPositions;
	startPositions:=[];
	if n=1 then 
	    return [[1.,1.]];
	elif n=2 then
	    return [[0.,2.],[2.,2.]];
	elif n=3 then 
	    return [[0.,3.],[3.,3.],[3.,0.]];	
	elif n mod 4=0 then
	    k:=n/4;
	    Append(startPositions,List([0..k-1],i->[i*4,n]));
	    Append(startPositions,List([0..k-1],i->[n,n-i*4]));
	    Append(startPositions,List([0..k-1],i->[n-i*4,0]));
	    Append(startPositions,List([0..k-1],i->[0,i*4]));
	elif n mod 4=1 then
	    k:=(n-1)/4;
	    Append(startPositions,List([0..k],i->[i*(n-1)/(k+1),(n-1)]));
	    Append(startPositions,List([0..k-1],i->[(n-1),(n-1)-i*4]));
	    Append(startPositions,List([0..k-1],i->[(n-1)-i*4,0]));
	    Append(startPositions,List([0..k-1],i->[0,i*4]));
	elif n mod 4=2 then
	    k:=(n-2)/4;
	    Append(startPositions,List([0..k],i->[i*(n-2)/(k+1),(n-2)]));
	    Append(startPositions,List([0..k-1],i->[(n-2),(n-2)-i*4]));
	    Append(startPositions,List([0..k],i->[(n-2)-i*(n-2)/(k+1),0]));
	    Append(startPositions,List([0..k-1],i->[0,i*4]));
	elif n mod 4=3 then	 
	    k:=(n-3)/4;
	    Append(startPositions,List([0..k],i->[i*(n-3)/(k+1),(n-3)]));
	    Append(startPositions,List([0..k],i->[(n-3),(n-3)-i*(k+1)]));
	    Append(startPositions,List([0..k],i->[(n-3)-i*(n-3)/(k+1),0]));
	    Append(startPositions,List([0..k-1],i->[0,i*(n-3)/4]));
	fi;
	return startPositions*1.0;
    end
);

    # this function returns the face sequence of faces contained in the umbrella
    # and not contained in visitedFaces
BindGlobal( "__SIMPLICIAL_OrderFaces",
    function(face1,face2,currUmb,visitedFaces)
	local f,cyc,orderedFaces;
	orderedFaces:=[];
	cyc:=CycleFromList(currUmb);
	if face1^cyc in visitedFaces then
	    cyc:=cyc^(-1);	
	fi;
	f:=face1^cyc; 
	while f<>face2 do 
	    if not f in visitedFaces then 
	        Add(orderedFaces,f);
	        f:=f^(cyc);
	    else 
	        f:=f^(cyc);
	    fi;
	od;
	return orderedFaces;
    end
);

    ## given the face positions of some faces and the set of Umbrellas of a 
    ## simplicial surface this function returns the list of faces that are incident to 
    ## exactly two of the faces with a given coordinate in facePositions.
    ## The returned list activeFaces is ordered in the sense that there exists 
    ## a umbrella containing the faces activefaces[i], activeFaces[i+1] and 
    ## faces whose coordinate has not been calculated yet
BindGlobal( "__SIMPLICIAL_ActiveFaces",
    function(facePositions,Umbrellas)
	local g,activeFaces,minFace,maxFace,minX,maxX,minY,maxY,min,max,i,
	xCoordinates,yCoordinates,posMinY,posMinX,posMaxY,posMaxX;
	activeFaces:=[];
	xCoordinates:=List(facePositions,g->g[1]);
	minX:=Minimum(xCoordinates);	
	maxX:=Maximum(xCoordinates);
	yCoordinates:=List(facePositions,g->g[2]);
	minY:=Minimum(yCoordinates);	
	maxY:=Maximum(yCoordinates);

	posMinX:=Filtered(facePositions,g->g[1]=minX);
	while posMinX <> [] do
		min:=Minimum(List(posMinX,g->g[2]));
		minFace:=Position(facePositions,Filtered(posMinX,g->g[2]=min)[1]);
		if Length(Filtered(Umbrellas,g->minFace in g))=2 then
			Add(activeFaces,minFace);
		fi;
		posMinX:=Filtered(posMinX,g->g[2]<>min);
	od;

	posMaxY:=Filtered(facePositions,g->g[2]=maxY and g[1]<>minX);
	while posMaxY <> [] do
		min:=Minimum(List(posMaxY,g->g[1]));
		minFace:=Position(facePositions,Filtered(posMaxY,g->g[1]=min)[1]);
		if Length(Filtered(Umbrellas,g->minFace in g))=2 then
			Add(activeFaces,minFace);
		fi;
		posMaxY:=Filtered(posMaxY,g->g[1]<>min);
	od;

	posMaxX:=Filtered(facePositions,g->g[1]=maxX and g[2]<>maxY);
	while posMaxX <> [] do
		max:=Maximum(List(posMaxX,g->g[2]));
		maxFace:=Position(facePositions,Filtered(posMaxX,g->g[2]=max)[1]);
		if Length(Filtered(Umbrellas,g->maxFace in g))=2 then
			Add(activeFaces,maxFace);
		fi;
		posMaxX:=Filtered(posMaxX,g->g[2]<>max);
	od;

	posMinY:=Filtered(facePositions,g->g[2]=minY and not(g[1] in [minX,maxX]) );
	while posMinY <> [] do
		max:=Maximum(List(posMinY,g->g[1]));
		maxFace:=Position(facePositions,Filtered(posMinY,g->g[1]=max)[1]);
		if Length(Filtered(Umbrellas,g->maxFace in g))=2 then
			Add(activeFaces,maxFace);
		fi;
		posMinY:=Filtered(posMinY,g->g[1]<>max);
	od;
	return activeFaces;
    end
);

    ## this functions works as a heuristic to place new face coordinates 
    ## the list activeFaces is a list of faces that are incident to a face 
    ## whose coordinate hasn't been calculated yet.
    ## so there exist a umbrella containing activeFaces[i],activeFaces[i+1] and a
    ## face with no face coordinate. The faces in this umbrella which don't have a
    ## face coordinate are given in nextFaces[i]
    ## This method tries to apply coordinates to the faces in nextFaces[i] so the 
    ## the embedding is still planar and vertices of the surface can be
    ## identified as faces of the resulting face graph
BindGlobal( "__SIMPLICIAL_NewFaceCoordinates",
    function(activeFaces,nextFaces,Umbrellas,facePositions)
	local g,l,numNewCoor,maxX,maxY,minX,minY,newPositions,face1,face2,t,
	nextFacesSubDiv,i,xCoordinates,yCoordinates,pos;
	xCoordinates:=List(facePositions,pos->pos[1]);
	minX:=Minimum(xCoordinates);
	maxX:=Maximum(xCoordinates);
	yCoordinates:=List(facePositions,pos->pos[2]);
	minY:=Minimum(yCoordinates);
	maxY:=Maximum(yCoordinates);
	numNewCoor:=[0,0,0,0];
	nextFacesSubDiv:=[];
	## the faces in activeFaces are situated on a rectangle. To construct an inner
	## rectangle of the tutte embedding we have to assign the faces of nextFaces
	## to the four sides of the inner rectangle
	for i in [1..Length(activeFaces)-1] do
	    l:=Length(nextFaces[i]); 
	    face1:=facePositions[activeFaces[i]];
	    face2:=facePositions[activeFaces[i+1]];
	    if face1[1]=minX and face2[1]=minX then
		if numNewCoor[1]=0 then 
		    numNewCoor[1]:=l;
		    nextFacesSubDiv[1]:=nextFaces[i];
	        else
		    numNewCoor[1]:=numNewCoor[1]+l-1;
		    RemoveElmList(nextFacesSubDiv[1],Length(nextFacesSubDiv[1]));
		    Append(nextFacesSubDiv[1],nextFaces[i]);
	        fi;		
	    elif face1[2]=maxY and face2[2]=maxY then
		if numNewCoor[2]=0 then 
		    numNewCoor[2]:=l;
		    nextFacesSubDiv[2]:=nextFaces[i];
	        else
		    numNewCoor[2]:=numNewCoor[2]+l-1;
		    RemoveElmList(nextFacesSubDiv[2],Length(nextFacesSubDiv[2]));
		    Append(nextFacesSubDiv[2],nextFaces[i]);
		fi;	
	    elif face1[1]=maxX and face2[1]=maxX then
		if numNewCoor[3]=0 then 
		    numNewCoor[3]:=l;
		    nextFacesSubDiv[3]:=nextFaces[i];
		else
		    numNewCoor[3]:=numNewCoor[3]+l-1;
		    RemoveElmList(nextFacesSubDiv[3],Length(nextFacesSubDiv[3]));
		    Append(nextFacesSubDiv[3],nextFaces[i]);
		fi;
	    elif face1[2]=minY and face2[2]=minY then
		if numNewCoor[4]=0 then 
		    numNewCoor[4]:=l;
		    nextFacesSubDiv[4]:=nextFaces[i];
		else
		    numNewCoor[4]:=numNewCoor[4]+l-1;
		    RemoveElmList(nextFacesSubDiv[4],Length(nextFacesSubDiv[4]));
		    Append(nextFacesSubDiv[4],nextFaces[i]);
		fi;		
	    elif face1[1]=minX and face2[2]=maxY and not(face2[1]=minX) then
		if l=1 then 
		    if numNewCoor[1]=0 then 
			numNewCoor[1]:=l;
			nextFacesSubDiv[1]:=nextFaces[i];
		    fi;
		else	
		    if numNewCoor[1]=0 then 
			numNewCoor[1]:=l;
			nextFacesSubDiv[1]:=nextFaces[i];
		    else
			numNewCoor[1]:=numNewCoor[1]+Length(nextFaces[i])-1;
			RemoveElmList(nextFacesSubDiv[1],Length(nextFacesSubDiv[1]));
			Append(nextFacesSubDiv[1],nextFaces[i]);
		    fi;				
		fi;
	    elif face1[1]=minX and face2[1]=maxX and not(face2[2]=maxY) then
		if l=1 then 
		    if numNewCoor[2]=0 then 
			numNewCoor[2]:=l;
			nextFacesSubDiv[2]:=nextFaces[i];
		    fi;
		else	
		    if numNewCoor[2]=0 then 
			numNewCoor[2]:=l;
			nextFacesSubDiv[2]:=nextFaces[i];
		    else
			numNewCoor[2]:=numNewCoor[2]+Length(nextFaces[i])-1;
			RemoveElmList(nextFacesSubDiv[2],Length(nextFacesSubDiv[2]));
			Append(nextFacesSubDiv[2],nextFaces[i]);
		    fi;			
		fi;
	    elif face1[1]=minX and face2[2]=minY and not(face2[1] in [minX,maxX]) then
		if l=1 then 
		    if numNewCoor[1]=0 then 
			numNewCoor[1]:=l;
			nextFacesSubDiv[1]:=nextFaces[i];
		    fi;
		else	
		    if numNewCoor[1]=0 then 
			numNewCoor[1]:=l;
			nextFacesSubDiv[1]:=nextFaces[i];
		    else
			numNewCoor[1]:=numNewCoor[1]+Length(nextFaces[i])-1;
			RemoveElmList(nextFacesSubDiv[1],Length(nextFacesSubDiv[1]));
			Append(nextFacesSubDiv[1],nextFaces[i]);
		    fi;			
		fi;
	    elif face1[2]=maxY and face2[1]=maxX  and not(face2[2]=maxY) then
		if l=1 then 
		    if numNewCoor[3]=0 then 
			numNewCoor[3]:=l;
			nextFacesSubDiv[3]:=nextFaces[i];
		    fi;
		else	
		    if numNewCoor[3]=0 then 
			numNewCoor[3]:=l;
			nextFacesSubDiv[3]:=nextFaces[i];
		    else
			numNewCoor[3]:=numNewCoor[3]+Length(nextFaces[i])-1;
			RemoveElmList(nextFacesSubDiv[3],Length(nextFacesSubDiv[3]));
			Append(nextFacesSubDiv[3],nextFaces[i]);
		    fi;			
		fi;
	    elif face1[2]=maxY and face2[2]=minY and not(face2[1]=maxX) then
		if l=1 then 
		    if numNewCoor[3]=0 then 
			numNewCoor[3]:=l;
			nextFacesSubDiv[3]:=nextFaces[i];
		    fi;
		else	
		    if numNewCoor[3]=0 then 
			numNewCoor[3]:=l;
			nextFacesSubDiv[3]:=nextFaces[i];
		    else
			numNewCoor[3]:=numNewCoor[3]+Length(nextFaces[i])-1;
			RemoveElmList(nextFacesSubDiv[3],Length(nextFacesSubDiv[3]));
			Append(nextFacesSubDiv[3],nextFaces[i]);
		    fi;			
		fi;
	    elif face1[1]=maxX and face2[2]=minY and not(face2[1]=maxX) then
		if l=1 then 
		    if numNewCoor[3]=0 then 
			numNewCoor[3]:=l;
			nextFacesSubDiv[3]:=nextFaces[i];
		    fi;
	        else	
		    if numNewCoor[3]=0 then 
			numNewCoor[3]:=l;
			nextFacesSubDiv[3]:=nextFaces[i];
		    else
			numNewCoor[3]:=numNewCoor[3]+Length(nextFaces[i])-1;
		        RemoveElmList(nextFacesSubDiv[3],Length(nextFacesSubDiv[3]));
		        Append(nextFacesSubDiv[3],nextFaces[i]);
		    fi;			
		fi;
	    fi;	
	od;

	##compute the new face coordinates
	if IsBound(nextFacesSubDiv[4]) and IsBound(nextFacesSubDiv[1]) then
	    if Length(nextFacesSubDiv[4]) <>0 and Length(nextFacesSubDiv[1])<>0 then 	
		if nextFacesSubDiv[4][Length(nextFacesSubDiv[4])]<>nextFacesSubDiv[1][1] then 	
		    numNewCoor[4]:=numNewCoor[4]+1;
		fi;
	    fi;
	fi;
	newPositions:=[];
	if numNewCoor[1]<>0 then
	    if numNewCoor[1]<>1 then 
		for t in [1..Length(nextFacesSubDiv[1])] do 
		    newPositions[nextFacesSubDiv[1][t]]:=[minX+0.25*(maxX-minX),minY+0.25*(maxY-minY)+0.5*((t-1)/(numNewCoor[1]-1))*(maxY-minY)];
		od;
	    else
		newPositions[nextFacesSubDiv[1][1]]:=[minX+0.25*(maxX-minX),minY+0.5*(maxY-minY)];
	    fi;
	fi;

	if numNewCoor[2]<>0 then
	    if numNewCoor[2]<>1 then 
		if numNewCoor[1]<> 0 then 
		    for t in [2..Length(nextFacesSubDiv[2])] do 
			newPositions[nextFacesSubDiv[2][t]]:=[minX+0.25*(maxX-minX)+0.5*((t-1)/(numNewCoor[2]-1))*(maxX-minX),maxY-0.25*(maxY-minY)];
		    od;
		else
		    for t in [1..Length(nextFacesSubDiv[2])] do
			newPositions[nextFacesSubDiv[2][t]]:=[minX+0.25*(maxX-minX)+0.5*((t-1)/(numNewCoor[2]-1))*(maxX-minX),maxY-0.25*(maxY-minY)];
		    od;
		fi;
	    else
		newPositions[nextFacesSubDiv[2][1]]:=[minX+0.5*(maxX-minX),maxY-0.25*(maxY-minY)];
	    fi;
	fi;
#######################################################
	if numNewCoor[3]<>0 then
	    if numNewCoor[3]<>1 then 
		if numNewCoor[1]+numNewCoor[2]<> 0 then
		    for t in [2..Length(nextFacesSubDiv[3])] do 
			newPositions[nextFacesSubDiv[3][t]]:=[maxX-0.25*(maxX-minX),maxY-0.25*(maxY-minY)-0.5*((t-1)/(numNewCoor[3]-1))*(maxY-minY)];
		    od;
		else
		    for t in [1..Length(nextFacesSubDiv[3])] do 
			newPositions[nextFacesSubDiv[3][t]]:=[maxX-0.25*(maxX-minX),maxY-0.25*(maxY-minY)-0.5*((t-1)/(numNewCoor[3]-1))*(maxY-minY)];
		    od;
		fi;
	    else
		newPositions[nextFacesSubDiv[3][1]]:=[maxX-0.25*(maxX-minX),maxY-0.5*(maxY-minY)];
	    fi;
	fi;
############################################
	if numNewCoor[4]<>0 then
	    if numNewCoor[4]<>1 then 
		if numNewCoor[1]+numNewCoor[2]+numNewCoor[3]<>0 then
		    for t in [2..Length(nextFacesSubDiv[4])] do 
			newPositions[nextFacesSubDiv[4][t]]:=[maxX-0.25*(maxX-minX)-0.5*((t-1)/(numNewCoor[4]-1))*(maxX-minX),minY+0.25*(maxY-minY)];
		    od;
		else
		    for t in [1..Length(nextFacesSubDiv[4])] do 
			newPositions[nextFacesSubDiv[4][t]]:=[maxX-0.25*(maxX-minX)-0.5*((t-1)/(numNewCoor[4]-1))*(maxX-minX),minY+0.25*(maxY-minY)];
		    od;
		fi;
	    else
		newPositions[nextFacesSubDiv[4][1]]:=[maxX-0.5*(maxX-minX),minY+0.25*(maxY-minY)];
	    fi;
	fi;
	return newPositions;
    end
);

    ## this function returns the face sequence of an umbrella as a list
BindGlobal( "__SIMPLICIAL_UmbrellaAsList",
    function(cyc)
	local i,f;
	f:=1;	
	while f^cyc=f do 
	    f:=f+1;
	od;
	return List([0..Order(cyc)-1],i->f^(cyc^i));
    end
);


    # compute the embedding of a face graph of a simplicial sphere
    # by assigning 2D-coordinates to the faces

BindGlobal( "__SIMPLICIAL_SetFaceCoordinates",
    function(surface)
	local activeFaces,face1,face2,f,facePositions,g,newCoor,Listact,output,temp,
	visited,tempFacPos,currUmb,Umbrellas,i,startPositions,umb,coor,newFaces;
	Umbrellas:=UmbrellaDescriptorOfSurface(surface);
	Umbrellas:=List(Umbrellas,umb->__SIMPLICIAL_UmbrellaAsList(umb));
	currUmb:=Filtered(Umbrellas,umb->Length(umb)= 
					Maximum(FaceDegreesOfVertices(surface)))[1];
	startPositions:=__SIMPLICIAL_StartPositions(Length(currUmb));
	facePositions:=[];
	for i in [1..Length(currUmb)] do 
	    facePositions[currUmb[i]]:=startPositions[i];
	od;
	Umbrellas:=Difference(Umbrellas,[currUmb]);
	visited:=currUmb;	
	tempFacPos:=ShallowCopy(facePositions);
	while Umbrellas <> [] do 
	    activeFaces:=__SIMPLICIAL_ActiveFaces(tempFacPos,Umbrellas);
	    Add(activeFaces,activeFaces[1]);
	    Listact:=[];
	    for i in [1..Length(activeFaces)-1] do
	        face1:=activeFaces[i];
	        face2:=activeFaces[i+1];
	        currUmb:=Filtered(Umbrellas,umb->face1 in umb and face2 in umb and 
							Intersection(umb,visited)<>[]);
	        if currUmb<> [] then 
		    currUmb:=currUmb[1];
		    Add(Listact,__SIMPLICIAL_OrderFaces(face1,face2,currUmb,visited));
		    Umbrellas:=Difference(Umbrellas,[currUmb]);
	        else 
		    Add(Listact,[]);
	        fi;
	    od;
	    newCoor:=__SIMPLICIAL_NewFaceCoordinates(activeFaces,Listact,Umbrellas,tempFacPos);
	    for coor in newCoor do
	        tempFacPos[Position(newCoor,coor)]:=coor;
	    od;
	    newFaces:=List(newCoor,g->Position(newCoor,g));
	    visited:=Union(visited,newFaces);
	    Umbrellas:=Filtered(Umbrellas,g->not IsSubset(visited,g));
	    temp:=[];
	    for g in tempFacPos do
	        if  Position(tempFacPos,g) in Union(Umbrellas) then 
		    temp[Position(tempFacPos,g)]:=g;
	        fi;
	        facePositions[Position(tempFacPos,g)]:=g;
	    od;
	    tempFacPos:=temp;
        od;
        return facePositions;
    end
);



    ## this functions manipulates the printRecord so that functionalities of 
    ## DrawSurfaceToTikZ can be used 

BindGlobal( "__SIMPLICIAL_InitializePrintRecord",
    function(surface,printRecord)
	local g,colour,e,f,v;
	if not IsBound(printRecord.vertexLabelsActive) then
	    printRecord.vertexLabelsActive := false;
	fi;
	if not IsBound(printRecord.latexDocumentclass) then
	    printRecord.latexDocumentclass := "article";
	fi;
	if not IsBound(printRecord.edgeLabelsActive) then
	    printRecord.edgeLabelsActive := false; 
	fi;
	if not IsBound(printRecord.faceLabelsActive) then
	    printRecord.faceLabelsActive := true;
	fi;
	if not IsBound(printRecord.scale) then
	    printRecord.scale :=2;
	fi;
	if IsBound(printRecord.edgeColours) then
	    if IsString(printRecord.edgeColours) then
		colour:=printRecord.edgeColours; 
		printRecord.edgeColours:=[];
		for e in Edges(surface) do
		    printRecord.edgeColours[e]:=colour;
		od;
	    fi;
	else
		printRecord.edgeColours:=[];
	fi;	
	if not IsBound(printRecord.edgeLabels) then
	    printRecord.edgeLabels := [];
	fi;
        if not IsBound(printRecord.faceLabels) then
            printRecord.faceLabels := [];
        fi;
        if not IsBound(printRecord.vertexLabels) then
            printRecord.vertexLabels := [];
        fi;
	if not IsBound(printRecord.geodesicActive) then
	    printRecord.geodesicActive:= false;
	fi;	
	if not IsBound(printRecord.faceCoordinates2D) then
	    if IsClosedSurface(surface) and IsVertexFaithful(surface) and EulerCharacteristic(surface)=2 then
		printRecord.faceCoordinates2D:= __SIMPLICIAL_SetFaceCoordinates(surface);
	    else 
		Error("face coordinates have to be specified");
	   fi;
	else 
	    if not __SIMPLICIAL_IsCoordinates2D(surface,printRecord.faceCoordinates2D) then
	        Error("face coordinates have to be in the correct format");
	    fi;
	fi;	
	if printRecord.edgeLabelsActive and printRecord.edgeLabels=[] then
	    for e in Edges(surface) do
		printRecord.edgeLabels[e]:=String(e);
	    od;
	fi;
        if printRecord.faceLabelsActive and printRecord.faceLabels=[] then
            for f in Faces(surface) do
                printRecord.faceLabels[f]:=String(f);
            od;
        fi;
        if printRecord.vertexLabelsActive and printRecord.vertexLabels=[] then
            for v in Vertices(surface) do
                printRecord.vertexLabels[v]:=String(v);
            od;
        fi;
        if IsBound(printRecord.faceColours) then
            if IsString(printRecord.faceColours) then
                colour:=printRecord.faceColours;
                printRecord.faceColours:=[];
                for f in Faces(surface) do
                    printRecord.faceColours[f]:=colour;
                od;
            fi;
        else
                printRecord.faceColours:=[];
        fi;

        if IsBound(printRecord.vertexColours) then
            if IsString(printRecord.vertexColours) then
                colour:=printRecord.vertexColours;
                printRecord.vertexColours:=[];
                for v in Vertices(surface) do
                    printRecord.vertexColours[v]:=colour;
                od;
            fi;
        else
                printRecord.vertexColours:=[];
        fi;
        if not IsBound(printRecord.compileLaTeX) then
	    printRecord.compileLaTeX :=false;
	fi;
        if not IsBound(printRecord.noOutput) then
            printRecord.noOutput :=false;
        fi;
        if not IsBound(printRecord.onlyTikzpicture) then
            printRecord.onlyTikzpicture:=false;
        fi;


	return printRecord;
    end
);






   #this function prints the embedding of the face graph of a 
   #simplicial surface into a .tex file
InstallMethod( DrawFacegraphToTikz,
    "for a closed simplicial surface, a file and a record",
    [IsSimplicialSurface, IsString, IsRecord],
    function(surface, file,printRecord)
    local e,e1,e2,f,f1,f2,f3,v,v1,v2,faceCoordTikZ,foe,output,umb,maxX,maxY,
    sum,newCoor,minX,minY,mX,mY,geodesic,i,j,currUmb,coordinates,temp,
    umbrellas,color,tempRec;

    if not( IsClosedSurface(surface) and IsVertexFaithful(surface) and EulerCharacteristic(surface)=2) and not IsBound(printRecord.faceCoordinates2D) then 
	return fail;
    fi;
        # Do something different for the manual
        if __SIMPLICIAL_MANUAL_MODE then
            printRecord!.onlyTikzpicture := true;
            printRecord!.compileLaTeX := false;
            printRecord!.noOutput := true;
            file := Concatenation( "doc/_TIKZ_", file );
        fi;

    sum:=function(L)
	local g,s,n;
	s:=[0.,0.];
	n:=Length(L);
	for g in L do
	    s:=1./n*g+s;
	od;
	return s;
    end;
    # Make the file end with .tex
    if not EndsWith( file, ".tex" ) then
        file := Concatenation( file, ".tex" );
    fi;

    f := Filename( DirectoryCurrent(), file );
    output := OutputTextFile( f, false );
    if output = fail then
        Error(Concatenation("File ", String(file), " can't be opened.") );
    fi;
    printRecord:=__SIMPLICIAL_InitializePrintRecord(surface,printRecord);
    SetPrintFormattingStatus( output, false );

    # Add Header to .tex file 
    tempRec:=ShallowCopy(printRecord);
    tempRec.faceLabelsActive:= printRecord.vertexLabelsActive;
    tempRec.vertexLabelsActive:= printRecord.faceLabelsActive;
    tempRec.vertexLabels:=printRecord.faceLabels;
    tempRec.faceLabels:=printRecord.vertexLabels;
    tempRec.vertexColours:=printRecord.faceColours;
    tempRec.faceColours:=printRecord.vertexColours;

  # Write this data into the file
    if not printRecord!.onlyTikzpicture then
        AppendTo( output, __SIMPLICIAL_PrintRecordGeneralHeader(tempRec));
        AppendTo( output, __SIMPLICIAL_PrintRecordTikzHeader(tempRec));
        AppendTo( output, "\n\n\\begin{document}\n\n" );
        if IsBound(printRecord!.caption) then
            AppendTo( output,
                "\\subsection*{", printRecord!.caption, "}\n \\bigskip\n");
            fi;
        fi;

#    AppendTo( output,__SIMPLICIAL_PrintRecordGeneralHeader(tempRec));
#    AppendTo( output,__SIMPLICIAL_PrintRecordTikzHeader(tempRec));
#    AppendTo( output, "\n\n\\begin{document}\n");
    AppendTo( output, "\n\n\\begin{tikzpicture}[",
    __SIMPLICIAL_PrintRecordTikzOptions(tempRec, surface), "]\n\n" );

    faceCoordTikZ:=[];
    for f in Faces(surface) do
        faceCoordTikZ[f]:=Concatenation("V",String(f));
    od;
    ##define face coordinates
    for f in Faces(surface) do
	AppendTo(output	,"\\coordinate (",faceCoordTikZ[f],") at (",
	printRecord.faceCoordinates2D[f][1]," , ",printRecord.faceCoordinates2D[f][2],");\n");
	#AppendTo(output,__SIMPLICIAL_PrintRecordDrawFaceFG(printRecord, surface, face, faceTikzCoord));
   od;

    ##draw edges
    for e in InnerEdges(surface) do 
	foe:=FacesOfEdge(surface,e);
        AppendTo(output,__SIMPLICIAL_PrintRecordDrawEdge(printRecord,surface,e,
	faceCoordTikZ{foe},printRecord.faceCoordinates2D{foe}));
    od;
    ##draw faces as nodes
#    for f in Faces(surface) do
#	AppendTo(output,"\\vertexLabelR{",faceCoordTikZ[f],"}{left}{$",f,"$}\n");
#   od;

    AppendTo( output, "% Draw the faces\n" );
    for f in Faces(surface) do
	AppendTo( output, __SIMPLICIAL_PrintRecordDrawFaceFG( printRecord, surface, f, faceCoordTikZ[f]));
    od;

    umbrellas:=UmbrellaDescriptorOfSurface(surface);
    umbrellas:=List(umbrellas,umb->__SIMPLICIAL_UmbrellaAsList(umb));
    currUmb:=Filtered(umbrellas,umb->Length(umb)=Maximum(FaceDegreesOfVertices(surface)))[1];

    ## draw vertex labels
    if IsBound(printRecord.vertexLabelsActive) then 
	if printRecord.vertexLabelsActive then
	   # at first draw vertex label of the outer umbrella
	    v:=Filtered(Vertices(surface),v->Set(FacesOfVertex(surface,v))=Set(currUmb))[1];
	    umbrellas:=Difference(umbrellas,[currUmb]);
	    coordinates:=List(currUmb,f->printRecord.faceCoordinates2D[f]);
	    maxX:=Maximum(List(coordinates,g->g[1]));
	    maxY:=Maximum(List(coordinates,g->g[2]));
	    minY:=Minimum(List(coordinates,g->g[2]));
#	    AppendTo(output,"\\node[faceLabel,scale=1.5] at (",maxX+1.,",",minY+1/2*(maxY-minY),") {$",v,"$};\n");
	    AppendTo(output,__SIMPLICIAL_PrintRecordDrawVertexFG(printRecord, surface, v,[maxX+1.,minY+1/2*(maxY-minY)]) ); 
           ## now the other labels 
	    for umb in umbrellas do
		v:=Filtered(Vertices(surface),v->Set(FacesOfVertex(surface,v))=Set(umb))[1];
		coordinates:=List(umb,f->printRecord.faceCoordinates2D[f]);
		temp:=sum(coordinates);
		AppendTo(output,__SIMPLICIAL_PrintRecordDrawVertexFG(printRecord,surface,v,temp));
	    od; 
	fi;
    fi;

    # draw geodesics 
    if IsBound(printRecord.geodesicActive) then 
	if printRecord.geodesicActive and EulerCharacteristic(surface)=2 then
	    coordinates:=[]; 
	    coordinates:=List(Vertices(surface),v->[]);
	    for umb in umbrellas do
		v:=Filtered(Vertices(surface),v->Set(FacesOfVertex(surface,v))=Set(umb))[1];
		temp:=List(umb,f->printRecord.faceCoordinates2D[f]);
		for f in umb do 
		    coordinates[v][f]:=printRecord.faceCoordinates2D[f]+0.1*(sum(temp)-printRecord.faceCoordinates2D[f]);
		od;
	    od;
	    v:=Filtered(Vertices(surface),v->Set(FacesOfVertex(surface,v))=Set(currUmb))[1];
	    temp:=sum(List(currUmb,f->printRecord.faceCoordinates2D[f]));
	    maxX:=Maximum(List(currUmb,f->printRecord.faceCoordinates2D[f][1]));
	    maxY:=Maximum(List(currUmb,f->printRecord.faceCoordinates2D[f][2]));
	    minX:=Minimum(List(currUmb,f->printRecord.faceCoordinates2D[f][1]));
	    minY:=Minimum(List(currUmb,f->printRecord.faceCoordinates2D[f][2]));
	    mX:=maxX-minX;
	    mY:=maxY-minY;
	    for f in currUmb do 
		coordinates[v][f]:=printRecord.faceCoordinates2D[f];
		if printRecord.faceCoordinates2D[f][1]=minX then 
		    coordinates[v][f]:=coordinates[v][f]-[0.05*mX,0.];
		fi;
		if printRecord.faceCoordinates2D[f][2]=minY then 
		    coordinates[v][f]:=coordinates[v][f]-[0.,0.05*mY];
		fi;
		if printRecord.faceCoordinates2D[f][1]=maxX then 
		    coordinates[v][f]:=coordinates[v][f]+[0.05*mX,0.];
		fi;
		if printRecord.faceCoordinates2D[f][2]=maxY then 
		    coordinates[v][f]:=coordinates[v][f]+[0.,0.05*mY];
		fi;
	    od;
	    color:=["red","blue","green","yellow","brown","gray","pink"];
	    geodesic:=MaximalGeodesicPaths(surface);
	    geodesic:=List(geodesic,g->ShallowCopy(FacesAsList(g)));
	    for i in [1..Length(geodesic)] do 
		Add(geodesic[i],geodesic[i][1]);
		Add(geodesic[i],geodesic[i][2]);
		for j in [1..Length(geodesic[i])-2] do 
		    f1:=geodesic[i][j];
		    f2:=geodesic[i][j+1];
		    f3:=geodesic[i][j+2];
		    e1:=Filtered(Edges(surface),e->FacesOfEdge(surface,e)=Set([f1,f2]))[1];
		    e2:=Filtered(Edges(surface),e->FacesOfEdge(surface,e)=Set([f2,f3]))[1];	
		    v:=VerticesOfEdge(surface,e1);
		    v1:=Filtered(v,g-> not g in VerticesOfEdge(surface,e2))[1];
		    v2:=Difference(v,[v1])[1];
		    AppendTo(output,"\\draw[edge=",color[i],"] (",
				coordinates[v1][f1][1],",",coordinates[v1][f1][2],") -- (",
				coordinates[v2][f2][1],",",coordinates[v2][f2][2],");\n");
		od;
	    od;
	fi;
    fi;

    AppendTo(output,"\\end{tikzpicture}\n");
    if not printRecord!.onlyTikzpicture then
        AppendTo( output, "\n\\end{document}\n");
    fi;

    CloseStream(output);
    if not printRecord!.noOutput then
        Print( "Picture written in TikZ." );
    fi;

    if printRecord.compileLaTeX then
        if not printRecord!.noOutput then
            Print( "Start LaTeX-compilation (type 'x' and press ENTER to abort).\n" );
        fi;

        # Run pdfLaTeX on the file (without visible output)
        Exec( "pdflatex ", file, " > /dev/null" );
        if not printRecord!.noOutput then
            Print( "Picture rendered (with pdflatex).\n");
        fi;
    fi;


    return printRecord;
end
);


InstallOtherMethod( DrawFacegraphToTikz,
    "for a simplicial surface and a file name",
    [IsSimplicialSurface,IsString],
    function(surface,file)
	    return DrawFacegraphToTikz(surface,file,rec());
    end
);


InstallMethod( DrawConvexFacegraphToTikz,
    "for a closed vertex-faithful simplicial sphere, a file name and a record",
    [IsSimplicialSurface, IsString, IsRecord],
    function(surf, name, record)
        local graph, SplitListPosition, ThreeSplitListPosition, InFilterFunc, IntersectionFilterFunc, CorrectFacesOfVertexFilter, WeightedCentric, TwoWeightedCentric, MainHelp, RegularPolygon, DrawConvexFaceGraph, DrawGraph;
        if not( IsClosedSurface(surf) and IsVertexFaithful(surf) and EulerCharacteristic(surf)=2) and not IsBound(printRecord.faceCoordinates2D) then 
            return fail;
        fi;

        SplitListPosition := function(list, v) # help function
            local i, res1, res2;
            res1:=[];
            res2:=[];
            for i in [2..v] do
                Add(res1,list[i]);
            od;
            for i in [v..Length(list)] do
                Add(res2, list[i]);
            od;
            Add(res1,list[1]);
            Add(res2, list[1]);
            return [res1,res2];
        end;

        ThreeSplitListPosition := function(list, v, w) # helpt function
            local i, res1, res2, res3;
            if w > v then
                res1 := [];
                res2 := [];
                res3 := [];
                for i in [2..v] do
                    Add(res1,list[i]);
                od;
                for i in [v..w] do
                    Add(res2, list[i]);
                od;
                for i in [w..Length(list)] do
                    Add(res3, list[i]);
                od;
                Add(res1, list[1]);
                Add(res2, list[1]);
                Add(res3, list[1]);
            elif w < v then
                res1 := [];
                res2 := [];
                res3 := [];
                for i in [2..w] do
                    Add(res1,list[i]);
                od;
                for i in [w..v] do
                    Add(res2, list[i]);
                od;
                for i in [v..Length(list)] do
                    Add(res3, list[i]);
                od;
                Add(res1, list[1]);
                Add(res2, list[1]);
                Add(res3, list[1]);
            fi;
            return [res1, res2, res3];
        end;

        InFilterFunc := function(cur1, cur2, list) # help function
            if cur1 in list and cur2 in list then
                return true;
            else
                return false;
            fi;
        end;

        IntersectionFilterFunc := function(faceGraph, list) # help function
            if not IsEmpty(Intersection(faceGraph, list)) then
                return true;
            else 
                return false;
            fi;
        end;

        CorrectFacesOfVertexFilter := function(cur1, cur2, faceGraph, list) # help function
            return InFilterFunc(cur1, cur2, list) and IntersectionFilterFunc(faceGraph, list);
        end;

        WeightedCentric := function(list) # help function
            return Float(2/3)*list[1]+Float(1/6)*(list[2]+list[3]);
        end;

        TwoWeightedCentric := function(list) # help function
            local res;
            res := [];
            Add(res, Float(2/3)*list[1] + Float(5/18)*list[2] + Float(1/18)*list[3]);
            Add(res, Float(2/3)*list[1] + Float(1/18)*list[2] + Float(5/18)*list[3]);
            return res;
        end;

        MainHelp := function(surf, cur, faceGraph) #surf simp. surface, cur list of lists of [v,[x,y]], faceGraph list of [v,[x,y]] with the added vertices of wanted faceGraph 
            local n, mainHelp1, mainHelp2, cur1, cur2, curi, mainHelpi, i, v, newv, res, neighbours, verticesOfFaceGraph, correctFacesOfVertex, toSplitVertex, toSplitVertex1, toSplitVertex2, toSplitVertexPos, toSplitVertexPos1, toSplitVertexPos2, alreadyPositionedVertices;
            if Length(cur) >= 2 then    # More than one convex drawing plane
                res := [];
                faceGraph := MainHelp(surf, [cur[1]], faceGraph)[2];
                for i in [1..Length(cur)] do
                    mainHelpi := MainHelp(surf, [cur[i]], faceGraph);
                    curi := mainHelpi[1];
                    res := Concatenation(res, curi);
                    faceGraph := Set(Concatenation(faceGraph, mainHelpi[2]));
                od;
                return [res, faceGraph];
            elif Length(cur)=1 then     # Only one convex drawing plane
                cur := cur[1];
                n:=Length(cur);
                if n < 2 then
                    return [[[]], faceGraph];
                fi;
                neighbours := NeighbourFacesOfFace(surf, cur[1][1]);
                verticesOfFaceGraph := List(faceGraph, x -> x[1]);
                if Length(Intersection(verticesOfFaceGraph, neighbours)) = 2 then                                       # 2 neighbours of cur[1] have been positioned already
                    if Length(neighbours) = 2 then # There are only 2 neighbours which means no vertex has to be positioned
                        Remove(cur, 1);
                    else                           # There are 3 neighbours which means there is a new vertex that has to be positioned
                        for v in neighbours do
                            if not v in verticesOfFaceGraph then
                                newv := [v, WeightedCentric([cur[1][2], cur[2][2], cur[n][2]])];
                                Add(faceGraph, newv);
                                Remove(cur, 1);
                                Add(cur, newv);
                            fi;
                        od;
                    fi;
                    return [[cur], faceGraph];
                elif Length(Intersection(verticesOfFaceGraph, neighbours)) = 1 then                                     # 1 neighbour of cur[1] has been positioned already
                    if Length(neighbours) = 1 then   # There is only 1 neighbour which means no vertex has to be positioned
                        Remove(cur, 1);
                    elif Length(neighbours) = 2 then # There are only 2 neighbours which means 1 vertex has to be positioned
                        for v in neighbours do
                            if not v in verticesOfFaceGraph then
                                newv := [v, WeightedCentric([cur[1][2], cur[2][2], cur[n][2]])];
                                Add(faceGraph, newv);
                                Remove(cur, 1);
                                Add(cur, newv);
                            fi;
                        od;
                    else                             # There are 3 neighbours which means 2 vertices have to be positioned
                        correctFacesOfVertex := Filtered(FacesOfVertices(surf), x -> CorrectFacesOfVertexFilter(cur[1][1], cur[2][1], List(faceGraph, y -> y[1]), x));
                        for v in Difference(Difference(neighbours, correctFacesOfVertex[1]), verticesOfFaceGraph) do
                            newv := [v, TwoWeightedCentric([cur[1][2], cur[2][2], cur[n][2]])[2]];
                            Add(faceGraph, newv);
                            Add(cur, newv);
                        od;
                        for v in Difference(Intersection(neighbours, correctFacesOfVertex[1]), verticesOfFaceGraph) do
                            newv := [v, TwoWeightedCentric([cur[1][2], cur[2][2], cur[n][2]])[1]];
                            Add(faceGraph, newv);
                            Add(cur, newv);
                        od;
                    fi;
                    Remove(cur, 1);
                    return [[cur], faceGraph];
                elif Length(Intersection(verticesOfFaceGraph, neighbours)) = 3 then                                     # 3 neighbours of cur[1] have been positioned already
                    alreadyPositionedVertices := Difference(neighbours, [cur[2][1], cur[n][1]]);
                    if Length(Intersection(List(cur, x -> x[1]), alreadyPositionedVertices)) = 2 then       # case 3: edge slices convex drawing plane in three and splits it
                        toSplitVertex1 := Intersection(List(cur, x -> x[1]), alreadyPositionedVertices)[1];
                        toSplitVertex2 := Intersection(List(cur, x -> x[1]), alreadyPositionedVertices)[2];
                        toSplitVertexPos1 := Position(List(cur, x -> x[1]), toSplitVertex1);
                        toSplitVertexPos2 := Position(List(cur, x -> x[1]), toSplitVertex2);
                        return [ThreeSplitListPosition(cur, toSplitVertexPos1, toSplitVertexPos2), faceGraph];
                    elif Length(Intersection(List(cur, x -> x[1]), alreadyPositionedVertices)) = 1 then     # case 2: edge slices convex drawing plane in two and splits it
                        toSplitVertex := Intersection(List(cur, x -> x[1]), alreadyPositionedVertices)[1];
                        toSplitVertexPos := Position(List(cur, x -> x[1]), toSplitVertex);
                        return [SplitListPosition(cur, toSplitVertexPos), faceGraph];
                    elif Length(Intersection(List(cur, x -> x[1]), alreadyPositionedVertices)) = 0 then     # case 1: edge does not violate convex drawing plane
                        Remove(cur, 1);
                        return [[cur], faceGraph];              
                    else                                            
                        # Print("Failure at 3 neighbours of cur[1] have been positioned already!");
                        Error();
                    fi;
                fi;
            fi;
        end;

        RegularPolygon := function(list) #returns vertices of a regular polygon as a list of [vert, [x,y]]
            local n, res, i;
            res:=[];
            n:=Length(list);
            for i in [1..n] do
                Add(res,[list[i],[Cos(2*3.14159265*((i-1)/n)),Sin(2*3.14159265*((i-1)/n))]]);
            od;
            return res;
        end;

        DrawConvexFaceGraph := function(surf)
            local cur, faceGraph, path, mainHelp, maxPathPos;
            maxPathPos := PositionMaximum(List(UmbrellaPathsOfVertices(surf), x -> Length(FacesAsList(x))));
            path := UmbrellaPathOfVertex(surf, maxPathPos);             # Start with the biggest UmbrellaPath
            # path := UmbrellaPathOfVertex(surf, Vertices(surf)[1]);    # Start with the UmbrellaPath of the vertex 1
            cur := [RegularPolygon(FacesAsList(path))];
            faceGraph := RegularPolygon(FacesAsList(path));
            while Length(faceGraph)<NumberOfFaces(surf) do
                mainHelp := MainHelp(surf, cur, faceGraph);
                cur := mainHelp[1];
                faceGraph := mainHelp[2];
            od; 
            return faceGraph;
        end;

        graph := DrawConvexFaceGraph(surf);
        SortBy(graph, x -> x[1]);
        if "scale" in RecNames(record) and "faceCoordinates2D" in RecNames(record) then
            return DrawFacegraphToTikz(surf, name, record);
        elif (not "scale" in RecNames(record)) and "faceCoordinates2D" in RecNames(record) then
            record.scale := 4;
        elif "scale" in RecNames(record) and (not "faceCoordinates2D" in RecNames(record)) then
            record.faceCoordinates2D := List(graph, x -> x[2]);
        else
            record.faceCoordinates2D := List(graph, x -> x[2]);
            record.scale := 4;
        fi;
        
        return DrawFacegraphToTikz(surf, name, record);

    end
);

InstallOtherMethod( DrawConvexFacegraphToTikz,
    "for a simplicial surface and a file name",
    [IsSimplicialSurface, IsString],
    function(surf, name)
	    return DrawConvexFacegraphToTikz(surf, name, rec());
    end
);

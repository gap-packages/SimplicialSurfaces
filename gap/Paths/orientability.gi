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




##
## Write all other functions
##
__SIMPLICIAL_AddRamifiedPolygonalAttribute( Orientation );


##############################
##
## Primary computation
##
InstallMethod( Orientation, 
    "for a polygonal complex without edge ramifications with FacesOfEdges, VerticesOfFaces, EdgesOfFaces, VerticesOfEdges",
    [ IsPolygonalComplex and IsNotEdgeRamified and HasFacesOfEdges and
        HasVerticesOfFaces and HasEdgesOfFaces and HasVerticesOfEdges ],
    function( surf )
	local facesOfEdges, verticesOfFaces, orientList, i, hole, edge,
	    facesToCheck, checkedFaces, CompatibleOrientation, orient1,
	    orient2, orientable, face, next, relOrient,
            FindGlobalOrientation, correctOr;

        if NumberOfFaces(surf) = 0 then
            return [];
        fi;

	# This method tries to find an orientation for the surface. 
        # It does so by constructing
	# CyclicVertexOrderInFaces we can distinguish "up" and "down" for each
	# individual face. If we now define a map from the faces to {+1,-1}
	# then this defines a set of orientations for all faces (+1 means "up",
	# -1 means "down"). Two adjacent faces have a compatible orientation
	# if they induce opposite orientations on the edge between them (you
	# can see this quite easily if you draw a picture). In this method we
	# use this fact to construct an orientation for the complete surface.

        facesOfEdges := FacesOfEdges(surf);
    	verticesOfFaces := VerticesOfFaces(surf);

	# Method to check if the orientation of a face is induced by that of
	# one of its edges
	CompatibleOrientation := function( edgeByVertices, facePerm )
	    return edgeByVertices[1]^VerticesAsPerm(facePerm) = edgeByVertices[2];
	end;

	# The variable orientList contains our constructed orientation. We have
	# to be careful since this list might contain holes. Therefore we have
	# to use Number instead of Length to only count the bound entries.
	orientable := true;
	orientList := [];
	while Number(orientList) < NumberOfFaces(surf) and orientable do
	    # We proceed individually in each strongly connected component. 
            # This loop
	    # is called once per strongly connected component. We start by 
            # finding a
	    # face that was not already included, define the minimal 
            # orientation for it
	    # and then derive how all other orientations have to look
	    # like (and maybe find a contradiction).
	
	    # Find the first face that has no defined orientation
	    hole := 0;
	    for face in Faces(surf) do
		if not IsBound( orientList[face] ) then
		    hole := face;
		    break;
		fi;
	    od;
	
	    # Define the standard orientation of this face
	    orientList[hole] := PerimeterPathOfFaceNC(surf,hole);
	    facesToCheck := [hole];		# Save the faces that have to be checked
	    checkedFaces := [];			# Save the faces that are "clear"

	    # The next loop is responsible for iterating through the strongly 
            # connected
	    # component of the face 'hole'. This has to be done step by step
	    # since we can only transform the orientation of one face into the
	    # orientation of an adjacent face.
	    while facesToCheck <> [] and orientable do
		face := facesToCheck[1];

		# For each face we check the transitions over all edges
		for edge in EdgesOfFaces(surf)[face] do
                    next := NeighbourFaceByEdge(surf, face, edge);
		    # This should be unique (inner edge) or empty (border edge)
		    if next = fail then
			continue;	# A border edge is no problem at all
		    fi;
			
		    # Now we have to check whether 'face' and 'next' induce
		    # different orientations on the edge between them. To do
		    # so we check whether the orientations of the two faces
		    # are compatible with a random orientation of the edge.
		    orient1 := 0;
		    orient2 := 0;
		    # Check how these two faces act on the edge
		    if CompatibleOrientation( VerticesOfEdges(surf)[edge],
                                            orientList[face]) then
			orient1 := 1;
		    else
			orient1 := -1;
		    fi;

		    if CompatibleOrientation( VerticesOfEdges(surf)[edge], 
                            PerimeterPathOfFaceNC(surf,next) ) then
			orient2 := 1;
		    else
			orient2 := -1;
		    fi;
	
                    # if orient1 * orient2 = -1 then the two polygonal
                    # orientations induce different edge orientations (ok).
                    # if orient1 * orient2 = 1 then they induce the same edge
                    # orientation => invert the cycle of next
                    relOrient := -1 * orient1 * orient2;
                    if relOrient = 1 then
                        correctOr := PerimeterPathOfFaceNC(surf,next);
                    else
                        correctOr := Inverse( PerimeterPathOfFaceNC(surf,next) );
                    fi;
                    if IsBound( orientList[next]) and orientList[next] <> correctOr  then
                        orientable := false;
                        break;
                    else
                        orientList[next] := correctOr;
                    fi;
	
		    if not next in checkedFaces then
			facesToCheck := Union( facesToCheck, [next] );
		    fi;
		od;
	        facesToCheck := Difference( facesToCheck, [face] );
		checkedFaces := Union( checkedFaces, [face] );
	    od;
	od;

        if orientable then
            return orientList;
        fi;
        return fail;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "Orientation",
    ["FacesOfEdges", "VerticesOfFaces", "EdgesOfFaces", "VerticesOfEdges"],
    ["IsPolygonalComplex"]);



##
## Special case if the orientability is known
##
InstallImmediateMethod( Orientation, 
    "for a polygonal complex without edge ramifications with known orientation",
    IsPolygonalComplex and IsNotEdgeRamified and HasIsOrientable, 0,
    function(ramSurf)
        if not IsOrientable(ramSurf) then
            return fail;
        fi;
        TryNextMethod();
    end
);

##
##  Now we write the method to only check if an orientation exists
##
InstallImmediateMethod( IsOrientable,
    "for a polygonal complex without edge ramifications with Orientation",
    IsPolygonalComplex and IsNotEdgeRamified and HasOrientation, 0,
    function(ramSurf)
        return Orientation(ramSurf) <> fail;
    end
);

## If we can't compute IsOrientable any other way, we try computing a global
## orientation first
InstallMethod( IsOrientable,
    "for a polygonal complex without edge ramifications",
    [IsPolygonalComplex and IsNotEdgeRamified],
    function(ramSurf)
        if HasOrientation(ramSurf) then
            TryNextMethod();
        fi;
        Orientation(ramSurf);
        return IsOrientable(ramSurf);
    end
);

## global orientation computation for twisted polygonal complexes
InstallMethod( IsOrientable,
    "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex and IsNotEdgeRamified],
    function(complex)
        local chamberValues, done, todo, check, zeroInv, oneInv, twoInv, c,
            zeroAd, oneAd, twoAd;

        zeroInv := ZeroAdjacencyInvolution(complex);
        oneInv := OneAdjacencyInvolution(complex);
        twoInv := TwoAdjacencyInvolution(complex);

        chamberValues := [];
        done := [];
        todo := Chambers(complex);
        while not IsEmpty(todo) do # for each strongly connected component
            chamberValues[todo[1]] := 1;
            check := [todo[1]];
            todo := todo{[2..Length(todo)]};
            while not IsEmpty(check) do
                c := check[1];
                check := check{[2..Length(check)]};

                # Zero Adjacency
                zeroAd := c^zeroInv;
                if zeroAd in todo then
                    chamberValues[zeroAd] := -1 * chamberValues[c];
                    Add(check, zeroAd);
                    todo := Difference(todo, [zeroAd]);
                else
                    if chamberValues[c]*chamberValues[zeroAd] = 1 then
                        return false;
                    fi;
                fi;

                # One Adjacency
                oneAd := c^oneInv;
                if oneAd in todo then
                    chamberValues[oneAd] := -1 * chamberValues[c];
                    Add(check, oneAd);
                    todo := Difference(todo, [oneAd]);
                else
                    if chamberValues[c]*chamberValues[oneAd] = 1 then
                        return false;
                    fi;
                fi;

                # Two Adjacency
                twoAd := c^twoInv;
                if twoAd in todo then
                    chamberValues[twoAd] := -1 * chamberValues[c];
                    Add(check, twoAd);
                    todo := Difference(todo, [twoAd]);
                else
                    if c <> twoAd and chamberValues[c]*chamberValues[twoAd] = 1 then
                        return false;
                    fi;
                fi;
            od;
        od;
        return true;
    end
);

## OrientationCover 
##TODO maybe reorganise -> This might not be the best spot
## maybe put VertexEdgePaths in their own chapter etc.

InstallMethod( OrientationCover, "for a polygonal complex without edge ramifications", 
    [IsPolygonalComplex and IsNotEdgeRamified],
    function(ramSurf)
        local splitSurf, newFaces, f, perimeter, newEdges, e, incFaces, v1, 
            v2, newF1, newF2, newF, cyc1, cyc2, bool1, bool2, newVertices,
            sideA, sideB, i, j, diff1A, diff1B, diff2A, diff2B, obj,
            vert, faces, vertsOfEdges, facesOfEdges, v, umb, first, edge, 
            neighbours, nVertex, nEdge, nFace, faceMap, edgeMap, vertexMap;

        # Remove all ramified vertices
        splitSurf := SplitAllVertices(ramSurf);

        newFaces := [];
        faceMap := [];
        for f in Faces(splitSurf) do
            perimeter := PerimeterPathsOfFaces(splitSurf)[f];
            newFaces[f] := [[f,perimeter], [f,Inverse(perimeter)]];
            Append(faceMap, [f,f]);
        od;

        newEdges := [];
        edgeMap := [];
        for e in Edges(splitSurf) do
            incFaces := FacesOfEdges(splitSurf)[e];
            if Length(incFaces) = 1 then
                newF := newFaces[incFaces[1]];
                newEdges[e] := [ [e,newF] ];
                Add(edgeMap, [e]);
            else
                # inner edge
                v1 := VerticesOfEdges(splitSurf)[e][1];
                v2 := VerticesOfEdges(splitSurf)[e][2];
                newF1 := newFaces[incFaces[1]];
                newF2 := newFaces[incFaces[2]];
                cyc1 := VerticesAsPerm( newF1[1][2] );
                cyc2 := VerticesAsPerm( newF2[1][2] );
                # this only works for faces with at least three vertices!
                bool1 := v1^cyc1 = v2;
                bool2 := v1^cyc2 = v2;
                if bool1 = bool2 then
                    # the "first" perimeters have opposite orientation
                    newEdges[e] := [ 
                        [ e, [ newF1[1], newF2[2] ] ], [ e, [ newF1[2], newF2[1] ] ]
                    ];
                else
                    # the "first" perimeters have equal orientation
                    newEdges[e] := [ 
                        [ e, [ newF1[1], newF2[1] ] ], [ e, [ newF1[2], newF2[2] ] ]
                    ];
                fi;
                Append(edgeMap,[e,e]);
            fi;
        od;

        newVertices := [];
        vertexMap := [];
        for v in VerticesAttributeOfComplex(splitSurf) do
            umb := UmbrellaPathsOfVertices(splitSurf)[v];
            if IsClosedPath(umb) then
                sideA := [];
                sideB := [];
                first := FacesAsList(umb)[1];
                Add(sideA, newFaces[first][1]);
                Add(sideB, newFaces[first][2]);
                for i in [2..Length(EdgesAsList(umb))-1] do
                    edge := EdgesAsList(umb)[i];
                    diff1A := Difference( newEdges[edge][1][2], sideA );
                    diff1B := Difference( newEdges[edge][1][2], sideB );
                    diff2A := Difference( newEdges[edge][2][2], sideA );
                    diff2B := Difference( newEdges[edge][2][2], sideB );
                    if Length(diff1A) = 1 then
                        Append(sideA, diff1A);
                        Append(sideB, diff2B);
                    else
                        Append(sideA, diff2A);
                        Append(sideB, diff1B);
                    fi;
                od;
                newVertices[v] := [ [v,sideA], [v,sideB ] ];
                Append(vertexMap, [v,v]);
            else
                # all incident faces show up with both sides
                neighbours := [];
                for f in FacesAsList(umb) do
                    newF := newFaces[f];
                    Append( neighbours, [ List(newF, p -> [ f, p ]) ] );
                od;
                newVertices[v] := [ [v,neighbours]];
                Add(vertexMap, v);
            fi;
        od;


        newVertices := Concatenation(newVertices);
        newEdges := Concatenation(newEdges);
        newFaces := Concatenation(newFaces);
        vertsOfEdges := [];
        facesOfEdges := [];
        for i in [1..Length(newEdges)] do
            vert := [];
            nEdge := newEdges[i];
            for j in [1..Length(newVertices)] do
                nVertex := newVertices[j];
                if nVertex[1] in VerticesOfEdges(splitSurf)[nEdge[1]] and IsSubset(nVertex[2], nEdge[2]) then
                    Add(vert,j);
                fi;
            od;
            vertsOfEdges[i] := vert;

            faces := [];
            for j in [1..Length(newFaces)] do
                nFace := newFaces[j];
                if nEdge[1] in EdgesOfFaces(splitSurf)[nFace[1]] and nFace in nEdge[2] then
                    Add(faces,j);
                fi;
            od;
            facesOfEdges[i] := faces;
        od;

        obj := Objectify(TwistedPolygonalComplexType, rec());
        SetVerticesOfEdges(obj, vertsOfEdges);
        SetFacesOfEdges(obj, facesOfEdges);
        return [obj, [vertexMap,edgeMap,faceMap], List(newFaces, i -> i[2])];
    end
);
RedispatchOnCondition( OrientationCover, true, [IsPolygonalComplex], [IsNotEdgeRamified], 0 );
#TODO this can be improved with a wild colouring. Can that be implemented in some way?
#TODO: return a homomorphism. How to deal with the map newFaces->oldPerimeters?

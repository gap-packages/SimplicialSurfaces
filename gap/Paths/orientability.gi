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
## Write the wrapper function
##
InstallMethod( OrientationByVertices, "for a ramified polygonal surface",
    [IsRamifiedPolygonalSurface],
    function( ramSurf )
        return OrientationByVerticesAsPerm(ramSurf);
    end
);
    RedispatchOnCondition( OrientationByVertices, true, 
        [IsPolygonalComplex], [IsRamifiedPolygonalSurface], 0);

InstallMethod( OrientationByEdges, "for a ramified polygonal surface",
    [IsRamifiedPolygonalSurface],
    function( ramSurf )
        return OrientationByEdgesAsPerm(ramSurf);
    end
);
    RedispatchOnCondition( OrientationByVertices, true, 
        [IsPolygonalComplex], [IsRamifiedPolygonalSurface], 0);


##
## Write all other functions
##
__SIMPLICIAL_AddRamifiedAttribute( OrientationByVerticesAsPerm );
__SIMPLICIAL_AddRamifiedAttribute( OrientationByVerticesAsList );
__SIMPLICIAL_AddRamifiedAttribute( OrientationByEdgesAsPerm );
__SIMPLICIAL_AddRamifiedAttribute( OrientationByEdgesAsList );


##############################
##
## Primary computation
##
InstallMethod( OrientationByVerticesAsPerm, 
    "for a ramified polygonal surface with FacesOfEdges, VerticesOfFaces, EdgesOfFaces, VerticesOfEdges",
    [ IsRamifiedPolygonalSurface and HasFacesOfEdges and
        HasVerticesOfFaces and HasEdgesOfFaces and HasVerticesOfEdges ],
    function( surf )
	local facesOfEdges, verticesOfFaces, orientList, i, hole, edge,
	    facesToCheck, checkedFaces, CompatibleOrientation, orient1,
	    orient2, orientable, face, next, 
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
	    return edgeByVertices[1]^facePerm = edgeByVertices[2];
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
	    orientList[hole] := CyclicVertexOrderOfFace(surf,hole);
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
                            CyclicVertexOrderOfFace(surf,next) ) then
			orient2 := 1;
		    else
			orient2 := -1;
		    fi;
	
                    # if orient1 * orient2 = -1 then the two polygonal
                    # orientations induce different edge orientations (ok).
                    # if orient1 * orient2 = 1 then they induce the same edge
                    # orientation => invert the cycle of next
                    correctOr := CyclicVertexOrderOfFace(surf,next)^(-1 * orient1 * orient2);
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
    "OrientationByVerticesAsPerm",
    ["FacesOfEdges", "VerticesOfFaces", "EdgesOfFaces", "VerticesOfEdges"] );



##############################
##
##  VerticesAsPerm
##
InstallMethod( OrientationByVerticesAsPerm, 
    "for a ramified polygonal surface with OrientationByVerticesAsList",
    [IsRamifiedPolygonalSurface and HasOrientationByVerticesAsList],
    function( ramSurf )
        return __SIMPLICIAL_TranslateListsIntoCycles( 
                OrientationByVerticesAsList(ramSurf) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "OrientationByVerticesAsPerm", "OrientationByVerticesAsList" );


################################
##
##  VerticesAsList
##
InstallMethod( OrientationByVerticesAsList,
    "for a ramified polygonal surface with OrientationByVerticesAsPerm",
    [ IsRamifiedPolygonalSurface and HasOrientationByVerticesAsPerm ],
    function( ramSurf )
        return __SIMPLICIAL_TranslateCyclesIntoLists(
            OrientationByVerticesAsPerm(ramSurf)  );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "OrientationByVerticesAsList", "OrientationByVerticesAsPerm");

InstallMethod( OrientationByVerticesAsList,
    "for a ramified polygonal surface with OrientationByEdgesAsList, Faces, VerticesOfEdges and VerticesOfFaces",
    [ IsRamifiedPolygonalSurface and HasOrientationByEdgesAsList and HasFaces and HasVerticesOfEdges and HasVerticesOfFaces ],
    function( ramSurf )
        return __SIMPLICIAL_ConversionListsVerticesEdges(
            OrientationByEdgesAsList(ramSurf),
            Faces(ramSurf),
            VerticesOfEdges(ramSurf),
            VerticesOfFaces(ramSurf) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "OrientationByVerticesAsList", 
    ["OrientationByEdgesAsList", "Faces", "VerticesOfEdges", "VerticesOfFaces"]);


##############################
##
##  EdgesAsPerm
##
InstallMethod( OrientationByEdgesAsPerm,
    "for a ramified polygonal surface with OrientationByEdgesAsList",
    [ IsRamifiedPolygonalSurface and HasOrientationByEdgesAsList ],
    function(ramSurf)
        return __SIMPLICIAL_TranslateListsIntoCycles(
            OrientationByEdgesAsList(ramSurf) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "OrientationByEdgesAsPerm", "OrientationByEdgesAsList" );


################################
##
##  EdgesAsList
##
InstallMethod( OrientationByEdgesAsList, 
    "for a ramified polygonal surface with OrientationByEdgesAsPerm",
    [IsRamifiedPolygonalSurface and HasOrientationByEdgesAsPerm],
    function(ramSurf)
        return __SIMPLICIAL_TranslateCyclesIntoLists(
            OrientationByEdgesAsPerm(ramSurf) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "OrientationByEdgesAsList", "OrientationByEdgesAsPerm");


InstallMethod( OrientationByEdgesAsList,
    "for a ramified polygonal surface with OrientationByVerticesAsList and Faces and EdgesOfVertices and EdgesOfFaces",
    [IsRamifiedPolygonalSurface and HasOrientationByVerticesAsList and HasFaces and HasEdgesOfVertices and HasEdgesOfFaces],
    function(ramSurf)
        return __SIMPLICIAL_ConversionListsVerticesEdges(
            OrientationByVerticesAsList(ramSurf),
            Faces(ramSurf),
            EdgesOfVertices(ramSurf),
            EdgesOfFaces(ramSurf) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "OrientationByEdgesAsList",
    ["OrientationByVerticesAsList", "Faces", "EdgesOfVertices", "EdgesOfFaces"]);


##
## Special case if the orientability is known
##
InstallMethod( OrientationByVerticesAsList, 
    "for a ramified polygonal surface with known orientation",
    [IsRamifiedPolygonalSurface and HasIsOrientable],
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
InstallMethod( IsOrientable,
    "for a ramified polygonal surface with OrientationByVerticesAsPerm",
    [IsRamifiedPolygonalSurface and HasOrientationByVerticesAsPerm],
    function(ramSurf)
        return OrientationByVerticesAsPerm(ramSurf) <> fail;
    end
);

## If we can't compute IsOrientable any other way, we try computing a global
## orientation first
InstallMethod( IsOrientable,
    "for a ramified polygonal surface",
    [IsRamifiedPolygonalSurface],
    function(ramSurf)
        if HasOrientationByVerticesAsPerm(ramSurf) then
            TryNextMethod();
        fi;
        OrientationByVerticesAsPerm(ramSurf);
        return IsOrientable(ramSurf);
    end
);

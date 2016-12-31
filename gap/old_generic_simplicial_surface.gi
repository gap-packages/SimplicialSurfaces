################################################################################
##
#W  generic_simplicial_surface.gi   Generic Simplicial Surface   Alice Niemeyer
#W															  Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##
##  The functions in this file compute with generic simplicial surfaces.
##
##	A generic simplicial surface consists of the following data:
##	1) The list of vertices
##	2) The list of edges
##	3) The list of faces
##	4) For each edge: A list of the two incident vertices
##	5) For each face: A list of the three incident edges
##		The order or these three edges defines the orientation of this face.
##



#############################################################################
##
##
##  A face vertex path is a list of lists. Each sublist describes a face.
##  Let $f$ be such a sublist. Then the entries in $f$ are the numbers of
##  the vertices surrounding the face (whose name is the position number 
##  in the face vertex path) in order. If the 

##  We have to assume that if two faces share a pair of vertices, they
##  share an edge.
##
##
##     f1         f2       f3
## [v2,v3,v4] [v2,v3,v4] [v5,v4,v3]
## [v1,v2],  [e1,e2,e3]
InstallGlobalFunction( GenericSimplicialSurfaceFromFaceVertexPath,
function( fvp )

	local nrOfFaces, faces,edges,i,newfaces,j,e;

	# The length of fvp is equal to the number of faces
	nrOfFaces := Length(fvp);

	faces := [1..Length(fvp)];
	faces := List( faces, i -> Set(Combinations( Set(fvp[i]) ,2)) );
	edges := Union(faces);

	newfaces := List(faces,i->[]);
	for i in [1..Length(fvp)] do
		for j  in [1..3] do
				e := faces[i][j];
			newfaces[i][j] := Position(edges,e);
		od;
	od;

	return GenericSimplicialSurface( rec(
		nrOfVertices := Length(Set(Flat(edges))),
		nrOfEdges := Length(edges),
		nrOfFaces := nrOfFaces,
		edges := edges,
		faces := newfaces ) );
end
);


#############################################################################
##
##  Compute the face vertex path description of a generic surface
##
## [v1,v2],  [e1,e2,e3]


InstallGlobalFunction( FaceVertexPathFromGenericSimplicialSurface,
function( surf )

        local fvp, f, fv, e,facesByVertices;

	facesByVertices := FacesByVerticesOfGenericSimplicialSurface( surf );

        fvp := [];
        
        for f in facesByVertices do
            fv := f;
	    Add( fv, fv[1] );
            Add( fvp, fv );
        od;

        return fvp;

end
);


##############################################################
## The next methods are used for the conversion from
## wild simplicial surface to generic simplicial surface
#############################################################

# Check whether a given vertex ist incident to a given edge
IsIncidentVertexEdge := function(simpsurf,vertexNumber,edgeColor,edgeNumber)
	local vert, edgeType, edges;

    edges := EdgesOfWildSimplicialSurface(simpsurf);

	for vert in VerticesOfWildSimplicialSurface(simpsurf)[vertexNumber] do
		for edgeType in [vert[2],vert[3]] do
			if edgeType = edgeColor and 
               vert[1] in edges[edgeColor][edgeNumber] then
				return true;
			fi;
		od;
	od;

	return false;
end;

# Return the vertices (as numbers) that are incident to the given edge
VerticesInEdgeAsNumbers := function( simpsurf, edgeColor, edgeNumber )
	local erg,i;

	erg := [];
	for i in [1..NrOfVerticesOfWildSimplicialSurface(simpsurf)] do
		if IsIncidentVertexEdge( simpsurf, i, edgeColor, edgeNumber ) then
			erg := Union( erg, [i]);
		fi;
	od;

	return erg;
end;

# Return the vertices (as data in the record) that are incident to 
#  the given edge
VerticesInEdge := function( simpsurf, edgeColor, edgeNumber )
	return List( VerticesInEdgeAsNumbers(simpsurf,edgeColor,edgeNumber), 
                  i-> VerticesOfWildSimplicialSurface(simpsurf)[i]);
end;



# Convert the simplicial surface data structure to a generic simplicial surface
# WARNING! It is instrumental at this point that the faces are numbered 1,2,...,f
InstallGlobalFunction( GenericSimplicialSurfaceFromWildSimplicialSurface,
    function( simpsurf )
	local erg, edges, edgeColor, edgeNumber, pos, faces, faceNumber, 
          edgesInFace, sedges;

	erg := [];

	# First entry is number of vertices
	erg[1] := NrOfVerticesOfWildSimplicialSurface(simpsurf);
	
	# Second entry is number of edges
	erg[2] := NrOfEdgesOfWildSimplicialSurface(simpsurf);

	# Third entry is number of faces
	erg[3] := NrOfFacesOfWildSimplicialSurface(simpsurf);

	# The fourth entry is a list. Each entry of this list corresponds to 
        # an edge and equals a list of the vertices contained in that edge
	edges := [];
    sedges := EdgesOfWildSimplicialSurface(simpsurf);
	for edgeColor in [1..Length(sedges)] do
		for edgeNumber in [1..Length(sedges[edgeColor])] do
			pos := (edgeColor - 1) * Length( sedges[edgeColor] ) + edgeNumber;
			edges[pos] := VerticesInEdgeAsNumbers(simpsurf,edgeColor,edgeNumber);
		od;
	od;
	erg[4] := edges;

	# The fifth entry is also a list, corresponding to the faces. 
        # Each entry is a list containing the edges of this face
	faces := [];
	for faceNumber in FacesOfWildSimplicialSurface(simpsurf) do
		edgesInFace := [];
		for edgeColor in [1..Length(sedges)] do
			for edgeNumber in [1..Length(sedges[edgeColor])] do
				if faceNumber in sedges[edgeColor][edgeNumber] then
					pos := (edgeColor - 1) * Length( sedges[edgeColor] ) 
                            + edgeNumber;
					Add( edgesInFace, pos );
				fi;
			od;
		od;
		faces[ faceNumber ] := edgesInFace;
	od;
	erg[5] := faces;

	# WARNING! Both loops use the same convention for converting 
        #  edgeColor and edgeNumber.

	return GenericSimplicialSurface( rec(
		nrOfVertices := erg[1],
		nrOfEdges := erg[2],
		nrOfFaces := erg[3],
		edges := erg[4],
		faces := erg[5] ) );
end
);



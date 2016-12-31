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


##
##	Declare the representation of generic simplicial surfaces.
##
##
DeclareRepresentation("IsGenericSimplicialSurfaceRep", IsSimplicialSurface,
	[ "vertices", "edges", "faces", "edgesByVertices", "facesByEdges" ] );


#############################################################################
##
##  The following functions only access the generic simplicial surface and
##  return known information about the generic simplicial surface <simpsurf>.
## 

#############################################################################
##
#!	@Description
#!	This function returns the numbers of the vertices as a dense list.
#!	@Returns a dense list of integers
#!	@Arguments a generic simplicial surface object generic
#!
InstallMethod( Vertices, "for a generic simplicial surface",
	[IsGenericSimplicialSurfaceRep],
	function( generic )
		return generic!.vertices;
	end
);

#############################################################################
##
#!	@Description
#!	This function returns the numbers of the edges as a dense list.
#!	@Returns a dense list of integers
#!	@Arguments a generic simplicial surface object generic
#!
InstallMethod( Edges, "for a generic simplicial surface",
	[IsGenericSimplicialSurfaceRep],
	function( generic )
		return generic!.edges;
	end
);

#############################################################################
##
#!	@Description
#!	This function returns the numbers of the faces as a dense list.
#!	@Returns a dense list of integers
#!	@Arguments a generic simplicial surface object generic
#!
InstallMethod( Faces, "for a generic simplicial surface",
	[IsGenericSimplicialSurfaceRep],
	function( generic )
		return generic!.faces;
	end
);

#############################################################################
##
#!	@Description
#!	This function returns the edges in terms of the vertices. It return a list
#!	with holes and at the position of each edge-number there is a list of
#!	all vertices that are incident to that edge. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
InstallMethod( EdgesByVertices, "for a generic simplicial surface",
	[IsGenericSimplicialSurfaceRep],
	function( simpsurf )
		return simpsurf!.edgesByVertices;
	end
);

#############################################################################
##
#!	@Description
#!	This function returns the faces in terms of the edges. It return a list
#!	with holes and at the position of each face-number there is a list of
#!	all edges that are incident to that face. All other positions are
#!	unbounded.
#!	@Returns a list of lists of integers
#!	@Arguments a generic simplicial surface object simpsurf
InstallMethod( FacesByEdges, "for a generic simplicial surface",
	[IsGenericSimplicialSurfaceRep],
	function( simpsurf )
		return simpsurf!.facesByEdges;
	end
);




# TODO SnippOffEars
# TODO guarantee well-defined-ness




###############################################################################
##
#!  @Description
#!  This function removes one vertex of a generic simplicial surface
#!  <simpsurf>, along with all edges and faces that are adjacent to the vertex
#!  @Returns a generic simplicial surface without the given vertex.
#!  @Arguments <simpsurf> a generic simplicial surface, <vertex> the vertex to
#!		 be removed
#!
##
InstallGlobalFunction( RemoveVertexOfGenericSimplicialSurface,
function( simpsurf, vertex )
	local newVertexNr, newEdgeNr, newFaceNr, newEdges, newFaces, replaceEdges, 
		currentNr, edge, el, newEdge;

	if not vertex in [1..NrOfVerticesOfGenericSimplicialSurface(simpsurf)] then
		Error("RemoveVertexOfGenericSimplicialSurface: The given vertex doesn't lie in the surface.");
	fi;

	newVertexNr := NrOfVerticesOfGenericSimplicialSurface(simpsurf) - 1;
	
	# Check all edges
	replaceEdges := [];	# Map from old numbers to new numbers (contains fail if edge vanishes)
	newEdges := [];
	currentNr := 0;		# Numbering of the new edges
	for edge in [1..NrOfEdgesOfGenericSimplicialSurface(simpsurf)] do
		if vertex in EdgesOfGenericSimplicialSurface(simpsurf)[edge] then
			replaceEdges[edge] := fail;
		else
			newEdge := [];
			# Shift higher vertices down
			for el in EdgesOfGenericSimplicialSurface(simpsurf)[edge] do	
				if el < vertex then
					Append( newEdge, [el] );
				else
					Append( newEdge, [el-1] );
				fi;
			od;
			Append( newEdges, [newEdge] );
			currentNr := currentNr + 1;
			replaceEdges[edge] := currentNr;
		fi;
	od;
	newEdgeNr := Length( newEdges );

	# Check all faces
	newFaces := List( FacesOfGenericSimplicialSurface(simpsurf), 
						face -> List( face, i -> replaceEdges[i] ) );
	newFaces := Filtered( newFaces, face -> not fail in face);
	newFaceNr := Length( newFaces );

	return GenericSimplicialSurface( rec(
		nrOfVertices := newVertexNr,
		nrOfEdges := newEdgeNr,
		nrOfFaces := newFaceNr,
		edges := newEdges,
		faces := newFaces ) );
end
);


###############################################################################
##
#!  @Description
#!  This function recursively removes ears of a generic simplicial surface
#!  <simpsurf>. An ear is a face with one vertex that only lies in that face.
#!  @Returns a generic simplicial surface without ears.
#!  @Arguments <simpsurf> a generic simplicial surface
#!
InstallGlobalFunction( SnippOffEarsOfGenericSimplicialSurface,
function( simpsurf )
	local vertexDegree, ears, newSurface, ear;

	# Find ears
	vertexDegree := UnsortedDegreesOfGenericSimplicialSurface( simpsurf );
	ears := Filtered( [1..NrOfVerticesOfGenericSimplicialSurface(simpsurf)], 
							i -> vertexDegree[i] <= 1);

	if IsEmpty( ears ) then
		return simpsurf;
	fi;
	
	# Remove the ears
	newSurface := simpsurf;
		# Start with the highest ear so that others are not affected
	for ear in Reversed( ears ) do	
		newSurface := RemoveVertexOfGenericSimplicialSurface( newSurface, ear);
	od;

	# Repeat as needed
	return SnippOffEarsOfGenericSimplicialSurface( newSurface );
end
);

InstallMethod( SnippOffEars, "for a simplicial surfaces", true, 
	[ IsGenericSimplicialSurfaceRep ], 0,
	SnippOffEarsOfGenericSimplicialSurface);

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



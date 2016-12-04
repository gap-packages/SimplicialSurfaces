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
##	1) The number of vertices
##	2) The number of edges
##	3) The number of faces
##	4) For each edge: A list of the two incident vertices
##	5) For each face: A list of the three indicent edges
##		The order or these three edges defines the orientation of this face.
##



##
##  The constructor GenericSimplicialSurface ensures that the simplicial surface
##  is stored inside a GAP object. 
##
GenericSimplicialSurface :=  function( simpsurf ) 
    
    return Objectify( GenericSimplicialSurfaceType, simpsurf );

end;

##
## Constructor that uses a list to initialize.
##
InstallGlobalFunction( GenericSimplicialSurfaceByList,
function( list )
	return GenericSimplicialSurface( rec(
		nrOfVertices := list[1],
		nrOfEdges := list[2],
		nrOfFaces := list[3],
		edges := list[4],
		faces := list[5] ) );
end
);



#############################################################################
##
##  The following functions only access the generic simplicial surface and
##  return known information about the generic simplicial surface <simpsurf>.
## 

#############################################################################
##
##
#!  @Description
#!  This function returns the list of faces of a generic simplicial surface.
#!  @Returns a list
#!  @Arguments simpsurf
#!
InstallGlobalFunction(FacesOfGenericSimplicialSurface,
function( simpsurf)

        if not IsGenericSimplicialSurfaceRep(simpsurf) then
            Error("usage: FacesOfGenericSimplicialSurface(simpsurf)");
            return fail;
        fi;
        return simpsurf!.faces;

end
);

#############################################################################
##
##
#!  @Description
#!  This function returns the number of faces of a generic simplicial surface.
#!  @Returns an integer
#!  @Arguments simpsurf
#!
InstallGlobalFunction(NrOfFacesOfGenericSimplicialSurface,
function (simpsurf)

		if not IsGenericSimplicialSurfaceRep(simpsurf) then
            Error("usage: NrOfFacesOfGenericSimplicialSurface(simpsurf)");
            return fail;
        fi;
        return simpsurf!.nrOfFaces;

end
);
InstallMethod( NrOfFaces, "for a simplicial surfaces", true, 
	[ IsSimplicialSurface and IsGenericSimplicialSurfaceRep ], 0,
	NrOfFacesOfGenericSimplicialSurface);

#############################################################################
##
##
#!  @Description
#!  This function returns the list of edges of a generic simplicial surface.
#!  @Returns a list
#!  @Arguments simpsurf
#!
InstallGlobalFunction(EdgesOfGenericSimplicialSurface,
function( simpsurf)

        if not IsGenericSimplicialSurfaceRep(simpsurf) then
            Error("usage: EdgesOfGenericSimplicialSurface(simpsurf)");
            return fail;
        fi;
        return simpsurf!.edges;

end
);

#############################################################################
##
##
#!  @Description
#!  This function returns the number of edges of a generic simplicial surface.
#!  @Returns an integer
#!  @Arguments simpsurf
#!
InstallGlobalFunction(NrOfEdgesOfGenericSimplicialSurface,
function( simpsurf)

       if not IsGenericSimplicialSurfaceRep(simpsurf) then
            Error("usage: NrOfEdgesOfGenericSimplicialSurface(simpsurf)");
            return fail;
        fi;
        return simpsurf!.nrOfEdges;

end
);
InstallMethod( NrOfEdges, "for a simplicial surfaces", true, 
	[ IsSimplicialSurface and IsGenericSimplicialSurfaceRep ], 0,
	NrOfEdgesOfGenericSimplicialSurface);

#############################################################################
##
##
#!  @Description
#!  This function returns the list of vertices of a  simplicial surface.
#!  @Returns a list
#!  @Arguments simpsurf
#!
InstallGlobalFunction(VerticesOfGenericSimplicialSurface,
function( simpsurf)

        if not IsGenericSimplicialSurfaceRep(simpsurf) then
            Error("usage: VerticesOfGenericSimplicialSurface(simpsurf)");
            return fail;
        fi;
        return [1..simpsurf!.nrOfVertices];

end
);

#############################################################################
##
##
#!  @Description
#!  This function returns the number of vertices of a generic simplicial
#!	surface.
#!  @Returns an integer
#!  @Arguments simpsurf
#!
InstallGlobalFunction(NrOfVerticesOfGenericSimplicialSurface,
function( simpsurf)

        if not IsGenericSimplicialSurfaceRep(simpsurf) then
            Error("usage: NrOfVerticesOfGenericSimplicialSurface(simpsurf)");
            return fail;
        fi;
        return simpsurf!.nrOfVertices;

end
);
InstallMethod( NrOfVertices, "for a simplicial surfaces", true, 
	[ IsSimplicialSurface and IsGenericSimplicialSurfaceRep ], 0,
	NrOfVerticesOfGenericSimplicialSurface);


############################################################################
##
#! @Description
#! This function returns the faces of the generic simplicial surface with
#! respect to their vertices. The implicit orientation that is given
#! through the edges will be represented here as well.
#! @Returns a list of lists of integers, for each face a list of the
#! contained vertices.
#! @Arguments <simpsurf>, a generic simplicial surface
#!
InstallGlobalFunction( FacesByVerticesOfGenericSimplicialSurface,
function( simpsurf )
	local faceList, i, face,intersectingEdges,vertices,j,edges;

	if IsBound(simpsurf!.facesByVertices) then
            return simpsurf!.facesByVertices;
        fi;

	edges := EdgesOfGenericSimplicialSurface(simpsurf);

	faceList := [];
	for i in [1 .. NrOfFacesOfGenericSimplicialSurface(simpsurf)] do
		face := FacesOfGenericSimplicialSurface(simpsurf)[i];
		vertices := [];

		# Intersect first and last edge to obtain first vertex
		intersectingEdges := Intersection( Set( edges[face[1]] ), 
										Set( edges[face[Length(face)]] ) );
		if Length(intersectingEdges) <> 1 then
       		Error("FacesByVerticesOfGenericSimplicialSurface: Edge intersection is not unique.");
		fi;
		vertices[1] := intersectingEdges[1];

		# Continue in the same way for the other edges
		for j in [2 .. Length(face)] do
			intersectingEdges := Intersection( Set( edges[face[j-1]] ),
												Set( edges[face[j]] ) );
			if Length(intersectingEdges) <> 1 then
       			Error("FacesByVerticesOfGenericSimplicialSurface: Edge intersection is not unique.");
			fi;
			vertices[j] := intersectingEdges[1];
		od;

		faceList[i] := vertices;
	od;

	simpsurf!.facesByVertices := faceList;
	return faceList;
end
);


############################################################################
##
#! @Description
#! This function returns for each edge of the generic simplicial surface
#! a set of all adjacent faces.
#! @Returns a list of sets of integers, for each edge a list of the
#! adjacent faces.
#! @Arguments <simpsurf>, a generic simplicial surface
#!
InstallGlobalFunction( EdgesByFacesOfGenericSimplicialSurface,
function( simpsurf )
	local edgeList, edge, faceSet, face;

	if IsBound( simpsurf!.edgesByFaces ) then
		return simpsurf!.edgesByFaces;
	fi;

	edgeList := [];
	for edge in [1..NrOfEdgesOfGenericSimplicialSurface(simpsurf)] do
		faceSet := [];
		for face in [1..NrOfFacesOfGenericSimplicialSurface(simpsurf)] do
			if edge in FacesOfGenericSimplicialSurface(simpsurf)[face] then
				faceSet := Union( faceSet, [face] );
			fi;
		od;
		edgeList[edge] := faceSet;
	od;

	simpsurf!.edgesByFaces := edgeList;
	return simpsurf!.edgesByFaces;
end
);


#############################################################################
##
#!  @Description
#!  This function computes the face-degrees of the vertices of the simplicial 
#!  surface <simpsurf>.
#!  The face-degree of a vertex is the number of faces incident to the vertex.
#!  @Returns a list of integers, containing for each
#!  vertex of the simplicial suface its degree
#!  @Arguments <simpsurf>, a simplicial surface object as created 
#!  by SimplicialSurface
#!
InstallGlobalFunction( UnsortedDegreesOfGenericSimplicialSurface,
function(simpsurf)

        local degrees, i, faces,j, deg,vertexNr;

		if IsBound( simpsurf!.UnsortedDegrees ) then
			return simpsurf!.UnsortedDegrees;
		fi;

		faces := FacesByVerticesOfGenericSimplicialSurface(simpsurf);
		vertexNr := NrOfVerticesOfGenericSimplicialSurface(simpsurf);
		degrees := List( [1 .. vertexNr], i -> Number( faces, j -> i in j ) );

        simpsurf!.UnsortedDegrees := degrees;

        return degrees;
end
);

#############################################################################
##
#!  @Description
#!  This function computes the face-degrees of the vertices of the simplicial 
#!  surface <simpsurf> and returns them sorted.
#!  The face-degree of a vertex is the number of faces incident to the vertex.
#!  @Returns a list of integers in increasing order, containing for each
#!  vertex of the simplicial suface its degree
#!  @Arguments <simpsurf>, a simplicial surface object as created 
#!  by SimplicialSurface
#!
InstallGlobalFunction( SortedDegreesOfGenericSimplicialSurface,
function(simpsurf)
		local degrees;

		if IsBound( simpsurf!.SortedDegrees) then
			return simpsurf!.SortedDegrees;
		fi;

		degrees := UnsortedDegreesOfGenericSimplicialSurface( simpsurf );
		Sort( degrees );
		simpsurf!.SortedDegrees := degrees;
        return degrees;
end
);


#############################################################################
##
#!  @Description
#!  Check if two generic simplicial surfaces are equal.
#!  @Returns true or false
#!  @Arguments <s1>, <s2>, two generic simplicial surface objects as created 
#!  by SimplicialSurface
#!
##
InstallMethod( \=, "for two generic simplicial surfaces", true, 
  [ IsGenericSimplicialSurfaceRep, IsGenericSimplicialSurfaceRep ], 0, 
		function( s1, s2 )

		if NrOfVerticesOfGenericSimplicialSurface(s1) <> 
			NrOfVerticesOfGenericSimplicialSurface(s2) then
			return false;
		fi;
		if NrOfEdgesOfGenericSimplicialSurface(s1) <> 
			NrOfEdgesOfGenericSimplicialSurface(s2) then
			return false;
		fi;
		if NrOfFacesOfGenericSimplicialSurface(s1) <> 
			NrOfFacesOfGenericSimplicialSurface(s2) then
			return false;
		fi;

		if EdgesOfGenericSimplicialSurface(s1) <> 
			EdgesOfGenericSimplicialSurface(s2) then
			return false;
		fi;
		if FacesOfGenericSimplicialSurface(s1) <> 
			FacesOfGenericSimplicialSurface(s2) then
			return false;
		fi;

        return true;

end);



#############################################################################
##
##  A Print method for generic simplicial surfaces
##

PrintGenericSimplicialSurface := function(simpsurf)

        Print("GenericSimplicialSurface( rec(\n");
        Print("nrOfVertices := ");
        Print(simpsurf!.nrOfVertices, ",\n");
        Print("nrOfEdges := ");
        Print(simpsurf!.nrOfEdges, ",\n");
        Print("nrOfFaces := ");
        Print(simpsurf!.nrOfFaces, ",\n");
        Print("edges := ");
        Print(simpsurf!.edges, ",\n");
        Print("faces := ");
        Print(simpsurf!.faces, "));\n");
end;

InstallMethod( PrintObj, "for GenericSimplicialSurface", true, 
               	[ IsGenericSimplicialSurfaceRep ], 0, 
				PrintGenericSimplicialSurface );


#############################################################################
##
##  A Display method for simplicial surfaces
##
DisplayGenericSimplicialSurface := function(simpsurf)

        Print("Number of vertices: ", simpsurf!.nrOfVertices, ",\n");
        Print("Number of edges: ", simpsurf!.nrOfEdges, ",\n");
        Print("Number of faces: ", simpsurf!.nrOfFaces, ",\n");
        Print("Edges: ", simpsurf!.edges, ",\n");
        Print("Faces: ", simpsurf!.faces);

end;

InstallMethod( Display, "for GenericSimplicialSurfaces", true, 
                   [IsGenericSimplicialSurfaceRep], 0, 
					DisplayGenericSimplicialSurface );

#############################################################################
##
#!  @Description
#!  Return the coloured incidence graph of a generic simplicial surface.
#!	The vertex set of this graph consists of all vertices, edges and faces
#!	of the generic simplicial surface. All vertices, all edges and all faces
#!	are in individual colour classes.
#!  @Returns the coloured incidence graph
#!  @Arguments <simpsurf>, a generic simplicial surface object as created 
#!  by GenericSimplicialSurface
#!
##
InstallGlobalFunction( IncidenceGraphOfGenericSimplicialSurface,
function( simpsurf )
	local graph, vertices, edges, faces, names, colours, incidence, 
		trivialAction;

	if IsBound( simpsurf!.incidenceGraph ) then
		return simpsurf!.incidenceGraph;
	fi;

	vertices := List( [1..NrOfVerticesOfGenericSimplicialSurface(simpsurf)],
							i -> [0,i] );
	edges := List( [1..NrOfEdgesOfGenericSimplicialSurface(simpsurf)], 
							i -> [1,i] );
	faces := List( [1..NrOfFacesOfGenericSimplicialSurface(simpsurf)], 
							i -> [2,i] );

	names := Union( vertices, edges, faces);
	colours := [vertices,edges, faces];
	incidence := function(x,y)
		if x[1] = 0 and y[1] = 1 then
			return x[2] in EdgesOfGenericSimplicialSurface(simpsurf)[y[2]];
		elif x[1] = 1 and y[1] = 0 then
			return y[2] in EdgesOfGenericSimplicialSurface(simpsurf)[x[2]];

		elif x[1] = 1 and y[1] = 2 then
			return x[2] in FacesOfGenericSimplicialSurface(simpsurf)[y[2]];
		elif x[1] = 2 and y[1] = 1 then
			return y[2] in FacesOfGenericSimplicialSurface(simpsurf)[x[2]];

		else
			return false;
		fi;
	end;

	trivialAction := function( pnt, g )
		return pnt;
	end;

	graph := Graph( Group( () ), names, trivialAction, incidence );
	graph!.colourClasses := colours;

	simpsurf!.incidenceGraph := graph;
	return graph;
end
);

#############################################################################
##
#!  @Description
#!  Check if two generic simplicial surfaces are isomorphic.
#!  @Returns true or false
#!  @Arguments <s1>, <s2>, two generic simplicial surface objects as created 
#!  by GenericSimplicialSurface
#!
##
InstallGlobalFunction( IsIsomorphicGenericSimplicialSurface,
function( s1,s2)
	local graph1, graph2;

	graph1 := IncidenceGraphOfGenericSimplicialSurface(s1);
	graph2 := IncidenceGraphOfGenericSimplicialSurface(s2);
	return IsIsomorphicGraph(graph1,graph2);
end
);


#############################################################################
##
#!  @Description
#!  Check if a generic simplicial surfaces is connected.
#!  @Returns true or false
#!  @Arguments <simpsurf>, a generic simplicial surface object as created 
#!  by GenericSimplicialSurface
#!
##
InstallGlobalFunction( IsConnectedGenericSimplicialSurface,
function(simpsurf)
	local faces, faceList, points, change, faceNr;

	if IsBound( simpsurf!.isConnected ) then 
		return simpsurf!.isConnected;
	fi;

	faceList := FacesByVerticesOfGenericSimplicialSurface(simpsurf);
	faces := [2..NrOfFacesOfGenericSimplicialSurface(simpsurf)];
	points := Set( faceList[1] );

	change := true;
	while change do
		change := false;

		for faceNr in faces do
			if Intersection( points, faceList[faceNr] ) <> [] then
				change := true;
				points := Union( points, faceList[faceNr] );
				faces := Difference( faces, [faceNr] );
			fi;
		od;
	od;

	simpsurf!.isConnected := IsEmpty( faces );

	return simpsurf!.isConnected;
end
);
InstallMethod( IsConnected, "for a simplicial surfaces", true, 
	[ IsSimplicialSurface and IsGenericSimplicialSurfaceRep ], 0,
	IsConnectedGenericSimplicialSurface);


###############################################################################
##
#!  @Description
#!  This function checks whether the generic simplicial surface is an actual
#!	surface.
#!  @Returns true if it is a surface and false else.
#!  @Arguments <simpsurf> a generic simplicial surface
#!
InstallGlobalFunction( IsActualSurfaceGenericSimplicialSurface,
function( simpsurf )
	local face, edgeByFaces, check;

	if IsBound( simpsurf!.isActualSurface ) then
		return simpsurf!.isActualSurface;
	fi;

	check := true;
	edgeByFaces := EdgesByFacesOfGenericSimplicialSurface( simpsurf );
	check := Filtered( edgeByFaces, i -> Length(i) > 2 );
	
	simpsurf!.isActualSurface := IsEmpty(check) ;
	return simpsurf!.isActualSurface;
end
);
InstallMethod( IsActualSurface, "for a simplicial surfaces", true, 
	[ IsSimplicialSurface and IsGenericSimplicialSurfaceRep ], 0,
	IsActualSurfaceGenericSimplicialSurface);


###############################################################################
##
#!  @Description
#!  This function decides whether the generic simplicial surface
#!  <simpsurf> is orientable. To that end it has to be an actual surface.
#!  @Returns true if the surface is orientable and false else.
#!  @Arguments <simpsurf> a simplicial surface
#!
InstallGlobalFunction(IsOrientableGenericSimplicialSurface,
function( simpsurf )
	local edgesByFaces, facesByVertices, orientList, i, hole, edge,
		 facesToCheck, checkedFaces, CompatibleOrientation, orient1,
		 orient2, orientable, face, neighbours, next;

	if not IsActualSurfaceGenericSimplicialSurface(simpsurf) then
		Error( "IsOrientableGenericSimplicialSurface: not an actual surface given." );
	fi;
	if IsBound( simpsurf!.isOrientable ) then
		return simpsurf!.isOrientable;
	fi;

	edgesByFaces := EdgesByFacesOfGenericSimplicialSurface(simpsurf);
	facesByVertices := FacesByVerticesOfGenericSimplicialSurface(simpsurf);

	# Method to check if the orientation of a face is induced by that of one of
	# its edges
	CompatibleOrientation := function( edgeByVertices, faceByVertices )
		local pos;

		pos := Position( faceByVertices, edgeByVertices[1] );
		if pos = fail then
			Error( "IsOrientableGenericSimplicialSurface: Incompatible Orientation" );
		fi;
		if pos < Length( faceByVertices ) then
			return edgeByVertices[2] = faceByVertices[pos+1];
		else
			return edgeByVertices[2] = faceByVertices[1];
		fi;
	end;

	orientable := true;
	orientList := [];
	orientList[ 1 + NrOfFacesOfGenericSimplicialSurface(simpsurf)] := 1;
	while not IsDenseList( orientList ) and orientable do
		# Find the first hole
		hole := 0;
		for i in [1..Length(orientList)] do
			if not IsBound( orientList[i] ) then
				hole := i;
				break;
			fi;
		od;

		# Define the standard orientation of this face as "up"
		orientList[hole] := 1;
		facesToCheck := [hole];
		checkedFaces := [];

		while facesToCheck <> [] and orientable do
			face := facesToCheck[1];
			for edge in FacesOfGenericSimplicialSurface(simpsurf)[face] do
				# This should be unique (inner edge) or empty (border edge)
				neighbours := Difference( edgesByFaces[edge], [face] );
				if Size( neighbours ) > 1 then
					Error( "IsOrientableGenericSimplicialSurface: Not a proper surface.");
				elif Size( neighbours ) = 0 then
					continue;
				fi;
				next := neighbours[1];

				# Check how these two faces act on the edge
				if CompatibleOrientation( EdgesOfGenericSimplicialSurface(simpsurf)[edge], facesByVertices[face] ) then
					orient1 := 1;
				else
					orient1 := -1;
				fi;

				if CompatibleOrientation( EdgesOfGenericSimplicialSurface(simpsurf)[edge], facesByVertices[next] ) then
					orient2 := 1;
				else
					orient2 := -1;
				fi;

				if orient1*orient2 = -1 then # the sides are neighbours
					if IsBound( orientList[next] ) and orientList[next] <> orientList[face] then
						orientable := false;
						break;
					else
						orientList[next] := orientList[face];
					fi;
				elif orient1*orient2 = 1 then # the sides are not neighbours
					if IsBound( orientList[next] ) and orientList[next] = orientList[face] then
						orientable := false;
						break;
					else
						orientList[next] := -1*orientList[face];
					fi;
				else
					Error( "IsOrientableGenericSimplicialSurface: Wrong definition of orientation.");
				fi;

				if not next in checkedFaces then
					facesToCheck := Union( facesToCheck, [next] );
				fi;
			od;
			facesToCheck := Difference( facesToCheck, [face] );
			checkedFaces := Union( checkedFaces, [face] );
		od;
	od;
	
	simpsurf!.isOrientable := orientable;
	return simpsurf!.isOrientable;
end
);
InstallMethod( IsOrientable, "for a simplicial surfaces", true, 
	[ IsSimplicialSurface and IsGenericSimplicialSurfaceRep ], 0,
	IsOrientableGenericSimplicialSurface);


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
							i -> vertexDegree[i] = 1);

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
	[ IsSimplicialSurface and IsGenericSimplicialSurfaceRep ], 0,
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



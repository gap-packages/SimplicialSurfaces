####################################################################################################################
##
## modifying_simplicial_surfaces.g 				Jesse Lansdown
##
##
## Method 1 (SplitFaceByDivision): Add a new face by dividing an existing face. A new vertex is added
## to one side of the face, and an edge is added which contains this vertex and the vertex of the face opposite it.
## Note that this deforms one of the neighbouring faces (if the edge is an inner edge).
## 
##    /|\
##   / | \
##  /  |  \
## /___|___\
##
## Method 2 (SplitFaceByTriangleInsertion): Three new vertices are added, one to each edge.
## Each vertex is then joined to each of the other vertices by three new edges. Four new faces are formed.
## Note that this deforms up to three of the neighbouring faces (for any inner edge of the given face).
##
##    /\
##   /__\
##  /\  /\
## /__\/__\
##
## Method 3 (SplitFaceBySpokes): A single new vertex is added in the centre of the face.
## Then three new edges are added, joiningthe new vertex to each of the vertices of the face. 
## Three new faces are formed. Note that this does not deform the neighbouring faces.
## 
##       /|\
##      / | \
##     /  |  \
##    /  / \  \
##   / /     \ \
##  //_________\\
##
##
##################################################################################

DeclareOperation( "SplitFaceBySpokes",
	[ IsSimplicialSurface, IsPosInt] );

InstallMethod(SplitFaceBySpokes, "",
	[ IsSimplicialSurface, IsPosInt] ,
	function(surf, face1)
	# Takes as input a surface and the face to be divided.

		local edge1, edge2, edge3, edge4, edge5, edge6, vertex1, vertex2, vertex3,
		vertex4, newEdgesByVertices, newFacesByEdges, newVertices, newEdges, newFaces;

		if not Size(FacesByEdges(surf)[face1]) = 3 then
			Print("ERROR: Chosen face is not a triangle!");
			return;
		fi;

		edge1 := FacesByEdges(surf)[face1][1];
		edge2 := FacesByEdges(surf)[face1][2];
		edge3 := FacesByEdges(surf)[face1][3];
		edge4 := Maximum(Edges(surf)) + 1;
		edge5 := Maximum(Edges(surf)) + 2;
		edge6 := Maximum(Edges(surf)) + 3;

		vertex1 := Difference(FacesByVertices(surf)[face1], EdgesByVertices(surf)[edge1])[1];
		vertex2 := Difference(EdgesByVertices(surf)[edge3], [vertex1])[1];
		vertex3 := Difference(EdgesByVertices(surf)[edge2], [vertex1])[1];
		vertex4 := Maximum(Vertices(surf)) + 1;

		newEdgesByVertices := List(EdgesByVertices(surf));
		Add(newEdgesByVertices, [vertex1, vertex4]);
		Add(newEdgesByVertices, [vertex2, vertex4]);
		Add(newEdgesByVertices, [vertex3, vertex4]);

		newFacesByEdges := List(FacesByEdges(surf));
		newFacesByEdges[face1] := [edge3, edge4, edge5];
		Add(newFacesByEdges, [edge1, edge5, edge6]);
		Add(newFacesByEdges, [edge2, edge4, edge6]);

		newVertices := List(Vertices(surf));
		Add(newVertices, vertex4);
		newEdges := List(Edges(surf));
		Append(newEdges, [edge4, edge5, edge6]);
		newFaces := List(Faces(surf));
		Append(newFaces, [Maximum(Faces(surf))+1, Maximum(Faces(surf))+2]);

		return SimplicialSurfaceByDownwardIncidence(newVertices, newEdges, newFaces, newEdgesByVertices, newFacesByEdges);
	end
);

DeclareOperation( "SplitFaceByDivision",
	[ IsSimplicialSurface, IsPosInt, IsPosInt, IsPosInt] );

InstallMethod( SplitFaceByDivision, "",
	[ IsSimplicialSurface, IsPosInt, IsPosInt, IsPosInt] ,
	#This is the divide situation
	function(surf, face1, edge1, vertex_used)
		# Takes as input a surface, the face to divide, and the edge which will be split.
		
		local edge2, edge3, edge4, edge5, vertex1, vertex2, vertex3, vertex4, newFacesByEdges, newEdgesByVertices,
		newVertices, newEdges, newFaces, i, adjacentFace;

		if not edge1 in FacesByEdges(surf)[face1] then
			Print("ERROR: Chosen edge is not in chosen face!\n");
			return;
		fi;
		if not Size(FacesByEdges(surf)[face1]) = 3 then
			Print("ERROR: Chosen face is not a triangle!");
			return;
		fi;

		edge2 := Difference(FacesByEdges(surf)[face1], [edge1])[1];
		edge3 := Difference(FacesByEdges(surf)[face1], [edge1])[2];
		edge4 := Maximum(Edges(surf)) + 1;
		edge5 := Maximum(Edges(surf)) + 2;

		vertex1 := Difference(FacesByVertices(surf)[face1], EdgesByVertices(surf)[edge1])[1];
		vertex2 := Difference(EdgesByVertices(surf)[edge3], [vertex1])[1];
		vertex3 := Difference(EdgesByVertices(surf)[edge2], [vertex1])[1];
		vertex4 := Maximum(Vertices(surf)) + 1;

		newFacesByEdges := List(FacesByEdges(surf));
		newEdgesByVertices := List(EdgesByVertices(surf));
		newEdgesByVertices[edge1] := [vertex3, vertex4];
		Add(newEdgesByVertices, [vertex2, vertex4]);
		if vertex_used in [vertex1, vertex4] then
			newFacesByEdges[face1] := [edge1, edge2, edge5];
			Add(newFacesByEdges, [edge3, edge4, edge5]);
			Add(newEdgesByVertices, [vertex1, vertex4]);
		else
			newFacesByEdges[face1] := [edge2, edge3, edge5];
			Add(newFacesByEdges, [edge1, edge4, edge5]);
			Add(newEdgesByVertices, [vertex3, vertex2]);
		fi;

		for i in Difference(EdgesByFaces(surf)[edge1], [face1]) do
			adjacentFace := List(newFacesByEdges[i]);
			newFacesByEdges[i] :=  Union(adjacentFace, [edge4]);
		od;

		newVertices := List(Vertices(surf));
		Add(newVertices, vertex4);
		newEdges := List(Edges(surf));
		Append(newEdges, [edge4, edge5]);
		newFaces := List(Faces(surf));
		Add(newFaces, Maximum(Faces(surf))+1);

		Print(newVertices, newEdges, newFaces, newEdgesByVertices, newFacesByEdges);
		return SimplicialSurfaceByDownwardIncidence(newVertices, newEdges, newFaces, newEdgesByVertices, newFacesByEdges);
	end
);

InstallOtherMethod( SplitFaceByDivision, "",
	[ IsSimplicialSurface, IsPosInt, IsPosInt] ,
	function(surf, face1, edge1)
		# Takes as input a surface, the face to divide, and the edge which will be split.
		local edge2, edge3, vertex1;

		if not edge1 in FacesByEdges(surf)[face1] then
			Print("ERROR: Chosen edge is not in chosen face!\n");
			return;
		fi;
		if not Size(FacesByEdges(surf)[face1]) = 3 then
			Print("ERROR: Chosen face is not a triangle!");
			return;
		fi;

		edge2 := Difference(FacesByEdges(surf)[face1], [edge1])[1];
		edge3 := Difference(FacesByEdges(surf)[face1], [edge1])[2];
		
		vertex1 := Difference(FacesByVertices(surf)[face1], EdgesByVertices(surf)[edge1])[1];
		return SplitFaceByDivision(surf, face1, edge1, vertex1);
	end
);


InstallOtherMethod( SplitFaceByDivision, "",
	[ IsSimplicialSurface, IsPosInt] ,
	function(surf, face1)
		# Takes as input a surface, the face to divide, and the edge which will be split.
		return SplitFaceByDivision(surf, face1, Random(FacesByEdges(surf)[face1]));
	end
);

DeclareOperation( "SplitFaceByTriangleInsertion",
	[ IsSimplicialSurface, IsPosInt ] );

InstallMethod( SplitFaceByTriangleInsertion , "",
	[IsSimplicialSurface, IsPosInt],
	function(surf, face1)
		#Takes as input a surface, the face to be divided and each of the edges of the face.

		local  i, old_edges, edge1, edge2, edge3, edge4, edge5, edge6, edge7, edge8, edge9, vertex1, vertex2, vertex3, vertex4, vertex5, vertex6,
		 newEdgesByVertices, newFacesByEdges, newVertices, newEdges, newFaces, adjacentFace;

		if not Size(FacesByEdges(surf)[face1]) = 3 then
			Print("ERROR: Chosen face is not a triangle!");
			return;
		fi;
		old_edges := Set(FacesByEdges(surf)[face1]);
		edge1 := old_edges[1]; 
		edge2 := old_edges[2];
		edge3 := old_edges[3];

		edge4 := Maximum(Edges(surf)) + 1;
		edge5 := Maximum(Edges(surf)) + 2;
		edge6 := Maximum(Edges(surf)) + 3;
		edge7 := Maximum(Edges(surf)) + 4;
		edge8 := Maximum(Edges(surf)) + 5;
		edge9 := Maximum(Edges(surf)) + 6;


		vertex1 := Difference(FacesByVertices(surf)[face1], EdgesByVertices(surf)[edge1])[1];
		vertex2 := Difference(FacesByVertices(surf)[face1], EdgesByVertices(surf)[edge2])[1];
		vertex3 := Difference(FacesByVertices(surf)[face1], EdgesByVertices(surf)[edge3])[1];
		vertex4 := Maximum(Vertices(surf)) + 1;
		vertex5 := Maximum(Vertices(surf)) + 2;
		vertex6 := Maximum(Vertices(surf)) + 3;
		
		newEdgesByVertices := List(EdgesByVertices(surf));
		newEdgesByVertices[edge1] := [vertex2, vertex4];
		newEdgesByVertices[edge2] := [vertex3, vertex5];
		newEdgesByVertices[edge3] := [vertex1, vertex6];
		#Edge4
		Add(newEdgesByVertices, [vertex3, vertex4]);
		#Edge5
		Add(newEdgesByVertices, [vertex1, vertex5]);
		#Edge6
		Add(newEdgesByVertices, [vertex2, vertex6]);
		#Edge7
		Add(newEdgesByVertices, [vertex5, vertex6]);
		#Edge8
		Add(newEdgesByVertices, [vertex4, vertex6]);
		#Edge9
		Add(newEdgesByVertices, [vertex4, vertex5]);

		newFacesByEdges := List(FacesByEdges(surf));
		newFacesByEdges[face1] := [edge3, edge5, edge7];
		Add(newFacesByEdges, [edge2, edge4, edge9]);
		Add(newFacesByEdges, [edge7, edge8, edge9]);
		Add(newFacesByEdges, [edge1, edge6, edge8]);

		newVertices := List(Vertices(surf));
		Append(newVertices, [vertex4, vertex5, vertex6]);
		newEdges := List(Edges(surf));
		Append(newEdges, [edge4, edge5, edge6, edge7, edge8, edge9]);
		newFaces := List(Faces(surf));
		Append(newFaces, [Maximum(Faces(surf))+1, Maximum(Faces(surf))+2, Maximum(Faces(surf))+3]);

		for i in Difference(EdgesByFaces(surf)[edge1], [face1]) do
			adjacentFace := List(newFacesByEdges[i]);
			newFacesByEdges[i] :=  Union(adjacentFace, [edge4]);
		od;
		for i in Difference(EdgesByFaces(surf)[edge2], [face1]) do
			adjacentFace := List(newFacesByEdges[i]);
			newFacesByEdges[i] :=  Union(adjacentFace, [edge5]);
		od;
		for i in Difference(EdgesByFaces(surf)[edge3], [face1]) do
			adjacentFace := List(newFacesByEdges[i]);
			newFacesByEdges[i] :=  Union(adjacentFace, [edge6]);
		od;

		return SimplicialSurfaceByDownwardIncidence(newVertices, newEdges, newFaces, newEdgesByVertices, newFacesByEdges);
	end
);


DeclareOperation( "SubdivideFace",
	[ IsSimplicialSurface, IsPosInt, IsPosInt ] );

InstallMethod(SubdivideFace,
	[IsSimplicialSurface, IsPosInt, IsPosInt],
	function(surf, face, n)
		local surf2, face2;
		if n > 3 then
			surf2 := SplitFaceBySpokes(surf, face);
			face2 := Random(Union(Difference(Faces(surf), [face]), [face]));
			return SubdivideFace(surf2, face2, n-2);
		elif n = 3 then
			return SplitFaceBySpokes(surf, face);
		else
			return SplitFaceByDivision(surf, face);
		fi;
	end
);




#################################################################################################



DeclareOperation( "RepairSquare",
	[ IsSimplicialSurface, IsPosInt, IsPosInt] );

InstallMethod(RepairSquare, "",
	[ IsSimplicialSurface, IsPosInt, IsPosInt] ,
	function(surf, face1, vertex1)

		#Add the option of not giving the vertex, and just choosing the max value point (as this is likely to be the most recently added point.)

		local adjacentEdges, edge1, edge2, edge3, edge4, edge5, vertex2, vertex3, vertex4, newEdgesByVertices, newFacesByEdges, newVertices, newEdges, newFaces;

		if not vertex1 in FacesByVertices(surf)[face1] then
			Print("ERROR: Chosen vertex is not in chosen face!\n");
			return;
		fi;
		if not Size(FacesByEdges(surf)[face1]) = 4 then
			Print("ERROR: Chosen face is not a square!");
			return;
		fi;

		adjacentEdges := Filtered(FacesByEdges(surf)[face1], t -> vertex1 in EdgesByVertices(surf)[t]);
		edge1:= adjacentEdges[1];
		vertex2 := Difference(EdgesByVertices(surf)[edge1], [vertex1])[1];
		edge4 := adjacentEdges[2];
		vertex4 := Difference(EdgesByVertices(surf)[edge4], [vertex1])[1];
		vertex3 := Difference(FacesByVertices(surf)[face1], Union(EdgesByVertices(surf){adjacentEdges}))[1];
		edge2 := Filtered(FacesByEdges(surf)[face1], t -> AsSet(EdgesByVertices(surf)[t]) = AsSet([vertex2, vertex3]))[1];
		edge3 := Filtered(FacesByEdges(surf)[face1], t -> AsSet(EdgesByVertices(surf)[t]) = AsSet([vertex3, vertex4]))[1];
		edge5 := Maximum(Edges(surf)) + 1;

		newEdgesByVertices := List(EdgesByVertices(surf));
		#Edge5
		Add(newEdgesByVertices, [vertex1, vertex3]);

		newFacesByEdges := List(FacesByEdges(surf));
		newFacesByEdges[face1] := [edge1, edge2, edge5];
		Add(newFacesByEdges, [edge3, edge4, edge5]);

		newEdges := List(Edges(surf));
		Append(newEdges, [edge5]);
		newFaces := List(Faces(surf));
		Append(newFaces, [Maximum(Faces(surf))+1]);
		newVertices := List(Vertices(surf));
		return SimplicialSurfaceByDownwardIncidence(newVertices, newEdges, newFaces, newEdgesByVertices, newFacesByEdges);
	end
);


InstallOtherMethod(RepairSquare, "",
	[ IsSimplicialSurface, IsPosInt] ,
	function(surf, face1)
		local vertex;
		vertex := Random(FacesByVertices(surf)[face1]);
		return RepairSquare(surf, face1, vertex);
	end
);


DeclareOperation("OrientedEdgePathOnFaceBetweenVertices",
	[IsSimplicialSurface, IsPosInt, IsPosInt, IsPosInt]);

InstallMethod(OrientedEdgePathOnFaceBetweenVertices, "",
	[IsSimplicialSurface, IsPosInt, IsPosInt, IsPosInt],
	function(surf, face1, vertex1, vertex2)
		local perm, edges_in_path, current_vertex, next_vertex, edges;
		if not vertex1 in FacesByVertices(surf)[face1] or not vertex2 in FacesByVertices(surf)[face1] then
			Print("ERROR: selected vertices do not lie on the given face!");
			return;
		fi;
		if vertex1 = vertex2 then
			Print("ERROR: vertices must be different!");
		fi;
		perm := LocalOrientationByVerticesAsPerm(surf)[face1];
		edges_in_path :=[];
		current_vertex := vertex1;
		edges := EdgesByVertices(surf);
		while not current_vertex = vertex2 do
			next_vertex := current_vertex^perm;
			Add(edges_in_path, Position(edges, Set([current_vertex, next_vertex])));
			current_vertex := next_vertex;
		od;
		return edges_in_path;
	end
);


DeclareOperation( "SplitPolygonalFace",
	[ IsSimplicialSurface, IsPosInt, IsPosInt, IsPosInt] );

InstallMethod(SplitPolygonalFace, "",
	[IsSimplicialSurface, IsPosInt, IsPosInt, IsPosInt],
	function(surf, face1, vertex1, vertex2)
		local path1, path2, newEdgesByVertices, newFacesByEdges, newVertices, newEdges, newFaces;
		if Set([vertex1, vertex2]) in EdgesByVertices(surf){FacesByEdges(surf)[face1]} then
			Print("ERROR: The vertices define an already existing edge of the face!");
			return;
		fi;
		if Size(FacesByEdges(surf)[face1]) <4 then
			Print("ERROR: The selected face has less than 4 edges!");
			return;
		fi;
		if not vertex1 in FacesByVertices(surf)[face1] or not vertex2 in FacesByVertices(surf)[face1] then
			Print("ERROR: selected vertices do not lie on the given face!");
			return;
		fi;
		path1 := OrientedEdgePathOnFaceBetweenVertices(surf, face1, vertex1, vertex2);
		Add(path1, Maximum(Edges(surf))+1);
		path2 := OrientedEdgePathOnFaceBetweenVertices(surf, face1, vertex2, vertex1);
		Add(path2, Maximum(Edges(surf))+1);

		newEdgesByVertices := List(EdgesByVertices(surf));
		Add(newEdgesByVertices, [vertex1, vertex2]);

		newFacesByEdges := List(FacesByEdges(surf));
		newFacesByEdges[face1] := path1;
		Add(newFacesByEdges, path2);

		newVertices := List(Vertices(surf));
		newEdges := List(Edges(surf));
		Add(newEdges, Maximum(Edges(surf))+1);
		newFaces := List(Faces(surf));
		Add(newFaces, Maximum(Faces(surf))+1);

		return SimplicialSurfaceByDownwardIncidence(newVertices, newEdges, newFaces, newEdgesByVertices, newFacesByEdges);
	end
);

InstallOtherMethod(SplitPolygonalFace, "",
	[IsSimplicialSurface, IsPosInt, IsPosInt],
	function(surf, face1, vertex1)
		local adjacentEdges, adjacentPoints, vertex2;

		adjacentEdges := Filtered(FacesByEdges(surf)[face1], t -> vertex1 in EdgesByVertices(surf)[t]);
		adjacentPoints := Union(EdgesByVertices(surf){adjacentEdges});
		vertex2 := Random(Difference(FacesByVertices(surf)[face1], adjacentPoints));;

		return SplitPolygonalFace(surf, face1, vertex1, vertex2);
	end
);

InstallOtherMethod(SplitPolygonalFace, "",
	[IsSimplicialSurface, IsPosInt],
	function(surf, face1)
		local vertex1;

		vertex1 := Random(FacesByVertices(surf)[face1]);;

		return SplitPolygonalFace(surf, face1, vertex1);
	end
);

#############################################################################################################################


DeclareOperation("AddFaceAndRepair",
	[IsSimplicialSurface, IsPosInt]);

InstallMethod(AddFaceAndRepair,"",
	[IsSimplicialSurface, IsPosInt],
	function(surf, face1)
		local method, face2, surf2, surf3;
		method := Random([1 .. 3]);
		if method = 1 then
			surf2 := SplitFaceBySpokes(surf, face1);
			Print("1\n");
		elif method = 2 then
			surf2 := SplitFaceByDivision(surf, face1);
			Print("2\n");
		else
			surf2 := SplitFaceByTriangleInsertion(surf, face1);
			Print("3\n");
		fi;
		while not IsTriangleSurface(surf2) do
			face2 := Random(Filtered(Faces(surf2), t -> Size(FacesByEdges(surf2)[t])>3));
			surf3 := SplitPolygonalFace(surf2, face2);
			surf2 := surf3;
		od;
		return surf2;
	end
);

InstallOtherMethod(AddFaceAndRepair,"",
	[IsSimplicialSurface],
	function(surf)
		return AddFaceAndRepair(surf, Random(Faces(surf)));
	end
);

#############################################################################################################################


##########################
# Old functions

# SplitFaceByDivision := function(surf, face1, edge1)
# 	# Takes as input a surface, the face to divide, and the edge which will be split.
	
# 	local edge2, edge3, edge4, edge5, vertex1, vertex2, vertex3, vertex4, newFacesByEdges, newEdgesByVertices, newVertices, newEdges, newFaces, i;

# 	if not edge1 in FacesByEdges(surf)[face1] then
# 		Print("ERROR: Chosen edge is not in chosen face!\n");
# 		return;
# 	fi;
# 	if not Size(FacesByEdges(surf)[face1]) = 3 then
# 		Print("ERROR: Chosen face is not a triangle!");
# 		return;
# 	fi;

# 	edge2 := Difference(FacesByEdges(surf)[face1], [edge1])[1];
# 	edge3 := Difference(FacesByEdges(surf)[face1], [edge1])[2];
# 	edge4 := Maximum(Edges(surf)) + 1;
# 	edge5 := Maximum(Edges(surf)) + 2;

# 	vertex1 := Difference(FacesByVertices(surf)[face1], EdgesByVertices(surf)[edge1])[1];
# 	vertex2 := Difference(EdgesByVertices(surf)[edge3], [vertex1])[1];
# 	vertex3 := Difference(EdgesByVertices(surf)[edge2], [vertex1])[1];
# 	vertex4 := Maximum(Vertices(surf)) + 1;

# 	newFacesByEdges := List(FacesByEdges(surf));
# 	newFacesByEdges[face1] := [edge1, edge2, edge5];
# 	Add(newFacesByEdges, [edge3, edge4, edge5]);
# 	newEdgesByVertices := List(EdgesByVertices(surf));
# 	newEdgesByVertices[edge1] := [vertex3, vertex4];
# 	Add(newEdgesByVertices, [vertex2, vertex4]);
# 	Add(newEdgesByVertices, [vertex1, vertex4]);

# 	for i in Difference(EdgesByFaces(surf)[edge1], [face1]) do
# 		adjacentFace := List(newFacesByEdges[i]);
# 		newFacesByEdges[i] :=  Union(adjacentFace, [edge4]);
# 	od;

# 	newVertices := List(Vertices(surf));
# 	Add(newVertices, vertex4);
# 	newEdges := List(Edges(surf));
# 	Append(newEdges, [edge4, edge5]);
# 	newFaces := List(Faces(surf));
# 	Add(newFaces, Maximum(Faces(surf))+1);

# 	return SimplicialSurfaceByDownwardIncidence(newVertices, newEdges, newFaces, newEdgesByVertices, newFacesByEdges);
# end;


# SplitFaceBySpokes := function(surf, face1)
# 	# Takes as input a surface and the face to be divided.

# 	local edge1, edge2, edge3, edge4, edge5, edge6, vertex1, vertex2, vertex3, vertex4, newEdgesByVertices, newFacesByEdges, newVertices, newEdges, newFaces;

# 	if not Size(FacesByEdges(surf)[face1]) = 3 then
# 		Print("ERROR: Chosen face is not a triangle!");
# 		return;
# 	fi;

# 	edge1 := FacesByEdges(surf)[face1][1];
# 	edge2 := FacesByEdges(surf)[face1][2];
# 	edge3 := FacesByEdges(surf)[face1][3];
# 	edge4 := Maximum(Edges(surf)) + 1;
# 	edge5 := Maximum(Edges(surf)) + 2;
# 	edge6 := Maximum(Edges(surf)) + 3;

# 	vertex1 := Difference(FacesByVertices(surf)[face1], EdgesByVertices(surf)[edge1])[1];
# 	vertex2 := Difference(EdgesByVertices(surf)[edge3], [vertex1])[1];
# 	vertex3 := Difference(EdgesByVertices(surf)[edge2], [vertex1])[1];
# 	vertex4 := Maximum(Vertices(surf)) + 1;

# 	newEdgesByVertices := List(EdgesByVertices(surf));
# 	Add(newEdgesByVertices, [vertex1, vertex4]);
# 	Add(newEdgesByVertices, [vertex2, vertex4]);
# 	Add(newEdgesByVertices, [vertex3, vertex4]);

# 	newFacesByEdges := List(FacesByEdges(surf));
# 	newFacesByEdges[face1] := [edge3, edge4, edge5];
# 	Add(newFacesByEdges, [edge1, edge5, edge6]);
# 	Add(newFacesByEdges, [edge2, edge4, edge6]);

# 	newVertices := List(Vertices(surf));
# 	Add(newVertices, vertex4);
# 	newEdges := List(Edges(surf));
# 	Append(newEdges, [edge4, edge5, edge6]);
# 	newFaces := List(Faces(surf));
# 	Append(newFaces, [Maximum(Faces(surf))+1, Maximum(Faces(surf))+2]);

# 	return SimplicialSurfaceByDownwardIncidence(newVertices, newEdges, newFaces, newEdgesByVertices, newFacesByEdges);
# end;

# SplitFaceByTriangleInsertion := function(surf, face1, edge1, edge2, edge3)
# 	#Takes as input a surface, the face to be divided and each of the edges of the face.

# 	local edge4, edge5, edge6, edge7, edge8, edge9, vertex1, vertex2, vertex3, vertex4, vertex5, vertex6,
# 	 newEdgesByVertices, newFacesByEdges, newVertices, newEdges, newFaces;

# 	if not Set([edge1, edge2, edge3]) = Set(FacesByEdges(surf)[face1]) then
# 		Print("ERROR: Chosen edges are not all in chosen face!\n");
# 		return;
# 	fi;
# 	if not Size(FacesByEdges(surf)[face1]) = 3 then
# 		Print("ERROR: Chosen face is not a triangle!");
# 		return;
# 	fi;

# 	edge4 := Maximum(Edges(surf)) + 1;
# 	edge5 := Maximum(Edges(surf)) + 2;
# 	edge6 := Maximum(Edges(surf)) + 3;
# 	edge7 := Maximum(Edges(surf)) + 4;
# 	edge8 := Maximum(Edges(surf)) + 5;
# 	edge9 := Maximum(Edges(surf)) + 6;


# 	vertex1 := Difference(FacesByVertices(surf)[face1], EdgesByVertices(surf)[edge1])[1];
# 	vertex2 := Difference(FacesByVertices(surf)[face1], EdgesByVertices(surf)[edge2])[1];
# 	vertex3 := Difference(FacesByVertices(surf)[face1], EdgesByVertices(surf)[edge3])[1];
# 	vertex4 := Maximum(Vertices(surf)) + 1;
# 	vertex5 := Maximum(Vertices(surf)) + 2;
# 	vertex6 := Maximum(Vertices(surf)) + 3;
	
# 	newEdgesByVertices := List(EdgesByVertices(surf));
# 	newEdgesByVertices[edge1] := [vertex2, vertex4];
# 	newEdgesByVertices[edge2] := [vertex3, vertex5];
# 	newEdgesByVertices[edge3] := [vertex1, vertex6];
# 	#Edge4
# 	Add(newEdgesByVertices, [vertex3, vertex4]);
# 	#Edge5
# 	Add(newEdgesByVertices, [vertex1, vertex5]);
# 	#Edge6
# 	Add(newEdgesByVertices, [vertex2, vertex6]);
# 	#Edge7
# 	Add(newEdgesByVertices, [vertex5, vertex6]);
# 	#Edge8
# 	Add(newEdgesByVertices, [vertex4, vertex6]);
# 	#Edge9
# 	Add(newEdgesByVertices, [vertex4, vertex5]);

# 	newFacesByEdges := List(FacesByEdges(surf));
# 	newFacesByEdges[face1] := [edge3, edge5, edge7];
# 	Add(newFacesByEdges, [edge2, edge4, edge9]);
# 	Add(newFacesByEdges, [edge7, edge8, edge9]);
# 	Add(newFacesByEdges, [edge1, edge6, edge8]);

# 	newVertices := List(Vertices(surf));
# 	Append(newVertices, [vertex4, vertex5, vertex6]);
# 	newEdges := List(Edges(surf));
# 	Append(newEdges, [edge4, edge5, edge6, edge7, edge8, edge9]);
# 	newFaces := List(Faces(surf));
# 	Append(newFaces, [Maximum(Faces(surf))+1, Maximum(Faces(surf))+2, Maximum(Faces(surf))+3]);

# 	for i in Difference(EdgesByFaces(surf)[edge1], [face1]) do
# 		adjacentFace := List(newFacesByEdges[i]);
# 		newFacesByEdges[i] :=  Union(adjacentFace, [edge4]);
# 	od;
# 	for i in Difference(EdgesByFaces(surf)[edge2], [face1]) do
# 		adjacentFace := List(newFacesByEdges[i]);
# 		newFacesByEdges[i] :=  Union(adjacentFace, [edge5]);
# 	od;
# 	for i in Difference(EdgesByFaces(surf)[edge3], [face1]) do
# 		adjacentFace := List(newFacesByEdges[i]);
# 		newFacesByEdges[i] :=  Union(adjacentFace, [edge6]);
# 	od;

# 	return SimplicialSurfaceByDownwardIncidence(newVertices, newEdges, newFaces, newEdgesByVertices, newFacesByEdges);
# end;



###################
# consider spliting for larger polygons? is this necessary if repairs are conducted immediately after the face division?

# RepairPolygonByDividing := function(surf, face1, vertex1, vertex2)

# 	local adjacentEdges, edge1, edge2, edge3, edge4, edge5, vertex2, vertex3, vertex4, newEdgesByVertices, newFacesByEdges, newVertices, newEdges, newFaces;

# 	if not vertex1 in FacesByVertices(surf)[face1] then
# 		Print("ERROR: Chosen vertex is not in chosen face!\n");
# 		return;
# 	fi;
# 	if Size(FacesByEdges(surf)[face1]) < 4 then
# 		Print("ERROR: Chosen face doesn't have enough edges to divide!");
# 		return;
# 	fi;

# 	adjacentEdges := Filtered(FacesByEdges(surf)[face1], t -> vertex1 in EdgesByVertices(surf)[t]);
# 	edge1:= adjacentEdges[1];
# 	vertex2 := Difference(EdgesByVertices(surf)[edge1], [vertex1])[1];
# 	edge4 := adjacentEdges[2];
# 	vertex4 := Difference(EdgesByVertices(surf)[edge4], [vertex1])[1];
# 	vertex3 := Difference(FacesByVertices(surf)[face1], Union(EdgesByVertices(surf){adjacentEdges}))[1];
# 	edge2 := Filtered(FacesByEdges(surf)[face1], t -> EdgesByVertices(surf)[t] = [vertex2, vertex3])[1];
# 	edge3 := Filtered(FacesByEdges(surf)[face1], t -> EdgesByVertices(surf)[t] = [vertex3, vertex4])[1];
# 	edge5 := Maximum(Edges(surf)) + 1;

# 	newEdgesByVertices := List(EdgesByVertices(surf));
# 	#Edge5
# 	Add(newEdgesByVertices, [vertex1, vertex3]);

# 	newFacesByEdges := List(FacesByEdges(surf));
# 	newFacesByEdges[face1] := [edge1, edge2, edge5];
# 	Add(newFacesByEdges, [edge3, edge4, edge5]);

# 	newEdges := List(Edges(surf));
# 	Append(newEdges, [edge5]);
# 	newFaces := List(Faces(surf));
# 	Append(newFaces, [Maximum(Faces(surf))+1]);
# 	newVertices := List(Vertices(surf));
# 	return SimplicialSurfaceByDownwardIncidence(newVertices, newEdges, newFaces, newEdgesByVertices, newFacesByEdges);
# end;
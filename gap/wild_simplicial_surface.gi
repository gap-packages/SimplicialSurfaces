#! @DoNotReadRestOfFile


##
##	Declare the representation of wild simplicial surfaces that does nothing.
##
DeclareRepresentation("IsWildSimplicialSurfaceRep", 
	IsWildSimplicialSurface, [ ] );
##
##	Define a type so we can use Objectify.
##
WildSimplicialSurfaceType := 
	NewType( SimplicialSurfaceFamily, IsWildSimplicialSurfaceRep );



#############################################################################
#############################################################################
##
##						Start of constructors
##

###################################
##
##	Constructor by downward incidence and edge colouring
##
InstallMethod( WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouringNC,
	"for three sets and three lists",
	[ IsSet, IsSet, IsSet, IsList, IsList, IsList],
	function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
		coloursOfEdges )

		local surf;

		surf := Objectify( WildSimplicialSurfaceType, rec() );

		# define the incidence structure
		SetVerticesAttributeOfSimplicialSurface( surf, vertices );
		SetEdges( surf, edges );
		SetFaces( surf, faces );
		SetVerticesOfEdges( surf, List(verticesOfEdges,i->Set(i)) );
		SetEdgesOfFaces( surf, List(edgesOfFaces,i->Set(i)) );

		# define other attributes of simplicial surface
		DeriveLocalOrientationAndFacesNamesFromIncidenceGeometryNC( surf );

		# set edge colouring attribute
		SetColoursOfEdges( surf, coloursOfEdges );

		return surf;
	end
);
	RedispatchOnCondition(
		WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouringNC, true,
		[ IsList, IsList, IsList, IsList, IsList, IsList],
		[ IsSet, IsSet, IsSet, , , ], 0 );

	#	Implement alternative callings
	InstallOtherMethod( 
		WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouringNC,
		"", [ IsPosInt, IsObject, IsObject, IsList, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
			coloursOfEdges )
		
			return WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouringNC(
						[1..vertices], edges, faces, verticesOfEdges, 
						edgesOfFaces, coloursOfEdges );
		end
	);

	InstallOtherMethod( 
		WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouringNC,
		"", [ IsSet, IsPosInt, IsObject, IsList, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
			coloursOfEdges )
		
			return WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouringNC(
						vertices, [1..edges], faces, verticesOfEdges, 
						edgesOfFaces, coloursOfEdges );
		end
	);
		RedispatchOnCondition(
			WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouringNC, true,
			[ IsList, IsPosInt, IsObject, IsList, IsList, IsList ],
			[ IsSet, , , , , ], 0 );

	InstallOtherMethod( 
		WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouringNC,
		"", [ IsSet, IsSet, IsPosInt, IsList, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
			coloursOfEdges )
		
			return WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouringNC(
						vertices, edges, [1..faces], verticesOfEdges, 
						edgesOfFaces, coloursOfEdges );
		end
	);
		RedispatchOnCondition(
			WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouringNC, true,
			[ IsList, IsList, IsPosInt, IsList, IsList, IsList ],
			[ IsSet, IsSet, , , , ], 0 );

BindGlobal( "__SIMPLICIAL_CheckEdgeColouring",
	function( faces, edgesOfFaces, coloursOfEdges )
		local f;

		for f in faces do
			if Set( List( edgesOfFaces[f], e -> coloursOfEdges[e] ) ) <> 
					[1,2,3] then
				Error("__SIMPLICIAL_CheckEdgeColouring: Each face has to have three different coloured edges." );
			fi;
		od;
	end
);
InstallMethod( WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring,
	"for three sets and three lists",
	[ IsSet, IsSet, IsSet, IsList, IsList, IsList],
	function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
		coloursOfEdges )

		local surf, f;

		__SIMPLICIAL_CheckDownwardIncidence( vertices, edges, faces,
			verticesOfEdges, edgesOfFaces, fail, false );

		surf := WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouringNC( 
						vertices, edges, faces, verticesOfEdges, 
						edgesOfFaces, coloursOfEdges );

		# Check the edge colouring
		__SIMPLICIAL_CheckEdgeColouring( Faces(surf), EdgesOfFaces(surf), 
											coloursOfEdges );

		return surf;
	end
);
	RedispatchOnCondition(
		WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring, true,
		[ IsList, IsList, IsList, IsList, IsList, IsList],
		[ IsSet, IsSet, IsSet, , , ], 0 );

	#	Implement alternative callings
	InstallOtherMethod( 
		WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring,
		"", [ IsPosInt, IsObject, IsObject, IsList, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
			coloursOfEdges )
		
			return WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring(
						[1..vertices], edges, faces, verticesOfEdges, 
						edgesOfFaces, coloursOfEdges );
		end
	);

	InstallOtherMethod( 
		WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring,
		"", [ IsSet, IsPosInt, IsObject, IsList, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
			coloursOfEdges )
		
			return WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring(
						vertices, [1..edges], faces, verticesOfEdges, 
						edgesOfFaces, coloursOfEdges );
		end
	);
		RedispatchOnCondition(
			WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring, true,
			[ IsList, IsPosInt, IsObject, IsList, IsList, IsList ],
			[ IsSet, , , , , ], 0 );

	InstallOtherMethod( 
		WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring,
		"", [ IsSet, IsSet, IsPosInt, IsList, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
			coloursOfEdges )
		
			return WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring(
						vertices, edges, [1..faces], verticesOfEdges, 
						edgesOfFaces, coloursOfEdges );
		end
	);
		RedispatchOnCondition(
			WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring, true,
			[ IsList, IsList, IsPosInt, IsList, IsList, IsList ],
			[ IsSet, IsSet, , , , ], 0 );


###################################
##
##	Constructor by downward incidence and generators
##
BindGlobal( "__SIMPLICIAL_ColoursOfEdgesFromGenerators",
	function( edges, faces, facesOfEdges, gens )
		local edgeColours, edge, cycles, col;

		cycles := List( gens, g -> Cycles( g, faces ) );
		edgeColours := [];
		for edge in edges do
			for col in [1..Length(cycles)] do
				if facesOfEdges[edge] in cycles[col] then
					if IsBound( edgeColours[edge] ) then
						Error("__SIMPLICIAL_ColoursOfEdgesFromGenerators: Cycles don't define edges uniquely.");
					else
						edgeColours[edge] := col;
					fi;
				fi; 
			od;
		od;

		return edgeColours;
	end
);
InstallMethod( WildSimplicialSurfaceByDownwardIncidenceAndGeneratorsNC,
	"for three sets and three lists",
	[ IsSet, IsSet, IsSet, IsList, IsList, IsList],
	function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
		generators )

		local surf, coloursOfEdges;

		surf := Objectify( WildSimplicialSurfaceType, rec() );

		# define the incidence structure
		SetVerticesAttributeOfSimplicialSurface( surf, vertices );
		SetEdges( surf, edges );
		SetFaces( surf, faces );
		SetVerticesOfEdges( surf, List(verticesOfEdges, i -> Set(i)) );
		SetEdgesOfFaces( surf, List(edgesOfFaces, i -> Set(i) ) );

		# define other attributes of simplicial surface
		DeriveLocalOrientationAndFacesNamesFromIncidenceGeometryNC( surf );

		# set edge colouring attribute
		SetGenerators( surf, generators );
		coloursOfEdges := __SIMPLICIAL_ColoursOfEdgesFromGenerators( 
				Edges(surf), Faces(surf), FacesOfEdges(surf), generators );
		SetColoursOfEdges( surf, coloursOfEdges );

		return surf;
	end
);
	RedispatchOnCondition(
		WildSimplicialSurfaceByDownwardIncidenceAndGeneratorsNC, true,
		[ IsList, IsList, IsList, IsList, IsList, IsList],
		[ IsSet, IsSet, IsSet, , , ], 0 );

	#	Implement alternative callings
	InstallOtherMethod( 
		WildSimplicialSurfaceByDownwardIncidenceAndGeneratorsNC,
		"", [ IsPosInt, IsObject, IsObject, IsList, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
			generators )
		
			return WildSimplicialSurfaceByDownwardIncidenceAndGeneratorsNC(
						[1..vertices], edges, faces, verticesOfEdges, 
						edgesOfFaces, generators );
		end
	);

	InstallOtherMethod( 
		WildSimplicialSurfaceByDownwardIncidenceAndGeneratorsNC,
		"", [ IsSet, IsPosInt, IsObject, IsList, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
			generators )
		
			return WildSimplicialSurfaceByDownwardIncidenceAndGeneratorsNC(
						vertices, [1..edges], faces, verticesOfEdges, 
						edgesOfFaces, generators );
		end
	);
		RedispatchOnCondition(
			WildSimplicialSurfaceByDownwardIncidenceAndGeneratorsNC, true,
			[ IsList, IsPosInt, IsObject, IsList, IsList, IsList ],
			[ IsSet, , , , , ], 0 );

	InstallOtherMethod( 
		WildSimplicialSurfaceByDownwardIncidenceAndGeneratorsNC,
		"", [ IsSet, IsSet, IsPosInt, IsList, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
			generators )
		
			return WildSimplicialSurfaceByDownwardIncidenceAndGeneratorsNC(
						vertices, edges, [1..faces], verticesOfEdges, 
						edgesOfFaces, generators );
		end
	);
		RedispatchOnCondition(
			WildSimplicialSurfaceByDownwardIncidenceAndGeneratorsNC, true,
			[ IsList, IsList, IsPosInt, IsList, IsList, IsList ],
			[ IsSet, IsSet, , , , ], 0 );


BindGlobal( "__SIMPLICIAL_CheckGenerators",
	function( gens, faces, edgesOfFaces )
		local g, f1, f2, stillFaces;

		if Length(gens) <> 3 then
			Error("__SIMPLICIAL_CheckGenerators: There should be exactly three generators.");
		fi;
		for g in gens do
			if not IsPerm(g) then
				Error("__SIMPLICIAL_CheckGenerators: Generators should be permutations.");
			fi;
			if g^2 <> One(g) then
				Error("__SIMPLICIAL_CheckGenerators: Generators have to be involutions.");
			fi;
		od;

		# Check if generators act on the faces
		g := Group( gens );
		if not IsSubset( MovedPoints(g), faces ) then
			Error("__SIMPLICIAL_CheckGenerators: There are more moved points in the generators than given faces.");
		fi;
		stillFaces := Difference( faces, MovedPoints(g) );

		# The still faces can't have an edge in common with any other face
		for f1 in stillFaces do
			for f2 in faces do
				if f1 >= f2 then
					continue;
				fi;
				if not IsEmpty( Intersection( edgesOfFaces[f1], edgesOfFaces[f2] ) ) then
					Error("__SIMPLICIAL_CheckGenerators: A face is not moved by group but shares an edge with another face.");
				fi;
			od;
		od;
	end
);
InstallMethod( WildSimplicialSurfaceByDownwardIncidenceAndGenerators,
	"for three sets and three lists",
	[ IsSet, IsSet, IsSet, IsList, IsList, IsList],
	function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
		generators )

		__SIMPLICIAL_CheckGenerators( generators, faces, edgesOfFaces );
		return WildSimplicialSurfaceByDownwardIncidenceAndGeneratorsNC( 
			vertices, edges, faces, verticesOfEdges, edgesOfFaces, generators );
	end
);
	RedispatchOnCondition(
		WildSimplicialSurfaceByDownwardIncidenceAndGenerators, true,
		[ IsList, IsList, IsList, IsList, IsList, IsList],
		[ IsSet, IsSet, IsSet, , , ], 0 );

	#	Implement alternative callings
	InstallOtherMethod( 
		WildSimplicialSurfaceByDownwardIncidenceAndGenerators,
		"", [ IsPosInt, IsObject, IsObject, IsList, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
			generators )
		
			return WildSimplicialSurfaceByDownwardIncidenceAndGenerators(
						[1..vertices], edges, faces, verticesOfEdges, 
						edgesOfFaces, generators );
		end
	);

	InstallOtherMethod( 
		WildSimplicialSurfaceByDownwardIncidenceAndGenerators,
		"", [ IsSet, IsPosInt, IsObject, IsList, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
			generators )
		
			return WildSimplicialSurfaceByDownwardIncidenceAndGenerators(
						vertices, [1..edges], faces, verticesOfEdges, 
						edgesOfFaces, generators );
		end
	);
		RedispatchOnCondition(
			WildSimplicialSurfaceByDownwardIncidenceAndGenerators, true,
			[ IsList, IsPosInt, IsObject, IsList, IsList, IsList ],
			[ IsSet, , , , , ], 0 );

	InstallOtherMethod( 
		WildSimplicialSurfaceByDownwardIncidenceAndGenerators,
		"", [ IsSet, IsSet, IsPosInt, IsList, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces, 
			generators )
		
			return WildSimplicialSurfaceByDownwardIncidenceAndGenerators(
						vertices, edges, [1..faces], verticesOfEdges, 
						edgesOfFaces, generators );
		end
	);
		RedispatchOnCondition(
			WildSimplicialSurfaceByDownwardIncidenceAndGenerators, true,
			[ IsList, IsList, IsPosInt, IsList, IsList, IsList ],
			[ IsSet, IsSet, , , , ], 0 );

###################################
##
##	Constructor by simplicial surface and edge colouring
##
InstallMethod( WildSimplicialSurfaceExtensionByEdgeColouringNC, "",
	[ IsSimplicialSurface and IsActualSurface and IsTriangleSurface, IsList ],
	function( surf, coloursOfEdges )
		local wild;

		wild := ObjectifySimplicialSurface( 
			WildSimplicialSurfaceType, rec(), surf);
		SetColoursOfEdges( wild, coloursOfEdges );

		return wild;
	end
);
	RedispatchOnCondition( WildSimplicialSurfaceExtensionByEdgeColouringNC, 
		true, [ IsSimplicialSurface, IsList ],
		[ IsActualSurface and IsTriangleSurface, ], 0 );


InstallMethod( WildSimplicialSurfaceExtensionByEdgeColouring, "",
	[ IsSimplicialSurface and IsActualSurface and IsTriangleSurface, IsList ],
	function( surf, coloursOfEdges )

		__SIMPLICIAL_CheckEdgeColouring( Faces(surf), EdgesOfFaces(surf), 
											coloursOfEdges );

		return WildSimplicialSurfaceExtensionByEdgeColouringNC( surf, 
															coloursOfEdges );
	end
);
	RedispatchOnCondition( WildSimplicialSurfaceExtensionByEdgeColouring, 
		true, [ IsSimplicialSurface, IsList ],
		[ IsActualSurface and IsTriangleSurface, ], 0 );


###################################
##
##	Constructor by simplicial surface and generators
##
InstallMethod( WildSimplicialSurfaceExtensionByGeneratorsNC, "",
	[ IsSimplicialSurface and IsActualSurface and IsTriangleSurface, IsList ],
	function( surf, generators )
		local wild, coloursOfEdges;

		coloursOfEdges := __SIMPLICIAL_ColoursOfEdgesFromGenerators( 
				Edges(surf), Faces(surf), FacesOfEdges(surf), generators );

		wild := ObjectifySimplicialSurface( 
			WildSimplicialSurfaceType, rec(), surf);

		SetGenerators( wild, generators );
		SetColoursOfEdges( wild, coloursOfEdges );

		return wild;
	end
);
	RedispatchOnCondition( WildSimplicialSurfaceExtensionByGeneratorsNC, 
		true, [ IsSimplicialSurface, IsList ],
		[ IsActualSurface and IsTriangleSurface, ], 0 );


InstallMethod( WildSimplicialSurfaceExtensionByGenerators, "",
	[ IsSimplicialSurface and IsActualSurface and IsTriangleSurface, IsList ],
	function( surf, generators )
		__SIMPLICIAL_CheckGenerators( generators, 
						Faces(surf), EdgesOfFaces(surf) );
		return WildSimplicialSurfaceExtensionByGeneratorsNC( surf, generators );
	end
);
	RedispatchOnCondition( WildSimplicialSurfaceExtensionByGenerators, 
		true, [ IsSimplicialSurface, IsList ],
		[ IsActualSurface and IsTriangleSurface, ], 0 );

###################################
##
##	Constructor by face-edge-paths and edge colouring
##
InstallMethod( WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouringNC,
	"for three sets and three lists",
	[ IsSet, IsSet, IsSet, IsList, IsList ],
	function( vertices, edges, faces, faceEdgePaths, coloursOfEdges )

		local surf;

		surf := Objectify( WildSimplicialSurfaceType, rec() );

		# define the incidence structure
		SetVerticesAttributeOfSimplicialSurface( surf, vertices );
		SetEdges( surf, edges );
		SetFaces( surf, faces );
		SetFaceEdgePathsOfVertices( surf, faceEdgePaths );

		# define other attributes of simplicial surface
		DeriveLocalOrientationAndFacesNamesFromIncidenceGeometryNC( surf );

		# set edge colouring attribute
		SetColoursOfEdges( surf, coloursOfEdges );

		return surf;
	end
);
	RedispatchOnCondition(
		WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouringNC, true,
		[ IsList, IsList, IsList, IsList, IsList ],
		[ IsSet, IsSet, IsSet, , ], 0 );

	#	Implement alternative callings
	InstallOtherMethod( 
		WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouringNC,
		"", [ IsPosInt, IsObject, IsObject, IsList, IsList ],
		function( vertices, edges, faces, faceEdgePaths, coloursOfEdges )
		
			return WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouringNC(
				[1..vertices], edges, faces, faceEdgePaths, coloursOfEdges );
		end
	);

	InstallOtherMethod( 
		WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouringNC,
		"", [ IsSet, IsPosInt, IsObject, IsList, IsList ],
		function( vertices, edges, faces, faceEdgePaths, coloursOfEdges )
		
			return WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouringNC(
				vertices, [1..edges], faces, faceEdgePaths, coloursOfEdges );
		end
	);
		RedispatchOnCondition(
			WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouringNC, true,
			[ IsList, IsPosInt, IsObject, IsList, IsList ],
			[ IsSet, , , , ], 0 );

	InstallOtherMethod( 
		WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouringNC,
		"", [ IsSet, IsSet, IsPosInt, IsList, IsList ],
		function( vertices, edges, faces, faceEdgePaths, coloursOfEdges )
		
			return WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouringNC(
				vertices, edges, [1..faces], faceEdgePaths, coloursOfEdges );
		end
	);
		RedispatchOnCondition(
			WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouringNC, true,
			[ IsList, IsList, IsPosInt, IsList, IsList ],
			[ IsSet, IsSet, , , ], 0 );



BindGlobal( "__SIMPLICIAL_CheckFaceEdgePaths",
	function( vertices, edges, faces, faceEdgePaths, coloured )
		local v, paths, path, foundEdges, foundFaces, CheckPath;

		# Check if vertices, edges and faces are sets of positive integers
		if not __SIMPLICIAL_IsSetPosInt( vertices ) then
			Error("__SIMPLICIAL_CheckFaceEdgePaths: Vertices have to be positive integers.");
		fi;

		if not __SIMPLICIAL_IsSetPosInt( edges ) then
			if coloured then
				Error("__SIMPLICIAL_CheckFaceEdgePaths: Colours have to be positive integers");
			else
				Error("__SIMPLICIAL_CheckFaceEdgePaths: Edges have to be positive integers");
			fi;
		fi;

		if not __SIMPLICIAL_IsSetPosInt( faces ) then
			Error("__SIMPLICIAL_CheckFaceEdgePaths: Faces have to be positive integers.");
		fi;

		# Check the faceEdgePaths specifically
		if Number( faceEdgePaths ) <> Length( vertices ) then
			Error("WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring: Not as many FaceEdgePaths as vertices.");
		fi;
		foundEdges := [];
		foundFaces := [];

		# Local method to check one path
		CheckPath := function( path )
			local i;

			if not IsList(path) then
				Error("WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring: Each path of FaceEdgePaths has to be a list.");
			fi;

			for i in [1..Length(path)] do
				if IsEvenInt(i) then
					if not path[i] in faces then
						Error("WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring: Even path-entries have to be faces.");
					fi;
					Append( foundFaces, [ path[i] ] );
				else
					if not path[i] in edges then
						if coloured then
							Error("WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring: Odd path-entries have to be colours."); 
						else
							Error("WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring: Odd path-entries have to be edges."); 
						fi;
					fi;
					Append( foundEdges, [ path[i] ] );
				fi;
			od;
		end;

		# Use local method to check all paths
		for v in vertices do
			if not IsBound( faceEdgePaths[v] ) then
				Error("WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring: FaceEdgePaths have to be given for each vertex.");
			fi;

			paths := faceEdgePaths[v];
			if coloured then
				CheckPath(paths);
			else
				for path in paths do
					CheckPath(path);
				od;
			fi;
		od;

		if Set(foundEdges) <> edges then
			if coloured then
				Error("WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring: Colours from face-edge-paths don't match given colours.");
			else
				Error("WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring: Edges from face-edge-paths don't match given edges.");
			fi;
		fi;
		if Set(foundFaces) <> faces then
			Error("WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring: Faces from face-edge-paths don't match given faces.");
		fi;
	end
);
InstallMethod( WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring, "",
	[ IsSet, IsSet, IsSet, IsList, IsList ],
	function( vertices, edges, faces, faceEdgePaths, coloursOfEdges )
		local surf;

		__SIMPLICIAL_CheckFaceEdgePaths( vertices, edges, faces, 
											faceEdgePaths, false );

		surf := WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouringNC( 
						vertices, edges, faces, faceEdgePaths, coloursOfEdges );

		# Check the edge colouring
		__SIMPLICIAL_CheckEdgeColouring( Faces(surf), EdgesOfFaces(surf), 
											coloursOfEdges );
		return surf;
	end
);
	RedispatchOnCondition(
		WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring, true,
		[ IsList, IsList, IsList, IsList, IsList],
		[ IsSet, IsSet, IsSet, , ], 0 );

	#	Implement alternative callings
	InstallOtherMethod( 
		WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring,
		"", [ IsPosInt, IsObject, IsObject, IsList, IsList ],
		function( vertices, edges, faces, faceEdgePaths, coloursOfEdges )
		
			return WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring(
				[1..vertices], edges, faces, faceEdgePaths, coloursOfEdges );
		end
	);

	InstallOtherMethod( 
		WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring,
		"", [ IsSet, IsPosInt, IsObject, IsList, IsList ],
		function( vertices, edges, faces, faceEdgePaths, coloursOfEdges )
		
			return WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring(
				vertices, [1..edges], faces, faceEdgePaths, coloursOfEdges );
		end
	);
		RedispatchOnCondition(
			WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring, true,
			[ IsList, IsPosInt, IsObject, IsList, IsList ],
			[ IsSet, , , , ], 0 );

	InstallOtherMethod( 
		WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring,
		"", [ IsSet, IsSet, IsPosInt, IsList, IsList ],
		function( vertices, edges, faces, faceEdgePaths, coloursOfEdges )
		
			return WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring(
				vertices, edges, [1..faces], faceEdgePaths, coloursOfEdges );
		end
	);
		RedispatchOnCondition(
			WildSimplicialSurfaceByFaceEdgesPathsAndEdgeColouring, true,
			[ IsList, IsList, IsPosInt, IsList, IsList ],
			[ IsSet, IsSet, , , ], 0 );



###################################
##
##	Constructor by coloured face-edge-paths
##
InstallMethod( WildSimplicialSurfaceByColouredFaceEdgePathsNC, "",
	[ IsSet, IsSet, IsList ],
	function( vertices, faces, colouredFaceEdgePaths )
		local surf, edges, facesOfEdges, colOfEdges, edgesOfVertices, v, i, 
			path, facesAround, possEdges, newEdge;

		edges := [];
		facesOfEdges := [];
		colOfEdges := [];
		edgesOfVertices := [];

		for v in vertices do
			edgesOfVertices[v] := [];
			path := colouredFaceEdgePaths[v];

			for i in [1..Length(path)] do
				if IsEvenInt(i) then
					continue;
				fi;

				facesAround := 
						__SIMPLICIAL_FacesAroundEdgesInFaceEdgePath( path, i );
				possEdges := Filtered( edges, e -> 
										facesOfEdges[e] = facesAround and 
										colOfEdges[e] = path[i] );
				if Length(possEdges) > 1 then
					Error("WildSimplicialSurfaceByColouredFaceEdgePaths: More than one edge for incident faces and colour.");
				elif Length(possEdges) = 1 then
					edgesOfVertices[v] := Union(edgesOfVertices[v], possEdges);
				else
					# Add new edge
					newEdge := Length(edges) + 1;
					facesOfEdges[newEdge] := facesAround;
					colOfEdges[newEdge] := path[i];
					Append( edges, [newEdge] );
					edgesOfVertices[v] := Union(edgesOfVertices[v], [newEdge]);
				fi;
			od;
		od;
	
		surf := Objectify( WildSimplicialSurfaceType, rec() );

		# define the incidence structure
		SetVerticesAttributeOfSimplicialSurface( surf, vertices );
		SetEdges( surf, edges );
		SetFaces( surf, faces );
		SetFacesOfEdges( surf, facesOfEdges );
		SetEdgesOfVertices( surf, edgesOfVertices );
		SetColoursOfEdges( surf, colOfEdges );
		SetColouredFaceEdgePathsOfVertices( surf, colouredFaceEdgePaths );

		# define other attributes of simplicial surface
		DeriveLocalOrientationAndFacesNamesFromIncidenceGeometryNC( surf );

		return surf;
	end
);
	RedispatchOnCondition( WildSimplicialSurfaceByColouredFaceEdgePathsNC, true,
		[ IsList, IsList, IsList ], [ IsSet, IsSet, ], 0 );

	#	Implement alternative callings
	InstallOtherMethod( WildSimplicialSurfaceByColouredFaceEdgePathsNC,
		"", [ IsPosInt, IsObject, IsList ],
		function( vertices, faces, colouredFaceEdgePaths )
			return WildSimplicialSurfaceByColouredFaceEdgePathsNC(
				[1..vertices], faces, colouredFaceEdgePaths );
		end
	);

	InstallOtherMethod( WildSimplicialSurfaceByColouredFaceEdgePathsNC,
		"", [ IsSet, IsPosInt, IsList ],
		function( vertices, faces, colouredFaceEdgePaths )
			return WildSimplicialSurfaceByColouredFaceEdgePathsNC(
				vertices, [1..faces], colouredFaceEdgePaths );
		end
	);
		RedispatchOnCondition( WildSimplicialSurfaceByColouredFaceEdgePathsNC, 
			true, [ IsList, IsPosInt, IsList ], [ IsSet, , ], 0 );


InstallMethod( WildSimplicialSurfaceByColouredFaceEdgePaths, "",
	[ IsSet, IsSet, IsList ],
	function( vertices, faces, colouredFaceEdgePaths )
		local surf;

		__SIMPLICIAL_CheckFaceEdgePaths( vertices, [1,2,3], faces, 
											colouredFaceEdgePaths, true );

		surf := WildSimplicialSurfaceByColouredFaceEdgePathsNC( 
						vertices, faces, colouredFaceEdgePaths );

		return surf;
	end
);
	RedispatchOnCondition( WildSimplicialSurfaceByColouredFaceEdgePaths, true,
		[ IsList, IsList, IsList], [ IsSet, IsSet, ], 0 );

	#	Implement alternative callings
	InstallOtherMethod( WildSimplicialSurfaceByColouredFaceEdgePaths,
		"", [ IsPosInt, IsObject, IsList ],
		function( vertices, faces, colouredFaceEdgePaths )
			return WildSimplicialSurfaceByColouredFaceEdgePaths(
				[1..vertices], faces, colouredFaceEdgePaths );
		end
	);

	InstallOtherMethod( WildSimplicialSurfaceByColouredFaceEdgePaths,
		"", [ IsSet, IsPosInt, IsList ],
		function( vertices, faces, colouredFaceEdgePaths )
			return WildSimplicialSurfaceByColouredFaceEdgePaths(
				vertices, [1..faces], colouredFaceEdgePaths );
		end
	);
		RedispatchOnCondition( WildSimplicialSurfaceByColouredFaceEdgePaths, 
			true, [ IsList, IsPosInt, IsList ], [ IsSet, , ], 0 );


##
##							End of constructors
##
#############################################################################
#############################################################################



#############################################################################
##
#! @Description
#! Return the group that is generated by the generators of the wild simplicial
#! surface.
#! @Arguments a wild simplicial surface
#! @Returns a group
#!
InstallMethod( GroupOfWildSimplicialSurface, 
	"for a wild simplicial surface", [ IsWildSimplicialSurface ],
	function(simpsurf)
		return Group( Generators(simpsurf) );
	end
);

#############################################################################
##
#!	@Description Given a wild coloured simplicial surface <simpsurf>, this
#!  function determines the vertex group of the simplicial surface.
#!  The vertex group of the simplicial surface <simpsurf> is defined to be
#!  $F_3/R$, where $F_3$ is the free group on three generators and $R$ is 
#!  the set of relations given by the vertex defining paths.
#!  @Returns finitely presented group.
#!
# TODO only defined for all inner vertices
##
InstallMethod( VertexGroup, 
	"for a wild simplicial surface", [ IsWildSimplicialSurface ],
	function(simpsurf)

        local fepath, rels, r,  i, fgrp;

        fgrp := FreeGroup(Length(Generators(simpsurf)));
        rels := [fgrp.1^2, fgrp.2^2, fgrp.3^2];

        for fepath in ColouredFaceEdgePathsOfVertices(simpsurf) do
            # check if fepath is closed
            if IsOddInt(Length(fepath)) then 
				continue; 
			fi;
 
            r := One(fgrp); 
            for i in [ 1,3 .. Length(fepath)-1] do 
                r := r * fgrp.(fepath[i]);
            od;
            Add(rels, r); 
        od;

        return [fgrp,Set(rels)];

	end
);




#############################################################################
##
#!	@Description Given a wild coloured simplicial surface <simpsurf>, this
#!  function determines the mr-type of each of the edges of <simpsurf>.
#!  The mr-type of an edge of <simpsurf> is either "m" (for mirror) or 
#!  "r" (for rotation). It is defined as followed. 
#!  Suppose the edge  $e$ is incident to the vertices $v_1$ and 
#!  $v_2$ and to the two faces $F$ and $F'$. Let $x$ and $y$ be the edges of
#!  incident  incident to $F$ and $F'$ and to the same vertex $v_1$, say.
#!  Then $e$ is of type $m$ if both $x$ and $y$ have the same colour, and $e$
#!  is of type $r$ if $x$ and $y$ are different. As we assume the surface to
#!  be wild coloured, this means that the colours of the other edges incident 
#!  to $e$ and both faces $F$ and $F'$ are then also determined. As the # $'$
#!  edges of the simplicial surface are pairs of points, the mr-type of 
#!  the simplicial surface <simpsurf> can be encoded as a list of length 3. 
#!   Each of the
#!  entries is in turn  a list encoding the mr-type of all edges of a 
#!  certain colour. Suppose that mrtype[1] is the list encoding the mr-type
#!  of the red edges. Then mrtype[1][i] = 0 if the mr-type of the red edge
#!  incident to the vertex i is unknown, mrtype[1][i] = 1 if the mr-type of 
#!  the red edge incident to the vertex i is "m", and mrtype[1][i] = 2 if 
#!  the mr-type of the red edge incident to the vertex i is "r". 
#!  @Returns a list of three lists, each of which contains the 
#!  entries 0, 1 or 2.
#!  @Arguments <simpsurf>, a simplicial surface object as created 
#!  by WildSimplicialSurface
#!  @BeginExample
#! MrType(tetra);
#! @EndExample
#!
InstallMethod( MRTypeOfEdgesAsNumbers, 
	"for a wild simplicial surface", [ IsWildSimplicialSurface ],
	function(simpsurf)

        local mrtype, edge, verts, faces, edges1, edges2, edgevertex1, edgevertex2;


        mrtype := [];

        for edge in Edges(simpsurf) do
            if Length(FacesOfEdges(simpsurf)[edge]) = 1 then # boundary edge
                mrtype[edge] := 0;
            else
               verts := VerticesOfEdges(simpsurf)[edge];
               faces := FacesOfEdges(simpsurf)[edge];
               edges1 := EdgesOfFaces(simpsurf)[faces[1]];  # edges of face1
               edges2 := EdgesOfFaces(simpsurf)[faces[2]];  # edges of face2
               edges1 := Difference( edges1, [edge]); # Other edge incident to face1 and edge
               edges2 := Difference( edges2, [edge]); # Other edge incident to face2 and edge
               edgevertex1 := Intersection(edges1,EdgesOfVertices(simpsurf)[verts[1]]);
               edgevertex2 := Intersection(edges2,EdgesOfVertices(simpsurf)[verts[1]]);
               if not Length(edgevertex1) = 1 or not Length(edgevertex2) = 1 then
                   Error("MRTypeOfEdgesAsNumbers: incorrect intersection at edge");
               fi;
               if ColourOfEdge(simpsurf,edgevertex1[1]) = 
						ColourOfEdge(simpsurf,edgevertex2[1]) then
                   mrtype[edge] := 1; # mirror
               else
                   mrtype[edge] := 2; # rotation
               fi;
            fi;
        od;

        return mrtype;
     
	end
);
InstallMethod( MRTypeOfEdges, 
	"for a wild simplicial surface", [ IsWildSimplicialSurface ],
	function(simpsurf)

        local f;
       
        f := function(e) 
            if e = 0 then return "border";
            elif e = 1 then return "mirror";
            elif e = 2 then return "rotation";
            else Error("MRTypeOfEdges: unknown mr type number");
            fi;
        end;

        return List(MRTypeOfEdgesAsNumbers(simpsurf), i-> f(i) );
	end
);


InstallMethod( Generators, "for a wild simplicial surface", 
	[ IsWildSimplicialSurface ],
	function( surf )
		local col, edges, gens, toList, facesOfEdge, edge;

		gens := [];
		for col in [1,2,3] do
			# Find all edges of this colour
			edges := EdgesOfColourNC( surf, col );

			# Construct the involution from a list 
			toList := [1..Maximum(Faces(surf))];

			for edge in edges do
				facesOfEdge := FacesOfEdges(surf)[edge];
				if Length(facesOfEdge) = 2 then
					toList[ facesOfEdge[1] ] := facesOfEdge[2];
					toList[ facesOfEdge[2] ] := facesOfEdge[1];
				fi;
			od;

			gens[col] := PermList( toList );
		od;

		return gens;
	end
);


##############################################################################
##############################################################################
##
##					Start of the coloured edge part
##
##
##	There are four attributes that are concerned with edge colourings:
##		- ColoursOfEdges
##		- ColouredEdgesOfFaces
##		- ColouredFaceEdgePathsOfVertices
##		- EdgesOfColour
##
##	All of them will be a part of the method selection graph
InstallMethod( ColoursOfEdges, "for a wild simplicial surface", 
	[ IsWildSimplicialSurface ],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
										ColoursOfEdges, surf);
	end
);
InstallMethod( ColouredEdgesOfFaces, "for a wild simplicial surface", 
	[ IsWildSimplicialSurface ],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
										ColouredEdgesOfFaces, surf);
	end
);
InstallMethod( ColouredFaceEdgePathsOfVertices, "for a wild simplicial surface", 
	[ IsWildSimplicialSurface ],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
										ColouredFaceEdgePathsOfVertices, surf);
	end
);
InstallMethod( EdgesOfColours, "for a wild simplicial surface", 
	[ IsWildSimplicialSurface ],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
										EdgesOfColours, surf);
	end
);


###############################
##
##	Next we give computations for all attributes
##

##
##	We compute ColoursOfEdges
##
InstallMethod( ColoursOfEdges, 
	"for a wild simplicial surface that has ColouredEdgesOfFaces",
	[ IsWildSimplicialSurface and HasColouredEdgesOfFaces and HasEdges and
		HasFacesOfEdges ],
	function( surf )
		local colEdges, edge, facesOnEdge, edgesInFace;

		colEdges := [];

		for edge in Edges(surf) do
			facesOnEdge := FacesOfEdges(surf)[edge];
			edgesInFace := ColouredEdgesOfFaces(surf)[ facesOnEdge[1] ];
			colEdges[edge] := Position( edgesInFace, edge );
		od;

		return colEdges;
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"ColoursOfEdges", ["ColouredEdgesOfFaces", "Edges", "FacesOfEdges"] );

InstallMethod( ColoursOfEdges, 
	"for a wild simplicial surface that has EdgesOfColours",
	[ IsWildSimplicialSurface and HasEdgesOfColours and HasEdges ],
	function( surf )
		local coloursOfEdges, edge, col;

		coloursOfEdges := [];
		for edge in Edges do
			for col in [1,2,3] do
				if edge in EdgesOfColourNC( surf, col ) then
					coloursOfEdges[edge] := col;
				fi;
			od;
		od;

		return coloursOfEdges;
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"ColoursOfEdges", ["EdgesOfColours", "Edges"] );
	

##
##	We compute ColouredEdgesOfFaces
##

InstallMethod( ColouredEdgesOfFaces, 
	"for a wild simplicial surface that knows its edge colours",
	[ IsWildSimplicialSurface and HasColoursOfEdges and HasFaces and 
		HasEdgesOfFaces ],
	function( surf )
		local edges, colEdgesOfFaces, face, colEdges;

		colEdgesOfFaces := [];
		for face in Faces(surf) do
			edges := EdgesOfFaces(surf)[face];
			colEdges := List( edges, e -> ColourOfEdge(surf,e) );

			colEdgesOfFaces[face] := List( [1,2,3], i -> 
											edges[ Position( colEdges, i ) ] );
		od;

		return colEdgesOfFaces;
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"ColouredEdgesOfFaces", ["ColoursOfEdges", "Faces", "EdgesOfFaces"] );


##
##	We compute ColouredFaceEdgePathsOfVertices
##

InstallMethod( ColouredFaceEdgePathsOfVertices, "for a wild simplicial surface",
	[ IsWildSimplicialSurface and HasColoursOfEdges and 
			HasFaceEdgePathsOfVertices ],
	function( surf )
		local GiveEdgesColour;

		GiveEdgesColour := function( index, entry )
			if IsEvenInt(index) then
				return entry;
			else
				return ColourOfEdge(surf,entry);
			fi;
		end;

		return List( FaceEdgePathsOfVertices(surf), path ->
						List( [1..Length(path[1])], i -> 
								GiveEdgesColour(i, path[1][i] ) ) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"ColouredFaceEdgePathsOfVertices", 
		["ColoursOfEdges", "FaceEdgePathsOfVertices"] );

##
##	We compute EdgesOfColours
##
InstallMethod( EdgesOfColours, 
	"for a wild simplicial surface with ColoursOfEdges",
	[ IsWildSimplicialSurface and HasColoursOfEdges and HasEdges ],
	function( surf )
		return List( [1,2,3], col -> 
				Filtered( Edges(surf), e -> ColourOfEdgeNC(surf,e) = col ) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"EdgesOfColours", ["ColoursOfEdges", "Edges"] );

InstallMethod( EdgesOfColours, 
	"for a wild simplicial surface with ColouredEdgesOfFaces",
	[ IsWildSimplicialSurface and HasColoursOfEdges ],
	function( surf )
		return List( [1,2,3], col ->
				Set( List( ColouredEdgesOfFaces, edges -> edges[col] ) ) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"EdgesOfColours", "ColouredEdgesOfFaces" );

#######################
##
##	Now we describe the implications of the coloured edges on the incidence
##	geometry.
##

##
##	Implications from ColoursOfEdges
##
InstallMethod( Edges, "for a wild simplicial surface with ColoursOfEdges",
	[ IsWildSimplicialSurface and HasColoursOfEdges ],
	function( surf )
		return __SIMPLICIAL_BoundEntriesOfList( ColoursOfEdges(surf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"Edges", "ColoursOfEdges" );


##
##	Implications from ColouredEdgesOfFaces
##
InstallMethod( Faces, "for a wild simplicial surface with ColouredEdgesOfFaces",
	[ IsWildSimplicialSurface and HasColouredEdgesOfFaces ],
	function( surf )
		return __SIMPLICIAL_BoundEntriesOfList( ColouredEdgesOfFaces(surf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"Faces", "ColouredEdgesOfFaces" );

InstallMethod( EdgesOfFaces, 
	"for a wild simplicial surface with ColouredEdgesOfFaces",
	[ IsWildSimplicialSurface and HasColouredEdgesOfFaces ],
	function( surf )
		return List( ColouredEdgesOfFaces(surf), edges -> Set(edges) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"EdgesOfFaces", "ColouredEdgesOfFaces" );

##
##	Implications from ColouredFaceEdgePathsOfVertices
##
InstallMethod( FaceEdgePathsOfVertices, 
	"for a simplicial surface that already has coloured face-edge-paths",
	[ IsSimplicialSurface and HasColouredFaceEdgePathsOfVertices and 
		HasVerticesAttributeOfSimplicialSurface and HasColouredEdgesOfFaces ],
	function( surf )
		local faceEdgePaths, vertex, colPath, newPath, i;

		faceEdgePaths := [];
		for vertex in Vertices(surf) do
			colPath := ColouredFaceEdgePathsOfVertices(surf)[vertex];
			newPath := ShallowCopy( colPath );

			newPath[1] := ColouredEdgeOfFaceNC( surf, colPath[2], colPath[1] );
			for i in [3..Length(colPath)] do
				if IsOddInt(i) then
					newPath[i] := ColouredEdgeOfFaceNC( surf, 
											colPath[i-1], colPath[i] );
				fi;
			od;
			faceEdgePaths[vertex] := [ newPath ];
		od;

		return faceEdgePaths;
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"FaceEdgePathsOfVertices", ["ColouredFaceEdgePathsOfVertices", 
			"ColouredEdgesOfFaces",	"VerticesAttributeOfSimplicialSurface"] );

InstallMethod( VerticesAttributeOfSimplicialSurface, 
	"for a simplicial surface with ColouredFaceEdgePathsOfVertices",
	[ IsSimplicialSurface and HasColouredFaceEdgePathsOfVertices ],
	function( surf )
		return __SIMPLICIAL_BoundEntriesOfList( 
							ColouredFaceEdgePathsOfVertices(surf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"VerticesAttributeOfSimplicialSurface", 
		"ColouredFaceEdgePathsOfVertices" );

InstallMethod( FacesOfVertices, 
	"for a simplicial surface with ColouredFaceEdgePathsOfVertices",
	[ IsSimplicialSurface and HasColouredFaceEdgePathsOfVertices ],
	function( surf )
		return List( ColouredFaceEdgePathsOfVertices(surf), path -> 
								__SIMPLICIAL_EvenEntriesOfList(path) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH,
		"FacesOfVertices", "ColouredFaceEdgePathsOfVertices" );

##
##	Implications from EdgesOfColours
##
InstallMethod( Edges, "for a simplicial surface with EdgesOfColours",
	[ IsSimplicialSurface and HasEdgesOfColours ],
	function( surf )
		return Union( EdgesOfColours( surf ) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"Edges", "EdgesOfColours" );

##
##			End of the coloured edge part
##
##############################################################################
##############################################################################

##
##	Now we implement the convenience methods for easier access to the 
##	coloured edge attributes.
##

InstallMethod( ColourOfEdgeNC,
	"for a wild simplicial surface", [ IsWildSimplicialSurface, IsPosInt ],
	function(simpsurf,edge)

        return ColoursOfEdges(simpsurf)[edge];
    end
);
InstallMethod( ColourOfEdge,
	"for a wild simplicial surface", [ IsWildSimplicialSurface, IsPosInt ],
	function(simpsurf,edge)

        if not edge in Edges(simpsurf) then 
            Error("ColourOfEdge: edge not an edge of given surface");
        fi;

        return ColourOfEdgeNC(simpsurf,edge);
	end
);


InstallMethod( ColouredEdgeOfFaceNC,
	"for a wild simplicial surface, a face and a colour (positive integers)", 
	[ IsWildSimplicialSurface, IsPosInt, IsPosInt ],
	function(simpsurf, face, colour)
		return ColouredEdgesOfFaces( simpsurf )[face][colour];
	end
);

InstallMethod( ColouredEdgeOfFace,
	"for a wild simplicial surface, a face and a colour (positive integers)", 
	[ IsWildSimplicialSurface, IsPosInt, IsPosInt ],
	function(simpsurf, face, colour)
		if not face in Faces(simpsurf) then
			Error("ColouredEdgeOfFace: Given face has to be a face of the given surface.");
		fi;
		if not colour in [1,2,3] then
			Error("ColouredEdgeOfFace: Given colour has to lie in [1,2,3].");
		fi;
		return ColouredEdgeOfFaceNC( simpsurf, face, colour);
	end
);


InstallMethod( ColouredFaceEdgePathOfVertexNC, 
	"for a wild simplicial surface and a positive integer", 
	[ IsWildSimplicialSurface, IsPosInt ],
	function( surf, vertex )
		return ColouredFaceEdgePathsOfVertices(surf)[vertex];
	end
);

InstallMethod( ColouredFaceEdgePathOfVertex, 
	"for a wild simplicial surface and a positive integer", 
	[ IsWildSimplicialSurface, IsPosInt ],
	function( surf, vertex )
		if not vertex in Vertices(surf) then
			Error("ColouredFaceEdgePathsOfVertex: Given vertex has to be a vertex of the given wild simplicial surface.");
		fi;
		return ColouredFaceEdgePathOfVertexNC(surf,vertex);
	end
);

InstallMethod( EdgesOfColourNC,
	"for a wild simplicial surface", [ IsWildSimplicialSurface, IsPosInt ],
	function(simpsurf,colour)

        return EdgesOfColours(simpsurf)[colour];
    end
);
InstallMethod( EdgesOfColour,
	"for a wild simplicial surface", [ IsWildSimplicialSurface, IsPosInt ],
	function(simpsurf,colour)

        if not colour in [1,2,3] then 
            Error("EdgesOfColour: given colour has to be 1, 2 or 3.");
        fi;

        return EdgesOfColourNC(simpsurf,colour);
	end
);


InstallMethod( EdgeByFacesAndColourNC, "for a wild simplicial surface", 
	[ IsWildSimplicialSurface, IsSet, IsPosInt ],
	function( surface, faces, colour )
		local possEdges, found;

		possEdges := EdgesOfColour( surface, colour );
		found := Filtered( possEdges, e -> FacesOfEdges(surface)[e] = faces );

		if Length(found) <> 1 then
			Error("EdgeByFacesAndColour: No unique edge found.");
		fi;

		return found[1];
	end
);
	RedispatchOnCondition( EdgeByFacesAndColourNC, true,
		[ IsWildSimplicialSurface, IsList, IsPosInt ], [ , IsSet, ], 0 );
InstallMethod( EdgeByFacesAndColour, "for a wild simplicial surface", 
	[ IsWildSimplicialSurface, IsSet, IsPosInt ],
	function( surface, faces, colour )
		if not colour in [1,2,3] then
			Error("EdgeByFacesAndColour: Given colour has to be 1, 2, or 3.");
		fi;

		return EdgeByFacesAndColourNC( surface, faces, colour );
	end
);
	RedispatchOnCondition( EdgeByFacesAndColour, true,
		[ IsWildSimplicialSurface, IsList, IsPosInt ], [ , IsSet, ], 0 );


##############################################################################
##############################################################################
##
##			Start of big (quasi-constructor) methods
##
##

InstallOtherMethod( AllWildSimplicialSurfaces, 
	"for three involutions",
	[ IsPerm, IsPerm, IsPerm ], function( perm1, perm2, perm3 )
		return AllWildSimplicialSurfaces( perm1, perm2, perm3 , [] );
	end
);

InstallOtherMethod( AllWildSimplicialSurfaces, 
	"for three involutions and a list that encodes the edge-types",
	[ IsPerm, IsPerm, IsPerm, IsList ], function( perm1, perm2, perm3, mrtype )
		return AllWildSimplicialSurfaces( [perm1, perm2, perm3], mrtype );
	end
);

InstallOtherMethod( AllWildSimplicialSurfaces, 
	"for a group",
	[ IsGroup ], function( grp )
		return AllWildSimplicialSurfaces( grp, [] );
	end
);

InstallOtherMethod( AllWildSimplicialSurfaces, 
	"for a group and a list that encodes the edge-types",
	[ IsGroup, IsList ], function( grp, mrtype )
		return AllWildSimplicialSurfaces( GeneratorsOfGroup(grp), mrtype );
	end
);


InstallOtherMethod( AllWildSimplicialSurfaces, 
	"for a list of three involutions",
	[ IsList ], function( gens )
		return AllWildSimplicialSurfaces( gens, [] );
	end
);

BindGlobal( "__SIMPLICIAL_ConvertWildLegacyIntoModern", 
	function( faces, edgeCycles, vertexPaths, gens )
	
	local nrCycles, edges, edgeColours, facesOfEdges, vertices, 
              edgesOfVertices, FindEdges, surf, EmptySetIfRealFace, 
              colEdgesOfFaces, col, i, f;

	nrCycles := Length(edgeCycles[1]);

	# The faces stay the same

	# The edges will be modified
	edges := [1..3*nrCycles];

	edgeColours := List( [1..nrCycles], i -> 1 );
	Append( edgeColours, List( [1..nrCycles], i -> 2 ) );
	Append( edgeColours, List( [1..nrCycles], i -> 3 ) );

	facesOfEdges := ShallowCopy( edgeCycles[1] );
	Append( facesOfEdges, edgeCycles[2] );
	Append( facesOfEdges, edgeCycles[3] );

	EmptySetIfRealFace := function( f )
		if f in faces then
			return [];
		fi;
		return;
	end;
	colEdgesOfFaces := List( [1..Maximum(faces)], i -> EmptySetIfRealFace(i) );
	for col in [1,2,3] do
		for i in [1..nrCycles] do
			for f in edgeCycles[col][i] do
				colEdgesOfFaces[f][col] := (col - 1)*nrCycles + i;
			od;
		od;
	od;


	# We define the wild simplicial surface before we manage the vertices
	# since we can profit from some code. We only have to be careful to not
	# call any methods that require unknown attributes.
	surf := Objectify( WildSimplicialSurfaceType, rec() );
	SetEdges( surf, edges );
	SetFaces( surf, faces );
	SetFacesOfEdges( surf, facesOfEdges );
	SetGenerators( surf, gens );
	SetColoursOfEdges( surf, edgeColours );
	SetColouredEdgesOfFaces( surf, colEdgesOfFaces );


	# The vertices have to be modified
	vertices := [1..Length(vertexPaths)];

	# The function FindEdges returns a set of all edges that are incident to
	# the given vertex
	FindEdges := function( vertexNr )
		local path, edges, possibleEdges, pathElement;

		path := vertexPaths[vertexNr];
		edges := [];

		for pathElement in path do
			possibleEdges := EdgesOfFaces(surf)[pathElement[1]];

			# Now we have to find the edges that conform to the 
                        # colours in pathElement[2] and pathElement[3]
			Append( edges, 
				[ ColouredEdgeOfFace(surf, pathElement[1], pathElement[2] ), 
				ColouredEdgeOfFace(surf, pathElement[1], pathElement[3] ) ] );
		od;

		return Set(edges);
	end;

	edgesOfVertices := List( vertices, i -> FindEdges(i) );


	# We have to set the final attributes
	SetVerticesAttributeOfSimplicialSurface( surf, vertices );
	SetEdgesOfVertices( surf, edgesOfVertices );
   #MB     SetFaceEdgePathsOfVertices( surf, vertexPaths );

	DeriveLocalOrientationAndFacesNamesFromIncidenceGeometryNC(surf);

	return surf;
end);


InstallMethod( AllWildSimplicialSurfaces, 
	"for a list of three involutions and a list that encodes the edge-types", 
    [IsList, IsList], function(gens, mrtype)

	local faces, edges, vertices, grp, i, j, k, 
          allvtxnames, completedvertices, nrvtsface, 
          FirstFreeVertex,  FindWildSimplicialSurface, 
          AllSurfaces, level, n, allvertices, IsMirror, IsRotation,  
          LoopOneVertexSignedWithBoundary,  faceinverse,
          BreakPoint,         knownmrtype, cmpvertices;

	# Check whether the given arguments are correct
	if Length(gens) <> 3 then
         Error("AllWildSimplicialSurfaces( gens[, mrtype] ) : There have to be three generators given.\n");
    fi;
    if not IsPerm(gens[1]) or not IsPerm(gens[2]) or not IsPerm(gens[3]) then
         Error("AllWildSimplicialSurfaces( gens[, mrtype] ) : The generators have to be permutations.\n");
    fi;
    if gens[1]^2 <> One(gens[1]) or gens[2]^2 <> One(gens[2]) 
        or gens[3]^2 <> One(gens[3]) then
         Error("AllWildSimplicialSurfaces( gens[, mrtype] ) : The generators have to be involutions.\n");
    fi;

    if not Length(mrtype) in [0,3] then
         Error("AllWildSimplicialSurfaces( gens[, mrtype] ) : The edge types have to be given as a list with up to three elements.\n");
    fi;


	# Start the actual computations

cmpvertices := function (v1, v2 )

    if Length(v1) < Length(v2 ) then return true;
    elif Length(v1) > Length(v2) then return false;
    fi;
    # now they have the same length
    return v1 < v2;

end;


    BreakPoint := false;
    faces := ShallowCopy(MovedPoints(gens)); # is a set, therefore sorted
    n := Length(faces);
    faceinverse := List([1..n],i->0);

    # store the position of face in in faces to avoid searching
    for i in faces do
        faceinverse[i] := Position(faces,i);
    od;

    for i in [ 1 .. 3] do
        for j in [i+1 .. 3] do
            if NrMovedPointsPerm( gens[i] * gens[j] ) <> n then
                Print("Warning: Simplicial surface not vertex transitive\n");
            fi;
        od;
    od;
 

    # if the argument mrtype was an empty list, then set all
    # mr-types to 0 - meaning unknown.       
    if Length(mrtype) = 0 then
        knownmrtype := false;
        mrtype := [];
        mrtype [1] := List( [1 .. n], i-> 0 );
        mrtype [2] := List( [1 .. n], i-> 0 );
        mrtype [3] := List( [1 .. n], i-> 0 );
    else
        knownmrtype := true;
    fi;

    # mirror has mr-type 1
    IsMirror := function( g, i )
        return mrtype[g][faceinverse[i]]=1;
    end;

    # rotation has mr-type 2
    IsRotation := function( g, i )
        return mrtype[g][faceinverse[i]]=2;
    end;

    # unknown has mr-type 0

    # now  we know that the simplicial surface is vertex transitive
    # this implies in particular that any 2-cycle only occurs in one
    # generator
    grp := Group(gens);

    # the edges are the 2-cycles of the transposition. We colour
    # the edges according to the permutation sigi which gave rise
    # to them. Note that no edge can arise from two different
    # permutations.
    edges := [Cycles(gens[1],faces),Cycles(gens[2],faces),Cycles(gens[3],faces)];
    vertices := [];

    # we now make a list of all possible vertices. This list will
    # contain a particular vertex several times under several different
    # names. A vertex is described by all triples (i,a,b) such a<b and
    # that the vertex is adjacent to face i and has edges in gens[a] and gens[b].
    allvertices := [];
    for i in [ 1 .. n ] do
        for j in [ 1 .. 3] do
            for k in [j+1 .. 3] do
                # k > j 
                Add(allvertices,[faces[i],j,k]);
            od;
        od;
    od;
    #(f-1)*3 + (i-1)*2 + j-i
    # 12 -> +1
    # 13 -> +2
    # 23 -> +3

    #
    # The following function finds all vertex defining paths
    # around the vertex vtx when moving next with g around the vertex.
    # For example, one such class could be [ (1,a,b), (4,a,c), (6,b,c) ]
    # in particular this means that the vertices in one class yield a word
    # either fixing all faces on the path or from a face with a boundary
    # to another face with a boundary.
    # In the given example acb is a word such that
    # 1acb = 1 or, more specifically, 1a = 4, 4c=6, 6b = 1.
    #
    LoopOneVertexSignedWithBoundary :=
            function(vtx,g,vtxnames,completedvertices,nrvtsface)
            local  h, fac, i, j, pj, k, x, knownfaces, nvtx, nvtxnames,
                   vtxnames_c, completedvertices_c, nrvtsface_c, poss;

            # all already known names for this vertex 
            # - known to be valid up to here
            # all already known faces incident to this vertex
            knownfaces := List(vtxnames, i-> i[1]);

            i := vtx[1]; # the face
            # consider each of the other two generators different to g

#           PrintVertexLabels( gens, vtxnames ); Print("\n");

            j :=  i^gens[g];
            if i = j then
                    # we have a boundary vertex
                    # back to the current starting point of the path
                    # and continue from there
                    if Length(vtxnames) = 1 then
                       # we are starting out with a boundary vertex
                       # but marching in the wrong direction so turn around
                       if vtx[2]=g then g := vtx[3];
                       else g := vtx[2]; fi;
#                      g := Difference(vtx[2],[g]);
#                      g := g[1];
                       j := i^gens[g];
                    else
                       # now we know that we are at the end of a 
                       #  path of length at least 2
                       # reverse path and continue at vertex at other end
                       vtx := vtxnames[1];
                       i := vtx[1];
                       g := [];
                       if i^gens[vtx[2]] <> vtxnames[2][1] then g := [vtx[2]];
                       elif i^gens[vtx[3]] <> vtxnames[2][1] then g := [vtx[3]];
                       fi;
#                      g := Filtered(vtx{[2,3]}, j-> i^gens[j]<>vtxnames[2][1]);
                       if g = [] then
                           # we found an ear
                           Print("we found an ear\n");
                       else
                           g := g[1];
                           j := i^gens[g];
                           vtxnames := Reversed(vtxnames);
                       fi;
                    fi;
            fi;


            if not j in knownfaces then


                # if the edge of face j opposite the given vertex is
                # known, then we have no choice 
#                x := PositionsProperty(allvertices, 
#                     v->(v[1]=j and (v[2] = g or v[3]=g)) );
                x := (faceinverse[j]-1)*3;
                if g = 1 then x := [x+1,x+2];
                elif g=2 then x := [x+1,x+3];
                else  x := [x+2,x+3]; fi;
                # x are the positions of the two vertices adjacent to j 
                # meeting the edge g from i to j 

                # work out whether we have 
                # a mirror (m) or a rotation (r) edge
                if mrtype[g][faceinverse[i]]=1 then
#                if IsMirror( g, i ) then  # h i g j -> use h next
                    # if g is an m-edge the we use the same generator
#                    poss := Difference( vtx{[2,3]}, [g] );
                    if g = vtx[2] then poss:= [vtx[3]]; 
                    elif g = vtx[3] then poss:=[vtx[2]];
                    else poss := [vtx[2],vtx[3]]; fi;
                elif mrtype[g][faceinverse[i]]=2 then
#                elif IsRotation( g, i ) then # h i g j -> use neither h, g next
                    # if g is an r-edge the we use the other generator
                     poss := [6-vtx[2]-vtx[3]];
#                    poss := Difference( [1..3], vtx{[2,3]} );
                else 
                    # the edge is not known, so just do not use g
#                    poss := Difference([1..3],[g]);
                    if g=1 then poss:=[2,3]; elif g=2 then poss:=[1,3]; 
                    else poss := [1,2]; fi;
                fi;
                if completedvertices[x[1]] then 
                    # the vertex is known. Do not consider the 
                    # generator on that vertex as it is already on face j
                    poss := Difference(poss,allvertices[x[1]]{[2,3]}); 
                elif completedvertices[x[2]] then 
                    poss := Difference(poss,allvertices[x[2]]{[2,3]});    
                fi;

                if poss = [] then # Print("contradiction "); 
                return; fi;
                # Error(); fi;

                # we have not seen this face around the vertex yet
                for h in poss  do
                    # modify a new copy of vtxnames
                    vtxnames_c := ShallowCopy(vtxnames);
                    completedvertices_c := ShallowCopy(completedvertices);
                    nrvtsface_c := ShallowCopy(nrvtsface);
                    # choose to continue with vertex {j,g,h}
                        # the vertex we are adding is making g into a
                        # mirror if [g,h] was also in previous vertex
                        k := Length(vtxnames_c);
                        if k > 0 and g < h then
                            if vtxnames_c[k][2]=g and 
                               vtxnames_c[k][3]=h and 
                               mrtype[g][faceinverse[j]]=2 then
                               # g should be a rotation but is a mirror
                               return;
                            elif vtxnames_c[k][2]<>h and 
                               vtxnames_c[k][3]<> h and 
                               mrtype[g][faceinverse[j]]=1 then
                               # g should be a mirror but is a rotation
                               return;
                            fi;
                    #   elif k > 0 and h < g then
# TODO: What was this and why is it commented out?                   
#                            if vtxnames_c[k][2]=h and 
#                               vtxnames_c[k][3]=g and 
#                               mrtype[g][faceinverse[j]]=2 then
#                               # g should be a rotation but is a mirror
#                               Print("YEAH2\n"); return;
#                            elif vtxnames_c[k][2]<>h and 
#                               vtxnames_c[k][3]<> h and 
#                               mrtype[g][faceinverse[j]]=1 then
#                               # g should be a mirror but is a rotation
#                               Error("YEAH2A\n"); return;
#                            fi;
                        fi;
                    if g < h then
                        Add( vtxnames_c, [j,g,h] );
#                        k := Position(allvertices,[j,g,h]); # slow code
                        k := (faceinverse[j]-1)*3 + (g-1)*2 + h-g;
                    else
                        Add( vtxnames_c, [j,h,g] );
#                        k := Position(allvertices,[j,h,g]); # slow code
                        k := (faceinverse[j]-1)*3 + (h-1)*2 + g-h;
                    fi;
                    # record that the vertex has been used again
                    if completedvertices_c[k]  then
                        # a vertex  can only be completed once - 
                        # so this is no solution
                        return;
                    fi;
                    completedvertices_c[k] := true;
                    pj := faceinverse[j];
                    nrvtsface_c[pj] := nrvtsface[pj]+1;
                    if nrvtsface_c[pj] > 3 then
                        # a face can only have 3 vertices - 
                        # so this is no solution
                        return;
                    fi;
                    # continue on with h               
                    nvtx := [j,g,h];
                    if h < g then nvtx  := [j,h,g]; fi;
                    LoopOneVertexSignedWithBoundary(nvtx, h,vtxnames_c,
                                  completedvertices_c,nrvtsface_c);
                    # Then continue with the next h.
                od;

            else # now j in knownfaces 
                # we found the face j twice around the vertex

                if i = j then
                    # we found the other  boundary of a vertex
                    Add(allvtxnames,[vtxnames,completedvertices,nrvtsface]);
                    return;
                elif j <> vtxnames[1][1] then
                   # we are not back at the start - so this is illegal
                   return;
                else
                   # we are back at the start, hence g must be
                   # an edge of the starting face!
                   if g <> vtxnames[1][2] and g <> vtxnames[1][3] then
                       # we did not end up where we started with g
                       return;
                   else
                       # we are at the start so add 
                       # but let the vertex start with smallest face
                       if vtxnames[1]<>Minimum(vtxnames) then
                            k := Position(vtxnames,Minimum(vtxnames));
                            nvtxnames := vtxnames{[k..Length(vtxnames)]};
                            Append(nvtxnames, vtxnames{[1..k-1]});
                            vtxnames := nvtxnames;
                       fi;
                       Add(allvtxnames,[vtxnames,completedvertices,nrvtsface]);
                       return;
                   fi;
                fi;
             fi; # if not j in knownfaces 
            return;
        end;

   
    # The following function finds the first free vertex adjacent
    # to a face for which as many vertices are known as possible

    FirstFreeVertex := function(completedvertices, nrvtsface)

        local face, v;
        
        # first find a face with as many know vertices as possible
        if 2 in nrvtsface then 
             face := faces[PositionProperty( nrvtsface, f-> f = 2 )];
        elif 1 in nrvtsface then
             face := faces[PositionProperty( nrvtsface, f-> f = 1 )];
        elif 0 in nrvtsface then
             face := faces[PositionProperty( nrvtsface, f-> f = 0 )];
        else
            # finished
             return false;
        fi;
 
        # this is the face with the most known vertices
        for v in [1..Length(allvertices)] do
            if not completedvertices[v] and 
               allvertices[v][1] = face then
                return v;
            fi;
        od;

        return false;

    end;

    # Supposing that we have chosen an initial set of vertices,
    # we now try to add the next vertex to our surface, recursively
    # here vertices are the vertices of our surface known so far,
    # completedvertices is a binary list telling us which vertices 
    # are done, and nrvtsface the number of vertices per face for
    # the surfaces under construction

    FindWildSimplicialSurface := function(level,vertices,completedvertices,nrvtsface)
    
        local vtx, v, i, pi, g, h, vtxEquivalentnames, vertices_c, ss,
              allvtxnames_c, completedvertices_c, nrvtsface_c, Li, x, edges;


        # choose the first free vertex
        # It can be fixed from now on, since it has to be
        # somewhere in the surface
        v := FirstFreeVertex(completedvertices, nrvtsface);
#       Print("lv= ", level, " v= ", v, "\n");

        if v = false then
            ##  now we know that there is no more free vertex
            edges :=  List( gens, g-> Cycles(g,MovedPoints(gens)));

            Sort( vertices, cmpvertices );
			ss := __SIMPLICIAL_ConvertWildLegacyIntoModern( faces, edges, 
															vertices, gens );
            Add(AllSurfaces, ss );
#               Error("COMPLETED?\n");
            return;
        fi;

        vtx := allvertices[v];

        # Now we find all the different names for vtx
        i := vtx[1]; # the number of the face
        pi := faceinverse[i];
        g := vtx[2]; # the generator number labelling one edge
        h := vtx[3]; # the generator number  labelling the other edge
        vtxEquivalentnames := [vtx]; 

        completedvertices[v] := true;
        nrvtsface[pi] := nrvtsface[pi]+1;

        # We store for vertex vtx all its vertex defining paths in allvtxnames
        allvtxnames := [];
        LoopOneVertexSignedWithBoundary(vtx,g,vtxEquivalentnames, 
                                          completedvertices, nrvtsface);

#        Print("Starting Vertex: \n");
#        PrintVertexLabels( gens, vtxEquivalentnames );
 
       allvtxnames_c  := ShallowCopy(allvtxnames);

        for Li in allvtxnames_c do
             vertices_c := ShallowCopy(vertices);
             Add(vertices_c, Li[1]);
             completedvertices_c := ShallowCopy(Li[2]);
             nrvtsface_c := ShallowCopy(Li[3]);
             FindWildSimplicialSurface(level+1, vertices_c, completedvertices_c, 
                                               nrvtsface_c);

        od;
        
    end;


    # This is a global variable in which we shall store all
    # completed surfaces
    AllSurfaces := []; 

    # here we store whether a vertex has already been  completed
    completedvertices := BlistList([1..Length(allvertices)],[]);
    # in nrvtsface we store for each face how many vertices are known for
    # this face
    nrvtsface := List([1..n],i->0);
    level := 0;

    FindWildSimplicialSurface( level, [], completedvertices, nrvtsface); 

    return AllSurfaces;

end);

##
##
##		End of big (quasi-constructor) methods
##
##############################################################################
##############################################################################



#############################################################################
##
##  A Display method for simplicial surfaces
##
InstallMethod( Display, "for WildSimplicialSurfaces", [IsWildSimplicialSurface],
	function(simpsurf)
        local vtx, e, i, gens, f, mr, path, l;

        gens :=  Generators(simpsurf);
        Print("Generators = \n");
        f := Faces(simpsurf);

        for i in [ 1.. Length(gens) ] do
           e :=   Cycles(gens[i],f);
           Print( gens[i], "\n");
           mr := Filtered( e, c -> 
		MRTypeOfEdgesAsNumbers( simpsurf )[ 
			EdgeByFacesAndColour( simpsurf, c, i ) ] = 1 );
           Print("    mirrors  ", mr, "\n" );
           mr := Filtered( e, c -> 
		MRTypeOfEdgesAsNumbers( simpsurf )[ 
			EdgeByFacesAndColour( simpsurf, c, i ) ] = 2 );
           Print("    rotations ", mr, "\n" );
        od;
        
        Print("Faces = ", Faces(simpsurf), "\n");
        #e := Filtered( e , c -> Length(c) = 2);
        #Print("Edges = ", EdgesOfWildSimplicialSurface(simpsurf), "\n");

        Print("Vertices = \n");
        for vtx in Vertices(simpsurf) do
            Print("    " );
            path := ColouredFaceEdgePathOfVertex( simpsurf, vtx ); 
            l := Length(path);
            if IsOddInt(l) then Print("|"); fi;
            for i in [1..l] do
                if IsEvenInt(i) then Print(path[i]); 
                elif path[i]=1 then Print("a"); 
                elif path[i]=2 then Print("b"); 
                elif path[i]=3 then Print("c"); 
                else Error("Display: unknown entry in path");
                fi;
            od;
            if IsOddInt(l) then Print("|"); fi;
        od;
	Print("\n");
 
        Print("Degrees = ", UnsortedDegrees(simpsurf) );
	end
);

#!	@Description
#!   The function SixFoldCover takes as input a generic description of
#!   a simplicial surface.  The six fold cover of a simplicial surface is
#!   the following surface.
#!   If f is a face of the original face with edge numbers e_a, e_b and
#!   e_c, then the face is covered by the six faces of the form
#!   (f, e1, e2, e3), for which {e1, e2, e3}  = {e_a, e_b, e_c}.
#!   See Proposition 3.XX in the paper.
#!   @Arguments
#!
#!   If the optional argument mrtype is given, it has to be a list of length 
#!   3 and each entry has to be  $1$, or $2$. In this case the six fold cover 
#!   will treat the position $i$ for $i\in\{1,2,3\}$ of the three
#!   edges around a faces either as a   reflection (mirror), if the entry 
#!   in position $i$ of mrtype is 1, or as a rotation, if the entry in 
#!   position $i$ is 2. That is, the cover surface is generated by three
#!   transpositions $\sigma_i$ for $i=1,2,3$. For $i=1$, suppose $f$ and 
#!   $f'$ are faces of the surface surf such that the edges of $f$ are 
#!   $e_1, e_2$  and $e_3$ and the edges of $f'$ are  $e_1, e_a, e_b$ are 
#!   the edges $e_1, e_2$ and $e_a$ intersect in a common vertex and 
#!   the edges $e_1, e_3$ and $e_b$ intersect in a common vertex.
#!   For $i=1$ and  mrtype of position $1$ being  mirror (i.e. $1$), then 
#!   $$\sigma_1(f,e_1,e_2,e_3) = (f', e_1, e_a, e_b),$$ whereas if the 
#!   mrtype of position $1$ is a reflection (i.e. $2$), then 
#!   $$\sigma_1(f,e_1,e_2,e_3) = (f', e_1, e_b, e_a).$$ The definition
#!   of $\sigma_2$ and $\sigma_3$ are analogous, with $e_2$, respectively
#!   $e_3$ taking the role of the common edge $e_1.$
#!
#!   
#!   If the optional argument mredges is given, and mredges is a list of 
#!   length equal to the number of edges of the surface **surf** and an
#!   entry for an edge e is either 1 or 2. If the entry is 1 then 
#!   the six fold cover will treat the edge as a reflection (mirror) and 
#!   if the entry is 2  then the edge is treated as a rotation. 
#!
#!   The six fold cover is always a wild colourable simplicial surface.
#!   @Returns a wild coloured simplicial surface
#!   @Arguments surface, mrtype, bool
#!   if bool is true or not given, the mrtype specifies the behaviour of 
#!   the $\sigma_i$, if bool is false, the mrtype specifies the behaviour
#!   of the edges.
InstallMethod( SixFoldCover, "for a simplicial surface",
	[IsSimplicialSurface, IsList],
	function(simpsurf, mrtype)
		#TODO
	end
);
InstallOtherMethod( SixFoldCover, "for a simplicial surface",
	[IsSimplicialSurface],
	function( simpsurf )
		#TODO, probably call the method above
	end
);


#############################################################################
##
#!  @Description
#!  Check if two wild simplicial surfaces are equal.
#!  @Returns true or false
#!  @Arguments <s1>, <s2>, two wild simplicial surface objects
#!
##
InstallMethod( \=, "for two wild simplicial surfaces", IsIdenticalObj, 
  [ IsWildSimplicialSurface, IsWildSimplicialSurface ],
	function( s1, s2 )
		# check all basic attributes

		if ColoursOfEdges(s1) <> ColoursOfEdges(s2) then
			return false;
		fi;

        TryNextMethod();	# This will call \= for simplicial surfaces
	end
);


############################################################################
############################################################################
##
##			Start of more specialized methods from SimplicialSurface
##

#!	@Description
#!	This function checks if a wild simplicial surface is connected.
#!	@Returns true if connected, false otherwise
#!	@Arguments a wild simplicial surface object simpsurf
#!
InstallMethod( IsConnected, "for a wild simplicial surface",
	[IsWildSimplicialSurface],
	function(simpsurf)
		return Length( Orbits( GroupOfWildSimplicialSurface(simpsurf), 
									Faces(simpsurf) ) ) = 1;
	end
);


##
##			End of more specialized methods from SimplicialSurface
##
############################################################################
############################################################################

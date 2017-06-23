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

##
## In contrast to general simplicial surfaces, the edge colouring of wild
## simplicial surfaces allows a general procedure to define the local
## orientation of each face: Just take the orientation defined by the colour
## cycle (1,2,3). For this end we overload the method 
## DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC.
InstallOtherMethod( DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC,
    "for a wild simplicial surface", [IsWildSimplicialSurface],
    function( wildSurf )
        local edgeOrientation;

        edgeOrientation := ColouredEdgesOfFaces(wildSurf);
        SetLocalOrientationByEdgesAsList( wildSurf, edgeOrientation );

        # Set the face names
        SetIsFaceNamesDefault( wildSurf, true);
    end
);

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

		# set edge colouring attribute
		SetColoursOfEdges( surf, coloursOfEdges );

		# define other attributes of simplicial surface
		DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC( surf );

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

		# set edge colouring attribute
		SetGenerators( surf, generators );
		coloursOfEdges := __SIMPLICIAL_ColoursOfEdgesFromGenerators( 
				Edges(surf), Faces(surf), FacesOfEdges(surf), generators );
		SetColoursOfEdges( surf, coloursOfEdges );

		# define other attributes of simplicial surface
		DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC( surf );

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

#TODO constructor by generators in mirror-setting
BindGlobal( "__SIMPLICIAL_MirrorByGenerators", function( gens )
        local faces, edgeLists, vertexLists, edgeIndex, i, vertexIndex,
            edgesOfVertices, facesOfEdges, f, edge, vertex, eIndex, vIndex;

        # faces are given by the domain of the generators (how do we know this?)

        edgeLists := List( gens, i-> Orbits(Group(i),faces) );
        edgeIndex := [];
        for i in [1,2,3] do
            Append(edgeIndex, List([1..Size(edgeLists[i])], j -> [i,j]) );
        od;

        vertexLists := List( [[1,2],[1,3],[2,3]], pair -> 
            List( Orbits( Group(gens[pair[1]],gens[pair[2]]), faces ), o -> [pair,o])  );
        vertexIndex := [];
        for i in [1,2,3] do
            Append(vertexIndex, List([1..Size(vertexLists[i])], j -> [i,j]));
        od;

        edgesOfVertices := List( vertexIndex, i -> [] );
        for vIndex in [1..Size(vertexIndex)] do
            for eIndex in [1..Size(edgeIndex)] do
                edge := edgeLists[eIndex[1]][eIndex[2]];
                vertex := vertexLists[vIndex[1]][vIndex[2]];
                if eIndex[1] in vertex[1] and edge in vertex[2] then
                    Add( edgesOfVertices[vIndex], eIndex );
                fi;
            od;
        od;

        facesOfEdges := List( edgeIndex, i -> []);
        for eIndex in [1..Size(edgeIndex)] do
            for f in faces do
                if f in edgeLists[ eIndex[1] ][ eIndex[2] ] then
                    Add(facesOfEdges[eIndex], f);
                fi;
            od;
        od;
        
        #TODO return SurfaceByUpwardIncidence
    end
);


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

		# set edge colouring attribute
		SetColoursOfEdges( surf, coloursOfEdges );

		# define other attributes of simplicial surface
		DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC( surf );

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
		DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC( surf );

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
BindGlobal( "__SIMPLICIAL_MRTypeNamesOfNumber",
    function( e )
            if e = 0 then return "border";
            elif e = 1 then return "mirror";
            elif e = 2 then return "rotation";
            else Error("__SIMPLICIAL_MRTypeNamesOfNumber: unknown mr type number");
            fi;
    end
);
InstallMethod( MRTypeOfEdges, 
	"for a wild simplicial surface", [ IsWildSimplicialSurface ],
	function(simpsurf)
            return List(MRTypeOfEdgesAsNumbers(simpsurf), __SIMPLICIAL_MRTypeNamesOfNumber );
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
		for edge in Edges(surf) do
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
BindGlobal( "__SIMPLICIAL_ConvertWildLegacyIntoModern", 
	function( faces, edgeCycles, vertexPaths, gens )
	
	local nrCycles, edges, edgeColours, facesOfEdges, vertices, 
              edgesOfVertices, FindEdges, surf, EmptySetIfRealFace, 
              colEdgesOfFaces, col, i, f, totalNrCycles;


        # The edgeCycles are lists of one or two elements
        #   - Two elements represent an inner edge
        #   - One element represents an outer edge
        # In any case - the number of cycles is the number of edges.
        # It is important to note that different colours might have
        # different numbers of corresponding edges.

        nrCycles := List( edgeCycles, Length );
        totalNrCycles := Sum(nrCycles);

	# The faces stay the same

	# The edges will be modified
	edges := [1..totalNrCycles];

	edgeColours := List( [1..nrCycles[1]], i -> 1 );
	Append( edgeColours, List( [1..nrCycles[2]], i -> 2 ) );
	Append( edgeColours, List( [1..nrCycles[3]], i -> 3 ) );

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
		for i in [1..nrCycles[col]] do
			for f in edgeCycles[col][i] do
				colEdgesOfFaces[f][col] := Sum( nrCycles{[1..(col-1)]}) + i;
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

	DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(surf);

	return surf;
end);


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

BindGlobal( "__SIMPLICIAL_CheckGeneratorsAndMRType",
	function( gens, mrtype )
		if Length(gens) <> 3 then
         Error("__SIMPLICIAL_CheckGeneratorsAndMRType: There have to be three generators given.\n");
		fi;
		if not IsPerm(gens[1]) or not IsPerm(gens[2]) or not IsPerm(gens[3]) then
		     Error("__SIMPLICIAL_CheckGeneratorsAndMRType: The generators have to be permutations.\n");
		fi;
		if gens[1]^2 <> One(gens[1]) or gens[2]^2 <> One(gens[2]) 
		    or gens[3]^2 <> One(gens[3]) then
		     Error("__SIMPLICIAL_CheckGeneratorsAndMRType: The generators have to be involutions.\n");
		fi;

		if not Length(mrtype) in [0,3] then
		     Error("__SIMPLICIAL_CheckGeneratorsAndMRType: The edge types have to be given as a list with up to three elements.\n");
		fi;
	end
);


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
	__SIMPLICIAL_CheckGeneratorsAndMRType(gens,mrtype);

        # Catch the case of gens = [ (), (), () ]
        if gens = [ (), (), () ] then
            return [ WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring(
                [],[],[],[],[],[]),
                WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring(
                3,3,1,[[1,2],[2,3],[1,3]],[[1,2,3]],[1,2,3] ) ];
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


############################################################################
##
##
##  A structure of a simplicial surface is a wild colouring where all
##  cycles of a single generator have the same mr-assignment, i.e. all
##  cycles of any one generator are either all mirrors or all reflections.
##  This function returns structures in the input list of simplicial 
##  surfaces, i.e. it returns all mmm, mmr, mrr, rrr surfaces, 
##
InstallMethod( FilteredStructuresWildSimplicialSurface, 
	"for a list of wild simplicial surfaces", [IsList],
	function (allsimpsurf)
            return Filtered(allsimpsurf, IsSurfaceWithStructure);
	end
);

InstallMethod( IsSurfaceWithStructure, "for a wild simplicial surface",
    [ IsWildSimplicialSurface ],
    function( wildSurf )
        local mr, edgeSet;

        mr := MRTypeOfEdgesAsNumbers(wildSurf);
        edgeSet := EdgesOfColours(wildSurf);
        mr := List( edgeSet, s -> List( s, e->mr[e] ) );
        if 1 in mr[1] and 2 in mr[1] then
            return false;
        fi;
        if 1 in mr[2] and 2 in mr[2] then
            return false;
        fi;
        if 1 in mr[3] and 2 in mr[3] then
            return false;
        fi;
        return true;
    end
);


InstallMethod( MRTypeOfSurfaceWithStructureAsNumbers, 
    "for a wild simplicial surface with structure",
    [ IsWildSimplicialSurface and IsSurfaceWithStructure],
    function( surf )
        local edgesOfColours, res, i, types;

        res := [];
        edgesOfColours := EdgesOfColours(surf);
        for i in [1,2,3] do
            # We have to be careful here - if there is a border edge 
            # it may be either a mirror or a rotation. If there is an edge
            # of the appropriate colour with mirror or rotation type, this 
            # will be returned.
            types := List( edgesOfColours[i], e -> MRTypeOfEdgesAsNumbers(surf)[e] );
            types := Set( types );
            if Size(types) = 1 then
                res[i] := types[1];
            else
                types := Difference( types, [0] );
                if Size(types) > 1 then
                    Error("MRTypeOfSurfaceWithStructureAsNumbers: Internal Error.");
                fi;
                res[i] := types[1];
            fi;
        od;
        
        return res;
    end
);
RedispatchOnCondition( MRTypeOfSurfaceWithStructureAsNumbers, true,
    [IsWildSimplicialSurface], [IsSurfaceWithStructure], 0 );

InstallMethod( MRTypeOfSurfaceWithStructure,
    "for a wild simplicial surface with structure",
    [IsWildSimplicialSurface and IsSurfaceWithStructure],
    function(surf)
        return List( MRTypeOfSurfaceWithStructureAsNumbers(surf), __SIMPLICIAL_MRTypeNamesOfNumber );
    end
);
RedispatchOnCondition( MRTypeOfSurfaceWithStructure, true,
    [IsWildSimplicialSurface], [IsSurfaceWithStructure], 0);


InstallMethod( ImageWildSimplicialSurface, 
    "for a simplicial surface and a permutation", 
    [IsWildSimplicialSurface, IsPerm ], function( surface, perm )
        local newFacesOfEdges, newNamesOfFaces, 
            newLocalOrientationByEdgesAsPerm, surf;

        # We define the action on the faces as follows (with the intent of
        # fixing vertices and edges):
        # - Change FacesOfEdges (simple application of permutation)
        # - EdgesOfVertices stays fixed
        # - Move NamesOfFaces (permute the indices)
        # - Move LocalOrientation
        newFacesOfEdges := OnTuplesSets( FacesOfEdges(surface), perm );
        newNamesOfFaces := Permuted( NamesOfFaces(surface), perm );
        newLocalOrientationByEdgesAsPerm := Permuted(
            LocalOrientationByEdgesAsPerm(surface), perm );

        surf := Objectify( WildSimplicialSurfaceType, rec() );
        SetVerticesAttributeOfSimplicialSurface( surf, Vertices(surface) );
        SetEdges( surf, Edges(surface) );
        SetFaces( surf, Faces(surface) );
        SetEdgesOfVertices( surf, EdgesOfVertices(surface) );
        SetFacesOfEdges( surf, newFacesOfEdges );
        SetNamesOfFaces( surf, newNamesOfFaces );
        SetLocalOrientationByEdgesAsPerm( surf, newLocalOrientationByEdgesAsPerm );
        SetColoursOfEdges( surf, ColoursOfEdges(surface) );

        return surf;
    end
);



#############################################################################
##
##
##  This function returns all simplicial surfaces that support a structure.
##  A structure on a simplicial surface is a wild colouring for which all
##  cycles of a single generator are all of the same type: either m or r.
##
##
InstallOtherMethod( AllStructuresWildSimplicialSurface, "for a group", 
	[IsGroup], function( grp )
		return AllStructuresWildSimplicialSurface( GeneratorsOfGroup(grp) );
	end
);

InstallOtherMethod( AllStructuresWildSimplicialSurface, "for three involutions", 
	[IsPerm, IsPerm, IsPerm], function( p1,p2,p3 )
		return AllStructuresWildSimplicialSurface( [p1,p2,p3] );
	end
);

InstallMethod( AllStructuresWildSimplicialSurface, 
	"for a list of three involutions", [IsList],  function (gens)

    local mrtype,  faces, res, ss;

    mrtype := [];

	# Check the generators
	__SIMPLICIAL_CheckGeneratorsAndMRType( gens, [] );

    faces := MovedPoints(gens);
    res := [];
   
    # mmm
    mrtype := List( [1..3], i-> List(faces, j-> 1 ));
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mmm-type"); fi;
    # mmr 
    mrtype :=[];
    mrtype[1] := List(faces,j->1);
    mrtype[2] := List(faces,j->1);
    mrtype[3] := List(faces,j->2);
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mmr-type"); fi;
    # mrm
    mrtype :=[];
    mrtype[1] := List(faces,j->1);
    mrtype[2] := List(faces,j->2);
    mrtype[3] := List(faces,j->1);
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mmr-type"); fi;
    # rmm
    mrtype :=[];
    mrtype[1] := List(faces,j->2);
    mrtype[2] := List(faces,j->1);
    mrtype[3] := List(faces,j->1);
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mmr-type"); fi;
    # mrr
    mrtype :=[];
    mrtype[1] := List(faces,j->1);
    mrtype[2] := List(faces,j->2);
    mrtype[3] := List(faces,j->2);
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mrr-type"); fi;
    # rmr
    mrtype :=[];
    mrtype[1] := List(faces,j->2);
    mrtype[2] := List(faces,j->1);
    mrtype[3] := List(faces,j->2);
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mrr-type"); fi;
    # rrm
    mrtype :=[];
    mrtype[1] := List(faces,j->2);
    mrtype[2] := List(faces,j->2);
    mrtype[3] := List(faces,j->1);
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mrr-type"); fi;
    # rrr
    mrtype := List( [1..3], i-> List(faces, j-> 2 ));
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one rrr-type"); fi;

    return res;
end);



#############################################################################
##
#!  @Description
#!  This function takes as input a list of pairs of integers. Suppose the
#!  integers occurring in this list of pairs is the set of faces. Then this
#!  function computes all triples of involutions acting on the set faces.
#!  @Returns a list of lists, which are involution triples.
#!  @Arguments a list of lists, which is a list of pairs of integers
#!
InstallMethod( GeneratorsFromFacePairs, "List of integer pairs", [IsList],
      function( facepairs )

        local gens, g, i,  cycs, cycs_c, gens_c, faces, fixedpoints_c, c,
              AllGenSets, NextFace, fixedpoints, IsEligible, check;

        if Length(facepairs) = 0 then return [ (), (), () ]; fi;
        check := Filtered( facepairs, i-> not IsList(i) or 
                           Length(i) <> 2 or not IsPosInt(i[1]) or 
                           not IsPosInt(i[2]) );
        if Length(check)<> 0 then 
            Error("GeneratorsFromFacePairs: ", 
                  "input not a list of pairs of positive integers");
        fi;

        facepairs := Compacted(facepairs);
        faces := Set( Flat(facepairs) );
        
        cycs := ShallowCopy(facepairs);

        c := First( cycs, i-> Length(i) = 2 );
        if c = fail then return [ (), (), () ]; fi;
        Remove(cycs,Position(cycs,c));
        Sort(cycs);
        

        cycs_c := ShallowCopy(cycs);
        # the first cycle has to be somewhere so it might as well
        # be on the first generator
        gens_c := [ (c[1], c[2]), (), () ];


        # here we record which fixed points we have used in which
        # generator so far
        fixedpoints := [];
        fixedpoints[1] := List( [1..Length(faces)], i-> false );
        fixedpoints[2] := List( [1..Length(faces)], i-> false );
        fixedpoints[3] := List( [1..Length(faces)], i-> false );

        # a global variable to store the results
        AllGenSets := [];


        # test whether g can be extended with the cycle c
        IsEligible := function (g,i, c, fix )
              
            if Length(c) = 2 then
                # first we have to ensure that neither c[1] nor c[2] are
                # fixed points of g
                if fix[i][c[1]] = false and fix[i][c[2]] = false and
                   c[1]^g = c[1] and c[2]^g = c[2] then
                    return true; # the 2-cycle is not in gens[i] yet
                else return false;
                fi;
            else # c is a 1-cycle
                # if it has not yet been used in g and g fixes it, return true
                if fix[i][c[1]] = false and c[1]^g=c[1] then return true; fi;
            fi;

            return false;

        end;

        # find all possibilities of moving face f
        NextFace := function( gens, cycs, fixedpoints )
            local g, i, c, nf;

        
            # choose the first cycle that contains f
            c := cycs[1];

            # now we try to add c to each of the generators
            for i in [ 1 .. 3 ] do
                g := gens[i];
                if IsEligible(g,i,c, fixedpoints) then
                    # this generator does not already move the 
                    # points in c, hence we can extend it by c.
                    gens_c := ShallowCopy(gens);
                    cycs_c := ShallowCopy(cycs);
                    fixedpoints_c := 
                        List(fixedpoints, x -> ShallowCopy(x));
                    if Length(c) = 2 then 
                        # if c is a 2-cycle, extend g
                        gens_c[i] := g * (c[1],c[2]);
                    else
                        # if c is a 1-cycle record its use in g
                        fixedpoints_c[i][c[1]] := true;
                    fi;
                    Remove( cycs_c, Position(cycs_c,c) );

                    if Length(cycs_c) = 0 then
                        # there are no more points to move 
                        # hence we found a valid assignment
                        Sort( gens_c );
                        Add(AllGenSets, gens_c);
                    else
                        NextFace( gens_c,cycs_c,fixedpoints_c);
                    fi;
                fi;
            od;

        end;


        NextFace( gens_c, cycs_c, fixedpoints );

        return Set(AllGenSets);

end);

# Given a list of generators and a face-edge-path this function calculates 
# all EdgesOfColours that are compatible with this path.
BindGlobal("__SIMPLICIAL_EdgeColoursFromFaceEdgePath", function(gens, path)

        local edgesOfColours, i, CheckTransitions;
        
        edgesOfColours := [ List( gens, g -> [] ) ];

        # face1 and face2 are connected via edge.
        # If a generator moves face1 to face2, the edge will be counted
        # as an edge of this colour. Otherwise return fail.
        CheckTransitions := function( face1, face2, edge )
            local newEdgeCol, found, i, edgeCol, newEdgesOfColours;

            newEdgesOfColours := [];
            found := false;
            for i in [1..Length(gens)] do
                if face1^gens[i] = face2 then
                    found := true;
                    for edgeCol in edgesOfColours do
                        newEdgeCol := ShallowCopy(edgeCol);
                        newEdgeCol[i] := Union( newEdgeCol[i], [edge] );
                        Add( newEdgesOfColours, newEdgeCol );
                    od;
                fi;
            od;
            if not found then
                return fail;
            fi;

            return newEdgesOfColours;
        end;

        if IsEvenInt( Length(path) ) then
            # Closed path
            edgesOfColours := CheckTransitions( path[2], path[Length(path)], path[1] );
            if edgesOfColours = fail then
                return [];
            fi;
            for i in [2,4..Length(path)-2] do
                edgesOfColours := CheckTransitions( path[i], path[i+2], path[i+1] );
                if edgesOfColours = fail then
                    return [];
                fi;
            od;
        else
            # Open path
            edgesOfColours := CheckTransitions( path[2], path[2], path[1] );
            if edgesOfColours = fail then
                return [];
            fi;

            edgesOfColours := CheckTransitions( path[ Length(path)-1 ], path[ Length(path) - 1], path[ Length(path) ] );
            if edgesOfColours = fail then
                return [];
            fi;

            for i in [2,4..Length(path)-3] do
                edgesOfColours := CheckTransitions( path[i], path[i+2], path[i+1] );
                if edgesOfColours = fail then
                    return [];
                fi;
            od;
        fi;

        return edgesOfColours;
    end
);


# auxilliary function
# v is a face-path and gens a list of generators
# return a list with all coloured face-edge-paths that are compatible with these generators
BindGlobal("__SIMPLICIAL_ColouredFaceEdgePathsFromFacePath",function( gens, v )

    local  walks, g, w, i, j, nw, newwalks;


    walks := [[]];
    if v[Length(v)] <> v[1] then
        # transversing face edge path (see paper)
        g := Filtered( gens, j-> v[1]^j=v[1] );
        if g=[] then return []; fi;
        walks := List(g, i-> [Position(gens,i),v[1]]);
        for i in [1..Length(v)-1] do
            # g will contain all perms with cycle (v[i], v[i+1])
            g := Filtered( gens, j-> v[i]^j=v[i+1] );
            if g = [] then return []; fi;
            newwalks := [];
            # loop through all partial walks w and
            # define |g| new walks by adding the elements
            # of g to w
            for w in walks do
                for j in g do
                    nw := ShallowCopy(w);
                    Append(nw,[Position(gens,j),v[i+1]]);
                    Add(newwalks, nw );
                od;
            od;
            walks := newwalks;
        od;
        i := Length(v);
        g := Filtered( gens, j-> v[i]^j=v[i] );
        if g = [] then return []; fi;
        newwalks := [];
        # loop through all partial walks w and
        # define |g| new walks by adding the elements
        # of g to w
        for w in walks do
            for j in g do
                nw := ShallowCopy(w);
                Add(nw,Position(gens,j));
                Add(newwalks, nw );
             od;
        od;
        walks := newwalks;

    else
        # closed face path (repeating starting face at the end)
        for i in [1..Length(v)-1] do
                g := Filtered( gens, j-> v[i]^j=v[i+1] );
                if g = [] then return []; fi;
                newwalks := [];
                # loop through all partial walks w and
                # define |g| new walks by adding the elements
                # of g to w
                for w in walks do
                    for j in g do
                        nw := ShallowCopy(w);
                        Append(nw,[Position(gens,j),v[i+1]]);
                        Add(newwalks, nw );
                    od;
                od;
                walks := newwalks;
        od;
        if Length(v) = 3 then
            # we have to check in this case that we use different
            # permutations, e.g. that 1a2a1 does not occur
            walks := Filtered( walks, w -> w[1] <> w[3] );
        fi;
    fi;

    return walks;
end);

BindGlobal("__SIMPLICIAL_TestGeneratorsForFaceEdgePaths", function(gens, paths)
    local p, i, edgeCols, allColours, g, cart, colourSnippets, 
        boundedPositions, MakeHoles, possColours;
 
    cart := [];
    allColours := [];
    for p in paths do
        edgeCols := __SIMPLICIAL_EdgeColoursFromFaceEdgePath(gens, p);
        if edgeCols = [] then 
            Print("path ", p, " is inconsistent with generators", gens, "\n");
            return []; 
        else
            Add(allColours,edgeCols);
            Add( cart, [1..Length(edgeCols)]);
        fi;
    od;
    cart := Cartesian(cart);
    # Combine all lists of colours in the following fashion:
    # One colour setting around the first vertex, one colour setting around
    # the second vertex, etc,
    colourSnippets := List(cart,l->List([1..Length(l)],i->allColours[i][l[i]]));

    # Combine the snippets into complete edgeColourings
    possColours := List( colourSnippets, snipp -> # for each local colour combination
            List( [1..Length(gens)], i -> # construct a list of three lists
                    Union( List( [1..Length(snipp)], nr -> snipp[nr][i] ) ) ) );

    # Check whether the edge colouring is consistent
    return Filtered( possColours, poss -> 
        Length( Intersection( poss[1], poss[2] ) ) = 0 and
        Length( Intersection( poss[1], poss[3] ) ) = 0 and
        Length( Intersection( poss[2], poss[3] )) = 0 );

end);

##  auxilliary function
## Test whether the generators match up with a list of face-paths (for
## each vertex one path is given). DON'T confuse them with face-edge-paths
BindGlobal("__SIMPLICIAL_TestGens", function(gens, paths)

            local v, i, vtx, allvertices, g, cart, colouredPaths,
            boundedPositions, MakeHoles;
 

            cart := [];
            allvertices := [];
            for v in paths do
                  vtx := __SIMPLICIAL_ColouredFaceEdgePathsFromFacePath(gens, v);
                  if vtx = [] then 
                      Print("vertex ", v, " without face-edge-path");
                      return []; 
                  else
                      Add(allvertices,vtx);
                      Add( cart, [1..Length(vtx)]);
                  fi;
            od;
            cart := Cartesian(cart);
            # Combine all lists of walks in the following fashion:
            # One walk around the first vertex, one walk around the second
            # vertex, etc,
            colouredPaths := List(cart,l->List([1..Length(l)],i->allvertices[i][l[i]]));

            boundedPositions := BoundPositions(paths);


            MakeHoles := function( path )
              local pathWithHoles,i;

              pathWithHoles := [];
              for i in [1..Length(boundedPositions)] do
                  pathWithHoles[boundedPositions[i]] := path[i];
              od;

              return pathWithHoles;
           end;
           
           return List( colouredPaths, MakeHoles );
 end);



InstallMethod( AllWildSimplicialSurfacesFromFacePath, 
"List of integers, List of pairs of integers, List of face paths",
[IsList,IsList,IsList], function(faces, edges, facepaths)

        local simpsurf, gens, allsurf, newvertices, vtx;

Print("Warning: Closed paths must repeat starting vertex!!\n");
        for vtx in facepaths do
            if vtx[1] <> vtx[Length(vtx)] then
	        if Length(vtx) <> Length(Set(vtx)) then
	       	    Error("WildSimplicialSurfacesFromFacePath: ",
                        "Facepaths can't repeat faces except at the end.");
                fi;		  
            else
                if Length(vtx)-1 <> Length(Set(vtx)) then
	       	    Error("WildSimplicialSurfacesFromFacePath: ",
                        "Facepaths can't repeat faces except at the end.");
                fi;
            fi;		  
        od;

        faces := ShallowCopy(faces);
        allsurf := [];

         
        # Now we test whether the simplicial surface we 
        # have supports a wild colouring.
        for gens in GeneratorsFromFacePairs(edges) do
            newvertices := __SIMPLICIAL_TestGens( gens, facepaths );
            for vtx in newvertices do
                if vtx <> [] then
                   # This method does not use generators or edges
                    simpsurf := WildSimplicialSurfaceByColouredFaceEdgePaths(
                                [1..Length(vtx)],faces,vtx);
                    Add( allsurf, simpsurf);
                fi;
            od;
        od;        

        return allsurf;
            
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
	    Print("\n");
        od;
 
        Print("Degrees = ", UnsortedDegrees(simpsurf) );
	end
);

#############################################################################
##
##  A Print method for simplicial surfaces
##
#TODO ignored orientation and non-standard names for faces
InstallMethod( PrintStringAttributeOfSimplicialSurface,
	"for a wild simplicial surface", [IsWildSimplicialSurface],
	function( simpsurf )
		local str, out;

		str := "";
		out := OutputTextString( str, true );
		PrintTo( out, 
				"WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouringNC(\n" );
		PrintTo( out, Vertices(simpsurf), ",\n" );
		PrintTo( out, Edges(simpsurf), ",\n" );
		PrintTo( out, Faces(simpsurf), ",\n" );
		PrintTo( out, VerticesOfEdges(simpsurf), ",\n" );
		PrintTo( out, EdgesOfFaces(simpsurf), ",\n" );
		PrintTo( out, ColoursOfEdges(simpsurf), " )\n");

		CloseStream(out);

		return str;
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

##
##	Check connectivity
##
InstallMethod( IsConnected, "for a wild simplicial surface",
	[IsWildSimplicialSurface],
	function(simpsurf)
		return Length( Orbits( GroupOfWildSimplicialSurface(simpsurf), 
									Faces(simpsurf) ) ) = 1;
	end
);

##
##	Check orientability
##
#TODO how should be handle the assumption of connectivity?
InstallMethod( IsOrientable, "for a wild simplicial surface", true, 
	[ IsWildSimplicialSurface and IsPathConnected], 0,
        function(simpsurf)

        local gens, newgens, i, mrtype, MapCycle, orb, N;


        N:= Maximum(Faces(simpsurf));


		# Map each cycle to a covering cycle. Mirrors are mapped to
		# (i, -j) (-i,j) and rotations to (i,j)(-i,-j). If the
		# type is unknown, we leave the cycle unchanged.
		MapCycle := function (c, t)

			local i, j;


			if Length(c) < 2 then return One(()); fi;   
			i := c[1]; j := c[2];

			if t = 0 then return (i,j); fi;

			if t = 1 then
				return (i, j+N) * (i+N, j );
			elif t = 2 then
				return (i,j)*(i+N, j+N);
			fi;

		end;

        gens := Generators(simpsurf);
        newgens := List( gens, i-> Cycles(i, Faces(simpsurf)));


        mrtype := MRTypeOfEdgesAsNumbers(simpsurf);

        for i in [ 1 .. 3 ] do
            newgens[i] := List( newgens[i], 
                    c -> MapCycle(c,mrtype[EdgeByFacesAndColourNC(simpsurf,c,i)]));
            newgens[i] := Product( newgens[i] );
        od;

        orb := Orbits(Group(newgens));

        if Length(orb) = 1 then
            return false;
        elif Length(orb) = 2 then
            return true;
        fi;
        Error("IsOrientable: unknown orientability of wild simplicial surface");

	end
);


##
##	Snipp off ears
##
InstallMethod( SnippOffEars, "for a wild simplicial surface",
	[IsWildSimplicialSurface],
	function(simpsurf)
		local snippSimp, newColours, edge;

		# Use the method for general simplicial surfaces
		snippSimp := __SIMPLICIAL_SnippOffEarsOfSimplicialSurface(simpsurf);

		# Add the appropriate colours
		newColours := ShallowCopy( ColoursOfEdges( simpsurf ) );
		for edge in Edges(simpsurf) do
			if not edge in Edges(snippSimp) then
				Unbind( newColours[edge] );
			fi;
		od;

		return WildSimplicialSurfaceExtensionByEdgeColouringNC( snippSimp, 
															newColours );
	end
);



##
##			End of more specialized methods from SimplicialSurface
##
############################################################################
############################################################################


#############################################################################
##
#!  @Description
#!  This function takes as input a ``generic"- description of a surface. 
#!  A ``generic"-description of a surface is the most general description 
#!  of a simplicial surface. Also surfaces which do not support a 
#!  wild-colouring can be described by a ``generic"-description. 
#!  The ``generic"-description of a surface is as follows:
#!  [ |V|, |E|, |F|, [ [v1,v2],...],  [[e1,e2,e3],... ] ], where
#!  * |V| denotes the  number of vertices, 
#!  * |E| denotes the number of edges and 
#!  * |F| denotes the number of faces,
#!  * [ [v1,v2], .. ] is a list of  pairs of vertices making up the edges, 
#!        here v1, v2, etc are numbers of the vertices in [1 .. |V|]
#!  * [[e1,e2,e3], .. ] is a list of triples of edges making up the faces
#!        e1, e2, e3 are all numbers in [1..|V|] and the number e represents
#!        the edge [va, vb] stored in the list of vertices in position e.
#!
#!  @BeginExample the tetrahedron has a  ``generic"-description:
#!   tetra := [ 4, 6, 4, [[1,3], [2,3], [1,2], [2,4], [1,4], [3,4] ],
#!        [  [ 1, 2, 3], [2, 4, 6], [ 3, 4, 5], [1, 5, 6] ] ];
#!        where the triple [1,2,3] encodes the following three edges
#!        [1,3], [2,3], and [1,2] according to their positions
#!              in the list of edges
#!  @EndExample
#!
#!  @Returns If the surface described by the ``generic" description supports
#!  a  wild colouring, then the wild coloured simplicial surfaces description
#!  is returned. Otherwise the function returns fail.
#!  @Arguments a list of lists, representing a ``generic"-description of a surface
## TODO: Clean up local variables here!
##
## TODO: FaceWithEdges wrong call?
InstallOtherMethod( AllWildSimplicialSurfaces,"",[IsSimplicialSurface and IsActualSurface], function(surface)

    local gens, newcolours, wild, edgeColours, allsurf;

        allsurf := [];

        # now we see which generating triples we can create from the edges of
        # the surface and see whether any of these can be a wild colouring
        # for the given edges. If the generic surface does not support a 
        # wild colouring, then TestGens will return an empty list.
        for gens in GeneratorsFromFacePairs( FacesOfEdges(surface) ) do
            newcolours := __SIMPLICIAL_TestGeneratorsForFaceEdgePaths( gens, List( FaceEdgePathsOfVertices(surface), i -> i[1] ) );
            # All coloured face-edge-paths with these generators
            for edgeColours in newcolours do
                if edgeColours <> [] then
		    wild := ObjectifySimplicialSurface( 
		        WildSimplicialSurfaceType, rec(), surface);
                    SetEdgesOfColours(wild,edgeColours);

                    Add( allsurf, wild);
                fi;
            od;
 
        od;

        return allsurf;
            
end);

RedispatchOnCondition( AllWildSimplicialSurfaces, true, [IsSimplicialSurface],
    [IsActualSurface], 0 );


###############################################################################
###############################################################################
##          Start of drawing methods
##

# We use the answer of
# https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
# to compute the intersection of two line segments
BindGlobal( "__SIMPLICIAL_IntersectingLineSegments",
    function( edgeCoords1, edgeCoords2 )
        local Cross, vtx1, vtx2, det, diff, factor1, factor2, min, max,
            IsEqualFloat;

        # Since we want to compare floats and this gives a lot of problems we
        # write a custom method to compare floats (up to a specified accuracy)
        IsEqualFloat := function( a, b )
            local diff;

            diff := (a-b)^2;
            # Currently: precision to 15 places
            return diff < Float( 10^(-30) );
        end;

        Cross := function( v, w )
            return v[1]*w[2] - v[2]*w[1];
        end;

        # Rewrite the lines into p + t * v
        vtx1 := edgeCoords1[2] - edgeCoords1[1];
        vtx2 := edgeCoords2[2] - edgeCoords2[1];

        # Check first if the lines are parallel
        det := Cross( vtx1, vtx2 );
        diff := edgeCoords2[1] - edgeCoords1[1];
        if IsEqualFloat( det, Float(0) ) then
            # parallel case:
            # We have to check if the lines coincide
            # For that we check if the vector between the two base
            # points is parallel to the line directions
            if not IsEqualFloat( Cross( vtx1, diff ), Float(0)) then
                return false;
            fi;
            
            # Now we know that the associated lines coincide
            # Determine factor1 such that
            # p_2 = p_1 + factor1 * vtx_1
            # and factor2 such that
            # p_2 + vtx_2 = p_1 + factor * vtx_1
            if not IsEqualFloat( vtx1[1], Float(0) ) then
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
            elif ( IsEqualFloat(factor1,0.) or IsEqualFloat(factor1,1.) )
                and ( IsEqualFloat(factor2,0.) or IsEqualFloat(factor2,1.) ) then
                return false;
            else
                return true;
            fi;
        fi;
    end
);


InstallOtherMethod( DrawSurfaceToTikz, "for a wild simplicial surface",
    [IsWildSimplicialSurface, IsString],
    function(surface, string)
        return DrawSurfaceToTikz( surface, string, rec() );
    end
);
InstallMethod( DrawSurfaceToTikz, "for a wild simplicial surface",
    [IsWildSimplicialSurface, IsString, IsRecord],
    function( surface, string, record )
      local toMuchInfo, angles, cos, sin, vertexCoordinates, edgeData, 
            faceData, faceOrientation, AddToData, unplacedFaces, 
            connCompByFaceLists, realStarts, realEdgeDraw, startIndex, 
            edgeDrawIndex, proposedDrawOrder, openEdges, openVertices, 
            currentVertex, currComponentList, start, vertOfStart, col, 
            otherCol, drawOrder, nextEdge, nextFace, baseVertex, basePoint, 
            otherVertex, baseVector, rescaleFactor, rotateAngle, newVector, 
            finalVertex, finalVertexTuple, newEdge1, newEdge2, subsurfaces, 
            name, output, subsurf, faceCol, faceX, faceY, i, j, e, v, f, tuple,
            VertexCoordinatesOfEdge, vtxCoord1, vtxCoord2, vtxIndex, 
            vtxCoord;

        # Test the given record first. Check if any information in the record
        # can't be used
        toMuchInfo := Difference( Set( RecNames( record ) ),
            [ "startingFaces", "edgeDrawOrder", "edgeColours", "faceColours",
                "edgeLengths", "vertexColour", "globalScale", 
                "vertexLabelling", "compileLaTeX", "noFaceColours", 
                "edgeLabelling", "faceLabelling", "edgeThickness", "caption"] );
        if not IsEmpty( toMuchInfo ) then
            Print( "Warning: The following components of the printing record " );
            Print( "could not be interpreted: " );
            Print( toMuchInfo );
            Print( "\n" );
        fi;



        # Add some missing information to the printing record
        # (the info about starting faces and edge draw order is done later)
        if not IsBound( record.edgeColours ) then
            record.edgeColours := [ "red", "blue", "green" ];
        fi;
        if not IsBound( record.faceColours ) then
            record.faceColours := [ "white", "lightgray" ];
        fi;
        if not IsBound( record.edgeLengths ) then
            record.edgeLengths := [2,3,4];
        fi;
        if not IsBound( record.globalScale ) then
            record.globalScale := 3/(2*Minimum(record.edgeLengths) );
        fi;
        if not IsBound( record.vertexColour ) then
            record.vertexColour := "orange";
        fi;
        if not IsBound( record.compileLaTeX ) then
            record.compileLaTeX := false;
        fi;
        if not IsBound( record.noFaceColours ) then
            record.noFaceColours := false;
        fi;
        if not IsBound( record.edgeLabelling ) then
            record.edgeLabelling := false;
        fi;
        if not IsBound( record.vertexLabelling ) then
            record.vertexLabelling := true;
        fi;
        if not IsBound( record.faceLabelling ) then
            record.faceLabelling := true;
        fi;
        if not IsBound( record.edgeThickness ) then
            record.edgeThickness := 1;
        fi;


        if IsBound( record.startingFaces ) and IsList( record.startingFaces ) then
            record.startingFaces := Compacted( record.startingFaces );
        else
            record.startingFaces := [];
        fi;

        if IsBound( record.edgeDrawOrder ) and IsList( record.edgeDrawOrder ) then
            record.edgeDrawOrder := Compacted( record.edgeDrawOrder );
        else
            record.edgeDrawOrder := [];
        fi;
        if IsBound( record.edgeDrawOrder[1] ) and not IsList( record.edgeDrawOrder[1] ) then
            # Probably someone inputted [1,2] instead of [[1,2]]
            Print("Warning: Given edge draw order was a list, not a list of lists. We interpreted the input as a double list.\n");
            record.edgeDrawOrder := [ record.edgeDrawOrder ];
        fi;
        
        # In addition to the lengths we need the angles of the drawn triangles.
        # We save those in a list angles, where angles[1] is the angle between
        # the two edges of lengths 2 and 3. Each angle is saved as a tuple
        # [cos(angle),sin(angle)] since only those are necessary for the
        # computation.
        angles := [];
        for i in [1..2] do
            for j in [i+1..3] do
                cos := Float( ( record.edgeLengths[6-i-j]^2 - 
                    record.edgeLengths[i]^2 - record.edgeLengths[j]^2 ) /
                    (-2* record.edgeLengths[i] * record.edgeLengths[j] ) );
                sin := Sqrt( Float( 1 - cos^2 ) );
                angles[6-i-j] := [cos,sin];
            od;
        od;
        
        
        # Next we define the data structure in which we will save the 
        # coordinate data
        # The vertex coordinates are a list (indexed by the vertices of the
        # surface) such that each entry is a list of position vectors (three
        # floats each). There might be several options since a vertex may
        # appear multiple times in one drawing.
        vertexCoordinates := [];
        # The edge data is a list (indexed by the edges of the surface) of
        # ordered pairs. Each entry of a pair represents a drawn vertex, 
        # therefore each entry is a pair of [vtx_number, index], where the
        # second component describes the position of the coordinates in the
        # vertex coordinate list.
        # Furthermore, the first entry is the base point of the edge. To
        # understand this, we interpret the ordered pair as a coordinate
        # vector that starts at the first entry and ends at the second one.
        # During the process of drawing the edge may be a border edge (because
        # the second face is not already drawn). In this case we want to know
        # in which direction we have to draw. If we can rotate this coordinate
        # vector around the first entry (mathematically positive e.g. counter-
        # clockwise) such that it moves into uncharted territory, we call the
        # first entry (around which we rotate) the base point of this edge.
        edgeData := [];
        # The face data is a list (indexed by the faces of the surface) of
        # triples. Each element of a triple corresponds to a coordinate point
        # (written as explained for edgeData).
        faceData := [];
        # The face orientation is a list (indexed by the faces of the surface)
        # of 3-cycles in the symmetric group S_3. For each face we define 
        # a local orientation of the three colours by going counterclockwise
        # around the edges.
        # This information is only relevant in colouring the faces later on.
        faceOrientation := [];
        # To better work with these data structures (especially
        # vertexCoordinates and edgeData) we write a custom add-method.
        AddToData := function( data, position, entry )
            if IsBound( data[position] ) then
                Add( data[position], entry );
            else
                data[position] := [entry];
            fi;
        end;

        
        # Now we begin with the computation of the coordinates. Since this
        # program can be completely and partially controlled by the printing
        # record (or maybe not at all) we need some variables to keep things
        # under control.

        # <General variables>
        # The unplacedFaces is a set of all faces that don't have a position in
        # the drawing yet.
        unplacedFaces := Faces( surface );
        # The list connCompByFaceLists is a list of sets, such that each set
        # represents the faces of a single path-connected component.
        connCompByFaceLists := [];

        # <Record keeping variables>
        # The list realStarts will be saved in the printing record later. It
        # records what the starting faces for each path-connected component
        # are (since they might be incomplete or incorrect before)
        realStarts := [];
        # The list realEdgeDraw will be saved in the printing record later and
        # records the order in which the edges are completed by faces.
        realEdgeDraw := [];

        # <Indexing variables>
        # Since we might have partial or wrong information about the startig
        # faces and the edge draw order in the given printing record, we use
        # two independent indices to iterate over these lists (independent of
        # the main method)
        startIndex := 1;
        edgeDrawIndex := 1;
        proposedDrawOrder := [];

        # <Variables for internal computation>
        # The list openEdges contains all border edges of the current drawing
        # that should be inner edges (except if they already have been drawn
        # twice). In other words, these are all edges where a triangle might
        # be added to the partial drawing.
        openEdges := [];
        # The list openVertices contains all vertices that are incident
        # to two faces, one of which is drawn and one of which isn't. Instead
        # of thinking about closing the edges, we might also think about
        # closing the vertices.
        openVertices := [];
        # The variable currentVertex keeps track about the vertex that we are
        # currently completing. Since choosing a random edge to draw a triangle
        # leads to a pretty random result, we try to complete the vertices one
        # at a time - which is why we have to keep track of the one we are
        # currently finishing. If there is no current vertex, this variable
        # is set to fail.
        currentVertex := fail;
        # The list currComponentList saves the faces in the path-connected
        # component at each time in the algorithm.
        currComponentList := [];

        # After all this preparation we are ready for the main algorithm
        # Since there might be several path-connected components our first
        # loop essentially computes them. It is not easily possible to
        # circumvent this because
        # 1) We have to iterate over all faces anyway
        # 2) We do not know in which order startingFaces gives us the 
        #   path-connected components (if it denotes them correctly at all)
        while not IsEmpty(unplacedFaces) do
            # We have started with a new path-connected component, so we
            # have to initialize the first face
                start := fail;
                if IsBound( record.startingFaces ) then
                    while startIndex < Size(record.startingFaces) and start = fail do
                        if record.startingFaces[startIndex] in Faces(surface) then
                            start := record.startingFaces[startIndex];
                        else
                            Print( "The given starting face " );
                            Print( record.startingFaces[startIndex] );
                            Print( " is not valid and will be ignored.\n" );
                        fi;
                        startIndex := startIndex + 1;
                    od;
                fi;
                if start = fail then
                    start := Minimum( unplacedFaces );
                fi;
                Add(realStarts,start);

                # After choosing the starting face we have to give it the
                # correct coordinates
                vertOfStart := VerticesOfFaces(surface)[start];
                # The first vertex goes into (0,0)
                AddToData( vertexCoordinates, vertOfStart[1], [Float(0),Float(0)] );
                # The second vertex goes to (?,0), therefore we have to find
                # the colour between those vertices
                col := fail;
                otherCol := fail; # The colour of the other adjacent edge
                for e in EdgesOfFaces(surface)[start] do
                    if Set(vertOfStart{[1,2]}) = VerticesOfEdges(surface)[e] then
                        # We have found the correct edge
                        col := ColourOfEdgeNC(surface,e);
                    elif vertOfStart[1] in VerticesOfEdges(surface)[e] then
                        otherCol := ColourOfEdgeNC(surface,e);
                    fi;
                od;
                if col = fail then
                    Error("DrawSurfaceToTikz: Internal error, colour not found.");
                fi;
                AddToData( vertexCoordinates, vertOfStart[2], 
                        [Float(record.edgeLengths[col]),Float(0)] );
                # The last vertex has to be defined by the angle
                if col=otherCol or otherCol = fail then
                    Error("DrawSurfaceToTik: Internal error, other colour not found." );
                fi;
                AddToData( vertexCoordinates, vertOfStart[3], 
                        record.edgeLengths[otherCol]*angles[6-col-otherCol] );

                # After setting the vertices, we have to set edges and faces
                edgeData[ ColouredEdgeOfFaceNC(surface,start,col) ] :=
                    [ [ [vertOfStart[2],1], [vertOfStart[1],1] ] ];
                edgeData[ ColouredEdgeOfFaceNC(surface,start,otherCol) ] :=
                    [ [ [vertOfStart[1],1], [vertOfStart[3],1] ] ];
                edgeData[ ColouredEdgeOfFaceNC(surface,start,6-col-otherCol)] :=
                    [ [ [vertOfStart[3],1], [vertOfStart[2],1] ] ];

                faceData[start] := List(vertOfStart, i->[i,1] ); 
                faceOrientation[start] := ( col, 6-col-otherCol, otherCol );

                # Initialize the variables for the next loop
                openEdges := Filtered( EdgesOfFaces(surface)[start], e ->
                    Size( FacesOfEdges(surface)[e] ) > 1 );
                openVertices := Filtered( VerticesOfFaces(surface)[start], v ->
                    Size( FacesOfVertices(surface)[v] ) > 1 );
                currComponentList := [start];

                # Initialize the proposed draw order
                if IsEmpty( record.edgeDrawOrder ) then
                    proposedDrawOrder := [];
                else
                    proposedDrawOrder := record.edgeDrawOrder[1];
                    Remove( record.edgeDrawOrder, 1 );
                fi;
                edgeDrawIndex := 1;
            # This ends the initialization of the starting face.


            # Now we assume that we have a starting face. We set up the vertex
            # variable for the case in which the drawing order is not given
            currentVertex := fail;
            # We also initialize the list that saves the order in which the
            # edges are drawn
            drawOrder := [];
            # We proceed until there are no more open edges
            while not IsEmpty( openEdges ) do
                # We check if the next user input is a good one
                nextEdge := fail;
                while edgeDrawIndex <= Size(proposedDrawOrder) and nextEdge = fail do
                    if proposedDrawOrder[edgeDrawIndex] in openEdges then
                        nextEdge := proposedDrawOrder[edgeDrawIndex];
                    else
                        Print("Warning: the proposed edge ");
                        Print( proposedDrawOrder[edgeDrawIndex] );
                        Print( " can't be used to draw a triangle.\n");
                    fi;
                    edgeDrawIndex := edgeDrawIndex + 1;
                od;
                # If we have not found a next input, we switch to closing open
                # vertices. If there is no current vertex, we have to find one.
                if currentVertex = fail then
                    currentVertex := Minimum( openVertices );
                fi;
                for e in openEdges do
                    if nextEdge <> fail then
                        break;
                    fi;
                    if currentVertex in VerticesOfEdges(surface)[e] then
                        nextEdge := e;
                    fi;
                od;
                # If we haven't found any edge something is wrong
                if nextEdge = fail then
                    Error("DrawSimplicialSurface: Internal error, open vertices and edges don't match.");
                fi;


                # Now that we have the next edge to draw upon, we draw the next
                # triangle.
                Add( drawOrder, nextEdge );
                nextFace := Difference( FacesOfEdges(surface)[nextEdge], currComponentList )[1];
                # We need to know number and coordinates of the base point
                baseVertex := edgeData[nextEdge][1][1][1];
                basePoint := vertexCoordinates[baseVertex][edgeData[nextEdge][1][1][2]];
                # We also need the number of the other vertex of this edge
                otherVertex := edgeData[nextEdge][1][2][1];
                # Since we want to compute the third vertex of the next face
                # via rotation, we need the connecting vector between base
                # point and other point.
                baseVector := vertexCoordinates[otherVertex][edgeData[nextEdge][1][2][2]] - basePoint;
                # We want to determine the colour of the given edge and the
                # colour of the other edge that is adjacent to the base vertex
                col := ColourOfEdgeNC( surface, nextEdge );
                otherCol := fail;
                for e in EdgesOfFaces(surface)[nextFace] do
                    if e <> nextEdge and baseVertex in VerticesOfEdges(surface)[e] then
                        otherCol := ColourOfEdgeNC(surface, e );
                    fi;
                od;
                if col = otherCol or otherCol = fail then
                    Error("DrawSimplicialSurface: Internal error, colour of next face.");
                fi;
                # Now we can compute the vector from the base point to the
                # third point.
                rescaleFactor := Float( record.edgeLengths[otherCol] / record.edgeLengths[col] );
                rotateAngle := angles[6-col-otherCol];
                newVector := rescaleFactor * 
                    [ rotateAngle[1]*baseVector[1] - rotateAngle[2]*baseVector[2],
                    rotateAngle[2]*baseVector[1] + rotateAngle[1]*baseVector[2] ];

                finalVertex := Difference( VerticesOfFaces(surface)[nextFace],
                        [ baseVertex, otherVertex ] )[1];
                AddToData( vertexCoordinates, finalVertex, basePoint + newVector );
                finalVertexTuple := 
                    [finalVertex, Size(vertexCoordinates[finalVertex]) ];
                # We add this vertex to the openVertices-list. This is ok since
                # we will test all vertices of the new face afterwards
                openVertices := Union( openVertices, [finalVertex] );


                # Modify edge and face data
                newEdge1 := ColouredEdgeOfFace( surface, nextFace, otherCol );
                newEdge2 := ColouredEdgeOfFace( surface, nextFace, 6-col-otherCol );
                AddToData( edgeData, newEdge1, 
                    [ edgeData[nextEdge][1][1], finalVertexTuple ] );
                AddToData( edgeData, newEdge2, 
                    [ finalVertexTuple, edgeData[nextEdge][1][2] ]);
                openEdges := Union( 
                    Difference( openEdges, [newEdge1, newEdge2, nextEdge] ),
                    Difference( Filtered([newEdge1, newEdge2], e -> 
                            Size(FacesOfEdges(surface)[e]) > 1 ), openEdges ) );

                # We have to confirm that the new edges do not intersect some 
                # of the old edges.
                VertexCoordinatesOfEdge := function( edge, index )
                    return List( edgeData[edge][index], vtxIndex ->
                        vertexCoordinates[vtxIndex[1]][vtxIndex[2]] );
                end;
                vtxCoord1 := VertexCoordinatesOfEdge( newEdge1,
                    Size( edgeData[newEdge1] ) );
                vtxCoord2 := VertexCoordinatesOfEdge( newEdge2,
                    Size( edgeData[newEdge2] ) );
                for e in Edges(surface) do
                    if IsBound( edgeData[e] ) then
                        for i in [1..Size(edgeData[e])] do
                            # The new edges don't need to be checked
                            if ( e = newEdge1 and i = Size(edgeData[e]) ) then
                                continue;
                            elif e = newEdge2 and i = Size(edgeData[e]) then
                                continue;
                            fi;

                            vtxCoord := VertexCoordinatesOfEdge( e,i );
                            if __SIMPLICIAL_IntersectingLineSegments(
                                vtxCoord, vtxCoord1 ) then
                                    Print("WARNING: The edge ");
                                    Print( newEdge1 );
                                    Print(" in the drawing step ");
                                    Print( drawOrder );
                                    Print(" intersects the edge ");
                                    Print( e );
                                    Print(" (instance " );
                                    Print( i );
                                    Print(")\n");
                            fi;
 
                            if __SIMPLICIAL_IntersectingLineSegments(
                                vtxCoord, vtxCoord2 ) then
                                    Print("WARNING: The edge ");
                                    Print( newEdge2 );
                                    Print(" in the drawing step ");
                                    Print( drawOrder );
                                    Print(" intersects the edge ");
                                    Print( e );
                                    Print(" (instance " );
                                    Print( i );
                                    Print(")\n");
                            fi;
                        od;
                    fi;
                od;

                faceData[nextFace] := Union( edgeData[nextEdge][1], [finalVertexTuple] );
                faceOrientation[nextFace] := (col, 6-col-otherCol, otherCol );
                Add( currComponentList, nextFace );


                # Afterwards, some vertices might have become closed
                for v in VerticesOfFaces(surface)[nextFace] do
                    if IsEmpty( Difference( FacesOfVertices(surface)[v], currComponentList ) ) then
                        # This vertex should not be an inner vertex
                        openVertices := Difference( openVertices, [v] );
                        if v = currentVertex then
                            currentVertex := fail;
                        fi;
                    fi;
                od;
            od;

            # At this point the component is finished
            Add( realEdgeDraw, drawOrder );
            unplacedFaces := Difference( unplacedFaces, currComponentList );
            Add( connCompByFaceLists, Set(currComponentList) );
        od;
        

        # Since we have effectively computed the path-connected components of
        # the given surface, we save this information (if we don't already
        # have it)
        subsurfaces := List( connCompByFaceLists, l -> 
                    SubsurfaceByFacesNC(surface,l) );
        if not HasPathConnectedComponents(surface) then
            SetPathConnectedComponents(surface, subsurfaces );
        fi;



        # Now we write this information into several tikz-pictures
        name := Filename( DirectoryCurrent(), string );
        output := OutputTextFile( name, false ); # override other files
        # Since apparently some editors format a long line into several lines
        # (and break the tex-code by that) we turn the formating off. We also
        # try to limit the amount of long lines.
        SetPrintFormattingStatus( output, false );
        AppendTo( output,
            "\\documentclass{article}\n\n",
            "\\usepackage{tikz}\n",
            "\\usepackage[inner=0.5cm,outer=0.5cm,top=1cm,bottom=0.5cm]{geometry}\n\n",
            "\\pagestyle{empty}\n",
            "\\begin{document}\n",
            "\\thispagestyle{empty}\n"
            );
        if IsBound(record.caption) then
          AppendTo( output,
          "\\subsection*{", record.caption, "}\n \\bigskip\n");
        fi;
        for i in [1..Size(subsurfaces)] do
            subsurf := subsurfaces[i];
            start := realStarts[i];
            # draw each one individually
            AppendTo( output, "\n\\begin{tikzpicture}[scale=", record.globalScale, "]\n");

            # Write all coordinates
            for v in Vertices( subsurf ) do
                for i in [1..Size(vertexCoordinates[v])] do
                    AppendTo( output,
                        "\\coordinate (V", v, "_", i, ") at (", 
                        vertexCoordinates[v][i][1], ", ", 
                        vertexCoordinates[v][i][2], ");\n" ); 
                od;
            od;

            AppendTo( output, "\n\n" );

            # Draw all faces
            for f in Faces(subsurf) do
                faceCol := record.faceColours[1];
                if IsOrientable(subsurf) then
                    if faceOrientation[f] <> faceOrientation[start] then
                        faceCol := record.faceColours[2];
                    fi;
                fi;
                if record.noFaceColours then
                    faceCol := "white";
                fi;
                AppendTo( output, "\\fill[", faceCol, "] " );
                faceX := 0;
                faceY := 0;
                for tuple in faceData[f] do
                    AppendTo( output, "(V", tuple[1], "_", tuple[2], ") -- " );
                    faceX := faceX + vertexCoordinates[tuple[1]][tuple[2]][1];
                    faceY := faceY + vertexCoordinates[tuple[1]][tuple[2]][2];
                od;
                AppendTo( output, "cycle;\n" );
                if record.faceLabelling then
                    AppendTo( output, "\\node (F", f, ") at (", 
                        faceX / 3, ", ", faceY / 3, ") {$f_{", f, "}$};\n" ); 
                fi;
            od;

            AppendTo( output, "\n\n" );

            # Draw all edges
            AppendTo( output,
                "\\tikzset{EdgeStyle/.style = {",
                "thin, double distance=",
                record.edgeThickness, "pt} }\n\n" );
            for e in Edges(subsurf) do
                for i in [1..Size(edgeData[e])] do
                    AppendTo(output, "\\draw[ EdgeStyle, double=", 
                        record.edgeColours[ ColourOfEdgeNC(surface,e) ],
                        "] ",
                        "(V", edgeData[e][i][1][1], "_", edgeData[e][i][1][2],
                        ") -- " );
                    if record.edgeLabelling then
                        AppendTo( output, "node { $e_{", e, "}$ } " );
                    fi;
                    AppendTo(output,                     
                        "(V", edgeData[e][i][2][1], "_", edgeData[e][i][2][2], ");\n");
                od;
            od;

            AppendTo( output, "\n\n\n" );

            # Label the vertices
            if record.vertexLabelling then
                AppendTo( output, 
                    "\\tikzset{VertexStyle/.style = {\n ",
                    "shape = circle,\n ",
                    "ball color = ", record.vertexColour, ",\n ", 
                    "text = black,\n ",
                    "inner sep = 2pt,\n ",
                    "outer sep = 0pt,\n ",
                    "minimum size = 10pt} }\n\n");
                for v in Vertices( subsurf ) do
                    for i in [1..Size(vertexCoordinates[v])] do
                        AppendTo( output,
                            "\\node[VertexStyle] at (V", v, "_", i, ") {", v, "};\n" ); 
                    od;
                od;
            fi;

            
            AppendTo( output, "\n\\end{tikzpicture}\n" );
        od;
        AppendTo( output, "\n\\end{document} \n" );
        CloseStream(output);
        Print( "Picture written (in tikz).\n");

        if record.compileLaTeX then
            Print( "Start LaTeX-compilation.\n" );

            # Run pdfLaTeX on the file (without visible output)
            Exec( "pdflatex ", name, " > /dev/null" );
            Print( "Picture rendered (with pdflatex).\n");
        fi;

        # Return the finished printing record that encodes the drawing process
        record.startingFaces := realStarts;
        record.edgeDrawOrder := realEdgeDraw;
        return record;
    end
);


InstallMethod( WildIncidenceGraph, "for a wild simplicial surface",
    [ IsWildSimplicialSurface ],
    function( wildSurf )
        local maxVertex, maxEdge, maxFace, edgeList, colourList, v, e, f,
            colSet;

        maxVertex := Maximum( Vertices(wildSurf) );
        maxEdge := Maximum( Edges(wildSurf) );

        if maxVertex <> NrOfVertices(wildSurf) or
            maxEdge <> NrOfEdges(wildSurf) or 
            Maximum( Faces(wildSurf) ) <> NrOfFaces(wildSurf) then
            Error("Only works for dense lists at the moment because of the Nauty-Interface\n");
        fi;

        edgeList := [];
        colourList := [];

        for v in Vertices(wildSurf) do
            colourList[v] := 1;
        od;

        for e in Edges(wildSurf) do
            colourList[maxVertex + e] := 2;
            Append(edgeList, List( VerticesOfEdges(wildSurf)[e], v -> [maxVertex + e,v] ) );
        od;

        for f in Faces(wildSurf) do
            colourList[maxVertex + maxEdge + f] := 3;
            Append(edgeList, List( EdgesOfFaces(wildSurf)[f], e -> [maxVertex + maxEdge + f, maxVertex + e] ) );
        od;

        for colSet in EdgesOfColours(wildSurf) do
            Append( edgeList, Combinations(List(colSet,e->maxVertex+e),2) );
        od;

        return NautyColoredGraph( edgeList, colourList );
    end
);


InstallMethod( AutomorphismGroup, "for a wild simplicial surface",
    [ IsWildSimplicialSurface ],
    function( wildSurf )
        return AutomorphismGroup( WildIncidenceGraph( wildSurf ) );
    end
);

InstallMethod( IsIsomorphicWildSimplicialSurface, 
    "for two wild simplicial surfaces",
    [ IsWildSimplicialSurface, IsWildSimplicialSurface ],
    function( ws1, ws2 )
        local wg1, wg2, canLabel1, canLabel2, newEdges1, newEdges2, 
            ActionOnListIndices, newColours1, newColours2;

        # The two surfaces are isomorphic if and only if their wild incidence
        # graphs w1 and w2 are isomorphic. Those are isomorphic if and only
        # if w1*c1 and w2*c2 are equal (where c1, c2 are the canonical
        # labelings of the graphs). 
        wg1 := WildIncidenceGraph(ws1);
        wg2 := WildIncidenceGraph(ws2);

        # Compute the canonical labelings
        canLabel1 := CanonicalLabeling(wg1);
        canLabel2 := CanonicalLabeling(wg2);

        # Compute the canonical forms
        newEdges1 := OnTuplesTuples( wg1!.edges, canLabel1^(-1) );
        newEdges2 := OnTuplesTuples( wg2!.edges, canLabel2^(-1) );

        newEdges1 := Set( List( newEdges1, e -> Set(e) ) );
        newEdges2 := Set( List( newEdges2, e -> Set(e) ) );
        

        newColours1 := Permuted( wg1!.colors, canLabel1^(-1) );
        newColours2 := Permuted( wg2!.colors, canLabel2^(-1) );

        
        return newEdges1 = newEdges2 and newColours1 = newColours2;
    end
);


InstallMethod( WildIsomorphismRepresentatives, "for a list of wild simplicial surfaces",
    [IsList],
    function( wildList )
        local rep, isNew, test, old;
        
        rep := [];
        for test in wildList do
            isNew := true;
            for old in rep do
                if isNew and IsIsomorphicWildSimplicialSurface(old,test) then
                    isNew := false;
                fi;
            od;

            if isNew then
                Add(rep, test);
            fi;
        od;

        return rep;
    end
);

##
##          End of drawing methods
###############################################################################
###############################################################################

#! @DoNotReadRestOfFile


##
##	Define the method selection graph for the package.
##
BindGlobal( "SIMPLICIAL_METHOD_SELECTION_GRAPH", MethodSelectionGraph([]) );


##############################################################################
##
#W  simplicial_surface.gi          Simplicial               Alice Niemeyer
#W                                                        Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Alice Niemeyer, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##
##  The functions in this file compute with simplicial surfaces.
##
##


##
##	Declare the generic representation of simplicial surfaces that does nothing.
##
DeclareRepresentation("IsSimplicialSurfaceRep", IsSimplicialSurface, [ ] );
##
##	Define a type so we can use Objectify.
##
SimplicialSurfaceType := 
	NewType( SimplicialSurfaceFamily, IsSimplicialSurfaceRep );



##
#!	@Description
#!	This function calls
#!		Objectify( type, rec )
#!	and afterwards copies all attributes and properties of the simplicial
#!	surface modelSurf that are declared in this section to the the new object.
#!	This method has to be overwritten for a specialization of this class.
#!
#!	WARNING: The type can't be checked! Only types that are derived from
#!	IsSimplicialSurface can be used with impunity!
#!
#!	@Arguments a type, a record, a simplicial surface
#!	@Returns an object of type type
InstallMethod( ObjectifySimplicialSurface, "",
		[IsType,IsRecord,IsSimplicialSurface],
	function( type, record, modelSurf )
		local newOb, attributeList, currentAttribute, currentAttributeString;

		newOb := Objectify( type, record );

		# copy all relevant attributes (implementation by suggestion of
		# Sebastian Gutsche)
		attributeList := [ "VerticesAttributeOfSimplicialSurface",
			"Edges", 
			"Faces",
			"NrOfVertices",
			"NrOfEdges",
			"NrOfFaces",
			"EdgesOfVertices",
			"FacesOfVertices",
			"VerticesOfEdges",
			"FacesOfEdges",
			"VerticesOfFaces",
			"EdgesOfFaces",
			"IsEdgesLikeSurface",
			"IsVerticesLikeSurface",
			"IsTriangleSurface",
			"IsOrientable",
			"IsConnected",
			"ConnectedComponentsAttributeOfSimplicialSurface",
			"EulerCharacteristic",
			"UnsortedDegrees",
			"SortedDegrees",
			"VertexSymbol",
			"FaceEdgePathsOfVertices",
			"LocalOrientationByVerticesAsPerm",
			"LocalOrientationByVerticesAsList",
			"LocalOrientationByEdgesAsPerm",
			"LocalOrientationByEdgesAsList",
			"NamesOfFaces",
			"IsFaceNamesDefault",
			"FaceAnomalyClasses",
			"IncidenceGraph"];
		for currentAttributeString in attributeList do
			# Find the attribute that corresponds to the given name
			currentAttribute := ValueGlobal( currentAttributeString );
			if Tester( currentAttribute )( modelSurf) then
				Setter( currentAttribute )( newOb, 
											currentAttribute( modelSurf ) );
			fi;
		od;

		return newOb;
	end
);

InstallMethod( DeriveLocalOrientationAndFaceNamesFromIncidenceGeometry, "",
		[IsSimplicialSurface],
	function( surf )
		local attrList, attrName, attr;

		attrList := [ "LocalOrientationByVerticesAsPerm",
			"LocalOrientationByVerticesAsList",
			"LocalOrientationByEdgesAsPerm",
			"LocalOrientationByEdgesAsList",
			"IsFaceNamesDefault",
			"NamesOfFaces" ];
		for attrName in attrList do
			attr := ValueGlobal( attrName );
			if Tester(attr)(surf) then
				Error("DeriveLocalOrientationAndFaceNamesFromIncidenceGeometry: Some attributes are already set.");
			fi;
		od;

		DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(surf);
	end
);

##
##	This method returns a VerticesOfFaces as lists (not sets) such that
##	adjacent vertices lie in a common edge. There is no guarantee about which
##	ordering of the vertices will be chosen.
##
BindGlobal( "__SIMPLICIAL_RandomVerticesOfFaces", function( vertices, faces, 
		verticesOfFaces, edgesOfFaces, edgesOfVertices )
	local faceList, i, faceVertices, vertexList, lastVertex, newVertex, v,
		inter;

	faceList := [];
	for i in faces do
		faceVertices := verticesOfFaces[i];
		vertexList := [];

		# Pick one to be the first vertex
		vertexList[1] := faceVertices[1];
		faceVertices := Difference( faceVertices, vertexList );

		# Pick the other vertices such that each one shares an edge with the 
		# vertex that was picked the last time
		while not IsEmpty(faceVertices) do
			# Find one vertex that is adjacent to the last one in vertexOrder
			lastVertex := vertexList[ Length(vertexList) ];
			newVertex := -1;
			for v in faceVertices do
				inter := Intersection( edgesOfFaces[i], 
							edgesOfVertices[lastVertex], edgesOfVertices[v] ); 
				if not IsEmpty( inter ) then
					newVertex := v;
				fi;
			od;

			if newVertex = -1 then
				Error("__SIMPLICIAL_RandomVerticesOfFaces: No next vertex found." );
			fi;

			Append( vertexList, [newVertex] );
			faceVertices := Difference( faceVertices, [newVertex] );
		od;

		faceList[i] := vertexList;
	od;

	return faceList;
end);

InstallMethod( DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC, "",
		[IsSimplicialSurface],
	function( surf )
		local verticesOfFaces;
	
		# Set the local orientation at random
		verticesOfFaces := __SIMPLICIAL_RandomVerticesOfFaces( Vertices(surf), 
			Faces(surf),
			VerticesOfFaces(surf), EdgesOfFaces(surf), EdgesOfVertices(surf) );
		SetLocalOrientationByVerticesAsList( surf, verticesOfFaces );

		# Set the face names
		SetIsFaceNamesDefault( surf, true );
	end
);

#############################################################################
#############################################################################
##
##						Start of constructors
##
##	While GAP has a type system that is nice in general, what it REALLY doesn't
##	like is overloading of methods. Therefore you can't just declare them
##	but you have to sneak them in by using InstallOtherMethod().
##
##	We start with the general constructor. Since we give so many options we
##	have to define a lot of methods and we need many helper-methods.
##


#############################
##
##	This is the constructor from downward incidence where the orientation
##	of the faces is implicit in the call
##
InstallMethod( SimplicialSurfaceByDownwardIncidenceWithOrientationNC, "",
	[ IsSet, IsSet, IsSet, IsList, IsList ],
	function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )
		local surf, namesOfFaces;

		surf := Objectify( SimplicialSurfaceType, rec() );
		# Set the given attributes
		SetVerticesAttributeOfSimplicialSurface( surf, vertices );
		SetEdges( surf, edges );
		SetFaces( surf, faces );
		SetVerticesOfEdges( surf, 
								List( verticesOfEdges, i -> Set(i) ) );
		SetLocalOrientationByEdgesAsList( surf, 
								edgesOfFaces );

		# Set the face names
		namesOfFaces := ValueOption( "NamesOfFaces" );
		if namesOfFaces = fail then
			SetIsFaceNamesDefault( surf, true );
		else
			SetNamesOfFaces( surf, namesOfFaces );
		fi;

		return surf;
	end
);
	RedispatchOnCondition( 
		SimplicialSurfaceByDownwardIncidenceWithOrientationNC,
		true, [ IsList, IsList, IsList, IsList, IsList],
		[ IsSet, IsSet, IsSet, , ], 0 );
	##
	##	Adjust for the alternative possibilities.
	InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceWithOrientationNC, 
		"",	[ IsPosInt, IsObject, IsObject, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )
			return SimplicialSurfaceByDownwardIncidenceWithOrientationNC( 
				[1..vertices], edges, faces, verticesOfEdges, edgesOfFaces );
		end
	);

	InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceWithOrientationNC, 
		"",	[ IsSet, IsPosInt, IsObject, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )
			return SimplicialSurfaceByDownwardIncidenceWithOrientationNC( 
				vertices, [1..edges],	faces, verticesOfEdges, edgesOfFaces );
		end
	);
		RedispatchOnCondition( 
			SimplicialSurfaceByDownwardIncidenceWithOrientationNC, 
			true, [ IsList, IsPosInt, IsObject, IsList, IsList],
			[ IsSet, , , , ], 0 );

	InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceWithOrientationNC, 
		"",[ IsSet, IsSet, IsPosInt, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )
			return SimplicialSurfaceByDownwardIncidenceWithOrientationNC( 
				vertices, edges, [1..faces], verticesOfEdges, edgesOfFaces );
		end
	);
		RedispatchOnCondition( 
			SimplicialSurfaceByDownwardIncidenceWithOrientationNC, 
			true, [ IsList, IsList, IsPosInt, IsList, IsList],
			[ IsSet, IsSet, , , ], 0 );
##
##	Next we have to install the same constructors with checks.
##
## This global function checks if a set consists of positive integers
BindGlobal( "__SIMPLICIAL_IsSetPosInt", function( set ) 
		local el;
		for el in set do
			if not IsPosInt(el) then
				return false;
			fi;
		od;
		return true;
	end
);
##
##	The argument edgesAdjacent is true if the edges in edgesOfFaces should 
##	conform to the standards of LocalOrientationOfEdgesAsList (that is, two
##	edges that are adjacent in the list should also be adjacent in the surface)
##
BindGlobal( "__SIMPLICIAL_CheckDownwardIncidence", function( vertices, edges, 
	faces, verticesOfEdges, edgesOfFaces, namesOfFaces, edgesAdjacent )
	
	local e, f, IncidentEdges, edgeList, i;

	# Check the sets
	if not __SIMPLICIAL_IsSetPosInt( vertices ) then
		Error("DownwardIncidenceCheck: Vertices have to be positive integers.");
	fi;

	if not __SIMPLICIAL_IsSetPosInt( edges ) then
		Error("DownwardIncidenceCheck: Edges have to be positive integers.");
	fi;

	if not __SIMPLICIAL_IsSetPosInt( faces ) then
		Error("DownwardIncidenceCheck: Faces have to be positive integers.");
	fi;

	# Is verticesOfEdges well defined?
	for e in edges do
		if not IsBound( verticesOfEdges[e] ) then
			Error("DownwardIncidenceCheck: One edge has no vertices.");
		elif Size( Set( verticesOfEdges[e] ) ) <> 2 then
			Error("DownwardIncidenceCheck: One edge has not two vertices.");
		elif not IsEmpty( Difference( Set(verticesOfEdges[e]), vertices ) ) then
			Error("DownwardIncidenceCheck: One edge has illegal vertex.");
		fi;
	od;
			# Number only counts bound entries
	if Number( verticesOfEdges ) <> Length( edges ) then 
		Error("DownwardIncidenceCheck: More edges than expected.");
	fi;
	if Union( verticesOfEdges ) <> vertices then
		Error("DownwardIncidenceCheck: One vertex does not lie in any edge.");
	fi;

	# Is edgesOfFaces well defined?
	for f in faces do
		if not IsBound( edgesOfFaces[f] ) then
			Error("DownwardIncidenceCheck: One face has no edges.");
		elif Size( Set( edgesOfFaces[f] ) ) < 3 then
			Error("DownwardIncidenceCheck: One face has less than three edges.");
		elif not IsEmpty( Difference( Set(edgesOfFaces[f]), edges ) ) then
			Error("DownwardIncidenceCheck: One face has illegal edge.");
		fi;
	od;
	if Number( edgesOfFaces ) <> Length( faces ) then
		Error("DownwardIncidenceCheck: More faces than expected.");
	fi;
	if Union( edgesOfFaces ) <> edges then
		Error("DownwardIncidenceCheck: One edge does not lie in any face.");
	fi;

	# Special check for the orientation preserving constructor
	if edgesAdjacent then
		IncidentEdges := function( verticesOfEdges, edge1, edge2 )
			local vert1, vert2, inter;

			vert1 := verticesOfEdges[edge1];
			vert2 := verticesOfEdges[edge2];
			inter := Intersection( vert1, vert2 );
		
			if Length(inter) <> 1 then
				Error("DownwardIncidenceCheck: Adjacent edges in the list have to be adjacent in the surface." );
			fi;
			
			return;
		end;

		for f in faces do
			edgeList := edgesOfFaces[f];
			
			IncidentEdges( verticesOfEdges, edgeList[1], 
										edgeList[ Length(edgeList) ] );
			for i in [2..Length(edgeList)] do
				IncidentEdges( verticesOfEdges, edgeList[i-1], edgeList[i] );
			od;
		od;
	fi;

	# Check the face names
	if not namesOfFaces = fail then
		for f in faces do
			if not IsBound( namesOfFaces[f] ) then
				Error("DownwardIncidenceCheck: One face has no names.");
			elif Size( Set( namesOfFaces[f] ) ) <> 2 then
				Error("DownwardIncidenceCheck: One face has not two different names.");
			elif not IsInt(namesOfFaces[f][1]) 
					or not IsInt(namesOfFaces[f][2]) then
				Error("DownwardIncidenceCheck: One face has non-integer names.");
			fi;
		od;
		if Number( namesOfFaces ) <> Length( faces ) then
			Error("DownwardIncidenceCheck: More face-names than expected.");
		fi;
	fi;
end);
##############################
##
InstallMethod( SimplicialSurfaceByDownwardIncidenceWithOrientation, "",
	[ IsSet, IsSet, IsSet, IsList, IsList ],
	function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )

		__SIMPLICIAL_CheckDownwardIncidence( vertices, edges, faces,
			verticesOfEdges, edgesOfFaces, ValueOption( "NamesOfFaces" ), true);

		return SimplicialSurfaceByDownwardIncidenceWithOrientationNC( 
					vertices, edges, faces, verticesOfEdges, edgesOfFaces );
	end
);
	RedispatchOnCondition( SimplicialSurfaceByDownwardIncidenceWithOrientation, 
		true, [ IsList, IsList, IsList, IsList, IsList],
		[ IsSet, IsSet, IsSet, , ], 0 );
	##
	##	Adjust for the alternative possibilities.
	InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceWithOrientation, "",
		[ IsPosInt, IsObject, IsObject, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )
			return SimplicialSurfaceByDownwardIncidenceWithOrientation( 
				[1..vertices], edges, faces, verticesOfEdges, edgesOfFaces );
		end
	);

	InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceWithOrientation, "",
		[ IsSet, IsPosInt, IsObject, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )
			return SimplicialSurfaceByDownwardIncidenceWithOrientation( 
				vertices, [1..edges],	faces, verticesOfEdges, edgesOfFaces );
		end
	);
		RedispatchOnCondition( 
			SimplicialSurfaceByDownwardIncidenceWithOrientation, 
			true, [ IsList, IsPosInt, IsObject, IsList, IsList],
			[ IsSet, , , , ], 0 );

	InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceWithOrientation, "",
		[ IsSet, IsSet, IsPosInt, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )
			return SimplicialSurfaceByDownwardIncidenceWithOrientation( 
				vertices, edges, [1..faces], verticesOfEdges, edgesOfFaces );
		end
	);
		RedispatchOnCondition( 
			SimplicialSurfaceByDownwardIncidenceWithOrientation, 
			true, [ IsList, IsList, IsPosInt, IsList, IsList],
			[ IsSet, IsSet, , , ], 0 );
##
##
##
##

############################
##
##	Next we install the "easy mode" of the above constructor.
InstallMethod( SimplicialSurfaceByDownwardIncidenceNC, "",
	[ IsSet, IsSet, IsSet, IsList, IsList ],
	function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )
		local surf;

		surf := Objectify( SimplicialSurfaceType, rec() );
		# Set the given attributes
		SetVerticesAttributeOfSimplicialSurface( surf, vertices );
		SetEdges( surf, edges );
		SetFaces( surf, faces );
		SetVerticesOfEdges( surf, List( verticesOfEdges, i -> Set(i) ) );
		SetEdgesOfFaces( surf, List( edgesOfFaces, i -> Set(i) ) );

		# Set local orientation and face names
		DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(surf);
		
		return surf;
	end
);
	RedispatchOnCondition( SimplicialSurfaceByDownwardIncidenceNC,
		true, [ IsList, IsList, IsList, IsList, IsList],
		[ IsSet, IsSet, IsSet, , ], 0 );
	##
	##	Adjust for the alternative possibilities.
	InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceNC, "",
		[ IsPosInt, IsObject, IsObject, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )
			return SimplicialSurfaceByDownwardIncidenceNC( [1..vertices], edges,
				faces, verticesOfEdges, edgesOfFaces );
		end
	);

	InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceNC, "",
		[ IsSet, IsPosInt, IsObject, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )
			return SimplicialSurfaceByDownwardIncidenceNC( vertices, [1..edges],
				faces, verticesOfEdges, edgesOfFaces );
		end
	);
		RedispatchOnCondition( SimplicialSurfaceByDownwardIncidenceNC, 
			true, [ IsList, IsPosInt, IsObject, IsList, IsList],
			[ IsSet, , , , ], 0 );

	InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceNC, "",
		[ IsSet, IsSet, IsPosInt, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )
			return SimplicialSurfaceByDownwardIncidenceNC( vertices, edges,
				[1..faces], verticesOfEdges, edgesOfFaces );
		end
	);
		RedispatchOnCondition( SimplicialSurfaceByDownwardIncidenceNC, 
			true, [ IsList, IsList, IsPosInt, IsList, IsList],
			[ IsSet, IsSet, , , ], 0 );

#################################
##
##	Next we have to install the same constructors with checks.
InstallMethod( SimplicialSurfaceByDownwardIncidence, "",
	[ IsSet, IsSet, IsSet, IsList, IsList ],
	function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )
		
		__SIMPLICIAL_CheckDownwardIncidence( vertices, edges, faces,
			verticesOfEdges, edgesOfFaces, fail, false );

		return SimplicialSurfaceByDownwardIncidenceNC( 
					vertices, edges, faces, verticesOfEdges, edgesOfFaces );
	end
);
	RedispatchOnCondition( SimplicialSurfaceByDownwardIncidence, 
		true, [ IsList, IsList, IsList, IsList, IsList],
		[ IsSet, IsSet, IsSet, , ], 0 );
	##
	##	Adjust for the alternative possibilities.
	InstallOtherMethod( SimplicialSurfaceByDownwardIncidence, "",
		[ IsPosInt, IsObject, IsObject, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )
			return SimplicialSurfaceByDownwardIncidence( 
				[1..vertices], edges, faces, verticesOfEdges, edgesOfFaces );
		end
	);

	InstallOtherMethod( SimplicialSurfaceByDownwardIncidence, "",
		[ IsSet, IsPosInt, IsObject, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )
			return SimplicialSurfaceByDownwardIncidence( vertices, 
				[1..edges],	faces, verticesOfEdges, edgesOfFaces );
		end
	);
		RedispatchOnCondition( SimplicialSurfaceByDownwardIncidence, 
			true, [ IsList, IsPosInt, IsObject, IsList, IsList],
			[ IsSet, , , , ], 0 );

	InstallOtherMethod( SimplicialSurfaceByDownwardIncidence, "",
		[ IsSet, IsSet, IsPosInt, IsList, IsList ],
		function( vertices, edges, faces, verticesOfEdges, edgesOfFaces )
			return SimplicialSurfaceByDownwardIncidence( vertices, 
				edges, [1..faces], verticesOfEdges, edgesOfFaces );
		end
	);
		RedispatchOnCondition( SimplicialSurfaceByDownwardIncidence, 
			true, [ IsList, IsList, IsPosInt, IsList, IsList],
			[ IsSet, IsSet, , , ], 0 );

##
##
############################
##
##	Next is the constructor ByUpwardIncidence
InstallMethod( SimplicialSurfaceByUpwardIncidenceNC, "",
	[ IsSet, IsSet, IsSet, IsList, IsList ],
	function( vertices, edges, faces, edgesOfVertices, facesOfEdges )
		local surf;

		surf := Objectify( SimplicialSurfaceType, rec() );
		# Set the given attributes
		SetVerticesAttributeOfSimplicialSurface( surf, vertices );
		SetEdges( surf, edges );
		SetFaces( surf, faces );
		SetEdgesOfVertices( surf, List( edgesOfVertices, i -> Set(i) ) );
		SetFacesOfEdges( surf, List( facesOfEdges, i -> Set(i) ) );

		# Set local orientation and face names
		DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(surf);
		
		return surf;
	end
);
	RedispatchOnCondition( SimplicialSurfaceByUpwardIncidenceNC,
		true, [ IsList, IsList, IsList, IsList, IsList],
		[ IsSet, IsSet, IsSet, , ], 0 );
	##
	##	Adjust for the alternative possibilities.
	InstallOtherMethod( SimplicialSurfaceByUpwardIncidenceNC, "",
		[ IsPosInt, IsObject, IsObject, IsList, IsList ],
		function( vertices, edges, faces, edgesOfVertices, facesOfEdges )
			return SimplicialSurfaceByUpwardIncidenceNC( [1..vertices], edges,
				faces, edgesOfVertices, facesOfEdges );
		end
	);

	InstallOtherMethod( SimplicialSurfaceByUpwardIncidenceNC, "",
		[ IsSet, IsPosInt, IsObject, IsList, IsList ],
		function( vertices, edges, faces, edgesOfVertices, facesOfEdges )
			return SimplicialSurfaceByUpwardIncidenceNC( vertices, [1..edges],
				faces, edgesOfVertices, facesOfEdges );
		end
	);
		RedispatchOnCondition( SimplicialSurfaceByUpwardIncidenceNC, 
			true, [ IsList, IsPosInt, IsObject, IsList, IsList],
			[ IsSet, , , , ], 0 );

	InstallOtherMethod( SimplicialSurfaceByUpwardIncidenceNC, "",
		[ IsSet, IsSet, IsPosInt, IsList, IsList ],
		function( vertices, edges, faces, edgesOfVertices, facesOfEdges )
			return SimplicialSurfaceByUpwardIncidenceNC( vertices, edges,
				[1..faces], edgesOfVertices, facesOfEdges );
		end
	);
		RedispatchOnCondition( SimplicialSurfaceByUpwardIncidenceNC, 
			true, [ IsList, IsList, IsPosInt, IsList, IsList],
			[ IsSet, IsSet, , , ], 0 );

#################################
##
##	Next we have to install the same constructors with checks.
BindGlobal( "__SIMPLICIAL_CheckUpwardIncidence", function( vertices, edges, 
	faces, edgesOfVertices, facesOfEdges, namesOfFaces )
	
	local e, v, IncidentEdges, edgeList, i;

	# Check the sets
	if not __SIMPLICIAL_IsSetPosInt( vertices ) then
		Error("UpwardIncidenceCheck: Vertices have to be positive integers.");
	fi;

	if not __SIMPLICIAL_IsSetPosInt( edges ) then
		Error("UpwardIncidenceCheck: Edges have to be positive integers.");
	fi;

	if not __SIMPLICIAL_IsSetPosInt( faces ) then
		Error("UpwardIncidenceCheck: Faces have to be positive integers.");
	fi;

	# Is edgesOfVertices well defined?
	for v in vertices do
		if not IsBound( edgesOfVertices[v] ) then
			Error("UpwardIncidenceCheck: One vertex has no edges.");
		elif not IsEmpty( Difference( Set(edgesOfVertices[v]), edges ) ) then
			Error("UpwardIncidenceCheck: One vertex has illegal edge.");
		fi;
	od;
			# Number only counts bound entries
	if Number( edgesOfVertices ) <> Length( vertices ) then 
		Error("UpwardIncidenceCheck: More vertices than expected.");
	fi;
	if Union( edgesOfVertices ) <> edges then
		Error("UpwardIncidenceCheck: One edge does not lie in any vertex.");
	fi;

	# Is facesOfEdges well defined?
	for e in edges do
		if not IsBound( facesOfEdges[e] ) then
			Error("UpwardIncidenceCheck: One edge has no faces.");
		elif not IsEmpty( Difference( Set(facesOfEdges[e]), faces ) ) then
			Error("UpwardIncidenceCheck: One edge has illegal face.");
		fi;
	od;
	if Number( facesOfEdges ) <> Length( edges ) then
		Error("UpwardIncidenceCheck: More edges than expected.");
	fi;
	if Union( facesOfEdges ) <> faces then
		Error("UpwardIncidenceCheck: One face does not lie in any edge.");
	fi;

end);
InstallMethod( SimplicialSurfaceByUpwardIncidence, "",
	[ IsSet, IsSet, IsSet, IsList, IsList ],
	function( vertices, edges, faces, edgesOfVertices, facesOfEdges )
		
		__SIMPLICIAL_CheckUpwardIncidence( vertices, edges, faces,
			edgesOfVertices, facesOfEdges );

		return SimplicialSurfaceByUpwardIncidenceNC( 
					vertices, edges, faces, edgesOfVertices, facesOfEdges );
	end
);
	RedispatchOnCondition( SimplicialSurfaceByUpwardIncidence, 
		true, [ IsList, IsList, IsList, IsList, IsList],
		[ IsSet, IsSet, IsSet, , ], 0 );
	##
	##	Adjust for the alternative possibilities.
	InstallOtherMethod( SimplicialSurfaceByUpwardIncidence, "",
		[ IsPosInt, IsObject, IsObject, IsList, IsList ],
		function( vertices, edges, faces, edgesOfVertices, facesOfEdges )
			return SimplicialSurfaceByUpwardIncidence( 
				[1..vertices], edges, faces, edgesOfVertices, facesOfEdges );
		end
	);

	InstallOtherMethod( SimplicialSurfaceByUpwardIncidence, "",
		[ IsSet, IsPosInt, IsObject, IsList, IsList ],
		function( vertices, edges, faces, edgesOfVertices, facesOfEdges )
			return SimplicialSurfaceByUpwardIncidence( vertices, 
				[1..edges],	faces, edgesOfVertices, facesOfEdges );
		end
	);
		RedispatchOnCondition( SimplicialSurfaceByUpwardIncidence, 
			true, [ IsList, IsPosInt, IsObject, IsList, IsList],
			[ IsSet, , , , ], 0 );

	InstallOtherMethod( SimplicialSurfaceByUpwardIncidence, "",
		[ IsSet, IsSet, IsPosInt, IsList, IsList ],
		function( vertices, edges, faces, edgesOfVertices, facesOfEdges )
			return SimplicialSurfaceByUpwardIncidence( vertices, 
				edges, [1..faces], edgesOfVertices, facesOfEdges );
		end
	);
		RedispatchOnCondition( SimplicialSurfaceByUpwardIncidence, 
			true, [ IsList, IsList, IsPosInt, IsList, IsList],
			[ IsSet, IsSet, , , ], 0 );




##
############################
##
##	Now we implement the constructor byVerticesInFaces. We start with the
##	NC-versions. The local orientation is always given by the verticesOfFaces
##	since the edges are constructed in this way.
InstallMethod( SimplicialSurfaceByVerticesInFacesNC, "",
	[ IsSet, IsSet, IsList ],
	function( vertices, faces, verticesOfFaces )
		local surf, namesOfFaces, verticesOfEdges, AdjacentVertices, 
				edgesOfFaces, f, j, e, facesBySetEdges;

		# Determine the edges. For each face we determine all subset of its
		# vertices that contain two elements which are adjacent in the list
		# of this face. These sets will form the edges
		# of the simplicial surface
		AdjacentVertices := function( list )
			local vertexSet, i;

			vertexSet := [ Set( [list[1], list[ Length(list) ] ] ) ];
			for i in [2..Length(list)] do
				Append( vertexSet, [ Set( [ list[i-1], list[i] ] ) ] );
			od;
			return Set(vertexSet);
		end;
			
		facesBySetEdges := List( faces, i -> 
							AdjacentVertices( verticesOfFaces[i] ) );
		verticesOfEdges := Union(facesBySetEdges);

		edgesOfFaces := List(faces,i->[]);
		for f in faces do
			for j  in [1..3] do
				e := facesBySetEdges[f][j];
				edgesOfFaces[f][j] := Position(verticesOfEdges,e);
			od;
		od;

		surf := Objectify( SimplicialSurfaceType, rec() );
		# Set the given attributes
		SetVerticesAttributeOfSimplicialSurface( surf, vertices );
		SetEdges( surf, 
									[1..Length(verticesOfEdges)] );
		SetFaces( surf, faces );
		SetVerticesOfEdges( surf, verticesOfEdges );
		SetEdgesOfFaces( surf, edgesOfFaces );
		SetLocalOrientationByVerticesAsList( surf, 
												verticesOfFaces );

		# Set the face names
		namesOfFaces := ValueOption( "NamesOfFaces" );
		if namesOfFaces = fail then
			SetIsFaceNamesDefault( surf, true );
		else
			SetNamesOfFaces( surf, namesOfFaces );
		fi;

		return surf;
	end
);
	RedispatchOnCondition( SimplicialSurfaceByVerticesInFacesNC, 
		true, [ IsList, IsList, IsList],
		[ IsSet, IsSet, ], 0 );

	##	Adjust for the alternative possibilities.
	InstallOtherMethod( SimplicialSurfaceByVerticesInFacesNC, "",
		[ IsPosInt, IsObject, IsList ],
		function( vertices, faces, verticesOfFaces )
			return SimplicialSurfaceByVerticesInFacesNC( 
				[1..vertices], faces, verticesOfFaces );
		end
	);
	InstallOtherMethod( SimplicialSurfaceByVerticesInFacesNC, "",
		[ IsSet, IsPosInt, IsList ],
		function( vertices, faces, verticesOfFaces )
			return SimplicialSurfaceByVerticesInFacesNC( vertices, 
				[1..faces],	verticesOfFaces );
		end
	);
		RedispatchOnCondition( SimplicialSurfaceByVerticesInFacesNC, 
			true, [ IsList, IsPosInt, IsList],
			[ IsSet, , ], 0 );
##
##	Of course the same constructors with sanity checks can't be missing.
##
BindGlobal( "__SIMPLICIAL_CheckVerticesInFaces", function( vertices, faces, 
		verticesOfFaces, namesOfFaces )
	
	local f;

	# Check sets
	if not __SIMPLICIAL_IsSetPosInt( vertices ) then
		Error("VerticesInFacesCheck: Vertices have to be positive integers.");
	fi;

	if not __SIMPLICIAL_IsSetPosInt( faces ) then
		Error("VerticesInFacesCheck: Faces have to be positive integers.");
	fi;

	# Is verticesOfFaces well defined?
	for f in faces do
		if not IsBound( verticesOfFaces[f] ) then
			Error("VerticesInFacesCheck: One face has no vertices.");
		elif Size( Set( verticesOfFaces[f] ) ) < 3 then
			Error("VerticesInFacesCheck: One face has less than three vertices.");
		elif not IsEmpty( Difference( Set(verticesOfFaces[f]), vertices ) ) then
			Error("VerticesInFacesCheck: One face has illegal vertex.");
		fi;
	od;
	if Number( verticesOfFaces ) <> Length( faces ) then
		Error("VerticesInFacesCheck: More faces than expected.");
	fi;

	# Check the face names
	if not namesOfFaces = fail then
		for f in faces do
			if not IsBound( namesOfFaces[f] ) then
				Error("VerticesInFacesCheck: One face has no names.");
			elif Size( Set( namesOfFaces[f] ) ) <> 2 then
				Error("VerticesInFacesCheck: One face has not two different names.");
			elif not IsInt(namesOfFaces[f][1]) 
					or not IsInt(namesOfFaces[f][2]) then
				Error("VerticesInFacesCheck: One face has non-integer names.");
			fi;
		od;
		if Number( namesOfFaces ) <> Length( faces ) then
			Error("VerticesInFacesCheck: More face-names than expected.");
		fi;
	fi;
end);
###########################
##
InstallMethod( SimplicialSurfaceByVerticesInFaces, "",
	[ IsSet, IsSet, IsList ],
	function( vertices, faces, verticesOfFaces )
		
		__SIMPLICIAL_CheckVerticesInFaces( vertices, faces, verticesOfFaces, 
			ValueOption( "NamesOfFaces" ) );

		return SimplicialSurfaceByVerticesInFacesNC( 
					vertices, faces, verticesOfFaces );
	end
);
	RedispatchOnCondition( SimplicialSurfaceByVerticesInFaces, true,
		[ IsList, IsList, IsList],
		[ IsSet, IsSet, ], 0 );
	##	Adjust for the alternative possibilities.
	InstallOtherMethod( SimplicialSurfaceByVerticesInFaces, "",
		[ IsPosInt, IsObject, IsList ],
		function( vertices, faces, verticesOfFaces )
			return SimplicialSurfaceByVerticesInFaces( 
				[1..vertices], faces, verticesOfFaces );
		end
	);
	InstallOtherMethod( SimplicialSurfaceByVerticesInFaces, "",
		[ IsSet, IsPosInt, IsList ],
		function( vertices, faces, verticesOfFaces )
			return SimplicialSurfaceByVerticesInFaces( vertices, 
				[1..faces],	verticesOfFaces );
		end
	);
		RedispatchOnCondition( SimplicialSurfaceByVerticesInFaces, true,
			[ IsList, IsPosInt, IsList],
			[ IsSet, , ], 0 );
##
##							End of constructors
##
#############################################################################
#############################################################################


#! @Description
#! Returns the numbers of the vertices as a set. This is a basic method.
#! @Arguments a simplicial surface
#! @Returns a dense list of integers
InstallMethod( Vertices, "for a simplicial surface", [ IsSimplicialSurface ],
	function(simpsurf)
		return VerticesAttributeOfSimplicialSurface( simpsurf );
	end
);


##
##	Since vertices, edges and faces can be computed (more or less implicitly)
##	from many different other attributes, we include them in the method
##	selection graph.
##
InstallMethod( VerticesAttributeOfSimplicialSurface, "for a simplicial surface",
	[ IsSimplicialSurface ],
	function( surf )
		return ComputeProperty( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
					VerticesAttributeOfSimplicialSurface, surf );
	end
);
InstallMethod( Edges, "for a simplicial surface", [ IsSimplicialSurface ],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, Edges, surf);
	end
);
InstallMethod( Faces, "for a simplicial surface", [ IsSimplicialSurface ],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, Faces, surf);
	end
);




#############################################################################
##
#!	@Description
#!	This function returns the number of vertices.
#!	@Returns an integer
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( NrOfVertices, "for a simplicial surface", 
	[ IsSimplicialSurface ],
	function(simpsurf)
		return Length( Vertices(simpsurf) );
	end
);

#############################################################################
##
#!	@Description
#!	This function returns the number of edges.
#!	@Returns an integer
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( NrOfEdges, "for a simplicial surface", [ IsSimplicialSurface ],
	function(simpsurf)
		return Length( Edges(simpsurf) );
	end
);

#############################################################################
##
#!	@Description
#!	This function returns the number of faces.
#!	@Returns an integer
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( NrOfFaces, "for a simplicial surface", [ IsSimplicialSurface ],
	function(simpsurf)
		return Length( Faces(simpsurf) );
	end
);

#############################################################################
##
##  A Print method for simplicial surfaces
##
InstallMethod( PrintStringAttributeOfSimplicialSurface,
	"for a simplicial surface", [IsSimplicialSurface],
	function( simpsurf )
		local str, out;

		str := "";
		out := OutputTextString( str, true );
		PrintTo( out, 
				"SimplicialSurfaceByDownwardIncidenceWithOrientationNC(\n" );
		PrintTo( out, Vertices(simpsurf), ",\n" );
		PrintTo( out, Edges(simpsurf), ",\n" );
		PrintTo( out, Faces(simpsurf), ",\n" );
		PrintTo( out, VerticesOfEdges(simpsurf), ",\n" );
		PrintTo( out, LocalOrientationByEdgesAsList(simpsurf), ",\n" );

		if IsFaceNamesDefault(simpsurf) then
			PrintTo( out, ");\n" );
		else
			PrintTo( out, " : NamesOfFaces := ", 
									NamesOfFaces(simpsurf), ");\n" );
		fi;

		CloseStream(out);

		return str;
	end
);
InstallMethod( PrintObj, "for simplicial surfaces", [ IsSimplicialSurface ], 
	function(simpsurf)
		Print( PrintStringAttributeOfSimplicialSurface( simpsurf ) );
	end
);


#############################################################################
##
##  A Display method for simplicial surfaces
##
InstallMethod( Display, "for simplicial surfaces", [ IsSimplicialSurface ],
	function(simpsurf)

        Print("Vertices: ", Vertices(simpsurf), ",\n");
        Print("Edges: ", Edges(simpsurf), ",\n");
        Print("Faces: ", Faces(simpsurf), ",\n");
        Print("VerticesOfEdges: ", VerticesOfEdges(simpsurf), ",\n");
        Print("EdgesOfFaces: ", EdgesOfFaces(simpsurf), ",\n" );
		Print("LocalOrientation: ", LocalOrientation(simpsurf), ",\n" );
		Print("NamesOfFaces: ", NamesOfFaces(simpsurf), ",\n" );
	end
);

#############################################################################
##
#!  @Description
#!  Check if two simplicial surfaces are equal.
#!  @Returns true or false
#!  @Arguments <s1>, <s2>, two simplicial surface objects
#!
##
InstallMethod( \=, "for two simplicial surfaces", IsIdenticalObj, 
  [ IsSimplicialSurface, IsSimplicialSurface ],
	function( s1, s2 )
		# check all basic attributes

		if Vertices(s1) <> Vertices(s2) then
			return false;
		fi;
		if Edges(s1) <> Edges(s2) then
			return false;
		fi;
		if Faces(s1) <> Faces(s2) then
			return false;
		fi;

		if VerticesOfEdges(s1) <> VerticesOfEdges(s2) then
			return false;
		fi;
		if EdgesOfFaces(s1) <> EdgesOfFaces(s2) then
			return false;
		fi;

		if LocalOrientation(s1) <> LocalOrientation(s2) then
			return false;
		fi;
		if NamesOfFaces(s1) <> NamesOfFaces(s2) then
			return false;
		fi;

        return true;
	end
);


#############################################################################
#############################################################################
##
##						Start of *Of*-methods
##
##	It is pretty annoying to implement all of the *Of*-methods for each
##	individual representation. As they are interdependent, this is also
##	redundant. Therefore we collect some methods here that allow us to only
##	implement a minimal set of these methods. We rely on the fact that we
##	consider the *Of*-objects as attributes which have a corresponding filter
##	which makes it known which of those are already known.
##
##
##	There are exactly four cases in which we know every information from
##	two of those values:
##		EdgesOfFaces and VerticesOfEdges
##		EdgesOfFaces and EdgesOfVertices
##		FacesOfEdges and VerticesOfEdges
##		FacesOfEdges and EdgesOfVertices
##	We will start with an inversion and a transitivity method. These two are
##	sufficient to generate every other combination in at most two steps. Since
##	GAP can't do more than one step we use the method selection graph to cover
##	all other cases.
##
##	Before we implement the relations between the *Of*-relations we implement
##	the implicit references to the constituents (for example we can derive
##	both Vertices and Edges from VerticesOfEdges).
BindGlobal( "__SIMPLICIAL_BoundEntriesOfList",
	function( list )
		return Filtered( [1..Length(list)], i -> IsBound( list[i] ) );
	end
);

##	VerticesOfEdges
InstallMethod( VerticesAttributeOfSimplicialSurface, 
	"for a simplicial surface that has VerticesOfEdges",
	[ IsSimplicialSurface and HasVerticesOfEdges ],
	function( surf );
		return Union( VerticesOfEdges( surf ) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"VerticesAttributeOfSimplicialSurface", "VerticesOfEdges" );
InstallMethod( Edges, "for a simplicial surface that has VerticesOfEdges",
	[ IsSimplicialSurface and HasVerticesOfEdges ],
	function( surf );
		return __SIMPLICIAL_BoundEntriesOfList( VerticesOfEdges(surf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"Edges", "VerticesOfEdges" );

##	VerticesOfFaces
InstallMethod( VerticesAttributeOfSimplicialSurface, 
	"for a simplicial surface that has VerticesOfFaces",
	[ IsSimplicialSurface and HasVerticesOfFaces ],
	function( surf );
		return Union( VerticesOfFaces( surf ) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"VerticesAttributeOfSimplicialSurface", "VerticesOfFaces" );
InstallMethod( Faces, "for a simplicial surface that has VerticesOfFaces",
	[ IsSimplicialSurface and HasVerticesOfFaces ],
	function( surf );
		return __SIMPLICIAL_BoundEntriesOfList( VerticesOfFaces(surf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"Faces", "VerticesOfFaces" );

##	EdgesOfVertices
InstallMethod( Edges, "for a simplicial surface that has EdgesOfVertices",
	[ IsSimplicialSurface and HasEdgesOfVertices ],
	function( surf );
		return Union( EdgesOfVertices( surf ) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"Edges", "EdgesOfVertices" );
InstallMethod( VerticesAttributeOfSimplicialSurface, 
	"for a simplicial surface that has EdgesOfVertices",
	[ IsSimplicialSurface and HasEdgesOfVertices ],
	function( surf );
		return __SIMPLICIAL_BoundEntriesOfList( EdgesOfVertices(surf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"VerticesAttributeOfSimplicialSurface", "EdgesOfVertices" );

##	EdgesOfFaces
InstallMethod( Edges, "for a simplicial surface that has EdgesOfFaces",
	[ IsSimplicialSurface and HasEdgesOfFaces ],
	function( surf );
		return Union( EdgesOfFaces( surf ) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"Edges", "EdgesOfFaces" );
InstallMethod( Faces, "for a simplicial surface that has EdgesOfFaces",
	[ IsSimplicialSurface and HasEdgesOfFaces ],
	function( surf );
		return __SIMPLICIAL_BoundEntriesOfList( EdgesOfFaces(surf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"Faces", "EdgesOfFaces" );

##	FacesOfVertices
InstallMethod( Faces, "for a simplicial surface that has FacesOfVertices",
	[ IsSimplicialSurface and HasFacesOfVertices ],
	function( surf );
		return Union( FacesOfVertices( surf ) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"Faces", "FacesOfVertices" );
InstallMethod( VerticesAttributeOfSimplicialSurface, 
	"for a simplicial surface that has FacesOfVertices",
	[ IsSimplicialSurface and FacesOfVertices ],
	function( surf );
		return __SIMPLICIAL_BoundEntriesOfList( FacesOfVertices(surf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"VerticesAttributeOfSimplicialSurface", "FacesOfVertices" );

##	FacesOfEdges
InstallMethod( Faces, 
	"for a simplicial surface that has FacesOfEdges",
	[ IsSimplicialSurface and HasFacesOfEdges ],
	function( surf );
		return Union( FacesOfEdges( surf ) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"Faces", "FacesOfEdges" );
InstallMethod( Edges, "for a simplicial surface that has FacesOfEdges",
	[ IsSimplicialSurface and HasFacesOfEdges ],
	function( surf );
		return __SIMPLICIAL_BoundEntriesOfList( FacesOfEdges(surf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"Edges", "FacesOfEdges" );


##	
##	Now we implement the inversion of an incidence relation. For example
##	we know edgesOfFaces but want to know facesOfEdges. As this inversion is
##	always the same we implement it in general.
##	Given are the numbers of edges and faces, together with the relation
##	edgesOfFaces. It returns the relation facesOfEdges. (The names are used
##	only for illustration.)
BindGlobal( "__SIMPLICIAL_InvertIncidence", 
	function( faceNr, edgesOfFaces, edgeNr )

	local edgeList, edge, faceSet, face;

	edgeList := [];
	for edge in edgeNr do
		faceSet := [];
		for face in faceNr do
			if edge in edgesOfFaces[face] then
				faceSet := Union( faceSet, [face] );
			fi;
		od;
		edgeList[edge] := faceSet;
	od;

	return edgeList;
end);
##
##	With this method we can write inversion methods for all six cases.
InstallMethod( EdgesOfVertices, 
	[IsSimplicialSurface and HasVerticesOfEdges ], 
	function( simpsurf )
		return __SIMPLICIAL_InvertIncidence( Edges(simpsurf),
				VerticesOfEdges(simpsurf), Vertices(simpsurf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"EdgesOfVertices", "VerticesOfEdges" );

InstallMethod( FacesOfVertices, 
	[IsSimplicialSurface and HasVerticesOfFaces ],
	function( simpsurf )
		return __SIMPLICIAL_InvertIncidence( Faces(simpsurf),
				VerticesOfFaces(simpsurf), Vertices(simpsurf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"FacesOfVertices", "VerticesOfFaces" );

InstallMethod( VerticesOfEdges, 
	[IsSimplicialSurface and HasEdgesOfVertices ],
	function( simpsurf )
		return __SIMPLICIAL_InvertIncidence( Vertices(simpsurf),
				EdgesOfVertices(simpsurf), Edges(simpsurf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"VerticesOfEdges", "EdgesOfVertices" );

InstallMethod( FacesOfEdges, 
	[IsSimplicialSurface and HasEdgesOfFaces ],
	function( simpsurf )
		return __SIMPLICIAL_InvertIncidence( Faces(simpsurf),
				EdgesOfFaces(simpsurf), Edges(simpsurf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"FacesOfEdges", "EdgesOfFaces" );

InstallMethod( VerticesOfFaces, 
	[IsSimplicialSurface and HasFacesOfVertices ],
	function( simpsurf )
		return __SIMPLICIAL_InvertIncidence( Vertices(simpsurf),
				FacesOfVertices(simpsurf), Faces(simpsurf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"VerticesOfFaces", "FacesOfVertices" );

InstallMethod( EdgesOfFaces, 
	[IsSimplicialSurface and HasFacesOfEdges ], 
	function( simpsurf )
		return __SIMPLICIAL_InvertIncidence( Edges(simpsurf),
				FacesOfEdges(simpsurf), Faces(simpsurf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"EdgesOfFaces", "FacesOfEdges" );

##
##	Next we consider the case of transitivity: From EdgesOfFaces and 
##	VerticesOfEdges we can deduce VerticesOfFaces
BindGlobal( "__SIMPLICIAL_TransitiveIncidence", 
	function( faceNr, edgesOfFaces, edgeNr,	verticesOfEdges, vertexNr )

	local face, verticesOfFaces, edgesInFace, verticesInEdges;

	verticesOfFaces := [];
	for face in faceNr do
		edgesInFace := edgesOfFaces[face];
		verticesInEdges := List( edgesInFace, e -> verticesOfEdges[e] );
		verticesOfFaces[face] := Union( verticesInEdges );
	od;

	return verticesOfFaces;
end);
##
InstallMethod( VerticesOfFaces, 
	[IsSimplicialSurface and HasEdgesOfFaces and HasVerticesOfEdges ],
	function( simpsurf )
		return __SIMPLICIAL_TransitiveIncidence( Faces(simpsurf),
			EdgesOfFaces(simpsurf), Edges(simpsurf),
			VerticesOfEdges(simpsurf), Vertices(simpsurf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"VerticesOfFaces", ["EdgesOfFaces", "VerticesOfEdges"] );

InstallMethod( FacesOfVertices, 
	[IsSimplicialSurface and HasEdgesOfVertices and HasFacesOfEdges ],
	function( simpsurf )
		return __SIMPLICIAL_TransitiveIncidence( Vertices(simpsurf),
			EdgesOfVertices(simpsurf), Edges(simpsurf),
			FacesOfEdges(simpsurf), Faces(simpsurf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"FacesOfVertices", ["EdgesOfVertices", "FacesOfEdges"] );


##	Normally we would be finished at this point. But the method selection of
##	GAP is not so intelligent to check for attributes transitively (it only
##	checks if an attribute is set, not if it could be set). It would have been
##	nice if this could be done by RedispatchOnCondition (see 78.5-1) but this
##	option only works for properties. Since Has* is false if the attribute *
##	is not computed, we can't use it (theoretically we could introduce an
##	additional property for "possible existence of this attribute" but that
##	gets even more involved). Therefore we will use the method selection graph.
##	For this to work we have to implement a method for each of the 
##	*Of*-attributes.
InstallMethod( VerticesOfEdges, "for a simplicial surface", 
	[ IsSimplicialSurface ],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
										VerticesOfEdges, surf);
	end
);
InstallMethod( VerticesOfFaces, "for a simplicial surface", 
	[ IsSimplicialSurface ],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
										VerticesOfFaces, surf);
	end
);
InstallMethod( EdgesOfVertices, "for a simplicial surface", 
	[ IsSimplicialSurface ],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
										EdgesOfVertices, surf);
	end
);
InstallMethod( EdgesOfFaces, "for a simplicial surface", 
	[ IsSimplicialSurface ],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
										EdgesOfFaces, surf);
	end
);
InstallMethod( FacesOfVertices, "for a simplicial surface", 
	[ IsSimplicialSurface ],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
										FacesOfVertices, surf);
	end
);
InstallMethod( FacesOfEdges, "for a simplicial surface", 
	[ IsSimplicialSurface ],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
										FacesOfEdges, surf);
	end
);

##
##							End of *Of*-Methods
##
#############################################################################
#############################################################################




#############################################################################
#############################################################################
##
##					Start of the local orientation methods
##
##
##	To work with the different ways of encoding the local orientation (via
##	edges or via vertices, as well as the difference between saving them as 
##	permutations or as lists) we define some global functions that help us
##	perform these translations in general.

##
##	Given a list of permutations (that have to be cycles) and an index set,
##	this function returns a list of lists such that these lists represent the
##	cycle representation of the permutation. For example the permutation (1,2,3)
##	may be represented by the lists [1,2,3], [2,3,1] or [3,1,2]. To define this
##	representation uniquely we stipulate that the first entry in the list
##	representation is the smallest entry of the list. In the above example,
##	the list [1,2,3] would be the so defined representation. Fixed points will
##	be ignored.
##
BindGlobal( "__SIMPLICIAL_TranslateCyclesIntoLists", 
	function( listOfPerms, indexSet )

	local listOfLists, i, points, listRep, j;

	listOfLists := [];
	for i in indexSet do
		points := MovedPoints( listOfPerms[i] );

		# Since points is a set, the first element is the smallest
		listRep := [ points[1] ];

		for j in [1..Length(points)-1] do
			Append( listRep, [ listRep[j]^listOfPerms[i] ] );
		od;
	od;

	return listOfLists;
end);

##
##	Given a list of lists, this function returns a list of
##	permutations such that each permutation is defined by the list (like it
##	was described for the function above).
##
BindGlobal( "__SIMPLICIAL_TranslateListsIntoCycles", function( listOfLists )
	local Shift;

	# local function that shifts each entry of the list to the previous one
	Shift := function( list )
		local newList, i;

		newList := [];
		newList[ Length(list) ] := list[1];
		for i in [2..Length(list)] do
			newList[i-1] := list[i];
		od;
		return newList;
	end;

	return List( listOfLists, list -> MappingPermListList(list, Shift(list)) );
end);



#############################################################################
#!	@Description
#!	Return a list of permutations where at the position of each face-number
#!	there is a cycle of all vertices that are incident to this face. This
#!	cycle represents the local orientation of this face. All other positions
#!	are unbounded.
#!  @Returns a list of permutations
#!  @Arguments a simplicial surface object simpsurf
InstallMethod( LocalOrientation, "for a simplicial surface", 
	[IsSimplicialSurface],
	function( simpsurf )
		return LocalOrientationByVerticesAsPerm(simpsurf);
	end
);
InstallMethod( LocalOrientationByVerticesAsPerm, "for a simplicial surface", 
	[IsSimplicialSurface],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
									LocalOrientationByVerticesAsPerm, surf);
	end
);

InstallMethod( LocalOrientationByVerticesAsPerm, "for a simplicial surface", 
	[IsSimplicialSurface and HasLocalOrientationByVerticesAsList],
	function( simpsurf )
		return __SIMPLICIAL_TranslateListsIntoCycles( 
			LocalOrientationByVerticesAsList( simpsurf ) );
	end
);
AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
	"LocalOrientationByVerticesAsPerm", "LocalOrientationByVerticesAsList" );


#############################################################################
#!	@Description
#!	Return a list of permutations where at the position of each face-number
#!	there is a cycle of all edges that are incident to this face. This
#!	cycle represents the local orientation of this face. All other positions
#!	are unbounded.
#!  @Returns a list of permutations
#!  @Arguments a simplicial surface object simpsurf
InstallMethod( LocalOrientationByEdgesAsPerm, "for a simplicial surface", 
	[IsSimplicialSurface],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
									LocalOrientationByEdgesAsPerm, surf);
	end
);

InstallMethod( LocalOrientationByEdgesAsPerm, "for a simplicial surface", 
	[IsSimplicialSurface and HasLocalOrientationByEdgesAsList],
	function( simpsurf )
		return __SIMPLICIAL_TranslateListsIntoCycles( 
			LocalOrientationByEdgesAsList( simpsurf ) );
	end
);
AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
	"LocalOrientationByEdgesAsPerm", "LocalOrientationByEdgesAsList" );

##
##	To perform the conversion between ByVerticesAsList and ByEdgesAsList we
##	implement another global function (as both conversions are identical from
##	the perspective of incidence geometry). We start with
##		a list of lists (in terms of elements A)
##		an index for the list (in our case that will be the faces)
##		a conversion of A in terms of B
##		a list of sets of all elements of B that are possible (for a given face)
##
BindGlobal( "__SIMPLICIAL_ConversionLocalOrientationVerticesEdges", 
	function( listOfLists, listIndex, conversion, possibleNewElements )

	local newListOfLists, i, oldList, newList, firstEl, secondEl, intersection,
		j, currentEl, nextEl;

	newListOfLists := [];
	# Iterate over the list index
	for i in listIndex do
		# We want to convert the elements of listOfLists (the 'old lists')
		# into the elements of newListOfLists (the 'new lists')
		oldList := listOfLists[i];
		newList := [];

		# Intersect first and last element of the oldList to obtain the first
		# element of the newList
		firstEl := Set( conversion[ oldList[1] ] );
		secondEl := Set( conversion[ oldList[ Length(oldList) ] ] );
		intersection := Intersection( firstEl, secondEl, 
											possibleNewElements[i] );
		if Length( intersection ) <> 1 then
			# This error should not be thrown if the method is used for its 
			# intended purpose
			Error("__SIMPLICIAL_ConversionLocalOrientationVerticesEdges: Intersection is not unique." );
		fi;
		newList[1] := intersection[1];


		# Now we continue for all other elements
		for j in [2..Length(oldList)] do
			currentEl := Set( conversion[ oldList[j-1] ] );
			nextEl := Set( conversion[ oldList[j] ] );
			intersection := Intersection( currentEl, nextEl, 
												possibleNewElements[i] );
			if Length( intersection ) <> 1 then
				# This error should not be thrown if the method is used for its 
				# intended purpose
				Error("__SIMPLICIAL_ConversionLocalOrientationVerticesEdges: Intersection is not unique." );
			fi;
			newList[j] := intersection[1];
		od;

		newListOfLists[i] := newList;
	od;

	return newListOfLists;
end);


#############################################################################
#!	@Description
#!	Return a list of lists where at the position of each face-number
#!	there is a list of all vertices that are incident to this face. This
#!	list represents the local orientation of this face. All other positions
#!	are unbounded.
#!  @Returns a list of lists
#!  @Arguments a simplicial surface object simpsurf
InstallMethod( LocalOrientationByVerticesAsList, "for a simplicial surface", 
	[IsSimplicialSurface],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
									LocalOrientationByVerticesAsList, surf);
	end
);

InstallMethod( LocalOrientationByVerticesAsList, "for a simplicial surface", 
	[IsSimplicialSurface and HasLocalOrientationByVerticesAsPerm],
	function( simpsurf )
		return __SIMPLICIAL_TranslateCyclesIntoLists( 
			LocalOrientationByVerticesAsPerm( simpsurf ), Faces( simpsurf ) );
	end
);
AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
	"LocalOrientationByVerticesAsList", "LocalOrientationByVerticesAsPerm" );

InstallMethod( LocalOrientationByVerticesAsList, "for a simplicial surface", 
	[IsSimplicialSurface and HasLocalOrientationByEdgesAsList],
	function( simpsurf )
		return __SIMPLICIAL_ConversionLocalOrientationVerticesEdges( 
			LocalOrientationByEdgesAsList(simpsurf), 
			Faces(simpsurf), 
			VerticesOfEdges(simpsurf),
			VerticesOfFaces(simpsurf) );
	end
);
AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
	"LocalOrientationByVerticesAsList", "LocalOrientationByEdgesAsList" );


#############################################################################
#!	@Description
#!	Return a list of lists where at the position of each face-number
#!	there is a list of all edges that are incident to this face. This
#!	list represents the local orientation of this face. All other positions
#!	are unbounded.
#!  @Returns a list of lists
#!  @Arguments a simplicial surface object simpsurf
InstallMethod( LocalOrientationByEdgesAsList, "for a simplicial surface", 
	[IsSimplicialSurface],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
									LocalOrientationByEdgesAsList, surf);
	end
);

InstallMethod( LocalOrientationByEdgesAsList, "for a simplicial surface", 
	[IsSimplicialSurface and HasLocalOrientationByEdgesAsPerm],
	function( simpsurf )
		return __SIMPLICIAL_TranslateCyclesIntoLists( 
			LocalOrientationByEdgesAsPerm( simpsurf ), Faces( simpsurf ) );
	end
);
AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
	"LocalOrientationByEdgesAsList", "LocalOrientationByEdgesAsPerm" );

InstallMethod( LocalOrientationByEdgesAsList, "for a simplicial surface", 
	[IsSimplicialSurface and HasLocalOrientationByVerticesAsList],
	function( simpsurf )
		return __SIMPLICIAL_ConversionLocalOrientationVerticesEdges( 
			LocalOrientationByVerticesAsList(simpsurf), 
			Faces(simpsurf), 
			EdgesOfVertices(simpsurf),
			EdgesOfFaces(simpsurf) );
	end
);
AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
	"LocalOrientationByEdgesAsList", "LocalOrientationByVerticesAsList" );


##
##	Furthermore we can use the local orientation to derive information about
##	EdgesOfFaces and VerticesOfFaces
InstallMethod( EdgesOfFaces, 
	"for a simplicial surface that has LocalOrientationByEdgesAsList",
	[ IsSimplicialSurface and HasLocalOrientationByEdgesAsList ],
	function( surf )
		return List( LocalOrientationByEdgesAsList(surf), i -> Set(i) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
					"EdgesOfFaces", "LocalOrientationByEdgesAsList" );

InstallMethod( VerticesOfFaces, 
	"for a simplicial surface that has LocalOrientationByVerticesAsList",
	[ IsSimplicialSurface and HasLocalOrientationByVerticesAsList ],
	function( surf )
		return List( LocalOrientationByVerticesAsList(surf), i -> Set(i) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
					"VerticesOfFaces", "LocalOrientationByVerticesAsList" );

##
##	Finally we can use all of the local orientation variants to derive the 
##	faces directly
InstallMethod( Faces, 
	"for a simplicial surface that has LocalOrientationByVerticesAsPerm",
	[ IsSimplicialSurface and HasLocalOrientationByVerticesAsPerm ],
	function( surf )
		return __SIMPLICIAL_BoundEntriesOfList( 
						LocalOrientationByVerticesAsPerm(surf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
					"Faces", "LocalOrientationByVerticesAsPerm" );

InstallMethod( Faces, 
	"for a simplicial surface that has LocalOrientationByVerticesAsList",
	[ IsSimplicialSurface and HasLocalOrientationByVerticesAsList ],
	function( surf )
		return __SIMPLICIAL_BoundEntriesOfList( 
						LocalOrientationByVerticesAsList(surf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
					"Faces", "LocalOrientationByVerticesAsList" );

InstallMethod( Faces, 
	"for a simplicial surface that has LocalOrientationByEdgesAsList",
	[ IsSimplicialSurface and HasLocalOrientationByEdgesAsList ],
	function( surf )
		return __SIMPLICIAL_BoundEntriesOfList( 
						LocalOrientationByEdgesAsList(surf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
					"Faces", "LocalOrientationByEdgesAsList" );

InstallMethod( Faces, 
	"for a simplicial surface that has LocalOrientationByEdgesAsPerm",
	[ IsSimplicialSurface and HasLocalOrientationByEdgesAsPerm ],
	function( surf )
		return __SIMPLICIAL_BoundEntriesOfList( 
						LocalOrientationByEdgesAsPerm(surf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
					"Faces", "LocalOrientationByEdgesAsPerm" );
	

##
##					End of the local orientation methods
##
##############################################################################
##############################################################################



#############################################################################
##
##
#!  @Description
#!  This function computes the Euler characteristic of a simplicial surface.
#!  The Euler characteristic is |V| - |E| + |F|, where |V| is the number of
#!  vertices, |E| is the number of edges and |F| is the number of faces.
#!  @Returns an integer, which is the Euler characteristic.
#!  @Arguments <simpsurf>, a simplicial surface object as created 
#!  by WildSimplicialSurface
#!
InstallMethod( EulerCharacteristic, "for a simplicial surface", 
	[IsSimplicialSurface ],
	function (simpsurf)
		local chi;

		chi := NrOfVertices(simpsurf)  # V
				- NrOfEdges(simpsurf)     # -E
				+ NrOfFaces(simpsurf);    # +F

		return chi;
	end
);

#############################################################################
##
#!  @Description
#!	Return a list of integers (with holes). For each vertex-
#!	number it contains the number of faces which are incident to that vertex
#!	(the degree of the vertex). All other positions are unbounded.
#!  @Returns a list of integers
#!  @Arguments a simplicial surface object simpsurf
#!
InstallMethod( UnsortedDegrees, "for a simplicial surface",	
	[IsSimplicialSurface],
	function(simpsurf)
		local facesOfVertices;

		facesOfVertices := FacesOfVertices( simpsurf );
		return List( facesOfVertices, i->Length(i) );
	end
);

#############################################################################
##
#!  @Description
#!	Return a dense sorted list of integers that contains the 
#!	degrees of the vertices (with repetitions)
#!  @Returns a dense sorted list of integers
#!  @Arguments a simplicial surface object simpsurf
#!
InstallMethod( SortedDegrees, "for a simplicial surface", [IsSimplicialSurface],
	function(simpsurf)
		local compact;

		compact := Compacted( UnsortedDegrees( simpsurf ) );
		Sort( compact );
		return compact;
	end
 );

#############################################################################
##
#!  @Description
#!  Return the vertex symbol of a simplicial surface.
#!	The vertex symbol is a list, where the i-th entry counts the number of 
#!	vertices that are incident to exactly i edges. If there are no such
#!	vertices the entry is unbounded.
#!  @Arguments a simplicial surface object simpsurf
#!  @Returns a list of integers
#!
InstallMethod( VertexSymbol, "for a simplicial surface", [IsSimplicialSurface],
	function(simpsurf)
		local edgesOfVertices, vertex, symbol, degree;

		edgesOfVertices := EdgesOfVertices( simpsurf );
		symbol := [];
		for vertex in Vertices( simpsurf ) do
			degree := Length( edgesOfVertices[vertex] );
			if IsBound( symbol[degree] ) then
				symbol[degree] := symbol[degree] + 1;
			else
				symbol[degree] := 1;
			fi;
		od;

		return symbol;
	end
);


##############################################################################
##
##	Install the methods concerning the face-edge-paths
##
InstallMethod( FaceEdgePathsOfVertices, "for a simplicial surface", 
	[IsSimplicialSurface and IsEdgesLikeSurface ],
	function( surf )
		return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
									FaceEdgePathsOfVertices, surf);
	end
);
	RedispatchOnCondition( FaceEdgePathsOfVertices, true, [IsSimplicialSurface],
		[IsEdgesLikeSurface], 0 );

InstallMethod( FaceEdgePathsOfVertices, 
	"for a simplicial surface that is an actual surface", 
	[ IsSimplicialSurface and IsEdgesLikeSurface and 
		HasVerticesAttributeOfSimplicialSurface and HasEdgesOfVertices and
		HasFacesOfVertices and HasEdgesOfFaces and HasFacesOfEdges ],
	function( surf )
		local faceEdgePathList, vertex, incidentEdges, incidentFaces, 
			faceEdgePaths, faceStart, possEdges, path, lastEdge, nextFaceList,
			frontFinished, backFinished, newLastEdge, Representation;

		faceEdgePathList := [];		# This will be the final result

		for vertex in Vertices( surf ) do
			incidentEdges := EdgesOfVertices(surf)[vertex];
			incidentFaces := ShallowCopy( FacesOfVertices(surf)[vertex] );
			faceEdgePaths := [];	# Save the paths for each vertex

			while not IsEmpty( incidentFaces ) do
				faceStart := incidentFaces[1];	# This is the smallest face
				incidentFaces := incidentFaces{[2..Length(incidentFaces)]};
				possEdges := Intersection( incidentEdges, 
										EdgesOfFaces(surf)[faceStart] );
				if Length(possEdges) <> 2 then
					Error("FaceEdgePathsOfVertices: Each face should have to edges incident to each of its incident vertices." );
				fi;

				# We define the path in such a way that the second edge is 
				# smaller than the first one
				path := [ possEdges[2], faceStart, possEdges[1] ];
				
				# Since we can possibly extend this path in two directions
				# we use two bools to check this possibility
				frontFinished := false;
				backFinished := false;

				while not frontFinished or not backFinished do
					# Try to extend the path beyond the last edge
					lastEdge := path[ Length(path) ];
					nextFaceList := Difference( FacesOfEdges(surf)[lastEdge], 
											[ path[ Length(path) - 1 ] ] );

					if IsEmpty( nextFaceList ) then
						# We have an open path. Now we have to extend the
						# front of the path until we find the next border
						if backFinished then
							frontFinished := true;
						else
							backFinished := true;
							path := Reversed( path );
						fi;
					elif Length( nextFaceList ) = 1 then
						# Append the new face
						Append( path, nextFaceList );
						incidentFaces := Difference( incidentFaces, 
															nextFaceList );
						newLastEdge := Difference( 
							Intersection( incidentEdges, 
										EdgesOfFaces(surf)[nextFaceList[1]] ), 
							[ lastEdge ] );

						if Length(newLastEdge) <> 1 then
							Error("FaceEdgePathsOfVertices: Can't walk the face-edge-path.");
						fi;

						# Check whether the path closes itself
						if path[1] = newLastEdge[1] then
							frontFinished := true;
							backFinished := true;
						else
							Append( path, newLastEdge );
						fi;
					else
						Error("FaceEdgePathsOfVertices: More than two faces incident to an edge." );
					fi;
				od;
				# path is finished
				# Because of our construction most of the paths are already in
				# the correct form.
				Representation := function( path )
					if IsOddInt( Length( path ) ) and 
								path[2] > path[ Length(path) - 1 ] then
						return Reversed(path);
					else
						return path;
					fi;
				end;
				Append( faceEdgePaths, [Representation(path)] );
			od;

			# Computation of paths for a vertex is finished
			faceEdgePathList[vertex] := Set( faceEdgePaths );
		od;

		return faceEdgePathList;
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
		"FaceEdgePathsOfVertices", 
		["VerticesAttributeOfSimplicialSurface", "EdgesOfVertices", 
			"FacesOfVertices", "EdgesOfFaces", "FacesOfEdges"] );

# We can use the face-edge-paths to derive other information
InstallMethod( VerticesAttributeOfSimplicialSurface, 
	"for a simplicial surface that has face-edge-paths",
	[ IsSimplicialSurface and HasFaceEdgePathsOfVertices ],
	function( surf )
		return __SIMPLICIAL_BoundEntriesOfList( FaceEdgePathsOfVertices(surf) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH,
		"VerticesAttributeOfSimplicialSurface", "FaceEdgePathsOfVertices" );

BindGlobal("__SIMPLICIAL_EvenEntriesOfList",
	function( list )
		local entries, i;

		entries := [];
		for i in [1..Length(list)] do
			if IsEvenInt(i) then
				entries[i] := list[i];
			fi;
		od;

		return Set(entries);
	end
);
InstallMethod( FacesOfVertices, 
	"for a simplicial surface that has face-edge-paths",
	[ IsSimplicialSurface and HasFaceEdgePathsOfVertices ],
	function( surf )
		return List( FaceEdgePathsOfVertices(surf), paths -> 
						Union( List( paths, path -> 
								__SIMPLICIAL_EvenEntriesOfList(path) ) ) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH,
		"FacesOfVertices", "FaceEdgePathsOfVertices" );

InstallMethod( EdgesOfVertices, 
	"for a simplicial surface that has face-edge-paths",
	[ IsSimplicialSurface and HasFaceEdgePathsOfVertices ],
	function( surf )
		local OddEntries;

		OddEntries := function( list )
			local entries, i;

			entries := [];
			for i in [1..Length(list)] do
				if IsOddInt(i) then
					entries[i] := list[i];
				fi;
			od;

			return Set(entries);
		end;

		return List( FaceEdgePathsOfVertices(surf), paths -> 
						Union( List( paths, path -> OddEntries(path) ) ) );
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH,
		"EdgesOfVertices", "FaceEdgePathsOfVertices" );

BindGlobal( "__SIMPLICIAL_FacesAroundEdgesInFaceEdgePath",
	function( path, pos )	# pos has to be an odd integer
		if pos = 1 and IsEvenInt( Length( path ) ) then
			return Set( [ path[2], path[ Length(path) ] ] );
		elif pos = 1 and IsOddInt( Length( path ) ) then
			return [ path[2] ];
		elif pos = Length( path ) then
			return [ path[ pos - 1 ] ];
		else
			return Set( [ path[ pos - 1 ], path[ pos + 1 ] ] );
		fi;
	end
);
InstallMethod( FacesOfEdges, 
	"for a simplicial surface that has face-edge-paths",
	[ IsSimplicialSurface and HasFaceEdgePathsOfVertices and 
		HasVerticesAttributeOfSimplicialSurface ],
	function( surf )
		local facesOfEdges, v, path, i;

		facesOfEdges := [];
		for v in Vertices(surf) do
			for path in FaceEdgePathsOfVertexNC( surf, v ) do
				# We will use that IsEdgesLikeSurface holds true

				for i in [1..Length(path)] do
					if IsEvenInt(i) then
						continue;
					fi;

					if not IsBound( facesOfEdges[ path[i] ] ) then
						facesOfEdges[ path[i] ] := 
						__SIMPLICIAL_FacesAroundEdgesInFaceEdgePath( path, i );
					fi;
				od;
			od;
		od;

		return facesOfEdges; 
	end
);
	AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, "FacesOfEdges", 
		["FaceEdgePathsOfVertices", "VerticesAttributeOfSimplicialSurface"] );



InstallMethod( FaceEdgePathsOfVertexNC, 
	"for a simplicial surface that is an actual surface and a positive integer", 
	[ IsSimplicialSurface and IsEdgesLikeSurface, IsPosInt ],
	function( surf, vertex )
		return FaceEdgePathsOfVertices(surf)[vertex];
	end
);
	RedispatchOnCondition( FaceEdgePathsOfVertexNC, true, 
		[IsSimplicialSurface, IsPosInt], [IsEdgesLikeSurface, ], 0 );

InstallMethod( FaceEdgePathsOfVertex, 
	"for a simplicial surface that is an actual surface and a positive integer", 
	[ IsSimplicialSurface and IsEdgesLikeSurface, IsPosInt ],
	function( surf, vertex )
		if not vertex in Vertices(surf) then
			Error("FaceEdgePathsOfVertex: Given vertex has to be a vertex of the given simplicial surface.");
		fi;
		return FaceEdgePathsOfVertexNC(surf,vertex);
	end
);
	RedispatchOnCondition( FaceEdgePathsOfVertex, true, 
		[IsSimplicialSurface, IsPosInt], [IsEdgesLikeSurface, ], 0 );

###############################################################################
##
#!  @Description
#!  This function returns the face-anomaly-classes of a simplicial surface.
#!	Two faces are in the same face-anomaly-class if they contain the same
#!	vertices.
#!  @Returns The face-anomaly-classes (as a list of sets)
#!  @Arguments <simpsurf> a simplicial surface
#!
InstallMethod( FaceAnomalyClasses, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local verticesOfFaces, classes, i, found, cl, j;

		verticesOfFaces := VerticesOfFaces(simpsurf);
		classes := [];

		for i in Faces(simpsurf) do
			found := false;
			for j in [1..Length(classes)] do
				cl := classes[j];
				if Set( verticesOfFaces[i] ) 
							= Set( verticesOfFaces[ cl[1] ] ) then
					classes[j] := Union( cl, [i] );
					found := true;
					break;
				fi;
			od;
			if not found then
				Append( classes, [ [i] ] );
			fi;
		od;

		return classes;
	end
 ); 

###############################################################################
##
##	Install the methods to determine whether a surface is an actual surface.
InstallMethod( IsEdgesLikeSurface, "for a simplicial surface",
	[IsSimplicialSurface],
	function( simpsurf )
		local face, edgeByFaces, check;

		check := true;
		edgeByFaces := FacesOfEdges( simpsurf );
		check := Filtered( edgeByFaces, i -> Length(i) > 2 );
	
		return IsEmpty(check);
	end
);

InstallMethod( IsVerticesLikeSurface, "for a simplicial surface",
	[IsSimplicialSurface],
	function( simpsurf )
		local vertexPaths, check;

		if not IsEdgesLikeSurface( simpsurf ) then
			return false;
		fi;

		vertexPaths := FaceEdgePathsOfVertices( simpsurf );
		check := Filtered( vertexPaths, i -> Length(i) <> 1 );
	
		return IsEmpty(check);
	end
);



#############################################################################
##
#!	@Description
#!	The property IsTriangleSurface is true if all faces of the SimplicialSurface
#!	object are triangles (i.e. they consist of three edges).
#!	@Arguments a simplicial surface
#!	@Returns true if all faces are triangles and false else.
InstallMethod( IsTriangleSurface, "for a simplicial surface",
	[IsSimplicialSurface],
	function( simpsurf )
		local face, edgesOfFaces, check;

		check := true;
		edgesOfFaces := EdgesOfFaces( simpsurf );
		check := Filtered( edgesOfFaces, i -> Length(i) <> 3 );
	
		return IsEmpty(check);
	end
);

#############################################################################
##
#!	@Description
#!	Given a simplicial surface whose edges look like edges on a surface, the 
#!	property
#!	IsClosedSurface is true if the surface is closed or equivalently that
#!	every edge is incident to exactly two faces.
#!	@Arguments a simplicial surface
#!	@Returns true if it is closed, false otherwise
InstallMethod( IsClosedSurface, "for a simplicial surface",
	[IsSimplicialSurface and IsEdgesLikeSurface],
	function( simpsurf )
		local facesOfEdges, check;

		check := true;
		facesOfEdges := FacesOfEdges( simpsurf );
		check := Filtered( facesOfEdges, i -> Length(i) <> 2 );
	
		return IsEmpty(check);
	end
);
	RedispatchOnCondition( IsClosedSurface, true, [IsSimplicialSurface],
		[IsEdgesLikeSurface], 0 );


#############################################################################
##
#!	@Description
#!	This function checks if a simplicial surface is connected.
#!	@Returns true if connected, false otherwise
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( IsConnected, "for a simplicial surface", [IsSimplicialSurface],
	function(simpsurf)
		local faces, faceList, points, change, faceNr;

		# In this function we check the connectivity by working with the
		# vertices. We start with the vertices of the first face and add all
		# faces that share a vertex with one of these. By iterating this
		# we construct all faces in the connected component of the first face.
		# For the implementation we start with the list of all faces and
		# remove those that lie in the connected component.

		faceList := VerticesOfFaces(simpsurf);
		# we start with all faces except the first one
		faces := Faces(simpsurf){ [2..NrOfFaces(simpsurf)] };
		# the algorithm starts with the vertices of the first face
		points := Set( faceList[ Faces(simpsurf)[1] ] );

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

		return IsEmpty( faces );
	end
);
InstallMethod( IsConnected, "for a simplicial surface",
	[IsSimplicialSurface and 
			HasConnectedComponentsAttributeOfSimplicialSurface],
	function(simpsurf)
		local components;

		components := ConnectedComponentsAttributeOfSimplicialSurface(simpsurf);
		return Length(components) = 1;
	end
);


###############################################################################
##
##      Start of the orientation-block
##

###############################################################################
##
##  Compute the orientation of a surface (if it has one).
##
InstallMethod( GlobalOrientationByVertices, "for a simplicial surface",
	[IsSimplicialSurface and IsEdgesLikeSurface],
	function(simpsurf)
		# This method tries to find an orientation for the surface. By the 
		# local orientation we can distinguish "up" and "down" for each
		# individual face. If we now define a map from the faces to {+1,-1}
		# then this defines a set of orientations for all faces (+1 means "up",
		# -1 means "down"). Two adjacent faces have a compatible orientation
		# if they induce opposite orientations on the edge between them (you
		# can see this quite easily if you draw a picture). In this method we
		# use this fact to construct an orientation for the complete surface.
		local facesOfEdges, verticesOfFaces, orientList, i, hole, edge,
			 facesToCheck, checkedFaces, CompatibleOrientation, orient1,
			 orient2, orientable, face, neighbours, next, 
                         FindGlobalOrientation;

		facesOfEdges := FacesOfEdges(simpsurf);
		verticesOfFaces := VerticesOfFaces(simpsurf);

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
		while Number(orientList) < NrOfFaces(simpsurf) and orientable do
			# We proceed individually in each connected component. This loop
			# is called once per connected component. We start by finding a
			# face that was not already included, define an orientation for it
			# at random and then derive how all other orientations have to look
			# like (and maybe find a contradiction).
	
			# Find the first face that has no defined orientation
			hole := 0;
			for face in Faces(simpsurf) do
				if not IsBound( orientList[face] ) then
					hole := face;
					break;
				fi;
			od;
	
			# Define the standard orientation of this face as "up"
			orientList[hole] := 1;
			facesToCheck := [hole];		# Save the faces that have to be checked
			checkedFaces := [];			# Save the faces that are "clear"

			# The next loop is responsible for iterating through the connected
			# component of the face 'hole'. This has to be done step by step
			# since we can only transform the orientation of one face into the
			# orientation of an adjacent face.
			while facesToCheck <> [] and orientable do
				face := facesToCheck[1];

				# For each face we check the transitions over all edges
				for edge in EdgesOfFaces(simpsurf)[face] do
					# This should be unique (inner edge) or empty (border edge)
					neighbours := Difference( facesOfEdges[edge], [face] );
					if Size( neighbours ) > 1 then
						Error( "IsOrientable[generic]: Not a proper surface.");
					elif Size( neighbours ) = 0 then
						continue;	# A border edge is no problem at all
					fi;
					next := neighbours[1];

				
					# Now we have to check whether 'face' and 'next' induce
					# different orientations on the edge between them. To do
					# so we check whether the orientations of the two faces
					# are compatible with a random orientation of the edge.
					orient1 := 0;
					orient2 := 0;
					# Check how these two faces act on the edge
					if CompatibleOrientation( VerticesOfEdges(simpsurf)[edge],
									LocalOrientation(simpsurf)[face] ) then
						orient1 := 1;
					else
						orient1 := -1;
					fi;
	
					if CompatibleOrientation( VerticesOfEdges(simpsurf)[edge], 
									LocalOrientation(simpsurf)[next] ) then
						orient2 := 1;
					else
						orient2 := -1;
					fi;
	
					# The next two cases can be collapsed (the elements in 
					# orientList take values in {+1,-1}).
					#TODO do so without destroying readability
					if orient1*orient2 = -1 then # the sides are neighbours
						if IsBound( orientList[next] ) and 
									orientList[next] <> orientList[face] then
							orientable := false;
							break;
						else
							orientList[next] := orientList[face];
						fi;
					elif orient1*orient2 = 1 then # the sides are not neighbours
						if IsBound( orientList[next] ) and 
									orientList[next] = orientList[face] then
							orientable := false;
							break;
						else
							orientList[next] := -1*orientList[face];
						fi;
					else
						Error( "IsOrientable[generic]: Wrong definition of orientation.");
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
                    FindGlobalOrientation := function( face )
                        if not face in Faces(simpsurf) then
                            return;
                        fi;

                        # Positive orientation means no switch
                        if orientList[face] = 1 then
                            return LocalOrientationByVerticesAsList( simpsurf )[face];
                        elif orientList[face] = -1 then
                            return Reversed( LocalOrientationByVerticesAsList( simpsurf )[face] );
                        else
                            Error("GlobalOrientationByVertices: FindGlobalOrientation: This should not have happened.");
                        fi;
                    end;
                    return List( [1..Maximum(Faces(simpsurf))], 
                            f -> FindGlobalOrientation(f) );
                fi;
		
		return fail;
	end
);
	RedispatchOnCondition( GlobalOrientationByVertices, true, [IsSimplicialSurface],
		[IsEdgesLikeSurface], 0 );

InstallMethod( GlobalOrientationByVertices, "for a simplicial surface", 
        [IsSimplicialSurface and HasIsOrientable],
        function( surf )
            if not IsOrientable(surf) then
                return fail;
            fi;
            TryNextMethod();
        end
);

##
##  Now we write the method to only check if an orientation exists
##
InstallMethod( IsOrientable, "for a simplicial surface",
        [IsSimplicialSurface and HasGlobalOrientationByVertices],
        function(surf)
            return GlobalOrientationByVertices(surf) <> fail;
        end
);

## If we can't compute IsOrientable any other way, we try computing a global
## orientation first
InstallMethod( IsOrientable, "for a simplicial surface",
        [IsSimplicialSurface and IsEdgesLikeSurface ],
        function(surf)
            GlobalOrientationByVertices(surf);
            TryNextMethod();
        end
);
RedispatchOnCondition( IsOrientable, true, 
    [IsSimplicialSurface], [IsEdgesLikeSurface], 0 );

##
##      End of the orientation block
##
###############################################################################


#############################################################################
##
#!	@Description
#!	This function returns the simplicial subsurface that is defined by the
#!	given set of faces.
#!	The NC-version does not check if the given faces actually are faces of
#!	the simplicial surface.
#!	@Arguments a simplicial surface object simpsurf, a set of positive integers
#!	@Returns a simplicial surface object
InstallMethod( SubsurfaceByFaces, "for a simplicial surface",
	[IsSimplicialSurface, IsSet],
	function(simpsurf, subfaces)
		local subVertices, subEdges, newVerticesOfEdges, newEdgesOfFaces, e, f;

		if not IsSubset( Faces(simpsurf), subfaces ) then
			Error("SubsurfaceByFaces: there are not only faces given.");
		fi;

		return SubsurfaceByFacesNC( simpsurf, subfaces );
	end
);
	RedispatchOnCondition( SubsurfaceByFaces, true, 
		[IsSimplicialSurface, IsList], [,IsSet], 0);
InstallMethod( SubsurfaceByFacesNC, "for a simplicial surface",
	[IsSimplicialSurface, IsSet],
	function(simpsurf, subfaces)
		local subVertices, subEdges, newVerticesOfEdges, newEdgesOfFaces, e, f;


		subEdges := Union( List( subfaces, f -> EdgesOfFaces(simpsurf)[f] ));
		subVertices := Union( List( subEdges, e -> 
											VerticesOfEdges(simpsurf)[e] ) );

		newVerticesOfEdges := [];
		for e in subEdges do
			newVerticesOfEdges[e] := VerticesOfEdges(simpsurf)[e];
		od;

		newEdgesOfFaces := [];
		for f in subfaces do
			newEdgesOfFaces[f] := EdgesOfFaces(simpsurf)[f];
		od;

		return SimplicialSurfaceByDownwardIncidenceNC( subVertices, subEdges,
			subfaces, newVerticesOfEdges, newEdgesOfFaces );
	end
);
	RedispatchOnCondition( SubsurfaceByFacesNC, true, 
		[IsSimplicialSurface, IsList], [,IsSet], 0);

#############################################################################
##
#!	@Description
#!	This function returns the connected component of the given face.
#!	The NC-version doesn't check if the given face actually is one.
#!	@Arguments a simplicial surface object simpsurf, a positive integer
#!	@Returns a simplicial surface object
InstallMethod( ConnectedComponentOfFaceNC, "for a simplicial surface",
	[IsSimplicialSurface, IsPosInt],
	function(simpsurf, f)
		local faceList, faces, points, comp, change, faceNr, subsurf;

		faceList := VerticesOfFaces(simpsurf);
		# Take care to not modify the real list of faces
		faces := Difference( Faces(simpsurf), [f] );
		points := faceList[f];
		comp := [ f ];

		change := true;
		while change do
			change := false;

			for faceNr in faces do
				if Intersection( points, faceList[faceNr] ) <> [] then
					change := true;
					points := Union( points, faceList[faceNr] );
					faces := Difference( faces, [faceNr] );
					comp := Union( comp, [faceNr] );
				fi;
			od;
		od;

		subsurf := SubsurfaceByFacesNC( simpsurf, comp);
		# this component is connected by construction, so we set the property
		SetIsConnected( subsurf, true );
		return subsurf;
	end
);
InstallMethod( ConnectedComponentOfFaceNC, "for a simplicial surface",
	[IsSimplicialSurface and IsConnected, IsPosInt],
	function(simpsurf, f)
		return simpsurf; # A connected surface has only one connected component
	end
);
InstallMethod( ConnectedComponentOfFace, "for a simplicial surface",
	[IsSimplicialSurface, IsPosInt],
	function(simpsurf, f)
		local faceList, faces, points, comp, change, faceNr, subsurf;

		if not f in Faces(simpsurf) then
			Error("ConnectedComponentOfFace: Given face doesn't lie in surface.");
		fi;

		return ConnectedComponentOfFaceNC( simpsurf, f);
	end
);

#############################################################################
##
#!	@Description
#!	This function returns the connected component of the given face.
#!	@Arguments a simplicial surface object simpsurf, a positive integer
#!	@Returns a simplicial surface object
InstallMethod( ConnectedComponentOfFaceNC, "for a simplicial surface",
	[IsSimplicialSurface and HasConnectedComponentsAttributeOfSimplicialSurface,
		 IsPosInt],
	function(simpsurf, f)
		local conCom, comp;

		conCom := ConnectedComponentsAttributeOfSimplicialSurface(simpsurf);
		for comp in conCom do
			if f in Faces(comp) then
				return comp;
			fi;
		od;
		Error("ConnectedComponentOfFace: Internal error in ConnectedComponents.");
	end
);
InstallMethod( ConnectedComponentOfFace, "for a simplicial surface",
	[IsSimplicialSurface and HasConnectedComponentsAttributeOfSimplicialSurface,
		 IsPosInt],
	function(simpsurf, f)
		local conCom, comp;

		if not f in Faces(simpsurf) then
			Error("ConnectedComponentOfFace: Given face doesn't lie in surface.");
		fi;

		return ConnectedComponentOfFaceNC( simpsurf, f);
	end
);

#############################################################################
##
#!	@Description
#!	Return a list of all connected components of the simplicial surface.
#!	@Arguments a simplicial surface
#!	@Returns a list of simplicial surfaced
InstallMethod( ConnectedComponentsAttributeOfSimplicialSurface,
	"for a simplicial surface", [IsSimplicialSurface],
	function(simpsurf)
		local faces, comp, f, component;

		faces := Faces(simpsurf);
		comp := [ ];
		while not IsEmpty(faces) do
			f := faces[1];
			component := ConnectedComponentOfFaceNC( simpsurf, f );
			Append( comp, [component] );
			faces := Difference( faces, Faces(component) );
		od;

		return comp;
	end
);
InstallMethod( ConnectedComponentsAttributeOfSimplicialSurface,
	"for a simplicial surface", [IsSimplicialSurface and IsConnected],
	function(simpsurf)
		return [simpsurf];
	end
);
#InstallMethod( ConnectedComponents, "for a simplicial surface",
#	[IsSimplicialSurface],
#	function(simpsurf)
#		return ConnectedComponentsAttributeOfSimplicialSurface( simpsurf );
#	end
#);



#############################################################################
##
##		SnippOffEars - methods
##

BindGlobal( "__SIMPLICIAL_SnippOffEarsOfSimplicialSurface",
	function(simpsurf)
		local vertexDegree, ears, newSurface, ear, facesToRemove, 
				remainingFaces;

		# Find ears
		vertexDegree := UnsortedDegrees( simpsurf );
		ears := Filtered( Vertices(simpsurf), i -> vertexDegree[i] <= 1);

		if IsEmpty( ears ) then
			return simpsurf;
		fi;

		facesToRemove := Union( List( ears, i->FacesOfVertices(simpsurf)[i]) );
		remainingFaces := Difference( Faces(simpsurf), facesToRemove );
		newSurface := SubsurfaceByFacesNC( simpsurf, remainingFaces );
	
		return newSurface;
	end
);

InstallMethod( SnippOffEars, "for a simplicial surface", [IsSimplicialSurface],
	__SIMPLICIAL_SnippOffEarsOfSimplicialSurface );


InstallMethod( SnippOffEarsRecursive, "for a simplicial surface", 
	[IsSimplicialSurface], function( simpsurf )
		local newSurface;

		newSurface := SnippOffEars( simpsurf );
		# Use a simplified equality test
		if NrOfFaces(newSurface) = NrOfFaces(simpsurf) then
			return simpsurf;
		fi;

		return SnippOffEarsRecursive(newSurface);
	end
);

##
###############################################################################

#############################################################################
##
#!	@Description
#!	Return a list of tuples where at each face-number there is a list with two
#!	entries. The first one is the name of the upper face-side, the second one
#!	the name of the lower face-side (with respect to the local orientation).
#!	All other positions are unbounded.
#!  @Returns a list of lists of integers
#!  @Arguments a simplicial surface object simpsurf
InstallMethod( NamesOfFaces,
	"for a simplicial surface with default face naming convention",
	[IsSimplicialSurface and IsFaceNamesDefault],
	function(simpsurf)
		local faceNames, face;

		faceNames := [];
		for face in Faces( simpsurf ) do
			faceNames[face] := [face, -1*face];
		od;
	
		return faceNames;
	end
);

#############################################################################
##
#!	@Description
#!	Return if the naming scheme for the faces is the default one, meaning
#!	that the upper side of a face f is called f (a positive integer) and the
#!	lower side -f (a negative integer).
#!	@Returns true if the simplicial surface follows the default naming scheme,
#!	false otherwise
#!	@Arguments a simplicial surface object simpsurf
InstallMethod( IsFaceNamesDefault, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local faceNames, face;

		faceNames := NamesOfFaces(simpsurf);
		for face in Faces( simpsurf ) do
			if not faceNames[face] = [face, -1*face] then
				return false;
			fi;
		od;
	
		return true;
	end
);

#############################################################################
##
#!	@Description
#!	This function returns both names of the given face. The first entry is
#!	the name of the upper side, the second one of the lower side.
#!	The NC-version doesn't check if the given number actually is a face.
#!	@Arguments a simplicial surface object simpsurf, a face number
#!	@Returns a list with two elements
InstallMethod( NamesOfFaceNC, "for a simplicial surface",
	[IsSimplicialSurface, IsPosInt],
	function(simpsurf, face)
		return NamesOfFaces(simpsurf)[face];
	end
);
InstallMethod( NamesOfFace, "for a simplicial surface",
	[IsSimplicialSurface, IsPosInt],
	function(simpsurf, face)
		if not face in Faces( simpsurf ) then
			Error("NamesOfFace[generic]: Face doesn't lie in surface.");
		fi;
		return NamesOfFaces(simpsurf)[face];
	end
);

#############################################################################
##
#!	@Description
#!	This function returns both names of the given face. The first entry is
#!	the name of the upper side, the second one of the lower side.
#!	The NC-version doesn't check if the given number actually is a face.
#!	@Arguments a simplicial surface object simpsurf, a face number
#!	@Returns a list with two elements
InstallMethod( NamesOfFaceNC,
	"for a simplicial surface with default face naming convention",
	[IsSimplicialSurface and IsFaceNamesDefault, IsPosInt],
	function(simpsurf, face)
		return [face, -1*face];
	end
);
InstallMethod( NamesOfFace,
	"for a simplicial surface with default face naming convention",
	[IsSimplicialSurface and IsFaceNamesDefault, IsPosInt],
	function(simpsurf, face)
		if not face in Faces( simpsurf ) then
			Error("NamesOfFace[default]: Face doesn't lie in surface.");
		fi;
		return [face, -1*face];
	end
);

#############################################################################
##
#!	@Description
#!	Return the face-number of the simplicial surface that has the given name
#!	as the name of one of its sides.
#!	@Arguments a simplicial surface object simpsurf, an integer
#!	@Returns a positive integer
InstallMethod( FaceByName, "for a simplicial surface",
	[IsSimplicialSurface, IsInt],
	function(simpsurf, face)
		local faceNames, faceNr;

		faceNames := NamesOfFaces(simpsurf);
		for faceNr in Faces(simpsurf) do
			if face in faceNames[faceNr] then
				return faceNr;
			fi;
		od;
		Error("FaceByName[generic]: Given face side name doesn't exist.");
	end
);

#############################################################################
##
#!	@Description
#!	Return the face-number of the simplicial surface that has the given name
#!	as the name of one of its sides.
#!	@Arguments a simplicial surface object simpsurf, an integer
#!	@Returns a positive integer
InstallMethod( FaceByName,
	"for a simplicial surface with default face naming convention",
	[IsSimplicialSurface and IsFaceNamesDefault, IsInt],
	function(simpsurf, face)
		local result;

		result := AbsInt(face);
		if not result in Faces(simpsurf) then
			Error("FaceByName[default]: Given face side name doesn't exist.");
		fi;
		return result;
	end
);

#############################################################################
##
#!  @Description
#!  Return the coloured incidence graph of a simplicial surface.
#!	The vertex set of this graph consists of all vertices, edges and faces
#!	of the simplicial surface. All vertices, all edges and all faces
#!	are in individual colour classes.
#!	The edges are given by vertex-edge and edge-face pairs.
#!  @Returns the coloured incidence graph
#!  @Arguments a simplicial surface object simpsurf
#!
InstallMethod( IncidenceGraph, "for a simplicial surface", 
	[IsSimplicialSurface],
	function(simpsurf)
		local graph, vertices, edges, faces, names, colours, incidence, 
			trivialAction;

		vertices := List( Vertices(simpsurf), i -> [0,i] );
		edges := List( Edges(simpsurf), i -> [1,i] );
		faces := List( Faces(simpsurf), i -> [2,i] );

		names := Union( vertices, edges, faces);
		colours := [vertices,edges, faces];
		incidence := function(x,y)
			if x[1] = 0 and y[1] = 1 then
				return x[2] in VerticesOfEdges(simpsurf)[y[2]];
			elif x[1] = 1 and y[1] = 0 then
				return y[2] in VerticesOfEdges(simpsurf)[x[2]];

			elif x[1] = 1 and y[1] = 2 then
				return x[2] in EdgesOfFaces(simpsurf)[y[2]];
			elif x[1] = 2 and y[1] = 1 then
				return y[2] in EdgesOfFaces(simpsurf)[x[2]];

			else
				return false;
			fi;
		end;

		trivialAction := function( pnt, g )
			return pnt;
		end;

		graph := Graph( Group( () ), names, trivialAction, incidence );
		graph!.colourClasses := colours;

		return graph;
	end
);


#############################################################################
##
#!  @Description
#!  Check if two simplicial surfaces are isomorphic. This method only checks
#!	if they are isomorphic with respect to the incidence relation. It does
#!	not check if additional structure like a wild coloring is isomorphic (or
#!	even present).
#!  @Returns true or false
#!  @Arguments <s1>, <s2>, two simplicial surface objects
#!
##
InstallMethod( IsIsomorphic, "for two simplicial surfaces",
	[IsSimplicialSurface, IsSimplicialSurface],
	function( s1,s2)
		local graph1, graph2;

		# We use ShallowCopy to make the graphs mutable
		# This is required to use IsIsomorphicGraph from GRAPE
		graph1 := ShallowCopy( IncidenceGraph(s1) );
		graph2 := ShallowCopy( IncidenceGraph(s2) );
		return IsIsomorphicGraph(graph1,graph2);
	end
);


#
###  This program is free software: you can redistribute it and/or modify
###  it under the terms of the GNU General Public License as published by
###  the Free Software Foundation, either version 3 of the License, or
###  (at your option) any later version.
###
###  This program is distributed in the hope that it will be useful,
###  but WITHOUT ANY WARRANTY; without even the implied warranty of
###  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
###  GNU General Public License for more details.
###
###  You should have received a copy of the GNU General Public License
###  along with this program.  If not, see <http://www.gnu.org/licenses/>.
###

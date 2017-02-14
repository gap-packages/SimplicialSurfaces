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
			"EdgesAttributeOfSimplicialSurface", 
			"FacesAttributeOfSimplicialSurface",
			"NrOfVerticesAttributeOfSimplicialSurface",
			"NrOfEdgesAttributeOfSimplicialSurface",
			"NrOfFacesAttributeOfSimplicialSurface",
			"VerticesByEdgesAttributeOfSimplicialSurface",
			"VerticesByFacesAttributeOfSimplicialSurface",
			"EdgesByVerticesAttributeOfSimplicialSurface",
			"EdgesByFacesAttributeOfSimplicialSurface",
			"FacesByVerticesAttributeOfSimplicialSurface",
			"FacesByEdgesAttributeOfSimplicialSurface",
			"IsActualSurface",
			"IsTriangleSurface",
			"IsOrientable",
			"IsConnected",
			"ConnectedComponentsAttributeOfSimplicialSurface",
			"EulerCharacteristicAttributeOfSimplicialSurface",
			"UnsortedDegreesAttributeOfSimplicialSurface",
			"SortedDegreesAttributeOfSimplicialSurface",
			"VertexSymbolAttributeOfSimplicialSurface",
			"LocalOrientationAttributeOfSimplicialSurface",
			"NamesOfFacesAttributeOfSimplicialSurface",
			"IsFaceNamesDefault",
			"FaceAnomalyClassesAttributeOfSimplicialSurface",
			"IncidenceGraphAttributeOfSimplicialSurface"];
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
##	Our first method gives us a sorted FacesByVertices (to reflect the
##	implicitly given orientation). If the given list does not allow a unique
##	result, an error is thrown.
##
__SIMPLICIAL_OrderPreservingFacesByVertices := function( vertices, edges,
		faces, edgesByVertices, facesByEdges )
	local faceList, i, faceEdges, intersectingEdges, vertexList, j, firstEdge,
		lastEdge, currentEdge, nextEdge;

	faceList := [];
	for i in faces do
		faceEdges := facesByEdges[i];
		vertexList := [];

		# Intersect first and last edge to obtain first vertex
		firstEdge := Set( edgesByVertices[faceEdges[1]] );
		lastEdge := Set( edgesByVertices[faceEdges[Length(faceEdges)]] );
		intersectingEdges := Intersection( firstEdge, lastEdge );
		if Length(intersectingEdges) <> 1 then
   	    	Error("__SIMPLICIAL_OrderPreservingFacesByVertices: Edge intersection is not unique.");
		fi;
		vertexList[1] := intersectingEdges[1];

		# Continue in the same way for the other edges
		for j in [2 .. Length(faceEdges)] do
			currentEdge := Set( edgesByVertices[faceEdges[j-1]] );
			nextEdge := Set( edgesByVertices[faceEdges[j]] );
			intersectingEdges := Intersection( currentEdge, nextEdge );
			if Length(intersectingEdges) <> 1 then
  	     		Error("__SIMPLICIAL_OrderPreservingFacesByVertices: Edge intersection is not unique.");
			fi;
			vertexList[j] := intersectingEdges[1];
		od;

		faceList[i] := vertexList;
	od;

	return faceList;
end;

__SIMPLICIAL_RandomFacesByVertices := function( vertices, faces, 
		facesByVertices, verticesByEdges )
	local faceList, i, faceEdges, intersectingEdges, vertexList, j, firstEdge,
		lastEdge, currentEdge, nextEdge;

	faceList := [];
	for i in faces do
		faceVertices := facesByVertices[i];
		vertexList := [];

		# Pick one to be the first vertex
		vertexList[1] := faceVertices[1];
		faceVertices := Difference( faceVertices, vertexList );

		# Pick the other vertices such that each one shares an edge with the last picked
		while not IsEmpty(faceVertices) do
			# Find one vertex that is adjacent to the last one in vertexOrder
			lastVertex := vertexList[ Length(vertexList) ];
			newVertex := -1;
			for v in faceVertices do
				if not IsEmpty( Intersection( verticesByEdges[lastVertex], verticesByEdges[newVertex] ) ) then
					newVertex := v;
				fi;
			od;

			if newVertex = -1 then
				Error("__SIMPLICIAL_RandomFacesByVertices: No next vertex found." );
			fi;

			Append( vertexList, [newVertex] );
			faceVertices := Difference( faceVertices, [newVertex] );
		od;

		faceList[i] := vertexList;
	od;

	return faceList;
end;

	facesByVerticesOrdered := [];
		for f in Faces(surf) do
			vertexList := facesByVertices[f];
			vertexOrder := [ vertexList[1] ];
			vertexList := Difference( vertexList, vertexOrder[1] );

			while not IsEmpty(vertexList) do
				# Find one vertex that is adjacent to the last one in vertexOrder
				newVertex := -1;
				for v in vertexList do

				od;
				
			od;
			facesByVerticesOrdered[f] := vertexOrder;
		od;

##
##	Next we create a local orientation from such a list
##
__SIMPLICIAL_LocalOrientationFromFacesByVertices := function( facesByVertices )
	local orientation, Shift;

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

	return List( facesByVertices, face -> MappingPermListList( face, Shift(face) ) );
end;

##
##	Now we install the most basic constructors
InstallMethod( SimplicialSurfaceByDownwardIncidenceWithOrientationNC, "",
	[ IsSet, IsSet, IsSet, IsList, IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		local surf, namesOfFaces, facesByVerticesOP, localOrient;

		facesByVerticesOP := __SIMPLICIAL_OrderPreservingFacesByVertices( 
					vertices, edges, faces, edgesByVertices, facesByEdges );
		localOrient := __SIMPLICIAL_LocalOrientationFromFacesByVertices( 
														facesByVerticesOP );

		surf := Objectify( SimplicialSurfaceType, rec() );
		# Set the given attributes
		SetVerticesAttributeOfSimplicialSurface( surf, vertices );
		SetEdgesAttributeOfSimplicialSurface( surf, edges );
		SetFacesAttributeOfSimplicialSurface( surf, faces );
		SetEdgesByVerticesAttributeOfSimplicialSurface( surf, 
								List( edgesByVertices, i -> Set(i) ) );
		SetFacesByEdgesAttributeOfSimplicialSurface( surf, 
								List( facesByEdges, i -> Set(i) ) );
		SetFacesByVerticesAttributeOfSimplicialSurface( surf, 
								List( facesByVerticesOP, i -> Set(i) ) );
		SetLocalOrientationAttributeOfSimplicialSurface( surf, localOrient );

		# Set the face names
		namesOfFaces := ValueOption( "NamesOfFaces" );
		if namesOfFaces = fail then
			SetIsFaceNamesDefault( surf, true );
		else
			SetNamesOfFacesAttributeOfSimplicialSurface( surf, namesOfFaces );
		fi;

		return surf;
	end
);
RedispatchOnCondition( SimplicialSurfaceByDownwardIncidenceWithOrientationNC,
	true, [ IsList, IsList, IsList, IsList, IsList],
	[ IsSet, IsSet, IsSet, , ], 0 );
##
##	Adjust for the alternative possibilities.
InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceWithOrientationNC, "",
	[ IsPosInt, IsObject, IsObject, IsList, IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		return SimplicialSurfaceByDownwardIncidenceWithOrientationNC( 
			[1..vertices], edges, faces, edgesByVertices, facesByEdges );
	end
);

InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceWithOrientationNC, "",
	[ IsSet, IsPosInt, IsObject, IsList, IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		return SimplicialSurfaceByDownwardIncidenceWithOrientationNC( vertices, 
			[1..edges],	faces, edgesByVertices, facesByEdges );
	end
);
RedispatchOnCondition( SimplicialSurfaceByDownwardIncidenceWithOrientationNC, 
	true, [ IsList, IsPosInt, IsObject, IsList, IsList],
	[ IsSet, , , , ], 0 );

InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceWithOrientationNC, "",
	[ IsSet, IsSet, IsPosInt, IsList, IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		return SimplicialSurfaceByDownwardIncidenceWithOrientationNC( vertices, 
			edges, [1..faces], edgesByVertices, facesByEdges );
	end
);
RedispatchOnCondition( SimplicialSurfaceByDownwardIncidenceWithOrientationNC, 
	true, [ IsList, IsList, IsPosInt, IsList, IsList],
	[ IsSet, IsSet, , , ], 0 );
##
##	Next we have to install the same constructors with checks.

__SIMPLICIAL_IsSetPosInt := function( set ) # check if a set consists of positive integers
		local el;
		for el in set do
			if not IsPosInt(el) then
				return false;
			fi;
		od;
		return true;
	end;
__SIMPLICIAL_CheckDownwardIncidence := function( vertices, edges, faces,
	edgesByVertices, facesByEdges, namesOfFaces )
	
	local e, f;

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

	# Is edgesByVertices well defined?
	for e in edges do
		if not IsBound( edgesByVertices[e] ) then
			Error("DownwardIncidenceCheck: One edge has no vertices.");
		elif Size( Set( edgesByVertices[e] ) ) <> 2 then
			Error("DownwardIncidenceCheck: One edge has not two vertices.");
		elif not IsEmpty( Difference( Set(edgesByVertices[e]), vertices ) ) then
			Error("DownwardIncidenceCheck: One edge has illegal vertex.");
		fi;
	od;
	if Number( edgesByVertices ) <> Length( edges ) then # Number counts bound entries
		Error("DownwardIncidenceCheck: More edges than expected.");
	fi;
	if Union( edgesByVertices ) <> vertices then
		Error("DownwardIncidenceCheck: One vertex does not lie in any edge.");
	fi;

	# Is facesByEdges well defined?
	for f in faces do
		if not IsBound( facesByEdges[f] ) then
			Error("DownwardIncidenceCheck: One face has no edges.");
		elif Size( Set( facesByEdges[f] ) ) < 3 then
			Error("DownwardIncidenceCheck: One face has less than three edges.");
		elif not IsEmpty( Difference( Set(facesByEdges[f]), edges ) ) then
			Error("DownwardIncidenceCheck: One face has illegal edge.");
		fi;
	od;
	if Number( facesByEdges ) <> Length( faces ) then
		Error("DownwardIncidenceCheck: More faces than expected.");
	fi;
	if Union( facesByEdges ) <> edges then
		Error("DownwardIncidenceCheck: One edge does not lie in any face.");
	fi;

	# Check the face names
	if not namesOfFaces = fail then
		for f in faces do
			if not IsBound( namesOfFaces[f] ) then
				Error("DownwardIncidenceCheck: One face has no names.");
			elif Size( Set( namesOfFaces[f] ) ) <> 2 then
				Error("DownwardIncidenceCheck: One face has not two different names.");
			elif not IsInt(namesOfFaces[f][1]) or not IsInt(namesOfFaces[f][2]) then
				Error("DownwardIncidenceCheck: One face has non-integer names.");
			fi;
		od;
		if Number( namesOfFaces ) <> Length( faces ) then
			Error("DownwardIncidenceCheck: More face-names than expected.");
		fi;
	fi;
end;
InstallMethod( SimplicialSurfaceByDownwardIncidenceWithOrientation, "",
	[ IsSet, IsSet, IsSet, IsList, IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )

		__SIMPLICIAL_CheckDownwardIncidence( vertices, edges, faces,
			edgesByVertices, facesByEdges, ValueOption( "NamesOfFaces" ) );

		return SimplicialSurfaceByDownwardIncidenceWithOrientationNC( 
					vertices, edges, faces, edgesByVertices, facesByEdges );
	end
);
RedispatchOnCondition( SimplicialSurfaceByDownwardIncidenceWithOrientation, 
	true, [ IsList, IsList, IsList, IsList, IsList],
	[ IsSet, IsSet, IsSet, , ], 0 );
##
##	Adjust for the alternative possibilities.
InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceWithOrientation, "",
	[ IsPosInt, IsObject, IsObject, IsList, IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		return SimplicialSurfaceByDownwardIncidenceWithOrientation( 
			[1..vertices], edges, faces, edgesByVertices, facesByEdges );
	end
);

InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceWithOrientation, "",
	[ IsSet, IsPosInt, IsObject, IsList, IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		return SimplicialSurfaceByDownwardIncidenceWithOrientation( vertices, 
			[1..edges],	faces, edgesByVertices, facesByEdges );
	end
);
RedispatchOnCondition( SimplicialSurfaceByDownwardIncidenceWithOrientation, 
	true, [ IsList, IsPosInt, IsObject, IsList, IsList],
	[ IsSet, , , , ], 0 );

InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceWithOrientation, "",
	[ IsSet, IsSet, IsPosInt, IsList, IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		return SimplicialSurfaceByDownwardIncidenceWithOrientation( vertices, 
			edges, [1..faces], edgesByVertices, facesByEdges );
	end
);
RedispatchOnCondition( SimplicialSurfaceByDownwardIncidenceWithOrientation, 
	true, [ IsList, IsList, IsPosInt, IsList, IsList],
	[ IsSet, IsSet, , , ], 0 );
##
##
##
##

##
##	Next we install the "easy mode" of the above constructor.
InstallMethod( SimplicialSurfaceByDownwardIncidenceNC, "",
	[ IsSet, IsSet, IsSet, IsList, IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		local surf, namesOfFaces, facesByVertices, facesByVerticesOrdered,
			 localOrient, f, newVertex, v;

		surf := Objectify( SimplicialSurfaceType, rec() );
		# Set the given attributes
		SetVerticesAttributeOfSimplicialSurface( surf, vertices );
		SetEdgesAttributeOfSimplicialSurface( surf, edges );
		SetFacesAttributeOfSimplicialSurface( surf, faces );
		SetEdgesByVerticesAttributeOfSimplicialSurface( surf, 
								List( edgesByVertices, i -> Set(i) ) );
		SetFacesByEdgesAttributeOfSimplicialSurface( surf, 
								List( facesByEdges, i -> Set(i) ) );

		# Set the local orientation at random
		facesByVertices := __SIMPLICIAL_RandomFacesByVertices( vertices, faces,
			FacesByVertices(surf), VerticesByEdges(surf) );
		localOrient := __SIMPLICIAL_LocalOrientationFromFacesByVertices( 
			facesByVerticesOrdered );
		SetLocalOrientationAttributeOfSimplicialSurface( surf, localOrient );

		# Set the face names
		SetNamesOfFacesAttributeOfSimplicialSurface( surf, namesOfFaces );
		
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
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		return SimplicialSurfaceByDownwardIncidenceNC( [1..vertices], edges,
			faces, edgesByVertices, facesByEdges );
	end
);

InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceNC, "",
	[ IsSet, IsPosInt, IsObject, IsList, IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		return SimplicialSurfaceByDownwardIncidenceNC( vertices, [1..edges],
			faces, edgesByVertices, facesByEdges );
	end
);
RedispatchOnCondition( SimplicialSurfaceByDownwardIncidenceNC, 
	true, [ IsList, IsPosInt, IsObject, IsList, IsList],
	[ IsSet, , , , ], 0 );

InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceNC, "",
	[ IsSet, IsSet, IsPosInt, IsList, IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		return SimplicialSurfaceByDownwardIncidenceNC( vertices, edges,
			[1..faces], edgesByVertices, facesByEdges );
	end
);
RedispatchOnCondition( SimplicialSurfaceByDownwardIncidenceNC, 
	true, [ IsList, IsList, IsPosInt, IsList, IsList],
	[ IsSet, IsSet, , , ], 0 );
##
##	Next we have to install the same constructors with checks.
InstallMethod( SimplicialSurfaceByDownwardIncidenceWithOrientation, "",
	[ IsSet, IsSet, IsSet, IsList, IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		
		__SIMPLICIAL_CheckDownwardIncidence( vertices, edges, faces,
			edgesByVertices, facesByEdges, fail );

		return SimplicialSurfaceByDownwardIncidenceWithOrientationNC( 
					vertices, edges, faces, edgesByVertices, facesByEdges );
	end
);
RedispatchOnCondition( SimplicialSurfaceByDownwardIncidenceWithOrientation, true,
	[ IsList, IsList, IsList, IsList, IsList],
	[ IsSet, IsSet, IsSet, , ], 0 );
##
##	Adjust for the alternative possibilities.
InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceWithOrientation, "",
	[ IsPosInt, IsObject, IsObject, IsList, IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		return SimplicialSurfaceByDownwardIncidenceWithOrientation( [1..vertices], edges,
			faces, edgesByVertices, facesByEdges );
	end
);

InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceWithOrientation, "",
	[ IsSet, IsPosInt, IsObject, IsList, IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		return SimplicialSurfaceByDownwardIncidenceWithOrientation( vertices, [1..edges],
			faces, edgesByVertices, facesByEdges );
	end
);
RedispatchOnCondition( SimplicialSurfaceByDownwardIncidenceWithOrientation, true,
	[ IsList, IsPosInt, IsObject, IsList, IsList],
	[ IsSet, , , , ], 0 );

InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceWithOrientation, "",
	[ IsSet, IsSet, IsPosInt, IsList, IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		return SimplicialSurfaceByDownwardIncidenceWithOrientation( vertices, edges,
			[1..faces], edgesByVertices, facesByEdges );
	end
);
RedispatchOnCondition( SimplicialSurfaceByDownwardIncidenceWithOrientation, true,
	[ IsList, IsList, IsPosInt, IsList, IsList],
	[ IsSet, IsSet, , , ], 0 );
##
##
##
##	Now we implement the constructor byVerticesInFaces. We start with the
##	NC-versions.
InstallMethod( SimplicialSurfaceByVerticesInFacesWithOrientationNC, "",
	[ IsSet, IsSet, IsList ],
	function( vertices, faces, facesByVertices )
		local surf, namesOfFaces, localOrient, edgesByVertices, 
				facesByEdges, f, j, e, facesBySetEdges;

		localOrient := __SIMPLICIAL_LocalOrientationFromFacesByVertices( 
														facesByVertices );

		# Determine the edges. For each face we determine all subset of its
		# vertices that contain two elements. These sets will form the edges
		# of the simplicial surface
		facesBySetEdges := List( faces, i -> 
					Set(Combinations( Set(facesByVertices[i]) ,2)) );
		edgesByVertices := Union(facesBySetEdges);

		facesByEdges := List(faces,i->[]);
		for f in faces do
			for j  in [1..3] do
				e := facesBySetEdges[f][j];
				facesByEdges[f][j] := Position(edgesByVertices,e);
			od;
		od;

		surf := Objectify( SimplicialSurfaceType, rec() );
		# Set the given attributes
		SetVerticesAttributeOfSimplicialSurface( surf, vertices );
		SetEdgesAttributeOfSimplicialSurface( surf, 
									[1..Length(edgesByVertices)] );
		SetFacesAttributeOfSimplicialSurface( surf, faces );
		SetEdgesByVerticesAttributeOfSimplicialSurface( surf, edgesByVertices );
		SetFacesByEdgesAttributeOfSimplicialSurface( surf, facesByEdges );
		SetFacesByVerticesAttributeOfSimplicialSurface( surf, 
									List( facesByVertices, i -> Set(i) ) );
		SetLocalOrientationAttributeOfSimplicialSurface( surf, localOrient );

		# Set the face names
		namesOfFaces := ValueOption( "NamesOfFaces" );
		if namesOfFaces = fail then
			SetIsFaceNamesDefault( surf, true );
		else
			SetNamesOfFacesAttributeOfSimplicialSurface( surf, namesOfFaces );
		fi;

		return surf;
	end
);
RedispatchOnCondition( SimplicialSurfaceByVerticesInFacesWithOrientationNC, true,
	[ IsList, IsList, IsList],
	[ IsSet, IsSet, ], 0 );

##	Adjust for the alternative possibilities.
InstallOtherMethod( SimplicialSurfaceByVerticesInFacesWithOrientationNC, "",
	[ IsPosInt, IsObject, IsList ],
	function( vertices, faces, facesByVertices )
		return SimplicialSurfaceByVerticesInFacesWithOrientationNC( [1..vertices], faces,
			facesByVertices );
	end
);
InstallOtherMethod( SimplicialSurfaceByVerticesInFacesWithOrientationNC, "",
	[ IsSet, IsPosInt, IsList ],
	function( vertices, faces, facesByVertices )
		return SimplicialSurfaceByVerticesInFacesWithOrientationNC( vertices, [1..faces],
			facesByVertices );
	end
);
RedispatchOnCondition( SimplicialSurfaceByVerticesInFacesWithOrientationNC, true,
	[ IsList, IsPosInt, IsList],
	[ IsSet, , ], 0 );
##
##	Of course the same constructors with sanity checks can't be missing.
##
__SIMPLICIAL_CheckVerticesInFaces := function( vertices, faces, facesByVertices, namesOfFaces )
	
	local f;

	# Check sets
	if not __SIMPLICIAL_IsSetPosInt( vertices ) then
		Error("VerticesInFacesCheck: Vertices have to be positive integers.");
	fi;

	if not __SIMPLICIAL_IsSetPosInt( faces ) then
		Error("VerticesInFacesCheck: Faces have to be positive integers.");
	fi;

	# Is facesByVertices well defined?
	for f in faces do
		if not IsBound( facesByVertices[f] ) then
			Error("VerticesInFacesCheck: One face has no vertices.");
		elif Size( Set( facesByVertices[f] ) ) <> 3 then
			Error("VerticesInFacesCheck: One face has not three vertices.");
		elif not IsEmpty( Difference( Set(facesByVertices[f]), vertices ) ) then
			Error("VerticesInFacesCheck: One face has illegal vertex.");
		fi;
	od;
	if Number( facesByVertices ) <> Length( faces ) then
		Error("VerticesInFacesCheck: More faces than expected.");
	fi;

	# Check the face names
	if not namesOfFaces = fail then
		for f in faces do
			if not IsBound( namesOfFaces[f] ) then
				Error("VerticesInFacesCheck: One face has no names.");
			elif Size( Set( namesOfFaces[f] ) ) <> 2 then
				Error("VerticesInFacesCheck: One face has not two different names.");
			elif not IsInt(namesOfFaces[f][1]) or not IsInt(namesOfFaces[f][2]) then
				Error("VerticesInFacesCheck: One face has non-integer names.");
			fi;
		od;
		if Number( namesOfFaces ) <> Length( faces ) then
			Error("VerticesInFacesCheck: More face-names than expected.");
		fi;
	fi;
end;
InstallMethod( SimplicialSurfaceByVerticesInFacesWithOrientation, "",
	[ IsSet, IsSet, IsList ],
	function( vertices, faces, facesByVertices )
		
		__SIMPLICIAL_CheckVerticesInFaces( vertices, faces, facesByVertices, ValueOption( "NamesOfFaces" ) );

		return SimplicialSurfaceByVerticesInFacesWithOrientationNC( 
					vertices, faces, facesByVertices );
	end
);
RedispatchOnCondition( SimplicialSurfaceByVerticesInFacesWithOrientation, true,
	[ IsList, IsList, IsList],
	[ IsSet, IsSet, ], 0 );
##	Adjust for the alternative possibilities.
InstallOtherMethod( SimplicialSurfaceByVerticesInFacesWithOrientation, "",
	[ IsPosInt, IsObject, IsList ],
	function( vertices, faces, facesByVertices )
		return SimplicialSurfaceByVerticesInFacesWithOrientation( [1..vertices], faces,
			facesByVertices );
	end
);
InstallOtherMethod( SimplicialSurfaceByVerticesInFacesWithOrientation, "",
	[ IsSet, IsPosInt, IsList ],
	function( vertices, faces, facesByVertices )
		return SimplicialSurfaceByVerticesInFacesWithOrientation( vertices, [1..faces],
			facesByVertices );
	end
);
RedispatchOnCondition( SimplicialSurfaceByVerticesInFacesWithOrientation, true,
	[ IsList, IsPosInt, IsList],
	[ IsSet, , ], 0 );

##
##
##	Finally the constructor VerticesInFaces
##	Now we implement the constructor byVerticesInFaces. We start with the
##	NC-versions.
InstallMethod( SimplicialSurfaceByVerticesInFacesNC, "",
	[ IsSet, IsSet, IsList ],
	function( vertices, faces, facesByVertices )
		local surf, namesOfFaces, localOrient, edgesByVertices, 
				facesByEdges, f, j, e, facesBySetEdges;

		# Determine the edges. For each face we determine all subset of its
		# vertices that contain two elements. These sets will form the edges
		# of the simplicial surface
		facesBySetEdges := List( faces, i -> 
					Set(Combinations( Set(facesByVertices[i]) ,2)) );
		edgesByVertices := Union(facesBySetEdges);

		facesByEdges := List(faces,i->[]);
		for f in faces do
			for j  in [1..3] do
				e := facesBySetEdges[f][j];
				facesByEdges[f][j] := Position(edgesByVertices,e);
			od;
		od;

		surf := Objectify( SimplicialSurfaceType, rec() );
		# Set the given attributes
		SetVerticesAttributeOfSimplicialSurface( surf, vertices );
		SetEdgesAttributeOfSimplicialSurface( surf, 
									[1..Length(edgesByVertices)] );
		SetFacesAttributeOfSimplicialSurface( surf, faces );
		SetEdgesByVerticesAttributeOfSimplicialSurface( surf, edgesByVertices );
		SetFacesByEdgesAttributeOfSimplicialSurface( surf, facesByEdges );
		SetFacesByVerticesAttributeOfSimplicialSurface( surf, 
									List( facesByVertices, i -> Set(i) ) );

		# Set the local orientation
		facesByVertices := __SIMPLICIAL_RandomFacesByVertices( vertices, faces,
			FacesByVertices(surf), VerticesByEdges(surf) );
		localOrient := __SIMPLICIAL_LocalOrientationFromFacesByVertices( 
			facesByVerticesOrdered );
		SetLocalOrientationAttributeOfSimplicialSurface( surf, localOrient );

		# Set the face names
		SetIsFaceNamesDefault( surf, true );

		return surf;
	end
);
RedispatchOnCondition( SimplicialSurfaceByVerticesInFacesNC, true,
	[ IsList, IsList, IsList],
	[ IsSet, IsSet, ], 0 );

##	Adjust for the alternative possibilities.
InstallOtherMethod( SimplicialSurfaceByVerticesInFacesNC, "",
	[ IsPosInt, IsObject, IsList ],
	function( vertices, faces, facesByVertices )
		return SimplicialSurfaceByVerticesInFacesNC( [1..vertices], faces,
			facesByVertices );
	end
);
InstallOtherMethod( SimplicialSurfaceByVerticesInFacesNC, "",
	[ IsSet, IsPosInt, IsList ],
	function( vertices, faces, facesByVertices )
		return SimplicialSurfaceByVerticesInFacesNC( vertices, [1..faces],
			facesByVertices );
	end
);
RedispatchOnCondition( SimplicialSurfaceByVerticesInFacesNC, true,
	[ IsList, IsPosInt, IsList],
	[ IsSet, , ], 0 );
##
##	Of course the same constructors with sanity checks can't be missing.
##
InstallMethod( SimplicialSurfaceByVerticesInFaces, "",
	[ IsSet, IsSet, IsList ],
	function( vertices, faces, facesByVertices )
		
		__SIMPLICIAL_CheckVerticesInFaces( vertices, faces, facesByVertices, ValueOption( "NamesOfFaces" ) );

		return SimplicialSurfaceByVerticesInFaces( 
					vertices, faces, facesByVertices );
	end
);
RedispatchOnCondition( SimplicialSurfaceByVerticesInFaces, true,
	[ IsList, IsList, IsList],
	[ IsSet, IsSet, ], 0 );
##	Adjust for the alternative possibilities.
InstallOtherMethod( SimplicialSurfaceByVerticesInFaces, "",
	[ IsPosInt, IsObject, IsList ],
	function( vertices, faces, facesByVertices )
		return SimplicialSurfaceByVerticesInFaces( [1..vertices], faces,
			facesByVertices );
	end
);
InstallOtherMethod( SimplicialSurfaceByVerticesInFaces, "",
	[ IsSet, IsPosInt, IsList ],
	function( vertices, faces, facesByVertices )
		return SimplicialSurfaceByVerticesInFaces( vertices, [1..faces],
			facesByVertices );
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


#############################################################################
#! @Description
#! Returns the numbers of the vertices as a set.
#! @Arguments a simplicial surface
#! @Returns a dense list of integers
InstallMethod( Vertices, "for a simplicial surface", [IsSimplicialSurface],
	function( simpsurf )
		return VerticesAttributeOfSimplicialSurface(simpsurf);
	end
);
#############################################################################
#! @Description
#! Returns the numbers of the edges as a set.
#! @Arguments a simplicial surface
#! @Returns a dense list of integers
InstallMethod( Edges, "for a simplicial surface", [IsSimplicialSurface],
	function( simpsurf )
		return EdgesAttributeOfSimplicialSurface(simpsurf);
	end
);
#############################################################################
#! @Description
#! Returns the numbers of the faces as a set.
#! @Arguments a simplicial surface
#! @Returns a dense list of integers
InstallMethod( Faces, "for a simplicial surface", [IsSimplicialSurface],
	function( simpsurf )
		return FacesAttributeOfSimplicialSurface(simpsurf);
	end
);
#############################################################################
#! @Description
#!	Return a list of permutations where at the position of each face-number
#!	there is a cycle of all vertices that are incident to this face. This
#!	cycle represents the local orientation of this face. All other positions
#!	are unbounded.
#!  @Returns a list of permutations
#!  @Arguments a simplicial surface object simpsurf
InstallMethod( LocalOrientation, "for a simplicial surface", 
	[IsSimplicialSurface],
	function( simpsurf )
		return LocalOrientationAttributeOfSimplicialSurface(simpsurf);
	end
);
#############################################################################
#!  @Description
#!	Return a list of tuples where at each face-number there is a list with two
#!	entries. The first one is the name of the upper face-side, the second one
#!	the name of the lower face-side (with respect to the local orientation).
#!	All other positions are unbounded.
#!  @Returns a list of lists of integers
#!  @Arguments a simplicial surface object simpsurf
InstallMethod( NamesOfFaces, "for a simplicial surface", 
	[IsSimplicialSurface],
	function( simpsurf )
		return NamesOfFacesAttributeOfSimplicialSurface(simpsurf);
	end
);


#############################################################################
##
#!	@Description
#!	This function returns the number of vertices.
#!	@Returns an integer
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( NrOfVerticesAttributeOfSimplicialSurface, 
	"for a simplicial surface",
	[ IsSimplicialSurface ],
	function(simpsurf)
		return Length( VerticesAttributeOfSimplicialSurface(simpsurf) );
	end
);
InstallMethod( NrOfVertices, "for a simplicial surface",
	[ IsSimplicialSurface ],
	function(simpsurf)
		return NrOfVerticesAttributeOfSimplicialSurface(simpsurf);
	end
);

#############################################################################
##
#!	@Description
#!	This function returns the number of edges.
#!	@Returns an integer
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( NrOfEdgesAttributeOfSimplicialSurface, 
	"for a simplicial surface",
	[ IsSimplicialSurface ],
	function(simpsurf)
		return Length( EdgesAttributeOfSimplicialSurface(simpsurf) );
	end
);
InstallMethod( NrOfEdges, "for a simplicial surface",
	[ IsSimplicialSurface ],
	function(simpsurf)
		return NrOfEdgesAttributeOfSimplicialSurface(simpsurf);
	end
);

#############################################################################
##
#!	@Description
#!	This function returns the number of faces.
#!	@Returns an integer
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( NrOfFacesAttributeOfSimplicialSurface, 
	"for a simplicial surface",
	[ IsSimplicialSurface ],
	function(simpsurf)
		return Length( FacesAttributeOfSimplicialSurface(simpsurf) );
	end
);
InstallMethod( NrOfFaces, "for a simplicial surface",
	[ IsSimplicialSurface ],
	function(simpsurf)
		return NrOfFacesAttributeOfSimplicialSurface(simpsurf);
	end
);

#############################################################################
##
##  A Print method for simplicial surfaces
##
InstallMethod( PrintObj, "for simplicial surfaces", [ IsSimplicialSurface ],
	function(simpsurf)

        Print("SimplicialSurfaceByDownwardIncidenceNC(\n");
        Print( Vertices(simpsurf), ",\n");
        Print( Edges(simpsurf), ",\n");
        Print( Faces(simpsurf), ",\n");
        Print( EdgesByVertices(simpsurf), ",\n");
        Print( FacesByEdges(simpsurf), ");\n");
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
        Print("EdgesByVertices: ", EdgesByVertices(simpsurf), ",\n");
        Print("FacesByEdges: ", FacesByEdges(simpsurf), ",\n" );
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

		if EdgesByVertices(s1) <> EdgesByVertices(s2) then
			return false;
		fi;
		if FacesByEdges(s1) <> FacesByEdges(s2) then
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
##						Start of *By*-methods
##
##	It is pretty annoying to implement all of the *By*-methods for each
##	individual representation. As they are interdependent, this is also
##	redundant. Therefore we collect some methods here that allow us to only
##	implement a minimal set of these methods. We rely on the fact that we
##	consider the *By*-objects as attributes which have a corresponding filter
##	which makes it known which of those are already known.
##
##	First we need some wrapper functions for the long attribute names.
InstallMethod( VerticesByEdges, [IsSimplicialSurface],
	function( surf )
		return VerticesByEdgesAttributeOfSimplicialSurface( surf );
	end
);
InstallMethod( VerticesByFaces, [IsSimplicialSurface],
	function( surf )
		return VerticesByFacesAttributeOfSimplicialSurface( surf );
	end
);
InstallMethod( EdgesByVertices, [IsSimplicialSurface],
	function( surf )
		return EdgesByVerticesAttributeOfSimplicialSurface( surf );
	end
);
InstallMethod( EdgesByFaces, [IsSimplicialSurface],
	function( surf )
		return EdgesByFacesAttributeOfSimplicialSurface( surf );
	end
);
InstallMethod( FacesByVertices, [IsSimplicialSurface],
	function( surf )
		return FacesByVerticesAttributeOfSimplicialSurface( surf );
	end
);
InstallMethod( FacesByEdges, [IsSimplicialSurface],
	function( surf )
		return FacesByEdgesAttributeOfSimplicialSurface( surf );
	end
);
##
##	There are exactly four cases in which we know every information from
##	two of those values:
##		FacesByEdges and EdgesByVertices
##		FacesByEdges and VerticesByEdges
##		EdgesByFaces and EdgesByVertices
##		EdgesByFaces and VerticesByEdges
##	We will start with an inversion and a transitivity method. These two are
##	sufficient to generate every other combination in at most two steps. Since
##	GAP can't do more than one step we have to define additional methods for
##	these cases.
##	
##	At first we implement the inversion of an incidence relation. For example
##	we know facesByEdges but want to know edgesByFaces. As this inversion is
##	always the same we implement it in general.
##	Given are the numbers of edges and faces, together with the relation
##	facesByEdges. It returns the relation edgesByFaces. (The names are used
##	only for illustration.)
__SIMPLICIAL_InvertIncidence := function( faceNr, facesByEdges, edgeNr )
	local edgeList, edge, faceSet, face;

	edgeList := [];
	for edge in edgeNr do
		faceSet := [];
		for face in faceNr do
			if edge in facesByEdges[face] then
				faceSet := Union( faceSet, [face] );
			fi;
		od;
		edgeList[edge] := faceSet;
	od;

	return edgeList;
end;
##
##	With this method we can write inversion methods for all six cases.
InstallMethod( VerticesByEdgesAttributeOfSimplicialSurface, 
	[IsSimplicialSurface and HasEdgesByVerticesAttributeOfSimplicialSurface ],
	function( simpsurf )
		return __SIMPLICIAL_InvertIncidence( Edges(simpsurf),
				EdgesByVertices(simpsurf), Vertices(simpsurf) );
	end
);
InstallMethod( VerticesByFacesAttributeOfSimplicialSurface, 
	[IsSimplicialSurface and HasFacesByVerticesAttributeOfSimplicialSurface ],
	function( simpsurf )
		return __SIMPLICIAL_InvertIncidence( Faces(simpsurf),
				FacesByVertices(simpsurf), Vertices(simpsurf) );
	end
);
InstallMethod( EdgesByVerticesAttributeOfSimplicialSurface, 
	[IsSimplicialSurface and HasVerticesByEdgesAttributeOfSimplicialSurface ],
	function( simpsurf )
		return __SIMPLICIAL_InvertIncidence( Vertices(simpsurf),
				VerticesByEdges(simpsurf), Edges(simpsurf) );
	end
);
InstallMethod( EdgesByFacesAttributeOfSimplicialSurface, 
	[IsSimplicialSurface and HasFacesByEdgesAttributeOfSimplicialSurface ],
	function( simpsurf )
		return __SIMPLICIAL_InvertIncidence( Faces(simpsurf),
				FacesByEdges(simpsurf), Edges(simpsurf) );
	end
);
InstallMethod( FacesByVerticesAttributeOfSimplicialSurface, 
	[IsSimplicialSurface and HasVerticesByFacesAttributeOfSimplicialSurface ],
	function( simpsurf )
		return __SIMPLICIAL_InvertIncidence( Vertices(simpsurf),
				VerticesByFaces(simpsurf), Faces(simpsurf) );
	end
);
InstallMethod( FacesByEdgesAttributeOfSimplicialSurface, 
	[IsSimplicialSurface and HasEdgesByFacesAttributeOfSimplicialSurface ],
	function( simpsurf )
		return __SIMPLICIAL_InvertIncidence( Edges(simpsurf),
				EdgesByFaces(simpsurf), Faces(simpsurf) );
	end
);
##
##	Next we consider the case of transitivity: From FacesByEdges and 
##	EdgesByVertices we can deduce FacesByVertices
__SIMPLICIAL_TransitiveIncidence := function( faceNr, facesByEdges, edgeNr,
												edgesByVertices, vertexNr )
	local face, facesByVertices, edgesInFace, verticesInEdges;

	facesByVertices := [];
	for face in faceNr do
		edgesInFace := facesByEdges[face];
		verticesInEdges := List( edgesInFace, e -> edgesByVertices[e] );
		facesByVertices[face] := Union( verticesInEdges );
	od;

	return facesByVertices;
end;
##
InstallMethod( FacesByVerticesAttributeOfSimplicialSurface, 
	[IsSimplicialSurface and HasFacesByEdgesAttributeOfSimplicialSurface and
							HasEdgesByVerticesAttributeOfSimplicialSurface ],
	function( simpsurf )
		return __SIMPLICIAL_TransitiveIncidence( Faces(simpsurf),
			FacesByEdges(simpsurf), Edges(simpsurf),
			EdgesByVertices(simpsurf), Vertices(simpsurf) );
	end
);
InstallMethod( VerticesByFacesAttributeOfSimplicialSurface, 
	[IsSimplicialSurface and HasVerticesByEdgesAttributeOfSimplicialSurface and
								HasEdgesByFacesAttributeOfSimplicialSurface ],
	function( simpsurf )
		return __SIMPLICIAL_TransitiveIncidence( Vertices(simpsurf),
			VerticesByEdges(simpsurf), Edges(simpsurf),
			EdgesByFaces(simpsurf), Faces(simpsurf) );
	end
);
##	Normally we would be finished at this point. But the method selection of
##	GAP is not so intelligent to check for attributes transitively (it only
##	checks if an attribute is set, not if it could be set). It would have been
##	nice if this could be done by RedispatchOnCondition (see 78.5-1) but this
##	option only works for properties. Since Has* is false if the attribute *
##	is not computed, we can't use it (theoretically we could introduce an
##	additional property for "possible existence of this attribute" but that
##	gets even more involved). Therefore we will just brute force all remaining
##	possibilites.
##
##	IMPORTANT Note: Since we change the filters we must not use TryNextMethod()
##	since doing so would not take this change into account.
##
##	VERY IMPORTANT subtle note: We have to take care to work with the automatic
##	method selection. Otherwise it might happen that we repeatedly choose
##	the same method and go into an infinite loop. Therefore we have to check
##	first if the necessary filter is set and - if it is - use TryNextMethod().
##
##	If both incidences go in the same direction (e.g. FacesByEdges and
##	EdgesByVertices) we get two inverses and one transitive in one step. The
##	opposing transitive is missing. In comparing both ways to compute it, first
##	transitive and then inverting is shorter than twice inverting and then using
##	the transitive.
InstallMethod( VerticesByFacesAttributeOfSimplicialSurface, 
	[IsSimplicialSurface and HasEdgesByVerticesAttributeOfSimplicialSurface and
								HasFacesByEdgesAttributeOfSimplicialSurface ],
	function( simpsurf )
		if HasFacesByVerticesAttributeOfSimplicialSurface(simpsurf) then
			TryNextMethod();
		else
			FacesByVerticesAttributeOfSimplicialSurface(simpsurf);
			return VerticesByFacesAttributeOfSimplicialSurface( simpsurf );
		fi;
	end
);
InstallMethod( FacesByVerticesAttributeOfSimplicialSurface, 
	[IsSimplicialSurface and HasVerticesByEdgesAttributeOfSimplicialSurface and
								HasEdgesByFacesAttributeOfSimplicialSurface ],
	function( simpsurf )
		if HasVerticesByFacesAttributeOfSimplicialSurface( simpsurf ) then
			TryNextMethod();
		else
			VerticesByFacesAttributeOfSimplicialSurface( simpsurf );
			return FacesByVerticesAttributeOfSimplicialSurface(simpsurf);
		fi;
	end
);
##
##	If the two incidences don't go in the same direction, things become more
##	complicated. Assume FacesByEdges and VerticesByEdges. We get the inverses
##	directly but we are missing FacesByVertices and VerticesByFaces. To get
##	those we first have to invert one of them and then use transitive.
InstallMethod( VerticesByFacesAttributeOfSimplicialSurface, 
	[IsSimplicialSurface and HasFacesByEdgesAttributeOfSimplicialSurface and
							HasVerticesByEdgesAttributeOfSimplicialSurface ],
	function( simpsurf )
		if HasEdgesByFacesAttributeOfSimplicialSurface( simpsurf ) then
			TryNextMethod();
		else
			EdgesByFacesAttributeOfSimplicialSurface( simpsurf );
			return VerticesByFacesAttributeOfSimplicialSurface( simpsurf );
		fi;
	end
);
InstallMethod( FacesByVerticesAttributeOfSimplicialSurface, 
	[IsSimplicialSurface and HasFacesByEdgesAttributeOfSimplicialSurface and
							HasVerticesByEdgesAttributeOfSimplicialSurface ],
	function( simpsurf )
		if HasEdgesByVerticesAttributeOfSimplicialSurface( simpsurf ) then
			TryNextMethod();
		else
			EdgesByVerticesAttributeOfSimplicialSurface( simpsurf );
			return FacesByVerticesAttributeOfSimplicialSurface(simpsurf);
		fi;
	end
);
##	case EdgesByFaces and EdgesByVertices is similar
InstallMethod( VerticesByFacesAttributeOfSimplicialSurface, 
	[IsSimplicialSurface and HasEdgesByFacesAttributeOfSimplicialSurface and
							HasEdgesByVerticesAttributeOfSimplicialSurface ],
	function( simpsurf )
		if HasVerticesByEdgesAttributeOfSimplicialSurface( simpsurf ) then
			TryNextMethod();
		else
			VerticesByEdgesAttributeOfSimplicialSurface( simpsurf );
			return VerticesByFacesAttributeOfSimplicialSurface( simpsurf );
		fi;
	end
);
InstallMethod( FacesByVerticesAttributeOfSimplicialSurface, 
	[IsSimplicialSurface and HasEdgesByFacesAttributeOfSimplicialSurface and
							HasEdgesByVerticesAttributeOfSimplicialSurface ],
	function( simpsurf )
		if HasFacesByEdgesAttributeOfSimplicialSurface( simpsurf ) then
			TryNextMethod();
		else
			FacesByEdgesAttributeOfSimplicialSurface( simpsurf );
			return FacesByVerticesAttributeOfSimplicialSurface(simpsurf);
		fi;
	end
);
##
##							End of *By*-Methods
##
#############################################################################
#############################################################################



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
InstallMethod( EulerCharacteristicAttributeOfSimplicialSurface, 
	"for a simplicial surface", [IsSimplicialSurface ],
	function (simpsurf)
		local chi;

		chi := NrOfVertices(simpsurf)  # V
				- NrOfEdges(simpsurf)     # -E
				+ NrOfFaces(simpsurf);    # +F

		return chi;
	end
);
InstallMethod( EulerCharacteristic, "for a simplicial surface",
	[IsSimplicialSurface],
	function( surf )
		return EulerCharacteristicAttributeOfSimplicialSurface( surf );
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
InstallMethod( UnsortedDegreesAttributeOfSimplicialSurface, 
	"for a simplicial surface",	[IsSimplicialSurface],
	function(simpsurf)
		local verticesByFaces;

		verticesByFaces := VerticesByFaces( simpsurf );
		return List( verticesByFaces, i->Length(i) );
	end
);
InstallMethod( UnsortedDegrees, "for a simplicial surface",
	[IsSimplicialSurface],
	function( simpsurf )
		return UnsortedDegreesAttributeOfSimplicialSurface( simpsurf );
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
InstallMethod( SortedDegreesAttributeOfSimplicialSurface, 
	"for a simplicial surface", [IsSimplicialSurface],
	function(simpsurf)
		local compact;

		compact := Compacted( UnsortedDegrees( simpsurf ) );
		Sort( compact );
		return compact;
	end
 );
InstallMethod( SortedDegrees, "for a simplicial surface",
	[IsSimplicialSurface],
	function( simpsurf )
		return SortedDegreesAttributeOfSimplicialSurface( simpsurf );
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
InstallMethod( VertexSymbolAttributeOfSimplicialSurface, 
	"for a simplicial surface",	[IsSimplicialSurface],
	function(simpsurf)
		local verticesByEdges, vertex, symbol, degree;

		verticesByEdges := VerticesByEdges( simpsurf );
		symbol := [];
		for vertex in Vertices( simpsurf ) do
			degree := Length( verticesByEdges[vertex] );
			if IsBound( symbol[degree] ) then
				symbol[degree] := symbol[degree] + 1;
			else
				symbol[degree] := 1;
			fi;
		od;

		return symbol;
	end
);
InstallMethod( VertexSymbol, "for a simplicial surface",
	[IsSimplicialSurface],
	function( simpsurf )
		return VertexSymbolAttributeOfSimplicialSurface( simpsurf );
	end
);

###############################################################################
##
#!  @Description
#!  This function returns the face-anomaly-classes of a simplicial surface.
#!	Two faces are in the same face-anomaly-class if they contain the same
#!	vertices.
#!  @Returns The face-anomaly-classes (as a list of sets)
#!  @Arguments <simpsurf> a simplicial surface
#!
InstallMethod( FaceAnomalyClassesAttributeOfSimplicialSurface, 
	"for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local facesByVertices, classes, i, found, cl, j;

		facesByVertices := FacesByVertices(simpsurf);
		classes := [];

		for i in [1..NrOfFaces(simpsurf)] do
			found := false;
			for j in [1..Length(classes)] do
				cl := classes[j];
				if Set( facesByVertices[i] ) = Set( facesByVertices[ cl[1] ] ) then
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
InstallMethod( FaceAnomalyClasses, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		return FaceAnomalyClassesAttributeOfSimplicialSurface( simpsurf );
	end
);      

###############################################################################
##
#!  @Description
#!  This function checks whether the simplicial surface is an actual surface.
#!  @Returns true if it is a surface and false else.
#!  @Arguments <simpsurf> a simplicial surface
#!
InstallMethod( IsActualSurface, "for a simplicial surface",
	[IsSimplicialSurface],
	function( simpsurf )
		local face, edgeByFaces, check;

		check := true;
		edgeByFaces := EdgesByFaces( simpsurf );
		check := Filtered( edgeByFaces, i -> Length(i) > 2 );
	
		return IsEmpty(check);
	end
);

#############################################################################
##
#!	@Description
#!	This function checks if a simplicial surface is connected.
#!	@Returns true if connected, false otherwise
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( IsConnected, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local faces, faceList, points, change, faceNr;

		faceList := FacesByVertices(simpsurf);
		faces := Faces(simpsurf){ [2..NrOfFaces(simpsurf)] };	# all except one
		points := Set( faceList[ Faces(simpsurf)[1] ] );	# vertices of the first face

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
	[IsSimplicialSurface and HasConnectedComponentsAttributeOfSimplicialSurface],
	function(simpsurf)
		local components;

		components := ConnectedComponentsAttributeOfSimplicialSurface(simpsurf);
		return Length(components) = 1;
	end
);

###############################################################################
##
#!  @Description
#!  This function decides whether the simplicial surface
#!  <simpsurf> is orientable. To that end it has to be an actual surface.
#!  @Returns true if the surface is orientable and false else.
#!  @Arguments <simpsurf> a simplicial surface
#!
InstallMethod( IsOrientable, "for a simplicial surface",
	[IsSimplicialSurface and IsActualSurface],
	function(simpsurf)
		local edgesByFaces, facesByVertices, orientList, i, hole, edge,
			 facesToCheck, checkedFaces, CompatibleOrientation, orient1,
			 orient2, orientable, face, neighbours, next;

		edgesByFaces := EdgesByFaces(simpsurf);
		facesByVertices := FacesByVertices(simpsurf);

		# Method to check if the orientation of a face is induced by that of
		# one of its edges
		CompatibleOrientation := function( edgeByVertices, facePerm )
			return edgeByVertices[1]^facePerm = edgeByVertices[2];
		end;

		# We use the characterisation from my master thesis in the proof of
		# theorem 4.31 (TODO explain).
		orientable := true;
		orientList := [];
		while Length(orientList) < NrOfFaces(simpsurf) and orientable do
			# Find the first hole
			hole := 0;
			for face in Faces(simpsurf) do
				if not IsBound( orientList[face] ) then
					hole := face;
					break;
				fi;
			od;
	
			# Define the standard orientation of this face as "up"
			orientList[hole] := 1;
			facesToCheck := [hole];
			checkedFaces := [];

			while facesToCheck <> [] and orientable do
				face := facesToCheck[1];
				for edge in FacesByEdges(simpsurf)[face] do
					# This should be unique (inner edge) or empty (border edge)
					neighbours := Difference( edgesByFaces[edge], [face] );
					if Size( neighbours ) > 1 then
						Error( "IsOrientable[generic]: Not a proper surface.");
					elif Size( neighbours ) = 0 then
						continue;
					fi;
					next := neighbours[1];

					orient1 := 0;
					orient2 := 0;
					# Check how these two faces act on the edge
					if CompatibleOrientation( EdgesByVertices(simpsurf)[edge],
									LocalOrientation(simpsurf)[face] ) then
						orient1 := 1;
					else
						orient1 := -1;
					fi;
	
					if CompatibleOrientation( EdgesByVertices(simpsurf)[edge], 
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
		
		return orientable;
	end
);
RedispatchOnCondition( IsOrientable, true, [IsSimplicialSurface],
	[IsActualSurface], 0 );

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
		local subVertices, subEdges, newEdgesByVertices, newFacesByEdges, e, f;

		if not IsSubset( Faces(simpsurf), subfaces ) then
			Error("SubsurfaceByFaces: there are not only faces given.");
		fi;

		return SubsurfaceByFacesNC( simpsurf, subfaces );
	end
);
RedispatchOnCondition( SubsurfaceByFaces, true, [IsSimplicialSurface, IsList],
	[,IsSet], 0);
InstallMethod( SubsurfaceByFacesNC, "for a simplicial surface",
	[IsSimplicialSurface, IsSet],
	function(simpsurf, subfaces)
		local subVertices, subEdges, newEdgesByVertices, newFacesByEdges, e, f;

		subEdges := Union( List( subfaces, f -> FacesByEdges(simpsurf)[f] ));
		subVertices := Union( List( subEdges, e -> EdgesByVertices(simpsurf)[e] ) );

		newEdgesByVertices := [];
		for e in subEdges do
			newEdgesByVertices[e] := EdgesByVertices(simpsurf)[e];
		od;

		newFacesByEdges := [];
		for f in subfaces do
			newFacesByEdges[f] := FacesByEdges(simpsurf)[f];
		od;

		return SimplicialSurfaceByDownwardIncidenceNC( subVertices, subEdges,
			subfaces, newEdgesByVertices, newFacesByEdges );
	end
);
RedispatchOnCondition( SubsurfaceByFacesNC, true, [IsSimplicialSurface, IsList],
	[,IsSet], 0);

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

		faceList := FacesByVertices(simpsurf);
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
		return simpsurf;	# A connected surface has only one connected component
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
#!	@Description
#!	This function removes all ears of the simplicial surface and returns
#!	the resulting surface.
#!	@Arguments a simplicial surface object simpsurf
#!	@Returns a simplicial surface object
InstallMethod( SnippOffEars, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local vertexDegree, ears, newSurface, ear, facesToRemove, 
				remainingFaces;

		# Find ears
		vertexDegree := UnsortedDegrees( simpsurf );
		ears := Filtered( Vertices(simpsurf), i -> vertexDegree[i] <= 1);

		if IsEmpty( ears ) then
			return simpsurf;
		fi;

		facesToRemove := Union( List( ears, i->VerticesByFaces(simpsurf)[i]) );
		remainingFaces := Difference( Faces(simpsurf), facesToRemove );
		newSurface := SubsurfaceByFacesNC( simpsurf, remainingFaces );
	
		return SnippOffEars( newSurface );
	end
);


#############################################################################
##
#!	@Description
#!	Return a list of tuples where at each face-number there is a list with two
#!	entries. The first one is the name of the upper face-side, the second one
#!	the name of the lower face-side (with respect to the local orientation).
#!	All other positions are unbounded.
#!  @Returns a list of lists of integers
#!  @Arguments a simplicial surface object simpsurf
InstallMethod( NamesOfFacesAttributeOfSimplicialSurface,
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
InstallMethod( IncidenceGraphAttributeOfSimplicialSurface, 
	"for a simplicial surface",
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
				return x[2] in EdgesByVertices(simpsurf)[y[2]];
			elif x[1] = 1 and y[1] = 0 then
				return y[2] in EdgesByVertices(simpsurf)[x[2]];

			elif x[1] = 1 and y[1] = 2 then
				return x[2] in FacesByEdges(simpsurf)[y[2]];
			elif x[1] = 2 and y[1] = 1 then
				return y[2] in FacesByEdges(simpsurf)[x[2]];

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
InstallMethod( IncidenceGraph, "for a simplicial surface",
	[IsSimplicialSurface],
	function( simpsurf )
		return IncidenceGraphAttributeOfSimplicialSurface( simpsurf );
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

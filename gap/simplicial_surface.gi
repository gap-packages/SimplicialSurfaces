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
##	implicitly given orientation).
##
_SIMPLICIAL_OrderPreservingFacesByVertices := function( vertices, edges,
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
   	    	Error("_SIMPLICIAL_OrderPreservingFacesByVertices: Edge intersection is not unique.");
		fi;
		vertexList[1] := intersectingEdges[1];

		# Continue in the same way for the other edges
		for j in [2 .. Length(faceEdges)] do
			currentEdge := Set( edgesByVertices[faceEdges[j-1]] );
			nextEdge := Set( edgesByVertices[faceEdges[j]] );
			intersectingEdges := Intersection( currentEdge, nextEdge );
			if Length(intersectingEdges) <> 1 then
  	     		Error("_SIMPLICIAL_OrderPreservingFacesByVertices: Edge intersection is not unique.");
			fi;
			vertexList[j] := intersectingEdges[1];
		od;

		faceList[i] := vertexList;
	od;

	return faceList;
end;

##
##	Next we create a local orientation from such a list
##
_SIMPLICIAL_LocalOrientationFromFacesByVertices := function( facesByVertices )
	local orientation, Shift;

	# local function that shifts each entry of the list to the previous one
	Shift := function( list )
		local newList, i;

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
_SIMPLICIAL_BasicSimplicialSurfaceByDownwardIncidenceNC := function( 
	vertices, edges, faces, edgesByVertices, facesByEdges )
		local facesByVerticesOP, localOrient, surf;

		# Transform if necessary
		if not IsSet( vertices ) then
			vertices := [1..vertices];
		fi;
		if not IsSet( edges ) then
			edges := [1..edges];
		fi;
		if not IsSet( faces ) then
			faces := [1..faces];
		fi;

		facesByVerticesOP := _SIMPLICIAL_OrderPreservingFacesByVertices( 
					vertices, edges, faces, edgesByVertices, facesByEdges );
		localOrient := _SIMPLICIAL_LocalOrientationFromFacesByVertices( 
														facesByVerticesOP );

		surf := Objectify( SimplicialSurfaceType, rec() );
		# Set the given attributes
		SetVertices( surf, vertices );
		SetEdges( surf, edges );
		SetFaces( surf, faces );
		SetEdgesByVertices( surf, edgesByVertices );
		SetFacesByEdges( surf, facesByEdges );
		SetFacesByVertices( surf, List( facesByVerticesOP, i -> Set(i) ) );
		SetLocalOrientation( surf, localOrient );

		return surf;
end;
InstallMethod( SimplicialSurfaceByDownwardIncidenceNC, "",
	[ IsSet or IsPosInt or IsZero, 
	  IsSet or IsPosInt or IsZero,
	  IsSet or IsPosInt or IsZero,
	  IsList,
	  IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		local surf;

		surf := _SIMPLICIAL_BasicSimplicialSurfaceByDownwardIncidenceNC( 
					vertices, edges, faces, edgesByVertices, facesByEdges );

		SetIsFaceNamesDefault( surf, true );

		return surf;
	end
);
InstallOtherMethod( SimplicialSurfaceByDownwardIncidenceNC, "",
	[ IsSet or IsPosInt or IsZero, 
	  IsSet or IsPosInt or IsZero,
	  IsSet or IsPosInt or IsZero,
	  IsList,
	  IsList,
	  IsList ],	# <- this one is additional
	function( vertices, edges, faces, edgesByVertices, facesByEdges, namesOfFaces )
		local surf;

		surf := _SIMPLICIAL_BasicSimplicialSurfaceByDownwardIncidenceNC( 
					vertices, edges, faces, edgesByVertices, facesByEdges );

		SetNamesOfFaces( surf, namesOfFaces );

		return surf;
	end
);
##
##	Next we have to install the same constructors with checks.

_SIMPLICIAL_IsSetPosInt := function( set ) # local method to check if a set consists of positive integers
		local el;
		for el in set do
			if not IsPosInt(el) then
				return false;
			fi;
		od;
		return true;
	end;
_SIMPLICIAL_BasicDownwardIncidenceCheck := function( vertices, edges, faces,
							 edgesByVertices, facesByEdges )
	local e, f;

	# Transform if necessary
	if not IsSet( vertices ) then
		vertices := [1..vertices];
	elif not _SIMPLICIAL_IsSetPosInt( vertices ) then
		Error("DownwardIncidenceCheck: Vertices have to be positive integers.");
	fi;

	if not IsSet( edges ) then
		edges := [1..edges];
	elif not _SIMPLICIAL_IsSetPosInt( edges ) then
		Error("DownwardIncidenceCheck: Edges have to be positive integers.");
	fi;

	if not IsSet( faces ) then
		faces := [1..faces];
	elif not _SIMPLICIAL_IsSetPosInt( faces ) then
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

	# Is facesByEdges well defined?
	for f in faces do
		if not IsBound( facesByEdges[f] ) then
			Error("DownwardIncidenceCheck: One face has no edges.");
		elif Size( Set( facesByEdges[f] ) ) <> 3 then
			Error("DownwardIncidenceCheck: One face has not three edges.");
		elif not IsEmpty( Difference( Set(facesByEdges[f]), vertices ) ) then
			Error("DownwardIncidenceCheck: One face has illegal edge.");
		fi;
	od;
	if Number( facesByEdges ) <> Length( faces ) then
		Error("DownwardIncidenceCheck: More faces than expected.");
	fi;
end;
InstallMethod( SimplicialSurfaceByDownwardIncidence, "",
	[ IsSet or IsPosInt or IsZero, 
	  IsSet or IsPosInt or IsZero,
	  IsSet or IsPosInt or IsZero,
	  IsList,
	  IsList ],
	function( vertices, edges, faces, edgesByVertices, facesByEdges )
		local surf;

		_SIMPLICIAL_BasicDownwardIncidenceCheck( 
					vertices, edges, faces, edgesByVertices, facesByEdges );

		return SimplicialSurfaceByDownwardIncidenceNC( 
					vertices, edges, faces, edgesByVertices, facesByEdges );
	end
);
InstallOtherMethod( SimplicialSurfaceByDownwardIncidence, "",
	[ IsSet or IsPosInt or IsZero, 
	  IsSet or IsPosInt or IsZero,
	  IsSet or IsPosInt or IsZero,
	  IsList,
	  IsList,
	  IsList ],	# <- this one is additional
	function( vertices, edges, faces, edgesByVertices, facesByEdges, namesOfFaces )
		local f;

		_SIMPLICIAL_BasicDownwardIncidenceCheck( 
					vertices, edges, faces, edgesByVertices, facesByEdges );

		# Check the face names
		if not IsSet( faces ) then
			faces := [1..faces];
		fi;
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

		return SimplicialSurfaceByDownwardIncidenceNC( vertices, edges, faces, 
								edgesByVertices, facesByEdges, namesOfFaces );
	end
);
##
##
##
##
##	Now we face the constructor byVerticesInFaces. We start with the NC-versions.
_SIMPLICIAL_BasicSimplicialSurfaceByVerticesInFacesNC := function( 
	vertices, faces, facesByVertices )
		local localOrient, surf, edges, edgesByVertices, facesByEdges, f, j, e;

		# Transform if necessary
		if not IsSet( vertices ) then
			vertices := [1..vertices];
		fi;
		if not IsSet( faces ) then
			faces := [1..faces];
		fi;

		localOrient := _SIMPLICIAL_LocalOrientationFromFacesByVertices( 
														facesByVertices );

		# Determine the edges
		facesBySetEdges := List( faces, i -> 
					Set(Combinations( Set(facesByVertices[i]) ,2)) );
		edgesByVertices := Union(edges);

		facesByEdges := List(faces,i->[]);
		for f in faces do
			for j  in [1..3] do
				e := facesBySetEdges[f][j];
				facesByEdges[f][j] := Position(edgesByVertices,e);
			od;
		od;

		surf := Objectify( SimplicialSurfaceType, rec() );
		# Set the given attributes
		SetVertices( surf, vertices );
		SetEdges( surf, [1..Length(edgesByVertices)] );
		SetFaces( surf, faces );
		SetEdgesByVertices( surf, edgesByVertices );
		SetFacesByEdges( surf, facesByEdges );
		SetFacesByVertices( surf, List( facesByVertices, i -> Set(i) ) );
		SetLocalOrientation( surf, localOrient );

		return surf;
end;
InstallMethod( SimplicialSurfaceByVerticesInFacesNC, "",
	[ IsSet or IsPosInt or IsZero, 
	  IsSet or IsPosInt or IsZero, 
	  IsList ],
	function( vertices, faces, facesByVertices )
		local surf;

		surf := _SIMPLICIAL_BasicSimplicialSurfaceByVerticesInFacesNC( 
					vertices, faces, facesByVertices );

		SetIsFaceNamesDefault( surf, true );

		return surf;
	end
);
InstallOtherMethod( SimplicialSurfaceByVerticesInFacesNC, "",
	[ IsSet or IsPosInt or IsZero, 
	  IsSet or IsPosInt or IsZero, 
	  IsList,
	  IsList ],	# <- this one is additional
	function( vertices, faces, facesByVertices, namesOfFaces )
		local surf;

		surf := _SIMPLICIAL_BasicSimplicialSurfaceByVerticesInFacesNC( 
					vertices, faces, facesByVertices );

		SetNamesOfFaces( surf, namesOfFaces );

		return surf;
	end
);
##
##	Of course the same constructors with sanity checks can't be missing.
##
_SIMPLICIAL_BasicVerticesInFacesCheck := function( vertices, faces,
							 facesByVertices )
	local f;

	# Transform if necessary
	if not IsSet( vertices ) then
		vertices := [1..vertices];
	elif not _SIMPLICIAL_IsSetPosInt( vertices ) then
		Error("VerticesInFacesCheck: Vertices have to be positive integers.");
	fi;

	if not IsSet( faces ) then
		faces := [1..faces];
	elif not _SIMPLICIAL_IsSetPosInt( faces ) then
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
end;
InstallMethod( SimplicialSurfaceByVerticesInFaces, "",
	[ IsSet or IsPosInt or IsZero, 
	  IsSet or IsPosInt or IsZero, 
	  IsList ],
	function( vertices, faces, facesByVertices )
		local surf;

		_SIMPLICIAL_BasicVerticesInFacesCheck( 
					vertices, faces, facesByVertices );

		return SimplicialSurfaceByVerticesInFacesNC( 
					vertices, faces, facesByVertices );
	end
);
InstallOtherMethod( SimplicialSurfaceByVerticesInFaces, "",
	[ IsSet or IsPosInt or IsZero, 
	  IsSet or IsPosInt or IsZero, 
	  IsList,
	  IsList ],	# <- this one is additional
	function( vertices, faces, facesByVertices, namesOfFaces )
		local f;

		_SIMPLICIAL_BasicVerticesInFacesCheck( 
					vertices, faces, facesByVertices );

		# Check the face names
		if not IsSet( faces ) then
			faces := [1..faces];
		fi;
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

		return SimplicialSurfaceByVerticesInFacesNC( vertices, faces, 
								facesByVertices, namesOfFaces );
	end
);
##
##							End of constructors
##
#############################################################################
#############################################################################



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
InstallMethod( NrOfEdges, "for a simplicial surface",
	[ IsSimplicialSurface ],
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
InstallMethod( NrOfFaces, "for a simplicial surface",
	[ IsSimplicialSurface ],
	function(simpsurf)
		return Length( Faces(simpsurf) );
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
##	There are exactly four cases in which we know every information from
##	two of those values:
##		FacesByEdges and EdgesByVertices
##		FacesByEdges and VerticesByEdges
##		EdgesByFaces and EdgesByVertices
##		EdgesByFaces and VerticesByEdges
##	We will start with an inversion and a transitivity method. These two are
##	sufficient to generate every other combination in at most two steps. Since
##	GAP can't do more than one step, we have to help it a bit at the end...
##
##
##	At first we implement the inversion of an incidence relation. For example
##	we know facesByEdges but want to know edgesByFaces. As this inversion is
##	always the same we implement it in general.
##	Given are the numbers of edges and faces, together with the relation
##	facesByEdges. It returns the relation edgesByFaces. (The names are used
##	only for illustration.)
_SIMPLICIAL_InvertIncidence := function( faceNr, facesByEdges, edgeNr )
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
InstallMethod( VerticesByEdges, [IsSimplicialSurface and HasEdgesByVertices ],
	function( simpsurf )
		return _SIMPLICIAL_InvertIncidence( Edges(simpsurf),
				EdgesByVertices(simpsurf), Vertices(simpsurf) );
	end
);
InstallMethod( VerticesByFaces, [IsSimplicialSurface and HasFacesByVertices ],
	function( simpsurf )
		return _SIMPLICIAL_InvertIncidence( Faces(simpsurf),
				FacesByVertices(simpsurf), Vertices(simpsurf) );
	end
);
InstallMethod( EdgesByVertices, [IsSimplicialSurface and HasVerticesByEdges ],
	function( simpsurf )
		return _SIMPLICIAL_InvertIncidence( Vertices(simpsurf),
				VerticesByEdges(simpsurf), Edges(simpsurf) );
	end
);
InstallMethod( EdgesByFaces, [IsSimplicialSurface and HasFacesByEdges ],
	function( simpsurf )
		return _SIMPLICIAL_InvertIncidence( Faces(simpsurf),
				FacesByEdges(simpsurf), Edges(simpsurf) );
	end
);
InstallMethod( FacesByVertices, [IsSimplicialSurface and HasVerticesByFaces ],
	function( simpsurf )
		return _SIMPLICIAL_InvertIncidence( Vertices(simpsurf),
				VerticesByFaces(simpsurf), Faces(simpsurf) );
	end
);
InstallMethod( FacesByEdges, [IsSimplicialSurface and HasEdgesByFaces ],
	function( simpsurf )
		return _SIMPLICIAL_InvertIncidence( Edges(simpsurf),
				EdgesByFaces(simpsurf), Faces(simpsurf) );
	end
);
##
##	Next we consider the case of transitivity: From FacesByEdges and 
##	EdgesByVertices we can deduce FacesByVertices
_SIMPLICIAL_TransitiveIncidence := function( faceNr, facesByEdges, edgeNr,
												edgesByVertices, vertexNr )
	local face, facesByVertices, edgesInFace, verticesInEdges;

	facesByVertices := [];
	for face in faceNr do
		edgesInFace := facesByEdges[face];
		verticesInEdges := List( edgesInFace, e -> edgesByVertices[e] );
		faceByVertices[face] := Union( verticesInEdges );
	od;

	return facesByVertices;
end;
##
InstallMethod( FacesByVertices, [IsSimplicialSurface and HasFacesByEdges and
										HasEdgesByVertices ],
	function( simpsurf )
		return _SIMPLICIAL_TransitiveIncidence( Faces(simpsurf),
			FacesByEdges(simpsurf), Edges(simpsurf),
			EdgesByVertices(simpsurf), Vertices(simpsurf) );
	end
);
InstallMethod( VerticesByFaces, [IsSimplicialSurface and HasVerticesByEdges and
										HasEdgesByFaces ],
	function( simpsurf )
		return _SIMPLICIAL_TransitiveIncidence( Vertices(simpsurf),
			VerticesByEdges(simpsurf), Edges(simpsurf),
			EdgesByFaces(simpsurf), Faces(simpsurf) );
	end
);
##
##	Normally we would be finished at this point. But the method selection of
##	GAP is not so intelligent to check for attributes transitively (it only
##	checks if an attribute is set, not if it could be set). It would have been
##	nice if this could be done by RedispatchOnCondition (see 78.5-1) but this
##	option only works for properties. Since Has* is false if the attribute *
##	is not computed, we can't use it (theoretically we could introduce an
##	additional property for "possible existence of this attribute" but that
##	gets even more involved). Therefore we will just brute force all remaining
##	possibilites.
##	Important Note: Since we change the filters we must not use TryNextMethod()
##	since doing so would not take this change into account.
##
##	If both incidences go in the same direction (e.g. FacesByEdges and
##	EdgesByVertices) we get two inverses and one transitive in one step. The
##	opposing transitive is missing. In comparing both ways to compute it, first
##	transitive and then inverting is shorter than twise inverting and then using
##	the transitive.
InstallMethod( VerticesByFaces, [IsSimplicialSurface and HasEdgesByVertices and
											HasFacesByEdges ],
	function( simpsurf )
		FacesByVertices(simpsurf);
		return VerticesByFaces( simpsurf );
	end
);
InstallMethod( FacesByVertices, [IsSimplicialSurface and HasVerticesByEdges and
											HasEdgesByFaces ],
	function( simpsurf )
		VerticesByFaces( simpsurf );
		return FacesByVertices(simpsurf);
	end
);
##
##	If the two incidences don't go in the same direction, things become more
##	complicated. Assume FacesByEdges and VerticesByEdges. We get the inverses
##	directly but we are missing FacesByVertices and VerticesByFaces. To get
##	those we first have to invert one of them and then use transitive.
InstallMethod( VerticesByFaces, [IsSimplicialSurface and HasFacesByEdges and
											HasVerticesByEdges ],
	function( simpsurf )
		EdgesByFaces( simpsurf );
		return VerticesByFaces( simpsurf );
	end
);
InstallMethod( FacesByVertices, [IsSimplicialSurface and HasFacesByEdges and
											HasVerticesByEdges ],
	function( simpsurf )
		EdgesByVertices( simpsurf );
		return FacesByVertices(simpsurf);
	end
);
##	case EdgesByFaces and EdgesByVertices is similar
InstallMethod( VerticesByFaces, [IsSimplicialSurface and HasEdgesByFaces and
											HasEdgesByVertices ],
	function( simpsurf )
		VerticesByEdges( simpsurf );
		return VerticesByFaces( simpsurf );
	end
);
InstallMethod( FacesByVertices, [IsSimplicialSurface and HasEdgesByFaces and
											HasEdgesByVertices ],
	function( simpsurf )
		FacesByEdges( simpsurf );
		return FacesByVertices(simpsurf);
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
#!	This function returns a list of integers (with holes). For each vertex-
#!	number it contains the number of faces which are incident to that vertex
#!	(the degree of the vertex).
#!  @Returns a list of integers
#!  @Arguments a simplicial surface object simpsurf
#!
InstallMethod( UnsortedDegrees, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local verticesByFaces;

		verticesByFaces := VerticesByFaces( simpsurf );
		return List( verticesByFaces, i->Length(i) );
	end
);

#############################################################################
##
#!  @Description
#!	This function returns a dense sorted list of integers that contains the 
#!	degrees of the vertices (with repetitions)
#!  @Returns a dense sorted list of integers
#!  @Arguments a simplicial surface object simpsurf
#!
InstallMethod( SortedDegrees, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local compact;

		compact := Compacted( UnsortedDegrees( simpsurf ) );
		Sort( compact );
		return compact;
	end;
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
InstallMethod( FaceAnomalyClasses, "for a simplicial surface",
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
	end;
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
				if not isBound( orientList[face] ) then
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
					if CompatibleOrientation( EdgesByVertices(simpsurf)[edge], LocalOrientation(simpsurf)[face] ) then
						orient1 := 1;
					else
						orient1 := -1;
					fi;
	
					if CompatibleOrientation( EdgesByVertices(simpsurf)[edge], LocalOrientation(simpsurf)[next] ) then
						orient2 := 1;
					else
						orient2 := -1;
					fi;
	
					# The next two cases can be collapsed (the elements in orientList take
					# values in {+1,-1}). TODO do so without destroying readability
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
	[IsSimplicialSurface and HasConnectedComponents, IsPosInt],
	function(simpsurf, f)
		local conCom, comp;

		conCom := ConnectedComponents(simpsurf);
		for comp in conCom do
			if f in Faces(comp) then
				return comp;
			fi;
		od;
		Error("ConnectedComponentOfFace: Internal error in ConnectedComponents.");
	end
);
InstallMethod( ConnectedComponentOfFace, "for a simplicial surface",
	[IsSimplicialSurface and HasConnectedComponents, IsPosInt],
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
InstallMethod( ConnectedComponents, "for a simplicial surface",
	[IsSimplicialSurface],
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
		local vertexDegree, ears, newSurface, ear;

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
#!	as the name of one of its sided.
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
#!	as the name of one of its sided.
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

		graph1 := IncidenceGraph(s1);
		graph2 := IncidenceGraph(s2);
		return IsIsomorphicGraph(graph1,graph2);
	end
);


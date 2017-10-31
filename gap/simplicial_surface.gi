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
                        "IsPathConnected",
                        "PathConnectedComponents",
			"EulerCharacteristic",
			"UnsortedDegrees",
			"SortedDegrees",
			"VertexCounter",
			"FaceEdgePathsOfVertices",
			"LocalOrientationByVerticesAsPerm",
			"LocalOrientationByVerticesAsList",
			"LocalOrientationByEdgesAsPerm",
			"LocalOrientationByEdgesAsList",
			"NamesOfFaces",
			"IsFaceNamesDefault",
			"FaceAnomalyClasses",
                        "EdgeAnomalyClasses",
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
	
	local e, f, IncidentEdges, edgeList, i, verticesOfFaces, errorString,
            errorStream;

        # Initialise the error states
        errorString := "DownwardIncidenceCheck: ";

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
                    errorStream := OutputTextString( errorString, true );
                    PrintTo( errorStream, "Edge ", e, " has no vertices.");
                    CloseStream(errorStream);
                    Error(errorString);
		elif Size( Set( verticesOfEdges[e] ) ) <> 2 then
                    errorStream := OutputTextString( errorString, true );
                    PrintTo( errorStream, "Edge ", e, " has ", 
                            Size(Set(verticesOfEdges[e])), 
                            " vertices instead of two.");
                    CloseStream(errorStream);
                    Error(errorString);
		elif not IsEmpty( Difference( Set(verticesOfEdges[e]), vertices ) ) then
                    errorStream := OutputTextString( errorString, true );
                    PrintTo( errorStream, "Edge ", e, " has illegal vertices ",
                            Difference( Set(verticesOfEdges[e], vertices)) );
                    CloseStream(errorStream);
                    Error(errorString);
		fi;
	od;
			# Number only counts bound entries
	if Number( verticesOfEdges ) <> Length( edges ) then 
	    errorStream := OutputTextString( errorString, true );
            PrintTo( errorStream, "VerticesOfEdges has ", 
                    Number(verticesOfEdges), 
                    " bound entries, but there are only ", Length(edges),
                    " edges." );
            CloseStream(errorStream);
            Error(errorString);
	fi;
	if Union( verticesOfEdges ) <> vertices then
		errorStream := OutputTextString( errorString, true );
                PrintTo( errorStream, "The vertices ", 
                        Difference(vertices, Union(verticesOfEdges)),
                        " don't lie in any edge." );
                CloseStream(errorStream);
                Error(errorString);
	fi;

	# Is edgesOfFaces well defined?
	for f in faces do
		if not IsBound( edgesOfFaces[f] ) then
		    errorStream := OutputTextString( errorString, true );
                    PrintTo( errorStream, "Face ", f, " has no edges" );
                    CloseStream(errorStream);
                    Error(errorString);
		elif Size( Set( edgesOfFaces[f] ) ) < 3 then
		    errorStream := OutputTextString( errorString, true );
                    PrintTo( errorStream, "Face ", f, " has only ",
                            Size(Set(edgesOfFaces[f])), 
                            " edges (Minimum three)" );
                    CloseStream(errorStream);
                    Error(errorString);
		elif not IsEmpty( Difference( Set(edgesOfFaces[f]), edges ) ) then
		    errorStream := OutputTextString( errorString, true );
                    PrintTo( errorStream, "Face ", f, " has illegal edges ",
                            Difference( edges, Set(edgesOfFaces[f])) );
                    CloseStream(errorStream);
                    Error(errorString);
		fi;
	od;
	if Number( edgesOfFaces ) <> Length( faces ) then
	    errorStream := OutputTextString( errorString, true );
            PrintTo( errorStream, "EdgesOfFaces has ", Number(edgesOfFaces),
                    " bound entries, but there are only ", Length(faces),
                    " faces.");
            CloseStream(errorStream);
            Error(errorString);
	fi;
	if Union( edgesOfFaces ) <> edges then
	    errorStream := OutputTextString( errorString, true );
            PrintTo( errorStream, "The edges ", 
                    Difference(edges, Union(edgesOfFaces) ), 
                    " don't lie in any face." );
            CloseStream(errorStream);
            Error(errorString);
	fi;

        # Check whether verticesOfEdges and edgesOfFaces are compatible
        verticesOfFaces := __SIMPLICIAL_TransitiveIncidence( faces, 
                        edgesOfFaces, edges, verticesOfEdges, vertices );
        for f in faces do
            if Length(edgesOfFaces[f]) <> Length(verticesOfFaces[f]) then
                errorStream := OutputTextString( errorString, true );
                PrintTo( errorStream, "Face ", f, " has the ", 
                        Length(edgesOfFaces[f]), " edges ", edgesOfFaces[f],
                        " and the ", Length(verticesOfFaces[f]), " vertices ",
                        verticesOfFaces[f], 
                        ", but there should be as many edges as vertices.");
                CloseStream(errorStream);
                Error(errorString);
            fi;
        od;

	# Special check for the orientation preserving constructor
	if edgesAdjacent then
		IncidentEdges := function( verticesOfEdges, edge1, edge2 )
			local vert1, vert2, inter;

			vert1 := verticesOfEdges[edge1];
			vert2 := verticesOfEdges[edge2];
			inter := Intersection( vert1, vert2 );
		
			if Length(inter) <> 1 then
	        	    errorStream := OutputTextString( errorString, true );
                            PrintTo( errorStream, "The edges ", edge1, " and ",
                            edge2, 
                            " are adjacent in an entry of EdgesOfFaces but do not share a vertex." );
                            CloseStream(errorStream);
                            Error(errorString);
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
			    errorStream := OutputTextString( errorString, true );
                            PrintTo( errorStream, "Face ", f, " has no names.");
                            CloseStream(errorStream);
                            Error(errorString);
			elif Size( Set( namesOfFaces[f] ) ) <> 2 then
			    errorStream := OutputTextString( errorString, true );
                            PrintTo( errorStream, "Face ", f,
                                    " should have two different names.");
                            CloseStream(errorStream);
                            Error(errorString);
			elif not IsInt(namesOfFaces[f][1]) 
					or not IsInt(namesOfFaces[f][2]) then
			    errorStream := OutputTextString( errorString, true );
                            PrintTo( errorStream, "Face ", f, 
                                    " has non-integer names ", 
                                    namesOfFaces[f] );
                            CloseStream(errorStream);
                            Error(errorString);
			fi;
		od;
		if Number( namesOfFaces ) <> Length( faces ) then
		    errorStream := OutputTextString( errorString, true );
                    PrintTo( errorStream, "There are ", Number(namesOfFaces),
                            " names for faces but there are ", Length(faces),
                            " faces given.");
                    CloseStream(errorStream);
                    Error(errorString);
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
#TODO make error messages readable	
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

                #TODO (4,4, [[1,2,3], [2,3,4], [2,3,4], [1,2,4]]) does not throw an error;
			
		facesBySetEdges := List( faces, i -> 
							AdjacentVertices( verticesOfFaces[i] ) );
		verticesOfEdges := Union(facesBySetEdges);

		edgesOfFaces := List(faces,i->[]);
		for f in faces do
			for j  in [1..Size(facesBySetEdges[f])] do
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
#############################
##  Add this point we define the example constructors

InstallMethod( Janushead, "", [], function()
    return SimplicialSurfaceByVerticesInFaces( 3, 2, 
            [ [1,2,3], [1,2,3] ] );
    end
);

InstallMethod( Tetrahedron, "", [], function()
    return SimplicialSurfaceByVerticesInFaces(4,4,
            [[1,2,3],[1,2,4],[2,3,4],[1,3,4]] );
    end
);

InstallMethod( Cube, "", [], function()
    return SimplicialSurfaceByVerticesInFaces( 8, 6,
        [ [1,2,3,4],[2,3,7,6],[1,2,6,5],[1,4,8,5],[3,4,8,7],[5,6,7,8] ] );
    end
);

InstallMethod( Octahedron, "", [], function()
    return SimplicialSurfaceByVerticesInFaces(6,8,
        [ [1,2,3],[1,3,4],[1,4,5],[1,2,5],[2,3,6],[3,4,6],[4,5,6],[2,5,6] ] );
    end
);

InstallMethod( Dodecahedron, "", [], function()
    return SimplicialSurfaceByVerticesInFaces( 20,12,
        [ [1,2,3,4,5],[1,6,7,8,2],[2,3,10,9,8],[3,4,12,11,10],
        [4,5,14,13,12],[1,6,15,14,5],[6,7,16,20,15],[17,9,8,7,16],
        [17,9,10,11,18],[11,12,13,19,18],[19,13,14,15,20],[16,17,18,19,20] ] );
    end
);

InstallMethod( Icosahedron, "", [], function()
    return  SimplicialSurfaceByVerticesInFaces(12,20,
		[ 	[1,2,3], [1,2,4], [1,4,5], [1,5,6],
			[1,3,6], [2,3,7], [2,4,8], [4,9,5],
			[5,6,10], [3,6,11], [2,7,8], [4,8,9],
			[5,9,10], [6,10,11], [3,11,7], [7,8,12],
			[8,9,12], [9,10,12], [10,11,12], [7,11,12]
		] );
    end
);


##
##							End of constructors
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

        if listOfPerms = fail then
            return fail;
        fi;

	listOfLists := [];
	for i in indexSet do
		points := MovedPoints( listOfPerms[i] );

		# Since points is a set, the first element is the smallest
		listRep := [ points[1] ];

		for j in [1..Length(points)-1] do
			Append( listRep, [ listRep[j]^listOfPerms[i] ] );
		od;

            listOfLists[i] := listRep;
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

        if listOfLists = fail then
            return fail;
        fi;

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

        if listOfLists = fail then
            return fail;
        fi;

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
#!  Return the vertex counter of a simplicial surface.
#!	The vertex counter is a list, where the i-th entry counts the number of 
#!	vertices that are incident to exactly i edges. If there are no such
#!	vertices the entry is unbounded.
#!  @Arguments a simplicial surface object simpsurf
#!  @Returns a list of integers
#!
InstallMethod( VertexCounter, "for a simplicial surface", [IsSimplicialSurface],
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

##
##  Alternative computation of the vertex counter if we already know the edge
##  counter. Usually this will result in fewer checks.
InstallMethod( VertexCounter, 
    "for a simplicial surface with known edge counter",
    [ IsSimplicialSurface and HasEdgeCounter ],
    function( surf )
        local symbol, i, j, edgeCounter, sum;

        symbol := [];
        edgeCounter := EdgeCounter(surf);
        for i in [1..Size(edgeCounter)] do
            sum := edgeCounter[i][i];   # This is counted twice
            for j in [1..Size(edgeCounter)] do
                sum := sum + edgeCounter[i][j];
            od;
            sum := sum/i;
            if sum <> 0 then
                symbol[i] := sum;
            fi;
        od;

        return symbol;
    end
);

#!
#!  @Description
#!  Return the edge counter of a simplicial surface. The edge counter is a
#!  symmetric matrix M such that M[i,j] counts the number of edges such that
#!  the two vertices of the edge have edge-degrees i and j.
#!  @Arguments simpSurf
#!  @Returns a matrix of integers
InstallMethod( EdgeCounter, "for a simplicial surface", [IsSimplicialSurface],
   function(simpSurf)
        local edgeDegrees, max, edge, symbol, degs;

        edgeDegrees := List( EdgesOfVertices(simpSurf), Size );
        if NrOfEdges(simpSurf) = 0 then
            return [];
        fi;
        max := Maximum( edgeDegrees ); # bigger than zero since edges exist

        # Set up the matrix
        symbol := List( [1..max], i -> List( [1..max], j -> 0 ) );
        for edge in Edges(simpSurf) do
            degs := List( VerticesOfEdges(simpSurf)[edge], v -> edgeDegrees[v] );
            symbol[ degs[1] ][ degs[2] ] := symbol[degs[1]][degs[2]] + 1;
            if degs[1] <> degs[2] then
                symbol[ degs[2] ][ degs[1] ] := symbol[degs[2]][degs[1]] + 1;
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
#!  @Description
#!  This function returns the edge-anomaly-classes of a simplicial surface.
#!	Two edges are in the same edge-anomaly-class if they contain the same
#!	vertices.
#!  @Returns The edge-anomaly-classes (as a list of sets)
#!  @Arguments <simpsurf> a simplicial surface
#!
InstallMethod( EdgeAnomalyClasses, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local verticesOfEdges, classes, i, found, cl, j;

		verticesOfEdges := VerticesOfEdges(simpsurf);
		classes := [];

		for i in Edges(simpsurf) do
			found := false;
			for j in [1..Length(classes)] do
				cl := classes[j];
				if Set( verticesOfEdges[i] ) 
							= Set( verticesOfEdges[ cl[1] ] ) then
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

InstallMethod( IsAnomalyFree, "for a simplicial surface",
        [IsSimplicialSurface],
        function( simpsurf )
            return Size( FaceAnomalyClasses(simpsurf) ) = NrOfFaces(simpsurf) 
                and Size( EdgeAnomalyClasses(simpsurf) ) = NrOfEdges(simpsurf);
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

InstallMethod( InnerEdges, "for a simplicial surface",
        [IsSimplicialSurface], 
    function( simpsurf )
        return Filtered( Edges(simpsurf), e -> 
                    Size( FacesOfEdges(simpsurf)[e]  ) = 2 );
    end
);
InstallMethod( IsInnerEdge, "for a simplicial surface",
    [IsSimplicialSurface, IsPosInt],
    function(surf, edge)
        return edge in InnerEdges(surf);
    end
);

InstallMethod( BoundaryEdges, "for a simplicial surface",
        [IsSimplicialSurface], 
    function( simpsurf )
        return Filtered( Edges(simpsurf), e -> 
                    Size( FacesOfEdges(simpsurf)[e]  ) < 2 );
    end
);
InstallMethod( IsBoundaryEdge, "", [IsSimplicialSurface, IsPosInt],
    function(surf, edge)
        return edge in BoundaryEdges(surf);
    end
);

InstallMethod( RamifiedEdges, "for a simplicial surface",
        [IsSimplicialSurface], 
    function( simpsurf )
        return Filtered( Edges(simpsurf), e -> 
                    Size( FacesOfEdges(simpsurf)[e]  ) > 2 );
    end
);
InstallMethod( IsRamifiedEdge, "", [IsSimplicialSurface, IsPosInt],
    function(surf, edge)
        return edge in RamifiedEdges(surf);
    end
);



##
## Given a set of elements (natural numbers) and a list of components
## (indexed by the elements) return the connected component of the
## element start.
BindGlobal( "__SIMPLICIAL_AbstractConnectedComponent", 
    function( elements, compOfElements, start )
        local change, component, internals, el;

        # The component contains start
        component := [ start ];
        # Modify the elements to remove everything that is added already
        elements := Difference( elements, component );
        # Save a set of internal components (by which the elements are connected)
        internals := compOfElements[start];

        change := true;
        while change do
            change := false;

            for el in elements do
                if Intersection( internals, compOfElements[el] ) <> [] then
                    change := true;
                    internals := Union( internals, compOfElements[el] );
                    elements := Difference( elements, [el] );
                    component := Union( component, [el] );
                fi;
            od;
        od;

        return component;
    end
);

#############################################################################
##
#!	@Description
#!	This function checks if a simplicial surface is connected.
#!	@Returns true if connected, false otherwise
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( IsConnected, "for a simplicial surface", [IsSimplicialSurface],
	function(simpsurf)
		local component;

                if NrOfFaces(simpsurf) = 0 then
                    return true;
                fi;
		# In this function we check the connectivity by working with the
		# vertices. We start with the vertices of the first face and add all
		# faces that share a vertex with one of these. By iterating this
		# we construct all faces in the connected component of the first face.
		# For the implementation we start with the list of all faces and
		# remove those that lie in the connected component.

                component := __SIMPLICIAL_AbstractConnectedComponent( 
                        Faces(simpsurf), VerticesOfFaces(simpsurf), 
                        Faces(simpsurf)[1] );
                return Size( component ) = NrOfFaces(simpsurf);
	end
);
InstallImmediateMethod( IsConnected, IsSimplicialSurface and 
        HasConnectedComponentsAttributeOfSimplicialSurface, 0, 
	function(simpsurf)
		local components;

		components := ConnectedComponentsAttributeOfSimplicialSurface(simpsurf);
		return Length(components) <= 1;
	end
);

InstallMethod( IsPathConnected, "for a simplicial surface", [IsSimplicialSurface],
	function(simpsurf)
		local component;

                if NrOfFaces(simpsurf) = 0 then
                    return true;
                fi;
		# In this function we check the connectivity by working with the
		# edges. We start with the edges of the first face and add all
		# faces that share an edge with one of these. By iterating this
		# we construct all faces in the connected component of the first face.
		# For the implementation we start with the list of all faces and
		# remove those that lie in the connected component.

                component := __SIMPLICIAL_AbstractConnectedComponent( 
                        Faces(simpsurf), EdgesOfFaces(simpsurf), 
                        Faces(simpsurf)[1] );
                return Size( component ) = NrOfFaces(simpsurf);
	end
);
InstallImmediateMethod( IsPathConnected, IsSimplicialSurface and 
        HasPathConnectedComponents, 0, 
	function(simpsurf)
		local components;

		components := PathConnectedComponents(simpsurf);
		return Length(components) <= 1;
	end
);

InstallImmediateMethod( IsPathConnected, IsSimplicialSurface and 
    HasConnectedComponentsAttributeOfSimplicialSurface, 0,
    function(surf)
        local components;

        components := ConnectedComponentsAttributeOfSimplicialSurface(surf);
        if Length(components) > 1 then
            return false;
        fi;
        TryNextMethod();
    end
);

InstallImmediateMethod( IsPathConnected, 
    IsSimplicialSurface and HasIsConnected, 0,
    function(surf)
        if not IsConnected(surf) then
            return false;
        fi;
        TryNextMethod();
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
                local comp, subsurf;

                comp := __SIMPLICIAL_AbstractConnectedComponent(
                    Faces(simpsurf), VerticesOfFaces(simpsurf), f );

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

InstallMethod( PathConnectedComponentOfFaceNC, "for a simplicial surface",
	[IsSimplicialSurface, IsPosInt],
	function(simpsurf, f)
                local comp, subsurf;

                comp := __SIMPLICIAL_AbstractConnectedComponent(
                    Faces(simpsurf), EdgesOfFaces(simpsurf), f );

		subsurf := SubsurfaceByFacesNC( simpsurf, comp);
		# this component is connected by construction, so we set the property
		SetIsConnected( subsurf, true );
		return subsurf;
	end
);
InstallMethod( PathConnectedComponentOfFaceNC, "for a simplicial surface",
	[IsSimplicialSurface and IsPathConnected, IsPosInt],
	function(simpsurf, f)
		return simpsurf; # A connected surface has only one connected component
	end
);
InstallMethod( PathConnectedComponentOfFace, "for a simplicial surface",
	[IsSimplicialSurface, IsPosInt],
	function(simpsurf, f)
		local faceList, faces, points, comp, change, faceNr, subsurf;

		if not f in Faces(simpsurf) then
			Error("PathConnectedComponentOfFace: Given face doesn't lie in surface.");
		fi;

		return PathConnectedComponentOfFaceNC( simpsurf, f);
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


InstallMethod( PathConnectedComponentOfFaceNC, "for a simplicial surface",
	[IsSimplicialSurface and HasPathConnectedComponents, IsPosInt],
	function(simpsurf, f)
		local conCom, comp;

		conCom := PathConnectedComponents(simpsurf);
		for comp in conCom do
			if f in Faces(comp) then
				return comp;
			fi;
		od;
		Error("PathConnectedComponentOfFace: Internal error in PathConnectedComponents.");
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
                        component := ConnectedComponentOfFace(simpsurf, f);
			Append( comp, [component] );
			faces := Difference( faces, Faces(component) );
		od;

		return comp;
	end
);
InstallImmediateMethod( ConnectedComponentsAttributeOfSimplicialSurface,
        IsSimplicialSurface and IsConnected, 0, 
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

InstallMethod( PathConnectedComponents,
	"for a simplicial surface", [IsSimplicialSurface],
	function(simpsurf)
		local faces, comp, f, component;

		faces := Faces(simpsurf);
		comp := [ ];
		while not IsEmpty(faces) do
			f := faces[1];
                        component := PathConnectedComponentOfFace(simpsurf,f);
			Append( comp, [component] );
			faces := Difference( faces, Faces(component) );
		od;

		return comp;
	end
);
InstallImmediateMethod( PathConnectedComponents,
        IsSimplicialSurface and IsPathConnected, 0, 
	function(simpsurf)
		return [simpsurf];
	end
);



##
## After implementing connectivity and path connectivity for themselves, we
## also want to work with the connection between them. We start with the
## direction "path-connected"->"connected"
InstallImmediateMethod( IsConnected, IsSimplicialSurface and
    HasPathConnectedComponents, 0,
    function( simpsurf )
        local components;

        components := PathConnectedComponents(simpsurf);
        if Length(components) <= 1 then
            return true;
        fi;

        # If there is more than one path-connected component, the structure
        # might still be connected.
        TryNextMethod();
    end
);

InstallMethod( ConnectedComponentsAttributeOfSimplicialSurface,
    "for a simplicial surface with path-connected components",
    [IsSimplicialSurface and HasPathConnectedComponents ],
    function( surf )
        local pathComponents, components, vertList, check, newComponent,
            currentVert, done, i;

        pathComponents := PathConnectedComponents(surf);
        components := [];
        if pathComponents = [] then
            return [];
        fi;

        vertList := List( pathComponents, Vertices );

        check := [1..Size(pathComponents)];
        while not IsEmpty(check) do
            newComponent := [ check[1] ];
            currentVert := vertList[ check[1] ];
            done := false;
            while not done do
                done := true;
                for i in Difference( check, newComponent ) do
                    if not IsEmpty( Intersection( currentVert, vertList[i] ) ) then
                        Add(newComponent, i );
                        check := Difference( check, [i] );
                        currentVert := Union( currentVert, vertList[i] );
                        done := false;
                    fi;
                od;
            od;
            Add( components, SubsurfaceByFacesNC( surf, 
                Union( List( newComponent, i-> Faces( pathComponents[i] ) ) ) ) );
        od;

        return components;
    end
);

InstallMethod( PathConnectedComponents, 
    "for a simplicial surface with connected components",
    [ IsSimplicialSurface and HasConnectedComponentsAttributeOfSimplicialSurface ],
    function( surf )
        local comp, pathComp, s;

        comp := ConnectedComponentsAttributeOfSimplicialSurface(surf);

        # If we only have one component, this method offers no benefit
        if Length(comp) = 1 then
            TryNextMethod();
        fi;

        pathComp := [];
        for s in comp do
            Append( pathComp, PathConnectedComponents( s ) );
        od;

        return pathComp;
    end
);

## For actual surfaces the connected and path-connected components are
## identical. 
InstallMethod( ConnectedComponentsAttributeOfSimplicialSurface,
    "for an actual surface with path-connected components",
    [IsSimplicialSurface and IsActualSurface and HasPathConnectedComponents ],
    function(surf)
        return PathConnectedComponents(surf);
    end
);
InstallMethod( PathConnectedComponents, 
    "for an actual surface with connected components",
    [IsSimplicialSurface and IsActualSurface and 
        HasConnectedComponentsAttributeOfSimplicialSurface ],
    function(surf)
        return ConnectedComponentsAttributeOfSimplicialSurface(surf);
    end
);
InstallImmediateMethod( PathConnectedComponents,
    IsSimplicialSurface and IsActualSurface and IsConnected, 0, 
    function(surf)
        return [surf];
    end
);
#TODO for actual surfaces two attributes are identical. Can we somehow encode
# this to save space (also in general)?


###############################################################################
###############################################################################
##
##      Start of the orientation-block
##

###############################################################################
##
##  Compute the orientation of a surface (if it has one).
##
BindGlobal( "__SIMPLICIAL_ConstructStandardGlobalOrientation", 
    function( simpsurf )
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
            return orientList;
        fi;
        return fail;
    end
);

##
## Write the wrapper function
##
InstallMethod( GlobalOrientation, "for a simplicial surface",
        [ IsSimplicialSurface and IsEdgesLikeSurface ],
        function( surf )
            return GlobalOrientationByVerticesAsPerm(surf);
        end
);
    RedispatchOnCondition( GlobalOrientation, true, [IsSimplicialSurface],
        [IsEdgesLikeSurface], 0 );

##
## Write all other functions
##

##############################
##
##  VerticesAsPerm
##
InstallMethod( GlobalOrientationByVerticesAsPerm, "for a simplicial surface",
        [ IsSimplicialSurface and IsEdgesLikeSurface ],
        function( surf )
            return ComputeProperty( SIMPLICIAL_METHOD_SELECTION_GRAPH,
                        GlobalOrientationByVerticesAsPerm, surf );
        end
);
    RedispatchOnCondition( GlobalOrientationByVerticesAsPerm, true,
        [IsSimplicialSurface], [IsEdgesLikeSurface], 0 );
InstallMethod( GlobalOrientationByVerticesAsPerm, "for a simplicial surface",
        [IsSimplicialSurface and IsEdgesLikeSurface and HasGlobalOrientationByVerticesAsList ],
        function( surf )
            return __SIMPLICIAL_TranslateListsIntoCycles(
                GlobalOrientationByVerticesAsList(surf) );
        end
);
AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
    "GlobalOrientationByVerticesAsPerm", "GlobalOrientationByVerticesAsList" );


################################
##
##  VerticesAsList
##
InstallMethod( GlobalOrientationByVerticesAsList, "for a simplicial surface",
        [ IsSimplicialSurface and IsEdgesLikeSurface ],
        function( surf )
            return ComputeProperty( SIMPLICIAL_METHOD_SELECTION_GRAPH,
                        GlobalOrientationByVerticesAsList, surf );
        end
);
    RedispatchOnCondition( GlobalOrientationByVerticesAsList, true,
        [IsSimplicialSurface], [IsEdgesLikeSurface], 0 );

InstallMethod( GlobalOrientationByVerticesAsList, "for a simplicial surface",
        [IsSimplicialSurface and IsEdgesLikeSurface and HasGlobalOrientationByVerticesAsPerm ],
        function( surf )
            return __SIMPLICIAL_TranslateCyclesIntoLists(
                GlobalOrientationByVerticesAsPerm(surf), Faces(surf) );
        end
);
AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
    "GlobalOrientationByVerticesAsList", "GlobalOrientationByVerticesAsPerm" );

InstallMethod( GlobalOrientationByVerticesAsList, "for a simplicial surface",
    [ IsSimplicialSurface and IsEdgesLikeSurface and HasGlobalOrientationByEdgesAsList ],
    function( surf )
        return __SIMPLICIAL_ConversionLocalOrientationVerticesEdges(
            GlobalOrientationByEdgesAsList(surf),
            Faces(surf),
            VerticesOfEdges(surf),
            VerticesOfFaces(surf) );
    end
);
AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH,
    "GlobalOrientationByVerticesAsList", 
    ["GlobalOrientationByEdgesAsList", "VerticesOfEdges", "VerticesOfFaces"] );

InstallMethod( GlobalOrientationByVerticesAsList, "for a simplicial surface",
    [ IsSimplicialSurface and IsEdgesLikeSurface and HasFacesOfEdges and
        HasVerticesOfFaces and HasEdgesOfFaces and HasVerticesOfEdges and
        HasLocalOrientationByVerticesAsPerm and HasLocalOrientationByVerticesAsList ],
    function( surf )
        local globalOr, FindGlobalOrientation, orAsList, f;

        if NrOfFaces(surf) = 0 then
            return [];
        fi;

        globalOr := __SIMPLICIAL_ConstructStandardGlobalOrientation( surf );
        if globalOr <> fail then
            FindGlobalOrientation := function( face )
                if not face in Faces(surf) then
                    return;
                fi;

                # Positive orientation means no switch
                if globalOr[face] = 1 then
                    return LocalOrientationByVerticesAsList( surf )[face];
                elif globalOr[face] = -1 then
                    return Reversed( LocalOrientationByVerticesAsList( surf )[face] );
                else
                    Error("GlobalOrientationByVertices: FindGlobalOrientation: This should not have happened.");
                fi;
            end;
            orAsList := [];
            for f in [1..Maximum(Faces(surf))] do
                if f in Faces(surf) then
                    orAsList[f] := FindGlobalOrientation(f);
                fi;
            od;
            return orAsList;
        fi;
        return fail;
    end
);
AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH,
    "GlobalOrientationByVerticesAsList",
    ["FacesOfEdges", "VerticesOfFaces", "EdgesOfFaces", "VerticesOfEdges",
        "LocalOrientationByVerticesAsPerm", "LocalOrientationByVerticesAsList"] );

##############################
##
##  EdgesAsPerm
##
InstallMethod( GlobalOrientationByEdgesAsPerm, "for a simplicial surface",
        [ IsSimplicialSurface and IsEdgesLikeSurface ],
        function( surf )
            return ComputeProperty( SIMPLICIAL_METHOD_SELECTION_GRAPH,
                        GlobalOrientationByEdgesAsPerm, surf );
        end
);
    RedispatchOnCondition( GlobalOrientationByEdgesAsPerm, true,
        [IsSimplicialSurface], [IsEdgesLikeSurface], 0 );
InstallMethod( GlobalOrientationByEdgesAsPerm, "for a simplicial surface",
        [IsSimplicialSurface and IsEdgesLikeSurface and HasGlobalOrientationByEdgesAsList ],
        function( surf )
            return __SIMPLICIAL_TranslateListsIntoCycles(
                GlobalOrientationByEdgesAsList(surf) );
        end
);
AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
    "GlobalOrientationByEdgesAsPerm", "GlobalOrientationByEdgesAsList" );


################################
##
##  EdgesAsList
##
InstallMethod( GlobalOrientationByEdgesAsList, "for a simplicial surface",
        [ IsSimplicialSurface and IsEdgesLikeSurface ],
        function( surf )
            return ComputeProperty( SIMPLICIAL_METHOD_SELECTION_GRAPH,
                        GlobalOrientationByEdgesAsList, surf );
        end
);
    RedispatchOnCondition( GlobalOrientationByEdgesAsList, true,
        [IsSimplicialSurface], [IsEdgesLikeSurface], 0 );

InstallMethod( GlobalOrientationByEdgesAsList, "for a simplicial surface",
        [IsSimplicialSurface and IsEdgesLikeSurface and HasGlobalOrientationByEdgesAsPerm ],
        function( surf )
            return __SIMPLICIAL_TranslateCyclesIntoLists(
                GlobalOrientationByEdgesAsPerm(surf), Faces(surf) );
        end
);
AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
    "GlobalOrientationByEdgesAsList", "GlobalOrientationByEdgesAsPerm" );

InstallMethod( GlobalOrientationByEdgesAsList, "for a simplicial surface",
    [ IsSimplicialSurface and IsEdgesLikeSurface and HasGlobalOrientationByVerticesAsList ],
    function( surf )
        return __SIMPLICIAL_ConversionLocalOrientationVerticesEdges(
            GlobalOrientationByVerticesAsList(surf),
            Faces(surf),
            EdgesOfVertices(surf),
            EdgesOfFaces(surf) );
    end
);
AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH,
    "GlobalOrientationByEdgesAsList", 
    ["GlobalOrientationByVerticesAsList", "EdgesOfVertices", "EdgesOfFaces"] );



##
## Special case if the orientability is known
##
InstallMethod( GlobalOrientationByVerticesAsList, "for a simplicial surface", 
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
        [IsSimplicialSurface and HasGlobalOrientationByVerticesAsList],
        function(surf)
            return GlobalOrientationByVerticesAsList(surf) <> fail;
        end
);

## If we can't compute IsOrientable any other way, we try computing a global
## orientation first
InstallMethod( IsOrientable, "for a simplicial surface",
        [IsSimplicialSurface and IsEdgesLikeSurface ],
        function(surf)
            if HasGlobalOrientationByVerticesAsList(surf) then
                TryNextMethod();
            fi;
            GlobalOrientationByVerticesAsList(surf);
            return IsOrientable(surf);
        end
);
RedispatchOnCondition( IsOrientable, true, 
    [IsSimplicialSurface], [IsEdgesLikeSurface], 0 );

##
##      End of the orientation block
##
###############################################################################
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

#TODO this is a method for the incidence geometry - no connection to local orientation
InstallMethod( AddVertexIntoEdge,
    "for a simplicial surface and an edge that is incident to exactly two faces.",
    [IsSimplicialSurface, IsPosInt],
    function( surf, edge )
        local oldVertices, v1,v2,v3,v4, oldFaces, f1,f2, newEdgesOfFaces, V, 
            newVerticesOfEdges, maxEdge, maxFaces;

        # Picture
        #             v3
        #            /  \
        #           / f1 \
        #          v1----v2
        #           \ f2 /
        #            \  /
        #             v4
        oldVertices := VerticesOfEdges(surf)[edge]; # [v1,v2]
        v1 := oldVertices[1];
        v2 := oldVertices[2];

        oldFaces := FacesOfEdges(surf)[edge]; # [f1,f2]
        if Size(oldFaces) <> 2 then
            Error("The edge has to be an inner edge.");
        fi;
        f1 := oldFaces[1];
        f2 := oldFaces[2];

        # find the other two vertices that are incident to the two faces but
        # not to the edge
        v3 := Difference( VerticesOfFaces(surf)[f1], oldVertices )[1];
        v4 := Difference( VerticesOfFaces(surf)[f2], oldVertices )[1];


        # We modify the picture to become
        #
        #                v3
        #              /  |  \
        #             /   |   \
        #            /   e+3   \
        #           / f+1 | f+2 \
        #          /      |      \
        #         v1-e+1--V-e+2---v2
        #          \      |      /
        #           \ f+3 | f+4 /
        #            \   e+4   /
        #             \   |   /
        #              \  |  /
        #                v4
        V := Maximum(Vertices(surf)) + 1;
        newVerticesOfEdges := ShallowCopy( VerticesOfEdges(surf) );
        Unbind( newVerticesOfEdges[edge] );
        maxEdge := Maximum( Edges(surf) );
        newVerticesOfEdges[maxEdge+1] := [v1,V];
        newVerticesOfEdges[maxEdge+2] := [V,v2];
        newVerticesOfEdges[maxEdge+3] := [v3,V];
        newVerticesOfEdges[maxEdge+4] := [V,v4];

        newEdgesOfFaces := ShallowCopy( EdgesOfFaces(surf) );
        Unbind( newEdgesOfFaces[f1] );
        Unbind( newEdgesOfFaces[f2] );
        maxFaces := Maximum(Faces(surf));
        newEdgesOfFaces[maxFaces+1] := 
            [ maxEdge+1, maxEdge+3, EdgeInFaceByVertices(surf, f1, [v1,v3]) ]; 
        newEdgesOfFaces[maxFaces+2] :=
            [ maxEdge+2, maxEdge+3, EdgeInFaceByVertices(surf, f1, [v2,v3]) ];
        newEdgesOfFaces[maxFaces+3] := 
            [ maxEdge+1, maxEdge+4, EdgeInFaceByVertices(surf, f2, [v1,v4]) ];
        newEdgesOfFaces[maxFaces+4] :=
            [ maxEdge+2, maxEdge+4, EdgeInFaceByVertices(surf, f2, [v2,v4]) ];

        return SimplicialSurfaceByDownwardIncidence( 
            Union( [V], Vertices(surf) ),
            Union( List([1,2,3,4],i->maxEdge+i), Difference(Edges(surf),[edge]) ),
            Union( List([1,2,3,4],i->maxFaces+i), Difference(Faces(surf),[f1,f2]) ),
            newVerticesOfEdges,
            newEdgesOfFaces );
    end
);


InstallMethod( EdgeInFaceByVertices, 
    "for a simplicial surface, a face and a list of two vertices",
    [IsSimplicialSurface, IsPosInt, IsList],
    function( surf, face, vertList )
        local possEdges;

        possEdges := Filtered( EdgesOfFaces(surf)[face], e -> 
                VerticesOfEdges(surf)[e] = Set(vertList) );
        if Size(possEdges) = 0 then
            Error("EdgeInFaceByVertices: No such edge exists.");
        elif Size(possEdges) > 1 then
            Error("EdgeInFaceByVertices: Internal error.");
        fi;
        return possEdges[1];
    end
);


InstallMethod( OtherEdgeOfVertexInFaceNC,
    "for a simplicial surface, a vertex, an edge and a face",
    [IsSimplicialSurface, IsPosInt, IsPosInt, IsPosInt],
    function( surf, vertex, edge, face )
        local possEdges, res;

        possEdges := EdgesOfFaces(surf)[face];
        res := Filtered( possEdges, e -> vertex in VerticesOfEdges(surf)[e] and e <> edge );
        return res[1];
    end
);
InstallMethod( OtherEdgeOfVertexInFace,
    "for a simplicial surface, a vertex, an edge and a face",
    [IsSimplicialSurface, IsPosInt, IsPosInt, IsPosInt],
    function( surf, vertex, edge, face )
        #TODO maybe write a separate method for these checks?
        if not vertex in Vertices(surf) then
            Error("Given vertex does not lie in the given surface.");
        fi;
        if not edge in Edges(surf) then
            Error("Given edge does not lie in the given surface.");
        fi;
        if not face in Faces(surf) then
            Error("Given face does not lie in the given surface.");
        fi;

        if not vertex in VerticesOfEdges(surf)[edge] then
            Error("Given vertex is not incident to given edge.");
        fi;
        if not edge in EdgesOfFaces(surf)[face] then
            Error("Given edge is not incident to given face.");
        fi;
        return OtherEdgeOfVertexInFaceNC(surf, vertex, edge, face);
    end
);


InstallMethod( NeighbourFaceByEdgeNC,
    "for a simplicial surface (edges like surface), a face and an edge",
    [IsSimplicialSurface and IsEdgesLikeSurface, IsPosInt, IsPosInt],
    function(surf, face, edge)
        local possFaces;

        possFaces := FacesOfEdges(surf)[edge];
        if face = possFaces[1] then
            return possFaces[2];
        elif face = possFaces[2] then
            return possFaces[1];
        else
            Error("Given edge is not incident to given face.");
        fi;
    end
);
    RedispatchOnCondition( NeighbourFaceByEdgeNC, true,
        [IsSimplicialSurface, IsPosInt, IsPosInt],
        [IsEdgesLikeSurface,,],0);
InstallMethod( NeighbourFaceByEdge,
    "for a simplicial surface (edges like surface), a face and an edge",
    [IsSimplicialSurface and IsEdgesLikeSurface, IsPosInt, IsPosInt],
    function(surf, face, edge)
        if not edge in Edges(surf) then
            Error("Given edge does not lie in surface.");
        fi;
        if not face in Faces(surf) then
            Error("Given face does not lie in surface.");
        fi;
        return NeighbourFaceByEdgeNC(surf,face, edge);
    end
);
    RedispatchOnCondition( NeighbourFaceByEdge, true,
        [IsSimplicialSurface, IsPosInt, IsPosInt],
        [IsEdgesLikeSurface,,],0);


InstallMethod( OtherVertexOfEdgeNC,
    "for a simplicial surface, a vertex and an edge",
    [IsSimplicialSurface, IsPosInt, IsPosInt],
    function(surf, vertex, edge)
        local possVert;
        
        possVert := VerticesOfEdges(surf)[edge];
        if vertex = possVert[1] then
            return possVert[2];
        elif vertex = possVert[2] then
            return possVert[1];
        else
            Error("Given vertex is not incident to given edge.");
        fi;
    end
);
InstallMethod( OtherVertexOfEdge,
    "for a simplicial surface, a vertex and an edge",
    [IsSimplicialSurface, IsPosInt, IsPosInt],
    function(surf,vertex, edge)
        if not vertex in Vertices(surf) then
            Error("Given vertex does not lie in surface.");
        fi;
        if not edge in Edges(surf) then
            Error("Given edge does not lie in surface.");
        fi;

        return OtherVertexOfEdgeNC(surf,vertex,edge);
    end
);



InstallMethod( AlternativeNames, "for a simplicial surface",
    [IsSimplicialSurface],
    function(simpSurf)
        return rec();
    end
);

InstallMethod( CommonCover, 
    "for two simplicial surfaces and mr-types of edges",
    [IsSimplicialSurface and IsEdgesLikeSurface and IsTriangleSurface,
    IsSimplicialSurface and IsEdgesLikeSurface and IsTriangleSurface,
    IsList, IsList],
    function( surf1, surf2, mrType1, mrType2 )
        local facePairs, newFaces, pair, vert1, vert2, allImages,
            TauByMR, taus1, taus2, tau1, tau2, e, e1, e2, vertOfE2,
            vertexBaseSet, vertexBasePositionsByFace, facePos,
            newFace, foundPairs, adjacencyList, AdjacentFace,
            edgePair, adFace1, adFace2, otherIso, bothFaces, otherFace,  
            found, j, baseVertPos1, baseVertPos2, baseVertA1, baseVertA2,
            baseVertB1, baseVertB2, vertOfEdge,
            vertexGraph, connComp, edgeDescription, i, edge, 
            surface, altNames, simpFaces, simpEdges, simpVertices,
            simpVerticesOfEdges, simpFacesOfEdges;

        # The new faces are given by all isomorphisms between faces
        # of the original two surfaces
        # We encode those as 
        # [first face, second face, bijection between first and second vertices]
        # The first vertices are ordered, the second vertices are arbitrary
        facePairs := Cartesian(Faces(surf1),Faces(surf2));
        newFaces := [];
        for pair in facePairs do
            vert1 := VerticesOfFaces(surf1)[pair[1]];
            vert2 := VerticesOfFaces(surf2)[pair[2]];
            allImages := Arrangements(vert2, Size(vert2));
            Append( newFaces, List(allImages, im -> 
                [pair[1], pair[2], GeneralMappingByElements( 
                    Domain(vert1), 
                    Domain(vert2),
                    List([1,2,3], i-> DirectProductElement([vert1[i],im[i]]))
                    # we only have triangular faces
                )]
            ));
        od;

        # We will now proceed this way:
        # 1) Define the set from which the vertices will be derived
        # 2) Iterate over all edge combinations (and construct adjacent faces)
        #   2.1) Those define the new edges
        #   2.2) They define the incidence to the faces
        #   2.3) They define the equivalence between vertices

        # Before we do this we need to define the maps tau that mirror or
        # rotate the vertices of a face along an edge (as given in the mrtype)
        TauByMR := function( surf, edge, mr )
            local vertsOfEdge, adjacentFaces, thirdVertices;

            vertsOfEdge := VerticesOfEdges(surf)[edge];
            adjacentFaces := FacesOfEdges(surf)[edge];
            thirdVertices := Difference( Union( List(adjacentFaces, 
                f -> VerticesOfFaces(surf)[f]) ), vertsOfEdge );

            if mr = 1 then # mirror
                if Size(thirdVertices) = 1 then
                    return ();
                else
                    return (thirdVertices[1],thirdVertices[2]);
                fi;
            elif mr = 2 then # rotation
                if Size(thirdVertices) = 1 then
                    return (vertsOfEdge[1],vertsOfEdge[2]);
                else
                    return (vertsOfEdge[1],vertsOfEdge[2])(thirdVertices[1],thirdVertices[2]);
                fi;
            else
                Error("CommonCover: Given MRType not complete.");
            fi;
        end;
        taus1 := [];
        for e in Edges(surf1) do
            taus1[e] := TauByMR(surf1, e, mrType1[e]);            
        od;
        taus2 := [];
        for e in Edges(surf2) do
            taus2[e] := TauByMR(surf2, e, mrType2[e]);
        od;

        # 1) 
        # The equivalence relation is defined on the set of pairs
        # [newFace, vertex], where the vertex is a vertex of the first
        # surface and lies in the face of the first surface that is 
        # defined by the newFace.
        vertexBaseSet := [];
        vertexBasePositionsByFace := [];
        for facePos in [1..Size(newFaces)] do
            vertexBasePositionsByFace[facePos] := 
                [Size(vertexBaseSet)+1..Size(vertexBaseSet)+3];
            newFace := newFaces[facePos];
            Append(vertexBaseSet, List(VerticesOfFaces(surf1)[newFace[1]], 
                v -> [facePos,v] ));
        od;


        # We will need a helper function to compute the adjacent face to
        # a given face. If the face is on the boundary, it will be returned.
        # Otherwise its neighbour will be returned.
        # TODO make this into a separate method for IsEdgesLikeSurface
        AdjacentFace := function( surf, face, edge )
            local allFaces;

            allFaces := FacesOfEdges(surf)[edge];
            if Size(allFaces) = 1 then
                return allFaces[1];
            else
                return Difference(allFaces, [face])[1];
            fi;
        end;
        
        # 2)
        # We iterate over the new edges. We represent a new edge as
        # [first edge, second edge, {adjacent new faces} ]
        # Since not all of those combinations are valid, we calculate
        # the adjacent face manually by using the tau-mappings:
        # If tau1 is the  mr-transfer of the first edge and tau2 is the 
        # mr-transfer of the second edge, we have
        # tau2 \circ iso1 = iso2 \circ tau1
        foundPairs := [];
        adjacencyList := [];    # List of adjacencies for the digraph package
        for facePos in [1..Size(newFaces)] do
            newFace := newFaces[facePos];
            # Consider all pairs of possible edges
            for e1 in EdgesOfFaces(surf1)[newFace[1]] do
                # Find the partner edge
                vertOfE2 := List( VerticesOfEdges(surf1)[e1], 
                        v -> Image(newFace[3],v) );
                e2 := EdgeInFaceByVertices(surf2, newFace[2], vertOfE2);
                edgePair := [e1,e2];

                # We need to find the adjacent faces
                adFace1 := AdjacentFace(surf1, newFace[1], edgePair[1]);
                adFace2 := AdjacentFace(surf2, newFace[2], edgePair[2]);
                # Define tau2 and tau1^(-1)
                tau2 := MappingByFunction( Range(newFace[3]), 
                    Domain(VerticesOfFaces(surf2)[adFace2]),
                    function(x) return x^taus2[edgePair[2]]; end );
                tau1 := MappingByFunction( 
                    Domain(VerticesOfFaces(surf1)[adFace1]),
                    Source( newFace[3] ), 
                    function(x) return x^taus1[edgePair[1]]; end );
                # Now we can compute the composition mapping
                otherIso := CompositionMapping( tau2, newFace[3], tau1);
                otherFace := [adFace1, adFace2, otherIso];
                bothFaces := Set( [newFace, otherFace] );

                # Check whether we already found this combination
                found := false;
                for j in [1..Size(foundPairs)] do
                    if edgePair = foundPairs[j][1] and 
                                bothFaces = foundPairs[j][2] then
                        foundPairs[j][3] := Union( foundPairs[j][3], [facePos] );
                        found := true;
                        break;
                    fi;
                od;
                if not found then
                    # We have to add this pair. At this point we also calculate
                    # the vertices.

                    # Compute the pairs of equivalent vertices
                    baseVertPos1 := vertexBasePositionsByFace[facePos];
                    baseVertPos2 := vertexBasePositionsByFace[
                            Position(newFaces, otherFace)];

                    vertOfEdge := VerticesOfEdges(surf1)[edgePair[1]];
                    # Localize the vertices on the common edge
                    baseVertA1 := Filtered( baseVertPos1, p ->
                        vertexBaseSet[p][2] = vertOfEdge[1])[1];
                    baseVertA2 := Filtered( baseVertPos2, p ->
                        vertexBaseSet[p][2] = vertOfEdge[1])[1];
                
                    baseVertB1 := Filtered( baseVertPos1, p ->
                        vertexBaseSet[p][2] = vertOfEdge[2])[1];
                    baseVertB2 := Filtered( baseVertPos2, p ->
                        vertexBaseSet[p][2] = vertOfEdge[2])[1];


                    # Since the isomorphism already connects the faces with
                    # respect to their mr-type, the vertices just have to care
                    # about what is happening on one simplicial surface

                    # The situation for the first surface is:
                    #       baseVertA1 . baseVertA2
                    #                / | \
                    #               /  |  \
                    #              . F1|F2 .
                    #               \  |  /
                    #                \ | /
                    #       baseVertB1 . baseVertB2

                    # Since the vertices of the two surfaces are connected by
                    # their isomorphism, we only work with the vertices of one
                    # surface. But it is easier to imagine that we work with the
                    # pair of vertices in the common cover (instead of a single
                    # vertex in one surface).

                    # If we have an mm or rr-edge-pair, A1 and A2 are identified
                    # Otherwise A1 and B2 are identified.
                    if IsOddInt( mrType1[edgePair[1]] + mrType2[edgePair[2]] ) then
                        # The inverted case
                        Append( adjacencyList,
                            [[baseVertA1,baseVertB2], [baseVertB1, baseVertA2]]);
                    else
                        Append( adjacencyList, 
                            [[baseVertA1, baseVertA2], [baseVertB1, baseVertB2]]);
                    fi;
                    
                    # Finally we add the pair to our list
                    Add(foundPairs, [edgePair, bothFaces, [facePos], 
                        [baseVertA1, baseVertA2, baseVertB1, baseVertB2]]);
                fi;
                #TODO can this be implemented more efficiently?

            od;
        od;

        # Now we have to compute the true vertices by finding the connected
        # components of the graph that we defined with out adjacencyList.
        vertexGraph := DigraphByEdges(adjacencyList);
        connComp := DigraphConnectedComponents(vertexGraph);

        # Now we translate all this information into a simplicial surface.
        # Simultaneously we define the alternative names.
        altNames := rec();

        # Faces
        simpFaces := [1..Size(newFaces)];
        altNames.Faces := List(newFaces, f -> [[f[1],f[2]], 
            [Elements(Source(f[3])), List(Elements(Source(f[3])),
                                e->Image(f[3],e))]]);
        altNames.DescriptionFaces := 
            "[[old face 1, old face 2], bijection of vertices by elements]";

        # Edges and FacesOfEdges and VerticesOfEdges from foundPairs
        simpEdges := [1..Size(foundPairs)];
        altNames.DescriptionEdges := 
            "[ [old edge 1, old edge 2], set of adjacent new faces (as numbers) ]";
        edgeDescription := [];
        simpFacesOfEdges := [];
        simpVerticesOfEdges := [];
        for i in [1..Size(foundPairs)] do
            edge := foundPairs[i];
            edgeDescription[i] := [edge[1],edge[3]];
            simpFacesOfEdges[i] := edge[3];
            simpVerticesOfEdges[i] := Set( List(edge[4], v -> connComp.id[v]) );
        od;
        altNames.Edges := edgeDescription;

        # Vertices from connComp
        simpVertices := [1..Size(connComp.comps)];
        altNames.Vertices := List(connComp.comps, cc ->
            List( cc, pos -> vertexBaseSet[pos] ) );
        altNames.DescriptionVertices :=
            "list of equivalence classes of [new face (as number), old vertex]-pairs";

        # Construct the new simplicial surface
        surface := Objectify( SimplicialSurfaceType, rec() );
        SetVerticesAttributeOfSimplicialSurface(surface, simpVertices);
        SetEdges(surface, simpEdges);
        SetFaces(surface, simpFaces);
        SetFacesOfEdges(surface, simpFacesOfEdges);
        SetVerticesOfEdges(surface, simpVerticesOfEdges);
        SetAlternativeNames(surface, rec( commonCover := altNames) );
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(surface);

        return surface;
    end
);
    RedispatchOnCondition( CommonCover, true, 
	[IsSimplicialSurface, IsSimplicialSurface, IsList, IsList], 
        [IsTriangleSurface and IsEdgesLikeSurface, 
            IsTriangleSurface and IsEdgesLikeSurface,,], 0);


InstallOtherMethod( MaximalStripEmbedding, "",
    [IsSimplicialSurface and IsEdgesLikeSurface and IsTriangleSurface,
        IsPosInt, IsPosInt],
    function( surf, vertex, face )
        local edges;

        if not vertex in Vertices(surf) then
            Error("Given vertex is not a vertex of the surface.");
        fi;
        if not face in Faces(surf) then
            Error("Given face is not a face of the surface.");
        fi;

        edges := Intersection( EdgesOfFaces(surf)[face], EdgesOfVertices(surf)[vertex] );

        if IsEmpty(edges) then
            Error("Given vertex and face have no edge between them.");
        fi;

        return MaximalStripEmbedding(surf, vertex, edges[1], face);
    end
);
    RedispatchOnCondition( MaximalStripEmbedding, true,
        [IsSimplicialSurface, IsPosInt, IsPosInt],
        [IsTriangleSurface and IsEdgesLikeSurface,,], 0);

InstallMethod( MaximalStripEmbedding, "", 
    [IsSimplicialSurface and IsEdgesLikeSurface and IsTriangleSurface, 
        IsPosInt, IsPosInt, IsPosInt],
    function( surf, vertex, edge, face )
        local path, len, neighbour, pivotVert, newBorderEdge, 
            traversedFaces, reversed;

        if not vertex in Vertices(surf) then
            Error("Given vertex is not a vertex of the surface.");
        fi;
        if not edge in Edges(surf) then
            Error("Given edge is not an edge of the surface.");
        fi;
        if not face in Faces(surf) then
            Error("Given face is not a face of the surface.");
        fi;

        if not vertex in VerticesOfEdges(surf)[edge] then
            Error("Given vertex does not lie in given edge.");
        fi;
        if not edge in EdgesOfFaces(surf)[face] then
            Error("Given edge does not lie in given face.");
        fi;

        # Idea:
        # Construct the edge-face-path in the variable path
        # Extend the right-hand-side until it goes no further
        # Then extend the left-hand-side

        # Initialize the system
        path := [ OtherEdgeOfVertexInFaceNC(surf, vertex, edge, face), face, edge ];
        traversedFaces := [face];
        pivotVert := vertex;

        reversed := false; # Used for the direction of the extension
        while( true ) do
            # Try to extend the path
            len := Size(path);
            neighbour := NeighbourFaceByEdgeNC(surf, path[len-1], path[len]);
            if neighbour in traversedFaces or neighbour = fail then
                if reversed then
                    break;
                else
                    reversed := true;
                    path := Reversed(path);
                    pivotVert := vertex; # Reset to original vertex
                    continue;
                fi;
            fi;

            pivotVert := OtherVertexOfEdgeNC(surf, pivotVert, path[len]);
            newBorderEdge := OtherEdgeOfVertexInFaceNC(surf,pivotVert,path[len],neighbour);
            Append( path, [neighbour, newBorderEdge] );
            Add( traversedFaces, neighbour );
        od;

        # We have to invert the path at the end (so it is oriented properly)
        path := Reversed(path);

        return [path, SubsurfaceByFacesNC(surf, Set(traversedFaces))];
    end
);
    RedispatchOnCondition( MaximalStripEmbedding, true,
        [IsSimplicialSurface, IsPosInt, IsPosInt, IsPosInt],
        [IsTriangleSurface and IsEdgesLikeSurface,,,], 0);

InstallMethod( Geodesic,
    "for a simplicial surface, a vertex, an edge and a face",
    [IsSimplicialSurface and IsTriangleSurface and IsEdgesLikeSurface,
    IsPosInt, IsPosInt, IsPosInt],
    function(surf,vertex,edge,face)
        local path, len, neighbour, pivotVert, newBorderEdge, other, 
            traversedFaces, reversed, minpos, permList, invPermList, swapList;
            #TODO copy of code above (with modifications) -> unify?

        if not vertex in Vertices(surf) then
            Error("Given vertex is not a vertex of the surface.");
        fi;
        if not edge in Edges(surf) then
            Error("Given edge is not an edge of the surface.");
        fi;
        if not face in Faces(surf) then
            Error("Given face is not a face of the surface.");
        fi;

        if not vertex in VerticesOfEdges(surf)[edge] then
            Error("Given vertex does not lie in given edge.");
        fi;
        if not edge in EdgesOfFaces(surf)[face] then
            Error("Given edge does not lie in given face.");
        fi;

        # Idea:
        # Construct the edge-face-path in the variable path
        # Extend the right-hand-side until it meets up again
        # or stops at a boundary. In that case reverse course.

        # Initialize the system
        other := OtherEdgeOfVertexInFaceNC(surf, vertex, edge, face);
        path := [ other, face, edge ];
        traversedFaces := [face];
        pivotVert := vertex;

        invPermList := [ Position(AllFlags(surf), [vertex,edge,face]) ];
        permList := [ Position(AllFlags(surf), [vertex,other,face]) ];

        # minpos[1] is the position of the edge of the minimal face
        # minpos[2] is the direction +1 means go right
        if path[1] < path[3] then 
            minpos := [3,-1]; 
        else 
            minpos := [1,1]; 
        fi;

        reversed := false; # Used for the direction of the extension
        while( true ) do
            # Try to extend the path
            len := Size(path);
            neighbour := NeighbourFaceByEdgeNC(surf, path[len-1], path[len]);
            pivotVert := OtherVertexOfEdgeNC(surf, pivotVert, path[len]);
            if neighbour <> fail then
                newBorderEdge := OtherEdgeOfVertexInFaceNC(
                                 surf,pivotVert,path[len],neighbour);
            fi;


            if neighbour <> fail then
                if neighbour < path[minpos[1]+minpos[2]] then
                    if path[len] < newBorderEdge then
                        minpos := [ len+2, -1 ];
                    else
                        minpos := [ len, 1 ];
                    fi;
                elif neighbour = path[minpos[1]+minpos[2]] then
                    if path[len] < newBorderEdge then
                        if path[len] < path[minpos[1]+2*minpos[2]] then
                            minpos := [len+2,-1];
                        elif path[len] = path[minpos[1]+2*minpos[2]] then
                            if newBorderEdge < path[minpos[1]] then
                                minpos := [len+2,-1];
                            fi;
                        fi;
                    else
                        if newBorderEdge < path[minpos[1]+2*minpos[2]] then
                            minpos := [len,1];
                        elif newBorderEdge = path[minpos[1]+2*minpos[2]] then
                            if path[len] < path[minpos[1]] then
                                minpos := [len,1];
                            fi;
                        fi;
                    fi;
                fi;
            fi;
            

            if neighbour = fail then
                if reversed then
                    path := Reversed(path);
                    permList := Reversed(permList);
                    invPermList := Reversed( invPermList );
                    swapList := invPermList;
                    invPermList := permList;
                    permList := swapList;
                    break;
                else
                    reversed := true;
                    path := Reversed(path);
                    permList := Reversed(permList);
                    invPermList := Reversed(invPermList);
                    swapList := invPermList;
                    invPermList := permList;
                    permList := swapList;
                    pivotVert := vertex; # Reset to original vertex
                    continue;
                fi;
            elif path[len] = path[1] and neighbour = path[2] and newBorderEdge = path[3] then
                # finished
                break;
            elif Size(path) > 6*NrOfFaces(surf) then
                Error("Geodesic: Inconsistent surface input.");
            fi;

            Append( path, [neighbour, newBorderEdge] );
            Add( traversedFaces, neighbour );
            invPermList := Concatenation( [Position(AllFlags(surf), [pivotVert, newBorderEdge, neighbour])], invPermList );
            Add(permList, Position(AllFlags(surf), [pivotVert, path[len], neighbour ] ) );
        od;

        # minimise the geodesic
        if reversed then
            # the path is not closed
            if path[2] < path[Length(path)-1] then
                #continue;
            elif path[2] > path[Length(path)-1] then
                path := Reversed(path);
            elif  path[3] < path[Length(path)-2] then
                #continue;
            elif  path[3] > path[Length(path)-2] then
                path := Reversed(path);
            elif path[1] > path[Length(path)] then
                path := Reversed(path);
            fi;
        else
            # the path is closed
            if minpos[2] = 1 then
               path := Concatenation(path{[minpos[1]..Length(path)]},
                        path{[2..minpos[1]-1]}, [ path[minpos[1]] ]);
            else
               path := Concatenation( [ path[minpos[1]] ], path{[minpos[1]+1..Length(path)]},
                        path{[2..minpos[1]]});
               path := Reversed(path);
            fi;
        fi;


        return [path, SubsurfaceByFacesNC(surf, Set(traversedFaces)), __SIMPLICIAL_TranslateListsIntoCycles([permList, invPermList])];
    end
);
    RedispatchOnCondition( Geodesic, true,
        [IsSimplicialSurface,IsPosInt, IsPosInt,IsPosInt],
        [IsTriangleSurface and IsEdgesLikeSurface,,,], 0);

InstallOtherMethod( Geodesic,
    "for a simplicial surface, a vertex and a face",
    [IsSimplicialSurface and IsTriangleSurface and IsEdgesLikeSurface,
    IsPosInt, IsPosInt],
    function(surf, vertex, face)
        local edges;
        
        if not vertex in Vertices(surf) then
            Error("Given vertex does not lie in surface.");
        fi;
        if not face in Faces(surf) then
            Error("Given face does not lie in surface.");
        fi;
        
        edges := Intersection( EdgesOfFaces(surf)[face], EdgesOfVertices(surf)[vertex] );
        if IsEmpty(edges) then
            Error("Given vertex is not incident to given face.");
        fi;
        
        return Geodesic(surf, vertex, edges[1], face);
    end
 );
    RedispatchOnCondition( Geodesic, true,
        [IsSimplicialSurface, IsPosInt, IsPosInt],
        [IsTriangleSurface and IsEdgesLikeSurface, ,], 0);

InstallMethod( Geodesics, "for a simplicial surface",
        [IsSimplicialSurface and IsTriangleSurface and IsActualSurface],
        function(surface)
            local triples, tr, geodesics, vertex, geo, vertOfEdge, allFlags,
                NormaliseFlag, allGeos, bigPerm, g;

            triples := Union( List( Faces(surface),
                f -> List( Combinations(EdgesOfFaces(surface)[f],2),
                              c -> [c[1],f,c[2]] ) ) );
            vertOfEdge := VerticesOfEdges(surface);

            geodesics := [];
            while Size(triples) > 0 do
               tr := triples[1];
               geo := Geodesic( surface, 
                  Intersection(vertOfEdge[tr[1]], vertOfEdge[tr[3]] )[1],
                  tr[3], tr[2] );
                  #TODO write this as alternative input
               Add(geodesics,geo);
               # remove all flags
               allFlags := List( [1..(Length(geo[1])-1)/2], i ->
                           geo[1]{[2*i-1,2*i,2*i+1]} );
               NormaliseFlag := function(x)
                   if x[1] > x[3] then
                       return [x[3],x[2],x[1]];
                   else
                       return x;
                   fi;
               end;
               allFlags := List( allFlags, NormaliseFlag );
               triples := Difference( triples, allFlags);

            od;

            allGeos := Set(geodesics);
            bigPerm := ();
            for g in allGeos do
                bigPerm := bigPerm * g[3][1] * g[3][2];
            od;
            SetGeodesicFlagPermutation(surface, bigPerm);

            return Set(geodesics);
        end
);
InstallMethod( GeodesicFlagPermutation, "", [IsSimplicialSurface],
    #TODO
    function(complex)
        Geodesics(complex);
        return GeodesicFlagPermutation(complex);
    end
);

##
##      Automorphisms
##
InstallMethod( DisplayAsAutomorphism, 
    "for a simplicial surface and a permutation",
    [IsSimplicialSurface, IsPerm],
    function( surf, perm )
        local maxVert, maxEdge, maxFace, autVert, autEdge, autFace, sep1, 
            sep2, listPerm;

        maxVert := Maximum( Vertices(surf) );
        maxEdge := Maximum( Edges(surf) );
        maxFace := Maximum( Faces(surf) );

        sep1 := maxVert + maxEdge;
        sep2 := maxVert + maxEdge + maxFace;

        # Restrict the permutations
        autVert := RestrictedPerm(perm, [1..maxVert]);
        autEdge := RestrictedPerm(perm, [maxVert+1..sep1]);
        autFace := RestrictedPerm(perm, [sep1+1..sep2]);

        # Rescale the permutations
        listPerm := ListPerm(autEdge, sep1);
        listPerm := listPerm{[maxVert+1..sep1]};
        listPerm := List( listPerm, i -> i - maxVert );
        autEdge := PermList( listPerm );

        listPerm := ListPerm(autFace, sep2);
        listPerm := listPerm{[sep1+1..sep2]};
        listPerm := List( listPerm, i -> i - sep1 );
        autFace := PermList( listPerm );

        return [autVert, autEdge, autFace];
    end
);

InstallMethod( InnerVertices, "for an actual surface",
    [IsSimplicialSurface and IsEdgesLikeSurface],
    function(surf)
        local paths;
        
        paths := FaceEdgePathsOfVertices(surf);
        return Filtered( Vertices(surf), v -> Size(paths[v]) = 1 and IsEvenInt( Size( paths[v][1] ) ) );
    end
);
RedispatchOnCondition( InnerVertices, true, [IsSimplicialSurface], [IsEdgesLikeSurface], 0 );
InstallMethod( IsInnerVertex, "for a ramified surface and a vertex",
    [IsSimplicialSurface and IsEdgesLikeSurface, IsPosInt],
    function(surf, v)
        if not v in Vertices(surf) then
            Error("IsInnerVertex: Not a vertex of the surface.");
        fi;
        return v in InnerVertices(surf);
    end
);
RedispatchOnCondition( IsInnerVertex, true, [IsSimplicialSurface,IsPosInt], [IsEdgesLikeSurface],0 );


InstallMethod( BoundaryVertices, "for a ramified surface",
    [IsSimplicialSurface and IsEdgesLikeSurface],
    function( surf )
        local paths;

        paths := FaceEdgePathsOfVertices(surf);
        return Filtered( Vertices(surf), v -> Size(paths[v])=1 and IsOddInt( Size( paths[v][1] ) ) );
    end
);
RedispatchOnCondition( BoundaryVertices, true, [IsSimplicialSurface], [IsEdgesLikeSurface], 0 );
InstallMethod( IsBoundaryVertex, "for a ramified surface and a vertex",
    [IsSimplicialSurface and IsEdgesLikeSurface, IsPosInt],
    function(surf, v)
        if not v in Vertices(surf) then
            Error("IsBoundaryVertex: Not a vertex of the surface.");
        fi;
        return v in BoundaryVertices(surf);
    end
);
RedispatchOnCondition( IsBoundaryVertex, true, [IsSimplicialSurface,IsPosInt], [IsEdgesLikeSurface],0 );


InstallMethod( RamifiedVertices, "for a ramified surface",
    [IsSimplicialSurface and IsEdgesLikeSurface],
    function( surf )
        local paths;
        
        paths := FaceEdgePathsOfVertices(surf);
        return Filtered(Vertices(surf), v->Size(paths[v])>1);
    end
);
RedispatchOnCondition( RamifiedVertices, true, [IsSimplicialSurface], [IsEdgesLikeSurface], 0 );
InstallMethod( IsRamifiedVertex, "for a ramified surface and a vertex",
    [IsSimplicialSurface and IsEdgesLikeSurface, IsPosInt],
    function(surf, v)
        if not v in Vertices(surf) then
            Error("IsRamifiedVertex: Not a vertex of the surface.");
        fi;
        return v in RamifiedVertices(surf);
    end
);
RedispatchOnCondition( IsRamifiedVertex, true, [IsSimplicialSurface,IsPosInt], [IsEdgesLikeSurface],0 );

##
##           cuts and mends
##
InstallMethod( CraterCuttableEdges, "for an actual surface",
    [IsSimplicialSurface],
    function(surf)
        local innerEdges, innerVertices;

        innerEdges := InnerEdges(surf);
        innerVertices := InnerVertices(surf);
        return Filtered( innerEdges, e -> ForAll( VerticesOfEdges(surf)[e], v -> v in innerVertices ) );
    end
);
InstallMethod(CraterCut, "for an actual surface and an inner edge",
    [IsSimplicialSurface and IsActualSurface, IsPosInt],
    function(surf, edge)
        local verts, verticesOfEdges, facesOfEdges, maxEdge, adFaces, adVerts, obj;

        # Check whether the edge is an inner edge
        verts := VerticesOfEdges(surf)[edge];
        if not verts[1] in InnerVertices(surf) or not verts[2] in InnerVertices(surf) then
            Error("CraterCut: Given edge has to be an inner edge where both vertices are inner.");
        fi;

        verticesOfEdges := ShallowCopy(VerticesOfEdges(surf));
        facesOfEdges := ShallowCopy(FacesOfEdges(surf));
        maxEdge := Maximum(Edges(surf));

        # replace edge by maxEdge+1 and maxEdge+2
        adFaces := facesOfEdges[edge];
        Unbind( facesOfEdges[edge] );
        facesOfEdges[maxEdge+1] := [adFaces[1]];
        facesOfEdges[maxEdge+2] := [adFaces[2]];

        adVerts := verticesOfEdges[edge];
        Unbind( verticesOfEdges[edge] );
        verticesOfEdges[maxEdge+1] := adVerts;
        verticesOfEdges[maxEdge+2] := adVerts;

        obj := Objectify( SimplicialSurfaceType, rec() );
        SetVerticesOfEdges(obj, verticesOfEdges);
        SetFacesOfEdges(obj, facesOfEdges);
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(obj);

        return obj;
    end
);
RedispatchOnCondition( CraterCut, true, [IsSimplicialSurface, IsPosInt], [IsActualSurface], 0 );

InstallMethod( CraterMendableEdgePairs, "for an actual surface",
    [IsSimplicialSurface],
    function(surf)
        local edgeAnomalies, comb;

        edgeAnomalies := List( EdgeAnomalyClasses(surf), cl -> Filtered(cl, e -> IsBoundaryEdge(surf, e)) );
        comb := List( edgeAnomalies, a -> Combinations(a,2) );
        return Union(comb);
    end
);
InstallMethod( CraterMend, "for an actual surface and two edges that form an edge anomaly",
    [IsSimplicialSurface and IsActualSurface, IsPosInt, IsPosInt],
    function(surf, e1, e2)
        local verticesOfEdges, facesOfEdges, obj;

        if VerticesOfEdges(surf)[e1] <> VerticesOfEdges(surf)[e2] then
            Error("CraterMend: Given edges have to form an edge anomaly.");
        fi;

        verticesOfEdges := ShallowCopy( VerticesOfEdges(surf) );
        Unbind(verticesOfEdges[e2]);

        facesOfEdges := ShallowCopy( FacesOfEdges(surf) );
        facesOfEdges[e1] := Union( facesOfEdges[e1], facesOfEdges[e2] );
        Unbind(facesOfEdges[e2]);

        obj := Objectify(SimplicialSurfaceType, rec());
        SetVerticesOfEdges(obj, verticesOfEdges);
        SetFacesOfEdges(obj, facesOfEdges);
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(obj);

        return obj;
    end
);
RedispatchOnCondition( CraterMend, true, [IsSimplicialSurface, IsPosInt, IsPosInt], [IsActualSurface], 0 );


InstallMethod( RipCuttableEdges, "for an actual surface", [IsSimplicialSurface],
    function(surf)
        local innerEdges, innerVertices, boundVertices;

        innerEdges := InnerEdges(surf);
        innerVertices := InnerVertices(surf);
        boundVertices := BoundaryVertices(surf);
        return Filtered( innerEdges, e -> 
            Size( Intersection( innerVertices, VerticesOfEdges(surf)[e] )) = 1
            and Size( Intersection( boundVertices, VerticesOfEdges(surf)[e] ) ) = 1);
    end
);
InstallMethod( RipCut, "for an actual surface and an inner edge where one vertex is inner and one is on the boundary",
    [IsSimplicialSurface and IsActualSurface, IsPosInt],
    function(surf, edge)
        local verts, in1, in2, maxVert, maxEdge, edgesOfVertices, 
            facesOfEdges, innerVert, boundVert, path, pos, edges1,
            edges2, obj;

        verts := VerticesOfEdges(surf)[edge];
        in1 := verts[1] in InnerVertices(surf);
        in2 := verts[2] in InnerVertices(surf);
        if in1 = in2 then
            Error("RipCut: Vertices of given edge have to be one on the boundary, one inner");
        fi;

        maxVert := Maximum(Vertices(surf));
        maxEdge := Maximum(Edges(surf));
        edgesOfVertices := ShallowCopy( EdgesOfVertices(surf) );
        facesOfEdges := ShallowCopy( FacesOfEdges(surf) );

        if in1 then
            innerVert := verts[1];
            boundVert := verts[2];
        else
            innerVert := verts[2];
            boundVert := verts[1];
        fi;

        # Replace boundVert by maxVertex+1 and maxVertex+2
        # Replace edge by maxEdge+1 and maxEdge+2
        edgesOfVertices[innerVert] := Union( [maxEdge+1,maxEdge+2], Difference(edgesOfVertices[innerVert], [edge]) );
        
        # We traverse the path around the vertex and separate the edges
        path := FaceEdgePathsOfVertex(surf, boundVert)[1];
        pos := Positions(path, edge);
        pos := Filtered( pos, IsOddInt );
        Assert(0, Size(pos)=1);
        pos := pos[1];

        # edge is at position pos
        edges1 := List([1..(pos-1)/2], i -> path[2*i-1]);
        edges2 := List([(pos+3)/2..(Size(path)+1)/2], i -> path[2*i-1]);
        Unbind( edgesOfVertices[boundVert] );
        edgesOfVertices[maxVert+1] := Union( edges1, [maxEdge+1] );
        edgesOfVertices[maxVert+2] := Union( edges2, [maxEdge+2] );

        Unbind( facesOfEdges[edge] );
        facesOfEdges[maxEdge+1] := [ path[pos-1] ];
        facesOfEdges[maxEdge+2] := [ path[pos+1] ];

        
        obj := Objectify( SimplicialSurfaceType, rec() );
        SetEdgesOfVertices( obj, edgesOfVertices);
        SetFacesOfEdges( obj, facesOfEdges );
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(obj);

        return obj;
    end
);
RedispatchOnCondition( RipCut, true, [IsSimplicialSurface, IsPosInt], [IsActualSurface], 0 );


InstallMethod( RipMendableEdgePairs, "for an actual surface", [IsSimplicialSurface],
    function(surf)
        local boundEdges, e1, e2, pairs;

        pairs := [];
        boundEdges := BoundaryEdges(surf);
        for e1 in [1..Size(boundEdges)] do
            for e2 in [e1+1..Size(boundEdges)] do
                if Size( Intersection( VerticesOfEdges(surf)[boundEdges[e1]], VerticesOfEdges(surf)[boundEdges[e2]] ) ) = 1 then
                    Add( pairs, [boundEdges[e1], boundEdges[e2]] );
                fi;
            od;
        od;

        return pairs;
    end
);
InstallMethod( RipMend, "for an actual surface and two boundary edges that share a vertex",
    [IsSimplicialSurface and IsActualSurface, IsPosInt, IsPosInt],
    function(surface, e1, e2)
        local commonVertices, commonVertex, v1, v2, obj, edgesOfVertices, facesOfEdges;

        if not e1 in BoundaryEdges(surface) or not e2 in BoundaryEdges(surface) then
            Error("RipMend: The given edges have to be boundary edges.");
        fi;

        commonVertices := Intersection( VerticesOfEdges(surface)[e1], VerticesOfEdges(surface)[e2] );
        if Size(commonVertices) <> 1 then
            Error("RipMend: The given edges should have exactly one vertex in common.");
        fi;

        commonVertex := commonVertices[1];
        v1 := Difference( VerticesOfEdges(surface)[e1], commonVertices )[1];
        v2 := Difference( VerticesOfEdges(surface)[e2], commonVertices )[1];

        edgesOfVertices := ShallowCopy( EdgesOfVertices(surface) );
        edgesOfVertices[v1] := Difference( Union( edgesOfVertices[v1], edgesOfVertices[v2] ), [e2] );
        Unbind( edgesOfVertices[v2] );
        edgesOfVertices[commonVertex] := Difference( edgesOfVertices[commonVertex], [e2] );

        facesOfEdges := ShallowCopy( FacesOfEdges(surface) );
        facesOfEdges[e1] := Union( facesOfEdges[e1], facesOfEdges[e2] );
        Unbind(facesOfEdges[e2]);

        obj := Objectify( SimplicialSurfaceType, rec() );
        SetEdgesOfVertices(obj, edgesOfVertices);
        SetFacesOfEdges(obj, facesOfEdges);
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(obj);
        return obj;
    end
);
RedispatchOnCondition( RipMend, true, [IsSimplicialSurface, IsPosInt, IsPosInt], [IsActualSurface], 0 );


InstallMethod( SplitCuttableEdges, "for an actual surface", [IsSimplicialSurface],
    function(surf)
        local innerEdges, boundVert;

        innerEdges := InnerEdges(surf);
        boundVert := BoundaryVertices(surf);

        return Filtered( innerEdges, e -> IsSubset( boundVert, VerticesOfEdges(surf)[e] ) );
    end
);
InstallMethod( SplitCut, "for an actual surface and an edge whose two vertices are boundary vertices",
    [IsSimplicialSurface and IsActualSurface, IsPosInt],
    function(surf, edge)
        local verts, maxEdge, maxVertex, path1, path2, pos1, pos2,
            edgesOfVertices, facesOfEdges, face1, face2, obj;

        if not edge in Edges(surf) then
            Error("SplitCut: Given edge has to be an edge of the surface.");
        fi;
        verts := VerticesOfEdges(surf)[edge];
        if verts[1] in InnerVertices(surf) or verts[2] in InnerVertices(surf) then
            Error("SplitCut: Vertices of given edge can't be inner vertices.");
        fi;

        maxVertex := Maximum( Vertices(surf) );
        maxEdge := Maximum( Edges(surf) );

        path1 := FaceEdgePathsOfVertex(surf,verts[1])[1];
        path2 := FaceEdgePathsOfVertex(surf,verts[2])[1];
        pos1 := Filtered( Positions(path1, edge), IsOddInt )[1];
        pos2 := Filtered( Positions(path2, edge), IsOddInt )[1];

        edgesOfVertices := ShallowCopy( EdgesOfVertices(surf) );
        facesOfEdges := ShallowCopy( FacesOfEdges(surf) );

        face1 := path1[pos1-1];
        face2 := path1[pos1+1];

        facesOfEdges[maxEdge+1] := [face1];
        facesOfEdges[maxEdge+2] := [face2];
        Unbind(facesOfEdges[edge]);

        edgesOfVertices[verts[1]] := Set( Concatenation( [maxEdge+1], List( [1..(pos1-1)/2], i -> path1[2*i-1] ) ) );
        edgesOfVertices[maxVertex+1] := Set( Concatenation( [maxEdge+2], List( [(pos1+3)/2..(Length(path1)+1)/2], i -> path1[2*i-1] ) ) );

        if path2[pos2-1] = face2 then
            path2 := Reversed(path2);
            pos2 := Length(path2) + 1 - pos2;
        fi;
        edgesOfVertices[verts[2]] := Set( Concatenation( [maxEdge+1], List( [1..(pos2-1)/2], i -> path2[2*i-1] ) ) );
        edgesOfVertices[maxVertex+2] := Set( Concatenation( [maxEdge+2], List( [(pos2+3)/2..(Length(path2)+1)/2], i -> path2[2*i-1] ) ) );

        
        obj := Objectify( SimplicialSurfaceType, rec() );
        SetEdgesOfVertices( obj, edgesOfVertices );
        SetFacesOfEdges( obj, facesOfEdges );
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(obj);
        return obj;
    end
);
RedispatchOnCondition( SplitCut, true, [IsSimplicialSurface,IsPosInt], [IsActualSurface], 0 );


InstallMethod( SplitMendableFlagPairs, "for an actual surface", [IsSimplicialSurface],
    function(surf)
        local boundEdges, i, j, e1, e2, verts1, verts2, flagPairs, v;

        boundEdges := BoundaryEdges(surf);
        flagPairs := [];
        for i in [1..Size(boundEdges)] do
            for j in [i+1..Size(boundEdges)] do
                e1 := boundEdges[i];
                e2 := boundEdges[j];
                verts1 := VerticesOfEdges(surf)[e1];
                verts2 := VerticesOfEdges(surf)[e2];
                if IsEmpty( Intersection( verts1, verts2 ) ) then
                    for v in verts2 do
                        if IsEmpty( Intersection( EdgesOfVertices(surf)[verts1[1]], EdgesOfVertices(surf)[v] ) ) then
                            Add( flagPairs, [ [verts1[1], e1], [v, e2] ] );
                        fi;
                    od;
                fi;
            od;
        od;

        return flagPairs;
    end
);
InstallMethod( SplitMend, "for an actual surface and two 2-flags of vertices-edges",
    [IsSimplicialSurface and IsActualSurface, IsList, IsList],
    function(surf, flag1, flag2)
        local obj, check, edgesOfVertices, facesOfEdges, oV1, oV2;

        check := function( flag )
            if Length(flag) <> 2 then
                Error("SplitMend: Flag has to consist of a vertex and an edge.");
            fi;
            if not flag[1] in Vertices(surf) then
                Error("SplitMend: First entry of flag is not a vertex.");
            fi;
            if not flag[2] in Edges(surf) then
                Error("SplitMend: Second entry of flag is not a vertex.");
            fi;

            if not flag[2] in BoundaryEdges(surf) then
                Error("SplitMend: Given edges have to be boundary edges.");
            fi;
        end;
        check(flag1);
        check(flag2);

        edgesOfVertices := ShallowCopy(EdgesOfVertices(surf));
        facesOfEdges := ShallowCopy( FacesOfEdges(surf) );

        if not IsEmpty( Intersection( edgesOfVertices[flag1[1]], edgesOfVertices[flag2[1]] ) ) then
            Error("SplitMend: Given vertices are connected by an edge.");
        fi;
        edgesOfVertices[flag1[1]] := Difference( Union( edgesOfVertices[flag1[1]], edgesOfVertices[flag2[1]] ), [flag2[2]] );
        Unbind( edgesOfVertices[ flag2[1] ] );
        oV1 := Difference( VerticesOfEdges(surf)[flag1[2]], [flag1[1]] )[1];
        oV2 := Difference( VerticesOfEdges(surf)[flag2[2]], [flag2[1]] )[1];
        if not IsEmpty( Intersection( edgesOfVertices[oV1], edgesOfVertices[oV2] ) ) then
            Error("SplitMend: Other vertices of given edges are connected by an edge.");
        fi;
        edgesOfVertices[oV1] := Difference( Union( edgesOfVertices[oV1], edgesOfVertices[oV2] ), [flag2[2]] );
        Unbind( edgesOfVertices[oV2] );
        
        facesOfEdges[flag1[2]] := Union( facesOfEdges[flag1[2]], facesOfEdges[flag2[2]] );
        Unbind( facesOfEdges[flag2[2]] );


        obj := Objectify( SimplicialSurfaceType, rec() );
        SetEdgesOfVertices( obj, edgesOfVertices );
        SetFacesOfEdges( obj, facesOfEdges );
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(obj);
        return obj;
    end
);
RedispatchOnCondition( SplitMend, true, [IsSimplicialSurface, IsList, IsList], [IsActualSurface], 0 );


## Connected sum
InstallMethod( ConnectedSum, "", [IsSimplicialSurface, IsList, IsSimplicialSurface, IsList],
    function( s1, flag1, s2, flag2 )
        local IsFlag, maxVert1, maxEdge1, maxFace1, verticesOfEdges, 
            edgesOfFaces, obj, e, f, verts2, edges2, vertPairs, edgePairs, 
            v2, v2Alt, e1, e1Alt, oldVertices, oldEdges, pair, otherFace; 

        IsFlag := function( surf, flag )
            if Size(flag) <> 3 then
                Error("ConnectedSum: Flag should consist of a vertex, an edge and a face.");
            fi;
            if not flag[1] in Vertices(surf) then
                Error("First element of flag is not a vertex.");
            fi;
            if not flag[2] in Edges(surf) then
                Error("Second element of flag is not an edge.");
            fi;
            if not flag[3] in Faces(surf) then
                Error("Third element of flag is not a face.");
            fi;
            if not flag[1] in VerticesOfEdges(surf)[flag[2]] then
                Error("Vertex is not in edge");
            fi;
            if not flag[2] in EdgesOfFaces(surf)[flag[3]] then
                Error("Edge is not in face");
            fi;
        end;
        IsFlag( s1, flag1 );
        IsFlag( s2, flag2 );

        maxVert1 := Maximum( Vertices(s1) );
        maxEdge1 := Maximum( Edges(s1) );
        maxFace1 := Maximum( Faces(s1) );

        verticesOfEdges := ShallowCopy( VerticesOfEdges(s1) );
        edgesOfFaces := ShallowCopy( EdgesOfFaces(s1) );

        verts2 := VerticesOfEdges(s2);
        edges2 := EdgesOfFaces(s2);

        for e in Edges(s2) do
            verticesOfEdges[maxEdge1+e] := List( verts2[e], x -> x + maxVert1 );
        od;
        for f in Faces(s2) do
            edgesOfFaces[maxFace1+f] := List( edges2[f], x -> x + maxEdge1 );
        od;

        # Now we have the disjoint union

        vertPairs := [];
        edgePairs := [];
        Add(vertPairs, [flag1[1], flag2[1]]);
        Add(edgePairs, [flag1[2], flag2[2]]);
        
        v2 := OtherVertexOfEdgeNC(s1, flag1[1], flag1[2]);
        v2Alt := OtherVertexOfEdgeNC( s2, flag2[1], flag2[2] );
        Add(vertPairs, [v2, v2Alt]);

        e1 := OtherEdgeOfVertexInFaceNC(s1, v2, flag1[2], flag1[3]);
        e1Alt := OtherEdgeOfVertexInFace( s2, v2Alt, flag2[2], flag2[3] );
        Add(edgePairs, [e1, e1Alt]);

        Add( vertPairs, [ OtherVertexOfEdgeNC(s1, v2, e1) , OtherVertexOfEdgeNC(s2, v2Alt, e1Alt) ] );
        Add( edgePairs, [ OtherEdgeOfVertexInFaceNC(s1, flag1[1], flag1[2], flag1[3]), OtherEdgeOfVertexInFaceNC( s2, flag2[1], flag2[2], flag2[3] ) ] );

        Unbind( edgesOfFaces[flag1[3]] );
        for e in EdgesOfFaces(s1)[flag1[3]] do
            otherFace := Difference( FacesOfEdges(s1)[e], [flag1[3]] )[1];
            oldEdges := edgesOfFaces[otherFace];
            for pair in edgePairs do
                if pair[1] in oldEdges then
                    oldEdges := Difference( oldEdges, [pair[1]] );
                    oldEdges := Union( oldEdges, [pair[2]] );
                fi;
            od;
            edgesOfFaces[otherFace] := oldEdges;
        od;
        for e in Edges(s1) do
            oldVertices := verticesOfEdges[e];
            for pair in vertPairs do
                if pair[1] in oldVertices then
                    oldVertices := Difference( oldVertices, [pair[1]] );
                    oldVertices := Union(oldVertices, [pair[2]]);
                fi;
            od;
            verticesOfEdges[e] := oldVertices;
        od;

        obj := Objectify( SimplicialSurfaceType, rec() );
        SetEdgesOfFaces(obj, edgesOfFaces);
        SetVerticesOfEdges(obj, verticesOfEdges);
        DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(obj);
        return obj;
    end
);

InstallMethod( AllMaximalStripEmbeddings, "for a geodesic", [IsList],
    function(geo)
        local res, max, start, seenFaces, rPos, nextFace, nextEdge, lPos, i;

        #TODO how to check if geodesic is closed?
        res := [];
        for i in [2,4..Size(geo[1])-1] do
            start := geo[1][i];
            seenFaces := [start];
            max := geo[1]{[i-1,i,i+1]};

            # go to the right
            rPos := i;
            while(true) do
                # increase rPos
                if rPos = Size(geo[1])-1 then
                    rPos := 2;
                else
                    rPos := rPos + 2;
                fi;

                # add face and edge
                nextFace := geo[1][rPos];
                nextEdge := geo[1][rPos+1];
                Append( max, [nextFace, nextEdge] );

                if nextFace in seenFaces then
                    break;
                else
                    Add(seenFaces, nextFace);
                fi;
            od;

            # go to the left
            lPos := i;
            while(true) do
                # decrase lPos
                if lPos = 2 then
                    lPos := Size(geo[1]);
                else
                    lPos := lPos - 2;
                fi;

                # add face and edge
                nextFace := geo[1][lPos];
                nextEdge := geo[1][lPos-1];
                
                max := Concatenation( [nextEdge, nextFace], max );
                if nextFace in seenFaces then
                    break;
                else
                    Add(seenFaces, nextFace);
                fi;
            od;

            Add(res, [max, Set(seenFaces)]);
        od;

        res := Set(res);
        return List( res, m -> [m[1], SubsurfaceByFacesNC(geo[2], m[2])] );
    end
);


InstallMethod( AllFlags, "", [IsSimplicialSurface],
    function(complex)
        local res, e, v, f;

        res := [];
        for e in Edges(complex) do
            for v in VerticesOfEdges(complex)[e] do
                for f in FacesOfEdges(complex)[e] do
                    Add( res, [v,e,f] );
                od;
            od;
        od;

        return Set(res);
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

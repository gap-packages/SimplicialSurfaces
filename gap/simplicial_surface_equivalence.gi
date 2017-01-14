##############################################################################
##
#W  simplicial_surface_equivalence.gi          SimplicialSurfaces         Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##
##  The functions in this file compute with simplicial surfaces with 
##	equivalence.
##

##
##	Generic representation
##
DeclareRepresentation("IsSimplicialSurfaceWithEquivalenceRep",
	 IsSimplicialSurfaceWithEquivalence, []);

##	accompanying type
SimplicialSurfaceWithEquivalenceType := 
    NewType( SimplicialSurfaceWithEquivalenceFamily,
			IsSimplicialSurfaceWithEquivalenceRep );



#############################################################################
#############################################################################
##
##						Start of constructors
##
##
##	We start with the construction from a simplicial surface. For this we have
##	to implement some methods that construct the additional structures from
##	the given one. 
##
##	We start with the generation of obvious equivalence relations
__SIMPLICIAL_GenerateTrivialEquivalence := function( vertices )
	local vertexEq, vertex;

	vertexEq := [];
	for vertex in vertices do
		vertexEq[vertex] := vertex;
	od;

	return vertexEq;
end;

##
##	Finally we can write the actual constructor.
##
#!	@Description
#!	Return a simplicial surface with equivalence that is based on the given 
#!	simplicial surface. All equivalences are assumed to be trivial.
#!	@Arguments a simplicial surface
#!	@Returns a simplicial surface with equivalence
InstallMethod( SimplicialSurfaceWithEquivalence,
	"for a simplicial surface", [IsSimplicialSurface],
	function( surface )
		local vertexEq, edgeEq, faceEq, complex;

		vertexEq := __SIMPLICIAL_GenerateTrivialEquivalence( Vertices(surface) );
		edgeEq := __SIMPLICIAL_GenerateTrivialEquivalence( Edges(surface) );
		faceEq := __SIMPLICIAL_GenerateTrivialEquivalence( Faces(surface) );

		complex := Objectify( 
				SimplicialSurfaceWithEquivalenceType,
				rec( ) );

		SetUnderlyingSimplicialSurfaceAttributeOfSSWE( complex, surface );
		SetVertexEquivalenceNumbersByElementsAttributeOfSSWE(complex, vertexEq);
		SetEdgeEquivalenceNumbersByElementsAttributeOfSSWE(complex, edgeEq);
		SetFaceEquivalenceNumbersByElementsAttributeOfSSWE(complex, faceEq);

		# Since the relations are trivial, we already know the quotient surface
		SetQuotientSimplicialSurfaceAttributeOfSSWE(complex, surface);

		return complex;
	end
);
##
##
##							End of constructors
##
#############################################################################
#############################################################################


##
##	Next we concern ourselves with the different possibilities to represent
##	equivalence classes.
##
##	We start with the switch from EquivalenceNumbersByElements to 
##	EquivalenceClassesByNumbers.

##
##	Since we have several methods to convert a list of images into actual
##	equivalence classes we write it in general.
##	indices gives the bound entries of imageList
##
__SIMPLICIAL_NumbersByElementsToClassesByNumbers := function( indices, imageList )
	local classes, classNr, i;

	classes := [];
	for i in indices do
		classNr := imageList[i];
		if IsBound( classes[ classNr ] ) then
			classes[ classNr ] := Union( classes[ classNr ], [i] );
		else
			classes[ classNr ] := [ i ];
		fi;
	od;

	return classes;
end;

#! @Description
#! Return the vertex equivalence classes. They are indexed by the vertex
#! equivalence numbers.
#! @Arguments a simplicial surface with equivalence
#! @Returns a list of sets of positive integers
InstallMethod( 
	VertexEquivalenceClassesByNumbersAttributeOfSSWE, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and 
		HasVertexEquivalenceNumbersByElementsAttributeOfSSWE],
	function( complex )
		return __SIMPLICIAL_NumbersByElementsToClassesByNumbers( 
			Vertices( UnderlyingSimplicialSurface( complex ) ),
			VertexEquivalenceNumbersByElements(complex) );
	end
);
InstallMethod( VertexEquivalenceClassesByNumbers, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return VertexEquivalenceClassesByNumbersAttributeOfSSWE( complex );
	end
);

#! @Description
#! Return the edge equivalence classes. They are indexed by the edge
#! equivalence numbers.
#! @Arguments a simplicial surface with equivalence
#! @Returns a list of sets of positive integers
InstallMethod( 
	EdgeEquivalenceClassesByNumbersAttributeOfSSWE, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and 
		HasEdgeEquivalenceNumbersByElementsAttributeOfSSWE],
	function( complex )
		return __SIMPLICIAL_NumbersByElementsToClassesByNumbers( 
			Edges( UnderlyingSimplicialSurface( complex ) ),
			EdgeEquivalenceNumbersByElements(complex) );
	end
);
InstallMethod( EdgeEquivalenceClassesByNumbers, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return EdgeEquivalenceClassesByNumbersAttributeOfSSWE( complex );
	end
);

#! @Description
#! Return the face equivalence classes. They are indexed by the face
#! equivalence numbers.
#! @Arguments a simplicial surface with equivalence
#! @Returns a list of sets of positive integers
InstallMethod( 
	FaceEquivalenceClassesByNumbersAttributeOfSSWE, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and 
		HasFaceEquivalenceNumbersByElementsAttributeOfSSWE],
	function( complex )
		return __SIMPLICIAL_NumbersByElementsToClassesByNumbers( 
			Faces( UnderlyingSimplicialSurface( complex ) ),
			FaceEquivalenceNumbersByElements(complex) );
	end
);
InstallMethod( FaceEquivalenceClassesByNumbers, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return FaceEquivalenceClassesByNumbersAttributeOfSSWE( complex );
	end
);

##
##	Next we calculate EquivalenceNumbersByElements from
##	EquivalenceClassesByNumbers. We use a helper method.
##
__SIMPLICIAL_ClassesByNumbersToNumbersByElements := function( classes, indices )
	local numbers, i, el;

	numbers := [];
	for i in indices do
		for el in classes[i] do
			numbers[el] := i;
		od;
	od;

	return numbers;
end;

#! @Description
#! Return the vertex equivalence numbers as list indexed by the vertices of the
#! underlying simplicial surface. Each vertex equivalence class 
#! has a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
InstallMethod( 
	VertexEquivalenceNumbersByElementsAttributeOfSSWE, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and 
		HasVertexEquivalenceClassesByNumbersAttributeOfSSWE],
	function( complex )
		return __SIMPLICIAL_ClassesByNumbersToNumbersByElements( 
			VertexEquivalenceClassesByNumbers( complex ),
			VertexEquivalenceNumbersAsSet( complex ) );
	end
);
InstallMethod( VertexEquivalenceNumbersByElements, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return VertexEquivalenceNumbersByElementsAttributeOfSSWE( complex );
	end
);


#! @Description
#! Return the edge equivalence numbers as list indexed by the edges of the
#! underlying simplicial surface. Each edge equivalence class 
#! has a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
InstallMethod( 
	EdgeEquivalenceNumbersByElementsAttributeOfSSWE, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and 
		HasEdgeEquivalenceClassesByNumbersAttributeOfSSWE],
	function( complex )
		return __SIMPLICIAL_ClassesByNumbersToNumbersByElements( 
			EdgeEquivalenceClassesByNumbers( complex ),
			EdgeEquivalenceNumbersAsSet( complex ) );
	end
);
InstallMethod( EdgeEquivalenceNumbersByElements, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return EdgeEquivalenceNumbersByElementsAttributeOfSSWE( complex );
	end
);


#! @Description
#! Return the face equivalence numbers as list indexed by the faces of the
#! underlying simplicial surface. Each face equivalence class 
#! has a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
InstallMethod( 
	FaceEquivalenceNumbersByElementsAttributeOfSSWE, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and 
		HasFaceEquivalenceClassesByNumbersAttributeOfSSWE],
	function( complex )
		return __SIMPLICIAL_ClassesByNumbersToNumbersByElements( 
			FaceEquivalenceClassesByNumbers( complex ),
			FaceEquivalenceNumbersAsSet( complex ) );
	end
);
InstallMethod( FaceEquivalenceNumbersByElements, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return FaceEquivalenceNumbersByElementsAttributeOfSSWE( complex );
	end
);

##
##	Next we consider EquivalenceNumbersAsSet, which we will calculate both
##	from NumbersByElements and ClassesByNumbers.
##

__SIMPLICIAL_ClassesByNumbersToNumbersAsSet := function( classes )
	return Set( Filtered( [1..Length(classes)], i->IsBound( classes[i] ) ) );
end;

#! @Description
#! Return the vertex equivalence numbers as set. Each vertex equivalence class 
#! has a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
InstallMethod( VertexEquivalenceNumbersAsSetAttributeOfSSWE,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and
		HasVertexEquivalenceNumbersByElementsAttributeOfSSWE],
	function( complex )
		return Set( VertexEquivalenceNumbersByElements(complex) );
	end
);
InstallMethod( VertexEquivalenceNumbersAsSetAttributeOfSSWE,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and
		HasVertexEquivalenceClassesByNumbersAttributeOfSSWE],
	function( complex )
		return __SIMPLICIAL_ClassesByNumbersToNumbersAsSet( 
						VertexEquivalenceClassesByElements(complex) );
	end
);
InstallMethod( VertexEquivalenceNumbersAsSet,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return VertexEquivalenceNumbersAsSetAttributeOfSSWE(complex);
	end
);

#! @Description
#! Return the edge equivalence numbers as set. Each edge equivalence class 
#! has a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
InstallMethod( EdgeEquivalenceNumbersAsSetAttributeOfSSWE,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and
		HasEdgeEquivalenceNumbersByElementsAttributeOfSSWE],
	function( complex )
		return Set( EdgeEquivalenceNumbersByElements(complex) );
	end
);
InstallMethod( EdgeEquivalenceNumbersAsSetAttributeOfSSWE,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and
		HasEdgeEquivalenceClassesByNumbersAttributeOfSSWE],
	function( complex )
		return __SIMPLICIAL_ClassesByNumbersToNumbersAsSet( 
						EdgeEquivalenceClassesByElements(complex) );
	end
);
InstallMethod( EdgeEquivalenceNumbersAsSet,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return EdgeEquivalenceNumbersAsSetAttributeOfSSWE(complex);
	end
);

#! @Description
#! Return the face equivalence numbers as set. Each face equivalence class 
#! has a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
InstallMethod( FaceEquivalenceNumbersAsSetAttributeOfSSWE,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and
		HasFaceEquivalenceNumbersByElementsAttributeOfSSWE],
	function( complex )
		return Set( FaceEquivalenceNumbersByElements(complex) );
	end
);
InstallMethod( FaceEquivalenceNumbersAsSetAttributeOfSSWE,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and
		HasFaceEquivalenceClassesByNumbersAttributeOfSSWE],
	function( complex )
		return __SIMPLICIAL_ClassesByNumbersToNumbersAsSet( 
						FaceEquivalenceClassesByElements(complex) );
	end
);
InstallMethod( FaceEquivalenceNumbersAsSet,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return FaceEquivalenceNumbersAsSetAttributeOfSSWE(complex);
	end
);


##
##	Finally we consider ClassesByElements which also has to defined by
##	NumbersByElements and ClassesByNumbers. Optimally we have both.
##
__SIMPLICIAL_ClassesByNumbersToClassesByElements := function( classes )
	local result, cl, el;

	result := [];
	for cl in classes do
		for el in cl do
			result[el] := cl;
		od;
	od;

	return result;
end;

#! @Description
#! Return the vertex equivalence classes. They are indexed by the vertices of
#! the underlying simplicial surface.
#! @Arguments a simplicial surface with equivalence
#! @Returns a list of sets of positive integers
InstallMethod( VertexEquivalenceClassesByElementsAttributeOfSSWE,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and
		HasVertexEquivalenceNumbersByElementsAttributeOfSSWE],
	function( complex )
		# calculate ClassesByNumbers
		return List( Vertices(UnderlyingSimplicialSurface(complex)),
			el -> VertexEquivalenceClassesByNumbers(complex)[
						VertexEquivalenceNumbersByElements(complex)[el] ] );
	end
);
InstallMethod( VertexEquivalenceClassesByElementsAttributeOfSSWE,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and
		HasVertexEquivalenceClassesByNumbersAttributeOfSSWE],
	function( complex )
		return __SIMPLICIAL_ClassesByNumbersToClassesByElements(
				 VertexEquivalenceClassesByNumbers(complex) );
	end
);
InstallMethod( VertexEquivalenceClassesByElements,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return VertexEquivalenceClassesByElementsAttributeOfSSWE( complex );
	end
);

#! @Description
#! Return the edge equivalence classes. They are indexed by the edges of
#! the underlying simplicial surface.
#! @Arguments a simplicial surface with equivalence
#! @Returns a list of sets of positive integers
InstallMethod( EdgeEquivalenceClassesByElementsAttributeOfSSWE,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and
		HasEdgeEquivalenceNumbersByElementsAttributeOfSSWE],
	function( complex )
		# calculate ClassesByNumbers
		return List( Edges(UnderlyingSimplicialSurface(complex)),
			el -> EdgeEquivalenceClassesByNumbers(complex)[
						EdgeEquivalenceNumbersByElements(complex)[el] ] );
	end
);
InstallMethod( EdgeEquivalenceClassesByElementsAttributeOfSSWE,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and
		HasEdgeEquivalenceClassesByNumbersAttributeOfSSWE],
	function( complex )
		return __SIMPLICIAL_ClassesByNumbersToClassesByElements(
				 EdgeEquivalenceClassesByNumbers(complex) );
	end
);
InstallMethod( EdgeEquivalenceClassesByElements,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return EdgeEquivalenceClassesByElementsAttributeOfSSWE( complex );
	end
);

#! @Description
#! Return the face equivalence classes. They are indexed by the faces of
#! the underlying simplicial surface.
#! @Arguments a simplicial surface with equivalence
#! @Returns a list of sets of positive integers
InstallMethod( FaceEquivalenceClassesByElementsAttributeOfSSWE,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and
		HasFaceEquivalenceNumbersByElementsAttributeOfSSWE],
	function( complex )
		# calculate ClassesByNumbers
		return List( Faces(UnderlyingSimplicialSurface(complex)),
			el -> FaceEquivalenceClassesByNumbers(complex)[
						FaceEquivalenceNumbersByElements(complex)[el] ] );
	end
);
InstallMethod( FaceEquivalenceClassesByElementsAttributeOfSSWE,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence and
		HasFaceEquivalenceClassesByNumbersAttributeOfSSWE],
	function( complex )
		return __SIMPLICIAL_ClassesByNumbersToClassesByElements(
				 FaceEquivalenceClassesByNumbers(complex) );
	end
);
InstallMethod( FaceEquivalenceClassesByElements,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return FaceEquivalenceClassesByElementsAttributeOfSSWE( complex );
	end
);



#!	@Description
#!	Return the binding relation of the given vertex class (represented by its
#!	number). The binding partition represents the finest partition into which 
#!	the vertex equivalence class may split without contradicting the
#!	consistency with the incidence relation.
#!	@Arguments a simplicial surface with equivalence, a positive integer
#!	@Returns a set of sets of positive integers
InstallMethod( VertexBindingRelationAttributeOfSSWEOp,
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( complex, name )
		local partition, vertexClass, edgeClassForVertex, relation, v1, v2;
		if not name in VertexEquivalenceNumbersAsSet( complex ) then
			Error("VertexBindingPartition: number has to refer to one of the vertex equivalence classes.");
		fi;
		
		# We only have to check the edges to determine the binding relation
		# (If two faces are equivalent, it forces equivalence onto their
		# edges as well)
		vertexClass := VertexEquivalenceClassesByNumbers( complex )[ name ];
		edgeClassForVertex := List( vertexClass, v -> 
			List( VerticesByEdges( UnderlyingSimplicialSurface( complex )[v] ),
				e -> EdgeEquivalenceNumbersByElements(complex)[e] ) );

		relation := [];
		for v1 in vertexClass do
			for v2 in Filtered( vertexClass, v -> v > v1 ) do
				if Size( Intersection( edgeClassForVertex[v1], 
									edgeClassForVertex[v2] ) ) > 0 then
					Append( relation, [v1,v2] );
				fi;
			od;
		od;

		return EquivalenceRelationByPairs( Domain( vertexClass ), relation );
	end
);
InstallMethod( VertexBindingRelation,
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( complex, name )
		return VertexBindingRelationAttributeOfSSWE( complex, name );
	end
);


#!	@Description
#!	Return the binding relation of the given edge class (represented by its
#!	number). The binding partition represents the finest partition into which 
#!	the edge equivalence class may split without contradicting the
#!	consistency with the incidence relation.
#!	@Arguments a simplicial surface with equivalence, a positive integer
#!	@Returns a set of sets of positive integers
InstallMethod( EdgeBindingRelationAttributeOfSSWEOp,
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( complex, name )
		local partition, edgeClass, faceClassForEdge, relation, e1, e2;
		if not name in EdgeEquivalenceNumbersAsSet( complex ) then
			Error("VertexBindingPartition: number has to refer to one of the edge equivalence classes.");
		fi;
		
		# We only have to check the faces to determine the binding relation
		# (If two faces are equivalent, it forces equivalence onto their
		# edges as well)
		edgeClass := EdgeEquivalenceClassesByNumbers( complex )[ name ];
		faceClassForEdge := List( edgeClass, e -> 
			List( EdgesByFaces( UnderlyingSimplicialSurface( complex )[e] ),
				f -> FaceEquivalenceNumbersByElements(complex)[f] ) );

		relation := [];
		for e1 in edgeClass do
			for e2 in Filtered( edgeClass, e -> e > e1 ) do
				if Size( Intersection( faceClassForEdge[e1], 
									faceClassForEdge[e2] ) ) > 0 then
					Append( relation, [e1,e2] );
				fi;
			od;
		od;

		return EquivalenceRelationByPairs( Domain( edgeClass ), relation );
	end
);
InstallMethod( EdgeBindingRelation,
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( complex, name )
		return EdgeBindingRelationAttributeOfSSWE( complex, name );
	end
);

	
#!	@Description
#!	Return a list that is indexed by the face-names of the underlying
#!	simplicial surface. At the position of a given face lies the local
#!	orientation in terms of the vertex equivalence classes, i.e. it is a
#!	cyclic permutation of the vertex equivalence class numbers that lie in the
#!	given face.
#!	@Arguments a simplicial surface with equivalence
#!	@Returns a list of cyclic permutations
InstallMethod( LocalOrientationWRTVertexEquivalenceClassesAttributeOfSSWE,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( surface )
		local list, face, faceByVertex, perm, vertex;

		list := [];
		faceByVertex := FacesByVertices(UnderlyingSimplicialSurface(surface));
		for face in Faces( UnderlyingSimplicialSurface( surface ) ) do
			perm := ();
			for vertex in faceByVertex[face] do
				perm := perm * ( vertex, 
						VertexEquivalenceClassesByElements(surface)[vertex] );
			od;
			list[face] := LocalOrientation(surface)[face]^perm;
		od;

		return list;
	end
);
InstallMethod( LocalOrientationWRTVertexEquivalenceClasses,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( surface )
		return LocalOrientationWRTVertexEquivalenceClassesAttributeOfSSWE( 
																	surface );
	end
);



##############################################


#! @Description
#! Return the simplicial surface that we get if we consider each equivalence
#! class as one point.
#! @Arguments a simplicial surface with equivalence
#! @Returns a simplicial surface
InstallMethod( QuotientSimplicialSurfaceAttributeOfSSWE,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( surface )
		local vertices, edges, faces, edgesByVertices, facesByEdges,
			edge, edgeClass, vertInEdge, vertNumInEdge, face, faceClass,
			edgeInFace, edgeNumInFace, unSurf;

		unSurf := UnderlyingSimplicialSurface( surface );

		vertices := VertexEquivalenceNumbersAsSet( surface );
		edges := EdgeEquivalenceNumbersAsSet( surface );
		faces := FaceEquivalenceNumbersAsSet( surface );

		edgesByVertices := [];
		for edge in edges do
			edgeClass := EdgeEquivalenceClassesByNumbers( surface )[edge];
			vertInEdge := EdgesByVertices( unSurf )[ edgeClass[1] ];
			vertNumInEdge := List( vertInEdge, 
						v -> VertexEquivalenceNumbersByElements(surface)[v] );
			edgesByVertices[ edge ] := Set( vertNumInEdge );
		od;

		facesByEdges := [];
		for face in faces do
			faceClass := FaceEquivalenceClassesByNumbers( surface )[face];
			edgeInFace := FacesByEdges( unSurf )[faceClass[1]];
			edgeNumInFace := List( edgeInFace, 
						e -> EdgeEquivalenceNumbersByElements(surface)[e] );
			facesByEdges[ face ] := Set( edgeNumInFace );
		od;

		return SimplicialSurfaceByDownwardIncidenceNC( vertices, edges, faces, 
												edgesByVertices, facesByEdges );
	end
);
InstallMethod( QuotientSimplicialSurface,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( surface )
		return QuotientSimplicialSurfaceAttributeOfSSWE(surface);
	end
);

#! @Description
#! Return the underlying simplicial surface.
#! @Arguments a simplicial surface with equivalence
#! @Returns a simplicial surface
InstallMethod( UnderlyingSimplicialSurface,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( surface )
		return UnderlyingSimplicialSurfaceAttributeOfSSWE(surface);
	end
);


##
##	To check if two vertices are equivalent we just have to compare their
##	image values.
##

#! @Description
#! Check if two vertices are equivalent.
#! @Arguments two positive integers
#! @Returns true if they are equivalent, false otherwise
InstallMethod( IsEquivalentVertex, "for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt, IsPosInt],
	function( complex, v1, v2 )
		return VertexEquivalenceNumbersByElements(complex)[v1] = 
				VertexEquivalenceNumbersByElements(complex)[v2];
	end
);

#! @Description
#! Check if two edges are equivalent.
#! @Arguments two positive integers
#! @Returns true if they are equivalent, false otherwise
InstallMethod( IsEquivalentEdge, "for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt, IsPosInt],
	function( complex, v1, v2 )
		return EdgeEquivalenceNumbersByElements(complex)[v1] = 
				EdgeEquivalenceNumbersByElements(complex)[v2];
	end
);

#! @Description
#! Check if two faces are equivalent.
#! @Arguments two positive integers
#! @Returns true if they are equivalent, false otherwise
InstallMethod( IsEquivalentFace, "for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt, IsPosInt],
	function( complex, v1, v2 )
		return FaceEquivalenceNumbersByElements(complex)[v1] = 
				FaceEquivalenceNumbersByElements(complex)[v2];
	end
);

############################################################################
##				START convenience methods

#!	@Description
#!	Return the vertex equivalence number of a given vertex. Each vertex 
#!	equivalence class has a unique number associated with it.
#!	The NC-version doesn't check whether the given vertex lies in the underlying
#!	simplicial surface.
#!	@Arguments a simplicial surface with equivalence, a positive integer
#!	@Returns a positive integers
InstallMethod( VertexEquivalenceNumberOfElementNC, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		return VertexEquivalenceNumbersByElements(surface)[el];
	end
);
InstallMethod( VertexEquivalenceNumberOfElement, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		if not el in Vertices( UnderlyingSimplicialSurface( surface ) ) then
			Error("VertexEquivalenceNumberOfElement: Vertex has to lie in underlying simplicial surface.");
		fi;
		return VertexEquivalenceNumbersByElements(surface)[el];
	end
);

#!	@Description
#!	Return the edge equivalence number of a given edge. Each edge 
#!	equivalence class has a unique number associated with it.
#!	The NC-version doesn't check whether the given edge lies in the underlying
#!	simplicial surface.
#!	@Arguments a simplicial surface with equivalence, a positive integer
#!	@Returns a positive integers
InstallMethod( EdgeEquivalenceNumberOfElementNC, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		return EdgeEquivalenceNumbersByElements(surface)[el];
	end
);
InstallMethod( EdgeEquivalenceNumberOfElement, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		if not el in Edges( UnderlyingSimplicialSurface( surface ) ) then
			Error("EdgeEquivalenceNumberOfElement: Edge has to lie in underlying simplicial surface.");
		fi;
		return EdgeEquivalenceNumbersByElements(surface)[el];
	end
);

#!	@Description
#!	Return the face equivalence number of a given face. Each face 
#!	equivalence class has a unique number associated with it.
#!	The NC-version doesn't check whether the given face lies in the underlying
#!	simplicial surface.
#!	@Arguments a simplicial surface with equivalence, a positive integer
#!	@Returns a positive integers
InstallMethod( FaceEquivalenceNumberOfElementNC, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		return FaceEquivalenceNumbersByElements(surface)[el];
	end
);
InstallMethod( FaceEquivalenceNumberOfElement, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		if not el in Faces( UnderlyingSimplicialSurface( surface ) ) then
			Error("FaceEquivalenceNumberOfElement: Face has to lie in underlying simplicial surface.");
		fi;
		return FaceEquivalenceNumbersByElements(surface)[el];
	end
);

#!	@Description
#!	Return the vertex equivalence class of a given vertex.
#!	The NC-version doesn't check whether the given vertex lies in the underlying
#!	simplicial surface.
#!	@Arguments a simplicial surface with equivalence, a positive integer
#!	@Returns a set of positive integers
InstallMethod( VertexEquivalenceClassOfElementNC, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		return VertexEquivalenceClassesByElements(surface)[el];
	end
);
InstallMethod( VertexEquivalenceClassOfElement, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		if not el in Vertices( UnderlyingSimplicialSurface( surface ) ) then
			Error("VertexEquivalenceClassOfElement: Vertex has to lie in underlying simplicial surface.");
		fi;
		return VertexEquivalenceClassesByElements(surface)[el];
	end
);

#!	@Description
#!	Return the edge equivalence class of a given edge.
#!	The NC-version doesn't check whether the given edge lies in the underlying
#!	simplicial surface.
#!	@Arguments a simplicial surface with equivalence, a positive integer
#!	@Returns a set of positive integers
InstallMethod( EdgeEquivalenceClassOfElementNC, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		return EdgeEquivalenceClassesByElements(surface)[el];
	end
);
InstallMethod( EdgeEquivalenceClassOfElement, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		if not el in Edges( UnderlyingSimplicialSurface( surface ) ) then
			Error("EdgeEquivalenceClassOfElement: Edge has to lie in underlying simplicial surface.");
		fi;
		return EdgeEquivalenceClassesByElements(surface)[el];
	end
);

#!	@Description
#!	Return the face equivalence class of a given face.
#!	The NC-version doesn't check whether the given face lies in the underlying
#!	simplicial surface.
#!	@Arguments a simplicial surface with equivalence, a positive integer
#!	@Returns a set of positive integers
InstallMethod( FaceEquivalenceClassOfElementNC, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		return FaceEquivalenceClassesByElements(surface)[el];
	end
);
InstallMethod( FaceEquivalenceClassOfElement, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		if not el in Faces( UnderlyingSimplicialSurface( surface ) ) then
			Error("FaceEquivalenceClassOfElement: Face has to lie in underlying simplicial surface.");
		fi;
		return FaceEquivalenceClassesByElements(surface)[el];
	end
);

#!	@Description
#!	Return the vertex equivalence class with a given number.
#!	The NC-version doesn't check whether the given number refers to a vertex
#!	equivalence class.
#!	@Arguments a simplicial surface with equivalence, a positive integer
#!	@Returns a set of positive integers
InstallMethod( VertexEquivalenceClassByNumberNC, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		return VertexEquivalenceClassesByNumbers(surface)[el];
	end
);
InstallMethod( VertexEquivalenceClassByNumber, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		if not el in VertexEquivalenceNumbersAsSet( surface ) then
			Error("VertexEquivalenceClassByNumber: The number has to refer to a vertex equivalence class.");
		fi;
		return VertexEquivalenceClassesByNumbers(surface)[el];
	end
);

#!	@Description
#!	Return the edge equivalence class with a given number.
#!	The NC-version doesn't check whether the given number refers to a vertex
#!	equivalence class.
#!	@Arguments a simplicial surface with equivalence, a positive integer
#!	@Returns a set of positive integers
InstallMethod( EdgeEquivalenceClassByNumberNC, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		return EdgeEquivalenceClassesByNumbers(surface)[el];
	end
);
InstallMethod( EdgeEquivalenceClassByNumber, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		if not el in EdgeEquivalenceNumbersAsSet( surface ) then
			Error("EdgeEquivalenceClassByNumber: The number has to refer to a edge equivalence class.");
		fi;
		return EdgeEquivalenceClassesByNumbers(surface)[el];
	end
);

#!	@Description
#!	Return the face equivalence class with a given number.
#!	The NC-version doesn't check whether the given number refers to a vertex
#!	equivalence class.
#!	@Arguments a simplicial surface with equivalence, a positive integer
#!	@Returns a set of positive integers
InstallMethod( FaceEquivalenceClassByNumberNC, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		return FaceEquivalenceClassesByNumbers(surface)[el];
	end
);
InstallMethod( FaceEquivalenceClassByNumber, 
	"for a simplicial surface with equivalence and a positive integer",
	[IsSimplicialSurfaceWithEquivalence, IsPosInt],
	function( surface, el )
		if not el in FaceEquivalenceNumbersAsSet( surface ) then
			Error("FaceEquivalenceClassByNumber: The number has to refer to a face equivalence class.");
		fi;
		return FaceEquivalenceClassesByNumbers(surface)[el];
	end
);

##					END convenience methods
############################################################################


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

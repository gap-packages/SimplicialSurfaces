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
##	We save the equivalences not by classes but by lists. For example
##	vertexEquivalenceImage is a list that is indiced by Vertices. At each
##	position is a number and the vertices that have the same number are in
##	the same equivalence class.
##
DeclareRepresentation("IsSimplicialSurfaceWithEquivalenceByEquivalenceImageRep",
	 IsSimplicialSurfaceWithEquivalence,
     ["vertexEquivalenceImage","edgeEquivalenceImage","faceEquivalenceImage"]);

##	accompanying type
SimplicialSurfaceWithEquivalenceByEquivalenceImageType := 
    NewType( SimplicialSurfaceWithEquivalenceFamily,
			IsSimplicialSurfaceWithEquivalenceByEquivalenceImageRep );



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
				SimplicialSurfaceWithEquivalenceByEquivalenceImageType,
				rec( vertexEquivalenceImage := vertexEq,
					edgeEquivalenceImage := edgeEq, 
					faceEquivalenceImage := faceEq ) );

		SetUnderlyingSimplicialSurfaceAttributeOfSSWE( complex, surface );

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
##	Since we have several methods to convert a list of images into actual
##	equivalence classes we write it in general.
##	indices gives the bound entries of imageList
##
_SIMPLICIAL_ImageListIntoEquivalenceClasses := function( indices, imageList )
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
#! Return the vertex equivalence classes.
#! @Arguments a folding complex
#! @Returns a list of sets of positive integers
InstallMethod( 
	VertexEquivalenceClassesAttributeOfSSWE, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalenceByEquivalenceImageRep],
	function( complex )
		return _SIMPLICIAL_ImageListIntoEquivalenceClasses( 
			Vertices( UnderlyingSimplicialSurface( complex ) ),
			complex!.vertexEquivalenceImage );
	end
);
InstallMethod( VertexEquivalenceClasses, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return VertexEquivalenceClassesAttributeOfSSWE( complex );
	end
);

#! @Description
#! Return the edge equivalence classes.
#! @Arguments a folding complex
#! @Returns a list of sets of positive integers
InstallMethod( 
	EdgeEquivalenceClassesAttributeOfSSWE, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalenceByEquivalenceImageRep],
	function( complex )
		return _SIMPLICIAL_ImageListIntoEquivalenceClasses( 
			Edges( UnderlyingSimplicialSurface( complex ) ),
			complex!.edgeEquivalenceImage );
	end
);
InstallMethod( EdgeEquivalenceClasses, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return EdgeEquivalenceClassesAttributeOfSSWE( complex );
	end
);

#! @Description
#! Return the face equivalence classes.
#! @Arguments a folding complex
#! @Returns a list of sets of positive integers
InstallMethod( 
	FaceEquivalenceClassesAttributeOfSSWE, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalenceByEquivalenceImageRep],
	function( complex )
		return _SIMPLICIAL_ImageListIntoEquivalenceClasses( 
			Faces( UnderlyingSimplicialSurface( complex ) ),
			complex!.faceEquivalenceImage );
	end
);
InstallMethod( FaceEquivalenceClasses, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return FaceEquivalenceClassesAttributeOfSSWE( complex );
	end
);

#! @Description
#! Return the vertex equivalence numbers. Each vertex equivalence class has
#! a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
InstallMethod( 
	VertexEquivalenceNumbersAttributeOfSSWE, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalenceByEquivalenceImageRep],
	function( complex )
		return Set( complex!.vertexEquivalenceImage );
	end
);
InstallMethod( VertexEquivalenceNumbers, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return VertexEquivalenceNumbersAttributeOfSSWE( complex );
	end
);


#! @Description
#! Return the edge equivalence numbers. Each edge equivalence class has
#! a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
InstallMethod( 
	EdgeEquivalenceNumbersAttributeOfSSWE, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalenceByEquivalenceImageRep],
	function( complex )
		return Set( complex!.edgeEquivalenceImage );
	end
);
InstallMethod( EdgeEquivalenceNumbers, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return EdgeEquivalenceNumbersAttributeOfSSWE( complex );
	end
);


#! @Description
#! Return the face equivalence numbers. Each face equivalence class has
#! a unique number associated with it.
#! @Arguments a simplicial surface with equivalence
#! @Returns a dense list of positive integers
InstallMethod( 
	FaceEquivalenceNumbersAttributeOfSSWE, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalenceByEquivalenceImageRep],
	function( complex )
		return Set( complex!.faceEquivalenceImage );
	end
);
InstallMethod( FaceEquivalenceNumbers, 
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalence],
	function( complex )
		return FaceEquivalenceNumbersAttributeOfSSWE( complex );
	end
);


#! @Description
#! Return the simplicial surface that we get if we consider each equivalence
#! class as one point.
#! @Arguments a simplicial surface with equivalence
#! @Returns a simplicial surface
InstallMethod( QuotientSimplicialSurfaceAttributeOfSSWE,
	"for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalenceByEquivalenceImageRep],
	function( surface )
		local vertices, edges, faces, edgesByVertices, facesByEdges,
			edge, edgeClass, vertInEdge, vertNumInEdge, face, faceClass,
			edgeInFace, edgeNumInFace, unSurf;

		unSurf := UnderlyingSimplicialSurface( surface );

		vertices := VertexEquivalenceNumbers( surface );
		edges := EdgeEquivalenceNumbers( surface );
		faces := FaceEquivalenceNumbers( surface );

		edgesByVertices := [];
		for edge in edges do
			edgeClass := EdgeEquivalenceClasses( surface )[edge];
			vertInEdge := EdgesByVertices( unSurf )[ edgeClass[1] ];
			vertNumInEdge := List( vertInEdge, 
									v -> surface!.vertexEquivalenceImage[v] );
			edgesByVertices[ edge ] := Set( vertNumInEdge );
		od;

		facesByEdges := [];
		for face in faces do
			faceClass := FaceEquivalenceClasses( surface )[face];
			edgeInFace := FacesByEdges( unSurf )[faceClass[1]];
			edgeNumInFace := List( edgeInFace, 
									e -> surface!.edgeEquivalenceImage[e] );
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
	[IsSimplicialSurfaceWithEquivalenceByEquivalenceImageRep, IsPosInt, IsPosInt],
	function( complex, v1, v2 )
		return complex!.vertexEquivalenceImage[v1] = 
				complex!.vertexEquivalenceImage[v2];
	end
);

#! @Description
#! Check if two edges are equivalent.
#! @Arguments two positive integers
#! @Returns true if they are equivalent, false otherwise
InstallMethod( IsEquivalentEdge, "for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalenceByEquivalenceImageRep, IsPosInt, IsPosInt],
	function( complex, e1, e2 )
		return complex!.edgeEquivalenceImage[e1] = 
				complex!.edgeEquivalenceImage[e2];
	end
);

#! @Description
#! Check if two faces are equivalent.
#! @Arguments two positive integers
#! @Returns true if they are equivalent, false otherwise
InstallMethod( IsEquivalentFace, "for a simplicial surface with equivalence",
	[IsSimplicialSurfaceWithEquivalenceByEquivalenceImageRep, IsPosInt, IsPosInt],
	function( complex, f1, f2 )
		return complex!.faceEquivalenceImage[f1] = 
				complex!.faceEquivalenceImage[f2];
	end
);

##
##	An alternative way of comparison would be to check if they lie in the
##	same equivalence class. For our current representation this is not needed.
##


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

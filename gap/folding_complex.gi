##############################################################################
##
#W  folding_complex.gi          SimplicialSurfaces         Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##
##  The functions in this file compute with folding complexes.
##

##
##	We save the equivalences not by classes but by lists. For example
##	vertexEquivalenceImage is a list that is indiced by Vertices. At each
##	position is a number and the vertices that have the same number are in
##	the same equivalence class.
##
DeclareRepresentation("IsFoldingComplexByEquivalenceImageRep", IsFoldingComplex,
     [vertexEquivalenceImage, edgeEquivalenceImage, faceEquivalenceImage]);

##	accompanying type
FoldingComplexByEquivalenceImageType := 
    NewType( FoldingComplexFamily, IsFoldingComplexByEquivalenceImageRep );



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
_SIMPLICIAL_GenerateTrivialEquivalence := function( vertices )
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
#!	Return a folding complex that is based on the given simplicial surface. All
#!	other properties are uniquely defined if we start with an actual surface.
#!	@Arguments a simplicial surface that is an actual surface
#!	@Returns a folding complex
InstallMethod( FoldingComplex,
	"for a simplicial surface that is an actual surface",
	[IsSimplicialSurface and IsActualSurface],
	function( surface )
		local vertexEq, edgeEq, faceEq, complex;

		vertexEq := _SIMPLICIAL_GenerateTrivialEquivalence( Vertices(surface) );
		edgeEq := _SIMPLICIAL_GenerateTrivialEquivalence( Edges(surface) );
		faceEq := _SIMPLICIAL_GenerateTrivialEquivalence( Faces(surface) );

		complex := Objectify( FoldingComplexByEquivalenceImageType,
				rec( vertexEquivalenceImage := vertexEq,
					edgeEquivalenceImage := edgeEq, 
					faceEquivalenceImage := faceEq ) );

		SetUnderlyingSimplicialSurface( complex, surface );

		#TODO

		return complex;
	end
);
##	If the simplicial surface is not already known as an actual surface, we have
##	to check manually.
RedispatchOnCondition( FoldingComplex, true, [IsSimplicialSurface],
	[IsActualSurface], 0);
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
InstallMethod( VertexEquivalenceClasses, "for a folding complex",
	[IsFoldingComplexByEquivalenceImageRep],
	function( complex )
		return _SIMPLICIAL_ImageListIntoEquivalenceClasses( 
			Vertices( UnderlyingSimplicialSurface( complex ) ),
			vertexEquivalenceImage );
	end
);

#! @Description
#! Return the edge equivalence classes.
#! @Arguments a folding complex
#! @Returns a list of sets of positive integers
InstallMethod( EdgeEquivalenceClasses, "for a folding complex",
	[IsFoldingComplexByEquivalenceImageRep],
	function( complex )
		return _SIMPLICIAL_ImageListIntoEquivalenceClasses( 
			Edges( UnderlyingSimplicialSurface( complex ) ),
			edgeEquivalenceImage );
	end
);

#! @Description
#! Return the face equivalence classes.
#! @Arguments a folding complex
#! @Returns a list of sets of positive integers
InstallMethod( FaceEquivalenceClasses, "for a folding complex",
	[IsFoldingComplexByEquivalenceImageRep],
	function( complex )
		return _SIMPLICIAL_ImageListIntoEquivalenceClasses( 
			Faces( UnderlyingSimplicialSurface( complex ) ),
			faceEquivalenceImage );
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
InstallMethod( IsEquivalentVertex, "for a folding complex",
	[IsFoldingComplexByEquivalenceImageRep, IsPosInt, IsPosInt],
	function( complex, v1, v2 )
		return vertexEquivalenceImage[v1] = vertexEquivalenceImage[v2];
	end
);

#! @Description
#! Check if two edges are equivalent.
#! @Arguments two positive integers
#! @Returns true if they are equivalent, false otherwise
InstallMethod( IsEquivalentEdge, "for a folding complex",
	[IsFoldingComplexByEquivalenceImageRep, IsPosInt, IsPosInt],
	function( complex, e1, e2 )
		return edgeEquivalenceImage[e1] = edgeEquivalenceImage[e2];
	end
);

#! @Description
#! Check if two faces are equivalent.
#! @Arguments two positive integers
#! @Returns true if they are equivalent, false otherwise
InstallMethod( IsEquivalentFace, "for a folding complex",
	[IsFoldingComplexByEquivalenceImageRep, IsPosInt, IsPosInt],
	function( complex, f1, f2 )
		return faceEquivalenceImage[f1] = faceEquivalenceImage[f2];
	end
);

##
##	An alternative way of comparison would be to check if they lie in the
##	same equivalence class. We define this method in general before we
##	specialise. TODO with HasVertexEquivalenceClasses etc.
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

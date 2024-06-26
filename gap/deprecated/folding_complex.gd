#! @DoNotReadRestOfFile

##############################################################################
##
#W  folding_complex.gd          SimplicialSurfaces           Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the declaration part for the folding complexes
##	of the SimplicialSurfaces package.
##
##	A folding complex consists of the following information:
##		- a SimplicialSurface that describes the underlying structure
##		- an equivalence relation on vertices, edges and faces that describes
##			which of those are folded together
##		- a fan for each edge equivalence class, i.e. a cycle of the incident
##			faces that depends on the orientation of the edge
##		- two face sides for each face equivalence class that describe the
##			borders of this equivalence class
##

#!	@Chapter Folding complexes

DeclareCategory( "IsFoldingComplex",
					IsComponentObjectRep and IsAttributeStoringRep );


BindGlobal( "FoldingComplexFamily", 
    NewFamily("FoldingComplexFamily",  IsObject, IsFoldingComplex) );


#############################################################################
##
##
#!  @Section Constructors for folding complexes
#!
#!
#!

#!	@Description
#!	Return a folding complex that is based on the given simplicial surface. All
#!	other properties are uniquely defined if we start with an actual surface.
#!	@Arguments a simplicial surface that is an actual surface
#!	@Returns a folding complex
DeclareOperation( "FoldingComplex", 
		[IsSimplicialSurface and IsEdgesLikeSurface]);


#!	@Description
#!	Return a folding complex that is based on the given (coloured) simplicial 
#!	surface. Furthermore we give some fans in form of a list that is 
#!	indexed by the edge equivalence class numbers of the coloured simplicial 
#!	surface. If a fan is not given in this list, we try to define it
#!	uniquely by checking the surface. If this is not possible we throw an error.
#!
#!	The NC-version doesn't check if the given list consists of fans that match
#!	the surface. It also does not guarantee the internal consistency of the 
#!	resulting folding complex.
#!	@Arguments a coloured simplicial surface and a list
#!	@Returns a folding complex
DeclareOperation( "FoldingComplexByFans", 
			[IsColouredSimplicialSurface, IsList] );
DeclareOperation( "FoldingComplexByFansNC", 
			[IsColouredSimplicialSurface, IsList] );


#!	@Description
#!	Return a folding complex that is based on the given coloured simplicial 
#!	surface. Furthermore we give some fans in form of a list that is 
#!	indexed by the edge equivalence class numbers of the coloured simplicial 
#!	surface. If a fan is not given in this list, we try to define it
#!	uniquely by checking the surface. If this is not possible we throw an error.
#!	We also give a list of border pieces, i.e. a list that is indexed by the 
#!	face equivalence classes and consists of sets.
#!
#!	The NC-version doesn't check if the given lists consists of fans that match
#!	the surface or of border pieces that match the fans. It also does not
#!	guarantee the internal consistency of the resulting folding complex.
#!	@Arguments a coloured simplicial surface and two lists
#!	@Returns a folding complex
DeclareOperation( "FoldingComplexByFansAndBorders", 
			[IsColouredSimplicialSurface, IsList, IsList] );
DeclareOperation( "FoldingComplexByFansAndBordersNC", 
			[IsColouredSimplicialSurface, IsList, IsList] );



#############################################################################
##
##
#!  @Section Attributes and properties of folding complexes
#!
#!

#!	@Description
#!	Return the underlying simplicial surface of this folding complex.
#!	@Arguments a folding complex
#!	@Returns a simplicial surface
DeclareAttribute( "UnderlyingSimplicialSurface",
		IsFoldingComplex);


#!	@Description
#!	Return the underlying coloured simplicial surface of this folding 
#!	complex.
#!	@Arguments a folding complex
#!	@Returns a coloured simplicial surface
DeclareAttribute( 
	"UnderlyingColouredSimplicialSurface",
		IsFoldingComplex);

#!	@Description
#!	Return the fans of this folding complex in the form of a list that is
#!	indexed by the edge equivalence class numbers of the underlying coloured
#!	simplicial surface.
#!	@Arguments a folding complex
#!	@Returns a list of fans
DeclareAttribute( "Fans", IsFoldingComplex);


#!	@Description
#!	Return the border pieces of this folding complex in the form of a list that 
#!	is indexed by the face equivalence class numbers of the underlying 
#!	coloured simplicial surface.
#!	@Arguments a folding complex
#!	@Returns a list of sets of integers
DeclareAttribute( "BorderPieces", IsFoldingComplex);


#!	@Description
#!	Return the orientation covering of this folding complex in the form of 
#!	a simplicial surface.
#!	@Arguments a folding complex
#!	@Returns a simplicial surface
DeclareAttribute( "OrientationCovering", 
													IsFoldingComplex);


#!	@Description
#!	Return the complementary oriented surface with respect to a given fan.
#!	Given are (besides the folding complex) the edge equivalence number of the
#!	fan and the name of an oriented face.
#!
#!	@Arguments a folding complex, a positive integer, an integer
#!	@Returns an integer
KeyDependentOperation( "ComplementaryOrientedFaceAttributeOfFoldingComplex", 
	IsFoldingComplex, IsList, 
	function( list )
		if Size(list) <> 2 then
			return false;
		fi;
		return IsPosInt(list[1]) and IsInt( list[2] );
	end
);
DeclareOperation( "ComplementaryOrientedFace", 
									[IsFoldingComplex, IsPosInt, IsInt] );


#############################################################################
##
##
#!  @Section Functions for folding complexes
#!
#!
#!


#!	@Description
#!	Return the fan of an edge equivalence class of this folding complex.
#!	The NC-version doesn't check if the given number actually represents
#!	a face equivalence class.
#!	@Arguments a folding complex and a positive integer
#!	@Returns a fan
DeclareOperation( "FanOfEdgeEquivalenceClass", [IsFoldingComplex, IsPosInt] );
DeclareOperation( "FanOfEdgeEquivalenceClassNC", [IsFoldingComplex, IsPosInt] );


#!	@Description
#!	Return the border pieces of a face equivalence class of this folding 
#!	complex as a set.
#!	The NC-version doesn't check if the given number actually represents
#!	a face equivalence class.
#!	@Arguments a folding complex and a positive integer
#!	@Returns a sets of integers 
DeclareOperation( "BorderPiecesOfFaceEquivalenceClass", 
		[IsFoldingComplex, IsPosInt] );
DeclareOperation( "BorderPiecesOfFaceEquivalenceClassNC", 
		[IsFoldingComplex, IsPosInt] );

#!	@Description
#!	Apply a fan of a folding complex to an oriented face. This is defined
#!	in the following way: Each oriented face defines an orientation around
#!	the adjacent edges. The fan of this edge has a cycle for each such
#!	orientation. We return the image of the given face (not an equivalence
#!	class!) under this cycle.
#!	The NC-version doesn't check if the given numbers refer to an oriented
#!	face and an edge equivalence class.
#!	@Arguments a folding complex, a positive integer (edge class) and an 
#!		integer (the oriented face name)
#!	@Returns a positive integer
DeclareOperation( "ApplyFanToOrientedFace", 
		[IsFoldingComplex, IsPosInt, IsInt] );
DeclareOperation( "ApplyFanToOrientedFaceNC", 
		[IsFoldingComplex, IsPosInt, IsInt] );


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

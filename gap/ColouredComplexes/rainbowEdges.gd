#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2018
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

#! @Chapter Rainbow Edge colourings
#! @ChapterLabel RainbowEdgeColouring
#! 
#! In chapter <Ref Chap="Chapter_EdgeColouring"/> the concept of edge 
#! colourings was introduced in general. This chapter is concerned with
#! a specific type of edge colourings, where every edge of a given face has to
#! have a different colour (so it is a rainbow colouring on each face).
#!
#! Section TODO will introduce special access functions made possible by
#! rainbow edge colourings. In section TODO the colouring will be represented
#! by permutations.
#!
#! After these general properties, section TODO deals with a special
#! subclass of a rainbow colouring: a <E>perfect</E> rainbow colouring in
#! which the number of colours is minimal (for example, in a simplicial 
#! surface there can only be three colours). It describes a method to
#! uniquely reconstruct a coloured surface from its permutation (by 
#! introducing the MR-Type).
#!
#! Finally section TODO describes some methods to construct rainbow coloured
#! surfaces.
#!

#! @Section Definition and elementary properties
#! @SectionLabel RainbowEdgeColouring_Definition
#! This section defines the concept of rainbow edge colourings and introduces
#! several modifications to previouly existing access functions.
#! 
#! @InsertChunk Example_ColouredPrism


#! @BeginGroup IsFaceRainbowEdgeColouring
#! @Description
#! The property <K>IsFaceRainbowEdgeColouring</K>
#! checks if the colouring of the given edge coloured polygonal complex is
#! a rainbow colouring if it is restricted to the edges of a face. This is
#! the case if and only if all edges of each face have different colours.
#!
#! For each face there have to be at least as many colours as there are
#! incident edges. Therefore the maximal number of edges in a face is a lower
#! bound on the number of colours in such a colouring. If this lower bound
#! is obtained, we call the colouring <E>perfect</E>, which is checked by
#! the property <K>IsPerfectFaceRainbowEdgeColouring</K>. For a simplicial
#! surface this means that there are exactly three colours.
#!
#! @InsertChunk Example_ColouredPrism_NonPerfect
#!
#! @Arguments colComplex
DeclareProperty("IsFaceRainbowEdgeColouring", IsEdgeColouredPolygonalComplex);
#! @Arguments colComplex
DeclareProperty("IsPerfectFaceRainbowEdgeColouring", IsEdgeColouredPolygonalComplex);
#! @EndGroup
InstallTrueMethod( IsFaceRainbowEdgeColouring, IsPerfectFaceRainbowEdgeColouring );


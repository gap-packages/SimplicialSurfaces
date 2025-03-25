#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2024
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################



#! @Chapter Generating certain simplicial surfaces
#! @ChapterLabel Generating

#! This chapter introduces methods to find all simplicial surfaces with certain
#! restrictions. 
#! 

#! @Section Essential discs
#! @SectionLabel Discs_Essential


#! This section contains the methods to compute all essential simplicial discs.


#! @BeginGroup IsEssentialDisc
#! @Description
#! This function returns true if  <A>disc</A> is an essential disc and false else. A
#! simplicial surface
#! <A>disc</A> is called an <E>essential disc</E> if <A>disc</A> is a connected
#! simplicial surfaces of Euler characteristic 1  and every circular
#! vertex-edge path of length 3 bounds a face of <A>disc</A>, and every
#! boundary vertex has degree at least <A>2</A> and and no inner edge joins
#! two boundary vertices.
#!
#! @BeginExampleSession
#! gap> disc := SimplicialSurfaceByDownwardIncidence(
#! >  [ [ 1, 3 ], [ 1, 2 ], [ 2, 3 ], [ 3, 4 ], [ 1, 4 ], [ 1, 5 ], [ 1, 6 ],
#! >    [ 2, 6 ], [ 2, 7 ], [ 3, 7 ], [ 4, 7 ], [ 4, 8 ], [ 4, 5 ], [ 5, 6 ],
#! >    [ 6, 7 ], [ 7, 8 ], [ 5, 8 ] ],
#! >  [ [ 1, 2, 3 ], [ 1, 4, 5 ], [ 6, 7, 14 ], [ 2, 7, 8 ], [ 8, 9, 15 ],
#! >    [ 3, 9, 10 ], [ 4, 10, 11 ], [ 11, 12, 16 ], [ 12, 13, 17 ],
#! >    [ 5, 6, 13 ] ] );
#! simplicial surface (8 vertices, 17 edges, and 10 faces)
#! gap> IsConnectedSurface(disc);
#! true
#! gap> EulerCharacteristic(disc);
#! 1
#! gap> CounterOfVertices(disc);
#! counter of vertices ([ 2, 3, 4, 5 ] degrees, and [ 1, 2, 3, 2 ] multiplicities)
#! gap> IsEssentialDisc(disc);
#! true
#! @EndExampleSession
#! @Arguments disc
#! @Returns true or false
DeclareOperation( "IsEssentialDisc", [IsTwistedPolygonalComplex] );
#! @EndGroup

#! @BeginGroup AllSimplicialSurfacesByEssentialButterflyInsertion
#! @Description
#! This function computes representatives of the isomorphism classes of
#! all simplicial surfaces that can be obtained from
#! the input surface <A>surf</A> by an essential butterfly insertion.
#! An essential butterfly insertion is a butterfly insertion that does not
#! create a 3-waist.
#!
#! @BeginExampleSession
#! gap> surface := SimplicialSurfaceByDownwardIncidence(
#! > [ [ 1, 3 ], [ 1, 2 ], [ 2, 3 ], [ 3, 4 ], [ 1, 4 ], [ 1, 5 ], [ 1, 6 ],
#! > [ 2, 6 ], [ 2, 7 ], [ 3, 7 ], [ 3, 8 ], [ 4, 8 ], [ 4, 5 ],  [ 5, 6 ],
#! > [ 6, 7 ], [ 7, 8 ], [ 5, 8 ] ],
#! > [ [1, 2, 3], [1, 4, 5], [6, 7, 14], [2, 7, 8], [8, 9, 15],
#! > [3, 9, 10], [10, 11, 16], [4, 11, 12], [12, 13, 17], [5, 6, 13] ]);
#! simplicial surface (8 vertices, 17 edges, and 10 faces)
#! gap> IsConnectedSurface(surface);
#! true
#! gap> EulerCharacteristic(surface);
#! 1
#! gap> AllSimplicialSurfacesByEssentialButterflyInsertion(surface);
#! [ simplicial surface (9 vertices, 20 edges, and 12 faces),
#! simplicial surface (9 vertices, 20 edges, and 12 faces)
#!     , simplicial surface (9 vertices, 20 edges, and 12 faces), 
#!  simplicial surface (9 vertices, 20 edges, and 12 faces) ]
#! @EndExampleSession
#! @Arguments surface
#! @Returns a list of simplicial surfaces
DeclareOperation( "AllSimplicialSurfacesByEssentialButterflyInsertion", [IsSimplicialSurface] );
#! @EndGroup




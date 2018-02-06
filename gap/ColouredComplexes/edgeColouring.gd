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

#! @Chapter Edge colourings
#! @ChapterLabel EdgeColouring
#! 
#! This chapter is concerned with edge-coloured polygonal complexes and in
#! particular simplicial surfaces. While it defines general functionality for
#! arbitrary edge-colourings, it lays a focus on specific edge-colourings. TODO explain better
#!

#! @Section General definition
#! @SectionLabel EdgeColouring_Definition
#!
#! This section describes how an edge-colouring is implemented in the
#! <K>SimplicialSurfaces</K>-package.
#!
#! An <K>EdgeColouredPolygonalComplex</K>(TODO) consists of a polygonal complex
#! and an edge colouring. These can be accessed by the methods
#! <K>PolygonalComplex</K>(TODO) and <K>EdgeColouring</K>(TODO) respectively.
#!

#! <ManSection Label="IsEdgeColouredPolygonalComplex">
#!   <Filt Name="IsEdgeColouredPolygonalComplex" Arg="object" 
#!      Label="for IsObject" 
#!      Comm="Check whether a given object is an EdgeColouredPolygonalComplex"/>
#!   <Returns>true or false</Returns>
#!   <Description>
#!     Check if a given object is an <K>EdgeColouredPolygonalComplex</K>.
#!     This is the case if it is consists of a polygonal complex and an edge
#!     colouring, accessible by <K>PolygonalComplex</K> (TODO) and
#!     <K>EdgeColouring</K> (TODO) respectively.
#!   </Description>
#! </ManSection>

#! @BeginGroup EdgeColouredPolygonalComplex
#! Construct an edge coloured polygonal complex. The edge colouring has to be
#! given as a list <A>edgeColours</A> of positive integers. For every edge
#! <A>edge</A> in the given <A>complex</A> the entry <A>edgeColours[edge]</A>
#! contains the colour of <A>edge</A> (we encode colours by positive integers).
#!
#! For example, we can construct a colouring of a tetrahedron in the
#! following fashion.
#!
#! @InsertChunk Example_Coloured_Tetrahedron
#!
#! @BeginExampleSession
#! gap> tetra := Tetrahedron();;
#! gap> edgeColours := [1,2,3,3,2,1];
#! [ 1, 2, 3, 3, 2, 1 ]
#! gap> colComplex := EdgeColouredPolygonalComplex(tetra, edgeColours);;
#! @EndExampleSession
#!
#! The variants like <K>EdgeColouredSimplicialSurface</K> check if the given
#! <A>complex</A> satisfies the additional requirement of the method (in this
#! case it checks if <A>complex</A> is a simplicial surface).
#!
#! The NC-versions don't check whether <A>complex</A> satisfies the additional
#! requirements (rather, they will store this information in <A>complex</A>)
#! and will also not check whether the given <A>edgeColours</A> are consistent
#! with the edges of <A>complex</A>.
#!
#! @Returns an <K>EdgeColouredPolygonalComplex</K>
#! @Arguments complex, edgeColours
DeclareOperation( "EdgeColouredPolygonalComplex", [IsPolygonalComplex, IsList] );
DeclareOperation( "EdgeColouredTriangularComplex", [IsPolygonalComplex, IsList] );
DeclareOperation( "EdgeColouredRamifiedPolygonalSurface", [IsPolygonalComplex, IsList] );
DeclareOperation( "EdgeColouredRamifiedSimplicialSurface", [IsPolygonalComplex, IsList] );
DeclareOperation( "EdgeColouredPolygonalSurface", [IsPolygonalComplex, IsList] );
DeclareOperation( "EdgeColouredSimplicialSurface", [IsPolygonalComplex, IsList] );
DeclareOperation( "EdgeColouredPolygonalComplexNC", [IsPolygonalComplex, IsList] );
DeclareOperation( "EdgeColouredTriangularComplexNC", [IsPolygonalComplex, IsList] );
DeclareOperation( "EdgeColouredRamifiedPolygonalSurfaceNC", [IsPolygonalComplex, IsList] );
DeclareOperation( "EdgeColouredRamifiedSimplicialSurfaceNC", [IsPolygonalComplex, IsList] );
DeclareOperation( "EdgeColouredPolygonalSurfaceNC", [IsPolygonalComplex, IsList] );
DeclareOperation( "EdgeColouredSimplicialSurfaceNC", [IsPolygonalComplex, IsList] );
#! @EndGroup

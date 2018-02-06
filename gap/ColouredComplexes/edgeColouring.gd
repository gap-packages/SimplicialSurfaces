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
#TODO explain this using a bigger example with two different colourings
#maybe show off the feature of using GAPs capabilities?

#! @Description
#! Check if a given object is an <K>IsEdgeColouredPolygonalComplex</K>. This
#! is the case if it consists of a polygonal complex and an edge colouring,
#! accessible by <K>PolygonalComplex</K> (TODO) and <K>EdgeColouring</K> (TODO);
#! respectively.
#! @Arguments object
#! @Returns true or false
DeclareCategory( "IsEdgeColouredPolygonalComplex", IsObject );

BindGlobal( "EdgeColouredPolygonalComplexFamily",
    NewFamily("EdgeColouredPolygonalComplexFamily", IsObject, 
        IsEdgeColouredPolygonalComplex) );

#! @BeginGroup EdgeColouredPolygonalComplex
#! @Description
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
#! The NC-version does not check whether the given <A>edgeColours</A> are consistent
#! with the edges of <A>complex</A>, i.e.
#! * Does every edge of <A>complex</A> have a colour in the list 
#!   <A>edgeColours</A>?
#! * Does every bound entry of <A>edgeColours</A> corresponds to an edge of
#!   <A>complex</A>?
#!
#! @Returns an <K>EdgeColouredPolygonalComplex</K>
#! @Arguments complex, edgeColours
DeclareOperation( "EdgeColouredPolygonalComplex", [IsPolygonalComplex, IsList] );
DeclareOperation( "EdgeColouredPolygonalComplexNC", [IsPolygonalComplex, IsList] );
#! @EndGroup

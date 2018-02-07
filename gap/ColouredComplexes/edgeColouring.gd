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
#! An <K>EdgeColouredPolygonalComplex</K> 
#! (<Ref Subsect="EdgeColouredPolygonalComplex"/>) consists of a polygonal 
#! complex
#! and an edge colouring. These can be accessed by the methods
#! <K>PolygonalComplex</K> (<Ref Subsect="EdgeColouring_PolygonalComplex"/>) 
#! and <K>ColoursOfEdges</K> (<Ref Subsect="ColoursOfEdges"/>) respectively.
#!
#TODO explain this using a bigger example with two different colourings
#maybe show off the feature of using GAPs capabilities?

#TODO choose a general example where the edge list is not dense

#! @Description
#! Check if a given object is an <K>IsEdgeColouredPolygonalComplex</K>. This
#! is the case if it consists of a polygonal complex and an edge colouring,
#! accessible by <K>PolygonalComplex</K> 
#! (<Ref Subsect="EdgeColouring_PolygonalComplex"/>) and <K>ColoursOfEdges</K> 
#! (<Ref Subsect="ColoursOfEdges"/>);
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
#! * Are the entries of the list positive integers?
#!
#! @Returns an <K>EdgeColouredPolygonalComplex</K>
#! @Arguments complex, edgeColours
DeclareOperation( "EdgeColouredPolygonalComplex", [IsPolygonalComplex, IsList] );
#! @Arguments complex, edgeColours
DeclareOperation( "EdgeColouredPolygonalComplexNC", [IsPolygonalComplex, IsList] );
#! @EndGroup


#! @BeginGroup EdgeColouring_PolygonalComplex
#! @Description
#! Return the underlying polygonal complex of an edge coloured polygonal
#! complex.
#! @Returns a polygonal complex
#! @Arguments colComplex
DeclareAttribute( "PolygonalComplex", IsEdgeColouredPolygonalComplex );
#! @EndGroup


#! @BeginGroup ColoursOfEdges
#! @Description
#! The method <K>ColourOfEdge</K>(<A>colComplex</A>, <A>edge</A>) returns the
#! colour of <A>edge</A>, represented by a positive integer. The NC-version
#! does not check whether the given <A>edge</A> is an edge of the underlying
#! polygonal complex.
#!
#! The attribute <K>ColoursOfEdges</K>(<A>colComplex</A>) collects all of
#! those colours in a list that is indexed by the edge labels, i.e.
#! <K>ColoursOfEdges</K>(<A>colComplex</A>)[<A>edge</A>] 
#! = <K>ColourOfEdge</K>(<A>colComplex</A>, <A>edge</A>). All other
#! positions of this list are not bound.
#!
#! TODO example
#! @Returns a list of positive integers / a positive integer
#! @Arguments colComplex
DeclareAttribute( "ColoursOfEdges", IsEdgeColouredPolygonalComplex );
#! @Arguments colComplex, edge
DeclareOperation( "ColourOfEdge", [IsEdgeColouredPolygonalComplex, IsPosInt] );
#! @Arguments colComplex, edge
DeclareOperation( "ColourOfEdgeNC", [IsEdgeColouredPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @BeginGroup EdgesOfColours
#! @Description
#! The method <K>EdgesOfColour</K>(<A>colComplex</A>, <A>colour</A>) returns 
#! the set of all edges with colour <A>colour</A>. If a colour is not used
#! in the given edge coloured polygonal complex, the empty set is returned.
#!
#! The attribute <K>EdgesOfColours</K>(<A>colComplex</A>) collects all of
#! these sets in a list that is indexed by the colours (given as positive
#! integers), i.e. <K>EdgesOfColours</K>(<A>colComplex</A>)[<A>colour</A>]
#! = <K>EdgesOfColour</K>(<A>colComplex</A>, <A>colour</A>). All other
#! positions of this list are not bound.
#!
#! TODO example
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments colComplex
DeclareAttribute( "EdgesOfColours", IsEdgeColouredPolygonalComplex );
#! @Arguments colComplex, colour
DeclareOperation( "EdgesOfColour", [IsEdgeColouredPolygonalComplex, IsPosInt] );
#TODO is this the right way or should the wrong colour lead to an error?
#! @EndGroup

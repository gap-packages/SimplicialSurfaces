#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2019
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

#! @Chapter Navigating the incidence structure
#! @ChapterLabel Navigation
#!
#! Chapter <Ref Chap="Chapter_AccessIncidenceGeometry"/> introduces the 
#! elementary
#! access operations for the incidence geometry. But if one works with
#! those geometries in practice, one notices that some tasks are quite
#! cumbersome with those tools, for example:
#! * Given a face and an incident edge, what is the other face incident
#!   to the edge?
#! * Given a triangular face and an incident vertex, which edge is
#!   opposite to that vertex?
#! * For which pairs of adjacent vertices do both of the vertices
#!   fulfill some property?
#! 
#! All of the methods in this chapter only require a few lines of code
#! with the tools of chapter <Ref Chap="Chapter_AccessIncidenceGeometry"/>.
#! Nevertheless, having them makes programming a bit simpler as one can
#! focus on higher-order structures. In addition, each method will
#! feature an explanation how the desired result can be achieved with
#! the tools from chapter <Ref Chap="Chapter_AccessIncidenceGeometry"/>,
#! so that each user can adapt them for their own special circumstances.
#!
#! TODO overview of sections
#!
#! We will use the following polygonal complex to exemplify the methods
#! in this chapter:
#! <Alt Only="TikZ">
#!   \input{Image_EyeStone.tex}
#! </Alt>
#! @ExampleSession
#! gap> complex := PolygonalComplexByDownwardIncidence( 
#! >        [[1,2],[2,5],[2,6],[2,6],[1,6],[5,6],[1,7],[6,8],[5,9],[7,8],[8,9],
#! >         [8,12],[2,13],[12,13]],
#! >        [[1,3,5],[5,7,8,10],,[6,8,9,11],[2,4,6],[2,9,11,12,13,14]]);;
#! @EndExampleSession
#

#! @Section Moving along edges
#! @SectionLabel Navigation_Edges
#!
#! This section is concerned with movement along edges, i.e. the relation
#! between vertices and edges. It contains the following methods (illustrated
#! on the polygonal complex from the start of chapter 
#! <Ref Chap="Chapter_Navigation"/>):
#! * <K>IsVerticesAdjacent</K> (<Ref Subsect="IsVerticesAdjacent"/>) checks
#!   whether two vertices are adjacent (i.e. connected by an edge).
#! @ExampleSession
#! gap> IsVerticesAdjacent( complex, 1, 2 );
#! true
#! gap> IsVerticesAdjacent( complex, 7, 12 );
#! false
#! gap> IsVerticesAdjacent( complex, 2, 2 );
#! false
#! @EndExampleSession
#! * <K>Edge(s)BetweenVertices</K> (<Ref Subsect="EdgesBetweenVertices"/>)
#!   returns the edge (or edges) between two vertices.
#! @ExampleSession
#! gap> EdgeBetweenVertices( complex, 1, 2 );
#! 1
#! gap> EdgesBetweenVertices( complex, 1, 2 );
#! [ 1 ]
#! gap> EdgeBetweenVertices( complex, 2, 6 );
#! fail
#! gap> EdgesBetweenVertices( complex, 2, 6 );
#! [ 3, 4 ]
#! gap> EdgeBetweenVertices( complex, 7, 9 );
#! fail
#! gap> EdgesBetweenVertices( complex, 7, 9 );
#! [  ]
#! @EndExampleSession
#! * <K>OtherVertexOfEdge</K> (<Ref Subsect="OtherVertexOfEdge"/>) takes
#!   an edge and an incident vertex and returns the other incident vertex
#!   of the given edge.
#! @ExampleSession
#! gap> OtherEdgeOfVertexInFace( complex, 1, 5, 2 );
#! 7
#! @EndExampleSession
#

#! @BeginGroup IsVerticesAdjacent
#! @Description
#! The method <K>IsVerticesAdjacent</K> checks whether two given vertices
#! of a VEF-complex are adjacent, i.e. whether they are connected by an
#! edge.
#! 
#! The NC-version does not check whether <A>v1</A> and <A>v2</A> are vertices
#! of the given
#! VEF-complex.
#! 
#! As an example consider the polygonal complex from the start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#! <Alt Only="TikZ">
#!   \input{Image_EyeStone.tex}
#! </Alt>
#! @ExampleSession
#! gap> IsVerticesAdjacent( complex, 1, 2 );
#! true
#! gap> IsVerticesAdjacent( complex, 7, 12 );
#! false
#! gap> IsVerticesAdjacent( complex, 2, 2 );
#! false
#! gap> IsVerticesAdjacent( complex, 2, 6 );
#! true
#! @EndExampleSession
#!
#! This method can be implemented with the methods from chapter
#! <Ref Chap="Chapter_AccessIncidenceGeometry"/>:
#! @LogSession
#! gap> Set([v1,v2]) in VerticesOfEdges(complex);
#! @EndLogSession
#!
#! @Returns <K>true</K> or <K>false</K>
#! @Arguments complex, v1, v2
DeclareOperation("IsVerticesAdjacent", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, v1, v2
DeclareOperation("IsVerticesAdjacentNC", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @EndGroup



#! @BeginGroup EdgesBetweenVertices
#! @Description
#! The method <K>EdgesBetweenVertices</K> returns the set of all edges that
#! are incident to both given vertices
#! of a VEF-complex. If there is exactly one edge incident to both vertices,
#! <K>EdgeBetweenVertices</K> directly returns this edge (or <K>fail</K> if
#! this is not the case).
#! 
#! The NC-versions do not check whether <A>v1</A> and <A>v2</A> are vertices
#! of the given
#! VEF-complex.
#! 
#! As an example consider the polygonal complex from the start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#! <Alt Only="TikZ">
#!   \input{Image_EyeStone.tex}
#! </Alt>
#! @ExampleSession
#! gap> EdgeBetweenVertices( complex, 1, 2 );
#! 1
#! gap> EdgesBetweenVertices( complex, 1, 2 );
#! [ 1 ]
#! gap> EdgeBetweenVertices( complex, 2, 6 );
#! fail
#! gap> EdgesBetweenVertices( complex, 2, 6 );
#! [ 3, 4 ]
#! gap> EdgeBetweenVertices( complex, 7, 9 );
#! fail
#! gap> EdgesBetweenVertices( complex, 7, 9 );
#! [  ]
#! @EndExampleSession
#!
#! The method <K>EdgesBetweenVertices</K> can be implemented with the 
#! methods from chapter
#! <Ref Chap="Chapter_AccessIncidenceGeometry"/>:
#! @LogSession
#! gap> Intersection( EdgesOfVertex(complex,v1), EdgesOfVertex(complex,v2) );
#! @EndLogSession
#!
#! @Returns A set of edges
#! @Arguments complex, v1, v2
DeclareOperation("EdgesBetweenVertices", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, v1, v2
DeclareOperation("EdgesBetweenVerticesNC", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Returns An edge or <K>fail</K>
#! @Arguments complex, v1, v2
DeclareOperation("EdgeBetweenVertices", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, v1, v2
DeclareOperation("EdgeBetweenVerticesNC", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @EndGroup


#! @BeginGroup OtherVertexOfEdge
#! @Description
#! Every edge in a polygonal complex is incident to exactly two vertices.
#! Given one of them, this method returns the other one. For a bend 
#! polygonal complex, an edge might only be incident to one vertex. This
#! method will return the same vertex if it is given.
#! 
#! The NC-version does not check whether the given <A>edge</A> is an edge of 
#! the
#! VEF-complex and whether the given <A>vertex</A> is incident to it.
#! 
#! As an example consider the polygonal complex that was introduced at the
#! start of chapter
#! <Ref Chap="Chapter_AccessIncidenceGeometry"/>:
#! <Alt Only="TikZ">
#!   \input{Image_EyeStone.tex}
#! </Alt>
#! @ExampleSession
#! gap> OtherVertexOfEdge(complex, 7, 10);
#! 8
#! gap> OtherVertexOfEdge(complex, 1, 5);
#! 6
#! gap> OtherVertexOfEdge(complex, 6, 8);
#! 8
#! @EndExampleSession
#! 
#! This method can be implemented with the 
#! methods from chapter
#! <Ref Chap="Chapter_AccessIncidenceGeometry"/>. We only give the
#! implementation for polygonal complexes, since the implementation 
#! for bend polygonal complexes only includes an additional case
#! distinction.
#! @LogSession
#! gap> Difference( VerticesOfEdge(complex, edge), [ vertex ] )[1];
#! @EndLogSession
#!
#! @Returns a positive integer
#! @Arguments complex, vertex, edge
DeclareOperation("OtherVertexOfEdge", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, vertex, edge
DeclareOperation("OtherVertexOfEdgeNC", 
        [IsVEFComplex, IsPosInt, IsPosInt]);
#! @EndGroup



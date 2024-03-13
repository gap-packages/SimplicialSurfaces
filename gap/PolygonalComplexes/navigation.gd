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
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
#! of a twisted polygonal complex are adjacent, i.e. whether they are connected by an
#! edge.
#! 
#! The NC-version does not check whether <A>v1</A> and <A>v2</A> are vertices
#! of the given
#! twisted polygonal complex.
#! 
#! As an example consider the polygonal complex from the start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
DeclareOperation("IsVerticesAdjacent", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, v1, v2
DeclareOperation("IsVerticesAdjacentNC", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @EndGroup



#! @BeginGroup EdgesBetweenVertices
#! @Description
#! The method <K>EdgesBetweenVertices</K> returns the set of all edges that
#! are incident to both given vertices
#! of a twisted polygonal complex. If there is exactly one edge incident to both vertices,
#! <K>EdgeBetweenVertices</K> directly returns this edge (or <K>fail</K> if
#! this is not the case).
#! 
#! The NC-versions do not check whether <A>v1</A> and <A>v2</A> are vertices
#! of the given
#! twisted polygonal complex.
#! 
#! As an example consider the polygonal complex from the start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
#! <Ref Chap="Chapter_Navigation"/>:
#! @LogSession
#! gap> Intersection( EdgesOfVertex(complex,v1), EdgesOfVertex(complex,v2) );
#! @EndLogSession
#!
#! @Returns A set of edges
#! @Arguments complex, v1, v2
DeclareOperation("EdgesBetweenVertices", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, v1, v2
DeclareOperation("EdgesBetweenVerticesNC", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Returns An edge or <K>fail</K>
#! @Arguments complex, v1, v2
DeclareOperation("EdgeBetweenVertices", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, v1, v2
DeclareOperation("EdgeBetweenVerticesNC", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @EndGroup


#! @BeginGroup OtherVertexOfEdge
#! @Description
#! Every edge in a polygonal complex is incident to exactly two vertices.
#! Given one of them, this method returns the other one. For a twisted 
#! polygonal complex, an edge might only be incident to one vertex. This
#! method will return the same vertex if it is given.
#! 
#! The NC-version does not check whether the given <A>edge</A> is an edge of 
#! the
#! twisted polygonal complex and whether the given <A>vertex</A> is incident to it.
#! 
#! As an example consider the polygonal complex that was introduced at the
#! start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
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
#! for twisted polygonal complexes only includes an additional case
#! distinction.
#! @LogSession
#! gap> Difference( VerticesOfEdge(complex, edge), [ vertex ] )[1];
#! @EndLogSession
#!
#! @Returns a positive integer
#! @Arguments complex, vertex, edge
DeclareOperation("OtherVertexOfEdge", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, vertex, edge
DeclareOperation("OtherVertexOfEdgeNC", 
        [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @EndGroup



#! @Section Moving within a face
#! @SectionLabel Navigation_WithinFaces
#!
#! This section is concerned with the movement within a face, i.e. the 
#! computation of related elements in a fixed face. This includes the
#! following methods (illustrated with the polygonal complex from the
#! start of chapter
#! <Ref Chap="Chapter_Navigation"/>):
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! * <K>EdgeInFaceByVertices</K> (<Ref Subsect="EdgeInFaceByVertices"/>)
#!   returns the edge of a face that is incident to two vertices (and 
#!   <K>fail</K> otherwise).
#! @ExampleSession
#! gap> EdgeInFaceByVertices( complex, 5, [2,6] );
#! 4
#! gap> EdgeInFaceByVertices( complex, 4, [6,9] );
#! fail
#! @EndExampleSession
#! * <K>OtherEdgeOfVertexInFace</K> (<Ref Subsect="OtherEdgeOfVertexInFace"/>)
#!   is given a vertex, an edge, and a face (all of them incident). It returns
#!   the other edge incident to both the vertex and the face (or <K>fail</K>).
#! @ExampleSession
#! gap> OtherEdgeOfVertexInFace( complex, 1, 5, 2 );
#! 7
#! @EndExampleSession
#! * <K>OppositeVertexOfEdgeInTriangle</K>
#!   (<Ref Subsect="OppositeVertexOfEdgeInTriangle"/>) is given an edge
#!   and an incident face (which has to be a triangle) and returns the
#!   unique vertex that is incident to the face but not to the edge.
#!   Currently, this is only supported for polygonal complexes.
#! @ExampleSession
#! gap> OppositeVertexOfEdgeInTriangle( complex, 3, 1 );
#! 1
#! @EndExampleSession
#! * <K>OppositeEdgeOfVertexInTriangle</K>
#!   (<Ref Subsect="OppositeEdgeOfVertexInTriangle"/>) is given a vertex
#!   and an incident face (which has to be a triangle) and returns the unique
#!   edge that is incident to the face but not to the vertex.
#!   Currently, this is only supported for polygonal complexes.
#! @ExampleSession
#! gap> OppositeEdgeOfVertexInTriangle( complex, 5, 5 );
#! 4
#! @EndExampleSession
#!  
#


#! @BeginGroup EdgeInFaceByVertices
#! @Description
#! If the method <K>EdgeInFaceByVertices</K> is given a face and a list of 
#! two vertices of a twisted polygonal complex, it returns the 
#! edge that
#! lies in the given face and is incident to the given vertices, if possible.
#! 
#! If there is no such edge (because the given vertices are not incident to
#! the given face or because they are not connected by an edge of the face),
#! or if there are several of these edges (this might happen for twisted polygonal
#! complexes)
#! it returns <K>fail</K>.
#!
#! The method <K>EdgesInFaceByVertices</K> takes the same arguments but
#! returns the set of all edges fulfilling this specification.
#! 
#! The NC-versions do not check if <A>face</A> is a face of the given
#! twisted polygonal complex.
#! 
#! As an example consider the polygonal complex from the start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> EdgeInFaceByVertices(complex, 5, [2,6]);
#! 4
#! gap> EdgeInFaceByVertices(complex, 1, [2,1]);
#! 1
#! gap> EdgeInFaceByVertices(complex, 1, [2,6]);
#! 3
#! gap> EdgeInFaceByVertices(complex, 2, [1,2]);
#! fail
#! gap> EdgeInFaceByVertices(complex, 4, [5,8]);
#! fail
#! @EndExampleSession
#!
#! The method <K>EdgesInFaceByVertices</K> can be implemented with the
#! methods of chapter <Ref Chap="Chapter_AccessIncidenceGeometry"/>:
#! @LogSession
#! gap> Intersection( EdgesOfFace(complex, face), 
#! >      EdgesOfVertex(complex, verts[1]), EdgesOfVertex(complex, verts[2]) );
#! @EndLogSession
#!
#! @Returns a positive integer or <K>fail</K>
#! @Arguments complex, face, verts
DeclareOperation("EdgeInFaceByVertices", [IsTwistedPolygonalComplex, IsPosInt, IsList]);
#! @Arguments complex, face, verts
DeclareOperation("EdgeInFaceByVerticesNC", 
        [IsTwistedPolygonalComplex, IsPosInt, IsList]);
#! @Returns a set of positive integers
#! @Arguments complex, face, verts
DeclareOperation("EdgesInFaceByVertices", [IsTwistedPolygonalComplex, IsPosInt, IsList]);
#! @Arguments complex, face, verts
DeclareOperation("EdgesInFaceByVerticesNC", 
        [IsTwistedPolygonalComplex, IsPosInt, IsList]);
#! @EndGroup


#! @BeginGroup OtherEdgeOfVertexInFace
#! @Description
#! If the method <K>OtherEdgeOfVertexInFace</K> is given a vertex, an edge,
#! and a face of a twisted polygonal complex, it returns the other edge incident to the
#! vertex and the face, if possible.
#!
#! For a twisted polygonal complex it might happen that only one or more than 
#! two edges are
#! incident to both vertex and face. In this case <K>fail</K> is returned.
#! 
#! The method <K>OtherEdgesOfVertexInFace</K> returns the set of all edges
#! satisfying this restriction.
#! 
#! The NC-version does not check whether the given vertex, edge, and face
#! actually lie in the complex and are incident to each other.
#! 
#! As an example consider the polygonal complex that was introduced at the
#! start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> OtherEdgeOfVertexInFace(complex, 1, 5, 2);
#! 7
#! gap> OtherEdgeOfVertexInFace(complex, 5, 9, 4);
#! 6
#! gap> OtherEdgeOfVertexInFace(complex, 1, 5, 1);
#! 1
#! @EndExampleSession
#!
#! The method <K>OtherEdgesOfVertexInFace</K> can be implemented with
#! the methods of chapter
#! <Ref Chap="Chapter_AccessIncidenceGeometry"/>:
#! @LogSession
#! gap> Difference( Intersection( EdgesOfFace(complex, face), 
#! >                     EdgesOfVertex(complex, vertex) ), [ edge ] );
#! @EndLogSession
#!
#! @Returns a positive integer or <K>fail</K>
#! @Arguments complex, vertex, edge, face
DeclareOperation("OtherEdgeOfVertexInFace", 
        [IsTwistedPolygonalComplex, IsPosInt, IsPosInt, IsPosInt]);
#! @Arguments complex, vertex, edge, face
DeclareOperation("OtherEdgeOfVertexInFaceNC",
        [IsTwistedPolygonalComplex, IsPosInt, IsPosInt, IsPosInt]);
#! @Returns a set of positive integers
#! @Arguments complex, vertex, edge, face
DeclareOperation("OtherEdgesOfVertexInFace", 
        [IsTwistedPolygonalComplex, IsPosInt, IsPosInt, IsPosInt]);
#! @Arguments complex, vertex, edge, face
DeclareOperation("OtherEdgesOfVertexInFaceNC",
        [IsTwistedPolygonalComplex, IsPosInt, IsPosInt, IsPosInt]);
#! @EndGroup


#! @BeginGroup OppositeVertexOfEdgeInTriangle
#! @Description
#! If the method <K>OppositeVertexOfEdgeInTriangle</K> is given an edge and
#! a face of a polygonal complex, such that the edge is incident to the face 
#! and
#! the face is a triangle, then it returns the unique vertex incident to the
#! face, but not the edge.
#!
#! The NC-version does not check whether the given edge and face
#! actually lie in the complex, are incident to each other and whether
#! the given face is a triangle.
#! 
#! As an example consider the polygonal complex that was introduced at the
#! start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> OppositeVertexOfEdgeInTriangle( complex, 1, 1 );
#! 6
#! gap> OppositeVertexOfEdgeInTriangle( complex, 3, 1 );
#! 1
#! gap> OppositeVertexOfEdgeInTriangle( complex, 5, 1 );
#! 2
#! gap> OppositeVertexOfEdgeInTriangle( complex, 2, 5 );
#! 6
#! gap> OppositeVertexOfEdgeInTriangle( complex, 4, 5 );
#! 5
#! gap> OppositeVertexOfEdgeInTriangle( complex, 6, 5 );
#! 2
#! @EndExampleSession
#!
#! This method can be implemented with
#! the methods of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#! @LogSession
#! gap> Difference( VerticesOfFace(complex,face), VerticesOfEdge(complex,edge) );
#! @EndLogSession
#!
#! @Returns a positive integer
#! @Arguments complex, edge, face
DeclareOperation("OppositeVertexOfEdgeInTriangle",
    [IsPolygonalComplex, IsPosInt, IsPosInt]);
DeclareOperation("OppositeVertexOfEdgeInTriangleNC",
    [IsPolygonalComplex, IsPosInt, IsPosInt]);
#! @EndGroup


#! @BeginGroup OppositeEdgeOfVertexInTriangle
#! @Description
#! If the method <K>OppositeEdgeOfVertexInTriangle</K> is given a vertex and
#! a face of a polygonal complex, such that the vertex is incident to the face 
#! and
#! the face is a triangle, then it returns the unique edge incident to the
#! face, but not the vertex.
#!
#! The NC-version does not check whether the given vertex and face
#! actually lie in the complex, are incident to each other and whether
#! the given face is a triangle.
#! 
#! As an example consider the polygonal complex that was introduced at the
#! start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> OppositeEdgeOfVertexInTriangle( complex, 1, 1 );
#! 3
#! gap> OppositeEdgeOfVertexInTriangle( complex, 2, 1 );
#! 5
#! gap> OppositeEdgeOfVertexInTriangle( complex, 6, 1 );
#! 1
#! gap> OppositeEdgeOfVertexInTriangle( complex, 2, 5 );
#! 6
#! gap> OppositeEdgeOfVertexInTriangle( complex, 5, 5 );
#! 4
#! gap> OppositeEdgeOfVertexInTriangle( complex, 6, 5 );
#! 2
#! @EndExampleSession
#!
#! This method can be implemented with
#! the methods of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#! @LogSession
#! gap> Difference( EdgesOfFace(complex,face), EdgesOfVertex(complex,vertex) );
#! @EndLogSession
#!
#! @Returns a positive integer
#! @Arguments complex, vertex, face
DeclareOperation("OppositeEdgeOfVertexInTriangle",
    [IsPolygonalComplex, IsPosInt, IsPosInt]);
DeclareOperation("OppositeEdgeOfVertexInTriangleNC",
    [IsPolygonalComplex, IsPosInt, IsPosInt]);
#! @EndGroup



#! @Section Moving between faces
#! @SectionLabel Navigation_BetweenFaces
#! 
#! This section contains methods for the movement between faces, i.e.
#! whether faces are adjacent and, if so, by which edge. It includes the
#! following methods (illustrated on the polygonal complex
#! from the start of chapter <Ref Chap="Chapter_Navigation"/>):
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!
#! * <K>IsFacesAdjacent</K> (<Ref Subsect="IsFacesAdjacent"/>) checks whether
#!   two faces are adjacent (i.e. if they are different but there is an 
#!   edge incident to both).
#! @ExampleSession
#! gap> IsFacesAdjacent( complex, 1, 2 );
#! true
#! gap> IsFacesAdjacent( complex, 1, 4 );
#! false
#! @EndExampleSession
#! * <K>Edge(s)BetweenFaces</K> (<Ref Subsect="EdgesBetweenFaces"/>) returns
#!   the edge (or edges) between two faces.
#! @ExampleSession
#! gap> EdgeBetweenFaces( complex, 2, 4 );
#! 8
#! gap> EdgesBetweenFaces( complex, 2, 4 );
#! [ 8 ]
#! gap> EdgeBetweenFaces( complex, 4, 6 );
#! fail
#! gap> EdgesBetweenFaces( complex, 4, 6 );
#! [ 9, 11 ]
#! gap> EdgeBetweenFaces( complex, 2, 5 );
#! fail
#! gap> EdgesBetweenFaces( complex, 2, 5 );
#! [  ]
#! @EndExampleSession
#! * <K>NeighbourFace(s)ByEdge</K> (<Ref Subsect="NeighbourFaceByEdge"/>) returns
#!   the face (or the set of faces) that is adjacent to the
#!   given face (with respect to the given edge).
#! @ExampleSession
#! gap> NeighbourFaceByEdge( complex, 2, 8 );
#! 4
#! gap> NeighbourFacesByEdge( complex, 2, 8 );
#! [ 4 ]
#! @EndExampleSession


#! @BeginGroup IsFacesAdjacent
#! @Description
#! The method <K>IsFacesAdjacent</K> checks whether two given faces
#! of a twisted polygonal complex are adjacent, i.e. whether they are connected by an
#! edge.
#! 
#! The NC-version does not check whether <A>f1</A> and <A>f2</A> are faces
#! of the given
#! twisted polygonal complex.
#! 
#! As an example consider the polygonal complex from the start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> IsFacesAdjacent( complex, 1, 2 );
#! true
#! gap> IsFacesAdjacent( complex, 1, 4 );
#! false
#! gap> IsFacesAdjacent( complex, 2, 2 );
#! false
#! gap> IsFacesAdjacent( complex, 4, 5 );
#! true
#! @EndExampleSession
#!
#! This method can be implemented with the methods from chapter
#! <Ref Chap="Chapter_AccessIncidenceGeometry"/>:
#! @LogSession
#! gap> Set([f1,f2]) in FacesOfEdges(complex);
#! @EndLogSession
#!
#! @Returns <K>true</K> or <K>false</K>
#! @Arguments complex, f1, f2
DeclareOperation("IsFacesAdjacent", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, f1, f2
DeclareOperation("IsFacesAdjacentNC", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @EndGroup



#! @BeginGroup EdgesBetweenFaces
#! @Description
#! The method <K>EdgesBetweenFaces</K> returns the set of all edges that
#! are incident to both given faces
#! of a twisted polygonal complex. If there is exactly one edge incident to both faces,
#! <K>EdgeBetweenFaces</K> directly returns this edge (or <K>fail</K> if
#! this is not the case).
#! 
#! The NC-versions do not check whether <A>f1</A> and <A>f2</A> are faces
#! of the given
#! twisted polygonal complex.
#! 
#! As an example consider the polygonal complex from the start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> EdgeBetweenFaces( complex, 2, 4 );
#! 8
#! gap> EdgesBetweenFaces( complex, 2, 4 );
#! [ 8 ]
#! gap> EdgeBetweenFaces( complex, 4, 6 );
#! fail
#! gap> EdgesBetweenFaces( complex, 4, 6 );
#! [ 9, 11 ]
#! gap> EdgeBetweenFaces( complex, 2, 5 );
#! fail
#! gap> EdgesBetweenFaces( complex, 2, 5 );
#! [  ]
#! @EndExampleSession
#!
#! The method <K>EdgesBetweenFaces</K> can be implemented with the 
#! methods from chapter
#! <Ref Chap="Chapter_Navigation"/>:
#! @LogSession
#! gap> Intersection( EdgesOfFace(complex,f1), EdgesOfFace(complex,f2) );
#! @EndLogSession
#!
#! @Returns A set of edges
#! @Arguments complex, f1, f2
DeclareOperation("EdgesBetweenFaces", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, f1, f2
DeclareOperation("EdgesBetweenFacesNC", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Returns An edge or <K>fail</K>
#! @Arguments complex, f1, f2
DeclareOperation("EdgeBetweenFaces", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, f1, f2
DeclareOperation("EdgeBetweenFacesNC", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @EndGroup


#! @BeginGroup NeighbourFaceByEdge
#! @Description
#! If the method <K>NeighbourFacesByEdge</K> is given a face and an edge, it
#! returns the set of all faces that are also incident to this edge. In a
#! polygonal complex, these have to be different from the given face. In a
#! twisted polygonal complex, this might not be the case.
#! 
#! If the set of these neighbours contains exactly one face, this face
#! is returned by <K>NeighbourFaceByEdge</K>. Otherwise, this method
#! returns <K>fail</K>.
#! 
#! The NC-version does not check whether the given <A>edge</A> is an edge of
#! the polygonal complex and whether the given <A>face</A> is an incident face
#! of the complex.
#! 
#! As an example consider the polygonal complex that was introduced at the
#! start of chapter <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> NeighbourFaceByEdge(complex, 2, 8);
#! 4
#! gap> NeighbourFaceByEdge(complex, 1, 5);
#! 2
#! gap> NeighbourFaceByEdge(complex, 4, 6);
#! 5
#! gap> NeighbourFaceByEdge(complex, 1, 3);
#! fail
#! gap> NeighbourFaceByEdge(complex, 6, 12);
#! fail
#! @EndExampleSession
#!
#! 
#! This method can be implemented with the 
#! methods from chapter
#! <Ref Chap="Chapter_AccessIncidenceGeometry"/>. We only give the
#! implementation for polygonal complexes, since the implementation 
#! for twisted polygonal complexes only includes an additional case
#! distinction.
#! @LogSession
#! gap> Difference( FacesOfEdge(complex, edge), [ face ] )[1];
#! @EndLogSession
#! 
#!
#! @Returns a positive integer or <K>fail</K>
#! @Arguments complex, face, edge
DeclareOperation("NeighbourFaceByEdge", 
        [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, face, edge
DeclareOperation("NeighbourFaceByEdgeNC",
        [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Returns a set of positive integers
#! @Arguments complex, face, edge
DeclareOperation("NeighbourFacesByEdge", 
        [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, face, edge
DeclareOperation("NeighbourFacesByEdgeNC",
        [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @EndGroup



#! @Section Localising subconfigurations with special properties
#! @SectionLabel Navigation_Subconfigurations
#!
#! In many cases it is necessary to find all vertices fulfilling a
#! certain property. Consider the polygonal complex from the start
#! of chapter <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! If we want to know all vertices that are incident to exactly three or four
#! faces, we can use the <K>Filtered</K>-command.
#! @ExampleSession
#! gap> Filtered( Vertices(complex), v -> FaceDegreeOfVertex(complex,v) in [3, 4] );
#! [ 2, 5, 6, 8 ]
#! @EndExampleSession
#! While this is a good method to find vertices, edges and faces with 
#! individual properties, it quickly becomes complicated if one searches
#! for more complicated structures.
#!
#! For example, assume we are interested in all edges, whose incident vertices
#! are both incident to three or four faces. We could write a function to
#! check this property:
#! @ExampleSession
#! gap> Is34Edge := function( complex, edge )
#! >      local vertices;
#! > 
#! >      vertices := VerticesOfEdge(complex, edge);
#! >      return FaceDegreeOfVertex(complex, vertices[1]) in [3,4] and 
#! >         FaceDegreeOfVertex(complex, vertices[2]) in [3,4];
#! >    end;
#! function( complex, edge ) ... end
#! gap> Filtered( Edges(complex), e -> Is34Edge(complex, e) );
#! [ 2, 3, 4, 6, 8 ]
#! @EndExampleSession
#!
#! With the knowledge how sublists can be produced, the condition can be
#! expressed more succintly:
#! @ExampleSession
#! gap> edge := 8;;
#! gap> vertices := VerticesOfEdge(complex, edge);
#! [ 6, 8 ]
#! gap> FaceDegreesOfVertices(complex){vertices};
#! [ 4, 3 ]
#! gap> IsSubset( [3,4], Set(last) );
#! true
#! @EndExampleSession
#!
#! Then a single <K>Filtered</K>-command could be used as well.
#! @ExampleSession
#! gap> Filtered( Edges(complex), e -> 
#! >      IsSubset( [3,4], 
#! >        Set(FaceDegreesOfVertices(complex){ VerticesOfEdge(complex, e) } ) 
#! >    ) );
#! [ 2, 3, 4, 6, 8 ]
#! @EndExampleSession
#! 
#! But even though this is technically a one-liner, it is still quite
#! complicated for a rather simple-seeming task. 
#! Therefore this section contains some methods to simplify
#! some of these situations.
#! 
#! Unfortunately, many special situations will still require writing
#! custom functions, as there is (as of yet) no way to test for arbitrary
#! substructures with arbitrary properties.
#!
#! This section contains the following shortcuts:
#! * Localising adjacent vertices fulfilling certain properties. These
#!   may be returned as pairs of vertices 
#!   (<K>AdjacentVerticesWithProperties</K>, see 
#!   <Ref Subsect="AdjacentVerticesWithProperties"/>) or as edges
#!   (<K>EdgesWithVertexProperties</K>, see
#!   <Ref Subsect="EdgesWithVertexProperties"/>).
#! * Localising faces whose vertices (or edges) fulfill certain properties.
#!   The available methods are <K>FacesWithVertexProperties</K>
#!   (<Ref Subsect="FacesWithVertexProperties"/>) and
#!   <K>FacesWithEdgeProperties</K> 
#!   (<Ref Subsect="FacesWithEdgeProperties"/>).
#! 

#! @BeginGroup AdjacentVerticesWithProperties
#! @Description
#! For a given twisted polygonal complex <A>complex</A> the method 
#! <K>AdjacentVerticesWithProperties</K>(<A>complex</A>, <A>prop1</A>, <A>prop2</A>)
#! returns all pairs of vertices <M>[v_1,v_2]</M> such that <M>v_1</M>
#! fulfills property <A>prop1</A> and <M>v_2</M> fulfills property
#! <A>prop2</A>.
#! 
#! The two properties can be given as list [<A>prop1</A>, <A>prop2</A>] as 
#! well.
#!
#! A property can be given in two ways (otherwise an error will be thrown);
#! * As a function <A>prop</A> with two arguments. Then, for a given vertex 
#!   <M>v</M>, it is checked whether <A>prop</A>(<A>complex</A>, <M>v</M>)
#!   is <K>true</K>.
#! * As a function <A>prop</A> with one argument. Then, for a given vertex
#!   <M>v</M>, it is checked whether <A>prop</A>(<M>v</M>) is <K>true</K>.
#!   In particular, it is assumed that the given function depends on
#!   <A>complex</A> (otherwise there can be strange results).
#!
#! For the alternative method <K>AdjacentVerticesWithProperty</K> there are
#! two differences:
#! * Both vertices have to fulfill the same property
#! * If <M>[v_1,v_2]</M> is a valid answer, then <M>[v_2,v_1]</M> also would
#!   be. Therefore only the smaller one of these is returned.
#!
#! 
#! As an example consider the polygonal complex that was introduced at the
#! start of chapter <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> AdjacentVerticesWithProperty(complex, 
#! >      v -> FaceDegreeOfVertex(complex,v) = 3);
#! [ [ 2, 5 ] ]
#! gap> VertexNotIncidentToTriangle := function(complex, vertex)
#! >      local faces;
#! > 
#! >      faces := FacesOfVertex(complex, vertex);
#! >      return ForAll( faces, f -> Length(EdgesOfFace(complex,f)) <> 3 );
#! > end;;
#! gap> AdjacentVerticesWithProperty( complex, VertexNotIncidentToTriangle );
#! [ [ 7, 8 ], [ 8, 9 ], [ 8, 12 ], [ 12, 13 ] ]
#! gap> 
#! gap> AdjacentVerticesWithProperties( complex, 
#! >      v -> FaceDegreeOfVertex(complex, v) = 2,
#! >      v -> FaceDegreeOfVertex(complex, v) = 3);
#! [ [ 1, 2 ], [ 9, 5 ], [ 9, 8 ] ]
#! gap> AdjacentVerticesWithProperties(complex, VertexNotIncidentToTriangle,
#! >      v -> IsInnerVertex(complex, v));
#! [ [ 8, 9 ], [ 9, 5 ] ]
#! @EndExampleSession
#!
#! Note for efficient computations: The only way to provide a general method
#! like <K>AdjacentVerticesWithProperties</K> is by wrapping the properties
#! into functions. Unfortunately, calling a function introduces an overhead.
#! In particular, if the executed instructions are very fast (for example a
#! small computation or a list lookup), then the overhead by the function
#! call may be as time intensive as the actual computation. Therefore, if
#! high efficiency is required and the functionality of this method is time
#! critical, it is probably more efficient to manually implement the 
#! functionality into the code.
#!
#! 
#! @Returns a set of tuples of positive integers
#! @Arguments complex, prop1, prop2
DeclareOperation("AdjacentVerticesWithProperties", 
        [IsTwistedPolygonalComplex, IsFunction, IsFunction]);
#! @Arguments complex, propList
DeclareOperation("AdjacentVerticesWithProperties", 
        [IsTwistedPolygonalComplex, IsList]);
#! @Returns a set of ordered tuples of positive integers
#! @Arguments complex, prop
DeclareOperation("AdjacentVerticesWithProperty", 
        [IsTwistedPolygonalComplex, IsFunction]);
#! @EndGroup


#! @BeginGroup EdgesWithVertexProperties
#! @Description
#! For a given twisted polygonal complex <A>complex</A> the method 
#! <K>EdgesWithVertexProperty</K>(<A>complex</A>, <A>prop</A>) returns
#! the set of all edges such that both of its vertices fulfill property 
#! <A>prop</A>.
#!
#! A property can be given in two ways (otherwise an error will be thrown);
#! * As a function <A>prop</A> with two arguments. Then, for a given vertex 
#!   <M>v</M>, it is checked whether <A>prop</A>(<A>complex</A>, <M>v</M>)
#!   is <K>true</K>.
#! * As a function <A>prop</A> with one argument. Then, for a given vertex
#!   <M>v</M>, it is checked whether <A>prop</A>(<M>v</M>) is <K>true</K>.
#!   In particular, it is assumed that the given function depends on
#!   <A>complex</A> (otherwise there can be strange results).
#!
#! The alternative method 
#! <K>EdgesWithVertexProperties</K>(<A>complex</A>, <A>prop1</A>, <A>prop2</A>)
#! returns the set of all edges such that one of the incident vertices in the
#! edge fulfills <A>prop1</A> and the other fulfills property <A>prop2</A>.
#!
#! The two properties can be given as list [<A>prop1</A>, <A>prop2</A>] as 
#! well.
#!
#! 
#! As an example consider the polygonal complex that was introduced at the
#! start of chapter <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> EdgesWithVertexProperty(complex, v -> IsBoundaryVertex(complex, v));
#! [ 5, 7, 8, 10, 12, 14 ]
#! gap> NotAdjacentToInnerVertex := function(complex, vertex)
#! >      local edges, otherVerts;
#! >   
#! >      edges := EdgesOfVertex(complex, vertex);
#! >      otherVerts := List(edges, e -> OtherVertexOfEdge(complex, vertex, e));
#! >      return ForAll( otherVerts, v -> not IsInnerVertex(complex, v) );
#! > end;;
#! gap> EdgesWithVertexProperty(complex, NotAdjacentToInnerVertex);
#! [ 7, 14 ]
#! gap> 
#! gap> EdgesWithVertexProperties(complex,
#! >      v -> IsBoundaryVertex(complex, v),
#! >      v -> IsRamifiedVertex(complex, v) );
#! [ 1, 3, 4, 13 ]
#! gap> EdgesWithVertexProperties(complex, NotAdjacentToInnerVertex,
#! >      v -> IsRamifiedVertex(complex, v));
#! [ 1, 13 ]
#! @EndExampleSession
#!
#! Note for efficient computations: The only way to provide a general method
#! like <K>EdgesWithVertexProperties</K> is by wrapping the properties
#! into functions. Unfortunately, calling a function introduces an overhead.
#! In particular, if the executed instructions are very fast (for example a
#! small computation or a list lookup), then the overhead by the function
#! call may be as time intensive as the actual computation. Therefore, if
#! high efficiency is required and the functionality of this method is time
#! critical, it is probably more efficient to manually implement the 
#! functionality into the code.
#!
#! 
#! @Returns a set of positive integers
#! @Arguments complex, prop1, prop2
DeclareOperation("EdgesWithVertexProperties", 
        [IsTwistedPolygonalComplex, IsFunction, IsFunction]);
#! @Arguments complex, propList
DeclareOperation("EdgesWithVertexProperties", [IsTwistedPolygonalComplex, IsList] );
#! @Arguments complex, prop
DeclareOperation("EdgesWithVertexProperty", [IsTwistedPolygonalComplex, IsFunction]);
#! @EndGroup


#! @BeginGroup FacesWithVertexProperties
#! @Description
#! For a given twisted polygonal complex <A>complex</A> the method 
#! <K>FacesWithVertexProperty</K>(<A>complex</A>, <A>prop</A>) returns
#! the set of all faces such that all of its incident vertices fulfill 
#! property 
#! <A>prop</A>.
#!
#! A property can be given in two ways (otherwise an error will be thrown);
#! * As a function <A>prop</A> with two arguments. Then, for a given vertex 
#!   <M>v</M>, it is checked whether <A>prop</A>(<A>complex</A>, <M>v</M>)
#!   is <K>true</K>.
#! * As a function <A>prop</A> with one argument. Then, for a given vertex
#!   <M>v</M>, it is checked whether <A>prop</A>(<M>v</M>) is <K>true</K>.
#!   In particular, it is assumed that the given function depends on
#!   <A>complex</A> (otherwise there can be strange results).
#!
#! The alternative method 
#! <K>FacesWithVertexProperties</K>(<A>complex</A>, <A>propList</A>)
#! returns the set of all faces such that each of the incident vertices in the
#! face fulfills one property of <A>propList</A>, such that every entry is
#! fulfilled exactly once (this implies in particular that the number of
#! incident vertices is equal to <K>Length</K>(<A>propList</A>)).
#!
#! Empty positions in this list are filled with the function that always
#! returns <K>true</K>.
#!
#! 
#! As an example consider the polygonal complex that was introduced at the
#! start of chapter <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> FacesWithVertexProperty( complex, v -> not IsInnerVertex(complex,v) );
#! [ 1, 2 ]
#! gap> TwoBoundaryEdgesIncident := function(complex, vertex)
#! >      local edges, boundEdges;
#! > 
#! >      edges := EdgesOfVertex(complex, vertex);
#! >      boundEdges := Filtered(edges, e -> IsBoundaryEdge(complex, e));
#! >      return Length(boundEdges) = 2;
#! > end;;
#! gap> FacesWithVertexProperty( complex, TwoBoundaryEdgesIncident );
#! [ 2 ]
#! gap> 
#! gap> FacesWithVertexProperties( complex, [ TwoBoundaryEdgesIncident,
#! >      v -> IsRamifiedVertex(complex, v),
#! >      v -> FaceDegreeOfVertex(complex, v) = 2 ] );
#! [ 1 ]
#! gap> FacesWithVertexProperties( complex, [ TwoBoundaryEdgesIncident,
#! >      v -> IsRamifiedVertex(complex, v),
#! >      v -> EdgeDegreeOfVertex(complex, v) = 3 ] );
#! [ 1, 5 ]
#! gap> FacesWithVertexProperties( complex, [ TwoBoundaryEdgesIncident, , ,
#! >      v -> IsInnerVertex(complex, v)] );
#! [ 4 ]
#! @EndExampleSession
#!
#! Note for efficient computations: The only way to provide a general method
#! like <K>FacesWithVertexProperties</K> is by wrapping the properties
#! into functions. Unfortunately, calling a function introduces an overhead.
#! In particular, if the executed instructions are very fast (for example a
#! small computation or a list lookup), then the overhead by the function
#! call may be as time intensive as the actual computation. Therefore, if
#! high efficiency is required and the functionality of this method is time
#! critical, it is probably more efficient to manually implement the 
#! functionality into the code.
#!
#! 
#! @Returns a set of positive integers
#! @Arguments complex, propList
DeclareOperation("FacesWithVertexProperties", [IsTwistedPolygonalComplex, IsList] );
#! @Arguments complex, prop
DeclareOperation("FacesWithVertexProperty", [IsTwistedPolygonalComplex, IsFunction]);
#! @EndGroup

 
#! @BeginGroup FacesWithEdgeProperties
#! @Description
#! For a given twisted polygonal complex <A>complex</A> the method 
#! <K>FacesWithEdgeProperty</K>(<A>complex</A>, <A>prop</A>) returns
#! the set of all faces such that all of its incident edges fulfill 
#! property 
#! <A>prop</A>.
#!
#! A property can be given in two ways (otherwise an error will be thrown);
#! * As a function <A>prop</A> with two arguments. Then, for a given edge
#!   <M>e</M>, it is checked whether <A>prop</A>(<A>complex</A>, <M>e</M>)
#!   is <K>true</K>.
#! * As a function <A>prop</A> with one argument. Then, for a given edge
#!   <M>e</M>, it is checked whether <A>prop</A>(<M>e</M>) is <K>true</K>.
#!   In particular, it is assumed that the given function depends on
#!   <A>complex</A> (otherwise there can be strange results).
#!
#! The alternative method 
#! <K>FacesWithEdgeProperties</K>(<A>complex</A>, <A>propList</A>)
#! returns the set of all faces such that each of the incident edges in the
#! face fulfills one property of <A>propList</A>, such that every entry is
#! fulfilled exactly once (this implies in particular that the number of
#! incident edges is equal to <K>Length</K>(<A>propList</A>)).
#!
#! Empty positions in this list are filled with the function that always
#! returns <K>true</K>.
#!
#! 
#! As an example consider the polygonal complex that was introduced at the
#! start of chapter <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> FacesWithEdgeProperty(complex, e -> IsInnerEdge(complex, e));
#! [ 4 ]
#! gap> InnerEdgeOrRamifiedVertex := function( complex, edge )
#! >      local verts;
#! > 
#! >      if IsInnerEdge(complex, edge) then
#! >        return true;
#! >      fi;
#! > 
#! >      verts := VerticesOfEdge(complex, edge);
#! >      return ForAny(verts, v -> IsRamifiedVertex(complex, v));
#! > end;;
#! gap> FacesWithEdgeProperty( complex, InnerEdgeOrRamifiedVertex );
#! [ 1, 4, 5 ]
#! gap> 
#! gap> FacesWithEdgeProperties(complex, [ 
#! >      e -> IsInnerEdge(complex, e),
#! >      InnerEdgeOrRamifiedVertex,
#! >      e -> IsBoundaryEdge(complex, e)]);
#! [ 1, 5 ]
#! gap> FacesWithEdgeProperties(complex, [ , ,
#! >     e -> IsBoundaryEdge(complex, e), InnerEdgeOrRamifiedVertex]);
#! [ 2 ]
#! @EndExampleSession
#!
#! Note for efficient computations: The only way to provide a general method
#! like <K>FacesWithEdgeProperties</K> is by wrapping the properties
#! into functions. Unfortunately, calling a function introduces an overhead.
#! In particular, if the executed instructions are very fast (for example a
#! small computation or a list lookup), then the overhead by the function
#! call may be as time intensive as the actual computation. Therefore, if
#! high efficiency is required and the functionality of this method is time
#! critical, it is probably more efficient to manually implement the 
#! functionality into the code.
#!
#! 
#! @Returns a set of positive integers
#! @Arguments complex, propList
DeclareOperation("FacesWithEdgeProperties", [IsTwistedPolygonalComplex, IsList] );
#! @Arguments complex, prop
DeclareOperation("FacesWithEdgeProperty", [IsTwistedPolygonalComplex, IsFunction]);
#! @EndGroup

#! @Section Determination of common elements
#! @SectionLabel Determination_of_common_elements

#! @BeginGroup CommonVerticesOfEdges
#! @Description
#! The method <K>CommonVerticesOfEdges</K>(<A>complex</A>, <A>edge1</A>, <A>edge2</A>) returns the
#! set of all vertices that are incident to <A>edge1</A> and <A>edge2</A>. The NC-version does
#! not check whether the given <A>edge1</A> and <A>edge2</A> is an edge of <A>complex</A>.
#! 
#! The method <K>CommonVerticesOfEdges</K>(<A>complex</A>, <A>edgeList</A>) returns the
#! set of all vertices that are incident to all the edges in <A>edgeList</A>. The NC-version does
#! not check whether the given edges in <A>edgeList</A> are an edge of <A>complex</A>.
#! 
#! As an example consider the polygonal complex from the start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> CommonVerticesOfEdges(complex,8,9);
#! [  ]
#! gap> CommonVerticesOfEdges(complex,8,6);
#! [ 6 ]
#! gap> CommonVerticesOfEdges(complex,[8,6,5]);
#! [ 6 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex, edge1, edge2
DeclareOperation( "CommonVerticesOfEdges", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, edgeList
DeclareOperation( "CommonVerticesOfEdges", [IsTwistedPolygonalComplex, IsList]);
#! @Arguments complex, edge1, edge2
DeclareOperation( "CommonVerticesOfEdgesNC", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, edgeList
DeclareOperation( "CommonVerticesOfEdgesNC", [IsTwistedPolygonalComplex, IsList]);
#! @EndGroup

#! @BeginGroup CommonEdgesOfFaces
#! @Description
#! The method <K>CommonEdgesOfFaces</K>(<A>complex</A>, <A>face1</A>, <A>face2</A>) returns the
#! set of all edges that are incident to <A>face1</A> and <A>face2</A>. The NC-version does
#! not check whether the given <A>face1</A> and <A>face2</A> is a face of <A>complex</A>.
#! 
#! The method <K>CommonEdgesOfFaces</K>(<A>complex</A>, <A>faceList</A>) returns the
#! set of all edges that are incident to all the faces in <A>faceList</A>. The NC-version does
#! not check whether the given faces in <A>faceList</A> are a face of <A>complex</A>.
#! 
#! As an example consider the polygonal complex from the start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> CommonEdgesOfFaces(complex,[6,4]);
#! [ 9, 11 ]
#! @EndExampleSession
#!
#! @Returns a set of positive integers
#! @Arguments complex, face1, face2
DeclareOperation( "CommonEdgesOfFaces", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, faceList
DeclareOperation( "CommonEdgesOfFaces", [IsTwistedPolygonalComplex, IsList]);
#! @Arguments complex, face1, face2
DeclareOperation( "CommonEdgesOfFacesNC", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, faceList
DeclareOperation( "CommonEdgesOfFacesNC", [IsTwistedPolygonalComplex, IsList]);
#! @EndGroup

#! @BeginGroup CommonVerticesOfFaces
#! @Description
#! The method <K>CommonVerticesOfFaces</K>(<A>complex</A>, <A>face1</A>, <A>face2</A>) returns the
#! set of all vertices that are incident to <A>face1</A> and <A>face2</A>. The NC-version does
#! not check whether the given <A>face1</A> and <A>face2</A> is a face of <A>complex</A>.
#! 
#! The method <K>CommonEdgesOfFaces</K>(<A>complex</A>, <A>faceList</A>) returns the
#! set of all vertices that are incident to all the faces in <A>faceList</A>. The NC-version does
#! not check whether the given faces in <A>faceList</A> are a face of <A>complex</A>.
#! 
#! As an example consider the polygonal complex from the start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> CommonVerticesOfFaces(complex,1,4);
#! [ 6 ]
#! gap> CommonVerticesOfFaces(complex,6,4);
#! [ 5, 8, 9 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex, face1, face2
DeclareOperation( "CommonVerticesOfFaces", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, faceList
DeclareOperation( "CommonVerticesOfFaces", [IsTwistedPolygonalComplex, IsList]);
#! @Arguments complex, face1, face2
DeclareOperation( "CommonVerticesOfFacesNC", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, faceList
DeclareOperation( "CommonVerticesOfFacesNC", [IsTwistedPolygonalComplex, IsList]);
#! @EndGroup

#! @BeginGroup CommonEdgesOfVertices
#! @Description
#! The method <K>CommonEdgesOfVertices</K>(<A>complex</A>, <A>vertex1</A>, <A>vertex2</A>) returns the
#! set of all edges that are incident to <A>vertex1</A> and <A>vertex2</A>. The NC-version does
#! not check whether the given <A>vertex1</A> and <A>vertex2</A> is a vertex of <A>complex</A>.
#! 
#! The method <K>CommonEdgesOfVertices</K>(<A>complex</A>, <A>vertexList</A>) returns the
#! set of all edges that are incident to all the vertices in <A>vertexList</A>. The NC-version does
#! not check whether the given vertices in <A>vertexList</A> are a vertex of <A>complex</A>.
#! 
#! As an example consider the polygonal complex from the start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap>  CommonEdgesOfVertices(complex,6,2);
#! [ 3, 4 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex, vertex1, vertex2
DeclareOperation( "CommonEdgesOfVertices", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, vertexList
DeclareOperation( "CommonEdgesOfVertices", [IsTwistedPolygonalComplex, IsList]);
#! @Arguments complex, vertex1, vertex2
DeclareOperation( "CommonEdgesOfVerticesNC", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, vertexList
DeclareOperation( "CommonEdgesOfVerticesNC", [IsTwistedPolygonalComplex, IsList]);
#! @EndGroup

#! @BeginGroup CommonFacesOfEdges
#! @Description
#! The method <K>CommonFacesOfEdges</K>(<A>complex</A>, <A>edge1</A>, <A>edge2</A>) returns the
#! set of all faces that are incident to <A>edge1</A> and <A>edge2</A>. The NC-version does
#! not check whether the given <A>edge1</A> and <A>edge2</A> is an edge of <A>complex</A>.
#! 
#! The method <K>CommonFacesOfEdges</K>(<A>complex</A>, <A>edgeList</A>) returns the
#! set of all faces that are incident to all the edges in <A>edgeList</A>. The NC-version does
#! not check whether the given edges in <A>edgeList</A> are an edge of <A>complex</A>.
#! 
#! As an example consider the polygonal complex from the start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> CommonFacesOfEdges(complex,9,12);
#! [ 6 ]
#! gap> CommonFacesOfEdges(complex,[9,11]);
#! [ 4, 6 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex, edge1, edge2
DeclareOperation( "CommonFacesOfEdges", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, edgeList
DeclareOperation( "CommonFacesOfEdges", [IsTwistedPolygonalComplex, IsList]);
#! @Arguments complex, edge1, edge2
DeclareOperation( "CommonFacesOfEdgesNC", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, edgeList
DeclareOperation( "CommonFacesOfEdgesNC", [IsTwistedPolygonalComplex, IsList]);
#! @EndGroup

#! @BeginGroup CommonFacesOfVertices
#! @Description
#! The method <K>CommonFacesOfVertices</K>(<A>complex</A>, <A>vertex1</A>, <A>vertex2</A>) returns the
#! set of all faces that are incident to <A>vertex1</A> and <A>vertex2</A>. The NC-version does
#! not check whether the given <A>vertex1</A> and <A>vertex2</A> is a vertex of <A>complex</A>.
#! 
#! The method <K>CommonFacesOfVertices</K>(<A>complex</A>, <A>vertexList</A>) returns the
#! set of all faces that are incident to all the vertices in <A>vertexList</A>. The NC-version does
#! not check whether the given vertices in <A>vertexList</A> are a vertex of <A>complex</A>.
#! 
#! As an example consider the polygonal complex from the start of chapter
#! <Ref Chap="Chapter_Navigation"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_EyeStone-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_EyeStone.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> CommonFacesOfVertices(complex,9,5);
#! [ 4, 6 ]
#! gap> CommonFacesOfVertices(complex,[6,8]);
#! [ 2, 4 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex, vertex1, vertex2
DeclareOperation( "CommonFacesOfVertices", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, vertexList
DeclareOperation( "CommonFacesOfVertices", [IsTwistedPolygonalComplex, IsList]);
#! @Arguments complex, vertex1, vertex2
DeclareOperation( "CommonFacesOfVerticesNC", [IsTwistedPolygonalComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, vertexList
DeclareOperation( "CommonFacesOfVerticesNC", [IsTwistedPolygonalComplex, IsList]);
#! @EndGroup


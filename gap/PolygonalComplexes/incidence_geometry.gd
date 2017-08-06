#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2016
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

#! @Chapter Access to the incidence geometry
#! @ChapterLabel AccessIncidenceGeometry
#! 
#! We have introduced incidence geometries in section
#! <Ref Sect="PolygonalStructures_complex"/> as a description of polygonal
#! complexes. In this
#! chapter we will collect different ways to access these incidence
#! structures.

#! @Section Access to labels of vertices, edges and faces
#! @SectionLabel Access_LabelAccess
#!
#! In polygonal complexes (the most general supported incidence structure,
#! compare chapter <Ref Chap="PolygonalStructures"/>) all vertices, edges
#! and faces are labelled by positive integers. We can access the set of
#! all those labels by <K>Vertices</K>, <K>Edges</K> and <K>Faces</K>.
#! If only the number of vertices is relevant, we can use <K>NrOfVertices</K>
#! instead (likewise for edges and faces).

#! @BeginGroup
## TODO check if grape has changed their definition of Vertices
#! @Description
#! Return the set of vertices.
#! <Par/>
#! We have separated the operation <K>Vertices</K> from the corresponding
#! attribute because there is a naming clash with the package grape.
#! @Arguments complex
#! @Returns A set of positive integers
DeclareOperation( "Vertices", [IsPolygonalComplex] );
#! @Arguments complex
DeclareAttribute( "VerticesAttributeOfPolygonalComplex", IsPolygonalComplex );
#! @EndGroup

#! @Description
#! Return the set of edges.
#! @Arguments complex
#! @Returns A set of positive integers
DeclareAttribute( "Edges", IsPolygonalComplex );

#! @Description
#! Return the set of faces.
#! @Arguments complex
#! @Returns A set of positive integers
DeclareAttribute( "Faces", IsPolygonalComplex );

#! @Description
#! Return the number of vertices.
#! @Arguments complex
#! @Returns a non-negative integer
DeclareAttribute( "NrOfVertices", IsPolygonalComplex );

#! @Description
#! Return the number of edges.
#! @Arguments complex
#! @Returns a non-negative integer
DeclareAttribute( "NrOfEdges", IsPolygonalComplex );

#! @Description
#! Return the number of faces.
#! @Arguments complex
#! @Returns a non-negative integer
DeclareAttribute( "NrOfFaces", IsPolygonalComplex );


#! @Section Basic access to the incidence structure
#! @SectionLabel Access_BasicAccess
#!
#! With the labels of vertices, edges and faces (which we can access by the
#! methods of section <Ref Sect="Section_Access_LabelAccess"/>) we can 
#! describe the incidence structure by lists of sets.
#! All those methods have the form *Of*, e.g. <K>VerticesOfFaces</K> and 
#! <K>EdgesOfVertices</K>.
#! <Par/>
#! We will illustrate the general pattern of these methods by showcasing
#! these two methods. For that we will use the following polygonal complex:
#TODO Text-version is crucial here, compare the picture in Image_StarOfStar
#! <Alt Only="TikZ">
#! {
#! \def\allLabels{1}
#! \input{Image_StarOfStarExample.tex}
#! }
#! </Alt>
#!
#TODO give a reference to the constructor
#! @BeginExample
complex := PolygonalComplexByDownwardIncidence( 5, 6, 2, 
    [ , , , , , [2,11], , [2,3], [3,11], [3,5], , [5,7], [7,11] ], 
    [[6,8,9], , , [9,10,12,13]]);;
Vertices(complex);
#! [ 2, 3, 5, 7, 11 ]
Edges(complex);
#! [ 6, 8, 9, 10, 12, 13 ]
Faces(complex);
#! [ 1, 4 ]
#! @EndExample
#!
#! The method <K>VerticesOfFaces</K> tells us, which vertices are incident
#! to which faces.
#! @BeginExample
VerticesOfFaces(complex);
#! [ [ 2, 3, 11 ], , , [ 3, 5, 7, 11 ] ];
#! @EndExample
#! The first entry of this list contains a set of all vertices that are
#! incident to face I. The second and third entries are not bounded since
#! there are no faces II and III. Finally, the fourth entry contains all
#! vertices that are incident to face IV.
#! <Par/>
#! So we have a list that contains sets of vertices and is indexed by the 
#! face labels.
#! <Par/>
#! The method <K>EdgesOfVertices</K> works in the same way: It returns a list
#! that contains sets of edges and is indexed by the vertex labels.
#! @BeginExample
EdgesOfVertices(complex);
#! [ , [ 6, 8 ], [ 8, 9, 10 ], , [ 10, 12 ], , [ 12, 13 ], , , , [ 6, 9, 13 ] ]
#! @EndExample
#! For example, if we consider the third entry of this list, we find the
#! set [8, 9, 10]. Those are all edges that are incident to the vertex 3.
#! <Par/>
#! In the same way all other *Of*-methods are defined.


#TODO mention 'ordered' access
#! @BeginGroup
#! @Description
#! The method <K>EdgesOfVertex</K>(<A>complex</A>, <A>vertex</A>) returns the
#! set of all edges that are incident to <A>vertex</A>. The NC-version does
#! not check whether the given <A>vertex</A> is a vertex of <A>complex</A>.
#! <Par/>
#! The attribute <K>EdgesOfVertices</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the vertex labels, i.e.
#! <K>EdgesOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>EdgesOfVertex</K>(<A>complex</A>, <A>vertex</A>).
#! All other positions of this list are not bounded.
#! <Par/>
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   {
#!     \def\vertexLabels{1}
#!     \def\edgeLabels{1}
#!     \input{Image_StarOfStarExample.tex}
#!   }
#! </Alt>
#! @BeginExample
EdgesOfVertex(complex, 2);
#! [ 6, 8 ]
EdgesOfVertex(complex, 11);
#! [ 6, 9, 13 ]
EdgesOfVertices(complex);
#! [ , [ 6, 8 ], [ 8, 9, 10 ], , [ 10, 12 ], , [ 12, 13 ], , , [ 6, 9, 13 ] ]
#! @EndExample
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "EdgesOfVertices", IsPolygonalComplex );
#! @Arguments complex, vertex
DeclareOperation( "EdgesOfVertex", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "EdgesOfVertexNC", [IsPolygonalComplex, IsPosInt]);
#! @EndGroup


#TODO mention 'ordered' access
#! @BeginGroup
#! @Description
#! The method <K>FacesOfVertex</K>(<A>complex</A>, <A>vertex</A>) returns the
#! set of all faces that are incident to <A>vertex</A>. The NC-version does
#! not check whether the given <A>vertex</A> is a vertex of <A>complex</A>.
#! <Par/>
#! The attribute <K>FacesOfVertices</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the vertex labels, i.e.
#! <K>FacesOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>FacesOfVertex</K>(<A>complex</A>, <A>vertex</A>).
#! All other positions of this list are not bounded.
#! <Par/>
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   {
#!     \def\vertexLabels{1}
#!     \def\faceLabels{1}
#!     \input{Image_StarOfStarExample.tex}
#!   }
#! </Alt>
#! @BeginExample
FacesOfVertex(complex, 2);
#! [ 1 ]
FacesOfVertex(complex, 11);
#! [ 1, 4 ]
FacesOfVertices(complex);
#! [ , [ 1 ], [ 1, 4 ], , [ 4 ], , [ 4 ], , , [ 1, 4 ] ]
#! @EndExample
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "FacesOfVertices", IsPolygonalComplex );
#! @Arguments complex, vertex
DeclareOperation( "FacesOfVertex", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "FacesOfVertexNC", [IsPolygonalComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup
#! @Description
#! The method <K>VerticesOfEdge</K>(<A>complex</A>, <A>edge</A>) returns the
#! set of all vertices that are incident to <A>edge</A>. The NC-version does
#! not check whether the given <A>edge</A> is an edge of <A>complex</A>.
#! <Par/>
#! The attribute <K>VerticesOfEdges</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the edge labels, i.e.
#! <K>VerticesOfEdges</K>(<A>complex</A>)[<A>edge</A>] = 
#! <K>VerticesOfEdge</K>(<A>complex</A>, <A>edge</A>).
#! All other positions of this list are not bounded.
#! <Par/>
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   {
#!     \def\vertexLabels{1}
#!     \def\edgeLabels{1}
#!     \input{Image_StarOfStarExample.tex}
#!   }
#! </Alt>
#! @BeginExample
VerticesOfEdge(complex, 8);
#! [ 2, 3 ]
VerticesOfEdge(complex, 12);
#! [ 5, 7 ]
VerticesOfEdges(complex);
#! [ , , , , , [ 2, 11 ], , [ 2, 3 ], [ 3, 11 ], [ 3, 5 ], , [ 5, 7 ], [ 7, 11 ] ]
#! @EndExample
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "VerticesOfEdges", IsPolygonalComplex );
#! @Arguments complex, edge
DeclareOperation( "VerticesOfEdge", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, edge
DeclareOperation( "VerticesOfEdgeNC", [IsPolygonalComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup
#! @Description
#! The method <K>FacesOfEdge</K>(<A>complex</A>, <A>edge</A>) returns the
#! set of all faces that are incident to <A>edge</A>. The NC-version does
#! not check whether the given <A>edge</A> is an edge of <A>complex</A>.
#! <Par/>
#! The attribute <K>FacesOfEdges</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the edge labels, i.e.
#! <K>FacesOfEdges</K>(<A>complex</A>)[<A>edge</A>] = 
#! <K>FacesOfEdge</K>(<A>complex</A>, <A>edge</A>).
#! All other positions of this list are not bounded.
#! <Par/>
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   {
#!     \def\edgeLabels{1}
#!     \def\faceLabels{1}
#!     \input{Image_StarOfStarExample.tex}
#!   }
#! </Alt>
#! @BeginExample
FacesOfEdge(complex, 9);
#! [ 1, 4 ]
FacesOfEdge(complex, 10);
#! [ 4 ]
FacesOfEdges(complex);
#! [ , , , , , [ 1 ], , [ 1 ], [ 1, 4 ], [ 4 ], , [ 4 ], [ 4 ] ]
#! @EndExample
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "FacesOfEdges", IsPolygonalComplex );
#! @Arguments complex, edge
DeclareOperation( "FacesOfEdge", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, edge
DeclareOperation( "FacesOfEdgeNC", [IsPolygonalComplex, IsPosInt]);
#! @EndGroup


#TODO mention ordered access
#! @BeginGroup
#! @Description
#! The method <K>VerticesOfFace</K>(<A>complex</A>, <A>face</A>) returns the
#! set of all vertices that are incident to <A>face</A>. The NC-version does
#! not check whether the given <A>face</A> is a face of <A>complex</A>.
#! <Par/>
#! The attribute <K>VerticesOfFaces</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the face labels, i.e.
#! <K>VerticesOfFaces</K>(<A>complex</A>)[<A>face</A>] = 
#! <K>VerticesOfFace</K>(<A>complex</A>, <A>face</A>).
#! All other positions of this list are not bounded.
#! <Par/>
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   {
#!     \def\vertexLabels{1}
#!     \def\faceLabels{1}
#!     \input{Image_StarOfStarExample.tex}
#!   }
#! </Alt>
#! @BeginExample
VerticesOfFace(complex, 1);
#! [ 2, 3, 11 ]
VerticesOfFace(complex, 4);
#! [ 3, 5, 7, 11 ]
VerticesOfFaces(complex);
#! [ [ 2, 3, 11 ], , , [ 3, 5, 7, 11 ] ]
#! @EndExample
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "VerticesOfFaces", IsPolygonalComplex );
#! @Arguments complex, face
DeclareOperation( "VerticesOfFace", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, face
DeclareOperation( "VerticesOfFaceNC", [IsPolygonalComplex, IsPosInt]);
#! @EndGroup


#TODO mention ordered access
#! @BeginGroup
#! @Description
#! The method <K>EdgesOfFace</K>(<A>complex</A>, <A>face</A>) returns the
#! set of all edges that are incident to <A>faces</A>. The NC-version does
#! not check whether the given <A>face</A> is a face of <A>complex</A>.
#! <Par/>
#! The attribute <K>EdgesOfFaces</K>(<A>complex</A>) collects all of those
#! sets in a list that is indexed by the face labels, i.e.
#! <K>EdgesOfFaces</K>(<A>complex</A>)[<A>face</A>] = 
#! <K>EdgesOfFace</K>(<A>complex</A>, <A>face</A>).
#! All other positions of this list are not bounded.
#! <Par/>
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   {
#!     \def\edgeLabels{1}
#!     \def\faceLabels{1}
#!     \input{Image_StarOfStarExample.tex}
#!   }
#! </Alt>
#! @BeginExample
EdgesOfFace(complex, 1);
#! [ 6, 8, 9 ]
EdgesOfFace(complex, 4);
#! [ 9, 10, 12, 13 ]
EdgesOfFaces(complex);
#! [ [ 6, 8, 9 ], , , [ 9, 10, 12, 13 ] ]
#! @EndExample
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments complex
DeclareAttribute( "EdgesOfFaces", IsPolygonalComplex );
#! @Arguments complex, face
DeclareOperation( "EdgesOfFace", [IsPolygonalComplex, IsPosInt]);
#! @Arguments complex, face
DeclareOperation( "EdgesOfFaceNC", [IsPolygonalComplex, IsPosInt]);
#! @EndGroup


#! @Section Ordered access to the incidence structure
#! @SectionLabel Access_OrderedAccess
#!
#! In most cases the basic access functions of section
#! <Ref Sect="Section_Access_BasicAccess"/> like <K>VerticesOfEdges</K> are
#! sufficient. But sometimes a more "ordered" access is necessary. This
#! package supports the following capabilities:
#! <Enum>
#!   <Item><E>Ordering around a vertex</E>
#!         <Par/>
#!         For polygonal surfaces (that were introduced in section
#!         <Ref Sect="PolygonalStructures_surface"/>) there is a natural 
#!         ordering of the edges and 
#!         faces that are incident to a vertex. It is achieved by "travelling 
#!         around the vertex" while staying on the surface.
#!         <Alt Only="TikZ">
#!           \input{Image_EdgeFacePath.tex}
#!         </Alt>
#!         This is captured in the concept of an <E>edge-face-path</E>, which
#!         is defined in subsection
#!         <Ref Subsect="Definition_EdgeFacePath_Vertex"/>.
#!    </Item>
#! </Enum>

    

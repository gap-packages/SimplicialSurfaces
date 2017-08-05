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

#! @Description
#! Return a list that contains sets of edges and is indexed by the vertex
#! labels. This list encodes the incidence relation between edges and
#! vertices.
#!
#! 

#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2019
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University
##    Jens Brandt, RWTH Aachen University
##
## Licensed under the GPL 3 or later.
##
#############################################################################

# TODO screenshots missing in the whole file

#! @Chapter Animating surfaces with Java Script
#! @ChapterLabel AnimationJavaScript
#!
#! This chapter deals with animating simplicial surfaces via Java Script
#! using three.js, see <URL>https://threejs.org/</URL>.

#! @Section Quick Start
#! @SectionLabel QuickStartAnimating
#!
#! This section contains a minimal example by animating an octahedron.
#! Therefore we only need to specify the 3D-coordinates of the vertices.
#! @BeginExampleSession
#! gap> oct := Octahedron();;
#! gap> verticesPositions := [
#! > [ 0, 0, Sqrt(2.) ],
#! > [ 1, 1, 0 ],
#! > [ 1, -1, 0 ],
#! > [ -1, -1, 0 ],
#! > [ -1, 1, 0 ],
#! > [ 0, 0, -Sqrt(2.) ] ];;
#! gap> printRecord := SetVertexCoordiantes3D(oct, verticesPositions, rec());;
# rec( vertexCoordinates3D := [ [ 0, 0, 1.41421 ], [ 1, 1, 0 ], [ 1, -1, 0 ], [ -1, -1, 0 ], [ -1, 1, 0 ], [ 0, 0, -1.41421 ] ] )
#! gap> DrawSurfaceToJavaScript(oct, "octahedron.html", printRecord);;
#! @EndExampleSession
#! Now your working directory should contain a file "octahedron.html".
#! @InsertChunk Example_OctahedronAnimating
# TODO missing three.polymake.js

#! @Section Introduction
#! @SectionLabel IntroductionAnimating
#!
#! The philosophy of the code presented in this chapter is the following.
#! The main function <K>DrawSurfaceToJavaScript</K> (Section <Ref Sect="Section_MainAnimating"/>) animates the surfaces using the configuration saved in the so called  print record, e.g. the 3D-coordinates (3D-coordinates are defined as a list with 3 entries of numbers) of the vertices (compare Section <Ref Sect="Section_QuickStartAnimating"/>). It is necessary that the print record contains the 3D-coordinates of each vertex of the surface which should be animated. Based on the 3D-coordinates of the vertices the surface is placed in the animation.
#! Therefore a typical workflow to animate a surfaces looks like this:
#! <Enum>
#!   <Item>Construct the surface, e.g. the octahedron in Section <Ref Sect="Section_QuickStartAnimating"/>.</Item>
#!   <Item>Configure your animation using the functions in the Sections <Ref Sect="Section_VerticesAnimating"/> to <Ref Sect="Section_NormalesInnerCirclesAnimating"/>.</Item>
#!   <Item>Write your animation to a file calling the main function <K>DrawSurfaceToJavaScript</K> (see Section <Ref Sect="Section_MainAnimating"/>).</Item>
#! </Enum>
#! The output of the function <K>DrawSurfaceToJavaScript</K> is a html file. The file can be opened with any browser and then the animation is shown directly.

#! @Section Vertices
#! @SectionLabel VerticesAnimating
#!
#! Since all 3D-geometry in this chapter is based on the 3D-coordinates of the vertices, we start editing those. The following options are implemented for vertices:
#! <Enum>
#!   <Item>Set and get 3D-coordinates of vertices of a simplicial surface.</Item>
#!   <Item>Activate and deactivate vertices. If a vertex is active, then he is shown as a node in the animation. </Item>
#!   <Item>Set colors of vertices for the animation. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)</Item>
#! </Enum>
#! The following example shows the animation without vertices.
#! @BeginExampleSession
#! gap> oct := Octahedron();;
#! gap> verticesPositions := [
#! > [ 0, 0, Sqrt(2.) ],
#! > [ 1, 1, 0 ],
#! > [ 1, -1, 0 ],
#! > [ -1, -1, 0 ],
#! > [ -1, 1, 0 ],
#! > [ 0, 0, -Sqrt(2.) ] ];;
#! gap> printRecord := SetVertexCoordiantes3D(oct, verticesPositions, rec());;
# rec( vertexCoordinates3D := [ [ 0, 0, 1.41421 ], [ 1, 1, 0 ], [ 1, -1, 0 ], [ -1, -1, 0 ], [ -1, 1, 0 ], [ 0, 0, -1.41421 ] ] );
#! gap> DrawSurfaceToJavaScript(oct, "octahedron.html", printRecord);;
#! @EndExampleSession
#! @InsertChunk Example_OctahedronAnimatingWithoutVertices
#!
#! @BeginGroup SetVertexCoordinates3D
#! @Description
#! Save the given list of 3D-coordinates in the given or the empty print record. If the format of the 3D-coordinates (3D-coordinates have to be a list of 3 entries of numbers) is not correct, then an error is shown.
#! The NC-version does not check the coordinate format.
#! @Returns the updated print record.
#! @Arguments surface, newCoordinatesList[, printRecord]
DeclareOperation( "SetVertexCoordiantes3D", [IsPolygonalComplex and IsNotEdgeRamified, IsDenseList, IsRecord] );
#! @Arguments newCoordinatesList[, printRecord]
DeclareOperation( "SetVertexCoordiantes3DNC", [IsDenseList, IsRecord] );
#! @EndGroup

#! @BeginGroup GetVertexCoordinates3D
#! @Description
#! Extract the 3D-coordinates of the <A>i</A>th vertex from the print record. If the format of the 3D-coordinates (3D-coordinates have to be a list of 3 entries of numbers) is not correct, then an error is shown. This can happen, if the NC version is used to store the 3D-coordinates.
#! The NC-version does not check the coordinate format saved in the print record.
#! @Returns the 3D-coordinates of the <A>i</A>th vertex.
#! @Arguments surface, i, printRecord
DeclareOperation( "GetVertexCoordiantes3D", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @Arguments i, printRecord
DeclareOperation( "GetVertexCoordiantes3DNC", [IsCyclotomic, IsRecord] );
#! @EndGroup

#! Furthermore all or one vertices/vertex can be (de-)activated, such that they are (not) visible in the animation.
#! By default all vertices are active.

#! @BeginGroup ActivateVertices
#! @Description
#! Activate all vertices. If a vertex is active, then the vertex is shown in the animation as a node.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "ActivateVertices", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup DeactivateVertices
#! @Description
#! Deactivate all vertices. If a vertex is active, then the vertex is shown in the animation as a node.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateVertices", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateVertex
#! @Description
#! Activate the <A>i</A>th vertex. If a vertex is active, then the vertex is shown in the animation as a node.
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateVertex", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup DeactivateVertex
#! @Description
#! Deactivate the <A>i</A>th vertex. If a vertex is active, then the vertex is shown in the animation as a node.
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateVertex", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup IsVertexActive
#! @Description
#! Test whether the <A>i</A>th vertex is active.
#! @Returns true or false.
#! @Arguments surface, i, printRecord
DeclareOperation( "IsVertexActive", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! We illustrade this functionality by animating an octahedron with none but the vertices 2 and 3 visiable
#! (using the vertex positions from Section <Ref Sect="Section_QuickStartAnimating"/>).
#! @BeginExampleSession
#! gap> oct := Octahedron();;
#! gap> printRecord := SetVertexCoordiantes3D(oct, verticesPositions, rec());;
#! gap> printRecord := DeactivateVertices(oct, printRecord);;
#! gap> printRecord := ActivateVertex(oct, 2, printRecord);;
#! gap> printRecord := ActivateVertex(oct, 3, printRecord);;
#! gap> List([1..NumberOfVertices(oct)], i -> IsVertexActive(oct, i, printRecord));
#! [ false, true, true, false, false, false ]
# gap> DrawSurfaceToJavaScript(oct, "octahedron.html", printRecord);;
#! @EndExampleSession
#! @InsertChunk Example_OctahedronAnimatingWithoutSomeVertices

#! Finally we can configure the colours of the vertices. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! The default vertex colour is 0xF58137. (0xF58137 is an orange hue.)

#! @BeginGroup SetVertexColours
#! @Description
#! Set colours for all vertices. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the updated print record.
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetVertexColours", [IsPolygonalComplex and IsNotEdgeRamified, IsDenseList, IsRecord] );
#! @EndGroup

#! @BeginGroup GetVertexColours
#! @Description
#! Extract the colours of the vertices from the print record. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the list of colours.
#! @Arguments surface, printRecord
DeclareOperation( "GetVertexColours", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup SetVertexColour
#! @Description
#! Set the <A>colour</A> of the <A>i</A>th vertex. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the updated print record.
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetVertexColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsString, IsRecord] );
#! @EndGroup

#! @BeginGroup GetVertexColour
#! @Description
#! Get the colour of the <A>i</A>th vertex. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the colour.
#! @Arguments surface, i, printRecord
DeclareOperation( "GetVertexColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! Now we use the presented code to expand the example from above and colour all vertices green but the third red.
#! @BeginExampleSession
#! gap> printRecord := SetVertexColours(oct,
#! > ListWithIdenticalEntries(NumberOfVertices(oct), "green"), printRecord);;
#! gap> printRecord := SetVertexColour(oct, 3, "red", printRecord);;
#! gap> List([1..NumberOfVertices(oct)], i -> GetVertexColour(oct, i, printRecord));
#! [ "green", "green", "red", "green", "green", "green" ]
# gap> DrawSurfaceToJavaScript(oct, "octahedron.html", printRecord);;
#! @EndExampleSession
#! @InsertChunk Example_OctahedronEdgeColors

#! @Section Edges
#! @SectionLabel EdgesAnimating
#!

# TODO add examples in this sections

#! The mathematical functionality concerning the edges is provided by the function, that calculates their position.
#! Please remember to rerun this function after redefinding the vertex coordinates, otherwise outdated edge parameters will be used.
#! The following options are implemented for edges:
#! <Enum>
#! <Item>Calculate the parameters of edges by the 3D-coordinates of the vertices. Note that this is necessary for the animation. Therefore the function <K>CalculateParametersOfEdges</K> gets called after using the function <K>DrawSurfaceToJavaScript</K> if no parameters are set for the edges. If parameters are set for the edges and the 3D-coordinates of a vertex has been changed, then you have to call the function <K>CalculateParametersOfEdges</K> manuel again. Otherwise the animation will be not necessarly correct. </Item>
#!   <Item>Activate and deactivate edges. If an edge is active, then he is shown as a line in the animation. </Item>
#!   <Item>Set colours of edges for the animation. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.) </Item>
#! </Enum>

#! @BeginGroup CalculateParametersOfEdges
#! @Description
#! This function calculates the parameters of the edges (centre, length, angles relative to x-direction) based on the
#! coordinates of the vertices and saves those to the print record.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "CalculateParametersOfEdges", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! We demonstrate the problem of outdated parameters described in the introduction of the section
#! by an example, that uses the vertex positions from Section <Ref Sect="Section_QuickStartAnimating"/>
#! and redefines thoses mirrored at Zero.
#! @BeginExampleSession
#! gap> verticesPositionsMirrored := -verticesPositions;;
#! gap> oct := Octahedron();;
#! gap> printRecord := SetVertexCoordiantes3D(oct, verticesPositions, rec());;
#! gap> printRecord := CalculateParametersOfEdges(oct, printRecord);;
#! gap> # coordinates of the center of the edge (1,2):
#! > printRecord.edges[EdgeBetweenVertices(oct, 1, 2)][1];
#! [ 0.5, 0.5, 0.707107 ]
#! gap> printRecord := SetVertexCoordiantes3D(oct, verticesPositionsMirrored,
#! > printRecord);;
#! gap> # coordinates of the edge (1,2) did not change:
#! > printRecord.edges[EdgeBetweenVertices(oct, 1, 2)][1];
#! [ 0.5, 0.5, 0.707107 ]
#! gap> printRecord := CalculateParametersOfEdges(oct, printRecord);;
#! gap> # now the coordinates of the edge (1,2) were updated:
#! > printRecord.edges[EdgeBetweenVertices(oct, 1, 2)][1];
#! [ -0.5, -0.5, -0.707107 ]
#! @EndExampleSession
#! @InsertChunk Example_OctahedronPositionMirrored

#! The remaining functions of this section are very simular to those in the former section.
#! The edges can be (de-)activated, too. By default they are all active.

#! @BeginGroup ActivateEdges
#! @Description
#! Activate all edges. If an edge is active, then the edge is shown in the animation as a line.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "ActivateEdges", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup DeactivateEdges
#! @Description
#! Deactivate all edges. If an edge is active, then the edge is shown in the animation as a line.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateEdges", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateEdge
#! @Description
#! Activate the <A>i</A>th edge. If an edge is active, then he is shown as a line in the animation.
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateEdge", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup DeactivateEdge
#! @Description
#! Deactivate the <A>i</A>th edge. If an edge is active, then the edge is shown in the animation as a line.
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateEdge", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup IsEdgeActive
#! @Description
#! Test whether the <A>i</A>th edge is active. If an edge is active, then the edge is shown in the animation as a line.
#! @Returns True or false.
#! @Arguments surface, i, printRecord
DeclareOperation( "IsEdgeActive", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! Also the colours of the edges is configurable. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! The default edge colour is 0xff0000. (0xff0000 is a red hue.)

#! @BeginGroup SetEdgeColours
#! @Description
#! Set colours for all edges. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the updated print record.
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetEdgeColours", [IsPolygonalComplex and IsNotEdgeRamified, IsDenseList, IsRecord] );
#! @EndGroup

#! @BeginGroup GetEdgeColours
#! @Description
#! Extract the colours of the edges from the print record. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the list of colours.
#! @Arguments surface, printRecord
DeclareOperation( "GetEdgeColours", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup SetEdgeColour
#! @Description
#! Set the <A>colour</A> of the <A>i</A>th edge. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the updated print record.
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetEdgeColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsString, IsRecord] );
#! @EndGroup

#! @BeginGroup GetEdgeColour
#! @Description
#! Get the colour of the <A>i</A>th edge. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the colour.
#! @Arguments surface, i, printRecord
DeclareOperation( "GetEdgeColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @Section Faces
#! @SectionLabel FacesAnimating
#!

# TODO add examples in this sections

#! The faces of the surface can be (de-)activated and coloured in the familiar way. By default they are active with colour 0xFFFF00. (0xFFFF00 is an yellow hue. Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! The following options are implemented for faces:
#! <Enum>
#!   <Item>Activate and deactivate faces. If a face is active, then he is shown as an area in the animation. </Item>
#!   <Item>Set colours of faces for the animation.</Item>
#! </Enum>

#! @BeginGroup ActivateFaces
#! @Description
#! Activate all faces. If a face is active, then the face is shown in the animation as an area.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "ActivateFaces", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup DeactivateFaces
#! @Description
#! Deactivate all faces. If a face is active, then the face is shown in the animation as an area.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateFaces", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateFace
#! @Description
#! Activate the <A>i</A>th face. If a face is active, then the face is shown in the animation as an area.
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateFace", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup DeactivateFace
#! @Description
#! Deactivate the <A>i</A>th face. If a face is active, then the face is shown in the animation as an area.
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateFace", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup IsFaceActive
#! @Description
#! Test whether the <A>i</A>th face is active. If a face is active, then the face is shown in the animation as an area.
#! @Returns True or false.
#! @Arguments surface, i, printRecord
DeclareOperation( "IsFaceActive", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup SetFaceColours
#! @Description
#! Set colours for all faces. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the updated print record.
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetFaceColours", [IsPolygonalComplex and IsNotEdgeRamified, IsDenseList, IsRecord] );
#! @EndGroup

#! @BeginGroup GetFaceColours
#! @Description
#! Extract the colours of the faces from the print record. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the list of colours.
#! @Arguments surface, printRecord
DeclareOperation( "GetFaceColours", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup SetFaceColour
#! @Description
#! Set the <A>colour</A> of the <A>i</A>th face. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the updated print record.
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetFaceColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsString, IsRecord] );
#! @EndGroup

#! @BeginGroup GetFaceColour
#! @Description
#! Get the colour of the <A>i</A>th face. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the colour.
#! @Arguments surface, i, printRecord
DeclareOperation( "GetFaceColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @Section Inner Circles
#! @SectionLabel InnerCirclesAnimating
#!

# TODO add examples in this sections
#! For an inner circle we need a face with 3 correspondig edges. Then an inner circle is an circle which lie in the face such that the circle touches each edge of the face in exactly one point.
#! The functionality concerning the inner circles is completely simular to the functionality converning the edges.
#! By default the inner circles are inactive with colour 0x000000. (0x000000 is transparent. Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! The following options are implemented for inner circles:
#! <Enum>
#! <Item>Calculate the parameters of inner circles by the 3D-coordinates of the vertices. Note that this is necessary for the animation. Therefore the function <K>CalculateParametersOfInnerCircle</K> gets called after using the function <K>DrawSurfaceToJavaScript</K> if no parameters are set for the inner circles. If parameters are set for the inner circles and the 3D-coordinates of a vertex has been changed, then you have to call the function <K>CalculateParametersOfInnerCircle</K> manuel again. Otherwise the animation will be not necessarly correct. </Item>
#!   <Item>Activate and deactivate inner circles. If an inner circle is active, then he is shown in the animation. </Item>
#!   <Item>Set colours of inner circles for the animation.</Item>
#! </Enum>
#! @BeginExampleSession
#! gap> oct := Octahedron();;
#! gap> printRecord := SetVertexCoordiantes3D(oct, verticesPositions, rec());;
#! gap> printRecord := ActivateInnerCircles(oct,printRecord);
#! gap> DrawSurfaceToJavaScript(oct, "Octahedron_InnerCircle.html", printRecord);;
#! @EndExampleSession
#! @InsertChunk Example_OctahedronInnerCircle
#! @InsertChunk Example_OctahedronInnerCircleWithoutFaces

#! @BeginGroup CalculateParametersOfInnerCircle
#! @Description
#! This function calculates the parameters of the innerer circles (incenter, radius, angles relative to x-y-plane) and their normal vectors (angles relative to x-direction) based on the
#! 3D-coordinates of the vertices and saves those to the print record. For the describtion of inner circles look at <Ref Sect="Section_InnerCirclesAnimating"/>.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "CalculateParametersOfInnerCircle", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateInnerCircles
#! @Description
#! Activate all innerer circles. If an inner circle is active, then he is shown in the animation. For the describtion of inner circles look at <Ref Sect="Section_InnerCirclesAnimating"/>.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "ActivateInnerCircles", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup DeactivateInnerCircles
#! @Description
#! Deactivate all innerer circles. If an inner circle is active, then he is shown in the animation. For the describtion of inner circles look at <Ref Sect="Section_InnerCirclesAnimating"/>.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateInnerCircles", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateInnerCircle
#! @Description
#! Activate the <A>i</A>th inner circle (following the face numbering). If an inner circle is active, then he is shown in the animation. For the describtion of inner circles look at <Ref Sect="Section_InnerCirclesAnimating"/>.
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateInnerCircle", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup DeactivateInnerCircle
#! @Description
#! Deactivate the <A>i</A>th inner circle (following the face numbering). If an inner circle is active, then he is shown in the animation. For the describtion of inner circles look at <Ref Sect="Section_InnerCirclesAnimating"/>.
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateInnerCircle", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup IsInnerCircleActive
#! @Description
#! Test whether the <A>i</A>th inner circle is active (following the face numbering). If an inner circle is active, then he is shown in the animation. For the describtion of inner circles look at <Ref Sect="Section_InnerCirclesAnimating"/>.
#! @Returns True or false.
#! @Arguments surface, i, printRecord
DeclareOperation( "IsInnerCircleActive", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup SetCircleColours
#! @Description
#! Set colours for all inner circles. For the describtion of inner circles look at <Ref Sect="Section_InnerCirclesAnimating"/>. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the updated print record.
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetCircleColours", [IsPolygonalComplex and IsNotEdgeRamified, IsDenseList, IsRecord] );
#! @EndGroup

#! @BeginGroup GetCircleColours
#! @Description
#! Extract the colours of the inner circles from the print record. For the describtion of inner circles look at <Ref Sect="Section_InnerCirclesAnimating"/>. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the list of colours.
#! @Arguments surface, printRecord
DeclareOperation( "GetCircleColours", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup SetCircleColour
#! @Description
#! Set the <A>colour</A> of the <A>i</A>th inner circle (following the face numbering). For the describtion of inner circles look at <Ref Sect="Section_InnerCirclesAnimating"/>. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the updated print record.
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetCircleColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsString, IsRecord] );
#! @EndGroup

#! @BeginGroup GetCircleColour
#! @Description
#! Get the colour of the <A>i</A>th inner circle (following the face numbering). For the describtion of inner circles look at <Ref Sect="Section_InnerCirclesAnimating"/>. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the colour.
#! @Arguments surface, i, printRecord
DeclareOperation( "GetCircleColour", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @Section Normales of Inner Circles
#! @SectionLabel NormalesInnerCirclesAnimating
#!

# TODO add examples in this sections

#! A normal of an inner circle is an vector (represented as a line) which go orthogonal through the middle point of the corresponding inner circle. (For the describtion of inner circles look at <Ref Sect="Section_InnerCirclesAnimating"/>)
#! The normal vectors of inner circles can also be (de-)activated in the familiar way.
#! If the are active, they have the colour of the corresponding inner circle.
#! @BeginExampleSession
#! gap> oct := Octahedron();;
#! gap> printRecord := SetVertexCoordiantes3D(oct, verticesPositions, rec());;
#! gap> printRecord := ActivateNormalOfInnerCircles(oct,printRecord);
#! gap> DrawSurfaceToJavaScript(oct, "Octahedron_InnerCircle.html", printRecord);;
#! @EndExampleSession
#! @InsertChunk Example_OctahedronNormalesOfInnerCircle
#! @InsertChunk Example_OctahedronNormalesOfInnerCircleWithoutFaces

#! @BeginGroup ActivateNormalOfInnerCircles
#! @Description
#! Activate all normals innerer circles. If a normal innerer circle is active, then the normal innerer circle is shown in the animation. For the describtion of normales of inner circles look at <Ref Sect="Section_NormalesInnerCirclesAnimating"/>.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "ActivateNormalOfInnerCircles", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup DeactivateNormalOfInnerCircles
#! @Description
#! Deactivate all normals of innerer circles. If a normal innerer circle is active, then the normal innerer circle is shown in the animation. For the describtion of normales of inner circles look at <Ref Sect="Section_NormalesInnerCirclesAnimating"/>.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateNormalOfInnerCircles", [IsPolygonalComplex and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateNormalOfInnerCircle
#! @Description
#! Activate the normal of the <A>i</A>th inner circle (following the face numbering). If a normal innerer circle is active, then the normal innerer circle is shown in the animation. For the describtion of normales of inner circles look at <Ref Sect="Section_NormalesInnerCirclesAnimating"/>.
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateNormalOfInnerCircle", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup DeactivateNormalOfInnerCircle
#! @Description
#! Deactivate the normal of the <A>i</A>th inner circle (following the face numbering). If a normal innerer circle is active, then the normal innerer circle is shown in the animation. For the describtion of normales of inner circles look at <Ref Sect="Section_NormalesInnerCirclesAnimating"/>.
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateNormalOfInnerCircle", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup IsNormalOfInnerCircleActive
#! @Description
#! Test whether the normal of the <A>i</A>th inner circle is active (following the face numbering). If a normal innerer circle is active, then the normal innerer circle is shown in the animation. For the describtion of normales of inner circles look at <Ref Sect="Section_NormalesInnerCirclesAnimating"/>.
#! @Returns True or false.
#! @Arguments surface, i, printRecord
DeclareOperation( "IsNormalOfInnerCircleActive", [IsPolygonalComplex and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @Section Main function <K>DrawSurfaceToJavaScript</K>
#! @SectionLabel MainAnimating
#!

#! @BeginGroup DrawSurfaceToJavaScript
#! @Description
#! This function animates the <A>surface</A> using the configuration in <A>printRecord</A> and writes the animation to the <A>filename</A> as a html file into the working directory. The animation can be watched and opened with any browser.
#! If, based on the configuration in the print record, calculations are possible and necessary, they will be done. This means that, if there are no parameters set for the edges and the inner circles the corresponding functions <K>CalculateParametersOfEdges</K> and <K>CalculateParametersOfInnerCircle</K> will be called.
#! E.g. if the coordinates of the vertices are set and edges are active but their parameters haven't been calculated, they will be calculated (see Section <Ref Sect="Section_EdgesAnimating"/>) and the result will be added to the print record.
#! @Returns the (possibly) updated print record.
#! @Arguments surface, filename, printRecord
DeclareOperation( "DrawSurfaceToJavaScript", [IsPolygonalComplex and IsNotEdgeRamified, IsString, IsRecord] );
#! @EndGroup

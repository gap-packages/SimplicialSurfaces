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

#! @Chapter Animating surfaces with Java Script
#! @ChapterLabel AnimationJavaScript
#!
#! This chapter deals with animating simplicial surfaces via Java Script
#! using three.js, see <URL>https://threejs.org/</URL>.

#! @Section Introduction and Quick Start
#! @SectionLabel LabelIntroductionAndQuickStartAnimating

#! This section contains a minimal example by animating an octahedron and after that shows the general strategy to use the functions of this chapter.
#! To construct an octahedron we only need to specify the 3D-coordinates of the vertices.
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
#! Now your working directory should contain a file "octahedron.html". Below is shown an image of the animation.
#! @InsertChunk Example_OctahedronAnimating

#! The philosophy of the code presented in this chapter is the following.
#! The main function <K>DrawSurfaceToJavaScript</K> (Section <Ref Sect="Section_LabelCoordinatesAndCoreFunctionality"/>) animates the surfaces using the configuration saved in the so called  print record, e.g. the 3D-coordinates (3D-coordinates are defined as a list with 3 entries of floats) of the vertices. It is necessary that the print record contains the 3D-coordinates of each vertex of the surface which should be animated. Based on the 3D-coordinates of the vertices the surface is placed in the animation.
#! Therefore a typical workflow to animate a surfaces looks like this:
#! <Enum>
#!   <Item>Construct the surface, e.g. the octahedron above.</Item>
#!   <Item>Configure your animation using the functions in the Sections
#!   <Ref Subsect="Section_LabelVisibility"/> and <Ref Subsect="Section_LabelColouring"/>.</Item>
#!   <Item>Write your animation to a file calling the main function <K>DrawSurfaceToJavaScript</K> (see Section <Ref Sect="Section_LabelCoordinatesAndCoreFunctionality"/>).</Item>
#! </Enum>
#! The output of the function <K>DrawSurfaceToJavaScript</K> is a html file. The file can be opened with any browser and then the animation is shown directly.

#! @Section Coordinates and Core Functionality
#! @SectionLabel LabelCoordinatesAndCoreFunctionality

#! This section deals with the main functions. Before the animation (see <K>DrawSurfaceToJavaScript</K>) can be drawn, it is necessary to specify the 3D-coordinates (which means, the [x,y,z] coordinates) of all vertices of the surface which should be animated (see <K>SetVertexCoordinates3D</K>).
#!
#! After seting parameters of the vertices, it is necessary to set parameters of the edges.
#! We demonstrate the problem of outdated parameters
#! by an example, where we set coordinates
#! and redefine these mirrored at Zero.
#! @BeginExampleSession
#! gap> verticesPositions := [
#! > [ 1, -1/Sqrt(3.), -1/Sqrt(6.) ],
#! > [ -1, -1/Sqrt(3.), -1/Sqrt(6.) ],
#! > [ 0, 2/Sqrt(3.) , -1/Sqrt(6.) ],
#! > [ 0, 0, 3/Sqrt(6.) ] ];;
#! gap> verticesPositionsMirrored := -verticesPositions;;
#! gap> tet := Tetrahedron();;
#! gap> printRecord := SetVertexCoordiantes3D(tet, verticesPositions, rec());;
#! gap> printRecord := CalculateParametersOfEdges(tet, printRecord);;
#! gap> # coordinates of the center of the edge (1,2):
#! > printRecord.edges[EdgeBetweenVertices(tet, 1, 2)][1];
#! [ 0., -0.57735, -0.408248 ]
#! gap> printRecord := SetVertexCoordiantes3D(tet, verticesPositionsMirrored,
#! > printRecord);;
#! gap> # coordinates of the edge (1,2) did not change:
#! > printRecord.edges[EdgeBetweenVertices(tet, 1, 2)][1];
#! [ 0., -0.57735, -0.408248 ]
#! gap> DrawSurfaceToJavaScriptCalculate(tet,
#! > "Tetrahedron_PositionMirrored.html", printRecord, false);;
#! @EndExampleSession
#! @InsertChunk Example_Tetrahedron_PositionMirrored
#! The function <K>DrawSurfaceToJavaScript</K> always calculates the parameters of the edges depending on the current vertices positions.
#! If you want to avoid that, you can use the function <K>DrawSurfaceToJavaScriptCalculate</K> and set the last parameter to false. In this case no new parameters are computed except that no parameters were ever set.

#! @BeginGroup SetVertexCoordinates3D
#! @Description
#! Save the given list of 3D-coordinates in the given or the empty print record. If the format of the 3D-coordinates (3D-coordinates have to be a list of 3 entries of floats) is not correct, then an error is shown.
#! The NC-version does not check the coordinate format.
#! @Returns the updated print record.
#! @Arguments surface, newCoordinatesList[, printRecord]
DeclareOperation( "SetVertexCoordiantes3D", [IsSimplicialSurface and IsNotEdgeRamified, IsDenseList, IsRecord] );
#! @Arguments newCoordinatesList[, printRecord]
DeclareOperation( "SetVertexCoordiantes3DNC", [IsDenseList, IsRecord] );
#! @EndGroup

#! @BeginGroup GetVertexCoordinates3D
#! @Description
#! Extract the 3D-coordinates from the print record of the vertex in position <A>i</A> of <K>Vertices</K> from the corresponding <A>surface</A>. If the format of the 3D-coordinates (3D-coordinates have to be a list of 3 entries of floats) is not correct, then an error is shown. This can happen, if the NC version is used to store the 3D-coordinates.
#! The NC-version does not check the coordinate format saved in the print record.
#! @Returns the 3D-coordinates of the <A>i</A>th vertex.
#! @Arguments surface, i, printRecord
DeclareOperation( "GetVertexCoordiantes3D", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @Arguments i, printRecord
DeclareOperation( "GetVertexCoordiantes3DNC", [IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup DrawSurfaceToJavaScript
#! @Description
#! These functions animate the <A>surface</A> as a html file <A>filename</A> in JavaScript into the working directory. The animation can be watched and opened with any browser.
#! An introduction to the use of this method (along with two examples)
#! can be found at the start of section
#! <Ref Sect="Section_LabelIntroductionAndQuickStartAnimating"/>.
#!
#! * If the given <A>fileName</A> does not end in <E>.html</E> the ending
#!   <E>.html</E> will be added to it.
#! * The given file will be overwritten without asking if it already exists.
#!   If you don't have permission to write in that file, this method will
#!   throw an error.
#! * The particulars of the drawing are determined by the
#!   given <A>printRecord</A>.
#! * The <A>printRecord</A> will be modified and returned by this method.
#!   It contains the data to recreate the drawing of the surface.
#!
#! To use these functions it is necessary to set the 3D-coordinates (3D-coordinates are defined as a list with 3 entries of floats) of the vertices of the surface (see <K>SetVertexCoordinates3D</K>).
#!
#! The function <K>DrawSurfaceToJavaScript</K> always calculates the parameters which are needed corresponding to the current positions of the vertices. Therefore the <A>printRecord</A> will be changed if some parameters are not set to the actual vertice positions.
#!
#! The function <K>DrawSurfaceToJavaScriptCalculate</K> has an extra parameter <A>calculate</A> which is a bool (true or false value). If you want to avoid that the parameters are always recalculated you can use the function <K>DrawSurfaceToJavaScriptCalculate</K> and set <A>calculate = false</A>. If, based on the configuration in the print record, calculations are possible and necessary, they will be done. This means that, if there are no parameters set for the edges and the inner circles the corresponding functions <K>CalculateParametersOfEdges</K> and <K>CalculateParametersOfInnerCircle</K> will be called.
#!
#! If you use the function <K>DrawSurfaceToJavaScriptCalculate</K> with <A>calculate = true</A> the function works like <K>DrawSurfaceToJavaScript</K>.
#!
#! There are two parameters to change the output of this method.
#! There are the following classes of parameters:
#! * <E>Visibility</E>
#!   (<Ref Subsect="Section_LabelVisibility"/>): Change the
#!   colours of vertices, edges and faces.
#! * <E>Colours</E>
#!   (<Ref Subsect="Section_LabelColouring"/>): Change the
#!   colours of vertices, edges and faces.
#!
#! There are also options for inner circles (<Ref Subsect="Section_LabelInnerCirclesAnimating"/>) and normales of inner circles (<Ref Subsect="Section_LabelNormalesInnerCirclesAnimating"/>).
#! @Returns the (possibly) updated print record.
#! @Arguments surface, filename, printRecord
DeclareOperation( "DrawSurfaceToJavaScript", [IsSimplicialSurface and IsNotEdgeRamified, IsString, IsRecord] );
#! @Arguments surface, filename, printRecord, calculate
DeclareOperation( "DrawSurfaceToJavaScriptCalculate", [IsSimplicialSurface and IsNotEdgeRamified, IsString, IsRecord, IsBool] );
#! @EndGroup

#! @BeginGroup DrawSurfaceToJavaScript

#! @EndGroup

#! @BeginGroup CalculateParametersOfEdges
#! @Description
#! This function calculates the parameters of the edges (centre, length, angles relative to x-direction) based on the
#! coordinates of the vertices and saves those to the print record.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "CalculateParametersOfEdges", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @Section Visibility
#! @SectionLabel LabelVisibility

#! A surface is described through its vertices, edges and faces. But sometimes it is also necessary to hide something.
#! Therefore it is possible to make the following visible and invisible:
#! <Enum>
#!   <Item>Vertices</Item>
#!   <Item>Edges</Item>
#!   <Item>Faces</Item>
#! </Enum>
#! By default all vertices, edges and faces are visible.

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
#! gap> printRecord := DeactivateVertices(oct, printRecord);;
#! gap> DrawSurfaceToJavaScript(oct, "octahedron.html", printRecord);;
#! @EndExampleSession
#! @InsertChunk Example_OctahedronAnimatingWithoutVertices

#! We illustrade this functionality by animating an octahedron with none but the vertices 2 and 3 visiable.
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
#! gap> printRecord := DeactivateVertices(oct, printRecord);;
#! gap> printRecord := ActivateVertex(oct, 2, printRecord);;
#! gap> printRecord := ActivateVertex(oct, 3, printRecord);;
#! gap> List([1..NumberOfVertices(oct)], i -> IsVertexActive(oct, i, printRecord));
#! [ false, true, true, false, false, false ]
#! gap> DrawSurfaceToJavaScript(oct, "octahedron.html", printRecord);;
#! @EndExampleSession
#! @InsertChunk Example_OctahedronAnimatingWithoutSomeVertices

#! @BeginGroup ActivateVertices
#! @Description
#! Activate all vertices. If a vertex is active, then the vertex is shown in the animation as a node.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "ActivateVertices", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateVertices", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateVertex
#! @Description
#! Activate the vertex in position <A>i</A> of <A>Vertices(surface)</A>. If a vertex is active, then the vertex is shown in the animation as a node. (For more information look at the start of the section <Ref Subsect="Section_LabelVisibility"/>)
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateVertex", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateVertex", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "IsVertexActive", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateEdges
#! @Description
#! Activate all edges. If an edge is active, then the edge is shown in the animation as a line. (For more information look at the start of the section <Ref Subsect="Section_LabelVisibility"/>)
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "ActivateEdges", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateEdges", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateEdge
#! @Description
#! Activate the edge in position <A>i</A> of <A>Edges(surface)</A>. If an edge is active, then he is shown as a line in the animation. (For more information look at the start of the section <Ref Subsect="Section_LabelVisibility"/>)
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateEdge", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateEdge", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "IsEdgeActive", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateFaces
#! @Description
#! Activate all faces. If a face is active, then the face is shown in the animation as an area. (For more information look at the start of the section <Ref Subsect="Section_LabelVisibility"/>)
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "ActivateFaces", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateFaces", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateFace
#! @Description
#! Activate the face in position <A>i</A> of <A>Faces(surface)</A>. If a face is active, then the face is shown in the animation as an area. (For more information look at the start of the section <Ref Subsect="Section_LabelVisibility"/>)
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateFace", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateFace", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "IsFaceActive", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @Section Colouring
#! @SectionLabel LabelColouring

#! Finally we can configure the colours. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! Therefore it is possible to make the following coloured:
#! <Enum>
#!   <Item>Vertices (The default vertex colour is 0xF58137. 0xF58137 is an orange hue.)</Item>
#!   <Item>Edges (The default edge colour is 0xff0000. 0xff0000 is a red hue.)</Item>
#!   <Item>Faces (The default face colour is 0xFFFF00. 0xFFFF00 is an yellow hue.)</Item>
#! </Enum>
#! There are also some colours, which can also be respresented by strings.
#! Below is a list of some strings, which can be used for a colour.
#! * Green = 0x008000
#! * Red = 0xFF0000
#! * Yellow = 0xFFFF00
#! * Blue = 0x0000FF
#! * Purple = 0x800080
#! * Pink = 0xFFC0CB
#! * Black = 0x000000
#! * Brown = 0xA52A2A
#! * White = 0xFFFFFF
#! * Orange = 0xFFA500

#! Now we give a brief example to see how the coloring works.
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
#! gap> printRecord := SetVertexColours(oct,
#! > ListWithIdenticalEntries(NumberOfVertices(oct), "green"), printRecord);;
#! gap> printRecord := SetVertexColour(oct, 3, "red", printRecord);;
#! gap> List([1..NumberOfVertices(oct)], i -> GetVertexColour(oct, i, printRecord));
#! [ "green", "green", "red", "green", "green", "green" ]
#! gap> DrawSurfaceToJavaScript(oct, "octahedron.html", printRecord);;
#! @EndExampleSession
#! @InsertChunk Example_OctahedronEdgeColors

#! @BeginGroup SetVertexColours
#! @Description
#! Set colours for all vertices. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code. For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>).
#! @Returns the updated print record.
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetVertexColours", [IsSimplicialSurface and IsNotEdgeRamified, IsDenseList, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "GetVertexColours", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup SetVertexColour
#! @Description
#! Set the <A>colour</A> of the vertex in position <A>i</A> of <A>Vertices(surface)</A>. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.  For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>).
#! @Returns the updated print record.
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetVertexColour", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsString, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "GetVertexColour", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup SetEdgeColours
#! @Description
#! Set colours for all edges. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.  For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>).
#! @Returns the updated print record.
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetEdgeColours", [IsSimplicialSurface and IsNotEdgeRamified, IsDenseList, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "GetEdgeColours", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup SetEdgeColour
#! @Description
#! Set the <A>colour</A> of the edge in position <A>i</A> of <A>Edges(surface)</A>. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.  For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>).
#! @Returns the updated print record.
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetEdgeColour", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsString, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "GetEdgeColour", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup


#! @BeginGroup SetFaceColours
#! @Description
#! Set colours for all faces. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.  For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>).
#! @Returns the updated print record.
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetFaceColours", [IsSimplicialSurface and IsNotEdgeRamified, IsDenseList, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "GetFaceColours", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup SetFaceColour
#! @Description
#! Set the <A>colour</A> of the face in position <A>i</A> of <A>Faces(surface)</A>. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.  For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>).
#! @Returns the updated print record.
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetFaceColour", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsString, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "GetFaceColour", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @Section Inner Circles
#! @SectionLabel LabelInnerCirclesAnimating
#!

#! For an inner circle we need a face with 3 corresponding edges. Then an inner circle is an circle which lie in the face such that the circle touches each edge of the face in exactly one point.
#!
#! The functionality concerning the inner circles is completely simular to the functionality converning the edges.
#!
#! By default the inner circles are inactive.
#!
#! The following options are implemented for inner circles:
#! <Enum>
#! <Item>Calculate the parameters of inner circles by the 3D-coordinates of the vertices. Note that this is necessary for the animation. Therefore the function <K>CalculateParametersOfInnerCircle</K> gets called after using the function <K>DrawSurfaceToJavaScript</K> if no parameters are set for the inner circles. If parameters are set for the inner circles and the 3D-coordinates of a vertex has been changed, then you have to call the function <K>CalculateParametersOfInnerCircle</K> manuel again if you use the function <K>DrawSurfaceToJavaScriptCalculate</K> with <A>calculate = false</A>. Otherwise the animation will be not necessarly correct. If you use the function <K>DrawSurfaceToJavaScript</K> the parameters will be updated automatically. </Item>
#!   <Item>Activate and deactivate inner circles. If an inner circle is active, then he is shown in the animation. </Item>
#!   <Item>Set colours of inner circles for the animation.</Item>
#! </Enum>
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
#! gap> printRecord := ActivateInnerCircles(oct,printRecord);;
#! gap> DrawSurfaceToJavaScript(oct, "Octahedron_InnerCircle.html", printRecord);;
#! @EndExampleSession
#! @InsertChunk Example_OctahedronInnerCircle
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
#! gap> printRecord := DeactivateFaces(oct,printRecord);;
#! gap> printRecord := ActivateInnerCircles(oct,printRecord);;
#! gap> DrawSurfaceToJavaScript(oct, "Octahedron_InnerCircle.html", printRecord);;
#! @EndExampleSession
#! @InsertChunk Example_OctahedronInnerCircleWithoutFaces

#! @BeginGroup ActivateInnerCircles
#! @Description
#! For the describtion of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>. Activate all innerer circles. If an inner circle is active, then he is shown in the animation.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "ActivateInnerCircles", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateInnerCircles", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateInnerCircle
#! @Description
#! For the describtion of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>. Activate the inner circle corresponding to the face in position <A>i</A> of <A>Faces(surface)</A>. If an inner circle is active, then he is shown in the animation.
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateInnerCircle", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateInnerCircle", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "IsInnerCircleActive", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup SetCircleColours
#! @Description
#! For the describtion of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>. Set colours for all inner circles. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the updated print record.
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetCircleColours", [IsSimplicialSurface and IsNotEdgeRamified, IsDenseList, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "GetCircleColours", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup SetCircleColour
#! @Description
#! For the describtion of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>. Set the <A>colour</A> of the inner circle corresponding to the face in position <A>i</A> of <A>Faces(surface)</A>. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.)
#! @Returns the updated print record.
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetCircleColour", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsString, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "GetCircleColour", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

#! @BeginGroup CalculateParametersOfInnerCircle
#! @Description
#! For the describtion of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>. This function calculates the parameters of the innerer circles (incenter, radius, angles relative to x-y-plane) and their normal vectors (angles relative to x-direction) based on the
#! 3D-coordinates of the vertices and saves those to the print record.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "CalculateParametersOfInnerCircle", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @Section Normales of Inner Circles
#! @SectionLabel LabelNormalesInnerCirclesAnimating
#!

#! A normal of an inner circle is a vector (represented as a line) which goes orthogonal through the middle point of the corresponding inner circle. (For the describtion of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>.)
#!
#! The normal vectors of inner circles can also be (de-)activated in the familiar way.
#! If the are active, they have the colour of the corresponding inner circle.
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
#! gap> printRecord := ActivateNormalOfInnerCircles(oct,printRecord);;
#! gap> DrawSurfaceToJavaScript(oct, "Octahedron_InnerCircle.html", printRecord);;
#! @EndExampleSession
#! @InsertChunk Example_OctahedronNormalesOfInnerCircle
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
#! gap> printRecord := DeactivateFaces(oct,printRecord);;
#! gap> printRecord := ActivateNormalOfInnerCircles(oct,printRecord);;
#! gap> DrawSurfaceToJavaScript(oct, "Octahedron_InnerCircle.html", printRecord);;
#! @EndExampleSession
#! @InsertChunk Example_OctahedronNormalesOfInnerCircleWithoutFaces

#! @BeginGroup ActivateNormalOfInnerCircles
#! @Description
#! For the describtion of normales of inner circles look at <Ref Sect="Section_LabelNormalesInnerCirclesAnimating"/>. Activate all normals innerer circles. If a normal innerer circle is active, then the normal innerer circle is shown in the animation.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "ActivateNormalOfInnerCircles", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateNormalOfInnerCircles", [IsSimplicialSurface and IsNotEdgeRamified, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateNormalOfInnerCircle
#! @Description
#! For the describtion of normales of inner circles look at <Ref Sect="Section_LabelNormalesInnerCirclesAnimating"/>. Activate the normal of the face in position <A>i</A> of <A>Faces(surface)</A>. If a normal innerer circle is active, then the normal innerer circle is shown in the animation.
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateNormalOfInnerCircle", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateNormalOfInnerCircle", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "IsNormalOfInnerCircleActive", [IsSimplicialSurface and IsNotEdgeRamified, IsCyclotomic, IsRecord] );
#! @EndGroup

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

#! This section contains a minimal example by animating an octahedron and showcases the general animation workflow.
#! To construct an octahedron, we only need to specify the 3D-coordinates of the vertices.
#! @BeginLog
#! gap> oct := Octahedron();;
#! gap> verticesPositions := [
#! > [ 0, 0, Sqrt(2.) ],
#! > [ 1, 1, 0 ],
#! > [ 1, -1, 0 ],
#! > [ -1, -1, 0 ],
#! > [ -1, 1, 0 ],
#! > [ 0, 0, -Sqrt(2.) ] ];;
#! gap> printRecord := SetVertexCoordinates3D(oct, verticesPositions, rec());;
# rec( vertexCoordinates3D := [ [ 0, 0, 1.41421 ], [ 1, 1, 0 ], [ 1, -1, 0 ], [ -1, -1, 0 ], [ -1, 1, 0 ], [ 0, 0, -1.41421 ] ] )
#! gap> DrawSurfaceToJavaScript(oct, "octahedron.html", printRecord);;
#! @EndLog
#! Now, your working directory should contain a file "octahedron.html". Below is shown an image of the animation.
#!
#! An image of the animation is shown below.
#! @InsertChunk Example_OctahedronAnimating

#! The philosophy of the code presented in this chapter is as follows:
#! The main method <K>DrawSurfaceToJavaScript</K> (Section <Ref Sect="Section_LabelCoordinatesAndCoreFunctionality"/>) animates the surfaces using the configuration saved in the so called  <A>print record</A>, e.g. the the 3D-coordinates (lists with three float entries) of the vertices. It is necessary that the print record contains the 3D-coordinates of each vertex of the surface which should be animated. Based on the 3D-coordinates of the vertices, the surface is placed in the animation.
#! Therefore, a typical workflow to animate a surfaces looks like this:
#! <Enum>
#!   <Item>Construct the surface, e.g. the octahedron above.</Item>
#!   <Item>Configure your animation using the methods in the Sections
#!   <Ref Subsect="Section_LabelVisibility"/> and <Ref Subsect="Section_LabelColouring"/>.</Item>
#!   <Item>Write your animation to a file calling the main method <K>DrawSurfaceToJavaScript</K> (see Section <Ref Sect="Section_LabelCoordinatesAndCoreFunctionality"/>).</Item>
#! </Enum>
#! The output of the method <K>DrawSurfaceToJavaScript</K>(<Ref Subsect="DrawSurfaceToJavaScript"/>) is a html file. The file can be opened with any browser and then the animation is shown directly.

#! @Section Coordinates and Core Functionality
#! @SectionLabel LabelCoordinatesAndCoreFunctionality

#! This section describes the animation method and how to define vertex coordinates. Before the animation (see <K>DrawSurfaceToJavaScript</K> <Ref Subsect="DrawSurfaceToJavaScript"/>) can be drawn, it is necessary to specify the 3D-coordinates (which means, the [x,y,z] coordinates) of all vertices of the surface which should be animated (see <K>SetVertexCoordinates3D</K>).
#!
#! After setting the vertex coordinates, the location of the edges in <M>\mathbb{R}^3</M> has to be derived.
#! If this is not done, the animation becomes inconsistent, as the following example shows.
#! We animate a tetrahedron, but then we replace all vertex coordinates with their negatives (without recomputing the edge locations).
#! @BeginLog
#! gap> verticesPositions := [
#! > [ 1, -1/Sqrt(3.), -1/Sqrt(6.) ],
#! > [ -1, -1/Sqrt(3.), -1/Sqrt(6.) ],
#! > [ 0, 2/Sqrt(3.) , -1/Sqrt(6.) ],
#! > [ 0, 0, 3/Sqrt(6.) ] ];;
#! gap> verticesPositionsMirrored := -verticesPositions;;
#! gap> tet := Tetrahedron();;
#! gap> printRecord := SetVertexCoordinates3D(tet, verticesPositions, rec());;
#! gap> printRecord := CalculateParametersOfEdges(tet, printRecord);;
#! gap> # coordinates of the center of the edge (1,2):
#! > printRecord.edges[EdgeBetweenVertices(tet, 1, 2)][1];
#! [ 0., -0.57735, -0.408248 ]
#! gap> printRecord := SetVertexCoordinates3D(tet, verticesPositionsMirrored,
#! > printRecord);;
#! gap> # coordinates of the edge (1,2) did not change:
#! > printRecord.edges[EdgeBetweenVertices(tet, 1, 2)][1];
#! [ 0., -0.57735, -0.408248 ]
#! gap> DrawSurfaceToJavaScriptCalculate(tet,
#! > "Tetrahedron_PositionMirrored.html", printRecord, false);;
#! @EndLog
#! @InsertChunk Example_Tetrahedron_PositionMirrored
#! By default, the method <K>DrawSurfaceToJavaScript</K>(<Ref Subsect="DrawSurfaceToJavaScript"/>) always calculates the edge locations depending on the current vertices positions.
#! If you want to avoid that, you can use the method <K>DrawSurfaceToJavaScriptCalculate</K>(<Ref Subsect="DrawSurfaceToJavaScript"/>) and set the last parameter to false. In this case, only the first call of the method computes the edge locations.

#! @BeginGroup SetVertexCoordinates3D
#! @Description
#! Save the given list of 3D-coordinates in the given or an empty print record. If the format of the 3D-coordinates (3D-coordinates have to be a list of 3 entries of floats) is not correct, then an error is shown.
#! The NC-version does not check the coordinate format.
#! @Returns the updated print record.
#! @Arguments surface, coordinates[, printRecord]
DeclareOperation( "SetVertexCoordinates3D", [IsSimplicialSurface, IsDenseList, IsRecord] );
#! @Arguments surface, coordinates[, printRecord]
DeclareOperation( "SetVertexCoordinates3DNC", [IsSimplicialSurface, IsDenseList, IsRecord] );
#! @EndGroup

#! @BeginGroup GetVertexCoordinates3D
#! @Description
#! Extract the 3D-coordinates from the print record of the vertex i from surface. If the format of the 3D-coordinates (3D-coordinates have to be a list of 3 entries of floats) is not correct, then an error is shown. This can happen, if the NC version is used to store the 3D-coordinates.
#! The NC-version does not check the coordinate format saved in the print record.
#! @Returns the 3D-coordinates from the print record of the vertex i from surface.
#! @Arguments surface, i, printRecord
DeclareOperation( "GetVertexCoordinates3D", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "GetVertexCoordinates3DNC", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup DrawSurfaceToJavaScript
#! @Description
#! These methods animate the <A>surface</A> as a html file <A>filename</A> in JavaScript into the working directory. The animation can be opened and watched with any browser.
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
#! To use these methods it is necessary to set the 3D-coordinates (3D-coordinates are defined as a list with 3 entries of floats) of the vertices of the surface (see <K>SetVertexCoordinates3D</K>).
#!
#! The method <K>DrawSurfaceToJavaScript</K> always calculates the locations of the edges, inner circles and normales of inner circles corresponding to the current positions of the vertices. Therefore, the <A>printRecord</A> will be changed if some parameters are not set to the actual vertex positions.
#!
#! The method <K>DrawSurfaceToJavaScriptCalculate</K> has an extra parameter <A>calculate</A> which is a bool (true or false). To avoid permanent recalculation of derived locations, like for edges, (which should not be an issue during regular usage), you can use the method <K>DrawSurfaceToJavaScriptCalculate</K> and set <A>calculate = false</A>. Calculations are only performed at the first call of the method that needs to draw the derived objects.
#!
#! If you use the method <K>DrawSurfaceToJavaScriptCalculate</K> with <A>calculate = true</A> the method works like <K>DrawSurfaceToJavaScript</K>.
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
DeclareOperation( "DrawSurfaceToJavaScript", [IsSimplicialSurface, IsString, IsRecord] );
#! @Arguments surface, filename, printRecord, calculate
DeclareOperation( "DrawSurfaceToJavaScriptCalculate", [IsSimplicialSurface, IsString, IsRecord, IsBool] );
#! @EndGroup

#! @BeginGroup DrawSurfaceToJavaScript

#! @EndGroup

#! @BeginGroup CalculateParametersOfEdges
#! @Description
#! This method calculates the parameters of the edges (centre, length, angles relative to x-direction) based on the
#! coordinates of the vertices and saves those to the print record.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "CalculateParametersOfEdges", [IsSimplicialSurface, IsRecord] );
#! @EndGroup

#! @Section Visibility
#! @SectionLabel LabelVisibility

#! A simplicial surface is described through its vertices, edges, and faces. But sometimes, not all of them should be visible.
#! Therefore, it is possible to make the following visible and invisible:
#! <Enum>
#!   <Item>Vertices (see <Ref Subsect="ActivateVertices"/>) </Item>
#!   <Item>Edges (see <Ref Subsect="ActivateEdges"/>) </Item>
#!   <Item>Faces (see <Ref Subsect="ActivateFaces"/>) </Item>
#! </Enum>
#! By default, all vertices, edges, and faces are visible.

#! The following example shows the animation without vertices.
#! @BeginLog
#! gap> oct := Octahedron();;
#! gap> verticesPositions := [
#! > [ 0, 0, Sqrt(2.) ],
#! > [ 1, 1, 0 ],
#! > [ 1, -1, 0 ],
#! > [ -1, -1, 0 ],
#! > [ -1, 1, 0 ],
#! > [ 0, 0, -Sqrt(2.) ] ];;
#! gap> printRecord := SetVertexCoordinates3D(oct, verticesPositions, rec());;
# rec( vertexCoordinates3D := [ [ 0, 0, 1.41421 ], [ 1, 1, 0 ], [ 1, -1, 0 ], [ -1, -1, 0 ], [ -1, 1, 0 ], [ 0, 0, -1.41421 ] ] );
#! gap> printRecord := DeactivateVertices(oct, printRecord);;
#! gap> DrawSurfaceToJavaScript(oct, "octahedron.html", printRecord);;
#! @EndLog
#! @InsertChunk Example_OctahedronAnimatingWithoutVertices

#! We illustrade this functionality by animating an octahedron with none but the vertices 2 and 3 visible.
#! @BeginLog
#! gap> oct := Octahedron();;
#! gap> verticesPositions := [
#! > [ 0, 0, Sqrt(2.) ],
#! > [ 1, 1, 0 ],
#! > [ 1, -1, 0 ],
#! > [ -1, -1, 0 ],
#! > [ -1, 1, 0 ],
#! > [ 0, 0, -Sqrt(2.) ] ];;
#! gap> printRecord := SetVertexCoordinates3D(oct, verticesPositions, rec());;
#! gap> printRecord := DeactivateVertices(oct, printRecord);;
#! gap> printRecord := ActivateVertex(oct, 2, printRecord);;
#! gap> printRecord := ActivateVertex(oct, 3, printRecord);;
#! gap> List([1..NumberOfVertices(oct)], i -> IsVertexActive(oct, i, printRecord));
#! [ false, true, true, false, false, false ]
#! gap> DrawSurfaceToJavaScript(oct, "octahedron.html", printRecord);;
#! @EndLog
#! @InsertChunk Example_OctahedronAnimatingWithoutSomeVertices

#! @BeginGroup ActivateVertices
#! @Description
#! Activate all vertices. If a vertex is active, then the vertex is shown in the animation as a node. (For more information look at the start of the section <Ref Subsect="Section_LabelVisibility"/>)
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "ActivateVertices", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateVertices", [IsSimplicialSurface, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateVertex
#! @Description
#! Activate the vertex <A>i</A>. If a vertex is active, then the vertex is shown in the animation as a node. (For more information look at the start of the section <Ref Subsect="Section_LabelVisibility"/>)
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateVertex", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateVertex", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "IsVertexActive", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateEdges
#! @Description
#! Activate all edges. If an edge is active, then the edge is shown in the animation as a line. (For more information look at the start of the section <Ref Subsect="Section_LabelVisibility"/>)
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "ActivateEdges", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateEdges", [IsSimplicialSurface, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateEdge
#! @Description
#! Activate the edge <A>i</A>. If an edge is active, then he is shown as a line in the animation. (For more information look at the start of the section <Ref Subsect="Section_LabelVisibility"/>)
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateEdge", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateEdge", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "IsEdgeActive", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateFaces
#! @Description
#! Activate all faces. If a face is active, then the face is shown in the animation as an area. (For more information look at the start of the section <Ref Subsect="Section_LabelVisibility"/>)
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "ActivateFaces", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateFaces", [IsSimplicialSurface, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateFace
#! @Description
#! Activate the face <A>i</A>. If a face is active, then the face is shown in the animation as an area. (For more information look at the start of the section <Ref Subsect="Section_LabelVisibility"/>)
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateFace", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateFace", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "IsFaceActive", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup SetTransparency
#! @Description
#! Set the transparency of the face <A>i</A>. The value has to be between 0 and 1. 0 means that the face is invisible and 1 means that the face is opaque. The face will not change its transparency by using the transparency controller. (For more information look at the start of the section <Ref Subsect="Section_LabelVisibility"/>)
#! @Returns the updated print record.
#! @Arguments surface, i, value, printRecord
DeclareOperation( "SetTransparencyJava", [IsSimplicialSurface, IsPosInt, IsFloat, IsRecord] );
#! @EndGroup

#! @BeginGroup RemoveTransparency
#! @Description
#! Remove the transparency of the face <A>i</A>. After this the face act as a normal face without a strict transparency value. (For more information look at the start of the section <Ref Subsect="Section_LabelVisibility"/>)
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "RemoveTransparencyJava", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup GetTransparency
#! @Description
#! Get the transparency of the face <A>i</A>. If no transparency is set, the function returns 1. Otherwise the function returns the transparency value of the face <A>i</A>. (For more information look at the start of the section <Ref Subsect="Section_LabelVisibility"/>)
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "GetTransparencyJava", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @Section Colouring
#! @SectionLabel LabelColouring

#! In this section, we describe how to colour the animation. The colours are stored in hecadecimal format, which starts with 0x. The following possibilities are available:
#! <Enum>
#!   <Item>Vertices (The default colour is 0xF58137, an orange hue. See <Ref Subsect="SetVertexColours"/>)</Item>
#!   <Item>Edges (The default colour is 0xff0000, an red hue. See <Ref Subsect="SetEdgeColours"/>)</Item>
#!   <Item>Faces (The default colour is 0xFFFF00, an yellow hue. See <Ref Subsect="SetFaceColours"/>)</Item>
#! </Enum>
#! Some colours can also be referred to by strings, namely:
#! * Black = 0x000000
#! * Blue = 0x0000FF
#! * Brown = 0xA52A2A
#! * Green = 0x008000
#! * Orange = 0xFFA500
#! * Purple = 0x800080
#! * Pink = 0xFFC0CB
#! * Red = 0xFF0000
#! * White = 0xFFFFFF
#! * Yellow = 0xFFFF00

#! Here is a brief colouring example:
#! @BeginLog
#! gap> oct := Octahedron();;
#! gap> verticesPositions := [
#! > [ 0, 0, Sqrt(2.) ],
#! > [ 1, 1, 0 ],
#! > [ 1, -1, 0 ],
#! > [ -1, -1, 0 ],
#! > [ -1, 1, 0 ],
#! > [ 0, 0, -Sqrt(2.) ] ];;
#! gap> printRecord := SetVertexCoordinates3D(oct, verticesPositions, rec());;
#! gap> printRecord := SetVertexColours(oct,
#! > ListWithIdenticalEntries(NumberOfVertices(oct), "green"), printRecord);;
#! gap> printRecord := SetVertexColour(oct, 3, "red", printRecord);;
#! gap> List([1..NumberOfVertices(oct)], i -> GetVertexColour(oct, i, printRecord));
#! [ "green", "green", "red", "green", "green", "green" ]
#! gap> DrawSurfaceToJavaScript(oct, "octahedron.html", printRecord);;
#! @EndLog
#! @InsertChunk Example_OctahedronEdgeColors

#! @BeginGroup SetVertexColours
#! @Description
#! Set colours for all vertices. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code. For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>).
#! @Returns the updated print record.
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetVertexColours", [IsSimplicialSurface, IsDenseList, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "GetVertexColours", [IsSimplicialSurface, IsRecord] );
#! @EndGroup

#! @BeginGroup SetVertexColour
#! @Description
#! Set the <A>colour</A> of the vertex <A>i</A> from surface. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.  For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>).
#! @Returns the updated print record.
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetVertexColour", [IsSimplicialSurface, IsPosInt, IsString, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "GetVertexColour", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup SetEdgeColours
#! @Description
#! Set colours for all edges. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.  For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>).
#! @Returns the updated print record.
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetEdgeColours", [IsSimplicialSurface, IsDenseList, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "GetEdgeColours", [IsSimplicialSurface, IsRecord] );
#! @EndGroup

#! @BeginGroup SetEdgeColour
#! @Description
#! Set the <A>colour</A> of the edge <A>i</A> from surface. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.  For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>).
#! @Returns the updated print record.
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetEdgeColour", [IsSimplicialSurface, IsPosInt, IsString, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "GetEdgeColour", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup


#! @BeginGroup SetFaceColours
#! @Description
#! Set colours for all faces. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.  For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>).
#! @Returns the updated print record.
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetFaceColours", [IsSimplicialSurface, IsDenseList, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "GetFaceColours", [IsSimplicialSurface, IsRecord] );
#! @EndGroup

#! @BeginGroup SetFaceColour
#! @Description
#! Set the <A>colour</A> of the face <A>i</A> from surface. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.  For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>).
#! @Returns the updated print record.
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetFaceColour", [IsSimplicialSurface, IsPosInt, IsString, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "GetFaceColour", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @Section Inner Circles
#! @SectionLabel LabelInnerCirclesAnimating
#!

#! Inner circles are defined for triangular faces. In the animation, they are circles within the face that touch each edge in exactly one point.
#!
#! The functionality concerning the inner circles is completely similar to the functionality converning the edges.
#!
#! By default, the inner circles are inactive.
#!
#! The following options are implemented for inner circles:
#! <Enum>
#!   <Item>Activate and deactivate inner circles. If an inner circle is active, then he is shown in the animation. (See <Ref Subsect="ActivateInnerCircles"/>)</Item>
#!   <Item>Set colours of inner circles for the animation. (See <Ref Subsect="SetCircleColours"/>)</Item>
#!   <Item> If the manual-calculation mode from Section <Ref Subsect="DrawSurfaceToJavaScript"/> is used, inner circles (like edges) have to be manually recomputed. The method is <K>CalculateParametersOfInnerCircle</K> (see <Ref Subsect="CalculateParametersOfInnerCircle"/>). Compare the description in Section <Ref Subsect="DrawSurfaceToJavaScript"/> for more details on this mode. </Item>
#! </Enum>
#! @BeginLog
#! gap> oct := Octahedron();;
#! gap> verticesPositions := [
#! > [ 0, 0, Sqrt(2.) ],
#! > [ 1, 1, 0 ],
#! > [ 1, -1, 0 ],
#! > [ -1, -1, 0 ],
#! > [ -1, 1, 0 ],
#! > [ 0, 0, -Sqrt(2.) ] ];;
#! gap> printRecord := SetVertexCoordinates3D(oct, verticesPositions, rec());;
#! gap> printRecord := ActivateInnerCircles(oct,printRecord);;
#! gap> DrawSurfaceToJavaScript(oct, "Octahedron_InnerCircle.html", printRecord);;
#! @EndLog
#! @InsertChunk Example_OctahedronInnerCircle
#! @BeginLog
#! gap> oct := Octahedron();;
#! gap> verticesPositions := [
#! > [ 0, 0, Sqrt(2.) ],
#! > [ 1, 1, 0 ],
#! > [ 1, -1, 0 ],
#! > [ -1, -1, 0 ],
#! > [ -1, 1, 0 ],
#! > [ 0, 0, -Sqrt(2.) ] ];;
#! gap> printRecord := SetVertexCoordinates3D(oct, verticesPositions, rec());;
#! gap> printRecord := DeactivateFaces(oct,printRecord);;
#! gap> printRecord := ActivateInnerCircles(oct,printRecord);;
#! gap> DrawSurfaceToJavaScript(oct, "Octahedron_InnerCircle.html", printRecord);;
#! @EndLog
#! @InsertChunk Example_OctahedronInnerCircleWithoutFaces

#! @BeginGroup ActivateInnerCircles
#! @Description
#! For the description of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>. Activate all inner circles. If an inner circle is active, then it is shown in the animation.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "ActivateInnerCircles", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateInnerCircles", [IsSimplicialSurface, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateInnerCircle
#! @Description
#! For the description of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>. Activate the inner circle corresponding to the face <A>i</A> from surface. If an inner circle is active, then it is shown in the animation.
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateInnerCircle", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateInnerCircle", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "IsInnerCircleActive", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup SetCircleColours
#! @Description
#! For the description of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>. Set colours for all inner circles. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code. Compare Section <Ref Sect="Section_LabelColouring"/> for a list of default colours.)
#! @Returns the updated print record.
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetCircleColours", [IsSimplicialSurface, IsDenseList, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "GetCircleColours", [IsSimplicialSurface, IsRecord] );
#! @EndGroup

#! @BeginGroup SetCircleColour
#! @Description
#! For the description of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>. Set the <A>colour</A> of the inner circle corresponding to the face <A>i</A> from surface. (Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code. Compare Section <Ref Sect="Section_LabelColouring"/> for a list of default colours.)
#! @Returns the updated print record.
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetCircleColour", [IsSimplicialSurface, IsPosInt, IsString, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "GetCircleColour", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup CalculateParametersOfInnerCircle
#! @Description
#! For the description of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>. This method calculates the parameters of the innerer circles (incenter, radius, angles relative to x-y-plane) and their normal vectors (angles relative to x-direction) based on the
#! 3D-coordinates of the vertices and saves those to the print record.
#!
#! Note that this is necessary for the animation. Therefore, the method <K>CalculateParametersOfInnerCircle</K> gets called after using the method <K>DrawSurfaceToJavaScript</K>(<Ref Subsect="DrawSurfaceToJavaScript"/>) if no locations are calculated for the inner circles. If parameters are set for the inner circles and the 3D-coordinates of a vertex has been changed, then you have to call the method <K>CalculateParametersOfInnerCircle</K> manuel again if you use the method <K>DrawSurfaceToJavaScriptCalculate</K> with <A>calculate = false</A>. Otherwise the animation will be not necessarly correct. If you use the method <K>DrawSurfaceToJavaScript</K>(<Ref Subsect="DrawSurfaceToJavaScript"/>) the parameters will be updated automatically.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "CalculateParametersOfInnerCircle", [IsSimplicialSurface, IsRecord] );
#! @EndGroup

#! @Section Normales of Inner Circles
#! @SectionLabel LabelNormalesInnerCirclesAnimating
#!

#! A normal of an inner circle (compare Section <Ref Sect="Section_LabelInnerCirclesAnimating"/>) is a line intersecting the center of the circle orthogonally. (For the description of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>.)
#!
#! The normal vectors of inner circles can be (de-)activated like vertices, edges, and faces.
#! If the are active, they have the colour of the corresponding inner circle.
#! @BeginLog
#! gap> oct := Octahedron();;
#! gap> verticesPositions := [
#! > [ 0, 0, Sqrt(2.) ],
#! > [ 1, 1, 0 ],
#! > [ 1, -1, 0 ],
#! > [ -1, -1, 0 ],
#! > [ -1, 1, 0 ],
#! > [ 0, 0, -Sqrt(2.) ] ];;
#! gap> printRecord := SetVertexCoordinates3D(oct, verticesPositions, rec());;
#! gap> printRecord := ActivateNormalOfInnerCircles(oct,printRecord);;
#! gap> DrawSurfaceToJavaScript(oct, "Octahedron_InnerCircle.html", printRecord);;
#! @EndLog
#! @InsertChunk Example_OctahedronNormalesOfInnerCircle
#! @BeginLog
#! gap> oct := Octahedron();;
#! gap> verticesPositions := [
#! > [ 0, 0, Sqrt(2.) ],
#! > [ 1, 1, 0 ],
#! > [ 1, -1, 0 ],
#! > [ -1, -1, 0 ],
#! > [ -1, 1, 0 ],
#! > [ 0, 0, -Sqrt(2.) ] ];;
#! gap> printRecord := SetVertexCoordinates3D(oct, verticesPositions, rec());;
#! gap> printRecord := DeactivateFaces(oct,printRecord);;
#! gap> printRecord := ActivateNormalOfInnerCircles(oct,printRecord);;
#! gap> DrawSurfaceToJavaScript(oct, "Octahedron_InnerCircle.html", printRecord);;
#! @EndLog
#TODO activate the next line again
# @InsertChunk Example_OctahedronNormalesOfInnerCircleWithoutFaces

#! @BeginGroup ActivateNormalOfInnerCircles
#! @Description
#! For the description of normales of inner circles look at <Ref Sect="Section_LabelNormalesInnerCirclesAnimating"/>. Activate all normals innerer circles. If a normal is active, the normal is shown in the animation.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "ActivateNormalOfInnerCircles", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateNormalOfInnerCircles", [IsSimplicialSurface, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateNormalOfInnerCircle
#! @Description
#! For the description of normales of inner circles look at <Ref Sect="Section_LabelNormalesInnerCirclesAnimating"/>. Activate the normal of the face <A>i</A> from surface. If a normal is active, the normal is shown in the animation.
#! @Returns the updated print record.
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateNormalOfInnerCircle", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateNormalOfInnerCircle", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "IsNormalOfInnerCircleActive", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @Section Additional Parameters
#! @SectionLabel AdditionalParameters
#!

#!The printRecord can have optional parameters to modify the output in the html file.

#!In large examples it can be a little bit hard to recognize all the edges. For this, one could change the parameter <A>edgeThickness</A>. The default value is set to $0.01$. We recommend choosing a value in the range $0.01-0.05$.



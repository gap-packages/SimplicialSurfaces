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
#! <E> There is a newer version available in beta at the following branch: <C>animations</C>. It implements a newer revision of the three.js framework
#! and some other improvements. To use it, just type <C>git checkout animations</C>. </E>
#! 
#! This chapter deals with animating simplicial surfaces via Java Script
#! using three.js, see <URL>https://threejs.org/</URL>.

#! @Section Introduction and Quick Start
#! @SectionLabel LabelIntroductionAndQuickStartAnimating

#! This section contains a minimal example by animating an octahedron and shows the general animation workflow.
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
#! gap> DrawSurfaceToJavaScript(oct, "octahedron.html", printRecord);;
#! @EndLog
#! Now, your working directory should contain a file "octahedron.html". Here is an image of the animation:
#! @InsertChunk Example_OctahedronAnimating

#! The philosophy of the code presented in this chapter is as follows:
#! The main method <K>DrawSurfaceToJavaScript</K> (Section <Ref Sect="Section_LabelCoordinatesAndCoreFunctionality"/>)
#! animates the surfaces using the configuration saved in the so called  <A>print record</A>,
#! e.g. the the 3D-coordinates (lists with three float entries) of the vertices.
#! It is necessary that the print record contains the 3D-coordinates of each vertex of the surface which should be animated.
#! Based on the 3D-coordinates of the vertices, the surface is placed in the animation.
#! Therefore, a typical workflow to animate a surfaces looks like this:
#! <Enum>
#!   <Item>Construct the surface, e.g. the octahedron above.</Item>
#!   <Item>Configure your animation using the methods in the Sections
#!   <Ref Subsect="Section_LabelVisibility"/> and <Ref Subsect="Section_LabelColouring"/>.</Item>
#!   <Item>Write your animation to a file calling the main method <K>DrawSurfaceToJavaScript</K>
#!        (see Section <Ref Sect="Section_LabelCoordinatesAndCoreFunctionality"/>).</Item>
#! </Enum>
#! The output of the method <K>DrawSurfaceToJavaScript</K>(<Ref Subsect="DrawSurfaceToJavaScript"/>) is an html file.
#! The file can be opened with any browser and then the animation is shown directly.

#! @Section Coordinates and Core Functionality
#! @SectionLabel LabelCoordinatesAndCoreFunctionality

#! This section describes the animation method and how to define vertex coordinates.
#! Before the animation (see <K>DrawSurfaceToJavaScript</K> <Ref Subsect="DrawSurfaceToJavaScript"/>) can be drawn,
#! it is necessary to specify the 3D-coordinates (which means, the [x,y,z] coordinates) of all vertices
#! of the surface which should be animated (see <K>SetVertexCoordinates3D</K> <Ref Subsect="SetVertexCoordinates3D"/>).
#!
#! After setting the vertex coordinates, the location of the edges in <M>\mathbb{R}^3</M> has to be derived.
#! By default, the method <K>DrawSurfaceToJavaScript</K>(<Ref Subsect="DrawSurfaceToJavaScript"/>)
#! always calculates the edge locations depending on the current vertices positions.
#! If you want to avoid that, you can use the method <K>DrawSurfaceToJavaScriptCalculate</K>(<Ref Subsect="DrawSurfaceToJavaScript"/>)
#! and set the last parameter to false. In this case, only the first call of the method computes the edge locations.
#! Using this method can make the animation inconsistent if the coordinates of the vertices have changed but the edge locations have stayed the same.
#!
#! To show this problem animate a tetrahedron:
#! @BeginLog
#! gap> verticesPositions := [
#! > [ 1, -1/Sqrt(3.), -1/Sqrt(6.) ],
#! > [ -1, -1/Sqrt(3.), -1/Sqrt(6.) ],
#! > [ 0, 2/Sqrt(3.) , -1/Sqrt(6.) ],
#! > [ 0, 0, 3/Sqrt(6.) ] ];;
#! gap> tet := Tetrahedron();;
#! gap> printRecord := SetVertexCoordinates3D(tet, verticesPositions, rec());;
#! gap> printRecord := CalculateParametersOfEdges(tet, printRecord);;
#! gap> printRecord.edges[EdgeBetweenVertices(tet, 1, 2)][1];
#! [ 0., -0.57735, -0.408248 ]
#! @EndLog
#! Now replace the vertex coordinates by their negatives but
#! the coordinates of  the edges stay the same.
#! This leads to an inconstistent animation:
#! @BeginLog
#! gap> verticesPositionsMirrored := -verticesPositions;;
#! gap> printRecord := SetVertexCoordinates3D(tet, verticesPositionsMirrored,
#! > printRecord);;
#! gap> printRecord.edges[EdgeBetweenVertices(tet, 1, 2)][1];
#! [ 0., -0.57735, -0.408248 ]
#! gap> DrawSurfaceToJavaScriptCalculate(tet,
#! > "Tetrahedron_PositionMirrored.html", printRecord, false);;
#! @EndLog
#! @InsertChunk Example_Tetrahedron_PositionMirrored
#! 
#! Note, it is also possible to animate simplicial surfaces whose vertices,
#! edges and faces are not given by a dense list <K>[1..n]</K>.
#! For example the function <K>SetVertexCoordinates3D</K> allows a list of
#! 3D-coordinates as input that is not dense. But this only works in the case 
#! that the 3D-coordinate of vertex <K>i</K> is stored in the <K>i</K>-th
#! position of the given list.
#!
#! @BeginExampleSession
#! gap> oneFace:=SimplicialSurfaceByDownwardIncidence([,[3,7],,[7,10],,[3,10]],
#! > [,,[2,4,6]]);;
#! gap> Vertices(oneFace);
#! [ 3, 7, 10 ]
#! gap> coor:=[];;
#! gap> coor[3]:=[1,0,0];;coor[7]:=[0,1,0];;coor[10]:=[0,0,1];;
#! gap> printRecord:=SetVertexCoordinates3D(oneFace,coor,rec());;
#! gap> DrawSurfaceToJavaScript(oneFace,"OneFace_animating",printRecord);
#! rec( edges := [ , [ [ 0.5, 0.5, 0. ], 1.41421, [ 0., 3.14159, -0.785398 ] ],, 
#!      [ [ 0., 0.5, 0.5 ], 1.41421, [ 0., -1.5708, -2.35619 ] ],, 
#!      [ [ 0.5, 0., 0.5 ], 1.41421, [ 0., -2.35619, -1.5708 ] ] ], 
#!  vertexCoordinates3D := [ ,, [ 1, 0, 0 ],,,, [ 0, 1, 0 ],,, [ 0, 0, 1 ] ] )  
#! @EndExampleSession
#!
#! @InsertChunk Example_OneFaceAnimating
#!
#! @BeginGroup SetVertexCoordinates3D
#! @Description
#! Save the given list of 3D-coordinates <A>coordinates</A> in the given or an empty print record.
#! The list <A>coordinates</A> has to have entries that are a list <A>[x,y,z]</A> of three floats.
#! If the format of the <A>coordinates</A> is not correct, then an error is shown.
#! The NC-version does not check the coordinate format.
#! @Returns the updated print record
#! @Arguments surface, coordinates[, printRecord]
DeclareOperation( "SetVertexCoordinates3D", [IsSimplicialSurface, IsList, IsRecord] );
#! @Arguments surface, coordinates[, printRecord]
DeclareOperation( "SetVertexCoordinates3DNC", [IsSimplicialSurface, IsList, IsRecord] );
#! @EndGroup

#! @BeginGroup GetVertexCoordinates3D
#! @Description
#! Extract the 3D-coordinates from the print record of the vertex <A>vertex</A> from <A>surface</A>.
#! The 3D-coordinates of vertex <A>vertex</A> has to have the format <A>[x,y,z]</A>.
#! If the format of the <A>coordinates</A> is not correct, then an error is shown.
#! This can happen, if the NC version is used to store the 3D-coordinates.
#! The NC-version does not check the coordinate format saved in the print record.
#! @Returns a list
#! @Arguments surface, vertex, printRecord
DeclareOperation( "GetVertexCoordinates3D", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, vertex, printRecord
DeclareOperation( "GetVertexCoordinates3DNC", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup DrawSurfaceToJavaScript
#! @Description
#! These methods animate the <A>surface</A> as a html file <A>filename</A> in JavaScript into the working directory.
#! The animation can be opened and watched with any browser.
#! An introduction to the use of this method with two examples
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
#! To use these methods it is necessary to set the 3D-coordinates 
#! of the vertices of the surface (see <K>SetVertexCoordinates3D</K>).
#!
#! The method <K>DrawSurfaceToJavaScript</K> always calculates the locations of the edges,
#! inner circles and normals of inner circles corresponding to the current positions of the vertices.
#! Therefore, the <A>printRecord</A> will be changed if some parameters are not set to the actual vertex positions.
#!
#! The method <K>DrawSurfaceToJavaScriptCalculate</K> has an extra parameter <A>calculate</A>
#! which is true or false. To avoid permanent recalculation of derived locations,
#! like for edges, (which should not be an issue during regular usage), you can use the method
#! <K>DrawSurfaceToJavaScriptCalculate</K> and set <A>calculate = false</A>.
#! Calculations are only performed at the first call of the method that needs to draw the derived objects.
#!
#! If you use the method <K>DrawSurfaceToJavaScriptCalculate</K> with <A>calculate = true</A> the method works like <K>DrawSurfaceToJavaScript</K>.
#!
#! There are two parameters to change the output of this method.
#! There are the following classes of parameters:
#! * <E>Visibility</E>
#!   (<Ref Subsect="Section_LabelVisibility"/>): Change the
#!   visibility of vertices, edges and faces.
#! * <E>Colours</E>
#!   (<Ref Subsect="Section_LabelColouring"/>): Change the
#!   colours of vertices, edges and faces.
#!
#! There are also options for inner circles (<Ref Subsect="Section_LabelInnerCirclesAnimating"/>)
#! and normals of inner circles (<Ref Subsect="Section_LabelNormalsInnerCirclesAnimating"/>).
#! @Returns the updated print record
#! @Arguments surface, filename, printRecord
DeclareOperation( "DrawSurfaceToJavaScript", [IsSimplicialSurface, IsString, IsRecord] );
#! @Arguments surface, filename, printRecord, calculate
DeclareOperation( "DrawSurfaceToJavaScriptCalculate", [IsSimplicialSurface, IsString, IsRecord, IsBool] );
#! @EndGroup

#! @BeginGroup CalculateParametersOfEdges
#! @Description
#! This method calculates the parameters of the edges (centre, length, angles relative to x-direction) based on the
#! coordinates of the vertices and saves those to the print record.
#! @Returns the updated print record
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
#! In <Ref Subsect="SetTransparency"/> it is described how we can change the transparency of the faces.

#! The following example shows an animation with invisible vertices.
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
#! gap> DrawSurfaceToJavaScript(oct, "octahedron.html", printRecord);;
#! @EndLog
#! @InsertChunk Example_OctahedronAnimatingWithoutVertices

#! It is also possible that some vertices are visible and others are not.
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
#! The method <K>ActivateVertex</K>(<A>surface</A>, <A>i</A>, <A>printRecord</A>) activates the vertex <A>i</A>.
#! If a vertex is active, then the vertex is shown in the animation as a node with the number <A>i</A>.
#! The method <K>ActivateVertices</K>(<A>surface</A>, <A>printRecord</A>) activates all vertices of <A>surface</A>.
#! By default, all vertices are activated.
#! @Returns the updated print record
#! @Arguments surface, printRecord
DeclareOperation( "ActivateVertices", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateVertex", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "IsVertexActive", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup DeactivateVertices
#! @Description
#! The method <K>DeactivateVertex</K>(<A>surface</A>, <A>i</A>, <A>printRecord</A>) deactivates the vertex <A>i</A>.
#! If a vertex is inactive, then the vertex is not shown separately.
#! The method <K>DeactivateVertices</K>(<A>surface</A>, <A>printRecord</A>) deactivates all vertices of <A>surface</A>.
#! By default, all vertices are activated.
#! @Returns the updated print record
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateVertices", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateVertex", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateEdges
#! @Description
#! The method <K>ActivateEdge</K>(<A>surface</A>, <A>i</A>, <A>printRecord</A>) activates the edge <A>i</A>.
#! If an edge is active, then the edge is shown in the animation as a line.
#! The method <K>ActivateEdges</K>(<A>surface</A>, <A>printRecord</A>) activates all edges of <A>surface</A>.
#! By default, all edges are activated.
#! @Returns the updated print record
#! @Arguments surface, printRecord
DeclareOperation( "ActivateEdges", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateEdge", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "IsEdgeActive", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup DeactivateEdges
#! @Description
#! The method <K>DeactivateEdge</K>(<A>surface</A>, <A>i</A>, <A>printRecord</A>) deactivates the edge <A>i</A>.
#! If an edge is inactive, then the edge is not shown in the animation as a line.
#! The method <K>DeactivateEdges</K>(<A>surface</A>, <A>printRecord</A>) deactivates all edges of <A>surface</A>.
#! By default, all edges are activated.
#! @Returns the updated print record
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateEdges", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateEdge", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup ActivateFaces
#! @Description
#! The method <K>ActivateFace</K>(<A>surface</A>, <A>i</A>, <A>printRecord</A>) activates the face <A>i</A>.
#! If a face is active, then the face is shown in the animation as an area.
#! The method <K>ActivateFaces</K>(<A>surface</A>, <A>printRecord</A>) activates all faces of <A>surface</A>.
#! By default, all faces are activated.
#! @Returns the updated print record
#! @Arguments surface, printRecord
DeclareOperation( "ActivateFaces", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateFace", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "IsFaceActive", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup DeactivateFaces
#! @Description
#! The method <K>DeactivateFace</K>(<A>surface</A>, <A>i</A>, <A>printRecord</A>) deactivates the face <A>i</A>.
#! If an face is inactive, then the face is not shown in the animation as an area.
#! The method <K>DeactivateFace</K>(<A>surface</A>, <A>printRecord</A>) deactivates all faces of <A>surface</A>.
#! By default, all faces are activated.
#! @Returns the updated print record
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateFaces", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateFace", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup SetTransparency
#! @Description
#! Set the transparency of the face <A>face</A>. The parameter <A>value</A> has to be between 0 and 1.
#! 0 means that the face is invisible and 1 means that the face is opaque.
#! The face will not change its transparency by using the transparency controller.
#! @Returns the updated print record
#! @Arguments surface, face, value, printRecord
DeclareOperation( "SetTransparencyJava", [IsSimplicialSurface, IsPosInt, IsFloat, IsRecord] );
#! @EndGroup

#! @BeginGroup RemoveTransparency
#! @Description
#! Remove the transparency of the face <A>face</A>.
#! After this the face act as a normal face without a strict transparency value.
#! @Returns the updated print record
#! @Arguments surface, face, printRecord
DeclareOperation( "RemoveTransparencyJava", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup GetTransparency
#! @Description
#! Get the transparency of the face <A>face</A>. If no transparency is set, the function returns 1.
#! Otherwise the function returns the transparency value of the face <A>face</A>.
#! @Returns the updated print record
#! @Arguments surface, face, printRecord
DeclareOperation( "GetTransparencyJava", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @Section Colouring
#! @SectionLabel LabelColouring

#! In this section, we describe how to colour the animation. The colours are stored in hexadecimal format, which starts with 0x.
#! The following possibilities are available:
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
#! The method <K>SetVertexColour</K>(<A>surface</A>, <A>i</A>, <A>colour</A>, <A>printRecord</A>) sets the colour of vertex <A>i</A> to <A>colour</A>.
#! The method <K>SetVertexColours</K>(<A>surface</A>,<A>newColoursList</A>, <A>printRecord</A>) sets the colours for all vertices of <A>surface</A>.
#! That means the method set the colour of vertex <A>j</A> to <A>newColoursList[j]</A>.
#! The default colour for all vertices is 0xF58137, an orange hue.
#! Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.
#! For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>.
#! @Returns a print record
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetVertexColours", [IsSimplicialSurface, IsList, IsRecord] );
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetVertexColour", [IsSimplicialSurface, IsPosInt, IsString, IsRecord] );
#! @EndGroup

#! @BeginGroup GetVertexColours
#! @Description
#! The method <K>GetVertexColour</K>(<A>surface</A>, <A>i</A>, <A>printRecord</A>) returns the colour of vertex <A>i</A>.
#! The method <K>GetVertexColours</K>(<A>surface</A>, <A>printRecord</A>) returns the colours for all vertices of <A>surface</A>
#! as a list <A>colours</A>, where the colour of vertex <A>j</A> is <A>colours[j]</A>.
#! The default colour for all vertices is 0xF58137, an orange hue.
#! Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.
#! For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>.
#! @Returns a print record
#! @Arguments surface, printRecord
DeclareOperation( "GetVertexColours", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "GetVertexColour", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup SetEdgeColours
#! @Description
#! The method <K>SetEdgeColour</K>(<A>surface</A>, <A>i</A>, <A>colour</A>, <A>printRecord</A>) sets the colour of edge <A>i</A> to <A>colour</A>.
#! The method <K>SetEdgeColours</K>(<A>surface</A>,<A>newColoursList</A>, <A>printRecord</A>) sets the colours for all edges of <A>surface</A>.
#! That means the method set the colour of edge <A>j</A> to <A>newColoursList[j]</A>.
#! The default colour for all edges is 0xff0000, an red hue.
#! Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.
#! For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>.
#! @Returns a print record
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetEdgeColours", [IsSimplicialSurface, IsList, IsRecord] );
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetEdgeColour", [IsSimplicialSurface, IsPosInt, IsString, IsRecord] );
#! @EndGroup

#! @BeginGroup GetEdgeColours
#! @Description
#! The method <K>GetEdgeColour</K>(<A>surface</A>, <A>i</A>, <A>printRecord</A>) returns the colour of edge <A>i</A>.
#! The method <K>GetEdgeColours</K>(<A>surface</A>, <A>printRecord</A>) returns the colours for all edges of <A>surface</A>
#! as a list <A>colours</A>, where the colour of edge <A>j</A> is <A>colours[j]</A>.
#! The default colour for all edges is 0xff0000, an red hue.
#! Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.
#! For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>.
#! @Returns a print record
#! @Arguments surface, printRecord
DeclareOperation( "GetEdgeColours", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "GetEdgeColour", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup SetFaceColours
#! @Description
#! The method <K>SetFaceColour</K>(<A>surface</A>, <A>i</A>, <A>colour</A>, <A>printRecord</A>) sets the colour of face <A>i</A> to <A>colour</A>.
#! The method <K>SetFaceColours</K>(<A>surface</A>,<A>newColoursList</A>, <A>printRecord</A>) sets the colours for all faces of <A>surface</A>.
#! That means the method set the colour of face <A>j</A> to <A>newColoursList[j]</A>.
#! The default colour for all faces is 0xFFFF00, an yellow hue.
#! Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.
#! For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>.
#! @Returns a print record
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetFaceColours", [IsSimplicialSurface, IsList, IsRecord] );
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetFaceColour", [IsSimplicialSurface, IsPosInt, IsString, IsRecord] );
#! @EndGroup

#! @BeginGroup GetFaceColours
#! @Description
#! The method <K>GetFaceColour</K>(<A>surface</A>, <A>i</A>, <A>printRecord</A>) returns the colour of face <A>i</A>.
#! The method <K>GetFaceColours</K>(<A>surface</A>, <A>printRecord</A>) returns the colours for all faces of <A>surface</A>
#! as a list <A>colours</A>, where the colour of face <A>j</A> is <A>colours[j]</A>.
#! The default colour for all faces is 0xFFFF00, an yellow hue.
#! Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.
#! For more information look at the start of the section <Ref Subsect="Section_LabelColouring"/>.
#! @Returns a print record
#! @Arguments surface, printRecord
DeclareOperation( "GetFaceColours", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "GetFaceColour", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @Section Inner Circles
#! @SectionLabel LabelInnerCirclesAnimating
#! Inner circles are defined for triangular faces.
#! In the animation, they are circles within the face that touch each edge in exactly one point.
#!
#! The functionality concerning the inner circles is completely similar to the functionality concerning the edges.
#!
#! By default, the inner circles are inactive.
#!
#! The following options are implemented for inner circles:
#! <Enum>
#!   <Item>Activate and deactivate inner circles. If an inner circle is active, then it is shown in the animation.
#!         (See <Ref Subsect="ActivateInnerCircles"/>)</Item>
#!   <Item>Set colours of inner circles for the animation. (See <Ref Subsect="SetCircleColours"/>)</Item>
#!   <Item> If the manual-calculation mode from Section <Ref Subsect="DrawSurfaceToJavaScript"/> is used,
#!          inner circles (like edges) have to be manually recomputed. The method is <K>CalculateParametersOfInnerCircle</K>
#!          (see <Ref Subsect="CalculateParametersOfInnerCircle"/>). Compare the description in Section
#!          <Ref Subsect="DrawSurfaceToJavaScript"/> for more details on this mode. </Item>
#! </Enum>
#! For example, consider the octahedron:
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
#! Consider the octahedron if the faces are deactivated:
#! @InsertChunk Example_OctahedronInnerCircleWithoutFaces

#! @BeginGroup ActivateInnerCircles
#! @Description
#! The method <K>ActivateInnerCircles</K>(<A>surface</A>, <A>i</A>, <A>printRecord</A>) activates the inner circle of face <A>i</A>.
#! The method <K>ActivateInnerCircle</K>(<A>surface</A>, <A>printRecord</A>) activates all inner circles of <A>surface</A>.
#! If an inner circle is active, then it is shown in the animation.
#! By default, the inner circles are deactivated.
#! For the description of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>.
#! @Returns a print record
#! @Arguments surface, printRecord
DeclareOperation( "ActivateInnerCircles", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateInnerCircle", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "IsInnerCircleActive", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup DeactivateInnerCircles
#! @Description
#! The method <K>DeactivateInnerCircles</K>(<A>surface</A>, <A>i</A>, <A>printRecord</A>) deactivates the inner circle of face <A>i</A>.
#! The method <K>DeactivateInnerCircle</K>(<A>surface</A>, <A>printRecord</A>) deactivates all inner circles of <A>surface</A>.
#! If an inner circle is deactivated, then it is not shown in the animation.
#! By default, the inner circles are deactivated.
#! For the description of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>.
#! @Returns a print record
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateInnerCircles", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateInnerCircle", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup SetCircleColours
#! @Description
#! The method <K>SetCircleColour</K>(<A>surface</A>, <A>i</A>, <A>colour</A>, <A>printRecord</A>) sets the colour for the inner circle of face <A>i</A>.
#! The method <K>SetCircleColours</K>(<A>surface</A>, <A>newColoursList</A>, <A>printRecord</A>) sets the colour for all inner circles of <A>surface</A>.
#! That means the method set the colour of the inner circle of face <A>j</A> to <A>newColoursList[j]</A>.
#! The default colour is 0x000000, an black hue.
#! Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.
#! Compare Section <Ref Sect="Section_LabelColouring"/> for a list of default colours.
#! For the description of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>.
#! @Returns a print record
#! @Arguments surface, newColoursList, printRecord
DeclareOperation( "SetCircleColours", [IsSimplicialSurface, IsList, IsRecord] );
#! @Arguments surface, i, colour, printRecord
DeclareOperation( "SetCircleColour", [IsSimplicialSurface, IsPosInt, IsString, IsRecord] );
#! @EndGroup

#! @BeginGroup GetCircleColours
#! @Description
#! The method <K>GetCircleColour</K>(<A>surface</A>, <A>i</A>, <A>printRecord</A>) returns the colour for the inner circle of face <A>i</A>.
#! The method <K>GetCircleColours</K>(<A>surface</A>, <A>printRecord</A>) returns the colour for all inner circles of <A>surface</A>
#! as a list <A>colours</A>, where the colour of the inner circle of face <A>j</A> is <A>colours[j]</A>.
#! The default colour is 0x000000, an black hue.
#! Colours are stored in the format 0xABCDEF where A,B,C,D,E,F are elements of the hexadecimal code.
#! Compare Section <Ref Sect="Section_LabelColouring"/> for a list of default colours.
#! For the description of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>.
#! @Returns a print record
#! @Arguments surface, printRecord
DeclareOperation( "GetCircleColours", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "GetCircleColour", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup CalculateParametersOfInnerCircle
#! @Description
#! This method calculates the parameters of the inner circles (incenter, radius, angles relative to x-y-plane)
#! and their normal vectors (angles relative to x-direction) based on the
#! 3D-coordinates of the vertices and saves those to the print record.
#! For the description of inner circles look at <Ref Sect="Section_LabelInnerCirclesAnimating"/>.
#!
#! Note that this is necessary for the animation. Therefore, the method <K>CalculateParametersOfInnerCircle</K>
#! gets called after using the method <K>DrawSurfaceToJavaScript</K>(<Ref Subsect="DrawSurfaceToJavaScript"/>)
#! if no locations are calculated for the inner circles. If parameters are set for the inner circles and the
#! 3D-coordinates of a vertex has been changed, then you have to call the method <K>CalculateParametersOfInnerCircle</K>
#! manual again if you use the method <K>DrawSurfaceToJavaScriptCalculate</K> with <A>calculate = false</A>.
#! Otherwise the animation will be not necessarily correct. If you use the method
#! <K>DrawSurfaceToJavaScript</K>(<Ref Subsect="DrawSurfaceToJavaScript"/>) the parameters will be updated automatically.
#! @Returns the updated print record.
#! @Arguments surface, printRecord
DeclareOperation( "CalculateParametersOfInnerCircle", [IsSimplicialSurface, IsRecord] );
#! @EndGroup

#! @Section Normals of Inner Circles
#! @SectionLabel LabelNormalsInnerCirclesAnimating
#!

#! A normal of an inner circle (compare Section <Ref Sect="Section_LabelInnerCirclesAnimating"/>) is a line
#! intersecting the center of the circle orthogonally.
#!
#! The normal vectors of inner circles can be (de-)activated like vertices, edges, and faces.
#! If the are active, they have the colour of the corresponding inner circle.
#! For example, consider the octahedron:
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
#! @InsertChunk Example_OctahedronNormalsOfInnerCircle
#! Consider the octahedron if the faces are deactivated:
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
# @InsertChunk Example_OctahedronNormalsOfInnerCircleWithoutFaces

#! @BeginGroup ActivateNormalOfInnerCircles
#! @Description
#! The method <K>ActivateNormalOfInnerCircles</K>(<A>surface</A>, <A>i</A>, <A>printRecord</A>) activates the normal of the inner circle of face <A>i</A>.
#! The method <K>ActivateNormalOfInnerCircle</K>(<A>surface</A>, <A>printRecord</A>) activates all normals of the inner circles of <A>surface</A>.
#! If a normal is active, then the normal is shown in the animation.
#! By default, the normals of inner circles are deactivated.
#! For the description of normals of inner circles look at <Ref Sect="Section_LabelNormalsInnerCirclesAnimating"/>.
#! @Returns a print record
#! @Arguments surface, printRecord
DeclareOperation( "ActivateNormalOfInnerCircles", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "ActivateNormalOfInnerCircle", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "IsNormalOfInnerCircleActive", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @BeginGroup DeactivateNormalOfInnerCircles
#! @Description
#! The method <K>DeactivateNormalOfInnerCircles</K>(<A>surface</A>, <A>i</A>, <A>printRecord</A>) deactivates the normal of the inner circle of face <A>i</A>.
#! The method <K>DeactivateNormalOfInnerCircle</K>(<A>surface</A>, <A>printRecord</A>) deactivates all normals of the inner circles of <A>surface</A>.
#! If a normal is deactivated, then the normal is not shown in the animation.
#! By default, the normals of inner circles are deactivated.
#! For the description of normals inner circles look at <Ref Sect="Section_LabelNormalsInnerCirclesAnimating"/>.
#! @Returns a print record
#! @Arguments surface, printRecord
DeclareOperation( "DeactivateNormalOfInnerCircles", [IsSimplicialSurface, IsRecord] );
#! @Arguments surface, i, printRecord
DeclareOperation( "DeactivateNormalOfInnerCircle", [IsSimplicialSurface, IsPosInt, IsRecord] );
#! @EndGroup

#! @Section Additional Parameters
#! @SectionLabel AdditionalParameters
#! The printRecord can have optional parameters to modify the output in the html file.

#! In large examples it can be a little bit hard to recognize all the edges.
#! For this, one could change the parameter <A>edgeThickness</A>. The default value is set to $0.01$. We recommend choosing a value in the range $0.01-0.05$.

#! An image of an octahedron with thicker edges which is produced by the following code is shown below.
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
#! gap> printRecord.edgeThickness:=0.03;
#! gap> DrawSurfaceToJavaScript(oct, "doc/Octahedron_ThickEdges.html", printRecord);;
#! @EndLog
#! @InsertChunk Example_OctahedronThickEdges



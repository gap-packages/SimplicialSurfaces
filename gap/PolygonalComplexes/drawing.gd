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

##
## WARNING: This file should NOT be read if the package is loaded.
## It contains examples for the manual and should only be used then.
##
if not __SIMPLICIAL_MANUAL_MODE then
    Error("The file 'drawing.gd' should only be read to generate the manual.");
fi;


#! @BeginChunk DrawSurfaceToTikz_Tutorial
#! While it is very hard to compute an embedding into <M>&RR;^3</M> it is
#! quite easy to draw the net of a ramified polygonal surface into a
#! plane.
#!
#! For example, the net of an octahedron can be drawn like this:
#! @BeginLog
oct := Octahedron();;
DrawSurfaceToTikz( oct, "Octahedron_example" );;
#! @EndLog
#!
#! This will write a file <E>Octahedron_example.tex</E> that contains the net of
#! the octahedron, written in <K>TikZ</K>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Octahedron_example-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Octahedron_example.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!
#! To customize this drawing, a record is used (called the <A>printRecord</A>).
#! Each call of the drawing method creates one of those:
#! @BeginLog
pr := DrawSurfaceToTikz( oct, "Octahedron_example" );;
#! @EndLog
#!
#! Maybe the edges should not be labelled. Then they can be turned off:
#! @BeginLog
pr.edgeLabelsActive := false;;
#! @EndLog
#!
#! The colours can also be changed very easily (especially if all colours
#! should be changed at once). For example, let's make all vertices green:
#! @BeginLog
pr.vertexColours := "green";;
#! @EndLog
#!
#! After compiling we get the following net.
#! @BeginLog
DrawSurfaceToTikz( oct, "Octahedron_recoloured.tex", pr );;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Octahedron_recoloured-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Octahedron_recoloured.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! It should be mentioned that all of these calls modify their 
#! <A>printRecord</A>.
#! 
#! Since it is impractical to always call &LaTeX; for every customization
#! we can call it directly from within &GAP;:
#! @BeginLog
pr.compileLaTeX := true;;
#! @EndLog
#!
#! Still the picture looks quite small. To see how big it currently is, we
#! can look at the parameter <A>scale</A>:
#! @BeginLog
pr.scale;
#! 2
#! @EndLog
#! So the default <A>scale</A> is 2. Since there is a lot of space left,
#! we can set the <A>scale</A> to 3. Furthermore we label the faces with
#! roman numbers.
#! @BeginLog
pr.scale := 3;;
pr.faceLabels := ["I","II","III","IV","V","VI","VII","VIII"];;
DrawSurfaceToTikz( oct, "Octahedron_customized.tex", pr );;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Octahedron_customized-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Octahedron_customized.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!
#! Next we would like to change the shapes of the triangles. To do so we need
#! to know how long the edges are.
#! @BeginLog
pr.edgeLabelsActive := true;;
DrawSurfaceToTikz( oct, "Octahedron_edgeLabels", pr );;
pr.edgeLengths;
#! [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Octahedron_edgeLabels-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Octahedron_edgeLabels.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!
#! We want to make the angles around vertex 1 larger, for example:
#! @BeginLog
pr.edgeLengths := [ 1, 1, 1, 1, 1.5, 1.5, 1, 1.5, 1, 1.5, 1, 1 ];;
#! @EndLog
#! Since the <A>printRecord</A> also remembers the angles, this information
#! has to be discarded before the recomputation.
#! @BeginLog
Unbind( pr.angles );
DrawSurfaceToTikz( oct, "Octahedron_reshaped", pr );
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Octahedron_reshaped-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Octahedron_reshaped.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! 
#! We can see that the program chooses to display a different net to avoid
#! self-intersections. If the system can not easily avoid intersections it
#! will split up the surface and draw these components separately. This feature 
#! can be turned off by setting the
#! parameter <A>avoidIntersections</A> to <K>false</K>.
#
#! @EndChunk

#! @BeginChunk DrawSurfaceToTikz_Colours
#! This subsection covers how to change the colours of vertices, edges and 
#! faces in the drawings 
#! from <K>DrawSurfaceToTikz</K> (<Ref Subsect="DrawSurfaceToTikz"/>).
#! It covers the following parameters:
#! * <E>vertexColours</E>: Modify the colours of the vertices (the default
#!   colour is orange).
#! * <E>edgeColours</E>: Modify the colours of the edges (the default
#!   colour is gray).
#! * <E>faceColours</E>: Modify the colours of the face (the default
#!   colour is a darker shade of yellow).
#!
#! We will exemplify them with the example of a cube. Here the cube has holes in the 
#! vertex, edge and face sets to make it more clear how the parameters work:
#! @BeginLog
cube := PolygonalComplexByDownwardIncidence([ [ 1, 2 ], [ 2, 3 ], [ 3, 4 ], 
[ 1, 4 ], [ 2, 7 ], , [ 3, 8 ], [ 4, 9 ], [ 1, 6 ], [ 7, 8 ] ,[ 8, 9 ],
[ 6, 9 ], [ 6, 7 ] ],[ [ 1, 2, 3, 4 ], ,[ 1, 5, 9, 13 ], [ 2, 5, 7, 10 ], 
[ 4, 8, 9, 12 ], [ 3, 7, 8, 11 ], [ 10, 11, 12, 13 ] ]);;
DrawSurfaceToTikz(cube, "Cube_example");;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Cube_example-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Cube_example.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! <List>
#!   <Item><E>vertexColours</E>: Modifies the colours of the vertices. The 
#!     colours
#!     are given in a list <A>colours</A> such that <A>colours[v]</A> is the
#!     colour of the vertex <A>v</A>. If vertex <A>v</A> is not in the surface, 
#!     the colour is skipped. The colours are strings that are 
#!     recognizable by &LaTeX;.
#!
#!     It is possible to leave some vertex colours unbound - those will be coloured with the
#!     default vertex colour (orange).
#! @BeginLog
pr := rec( vertexColours :=
   ["red", "blue", "green",, "pink", "black!20!yellow"] );;
DrawSurfaceToTikz(cube, "Cube_vertexColouredLocal", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Cube_vertexColouredLocal-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Cube_vertexColouredLocal.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!   Instead of giving an entire list it is also possible to give just one
#!   string defining a new colour for all vertices. It will be internally
#!   converted into a list.
#! @BeginLog
pr := rec( vertexColours := "blue!60!white" );;
DrawSurfaceToTikz(cube, "Cube_vertexColouredGlobal", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Cube_vertexColouredGlobal-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Cube_vertexColouredGlobal.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!   </Item>
#!
#!   <Item><E>edgeColours</E>: Modifies the colours of the edges. The
#!     colours are given in a list <A>colours</A> such that <A>colours[e]</A>
#!     is the colour of the edge <A>e</A>. If edge <A>e</A> is not in the surface,
#!     the colour is skipped. The colours are strings that are
#!     recognizable by &LaTeX;.
#!
#!     Is is possible to leave some edge colours unbound - those will be coloured with the
#!     default edge colour (gray).
#! @BeginLog
pr := rec( edgeColours :=
   [,,,,"red", "purple", "blue", "green!80!black"] );;
DrawSurfaceToTikz( cube, "Cube_edgeColouredLocal", pr );;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Cube_edgeColouredLocal-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Cube_edgeColouredLocal.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!     Instead of giving an entire list it is also possible to give just one
#!     string defining a new colour for all edges. It will be internally 
#!     converted into a list.
#! @BeginLog
pr := rec( edgeColours := "red" );;
DrawSurfaceToTikz( cube, "Cube_edgeColouredGlobal", pr );;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Cube_edgeColouredGlobal-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Cube_edgeColouredGlobal.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!   </Item>
#!
#!   <Item><E>faceColours</E>: Modifies the colours of the faces. The
#!     colours are given in a list <A>colours</A> such that <A>colours[f]</A>
#!     is the colour of the face <A>f</A>. If face <A>f</A> is not in the surface,
#!     the colour is skipped. It is possible to leave some
#!     face colours unbound - those will be coloured with the default face colour (a darker
#!     shape of yellow, the custom colour <E>\\faceColorY</E>).
#!
#!     The colours can be strings that are recognized by &LaTeX;, but they can
#!     also be one of six pre-defined colours of this package:
#! @BeginLog
pr := rec( faceColours := ["\\faceColorY", "\\faceColorB", 
    "\\faceColorC", "\\faceColorR", "\\faceColorG", "\\faceColorO"] );;
DrawSurfaceToTikz( cube, "Cube_faceColouredLocal", pr );;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Cube_faceColouredLocal-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Cube_faceColouredLocal.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!     Instead of giving an entire list it is also possible to give just one
#!     string defining a new colour for all faces. It will be internally
#!     converted into a list.
#! @BeginLog
pr := rec( faceColours := "olive!20!white" );;
DrawSurfaceToTikz( cube, "Cube_faceColouredGlobal", pr );;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Cube_faceColouredGlobal-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Cube_faceColouredGlobal.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!   </Item>
#! </List>
#! @EndChunk

#! @BeginChunk DrawSurfaceToTikz_Labels
#! This subsection covers the parameters that change the labels of vertices,
#! edges and faces in the drawings of <K>DrawSurfaceToTikz</K>
#! (<Ref Subsect="DrawSurfaceToTikz"/>).
#! * <E>vertexLabelsActive</E>: Turn the vertex labels on or off (by default
#!   they are turned on).
#! * <E>vertexLabels</E>: Modify the vertex labels (by default they are 
#!   labelled by their number).
#! * <E>edgeLabelsActive</E>: Turn the edge labels on or off (by default
#!   they are turned on).
#! * <E>edgeLabels</E>: Modify the edge labels (by default they are 
#!   labelled by their number).
#! * <E>faceLabelsActive</E>: Turn the face labels on or off (by default
#!   they are turned on).
#! * <E>faceLabels</E>: Modify the face labels (by default they are 
#!   labelled by their number).
#! 
#! We will exemplify these parameters on the example of a tetrahedron. Here the tetrahedron has holes in the
#! vertex, edge and face sets to make it more clear how the parameters work:
#! @BeginLog
tetra := SimplicialSurfaceByDownwardIncidence([ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], 
[ 3, 4 ], ,[ 3, 5 ], [ 4, 5 ] ], [ [ 1, 2, 4 ], [ 1, 3, 6 ], ,
[ 4, 6, 7 ], [ 2, 3, 7 ] ]);;
DrawSurfaceToTikz( tetra, "Tetrahedron_example" );;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Tetrahedron_example-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Tetrahedron_example.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! <List>
#!   <Item><E>vertexLabelsActive</E>: By default all vertices are labelled. If they
#!     should not be labelled, this parameter can be set to <K>false</K>.
#! @BeginLog
pr := rec( vertexLabelsActive := false );;
DrawSurfaceToTikz( tetra, "Tetrahedron_vertexLabelsOff", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Tetrahedron_vertexLabelsOff-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Tetrahedron_vertexLabelsOff.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! </Item>
#! <Item><E>vertexLabels</E>: By default the vertices are labelled by their 
#!   number. This can be changed with this parameter (if you just want to
#!   turn off the labels, use <E>vertexLabelsActive</E> instead).
#! 
#!   The labels are given as a list <A>labels</A> such that <A>labels[v]</A>
#!   is the label of the vertex <A>v</A>. If vertex <A>v</A> is not in the surface,
#!   the label is skipped. It is possible to leave some 
#!   vertex labels unbound - those will be labelled with their default label.
#! @BeginLog
pr := rec( vertexLabels := ["V_1", "X", , "++"] );;
DrawSurfaceToTikz( tetra, "Tetrahedron_vertexLabels", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Tetrahedron_vertexLabels-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Tetrahedron_vertexLabels.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!   </Item>
#! 
#!   <Item><E>edgeLabelsActive</E>: By default all edges are labelled. If they
#!     should not be labelled, this parameter can be set to <K>false</K>.
#! @BeginLog
pr := rec( edgeLabelsActive := false );;
DrawSurfaceToTikz( tetra, "Tetrahedron_edgeLabelsOff", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Tetrahedron_edgeLabelsOff-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Tetrahedron_edgeLabelsOff.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! </Item>
#! <Item><E>edgeLabels</E>: By default the edges are labelled by their 
#!   number. This can be changed with this parameter (if you just want to
#!   turn off the labels, use <E>edgeLabelsActive</E> instead).
#! 
#!   The labels are given as a list <A>labels</A> such that <A>labels[e]</A>
#!   is the label of the edge <A>e</A>. If edge <A>e</A> is not in the surface,
#!   the label is skipped. It is possible to leave some 
#!   edge labels unbound - those will be labelled with their default label.
#! @BeginLog
pr := rec( edgeLabels := ["a", , "e_3", , "?"] );;
DrawSurfaceToTikz( tetra, "Tetrahedron_edgeLabels", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Tetrahedron_edgeLabels-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Tetrahedron_edgeLabels.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!   </Item>
#!
#!   <Item><E>faceLabelsActive</E>: By default all faces are labelled. If they
#!     should not be labelled, this parameter can be set to <K>false</K>.
#! @BeginLog
pr := rec( faceLabelsActive := false );;
DrawSurfaceToTikz( tetra, "Tetrahedron_faceLabelsOff", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Tetrahedron_faceLabelsOff-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Tetrahedron_faceLabelsOff.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! </Item>
#! <Item><E>faceLabels</E>: By default the faces are labelled by their 
#!   number. This can be changed with this parameter (if you just want to
#!   turn off the labels, use <E>faceLabelsActive</E> instead).
#! 
#!   The labels are given as a list <A>labels</A> such that <A>labels[f]</A>
#!   is the label of the face <A>f</A>. If face <A>f</A> is not in the surface,
#!   the label is skipped. It is possible to leave some 
#!   face labels unbound - those will be labelled with their default label.
#! @BeginLog
pr := rec( faceLabels := ["I", "f_2", "42", ,] );;
DrawSurfaceToTikz( tetra, "Tetrahedron_faceLabels", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Tetrahedron_faceLabels-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Tetrahedron_faceLabels.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!   </Item>
#! </List>
#! @EndChunk

#! @BeginChunk DrawSurfaceToTikz_LengthsAndAngles
#! This subsection explains the parameters that modify the size and shapes 
#! of the
#! faces that are drawn by the method <K>DrawSurfaceToTikz</K>
#! (<Ref Subsect="DrawSurfaceToTikz"/>). More specifically it explains the
#! following parameters:
#! * <E>scale</E>: Globally scales the picture. The default is 2.
#! * <E>edgeLengths</E>: Is a list <A>lengths</A> such that
#!   <A>lengths[e]</A> is the length of the edge <A>e</A>. By default, each
#!   edge has length 1.
#! * <E>angles</E>: This parameter controls the inner angles of the faces.
#!   The angles are stored as a list <A>angles</A> such that
#!   <A>angles[f][v]</A> represents the angle in face <A>f</A> at vertex
#!   <A>v</A>. The angle is represented as a list <A>[sin,cos]</A> with
#!   the sine and cosine of the angle.
#! * <E>floatAccuracy</E>: Internal parameter to decide when two floats are
#!   regarded as equal. The default is 0.001. Usually it should not be 
#!   necessary to modify this value.
#!
#! By default, all faces are drawn as regular polygons. To choose different
#! polygons their edge lengths and inner angles have to be defined (exception:
#! for triangles it is sufficient to define the edge lengths, as long as the
#! angles are not set).
#!
#! If the given information is inconsistent an error is thrown.
#!
#! We will exemplify the first two parameters on the example of a tetrahedron. Here the tetrahedron has holes in the
#! vertex, edge and face sets to make it more clear how the parameters work:
#! @BeginLog
tetra := SimplicialSurfaceByDownwardIncidence([ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ],
[ 3, 4 ], ,[ 3, 5 ], [ 4, 5 ] ], [ [ 1, 2, 4 ], [ 1, 3, 6 ], ,
[ 4, 6, 7 ], [ 2, 3, 7 ] ]);;
DrawSurfaceToTikz( tetra, "Tetrahedron_example" );;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Tetrahedron_example-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Tetrahedron_example.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! <List>
#!   <Item><E>scale</E>: By default the scale is 2. This can be changed with this parameter.
#! @BeginLog
pr := rec( scale := 1.5 );;
DrawSurfaceToTikz( tetra, "Tetrahedron_rescaled", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Tetrahedron_rescaled-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Tetrahedron_rescaled.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! </Item>
#! <Item><E>edgeLengths</E>: By default each edge has length 1. This can be changed with this parameter. 
#!
#!   The lengths are given as a list <A>edgeLengths</A> such that <A>edgeLengths[e]</A>
#!   is the length of the edge <A>e</A>. If edge <A>e</A> is not in the surface,
#!   the length is skipped. It is possible to leave some
#!   edge lengths unbound - those will have length 1.
#! @BeginLog
pr := rec( edgeLengths := [1.5, 1.5, 1, 1.5, 2, 1, 1] );;
DrawSurfaceToTikz( tetra, "Tetrahedron_edgeLengths", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Tetrahedron_edgeLengths-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Tetrahedron_edgeLengths.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! </Item>
#! <Item><E>angles</E>: The angles can be changed with this parameter.
#!
#!   The angles are given as a list <A>angles</A> such that <A>angles[f][v]</A>
#!   is the inner angle of vertex <A>v</A> in face <A>f</A>. The angle is represented as a 
#!   list <A>[sin,cos]</A> with the sine and cosine of the angle.
#!   In the case of a triangle, it is not possible to change the angles without 
#!   specifying the edge lengths, as the angles do not describe a unique triangle.
#!
#! We will exemplify this parameter on the example of a rectangle example. 
#! In the case of a rectangle, changing the angles does not change the edge lengths.
#! @BeginLog
rectangle:=PolygonalSurfaceByVerticesInFaces([[1,2,3,4]]);;
pr:=DrawSurfaceToTikz( rectangle, "Rectangle_example" );;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Rectangle_example-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Rectangle_example.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginLog
pr.angles:=[[[ 0.866025, 0.5 ],[ 0.866025, -0.5 ],[ 0.866025, 0.5 ],
[ 0.866025, -0.5 ]]];;
DrawSurfaceToTikz( rectangle, "Rectangle_angles", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Rectangle_angles-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Rectangle_angles.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! </Item>
#! </List>
#! @EndChunk

#! @BeginChunk DrawSurfaceToTikz_DrawOrder
#! This subsection is concerned with the parameters that control the draw
#! order of the drawings from <K>DrawSurfaceToTikz</K> 
#! (<Ref Subsect="DrawSurfaceToTikz"/>). The drawing order is decided by the
#! following parameters:
#! * <E>avoidIntersections</E>: If this parameter is <K>true</K> (the default) 
#!   intersections in the drawing are avoided if possible. If there is a 
#!   conflict between a given drawing order and the intersection avoidance,
#!   the avoidance will prevail!
#! * <E>startingFaces</E>: After drawing this list contains one face from
#!   each strongly connected component. These are the first faces that were
#!   drawn from these components. That means that the vertex coordinates of 
#!   these faces are the first to be calculated. By giving this list manually the first
#!   drawn faces can be customized. The function will auto-correct the 
#!   spelling <E>startingFace</E> into <E>startingFaces</E> if there is
#!   no entry for <E>startingFaces</E>.
#! * <E>edgeDrawOrder</E>: After drawing this list contains a list of edges
#!   for each strongly connected component. For each component, this list
#!   explains the order in which these edges were completed (an edge is 
#!   completed if both adjacent faces are drawn). This means that this parameter 
#!   controls which edges are drawn once and which edges need to be drawn twice because 
#!   they cannot be completed. This can be customized and
#!   <K>DrawSurfaceToTikz</K> will try to follow it as closely as possible
#!   while avoiding intersections (if <E>avoidIntersections</E> is set).
#! 
#! We will exemplify these parameters on different examples.
#! <List>
#! <Item><E>startingFaces</E>: After drawing, this list contains the first faces that were drawn from
#!   each strongly connected component. These can be changed with this parameter.
#!
#! For example, consider the butterfly with two strongly connected components.
#! @BeginLog
butterfly := TriangularComplexByVerticesInFaces( 7, 4, [ [1,2,3], 
[1,6,7], [1,3,4], [1,5,6] ]);;
pr := DrawSurfaceToTikz(butterfly,"Butterfly");;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Butterfly-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Butterfly.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! Changing the faces results in a different picture:
#! @BeginLog
pr := rec( startingFaces := [3,4] );;
DrawSurfaceToTikz( butterfly, "Butterfly_startingFaces", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_Butterfly_startingFaces-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_Butterfly_startingFaces.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! </Item>
#! <Item><E>edgeDrawOrder</E>: After drawing this list contains a list of edges for each 
#! strongly connected component. For each component, this list explains the order in which 
#! these edges were completed (an edge is completed if both adjacent faces are drawn).
#! This order can be changed with this parameter.
#!
#! For example, consider this simplicial surface:
#! @BeginLog 
doubleSixGon:=SimplicialSurfaceByUmbrellaDescriptor([(1,2,3,4,5,6),
(7,8,9,10,11,12),(1,2,8,7),(2,3,9,8),(3,4,10,9),(4,5,11,10),(5,6,12,11),
(6,1,7,12)]);;
pr:=DrawSurfaceToTikz(doubleSixGon,"DoubleSixGon");;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_DoubleSixGon-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_DoubleSixGon.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! Changing the edge draw order results in a different picture:
#! @BeginLog
pr!.edgeDrawOrder:=[[1,2,10,8,6,4,7,15,13,14,18,17,16]];;
DrawSurfaceToTikz(doubleSixGon,"DoubleSixGon_edgeDraw",pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_DoubleSixGon_edgeDraw-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_DoubleSixGon_edgeDraw.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! </Item>
#! </List>
#!
#! @EndChunk

#! @BeginChunk DrawSurfaceToTikz_Output
#! This subsection contains miscellaneous parameters to control the output
#! of <K>DrawSurfaceToTikz</K> (<Ref Subsect="DrawSurfaceToTikz"/>). It 
#! contains the following options:
#! * <E>compileLaTeX</E>: If this parameter is <K>true</K> (the default is
#!   <K>false</K>) the generated tex-file will be automatically compiled
#!   with <K>pdflatex</K>. In rare cases the compilation might run into
#!   a problem and stop. To abort such a computation, type 'x' and hit
#!   ENTER (this command is passed to <K>pdflatex</K>). If this happens,
#!   please notify the developers so it can be fixed in a later version.
#! * <E>latexDocumentclass</E>: Defines which documentclass is used for
#!   the output. The default is <K>article</K>. If the picture should
#!   not be cropped (and not be printed), <K>standalone</K> is recommended.
#! * <E>noOutput</E>: If this parameter is <K>true</K> (the default is
#!   <K>false</K>) the method <K>DrawSurfaceToTikz</K> will produce no
#!   output on the console.
#! * <E>onlyTikzpicture</E>: If this parameter is <K>true</K> (the default
#!   is <K>false</K>) the generated tex-file will only consist of a 
#!   <K>tikzpicture</K> without header (it is not possible to compile it on
#!   its own).
#! @EndChunk

#! @BeginChunk DrawSurfaceToTikz_Data
#! This subsection contains miscellaneous parameters which cannot be influenced by the 
#! user and contain information to recreate the drawing of <K>DrawSurfaceToTikz</K> (<Ref Subsect="DrawSurfaceToTikz"/>). 
#! These parameters are: <E>vertexCoordinates</E>, <E>edgeEndPoint</E> and <E>faceVertices</E>.
#!
#! For each vertex <A>v</A> and each edge <A>e</A> the components that contain <A>v</A> respectively <A>e</A>
#! are sorted in the order in which <A>v</A> respectively <A>e</A> were drawn.
#! The variable <A>index</A> will play an essential role in describing the parameters.
#! <A>index(v)</A> specifies the index of the component in the order 
#! described above in which the drawn node is located (analogously for <A>e</A>).
#! Consider the parameters in detail:
#!  * <E>vertexCoordinates</E>: After drawing this list contains a list for each vertex.
#!    For each vertex the list stores the coordinates each time the vertex is drawn. 
#!    The coordinates are represented as a list <A>[x,y, index]</A>.
#!  * <E>edgeEndPoint</E>: After drawing this list contains a list for each edge <A>e</A>. 
#!    For each edge the list stores the end vertices of <A>e</A> for each drawn time.
#!    Each entry is represented as <A>[v1,v2,index(e)]</A>, with the vertices <A>v1</A> and <A>v2</A> 
#!    are represented as a list <A>[vi, index(vi)]</A>.
#!  * <E>faceVertices</E>: After drawing this list contains a list for each face. 
#!    For each face the list contains in each entry a list of triples, with each entry in the list describing a vertex. 
#!    The vertices are represented as <A>[v, index(v)]</A>.
#! @EndChunk


#TODO modify boundaries of page (to center picture for printing)
#TODO for triangles, the length information should overwrite the angle information
#TODO for >triangles can we define a notion of "this was probably meant" by minimum distance or so?


#! @BeginChunk DrawFacegraphToTikz_Tutorial
#! The face graph of a simplicial surface is a graph whereby the vertices of
#! the graph are given by the faces and the edges of the graph are given by
#! the edges of the given simplicial surface. For more specific access to the
#! face graph of a simplicial surface, compare 
#! (<Ref Subsect="FaceGraph"/>). We can compute a straight-line
#! embedding of the face graph by assigning 2D-coordinates to the faces.
#! Note, <K>DrawFacegraphToTikz</K> (<Ref Subsect="DrawFacegraphToTikz"/>) 
#! only computes face graphs of spherical vertex faithful surfaces.
#!  
#! For example the face graph of an octahedron can be drawn like this:
#! @BeginLog
oct := Octahedron();;
DrawFacegraphToTikz( oct, "facephgraph_oct_example" );;
#! @EndLog
#!
#! This will write a file <E>facegraph_oct_example.tex</E> that contains the
#! face graph of the octahedron, written in <K>TikZ</K>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_facegraph_oct_Rescaled-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_facegraph_oct_Rescaled.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!
#! To customize this drawing, a record is used (called the <A>printRecord</A>).
#! Each call of the drawing method creates one of those:
#! @BeginLog
pr := DrawFacegraphToTikz( oct, "facegraph_oct" );;
#! @EndLog
#!
#! If the edges should be labelled, they can be turned on as follows:
#! @BeginLog
pr.edgeLabelsActive := true;;
#! @EndLog
#!
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_facegraph_oct_edgelabels-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_facegraph_oct_edgelabels.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!
#! The labels of the vertices can be turned on with 
#! @BeginLog
pr.vertexLabelsActive := true;;
#! @EndLog
#!
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_facegraph_oct_vertexLabels-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_facegraph_oct_vertexLabels.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!
#! The colours of the edges and vertices can also be changed very easily 
#! (especially if all colours should be changed at once). For example,
#! let's make all edges green:
#! @BeginLog
pr.edgeColours := "green";;
#! @EndLog

#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_facegraph_oct_greenEdges-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_facegraph_oct_greenEdges.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!
#! We can even compute an embedding of the face graph with the corresponding 
#! geodesics of the simplicial surface.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_facegraph_octGeodesics-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_facegraph_octGeodesics.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!
#! If we are not happy with the position of a face node, we can change it  
#! by adjusting the 2D-coordinate of the face.
#!
#! @BeginLog
pr.faceCoordinates2D[1]:=[-2.,4.];;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;img src="./images/_Wrapper_Image_facegraph_oct2-1.svg"> &lt;/img>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_Image_facegraph_oct2.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!
#! It is even possible to compute an embedding of the face graph of a given
#! simplicial surface by manipulating all face coordinates. For example we
#! can compute an embedding so that it is clear to see that the face graph
#! of the octahedron is bipartite.
#!
#! @BeginLog
pr.faceCoordinates2D[1]:=[0.,0.];;pr.faceCoordinates2D[4]:=[4.,0.];;
pr.faceCoordinates2D[3]:=[4.,1.];;pr.faceCoordinates2D[7]:=[4.,2.];;
pr.faceCoordinates2D[2]:=[0.,1.];;pr.faceCoordinates2D[6]:=[0.,2.];;
pr.faceCoordinates2D[5]:=[0.,3.];;pr.faceCoordinates2D[8]:=[4.,3.];;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;img src="./images/_Wrapper_Image_facegraph_oct3-1.svg"> &lt;/img>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_Image_facegraph_oct3.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>

#! @EndChunk



#! @BeginChunk DrawFacegraphToTikz_Colours
#! This subsection covers how to change the colours of edges and faces  
#! represented as vertices in the drawings 
#! from <K>DrawFacegraphToTikz</K> (<Ref Subsect="DrawFacegraphToTikz"/>).
#! It covers the following parameters:
#! * <E>faceColours</E>: Modify the colours of the vertices representing 
#!   the faces (the default colour is gray).
#! * <E>edgeColours</E>: Modify the colours of the edges (the default
#!   colour is gray).
#!
#! We will exemplify them with the tetrahedron to make clear how the parameters 
#! work:
#! @BeginLog
tetra :=SimplicialSurfaceByVerticesInFaces([[1,2,3],[1,2,4],
[1,3,4],[2,3,4]]);;
DrawFacegraphToTikz(tetra, "facegraph_tetrahedron");;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_facegraph_tetrahedron-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_facegraph_tetrahedron.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! <List>
#!   <Item><E>faceColours</E>: Modifies the colours of the vertices representing 
#!     the faces. The colours are given in a list <A>colours</A> such that 
#!     <A>colours[f]</A> is the colour of the vertex representing face <A>f</A>. If
#!     face <A>f</A> is not in the surface, the colour is skipped. The colours are 
#!     strings that are recognizable by &LaTeX;.
#!
#!     It is possible to leave some face colours unbound - those will be coloured
#!     with the default face colour (gray).
#! @BeginLog
pr := rec( faceColours :=
   ["blue", "green",, "black!20!yellow"] );;
DrawFacegraphToTikz(tetra, 
"facegraph_tetrahedron_vertexColouredLocal", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_facegraph_tetrahedron_vertexColouredLocal-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_facegraph_tetrahedron_vertexColouredLocal.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!   Instead of giving an entire list it is also possible to give just one
#!   string defining a new colour for all vertices. It will be internally
#!   converted into a list.
#! @BeginLog
pr := rec( vertexColours := "blue!60!white" );;
DrawFacegraphToTikz(tetra, 
"facegraph_tetrahedron_vertexColouredGlobal.tex",pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_facegraph_tetrahedron_vertexColouredGlobal-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_facegraph_tetrahedron_vertexColouredGlobal.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!   </Item>
#!
#!   <Item><E>edgeColours</E>: Modifies the colours of the edges. The
#!     colours are given in a list <A>colours</A> such that <A>colours[e]</A>
#!     is the colour of the edge <A>e</A>. If edge <A>e</A> is not in the surface,
#!     the colour is skipped. The colours are strings that are
#!     recognizable by &LaTeX;.
#!
#!     Is is possible to leave some edge colours unbound - those will be coloured 
#!     with the default edge colour (gray).
#! @BeginLog
pr := rec( edgeColours :=
   [,,"red","purple","blue","green!80!black"] );;
DrawFacegraphToTikz(tetra,
"facegraph_tetrahedron_edgeColouredLocal.tex", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_facegraph_tetrahedron_edgeColouredLocal-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_facegraph_tetrahedron_edgeColouredLocal.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!     Instead of giving an entire list it is also possible to give just one
#!     string defining a new colour for all edges. It will be internally 
#!     converted into a list.
#! @BeginLog
pr := rec( edgeColours := "red" );;
DrawFacegraphToTikz( tetra, 
"facegraph_tetrahedron_edgeColouredGlobal.tex", pr );;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_facegraph_tetrahedron_edgeColouredGlobal-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_facegraph_tetrahedron_edgeColouredGlobal.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!   </Item>
#! </List>
#! @EndChunk


#! @BeginChunk DrawFacegraphToTikz_Labels
#! This subsection covers the parameters that change the labels of vertices,
#! edges and faces in the drawings of <K>DrawFacegraphToTikz</K>
#! (<Ref Subsect="DrawFacegraphToTikz"/>).
#! * <E>vertexLabelsActive</E>: Turn the vertex labels on or off (by default
#!   they are turned off).
#! * <E>vertexLabels</E>: Modify the vertex labels (by default they are 
#!   labelled by their number).
#! * <E>edgeLabelsActive</E>: Turn the edge labels on or off (by default
#!   they are turned off).
#! * <E>edgeLabels</E>: Modify the edge labels (by default they are 
#!   labelled by their number).
#! * <E>faceLabelsActive</E>: Turn the face labels on or off (by default
#!   they are turned on).
#! * <E>faceLabels</E>: Modify the face labels (by default they are 
#!   labelled by their number).
#! 
#! We will exemplify these parameters on the example of a double-6-gon to 
#! make clear how the parameters work:
#! @BeginLog
double6Gon := SimplicialSurfaceByVerticesInFaces([[1,2,3],[1,3,4],[1,4,5],
[1,5,6],[1,6,7],[1,2,7],[2,3,8],[3,4,8],[4,5,8],[5,6,8],[6,7,8],[2,7,8]]);;
#! @EndLog
#!
#!  <Alt Only="HTML">
#! &lt;img src="./images/_Wrapper_Image_Double6gon-1.svg"> &lt;/img>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_Image_Double6gon.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginLog
DrawFacegraphToTikz( double6Gon, "facegraph_Double6Gon.tex" );;
#! @EndLog
#! 
#!  <Alt Only="HTML">
#! &lt;img src="./images/_Wrapper_Image_facegraph_Double6Gon-1.svg"> &lt;/img>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_Image_facegraph_Double6Gon.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! <List>
#!   <Item><E>vertexLabelsActive</E>: By default all vertices are not labelled. If they
#!     should be labelled, this parameter can be set to <K>true</K>. Note,
#!     the vertices of the simplicial surface can be identified by the faces of 
#!     the facegraph.
#! @BeginLog
pr := rec( vertexLabelsActive := true);;
DrawFacegraphToTikz( double6Gon,"facegraph_Double6Gon_VertexLabelsOn" , pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;img src="./images/_Wrapper_TIKZ_facegraph_Double6Gon_VertexLabelsOn-1.svg"> &lt;/img>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_facegraph_Double6Gon_VertexLabelsOn.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! </Item>
#! <Item><E>vertexLabels</E>: By default the vertices are labelled by their 
#!   number. This can be changed with this parameter (if you just want to
#!   turn off the labels, use <E>vertexLabelsActive</E> instead).
#! 
#!   The labels are given as a list <A>labels</A> such that <A>labels[v]</A>
#!   is the label of the vertex <A>v</A>. If vertex <A>v</A> is not in the surface,
#!   the label is skipped. It is possible to leave some 
#!   vertex labels unbound - those will be labelled with their default label.
#! @BeginLog
pr := rec( vertexLabels := ["V_1", "X", , "++"] );;
DrawFacegraphToTikz( double6Gon, "facegraph_Double6Gon_vertexLabels", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;img src="./images/_Wrapper_TIKZ_facegraph_Double6Gon_vertexLabels-1.svg"> &lt;/img>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_facegraph_Double6Gon_vertexLabels.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!   </Item>
#! 
#!   <Item><E>edgeLabelsActive</E>: By default all edges are not labelled. If they
#!     should be labelled, this parameter can be set to <K>true</K>.
#! @BeginLog
pr := rec( edgeLabelsActive := true  );;
DrawFacegraphToTikz( double6Gon, "facegraph_Double6Gon_EdgeLabelsOn", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;img src="./images/_Wrapper_TIKZ_facegraph_Double6Gon_EdgeLabelsOn-1.svg"> &lt;/img>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_facegraph_Double6Gon_EdgeLabelsOn.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! </Item>
#! <Item><E>edgeLabels</E>: By default the edges are labelled by their 
#!   number. This can be changed with this parameter (if you just want to
#!   turn off the labels, use <E>edgeLabelsActive</E> instead).
#! 
#!   The labels are given as a list <A>labels</A> such that <A>labels[e]</A>
#!   is the label of the edge <A>e</A>. If edge <A>e</A> is not in the surface,
#!   the label is skipped. It is possible to leave some 
#!   edge labels unbound - those will be labelled with their default label.
#! @BeginLog
pr := rec( edgeLabels := ["a", , "e_3", , "?"] );;
DrawFacegraphToTikz( double6Gon, "facegraph_Double6Gon_EdgeLabels", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;img src="./images/_Wrapper_TIKZ_facegraph_Double6Gon_EdgeLabels-1.svg"> &lt;/img>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_facegraph_Double6Gon_EdgeLabels.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!   </Item>
#!
#!   <Item><E>faceLabelsActive</E>: By default all faces are labelled. If they
#!     should not be labelled, this parameter can be set to <K>false</K>.
#! @BeginLog
pr := rec( faceLabelsActive := false );;
DrawFacegraphToTikz( double6Gon, "facegraph_Double6Gon_FaceLabelsOff", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;img src="./images/_Wrapper_Image_facegraph_Double6Gon_FaceLabelsOff-1.svg"> &lt;/img>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_Image_facegraph_Double6Gon_FaceLabelsOff.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! </Item>
#! <Item><E>faceLabels</E>: By default the faces are labelled by their 
#!   number. This can be changed with this parameter (if you just want to
#!   turn off the labels, use <E>faceLabelsActive</E> instead).
#! 
#!   The labels are given as a list <A>labels</A> such that <A>labels[f]</A>
#!   is the label of the face <A>f</A>. If face <A>f</A> is not in the surface,
#!   the label is skipped. It is possible to leave some 
#!   face labels unbound - those will be labelled with their default label.
#! @BeginLog
pr := rec( faceLabels := ["I", "f_2", "42", ,] );;
DrawFacegraphToTikz( double6Gon, "facegraph_Double6Gon_FaceLabels", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;img src="./images/_Wrapper_TIKZ_facegraph_Double6Gon_FaceLabels-1.svg"> &lt;/img>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_TIKZ_facegraph_Double6Gon_FaceLabels.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!   </Item>
#! </List>
#! @EndChunk


#! @BeginChunk DrawFacegraphToTikz_Scaling
#! This subsection explains the parameters that modify the size of the drawings
#! produced by the method <K>DrawFacegraphToTikz</K>
#! (<Ref Subsect="DrawFacegraphToTikz"/>). More specifically it explains the
#! following parameters:
#! * <E>scale</E>: Globally scales the picture. The default is 2.
#! * <E>floatAccuracy</E>: Internal parameter to decide when two floats are
#!   regarded as equal. The default is 0.001. Usually it should not be 
#!   necessary to modify this value.
#!
#! We will exemplify the parameter <E>scale</E> on the octahedron to make it more clear how the parameters works:
#! @BeginLog
oct:=Octahedron();;
DrawFacegraphToTikz( oct, "facegraph_oct" );;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_facegraph_oct-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_facegraph_oct.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! <List>
#!   <Item><E>scale</E>: By default the scale is 2. This can be changed with this parameter.
#! @BeginLog
pr := rec( scale := 1.5 );;
DrawFacegraphToTikz( tetra, "facegraph_oct_rescaled", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_facegraph_oct_Rescaled-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_facegraph_oct_Rescaled.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! </Item>
#! </List>
#! @EndChunk

 
#! @BeginChunk DrawFacegraphToTikz_FaceCoordinates
#! This subsection covers how to change the position of the faces in the drawing
#! computed by <K>DrawFacegraphToTikz</K> 
#! (<Ref Subsect="DrawFacegraphToTikz"/>). It covers the following parameters:
#! * <E>faceCoordinates2D</E>: Modify the coordinates of the faces which are
#!   represented as vertices in the embedding.
#!
#! We will exemplify them with the tetrahedron to make clear how the parameters 
#! work:
#!
#! @BeginLog
tetra :=SimplicialSurfaceByVerticesInFaces([[1,2,3],[1,2,4],
[1,3,4],[2,3,4]]);;
DrawFacegraphToTikz(tetra, "facegraph_tetrahedron");;
#! @EndLog
#!
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_facegraph_tetrahedron-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_facegraph_tetrahedron.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! <List>
#!   <Item><E>faceCoordinates2D</E>: Modifies the position of the vertices
#!     representing the faces. The coordinates are given in a list
#!     <A>faceCoordinates2D</A> such that <A>faceCoordinates2D[f]</A> is the
#!     2D-coordinate of the vertex representing face <A>f</A>. The list of
#!     bounded positions in <E>faceCoordinates2D</E> has to be equal to the
#!     set of faces of the given surface, otherwise the function returns
#!     an error.
#!
#! @BeginLog
pr := rec( faceCoordinates2D:=[[0.,0.],[4.,0.],[4.,4.],[0.,4.]]);;
DrawFacegraphToTikz(tetra, 
"facegraph_tetrahedron_Coordinates", pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_TIKZ_facegraph_tetrahedron_Coordinates-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_TIKZ_facegraph_tetrahedron_Coordinates.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!
#!   </Item>
#! </List>
#! @EndChunk


#! @BeginChunk DrawFacegraphToTikz_Geodesics
#! This subsection covers the  usage of the parameter that adds geodesics into 
#! the drawings of <K>DrawFacegraphToTikz</K>
#! (<Ref Subsect="DrawFacegraphToTikz"/>). This parameter is designed for 
#! simplicial surfaces whose face graphs are embedded with the help of the 
#! coordinates computed in the implementations. 
#!
#! It covers the following parameters:
#! * <E>geodesicsActice</E>: Turn the drawing of the geodesics on or off (by default
#!   they are turned off). A geodesic of a simplicial surface can be defined as a 
#!   face-edge-path. This information can be used to draw the geodesic as polygon 
#!   so that edges of the polygon and edges of the embedding of the face graph intersect
#!   if and only if the corresponding edge of the simplicial surface lies on the 
#!   defining face-edge-path. 
#! 
#! We will exemplify these parameter on the example of a octahedron
#! to make it more clear how the parameters work:
#! @BeginLog
oct:=Octahedron();
DrawFacegraphToTikz( oct, "facegraph_Octahedron.tex" );;
#! @EndLog
#! 
#!  <Alt Only="HTML">
#! &lt;img src="./images/_Wrapper_Image_facegraph_oct_Rescaled-1.svg"> &lt;/img>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \includegraphics{images/_Wrapper_Image_facegraph_oct_Rescaled.pdf}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! <List>
#!   <Item><E>geodesicsActive</E>: By default the geodics are not painted into
#!   the .tex file. If they should be shown, this parameter can be set to
#!   <K>true</K>. Note the octahedron has four geodesics which are all
#!   represented in the drawing by polygons coloured in red, green, 
#!   blue and yellow.
#! @BeginLog
pr := rec( geodesicActive := true);;
DrawFacegraphToTikz( oct,
"facegraph_octGeodesics.tex" , pr);;
#! @EndLog
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_facegraph_octGeodesics-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_facegraph_octGeodesics.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! </Item>
#! </List>
#! @EndChunk

#! @BeginChunk DrawFacegraphToTikz_Output
#! This subsection contains miscellaneous parameters to control the output
#! of <K>DrawFacegraphToTikz</K> (<Ref Subsect="DrawFacegraphToTikz"/>). It 
#! contains the following options:
#! * <E>compileLaTeX</E>: If this parameter is <K>true</K> (the default is
#!   <K>false</K>) the generated tex-file will be automatically compiled
#!   with <K>pdflatex</K>. In rare cases the compilation might run into
#!   a problem and stop. To abort such a computation, type 'x' and hit
#!   ENTER (this command is passed to <K>pdflatex</K>). If this happens,
#!   please notify the developers so it can be fixed in a later version.
#! * <E>latexDocumentclass</E>: Defines which documentclass is used for
#!   the output. The default is <K>article</K>. If the picture should
#!   not be cropped (and not be printed), <K>standalone</K> is recommended.
#! * <E>noOutput</E>: If this parameter is <K>true</K> (the default is
#!   <K>false</K>) the method <K>DrawSurfaceToTikz</K> will produce no
#!   output on the console.
#! * <E>onlyTikzpicture</E>: If this parameter is <K>true</K> (the default
#!   is <K>false</K>) the generated tex-file will only consist of a 
#!   <K>tikzpicture</K> without header (it is not possible to compile it on
#!   its own).
#! @EndChunk


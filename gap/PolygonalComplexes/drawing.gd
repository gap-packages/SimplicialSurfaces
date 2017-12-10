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
## WARNING: This package should NOT be read if the package is loaded.
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
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Octahedron_example.tex}
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
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Octahedron_recoloured.tex}
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
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Octahedron_customized.tex}
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
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Octahedron_edgeLabels.tex}
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
#! <Alt Only="TikZ">
#!    \input{_TIKZ_Octahedron_reshaped.tex}
#! </Alt>
#! 
#! We can see that the programm chose to display a different net to avoid
#! self-intersections. This feature can be turned off by setting the
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
#! We will exemplify them with the example of a cube:
#! @BeginLog
cube := Cube();;
DrawSurfaceToTikz(cube, "Cube_example");;
#! @EndLog
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Cube_example.tex}
#! </Alt>
#! <List>
#!   <Item><E>vertexColours</E>: Modifies the colours of the vertices. The 
#!     colours
#!     are given in a list <A>colours</A> such that <A>colours[v]</A> is the
#!     colour of the vertex <A>v</A>. The colours are strings that are 
#!     recognizable by &LaTeX;.
#!
#!     It is possible to skip some vertices - those will be coloured with the
#!     default vertex colour (orange).
#! @BeginLog
pr := rec( vertexColours := ["red", "blue", "green",, "black!20!yellow"] );;
DrawSurfaceToTikz(cube, "Cube_vertexColouredLocal", pr);;
#! @EndLog
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Cube_vertexColouredLocal.tex}
#! </Alt>
#!   Instead of giving a whole list it is also possible to give just one
#!   string defining a new colour for all vertices. It will be internally
#!   converted into a list.
#! @BeginLog
pr := rec( vertexColours := "blue!60!white" );;
DrawSurfaceToTikz(cube, "Cube_vertexColouredGlobal", pr);;
#! @EndLog
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Cube_vertexColouredGlobal.tex}
#! </Alt>
#!   </Item>
#!
#!   <Item><E>edgeColours</E>: Modifies the colours of the edges. The
#!     colours are given in a list <A>colours</A> such that <A>colours[e]</A>
#!     is the colour of the edge <A>e</A>. The colours are strings that are
#!     recognizable by &LaTeX;.
#!
#!     Is is possible to skip some edges - those will be coloured with the
#!     default edge colour (gray).
#! @BeginLog
pr := rec( edgeColours := [,,,,"red", "blue", "purple", "green!80!black"] );;
DrawSurfaceToTikz( cube, "Cube_edgeColouredLocal", pr );;
#! @EndLog
#! <Alt Only="TikZ">
#!    \input{_TIKZ_Cube_edgeColouredLocal.tex}
#! </Alt>
#!     Instead of giving a whole list it is also possible to give just one
#!     string defining a new colour for all edges. It will be internally 
#!     converted into a list.
#! @BeginLog
pr := rec( edgeColours := "red" );;
DrawSurfaceToTikz( cube, "Cube_edgeColouredGlobal", pr );;
#! @EndLog
#! <Alt Only="TikZ">
#!    \input{_TIKZ_Cube_edgeColouredGlobal.tex}
#! </Alt>
#!   </Item>
#!
#!   <Item><E>faceColours</E>: Modifies the colours of the faces. The
#!     colours are given in a list <A>colours</A> such that <A>colours[f]</A>
#!     is the colour of the face <A>f</A>. It is possible to skip some
#!     faces - those will be coloured with the default face colour (a darker
#!     shape of yellow, the custom colour <E>\\faceColorY</E>).
#!
#!     The colours can be strings that are recognized by &LaTeX;, but they can
#!     also be one of six pre-defined colours of this package:
#! @BeginLog
pr := rec( faceColours := ["\\faceColorY", "\\faceColorB", 
    "\\faceColorC", "\\faceColorR", "\\faceColorG", "\\faceColorO"] );;
DrawSurfaceToTikz( cube, "Cube_faceColouredLocal", pr );;
#! @EndLog
#! <Alt Only="TikZ">
#!    \input{_TIKZ_Cube_faceColouredLocal.tex}
#! </Alt>
#!     Instead of giving a whole list it is also possible to give just one
#!     string defining a new colour for all faces. It will be internally
#!     converted into a list.
#! @BeginLog
pr := rec( faceColours := "olive!20!white" );;
DrawSurfaceToTikz( cube, "Cube_faceColouredGlobal", pr );;
#! @EndLog
#! <Alt Only="TikZ">
#!    \input{_TIKZ_Cube_faceColouredGlobal.tex}
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
#! We will exemplify these parameters on the example of a tetrahedron:
#! @BeginLog
tetra := Tetrahedron();;
DrawSurfaceToTikz( tetra, "Tetrahedron_example" );;
#! @EndLog
#! <Alt Only="TikZ">
#!    \input{_TIKZ_Tetrahedron_example.tex}
#! </Alt>
#! <List>
#!   <Item><E>vertexLabelsActive</E>: By default all vertices are labelled. If they
#!     should not be labelled, this parameter can be set to <K>false</K>.
#! @BeginLog
pr := rec( vertexLabelsActive := false );;
DrawSurfaceToTikz( tetra, "Tetrahedron_vertexLabelsOff", pr);;
#! @EndLog
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Tetrahedron_vertexLabelsOff.tex}
#! </Alt>
#! </Item>
#! <Item><E>vertexLabels</E>: By default the vertices are labelled by their 
#!   number. This can be changed with this parameter (if you just want to
#!   turn off the labels, use <E>vertexLabelsActive</E> instead).
#! 
#!   The labels are given as a list <A>labels</A> such that <A>labels[v]</A>
#!   is the label of the vertex <A>v</A>. It is possible to skip some 
#!   vertices - those will be labelled with their default label.
#! @BeginLog
pr := rec( vertexLabels := ["V_1", , "X", "++"] );;
DrawSurfaceToTikz( tetra, "Tetrahedron_vertexLabels", pr);;
#! @EndLog
#! <Alt Only="TikZ">
#!    \input{_TIKZ_Tetrahedron_vertexLabels.tex}
#! </Alt>
#!   </Item>
#! 
#!   <Item><E>edgeLabelsActive</E>: By default all edges are labelled. If they
#!     should not be labelled, this parameter can be set to <K>false</K>.
#! @BeginLog
pr := rec( edgeLabelsActive := false );;
DrawSurfaceToTikz( tetra, "Tetrahedron_edgeLabelsOff", pr);;
#! @EndLog
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Tetrahedron_edgeLabelsOff.tex}
#! </Alt>
#! </Item>
#! <Item><E>edgeLabels</E>: By default the edges are labelled by their 
#!   number. This can be changed with this parameter (if you just want to
#!   turn off the labels, use <E>edgeLabelsActive</E> instead).
#! 
#!   The labels are given as a list <A>labels</A> such that <A>labels[e]</A>
#!   is the label of the edge <A>e</A>. It is possible to skip some 
#!   edges - those will be labelled with their default label.
#! @BeginLog
pr := rec( edgeLabels := ["a", , "e_3", , "?"] );;
DrawSurfaceToTikz( tetra, "Tetrahedron_edgeLabels", pr);;
#! @EndLog
#! <Alt Only="TikZ">
#!    \input{_TIKZ_Tetrahedron_edgeLabels.tex}
#! </Alt>
#!   </Item>
#!
#!   <Item><E>faceLabelsActive</E>: By default all faces are labelled. If they
#!     should not be labelled, this parameter can be set to <K>false</K>.
#! @BeginLog
pr := rec( faceLabelsActive := false );;
DrawSurfaceToTikz( tetra, "Tetrahedron_faceLabelsOff", pr);;
#! @EndLog
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Tetrahedron_faceLabelsOff.tex}
#! </Alt>
#! </Item>
#! <Item><E>faceLabels</E>: By default the faces are labelled by their 
#!   number. This can be changed with this parameter (if you just want to
#!   turn off the labels, use <E>faceLabelsActive</E> instead).
#! 
#!   The labels are given as a list <A>labels</A> such that <A>labels[f]</A>
#!   is the label of the face <A>f</A>. It is possible to skip some 
#!   faces - those will be labelled with their default label.
#! @BeginLog
pr := rec( faceLabels := ["I", "f_2", , "42"] );;
DrawSurfaceToTikz( tetra, "Tetrahedron_faceLabels", pr);;
#! @EndLog
#! <Alt Only="TikZ">
#!    \input{_TIKZ_Tetrahedron_faceLabels.tex}
#! </Alt>
#!   </Item>
#! </List>
#! @EndChunk

#! @BeginChunk DrawSurfaceToTikz_LengthsAndAngles
#!
#! @EndChunk

#! @BeginChunk DrawSurfaceToTikz_DrawOrder
#!
#! @EndChunk

#! @BeginChunk DrawSurfaceToTikz_Output
#!
#! @EndChunk

#! @BeginChunk DrawSurfaceToTikz_Data
#!
#! @EndChunk

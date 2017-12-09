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

#! @BeginChunk DrawSurfaceToTikz_ColoursAndLabels
#! This subsection covers cosmetic changes that can be made to the drawings
#! from <K>DrawSurfaceToTikz</K> (<Ref Subsect="DrawSurfaceToTikz"/>).
#! We will exemplify them with the example of a cube:
#! @BeginLog
cube := Cube();;
DrawSurfaceToTikz(cube, "Cube_example");;
#! @EndLog
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Cube_example.tex}
#! </Alt>
#! <List>
#! <Item><E>vertexColours</E>: Modifies the colours of the vertices (the default
#!   is <E>orange</E>). The colours
#!   are given in a list <A>colours</A> such that <A>colours[v]</A> is the
#!   colour of the vertex <A>v</A>. The colours are strings that are 
#!   recognizable by &LaTeX;.
#!   It is possible to skip some vertices - those will be coloured with the
#!   default vertex colour.
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
#! </Item>
#! <Item><E>vertexLabelsActive</E>: By default all vertices are labelled. If they
#!   should not be labelled, this parameter can be set to <K>false</K>.
#! @BeginLog
pr := rec( vertexLabelsActive := false );;
DrawSurfaceToTikz( cube, "Cube_vertexLabelsOff", pr);;
#! @EndLog
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Cube_vertexLabelsOff.tex}
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
pr := rec( vertexLabels := ["V_1", , "X", , "++"] );;
DrawSurfaceToTikz( cube, "Cube_vertexLabels", pr);;
#! @EndLog
#! <Alt Only="TikZ">
#!    \input{_TIKZ_Cube_vertexLabels.tex}
#! </Alt>
#! </Item>
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

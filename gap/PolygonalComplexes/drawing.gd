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
DrawSurfaceToTikz( oct, "Octahedron" );;
#! @EndLog
#!
#! This will write a file <E>Octahedron.tex</E> that contains the net of
#! the octahedron, written in <K>TikZ</K>:
#! <Alt Only="TikZ">
#!     \input{_TIKZ_Octahedron.tex}
#! </Alt>
#!
#! To customize this drawing, a record is used (called the <A>printRecord</A>).
#! Each call of the drawing method creates one of those:
#! @BeginLog
pr := DrawSurfaceToTikz( oct, "Octahedron" );;
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


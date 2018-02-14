#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2018
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

#! @BeginChunk Example_FlagComplex
#! For example consider the polygonal complex from the start of section
#! <Ref Sect="Section_Flags_Definition"/>.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!       \input{Image_StarOfStarExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExample
flagComp := FlagComplex(complex);;
DrawSurfaceToTikz(flagComp, "FlagComplex_Labelled", rec(
    vertexLabels := OneFlags(flagComp),
    edgeLabels := TwoFlags(flagComp),
    faceLabels := ThreeFlags(flagComp) ));;
#! @EndExample
#! <Alt Only="TikZ">
#!   \input{_TIKZ_FlagComplex_Labelled.tex}
#! </Alt>
#! Both the original complex and the uncoloured flag complex can be 
#! obtained.
#! @BeginExample
OriginalComplex(flagComp) = complex;
#! true
PolygonalComplex(flagComp);;
#! @EndChunk
#TODO write the View()-result there;

#! @BeginChunk Example_FlagComplex_Construction
#! As an example consider the polygonal complex from  the start of section
#! <Ref Sect="Section_Flags_Definition"/>.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!       \input{Image_StarOfStarExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExample
flagSurf := FlagSurface(complex);;
DrawSurfaceToTikz(flagSurf, "FlagSurface");;
#! @EndExample
#! <Alt Only="TikZ">
#!   \input{_TIKZ_FlagSurface.tex}
#! </Alt>
#! @EndChunk



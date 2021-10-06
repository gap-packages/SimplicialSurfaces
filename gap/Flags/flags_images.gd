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


##
## WARNING: This file should NOT be read if the package is loaded.
## It contains examples for the manual and should only be used then.
##
if not __SIMPLICIAL_MANUAL_MODE then
    Error("The file 'flags_images.gd' should only be read to generate the manual.");
fi;


complex := PolygonalComplexByDownwardIncidence( 
 [ , , , , , [2,5], , [2,3], [3,5], [11,5], , [3,7], [7,11] ], 
 [[6,8,9], , , [9,10,12,13]]);;
#
#! @BeginChunk Example_FlagComplex
#! For example consider the polygonal complex from the start of section
#! <Ref Sect="Section_Flags_Definition"/>.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!       \input{Image_FlagComplexExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExample
flagComp := FlagComplex(complex);;
OriginalComplex(flagComp) = complex;
#! true
PolygonalComplex(flagComp);;
#! @EndExample
#! Both the original complex and the uncoloured flag complex can be 
#! obtained.
#!
#! The drawing function treats flag surfaces in a special way.
#! Compare <Ref Subsect="DrawSurfaceToTikz_FlagComplex"/>
#! for details.
#! @BeginLog
DrawSurfaceToTikz(flagComp, "FlagComplex_Labelled", rec( scale:=5,
    vertexLabels := OneFlags(complex),
    edgeLabels := TwoFlags(complex),
    faceLabels := ThreeFlags(complex),
    startingFaces := 14));;
#! @EndLog
#! <Alt Only="TikZ">
#!   \input{_TIKZ_FlagComplex_Labelled.tex}
#! </Alt>
#! @EndChunk
#TODO write the View()-result there;

#! @BeginChunk Example_FlagComplex_Construction
#! As an example consider the polygonal complex from  the start of section
#! <Ref Sect="Section_Flags_Definition"/>.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!       \input{Image_FlagComplexExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExample
flagSurf := FlagSurface(complex);;
#! @EndExample
DrawSurfaceToTikz(flagSurf, "FlagSurface", 
                rec(scale:=3, startingFaces:=14));;
#! <Alt Only="TikZ">
#!   \input{_TIKZ_FlagSurface.tex}
#! </Alt>
#! @EndChunk



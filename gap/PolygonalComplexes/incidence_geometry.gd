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

#! @Chapter Access to the incidence geometry
#! @ChapterLabel AccessIncidenceGeometry
#!
#! @Section Basic access to the incidence structure
#! @SectionLabel Access_BasicAccess
#!
#! In polygonal complexes (the most general supported incidence structure,
#! compare chapter <Ref Chap="PolygonalStructures"/>) all vertices, edges
#! and faces are labelled by positive integers. We can access the set of
#! all those labels by <K>Vertices</K>, <K>Edges</K> and <K>Faces</K>.


#! @BeginGroup
## TODO check if grape has changed their definition of Vertices
#! @Description
#! Return the set of vertices.
#! @Arguments complex
#! @Returns A set of positive integers
DeclareOperation( "Vertices", [IsPolygonalComplex] );
#! @Arguments complex
DeclareAttribute( "VerticesAttributeOfPolygonalComplex", IsPolygonalComplex );
#! @EndGroup


#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2019
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

#! @Chapter Homomorphisms
#! @ChapterLabel Morphisms
#!
#! This chapter is concerned with morphisms between different polygonal
#! complexes (morphisms between bend polygonal complexes are not implemented
#! so far).
#!
#! A morphism between two polygonal complexes <M>(V_1,E_1,F_1)</M> and
#! <M>(V_2,E_2,F_2)</M> consists of maps <M>V_1 \to V_2</M>, <M>E_1 \to E_2</M>,
#! and <M>F_1 \to F_2</M>, such that incident elements remain incident.
#!
#! TODO: these maps can be represented as lists, or as mappings (in GAP)
#! TODO: example with constructors for the two
#!
#! TODO a lot of introduction

#idea: polygonal morphisms are maps between sets: vertices+edges+faces, where edges
# are shifted by MaxVertex and faces are shifted by MaxVertex+MaxEdge
DeclareCategory("IsGeneralPolygonalMorphism", IsNonSPGeneralMapping);
# TODO maybe add more specific properties, like IsPolygonalMorphism
# TODO are the names good? Or should we be more specific, e.g. IsPolygonalComplexMorphism, IsPolygonalSurfaceMorphism?


BindGlobal( "GeneralPolygonalMorphismFamily", 
    NewFamily( "GeneralPolygonalMorphismFamily", IsGeneralMapping, IsGeneralPolygonalMorphism ) );

#! @Section Construction of Morphisms
#! @SectionLabel Morphisms_Construction
#!
#! In this section, we give several different ways to construct morphisms
#! from scratch.

# TODO implement constructor by three lists (images of vertices, edges and faces)

# TODO implement IdentityMapping

# TODO implement InverseMapping/InverseMorphism (for appropriate...)

# TODO overload CompositionMapping2

#! @Section Elementary properties
#! @SectionLabel Morphisms_Properties

# TODO document some of the generic properties like IsInjective, IsSurjective, ...


#! @Section Images and pre-images

#TODO
# implement PreImagesOfVertex
# implement PreImagesOfEdge
# implement PreImagesOfFace


# implement ImageOfVertex (for a total and single-valued ..);
# implement ImageOfEdge (for a total and single-valued ..);
# implement ImageOfFace (for a total and single-valued ..);


#! @Section Components of a morphism

#List of TODO:
# implement VertexMapAsImageList (for single-valued);
# implement EdgeMapAsImageList (for single-valued);
# implement FaceMapAsImageList (for single-valued);

# attribute SourceComplex
# attribute SourceSurface
# attribute RangeComplex
# attribute RangeSurface


# attribute VertexMapping
# attribute EdgeMapping
# attribute FaceMapping


##########################################
# For a polygonal complex: maps between edges and shiftedEdges (compare graph.gi);
# For a polygonal complex: maps between faces and shiftedFaces (compare graph.gi);
# VEFLabelOfVertex
# VEFLabelOfEdge
# VEFLabelOfFace
# VertexOfVEFLabel
# EdgeOfVEFLabel
# FaceOfVEFLabel
# I don't like the name VEFLabel..

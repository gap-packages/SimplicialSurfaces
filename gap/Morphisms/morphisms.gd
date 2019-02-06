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


#List of TODO:

# For a polygonal complex: maps between edges and shiftedEdges (compare graph.gi);
# For a polygonal complex: maps between faces and shiftedFaces (compare graph.gi);

# attribute SourceComplex
# attribute SourceSurface
# attribute RangeComplex
# attribute RangeSurface

# overload CompositionMapping2

# attribute VertexMapping
# attribute EdgeMapping
# attribute FaceMapping

# implement PreImagesOfVertex
# implement PreImagesOfEdge
# implement PreImagesOfFace

# implement ImagesOfVertex
# implement ImagesOfEdge
# implement ImagesOfFace

# implement ImageOfVertex (for a total and single-valued ..);
# implement ImageOfEdge (for a total and single-valued ..);
# implement ImageOfFace (for a total and single-valued ..);

# implement IdentityMapping

# document some of the generic properties like IsInjective, IsSurjective, ...

# implement InverseMapping/InverseMorphism (for appropriate...)

# implement constructor by three lists (images of vertices, edges and faces)

# implement VertexMapAsImageList (for single-valued);
# implement EdgeMapAsImageList (for single-valued);
# implement FaceMapAsImageList (for single-valued);

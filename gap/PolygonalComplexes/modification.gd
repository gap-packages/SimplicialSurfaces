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

#! @Chapter Modification of polygonal complexes
#! @ChapterLabel Modification
#!
#! This chapter is concerned with the modification of polygonal complexes
#! (introduced in chapter <Ref Chap="PolygonalStructures"/> as a 
#! generalization of simplicial surfaces). This allows the construction
#! of new complexes from old ones.
#!
#! This chapter covers the operations of splitting 
#! (<Ref Sect="Section_Modification_Splitting"/>) and joining 
#! (<Ref Sect="Section_Modification_Joining"/>)
#! a polygonal complex along vertices or edges (more generally along 
#! a vertex-edge-path, which was introduced in section 
#! <Ref Sect="Section_Paths_VertexEdge"/>).
#!
#! The aim of these operations is to provide a set of tools that allows a
#! user to develop their own modifications without worrying too much about
#! the underlying incidence structure. To make this easier, section TODO
#! contains several useful modifications, along with an explanation how
#! they can be constructed with the elementary tools.
#!
#! Section TODO contains a more involved example that combines the 
#! modification of surfaces with a judicious use of the automorphism
#! group of section <Ref Sect="Section_Graphs_Automorphisms"/>.


#! @Section Splitting along a path
#! @SectionLabel Modification_Splitting
#! TODO
#Section Split along a path

#! @Section Removing faces
#! @SectionLabel Modification_FaceRemoval
#! TODO
#Section Removing faces

#! @Section Disjoint union
#! @Section Modification_DisjointUnion
#! TODO
#Section Disjoint union

#! @Section Joining along a path
#! @SectionLabel Modification_Joining
#! TODO
#Section Joining along a path

#TODO duality where combining and cutting method are described together?



# Connected sum over
# * face
# * edge (where edge blows up)
# <-> Separation at two-waist or three-waist

# cut/mend edges

# These do not fit the above pattern:
# SnippOffEars      -> can be an advanced example
# CommonCover       -> does not fit here at all -> chapter Coverings (or only as a section in chapter "Associated Complexes" that also includes DualSurface?)
# DualSurface       -> does not fit here at all -> ?
# AddVertexIntoEdge (and the rest of Jesse's stuf) -> subdivision section?

DeclareOperation( "SubcomplexByFaces", [IsPolygonalComplex, IsSet] );
DeclareOperation( "SubcomplexByFacesNC", [IsPolygonalComplex, IsSet] );

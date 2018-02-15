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
#!
#! This section contains the basic functionality for splitting polygonal
#! complexes along edges (<Ref Subsect="SplitEdge"/>) and vertices 
#! (<Ref Subsect="SplitVertex"/>). More generally, it also
#! provides methods to split along
#! vertex-edge-paths (<Ref Subsect="SplitVertexEdgePath"/> and 
#! <Ref Subsect="SplitEdgePath"/>).
#!
#! After splitting one element into several elements the label of the
#! old element is replaced by new labels. The splitting methods always
#! return the new labels to make further modification easier.
#!
#! This will be illustrated on a hexagon.
#! <Alt Only="TikZ">
#!   \input{Image_SplitExample.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> hex := SimplicialSurfaceByDownwardIncidence(
#! >      [ [1,7],[2,7],[3,7],[4,7],[5,7],[6,7],[1,2],[2,3],[3,4],[4,5],[5,6],[1,6] ],
#! >      [ [1,2,7],[2,3,8],[3,4,9],[4,5,10],[5,6,11],[1,6,12] ]);;
#! @EndExampleSession
#!
#! For example it is possible to split the inner edge 1 into two 
#! boundary edges 13 and 14 by <K>SplitEdge</K> (<Ref Subsect="SplitEdge"/>).
#! @BeginExampleSession
#! gap> edgeSplit := SplitEdge(hex, 1);;
#! gap> edgeSplit[2];
#! [ 13, 14 ];
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   {
#!     \def\splitEdge{1}
#!     \input{Image_SplitExample.tex}
#!   }
#! </Alt>
#! Conversely, trying to split a boundary edge, like 7, would have made
#! no difference:
#! @BeginExampleSession
#! gap> boundSplit := SplitEdge(hex, 7);;
#! gap> boundSplit[1] = hex;
#! true
#! @EndExampleSession
#!
#! After the edge split the vertex 1 has two umbrellas (compare
#! <Ref Subsect="UmbrellaPartitionsOfVertices"/> for details). These
#! can be split up by <K>SplitVertex</K> (<Ref Subsect="SplitVertex"/>).
#! @BeginExampleSession
#! gap> vertSplit := SplitVertex( edgeSplit[1], 1 );;
#! gap> vertSplit[2];
#! [ 8, 9 ]
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   {
#!     \def\splitBoundaryRight{1}
#!     \input{Image_SplitExample.tex}
#!   }
#! </Alt>
#!
#! These two splitting operations can also be combined by using a 
#! vertex-edge-path (introduced in section 
#! <Ref Sect="Section_Paths_VertexEdge"/>). For example, to cut
#! through the edges 1 and 4 of the hexagon (along with the incident
#! vertices), we can use <K>SplitVertexEdgePath</K> 
#! (<Ref Subsect="SplitVertexEdgePath"/>).
#! @BeginExampleSession
#! gap> hexCut := SplitVertexEdgePath( hex, [4,4,7,1,1] );;
#! gap> NumberOfConnectedComponents(hexCut[1]);
#! 2
#! @EndExampleSession
#TODO check second output
#! <Alt Only="TikZ">
#!   {
#!     \def\splitCenter{1}
#!     \def\splitBoundaryLeft{1}
#!     \def\splitBoundaryRight{1}
#!     \input{Image_SplitExample.tex}
#!   }
#! </Alt>
#!
#! If instead only the central vertex should be splitted (such that the
#! edge split "opens" the surface), the method <K>SplitEdgePath</K>
#! (<Ref Subsect="SplitEdgePath"/>) can be used instead.
#! @BeginExampleSession
#! gap> hexOpen := SplitEdgePath( hex, [4,4,7,1,1] );;
#! gap> NumberOfConnectedComponents(hexOpen[1]);
#! 1
#! @EndExampleSession
#TODO check second output
#! <Alt Only="TikZ">
#!   {
#!     \def\splitCenter{1}
#!     \input{Image_SplitExample.tex}
#!   }
#! </Alt>
#!
#! 
#!
#! 
#!
#! 
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

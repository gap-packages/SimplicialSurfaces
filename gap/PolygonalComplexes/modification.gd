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
#! [ 13, 14 ]
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


#! @BeginGroup SplitEdge
#! @Description
#! Split the given <A>edge</A> in the polygonal complex <A>complex</A> into
#! as many edges as there are faces incident to <A>edge</A>. If there was only
#! one incident face (i.e. the edge is a boundary edge 
#! (<Ref Subsect="BoundaryEdges"/>)) then no labels are
#! changed. Otherwise the old edge label is no longer used and will be
#! replaced by the appropriate number of new labels. The new labels can be
#! defined by the optional argument <A>newEdgeLabels</A>.
#!
#! TODO examples
#!
#! The NC-version does not check whether <A>edge</A> is an actual edge of
#! <A>complex</A> and whether the new edge labels are actually available.
#!
#! @Returns a pair, where the first entry is a polygonal complex and the
#!   second entry is a set of the new edge labels.
#! @Arguments complex, edge[, newEdgeLabels]
DeclareOperation( "SplitEdge", [IsPolygonalComplex, IsPosInt, IsList] );
#! @Arguments complex, edge[, newEdgeLabels]
DeclareOperation( "SplitEdgeNC", [IsPolygonalComplex, IsPosInt, IsList] );
#! @EndGroup


#! @BeginGroup SplitVertex
#! @Description
#! Split the given <A>vertex</A> in the polygonal complex <A>complex</A> into
#! as many vertices as necessary such that the incident faces of the new
#! vertices are connected via the incident edges of these vertices.
#!
#! For a polygonal surface this corresponds to adding one vertex for each
#! element of the umbrella partition 
#! (<Ref Subsect="UmbrellaPartitionsOfVertices"/>) of <A>vertex</A>.
#!
#! If the vertex does not have to be split according to this rule (i.e. it is
#! an inner (<Ref Subsect="InnerVertices"/>) or a boundary 
#! (<Ref Subsect="BoundaryVertices"/>) vertex), its
#! label will stay the same. Otherwise the old label will be removed and
#! replaced by new labels. The new labels can be defined by the optional
#! argument <A>newVertexLabels</A>.
#!
#! TODO examples
#!
#! The NC-version does not check whether <A>vertex</A> is an actual vertex of
#! <A>complex</A> and whether the new vertex labels are actually available.
#!
#! @Returns a pair, where the first entry is a polygonal complex and the
#!   second entry is a set of the new vertex labels.
#! @Arguments complex, vertex[, newVertexLabels]
DeclareOperation( "SplitVertex", [IsPolygonalComplex, IsPosInt, IsList] );
#! @Arguments complex, vertex[, newVertexLabels]
DeclareOperation( "SplitVertexNC", [IsPolygonalComplex, IsPosInt, IsList] );
#! @EndGroup


#! @BeginGroup SplitVertexEdgePath
#! @Description
#! Split the given <A>complex</A> along the given <A>vePath</A>. First,
#! all edges of the path are splitted by <K>SplitEdge</K> 
#! (<Ref Subsect="SplitEdge"/>), then all vertices of the path are splitted
#! by <K>SplitVertex</K> (<Ref Subsect="SplitVertex"/>). If the first and
#! final vertex of <A>vePath</A> should not be splitted, the method
#! <K>SplitEdgePath</K> (<Ref Subsect="SplitEdgePath"/>) should be used
#! instead.
#!
#! The given <A>vePath</A> has to be a duplicate-free 
#! (<Ref Subsect="VertexEdge_IsDuplicateFree"/>) vertex-edge-path
#! (for the definition see <Ref Subsect="VertexEdgePath"/>) of <A>complex</A>.
#!
#! This method returns a pair where the first component is the splitted
#! <A>complex</A> and the second one contains the changed labels.
#! The second component is a list of pairs [<A>newPath</A>, <A>oldPath</A>].
#! These are computed as follows: If the original <A>vePath</A> would be 
#! marked in the splitted complex, it would show up as multiple 
#! vertex-edge-paths. Each of those is a <A>newPath</A> and the corresponding
#! <A>oldPath</A> is the unique subpath of the original <A>vePath</A>, such
#! that each element of <A>newPath</A> was obtained from the element at the
#! same position in <A>oldPath</A>.
#!
#! TODO explain better
#!
#! TODO many, many examples
#!
#! TODO explain alternative calls, refer to vertex-edge-paths and how those
#! can be constructed "more easily".
#!
#! The NC-versions do not check whether the given vertex-edge-paths match
#! the given <A>complex</A>.
#!
#! @Returns a pair, where the first entry is a polygonal complex and the
#!   second entry encodes the label changes
#! @Arguments complex, vePath
DeclareOperation( "SplitVertexEdgePath", [IsPolygonalComplex, IsVertexEdgePath] );
#! @Arguments complex, vePath
DeclareOperation( "SplitVertexEdgePathNC", [IsPolygonalComplex, IsVertexEdgePath] );
#! @Arguments complex, pathAsList
DeclareOperation( "SplitVertexEdgePath", [IsPolygonalComplex, IsList] );
#! @Arguments complex, pathAsList
DeclareOperation( "SplitVertexEdgePathNC", [IsPolygonalComplex, IsList] );
#! @EndGroup


#! @BeginGroup SplitEdgePath
#! @Description
#! Split the given <A>complex</A> along the given <A>vePath</A>. First,
#! all edges of the path are splitted by <K>SplitEdge</K> 
#! (<Ref Subsect="SplitEdge"/>), then all vertices of the path (except first
#! and last) are splitted
#! by <K>SplitVertex</K> (<Ref Subsect="SplitVertex"/>). If the first and
#! final vertex of <A>vePath</A> should also be splitted, the method
#! <K>SplitVertexEdgePath</K> (<Ref Subsect="SplitVertexEdgePath"/>) should
#! be used instead.
#!
#! The given <A>vePath</A> has to be a duplicate-free 
#! (<Ref Subsect="VertexEdge_IsDuplicateFree"/>) vertex-edge-path
#! (for the definition see <Ref Subsect="VertexEdgePath"/>) of <A>complex</A>.
#!
#! This method returns a pair where the first component is the splitted
#! <A>complex</A> and the second one contains the changed labels.
#! The second component is a list of pairs [<A>newPath</A>, <A>oldPath</A>].
#! These are computed as follows: If the original <A>vePath</A> would be 
#! marked in the splitted complex, it would show up as multiple 
#! vertex-edge-paths. Each of those is a <A>newPath</A> and the corresponding
#! <A>oldPath</A> is the unique subpath of the original <A>vePath</A>, such
#! that each element of <A>newPath</A> was obtained from the element at the
#! same position in <A>oldPath</A>.
#!
#! TODO explain better
#!
#! TODO many, many examples
#!
#! TODO explain alternative calls, refer to vertex-edge-paths and how those
#! can be constructed "more easily".
#!
#! The NC-versions do not check whether the given vertex-edge-paths match
#! the given <A>complex</A>.
#!
#! @Returns a pair, where the first entry is a polygonal complex and the
#!   second entry encodes the label changes
#! @Arguments complex, vePath
DeclareOperation( "SplitEdgePath", [IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree] );
#! @Arguments complex, vePath
DeclareOperation( "SplitEdgePathNC", [IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree] );
#! @Arguments complex, pathAsList
DeclareOperation( "SplitEdgePath", [IsPolygonalComplex, IsList] );
#! @Arguments complex, pathAsList
DeclareOperation( "SplitEdgePathNC", [IsPolygonalComplex, IsList] );
#! @EndGroup


#! @Section Removing faces
#! @SectionLabel Modification_FaceRemoval
#!
#! This section contains the functionality to:
#! * remove faces of a polygonal complex
#! * restrict a polygonal complex to a subset of faces
#!
#! TODO nice intro example

#! @BeginGroup SubcomplexByFaces
#! @Description
#! Return the polygonal complex that is generated by restricting 
#! <A>complex</A> to the given set of faces. This will remove all edges
#! and vertices that are not incident to one of the remaining faces.
#!
#! All labels of remaining vertices, edges and faces will remain the same.
#! 
#! TODO example
#!
#! The NC-version does not check whether the given set of <A>faces</A>
#! actually consists only of faces in <A>complex</A>.
#! 
#! @Returns a polygonal complex
#! @Arguments complex, faces
DeclareOperation( "SubcomplexByFaces", [IsPolygonalComplex, IsSet] );
#! @Arguments complex, faces
DeclareOperation( "SubcomplexByFacesNC", [IsPolygonalComplex, IsSet] );
#! @EndGroup


#! @BeginGroup RemoveFaces
#! @Description
#! Remove the given faces from <A>complex</A> and return the result. All
#! vertices and edges that were incident to just these faces will also be
#! removed as a result. The labels of the remaining vertices, edges and faces
#! will remain unaffected.
#!
#! TODO example
#!
#! The NC-version does not check whether the given set of <A>faces</A> 
#! actually consists only of faces in <A>complex</A>.
#!
#! @Returns a polygonal complex
#! @Arguments complex, faces
DeclareOperation( "RemoveFaces", [IsPolygonalComplex, IsSet] );
#! @Arguments complex, faces
DeclareOperation( "RemoveFacesNC", [IsPolygonalComplex, IsSet] );
#! @Arguments complex, face
DeclareOperation( "RemoveFace", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "RemoveFaceNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup



#! @Section Disjoint union
#! @SectionLabel Modification_DisjointUnion
#! 
#! This section explains the conventions of disjoint unions 
#! (<Ref Subsect="DisjointUnion"/>) of polygonal
#! complexes. While this might seem trivial at first, its behaviour has
#! to be stated clearly and unambiguously, since all of the joining
#! modifications of section <Ref Sect="Section_Modification_Joining"/> are
#! based on it.
#!
#! To illustrate this, consider the tetrahedron.
#! @BeginExampleSession
#! gap> tetra := Tetrahedron();;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!     \input{Image_Tetrahedron_Net.tex}
#!   \end{tikzpicture}
#! </Alt>
#! Both of these tetrahedra have the same labels for vertices, edges and faces.
#! @BeginExampleSession
#! gap> Vertices(tetra);
#! [ 1, 2, 3, 4 ]
#! gap> Edges(tetra);
#! [ 1, 2, 3, 4, 5, 6 ]
#! gap> Faces(tetra);
#! [ 1, 2, 3, 4 ]
#! @EndExampleSession
#! A disjoint union can't just combine these labels because it would not be
#! clear to which component the vertex 2 is belonging. This conflict of labels
#! is a common occurence and has to be handled delicately.
#!
#! The <K>SimplicialSurface</K>-package deals with this problem by uniformly
#! shifting the labels of the second argument.
#! @BeginExampleSession
#! gap> disjoint := DisjointUnion(tetra, tetra);;
#! gap> Vertices( disjoint[1] );
#! [ 1, 2, 3, 4, 7, 8, 9, 10 ]
#! gap> Edges( disjoint[1] );
#! [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]
#! gap> Faces( disjoint[1] );
#! [ 1, 2, 3, 4, 7, 8, 9, 10 ]
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!     \begin{scope}
#!        \input{Image_Tetrahedron_Net.tex}
#!     \end{scope}
#!     \begin{scope}[xshift=8cm];
#!        \def\disjoint{1}
#!        \input{Image_Tetrahedron_Net.tex}
#!     \end{scope}
#!   \end{tikzpicture}
#! </Alt>
#! Notably all labels of the second tetrahedron were shifted by the same
#! amount. More precisely they are shifted by the highest label of the
#! first tetrahedron - which is the edge label 6.
#!
#! To be able to use this information in further calculations, the used
#! shift is returned as well.
#! @BeginExampleSession
#! gap> disjoint[2];
#! 6
#! @EndExampleSession
#!


#! @BeginGroup DisjointUnion
#! @Description
#! Return the disjoint union of the given two polygonal complexes.
#! In this process the labels of the second complex usually are shifted.
#! The default shift is determined by this procedure:
#! <Enum>
#!   <Item>If the labels of vertices, edges and faces do not overlap,
#!      the second labels do not need to be shifted. The default shift
#!      is 0.</Item>
#!   <Item>Otherwise the labels of the second complex are shifted by
#!      the highest label of the first complex - which may be the label
#!      of a vertex, an edge or a face.</Item>
#! </Enum>
#! If the optional <A>shift</A> is higher than the default shift, it will
#! be used instead. Otherwise it will be ignored.
#! 
#! All labels of the second complex are shifted upwards by the same amount,
#! even if it would not be necessary to shift all of them that much to make
#! the labels disjoint.
#!       
#! TODO example different from the one before?
#!
#! @Returns a pair, where the first entry is a polygonal complex and the
#!   second entry is the used shift
#! @Arguments complex1, complex2[, shift]
DeclareOperation( "DisjointUnion", [IsPolygonalComplex, IsPolygonalComplex, IsInt] );
#! @EndGroup



#! @Section Joining along a path
#! @SectionLabel Modification_Joining
#!
#! This section contains the basic functionality for joining polygonal 
#! complexes along vertices and edges and more generally along
#! vertex-edge-paths (for their definition, compare
#! <Ref Subsect="VertexEdgePath"/>). More specifically the following
#! operations are supported:
#! * Identifying two vertices (<Ref Subsect="JoinVertices"/>)
#! * Identifying two edges (<Ref Subsect="JoinEdges"/>)
#! * Identifying two vertex-edge-paths (<Ref Subsect="JoinVertexEdgePaths"/>)
#! * Identifying the perimeters of two boundaries/holes 
#!   (<Ref Subsect="JoinPerimeters"/>)
#!
#! 
#! TODO examples + Tests





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


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
#! the underlying incidence structure. To make this easier, section
#! <Ref Sect="Section_Modification_Applications"/>
#! contains several useful modifications, along with an explanation how
#! they can be constructed with the elementary tools.


#! @BeginChunk VertexEdgePath_Construction
#! Vertex-edge-paths can be created easily:
#! * From a list of vertices: <K>VertexEdgePathByVertices</K> 
#!   (<Ref Subsect="VertexEdgePathByVertices"/>)
#! * From a list of edges: <K>VertexEdgePathByEdges</K>
#!   (<Ref Subsect="VertexEdgePathByEdges"/>)
#! * From a list in which vertices and edges are alternating:
#!   <K>VertexEdgePath</K> (<Ref Subsect="VertexEdgePath"/>)
#! @EndChunk

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
#! <Ref Subsect="UmbrellaPathPartitionsOfVertices"/> for details). These
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
#!
#! The splitting path can be given in multiple ways: via vertices,
#! via edges or by giving an alternating list of both.
#! @BeginExampleSession
#! gap> cutPath := VertexEdgePath(hex, [4,4,7,1,1]);
#! | v4, E4, v7, E1, v1 |
#! gap> VertexEdgePathByVertices(hex, [4,7,1]);
#! | v4, E4, v7, E1, v1 |
#! gap> VertexEdgePathByEdges(hex, [4,1]);
#! | v4, E4, v7, E1, v1 |
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \input{Image_SplitExample.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> hexCut := SplitVertexEdgePath( hex, cutPath );;
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
#! gap> hexOpen := SplitEdgePath( hex, cutPath );;
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
#! For example consider the following triangular complex:
#! <Alt Only="TikZ">
#! 	\def\closed{1}	
#!	\input{Image_Eye_Open.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> closeEye:=SimplicialSurfaceByDownwardIncidence(
#! >            [[1,2],[1,3],[2,3],[3,4],[1,4]],[[1,2,3],[2,4,5]]);
#! simplicial surface (4 vertices, 5 edges, and 2 faces)
#! gap> eye:=SplitEdge(closeEye,2);
#! [ triangular complex (4 vertices, 6 edges, and 2 faces), [ 6, 7 ] ] 
#! @EndExampleSession
#! 
#! <Alt Only="TikZ">
#!      \input{Image_Eye_Open.tex}
#! </Alt>
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
#! (<Ref Subsect="UmbrellaPathPartitionsOfVertices"/>) of <A>vertex</A>.
#!
#! If the vertex does not have to be split according to this rule (i.e. it is
#! an inner (<Ref Subsect="InnerVertices"/>) or a boundary 
#! (<Ref Subsect="BoundaryVertices"/>) vertex), its
#! label will stay the same. Otherwise the old label will be removed and
#! replaced by new labels. The new labels can be defined by the optional
#! argument <A>newVertexLabels</A>.
#!
#! For example consider the following triangular complex:
#! <Alt Only="TikZ">
#!   \input{Image_EdgeFacePath_ramified.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> ramSurf := PolygonalComplexByDownwardIncidence(
#! > [ ,,,,,,,,,,,,[6,5],[1,5],[5,7],[6,1],[6,7],[1,7],
#! > [1,8],[1,10],[1,12],[8,10],[10,12] ],
#! > [ , [14,15,18],[13,14,16],[16,17,18],,,,,[19,22,20],,[20,21,23] ]);;
#! gap> splittedComplex:=SplitVertex(ramSurf,1);
#! [ simplicial surface (8 vertices, 11 edges, and 5 faces), [ 13, 14 ] ]
#! @EndExampleSession
#! Splitting the vertex 1 in the complex divides the complex into two components:
#! @BeginExampleSession
#! gap> NumberOfConnectedComponents(splittedComplex[1]);
#! 2
#! @EndExampleSession
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
#! This method will change the labels of all affected vertices and edges.
#! All other labels remain unchanged.
#!
#! The given <A>vePath</A> has to be a duplicate-free 
#! (<Ref Subsect="VertexEdge_IsDuplicateFree"/>) vertex-edge-path
#! (for the definition see <Ref Subsect="VertexEdgePath"/>) of <A>complex</A>.
#! @InsertChunk VertexEdgePath_Construction
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
#! For example consider the following polygonal complex:
#! @BeginExampleSession
#! gap> complex:=PolygonalComplexByDownwardIncidence([[1,2],[2,3],[1,3],[1,4],
#! > [3,4],[3,5],[5,6],[3,6],[3,7],[6,7]],[[1,2,3],[3,4,5],[6,7,8],[8,9,10]]);;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \input{Image_SplitEdgePath.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> path:=VertexEdgePathByEdges(complex,[3,8]);
#! | v1, E3, v3, E8, v6 |
#! @EndExampleSession
#! Splitting the complex along this path leads to four one faces:
#! @BeginExampleSession
#! gap> splitted:=SplitVertexEdgePath(complex,path);;
#! gap> NumberOfConnectedComponents(splitted[1]);
#! 4
#! @EndExampleSession
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
#! This method will change the labels of all affected vertices and edges.
#! All other labels remain unchanged.
#!
#! The given <A>vePath</A> has to be a duplicate-free 
#! (<Ref Subsect="VertexEdge_IsDuplicateFree"/>) vertex-edge-path
#! (for the definition see <Ref Subsect="VertexEdgePath"/>) of <A>complex</A>.
#! @InsertChunk VertexEdgePath_Construction
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
#! For example consider the following polygonal complex:
#! @BeginExampleSession
#! gap> complex:=PolygonalComplexByDownwardIncidence([[1,2],[2,3],[1,3],[1,4],
#! > [3,4],[3,5],[5,6],[3,6],[3,7],[6,7]],[[1,2,3],[3,4,5],[6,7,8],[8,9,10]]);;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \input{Image_SplitEdgePath.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> path:=VertexEdgePathByEdges(complex,[3,8]);
#! | v1, E3, v3, E8, v6 |
#! @EndExampleSession
#! Splitting the complex along this path without the first and the last vertex leads
#! to two components:
#! @BeginExampleSession
#! gap> splitted:=SplitEdgePath(complex,path);;
#! gap> NumberOfConnectedComponents(splitted[1]);
#! 2
#! @EndExampleSession
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
#! @EndGroup


#! @Section Removing faces
#! @SectionLabel Modification_FaceRemoval
#!
#! This section contains the functionality to:
#! * remove faces of a polygonal complex
#! * restrict a polygonal complex to a subset of faces
#!
#! The functions will be illustrated on a hexagon.
#! <Alt Only="TikZ">
#!   \input{Image_SplitExample.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> hex := SimplicialSurfaceByDownwardIncidence(
#! > [ [1,7],[2,7],[3,7],[4,7],[5,7],[6,7],[1,2],[2,3],[3,4],[4,5],[5,6],[1,6] ],
#! > [ [1,2,7],[2,3,8],[3,4,9],[4,5,10],[5,6,11],[1,6,12] ]);;
#! @EndExampleSession
#! For example it is possible to remove the face 1.
#! @BeginExampleSession
#! gap> removedHex := RemoveFace(hex,1);
#! simplicial surface (7 vertices, 11 edges, and 5 faces) 
#! @EndExampleSession
#! It is also possible to restrict the hexagon to the faces 2 to 6.
#! @BeginExampleSession
#! gap> restrictedHex := SubcomplexByFaces(hex,[2,3,4,5,6]);
#! simplicial surface (7 vertices, 11 edges, and 5 faces)
#! @EndExampleSession
#! These two surfaces are isomorphic.
#! @BeginExampleSession
#! gap> IsIsomorphic(removedHex,restrictedHex);
#! true
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \def\removeFace{1}
#!   \input{Image_Hexagon_RemovedFace.tex}
#! </Alt>

#! @BeginGroup SubcomplexByFaces
#! @Description
#! Return the polygonal complex that is generated by restricting 
#! <A>complex</A> to the given set of faces. This will remove all edges
#! and vertices that are not incident to one of the remaining faces.
#!
#! All labels of remaining vertices, edges and faces will remain the same.
#! The method <K>SubsurfaceByFaces</K> is only applicable to surfaces
#! and guarantees that the returned subcomplex is a surface. If this
#! is not possible <K>fail</K> is returned.
#! 
#! For example consider the hexagon from the start of this chapter:
#! @BeginExampleSession
#! gap> SubcomplexByFaces(hex,[2,5]);
#! triangular complex (5 vertices, 6 edges, and 2 faces)
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \input{Image_Hexagon_RemovedFace.tex}
#! </Alt>
#!
#! The NC-version does not check whether the given set of <A>faces</A>
#! actually consists only of faces in <A>complex</A>. It also does not
#! check whether the result of <K>SubsurfaceByFaces</K> is a surface.
#! 
#! @Returns a twisted polygonal complex
#! @Arguments complex, faces
DeclareOperation( "SubcomplexByFaces", [IsTwistedPolygonalComplex, IsSet] );
#! @Arguments complex, faces
DeclareOperation( "SubcomplexByFacesNC", [IsTwistedPolygonalComplex, IsSet] );
#! @Returns a twisted polygonal surface
#! @Arguments surface, faces
DeclareOperation( "SubsurfaceByFaces", [IsTwistedPolygonalComplex, IsSet] );
#! @Arguments surface, faces
DeclareOperation( "SubsurfaceByFacesNC", [IsTwistedPolygonalComplex, IsSet] );
#! @EndGroup


#! @BeginGroup RemoveFaces
#! @Description
#! Remove the given faces from <A>complex</A> and return the result. If this
#! removal results in vertices or edges that are not incident to any remaining
#! faces, they will be removed as well.
#! The labels of all remaining vertices, edges and faces
#! will remain unaffected.
#!
#! For example consider the Tetrahedron and remove one face:
#! @BeginExampleSession
#! gap> tetraRemoved:=RemoveFace(Tetrahedron(),1);
#! simplicial surface (4 vertices, 6 edges, and 3 faces)
#! gap> IsClosedSurface(tetraRemoved);
#! false
#! @EndExampleSession
#!  <Alt Only="TikZ">
#!   \input{Image_Tetra_RemovedFace.tex}
#! </Alt>
#!
#! The NC-version does not check whether the given set of <A>faces</A> 
#! actually consists only of faces in <A>complex</A>.
#!
#! @Returns a polygonal complex
#! @Arguments complex, faces
DeclareOperation( "RemoveFaces", [IsTwistedPolygonalComplex, IsSet] );
#! @Arguments complex, faces
DeclareOperation( "RemoveFacesNC", [IsTwistedPolygonalComplex, IsSet] );
#! @Arguments complex, face
DeclareOperation( "RemoveFace", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "RemoveFaceNC", [IsTwistedPolygonalComplex, IsPosInt] );
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
#! [ 1 .. 4 ]
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
#! For example also the disjoint union of two different complexes can be build:
#! @BeginExampleSession
#! gap> oneFace:=SimplicialSurfaceByDownwardIncidence(
#! > [[1,2],[2,3],[1,3]],[[1,2,3]]);;
#! gap> DisjointUnion(oneFace, JanusHead());
#! [ simplicial surface (6 vertices, 6 edges, and 3 faces), 3 ]
#! @EndExampleSession
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
#!   (<Ref Subsect="JoinBoundaries"/>)
#!
#! 
#! For example conisder the following complex:
#! @BeginExampleSession
#! gap> complex:=SimplicialSurfaceByDownwardIncidence(
#! >            [,[2,7],[3,7],[4,7],[5,7],[6,7],[2,8],[2,3],[3,4],
#! >            [4,5],[5,6],[6,9],[7,8],[7,9]],
#! >            [[2,7,13],[2,3,8],[3,4,9],[4,5,10],[5,6,11],[6,12,14]]);;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   {
#!     \def\splitBoundaryRight{1}
#!     \input{Image_SplitExample.tex}
#!   }
#! </Alt>
#! It is possible to join the vertices 8 and 9 and the new vertex will get the label 1.
#! @BeginExampleSession
#! gap> vertJoin:=JoinVertices(complex,[8,9],1);;
#! gap> vertJoin[2];
#! 1
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   {
#!     \def\splitEdge{1}
#!     \input{Image_SplitExample.tex}
#!   }
#! </Alt>
#! After this vertex join the edges 13 and 14 can be join to a new edge with label 1.
#! @BeginExampleSession
#! gap> edgeJoin:=JoinEdges(vertJoin[1],13,14,1);;
#! gap> edgeJoin[2];
#! 1
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \input{Image_SplitExample.tex}
#! </Alt>
#! These two joining operations can also be combined by using a vertex-edge-path 
#! (introduced in section  <Ref Sect="Section_Paths_VertexEdge"/>).
#! Consider the following complex:
#! @BeginExampleSession
#! gap> hexOpen:=SimplicialSurfaceByDownwardIncidence(
#! >            [,[2,12],[3,12],,[5,13],[6,13],[2,8],[2,3],[3,10],[5,11],
#! >            [5,6],[6,9],[8,12],[9,13],[10,12],[11,13]],
#! >            [[2,7,13],[2,3,8],[3,9,15],[5,10,16],[5,6,11],[6,12,14]]);;
#! @EndExampleSession 
#! <Alt Only="TikZ">
#!   {
#!     \def\splitCenter{1}
#!     \def\splitBoundaryLeft{1}
#!     \def\splitBoundaryRight{1}
#!     \input{Image_SplitExample.tex}
#!   }
#! </Alt>
#! The two joining paths can be given in multiple ways: via vertices, via edges or by giving an alternating list of both.
#! @BeginExampleSession
#! gap> path1:=VertexEdgePath(hexOpen,[10,15,12,13,8]);
#! | v10, E15, v12, E13, v8 |
#! gap> VertexEdgePathByVertices(hexOpen,[10,12,8]);
#! | v10, E15, v12, E13, v8 |
#! gap> VertexEdgePathByEdges(hexOpen,[15,13]);
#! | v10, E15, v12, E13, v8 |
#! gap> path2:=VertexEdgePath(hexOpen,[11,16,13,14,9]);
#! | v11, E16, v13, E14, v9 |
#! gap> VertexEdgePathByVertices(hexOpen,[11,13,9]);
#! | v11, E16, v13, E14, v9 |
#! gap> VertexEdgePathByEdges(hexOpen,[16,14]);
#! | v11, E16, v13, E14, v9 |
#! gap> hex:=JoinVertexEdgePaths(hexOpen,path1,path2);;
#! gap> NumberOfConnectedComponents(hex[1]);
#! 1
#! @EndExampleSession
#!  <Alt Only="TikZ">
#!   \input{Image_SplitExample.tex}
#! </Alt>

#! @BeginGroup JoinVertices
#! @Description
#! Combine two vertices into one. This method comes in two flavors:
#! <Enum>
#!   <Item>Combine two vertices <A>v1</A> and <A>v2</A> of a single
#!      polygonal complex <A>complex</A> into one. This will return
#!      <K>fail</K> if the vertices are incident to a common face.
#!
#!      The optional argument <A>newVertexLabel</A> allows to set the
#!      label of the new vertex. By default, an unused label will be
#!      chosen.</Item>
#!   <Item>Combine two vertices <A>v1</A> and <A>v2</A> of two distinct
#!      polygonal complexes <A>complex1</A> and <A>complex2</A>. This will
#!      perform <K>DisjointUnion</K> (<Ref Subsect="DisjointUnion"/>) on
#!      the two complexes to reduce this problem to the first case.</Item>
#! </Enum>
#!
#! Both methods return a list, where the first entry is the new polygonal
#! complex, the second entry is the label of the new vertex and (only in the
#! second case) the third entry is the used shift of the disjoint union (refer
#! to section <Ref Sect="Section_Modification_DisjointUnion"/> for details).
#!
#! To illustrate the first case, consider the octahedron.
#! @BeginExampleSession
#! gap> octa := Octahedron();;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Octahedron_constructor.tex}
#! </Alt>
#! It is possible to join vertices on opposite sides, for example 1 and 6.
#! @BeginExampleSession
#! gap> octJoin := JoinVertices(octa, 1, 6);;
#! gap> octJoin = fail;
#! false
#! @EndExampleSession
#! This combines the vertices 1 and 6 into a new one, which becomes a 
#! ramified vertex (<Ref Subsect="RamifiedVertices"/>).
#! @BeginExampleSession
#! gap> octJoin[2];
#! 7
#! gap> Vertices(octJoin[1]);
#! [ 2, 3, 4, 5, 7 ]
#! gap> RamifiedVertices(octJoin[1]);
#! [ 7 ]
#! @EndExampleSession
#! On the other hand, it is not possible to join two vertices if they are 
#! connected by an edge.
#! @BeginExampleSession
#! gap> JoinVertices(octa, [2,3]);
#! fail
#! @EndExampleSession
#!
#! To illustrate the second case, consider the following two simplicial
#! surfaces:
#! @BeginExampleSession
#! gap> leftWing := SimplicialSurfaceByVerticesInFaces( [[1,2,3],[2,3,4],,[3,4,5]] );;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   {
#!     \def\leftWing{1}
#!     \input{Image_Butterfly_unbalanced.tex}
#!   }
#! </Alt>
#! @BeginExampleSession
#! gap> rightWing := SimplicialSurfaceByVerticesInFaces( [[1,2,3],[2,3,4]] );;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   {
#!     \def\rightWing{1}
#!     \input{Image_Butterfly_unbalanced.tex}
#!   }
#! </Alt>
#! If these two surfaces are joined along the vertices 3 (of the left wing) and
#! 2 (of the right wing), the labels of the second one have to be shifted.
#! @BeginExampleSession
#! gap> butterfly := JoinVertices(leftWing, 3, rightWing, 2);;
#! gap> butterfly[3];
#! 7
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   {
#!     \def\leftWing{1}
#!     \def\rightWing{1}
#!     \input{Image_Butterfly_unbalanced.tex}
#!   }
#! </Alt>
#! @BeginExampleSession
#! gap> butterfly[2];
#! 12
#! @EndExampleSession
#!
#! The NC-versions don't check whether the given vertices are distinct vertices of
#! the corresponding complexes and whether the <A>newVertexLabel</A> is available.
#!
#! @Returns a list, where the first entry is a polygonal complex, the second
#!   one is the new vertex label and the third is the shift for the labels of
#!   the second input <A>complex2</A> (only if applicable).
#! @Arguments complex, v1, v2[, newVertexLabel]
DeclareOperation( "JoinVertices", [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt] );
#! @Arguments complex, v1, v2[, newVertexLabel]
DeclareOperation( "JoinVerticesNC", [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt] );
#! @Arguments complex, vertexList[, newVertexLabel]
DeclareOperation( "JoinVertices", [IsPolygonalComplex, IsList, IsPosInt] );
#! @Arguments complex, vertexList[, newVertexLabel]
DeclareOperation( "JoinVerticesNC", [IsPolygonalComplex, IsList, IsPosInt] );
#! @Arguments complex1, v1, complex2, v2
DeclareOperation( "JoinVertices", [IsPolygonalComplex, IsPosInt, IsPolygonalComplex, IsPosInt] );
#! @Arguments complex1, v1, complex2, v2
DeclareOperation( "JoinVerticesNC", [IsPolygonalComplex, IsPosInt, IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup JoinEdges
#! @Description
#! Combine two edges <A>e1</A> and <A>e2</A> of a polygonal complex into one
#! edge, whose new label can be given by the optional argument 
#! <A>newEdgeLabel</A> (otherwise a default label is chosen). The edges have 
#! to have had the same incident vertices.
#! 
#! This method returns a pair, where the first entry is the modified polygonal
#! complex and the second entry is the label of the new edge.
#!
#! For example consider the following triangular complex without edge
#! ramifications:
#! @BeginExampleSession
#! gap> eye := TriangularComplexByDownwardIncidence(
#! >     [[1,2],[2,3],[1,3],[2,4],[3,4],[2,3]], [[1,2,3],[4,5,6]]);;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   {
#!     \def\open{1}
#!     \input{Image_Eye_OpenClosed.tex}
#!   }
#! </Alt>
#! The only edges that can be joined are those with equal incident vertices.
#! These can be found by <K>EdgeAnomalyClasses</K> 
#! (<Ref Subsect="EdgeAnomalies"/>).
#! @BeginExampleSession
#! gap> EdgeAnomalyClasses(eye);
#! [ [ 1 ], [ 2, 6 ], [ 3 ], [ 4 ], [ 5 ] ]
#! @EndExampleSession
#! The only pair of edges with the same incident vertices are 2 and 6.
#! @BeginExampleSession
#! gap> closeEye := JoinEdges( eye, 2, 6 );;
#! gap> closeEye[2];
#! 7
#! @EndExampleSession
#! <Alt Only="TikZ">
#!     \input{Image_Eye_OpenClosed.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> EdgeAnomalyClasses(closeEye[1]);
#! [ [ 1 ], [ 3 ], [ 4 ], [ 5 ], [ 7 ] ]
#! @EndExampleSession
#!
#! The NC-versions do not check whether the given edges are distinct edges
#! with the same incident vertices of <A>complex</A> and whether the new edge label is
#! actually valid.
#!
#! @Returns a pair, where the first entry is a polygonal complex and the
#!    second one is the new edge label
#! @Arguments complex, e1, e2[, newEdgeLabel]
DeclareOperation("JoinEdges", [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt]);
#! @Arguments complex, e1, e2[, newEdgeLabel]
DeclareOperation("JoinEdgesNC", [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt]);
#! @Arguments complex, edgeList[, newEdgeLabel]
DeclareOperation("JoinEdges", [IsPolygonalComplex, IsList, IsPosInt]);
#! @Arguments complex, edgeList[, newEdgeLabel]
DeclareOperation("JoinEdgesNC", [IsPolygonalComplex, IsList, IsPosInt]);
#! @EndGroup

#! @BeginGroup JoinFaces
#! @Description
#! Combine two faces <A>F1</A> and <A>F2</A> of a polygonal complex into one
#! face, whose new label can be given by the optional argument 
#! <A>newFaceLabel</A> (otherwise a default label is chosen). The faces have 
#! to have had the same incident edges.
#! 
#! This method returns a pair, where the first entry is the modified polygonal
#! complex and the second entry is the label of the new face.
#!
#! For example consider the Janus-head. The two faces have equal incident edges so they can be joined:
#! @BeginExampleSession
#! gap> JoinFaces(JanusHead(),1,2);
#! [ simplicial surface (3 vertices, 3 edges, and 1 faces), 3 ]
#! @EndExampleSession
#! The resulting surface is the one-face.
#!
#! The NC-versions do not check whether the given faces are distinct faces
#! with the same incident edges of <A>complex</A> and whether the new face label is
#! actually valid.
#!
#! @Returns a pair, where the first entry is a polygonal complex and the
#!    second one is the new face label
#! @Arguments complex, F1, F2[, newFaceLabel]
DeclareOperation("JoinFaces", [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt]);
#! @Arguments complex, F1, F2[, newFaceLabel]
DeclareOperation("JoinFacesNC", [IsPolygonalComplex, IsPosInt, IsPosInt, IsPosInt]);
#! @Arguments complex, faceList[, newFaceLabel]
DeclareOperation("JoinFaces", [IsPolygonalComplex, IsList, IsPosInt]);
#! @Arguments complex, faceList[, newFaceLabel]
DeclareOperation("JoinFacesNC", [IsPolygonalComplex, IsList, IsPosInt]);
#! @EndGroup

#! @BeginGroup JoinVertexEdgePaths
#! @Description
#! Combine two duplicate-free (<Ref Subsect="VertexEdge_IsDuplicateFree"/>) 
#! vertex-edge-paths (<Ref Subsect="VertexEdgePath"/>) of equal length 
#! into
#! one. This is done by first joining the corresponding vertices by
#! <K>JoinVertices</K> (<Ref Subsect="JoinVertices"/>) and then identifying
#! the corresponding edges with <K>JoinEdges</K> (<Ref Subsect="JoinEdges"/>).
#! If two polygonal complexes are given, they are combined with 
#! <K>DisjointUnion</K> (<Ref Subsect="DisjointUnion"/>) before these
#! identifications take place.
#!
#! If some of the vertices can't be identified because they are incident
#! to the same edge, <K>fail</K> is returned. Otherwise this method returns a
#! pair, where the first entry is a polygonal complex and the second one
#! is the vertex-edge-path in the new polygonal complex that was generated
#! by the identified vertex-edge-paths.
#!
#! One thing that can be done is the construction of a ramified edge. 
#! Consider just one triangle:
#! @BeginExampleSession
#! gap> triangle := SimplicialSurfaceByDownwardIncidence( [[1,2],[1,3],[2,3]],[[1,2,3]] );;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!     \def\len{3}
#!     \coordinate (L) at (0,0);
#!     \coordinate (R) at (\len,0);
#!     \coordinate (U) at (60:\len);
#!
#!     \draw[edge,face] (L) -- node[edgeLabel]{1} (R) -- node[edgeLabel]{3} (U) -- node[edgeLabel]{2} cycle;
#!     \node[faceLabel] at (barycentric cs:L=1,R=1,U=1){I};
#!     \foreach \p/\r/\n in {L/left/1,R/right/2,U/above/3}{
#!       \vertexLabelR{\p}{\r}{\n}
#!     }
#!   \end{tikzpicture}
#! </Alt>
#! First we combine two of them:
#! @BeginExampleSession
#! gap> joinPath := VertexEdgePathByVertices(triangle, [1,2]);
#! | v1, E1, v2 |
#! gap> join := JoinVertexEdgePaths(triangle, joinPath, triangle, joinPath);;
#! gap> join[2];
#! | v7, E7, v8 |
#! @EndExampleSession
#! Along this vertex-edge-path another of the triangles can be added:
#! @BeginExampleSession
#! gap> tripleJoin := JoinVertexEdgePaths(join[1],join[2],triangle,joinPath);;
#! gap> tripleJoin[2];
#! | v12, E12, v13 |
#! gap> RamifiedEdges(tripleJoin[1]);
#! [ 12 ]
#! @EndExampleSession
#! 
#! The NC-versions do not check whether the given vertex-edge-paths are
#! actually vertex-edge-paths of the polygonal complexes.
#! 
#! @Returns a pair, where the first entry is a polygonal complex and the
#!   second entry is a vertex-edge-path. The optional third entry describes
#!   the label shift of <A>complex2</A> (if applicable).
#! @Arguments complex, vePath1, vePath2
DeclareOperation("JoinVertexEdgePaths", [IsPolygonalComplex, 
    IsVertexEdgePath and IsDuplicateFree, 
    IsVertexEdgePath and IsDuplicateFree]);
#! @Arguments complex, vePath1, vePath2
DeclareOperation("JoinVertexEdgePathsNC", [IsPolygonalComplex, 
    IsVertexEdgePath and IsDuplicateFree, 
    IsVertexEdgePath and IsDuplicateFree]);
#! @Arguments complex1, vePath1, complex2, vePath2
DeclareOperation("JoinVertexEdgePaths", 
    [IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree, 
    IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree]);
#! @Arguments complex1, vePath1, complex2, vePath2
DeclareOperation("JoinVertexEdgePathsNC", 
    [IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree, 
    IsPolygonalComplex, IsVertexEdgePath and IsDuplicateFree]);
#! @EndGroup


#! @BeginGroup JoinBoundaries
#! @Description
#! Combine two boundaries into one. This method takes the starts of two
#! vertex-edge-paths (<Ref Subsect="VertexEdgePath"/>) and extends those
#! into vertex-edge-paths along the boundary of the given polygonal surfaces.
#! Then the method <K>JoinVertexEdgePaths</K> 
#! (<Ref Subsect="JoinVertexEdgePaths"/>) will be called on these 
#! vertex-edge-paths or if a length is given it will be called for possibly truncated vertex-edge-paths.
#!
#! If two surfaces should be combined, <K>DisjointUnion</K> 
#! (<Ref Subsect="DisjointUnion"/>) will be
#! called beforehand.
#!
#! Currently the <A>veList</A> has to be given as a list
#! [<A>vertex</A>, <A>edge</A>].
#!
#! For example, consider the following simplicial surface:
#! <Alt Only="TikZ">
#!  \input{Image_FourGon.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> fourGon := SimplicialSurfaceByDownwardIncidence(
#! >        [[1,2],[1,3],[1,4],[1,5],[2,3],[3,4],[4,5],[2,5]], 
#! >         [[1,2,5],[2,3,6],[3,4,7],[1,4,8]] );;
#! @EndExampleSession
#!
#! Combining two of these along their boundaries gives the octahedron.
#! @BeginExampleSession
#! gap> oct := JoinBoundaries(fourGon, [3,6], fourGon, [4,7]);;
#! gap> IsIsomorphic(oct[1], Octahedron());
#! true
#! gap> octLength := JoinBoundaries(fourGon, [3,6], fourGon, [4,7], 4);;
#! gap> IsIsomorphic(octLength[1], Octahedron());
#! true
#! @EndExampleSession
#!
#! @Returns a list, where the first entry is a polygonal surface, the
#!   second one is a vertex-edge-path and the third one is the label
#!   shift of <A>complex2</A> (if applicable).
#! @Arguments surface, veList1, veList2, [length]
   DeclareOperation( "JoinBoundaries", [IsPolygonalComplex, IsList, IsList, IsInt] );
#! @Arguments surface, veList1, veList2, [length]
   DeclareOperation( "JoinBoundariesNC", [IsPolygonalComplex, IsList, IsList, IsInt] );
#! @Arguments surface1, veList1, surface2, veList2, [length]
   DeclareOperation( "JoinBoundaries", [IsPolygonalComplex, IsList, IsPolygonalComplex, IsList, IsInt] );
#! @Arguments surface1, veList1, surface2, veList2, [length]
   DeclareOperation( "JoinBoundariesNC", [IsPolygonalComplex, IsList, IsPolygonalComplex, IsList, IsInt] );
#! @EndGroup

#! @BeginGroup JoinBoundary
#! @Description
#! This method takes a boundary vertex <A>v</A> and joins the vertex-edge-path of the 
#! boundary where <A>v</A> lies on if the path has even length. 
#! This means, the method splits the vertex-edge-path of the boundary in two parts. 
#! Then the method <K>JoinVertexEdgePaths</K> (<Ref Subsect="JoinVertexEdgePaths"/>) will be called on these 
#! two vertex-edge-paths.
#!
#! For example, consider the following simplicial surface:
#! <Alt Only="TikZ">
#!  \input{Image_FourGon.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> fourGon := SimplicialSurfaceByDownwardIncidence(
#! >        [[1,2],[1,3],[1,4],[1,5],[2,3],[3,4],[4,5],[2,5]],
#! >         [[1,2,5],[2,3,6],[3,4,7],[1,4,8]] );;
#! @EndExampleSession
#! Joining the boundary together of this surface gives a closed surface.
#! @BeginExampleSession
#! gap> joined:=JoinBoundary(fourGon,2);
#! [ simplicial surface (4 vertices, 6 edges, and 4 faces),
#! | v2, E9, v7, E10, v4 | ]
#! gap> IsClosedSurface(joined[1]);
#! true
#! gap> IsIsomorphic(joined[1],JoinBoundary(fourGon,3)[1]);
#! true
#! @EndExampleSession
#!
#! @Returns a pair, where the first entry is a polygonal complex and the second entry 
#! is a vertex-edge-path.
#! @Arguments complex, vertex
DeclareOperation( "JoinBoundary", [IsPolygonalComplex, IsInt] );
#! @Arguments complex, vertex
DeclareOperation( "JoinBoundaryNC", [IsPolygonalComplex, IsInt] );
#! @EndGroup


#! @Section Specific modifications
#! @SectionLabel Modification_Applications
#! 
#! This section contains some specific modifications that are generally 
#! useful. To illustrate the power of the modification toolbox that was
#! developed in the previous sections, the fundamental code for each
#! of them is presented as well. To make seeing the underlying structure
#! easier, this code will not consider border cases or check its inputs
#! for validity.
#!
#! 

#! @BeginGroup ConnectedFaceSum
#! @Description
#! Compute the <E>connected face-sum</E> of two polygonal surfaces.
#! The connected face-sum identifies the faces of two polygonal surfaces
#! and removes them afterwards. The edges of the identified faces can't
#! be boundary edges (<Ref Subsect="BoundaryEdges"/>), otherwise <K>fail</K>
#! is returned.
#!
#! Since there are six different ways how the two faces could be identified,
#! this methods needs a flag of each complex, i.e. a list of a vertex, an edge
#! and a face that are all incident.
#!
#! For example consider the tetrahedron:
#! @BeginExampleSession
#! gap> doubleTetra:=ConnectedFaceSum(Tetrahedron(),[1,1,1],Tetrahedron(),[1,1,1]);
#! simplicial surface (5 vertices, 9 edges, and 6 faces)
#! gap> IsClosedSurface(doubleTetra);
#! true
#! gap> NumberOfConnectedComponents(doubleTetra);
#! 1
#! @EndExampleSession
#!
#! The central part of this can be implemented like this:
#! @BeginLogSession
#! gap> rem1 := RemoveFace( surface1, flag1[3] );
#! gap> rem2 := RemoveFace( surface2, flag2[3] );
#! gap> conSum := JoinBoundaries(rem1, flag1{[1,2]}, rem2, flag2{[1,2]})[1];
#! @EndLogSession
#!
#! @Returns a polygonal surface or <K>fail</K>
#! @Arguments surface1, flag1, surface2, flag2
DeclareOperation( "ConnectedFaceSum", [IsPolygonalComplex, IsList, IsPolygonalComplex, IsList] );
#! @EndGroup
#TODO can this be implemented more generally?


#! @Description
#! Remove all "ears" of the given simplicial surface, i.e. all pairs of faces
#! that share two edges. The resulting edge anomaly is also fixed by
#! identifying the edges.
#!
#! For example consider the following complex:
#! <Alt Only="TikZ">
#!   {
#!     \def\withEar{1}
#!     \input{Image_ComplexWithEar.tex}
#!   }
#! </Alt>
#! @BeginExampleSession
#! gap> complex:=SimplicialSurfaceByDownwardIncidence(
#! >             [[1,2],[2,3],[1,3],[1,3],[3,4],[1,4],[4,5],[1,5],[3,5]],
#! >             [[1,2,3],[1,2,4],[3,5,6],[6,7,8],[4,8,9]]);;
#! @EndExampleSession
#! Face 1 and 2 share two edges, that means, they form an ear of the given simplicial surface.
#! @BeginExampleSession
#! gap> complexWithoutEars:=SnippOffEars(complex);
#! simplicial surface (4 vertices, 6 edges, and 3 faces)
#! gap> EdgesOfFaces(complexWithoutEars);
#! [ ,, [ 5, 6, 10 ], [ 6, 7, 8 ], [ 8, 9, 10 ] ]
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   {
#!     \input{Image_ComplexWithEar.tex}
#!   }
#! </Alt>
#!
#! For a given face-anomaly [<A>face1</A>, <A>face2</A>] this could be
#! implemented like this:
#! @BeginLogSession
#! gap> commonEdges := Intersection( 
#! >          EdgesOfFace(surface,face1), EdgesOfFace(surface,face2) );
#! gap> edge1 := Difference( EdgesOfFace(surface,face1), commonEdges )[1];
#! gap> edge2 := Difference( EdgesOfFace(surface,face2), commonEdges )[1];
#! gap> rem := RemoveFaces(surface, [face1, face2]);
#! gap> snipp := JoinEdges(rem, edge1, edge2)[1];
#! @EndLogSession
#!
#! @Returns a simplicial surface
#! @Arguments surface
DeclareOperation( "SnippOffEars", [IsSimplicialSurface] );


#! @Description
#! Split all vertices of the given polygonal complex via <K>SplitVertex</K>
#! (<Ref Subsect="SplitVertex"/>). For polygonal complexes without edge 
#! ramifications
#! (<Ref Sect="IsNotEdgeRamified"/>) this is equivalent to
#! splitting all ramified vertices (<Ref Subsect="RamifiedVertices"/>). In
#! this case a polygonal surface will be returned.
#!
#! For example consider the following complex:
#! @BeginExampleSession
#! gap> triforce := PolygonalComplexByVerticesInFaces([[1,2,3],[2,4,5],[3,5,6]]);;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_Triforce.tex}
#!  \end{tikzpicture}
#! </Alt>
#! 
#! @BeginExampleSession
#! gap> vertSplit:=SplitAllVertices(triforce);
#! simplicial surface (9 vertices, 9 edges, and 3 faces)
#! gap> NumberOfConnectedComponents(vertSplit);
#! 3
#! @EndExampleSession
#! After splitting all ramified vertices the complex is the disjoint union of three one-faces.
#!
#! @Returns a polygonal complex
#! @Arguments complex
DeclareOperation("SplitAllVertices", [IsPolygonalComplex]);

#! @BeginGroup TetrahedralExtension
#! @Description
#! Given a simplicial surface a new surface can be constructed by attaching a
#! tetrahedron on the given face. This can be seen as a subdivision of the 
#! given surface which arises by subdividing a face into three
#! new faces.
#! <Alt Only="TikZ">
#!      \input{Image_TetraExt.tex}
#! </Alt>
#! So, this modification results in increasing the number of
#! vertices by 1, the number of edges by 3 and the number of faces by 2.
#! As an example consider the tetrahedron:
#!
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!      \input{Image_Tetrahedron_Net.tex}
#!   \end{tikzpicture}
#! </Alt>
#!
#! Subdividing face 1 of the tetrahedron results in the double tetrahedron:
#! @BeginExampleSession
#! gap> s:=TetrahedralExtension(Tetrahedron(),1);
#! simplicial surface (5 vertices, 9 edges, and 6 faces)
#! gap> Faces(s);
#! [ 2, 3, 4, 5, 6, 7 ]
#! @EndExampleSession
#!
#! <Alt Only="TikZ">
#!      \input{Image_TetrahedralExtension.tex}
#! </Alt>
#! @Returns a surface
#! @Arguments surface, face
DeclareOperation( "TetrahedralExtension", [IsSimplicialSurface, IsPosInt] );
#! @EndGroup

#! @BeginGroup TetrahedralReduction
#! @Description
#! Given a simplicial surface and a vertex of face degree 3 a new surface can
#! be constructed by removing the faces incident to <K>vertex</K> in
#! <K>surface</K> and attaching a new face to the resulting boundary edges.
#! <Alt Only="TikZ">
#!      \input{Image_TetraRed.tex}
#! </Alt>
#! So, this modification results in decreasing the number of vertices by 1, the 
#! number of edges by 3 and the number of faces by 2. As an Example consider
#! the double tetrahedron.
#! <Alt Only="TikZ">
#!      \input{Image_DoubleTetrahedron.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> vof:=[[1,2,4],[2,3,4],[1,3,4],[1,2,5],[1,3,5],[2,3,5]];;
#! gap> doubleTetra:=SimplicialSurfaceByVerticesInFaces(vof);
#! simplicial surface (5 vertices, 9 edges, and 6 faces)
#! gap> tet:=TetrahedralReduction(doubleTetra,4);
#! simplicial surface (4 vertices, 6 edges, and 4 faces)
#! gap> IsIsomorphic(tet,Tetrahedron());
#! true
#! @EndExampleSession

#! So performing the tetrahedral reduction with the double tetrahedron gives rise
#! to the tetrahedron.
#! @Returns a surface
#! @Arguments surface,vertex 
DeclareOperation( "TetrahedralReduction", [IsSimplicialSurface,IsPosInt] );
#! @EndGroup

#! @BeginGroup InnerMultiTetrahedralSphere
#! @Description
#! Return the inner multi tetrahedral sphere of a given twisted polygonal
#! complex. If <K>complex</K> is a multi tetrahedral sphere, a new multi
#! tetrahedral sphere can be obtained by applying a tetrahedral reduction
#! to every vertex in <K>complex</K> with face degree 3. If <K>complex</K>
#! is not a multi tetrahedral sphere, the function returns <K>fail</K>.
#!
#! As an example, consider the multi tetrahedral sphere obtained by applying 
#! exactly two tetrahdral extensions to the tetrahedron with any two faces.
#! Since this surface has exactly two vertices with face degree 3, removing 
#! the attached tetrahedron gives rise to the tetrahedron.
#! @BeginExampleSession
#! gap> doubleTetra:=TetrahedralExtension(Tetrahedron(),1);
#! simplicial surface (5 vertices, 9 edges, and 6 faces)
#! gap> multiTetra:=TetrahedralExtension(doubleTetra,2);
#! simplicial surface (6 vertices, 12 edges, and 8 faces)
#! gap> tetra:=InnerMultiTetrahedralSphere(multiTetra);
#! simplicial surface (4 vertices, 6 edges, and 4 faces)
#! gap> IsIsomorphic(tetra,Tetrahedron());
#! true
#! @EndExampleSession
#! @Returns a complex
#! @Arguments complex 
DeclareOperation( "InnerMultiTetrahedralSphere", [IsTwistedPolygonalComplex] );
## ! @EndGroup 

#! @BeginGroup MultiTetrahedralSphereByTetrahedralSymbol
#! @Description
#! Returns a multi tetrahedral sphere with the given multi tetrahedral symbol.
#! As examples, consider the following two multi tetrahedral symbols.
#! @BeginExampleSession
#! gap> tetra:=MultiTetrahedralSphereByTetrahedralSymbol([]);
#! simplicial surface (4 vertices, 6 edges, and 4 faces)
#! gap> VertexCounter(tetra);
#! [ [ 3, 4 ] ]
#! gap> doubleTet:=MultiTetrahedralSphereByTetrahedralSymbol([[1,1]]);
#! simplicial surface (5 vertices, 9 edges, and 6 faces)
#! gap> VertexCounter(doubleTet);
#! [ [ 3, 2 ], [ 4, 3 ] ]
#! @EndExampleSession
#! @Returns a simplicial surface
#! @Arguments symbol
DeclareOperation( "MultiTetrahedralSphereByTetrahedralSymbol", [IsDenseList] );
#! @EndGroup

#! @BeginGroup EdgeTurn
#! @Description
#! Given a simplicial surface and an inner edge contained in the surface, one
#! can construct a new surface by manipulating the inner edge. If <K>edge</K>
#! is an inner edge, it gives rise to a butterfly (e.g. if the surface is
#! vertex faithful) and thus a new surface can be created by turning
#! <K>edge</K>. This results in replacing <K>edge</K> by the edge
#! <K>newedge</K> which is connecting the other two vertices of the butterfly.
#! So it has the same number of faces, edges and vertices, but the vertex
#! degrees in four positions will change by +-1 i.e. the vertex degrees of
#! the vertices incident to <K>edge</K> decrease and the degrees of the
#! vertices incident to <K>newedge</K> increase by 1. 
#! If the function is called without the argument <K>newedge</K>, the
#! function simply manipulates the incidence structure of <K>edge</K> 
#! without relabelling this edge. So after this modification on the simplicial
#! surface <K>surface</K> the set of edges remains the same.
#! For example, consider the octahedron:
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Octahedron_constructor.tex}
#! </Alt>
#! Turning the edge 1 results in
#! @BeginExampleSession
#! gap> surf:=EdgeTurn(Octahedron(),1);
#! simplicial surface (6 vertices, 12 edges, and 8 faces)
#! gap> VerticesOfEdges(surf);
#! [ [ 3, 5 ], [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 2, 3 ], [ 2, 5 ], [ 2, 6 ], [ 3, 4 ],
#! [ 3, 6 ], [ 4, 5 ], [ 4, 6 ], [ 5, 6 ] ]
#! gap> EdgesOfFaces(surf);
#! [ [ 1, 2, 4 ], [ 6, 7, 12 ], [ 1, 5, 6 ], [ 5, 7, 9 ], [ 3, 4, 10 ], [ 8, 9, 11 ],
#! [ 2, 3, 8 ], [ 10, 11, 12 ] ]
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \input{Image_ETOctahedron.tex}
#! </Alt>
#!
#! The same process can also be done by relabelling the turned edge.
#! @BeginExampleSession
#! gap> EdgeTurn(Octahedron(),1,15);
#! simplicial surface (6 vertices, 12 edges, and 8 faces)
#! gap> Edges(last);
#! [ 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 15 ]
#! @EndExampleSession

#! @Returns a simplicial surface or <K>fail</K>
#! @Arguments surface,edge [,newedge]
DeclareOperation( "EdgeTurn", [IsSimplicialSurface, IsPosInt,IsPosInt] );
#! @EndGroup

#! @BeginGroup BuildingBlocks
#! @Description
#! Return the building blocks of a vertex-faithful simplicial sphere.

#! Given two closed simplicial surfaces with euler-characteristic 2 a new surface
#! can be constructed by computing the connected-face sum 
#! (<Ref Subsect="ConnectedFaceSum"/>) of this surfaces.
#! This gives rise to a waist of length 3 in the resulting surface.
 
#! Given a vertex-faithful simplicial sphere there exists a finite number of 
#! simplicial spheres without waists of length 3, so that iteratively computing the 
#! connected-face-sum of those surfaces gives rise to <K>surface</K>, up to 
#! isomorphism. This surfaces which are unique up to isomorphism are called the 
#! building blocks of the simplicial sphere <K>surface</K>. 
#! Since building blocks only exist for vertex-faithful spheres the function returns
#! <K>fail</K>, if <K>surface</K> does not satisfy this property. 
#! As an example, consider the octahedron.
#! @BeginExampleSession
#! gap> BuildingBlocks(Octahedron());
#! [ simplicial surface (6 vertices, 12 edges, and 8 faces)]
#! @EndExampleSession
#!
#! As another example consider the double tetrahedron.
#! Applying the connected sum to two tetrahedron with any two faces 
#! gives rise to the double tetrahedron. So the double tetrahedron
#! has two building blocks, namely two tetrahedron.
#! @BeginExampleSession
#! gap> vof:=[[1,2,4],[2,3,4],[1,3,4],[1,2,5],[1,3,5],[2,3,5]];;
#! gap> doubleTetra:=SimplicialSurfaceByVerticesInFaces(vof);
#! simplicial surface (5 vertices, 9 edges, and 6 faces)
#! gap> buildingBlocks:=BuildingBlocks(doubleTetra);
#! [ simplicial surface (4 vertices, 6 edges, and 4 faces)
#!     , 
#!   simplicial surface (4 vertices, 6 edges, and 4 faces) 
#!  ]
#! gap> List(buildingBlocks,g->IsIsomorphic(g,Tetrahedron()));
#! [ true, true ]
#! @EndExampleSession
#! @Returns a set of simplicial surfaces
#! @Arguments surface
DeclareAttribute( "BuildingBlocks", IsSimplicialSurface);
#! @EndGroup

#TODO maybe move into chapter ExampleApplications?
#! @Section Example: Cut and Mend
#! @SectionLabel Modification_CutMend
#!
#! While the previous sections talked about general modifications and some
#! often-used modifications, this section shows how these tools could be used
#! in practice. After introducing some modifications of theoretical value it
#! is shown how they could be implemented with the help from the package.
#! 
#! Specifically this concerns the following operations (for polygonal surfaces):
#! <Enum>
#!   <Item><K>CraterCut</K> (<Ref Subsect="CraterCut"/>): For an inner edge 
#!      (<Ref Subsect="InnerEdges"/>) 
#!      with two
#!      incident inner vertices (<Ref Subsect="InnerVertices"/>), split the
#!      edge in two (while leaving the vertices intact).
#!
#!      The inverse operation is the <K>CraterMend</K>
#!      (<Ref Subsect="CraterMend"/>).</Item>
#!   <Item><K>RipCut</K> (<Ref Subsect="RipCut"/>): For an inner edge 
#!      (<Ref Subsect="InnerEdges"/>), 
#!      where one of the incident vertices is an inner vertex 
#!      (<Ref Subsect="InnerVertices"/>) and one is a boundary vertex
#!      (<Ref Subsect="BoundaryVertices"/>), split the edge and the boundary
#!      vertex.
#!
#!      The inverse operation is the <K>RipMend</K>
#!      (<Ref Subsect="RipMend"/>).</Item>
#!   <Item><K>SplitCut</K> (<Ref Subsect="SplitCut"/>): For an inner edge 
#!      with two incident boundary
#!      vertices (<Ref Subsect="BoundaryVertices"/>), split the edge and
#!      both incident vertices in two.
#!
#!      The inverse operation is the <K>SplitMend</K>
#!      (<Ref Subsect="SplitMend"/>).</Item>
#! </Enum>
#!
#! Besides the actual modification it is also important to have some function
#! available that checks if the conditions are fulfilled.
#!
#! Each of these six operations has their own manual entry with a code 
#! snippet. These code snippets could be put into a file <E>CutMend.g</E>
#! and read into an active &GAP;-session by 
#! @BeginLogSession
#! gap> Read("CutMend.g");
#! @EndLogSession
#! While this is not necessary for the concrete methods in this section, this
#! would be the method of choice for used-defined modifications.

#! @BeginGroup CraterCut
#! @Description
#! Every inner edge (<Ref Subsect="InnerEdges"/>) whose incident vertices are
#! both inner vertices (<Ref Subsect="InnerVertices"/>) can be split into
#! two boundary edges by a
#! <K>CraterCut</K>. The attribute 
#! <K>CraterCuttableEdges</K>(<A>complex</A>) returns the set of all 
#! edges that fulfill these conditions.
#!
#! For example, consider the Janus-head:
#! <Alt Only="TikZ">
#!    \input{_TIKZ_Janus_constructor.tex}
#! </Alt>
#! Applying a crater cut to the Janus-head yields the open bag:
#! @BeginExampleSession
#! gap> CraterCuttableEdges(JanusHead());
#! [ 1, 2, 3 ]
#! gap> janusCrater:=CraterCut(JanusHead(),3);
#! simplicial surface (3 vertices, 4 edges, and 2 faces)
#! gap> openBag := SimplicialSurfaceByDownwardIncidence(
#! > [[1,2],[1,3],[2,3],[2,3]], [[1,2,4],[1,2,3]]);;
#! gap> IsIsomorphic(openBag,janusCrater);
#! true
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_OpenBag.tex}
#!   \end{tikzpicture}
#! </Alt>
#!
#! This could be implemented like this:
#! @BeginExampleSession
#! gap> CraterCuttableEdges_custom := function(complex)
#! >      return EdgesWithVertexProperty(complex, v -> IsInnerVertexNC(complex, v));
#! >    end;
#! function( complex ) ... end
#! gap> CraterCut_custom := function(complex, edge)
#! >       if not edge in CraterCuttableEdges_custom(complex) then
#! >         Error("Given edge has to be crater-cuttable");
#! >       fi;
#! >       
#! >       return SplitEdge(complex, edge)[1];
#! >    end;
#! function( complex, edge ) ... end
#! @EndExampleSession
#!
#! @Returns a polygonal complex
#! @Arguments complex, edge
DeclareOperation( "CraterCut", [IsPolygonalComplex, IsPosInt] );
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "CraterCuttableEdges", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup CraterMend
#! @Description
#! Every pair of boundary edges (<Ref Subsect="BoundaryEdges"/>) with the
#! same incident vertices, that also are boundary vertices 
#! (<Ref Subsect="BoundaryVertices"/>), can be joined into one inner edge
#! by a <K>CraterMend</K>. The attribute 
#! <K>CraterMendableEdgePairs</K>(<A>complex</A>) returns the set of all
#! edge pairs that fulfill these conditions.
#!
#! For example, consider the open bag:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_OpenBag.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> openBag := SimplicialSurfaceByDownwardIncidence(
#! > [[1,2],[1,3],[2,3],[2,3]], [[1,2,4],[1,2,3]]);;
#! @EndExampleSession
#! Applying a crater mend to the open bag yields to the Janus-head:
#! @BeginExampleSession
#! gap> CraterMendableEdgePairs(openBag);
#! [ [ 3, 4 ] ]
#! gap> CraterMend(openBag,[3,4]);
#! simplicial surface (3 vertices, 3 edges, and 2 faces)
#! gap> IsIsomorphic(last,JanusHead());
#! true
#! @EndExampleSession
#! <Alt Only="TikZ">
#!    \input{_TIKZ_Janus_constructor.tex}
#! </Alt>
#!
#! This could be implemented like this:
#! @BeginExampleSession
#! gap> CraterMendableEdgePairs_custom := function(complex)
#! >        local edgeAnom, edgePairs;
#! > 
#! >        edgeAnom := List( EdgeAnomalyClasses(complex), 
#! >             cl -> Filtered( cl, 
#! >                   e -> IsBoundaryEdgeNC(complex, e) ) );
#! > 	    edgePairs:=List(edgeAnom,cl->Combinations(cl, 2) );
#! >        return Union(edgePairs);
#! >    end;
#! function( complex ) ... end
#! gap> CraterMend_custom := function(complex, edgePair)
#! >        if not Set(edgePair) in CraterMendableEdgePairs_custom(complex) then
#! >            Error("Given edge-pair has to be crater-mendable.");
#! >        fi;
#! >        return JoinEdgesNC(complex, edgePair)[1];
#! >    end;
#! function( complex, edgePair ) ... end
#! @EndExampleSession
#!
#! @Returns a polygonal complex
#! @Arguments complex, edgePair
DeclareOperation( "CraterMend", [IsPolygonalComplex, IsList] );
#! @Returns a set of edge pairs
#! @Arguments complex
DeclareAttribute( "CraterMendableEdgePairs", IsPolygonalComplex );
#! @EndGroup


#! @BeginGroup RipCut
#! @Description
#! For every inner edge (<Ref Subsect="InnerEdges"/>) where one incident vertex
#! is an inner vertex (<Ref Subsect="InnerVertices"/>) and one is a boundary
#! vertex (<Ref Subsect="BoundaryVertices"/>) a <E>rip cut</E> can be 
#! performed. In doing so, the edge and the boundary vertex are split in two.
#! The attribute <K>RipCuttableEdges</K>(<A>complex</A>) returns a set of all
#! edges with these properties.
#!
#! For example, consider the open bag:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_OpenBag.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> openBag := SimplicialSurfaceByDownwardIncidence(
#! > [[1,2],[1,3],[2,3],[2,3]], [[1,2,4],[1,2,3]]);;
#! @EndExampleSession
#! Applying a rip cut to the open bag yields the butterfly:
#! @BeginExampleSession
#! gap> RipCuttableEdges(openBag);
#! [ 1, 2 ]
#! gap> openBagRip:=RipCut(openBag,1);
#! simplicial surface (4 vertices, 5 edges, and 2 faces)
#! gap> butterfly:=SimplicialSurfaceByUmbrellaDescriptor([[1],[2],[1,2],[1,2]]);
#! simplicial surface (4 vertices, 5 edges, and 2 faces)
#! gap> IsIsomorphic(openBagRip,butterfly);
#! true
#! @EndExampleSession
#! <Alt Only="TikZ">
#!	\input{Image_Butterfly.tex}
#! </Alt>
#!
#! This could be implemented like this:
#! @BeginExampleSession
#! gap> RipCuttableEdges_custom := function(complex)
#! >        return EdgesWithVertexProperties(complex,
#! >              v->IsInnerVertexNC(complex,v), v->IsBoundaryVertexNC(complex,v));
#! >    end;
#! function( complex ) ... end
#! gap> RipCut_custom := function(complex, edge)
#! >        if not edge in RipCuttableEdges_custom(complex) then
#! >            Error("Given edge has to be rip-cuttable.");
#! >        fi;
#! >        return SplitVertexEdgePathNC(complex, 
#! >              VertexEdgePathByEdgesNC(complex, [edge]))[1];
#! >    end;
#! function( complex, edge ) ... end
#! @EndExampleSession
#! 
#! @Returns a polygonal complex
#! @Arguments complex, edge
DeclareOperation( "RipCut", [IsPolygonalComplex, IsPosInt] );
#! @Returns a set of edges
#! @Arguments complex
DeclareAttribute( "RipCuttableEdges", IsPolygonalComplex );
#! @EndGroup


#! @BeginGroup RipMend
#! @Description
#! Every pair of boundary edges (<Ref Subsect="BoundaryEdges"/>) that has
#! exactly one boundary vertex (<Ref Subsect="BoundaryVertices"/>) and no
#! other vertex in common, can be joined by a <K>RipMend</K>. The 
#! attribute <K>RipMendableEdgePairs</K>(<A>complex</A>) returns the set of
#! all edge pairs that fulfill these conditions.
#!
#! If the joined vertices are connected by an edge, the mend can not be
#! performed and <K>fail</K> will be returned.
#!
#! For example, consider the butterfly:
#! <Alt Only="TikZ">
#!       \input{Image_Butterfly.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> butterfly:=SimplicialSurfaceByUmbrellaDescriptor([[1],[2],[1,2],[1,2]]);
#! simplicial surface (4 vertices, 5 edges, and 2 faces)
#! @EndExampleSession
#! Applying a rip mend to the butterfly yields to the open bag:
#! @BeginExampleSession
#! gap> openBag := SimplicialSurfaceByDownwardIncidence(
#! > [[1,2],[1,3],[2,3],[2,3]], [[1,2,4],[1,2,3]]);;
#! gap> RipMendableEdgePairs(butterfly);
#! [ [ 1, 2 ], [ 1, 4 ], [ 2, 5 ], [ 4, 5 ] ]
#! gap> RipMend(butterfly,[1,2]);
#! simplicial surface (3 vertices, 4 edges, and 2 faces)
#! gap> IsIsomorphic(last,openBag);
#! true
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_OpenBag.tex}
#!   \end{tikzpicture}
#! </Alt>
#!
#! This could be implemented like this:
#! @BeginExampleSession
#! gap> RipMendableEdgePairs_custom := function(complex)
#! >        local pairs, v, boundEdges, edgePairs;
#! >    
#! >        pairs := [];
#! >        for v in BoundaryVertices(complex) do
#! >            boundEdges := Filtered( EdgesOfVertices(complex)[v], 
#! >                e -> IsBoundaryEdgeNC(complex, e) );
#! >            edgePairs := Combinations(boundEdges, 2);
#! >            Append(pairs, Filtered(edgePairs, p -> 
#! >                OtherVertexOfEdgeNC(complex,v,p[1]) <> 
#! >                OtherVertexOfEdgeNC(complex,v,p[2])));
#! >        od;
#! >    
#! >        return Set(pairs);
#! >    end;
#! function( complex ) ... end
#! gap> RipMend_custom := function(complex, edgePair)
#! >        local commonVertex, path1, path2, join;
#! > 
#! >        if not edgePair in RipMendableEdgePairs(complex) then
#! >            Error("Given edge-pair has to be rip-mendable.");
#! >        fi;
#! >        commonVertex := Intersection( 
#! >            VerticesOfEdge(complex, edgePair[1]), 
#! >            VerticesOfEdge(complex, edgePair[2]) )[1];
#! >        path1 := VertexEdgePathNC(complex, [commonVertex, edgePair[1], 
#! >                OtherVertexOfEdgeNC(complex, commonVertex, edgePair[1])]);
#! >        path2 := VertexEdgePathNC(complex, [commonVertex, edgePair[2], 
#! >                OtherVertexOfEdgeNC(complex, commonVertex, edgePair[2])]);
#! >        join := JoinVertexEdgePathsNC(complex, path1, path2);
#! >        if join = fail then
#! >            return fail;
#! >        else
#! >            return join[1];
#! >        fi;
#! >    end;
#! function( complex, edgePair ) ... end
#! @EndExampleSession
#!
#! @Returns a polygonal complex or <K>fail</K>
#! @Arguments complex, edgePair
DeclareOperation( "RipMend", [IsPolygonalComplex, IsList] );
#! @Returns a set of edge pairs
#! @Arguments complex
DeclareAttribute( "RipMendableEdgePairs", IsPolygonalComplex );
#! @EndGroup


#! @BeginGroup SplitCut
#! @Description
#! Any inner edge (<Ref Subsect="InnerEdges"/>) with two incident
#! boundary vertices (<Ref Subsect="InnerVertices"/>) can be splitted
#! into two boundary edges by a <K>SplitCut</K>. The attribute
#! <K>SplitCuttableEdges</K>(<A>complex</A>) returns the set of all edges
#! satisfying this property.
#!
#! For example, consider the butterfly:
#! <Alt Only="TikZ">
#!        \input{Image_Butterfly.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> butterfly:=SimplicialSurfaceByUmbrellaDescriptor([[1],[2],[1,2],[1,2]]);
#! simplicial surface (4 vertices, 5 edges, and 2 faces)
#! @EndExampleSession
#! Applying a split cut to the butterfly yields to a disjoint union of two one-faces:
#! @BeginExampleSession
#! gap> SplitCuttableEdges(butterfly);
#! [ 3 ]
#! gap> butterflySplit:=SplitCut(butterfly,3);
#! simplicial surface (6 vertices, 6 edges, and 2 faces)
#! gap> oneFace:=SimplicialSurfaceByUmbrellaDescriptor([[1],[1],[1]]);
#! simplicial surface (3 vertices, 3 edges, and 1 faces)
#! gap> twoOneFaces:=DisjointUnion(oneFace,oneFace)[1];
#! simplicial surface (6 vertices, 6 edges, and 2 faces)
#! gap> IsIsomorphic(butterflySplit,twoOneFaces);
#! true
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \input{Image_TwoDisjointOneFaces.tex}
#! </Alt>
#!
#! This could be implemented like this:
#! @BeginExampleSession
#! gap> SplitCuttableEdges_custom := function(complex)
#! >         return Intersection(InnerEdges(complex), 
#! >               EdgesWithVertexProperty(complex, 
#! >                     v -> IsBoundaryVertexNC(complex, v)));
#! >    end;
#! function( complex ) ... end
#! gap> SplitCut_custom := function(complex, edge)
#! >        if not edge in SplitCuttableEdges_custom(complex) then
#! >            Error("Given edge has to be split-cuttable.");
#! >        fi;
#! >        return SplitVertexEdgePathNC(complex, 
#! >              VertexEdgePathByEdgesNC(complex, [edge]))[1];
#! >    end;
#! function( complex, edge ) ... end
#! @EndExampleSession
#! 
#! @Returns a polygonal complex
#! @Arguments complex, edge
DeclareOperation( "SplitCut", [IsPolygonalComplex, IsPosInt] );
#! @Returns a set of edges
#! @Arguments complex
DeclareAttribute( "SplitCuttableEdges", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup SplitMend
#! @Description
#! Two boundary edges (<Ref Subsect="BoundaryEdges"/>) with no shared
#! vertices can be joined by <K>SplitMend</K>. For this operation to
#! be well-defined two vertices of these edges that should be combined 
#! have to be
#! given as well. The attribute 
#! <K>SplitMendableFlagPairs</K>(<A>complex</A>) returns the set of
#! all pairs of vertex-edge-flags (<Ref Subsect="VertexEdgeFlags"/>)
#! that fulfill the above conditions.
#!
#! If two given flags can't be joined (because two vertices that should
#! be joined are connected by an edge), <K>fail</K> is returned.
#!
#! For example, consider the disjoint union of two one-faces:
#! <Alt Only="TikZ">
#!   \input{Image_TwoDisjointOneFaces.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> twoOneFaces:=DisjointUnion(oneFace,oneFace)[1];
#! simplicial surface (6 vertices, 6 edges, and 2 faces)
#! @EndExampleSession
#! Applying a split mend to the disjoint union of two one-faces yields to the butterfly:
#! @BeginExampleSession
#! gap> butterfly:=SimplicialSurfaceByUmbrellaDescriptor([[1],[2],[1,2],[1,2]]);
#! simplicial surface (4 vertices, 5 edges, and 2 faces)
#! gap> SplitMendableFlagPairs(twoOneFaces);
#! [ [ [ 1, 1 ], [ 4, 4 ] ], [ [ 1, 1 ], [ 4, 5 ] ], [ [ 1, 1 ], [ 5, 5 ] ], 
#!   [ [ 1, 1 ], [ 5, 6 ] ], [ [ 1, 1 ], [ 6, 4 ] ], [ [ 1, 1 ], [ 6, 6 ] ],
#!   [ [ 1, 2 ], [ 4, 4 ] ], [ [ 1, 2 ], [ 4, 5 ] ], [ [ 1, 2 ], [ 5, 5 ] ], 
#!   [ [ 1, 2 ], [ 5, 6 ] ], [ [ 1, 2 ], [ 6, 4 ] ], [ [ 1, 2 ], [ 6, 6 ] ], 
#!   [ [ 2, 2 ], [ 4, 4 ] ], [ [ 2, 2 ], [ 4, 5 ] ], [ [ 2, 2 ], [ 5, 5 ] ],
#!   [ [ 2, 2 ], [ 5, 6 ] ], [ [ 2, 2 ], [ 6, 4 ] ], [ [ 2, 2 ], [ 6, 6 ] ], 
#!   [ [ 2, 3 ], [ 4, 4 ] ], [ [ 2, 3 ], [ 4, 5 ] ], [ [ 2, 3 ], [ 5, 5 ] ],
#!   [ [ 2, 3 ], [ 5, 6 ] ], [ [ 2, 3 ], [ 6, 4 ] ], [ [ 2, 3 ], [ 6, 6 ] ],
#!   [ [ 3, 1 ], [ 4, 4 ] ], [ [ 3, 1 ], [ 4, 5 ] ], [ [ 3, 1 ], [ 5, 5 ] ],
#!   [ [ 3, 1 ], [ 5, 6 ] ], [ [ 3, 1 ], [ 6, 4 ] ], [ [ 3, 1 ], [ 6, 6 ] ],
#!   [ [ 3, 3 ], [ 4, 4 ] ], [ [ 3, 3 ], [ 4, 5 ] ], [ [ 3, 3 ], [ 5, 5 ] ],
#!   [ [ 3, 3 ], [ 5, 6 ] ], [ [ 3, 3 ], [ 6, 4 ] ], [ [ 3, 3 ], [ 6, 6 ] ] ]
#! gap> SplitMend(twoOneFaces,[[1,1],[4,4]]);
#! simplicial surface (4 vertices, 5 edges, and 2 faces)
#! gap> IsIsomorphic(last,butterfly);
#! true
#! @EndExampleSession
#! <Alt Only="TikZ">
#!        \input{Image_Butterfly.tex}
#! </Alt>
#!
#! This could be implemented like this:
#! @BeginExampleSession
#! gap> SplitMendableFlagPairs_custom := function( complex )
#! >        local boundPairs, flagPairs, verts1, verts2, pair;
#! >    
#! >        flagPairs := [];
#! >        boundPairs := Combinations( BoundaryEdges(complex), 2 );
#! >        for pair in boundPairs do
#! >            verts1 := VerticesOfEdges(complex)[pair[1]];
#! >            verts2 := VerticesOfEdges(complex)[pair[2]];
#! >            if IsEmpty(Intersection(verts1, verts2)) then
#! >                Append( flagPairs, [ 
#! >                    Set( [ [ verts1[1], pair[1] ], [ verts2[1], pair[2] ] ] ),
#! >                    Set( [ [ verts1[1], pair[1] ], [ verts2[2], pair[2] ] ] ),
#! >                    Set( [ [ verts1[2], pair[1] ], [ verts2[1], pair[2] ] ] ),
#! >                    Set( [ [ verts1[2], pair[1] ], [ verts2[2], pair[2] ] ] )] );
#! >            fi;
#! >        od;
#! >    
#! >        return Set(flagPairs);
#! >    end;
#! function( complex ) ... end
#! gap> SplitMend_custom := function( complex, flagPair )
#! >        local path1, path2, join;
#! >    
#! >        if not flagPair in SplitMendableFlagPairs(complex) then
#! >            Error("Given flag-pair has to be split-mendable");
#! >        fi;
#! >    
#! >        path1 := VertexEdgePathNC(complex, [ flagPair[1][1], flagPair[1][2],
#! >            OtherVertexOfEdgeNC(complex, flagPair[1][1], flagPair[1][2])]);
#! >        path2 := VertexEdgePathNC(complex, [ flagPair[2][1], flagPair[2][2],
#! >            OtherVertexOfEdgeNC(complex, flagPair[2][1], flagPair[2][2])]);
#! >        join := JoinVertexEdgePathsNC(complex, path1, path2);
#! >        if join = fail then
#! >            return fail;
#! >        else
#! >            return join[1];
#! >        fi;
#! >    end;
#! function( complex, flagPair ) ... end
#! @EndExampleSession
#!
#! @Returns a polygonal complex or <K>fail</K>
#! @Arguments complex, flagPair
DeclareOperation( "SplitMend", [IsPolygonalComplex, IsList] );
#! @Returns a set of vertex-edge-flag pairs
#! @Arguments complex
DeclareAttribute( "SplitMendableFlagPairs", IsPolygonalComplex );
#! @EndGroup


# These do not fit the above pattern:
# CommonCover       -> does not fit here at all -> chapter Coverings (or only as a section in chapter "Associated Complexes" that also includes DualSurface?)
# AddVertexIntoEdge (and the rest of Jesse's stuf) -> subdivision section?


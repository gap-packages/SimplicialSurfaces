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

#! @Chapter Constructing simplicial surfaces by umbrella descriptors 
#! @ChapterLabel UmbrellaDescriptors
#!
#! In chapter <Ref Chap="Constructors"/>  we introduced general constructors
#! for polygonal complexes. Here we consider a particular constructor for
#! simplicial surfaces for which we know the umbrellas of its vertices.
#! 
#! This chapter deals with the construction of simplicial surfaces.

#######

#! @Section UmbrellaDescriptor 
#! @SectionLabel UmbrellaDescriptor
#!
#!  Let <surf> be a simplicial surface. This method returns a list <umbdesc>
#!  of length equal to the number of vertices of surf. The i-th entry in the 
#!  list <umbdesc> represents the i-th vertex. If the i-th vertex is inner, 
#!  then the i-th entry in <umbdesc> is a permutation consisting of a single 
#!  cycle consisting of the faces in the umbrella path around the vertex such
#!  that adjacent faces are consecutive. If the i-th vertex is a boundary
#!  vertex, then the i-th entry in <umbdesc> is a list consisting of the 
#!  faces in the umbrella path of the vertex such that adjacent faces are 
#!  consecutive and the two faces with boundary edges are the first and the 
#!  last entry of the list.
#! @InsertChunk Documentation_UmbrellaDescriptor
#!
#! As an example consider the following net of a simplicial surface:
#! <Alt Only="TikZ">
#!      \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle, face/.default=\faceColorSecond]
#!          \input{Image_Constructor_SimplicialSurface.tex}
#!      \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> surf := Octahedron();;
#! gap> UmbrellaDescriptorOfSurface(surf);
#! [ (1,7,5,3), (1,4,2,3), (1,4,6,7), (5,8,6,7), (2,8,5,3), (2,8,6,4) ]
#! gap> surf := CraterCut(surf,1);;
#! gap> surf := RipCut(surf,2);;
#! gap> UmbrellaDescriptorOfSurface(surf);
#! [ [ 1, 4, 2, 3 ], [ 1, 4, 6, 7 ], (5,8,6,7), (2,8,5,3), (2,8,6,4), [ 1 ], 
#!  [ 3, 5, 7 ] ]
#! @EndExampleSession
#!
#! @Returns a simplicial surface  
#! @Arguments edgesOfVertices, facesOfEdges
DeclareOperation( "UmbrellaDescriptorOfSurface", [IsSimplicialSurface] );

#! @Section SimplicialSurfaceByUmbrellaDescriptor 
#! @SectionLabel Constructors_UmbrellaDescriptor
#!  <udesc> is a list as returned by the function UmbrellaDescriptorOfSurface.
DeclareOperation( "SimplicialSurfaceByUmbrellaDescriptor", [IsList] );

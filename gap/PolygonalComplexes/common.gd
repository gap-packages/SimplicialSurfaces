#! @BeginGroup CommonVerticesOfEdges
#! @Description
#! The method <K>CommonVerticesOfEdges</K>(<A>complex</A>, <A>edge1</A>, <A>edge2</A>) returns the
#! set of all vertices that are incident to <A>edge1</A> and <A>edge2</A>. The NC-version does
#! not check whether the given <A>edge1</A> and <A>edge2</A> is an edge of <A>complex</A>.
#! 
#! The method <K>CommonVerticesOfEdges</K>(<A>complex</A>, <A>edgeList</A>) returns the
#! set of all vertices that are incident to all the edges in <A>edgeList</A>. The NC-version does
#! not check whether the given edges in <A>edgeList</A> are an edge of <A>complex</A>.
#! 
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle=nolabels]
#!       \input{Image_StarOfStarExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> CommonVerticesOfEdges(complex, 8, 9);
#! [ 3 ]
#! gap> CommonVerticesOfEdges(complex, [ 8, 9 , 12]);
#! [ 3 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex, edge1, edge2
DeclareOperation( "CommonVerticesOfEdges", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, edgeList
DeclareOperation( "CommonVerticesOfEdges", [IsVEFComplex, IsList]);
#! @Arguments complex, edge1, edge2
DeclareOperation( "CommonVerticesOfEdgesNC", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, edgeList
DeclareOperation( "CommonVerticesOfEdgesNC", [IsVEFComplex, IsList]);
#! @EndGroup




#! @BeginGroup CommonEdgesOfFaces
#! @Description
#! The method <K>CommonEdgesOfFaces</K>(<A>complex</A>, <A>face1</A>, <A>face2</A>) returns the
#! set of all edges that are incident to <A>face1</A> and <A>face2</A>. The NC-version does
#! not check whether the given <A>face1</A> and <A>face2</A> is a face of <A>complex</A>.
#! 
#! The method <K>CommonEdgesOfFaces</K>(<A>complex</A>, <A>faceList</A>) returns the
#! set of all edges that are incident to all the faces in <A>faceList</A>. The NC-version does
#! not check whether the given faces in <A>faceList</A> are a face of <A>complex</A>.
#! 
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle=nolabels, edgeStyle, faceStyle]
#!       \input{Image_StarOfStarExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> CommonEdgesOfFaces(complex,[1,4]);
#! [ 9 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex, face1, face2
DeclareOperation( "CommonEdgesOfFaces", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, faceList
DeclareOperation( "CommonEdgesOfFaces", [IsVEFComplex, IsList]);
#! @Arguments complex, face1, face2
DeclareOperation( "CommonEdgesOfFacesNC", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, faceList
DeclareOperation( "CommonEdgesOfFacesNC", [IsVEFComplex, IsList]);
#! @EndGroup



#! @BeginGroup CommonVerticesOfFaces
#! @Description
#! The method <K>CommonVerticesOfFaces</K>(<A>complex</A>, <A>face1</A>, <A>face2</A>) returns the
#! set of all vertices that are incident to <A>face1</A> and <A>face2</A>. The NC-version does
#! not check whether the given <A>face1</A> and <A>face2</A> is a face of <A>complex</A>.
#! 
#! The method <K>CommonEdgesOfFaces</K>(<A>complex</A>, <A>faceList</A>) returns the
#! set of all vertices that are incident to all the faces in <A>faceList</A>. The NC-version does
#! not check whether the given faces in <A>faceList</A> are a face of <A>complex</A>.
#! 
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!       \input{Image_StarOfStarExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> CommonVerticesOfFaces(complex,1,4);
#! [ 3, 5 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex, face1, face2
DeclareOperation( "CommonVerticesOfFaces", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, faceList
DeclareOperation( "CommonVerticesOfFaces", [IsVEFComplex, IsList]);
#! @Arguments complex, face1, face2
DeclareOperation( "CommonVerticesOfFacesNC", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, faceList
DeclareOperation( "CommonVerticesOfFacesNC", [IsVEFComplex, IsList]);
#! @EndGroup




#! @BeginGroup CommonEdgesOfVertices
#! @Description
#! The method <K>CommonEdgesOfVertices</K>(<A>complex</A>, <A>vertex1</A>, <A>vertex2</A>) returns the
#! set of all edges that are incident to <A>vertex1</A> and <A>vertex2</A>. The NC-version does
#! not check whether the given <A>vertex1</A> and <A>vertex2</A> is a vertex of <A>complex</A>.
#! 
#! The method <K>CommonEdgesOfVertices</K>(<A>complex</A>, <A>vertexList</A>) returns the
#! set of all edges that are incident to all the vertices in <A>vertexList</A>. The NC-version does
#! not check whether the given vertices in <A>vertexList</A> are a vertex of <A>complex</A>.
#! 
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle=nolabels]
#!       \input{Image_StarOfStarExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> CommonEdgesOfVertices(complex,3,5);
#! [ 9 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex, vertex1, vertex2
DeclareOperation( "CommonEdgesOfVertices", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, vertexList
DeclareOperation( "CommonEdgesOfVertices", [IsVEFComplex, IsList]);
#! @Arguments complex, vertex1, vertex2
DeclareOperation( "CommonEdgesOfVerticesNC", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, vertexList
DeclareOperation( "CommonEdgesOfVerticesNC", [IsVEFComplex, IsList]);
#! @EndGroup




#! @BeginGroup CommonFacesOfEdges
#! @Description
#! The method <K>CommonFacesOfEdges</K>(<A>complex</A>, <A>edge1</A>, <A>edge2</A>) returns the
#! set of all faces that are incident to <A>edge1</A> and <A>edge2</A>. The NC-version does
#! not check whether the given <A>edge1</A> and <A>edge2</A> is an edge of <A>complex</A>.
#! 
#! The method <K>CommonFacesOfEdges</K>(<A>complex</A>, <A>edgeList</A>) returns the
#! set of all faces that are incident to all the edges in <A>edgeList</A>. The NC-version does
#! not check whether the given edges in <A>edgeList</A> are an edge of <A>complex</A>.
#! 
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle=nolabels, edgeStyle, faceStyle=]
#!       \input{Image_StarOfStarExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> CommonFacesOfEdges(complex,9,12);
#! [ 4 ]
#! gap> CommonFacesOfEdges(complex,[9,10,12,13]);
#! [ 4 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex, edge1, edge2
DeclareOperation( "CommonFacesOfEdges", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, edgeList
DeclareOperation( "CommonFacesOfEdges", [IsVEFComplex, IsList]);
#! @Arguments complex, edge1, edge2
DeclareOperation( "CommonFacesOfEdgesNC", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, edgeList
DeclareOperation( "CommonFacesOfEdgesNC", [IsVEFComplex, IsList]);
#! @EndGroup




#! @BeginGroup CommonFacesOfVertices
#! @Description
#! The method <K>CommonFacesOfVertices</K>(<A>complex</A>, <A>vertex1</A>, <A>vertex2</A>) returns the
#! set of all faces that are incident to <A>vertex1</A> and <A>vertex2</A>. The NC-version does
#! not check whether the given <A>vertex1</A> and <A>vertex2</A> is a vertex of <A>complex</A>.
#! 
#! The method <K>CommonFacesOfVertices</K>(<A>complex</A>, <A>vertexList</A>) returns the
#! set of all faces that are incident to all the vertices in <A>vertexList</A>. The NC-version does
#! not check whether the given vertices in <A>vertexList</A> are a vertex of <A>complex</A>.
#! 
#! As an example, consider the polygonal complex that was introduced at the
#! start of section <Ref Sect="Section_Access_BasicAccess"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!       \input{Image_StarOfStarExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> CommonFacesOfVertices(complex,3,5);
#! [ 1, 4 ]
#! gap> CommonFacesOfVertices(complex,[3,5,7,11]);
#! [ 4 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex, vertex1, vertex2
DeclareOperation( "CommonFacesOfVertices", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, vertexList
DeclareOperation( "CommonFacesOfVertices", [IsVEFComplex, IsList]);
#! @Arguments complex, vertex1, vertex2
DeclareOperation( "CommonFacesOfVerticesNC", [IsVEFComplex, IsPosInt, IsPosInt]);
#! @Arguments complex, vertexList
DeclareOperation( "CommonFacesOfVerticesNC", [IsVEFComplex, IsList]);
#! @EndGroup
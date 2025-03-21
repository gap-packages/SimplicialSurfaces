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

## This chapter contains many diverse aspects of polygonal complexes.
## The current order may not be optimal, depending on what the future holds

#######
## This has to be after the incidence chapter since it heavily relies on it.
## Since it consists of disconnected ideas it is no big issue if it comes
## after the constuctors-chapter that inclines the reader to skipping.
#######

#! @Chapter Properties of surfaces and complexes
#! @ChapterLabel Properties
#! 
#! In chapter <Ref Chap="Chapter_AccessIncidenceGeometry"/> we introduced the incidence structures of polygonal complexes.
#! Along with this we can consider various properties of surfaces and complexes that rely on the incidence structure.
#! In section <Ref Sect="Section_Properties_Invariants"/> some invariants of polygonal complexes are explained.
#! Section <Ref Subsect="Section_Properties_Degrees"/> describes properties based on the degree of the vertices.
#! Different types of faces, edges and vertices are introduced in section <Ref Sect="Section_Properties_FaceTypes"/>,
#! <Ref Sect="Section_Properties_EdgeTypes"/> and <Ref Sect="Section_Properties_VertexTypes"/>.
#!
#! We will showcase these properties on several examples. One of them is the
#! <E>five-star</E>:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-1-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-1.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @ExampleSession
#! gap> fiveStar := SimplicialSurfaceByVerticesInFaces( [1,2,3,5,7,11], 5,
#! >                [ [1,2,3], [1,3,5], [1,5,7], [1,7,11], [1,2,11] ] );;
#! @EndExampleSession
#!
#! Another one is the <E>triforce</E>:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-2-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-2.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @ExampleSession
#! gap> triforce := PolygonalComplexByVerticesInFaces([[1,2,3],[2,4,5],[3,5,6]]);;
#! @EndExampleSession

#! @Section Invariants
#! @SectionLabel Properties_Invariants
#!
#! This section introduces invariants of (twisted) polygonal complexes.
#! Invariants of (twisted) polygonal complexes are properties that are
#! equal for each (twisted) polygonal complex in the same isomorphism class.
#! Examples of such invariants are the Euler-characteristic <Ref Subsect="EulerCharacteristic"/>,
#! whether a complex is closed or open <Ref Subsect="IsClosedSurface"/> and
#! some other properties about multi tetrahedral spheres.

#! @BeginGroup EulerCharacteristic
#! @Description
#! Return the <E>Euler-characteristic</E> of the given twisted polygonal complex.
#! The Euler-characteristic is computed as
#! @BeginLogSession
#! gap> NumberOfVertices(complex) - NumberOfEdges(complex) + NumberOfFaces(complex);
#! @EndLogSession
#! As an example, consider the five-star that was introduced at the
#! start of chapter <Ref Chap="Chapter_Properties"/>:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-3-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-3.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @ExampleSession
#! gap> NumberOfVertices(fiveStar);
#! 6
#! gap> NumberOfEdges(fiveStar);
#! 10
#! gap> NumberOfFaces(fiveStar);
#! 5
#! gap> EulerCharacteristic(fiveStar);
#! 1
#! @EndExampleSession
#! 
#! @Returns an integer
#! @Arguments complex
DeclareAttribute( "EulerCharacteristic", IsTwistedPolygonalComplex );
#! @EndGroup


#! @BeginGroup IsClosedSurface
#! @Description
#! Check whether the given twisted polygonal complex without edge ramifications is 
#! <E>closed</E>.
#! A twisted polygonal complex without edge ramifications is closed if every edge is 
#! incident to <E>exactly</E> two
#! faces (whereas the absence of edge ramifications only means that
#! every edge is incident to <E>at most</E> two faces).
#!
#! For example, the platonic solids are closed.
#! @ExampleSession
#! gap> IsClosedSurface( Octahedron() );
#! true
#! gap> IsClosedSurface( Dodecahedron() );
#! true
#! @EndExampleSession
#! In contrast, the five-star and the triforce from the start of chapter
#! <Ref Chap="Chapter_Properties"/> are not closed.
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-4-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-4.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @ExampleSession
#! gap> IsClosedSurface(fiveStar);
#! false
#! @EndExampleSession
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-5-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-5.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @ExampleSession
#! gap> IsClosedComplex(triforce);
#! false
#! @EndExampleSession
#!
#! @Arguments complex
DeclareProperty( "IsClosedComplex", IsTwistedPolygonalComplex and IsNotEdgeRamified );
#! @Arguments surf
DeclareProperty( "IsClosedSurface", IsPolygonalSurface );
## We can't use IsClosed since this is blocked by the orb-package
#! @EndGroup

#! @BeginGroup IsMultiTetrahedralSphere
#! @Description
#! Check whether the given twisted polygonal complex is a multitetrahedral
#! sphere. A multitetrahedral sphere can be obtained by starting with the
#! tetrahedron and performing a finite number of tetrahedral extensions.
#! So multi-tetrahedral spheres are closed simplicial surfaces with
#! euler-characteristic 2. 
#! As example consider the tetrahedron and the double tetrahedron. Up to
#! isomorphism there is exactly one multi-tetrahedral sphere with 4
#! faces, namely the tetradron.
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-6-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-6.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! And there is exactly one multi-tetrahedral sphere with 6 faces namely
#! the double tetraedron which can be obtained by performing exactly one
#! tetrahedral extension to the tetradron.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_DoubleTetrahedron-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_DoubleTetrahedron.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> IsMultiTetrahedralSphere(Tetrahedron());
#! true
#! gap> vof:=[[1,2,4],[2,3,4],[1,3,4],[1,2,5],[1,3,5],[2,3,5]];;
#! gap> doubleTetra:=SimplicialSurfaceByVerticesInFaces(vof);
#! simplicial surface (5 vertices, 9 edges, and 6 faces)
#! gap> IsMultiTetrahedralSphere(doubleTetra);
#! true
#! @EndExampleSession
#!
#! As another example, consider the octahedron.
#!
#! @BeginExampleSession
#! gap> IsMultiTetrahedralSphere(Octahedron());
#! false
#! @EndExampleSession
#! @Returns true or false
#! @Arguments complex
DeclareProperty( "IsMultiTetrahedralSphere", IsTwistedPolygonalComplex );
#! @EndGroup 

#! @BeginGroup TetrahedralNumber
#! @Description
#! Return the number of tetrahedra that are used to construct the given 
#! twisted polygonal complex. If <K>complex</K> is a multi-tetrahedral sphere,
#! this number is 1 greater than the number of tetrahedral extensions that 
#! have to be applied to the tetrahedron to obtain <K>complex</K>.
#! If <K>complex</K> is not a multi-tetrahedral sphere, the function returns
#! fail.
#!
#! As example, consider the tetrahedron, the double tetrahedron and 
#! the multi-tetrahedral sphere which can be obtained by
#! applying exactly two tetrahedral extensions to the tetrahedron.  
#! @BeginExampleSession
#! gap> doubleTetra:=TetrahedralExtension(Tetrahedron(),1);
#! simplicial surface (5 vertices, 9 edges, and 6 faces)
#! gap> multiTetra:=TetrahedralExtension(doubleTetra,2);
#! simplicial surface (6 vertices, 12 edges, and 8 faces)
#! gap> TetrahedralNumber(Tetrahedron());
#! 1
#! gap> TetrahedralNumber(doubleTetra);
#! 2
#! gap> TetrahedralNumber(multiTetra);
#! 3
#! @EndExampleSession
#! @Returns positive integer or fail
#! @Arguments complex
DeclareAttribute( "TetrahedralNumber", IsTwistedPolygonalComplex );
#! @EndGroup

#! @BeginGroup TetrahedralType
#! @Description
#! Return the tetrahedral type of a given twisted polygonal complex or
#! <K>fail</K>, if <K>complex</K> is not a multi tetrahedral sphere. 
#! The tetrahedral type of a multi tetrahedral sphere is a tuple
#! <K>[a0,...,ak]</K> satisfying the following property:
#! <K>X</K> is a list of multi tetrahedral spheres of length <K>k</K> so that
#! <K>X[1]=complex</K> and <K>X[k]</K> is either isomorphic to the tetrahedron 
#! or the double tetrahedron. Furthermore <K>X[i]</K> is obtained by applying 
#! tetrahedral reductions to all vertices with face degree 3 in <K>X[i-1]</K>.
#! So <K>ai</K> is the number of vertices with face degree 3 in <K>X[i]</K>,
#! if <K>X[k]</K> is isomorphic to the tetrahedron, the number <K>ak</K> is
#! redefined as 1.
#! As example, consider the tetrahedron, the double tetrahedron and 
#! the multi-tetrahedral sphere which can be obtained by
#! applying exactly two tetrahedral extensions to the tetrahedron.  
#! @BeginExampleSession
#! gap> doubleTetra:=TetrahedralExtension(Tetrahedron(),1);
#! simplicial surface (5 vertices, 9 edges, and 6 faces)
#! gap> multiTetra:=TetrahedralExtension(doubleTetra,2);
#! simplicial surface (6 vertices, 12 edges, and 8 faces)
#! gap> TetrahedralType(Tetrahedron());
#! [ 1 ]
#! gap> TetrahedralType(doubleTetra);
#! [ 2 ]
#! gap> TetrahedralType(multiTetra);
#! [ 2, 1 ]
#! @EndExampleSession
#! @Returns a dense list or fail
#! @Arguments complex
DeclareAttribute( "TetrahedralType", IsTwistedPolygonalComplex );
#! @EndGroup TetrahedralType

#! @BeginGroup BlockType
#! @Description
#! Return the block type of a vertex-faithful simplicial sphere.
#! The block type is a list of pairs <K>[num,numOfFaces]</K> where <K>num</K> 
#! counts the building blocks(<Ref Subsect="BuildingBlocks"/>) of
#! <K>surface</K> whose number of faces match <K>numOfFaces</K>.
#! Since building blocks only exist for vertex-faithful spheres the function
#! returns <K>fail</K>, if <K>surface</K> does not satisfy this property.  
#!
#! As examples, consider the tetrahedron and the double tetrahedron. 
#! @BeginExampleSession
#! gap> BlockType(Tetrahedron());
#! [ [ 4, 1 ] ]
#! gap> vof:=[[1,2,4],[2,3,4],[1,3,4],[1,2,5],[1,3,5],[2,3,5]];;
#! gap> doubleTetra:=SimplicialSurfaceByVerticesInFaces(vof);
#! simplicial surface (5 vertices, 9 edges, and 6 faces)
#! gap> BlockType(doubleTetra);
#! [ [ 4, 2 ] ]
#! @EndExampleSession
#! @Returns list of pairs or fail
#! @Arguments surface
DeclareAttribute( "BlockType",IsSimplicialSurface);
#! @EndGroup


#! @Section Degree-based properties and invariants
#! @SectionLabel Properties_Degrees

# Separating degrees into an own section feels weird, but putting them under 
# vertex properties feels weird as well (since there are methods like 
# InnerVertices etc. that feel too connected to separate them by the degrees..);

#! This section contains properties and invariants that are based on the
#! degrees of the vertices. We have to distinguish two different definitions
#! for the degree of a vertex - we can either count the number of incident
#! edges of the number of incident faces.
#! These two definitions are distinguished by calling them 
#! <K>EdgeDegreesOfVertices</K> and <K>FaceDegreesOfVertices</K>.
#! 
#! A large part of this chapter are the counters. There are six different counter objects:
#! vertex counter(<Ref Subsect="CounterOfVertices"/>), edge counter(<Ref Subsect="CounterOfEdges"/>),
#! face counter(<Ref Subsect="CounterOfFaces"/>), butterfly counter(<Ref Subsect="CounterOfButterflies"/>),
#! umbrella counter(<Ref Subsect="CounterOfUmbrellas"/>) and three face counter(<Ref Subsect="CounterOfThreeFaces"/>).
#! For a given surface, the counters save information about the vertex, face or edge degrees.
#! There are different methods to get these information like <A>ListCounter</A>(<Ref Subsect="ListCounter"/>),
#! <A>MultiplicitiesOfCounter</A>(<Ref Subsect="MultiplicitiesOfCounter"/>) and <A>DegreesOfCounter</A>(<Ref Subsect="DegreesOfCounter"/>).


#! @BeginGroup EdgeDegreesOfVertices
#! @Description
#! The method <K>EdgeDegreeOfVertex</K>(<A>complex</A>, <A>vertex</A>) 
#! returns the <E>edge-degree</E> of the given vertex in the given
#! twisted polygonal complex, i.e. the number of incident edges. The NC-version does
#! not check whether <A>vertex</A> is a vertex of <A>complex</A>.
#!
#! The attribute <K>EdgeDegreesOfVertices</K>(<A>complex</A>) collects all of
#! these degrees in a list that is indexed by the vertices, i.e.
#! <K>EdgeDegreesOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>EdgeDegreeOfVertex</K>(<A>complex</A>, <A>vertex</A>). All other
#! positions of this list are not bound.
#!
#! As an example, consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-7-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-7.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @ExampleSession
#! gap> EdgeDegreeOfVertex( fiveStar, 1 );
#! 5
#! gap> EdgeDegreeOfVertex( fiveStar, 5 );
#! 3
#! gap> EdgeDegreesOfVertices( fiveStar );
#! [ 5, 3, 3,, 3,, 3,,,, 3 ]
#! @EndExampleSession
#!
#! @Returns a list of positive integers
#! @Arguments complex
DeclareAttribute( "EdgeDegreesOfVertices", IsTwistedPolygonalComplex );
#! @Returns a positive integer
#! @Arguments complex, vertex
DeclareOperation( "EdgeDegreeOfVertex", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "EdgeDegreeOfVertexNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup FaceDegreesOfVertices
#! @Description
#! The method <K>FaceDegreeOfVertex</K>(<A>complex</A>, <A>vertex</A>) 
#! returns the <E>face-degree</E> of the given vertex in the given
#! twisted polygonal complex, i.e. the number of incident faces. The NC-version does
#! not check whether <A>vertex</A> is a vertex of <A>complex</A>.
#!
#! The attribute <K>FaceDegreesOfVertices</K>(<A>complex</A>) collects all of
#! these degrees in a list that is indexed by the vertices, i.e.
#! <K>FaceDegreesOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>FaceDegreeOfVertex</K>(<A>complex</A>, <A>vertex</A>). All other
#! positions of this list are not bound.
#!
#! As an example, consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-8-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-8.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @ExampleSession
#! gap> FaceDegreeOfVertex( fiveStar, 1 );
#! 5
#! gap> FaceDegreeOfVertex( fiveStar, 5 );
#! 2
#! gap> FaceDegreesOfVertices( fiveStar );
#! [ 5, 2, 2,, 2,, 2,,,, 2 ]
#! gap> DegreesOfVertices( fiveStar );
#! [ 5, 2, 2,, 2,, 2,,,, 2 ]
#! @EndExampleSession
#!
#! For convenience, these methods can also be called by the names
#! <K>DegreesOfVertices</K> and <K>DegreeOfVertex</K>.
#!
#! @Returns a list of positive integers
#! @Arguments complex
DeclareAttribute( "FaceDegreesOfVertices", IsTwistedPolygonalComplex );
#! @Returns a positive integer
#! @Arguments complex, vertex
DeclareOperation( "FaceDegreeOfVertex", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "FaceDegreeOfVertexNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Returns a list of positive integers
#! @Arguments complex
DeclareAttribute( "DegreesOfVertices", IsTwistedPolygonalComplex );
#! @Returns a positive integer
#! @Arguments complex, vertex
DeclareOperation( "DegreeOfVertex", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "DegreeOfVertexNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup TotalDefect
#! @Description
#! Return the <E>total (inner) defect</E> of the given simplicial surface.
#! The defect of an inner vertex is <M>6 - faceDegree</M> and the defect of
#! a boundary vertex is <M>3 - faceDegree</M>.
#!
#! The <E>total defect</E> is the sum over all defects.
#! The <E>total inner defect</E> is the sum over the defects of all inner 
#! vertices.
#! As an example, consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-9-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-9.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @ExampleSession
#! gap> TotalDefect( fiveStar );
#! 6
#! gap> TotalInnerDefect( fiveStar );
#! 1
#! @EndExampleSession
#!
#! @Returns an integer
#! @Arguments surface
DeclareAttribute( "TotalDefect", IsSimplicialSurface );
#! @Arguments surface
DeclareAttribute( "TotalInnerDefect", IsSimplicialSurface );
#! @EndGroup

#! <ManSection Label="CounterOfVertices">
#!   <Oper Name="CounterOfVertices" Arg="complex"
#!      Label="for IsTwistedPolygonalComplex"
#!      Comm="Construct a vertex counter from a twisted polygonal complex"/>
#!   <Returns>A Counter-&GAP;-object</Returns>
#!   <Prop Name="IsCounterOfVertices" Arg="object" Label="for IsObject"
#!      Comm="Check whether a given object is a vertex counter"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!      The method <K>CounterOfVertices</K> constructs a new vertex counter from
#!      a polygonal complex. The method <K>IsCounterOfVertices</K>
#!      checks if a given &GAP;-object represents such a vertex counter.
#!      The vertex counter saves the information about how many vertices are incident
#!      to how many faces. To get this information there are different possibilities.
#!      For example, the method <A>ListCounter</A> (<Ref Subsect="ListCounter"/>) that
#!      returns this information as a list of pairs <E>[degree, multiplicity]</E>, where
#! 	<E>multiplicity</E> counts the number of vertices with exactly <E>degree</E>
#! 	incident faces.
#!
#! 	As an example, consider the five-star from the start of chapter
#!	<Ref Chap="Chapter_Properties"/>:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-1-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-1.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! 	@ExampleSession
#! gap> List( FacesOfVertices(fiveStar), Size );
#! [ 5, 2, 2,, 2,, 2,,,, 2 ]
#! gap> countVert:=CounterOfVertices(fiveStar);
#! counter of vertices ([ 2, 5 ] degrees, and [ 5, 1 ] multiplicities)
#! gap> ListCounter(countVert);
#! [ [ 2, 5 ], [ 5, 1 ] ]
#! 	@EndExampleSession
#!   </Description>
#! </ManSection>

#! <ManSection Label="CounterOfEdges">
#!   <Oper Name="CounterOfEdges" Arg="complex"
#!      Label="for IsTwistedPolygonalComplex"
#!      Comm="Construct an edge counter from a twisted polygonal complex"/>
#!   <Returns>A Counter-&GAP;-object</Returns>
#!   <Prop Name="IsCounterOfEdges" Arg="object" Label="for IsObject"
#!      Comm="Check whether a given object is an edge counter"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!	The method <K>CounterOfEdges</K> constructs a new edge counter from
#!	a polygonal complex. The method <K>IsCounterOfEdges</K>
#!	checks if a given &GAP;-object represents such an edge counter.
#! 	The edge counter saves the information about how many edges have vertices with the same degrees.
#!	To get this information there are different possibilities.
#!	For example, the method <A>ListCounter</A> (<Ref Subsect="ListCounter"/>) that
#!	returns this information as a list of pairs <E>[degreeList, multiplicity]</E>, where
#!	<E>multiplicity</E> counts the number of edges whose vertices
#!	are incident to <E>degreeList[1]</E> and <E>degreeList[2]</E> faces.
#! 	The list <E>degreeList</E> is always sorted but may contain duplicates.
#!
#! 	As an example, consider the five-star from the start of chapter
#! 	<Ref Chap="Chapter_Properties"/>:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-2-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-2.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! 	@BeginExampleSession
#! gap> countEdg := CounterOfEdges(fiveStar);
#! counter of edges ([ [ 2, 2 ], [ 2, 5 ] ] degrees, and [ 5, 5 ] multiplicities)
#! gap> ListCounter(countEdg);
#! [ [ [ 2, 2 ], 5 ], [ [ 2, 5 ], 5 ] ]
#! 	@EndExampleSession
#!   </Description>
#! </ManSection>

#! <ManSection Label="CounterOfFaces">
#!   <Oper Name="CounterOfFaces" Arg="complex"
#!      Label="for IsTwistedPolygonalComplex"
#!      Comm="Construct a face counter from a twisted polygonal complex"/>
#!   <Returns>A Counter-&GAP;-object</Returns>
#!   <Prop Name="IsCounterOfFaces" Arg="object" Label="for IsObject"
#!      Comm="Check whether a given object is a face counter"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!      The method <K>CounterOfFaces</K> constructs a new face counter from
#!      a polygonal complex. The method <K>IsCounterOfFaces</K>
#!      checks if a given &GAP;-object represents such a face counter.
#!      The face counter saves the information about how many faces have vertices with the same degrees.
#! 	To get this information there are different possibilities.
#! 	For example, the method <A>ListCounter</A> (<Ref Subsect="ListCounter"/>) that
#! 	returns this information as a list of pairs <E>[degreeList, multiplicity]</E>, where
#! 	<E>multiplicity</E> counts the number of faces whose vertex degrees
#! 	match <E>degreeList</E>, i.e. for every vertex there is exactly one
#! 	entry of <E>degreeList</E> such that the vertex is incident to this
#! 	number of faces.
#! 	The <E>degreeList</E> is always sorted but may contain duplicates.
#!
#!	 As an example, consider the five-star from the start of chapter
#! 	<Ref Chap="Chapter_Properties"/>:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-3-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-3.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! 	@ExampleSession
#! gap> countFac:=CounterOfFaces(fiveStar);
#! counter of faces ([ [ 2, 2, 5 ] ] degrees, and [ 5 ] multiplicities) 
#! gap> ListCounter(countFac);
#! [ [ [ 2, 2, 5 ], 5 ] ]
#! 	@EndExampleSession
#!   </Description>
#! </ManSection>

#! <ManSection Label="CounterOfButterflies">
#!   <Oper Name="CounterOfButterflies" Arg="surface"
#!      Label="for IsSimplicialSurface"
#!      Comm="Construct a butterfly counter from a simplicial surface"/>
#!   <Returns>A Counter-&GAP;-object</Returns>
#!   <Prop Name="IsCounterOfButterflies" Arg="object" Label="for IsObject"
#!      Comm="Check whether a given object is a butterfly counter"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!       The method <K>CounterOfButterflies</K> constructs a new butterfly counter from
#!       a simplicial surface. The method <K>IsCounterOfButterflies</K>
#!       checks if a given &GAP;-object represents such a butterfly counter.
#! 	 The butterfly counter saves the information about how many butterflies have vertices with the same degrees.
#!       To get this information there are different possibilities.
#!       For example, the method <A>ListCounter</A> (<Ref Subsect="ListCounter"/>) that
#!       returns this information as a list of pairs <E>[[degList1,degList2], multiplicity]</E>, where
#!       <E>multiplicity</E> counts the number of butterflies whose vertex degrees match
#!       <E>[degList1,degList2]</E>, whereby <E>degList1</E> denotes the
#!       vertex degree of the vertices that are incident to the edge
#!       inducing the corresponding butterfly and <E>degList2</E> contains
#!       the vertex degrees of the two remaining vertices of the butterfly.
#! 
#! 	 As an example, consider the double-5-gon:
#!        <Alt Only="HTML">
#! &lt;img src="./images/_Wrapper_Image_Double5gon-1.svg"> &lt;/img>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_Double5gon.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!       @ExampleSession
#! gap> vof:=[[1,4,5],[1,4,6],[1,5,7],[1,6,7],[2,3,5],[2,3,6],[2,4,5],
#! > [2,4,6],[3,5,7],[3,6,7]];;
#! gap> s:=SimplicialSurfaceByVerticesInFaces(vof);;
#! gap> counter:=CounterOfButterflies(s);
#! counter of butterlies ([ [ [ 4, 4 ], [ 5, 5 ] ], [ [ 4, 5 ], [ 4, 4 ] ] ]
#! degrees, and [ 5, 10 ] multiplicities) 
#! gap> ListCounter(counter);
#! [ [ [ [ 4, 4 ], [ 5, 5 ] ], 5 ], [ [ [ 4, 5 ], [ 4, 4 ] ], 10 ] ]
#!       @EndExampleSession
#!   </Description>
#! </ManSection>

#! <ManSection Label="CounterOfUmbrellas">
#!   <Oper Name="CounterOfUmbrellas" Arg="surface"
#!      Label="for IsSimplicialSurface"
#!      Comm="Construct an umbrella counter from a simplicial surface"/>
#!   <Returns>A Counter-&GAP;-object</Returns>
#!   <Prop Name="IsCounterOfUmbrellas" Arg="object" Label="for IsObject"
#!      Comm="Check whether a given object is an umbrella counter"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!      The method <K>CounterOfUmbrellas</K> constructs a new umbrella counter from
#!      a simplicial surface. The method <K>IsCounterOfUmbrellas</K>
#!      checks if a given &GAP;-object represents such an umbrella counter.
#!      The umbrella counter saves the information about how many umbrellas have vertices with the same degrees.
#!	To get this information there are different possibilities.
#! 	For example, the method (<A>ListCounter</A> <Ref Subsect="ListCounter"/>) that
#! 	returns this information as a list of pairs <E>[degreeList, multiplicity]</E>,
#! 	where <E>multiplicity</E> counts the number of umbrellas whose vertex degrees
#! 	of vertices contained at the boundary of the umbrella match
#! 	<E>degreeList</E>, i.e. for every vertex contained in the boundary
#! 	of an umbrella there is exactly one entry of <E>degreeList</E> such that
#! 	the vertex is incident to this number of faces.
#! 	The list <E>degreeList</E> is not sorted but may contain duplicates.
#!
#! 	As an example, consider the double-6-gon:
#!  <Alt Only="HTML">
#! &lt;img src="./images/_Wrapper_Image_Double6gon-1.svg"> &lt;/img>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_Double6gon.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> vof:=[[1,5,7],[1,5,8],[1,6,7],[1,6,8],[2,3,5],[2,3,6],[2,4,5],
#! > [2,4,6],[3,5,7],[3,6,7],[4,5,8],[4,6,8]];;
#! gap> s:=SimplicialSurfaceByVerticesInFaces(vof);;
#! gap> counter:=CounterOfUmbrellas(s);
#! counter of umbrellas ([ [ 4, 6, 4, 6 ], [ 4, 4, 4, 4, 4, 4 ] ] degrees,
#! and [ 6, 2 ] multiplicities)
#! gap> ListCounter(counter);
#! [ [ [ 4, 6, 4, 6 ], 6 ], [ [ 4, 4, 4, 4, 4, 4 ], 2 ] ]
#! @EndExampleSession
#!   </Description>
#! </ManSection>
# No AutoDoc-documentation
DeclareAttribute("CounterOfUmbrellas",IsClosedSurface and IsSimplicialSurface);

#! <ManSection Label="CounterOfThreeFaces">
#!   <Oper Name="CounterOfThreeFaces" Arg="surface"
#!      Label="for IsSimplicialSurface"
#!      Comm="Construct a three face counter from a simplicial surface"/>
#!   <Returns>A Counter-&GAP;-object</Returns>
#!   <Prop Name="IsCounterOfThreeFaces" Arg="object" Label="for IsObject"
#!      Comm="Check whether a given object is a three face counter"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!      The method <K>CounterOfThreeFaces</K> constructs a new three face counter from
#!      a simplicial surface. The method <K>IsCounterOfThreeFaces</K>
#!      checks if a given &GAP;-object represents such a three face counter.
#!	The three-face counter saves the information about how many three-faces have vertices with the same degrees.
#!	To get this information there are different possibilities.
#! 	For example, the method <A>ListCounter</A> (<Ref Subsect="ListCounter"/>) that
#! 	returns this information as a list of pairs
#! 	<E>[[deg,degreeList1,degreeList2], multiplicity]</E>, whereby
#! 	<E>[deg,degreeList1,degreeList2]</E> satisfies the following property:
#! 	Assume that the vertices <E>v1,v2,v3</E> are all incident to the same
#! 	face and there exist exactly two vertices <E>v4,v5</E> so that <E>v4</E>
#! 	resp. <E>v5</E> is the remaining vertex of the butterfly induced by
#! 	the edge incident to the vertices <E>v1</E> and <E>v2</E> resp.<E>v1</E>
#! 	and <E>v3</E>.
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-4-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-4.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! 	So <E>deg</E> denotes the vertex degree of the vertex <E>v1</E>. The
#! 	first resp. second entry of <E>degreeList1</E> is the vertex degree of
#! 	<E>v2</E> resp <E>v3</E>. And the first resp. second
#! 	entry of <E>degreeList2</E> is the vertex degree of <E>v4</E> resp.
#! 	<E>v5</E>. The integer <E>multiplicity</E> counts the number of adjacent
#! 	three-faces whose vertex degrees match <E>degreeList</E>.
#!
#! 	The different lists in <E>degreeList</E> are not sorted but may
#! 	contain duplicates.
#!
#!	 As an example, consider the double-6-gon:
#!  <Alt Only="HTML">
#! &lt;img src="./images/_Wrapper_Image_Double6gon-1.svg"> &lt;/img>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_Double6gon.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> vof:=[[1,5,7],[1,5,8],[1,6,7],[1,6,8],[2,3,5],[2,3,6],[2,4,5],
#! > [2,4,6],[3,5,7],[3,6,7],[4,5,8],[4,6,8]];;
#! gap> s:=SimplicialSurfaceByVerticesInFaces(vof);;
#! gap> counter:=CounterOfThreeFaces(s);
#! counter of three faces ([ [ 4, [ 4, 6 ], [ 6, 4 ] ], [ 6, [ 4, 4 ], [ 4, 4 ] ] ]
#! degrees, and [ 24, 12 ] multiplicities)
#! gap> ListCounter(counter);
#! [ [ [ 4, [ 4, 6 ], [ 6, 4 ] ], 24 ], [ [ 6, [ 4, 4 ], [ 4, 4 ] ], 12 ] ]
#! @EndExampleSession
#!   </Description>
#! </ManSection>

#! <ManSection Label="IsCounter">
#!   <Prop Name="IsCounter" Arg="object" Label="for IsObject"
#!      Comm="Check whether a given object is a counter"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!      The method returns if the <E>object</E> is a vertex counter, edge counter, face counter,
#! 	butterfly counter, umbrella counter or three face counter.
#! @ExampleSession
#! gap> IsCounter(CounterOfVertices(fiveStar));
#! true
#! @EndExampleSession
#!   </Description>
#! </ManSection>

#! @BeginGroup TypeOfCounter
#! @Description
#! Returns the type of the counter. That means if <A>counter</A> is a
#! CounterOfVertices(<Ref Subsect="CounterOfVertices"/>), CounterOfEdges(<Ref Subsect="CounterOfEdges"/>),
#! CounterOfFaces(<Ref Subsect="CounterOfFaces"/>), CounterOfButterflies(<Ref Subsect="CounterOfButterflies"/>),
#! CounterOfUmbrellas(<Ref Subsect="CounterOfUmbrellas"/>), CounterOfThreeFaces(<Ref Subsect="CounterOfThreeFaces"/>) 
#! or a not specified counter object.
#! 
#! @BeginExampleSession
#! gap> counter:=CounterOfVertices(fiveStar);;
#! gap> TypeOfCounter(counter);
#! CounterOfVertices
#! @EndExampleSession
#! 
#! @Arguments counter
DeclareOperation("TypeOfCounter", [IsCounter]);
#! @EndGroup

#! @BeginGroup AssociatedPolygonalComplex
#! @Description
#! Return the polygonal complex for which the given counter is
#! defined.
#! 
#! @BeginExampleSession
#! gap> assCom:=AssociatedPolygonalComplex(CounterOfVertices(fiveStar));;
#! gap> IsIsomorphic(assCom, fiveStar);
#! true
#! @EndExampleSession
#!
#! @Returns a polygonal complex
#! @Arguments counter
DeclareAttribute( "AssociatedPolygonalComplex", IsCounter );
#! @EndGroup

#! @BeginGroup ListCounter
#! @Description
#! Returns the information about different counters.
#! For a vertex counter the method returns the list of pairs
#! <E>[degree, multiplicity]</E> for <E>counter</E>.
#! For an edge counter, a face counter and an umbrella counter
#! the method returns the list of pairs <E>[degreeList, multiplicity]</E>.
#! For a butterfly counter the method returns the list of pairs <E>[[degList1,degList2], multiplicity]</E> and
#! for a three face counter the method returns the list of pairs <E>[[deg,degList1,degList2], multiplicity]</E>.
#! @BeginExampleSession
#! gap> countFac:=CounterOfFaces(fiveStar);;
#! gap> ListCounter(countFac);
#! [ [ [ 2, 2, 5 ], 5 ] ]
#! @EndExampleSession
#!
#! @Returns a list of pairs
#! @Arguments counter
DeclareAttribute("ListCounter",IsCounter);
#! @EndGroup

#! @BeginGroup MultiplicitiesOfCounter
#! @Description
#! The method <A>Multiplicities</A> returns the second entry of the tupels contained in the list obtained from <A>ListCounter</A>.
#! This means, for example, that the method returns how many vertices have the same degree if <A>counter</A> is a vertex counter.
#! The method <A>MultiplicityOfDegree</A> returns the number for the given <A>degree</A> or <A>degreeList</A> of <A>counter</A>.
#! The method <A>MultiplicitiesOfDegrees</A> returns a list <A>multiplicities</A> for a vertex counter where <A>multiplicities[i]</A>
#! is the number of times a vertex has degree <A>i</A>.
#! @BeginExampleSession
#! gap> counterEd:=CounterOfEdges(fiveStar);;
#! gap> MultiplicitiesOfCounter(counterEd);
#! [ 5, 5 ]
#! gap> MultiplicityOfDegree(counterEd,[2,5]);
#! 5
#! gap> counterVert:=CounterOfVertices(fiveStar);;
#! gap> MultiplicitiesOfDegrees(counterVert);
#! [ , 5,,, 1 ]
#! @EndExampleSession
#! @Returns a list of positive integers/a positive integer
#! @Arguments counter
DeclareOperation("MultiplicitiesOfCounter",[IsCounter]);
#! @Arguments counterVert
DeclareOperation("MultiplicitiesOfDegrees",[IsCounterOfVertices]);
#! @Arguments counter, degreeList
DeclareOperation("MultiplicityOfDegree",[IsCounter, IsList]);
#! @Arguments counterVert, degree
DeclareOperation("MultiplicityOfDegree",[IsCounterOfVertices, IsPosInt]);
#! @EndGroup

#! @BeginGroup DegreesOfCounter
#! @Description
#! The method <A>Degrees</A> returns the first entry of tupels contained in the list obtained from <A>ListCounter</A>.
#! This means, for example, that if <A>counter</A> is a vertex counter, the method returns what the different degrees of the vertices are.
#! The method <A>DegreesOfMultiplicities</A> returns a list <A>degrees</A> for <A>counter</A>, where <A>degrees[i]</A>
#! is the degree or degreeList that occurs <A>i</A> times.
#! @BeginExampleSession
#! gap> counterEd:=CounterOfEdges(fiveStar);;
#! gap> DegreesOfCounter(counterEd);
#! [ [ 2, 2 ], [ 2, 5 ] ]
#! gap> DegreesOfMultiplicities(counterEd);
#! [ ,,,, [ [ 2, 2 ], [ 2, 5 ] ] ]
#! gap> DegreesOfMultiplicity(counterEd,5);
#! [ [ 2, 2 ], [ 2, 5 ] ]
#! @EndExampleSession
#! @Returns a list of positive integers
#! @Arguments counter
DeclareOperation("DegreesOfCounter",[IsCounter]);
#! @Arguments counter
DeclareOperation("DegreesOfMultiplicities",[IsCounter]);
#! @Arguments counter, multiplicity
DeclareOperation("DegreesOfMultiplicity",[IsCounter, IsPosInt]);
#! @EndGroup

#! @Section Types of faces
#! @SectionLabel Properties_FaceTypes
#!
#! The faces in a (twisted) polygonal complex are (twisted) polygons. In
#! particular there can be polygons with different numbers of vertices,
#! i.e. triangle, quadrangles, and so on.

#! @BeginGroup IsFaceHomogenous
#! @Description
#! Check whether all polygons in this twisted polygonal complex have the same number
#! of vertices.
#!
#! Consider the following polygonal complex:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> complex := PolygonalComplexByDownwardIncidence(
#! > [ , , , , , [2,5], , [2,3], [3, 5], [11,5], , [3,7], [7,11] ],
#! > [[6,8,9], , , [9,10,12,13]]);;
#! gap> IsFaceHomogeneous(complex);
#! false
#! @EndExampleSession
#! This complex is not face homogeneous, since it contains a face with three vertices
#! and a face with four vertices.
#! A tetrahedron is face homogeneous:
#! @BeginExampleSession
#! gap> IsFaceHomogeneous(Tetrahedron());
#! true
#! @EndExampleSession
#! @Arguments complex
DeclareProperty( "IsFaceHomogeneous", IsTwistedPolygonalComplex );
#! @EndGroup


#! @BeginGroup IsTriangular
#! @Description
#! Check whether all polygons in this twisted polygonal complex are triangles.
#! If this is the case, the twisted polygonal complex is face homogeneous.
#! 
#! The tetrahedron consists only of triangles:
#! @BeginExampleSession
#! gap> IsTriangular(Tetrahedron());
#! true
#! @EndExampleSession
#! @Arguments complex
DeclareProperty( "IsTriangular", IsTwistedPolygonalComplex );
InstallTrueMethod(IsFaceHomogeneous, IsTriangular);
#! @EndGroup

#! @BeginGroup IsQuadrangular
#! @Description
#! Check whether all polygons in this twisted polygonal complex are quadrangles.
#!
#! Consider the following polygonal complex:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FlagComplexExample-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FlagComplexExample.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @BeginExampleSession
#! gap> complex := PolygonalComplexByDownwardIncidence(
#! > [ , , , , , [2,5], , [2,3], [3, 5], [11,5], , [3,7], [7,11] ],
#! > [[6,8,9], , , [9,10,12,13]]);;
#! gap> IsQuadrangular(complex);
#! false
#! @EndExampleSession
#! This complex is not quadrangular, since it contains a triangle.
#! @Arguments complex
DeclareProperty( "IsQuadrangular", IsTwistedPolygonalComplex );
InstallTrueMethod(IsFaceHomogeneous, IsQuadrangular);
#! @EndGroup


#! @Section Types of edges
#! @SectionLabel Properties_EdgeTypes
#!
#! The edges of a twisted polygonal complex (defined in 
#! <Ref Sect="PolygonalStructures_complex"/>) can be in different local
#! positions. This can be seen in the example of the five-star (which was
#! introduced at the start of chapter <Ref Chap="Chapter_Properties"/>):
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-10-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-10.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! The edges that are incident to the vertex 1 are different from the other 
#! edges since they lie "inside" the surface. Edges with two incident faces
#! are called <E>inner edges</E> while edges with only one incident face are
#! called <E>boundary edges</E>.
#!
#! If edge ramifications are not allowed, only those two edge types can appear
#! (by definition there are one or two faces incident to each edge). In 
#! general there might appear a third case (more than
#! two faces incident to an edge). This is exemplified in the following
#! example:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-11-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-11.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! Edges with more than two incident faces are called <E>ramified edges</E>.
#!

#! @BeginGroup InnerEdges
#! @Description
#! Return the set of all inner edges of the given twisted polygonal complex.
#! An <E>inner edge</E> is an edge that is incident to exactly two faces.
#!
#! The method <K>IsInnerEdge</K> checks whether the given edge is an inner
#! edge of the given twisted polygonal complex. The NC-version does not check whether
#! <A>edge</A> is an edge of <A>complex</A>.
#!
#! Consider the five-star from the start of chapter 
#! <Ref Chap="Chapter_Properties"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FiveTrianglesInCycle-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FiveTrianglesInCycle.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> IsInnerEdge( fiveStar, 4 );
#! true
#! gap> IsInnerEdge( fiveStar, 10 );
#! false
#! gap> InnerEdges( fiveStar );
#! [ 1, 2, 3, 4, 5 ]
#! @EndExampleSession
#!
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "InnerEdges", IsTwistedPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, edge
DeclareOperation( "IsInnerEdge", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, edge
DeclareOperation( "IsInnerEdgeNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @BeginGroup TurnableEdges
#! @Description
#! Return the set of all turnable edges of the given simplicial surface.
#! Let <A>v1,v2</A> be the vertices of the subsurface
#! induced by a given edge which are not incident to this edge.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_ButIndEdg-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_ButIndEdg.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! The given edge is a turnable edge, if and only if <A>v1</A> is not equal to
#! <A>v2</A> and there exist no edge whose incident vertices are exactly
#! <A>v1</A> and <A>v2</A>.
#! The method <A>IsTurnableEdge</A> checks whether the given edge is a turnable
#! edge of the given simplicial surface. The NC-version does not check whether
#! <A>edge</A> is an edge of <A>surface</A>.
#!
#! @BeginExampleSession
#! gap> TurnableEdges(Tetrahedron());
#! [  ]
#! gap> TurnableEdges(Octahedron());
#! [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]
#! gap> IsTurnableEdge(Tetrahedron(),1);
#! false
#! gap> IsTurnableEdge(Octahedron(),2);
#! true
#! @EndExampleSession
#! 
#! As another example surfaces with boundary edges can be considered.
#! @BeginExampleSession
#! gap> s:=SimplicialSurfaceByVerticesInFaces([[1,2,3],[1,2,4]]);
#! simplicial surface (4 vertices, 5 edges, and 2 faces)
#! gap> IsTurnableEdge(s,1);
#! true
#! gap> IsTurnableEdge(s,2);
#! false
#! gap> EdgesOfFaces(s);
#! [ [ 1, 2, 4 ], [ 1, 3, 5 ] ]
#! @EndExampleSession
#!
#! @Returns a set of positive integers
#! @Arguments surface
DeclareAttribute( "TurnableEdges", IsSimplicialSurface);
#! @Returns true or false
#! @Arguments surface,edge
DeclareOperation( "IsTurnableEdge", [IsSimplicialSurface, IsPosInt] );
#! @Arguments surface, edge
DeclareOperation( "IsTurnableEdgeNC", [IsSimplicialSurface, IsPosInt] );
#! @EndGroup


#! @BeginGroup BoundaryEdges
#! @Description
#! Return the set of all boundary edges of the given twisted polygonal complex.
#! A <E>boundary edge</E> is an edge that is incident to exactly one face.
#!
#! The method <K>IsBoundaryEdge</K> checks whether the given edge is a 
#! boundary
#! edge of the given twisted polygonal complex. The NC-version does not check whether
#! <A>edge</A> is an edge of <A>complex</A>.
#!
#! Consider the five-star from the start of chapter 
#! <Ref Chap="Chapter_Properties"/>:
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_FiveTrianglesInCycle-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_FiveTrianglesInCycle.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> IsBoundaryEdge( fiveStar, 4 );
#! false
#! gap> IsBoundaryEdge( fiveStar, 10 );
#! true
#! gap> BoundaryEdges( fiveStar );
#! [ 6, 7, 8, 9, 10 ]
#! @EndExampleSession
#!
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "BoundaryEdges", IsTwistedPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, edge
DeclareOperation( "IsBoundaryEdge", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, edge
DeclareOperation( "IsBoundaryEdgeNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @BeginGroup RamifiedEdges
#! @Description
#! Return the set of all ramified edges of the given twisted polygonal complex.
#! A <E>ramified edge</E> is an edge that is incident to at least three faces.
#!
#! The method <K>IsRamifiedEdge</K> checks whether the given edge is a 
#! ramified
#! edge of the given twisted polygonal complex. The NC-version does not check whether
#! <A>edge</A> is an edge of <A>complex</A>.
#!
#! We illustrate it on the following triangular complex:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-12-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-12.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> branch := TriangularComplexByDownwardIncidence(
#! >        [[2,3],[1,3],[2,4],[1,4],[2,5],[1,5],[1,2]], 
#! >        [[1,2,7],[3,4,7],[5,6,7]]);;
#! gap> IsRamifiedEdge(branch, 1);
#! false
#! gap> IsRamifiedEdge(branch, 7);
#! true
#! gap> RamifiedEdges(branch);
#! [ 7 ]
#! @EndExampleSession
#!
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "RamifiedEdges", IsTwistedPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, edge
DeclareOperation( "IsRamifiedEdge", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, edge
DeclareOperation( "IsRamifiedEdgeNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @Section Types of vertices
#! @SectionLabel Properties_VertexTypes
#! 
#! The vertices of a twisted polygonal complex (defined in 
#! <Ref Sect="PolygonalStructures_complex"/>) can be in different local
#! positions. This can be seen in the example of the five-star (which was
#! introduced at the start of chapter <Ref Chap="Chapter_Properties"/>):
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-13-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-13.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! The vertex 1 is the only vertex that is completely surrounded by faces. It
#! is called an <E>inner vertex</E> while the other vertices of the five-star
#! are <E>boundary vertices</E>. This classifies all vertices of a twisted polygonal surface.
#!
#! In general there are more than these two possibilities. In the case of
#! vertex ramifications (defined in <Ref Sect="PolygonalStructures_surface"/>)
#! there can be 
#! <E>ramified vertices</E>:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-14-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-14.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#!
#! In the case of edge ramifications (also defined in 
#! <Ref Sect="PolygonalStructures_surface"/>) there might be edges that are 
#! incident to more than two faces.
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-15-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-15.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! Vertices that are incident to such an edge are called 
#! <E>chaotic vertices</E>.

#! @BeginGroup InnerVertices
#! @Description
#! Return the set of all inner vertices. 
#! 
#! A vertex is an inner vertex if and only if there is exactly
#! one closed umbrella-path around it (compare section 
#! <Ref Sect="Section_Access_OrderedVertexAccess"/> for the definition of
#! umbrella-paths).
#!
#! The method <K>IsInnerVertex</K> checks whether the given vertex is an inner
#! vertex of the given twisted polygonal complex. The NC-version does not check whether
#! <A>vertex</A> is an vertex of <A>complex</A>.
#! 
#! Consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-16-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-16.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> IsInnerVertex( fiveStar, 1 );
#! true
#! gap> IsInnerVertex( fiveStar, 3 );
#! false
#! gap> InnerVertices( fiveStar );
#! [ 1 ]
#! @EndExampleSession
#! 
#! For the special case of a twisted polygonal surface the inner vertices have an
#! easier characterisation: a vertex is
#! an inner vertex if and only if every incident edge is incident to exactly
#! two faces (that is, if it only incident to inner edges 
#! (<Ref Subsect="InnerEdges"/>)).
#! 
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "InnerVertices", IsTwistedPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, vertex
DeclareOperation( "IsInnerVertex", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "IsInnerVertexNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @BeginGroup BoundaryVertices
#! @Description
#! Return the set of all boundary vertices.
#!
#! A vertex is a boundary vertex if and only if there is exactly
#! one non-closed umbrella-path around it (compare section
#! <Ref Sect="Section_Access_OrderedVertexAccess"/> for the definition of
#! umbrella-paths).
#!
#! The method <K>IsBoundaryVertex</K> checks whether the given vertex is a 
#! boundary
#! vertex of the given twisted polygonal complex. The NC-version does not check whether
#! <A>vertex</A> is an vertex of <A>complex</A>.
#!
#! Consider the triforce from the start of section
#! <Ref Chap="Chapter_Properties"/>:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-17-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-17.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> IsBoundaryVertex( triforce, 6 );
#! true
#! gap> IsBoundaryVertex( triforce, 2 );
#! false
#! gap> BoundaryVertices( triforce );
#! [ 1, 4, 6 ]
#! @EndExampleSession
#!
#! For twisted polygonal surfaces the boundary vertices can be described more
#! easily: a vertex is a boundary vertex if and only if it
#! is incident to at least one edge that is incident to exactly one face 
#! (i.e. if it is 
#! incident to a boundary edge (<Ref Subsect="BoundaryEdges"/>)).
#!
#! Consider the five-star from the start of section 
#! <Ref Chap="Chapter_Properties"/>:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-18-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-18.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> IsBoundaryVertex( fiveStar, 5 );
#! true
#! gap> IsBoundaryVertex( fiveStar, 1 );
#! false
#! gap> BoundaryVertices( fiveStar );
#! [ 2, 3, 5, 7, 11 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "BoundaryVertices", IsTwistedPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, vertex
DeclareOperation( "IsBoundaryVertex", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "IsBoundaryVertexNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @BeginGroup RamifiedVertices
#! @Description
#! Return the set of all ramified vertices.
#!
#! A vertex is ramified if and only if there is a well-defined
#! umbrella-path partition around it (compare 
#! <Ref Subsect="UmbrellaPathPartitionsOfVertices"/>) and there are at least two
#! umbrella-paths in this partition.
#!
#! The method <K>IsRamifiedVertex</K> checks whether the given vertex is a
#! ramified
#! vertex of the given twisted polygonal complex. The NC-version does not check whether
#! <A>vertex</A> is an vertex of <A>complex</A>.
#!
#! Consider the triforce from the start of section
#! <Ref Chap="Chapter_Properties"/>:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-19-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-19.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> IsRamifiedVertex( triforce, 3 );
#! true
#! gap> IsRamifiedVertex( triforce, 4 );
#! false
#! gap> RamifiedVertices( triforce );
#! [ 2, 3, 5 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "RamifiedVertices", IsTwistedPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, vertex
DeclareOperation( "IsRamifiedVertex", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "IsRamifiedVertexNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup ChaoticVertices
#! @Description
#! Return the set of all chaotic vertices.
#!
#! A vertex is chaotic if and only if it is incident to an edge that is
#! incident to at least three faces. In other words, there is no well-defined
#! umbrella-path partition (<Ref Subsect="UmbrellaPathPartitionsOfVertices"/>) around 
#! a chaotic vertex.
#!
#! The method <K>IsChaoticVertex</K> checks whether the given vertex is a 
#! chaotic
#! vertex of the given twisted polygonal complex. The NC-version does not check whether
#! <A>vertex</A> is an vertex of <A>complex</A>.
#!
#! As an example, we consider the following triangular complex:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_properties-20-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_properties-20.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#! @BeginExampleSession
#! gap> branch := TriangularComplexByDownwardIncidence(
#! >        [[2,3],[1,3],[2,4],[1,4],[2,5],[1,5],[1,2]], 
#! >        [[1,2,7],[3,4,7],[5,6,7]]);;
#! gap> IsChaoticVertex(branch, 1);
#! true
#! gap> IsChaoticVertex(branch, 3);
#! false
#! gap> ChaoticVertices(branch);
#! [ 1, 2 ]
#! @EndExampleSession
#! 
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "ChaoticVertices", IsTwistedPolygonalComplex );
#! @Returns true or false
#! @Arguments complex, vertex
DeclareOperation( "IsChaoticVertex", [IsTwistedPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "IsChaoticVertexNC", [IsTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @Section Face-colouring 
#! @SectionLabel Properties_FaceColouring
#!
#! @BeginGroup FaceTwoColouring
#! @Description
#! If the method is given a polygonal complex, it returns a pair of two sets of 
#! faces, which represents a face-2-coloring, if possible. 
#! A 2-face-colouring of a polygonal complex is a colouring of the faces with exactly
#! two colours, whereby two neighbouring faces have to be coloured different.
#! If no such coloring exists, the method returns <K>fail</K>.
#! In the case that such a colouring exists,
#! the first set of the returned pair contains the face with the smallest label.  
#!
#! As an example, consider the octahedron.
#!
#! @ExampleSession
#! gap> FaceTwoColouring(Octahedron());
#! [ [ 1, 2, 5, 6 ], [ 3, 4, 7, 8 ] ]
#! @EndExampleSession
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_TwoColouredOctahedron-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_TwoColouredOctahedron.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @Returns a pair where the first and second entry are sets of positive integers or <K>fail</K>
#! @Arguments complex
DeclareAttribute( "FaceTwoColouring", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup AdmissibleRelationsOfSurface
#! @Description
#! An admissible relation of a simplicial surface is an equivalence relation on the surface satisfying the following properties:
#! - Each equivalence class contains either vertices, edges or faces only.
#! - We can define an incidence relation as follows: Let <K>K</K> and <K>L</K> be two equivalence classes. The class <K>K</K> is incident to the class <K>L</K>
#!   if and only if there exist <K>k</K> in the class <K>K</K> and <K>l</K> in the class <K>L</K> so that <K>k</K> is incident to <K>l</K> as elements of the given simplicial surface.
#! - The equivalence classes together with the introduced relation gives rise to a triangulated surface without ramifications.    
#!
#!  Note, let <K>X</K> be a simplicial surface and <K>Y</K> be a simplicial constructed by an admissible relation on <K>X</K>. Then there exists an epimorphism from <K>X</K>
#!  to <K>Y</K>.
#! This functions focuses on the admissible relations that yield butterfly friendly epimorphisms. Here, an epimorphism from a simplicial surface <K>X</K> to another 
#! simplicial surface <K>Y</K> is called butterfly friendly, if for each inner 
#! edge <K>e</K>, the restriction of the epimorphism to the butterfly induced by <K>e</K> is surjective. 

#! This function returns a list of tuples <K>[s,relation]</K>, where <K>s</K> is a simplicial surface and <K>relation</K> is the admissible relation of the given surface that gives rise to the resulting surface <K>X</K>.
#! The relation <K>relation</K> is given by the resulting partition of vertices, edges and faces.
#! If <K>bool=true</K> then the list which is returned by the function contains all surfaces that can be constructed by forming an admissible relation of the given surface and 
#! if <K>bool=false</K> then the list only contains isomorphism representatives with their corresponding admissible relations.
#! If <K>bool2=false</K> then the function prints how many faces are already visited while computating the admissible relations.

#! As an example, consider the tetrahedron.
#! @ExampleSession
#! gap> AdmissibleRelationsOfSurface(Tetrahedron(),true);
#! [ [ simplicial surface (4 vertices, 6 edges, and 4 faces)
#!        , 
#!       [ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ] ], 
#!           [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ] ], 
#!           [ [ 1 ], [ 2 ], [ 4 ], [ 3 ] ] ] ] ]
#! @EndExampleSession
#! 
#! As an example, consider the butterfly.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_butfly-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_butfly.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#! @ExampleSession
#! gap> butterfly:=SimplicialSurfaceByVerticesInFaces([[1,2,3],[2,3,4]]);;
#! gap> AdmissibleRelationsOfSurface(butterfly,false);
#! [ [ simplicial surface (4 vertices, 5 edges, and 2 faces)
#!         , 
#!       [ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ] ], [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ] ],
#!           [ [ 1 ], [ 2 ] ] ] ], 
#!   [ simplicial surface (3 vertices, 3 edges, and 1 faces),
#!       [ [ [ 1, 4 ], [ 2 ], [ 3 ] ], [ [ 1, 4 ], [ 2, 5 ], [ 3 ] ], 
#!           [ [ 1, 2 ] ] ] ] ]
#! @EndExampleSession
#! @Returns a list of tuples where the first entry is a surface and the second entry is a list of partitions
#! @Arguments surface,bool [,bool2]
DeclareOperation( "AdmissibleRelationsOfSurface", [IsSimplicialSurface,IsBool,IsBool] );
#! @EndGroup



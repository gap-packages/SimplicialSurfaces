#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2018
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

# The name "Library" can be a source of misunderstandings (actually happened
# to some students), since it shares
# terminology with "software libraries". Since the term is establishes in
# GAP, we do not want to unilaterally deviate from it (and create confusion
# for more regular users of GAP). Still, our terminology (in particular
# our headings) should try to break with the language of software libraries.
# If we do this properly, people who only know software libraries will
# recognize that something is off and decide to investigate it.


# The title includes "predefined" so that even if someone were to 
# misunderstand "library" as "software library", they will still
# check out this chapter if they search for surfaces "that are already defined"
#! @Chapter Library of predefined surfaces
#! @ChapterLabel Library
#! 
#! While chapter <Ref Chap="Chapter_Constructors"/> described how to construct
#! polygonal complexes from their incidence structure, this chapter describes
#! how to access the pre-defined surfaces and complexes in this package.
#!
#! The library serves two main purposes:
#! * It is a collection of a large number of polygonal complexes that
#!   can be used to test theories. This collection will change over
#!   time when new surfaces are added. The collection can be accessed
#!   in this way by methods like <K>AllSimplicialSurfaces</K>
#!   (<Ref Subsect="Library_AllTwistedPolygonalComplexes"/>).
#! * For certain classes of polygonal complexes (like simplicial spheres)
#!   it provides a complete classification (within certain bounds). These
#!   lists are complete and can be the basis for theorems. They are
#!   presented in section <Ref Sect="Section_Library_Classifications"/>.
#!
#!
#! Section <Ref Sect="Section_Library_Usage"/> explains the main
#! syntax that is used to access the library. It also contains the 
#! methods to access the complete collection of complexes.
#!
#! Section <Ref Sect="Section_Library_Classifications"/> covers the
#! specific classes of polygonal complexes that are (fully) contained
#! in the package.

#! @Section Accessing all stored complexes
#! @SectionLabel Library_Usage
#!
#! This section explains how all polygonal complexes that are stored
#! in the library can be accessed. This is done by the method
#! <K>AllTwistedPolygonalComplexes</K> (<Ref Subsect="Library_AllTwistedPolygonalComplexes"/>),
#! but it can also be restricted further, for example by
#! <K>AllSimplicialSurfaces</K>.
#!
#! The syntax of this call can be a bit confusing at first, since it was
#! chosen to give the user much flexibility. We will start with a few 
#! examples. The call
#! @BeginExampleSession 
#! gap> AllSimplicialSurfaces( NumberOfFaces, 3 );
#! [ simplicial surface (3 vertices, 6 edges, and 3 faces)  ]
#! @EndExampleSession
#! returns all simplicial surfaces from the library that have 
#! exactly three faces.
#!
#! If we wanted all simplicial surfaces with 6, 8, or 9 edges,
#! we could use
#! @BeginExampleSession
#! gap> AllSimplicialSurfaces( NumberOfEdges, [6,8,9] );
#! [ simplicial surface (3 vertices, 9 edges, and 6 faces),
#!   simplicial surface (4 vertices, 6 edges, and 4 faces), 
#!   simplicial surface (3 vertices, 6 edges, and 3 faces), 
#!   simplicial surface (3 vertices, 6 edges, and 4 faces) ]
#! @EndExampleSession
#!
#! It is even possible to combine these restrictions. To obtain
#! all simplicial surfaces with 6 edges and 4 faces, we could use
#! @BeginExampleSession
#! gap> AllSimplicialSurfaces(NumberOfEdges, 6, NumberOfFaces, [4]);
#! [ simplicial surface (4 vertices, 6 edges, and 4 faces), 
#!   simplicial surface (3 vertices, 6 edges, and 4 faces) ]
#! @EndExampleSession
#!
#! In general, the arguments of <K>AllSimplicialSurfaces</K> alternate
#! between a function and its result (or list of possible results).
#! The strength of this syntax derives from its versatility - it
#! is actually possible to use every <E>conceivable</E> function.
#! Obviously, we can use functions defined by this package. For example,
#! the following command returns all predefined tori:
#! @BeginExampleSession
#! gap> AllPolygonalComplexes( IsConnected, true, 
#! >            IsOrientable, true, EulerCharacteristic, 0 );
#! [ simplicial surface (3 vertices, 9 edges, and 6 faces), 
#!   simplicial surface (9 vertices, 27 edges, and 18 faces), 
#!   simplicial surface (4 vertices, 12 edges, and 8 faces) ]
#! @EndExampleSession
#! Since it is tedious to always write <K>true</K>, there is a shortcut
#! implemented that interprets "missing" results as <K>true</K>: 
#! @BeginExampleSession
#! gap> AllPolygonalComplexes( IsConnected, IsOrientable, EulerCharacteristic, 0 );
#! [ simplicial surface (3 vertices, 9 edges, and 6 faces), 
#!   simplicial surface (9 vertices, 27 edges, and 18 faces), 
#!   simplicial surface (4 vertices, 12 edges, and 8 faces) ]
#! @EndExampleSession
#!
#! If this is not sufficient, any user can define their own functions
#! to search for specific surfaces. For example, if one was interested
#! in all non-orientable simplicial surfaces such that one vertex in
#! incident to every face, we could find them like this:
#! @BeginExampleSession
#! gap> HasCentralVertex := function(surface)
#! >        local intersect;
#! >        intersect := Intersection(VerticesOfFaces(surface));
#! >        return Length(intersect) > 0;
#! > end;
#! function( surface ) ... end
#! gap> AllSimplicialSurfaces(IsOrientable, false, HasCentralVertex);
#! [ simplicial surface (3 vertices, 6 edges, and 3 faces), 
#!   simplicial surface (3 vertices, 6 edges, and 4 faces), 
#!   simplicial surface (4 vertices, 12 edges, and 8 faces) ]
#! @EndExampleSession
#!

#! @BeginGroup Library_AllTwistedPolygonalComplexes
#! @Description
#! Return all twisted polygonal complexes that are stored in the library with the desired properties.
#!
#! The number of arguments can be arbitrarily long. In general the arguments
#! have to come in pairs. The first argument in such a pair is a function and
#! the second argument is either the result of that function or a list of
#! accepted results. For example
#! @BeginLog
#! gap> AllTwistedPolygonalComplexes( NumberOfVertices, [10,12], IsOrientable, false );
#! @EndLog
#! returns all non-orientable twisted polygonal complexes with 10 or 12 vertices from
#! the library.
#!
#! To obtain the platonic solids a custom function has to be written:
#! @BeginExampleSession
#! gap> DegreeRegular := function( complex )
#! >      local degrees;
#! >  
#! >      degrees := Set(FaceDegreesOfVertices(complex));
#! >      return Size(degrees) = 1 and degrees[1] >= 3;
#! >    end;;
#! gap> plat := AllPolygonalComplexes( IsPolygonalSurface, true,
#! >      EulerCharacteristic, 2, DegreeRegular, true,
#! >      IsConnected, true, IsClosedSurface, true);;
#! gap> Size(plat);
#! 5
#! @EndExampleSession
#!
#! For user convenience the following simplifications may be used:
#! * If one of the more specific incarnations, like 
#!   <K>AllSimplicialSurfaces</K> is called, the returned complexes will
#!   satisfy this additional requirement (in this case, they will be 
#!   simplicial surfaces).
#! * If the function in the first argument pair is <K>NrOfFaces</K>, it
#!   can be omitted. This is the only possible case in which the first
#!   argument is not a function.
#! * If the second argument of a pair is omitted, it is assumed to be
#!   <K>true</K>. This is especially useful if the corresponding function
#!   is a property.
#! For example, the above command for the platonic solids can be simplified
#! as follows:
#! @BeginExampleSession
#! gap> plat := AllPolygonalSurfaces( EulerCharacteristic, 2, DegreeRegular,
#! >      IsConnected, IsClosedSurface );;
#! gap> Size(plat);
#! 5
#! @EndExampleSession
#! To get just the platonic solids with triangular faces, the following
#! command may be used:
#! @BeginExampleSession
#! gap> plat := AllSimplicialSurfaces( EulerCharacteristic, 2, DegreeRegular,
#! >      IsConnected, IsClosedSurface );;
#! gap> Size(plat);
#! 3
#! @EndExampleSession
#!
#! To obtain just tetrahedron and octahedron, the number of faces can be
#! restricted:
#! @BeginExampleSession
#! gap> plat := AllPolygonalComplexes( [4,8], 
#! >               EulerCharacteristic, 2, IsConnected, IsClosedSurface );;
#! gap> Size(plat);
#! 2
#! @EndExampleSession
#!
#! @Returns a list of polygonal complexes
#! @Arguments fct1, res1, fct2, res2, ...
DeclareGlobalFunction("AllTwistedPolygonalComplexes");
#! @Arguments fct1, res1, fct2, res2, ...
DeclareGlobalFunction("AllPolygonalComplexes");
#! @Arguments fct1, res1, fct2, res2, ...
DeclareGlobalFunction("AllTriangularComplexes");
#! @Arguments fct1, res1, fct2, res2, ...
DeclareGlobalFunction("AllPolygonalSurfaces");
#! @Arguments fct1, res1, fct2, res2, ...
DeclareGlobalFunction("AllSimplicialSurfaces");
#! @EndGroup


#! @Section Accessing the classifications
#! @SectionLabel Library_Classifications
#!
#! In this section, different classifications of polygonal complexes
#! are described. In most cases, these are infinite families. The
#! documentation of each method explains in detail which part of the
#! classification can be relied upon.
#!
#! The general syntax is identical to the one from
#! <K>AllTwistedPolygonalComplexes</K> or <K>AllSimplicialSurfaces</K>
#! (<Ref Subsect="Library_AllTwistedPolygonalComplexes"/>).
#!
#! Currently, the following classes are contained in the package:
#! * <K>AllPlatonicSurfaces</K> (<Ref Subsect="Library_AllPlatonicSurfaces"/>):
#!   all platonic solids
#! * <K>AllSimplicialSpheres</K> (<Ref Subsect="Library_AllSimplicialSpheres"/>):
#!   simplicial spheres without 3--waists (i.e. each of their
#!   vertex-edge-paths (<Ref Sect="Section_Paths_VertexEdge"/>) 
#!   of length 3 is the perimeter path (<Ref Sect="Section_Paths_Perimeter"/>)
#!   of a face).
#! * <K>AllGeodesicSelfDualSurfaces</K>
#!   (<Ref Subsect="Library_AllGeodesicSelfDualSurfaces"/>): 
#!   geodesic self-dual surfaces
#! 
#! TODO needs nicer introduction and streamlining

#! @BeginGroup Library_AllSimplicialSpheres
#! @Description
#! This method has the same syntax as <K>AllTwistedPolygonalComplexes</K> and
#! <K>AllSimplicialSurfaces</K> (<Ref Subsect="Library_AllTwistedPolygonalComplexes"/>),
#! but is restricted to the simplicial spheres without 3--waists, i.e.
#! * simplicial surfaces
#! * that are homeomorphic to the sphere
#! * each of their
#!   vertex-edge-paths (<Ref Sect="Section_Paths_VertexEdge"/>) 
#!   of length 3 is the perimeter path (<Ref Sect="Section_Paths_Perimeter"/>)
#!   of a face
#!
#! Since this class is infinite, not all of them can be accessed.
#! Currently, all of those surfaces with at most 28 faces are
#! stored.
#!
#! @BeginExampleSession
#! gap> AllSimplicialSpheres([4,8,10]);
#! [ simplicial surface (7 vertices, 15 edges, and 10 faces), 
#!   simplicial surface (4 vertices, 6 edges, and 4 faces), 
#!   simplicial surface (6 vertices, 12 edges, and 8 faces) ]
#! gap> AllSimplicialSpheres(NumberOfVertices, 8);
#! [ simplicial surface (8 vertices, 18 edges, and 12 faces), 
#!   simplicial surface (8 vertices, 18 edges, and 12 faces) ]
#! @EndExampleSession
#! 
#! @Returns a list of simplicial surfaces
#! @Arguments fct1, res1, fct2, res2, ...
DeclareGlobalFunction("AllSimplicialSpheres");
#! @EndGroup

#! @BeginGroup Library_AllGeodesicSelfDualSurfaces
#! @Description
#! This method has the same syntax as <K>AllTwistedPolygonalComplexes</K> and
#! <K>AllSimplicialSurfaces</K> (<Ref Subsect="Library_AllTwistedPolygonalComplexes"/>),
#! but is restricted to the geodesic self-dual surfaces (TODO).
#!
#! Since these are (probably) infinite, this method currently only
#! gives access to the following surfaces:
#! * The unique geodesic self-dual surface of degree 5
#! * Both geodesic self-dual surfaces of degree 6
#! * The two geodesic self-dual surfaces of degree 8 that arise
#!   from a normal subgroup
#! * The geodesic self-dual surface of degree 9 that arises
#!   from the trivial subgroup
#!
#! @BeginExampleSession
#! gap> AllGeodesicSelfDualSurfaces();
#! [ simplicial surface (6 vertices, 15 edges, and 10 faces), 
#!   simplicial surface (3 vertices, 9 edges, and 6 faces), 
#!   simplicial surface (9 vertices, 27 edges, and 18 faces), 
#!   simplicial surface (21 vertices, 84 edges, and 56 faces), 
#!   simplicial surface (42 vertices, 168 edges, and 112 faces), 
#!   twisted polygonal surface (6 vertices, 24 edges, 16 faces, and 96 chambers),
#!   twisted polygonal surface (3 vertices, 12 edges, 8 faces, and 48 chambers), 
#!   simplicial surface (190 vertices, 855 edges, and 570 faces), 
#!   twisted polygonal surface (38 vertices, 171 edges, 114 faces, and 684 chambers),
#!   simplicial surface (10 vertices, 45 edges, and 30 faces) ]
#! @EndExampleSession
#! 
#! @Returns a list of simplicial surfaces
#! @Arguments fct1, res1, fct2, res2, ...
DeclareGlobalFunction("AllGeodesicSelfDualSurfaces");
#! @EndGroup

#! @BeginGroup Library_AllDiscs
#! @Description
#! This method has the same syntax as <K>AllTwistedPolygonalComplexes</K> and
#! <K>AllSimplicialSurfaces</K> (<Ref Subsect="Library_AllTwistedPolygonalComplexes"/>),
#! but is restricted to simplicial discs. (TODO)
#!
#! This list is very incomplete at the moment TODO.
#!
#! @BeginExampleSession
#! gap> discs := AllDiscs();;
#! gap> Length(discs);
#! 87
#! gap> AllDiscs(function(surf) return 7 in FaceDegreesOfVertices(surf); end);
#! []
#! gap> List(discs, UmbrellaPathsOfVertices);;
#! @EndExampleSession
#! 
#! @Returns a list of simplicial surfaces
#! @Arguments fct1, res1, fct2, res2, ...
DeclareGlobalFunction("AllDiscs");
#! @EndGroup


#! @Section Platonic solids
#! @SectionLabel Library_Platonics
#!
#! This section covers the platonic solids, i.e.
#! * <K>Tetrahedron</K> (<Ref Subsect="Tetrahedron"/>).
#! * <K>Cube</K> (<Ref Subsect="Cube"/>).
#! * <K>Octahedron()</K> (<Ref Subsect="Octahedron"/>).
#! * <K>Dodecahedron()</K> (<Ref Subsect="Dodecahedron"/>).
#! * <K>Icosahedron()</K> (<Ref Subsect="Icosahedron"/>).
#!
#! Since it might
#! be useful to see the incidence structure at a glance, every one of those 
#! methods
#! features a net of the constructed polygonal structure. Those
#! nets are constructed by the method <K>DrawSurfaceToTikz</K> 
#! (<Ref Subsect="DrawSurfaceToTikz"/>).
#!
#! It also contains the method <K>AllPlatonicSurfaces</K>
#! (<Ref Subsect="Library_AllPlatonicSurfaces"/>) to find 
#! those platonic surfaces with specified properties.

#! @BeginGroup Library_AllPlatonicSurfaces
#! @Description
#! This method has the same syntax as <K>AllTwistedPolygonalComplexes</K> and
#! <K>AllSimplicialSurfaces</K> (<Ref Subsect="Library_AllTwistedPolygonalComplexes"/>),
#! but is restricted to the platonic surfaces:
#! * Tetrahedron
#! * Cube
#! * Octahedron
#! * Dodecahderon
#! * Icosahedron
#!
#! @BeginExampleSession
#! gap> AllPlatonicSurfaces();
#! [ simplicial surface (4 vertices, 6 edges, and 4 faces), 
#!   polygonal surface (8 vertices, 12 edges, and 6 faces), 
#!   simplicial surface (6 vertices, 12 edges, and 8 faces), 
#!   polygonal surface (20 vertices, 30 edges, and 12 faces), 
#!   simplicial surface (12 vertices, 30 edges, and 20 faces) ]
#! @EndExampleSession
#! 
#! @Returns a list of polygonal surfaces
#! @Arguments fct1, res1, fct2, res2, ...
DeclareGlobalFunction("AllPlatonicSurfaces");
#! @EndGroup


#! @Description
#! Return a <E>tetrahedron</E> as a simplicial surface. A tetrahedron is the
#! platonic solid with four triangular faces. 
#! 
#! @InsertChunk Example_Tetrahedron
#!
#! @Returns a simplicial surface
DeclareOperation( "Tetrahedron", [] );

#! @Description
#! Return a <E>cube</E> as a polygonal surface. A cube is the platonic
#! solid with six square faces.
#!
#! @InsertChunk Example_Cube
#! 
#! @Returns a polygonal surface
DeclareOperation( "Cube", [] );

#! @Description
#! Return an <E>octahedron</E> as a simplicial surface. An octahedron is the
#! platonic solid with eight triangular faces.
#! 
#! @InsertChunk Example_Octahedron
#!
#! @Returns a simplicial surface
DeclareOperation( "Octahedron", [] );


#! @Description
#! Return a <E>dodecahedron</E> as a polygonal surface. A dodecahedron ist the
#! platonic solid with 12 pentagon faces.
#! 
#! @InsertChunk Example_Dodecahedron
#!
#! @Returns a polygonal surface
DeclareOperation( "Dodecahedron", [] );

#! @Description
#! Return an <E>icosahedron</E> as a simplicial surface. An icosahedron is the
#! platonic solid with 20 triangular faces.
#! 
#! @InsertChunk Example_Icosahedron
#! 
#! @Returns a simplicial surface
DeclareOperation( "Icosahedron", [] );



#! @Section Other pre-defined surfaces
#! @SectionLabel Library_Uncategorised
#!
#! This section contains all other pre-defined surfaces that are not
#! covered in one of the other sections.


#! @Description
#! Return a <E>Janus-Head</E> as a simplicial surface. A Janus-Head consists
#! of two triangular faces that share three edges.
#! 
#! @InsertChunk Example_JanusHead
#! 
#! @Returns a simplicial surface
DeclareOperation( "JanusHead", [] );



#! @BeginGroup SimplicialUmbrella
#! @Description
#! Return a simplicial surface consisting of one closed umbrella-path
#! with <A>nrFaces</A> triangles. The labels are assigned according
#! to the following illustration, in which <M>n</M> is <A>nrFaces</A>:
 
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src='./images/_Wrapper_library-1-1.svg'> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_library-1.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
            #! </Alt>
#!
#! @ExampleSession
#! gap> umb4 := SimplicialUmbrella(4);
#! simplicial surface (5 vertices, 8 edges, and 4 faces)
#! gap> VerticesOfEdges(umb4);
#! [ [ 1, 5 ], [ 2, 5 ], [ 3, 5 ], [ 4, 5 ], [ 1, 2 ], [ 2, 3 ], [ 3, 4 ], [ 1, 4 ] ]
#! gap> EdgesOfFaces(umb4);
#! [ [ 1, 2, 5 ], [ 2, 3, 6 ], [ 3, 4, 7 ], [ 1, 4, 8 ] ]
#! gap> VerticesOfFaces(umb4);
#! [ [ 1, 2, 5 ], [ 2, 3, 5 ], [ 3, 4, 5 ], [ 1, 4, 5 ] ]
#! gap> umb2 := SimplicialUmbrella(2);
#! simplicial surface (3 vertices, 4 edges, and 2 faces)
#! gap> VerticesOfEdges(umb2);
#! [ [ 1, 3 ], [ 2, 3 ], [ 1, 2 ], [ 1, 2 ] ]
#! gap> EdgesOfFaces(umb2);
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ] ]
#! @EndExampleSession
#!
#!
#! @Returns a simplicial surface
#! @Arguments nrFaces
DeclareOperation( "SimplicialUmbrella", [ IsPosInt ] );
#! @EndGroup

#! <ManSection Label="SimplicialDoubleUmbrella"> 
#!   <Oper Name="SimplicialDoubleUmbrella" Arg="nrFaces" Label="for IsPosInt"/>
#!   <Filt Name="SimplicialDoubleGon" Arg="nrFaces" Type="operation"/>
#!   <Returns><K>a simplicial surface</K></Returns>
#!   <Description>
#!   Return a simplicial surface consisting of two closed umbrella-path
#!   with <A>nrFaces</A> triangles which are joined at their boundary. 
#!   The labels of one umbrella are assigned according to the illustration for <E>SimplicialUmbrella</E>,
#!   the additional vertex is labelled with <A>nrFaces+2</A>, the incident edges to this vertex 
#!   are labelled from <A>2*nrFaces+1</A> to <A>4*nrFaces</A> and the incident faces are labelled from
#!   <A>nrFaces+1</A> to <A>2*nrFaces</A>.
#! @ExampleSession
#! gap> doubleumb2:=SimplicialDoubleUmbrella(2);
#! simplicial surface (4 vertices, 6 edges, and 4 faces)
#! gap> VerticesOfEdges(doubleumb2);
#! [ [ 1, 3 ], [ 2, 3 ], [ 1, 2 ], [ 1, 2 ], [ 1, 4 ], [ 2, 4 ] ]
#! gap> EdgesOfFaces(doubleumb2);
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 3, 5, 6 ], [ 4, 5, 6 ] ]
#! gap> doubleumb4:=SimplicialDoubleUmbrella(4);
#! simplicial surface (6 vertices, 12 edges, and 8 faces)
#! gap> IsIsomorphic(doubleumb4,Octahedron());
#! true
#! @EndExampleSession
#!   </Description>
#! </ManSection>
# here no AutoDoc documentation since synonyms can't be handled automatically
DeclareOperation("SimplicialDoubleUmbrella", [ IsPosInt ] );
DeclareSynonym("SimplicialDoubleGon", SimplicialDoubleUmbrella);

#! @BeginGroup SimplicialOpenGeodesic
#! @Description
#! Return a simplicial surface consisting of one non-closed geodesic-path
#! with <A>nrFaces</A> triangles. The labels are assigned according
#! to the following illustration (for <M>n</M> odd), 
#! in which <M>n</M> is <A>nrFaces</A>.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_SimplicialOpenGeodesic-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_SimplicialOpenGeodesic.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!
#! @ExampleSession
#! gap> geo4 := SimplicialOpenGeodesic(4);
#! simplicial surface (6 vertices, 9 edges, and 4 faces)
#! gap> VerticesOfEdges(geo4);
#! [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ], [ 2, 4 ], [ 3, 4 ], [ 3, 5 ], [ 4, 5 ], 
#!   [ 4, 6 ], [ 5, 6 ] ]
#! gap> EdgesOfFaces(geo4);
#! [ [ 1, 2, 3 ], [ 3, 4, 5 ], [ 5, 6, 7 ], [ 7, 8, 9 ] ]
#! gap> VerticesOfFaces(geo4);
#! [ [ 1, 2, 3 ], [ 2, 3, 4 ], [ 3, 4, 5 ], [ 4, 5, 6 ] ]
#! gap> 
#! gap> geo5 := SimplicialStrip(5);
#! simplicial surface (7 vertices, 11 edges, and 5 faces)
#! gap> VerticesOfEdges(geo5);
#! [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ], [ 2, 4 ], [ 3, 4 ], [ 3, 5 ], [ 4, 5 ], 
#!   [ 4, 6 ], [ 5, 6 ], [ 5, 7 ], [ 6, 7 ] ]
#! gap> EdgesOfFaces(geo5);
#! [ [ 1, 2, 3 ], [ 3, 4, 5 ], [ 5, 6, 7 ], [ 7, 8, 9 ], [ 9, 10, 11 ] ]
#! @EndExampleSession
#!
#!
#! @Returns a simplicial surface
#! @Arguments nrFaces
DeclareOperation( "SimplicialOpenGeodesic", [ IsPosInt ] );
#! @Arguments nrFaces
DeclareOperation( "SimplicialStrip", [ IsPosInt ] );
#! @EndGroup

#! @BeginGroup SimplicialClosedGeodesic
#! @Description
#! Return a simplicial surface consisting of one closed geodesic-path
#! with <A>nrFaces</A> triangles (at least 3 faces are needed). 
#! The labels are assigned according
#! to the following illustration (for <M>n</M> odd), 
#! in which <M>n</M> is <A>nrFaces</A>.
#!  <Alt Only="HTML">
#! &lt;br>&lt;img src="./images/_Wrapper_Image_SimplicialClosedGeodesic-1.svg"> &lt;/img> &lt;br>
#! </Alt>
#! <Alt Only = "LaTeX">
#! \begin{center}
#! \includegraphics{images/_Wrapper_Image_SimplicialClosedGeodesic.pdf}
#! \end{center}
#! </Alt>
#! <Alt Only = "Text">
#! Image omitted in terminal text
#! </Alt>
#!
#! @ExampleSession
#! gap> geo3 := SimplicialClosedGeodesic(3);
#! simplicial surface (3 vertices, 6 edges, and 3 faces)
#! gap> VerticesOfEdges(geo3);
#! [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ], [ 1, 2 ], [ 1, 3 ], [ 2, 3 ] ]
#! gap> EdgesOfFaces(geo3);
#! [ [ 1, 2, 3 ], [ 3, 4, 5 ], [ 1, 5, 6 ] ]
#! gap> VerticesOfFaces(geo3);
#! [ [ 1, 2, 3 ], [ 1, 2, 3 ], [ 1, 2, 3 ] ]
#! gap> 
#! gap> geo6 := SimplicialGeodesic(6);
#! simplicial surface (6 vertices, 12 edges, and 6 faces)
#! gap> VerticesOfEdges(geo6);
#! [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ], [ 2, 4 ], [ 3, 4 ], [ 3, 5 ], [ 4, 5 ],
#!   [ 4, 6 ], [ 5, 6 ], [ 1, 5 ], [ 1, 6 ], [ 2, 6 ] ]
#! gap> EdgesOfFaces(geo6);
#! [ [ 1, 2, 3 ], [ 3, 4, 5 ], [ 5, 6, 7 ], [ 7, 8, 9 ], [ 9, 10, 11 ], [ 1, 11, 12 ] ]
#! @EndExampleSession
#!
#!
#! @Returns a simplicial surface
#! @Arguments nrFaces
DeclareOperation( "SimplicialClosedGeodesic", [ IsPosInt ] );
#! @Arguments nrFaces
DeclareOperation( "SimplicialGeodesic", [ IsPosInt ] );
#! @EndGroup



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

#TODO "Library" can raise erroneous assumptions (like libraries in C).
# "Using the library" mirrors the language there as well. Maybe rename
# to "Collection" or similar others? But this conflicts with established
# names for other libraries in GAP..

#! @Chapter Library of surfaces
#! @ChapterLabel Library
#! 
#! While chapter <Ref Chap="Chapter_Constructors"/> described how to construct
#! polygonal complexes from their incidence structure, this chapter describes
#! how to access the pre-defined surfaces and complexes in this package.
#!
#! The main feature is the library access <K>AllVEFComplexes</K>, which
#! is similar to the group libraries of &GAP;
#!
#! TODO complete introduction, maybe discuss some of the pre-defined structures?

#! @Section Using the library
#! @SectionLabel Library_Usage
#!
#! This section explains the functionality of the library method
#! <K>AllVEFComplexes</K> (<Ref Subsect="Library_AllVEFComplexes"/>).
#!

#! @BeginGroup Library_AllVEFComplexes
#! @Description
#! Return all VEF-complexes of the library with the desired properties.
#!
#! The number of arguments can be arbitrarily long. In general the arguments
#! have to come in pairs. The first argument in such a pair is a function and
#! the second argument is either the result of that function or a list of
#! accepted results. For example
#! @BeginLog
#! gap> AllVEFComplexes( NrOfVertices, [10,12], IsOrientable, false );
#! @EndLog
#! returns all non-orientable VEF-complexes with 10 or 12 vertices from
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
#! gap> plat := AllPolygonalComplexes( [4,8], EulerCharacteristic, 2, IsConnected, IsClosedSurface );;
#! gap> Size(plat);
#! 2
#! @EndExampleSession
#!
#! @Returns a list of polygonal complexes
#! @Arguments fct1, res1, fct2, res2, ...
DeclareGlobalFunction("AllVEFComplexes");
#! @Arguments fct1, res1, fct2, res2, ...
DeclareGlobalFunction("AllPolygonalComplexes");
#! @Arguments fct1, res1, fct2, res2, ...
DeclareGlobalFunction("AllTriangularComplexes");
#! @Arguments fct1, res1, fct2, res2, ...
DeclareGlobalFunction("AllPolygonalSurfaces");
#! @Arguments fct1, res1, fct2, res2, ...
DeclareGlobalFunction("AllSimplicialSurfaces");
#! @Arguments fct1, res1, fct2, res2, ...
DeclareGlobalFunction("AllBendPolygonalComplexes");
#! @EndGroup

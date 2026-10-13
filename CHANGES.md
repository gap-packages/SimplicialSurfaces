This file describes changes in the SimplicialSurfaces package.

## Unreleased

- Add simplicial complexes: `IsSimplicialComplex`,
  `SimplicialComplexByDownwardIncidence`, `SimplicialComplexByUpwardIncidence`,
  `SimplicialComplexByVerticesInFaces` (with `NC` variants) and
  `PureSimplicialComplex` (#373)
- Add `IsNotTwisted` and `IsFacePure`; `IsPolygonalComplex` is now a synonym
  for `IsTwistedPolygonalComplex and IsNotTwisted` (#373)
- Add `IsolatedVertices`, `IsolatedEdges`, `IsIsolatedVertex` and
  `IsIsolatedEdge` (#373)
- Change the `...ByDownwardIncidence`, `...ByUpwardIncidence` and
  `...ByVerticesInFaces` constructors: they no longer take explicit lists of
  vertices, edges and faces; complex constructors instead accept optional
  isolated vertices (and isolated edges) (#373)
- Fix `IsIsomorphic` ignoring isolated vertices (#386), and include isolated
  vertices in the `String` of a polygonal complex (#387)
- `TypeOfCounter` now returns the counter name instead of printing it; fix the
  misspelt name of `CounterOfButterflies` in counter output (#384)

## 0.8 (2026-05-15)

- Add `ButterflyDeletion` and `ButterflyDeletionNC` for simplicial surfaces
  (#335)
- Add `EdgeInsertion`, `EdgeReduction` and `NewGraphsForEdgeInsertion` (with
  `NC` variants) for digraphs (#328)
- Add an optional `checkOrientation` argument to `UmbrellaDescriptorOfSurface`
  and `UmbrellaTipDescriptorOfSurface` to compute oriented descriptors (#345)
- Add `FaceListOfSimplexRing`, `FaceListOfSimplexString` (#341) and
  `AllSimplicialSurfacesByFacesOfEdges`
- Change the required AttributeScheduler version to >= 0.1
- Reorder the manual, add a bibliography and use consistent definitions of
  star and link (#337, #340, #357)

## 0.7 (2025-04-11)

- Require GAP >= 4.12 (#275) and the Digraphs package (#265); GRAPE is no
  longer required (#315)
- Remove the JavaScript animation code, including `DrawSurfaceToJavaScript`;
  use the GAPic package instead (#318)
- Rename `IsConnected`, `IsStronglyConnected` and `IsOrientable` to
  `IsConnectedSurface`/`IsConnectedComplex` etc., and add `IsClosedComplex`
  (#307)
- Replace `VertexCounter`, `EdgeCounter`, `FaceCounter` and
  `VertexCounterByAngle` by counter objects `CounterOfVertices`,
  `CounterOfEdges`, `CounterOfFaces` and `CounterOfVerticesByAngle`; add
  `CounterOfButterflies`, `CounterOfUmbrellas` and `CounterOfThreeFaces`
  (#177, #221, #304)
- Add butterfly insertion: `ButterflyInsertion`,
  `AllSimplicialSurfacesByEssentialButterflyInsertion`,
  `ButterflyFaithfulMonomorphismIntoSimplicialSurface` and
  `AllButterflyFaithfulMonomorphismsIntoSimplicialSurface` (#263, #284)
- Add face graph functions: `DrawFacegraphToTikz`, `DrawConvexFacegraphToTikz`,
  `AllSimplicialSurfacesOfDigraph`, `ReembeddingsOfDigraph` and
  `ReembeddingsOfSimplicialSphere`; add `DrawComplexToSVG` (#172, #178, #262,
  #301, #303)
- Add umbrella descriptor functions: `NormedUmbrellaDescriptor`,
  `UmbrellaTipDescriptorOfSurface`, `DegreeSequenceOfUmbrellaDescriptor` and
  `AllUmbrellaDescriptorsOfDegreeSequence` (#204, #240)
- Add `EdgeTurn`, `TurnableEdges`, `TetrahedralExtension`,
  `TetrahedralReduction`, `JoinFaces`, `JoinBoundary`, `Star`, `Link`,
  `FaceTwoColouring`, waist functions such as `AllWaistsOfComplex`,
  `AllToriOfSimplicialSphere`, `SimplicialSurfaceByDressGroup`,
  `AdmissibleRelationsOfSurface`, simplex rings and strings, and more (#142,
  #146, #176, #179, #182, #185, #214, #219, #228, #242, #310)
- Speed up `IsIsomorphic` (#254, #292)
- Fix `CanonicalRepresentativeOfPolygonalSurface` (#287),
  `ConcatenationOfPaths` (#272) and the automorphism group action on edges
  and faces

## 0.6 (2021-09-23)

- Add twisted polygonal complexes, described by chambers and their
  adjacencies, e.g. `TwistedPolygonalComplexByChamberRelations` (#119)
- Add isosceles coloured surfaces: `AllIsoscelesColouredSurfaces`,
  `IsIsoscelesColouredSurface` and
  `WildColouredSurfaceOfIsoscelesColouredSurface` (#118)
- Add `DrawSurfaceToJavaScript` for interactive 3D drawings, with control over
  colours, transparency and visibility of elements (#113, #116)
- Add `UmbrellaDescriptorOfSurface` and `SimplicialSurfaceByUmbrellaDescriptor`
  (#120)
- Add `ConcatenationOfPaths`, `ShiftCyclicPath`, `JoinBoundariesNC`,
  `CommonEdgesOfFaces` and similar incidence functions, and let `JoinEdges`
  accept a list (#124, #128, #130, #133)
- Require GAP >= 4.11 (#122)

## 0.5 (2019-12-02)

## 0.1 (2017-07-07)

## 0.0.1 (2016-11-15)

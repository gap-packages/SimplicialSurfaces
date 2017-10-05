Read("../AttributeScheduler/AttributeScheduler.gd");
Read("../AttributeScheduler/AttributeScheduler.gi");

Read("./main.gd");
Read("./polygonal_hierarchy.gd");
Read("./incidence_geometry.gd");
Read("./constructors.gd");

Read("./main.gi");
Read("./polygonal_hierarchy.gi");
Read("./incidence_geometry.gi");
Read("./constructors.gi");



verticesOfEdges := [[1,2],[1,3],[2,3],[2,3]];;
edgesOfFaces := [[1,2,4],[1,2,3]];;
bag := SimplicialSurfaceByDownwardIncidence( verticesOfEdges, edgesOfFaces);;

if IsPackageMarkedForLoading( "Digraphs", ">=0.10.1" ) then
	BindGlobal( "__SIMPLICIAL_Test_IncidenceDigraphsGraph", function()
		local digTetra, digTetraEdges, vertex, edges, edge, faces;
		digTetra:=IncidenceDigraphsGraph(Tetrahedron());
		digTetraEdges:=ShallowCopy(DigraphEdges(digTetra));
		Assert(0,Length(digTetraEdges)=48);
		for edge in [1..Length(digTetraEdges)] do
			digTetraEdges[edge]:=[DigraphVertexLabel(digTetra,digTetraEdges[edge][1]),DigraphVertexLabel(digTetra,digTetraEdges[edge][2])];
		od;
		
		for vertex in EdgesOfVertices(Tetrahedron()) do
			for edges in vertex do
				Assert(0,[Position(EdgesOfVertices(Tetrahedron()),vertex),edges+Last(Vertices(Tetrahedron()))] in digTetraEdges);
			od;
		od;
		
		for edge in FacesOfEdges(Tetrahedron()) do
			for faces in edge do
				Assert(0,[Position(FacesOfEdges(Tetrahedron()),edge)+Last(Vertices(Tetrahedron())),faces+Last(Vertices(Tetrahedron()))+
				Last(Edges(Tetrahedron()))] in digTetraEdges);
			od;
		od;
	end);
	
	BindGlobal( "__SIMPLICIAL_Test_EdgeDigraphsGraph", function()
		local digTetra, eye, digEye;
		digTetra:=EdgeDigraphsGraph(Tetrahedron());
		Assert(0, DigraphEdges(digTetra)=VerticesOfEdges(Tetrahedron()));
		
		eye := PolygonalComplexByDownwardIncidence([[1,2],[2,3],[1,3],[2,4],[3,4],[2,3]],[[1,2,3],[4,5,6]]);
		digEye:=EdgeDigraphsGraph(eye);
		Assert(0, DigraphEdges(digEye)=VerticesOfEdges(eye));
	end);

fi;

if IsPackageMarkedForLoading( "GRAPE", ">=0" ) then
	BindGlobal( "__SIMPLICIAL_Test_IncidenceGrapeGraph", function()
		local grapeTetra, grapeTetraEdges, vertex, edges, edge, faces;
		grapeTetra:=IncidenceGrapeGraph(Tetrahedron()).graph;
		grapeTetraEdges:=DirectedEdges(grapeTetra);
		Assert(0,Length(grapeTetraEdges)=48);
		for vertex in [1..Length(EdgesOfVertices(Tetrahedron()))] do
			for edges in EdgesOfVertices(Tetrahedron())[vertex] do
				Assert(0,[vertex,edges+Last(Vertices(Tetrahedron()))] in grapeTetraEdges);
			od;
		od;
		
		for edge in [1..Length(FacesOfEdges(Tetrahedron()))] do
			for faces in FacesOfEdges(Tetrahedron())[edge] do
				Assert(0,[edge+Last(Vertices(Tetrahedron())),faces+Last(Vertices(Tetrahedron()))+Last(Edges(Tetrahedron()))] in grapeTetraEdges);
			od;
		od;
	end);
	
	BindGlobal( "__SIMPLICIAL_Test_EdgeGrapeGraph", function()
		local grapeTetra, eye, grapeEye,reversedTetra, reversedEye, vertices;
		grapeTetra:=EdgeGrapeGraph(Tetrahedron());
		reversedTetra:=[];
		for vertices in VerticesOfEdges(Tetrahedron()) do
			Add(reversedTetra,Reversed(vertices));
		od;
		Assert(0, DirectedEdges(grapeTetra)=Union(VerticesOfEdges(Tetrahedron()),reversedTetra));
		

		eye := PolygonalComplexByDownwardIncidence([[1,2],[2,3],[1,3],[2,4],[3,4],[2,3]],[[1,2,3],[4,5,6]]);
		grapeEye:=EdgeGrapeGraph(eye);
		reversedEye:=[];
		for vertices in VerticesOfEdges(eye) do
			Add(reversedEye,Reversed(vertices));
		od;
		Assert(0, DirectedEdges(grapeEye)=Union(VerticesOfEdges(eye),reversedEye));
	end);
fi;

if IsPackageMarkedForLoading("NautyTracesInterface", ">=0") then
	BindGlobal( "__SIMPLICIAL_Test_IncidenceNautyGraph", function()
		local nautyTetra, nautyTetraEdges, vertex, edges, edge, faces;
		nautyTetra:=UnderlyingNautyGraph(IncidenceNautyGraph(Tetrahedron()));
		nautyTetraEdges:=nautyTetra!.edges;
		Assert(0,Length(nautyTetraEdges)=24);
		
		for vertex in [1..Length(EdgesOfVertices(Tetrahedron()))] do
			for edges in EdgesOfVertices(Tetrahedron())[vertex] do
				Assert(0,[vertex,edges+NumberOfVertices(Tetrahedron())] in nautyTetraEdges);
			od;
		od;
		
		for edge in [1..Length(FacesOfEdges(Tetrahedron()))] do
			for faces in FacesOfEdges(Tetrahedron())[edge] do
				Assert(0,[edge+NumberOfVertices(Tetrahedron()),faces+NumberOfVertices(Tetrahedron())+NumberOfEdges(Tetrahedron())] in nautyTetraEdges);
			od;
		od;
	end);
	
	BindGlobal( "__SIMPLICIAL_Test_EdgeNautyGraph", function()
		local nautyTetra, eye, nautyEye;
		nautyTetra:=UnderlyingNautyGraph(EdgeNautyGraph(Tetrahedron()));
		Assert(0, nautyTetra!.edges=VerticesOfEdges(Tetrahedron()));

		eye := PolygonalComplexByDownwardIncidence([[1,2],[2,3],[1,3],[2,4],[3,4],[2,3]],[[1,2,3],[4,5,6]]);
		nautyEye:=UnderlyingNautyGraph(EdgeNautyGraph(eye));
		Assert(0, nautyEye!.edges=VerticesOfEdges(eye));
	end);
fi;

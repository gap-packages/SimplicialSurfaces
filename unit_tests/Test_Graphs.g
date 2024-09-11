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
		local digTetra, reversedTetra, vertices, eye, digEye, reversedEye;
		digTetra:=EdgeDigraphsGraph(Tetrahedron());
		reversedTetra:=[];
                for vertices in VerticesOfEdges(Tetrahedron()) do
                        Add(reversedTetra,Reversed(vertices));
                od;
		Assert(0, Set(DigraphEdges(digTetra))=Set(Union(VerticesOfEdges(Tetrahedron()),reversedTetra)));
		
		eye := PolygonalComplexByDownwardIncidence([[1,2],[2,3],[1,3],[2,4],[3,4],[2,3]],[[1,2,3],[4,5,6]]);
		digEye:=EdgeDigraphsGraph(eye);
		reversedEye:=[];
                for vertices in VerticesOfEdges(eye) do
                        Add(reversedEye,Reversed(vertices));
                od;
                Assert(0, Set(DigraphEdges(digEye))=Set(Union(VerticesOfEdges(eye),reversedEye)));
	end);

	BindGlobal( "__SIMPLICIAL_Test_FaceDigraphsGraph", function()
		local digTetra, butterfly, digButterfly, reversedTetra, reversedButterfly, faces;
		digTetra:=FaceDigraphsGraph(Tetrahedron());
		reversedTetra:=[];
		for faces in FacesOfEdges(Tetrahedron()) do
			Add(reversedTetra,Reversed(faces));
		od;
		Assert(0, Set(DigraphEdges(digTetra))=Set(Union(FacesOfEdges(Tetrahedron()),reversedTetra)));
		
		butterfly := SimplicialSurfaceByDownwardIncidence([[1,2],[1,3],[2,3],[2,4],[3,4]],[[1,2,3],[3,4,5]]);
		digButterfly:=FaceDigraphsGraph(butterfly);
		reversedButterfly:=[];
		for faces in FacesOfEdges(butterfly) do
			if Length(faces)=2 then 
				Add(reversedButterfly,Reversed(faces));
			else
				Add(reversedButterfly,[faces[1],faces[1]]);
			fi;
		od;
		Assert(0, Set(DigraphEdges(digButterfly))=Set(Filtered(Union(FacesOfEdges(butterfly),reversedButterfly),i->Length(i)=2)));
	end);

	BindGlobal( "__SIMPLICIAL_Test_AllSimplicialSurfacesOfDigraph", function()
		local dig, surface, list1, list2;
		surface:=SimplicialSurfaceByVerticesInFaces([[1,4,5],[1,4,6],[1,5,7],[1,6,7],[2,3,5],[2,3,6],[2,4,5],[2,4,6],[3,5,7],[3,6,7]]);
		dig:=FaceDigraphsGraph(surface);
		list1:=AllSimplicialSurfacesOfDigraph(dig,true);
		Assert(0,Length(list1)=1);
		Assert(0,IsIsomorphic(list1[1],surface));
	
		list2:=AllSimplicialSurfacesOfDigraph(dig);
		Assert(0, Length(Filtered(list2,IsVertexFaithful))=1);
		Assert(0,IsIsomorphic(Filtered(list2,IsVertexFaithful)[1],surface));
		Assert(0,Length(list2)=11);

		dig:=DigraphByEdges([ [ 1, 2 ], [ 1, 4 ], [ 1, 5 ], [ 2, 1 ], [ 2, 3 ], [ 2, 6 ], [ 3, 2 ], [ 3, 4 ], [ 3, 5 ], [ 4, 1 ], [ 4, 3 ], 
					[ 4, 6 ], [ 5, 1 ],[ 5, 3 ], [ 5, 6 ], [ 6, 2 ], [ 6, 4 ], [ 6, 5 ] ]);
		list1:=AllSimplicialSurfacesOfDigraph(dig,true);
		list2:=AllSimplicialSurfacesOfDigraph(dig,false);
		Assert(0,Length(list1)=0);
		Assert(0,Length(list2)=2);

		#One of the smallest face graph with more than one vertex-faithful surface
		dig:=DigraphByEdges([ [ 1, 9 ], [ 9, 1 ], [ 1, 13 ], [ 13, 1 ], [ 1, 14 ], [ 14, 1 ], [ 2, 6 ], [ 6, 2 ], [ 2, 7 ], [ 7, 2 ], [ 2, 10 ], 
					[ 10, 2 ], [ 3, 10 ],[ 10, 3 ], [ 3, 15 ], [ 15, 3 ], [ 3, 16 ], [ 16, 3 ], [ 4, 6 ], [ 6, 4 ], [ 4, 8 ], [ 8, 4 ], 
					[ 4, 9 ], [ 9, 4 ], [ 5, 6 ], [ 6, 5 ], [ 5, 12 ], [ 12, 5 ],[ 5, 14 ], [ 14, 5 ], [ 7, 8 ], [ 8, 7 ], [ 7, 13 ], [ 13, 7 ], 
					[ 8, 11 ], [ 11, 8 ], [ 9, 10 ], [ 10, 9 ], [ 11, 12 ], [ 12, 11 ], [ 11, 15 ], [ 15, 11 ], [ 12, 16 ], [ 16, 12 ], 
					[ 13, 14 ], [ 14, 13 ], [ 15, 16 ], [ 16, 15 ] ]);
		list1:=AllSimplicialSurfacesOfDigraph(dig,true);
		Assert(0,Length(list1)=2);
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

	BindGlobal( "__SIMPLICIAL_Test_FaceNautyGraph", function()
		local nautyTetra, butterfly, nautyButterfly, edges, faces;
		nautyTetra:=UnderlyingNautyGraph(FaceNautyGraph(Tetrahedron()));
		
		Assert(0, Set(nautyTetra!.edges)=Set(FacesOfEdges(Tetrahedron())));
		
		butterfly := SimplicialSurfaceByDownwardIncidence([[1,2],[1,3],[2,3],[2,4],[3,4]],[[1,2,3],[3,4,5]]);
		nautyButterfly:=UnderlyingNautyGraph(FaceNautyGraph(butterfly));
		edges:=ShallowCopy(FacesOfEdges(butterfly));
		for faces in FacesOfEdges(butterfly) do
			if Length(faces)=1 then 
				Add(edges,[faces[1],faces[1]]);
			fi;
		od;
		Assert(0, Set(nautyButterfly!.edges)=Set(Filtered(edges,i->Length(i)=2)));
	end);
fi;

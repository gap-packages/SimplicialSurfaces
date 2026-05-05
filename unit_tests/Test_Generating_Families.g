if IsPackageMarkedForLoading( "Digraphs", ">=1.9.0" ) then
	BindGlobal( "__SIMPLICIAL_Test_AllSimplicialSurfacesOfDigraph", function()
		local dig, surface, list1, list2;
		surface:=SimplicialSurfaceByVerticesInFaces([[1,4,5],[1,4,6],[1,5,7],[1,6,7],[2,3,5],[2,3,6],[2,4,5],[2,4,6],[3,5,7],[3,6,7]]);
		dig:=FaceDigraphsGraph(surface);
	
		list2:=AllSimplicialSurfacesOfDigraph(dig);
		Assert(0, Length(Filtered(list2,IsVertexFaithful))=1);
		Assert(0,IsIsomorphic(Filtered(list2,IsVertexFaithful)[1],surface));
		Assert(0,Length(list2)=11);

		list1:=AllSimplicialSurfacesOfDigraph(dig,true);
                Assert(0,Length(list1)=1);
                Assert(0,IsIsomorphic(list1[1],surface));

		dig:=DigraphByEdges([ [ 1, 2 ], [ 1, 4 ], [ 1, 5 ], [ 2, 1 ], [ 2, 3 ], [ 2, 6 ], [ 3, 2 ], [ 3, 4 ], [ 3, 5 ], [ 4, 1 ], [ 4, 3 ], 
					[ 4, 6 ], [ 5, 1 ],[ 5, 3 ], [ 5, 6 ], [ 6, 2 ], [ 6, 4 ], [ 6, 5 ] ]);
		list1:=AllSimplicialSurfacesOfDigraph(dig,false);
		list2:=AllSimplicialSurfacesOfDigraph(dig,true);
		Assert(0,Length(list1)=2);
		Assert(0,Length(list2)=0);

		# One of the smallest face graph with more than one vertex-faithful surface
		dig:=DigraphByEdges([ [ 1, 9 ], [ 9, 1 ], [ 1, 13 ], [ 13, 1 ], [ 1, 14 ], [ 14, 1 ], [ 2, 6 ], [ 6, 2 ], [ 2, 7 ], [ 7, 2 ], [ 2, 10 ], 
					[ 10, 2 ], [ 3, 10 ],[ 10, 3 ], [ 3, 15 ], [ 15, 3 ], [ 3, 16 ], [ 16, 3 ], [ 4, 6 ], [ 6, 4 ], [ 4, 8 ], [ 8, 4 ], 
					[ 4, 9 ], [ 9, 4 ], [ 5, 6 ], [ 6, 5 ], [ 5, 12 ], [ 12, 5 ],[ 5, 14 ], [ 14, 5 ], [ 7, 8 ], [ 8, 7 ], [ 7, 13 ], [ 13, 7 ], 
					[ 8, 11 ], [ 11, 8 ], [ 9, 10 ], [ 10, 9 ], [ 11, 12 ], [ 12, 11 ], [ 11, 15 ], [ 15, 11 ], [ 12, 16 ], [ 16, 12 ], 
					[ 13, 14 ], [ 14, 13 ], [ 15, 16 ], [ 16, 15 ] ]);
		list1:=AllSimplicialSurfacesOfDigraph(dig,true);
		Assert(0,Length(list1)=2);

		Assert(0,Length(AllSimplicialSurfacesByFacesOfEdges (Tetrahedron()))=2);
		Assert(0,Length(AllSimplicialSurfacesByFacesOfEdges (Tetrahedron(),true))=1);
	end);
else
	BindGlobal( "__SIMPLICIAL_Test_AllSimplicialSurfacesOfDigraph", function() end);
fi;


if IsPackageMarkedForLoading( "Digraphs", ">=1.10.0" ) then
	BindGlobal( "__SIMPLICIAL_Test_ReembeddingsOfDigraph", function()
		local digraph, reemb1, reemb2, reemb3;
		digraph:=CompleteDigraph(4);;

		reemb1:=ReembeddingsOfDigraph(digraph,1,false);
		Assert(0,Length(reemb1)=1);
		Assert(0,NumberOfVertices(reemb1[1])=3);

		reemb2:=ReembeddingsOfDigraph(digraph,1,true);
		Assert(0,reemb2=[]);

		reemb3:=ReembeddingsOfDigraph(digraph,2,false);
		Assert(0,reemb2=[]);
	end);
else
	BindGlobal( "__SIMPLICIAL_Test_ReembeddingsOfDigraph", function() end);
fi;
AllCyclesOfFaceGraph:=function(digraph)

	local AdjacencyMatrixFromList,CycleOnEdge,CycleBasisOfFaceGraph, NodesOfCycle,
	XORAdjacencyMatrices,MultipleCyclesInMatrix,cyclebasis, allcycles, nullmat, mat, i, k, pos, neighs,c,cycle;


	# We want to store graphs as adjacency matrices. This function
	# turns a cycle into a boolean lower triangular matrix.
	AdjacencyMatrixFromList := function(cycle, n)
		local mat, i, j, k;

		mat := []; 
		for i in [ 1 .. n] do
			mat[i] := BlistList([1..i],[]);
		od;

		for i in [ 1 .. Length(cycle)] do
			if i < Length(cycle) then 
				 j := cycle[i+1];
			else j := cycle[1];
			fi;
			k := cycle[i]; 
			if k < j then 
				mat[j]:= UnionBlist(mat[j],BlistList( [1..j],[k] )); 
			elif j < k then 
				mat[k] := UnionBlist(mat[k],BlistList([1..k],[j]));
			fi;
		od;
		
		 return mat;
	end;;
	   
	# Find a cycle in the original graph all of whose edges are in
	# tree except for the edge e.
	CycleOnEdge := function( tree, root, e )
			
			local cycle, i, path1, path2, l1, l2;

			if e[1] = e[2] then
				Error("CycleOnEdge: edge is  a loop");
				return false;
			fi;

			# first find paths from the root to the two vertices of e
			if root = e[1] then path1 := [root];
			else path1 := DigraphPath(tree, root, e[1])[1]; fi;
			if root = e[2] then path2 := [root];
			else path2 := DigraphPath(tree, root, e[2])[1]; fi;
			l1 := Length(path1); l2 := Length(path2);

			# now skip the common entries in the path
			cycle := []; i := 1;
			while i <= Minimum(l1,l2) and path1[i] = path2[i]  do
				  i := i + 1;
			od;
		
			cycle := [path1[i-1]];
			Append(cycle, path1{[i..l1]});
			Append(cycle, Reversed(path2{[i..l2]}));

			return AdjacencyMatrixFromList(cycle,DigraphNrVertices(tree));
	end;;

	# This function computes a cycle basis for the undirected graph
	# dig, which is assumed to be a symmetric digraph.
	# The cycle Basis consists of lower triangular matrices whose
	# entries are boolean lists.
	CycleBasisOfFaceGraph := function( dig )

		local tree, dige, base, root, e;

		if not IsSymmetricDigraph(dig) then
			Error("the digraph is assumed to be symmetric");
		fi;

		base := Set([]);
		tree := UndirectedSpanningTree(dig);
		dige := DigraphEdges(tree);

		root := DigraphVertices(dig)[1];
		
		for e in DigraphEdges(dig) do
			if not e in dige then
				AddSet(base, CycleOnEdge(tree,root, e));
			fi;
		od;
		

		return base;
	end;;

	# This method combines two adjacency matrices with the operator XOR.
	XORAdjacencyMatrices := function( mat1, mat2 )

		local j, res, nd;

			res :=[];
			for j in [1.. Length(mat1)] do
				nd := IntersectionBlist(mat1[j],mat2[j]);
				FlipBlist(nd);
				res[j] := IntersectionBlist( UnionBlist(mat1[j],mat2[j]), nd );
			od;

			return res;
	end;;
	
	# The function converts a boolean list describing one or more cycles 
	# into lists of nodes of the cycles.
	NodesOfCycle:=function(cycle)
		local edges,firstNod,actualNod,nodes,found,e,cycles;

		edges:=__SIMPLICIAL_EdgesFromAdjacencyMat(cycle);
		cycles:=[];
		# We have to use each edge exactly one time
		while edges<>[] do
			firstNod:=(edges[1])[1];
			actualNod:=(edges[1])[2];
			Remove(edges,1);
			nodes:=[actualNod];
			# Walk along the cycle
			while actualNod<>firstNod do
				found:=false;
				for e in edges do
					if found=false then
						if e[1]=actualNod then
							actualNod:=e[2];
							Add(nodes,actualNod);
							Remove(edges,Position(edges,e));
							found:=true; 
						elif e[2]=actualNod then
							actualNod:=e[1];
							Add(nodes,actualNod);
							Remove(edges,Position(edges,e));
							found:=true;
						fi;
					fi;
				od;
			od;
			Add(cycles,nodes);
		od;
		return cycles;
	end;;	

	cyclebasis := CycleBasisOfFaceGraph( digraph );
	
	if cyclebasis=[] then
		return [];
	fi;

	neighs := OutNeighbours(digraph);
	allcycles := [];
	
	nullmat := XORAdjacencyMatrices(cyclebasis[1],cyclebasis[1]);
	for k in [0..2^Length(cyclebasis)-1] do
		# combine the matrices encoded by k
		mat := nullmat;
		i := k;
		pos := 0;
		while i>0 do
			pos := pos + 1;
			if i mod 2 <> 0 then
				mat := XORAdjacencyMatrices(mat,cyclebasis[pos]);
			fi;
			i := Int(i/2);
		od;

		if SizeBlist(Flat(mat))<>0 then
			for c in NodesOfCycle(mat) do
				cycle:=AdjacencyMatrixFromList(c,Length(mat));
				if not cycle in allcycles then
					Add(allcycles,cycle);
				fi;
			od; 
		fi;
	 od;
	return allcycles;

	end;;
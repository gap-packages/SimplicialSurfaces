
AllPathsOfLengthEdge:=function(graph,k,e1,e2,path)
	local paths,edges,e,copy_edge;
	paths:=[];
	if k=0 then
		return [];
	fi;
	edges:=DigraphEdges(graph);
	edges:=Set(List(edges,i->Set(i)));
	if k=1 then
		for e in edges do
			if not e in path and e=Set([e1,e2]) then
				return [Concatenation(path,[e])];
			fi;
		od;
	fi;
	if k>1 then
		for e in edges do
			if not e in path and e2 in e then
				copy_edge:=StructuralCopy(e);
				Remove(copy_edge,Position(copy_edge,e2));
				paths:=Concatenation(paths,AllPathsOfLengthEdge(graph,k-1,e1,copy_edge[1],Concatenation(path,[e])));
			fi;
		od;
	fi;
	return paths;
end;;


act_cycle:=function(cycle,gen)
	return List(cycle,c->OnTuples(c,gen));
end;;




AllCyclesOfLength:=function(graph,k)
	local edges,cycles,e;
	g:=AutomorphismGroup(graph);
	#g:=Group(());
	edges:=DigraphEdges(graph);
	edges:=Set(List(edges,i->Set(i)));
	orbs:=OrbitsDomain(g,edges,OnSets);
	cycles:=[];
	for e in orbs do
		e:=e[1];
		cycles:=Concatenation(cycles,AllPathsOfLengthEdge(graph,k-1,e[1],e[2],[e]));
	od;
	return Concatenation(Orbits(g,cycles,act_cycle));
end;;

EdgeCycleToVertexCycle:=function(cycle)
	local vert_cycle,i,cur_edge;
	vert_cycle:=ShallowCopy(cycle[1]);
	for i in [2..Size(cycle)-1] do
		cur_edge:=ShallowCopy(cycle[i]);
		Remove(cur_edge,Position(cur_edge,vert_cycle[Size(vert_cycle)]));
		Add(vert_cycle,cur_edge[1]);
	od;
	return vert_cycle;
end;;

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

ListFromCycle:=function(cycle)
	local i;
	i:=MovedPoints(cycle)[1];
	return List([1..Order(cycle)],j->i^(cycle^j));
end;

ListFromPerm:=function(perm)
	local mov,list,cur,i;
	mov:=ShallowCopy(MovedPoints(perm));
	list:=[];
	cur:=[];
	i:=mov[1];
	#RemoveSet(mov,i);
	while Size(mov)>0 do
		
		RemoveSet(mov,i);
		Add(cur,i);
		i:=i^perm;		
		if i in cur then
			if Size(mov)>0 then
				i:=mov[1];
				RemoveSet(mov,i);
			fi;
			Add(list,cur);
			cur:=[];
		fi;
		
	od;
	#Add(list,cur);
	return list;
end;;

CycleTriple:=function(graph,i)
local edges,neighbours,n,new_graph,list;
	edges:=Set(StructuralCopy(ShallowCopy(DigraphEdges(graph))));
	neighbours:=InNeighbors(graph)[i];
	for n in neighbours do
		RemoveSet(edges,[i,n]);
		RemoveSet(edges,[n,i]);
	od;
	new_graph:=DigraphByEdges(edges);
	list:=[DigraphDijkstra(new_graph,neighbours[1])[1][neighbours[2]],DigraphDijkstra(new_graph,neighbours[3])[1][neighbours[2]],DigraphDijkstra(new_graph,neighbours[1])[1][neighbours[3]]]+2;
	Sort(list);
	return list;
end;;

MinimalCycleDecomposition:=function(graph)
	local cycles,i,edges,neighbours,n,new_graph,n2,candidates,j;
	cycles:=[];
	for i in DigraphVertices(graph) do
		candidates:=[];
		edges:=Set(StructuralCopy(ShallowCopy(DigraphEdges(graph))));
		neighbours:=InNeighbors(graph)[i];
		for n in neighbours do
			RemoveSet(edges,[i,n]);
			RemoveSet(edges,[n,i]);
		od;
		new_graph:=DigraphByEdges(edges);
		Add(candidates,Concatenation([i],DigraphShortestPath(new_graph,neighbours[1],neighbours[2])[1]));
		Add(candidates,Concatenation([i],DigraphShortestPath(new_graph,neighbours[3],neighbours[2])[1]));
		Add(candidates,Concatenation([i],DigraphShortestPath(new_graph,neighbours[1],neighbours[3])[1]));
		SortBy(candidates,i->Size(i));
		Add(cycles,candidates[1]);
		for j in [1..Size(candidates[1])] do
			RemoveSet(edges,[candidates[1][j],candidates[1][j mod Size(candidates[1])+1]]);
			RemoveSet(edges,[candidates[1][j mod Size(candidates[1])+1],candidates[1][j]]);
		od;
		n:=DifferenceLists(neighbours,candidates[1])[1];
		candidates:=[];
		new_graph:=DigraphByEdges(edges);
		Add(candidates,Concatenation([i],DigraphShortestPath(new_graph,n,DifferenceLists(neighbours,[n])[1])[1]));
		Add(candidates,Concatenation([i],DigraphShortestPath(new_graph,n,DifferenceLists(neighbours,[n])[2])[1]));
		SortBy(candidates,i->Size(i));
		Add(cycles,candidates[1]);
		for j in [1..Size(candidates[1])] do
			RemoveSet(edges,[candidates[1][j],candidates[1][j mod Size(candidates[1])+1]]);
			RemoveSet(edges,[candidates[1][j mod Size(candidates[1])+1],candidates[1][j]]);
		od;
		n2:=DifferenceLists(neighbours,candidates[1])[1];
		new_graph:=DigraphByEdges(edges);
		Add(cycles,Concatenation([i],DigraphShortestPath(new_graph,n,n2)[1]));
	od;
	cycles:=Set(List(cycles,c->Set([CycleFromList(c),CycleFromList(Reversed(c))])));
	return Set(List(cycles,c->c[1]));
end;;


MinimalCycleDecomposition:=function(graph)
	local cycles,i,edges,neighbours,n,new_graph;
	cycles:=[];
	for i in DigraphVertices(graph) do
		edges:=Set(StructuralCopy(ShallowCopy(DigraphEdges(graph))));
		neighbours:=InNeighbors(graph)[i];
		for n in neighbours do
			RemoveSet(edges,[i,n]);
			RemoveSet(edges,[n,i]);
		od;
		new_graph:=DigraphByEdges(edges);
		Add(cycles,Concatenation([i],DigraphShortestPath(new_graph,neighbours[1],neighbours[2])[1]));
		Add(cycles,Concatenation([i],DigraphShortestPath(new_graph,neighbours[3],neighbours[2])[1]));
		Add(cycles,Concatenation([i],DigraphShortestPath(new_graph,neighbours[1],neighbours[3])[1]));
	od;
	cycles:=Set(List(cycles,c->Set([CycleFromList(c),CycleFromList(Reversed(c))])));
	return Set(List(cycles,c->c[1]));
end;;

#for i in [4..2000] do
#	groups:=AllGroups(i);
#	Print(i,"\n");
#	for j in [1..Size(groups)] do
#		n:=GeneratorsOfGroup(groups[j]);
#		if Size(n)=2 then
#			for c in Combinations(n,Size(n)) do
#				graph:=CubicGraphGivenGroupAndGeneratorsRed(groups[j],c);
#				if CycleTriple(graph,4)=CycleTriple(graph,6) then
#					Print(StructureDescription(groups[j])," and Generators ",String(c),"\n");
#					Error();
#				fi;
#			od;
#		fi;
#	od;
#od;






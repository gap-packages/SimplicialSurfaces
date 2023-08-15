Find3Waists:=function(edges)
	local c,e,3waists;
	3waists:=[];
	for c in Combinations([1..64],3) do
		if [c[1],c[2]] in edges and [c[1],c[3]] in edges and [c[3],c[2]] in edges then
			#Print(c);
			Add(3waists,c);
		fi;
	od;
	return 3waists;
end;;

Find4Waists:=function(edges)
	local c,e,4waists;
	4waists:=[];
	for c in Combinations([1..64],4) do
		if [c[1],c[2]] in edges and [c[1],c[4]] in edges and [c[3],c[2]] in edges and [c[3],c[4]] in edges then
			#Print(c);
			Add(4waists,c);
		elif [c[1],c[3]] in edges and [c[1],c[4]] in edges and [c[3],c[2]] in edges and [c[1],c[4]] in edges then
			#Print(c);
			Add(4waists,[c[1],c[3],c[2],c[4]]);
		elif [c[1],c[2]] in edges and [c[1],c[3]] in edges and [c[3],c[4]] in edges and [c[2],c[4]] in edges then
			#Print(c);
			Add(4waists,[c[1],c[3],c[4],c[2]]);
		fi;
	od;
	return 4waists;
end;;

Reduce3Vertices:=function(graph)
	local edges2,c,e,edges;
	edges:=Set((DigraphEdges(graph)));
	edges:=Set(List(edges,e->ShallowCopy(e)));
	edges:=Set(List(edges,i->Set(i)));
	edges2:=Set(edges);
	for c in Combinations([1..DigraphNrVertices(graph)],3) do
		if Set([c[1],c[2]]) in edges2 and Set([c[1],c[3]]) in edges2 and Set([c[3],c[2]]) in edges2 then
			#Error();
			#Print(c);
			edges:=contract_three_waist(edges,c);
			copy:=StructuralCopy(edges);
			for e in copy do
				Add(edges,Set([e[2],e[1]]));
			od;
			edges:=Set(edges);
			#Print(Size(edges),"\n");
		fi;
	od;
	return edges;
end;;

Reduce3Vertices:=function(graph)
	local edges2,c,e,copy,edges,cycles;
	edges:=Set((DigraphEdges(graph)));
	edges:=Set(List(edges,e->ShallowCopy(e)));
	edges:=Set(List(edges,i->Set(i)));
	edges2:=Set(edges);
	cycles:=AllCyclesOfLength(graph,3);
	cycles:=List(cycles,i->EdgeCycleToVertexCycle(i));
    cycles:=Set(List(cycles,i->CycleFromList(i)));
    cycles:=Set(List(cycles,i->Set([i,i^-1])));
    cycles:=Set(List(cycles,i->i[1]));
    cycles:=Set(List(cycles,i->ListFromCycle(i)));
	for c in cycles do
			edges:=contract_three_waist(edges,c);
			copy:=StructuralCopy(edges);
			for e in copy do
				Add(edges,Set([e[2],e[1]]));
			od;
			edges:=Set(edges);
			#Print(Size(edges),"\n");
	od;
	copy:=StructuralCopy(edges);
	for e in copy do
		Add(edges,[e[2],e[1]]);
	od;
	return DigraphByEdges(can_label(edges));
end;;

can_label:=function(edges)
	local new_edges,vertices_map,count,e;
	new_edges:=[];
	vertices_map:=[];
	count:=1;
	for e in edges do
		if not IsBound(vertices_map[e[1]]) then
			vertices_map[e[1]]:=count;
			count:=count+1;
		fi;
		if not IsBound(vertices_map[e[2]]) then
			vertices_map[e[2]]:=count;
			count:=count+1;
		fi;
		Add(new_edges,[vertices_map[e[1]],vertices_map[e[2]]]);
	od;
	return new_edges;
end;;

contract_three_waist:=function(edges,c)
	local e;
	# delete edges
	#RemoveSet(edges,Set([c[1],c[2]]));
	#RemoveSet(edges,Set([c[1],c[3]]));
	#RemoveSet(edges,Set([c[3],c[2]]));
	#RemoveSet(edges,Set([c[2],c[1]]));
	#RemoveSet(edges,Set([c[3],c[1]]));
	#RemoveSet(edges,Set([c[2],c[3]]));
	edges:=Filtered(edges,i->not IsSubset(c,i));
	edges:=Set(List(edges,i->Set(i)));
	# modify edges with new node
	for e in edges do
		#Print(e," und ",c,"\n");
		if c[2] in e then
			RemoveSet(e,c[2]);
			AddSet(e,c[1]);
		elif c[3] in e then
			RemoveSet(e,c[3]);
			AddSet(e,c[1]);
		fi;
	od;
	return Set(List(edges,i->Set(i)));
end;;
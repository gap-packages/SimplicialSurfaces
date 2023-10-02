orbits_inv:=function(inv_1,inv_2,graph)
	local l,orbits, k, i, orb;
	l:=[1..DigraphNrVertices(graph)];
	orbits:=[];
	while l <> [] do
		k:=1;
		i:=l[1];
		Remove(l,Position(l,i));
		orb:=[i];
		while (k mod 2 = 1 and not i^inv_1 in orb) or (k mod 2 = 0 and not i^inv_2 in orb) do
			if k mod 2 = 1 then
				Add(orb,i^inv_1);
				Remove(l,Position(l,i^inv_1));
				i:=i^inv_1;
			else
				Add(orb,i^inv_2);
				Remove(l,Position(l,i^inv_2));
				i:=i^inv_2;
			fi;
			k:=k+1;
		od;
		Add(orbits,orb);
	od;
	return orbits;
end;;

CayleySurface:=function(g,s)
	local vertices,edge,blue,green,red,blue_perm,green_perm,red_perm,Umbrellas,graph,edges;
	vertices:=Elements(g);
	edges:=[];

	for i in [1..Size(vertices)] do
		for j in [1..Size(s)] do
			Add(edges,[i,Position(vertices,vertices[i]*s[j])]);
		od;
	od;
	edges:=Set(Concatenation(List(edges,e->[e,[e[2],e[1]]])));
	graph:=DigraphByEdges(edges);
	blue:=Set([]);
	for i in [1..Size(vertices)] do
			AddSet(blue,Set([i,Position(vertices,vertices[i]*s[1])]));
	od;
	green:=Set([]);
	for i in [1..Size(vertices)] do
			AddSet(green,Set([i,Position(vertices,vertices[i]*s[2])]));
	od;
	red:=Set([]);
	for i in [1..Size(vertices)] do
			AddSet(red,Set([i,Position(vertices,vertices[i]*s[3])]));
	od;


	blue_perm:=Product(List(blue,i->CycleFromList(i)));
	green_perm:=Product(List(green,i->CycleFromList(i)));
	red_perm:=Product(List(red,i->CycleFromList(i)));

	Umbrellas:=Concatenation(orbits_inv(blue_perm,green_perm,graph),orbits_inv(blue_perm,red_perm,graph),orbits_inv(red_perm,green_perm,graph));
	Umbrellas:=List(Umbrellas,i->CycleFromList(i));
	return [graph,SimplicialSurfaceByUmbrellaDescriptor(Umbrellas)];
end;;

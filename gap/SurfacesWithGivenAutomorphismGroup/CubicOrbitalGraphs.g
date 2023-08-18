
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

# return all cubic orbital graphs
# ore ha baka
CubicOrbitalGraphs:=function(g,only_max,only_one,aut_graph)
	local subs,orbs_sub,t,g_t,n,edges,orbs,size,i,j,cur_size,cur_edges,graph,graphs,c,blue_perm,red_perm,green_perm,Umbrellas,x,y;
	graphs:=[];
	if only_max then
		orbs_sub:=List(MaximalSubgroupClassReps(g),m->[m]);
	else
		subs:=AllSubgroups(g);
		orbs_sub:=OrbitsDomain(g,subs);
	fi;
	for u in orbs_sub do
		u:=u[1];
		if Size(u)=1 then
			continue;
		fi;
		t:= RightTransversal(g,u);
		g_t:= Action( g, t, OnRight);
		n:=Size(t);
		edges := Combinations([1..n],2);;
		orbs:=OrbitsDomain(g_t,edges,OnSets);;
		size:=List([1..n],i->[]);;
		for i in [1..Size(orbs)] do
			cur_size:=0;
			for j in [1..Size(orbs[i])] do
				if 1 in orbs[i][j] then
					cur_size:=cur_size+1;
				fi;
			od;
			Add(size[cur_size],i);
		od;
		# three different partitions 
		#[1,1,1]
		for c in Combinations(size[1],3) do
			cur_edges:=Concatenation(orbs[c[1]],orbs[c[2]],orbs[c[3]]);
			cur_edges:=Concatenation(cur_edges,List(cur_edges,i->[i[2],i[1]]));
			graph:=DigraphByEdges(cur_edges);
			if Size(AutomorphismGroup(graph))=Size(g) and aut_graph then
				#Error();
				blue_perm:=Product(orbs[c[1]],i->CycleFromList(i));
				red_perm:=Product(orbs[c[2]],i->CycleFromList(i));
				green_perm:=Product(orbs[c[3]],i->CycleFromList(i));
				Umbrellas:=Concatenation(orbits_inv(blue_perm,green_perm,graph),orbits_inv(blue_perm,red_perm,graph),orbits_inv(red_perm,green_perm,graph));
				Umbrellas:=List(Umbrellas,i->CycleFromList(i));
				Add(graphs,[graph,SimplicialSurfaceByUmbrellaDescriptor(Umbrellas)]);
				if only_one then
					return [graph,SimplicialSurfaceByUmbrellaDescriptor(Umbrellas)];
				fi;
				if n<60 then
					Print("Three Orbital \n");
				fi;
			elif not aut_graph then
				blue_perm:=Product(orbs[c[1]],i->CycleFromList(i));
				red_perm:=Product(orbs[c[2]],i->CycleFromList(i));
				green_perm:=Product(orbs[c[3]],i->CycleFromList(i));
				Umbrellas:=Concatenation(orbits_inv(blue_perm,green_perm,graph),orbits_inv(blue_perm,red_perm,graph),orbits_inv(red_perm,green_perm,graph));
				Umbrellas:=List(Umbrellas,i->CycleFromList(i));
				Add(graphs,[graph,SimplicialSurfaceByUmbrellaDescriptor(Umbrellas)]);
				if n<60 then
					Print("Three Orbital \n");
				fi;
			fi;
		od;
		# [2,1]
		if IsBound(size[2]) then
			for x in size[1] do
				for y in size[2] do
					cur_edges:=Concatenation(orbs[x],orbs[y]);
					cur_edges:=Concatenation(cur_edges,List(cur_edges,i->[i[2],i[1]]));
					graph:=DigraphByEdges(cur_edges);
					for i in orbs[x] do
						if 1 in i then
							s:=Elements(g_t)[i[2]];
						fi;
					od;
					for i in orbs[y] do
						if 1 in i then
							z:=Elements(g_t)[i[2]];
						fi;
					od;
					cycles:=[];
					orbs_z:=Orbits(Group(z),[1..n]);
					for cycle in orbs_z do
						Add(cycles,CycleFromList(List([1..Size(cycle)],c->cycle[1]^(z^(c-1)))));
					od;

					orbs_sz:=Orbits(Group(s*z),[1..n]);
					for cycle in orbs_sz do
						Add(cycles,CycleFromList(Concatenation(List([1..Size(cycle)],c->[cycle[1]^((s*z)^(c-1)),cycle[1]^((s*z)^(c-1)*s)]))));
					od;
					orbs_sz1:=Orbits(Group(s*z^-1),[1..n]);
					for cycle in orbs_sz1 do
						Add(cycles,CycleFromList(Concatenation(List([1..Size(cycle)],c->[cycle[1]^((s*z^-1)^(c-1)),cycle[1]^((s*z^-1)^(c-1)*s)]))));
					od;
					#cycles:=Set(List(cycles,c->Set([c,c^-1])));
					#cycles:= Set(List(cycles,c->c[1]));
					#if not IsConnectedDigraph(graph) then
					#	continue;
					#fi;
					if Size(AutomorphismGroup(graph))=Size(g) and aut_graph then
						if only_one then
							return graph;
						fi;
						#if n<60 then
							#Print("Two Orbitals \n");
							#Error();
						#fi;
						#Add(graphs,[graph,2OrbitalCombinations(orbs[y],orbs[x],g,u)]);
						Add(graphs,[graph]);
					elif not aut_graph then
						#Add(graphs,[graph,2OrbitalCombinations(orbs[y],orbs[x],g,u)]);
						Add(graphs,[graph]);
						if n<60 then
							#Print("Two Orbitals \n");
							#Error();
						fi;
					fi;
				od;
			od;
		fi;
		# [3]
		# is this even possible?
		if IsBound(size[3]) then
			for x in size[3] do
					cur_edges:=orbs[x];
					cur_edges:=Concatenation(cur_edges,List(cur_edges,i->[i[2],i[1]]));
					graph:=DigraphByEdges(cur_edges);
					if IsIsomorphicDigraph(graph,PetersenGraph()) then
						#Error();
					fi;
					if Size(AutomorphismGroup(graph))=Size(g) and aut_graph then
						if n<60 then
							#Print("One Orbitals \n");
						fi;
						Add(graphs,[graph]);
					elif not aut_graph then
						Add(graphs,[graph]);
						if n<60 then
							#Print("One Orbitals \n");
						fi;
					fi;

			od;
		fi;
	od;
	isom_rep:=[];
	is_isom:=false;
	for graph in graphs do 
		is_isom:=false;
		for h in isom_rep do 
			if IsIsomorphicDigraph(graph[1],h[1]) then 
				is_isom:=true; 
				break; 
			fi; 
		od; 
		if not is_isom then 
			Add(isom_rep,graph); 
		fi;
	od;  
	return isom_rep;
end;;

# return all cubic orbital graphs
# ore ha baka
CubicCayleyGraphs:=function(g,only_one,aut_graph)
	local subs,orbs_sub,t,g_t,n,edges,orbs,size,i,j,cur_size,cur_edges,graph,graphs,u,c,blue_perm,red_perm,green_perm,Umbrellas,x,y;
	graphs:=[];
	#subs:=AllSubgroups(g);
	#orbs_sub:=OrbitsDomain(g,subs);
	
		u:=TrivialSubgroup(g);
		t:= RightTransversal(g,u);
		g_t:= Action( g, t, OnRight);
		n:=Size(t);
		edges := Combinations([1..n],2);;
		orbs:=OrbitsDomain(g_t,edges,OnSets);
		size:=List([1..n],i->[]);
		for i in [1..Size(orbs)] do
			cur_size:=0;
			for j in [1..Size(orbs[i])] do
				if 1 in orbs[i][j] then
					cur_size:=cur_size+1;
				fi;
			od;
			Add(size[cur_size],i);
		od;
		# three different partitions 
		#[1,1,1]
		for c in Combinations(size[1],3) do
			cur_edges:=Concatenation(orbs[c[1]],orbs[c[2]],orbs[c[3]]);
			cur_edges:=Concatenation(cur_edges,List(cur_edges,i->[i[2],i[1]]));
			graph:=DigraphByEdges(cur_edges);
			if Size(AutomorphismGroup(graph))=Size(g) and aut_graph then
				blue_perm:=Product(orbs[c[1]],i->CycleFromList(i));
				red_perm:=Product(orbs[c[2]],i->CycleFromList(i));
				green_perm:=Product(orbs[c[3]],i->CycleFromList(i));
				Umbrellas:=Concatenation(orbits_inv(blue_perm,green_perm,graph),orbits_inv(blue_perm,red_perm,graph),orbits_inv(red_perm,green_perm,graph));
				Umbrellas:=List(Umbrellas,i->CycleFromList(i));
				Add(graphs,[graph,SimplicialSurfaceByUmbrellaDescriptor(Umbrellas)]);
				if only_one then
					#Error();
					return [graph,SimplicialSurfaceByUmbrellaDescriptor(Umbrellas)];
				fi;
			elif not aut_graph then
				blue_perm:=Product(orbs[c[1]],i->CycleFromList(i));
				red_perm:=Product(orbs[c[2]],i->CycleFromList(i));
				green_perm:=Product(orbs[c[3]],i->CycleFromList(i));
				Umbrellas:=Concatenation(orbits_inv(blue_perm,green_perm,graph),orbits_inv(blue_perm,red_perm,graph),orbits_inv(red_perm,green_perm,graph));
				Umbrellas:=List(Umbrellas,i->CycleFromList(i));
				Add(graphs,[graph,SimplicialSurfaceByUmbrellaDescriptor(Umbrellas)]);
			fi;
		od;
		# [2,1]
		if IsBound(size[2]) then
			for x in size[1] do
				for y in size[2] do
					#Error();
					cur_edges:=Concatenation(orbs[x],orbs[y]);
					cur_edges:=Concatenation(cur_edges,List(cur_edges,i->[i[2],i[1]]));
					for i in orbs[x] do
						if 1 in i then
							s:=Elements(g_t)[i[2]];
						fi;
					od;
					for i in orbs[y] do
						if 1 in i then
							z:=Elements(g_t)[i[2]];
						fi;
					od;
					cycles:=[];
					orbs_z:=Orbits(Group(z),[1..n]);
					for cycle in orbs_z do
						Add(cycles,CycleFromList(List([1..Size(cycle)],c->cycle[1]^(z^(c-1)))));
					od;

					orbs_sz:=Orbits(Group(s*z),[1..n]);
					for cycle in orbs_sz do
						Add(cycles,CycleFromList(Concatenation(List([1..Size(cycle)],c->[cycle[1]^((s*z)^(c-1)),cycle[1]^((s*z)^(c-1)*s)]))));
					od;
					#orbs_sz1:=Orbits(Group(s*z^-1),[1..n]);
					#for cycle in orbs_sz1 do
					#	Add(cycles,CycleFromList(Concatenation(List([1..Size(cycle)],c->[cycle[1]^((s*z^-1)^(c-1)),cycle[1]^((s*z^-1)^(c-1)*s)]))));
					#od;
					#cycles:=Set(List(cycles,c->Set([c,c^-1])));
					#cycles:= Set(List(cycles,c->c[1]));
					# get elements
					graph:=DigraphByEdges(cur_edges);
					if Size(AutomorphismGroup(graph))=Size(g) and aut_graph then
						

						Add(graphs,[graph,SimplicialSurfaceByUmbrellaDescriptor(cycles)]);
					elif not aut_graph then
						Add(graphs,[graph,SimplicialSurfaceByUmbrellaDescriptor(cycles)]);
					fi;
				od;
			od;
		fi;
		# [3]
		# is this even possible? for orbital graphs -> Peterson
		if IsBound(size[3]) then
			for x in size[3] do
				
					cur_edges:=orbs[x];
					cur_edges:=Concatenation(cur_edges,List(cur_edges,i->[i[2],i[1]]));
					graph:=DigraphByEdges(cur_edges);

					if Size(AutomorphismGroup(graph))=Size(g) and aut_graph then
						Add(graphs,[graph]);
					elif not aut_graph then
						Add(graphs,[graph]);
					fi;

			od;
		fi;
	isom_rep:=[];
	is_isom:=false;
	for graph in graphs do 
		is_isom:=false;
		for h in isom_rep do 
			if IsIsomorphicDigraph(graph[1],h[1]) then 
				is_isom:=true; 
				break; 
			fi; 
		od; 
		if not is_isom then 
			Add(isom_rep,graph); 
		fi;
	od;  
	return isom_rep;
end;;#

#isom_rep:=[];
#is_isom:=false;
#for graph in graphs do 
#	graph:=graph[1];
#	is_isom:=false;
#	for h in isom_rep do 
#		if IsIsomorphicDigraph(graph,h) then 
#			is_isom:=true; 
#			break; 
#		fi; 
#	od; 
#	if not is_isom then 
#		Add(isom_rep,graph); 
#	fi;
#od;  #
#

#						blue_perm:=Product(orbs[x],i->CycleFromList(i));
#						# find out permutation for y#

#							cur_size:=0;
#							for j in [1..Size(orbs[y])] do
#								if 1 in orbs[i][j] then
#									perm:=t[j][2];
#								fi;
#							od;
#						Error();	
#						
#						red_perm:=Product(orbs[y],i->CycleFromList(i));
#						green_perm:=Product(orbs[y],i->CycleFromList(i));
#						Umbrellas:=Concatenation(orbits_inv(blue_perm,green_perm,graph),orbits_inv(blue_perm,red_perm,graph),orbits_inv(red_perm,green_perm,graph));#

##für jede Untergruppenbeziehung berechnen wir die Orbitalgraphen
#for x in [1..14] do 
#g:= l[x][1];
#s:= l[x][2];
#t:= RightTransversal(g,s);
#g20:= Action( g, t, OnRight); 
#n:=Size(RightCosets(g,s));
#edges := ShallowCopy(Orbit(SymmetricGroup(n), [1,2], OnPairs));;
#while not IsEmpty(edges) do
#	orb1 := EdgeOrbitsGraph( g20, edges[1] );;
#	aut1 := AutGroupGraph( orb1 );;
#	if Size( aut1) = 60 then
#		Print("Orbitalgraph von ", StructureDescription(g),
#" und ",StructureDescription(s), " mit Automorphismengruppe:",
#StructureDescription( aut1),"\n");
#		Print(orb1, "\n");	
#	else
#		Print("Orbitalgraph von ", StructureDescription(g),
#" und ",StructureDescription(s), " mit ", Size(aut1),
#"-elementiger Automorphismengruppe","\n");
#	fi;
#	del := ShallowCopy(DirectedEdges(orb1));;
#	n := Size(del);;
#	for i in [1..n] do
# 		Remove( edges, Position( edges, del[i]));;
#	od;
#od;
#od;#
#

#weight:=6/12;
#	faceCoordinates2D:=Tutte(s,weight);
#	pr:=rec();
#	pr.faceCoordinates2D:=faceCoordinates2D/180;
#	pr.edgeColours:=edgeColours;
#	#pr.faceLabels:=faceLabels;
#	pr.compileLaTeX:=true;#

#values:=[];
#for f in faceCoordinates2D do
#	value:=Ceil(Sqrt(f[1]^2+f[2]^2)/10);
#	if value<>0. then
#		Add(values,value*10);
#	fi;
#od;
#values:=Set(values);#

#newfaceCoordinates2D:=[];#

#for f in faceCoordinates2D do
#	min:=AbsoluteValue(Sqrt(f[1]^2+f[2]^2)-values[1]);
#	j:=1;
#	for i in [2..Size(values)] do
#		if AbsoluteValue(Sqrt(f[1]^2+f[2]^2)-values[i])<min then
#			min:=AbsoluteValue(Sqrt(f[1]^2+f[2]^2)-values[i]);
#			j:=i;
#		fi;
#	od;
#	if j=1 then
#		Add(newfaceCoordinates2D,[f[1],f[2]]/Sqrt(f[1]^2+f[2]^2)*1.5*(j*1.)^(0.9));
#	else
#		Add(newfaceCoordinates2D,f/Sqrt(f[1]^2+f[2]^2)*2*(j*1.)^(0.5));
#	fi;
#od;
#pr.faceCoordinates2D:=newfaceCoordinates2D;#

#DrawFacegraphToTikz(s,"A5_60_31",pr);      #
#
#

#weight:=1/2;
#	faceCoordinates2D:=Tutte_v(s,weight,72);
#	pr:=rec();
#	pr.faceCoordinates2D:=faceCoordinates2D/180;
#	#pr.edgeColours:=edgeColours;
#	#pr.faceLabels:=faceLabels;
#	pr.compileLaTeX:=true;#

#values:=[];
#for f in faceCoordinates2D do
#	value:=Ceil(Sqrt(f[1]^2+f[2]^2));
#	if value<>0. then
#		Add(values,value);
#	fi;
#od;
#values:=Set(values);#

#newfaceCoordinates2D:=[];#

#for f in faceCoordinates2D do
#	min:=AbsoluteValue(Sqrt(f[1]^2+f[2]^2)-values[1]);
#	j:=1;
#	for i in [2..Size(values)] do
#		if AbsoluteValue(Sqrt(f[1]^2+f[2]^2)-values[i])<min then
#			min:=AbsoluteValue(Sqrt(f[1]^2+f[2]^2)-values[i]);
#			j:=i;
#		fi;
#	od;
#	if j=1 then
#		Add(newfaceCoordinates2D,[f[1],f[2]]/Sqrt(f[1]^2+f[2]^2)*(2*j*1.)^(1));
#	else
#		Add(newfaceCoordinates2D,f/Sqrt(f[1]^2+f[2]^2)*(2*j*1.)^(0.7));
#	fi;
#od;
#pr.faceCoordinates2D:=newfaceCoordinates2D; 

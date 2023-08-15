
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

can_wild_surf:=function(w)
	local c,blue_perm,green_perm,red_perm,graph,Umbrellas;
	c:=ColourInvolutions(w);
	blue_perm:=c[1];
	green_perm:=c[2];
		red_perm:=c[3];graph:=FaceDigraphsGraph(w);Umbrellas:=Concatenation(orbits_inv(blue_perm,green_perm,graph),orbits_inv(blue_perm,red_perm,graph),orbits_inv(red_perm,green_perm,graph));
	Umbrellas:=List(Umbrellas,i->CycleFromList(i));
	return SimplicialSurfaceByUmbrellaDescriptor(Umbrellas);
end;

SurfaceWithGivenGroup:=function(g)
	local hh,h,x,red,green,blue,c,edges,graph,s,copy,inv_1,inv_2,Umbrellas,red_perm,green_perm,blue_perm,orbits_inv,e,i,k,n;
	if IsSolubleGroup(g) then
		n:=MinimalGeneratingSet(g);
	else
		n:=GeneratorsOfGroup(g);
	fi;
	hh:=List(g);
	h:=ShallowCopy(StructuralCopy(n));
	for x in hh do
		if not x in h and not x=Identity(g) then
			Add(h,x);
		fi;
	od;
	Add(h,Identity(g));
	red:=[];
	green:=[];
	blue:=[];
	c:=(2*Size(n)+4);
	# we have (2n+4)h vertices

	edges:=[];

	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+2]);
		Add(blue,[(k-1)*c+1,(k-1)*c+2]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+4]);
		Add(red,[(k-1)*c+1,(k-1)*c+4]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+5]);
		Add(green,[(k-1)*c+1,(k-1)*c+5]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+2,(k-1)*c+3]);
		Add(red,[(k-1)*c+2,(k-1)*c+3]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+2,(k-1)*c+4]);
		Add(green,[(k-1)*c+2,(k-1)*c+4]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+3,(k-1)*c+5]);
		Add(blue,[(k-1)*c+3,(k-1)*c+5]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+3,(k-1)*c+6]);
		Add(green,[(k-1)*c+3,(k-1)*c+6]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+4,(k-1)*c+c]);
		Add(blue,[(k-1)*c+4,(k-1)*c+c]);
	od;



	for i in [6..2*Size(n)+3] do
			for k in [1..Size(h)] do
				Add(edges,[(k-1)*c+i,(k-1)*c+i+1]);
				if i mod 2 = 0 then
					Add(blue,[(k-1)*c+i,(k-1)*c+i+1]);
				else
					Add(green,[(k-1)*c+i,(k-1)*c+i+1]);
				fi; 
			od;
	od;
	for k in [1..Size(h)] do
		for i in [1..Size(n)] do
			Add(edges,[(k-1)*c+(2*i+3),(Position(h,h[k]*h[i])-1)*c+(2*i+4)]);
			Add(red,[(k-1)*c+(2*i+3),(Position(h,h[k]*h[i])-1)*c+(2*i+4)]);
		od;
	od;

	copy:=StructuralCopy(edges);
	for e in copy do
		Add(edges,[e[2],e[1]]);
	od;
	graph:=DigraphByEdges(Set(edges));


	blue_perm:=Product(List(blue,i->CycleFromList(i)));
	green_perm:=Product(List(green,i->CycleFromList(i)));
	red_perm:=Product(List(red,i->CycleFromList(i)));


	inv_1:=blue_perm;
	inv_2:=green_perm;

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

	Umbrellas:=Concatenation(orbits_inv(blue_perm,green_perm,graph),orbits_inv(blue_perm,red_perm,graph),orbits_inv(red_perm,green_perm,graph));
	Umbrellas:=List(Umbrellas,i->CycleFromList(i));
	s:=SimplicialSurfaceByUmbrellaDescriptor(Umbrellas);
	return [graph,s];
end;;

SurfaceWithGivenGroupAndGenerators:=function(g,n)
	local hh,h,x,red,green,blue,c,edges,graph,s,copy,inv_1,inv_2,Umbrellas,red_perm,green_perm,blue_perm,orbits_inv,e,i,k;
	hh:=List(g);
	h:=ShallowCopy(StructuralCopy(n));
	for x in hh do
		if not x in h and not x=Identity(g) then
			Add(h,x);
		fi;
	od;
	Add(h,Identity(g));
	red:=[];
	green:=[];
	blue:=[];
	c:=(2*Size(n)+4);
	# we have (2n+4)h vertices

	edges:=[];

	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+2]);
		Add(blue,[(k-1)*c+1,(k-1)*c+2]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+4]);
		Add(red,[(k-1)*c+1,(k-1)*c+4]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+5]);
		Add(green,[(k-1)*c+1,(k-1)*c+5]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+2,(k-1)*c+3]);
		Add(red,[(k-1)*c+2,(k-1)*c+3]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+2,(k-1)*c+4]);
		Add(green,[(k-1)*c+2,(k-1)*c+4]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+3,(k-1)*c+5]);
		Add(blue,[(k-1)*c+3,(k-1)*c+5]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+3,(k-1)*c+6]);
		Add(green,[(k-1)*c+3,(k-1)*c+6]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+4,(k-1)*c+c]);
		Add(blue,[(k-1)*c+4,(k-1)*c+c]);
	od;



	for i in [6..2*Size(n)+3] do
			for k in [1..Size(h)] do
				Add(edges,[(k-1)*c+i,(k-1)*c+i+1]);
				if i mod 2 = 0 then
					Add(blue,[(k-1)*c+i,(k-1)*c+i+1]);
				else
					Add(green,[(k-1)*c+i,(k-1)*c+i+1]);
				fi; 
			od;
	od;
	for k in [1..Size(h)] do
		for i in [1..Size(n)] do
			Add(edges,[(k-1)*c+(2*i+3),(Position(h,h[k]*h[i])-1)*c+(2*i+4)]);
			Add(red,[(k-1)*c+(2*i+3),(Position(h,h[k]*h[i])-1)*c+(2*i+4)]);
		od;
	od;

	copy:=StructuralCopy(edges);
	for e in copy do
		Add(edges,[e[2],e[1]]);
	od;
	graph:=DigraphByEdges(Set(edges));


	blue_perm:=Product(List(blue,i->CycleFromList(i)));
	green_perm:=Product(List(green,i->CycleFromList(i)));
	red_perm:=Product(List(red,i->CycleFromList(i)));


	inv_1:=blue_perm;
	inv_2:=green_perm;

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

	Umbrellas:=Concatenation(orbits_inv(blue_perm,green_perm,graph),orbits_inv(blue_perm,red_perm,graph),orbits_inv(red_perm,green_perm,graph));
	Umbrellas:=List(Umbrellas,i->CycleFromList(i));
	s:=SimplicialSurfaceByUmbrellaDescriptor(Umbrellas);
	return [graph,s];
end;;

CubicGraphGivenGroup:=function(g)
	local hh,h,x,red,green,blue,c,edges,graph,s,copy,inv_1,inv_2,Umbrellas,red_perm,green_perm,blue_perm,orbits_inv,e,i,k,n,orig_graph;
	fCatch := function(x)
		local result;
    	BreakOnError := false;
    	result := CALL_WITH_CATCH(f, [ x ])[1];;
    	BreakOnError := true;
    	return result;
	end;
	if IsSolubleGroup(g) then
		f:=MinimalGeneratingSet;
		if fCatch(g)=false then
			n:=GeneratorsOfGroup(g);
		else
			n:=MinimalGeneratingSet(g);
		fi;
	else
		n:=GeneratorsOfGroup(g);
	fi;
	hh:=List(g);
	h:=ShallowCopy(StructuralCopy(n));
	for x in hh do
		if not x in h and not x=Identity(g) then
			Add(h,x);
		fi;
	od;
	Add(h,Identity(g));
	red:=[];
	green:=[];
	blue:=[];
	c:=(2*Size(n)+4);
	# we have (2n+4)h vertices

	edges:=[];

	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+2]);
		Add(blue,[(k-1)*c+1,(k-1)*c+2]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+4]);
		Add(red,[(k-1)*c+1,(k-1)*c+4]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+5]);
		Add(green,[(k-1)*c+1,(k-1)*c+5]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+2,(k-1)*c+3]);
		Add(red,[(k-1)*c+2,(k-1)*c+3]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+2,(k-1)*c+4]);
		Add(green,[(k-1)*c+2,(k-1)*c+4]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+3,(k-1)*c+5]);
		Add(blue,[(k-1)*c+3,(k-1)*c+5]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+3,(k-1)*c+6]);
		Add(green,[(k-1)*c+3,(k-1)*c+6]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+4,(k-1)*c+c]);
		Add(blue,[(k-1)*c+4,(k-1)*c+c]);
	od;



	for i in [6..2*Size(n)+3] do
			for k in [1..Size(h)] do
				Add(edges,[(k-1)*c+i,(k-1)*c+i+1]);
				if i mod 2 = 0 then
					Add(blue,[(k-1)*c+i,(k-1)*c+i+1]);
				else
					Add(green,[(k-1)*c+i,(k-1)*c+i+1]);
				fi; 
			od;
	od;
	for k in [1..Size(h)] do
		for i in [1..Size(n)] do
			Add(edges,[(k-1)*c+(2*i+3),(Position(h,h[k]*h[i])-1)*c+(2*i+4)]);
			Add(red,[(k-1)*c+(2*i+3),(Position(h,h[k]*h[i])-1)*c+(2*i+4)]);
		od;
	od;

	copy:=StructuralCopy(edges);
	for e in copy do
		Add(edges,[e[2],e[1]]);
	od;
	orig_graph:=DigraphByEdges(Set(edges));
	graph:=orig_graph;
	new_graph:=Reduce3Vertices(orig_graph);
	while Size(AutomorphismGroup(new_graph))=Size(g) and new_graph<>graph do
		graph:=new_graph;
		new_graph:=Reduce3Vertices(graph);
	od;
	return [orig_graph,graph];

end;;

CubicGraphGivenGroupAndGenerators:=function(g,n)
	local hh,h,x,red,green,blue,c,edges,graph,s,copy,inv_1,inv_2,Umbrellas,red_perm,green_perm,blue_perm,orbits_inv,e,i,k,orig_graph;
	hh:=List(g);
	h:=List(ShallowCopy(StructuralCopy(Set(n))));
	for x in hh do
		if not x in h and not x=Identity(g) then
			Add(h,x);
		fi;
	od;
	Add(h,Identity(g));
	red:=[];
	green:=[];
	blue:=[];
	c:=(2*Size(n)+4);
	# we have (2n+4)h vertices

	edges:=[];

	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+2]);
		Add(blue,[(k-1)*c+1,(k-1)*c+2]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+4]);
		Add(red,[(k-1)*c+1,(k-1)*c+4]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+5]);
		Add(green,[(k-1)*c+1,(k-1)*c+5]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+2,(k-1)*c+3]);
		Add(red,[(k-1)*c+2,(k-1)*c+3]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+2,(k-1)*c+4]);
		Add(green,[(k-1)*c+2,(k-1)*c+4]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+3,(k-1)*c+5]);
		Add(blue,[(k-1)*c+3,(k-1)*c+5]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+3,(k-1)*c+6]);
		Add(green,[(k-1)*c+3,(k-1)*c+6]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+4,(k-1)*c+c]);
		Add(blue,[(k-1)*c+4,(k-1)*c+c]);
	od;



	for i in [6..2*Size(n)+3] do
			for k in [1..Size(h)] do
				Add(edges,[(k-1)*c+i,(k-1)*c+i+1]);
				if i mod 2 = 0 then
					Add(blue,[(k-1)*c+i,(k-1)*c+i+1]);
				else
					Add(green,[(k-1)*c+i,(k-1)*c+i+1]);
				fi; 
			od;
	od;
	for k in [1..Size(h)] do
		for i in [1..Size(n)] do
			Add(edges,[(k-1)*c+(2*i+3),(Position(h,h[k]*n[i])-1)*c+(2*i+4)]);
			Add(red,[(k-1)*c+(2*i+3),(Position(h,h[k]*n[i])-1)*c+(2*i+4)]);
		od;
	od;

	copy:=StructuralCopy(edges);
	for e in copy do
		Add(edges,[e[2],e[1]]);
	od;
	orig_graph:=DigraphByEdges(Set(edges));
	graph:=orig_graph;
	new_graph:=Reduce3Vertices(orig_graph);
	while Size(AutomorphismGroup(new_graph))=Size(g) and new_graph<>graph do
		graph:=new_graph;
		new_graph:=Reduce3Vertices(graph);
	od;
	return [orig_graph,graph];

end;;

#for i in [4..100] do
#	Print(i,"\n");
#	for g in AllGroups(i) do
#		if not Size(GeneratorsOfGroup(g))=1 then
#			graph:=CubicGraphGivenGroup(g)[2];
#			if DigraphNrVertices(graph)>2*(Size(GeneratorsOfGroup(g))+1)*Size(g) then
#				Print(g);
#			fi;
#		fi;
#	od;
#od;


CubicGraphGivenGroupRed:=function(g)
	local hh,h,x,red,green,blue,c,edges,graph,s,copy,inv_1,inv_2,Umbrellas,red_perm,green_perm,blue_perm,orbits_inv,e,i,k,n,orig_graph,faceLabels,orbs,cycle,cycles,swap;
	fCatch := function(x)
		local result;
    	BreakOnError := false;
    	result := CALL_WITH_CATCH(f, [ x ])[1];;
    	BreakOnError := true;
    	return result;
	end;
	if IsSolubleGroup(g) then
		f:=MinimalGeneratingSet;
		if fCatch(g)=false then
			n:=GeneratorsOfGroup(g);
		else
			n:=MinimalGeneratingSet(g);
		fi;
	else
		n:=GeneratorsOfGroup(g);
	fi;
	n:=ShallowCopy(n);
	if Order(n[1])=2 then
		swap:=n[1];
		n[1]:=n[2];
		n[2]:=swap;
	fi;
	hh:=List(g);
	h:=ShallowCopy(StructuralCopy(n));
	for x in hh do
		if not x in h and not x=Identity(g) then
			Add(h,x);
		fi;
	od;
	Add(h,Identity(g));
	red:=[];
	green:=[];
	blue:=[];
	c:=(2*Size(n)+2);
	# we have (2n+4)h vertices

	edges:=[];


	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+2,(k-1)*c+3]);
		Add(green,[(k-1)*c+2,(k-1)*c+3]);
	od;

	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+2,(k-1)*c+1]);
		Add(red,[(k-1)*c+2,(k-1)*c+1]);
	od;

	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+3]);
		Add(blue,[(k-1)*c+1,(k-1)*c+3]);
	od;

	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+4]);
		Add(green,[(k-1)*c+1,(k-1)*c+4]);
	od;

	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+2,(k-1)*c+c]);
		Add(blue,[(k-1)*c+2,(k-1)*c+c]);
	od;



	for i in [6..2*Size(n)+3] do
			for k in [1..Size(h)] do
				Add(edges,[(k-1)*c+i-2,(k-1)*c+i+1-2]);
				if i mod 2 = 0 then
					Add(blue,[(k-1)*c+i-2,(k-1)*c+i+1-2]);
				else
					Add(green,[(k-1)*c+i-2,(k-1)*c+i+1-2]);
				fi; 
			od;
	od;

	for k in [1..Size(h)] do
		for i in [1..Size(n)] do
			Add(edges,[(k-1)*c+(2*i+3)-2,(Position(h,h[k]*h[i])-1)*c+(2*i+4)-2]);
			Add(red,[(k-1)*c+(2*i+3)-2,(Position(h,h[k]*h[i])-1)*c+(2*i+4)-2]);
		od;
	od;

	copy:=StructuralCopy(edges);
	for e in copy do
		Add(edges,[e[2],e[1]]);
	od;
	faceLabels:=[];
	for j in [1..Size(h)] do
		for i in [1..c] do
			Add(faceLabels,Concatenation("x_{",String(i),",g_{",String(j),"}}"));
		od;
	od;
	graph:=DigraphByEdges(Set(edges));
	blue_perm:=Product(List(blue,i->CycleFromList(i)));
	green_perm:=Product(List(green,i->CycleFromList(i)));
	red_perm:=Product(List(red,i->CycleFromList(i)));


	inv_1:=blue_perm;
	inv_2:=green_perm;

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

	Umbrellas:=Concatenation(orbits_inv(blue_perm,green_perm,graph),orbits_inv(blue_perm,red_perm,graph),orbits_inv(red_perm,green_perm,graph));
	Umbrellas:=List(Umbrellas,i->CycleFromList(i));
	s:=SimplicialSurfaceByUmbrellaDescriptor(Umbrellas);

	if Size(n)=2 then
		# Alternative Construction
		cycles:=[];
		# 1-2-3 cycles
		for i in [1..Size(g)] do
			Add(cycles,(1+(i-1)*6,2+(i-1)*6,3+(i-1)*6));
		od;
		# 1-2-6-5-4 cycles
		for i in [1..Size(g)] do
			Add(cycles,(1+(i-1)*6,2+(i-1)*6,6+(i-1)*6,5+(i-1)*6,4+(i-1)*6));
		od;
		# 5-6-5'-6'-...
		orbs:=Orbits(Group(n[2]),g,OnRight);
		for cycle in orbs do
			cycle:=List([1..Size(cycle)],c->cycle[1]*n[2]^(c-1));
			cycle:=List(cycle,c->Position(h,c));
			Add(cycles,CycleFromList(Concatenation(List(cycle,c->[6+(c-1)*6,5+(c-1)*6]))));
		od;
		if Order(n[2])=2 and Order(n[1])<>2 then
		## alternative constructions for involution y
			# 6-2-3-4'-1'-3'-4''-5''
			# x^2*y
			orbs:=Orbits(Group(n[1]*n[1]*n[2]),g,OnRight);
			for cycle in orbs do
				cycle:=List([1..Size(cycle)],c->cycle[1]*(n[1]*n[1]*n[2])^(c-1));
				cycle:=List(cycle,c->Position(h,c));
				Add(cycles,CycleFromList(Concatenation(List(cycle,c->[6+(c-1)*6,2+(c-1)*6,3+(c-1)*6,4+(Position(h,h[c]*n[1])-1)*6,1+(Position(h,h[c]*n[1])-1)*6,3+(Position(h,h[c]*n[1])-1)*6,4+(Position(h,h[c]*n[1]*n[1])-1)*6,5+(Position(h,h[c]*n[1]*n[1])-1)*6]))));
			od;

			# crazy try for C2xC4 based on CDC of Cayley graph
			# 6-2-3-4'-5'-6''-5''-4''-3'''-2'''-6'''-5''''
			# x*y*x^-1*y
			orbs:=Orbits(Group(n[1]*n[2]*n[1]^-1*n[2]),g,OnRight);
			for cycle in orbs do
				cycle:=List([1..Size(cycle)],c->cycle[1]*(n[1]*n[2]*n[1]^-1*n[2])^(c-1));
				cycle:=List(cycle,c->Position(h,c));
				Add(cycles,CycleFromList(Concatenation(List(cycle,c->[5+(c-1)*6,6+(c-1)*6,2+(c-1)*6,3+(c-1)*6,4+(Position(h,h[c]*n[1])-1)*6,5+(Position(h,h[c]*n[1])-1)*6,6+(Position(h,h[c]*n[1]*n[2])-1)*6,5+(Position(h,h[c]*n[1]*n[2])-1)*6,4+(Position(h,h[c]*n[1]*n[2])-1)*6,3+(Position(h,h[c]*n[1]*n[2]*n[1]^-1)-1)*6,2+(Position(h,h[c]*n[1]*n[2]*n[1]^-1)-1)*6,6+(Position(h,h[c]*n[1]*n[2]*n[1]^-1)-1)*6]))));
			od;



		else

			# 3-1-4-3'-1'-4'-...
			orbs:=Orbits(Group(n[1]),g,OnRight);
			for cycle in orbs do
				cycle:=List([1..Size(cycle)],c->cycle[1]*n[1]^(c-1));
				cycle:=List(cycle,c->Position(h,c));
				Add(cycles,CycleFromList(Concatenation(List(cycle,c->[4+(c-1)*6,1+(c-1)*6,3+(c-1)*6]))));
			od;
			# 3-2-6-5'-4'-3''-...
			orbs:=Orbits(Group(n[1]*n[2]),g,OnRight);
			for cycle in orbs do
				cycle:=List([1..Size(cycle)],c->cycle[1]*(n[1]*n[2])^(c-1));
				cycle:=List(cycle,c->Position(h,c));
				Add(cycles,CycleFromList(Concatenation(List(cycle,c->[6+(c-1)*6,2+(c-1)*6,3+(c-1)*6,4+(Position(h,h[c]*n[1])-1)*6,5+(Position(h,h[c]*n[1])-1)*6]))));
			od;
		fi;
		



		return [graph,s,SimplicialSurfaceByUmbrellaDescriptor(cycles),faceLabels];
	else
		return [graph,s,faceLabels];
	fi;
	

end;;


CubicGraphGivenGroupAndGeneratorsRed:=function(g,n)
	local hh,h,x,red,green,blue,c,edges,graph,s,copy,inv_1,inv_2,Umbrellas,red_perm,green_perm,blue_perm,orbits_inv,e,i,k,orig_graph;
	fCatch := function(x)
		local result;
    	BreakOnError := false;
    	result := CALL_WITH_CATCH(f, [ x ])[1];;
    	BreakOnError := true;
    	return result;
	end;

	hh:=List(g);
	h:=ShallowCopy(StructuralCopy(n));
	for x in hh do
		if not x in h and not x=Identity(g) then
			Add(h,x);
		fi;
	od;
	Add(h,Identity(g));
	red:=[];
	green:=[];
	blue:=[];
	c:=(2*Size(n)+2);
	# we have (2n+4)h vertices

	edges:=[];


	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+2,(k-1)*c+3]);
		Add(green,[(k-1)*c+2,(k-1)*c+3]);
	od;

	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+2,(k-1)*c+1]);
		Add(red,[(k-1)*c+2,(k-1)*c+1]);
	od;

	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+3]);
		Add(blue,[(k-1)*c+1,(k-1)*c+3]);
	od;

	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+1,(k-1)*c+4]);
		Add(green,[(k-1)*c+1,(k-1)*c+4]);
	od;

	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+2,(k-1)*c+c]);
		Add(blue,[(k-1)*c+2,(k-1)*c+c]);
	od;



	for i in [6..2*Size(n)+3] do
			for k in [1..Size(h)] do
				Add(edges,[(k-1)*c+i-2,(k-1)*c+i+1-2]);
				if i mod 2 = 0 then
					Add(blue,[(k-1)*c+i-2,(k-1)*c+i+1-2]);
				else
					Add(green,[(k-1)*c+i-2,(k-1)*c+i+1-2]);
				fi; 
			od;
	od;

	for k in [1..Size(h)] do
		for i in [1..Size(n)] do
			Add(edges,[(k-1)*c+(2*i+3)-2,(Position(h,h[k]*h[i])-1)*c+(2*i+4)-2]);
			Add(red,[(k-1)*c+(2*i+3)-2,(Position(h,h[k]*h[i])-1)*c+(2*i+4)-2]);
		od;
	od;

	copy:=StructuralCopy(edges);
	for e in copy do
		Add(edges,[e[2],e[1]]);
	od;
	return DigraphByEdges(Set(edges));
	

end;;

CubicGraphGivenGroupRed2:=function(g)
	local hh,h,x,red,green,blue,c,edges,graph,s,copy,inv_1,inv_2,Umbrellas,red_perm,green_perm,blue_perm,orbits_inv,e,i,k,n,orig_graph;
	fCatch := function(x)
		local result;
    	BreakOnError := false;
    	result := CALL_WITH_CATCH(f, [ x ])[1];;
    	BreakOnError := true;
    	return result;
	end;
	if IsSolubleGroup(g) then
		f:=MinimalGeneratingSet;
		if fCatch(g)=false then
			n:=GeneratorsOfGroup(g);
		else
			n:=MinimalGeneratingSet(g);
		fi;
	else
		n:=GeneratorsOfGroup(g);
	fi;
	hh:=List(g);
	h:=ShallowCopy(StructuralCopy(n));
	for x in hh do
		if not x in h and not x=Identity(g) then
			Add(h,x);
		fi;
	od;
	Add(h,Identity(g));
	red:=[];
	green:=[];
	blue:=[];
	c:=(2*Size(n)+4);
	# we have (2n+4)h vertices

	edges:=[];






	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+5,(k-1)*c+6]);
		Add(green,[(k-1)*c+5,(k-1)*c+6]);
	od;
	for k in [1..Size(h)] do
		Add(edges,[(k-1)*c+5,(k-1)*c+c]);
		Add(blue,[(k-1)*c+5,(k-1)*c+c]);
	od;



	for i in [6..2*Size(n)+3] do
			for k in [1..Size(h)] do
				Add(edges,[(k-1)*c+i,(k-1)*c+i+1]);
				if i mod 2 = 0 then
					Add(blue,[(k-1)*c+i,(k-1)*c+i+1]);
				else
					Add(green,[(k-1)*c+i,(k-1)*c+i+1]);
				fi; 
			od;
	od;
	for k in [1..Size(h)] do
		for i in [1..Size(n)] do
			Add(edges,[(k-1)*c+(2*i+3),(Position(h,h[k]*h[i])-1)*c+(2*i+4)]);
			Add(red,[(k-1)*c+(2*i+3),(Position(h,h[k]*h[i])-1)*c+(2*i+4)]);
		od;
	od;

	copy:=StructuralCopy(edges);
	for e in copy do
		Add(edges,[e[2],e[1]]);
	od;
	return DigraphByEdges(can_label(Set(edges)));
	
end;;

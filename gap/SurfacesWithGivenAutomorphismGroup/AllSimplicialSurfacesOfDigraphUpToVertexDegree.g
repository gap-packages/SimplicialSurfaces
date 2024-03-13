AllSimplicialSurfacesOfDigraphUpToVertexDegree:=function(digraph,vertexFaithful,n)
		
		local allCycles,edgesOfGraph, faces,edgesOfCycles,CyclesOfEdges,cyclesOfEdges,FindSurface,FindCycleComb,
		NodesOfCycle,cycle,cyclePair,IsPartOf,possibleCyclesPairs,commonEdges,Possible,e,nr,cycles,graph,j;

		if IsMultiDigraph(digraph) or DigraphHasLoops(digraph) or not IsSymmetricDigraph(digraph) or not IsConnectedDigraph(digraph) then
                        Error("SimplicialSurfaceOfFaceGraph: Given digraph has to be simple, symmetric and connected");
         	fi;
        nr:=DigraphNrVertices(digraph);
        allCycles:=[];
        for j in [3..n] do
        	cycles:=AllCyclesOfLength(digraph,j);
        	cycles:=List(cycles,i->EdgeCycleToVertexCycle(i));
        	cycles:=Set(List(cycles,i->CycleFromList(i)));
        	cycles:=Filtered(cycles,c->c<>fail);
        	cycles:=Set(List(cycles,i->Set([i,i^-1])));
        	cycles:=Set(List(cycles,i->i[1]));
        	cycles:=Set(List(cycles,i->ListFromCycle(i)));
        	cycles:=List(cycles,i->AdjacencyMatrixFromList(i,nr));
        	allCycles:=Concatenation(allCycles,cycles);
        od;
		#allCycles:=__SIMPLICIAL_AllCyclesOfFaceGraph(digraph);

		edgesOfGraph:=Filtered(DigraphEdges(digraph),e->not IsSortedList(e));

		edgesOfCycles:=[];
		for cycle in [1..Length(allCycles)] do;
			edgesOfCycles[cycle]:=List(__SIMPLICIAL_EdgesFromAdjacencyMat(allCycles[cycle]),e->Position(edgesOfGraph,e));
		od;

		possibleCyclesPairs:=[];
		for e in [1..Length(edgesOfGraph)] do
			possibleCyclesPairs[e]:=[];
		od;

		for cyclePair in IteratorOfCombinations([1..Length(allCycles)],2) do
			commonEdges:=Intersection(edgesOfCycles[cyclePair[1]],edgesOfCycles[cyclePair[2]]);
			if Length(commonEdges)=1 then
				Add(possibleCyclesPairs[commonEdges[1]],cyclePair);
			fi;
		od;

		faces:=[];

		# The function returns a list that stores a Boolean list for each edge. 
		# An entry in the list is true if the edge is included in this cycle.
		CyclesOfEdges:=function()
			local cyclesOfEdges,e,cyclesOfEdge,cycle;
			cyclesOfEdges:=[];

			for e in [1..Length(edgesOfGraph)] do
				cyclesOfEdge:=BlistList([1..Length(allCycles)],[]);
				for cycle in [1..Length(allCycles)] do
					if e in edgesOfCycles[cycle] then
						cyclesOfEdge[cycle]:=true;
					fi;
				od;
				cyclesOfEdges[e]:=cyclesOfEdge;
			od;
			
			return cyclesOfEdges;
		end;;

		cyclesOfEdges:=CyclesOfEdges();;
		
		# The function checks whether the given cycle has at most one common edge with one element of cycles.
		Possible:=function(cycle,cycles)
			local c;
			for c in cycles do
				if Length(Intersection(edgesOfCycles[cycle],edgesOfCycles[c]))>1 then	
					return false;
				fi; 
			od;
			return true;
		end;;

		# The function computes for a given cycle the sequence of nodes of the cycle.
		NodesOfCycle:=function(cycle)
			local edges,firstNod,actualNode,nodes,e;

			edges:=__SIMPLICIAL_EdgesFromAdjacencyMat(cycle);
		 
			firstNod:=(edges[1])[1];
			actualNode:=(edges[1])[2];
			nodes:=[actualNode];
			Remove(edges,1);

			while actualNode<>firstNod do
				for e in edges do
					if e[1]=actualNode then
						actualNode:=e[2];
						Add(nodes,actualNode);
						Remove(edges,Position(edges,e)); 
					elif e[2]=actualNode then
						actualNode:=e[1];
						Add(nodes,actualNode);
						Remove(edges,Position(edges,e));
					fi; 
				od;
			od;

			return CycleFromList(nodes);
		end;;

		IsPartOf:=function(face,faces)
			local f;
			for f in faces do
				if IsIsomorphic(f,face) then
					return true;
				fi;
			od;
			return false;
		end;;

		FindSurface:=function(graph)
			local smallCy, cycle,cyclesOfFace,usedEdges,edgesOfCycle,c,edge,cyclesToUse; 
			
			# if we search vertex-faithful simplicial surfaces all cycles of length three and four have to be part of the resulting cycle combination
			if vertexFaithful and IsIsomorphicDigraph(graph, CompleteDigraph(4)) then
				smallCy:=Filtered([1..Length(allCycles)], c->SizeBlist(Flat(allCycles[c]))<4);
				smallCy:=BlistList([1..Length(allCycles)],smallCy);
			elif vertexFaithful then
				smallCy:=Filtered([1..Length(allCycles)], c->SizeBlist(Flat(allCycles[c]))<5);
				smallCy:=BlistList([1..Length(allCycles)],smallCy);
			fi;
			
			for cycle in [1..Length(allCycles)] do
				
				cyclesOfFace:=BlistList([1..Length(allCycles)],[cycle]);
				
				if vertexFaithful then
					cyclesOfFace:=UnionBlist(cyclesOfFace, smallCy);
				fi;
				
				usedEdges:=ListWithIdenticalEntries(Length(edgesOfGraph),0);
				
				edgesOfCycle:=[];
				for c in ListBlist([1..Length(allCycles)],cyclesOfFace) do
					edgesOfCycle:=Concatenation(edgesOfCycle,edgesOfCycles[c]);
				od;

				for edge in edgesOfCycle do
					usedEdges[edge]:=usedEdges[edge]+1;
				od;
				
				cyclesToUse:=BlistList([1..Length(allCycles)],[cycle+1..Length(allCycles)]);
				cyclesToUse:=DifferenceBlist(cyclesToUse,cyclesOfFace);
			
				FindCycleComb(cyclesOfFace,usedEdges,1,graph,cyclesToUse);
			od;
		end;;

		# This is a recursive function that searches an admissible cycle combination.  
		# usedEdges stores how often each edge is used.
		# We assume that usedEdges is permissible, that mean each entry is at most two and the cycles overlap at most in one edge 
		# if we search vertex-faithful surfaces.
		# vertexCycleComb is a Boolean list which stores all cycles we used so far.
		# k is the position of the edge that we want to consider where all previous edges are already used twice. We start with the first edge.
		# CyclesToUse is a Boolean list that stores all the cycles that we are currently allowed to use.
		# A cycle must not be used if it contains an edge that has already been used twice.
		FindCycleComb:=function(vertexCycleComb,usedEdges,k,graph,cyclesToUse)
			local face,umbrellaDesk,kcycle,permissible,cycle,j,e,newUsedEdges,newVertexCycleComb,edgesOfCycle,newCyclesToUse,cy;
		
			if ForAll(usedEdges,i->i=2) then
				umbrellaDesk:=[];

				for cycle in ListBlist([1..Length(vertexCycleComb)],vertexCycleComb) do
					Add(umbrellaDesk,NodesOfCycle(allCycles[cycle]));
				od;
			
				face:=SimplicialSurfaceByUmbrellaDescriptor(umbrellaDesk);
				if not IsPartOf(face,faces) then
					Add(faces,face);
				fi;
			else
				if usedEdges[k]=1 and SizeBlist(cyclesToUse)>0 then
				
					kcycle:=IntersectionBlist(cyclesOfEdges[k],cyclesToUse);

					# Checks which cycle we can add to our combination such that k is contained twice and the new combination is permissible.
					for j in ListBlist([1..Length(kcycle)],kcycle) do
							
						if not vertexFaithful or Possible(j,ListBlist([1..Length(allCycles)],vertexCycleComb))then
							
							# permissible stores if the current vertexCycleComb together with the new cycle is admissible. 
							permissible:=true;

							edgesOfCycle:=edgesOfCycles[j];
								
							for e in edgesOfCycle do
								if usedEdges[e]>=2 then
									permissible:=false;
								fi;
							od;
								
							if permissible then

								newUsedEdges:=ShallowCopy(usedEdges);
								for e in edgesOfCycle do
									newUsedEdges[e]:=usedEdges[e]+1;
								od;

								newVertexCycleComb:=ShallowCopy(vertexCycleComb);
								newVertexCycleComb[j]:=true;

								newCyclesToUse:=DifferenceBlist(cyclesToUse,kcycle);
			
								for e in edgesOfCycle do
									if newUsedEdges[e]=2 and e>k then
										newCyclesToUse:=DifferenceBlist(newCyclesToUse,cyclesOfEdges[e]);
									fi;
								od;	
								FindCycleComb(newVertexCycleComb,newUsedEdges,k+1,graph,newCyclesToUse);
							fi;
						fi;
					od;
				elif usedEdges[k]=0 and SizeBlist(cyclesToUse)>0 then
						
					# Checks which cycle pair of k can be added to our cycle combination
					for j in possibleCyclesPairs[k] do
						
						if cyclesToUse[j[1]] and cyclesToUse[j[2]] and (not vertexFaithful or Possible(j[1],
							ListBlist([1..Length(allCycles)],vertexCycleComb)) and Possible(j[2],ListBlist([1..Length(allCycles)],
							vertexCycleComb))) then
							edgesOfCycle:=Union(edgesOfCycles[j[1]],edgesOfCycles[j[2]]);						

							# permissible stores if the current vertexCycleComb together with the new cycle is admissible. 
							permissible:=true;
								
							for e in edgesOfCycle do
								if usedEdges[e]>=2 then
									permissible:=false;
								fi;
							od;

							if not vertexFaithful then
								for e in Intersection(edgesOfCycles[j[1]],edgesOfCycles[j[2]]) do
									if usedEdges[e]>=1 then
										permissible:=false;
									fi;
								od;
							fi;

							if permissible then 
							
								newUsedEdges:=ShallowCopy(usedEdges);
								for e in edgesOfCycle do
									newUsedEdges[e]:=newUsedEdges[e]+1;
								od;
									
								if vertexFaithful then
									newUsedEdges[k]:=newUsedEdges[k]+1;
								else
									for e in Intersection(edgesOfCycles[j[1]],edgesOfCycles[j[2]]) do
										newUsedEdges[e]:=newUsedEdges[e]+1;
									od;
								fi;
								
								newVertexCycleComb:=ShallowCopy(vertexCycleComb);
								newVertexCycleComb[j[1]]:=true;
								newVertexCycleComb[j[2]]:=true;

								kcycle:=IntersectionBlist(cyclesOfEdges[k],cyclesToUse);
								newCyclesToUse:=DifferenceBlist(cyclesToUse,kcycle);

								for e in edgesOfCycle do
									if newUsedEdges[e]=2 and e>k then
										newCyclesToUse:=DifferenceBlist(newCyclesToUse,cyclesOfEdges[e]);
									fi;
								od;	
								FindCycleComb(newVertexCycleComb,newUsedEdges,k+1,graph,newCyclesToUse);
							fi;
						fi;
					od;
				elif usedEdges[k]=2 then
					FindCycleComb(vertexCycleComb,usedEdges,k+1,graph,cyclesToUse);
				fi;
			fi;
		end;;

		FindSurface(digraph);

		return faces;
		
		end;;
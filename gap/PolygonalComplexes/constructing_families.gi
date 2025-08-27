#############################################################################
##
#F IsEssentialDisc( <disc> ) . . . . . . . . test whether <disc> is essential
##
## A simplicial surface <disc> is called an essential simplicial disc, if
## it is a connected simplicial surface of Euler Characteristic 1, no
## inner vertex has degree less than 4, no boundary vertex has degree 1,
## no inner edge connects two boundary vertices and the disc has no 3-waists.
##

InstallMethod( IsEssentialDisc, 
    "for a simplicial surface",
    [IsTwistedPolygonalComplex],
    
      function( disc )

           local bound, v, inner, innerE, e;

           if not IsSimplicialSurface(disc) then return false; fi;

           if not IsConnectedSurface(disc) then return false; fi;
           if EulerCharacteristic(disc)<>1 then return false; fi;

           bound := BoundaryVertices(disc);
           # ensure that all boundary vertices have degree at least 2
           for v in bound do
               if DegreeOfVertex(disc,v) < 2 then return false; fi;
           od;
           inner := InnerVertices(disc);
           # ensure that all inner vertices have degree at least 4
           for v in inner do
               if DegreeOfVertex(disc,v) <= 3 then return false; fi;
           od;
           innerE := InnerEdges(disc);
            # ensure that all inner edges do not have two boundary vertices
           for e in innerE do
               v := VerticesOfEdge(disc,e);
               if  v[1] in bound and v[2] in bound then return false; fi;
           od;
           # ensure that the disc has no 3-waists
           if Length(AllThreeWaistsOfComplex(disc)) > 0 then return false; fi;
           return true;
end
);



#############################################################################
##
## A relevant 2-path in an essential disc D is a pair of edges of D sharing
## exactly one vertex W such that the two edges are not adjacent to one
## common face.
## Find all relevant 2-paths up to the action of the automorphism
## group of the surface <surf>
##
if IsPackageMarkedForLoading("NautyTracesInterface", ">=0") then
BindGlobal( "__SIMPLICIAL_AllEssentialTwoPaths",
    function( surf )

        local vertices, i, t, umbti, u, relpaths, mp, twosets, isgood,
              aut, orbs, isNewInOrb, li;

        umbti := UmbrellaTipDescriptorOfSurface(surf);
        relpaths := [];

        #check if a two-set t contains two neighbouring vertices
        isgood := function(t,u)
            if IsPerm(u) then
                if t[1]^u=t[2] then return false; fi;
                if t[2]^u=t[1] then return false; fi;
            else
               if Position(u,t[1]) = Position(u,t[2]) + 1 or
                  Position(u,t[1]) = Position(u,t[2]) - 1 then
                    return false;
               fi;
            fi;
            return true;
        end;

        isNewInOrb := function(t)

            local j;

            if Length(orbs) = 0 then return true; fi;

            for j in [1 .. Length(orbs)] do
                if t in orbs[j] then return false; fi;
            od;

            return true;
        end;


        aut := AutomorphismGroupOnVertices(surf);
        orbs := [];

        for i in [1 .. Length(umbti)] do
            if IsBound(umbti[i]) then
                # Construct all 2-paths with middle vertex i
                u := umbti[i];
                if IsPerm(u) then
                    # vertex i is inner
                    mp := MovedPoints(u);
                else
                    # vertex i is a boundary vertex. 
                    mp := umbti[i];
                fi;
                # from every vertex in mp we can find a 2-path
                # to any other via i. Just remove non-relevant paths
                twosets := Combinations(mp, 2);
                twosets := Filtered(twosets, t-> isgood(t,u));
                li := List(twosets, t-> [t[1],i,t[2]]);
                for t in li do
                    if isNewInOrb(t) then
                        Add(orbs, Orbit( aut, t, OnTuples) );
                        Add(relpaths, t);
                    fi;
                od;
             fi;
        od;



        return relpaths;

end
);


# Compute up to isomorphism all surfaces that can be obtained from
# the surface surf by a butterfly insertion along a relevant 2-path

InstallMethod( AllSimplicialSurfacesByEssentialButterflyInsertion,
    "for a simplicial surface",
    [IsSimplicialSurface],
    

    function(surf)

        local allp, surfaces;

        allp := __SIMPLICIAL_AllEssentialTwoPaths(surf);

        surfaces := List(allp, t-> ButterflyInsertion(surf, t)[1]);


        return IsomorphismRepresentatives(surfaces);

end);
fi;


#######################################
##
##      All Surfaces Of A Graph
##

InstallOtherMethod(AllSimplicialSurfacesOfDigraph,"for a digraph",
	[IsDigraph],
	function(digraph)
		Error("ReembeddingsOfDigraph: The package Digraph has to be available with version at least 1.9.0.");
	end
);

InstallMethod(AllSimplicialSurfacesOfDigraph,"for a digraph and a Boolean",
	[IsDigraph,IsBool],
	function(digraph,vertexFaithful)
        Error("ReembeddingsOfDigraph: The package Digraph has to be available with version 1.10.0.");
    end
);

if IsPackageMarkedForLoading( "Digraphs", ">=1.9.0" ) then
BindGlobal("__SIMPLICIAL_EdgesFromCycle",
        function(digraph,cycle)

        local edgesOfCycle, i, edge;

        edgesOfCycle:=[];
        for i in [1..Length(cycle)] do
		if i<Length(cycle) then
			edge:=[cycle[i],cycle[i+1]];
		else
			edge:=[cycle[i],cycle[1]];
		fi;
		Sort(edge);
		Add(edgesOfCycle,Reversed(edge));
	od;

       	return edgesOfCycle;

        end
);

BindGlobal("__SIMPLICIAL_IsNonSeparating",
        function(digraph,cycle)

        local digraphRemoved;

        if not IsSymmetricDigraph(digraph) then
                return false;
        fi;

        digraphRemoved:=DigraphRemoveVertices(digraph,cycle);
        if IsConnectedDigraph(digraphRemoved) then
                return true;
        else
                return false;
        fi;

        end
);

InstallOtherMethod(AllSimplicialSurfacesOfDigraph,"for a digraph",
	[IsDigraph],
	function(digraph)
		return AllSimplicialSurfacesOfDigraph(digraph,false);
	end
);

InstallMethod(AllSimplicialSurfacesOfDigraph,"for a digraph and a Boolean",
	[IsDigraph,IsBool],
	function(digraph,vertexFaithful)
		
		local allCycles,edgesOfGraph, faces,edgesOfCycles,CyclesOfEdges,cyclesOfEdges,FindSurface,FindCycleComb,
		cycle,cyclePair,IsPartOf,possibleCyclesPairs,commonEdges,Possible,e;

		if IsMultiDigraph(digraph) or DigraphHasLoops(digraph) or not IsSymmetricDigraph(digraph) or not IsConnectedDigraph(digraph) then
            		Error("SimplicialSurfaceOfDigraph: Given digraph has to be simple, symmetric and connected");
        	fi;
		if vertexFaithful then
			allCycles:=DigraphAllChordlessCycles(digraph);
			allCycles:=Filtered(allCycles,c->__SIMPLICIAL_IsNonSeparating(digraph,c));
		else
			allCycles:=DigraphAllUndirectedSimpleCircuits(digraph);
		fi;

		edgesOfGraph:=Filtered(DigraphEdges(digraph),e->not IsSortedList(e));

		edgesOfCycles:=[];
		for cycle in [1..Length(allCycles)] do;
			edgesOfCycles[cycle]:=List(__SIMPLICIAL_EdgesFromCycle(digraph,allCycles[cycle]),e->Position(edgesOfGraph,e));
		od;

		possibleCyclesPairs:=[];
		for e in [1..Length(edgesOfGraph)] do
			possibleCyclesPairs[e]:=[];
		od;

		for cyclePair in IteratorOfCombinations([1..Length(allCycles)],2) do
			commonEdges:=Intersection(edgesOfCycles[cyclePair[1]],edgesOfCycles[cyclePair[2]]);
			if Length(commonEdges)=1 and vertexFaithful then
				Add(possibleCyclesPairs[commonEdges[1]],cyclePair);
			elif not vertexFaithful then
				for e in commonEdges do
					Add(possibleCyclesPairs[e],cyclePair);
				od;
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
				smallCy:=Filtered(allCycles, c->Length(c)<4);
				smallCy:=BlistList([1..Length(allCycles)],smallCy);
			elif vertexFaithful then
				smallCy:=Filtered(allCycles, c->Length(c)<5);
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

                		if ForAll(usedEdges,i->i<3) then
					cyclesToUse:=BlistList([1..Length(allCycles)],[cycle+1..Length(allCycles)]);
                   	 		cyclesToUse:=DifferenceBlist(cyclesToUse,cyclesOfFace);
                    
                   			FindCycleComb(cyclesOfFace,usedEdges,1,graph,cyclesToUse);
                		fi;
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
			local admissible, cycleRem, face,umbrellaDesk,kcycle,permissible,cycle,j,e,newUsedEdges,newVertexCycleComb,edgesOfCycle,newCyclesToUse,cy;
		
			if ForAll(usedEdges,i->i=2) then
                		admissible:=true;
                        if vertexFaithful then
                            for cycle in ListBlist([1..Length(vertexCycleComb)],vertexCycleComb) do
                                    cycleRem:=ShallowCopy(vertexCycleComb);
                                    cycleRem[cycle]:=false;
                                    if not Possible(cycle, ListBlist([1..Length(vertexCycleComb)],cycleRem)) then
                                        admissible:=false;
                                    fi;
                            od;
                        fi;

                		if admissible then
                    			umbrellaDesk:=[];

                    			for cycle in ListBlist([1..Length(vertexCycleComb)],vertexCycleComb) do
                        			Add(umbrellaDesk,CycleFromList(allCycles[cycle]));
                    			od;
                
                    			face:=SimplicialSurfaceByUmbrellaDescriptor(umbrellaDesk);
                    			if not IsPartOf(face,faces) then
                        			Add(faces,face);
                    			fi;
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
		
		end
);
fi;


#######################################
##
##      Reembedding of Simplicial Spheres
##

#InstallMethod( ReembeddingsOfDigraph, "for a 3-connected planar graph, a genus and a boolean", 
#[IsDigraph, IsInt, IsBool], function(digraph, g, orientable)
#        Error("ReembeddingsOfDigraph: The package Digraph has to be available with version at least 1.10.0.");
#    end
#);

#InstallMethod(ReembeddingsOfSimplicialSphere,"for a vertex-faithful simplicial sphere, a genus and a boolean",
#	[IsSimplicialSurface, IsInt, IsBool],
#	function(surf, g, orientable)
#        Error("ReembeddingsOfSimplicialSphere: The package Digraph has to be available with version at least 1.10.0.");
#	end
#);

if IsPackageMarkedForLoading( "Digraphs", ">=1.10.0" ) then
# Algorithm from Enami and Weiß 
# Computes for a given vertex-faithful simplicial sphere
# all edge-face equivalent simplicial projective planes, tori, klein bottles

# Computes all twisted subgraphs for the given surface
BindGlobal( "__SIMPLICIAL_TwistedSubgraphs",
    function(dualGraph, g, orientable)
        local ApplyHomomorphism, ProjectivePlane, RemoveQuotient, CompleteTransformationList, GenerateK2m, K2m, Torus, KleinBottle, TestPartitionSetOfSizeTwo;

        ApplyHomomorphism := function(D1, D2, t)
            local old, new, v, im;
            old := OutNeighbours(D1);
            new := List([1 .. DigraphNrVertices(D2)], x -> []);
            for v in DigraphVertices(D1) do
            im := v ^ t;
            if not IsBound(new[im]) then
                new[im] := [];
            fi;
            Append(new[im], OnTuples(old[v], t));
            od;
            return DigraphNC(new);
        end;
        
        # Tests for a bipartite graph whether the nodes in a partionset of of size two are adjacent in the dual graph.
        # If this is the case, the result will not be a simplicial surface.
        TestPartitionSetOfSizeTwo:=function(subgraph,dualGraph)
            local components, i, c;
            if IsBipartiteDigraph(subgraph) then
                components:=ShallowCopy(DigraphBicomponents(subgraph));
                for i in [1..Length(components)] do
                    components[i]:=Filtered(components[i],v->OutNeighboursOfVertex(subgraph,v)<>[]);
                od;
                components:=Filtered(components,c->Length(c)=2);
                for c in components do
                    if IsDigraphEdge(dualGraph,c) then
                        return false;
                    fi;
                od;
                return true;
            else
                Error("not bipartite");
            fi;
        end;

        # Computes all twisted subgraphs for the projective plane
        ProjectivePlane:=function(dualGraph)
            local subdigraphs;
            subdigraphs:=SubdigraphsMonomorphisms(CompleteDigraph(4),dualGraph);
            return List(subdigraphs,g->ApplyHomomorphism(CompleteDigraph(4),dualGraph,g));
        end;

        # Computes all twisted subgraphs for the torus
        Torus:=function(dualGraph)
            local trans, subdigraphs, sub, m;

            trans:=SubdigraphsMonomorphisms(CompleteMultipartiteDigraph([2,2,2]),dualGraph);
            subdigraphs:=List(trans,g->ApplyHomomorphism(CompleteMultipartiteDigraph([2,2,2]),dualGraph,g));

            for m in [1..Int(DigraphNrVertices(dualGraph)/2)-1] do
                trans:=SubdigraphsMonomorphisms(CompleteMultipartiteDigraph([2,2*m]),dualGraph);
                sub:=List(trans,g->ApplyHomomorphism(CompleteMultipartiteDigraph([2,2*m]),dualGraph,g));
                Append(subdigraphs,Filtered(sub,g->TestPartitionSetOfSizeTwo(g,dualGraph)));
            od;
            
            return subdigraphs;
        end;

        # Computes all twisted subgraphs for the Klein bottle
        KleinBottle:=function(dualGraph)
            local A3, A5, A6, trans, subdigraphs, m, sub;
            
            A3:=Digraph([[2,3,4],[1,3,4],[1,2,4],[1,2,3],[6,7,8],[5,7,8],[5,6,8],[5,6,7]]);
            A5:=Digraph([[2,3,4],[1,3,4],[1,2,4],[1,2,3,5,6,7],[4,6,7],[4,5,7],[4,5,6]]);
            A6:=Digraph([[2,3,4],[1,3,4],[1,2,5,6],[1,2,5,6],[3,4,6],[3,4,5]]);

            trans:=SubdigraphsMonomorphisms(A3,dualGraph);
            subdigraphs:=List(trans,g->ApplyHomomorphism(A3,dualGraph,g));

            trans:=SubdigraphsMonomorphisms(A5,dualGraph);
            Append(subdigraphs,List(trans,g->ApplyHomomorphism(A5,dualGraph,g)));
            
            trans:=SubdigraphsMonomorphisms(A6,dualGraph);
            Append(subdigraphs,List(trans,g->ApplyHomomorphism(A6,dualGraph,g)));

        for m in [2..Int((DigraphNrVertices(dualGraph)-1)/2)] do
                trans:=SubdigraphsMonomorphisms(CompleteMultipartiteDigraph([2,2*m-1]),dualGraph);
                sub:=List(trans,g->ApplyHomomorphism(CompleteMultipartiteDigraph([2,2*m-1]),dualGraph,g));
                Append(subdigraphs,Filtered(sub,g->TestPartitionSetOfSizeTwo(g,dualGraph)));
            od;
            return subdigraphs;
        end;

        if g=1 and not orientable then
            return ProjectivePlane(dualGraph);
        elif g=1 and orientable then
            return Torus(dualGraph);
        elif g=2 and not orientable then
            return KleinBottle(dualGraph);
        else   
            Error("Choose another genus and orientability");
        fi;
end
);

InstallMethod(ReembeddingsOfSimplicialSphere,"for a vertex-faithful simplicial sphere, a genus and a boolean",
	[IsSimplicialSurface, IsInt, IsBool],
	function(surf, g, orientable)
        if EulerCharacteristic(surf)=2 and IsVertexFaithful(surf) then
		    return ReembeddingsOfDigraph(FaceDigraphsGraph(surf),g,orientable);
        else
            Error("The given simplicial surface is not a vertex-faithful simplicial sphere");
        fi;
	end
);

InstallMethod(ReembeddingsOfDigraph, 
    "for a 3-connected planar graph, a genus and a boolean", [IsDigraph, IsInt, IsBool],
    function( digraph, g, orientable)
    local DualGraph, RemoveTwistedSubgraphs, FindTwistedEdges, Corners, FindPosition, NextNeighbour,
          NewEmbedding, DigraphsToSurf, facialCycles, rotationSystem, dualGraph, subdigraphs;
        
    if not IsPlanarDigraph(digraph) then
        Error("The given graph is not planar.");
    elif not ForAll(OutDegrees(digraph),d->d=3) then
        Error("This is not a cubic graph");
    fi;

    if not IsSymmetricDigraph(digraph) then
        digraph:=DigraphSymmetricClosure(digraph);
    fi;

    # Computes the dual graph using the facial cycles
    DualGraph:=function(facialCycles)
        local edges, c1,c2,commonNodes;

        edges:=[];
        for c1 in [1..Length(facialCycles)-1] do
            for c2 in [c1+1..Length(facialCycles)] do
                commonNodes:=Intersection(facialCycles[c1],facialCycles[c2]);
                if commonNodes<>[] then
                    Add(edges,[c1,c2]);
                    Add(edges,[c2,c1]);
                fi;
            od;
        od;
        return DigraphByEdges(edges);
    end;

    # Removes subgraphs so that we cannot get isomorphic embeddings afterwards
    RemoveTwistedSubgraphs:=function(subdigraphs,digraph)
        local edges, orbits, g, component, remove, l, pos;
        edges:=List(subdigraphs,g->Set(DigraphEdges(g)));
        orbits:=List(edges,n->Orbit(AutomorphismGroup(dualGraph),n,OnSetsTuples));
        
        for g in subdigraphs do
            remove:=[];
            for l in Difference(Filtered([1..Length(orbits)],i->edges[Position(subdigraphs,g)] in orbits[i]),[Position(subdigraphs,g)]) do
                Add(remove,subdigraphs[l]);
            od;
            for l in remove do
                pos:=Position(subdigraphs,l);
                Remove(subdigraphs,pos);
                Remove(orbits,pos);
                Remove(edges,pos);
            od;
        od;
        return subdigraphs;
    end;

    # Compute the twisted arcs in the original graph by the twisted subgraph
    FindTwistedEdges:=function(digraph,facialCycles)
        local twistedEdges,edge;
        twistedEdges:=[];
        for edge in DigraphEdges(MaximalAntiSymmetricSubdigraph(digraph)) do
            Add(twistedEdges,Intersection(facialCycles[edge[1]],facialCycles[edge[2]]));
            Sort(Last(twistedEdges));
        od;
        return twistedEdges;
    end;

    # Computes all corners of a graph by the rotation system
    Corners:=function(rotationSystem)
        local corners, v, pair;
        corners:=[];
        for v in [1..Length(rotationSystem)] do
            for pair in Combinations(rotationSystem[v],2) do
                Add(corners,[pair[1],v,pair[2]]);
            od;
        od;
        return corners;
    end;

    # Find the position of the set edge in the list edges
    FindPosition:=function(edge,edges)
        if edge in edges then
            return Position(edges,edge);
        else
            return Position(edges,Reversed(edge));
        fi;
    end;

    # Computes the next vertex in the face traversal procedure
    NextNeighbour:=function(vertex, pos, twisting, rotationSystem)
        if twisting then
                if pos>1 then
                    return rotationSystem[vertex][pos-1];
                else
                    return Last(rotationSystem[vertex]);
                fi;
            else
                if pos<Length(rotationSystem[vertex]) then
                    return rotationSystem[vertex][pos+1];
                else
                    return First(rotationSystem[vertex]);
                fi;
            fi;
    end;

    # Calculates the re-embedding for given twisted edges
    NewEmbedding:=function(twistedEdges,edges,rotationSystem)
        local cycles, corners, corner, last, previous, act, cycle, twisting, v, temp, pos, remove, i, cornerUsed,c;
        cycles:=[];
        corners:=Corners(rotationSystem);

        # Each corner has to be visited by a facial cycle
        while corners<>[] do
            corner:=corners[1];
            last:=corner[1];
            previous:=corner[2];
            act:=corner[3];
            cycle:=ShallowCopy(corner);

            # Checks how we have to start traversing to get a facial cycle that visits corner
            twisting:=twistedEdges[FindPosition([last,previous],edges)];
            v:=NextNeighbour(previous, Position(rotationSystem[previous],last),twisting,rotationSystem);
            if v<>act then
                twisting:=not twisting;
            fi;
    
            if twistedEdges[FindPosition([previous,act],edges)]=true then
                twisting:=not twisting;
            fi;

            # Traverse until we are back at the start vertex
            while act<>last do
                temp:=act;
                act:=NextNeighbour(act, Position(rotationSystem[act],previous),twisting,rotationSystem);
                previous:=temp;

                if act<>last then
                    Add(cycle,act);
                fi;

                # Adjust twisting
                if previous<act then
                    pos:=Position(edges,[previous,act]);
                else
                    pos:=Position(edges,[act,previous]);
                fi;
                if twistedEdges[pos]=true then
                    twisting:= not twisting;
                fi;
            od;
        
            remove:=[];

            # Remove the corners which are visited now
            for i in [1..Length(cycle)] do
                if i=1 then
                    cornerUsed:=[Last(cycle),First(cycle),cycle[2]];
                elif i=Length(cycle) then
                    cornerUsed:=[cycle[i-1],Last(cycle),First(cycle)];
                else
                    cornerUsed:=[cycle[i-1],cycle[i],cycle[i+1]];
                fi;
                if cornerUsed in corners then
                    pos:=Position(corners,cornerUsed);
                else 
                    pos:=Position(corners,Reversed(cornerUsed));
                    cornerUsed:=Reversed(cornerUsed);
                fi;
                if pos=fail then
                    Error("in NewEmbedding");
                else
                    Add(remove,cornerUsed);
                fi;
            od;
            for c in remove do
                Remove(corners,Position(corners,c));
            od;
            Add(cycles,cycle);
        od;
        return cycles;
    end;

    # Calculates for the twisted subgraphs the simplicial embeddings
    DigraphsToSurf:=function(digraph,digraphs,facialCycles,rotationSystem) 
        local res,subdigr,digraphUndirectedEdges,twistedEdges,cycles,umbr,cycle,s,contained,simp;
        res:=[];
        for subdigr in digraphs do
            twistedEdges:=FindTwistedEdges(subdigr,facialCycles);
            digraphUndirectedEdges:=DigraphEdges(MaximalAntiSymmetricSubdigraph(digraph));
            twistedEdges:=BlistList(digraphUndirectedEdges,twistedEdges);
            cycles:=NewEmbedding(twistedEdges,digraphUndirectedEdges,rotationSystem);
            umbr:=[];
            for cycle in cycles do
                Add(umbr,CycleFromList(cycle));
            od;
            Add(res,SimplicialSurfaceByUmbrellaDescriptor(umbr));
        od;
        return res;
    end;

    rotationSystem:=PlanarEmbedding(digraph);
    facialCycles:=FacialWalks(digraph,rotationSystem);
    dualGraph:=DualPlanarGraph(digraph);
    subdigraphs:=__SIMPLICIAL_TwistedSubgraphs(dualGraph, g, orientable);
    subdigraphs:=RemoveTwistedSubgraphs(subdigraphs,digraph);
    return DigraphsToSurf(digraph,subdigraphs,facialCycles,rotationSystem);
end);
fi;
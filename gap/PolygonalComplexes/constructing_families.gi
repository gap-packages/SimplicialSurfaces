#######################################
##
##      Reembedding of Simplicial Spheres
##

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

InstallMethod( ReembeddingsOfDigraph, "for a 3-connected planar graph, a genus and a boolean", 
[IsDigraph, IsInt, IsBool], function(digraph, g, orientable)
        Error("ReembeddingsOfDigraph: The package Digraph has to be available with version at least 1.10.0.");
    end
);

InstallMethod(ReembeddingsOfSimplicialSphere,"for a vertex-faithful simplicial sphere, a genus and a boolean",
	[IsSimplicialSurface, IsInt, IsBool],
	function(surf, g, orientable)
        Error("ReembeddingsOfSimplicialSphere: The package Digraph has to be available with version at least 1.10.0.");
	end
);
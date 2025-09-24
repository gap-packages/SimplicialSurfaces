#####
#####
#####   This file contains the implementations for the incidence graphs
#####
#####

BindGlobal( "__SIMPLICIAL_IncidenceGraph",
    function(complex)
        local maxVertex, maxEdge, maxFace, edgeList, colourList, v, e, f,
                colSet, vertexList, verts;

            maxVertex := VerticesAttributeOfComplex(complex)[NumberOfVertices(complex)];
            maxEdge := Edges(complex)[NumberOfEdges(complex)];

            vertexList := ShallowCopy( VerticesAttributeOfComplex(complex) );
            edgeList := [];
            colourList := ListWithIdenticalEntries( NumberOfVertices(complex), 0 );

            for e in Edges(complex) do
                # There are two vertices for each edge
                verts := VerticesOfEdges(complex)[e];
                Append( edgeList, [ [verts[1], maxVertex+e], [verts[2], maxVertex+e] ] );
            od;
            Append(vertexList, Edges(complex) + maxVertex);
            Append(colourList, ListWithIdenticalEntries( NumberOfEdges(complex), 1 ));

            for f in Faces(complex) do
                Add(colourList, 2); # done manually since NumberOfFaces is not necessarily computed
                for e in EdgesOfFaces(complex)[f] do
                    Add( edgeList, [maxVertex + e, maxVertex + maxEdge + f] );
                od;
            od;
            Append(vertexList, Faces(complex) + maxVertex + maxEdge);

            return [edgeList, colourList, vertexList ];
    end
);


#######################################
##
##      Digraphs
##
InstallMethod( IncidenceDigraphsGraph, "for a polygonal complex",
    [IsPolygonalComplex],
    function( complex )
    local data, vertexList, newColours, shift, i, j;
    data := __SIMPLICIAL_IncidenceGraph(complex);
    vertexList:=data[3];

    newColours:=[];
    shift:=0;
    for i in [1..Length(vertexList)] do
        if vertexList[i]=i+shift then
            Add(newColours,data[2][i]+1);
        else
            if i=1 then
                shift:=vertexList[i]-1;
            else
                shift:=vertexList[i]-vertexList[i-1]-1;
            fi;
            for j in [1..shift] do
                Add(newColours,4);
            od;
            Add(newColours,data[2][i]+1);
        fi;
    od;

    return [DigraphSymmetricClosure(DigraphByEdges(data[1])), newColours];
    end
);

InstallMethod( EdgeDigraphsGraph, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local arcs, diedges, i, graph;
    
    arcs := [];
    diedges := Compacted(VerticesOfEdges(complex));
    for i in [1..Length(diedges)] do
    arcs[2*i-1] := diedges[i];
    arcs[2*i] := Reversed(diedges[i]);
    od;
        # Digraphs can only create graphs with vertices [1..n]
        # Therefore we have to take a subgraph of this graph
        graph := DigraphByEdges( arcs );
        return InducedSubdigraph( graph, 
            VerticesAttributeOfComplex(complex) );
    end
);

InstallMethod(FaceDigraphsGraph, "for a polygonal complex",[IsPolygonalComplex],
function(complex)
    local i, diedges, arcs, loops, graph;
    
    arcs := [];
    diedges := Filtered( FacesOfEdges(complex), i->Length(i)=2);
    for i in [1..Length(diedges)] do
        arcs[2*i-1] := diedges[i];
        arcs[2*i] := Reversed(diedges[i]);
    od;
    
    loops:=Filtered( FacesOfEdges(complex), i->Length(i)=1);
    for i in [1..Length(loops)] do
        Add(arcs,[loops[i][1],loops[i][1]]);
    od;
    
    # Digraphs can only create graphs with vertices [1..n]
    # Therefore we have to take a subgraph of this graph
    graph:=DigraphByEdges(arcs);
    return InducedSubdigraph( graph,Faces(complex) );
end
);
##
##      End Digraphs
##
#######################################




#######################################
##
##      GRAPE
##
if IsPackageMarkedForLoading( "GRAPE", ">=0" ) then
    InstallMethod( IncidenceGrapeGraph, "for a polygonal complex",
        [IsPolygonalComplex],
        function(complex)
 	    local graph, vertices, edges, faces, names, colours, incidence, 
	        trivialAction, maxVert, maxEdge, colourClasses;

            maxVert := VerticesAttributeOfComplex(complex)[NumberOfVertices(complex)];
            maxEdge := Edges(complex)[NumberOfEdges(complex)];
            vertices := ShallowCopy( VerticesAttributeOfComplex(complex) );
            edges := List( Edges(complex), e -> e + maxVert );
            faces := List( Faces(complex), f -> f + maxVert + maxEdge );

            names := Union( vertices, edges, faces);
	        colours := [vertices,edges, faces]; # This gives the actual names
	        incidence := function(x,y)
                if x in vertices and y in edges then
                    return x in VerticesOfEdges(complex)[y-maxVert];
                elif x in edges and y in vertices then
                    return y in VerticesOfEdges(complex)[x-maxVert];
                elif x in edges and y in faces then
                    return x-maxVert in EdgesOfFaces(complex)[y-maxVert-maxEdge];
                elif x in faces and y in edges then
                    return y-maxVert in EdgesOfFaces(complex)[x-maxVert-maxEdge];
                else
		    return false;
	        fi; 
	    end;

	    trivialAction := function( pnt, g )
	        return pnt;
	    end;

	    graph := Graph( Group( () ), names, trivialAction, incidence );
            # Since a grape colouring refers to the graph vertices instead of the names, 
            # we need to redefine the colour classes
            colourClasses := [
                [1 .. Length(vertices)],
                Length(vertices) + [1 .. Length(edges)],
                Length(vertices) + Length(edges) + [1 .. Length(faces)]
            ];

	    return rec( graph := graph, colourClasses := colourClasses );   
        end
    );

     if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
        RedispatchOnCondition( IncidenceGrapeGraph, true, [IsTwistedPolygonalComplex], [IsPolygonalComplex], 0 );
    fi;

    InstallMethod( EdgeGrapeGraph, "for a polygonal complex",
        [IsPolygonalComplex],
        function(complex)
    	    local graph, vertices, names, incidence, trivialAction;

	    vertices := VerticesAttributeOfComplex(complex);

            names := vertices;
	    incidence := function(x,y)
		return Set([x,y]) in VerticesOfEdges(complex);
	    end;

	    trivialAction := function( pnt, g )
		return pnt;
	    end;

	    graph := Graph( Group( () ), names, trivialAction, incidence );

	    return graph;
        end
    );

     if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
        RedispatchOnCondition( EdgeGrapeGraph, true, [IsTwistedPolygonalComplex], [IsPolygonalComplex], 0 );
    fi;
fi;
##
##      End GRAPE
##
#######################################



#######################################
##
##      NautyTracesInterface
##
if IsPackageMarkedForLoading("NautyTracesInterface", ">=0") then
    InstallMethod( IncidenceNautyGraph, "for a polygonal complex",
        [IsPolygonalComplex],
        function(complex)
            local data;
            data := __SIMPLICIAL_IncidenceGraph(complex);

            return NautyColoredGraphWithNodeLabels( data[1], data[2], data[3] );
        end
    );

     if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
        RedispatchOnCondition( IncidenceNautyGraph, true, [IsTwistedPolygonalComplex], [IsPolygonalComplex], 0 );
    fi;

    InstallMethod( ChamberAdjacencyGraph, "for a twisted polygonal complex",
        [IsTwistedPolygonalComplex],
        function(complex)
            local nrNodes, i, chambersOfLabels, c,class,edges, cl, 
	    combCl,twoEdges;

            nrNodes := NumberOfChambers(complex);
            chambersOfLabels := [];
            for i in [1 .. nrNodes] do
                c := Chambers(complex)[i];
                chambersOfLabels[c] := i;
            od;

            # construct the edges
            edges := [];
            Add(edges, List(ZeroAdjacencyClasses(complex), cl -> List(cl, c -> chambersOfLabels[c])));
            Add(edges, List(OneAdjacencyClasses(complex), cl -> List(cl, c -> chambersOfLabels[c])));
            twoEdges := [];
            for class in TwoAdjacencyClasses(complex) do
                if Length(class) > 1 then
		    combCl:=Combinations(class,2);
		    for cl in combCl do
                        Add(twoEdges, List(cl, c -> chambersOfLabels[c]));
		    od;
                fi;
            od;
            Add(edges, twoEdges);

            return NautyEdgeColoredGraph(edges, nrNodes);
        end
    );

    InstallMethod( EdgeNautyGraph, "for a polygonal complex",
        [IsPolygonalComplex],
        function(complex)
            return NautyGraphWithNodeLabels( VerticesOfEdges(complex), 
                VerticesAttributeOfComplex(complex) );
        end
    );

     if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
        RedispatchOnCondition( EdgeNautyGraph, true, [IsTwistedPolygonalComplex], [IsPolygonalComplex], 0 );
    fi;

    InstallMethod(FaceNautyGraph, "for a polygonal complex",[IsPolygonalComplex],
	function(complex)
		local i, diedges, loops;
			
		diedges:=Filtered(FacesOfEdges(complex),i->Length(i)=2);	
		loops:=Filtered(FacesOfEdges(complex),i->Length(i)=1);
		loops:=List(loops,i->[i[1],i[1]]);
			
		return NautyGraphWithNodeLabels( Concatenation(diedges,loops), 
                Faces(complex) );
	end
    );

     if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
        RedispatchOnCondition( FaceNautyGraph, true, [IsTwistedPolygonalComplex], [IsPolygonalComplex], 0 );
    fi;
fi;
##
##      End NautyTracesInterface
##
#######################################




#######################################
##
##      Isomorphism test and automorphism group
##

InstallMethod( AutomorphismGroup, "for a twisted polygonal complex", 
    [IsTwistedPolygonalComplex],
    function(complex)
        Error("AutomorphismGroup: The package NautyTracesInterface has to be available.");
    end
);

InstallOtherMethod( IsIsomorphic,
    "for two twisted polygonal complexes",
    [IsTwistedPolygonalComplex, IsTwistedPolygonalComplex],
    function(complex1, complex2)
        local inc1, inc2, g1, g2, iso1, iso2, c1, c2;
    
        if IsSimplicialSurface(complex1) and IsSimplicialSurface(complex2) and CounterOfButterflies(complex1)<>CounterOfButterflies(complex2) then
            return false;
        fi;

        inc1 := IncidenceDigraphsGraph(complex1);
        inc2 := IncidenceDigraphsGraph(complex2);
        g1:=inc1[1];
        g2:=inc2[1];

        iso1:=Filtered(DigraphVertices(g1),v->OutDegreeOfVertex(g1,v)=0);
        iso2:=Filtered(DigraphVertices(g2),v->OutDegreeOfVertex(g2,v)=0);

        g1:=DigraphRemoveVertices(g1,iso1);
        g2:=DigraphRemoveVertices(g2,iso2);
        
        c1:=Filtered(inc1[2],c->c<4);
        c2:=Filtered(inc2[2],c->c<4);

        return IsIsomorphicDigraph(g1,g2,c1,c2);
    end
);

if IsPackageMarkedForLoading( "GRAPE", ">=0" ) then
    InstallOtherMethod( IsIsomorphic,
        "for two polygonal complexes",
        [IsPolygonalComplex, IsPolygonalComplex],
        function(complex1, complex2)
            local inc1, inc2;
		
            if IsSimplicialSurface(complex1) and IsSimplicialSurface(complex2) and CounterOfButterflies(complex1)<>CounterOfButterflies(complex2) then
		return false;
	    fi;

            inc1 := IncidenceGrapeGraph(complex1);
            inc2 := IncidenceGrapeGraph(complex2);
            # We copy the structure fully, so that all components stay mutable
            # (this is necessary for GRAPE to function)
            return IsIsomorphicGraph(
                rec( graph := ShallowCopy(inc1.graph), colourClasses := ShallowCopy(inc1.colourClasses) ),
                rec( graph := ShallowCopy(inc2.graph), colourClasses := ShallowCopy(inc2.colourClasses) )
            );
        end
    );
fi;

if IsPackageMarkedForLoading("NautyTracesInterface", ">=0") then
    InstallMethod( IsIsomorphic, 
        "for two twisted polygonal complexes", 
        [IsTwistedPolygonalComplex, IsTwistedPolygonalComplex],5,
        function(complex1, complex2)
        if IsSimplicialSurface(complex1) and IsSimplicialSurface(complex2) and CounterOfButterflies(complex1)<>CounterOfButterflies(complex2) then
              return false;
        fi;

        return IsomorphismGraphs( 
            ChamberAdjacencyGraph(complex1),
            ChamberAdjacencyGraph(complex2)) <> fail;
        end
    );

    InstallMethod( AutomorphismGroup, "for a twisted polygonal complex", 
        [IsTwistedPolygonalComplex],
        function(complex)
            return AutomorphismGroup( ChamberAdjacencyGraph(complex) );
        end
    );
fi;


InstallMethod( IsomorphismRepresentatives,
    "for a list of twisted polygonal complexes", [IsList],
    function(ls)
        local newList, p, q, newOne;

        for p in ls do
            if not IsTwistedPolygonalComplex(p) then
                Error("IsomorphismRepresentatives: Argument has to be a list of twisted polygonal complexes.");
            fi;
        od;

        newList := [];
        for p in ls do
            newOne := true;
            for q in newList do
                if IsIsomorphic(p,q) then
                    newOne := false;
                    break;
                fi;
            od;
            if newOne then
                Add(newList, p);
            fi;
        od;

        return newList;
    end
);

if IsPackageMarkedForLoading("NautyTracesInterface", ">=0") then
InstallMethod( CanonicalRepresentativeOfPolygonalSurface, 
    "for a polygonal surface", [IsPolygonalSurface],
    function( surf )
        local originalfacesofsurf, originaledgesofsurf, originalverticesofsurf,
        totalgraphverts, mapfaces, mapedges, mapvertices, currentvert, i, vertsofgraph,
        edges, edgesofface, j, verticesofface, verticesofedge, graph, perm, perminv, 
        edgesoffacesofsurf, F, edgesofface2, verticesofedgesofsurf, e, verticesofedge2,
        newfaces, newedges, newvertices, n1, n2, n3,
        mapfaces2, mapedges2, mapvertices2, edgesoffacesofsurf2, verticesofedgesofsurf2,
        surf2, surf3, colours, inversefacemap, inverseedgemap, inversevertexmap;


        # The original faces/edges/vertices of surf
        originalfacesofsurf := Faces(surf); 
        originaledgesofsurf := Edges(surf);
        originalverticesofsurf := VerticesAttributeOfComplex(surf);
        # The number of faces/edges/vertices of surf
        n1 := NumberOfFaces(surf);
        n2 := NumberOfEdges(surf);
        n3 := NumberOfVertices(surf);
        # Total number of elements of surf - we make a bijection with the elements
        totalgraphverts := n1+n2+n3;

        # Create maps from the elements to the new labels.
        # Map faces to [1 .. n1], edges to [n1+1 .. n1+n2] and vertices to [n1+n2+1 .. totalverts]
        # Let i be a face, then the i maps to mapfaces[i]
        mapfaces := [];
        mapedges := [];
        mapvertices := [];
        # Also assign each element a colour - faces are 1, edges are 2, vertices are 3
        # Let i be an element of surf with the new labelling. Then the colour can be
        # established with colours[i]
        colours:=[];
        for i in [1..n1] do
            mapfaces[originalfacesofsurf[i]] := i;
        od;
        Append(colours, ListWithIdenticalEntries(n1,1));
        for i in [1..n2] do
            mapedges[originaledgesofsurf[i]] := i + n1;
        od;
        Append(colours, ListWithIdenticalEntries(n2,2));
        for i in [1..n3] do
            mapvertices[originalverticesofsurf[i]] := i + n1 + n2;
        od;
        Append(colours, ListWithIdenticalEntries(n3,3));


        # Create the corresponding graph.
        # The elements of surf form the vertices of the graph.
        # There is an edge in the graph if the corresponding elements of surf are incident.
        vertsofgraph := [1 .. totalgraphverts];

        # Loop through the faces and for each face loop through vertices and edges.
        # If the face is incident with the edge/vertex, put an edge in the graph.
        edges := [];
        for i in originalfacesofsurf do
            edgesofface := EdgesOfFaces( surf )[i];
            for j in edgesofface do
                Add(edges, [mapfaces[i], mapedges[j]]);
            od; 
            verticesofface := VerticesOfFaces( surf ) [i]; 
            for j in verticesofface do
                Add(edges, [mapfaces[i], mapvertices[j]]);
            od; 
        od;
        # Repeat for edges. Only need to check for vertices, since we did faces-edges above.
        for i in originaledgesofsurf do
            verticesofedge := VerticesOfEdges( surf )[i];
            for j in verticesofedge do
                Add(edges, [mapedges[i], mapvertices[j]]);
            od; 
        od;
        # No need to loop through vertices, since vertices are not incident with vertices,
        # and incidence with faces/edges done above.

        # Find the canonical form of the graph with Nauty,
        # preserving the colours (ie  map faces to faces, edges to edge etc...)
        graph := NautyColoredGraph(edges, colours);
        # Find the permutation which will map the old vertices to the new.
        perminv := CanonicalLabeling(graph);
        perm := perminv^(-1);

        # Now that we have the canonical labelling, we can write the surface in canonical form.
        # First take a face and write it by its edges
        # Map the face to its new labelling, and then permute to canonical form.
        # Map the edges to the new labelling
        # Permute the newly labelled eges to their canonical form.
        # Now put the edges in the list of FacesByEdges
        edgesoffacesofsurf := [];
        for i in originalfacesofsurf do
            F := mapfaces[i]^perm;
            edgesofface := EdgesOfFaces( surf )[i];
            edgesofface2 := [];
            for j in [1..Length(edgesofface)] do
                edgesofface2[j] := mapedges[edgesofface[j]]^perm;
            od;
            edgesoffacesofsurf[F] := edgesofface2;
        od;

        # Same as above, but for edges with respect to vertices
        verticesofedgesofsurf := [];
        for i in originaledgesofsurf do
            e := mapedges[i]^perm;
            verticesofedge := VerticesOfEdges( surf )[i];
            verticesofedge2 := [];
            for j in [1..Length(verticesofedge)] do
                verticesofedge2[j] := mapvertices[verticesofedge[j]]^perm;
            od;
            verticesofedgesofsurf[e] := verticesofedge2;
        od;


        # Map the elements to the new labelling, then permute to canonical form
        newfaces := [1..n1];
        newedges := [n1+1..n1+n2];
        newvertices := [n1+n2+1..n1+n2+n3];

        # Now that we have the newly labelled, canonical elements,
        # we map them to a lex least labelling.
        # The newfaces are [1..n1] and will stay that way
        # The newedges are [n1+1..n1+n2] and their minimal labeling is [1..n2]
        #    (so the performed operation is subtraction of n1)
        # newvertices are [n1+n2+1..n1+n2+n3] and their minimal labeling is [1..n3]
        #    (so the performed operation is subtraction of n1+n2)

        edgesoffacesofsurf2 := [];
        for i in newfaces do
            # we talk about the face i
            edgesoffacesofsurf2[i] := [];
            for j in edgesoffacesofsurf[i] do
                Add(edgesoffacesofsurf2[i], j-n1); # shift edge labels by n1
            od;
        od;

        verticesofedgesofsurf2 := [];
        for i in newedges do
            # we talk about the edge i-n1
            verticesofedgesofsurf2[i-n1] := [];
            for j in verticesofedgesofsurf[i] do
                Add(verticesofedgesofsurf2[i-n1], j - n1 - n2); # shift vertex labels by n1+n2
            od;
        od;

        # To get the inverse map (from the new labels to the old ones), 
        # we reverse the lex least map,
        # then the canonical permuting, then the bijection to new labelling.
        inversefacemap := [];
        for i in newfaces do
            inversefacemap[i] := Faces(surf)[i^perminv];
        od;
        inverseedgemap := [];
        for i in newedges do
            inverseedgemap[i-n1] := Edges(surf)[i^perminv - n1];
        od;
        inversevertexmap := [];
        for i in newvertices do
            inversevertexmap[i-n1-n2] := VerticesAttributeOfComplex(surf)[i^perminv - n1 - n2];
        od;


        # Use the correct constructor 
        if IsSimplicialSurface(surf) then
            surf2 := SimplicialSurfaceByDownwardIncidence(verticesofedgesofsurf2, edgesoffacesofsurf2);
        else
            surf2 := PolygonalSurfaceByDownwardIncidence(verticesofedgesofsurf2, edgesoffacesofsurf2);
        fi;


        # return the canonical form of the surface and
        # the bijections mapping the new elements to old, by element i in canonical surface
        # maps to inversemap[i] in the old surface.
        return [surf2, PolygonalMorphismByListsNC(surf2, surf, 
                    inversevertexmap, inverseedgemap, inversefacemap)];
    end
);
if SIMPLICIAL_ENABLE_SURFACE_REDISPATCH then
    RedispatchOnCondition( CanonicalRepresentativeOfPolygonalSurface, true, 
        [IsPolygonalComplex], [IsPolygonalSurface], 0 );
fi;
fi;


#######################################
##
##      Automorphism group
##

BindGlobal( "__SIMPLICIAL_RestrictToVertices",
    function(complex, g)
        local maxVert, permList, c, vOfC;

        maxVert := Maximum(Vertices(complex));
        permList := [1..maxVert];
        vOfC := VerticesOfChambers(complex);
        for c in Chambers(complex) do
            permList[vOfC[c]] := vOfC[c^g];
        od;
        return PermList(permList);
    end
);
BindGlobal( "__SIMPLICIAL_RestrictToEdges",
    function(complex,  g)
        local maxEdge, permList, c, eOfC;

        maxEdge := Maximum(Edges(complex));
        permList := [1..maxEdge];
        eOfC := EdgesOfChambers(complex);
        for c in Chambers(complex) do
            permList[eOfC[c]] := eOfC[c^g];
        od;
        return PermList(permList);
    end
);

BindGlobal( "__SIMPLICIAL_RestrictToFaces",
    function(complex, g)
        local maxFace, permList, c, fOfC;

        maxFace := Maximum(Faces(complex));
        permList := [1..maxFace];
        fOfC := FacesOfChambers(complex);
        for c in Chambers(complex) do
            permList[fOfC[c]] := fOfC[c^g];
        od;
        return PermList(permList);
    end
);

InstallMethod( DisplayAsAutomorphism, 
    "for a polygonal complex and a permutation",
    [IsTwistedPolygonalComplex, IsPerm],
    function(complex, perm)
        local autVert, autEdge, autFace;

        autVert := __SIMPLICIAL_RestrictToVertices(complex, perm);
        autEdge := __SIMPLICIAL_RestrictToEdges(complex, perm );
        autFace := __SIMPLICIAL_RestrictToFaces(complex, perm);

        return [autVert, autEdge, autFace];
    end
);

if IsPackageMarkedForLoading("NautyTracesInterface", ">=0") then

InstallMethod( AutomorphismGroupOnVertices, "for a polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        local aut, grp, gens, g;

        aut := AutomorphismGroup(complex);
        gens := [];
        for g in GeneratorsOfGroup(aut) do
            Add( gens, __SIMPLICIAL_RestrictToVertices(complex, g) );
        od;

        return Group( gens );
    end
);
InstallMethod( AutomorphismGroupOnEdges, "for a polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        local aut, grp, gens, g;

        aut := AutomorphismGroup(complex);
        gens := [];
        for g in GeneratorsOfGroup(aut) do
            Add( gens, __SIMPLICIAL_RestrictToEdges(complex, g) );
        od;

        return Group( gens );
    end
);
InstallMethod( AutomorphismGroupOnFaces, "for a polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        local aut, grp, gens, g;

        aut := AutomorphismGroup(complex);
        gens := [];
        for g in GeneratorsOfGroup(aut) do
            Add( gens, __SIMPLICIAL_RestrictToFaces(complex, g) );
        od;

        return Group( gens );
    end
);

fi;


InstallMethod( IsAutomorphismDefinedByVertices, "for a polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        return Length( Set(VerticesOfEdges(complex)) ) = NumberOfEdges(complex) 
            and Length( Set(VerticesOfFaces(complex)) ) = NumberOfFaces(complex);
    end
);
InstallMethod( IsAutomorphismDefinedByEdges, "for a polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        return Length( Set(EdgesOfVertices(complex)) ) = NumberOfVertices(complex) 
            and Length( Set(EdgesOfFaces(complex)) ) = NumberOfFaces(complex);
    end
);
InstallMethod( IsAutomorphismDefinedByFaces, "for a polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        return Length( Set(FacesOfEdges(complex)) ) = NumberOfEdges(complex) 
            and Length( Set(FacesOfVertices(complex)) ) = NumberOfVertices(complex);
    end
);


InstallMethod( OnVertexEdgePaths, 
    "for a vertex-edge-path on a polygonal complex and an automorphism",
    [IsVertexEdgePath , IsPerm],
    function( vePath, aut )
        local surf, list, display, verts, edges, i;

        surf := AssociatedPolygonalComplex(vePath);
        display := DisplayAsAutomorphism(surf, aut);
        if display = fail then
            return fail;
        fi;

        list := [];
        verts := VerticesAsList(vePath);
        edges := EdgesAsList(vePath);
        for i in [1..Length(verts)] do
            list[2*i-1] := verts[i]^display[1];
        od;
        for i in [1..Length(edges)] do
            list[2*i] := edges[i]^display[2];
        od;

        return VertexEdgePathNC(surf, list);
    end
);


InstallMethod( OnEdgeFacePaths, 
    "for an edge-face-path on a polygonal complex and an automorphism",
    [IsEdgeFacePath , IsPerm],
    function( efPath, aut )
        local surf, list, display, faces, edges, i;

        surf := AssociatedPolygonalComplex(efPath);
        display := DisplayAsAutomorphism(surf, aut);
        if display = fail then
            return fail;
        fi;

        list := [];
        edges := EdgesAsList(efPath);
        faces := FacesAsList(efPath);
        for i in [1..Length(edges)] do
            list[2*i-1] := edges[i]^display[2];
        od;
        for i in [1..Length(faces)] do
            list[2*i] := faces[i]^display[3];
        od;

        return EdgeFacePathNC(surf, list);
    end
);

#######################################
##
##      Edge Insertion / Reduction
##

BindGlobal( "__SIMPLICIAL_DigraphAddEdgeNC",
    function(D, vertexA, vertexB)
        Add(D!.OutNeighbours[vertexA], vertexB);

        if HaveEdgeLabelsBeenAssigned(D) and not IsMultiDigraph(D) then
            SetDigraphEdgeLabel(D, vertexA, vertexB, 1);
        fi;
    end
);

BindGlobal( "__SIMPLICIAL_EdgeInsertionDirectNC",
    function(D, edgeA, edgeB)
        local numVertices;

        numVertices := Maximum(DigraphVertices(D));

        # Remove former edges
        D := DigraphRemoveEdge(D, edgeA);
        D := DigraphRemoveEdge(D, Reversed(edgeA));
        D := DigraphRemoveEdge(D, edgeB);
        D := DigraphRemoveEdge(D, Reversed(edgeB));

        # Add two new vertices that will represent the insertion of two surfaces
        # Values of numVertices + 1 and numVertices + 2 represent the two added vertices
        DigraphAddVertex(D, numVertices + 1); # Vertex A
        DigraphAddVertex(D, numVertices + 2); # Vertex B

        # Add two connected edges between each former edge
        #
        # Add edges intersecting former edgeA with Vertex A
        __SIMPLICIAL_DigraphAddEdgeNC(D, edgeA[1], numVertices + 1);
        __SIMPLICIAL_DigraphAddEdgeNC(D, numVertices + 1, edgeA[1]);
        #
        __SIMPLICIAL_DigraphAddEdgeNC(D, edgeA[2], numVertices + 1);
        __SIMPLICIAL_DigraphAddEdgeNC(D, numVertices + 1, edgeA[2]);
        #
        # Add edges intersecting former edgeB with Vertex B
        __SIMPLICIAL_DigraphAddEdgeNC(D, edgeB[1], numVertices + 2);
        __SIMPLICIAL_DigraphAddEdgeNC(D, numVertices + 2, edgeB[1]);
        #
        __SIMPLICIAL_DigraphAddEdgeNC(D, edgeB[2], numVertices + 2);
        __SIMPLICIAL_DigraphAddEdgeNC(D, numVertices + 2, edgeB[2]);

        # Add edges connecting Vertex A and Vertex B
        __SIMPLICIAL_DigraphAddEdgeNC(D, numVertices + 1, numVertices + 2);
        __SIMPLICIAL_DigraphAddEdgeNC(D, numVertices + 2, numVertices + 1);

        return D;
    end
);

InstallMethod( EdgeInsertionNC, "for a digraph and two lists", [IsDigraph, IsList, IsList],
    function (D, edgeA, edgeB)
        local dMutable, isMutable;

        if not IsSymmetricDigraph(D) then
            D := DigraphSymmetricClosure(D);
        fi;

        if IsMutableDigraph(D) then
            isMutable := true;
            dMutable := D;
        else
            isMutable := false;
            dMutable := DigraphMutableCopy(D);
        fi;

        dMutable := __SIMPLICIAL_EdgeInsertionDirectNC(dMutable, edgeA, edgeB);

        if isMutable then
            return dMutable;
        fi;
        return MakeImmutable(dMutable);
    end
);

InstallMethod( EdgeInsertion, "for a digraph and two lists", [IsDigraph, IsList, IsList],
    function (D, edgeA, edgeB)
        local vertices;

        vertices := Union(edgeA, edgeB);

        # Sanity checks
        if Length(vertices) < 3 then
            return ErrorNoReturn("The given edges mustn't have the same vertices");
        fi;

        if not IsSymmetricDigraph(D) then
            D := DigraphSymmetricClosure(D);
        fi;

        if not IsDigraphEdge(D, edgeA) or not IsDigraphEdge(D, edgeB) then
            return ErrorNoReturn("The given edge is not a digraph edge of the given digraph");
        fi;

        return EdgeInsertionNC(D, edgeA, edgeB);
    end
);

BindGlobal( "__SIMPLICIAL_EdgeReductionDirectNC",
    function (D, intersectingEdge)
        local neighbours, neighbour, newEdge;

        # Add new edges
        #
        # left side of intersecting edge
        newEdge := [];
        neighbours := OutNeighboursOfVertex(D, intersectingEdge[1]);
        for neighbour in neighbours do
            if neighbour <> intersectingEdge[2] then
                Add(newEdge, neighbour);
            fi;
        od;
        for neighbour in neighbours do
            DigraphRemoveEdge(D, [intersectingEdge[1], neighbour]);
        od;
        __SIMPLICIAL_DigraphAddEdgeNC(D, newEdge[1], newEdge[2]);
        __SIMPLICIAL_DigraphAddEdgeNC(D, newEdge[2], newEdge[1]);
        #
        # right side of intersecting edge
        newEdge := [];
        neighbours := OutNeighboursOfVertex(D, intersectingEdge[2]);
        for neighbour in neighbours do
            if neighbour <> intersectingEdge[1] then
                Add(newEdge, neighbour);
            fi;
        od;
        for neighbour in neighbours do
            DigraphRemoveEdge(D, [intersectingEdge[2], neighbour]);
        od;
        __SIMPLICIAL_DigraphAddEdgeNC(D, newEdge[1], newEdge[2]);
        __SIMPLICIAL_DigraphAddEdgeNC(D, newEdge[2], newEdge[1]);

        # Remove old vertices
        DigraphRemoveVertices(D, intersectingEdge);

        return D;
    end
);

InstallMethod( EdgeReductionNC, "for a digraph and a list", [IsDigraph, IsList],
    function (D, intersectingEdge)
        local dMutable, isMutable;

        if not IsSymmetricDigraph(D) then
            D := DigraphSymmetricClosure(D);
        fi;

        if IsMutableDigraph(D) then
            isMutable := true;
            dMutable := D;
        else
            isMutable := false;
            dMutable := DigraphMutableCopy(D);
        fi;

        dMutable := __SIMPLICIAL_EdgeReductionDirectNC(dMutable, intersectingEdge);

        if isMutable then
            return dMutable;
        fi;
        return MakeImmutable(dMutable);
    end
);

InstallMethod( EdgeReduction, "for a digraph and a list", [IsDigraph, IsList],
    function (D, edge)
        local leftVertexOutNeighbours, rightVertexOutNeighbours, edgeOutNeighbours;

        if not IsSymmetricDigraph(D) then
            D := DigraphSymmetricClosure(D);
        fi;

        if not IsDigraphEdge(D, edge) then
            return ErrorNoReturn("The given edge is not a digraph edge of given digraph");
        fi;

        leftVertexOutNeighbours := OutNeighboursOfVertex(D, edge[1]);
        rightVertexOutNeighbours := OutNeighboursOfVertex(D, edge[2]);

        # Check if edge vertices have degree three
        if Length(leftVertexOutNeighbours) <> 3 or
        Length(rightVertexOutNeighbours) <> 3 then
            return ErrorNoReturn("The vertices of the given edge must have degree three");
        fi;

        # Check if edge has four outwards neighbours
        edgeOutNeighbours := Union(
            leftVertexOutNeighbours,
            rightVertexOutNeighbours
        );
        if Length(edgeOutNeighbours) <> 6 then
            return ErrorNoReturn("The given edge must have four outwards neighbours");
        fi;

        return EdgeReductionNC(D, edge);
    end
);

InstallMethod( NewGraphsForEdgeInsertion, "for a mutable digraph", [IsMutableDigraph, IsBool],
    function (D, allowTriangleInsertion)
        # placeholder for checks

        return NewGraphsForEdgeInsertionNC(D, allowTriangleInsertion);
    end
);

InstallOtherMethod( NewGraphsForEdgeInsertion, "for an immutable digraph", [IsImmutableDigraph, IsBool],
    function(D, allowTriangleInsertion)
        local dMutable;

        if not IsSymmetricDigraph(D) then
            D := DigraphSymmetricClosure(D);
        fi;

        dMutable := DigraphMutableCopy(D);

        return NewGraphsForEdgeInsertion(dMutable, allowTriangleInsertion);
    end
);

InstallOtherMethod( NewGraphsForEdgeInsertion, "for a digraph", [IsDigraph],
    function(D)
        return NewGraphsForEdgeInsertion(D, true);
    end
);

InstallMethod( NewGraphsForEdgeInsertionNC, "for a mutable digraph", [IsMutableDigraph, IsBool],
    function (D, allowTriangleInsertion)
        local newUniqueGraphs, newGraphs, newGraph, orbits, orbitsS, orbit,
            uniqueEdges, uniqueEdgesS, undirectedEdges, edgeA, edgeB, isUniqueGraph, 
            g1, g2, numIntersectingVertices, stab;

        if not IsSymmetricDigraph(D) then
            D := DigraphSymmetricClosure(D);
        fi;

        newUniqueGraphs := [];
        newGraphs := [];
        uniqueEdges := [];

        undirectedEdges := Filtered(DigraphEdges(D), e -> (e[1] < e[2]));

        # Calculate Orbits with undirected edges of D
        orbits := Orbits(AutomorphismGroup(D), undirectedEdges, OnSets);

        # For each Orbit only collect the initial edge and store it to uniqueEdges
        for orbit in orbits do
            Add(uniqueEdges, orbit[1]);
        od;

        # For each edge representative find subsequent stabilized representatives
        for edgeA in uniqueEdges do
            stab := Stabilizer(AutomorphismGroup(D), edgeA, OnSets);

            orbitsS := Orbits(
                stab,
                undirectedEdges,
                OnSets
            );

            uniqueEdgesS := [];
            for orbit in orbitsS do
                Add(uniqueEdgesS, orbit[1]);
            od;

            # For each combination of edge representatives do edge insertion
            for edgeB in uniqueEdgesS do
                numIntersectingVertices := Length(Union(edgeA, edgeB));
                if (allowTriangleInsertion and numIntersectingVertices = 3) or
                    numIntersectingVertices = 4 then
                    newGraph := DigraphMutableCopy(D);

                    newGraph := __SIMPLICIAL_EdgeInsertionDirectNC(newGraph, edgeA, edgeB);

                    MakeImmutable(newGraph);
                    Add(newGraphs, newGraph);
                fi;
            od;
        od;

        if Length(newGraphs) = 0 then
            return [];
        fi;

        # for each new graph check if its unique
        for g1 in newGraphs do
            isUniqueGraph := true;

            for g2 in newUniqueGraphs do
                if IsIsomorphicDigraph(g1, g2) then
                    isUniqueGraph := false;
                    break;
                fi;
            od;

            if isUniqueGraph then
                Add(newUniqueGraphs, g1);
            fi;
        od;

        return newUniqueGraphs;
    end
);

InstallOtherMethod( NewGraphsForEdgeInsertionNC, "for a digraph", [IsImmutableDigraph, IsBool],
    function(D, allowTriangleInsertion)
        local dMutable, newUniqueGraphs;

        dMutable := DigraphMutableCopy(D);

        newUniqueGraphs := NewGraphsForEdgeInsertionNC(dMutable, allowTriangleInsertion);

        return newUniqueGraphs;
    end
);

InstallOtherMethod( NewGraphsForEdgeInsertionNC, "for a digraph", [IsDigraph],
    function(D)
        return NewGraphsForEdgeInsertionNC(D, true);
    end
);
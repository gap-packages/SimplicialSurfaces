#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2018
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

#####
#####
#####   This file contains the implementations for the incidence graphs
#####
#####


#######################################
##
##      Digraphs
##
if IsPackageMarkedForLoading( "Digraphs", ">=0.10.1" ) then
    InstallMethod( IncidenceDigraphsGraph, "for a polygonal complex",
        [IsPolygonalComplex],
        function( complex )
            return Digraph( IncidenceGrapeGraph(complex) );
            #TODO is there a better way?
        end
    );

    InstallMethod( EdgeDigraphsGraph, "for a polygonal complex",
        [IsPolygonalComplex],
        function(complex)
            local graph;

            # Digraphs can only create graphs with vertices [1..n]
            # Therefore we have to take a subgraph of this graph
            graph := DigraphByEdges( Compacted( VerticesOfEdges(complex) ) );
            return InducedSubdigraph( graph, 
                VerticesAttributeOfPolygonalComplex(complex) );
        end
    );
fi;
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
	        trivialAction, maxVert, maxEdge;

            maxVert := VerticesAttributeOfPolygonalComplex(complex)[NumberOfVertices(complex)];
            maxEdge := Edges(complex)[NumberOfEdges(complex)];
            vertices := ShallowCopy( VerticesAttributeOfPolygonalComplex(complex) );
            edges := List( Edges(complex), e -> e + maxVert );
            faces := List( Faces(complex), f -> f + maxVert + maxEdge );

            names := Union( vertices, edges, faces);
	    colours := [vertices,edges, faces];
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
	    graph!.colourClasses := colours;

	    return graph;   
        end
    );

    InstallMethod( EdgeGrapeGraph, "for a polygonal complex",
        [IsPolygonalComplex],
        function(complex)
    	    local graph, vertices, names, incidence, trivialAction;

	    vertices := VerticesAttributeOfPolygonalComplex(complex);

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
            local maxVertex, maxEdge, maxFace, edgeList, colourList, v, e, f,
                colSet, vertexList, verts;

            maxVertex := VerticesAttributeOfPolygonalComplex(complex)[NumberOfVertices(complex)];
            maxEdge := Edges(complex)[NumberOfEdges(complex)];

            vertexList := ShallowCopy( VerticesAttributeOfPolygonalComplex(complex) );
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

            return NautyColoredGraphWithNodeLabels( edgeList, colourList, vertexList );
        end
    );

    InstallMethod( EdgeNautyGraph, "for a polygonal complex",
        [IsPolygonalComplex],
        function(complex)
            return NautyGraphWithNodeLabels( VerticesOfEdges(complex), 
                VerticesAttributeOfPolygonalComplex(complex) );
        end
    );
fi;
##
##      End NautyTracesInterface
##
#######################################




#######################################
##
##      Isomorphism test and automorphism group
##

## The order of installation describes which of these functions is
## preferred - the last one has highest priority.
InstallMethod( IsIsomorphicPolygonalComplex, "for two polygonal complexes",
    [IsPolygonalComplex, IsPolygonalComplex],
    function(complex1, complex2)
        Error("IsIsomorphicPolygonalComplex: One of the packages NautyTracesInterface or GRAPE has to be available.");
    end
);
InstallMethod( AutomorphismGroup, "for a polygonal complex", 
    [IsPolygonalComplex],
    function(complex)
        Error("AutomorphismGroup: One of the packages NautyTracesInterface, Digraphs or GRAPE has to be available.");
    end
);

if IsPackageMarkedForLoading("GRAPE", ">=0") then
    InstallMethod( IsIsomorphicPolygonalComplex, 
        "for two polygonal complexes",
        [IsPolygonalComplex, IsPolygonalComplex],
        function(complex1, complex2)
            return IsIsomorphicGraph(
                ShallowCopy( IncidenceGrapeGraph(complex1) ),
                ShallowCopy( IncidenceGrapeGraph(complex2) ) );
        end
    );

    InstallMethod( AutomorphismGroup, "for a polygonal complex",
        [IsPolygonalComplex],
        function(complex)
            return AutGroupGraph( ShallowCopy( IncidenceGrapeGraph(complex) ) );
        end
    );
fi;

if IsPackageMarkedForLoading("Digraphs", ">=0") and not ARCH_IS_WINDOWS() then

#TODO install the digraphs function as soon as it is available

    InstallMethod( AutomorphismGroup, "for a polygonal complex",
        [IsPolygonalComplex],
        function(complex)
            return AutomorphismGroup( IncidenceDigraphsGraph(complex) );
        end
    );
fi;

if IsPackageMarkedForLoading("NautyTracesInterface", ">=0") then
    InstallMethod( IsIsomorphicPolygonalComplex, 
        "for two polygonal complexes", 
        [IsPolygonalComplex, IsPolygonalComplex],
        function(complex1, complex2)
            return IsomorphismGraphs( 
                UnderlyingNautyGraph( IncidenceNautyGraph(complex1) ),
                UnderlyingNautyGraph( IncidenceNautyGraph(complex2) )) <> fail;
        end
    );

    InstallMethod( AutomorphismGroup, "for a polygonal complex", 
        [IsPolygonalComplex],
        function(complex)
            return AutomorphismGroup( IncidenceNautyGraph(complex) );
        end
    );
fi;


InstallMethod( PolygonalComplexIsomorphismRepresentatives,
    "for a list of polygonal complexes", [IsList],
    function(ls)
        local newList, p, q, newOne;

        for p in ls do
            if not IsPolygonalComplex(p) then
                Error("PolygonalComplexIsomorphismRepresentatives: Argument has to be a list of polygonal complexes.");
            fi;
        od;

        newList := [];
        for p in ls do
            newOne := true;
            for q in newList do
                if IsIsomorphicPolygonalComplex(p,q) then
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


#######################################
##
##      Automorphism group
##

#TODO
# currently we use the kernel method RESTRICTED_PERM since
# RestrictedPerm throws an error instead of returning fail.
# can this be changed?

BindGlobal( "__SIMPLICIAL_RestrictToVertices",
    function(complex, g)
        return RESTRICTED_PERM(g, [1..VerticesAttributeOfPolygonalComplex(complex)[NumberOfVertices(complex)]],true);
    end
);
BindGlobal( "__SIMPLICIAL_RestrictToEdges",
    function(complex,  g)
        local maxVert, maxEdge, autEdge, listPerm;

        maxVert := VerticesAttributeOfPolygonalComplex(complex)[NumberOfVertices(complex)];
        maxEdge := Edges(complex)[NumberOfEdges(complex)];
        autEdge := RESTRICTED_PERM(g, [maxVert+1..maxVert+maxEdge],true);

        if autEdge = fail then
            return fail;
        fi;

        # Rescale the permutations
        listPerm := ListPerm(autEdge, maxVert+maxEdge);
        listPerm := listPerm{[maxVert+1..maxVert+maxEdge]} - maxVert;
        autEdge := PermList( listPerm );

        return autEdge;
    end
);

BindGlobal( "__SIMPLICIAL_RestrictToFaces",
    function(complex, g)
        local maxVert, maxEdge, maxFace, autFace, listPerm, sep1, sep2;

        maxVert := VerticesAttributeOfPolygonalComplex(complex)[NumberOfVertices(complex)];
        maxEdge := Edges(complex)[NumberOfEdges(complex)];
        maxFace := Faces(complex)[NumberOfFaces(complex)];

        sep1 := maxVert + maxEdge;
        sep2 := maxVert + maxEdge + maxFace;

        autFace := RESTRICTED_PERM(g, [sep1+1..sep2],true);
        if autFace = fail then
            return fail;
        fi;

        # Rescale the permutation
        listPerm := ListPerm(autFace, sep2);
        listPerm := listPerm{[sep1+1..sep2]} - sep1;
        autFace := PermList( listPerm );

        return autFace;
    end
);

InstallMethod( DisplayAsAutomorphism, 
    "for a polygonal complex and a permutation",
    [IsPolygonalComplex, IsPerm],
    function(complex, perm)
        local autVert, autEdge, autFace;

        autVert := __SIMPLICIAL_RestrictToVertices(complex, perm);
        autEdge := __SIMPLICIAL_RestrictToEdges(complex, perm );
        autFace := __SIMPLICIAL_RestrictToFaces(complex, perm);

        if autVert = fail or autEdge = fail or autFace = fail then
            return fail;
        fi;

        return [autVert, autEdge, autFace];
    end
);

InstallMethod( AutomorphismGroupOnVertices, "for a polygonal complex",
    [IsPolygonalComplex],
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
    [IsPolygonalComplex],
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
    [IsPolygonalComplex],
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


InstallMethod( IsAutomorphismDefinedByVertices, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return Length( Set(VerticesOfEdges(complex)) ) = NumberOfEdges(complex) 
            and Length( Set(VerticesOfFaces(complex)) ) = NumberOfFaces(complex);
    end
);
InstallMethod( IsAutomorphismDefinedByEdges, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return Length( Set(EdgesOfVertices(complex)) ) = NumberOfVertices(complex) 
            and Length( Set(EdgesOfFaces(complex)) ) = NumberOfFaces(complex);
    end
);
InstallMethod( IsAutomorphismDefinedByFaces, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return Length( Set(FacesOfEdges(complex)) ) = NumberOfEdges(complex) 
            and Length( Set(FacesOfVertices(complex)) ) = NumberOfVertices(complex);
    end
);



InstallMethod( CanonicalRepresentativeOfPolygonalSurface, 
    "for a polygonal surface", [IsPolygonalSurface],
    function( surf )
        local originalfacesofsurf, originaledgesofsurf, originalverticesofsurf,
        totalgraphverts, mapfaces, mapedges, mapvertices, currentvert, i, vertsofgraph,
        edges, edgesofface, j, verticesofface, verticesofedge, graph, perm, perminv, 
        edgesoffacesofsurf, F, edgesofface2, verticesofedgesofsurf, e, verticesofedge2,
        newfaces, newedges, newvertices,
        mapfaces2, mapedges2, mapvertices2, edgesoffacesofsurf2, verticesofedgesofsurf2,
        surf2, surf3, colours, inversefacemap, inverseedgemap, inversevertexmap;


        # The original faces/edges/vertices of surf
        originalfacesofsurf := Faces(surf); 
        originaledgesofsurf := Edges(surf);
        originalverticesofsurf := Vertices(surf);
        # The number of faces/edges/vertices of surf
        n1 := NumberOfFaces(surf);
        n2 := NumberOfEdges(surf);
        n3 := NumberOfVertices(surf);
        # Total number of elements of surf - we make a bijection with the elements
        totalgraphverts := n1+n2+n3;

        # Create maps from the elements to the new labels.
        # Map faces to [1 .. n1], edges to [n1+1 .. n1+n2] and vertices to [n1+n2+1 .. totalverts]
        # Let i be a face, then the i maps to mapfaces[i]
        mapfaces := ListWithIdenticalEntries(Maximum(originalfacesofsurf), 0);
        mapedges := ListWithIdenticalEntries(Maximum(originaledgesofsurf), 0);
        mapvertices := ListWithIdenticalEntries(Maximum(originalverticesofsurf), 0);
        # Also assign each element a colour - faces are 1, edges are 2, vertices are 3
        # Let i be an element of surf with the new labelling. Then the colour can be
        # established with colours[i]
        colours:=[];
        currentvert:=0;
        for i in originalfacesofsurf do
            currentvert := currentvert + 1;
            mapfaces[i] := currentvert;
            Add(colours, 1);
        od;
        for i in originaledgesofsurf do
            currentvert := currentvert + 1;
            mapedges[i] := currentvert;
            Add(colours, 2);
        od;
        for i in originalverticesofsurf do
            currentvert := currentvert + 1;
            mapvertices[i] := currentvert;
            Add(colours, 3);
        od;


        # Create the corresponding graph.
        # The elements of surf form the vertices of the graph.
        # There is an edge in the graph if the corresponding elements of surf are incident.
        vertsofgraph := [1 .. totalgraphverts];

        # Loop through the faces and for each face loop through vertices and edges.
        # If the face is incident with the edge/vertex, put an edge in the graph.
        edges := [];
        for i in originalfacesofsurf do
            edgesofface := EdgesOfFace( surf, i);
            for j in edgesofface do
                Add(edges, [mapfaces[i], mapedges[j]]);
            od; 
            verticesofface := VerticesOfFace( surf, i);
            for j in verticesofface do
                Add(edges, [mapfaces[i], mapvertices[j]]);
            od; 
        od;
        # Repeat for edges. Only need to check for vertices, since we did faces-edges above.
        for i in originaledgesofsurf do
            verticesofedge := VerticesOfEdge( surf, i);
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
            edgesofface := EdgesOfFace( surf, i);
            edgesofface2 := List(edgesofface, t -> mapedges[t]^perm);
            edgesoffacesofsurf[F] := edgesofface2;;
        od;

        # Same as above, but for edges with respect to vertices
        verticesofedgesofsurf := [];
        for i in originaledgesofsurf do
            e := mapedges[i]^perm;
            verticesofedge := VerticesOfEdge( surf, i);
            verticesofedge2 := List(verticesofedge, t -> mapvertices[t]^perm);
            verticesofedgesofsurf[e] := verticesofedge2;;
        od;


        # Map the elements to the new labelling, then permute to canonical form
        newfaces := Set(originalfacesofsurf, t -> mapfaces[t]^perm);
        newedges := Set(originaledgesofsurf, t -> mapedges[t]^perm);
        newvertices := Set(originalverticesofsurf, t -> mapvertices[t]^perm);

        # Now that we have the newly labelled, canonical elements,
        # we map them a lex least labelling.
        # We simply take the set of the new + canonical labels and make a bijection to
        # its position in the set.
        mapfaces2 := [];
        for i in [1 .. Size(newfaces)] do
            mapfaces2[newfaces[i]] := i;
        od;
        mapedges2 := [];
        for i in [1 .. Size(newedges)] do
            mapedges2[newedges[i]] := i;
        od;
        mapvertices2 := [];
        for i in [1 .. Size(newvertices)] do
            mapvertices2[newvertices[i]] := i;
        od;

        edgesoffacesofsurf2 := [];
        for i in newfaces do
            F := mapfaces2[i];
            edgesoffacesofsurf2[F] := List(edgesoffacesofsurf[i], t -> mapedges2[t]);;
        od;

        verticesofedgesofsurf2 := [];
        for i in newedges do
            e := mapedges2[i];
            verticesofedgesofsurf2[e] := List(verticesofedgesofsurf[i], t -> mapvertices2[t]);;
        od;

        # To get the inverse map, we reverse the lex least map,
        # then the canonical permuting, then the bijection to new labelling.
        inversefacemap:= List([1 .. n1], t -> Position(mapfaces2, t));
        inversefacemap:= List(inversefacemap, t -> t^perminv);
        inversefacemap:= List(inversefacemap, t -> Position(mapfaces, t));
        inverseedgemap:= List([1 .. n2], t -> Position(mapedges2, t));
        inverseedgemap:= List(inverseedgemap, t -> t^perminv);
        inverseedgemap:= List(inverseedgemap, t -> Position(mapedges, t));
        inversevertexmap:= List([1 .. n3], t -> Position(mapvertices2, t));
        inversevertexmap:= List(inversevertexmap, t -> t^perminv);
        inversevertexmap:= List(inversevertexmap, t -> Position(mapvertices, t));

        surf2 := PolygonalSurfaceByDownwardIncidence(verticesofedgesofsurf2, edgesoffacesofsurf2);

        # return the canonical form of the surface and
        # the bijcetions mapping the new elements to old, by element i in canonical surface
        # maps to inversemap[i] in the old surface.
        return [surf2, [inversefacemap, inverseedgemap, inversevertexmap]];
    end
);

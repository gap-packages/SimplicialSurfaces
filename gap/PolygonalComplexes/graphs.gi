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

    InstallMethod( LocalIncidenceDigraphsGraph, 
        "for a bend polygonal complex",
        [IsBendPolygonalComplex],
        function( complex )
            return Digraph( LocalIncidenceGrapeGraph(complex) );
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
                VerticesAttributeOfVEFComplex(complex) );
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

            maxVert := VerticesAttributeOfVEFComplex(complex)[NumberOfVertices(complex)];
            maxEdge := Edges(complex)[NumberOfEdges(complex)];
            vertices := ShallowCopy( VerticesAttributeOfVEFComplex(complex) );
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

    InstallMethod( LocalIncidenceGrapeGraph, "for a bend polygonal complex",
        [IsBendPolygonalComplex],
        function(complex)
            local maxLocalVert, maxLocalEdge, localVertices, localEdges, 
                halfEdges, names, colours, incidence, trivialAction, graph;

            maxLocalVert := LocalVertices(complex)[Length(LocalVertices(complex))];
            maxLocalEdge := LocalEdges(complex)[Length(LocalEdges(complex))];
            localVertices := ShallowCopy( LocalVertices( complex ) );
            localEdges := List( LocalEdges( complex ), e -> e + maxLocalVert );
            halfEdges := List( HalfEdges( complex ), h -> h + maxLocalVert + maxLocalEdge );

            names := Concatenation( localVertices, localEdges, halfEdges );
            colours := [localVertices, localEdges, halfEdges];
	    incidence := function(x,y)
                if x in localVertices and y in localEdges then
                    return Length( Intersection( 
                        LocalFlagsOfLocalVertices(complex)[x], 
                        LocalFlagsOfLocalEdges(complex)[y-maxLocalVert] ) ) = 1;
                elif x in localEdges and y in localVertices then
                    return Length( Intersection( 
                        LocalFlagsOfLocalEdges(complex)[x-maxLocalVert], 
                        LocalFlagsOfLocalVertices(complex)[y] ) ) = 1;
                elif x in localVertices and y in halfEdges then
                    return Length( Intersection( 
                        LocalFlagsOfLocalVertices(complex)[x], 
                        LocalFlagsOfHalfEdges(complex)[y-maxLocalVert-maxLocalEdge] ) ) = 1;
                elif x in halfEdges and y in localVertices then
                    return Length( Intersection( 
                        LocalFlagsOfHalfEdges(complex)[x-maxLocalVert-maxLocalEdge], 
                        LocalFlagsOfLocalVertices(complex)[y] ) ) = 1;
                elif x in localEdges and y in halfEdges then
                    return Length( Intersection(
                        LocalFlagsOfLocalEdges(complex)[x-maxLocalVert],
                        LocalFlagsOfHalfEdges(complex)[y-maxLocalVert-maxLocalEdge]) ) = 1;
                elif x in halfEdges and y in localEdges then
                    return Length( Intersection(
                        LocalFlagsOfHalfEdges(complex)[x-maxLocalVert-maxLocalEdge],
                        LocalFlagsOfLocalEdges(complex)[y-maxLocalVert-maxLocalVert]) ) = 1;
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

	    vertices := VerticesAttributeOfVEFComplex(complex);

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

            maxVertex := VerticesAttributeOfVEFComplex(complex)[NumberOfVertices(complex)];
            maxEdge := Edges(complex)[NumberOfEdges(complex)];

            vertexList := ShallowCopy( VerticesAttributeOfVEFComplex(complex) );
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

    InstallMethod( LocalIncidenceNautyGraph, "for a bend polygonal complex",
        [IsBendPolygonalComplex],
        function(complex)
            local maxLocalVert, maxLocalEdge, vertexList, edgeList, colourList,
                f, locVert, locEdge, halfEdge;

            maxLocalVert := LocalVertices(complex)[Length(LocalVertices(complex))];
            maxLocalEdge := LocalEdges(complex)[Length(LocalEdges(complex))];

            vertexList := ShallowCopy( LocalVertices(complex) );
            edgeList := [];
            colourList := ListWithIdenticalEntries( Length(LocalVertices(complex)), 0 );

            Append(vertexList, LocalEdges(complex) + maxLocalVert);
            Append(colourList, ListWithIdenticalEntries( Length( LocalEdges(complex) ), 1 ));
            Append(vertexList, HalfEdges(complex) + maxLocalVert + maxLocalEdge);
            Append(colourList, ListWithIdenticalEntries( Length( HalfEdges(complex) ), 2 ));

            for f in LocalFlags(complex) do
                locVert := LocalVerticesOfLocalFlags(complex)[f];
                locEdge := LocalEdgesOfLocalFlags(complex)[f];
                halfEdge := HalfEdgesOfLocalFlags(complex)[f];
                Append(edgeList, [ [ locVert, locEdge + maxLocalVert ], 
                    [ locVert, halfEdge + maxLocalVert + maxLocalEdge ], 
                    [ locEdge + maxLocalVert, halfEdge + maxLocalVert + maxLocalEdge ] ]);
            od;

            return NautyColoredGraphWithNodeLabels( edgeList, colourList, vertexList );
        end
    );



    InstallMethod( EdgeNautyGraph, "for a polygonal complex",
        [IsPolygonalComplex],
        function(complex)
            return NautyGraphWithNodeLabels( VerticesOfEdges(complex), 
                VerticesAttributeOfVEFComplex(complex) );
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

BindGlobal( "__SIMPLICIAL_BendAutomorphismFromNauty",
    function(complex, autGrp)
        local maxLocalVert, maxLocalEdge, gen, genLocVert, genLocEdge, g,
            temp, listPerm, genLocalFlag, i, permList, f, locVert, locEdge,
            face, newLoc, newLocVert, newLocEdge;

        maxLocalVert := LocalVertices(complex)[Length(LocalVertices(complex))];
        maxLocalEdge := LocalEdges(complex)[Length(LocalEdges(complex))];

        gen := GeneratorsOfGroup(autGrp);
        genLocVert := [];
        genLocEdge := [];
        for g in gen do
            Add( genLocVert, RESTRICTED_PERM(g, [1..maxLocalVert], true) );

            temp := RESTRICTED_PERM(g, [maxLocalVert+1..maxLocalVert+maxLocalEdge], true);
            # Rescale
            listPerm := ListPerm(temp, maxLocalVert+maxLocalEdge);
            listPerm := listPerm{[maxLocalVert+1..maxLocalVert+maxLocalEdge]} - maxLocalVert;
            Add( genLocEdge, PermList( listPerm ) );
        od;

        genLocalFlag := [];
        for i in [1..Length(gen)] do
            permList := [];
            for f in LocalFlags(complex) do
                locVert := LocalVerticesOfLocalFlags(complex)[f];
                locEdge := LocalEdgesOfLocalFlags(complex)[f];

                newLocVert := locVert^genLocVert[i];
                newLocEdge := locEdge^genLocEdge[i];
                face := FacesOfLocalVertices(complex)[newLocVert];
                Assert(1, face = FacesOfLocalEdges(complex)[newLocEdge]);

                newLoc := LocalFlagByLocalVertexLocalEdgeFace(complex, newLocVert, newLocEdge, face);
                permList[f] := newLoc;
            od;
            Add(genLocalFlag, PermList(permList));
        od;

        return Group( genLocalFlag );
    end
);

InstallMethod( IsIsomorphic, 
    "for a polygonal complex and a bend polygonal complex",
    [IsPolygonalComplex, IsBendPolygonalComplex],
    function(poly, bend)
        local obj;

        obj := PolygonalComplex(bend);
        if obj = fail then
            return false;
        fi;
        return IsIsomorphic(poly, obj);
    end
);
InstallMethod( IsIsomorphic, 
    "for a bend polygonal complex and a polygonal complex",
    [IsBendPolygonalComplex, IsPolygonalComplex],
    function(bend, poly)
        local obj;

        obj := PolygonalComplex(bend);
        if obj = fail then
            return false;
        fi;
        return IsIsomorphic(poly, obj);
    end
);

## The order of installation describes which of these functions is
## preferred - the last one has highest priority.
InstallMethod( IsIsomorphic, "for two VEF-complexes",
    [IsVEFComplex, IsVEFComplex],
    function(complex1, complex2)
        Error("IsIsomorphic: One of the packages NautyTracesInterface or GRAPE has to be available.");
    end
);
InstallMethod( AutomorphismGroup, "for a polygonal complex", 
    [IsPolygonalComplex],
    function(complex)
        Error("AutomorphismGroup: One of the packages NautyTracesInterface, Digraphs or GRAPE has to be available.");
    end
);
InstallMethod( AutomorphismGroup, "for a bend polygonal complex", 
    [IsBendPolygonalComplex],
    function(complex)
        Error("AutomorphismGroup: One of the packages NautyTracesInterface, Digraphs or GRAPE has to be available.");
    end
);

if IsPackageMarkedForLoading("GRAPE", ">=0") then
    InstallMethod( IsIsomorphic, 
        "for two polygonal complexes",
        [IsPolygonalComplex, IsPolygonalComplex],
        function(complex1, complex2)
            local graph1, graph2;

            Error("IsIsomorphic can't be computed by GRAPE since GRAPE allows the exchange of colour classes.");


            graph1 := ShallowCopy( IncidenceGrapeGraph(complex1) );
            graph2 := ShallowCopy( IncidenceGrapeGraph(complex2) );

            # Compute canonical labelling
            SetAutGroupCanonicalLabellingNauty(graph1, true);
            SetAutGroupCanonicalLabellingNauty(graph2, true);
        end
    );
    InstallMethod( IsIsomorphic, 
        "for two bend polygonal complexes",
        [IsBendPolygonalComplex, IsBendPolygonalComplex],
        function(complex1, complex2)
            Error("IsIsomorphic can't be computed by GRAPE since GRAPE allows the exchange of colour classes.");

            return IsIsomorphicGraph(
                ShallowCopy( LocalIncidenceGrapeGraph(complex1) ),
                ShallowCopy( LocalIncidenceGrapeGraph(complex2) ) );
        end
    );

    InstallMethod( AutomorphismGroup, "for a polygonal complex",
        [IsPolygonalComplex],
        function(complex)
            Error("AutomorphismGroup can't be computed by GRAPE since GRAPE allows the exchange of colour classes.");
            return AutGroupGraph( ShallowCopy( IncidenceGrapeGraph(complex) ) );
        end
    );
    InstallMethod( AutomorphismGroup, "for a bend polygonal complex",
        [IsBendPolygonalComplex],
        function(complex)
            Error("AutomorphismGroup can't be computed by GRAPE since GRAPE allows the exchange of colour classes.");
        end
    );
fi;

if IsPackageMarkedForLoading("Digraphs", ">=0") and not ARCH_IS_WINDOWS() then
    InstallMethod( IsIsomorphic, 
        "for two polygonal complexes",
        [IsPolygonalComplex, IsPolygonalComplex],
        function(complex1, complex2)
            local graph1, graph2, grape1, grape2, col1, col2;

            grape1 := IncidenceGrapeGraph(complex1);
            col1 := grape1.colourClasses;
            graph1 := IncidenceDigraphsGraph(complex1);

            grape2 := IncidenceGrapeGraph(complex2);
            col2 := grape1.colourClasses;
            graph2 := IncidenceDigraphsGraph(complex2);

            return IsomorphismDigraphs(graph1, graph2, col1, col2);
        end
    );
    InstallMethod( IsIsomorphic, 
        "for two bend polygonal complexes",
        [IsBendPolygonalComplex, IsBendPolygonalComplex],
        function(complex1, complex2)
            local graph1, graph2, grape1, grape2, col1, col2;

            grape1 := LocalIncidenceGrapeGraph(complex1);
            col1 := grape1.colourClasses;
            graph1 := LocalIncidenceDigraphsGraph(complex1);

            grape2 := LocalIncidenceGrapeGraph(complex2);
            col2 := grape1.colourClasses;
            graph2 := LocalIncidenceDigraphsGraph(complex2);

            return IsomorphismDigraphs(graph1, graph2, col1, col2);
        end
    );


    InstallMethod( AutomorphismGroup, "for a polygonal complex",
        [IsPolygonalComplex],
        function(complex)
            local graph, grape, col;

            grape := IncidenceGrapeGraph(complex);
            col := grape.colourClasses;
            graph := IncidenceDigraphsGraph(complex);
            return AutomorphismGroup( graph, col );
        end
    );
    InstallMethod( AutomorphismGroup, "for a bend polygonal complex",
        [IsBendPolygonalComplex],
        function(complex)
            local graph, grape, col, aut;

            grape := LocalIncidenceGrapeGraph(complex);
            col := grape.colourClasses;
            graph := LocalIncidenceDigraphsGraph(complex);
            aut := AutomorphismGroup( graph, col );
            return __SIMPLICIAL_BendAutomorphismFromNauty(complex, aut);
        end
    );
fi;

if IsPackageMarkedForLoading("NautyTracesInterface", ">=0") then
    InstallMethod( IsIsomorphic, 
        "for two polygonal complexes", 
        [IsPolygonalComplex, IsPolygonalComplex],
        function(complex1, complex2)
            return IsomorphismGraphs( 
                UnderlyingNautyGraph( IncidenceNautyGraph(complex1) ),
                UnderlyingNautyGraph( IncidenceNautyGraph(complex2) )) <> fail;
        end
    );
    InstallMethod( IsIsomorphic, 
        "for two bend polygonal complexes", 
        [IsBendPolygonalComplex, IsBendPolygonalComplex],
        function(complex1, complex2)
            return IsomorphismGraphs( 
                UnderlyingNautyGraph( LocalIncidenceNautyGraph(complex1) ),
                UnderlyingNautyGraph( LocalIncidenceNautyGraph(complex2) )) <> fail;
        end
    );

    InstallMethod( AutomorphismGroup, "for a polygonal complex", 
        [IsPolygonalComplex],
        function(complex)
            return AutomorphismGroup( IncidenceNautyGraph(complex) );
        end
    );
    InstallMethod( AutomorphismGroup, "for a bend polygonal complex",
        [IsBendPolygonalComplex],
        function(complex)
            return __SIMPLICIAL_BendAutomorphismFromNauty( complex,
                AutomorphismGroup( LocalIncidenceNautyGraph(complex) ) );
        end
    );
fi;


InstallMethod( IsomorphismRepresentatives,
    "for a list of VEF-complexes", [IsList],
    function(ls)
        local newList, p, q, newOne;

        for p in ls do
            if not IsVEFComplex(p) then
                Error("IsomorphismRepresentatives: Argument has to be a list of VEF-complexes.");
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
        return RESTRICTED_PERM(g, [1..VerticesAttributeOfVEFComplex(complex)[NumberOfVertices(complex)]],true);
    end
);
BindGlobal( "__SIMPLICIAL_RestrictToEdges",
    function(complex,  g)
        local maxVert, maxEdge, autEdge, listPerm;

        maxVert := VerticesAttributeOfVEFComplex(complex)[NumberOfVertices(complex)];
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

        maxVert := VerticesAttributeOfVEFComplex(complex)[NumberOfVertices(complex)];
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
        newfaces, newedges, newvertices, n1, n2, n3,
        mapfaces2, mapedges2, mapvertices2, edgesoffacesofsurf2, verticesofedgesofsurf2,
        surf2, surf3, colours, inversefacemap, inverseedgemap, inversevertexmap;


        # The original faces/edges/vertices of surf
        originalfacesofsurf := Faces(surf); 
        originaledgesofsurf := Edges(surf);
        originalverticesofsurf := VerticesAttributeOfVEFComplex(surf);
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
            inversevertexmap[i-n1-n2] := VerticesAttributeOfVEFComplex(surf)[i^perminv - n1 - n2];
        od;

        surf2 := PolygonalSurfaceByDownwardIncidenceNC(verticesofedgesofsurf2, edgesoffacesofsurf2);

        # return the canonical form of the surface and
        # the bijections mapping the new elements to old, by element i in canonical surface
        # maps to inversemap[i] in the old surface.
        return [surf2, [inversefacemap, inverseedgemap, inversevertexmap]];
    end
);

InstallMethod( AutomorphismGroupOnLocalFlags,
    "for a bend polygonal complex", [IsBendPolygonalComplex],
    function(complex)
        return AutomorphismGroup(complex);
    end
);

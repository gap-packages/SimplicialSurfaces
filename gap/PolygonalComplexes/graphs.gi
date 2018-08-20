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


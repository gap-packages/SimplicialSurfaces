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

            maxVert := Maximum( Vertices(complex) );
            maxEdge := Maximum( Edges(complex) );
            vertices := ShallowCopy( Vertices(complex) );
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
                colSet, vertexList;

            maxVertex := Maximum( Vertices(complex) );
            maxEdge := Maximum( Edges(complex) );

            vertexList := ShallowCopy( Vertices(complex) );
            edgeList := [];
            colourList := List( [1..NumberOfVertices(complex)], i -> 0 );

            for e in Edges(complex) do
                Add(colourList, 1);
                Append(edgeList, List( VerticesOfEdges(complex)[e], 
                    v -> [v, maxVertex + e] ) );
                Add(vertexList, maxVertex + e);
            od;

            for f in Faces(complex) do
                Add(colourList, 2);
                Add(vertexList, maxVertex + maxEdge + f);
                Append(edgeList, List( EdgesOfFaces(complex)[f], 
                    e -> [maxVertex + e, maxVertex + maxEdge + f] ) );
            od;

            return NautyColoredGraphWithNodeLabels( edgeList, colourList, vertexList );
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
InstallMethod( IsIsomorphicIncidenceStructure, "for two polygonal complexes",
    [IsPolygonalComplex, IsPolygonalComplex],
    function(complex1, complex2)
        Error("IsIsomorphicIncidenceStructure: One of the packages NautyTracesInterface or GRAPE has to be available.");
    end
);
InstallMethod( AutomorphismGroup, "for a polygonal complex", 
    [IsPolygonalComplex],
    function(complex)
        Error("AutomorphismGroup: One of the packages NautyTracesInterface, Digraphs or GRAPE has to be available.");
    end
);

if IsPackageMarkedForLoading("GRAPE", ">=0") then
    InstallMethod( IsIsomorphicIncidenceStructure, 
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
    InstallMethod( IsIsomorphicIncidenceStructure, 
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


#######################################
##
##      Automorphism group
##

InstallMethod( DisplayAsAutomorphism, 
    "for a polygonal complex and a permutation",
    [IsPolygonalComplex, IsPerm],
    function(complex, perm)
        local maxVert, maxEdge, maxFace, autVert, autEdge, autFace, sep1, 
            sep2, listPerm;

        maxVert := Maximum( Vertices(complex) );
        maxEdge := Maximum( Edges(complex) );
        maxFace := Maximum( Faces(complex) );

        sep1 := maxVert + maxEdge;
        sep2 := maxVert + maxEdge + maxFace;

        # Restrict the permutations
        # We use the kernel method (compare permutat.g, line 535)
        # since we want the return value fail and not an error
        #TODO maybe change this to an option in GAP?
        autVert := RESTRICTED_PERM(perm, [1..maxVert],true);
        autEdge := RESTRICTED_PERM(perm, [maxVert+1..sep1],true);
        autFace := RESTRICTED_PERM(perm, [sep1+1..sep2],true);

        if autVert = fail or autEdge = fail or autFace = fail then
            return fail;
        fi;

        # Rescale the permutations
        listPerm := ListPerm(autEdge, sep1);
        listPerm := listPerm{[maxVert+1..sep1]};
        listPerm := List( listPerm, i -> i - maxVert );
        autEdge := PermList( listPerm );

        listPerm := ListPerm(autFace, sep2);
        listPerm := listPerm{[sep1+1..sep2]};
        listPerm := List( listPerm, i -> i - sep1 );
        autFace := PermList( listPerm );

        return [autVert, autEdge, autFace];
    end
);

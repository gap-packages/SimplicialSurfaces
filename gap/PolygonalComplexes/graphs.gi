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

##
## We define a more general package loading method that works even
## if loading the package normally throws an error (as happens
## quite often when working with Digraphs).
##TODO maybe use CALL_WITH_CATCH(LoadPackage, ["name"]); instead?
#BindGlobal( "__SIMPLICIAL_LoadPackage", 
#    function(name)
#        local breakOnError, res;
#
#        breakOnError := BreakOnError;
#        BreakOnError := false;
#        res := LoadPackage(name);

        # If there was an error in the loading, return false
#        if not IsBound(res) then
#            res := false;
#        fi;

#        BreakOnError := breakOnError;
#        return res;
#    end
#);

InstallMethod( IncidenceGraph, "for a polygonal complex", 
    [IsPolygonalComplex],
    function(complex)
        return IncidenceDigraphsGraph(complex);
    end
);


#######################################
##
##      Digraphs
##
if IsPackageMarkedForLoading( "Digraphs", ">=0.10.1" ) then
InstallMethod( IncidenceDigraphsGraph, "for a polygonal complex",
    [IsPolygonalComplex],
    function( complex )
        if LoadPackage("Digraphs") <> true then
            Error("Package Digraphs has to be available to use IncidenceDigraphsGraph.");
        fi;
    
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
InstallMethod( IncidenceGrapeGraph, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
 	local graph, vertices, edges, faces, names, colours, incidence, 
	    trivialAction, maxVert, maxEdge;
        
        if LoadPackage("GRAPE") <> true then
            Error("Package GRAPE has to be available to use IncidenceGrapeGraph.");
        fi;

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
##
##      End GRAPE
##
#######################################



#######################################
##
##      NautyTracesInterface
##
InstallMethod( IncidenceNautyGraph, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local maxVertex, maxEdge, maxFace, edgeList, colourList, v, e, f,
            colSet, vertexList;

        if LoadPackage("NautyTracesInterface") <> true then
            Error("Package NautyTracesInterface has to be available to use IncidenceNautyGraph.");
        fi;

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
##
##      End NautyTracesInterface
##
#######################################




#######################################
##
##      Isomorphism test
##
InstallMethod( IsIsomorphicIncidenceStructure, "for two polygonal complexes",
    [IsPolygonalComplex, IsPolygonalComplex],
    function(complex1, complex2)
        if LoadPackage("NautyTracesInterface") = true then
            return IsomorphismGraphs( 
                UnderlyingNautyGraph( IncidenceNautyGraph(complex1) ),
                UnderlyingNautyGraph( IncidenceNautyGraph(complex2) )) <> fail;
        elif LoadPackage("GRAPE") = true then
            return IsIsomorphicGraph(
                ShallowCopy( IncidenceGrapeGraph(complex1) ),
                ShallowCopy( IncidenceGrapeGraph(complex2) ) );
        elif not ARCH_IS_WINDOWS() and LoadPackage("Digraphs") = true then # We disable Digraphs on Windows as it may not load
            #TODO is this possible? Then maybe put in in second place
            Error("Isomorphism test in Digraphs not implemented. GRAPE and NautyTracesInterface are not loaded.");
        else
            Error("Isomorphism test needs at least one of the packages NautyTracesInterface, Digraphs or GRAPE.");
        fi;
    end
);


#######################################
##
##      Automorphism group
##
InstallMethod( AutomorphismGroup, "for a polygonal complex", 
    [IsPolygonalComplex],
    function(complex)
        return AutomorphismGroup( IncidenceNautyGraph(complex) );
    end
);

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

#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2016
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
##
BindGlobal( "__SIMPLICIAL_LoadPackage", 
    function(name)
        local breakOnError, res;

        breakOnError := BreakOnError;
        BreakOnError := false;
        res := LoadPackage(name);

        # If there was an error in the loading, return false
        if not IsBound(res) then
            res := false;
        fi;

        BreakOnError := breakOnError;
        return res;
    end
);

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
InstallMethod( IncidenceDigraphsGraph, "for a polygonal complex",
    [IsPolygonalComplex],
    function( complex )
        if __SIMPLICIAL_LoadPackage("Digraphs") <> true then
            Error("Package Digraphs has to be available to use IncidenceDigraphsGraph.");
        fi;
    
        return Digraph( IncidenceGrapeGraph(complex) );
        #TODO is there a better way?
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
InstallMethod( IncidenceGrapeGraph, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
 	local graph, vertices, edges, faces, names, colours, incidence, 
	    trivialAction;
        
        if __SIMPLICIAL_LoadPackage("GRAPE") <> true then
            Error("Package GRAPE has to be available to use IncidenceGrapeGraph.");
        fi;

	vertices := List( Vertices(complex), i -> [0,i] );
        edges := List( Edges(complex), i -> [1,i] );
        faces := List( Faces(complex), i -> [2,i] );

        names := Union( vertices, edges, faces);
	colours := [vertices,edges, faces];
	incidence := function(x,y)
	    if x[1] = 0 and y[1] = 1 then
		return x[2] in VerticesOfEdges(complex)[y[2]];
	    elif x[1] = 1 and y[1] = 0 then
		return y[2] in VerticesOfEdges(complex)[x[2]];

	    elif x[1] = 1 and y[1] = 2 then
		return x[2] in EdgesOfFaces(complex)[y[2]];
	    elif x[1] = 2 and y[1] = 1 then
		return y[2] in EdgesOfFaces(complex)[x[2]];

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

        if __SIMPLICIAL_LoadPackage("NautyTracesInterface") <> true then
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
        if __SIMPLICIAL_LoadPackage("NautyTracesInterface") = true then
            return IsomorphismGraphs( 
                UnderlyingNautyGraph( IncidenceNautyGraph(complex1) ),
                UnderlyingNautyGraph( IncidenceNautyGraph(complex2) )) <> fail;
        elif __SIMPLICIAL_LoadPackage("GRAPE") = true then
            return IsIsomorphicGraph(
                ShallowCopy( IncidenceGrapeGraph(complex1) ),
                ShallowCopy( IncidenceGrapeGraph(complex2) ) );
        elif __SIMPLICIAL_LoadPackage("Digraphs") = true then
            #TODO is this possible? Then maybe put in in second place
            Error("Isomorphism test in Digraphs not implemented. GRAPE and NautyTracesInterface are not loaded.");
        else
            Error("Isomorphism test needs at least one of the packages NautyTracesInterface, Digraphs or GRAPE.");
        fi;
    end
);

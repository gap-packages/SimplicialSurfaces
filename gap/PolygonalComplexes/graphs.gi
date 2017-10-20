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


##
##      End NautyTracesInterface
##
#######################################

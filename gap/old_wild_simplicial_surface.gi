#! @DoNotReadRestOfFile

##############################################################################
##
#W  wild_simplicial_surface.gi          Simplicial         Alice Niemeyer
#W                                                        Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Alice Niemeyer, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##
##  The functions in this file compute with wild coloured simplicial surfaces.
##
##  There are several ways of inputting a wild coloured simplicial surface.
##
##  A wild coloured simplicial surface is created by the function 
##  WildSimplicialSurface and is a GAP object. Simplicial surfaces can be 
##  obtained as follows:
##
##  1) Given a triple <gens> of involutions, the function
##     AllWildSimplicialSurfaces(gens)  computes  all wild coloured simplicial 
##     surfaces whose faces are the moved points of the generators and whose
##     edges are determined by the 2-cycles of the generators.
##  2) Input a surface by first listing the faces, 
##     then pairs of faces making up the edges, 
##     then the face-paths for  each vertex.  A face-path is simply
##     a list of the faces in the order in which they occur around a vertex.
##     The function WildSimplicialSurfacesFromFacePath takes this input
##     and returns all wild coloured simplicial surfaces matching the
##     description
##  3) Input a wild coloured surface by the following data structure, 
##     called the *generic-surface* data structure. The generic-surface
##     data structure is the most general data structure to describe
##     surfaces and is not restricted to wild coloured surfaces only.
##     The generic-surface data structure is a list of
##      the number of vertices, edges and faces
##      then pairs of vertices making up the edges, 
##      then triples of edges making up the faces, e.g.
##      ( |V|, |E|, |F|, [ [v1,v2],...],  [[e1,e2,e3],... ] )
##       here ei is a number, which is a position in the list of edges,
##       so that the list of vertex pairs can be indexed by ei to find
##       the two vertex numbers of edges ei.
##     
##
##
##    As GAP objects, certain general methods are installed for 
##    simplicial surface objects, such as Print and Display and "=".
##
##    The mr-type of a wild coloured simplicial surface <simpsurf>
##    can be determined with the function MrTypeOfWildSimplicialSurface.
##
##    As Simplicial surfaces are GAP objects, they cannot be 
##    accessed like records.
##
##    An action of a permutation on a simplicial surface is installed, 
##    allowing us to compute the orbits of a group acting on a set of
##    simplicial surfaces.
##    
##




#InstallMethod( \<, "for two simplicial surfaces", true, 
#  [ IsWildSimplicialSurfaceRep, IsWildSimplicialSurfaceRep ], 0,
#   LtWildSimplicialSurface );

GenericSurfaceCommonCover := function(cov)

        local surf, i, j, edges, faces, vertices;

        surf := [];

        surf[1] := Length(cov.vertices);
        surf[2] := Length(cov.edges);
        surf[3] := Length(cov.faces);
        
        surf[4] := [];
        surf[5] := List( cov.faces, i-> [] );
        for i in [ 1.. Length(cov.faces) ] do
            for j in [ 1.. Length(cov.edges) ] do
                if i^cov.edges[j] <> i then
                    Add( surf[5][i], j );
                fi;
            od;
        od;

	return surf;

end;


end;


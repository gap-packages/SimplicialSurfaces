##############################################################################
##
#W  wild_simplicial_surface.gd     SimplicialSurfaces     Alice Niemeyer
#W														Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Alice Niemeyer, Markus Baumeister, 
#Y  Lehrstuhl B für Mathematik, RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the declaration part for the wild simplicial surfaces
##	of the SimplicialSurfaces package.
##
##	TODO description of wild coloured simplicial surfaces
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

##
##	Wild simplicial surfaces are simplicial surfaces that have additional
##	structure. Since not every simplicial surface admits a unique wild 
##	colouring, we don't define it as an attribute but rather as a separate
##	object (which is encoded as a category).
##
DeclareCategory( "IsWildSimplicialSurface", IsSimplicialSurface and
												 IsActualSurface );
InstallTrueMethod( IsSimplicialSurface, IsWildSimplicialSurface );
# TODO is this necessary? 80.8-1 and 78.7-1 seem to be in conflict here.


#############################################################################
##
##
#!  @Section Attributes and properties of wild coloured simplicial surfaces
#!
#!


#############################################################################
##
##
#!  @Section Functions for wild coloured simplicial surfaces
#!
#!
#!

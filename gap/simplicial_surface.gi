##############################################################################
##
#W  simplicial_surface.gi          Simplicial               Alice Niemeyer
#W                                                        Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Alice Niemeyer, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##
##  The functions in this file compute with simplicial surfaces.
##
##



#############################################################################
##
##
#!  @Description
#!  This function computes the Euler characteristic of a simplicial surface.
#!  The Euler characteristic is |V| - |E| + |F|, where |V| is the number of
#!  vertices, |E| is the number of edges and |F| is the number of faces.
#!  @Returns an integer, which is the Euler characteristic.
#!  @Arguments <simpsurf>, a simplicial surface object as created 
#!  by WildSimplicialSurface
#!
InstallGlobalFunction( EulerCharacteristic, function (simpsurf)

    local chi;

    if not IsSimplicialSurface(simpsurf) then
        Error("usage: EulerCharacteristic(simpsurf");
        return fail;
    fi;

    if IsBound(simpsurf!.EulerCharacteristic) then
        return simpsurf!.EulerCharacteristic;
    fi;

    chi :=    NrOfVertices(simpsurf)  # V
            - NrOfEdges(simpsurf)     # -E
            + NrOfFaces(simpsurf);    # +F


     simpsurf!.EulerCharacteristic := chi;

     return chi;

end);

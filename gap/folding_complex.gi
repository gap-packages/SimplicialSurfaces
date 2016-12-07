##############################################################################
##
#W  folding_complex.gi          Simplicial         Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##
##  The functions in this file compute with folding complexes.
##

DeclareRepresentation("FoldingComplexRep", IsSimplicialSurface,
     []); #TODO

# From now on, we can do "Objectify( WildSimplicialSurfaceType, re )" 
# for any list re
FoldingComplexType := 
    NewType( FoldingComplexFamily, IsFoldingComplex );

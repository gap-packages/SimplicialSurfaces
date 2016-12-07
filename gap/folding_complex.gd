##############################################################################
##
#W  folding_complex.gd          Simplicial             Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the declaration part for the folding complexes
##	of the Simplicial package.
##

FoldingComplexFamily := 
    NewFamily("FoldingComplexFamily",  IsObject, IsComponentObjectRep);

DeclareCategory( "IsFoldingComplex", IsComponentObjectRep );



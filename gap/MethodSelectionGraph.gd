#############################################################################
##
##                                                      MethodSelectionGraph
##
##  Copyright 2017,                            Markus Baumeister, RWTH Aachen
##                                       Sebastian Gutsche, Siegen University
##
#############################################################################

DeclareGlobalFunction( "evaluate_recusive" );

DeclareCategory( "IsMethodSelectionGraph", IsObject );

DeclareOperation( "MethodSelectionGraph", [ IsList ] );

DeclareOperation( "AddPropertyIncidence", [ IsMethodSelectionGraph, IsString, IsList ] );

DeclareOperation( "ComputeProperty", [ IsMethodSelectionGraph, IsFunction, IsObject ] );

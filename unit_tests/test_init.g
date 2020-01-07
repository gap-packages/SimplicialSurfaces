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

# This is the document that manages all other tests

DeclareGlobalVariable("__SIMPLICIAL_TestFailure");
MakeReadWriteGlobal("__SIMPLICIAL_TestFailure");
BindGlobal( "SIMPLICIAL_TestAssert", function(bool)
    if not bool then
        # Print the current location
        PrintTo("*errout*", "caller: ");
        PRINT_CURRENT_STATEMENT("*errout*", ParentLVars(GetCurrentLVars())); 
        PrintTo("*errout*", "\n");
        __SIMPLICIAL_TestFailure := true;
    fi;
end);



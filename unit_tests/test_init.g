

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



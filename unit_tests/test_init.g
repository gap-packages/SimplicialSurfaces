

# This is the document that manages all other tests

DeclareGlobalVariable("__SIMPLICIAL_TestFailure");
MakeReadWriteGlobal("__SIMPLICIAL_TestFailure");
BindGlobal( "SIMPLICIAL_TestAssert", function(bool)
    local loc;
    if not bool then
        # Print the location of the caller
        loc := CURRENT_STATEMENT_LOCATION(ParentLVars(GetCurrentLVars()));
        if loc = fail then
            PrintTo("*errout*", "SIMPLICIAL_TestAssert failed\n");
        else
            PrintTo("*errout*", "SIMPLICIAL_TestAssert failed at ",
                loc[1], ":", loc[2], "\n");
        fi;
        __SIMPLICIAL_TestFailure := true;
    fi;
end);



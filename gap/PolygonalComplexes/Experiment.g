exp := function( name )
    local filters;

    filters := List( [1,2], i -> ValueGlobal("IsList") );
    DeclareOperation( name, filters );
    InstallMethod(ValueGlobal(name), Concatenation("for ", name), filters, 
        function(arg)
            return Union( arg[1], arg[2] );
        end);
end;

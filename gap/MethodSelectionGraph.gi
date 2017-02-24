#############################################################################
##
##                                                      MethodSelectionGraph
##
##  Copyright 2017,                            Markus Baumeister, RWTH Aachen
##                                       Sebastian Gutsche, Siegen University
##
#############################################################################

DeclareRepresentation( "IsMethodSelectionGraphRep",
        IsMethodSelectionGraph and IsAttributeStoringRep,
        [ ] );

BindGlobal( "TheFamilyOfMethodSelectionGraphs",
        NewFamily( "TheFamilyOfMethodSelectionGraphs" ) );

BindGlobal( "TheTypeMethodSelectionGraph",
        NewType( TheFamilyOfMethodSelectionGraphs,
                IsMethodSelectionGraphRep ) );
                
##
InstallMethod( MethodSelectionGraph,
               [ IsList ],
               
  function( methods )
    local graph, i;
    
    graph := rec( );
    
    for i in methods do
        graph.(i) := [ ];
    od;
    
    Objectify( TheTypeMethodSelectionGraph, graph );
    
    return graph;
    
end );

InstallMethod( AddPropertyIncidence,
               [ IsMethodSelectionGraph, IsString, IsList ],
               
  function( graph, property_to_compute, property_depends_on )
    
    if IsString( property_depends_on ) then
        property_depends_on := [ property_depends_on ];
    fi;
    
    Add( graph!.(property_to_compute), property_depends_on );
    
end );

InstallGlobalFunction( "evaluate_recursive",
                       function( graph, name_property, object, spanning_tree )
    local i, props;
    
    if spanning_tree.( name_property ) = 0 then
        return ValueGlobal( name_property )( object );
    fi;
    
    props := graph!.( name_property )[ spanning_tree.( name_property ) ];
    
    for i in props do
        evaluate_recursive( graph, i, object, spanning_tree );
    od;
    
    return ValueGlobal( name_property )( object );
    
end );

InstallMethod( ComputeProperty,
               [ IsMethodSelectionGraph, IsFunction, IsObject ],
  function( graph, property, object )
    local all_names, how_to_compute, i, property_name, possibilities, max, j;
    
    all_names := NamesOfComponents( graph );
    
    how_to_compute := rec();
    
    for i in all_names do
        how_to_compute.( i ) := -1;
    od;
    
    for i in [ 1 .. Length( all_names ) ] do
        if Tester( ValueGlobal( all_names[ i ] ) )( object ) then
            how_to_compute.( all_names[ i ] ) := 0;
        fi;
    od;
    
    property_name := NameFunction( property );
    
    if how_to_compute.( property_name ) > -1 then
        return property( object );
    fi;
    
    for max in [ 1 .. Length( all_names ) ] do
        
        for i in [ 1 .. Length( all_names ) ] do
            
            if how_to_compute.( all_names[ i ] ) > -1 then
                continue;
            fi;
            
            possibilities := graph!.( all_names[ i ] );
            
            for j in [ 1 .. Length( possibilities ) ] do
                
                if ForAll( possibilities[ j ], k -> how_to_compute.( k ) > -1 ) then
                    
                    how_to_compute.( all_names[ i ] ) := j;
                    break;
                
                fi;
                
            od;
            
        od;
        
        if how_to_compute.( property_name ) > -1 then
            break;
        fi;
        
    od;
    
    if how_to_compute.( property_name ) = -1 then
        
        Error( "cannot compute property" );
        
    fi;
    
    return evaluate_recursive( graph, property_name, object, how_to_compute );
    
end );



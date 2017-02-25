DeclareAttribute( "A", IsAttributeStoringRep );
DeclareAttribute( "B", IsAttributeStoringRep );
DeclareAttribute( "C", IsAttributeStoringRep );
DeclareAttribute( "D", IsAttributeStoringRep );

InstallMethod( A, [ HasB ], i -> B( i )*2 );
InstallMethod( B, [ HasA ], i -> A( i )*3 );

InstallMethod( B, [ HasC ], i -> C( i )*5 );
InstallMethod( C, [ HasB ], i -> C( i )*7 );

InstallMethod( C, [ HasD ], i -> D( i )*11 );
InstallMethod( D, [ HasC ], i -> C( i )*13 );

InstallMethod( A, [ HasD ], i -> D( i )*17 );
InstallMethod( D, [ HasA ], i -> A( i )*19 );

#graph := MethodSelectionGraph( [ "A", "B", "C", "D" ] );
graph := MethodSelectionGraph( [] );

AddPropertyIncidence( graph, "A", "B" );
AddPropertyIncidence( graph, "A", "D" );

AddPropertyIncidence( graph, "B", "A" );
AddPropertyIncidence( graph, "B", "C" );

AddPropertyIncidence( graph, "C", "B" );
AddPropertyIncidence( graph, "C", "D" );

AddPropertyIncidence( graph, "D", "C" );
AddPropertyIncidence( graph, "D", "A" );

S := SymmetricGroup( 3 );
SetC( S, 1 );

InstallMethod( A, [IsAttributeStoringRep], i -> ComputeProperty(graph,A,i) );

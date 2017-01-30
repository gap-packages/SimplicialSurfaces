DeclareOperation( "TestFunction", [IsSet, IsSet] );

InstallMethod( TestFunction, "for testing", [IsSet, IsSet],
	function( a, b )
		return Difference(a,b);
	end
);

RedispatchOnCondition( TestFunction, true, [IsList,IsList], [IsSet,IsSet], 0);


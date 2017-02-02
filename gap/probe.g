DeclareCategory( "IsTestObject", IsComponentObjectRep and IsAttributeStoringRep );

TestObjectFamily := NewFamily("TestObjectFamily",  IsObject, IsTestObject);

DeclareRepresentation("IsTestObjectRep", IsTestObject, []);

TestObjectType := NewType( TestObjectFamily, IsTestObjectRep );



DeclareOperation( "TestObject", []);
InstallMethod( TestObject, "", [],
	function()
		return Objectify( TestObjectType, rec() );
	end
);


KeyDependentOperation( "TestKey", IsTestObject, IsPosInt, function(x) return true; end);
InstallMethod( TestKeyOp, "", [IsTestObject,IsPosInt],
	function( test, pos )
		return pos;
		#return EquivalenceRelationByPairs( Domain( [pos] ), [] );
	end
);


##
##	Test the consistency of a simplicial surface fan
##	
TestFanConsistency := function( fan, messageFanOrigin )
	local testFan, inv;


	if not IsSimplicialSurfaceFan(fan) then
		Print( messageFanOrigin );
		Print( " is not a simplicial surface fan.\n" );
	fi;

	# Test the begin
	if BeginOfFan(fan) <> BeginOfFanAttributeOfSimplicialSurfaceFan(fan) then
		Print( messageFanOrigin );
		Print( " has inconsistent begin.\n");
	fi;
	
	# Test the begin
	if EndOfFan(fan) <> EndOfFanAttributeOfSimplicialSurfaceFan(fan) then
		Print( messageFanOrigin );
		Print( " has inconsistent end.\n");
	fi;

	# Test the permutation
	if PermutationOfFan(fan) <> PermutationOfFanAttributeOfSimplicialSurfaceFan(fan) then
		Print( messageFanOrigin );
		Print( " has inconsistent permutation.\n");
	fi;

	# Test the corona
	if CoronaOfFan(fan) <> CoronaOfFanAttributeOfSimplicialSurfaceFan(fan) then
		Print( messageFanOrigin );
		Print( " has inconsistent corona.\n");
	fi;


	# Test detailed constructor
	testFan := SimplicialSurfaceFan( BeginOfFan(fan), EndOfFan(fan),
		PermutationOfFan(fan) : Corona:=CoronaOfFan(fan) );
	if fan <> testFan then
		Print( messageFanOrigin );
		Print( " is not equal to a fan with the same attributes.\n" );
	fi;


	# Test the inverse
	if InverseOfFan(fan) <> InverseOfFanAttributeOfSimplicialSurfaceFan(fan) then
		Print( messageFanOrigin );
		Print( " has inconsistent inverse.\n");
	fi;
	inv := InverseOfFan(fan);
	if BeginOfFan(inv) <> EndOfFan(fan) then
		Print( messageFanOrigin );
		Print( ": Begin of inverse is not end of original.\n" );
	fi;
	if EndOfFan(inv) <> BeginOfFan(fan) then
		Print( messageFanOrigin );
		Print( ": End of inverse is not begin of original.\n" );
	fi;
	if CoronaOfFan(inv) <> CoronaOfFan(fan) then
		Print( messageFanOrigin );
		Print( ": Corona of inverse is not corona of original.\n" );
	fi;
	if PermutationOfFan(inv)^(-1) <> PermutationOfFan(fan) then
		Print( messageFanOrigin );
		Print( ": Permutation of inverse is not inverse permutation of original.\n" );
	fi;


	# Test the reduced fan for all subsets of the corona
	
end;

##
##	Test the consistency of a simplicial surface fan
##	
TestFanConsistency := function( fan, messageFanOrigin )
	local testFan, inv, subsets, red, sub;


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
	if PermutationOfFan(fan) <> () then
		if MovedPoints( PermutationOfFan(fan) ) <> CoronaOfFan(fan) then
			Print( messageFanOrigin );
			Print( " has a corona that is inconsistent with the permutation.\n");
		fi;
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
	if not IsSimplicialSurfaceFan(inv) then
		Print( messageFanOrigin );
		Print( ": The inverse is not a fan.\n" );
	fi;
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
	subsets := Combinations( CoronaOfFan( fan ) );
	for sub in subsets do
		red := ReducedFan( fan, sub );
		if not IsSimplicialSurfaceFan(red) then
			Print( messageFanOrigin );
			Print( ": The reduct to " );
			Print( sub );
			Print( " is not a fan.\n" );
		fi;
		if BeginOfFan(red) <> BeginOfFan(fan) then
			Print( messageFanOrigin );
			Print( ": The reduct to " );
			Print( sub );
			Print( " has a different begin than the original fan.\n" );
		fi;
		if EndOfFan(red) <> EndOfFan(fan) then
			Print( messageFanOrigin );
			Print( ": The reduct to " );
			Print( sub );
			Print( " has a different end than the original fan.\n" );
		fi;
		if CoronaOfFan(red) <> sub then
			Print( messageFanOrigin );
			Print( ": The reduct to " );
			Print( sub );
			Print( " has a different corona than " );
			Print( sub );
			Print( ".\n" );
		fi;	
	od;
end;


##
##	Test attributes of simplicial surface fans
##	beginOfFan		BeginOfFan
##	endOfFan			EndOfFan
##	permutation		PermutationOfFan
##	corona		CoronaOfFan
##
TestFanAttributes := function(fan, messageFanOrigin, beginOfFan, endOfFan,
	permutation, corona)

	TestFanConsistency( surface, messageFanOrigin );

	if BeginOfFan(fan) <> beginOfFan then
		Print( messageFanOrigin );
		Print( " does not have Begin " );
		Print( beginOfFan );
		Print( ".\n" );
	fi;

	if EndOfFan(fan) <> endOfFan then
		Print( messageFanOrigin );
		Print( " does not have End " );
		Print( endOfFan );
		Print( ".\n" );
	fi;

	if PermutationOfFan(fan) <> permutation then
		Print( messageFanOrigin );
		Print( " does not have permutation " );
		Print( permutation );
		Print( ".\n" );
	fi;

	if CoronaOfFan(fan) <> corona then
		Print( messageFanOrigin );
		Print( " does not have corona " );
		Print( corona );
		Print( ".\n" );
	fi;
end;

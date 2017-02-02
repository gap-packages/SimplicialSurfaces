
##
##	Test the consistency of a coloured simplicial surface.
##	
TestColouredSimplicialSurfaceConsistency := function( surface, messageSurfaceOrigin )
	local i, numbersAsSet, classesByNumbers;

	if not IsColouredSimplicialSurface( surface ) then
		Print( messageSurfaceOrigin );
		Print( " is not a coloured simplicial surface.\n");
	fi;

	# Test the underlying simplicial surface
	if UnderlyingSimplicialSurface(surface) <> UnderlyingSimplicialSurfaceAttributeOfCSS(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent underlying simplicial surface.\n");
	fi;
	if not IsSimplicialSurface( UnderlyingSimplicialSurface(surface) ) then
		Print( messageSurfaceOrigin );
		Print( ": Underlying simplicial surface is not a simplicial surface.\n");
	fi;

	# Test the quotient simplicial surface
	if QuotientSimplicialSurface(surface) <> QuotientSimplicialSurfaceAttributeOfCSS(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent quotient simplicial surface.\n");
	fi;
	if not IsSimplicialSurface( QuotientSimplicialSurface(surface) ) then
		Print( messageSurfaceOrigin );
		Print( ": Quotient simplicial surface is not a simplicial surface.\n");
	fi;

	##
	## Test the consistency of the vertices
	##
	if VertexEquivalenceNumbersAsSet(surface) <> VertexEquivalenceNumbersAsSetAttributeOfCSS(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent vertex equivalence numbers (as set).\n");
	fi;

	if VertexEquivalenceNumbersByElements(surface) <> VertexEquivalenceNumbersByElementsAttributeOfCSS(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent vertex equivalence numbers (by elements).\n");
	fi;
	
	if VertexEquivalenceClassesByNumbers(surface) <> VertexEquivalenceClassesByNumbersAttributeOfCSS(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent vertex equivalence classes (by numbers).\n");
	fi;

	if VertexEquivalenceClassesByElements(surface) <> VertexEquivalenceClassesByElementsAttributeOfCSS(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent vertex equivalence classes (by elements).\n");
	fi;

	# Compare NumbersAsSet and NumbersByElements
	if VertexEquivalenceNumbersAsSet(surface) <> Set( VertexEquivalenceNumbersByElements(surface) ) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent vertex equivalence numbers (in comparing AsSet with ByElements).\n");
	fi;

	# Compare ClassesByNumbers and ClassesByElements
	if Set( VertexEquivalenceClassesByNumbers(surface) ) <> Set( VertexEquivalenceClassesByElements(surface) ) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent vertex equivalence classes (in comparing ByNumbers with ByElements).\n");
	fi;

	# Check ClassesByElements internally
	for i in Vertices( UnderlyingSimplicialSurface( surface ) ) do
		if not i in VertexEquivalenceClassesByElements(surface)[i] then
			Print( messageSurfaceOrigin );
			Print( " has an inconsistent vertex equivalence class for the vertex" );
			Print( i );
			Print( ".\n");
		fi;
	od;

	# Compare NumbersAsSet and ClassesByNumbers
	numbersAsSet := VertexEquivalenceNumbersAsSet(surface);
	classesByNumbers := VertexEquivalenceClassesByNumbers(surface);
	for i in [1..Length(classesByNumbers)] do
		if i in numbersAsSet and not IsBound( classesByNumbers[i] ) then
			Print( messageSurfaceOrigin );
			Print( ": the vertex equivalence number " );
			Print( i );
			Print( " has no associated equivalence class.\n" );
		elif not i in numbersAsSet and IsBound( classesByNumbers[i] ) then
			Print( messageSurfaceOrigin );
			Print( ": " );
			Print( i );
			Print( " is no vertex equivalence number but has an associated equivalence class.\n" );
		fi;
	od;

	# Check if the class separation works
	if Vertices( UnderlyingSimplicialSurface( surface ) ) <> Union( Set( VertexEquivalenceClassesByNumbers(surface) ) ) then
		Print( messageSurfaceOrigin );
		Print( ": vertex equivalence classes (by numbers) don't partition the vertex set.\n");
	fi;
	if Vertices( UnderlyingSimplicialSurface( surface ) ) <> Union( Set( VertexEquivalenceClassesByElements(surface) ) ) then
		Print( messageSurfaceOrigin );
		Print( ": vertex equivalence classes (by elements) don't partition the vertex set.\n");
	fi;

end;

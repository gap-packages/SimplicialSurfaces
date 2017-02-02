
##
##	Test the consistency of a coloured simplicial surface.
##	
TestColouredSimplicialSurfaceConsistency := function( surface, messageSurfaceOrigin )
	local ;

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

end;




##
##	Test the consistency of a coloured simplicial surface.
##	
TestColouredSimplicialSurfaceConsistency := function( surface, messageSurfaceOrigin )
	local i, numbersAsSet, classesByNumbers, el;

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
			Print( " has an inconsistent vertex equivalence class for the vertex " );
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

	##
	## Test the consistency of the edges
	##
	if EdgeEquivalenceNumbersAsSet(surface) <> EdgeEquivalenceNumbersAsSetAttributeOfCSS(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent edge equivalence numbers (as set).\n");
	fi;

	if EdgeEquivalenceNumbersByElements(surface) <> EdgeEquivalenceNumbersByElementsAttributeOfCSS(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent edge equivalence numbers (by elements).\n");
	fi;
	
	if EdgeEquivalenceClassesByNumbers(surface) <> EdgeEquivalenceClassesByNumbersAttributeOfCSS(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent edge equivalence classes (by numbers).\n");
	fi;

	if EdgeEquivalenceClassesByElements(surface) <> EdgeEquivalenceClassesByElementsAttributeOfCSS(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent edge equivalence classes (by elements).\n");
	fi;

	# Compare NumbersAsSet and NumbersByElements
	if EdgeEquivalenceNumbersAsSet(surface) <> Set( EdgeEquivalenceNumbersByElements(surface) ) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent edge equivalence numbers (in comparing AsSet with ByElements).\n");
	fi;

	# Compare ClassesByNumbers and ClassesByElements
	if Set( EdgeEquivalenceClassesByNumbers(surface) ) <> Set( EdgeEquivalenceClassesByElements(surface) ) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent edge equivalence classes (in comparing ByNumbers with ByElements).\n");
	fi;

	# Check ClassesByElements internally
	for i in Edges( UnderlyingSimplicialSurface( surface ) ) do
		if not i in EdgeEquivalenceClassesByElements(surface)[i] then
			Print( messageSurfaceOrigin );
			Print( " has an inconsistent edge equivalence class for the edge " );
			Print( i );
			Print( ".\n");
		fi;
	od;

	# Compare NumbersAsSet and ClassesByNumbers
	numbersAsSet := EdgeEquivalenceNumbersAsSet(surface);
	classesByNumbers := EdgeEquivalenceClassesByNumbers(surface);
	for i in [1..Length(classesByNumbers)] do
		if i in numbersAsSet and not IsBound( classesByNumbers[i] ) then
			Print( messageSurfaceOrigin );
			Print( ": the edge equivalence number " );
			Print( i );
			Print( " has no associated equivalence class.\n" );
		elif not i in numbersAsSet and IsBound( classesByNumbers[i] ) then
			Print( messageSurfaceOrigin );
			Print( ": " );
			Print( i );
			Print( " is no edge equivalence number but has an associated equivalence class.\n" );
		fi;
	od;

	# Check if the class separation works
	if Edges( UnderlyingSimplicialSurface( surface ) ) <> Union( Set( EdgeEquivalenceClassesByNumbers(surface) ) ) then
		Print( messageSurfaceOrigin );
		Print( ": edge equivalence classes (by numbers) don't partition the edge set.\n");
	fi;
	if Edges( UnderlyingSimplicialSurface( surface ) ) <> Union( Set( EdgeEquivalenceClassesByElements(surface) ) ) then
		Print( messageSurfaceOrigin );
		Print( ": edge equivalence classes (by elements) don't partition the edge set.\n");
	fi;


	##
	## Test the consistency of the faces
	##
	if FaceEquivalenceNumbersAsSet(surface) <> FaceEquivalenceNumbersAsSetAttributeOfCSS(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent face equivalence numbers (as set).\n");
	fi;

	if FaceEquivalenceNumbersByElements(surface) <> FaceEquivalenceNumbersByElementsAttributeOfCSS(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent face equivalence numbers (by elements).\n");
	fi;
	
	if FaceEquivalenceClassesByNumbers(surface) <> FaceEquivalenceClassesByNumbersAttributeOfCSS(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent face equivalence classes (by numbers).\n");
	fi;

	if FaceEquivalenceClassesByElements(surface) <> FaceEquivalenceClassesByElementsAttributeOfCSS(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent face equivalence classes (by elements).\n");
	fi;

	# Compare NumbersAsSet and NumbersByElements
	if FaceEquivalenceNumbersAsSet(surface) <> Set( FaceEquivalenceNumbersByElements(surface) ) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent face equivalence numbers (in comparing AsSet with ByElements).\n");
	fi;

	# Compare ClassesByNumbers and ClassesByElements
	if Set( FaceEquivalenceClassesByNumbers(surface) ) <> Set( FaceEquivalenceClassesByElements(surface) ) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent face equivalence classes (in comparing ByNumbers with ByElements).\n");
	fi;

	# Check ClassesByElements internally
	for i in Faces( UnderlyingSimplicialSurface( surface ) ) do
		if not i in FaceEquivalenceClassesByElements(surface)[i] then
			Print( messageSurfaceOrigin );
			Print( " has an inconsistent face equivalence class for the face " );
			Print( i );
			Print( ".\n");
		fi;
	od;

	# Compare NumbersAsSet and ClassesByNumbers
	numbersAsSet := FaceEquivalenceNumbersAsSet(surface);
	classesByNumbers := FaceEquivalenceClassesByNumbers(surface);
	for i in [1..Length(classesByNumbers)] do
		if i in numbersAsSet and not IsBound( classesByNumbers[i] ) then
			Print( messageSurfaceOrigin );
			Print( ": the face equivalence number " );
			Print( i );
			Print( " has no associated equivalence class.\n" );
		elif not i in numbersAsSet and IsBound( classesByNumbers[i] ) then
			Print( messageSurfaceOrigin );
			Print( ": " );
			Print( i );
			Print( " is no face equivalence number but has an associated equivalence class.\n" );
		fi;
	od;

	# Check if the class separation works
	if Faces( UnderlyingSimplicialSurface( surface ) ) <> Union( Set( FaceEquivalenceClassesByNumbers(surface) ) ) then
		Print( messageSurfaceOrigin );
		Print( ": face equivalence classes (by numbers) don't partition the face set.\n");
	fi;
	if Faces( UnderlyingSimplicialSurface( surface ) ) <> Union( Set( FaceEquivalenceClassesByElements(surface) ) ) then
		Print( messageSurfaceOrigin );
		Print( ": face equivalence classes (by elements) don't partition the face set.\n");
	fi;




	# Check vertex binding relation
	for i in VertexEquivalenceNumbersAsSet(surface) do
		if VertexBindingRelation(surface,i) <> VertexBindingRelationAttributeOfCSS(surface,i) then
			Print( messageSurfaceOrigin );
			Print( " has inconsistent vertex binding relation at vertex equivalence number ");
			Print( i );
			Print(".\n");
		fi;
		if VertexEquivalenceClassesByNumbers(surface)[i] <> Union( Set( List( VertexBindingRelation(surface,i ), l -> Set(l) ) ) ) then
			Print( messageSurfaceOrigin );
			Print( ": vertex equivalence relation of number ");
			Print( i );
			Print( " does not partition the vertex equivalence class.\n");
		fi;
	od;

	# Check edge binding relation
	for i in EdgeEquivalenceNumbersAsSet(surface) do
		if EdgeBindingRelation(surface,i) <> EdgeBindingRelationAttributeOfCSS(surface,i) then
			Print( messageSurfaceOrigin );
			Print( " has inconsistent edge binding relation at edge equivalence number ");
			Print( i );
			Print(".\n");
		fi;
		if EdgeEquivalenceClassesByNumbers(surface)[i] <> Union( Set( List( EdgeBindingRelation(surface,i ), l -> Set(l) ) ) ) then
			Print( messageSurfaceOrigin );
			Print( ": edge equivalence relation of number ");
			Print( i );
			Print( " does not partition the edge equivalence class.\n");
		fi;
	od;

	# Check local orientation
	if LocalOrientationWRTVertexEquivalenceClasses(surface) <> LocalOrientationWRTVertexEquivalenceClassesAttributeOfCSS(surface) then
		Print( messageSurfaceOrigin );
		Print( " has inconsistent local orientation.\n");
	fi;
	#TODO check whether the elements in the cycles match

	
	#TODO test equivalence methods


	##
	##	Convenience methods
	##
	
	# Check VertexEquivalenceNumberOfElement
	for el in Vertices( UnderlyingSimplicialSurface( surface ) ) do
		if VertexEquivalenceNumberOfElement(surface,el) <> VertexEquivalenceNumberOfElementNC(surface,el) then
			Print( messageSurfaceOrigin );
			Print( " has different vertex equivalence number results for NC.\n");
		fi;
		if VertexEquivalenceNumberOfElement(surface,el) <> VertexEquivalenceNumbersByElements(surface)[el] then
			Print( messageSurfaceOrigin );
			Print( " has inconsistent convenience method to determine vertex equivalence numbers.\n");
		fi;
	od;

	# Check EdgeEquivalenceNumberOfElement
	for el in Edges( UnderlyingSimplicialSurface( surface ) ) do
		if EdgeEquivalenceNumberOfElement(surface,el) <> EdgeEquivalenceNumberOfElementNC(surface,el) then
			Print( messageSurfaceOrigin );
			Print( " has different edge equivalence number results for NC.\n");
		fi;
		if EdgeEquivalenceNumberOfElement(surface,el) <> EdgeEquivalenceNumbersByElements(surface)[el] then
			Print( messageSurfaceOrigin );
			Print( " has inconsistent convenience method to determine edge equivalence numbers.\n");
		fi;
	od;

	# Check FaceEquivalenceNumberOfElement
	for el in Faces( UnderlyingSimplicialSurface( surface ) ) do
		if FaceEquivalenceNumberOfElement(surface,el) <> FaceEquivalenceNumberOfElementNC(surface,el) then
			Print( messageSurfaceOrigin );
			Print( " has different face equivalence number results for NC.\n");
		fi;
		if FaceEquivalenceNumberOfElement(surface,el) <> FaceEquivalenceNumbersByElements(surface)[el] then
			Print( messageSurfaceOrigin );
			Print( " has inconsistent convenience method to determine face equivalence numbers.\n");
		fi;
	od;



	# Check VertexEquivalenceClassOfElement
	for el in Vertices( UnderlyingSimplicialSurface( surface ) ) do
		if VertexEquivalenceClassOfElement(surface,el) <> VertexEquivalenceClassOfElementNC(surface,el) then
			Print( messageSurfaceOrigin );
			Print( " has different vertex equivalence class (by element) results for NC.\n");
		fi;
		if VertexEquivalenceClassOfElement(surface,el) <> VertexEquivalenceClassesByElements(surface)[el] then
			Print( messageSurfaceOrigin );
			Print( " has inconsistent convenience method to determine vertex equivalence classes (by element).\n");
		fi;
	od;

	# Check EdgeEquivalenceClassOfElement
	for el in Edges( UnderlyingSimplicialSurface( surface ) ) do
		if EdgeEquivalenceClassOfElement(surface,el) <> EdgeEquivalenceClassOfElementNC(surface,el) then
			Print( messageSurfaceOrigin );
			Print( " has different edge equivalence class (by element) results for NC.\n");
		fi;
		if EdgeEquivalenceClassOfElement(surface,el) <> EdgeEquivalenceClassesByElements(surface)[el] then
			Print( messageSurfaceOrigin );
			Print( " has inconsistent convenience method to determine edge equivalence classes (by element).\n");
		fi;
	od;

	# Check FaceEquivalenceClassOfElement
	for el in Faces( UnderlyingSimplicialSurface( surface ) ) do
		if FaceEquivalenceClassOfElement(surface,el) <> FaceEquivalenceClassOfElementNC(surface,el) then
			Print( messageSurfaceOrigin );
			Print( " has different face equivalence class (by element) results for NC.\n");
		fi;
		if FaceEquivalenceClassOfElement(surface,el) <> FaceEquivalenceClassesByElements(surface)[el] then
			Print( messageSurfaceOrigin );
			Print( " has inconsistent convenience method to determine face equivalence classes (by element).\n");
		fi;
	od;



	# Check VertexEquivalenceClassByNumber
	for el in Vertices( UnderlyingSimplicialSurface( surface ) ) do
		if VertexEquivalenceClassByNumber(surface,el) <> VertexEquivalenceClassByNumberNC(surface,el) then
			Print( messageSurfaceOrigin );
			Print( " has different vertex equivalence class (by number) results for NC.\n");
		fi;
		if VertexEquivalenceClassByNumber(surface,el) <> VertexEquivalenceClassesByNumbers(surface)[el] then
			Print( messageSurfaceOrigin );
			Print( " has inconsistent convenience method to determine vertex equivalence classes (by number).\n");
		fi;
	od;

	# Check EdgeEquivalenceClassByNumber
	for el in Edges( UnderlyingSimplicialSurface( surface ) ) do
		if EdgeEquivalenceClassByNumber(surface,el) <> EdgeEquivalenceClassByNumberNC(surface,el) then
			Print( messageSurfaceOrigin );
			Print( " has different edge equivalence class (by number) results for NC.\n");
		fi;
		if EdgeEquivalenceClassByNumber(surface,el) <> EdgeEquivalenceClassesByNumbers(surface)[el] then
			Print( messageSurfaceOrigin );
			Print( " has inconsistent convenience method to determine edge equivalence classes (by number).\n");
		fi;
	od;

	# Check FaceEquivalenceClassByNumber
	for el in Faces( UnderlyingSimplicialSurface( surface ) ) do
		if FaceEquivalenceClassByNumber(surface,el) <> FaceEquivalenceClassByNumberNC(surface,el) then
			Print( messageSurfaceOrigin );
			Print( " has different face equivalence class (by number) results for NC.\n");
		fi;
		if FaceEquivalenceClassByNumber(surface,el) <> FaceEquivalenceClassesByNumbers(surface)[el] then
			Print( messageSurfaceOrigin );
			Print( " has inconsistent convenience method to determine face equivalence classes (by number).\n");
		fi;
	od;

end;

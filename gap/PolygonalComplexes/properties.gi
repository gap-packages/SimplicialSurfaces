#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2016
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################


#######################################
##
##      Invariants
##
InstallMethod( EulerCharacteristic, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return NrOfVertices(complex) - NrOfEdges(complex) + NrOfFaces(complex);
    end
);

InstallMethod( IsClosedSurface, "for a ramified polygonal surface",
    [IsRamifiedPolygonalSurface],
    function( ramSurf )
        return ForAll( List( FacesOfEdges(ramSurf), Size ), i -> i=2 );
    end
);
InstallOtherMethod( IsClosedSurface, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        if not IsRamifiedPolygonalSurface(complex) then
            Error("IsClosed: Given polygonal complex is not a ramified polygonal surface.");
        fi;
        return IsClosed(complex); # Call the function above
    end
);

##
##      End of invariants
##
#######################################


#######################################
##
##      Degree-based properties
##

InstallMethod( EdgeDegreesOfVertices, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return List( EdgesOfVertices(complex), Size );
    end
);
InstallMethod( EdgeDegreeOfVertexNC, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function( complex, vertex )
        return EdgeDegreesOfVertices(complex)[vertex];
    end
);
InstallMethod( EdgeDegreeOfVertex, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function( complex, vertex )
        __SIMPLICIAL_CheckVertex(complex, vertex, "EdgeDegreeOfVertex");
        return EdgeDegreeOfVertexNC(complex, vertex);
    end
);


InstallMethod( FaceDegreesOfVertices, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return List( FacesOfVertices(complex), Size );
    end
);
InstallMethod( FaceDegreeOfVertexNC, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function( complex, vertex )
        return FaceDegreesOfVertices(complex)[vertex];
    end
);
InstallMethod( FaceDegreeOfVertex, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function( complex, vertex )
        __SIMPLICIAL_CheckVertex(complex, vertex, "FaceDegreeOfVertex");
        return FaceDegreeOfVertexNC(complex, vertex);
    end
);


InstallMethod( VertexCounter, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local edgeDegrees, maxDeg, sym, d, pos;

        edgeDegrees := List( EdgesOfVertices(complex), Size );
        maxDeg := Maximum(edgeDegrees);
        sym := [];
        for d in [1..maxDeg] do
            pos := Size( Positions(edgeDegrees, d) );
            if pos <> 0 then
                sym[d] := pos;
            fi;
        od;

        return sym;
    end
);
InstallMethod( VertexCounter, "for a polygonal complex with computed EdgeCounter",
    [IsPolygonalComplex and HasEdgeCounter],
    function(complex)
        local symbol, i, j, edgeCounter, sum;

        symbol := [];
        edgeCounter := EdgeCounter(complex);
        for i in [1..Size(edgeCounter)] do
            sum := edgeCounter[i][i];   # This is counted twice
            for j in [1..Size(edgeCounter)] do
                sum := sum + edgeCounter[i][j];
            od;
            sum := sum/i;
            if sum <> 0 then
                symbol[i] := sum;
            fi;
        od;

        return symbol;
    end
);

InstallMethod( EdgeCounter, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local edgeDegrees, max, edge, symbol, degs;

        edgeDegrees := List( EdgesOfVertices(complex), Size );
        if NrOfEdges(complex) = 0 then
            return [];
        fi;
        max := Maximum( edgeDegrees ); # bigger than zero since edges exist

        # Set up the matrix
        symbol := List( [1..max], i -> List( [1..max], j -> 0 ) );
        for edge in Edges(complex) do
            degs := List( VerticesOfEdges(complex)[edge], v -> edgeDegrees[v] );
            symbol[ degs[1] ][ degs[2] ] := symbol[degs[1]][degs[2]] + 1;
            if degs[1] <> degs[2] then
                symbol[ degs[2] ][ degs[1] ] := symbol[degs[2]][degs[1]] + 1;
            fi;
        od;

        return symbol;
    end
);

##
##      End of degrees
##
#######################################


#######################################
##
##      Connectivity
##

InstallMethod( ConnectedComponentsOfComplex, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return ConnectedComponentsAttributeOfPolygonalComplex(complex);
    end
);
InstallMethod( StronglyConnectedComponents, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return StronglyConnectedComponentsAttributeOfPolygonalComplex(complex);
    end
);

##
## There is some interesting symmetry between connectivity and strong 
## connectivity: Connectivity means "connected in the incidence graph
## of VerticesOfFaces" while strong connectivity means "connected in
## the incidence graph of EdgesOfFaces".
## Therefore we give a general method that can compute both of these
## components.
BindGlobal( "__SIMPLICIAL_AbstractConnectedComponent", 
    function( elements, compOfElements, start )
        local change, component, internals, el;

        # The component contains start
        component := [ start ];
        # Modify the elements to remove everything that is added already
        elements := Difference( elements, component );
        # Save a set of internal components (by which the elements are connected)
        internals := compOfElements[start];

        change := true;
        while change do
            change := false;

            for el in elements do
                if Intersection( internals, compOfElements[el] ) <> [] then
                    change := true;
                    internals := Union( internals, compOfElements[el] );
                    elements := Difference( elements, [el] );
                    component := Union( component, [el] );
                fi;
            od;
        od;

        return component;
    end
);


##
## general connectivity
##
InstallMethod( IsConnected, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
	local component;

        if NrOfFaces(complex) = 0 then
            return true;
        fi;

        component := __SIMPLICIAL_AbstractConnectedComponent( 
                        Faces(complex), VerticesOfFaces(complex), 
                        Faces(complex)[1] );
        return Size( component ) = NrOfFaces(complex);
    end
);
InstallImmediateMethod( IsConnected, 
    IsPolygonalComplex and HasConnectedComponentsAttributeOfPolygonalComplex,0, 
    function(complex)
	local components;

	components := ConnectedComponentsAttributeOfPolygonalComplex(complex);
	return Length(components) <= 1;
    end
);

InstallMethod( IsStronglyConnected, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
	local component;

        if NrOfFaces(complex) = 0 then
            return true;
        fi;

        component := __SIMPLICIAL_AbstractConnectedComponent( 
                        Faces(complex), EdgesOfFaces(complex), 
                        Faces(complex)[1] );
        return Size( component ) = NrOfFaces(complex);
    end
);
InstallImmediateMethod( IsStronglyConnected, 
    IsPolygonalComplex and HasStronglyConnectedComponentsAttributeOfPolygonalComplex, 0, 
    function(complex)
	local components;

	components := StronglyConnectedComponentsAttributeOfPolygonalComplex(complex);
	return Length(components) <= 1;
    end
);

InstallImmediateMethod( IsStronglyConnected, IsPolygonalComplex and 
    HasConnectedComponentsAttributeOfPolygonalComplex, 0,
    function(complex)
        local components;

        components := ConnectedComponentsAttributeOfPolygonalComplex(complex);
        if Length(components) > 1 then
            return false;
        fi;
        TryNextMethod();
    end
);

InstallImmediateMethod( IsStronglyConnected, 
    IsPolygonalComplex and HasIsConnected, 0,
    function(complex)
        if not IsConnected(complex) then
            return false;
        fi;
        TryNextMethod();
    end
);

##
## components
##
InstallMethod( ConnectedComponentOfFaceNC, "for a polygonal complex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
        local comp, subsurf;

        comp := __SIMPLICIAL_AbstractConnectedComponent(
                    Faces(complex), VerticesOfFaces(complex), face );

	subsurf := SubcomplexByFacesNC( complex, comp);
	# this component is connected by construction, so we set the property
	SetIsConnected( subsurf, true );
	return subsurf;
    end
);
InstallMethod( ConnectedComponentOfFaceNC, "for a polygonal complex",
    [IsPolygonalComplex and IsConnected, IsPosInt],
    function(complex, f)
	return complex; # A connected surface has only one connected component
    end
);
InstallMethod( ConnectedComponentOfFace, "for a polygonal complex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
	local faceList, faces, points, comp, change, faceNr, subsurf;

        __SIMPLICIAL_CheckFace(complex, face, "ConnectedComponentOfFace");

	return ConnectedComponentOfFaceNC( complex, face);
    end
);

InstallMethod( StronglyConnectedComponentOfFaceNC, "for a polygonal complex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
        local comp, subsurf;

        comp := __SIMPLICIAL_AbstractConnectedComponent(
                    Faces(complex), EdgesOfFaces(complex), face );

	subsurf := SubcomplexByFacesNC( complex, comp);
	# this component is strongly connected by construction, so we set the property
	SetIsStronglyConnected( subsurf, true );
	return subsurf;
    end
);
InstallMethod( StronglyConnectedComponentOfFaceNC, "for a polygonal complex",
    [IsPolygonalComplex and IsStronglyConnected, IsPosInt],
    function(complex, face)
	return complex; # A strongly connected surface has only one strongly connected component
    end
);
InstallMethod( StronglyConnectedComponentOfFace, "for a polygonal complex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, face)
	local faceList, faces, points, comp, change, faceNr, subsurf;

	__SIMPLICIAL_CheckFace(complex, face, "StronglyConnectedComponentOfFace");

	return StronglyConnectedComponentOfFaceNC( complex, face);
    end
);


InstallMethod( ConnectedComponentOfFaceNC, "for a polygonal complex",
    [IsPolygonalComplex and HasConnectedComponentsAttributeOfPolygonalComplex,
        IsPosInt],
    function( complex, face )
	local conCom, comp;

	conCom := ConnectedComponentsAttributeOfPolygonalComplex(complex);
	for comp in conCom do
	    if face in Faces(comp) then
		return comp;
	    fi;
	od;
	Error("ConnectedComponentOfFace: Internal error in ConnectedComponents.");
    end
);


InstallMethod( StronglyConnectedComponentOfFaceNC, "for a polygonal complex",
    [IsPolygonalComplex and HasStronglyConnectedComponentsAttributeOfPolygonalComplex, IsPosInt],
    function(complex, face)
	local conCom, comp;

	conCom := StronglyConnectedComponentsAttributeOfPolygonalComplex(complex);
	for comp in conCom do
	    if face in Faces(comp) then
		return comp;
	    fi;
	od;
	Error("StronglyConnectedComponentOfFace: Internal error in StronglyConnectedComponents.");
    end
);


InstallMethod( ConnectedComponentsAttributeOfPolygonalComplex,
    "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
	local faces, comp, f, component;

	faces := Faces(complex);
	comp := [ ];
	while not IsEmpty(faces) do
	    f := faces[1];
            component := ConnectedComponentOfFace(complex, f);
	    Append( comp, [component] );
	    faces := Difference( faces, Faces(component) );
	od;

	return comp;
    end
);
InstallImmediateMethod( ConnectedComponentsAttributeOfPolygonalComplex,
    IsPolygonalComplex and IsConnected, 0, 
    function(complex)
	return [complex];
    end
);


InstallMethod( StronglyConnectedComponentsAttributeOfPolygonalComplex,
    "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
	local faces, comp, f, component;

	faces := Faces(complex);
	comp := [ ];
	while not IsEmpty(faces) do
	    f := faces[1];
            component := StronglyConnectedComponentOfFace(complex,f);
	    Append( comp, [component] );
	    faces := Difference( faces, Faces(component) );
	od;

	return comp;
    end
);
InstallImmediateMethod( StronglyConnectedComponentsAttributeOfPolygonalComplex,
    IsPolygonalComplex and IsStronglyConnected, 0,
    function(complex)
        return [complex];
    end
);


##
## After implementing connectivity and strong connectivity for themselves, we
## also want to work with the connection between them. We start with the
## direction "strongly connected"->"connected"
InstallImmediateMethod( IsConnected, 
    IsPolygonalComplex and HasStronglyConnectedComponentsAttributeOfPolygonalComplex, 0, 
    function( complex )
        local components;

        components := StronglyConnectedComponentsAttributeOfPolygonalComplex(complex);
        if Length(components) <= 1 then
            return true;
        fi;

        # If there is more than one path-connected component, the structure
        # might still be connected.
        TryNextMethod();
    end
);

InstallMethod( ConnectedComponentsAttributeOfPolygonalComplex,
    "for a polygonal complex with strongly connected components",
    [IsPolygonalComplex and HasStronglyConnectedComponentsAttributeOfPolygonalComplex ],
    function( complex )
        local strongComponents, components, vertList, check, newComponent,
            currentVert, done, i;

        strongComponents := StronglyConnectedComponents(complex);
        components := [];
        if strongComponents = [] then
            return [];
        fi;

        vertList := List( strongComponents, Vertices );

        check := [1..Size(strongComponents)];
        while not IsEmpty(check) do
            newComponent := [ check[1] ];
            currentVert := vertList[ check[1] ];
            done := false;
            while not done do
                done := true;
                for i in Difference( check, newComponent ) do
                    if not IsEmpty( Intersection( currentVert, vertList[i] ) ) then
                        Add(newComponent, i );
                        check := Difference( check, [i] );
                        currentVert := Union( currentVert, vertList[i] );
                        done := false;
                    fi;
                od;
            od;
            Add( components, SubcomplexByFacesNC( complex, 
                Union( List( newComponent, i-> Faces( strongComponents[i] ) ) ) ) );
        od;

        return components;
    end
);

InstallMethod( StronglyConnectedComponentsAttributeOfPolygonalComplex, 
    "for a polygonal complex with connected components",
    [ IsPolygonalComplex and HasConnectedComponentsAttributeOfPolygonalComplex ],
    function( complex )
        local comp, pathComp, s;

        comp := ConnectedComponentsAttributeOfPolygonalComplex(complex);

        # If we only have one component, this method offers no benefit
        if Length(comp) = 1 then
            TryNextMethod();
        fi;

        pathComp := [];
        for s in comp do
            Append( pathComp, StronglyConnectedComponentsAttributeOfPolygonalComplex( s ) );
        od;

        return pathComp;
    end
);

## For surfaces the connected and path-connected components are
## identical. 
InstallMethod( ConnectedComponentsAttributeOfPolygonalComplex,
    "for a polygonal surface with strongly connected components",
    [IsPolygonalSurface and HasStronglyConnectedComponentsAttributeOfPolygonalComplex ],
    function(surf)
        return StronglyConnectedComponentsAttributeOfPolygonalComplex(surf);
    end
);
InstallMethod( StronglyConnectedComponentsAttributeOfPolygonalComplex, 
    "for a polygonal surface with connected components",
    [IsPolygonalSurface and 
        HasConnectedComponentsAttributeOfPolygonalComplex ],
    function(surf)
        return ConnectedComponentsAttributeOfPolygonalComplex(surf);
    end
);
InstallImmediateMethod( StronglyConnectedComponentsAttributeOfPolygonalComplex,
    IsPolygonalSurface and IsConnected, 0, 
    function(surf)
        return [surf];
    end
);


##
##      End of connectivity
##
#######################################



#######################################
##
##      Orientability
##



##
##      End of orientability
##
#######################################




#######################################
##
##      Types of edges
##

InstallMethod( InnerEdges, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local facesOfEdges;

        facesOfEdges := FacesOfEdges(complex);
        return Filtered( Edges(complex), e -> Size(facesOfEdges[e]) = 2 );
    end
);
InstallMethod( IsInnerEdgeNC, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        return edge in InnerEdges(complex);
    end
);
InstallMethod( IsInnerEdge, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "IsInnerEdge");
        return IsInnerEdgeNC(complex, edge);
    end
);


InstallMethod( BoundaryEdges, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local facesOfEdges;

        facesOfEdges := FacesOfEdges(complex);
        return Filtered( Edges(complex), e -> Size(facesOfEdges[e]) = 1 );
    end
);
InstallMethod( IsBoundaryEdgeNC, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        return edge in BoundaryEdges(complex);
    end
);
InstallMethod( IsBoundaryEdge, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "IsBoundaryEdge");
        return IsBoundaryEdgeNC(complex, edge);
    end
);


InstallMethod( RamifiedEdges, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local facesOfEdges;

        facesOfEdges := FacesOfEdges(complex);
        return Filtered( Edges(complex), e -> Size(facesOfEdges[e]) > 2 );
    end
);
InstallMethod( IsRamifiedEdgeNC, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        return edge in RamifiedEdges(complex);
    end
);
InstallMethod( IsRamifiedEdge, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "IsRamifiedEdge");
        return IsRamifiedEdgeNC(complex, edge);
    end
);


##
##      End of edge types
##
#######################################

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

InstallMethod( NumberOfConnectedComponents, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return Length(ConnectedComponentsAttributeOfPolygonalComplex(complex));
    end
);
InstallMethod( NumberOfStronglyConnectedComponents,
    "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        return Length(StronglyConnectedComponentsAttributeOfPolygonalComplex(complex));
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

        if NumberOfFaces(complex) = 0 then
            return true;
        fi;

        component := __SIMPLICIAL_AbstractConnectedComponent( 
                        Faces(complex), VerticesOfFaces(complex), 
                        Faces(complex)[1] );
        return Length( component ) = NumberOfFaces(complex);
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

        if NumberOfFaces(complex) = 0 then
            return true;
        fi;

        component := __SIMPLICIAL_AbstractConnectedComponent( 
                        Faces(complex), EdgesOfFaces(complex), 
                        Faces(complex)[1] );
        return Length( component ) = NumberOfFaces(complex);
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
	while Length(faces) > 0 do
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
	while Length(faces) > 0 do
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

        vertList := List( strongComponents, VerticesAttributeOfPolygonalComplex );

        check := [1..Length(strongComponents)];
        while Length(check) > 0 do
            newComponent := [ check[1] ];
            currentVert := vertList[ check[1] ];
            done := false;
            while not done do
                done := true;
                for i in Difference( check, newComponent ) do
                    if Length( Intersection( currentVert, vertList[i] ) ) > 0 then
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



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

InstallMethod( ConnectedComponentsOfComplex, "for a VEF-complex",
    [IsVEFComplex],
    function(complex)
        return ConnectedComponentsAttributeOfVEFComplex(complex);
    end
);
InstallMethod( StronglyConnectedComponents, "for a VEF-complex",
    [IsVEFComplex],
    function(complex)
        return StronglyConnectedComponentsAttributeOfVEFComplex(complex);
    end
);

InstallMethod( NumberOfConnectedComponents, "for a VEF-complex",
    [IsVEFComplex],
    function(complex)
        return Length(ConnectedComponentsAttributeOfVEFComplex(complex));
    end
);
InstallMethod( NumberOfStronglyConnectedComponents,
    "for a VEF-complex", [IsVEFComplex],
    function(complex)
        return Length(StronglyConnectedComponentsAttributeOfVEFComplex(complex));
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
                    Add(component, el);
                fi;
            od;
        od;

        return Set(component);
    end
);


##
## general connectivity
##
InstallMethod( IsConnected, "for a VEF-complex", [IsVEFComplex], 
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
    IsVEFComplex and HasConnectedComponentsAttributeOfVEFComplex,0, 
    function(complex)
	local components;

	components := ConnectedComponentsAttributeOfVEFComplex(complex);
	return Length(components) <= 1;
    end
);

InstallMethod( IsStronglyConnected, "for a VEF-complex", [IsVEFComplex],
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
    IsVEFComplex and HasStronglyConnectedComponentsAttributeOfVEFComplex, 0, 
    function(complex)
	local components;

	components := StronglyConnectedComponentsAttributeOfVEFComplex(complex);
	return Length(components) <= 1;
    end
);

InstallImmediateMethod( IsStronglyConnected, IsVEFComplex and 
    HasConnectedComponentsAttributeOfVEFComplex, 0,
    function(complex)
        local components;

        components := ConnectedComponentsAttributeOfVEFComplex(complex);
        if Length(components) > 1 then
            return false;
        fi;
        TryNextMethod();
    end
);

InstallImmediateMethod( IsStronglyConnected, 
    IsVEFComplex and HasIsConnected, 0,
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
InstallMethod( ConnectedComponentOfFaceNC, "for a VEF-complex",
    [IsVEFComplex, IsPosInt],
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
InstallMethod( ConnectedComponentOfFaceNC, "for a VEF-complex",
    [IsVEFComplex and IsConnected, IsPosInt],
    function(complex, f)
	return complex; # A connected surface has only one connected component
    end
);
InstallMethod( ConnectedComponentOfFace, "for a VEF-complex",
    [IsVEFComplex, IsPosInt],
    function(complex, face)
	local faceList, faces, points, comp, change, faceNr, subsurf;

        __SIMPLICIAL_CheckFace(complex, face, "ConnectedComponentOfFace");

	return ConnectedComponentOfFaceNC( complex, face);
    end
);

InstallMethod( StronglyConnectedComponentOfFaceNC, "for a VEF-complex",
    [IsVEFComplex, IsPosInt],
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
InstallMethod( StronglyConnectedComponentOfFaceNC, "for a VEF-complex",
    [IsVEFComplex and IsStronglyConnected, IsPosInt],
    function(complex, face)
	return complex; # A strongly connected surface has only one strongly connected component
    end
);
InstallMethod( StronglyConnectedComponentOfFace, "for a VEF-complex",
    [IsVEFComplex, IsPosInt],
    function(complex, face)
	local faceList, faces, points, comp, change, faceNr, subsurf;

	__SIMPLICIAL_CheckFace(complex, face, "StronglyConnectedComponentOfFace");

	return StronglyConnectedComponentOfFaceNC( complex, face);
    end
);


InstallMethod( ConnectedComponentOfFaceNC, "for a VEF-complex",
    [IsVEFComplex and HasConnectedComponentsAttributeOfVEFComplex,
        IsPosInt],
    function( complex, face )
	local conCom, comp;

	conCom := ConnectedComponentsAttributeOfVEFComplex(complex);
	for comp in conCom do
	    if face in Faces(comp) then
		return comp;
	    fi;
	od;
	Error("ConnectedComponentOfFace: Internal error in ConnectedComponents.");
    end
);


InstallMethod( StronglyConnectedComponentOfFaceNC, "for a VEF-complex",
    [IsVEFComplex and HasStronglyConnectedComponentsAttributeOfVEFComplex, IsPosInt],
    function(complex, face)
	local conCom, comp;

	conCom := StronglyConnectedComponentsAttributeOfVEFComplex(complex);
	for comp in conCom do
	    if face in Faces(comp) then
		return comp;
	    fi;
	od;
	Error("StronglyConnectedComponentOfFace: Internal error in StronglyConnectedComponents.");
    end
);


InstallMethod( ConnectedComponentsAttributeOfVEFComplex,
    "for a VEF-complex", [IsVEFComplex],
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
InstallImmediateMethod( ConnectedComponentsAttributeOfVEFComplex,
    IsVEFComplex and IsConnected, 0, 
    function(complex)
	return [complex];
    end
);


InstallMethod( StronglyConnectedComponentsAttributeOfVEFComplex,
    "for a VEF-complex", [IsVEFComplex],
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
InstallImmediateMethod( StronglyConnectedComponentsAttributeOfVEFComplex,
    IsVEFComplex and IsStronglyConnected, 0,
    function(complex)
        return [complex];
    end
);


##
## After implementing connectivity and strong connectivity for themselves, we
## also want to work with the connection between them. We start with the
## direction "strongly connected"->"connected"
InstallImmediateMethod( IsConnected, 
    IsVEFComplex and HasStronglyConnectedComponentsAttributeOfVEFComplex, 0, 
    function( complex )
        local components;

        components := StronglyConnectedComponentsAttributeOfVEFComplex(complex);
        if Length(components) <= 1 then
            return true;
        fi;

        # If there is more than one path-connected component, the structure
        # might still be connected.
        TryNextMethod();
    end
);

InstallMethod( ConnectedComponentsAttributeOfVEFComplex,
    "for a VEF-complex with strongly connected components",
    [IsVEFComplex and HasStronglyConnectedComponentsAttributeOfVEFComplex ],
    function( complex )
        local strongComponents, components, vertList, check, newComponent,
            currentVert, done, i;

        strongComponents := StronglyConnectedComponents(complex);
        components := [];
        if strongComponents = [] then
            return [];
        fi;

        vertList := List( strongComponents, VerticesAttributeOfVEFComplex );

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

InstallMethod( StronglyConnectedComponentsAttributeOfVEFComplex, 
    "for a VEF-complex with connected components",
    [ IsVEFComplex and HasConnectedComponentsAttributeOfVEFComplex ],
    function( complex )
        local comp, pathComp, s;

        comp := ConnectedComponentsAttributeOfVEFComplex(complex);

        # If we only have one component, this method offers no benefit
        if Length(comp) = 1 then
            TryNextMethod();
        fi;

        pathComp := [];
        for s in comp do
            Append( pathComp, StronglyConnectedComponentsAttributeOfVEFComplex( s ) );
        od;

        return pathComp;
    end
);

## For surfaces the connected and path-connected components are
## identical. 
InstallMethod( ConnectedComponentsAttributeOfVEFComplex,
    "for a polygonal surface with strongly connected components",
    [IsPolygonalSurface and HasStronglyConnectedComponentsAttributeOfVEFComplex ],
    function(surf)
        return StronglyConnectedComponentsAttributeOfVEFComplex(surf);
    end
);
InstallMethod( StronglyConnectedComponentsAttributeOfVEFComplex, 
    "for a polygonal surface with connected components",
    [IsPolygonalSurface and 
        HasConnectedComponentsAttributeOfVEFComplex ],
    function(surf)
        return ConnectedComponentsAttributeOfVEFComplex(surf);
    end
);
InstallImmediateMethod( StronglyConnectedComponentsAttributeOfVEFComplex,
    IsPolygonalSurface and IsConnected, 0, 
    function(surf)
        return [surf];
    end
);


##
##      End of connectivity
##
#######################################



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


BindGlobal( "__SIMPLICIAL_AllTypes", 
    ["PolygonalComplex", "TriangularComplex", "RamifiedPolygonalSurface", "RamifiedSimplicialSurface", "PolygonalSurface", "SimplicialSurface"] );
##
## Automated construction of the constructors. Parameters:
## methodString: String for the method of the constructor (like 
##              "DownwardIncidence")
## typeStringList: List of strings of all supported types (like 
##              "PolygonalComplex" and "SimplicialSurface")
## objectConst: Function to construct an object with the given lists
## preCheck: Function to check consistency in normal case (should work with 
##              long and short version of arguments). This does not have to 
##              check whether the sets only contain positive integers
##              First argument is the name of the method where it is called,
##              the other arguments follow.
## postCheck: Function to check consistency in normal case after construction 
##              (only takes the method name and the constructed object as input)
## namesOfSets: List of strings (for the optional set-parameters)
## namesOfLists: List of strings (for the additional list-parameters)
BindGlobal( "__SIMPLICIAL_IntSetConstructor", 
    function( methodString, typeStringList, objectConst, preCheck, postCheck, namesOfSets, namesOfLists )
        local name, nameNC, typeString, shortFilter, nameProperty, setterNC, 
            setterNormal, descriptionShort, descriptionLong, longFilter, 
            shortPos, pos, filterStd, filterWeak, filterStrong, longFilterAlt,
            longFilterRe, normalFunction, description, i, wrapper;

        shortFilter := List( namesOfLists, i -> ValueGlobal("IsList") );
        longFilter := Concatenation( List(namesOfSets, i -> ValueGlobal("IsSet") ), shortFilter );
        shortPos := [Size(namesOfSets)+1..Size(longFilter)];
        longFilterAlt := List( [1..Size(longFilter)], i -> ValueGlobal("IsList") );
        longFilterRe := List(namesOfSets, i -> ValueGlobal("IsSet") );

        # Write a constructor for every type
        for typeString in typeStringList do
            name := Concatenation( typeString, "By", methodString );
            nameNC := Concatenation( name, "NC" );
            nameProperty := Concatenation( "Is", typeString );

            # Since the Setter-method of GAP does not work on synonyms, we
            # have to write the setters manually
            if typeString = "PolygonalComplex" then
                setterNC := function( obj ) end;
            elif typeString = "TriangularComplex" then
                setterNC := function( obj )
                    SetIsTriangularComplex(obj, true);
                end;
            elif typeString = "RamifiedPolygonalSurface" then
                setterNC := function( obj )
                    SetIsRamifiedPolygonalSurface(obj, true);
                end;
            elif typeString = "RamifiedSimplicialSurface" then
                setterNC := function( obj )
                    SetIsRamifiedPolygonalSurface(obj, true);
                    SetIsTriangularComplex(obj, true);
                end;
            elif typeString = "PolygonalSurface" then
                setterNC := function( obj )
                    SetIsPolygonalSurface(obj, true);
                end;
            elif typeString = "SimplicialSurface" then
                setterNC := function( obj )
                    SetIsPolygonalSurface(obj, true);
                    SetIsTriangularComplex(obj, true);
                end;
            else
                Error("This type is not supported.");
            fi;

            # The normal "setter" is just a test and can therefore easily
            # be implemented
            wrapper := function( typeString, name )
                return function( obj )
                    if not ValueGlobal( Concatenation("Is", typeString) )(obj) then
                        Error(Concatenation(name, ": Constructed complex is not a ", typeString));
                    fi;
                end;
            end;
            setterNormal := wrapper(typeString, name);

            descriptionShort := 
                Concatenation("for ", String(Size(namesOfLists)), " lists");
            descriptionLong := 
                Concatenation("for ", String(Size(namesOfSets)), 
                    " (sets of) positive integers and ", 
                    String(Size(namesOfLists)), " lists");

            # Install the short versions first
            wrapper := function( longFilter, name, setterNormal )
                return function(arg)
                    local obj, i, off;

                    # Check the sets for well-definedness
                    if Size(arg) = Size(longFilter) then
                        # The sets are present and have to be checked for well-definedness
                        for i in [1..Size(namesOfSets)] do
                            if ForAny(arg[i], x -> not IsPosInt(x)) then
                                Error(Concatenation(name,": ", namesOfSets[1], " have to be positive integers."));
                            fi;
                        od;
                    fi;

                    # Check the lists for well-definedness
                    off := 0;
                    if Size(arg) = Size(longFilter) then
                        off := Size(namesOfSets);
                    fi;
                    for i in [1..Size(namesOfLists)] do
                        if ForAny( arg[i+off], l -> not IsList(l) and ForAll(l, IsPosInt ) ) then
                            Error(Concatenation(name, ": The entries of ", namesOfLists[i], " have to be lists of positive integers."));
                        fi;
                    od;

                    CallFuncList( preCheck, Concatenation([name], arg));
                    obj := CallFuncList( objectConst, arg);
                    postCheck(name, obj);
                    setterNormal(obj);

                    return obj;
                end;
            end;
            normalFunction := wrapper(longFilter, name, setterNormal);
            # To install by using local functions we have to use a workaround
            wrapper := function( setterNC, descriptionShort, shortFilter )
                InstallMethod( ValueGlobal(nameNC),descriptionShort,shortFilter,
                    function(arg)
                        local obj;

                        obj := CallFuncList(objectConst,arg);
                        setterNC(obj);
                        return obj;
                    end);
            end;
            wrapper(setterNC, descriptionShort, shortFilter);
            wrapper := function(normalFunction, descriptionShort, shortFilter)
                InstallMethod( ValueGlobal(name), descriptionShort, shortFilter,
                    normalFunction );
            end;
            wrapper(normalFunction, descriptionShort, shortFilter);

            # Installing the long versions is a bit of a hassle because they
            # need many installations and redispatches
            wrapper := function(name, nameNC, normalFunction, descriptionLong, longFilter, shortPos, longFilterAlt, longFilterRe)
                InstallMethod( ValueGlobal(nameNC), descriptionLong, longFilter,
                    function(arg)
                        return CallFuncList( ValueGlobal(nameNC), arg{shortPos});
                    end);
                    RedispatchOnCondition( ValueGlobal(nameNC), true,
                        longFilterAlt, longFilterRe, 0);
                InstallMethod( ValueGlobal(name), descriptionLong, longFilter,
                    normalFunction);
                    RedispatchOnCondition( ValueGlobal(name), true,
                        longFilterAlt, longFilterRe, 0);
            end;
            wrapper(name, nameNC, normalFunction, descriptionLong, longFilter, shortPos, longFilterAlt, longFilterRe);

            # The implementation of the PosInt-alternative to sets takes
            # the most work:
            for pos in [1..Size(namesOfSets)] do
                filterStd := []; # filters for the method
                filterWeak := []; # these are accepted by redispatch
                filterStrong := []; # checked by redispatch
                description := "for";
                for i in [1..Size(namesOfSets)] do
                    if i < pos then
                        filterStd[i] := ValueGlobal("IsSet");
                        filterWeak[i] := ValueGlobal("IsList");
                        filterStrong[i] := ValueGlobal("IsSet");
                        Append(description, " a set,");
                    elif i = pos then
                        filterStd[i] := ValueGlobal("IsPosInt");
                        Append(description, " a positive integer,");
                    else
                        filterStd[i] := ValueGlobal("IsObject");
                        Append(description, " an object,");
                    fi;
                    Append(description, Concatenation(" and ", String(Size(namesOfLists)), " lists"));

                    # Install the methods
                    wrapper := function( name, nameNC, description, filterStd, filterWeak, filterStrong )
                        InstallOtherMethod( ValueGlobal(nameNC), description, filterStd, 
                            function(arg)
                                return CallFuncList( ValueGlobal(nameNC), 
                                    Concatenation(arg{[1..pos-1]}, [1..arg[pos]], arg{[pos+1..Size(arg)]}));
                            end);
                            RedispatchOnCondition( ValueGlobal(nameNC), true,
                                filterWeak, filterStrong, 0);
                        InstallOtherMethod( ValueGlobal(name), description, filterStd,
                            function(arg)
                                return CallFuncList( ValueGlobal(name),
                                    Concatenation(arg{[1..pos-1]}, [1..arg[pos]], arg{[pos+1..Size(arg)]}));
                            end);
                            RedispatchOnCondition( ValueGlobal(name), true,
                                filterWeak, filterStrong, 0);
                    end;
                    wrapper(name, nameNC, description, filterStd, filterWeak, filterStrong);
                od;
            od;
        od;
    end
);


##
## Provide some functions for checking inputs
BindGlobal("__SIMPLICIAL_CompareSets", 
    function(name, setA, setB, word)
        local symDiff;
        
        if not setA = setB then
            symDiff := Union( Difference(setA, setB), Difference(setB, setA) );
            Error(Concatenation(name, ": Given ", word, " information does not match for ", String(symDiff)));
        fi;
    end
);
BindGlobal("__SIMPLICIAL_TwoVerticesPerEdge",
    function(name, verticesOfEdges)
        local e;

        for e in [1..Size(verticesOfEdges)] do
            if IsBound(verticesOfEdges[e]) then
                if Size(verticesOfEdges[e]) <> 2 and verticesOfEdges[e][1] <> verticesOfEdges[e][2] then
                    Error(Concatenation(name, ": Edge ", String(e), 
                        " should have exactly two vertices, but has ", 
                        String(verticesOfEdges[e], ".")));
                fi;
            fi;
        od;
    end
);
BindGlobal( "__SIMPLICIAL_AtLeastTwoPerFace",
    function(name, edgesOfFaces, words)
        local f;

        for f in [1..Size(edgesOfFaces)] do
            if IsBound(edgesOfFaces[f]) then
                if Size(edgesOfFaces[f]) < 2 then
                    Error(Concatenation(name, ": Face ", String(f),
                        " should have at least two ", words,  ", but has ",
                        String(edgesOfFaces[f]), "."));
                fi;
            fi;
        od;
    end
);
BindGlobal( "__SIMPLICIAL_CheckPolygons",
    function( name, obj )
        local face, vertices, edges, vertexDegrees, perms;

        # We check the polygonal property by two separate properties:
        # 1) Every edge defines a transposition of its vertices. The group
        #    generated from those has to be transitive on the vertices.
        # 2) Every vertex is incident to exactly two edges inside the face.
        for face in Faces(obj) do
            vertices := VerticesOfFaces(obj)[face];
            edges := EdgesOfFaces(obj)[face];

            # 2
            vertexDegrees := List( vertices, v -> Intersection(edges, EdgesOfVertices(obj)[v]) );
            if ForAny( vertexDegrees, x -> Size(x) <> 2 ) then
                Error( Concatenation( name, ": Face ", String(face), " is not a polygon (bad degrees)." ) );
            fi;

            # 3
            perms := List( edges, e -> (VerticesOfEdges(obj)[e][1], VerticesOfEdges(obj)[e][2]) );
            if not IsTransitive( Group(perms) ) then
                Error( Concatenation( name, ": Face ", String(face), " is not a polygon (intransitive)." ) );
            fi;
        od;
    end
);
    

#######################################
##
##  Downward incidence
##

__SIMPLICIAL_IntSetConstructor("DownwardIncidence", __SIMPLICIAL_AllTypes,
    function( verticesOfEdges, edgesOfFaces )
        local obj;

        obj := Objectify( PolygonalComplexType, rec() );
        SetVerticesOfEdges(obj, verticesOfEdges);
        SetEdgesOfFaces(obj, edgesOfFaces);

        return obj;
    end,
    function( arg )
        local verticesDed, edgesDed, facesDed, verticesOfEdges,
            edgesOfFaces;

        # First we deduce vertices, edges and faces
        if Size(arg) = 3 then
            verticesOfEdges := arg[2];
            edgesOfFaces := arg[3];
        else
            verticesOfEdges := arg[5];
            edgesOfFaces := arg[6];
        fi;
        verticesDed := Union( verticesOfEdges );
        edgesDed := __SIMPLICIAL_BoundEntriesOfList(verticesOfEdges); # from incidence_geometry.gi
        facesDed := __SIMPLICIAL_BoundEntriesOfList(edgesOfFaces);
        
        # Compare the vertex, edge and face data
        if Size(arg) = 6 then
            __SIMPLICIAL_CompareSets( arg[1], arg[2], verticesDed, "vertex" );
            __SIMPLICIAL_CompareSets( arg[1], arg[3], edgesDed, "edge" );
            __SIMPLICIAL_CompareSets( arg[1], arg[4], facesDed, "face" );
        fi;
        __SIMPLICIAL_CompareSets( arg[1], edgesDed, Union(edgesOfFaces), "edge" );

        # Guarantee basic size restrictions
        __SIMPLICIAL_TwoVerticesPerEdge(arg[1], verticesOfEdges);
        __SIMPLICIAL_AtLeastTwoPerFace(arg[1], edgesOfFaces, "edges");
    end,
    __SIMPLICIAL_CheckPolygons,
    ["vertices", "edges", "faces"],
    ["verticesOfEdges", "edgesOfFaces"]);

##
##  End downward incidence
##
#######################################



#######################################
##
##  Upward incidence
##



##
##  End updward incidence
##
#######################################



#######################################
##
##  VerticesInFaces
##

__SIMPLICIAL_IntSetConstructor("VerticesInFaces", __SIMPLICIAL_AllTypes,
    function( verticesInFaces )
        local AdjacentVertices, allEdges, vertexPairs, edgesOfFaces, obj;

        AdjacentVertices := function(list)
            local pairs, i;

            pairs := [ Set( [list[1], list[Length(list)]] ) ];
            for i in [2..Length(list)] do
                Add(pairs, Set([ list[i-1], list[i] ]));
            od;
            return pairs;
        end;

        vertexPairs := List(verticesInFaces, AdjacentVertices);

        allEdges := Union( vertexPairs );
        # This is verticesOfEdges

        edgesOfFaces := List( vertexPairs, l -> List( l, p -> Position(allEdges,p) ) );

        obj := Objectify( PolygonalComplexType, rec() );
        SetVerticesOfEdges(obj, allEdges);
        SetVerticesOfFaces(obj, List(verticesInFaces,Set));
        SetEdgesOfFaces(obj, List(edgesOfFaces, Set));

        return obj;
    end,
    function( arg )
        local verticesDed, facesDed, verticesInFaces;

        # First we deduce vertices and faces
        if Size(arg) = 2 then
            verticesInFaces := arg[2];
        else
            verticesInFaces := arg[4];
        fi;
        verticesDed := Union( verticesInFaces );
        facesDed := __SIMPLICIAL_BoundEntriesOfList(verticesInFaces);
        
        # Compare the vertex and face data
        if Size(arg) = 4 then
            __SIMPLICIAL_CompareSets( arg[1], arg[2], verticesDed, "vertex" );
            __SIMPLICIAL_CompareSets( arg[1], arg[3], facesDed, "face" );
        fi;

        # Guarantee basic size restrictions
        __SIMPLICIAL_AtLeastTwoPerFace(arg[1], verticesInFaces, "vertices");
    end,
    function( name, obj )
        
    end,
    ["vertices", "faces"],
    ["verticesInFaces"]);

##
##  End verticesInFaces
##
#######################################




#######################################
##
##  EdgeFacePaths
##



##
##  End edgeFacePaths
##
#######################################

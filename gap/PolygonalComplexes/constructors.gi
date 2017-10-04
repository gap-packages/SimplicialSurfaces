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
## methodString: String for the method of the constructor (like "DownwardIncidence")
## typeStringList: List of strings of all supported types (like "PolygonalComplex" and "SimplicialSurface")
## objectConst: Function to construct an object with the given lists
## preCheck: Function to check consistency in normal case (should work with long and short version of arguments)
## postCheck: Function to check consistency in normal case after construction (only takes the constructed object as input)
## namesOfSets: List of strings (for the optional set-parameters)
## namesOfLists: List of strings (for the additional list-parameters)
BindGlobal( "__SIMPLICIAL_IntSetConstructor", 
    function( methodString, typeStringList, objectConst, preCheck, postCheck, namesOfSets, namesOfLists )
        local name, nameNC, typeString, shortFilter, nameProperty, setterNC, 
            setterNormal, descriptionShort, descriptionLong, longFilter, 
            shortPos, pos, filterStd, filterWeak, filterStrong;

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
                    SetIsTriangular(obj, true);
                end;
            elif typeString = "RamifiedPolygonalSurface" then
                setterNC := function( obj )
                    SetIsRamifiedPolygonalSurface(obj, true);
                end;
            elif typeString = "RamifiedSimplicialSurface" then
                setterNC := function( obj )
                    SetIsRamifiedPolygonalSurface(obj, true);
                    SetIsTriangular(obj, true);
                end;
            elif typeString = "PolygonalSurface" then
                setterNC := function( obj )
                    SetIsPolygonalSurface(obj, true);
                end;
            elif typeString = "SimplicialSurface" then
                setterNC := function( obj )
                    SetIsPolygonalSurface(obj, true);
                    SetIsTriangular(obj, true);
                end;
            else
                Error("This type is not supported.");
            fi;

            # The normal "setter" is just a test and can therefore easily
            # be implemented
            setterNormal := function( obj )
                if not ValueGlobal( Concatenation("Is", typeString) )(obj) then
                    Error(Concatenation(name, ": Constructed complex is not a ", typeString));
                fi;
            end;

            descriptionShort := Concatenation("for ", Size(namesOfLists), " lists");
            descriptionLong := Concatenation("for ", Size(namesOfSets), " (sets of) positive integers and ", Size(namesOfLists), " lists");

            # Install the short versions first
            normalFunction := function( arg )
                local obj;

                CallFuncList( preCheck, arg);
                obj := CallFuncList( objectConst, arg);
                postCheck(obj);
                setterNormal(obj);

                return obj;
            end;
            InstallMethod( ValueGlobal(nameNC),descriptionShort,shortFilter,
                function(arg)
                    local obj;

                    obj := CallFuncList(objectConst,arg);
                    setterNC(obj);
                    return obj;
                end);
            InstallMethod( ValueGlobal(name), descriptionShort, shortFilter,
                normalFunction );

            # Installing the long versions is a bit of a hassle because they
            # need many installations and redispatches
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
                    Append(description, Concatenation(" and ", Size(namesOfLists), " lists"));

                    # Install the methods
                    InstallMethod( ValueGlobal(nameNC), description, filterStd, 
                        function(arg)
                            return CallFuncList( ValueGlobal(nameNC), 
                                Concatenation(arg{[1..pos-1]}, [1..arg[pos]], arg{[pos+1..Size(arg)]}));
                        end);
                        RedispatchOnCondition( ValueGlobal(nameNC), true,
                            filterWeak, filterStrong, 0);
                    InstallMethod( ValueGlobal(name), description, filterStd,
                        function(arg)
                            return CallFuncList( ValueGlobal(name),
                                Concatenation(arg{[1..pos-1]}, [1..arg[pos]], arg{[pos+1..Size(arg)]}));
                        end);
                        RedispatchOnCondition( ValueGlobal(name), true,
                            filterWeak, filterStrong, 0);
                od;
            od;
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
    #preCheck,
    function( arg ) end,
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

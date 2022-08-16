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
    ["PolygonalComplex", "TriangularComplex", "PolygonalSurface", "SimplicialSurface"] );
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
        shortPos := [Length(namesOfSets)+1..Length(longFilter)];
        longFilterAlt := List( [1..Length(longFilter)], i -> ValueGlobal("IsList") );
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
            elif typeString = "PolygonalSurface" then
                setterNC := function( obj )
                    SetIsNotEdgeRamified(obj, true);
                    SetIsNotVertexRamified(obj, true);
                end;
            elif typeString = "SimplicialSurface" then
                setterNC := function( obj )
                    SetIsNotEdgeRamified(obj, true);
                    SetIsNotVertexRamified(obj, true);
                    SetIsTriangular(obj, true);
                end;
            else
                Error("This type is not supported.\n");
            fi;

            # The normal "setter" is just a test and can therefore easily
            # be implemented
            wrapper := function( typeString, name )
                return function( obj )
                    if not ValueGlobal( Concatenation("Is", typeString) )(obj) then
                        Error(Concatenation(name, ": Constructed complex is not a ", typeString, ".\n"));
                    fi;
                end;
            end;
            setterNormal := wrapper(typeString, name);

            descriptionShort := 
                Concatenation("for ", String(Length(namesOfLists)), " list(s)");
            descriptionLong := 
                Concatenation("for ", String(Length(namesOfSets)), 
                    " (sets of) positive integers and ", 
                    String(Length(namesOfLists)), " list(s)");

            # Install the short versions first
            wrapper := function( longFilter, name, setterNormal )
                return function(arg)
                    local obj, i, off;

                    # Check the sets for well-definedness
                    if Length(arg) = Length(longFilter) then
                        # The sets are present and have to be checked for well-definedness
                        for i in [1..Length(namesOfSets)] do
                            if ForAny(arg[i], x -> not IsPosInt(x)) then
                                Error(Concatenation(name,": ", namesOfSets[1], " have to be positive integers.\n"));
                            fi;
                        od;
                    fi;

                    # Check the lists for well-definedness
                    off := 0;
                    if Length(arg) = Length(longFilter) then
                        off := Length(namesOfSets);
                    fi;
                    for i in [1..Length(namesOfLists)] do
                        if ForAny( arg[i+off], l -> not IsList(l) or ForAny(l, x -> not IsPosInt(x) ) ) then
                            Error(Concatenation(name, ": The entries of ", namesOfLists[i], " have to be lists of positive integers.\n"));
                        fi;
                    od;

                    CallFuncList( preCheck, Concatenation([name], arg));
                    obj := CallFuncList( objectConst, arg{[off+1..Length(arg)]});
                    postCheck(name, obj);
                    setterNormal(obj);
                    SetIsDefaultChamberSystem(obj, true);

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
                        SetIsDefaultChamberSystem(obj,true);
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
            for pos in [1..Length(namesOfSets)] do
                filterStd := []; # filters for the method
                filterWeak := []; # these are accepted by redispatch
                filterStrong := []; # checked by redispatch
                description := "for";
                for i in [1..Length(namesOfSets)] do
                    if i < pos then
                        filterStd[i] := ValueGlobal("IsSet");
                        filterWeak[i] := ValueGlobal("IsList");
                        filterStrong[i] := ValueGlobal("IsSet");
                        Append(description, " a set,");
                    elif i = pos then
                        filterStd[i] := ValueGlobal("IsPosInt");
                        filterWeak[i] := ValueGlobal("IsPosInt");
                        Append(description, " a positive integer,");
                    else
                        filterStd[i] := ValueGlobal("IsObject");
                        filterWeak[i] := ValueGlobal("IsObject");
                        Append(description, " an object,");
                    fi;
                od;
                Append(description, Concatenation(" and ", String(Length(namesOfLists)), " list(s)"));
                Append( filterStd, shortFilter );
                Append( filterWeak, shortFilter );
                
                # Install the methods
                wrapper := function( name, nameNC, description, filterStd, filterWeak, filterStrong, pos )
                    InstallOtherMethod( ValueGlobal(nameNC), description, filterStd, 
                        function(arg)
                            return CallFuncList( ValueGlobal(nameNC), 
                                Concatenation(arg{[1..pos-1]}, [[1..arg[pos]]], arg{[pos+1..Length(arg)]}));
                        end);
                        RedispatchOnCondition( ValueGlobal(nameNC), true,
                            filterWeak, filterStrong, 0);
                    InstallOtherMethod( ValueGlobal(name), description, filterStd,
                        function(arg)
                            return CallFuncList( ValueGlobal(name),
                                Concatenation(arg{[1..pos-1]}, [[1..arg[pos]]], arg{[pos+1..Length(arg)]}));
                        end);
                        RedispatchOnCondition( ValueGlobal(name), true,
                            filterWeak, filterStrong, 0);
                end;
                wrapper(name, nameNC, description, filterStd, filterWeak, filterStrong, pos);
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
            Error(Concatenation(name, ": Given ", word, " information does not match for each ", word, " in ", String(symDiff),".\n"));
        fi;
    end
);
BindGlobal("__SIMPLICIAL_TwoVerticesPerEdge",
    function(name, verticesOfEdges)
        local e;

        for e in [1..Length(verticesOfEdges)] do
            if IsBound(verticesOfEdges[e]) then
                if Length(verticesOfEdges[e]) <> 2 or verticesOfEdges[e][1] = verticesOfEdges[e][2] then
                    Error(Concatenation(name, ": Edge ", String(e), 
                        " should have exactly two vertices, but has ", 
                        String(verticesOfEdges[e]), ".\n"));
                fi;
            fi;
        od;
    end
);
BindGlobal( "__SIMPLICIAL_AtLeastTwoPerFace",
    function(name, edgesOfFaces, words)
        local f;

        for f in [1..Length(edgesOfFaces)] do
            if IsBound(edgesOfFaces[f]) then
                if Length(edgesOfFaces[f]) < 2 then
                    Error(Concatenation(name, ": Face ", String(f),
                        " should have at least two ", words,  ", but has ",
                        String(edgesOfFaces[f]), ".\n"));
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
            if ForAny( vertexDegrees, x -> Length(x) <> 2 ) then
                Error( Concatenation( name, ": Face ", String(face), " is not a polygon (bad degrees).\n" ) );
            fi;

            # 3
            perms := List( edges, e -> (VerticesOfEdges(obj)[e][1], VerticesOfEdges(obj)[e][2]) );
            if not IsTransitive( Group(perms) ) then
                Error( Concatenation( name, ": Face ", String(face), " is not a polygon (intransitive).\n" ) );
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
        obj := Objectify( TwistedPolygonalComplexType, rec() );
        SetIsPolygonalComplex(obj, true);
        SetVerticesOfEdges(obj, List(verticesOfEdges, Set) );
        SetEdgesOfFaces(obj, List(edgesOfFaces, Set) );
        return obj;
    end,
    function( arg )
        local verticesDed, edgesDed, facesDed, verticesOfEdges,
            edgesOfFaces;

        # First we deduce vertices, edges and faces
        if Length(arg) = 3 then
            verticesOfEdges := arg[2];
            edgesOfFaces := arg[3];
        else
            verticesOfEdges := arg[5];
            edgesOfFaces := arg[6];
        fi;

        verticesDed := Union( verticesOfEdges ); #TODO this still can throw an error!
        edgesDed := PositionsBound(verticesOfEdges); # from incidence_geometry.gi
        facesDed := PositionsBound(edgesOfFaces);
        
        # Compare the vertex, edge and face data
        if Length(arg) = 6 then
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

__SIMPLICIAL_IntSetConstructor("UpwardIncidence", __SIMPLICIAL_AllTypes, 
    function( edgesOfVertices, facesOfEdges )
        local obj;
        obj := Objectify( TwistedPolygonalComplexType, rec() );
        SetIsPolygonalComplex(obj, true);
        SetEdgesOfVertices( obj, List(edgesOfVertices, Set) );
        SetFacesOfEdges(obj, List(facesOfEdges, Set) );
        return obj;
    end,
    function( arg )
        local verticesDed, edgesDed, facesDed, edgesOfVertices, facesOfEdges;

        # First we deduce vertices, edges and faces
        if Length(arg) = 3 then
            edgesOfVertices := arg[2];
            facesOfEdges := arg[3];
        else
            edgesOfVertices := arg[5];
            facesOfEdges := arg[6];
        fi;
        facesDed := Union( facesOfEdges );
        edgesDed := PositionsBound(facesOfEdges);
        verticesDed := PositionsBound(edgesOfVertices);
        
        # Compare the vertex, edge and face data
        if Length(arg) = 6 then
            __SIMPLICIAL_CompareSets( arg[1], arg[2], verticesDed, "vertex" );
            __SIMPLICIAL_CompareSets( arg[1], arg[3], edgesDed, "edge" );
            __SIMPLICIAL_CompareSets( arg[1], arg[4], facesDed, "face" );
        fi;
        __SIMPLICIAL_CompareSets( arg[1], edgesDed, Union(edgesOfVertices), "edge" );
    end,
    function( name, obj )
        # We have to check whether we have polygons and we have to check the basic
        # size restrictions
        __SIMPLICIAL_TwoVerticesPerEdge(name, VerticesOfEdges(obj));
        __SIMPLICIAL_AtLeastTwoPerFace(name, EdgesOfFaces(obj), "edges");
        __SIMPLICIAL_CheckPolygons(name, obj);
    end,
    ["vertices", "edges", "faces"],
    ["edgesOfVertices", "facesOfEdges"]);


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

        obj := Objectify( TwistedPolygonalComplexType, rec() );
        SetIsPolygonalComplex(obj, true);
        SetVerticesOfEdges(obj, allEdges);
        SetVerticesOfFaces(obj, List(verticesInFaces,Set));
        SetEdgesOfFaces(obj, List(edgesOfFaces, Set));

        return obj;
    end,
    function( arg )
        local verticesDed, facesDed, verticesInFaces;

        # First we deduce vertices and faces
        if Length(arg) = 2 then
            verticesInFaces := arg[2];
        else
            verticesInFaces := arg[4];
        fi;
        verticesDed := Union( verticesInFaces );
        facesDed := PositionsBound(verticesInFaces);
        
        # Compare the vertex and face data
        if Length(arg) = 4 then
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
##  UmbreallaDescriptors 
##


#############################################################################
##
#F  UmbrellaDescriptorOfSurface . . . . . compute the umbrella descriptor
##
##
InstallMethod( UmbrellaDescriptorOfSurface, 
    "for a simplicial surface", [IsSimplicialSurface], 
    function( surf) 
        local umb, umbdesc, j;

        umbdesc := [];
        umb := UmbrellaPathsOfVertices(surf);
        for j in [1..Length(umb)] do
          if IsBound(umb[j]) then
            if IsClosedPath(umb[j]) then
                # um[j] is a closed umbrella around a vertex
                # turn it into a cycle
                umbdesc[j] := CycleFromList(FacesAsList(umb[j]));
            else
                # um[j] is not a closed umbrella
                # store it as a list
                umbdesc[j] := FacesAsList(umb[j]);
            fi;
          fi;
        od;

        return umbdesc;
end);


###
###
## Local Code for umbrealls
##
## given one umbrella <umbrella> and a face <face> return the neighbours 
## of <face> in <umbrella> as a set
##
BindGlobal( "__SIMPLICIAL_UmbrellaAdjacentFaces",
    function( umbrella, face )
            local i, neigh;

            if IsPerm(umbrella) then
                neigh := [];
                i := face^umbrella;
                if i <> face then
                    Add(neigh, i);
                fi;
                i  := face^(umbrella^-1);
                if i <> face then
                    Add(neigh, i);
                fi;
                return Set(neigh);

            elif IsList(umbrella) then
                i := Positions( umbrella, face);
                # <face> is only allowed to occur once
                if Length(i) > 1 then
		    ErrorNoReturn(" face occurs too often in umbrella");
		fi;
                # <face> is not in the umbrella
                if Length(i) = 0 then return Set([]); fi;
                # if <face> is the only face there are no neighbours
                if Length(umbrella)=1 then return Set([]); fi;
                i := i[1]; # is the position of <face> in umbrella 

                # if <face> is a boundary face there is exactly one neighbour
                if i = 1 then return Set([umbrella[2]]); fi;
                if i = Length(umbrella) then
		    return Set([umbrella[Length(umbrella)-1]]);
		fi;
                # if <face> is not a boundary face there is are two neighbours
                return Set([umbrella[i-1],umbrella[i+1]]);
            else
	        # some umbrella is neither a permutation nor a list
	        return false;
            fi;
    end
);

##
## find all the faces of the surface described by the umbrella descriptor
## 
BindGlobal( "__SIMPLICIAL_FacesOfUmbrellaDescriptor",
    function( udesc )
        local faces, v;

        faces := Set([]);
        # the entries in the lists in <udesc> are the faces
        # test that the umbrella descriptors are either single
        # cycles or lists of length > 0 of pairwise different entries
        # and find all faces
        for v in udesc do
            if IsPerm(v) then
                if Length(CycleLengths(v,MovedPoints(v)))<>1 then
                  # Umbrella descriptors consist of single cycles ...
                   return false;
                fi;
                faces := Union(faces,MovedPoints(v));
            elif  IsList(v) and Length(v)<> 0  and
                # .. or non-empty lists of pairwise different elements. 
                Length(v) = Length(Set(v)) then
                faces := Union(faces,Set(v));
            else
               return false;
            fi;
        od;
 
       return faces;	

   end
);

##
## A test whether an umbrella descriptor is valid. It checks that
## each face occurs at most once in a single umbrella and that 
## it has at most 3 neighbours in the umbrella descriptor
##
BindGlobal( "__SIMPLICIAL_IsValidUmbrellaDescriptor",
    function( udesc )
        local f, u, faces, neighs, newn;

	faces := __SIMPLICIAL_FacesOfUmbrellaDescriptor(udesc);
	if faces = false then return false; fi;

	for f in faces do
            neighs := Set([]);
            for u in udesc do
                newn := __SIMPLICIAL_UmbrellaAdjacentFaces(u,f);
                if newn = false then return false; fi;
                neighs := Union(neighs, newn );
	    od;
            if Length(neighs) > 3 then return false; fi;
        od;
	
        return true;

    end
);

#############################################################################
##
#F  SimplicalSurfaceByUmbrellaDescriptor . . . surface by umbrella descriptor
##
##
##  <udesc> is a list as returned by the function UmbrellaDescriptorOfSurface.
##
InstallMethod( SimplicialSurfaceByUmbrellaDescriptor,
    "for a list",  [IsList], function(udesc) 

	local     vertices, edges, faces,  j, f, eofv, e, v,  
              neigh,  res, edgesOfVertices, facesOfEdges, 
              # local functions
              verticesInFace,
              ListFromCycle,  
              IsCorrectFaceWithVertexOfDegreeOne,
              IsCorrectFaceWithBoundary,
              IsCorrectFaceOfDegreeTwo;

        ListFromCycle := function (c)
  	    local l, p, s;

            if IsOne(c) then return []; fi;
            s := Minimum( MovedPoints(c) );
            l := [s]; p := s^c;
            while p <> s do
                Add(l,p);
                p := p^c;
            od;
            return l;
        end;
                

        # determine the vertices of f. This equals the indices of the
        # umbrellas containing f. Note that if there are not exactly
        # 3 umbrellas containing f, this is not a surface. 
        # We also allow only one vertex of f to have degree 2.
        verticesInFace := function( udesc, f)

            local umb, vtx, j;
 
            vtx := [];
            for j in [ 1.. Length(udesc)] do
                if not IsBound(udesc[j]) then continue; fi;
                umb := udesc[j];
                if IsList(umb) and f in umb then
                    # Half-umbrella
                    Add(vtx,j);
                 elif  IsPerm(umb) and f^umb <> f then
                    Add(vtx,j);
                fi;
            od;
            if Length(vtx)<>3 then
                Error("Face ", f ," should have 3 vertices");
                return false;
            fi;
            return vtx;
        end;

        # first we deal with the case that there is a vertex of degree 1
        # this is condition 2a)
        # <v> is a list of the positions of the 
        # three umbrellas containing <f>
        IsCorrectFaceWithVertexOfDegreeOne := function(f,v)

            local deg1, vtx, others, i, j, neighs;

            deg1 := [];
            for j in v do
                if udesc[j]=[f] then Add(deg1,j); fi;
            od;

            if Length(deg1) = 0 then
                # f does not have degree 1
                return "not applicable";
            fi;
            if Length(deg1) = 3 then
                # this means f is a connected component consisting of a
                # single face
#                Info(InfoSimplicialSurface,5,"#I found One-face component" );
                edgesOfVertices[deg1[1]] := [[1,f],[2,f]];
                edgesOfVertices[deg1[2]] := [[2,f],[3,f]];
                edgesOfVertices[deg1[3]] := [[3,f],[1,f]];
                AddSet(edges, [1,f]);
                AddSet(edges, [2,f]);
                AddSet(edges, [3,f]);
                return true;
            fi;
            if Length(deg1) = 2 then
                ErrorNoReturn("Found face with two vertices of degree 1");
            fi;

#            Info(InfoSimplicialSurface,5,"#I face with vertex of degree 1" );
            # now we know f has 1 vertex of degree 1
            # store in others the indices of the other umbrellas
            others := [];
            for i in [1 .. Length(v)] do
                if v[i] <> deg1[1] then
                    Add(others, v[i] );
                fi;
            od;

            # the neighbours of m in others must be the same
            neighs := List(others,
	         j->__SIMPLICIAL_UmbrellaAdjacentFaces(udesc[j], f));
            if Length(neighs[1]) <> 1 or Length(neighs[2]) <> 1 or
               Length(Intersection(neighs[1],neighs[2])) <> 1 then
               Error("Found face with  vertex of degree 1 but no neighbours");
               return false;
            fi;
            # neighs contains the unique neibouring face
            neighs := neighs[1][1];
            # two boundary edges
            AddSet(edgesOfVertices[deg1[1]], [1,f]);
            AddSet(edgesOfVertices[deg1[1]], [2,f]);
            AddSet(edges, [1,f] );
            AddSet(edges, [2,f] );
            # the inner edge
            AddSet(edges, [1,Set([f,neighs])] );
            AddSet(edgesOfVertices[others[1]],[1,f]);
            AddSet(edgesOfVertices[others[1]],[1,Set([f,neighs])]);
            AddSet(edgesOfVertices[others[2]],[2,f]);
            AddSet(edgesOfVertices[others[2]],[1,Set([f,neighs])]);
            return true;
        end;

        # Now we deal with the case that f does not have degree 1 vertex
        # and f is a boundary face. This is condition 2b)
        IsCorrectFaceWithBoundary := function(f,v)

            local vtx, umb, others, j, cycs, neighs, n1, n2;

            vtx :=[];
            for j in v do
                if IsList( udesc[j] ) then
                    umb := udesc[j];
                    if umb[1]=f or umb[Length(umb)]=f then
                        Add(vtx,j);
                    fi;
                fi;
            od;
            # vtx contains the positions of the half-cycles with boundary f

            if Length(vtx) = 0 then
                # f is not a boundary face;
                return "not applicable";
            fi;

            # there is a half umbrella with boundary ... 
            if Length(vtx) <> 2  then 
               # ... but there should then be two 
               ErrorNoReturn("Found boundary face which is incorrect ");
            fi;

            # now we check whether the neighbours of f in the two
            # half-cycles occur also in the other vertex
            neighs := [__SIMPLICIAL_UmbrellaAdjacentFaces(udesc[vtx[1]],f),
                       __SIMPLICIAL_UmbrellaAdjacentFaces(udesc[vtx[2]],f)];
            for j in neighs do
                if Length(j) <> 1 then
                    Error("Found boundary face which is incorrect ");
                    return false;
                fi;
            od;
            # the two neighbours
            n1 := neighs[1][1]; n2 := neighs[2][1];
            # Set j to the position of the third vertex
            j := Difference(v,vtx)[1];
            if n1 <> n2 then
                # the neighbours of f in the two halfcycles differ
                # Add the edges: one boundary and two inner edges
                AddSet( edges, [1,f] );
                AddSet( edges, [1,Set([f,n1])]); 
                AddSet( edges, [1,Set([f,n2])]); 
                # Add the edges of the vertices
                AddSet(edgesOfVertices[vtx[1]],[1,f] );
                AddSet(edgesOfVertices[vtx[2]],[1,f] );
                AddSet(edgesOfVertices[vtx[1]],[1,Set([f,n1])]); 
                AddSet(edgesOfVertices[vtx[2]],[1,Set([f,n2])]); 
                # th vertex at j is incident to the two inner edges.
                AddSet(edgesOfVertices[j],[1,Set([f,n1])]); 
                AddSet(edgesOfVertices[j],[1,Set([f,n2])]); 
#                Info(InfoSimplicialSurface,5,"#I Surface with boundary face" );
                
            else
                # the neighbours of f are identical  
                # this means we have an ear
                # and the umberella at j has to be a 2-cycle
                cycs := udesc[j]; 
                if cycs = false or cycs <> (f,n1) then
                     # the dihedral cycle should contain f and the neighbour 
                     ErrorNoReturn("Found boundary face which is incorrect ");
                fi;
#                Info(InfoSimplicialSurface,5,"#I Surface with boundary ear" );
                AddSet( edges, [1,f] );
                # there are two inner edges between f and n1
                AddSet( edges, [1,Set([f,n1])]); 
                AddSet( edges, [2,Set([f,n1])]); 
                # Add the edges of the vertices
                AddSet(edgesOfVertices[vtx[1]],[1,f] );
                AddSet(edgesOfVertices[vtx[2]],[1,f] );
                AddSet(edgesOfVertices[vtx[1]],[1,Set([f,n1])]); 
                AddSet(edgesOfVertices[vtx[2]],[2,Set([f,n1])]); 
                # the vertex at j is incident to the two inner edges.
                AddSet(edgesOfVertices[j],[1,Set([f,n1])]); 
                AddSet(edgesOfVertices[j],[2,Set([f,n1])]); 
            fi;
    
            return true;

        end;


        # test whether f has a vertex of degree 2 but no boundary edge
        IsCorrectFaceOfDegreeTwo := function (f,v)

            local vtx, cycs, neigh, umb, other, j, common;

            cycs := []; 
            for j in v do
                if not IsPerm(udesc[j]) then
                    # face has a boundary and has been treated
                    return "not applicable";
                elif Order(udesc[j]) = 2 then
                    Add(cycs,j);
                fi;
            od;
           

            if Length(cycs) = 0 then
                return "not applicable";
            fi;
            # now we know f has a vertex of degree 2
            if Length(cycs) = 2 then
               Error("Found face with two vertices of degree 2");
               return false;
            fi;
            # if we have 3 verties of degree 2, we should have a Janus head
            if Length(cycs) = 3 then
                umb := udesc[cycs[1]];
                if umb <> udesc[cycs[2]] or umb <> udesc[cycs[3]] then
                    Error("Found face with 3 different vertices of degree 2");
                    return false;
                fi;
#                Info(InfoSimplicialSurface,5,"#I Janus Head component\n");
                AddSet( edges, [1,Set(MovedPoints(umb))]);
                AddSet( edges, [2,Set(MovedPoints(umb))]);
                AddSet( edges, [3,Set(MovedPoints(umb))]);
                AddSet(edgesOfVertices[v[1]],[2,Set(MovedPoints(umb))]);
                AddSet(edgesOfVertices[v[1]],[3,Set(MovedPoints(umb))]);
                AddSet(edgesOfVertices[v[2]],[1,Set(MovedPoints(umb))]);
                AddSet(edgesOfVertices[v[2]],[3,Set(MovedPoints(umb))]);
                AddSet(edgesOfVertices[v[3]],[1,Set(MovedPoints(umb))]);
                AddSet(edgesOfVertices[v[3]],[2,Set(MovedPoints(umb))]);
                return true;
            fi;

#            Info(InfoSimplicialSurface,5,"#I Surface with inner ear" );
            # now we know that f is an ear and that f is not a boundary
            # face, so the other umbrellas are cycles.
            vtx := Difference(v,cycs);
            common := [__SIMPLICIAL_UmbrellaAdjacentFaces(udesc[vtx[1]],f),
                       __SIMPLICIAL_UmbrellaAdjacentFaces(udesc[vtx[2]],f)];
            # f has two neighbours that are incidet to vtx[1] and vtx[2],
            # namely the other face in the 2-cycle and some other face
            
            # the other umbrellas also have to contain neigh as a neighbour
            if  Set(common[1]) <> Set(common[2]) then
                ErrorNoReturn("Found face with incorrect vertex of degree 2");
            fi;
            # but there should be another common neighbour 
            umb := Set(MovedPoints(udesc[cycs[1]]));
            other := Difference( common[1], umb );
            if Length(other) <> 1 then
                ErrorNoReturn("Found face with incorrect vertex of degree 2");
            fi;
            # this is the other face that is not involved in the ear
            neigh := other[1];

            # there are two inner edges at the vertex of degree 2 
            AddSet( edges, [1,umb]);
            AddSet( edges, [2,umb]);
            # there is one inner edges between f and neigh
            AddSet( edges, [1,Set([f,neigh])]);

            # Add the edges of the vertices
            # the vertex of degree 2 
            AddSet(edgesOfVertices[cycs[1]],[1,umb] );
            AddSet(edgesOfVertices[cycs[1]],[2,umb] );

            # the other vertices
            vtx := Difference(v,cycs);
            AddSet(edgesOfVertices[vtx[1]],[1,umb] );
            AddSet(edgesOfVertices[vtx[2]],[2,umb] );

            AddSet(edgesOfVertices[vtx[1]],[1,Set([f,neigh])]); 
            AddSet(edgesOfVertices[vtx[2]],[1,Set([f,neigh])]); 

            return true;

        end;

        faces := __SIMPLICIAL_FacesOfUmbrellaDescriptor(udesc);
        if faces = false then
           Info(InfoSimplicial,5,"#I Not a valid umbrella descriptor\n");
           return false;
	fi;

        # the vertices correspond to the umbrellas
        vertices := []; v := 1;
        for j in [1..Length(udesc)] do
            if IsBound(udesc[j]) then
                vertices[j] := v;
                v := v + 1;
            fi;
        od;

        edgesOfVertices := List(vertices,i->Set([]));

        # the edges we have to find now
        edges := Set([]);

        for f in faces do
            v := verticesInFace(udesc,f);
            if v = false then 
                Error( "Input is not an umbrella descriptor of a surface");
                    return false;
            fi;

            # Now we know f appears in the 3 vertices stored in v
            res := IsCorrectFaceWithVertexOfDegreeOne(f,v);
            if res = false then return false;
            elif res = true then continue; fi;

            res :=  IsCorrectFaceWithBoundary(f,v);
            if res = false then return false;
            elif res = true then continue; fi;

            # now we know that f is not a boundary face.
            res :=  IsCorrectFaceOfDegreeTwo(f,v);
            if res = false then return false;
            elif res = true then continue; fi;

            # Now we check the condition d)
            for j in v do
                # add the neighbours of f at vertex v
                neigh := __SIMPLICIAL_UmbrellaAdjacentFaces(udesc[j],f);
                AddSet(edges,[1,Set([f, neigh[1]])]);
                AddSet(edges,[1,Set([f, neigh[2]])]);
                AddSet(edgesOfVertices[j],[1,Set([f, neigh[1]])]);
                AddSet(edgesOfVertices[j],[1,Set([f, neigh[2]])]);
            od;
                                    
            
        od;

        eofv := []; 
        # now we have to turn the edgesOfVertices into position lists
        for j in [1..Length(udesc)] do
            if IsBound(udesc[j]) then
                eofv[j] := [];
                for e in edgesOfVertices[j] do
                    AddSet(eofv[j], Position(edges,e));
                od;
            fi;
        od;

        facesOfEdges := [];
        for j in [1..Length(edges)] do
            e := edges[j];
            if IsSet(e[2]) then
                    # inner edges
		    facesOfEdges[j] := e[2];
            else
                    # boundary edges
		    facesOfEdges[j] := [e[2]];
            fi;
        od;

        # now we know that each face occurs in exactly three umbrellas
        # and for each face we have stored its vertices
        # so we can call SimplicialSurfaceByUpwardIncidence
        return SimplicialSurfaceByUpwardIncidence(  eofv, facesOfEdges );

end);
        


#############################################################################
##
#F  NormedUmbrellaDescriptorOfSurface . . . normed umbrella descriptor of a surface
##
##
##  <udesc> is a list as returned by the function UmbrellaDescriptorOfSurface.
##  <face> is a face in the surface, the optional third argument <neighs> are
##  neighbouring faces of <face>.
##
__SIMPLICIAL_NormedUmbrellaDescriptor := function( ud, face, neigh)

        local faces, pos, newud, neighs, udlist, onface, orign,
              i, j, k, UDContainingF, pt, u, AddN, fn, l, o;

        fn := "NormedUmbrellaDescriptor";
    
        # Data structures: 
        #
        # a) A list <pos> with the new ordering of the faces, that
        #    is the face in pos[i] has new number i. Initially:
        #    pos := [face, neigh[1], neigh[2], neigh[3]];
        # b) udlist is a list of umbrella descriptors in the old
        #    numbering that still need to be renumbered
        # c) newud a list of already renumbered umbrellas



        # add a neighbour pair in a sorted manner
        # l is a list of length 2
        AddN := function(neighs,l)
                if Position(pos,l[1]) < Position(pos,l[2]) then
		            Add(neighs, l );
                else 
		            Add(neighs,[l[2],l[1]]);
                fi;
        end;

        # Find all umbrellas in udlist on face <face>
        # organise the umbrellas in such a way that the
        # neighbour pairs of faces are increasing
        UDContainingF := function( udlist, face)
		    local newud, u, neighs, cmp, perm, l;

                # we can compare two neighbour pairs 
                # by replacing them with their new numbers
                # and comparing these lexicographically
                cmp := function( n1, n2 )

                    # this should also work with entries fail
                    n1 := Set([ Position(pos,n1[1]), Position(pos,n1[2])]);
                    n2 := Set([ Position(pos,n2[1]), Position(pos,n2[2])]);
			        return n1 < n2;
                end;
                        
            newud := [];
            neighs := []; # A list of neighbour pairs
            for u in udlist do
		if IsPerm(u) and face^u <> face then
		    Add(newud, u);
                    AddN(neighs, [face^u, face^(u^-1)]);
                elif IsList(u) and face in u then
			        Add(newud, u);
                    l := Length(u);
                    if l = 1 then
                        # <face> has no neighbours
                        Add(neighs, [-1,-1]);
                    elif u[1] = face then
                        # <face> has only one neighbour
                        Add(neighs, [u[2],-1]);
                    elif u[l] = face then
                        # <face> has only one neighbour
                        Add(neighs, [u[l-1],-1]);
                    else
                        # <face> has two neighbours
                        i := Position(u,face);
                        AddN(neighs, [u[i-1],u[i]]);
                    fi;
                fi;
            od;

            if Length(newud) <= 1 then
			    return [newud,neighs];
            fi;

            # sort the list newud (which has length 3), so that the 
            # umbrella descriptor stored in position i corresponds 
            # to the one containing the i-th neighbour pair in neighs.
		    perm := Sortex(neighs,cmp)^-1;
            newud := List([1..Length(newud)], i-> newud[i^perm]);
		    return [newud,neighs];	
        end;


        # the faces of the surface are the moved points of <ud>
        faces := Set([]);
        for u in ud do
            if IsPerm(u) then
                faces := Union(faces, MovedPoints(u) );
            else
                faces := Union(faces,u);
            fi;
        od;

        # check if the input is valid. 
        if not __SIMPLICIAL_IsValidUmbrellaDescriptor(ud) then
            ErrorNoReturn(fn, " umbrella descriptor not a valid descriptor" );
        fi;
        # <face> must be one of the faces and the entries in <neigh>
        # as well and they must be  neighbours of <face>
        if not face in faces then
	        ErrorNoReturn(fn, ": face must be a face in the descriptor");
        fi;
        # the face in pos[i] has new number i
        pos := [face];
        onface :=UDContainingF(ud, face);
        orign := Set([]);
        for u in onface[1] do
            orign := Union(orign,__SIMPLICIAL_UmbrellaAdjacentFaces(u,face));
        od;
	Append(neigh, Difference(orign,neigh));
        if Length(neigh) > 3 then 
          ErrorNoReturn(fn," ",neigh," more than 3 neighbours of ", face);
        fi;
        for i in [ 1..Length(neigh) ] do 
            if not neigh[i] in faces or not neigh[i] in orign then
	        ErrorNoReturn(fn," ",neigh[i]," must be a neighbour of ",face);
	    fi;
            pos[i+1] := neigh[i];
        od;

        
        newud := [];

        # udlist stores all the umbrella descriptors
        # still to renumber
        udlist := ShallowCopy(ud);

        # Deal with the face in position i
        i := 1;
        while i <= Length(pos) do
            face := pos[i];
            onface := UDContainingF(udlist, face);
            # onface[1] are up to  three umbrella descriptors containing 
            # <face> in increasing order and
            # onface[2] is a list containing at most three neighbour pairs
            # remove the three descriptors on <face> from the list
            # of descriptors still to be renumbered
            udlist := Difference(udlist, onface[1]);
            for j in [1..Length(onface[1])] do
                # deal with the j-th ud 
                u := onface[1][j];
                neighs := onface[2][j];
                if IsPerm(u) then
                    # ensure we walk around the correct way.
                    # (1,2, ..., 3)
                    if face^u in pos and face^(u^-1) in pos and
                        Position(pos,face^(u^-1))<Position(pos,face^u) then
                        # e.g. u=(1,3,....,2) for pos=[1,2,3] and face=1
                        u := u^-1;
                    elif not face^u  in pos and face^(u^-1) in pos then
                        # e.g. u=(1,6,....,2) for pos=[1,2,3] and face=1
                        u := u^-1; 
                    fi;
                    pt := face^u;
                    # skip over points already numbered
                    k := 1; o := Order(u);

                    # check the points in the cycle and rename any new ones
                    while k <= o do
                        if not  pt in pos then 
                            Add(pos,pt);
                        fi;
                        pt := pt^u; 
                        k := k + 1;
                    od;
                    Add(newud, u);
                elif IsList(u) then
                    k := Position(u,face);
                    l := Length(u);
                    if k > 1 and k < l then
                        if Position(pos,u[k-1]) > Position(pos,u[k+1]) then
                           # left neighbour is bigger than right neighbour
                           # so we have to reverse the entries in u
                           u := Reversed(u);
                        fi;
                    elif k = l then
                        u := Reversed(u);
                    fi;
                    if k < l then
                       pt := face;
                       # now rename the new points in this cycle.
                       while k < l  do
		           if not pt in pos then
		               Add(pos,pt);
			   fi;
                           k := k + 1;
                           pt := u[k]; 
                       od;
                    fi;
                    Add(newud, u);
                fi; # IsList(u)
                 
            od; # for-loop
            
            i := i + 1;
        od;

        # fill up pos
        for face in [1..Maximum(faces)] do
            if not face in pos then
                Add(pos,face);
            fi;
        od;
        pos := PermList(pos);
        if pos = fail then
            ErrorNoReturn(fn,": Not a valid umbrella descriptor");
        fi;
        pos := pos^-1;

        # now apply the permutation  pos to newud
        ud := newud;
        newud := [];
        for i in [ 1 .. Length(ud) ] do
            if not IsBound(ud[i]) then continue; fi;
            if IsPerm(ud[i]) then
               newud[i] := ud[i]^pos;
            elif IsList(ud[i]) then
               newud[i] := List( ud[i], j-> j^pos );
            else
                ErrorNoReturn(fn,": Not a valid umbrella descriptor");
            fi; 
        od;

        return newud;
end;


InstallMethod( NormedUmbrellaDescriptor,
    "for a list, a positive integer and a list",  [IsList,IsPosInt,IsList], function(ud,face,neigh) 
    return __SIMPLICIAL_NormedUmbrellaDescriptor(ud, face, neigh);
end
);



InstallMethod( NormedUmbrellaDescriptor,
    "for a list, a positive integer",  [IsList,IsPosInt], function(ud,face) 
    return __SIMPLICIAL_NormedUmbrellaDescriptor(ud, face, []);
end
);

#############################################################################
##
##  compute the degree sequence of a normed umbrella descriptor
##
InstallMethod( DegreeSequenceOfUmbrellaDescriptor,
    "for a list",  [IsList], function(ud) 

        local i, l;

        # check if the input is valid. 
        if not __SIMPLICIAL_IsValidUmbrellaDescriptor(ud) then
            ErrorNoReturn(" umbrella descriptor not a valid descriptor" );
        fi;

	# as we have already checked that the umbrella descriptor
	# <ud> is valid, we know that every bound entry is either a
	# single cycle or a list.
        l := [];
        for i in [1..Length(ud)] do
            if IsBound(ud[i]) then
                if IsPerm(ud[i]) then
                    l[i] := [Order(ud[i]),true];
                else
                    l[i] := [Length(ud[i]),false];
                fi;
            fi;
        od;

        return l;
end
);


# cannot deal with umbrellas of length 2 yet
# ucode is a list of of lists. The first entry of each of these is
# a number, giving the length of the umbrella descriptor, the second
# is true if the descriptor is a cycle and false if it is a half-cycle
# for closed surfaces ucode can just be a list of numbers and that
# corresponds to the same list of numbers with the second entries always
# being set true

InstallMethod( AllUmbrellaDescriptorsOfDegreeSequence,
    "for a list",  [IsList],
      function( ucode )

        local ud, c, i, F, F1, F2, N, n, C, nrfaces, u, neighs, oncycles,
             isValid, findNeighs, CyclesOfUD, nucode, Pos, FindAllNeighs,
             nextStep, done, AllUmbrellaDescriptors, p, val, id, nextF,
             isClosedSurf;


        # Data structures:
        #
        # a) neighs is a list of list which contains in position F
        #    the list of neighbours of the face F
        # b) ud is the list of new umbrella descriptors (working matrix)
        # c) oncycles stores in position F in how many descriptors F is
        # d) done, a boolean list to say which ud are completed
        # e) AllUmbrellaDescriptors global list containing all such


        # find the position of F in u before or in position l
        Pos := function( u, l, F)
            local i;

            for i in [1 .. l] do
                if u[i]=F then return i; fi;
            od;

            return false;
        end;

        # Turn umbrella descriptor matrix ucode into cycles or lists
        # each row of ucode is either an umbrella of an inner vertex and
        # thus should be stored as a cycle, or a list from one boundary
        # face to another. In either case, the matrix can have trailing
        # 0s in each row that need to be removed
        CyclesOfUD := function( ud )

            local cud, i, perm, u;

            cud := [];
            for i in [ 1 .. Length(ucode) ] do
                # we have to remove the 0s
                u := ud[i];
                # if the vertex is inner, it is a permutation
                if ucode[i][2]=true then
                    # turn the umbrella into a cycle
                    perm := CycleFromList(u{[1..ucode[i][1]]});
                    if perm = fail then
                        ErrorNoReturn("invalid umbrella descriptor");
                    fi;
                    Add( cud, perm);
                else Add( cud, u{[1..ucode[i][1]]});
                fi;
            od;
            return cud;
        end;

        # This function finds all neigbours of the face F
        # in ud up to position [c,p]
        # This function assumes ud[c][p] is valid and filled
        FindAllNeighs := function( ud, c, p, F )

            local neighs, i, r;

            neighs := [];
            for r in [ 1 .. c-1] do
                Append( neighs, findNeighs(ud[r],ucode[r][1],F,ucode[r][2]) );
            od;
            for i in [ 1 .. p ] do
                if ud[c][i] = F then
                    if i = 1 and 2<=p then
                        Add(neighs,ud[c][2]);
                    elif i = p and i > 1 then
                        Add(neighs,ud[c][i-1]);
                    else
                        Add(neighs,ud[c][i-1]);
                        Add(neighs,ud[c][i+1]);
                    fi;
                fi;
            od;

            return neighs;
        end;


        # Find the neighbours of face F in a given umbrella u
        # this is assuming F is in u and u has length l
        # if the last argument is true, it is a cycle and thus
        # it cycles around the end, otherwise it is not a cycle
        findNeighs := function( u, l, F, iscyc )

            local i, neighs;

            i := Pos(u,l,F);

            if i = false then return []; fi;
            # if u has length 1 then F has no neighbours
            if l = 1 then return []; fi;

            if i = 1 and iscyc then
                # u starts with F
                return Difference([u[2],u[l] ],[0]);
            elif i = 1 and not iscyc then
                # u starts with F
                return Difference([u[2]],[0]);
            elif i = l and iscyc then
                # u ends with F
                return Difference([u[1],u[l-1] ],[0]);
            elif i = l and not iscyc then
                # u ends with F
                return Difference([u[l-1] ],[0]);
            else 
                return Difference([u[i-1],u[i+1]],[0]);
            fi;
        end;

        # test if we can use F in the umbrella descriptor in position c
        # F has to satisfy the following two tests:
        # a) it can only appear in 3 descriptors
        # b) it can only have 3 neighbours
        # c) each neighbour pair can only be in 2 umbrellas

        # This function tests if the umbrella descriptor ud
        # is valid until row c and position p if face F
        # were to be inserted there. It assumes it is valid until then
        isValid := function(ud, c, F, p )
            local u, r, l, nbs, i, G, neighs, neighsG, j, oncyc, alln;

            u := ud[c]; l := ucode[c][1];

            # if F already occurs in u then we cannot add it again
            if Pos(u,l,F)  <> false then
                return false;
            fi;

            # if we add F to any new descriptor and it will be in
            # too many cycles then we return false
            oncyc := []; neighs := Set([]);
            for r in [1 .. c-1] do
                j := Pos(ud[r],ucode[r][1],F);
                if j <> false then
                  Add( oncyc, [r,j] );
                  # Find the existing neighbours of F
                  Append(neighs, findNeighs(ud[r],ucode[r][1],F,ucode[r][2]));
                fi;
            od;
            neighs := Set(neighs);

            if Length(oncyc) >= 3 then
                return false;
            fi;
                
            # now we know we can fill position p
            # nbs the putative neighbours of F in row c
            nbs := Set([]);

            if p = 1 then
                if u[2] <> 0 then Add(nbs,u[2]); fi;
                if u[l] <> 0 then Add(nbs,u[l]); fi;
            elif p=ucode[c][1] then
                if u[1] <> 0 then Add(nbs,u[1]); fi;
                if u[l-1]<>0 then Add(nbs,u[l-1]); fi;
            else
                if u[p-1] <> 0 then Add(nbs, u[p-1]); fi; 
                if u[p+1] <> 0 then Add(nbs, u[p+1]); fi;
            fi;

            # new neighbours of face F are nbs 
            # in total, F may only have 3 neighbours
            if Size( Union( neighs, nbs ) ) > 3 then return false; fi;

            ud[c][p]:= F;
            Add( oncyc, [c,p] );

            # now we need to check that by adding F we do not create
            # problems for its new neighbours
            for G in nbs do
                alln := FindAllNeighs(ud,c,p,G);
                if Size( Union(alln,[F]) ) > 3 then
                    return false;
                fi;
                alln := Filtered(alln, i-> i > G );
                if isClosedSurf and  p = 2 and u[1] = G and
                    F <> Minimum(alln) then
                    # ensure lexicographically least sequence
                    return false;
                fi;
          
                # Find the neighbour pairs of the faces G
                # which are the neighbours of F
                # neighsG := [];
                # G must have 3 different  neighbour pairs
                i := 0;
                for j in [1..Length(oncyc)] do
                    r := oncyc[j][1]; # F occurs in row r
                    if Pos(ud[r],ucode[r][1],G) <> false then
                        # G also occurs in row r 
                        # add neigbour pair of G
                        neighsG := findNeighs(ud[r],ucode[r][1],G,ucode[r][2]);
                        # the neighbour pairs of G in row r
                        if F in neighsG then i := i + 1; fi;
                        if i>= 3 then
                            # We are only allowed to have F and G
                            # as neigbour pair twice
                            return false;
                        fi;
                    fi;
                od;

            od;

            return true;
      end;

        # check the validity of the input
        if not IsList(ucode) then
            Error("UmbrellaDescriptorsDegreeSequence: Input must be a list");
            return false;
        fi;
        nucode := [];
        for i in ucode do
            if IsInt(i) and i > 0 then
                Add(nucode,[i,true]);
            elif IsList(i) and IsInt(i[1]) and i[1]>0 and IsBool(i[2]) then
                    Add(nucode,i);
                    if i[2] = false then
                        ErrorNoReturn("UmbrellaDescriptorsDegreeSequence: not yet implemented");
                    fi;
            else
                   Error("AllUmbrellaDescriptorsDegreeSequence: Input wrong");
                   return false;
            fi;
        od;
        ucode := nucode;

        ud := [];
        ud := NullMat(Length(ucode),Maximum(List(ucode,i->i[1]))); 
        # store all valid umbrella descriptors here
        AllUmbrellaDescriptors := [];
        for i in [1 .. Length(ucode)] do
            if ucode[i][1] < 3 then
                Error("not yet implemented");
                return false;
            fi;
        od;
        F := 1; # F is the number of the face we are working on
        nrfaces := Sum( List( ucode, i-> i[1] ));
        if  nrfaces mod 3 <> 0 then 
            Error("UmbrellaDescriptorUmbrellaCode: Invalid number of faces");
        fi;
        nrfaces := nrfaces/3;
        oncycles :=  NullMat(nrfaces,3);
        id := IdentityMat(Maximum(List(ucode,i->i[1])), 
                           Maximum(List(ucode,i->i[1]))); 


    # Next free face number we use is N
    nextStep := function(ud, c, N)

            local u, p, n, id, newneighs, copyneighs, copycycs, F;


            id := IdentityMat(Maximum(List(ucode,i->i[1])), 
                              Maximum(List(ucode,i->i[1]))); 

            while c <= Length(ucode) do
                # if there is a 0, it is incomplete
                p := Pos(ud[c],ucode[c][1],0);
                if p = false then
                    # the umbrella u is complete
                    c := c + 1;
                else break;
                fi;
            od;
            # in position c there is an incomplete descriptor
            # note, this umbrella could be empty

            # if all umbrellas of ud are done, then we add ud to results
            if c > Length(ucode) then
                # we are completely finished
                Add(AllUmbrellaDescriptors,CyclesOfUD(ud)); 
                return;
            fi;
 
            # now we know that ud[c] is incomplete and position p is free
           
            F := 1;
            while F <= N do
                # if F cannot be put into ud[c][p] we continue
                if isValid(ud,c,F,p) = false then
                    F := F + 1;
                    continue;
                fi;
   
                # we now try F in u
                ud[c][p] := F;

                # recurse
                if F = N and N+1 <= nrfaces then
                    nextStep (ud*id, c, N+1);
                else
                    nextStep (ud*id, c,  N);
                fi;
 
                F := F + 1;
                ud[c][p] := 0;
                # only try the smallest valid face in position 1
                if p = 1 then F := N+1; fi;
            od;
        end;

        # we test whether the surface is closed or not
        # closed surfaces are more efficient, as we can
        # make more assumptions on choosing lexicographically
        # least faces
        isClosedSurf := true;
        for C in [1..Length(ucode)] do
            if ucode[C][2] = false then
                isClosedSurf := false;
            fi;
        od;
        

        # Deal with the first cycle [1,2,...,3]
        if isClosedSurf then
            if ucode[1][1] > 2 and ucode[1][2] = true then
                ud[1][1] := 1; ud[1][2] := 2; ud[1][ucode[1][1]] := 3;
                ud[2][1] := 1; ud[2][2] := 2; ud[2][ucode[2][1]] := 4;
                ud[3][1] := 1; ud[3][2] := 3; ud[3][ucode[3][1]] := 4;
                C := 1; nextF := 5;
            elif ucode[1][1] = 2 and ucode[1][2] = true then
                ud[1][1] := 1; ud[1][2] := 2;
                ud[2][1] := 1; ud[2][2] := 2; ud[2][ucode[2][1]] := 3;
                ud[3][1] := 1; ud[3][2] := 2; ud[3][ucode[3][1]] := 3;
                 C := 2; nextF := 4;
            fi;
        else
            ud[1][1] := 1; C  := 1; nextF := 2;
         fi;

        nextStep (ud, C, Minimum(nrfaces,nextF));

        return AllUmbrellaDescriptors;

end);


##
##  End UmbrellaDescriptors
##
#######################################



#######################################
##
##  DressGroups
##


#############################################################################
##
#F  SimplicalSurfaceByDressGroup . . . . . . . . .  .surface by dress group
##
##  Test whether the permutation group <D> defines a simplicial surface whose
##  Dress group is <D> and if so, return the surface.
##
##
InstallMethod( SimplicialSurfaceByDressGroup,
    "for a permutation group",  [IsPermGroup], function(grp) 

        local vertices, edges, faces, D0, D1, D2, dom,
              t1, t2, t3, v, e, f, i, j, gens, infostr,
              verticesofedge, facesofedges, edgesofvertices;

        dom := MovedPoints(grp);
        gens := GeneratorsOfGroup(grp);
        if Length(gens)<>3 then
            return false;
        fi;

        t0 := gens[1];
        t1 := gens[2];
        t2 := gens[3];
        D0 := Group( [t1, t2] );
        D1 := Group( [t0, t2] );
        D2 := Group( [t0, t1] );

        infostr := "the dress relations are not satisfied.";
        # t0 and t1 are to have no fixed points
        if Size(MovedPoints(t0)) <> Length(dom) then
            Info( InfoSimplicial,2, infostr );
            return false;
        fi;
        if Size(MovedPoints(t1)) <> Length(dom) then
            Info( InfoSimplicial,2, infostr );
            return false;
        fi;
        if Size(MovedPoints(t0*t1)) <> Length(dom) then
            Info( InfoSimplicial,2, infostr );
            return false;
        fi;
        if Size(MovedPoints(t0*t2)) <> Length(dom) then
            Info( InfoSimplicial,2, infostr );
            return false;
        fi;
        if Size(MovedPoints(t1*t2)) <> Length(dom) then
            Info( InfoSimplicial,2, infostr );
            return false;
        fi;


        # all generators must be involutions
        if IsOne(t0) or IsOne(t1) then
            Info( InfoSimplicial,2, infostr );
            return false;
        fi;
        if not IsOne(t0^2) or not IsOne(t1^2) or not IsOne(t2^2) then
            Info( InfoSimplicial,2, infostr );
            return false;
        fi;
        if IsOne( t0*t2) or not IsOne( (t0*t2)^2 ) then
            Info( InfoSimplicial,2, infostr );
            return false;
        fi;
        if IsOne( t0*t1) or not IsOne( (t0*t1)^3 ) then
            Info( InfoSimplicial,2, infostr );
            return false;
        fi;
        # now we know that the group satisfies the dress relations

        vertices := Orbits( D0, dom);
        edges := Orbits( D1, dom);
        faces := Orbits( D2, dom);

        # now we test necessary conditions that we
        # may have a surface
        for f in faces do
            if Length(f) <> 6 then
                Info( InfoSimplicial,2, "Faces must have 6 flags" );
                return false;
            fi;
        od;
        for e in edges do
            if not Length(e) in [2,4] then
                Info( InfoSimplicial,2, "Edges must have 2 or 4 flags" );
                return false;
            fi;

            # check that the vertices of e are all different
            verticesofedge := Set([]);
            for i in [ 1 .. Length(e) ] do
                  for j in [ 1 .. Length(vertices)] do
                      if e[i] in vertices[j] then
                          AddSet(verticesofedge,j);
                      fi;
                  od;
            od;
            if Length(verticesofedge) <> 2 then
                Info( InfoSimplicial,2, "Edges must have 2 vertices" );
                return false;
            fi;
        od;

        edgesofvertices := [];
        for i in [1..Length(vertices)] do
            v := vertices[i];
            edgesofvertices[i]:=[];
            for j in [ 1 .. Length(edges) ] do
                e := edges[j];
                if Intersection(e,v) <> [] then
                  Add(edgesofvertices[i],j);
                fi;
            od;
            if Length(edgesofvertices[i])<2 then
                Info( InfoSimplicial,2, "Vertices must have at least 2 edges" );
                return false;
            fi;
        od; 

        facesofedges := [];
        for i in [1..Length(edges)] do
            e := edges[i];
            facesofedges[i]:=[];
            for j in [ 1 .. Length(faces) ] do
                f := faces[j];
                if Intersection(e,f) <> [] then
                  Add(facesofedges[i],j);
                  if Length(facesofedges[i])>2 then
                      Info( InfoSimplicial,2, "Edges can have only 2 faces" );
                      return false;
                  fi;
                fi;
            od;
        od; 

    return SimplicialSurfaceByUpwardIncidence(edgesofvertices,facesofedges);
end;



##
##  End DressGroups
##
#######################################


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
        obj := Objectify( PolygonalComplexType, rec() );
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
        edgesDed := __SIMPLICIAL_BoundPositions(verticesOfEdges); # from incidence_geometry.gi
        facesDed := __SIMPLICIAL_BoundPositions(edgesOfFaces);
        
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
        obj := Objectify( PolygonalComplexType, rec() );
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
        edgesDed := __SIMPLICIAL_BoundPositions(facesOfEdges);
        verticesDed := __SIMPLICIAL_BoundPositions(edgesOfVertices);
        
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

        obj := Objectify( PolygonalComplexType, rec() );
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
        facesDed := __SIMPLICIAL_BoundPositions(verticesInFaces);
        
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
##  EdgeFacePaths
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
              adjacentFaces, 
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
                
        # given one umbrella <umb> and a face <f> return its neighbours
        # in <umb> as a set
        adjacentFaces := function( umb, f )

            local i, neigh;

            if IsPerm(umb) then
                neigh := [];
                i := f^umb;
                if i <> f then
                    Add(neigh, i);
                fi;
                i  := f^(umb^-1);
                if i <> f then
                    Add(neigh, i);
                fi;
                return Set(neigh);
            else

                i := Positions( umb, f);
                if Length(i) <> 1 then return Set([]); fi;
                # if f is the only face there are no neighbours
                if Length(umb)=1 then return Set([]); fi;
                i := i[1]; 

                # if f is a boundary face there is exactly one neighbour
                if i = 1 then return Set([umb[2]]); fi;
                if i = Length(umb) then return Set([umb[Length(umb)-1]]); fi;

                # if f is not a boundary face there is are two neighbours
                return Set([umb[i-1],umb[i+1]]);
             fi;

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
                Error("Found face with two vertices of degree 1");
                return false;
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
            neighs := List(others, j->adjacentFaces(udesc[j], f));
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
               Error("Found boundary face which is incorrect ");
               return false;
            fi;

            # now we check whether the neighbours of f in the two
            # half-cycles occur also in the other vertex 
            neighs := [adjacentFaces(udesc[vtx[1]],f),
                       adjacentFaces(udesc[vtx[2]],f)];
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
                     Error("Found boundary face which is incorrect ");
                     return false;
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
            common := [adjacentFaces(udesc[vtx[1]],f),
                       adjacentFaces(udesc[vtx[2]],f)];
            # f has two neighbours that are incidet to vtx[1] and vtx[2],
            # namely the other face in the 2-cycle and some other face
            
            # the other umbrellas also have to contain neigh as a neighbour
            if  Set(common[1]) <> Set(common[2]) then
                    Error("Found face with incorrect vertex of degree 2");
                    return false;
            fi;
            # but there should be another common neighbour 
            umb := Set(MovedPoints(udesc[cycs[1]]));
            other := Difference( common[1], umb );
            if Length(other) <> 1 then
                    Error("Found face with incorrect vertex of degree 2");
                    return false;
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


        faces := Set([]);
        # the entries in the lists in <udesc> are the faces
        # test that the umbrella descriptors are either single
        # cycles or lists of length > 0 of pairwise different entries
        # and find all faces
        for v in udesc do
            if IsPerm(v) then 
                if Length(CycleLengths(v,MovedPoints(v)))<>1 then 
                    # Umbrella descriptors consist of single cycles ...
                    Error("Input is not an umbrella descriptor of a surface");
                    return false;
                fi;
                faces := Union(faces,Set(ListFromCycle(v)));
            elif  IsList(v) and Length(v)<> 0  and 
                # .. or non-empty lists of pairwise different elements. 
                Length(v) = Length(Set(v)) then
                faces := Union(faces,Set(v));
            else
                Error("Input is not an umbrella descriptor of a surface");
                return false;
            fi;
        od;

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
                neigh := adjacentFaces(udesc[j],f);
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
        


##
##  End edgeFacePaths
##
#######################################




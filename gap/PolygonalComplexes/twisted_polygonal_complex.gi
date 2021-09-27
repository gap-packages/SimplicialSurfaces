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


##############################################################################
##
##          Methods for incidence
##
InstallMethod( NumberOfChambers, "for a twisted polygonal complex", [IsTwistedPolygonalComplex],
    function(complex)
        return Length( Chambers(complex) );
    end
);


## VerticesOfChambers
InstallMethod(VertexOfChamberNC, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, chamber)
        return VerticesOfChambers(complex)[chamber];
    end
);
InstallMethod(VertexOfChamber,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, chamber)
        __SIMPLICIAL_CheckChamber( complex, chamber, "VertexOfChamber" );
        return VertexOfChamberNC(complex,chamber);
    end
);

## ChambersOfVertices
InstallMethod(ChambersOfVertexNC, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, vertex)
        return ChambersOfVertices(complex)[vertex];
    end
);
InstallMethod(ChambersOfVertex,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, vertex)
        __SIMPLICIAL_CheckVertex( complex, vertex, "ChambersOfVertex" );
        return ChambersOfVertexNC(complex, vertex);
    end
);

## EdgesOfChambers
InstallMethod(EdgeOfChamberNC, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, chamber)
        return EdgesOfChambers(complex)[chamber];
    end
);
InstallMethod(EdgeOfChamber,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, chamber)
        __SIMPLICIAL_CheckChamber( complex, chamber, "EdgesOfChamber" );
        return EdgeOfChamberNC(complex,chamber);
    end
);

## ChambersOfEdges
InstallMethod(ChambersOfEdgeNC, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, edge)
        return ChambersOfEdges(complex)[edge];
    end
);
InstallMethod(ChambersOfEdge,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge( complex, edge, "ChambersOfEdge" );
        return ChambersOfEdgeNC(complex, edge);
    end
);

## FacesOfChambers
InstallMethod(FaceOfChamberNC, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, chamber)
        return FacesOfChambers(complex)[chamber];
    end
);
InstallMethod(FaceOfChamber,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, chamber)
        __SIMPLICIAL_CheckChamber( complex, chamber, "FaceOfChamber" );
        return FaceOfChamberNC(complex,chamber);
    end
);

## ChambersOfFaces
InstallMethod(ChambersOfFaceNC, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, face)
        return ChambersOfFaces(complex)[face];
    end
);
InstallMethod(ChambersOfFace,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, face)
        __SIMPLICIAL_CheckFace( complex, face, "ChambersOfFace" );
        return ChambersOfFaceNC(complex, face);
    end
);

##
##          End of methods for incidence
##
##############################################################################


##############################################################################
##
##          Methods for chamber adjacency
##

__SIMPLICIAL_AddTwistedAttribute(ZeroAdjacencyRelation);
__SIMPLICIAL_AddTwistedAttribute(OneAdjacencyRelation);
__SIMPLICIAL_AddTwistedAttribute(TwoAdjacencyRelation);
__SIMPLICIAL_AddTwistedAttribute(ZeroAdjacencyClasses);
__SIMPLICIAL_AddTwistedAttribute(OneAdjacencyClasses);
__SIMPLICIAL_AddTwistedAttribute(TwoAdjacencyClasses);
__SIMPLICIAL_AddTwistedAttribute(ZeroAdjacencyInvolution);
__SIMPLICIAL_AddTwistedAttribute(OneAdjacencyInvolution);
__SIMPLICIAL_AddTwistedAttribute(TwoAdjacencyInvolution);

## from Relation to chambers
InstallMethod( Chambers,
    "for a twisted polygonal complex with ZeroAdjacencyRelation",
    [IsTwistedPolygonalComplex and HasZeroAdjacencyRelation],
    function(complex)
        return Set(Source(ZeroAdjacencyRelation(complex)));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "Chambers", ["ZeroAdjacencyRelation"] );
InstallMethod( Chambers,
    "for a twisted polygonal complex with OneAdjacencyRelation",
    [IsTwistedPolygonalComplex and HasOneAdjacencyRelation],
    function(complex)
        return Set(Source(OneAdjacencyRelation(complex)));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "Chambers", ["OneAdjacencyRelation"] );
InstallMethod( Chambers,
    "for a twisted polygonal complex with TwoAdjacencyRelation",
    [IsTwistedPolygonalComplex and HasTwoAdjacencyRelation],
    function(complex)
        return Set(Source(TwoAdjacencyRelation(complex)));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "Chambers", ["TwoAdjacencyRelation"] );


## from Classes to chambers
InstallMethod( Chambers,
    "for a twisted polygonal complex with ZeroAdjacencyClasses",
    [IsTwistedPolygonalComplex and HasZeroAdjacencyClasses],
    function(complex)
        return __SIMPLICIAL_UnionSets(ZeroAdjacencyClasses(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "Chambers", ["ZeroAdjacencyClasses"] );
InstallMethod( Chambers,
    "for a twisted polygonal complex with OneAdjacencyClasses",
    [IsTwistedPolygonalComplex and HasOneAdjacencyClasses],
    function(complex)
        return __SIMPLICIAL_UnionSets(OneAdjacencyClasses(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "Chambers", ["OneAdjacencyClasses"] );
InstallMethod( Chambers,
    "for a twisted polygonal complex with TwoAdjacencyClasses",
    [IsTwistedPolygonalComplex and HasTwoAdjacencyClasses],
    function(complex)
        return __SIMPLICIAL_UnionSets(TwoAdjacencyClasses(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "Chambers", ["TwoAdjacencyClasses"] );


## from Involutions to chambers
InstallMethod( Chambers,
    "for a twisted polygonal complex with ZeroAdjacencyInvolution",
    [IsTwistedPolygonalComplex and HasZeroAdjacencyInvolution],
    function(complex)
        return MovedPoints( ZeroAdjacencyInvolution(complex) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "Chambers", ["ZeroAdjacencyInvolution"] );
InstallMethod( Chambers,
    "for a twisted polygonal complex with OneAdjacencyInvolution",
    [IsTwistedPolygonalComplex and HasOneAdjacencyInvolution],
    function(complex)
        return MovedPoints( OneAdjacencyInvolution(complex) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "Chambers", ["OneAdjacencyInvolution"] );



## from Relation to Classes
InstallMethod( ZeroAdjacencyClasses, 
    "for a twisted polygonal complex with ZeroAdjacencyRelation",
    [IsTwistedPolygonalComplex and HasZeroAdjacencyRelation],
    function(complex)
        return Set( EquivalenceRelationPartition( ZeroAdjacencyRelation(complex) ), Set );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "ZeroAdjacencyClasses", ["ZeroAdjacencyRelation"] );
InstallMethod( OneAdjacencyClasses, 
    "for a twisted polygonal complex with OneAdjacencyRelation",
    [IsTwistedPolygonalComplex and HasOneAdjacencyRelation],
    function(complex)
        return Set( EquivalenceRelationPartition( OneAdjacencyRelation(complex) ), Set);
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "OneAdjacencyClasses", ["OneAdjacencyRelation"] );
InstallMethod( TwoAdjacencyClasses, 
    "for a twisted polygonal complex with TwoAdjacencyRelation",
    [IsTwistedPolygonalComplex and HasTwoAdjacencyRelation],
    function(complex)
        local classes, el, rel, iter;

        rel := TwoAdjacencyRelation(complex);
        # This call is insufficient since there might be elements that
        # are only equivalent to themselves
        classes := List( EquivalenceRelationPartition(rel), Set);
        for el in Source(rel) do
            iter := Iterator( EquivalenceClassOfElementNC(rel, el) );
            NextIterator(iter);
            if IsDoneIterator(iter) then # Singleton
                Add(classes, [el]);
            fi;
        od;
        Sort(classes);
        return classes;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "TwoAdjacencyClasses", ["TwoAdjacencyRelation"] );


## from Classes to Relation
InstallMethod( ZeroAdjacencyRelation,
    "for a twisted polygonal complex with ZeroAdjacencyClasses and Chambers",
    [IsTwistedPolygonalComplex and HasZeroAdjacencyClasses and HasChambers],
    function(complex)
        return EquivalenceRelationByPartitionNC(Domain(Chambers(complex)), ZeroAdjacencyClasses(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "ZeroAdjacencyRelation", ["ZeroAdjacencyClasses", "Chambers"] );
InstallMethod( OneAdjacencyRelation,
    "for a twisted polygonal complex with OneAdjacencyClasses and Chambers",
    [IsTwistedPolygonalComplex and HasOneAdjacencyClasses and HasChambers],
    function(complex)
        return EquivalenceRelationByPartitionNC(Domain(Chambers(complex)), OneAdjacencyClasses(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "OneAdjacencyRelation", ["OneAdjacencyClasses", "Chambers"] );
InstallMethod( TwoAdjacencyRelation,
    "for a twisted polygonal complex with TwoAdjacencyClasses and Chambers",
    [IsTwistedPolygonalComplex and HasTwoAdjacencyClasses and HasChambers],
    function(complex)
        return EquivalenceRelationByPartitionNC(Domain(Chambers(complex)), TwoAdjacencyClasses(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "TwoAdjacencyRelation", ["TwoAdjacencyClasses", "Chambers"] );


## from Involution to Classes
InstallMethod( ZeroAdjacencyClasses, 
    "for a twisted polygonal complex with ZeroAdjacencyInvolution and Chambers",
    [IsTwistedPolygonalComplex and HasZeroAdjacencyInvolution and HasChambers],
    function(complex)
        return Cycles( ZeroAdjacencyInvolution(complex), Chambers(complex) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "ZeroAdjacencyClasses", ["Chambers", "ZeroAdjacencyInvolution"] );
InstallMethod( OneAdjacencyClasses, 
    "for a twisted polygonal complex with OneAdjacencyInvolution and Chambers",
    [IsTwistedPolygonalComplex and HasOneAdjacencyInvolution and HasChambers],
    function(complex)
        return Cycles( OneAdjacencyInvolution(complex), Chambers(complex) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "OneAdjacencyClasses", ["OneAdjacencyInvolution","Chambers"] );
InstallMethod( TwoAdjacencyClasses, 
    "for a twisted polygonal complex without edge ramifications with TwoAdjacencyInvolution and Chambers",
    [IsTwistedPolygonalComplex and IsNotEdgeRamified and HasTwoAdjacencyInvolution and HasChambers],
    function(complex)
        return Cycles(TwoAdjacencyInvolution(complex), Chambers(complex));
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "TwoAdjacencyClasses", ["TwoAdjacencyInvolution", "Chambers"], ["IsNotEdgeRamified"] );

# If the TwoAdjacencyInvolution is not fail, the complex has no edge ramification
InstallImmediateMethod( IsNotEdgeRamified,
    IsTwistedPolygonalComplex and HasTwoAdjacencyInvolution, 0,
    function(complex)
        return TwoAdjacencyInvolution(complex) <> fail;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "IsNotEdgeRamified", ["TwoAdjacencyInvolution"] );


## from Classes to Involution
InstallMethod( ZeroAdjacencyInvolution,
    "for a twisted polygonal complex with ZeroAdjacencyClasses and Chambers",
    [IsTwistedPolygonalComplex and HasZeroAdjacencyClasses and HasChambers],
    function(complex)
        local list, cl, maxChamber;

        maxChamber := Maximum(Chambers(complex));
        list := [1..maxChamber];
        for cl in ZeroAdjacencyClasses(complex) do
            list[cl[1]] := cl[2];
            list[cl[2]] := cl[1];
        od;
        return PermList(list);
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "ZeroAdjacencyInvolution", ["ZeroAdjacencyClasses", "Chambers"] );

InstallMethod( OneAdjacencyInvolution,
    "for a twisted polygonal complex with OneAdjacencyClasses and Chambers",
    [IsTwistedPolygonalComplex and HasOneAdjacencyClasses and HasChambers],
    function(complex)
        local list, cl, maxChamber;

        maxChamber := Maximum(Chambers(complex));
        list := [1..maxChamber];
        for cl in OneAdjacencyClasses(complex) do
            list[cl[1]] := cl[2];
            list[cl[2]] := cl[1];
        od;
        return PermList(list);
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "OneAdjacencyInvolution", ["OneAdjacencyClasses", "Chambers"] );

InstallMethod( TwoAdjacencyInvolution,
    "for a twisted polygonal complex with TwoAdjacencyClasses and Chambers",
    [IsTwistedPolygonalComplex and HasTwoAdjacencyClasses and HasChambers],
    function(complex)
        local list, cl, maxChamber;

        maxChamber := Maximum(Chambers(complex));
        list := [1..maxChamber];
        for cl in TwoAdjacencyClasses(complex) do
            if Length(cl) = 2 then
                list[cl[1]] := cl[2];
                list[cl[2]] := cl[1];
            elif Length(cl) > 2 then
                return fail;
            fi;
        od;
        return PermList(list);
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "TwoAdjacencyInvolution", ["TwoAdjacencyClasses", "Chambers"] );


####
##
## Construct adjacent chambers
##
####

InstallMethod( ZeroAdjacentChamberNC, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, c)
        return c^ZeroAdjacencyInvolution(complex);
    end
);
InstallMethod( ZeroAdjacentChamber, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, c)
        __SIMPLICIAL_CheckChamber(complex, c, "ZeroAdjacentChamber");
        return ZeroAdjacentChamberNC(complex,c);
    end
);
InstallMethod( OneAdjacentChamberNC, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, c)
        return c^OneAdjacencyInvolution(complex);
    end
);
InstallMethod( OneAdjacentChamber, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, c)
        __SIMPLICIAL_CheckChamber(complex, c, "OneAdjacentChamber");
        return OneAdjacentChamberNC(complex,c);
    end
);

InstallMethod( TwoAdjacentChamberNC,
    "for a twisted polygonal complex without edge ramifications and a positive integer",
    [IsTwistedPolygonalComplex and IsNotEdgeRamified, IsPosInt],
    function(complex, c)
        return c^TwoAdjacencyInvolution(complex);
    end
);
InstallMethod( TwoAdjacentChamber,
    "for a twisted polygonal complex without edge ramifications and a positive integer",
    [IsTwistedPolygonalComplex and IsNotEdgeRamified, IsPosInt],
    function(complex, c)
        __SIMPLICIAL_CheckChamber(complex, c, "TwoAdjacentChamber");
        return TwoAdjacentChamberNC(complex,c);
    end
);
InstallMethod( TwoAdjacentChambersNC,
    "for a twisted polygonal complex without edge ramifications and a positive integer",
    [IsTwistedPolygonalComplex and IsNotEdgeRamified, IsPosInt],
    function(complex, c)
        return [TwoAdjacentChamberNC(complex,c)];
    end
);
InstallMethod( TwoAdjacentChambers,
    "for a twisted polygonal complex without edge ramifications and a positive integer",
    [IsTwistedPolygonalComplex and IsNotEdgeRamified, IsPosInt],
    function(complex, c)
        __SIMPLICIAL_CheckChamber(complex, c, "TwoAdjacentChambers");
        return TwoAdjacentChambersNC(complex,c);
    end
);

InstallMethod( TwoAdjacentChambersNC,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex,c)
        local class, iter, res, el;

        class := EquivalenceClassOfElementNC(TwoAdjacencyRelation(complex),c);
        iter := Iterator(class);
        res := [];
        while not IsDoneIterator(iter) do
            el := NextIterator(iter);
            if c <> el then
                Add(res, el);
            fi;
        od;
        return Set(res);
    end
);
InstallMethod( TwoAdjacentChambers,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex,c)
        __SIMPLICIAL_CheckChamber(complex, c, "TwoAdjacentChambers");
        return TwoAdjacentChambersNC(complex, c);
    end
);
InstallMethod( TwoAdjacentChamberNC,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, c)
        return TwoAdjacentChambersNC(complex,c)[1];
    end
);
InstallMethod( TwoAdjacentChamber,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, c)
        local res;

        __SIMPLICIAL_CheckChamber(complex, c, "TwoAdjacentChamber");
        res := TwoAdjacentChambersNC(complex,c);
        if Length(res) <> 1 then
            Error(Concatenation("TwoAdjacentChamber: Given chamber ", 
                String(c), " is 2-adjacent to all chambers in ", 
                String(res), 
                ", so the result is not unique. To obtain this set, please use TwoAdjacentChambers."));
        fi;
        return res[1];
    end
);

####
##
## Check adjacency
##
####

InstallMethod( IsZeroAdjacentChambersNC,
    "for a twisted polygonal complex and two positive integers",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, c1,c2)
        return c2 = ZeroAdjacentChamberNC(complex,c1);
    end
);
InstallMethod( IsZeroAdjacentChambers,
    "for a twisted polygonal complex and two positive integers",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, c1,c2)
        __SIMPLICIAL_CheckChamber(complex, c1, "IsZeroAdjacentChambers");
        __SIMPLICIAL_CheckChamber(complex, c2, "IsZeroAdjacentChambers");
        return IsZeroAdjacentChambersNC(complex,c1,c2);
    end
);
InstallMethod( IsOneAdjacentChambersNC,
    "for a twisted polygonal complex and two positive integers",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, c1,c2)
        return c2 = OneAdjacentChamberNC(complex,c1);
    end
);
InstallMethod( IsOneAdjacentChambers,
    "for a twisted polygonal complex and two positive integers",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, c1,c2)
        __SIMPLICIAL_CheckChamber(complex, c1, "IsOneAdjacentChambers");
        __SIMPLICIAL_CheckChamber(complex, c2, "IsOneAdjacentChambers");
        return IsOneAdjacentChambersNC(complex,c1,c2);
    end
);

InstallMethod( IsTwoAdjacentChambersNC,
    "for a twisted polygonal complex without edge ramifications and two positive integers",
    [IsTwistedPolygonalComplex and IsNotEdgeRamified, IsPosInt, IsPosInt],
    function(complex, c1,c2)
        return c2 = TwoAdjacentChamberNC(complex,c1);
    end
);
InstallMethod( IsTwoAdjacentChambersNC,
    "for a twisted polygonal complex and two positive integers",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, c1,c2)
        return c2 in EquivalenceClassOfElementNC(TwoAdjacencyRelation(complex),c1);
    end
);
InstallMethod( IsTwoAdjacentChambers,
    "for a twisted polygonal complex and two positive integers",
    [IsTwistedPolygonalComplex, IsPosInt, IsPosInt],
    function(complex, c1,c2)
        __SIMPLICIAL_CheckChamber(complex, c1, "IsTwoAdjacentChambers");
        __SIMPLICIAL_CheckChamber(complex, c2, "IsTwoAdjacentChambers");
        return IsTwoAdjacentChambersNC(complex,c1,c2);
    end
);



##
##          End of methods for adjacency
##
##############################################################################



##############################################################################
##
##          Start of constructors
##

BindGlobal( "__SIMPLICIAL_VerifyAdjacencyInvolution",
    function( perm, method, number )
        if perm^2 <> () then
            Error( Concatenation( method, ": ", number, 
                "AdjacencyInvolution should be an involution but is ", 
                String(perm), "." ) );
        fi;
    end
);
BindGlobal( "__SIMPLICIAL_VerifyAdjacencyClasses",
    function( list, method, number )
        local i, j, el, inter;

        for i in [1..Length(list)] do
            el := list[i];
            # Check whether each element is correct
            if not IsList(el) then
                Error(Concatenation( method, ": ", number, 
                    "AdjacencyClasses should be a list of lists, but the entry at position ", 
                    String(i), " is ", String(el), "." ));
            fi;
            if number = "Zero" or number = "One" then
                if Length(el) <> 2 then
                    Error(Concatenation( method, ": Every element of ", number, 
                        "AdjacencyClasses should be a list with two entries, but the entry at position ", 
                        String(i), " is ", String(el), "." ));
                fi;
                if not IsPosInt(el[1]) or not IsPosInt(el[2]) then
                    Error(Concatenation( method, ": Every element of ", number, 
                        "AdjacencyClasses should be a list of positive integers, but the entry at position ", 
                        String(i), " is ", String(el), "." ));
                fi;
            else
                if Length(el) = 0 then
                    Error(Concatenation( method, ": Every element of ", number, 
                        "AdjacencyClasses should be a non-empty list, but the entry at position ", 
                        String(i), " is ", String(el), "." ));
                fi;
                if not ForAll(el, IsPosInt) then
                    Error(Concatenation( method, ": Every element of ", number, 
                        "AdjacencyClasses should be a list of positive integers, but the entry at position ", 
                        String(i), " is ", String(el), "." ));
                fi;
            fi;
            # Compare to all previous elements to check intersections
            for j in [1..i-1] do
                inter := Intersection(el, list[j]);
                if Length(inter) > 0 then
                    Error(Concatenation( method, ": The elements of ", number,
                        "AdjacencyClasses should be disjoint, but the entries at positions ",
                        String(i), " and ", String(j), " intersect in ", String(inter), "."));
                fi;
            od;
        od;
    end
);
BindGlobal( "__SIMPLICIAL_VerifyAdjacencyRelation",
    function(rel, method, number)
        local iter, next, equiv, counter;

        iter := Iterator(Source(rel));
        while not IsDoneIterator(iter) do
            next := NextIterator(iter);
            # Check whether domain consists of positive integers
            if not IsPosInt(next) then
                Error(Concatenation(method, ": ", number,
                    "AdjacencyRelation should be an equivalence relation on positive integers, but its domain contains ",
                    String(next), "."));
            fi;

            # Check whether equivalence classes have the correct size
            if number = "Zero" or number = "One" then
                equiv := EquivalenceClassOfElementNC(rel, next);
                counter := Iterator(equiv);
                NextIterator(counter);
                if IsDoneIterator(counter) then
                    Error(Concatenation(method, ": ", number, 
                        "AdjacencyRelation should not have elements that are only related to themselves, but contains ",
                        String(next), "."));
                fi;
                NextIterator(counter);
                if not IsDoneIterator(counter) then
                    Error(Concatenation(method, ": ", number, 
                        "AdjacencyRelation should not have elements that are related to more than one other element, but contains ",
                        String(next), "."));
                fi;
            fi;
        od;
    end
);

BindGlobal( "__SIMPLICIAL_VerifyStarOfChambers",
    function(list, name, listname)
        local i, val;

        for i in [1..Length(list)] do
            if not IsBound(list[i]) then
                continue;
            fi;
            val := list[i];
            if not IsPosInt(val) then
                Error(Concatenation(name, ": The list ", listname, " should consist of positive integers, but the value at position ", String(i), " is ", String(val), "." ));
            fi;
        od;
    end
);

BindGlobal( "__SIMPLICIAL_ExtractChambersFromInvolution",
    function(perm)
        return MovedPoints(perm);
    end
);
BindGlobal( "__SIMPLICIAL_ExtractChambersFromRelation",
    function(rel)
        return Set(Source(rel));
    end
);
BindGlobal( "__SIMPLICIAL_ExtractChambersFromClasses",
    function(classes)
        return __SIMPLICIAL_UnionSets(classes);
    end
);
# Form for the list elements: [method, element, x, name].
# x=1: produce the chamber set
# x=0: produce a subset of the chambers
BindGlobal( "__SIMPLICIAL_ConstructorConsistencyChambers",
    function( list, name )
        local chamberData, i, j, dataA, dataB;

        chamberData := List(list, x -> [ x[1](x[2]), x[3], x[4] ]);

        for i in [1..Length(chamberData)] do
            for j in [i+1..Length(chamberData)] do
                dataA := chamberData[i];
                dataB := chamberData[j];
                if dataA[2] = 1 and dataB[2] = 1 then
                    # they have to be equal
                    if dataA[1] <> dataB[1] then
                        Error(Concatenation(name, ": Chamber data of ", 
                            dataA[3], " (", dataA[1], ") and ", 
                            dataB[3], " (", dataB[1], 
                            ") should be equal but are different."));
                    fi;
                elif dataA[2] = 1 and dataB[2] = 0 then
                    # dataB is subset of dataA
                    if not IsSubset(dataA[1],dataB[1]) then
                        Error(Concatenation(name, ": Chamber data of ", 
                            dataB[3], " (", dataB[1], ") should be a subset of ", 
                            dataA[3], " (", dataA[1], 
                            ")."));
                    fi;
                elif dataB[2] = 1 and dataA[2] = 0 then
                    # dataA is subset of dataB
                    if not IsSubset(dataB[1],dataA[1]) then
                        Error(Concatenation(name, ": Chamber data of ", 
                            dataA[3], " (", dataA[1], ") should be a subset of ", 
                            dataB[3], " (", dataB[1], 
                            ")."));
                    fi;
                fi;
            od;
        od;
    end
);


# Consistency checks
BindGlobal( "__SIMPLICIAL_ConstructorConsistencyAdjacency",
    function(complex, name)
        local c, a, cz, az;

        for c in Chambers(complex) do
            for a in TwoAdjacentChambersNC(complex, c) do
                cz := ZeroAdjacentChamberNC(complex, c);
                az := ZeroAdjacentChamberNC(complex, a);
                if not IsTwoAdjacentChambers(complex, cz, az) then
                    Error(Concatenation(name, ": The chambers ", String(c), 
                        " and ", String(a), 
                        " are 2-adjacent, but their 0-adjacent chambers ", 
                        String(cz), " and ", String(az), " are not 2-adjacent."));
                fi;
            od;
        od;
    end
);

BindGlobal( "__SIMPLICIAL_ConstructorConsistencyIncidence",
    function(complex, name)
        local c, cz, co, i, j, d, grp, tuple;

        grp := Group( [ ZeroAdjacencyInvolution(complex), OneAdjacencyInvolution(complex) ] );
        for i in [1..Length(Chambers(complex))] do
            c := Chambers(complex)[i];

            # 0-adjacency does not change edges and faces
            cz := ZeroAdjacentChamberNC(complex, c);
            if EdgeOfChamberNC(complex,c) <> EdgeOfChamberNC(complex, cz) then
                Error(Concatenation(name, ": The chambers ", String(c), 
                    " and ", String(cz), 
                    " are 0-adjacent, but have different edges (", 
                    String(EdgeOfChamberNC(complex,c)), " and ", 
                    String(EdgeOfChamberNC(complex, cz)), ")."));
            fi;
            if FaceOfChamberNC(complex,c) <> FaceOfChamberNC(complex, cz) then
                Error(Concatenation(name, ": The chambers ", String(c), 
                    " and ", String(cz), 
                    " are 0-adjacent, but have different faces (", 
                    String(FaceOfChamberNC(complex,c)), " and ", 
                    String(FaceOfChamberNC(complex, cz)), ")."));
            fi;

            # 1-adjacency does not change vertices and faces
            co := OneAdjacentChamberNC(complex, c);
            if VertexOfChamberNC(complex,c) <> VertexOfChamberNC(complex, co) then
                Error(Concatenation(name, ": The chambers ", String(c), 
                    " and ", String(co), 
                    " are 1-adjacent, but have different vertices (", 
                    String(VertexOfChamberNC(complex,c)), " and ", 
                    String(VertexOfChamberNC(complex, co)), ")."));
            fi;
            if FaceOfChamberNC(complex,c) <> FaceOfChamberNC(complex, co) then
                Error(Concatenation(name, ": The chambers ", String(c), 
                    " and ", String(co), 
                    " are 1-adjacent, but have different faces (", 
                    String(FaceOfChamberNC(complex,c)), " and ", 
                    String(FaceOfChamberNC(complex, co)), ")."));
            fi;

            for j in [i+1..Length(Chambers(complex))] do
                d := Chambers(complex)[j];

                # 2-adjacency does not change vertices and edges
                if IsTwoAdjacentChambersNC(complex, c,d) then
                    if VertexOfChamberNC(complex,c) <> VertexOfChamberNC(complex, d) then
                        Error(Concatenation(name, ": The chambers ", String(c), 
                            " and ", String(d), 
                            " are 2-adjacent, but have different vertices (", 
                            String(VertexOfChamberNC(complex,c)), " and ", 
                            String(VertexOfChamberNC(complex,d)), ")."));
                    fi;
                    if EdgeOfChamberNC(complex,c) <> EdgeOfChamberNC(complex,d) then
                        Error(Concatenation(name, ": The chambers ", String(c), 
                            " and ", String(d), 
                            " are 2-adjacent, but have different edges (", 
                            String(FaceOfChamberNC(complex,c)), " and ", 
                            String(FaceOfChamberNC(complex,d)), ")."));
                    fi;
                fi;

                # chambers with the same edge fulfill certain properties
                if EdgeOfChamberNC(complex, c) = EdgeOfChamberNC(complex, d) then
                    if not IsTwoAdjacentChambersNC(complex,c,d) and not IsZeroAdjacentChambersNC(complex,c,d)
                        and not IsTwoAdjacentChambersNC(complex, c, ZeroAdjacentChamberNC(complex,d)) then
                        Error(Concatenation(name, ": The chambers ", String(c),
                            " and ", String(d), 
                            " have the same edge, but are neither 0-adjacent, 2-adjacent nor is there another chamber that is 2-adjacent to one and 0-adjacent to the other."));
                    fi;
                fi;

                # chambers with the same face fulfill certain properties
                if FaceOfChamberNC(complex, c) = FaceOfChamberNC(complex, d) then
                    if not c in Orbit(grp, d) then
                        Error(Concatenation(name, ": The chambers ", String(c),
                            " and ", String(d), 
                            " have the same face, but are not in the same orbit with respect to the 0-adjacency involution and 1-adjacency involution."));
                    fi;
                fi;
            od;
        od;
    end
);


# Create vertices, edges, faces from chamber adjacencies
BindGlobal( "__SIMPLICIAL_VertexEdgeFaceFromChamberAdjacencies",
    function(complex)
        local zeroInv, oneInv, twoInv, chambersOfFaces,
            chambersOfEdges, chambersOfVertices, vertexEq,
            edgeEq, faceEq;

        twoInv := TwoAdjacencyInvolution(complex);
        if twoInv <> fail then
            zeroInv := ZeroAdjacencyInvolution(complex);
            oneInv := OneAdjacencyInvolution(complex);
            chambersOfVertices := Set( Orbits( Group([oneInv,twoInv]), Chambers(complex) ), Set);
            chambersOfEdges := Set( Orbits( Group([zeroInv, twoInv]), Chambers(complex) ), Set);
            chambersOfFaces := Set( Orbits( Group([zeroInv,oneInv]), Chambers(complex) ), Set);
        else
            vertexEq := JoinEquivalenceRelations( OneAdjacencyRelation(complex), TwoAdjacencyRelation(complex) );
            chambersOfVertices := Set( EquivalenceRelationPartition(vertexEq), Set );

            edgeEq := JoinEquivalenceRelations( ZeroAdjacencyRelation(complex), TwoAdjacencyRelation(complex) );
            chambersOfEdges := Set( EquivalenceRelationPartition(edgeEq), Set);

            faceEq := JoinEquivalenceRelations( ZeroAdjacencyRelation(complex), OneAdjacencyRelation(complex) );
            chambersOfFaces := Set( EquivalenceRelationPartition(faceEq), Set);
        fi;

        SetChambersOfVertices(complex, chambersOfVertices);
        SetChambersOfEdges(complex, chambersOfEdges);
        SetChambersOfFaces(complex, chambersOfFaces);
    end
);

InstallMethod( TwistedPolygonalSurfaceByChamberInvolutionsNC,
    "for three involutions", [IsPerm, IsPerm, IsPerm],
    function( zeroInv, oneInv, twoInv )
        local complex;

        complex := Objectify( TwistedPolygonalComplexType, rec() );
        SetZeroAdjacencyInvolution(complex, zeroInv);
        SetOneAdjacencyInvolution(complex, oneInv);
        SetTwoAdjacencyInvolution(complex, twoInv);

        __SIMPLICIAL_VertexEdgeFaceFromChamberAdjacencies(complex);
        SetIsNotEdgeRamified(complex, true);
        SetIsNotVertexRamified(complex, true);
        return complex;
    end
);
InstallMethod( TwistedPolygonalSurfaceByChamberInvolutions,
    "for three involutions", [IsPerm, IsPerm, IsPerm],
    function( zeroInv, oneInv, twoInv )
        local name, complex;

        name := "TwistedPolygonalSurfaceByChamberInvolutions";
        __SIMPLICIAL_VerifyAdjacencyInvolution(zeroInv, name, "Zero");
        __SIMPLICIAL_VerifyAdjacencyInvolution(oneInv, name, "One");
        __SIMPLICIAL_VerifyAdjacencyInvolution(twoInv, name, "Two");

        # Compare chambers
        __SIMPLICIAL_ConstructorConsistencyChambers([
            [__SIMPLICIAL_ExtractChambersFromInvolution, zeroInv, 1, "zeroAdjacency"],
            [__SIMPLICIAL_ExtractChambersFromInvolution, oneInv, 1, "oneAdjacency"],
            [__SIMPLICIAL_ExtractChambersFromInvolution, twoInv, 0, "twoAdjacency"]],name);

        complex := Objectify( TwistedPolygonalComplexType, rec() );
        SetZeroAdjacencyInvolution(complex, zeroInv);
        SetOneAdjacencyInvolution(complex, oneInv);
        SetTwoAdjacencyInvolution(complex, twoInv);
        __SIMPLICIAL_ConstructorConsistencyAdjacency(complex, name);

        __SIMPLICIAL_VertexEdgeFaceFromChamberAdjacencies(complex);
        SetIsNotEdgeRamified(complex, true);
        SetIsNotVertexRamified(complex, true);
        return complex;
    end
);

BindGlobal( "__SIMPLICIAL_TwistedTypeOptions",
    function()
        local typeOptions;

        typeOptions := []; # [name (as string), checkFct, setFct]
        Add(typeOptions, [ "TwistedPolygonalComplex", function(complex, name) end, function(complex) end ]);
        Add(typeOptions, [ "TwistedPolygonalSurface",
            function(complex, name)
                if not IsNotEdgeRamified(complex) then
                    Error(Concatenation(name, ": Constructed twisted polygonal complex is edge ramified."));
                fi;
                if not SetIsNotVertexRamified(complex) then
                    Error(Concatenation(name, ": Constructed twisted polygonal complex is vertex ramified."));
                fi;
            end,
            function(complex)
                SetIsNotEdgeRamified(complex, true);
                SetIsNotVertexRamified(complex, true);
            end]);
        return typeOptions;
    end
);
BindGlobal( "__SIMPLICIAL_TwistedArgOptions",
    function()
        local argOptions, tuple;

        argOptions := []; # [localTest, filter, string, verify, extract]
        Add(argOptions, ["an involution", IsPerm, "Involution"]);
        Add(argOptions, ["a list", IsList, "Classes"]);
        Add(argOptions, ["an equivalence relation", IsEquivalenceRelation, "Relation"]);
        for tuple in argOptions do
            # Complete the lists
            tuple[4] := ValueGlobal(Concatenation("__SIMPLICIAL_VerifyAdjacency", tuple[3]));
            tuple[5] := ValueGlobal(Concatenation("__SIMPLICIAL_ExtractChambersFrom", tuple[3]));
        od;
        return argOptions;
    end
);
BindGlobal( "__SIMPLICIAL_WriteTwistedConstructorRelation",
    function()
        local typeOptions, argOptions, primary, name, type, constName,
            constNameNC, first, second, third, installFct, description,
            filters, wrapper;

        typeOptions := __SIMPLICIAL_TwistedTypeOptions();
        argOptions := __SIMPLICIAL_TwistedArgOptions();
        primary := [IsList, IsList, IsList];

        name := "ByChamberRelations";
        for type in typeOptions do
            constName := Concatenation(type[1],name);
            constNameNC := Concatenation(constName, "NC");
            for first in argOptions do
                for second in argOptions do
                    for third in argOptions do
                        if [first[2],second[2],third[2]] = primary then
                            installFct := ValueGlobal("InstallMethod");
                        else
                            installFct := ValueGlobal("InstallOtherMethod");
                        fi;
                        description := Concatenation( "for three lists, ", first[1], ", ", second[1], ", and ", third[1] );
                        filters := [IsList,IsList,IsList];
                        Add(filters, first[2]);
                        Add(filters, second[2]);
                        Add(filters, third[2]);

                        wrapper := function(constNameNC, constName, description, filters, argOptions, type)
                            # NC-version
                            installFct( ValueGlobal(constNameNC), description, filters,
                                function(vOfC, eOfC, fOfC, zeroAd, oneAd, twoAd)
                                    local complex;

                                    complex := Objectify(TwistedPolygonalComplexType, rec());
                                    SetVerticesOfChambers(complex, vOfC);
                                    SetEdgesOfChambers(complex, eOfC);
                                    SetFacesOfChambers(complex, fOfC);
                                    ValueGlobal( Concatenation( "SetZeroAdjacency", argOptions[1][3]) )(complex, zeroAd);
                                    ValueGlobal( Concatenation( "SetOneAdjacency", argOptions[2][3]) )(complex, oneAd);
                                    ValueGlobal( Concatenation( "SetTwoAdjacency", argOptions[3][3]) )(complex, twoAd);

                                    type[3](complex);
                                    return complex;
                                end
                            );
                            # normal version
                            installFct( ValueGlobal(constName), description, filters,
                                function(vOfC, eOfC, fOfC, zeroAd, oneAd, twoAd)
                                    local complex;

                                    # Verify input validity
                                    __SIMPLICIAL_VerifyStarOfChambers(vOfC, constName, "verticesOfChambers");
                                    __SIMPLICIAL_VerifyStarOfChambers(eOfC, constName, "edgesOfChambers");
                                    __SIMPLICIAL_VerifyStarOfChambers(fOfC, constName, "facesOfChambers");
                                    argOptions[1][4](zeroAd, constName, "Zero");
                                    argOptions[2][4](oneAd, constName, "One");
                                    argOptions[3][4](twoAd, constName, "Two");

                                    # Verify chamber information
                                    __SIMPLICIAL_ConstructorConsistencyChambers([
                                        [PositionsBound, vOfC, 1, "verticesOfChambers"],
                                        [PositionsBound, eOfC, 1, "edgesOfChambers"],
                                        [PositionsBound, fOfC, 1, "facesOfChambers"],
                                        [argOptions[1][5], zeroAd, 1, "zeroAdjacency"],
                                        [argOptions[2][5], oneAd, 1, "zeroAdjacency"],
                                        [argOptions[3][5], twoAd, 1, "zeroAdjacency"]], constName);

                                    # Create the complex
                                    complex := Objectify(TwistedPolygonalComplexType, rec());
                                    SetVerticesOfChambers(complex, vOfC);
                                    SetEdgesOfChambers(complex, eOfC);
                                    SetFacesOfChambers(complex, fOfC);
                                    ValueGlobal( Concatenation( "SetZeroAdjacency", argOptions[1][3]) )(complex, zeroAd);
                                    ValueGlobal( Concatenation( "SetOneAdjacency", argOptions[2][3]) )(complex, oneAd);
                                    ValueGlobal( Concatenation( "SetTwoAdjacency", argOptions[3][3]) )(complex, twoAd);

                                    # Test consistency
                                    __SIMPLICIAL_ConstructorConsistencyAdjacency(complex, constName);
                                    __SIMPLICIAL_ConstructorConsistencyIncidence(complex, constName);
                                    type[2](complex, constName);

                                    return complex;
                                end
                            );
                        end;
                        wrapper(constNameNC, constName, description, filters, [first,second,third], type);
                    od;
                od;
            od;
        od;
    end
);
__SIMPLICIAL_WriteTwistedConstructorRelation();

BindGlobal( "__SIMPLICIAL_WriteTwistedConstructorAdjacencies",
    function()
        local typeOptions, argOptions, primary, name, type,
            constName, constNameNC, first, second, third, 
            description, filters, wrapper, installFct;

        typeOptions := __SIMPLICIAL_TwistedTypeOptions();
        argOptions := __SIMPLICIAL_TwistedArgOptions();
        primary := [IsList, IsList, IsList];

        name := "ByChamberAdjacencies";
        for type in typeOptions do
            constName := Concatenation(type[1],name);
            constNameNC := Concatenation(constName, "NC");
            for first in argOptions do
                for second in argOptions do
                    for third in argOptions do
                        if [first[2],second[2],third[2]] = primary then
                            installFct := ValueGlobal("InstallMethod");
                        else
                            installFct := ValueGlobal("InstallOtherMethod");
                        fi;
                        description := Concatenation( "for ", first[1], ", ", second[1], ", and ", third[1] );
                        filters := [first[2],second[2],third[2]];

                        wrapper := function(constNameNC, constName, description, filters, argOptions, type)
                            # NC-version
                            installFct( ValueGlobal(constNameNC), description, filters,
                                function(zeroAd, oneAd, twoAd)
                                    local complex;

                                    complex := Objectify(TwistedPolygonalComplexType, rec());
                                    ValueGlobal( Concatenation( "SetZeroAdjacency", argOptions[1][3]) )(complex, zeroAd);
                                    ValueGlobal( Concatenation( "SetOneAdjacency", argOptions[2][3]) )(complex, oneAd);
                                    ValueGlobal( Concatenation( "SetTwoAdjacency", argOptions[3][3]) )(complex, twoAd);

                                    __SIMPLICIAL_VertexEdgeFaceFromChamberAdjacencies(complex);
                                    type[3](complex);
                                    return complex;
                                end
                            );
                            # normal version
                            installFct( ValueGlobal(constName), description, filters,
                                function(zeroAd, oneAd, twoAd)
                                    local complex;

                                    # Verify input validity
                                    argOptions[1][4](zeroAd, constName, "Zero");
                                    argOptions[2][4](oneAd, constName, "One");
                                    argOptions[3][4](twoAd, constName, "Two");

                                    # Verify chamber information
                                    __SIMPLICIAL_ConstructorConsistencyChambers([
                                        [argOptions[1][5], zeroAd, 1, "zeroAdjacency"],
                                        [argOptions[2][5], oneAd, 1, "zeroAdjacency"],
                                        [argOptions[3][5], twoAd, 1, "zeroAdjacency"]], constName);

                                    # Create the complex
                                    complex := Objectify(TwistedPolygonalComplexType, rec());
                                    ValueGlobal( Concatenation( "SetZeroAdjacency", argOptions[1][3]) )(complex, zeroAd);
                                    ValueGlobal( Concatenation( "SetOneAdjacency", argOptions[2][3]) )(complex, oneAd);
                                    ValueGlobal( Concatenation( "SetTwoAdjacency", argOptions[3][3]) )(complex, twoAd);

                                    # Test consistency
                                    __SIMPLICIAL_ConstructorConsistencyAdjacency(complex, constName);
                                    __SIMPLICIAL_VertexEdgeFaceFromChamberAdjacencies(complex);
                                    type[2](complex,constName);

                                    return complex;
                                end
                            );
                        end;
                        wrapper(constNameNC, constName, description, filters, [first,second,third], type);
                    od;
                od;
            od;
        od;
    end
);
__SIMPLICIAL_WriteTwistedConstructorAdjacencies();


##
##          End of constructors
##
##############################################################################


##############################################################################
##
##      Relation to polygonal complexes
##
__SIMPLICIAL_AddTwistedAttribute(IsDefaultChamberSystem);

InstallMethod( IsDefaultChamberSystem, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        if not IsPolygonalComplex(complex) then
            return false;
        fi;

        TryNextMethod();
    end
);
InstallMethod( IsDefaultChamberSystem, 
    "for a polygonal complex with flags, verticesOfChambers, edgesOfChambers, facesOfChambers, and chambers",
    [IsTwistedPolygonalComplex and HasFlags and HasVerticesOfChambers and HasEdgesOfChambers and HasFacesOfChambers and HasChambers],
    function(complex)
        local flags, vOfC, eOfC, fOfC, k;

        flags := Flags(complex);
        vOfC := VerticesOfChambers(complex);
        eOfC := EdgesOfChambers(complex);
        fOfC := FacesOfChambers(complex);

        for k in [1..Length(flags)] do
            if not k in Chambers(complex) then
                return false;
            fi;
            if vOfC[k] <> flags[k][1] then
                return false;
            fi;
            if eOfC[k] <> flags[k][2] then
                return false;
            fi;
            if fOfC[k] <> flags[k][3] then
                return false;
            fi;
        od;
        return true;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "IsDefaultChamberSystem",
    ["Flags", "VerticesOfChambers", "EdgesOfChambers", "FacesOfChambers", "Chambers"],
    ["IsPolygonalComplex"]);


InstallMethod( Chambers, 
    "for a twisted polygonal complex with default chamber system and flags", 
    [IsTwistedPolygonalComplex and IsDefaultChamberSystem and HasFlags],
    function(complex)
        return [1..Length(Flags(complex))];
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "Chambers",["Flags"], ["IsDefaultChamberSystem"] );
InstallMethod( VerticesOfChambers,
    "for a twisted polygonal complex with default chamber system and flags", 
    [IsTwistedPolygonalComplex and IsDefaultChamberSystem and HasFlags],
    function(complex)
        return List( Flags(complex), f -> f[1] );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "VerticesOfChambers",["Flags"], ["IsDefaultChamberSystem"] );
InstallMethod( EdgesOfChambers,
    "for a twisted polygonal complex with default chamber system and flags", 
    [IsTwistedPolygonalComplex and IsDefaultChamberSystem and HasFlags],
    function(complex)
        return List( Flags(complex), f -> f[2] );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "EdgesOfChambers",["Flags"], ["IsDefaultChamberSystem"] );
InstallMethod( FacesOfChambers,
    "for a twisted polygonal complex with default chamber system and flags", 
    [IsTwistedPolygonalComplex and IsDefaultChamberSystem and HasFlags],
    function(complex)
        return List( Flags(complex), f -> f[3] );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "FacesOfChambers",["Flags"], ["IsDefaultChamberSystem"] );

BindGlobal( "__SIMPLICIAL_FlagAdjacencyClasses",
    function(complex, x,y)
        local classes, flags, remain, min, class, k;

        classes := [];
        flags := Flags(complex);
        remain := [1..Length(flags)];
        while not IsEmpty(remain) do
            min := remain[1];
            class := [];
            for k in remain do
                if flags[min][x] = flags[k][x] and flags[min][y] = flags[k][y] then
                    Add(class,k);
                fi;
            od;
            Add(classes,class);
            remain := Difference(remain, class);
        od;

        return classes;
    end
);
InstallMethod( ZeroAdjacencyClasses,
    "for a twisted polygonal complex with default chamber system and flags", 
    [IsTwistedPolygonalComplex and IsDefaultChamberSystem and HasFlags],
    function(complex)
        return __SIMPLICIAL_FlagAdjacencyClasses(complex,2,3);
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "ZeroAdjacencyClasses",["Flags"], ["IsDefaultChamberSystem"] );
InstallMethod( OneAdjacencyClasses,
    "for a twisted polygonal complex with default chamber system and flags", 
    [IsTwistedPolygonalComplex and IsDefaultChamberSystem and HasFlags],
    function(complex)
        return __SIMPLICIAL_FlagAdjacencyClasses(complex,1,3);
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "OneAdjacencyClasses",["Flags"], ["IsDefaultChamberSystem"] );
InstallMethod( TwoAdjacencyClasses,
    "for a twisted polygonal complex with default chamber system and flags", 
    [IsTwistedPolygonalComplex and IsDefaultChamberSystem and HasFlags],
    function(complex)
        return __SIMPLICIAL_FlagAdjacencyClasses(complex,2,1);
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "TwoAdjacencyClasses",["Flags"], ["IsDefaultChamberSystem"] );



InstallMethod( IsPolygonalComplex, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        local f, chamb, verts, edges;

        for f in Faces(complex) do
            chamb := ChambersOfFaces(complex)[f];
            verts := Set( VerticesOfChambers(complex){chamb} );
            if 2*Length(verts) <> Length(chamb) then
                return false;
            fi;
            edges := Set( EdgesOfChambers(complex){chamb} );
            if 2*Length(edges) <> Length(chamb) then
                return false;
            fi;
        od;
        return true;
    end
);

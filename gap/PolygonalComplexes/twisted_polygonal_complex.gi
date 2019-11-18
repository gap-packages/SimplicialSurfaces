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
        return ChambersOfVertex(complex)[vertex];
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
InstallMethod(EdgesOfChamberNC, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, chamber)
        return EdgesOfChambers(complex)[chamber];
    end
);
InstallMethod(EdgesOfChamber,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, chamber)
        __SIMPLICIAL_CheckChamber( complex, chamber, "EdgesOfChamber" );
        return EdgesOfChamberNC(complex,chamber);
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
InstallMethod(FacesOfChamberNC, 
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, chamber)
        return FacesOfChambers(complex)[chamber];
    end
);
InstallMethod(FacesOfChamber,
    "for a twisted polygonal complex and a positive integer",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, chamber)
        __SIMPLICIAL_CheckChamber( complex, chamber, "FacesOfChamber" );
        return FacesOfChamberNC(complex,chamber);
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



## from Relation to Classes
InstallMethod( ZeroAdjacencyClasses, 
    "for a twisted polygonal complex with ZeroAdjacencyRelation",
    [IsTwistedPolygonalComplex and HasZeroAdjacencyRelation],
    function(complex)
        return EquivalenceRelationPartition( ZeroAdjacencyRelation(complex) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "ZeroAdjacencyClasses", ["ZeroAdjacencyRelation"] );
InstallMethod( OneAdjacencyClasses, 
    "for a twisted polygonal complex with OneAdjacencyRelation",
    [IsTwistedPolygonalComplex and HasOneAdjacencyRelation],
    function(complex)
        return EquivalenceRelationPartition( OneAdjacencyRelation(complex) );
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
        classes := EquivalenceRelationPartition(rel);
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
    "for a twisted polygonal complex with ZeroAdjacencyInvolution",
    [IsTwistedPolygonalComplex and HasZeroAdjacencyInvolution],
    function(complex)
        return Cycles( ZeroAdjacencyInvolution(complex) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "ZeroAdjacencyClasses", ["ZeroAdjacencyInvolution"] );
InstallMethod( OneAdjacencyClasses, 
    "for a twisted polygonal complex with OneAdjacencyInvolution",
    [IsTwistedPolygonalComplex and HasOneAdjacencyInvolution],
    function(complex)
        return Cycles( OneAdjacencyInvolution(complex) );
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "OneAdjacencyClasses", ["OneAdjacencyInvolution"] );
InstallMethod( TwoAdjacencyClasses, 
    "for a twisted polygonal complex without edge ramifications with TwoAdjacencyInvolution and Chambers",
    [IsTwistedPolygonalComplex and IsNotEdgeRamified and HasTwoAdjacencyInvolution and HasChambers],
    function(complex)
        local classes, el;

        classes := Cycles(TwoAdjacencyInvolution(complex));
        # This call is insufficient since there might be fixed points

        for el in Chambers(complex) do
            if el^TwoAdjacencyInvolution(complex) = el then
                Add(classes, [el]);
            fi;
        od;
        Sort(classes);
        return classes;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "TwoAdjacencyClasses", ["TwoAdjacencyInvolution", "Chambers"], ["IsNotEdgeRamified"] );


## from Classes to Involution
InstallMethod( ZeroAdjacencyInvolution,
    "for a twisted polygonal complex with ZeroAdjacencyClasses and Chambers",
    [IsTwistedPolygonalComplex and HasZeroAdjacencyClasses and Chambers],
    function(complex)
        local list, cl, maxChamber;

        maxChamber := Maximum(Chambers(complex));
        list := [1..maxChamber];
        for cl in ZeroAdjacencyClasses(complex) do
            list[cl[1]] := cl[2];
            list[cl[2]] := cl[1];
        do;
        return PermList(list);
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "ZeroAdjacencyInvolution", ["ZeroAdjacencyClasses", "Chambers"] );

InstallMethod( OneAdjacencyInvolution,
    "for a twisted polygonal complex with OneAdjacencyClasses and Chambers",
    [IsTwistedPolygonalComplex and HasOneAdjacencyClasses and Chambers],
    function(complex)
        local list, cl, maxChamber;

        maxChamber := Maximum(Chambers(complex));
        list := [1..maxChamber];
        for cl in OneAdjacencyClasses(complex) do
            list[cl[1]] := cl[2];
            list[cl[2]] := cl[1];
        do;
        return PermList(list);
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "OneAdjacencyInvolution", ["OneAdjacencyClasses", "Chambers"] );

InstallMethod( TwoAdjacencyInvolution,
    "for a twisted polygonal complex with TwoAdjacencyClasses and Chambers",
    [IsTwistedPolygonalComplex and HasTwoAdjacencyClasses and Chambers],
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
        do;
        return PermList(list);
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, "TwoAdjacencyInvolution", ["TwoAdjacencyClasses", "Chambers"] );


##
##          End of methods for adjacency
##
##############################################################################



##############################################################################
##
##          Start of constructors
##

##
##          End of constructors
##
##############################################################################

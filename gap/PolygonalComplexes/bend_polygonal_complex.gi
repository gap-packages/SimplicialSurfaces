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


BindGlobal( "__SIMPLICIAL_ComputeLocalFlags", 
    function( faces, sizesOfFaces )
        local res, f, i, max;

        res := [];
        for f in faces do
            max := sizesOfFaces[f]; 
            for i in [1..max do
                if i = 1 then
                    Add(res, [i,max]);
                else
                    Add(res, [i,i-1]);
                fi;

                if i = max then
                    Add(res, [i,1]);
                else
                    Add(res, [i,i+1]);
                fi;
            od;
        od;

        return res;
    end
);


#######################################
##
##  Interaction between local flags and global vertices/edges/faces
##

BindGlobal( "__SIMPLICIAL_PartitionFromEquivalenceNumber",
    function( numberOfElements )
        local partitionOfNumber, i;

        partitionOfNumber := [];
        for i in [1..Length(numberOfElements)] do
            if IsBound( numberOfElements[i] ) then
                if IsBound( partitionOfNumber[numberOfElements[i]] ) then
                    Add(partitionOfNumber[numberOfElements[i]], i);
                else
                    partitionOfNumber[numberOfElements[i]] := [i];
                fi;
            fi;
        od;

        return partitionOfNumber;
    end
);

InstallMethod( LocalFlagsOfGlobalVertices, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(bendComplex)
        return __SIMPLICIAL_PartitionFromEquivalenceNumber( 
            GlobalVerticesOfLocalFlags(bendComplex) );
    end
);

InstallMethod( LocalFlagsOfGlobalEdges, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(bendComplex)
        return __SIMPLICIAL_PartitionFromEquivalenceNumber( 
            GlobalEdgesOfLocalFlags(bendComplex) );
    end
);

InstallMethod( LocalFlagsOfGlobalFaces, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(bendComplex)
        return __SIMPLICIAL_PartitionFromEquivalenceNumber( 
            GlobalFacesOfLocalFlags(bendComplex) );
    end
);


BindGlobal( "__SIMPLICIAL_EquivalenceNumberFromPartition",
    function( partitionOfNumber )
        local numberOfElements, i, el;

        numberOfElements := [];
        for i in [1..Length(partitionOfNumber)] do
            if IsBound( partitionOfNumber[i] ) then
                for el in partitionOfNumber[i] do
                    numberOfElements[el] := i;
                od;
            fi;
        od;

        return numberOfElements;
    end
);

InstallMethod( GlobalVerticesOfLocalFlags, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(bendComplex)
        return __SIMPLICIAL_EquivalenceNumberFromPartition( 
            LocalFlagsOfGlobalVertices(bendComplex) );
    end
);

InstallMethod( GlobalEdgesOfLocalFlags, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(bendComplex)
        return __SIMPLICIAL_EquivalenceNumberFromPartition( 
            LocalFlagsOfGlobalEdges(bendComplex) );
    end
);

InstallMethod( GlobalFacesOfLocalFlags, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(bendComplex)
        return __SIMPLICIAL_EquivalenceNumberFromPartition( 
            LocalFlagsOfGlobalFaces(bendComplex) );
    end
);



#######################################
##
##  Interaction between local flag partitions and involution
##

BindGlobal("__SIMPLICIAL_InvolutionFromPartition",
    function(partition)
        local inv, pair;

        inv := ();
        for pair in partition do
            if Length(pair) = 2 then
                inv := inv * (pair[1],pair[2]);
            elif Length(pair) > 2 then
                return fail;
            fi;
        od;
        return inv;
    end
);

InstallMethod( LocalFlagVertexInvolution, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(bendComplex)
        return __SIMPLICIAL_InvolutionFromPartition(
            LocalFlagVertexPartition(bendComplex) );
    end
);
InstallMethod( LocalFlagEdgeInvolution, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(bendComplex)
        return __SIMPLICIAL_InvolutionFromPartition(
            LocalFlagEdgePartition(bendComplex) );
    end
);
InstallMethod( LocalFlagFaceInvolution, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(bendComplex)
        return __SIMPLICIAL_InvolutionFromPartition(
            LocalFlagFacePartition(bendComplex) );
    end
);


InstallMethod( LocalFlagVertexPartition, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(bendComplex)
        return Cycles( LocalFlagVertexInvolution(bendComplex),
            [1..Length(LocalFlags(bendComplex))]);
    end
);
InstallMethod( LocalFlagEdgePartition, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(bendComplex)
        return Cycles( LocalFlagEdgeInvolution(bendComplex),
            [1..Length(LocalFlags(bendComplex))]);
    end
);
InstallMethod( LocalFlagFacePartition, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(bendComplex)
        if LocalFlagFaceInvolution(bendComplex) = fail then
            TryNextMethod();
        else
            return Cycles( LocalFlagFaceInvolution(bendComplex),
                [1..Length(LocalFlags(bendComplex))]);
        fi;
    end
);

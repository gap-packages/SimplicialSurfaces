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
            for i in [1..max] do
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

InstallMethod( LocalFlagsOfVertices, "for a bend polygonal complex",
    [IsBendPolygonalComplex and HasVerticesOfLocalFlags],
    function(bendComplex)
        return __SIMPLICIAL_PartitionFromEquivalenceNumber( 
            VerticesOfLocalFlags(bendComplex) );
    end
);

InstallMethod( LocalFlagsOfEdges, "for a bend polygonal complex",
    [IsBendPolygonalComplex and HasEdgesOfLocalFlags],
    function(bendComplex)
        return __SIMPLICIAL_PartitionFromEquivalenceNumber( 
            EdgesOfLocalFlags(bendComplex) );
    end
);

InstallMethod( LocalFlagsOfFaces, "for a bend polygonal complex",
    [IsBendPolygonalComplex and HasFacesOfLocalFlags],
    function(bendComplex)
        return __SIMPLICIAL_PartitionFromEquivalenceNumber( 
            FacesOfLocalFlags(bendComplex) );
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

InstallMethod( VerticesOfLocalFlags, "for a bend polygonal complex",
    [IsBendPolygonalComplex and HasLocalFlagsOfVertices],
    function(bendComplex)
        return __SIMPLICIAL_EquivalenceNumberFromPartition( 
            LocalFlagsOfVertices(bendComplex) );
    end
);

InstallMethod( EdgesOfLocalFlags, "for a bend polygonal complex",
    [IsBendPolygonalComplex and HasLocalFlagsOfEdges],
    function(bendComplex)
        return __SIMPLICIAL_EquivalenceNumberFromPartition( 
            LocalFlagsOfEdges(bendComplex) );
    end
);

InstallMethod( FacesOfLocalFlags, "for a bend polygonal complex",
    [IsBendPolygonalComplex and HasLocalFlagsOfFaces],
    function(bendComplex)
        return __SIMPLICIAL_EquivalenceNumberFromPartition( 
            LocalFlagsOfFaces(bendComplex) );
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
    [IsBendPolygonalComplex and HasLocalFlagVertexPartition],
    function(bendComplex)
        return __SIMPLICIAL_InvolutionFromPartition(
            LocalFlagVertexPartition(bendComplex) );
    end
);
InstallMethod( LocalFlagEdgeInvolution, "for a bend polygonal complex",
    [IsBendPolygonalComplex and HasLocalFlagEdgePartition],
    function(bendComplex)
        return __SIMPLICIAL_InvolutionFromPartition(
            LocalFlagEdgePartition(bendComplex) );
    end
);
InstallMethod( LocalFlagFaceInvolution, "for a bend polygonal complex",
    [IsBendPolygonalComplex and HasLocalFlagFacePartition],
    function(bendComplex)
        return __SIMPLICIAL_InvolutionFromPartition(
            LocalFlagFacePartition(bendComplex) );
    end
);


InstallMethod( LocalFlagVertexPartition, "for a bend polygonal complex",
    [IsBendPolygonalComplex and HasLocalFlagVertexInvolution],
    function(bendComplex)
        return Cycles( LocalFlagVertexInvolution(bendComplex),
            LocalFlags(bendComplex));
    end
);
InstallMethod( LocalFlagEdgePartition, "for a bend polygonal complex",
    [IsBendPolygonalComplex and HasLocalFlagEdgeInvolution],
    function(bendComplex)
        return Cycles( LocalFlagEdgeInvolution(bendComplex),
            LocalFlags(bendComplex));
    end
);
InstallMethod( LocalFlagFacePartition, "for a bend polygonal complex",
    [IsBendPolygonalComplex and HasLocalFlagFaceInvolution],
    function(bendComplex)
        if LocalFlagFaceInvolution(bendComplex) = fail then
            TryNextMethod();
        else
            return Cycles( LocalFlagFaceInvolution(bendComplex),
                LocalFlags(bendComplex));
        fi;
    end
);


#TODO compute incidence information from flags in attribute scheduler
InstallMethod( BendPolygonalComplexBySignedFacePerimeters,
    "for a list of signed face perimeters", [IsList],
    function(signedFacePerimeter)
        local currLength, vertexMap, edgeMap, edgeSignMap, faceMap,
            vertexPart, edgePart, facePart, edgeOfFace, vertexOfEdge,
            i, size, perimeter, edges, f, edge, verts, found, p, complex;

        currLength := 0;

        vertexMap := [];
        edgeMap := [];
        edgeSignMap := [];
        faceMap := [];

        vertexPart := [];
        edgePart := [];
        facePart := [];

        edgeOfFace := [];
        vertexOfEdge := [];
        for i in [1..Length(signedFacePerimeter)] do
            if IsBound(signedFacePerimeter[i]) then
                size := Length(signedFacePerimeter[i]);
                # new flags: currLength+1,...,currLength+size
                perimeter := signedFacePerimeter[i];
                Add(perimeter, perimeter[1]);

                edges := [];

                for f in [1..size] do
                    if IsEvenInt(f) then
                        vertexMap[currLength+f] := perimeter[f+1];
                        edgeMap[currLength+f] := AbsoluteValue(perimeter[f]);
                        edgeSignMap[currLength+f] := SignInt(perimeter[f]);
                        if f = size then
                            Add(edgePart, [currLength+1, currLength+size]);
                        else
                            Add(edgePart, [currLength+f, currLength+f+1]);
                        fi;
                    else
                        vertexMap[currLength+f] := perimeter[f];
                        edge := AbsoluteValue(perimeter[f+1]);
                        edgeMap[currLength+f] := edge;
                        edgeSignMap[currLength+f] := SignInt(perimeter[f+1])*(-1);
                        Add(vertexPart, [currLength+f, currLength+f+1]);

                        Add(edges, edge);
                        verts := Set([perimeter[f],perimeter[f+2]]);
                        if IsBound(vertexOfEdge[edge]) then
                            if vertexOfEdge[edge] <> verts then
                                Error("Inconsistent data");
                            fi;
                        else
                            vertexOfEdge[edge] := verts;
                        fi;
                    fi;
                    faceMap[currLength+f] := i;
                od;

                edgeOfFace[i] := Set(edges);
                currLength := currLength + size;
            fi;
        od;

        # Generate the face partition
        for i in [1..currLength] do
            found := false;
            for p in facePart do
                if edgeMap[i] = edgeMap[p[1]] and edgeSignMap[i] = edgeSignMap[p[1]] then
                    found := true;
                    Add(p,i);
                fi;
            od;
            if not found then
                Add(facePart, [i]);
            fi;
        od;


        complex := Objectify(BendPolygonalComplexType, rec());
        SetVerticesOfEdges(complex, vertexOfEdge);
        SetEdgesOfFaces(complex, edgeOfFace);
        SetVerticesOfLocalFlags(complex, vertexMap);
        SetEdgesOfLocalFlags(complex, edgeMap);
        SetFacesOfLocalFlags(complex, faceMap);
        SetLocalFlagVertexPartition(complex, vertexPart);
        SetLocalFlagEdgePartition(complex, edgePart);
        SetLocalFlagFacePartition(complex, facePart);
        return complex;
    end
);

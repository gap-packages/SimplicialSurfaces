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

# This makes the incidence relations easier to implement
# (as they are all symmetrical)

BindGlobal( "__SIMPLICIAL_OneToManyBendIncidenceRelations",
    function( set_many, set_one, many_of_one, one_of_many )
        local attr_one, attr_many, attr_oneOfMany, attr_manyOfOne,
            genString;

        genString := "for a bend polygonal complex with ";

        # Compute the actual attributes
        attr_one := VALUE_GLOBAL(set_one);
        attr_many := VALUE_GLOBAL(set_many);
        attr_oneOfMany := VALUE_GLOBAL(one_of_many);
        attr_manyOfOne := VALUE_GLOBAL(many_of_one);

        # Add all properties to the attribute scheduler
        # Exception: set_one (since it would be added several times)
        __SIMPLICIAL_AddBendPolygonalAttribute( attr_oneOfMany );
        __SIMPLICIAL_AddBendPolygonalAttribute( attr_manyOfOne );

        # Implement the inversion functions
        InstallMethod( attr_oneOfMany,
            Concatenation(genString, many_of_one ),
            [IsBendPolygonalComplex and Tester( attr_manyOfOne )],
            function(bendComplex)
                return __SIMPLICIAL_EquivalenceNumberFromPartition(
                    attr_manyOfOne(bendComplex) );
            end
        );
        AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
            one_of_many, many_of_one);

        InstallMethod( attr_manyOfOne,
            Concatenation(genString, one_of_many ),
            [IsBendPolygonalComplex and Tester( attr_oneOfMany )],
            function(bendComplex)
                return __SIMPLICIAL_PartitionFromEquivalenceNumber(
                    attr_oneOfMany(bendComplex) );
            end
        );
        AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
            many_of_one, one_of_many );

        # Implement inferences to set_many and set_one
        InstallMethod( attr_one,
            Concatenation(genString, one_of_many),
            [IsBendPolygonalComplex and Tester( attr_oneOfMany )],
            function(bendComplex)
                return Set( attr_oneOfMany(bendComplex) );
            end
        );
        AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
            set_one, one_of_many);

        InstallMethod( attr_many,
            Concatenation(genString, many_of_one),
            [IsBendPolygonalComplex and Tester( attr_manyOfOne )],
            function(bendComplex)
                return __SIMPLICIAL_UnionSets( attr_manyOfOne(bendComplex) );
            end
        );
        AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
            set_many, many_of_one);

        InstallMethod( attr_many,
            Concatenation(genString, one_of_many),
            [IsBendPolygonalComplex and Tester( attr_oneOfMany )],
            function(bendComplex)
                return __SIMPLICIAL_BoundPositions( attr_oneOfMany(bendComplex) );
            end
        );
        AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
            set_many, one_of_many);

        InstallMethod( attr_one,
            Concatenation(genString, many_of_one),
            [IsBendPolygonalComplex and Tester( attr_manyOfOne )],
            function(bendComplex)
                __SIMPLICIAL_BoundPositions( attr_manyOfOne(bendComplex) );
            end
        );
        AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
            set_one, many_of_one);
    end
);

__SIMPLICIAL_AddBendPolygonalAttribute( LocalFlags );
__SIMPLICIAL_OneToManyBendIncidenceRelations( "LocalFlags", 
    "VerticesAttributeOfVEFComplex", "LocalFlagsOfVertices", 
    "VerticesOfLocalFlags" );
__SIMPLICIAL_OneToManyBendIncidenceRelations( "LocalFlags", 
    "Edges", "LocalFlagsOfEdges", 
    "EdgesOfLocalFlags" );
__SIMPLICIAL_OneToManyBendIncidenceRelations( "LocalFlags", 
    "Faces", "LocalFlagsOfFaces", 
    "FacesOfLocalFlags" );





#######################################
##
##  Interaction between local flag partitions and involution
##

__SIMPLICIAL_AddBendPolygonalAttribute( LocalVertices );
__SIMPLICIAL_AddBendPolygonalAttribute( LocalEdges );
__SIMPLICIAL_AddBendPolygonalAttribute( HalfEdges );


__SIMPLICIAL_OneToManyBendIncidenceRelations( "LocalFlags", 
    "LocalVertices", "LocalFlagsOfLocalVertices", 
    "LocalVerticesOfLocalFlags" );
__SIMPLICIAL_OneToManyBendIncidenceRelations( "LocalFlags", 
    "LocalEdges", "LocalFlagsOfLocalEdges", 
    "LocalEdgesOfLocalFlags" );
__SIMPLICIAL_OneToManyBendIncidenceRelations( "LocalFlags", 
    "HalfEdges", "LocalFlagsOfHalfEdges", 
    "HalfEdgesOfLocalFlags" );


BindGlobal( "__SIMPLICIAL_ManyToManyBendIncidenceRelations",
    function( set_A, set_B, A_of_B, B_of_A )
        local attr_A, attr_B, attr_AofB, attr_BofA,
            genString;

        genString := "for a bend polygonal complex with ";

        # Compute the actual attributes
        attr_A := VALUE_GLOBAL(set_A);
        attr_B := VALUE_GLOBAL(set_B);
        attr_AofB := VALUE_GLOBAL(A_of_B);
        attr_BofA := VALUE_GLOBAL(B_of_A);

        # Add all properties to the attribute scheduler
        # Exception: set_one (since it would be added several times)
        __SIMPLICIAL_AddBendPolygonalAttribute( attr_AofB );
        __SIMPLICIAL_AddBendPolygonalAttribute( attr_BofA );

        # Implement the inversion functions
        InstallMethod( attr_AofB,
            Concatenation(genString, B_of_A ),
            [IsBendPolygonalComplex and Tester( attr_BofA )],
            function(bendComplex)
                return __SIMPLICIAL_InvertIncidence(
                    attr_B(bendComplex), attr_BofA(bendComplex), attr_A(bendComplex));
            end
        );
        AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
            A_of_B, B_of_A);

        InstallMethod( attr_BofA,
            Concatenation(genString, A_of_B ),
            [IsBendPolygonalComplex and Tester( attr_AofB )],
            function(bendComplex)
                return __SIMPLICIAL_InvertIncidence(
                    attr_A(bendComplex), attr_AofB(bendComplex), attr_B(bendComplex));
            end
        );
        AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
            B_of_A, A_of_B);

        # Implement inferences to set_many and set_one
        InstallMethod( attr_A,
            Concatenation(genString,A_of_B),
            [IsBendPolygonalComplex and Tester( attr_AofB )],
            function(bendComplex)
                return __SIMPLICIAL_UnionSets( attr_AofB(bendComplex) );
            end
        );
        AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
            set_A, A_of_B);
        InstallMethod( attr_B,
            Concatenation(genString,B_of_A),
            [IsBendPolygonalComplex and Tester( attr_BofA )],
            function(bendComplex)
                return __SIMPLICIAL_UnionSets( attr_BofA(bendComplex) );
            end
        );
        AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
            set_B, B_of_A);

        InstallMethod( attr_A,
            Concatenation(genString, B_of_A),
            [IsBendPolygonalComplex and Tester( attr_BofA )],
            function(bendComplex)
                return __SIMPLICIAL_BoundPositions( attr_BofA(bendComplex) );
            end
        );
        AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
            set_A, B_of_A);
        InstallMethod( attr_B,
            Concatenation(genString, A_of_B),
            [IsBendPolygonalComplex and Tester( attr_AofB )],
            function(bendComplex)
                return __SIMPLICIAL_BoundPositions( attr_AofB(bendComplex) );
            end
        );
        AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
            set_B, A_of_B);
    end
);

__SIMPLICIAL_ManyToManyBendIncidenceRelations(
    "LocalVertices", "Faces", "LocalVerticesOfFaces", "FacesOfLocalVertices");
__SIMPLICIAL_ManyToManyBendIncidenceRelations(
    "LocalEdges", "Faces", "LocalEdgesOfFaces", "FacesOfLocalEdges");
__SIMPLICIAL_ManyToManyBendIncidenceRelations(
    "HalfEdges", "Faces", "HalfEdgesOfFaces", "FacesOfHalfEdges");
__SIMPLICIAL_ManyToManyBendIncidenceRelations(
    "Edges", "LocalEdges", "EdgesOfLocalEdges", "LocalEdgesOfEdges");



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
            LocalFlagsOfLocalVertices(bendComplex) );
    end
);
InstallMethod( LocalFlagEdgeInvolution, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(bendComplex)
        return __SIMPLICIAL_InvolutionFromPartition(
            LocalFlagsOfLocalEdges(bendComplex) );
    end
);
InstallMethod( LocalFlagFaceInvolution, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(bendComplex)
        return __SIMPLICIAL_InvolutionFromPartition(
            LocalFlagsOfHalfEdges(bendComplex) );
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
        
        SetLocalFlagsOfLocalVertices(complex, vertexPart);
        SetLocalFlagsOfLocalEdges(complex, edgePart);
        SetLocalFlagsOfHalfEdges(complex, facePart);
        return complex;
    end
);

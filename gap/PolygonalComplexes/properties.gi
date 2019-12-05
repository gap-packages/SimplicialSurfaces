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
##      Invariants
##
InstallMethod( EulerCharacteristic, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        return NumberOfVertices(complex) - NumberOfEdges(complex) + NumberOfFaces(complex);
    end
);

InstallMethod( IsClosedSurface, "for a polygonal complex without edge ramifications",
    [IsPolygonalComplex and IsNotEdgeRamified],
    function( ramSurf )
        local faces;

        for faces in FacesOfEdges(ramSurf) do
            if Length(faces) <> 2 then
                return false;
            fi;
        od;
        return true;
    end
);
InstallMethod( IsClosedSurface, "for a twisted polygonal complex without edge ramifications",
    [IsTwistedPolygonalComplex and IsNotEdgeRamified],
    function( ramSurf )
        local edgeClass;

        for edgeClass in TwoAdjacencyClasses(ramSurf) do
            if Length(edgeClass) <> 2 then
                return false;
            fi;
        od;
        return true;
    end
);
InstallOtherMethod( IsClosedSurface, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        if not IsNotEdgeRamified(complex) then
            Error("IsClosedSurface: Given twisted polygonal complex complex contains ramified edges.");
        fi;
        return IsClosedSurface(complex); # Call the function above
    end
);

##
##      End of invariants
##
#######################################


#######################################
##
##      Degree-based properties
##

InstallMethod( EdgeDegreesOfVertices, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        return List( EdgesOfVertices(complex), Length );
    end
);
InstallMethod( EdgeDegreeOfVertexNC, "for a twisted polygonal complex and a vertex",
    [IsTwistedPolygonalComplex, IsPosInt],
    function( complex, vertex )
        return EdgeDegreesOfVertices(complex)[vertex];
    end
);
InstallMethod( EdgeDegreeOfVertex, "for a twisted polygonal complex and a vertex",
    [IsTwistedPolygonalComplex, IsPosInt],
    function( complex, vertex )
        __SIMPLICIAL_CheckVertex(complex, vertex, "EdgeDegreeOfVertex");
        return EdgeDegreeOfVertexNC(complex, vertex);
    end
);


InstallMethod( FaceDegreesOfVertices, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        return List( FacesOfVertices(complex), Length );
    end
);
InstallMethod( FaceDegreeOfVertexNC, "for a twisted polygonal complex and a vertex",
    [IsTwistedPolygonalComplex, IsPosInt],
    function( complex, vertex )
        return FaceDegreesOfVertices(complex)[vertex];
    end
);
InstallMethod( FaceDegreeOfVertex, "for a twisted polygonal complex and a vertex",
    [IsTwistedPolygonalComplex, IsPosInt],
    function( complex, vertex )
        __SIMPLICIAL_CheckVertex(complex, vertex, "FaceDegreeOfVertex");
        return FaceDegreeOfVertexNC(complex, vertex);
    end
);

InstallMethod( DegreesOfVertices, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        return FaceDegreesOfVertices(complex);
    end
);
InstallMethod( DegreeOfVertexNC, "for a twisted polygonal complex and a vertex",
    [IsTwistedPolygonalComplex, IsPosInt],
    function( complex, vertex )
        return FaceDegreeOfVertexNC(complex, vertex);
    end
);
InstallMethod( DegreeOfVertex, "for a twisted polygonal complex and a vertex",
    [IsTwistedPolygonalComplex, IsPosInt],
    function( complex, vertex )
        return FaceDegreeOfVertex(complex, vertex);
    end
);



InstallMethod( TotalDefect, "for a simplicial surface", [IsSimplicialSurface],
    function(surf)
        local res, v, degrees;

        degrees := FaceDegreesOfVertices(surf);
        res := 0;
        for v in VerticesAttributeOfComplex(surf) do
            if IsInnerVertexNC(surf, v) then
                res := res + 6 - degrees[v];
            else
                res := res + 3 - degrees[v];
            fi;
        od;
        return res;
    end
);
RedispatchOnCondition( TotalDefect, true, [IsTwistedPolygonalComplex], [IsSimplicialSurface], 0 );

InstallMethod( TotalInnerDefect, "for a simplicial surface", [IsSimplicialSurface],
    function(surf)
        local res, v, degrees;

        degrees := FaceDegreesOfVertices(surf);
        res := 0;
        for v in VerticesAttributeOfComplex(surf) do
            if IsInnerVertexNC(surf, v) then
                res := res + 6 - degrees[v];
            fi;
        od;
        return res;
    end
);
RedispatchOnCondition( TotalInnerDefect, true, [IsTwistedPolygonalComplex], [IsSimplicialSurface], 0 );


InstallMethod( VertexCounter, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        local faceDegrees, faces, deg, counter;

        faceDegrees := [];
        for faces in FacesOfVertices(complex) do
            deg := Length(faces);
            if IsBound(faceDegrees[deg]) then
                faceDegrees[deg] := faceDegrees[deg] + 1;
            else
                faceDegrees[deg] := 1;
            fi;
        od;

        counter := [];
        for deg in [1..Length(faceDegrees)] do
            if IsBound(faceDegrees[deg]) then
                Add(counter, [ deg, faceDegrees[deg] ]);
            fi;
        od;

        return counter;

        #faceDegrees := List( FacesOfVertices(complex), Length );
        #return Collected( Compacted( faceDegrees ) );
    end
);

InstallMethod( EdgeCounter, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        local faceDegrees, edgeDegrees;

        faceDegrees := List( FacesOfVertices(complex), Length );
        edgeDegrees := List( VerticesOfEdges(complex), vs -> List(vs, v -> faceDegrees[v]) );
        Perform( edgeDegrees, Sort );
        return Collected( Compacted( edgeDegrees ) );
    end
);

InstallMethod( FaceCounter, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        local vertexDegrees, faceDegrees;

        vertexDegrees := List( FacesOfVertices(complex), Length );
        faceDegrees := List( VerticesOfFaces(complex), vs -> List(vs, v -> vertexDegrees[v]) );
        Perform( faceDegrees, Sort );
        return Collected( Compacted( faceDegrees ) );
    end
);
##
##      End of degrees
##
#######################################



#######################################
##
##      Types of vertices
##
InstallMethod( InnerVertices, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local edgeFacePaths, res, v;

        edgeFacePaths := UmbrellaPathsOfVertices(complex);
        res := [];
        for v in VerticesAttributeOfComplex(complex) do
            if edgeFacePaths[v] <> fail and IsClosedPath(edgeFacePaths[v]) then
                Add(res, v);
            fi;
        od;
        return res;
    end
);
InstallMethod( InnerVertices, "for a polygonal surface",
    [IsPolygonalSurface],
    function(surface)
        local res, v;

        res := [];
        for v in VerticesAttributeOfComplex(surface) do
            if Length(EdgesOfVertices(surface)[v]) = Length(FacesOfVertices(surface)[v]) then
                Add(res, v);
            fi;
        od;

        return res;
    end
);
InstallMethod( InnerVertices, "for a closed twisted polygonal complex",
    [IsTwistedPolygonalComplex and IsClosedSurface],
    function(complex)
        return VerticesAttributeOfComplex(complex);
    end
);
InstallMethod( InnerVertices, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        local res, oneRel, twoRel, vertexRel, chambers, v, c, inner;
        
        res := [];
        oneRel := OneAdjacencyRelation(complex);
        twoRel := TwoAdjacencyRelation(complex);
        vertexRel := JoinEquivalenceRelations(oneRel,twoRel);
        chambers := EquivalenceRelationPartition(vertexRel);
        for v in VerticesAttributeOfComplex(complex) do
            if ForAny( EdgesOfVertexNC(complex,v), e -> IsRamifiedEdgeNC(complex,e) ) then
                continue;
            fi;
            if not ChambersOfVertexNC(complex,v) in chambers then
                continue;
            fi;
            # We need to distinguish between inner vertices and boundary vertices
            inner := true;
            for c in ChambersOfVertexNC(complex,v) do
                if TwoAdjacentChambersNC(complex,v) = [] then
                    inner := false;
                    break;
                fi;
            od;
            if inner then
                Add(res,v);
            fi;
        od;

        return res;
    end
);
InstallMethod( IsInnerVertexNC, "for a twisted polygonal complex and a vertex",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, vertex)
        return vertex in InnerVertices(complex);
    end
);
InstallMethod( IsInnerVertex, "for a twisted polygonal complex and a vertex",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, vertex)
        __SIMPLICIAL_CheckVertex(complex, vertex, "IsInnerVertex");
        return IsInnerVertexNC(complex, vertex);
    end
);
#TODO implication to IsClosedSurface


BindGlobal("__SIMPLICIAL_BoundaryVertices_Umbrellas",
    function(complex)
        local edgeFacePaths, res, v;

        edgeFacePaths := UmbrellaPathsOfVertices(complex);
        res := [];
        for v in VerticesAttributeOfComplex(complex) do
            if edgeFacePaths[v] <> fail and not IsClosedPath(edgeFacePaths[v]) then
                Add(res, v);
            fi;
        od;
        return res;
    end
);
BindGlobal("__SIMPLICIAL_BoundaryVertices_BoundaryEdges",
    function(surface)
        local boundEdges;

        boundEdges := BoundaryEdges(surface);
        return __SIMPLICIAL_UnionSets( VerticesOfEdges(surface){boundEdges} );
    end
);

# Generic method
InstallMethod( BoundaryVertices, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return __SIMPLICIAL_BoundaryVertices_Umbrellas(complex);
    end
);
# Special case closed surface
InstallMethod( BoundaryVertices, "for a closed twisted polygonal complex",
    [IsTwistedPolygonalComplex and IsClosedSurface],
    function(complex)
        return [];
    end
);
# Special case umbrellas are known
InstallMethod( BoundaryVertices, 
    "for a polygonal complex with UmbrellaPathsOfVertices",
    [IsPolygonalComplex and HasUmbrellaPathsOfVertices],
    function(complex)
        return __SIMPLICIAL_BoundaryVertices_Umbrellas(complex);
    end
);
# Special case polygonal surface and boundary edges are known
InstallMethod( BoundaryVertices, "for a polygonal surface with BoundaryEdges",
    [IsPolygonalSurface and HasBoundaryEdges],
    function(surface)
        return __SIMPLICIAL_BoundaryVertices_BoundaryEdges(surface);
    end
);
# "Generic" case for polygonal surfaces
InstallMethod( BoundaryVertices, "for a polygonal surface",
    [IsPolygonalSurface],
    function(surface)
        if HasUmbrellaPathsOfVertices(surface) then
            TryNextMethod();
        fi;
        return __SIMPLICIAL_BoundaryVertices_BoundaryEdges(surface);
    end
);
InstallMethod( BoundaryVertices, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        local res, oneRel, twoRel, vertexRel, chambers, v, c, inner;
        
        res := [];
        oneRel := OneAdjacencyRelation(complex);
        twoRel := TwoAdjacencyRelation(complex);
        vertexRel := JoinEquivalenceRelations(oneRel,twoRel);
        chambers := EquivalenceRelationPartition(vertexRel);
        for v in VerticesAttributeOfComplex(complex) do
            if ForAny( EdgesOfVertexNC(complex,v), e -> IsRamifiedEdgeNC(complex,e) ) then
                continue;
            fi;
            if not ChambersOfVertexNC(complex,v) in chambers then
                continue;
            fi;
            # We need to distinguish between inner vertices and boundary vertices
            inner := true;
            for c in ChambersOfVertexNC(complex,v) do
                if TwoAdjacentChambersNC(complex,v) = [] then
                    inner := false;
                    break;
                fi;
            od;
            if not inner then
                Add(res,v);
            fi;
        od;

        return res;
    end
);



InstallMethod( IsBoundaryVertexNC, "for a twisted polygonal complex and a vertex",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, vertex)
        return vertex in BoundaryVertices(complex);
    end
);
InstallMethod( IsBoundaryVertex, "for a twisted polygonal complex and a vertex",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, vertex)
        __SIMPLICIAL_CheckVertex(complex, vertex, "IsBoundaryVertex");
        return IsBoundaryVertexNC(complex, vertex);
    end
);
#TODO implement implication to IsClosedSurface?


__SIMPLICIAL_AddTwistedAttribute( RamifiedVertices );
InstallMethod( RamifiedVertices, 
    "for a polygonal complex with UmbrellaPathsOfVertices, UmbrellaPathPartitionsOfVertices and VerticesAttributeOfComplex",
    [IsPolygonalComplex and HasUmbrellaPathsOfVertices and HasUmbrellaPathPartitionsOfVertices and HasVerticesAttributeOfComplex],
    function(complex)
        local edgeFacePaths, partitions, res, v;

        edgeFacePaths := UmbrellaPathsOfVertices(complex);
        partitions := UmbrellaPathPartitionsOfVertices(complex);
        res := [];
        for v in VerticesAttributeOfComplex(complex) do
            if edgeFacePaths[v] = fail and partitions[v] <> fail then
                Add(res, v);
            fi;
        od;
        return res;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "RamifiedVertices", 
    ["UmbrellaPathsOfVertices", "UmbrellaPathPartitionsOfVertices", "VerticesAttributeOfComplex"]);

InstallMethod( RamifiedVertices, 
    "for a twisted polygonal complex with OneAdjacencyRelation, TwoAdjacencyRelation, VerticesAttributeOfComplex, RamifiedEdges, EdgesOfVertices, and ChambersOfVertices",
    [IsTwistedPolygonalComplex and HasOneAdjacencyRelation and HasTwoAdjacencyRelation and HasVerticesAttributeOfComplex and HasRamifiedEdges and HasEdgesOfVertices and HasChambersOfVertices],
    function(complex)
        local res, oneRel, twoRel, vertexRel, chambers, v, c, inner;
        
        res := [];
        oneRel := OneAdjacencyRelation(complex);
        twoRel := TwoAdjacencyRelation(complex);
        vertexRel := JoinEquivalenceRelations(oneRel,twoRel);
        chambers := EquivalenceRelationPartition(vertexRel);
        for v in VerticesAttributeOfComplex(complex) do
            if ForAny( EdgesOfVertexNC(complex,v), e -> IsRamifiedEdgeNC(complex,e) ) then
                continue;
            fi;
            if not ChambersOfVertexNC(complex,v) in chambers then
                Add(res,v);
            fi;
        od;

        return res;
        
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "RamifiedVertices",
    ["OneAdjacencyRelation", "TwoAdjacencyRelation", "VerticesAttributeOfComplex", "RamifiedEdges", "EdgesOfVertices", "ChambersOfVertices"]);


InstallImmediateMethod( RamifiedVertices, "for a twisted polygonal surface",
    IsTwistedPolygonalSurface, 0,
    function(surf)
        return [];
    end
);
InstallMethod( IsRamifiedVertexNC, "for a twisted polygonal complex and a vertex",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, vertex)
        return vertex in RamifiedVertices(complex);
    end
);
InstallMethod( IsRamifiedVertex, "for a twisted polygonal complex and a vertex",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, vertex)
        __SIMPLICIAL_CheckVertex(complex, vertex, "IsRamifiedVertex");
        return IsRamifiedVertexNC(complex, vertex);
    end
);


__SIMPLICIAL_AddTwistedAttribute( IsNotVertexRamified );
InstallMethod( IsNotVertexRamified, 
    "for a twisted polygonal complex with IsNotEdgeRamified and RamifiedVerticces", 
    [IsTwistedPolygonalComplex and HasIsNotEdgeRamified and HasRamifiedVertices],
    function(complex)
        return IsNotEdgeRamified(complex) and Length(RamifiedVertices(complex)) = 0;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "IsNotVertexRamified", ["IsNotEdgeRamified", "RamifiedVertices"]);


InstallMethod( ChaoticVertices, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local partitions, res, v;

        partitions := UmbrellaPathPartitionsOfVertices(complex);
        res := [];
        for v in VerticesAttributeOfComplex(complex) do
            if partitions[v] = fail then
                Add(res, v);
            fi;
        od;
        return res;
    end
);
InstallMethod( ChaoticVertices, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        return Filtered( VerticesAttributeOfComplex(complex), v ->
            ForAny(EdgesOfVertexNC(complex,v), e -> IsRamifiedEdgeNC(complex, e)));
    end
);
InstallMethod( ChaoticVertices, "for a twisted polygonal complex without edge ramifications",
    [IsTwistedPolygonalComplex and IsNotEdgeRamified],
    function(ramSurf)
        return [];
    end
);
InstallMethod( IsChaoticVertexNC, "for a twisted polygonal complex and a vertex",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, vertex)
        return vertex in ChaoticVertices(complex);
    end
);
InstallMethod( IsChaoticVertex, "for a twisted polygonal complex and a vertex",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, vertex)
        __SIMPLICIAL_CheckVertex(complex, vertex, "IsChaoticVertex");
        return IsChaoticVertexNC(complex, vertex);
    end
);

InstallMethod( IsNotEdgeRamified,
    "for a twisted polygonal complex with ChaoticVertices",
    [IsTwistedPolygonalComplex and HasChaoticVertices],
    function(complex)
        if Length(ChaoticVertices(complex)) > 0 then
            return false;
        fi;
        TryNextMethod();
    end
);


##
##      End of vertex-types
##
#######################################


#######################################
##
##      Types of edges
##

InstallMethod( InnerEdges, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local facesOfEdges, res, e;

        facesOfEdges := FacesOfEdges(complex);
        res := [];
        for e in Edges(complex) do
            if Length(facesOfEdges[e]) = 2 then
                Add(res, e);
            fi;
        od;
        return res;
    end
);
InstallMethod( InnerEdges, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        local chambersOfEdges, res, e;

        chambersOfEdges := ChambersOfEdges(complex);
        res := [];
        for e in Edges(complex) do
            if Length(chambersOfEdges[e]) = 4 then
                Add(res, e);
            fi;
        od;
        return res;
    end
);
InstallMethod( InnerEdges, "for a closed polygonal surface",
    [IsPolygonalSurface and IsClosedSurface],
    function(complex)
        return Edges(complex);
    end
);
InstallMethod( IsInnerEdgeNC, "for a twisted polygonal complex and an edge",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, edge)
        return edge in InnerEdges(complex);
    end
);
InstallMethod( IsInnerEdge, "for a twisted polygonal complex and an edge",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "IsInnerEdge");
        return IsInnerEdgeNC(complex, edge);
    end
);
#TODO Implication to IsClosedSurface


InstallMethod( BoundaryEdges, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local facesOfEdges, res, e; 

        facesOfEdges := FacesOfEdges(complex);
        res := [];
        for e in Edges(complex) do
            if Length(facesOfEdges[e]) = 1 then
                Add(res,e);
            fi;
        od;
        return res;
    end
);
InstallMethod( BoundaryEdges, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        local chambersOfEdges, res, e;

        chambersOfEdges := ChambersOfEdges(complex);
        res := [];
        for e in Edges(complex) do
            if Length(chambersOfEdges[e]) = 2 then
                Add(res,e);
            fi;
        od;
        return res;
    end
);
InstallMethod( BoundaryEdges, "for a closed polygonal complex",
    [IsPolygonalComplex and IsClosedSurface],
    function(complex)
        return [];
    end
);
InstallMethod( IsBoundaryEdgeNC, "for a twisted polygonal complex and an edge",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, edge)
        return edge in BoundaryEdges(complex);
    end
);
InstallMethod( IsBoundaryEdge, "for a twisted polygonal complex and an edge",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "IsBoundaryEdge");
        return IsBoundaryEdgeNC(complex, edge);
    end
);


__SIMPLICIAL_AddTwistedAttribute(RamifiedEdges);
InstallMethod( RamifiedEdges, 
    "for a polygonal complex with FacesOfEdges and Edges",
    [IsPolygonalComplex and HasFacesOfEdges and HasEdges],
    function(complex)
        local facesOfEdges, ram, e;

        facesOfEdges := FacesOfEdges(complex);
        ram := [];
        for e in Edges(complex) do
            if Length(facesOfEdges[e]) > 2 then
                Add(ram, e);
            fi;
        od;
        return ram;
    end
);
AddPropertyIncidence(SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "RamifiedEdges", ["FacesOfEdges", "Edges"], ["IsPolygonalComplex"]);
InstallMethod( RamifiedEdges, 
    "for a twisted polygonal complex with ChambersOfEdges and Edges",
    [IsTwistedPolygonalComplex and HasChambersOfEdges and HasEdges],
    function(complex)
        local chambersOfEdges, ram, e;

        chambersOfEdges := ChambersOfEdges(complex);
        ram := [];
        for e in Edges(complex) do
            if Length(chambersOfEdges[e]) > 4 then
                Add(ram, e);
            fi;
        od;
        return ram;
    end
);
AddPropertyIncidence(SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "RamifiedEdges", ["ChambersOfEdges", "Edges"]);

InstallImmediateMethod( RamifiedEdges, 
    "for a twisted polygonal complex without edge ramifications",
    IsTwistedPolygonalComplex and IsNotEdgeRamified, 0,
    function(ramSurf)
        return []; # There are no ramified edges in a ramified polygonal surface
    end
);
InstallMethod( IsRamifiedEdgeNC, "for a twisted polygonal complex and an edge",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, edge)
        return edge in RamifiedEdges(complex);
    end
);
InstallMethod( IsRamifiedEdge, "for a twisted polygonal complex and an edge",
    [IsTwistedPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "IsRamifiedEdge");
        return IsRamifiedEdgeNC(complex, edge);
    end
);

__SIMPLICIAL_AddTwistedAttribute( IsNotEdgeRamified );
InstallMethod( IsNotEdgeRamified, 
    "for a twisted polygonal complex with RamifiedEdges", 
    [IsTwistedPolygonalComplex and HasRamifiedEdges],
    function(complex)
        return Length(RamifiedEdges(complex)) = 0;
    end
);
AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
    "IsNotEdgeRamified", "RamifiedEdges");


##
##      End of edge types
##
#######################################


#######################################
##
##      Types of faces
##

InstallMethod( IsFaceHomogeneous, "for a polygonal complex", 
    [IsPolygonalComplex],
    function(complex)
        local nr, f, verts, faces;

        verts := VerticesOfFaces(complex);
        faces := Faces(complex);
        if Length(faces) = 0 then
            return true;
        fi;

        nr := Length( verts[faces[1]] );
        for f in [2..Length(faces)] do
            if Length(verts[faces[f]]) <> nr then
                return false;
            fi;
        od;

        return true;
    end
);
InstallMethod( IsFaceHomogeneous, "for a twisted polygonal complex", 
    [IsTwistedPolygonalComplex],
    function(complex)
        local nr, f, chambersOfFaces, faces;

        chambersOfFaces := chambersOfFaces(complex);
        faces := Faces(complex);
        if Length(faces) = 0 then
            return true;
        fi;

        nr := Length( chambersOfFaces[faces[1]] );
        for f in [2..Length(faces)] do
            if Length(chambersOfFaces[faces[f]]) <> nr then
                return false;
            fi;
        od;

        return true;
    end
);


InstallMethod( IsTriangular, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local verts, f;

        verts := VerticesOfFaces(complex);
        for f in Faces(complex) do
            if Length(verts[f]) <> 3 then
                return false;
            fi;
        od;

        return true;
    end
);
InstallMethod( IsTriangular, "for a polygonal complex with homogeneous faces",
    [IsPolygonalComplex and IsFaceHomogeneous],
    function(complex)
        local verts;

        verts := VerticesOfFaces(complex);
        if Length(Faces(complex)) = 0 then
            return true;
        else
            return Length(verts[Faces(complex)[1]]) = 3;
        fi;
    end
);
InstallMethod( IsTriangular, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        local chambs, f;

        chambs := ChambersOfFaces(complex);
        for f in Faces(complex) do
            if Length(chambs[f]) <> 6 then
                return false;
            fi;
        od;

        return true;
    end
);
InstallMethod( IsTriangular, 
    "for a twisted polygonal complex with homogeneous faces",
    [IsTwistedPolygonalComplex and IsFaceHomogeneous],
    function(complex)
        local chambs;

        chambs := ChambersOfFaces(complex);
        if Length(Faces(complex)) = 0 then
            return true;
        else
            return Length(chambs[Faces(complex)[1]]) = 6;
        fi;
    end
);



InstallMethod( IsQuadrangular, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local verts, f;

        verts := VerticesOfFaces(complex);
        for f in Faces(complex) do
            if Length(verts[f]) <> 4 then
                return false;
            fi;
        od;

        return true;
    end
);
InstallMethod( IsQuadrangular, 
    "for a polygonal complex with homogeneous faces",
    [IsPolygonalComplex and IsFaceHomogeneous],
    function(complex)
        local verts;

        verts := VerticesOfFaces(complex);
        if Length(Faces(complex)) = 0 then
            return true;
        else
            return Length(verts[Faces(complex)[1]]) = 4;
        fi;
    end
);
InstallMethod( IsQuadrangular, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        local chambs, f;

        chambs := ChambersOfFaces(complex);
        for f in Faces(complex) do
            if Length(chambs[f]) <> 8 then
                return false;
            fi;
        od;

        return true;
    end
);
InstallMethod( IsQuadrangular, 
    "for a twisted polygonal complex with homogeneous faces",
    [IsTwistedPolygonalComplex and IsFaceHomogeneous],
    function(complex)
        local chambs;

        chambs := ChambersOfFaces(complex);
        if Length(Faces(complex)) = 0 then
            return true;
        else
            return Length(chambs[Faces(complex)[1]]) = 8;
        fi;
    end
);



##
##      End of types of faces
##
#######################################



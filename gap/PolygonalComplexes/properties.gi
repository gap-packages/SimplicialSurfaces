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
InstallMethod( EulerCharacteristic, "for a VEF-complex",
    [IsVEFComplex],
    function(complex)
        return NumberOfVertices(complex) - NumberOfEdges(complex) + NumberOfFaces(complex);
    end
);

InstallMethod( IsClosedSurface, "for a ramified polygonal surface",
    [IsRamifiedPolygonalSurface],
    function( ramSurf )
        return ForAll( List( FacesOfEdges(ramSurf), Length ), i -> i=2 );
    end
);
InstallOtherMethod( IsClosedSurface, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        if not IsRamifiedPolygonalSurface(complex) then
            Error("IsClosed: Given polygonal complex is not a ramified polygonal surface.");
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

InstallMethod( EdgeDegreesOfVertices, "for a VEF-complex",
    [IsVEFComplex],
    function(complex)
        return List( EdgesOfVertices(complex), Length );
    end
);
InstallMethod( EdgeDegreeOfVertexNC, "for a VEF-complex and a vertex",
    [IsVEFComplex, IsPosInt],
    function( complex, vertex )
        return EdgeDegreesOfVertices(complex)[vertex];
    end
);
InstallMethod( EdgeDegreeOfVertex, "for a VEF-complex and a vertex",
    [IsVEFComplex, IsPosInt],
    function( complex, vertex )
        __SIMPLICIAL_CheckVertex(complex, vertex, "EdgeDegreeOfVertex");
        return EdgeDegreeOfVertexNC(complex, vertex);
    end
);


InstallMethod( FaceDegreesOfVertices, "for a VEF-complex",
    [IsVEFComplex],
    function(complex)
        return List( FacesOfVertices(complex), Length );
    end
);
InstallMethod( FaceDegreeOfVertexNC, "for a VEF-complex and a vertex",
    [IsVEFComplex, IsPosInt],
    function( complex, vertex )
        return FaceDegreesOfVertices(complex)[vertex];
    end
);
InstallMethod( FaceDegreeOfVertex, "for a VEF-complex and a vertex",
    [IsVEFComplex, IsPosInt],
    function( complex, vertex )
        __SIMPLICIAL_CheckVertex(complex, vertex, "FaceDegreeOfVertex");
        return FaceDegreeOfVertexNC(complex, vertex);
    end
);


InstallMethod( VertexCounter, "for a VEF-complex",
    [IsVEFComplex],
    function(complex)
        local faceDegrees;

        faceDegrees := List( FacesOfVertices(complex), Length );
        return Collected( Compacted( faceDegrees ) );
    end
);

InstallMethod( EdgeCounter, "for a VEF-complex",
    [IsVEFComplex],
    function(complex)
        local faceDegrees, edgeDegrees;

        faceDegrees := List( FacesOfVertices(complex), Length );
        edgeDegrees := List( VerticesOfEdges(complex), vs -> List(vs, v -> faceDegrees[v]) );
        Perform( edgeDegrees, Sort );
        return Collected( Compacted( edgeDegrees ) );
    end
);

InstallMethod( FaceCounter, "for a VEF-complex",
    [IsVEFComplex],
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

        edgeFacePaths := UmbrellasOfVertices(complex);
        res := [];
        for v in VerticesAttributeOfVEFComplex(complex) do
            if edgeFacePaths[v] <> fail and IsClosedPath(edgeFacePaths[v]) then
                Add(res, v);
            fi;
        od;
        return res;
    end
);
InstallMethod( InnerVertices, "for a closed polygonal complex",
    [IsPolygonalComplex and IsClosedSurface],
    function(complex)
        return VerticesAttributeOfVEFComplex(complex);
    end
);
InstallMethod( IsInnerVertexNC, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        return vertex in InnerVertices(complex);
    end
);
InstallMethod( IsInnerVertex, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        __SIMPLICIAL_CheckVertex(complex, vertex, "IsInnerVertex");
        return IsInnerVertexNC(complex, vertex);
    end
);
#TODO implication to IsClosedSurface


BindGlobal("__SIMPLICIAL_BoundaryVertices_Umbrellas",
    function(complex)
        local edgeFacePaths, res, v;

        edgeFacePaths := UmbrellasOfVertices(complex);
        res := [];
        for v in VerticesAttributeOfVEFComplex(complex) do
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
InstallMethod( BoundaryVertices, "for a closed polygonal complex",
    [IsPolygonalComplex and IsClosedSurface],
    function(complex)
        return [];
    end
);
# Special case umbrellas are known
InstallMethod( BoundaryVertices, 
    "for a polygonal complex with UmbrellasOfVertices",
    [IsPolygonalComplex and HasUmbrellasOfVertices],
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
        if HasUmbrellasOfVertices(surface) then
            TryNextMethod();
        fi;
        return __SIMPLICIAL_BoundaryVertices_BoundaryEdges(surface);
    end
);



InstallMethod( IsBoundaryVertexNC, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        return vertex in BoundaryVertices(complex);
    end
);
InstallMethod( IsBoundaryVertex, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        __SIMPLICIAL_CheckVertex(complex, vertex, "IsBoundaryVertex");
        return IsBoundaryVertexNC(complex, vertex);
    end
);
#TODO implement implication to IsClosedSurface?


InstallMethod( RamifiedVertices, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local edgeFacePaths, partitions, res, v;

        edgeFacePaths := UmbrellasOfVertices(complex);
        partitions := UmbrellaPartitionsOfVertices(complex);
        res := [];
        for v in VerticesAttributeOfVEFComplex(complex) do
            if edgeFacePaths[v] = fail and partitions[v] <> fail then
                Add(res, v);
            fi;
        od;
        return res;
    end
);
InstallMethod( RamifiedVertices, "for a polygonal surface",
    [IsPolygonalSurface],
    function(surf)
        return [];
    end
);
InstallMethod( IsRamifiedVertexNC, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        return vertex in RamifiedVertices(complex);
    end
);
InstallMethod( IsRamifiedVertex, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        __SIMPLICIAL_CheckVertex(complex, vertex, "IsRamifiedVertex");
        return IsRamifiedVertexNC(complex, vertex);
    end
);

InstallMethod( IsPolygonalSurface, 
    "for a polygonal complex with RamifiedVertices",
    [IsPolygonalComplex and HasRamifiedVertices],
    function(complex)
        if Length(RamifiedVertices(complex)) <> 0 then
            return false;
        fi;
        TryNextMethod();
    end
);


InstallMethod( ChaoticVertices, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local partitions, res, v;

        partitions := UmbrellaPartitionsOfVertices(complex);
        res := [];
        for v in VerticesAttributeOfVEFComplex(complex) do
            if partitions[v] = fail then
                Add(res, v);
            fi;
        od;
        return res;
    end
);
InstallMethod( ChaoticVertices, "for a ramified polygonal surface",
    [IsRamifiedPolygonalSurface],
    function(ramSurf)
        return [];
    end
);
InstallMethod( IsChaoticVertexNC, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        return vertex in ChaoticVertices(complex);
    end
);
InstallMethod( IsChaoticVertex, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function(complex, vertex)
        __SIMPLICIAL_CheckVertex(complex, vertex, "IsChaoticVertex");
        return IsChaoticVertexNC(complex, vertex);
    end
);

InstallMethod( IsRamifiedPolygonalSurface, 
    "for a polygonal complex with ChaoticVertices",
    [IsPolygonalComplex and HasChaoticVertices],
    function(complex)
        if Length(ChaoticVertices(complex)) <> 1 then
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
InstallMethod( InnerEdges, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(complex)
        local facesOfEdges, res, e;

        facesOfEdges := LocalEdgesOfEdges(complex);
        res := [];
        for e in Edges(complex) do
            if Length(facesOfEdges[e]) = 2 then
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
InstallMethod( IsInnerEdgeNC, "for a VEF-complex and an edge",
    [IsVEFComplex, IsPosInt],
    function(complex, edge)
        return edge in InnerEdges(complex);
    end
);
InstallMethod( IsInnerEdge, "for a VEF-complex and an edge",
    [IsVEFComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "IsInnerEdge");
        return IsInnerEdgeNC(complex, edge);
    end
);
#TODO Implication to IsClosedSurface


InstallMethod( BoundaryEdges, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local facesOfEdges, res, e, u,v;

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
InstallMethod( BoundaryEdges, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(complex)
        local facesOfEdges, res, e, u,v;

        facesOfEdges := LocalEdgesOfEdges(complex);
        res := [];
        for e in Edges(complex) do
            if Length(facesOfEdges[e]) = 1 then
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
InstallMethod( IsBoundaryEdgeNC, "for a VEF-complex and an edge",
    [IsVEFComplex, IsPosInt],
    function(complex, edge)
        return edge in BoundaryEdges(complex);
    end
);
InstallMethod( IsBoundaryEdge, "for a VEF-complex and an edge",
    [IsVEFComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "IsBoundaryEdge");
        return IsBoundaryEdgeNC(complex, edge);
    end
);


InstallMethod( RamifiedEdges, "for a polygonal complex",
    [IsPolygonalComplex],
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
InstallMethod( RamifiedEdges, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(complex)
        local facesOfEdges, ram, e;

        facesOfEdges := LocalEdgesOfEdges(complex);
        ram := [];
        for e in Edges(complex) do
            if Length(facesOfEdges[e]) > 2 then
                Add(ram, e);
            fi;
        od;
        return ram;
    end
);
InstallMethod( RamifiedEdges, "for a ramified polygonal surface",
    [IsRamifiedPolygonalSurface],
    function(ramSurf)
        return []; # There are no ramified edges in a ramified polygonal surface
    end
);
InstallMethod( IsRamifiedEdgeNC, "for a VEF-complex and an edge",
    [IsVEFComplex, IsPosInt],
    function(complex, edge)
        return edge in RamifiedEdges(complex);
    end
);
InstallMethod( IsRamifiedEdge, "for a VEF-complex and an edge",
    [IsVEFComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "IsRamifiedEdge");
        return IsRamifiedEdgeNC(complex, edge);
    end
);

InstallMethod( IsNotEdgeRamified, "for a VEF-complex", [IsVEFComplex],
    function(complex)
        return Length(RamifiedEdges(complex)) = 0;
    end
);


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
InstallMethod( IsFaceHomogeneous, "for a bend polygonal complex", 
    [IsBendPolygonalComplex],
    function(complex)
        local nr, f, verts, faces;

        verts := LocalVerticesOfFaces(complex);
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
InstallMethod( IsTriangular, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(complex)
        local verts, f;

        verts := LocalVerticesOfFaces(complex);
        for f in Faces(complex) do
            if Length(verts[f]) <> 3 then
                return false;
            fi;
        od;

        return true;
    end
);
InstallMethod( IsTriangular, 
    "for a bend polygonal complex with homogeneous faces",
    [IsBendPolygonalComplex and IsFaceHomogeneous],
    function(complex)
        local verts;

        verts := LocalVerticesOfFaces(complex);
        if Length(Faces(complex)) = 0 then
            return true;
        else
            return Length(verts[Faces(complex)[1]]) = 3;
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
InstallMethod( IsQuadrangular, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(complex)
        local verts, f;

        verts := LocalVerticesOfFaces(complex);
        for f in Faces(complex) do
            if Length(verts[f]) <> 4 then
                return false;
            fi;
        od;

        return true;
    end
);
InstallMethod( IsQuadrangular, 
    "for a bend polygonal complex with homogeneous faces",
    [IsBendPolygonalComplex and IsFaceHomogeneous],
    function(complex)
        local verts;

        verts := LocalVerticesOfFaces(complex);
        if Length(Faces(complex)) = 0 then
            return true;
        else
            return Length(verts[Faces(complex)[1]]) = 4;
        fi;
    end
);



##
##      End of types of faces
##
#######################################



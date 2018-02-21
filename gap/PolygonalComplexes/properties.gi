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
InstallMethod( EulerCharacteristic, "for a polygonal complex",
    [IsPolygonalComplex],
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

InstallMethod( EdgeDegreesOfVertices, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return List( EdgesOfVertices(complex), Length );
    end
);
InstallMethod( EdgeDegreeOfVertexNC, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function( complex, vertex )
        return EdgeDegreesOfVertices(complex)[vertex];
    end
);
InstallMethod( EdgeDegreeOfVertex, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function( complex, vertex )
        __SIMPLICIAL_CheckVertex(complex, vertex, "EdgeDegreeOfVertex");
        return EdgeDegreeOfVertexNC(complex, vertex);
    end
);


InstallMethod( FaceDegreesOfVertices, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        return List( FacesOfVertices(complex), Length );
    end
);
InstallMethod( FaceDegreeOfVertexNC, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function( complex, vertex )
        return FaceDegreesOfVertices(complex)[vertex];
    end
);
InstallMethod( FaceDegreeOfVertex, "for a polygonal complex and a vertex",
    [IsPolygonalComplex, IsPosInt],
    function( complex, vertex )
        __SIMPLICIAL_CheckVertex(complex, vertex, "FaceDegreeOfVertex");
        return FaceDegreeOfVertexNC(complex, vertex);
    end
);


InstallMethod( VertexCounter, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local faceDegrees;

        faceDegrees := List( FacesOfVertices(complex), Length );
        return Collected( Compacted( faceDegrees ) );
    end
);

InstallMethod( EdgeCounter, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local faceDegrees, edgeDegrees;

        faceDegrees := List( FacesOfVertices(complex), Length );
        edgeDegrees := List( VerticesOfEdges(complex), vs -> List(vs, v -> faceDegrees[v]) );
        Perform( edgeDegrees, Sort );
        return Collected( Compacted( edgeDegrees ) );
    end
);

InstallMethod( FaceCounter, "for a polygonal complex",
    [IsPolygonalComplex],
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
        local edgeFacePaths;

        edgeFacePaths := UmbrellasOfVertices(complex);
        return Filtered( Vertices(complex), v -> 
            edgeFacePaths[v]<>fail and IsClosedPath(edgeFacePaths[v]) );
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


InstallMethod( BoundaryVertices, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local edgeFacePaths;

        edgeFacePaths := UmbrellasOfVertices(complex);
        return Filtered( Vertices(complex), v -> 
            edgeFacePaths[v]<>fail and not IsClosedPath(edgeFacePaths[v]) );
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


InstallMethod( RamifiedVertices, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local edgeFacePaths, partitions;

        edgeFacePaths := UmbrellasOfVertices(complex);
        partitions := UmbrellaPartitionsOfVertices(complex);
        return Filtered( Vertices(complex), v -> 
            edgeFacePaths[v]=fail and partitions[v]<>fail );
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


InstallMethod( ChaoticVertices, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local partitions;

        partitions := UmbrellaPartitionsOfVertices(complex);
        return Filtered( Vertices(complex), v -> partitions[v]=fail );
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
        local facesOfEdges;

        facesOfEdges := FacesOfEdges(complex);
        return Filtered( Edges(complex), e -> Length(facesOfEdges[e]) = 2 );
    end
);
InstallMethod( IsInnerEdgeNC, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        return edge in InnerEdges(complex);
    end
);
InstallMethod( IsInnerEdge, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "IsInnerEdge");
        return IsInnerEdgeNC(complex, edge);
    end
);


InstallMethod( BoundaryEdges, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local facesOfEdges;

        facesOfEdges := FacesOfEdges(complex);
        return Filtered( Edges(complex), e -> Length(facesOfEdges[e]) = 1 );
    end
);
InstallMethod( IsBoundaryEdgeNC, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        return edge in BoundaryEdges(complex);
    end
);
InstallMethod( IsBoundaryEdge, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "IsBoundaryEdge");
        return IsBoundaryEdgeNC(complex, edge);
    end
);


InstallMethod( RamifiedEdges, "for a polygonal complex",
    [IsPolygonalComplex],
    function(complex)
        local facesOfEdges;

        facesOfEdges := FacesOfEdges(complex);
        return Filtered( Edges(complex), e -> Length(facesOfEdges[e]) > 2 );
    end
);
InstallMethod( IsRamifiedEdgeNC, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        return edge in RamifiedEdges(complex);
    end
);
InstallMethod( IsRamifiedEdge, "for a polygonal complex and an edge",
    [IsPolygonalComplex, IsPosInt],
    function(complex, edge)
        __SIMPLICIAL_CheckEdge(complex, edge, "IsRamifiedEdge");
        return IsRamifiedEdgeNC(complex, edge);
    end
);


##
##      End of edge types
##
#######################################

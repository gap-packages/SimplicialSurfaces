## Code for Distance-Calculations

InstallMethod( NeighbourVerticesOfVertexNC,
    "for a polygonal complex and a positive integer",
    [IsPolygonalComplex,IsPosInt],
	function(polygonalComplex,vertex)
        local listOfNeighbourVertices,edge;
        listOfNeighbourVertices:=[];
        for edge in EdgesOfVertexNC(polygonalComplex,vertex) do
            # Now we use that every edge of a polygonal complex is incident to
            # excactly two vertices.
            Add(listOfNeighbourVertices, OtherVertexOfEdgeNC(polygonalComplex, vertex, edge) );
        od;
        return listOfNeighbourVertices;
    end
);

InstallMethod( NeighbourVerticesOfVertex,
	"for a polygonal complex and a positive integer",
	[IsPolygonalComplex,IsPosInt],
	function(polygonalComplex,vertex)
        __SIMPLICIAL_CheckVertex( polygonalComplex, vertex, "NeighbourVerticesOfVertex" );
        return NeighbourVerticesOfVertexNC(polygonalComplex,vertex);
    end
);

InstallMethod(DistanceOfVerticesNC,
    
    # The NC-Version of DistanceOfVertices does not check wheter the given
    # vertices vertex1 and vertex2 are vertices of the polygonal complex.
    # So it expects its input to be correct ( in the above frame).
    
    "for a polygonal complex and two positive integers",
	[IsPolygonalComplex, IsPosInt, IsPosInt],
	function(polygonalComplex, vertex1, vertex2)
        local vertex,lastDistance,listOfLastAdded,listOfVisitedVertices,
        currentVertex,listOfLastAddedOld;
    
        # The algorithm searches for the vertex2 in circles around vertex1, by
        # pacing of all possible vertex-edge-paths in the polygonal complex.
	
        if(vertex1=vertex2) then
            return 0;
        fi;
        lastDistance:=0;
	
        listOfVisitedVertices:=[vertex1];
	
        listOfLastAdded:=[vertex1];
        
        while(not(listOfLastAdded=[])) do
        
            # If there exists a shortest vertex-edge-path from vertex1 to vertex2,
            # this path will be extended by one edge in every step of this loop.
            # That means: If there is an iteration, in which no new edge is
            # reached, then vertex1 and vertex2 lie in two different connected
            # components of the polygonal complex. So there is no vertex-edge-path
            # between vertex1 and vertex2 ( in particular the is no shortest one)
            # and the distance -1 will be returned.
        
            lastDistance:=lastDistance+1;
        
            # With every step of this loop, the radius of the searched area
            # increases by 1 (which is the length of one edge). Accordingly the
            # variable lastDistance, which counts the steps of this loop, gives us
            # the distance between vertex1 and a vertex, that is found in the
            # current step (for the first time).
        
            listOfLastAddedOld:=ShallowCopy(listOfLastAdded);
            listOfLastAdded:=[];
            for vertex in listOfLastAddedOld do
                for currentVertex in NeighbourVerticesOfVertexNC(polygonalComplex,vertex) do
                    if(not(currentVertex in listOfVisitedVertices)) then
                        if(currentVertex=vertex2) then
                            return lastDistance;
                        fi;
                        Add(listOfLastAdded,currentVertex);
                        Add(listOfVisitedVertices,currentVertex);
                    fi;
                od;
            od;
        od;
        return -1;
	
        # If all vertices, which are reachable with a vertex-edge-path beginning at
        # vertex1, are already visited, and vertex2 is not one of them, then the
        # distance is infinite are the method will return -1.
	end
);


InstallMethod( DistanceOfVertices, 
	"for a polygonal complex and two positive integers",
	[IsPolygonalComplex, IsPosInt, IsPosInt],
	function(polygonalComplex, vertex1, vertex2)
        __SIMPLICIAL_CheckVertex( polygonalComplex, vertex1, "DistanceOfVertices" );
        __SIMPLICIAL_CheckVertex( polygonalComplex, vertex2, "DistanceOfVertices" );
        return DistanceOfVerticesNC(polygonalComplex, vertex1, vertex2);
    end
);

##########################################################################################################################################################

InstallMethod( NeighbourFacesOfFaceNC,
	"for a polygonal complex and a positive integer",
	[IsPolygonalComplex,IsPosInt],
	function(polygonalComplex,face)
        local listOfNeighbourFaces,currentEdge,neighbourFaces;
        listOfNeighbourFaces:=[];

        for currentEdge in EdgesOfFaceNC(polygonalComplex,face) do
            neighbourFaces := NeighbourFacesByEdgeNC(polygonalComplex,face,edge);
            Append(listOfNeighbourFaces, neighbourFaces);
        od;
        listOfNeighbourFaces:=DuplicateFreeList(listOfNeighbourFaces);
        return listOfNeighbourFaces;
    end
);


InstallMethod( NeighbourFacesOfFace,
	"for a polygonal complex and a positive integer",
	[IsPolygonalComplex,IsPosInt],
	function(polygonalComplex,face)
         __SIMPLICIAL_CheckFace( polygonalComplex, face, "NeighbourFacesOfFace" );
    
        return NeighbourFacesOfFaceNC(polygonalComplex,face);
    end
);


InstallMethod(DistanceOfFacesNC,
    "for a polygonal complex and two positive integers",
	[IsPolygonalComplex, IsPosInt, IsPosInt],
	function(polygonalComplex, face1, face2)
        local face,lastDistance,listOfLastAdded,listOfVisitedFaces,
        currentFace,listOfLastAddedOld;
        
        # The algorithm searches for the face2 in circles around face1, by
        # pacing of all possible face-edge-paths in the polygonal complex.
	
        if(face1=face2) then
            return 0;
        fi;
        lastDistance:=0;
        listOfVisitedFaces:=[face1];
	
        # Because we start the search for face2 at face1, the face1 lies in
        # the middle of the scanned area.
	
        listOfLastAdded:=[face1];
	
        while(not(listOfLastAdded=[])) do
	
            # If there exists a shortest face-edge-path from face1 to face2,
            # this path will be extended by one edge in every step of this loop.
            # That means: If there is an iteration, in which no new edge is
            # reached, then face1 and face2 lie in two different connected
            # components of the polygonal complex ( here we mean the connection by
            # a face-edge-connection; ramified vertices do not need to lead to a
            # connection in this frame!) . So there is no face-edge-path between
            # face1 and face2 ( in particular the is no shortest one). In this case
            # we leave the loop and return the distance -1.
        
            lastDistance:=lastDistance+1;
        
            # With every step of this loop, the radius of the searched area
            # increases by 1 (which is the length of one edge). Accordingly the
            # variable lastDistance, which counts the steps of this loop, gives us
            # the distance between face1 and a face, that is found in the
            # current step (for the first time).
     
            listOfLastAddedOld:=ShallowCopy(listOfLastAdded);
            listOfLastAdded:=[];
            for face in listOfLastAddedOld do
                for currentFace in NeighbourFacesOfFace(polygonalComplex,face) do
                    if(not(currentFace in listOfVisitedFaces)) then
        
                        if(currentFace=face2) then
                            return lastDistance;
                        fi;
                        Add(listOfLastAdded,currentFace);
                        Add(listOfVisitedFaces,currentFace);
                    fi;
                od;
            od;
        od;
        return -1;
	
        # If all faces, which are reachable with a face-edge-path beginning at
        # face1, are already visited, and face2 is not one of them, then the
        # distance is infinite and the method will return -1.
	end
);

InstallMethod( DistanceOfFaces, 
	"for a polygonal complex and two positive integers",
	[IsPolygonalComplex, IsPosInt, IsPosInt],
	function(polygonalComplex, face1, face2)
        __SIMPLICIAL_CheckFace( polygonalComplex, face1, "DistanceOfFaces" );
        __SIMPLICIAL_CheckFace( polygonalComplex, face2, "DistanceOfFaces" );
        return DistanceOfFacesNC(polygonalComplex, face1, face2);
    end
);

##################################################################################################################################################################

InstallMethod(RestrictionToNeighbourhoodOfFacesNC,
    "for a polygonal complex, a positive integer, and a list of faces ",
    [IsPolygonalComplex,IsPosInt,IsList],
    function(polygonalComplex, maxDist, startingFaces)
        local currentDistance,bigArea,localArea,face,startingFace,listOfLastAdded,listOfLastAddedOld,currentFace;
    
        # The algorithm extends each given face from the list startingFaces to
        # local neighbourhoods localArea of maximal size maxDist, unites all these
        # areas to a the new one bigArea, and then restricts the polygonal complex
        # to bigArea.

        bigArea:=[];
        for startingFace in startingFaces do
            localArea:=[startingFace];
            currentDistance:=1;
            listOfLastAdded:=[startingFace];
            while(not(currentDistance > maxDist)) do #determine localArea
            
                # With every step of this loop, the radius of the searched area
                # increases by 1 (which is the length of one edge). Accordingly the
                # variable lastDistance, which counts the steps of this loop, gives
                # us the distance between face1 and a face, that is found in the
                # current step (for the first time).
                # That means: As long as currentDistance is smaller or equal to
                # maxDist, new faces will be added to the area.
     
                listOfLastAddedOld:=ShallowCopy(listOfLastAdded);
                listOfLastAdded:=[];
                for face in listOfLastAddedOld do
                    for currentFace in NeighbourFacesOfFace(polygonalComplex,face) do
                        if(not(currentFace in localArea)) then
                            Add(listOfLastAdded,currentFace);
                            Add(localArea,currentFace);
                        fi;
                    od;
                od;
                currentDistance:=currentDistance+1;
            od;
            bigArea:= DuplicateFreeList(Concatenation(bigArea,localArea));
     
            # We unite the bigArea and the just computed localArea.
        od;
    
        # Last we restrict the polygonal complex to all its faces, that lie in
        # bigArea.
        return SubcomplexByFaces(polygonalComplex,bigArea);
    end
);

InstallMethod(RestrictionToNeighbourhoodOfFaces,
    "for a polygonal complex, a positive integer, and a list of faces ",
    [IsPolygonalComplex,IsPosInt,IsList],
    function(polygonalComplex, maxDist, startingFaces)
        local face;
    
        for face in startingFaces do
            __SIMPLICIAL_CheckFace( polygonalComplex, face, "RestrictionToNeighbourhoodOfFaces" );
        od;
    
        return RestrictionToNeighbourhoodOfFacesNC(polygonalComplex,maxDist,startingFaces);
    end
);
##################################################################################################################################################################

InstallMethod(RestrictionToNeighbourhoodOfVerticesNC,
    "for a triangular complex, a positive integer, and a list of vertices ",
    [IsTriangularComplex,IsPosInt,IsList],
    function(triangularComplex, maxDist,startingVertices)
        local currentDistance,bigArea,localArea,vertex,startingVertex,listOfLastAdded,listOfLastAddedOld,currentVertex,includedFaces,face;
    
        # The algorithm extends each given vertex from the list startingVertices to
        # local neighbourhoods localArea of maximal size maxDist and unites all
        # these areas to a new one, bigArea. At the end all faces of the triangular
        # complex for which holds that all three incident vertices lie in bigArea
        # will be identified and the triangular complex  will be restricted to
        # these faces.

        bigArea:=[];
        for startingVertex in startingVertices do
            localArea:=[startingVertex];
            currentDistance:=1;
            listOfLastAdded:=[startingVertex];
            while(not(currentDistance > maxDist)) do #determine localArea
            
                # With every step of this loop, the radius of the searched area
                # increases by 1 (which is the length of one edge). Accordingly the
                # variable lastDistance, which counts the steps of this loop, gives
                # us the distance between vertex1 and a vertex, that is found in
                # the current step (for the first time).
                # That means: As long as currentDistance is smaller or equal to
                # maxDist, new vertices will be added to the area.
     
                listOfLastAddedOld:=ShallowCopy(listOfLastAdded);
                listOfLastAdded:=[];
                for vertex in listOfLastAddedOld do
                    for currentVertex in NeighbourVerticesOfVertexNC(triangularComplex,vertex) do
                        if(not(currentVertex in localArea)) then
                            Add(listOfLastAdded,currentVertex);
                            Add(localArea,currentVertex);
                        fi;
                    od;
                od;
       
                currentDistance:=currentDistance+1;
            od;
     
            # We unite bigArea and the just computed localArea.
     
            bigArea:= DuplicateFreeList(Concatenation(bigArea,localArea));
        od;
    
        # Now we identify all faces of the triangular complex for which holds, that
        # all three incident edges lie in bigArea. Then we restrict the triangular
        # complex to these faces. For that we use that every such face is a
        # triangle. This is checked by the method
        # RestrictionToNeighbourhoodOfVertices.
    
        includedFaces:=[];
        for face in Faces(triangularComplex) do
            if IsSubset(bigArea, VerticesOfFace(triangularComplex,face)) then
            Add(includedFaces,face);
            fi;
        od;
        return SubcomplexByFacesNC(triangularComplex,includedFaces);
    end
);


InstallMethod(RestrictionToNeighbourhoodOfVertices,
    "for a triangular complex, a positive integer, and a list of faces ",
    [IsTriangularComplex,IsPosInt,IsList],
    function(triangularComplex, maxDist, startingVertices)
        local vertex;
    
        for vertex in startingVertices do
            __SIMPLICIAL_CheckVertex( triangularComplex, vertex, "RestrictionToNeighbourhoodOfVertices" );
        od;
        
        return RestrictionToNeighbourhoodOfVerticesNC(triangularComplex,maxDist,startingVertices);
    end
);


InstallMethod(EccentricityOfVertexNC,
    "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(polygonalComplex, vertex)
        local eccentricity,currentVertex,distance;
        eccentricity:=0;
        for currentVertex in Vertices(polygonalComplex) do
            distance:=DistanceOfVerticesNC(polygonalComplex,vertex,currentVertex);
            if distance=-1 then
                return -1;
            fi;    
            eccentricity:=Maximum(eccentricity,distance);
        od;
        return eccentricity;
    end
);

InstallMethod(EccentricityOfVertex,
    "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(polygonalComplex, vertex)
        __SIMPLICIAL_CheckVertex( polygonalComplex, vertex, "EccentricityOfVertex" );
        return EccentricityOfVertexNC(polygonalComplex,vertex);
end);

InstallMethod(DiameterOfPolygonalComplex,
    "for a polygonal complex",
    [IsPolygonalComplex],
    function(polygonalComplex)
        local diameter,vertex;
        diameter:=0;
        for vertex in Vertices(polygonalComplex) do
            if EccentricityOfVertex(polygonalComplex,vertex)=-1 then
                return -1;
            fi;
            diameter:=Maximum(diameter,EccentricityOfVertex(polygonalComplex,vertex));
        od;
        return diameter;
    end
);

InstallMethod(RadiusOfPolygonalComplex,
    "for a polygonal complex",
    [IsPolygonalComplex],
    function(polygonalComplex)
        local radius,vertex;
        radius:=Length(Edges(polygonalComplex));
        for vertex in Vertices(polygonalComplex) do
            if EccentricityOfVertex(polygonalComplex,vertex)=-1 then
                return -1;
            fi;
            radius:=Minimum(radius,EccentricityOfVertex(polygonalComplex,vertex));
        od;
        return radius;
    end
);


InstallMethod(CenterOfPolygonalComplex,
    "for a polygonal complex",
    [IsPolygonalComplex],
    function(polygonalComplex)
        local center,vertex;
        center:=[];
        if DiameterOfPolygonalComplex(polygonalComplex)=-1 then
            return [];
        fi;
        for vertex in Vertices(polygonalComplex) do
            if EccentricityOfVertex(polygonalComplex,vertex)=RadiusOfPolygonalComplex(polygonalComplex) then
            Add(center,vertex,Length(center)+1);
            fi;
        od;
        return center;
    end
);

## Code for Distance-Calculations

# First we will have a look at three functions to compute the distance of two
# vertices in a polygonal complex. This distance is defined as the length of a
# shortest vertex-edge-path between these two given vertices, where edge has
# length one.

# The following method NeighbourVerticesOfVertexNC computes all vertices of a
# polygonal complex, which share an edge with the given vertex. These
# neighbour-vertices will be returned in a list.

InstallMethod( NeighbourVerticesOfVertexNC,
	"for a polygonal complex and a positive integer",
    [IsPolygonalComplex,IsPosInt],
	function(polygonalComplex,vertex)
    local listOfNeighbourVertices,edge;
    listOfNeighbourVertices:=[];
    for edge in EdgesOfVertex(polygonalComplex,vertex) do
        # Now we use, that every edge of a polygonal complex is incident to
        # excactly two vertices.
        if(VerticesOfEdge(polygonalComplex,edge)[1]=vertex) then
            Add(listOfNeighbourVertices,VerticesOfEdge(polygonalComplex,edge)[2],Length(listOfNeighbourVertices)+1);
        else
            Add(listOfNeighbourVertices,VerticesOfEdge(polygonalComplex,edge)[1],Length(listOfNeighbourVertices)+1);
        fi;
    od;
    return listOfNeighbourVertices;
end);

# The method NeighbourVerticesOfVertex checks whether the given positive
# integer is a vertex of the polygonal complex. If that is true, then the
# neighbours of the given vertex in the polygonal complex will me computed by
# a call to NeighbourVerticesOfVertexNC.

InstallMethod( NeighbourVerticesOfVertex,
	"for a polygonal complex and a positive integer",
	[IsPolygonalComplex,IsPosInt],
	function(polygonalComplex,vertex)
	
	# If the given positive integer is not a vertex of the polygonal complex,
	# then an error will be returned.
    	
	if(not(vertex in Vertices(polygonalComplex))) then
        Error( Concatenation( "The vertex ", String(vertex), " does not lie in the given complex.\n")); 
    fi;
    
    # Now when we have checked the input for its correctness, we can call the
    # NC-Version NeighbourVerticesOfVertexNC, which actually computes the
    # neighbour-vertices of a vertex in a polygonal complex.
    
    return NeighbourVerticesOfVertexNC(polygonalComplex,vertex);
end);

# Below we have the NC-Version of DistanceOfVertices, which is the essentiellen
# part of the distance-computation of two vertices in a polygonal complex.

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
	
	# Because we start the search for vertex2 at vertex1, the vertex 1 lies in
	# the middle of the scanned area.
	
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
            for currentVertex in NeighbourVerticesOfVertex(polygonalComplex,vertex) do
                if(not(currentVertex in listOfVisitedVertices)) then
                    if(currentVertex=vertex2) then
                        return lastDistance;
                    fi;
                    Add(listOfLastAdded,currentVertex,Length(listOfLastAdded)+1);
                    Add(listOfVisitedVertices,currentVertex,Length(listOfVisitedVertices)+1);
                fi;
            od;
        od;
	od;
	return -1;
	
	# If all vertices, which are reachable with a vertex-edge-path beginning at
	# vertex1, are already visited, and vertex2 is not one of them, then the
	# distance is infinite are the method will return -1.
	
end);


# In this method we check wheter the the given vertices lie in the polygonal
# complex. If they both do, we then compute their distance by calling the
# NC-method DistanceOfVerticesNC. 

InstallMethod( DistanceOfVertices, 
	"for a polygonal complex and two positive integers",
	[IsPolygonalComplex, IsPosInt, IsPosInt],
	function(polygonalComplex, vertex1, vertex2)
	
	# If at least one of the given positive integers is not a vertex of the
	# polygonal complex, then an error will be returned.
	
	if((not(vertex1 in Vertices(polygonalComplex)))or(not(vertex2 in Vertices(polygonalComplex)))) then
        Error( Concatenation( "At least one of the vertices ", String(vertex1), " and ", String(vertex2), " does not lie in the given complex.\n")); 
    fi;
    
    
    # Now that we checked the input for its correctness, we can call the
    # NC-Version of DistanceOfVertices, which does the actual computation of
    # the distance of two vertices in a polygonal complex.
    
    return DistanceOfVerticesNC(polygonalComplex, vertex1, vertex2);
end);

##################################################################################################################################################################

# Next we will have a look at functions, which compute the distance of two
# faces in a polygonal complex. The distance is measured by the length of a
# shortest face-edge-path between these two faces. Every edge has length 1.

InstallMethod( NeighbourFacesOfFaceNC,
	"for a polygonal complex and a positive integer",
	[IsPolygonalComplex,IsPosInt],
	function(polygonalComplex,face)
    local listOfNeighbourFaces,currentEdge,currentFace;
    listOfNeighbourFaces:=[];
    for currentEdge in EdgesOfFace(polygonalComplex,face) do
        if(not(Length(FacesOfEdge(polygonalComplex,currentEdge))=1)) then
            
            # If currentEdge is an outer edge, then the only face to which it
            # is incident, is the given face itself. Because we only look for
            # real neighbour-faces, we can continue with the next edge.
            # We iterate over the list of all these faces, to not get into
            # trouble, when looking at ramified edges, (which are edges that
            # are incident to more than one face).
            # Polygonal Complexes can contain ramified edges.
     
            for currentFace in FacesOfEdge(polygonalComplex,currentEdge) do
                if(not((currentFace=face) or (currentFace in listOfNeighbourFaces))) then
                    Add(listOfNeighbourFaces,currentFace,Length(listOfNeighbourFaces)+1);
                fi;
                
                # The check '(currentFace in listOfNeighbourFaces)' is
                # necessary to not count faces, that are incident to more than
                # one edge of face, several times.
            od;
        fi;
    od;
    return listOfNeighbourFaces;
end);

# The following method NeighbourVerticesOfVertexNC computes all faces of a
# polygonal complex, which share an edge with the given face. These
# neighbour-faces will be returned in a list.

InstallMethod( NeighbourFacesOfFace,
	"for a polygonal complex and a positive integer",
	[IsPolygonalComplex,IsPosInt],
	function(polygonalComplex,face)
	
	# If the given positive integer is not a face of the polygonal complex,
	# then an error will be returned.
	
	if(not(face in Faces(polygonalComplex))) then
        Error( Concatenation( "The face ", String(face), " does not lie in the given complex.\n")); 
    fi;
    
    # Now that we have checked the input for its correctness, we can call the
    # NC-Version NeighbourFacesOfFaceNC, which actually computes the
    # neighbour-faces of a face in a polygonal complex.
    
    return NeighbourFacesOfFaceNC(polygonalComplex,face);
end);

# Below we have the NC-Version of DistanceOfFaces, which is the essentiellen
# part of the distance-computation of two faces in a polygonal complex.


InstallMethod(DistanceOfFacesNC,
    
    # The NC-Version of DistanceOfFaces does not check wheter the given
    # faces face1 and face2 are faces of the polygonal complex.
    # So it expects its input to be correct ( in the above frame).
    
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
                    Add(listOfLastAdded,currentFace,Length(listOfLastAdded)+1);
                    Add(listOfVisitedFaces,currentFace,Length(listOfVisitedFaces)+1);
                fi;
            od;
        od;
	od;
	return -1;
	
    # If all faces, which are reachable with a face-edge-path beginning at
	# face1, are already visited, and face2 is not one of them, then the
	# distance is infinite are the method will return -1.
	
end);

# In this method we check wheter the the given faces lie in the polygonal
# complex. If they both do, then we compute their distance by calling the
# NC-method DistanceOfFacesNC.

InstallMethod( DistanceOfFaces, 
	"for a polygonal complex and two positive integers",
	[IsPolygonalComplex, IsPosInt, IsPosInt],
	function(polygonalComplex, face1, face2)
    
	# If a least one of the given positive integers is not a face of the
	# polygonal complex, then an error will be returned.
	
	if((not(face1 in Faces(polygonalComplex)))or(not(face2 in Faces(polygonalComplex)))) then
        Error( Concatenation( "At least one of the faces ", String(face1), " and ", String(face2), " does not lie in the given complex.\n")); 
    fi;
    
    # Now that we checked the input for its correctness, we can call the
    # NC-Version of DistanceOfVertices, which does the actual computation of
    # the distance of two vertices in a polygonal complex.
    
    return DistanceOfFacesNC(polygonalComplex, face1, face2);
end);

##################################################################################################################################################################

# The next few methods restrict a polygonal complex to a neighbourhood of
# faces(/vertices) of a given size.

InstallMethod(RestrictionToNeighbourhoodOfFacesNC,
    "for a polygonal complex, a positive integer and a list of faces ",
    [IsPolygonalComplex,IsPosInt,IsList],
    function(polygonalComplex, maxDist, startingFaces)
    local currentDistance,bigArea,localArea,face,startingFace,listOfLastAdded,listOfLastAddedOld,currentFace;
    
    # The algorithm extends each given face from the list startingFaces to
    # local neighbourhoods localArea of maximal size maxDist, unites all these
    # areas to a the new one bigArea and then restricts the polygonal complex
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
                        Add(listOfLastAdded,currentFace,Length(listOfLastAdded)+1);
                        Add(localArea,currentFace,Length(localArea)+1);
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
end);

# In the method RestrictionToNeighbourhoodOfFaces we first check wheter the
# given distance is not negative. If it is true, and thus permitted, we next
# check whether the given faces lie in the polygonal complex. If this test is
# true also, we compute the compute the sub-complex by calling the NC-Method
# RestrictionToNeighbourhoodOfFacesNC. 

InstallMethod(RestrictionToNeighbourhoodOfFaces,
    "for a polygonal complex, a positive integer and a list of faces ",
    [IsPolygonalComplex,IsPosInt,IsList],
    function(polygonalComplex, maxDist, startingFaces)
    local invalidFaces,face;
    
    # If the given distance is smaller than 0, a error will be returned.

	if(maxDist<0)then
        Error(Concatenation("The given distance ", String(maxDist)," is less than zero.\n"));
    fi;
    
    # If a least one of the given positive integers from the list startingFaces
    # is not a face in the polygonal complex, then an error will be returned.
	
	invalidFaces:=[];
	for face in startingFaces do
        if(not(face in Faces(polygonalComplex))) then
            Add(invalidFaces,face,Length(invalidFaces)+1);
        fi;
    od;
    if(not(invalidFaces=[])) then
        Error( Concatenation( "The faces in ", String(invalidFaces), " do not lie in the given complex.\n")); 
    fi;
    
    # Now that we checked the input for its correctness, we can call the
    # NC-Version of DistanceOfFaces, which does the actual restriction of a
    # polygonal complex to a neighbourhood of faces.
    
    return RestrictionToNeighbourhoodOfFacesNC(polygonalComplex,maxDist,startingFaces);
end);
##################################################################################################################################################################

# The method RestrictionToNeighbourhoodOfVertices does only work for polygonal
# complexes, whose faces are all triangles (i.e. triangular complexes)

InstallMethod(RestrictionToNeighbourhoodOfVerticesNC,
    "for a triangular complex, a positive integer and a list of vertices ",
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
                for currentVertex in NeighbourVerticesOfVertex(triangularComplex,vertex) do
                    if(not(currentVertex in localArea)) then
                        Add(listOfLastAdded,currentVertex,Length(listOfLastAdded)+1);
                        Add(localArea,currentVertex,Length(localArea)+1);
                    fi;
                od;
            od;
       
            currentDistance:=currentDistance+1;
        od;
     
        # We unite the bigArea and the just computed localArea.
     
        bigArea:= DuplicateFreeList(Concatenation(bigArea,localArea));
	od;
    
    # Now we identify all faces of the triangular complex for which holds, that
    # all three incident edges lie in bigArea. Then we restrict the triangular
    # complex to these faces. For that we use that every such face is a
    # triangle. This is checked by the method
    # RestrictionToNeighbourhoodOfVertices.
    
	includedFaces:=[];
	for face in Faces(triangularComplex) do
        if ((VerticesOfFace(triangularComplex,face)[1] in bigArea) and (VerticesOfFace(triangularComplex,face)[2] in bigArea) and (VerticesOfFace(triangularComplex,face)[3] in bigArea)) then
            Add(includedFaces,face,Length(includedFaces)+1);
        fi;
    od;
	return SubcomplexByFaces(triangularComplex,includedFaces);

end);

# In the method RestrictionToNeighbourhoodOfVertices we first check whether the
# given faces lies in the polygonal complex. If it is true, we next check
# wheter the given distance is not negative. If this test is true also, we
# compute the sub-complex by calling the NC-Method
# RestrictionToNeighbourhoodOfFacesNC. 

InstallMethod(RestrictionToNeighbourhoodOfVertices,
    "for a triangular complex, a positive integer and a list of faces ",
    [IsTriangularComplex,IsPosInt,IsList],
    function(triangularComplex, maxDist, startingVertices)
    local invalidVertices,vertex,face;
    
    # If there exists any non-triangular face in the polygonal complex an error
    # will be returned.
    
    for face in Faces(triangularComplex) do
        if(not(Length(VerticesOfFace(triangularComplex,face))=3)) then
            Error("The given polygonal complex has a face that is not a triangle.\n ");
        fi;
    od;
    
    # If the given distance is smaller than 0, a error will be returned.
    
	if(maxDist<0)then
        Error(Concatenation("The given distance ", String(maxDist)," is less than zero.\n"));
    fi;
    
    # If a least one of the given positive integers from the list
    # startingVertices is not a vertex in the triangular complex, then an error
    # will be returned.
	
	invalidVertices:=[];
	for vertex in startingVertices do
        if(not(vertex in Vertices(triangularComplex))) then
            Add(invalidVertices,vertex,Length(invalidVertices)+1);
        fi;
    od;
    if(not(invalidVertices=[])) then
        Error( Concatenation( "The faces in ", String(invalidVertices), " do not lie in the given complex.\n")); 
    fi;
    
    # Now that we checked the input for its correctness, we can call the
    # NC-Version RestrictionToNeighbourhoodOfVerticesNC, which does the actual
    # restriction of a polygonal complex to a neighbourhood of vertices.
    
    return RestrictionToNeighbourhoodOfVerticesNC(triangularComplex,maxDist,startingVertices);
end);

# The methods below follow excactly the definition of eccentricity, diameter,
# radius and the center of a graph.

InstallMethod(EccentricityOfVertexNC,
    "for a polygonal complex, positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(polygonalComplex, vertex)
    local eccentricity,currentVertex,distance;
    eccentricity:=0;
    for currentVertex in Vertices(polygonalComplex) do
        distance:=DistanceOfVertices(polygonalComplex,vertex,currentVertex);
        if(distance=-1) then
            return -1;
        fi;    
        eccentricity:=Maximum(eccentricity,distance);
    od;
    return eccentricity;
end);

InstallMethod(EccentricityOfVertex,
    "for a polygonal complex, positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(polygonalComplex, vertex)
    if(not(vertex in Vertices(polygonalComplex))) then
        Error(Concatenation("The given vertex ", String(vertex)," does not lie in the given polygonal complex.\n"));
    fi;
    return EccentricityOfVertexNC(polygonalComplex,vertex);
end);

InstallMethod(DiameterOfPolygonalComplex,
    "for a polygonal complex",
    [IsPolygonalComplex],
    function(polygonalComplex)
    local diameter,vertex;
    diameter:=0;
    for vertex in Vertices(polygonalComplex) do
        if(EccentricityOfVertex(polygonalComplex,vertex)=-1) then
            return -1;
        fi;
        diameter:=Maximum(diameter,EccentricityOfVertex(polygonalComplex,vertex));
    od;
    return diameter;
end);

InstallMethod(RadiusOfPolygonalComplex,
    "for a polygonal complex",
    [IsPolygonalComplex],
    function(polygonalComplex)
    local radius,vertex;
    radius:=Length(Edges(polygonalComplex));
    for vertex in Vertices(polygonalComplex) do
        if(EccentricityOfVertex(polygonalComplex,vertex)=-1) then
            return -1;
        fi;
        radius:=Minimum(radius,EccentricityOfVertex(polygonalComplex,vertex));
    od;
    return radius;
end);


InstallMethod(CenterOfPolygonalComplex,
    "for a polygonal complex",
    [IsPolygonalComplex],
    function(polygonalComplex)
    local center,vertex;
    center:=[];
    if (DiameterOfPolygonalComplex(polygonalComplex)=-1) then
        return [];
    fi;
    for vertex in Vertices(polygonalComplex) do
        if(EccentricityOfVertex(polygonalComplex,vertex)=RadiusOfPolygonalComplex(polygonalComplex)) then
            Add(center,vertex,Length(center)+1);
        fi;
    od;
    return center;
end);

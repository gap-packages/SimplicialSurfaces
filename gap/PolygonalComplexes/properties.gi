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

InstallMethod( ButterflyCounter, "for a simplicial surface",
    [IsSimplicialSurface],
    function(surface)
	local e,temp2,counter,g,VerticesOfOrthogonalEdge,voe1,voe2,degOfVert1,degOfVert2;

        VerticesOfOrthogonalEdge:=function(S,e)
            local temp;
            temp:=FacesOfEdge(S,e);
            temp:=Union(VerticesOfFace(S,temp[1]),VerticesOfFace(S,temp[2]));
            return Difference(temp, VerticesOfEdge(S,e));
	end;
	counter:=[];
	for e in InnerEdges(surface) do 
		voe1:=VerticesOfEdge(surface,e);
		degOfVert1:=SortedList(List(voe1,g->FaceDegreeOfVertex(surface,g)));
		voe2:=VerticesOfOrthogonalEdge(surface,e);
		degOfVert2:=SortedList(List(voe2,g->FaceDegreeOfVertex(surface,g)));
		Add(counter,[degOfVert1,degOfVert2]);
	od;
	return Set(Collected(counter));
end
);


InstallMethod( UmbrellaCounter, "for a simplicial surface",
    [IsSimplicialSurface],
    function(surface)
	local n,counter,v,temp,orb,tup,G,perm,OrbitOnList,tempcounter,temp1,rightumb,bub;
	tempcounter:=[];
	if not IsClosedSurface(surface) then 
		return fail;
	fi;
	rightumb:=function(L)
		local m,temp,i,t;
		temp:=orb;		
		n:=Length(temp[1]);
		i:=2;
		m:=Minimum(temp[1]);
		temp:=Filtered(temp,g->g[1]=m);
		while temp <>[] and i<=n do 
			m:=Minimum(List(temp,g->g[i]));
			temp:=Filtered(temp,g->g[i]=m);
			i:=i+1;
			if Length(temp)=1 then
				return temp[1];
			fi; 	
		od;
		return temp[1];
	end;

	OrbitOnList:=function(G,L)
		local g,orb,temp,temp1,i,l,n;
		orb:=[];
		n:=Length(L);
		l:=[1..n];
		temp1:=[];
		for g in G do
			temp:=[]; 
			for i in [1..n] do
				temp[i]:=L[i^g];
			od;
			Add(temp1,temp);
		od;
		return temp1;
	end;
	bub:=function(list)
		local g,tempm,tempL,m;
		tempL:=[];
		tempm:=List(list,g->Length(g));
		for m in Set(tempm) do
			temp:=Filtered(list,g->Length(g)=m);
			Append(tempL,temp);
		od; 
		return tempL;
	end;
	for v in Vertices(surface) do
		temp:=UmbrellaPathOfVertex(surface,v);
		temp:=EdgesAsList(temp);
		temp:=List([1..Length(temp)-1],g->temp[g]);
		temp:=List(temp,g->Difference(VerticesOfEdge(surface,g),[v])[1]);
		temp:=List(temp,g->FaceDegreeOfVertex(surface,g));
		Add(tempcounter,temp);
	od;
	counter:=[];
	
	while tempcounter <> [] do 
		tup:=tempcounter[1];
		n:=Length(tup);
		G:=DihedralGroup(IsPermGroup,2*n);
		orb:=OrbitOnList(G,tup);
		temp:=Filtered(tempcounter,g-> g in orb);
		Add(counter,[rightumb(orb),Length(temp)]);		
		tempcounter:=Filtered(tempcounter,g-> not g in temp);		
	od; 
	temp:=bub(List(counter,g->g[1]));
	return List(temp,g->Filtered(counter,h->h[1]=g)[1]);
end
);

InstallMethod( ThreeFaceCounter, "for a simplicial surface",
    [IsSimplicialSurface],
    function(surface)
	local g,tempcounter,v,f,face,vert,vof,vof2,counter,i,temp,tup;
	tempcounter:=[];
	for v in Vertices(surface) do
		for f in FacesOfVertex(surface,v) do
			if Length(Filtered(NeighbourFacesOfFace(surface,f),g->v in VerticesOfFace(surface,g)))>=2 then 
				vof:=Filtered(VerticesOfFace(surface,f),g->g<>v);
				if FaceDegreeOfVertex(surface,vof[1])>=FaceDegreeOfVertex(surface,vof[2]) then 
					temp:=vof[1];
					vof[1]:=vof[2];
					vof[2]:=temp;
				fi;
				vof2:=[];
				for i in [1,2] do 
					face:=Filtered(Faces(surface),g->IsSubset(VerticesOfFace(surface,g),[v,vof[i]]) and g <>f)[1];
					vert:=Difference(VerticesOfFace(surface,face),[vof[i],v])[1];
					Add(vof2,vert);
				od;
				vof:=List(vof,g->FaceDegreeOfVertex(surface,g));
				vof2:=List(vof2,g->FaceDegreeOfVertex(surface,g));
				if vof[1]<=vof[2] then
					Add(tempcounter,[FaceDegreeOfVertex(surface,v),vof,vof2]);
				else
                                        Add(tempcounter,[FaceDegreeOfVertex(surface,v),[vof[2],vof[1]],[vof2[2],vof2[1]]]);
				fi;
			fi;
		od;
	od;
	return Collected(tempcounter);
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
BindGlobal( "__SIMPLICIAL_TwistedVertexTypes",
    function(complex)
        local inner, boundary, ramified, chaotic, oneRel, twoRel, vertexRel,
            chambers, v, found, inCheck, c, class;

        inner := [];
        boundary := [];
        ramified := [];
        chaotic := [];

        oneRel := OneAdjacencyRelation(complex);
        twoRel := TwoAdjacencyRelation(complex);
        vertexRel := JoinEquivalenceRelations(oneRel,twoRel);
        chambers := EquivalenceRelationPartition(vertexRel);

        for v in VerticesAttributeOfComplex(complex) do
            # Check for chaotic
            if ForAny( EdgesOfVertexNC(complex,v), e -> IsRamifiedEdgeNC(complex,e) ) then
                Add(chaotic, v);
                continue;
            fi;
            
            # Check for ramified
            found := false;
            for class in chambers do
                if IsSubset(class, ChambersOfVertexNC(complex, v)) then
                    found := true;
                fi;
            od;
            if not found then
                Add(ramified,v);
                continue;
            fi;

            # We need to distinguish between inner vertices and boundary vertices
            inCheck := true;
            for c in ChambersOfVertexNC(complex,v) do
                if TwoAdjacentChambersNC(complex,v) = [] then
                    inCheck := false;
                    break;
                fi;
            od;
            if inCheck then
                Add(inner,v);
            else
                Add(boundary,v);
            fi;
        od;

        SetInnerVertices(complex, inner);
        SetBoundaryVertices(complex, inner);
        SetRamifiedVertices(complex, ramified);
        SetChaoticVertices(complex, chaotic);
    end
);
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
        __SIMPLICIAL_TwistedVertexTypes(complex);
        return InnerVertices(complex);
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
        __SIMPLICIAL_TwistedVertexTypes(complex);
        return BoundaryVertices(complex);
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
        __SIMPLICIAL_TwistedVertexTypes(complex);
        return RamifiedVertices(complex);
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
        __SIMPLICIAL_TwistedVertexTypes(complex);
        return ChaoticVertices(complex);
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

        chambersOfFaces := ChambersOfFaces(complex);
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

#######################################
##
##      Face colouring
##

InstallMethod( FaceTwoColouring, 
    "for a polygonal complex",
	[IsPolygonalComplex],
	function(complex)
		local faces,red,blue,tempfacdeg,f,remfaces,comp,Listcomp,
		tempfaces,neighbours;
		blue:=[];
		red:=[];
		Listcomp:=StronglyConnectedComponents(complex);
		for comp in Listcomp do
			Add(blue,Faces(comp)[1]);
			remfaces := Faces(comp){[2 .. NumberOfFaces(comp)]};
			while remfaces <> [] do 
				tempfaces:=Filtered(remfaces,f->Intersection(NeighbourFacesOfFace(comp,f),Union(blue,red))<>[]);
				for f in tempfaces do 
					neighbours:=NeighbourFacesOfFace(comp,f);
					if Intersection(neighbours,blue)=[] then
						Add(blue,f);
					elif Intersection(neighbours,red)=[] then 
						Add(red,f);
					else
						return fail;
					fi;
				od;
				remfaces:=Difference(remfaces,Union(blue,red));
			od;
		od;
		return [Set(blue),Set(red)];
	end
);

##
##      End of face colouring
##
#######################################



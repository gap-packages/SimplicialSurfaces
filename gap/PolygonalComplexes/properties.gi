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

InstallMethod( IsClosedComplex, "for a polygonal complex without edge ramifications",
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
InstallMethod( IsClosedComplex, "for a twisted polygonal complex without edge ramifications",
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
InstallOtherMethod( IsClosedComplex, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        if not IsNotEdgeRamified(complex) then
            Error("IsClosedComplex: Given twisted polygonal complex complex contains ramified edges.");
        fi;
        return IsClosedComplex(complex); # Call the function above
    end
);

InstallMethod( IsClosedSurface, "for a polygonal surface",
    [IsPolygonalSurface],
    function( surf )
        return IsClosedComplex(surf);
    end
);

InstallMethod( IsMultiTetrahedralSphere, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
        local waists;
        if not (IsSimplicialSurface(complex) and IsClosedComplex(complex) and
                EulerCharacteristic(complex)=2 and IsVertexFaithful(complex)) then
                return false;
        fi;
	waists:=AllThreeWaistsOfComplex(complex);
        if Length(waists)=NumberOfFaces(complex)/2-2 then
                return true;
        else
                return false;
        fi;
end
);

InstallMethod( TetrahedralNumber, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
	if IsMultiTetrahedralSphere(complex) then
		return NumberOfFaces(complex)/2-1;
	else
		return fail;
	fi; 
    end
);
InstallMethod( TetrahedralType, "for a twisted polygonal complex",
    [IsTwistedPolygonalComplex],
    function(complex)
	local comp,v,tetratype;
	comp:=complex;
	tetratype:=[];
	if IsMultiTetrahedralSphere(complex) then
		while not ListCounter(CounterOfVertices(comp)) in [[[3,4]],[[3,2],[4,3]]] do
			Add(tetratype,Length(Filtered(Vertices(comp),
				v->FaceDegreeOfVertex(comp,v)=3)));
			comp:=InnerMultiTetrahedralSphere(comp);
		od;
		if ListCounter(CounterOfVertices(comp))=[[3,4]] then 
			Add(tetratype,1);
		fi;
		if ListCounter(CounterOfVertices(comp))=[[3,2],[4,3]] then
			Add(tetratype,2);
		fi;
	else
		return fail;
	fi;
	return tetratype;
end
);

InstallMethod( BlockType, "for a simplicial surface", 
    [IsSimplicialSurface],
    function( surface )
	local bblocks,numOfFaces,s;
	if not (EulerCharacteristic(surface)=2 and IsVertexFaithful(surface)
	and IsClosedSurface(surface)) then
		return fail;
	fi;
	bblocks:=BuildingBlocks(surface);
	numOfFaces:=List(bblocks,s->NumberOfFaces(s));
	return Collected(numOfFaces);
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

BindGlobal("CounterFamily",NewFamily("CounterFamily",IsObject,IsCounter));
DeclareRepresentation("IsCounterRep",IsCounter and IsAttributeStoringRep,[]);
BindGlobal("IsCounterType",NewType(CounterFamily,IsCounterRep));

BindGlobal( "__SIMPLICIAL_VertexCounter",
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
    end
);

DeclareRepresentation("CounterOfVerticesRep", 
    IsCounterOfVertices and IsAttributeStoringRep, []);
BindGlobal("CounterOfVerticesType", 
    NewType(CounterOfVerticesFamily, CounterOfVerticesRep));

InstallMethod( CounterOfVertices,
    "method for twisted polygonal complexes",
    [ IsTwistedPolygonalComplex ],
    function( complex )
                local counter;
		counter:=Objectify(CounterOfVerticesType,rec());
                SetListCounter(counter,__SIMPLICIAL_VertexCounter(complex));
		SetAssociatedPolygonalComplex(counter,complex);
                return counter;
    end
);

BindGlobal( "__SIMPLICIAL_EdgeCounter",
    function(complex)
        local faceDegrees, edgeDegrees;

        faceDegrees := List( FacesOfVertices(complex), Length );
        edgeDegrees := List( VerticesOfEdges(complex), vs -> List(vs, v -> faceDegrees[v]) );
        Perform( edgeDegrees, Sort );
        return Collected( Compacted( edgeDegrees ) );
    end
);

DeclareRepresentation("CounterOfEdgesRep",
    IsCounterOfEdges and IsAttributeStoringRep, []);
BindGlobal("CounterOfEdgesType",
    NewType(CounterOfEdgesFamily, CounterOfEdgesRep));

InstallMethod( CounterOfEdges,
    "method for twisted polygonal complexes",
    [ IsTwistedPolygonalComplex ],
    function( complex )
                local counter;
                counter:=Objectify(CounterOfEdgesType,rec());
                SetListCounter(counter,__SIMPLICIAL_EdgeCounter(complex));
		SetAssociatedPolygonalComplex(counter,complex);
                return counter;
    end
);

BindGlobal( "__SIMPLICIAL_FaceCounter",
    function(complex)
        local vertexDegrees, faceDegrees;

        vertexDegrees := List( FacesOfVertices(complex), Length );
        faceDegrees := List( VerticesOfFaces(complex), vs -> List(vs, v -> vertexDegrees[v]) );
        Perform( faceDegrees, Sort );
        return Collected( Compacted( faceDegrees ) );
    end
);

DeclareRepresentation("CounterOfFacesRep",
    IsCounterOfFaces and IsAttributeStoringRep, []);
BindGlobal("CounterOfFacesType",
    NewType(CounterOfFacesFamily, CounterOfFacesRep));

InstallMethod( CounterOfFaces,
    "method for twisted polygonal complexes",
    [ IsTwistedPolygonalComplex ],
    function( complex )
                local counter;
                counter:=Objectify(CounterOfFacesType,rec());
                SetListCounter(counter,__SIMPLICIAL_FaceCounter(complex));
		SetAssociatedPolygonalComplex(counter,complex);
                return counter;
    end
);

BindGlobal( "__SIMPLICIAL_ButterflyCounter",
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

DeclareRepresentation("CounterOfButterfliesRep",
    IsCounterOfButterflies and IsAttributeStoringRep, []);
BindGlobal("CounterOfButterfliesType",
    NewType(CounterOfButterfliesFamily, CounterOfButterfliesRep));

InstallMethod( CounterOfButterflies,
    "method for a simplicial surface",
    [ IsSimplicialSurface],
    function( surf )
	local counter;
	counter:=Objectify(CounterOfButterfliesType,rec());
	SetListCounter(counter,__SIMPLICIAL_ButterflyCounter(surf));
	SetAssociatedPolygonalComplex(counter,surf);
	return counter;
    end 
);


BindGlobal( "__SIMPLICIAL_UmbrellaCounter",
    function(surface)
	local n,counter,v,temp,orb,tup,G,perm,OrbitOnList,tempcounter,
	verticesOfUmb,edgesOfUmb,facdegOfVert,temp1,EquivalentLists,
	ComputeSmallestRepresentative,bub,equi,help_SortCounter;

	if not IsClosedSurface(surface) then 
		return fail;
	fi;
        #facdegList is a list of positive integers describing the face degrees
        #of the boundary vertices of a closed umbrella, whereby the degrees
        #of two neighbouring vertices of the umbrella stand next to each
	#other in the given list. Since there are different lists with the
	#same property describing the same closed umbrella, this function
	#returns all those lists. 
        EquivalentLists:=function(G,facdegList)
                local g,temp,i,EquivFacDegLists;
                EquivFacDegLists:=[];
                for g in G do
                        temp:=[];
                        for i in [1..Length(facdegList)] do
                                temp[i]:=facdegList[i^g];
                        od;
                        Add(EquivFacDegLists,temp);
                od;
                return EquivFacDegLists;
        end;



	#As mentioned before, there are different lists of integers describing
	#the same closed umbrella. This functions returns the lexicographically
	#smallest list of all the possibilities.
	ComputeSmallestRepresentative:=function(L)
		local min,tempL,i;
		tempL:=L;		
		i:=2;
		min:=Minimum(tempL[1]);
		tempL:=Filtered(tempL,g->g[1]=min);
		while tempL <>[] and i<=Length(tempL[1]) do 
			min:=Minimum(List(tempL,g->g[i]));
			tempL:=Filtered(tempL,g->g[i]=min);
			i:=i+1;
			if Length(tempL)=1 then
				return tempL[1];
			fi; 
		od;
		return tempL[1];
	end;


	#The list tcounter consists of lists of positive integers.
	#This function sorts the list tcounter with respect to
	#the length of the lists and lexicography. 
	help_SortCounter:=function(tcounter)
		local g,lengths,sortedCounter,l;
		sortedCounter:=[];
		lengths:=List(tcounter,g->Length(g));
		for l in Set(lengths) do
			temp:=Filtered(tcounter,g->Length(g)=l);
			Append(sortedCounter,Set(temp));
		od; 
		return sortedCounter;
	end;
	tempcounter:=[];
	for v in Vertices(surface) do
		edgesOfUmb:=EdgesAsList(UmbrellaPathOfVertex(surface,v));
		edgesOfUmb:=edgesOfUmb{[1..Length(edgesOfUmb)-1]};
		verticesOfUmb:=List(edgesOfUmb,g->Difference(VerticesOfEdge(surface,g),[v])[1]);
		facdegOfVert:=List(verticesOfUmb,g->FaceDegreeOfVertex(surface,g));
		Add(tempcounter,facdegOfVert);
	od;

	#tempcounter may still contain lists describing the same sequence of face
	#degrees. So the different lists have to be collected and replaced by 
	#the lexicographically smallest representative in the counter 
	counter:=[];
	while tempcounter <> [] do 
		facdegOfVert:=tempcounter[1];
		n:=Length(facdegOfVert);
		G:=DihedralGroup(IsPermGroup,2*n);
		equi:=EquivalentLists(G,facdegOfVert);
		temp:=Filtered(tempcounter,g->g in equi);
		Add(counter,[ComputeSmallestRepresentative(equi),Length(temp)]);
		tempcounter:=Filtered(tempcounter,g-> not g in temp);		
	od; 
	temp:=help_SortCounter(List(counter,g->g[1]));
	return List(temp,g->Filtered(counter,h->h[1]=g)[1]);
end
);

DeclareRepresentation("CounterOfUmbrellasRep",
    IsCounterOfUmbrellas and IsAttributeStoringRep, []);
BindGlobal("CounterOfUmbrellasType",
    NewType(CounterOfUmbrellasFamily, CounterOfUmbrellasRep));

InstallMethod( CounterOfUmbrellas,
    "method for a closed simplicial surface",
    [ IsSimplicialSurface and IsClosedSurface],
    function( surf )
	local counter;
	counter:=Objectify(CounterOfUmbrellasType,rec());
	SetListCounter(counter,__SIMPLICIAL_UmbrellaCounter(surf));
	SetAssociatedPolygonalComplex(counter,surf);
	return counter;
    end 
);

BindGlobal( "__SIMPLICIAL_ThreeFaceCounter",
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

DeclareRepresentation("CounterOfThreeFacesRep",
    IsCounterOfThreeFaces and IsAttributeStoringRep, []);
BindGlobal("CounterOfThreeFacesType",
    NewType(CounterOfThreeFacesFamily, CounterOfThreeFacesRep));

InstallMethod( CounterOfThreeFaces,
    "method for a simplicial surface",
    [ IsSimplicialSurface ],
    function( surf )
	local counter;
	counter:=Objectify(CounterOfThreeFacesType,rec());
	SetListCounter(counter,__SIMPLICIAL_ThreeFaceCounter(surf));
	SetAssociatedPolygonalComplex(counter,surf);
	return counter;
    end 
);

InstallMethod( MultiplicitiesOfDegrees,
    "method for a counter of vertices",
    [ IsCounterOfVertices ],
    function( counter)
		local counterList, maxDegree, numbers, c;
		counterList:=ListCounter(counter);
		maxDegree:=Maximum(List(counterList,c->c[1]));
		numbers:=EmptyPlist(maxDegree);
		for c in counterList do
			numbers[c[1]]:=c[2];
		od;
		return numbers;
    end
);

InstallOtherMethod( MultiplicityOfDegree,
    "method for a vertex counter and a degree",
    [ IsCounterOfVertices, IsPosInt],
    function( counter, degree)
                local tupel;
                if degree in DegreesOfCounter(counter) then
                        for tupel in ListCounter(counter) do
                                if tupel[1]=degree then
                                        return tupel[2];
                                fi;
                        od;
                else
                        Error(Concatenation("NumberOfDegree: Given counter ", String(counter),
                " does not have a vertex of degree ", String(degree), "." ));
                fi;
    end
);

InstallMethod( MultiplicityOfDegree,
    "method for a counter and a degree list",
    [ IsCounter, IsList],
    function( counter, degree)
                local tupel;
                if degree in DegreesOfCounter(counter) then
                        for tupel in ListCounter(counter) do
                                if tupel[1]=degree then
                                        return tupel[2];
                                fi;
                        od;
                else
                        Error(Concatenation("NumberOfDegree: Given counter ", String(counter),
                " does not have a vertex of degree ", String(degree), "." ));
                fi;
    end
);

InstallMethod( DegreesOfCounter,
    "method for a counter",
    [ IsCounter ],
    function(counter)
		return List(ListCounter(counter),c->c[1]);
    end
);
InstallMethod( MultiplicitiesOfCounter,
    "method for a counter",
    [ IsCounter ],
    function( counter)
		return List(ListCounter(counter),c->c[2]);
    end
);
InstallMethod( DegreesOfMultiplicities,
    "method for a counter",
    [ IsCounter ],
    function(counter)
		local counterList, number, degrees, c;
		counterList:=ListCounter(counter);
		number:=Maximum(List(counterList,c->c[2]));
		degrees:=EmptyPlist(number);
		for c in counterList do
			if IsBound(degrees[c[2]]) then
				Add(degrees[c[2]],c[1]);
			else
				degrees[c[2]]:=[c[1]];
			fi;
		od;
		return degrees;
    end
);
InstallMethod( DegreesOfMultiplicity,
    "method for a counter and an integer",
    [ IsCounter, IsPosInt],
    function( counter, multiplicity)
		if IsBound(DegreesOfMultiplicities(counter)[multiplicity]) then
			return DegreesOfMultiplicities(counter)[multiplicity];
		else 
			Error(Concatenation("DegreesOfNumber: Given counter ", String(counter), 
                " does not have ", String(multiplicity), " of same degree." ));
		fi;
    end
);

InstallMethod( \=, "for two counters", 
    [IsCounter, IsCounter],
    function(counter1, counter2)
        return ListCounter(counter1)=ListCounter(counter2);
    end
);

InstallMethod( \<, "for two counters", 
    [IsCounter, IsCounter],
    function(counter1, counter2)
        return ListCounter(counter1)<ListCounter(counter2);
    end
);

BindGlobal( "__SIMPLICIAL_CounterName",
    function(counter, big)
        local nameList;

        if big then
            nameList := ["CounterOfVertices", "CounterOfEdges", 
                "CounterOfFaces", "CounterOfButterlies",
                "CounterOfUmbrellas", "CounterOfThreeFaces","CounterOfVerticesByAngle", "Counter"];
        else
            nameList := ["counter of vertices", "counter of edges", 
                "counter of faces", "counter of butterlies",
                "counter of umbrellas", "counter of three faces","counter of vertices by angle", "counter"];
        fi;

        if IsCounterOfVertices(counter) then
            return nameList[1];
        elif IsCounterOfEdges(counter) then
            return nameList[2];
        elif IsCounterOfFaces(counter) then
            return nameList[3];
        elif IsCounterOfButterflies(counter) then
            return nameList[4];
		elif IsCounterOfUmbrellas(counter) then
            return nameList[5];
        elif IsCounterOfThreeFaces(counter) then
            return nameList[6];
        elif IsCounterOfVerticesByAngle(counter) then
            return nameList[7];
        else
            return nameList[8];
        fi;
    end
);

InstallMethod(TypeOfCounter, "for a counter",
	[IsCounter],
	function(counter)
		 Print(__SIMPLICIAL_CounterName(counter,true)); 
	end
);

InstallOtherMethod( ViewInformation, "for a counter", 
    [IsCounter],
    function(counter)
        local strList, str, out;

        strList := [];
        str := "";
        out := OutputTextString(str,true);
        PrintTo( out, __SIMPLICIAL_CounterName(counter, false) );
        PrintTo(out, " (");
        CloseStream(out);
        Add( strList, [str, 0] );

        Add( strList, [Concatenation(String(DegreesOfCounter(counter)), " degrees"), 1] );
        Add( strList, [", and ", 0] );
        Add( strList, [Concatenation(String(MultiplicitiesOfCounter(counter)), " multiplicities"), 2] );
        Add( strList, [")", 0] );

        return strList;
    end
);


InstallMethod(ViewObj,"for a counter", [IsCounter],
	function(counter)
	    if SIMPLICIAL_COLOURS_ON then
                __SIMPLICIAL_PrintColourString( ViewInformation(counter), 
                    [ SIMPLICIAL_COLOURS_VERTICES, 
                        SIMPLICIAL_COLOURS_EDGES]);
            else
                Print(__SIMPLICIAL_UncolouredString( ViewInformation(counter) ));
            fi;
	end
);

InstallMethod( String, "for a counter", [IsCounter],
    function(counter)
        local str, out, name;
        
        str := "";
        out := OutputTextString(str,true);
	name:=__SIMPLICIAL_CounterName(counter,true);

        PrintTo(out, name);
	PrintTo(out, "( ");
        PrintTo(out, AssociatedPolygonalComplex(counter));
        PrintTo(out, ", ");
        PrintTo(out, ListCounter(counter));
        PrintTo(out, ")");

        CloseStream(out);
        return str;
    end
);

InstallOtherMethod(DisplayInformation, "for a counter", [IsCounter],
    function(counter)
	local strList, str, out;
	strList:=[];
	str := "";
        out := OutputTextString(str, true);
        PrintTo(out, __SIMPLICIAL_CounterName(counter, true) );
	PrintTo(out,  "\n");
	Add( strList, [ str, 0 ] );
	
	Add( strList, [ Concatenation(
            "    DegreesOfCounter : ",
            String(DegreesOfCounter(counter)), "\n"), 1 ] );
	Add( strList, [ Concatenation(
            "    MultiplicitiesOfCounter : ",
            String(MultiplicitiesOfCounter(counter)), "\n"), 2 ] );
	Add( strList, [ Concatenation(
            "    ListCounter : ", 
            String(ListCounter(counter)), "\n"), 3 ] );
	return strList;
    end
);

InstallMethod(Display, "for a counter", [IsCounter],
    function(counter)
    	if SIMPLICIAL_COLOURS_ON then
               __SIMPLICIAL_PrintColourString( DisplayInformation(counter), 
                    [ SIMPLICIAL_COLOURS_VERTICES, SIMPLICIAL_COLOURS_EDGES, SIMPLICIAL_COLOURS_FACES ]);
            else
               Print(__SIMPLICIAL_UncolouredString( DisplayInformation(counter) ));
            fi;
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
    [IsTwistedPolygonalComplex and IsClosedComplex],
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
    [IsTwistedPolygonalComplex and IsClosedComplex],
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

InstallMethod( IsTurnableEdge, "for a simplicial surface and an edge",
    [IsSimplicialSurface, IsPosInt],
    function(surface, edge)
        __SIMPLICIAL_CheckEdge(surface, edge, "IsTurnableEdge");
        return IsTurnableEdgeNC(surface, edge);
    end
);

InstallMethod(TurnableEdges,"for a simplicial surface",
    [IsSimplicialSurface],
    function(surface)
	local res,voe1,voe2,foe,edge;
	res:=[];
	for edge in Edges(surface) do 
		voe1:=VerticesOfEdge(surface,edge);
		foe:=FacesOfEdge(surface,edge);
		voe2:=Union(VerticesOfFaces(surface){foe});
		voe2:=Difference(voe2,voe1);
		if Length(voe2)>=2 and not voe2 in VerticesOfEdges(surface) then
			Add(res,edge);
		fi;
	od;
	return res;
    end
);

InstallMethod( IsTurnableEdgeNC, "for a simplicial surface and an edge",
    [IsSimplicialSurface, IsPosInt],
    function(surface, edge)
        return edge in TurnableEdges(surface);
    end
);

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
    [IsPolygonalComplex and IsClosedComplex],
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

#######################################
##
##      epimorphic images 
##

## this function returns the possibillies to identy the edges of Faces eof1 and eof2 in edges=[eof1,eof2]
## in order to construct an admissible relation
BindGlobal( "__SIMPLICIAL_MendableEdgeAssignments",
function(surface,edges,verticesOfEdges,intSec)
    local g,edgeAssign,vof1,vof2,arrangements,eov1,eov2,i,
    edge1,edge2,ee,eof,help,res,help2,help1,v,inter;

    arrangements:=Arrangements(edges[2],3);
    edgeAssign:=List([1..6],i->[edges[1],arrangements[i]]);
    res:=[];
    help1:=function(surface,ee)
	local i,v1,v2;
	for i in [[1,2],[1,3],[2,3]] do 
	    v1:=intSec[ee[1][i[1]]][ee[1][i[2]]][1];
	    v2:=intSec[ee[2][i[1]]][ee[2][i[2]]][1];
	    if Set([v1,v2]) in verticesOfEdges then 
		return false; 
	    fi;
	od;
	return true;
    end;
    help2:=function(surface,ee)
	local i,v1,v2;
	v1:=[];
	v2:=[];
	for i in [[1,2],[1,3],[2,3]] do 
	    Add(v1,intSec[ee[1][i[1]]][ee[1][i[2]]][1]);
	    Add(v2,intSec[ee[2][i[1]]][ee[2][i[2]]][1]);
	od;
	inter:=Intersection(v1,v2);
	for v in inter do
		if Position(v1,v)<>Position(v2,v) then
			return false;
		fi;
	od;
	return true;
    end;
    return Filtered(edgeAssign,ee->help1(surface,ee) and help2(surface,ee));
  end
);

BindGlobal( "__SIMPLICIAL_Mendable",
    function(surface,v,eof,edgesOfFaces,verticesOfEdges,intSec)
	local temp,res,ee,mendable,edgeAssign,lm;
	temp:=Arrangements(eof,3);
	res:=[];
	if edgesOfFaces=[] then 
	    return [eof];
	fi;
	mendable:=List(edgesOfFaces,ee->__SIMPLICIAL_MendableEdgeAssignments(surface,[ee,eof],verticesOfEdges,intSec));
	lm:=Length(mendable);
	if not [] in mendable then
	    for ee in temp do
		if IsBound(Filtered(mendable,edgeAssign->Filtered(edgeAssign,e->e[2]=ee)<>[])[lm]) then	
		    Add(res,ee);
		fi;
	    od;
	fi;
	return res;
   end
);

## This function returns a tuple [s,equiv], where s is a simplicial surface and equiv is the ordered list containing the partitions of the vertices,edges and faces 
# of the admissible relation 'relation' or fail if relation does not give rise to a simplical surface 
BindGlobal( "__SIMPLICIAL_SimplicialSurfaceByRelation",
    function(surface,relation,verticesOfEdges,intSec)
	local g,vertexClasses,i,cl,f,EdgeClasses,visitedEdges,ee,vv,
	vClass,edges,edgeClasses,eof,edge,vc1,vc2,voe,j,temp,vertices,e,edgesOfClasses,
	eClass,edges1,edges2,tempE,tempE2,v,numV,numE,edgesOfFaces;
	edgesOfClasses:=List(relation,r->Union(r));

       ## construct the partition of the edges
	edges:=[];	
	edgeClasses:=[];
	edgesOfFaces:=EdgesOfFaces(surface);
	for cl in relation do
	    for i in [1,2,3] do
		temp:=List(cl, f-> f[i]);
		edges:=Union(edges,[Set(temp)]);
	    od;	
	od;
	for eClass in edges do
	    temp:=Filtered(edges,e->Intersection(e,eClass)<>[]);
	    temp:=Union(temp);
	    while temp<> eClass do
		eClass:=Union(eClass,temp);
		temp:=Filtered(edges,e->Intersection(e,eClass)<>[]);
		temp:=Union(temp);
	    od;
	    if IsBound(Filtered(edgesOfClasses,e->Intersection(e,eClass)<>[])[3]) then 
		return fail;
	    fi;
	    edgeClasses:=Union(edgeClasses,[eClass]);
	od;
	## construct the partition of the vertices
	vertexClasses:=[];
	vertices:=[];
	for cl in relation do
	    for i in [[1,2],[2,3],[1,3]] do
		temp:=List(cl, f->intSec[f[i[1]]][f[i[2]]][1]);
		vertices:=Union(vertices,[Set(temp)]);
	    od;
	od;
	for vClass in vertices do
	    temp:=Filtered(vertices,vv->Intersection(vv,vClass)<>[]);
	    temp:=Union(temp);
	    while temp<> vClass do
		vClass:=Union(vClass,temp);
		temp:=Filtered(vertices,vv->Intersection(vv,vClass)<>[]);
		temp:=Union(temp);
	    od;
	    vertexClasses:=Union(vertexClasses,[vClass]);
	od;
	## construct incidences
	numE:=Length(edgeClasses);
	numV:=Length(vertexClasses);
	voe:=[];
	for edge in edgeClasses do
	    temp:=Union(List(edge,e->verticesOfEdges[e]));
	    e:=Filtered([1..numV],i->Intersection(vertexClasses[i],temp)<>[]);
	    Add(voe,e);
	od;
	visitedEdges:=[];
	eof:=[];
	for cl in relation do 		
	    f:=Filtered([1..numE],i->Intersection(edgeClasses[i],Union(cl))<>[]);
	    Add(eof,f);
	od;
	if Set(List(eof,f->Length(Set(f))))<>[3] or Set(List(voe,e->Length(Set(e))))<>[2] then 
	    return fail;
	fi;
	
	## construct partition of the faces
	temp:=List(relation,cl->Set(List(cl,f->Position(edgesOfFaces,Set(f)))));
	temp:=[vertexClasses,edgeClasses,temp];
	return [TriangularComplexByDownwardIncidenceNC(voe,eof),temp];
    end
);

# checks whether the edges of the face face have ramifications 
BindGlobal( "__SIMPLICIAL_IsNotEdgeRamFace",
    function(relation,face)
	local g,vertexClasses,verticesOfEdges,i,cl,f,EdgeClasses,visitedEdges,ee,vv,
	vClass,edges,edgeClasses,eof,edge,vc1,vc2,voe,j,temp,vertices,e,edgesOfClasses,
	eClass;

	edgesOfClasses:=List(relation,r->Union(r));
	edges:=[];	
	edgeClasses:=[];

	for cl in relation do
		for i in [1,2,3] do
			temp:=List(cl,f-> f[i]);
			edges:=Union(edges,[Set(temp)]);
		od;	
	od;

	for e in face do 
		temp:=Union(Filtered(edges,cl-> e in cl));
		eClass:=[];
		while temp <> eClass do
			eClass:=Union(eClass,temp);
			temp:=Filtered(edges,e->Intersection(e,eClass)<>[]);
			temp:=Union(temp);
		od;
		if IsBound(Filtered(edgesOfClasses,e->Intersection(e,eClass)<>[])[3]) then
			return false;
		fi;	
	od;
	return true;
end
);
BindGlobal( "__SIMPLICIAL_nextVertexHelp",
    function(surface,v,relation,faces,neighbours,edgesOfFaces,facesOfVertices)
	local vv,eof,f,temp;
	temp:=List(Union(relation),eof->Set(eof));
	temp:=Filtered(faces,f->edgesOfFaces[f] in temp);
	temp:=Filtered(neighbours[v],vv->Difference(facesOfVertices[vv],temp)<>[]);
	if temp <>[] then 
	    return temp[1];
	else 
	    return 0;
	fi;
    end
);


BindGlobal( "__SIMPLICIAL_nextFace",
    function(surface,v,relation,facesOfVertices,edgesOfFaces,edgesOfVertices)
	local foe,edgesOfFaces2,temp,eof,ee;
	foe:=facesOfVertices[v];
	foe:=edgesOfFaces{foe};
	edgesOfFaces2:=List(Union(relation),ee->Set(ee));
	foe:=Difference(foe,edgesOfFaces2);
	temp:=Intersection(Union(edgesOfFaces2),edgesOfVertices[v]);
	temp:=Filtered(foe,eof->Intersection(eof,temp)<>[]);
	if temp=[] then 
	    return 0;
	else
	    return temp[1];
	fi;
    end
);


BindGlobal( "__SIMPLICIAL_AddFaceToRelation",
    function(surface,v,eof,relation,verticesOfEdges,facesOfVertices,edgesOfFaces,edgesOfVertices,intSec)
	local edgesOfClasses,edges,r,filtered,res,mendable,l,f,cl,fil,i,j,ee,temp,
	umbClass,facesOfVert,face,n,e,eov,pos,lr;

	res:=[];
	r:=Length(relation);
	lr:=[1..r];

	eov:=Intersection(eof,edgesOfVertices[v]);
	edgesOfClasses:=List(relation,cl->Union(cl));
	facesOfVert:=facesOfVertices[v];
	facesOfVert:=edgesOfFaces{facesOfVert};
	umbClass:=Filtered(lr,i->Intersection(List(relation[i],f->Set(f)),facesOfVert)<>[]);

	#add next face to one of the faceClasses of the vertex
	for i in lr do
	    mendable:=__SIMPLICIAL_Mendable(surface,v,eof,relation[i],verticesOfEdges,intSec);
	    for ee in mendable do
		temp:=List(lr,l->ShallowCopy(relation[l]));
		AddSet(temp[i],ee);
		Add(res,temp);
	    od;
	od;

	# l is the number of the class neighbouring eof
	l:=Filtered(umbClass,i->Intersection(eov,edgesOfClasses[i])<>[])[1];
	e:=Intersection(edgesOfClasses[l],eov)[1];
	pos:=0;
	face:=relation[l];
	for i in [1,2,3] do 
	    if e in List(face,f->f[i]) then 
		pos:=i;
	    fi;
	od;
	edges:=List(face,f->f[pos]);
	n:=Filtered(lr,i->Intersection(edges,edgesOfClasses[i])<>[] and l<>i);
	if n<>[] then
	    n:=n[1];
	    mendable:=__SIMPLICIAL_Mendable(surface,v,eof,relation[n],verticesOfEdges,intSec);
	    for ee in mendable do
		temp:=List(lr,l->ShallowCopy(relation[l]));
		AddSet(temp[n],ee);
		Add(res,temp);
	    od;
	else
	    temp:=List(lr,i->ShallowCopy(relation[i]));
	    Add(temp,[eof]);
	    Add(res,temp);
	fi;		
	return Filtered(res,r->__SIMPLICIAL_IsNotEdgeRamFace(r,eof));
end
);

# the function returns a list of tuples [s,rel] where s is a simplicial surface and the rel is a admissible relation
# on the given surface 'surface' that gives rise to s. 
# Note that this function only focuses on admissible relation that yield butterfly friendly epimorphism from surface to s.
# The idea is to build the adissible relation from scratch by adding more and more simplicies to the relation.
# As data structure we use the edges of faces to carry on the computations, whereby the position of the edges is important for the admissible relation.
# So the implementation uses equivalence classes that consists of edges of faces. For example if faces f_1=[1,2,3] and f_2=[6,5,4] happen to be in the same
# class [f_1,f_2] then the following holds:
# - In our relation f_1 and f_2 are identified. 
# - the edge pairs 1,6 and 2,5 and 3,4 get identified
# From this information we can also deduce the identified vertices by forming intersection 
# Strategy: We start from an vertex of the vertex and aim to build admissible relations containing the umbrella of the vertex. And then go on to add the umbrellas of
# the neighbouring vertices to the umbrella and so on. 
BindGlobal( "__SIMPLICIAL_AdmissibleRelationsHelp",
function(surface,relation,bool,bool2)
    local visitedFaces,visitedVertices,remainingVertices,v,vertices,
	facesOfVertex,remainingFaces,relations,f,eof,rel,edgesOfFaces,temp,next,
	vert,temp2,s,verticesOfEdges,numFaces,vis,faces,neighbours,
	facesOfVertices,edgesOfVertices,intSec,res;

	## initialize the needed information
	numFaces:=NumberOfFaces(surface);
	verticesOfEdges:=VerticesOfEdges(surface);
	edgesOfFaces:=EdgesOfFaces(surface);
	facesOfVertices:=FacesOfVertices(surface);
	vertices:=Vertices(surface);
	edgesOfVertices:=EdgesOfVertices(surface);
	visitedFaces:=List(Union(relation),eof->Set(eof));
	temp:=List(visitedFaces,eof->Position(edgesOfFaces,eof));
	visitedVertices:=Filtered(vertices,v->IsSubset(temp,FacesOfVertex(surface,v)));
	v:=0;
	neighbours:=List(vertices,v->NeighbourVerticesOfVertex(surface,v));
	faces:=Faces(surface);
	intSec:=List(verticesOfEdges,voe1->List(verticesOfEdges,voe2->Intersection(voe1,voe2)));
	for vert in visitedVertices do
	    next:=__SIMPLICIAL_nextVertexHelp(surface,vert,relation,faces,neighbours,edgesOfFaces,facesOfVertices); 
	    if next<>0 then 
		v:=next;
	    fi;
	od;
	if v=0 and visitedVertices<>vertices then
	    vert:=Filtered(vertices,vert->Intersection(temp,facesOfVertices[vert])<>[]);
	    v:=vert[1];
        fi;

        ### main function
        relations:=[relation];
        vis:=Length(visitedFaces);
        while vis <> numFaces do
	    f:=__SIMPLICIAL_nextFace(surface,v,relations[1],facesOfVertices,edgesOfFaces,edgesOfVertices);
	    while f<>0 do
		if bool2 then 
		    Print("visited", vis, "faces\n" );
		fi;

	        relations:=Union(List(relations,
		rel->__SIMPLICIAL_AddFaceToRelation(surface,v,f,rel,verticesOfEdges,facesOfVertices,edgesOfFaces,edgesOfVertices,intSec)));
	        Add(visitedFaces,f);
	        vis:=vis+1;
	        f:=__SIMPLICIAL_nextFace(surface,v,relations[1],facesOfVertices,edgesOfFaces,edgesOfVertices);
	    od;
	    Add(visitedVertices,v);
	    if vis <> numFaces then 
		v:=__SIMPLICIAL_nextVertexHelp(surface,v,relations[1],faces,neighbours,edgesOfFaces,facesOfVertices);
	    fi;
	od;

	## just for the change of the return
	res:=[];
	if bool then 
	    for rel in relations do 
		s:=__SIMPLICIAL_SimplicialSurfaceByRelation(surface,rel,verticesOfEdges,intSec);
		if s <>fail then 
		    Add(res,s);
		fi;
	    od;
	else
	    temp2:=Set([]);
	    for rel in relations do 
		temp:=__SIMPLICIAL_SimplicialSurfaceByRelation(surface,rel,verticesOfEdges,intSec);
		if temp<>fail then 
		    s:=CanonicalRepresentativeOfPolygonalSurface(temp[1])[1];
		    if not s in temp2 then 
			AddSet(temp2,s);
			Add(res,temp);
		    fi;
		fi;	
	    od;
	fi;
	return res;

    end
);


InstallMethod( AdmissibleRelationsOfSurface, 
    "for a simplicial surface and a bool",
    [IsSimplicialSurface,IsBool,IsBool],
    function(surface,bool,bool2)	
	return __SIMPLICIAL_AdmissibleRelationsHelp(surface,[[EdgesOfFaces(surface)[1]]],bool,bool2);
  
end
);

InstallOtherMethod( AdmissibleRelationsOfSurface, 
    "for a simplicial surface and a bool",
    [IsSimplicialSurface,IsBool],
    function(surface,bool)	
	return __SIMPLICIAL_AdmissibleRelationsHelp(surface,[[EdgesOfFaces(surface)[1]]],bool,false);  
end
);


##
##      End of epimorphic images
##
#######################################

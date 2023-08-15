StartPositions:=function(n)
	local d,D,temp,i;
	temp:=[];
	if n=1 then 
		return [[1,1]];
	elif n=2 then
		return [[0,4],[4,4]];
	elif n=3 then 
		return [[0,4],[4,4],[4,0]];	
	elif n mod 4=0 then
		d:=n/4;	
		D:=n/1;
		for i in [0..d-1] do
			Add(temp,[i*4,D]);
		od;
		for i in [0..d-1] do
			Add(temp,[D,D-i*4]);
		od;
		for i in [0..d-1] do
			Add(temp,[D-i*4,0]);
		od;
		for i in [0..d-1] do
			Add(temp,[0,i*4]);
		od;
	elif n mod 4=1 then
		d:=(n-1)/4;
		D:=(n-1);
		for i in [0..d] do
			Add(temp,[i*D/(d+1),D]);
		od;
		for i in [0..d-1] do
			Add(temp,[D,D-i*4]);
		od;
		for i in [0..d-1] do
			Add(temp,[D-i*4,0]);
		od;
		for i in [0..d-1] do
			Add(temp,[0,i*4]);
		od;
	elif n mod 4=2 then
		d:=(n-2)/4;
		D:=n-2;
		for i in [0..d] do
			Add(temp,[i*D/(d+1),D]);
		od;
		for i in [0..d-1] do
			Add(temp,[D,D-i*4]);
		od;
		for i in [0..d] do
			Add(temp,[D-i*D/(d+1),0]);
		od;
		for i in [0..d-1] do
			Add(temp,[0,i*4]);
		od;
	elif n mod 4=3 then	 
		d:=(n-3)/4;
		D:=n-3;
		for i in [0..d] do
			Add(temp,[i*D/(d+1),D]);
		od;
		for i in [0..d] do
			Add(temp,[D,D-i*D/(d+1)]);
		od;
		for i in [0..d] do
			Add(temp,[D-i*D/(d+1),0]);
		od;
		for i in [0..d-1] do
			Add(temp,[0,i*D/4]);
		od;
	fi;
	return temp;
end;

StartPositions:=function(n)
	local temp,pi,i;
	pi:=3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481;
	temp:=[];
	for i in [1..n] do
		Add(temp,1000*[Cos(2*pi*i/n+pi/2),Sin(2*pi*i/n+pi/2)]);
	od;
	temp:=List(temp,i->[Int(i[1]),Int(i[2])]);
	return temp;
end;;


ListFromCycle:=function(cyc)
	local i,G,b,a;
	i:=1;
	G:=Group(cyc);	
	while i^cyc=i do 
		i:=i+1;
	od;
	a:=Orbit(G,i);
	return List([1..Size(a)],i->a[i]);      
end;

Tutte:=function(s,weight)
	local temp,umbrellas,sol1,sol2,b1,b2,vectors1,vectors2,faceDeg,faces,i,m,umb,n,j,vec1,vec2,facePositions;
	#weight:=0.7;
	faceDeg:=FaceDegreesOfVertices(s);
	umbrellas:=UmbrellaDescriptorOfSurface(s);	
	umbrellas:=List(umbrellas,umb->ListFromCycle(umb));
	m:=Maximum(faceDeg);
	umb:=Filtered(umbrellas,umb->Size(umb)=m)[1];
	facePositions:=[];
	temp:=StartPositions(m);	
	for i in [1..m] do 
		facePositions[umb[i]]:=temp[i];
	od;
	##solving equations
	faces:=Difference(Faces(s),umb);
	b1:=[];
	b2:=[];
	vectors1:=[];
	vectors2:=[];
	if faces=[] then 
		return temp;
	fi;
	for i in faces do
		Add(b1,0);
		Add(b2,0);
		vec1:=[];
		vec2:=[];
	 	for j in Faces(s) do 
			if i=j then 
				Add(vec1,-1);
				Add(vec2,-1);
			elif j in NeighbourFacesOfFace(s,i) then
				if j in umb then 
					b1[Length(b1)]:=b1[Length(b1)]-weight*facePositions[j][1];
					b2[Length(b2)]:=b2[Length(b2)]-weight*facePositions[j][2];
					Add(vec1,0);
					Add(vec2,0);
				else
					Add(vec1,(1-weight)/2);
					Add(vec2,(1-weight)/2);

				fi; 			
	
			else
				Add(vec1,0);
				Add(vec2,0);
			fi;
		od;
		
		Add(vectors1,vec1 );
		Add(vectors2,vec2 );
	od;
	vectors1:=TransposedMat(vectors1);
	vectors2:=TransposedMat(vectors2);
	sol1:=SolutionMat(vectors1,b1);
	sol2:=SolutionMat(vectors2,b2);
	for j in faces do
		facePositions[j]:=[sol1[j],sol2[j]];
	od;
	return 1.*facePositions;
	
end;

#for e in Edges(q8) do
#	voe:=VerticesOfEdge(s,e);
#	vector:=coordinates[voe[1]]-coordinates[voe[2]];
#	Print(Sqrt(vector[1]^2+vector[2]^2+vector[3]^2),"\n");
#od;#
#
#
#
#
#
#

#AllCyclesOfLength(graph,3);
#cycles:=Set(List(last,l->Set(l)));
#cycles_vertices:=List(cycles,i->Set(Concatenation(i)));
#edges;

#faceCoordinates2D_new:=pr.faceCoordinates2D;
#q8_old:=q8;
#for v in Vertices(q8_old) do
#    if DegreeOfVertex(q8_old,v)=3 then
#         q8:=TetrahedralReduction(q8,v);
#         Add(faceCoordinates2D_new,Sum(faceCoordinates2D_new{FacesOfVertex(q8_old,v)})/3);
#    fi;
#od;




Tutte_v:=function(s,weight,v)
	local temp,umbrellas,sol1,sol2,b1,b2,vectors1,vectors2,faceDeg,faces,i,m,umb,n,j,vec1,vec2,facePositions;
	#weight:=0.7;
	faceDeg:=FaceDegreesOfVertices(s);
	umbrellas:=UmbrellaDescriptorOfSurface(s);	
	umb:=List(umbrellas,umb->ListFromCycle(umb))[v];
	facePositions:=[];
	m:=DegreeOfVertex(s,v);
	temp:=StartPositions(m);	
	for i in [1..m] do 
		facePositions[umb[i]]:=temp[i];
	od;
	##solving equations
	faces:=Difference(Faces(s),umb);
	b1:=[];
	b2:=[];
	vectors1:=[];
	vectors2:=[];
	if faces=[] then 
		return temp;
	fi;
	for i in faces do
		Add(b1,0);
		Add(b2,0);
		vec1:=[];
		vec2:=[];
	 	for j in Faces(s) do 
			if i=j then 
				Add(vec1,-1);
				Add(vec2,-1);
			elif j in NeighbourFacesOfFace(s,i) then
				if j in umb then 
					b1[Length(b1)]:=b1[Length(b1)]-weight*facePositions[j][1];
					b2[Length(b2)]:=b2[Length(b2)]-weight*facePositions[j][2];
					Add(vec1,0);
					Add(vec2,0);
				else
					Add(vec1,(1-weight)/2);
					Add(vec2,(1-weight)/2);

				fi; 			
	
			else
				Add(vec1,0);
				Add(vec2,0);
			fi;
		od;
		
		Add(vectors1,vec1 );
		Add(vectors2,vec2 );
	od;
	vectors1:=TransposedMat(vectors1);
	vectors2:=TransposedMat(vectors2);
	sol1:=SolutionMat(vectors1,b1);
	sol2:=SolutionMat(vectors2,b2);
	for j in faces do
		facePositions[j]:=[sol1[j],sol2[j]];
	od;
	return 1.*facePositions;
	
end;










StraightLineEmbeddingOfCyclicGraph:=function(n,file) 
	local alpha,len,tempC,coordinates,mat,g,s;
	alpha:=2*3.14159265358979323846/n;
	len:=10*help_norm([Cos(alpha)-Cos(alpha*2),Sin(alpha)-Sin(alpha*2),0.]);
	tempC:=len*[[1,0]+1/2.*[Cos(alpha)-1,Sin(alpha)],
		   [1,0]+1/4.*[Cos(alpha)-1,Sin(alpha)],
		   [1,0]+1/2.*[Cos(alpha)-1,Sin(alpha)]+1.5*[Sin(alpha),1-Cos(alpha)],
		   [1,0]+1/2.*[Cos(alpha)-1,Sin(alpha)]+2*[Sin(alpha),1-Cos(alpha)],
		   [1,0]+3/4.*[Cos(alpha)-1,Sin(alpha)],
		   [1,0]+1/2.*[Cos(alpha)-1,Sin(alpha)]+[Sin(alpha),1-Cos(alpha)]];
	coordinates:=ShallowCopy(tempC);
	mat:=[[Cos(alpha),-Sin(alpha)],[Sin(alpha),Cos(alpha)]];
	g:=CycleFromList([1..n])*CycleFromList([n+1..2*n])*CycleFromList([2*n+1..3*n]);
	G:=GroupByGenerators([g]);
	#North pol is 3*n+1^south pol is 2*n+2

	tempF:=[[n+1,2*n+1,3*n+2],[2,n+1,3*n+2],[1,2,n+1],[1,2,3*n+1],[1,2*n+1,3*n+2],[1,n+1,2*n+1]];
	tempF:=[[n+1,2*n+1,3*n+2],[1,2*n+1,3*n+2],[1,2,n+1],[1,2,3*n+1],[2,n+1,3*n+2],[1,n+1,2*n+1]];
	vof:=ShallowCopy(tempF);
	for i in [1..n-1] do
		for j in [1..6] do
			Add(coordinates,mat^(i)*tempC[j]); 
			Add(vof,[tempF[j][1]^(g^i),tempF[j][2]^(g^i),tempF[j][3]^(g^i)]);		
		od;
	od;
	s:=SimplicialSurfaceByVerticesInFaces(vof);
	DrawFacegraphToTikz(s,file,rec(faceCoordinates2D:=0.1*coordinates));
	return [s,coordinates];
end;

StraightLineEmbeddingOfDihedralGraph:=function(n,file) 
	local alpha,len,tempC,coordinates,mat,g,s;
	alpha:=2*3.14159265358979323846/n;
	len:=10*help_norm([Cos(alpha)-Cos(alpha*2),Sin(alpha)-Sin(alpha*2),0.]);
	tempC:=len*[[1,0]+3/4.*[Cos(alpha)-1,Sin(alpha)],
		   [1,0]+1/4.*[Cos(alpha)-1,Sin(alpha)],
		   [1,0]+1/2.*[Cos(alpha)-1,Sin(alpha)]+.5*[Sin(alpha),1-Cos(alpha)],
		   [1,0]+1/2.*[Cos(alpha)-1,Sin(alpha)]+1*[Sin(alpha),1-Cos(alpha)]];
	coordinates:=ShallowCopy(tempC);
	mat:=[[Cos(alpha),-Sin(alpha)],[Sin(alpha),Cos(alpha)]];
	g:=CycleFromList([1..n])*CycleFromList([n+1..2*n]);
	G:=GroupByGenerators([g]);
	#North pol is 3*n+1^south pol is 2*n+2
	tempF:=[[2,n+1,2*n+2],[1,n+1,2*n+2],[1,2,n+1],[1,2,2*n+1]];
	vof:=ShallowCopy(tempF);
	for i in [1..n-1] do
		for j in [1..4] do
			Add(coordinates,mat^(i)*tempC[j]); 
			Add(vof,[tempF[j][1]^(g^i),tempF[j][2]^(g^i),tempF[j][3]^(g^i)]);		
		od;
	od;
	s:=SimplicialSurfaceByVerticesInFaces(vof);
	DrawFacegraphToTikz(s,file,rec(faceCoordinates2D:=0.1*coordinates));
	return [s,coordinates];
end;

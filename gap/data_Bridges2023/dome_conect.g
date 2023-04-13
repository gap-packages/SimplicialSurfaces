# The following function returns two blocks that connect a tube 
# with angle blocks dividing the unit circle in 4*m patches
TubeConnectPlanar:=function(n)
	local pi,t,temp,norm,dist,add,coordinates1,coordinates2,s1,s2,faces;
	if not n mod 4 = 0 then
		Print("The input value ",n," is not divisible by 4!");
		return fail;
	fi;
	pi:=3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481;
	faces:=[
	[1,4,10],[12,14,2],   [14,3,2],

	[5,6,13],[7,8,9],[11,7,9],[15,5,13],

	[1,9,11],[12,15,5],
	[5,12,2],[5,6,2],[6,2,13],[4,8,7],[4,8,9],[4,9,1],[4,10,7],[13,3,2],[13,14,3],

	[11,15,7],[7,15,13],[7,13,10],[10,13,14],[10,14,1],[1,14,12],[1,12,11],[11,12,15]
	];;
	s1:=SimplicialSurfaceByVerticesInFaces(faces);
	s2:=SimplicialSurfaceByVerticesInFaces(faces);
	t:=[Cos(2*pi/n),Sin(2*pi/n)]-[Cos(2*pi*2/n),Sin(2*pi*2/n)];
	temp:=Sqrt(t[1]^2+t[2]^2);
	norm:=1./temp;
	dist:=Sqrt(norm^2-0.5^2);
	
	add:=Ceil(dist+1)-dist+0.5;

	coordinates1:=[ [ 0, 0, 0 ], [ 1, 1+add, 0 ], [ 2, add, 0 ], [ 1, -1, 0 ], [ 0, 1+add, 1 ], [ 1, 1+add, 1 ], [ 1, 0, 1 ], [ 1, -1, 1 ], [ 0, -1, 1 ], [ 1, 0, 0 ], [ 0, 0, 1 ] , [0,add,0],[ 1, add, 1 ],[ 1, add, 0 ], [ 0, add, 1 ]]*1.;

	add:=Ceil(dist)-dist+0.5;

	coordinates2:=[ [ 0, 0, 0 ], [ 1, 1+add, 0 ], [ 2, add, 0 ], [ 1, -1, 0 ], [ 0, 1+add, 1 ], [ 1, 1+add, 1 ], [ 1, 0, 1 ], [ 1, -1, 1 ], [ 0, -1, 1 ], [ 1, 0, 0 ], [ 0, 0, 1 ] , [0,add,0],[ 1, add, 1 ],[ 1, add, 0 ], [ 0, add, 1 ]]*1.;

	return [[s1,coordinates1],[s2,coordinates2]];
end;;


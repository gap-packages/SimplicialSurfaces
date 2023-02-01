# The following function returns two blocks that connect tubes
# diving the unit circle in n resp. m blocks, 
# where 4 divides m and m divides n
TubesConnect:=function(n,m)
	local pi,t,temp,norm,dist1,dist2,add,height,coordinates1,coordinates2,faces,s1,s2;

	#coordinates:=[[0,0,0],[1,0,0],[1,1,0],
	#				[0,1,1],
	#				[1,1,2],[0,1,2],
	#				[1,1+add,2],[0,1+add,2],
	#				[1,2+add,2],[0,2+add,2],
	#				[0,0,3],[1,0,3],[0,1,3],[1,1,3],
	#				[0,1+add,3],[1,1+add,3],
	#				[1,2+add,3]
	#				];

	pi:=3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481;
	t:=[Cos(2*pi/n),Sin(2*pi/n)]-[Cos(2*pi*2/n),Sin(2*pi*2/n)];
	temp:=Sqrt(t[1]^2+t[2]^2);
	norm:=1./temp;
	dist1:=Sqrt(norm^2-0.5^2);
	n:=m;
	t:=[Cos(2*pi/n),Sin(2*pi/n)]-[Cos(2*pi*2/n),Sin(2*pi*2/n)];
	temp:=Sqrt(t[1]^2+t[2]^2);
	norm:=1./temp;
	dist2:=Sqrt(norm^2-0.5^2);
	add:=dist1-dist2-1;
	height:=1;
	
	coordinates1:=[[0,0,0],[1,0,0],[1,1,0],
					[0,1,1],
					[1,1,1+height],[0,1,1+height],
					[1,1+add,1+height],[0,1+add,1+height],
					[1,2+add,1+height],[0,2+add,1+height],
					[0,0,2+height],[1,0,2+height],,
					[0,1+add,2+height],
					[1,2+add,2+height]
					];


	

	faces:=[[11,12,14],[12,14,15],
			[1,2,3],[1,3,4],[5,7,6],[6,7,8],[7,8,9],[8,9,10],
			[1,2,11],[2,11,12],
			[2,3,5],[2,5,12],[5,7,12],[7,12,15],[7,9,15],
			[1,4,6],[1,6,11],[6,11,14],[10,8,14],[6,8,14],
			[9,10,15],[10,14,15],[3,4,5],[4,5,6]];
	s1:=SimplicialSurfaceByVerticesInFaces(faces);

	## second stone



	coordinates2:=[[0,0,0],[1,0,0],[1,1,0],
					[0,1,1],[1,1,1],[1,2+add,1],[0,2+add,1],
					[0,0,2],[1,0,2],[0,1,2],
					[0,1+add,2],
					[1,2+add,2],
					[0,2+add,3]];

	faces:=[[1,2,3],[1,3,4],[4,5,7],[5,6,7],
			[1,2,8],[2,8,9],
			[8,9,10],[9,10,12],[10,11,12],[11,12,13],
			[3,4,5],[6,12,13],[6,7,13],
			[2,3,5],[2,5,9],[5,9,12],[5,6,12],
			[1,4,8],[4,8,10],[4,10,11],[4,7,11],[7,11,13]];

	s2:=SimplicialSurfaceByVerticesInFaces(faces);
	return [[s1,coordinates1],[s2,coordinates2]];

end;;

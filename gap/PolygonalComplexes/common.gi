InstallMethod(CommonVerticesOfEdgesNC,
	"for a polygonal complex and two positive integers",
	[IsVEFComplex,IsPosInt,IsPosInt],
	function(complex,edge1,edge2)
		return Intersection(VerticesOfEdge(complex,edge1),VerticesOfEdge(complex,edge2));
	end
);

InstallMethod(CommonVerticesOfEdges,
	"for a polygonal complex and two positive integers",
	[IsVEFComplex,IsPosInt,IsPosInt],
	function(complex,edge1,edge2)
		__SIMPLICIAL_CheckEdge( complex, edge1, "CommonVerticesOfEdges" );
		__SIMPLICIAL_CheckEdge( complex, edge2, "CommonVerticesOfEdges" );
		return CommonVerticesOfEdgesNC(complex,edge1,edge2);
	end
);

InstallMethod(CommonVerticesOfEdgesNC,
	"for a polygonal complex and a list",
	[IsVEFComplex,IsList],
	function(complex,edgeList)
		local vertices,e,comb,vertex;
		if Length(edgeList)>1 then
			vertices:=[];
			comb:=Combinations(edgeList,2);
			for e in [1..Length(comb)] do
				if e>1 then
					vertices:=Intersection(vertices,CommonVerticesOfEdgesNC(complex,comb[e][1],comb[e][2]));
				else
					vertices:=CommonVerticesOfEdgesNC(complex,comb[e][1],comb[e][2]);
				fi;
			od;
			return vertices;
		elif List(edgeList)=1 then
			return VerticesOfEdge(complex,edgeList[1]);
		else
			return [];
		fi;
	end
);

InstallMethod(CommonVerticesOfEdges,
	"for a polygonal complex and a list",
	[IsVEFComplex,IsList],
	function(complex,edgeList)
		local e;
		for e in edgeList do
			__SIMPLICIAL_CheckEdge( complex, e, "CommonVerticesOfEdges" );
		od;
		return CommonVerticesOfEdgesNC(complex, edgeList);
	end
);

InstallMethod(CommonEdgesOfFacesNC,
	"for a polygonal complex and two positive integers",
	[IsVEFComplex,IsPosInt,IsPosInt],
	function(complex,face1,face2)
		return Intersection(EdgesOfFace(complex,face1),EdgesOfFace(complex,face2));
	end
);

InstallMethod(CommonEdgesOfFaces,
	"for a polygonal complex and two positive integers",
	[IsVEFComplex,IsPosInt,IsPosInt],
	function(complex,face1,face2)
		__SIMPLICIAL_CheckFace( complex, face1, "CommonEdgesOfFaces" );
		__SIMPLICIAL_CheckFace( complex, face2, "CommonEdgesOfFaces" );
		return CommonEdgesOfFacesNC(complex,face1,face2);
	end
);


InstallMethod(CommonEdgesOfFacesNC,
	"for a polygonal complex and a list",
	[IsVEFComplex,IsList],
	function(complex,faceList)
		local edges,comb,e;
		if Length(faceList)>1 then
			edges:=[];
			comb:=Combinations(faceList,2);
			for e in [1..Length(comb)] do
				if e>1 then
					edges:=Intersection(edges,CommonEdgesOfFaces(complex,comb[e][1],comb[e][2]));
				else
					edges:=CommonEdgesOfFaces(complex,comb[e][1],comb[e][2]);
				fi;
			od;
			return edges;
		elif List(faceList)=1 then
			return EdgesOfFace(complex,faceList[1]);
		else
			return [];
		fi;
	end
);

InstallMethod(CommonEdgesOfFaces,
	"for a polygonal complex and a list",
	[IsVEFComplex,IsList],
	function(complex,faceList)
		local f;
		for f in faceList do
			__SIMPLICIAL_CheckFace( complex, f, "CommonEdgesOfFaces" );
		od;
		return CommonEdgesOfFacesNC(complex,faceList);
	end
);

InstallMethod(CommonVerticesOfFacesNC,
	"for a polygonal complex and two positive integers",
	[IsVEFComplex,IsPosInt,IsPosInt],
	function(complex,face1,face2)
		return Intersection(VerticesOfFace(complex,face1),VerticesOfFace(complex,face2));
	end
);

InstallMethod(CommonVerticesOfFaces,
	"for a polygonal complex and two positive integers",
	[IsVEFComplex,IsPosInt,IsPosInt],
	function(complex,face1,face2)
		__SIMPLICIAL_CheckFace( complex, face1, "CommonVerticesOfFaces" );
		__SIMPLICIAL_CheckFace( complex, face2, "CommonVerticesOfFaces" );
		return CommonVerticesOfFacesNC(complex,face1,face2);
	end
);

InstallMethod(CommonVerticesOfFacesNC,
	"for a polygonal complex and a list",
	[IsVEFComplex,IsList],
	function(complex,faceList)
		local vertices,comb,f;
		if Length(faceList)>1 then
			vertices:=[];
			comb:=Combinations(faceList,2);
			for f in [1..Length(comb)] do
				if f>1 then
					vertices:=Intersection(vertices,CommonVerticesOfFacesNC(complex,comb[f][1],comb[f][2]));
				else
					vertices:=CommonVerticesOfFacesNC(complex,comb[f][1],comb[f][2]);
				fi;
			od;
			return vertices;
		elif Length(faceList)=1 then	
			return VerticesOfFace(complex,faceList[1]);
		else
			return [];
		fi;
	end
);

InstallMethod(CommonVerticesOfFaces,
	"for a polygonal complex and a list",
	[IsVEFComplex,IsList],
	function(complex,faceList)
		local f;
		for f in faceList do
			__SIMPLICIAL_CheckFace( complex, f, "CommonVerticesOfFaces" );
		od;
		return CommonVerticesOfFacesNC(complex,faceList);
	end
);


InstallMethod(CommonEdgesOfVerticesNC,
	"for a polygonal complex and two positive integers",
	[IsVEFComplex,IsPosInt,IsPosInt],
	function(complex,vertex1,vertex2)
		return Intersection(EdgesOfVertex(complex,vertex1),EdgesOfVertex(complex,vertex2));
	end
);

InstallMethod(CommonEdgesOfVertices,
	"for a polygonal complex and two positive integers",
	[IsVEFComplex,IsPosInt,IsPosInt],
	function(complex,vertex1,vertex2)
		__SIMPLICIAL_CheckVertex( complex, vertex1, "CommonEdgesOfVertices" );
		__SIMPLICIAL_CheckVertex( complex, vertex2, "CommonEdgesOfVertices" );
		return CommonEdgesOfVerticesNC(complex,vertex1,vertex2);
	end
);


InstallMethod(CommonFacesOfEdgesNC,
	"for a polygonal complex and two positive integers",
	[IsVEFComplex,IsPosInt,IsPosInt],
	function(complex,edge1,edge2)
		return Intersection(FacesOfEdge(complex,edge1),FacesOfEdge(complex,edge2));
	end
);

InstallMethod(CommonFacesOfEdges,
	"for a polygonal complex and two positive integers",
	[IsVEFComplex,IsPosInt,IsPosInt],
	function(complex,edge1,edge2)
		__SIMPLICIAL_CheckEdge( complex, edge1, "CommonFacesOfEdges" );
		__SIMPLICIAL_CheckEdge( complex, edge2, "CommonFacesOfEdges" );
		return CommonFacesOfEdgesNC(complex,edge1,edge2);
	end
);

InstallMethod(CommonFacesOfEdgesNC,
	"for a polygonal complex and a list",
	[IsVEFComplex,IsList],
	function(complex,edgeList)
			local faces,comb,f;
		if Length(edgeList)>1 then
			faces:=[];
			comb:=Combinations(edgeList,2);
			for f in [1..Length(comb)] do
				if f>1 then
					faces:=Intersection(faces,CommonFacesOfEdges(complex,comb[f][1],comb[f][2]));
				else
					faces:=CommonFacesOfEdges(complex,comb[f][1],comb[f][2]);
				fi;
			od;
			return faces;
		elif List(edgeList)=1 then
			return FacesOfEdge(complex,edgeList[1]);
		else
			return [];
		fi;
	end
);

InstallMethod(CommonFacesOfEdges,
	"for a polygonal complex and a list",
	[IsVEFComplex,IsList],
	function(complex,edgeList)
		local e;
		for e in edgeList do
			__SIMPLICIAL_CheckEdge( complex, e, "CommonFacesOfEdges" );
		od;
		return CommonFacesOfEdgesNC(complex,edgeList);
	end
);

InstallMethod(CommonFacesOfVerticesNC,
	"for a polygonal complex and two positive integers",
	[IsVEFComplex,IsPosInt,IsPosInt],
	function(complex,vertex1,vertex2)
		return Intersection(FacesOfVertex(complex,vertex1),FacesOfVertex(complex,vertex2));
	end
);

InstallMethod(CommonFacesOfVertices,
	"for a polygonal complex and two positive integers",
	[IsVEFComplex,IsPosInt,IsPosInt],
	function(complex,vertex1,vertex2)
		__SIMPLICIAL_CheckVertex( complex, vertex1, "CommonFacesOfVertices" );
		__SIMPLICIAL_CheckVertex( complex, vertex2, "CommonFacesOfVertices" );
		return CommonFacesOfVerticesNC(complex,vertex1,vertex2);
	end
);

InstallMethod(CommonFacesOfVerticesNC,
	"for a polygonal complex and a list",
	[IsVEFComplex,IsList],
	function(complex,vertexList)
		local faces,comb,f;
		if Length(vertexList)>1 then
			faces:=[];
			comb:=Combinations(vertexList,2);
			for f in [1..Length(comb)] do
				if f>1 then
					faces:=Intersection(faces,CommonFacesOfVerticesNC(complex,comb[f][1],comb[f][2]));
				else
					faces:=CommonFacesOfVerticesNC(complex,comb[f][1],comb[f][2]);
				fi;
			od;
			return faces;
		elif List(vertexList)=1 then
			return FacesOfVertex(complex,vertexList[1]);
		else
			return [];
		fi;
	end
);

InstallMethod(CommonFacesOfVertices,
	"for a polygonal complex and a list",
	[IsVEFComplex,IsList],
	function(complex,vertexList)
		local v;
		for v in vertexList do
			__SIMPLICIAL_CheckVertex( complex, v, "CommonFacesOfVertices" );
		od;
		return CommonFacesOfVerticesNC(complex,vertexList);
	end
);
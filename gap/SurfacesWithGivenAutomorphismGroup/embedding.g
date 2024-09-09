GetNewVertex:=function(V1,V2,V3)
  local crossProduct,r1,r2,p;
  crossProduct:=function(A,B)
    local CP;
    CP:=[A[2]*B[3]-A[3]*B[2],
	 A[3]*B[1]-A[1]*B[3],
	 A[1]*B[2]-A[2]*B[1]];
    return 1./Sqrt(CP[1]*CP[1]+CP[2]*CP[2]+CP[3]*CP[3])*CP;
  end;
  r1:=V2-V1;
  r2:=V3-V1;
  p:=V1+1./3*(r1+r2);
  return p+Sqrt(6.)/3*crossProduct(r1,r2);
end;

helpEmbeddingOfSixCompletion:=function(n,l,k,index,file)
  local coordinates,vert,nnorm,vof,height1,height2,norm,points,i,j,S,coor,
         pi,c,edges,v,face,temp,faces,f;
  coordinates:=[];
  vof:=[];
  pi:=3.14159;
  nnorm:=function(v)
    return Sqrt(v[1]^2+v[2]^2+v[3]^2);
  end;
  norm:=Sqrt((Sin(4*pi*l/n)-Sin(2*pi*l/n))^2+(Cos(4*pi*l/n)-Cos(2*pi*l/n))^2);
  points:=[List([1..n],i-> (1/norm)*[Cos(2*pi*i*l/n),Sin(2*pi*i*l/n),0.]),
        List([1..n],i-> (1/norm)*[Cos(2*pi*i*l/n+pi*l/n), Sin(2*pi*i*l/n+pi*l/n),0.])]; 
  height1:=Sqrt(1-points[1][1][1]^2-points[1][1][2]^2);
  if n=6 then
    height1:=0; 
  fi;
  height2:=Sqrt(1-(points[1][1][1]-points[2][1][1])^2-
                  (points[1][1][2]-points[2][1][2])^2);
  for i in [1..k+1] do 
    Append(coordinates,List(points[2-(i mod 2)],coor->coor-[0.,0.,(i-1)*height2]));
  od;
  c:=Length(coordinates);
  Add(coordinates,[0.,0.,height1]);
  Add(coordinates,[0.,0.,-(k)*height2-height1]);	
  Add(points[1],points[1][1]);
  Add(points[2],points[2][1]);

  Add(vof,[c+1,1,n]);
  Add(vof,[c+2,c-n+1,c]);
  for i in [1..n-1] do 
    Add(vof,[c+1,i,i+1]);
    Add(vof,[c+2,c-n+i,c-n+i+1]);
  od; 

  for i in [1..n-1] do 
    for j in [0..k-1] do
      if j mod 2 =0 then 
        Add(vof,[j*n+i,j*n+i+1,(j+1)*n+i]);
        Add(vof,[j*n+i+1,(j+1)*n+i,(j+1)*n+i+1]);
      else
        Add(vof,[(j+1)*n+i,(j+1)*n+i+1,(j)*n+i]);
        Add(vof,[j*n+i,(j)*n+i+1,(j+1)*n+i+1]);
      fi;
    od;
  od;
  for j in [0..k-1] do 
    if j mod 2 =0 then
      Add(vof,[j*n+1,(j+1)*n+1,(j+1)*n+n]);
      Add(vof,[(j)*n+1,(j+1)*n,(j+2)*n]);
    else
      Add(vof,[(j+1)*n,(j+1)*n+1,(j+2)*n]);
      Add(vof,[(j)*n+1,(j+1)*n,(j+1)*n+1]);
    fi;
  od;
  S:=SimplicialSurfaceByVerticesInFaces(vof);
  if index=0 then 
    DrawSurfaceToJavaScript(S,file,rec(vertexCoordinates3D:=coordinates));
    return [S,coordinates];
  fi;
  faces:=UmbrellaPathOfVertex(S,c+1);
  edges:=EdgesAsList(faces);	
  faces:=FacesAsList(faces);
  if index=2 then 
    for i in [1..Length(edges)-1] do
      faces:=Intersection(Faces(S),faces);
      face:=Filtered(faces,f->IsSubset(EdgesOfFace(S,f),[edges[i],edges[i+1]]))[1];
      temp:=TetrahedralExtension(S,face);
      vert:=VerticesOfFace(S,face);
      face:=Filtered(Difference(Faces(temp),Faces(S)),
                     f->edges[i] in EdgesOfFace(temp,f))[1];
      S:=TetrahedralExtension(temp,face);
      vert:=VerticesOfEdge(S,edges[i]);
      v:=Difference(VerticesOfEdge(S,edges[i+1]),vert)[1];
      vert:=coordinates{vert};
      coordinates[Length(coordinates)+1]:=GetNewVertex(vert[1],vert[2],coordinates[v]);
      coordinates[Length(coordinates)+1]:=
        GetNewVertex(vert[1],vert[2],coordinates[Length(coordinates)]);
    od;
  else
    for i in [1..Length(edges)-1] do
      faces:=Intersection(Faces(S),faces);
      face:=Filtered(faces,f->IsSubset(EdgesOfFace(S,f),[edges[i],edges[i+1]]))[1];
      S:=TetrahedralExtension(S,face);
      vert:=VerticesOfEdge(S,edges[i]);
      v:=Difference(VerticesOfEdge(S,edges[i+1]),vert)[1];
      vert:=coordinates{vert};
      coordinates[Length(coordinates)+1]:=GetNewVertex(vert[1],vert[2],coordinates[v]);
    od;
  fi;
  DrawSurfaceToJavaScript(S,file,rec(vertexCoordinates3D:=coordinates));
  return [S,coordinates];	
end;

EmbeddingOfSimplicialSurfaceWithCyclicAutomorphismGroup:=function(n,l,k,file)
  return helpEmbeddingOfSixCompletion(n,l,k,2,file)
end;

EmbeddingOfSimplicialSurfaceWithDihedralAutomorphismGroup:=function(n,l,k,file)
  return helpEmbeddingOfSixCompletion(n,l,k,1,file)
end;

#Edge Stone
#alpha ist der Winkel für den Eckstein
AngleStone:=function(alpha,i)
  local coordinates, faces;
  if not IsInt(i) or i*1.<1. or i*1.>4. then
    Print("i has to be an Integer between 1 and 4");
    return fail;
  fi;

  alpha:=3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481/(360*1./alpha);
  if i=1 then
    coordinates:=[[2,2,-Sqrt(2.)],
    [2,0,-Sqrt(2.)],
    [2,2,0],
    [1,1,0],
    [2+Sin(alpha),2-Sin(alpha),-Sqrt(2.)*Cos(alpha)],
    [3+Sin(alpha)+Cos(alpha),3-Sin(alpha)-Cos(alpha),-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],
    [1+Sin(alpha)+Cos(alpha),1-Sin(alpha)-Cos(alpha),-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],
    [4,2,-Sqrt(2.)],
    [3,3,0]]*1/Sqrt(2.);

    faces:=[ [ 1, 2, 4 ], [ 1, 3, 4 ], [ 1, 8, 9 ], [ 1, 3, 9 ], [ 4, 5, 7 ], [ 5, 6, 9 ], [ 2, 4, 7 ], [ 6, 8, 9 ], [ 5, 6, 8 ], 
      [ 2, 5, 7 ], [ 1, 5, 8 ], [ 1, 2, 5 ], [ 3, 5, 9 ], [ 3, 4, 5 ] ];
    return [coordinates,SimplicialSurfaceByVerticesInFaces(faces)];
  elif i=2 then
    coordinates:=[[2,2,-Sqrt(2.)],
    [2,0,-Sqrt(2.)],
    [2,2,0],
    [1,1,0],
    [2+Sin(alpha),2-Sin(alpha),-Sqrt(2.)*Cos(alpha)],
    [3+Sin(alpha)+Cos(alpha),3-Sin(alpha)-Cos(alpha),-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],
    [1+Sin(alpha)+Cos(alpha),1-Sin(alpha)-Cos(alpha),-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],
    [4,2,-Sqrt(2.)],
    [3,3,0]]*1/Sqrt(2.);

  # second version
  faces:=[ [ 1, 2, 4 ], [ 1, 3, 4 ], [ 1, 8, 9 ], [ 1, 3, 9 ], [ 4, 5, 7 ], [ 5, 6, 9 ], [ 2, 4, 7 ], [ 6, 8, 9 ], [ 5, 6, 8 ], 
    [ 2, 5, 7 ],  [ 3, 5, 9 ], [ 3, 4, 5 ],[2,8,1],[2,8,5] ];
    return [coordinates,SimplicialSurfaceByVerticesInFaces(faces)];
  elif i=3 then
    
  #third version

  coordinates:=[[2,2,-Sqrt(2.)],
  [2,0,-Sqrt(2.)],
  [2,2,0],
  [1,1,0],
  [2+Sin(alpha),2-Sin(alpha),-Sqrt(2.)*Cos(alpha)],
  [3+Sin(alpha)+Cos(alpha),3-Sin(alpha)-Cos(alpha),-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],
  [1+Sin(alpha)+Cos(alpha),1-Sin(alpha)-Cos(alpha),-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],
  [4,2,-Sqrt(2.)],
  [3,3,0],[3,1,-Sqrt(2.)]]*1/Sqrt(2.);

  faces:=[ [ 1, 2, 4 ], [ 1, 3, 4 ], [ 1, 8, 9 ], [ 1, 3, 9 ], [ 4, 5, 7 ], [ 5, 6, 9 ], [ 2, 4, 7 ], [ 6, 8, 9 ], [ 10, 6, 8 ], 
    [ 2, 10, 7 ],  [ 3, 5, 9 ], [ 3, 4, 5 ],[2,10,1],[10,8,1],[5,10,7],[5,10,6]];
    return [coordinates,SimplicialSurfaceByVerticesInFaces(faces)];
    
   # fourth version
   
   # watch out for 90 degrees! Does not work for it
  elif i=4 then 
   coordinates:=[[2,2,-Sqrt(2.)],
  [2,0,-Sqrt(2.)],
  [1,1,0],
  [2+Sin(alpha),2-Sin(alpha),-Sqrt(2.)*Cos(alpha)],
  [3+Sin(alpha)+Cos(alpha),3-Sin(alpha)-Cos(alpha),-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],
  [1+Sin(alpha)+Cos(alpha),1-Sin(alpha)-Cos(alpha),-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],
  [4,2,-Sqrt(2.)],
  [3,3,0],[3,1,-Sqrt(2.)]]*1/Sqrt(2.);
   
  faces:=[ [ 1, 2, 3 ], [ 1, 7, 8 ], [ 1, 3, 8 ], [ 3, 4, 6 ], [ 4, 5, 8 ], [ 2, 3, 6 ], [ 5, 7, 8 ], [ 5, 7, 9 ], [ 2, 6, 9 ], [ 3, 4, 8 ], 
    [ 1, 2, 9 ], [ 1, 7, 9 ], [ 4, 5, 6 ], [ 5, 6, 9 ] ];
    return [coordinates,SimplicialSurfaceByVerticesInFaces(faces)];
  fi;
end;;
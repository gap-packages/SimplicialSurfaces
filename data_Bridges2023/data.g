## This file contains the data for the construction kit introduced in the paper "Topological Interlocking, Truchet Tiles and Self-Assemblies: A Construction-Kit for 
## Civil Engineering Design" by Reymond Akpanya, Tom Goertzen, Sebastian Wiesenhuetter, Alice C. Niemeyer and Jorg Noenning. 
## TODO Description
##

#######################################
##
##      data of versatile block 

coordinatesOfVersatileBlock:=[[0,0,0],[2,0,0],[2,-2,0],[0,-2,0],[1,1,1],[2,0,1],[1,-1,1],[0,-2,1],[-1,-1,1]];;
facesOfVersatileBlock:=[[1,2,4],[2,3,4],[5,6,7],[7,8,9],[5,7,9],[1,9,5],[5,1,2],[5,6,2],[6,2,7],[7,2,3],[7,3,4],[4,8,7],[4,8,9],[4,9,1]];;

##
## 
#######################################
#######################################
##
##      data of curved versatile block with 45 degree rotation 

facesOfCurvedVersatileBlock:=[[1,2,4],[2,3,4],[5,6,7],[7,8,9],[5,7,9],[1,9,5],[5,1,2],[5,6,2],[6,2,7],[7,2,3],[7,3,4],[4,8,7],[4,8,9],[4,9,1]];;
coordinatesOfCurvedVersatileBlock:=[ [ 0., 0., 0. ], [ 0.152232, -2., 2.76535 ], [ 0.917578, 0., 4.61311 ], [ 0.152232, 2., 2.76535 ], [ 2., -2., 0. ], [ 2., -2., 2. ], [ 2., 0., 2. ], 
  [ 2., 2., 2. ], [ 2., 2., 0. ]];

##
## 
#######################################
#######################################
##
##      data of edge stone (Version 1) with 90 degree rotation

alpha:=3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481/4;
coordinatesOfEdgeStone1:=[[2,2,-Sqrt(2.)],
[2,0,-Sqrt(2.)],[2,2,0],[1,1,0],[2+Sin(alpha),2-Sin(alpha),-Sqrt(2.)*Cos(alpha)],[3+Sin(alpha)+Cos(alpha),3-Sin(alpha)-Cos(alpha),-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],[1+Sin(alpha)+Cos(alpha),1-Sin(alpha)-Cos(alpha),-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],[4,2,-Sqrt(2.)],[3,3,0]]*1/Sqrt(2.);

facesOfEdgeStone1:=[ [ 1, 2, 4 ], [ 1, 3, 4 ], [ 1, 8, 9 ], [ 1, 3, 9 ], [ 4, 5, 7 ], [ 5, 6, 9 ], [ 2, 4, 7 ], [ 6, 8, 9 ], [ 5, 6, 8 ], 
  [ 2, 5, 7 ], [ 1, 5, 8 ], [ 1, 2, 5 ], [ 3, 5, 9 ], [ 3, 4, 5 ] ];

##
##
#######################################
#######################################
##
##      data of edge stone (Version 2) with 45 degree rotation

alpha:=3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481/4;
coordinatesOfEdgeStone2:=[[2,2,-Sqrt(2.)],
[2,0,-Sqrt(2.)],[2,2,0],[1,1,0],[2+Sin(alpha),2-Sin(alpha),-Sqrt(2.)*Cos(alpha)],[3+Sin(alpha)+Cos(alpha),3-Sin(alpha)-Cos(alpha),-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],[1+Sin(alpha)+Cos(alpha),1-Sin(alpha)-Cos(alpha),-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],[4,2,-Sqrt(2.)],[3,3,0]]*1/Sqrt(2.);
facesOfEdgeStone2:=[ [ 1, 2, 4 ], [ 1, 3, 4 ], [ 1, 8, 9 ], [ 1, 3, 9 ], [ 4, 5, 7 ], [ 5, 6, 9 ], [ 2, 4, 7 ], [ 6, 8, 9 ], [ 5, 6, 8 ], 
  [ 2, 5, 7 ],  [ 3, 5, 9 ], [ 3, 4, 5 ],[2,8,1],[2,8,5] ];

##
##
#######################################
#######################################
##
##      data of edge stone (Version 3) with 90 degree rotation

##
##
#######################################
#######################################
##
##      data of edge stone (Version 4) with 45 degree rotation 
##      watch out for 90 degrees! Does not work for it.

alpha:=3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481/4;
coordinatesOfEdgeStone4:=[[2,2,-Sqrt(2.)],[2,0,-Sqrt(2.)],[1,1,0],[2+Sin(alpha),2-Sin(alpha),-Sqrt(2.)*Cos(alpha)],[3+Sin(alpha)+Cos(alpha),3-Sin(alpha)-Cos(alpha),-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],[1+Sin(alpha)+Cos(alpha),1-Sin(alpha)-Cos(alpha),-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],[4,2,-Sqrt(2.)],[3,3,0],[3,1,-Sqrt(2.)]]*1/Sqrt(2.);
 
facesOfEdgeStone4:=[ [ 1, 2, 3 ], [ 1, 7, 8 ], [ 1, 3, 8 ], [ 3, 4, 6 ], [ 4, 5, 8 ], [ 2, 3, 6 ], [ 5, 7, 8 ], [ 5, 7, 9 ], [ 2, 6, 9 ], [ 3, 4, 8 ], 
  [ 1, 2, 9 ], [ 1, 7, 9 ], [ 4, 5, 6 ], [ 5, 6, 9 ] ];

##
##
#######################################
#######################################
##
##    data dome connect stone TODO

##
##
#######################################





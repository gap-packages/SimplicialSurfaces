gap> complex:=PolygonalComplexByDownwardIncidence([,,,,,[2,5],,[2,3],[3,5],[11,5],,[3,7],[7,11]],[[6,8,9],,,[9,10,12,13]]);;
gap> flagComp:=FlagComplex(complex);;
gap> OriginalVertices(flagComp);
[ 2, 3, 5, 7, 11 ]
gap> OriginalEdges(flagComp);
[ 6, 8, 9, 10, 12, 13 ]
gap> OriginalFaces(flagComp);
[ 1, 4 ]
gap> L1:=[];;
gap> for g in [1..5] do
> Add(L1,OriginalOneFlag(flagComp,g));
> od;
gap> L1;
[ [ 0, 2 ], [ 0, 3 ], [ 0, 5 ], [ 0, 7 ], [ 0, 11 ] ]
gap> L1:=[];;                            
gap> for g in [6..10] do
> Add(L1,OriginalOneFlag(flagComp,g));
> od;
gap> L1;
[ [ 1, 6 ], [ 1, 8 ], [ 1, 9 ], [ 1, 10 ], [ 1, 12 ] ]
gap> L1:=[];;                            
gap> for g in [11..13] do
> Add(L1,OriginalOneFlag(flagComp,g));
> od;
gap> L1;
[ [ 1, 13 ], [ 2, 1 ], [ 2, 4 ] ]
gap> M1:=[];;
gap> for g in [1..26] do
> Add(M1,OriginalTwoFlag(flagComp,g));
> od;
gap> M1;
[ [ 1, [ 2, 6 ] ], [ 1, [ 2, 8 ] ], [ 1, [ 3, 8 ] ], [ 1, [ 3, 9 ] ], 
  [ 1, [ 3, 12 ] ], [ 1, [ 5, 6 ] ], [ 1, [ 5, 9 ] ], [ 1, [ 5, 10 ] ], 
  [ 1, [ 7, 12 ] ], [ 1, [ 7, 13 ] ], [ 1, [ 11, 10 ] ], [ 1, [ 11, 13 ] ], 
  [ 2, [ 2, 1 ] ], [ 2, [ 3, 1 ] ], [ 2, [ 3, 4 ] ], [ 2, [ 5, 1 ] ], 
  [ 2, [ 5, 4 ] ], [ 2, [ 7, 4 ] ], [ 2, [ 11, 4 ] ], [ 3, [ 6, 1 ] ], 
  [ 3, [ 8, 1 ] ], [ 3, [ 9, 1 ] ], [ 3, [ 9, 4 ] ], [ 3, [ 10, 4 ] ], 
  [ 3, [ 12, 4 ] ], [ 3, [ 13, 4 ] ] ]
gap> N1:=[];;
gap> for g in [1..14] do
> Add(N1,OriginalThreeFlag(flagComp,g));
> od;
gap> N1;
[ [ 2, 6, 1 ], [ 2, 8, 1 ], [ 3, 8, 1 ], [ 3, 9, 1 ], [ 3, 9, 4 ], 
  [ 3, 12, 4 ], [ 5, 6, 1 ], [ 5, 9, 1 ], [ 5, 9, 4 ], [ 5, 10, 4 ], 
  [ 7, 12, 4 ], [ 7, 13, 4 ], [ 11, 10, 4 ], [ 11, 13, 4 ] ]
gap> L2:=[];;
gap> for g in Vertices(complex) do 
> Add(L2,BarycentreOfVertex(complex,g));
> od;
gap> L2;
[ 1, 2, 3, 4, 5 ]
gap> M2:=[];;
gap> for g in Edges(complex) do
> Add(M2,BarycentreOfEdge(complex,g));
> od;
gap> M2;
[ 6, 7, 8, 9, 10, 11 ]
gap> N2:=[];;
gap> for g in Faces(complex) do
> Add(N2,BarycentreOfFace(complex,g));
> od;
gap> N2;
[ 12, 13 ]

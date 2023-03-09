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
####################################### functions to investigate the versatile block 



## GAP-CODE for Possible Planar Assemblies using Truchet Tiles
#Here we use the first version of the coordinates of the divine block.
#We also give a function that generates a random $m\times n$ assembly.

coordinates_middle:=[[0,0,0],[2,0,0],[2,-2,0],[0,-2,0]];;

coordinates_up:=[
			[1,1,1],[2,0,1],[1,-1,1],[0,-2,1],[-1,-1,1]
];;

coordinates:=Concatenation(coordinates_middle,coordinates_up);;

coordinates:=coordinates*    DiagonalMat([1,1,Sqrt(2.)]);;

#middle connected to upper part
faces_up_middle:=[
[1,2,3],[1,3,4],

[5,6,7],[7,8,9],[5,7,9],

[1,9,5],[5,1,2],[5,6,2],[6,2,7],[7,2,3],[7,3,4],[4,8,7],[4,8,9],[4,9,1]

];;


s:=SimplicialSurfaceByVerticesInFaces(faces_up_middle);;
pr:=SetVertexCoordinates3D(s,coordinates);;

vof:=VerticesOfFaces(s);

#  courdinate ways:

rot90:=[[0,1,0],[-1,0,0],[0,0,1]];;

coordinates;;

coordinates90:=coordinates*rot90-[0,2,0];

coordinates180:=coordinates*rot90^2-[-2,2,0];

coordinates270:=coordinates*rot90^3+[2,0,0];

ul:=coordinates;

ll:=coordinates90;

lr:=coordinates180;

ur:=coordinates270;


assembly_matrix:=[[lr,ur,ur,ur,lr],[ll,ul,ul,ul,ll],[lr,ur,ur,ur,lr],[lr,ur,ur,ur,lr],[lr,ur,ur,ur,lr]];

#assembly_matrix:=[[ll,ul],[lr,ur]];

#assembly_matrix:=[[lr,ur,lr],[ll,ul,ll],[lr,ur,lr]];

vof_assembly:=Concatenation(List([1..Size(assembly_matrix)],i->Concatenation(List([1..Size(assembly_matrix[1])],j->vof+NumberOfVertices(s)*((i-1)*Size(assembly_matrix[1])+(j-1))))));

coordinates_assembly:=Concatenation(List([1..Size(assembly_matrix)],j->Concatenation(List([1..Size(assembly_matrix[1])],i->assembly_matrix[i][j]+(j-1)*[2,0,0]+(i-1)*[0,-2,0]))));

s_assembly:=SimplicialSurfaceByVerticesInFaces(vof_assembly);;      pr_assembly:=SetVertexCoordinates3D(s_assembly,coordinates_assembly);;
deactivate_edges:=Concatenation(List([1..NumberOfFaces(s_assembly)/14],i->(i-1)*21+[2,16,20]));
for i in deactivate_edges do pr_assembly:=DeactivateEdge(s_assembly,i,pr_assembly); od;
pr_assembly:=DeactivateVertices(s_assembly,pr_assembly);
pr_assembly:=SetEdgeColours(s_assembly,List(Edges(s_assembly),i->"black"),pr_assembly);
pr_assembly.faceColours:=List(Faces(s_assembly),i->"0x89C2FF");
pr_assembly.edgeThickness:=0.05;
DrawSurfaceToJavaScript(s_assembly,"pg_aperiodic_matrix_example",pr_assembly);

# Function for generating random assemblies

HelperRandomPlanarAssembly:=function(m,n)
    local first,first_row, assembly, i, j;
    # compute the first row
    first:=RandomList([1,2,3,4]);
    first_row:=[first];
    for i in [2..n] do
        Add(first_row,RandomList([0,1]));
    od;
    assembly:=[first_row];
    #add remaining rows
    for j in [2..m] do
        Add(assembly,RandomList([0,1]));
    od;
    return assembly;
end;;

RandomPlanarAssembly:=function(m,n)
    local data,assembly_matrix,tiles,first_index,first_row,index,i,j,row,vof_asembly,coordinates_assembly,s_assembly,pr_assembly,name;
    data:=HelperRandomPlanarAssembly(m,n);
    assembly_matrix:=[];
    #first row
    #tiles:=["ll","lr","ul","ur"];
    tiles:=[ll,lr,ul,ur];
    first_index:=data[1][1];
    first_row:=[first_index];
    for i in [2..n] do
        if first_index=1 or first_index=2 then
            index:=first_index+2*data[1][i];
        else
            index:=first_index-2*data[1][i];
        fi;
        Add(first_row,index);
    od;
    Add(assembly_matrix,first_row);
    # add remaining rows
    for j in [2..m] do
        row:=[];
        for i in [1..n] do
            if i=1 then
                if assembly_matrix[j-1][1]=1 or assembly_matrix[j-1][1]=3 then
                    index:=assembly_matrix[j-1][1]+data[j];
                else
                    index:=assembly_matrix[j-1][1]-data[j];
                fi;
            else
                if assembly_matrix[j-1][i]=1 or assembly_matrix[j-1][i]=3 then
                    index:=assembly_matrix[j-1][i]+((row[i-1]+1) mod 2);
                else
                    index:=assembly_matrix[j-1][i]-((row[i-1]) mod 2);
                fi;
            fi;
            if index>4 then
                Error();
            fi;
            Add(row,index);
        od;
        Add(assembly_matrix,row);
    od;
    assembly_matrix:=List([1..m],i->List([1..n],j->tiles[assembly_matrix[i][j]]));
    
    vof_assembly:=Concatenation(List([1..Size(assembly_matrix)],i->Concatenation(List([1..Size(assembly_matrix[1])],j->vof+NumberOfVertices(s)*((i-1)*Size(assembly_matrix[1])+(j-1))))));

    coordinates_assembly:=Concatenation(List([1..Size(assembly_matrix)],j->Concatenation(List([1..Size(assembly_matrix[1])],i->assembly_matrix[i][j]+(j-1)*[2,0,0]+(i-1)*[0,-2,0]))));

    s_assembly:=SimplicialSurfaceByVerticesInFaces(vof_assembly);;      pr_assembly:=SetVertexCoordinates3D(s_assembly,coordinates_assembly);;
    deactivate_edges:=Concatenation(List([1..NumberOfFaces(s_assembly)/14],i->(i-1)*21+[2,16,20]));
    for i in deactivate_edges do pr_assembly:=DeactivateEdge(s_assembly,i,pr_assembly); od;
    pr_assembly:=DeactivateVertices(s_assembly,pr_assembly);
    pr_assembly:=SetEdgeColours(s_assembly,List(Edges(s_assembly),i->"black"),pr_assembly);
    pr_assembly.faceColours:=List(Faces(s_assembly),i->"0x89C2FF");
    pr_assembly.edgeThickness:=0.05;
    name:=Concatenation("Random_planar_",String(m),"x",String(n),"_assembly");
    DrawSurfaceToJavaScript(s_assembly,name,pr_assembly);
    return [s_assembly,pr_assembly];
end;;
            
RandomPlanarAssemblyString:=function(m,n)
    local data,assembly_matrix,tiles,first_index,first_row,index,i,j,row,vof_asembly,coordinates_assembly,s_assembly,pr_assembly,name;
    data:=HelperRandomPlanarAssembly(m,n);
    assembly_matrix:=[];
    #first row
    tiles:=["ll","lr","ul","ur"];
    #tiles:=[ll,lr,ul,ur];
    first_index:=data[1][1];
    first_row:=[first_index];
    for i in [2..n] do
        if first_index=1 or first_index=2 then
            index:=first_index+2*data[1][i];
        else
            index:=first_index-2*data[1][i];
        fi;
        Add(first_row,index);
    od;
    Add(assembly_matrix,first_row);
    # add remaining rows
    for j in [2..m] do
        row:=[];
        for i in [1..n] do
            if i=1 then
                if assembly_matrix[j-1][1]=1 or assembly_matrix[j-1][1]=3 then
                    index:=assembly_matrix[j-1][1]+data[j];
                else
                    index:=assembly_matrix[j-1][1]-data[j];
                fi;
            else
                if assembly_matrix[j-1][i]=1 or assembly_matrix[j-1][i]=3 then
                    index:=assembly_matrix[j-1][i]+((row[i-1]+1) mod 2);
                else
                    index:=assembly_matrix[j-1][i]-((row[i-1]) mod 2);
                fi;
            fi;
            if index>4 then
                Error();
            fi;
            Add(row,index);
        od;
        Add(assembly_matrix,row);
    od;
    return List([1..m],i->List([1..n],j->tiles[assembly_matrix[i][j]]));
    
    
end;;

RandomPlanarShift:=function(tiles,shift)
    local data,assembly_matrix,first_index,first_row,index,i,j,row,vof_asembly,coordinates_assembly,s_assembly,pr_assembly,name;
    assembly_matrix:=[];
    #first row
    
    assembly_matrix:=List(tiles,i->List(i,j->EvalString(j)));
    
    
    vof_assembly:=Concatenation(List([1..Size(assembly_matrix)],i->Concatenation(List([1..Size(assembly_matrix[1])],j->vof+NumberOfVertices(s)*((i-1)*Size(assembly_matrix[1])+(j-1))))));

    coordinates_assembly:=Concatenation(List([1..Size(assembly_matrix)],j->Concatenation(List([1..Size(assembly_matrix[1])],i->assembly_matrix[i][j]+(j-1)*[2+shift,0,0]+(i-1)*[0,-2-shift,0]))));

    s_assembly:=SimplicialSurfaceByVerticesInFaces(vof_assembly);;      pr_assembly:=SetVertexCoordinates3D(s_assembly,coordinates_assembly);;
    deactivate_edges:=Concatenation(List([1..NumberOfFaces(s_assembly)/14],i->(i-1)*21+[2,16,20]));
    for i in deactivate_edges do pr_assembly:=DeactivateEdge(s_assembly,i,pr_assembly); od;
    pr_assembly:=DeactivateVertices(s_assembly,pr_assembly);
    pr_assembly:=SetEdgeColours(s_assembly,List(Edges(s_assembly),i->"black"),pr_assembly);
    pr_assembly.faceColours:=List(Faces(s_assembly),i->"0x89C2FF");
    pr_assembly.edgeThickness:=0.05;
    name:="Random_planar_Shift";
    DrawSurfaceToJavaScript(s_assembly,name,pr_assembly);
    return [s_assembly,pr_assembly];
end;;

### function to attach the divine block to a assembly of divine blocks

# surf is a simplicial surface
# c is the list of 3D-coordinates for the vertices of surf
# id is a list [[v1,w1],[v2,w2],[v3,w3]] so that [v1,v2,v3] is a face of surf and [w1,w2,w3] is a face of the divine block 
# i is either 0 or 1 
# Example  
s:=SimplicialSurfaceByVerticesInFaces(facesDivineBlock);;
 AddBlock(s,coorDivineBlock,[[3,2],[4,1],[7,5]],2);

AddBlock:=function(surf,c,id,i)
	local g,crossProduct,n,v1,v2,v3,w1,w2,w3,s,v,temp,sol;
	##erstmal ohne seitenlöschen
	crossProduct:=function(A,B)
		local CP;
		CP:=[A[2]*B[3]-A[3]*B[2],
			A[3]*B[1]-A[1]*B[3],
			A[1]*B[2]-A[2]*B[1]];
		return 1/Sqrt(CP[1]*CP[1]+CP[2]*CP[2]+CP[3]*CP[3]*1.)*CP;
	end;
	n:=Length(c);
	v1:=1.*c[id[2][1]]-c[id[1][1]];
	v2:=1.*c[id[3][1]]-c[id[1][1]];
	v3:=crossProduct(v1,v2);
	w1:=1.*coordinates[id[2][2]]-coordinates[id[1][2]];
	w2:=1.*coordinates[id[3][2]]-coordinates[id[1][2]];
	w3:=(-1)^i*crossProduct(w1,w2);##ausrichtung ändern
	s:=Filtered(ConnectedComponents(surf),
		s->Set(List(id,g->g[1])) in VerticesOfFaces(s))[1];
	for v in [1..10] do
		sol:=SolutionMat([w1,w2,w3],1.*coordinates[v]-coordinates[id[1][2]]);
		Add(c,c[id[1][1]]+v1*sol[1]+v2*sol[2]+v3*sol[3]);
	od;
	temp:=List(faces,f->f+[n,n,n]);
	s:=SimplicialSurfaceByVerticesInFaces(Union(VerticesOfFaces(surf),temp));
	return [s,c];

end;

## add function for arbritaryblock
AddAngle:=function(surf,c,id,n,i,numE)
	local g,crossProduct,num,mat,v1,v2,v3,w1,w2,w3,s,v,temp,sol,
		alpha,coorA,facesA;
    ##erstmal ohne seitenlöschen
    alpha:=3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481/n;
    crossProduct:=function(A,B)
    local CP;
	CP:=[A[2]*B[3]-A[3]*B[2],
	     A[3]*B[1]-A[1]*B[3],
	     A[1]*B[2]-A[2]*B[1]];
	     return 1/Sqrt(CP[1]*CP[1]+CP[2]*CP[2]+CP[3]*CP[3]*1.)*CP;
    end;
    if numE=1 then   
	coorA:=[[2,2,-Sqrt(2.)],[2,0,-Sqrt(2.)],[2,2,0],[1,1,0],
		     [2+Sin(alpha),2-Sin(alpha),-Sqrt(2.)*Cos(alpha)],
		     [3+Sin(alpha)+Cos(alpha),3-Sin(alpha)-Cos(alpha),
		     -Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],
		     [1+Sin(alpha)+Cos(alpha),1-Sin(alpha)-Cos(alpha),
		     -Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],[4,2,-Sqrt(2.)],
		     [3,3,0]]*1/Sqrt(2.);
	facesA:=[[1,2,4],[1,3,4],[1,8,9],[1,3,9],[4,5,7],[5,6,9],[2,4,7],
			  [6,8,9],[5,6,8],[2,5,7],[1,5,8],[1,2,5],[3,5,9],[3,4,5]];
    elif numE =2 then 
	coorA:=[[2,2,-Sqrt(2.)],[2,0,-Sqrt(2.)],[2,2,0],[1,1,0],
		     [2+Sin(alpha),2-Sin(alpha),-Sqrt(2.)*Cos(alpha)],
		     [3+Sin(alpha)+Cos(alpha),3-Sin(alpha)-Cos(alpha),
		     -Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],
		     [1+Sin(alpha)+Cos(alpha),1-Sin(alpha)-Cos(alpha),
		     -Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],[4,2,-Sqrt(2.)],
		     [3,3,0]]*1/Sqrt(2.);
	facesA:=[[1,2,4],[1,3,4],[1,8,9],[1,3,9],[4,5,7],[5,6,9],[2,4,7],
			  [6,8,9],[5,6,8],[2,5,7],[3,5,9],[3,4,5],[2,8,1],[2,8,5]];
    elif numE=3 then
	coorA:=[[2,2,-Sqrt(2.)],[2,0,-Sqrt(2.)],[2,2,0],[1,1,0],
		      [2+Sin(alpha),2-Sin(alpha),-Sqrt(2.)*Cos(alpha)],
		      [3+Sin(alpha)+Cos(alpha),3-Sin(alpha)-Cos(alpha),
			-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],
		      [1+Sin(alpha)+Cos(alpha),1-Sin(alpha)-Cos(alpha),
			-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],
		      [4,2,-Sqrt(2.)],[3,3,0],[3,1,-Sqrt(2.)]]*1/Sqrt(2.);

	facesA:=[[1,2,4],[1,3,4],[1,8,9],[1,3,9],[4,5,7],[5,6,9],[2,4,7],
			  [6,8,9],[10,6,8],[2,10,7],[3,5,9],[3,4,5],[2,10,1],[10,8,1],
			  [5,10,7],[5,10,6]];
    elif numE=4 then 
	coorA:=[[2,2,-Sqrt(2.)],[2,0,-Sqrt(2.)],[1,1,0],
		      [2+Sin(alpha),2-Sin(alpha),-Sqrt(2.)*Cos(alpha)],
		      [3+Sin(alpha)+Cos(alpha),3-Sin(alpha)-Cos(alpha),
			-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],
		      [1+Sin(alpha)+Cos(alpha),1-Sin(alpha)-Cos(alpha),
			-Sqrt(2.)*Cos(alpha)+Sqrt(2.)*Sin(alpha)],
		      [4,2,-Sqrt(2.)],[3,3,0],[3,1,-Sqrt(2.)]]*1/Sqrt(2.);
 
	facesA:=[[1,2,3],[1,7,8],[1,3,8],[3,4,6],[4,5,8],[2,3,6],
		[5,7,8],[5,7,9],[2,6,9],[3,4,8],[1,2,9],[1,7,9],[4,5,6],[5,6,9]];
    else 
	return Error();
    fi;
	num:=Length(c);
	v1:=1.*c[id[2][1]]-c[id[1][1]];
	v2:=1.*c[id[3][1]]-c[id[1][1]];
	v3:=crossProduct(v1,v2);
	w1:=1.*coorA[id[2][2]]-coorA[id[1][2]];
	w2:=1.*coorA[id[3][2]]-coorA[id[1][2]];
	w3:=((-1)^i)*crossProduct(w1,w2);
	mat:=[w1,w2,w3];
	#mat:=TransposedMat(mat);
	mat:=mat^(-1);
	for v in [1..Length(coorA)] do
	    sol:=(1.*coorA[v]-coorA[id[1][2]])*mat;
	  #  sol:=SolutionMat([w1,w2,w3],1.*coorA[v]-coorA[id[1][2]]);
	    Add(c,c[id[1][1]]+v1*sol[1]+v2*sol[2]+v3*sol[3]);
	od;
	temp:=List(facesA,f->f+[num,num,num]);
	s:=SimplicialSurfaceByVerticesInFaces(Union(VerticesOfFaces(surf),temp));
	return [s,c];
end;

## function for creating tubular structures
tunnel:=function(n,k,numE)
    local g,pi,mat,t,l,coor,i,j,res,mat2,norm,vof,temp,temp2,s,crossProduct,beta,len,tvof;
    crossProduct:=function(A,B)
	local CP;
	CP:=[A[2]*B[3]-A[3]*B[2],
		A[3]*B[1]-A[1]*B[3],
		A[1]*B[2]-A[2]*B[1]];
	return 1/Sqrt(CP[1]*CP[1]+CP[2]*CP[2]+CP[3]*CP[3]*1.)*CP;
    end;

    pi:=3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481;
    coor:=[[0,0,0],[-1,1,0],[0,2,0],[1,1,0],[-1,0,1],[-1,1,1],[0,1,1],[1,1,1],[1,0,1],[0,0,1]];

    coor:=List(coor,g->g-[0,1,0]);
    #coor:=List(coor,g->g);
    s:=SimplicialSurfaceByVerticesInFaces(facesDivineBlock);
	#Error();
	if numE=4 then 
	    res:=AddAngle(s,coor,[[1,4],[2,8],[5,5]],n/2,-1,4);
	else
	    res:=AddAngle(s,coor,[[1,5],[2,9],[5,6]],n/2,-1,numE);    
	fi;
    beta:=pi/(n);
    mat2:=[[1,0,0],[0,Cos(beta),-Sin(beta)],[0,Sin(beta),Cos(beta)]];
    mat:=[[1,0,0],[0,Cos(2*pi/(n)),-Sin(2*pi/(n))],[0,Sin(2*pi/(n)),Cos(2*pi/(n))]];
    t:=[Cos(2*pi/n),Sin(2*pi/n)]-[Cos(2*pi*2/n),Sin(2*pi*2/n)];
    temp:=Sqrt(t[1]^2+t[2]^2);
    norm:=1/temp;
    temp2:=List(res[2],g->ShallowCopy(g)*mat2+norm*[0,0,1]);
    coor:=[];
    vof:=[];
	#Error();
    for i in [1..n] do
	temp:=[];
	for j in [1..Length(temp2)] do
	    temp[j]:=mat^(i)*temp2[j]+(i mod 2)*[1,0,0];
	od;
	Append(coor,temp);
	Append(vof,List(VerticesOfFaces(res[1]),g->ShallowCopy(g)+Length(res[2])*[i-1,i-1,i-1]));
    od;
	
###
   len:=Length(coor);
   tvof:=ShallowCopy(vof);
    for i in [1..k-1] do
	temp:=[];
	for j in [1..len] do
	    temp[j]:=coor[j]+i*[2,0,0];
	od;
	Append(coor,temp);
	Append(vof,List(tvof,g->ShallowCopy(g)+len*[i,i,i]));
    od;
    return [SimplicialSurfaceByVerticesInFaces(vof),coor];
end;


## Function for finding Normals of Outer Hull

### Example: 


coordinates:=[[0,0,0],[2,0,0],[2,-2,0],[0,-2,0],
[1,1,1],[2,0,1],[1,-1,1],[0,-2,1],[-1,-1,1]
]*  DiagonalMat([1.,1.,Sqrt(2.)]);;
#middle connected to upper part
faces:=[
[1,2,3],[1,3,4],

[5,6,7],[7,8,9],[5,7,9],

[1,9,5],[5,1,2],[5,6,2],[6,2,7],[7,2,3],[7,3,4],[4,8,7],[4,8,9],[4,9,1]

];;
s:=SimplicialSurfaceByVerticesInFaces(faces);
NormalsOuterHull(s,coordinates);


### Function:

Crossproduct:=function(x,y)
	return [x[2]*y[3]-x[3]*y[2],x[3]*y[1]-x[1]*y[3],x[1]*y[2]-x[2]*y[1]];
end;;

# Find outer triangle
# for a triangular complex with points find an outer face and
# a normal vector pointing outwards
FindOuterTriangle:=function(t,points)
	local i_max,px_max,i,eov,j_min,x_max,j_max,x_min,e,f,n,foe,indices,index,j;
	# find point with maximal x coordinate
	indices:=Filtered([1..Size(points)],i->IsBound(points[i]));
	i_max:=indices[1];
	px_max:=points[i_max][1];
	for i in [2..Size(indices)] do
		index:=indices[i];
		if points[index][1]>px_max then
			px_max:=points[index][1];
			i_max:=index;
		fi;
	od;
	eov:=EdgesOfVertex(t,i_max);
	eov:=List(eov,e->[e,DifferenceLists(VerticesOfEdge(t,e),[i_max])]);
	eov:=List(eov,e->[e[1],points[e[2][1]]-points[i_max]]);
	eov:=List(eov,e->[e[1],e[2]/MyNorm(e[2])]);
	# find edge with smallest absolute value in x-coordinate
	j_min:=1;
	x_min:=AbsoluteValue(eov[1][2][1]);
	for j in [2..Size(eov)] do
		if AbsoluteValue(eov[j][2][1]) < x_min then
			j_min:=j;
			x_min:=AbsoluteValue(eov[j][2][1]);
		fi;
	od;
	# found the edge
	e:=eov[j_min][1];
	foe:=FacesOfEdge(t,e);
	foe:=List(foe,f->[f,VerticesOfFace(t,f)]);
	foe:=List(foe,f->[f[1],Crossproduct(points[f[2][2]]-points[f[2][1]],points[f[2][3]]-points[f[2][1]])]);
	foe:=List(foe,f->[f[1],f[2]/MyNorm(f[2])]);
	# find edge with smallest absolute value in x-coordinate
	j_max:=1;
	x_max:=AbsoluteValue(foe[1][2][1]);
	for j in [2..Size(foe)] do
		if AbsoluteValue(foe[j][2][1]) > x_max then
			j_max:=j;
			x_max:=AbsoluteValue(foe[j][2][1]);
		fi;
	od;
	# found the face
	f:=foe[j_max][1];
	n:=foe[j_max][2];
	if foe[j_max][2][1]<0. then
		n:=-n;
	fi;
	return [f,n];
end;;

# Dot Product
Dot:=function(a,b)
	return a[1]*b[1]+a[2]*b[2]+a[3]*b[3];
end;;

MyNorm:=function(a)
	return Sqrt(Dot(a,a));
end;

MyRoundVector:=function(n,eps)
	local i;
	n:=1.0*n;
	for i in [1..3] do 
		if Sqrt(n[i]^2)<eps then
			n[i]:=0.;
		fi;
	od;
	return n;
end;

VectorAngle:=function(a,b)
	return Acos(Dot(a,b)/(MyNorm(a)*MyNorm(b)));
end;;

VectorAnglePlane:=function(a,b,n)
	return Atan2(Determinant(1.*[a,b,n]),Dot(a,b));
end;;

Rotate_Vector_Axis:=function(v,u,alpha)
	local r_alpha_u;
	u:=u/MyNorm(u);
	r_alpha_u:= Cos(alpha)*IdentityMat(3) + Sin(alpha)*[[0,-u[3],u[2]],[u[3],0,-u[1]],[-u[2],u[1],0]] + (1- Cos(alpha)) *(TransposedMat([u])*[u]);
	return (v*TransposedMat(r_alpha_u));
end;;



# Given an edge e, from a triangular complex s, with vertexCoordinates vC and a face f with MyNormal vector n
# calculate the fan [(f,n),(f2,n2),...] in direction of MyNormal
CalculateFan:=function(s,e,vC,f,MyNormal)
	local FacesOfEdge_e, ThirdPoint, VoE, a, p, n, t, vec, face; 
	# for all faces with edge e in s arrange them first
	FacesOfEdge_e:=FacesOfEdge(s,e);
	ThirdPoint:=[];
	VoE:=VerticesOfEdge(s,e);
	for face in FacesOfEdge_e do
		Add(ThirdPoint,[face,DifferenceLists(VerticesOfFace(s,face),VoE)[1]]);
	od;
	a:=vC[VoE[1]];
	n:=vC[VoE[2]]-vC[VoE[1]];
	n:=n/MyNorm(n);
	for t in ThirdPoint do
		p:=vC[t[2]];
		t[3]:=p-a-Dot((p-a),n)*n;
		# if we consider face f save the vector
		if t[1]=f then
			vec:=t[3];
		fi;
	od;
	# now compute the angle of all derived vectors with vec and rotate MyNormal vector n according to the angle
	for t in ThirdPoint do
		if Determinant(1.*[vec,n,MyNormal]) < 0. then
			t[4]:=VectorAnglePlane(vec,t[3],n);
			t[5]:=Rotate_Vector_Axis(MyNormal,n,t[4]);
		else
			t[4]:=VectorAnglePlane(vec,t[3],-n);
			t[5]:=Rotate_Vector_Axis(MyNormal,-n,t[4]);
		fi;
	od;
	SortBy(ThirdPoint,x->x[4]);
	return ThirdPoint;
end;;

UpwardContinuation:=function(s,e,vC,f,MyNormal)
	local Fan, index, i;
	Fan:=CalculateFan(s,e,vC,f,MyNormal);
	for i in [1..Size(Fan)] do 
		if Fan[i][1]=f then
			index:=(i mod (Size(Fan))) + 1;
			return [Fan[index][1],-Fan[index][5]];
		fi;
	od;
	return fail;
end;;


# Algorithm from Paper by M. Attene Title: As-exact-as-possible repair of unprintable stl files
# Input: a triangular complex s with coordinates vC and an outer face f with normal vector n
# Output: s, Restricted Complex to outer faces, Outer Faces, and correctly oriented normal vectors
OuterHull:=function(s,vC,f,n)
	local B, e, OuterTriangles, InnerTriangles, NormalVectors, b, edge, t, t_new, eps;
	eps := 1.0/(10^(12));
	B:=[];
	for e in EdgesOfFace(s,f) do
		Add(B,[f,e]);
	od;
	OuterTriangles:=[f];
	NormalVectors:=[];
	NormalVectors[f]:=n;
	InnerTriangles:=[];
	while not IsEmpty(B) do 
		t:=Remove(B);
		t_new:=UpwardContinuation(s,t[2],vC,t[1],NormalVectors[t[1]]);
		if not t_new[1] in OuterTriangles then

			Add(OuterTriangles,t_new[1]);
			NormalVectors[t_new[1]]:=MyRoundVector(t_new[2], eps);
			for edge in EdgesOfFace(s,t_new[1]) do
				if edge <> t[2] then
					Add(B,[t_new[1],edge]);
				fi;
			od;
		fi;
	od;
	return [s,SubcomplexByFaces(s,OuterTriangles),OuterTriangles,NormalVectors];
end;;


Sublist:=function(list,positions)
	local new_list,p;
	new_list:=[];
	for p in positions do
		new_list[p]:=list[p];
	od;
	return new_list;
end;;

BoundedPositions:=function(list)
	return Filtered([1..Size(list)],i->IsBound(list[i]));
end;;

UnionLists:=function(list1,list2)
	local new_list,i;
	new_list:=[];
	for i in BoundedPositions(list1) do
		new_list[i]:=list1[i];
	od;
	for i in BoundedPositions(list2) do
		new_list[i]:=list2[i];
	od;
	return new_list;
end;;

NormalsOuterHull:=function(t,points)
    local data,f,n;
    points:=points*1.;
    data:=FindOuterTriangle(t,Sublist(points,Vertices(t)));
    f:=data[1];
    n:=data[2];
    return OuterHull(t,points,f,n)[4];
end;;



### JoinComponents


# Dot Product
Dot:=function(a,b)
	return a[1]*b[1]+a[2]*b[2]+a[3]*b[3];
end;;

MyNorm:=function(a)
	return Sqrt(Dot(a,a));
end;

NumericalPosition:=function(list,entry,epsilon)
        local i, n;
        n := Length(list);
        i := 1;       
        while i <= n do
            if MyNorm(list[i]-entry)< epsilon then
                return i;
            fi;
            i := i + 1;
        od;       
        return fail;
    end;

JoinComponents:=function(t,coordinates,eps)
	local map,i,new_faces,new_vertices,map2,data;
    data:=[coordinates,VerticesOfFaces(t)];
    data[1]:=1.*data[1];
	# delete multiple occurences of vertices
	map:=[];
	for i in [1..Size(data[1])] do
		map[i]:=NumericalPosition(data[1],data[1][i],eps);
	od;
	new_vertices:=[];
	map2:=[];
	for i in [1..Size(data[1])] do
		if i in map then
			Add(new_vertices,data[1][i]);
			map2[i]:=Size(new_vertices);
		else
			map2[i]:=map2[map[i]];
		fi;
	od;
	new_faces:=List(data[2],j->[map2[j[1]],map2[j[2]],map2[j[3]]]);
	data[2]:=new_faces;
	data[1]:=new_vertices;
	# delete multiple occurences of faces
	data[2]:=Set(List(data[2],i->Set(i)));
	return [data[1],TriangularComplexByVerticesInFaces(data[2])];
end;;


IsomorphismTest:=function(n)
	local i,isoRep,numIso,temp,data,bool,j;
	isoRep:=[];
	numIso:=[];
	for j in [1..1000] do
		temp:=RandomAssemblies(n);
		data:=JoinComponents(temp[1],temp[2],0.01);
		bool:=false;
		for i in [1..Length(isoRep)] do
			if IsIsomorphic(data[2],isoRep[i][2]) then 
				bool:=true;
				numIso[i]:=numIso[i]+1;	
			fi;
		od;
		if not bool then 
			Add(numIso,1);
			Add(isoRep,data);
		fi;
	od;
	return [isoRep,numIso];
end;


### draw random truchet tile 

DrawRandomAssemblyToTikZ:=function(m,n,fileName)
	local g,output,file,i,j,temp,randomAssembly,help_print,printRecord;
#    tiles:=["ll","lr","ul","ur"];
##################################bla
        if not EndsWith( fileName, ".tex" ) then
            fileName := Concatenation( fileName, ".tex" );
        fi;
        file := Filename( DirectoryCurrent(), fileName ); #TODO allow absolute $
        output := OutputTextFile( file, false ); # override other files
        if output = fail then
            Error(Concatenation("File ", String(file), " can't be opened.") );
        fi;
        SetPrintFormattingStatus( output, false );

	printRecord:=DrawSurfaceToTikz(Tetrahedron(),fileName);
	AppendTo( output, __SIMPLICIAL_PrintRecordGeneralHeader(printRecord) );
	AppendTo( output, __SIMPLICIAL_PrintRecordTikzHeader(printRecord) );
	AppendTo( output, "\n\n\\begin{document}\n\n" );

        AppendTo( output, "\n\n\\begin{tikzpicture}[vertexBall, edgeDouble, faceStyle, scale=2]\n\n" );
#################################
	randomAssembly:=RandomPlanarAssemblyString(m,n);
	help_print:=function(i,j,output)
		local temp;
		temp:="";
		temp:=Concatenation(temp,
		"\\coordinate (V1) at (", String(-1*(i-1)),",",String(j-1),");\n",
 		"\\coordinate (V2) at (", String(-i),",",String(j-1),");\n",
		"\\coordinate (V3) at (", String(-i),",",String(j),");\n",
		"\\coordinate (V4) at (", String(-1*(i-1)),",",String(j),");\n");
		AppendTo(output,temp);
	end;
##u
    for i in [1..m] do
	for j in [1..n] do
	    help_print(j,i,output);
	     if randomAssembly[i][j]="lr" then 
		AppendTo(output,"\\fill[face=black]  (V1) -- (V4) -- (V2) -- cycle;\n");
	    elif randomAssembly[i][j]="ll" then
		AppendTo(output,"\\fill[face=black]  (V1) -- (V2) -- (V3) -- cycle;\n");
	    elif randomAssembly[i][j]="ur" then
		AppendTo(output,"\\fill[face=black]  (V1) -- (V4) -- (V3) -- cycle;\n");
	    elif randomAssembly[i][j]="ul" then
		AppendTo(output,"\\fill[face=black]  (V4) -- (V3) -- (V2) -- cycle;\n");
	    fi;
	od;
    od;



#######################bla

	AppendTo( output, "\n\\end{tikzpicture} \n\\end{document}\n" );
        return randomAssembly;

############################

end;

### random assemblies
RandomAssemblies:=function(numBlocks)
    local g,coor,surface,s,faces,res,tempID,combID,temp,i,id;
    coor:=[[0,0,0],[-1,1,0],[0,2,0],[1,1,0],[-1,0,1],[-1,1,1],[0,1,1],[1,1,1],[1,0,1],[0,0,1],[0,1,0]];

    faces:=[[5,6,7],[7,8,9],[5,1,2],[5,6,2],[6,2,7],[7,2,3],[7,3,4],[4,8,7],[4,8,9],[4,9,1],[10,5,7],[10,7,9],[10,9,1],[10,1,5],[11,2,3],[11,3,4],[11,1,4],[11,1,2]];
    s:=SimplicialSurfaceByVerticesInFaces(faces);

    res:=[s,coor];

    tempID:=[[[3,2],[4,1],[7,5]],[[3,5],[4,2],[7,1]],[[3,1],[4,5],[7,2]],
	[[2,3],[1,4],[5,7]],[[5,3],[2,4],[1,7]],[[1,3],[5,4],[2,7]],
	[[3,4],[2,1],[7,9]],[[3,9],[2,4],[7,1]],[[3,1],[2,9],[7,4]],
	[[4,3],[1,2],[9,7]],[[9,3],[4,2],[1,7]],[[1,3],[9,2],[4,7]],

	[[3,4],[4,9],[7,1]],[[3,1],[4,4],[7,9]],[[3,9],[4,1],[7,4]],
	[[1,3],[2,2],[5,7]],[[1,7],[2,3],[5,2]],[[1,2],[2,7],[5,3]],
	[[2,2],[3,1],[7,5]],[[2,5],[3,2],[7,1]],[[2,1],[3,5],[7,2]],
	[[1,3],[4,4],[9,7]],[[1,7],[4,3],[9,4]],[[1,4],[4,7],[9,3]]];
#tempID:=[];
    combID:=tempID;

    for i in [1..numBlocks-1] do 
	id:=Random(combID);
	combID:=Difference(combID,[id]);
	res:=AddBlockRandom(res[1],res[2], id , 2);
	temp:=Filtered(tempID,l-> Set(List(id,g->g[1] mod 11))=Set(List(l,h->h[1])));
	Append(combID,List(temp,l->List(l,g->[g[1]+i*11,g[2]])));
	#combID:=Filtered(combID,g->Set(coor{List(g,i->i[1])})<>Set(coor{List(g,i->i[2])}));
   od;
    DrawSurfaceToJavaScript(res[1],"random",rec(vertexCoordinates3D:=1.*res[2]));
    return res;
end;



AddBlockRandom:=function(surf,c,id,i)
    local g,crossProduct,facesD,coorD,n,v1,v2,v3,w1,w2,w3,s,v,temp,sol,mat;
    coorD:=[[0,0,0],[-1,1,0],[0,2,0],[1,1,0],[-1,0,1],[-1,1,1],[0,1,1],
	   [1,1,1],[1,0,1],[0,0,1],[0,1,0]];
    facesD:=[[5,6,7],[7,8,9],[5,1,2],[5,6,2],[6,2,7],[7,2,3],[7,3,4],
	   [4,8,7],[4,8,9],[4,9,1],[10,5,7],[10,7,9],[10,9,1],[10,1,5],[11,2,3],
	   [11,3,4],[11,1,4],[11,1,2]];

	crossProduct:=function(A,B)
		local CP;
		CP:=[A[2]*B[3]-A[3]*B[2],
			A[3]*B[1]-A[1]*B[3],
			A[1]*B[2]-A[2]*B[1]];
		return CP;
	end;
	n:=Length(c);
	v1:=c[id[2][1]]-c[id[1][1]];
	v2:=c[id[3][1]]-c[id[1][1]];
	v3:=crossProduct(v1,v2);
	w1:=coorD[id[2][2]]-coorD[id[1][2]];
	w2:=coorD[id[3][2]]-coorD[id[1][2]];
	w3:=((-1)^i)*crossProduct(w1,w2);
	mat:=[w1,w2,w3];
	mat:=mat^(-1);
	for v in [1..11] do
	    sol:=(coorD[v]-coorD[id[1][2]])*mat;

	   Add(c,c[id[1][1]]+v1*sol[1]+v2*sol[2]+v3*sol[3]);
	od;
	temp:=List(facesD,f->f+[n,n,n]);
	s:=SimplicialSurfaceByVerticesInFaces(Union(VerticesOfFaces(surf),temp));
	return [s,c];
end;


RandomAssembliesWithoutSelfIntersections:=function(numBlocks)
    local g,coor,surface,s,faces,res,tempID,combID,temp,i,data,
	id,help_HasSelfIntersections,help_Candidates;
    coor:=[[0,0,0],[-1,1,0],[0,2,0],[1,1,0],[-1,0,1],[-1,1,1],[0,1,1],[1,1,1],[1,0,1],[0,0,1],[0,1,0]];

    faces:=[[5,6,7],[7,8,9],[5,1,2],[5,6,2],[6,2,7],[7,2,3],[7,3,4],[4,8,7],[4,8,9],[4,9,1],[10,5,7],[10,7,9],[10,9,1],[10,1,5],[11,2,3],[11,3,4],[11,1,4],[11,1,2]];
    s:=SimplicialSurfaceByVerticesInFaces(faces);

    res:=[s,coor];

    tempID:=[[[3,2],[4,1],[7,5]],[[3,5],[4,2],[7,1]],[[3,1],[4,5],[7,2]],
	[[2,3],[1,4],[5,7]],[[5,3],[2,4],[1,7]],[[1,3],[5,4],[2,7]],
	[[3,4],[2,1],[7,9]],[[3,9],[2,4],[7,1]],[[3,1],[2,9],[7,4]],
	[[4,3],[1,2],[9,7]],[[9,3],[4,2],[1,7]],[[1,3],[9,2],[4,7]],

	[[3,4],[4,9],[7,1]],[[3,1],[4,4],[7,9]],[[3,9],[4,1],[7,4]],
	[[1,3],[2,2],[5,7]],[[1,7],[2,3],[5,2]],[[1,2],[2,7],[5,3]],
	[[2,2],[3,1],[7,5]],[[2,5],[3,2],[7,1]],[[2,1],[3,5],[7,2]],
	[[1,3],[4,4],[9,7]],[[1,7],[4,3],[9,4]],[[1,4],[4,7],[9,3]]];
    combID:=tempID;
## 7-11 1-7
    help_HasSelfIntersections:=function(data,j)
	local g,edges,temp,temp2;
	edges:=VerticesOfEdges(data[1]){[1..27*j]};
	temp:=List(edges,e->data[2]{e});
	temp2:=[data[2]{[11*j+1,11*j+7]},data[2]{[11*j+7,11*j+11]} ];
	#temp2:=List(temp2,g->Set(g));
	return Intersection(temp,temp2)<>[];
    end;

    help_Candidates:=function(data,candidates,j)
	local g,res;
	res:=[];
	for g in candidates do
	
	    temp:=AddBlockRandom(data[1],ShallowCopy(data[2]), g , 2);
	    if not help_HasSelfIntersections(temp,j) then 
		Add(res,g);
	    fi;
	od;
	return res;
    end;
    for i in [1..numBlocks-1] do 
	Print(i,"\n");
	combID:=help_Candidates(res,combID,i);
	if combID=[] then return fail; fi;
#	Print(combID,"\n");
	id:=Random(combID);
	res:=AddBlockRandom(res[1],res[2], id , 2);	
	combID:=Difference(combID,[id]);
	temp:=Filtered(tempID,l-> Set(List(id,g->g[1] mod 11))=Set(List(l,h->h[1])));
	Append(combID,List(temp,l->List(l,g->[g[1]+i*11,g[2]])));
	combID:=Filtered(combID,g->Set(res[2]{List(g,i->i[1])})<>Set(res[2]{List(g,i->i[2])}));
   od;
    DrawSurfaceToJavaScript(res[1],"random",rec(vertexCoordinates3D:=1.*res[2]));
    return res;
end;







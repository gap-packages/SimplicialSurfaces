##finds an arbitrary vertex of the starting face
findPoint:=function(simpsurf, start)
    local i,j; 

    for i in [1..NrOfVerticesOfSimplicialSurface(simpsurf)] do
	    for j in [1..Length(VerticesOfSimplicialSurface(simpsurf)[i])] do
		    if VerticesOfSimplicialSurface(simpsurf)[i][j][1] = start then
			    return [i,j];
            fi;
	    od;
    od;

##sonst Fehler da Fläche keine Ecken hat
end;

##finds the point connected to vertex(k) via the edge "edge" of the face "face".
findotherPoint:=function(simpsurf, face, edge,k)
local i,j;

for i in [1..NrOfVerticesOfSimplicialSurface(simpsurf)] do
	for j in [1..Length(VerticesOfSimplicialSurface(simpsurf)[i])] do
		if VerticesOfSimplicialSurface(simpsurf)[i][j][1] = face then
			if VerticesOfSimplicialSurface(simpsurf)[i][j][2] = edge or VerticesOfSimplicialSurface(simpsurf)[i][j][3] = edge then
				if not k=i then
					return [i,j];
				fi;
			fi;
		fi;
	od;
od;
##sonst Fehler da Fläche keine Kanten hat
end;


# Return a list [a,b], where a and b are edges incident to the face but not
# equal to edge. Furthermore a is incident to vertex 
typesOfConnection:=function(surf, face, vertex, edge )
	local i,j,edges;
        
        edges := EdgesOfFaceVertexPair( surf, face, vertex );
        i := Difference( edges, [edge] )[1];
        #TODO check if this difference only has one element
        j := Difference( EdgesOfFaces(surf)[face], edges )[1]; 
	return [i,j];
end;

computeNewPoint:=function(surf, point,connections,a,b,c)
	local cosalpha,sinalpha,leftedge,rightedge,angle,length,newangle,newpoint;
	leftedge:=ColourOfEdge(surf,connections[1]);
	rightedge:=ColourOfEdge(surf,connections[2]);
	if ColourOfEdge(surf,point[4])=1 then
		if leftedge=2 then
			rightedge:=3;
			cosalpha:=Float((b^2+a^2-c^2)/(2*b*a));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle:=[cosalpha,sinalpha];
			length:=b;
		fi;
		if leftedge=3 then
			rightedge:=2;
			cosalpha:=Float((c^2+a^2-b^2)/(2*c*a));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle:=[cosalpha,sinalpha];
			length:=c;
		fi;
	fi;
	if ColourOfEdge(surf,point[4])=2 then	
		if leftedge=1 then
			rightedge:=3;
			cosalpha:=Float((b^2+a^2-c^2)/(2*b*a));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle:=[cosalpha,sinalpha];
			length:=a;
		fi;
		if leftedge=3 then
			rightedge:=1;
			cosalpha:=Float((c^2+b^2-a^2)/(2*c*b));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle:=[cosalpha,sinalpha];
			length:=c;
		fi;
	fi;
	if ColourOfEdge(surf,point[4])=3 then
		if leftedge=1 then
			rightedge:=2;
			cosalpha:=Float((c^2+a^2-b^2)/(2*c*a));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle:=[cosalpha,sinalpha];
			length:=a;
		fi;
		if leftedge=2 then
			rightedge:=1;
			cosalpha:=Float((c^2+b^2-a^2)/(2*c*b));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle:=[cosalpha,sinalpha];
			length:=b;
		fi;
	fi;
	newangle:=[cosalpha*point[3][1]-(sinalpha*point[3][2]),cosalpha*point[3][2]+sinalpha*point[3][1]];
	newpoint:=point[1]+length*newangle;
	return [newpoint,newangle];
end;

ComputeNeighbour:=function(simpsurf,point,data)
    local incFaces, face;

    incFaces := FacesOfEdges(simpsurf)[ point[4] ];
    for face in incFaces do
        if not face in data.facesComputed then
            return [true,face];
        fi;
    od;

    return [false,0];

end;


# Check whether the edges between newpoint and the oldpoints
# intersect the previously computed edges in data.
fits:=function(newpoint,oldpoints,data)  #newpoint as coordinates, oldpoints:=[i,j] with data.point[i] is the point
	local edge,a,b,c,d,x,y,i;
	for edge in data.pointsConnected do
		for i in [1,2] do
			if not (oldpoints[i]=edge[1] or oldpoints[i]=edge[2]) then
				a:=data.points[oldpoints[i]][1]-data.points[edge[1]][1];
				b:=newpoint-data.points[oldpoints[i]][1];
				d:=data.points[edge[2]][1]-data.points[edge[1]][1];
				if not EqFloat(b[1],0.0) then
					c:=b[2]/b[1];
					if not EqFloat(d[2]-c*d[1],0.0) then
						y:=(a[2]-c*a[1])/(d[2]-c*d[1]);
						x:=(a[1]-y*d[1])/(-b[1]);
						if (0.0<=x and x<=1.0 and 0.0<=y and y<=1.0) then
							return false;
						fi;
					fi;
				else 
					c:=b[1]/b[2];
					if not (d[1]-c*d[2]=0.0) then
						y:=(a[1]-c*a[2])/(d[1]-c*d[2]);
						x:=(a[2]-y*d[2])/(-b[2]);
						if (0.0<=x and x<=1.0 and 0.0<=y and y<=1.0) then
							return false;
						fi;
					fi;
				fi;
			fi;
		od;
	od;
	return true;						
end;

computenextface:=function(simpsurf,data,index,a,b,c)
	local newdata,newangle,nextVertex,newface,newtodo,
          labelneighbourcorner,tmp,PointandAngle,n,typesofconnection,
          direction,currpoint; 


	newdata:=ShallowCopy(data);
	if Length(data.facesComputed) < NrOfFaces(simpsurf) then
		currpoint:=newdata.points[index];
		tmp:=ComputeNeighbour(simpsurf,currpoint,data);
		if tmp[1] then
                    newface:=tmp[2];
                    # Compute a list of two edges: 
                    # 1) edge is incident to currpoint[2] and newface, but not currpoint[4]
                    # 2) final edge of newface (not incident to currpoint[2])
                    typesofconnection:=typesOfConnection(simpsurf, newface, currpoint[2], currpoint[4] );
                    # Compute coordinates of the next vertex and the coordinate vector to the next vertex
                    PointandAngle:=computeNewPoint(simpsurf, currpoint,typesofconnection,a,b,c);
                    # Find last vertex of new face
                    nextVertex := OtherVertexOfEdge( simpsurf, typesOfConnection[1], currpoint[2] );
                    if fits(PointandAngle[1],[index,currpoint[5]],data) then
                            direction:=data.points[currpoint[5]][1]-PointandAngle[1];
                            newangle:=direction/(Sqrt(Float(direction[1]^2+direction[2]^2)));
                            n:=Length(newdata.points);
                            # Modify the existing point 'index' such that its edge will be a border edge, if possible
                            newdata.points[index]:=[currpoint[1],currpoint[2],PointandAngle[2],typesofconnection[1],n+1,currpoint[6]];
                            newdata.points[n+1]:=[PointandAngle[1],nextVertex,newangle,typesofconnection[2],currpoint[5],index];
                            newdata.points[currpoint[5]][6]:=n+1;
                            Add(newdata.rescale,index);
                            Add(newdata.facesComputed, newface);
                            Add(newdata.coordinatesoffaces,[newface,currpoint[1]/3+PointandAngle[1]/3+data.points[currpoint[5]][1]/3]);
                            Add(newdata.pointsConnected,[index,n+1,ColourOfEdge(simpsurf,typesofconnection[1])]);
                            Add(newdata.pointsConnected,[currpoint[5],n+1,ColourOfEdge(simpsurf,typesofconnection[2])]);
                            return newdata;
                    fi;
		fi;
	fi;
	return data;
end;

#TODO why all these rescale-methods?
computenextfacerescale:=function(simpsurf,data,point,a,b,c)
	local newdata,newangle,labelnewcorner,newface,newtodo,labelneighbourcorner,tmp,PointandAngle,n,typesofconnection,direction,currpoint;
	newdata:=ShallowCopy(data);
	if Length(data.facesComputed) < NrOfFacesOfSimplicialSurface(simpsurf) then
		currpoint:=newdata.points[point];
		tmp:=ComputeNeighbour(simpsurf,currpoint,data);
		if tmp[1] then
			labelneighbourcorner:=tmp[2];
		newface:=VerticesOfSimplicialSurface(simpsurf)[tmp[2][1]][tmp[2][2]][1];
		typesofconnection:=typesOfConnection(VerticesOfSimplicialSurface(simpsurf)[tmp[2][1]][tmp[2][2]],currpoint[4]);
		PointandAngle:=computeNewPoint(simpsurf, currpoint,typesofconnection,a,b,c);
		labelnewcorner:=findotherPoint(simpsurf, newface, typesofconnection[1],currpoint[2][1]);
		#if fits(PointandAngle[1],[point,currpoint[5]],data) then
			direction:=data.points[currpoint[5]][1]-PointandAngle[1];
			newangle:=direction/(Sqrt(Float(direction[1]^2+direction[2]^2)));
			n:=Length(newdata.points);
			newdata.points[point]:=[newdata.points[point][1],labelneighbourcorner,PointandAngle[2],typesofconnection[1],n+1,newdata.points[point][6]];
			newdata.points[n+1]:=[PointandAngle[1],labelnewcorner,newangle,typesofconnection[2],currpoint[5],point];
			newdata.points[currpoint[5]][6]:=n+1;
			Add(newdata.facesComputed, newface);
			Add(newdata.coordinatesoffaces,[newface,currpoint[1]/3+PointandAngle[1]/3+data.points[currpoint[5]][1]/3]);
			Add(newdata.pointsConnected,[point,n+1,ColourOfEdge(simpsurf,typesofconnection[1])]);
			Add(newdata.pointsConnected,[currpoint[5],n+1,ColourOfEdge(simpsurf,typesofconnection[2])]);
			return newdata;
		#fi;
		fi;
	fi;
	return data;
end;

#TODO Assumes that the face-edge-paths around the vertices are all equally oriented
istoleft:=function(simpsurf,vertex,j,i,edge)
	local face1,face2;
	face1:=VerticesOfSimplicialSurface(simpsurf)[vertex][j][1];
	face2:=VerticesOfSimplicialSurface(simpsurf)[vertex][i][1];
	if face1^GeneratorsOfSimplicialSurface(simpsurf)[edge]=face2 then
		return true;
	else 
		return false;
	fi;
end;

# egal, da splitter=0
findPointcc:=function(data,i,counter)
	local tmpcounter,j;
	tmpcounter:=0;
	for j in [1..Length(data.points)] do
		if data.points[j][2]=i then
			if tmpcounter=counter[i] then
				return j;
			fi;
			tmpcounter:=tmpcounter+1;
		fi;
	od;
end;

computeCorner:=function(simpsurf,data,todo,i,splitter,counter,a,b,c)
	local newtodo,newcounter,point,newdata,j,n,k,vertex;

	if i>Length(todo) then
		return data;
	elif Length(data.facesComputed) = NrOfFaces(simpsurf) then
		return data;
	else
		newdata:=ShallowCopy(data);
		newcounter:=ShallowCopy(counter);
		newtodo:=ShallowCopy(todo);
		if i<=splitter then
			point:=findPointcc(data,todo[i],counter);
			newcounter[todo[i]]:=newcounter[todo[i]]+1;
			vertex:=todo[i];
		else
			point:=todo[i];
			vertex:=data.points[point][2];
		fi;
                #TODO how to reformulate rest of this method?
                # Was passiert: Führe computenextface solange aus, bis es nicht mehr geht (erste Schleife reicht)
		j:=data.points[point][2][2];
		if j>1 then 		
			if istoleft(simpsurf,vertex,j,j-1,data.points[point][4]) then	
				while j>1 do
					newdata:=computenextface(simpsurf,newdata,point,a,b,c);
					n:=Length(newtodo);
					k:=Length(newdata.points);
					if not newtodo[n]=k then
						Add(newtodo,k);
					fi;
					j:=j-1;
				od;
			else
				while j>1 do
					newdata:=computenextface(simpsurf,newdata,newdata.points[point][6],a,b,c);
					n:=Length(newtodo);
					k:=Length(newdata.points);
					if not newtodo[n]=k then
						Add(newtodo,k);
					fi;
					j:=j-1;
				od; 
			fi;
		fi;
		j:=data.points[point][2][2];
		if j<Length(VerticesOfSimplicialSurface(simpsurf)[vertex]) then
			if istoleft(simpsurf,vertex,j,j+1,data.points[point][4]) then	
				while j<Length(VerticesOfSimplicialSurface(simpsurf)[vertex]) do
					newdata:=computenextface(simpsurf,newdata,point,a,b,c);
					n:=Length(newtodo);
					k:=Length(newdata.points);
					if not newtodo[n]=k then
						Add(newtodo,k);
					fi;
					j:=j+1;
				od;
			else
				while j<Length(VerticesOfSimplicialSurface(simpsurf)[vertex]) do	
					newdata:=computenextface(simpsurf,newdata,newdata.points[point][6],a,b,c);
					n:=Length(newtodo);
					k:=Length(newdata.points);
					if not newtodo[n]=k then
						Add(newtodo,k);
					fi;
					j:=j+1;
				od; 
			fi;
		fi;
		return computeCorner(simpsurf,newdata,newtodo,i+1,splitter,newcounter,a,b,c);
	fi;
end;

drawSimpSurf:=function(listofdrawings,nameoffile,printrecord)
	local name,output,i,j,c,p,slash,face;
	## Test if Directory is correct
	#
	name:=Filename(DirectoryCurrent(),nameoffile);
	##Test if File already exists
	#IsExistingFile( name );
	output:=OutputTextFile(name,false); #old File will be overwritten
	AppendTo(output,"\\documentclass{article} \n", "\\usepackage{tikz} \n", "\\begin{document}");
	
	for i in [1..Length(listofdrawings)] do
		j:=1;
		AppendTo(output,"\n"," \\begin{tikzpicture} \n", "{ \n" );
		for p in listofdrawings[i].points do
			AppendTo(output,"\\coordinate [label=left:$",p[2][1],"$] \n (P",j,") at (",p[1][1],",",p[1][2],"); \n");
			j:=j+1;
		od;	
		for face in listofdrawings[i].coordinatesoffaces do
			AppendTo(output,"\\node (P",j,") at (",face[2][1],",",face[2][2],") {f",face[1],"}; \n");
			j:=j+1;
		od;
		for c in listofdrawings[i].pointsConnected do
                        # TODO Calculate colours from edges
			if c[3]=1 then
				AppendTo(output, "\\draw[",printrecord.colours[1],",","line width=",printrecord.thickness," pt] (P",c[1],") -- (P",c[2],"); \n");
			elif c[3]=2 then
				AppendTo(output, "\\draw[",printrecord.colours[2],",","line width=",printrecord.thickness," pt] (P",c[1],") -- (P",c[2],"); \n");
			elif c[3]=3 then
				AppendTo(output, "\\draw[",printrecord.colours[3],",","line width=",printrecord.thickness," pt] (P",c[1],") -- (P",c[2],"); \n");
			fi;
		od;
		AppendTo(output,"} \n","\\end{tikzpicture} \n");
	od;
	AppendTo(output,"\\end{document} \n");
	CloseStream(output);
end;

CreateDefaultPrintRecord:=function(simpsurf)
return rec(start:=Faces(simpsurf)[1],
	path:=[[],[]],
	scale:=[2,3,4],
	colours:=["red","blue","green"],
	thickness:=0.6,
	rescalelist:=[]);
end;

SetPath:=function(printrecord,listoffaces,listofsides)
	printrecord.path:=[listoffaces,listofsides];
end;

AddToPath:=function(printrecord,face,side);
	Add(printrecord.path[1],face);
	Add(printrecord.path[2],side);
end;

SetThickness:=function(printrecord,thickness)
	printrecord.thickness:=thickness;
end;

SetScale:=function(printrecord,scale)
#todo error message if scale is not a list with 3 elements
	printrecord.scale:=scale;
end;

SetColours:=function(printrecord,colours)
#todo error message if scale is not a list with 3 strings
	printrecord.colours:=colours;
end;

SetStartingFace:=function(printrecord,start)
#todo check if start is actually a face of the simpsurf
	printrecord.start:=start;
end;


## Given a face, a colour col 
## find an incident vertex-edge pair such that the vertex is incident to the
## face and the edge has colour col
findPathPoint:=function(simpsurf,data,face, col)
    local i, label2;

    for i in [1..Length(data.points)] do
	    if data.points[i][4]=col then
            if face in FacesOfVertices(simpsurf)[data.points[i][2]] then
			    return i;
            fi;
        fi;
    od;

    #Print("Path not possible");
    return 0; 
end;

EdgesOfFaceVertexPair := function( simpsurf, face, vertex )

    return Intersection(EdgesOfFaces(simpsurf)[face],
                        EdgesOfVertices(simpsurf)[vertex]);
end;

OtherVertexOfEdge := function(simpsurf, edge, vertex)

    # TODO catch Errors
    return Difference( VerticesOfEdges(simpsurf)[edge], [vertex])[1];
end;


SimpSurfToTikz:= function(simpsurf,nameoffile, printrecord)
#start, listofvertices,Scale, nameoffile)

local ConnectedPoints, start, listofvertices,Scale,Points, f,a,b,c, todo,  
angle13, n,k,index, angle32,listofdrawings,direction32,res,res1,res2,res3, 
RescaleList,pathindex,face,side, facesComputed,bottomedge,leftedge,rightedge,vtx1,bvtx,lvtx,point2,point3,cosalpha,sinalpha,data,newtodo,counter,splitter,i,
incidentedges, bcol, lcol, rcol,rightedge;


#a,b,c length of edges, set differently if wanted
start:=printrecord.start;
listofvertices:=[];
Scale:=printrecord.scale;
facesComputed:=[];
listofdrawings:=[];
RescaleList:=[];
a:=Scale[1]; # length of first edge
b:=Scale[2]; # length of second edge
c:=Scale[3]; # length of third edge

while Length(facesComputed)<NrOfFaces(simpsurf) do
	
	# Point:=[[horizontal-Koordinate,vertikal-Koordinate],vtx1 
    # (so, dass vertices[vtx1] dem 	Punkt entspricht), 
    # angle (needed to compute next point)]
	Points:=[];
	ConnectedPoints:=[]; #[point1,point2,type of connection]
	todo:=[];

	#draw first triangle, 3 is the top corner
    # set vtx1 to one of the vertices of the face start
	vtx1:= VerticesOfFaces(simpsurf)[start][1];

	incidentedges := EdgesOfFaceVertexPair(simpsurf,start,vtx1);
    bottomedge := incidentedges[1];
    leftedge := incidentedges[2];
    rightedge := Difference( EdgesOfFaces(simpsurf)[start], incidentEdges )[1];
    # find the bottom vertex bvtx of the edge bottomedge and 
    # find the left vertex lvtx of the edge leftedge 
	bvtx:=OtherVertexOfEdge(simpsurf,bottomedge,vtx1 );
	lvtx:=OtherVertexOfEdge(simpsurf,leftedge,vtx1 );

    bcol := ColourOfEdge(simpsurf,bottomedge);
    lcol := ColourOfEdge(simpsurf,leftedge);
    rcol := Difference( [1,2,3],[bcol,lcol])[1];

	if bcol = 1 then
		point2:=[a,0];

		if lcol=2 then
			cosalpha:=Float((b^2+a^2-c^2)/(2*b*a));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle13:=[cosalpha,sinalpha];
			point3:=angle13*b;
		elif lcol=3 then
			cosalpha:=Float((c^2+a^2-b^2)/(2*c*a));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle13:=[cosalpha,sinalpha];
			point3:=angle13*c;
        else Error("TODO");
		fi;
	elif bcol = 2 then
		point2:=[b,0];
	
		if lcol=1 then
			cosalpha:=Float((b^2+a^2-c^2)/(2*b*a));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle13:=[cosalpha,sinalpha];
			point3:=angle13*a;
		elif lcol=3 then
			cosalpha:=Float((c^2+b^2-a^2)/(2*c*b));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle13:=[cosalpha,sinalpha];
			point3:=angle13*c;
        else Error("TODO");
		fi;
	elif bcol=3 then
		point2:=[c,0];
	
		if lcol=1 then
			cosalpha:=Float((c^2+a^2-b^2)/(2*c*a));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle13:=[cosalpha,sinalpha];
			point3:=angle13*a;
		elif lcol=2 then
			cosalpha:=Float((c^2+b^2-a^2)/(2*c*b));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle13:=[cosalpha,sinalpha];
			point3:=angle13*b;
        else Error("TODO");
		fi;
    else Error("SimpSurfToTikz: incorrect colour used");
	fi;

	direction32:=point2-point3;
	angle32:=direction32/(Sqrt(Float(direction32[1]^2+direction32[2]^2)));
	
    # The entries of Points are
    # 1)  coordinate position, 
    # 2)  vtx number,
    # 3)  coordinate vector to next vertex, 
    # 4)  edge number (corresponding to the vector), 
    # 5)  next vertex position in triangle
    # 6)  second next vertex position in triangle (position in list Points)
	Points[1]:=[[0,0],vtx1,angle13,leftedge,3,2];
	Points[2]:=[point2,bvtx,[-1,0],bottomedge,1,3];
	Points[3]:=[point3,lvtx,angle32,rightedge,2,1];
	
	
	ConnectedPoints:=[[1,2,bcol],[2,3,rcol],[1,3,lcol]]; 
	Add(facesComputed,start); 
	data:=rec( points:=Points, 
               pointsConnected:=ConnectedPoints, 
               facesComputed:=facesComputed, 
               # store the centre of gravity for each face
               coordinatesoffaces:=[[start,([0,0]+point3+point2)/3]], 
               rescale:=[]);
	newtodo:=ShallowCopy(listofvertices);
	splitter:=Length(newtodo);
	Append(newtodo,[1,2,3]);
 
    # TODO: what is counter? Not necessary since only used for splitter.
	counter:=[];
	for i in [1..NrOfVerticesOfSimplicialSurface(simpsurf)] do
		counter[i]:=0;
	od;

	#compute representation in coordinates of inital path 
	pathindex := 1;
	while pathindex <= Length(printrecord.path[1]) do
		face:=printrecord.path[1][pathindex];
		side:=printrecord.path[2][pathindex];
		index:=findPathPoint(simpsurf,data,face,side);
		data:=computenextface(simpsurf,data,index,a,b,c);
		pathindex:=pathindex+1;
		n:=Length(newtodo);
		k:=Length(data.points);
		if not newtodo[n]=k then
			Add(newtodo,k);
		fi;
	od;


	res:=computeCorner(simpsurf,data,newtodo,1,splitter,counter,a,b,c);

	Add(listofdrawings, res);
	facesComputed:=res.facesComputed;
	if Length(facesComputed)<NrOfFaces(simpsurf) then
		for f in Faces(simpsurf) do
			if not f in facesComputed then
                                # Restart the loop with a different face
				start:=f;
			fi;
		od;
	fi;	
	Add(RescaleList,res.rescale);
	od;
	drawSimpSurf(listofdrawings,nameoffile,printrecord);
	printrecord.rescalelist:=RescaleList;
end;

computeRescale:=function(simpsurf,data,rescale,a,b,c)
local newdata,i;
newdata:=ShallowCopy(data);
for i in rescale do
	newdata:=computenextfacerescale(simpsurf,newdata,i,a,b,c);
od;

return newdata;
end;

# Assumes that everything is already computed
SimpSurftoTikzRescale:= function(simpsurf, nameoffile,printrecord)
local ConnectedPoints, Points,a,b,c,f,todo,angle13, angle32,listofdrawings,direction32,res,res1,res2,res3,rescale,start, RescaleList,Scale, facesComputed,bottomedge,leftedge,rightedge,label,label2,label3,point2,point3,cosalpha,sinalpha,data,newtodo,counter,splitter,i;
#a,b,c length of edges, set differently if wanted
start:=printrecord.start;
RescaleList:=printrecord.rescalelist;
Scale:=printrecord.scale;
a:=Scale[1];
b:=Scale[2];
c:=Scale[3];
facesComputed:=[];
listofdrawings:=[];

for rescale in RescaleList do

	#Point:=[[horizontal-Koordinate,vertikal-Koordinate],label (so, dass vertices[label] dem Punkt entspricht), angle (needed to compute next point)]
	Points:=[];
	ConnectedPoints:=[]; #[point1,point2,type of connection]
	todo:=[];

	#draw first triangle, 3 is the top corner
	label:=findPoint(simpsurf,start);

	bottomedge:= VerticesOfSimplicialSurface(simpsurf)[label[1]][label[2]][3];
	leftedge:= VerticesOfSimplicialSurface(simpsurf)[label[1]][label[2]][2];
	label2:=findotherPoint(simpsurf,start,bottomedge,label[1]);
	label3:=findotherPoint(simpsurf,start,leftedge,label[1]);

	if bottomedge=1 then
		point2:=[a,0];

		if leftedge=2 then
			rightedge:=3;
			cosalpha:=Float((b^2+a^2-c^2)/(2*b*a));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle13:=[cosalpha,sinalpha];
			point3:=angle13*b;
		fi;
		if leftedge=3 then
			rightedge:=2;
			cosalpha:=Float((c^2+a^2-b^2)/(2*c*a));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle13:=[cosalpha,sinalpha];
			point3:=angle13*c;
		fi;
	fi;
	if bottomedge=2 then
		point2:=[b,0];
	
		if leftedge=1 then
			rightedge:=3;
			cosalpha:=Float((b^2+a^2-c^2)/(2*b*a));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle13:=[cosalpha,sinalpha];
			point3:=angle13*a;
		fi;
		if leftedge=3 then
			rightedge:=1;
			cosalpha:=Float((c^2+b^2-a^2)/(2*c*b));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle13:=[cosalpha,sinalpha];
			point3:=angle13*c;
			fi;
	fi;
	if bottomedge=3 then
		point2:=[c,0];
	
		if leftedge=1 then
			rightedge:=2;
			cosalpha:=Float((c^2+a^2-b^2)/(2*c*a));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle13:=[cosalpha,sinalpha];
			point3:=angle13*a;
		fi;
		if leftedge=2 then
			rightedge:=1;
			cosalpha:=Float((c^2+b^2-a^2)/(2*c*b));
			sinalpha:=Sqrt(Float(1-cosalpha^2));
			angle13:=[cosalpha,sinalpha];
			point3:=angle13*b;
		fi;
	fi;
	direction32:=point2-point3;
	angle32:=direction32/(Sqrt(Float(direction32[1]^2+direction32[2]^2)));
	
	Points[1]:=[[0,0],label,angle13,leftedge,3,2];
	Points[2]:=[point2,label2,[-1,0],bottomedge,1,3];
	Points[3]:=[point3,label3,angle32,rightedge,2,1];
	
	
	ConnectedPoints:=[[1,2,bottomedge],[2,3,rightedge],[1,3,leftedge]]; 
	Add(facesComputed,start); 
	data:=rec(points:=Points, pointsConnected:=ConnectedPoints, facesComputed:=facesComputed, coordinatesoffaces:=[[start,(point3+point2)/3]]);
	#newtodo:=ShallowCopy(listofvertices);
	#splitter:=Length(newtodo);
	#Append(newtodo,[1,2,3]);
	counter:=[];
	for i in [1..NrOfVerticesOfSimplicialSurface(simpsurf)] do
		counter[i]:=0;
	od;
	res:=computeRescale(simpsurf,data,rescale,a,b,c);

	#res:=rec(points:=Points, pointsConnected:=ConnectedPoints, facesComputed:=facesComputed);
	Add(listofdrawings, res);
	facesComputed:=res.facesComputed;
	if Length(facesComputed)<NrOfFacesOfSimplicialSurface(simpsurf) then
		for f in FacesOfSimplicialSurface(simpsurf) do
			if not f in facesComputed then
				start:=f;
			fi;
		od;
	fi;	
	od;
	drawSimpSurf(listofdrawings,nameoffile,printrecord);
end;

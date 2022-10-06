#SVG header
LoadPackage("simpl");

BindGlobal("__SIMPLICIAL_PrintRecordSVGHeader",
	function(printRecord)
		local res;
		res:="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n<svg\n\n   viewBox=\"-500 -500 1000 1000\"\n   id=\"svg7099\"\n   version=\"1.1\"\n   xmlns=\"http://www.w3.org/2000/svg\"\n   >";
		return res;
	end
);	

#Draw Edge for DrawSurfaceToSVG

BindGlobal( "__SIMPLICIAL_PrintRecordDrawSVGEdge",
    function( printRecord, surface, edge, vertexCoord, drawColors )
        local res;

        res := Concatenation("<line\n       x1=\"",String(Int(vertexCoord[1][1])),"\"\n       y1=\"",String(Int(vertexCoord[1][2])),"\"\n       x2=\"",String(Int(vertexCoord[2][1])),"\"\n       y2=\"",String(Int(vertexCoord[2][2])),"\" \n"       );
	
	if IsBound( printRecord!.edgeColours[edge] ) and  drawColors then
            res := Concatenation(res, "style=\"stroke:",printRecord!.edgeColours[edge],";stroke-width:2\"");
        fi;
	res:=Concatenation(res,"/>\n");
	return res;
    end
);

__SIMPLICIAL_PrintRecordDrawSVGEdgeREC:=function(printRecord, surface, edge, vertexCoord, drawColors )
	local eps,normal_vec,v,p1,p2,p3,p4,res,i;
	eps:=3;
	v:=vertexCoord[1]-vertexCoord[2];
	if Norm(v[1])<Float(10^-10) then
		normal_vec:= [1,0];
	else
		normal_vec:= [-v[2]/v[1],1];
	fi;
	normal_vec:=eps*normal_vec/Sqrt(normal_vec[1]^2+normal_vec[2]^2);
	p1:=List(vertexCoord[1]+normal_vec,i->Int(i));
	p2:=List(vertexCoord[1]-normal_vec,i->Int(i));
	p3:=List(vertexCoord[2]+normal_vec,i->Int(i));
	p4:=List(vertexCoord[2]-normal_vec,i->Int(i));
	res:=Concatenation("<polygon points=\"",String(p1[1]),",",String(p1[2])," ",String(p2[1]),",",String(p2[2])," ",String(p4[1]),",",String(p4[2])," ",String(p3[1]),",",String(p3[2]),"\"");
	if IsBound( printRecord!.edgeColours[edge] ) and  drawColors then
            res := Concatenation(res, " style=\"fill:",printRecord!.edgeColours[edge], "\"");
        fi;
	res:=Concatenation(res,"/>\n");
	return res;
end;;
	
BindGlobal( "__SIMPLICIAL_AddFlap",
    function( printRecord, surface, vertexCoord, flappoints )
        local res,i,j,cx,cy,r;
	#round coordinates for svg format
	vertexCoord:=List(vertexCoord,i->List(i,j->Int(j)));
	flappoints:=List(flappoints,i->List(i,j->Int(j)));
	res:="";
	#if printRecord!.AddCircle and Size(flappoints)=1 then
	#	cx:= Int((vertexCoord[1][1]+vertexCoord[2][1]+ flappoints[1][1])/3.);
	#	cy:=Int((vertexCoord[1][2]+vertexCoord[2][2]+ flappoints[1][2])/3.);
	#	r:=10;
	#	res:=Concatenation(res,"<circle r=\"",String(r),"\" cx=\"",String(cx),"\" cy=\"",String(cy),"\"  class=\"external-circle\" stroke-width=\"4\" fill=\"none\" stroke=\"black\"></circle> \n");
	#fi;
	
	res:=Concatenation(res,"<!-- start flap -->\n");
	if Size(flappoints)=2 then
        res := Concatenation(res,"<line\n       x1=\"",String(vertexCoord[1][1]),"\"\n       y1=\"",String(vertexCoord[1][2]),"\"\n       x2=\"",String(flappoints[1][1]),"\"\n       y2=\"",String(flappoints[1][2]),"\"       />\n");
		res := Concatenation(res,"<line\n       x1=\"",String(flappoints[1][1]),"\"\n       y1=\"",String(flappoints[1][2]),"\"\n       x2=\"",String(flappoints[2][1]),"\"\n       y2=\"",String(flappoints[2][2]),"\"       />\n");
		res := Concatenation(res,"<line\n       x1=\"",String(vertexCoord[2][1]),"\"\n       y1=\"",String(vertexCoord[2][2]),"\"\n       x2=\"",String(flappoints[2][1]),"\"\n       y2=\"",String(flappoints[2][2]),"\"       />\n");
	else
        res := Concatenation(res,"<line\n       x1=\"",String(vertexCoord[1][1]),"\"\n       y1=\"",String(vertexCoord[1][2]),"\"\n       x2=\"",String(flappoints[1][1]),"\"\n       y2=\"",String(flappoints[1][2]),"\"       />\n");  
		res := Concatenation(res,"<line\n       x1=\"",String(vertexCoord[2][1]),"\"\n       y1=\"",String(vertexCoord[2][2]),"\"\n       x2=\"",String(flappoints[1][1]),"\"\n       y2=\"",String(flappoints[1][2]),"\"       />\n");
	fi;
		
		res:=Concatenation(res,"<!-- end -->\n");
	return res;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordDrawFaceSVG",
    function(printRecord, surface, f, vertexCoord)
    local res,cx,cy,r,v,temp,temp1,sum1,sum2;
    		
    res:="";

   res:=Concatenation(res,"<polygon points=\"");
   v:=0;
   temp:=[VerticesOfFace(surface,f)[1]];
   while Length(temp)<Length(VerticesOfFace(surface,f)) do
	v:=temp[Length(temp)];
	res:=Concatenation(res,String(Int(vertexCoord[v][1])),",",String(Int(vertexCoord[v][2]))," ");
temp1:=Intersection(VerticesOfFace(surface,f),NeighbourVerticesOfVertex(surface,v));
        v:=Difference(temp1,temp)[1];
	Add(temp,v);  

   od;
   res:=Concatenation(res,String(Int(vertexCoord[v][1])),",",String(Int(vertexCoord[v][2])),"\""," ");
   if IsBound( printRecord!.faceColours[f] )then
            res := Concatenation(res, " style=\"fill:",printRecord!.faceColours[f], "\"");
   fi;
	res:=Concatenation(res,"/>\n");
    if IsBound(printRecord!.AddCircle) then
		if printRecord!.AddCircle then
	            sum1:=0;
	            sum2:=0;
		   for v in VerticesOfFace(surface,f) do
			sum1:=sum1+vertexCoord[v][1];
			sum2:=sum2+vertexCoord[v][2];
		   od;	
	 	   sum1:=sum1/Length(VerticesOfFace(surface,f));
		   sum2:=sum2/Length(VerticesOfFace(surface,f));	
	           cx:= Int(sum1);
		   cy:=Int(sum2);
		   r:=10;
		   res:=Concatenation(res,"<circle r=\"",String(r),"\" cx=\"",String(cx),"\" cy=\"",String(cy),"\"  class=\"external-circle\" stroke-width=\"4\" fill=\"none\" stroke=\"black\"></circle> \n");
		fi;	
	fi;
	return res;
    end
);

SIMPLICIAL_PrintRecordFaceLabelSVG:=function(cx,cy,scale,f)
	local res,temp,tf,i,helper_faceLabel;
	helper_faceLabel:=function(x,y,scale,n)
    	local faceLabel;
	faceLabel:=List([1..10],g->"");
	faceLabel[1]:=Concatenation(faceLabel[1],"<path class=\"cls-1\" d=\"M6\.12-1c0,5\.76-2\.29,8\.94-6\.24,8\.94-3\.51,0-5\.92-3\.1-6-8\.71S-3\.47-9\.58\.18-9\.58,6\.12-6\.4,6\.12-1Zm-9\.75\.26c0,4\.4,1\.43,6\.91,3\.65,6\.91,2\.45,0,3\.64-2\.74,3\.64-7\.07,0-4\.17-1\.1-6\.91-3\.64-6\.91C-2\.08-7\.81-3\.63-5\.36-3\.63-\.74Z\" transform=\"translate(",String(x)," ", String(y),") scale(",String(0.01*scale),",",String(0.01*scale),") \" />\n");

	faceLabel[2]:=Concatenation(faceLabel[2],"<path class=\"cls-1\" d=\"M1\.54-10\.6H1\.4L-6-7\.94l-1\.11-2\.92,9\.28-3\.31h4\.9V14\.17H1\.54Z\" transform=\" translate(",String(x)," ", String(y),") scale(",String(0.006*scale),",",String(0.006*scale),")\" />\n");

	faceLabel[3]:=Concatenation(faceLabel[3],"<path class=\"cls-1\" d=\"M-5\.84,7\.65V6\.25l1\.9-1\.75C\.65\.38,2\.75-1\.81,2\.75-4\.37c0-1\.72-\.86-3\.31-3\.54-3\.31A6\.32,6\.32,0,0,0-4\.6-6\.25l-\.77-1\.61A8\.19,8\.19,0,0,1-\.32-9\.58c3\.87,0,5\.5,2\.5,5\.5,4\.93C5\.18-1\.53,2\.78,1-1,4\.45L-2\.42,5\.7v0h8v1\.9Z\"  transform=\"translate(",String(x)," ", String(y),") scale(",String(0.01*scale),",",String(0.01*scale),") \" />\n");

	faceLabel[4]:=Concatenation(faceLabel[4],"<path class=\"cls-1\" d=\"M-5\.26,5\.05a8\.73,8\.73,0,0,0,4,1c3\.09,0,4\.09-1\.85,4\.06-3\.29C2\.75\.43\.49-\.59-1\.86-\.59H-3\.22V-2\.31h1\.36c1\.76,0,4-\.86,4-2\.87,0-1\.35-\.91-2\.55-3\.15-2\.55A6\.87,6\.87,0,0,0-4\.6-6\.61l-\.66-1\.67A9\.08,9\.08,0,0,1-\.54-9\.58c3\.54,0,5\.14,2,5\.14,4,0,1\.77-1\.13,3\.26-3\.31,4v\.06a4\.47,4\.47,0,0,1,4,4\.33C5\.29,5\.57,3,7\.94-1\.26,7\.94A9\.56,9\.56,0,0,1-5\.93,6\.79Z\" transform=\"translate(",String(x)," ", String(y),") scale(",String(0.01*scale),",",String(0.01*scale),") \" />\n");

faceLabel[5]:=Concatenation(faceLabel[5],"<path class=\"cls-1\" d=\"M1\.67,7\.65V3H-6\.67V1\.53l8-10\.83H4V1\.24H6\.48V3H4V7\.65Zm0-6\.41V-4\.42c0-\.89,0-1\.77\.09-2\.66H1.67c-\.55,1-1,1\.72-1\.49,2\.5L-4\.21,1\.19v\.05Z\" transform=\" translate(",String(x)," ", String(y),") scale(",String(0.01*scale),",",String(0.01*scale),") \" />\n");

faceLabel[6]:=Concatenation(faceLabel[6],"<path class=\"cls-1\" d=\"M4\.88-7\.37H-2L-2\.67-3A11\.32,11\.32,0,0,1-1\.2-3\.09a7\.64,7\.64,0,0,1,3\.87\.91A4\.75,4\.75,0,0,1,5\.24,2\.15c0,3\.31-2\.79,5\.79-6\.69,5\.79a9\.35,9\.35,0,0,1-4\.48-1l\.61-1\.75a8\.42,8\.42,0,0,0,3\.87\.94c2\.27,0,4\.26-1\.41,4\.23-3\.68S1\.2-1\.32-2\.36-1\.32a20\.22,20\.22,0,0,0-2\.52\.16L-3\.72-9\.3h8\.6Z\" transform=\"translate(",String(x)," ", String(y),") scale(",String(0.01*scale),",",String(0.01*scale),") \" />\n");

faceLabel[7]:=Concatenation(faceLabel[7],"<path class=\"cls-1\" d=\"M4\.41-7\.68a9\.51,9\.51,0,0,0-1\.82\.13,7,7,0,0,0-6\.25,6h\.06a5\.43,5\.43,0,0,1,4\.36-2A5\.18,5\.18,0,0,1,6\.18,1\.94a5\.83,5\.83,0,0,1-6,6c-3\.81,0-6\.33-2\.82-6\.33-7\.22a10\.25,10\.25,0,0,1,3-7\.64A10,10,0,0,1,2\.64-9\.43a13\.07,13\.07,0,0,1,1\.77-\.13ZM3\.72,2\.1A3\.53,3\.53,0,0,0,0-1\.79,4,4,0,0,0-3\.49.3a2,2,0,0,0-\.25,1c0,2\.79,1\.41,4\.88,4,4\.88C2\.31,6\.17,3\.72,4\.52,3\.72,2\.1Z\" transform=\"translate(",String(x)," ", String(y),") scale(",String(0.01*scale),",",String(0.01*scale),") \" />\n");

faceLabel[8]:=Concatenation(faceLabel[8],"<path class=\"cls-1\" d=\"M5\.82-9\.3v1\.52L-2,7\.65H-4\.52l7\.8-15v0H-5\.51V-9\.3Z\" transform=\" translate(",String(x)," ", String(y),") scale(",String(0.01*scale),",",String(0.01*scale),") \" />\n");

faceLabel[9]:=Concatenation(faceLabel[9],"<path class=\"cls-1\" d=\"M-2\.53-1\.26A4\.21,4\.21,0,0,1-5\.4-5\.07C-5\.4-7\.76-3-9\.58\.18-9\.58c3\.48,0,5\.25,2,5\.25,4\.17,0,1\.43-\.77,3-3,4v.08C4\.69-\.53,6\.07,1,6\.07,3,6\.07,6,3\.39,7\.94,0,7\.94c-3\.76,0-6-2\.09-6-4\.56,0-2\.14,1\.35-3\.68,3\.56-4\.57ZM3\.61,3\.25c0-2-1\.52-3-3\.95-3\.71-2\.1\.58-3\.24,1\.91-3\.24,3\.52S-2\.28,6\.27,0,6\.27,3\.61,5,3\.61,3\.25ZM-3\.08-5\.23c0,1\.7,1\.35,2\.61,3\.43,3\.13C1\.9-2\.59,3\.08-3\.64,3\.08-5\.18A2\.71,2\.71,0,0,0,0-7\.94C-2-7\.94-3\.08-6\.69-3\.08-5\.23Z\"  transform=\"translate(",String(cx)," ", String(cy),") scale(",String(0.01*scale),",",String(0.01*scale),") \" />\n");

faceLabel[10]:=Concatenation(faceLabel[10],"<path class=\"cls-1\" d=\"M-4\.43,6a10\.8,10\.8,0,0,0,2-\.08A6\.84,6\.84,0,0,0,1\.29,4\.32,7\.36,7\.36,0,0,0,3\.66-\.17H3\.58A5\.39,5\.39,0,0,1-\.68,1\.63,5,5,0,0,1-5\.95-3\.56a6,6,0,0,1,6\.13-6c3\.68,0,5\.94,2\.79,5\.94,7\.17A10\.37,10\.37,0,0,1,3,5\.52,9\.21,9\.21,0,0,1-2\.2,7\.78a11\.59,11\.59,0,0,1-2\.23\.13Zm\.88-9\.73A3\.34,3\.34,0,0,0-\.1-\.09,4\.08,4\.08,0,0,0,3\.44-1\.86a1\.55,1\.55,0,0,0,\.22-\.87c0-2\.89-1\.13-5\.11-3\.7-5\.11C-2\.08-7\.84-3\.55-6\.12-3\.55-3\.69Z\" transform=\" translate(",String(x)," ", String(y),") scale(",String(0.01*scale),",",String(0.01*scale),") \" />\n");
	return faceLabel[n+1];
end;
	temp:=[];
	tf:=f;
	while tf<>0 do 
		Add(temp,tf mod 10);
		tf:=(tf-(tf mod 10))/10;
	od;

	res:="";	
	res:=Concatenation( res, "<!-- Draw the facelabel -->\n" );
	for i in [1..Length(temp)] do
		res:=Concatenation(res,helper_faceLabel(cx+15*0.01*scale*(Length(temp)/2.-i),cy,scale,temp[i]));
	od;	
	return res;
    end;


#Draw Face Labels

SIMPLICIAL_PrintRecordDrawFaceLabelSVG:=function(printRecord, surface,f,vertexCoord,scale)
    	local res,cx,cy,r,v,temp,temp1,sum1,sum2,m;
            sum1:=0;
            sum2:=0;
	   for v in VerticesOfFace(surface,f) do
		sum1:=sum1+vertexCoord[v][1];
		sum2:=sum2+vertexCoord[v][2];    
	   od;	
 	   sum1:=sum1/Length(VerticesOfFace(surface,f));
	   sum2:=sum2/Length(VerticesOfFace(surface,f));	
           cx:= Int(sum1);
	   cy:=Int(sum2);
	   res:="";
	m:=Maximum(List(vertexCoord,g->g[2]));
	if Length(Filtered(vertexCoord,g->AbsoluteValue(g[2]-m)<=0.1))=2 then
	    res:=Concatenation(res,SIMPLICIAL_PrintRecordFaceLabelSVG(cx+4,cy-5,scale,f));
	else
res:=Concatenation(res,SIMPLICIAL_PrintRecordFaceLabelSVG(cx+4,cy+2,scale,f));
	fi;
return res;
#	fi;

    end;


#TODO write this into embedding.gd
DeclareOperation( "DrawSurfaceToSVG", [IsPolygonalComplex and IsNotEdgeRamified, IsString, IsRecord] );

InstallMethod( DrawSurfaceToSVG, 
    "for a polygonal complex without edge ramifications, a filename and a record",
    [IsPolygonalComplex and IsNotEdgeRamified, IsString, IsRecord],
    function(surface, fileName, printRecord)
        local file, output, f, v,g, i, positions, comp, 
            allVertexCoords, TikzCoordFromVertexPosition, unplacedFaces,
            strongComponents, start, computedFace, nextFct, checkFct, k,
            nextEdge, firstEdge, rejected, repeatData, tries, proposedEdge,
            adFace, vertexData, edgeData, testResults, e, ends, facePath,
            vertexEdgeData, success, j, vertexCoords, vertexPositions, 
            lastOrder, nextFctIndex, oldFace, pos, strongComp, drawComp,
            drawIndex, ind, drawIndices, strongCompNumber, helperRound, helperRoundNumber, helperFlap, scale, scoreFlaps,helperThirdPoint, cur, helperNormalVector, helperNorm, helperNotIn, helperInTriangle,help_geodesic,round2,epsi,temp,classLen,edgeLen,classCol,edgeCol,flapTriangles,helperLineIntersection,
	    helperEdgeIntersection;

    if IsEdgeColouredPolygonalComplex(surface) then

    if not IsBound(printRecord.edgeColourClassActive) then
            printRecord.edgeColourClassActive := true;
        fi;

        if printRecord.edgeColourClassActive then
            if IsBound(printRecord.edgeColourClassLengths) then
                classLen := printRecord.edgeColourClassLengths;
                if not IsList(classLen) then
                    Print("Warning: edgeColourClassLengths should be a list.");
                else
                    # We require that all colours are given
                    # change that and allow partial information
                    if not PositionsBound(classLen) = Set(ColoursOfEdges(surface)) then
                        Error("DrawSurfaceToTikz: In edgeColourClassLengths there has to be a length for every colour (and only for the appearing colours).");
                    fi;
                    edgeLen := [];
                    for e in Edges(PolygonalComplex(surface)) do
                        edgeLen[e] := classLen[ColourOfEdgeNC(surface, e)];
                    od;
                    printRecord.edgeLengths := edgeLen;
                fi;
            fi;

            if not IsBound(printRecord.edgeColourClassColours) and Length(Set(ColoursOfEdges(surface))) = 3 then
                printRecord.edgeColourClassColours := ["red","blue","green"];
            fi; # this is a special case for 3 colours - what can be done in general?
            if IsBound(printRecord.edgeColourClassColours) then
                classCol := printRecord.edgeColourClassColours;
                if not IsList(classCol) then
                    Print("Warning: edgeColourClassColours should be a list.");
                else
                    # We require that all colours are given
                    # change that and allow partial information
                    if not PositionsBound(classCol) = Set(ColoursOfEdges(surface)) then
                        Error("DrawSurfaceToTikz: In edgeColourClassColours there has to be a colour for every colour (and only for the appearing colours).");
                    fi;
                    edgeCol := [];
                    for e in Edges(PolygonalComplex(surface)) do
                        edgeCol[e] := classCol[ColourOfEdgeNC(surface, e)];
                    od;
                    printRecord.edgeColours := edgeCol;
                fi;
            fi;
        fi;
    fi;

    # the scale attribute scales the output image
	if IsBound(printRecord!.scale) then 
		scale:=printRecord!.scale;
	else 
		printRecord!.scale:=100;
	fi;
	scale:=printRecord!.scale;

	# Euclidean Norm in two dimensions
	helperNorm:=function(v)
		return 	Sqrt(v[1]^2+v[2]^2);
	end;

	# normal vector for vector v in two dimensions
	helperNormalVector:=function(v)
		if Norm(v[1])<Float(10^-10) then
			return [1,0];
		else
			return [-v[2]/v[1],1];
		fi;
	end;
	
	#find third point of the triangle with edge e[k]
	helperThirdPoint:=function(e,k)
		local l1,l2,ll,j,res;
		e:=printRecord!.edgeEndpoints[e];
		ll:=printRecord!.faceVertices;
		#l1:=List(ll,p->Position(p[1],e[i][1]));
		#l2:=List(ll,p->Position(p[1],e[i][2]));	
		for j in [1..Size(ll)] do
			if  e[k][1] in ll[j][1] and e[k][2] in ll[j][1] then
				res:=StructuralCopy(ll[j][1]);
				Remove(res,Position(res,e[k][1]));
				Remove(res,Position(res,e[k][2]));
				return [res[1],j,Position(ll[j][1],e[k][1]),Position(ll[j][1],e[k][2])];
			fi;
		od;
	end;
	
	# returns false if point is contained in a face or flap
	helperNotIn:=function(point)
		local px,py, p0x, p0y, p1x, p1y, p2x, p2y, face;
		for f in printRecord!.faceVertices do
			for face in f do
				p0x:=printRecord!.vertexCoordinates[face[1][1]][face[1][2]][1];
				p0y:=printRecord!.vertexCoordinates[face[1][1]][face[1][2]][2];
				p1x:=printRecord!.vertexCoordinates[face[2][1]][face[2][2]][1];
				p1y:=printRecord!.vertexCoordinates[face[2][1]][face[2][2]][2];
				p2x:=printRecord!.vertexCoordinates[face[3][1]][face[3][2]][1];
				p2y:=printRecord!.vertexCoordinates[face[3][1]][face[3][2]][2];
				if helperInTriangle(point[1],point[2], p0x, p0y, p1x, p1y, p2x, p2y) then
					return false;
				fi;
			od;
			# test also flaps
			for face in flapTriangles do
				p0x:=face[1][1];
				p0y:=face[1][2];
				p1x:=face[2][1];
				p1y:=face[2][2];
				p2x:=face[3][1];
				p2y:=face[3][2];
				if helperInTriangle(point[1],point[2], p0x, p0y, p1x, p1y, p2x, p2y) then
					return false;
				fi;
			od;
		od;
		return true;
	end;

# test if edge given by p0,p1 intersects edges of the drawn net (intersections at vertices are ignored)

helperEdgeIntersection:=function(p0,  p1)
	local edges,edge;
	for edges in printRecord!.edgeEndpoints do
		for edge in edges do
			if helperLineIntersection(p0,p1,printRecord!.vertexCoordinates[edge[1][1]][edge[1][2]]{[1,2]},printRecord!.vertexCoordinates[edge[2][1]][edge[2][2]]{[1,2]}) then
				return true;
			fi;
		od;
	od;
	return false;
end;


# https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect Gavin's Answer
helperLineIntersection:=function( p0,  p1, 
     p2,  p3)
		local  s1_x, s1_y, s2_x, s2_y,s,t,p0_x,p0_y,p1_x,p1_y,p2_x,p2_y,p3_x,p3_y,eps;
		eps:=1.*10^(-6);
		p0_x:=p0[1];
		p0_y:=p0[2];
		p1_x:=p1[1];
		p1_y:=p1[2];
		p2_x:=p2[1];
		p2_y:=p2[2];
		p3_x:=p3[1];
		p3_y:=p3[2];
		s1_x := p1_x - p0_x;     s1_y := p1_y - p0_y;
    	s2_x := p3_x - p2_x;     s2_y := p3_y - p2_y;
    # colinear for now return false	
    if epsi(-s2_x * s1_y + s1_x * s2_y) then
    	return false;
    fi;
    s := (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y);
    t := ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y);

    if s > 0.+eps and s < 1.-eps and t > 0.+eps and t < 1.-eps then
    	return true;
    fi;

    return false;
end;
	
	
	# returns false if point given by px and py is contained in the face given by the points p0,p1,p2
	helperInTriangle:=function(px,py, p0x, p0y, p1x, p1y, p2x, p2y)
		local Area, s, t;
		Area := 0.5 *(-p1y*p2x + p0y*(-p1x + p2x) + p0x*(p1y - p2y) + p1x*p2y);
		s := 1/(2*Area)*(p0y*p2x - p0x*p2y + (p2y - p0y)*px + (p0x - p2x)*py);
		t := 1/(2*Area)*(p0x*p1y - p0y*p1x + (p0y - p1y)*px + (p1x - p0x)*py);
		return s>=0. and t>=0. and 1.-s-t>=0.;
	end;
		
	# we save all flaps in triangles
	flapTriangles:=[];

	# calculate flap for gluing
	helperFlap := function(e)
		local angle_l,angle_r,l,normal_vector,third_point,angle, flap_point_l, flap_point_r,middle_point, flap_point, length, vector_e, rot_matrix, triangle, third_point_2, index, rot_angle, f1, f2, VoEinf1_vc, VoEinf1, e2, FoE,swap;
		if IsBound(printRecord!.AddFlapTriangle) then 
			if printRecord!.AddFlapTriangle then
				#Identify Edges that will be glued together
				#Flap is added to triangle f at edge e and has the shape of f' where f' is the other face with edge e
				FoE:=FacesOfEdge(surface,e);
				#we assume that e is inner
				f1:=FoE[1];
				f2:=FoE[2];
				if not IsSubset(printRecord!.faceVertices[f1][1],printRecord!.edgeEndpoints[e][1]{[1,2]}) then
					f1:=FoE[2];
					f2:=FoE[1];
				fi;
				#get common vertex of f1 and f2
				v:=VerticesOfEdge(surface,e)[1];
				#get angle of v in f2
				angle:=printRecord!.angles[f2][v];
				#get edge other than e in f2 incident to v
				e2:=Filtered(EdgesOfFace(surface,f2),j-> v in VerticesOfEdge(surface,j) and j <> e)[1]; 
				#get length of e2
				length:=printRecord!.edgeLengths[e2];
				#get vertices of first appearance of edge e
				VoEinf1:=Filtered(printRecord!.faceVertices[f1][1],j->j[1] in VerticesOfEdge(surface,e));
				#get vertex coordinates
				VoEinf1_vc:=[printRecord!.vertexCoordinates[VoEinf1[1][1]][VoEinf1[1][2]],printRecord!.vertexCoordinates[VoEinf1[2][1]][VoEinf1[2][2]]];
				triangle:=[];
				if v = VoEinf1[1][1] then
					vector_e:=VoEinf1_vc[2]-VoEinf1_vc[1];
					Add(triangle,VoEinf1_vc[1]);
					Add(triangle,VoEinf1_vc[2]);
				else
					vector_e:=VoEinf1_vc[1]-VoEinf1_vc[2];
					Add(triangle,VoEinf1_vc[2]);
					Add(triangle,VoEinf1_vc[1]);
				fi;
				vector_e:=vector_e{[1,2]};
				#normalize vector_e
				vector_e:=vector_e/helperNorm(vector_e);
				#get rotation angle
				rot_angle:=printRecord!.angles[f2][v];
				#get rotation matrix	
				rot_matrix:=[[rot_angle[2],-rot_angle[1]],[rot_angle[1],rot_angle[2]]];
				#calculate flap_point
				index:=Filtered(printRecord!.faceVertices[f1][1],j->j[1]=v)[1][2];
				#case distinction for left or right-hand rotation via https://math.stackexchange.com/questions/1324179/how-to-tell-if-3-connected-points-are-connected-clockwise-or-counter-clockwise
				third_point_2:=helperThirdPoint(e,1)[1];
				third_point_2:=printRecord!.vertexCoordinates[third_point_2[1]][third_point_2[2]];
				Add(triangle,third_point_2);
				
				if DeterminantMat(triangle*1.)<0. then
					rot_matrix:=TransposedMat(rot_matrix);
				fi;
				
				flap_point:=vector_e*rot_matrix*length+printRecord!.vertexCoordinates[v][index]{[1,2]};
				# test if flap_point lies inside the net
				#return [helperRound([flap_point]),1];
				#if helperNotIn(flap_point) then
				if not helperEdgeIntersection(triangle[1],flap_point) and not helperEdgeIntersection(triangle[2],flap_point) then
					return [[flap_point],1];
				else
					# try other edge
					swap:=f1;
					f1:=f2;
					f2:=swap;
					#get common vertex of f1 and f2
					v:=VerticesOfEdge(surface,e)[1];
					#get angle of v in f2
					angle:=printRecord!.angles[f2][v];
					#get edge other than e in f2 incident to v
					e2:=Filtered(EdgesOfFace(surface,f2),j-> v in VerticesOfEdge(surface,j) and j <> e)[1]; 
					#get length of e2
					length:=printRecord!.edgeLengths[e2];
					#get vertices of first appearance of edge e
					VoEinf1:=Filtered(printRecord!.faceVertices[f1][1],j->j[1] in VerticesOfEdge(surface,e));
					#get vertex coordinates
					VoEinf1_vc:=[printRecord!.vertexCoordinates[VoEinf1[1][1]][VoEinf1[1][2]],printRecord!.vertexCoordinates[VoEinf1[2][1]][VoEinf1[2][2]]];
					triangle:=[];
					if v = VoEinf1[1][1] then
						vector_e:=VoEinf1_vc[2]-VoEinf1_vc[1];
						Add(triangle,VoEinf1_vc[1]);
						Add(triangle,VoEinf1_vc[2]);
					else
						vector_e:=VoEinf1_vc[1]-VoEinf1_vc[2];
						Add(triangle,VoEinf1_vc[2]);
						Add(triangle,VoEinf1_vc[1]);
					fi;
					vector_e:=vector_e{[1,2]};
					#normalize vector_e
					vector_e:=vector_e/helperNorm(vector_e);
					#get rotation angle
					rot_angle:=printRecord!.angles[f2][v];
					#get rotation matrix	
					rot_matrix:=[[rot_angle[2],-rot_angle[1]],[rot_angle[1],rot_angle[2]]];
					#calculate flap_point
					index:=Filtered(printRecord!.faceVertices[f1][1],j->j[1]=v)[1][2];
					#case distinction for left or right-hand rotation via https://math.stackexchange.com/questions/1324179/how-to-tell-if-3-connected-points-are-connected-clockwise-or-counter-clockwise
					third_point_2:=helperThirdPoint(e,2)[1];
					third_point_2:=printRecord!.vertexCoordinates[third_point_2[1]][third_point_2[2]];
					Add(triangle,third_point_2);
					
					if DeterminantMat(triangle*1.)<0. then
						rot_matrix:=TransposedMat(rot_matrix);
					fi;
					
					flap_point:=vector_e*rot_matrix*length+printRecord!.vertexCoordinates[v][index]{[1,2]};
					
					if not helperEdgeIntersection(triangle[1],flap_point) and not helperEdgeIntersection(triangle[2],flap_point) then
						return [[flap_point],2];
					fi;
				fi;
			fi;
		fi;


		if IsBound(printRecord!.AddFlaps) then 
			if printRecord!.AddFlaps then





				#get vertices of first appearance of edge e
				l:=List( printRecord!.edgeEndpoints[e][1]{[1,2]}, p -> printRecord!.vertexCoordinates[p[1]][p[2]]{[1,2]});
				
				#normal_vector:=helperNormalVector(l[1]-l[2]);
				#get third point of the triangle
				third_point:=helperThirdPoint(e,2);
				#get angle
				angle:=printRecord!.angles[third_point[2]][printRecord!.edgeEndpoints[e][1][1][1]];
				angle:=[angle[2],angle[1]];
				angle:=[Cos(Acos(angle[1])),Sin(Asin(angle[2]))];
				flap_point_l:= ([[angle[1],-angle[2]],[angle[2],angle[1]]])*(l[2]-l[1])*1/4+l[1];
				angle:=printRecord!.angles[third_point[2]][printRecord!.edgeEndpoints[e][1][2][1]];
				angle:=[angle[2],angle[1]];
				angle:=[Cos(Acos(angle[1])),Sin(Asin(angle[2]))];
				flap_point_r:= ([[angle[1],angle[2]],[-angle[2],angle[1]]])*(l[1]-l[2])*1/4+l[2];
				if not helperEdgeIntersection(l[1],flap_point_l) and not helperEdgeIntersection(l[1],flap_point_r) and not helperEdgeIntersection(l[2],flap_point_l) and not helperEdgeIntersection(l[2],flap_point_r) and not helperEdgeIntersection(flap_point_l,flap_point_r) then
					return [[flap_point_l,flap_point_r],1];
				else
					l:=List( printRecord!.edgeEndpoints[e][2]{[1,2]}, p -> printRecord!.vertexCoordinates[p[1]][p[2]]{[1,2]});
					normal_vector:=helperNormalVector(l[1]-l[2]);
					third_point:=helperThirdPoint(e,2)[1];
					#sgn:= SignFloat(normal_vector*printRecord!.vertexCoordinates[third_point[1]][third_point[2]]+normal_vector*l[1]);
					third_point:=helperThirdPoint(e,1);
					angle:=printRecord!.angles[third_point[2]][printRecord!.edgeEndpoints[e][2][1][1]];
					angle:=[angle[2],angle[1]];
					angle:=[Cos(Acos(angle[1])),Sin(Asin(angle[2]))];
					flap_point_l:= ([[angle[1],-angle[2]],[angle[2],angle[1]]])*(l[2]-l[1])*1/4+l[1];
					angle:=printRecord!.angles[third_point[2]][printRecord!.edgeEndpoints[e][2][2][1]];
					angle:=[angle[2],angle[1]];
					angle:=[Cos(Acos(angle[1])),Sin(Asin(angle[2]))];
					flap_point_r:= ([[angle[1],angle[2]],[-angle[2],angle[1]]])*(l[1]-l[2])*1/4+l[2];
					if not helperEdgeIntersection(l[1],flap_point_l) and not helperEdgeIntersection(l[1],flap_point_r) and not helperEdgeIntersection(l[2],flap_point_l) and not helperEdgeIntersection(l[2],flap_point_r) and not helperEdgeIntersection(flap_point_l,flap_point_r) then
						return [[flap_point_l,flap_point_r],2];
					else
						#situation when the two appearances of the edges e are adjacent
						l:=List( printRecord!.edgeEndpoints[e][2]{[1,2]}, p -> printRecord!.vertexCoordinates[p[1]][p[2]]{[1,2]});
						normal_vector:=helperNormalVector(l[1]-l[2]);
						third_point:=helperThirdPoint(e,2)[1];
						#sgn:= SignFloat(normal_vector*printRecord!.vertexCoordinates[third_point[1]][third_point[2]]+normal_vector*l[1]);
						third_point:=helperThirdPoint(e,1);
						angle:=printRecord!.angles[third_point[2]][printRecord!.edgeEndpoints[e][2][1][1]];
						angle:=[angle[2],angle[1]];
						angle:=[Cos(0.25*Acos(angle[1])),Sin(0.25*Asin(angle[2]))];
						flap_point_l:= ([[angle[1],-angle[2]],[angle[2],angle[1]]])*(l[2]-l[1])*1/4+l[1];
						angle:=printRecord!.angles[third_point[2]][printRecord!.edgeEndpoints[e][2][2][1]];
						angle:=[angle[2],angle[1]];
						angle:=[Cos(0.25*Acos(angle[1])),Sin(0.25*Asin(angle[2]))];
						flap_point_r:= ([[angle[1],angle[2]],[-angle[2],angle[1]]])*(l[1]-l[2])*1/4+l[2];
						if not helperEdgeIntersection(l[1],flap_point_l) and not helperEdgeIntersection(l[1],flap_point_r) and not helperEdgeIntersection(l[2],flap_point_l) and not helperEdgeIntersection(l[2],flap_point_r) and not helperEdgeIntersection(flap_point_l,flap_point_r) then
							#return [[flap_point_l,flap_point_r],2];
						fi;

					fi;
				fi;
			fi;
		fi;
	return [];	
		
	end;	


	helperRoundNumber:=function(p)
		return 	 Round(scale * 100. * p[1]) / 100.;
	end;

        helperRound := function(l)
		local p,o;
		if Size(l[Length(l)])=3 then
			return List(l,p->[Round(scale * 100. * p[1]) / 100,Round(scale * 100. * p[2]) / 100., p[3]]);
		else
			return List(l,p->List(p,o->Round(scale * 100. * o) / 100.));
		fi;
	end;
	round2:=function(coor)
		return List(coor,g->Round(scale * 100. * g) / 100);
	end;

	epsi:=function(x)
		if AbsoluteValue(x*1.)<0.001 then 
			return true;
		else
			return false;
		fi;
	end;
    help_geodesic:=function(S, printRecord,output)	
	local g,temp,max,f,vertices,c1,c2,c3,t1,
	t2,a1,a2,b1,b2,e,vec1,vec2,i,coorV,t,a,edges,edgeLen;
	edgeLen:=printRecord.edgeLengths[1];
	if IsBound(printRecord.AddGeodesic) and Set(printRecord.edgeLengths)=[edgeLen] then 
	    if printRecord.AddGeodesic then 
		AppendTo(output,"<!--start with geodesic--> \n");
		AppendTo(output,"\n<g\n  style=\"stroke:black;stroke-width:2\" >");
		for f in Faces(S) do
		    ## get vertexcoordinates
		    edges:=EdgesOfFace(S,f);
		    edges:=Filtered(edges,g->Length(printRecord.edgeEndpoints[g])=1)[1];
		    edges:=printRecord.edgeEndpoints[edges][1]{[1,2]};
		    coorV:=List(edges,g->printRecord.vertexCoordinates[g[1]][g[2]]);
		    coorV:=List(coorV,g->[g[1],g[2]]);
		    v:=Difference(VerticesOfFace(S,f),[edges[1][1],edges[2][1]])[1];
		    v:=List(printRecord.vertexCoordinates[v],g->[g[1],g[2]]);
		    v:=Filtered(v,g->epsi(edgeLen-helperNorm(g-coorV[1]))and epsi(edgeLen-helperNorm(g-coorV[2])));
		    Append(coorV,v);
		    max:=Maximum([coorV[1][2],coorV[2][2],coorV[3][2]]);
		    temp:=Filtered(coorV,g->epsi(g[2]-max));
		    a:=0;
		    if Length(temp)=1 then 
			c1:=temp[1];
			c2:=Filtered(coorV,g->g[1]<c1[1])[1];
			c3:=Difference(coorV,[c1,c2])[1];
			a:=1;
		    else
			c1:=Difference(coorV,temp)[1];
			c2:=Filtered(coorV,g->g[1]<c1[1])[1];
			c3:=Difference(coorV,[c1,c2])[1];
			a:=2;
		    fi;
		    temp:=[c1,c2,c3];
		#Print(f," and ",a,"\n");
		## add an new edge to assurre this edges are colored black
		    for i in [[1,2],[2,3],[3,1]] do 
			t1:=temp[i[1]];
			t2:=temp[i[2]];
			t:=[t1,t2];
			vec1:=t2-t1;
			vec2:=Difference(temp,[t1,t2])[1]-t[a];
			## draw edges for geodesics
			a1:=t1+1/3*vec1;
	           	a2:=t1+2/3*vec1;
	           	b1:=t1+1/3*vec1+1/3*vec2;
	           	b2:=t1+2/3*vec1+1/3*vec2;

			e:=Length(Edges(S))+1;
                        AppendTo( output, __SIMPLICIAL_PrintRecordDrawSVGEdgeREC( printRecord, S,e,[round2(a1),round2(b1)], false));    
                        AppendTo( output, __SIMPLICIAL_PrintRecordDrawSVGEdgeREC( printRecord, S, e, [round2(a2),round2(b2)], false));    

		    od;
	        od;
                AppendTo(output,"\n </g>");
	    fi;
	elif IsBound(printRecord.AddGeodesic) and Set(printRecord.edgeLengths)<>[edgeLen] then
	    Print("Geodesics can only be drawn if the faces are equilateral triangles.\n\n");
	fi;

end;

###########################################################################

        # Make the file end with .svg
        if not EndsWith( fileName, ".svg" ) then
            fileName := Concatenation( fileName, ".svg" );
        fi;

        # Try to open the given file
        file := Filename( DirectoryCurrent(), fileName );
        output := OutputTextFile( file, false ); # override other files
        if output = fail then
            Error(Concatenation("File ", String(file), " can't be opened.") );
        fi;
        SetPrintFormattingStatus( output, false );

	 
        __SIMPLICIAL_PrintRecordInit(printRecord, surface);
        __SIMPLICIAL_PrintRecordInitializePolygons(printRecord, surface);

        # Start the actual method
        unplacedFaces := Faces(surface);
        strongComponents := [];
        drawIndex := 0;
        while Length(unplacedFaces) > 0 do
            # Find the starting face
            start := __SIMPLICIAL_PrintRecordStartingFace( printRecord, surface, unplacedFaces );
            Add( printRecord!.startingFaces, start );
            Add( printRecord.edgeDrawOrder,  [] );

            comp := [[start]];
            drawIndex := drawIndex + 1;
            drawIndices := [drawIndex];
            #drawIndex := 1;
            computedFace := __SIMPLICIAL_PrintRecordComputeFirstFace( printRecord, surface, start, drawIndex );
            __SIMPLICIAL_PrintRecordAddFace(printRecord, surface, computedFace[1], computedFace[2], start, drawIndex);
            unplacedFaces := Difference( unplacedFaces, [start] );
            printRecord.openEdges := Filtered( EdgesOfFaces(surface)[start], e -> Length( Intersection(unplacedFaces, FacesOfEdges(surface)[e]) ) > 0 );

            nextFct := [ ["__SIMPLICIAL_PrintRecordNextEdgeByDrawOrder", infinity], ["__SIMPLICIAL_PrintRecordNextEdge", infinity] ];
            checkFct := [ "__SIMPLICIAL_PrintRecordNoIntersection" ];
            repeatData := [];
            # This is an infinite loop to extend all edges - bounded from above by the number of edges
            for k in [1..NumberOfEdges(surface)] do
                if Length(printRecord!.openEdges) = 0 then
                    break;
                fi;
                # Find the next edge
                nextEdge := fail;
                firstEdge := fail; # Fallback if all edges fail some test
                rejected := [];
                nextFctIndex := 1;
                tries := 1;
                for i in [1..Length(printRecord!.openEdges)+Length(nextFct)] do
                    if nextFctIndex > Length(nextFct) then
                        break;
                    fi;
                    if tries > nextFct[nextFctIndex][2] then
                        nextFctIndex := nextFctIndex + 1;
                        tries := 1;
                        continue;
                    fi;
                    proposedEdge := ValueGlobal( nextFct[nextFctIndex][1] )(printRecord, rejected);
                    tries := tries + 1;
                    if proposedEdge = fail then #code duplication with lines above
                        nextFctIndex := nextFctIndex + 1;
                        tries := 1;
                        continue;
                    fi;
                    if firstEdge = fail then
                        firstEdge := proposedEdge;
                    fi;
                    # every edge is used at most once (if there could be ambiguity, the edge has more than 2 incident faces)
                    # for each edge we store
                    # 1) the adjacent face
                    # 2) the computed vertex data
                    # 3) the computed edge data
                    # 4) a list with the results of the checks
                    if IsBound( repeatData[proposedEdge] ) then
                        # Take data from storage
                        adFace := repeatData[proposedEdge][1];
                        vertexData := repeatData[proposedEdge][2];
                        edgeData := repeatData[proposedEdge][3];
                        testResults := repeatData[proposedEdge][4];
                    else
                        adFace := Intersection( FacesOfEdges(surface)[proposedEdge], unplacedFaces )[1];
                        vertexEdgeData := __SIMPLICIAL_PrintRecordComputeFace(printRecord, surface, adFace, proposedEdge, drawIndex);
                        vertexData := vertexEdgeData[1];
                        edgeData := vertexEdgeData[2];
                        testResults := [];
                    fi;

                    # do tests
                    # we rely on the fact that computed faces of a previous 
                    # drawing component will keep beeing false (otherwise
                    # the tried addition will produce an error).
                    success := true;
                    for j in [1..Length(checkFct)] do
                        if IsBound( testResults[j] ) then
                            # there was a test before
                            testResults[j] := ValueGlobal( checkFct[j] )(printRecord, surface, vertexData, edgeData, drawIndex, testResults[j]);
                        else
                            testResults[j] := ValueGlobal( checkFct[j] )(printRecord, surface, vertexData, edgeData, drawIndex, []);
                        fi;

                        if testResults[j][1] = false then
                            success := false;
                            break;
                        fi;
                    od;
                
                    # Store data since it is either needed to avoid recomputation or to continue
                    repeatData[proposedEdge] := [ adFace, vertexData, edgeData, testResults ];

                    if not success then
                        Add(rejected, proposedEdge);
                        proposedEdge := fail;
                        continue;
                    else
                        nextEdge := proposedEdge;
                        break;
                    fi;
                od;
                if proposedEdge = fail then
                    # take the first edge instead
                    proposedEdge := firstEdge;
                    drawIndex := drawIndex + 1;
                    Add(drawIndices, drawIndex);
                    Add( comp, [repeatData[proposedEdge][1]]  );
                    computedFace := __SIMPLICIAL_PrintRecordComputeFirstFace( printRecord, surface, repeatData[proposedEdge][1], drawIndex );
                    __SIMPLICIAL_PrintRecordAddFace(printRecord, surface, computedFace[1], computedFace[2], repeatData[proposedEdge][1], drawIndex);

                    Print("DrawSurfaceToSVG: Could not find intersection-free continuation. Draw face ", repeatData[proposedEdge][1], " via edge ", firstEdge, " instead.\n");
                else
                    __SIMPLICIAL_PrintRecordAddFace( printRecord, surface, repeatData[proposedEdge][2], repeatData[proposedEdge][3], repeatData[proposedEdge][1], drawIndex );
                    # We will be in this case until we can't continue any edge without failing some test.
                    # Therefore this case will always add in the component that was last modified
                    Add( comp[Length(comp)], repeatData[proposedEdge][1] );
                fi;

                # Add the new face and remove initial edge from openEdges
                unplacedFaces := Difference( unplacedFaces, [ repeatData[proposedEdge][1] ]);
                for e in EdgesOfFaces(surface)[repeatData[proposedEdge][1]] do
                    if Length( Intersection(unplacedFaces, FacesOfEdges(surface)[e]) ) = 0 then
                        printRecord.openEdges := Difference( printRecord.openEdges, [e] );
                    else
                        printRecord.openEdges := Union( printRecord.openEdges, [e] );
                    fi;
                od;

                # Modify the edge draw order
                lastOrder := printRecord.edgeDrawOrder[Length(printRecord.edgeDrawOrder)];
                Add(lastOrder, proposedEdge);
            od;
            Add( printRecord.drawComponents, comp );
            Add( printRecord.drawIndices, drawIndices );
        od;

        # Set the strongly connected components (if not already done)
        if not HasStronglyConnectedComponentsAttributeOfComplex( surface ) then
            SetStronglyConnectedComponentsAttributeOfComplex( surface, List( printRecord.drawComponents, c -> SubcomplexByFacesNC(surface, Union(c) ) ));
        fi;

        # Write this data into the file
        printRecord!.onlySVGpicture:=false;
        if not printRecord!.onlySVGpicture then
           
            AppendTo( output, __SIMPLICIAL_PrintRecordSVGHeader(printRecord) );

        fi;
        
        allVertexCoords := printRecord!.vertexCoordinates;
        for strongCompNumber in [1..Length(printRecord.drawComponents)] do
            strongComp := printRecord.drawComponents[strongCompNumber];
            for ind in [1..Length(strongComp)] do;
                drawComp := strongComp[ind];
                comp := SubcomplexByFacesNC(surface,drawComp);
                drawIndex := printRecord.drawIndices[strongCompNumber][ind];

                # Start the picture
                
                
                
		   
                
		   # Draw faces
		   AppendTo( output, "<!-- Draw the faces -->\n" );
		   #AppendTo(output,"\n<g\n     style=\"fill:yellow;\">");
		   AppendTo(output,"\n<g\n     style=\"fill:white;\">");
                
                for f in Faces(comp) do
                    vertexPositions := printRecord!.faceVertices[f][drawIndex];
		    temp:=[];#
		    for g in vertexPositions do#
		    temp[g[1]]:=g;
		    od;
                    AppendTo( output, __SIMPLICIAL_PrintRecordDrawFaceSVG(printRecord, surface, f, 
                        helperRound(List(temp, p -> allVertexCoords[p[1]][p[2]]))) );#

                od;
                AppendTo( output, "\n\n" );
	         AppendTo(output,"</g>\n");

                # Draw all edges
		
                AppendTo(output,"\n<g>\n");

                for e in Edges(comp) do
                    ends := printRecord!.edgeEndpoints[e];
		    i:=1;
                    for i in [1..Length(ends)] do
                        if ends[i][3] = drawIndex then
 				
                            AppendTo( output, __SIMPLICIAL_PrintRecordDrawSVGEdgeREC( printRecord, surface, e, helperRound(List( ends[i]{[1,2]}, p -> allVertexCoords[p[1]][p[2]])), true));
                        fi;
                    od;
                od;
                AppendTo(output,"\n </g>");

		# Add all cut edges
                AppendTo(output,"\n<g\n  style=\"stroke:black;stroke-width:2\" >");
		 
		i:=1;
		#List scoreFlaps saved the index of edge e that has a flap attached to it
		scoreFlaps:=[];
                for e in Edges(comp) do
                    ends := printRecord!.edgeEndpoints[e];
		    
		   			 i:=1;
		    		if Size(ends)=2 then
			
						i:=1;
	                	for i in [1..Size(ends)] do	
							#hier helper Flap und gucken wo man Laschen dran klebt				
							cur:=helperFlap(e);
							if cur <> [] then
							scoreFlaps[e]:=cur[2];
								if i=cur[2] then
									if Size(cur[1])=1 then
										Add(flapTriangles,Concatenation([cur[1][1]],List( ends[i]{[1,2]}, p ->allVertexCoords[p[1]][p[2]])));
									fi;
									AppendTo(output,__SIMPLICIAL_AddFlap( printRecord, surface, helperRound(List( ends[i]{[1,2]}, 			p -> allVertexCoords[p[1]][p[2]])), helperRound(cur[1])));
								else
									if ends[i][3] = drawIndex then	 					
				               			AppendTo( output, __SIMPLICIAL_PrintRecordDrawSVGEdge( printRecord,surface, e, helperRound(List( ends[i]{[1,2]}, p -> allVertexCoords[p[1]][p[2]])), false));
				                    fi;
								fi;
							fi;
	                	od; 	
		   			fi;
                od;
                AppendTo(output,"\n </g>");

		# Add all Scoring edges
                AppendTo(output,"\n<g\n     >");

                for e in Edges(comp) do
                    ends := printRecord!.edgeEndpoints[e];
		    if Size(ends)=1 then
			i:=1;
                    	for i in [1..Length(ends)] do
                        	if ends[i][3] = drawIndex then
 				
                            		AppendTo( output, __SIMPLICIAL_PrintRecordDrawSVGEdge( printRecord, surface, e, helperRound(List( ends[i]{[1,2]}, p -> allVertexCoords[p[1]][p[2]])), false));
                        	fi;
                    	od;
		    else #Flap scoring edge
	             	for i in [1..Length(ends)] do
                        	if ends[i][3] = drawIndex then
 								if IsBound(scoreFlaps[e]) then
                            		AppendTo( output, __SIMPLICIAL_PrintRecordDrawSVGEdge( printRecord, surface, e, helperRound(List( ends[scoreFlaps[e]]{[1,2]}, p -> allVertexCoords[p[1]][p[2]])), false));
                            	fi;
                        	fi;
                    	od;
		    fi;
                od;
                AppendTo(output,"\n </g>");
	
		

	##DrawFaceLabels
		if IsBound(printRecord.drawfaceLabels) then
			if printRecord.drawfaceLabels then
	    		AppendTo(output,"<g>"); 
	   		for f in Faces(surface) do
	        		vertexPositions := printRecord!.faceVertices[f][drawIndex];
	        		temp:=[];#
				for g in vertexPositions do#
					temp[g[1]]:=g;
	        		od;
	        		AppendTo( output, SIMPLICIAL_PrintRecordDrawFaceLabelSVG(printRecord, surface, f, 
	                        helperRound(List(temp, p -> allVertexCoords[p[1]][p[2]])),scale) );#
	    		od;
			AppendTo(output,"</g>");
			fi;
		fi;
### TODO vertex and face labels

###TODO rotation of the edglabels with givenAngels in printRecord
                
		# End the picture
	######################
		help_geodesic(surface,printRecord,output);



##########################
		
                AppendTo( output, "\n</svg>" );
            od;
        od;
	
	
	
        
        CloseStream(output);
        if not printRecord!.noOutput then
            Print( "Picture written in SVG." );
        fi;


        


        # Clean up the record
        __SIMPLICIAL_PrintRecordCleanup(printRecord);

        return printRecord;
    end
);
RedispatchOnCondition( DrawSurfaceToSVG, true, [IsPolygonalComplex,IsString,IsRecord], [IsNotEdgeRamified], 0  ); # test if prior Test with IsNotEdgeRamified is necessary

InstallOtherMethod( DrawSurfaceToSVG, 
    "for a polygonal complex without edge ramifications and a file name",
    [IsPolygonalComplex and IsNotEdgeRamified, IsString],
    function(surface, file)
        return DrawSurfaceToSVG(surface, file, rec());
    end
);
RedispatchOnCondition( DrawSurfaceToSVG, true, [IsPolygonalComplex,IsString], [IsNotEdgeRamified], 0  );


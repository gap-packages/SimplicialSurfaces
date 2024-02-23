s:=[ (1,2)(3,4), (1,2,3,4,5), (1,3,5) ];
x:=s[1]; y:=s[2]; z:=s[3];
faces:=[[y,y^2,y^3,y^4,y^5],[z,z^2,z^3]];  
#Add(faces,[z,z*y^-1,()]);   
 Add(faces,[y,y*z^-1,()]);  
#Add(faces,[y^-1,y^-1*x,()]);
#faces:=[ [ (1,2,3,4,5), (1,3,5,2,4), (1,4,2,5,3), (1,5,4,3,2), () ], 
  [ (1,3,5), (1,5,3), () ], [ (1,3,5), (1,2)(3,4), () ], 
  [ (1,2,3,4,5), (1,2)(3,4), () ], [ (1,2,3,4,5), (1,2)(3,4), () ] ];
orbs:=Set(List(orbs,f->Set(List(f,v->Position(Elements(AlternatingGroup(5)),v)))));
g:=Elements(AlternatingGroup(5));


new_faces:=List(faces,f->List(f,e->Position(g,e)));

#new_faces:=List(new_faces,f->f);
act:=function(l,pi) return List(l,e->Position(g,g[e]*pi)); end;
act:=function(l,pi) return List(l,e->e*pi); end;;

orbs:=Orbits(AlternatingGroup(5),faces,act);
all_faces:=Concatenation(orbs);
all_faces:=List(all_faces,f->List(f,e->Position(g,e))); 
all_faces:=Set(List(all_faces,f->CycleFromList(f)));
faces:=List(all_faces,face->ListFromCycle(face));
act:=function(l,pi) return List(l,e->Position(g,g[e]*pi)); end;
orbs:=Orbits(AlternatingGroup(5),new_faces,act);  



snub:=orbs[1];
rest:=Concatenation(orbs{[2,3,4]});
rest:=Set(List(rest,r->Set(r)));



snub:=last;

PolygonalComplexByVerticesInFaces(snub);

snub_dodecahedron:=last;

s:=[ (1,2)(3,4), (1,2,3,4,5), (1,3,5) ];
s:=[(1,5)(2,4),(1,2,4,3,5),(2,5,3)];
x:=s[1]; y:=s[2]; z:=s[3];
faces:=[[y,y^2,y^3,y^4,y^5],[z,z^2,z^3]];
Add(faces,[z,x,()]);
#Add(faces,[z^-1,z^-1*y^-1,()]);   
#Add(faces,[y,y*z^-1,()]);

act:=function(pnt,pi) return List(pnt,e->e*pi); end;
orbs:=Orbits(AlternatingGroup(5),faces,act); 
orbs:=Concatenation(last);
orbs:=Set(List(orbs,f->(List(f,v->Position(Elements(AlternatingGroup(5)),v)))));
orbs:=List(orbs,f->CycleFromList(f));  
orbs:=List(Set(orbs),f->ListFromCycle(f));
snub_dodecahedron:=PolygonalComplexByVerticesInFaces(orbs);  

#(1,2)(3,4)
m1:=[[-1./2,1/(2*phi),phi/2],[1./(2*phi),-phi/2,1./2],[phi/2,1./2,1./(2*phi)]];
# (1,3,5)
m3:=[[phi/2,-1./2,-1/(2*phi)],[-1./2,-1./(2*phi),-phi/2],[1./(2*phi),phi/2,-1./2]];
#(3,4,5)
#m2:=[[-1./2,1/(2*phi),phi/2],[-1./(2*phi),phi/2,-1./2],[-phi/2,-1./2,-1./(2*phi)]];
xi:=0.94315125924;
phi:=(1+Sqrt(5.))/2;
#(1,2,3,4,5)
m2:=[[-1/(2*phi),phi/2,-1./2],[phi/2,1./2,1./(2*phi)],[1./2,-1./(2*phi),-phi/2]];
p:=[phi^2-phi^2*xi,-phi^3+phi*xi+2*phi*xi^2,xi];
s:=[ (1,2)(3,4), (1,2,3,4,5), (1,3,5) ];
g:=GroupWithGenerators(s);
words:=List(Elements(AlternatingGroup(5)),elm->Factorization(g,elm));;

words:=List(words,w->String(w));
subs:=[];
for w in words do
  if w= "<identity ...>" then
    Add(subs,"[[1,0,0],[0,1,0],[0,0,1]]");
  else
    subs_w:="";
    for c in w do
      if c='x' then
        Add(subs_w,'m');
      else
        Add(subs_w,c);
      fi;
    od;
    Add(subs,subs_w);
  fi;
od;
subs:=List(subs,s->EvalString(s));
coordinates:=List(subs,s->p*s);

new_vof:=[];
new_coordinates:=StructuralCopy(coordinates);
for f in Faces(snub_dodecahedron) do
  vof:=VerticesOfFace(snub_dodecahedron,f);
  if Size(vof)=3 then
    Add(new_vof,vof);
  else
    nr:=Size(new_coordinates)+1;
    new_faces:=List(EdgesOfFace(snub_dodecahedron,f),e->[VerticesOfEdge(snub_dodecahedron,e)[1],VerticesOfEdge(snub_dodecahedron,e)[2],nr]);
    new_vof:=Concatenation(new_vof,new_faces);
    Add(new_coordinates,Sum(coordinates{vof})/Size(vof));
  fi;
od;
snub_dodecahedron_tri:=SimplicialSurfaceByVerticesInFaces(new_vof);
# two neighbouring verticse
dist:=MyNorm(coordinates[1]-coordinates[60]);
new_coordinates:=new_coordinates/dist;
data:=PrintableOuterHull(snub_dodecahedron_tri,new_coordinates,"Snub_Dodecahedron",eps,0.01,Group(()),true);
normals:=data[4];

for i in [61..72] do
  f:=FacesOfVertex(snub_dodecahedron_tri,i)[1];
  e:=EdgesOfVertex(snub_dodecahedron_tri,i)[1];
  voe:=VerticesOfEdge(snub_dodecahedron_tri,e);
  z:=new_coordinates[voe[1]];
  x:=new_coordinates[voe[2]];
  n:=normals[f];
  p:=Sum([1..3],j->n[j]*(x[j]-z[j]));
  q:=MyNorm(x-z)^2-1;
  t:=p+Sqrt(p^2-q);
  new_coordinates[i]:=new_coordinates[i]+t*n;
od;

for e in VerticesOfEdges(snub_dodecahedron_tri) do
  Print(MyNorm(new_coordinates[e[1]]-new_coordinates[e[2]]),"\n");
od;

edgeColours:=[];
red:=[];
blue:=[];
green:=[];
g:=Elements(AlternatingGroup(5));
s:=[(1,5)(2,4),(1,2,4,3,5),(2,5,3)];
for i in Vertices(snub_dodecahedron) do
  Add(red,Set([i,Position(g,s[2]*g[i])]));
  Add(red,Set([i,Position(g,s[2]^-1*g[i])]));
  Add(green,Set([i,Position(g,s[1]*g[i])]));
  Add(blue,Set([i,Position(g,s[3]*g[i])]));
  Add(blue,Set([i,Position(g,s[3]^-1*g[i])]));
od;
red:=Set(red);
blue:=Set(blue);
green:=Set(green);
for e in Edges(snub_dodecahedron_tri) do
  voe:=VerticesOfEdge(snub_dodecahedron_tri,e);
  if voe in red then
    edgeColours[e]:="red";
  elif voe in blue then
    edgeColours[e]:="blue";
  elif voe in green then
    edgeColours[e]:="green";
  else
    edgeColours[e]:="yellow";
  fi;
od;
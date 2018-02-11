#############################################################################
##
#W  simpliciallib.gi       GAP simplicial surface library  
##                                                         Markus Baumeister
##                                                         Alice Niemeyer
##                                                         Wilhelm Plesken
##                                                         Ansgar Strzelczyk
##
##
#Y  Copyright (C)  2017,  Lehrstuhl B für Mathematik, RWTH Aachen University 
##
##  This file contains the routines for the simplicial surfaces library
##



Unbind(SIMPLICIAL_SURFACES);
SIMPLICIAL_SURFACES := [];

BindGlobal("SIMPLICIALRANGE", [1..20]);
BindGlobal("SIMPLICIALLENGTHS", [
0,0,0,0,0,0,0,1,0,1,0,
2, 0,
4, 0,
10, 0,
25, 0,
86, 0 ]);

BindGlobal("SIMPLICIALINDX",
[1,1,1,1,1,1,1,8,9,10,11,12,13,14,15,16,17,18,19,20] );

SIMPLICIALLOAD := [];

#############################################################################
##
#V    SIMPLICIAL_SURFACES
##
##   1: NrVertices
##   2: NrEdges
##   3: NrFaces
##   4: IsVertexFaithful
##   5: Storage way: 1 VerticesInFaces, 2 EdgesInFaces and VerticesInEdges
##   6: Data for 5, e.g. VerticesInFaces
##   7: connected components list of faces
##   8: path connected components
##   9: generators of Automorphism group:
##      embedded into the direct product S(Vertices) x S(Edges) x S(Faces)ZZ
##

BIND_GLOBAL("SimplicialSurfaceLoad",function(NrFaces)
local s,fname,ind,new;
  if not IsBound(SIMPLICIAL_SURFACES[NrFaces]) then
    if not (NrFaces in SIMPLICIALRANGE and IsBound(SIMPLICIALINDX[NrFaces])) then
      Error("Simplicial surfaces with ",NrFaces," faces are not known!");
    fi;

    # are there too many groups stored?
    s:=Sum(Filtered(SIMPLICIAL_SURFACES,i->IsBound(i)),Length);
    if IsBound(SIMPLICIALLOAD[1]) then
      while s>200 do
        s:=s-SIMPLICIALLENGTHS[SIMPLICIALLOAD[1]];
        Unbind(SIMPLICIAL_SURFACES[SIMPLICIALLOAD[1]]);
        SIMPLICIALLOAD:=SIMPLICIALLOAD{[2..Length(SIMPLICIALLOAD)]};      od;
    fi;

    ind:=SIMPLICIALINDX[NrFaces];
    new:=Filtered([1..Length(SIMPLICIALINDX)],i->SIMPLICIALINDX[i]=ind);
    fname:=Concatenation("surf",String(ind));
    ReadGapRoot( Concatenation( "pkg/simplicial-surfaces/surfaces/", fname, ".g" ) );

    # store the NrFacesree
    SIMPLICIALLOAD:=Filtered(SIMPLICIALLOAD,i->not i in new);
    Append(SIMPLICIALLOAD,new);

  fi;
end);



BIND_GLOBAL("SIMPLICIALsurf",function(nrfaces,nr)
    SimplicialSurfaceLoad(nrfaces);
      if nr>SIMPLICIALLENGTHS[nrfaces] then
            Error("There are only ",SIMPLICIALLENGTHS[nrfaces],
            " surfaces with ",nrfaces," faces\n");
     fi;
     return SIMPLICIAL_SURFACES[nrfaces][nr];
end);

InstallGlobalFunction(NrSimplicialSurfaces, function(nrfaces)
      if not IsBound(SIMPLICIALLENGTHS[nrfaces]) then
              SimplicialSurfaceLoad(nrfaces);
      fi;
      return SIMPLICIALLENGTHS[nrfaces];
end);

##   1: NrVertices
##   2: NrEdges
##   3: NrFaces
##   4: IsVertexFaithful
##   5: Storage way: 1 VerticesInFaces, 2 EdgesInFaces and VerticesInEdges
##   6: Data for 5, e.g. VerticesInFaces
##   7: connected components list of faces
##   8: path connected components
##   9: generators of Automorphism group:
##      embedded into the direct product S(Vertices) x S(Edges) x S(Faces)
InstallGlobalFunction( SimplicialSurfaceLib, function(nrfaces,num)
local l,g,fac,mats,perms,v,t;
  l:=SIMPLICIALsurf(nrfaces,num);

  Error("check l");
  # special case: 
  if l[4] = true and l[5] = 1 then
      g := SimplicialSurfaceByVerticesInFaces(l[1],l[3],l[6]);
  else
      return fail;
  fi;
  
  # SetAutomorphismGroup(g,Group(l[7]));
  
  return g;
end );

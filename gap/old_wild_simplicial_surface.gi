#! @DoNotReadRestOfFile

##############################################################################
##
#W  wild_simplicial_surface.gi          Simplicial         Alice Niemeyer
#W                                                        Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Alice Niemeyer, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##
##  The functions in this file compute with wild coloured simplicial surfaces.
##
##  There are several ways of inputting a wild coloured simplicial surface.
##
##  A wild coloured simplicial surface is created by the function 
##  WildSimplicialSurface and is a GAP object. Simplicial surfaces can be 
##  obtained as follows:
##
##  1) Given a triple <gens> of involutions, the function
##     AllWildSimplicialSurfaces(gens)  computes  all wild coloured simplicial 
##     surfaces whose faces are the moved points of the generators and whose
##     edges are determined by the 2-cycles of the generators.
##  2) Input a surface by first listing the faces, 
##     then pairs of faces making up the edges, 
##     then the face-paths for  each vertex.  A face-path is simply
##     a list of the faces in the order in which they occur around a vertex.
##     The function WildSimplicialSurfacesFromFacePath takes this input
##     and returns all wild coloured simplicial surfaces matching the
##     description
##  3) Input a wild coloured surface by the following data structure, 
##     called the *generic-surface* data structure. The generic-surface
##     data structure is the most general data structure to describe
##     surfaces and is not restricted to wild coloured surfaces only.
##     The generic-surface data structure is a list of
##      the number of vertices, edges and faces
##      then pairs of vertices making up the edges, 
##      then triples of edges making up the faces, e.g.
##      ( |V|, |E|, |F|, [ [v1,v2],...],  [[e1,e2,e3],... ] )
##       here ei is a number, which is a position in the list of edges,
##       so that the list of vertex pairs can be indexed by ei to find
##       the two vertex numbers of edges ei.
##     
##
##
##    As GAP objects, certain general methods are installed for 
##    simplicial surface objects, such as Print and Display and "=".
##
##    The mr-type of a wild coloured simplicial surface <simpsurf>
##    can be determined with the function MrTypeOfWildSimplicialSurface.
##
##    As Simplicial surfaces are GAP objects, they cannot be 
##    accessed like records.
##
##    An action of a permutation on a simplicial surface is installed, 
##    allowing us to compute the orbits of a group acting on a set of
##    simplicial surfaces.
##    
##




#InstallMethod( \<, "for two simplicial surfaces", true, 
#  [ IsWildSimplicialSurfaceRep, IsWildSimplicialSurfaceRep ], 0,
#   LtWildSimplicialSurface );

#############################################################################
##
##  A Print method for simplicial surfaces
##

PrintWildSimplicialSurface := function(simpsurf)

        Print("WildSimplicialSurface( rec(\n");
        Print("generators := ");
        Print(simpsurf!.generators, ",\n");
        if IsBound( simpsurf!.mrtype) then
            Print("mrtype := ");
            Print(simpsurf!.mrtype, ",\n");
        fi;
        Print("faces := ");
        Print(simpsurf!.faces, ",\n");
        Print("edges := ");
        Print(simpsurf!.edges, ",\n");
        Print("vertices := ");
        Print(simpsurf!.vertices, "));\n");
end;

InstallMethod( PrintObj, "for WildSimplicialSurface", true, 
               [ IsWildSimplicialSurfaceRep ], 0, PrintWildSimplicialSurface );





# compute the double cover - extend old mr settings
DoubleCoverOfWildSimplicialSurface := function (simpsurf)

        local gens, newgens, i, j, mrtype, MapCycle, grp, N, mrtypenew;


        N := NrOfFacesOfWildSimplicialSurface(simpsurf);

# replace a mirror (i,j) by (i, -j)(-i, j) 
# and a rotation (i,j) by (i,j)(-i,-j).
# As GAP cannot permute negative numbers we represent
# -i by i+N
MapCycle := function (c, t)

    local i, j;

    if t = 0 then return One(c); fi;

    i := c[1]; j := c[2];
    if t = 1 then
        return (i, j+N) * (i+N, j );
    elif t = 2 then
        return (i,j)*(i+N, j+N);
    fi;

end;

        gens := GeneratorsOfWildSimplicialSurface(simpsurf);
        newgens := List( gens, i-> Cycles(i,
            [ 1 .. Length(FacesOfWildSimplicialSurface(simpsurf)) ] ));

        mrtype := MrTypeOfWildSimplicialSurface(simpsurf);
        mrtypenew := [];

        for i in [ 1 .. 3 ] do
            newgens[i] := List( newgens[i], c -> MapCycle( c, mrtype[i][c[1]] ));
            newgens[i] := Product( newgens[i] );
            mrtypenew[i] := [];
            for j in [ 1 .. N ] do
                mrtypenew[i][j] := mrtype[i][j];
                mrtypenew[i][j+N] := mrtype[i][j];
            od;
        od;

        return WildSimplicialSurface( newgens[1], newgens[2], newgens[3], mrtypenew );
       
end;



#############################################################################
##
#!  @Description
#!  This function takes as input a  wild-coloured simplicial surface
#!  <simpsurf> and returns the simplicial simplicial surface obtained
#!  from <simpsurf> by recursively removing all ears. An ear is a surface
#!  consisting of two faces that have two common incident edges.
#!  @Returns a simplicial surface without ears.
#!
InstallGlobalFunction( SnippOffEarsOfWildSimplicialSurface, function( simpsurf )

        local i, gens, edges, FindCommon, j, e, ne, vtx, ear, x, vtxnames,
              newvertices, newedges, newgens, newvtxnames, verynewvertices;

        gens := GeneratorsOfWildSimplicialSurface(simpsurf);
        newgens := ShallowCopy(gens);

        edges := EdgesOfWildSimplicialSurface(simpsurf);

        newedges := [List(edges[1],i->ShallowCopy(i)),
                    List(edges[2],i->ShallowCopy(i)),
                    List(edges[3],i->ShallowCopy(i))];
        newvertices := ShallowCopy(VerticesOfWildSimplicialSurface(simpsurf)); 

    FindCommon := function (edges)

        local ab, bc, ac;

        ab := Intersection( edges[1], edges[2] );
        bc := Intersection( edges[2], edges[3] );
        ac := Intersection( edges[1], edges[3] );

        if Length(ab) > 0 then return [ab[1], [1,2]]; fi;
        if Length(bc) > 0 then return [bc[1], [2,3]]; fi;
        if Length(ac) > 0 then return [ac[1], [1,3]]; fi;
          
        return false;
    end;

        ear :=  FindCommon(newedges);

        while ear <> false do
            # Found an ear that we now have to cut off
            RemoveSet(newedges[ear[2][1]], ear[1]);
            RemoveSet(newedges[ear[2][2]], ear[1]);
            j := Difference( [1,2,3], ear[2] ); j := j[1];
            # the edges of the other generator containing faces in ear
            e := Filtered(newedges[j],i->Length(Intersection(ear[1],i))<>0);
            ne := Flat(e); ne := Set(ShallowCopy(ne));
            RemoveSet(ne,ear[1][1]); RemoveSet(ne,ear[1][2]);
            for x in e do 
                RemoveSet(newedges[j], x);
            od;
            AddSet(newedges[j], ne);
            newgens := List( newedges, j-> Product(j,  i-> (i[1],i[2])));

            verynewvertices := [];
            # now we have to change the vertices to remove the ear
            for i in [ 1 .. Length(newvertices)] do
                # here are all the names a vertex is known by
                vtxnames := newvertices[i];
                # the new names for the given vertex
                newvtxnames := [];
                for j in [1..Length(vtxnames)] do
                    vtx := vtxnames[j];
                    if not vtx[1] in ear[1] then
                        # the vtx does not contain a face of the ear
                        # so we keep it
                        Add(newvtxnames,vtx);
                    fi;
                od;
                if Length(newvtxnames)>1 then
                    Add(verynewvertices,newvtxnames);
                fi;
            od;   
            newvertices := verynewvertices;

            ear :=  FindCommon(newedges);
        od;


        return WildSimplicialSurface( rec( generators := newgens,     
                    faces := MovedPoints(gens),
                    edges := newedges, 
                    # here we are careful to create a structural copy
                    # of the vertices
                    vertices := StructuralCopy(newvertices)));
end);
InstallMethod( SnippOffEars, "for a simplicial surfaces", true, 
	[ IsWildSimplicialSurfaceRep ], 0,
	SnippOffEarsOfWildSimplicialSurface);



#############################################################################
##
##
##  A face vertex path is a list of lists. Each sublist describes a face.
##  Let $f$ be such a sublist. Then the entries in $f$ are the numbers of
##  the vertices surrounding the face (whose name is the position number 
##  in the face vertex path) in order. If the 

##  We have to assume that if two faces share a pair of vertices, they
##  share an edge.
##
##
##     f1         f2       f3
## [v2,v3,v4] [v2,v3,v4] [v5,v4,v3]
## [v1,v2],  [e1,e2,e3]


## #############################################################################
## ##
## ##
## ## [v1,v2],  [e1,e2,e3]
## 
## 
## FaceVertexPathFromGenericSurface := function( surf )
## 
##         local fvp, f, fv, e;
## 
##         fvp := [];
##         
##             fv := Set([]);
##             for e in f do
##             od;
##             Add( fvp, fv );
##         od;
## 
##         return fvp;
## 
## end;



# find one face with edges e1 and e2
# note that there may be several faces with edges e1 and e2,
# e.g. the Janus Head.
FaceWithEdges := function(surf, e1, e2 )
            local i;

            for i in [ 1 .. Length(surf[5]) ] do
                if Length(Intersection( surf[5][i], [e1,e2]))=2 then
                    # we found a face with the edges e1 and e2
                    return i;
                fi;
            od;
            return false;
end;

AllFacesWithEdges := function(surf, e1, e2 )
        local i;

        return Filtered( surf[5], f-> Length(Intersection(f,[e1,e2]))=2);

end;


# Find the numbers of all faces incident to e
# here e is an edge number
Faces := function(surf, e)
            local i, f;

            f := [];
            for i in [ 1 .. Length(surf[5]) ] do
                    if e in  surf[5][i] then
                        # we found a face incident to e
                        Add(f, i);
                    fi;
            od;
            return f;
end;


# find the face incident to v on the other side of 
# edge e from face f1 and return this face and the next
# edge incident to v
NextFaceEdge := function(surf, e1,f1,incident)

                local f2, fa, e;

                f2 := Faces(surf, e1); # numbers of faces incident to e1
                if Length(f2) = 0 then return false; fi;

                # if there is only one face f1 incident to e then
                # e is a boundary edge, so return 0
                if Length(f2) = 1 then return 0; fi;

                # find face on the other side of edge e1
                RemoveSet(f2, f1);
                fa := surf[5][f2[1]]; # e.g. [e1, e2, e4]

                # now find the edges incident to face fa
                e := Set(ShallowCopy( fa )); # e.g. [e1, e3, e6]
                RemoveSet(e,e1);  # e.g. [e5,e6]
                # check which are incident to vertex v
                e := Intersection( e, incident);
                if Length(e) <> 1 then Error("found no edge"); fi;
                
                return [f2[1],e[1]];
end;


# find the neighbouring face along the edge e
NeighbouringFace := function( surf, f, e )

         local neigh;

         neigh := Faces(surf, e); # face numbers of neighbouring faces
         neigh := Difference(neigh, [f] );
         if Length(neigh)=0 then
             return f; # e is a boundary edge
         else
             return neigh[1]; # the face on the other side of e
         fi;
end;


#############################################################################
##
#!  @Description
#!  This function takes as input a ``generic"- description of a surface. 
#!  A ``generic"-description of a surface is the most general description 
#!  of a simplicial surface. Also surfaces which do not support a 
#!  wild-colouring can be described by a ``generic"-description. 
#!  The ``generic"-description of a surface is as follows:
#!  [ |V|, |E|, |F|, [ [v1,v2],...],  [[e1,e2,e3],... ] ], where
#!  * |V| denotes the  number of vertices, 
#!  * |E| denotes the number of edges and 
#!  * |F| denotes the number of faces,
#!  * [ [v1,v2], .. ] is a list of  pairs of vertices making up the edges, 
#!        here v1, v2, etc are numbers of the vertices in [1 .. |V|]
#!  * [[e1,e2,e3], .. ] is a list of triples of edges making up the faces
#!        e1, e2, e3 are all numbers in [1..|V|] and the number e represents
#!        the edge [va, vb] stored in the list of vertices in position e.
#!
#!  @BeginExample the tetrahedron has a  ``generic"-description:
#!   tetra := [ 4, 6, 4, [[1,3], [2,3], [1,2], [2,4], [1,4], [3,4] ],
#!        [  [ 1, 2, 3], [2, 4, 6], [ 3, 4, 5], [1, 5, 6] ] ];
#!        where the triple [1,2,3] encodes the following three edges
#!        [1,3], [2,3], and [1,2] according to their positions
#!              in the list of edges
#!  @EndExample
#!
#!  @Returns If the surface described by the ``generic" description supports
#!  a  wild colouring, then the wild coloured simplicial surfaces description
#!  is returned. Otherwise the function returns fail.
#!  @Arguments a list of lists, representing a ``generic"-description of a surface
## TODO: Clean up local variables here!
##
## TODO: FaceWithEdges wrong call?
InstallGlobalFunction( WildSimplicialSurfacesFromGenericSurface, function(surface)

        local simpsurf, pair, x, y, edges, faces, vertices, e, f1, f2, e1, e2, boundary1,
              fa, i, j, v, f, vtx, facepairs, incident, gens, allsurf, newvertices, surf;

		surf := [ NrOfVertices(surface), NrOfEdges(surface), NrOfFaces(surface),
				EdgesOfGenericSimplicialSurface(surface),
				FacesOfGenericSimplicialSurface(surface)];


        # find one face with edges e1 and e2
        # note that there may be several faces with edges e1 and e2,
        # e.g. the Janus Head.
        FaceWithEdges := function( e1, e2 )
                local i;

                for i in [ 1 .. Length(surf[5]) ] do
                    if Length(Intersection( surf[5][i], [e1,e2]))=2 then
                        # we found a face with the edges e1 and e2
                        return i;
                    fi;
                od;
                return false;
        end;

        # Find the numbers of all faces incident to e
        # here e is an edge number
        Faces := function(e)
                local i, f;

                f := [];
                for i in [ 1 .. Length(surf[5]) ] do
                    if e in  surf[5][i] then
                        # we found a face incident to e
                        Add(f, i);
                    fi;
                od;
                return f;
        end;


        # find the face incident to v on the other side of 
        # edge e from face f1 and return this face and the next
        # edge incident to v
        NextFaceEdge := function(e1,f1,incident)

                local f2, fa, e;

                f2 := Faces(e1); # numbers of the faces incident to e1
                if Length(f2) = 0 then return false; fi;

                # if there is only one face f1 incident to e then
                # e is a boundary edge, so return 0
                if Length(f2) = 1 then return 0; fi;

                # find face on the other side of edge e1
                RemoveSet(f2, f1);
                fa := surf[5][f2[1]]; # e.g. [e1, e2, e4]

                # now find the edges incident to face fa
                e := Set(ShallowCopy( fa )); # e.g. [e1, e3, e6]
                RemoveSet(e,e1);  # e.g. [e5,e6]
                # check which are incident to vertex v
                e := Intersection( e, incident);
                if Length(e) <> 1 then Error("found no edge"); fi;
                
                return [f2[1],e[1]];
        end;


        faces := [1..surf[3]];
        simpsurf := rec( generators := [],
                          faces := faces );
        edges := [];

        # The list <edges> is a list of pairs of adjacent faces.
        # Take pairs of faces of the surface and see if they share an edge.
        # If they do, we add the pair of faces to the list edges.

        for i in [ 1 .. Length(faces) ] do
            for j in [i+1 .. Length(faces) ] do
                f1 := surf[5][i];
                f2 := surf[5][j];
                x := Intersection(f1,f2);
                for y in x do
                    edges[y] := [i,j];
                od;
            od;
        od;

        simpsurf.edges := edges;

        # for each vertex we now create a vertex defining face path
        # this is always possible, even if the surface does not support
        # a wild colouring
        vertices := [];
        for v in [ 1 .. surf[1] ] do
            # find all edges incident to v
            incident := Filtered( surf[4], i -> v in i );
            incident := List( incident, i-> Position(surf[4],i));
            # e.g. incident to v=1 are edges [[1,2],[1,3],[1,4]]
            # incident now contains their position numbers in edges
            # now we have to arrange all the faces in the right
            # order around the vertex v, so vtx will become
            # the vertex defining path for v
            vtx := [];
            if Length(incident) = 0 then
                Error("vertex not incident to any edge");
                return;
            elif Length(incident) = 1  then
                Error("vertex only incident to a single edge");
                return;
            elif Length(incident) = 2  then
                Info(InfoSimplicial, "vertex  incident to a flap");
                Add(vtx, [FaceWithEdges(edges[incident[1]], 
                                        edges[incident[2]])]);
            else
                # now incident contains at least 3 edges. 
                # Take the first edge adjacent to two faces, which must
                # exist, as the length of incident is at least 2:
                e1 := incident[1];
                f := Faces(e1);
                
                # e1 := First( incident, i-> Length(Faces(edges[i]))>1 );
                # f1 := Faces(edges[e1]); # these are now 2 faces
                # here is a face incident to these edges and
                # we start with this face (there may be more...)
                # f := FaceWithEdges( e1, e2 );
                # e.g. [ [1,2,3], 
                if Length(f)=0  then 
                    Error("something is wrong - edges not incidet to face"); 
                    return;
                fi;
                f := f[1];
                # we add the first face to the vertex vtx
                Add(vtx,f);
                # find all faces that have edge e1
                f2 := NextFaceEdge(e1,f,incident);
#                f2 := NextFaceEdge(surf,e1,f,incident);
                boundary1 := false;
                while f2 <> false do
                    if f2 = 0 then
                        # we found a boundary edge
                        if boundary1 then
                            f2 := true; # this is a second boundary - done
                            break;
                        else
                           boundary1 := true;
                           vtx := Reversed(vtx);
                           f2 := vtx[Length(vtx)];
                            #ADD todo e1;
                         fi;
                     else
                         # add the next incident face
                         Add(vtx, f2[1]); # add first face twice if closed
                         if f2[1] = vtx[1] then
                             break; # we are done
                         fi;
                      fi;
                      f2 := NextFaceEdge(f2[2],f2[1],incident);
                      f2 := NextFaceEdge(surf,f2[2],f2[1],incident);	#ERROR: Call with four arguments, but function only wants three
                  od;
                  Add( vertices, vtx);                                  
            fi;
        od;

        allsurf := [];

        # now we see which generating triples we can create from the edges of
        # the surface and see whether any of these can be a wild colouring
        # for the given edges. If the generic surface does not support a 
        # wild colouring, then TestGens will return an empty list.
        for gens in GeneratorsFromEdgesOfWildSimplicialSurface(simpsurf.edges) do
            edges :=  List( gens, g-> Cycles(g,MovedPoints(gens)));
            edges  := List( edges, e->Filtered( e , c -> Length(c) = 2));
            newvertices := TestGens( gens, vertices );
            for vtx in newvertices do
                simpsurf := rec( generators := gens,
                             faces := faces,
                             edges := edges,
                             vertices := vtx );
                Add( allsurf, WildSimplicialSurface(simpsurf) );
            od;   
        od;        

        return allsurf;
            
end);

#############################################################################
##
#!   @Description
#!   The function SixFoldCover takes as input a generic description of
#!   a simplicial surface.  The six fold cover of a simplicial surface is
#!   the following surface.
#!   If f is a face of the original face with edge numbers e_a, e_b and
#!   e_c, then the face is covered by the six faces of the form
#!   (f, e1, e2, e3), for which {e1, e2, e3}  = {e_a, e_b, e_c}.
#!   See Proposition 3.XX in the paper.
#!   @Arguments
#!
#!   If the optional argument mrtype is given, it has to be a list of length 
#!   3 and each entry has to be  $1$, or $2$. In this case the six fold cover 
#!   will treat the position $i$ for $i\in\{1,2,3\}$ of the three
#!   edges around a faces either as a   reflection (mirror), if the entry 
#!   in position $i$ of mrtype is 1, or as a rotation, if the entry in 
#!   position $i$ is 2. That is, the cover surface is generated by three
#!   transpositions $\sigma_i$ for $i=1,2,3$. For $i=1$, suppose $f$ and 
#!   $f'$ are faces of the surface surf such that the edges of $f$ are 
#!   $e_1, e_2$  and $e_3$ and the edges of $f'$ are  $e_1, e_a, e_b$ are 
#!   the edges $e_1, e_2$ and $e_a$ intersect in a common vertex and 
#!   the edges $e_1, e_3$ and $e_b$ intersect in a common vertex.
#!   For $i=1$ and  mrtype of position $1$ being  mirror (i.e. $1$), then 
#!   $$\sigma_1(f,e_1,e_2,e_3) = (f', e_1, e_a, e_b),$$ whereas if the 
#!   mrtype of position $1$ is a reflection (i.e. $2$), then 
#!   $$\sigma_1(f,e_1,e_2,e_3) = (f', e_1, e_b, e_a).$$ The definition
#!   of $\sigma_2$ and $\sigma_3$ are analogous, with $e_2$, respectively
#!   $e_3$ taking the role of the common edge $e_1.$
#!
#!   
#!   If the optional argument mredges is given, and mredges is a list of 
#!   length equal to the number of edges of the surface **surf** and an
#!   entry for an edge e is either 1 or 2. If the entry is 1 then 
#!   the six fold cover will treat the edge as a reflection (mirror) and 
#!   if the entry is 2  then the edge is treated as a rotation. 
#!
#!   The six fold cover is always a wild colourable simplicial surface.
#!   @Returns a wild coloured simplicial surface
#!   @Arguments surface, mrtype, bool
#!   if bool is true or not given, the mrtype specifies the behaviour of 
#!   the $\sigma_i$, if bool is false, the mrtype specifies the behaviour
#!   of the edges.
#!
InstallGlobalFunction( SixFoldCover, function( arg )

      local cover, faces, edges, vertices, gens, g, i, e, h, s, orbs, j, surf,
                   cfaces, cvertices, cedges, cgens, cg, cf, img, vtx, Faces,
                   neigh, e1, e2, p1, p2, poss, mrtype, Vertex, IsIncident,
                   f1, f2, sigi, cmrtype, mr, sigtype, GetMr, IsMirror;


      Vertex := function(e)
          return Set(surf[4][e]);
      end;

      IsIncident := function(e1, e2, e3)

          local inter;

          inter := Intersection(Vertex(e1), Vertex(e2));
          if Size(Intersection( inter, Vertex(e3) ) ) > 0 then
              return true;
          fi;
          return false;
      end;

      # Find the numbers of all faces incident to e
      # here e is an edge number
      Faces := function(e)
                local i, f;

                f := [];
                for i in [ 1 .. Length(surf[5]) ] do
                    if e in  surf[5][i] then
                        # we found a face incident to e
                        Add(f, i);
                    fi;
                od;
                return f;
        end;


        if Length(arg) < 1 or Length(arg) > 3 then 
            Error("SixFoldCover( <surf>[, <mrtype>, <bool>] )");
            return;
        fi;

        surf := [ NrOfVertices(arg[1]), NrOfEdges(arg[1]), NrOfFaces(arg[1]),
			EdgesOfGenericSimplicialSurface(arg[1]),
			FacesOfGenericSimplicialSurface(arg[1]) ];
        faces := surf[5];
        edges := surf[4];
        vertices := [1..surf[1]];

        if Length(arg) = 2 then
            mrtype := arg[2]; sigtype := true; 
            # the mrtype specifies the sigma_i
            if Length(mrtype) > 3 then 
                Error("SixFoldCover( <surf>[, <mrtype>, <bool>] )");
                return;
            fi;
        elif  Length(arg) = 1 then
            sigtype := true; # the mrtype specifies 
            mrtype := List( [1,2,3], i-> 1 ); 
            # the default is to reflect at every position
        else #length of arg is 3
            mrtype := arg[2]; sigtype := arg[3];
        fi;


        IsMirror := function(k, i)
                  if sigtype = false then
                      if  mrtype[k] <= 1 then
                          return true;
                      else return false;
                      fi;
                   fi;
                   if mrtype[i] = 1 then return true; 
                   else return false; 
                   fi;

        end;

      # first we compute the faces of the cover
      cfaces := Cartesian( [1..surf[3]], Arrangements( [1,2,3], 3 ) );
      cfaces := List( cfaces, f -> [f[1], faces[f[1]][f[2][1]], 
                                          faces[f[1]][f[2][2]], 
                                          faces[f[1]][f[2][3]] ]);

      # record the mrtype of the cover
      cmrtype := List( [1..3], j->List( cfaces, i-> 0 ));

      # new we have to compute the edges
      # we enforce that generator g maps  (f,(e_a, e_b, e_c)) to
      # itself, if f is a fixed point of g and to 
      # (f^g, e_x, e_y, e_z), where the edge of the same colour as g
      # is fixed and the remaining two are interchanged - so that

      cgens := [];
      for i in [1..3]  do
          sigi := []; # define generator g
          for j  in [1..Length(cfaces)] do
              cf := cfaces[j]; # work out the image of cf under sigi
              # e.g. cf = [1, 2, 3, 4] means face 1, edge numbers 2,3,4
              # if i=2 then we have to map along edge number 3
              # need to find the neighbour of cf along edge i
              # cf[1+i] is the edge number along which to map
              # add +1, since the first entry in cf is a face
              neigh := Faces(cf[i+1]); # the face numbers of 
                                       #the neighbouring faces
              if not cf[1] in neigh then
                  Error("cannot find neighbour of face ", cf, "\n");
              fi;
              neigh := Difference(neigh, [cf[1]] );
              if Length(neigh)=0 then
                  img := ShallowCopy(cf); # boundary edge
              else
                  neigh := neigh[1]; # the face number of the neighbour
                  img := [neigh];
                  e := surf[5][neigh]; # the edges of neigh
                  img[i+1] := cf[i+1]; # this edge remains fixed
                  # match up the other two edges
                  poss := Difference([1,2,3], [Position(e,cf[i+1])]); 
                  if Length(poss) <> 2 then Error("no matching edges"); fi;
                  # the other two possibilities for positions in e
                  # thus e[poss] are the two edges other than the edge
                  # along which we map
                  p1 := poss[1]; p2 := poss[2];
                  # cf[i+1] is an edge of face cf
                  # check whether it shares a vertex with the
                  # edge e[p1]. The vertices of both are intersected
                  e1 := e[p1]; e2 := e[p2]; # the other edges of neigh
                  poss := Difference([1,2,3], [i]); 
                  p1 := poss[1]; p2 := poss[2];
                  f1 := cfaces[j][p1+1]; 
                  f2 := cfaces[j][p2+1]; # other edges of cf

                  if sigtype = false then
			  if IsIncident(e1, f1, cf[i+1]) and mrtype[cf[i+1]] <= 1  or
			     IsIncident(e1, f2, cf[i+1]) and  mrtype[cf[i+1]] =2 then
				  img[p1+1] := e1;
				  img[p2+1] := e2;
			  else
				  img[p1+1] := e2;
				  img[p2+1] := e1;
			   fi;
			  sigi[j] := Position( cfaces, img );
			  cmrtype[i][j] := mrtype[cf[i+1]];
			  if cmrtype[i][j] = 0 then cmrtype[i][j] := 1; fi;
			  #Print( cfaces[j], "-", i, "->", img, "\n");
                  else  # we map according to positions
			  if IsIncident(e1, f1, cf[i+1]) and mrtype[i] <= 1  or
			     IsIncident(e1, f2, cf[i+1]) and  mrtype[i]=2 then
				  img[p1+1] := e1;
				  img[p2+1] := e2;
			  else
				  img[p1+1] := e2;
				  img[p2+1] := e1;
			   fi;
                      sigi[j] := Position( cfaces, img );
                      cmrtype[i][j] := mrtype[i];
                      if cmrtype[i][j] = 0 then cmrtype[i][j] := 1; fi;
                      #Print( cfaces[j], "-", i, "->", img, "\n");
                  fi;
                fi;
        
#                    if IsIncident(e1, f1) and  mrtype[cf[i+1]] <= 1 or
#                       IsIncident(e1, f2) and  mrtype[cf[i+1]] = 2 then
#                        img[p1+1] := e1;
#                        img[p2+1] := e2;
#                    else
#                        img[p1+1] := e2;
#                        img[p2+1] := e1;
#                    fi;
              
          od;

          for i in [ 1 .. Length(sigi) ] do
              if not IsBound(sigi[i]) then
                  sigi[i] := i;
              fi;
          od;

          if PermList(sigi) = fail then 
              Info( InfoSimplicial, 1, "Surface does not exist");
              Error("a");
              return false;
          fi;
          Add( cgens, PermList(sigi) );
      od;
  

      return AllWildSimplicialSurfaces( cgens, cmrtype );

end);

GenericSurfaceCommonCover := function(cov)

        local surf, i, j, edges, faces, vertices;

        surf := [];

        surf[1] := Length(cov.vertices);
        surf[2] := Length(cov.edges);
        surf[3] := Length(cov.faces);
        
        surf[4] := [];
        surf[5] := List( cov.faces, i-> [] );
        for i in [ 1.. Length(cov.faces) ] do
            for j in [ 1.. Length(cov.edges) ] do
                if i^cov.edges[j] <> i then
                    Add( surf[5][i], j );
                fi;
            od;
        od;

	return surf;

end;


#############################################################################
##
##
##  map the simplicial surface under the permutation pi which has
##  to  lie in the centraliser of the generators of ss inside the
##  full symmetric group.
##  This now allows us to act with a group on a simplicial surface and
##  call the orbit function
ImageWildSimplicialSurface := function (ss, pi )
 
        local nss, i, j, vtx, v, nv, vert, cmpvertices;

cmpvertices := function (v1, v2 )

    if Length(v1) < Length(v2 ) then return true;
    elif Length(v1) > Length(v2) then return false;
    fi;
    # now they have the same length
    return v1 < v2;

end;


        nss := rec();

        nss.generators := List(GeneratorsOfWildSimplicialSurface(ss), g->g^pi);
        nss.faces := List(FacesOfWildSimplicialSurface(ss),g->g^pi);
        Sort(nss.faces);
        nss.edges := [Cycles(nss.generators[1],nss.faces),
                      Cycles(nss.generators[2],nss.faces),
                      Cycles(nss.generators[3],nss.faces)];

        nss.vertices := [];
        vert := VerticesOfWildSimplicialSurface(ss);
        for i in [1..Length(vert)] do
            v := vert[i];
            nss.vertices[i] := [];
            for j in [ 1 .. Length(v)] do
                vtx := v[j];
                nss.vertices[i][j] := [vtx[1]^pi, vtx[2], vtx[3]];
            od;
            j := Position(nss.vertices[i], Minimum(nss.vertices[i]));
            nv := nss.vertices[i]{[j..Length(nss.vertices[i])]};
            Append(nv, nss.vertices[i]{[1..j-1]});
            nss.vertices[i] := nv;
        od;

        Sort( nss!.vertices, cmpvertices);
        nss := WildSimplicialSurface(nss);

        DegreesOfWildSimplicialSurface(nss);
        MrTypeOfWildSimplicialSurface(nss);
           

        return nss;

end;

#############################################################################
##
##   Code for generic surfaces
##
##

##
##  return all edges that are incident to the given vertex v
##  in the generic simplicial surface surf
##

EdgeNrIncidentVertex := function(surf, v)

        local edges;
        edges := Filtered( surf[4], i-> v in i );
        return List(edges,i->Position(surf[4],i));

end;


##
##  return all edges that are incident to the given vertex v
##  in the generic simplicial surface surf
##

FaceNrIncidentVertex := function(surf, v)
        local edges, faces, e, f;
        
        faces := Set([]);
        edges := EdgeNrIncidentVertex(surf, v);
        for e in edges do
            for f in surf[5] do
                if e in f then
                    AddSet(faces, f);
                fi;
            od;
        od;

        return List(faces, i-> Position(surf[5],i));

end;

IsBoundaryEdge := function(surf,e)

       return Length(Filtered(surf[5],i->e in i)) = 1;

end;



#
# The following function finds all vertex defining paths
# around the vertex vtx when moving next with g around the vertex.
# For example, one such class could be [ (1,a,b), (4,a,c), (6,b,c) ]
# in particular this means that the vertices in one class yield a word
# either fixing all faces on the path or from a face with a boundary
# to another face with a boundary.
# In the given example acb is a word such that
# 1acb = 1 or, more specifically, 1a = 4, 4c=6, 6b = 1.
#

VertexDefiningPathsGenericSurface := function(surf)

        local  vertices, v, vtx, incident, e1, f, f2, boundary1, edges, i;
                   
        edges := surf[4];
        # for each vertex we now create a vertex defining face path
        vertices := [];
        for v in [ 1 .. surf[1] ] do
            # find all edges incident to v
            incident := []; 
            for i in [ 1 .. Length(surf[4]) ] do
                if v in surf[4][i] then
                    Add(incident,i);
                fi;
            od;
#            incident := List( incident, i-> Position(surf[4],i)); WRONG
            # e.g. incident to v=1 are edges [[1,2],[1,3],[1,4]]
            # incident now contains their position numbers in edges
            # now we have to arrange all the faces in the right
            # order around the vertex v, so vtx will become
            # the vertex defining path for v
            vtx := [];
            if Length(incident) = 0 then
                Error("vertex not incident to any edge");
                return;
            elif Length(incident) = 1  then
                Error("vertex only incident to a single edge");
                return;
            elif Length(incident) = 2  then
#                Info(InfoSimplicial, "vertex  incident to a flap");

                f := AllFacesWithEdges(surf,incident[1], incident[2]);
                f := List(f, i-> Position(surf[5],i));
                if Length(f) = 1 then
                    Add(vtx,[ [f[1],incident[1]], [f[1], incident[2]]] );
                elif Length(f) = 2 then
                    Add(vtx,[ [f[1],incident[1]], [f[2], incident[2]],
                              [f[1],incident[1]] ] );
                fi;
            else
                # now incident contains at least 3 edges. 
                # Take the first edge adjacent to two faces, which must
                # exist, as the length of incident is at least 2:
                e1 := incident[1];
                f := Faces(surf,e1);
                
                # e1 := First( incident, i-> Length(Faces(edges[i]))>1 );
                # f1 := Faces(edges[e1]); # these are now 2 faces
                # here is a face incident to these edges and
                # we start with this face (there may be more...)
                # f := FaceWithEdges(surf, e1, e2 );
                # e.g. [ [1,2,3], 
                if Length(f)=0  then 
                    Error("something is wrong - edges not incidet to face"); 
                    return;
                fi;
                f := f[1];
                # we add the first face to the vertex vtx
                Add(vtx,[f,e1]);
                # find all faces that have edge e1
                f2 := NextFaceEdge(surf, e1,f,incident);
                boundary1 := false;
                while f2 <> false do
                    if f2 = 0 then
                        # we found a boundary edge
                        if boundary1 then
                            f2 := true; # this is a second boundary - done
                            break;
                        else
                           boundary1 := true;
                           vtx := Reversed(vtx);
                           f2 := vtx[Length(vtx)];
                            #ADD todo e1;
                         fi;
                     else
                         # add the next incident face
                         Add(vtx, [f2[1],f2[2]]); # add first face twice if closed
                         if f2[1] = vtx[1][1] then #ACN
                             break; # we are done
                         fi;
                      fi;
                      f2 := NextFaceEdge(surf,f2[2],f2[1],incident);
                  od;
            fi;
            Add( vertices, vtx);                                  
        od;
        return vertices;
end;



# InstallMethod( \^, "for a simplicial surface and a permutation", true, 
#  [ IsWildSimplicialSurfaceRep, IsPerm ], 0, ImageWildSimplicialSurface);

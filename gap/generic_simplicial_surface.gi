##############################################################################
##
#W  generic_surface.gi      Generic Simplicial Surface       Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##
##  The functions in this file compute with generic simplicial surfaces.
##
##

DeclareInfoClass( "InfoSimplicial" );
SetInfoLevel(InfoSimplicial,1);



DeclareRepresentation("IsGenericSimplicialSurfaceRep", IsComponentObjectRep,
#     IsPositionalObjectRep and IsDenseList, 
     ["faces","edges","vertices", "generators"]);

# From now on, we can do "Objectify( SimplicialSurfaceType, re )" 
# for any list re
SimplicialSurfaceType := 
    NewType( SimplicialSurfaceFamily, IsSimplicialSurfaceRep );

##
##  The constructor SimplicialSurface ensures that the simplicial surface
##  is  stored inside a GAP object. 
##
InstallGlobalFunction( SimplicialSurface,  function( simpsurf ) 
    
    return Objectify( SimplicialSurfaceType, simpsurf );

end );

##
## Print the vertex labels around a given edge
##
_SIMPLICIAL_PrintVertexLabels := function( gens, vtxnames )

        local i,j,f, h, PrintGen;

        PrintGen := function(gens,g)

            if   g = 1 then Print("a"); 
            elif g = 2 then Print("b"); 
            else Print("c"); fi;
            
        end;


        j := vtxnames[1][1];

        if Length(vtxnames)=2 and 
           j^gens[vtxnames[1][2]] = vtxnames[2][1] and
           j^gens[vtxnames[1][3]] = vtxnames[2][1] and
           vtxnames[1][2] = vtxnames[2][2] and
           vtxnames[1][3] = vtxnames[2][3]   then
           Print(j); 
           PrintGen(gens,vtxnames[1][2]);
           Print(j^gens[vtxnames[1][2]]); 
           PrintGen(gens,vtxnames[1][3]);
           Print(j);  Print(" # ear\n");
           return;
        fi;

        if j^gens[vtxnames[1][2]] = j or 
           j^gens[vtxnames[1][3]] = j then 
           Print("|");
           if Length(vtxnames) = 1 then
               # we have a flap
               PrintGen(gens,vtxnames[1][2]);
               Print(j);
               PrintGen(gens,vtxnames[1][3]);
               Print("|  # flap\n");
               return;          
            fi;
        fi;
        for i in [ 1 .. Length(vtxnames)-1 ] do
            j := vtxnames[i][1];
            f := Filtered(vtxnames[i]{[2,3]},g-> (j^gens[g]=vtxnames[i+1][1]));
            if i = 1  then
                h := Difference(vtxnames[i]{[2,3]},f);
                if Length(h) > 0 then 
                    PrintGen(gens,h[1]);
                fi;
            fi;
            Print(j);
    #        if Length(f) > 1 then Error("ear"); return; fi;
            if Length(f) <> 0 then
                PrintGen(gens, f[1] );
            fi;
        od;
        i := Length(vtxnames);
        j := vtxnames[i][1];
        Print(j);
        if i = 1 then Print("\n"); return; fi;
        h := Difference(vtxnames[i]{[2,3]},f);
        if Length(h) > 0 and j^gens[h[1]] = j then
             PrintGen(gens,h[1]);
             Print("|  # transversing reduced path \n");
             return;
        fi;
        f := Filtered(vtxnames[i]{[2,3]},g-> (j^gens[g]=vtxnames[1][1]));
#        if Length(f) > 1 then Error("incorrect names"); return; fi;
        if Length(f) <> 0 then
            PrintGen(gens, f[1] );
            Print(j^gens[f[1]]);
        fi;
        Print(" # closed reduced path \n");
 
end;

##
## obtain the vertex relation around a given edge
##
InstallGlobalFunction( VertexRelationOfEdge, function( gens, vtxnames, fgrp )

        local i,j,f, h, r, fgens;


        fgens := GeneratorsOfGroup(fgrp);
        r := One(fgrp);

        j := vtxnames[1][1];
        if j^gens[vtxnames[1][2]] = j or 
           j^gens[vtxnames[1][3]] = j then 
           # This is not a closed path
           Print("not a closed path - ignoring vertex\n");
           return false;
        fi;
        if Length(vtxnames)=2 and 
           j^gens[vtxnames[1][2]] = vtxnames[2][1] and
           j^gens[vtxnames[1][3]] = vtxnames[2][1] and
           vtxnames[1][2] = vtxnames[2][2]  and
           vtxnames[1][3] = vtxnames[2][3]  then
#           Print("Found an ear!!");
           r := r * fgens[vtxnames[1][2]] * fgens[vtxnames[1][3]];
           return r;
        fi;

        for i in [ 1 .. Length(vtxnames)-1 ] do
            j := vtxnames[i][1];
            f := Filtered(vtxnames[i]{[2,3]},g-> (j^gens[g]=vtxnames[i+1][1]));
            if i = 1  then
                h := Difference(vtxnames[i]{[2,3]},f);
                if Length(h) > 0 then 
                    r := r * fgens[h[1]];       
                fi;
            fi;
            if Length(f) <> 0 then
                r := r * fgens[f[1]];       
            fi;
        od;
        i := Length(vtxnames);
        j := vtxnames[i][1];
        h := Difference(vtxnames[i]{[2,3]},f);
        if Length(h) > 0 and j^gens[h[1]] = j then
             Print("|\n");
             return false;
        fi;
        f := Filtered(vtxnames[i]{[2,3]},g-> (j^gens[g]=vtxnames[1][1]));
#        if Length(f) > 1 then Error("incorrect names"); return; fi;
#        if Length(f) <> 0 then
#            PrintGen(gens, f[1] );
#            Print(j^gens[f[1]]);
#        fi;
#        Print("\n");
#        Error("check me");
        return r; 
end);

##
## obtain the vertex relation around a given edge
##
GetVertexRelation := function( gens, vtxnames, fgrp )

        local i,j,f, h, r, fgens;


        fgens := GeneratorsOfGroup(fgrp);
        r := One(fgrp);

        j := vtxnames[1][1];
        if j^gens[vtxnames[1][2]] = j or 
           j^gens[vtxnames[1][3]] = j then 
           # This is not a closed path
           Print("not a closed path - ignoring vertex\n");
           return false;
        fi;
        if Length(vtxnames)=2 and 
           j^gens[vtxnames[1][2]] = vtxnames[2][1] and
           j^gens[vtxnames[1][3]] = vtxnames[2][1] and
           vtxnames[1][2] = vtxnames[2][2]  and
           vtxnames[1][3] = vtxnames[2][3]  then
#           Print("Found an ear!!");
           r := r * fgens[vtxnames[1][2]] * fgens[vtxnames[1][3]];
           return r;
        fi;

        for i in [ 1 .. Length(vtxnames)-1 ] do
            j := vtxnames[i][1];
            f := Filtered(vtxnames[i]{[2,3]},g-> (j^gens[g]=vtxnames[i+1][1]));
            if i = 1  then
                h := Difference(vtxnames[i]{[2,3]},f);
                if Length(h) > 0 then 
                    r := r * fgens[h[1]];       
                fi;
            fi;
            if Length(f) <> 0 then
                r := r * fgens[f[1]];       
            fi;
        od;
        i := Length(vtxnames);
        j := vtxnames[i][1];
        h := Difference(vtxnames[i]{[2,3]},f);
        if Length(h) > 0 and j^gens[h[1]] = j then
             Print("|\n");
             return false;
        fi;
        f := Filtered(vtxnames[i]{[2,3]},g-> (j^gens[g]=vtxnames[1][1]));
#        if Length(f) > 1 then Error("incorrect names"); return; fi;
#        if Length(f) <> 0 then
#            PrintGen(gens, f[1] );
#            Print(j^gens[f[1]]);
#        fi;
#        Print("\n");
#        Error("check me");
        return r; 
end;


#############################################################################
##
##  The following functions only access the simplicial surface and return
##  known information about the simplicial surface <simpsurf>.
## 

#############################################################################
##
##
#!  @Description
#!  This function returns the list of faces of a  simplicial surface.
#!  @Returns a list
#!  @Arguments simpsurf
#!
InstallGlobalFunction( FacesOfSimplicialSurface, function( simpsurf)

        if not IsSimplicialSurfaceRep(simpsurf) then
            Error("usage: FacesOfSimplicialSurface(simpsurf");
            return fail;
        fi;
        return simpsurf!.faces;

end);

#############################################################################
##
##
#!  @Description
#!  This function returns the number of faces of a  simplicial surface.
#!  @Returns an integer
#!  @Arguments simpsurf
#!
InstallGlobalFunction( NrOfFacesOfSimplicialSurface, function (simpsurf)

        return Length(FacesOfSimplicialSurface(simpsurf));

end);

#############################################################################
##
##
#!  @Description
#!  This function returns the list of edges of a  simplicial surface.
#!  @Returns a list
#!  @Arguments simpsurf
#!
InstallGlobalFunction( EdgesOfSimplicialSurface, function( simpsurf)

        if not IsSimplicialSurfaceRep(simpsurf) then
            Error("usage: EdgesOfSimplicialSurface(simpsurf");
            return fail;
        fi;
        return simpsurf!.edges;

end);

#############################################################################
##
##
#!  @Description
#!  This function returns the number of edges of a  simplicial surface.
#!  @Returns an integer
#!  @Arguments simpsurf
#!
InstallGlobalFunction( NrOfEdgesOfSimplicialSurface, function( simpsurf)

       return Sum(List(EdgesOfSimplicialSurface(simpsurf), i->Length(i)));

end);

#############################################################################
##
##
#!  @Description
#!  This function returns the list of vertices of a  simplicial surface.
#!  @Returns a list
#!  @Arguments simpsurf
#!
InstallGlobalFunction( VerticesOfSimplicialSurface, function( simpsurf)

        if not IsSimplicialSurfaceRep(simpsurf) then
            Error("usage: VerticesOfSimplicialSurface(simpsurf");
            return fail;
        fi;
        return simpsurf!.vertices;

end);

#############################################################################
##
##
#!  @Description
#!  This function returns the number of vertices of a  simplicial surface.
#!  @Returns an integer
#!  @Arguments simpsurf
#!
InstallGlobalFunction( NrOfVerticesOfSimplicialSurface, function( simpsurf)

        return Length(VerticesOfSimplicialSurface(simpsurf));

end);


#############################################################################
##
##
#!  @Description
#!  This function computes the Euler characteristic of a simplicial surface.
#!  The Euler characteristic is |V| - |E| + |F|, where |V| is the number of
#!  vertices, |E| is the number of edges and |F| is the number of faces.
#!  @Returns an integer, which is the Euler characteristic.
#!  @Arguments <simpsurf>, a simplicial surface object as created 
#!  by SimplicialSurface
#!
InstallGlobalFunction( GeneratorsOfSimplicialSurface, function( simpsurf)

        if not IsSimplicialSurfaceRep(simpsurf) then
            Error("usage: GeneratorsOfSimplicialSurface(simpsurf");
            return fail;
        fi;
        return simpsurf!.generators;

end);

#############################################################################
##
##
#!  @Description
#!  This function computes the Euler characteristic of a simplicial surface.
#!  The Euler characteristic is |V| - |E| + |F|, where |V| is the number of
#!  vertices, |E| is the number of edges and |F| is the number of faces.
#!  @Returns an integer, which is the Euler characteristic.
#!  @Arguments <simpsurf>, a simplicial surface object as created 
#!  by SimplicialSurface
#!
InstallGlobalFunction( GroupOfSimplicialSurface, function(simpsurf)

        if not IsSimplicialSurfaceRep(simpsurf) then
            Error("usage: GroupOfSimplicialSurface(simpsurf");
            return fail;
        fi;
        return Group(simpsurf!.generators);

end);


#############################################################################
##
##
#!  @Description
#!  This function computes the Euler characteristic of a simplicial surface.
#!  The Euler characteristic is |V| - |E| + |F|, where |V| is the number of
#!  vertices, |E| is the number of edges and |F| is the number of faces.
#!  @Returns an integer, which is the Euler characteristic.
#!  @Arguments <simpsurf>, a simplicial surface object as created 
#!  by SimplicialSurface
#!
InstallGlobalFunction( EulerCharacteristic, function (simpsurf)

    local chi;

    if not IsSimplicialSurfaceRep(simpsurf) then
        Error("usage: EulerCharacteristic(simpsurf");
        return fail;
    fi;

    if IsBound(simpsurf!.EulerCharacteristic) then
        return simpsurf!.EulerCharacteristic;
    fi;

    chi :=    NrOfVerticesOfSimplicialSurface(simpsurf)  # V
            - NrOfEdgesOfSimplicialSurface(simpsurf)     # -E
            + NrOfFacesOfSimplicialSurface(simpsurf);    # +F


     simpsurf!.EulerCharacteristic := chi;

     return chi;

end);

#############################################################################
##
#!  @Description
#!  This function computes the degrees of the vertices of the simplicial 
#!  surface <simpsurf>.
#!  The degree of a vertex is the number of faces incident to the vertex.
#!  @Returns a list of integers in increasing order, containing for each
#!  vertex of the simplicial suface its degree
#!  @Arguments <simpsurf>, a simplicial surface object as created 
#!  by SimplicialSurface
#!
InstallGlobalFunction( DegreesOfSimplicialSurface, function(simpsurf)

        local degrees, i;

# TODO noch nicht richtig fuer flaps
        if not IsSimplicialSurfaceRep(simpsurf) then
            Error("usage: DegreesOfSimplicialSurface(simpsurf");
            return fail;
        fi;
        if IsBound(simpsurf!.Degrees) then return simpsurf!.Degrees; fi;

        degrees := List(VerticesOfSimplicialSurface(simpsurf), i-> Length(i));
        Sort(degrees);

        simpsurf!.Degrees := degrees;

        return degrees;
end);



##
##  A method to test whether two simplicial surfaces are equal
##
##  TODO: check for equality if the generators are possibly reordered
##
InstallMethod( \=, "for two wild simplicial surfaces", true, 
  [ IsSimplicialSurfaceRep, IsSimplicialSurfaceRep ], 0,  function( s1, s2 )

        local vtx, rvtx, vert1, vert2;

        if EulerCharacteristic(s1) <> EulerCharacteristic(s2) then
                return false;
        fi;

        if GeneratorsOfSimplicialSurface(s1) <>
           GeneratorsOfSimplicialSurface(s2) then
                return false;
        fi;

        if DegreesOfSimplicialSurface(s1) <>
           DegreesOfSimplicialSurface(s2) then
                return false;
        fi;

        if EdgesOfSimplicialSurface(s1) <>
           EdgesOfSimplicialSurface(s2) then
                return false;
        fi;

        vert1 := VerticesOfSimplicialSurface(s1);
        vert2 := VerticesOfSimplicialSurface(s2);

        if Length(vert1)<>Length(vert2) then return false; fi;

        # vertices might come in different order.
        for vtx in  vert1 do
            # also check the reverse vertex
            rvtx := [ vtx[1] ];
            Append( rvtx, Reversed( vtx{[2..Length(vtx)]} ) );
            if not vtx in vert2 and not rvtx in vert2 then
                return false; 
            fi;

        od;

        return true;

end);



#InstallMethod( \<, "for two simplicial surfaces", true, 
#  [ IsSimplicialSurfaceRep, IsSimplicialSurfaceRep ], 0,
#   LtSimplicialSurface );

#############################################################################
##
#!  @Description Given a wild coloured simplicial surface <simpsurf>, this
#!  function determines the mr-type of each of the edges of <simpsurf>.
#!  The mr-type of an edge of <simpsurf> is either "m" (for mirror) or 
#!  "r" (for rotation). It is defined as followed. 
#!  Suppose the edge  $e$ is incident to the vertices $v_1$ and 
#!  $v_2$ and to the two faces $F$ and $F'$. Let $x$ and $y$ be the edges of
#!  incident  incident to $F$ and $F'$ and to the same vertex $v_1$, say.
#!  Then $e$ is of type $m$ if both $x$ and $y$ have the same colour, and $e$
#!  is of type $r$ if $x$ and $y$ are different. As we assume the surface to
#!  be wild coloured, this means that the colours of the other edges incident 
#!  to $e$ and both faces $F$ and $F'$ are then also determined. As the # $'$
#!  edges of the simplicial surface are pairs of points, the mr-type of 
#!  the simplicial surface <simpsurf> can be encoded as a list of length 3. 
#!   Each of the
#!  entries is in turn  a list encoding the mr-type of all edges of a 
#!  certain colour. Suppose that mrtype[1] is the list encoding the mr-type
#!  of the red edges. Then mrtype[1][i] = 0 if the mr-type of the red edge
#!  incident to the vertex i is unknown, mrtype[1][i] = 1 if the mr-type of 
#!  the red edge incident to the vertex i is "m", and mrtype[1][i] = 2 if 
#!  the mr-type of the red edge incident to the vertex i is "r". 
#!  @Returns a list of three lists, each of which contains the 
#!  entries 0, 1 or 2.
#!  @Arguments <simpsurf>, a simplicial surface object as created 
#!  by SimplicialSurface
#!  @BeginExample
#! MrTypeOfSimplicialSurface(tetra);
#! @EndExample
#!
InstallGlobalFunction( MrTypeOfSimplicialSurface, function (simpsurf)
 
        local mrtype, i, j, f, path, n, pos, g, gens;

        if not IsSimplicialSurfaceRep(simpsurf) then
            Error("usage: MrTypeOfSimplicialSurface(simpsurf");
            return fail;
        fi;

        if IsBound(simpsurf!.mrtype) and Length(simpsurf!.mrtype) > 0 
           and simpsurf!.mrtype[1] <> 0 * simpsurf!.mrtype[1]  and
                simpsurf!.mrtype[2] <> 0 * simpsurf!.mrtype[2] and
                simpsurf!.mrtype[3] <> 0 * simpsurf!.mrtype[3]  then 
            return simpsurf!.mrtype; 
        fi;

        gens := GeneratorsOfSimplicialSurface(simpsurf);
        n := Maximum(FacesOfSimplicialSurface(simpsurf));

        mrtype := [];
     
        mrtype [1] := List( [1 .. n], i-> 0 );
        mrtype [2] := List( [1 .. n], i-> 0 );
        mrtype [3] := List( [1 .. n], i-> 0 );

       for path in VerticesOfSimplicialSurface(simpsurf) do
           for i in [ 1 .. Length(path)] do
               if i < Length(path) then j  := i + 1; else j := 1; fi;
               f := path[i][1]; # the face we are considering
#               Print( f, " ");
               g := Filtered( path[i]{[2,3]}, x -> (f^gens[x] = path[j][1]) );
#               if Length(g) > 1 then
#                   Print("# ear \n");
#               fi; 
               if Length(g) = 0 then continue; fi;
               g := g[1]; # g is the permutation mapping f to next face

               if Set(path[i]{[2,3]}) = Set(path[j]{[2,3]}) then
                   # this is a mirror
                   mrtype[g][f] := 1;
                   mrtype[g][f^gens[g]] := 1;
               elif Size(Intersection(Set(path[i]{[2,3]}), Set(path[j]{[2,3]})))=1 then
                   # this is a rotation
                   mrtype[g][f] := 2;
                   mrtype[g][f^gens[g]] := 2;
               else Error("?");
               fi;
            od;
#            Print("\n");
        od;
 
        simpsurf!.mrtype := mrtype;

        return mrtype;

end);


#############################################################################
##
#!  @Description Given a wild coloured simplicial surface <simpsurf>, this
#!  function determines the vertex group of the simplicial surface.
#!  The vertex group of the simplicial surface <simpsurf> is defined to be
#!  $F_3/R$, where $F_3$ is the free group on three generators and $R$ is 
#!  the set of relations given by the vertex defining paths.
#!  @Returns finitely presented group.
#!
InstallGlobalFunction( VertexGroupOfSimplicialSurface, function(simpsurf)

        local vtxnames, rels, r,  gens, fgrp;
 
        gens := GeneratorsOfSimplicialSurface(simpsurf);
        fgrp := FreeGroup(Length(gens));
        rels := [fgrp.1^2, fgrp.2^2, fgrp.3^2];

        for vtxnames in VerticesOfSimplicialSurface(simpsurf) do
            r := GetVertexRelation(gens, vtxnames, fgrp);
            if r <> false then Add(rels, r); fi;
        od;

        return [fgrp,Set(rels)];
      
end);

#############################################################################
##
##  A Print method for simplicial surfaces
##

PrintSimplicialSurface := function(simpsurf)

        Print("SimplicialSurface( rec(\n");
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

InstallMethod( PrintObj, "for SimplicialSurface", true, 
               [ IsSimplicialSurfaceRep ], 0, PrintSimplicialSurface );


#############################################################################
##
##  A Display method for simplicial surfaces
##
DisplaySimplicialSurface := function(simpsurf)

        local g, vtx, c, e, i, gens, f, mr, faceinverse;
 

        gens :=  GeneratorsOfSimplicialSurface(simpsurf);
        Print("Generators = \n");
        f := FacesOfSimplicialSurface(simpsurf);
        faceinverse := List([1..Length(f)],i->0);

        # store the position of face in in faces to avoid searching
        for i in f do
            faceinverse[i] := Position(f,i);
        od;

        MrTypeOfSimplicialSurface(simpsurf);
        for i in [ 1.. Length(gens) ] do
           e :=   Cycles(gens[i],f);
           Print( gens[i], "\n");
           mr := Filtered( e, c -> simpsurf!.mrtype[i][faceinverse[c[1]]] = 1 );
           Print("    mirrors  ", mr, "\n" );
           mr := Filtered( e, c -> simpsurf!.mrtype[i][faceinverse[c[1]]] = 2 );
           Print("    rotations ", mr, "\n" );
        od;
        
        Print("Faces = ", FacesOfSimplicialSurface(simpsurf), "\n");
        e := Filtered( e , c -> Length(c) = 2);
        Print("Edges = ", EdgesOfSimplicialSurface(simpsurf), "\n");

        Print("Vertices = \n");
        for vtx in VerticesOfSimplicialSurface(simpsurf) do
            Print("    " ); _SIMPLICIAL_PrintVertexLabels( gens, vtx );
        od;
 
        Print("Degrees = ", DegreesOfSimplicialSurface(simpsurf) );

end;

InstallMethod( Display, "for SimplicialSurfaces", true, 
                   [IsSimplicialSurfaceRep], 0, DisplaySimplicialSurface );



IsConnectedSimplicialSurface := function(simpsurf)


      if IsBound( simpsurf!.isConnected ) then 
          return simpsurf!.isConnected;
      fi;

      simpsurf!.isConnected := 
      Length(Orbits(GroupOfSimplicialSurface(simpsurf), 
                    FacesOfSimplicialSurface(simpsurf)))=1;

          return simpsurf!.isConnected;

end;


#############################################################################
##
##  AllSimplicialSurfaces( gens[, mrtype] ) . . . . all simplicial surfaces
##  AllSimplicialSurfaces( grp[, mrtype] )
##  AllSimplicialSurfaces( sig1, sig2, sig3[, mrtype] )
##
##
#!  @Description
#!  This function computes all wild-coloured simplicial surfaces generated
#!  by a triple of involutions as specified in the input. If the optional
#!  argument <mrtype> is present, only those wit a predefined mrtype are
#!  constructed.
#!  The involution triple can be given to the function in various ways.
#!  Either they are input as a list <gens> of three involutions, or as
#!  a group <grp> whose generators are the tree involutions, or they can
#!  be input into the function as three arguments, one for each involution.
#! 
#!  In case the optional argument <mrtype>  is present, it can be used to
#!  restrict to wild-colourings for which some or all edges have a predefined
#!  colour. This is equivalent to marking the cycles of the three involutions
#!  as follows. If the edge $(j, j^\sigma_i)$ of the involution $\sigma_i$ is
#!  to be a reflection (mirror) let $k=1$, if it is to be a rotation, let 
#!  $k=2$ and if it can be either let $k=0.$ Then set $mrtype[i][j] = k$.
#!  @Returns a list of all wild-coloured simplicial surfaces with generating
#!  set given by three involutions.
#!  The function AllSimplicialSurfaces when called with the optional argument
#!  <mrtype> now returns all wild-coloured simplicial surfaces whose edges
#!  are coloured according to the restrictions imposed by <mrtype>.
#!  @Arguments gens, a list of three involutions
#!
InstallGlobalFunction( AllSimplicialSurfaces, function(arg)


	local faces, edges, vertices, grp, gens, i, j, k, 
          allvtxnames, completedvertices, nrvtsface, 
          FirstFreeVertex,  FindSimplicialSurface, 
          AllSurfaces, level, n, allvertices, IsMirror, IsRotation,  
          LoopOneVertexSignedWithBoundary,  faceinverse,
          BreakPoint,  mrtype,         knownmrtype, cmpvertices;

cmpvertices := function (v1, v2 )

    if Length(v1) < Length(v2 ) then return true;
    elif Length(v1) > Length(v2) then return false;
    fi;
    # now they have the same length
    return v1 < v2;

end;


    mrtype := [];

    if Length(arg) = 1 then
        if IsGroup(arg[1]) then gens := GeneratorsOfGroup(arg[1]);
        else gens := arg[1]; fi;
    elif Length(arg) = 2 then
        if IsGroup(arg[1]) then gens := GeneratorsOfGroup(arg[1]);
        else gens := arg[1]; fi;
        mrtype := arg[2];
    elif Length(arg) = 3 then
   	   gens := [arg[1],arg[2],arg[3]];
    elif Length(arg) = 4 then
   	   gens := [arg[1],arg[2],arg[3]];
       mrtype := arg[4];
    fi;
    if not IsList(gens) or Length(gens) <> 3 then
         Error("usage: AllSimplicialSurfaces( gens[, mrtype] )\n");
    fi;
    if not IsPerm(gens[1]) or not IsPerm(gens[2])
        or not IsPerm(gens[3]) then
         Error("usage: AllSimplicialSurfaces( gens[, mrtype] )\n");
    fi;
    if gens[1]^2 <> One(gens[1]) or gens[2]^2 <> One(gens[2]) 
        or gens[3]^2 <> One(gens[3]) then
            Error("generators must be involutions\n");
    fi;

    if not IsList(mrtype) or not Length(mrtype) in [0,3] then
            Error("usage: AllSimplicialSurfaces( gens[, mrtype] )\n");
    fi;

        

    BreakPoint := false;
    faces := ShallowCopy(MovedPoints(gens));
    Sort(faces);
    n := Length(faces);
    faceinverse := List([1..n],i->0);

    # store the position of face in in faces to avoid searching
    for i in faces do
        faceinverse[i] := Position(faces,i);
    od;

    for i in [ 1 .. 3] do
        for j in [i+1 .. 3] do
            if NrMovedPointsPerm( gens[i] * gens[j] ) <> n then
                Print("Warning: Simplicial surface not vertex transitive\n");
            fi;
        od;
    od;
 

    # if the argument mrtype was an empty list, then set all
    # mr-types to 0 - meaning unknown.       
    if Length(mrtype) = 0 then
        knownmrtype := false;
        mrtype := [];
        mrtype [1] := List( [1 .. n], i-> 0 );
        mrtype [2] := List( [1 .. n], i-> 0 );
        mrtype [3] := List( [1 .. n], i-> 0 );
    else
        knownmrtype := true;
    fi;

    # mirror has mr-type 1
    IsMirror := function( g, i )
        return mrtype[g][faceinverse[i]]=1;
    end;

    # rotation has mr-type 2
    IsRotation := function( g, i )
        return mrtype[g][faceinverse[i]]=2;
    end;

    # unknown has mr-type 0

    # now  we know that the simplicial surface is vertex transitive
    # this implies in particular that any 2-cycle only occurs in one
    # generator
    grp := Group(gens);

    # the edges are the 2-cycles of the transposition. We colour
    # the edges according to the permutation sigi which gave rise
    # to them. Note that no edge can arise from two different
    # permutations.
	edges := [Cycles(gens[1],faces),Cycles(gens[2],faces),Cycles(gens[3],faces)];
    vertices := [];

    # we now make a list of all possible vertices. This list will
    # contain a particular vertex several times under several different
    # names. A vertex is described by all triples (i, a,b) such a<b and
    # that the vertex is adjacent to i and has edges gens[a] and gens[b].
	allvertices := [];
    for i in [ 1 .. n ] do
        for j in [ 1 .. 3] do
            for k in [j+1 .. 3] do
                # k > j 
                Add(allvertices,[faces[i],j,k]);
            od;
        od;
    od;
    #(f-1)*3 + (i-1)*2 + j-i
    # 12 -> +1
    # 13 -> +2
    # 23 -> +3

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
    LoopOneVertexSignedWithBoundary :=
            function(vtx,g,vtxnames,completedvertices,nrvtsface)
            local  h, fac, i, j, pj, k, x, knownfaces, nvtx, nvtxnames,
                   vtxnames_c, completedvertices_c, nrvtsface_c, poss;

            # all already known names for this vertex 
            # - known to be valid up to here
            # all already known faces incident to this vertex
            knownfaces := List(vtxnames, i-> i[1]);

            i := vtx[1]; # the face
            # consider each of the other two generators different to g

#           PrintVertexLabels( gens, vtxnames ); Print("\n");

            j :=  i^gens[g];
            if i = j then
                    # we have a boundary vertex
                    # back to the current starting point of the path
                    # and continue from there
                    if Length(vtxnames) = 1 then
                       # we are starting out with a boundary vertex
                       # but marching in the wrong direction so turn around
                       if vtx[2]=g then g := vtx[3];
                       else g := vtx[2]; fi;
#                      g := Difference(vtx[2],[g]);
#                      g := g[1];
                       j := i^gens[g];
                    else
                       # now we know that we are at the end of a 
                       #  path of length at least 2
                       # reverse path and continue at vertex at other end
                       vtx := vtxnames[1];
                       i := vtx[1];
                       g := [];
                       if i^gens[vtx[2]] <> vtxnames[2][1] then g := [vtx[2]];
                       elif i^gens[vtx[3]] <> vtxnames[2][1] then g := [vtx[3]];
                       fi;
#                      g := Filtered(vtx{[2,3]}, j-> i^gens[j]<>vtxnames[2][1]);
                       if g = [] then
                           # we found an ear
                           Print("we found an ear\n");
                       else
                           g := g[1];
                           j := i^gens[g];
                           vtxnames := Reversed(vtxnames);
                       fi;
                    fi;
            fi;


            if not j in knownfaces then


                # if the edge of face j opposite the given vertex is
                # known, then we have no choice 
#                x := PositionsProperty(allvertices, 
#                     v->(v[1]=j and (v[2] = g or v[3]=g)) );
                x := (faceinverse[j]-1)*3;
                if g = 1 then x := [x+1,x+2];
                elif g=2 then x := [x+1,x+3];
                else  x := [x+2,x+3]; fi;
                # x are the positions of the two vertices adjacent to j 
                # meeting the edge g from i to j 

                # work out whether we have 
                # a mirror (m) or a rotation (r) edge
                if mrtype[g][faceinverse[i]]=1 then
#                if IsMirror( g, i ) then  # h i g j -> use h next
                    # if g is an m-edge the we use the same generator
#                    poss := Difference( vtx{[2,3]}, [g] );
                    if g = vtx[2] then poss:= [vtx[3]]; 
                    elif g = vtx[3] then poss:=[vtx[2]];
                    else poss := [vtx[2],vtx[3]]; fi;
                elif mrtype[g][faceinverse[i]]=2 then
#                elif IsRotation( g, i ) then # h i g j -> use neither h, g next
                    # if g is an r-edge the we use the other generator
                     poss := [6-vtx[2]-vtx[3]];
#                    poss := Difference( [1..3], vtx{[2,3]} );
                else 
                    # the edge is not known, so just do not use g
#                    poss := Difference([1..3],[g]);
                    if g=1 then poss:=[2,3]; elif g=2 then poss:=[1,3]; 
                    else poss := [1,2]; fi;
                fi;
                if completedvertices[x[1]] then 
                    # the vertex is known. Do not consider the 
                    # generator on that vertex as it is already on face j
                    poss := Difference(poss,allvertices[x[1]]{[2,3]}); 
                elif completedvertices[x[2]] then 
                    poss := Difference(poss,allvertices[x[2]]{[2,3]});    
                fi;

                if poss = [] then # Print("contradiction "); 
                return; fi;
                # Error(); fi;

                # we have not seen this face around the vertex yet
                for h in poss  do
                    # modify a new copy of vtxnames
                    vtxnames_c := ShallowCopy(vtxnames);
                    completedvertices_c := ShallowCopy(completedvertices);
                    nrvtsface_c := ShallowCopy(nrvtsface);
                    # choose to continue with vertex {j,g,h}
                        # the vertex we are adding is making g into a
                        # mirror if [g,h] was also in previous vertex
                        k := Length(vtxnames_c);
                        if k > 0 and g < h then
                            if vtxnames_c[k][2]=g and 
                               vtxnames_c[k][3]=h and 
                               mrtype[g][faceinverse[j]]=2 then
                               # g should be a rotation but is a mirror
                               return;
                            elif vtxnames_c[k][2]<>h and 
                               vtxnames_c[k][3]<> h and 
                               mrtype[g][faceinverse[j]]=1 then
                               # g should be a mirror but is a rotation
                               return;
                            fi;
                    #   elif k > 0 and h < g then
# TODO: What was this and why is it commented out?                   
#                            if vtxnames_c[k][2]=h and 
#                               vtxnames_c[k][3]=g and 
#                               mrtype[g][faceinverse[j]]=2 then
#                               # g should be a rotation but is a mirror
#                               Print("YEAH2\n"); return;
#                            elif vtxnames_c[k][2]<>h and 
#                               vtxnames_c[k][3]<> h and 
#                               mrtype[g][faceinverse[j]]=1 then
#                               # g should be a mirror but is a rotation
#                               Error("YEAH2A\n"); return;
#                            fi;
                        fi;
                    if g < h then
                        Add( vtxnames_c, [j,g,h] );
#                        k := Position(allvertices,[j,g,h]); # slow code
                        k := (faceinverse[j]-1)*3 + (g-1)*2 + h-g;
                    else
                        Add( vtxnames_c, [j,h,g] );
#                        k := Position(allvertices,[j,h,g]); # slow code
                        k := (faceinverse[j]-1)*3 + (h-1)*2 + g-h;
                    fi;
                    # record that the vertex has been used again
                    if completedvertices_c[k]  then
                        # a vertex  can only be completed once - 
                        # so this is no solution
                        return;
                    fi;
                    completedvertices_c[k] := true;
                    pj := faceinverse[j];
                    nrvtsface_c[pj] := nrvtsface[pj]+1;
                    if nrvtsface_c[pj] > 3 then
                        # a face can only have 3 vertices - 
                        # so this is no solution
                        return;
                    fi;
                    # continue on with h               
                    nvtx := [j,g,h];
                    if h < g then nvtx  := [j,h,g]; fi;
                    LoopOneVertexSignedWithBoundary(nvtx, h,vtxnames_c,
                                  completedvertices_c,nrvtsface_c);
                    # Then continue with the next h.
                od;

            else # now j in knownfaces 
                # we found the face j twice around the vertex

                if i = j then
                    # we found the other  boundary of a vertex
                    Add(allvtxnames,[vtxnames,completedvertices,nrvtsface]);
                    return;
                elif j <> vtxnames[1][1] then
                   # we are not back at the start - so this is illegal
                   return;
                else
                   # we are back at the start, hence g must be
                   # an edge of the starting face!
                   if g <> vtxnames[1][2] and g <> vtxnames[1][3] then
                       # we did not end up where we started with g
                       return;
                   else
                       # we are at the start so add 
                       # but let the vertex start with smallest face
                       if vtxnames[1]<>Minimum(vtxnames) then
                            k := Position(vtxnames,Minimum(vtxnames));
                            nvtxnames := vtxnames{[k..Length(vtxnames)]};
                            Append(nvtxnames, vtxnames{[1..k-1]});
                            vtxnames := nvtxnames;
                       fi;
                       Add(allvtxnames,[vtxnames,completedvertices,nrvtsface]);
                       return;
                   fi;
                fi;
             fi; # if not j in knownfaces 
            return;
        end;

   
    # The following function finds the first free vertex adjacent
    # to a face for which as many vertices are known as possible

    FirstFreeVertex := function(completedvertices, nrvtsface)

        local face, v;
        
        # first find a face with as many know vertices as possible
        if 2 in nrvtsface then 
             face := faces[PositionProperty( nrvtsface, f-> f = 2 )];
        elif 1 in nrvtsface then
             face := faces[PositionProperty( nrvtsface, f-> f = 1 )];
        elif 0 in nrvtsface then
             face := faces[PositionProperty( nrvtsface, f-> f = 0 )];
        else
            # finished
             return false;
        fi;
 
        # this is the face with the most known vertices
        for v in [1..Length(allvertices)] do
            if not completedvertices[v] and 
               allvertices[v][1] = face then
                return v;
            fi;
        od;

        return false;

    end;

    # Supposing that we have chosen an initial set of vertices,
    # we now try to add the next vertex to our surface, recursively
    # here vertices are the vertices of our surface known so far,
    # completedvertices is a binary list telling us which vertices 
    # are done, and nrvtsface the number of vertices per face for
    # the surfaces under construction

    FindSimplicialSurface := function(level,vertices,completedvertices,nrvtsface)
    
        local vtx, v, i, pi, g, h, vtxEquivalentnames, vertices_c, ss,
              allvtxnames_c, completedvertices_c, nrvtsface_c, Li, x, edges;


        # choose the first free vertex
        # It can be fixed from now on, since it has to be
        # somewhere in the surface
        v := FirstFreeVertex(completedvertices, nrvtsface);
#       Print("lv= ", level, " v= ", v, "\n");

        if v = false then
            ##  now we know that there is no more free vertex
            edges :=  List( gens, g-> Cycles(g,MovedPoints(gens)));
            edges  := List( edges, e->Filtered( e , c -> Length(c) = 2));

            Sort( vertices, cmpvertices );
            ss :=  SimplicialSurface(rec( faces := MovedPoints(gens),
                edges := edges, vertices := vertices, generators := gens ));
            ss!.mrtype := mrtype;
            Add(AllSurfaces, ss );
#               Error("COMPLETED?\n");
            return;
        fi;

        vtx := allvertices[v];

        # Now we find all the different names for vtx
        i := vtx[1]; # the number of the face
        pi := faceinverse[i];
        g := vtx[2]; # the generator number labelling one edge
        h := vtx[3]; # the generator number  labelling the other edge
        vtxEquivalentnames := [vtx]; 

        completedvertices[v] := true;
        nrvtsface[pi] := nrvtsface[pi]+1;

        # We store for vertex vtx all its vertex defining paths in allvtxnames
        allvtxnames := [];
        LoopOneVertexSignedWithBoundary(vtx,g,vtxEquivalentnames, 
                                          completedvertices, nrvtsface);

#        Print("Starting Vertex: \n");
#        PrintVertexLabels( gens, vtxEquivalentnames );
 
       allvtxnames_c  := ShallowCopy(allvtxnames);

        for Li in allvtxnames_c do
             vertices_c := ShallowCopy(vertices);
             Add(vertices_c, Li[1]);
             completedvertices_c := ShallowCopy(Li[2]);
             nrvtsface_c := ShallowCopy(Li[3]);
             FindSimplicialSurface(level+1, vertices_c, completedvertices_c, 
                                               nrvtsface_c);

        od;
        
    end;


    # This is a global variable in which we shall store all
    # completed surfaces
    AllSurfaces := []; 

    # here we store whether a vertex has already been  completed
    completedvertices := BlistList([1..Length(allvertices)],[]);
    # in nrvtsface we store for each face how many vertices are known for
    # this face
    nrvtsface := List([1..n],i->0);
    level := 0;

    FindSimplicialSurface( level, [], completedvertices, nrvtsface); 

    return AllSurfaces;

end);



# compute the double cover - extend old mr settings
DoubleCoverOfSimplicialSurface := function (simpsurf)

        local gens, newgens, i, j, mrtype, MapCycle, grp, N, mrtypenew;


        N := NrOfFacesOfSimplicialSurface(simpsurf);

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

        gens := GeneratorsOfSimplicialSurface(simpsurf);
        newgens := List( gens, i-> Cycles(i,
            [ 1 .. Length(FacesOfSimplicialSurface(simpsurf)) ] ));

        mrtype := MrTypeOfSimplicialSurface(simpsurf);
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

        return SimplicialSurface( newgens[1], newgens[2], newgens[3], mrtypenew );
       
end;


###############################################################################
##
#!  @Description
#!  This function decides whether the wild-coloured simplicial surface
#!  <simpsurf> is orientable.
#!  @Returns true if the surface is orientable and false else.
#!  @Arguments <simpsurf> a simplicial surface
#!
InstallGlobalFunction( IsOrientableSimplicialSurface, function ( simpsurf )

        local gens, newgens, i, mrtype, MapCycle, orb, N;

        if not IsSimplicialSurfaceRep(simpsurf) then
            Error("usage: IsOrientableSimplicialSurface(simpsurf");
            return fail;
        fi;
        N:= NrOfFacesOfSimplicialSurface(simpsurf);


# Map each cycle to a covering cycle. Mirrors are mapped to
# (i, -j) (-i,j) and rotations to (i,j)(-i,-j). If the
# type is unknown, we leave the cycle unchanged.
MapCycle := function (c, t)

    local i, j;


    if Length(c) < 2 then return One(()); fi;   
    i := c[1]; j := c[2];

    if t = 0 then return (i,j); fi;

    if t = 1 then
        return (i, j+N) * (i+N, j );
    elif t = 2 then
        return (i,j)*(i+N, j+N);
    fi;

end;

        gens := GeneratorsOfSimplicialSurface(simpsurf);
        newgens := List( gens, i-> Cycles(i,
            [ 1 .. Length(FacesOfSimplicialSurface(simpsurf)) ] ));

        mrtype := MrTypeOfSimplicialSurface(simpsurf);

        for i in [ 1 .. 3 ] do
            newgens[i] := List( newgens[i], c -> MapCycle(c,mrtype[i][c[1]]));
            newgens[i] := Product( newgens[i] );
        od;

        orb := Orbits(Group(newgens));
        if Length(orb) = 1 then
            simpsurf!.isOrientable := false;
            return false;
        elif Length(orb) = 2 then
            simpsurf!.isOrientable := true;
            return true;
        else
            Error("unknown orientability");
        fi;

        return fail;
       
end);


#############################################################################
##
#!  @Description
#!  This function takes as input a  wild-coloured simplicial surface
#!  <simpsurf> and returns the simplicial simplicial surface obtained
#!  from <simpsurf> by recursively removing all ears. An ear is a surface
#!  consisting of two faces that have two common incident edges.
#!  @Returns a simplicial surface without ears.
#!
InstallGlobalFunction( SnippOffEars, function( simpsurf )

        local i, gens, edges, FindCommon, j, e, ne, vtx, ear, x, vtxnames,
              newvertices, newedges, newgens, newvtxnames, verynewvertices;

        gens := GeneratorsOfSimplicialSurface(simpsurf);
        newgens := ShallowCopy(gens);

        edges := EdgesOfSimplicialSurface(simpsurf);

        newedges := [List(edges[1],i->ShallowCopy(i)),
                    List(edges[2],i->ShallowCopy(i)),
                    List(edges[3],i->ShallowCopy(i))];
        newvertices := ShallowCopy(VerticesOfSimplicialSurface(simpsurf)); 

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


        return SimplicialSurface( rec( generators := newgens,     
                    faces := MovedPoints(gens),
                    edges := newedges, 
                    # here we are careful to create a structural copy
                    # of the vertices
                    vertices := StructuralCopy(newvertices)));
end);


##
##    Compute the edges of a wild coloured simplicial surface from its
##    generators - which are assumed to be  a triple of involutions
## 
EdgesFromCycles := function ( gens )

    local edges, g;

    edges := [];

    for g in gens do
        Append( edges,  Cycles( g, MovedPoints(gens) ) );
    od;

    return Filtered(edges, g->Length(g)=2);

end;

# auxilliary function
# v is a vertex, i.e. a face path.
# find all possible lists of generators that
# support this walk. We assume that if v is a closed walk, then
# it starts and ends with the same face.
WalksForVertex := function( gens, v )

    local  walks, g, w, i, j, nw, newwalks, iselig;


    iselig := function( w )
        local e;

        for e in w do
            if e[2]=e[3] then return false; fi;
        od;
        return true;
    end;

    walks := [[]];
    if v[Length(v)] <> v[1] then
        for i in [1..Length(v)-1] do
            g := Filtered( gens, j-> v[i]^j=v[i+1] );
            if g = [] then return false; fi;
            newwalks := [];
            # loop through all partial walks w and
            # define |g| new walks by adding the elements
            # of g to w
            for w in walks do
                for j in g do
                    nw := ShallowCopy(List(w,i->ShallowCopy(i)));
                    Add(nw,[v[i],Position(gens,j)]);
                    Add(newwalks, nw );
                od;
            od;
            walks := newwalks;
        od;
        i := Length(v);
        g := Filtered( gens, j-> v[i]^j=v[i] );
        if g = [] then return false; fi;
        newwalks := [];
        # loop through all partial walks w and
        # define |g| new walks by adding the elements
        # of g to w
        for w in walks do
            for j in g do
                nw := ShallowCopy(List(w,i->ShallowCopy(i)));
                Add(nw,[v[i],Position(gens,j)]);
                Add(newwalks, nw );
             od;
        od;
        walks := newwalks;

#Error("x1");
#                       
#                        newwalks := [];
#                        for w in walks do
#                            for j in g do
#                                nw := ShallowCopy(List(w,i->ShallowCopy(i)));
#                                Add( nw, [v[Length(v)],Position(gens,j)] );
#                                Add(newwalks, nw );
#                            od;
#                        od;
# Error("x2");

        else
            for i in [1..Length(v)-1] do
                g := Filtered( gens, j-> v[i]^j=v[i+1] );
                if g = [] then return false; fi;
                newwalks := [];
                # loop through all partial walks w and
                # define |g| new walks by adding the elements
                # of g to w
                for w in walks do
                    for j in g do
                        nw := ShallowCopy(List(w,i->ShallowCopy(i)));
                        Add(nw,[v[i],Position(gens,j)]);
                        Add(newwalks, nw );
                    od;
                od;
                walks := newwalks;
        od;
    fi;

    # now add second generator of first vtx
    if v[Length(v)] <> v[1] then
                  g := Filtered( gens, j-> v[1]^j=v[1] );
                  if g = [] then return false; fi;
                  newwalks := [];
                  for w in walks do
                      for j in g do
                          nw := ShallowCopy(List(w,i->ShallowCopy(i)));
                          Add(nw[1],Position(gens,j));
                          Add(newwalks, nw );
                     od;
                  od;
    else  # the second edge for first vertex
                  g := Filtered( gens, j-> v[Length(v)-1]^j=v[1] );
                  if g = [] then return false; fi;
                  newwalks := [];
                  for w in walks do
                     for j in g do
                          nw := ShallowCopy(List(w,i->ShallowCopy(i)));
                          Add(nw[1],Position(gens,j));
                          Add(newwalks, nw );
                     od;
                  od;
     fi;
     walks := newwalks;


          # add in the second generator for each face around v   
          j := Length(v); 
          if v[Length(v)] = v[1] then  j := j-1; fi;
                 
          for w in walks do
              for i in [2..j]do
                   Add(w[i],w[i-1][2]);
              od;
          od;

    # throw out walks which are not correct, i.e. have 
    # two edges that are equal
    walks := Filtered( walks, w -> iselig(w) );
    return walks;
end;

##  auxilliary function
## Test whether the generators match up with the vertices 
TestGens := function(gens, vertices)

            local v, i, vtx, allvertices, g, cart;
 

            cart := [];
            allvertices := [];
            for v in vertices do
                  vtx := WalksForVertex(gens, v);
                  if vtx = false then 
                      Print("vertex without walk");
                      return []; 
                  fi;
                  if vtx <> false then
                      Add(allvertices,vtx);
                      Add( cart, [1..Length(vtx)]);
                  fi;
            od;
            cart := Cartesian(cart);
            return List(cart,l->List([1..Length(l)],i->allvertices[i][l[i]]));

#                 vtx := [];
#                 # v = [f1, f2, f3 ..] faces around v
#                 for i in [1..Length(v)-1]do
#                    g := First( gens, j-> v[i]^j=v[i+1] );
#                    if g = fail then return false; fi;
#                    Add( vtx, [v[i], Position(gens,g)] );
#                 od;
#                 if v[Length(v)] <> v[1] then
#                     # we do not have a closed path,
#                     # which means last entry not equal to first
#                     # [1,2,3] -> [[1,1],[2,2],[3,1],
#                     g := First( gens, j-> v[1]^j=v[1] );
#                     if g = fail then return false; fi;
#                     Add(vtx[1],Position(gens,g));
#                     g := First( gens, j-> v[Length(v)]^j=v[Length(v)] );
#                     if g = fail then return false; fi;
#                     Add( vtx, [v[Length(v)], Position(gens,g)] );
#                 else # closed path
#                     g := First( gens, j-> v[1]^j=v[Length(v)-1] );
#                     if g = fail then return false; fi;
#                     Add(vtx[1],Position(gens,g));
#                 fi;
#                 for i in [2..Length(v)-1]do
#                     Add(vtx[i],vtx[i-1][2]);
#                 od;
#                 Add( allvertices, vtx );
#            od;

            return allvertices;

 end;


#############################################################################
##
#!  @Description
#!  This function takes as input a list of pairs of integers. Suppose the
#!  integers occurring in this list of pairs is the set faces. Then this
#!  function computes all triples of involutions acting on the set faces.
#!  @Returns a list of lists, which are involution triples.
#!  @Arguments a list of lists, which is a list of pairs of integers
#!
InstallGlobalFunction( GeneratorsFromEdgesOfSimplicialSurface, 
      function( alledges )

        local gens, g, i,  cycs, cycs_c, gens_c, faces, fixedpoints_c, c,
              AllGenSets, NextFace, fixedpoints, IsEligible;

        if Length(alledges) = 0 then return [ (), (), () ]; fi;

        faces := Set( Flat(alledges) );
        cycs := ShallowCopy(alledges);

        c := First( cycs, i-> Length(i) = 2 );
        if c = fail then return [ (), (), () ]; fi;
        Remove(cycs,Position(cycs,c));
        Sort(cycs);
        

        cycs_c := ShallowCopy(cycs);
        # the first cycle has to be somewhere so it might as well
        # be on the first generator
        gens_c := [ (c[1], c[2]), (), () ];


        # here we record which fixed points we have used in which
        # generator so far
        fixedpoints := [];
        fixedpoints[1] := List( [1..Length(faces)], i-> false );
        fixedpoints[2] := List( [1..Length(faces)], i-> false );
        fixedpoints[3] := List( [1..Length(faces)], i-> false );

        # a global variable to store the results
        AllGenSets := [];


        # test whether g can be extended with the cycle c
        IsEligible := function (g,i, c, fix )
              
            if Length(c) = 2 then
                # first we have to ensure that neither c[1] nor c[2] are
                # fixed points of g
                if fix[i][c[1]] = false and fix[i][c[2]] = false and
                   c[1]^g = c[1] and c[2]^g = c[2] then
                    return true; # the 2-cycle is not in gens[i] yet
                else return false;
                fi;
            else # c is a 1-cycle
                # if it has not yet been used in g and g fixes it, return true
                if fix[i][c[1]] = false and c[1]^g=c[1] then return true; fi;
            fi;

            return false;

        end;

        # find all possibilities of moving face f
        NextFace := function( gens, cycs, fixedpoints )
            local g, i, c, nf;

        
            # choose the first cycle that contains f
            c := cycs[1];

            # now we try to add c to each of the generators
            for i in [ 1 .. 3 ] do
                g := gens[i];
                if IsEligible(g,i,c, fixedpoints) then
                    # this generator does not already move the 
                    # points in c, hence we can extend it by c.
                    gens_c := ShallowCopy(gens);
                    cycs_c := ShallowCopy(cycs);
                    fixedpoints_c := 
                        List(fixedpoints, x -> ShallowCopy(x));
                    if Length(c) = 2 then 
                        # if c is a 2-cycle, extend g
                        gens_c[i] := g * (c[1],c[2]);
                    else
                        # if c is a 1-cycle record its use in g
                        fixedpoints_c[i][c[1]] := true;
                    fi;
                    Remove( cycs_c, Position(cycs_c,c) );

                    if Length(cycs_c) = 0 then
                        # there are no more points to move 
                        # hence we found a valid assignment
                        Sort( gens_c );
                        Add(AllGenSets, gens_c);
                    else
                        NextFace( gens_c,cycs_c,fixedpoints_c);
                    fi;
                fi;
            od;

        end;


        NextFace( gens_c, cycs_c, fixedpoints );

        return Set(AllGenSets);

end);



#############################################################################
##
#!  @Description
#!  This function takes as input a ``face"- description of a surface. 
#!  A ``face"-description of a surface is as  follows.
#!
#!  A list <surf> with three entries:
#!  * a list of integers, the faces, 
#!  * a list of  pairs of faces making up the edges, 
#!  * a list of  face-paths, one face-path for  each vertex. 
#!  A face-path is a list of on a vertex in the order in which they occur
#!  in the vertex. Note that in this representation it is critical that a 
#!  closed face-path is represented by a list of faces that repeats the 
#!  starting face at the end! That means  the first and last face in the
#!  list of faces for the given face-path **must** be equal, otherwise 
#!  the face-path is assumed to be a path from a face with boundary to 
#!  another face with boundary around a fixed vertex.
#!   Thus the ``face"-description has the form
#!  surf := [ [f1, f2, ..., fn, f1],  [ [f1,f2],...],  [[f1,f2,f3,...],... ];
#!  This is a very simple way of inputting a simplicial surface by just 
#!  reading off the face numbers of each  vertex.
#!
#!
#!  @BeginExample the tetrahedron is represented as
#!    tetra := [ [1..4], [[1,2],[1,3],[1,4],[2,3],[3,4],[2,4]],
#!             [[1,2,3,1], [1,3,4,1],[1,2,4,1],[2,3,4,2]];
#!    WildSimplicialSurfacesFromFacePath(tetra);
#!             where the triple [1,2,3,1] encodes the face path
#!              around one vertex.
#!  @EndExample
#!
#!  @Returns  the list of all wild coloured simplicial surfaces with these 
#!  specifications.
#!  @Arguments a list of lists, representing a ``face"-description of a surface
#! 
InstallGlobalFunction( 
WildSimplicialSurfacesFromFacePath, function(surf)

        local simpsurf, edges, faces, vertices, 
           gens, allsurf, newvertices, vtx;

Print("Warning: Closed paths must repeat starting vertex!!\n");

        faces := ShallowCopy(surf[1]);
        edges := ShallowCopy(surf[2]);
        simpsurf := rec( generators := [],
                          faces := faces,
                          edges := edges );
        vertices := surf[3];

        allsurf := [];

        # Now we test whether the simplicial surface we 
        # have supports a wild colouring.
        for gens in GeneratorsFromEdgesOfSimplicialSurface(edges) do
            newvertices := TestGens( gens, vertices );
            if newvertices <> false then
                for vtx in newvertices do
                    simpsurf := rec( generators := gens,
                                 faces := faces,
                                 edges := edges,
                                 vertices := vtx );
                    Add( allsurf, SimplicialSurface(simpsurf) );
                od;
            fi;
        od;        

        return allsurf;
            
end);

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
GenericSurfaceFromFaceVertexPath := function( fvp )

        local surf, i, j, edges, faces, newfaces, e;

        # The length of fvp is equal to the number of faces
	surf := [,,Length(fvp)];

	faces := [1..Length(fvp)];
        faces := List( faces, i-> Set(Combinations(fvp[i],2)) );
        edges := Union(faces);

        newfaces := List(faces,i->[]);
        for i in [1..Length(fvp)] do
            for j  in [1..3] do
                e := faces[i][j];
                newfaces[i][j] := Position(edges,e);
            od;
        od;

        surf[4] := edges;
        surf[2] := Length(edges);
        surf[1] := Length(Set(Flat(edges)));
        surf[5] := newfaces;

        return surf;
end;

#############################################################################
##
##  Compute the face vertex path description of a generic surface
##
## [v1,v2],  [e1,e2,e3]


FaceVertexPathFromGenericSurface := function( surf )

        local fvp, f, fv, e;

        fvp := [];
        
        for f in surf[5] do
            fv := Set([]);
            for e in f do
                fv := Union(fv, Set( surf[4][e] ) );
            od;
            Add( fvp, fv );
        od;

        return fvp;

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
InstallGlobalFunction( WildSimplicialSurfacesFromGenericSurface, function(surf)
## TODO: Clean up local variables here!
##

        local simpsurf, pair, x, y, edges, faces, vertices, e, f1, f2, e1, e2,
              FaceWithEdges, Faces, Edges, NextFaceEdge, boundary1, j, g,
              fa, i, v, f, vtx, facepairs, incident, gens, allsurf, newvertices;

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
                  od;
                  Add( vertices, vtx);                                  
            fi;
        od;

        allsurf := [];

        # now we see which generating triples we can create from the edges of
        # the surface and see whether any of these can be a wild colouring
        # for the given edges. If the generic surface does not support a 
        # wild colouring, then TestGens will return an empty list.
        for gens in GeneratorsFromEdgesOfSimplicialSurface(simpsurf.edges) do
            edges :=  List( gens, g-> Cycles(g,MovedPoints(gens)));
            edges  := List( edges, e->Filtered( e , c -> Length(c) = 2));
            newvertices := TestGens( gens, vertices );
            for vtx in newvertices do
                simpsurf := rec( generators := gens,
                             faces := faces,
                             edges := edges,
                             vertices := vtx );
                Add( allsurf, SimplicialSurface(simpsurf) );
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
#!   $f'$ are facese of the surface surf such that the edges of $f$ are 
#!   $e_1, e_2$  and $e_3$ and the edges of $f'$ are  $e_1, e_a, e_b$ are 
#!   the edges $e_1, e_2$ and $e_a$ interesct in a common vertex and 
#!   the edges $e_1, e_3$ and $e_b$ interesct in a common vertex.
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

        surf := arg[1];
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
  

      return AllSimplicialSurfaces( cgens, cmrtype );

end);


#############################################################################
##
##
##  A structure of a simplicial surface is a wild colouring where all
##  cycles of a single generator have the same mr-assignment, i.e. all
##  cycles of any one generator are either all mirrors or all reflections.
##  This function returns structures in the input list of simplicial surfaces,
##  i.e. it returns all mmm, mmr, mrr, rrr surfaces, 
##
InstallGlobalFunction( AllStructuresSimplicialSurface, function (allsimpsurf)

        local res, i, ss, mr;

        res :=[];
        for ss in allsimpsurf do
             mr := MrTypeOfSimplicialSurface(ss);
             if 1 in mr[1] and 2 in mr[1] then continue; fi;
             if 1 in mr[2] and 2 in mr[2] then continue; fi;
             if 1 in mr[3] and 2 in mr[3] then continue; fi;

             Add(res,mr);
        od;

        return res;
end);

#############################################################################
##
##
##  This function returns all simplicial surfaces that support a structure.
##  A structure on a simplicial surface is a wild colouring for which all
##  cycles of a single generator are all of the same type: either m or r.
##
##
InstallGlobalFunction( StructuresSimplicialSurface, function (arg)

    local mrtype,  faces, res, ss, gens;

    mrtype := [];

    if Length(arg) = 1 then
        if IsGroup(arg[1]) then gens := GeneratorsOfGroup(arg[1]);         
        else gens := arg[1]; fi;
    elif Length(arg) = 3 then
   	   gens := [arg[1],arg[2],arg[3]];
    fi;
    if not IsList(gens) or Length(gens) <> 3 then
         Error("usage: StructureSimplicialSurface( gens )\n");
    fi;
    if not IsPerm(gens[1]) or not IsPerm(gens[2])
        or not IsPerm(gens[3]) then
         Error("usage: SimplicialSurface( gens )\n");
    fi;
    if gens[1]^2 <> One(gens[1]) or gens[2]^2 <> One(gens[2]) 
        or gens[3]^2 <> One(gens[3]) then
            Error("generators must be involutions\n");
    fi;
    faces := MovedPoints(gens);
    res := [];
   
    # mmm
    mrtype := List( [1..3], i-> List(faces, j-> 1 ));
    ss := AllSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mmm-type"); fi;
    # mmr 
    mrtype :=[];
    mrtype[1] := List(faces,j->1);
    mrtype[2] := List(faces,j->1);
    mrtype[3] := List(faces,j->2);
    ss := AllSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mmr-type"); fi;
    # mrm
    mrtype :=[];
    mrtype[1] := List(faces,j->1);
    mrtype[2] := List(faces,j->2);
    mrtype[3] := List(faces,j->1);
    ss := AllSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mmr-type"); fi;
    # rmm
    mrtype :=[];
    mrtype[1] := List(faces,j->2);
    mrtype[2] := List(faces,j->1);
    mrtype[3] := List(faces,j->1);
    ss := AllSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mmr-type"); fi;
    # mrr
    mrtype :=[];
    mrtype[1] := List(faces,j->1);
    mrtype[2] := List(faces,j->2);
    mrtype[3] := List(faces,j->2);
    ss := AllSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mrr-type"); fi;
    # rmr
    mrtype :=[];
    mrtype[1] := List(faces,j->2);
    mrtype[2] := List(faces,j->1);
    mrtype[3] := List(faces,j->2);
    ss := AllSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mrr-type"); fi;
    # rrm
    mrtype :=[];
    mrtype[1] := List(faces,j->2);
    mrtype[2] := List(faces,j->2);
    mrtype[3] := List(faces,j->1);
    ss := AllSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mrr-type"); fi;
    # rrr
    mrtype := List( [1..3], i-> List(faces, j-> 2 ));
    ss := AllSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one rrr-type"); fi;

    return res;
end);



#############################################################################
##
##
##  map the simplicial surface under the permutation pi which has
##  to  lie in the centraliser of the generators of ss inside the
##  full symmetric group.
##  This now allows us to act with a group on a simplicial surface and
##  call the orbit function
ImageSimplicialSurface := function (ss, pi )
 
        local nss, i, j, vtx, v, nv, vert, cmpvertices;

cmpvertices := function (v1, v2 )

    if Length(v1) < Length(v2 ) then return true;
    elif Length(v1) > Length(v2) then return false;
    fi;
    # now they have the same length
    return v1 < v2;

end;


        nss := rec();

        nss.generators := List(GeneratorsOfSimplicialSurface(ss), g->g^pi);
        nss.faces := List(FacesOfSimplicialSurface(ss),g->g^pi);
        Sort(nss.faces);
        nss.edges := [Cycles(nss.generators[1],nss.faces),
                      Cycles(nss.generators[2],nss.faces),
                      Cycles(nss.generators[3],nss.faces)];

        nss.vertices := [];
        vert := VerticesOfSimplicialSurface(ss);
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
        nss := SimplicialSurface(nss);

        DegreesOfSimplicialSurface(nss);
        MrTypeOfSimplicialSurface(nss);
           

        return nss;

end;

#############################################################################
##
##
##  This code is from Markus Baumeister
##

# Check whether a given vertex ist incident to a given edge
IsIncidentVertexEdge := function(simpsurf,vertexNumber,edgeColor,edgeNumber)
	local vert, edgeType, edges;

    edges := EdgesOfSimplicialSurface(simpsurf);

	for vert in VerticesOfSimplicialSurface(simpsurf)[vertexNumber] do
		for edgeType in [vert[2],vert[3]] do
			if edgeType = edgeColor and 
               vert[1] in edges[edgeColor][edgeNumber] then
				return true;
			fi;
		od;
	od;

	return false;
end;

# Return the vertices (as numbers) that are incident to the given edge
VerticesInEdgeAsNumbers := function( simpsurf, edgeColor, edgeNumber )
	local erg,i;

	erg := [];
	for i in [1..NrOfVerticesOfSimplicialSurface(simpsurf)] do
		if IsIncidentVertexEdge( simpsurf, i, edgeColor, edgeNumber ) then
			erg := Union( erg, [i]);
		fi;
	od;

	return erg;
end;

# Return the vertices (as data in the record) that are incident to 
#  the given edge
VerticesInEdge := function( simpsurf, edgeColor, edgeNumber )
	return List( VerticesInEdgeAsNumbers(simpsurf,edgeColor,edgeNumber), 
                  i-> VerticesOfSimplicialSurface(simpsurf)[i]);
end;


# Convert the simplicial surface data structure to the structure used in 
# maple
# WARNING! It is instrumental at this point (Maple can't handle holes 
# in lists) that the faces are numbered 1,2,...,f
InstallGlobalFunction( GenericSurfaceFromWildSimplicialSurface, 
    function( simpsurf )
	local erg, edges, edgeColor, edgeNumber, pos, faces, faceNumber, 
          edgesInFace, sedges;

	erg := [];

	# First entry is number of vertices
	erg[1] := NrOfVerticesOfSimplicialSurface(simpsurf);
	
	# Second entry is number of edges
	erg[2] := NrOfEdgesOfSimplicialSurface(simpsurf);

	# Third entry is number of faces
	erg[3] := NrOfFacesOfSimplicialSurface(simpsurf);

	# The fourth entry is a list. Each entry of this list corresponds to 
    # an edge and equals a list of the vertices contained in that edge
	edges := [];
    sedges := EdgesOfSimplicialSurface(simpsurf);
	for edgeColor in [1..Length(sedges)] do
		for edgeNumber in [1..Length(sedges[edgeColor])] do
			pos := (edgeColor - 1) * Length( sedges[edgeColor] ) + edgeNumber;
			edges[pos] := VerticesInEdgeAsNumbers(simpsurf,edgeColor,edgeNumber);
		od;
	od;
	erg[4] := edges;

	# The fifth entry is also a list, corresponding to the faces. 
    # Each entry is a list containing the edges of this face
	faces := [];
	for faceNumber in FacesOfSimplicialSurface(simpsurf) do
		edgesInFace := [];
		for edgeColor in [1..Length(sedges)] do
			for edgeNumber in [1..Length(sedges[edgeColor])] do
				if faceNumber in sedges[edgeColor][edgeNumber] then
					pos := (edgeColor - 1) * Length( sedges[edgeColor] ) 
                            + edgeNumber;
					Add( edgesInFace, pos );
				fi;
			od;
		od;
		faces[ faceNumber ] := edgesInFace;
	od;
	erg[5] := faces;

	# WARNING! Both loops use the same convention for converting 
    #  edgeColor and edgeNumber.

	return erg;
end);



# InstallMethod( \^, "for a simplicial surface and a permutation", true, 
#  [ IsSimplicialSurfaceRep, IsPerm ], 0, ImageSimplicialSurface);

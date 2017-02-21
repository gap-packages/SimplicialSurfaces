


InstallGlobalFunction( AllWildSimplicialSurfaces, function(arg)


	local faces, edges, vertices, grp, gens, i, j, k, 
          allvtxnames, completedvertices, nrvtsface, 
          FirstFreeVertex,  FindWildSimplicialSurface, 
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
         Error("usage: AllWildSimplicialSurfaces( gens[, mrtype] )\n");
    fi;
    if not IsPerm(gens[1]) or not IsPerm(gens[2])
        or not IsPerm(gens[3]) then
         Error("usage: AllWildSimplicialSurfaces( gens[, mrtype] )\n");
    fi;
    if gens[1]^2 <> One(gens[1]) or gens[2]^2 <> One(gens[2]) 
        or gens[3]^2 <> One(gens[3]) then
            Error("generators must be involutions\n");
    fi;

    if not IsList(mrtype) or not Length(mrtype) in [0,3] then
            Error("usage: AllWildSimplicialSurfaces( gens[, mrtype] )\n");
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

    FindWildSimplicialSurface := function(level,vertices,completedvertices,nrvtsface)
    
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

            Sort( vertices, cmpvertices );
			ss := rec( faces := MovedPoints(gens),
                edges := edges, vertices := vertices, generators := gens );
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
             FindWildSimplicialSurface(level+1, vertices_c, completedvertices_c, 
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

    FindWildSimplicialSurface( level, [], completedvertices, nrvtsface); 

    return AllSurfaces;

end);

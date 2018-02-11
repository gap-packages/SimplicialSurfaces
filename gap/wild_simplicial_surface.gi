#! @DoNotReadRestOfFile

##############################################################################
##############################################################################
##
##			Start of big (quasi-constructor) methods
##
##
BindGlobal( "__SIMPLICIAL_ConvertWildLegacyIntoModern", 
	function( faces, edgeCycles, vertexPaths, gens )
	
	local nrCycles, edges, edgeColours, facesOfEdges, vertices, 
              edgesOfVertices, FindEdges, surf, init, edgesOfFaces,
              colEdgesOfFaces, col, i, f, totalNrCycles;


        # The edgeCycles are lists of one or two elements
        #   - Two elements represent an inner edge
        #   - One element represents an outer edge
        # In any case - the number of cycles is the number of edges.
        # It is important to note that different colours might have
        # different numbers of corresponding edges.

        # Manual computation to avoid list overhead
        nrCycles := [ Length(edgeCycles[1]), Length(edgeCycles[2]), Length(edgeCycles[3]) ];
        totalNrCycles := nrCycles[1] + nrCycles[2] + nrCycles[3];

	# The faces stay the same

	# The edges will be modified
	edges := [1..totalNrCycles];

	edgeColours := List( [1..nrCycles[1]], i -> 1 );
	Append( edgeColours, List( [1..nrCycles[2]], i -> 2 ) );
	Append( edgeColours, List( [1..nrCycles[3]], i -> 3 ) );

	facesOfEdges := ShallowCopy( edgeCycles[1] );
	Append( facesOfEdges, edgeCycles[2] );
	Append( facesOfEdges, edgeCycles[3] );

        colEdgesOfFaces := [];
        edgesOfFaces := [];
        for f in faces do
            colEdgesOfFaces[f] := [];
            edgesOfFaces[f] := [];
        od;

	for col in [1,2,3] do
		for i in [1..nrCycles[col]] do
			for f in edgeCycles[col][i] do
                            # This is done by if-statements to make it faster
                            if col = 1 then
                                init := 0;
                            elif col = 2 then
                                init := nrCycles[1];
                            else 
                                init := nrCycles[1] + nrCycles[2];
                            fi;
			    colEdgesOfFaces[f][col] := init + i;
                            edgesOfFaces[f] := Union( edgesOfFaces[f], [init + i] );
			od;
		od;
	od;


	# We define the wild simplicial surface before we manage the vertices
	# since we can profit from some code. We only have to be careful to not
	# call any methods that require unknown attributes.
	surf := Objectify( WildSimplicialSurfaceType, rec() );
	SetEdges( surf, edges );
	SetFaces( surf, faces );
	SetFacesOfEdges( surf, facesOfEdges );
        SetEdgesOfFaces( surf, edgesOfFaces );
	SetGenerators( surf, gens );
	SetColoursOfEdges( surf, edgeColours );
	SetColouredEdgesOfFaces( surf, colEdgesOfFaces );


	# The vertices have to be modified
	vertices := [1..Length(vertexPaths)];

	# The function FindEdges returns a set of all edges that are incident to
	# the given vertex
	FindEdges := function( vertexNr )
		local path, edges, possibleEdges, pathElement;

		path := vertexPaths[vertexNr];
		edges := [];

		for pathElement in path do
			possibleEdges := EdgesOfFaces(surf)[pathElement[1]];

			# Now we have to find the edges that conform to the 
                        # colours in pathElement[2] and pathElement[3]
			Append( edges, 
                            # Don't use the corresponding method to avoid overhead
                            [ colEdgesOfFaces[pathElement[1]][pathElement[2]],
                                colEdgesOfFaces[pathElement[1]][pathElement[3]] ]);
		od;

		return Set(edges);
	end;

	edgesOfVertices := List( vertices, i -> FindEdges(i) );


	# We have to set the final attributes
	SetVerticesAttributeOfSimplicialSurface( surf, vertices );
	SetEdgesOfVertices( surf, edgesOfVertices );

	DeriveLocalOrientationAndFaceNamesFromIncidenceGeometryNC(surf);

	return surf;
end);


InstallOtherMethod( AllWildSimplicialSurfaces, 
	"for three involutions",
	[ IsPerm, IsPerm, IsPerm ], function( perm1, perm2, perm3 )
		return AllWildSimplicialSurfaces( perm1, perm2, perm3 , [] );
	end
);

InstallOtherMethod( AllWildSimplicialSurfaces, 
	"for three involutions and a list that encodes the edge-types",
	[ IsPerm, IsPerm, IsPerm, IsList ], function( perm1, perm2, perm3, mrtype )
		return AllWildSimplicialSurfaces( [perm1, perm2, perm3], mrtype );
	end
);

InstallOtherMethod( AllWildSimplicialSurfaces, 
	"for a group",
	[ IsGroup ], function( grp )
		return AllWildSimplicialSurfaces( grp, [] );
	end
);

InstallOtherMethod( AllWildSimplicialSurfaces, 
	"for a group and a list that encodes the edge-types",
	[ IsGroup, IsList ], function( grp, mrtype )
		return AllWildSimplicialSurfaces( GeneratorsOfGroup(grp), mrtype );
	end
);


InstallOtherMethod( AllWildSimplicialSurfaces, 
	"for a list of three involutions",
	[ IsList ], function( gens )
		return AllWildSimplicialSurfaces( gens, [] );
	end
);

BindGlobal( "__SIMPLICIAL_CheckGeneratorsAndMRType",
	function( gens, mrtype )
		if Length(gens) <> 3 then
         Error("__SIMPLICIAL_CheckGeneratorsAndMRType: There have to be three generators given.\n");
		fi;
		if not IsPerm(gens[1]) or not IsPerm(gens[2]) or not IsPerm(gens[3]) then
		     Error("__SIMPLICIAL_CheckGeneratorsAndMRType: The generators have to be permutations.\n");
		fi;
		if gens[1]^2 <> One(gens[1]) or gens[2]^2 <> One(gens[2]) 
		    or gens[3]^2 <> One(gens[3]) then
		     Error("__SIMPLICIAL_CheckGeneratorsAndMRType: The generators have to be involutions.\n");
		fi;

		if not Length(mrtype) in [0,3] then
		     Error("__SIMPLICIAL_CheckGeneratorsAndMRType: The edge types have to be given as a list with up to three elements.\n");
		fi;
	end
);


InstallMethod( AllWildSimplicialSurfaces, 
	"for a list of three involutions and a list that encodes the edge-types", 
    [IsList, IsList], function(gens, mrtype)

	local faces, edges, vertices, grp, i, j, k, 
          allvtxnames, completedvertices, nrvtsface, 
          FirstFreeVertex,  FindWildSimplicialSurface, 
          AllSurfaces, level, n, allvertices, IsMirror, IsRotation,  
          LoopOneVertexSignedWithBoundary,  faceinverse,
          BreakPoint,         knownmrtype, cmpvertices;

	# Check whether the given arguments are correct
	__SIMPLICIAL_CheckGeneratorsAndMRType(gens,mrtype);

        # Catch the case of gens = [ (), (), () ]
        if gens = [ (), (), () ] then
            return [ WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring(
                [],[],[],[],[],[]),
                WildSimplicialSurfaceByDownwardIncidenceAndEdgeColouring(
                3,3,1,[[1,2],[2,3],[1,3]],[[1,2,3]],[1,2,3] ) ];
        fi;


	# Start the actual computations

	cmpvertices := function (v1, v2 )

		if Length(v1) < Length(v2 ) then return true;
		elif Length(v1) > Length(v2) then return false;
		fi;
		# now they have the same length
		return v1 < v2;

	end;


    BreakPoint := false;
    faces := ShallowCopy(MovedPoints(gens)); # is a set, therefore sorted
    n := Length(faces);
    faceinverse := List([1..n],i->0);

    # store the position of face in in faces to avoid searching
    for i in faces do
        faceinverse[i] := Position(faces,i);
    od;

#
#    for i in [ 1 .. 3] do
#        for j in [i+1 .. 3] do
#            if NrMovedPointsPerm( gens[i] * gens[j] ) <> n then
#                Print("Warning: Simplicial surface not vertex faithful\n");
#            fi;
#        od;
#    od;
 

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

    # now  we know that the simplicial surface is vertex faithful
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
    # names. A vertex is described by all triples (i,a,b) such a<b and
    # that the vertex is adjacent to face i and has edges in gens[a] and gens[b].
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
    #knownfaces = List(vtxnames, i -> i[1]);
    LoopOneVertexSignedWithBoundary :=
            function(vtx,g,vtxnames, knownfaces,completedvertices,nrvtsface)
            local  h, fac, i, j, pj, k, x,  nvtx, nvtxnames,
                   vtxnames_c, completedvertices_c, nrvtsface_c, poss, knownfaces_c;

            # all already known names for this vertex 
            # - known to be valid up to here
            # all already known faces incident to this vertex
            #knownfaces := List(vtxnames, i-> i[1]); # too slow

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
                    knownfaces_c := ShallowCopy(knownfaces);
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
                        Add( knownfaces_c, [j] );
#                        k := Position(allvertices,[j,g,h]); # slow code
                        k := (faceinverse[j]-1)*3 + (g-1)*2 + h-g;
                    else
                        Add( vtxnames_c, [j,h,g] );
                        Add( knownfaces_c, [j] );
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
                    LoopOneVertexSignedWithBoundary(nvtx, h,vtxnames_c, knownfaces_c,
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
		   # we now have to check if we arrived with the
		   # correct mrtype, if that is set.
                   if g <> vtxnames[1][2] and g <> vtxnames[1][3] then
                       # we did not end up where we started with g
                       return;
                   else 
                       k  := Length(vtxnames);
			
                       if k > 0 then
                            if   mrtype[g][faceinverse[j]]=2 and
                            vtxnames[k]{[2,3]}= vtxnames[1]{[2,3]} then
                               # g should be a rotation but is a mirror
#			       Error("surface closed with incorrect mirror");
                               return;
                            elif    mrtype[g][faceinverse[j]]=1 and
		            vtxnames[k]{[2,3]} <> vtxnames[1]{[2,3]} then
                               # g should be a mirror but is a rotation
#			       Error("surface closed with incorrect rotation");
                               return;
                            fi;
                       fi;

                       # we are at the start so add 
                       # but let the vertex start with smallest face
# Since we changed the primary data structure, this sorting is unnecessary
#                       if vtxnames[1]<>Minimum(vtxnames) then
#                            k := Position(vtxnames,Minimum(vtxnames));
#                            nvtxnames := vtxnames{[k..Length(vtxnames)]};
#                            Append(nvtxnames, vtxnames{[1..k-1]});
#                            vtxnames := nvtxnames;
#                       fi;
                       Add(allvtxnames,[vtxnames,completedvertices,nrvtsface]);
#		Print ("vertex closed correctly");
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
			ss := __SIMPLICIAL_ConvertWildLegacyIntoModern( faces, edges, 
															vertices, gens );
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
        LoopOneVertexSignedWithBoundary(vtx,g,vtxEquivalentnames, [i],
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


############################################################################
##
##
##  A structure of a simplicial surface is a wild colouring where all
##  cycles of a single generator have the same mr-assignment, i.e. all
##  cycles of any one generator are either all mirrors or all reflections.
##  This function returns structures in the input list of simplicial 
##  surfaces, i.e. it returns all mmm, mmr, mrr, rrr surfaces, 
##
InstallMethod( FilteredStructuresWildSimplicialSurface, 
	"for a list of wild simplicial surfaces", [IsList],
	function (allsimpsurf)
            return Filtered(allsimpsurf, IsSurfaceWithStructure);
	end
);


InstallMethod( ImageWildSimplicialSurface, 
    "for a simplicial surface and a permutation", 
    [IsWildSimplicialSurface, IsPerm ], function( surface, perm )
        local newFacesOfEdges, newNamesOfFaces, 
            newLocalOrientationByEdgesAsPerm, surf;

        # We define the action on the faces as follows (with the intent of
        # fixing vertices and edges):
        # - Change FacesOfEdges (simple application of permutation)
        # - EdgesOfVertices stays fixed
        # - Move NamesOfFaces (permute the indices)
        # - Move LocalOrientation
        newFacesOfEdges := OnTuplesSets( FacesOfEdges(surface), perm );
        newNamesOfFaces := Permuted( NamesOfFaces(surface), perm );
        newLocalOrientationByEdgesAsPerm := Permuted(
            LocalOrientationByEdgesAsPerm(surface), perm );

        surf := Objectify( WildSimplicialSurfaceType, rec() );
        SetVerticesAttributeOfSimplicialSurface( surf, Vertices(surface) );
        SetEdges( surf, Edges(surface) );
        SetFaces( surf, Faces(surface) );
        SetEdgesOfVertices( surf, EdgesOfVertices(surface) );
        SetFacesOfEdges( surf, newFacesOfEdges );
        SetNamesOfFaces( surf, newNamesOfFaces );
        SetLocalOrientationByEdgesAsPerm( surf, newLocalOrientationByEdgesAsPerm );
        SetColoursOfEdges( surf, ColoursOfEdges(surface) );

        return surf;
    end
);



#############################################################################
##
##
##  This function returns all simplicial surfaces that support a structure.
##  A structure on a simplicial surface is a wild colouring for which all
##  cycles of a single generator are all of the same type: either m or r.
##
##
InstallOtherMethod( AllStructuresWildSimplicialSurfaces, "for a group", 
	[IsGroup], function( grp )
		return AllStructuresWildSimplicialSurfaces( GeneratorsOfGroup(grp) );
	end
);

InstallOtherMethod( AllStructuresWildSimplicialSurfaces, "for three involutions", 
	[IsPerm, IsPerm, IsPerm], function( p1,p2,p3 )
		return AllStructuresWildSimplicialSurfaces( [p1,p2,p3] );
	end
);

InstallMethod( AllStructuresWildSimplicialSurfaces, 
	"for a list of three involutions", [IsList],  function (gens)

    local mrtype,  faces, res, ss;

    mrtype := [];

	# Check the generators
	__SIMPLICIAL_CheckGeneratorsAndMRType( gens, [] );

    faces := MovedPoints(gens);
    res := [];
   
    # mmm
    mrtype := List( [1..3], i-> List(faces, j-> 1 ));
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mmm-type"); fi;
    # mmr 
    mrtype :=[];
    mrtype[1] := List(faces,j->1);
    mrtype[2] := List(faces,j->1);
    mrtype[3] := List(faces,j->2);
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mmr-type"); fi;
    # mrm
    mrtype :=[];
    mrtype[1] := List(faces,j->1);
    mrtype[2] := List(faces,j->2);
    mrtype[3] := List(faces,j->1);
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mmr-type"); fi;
    # rmm
    mrtype :=[];
    mrtype[1] := List(faces,j->2);
    mrtype[2] := List(faces,j->1);
    mrtype[3] := List(faces,j->1);
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mmr-type"); fi;
    # mrr
    mrtype :=[];
    mrtype[1] := List(faces,j->1);
    mrtype[2] := List(faces,j->2);
    mrtype[3] := List(faces,j->2);
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mrr-type"); fi;
    # rmr
    mrtype :=[];
    mrtype[1] := List(faces,j->2);
    mrtype[2] := List(faces,j->1);
    mrtype[3] := List(faces,j->2);
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mrr-type"); fi;
    # rrm
    mrtype :=[];
    mrtype[1] := List(faces,j->2);
    mrtype[2] := List(faces,j->2);
    mrtype[3] := List(faces,j->1);
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one mrr-type"); fi;
    # rrr
    mrtype := List( [1..3], i-> List(faces, j-> 2 ));
    ss := AllWildSimplicialSurfaces( gens, mrtype);
    if Length(ss) > 0 then Add(res, ss[1]); fi;
    if Length(ss) >  1 then Error("more than one rrr-type"); fi;

    return res;
end);



#############################################################################
##
#!  @Description
#!  This function takes as input a list of pairs of integers. Suppose the
#!  integers occurring in this list of pairs is the set of faces. Then this
#!  function computes all triples of involutions acting on the set faces.
#!  @Returns a list of lists, which are involution triples.
#!  @Arguments a list of lists, which is a list of pairs of integers
#!
InstallMethod( GeneratorsFromFacePairs, "List of integer pairs", [IsList],
      function( facepairs )

        local gens, g, i,  cycs, cycs_c, gens_c, faces, fixedpoints_c, c,
              AllGenSets, NextFace, fixedpoints, IsEligible, check;

        if Length(facepairs) = 0 then return [ (), (), () ]; fi;
        check := Filtered( facepairs, i-> not IsList(i) or 
                           not Length(i) in [1,2] or not IsPosInt(i[1]) or 
                           Size( Filtered(i, j-> not IsPosInt(j)) ) > 0 );
        if Length(check)<> 0 then 
            Error("GeneratorsFromFacePairs: ", 
                  "input not a list of pairs of positive integers");
        fi;

        facepairs := Compacted(facepairs);
        faces := Set( Flat(facepairs) );
        
        cycs := ShallowCopy(facepairs);

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

# Given a list of generators and a face-edge-path this function calculates 
# all EdgesOfColours that are compatible with this path.
BindGlobal("__SIMPLICIAL_EdgeColoursFromFaceEdgePath", function(gens, path)

        local edgesOfColours, i, CheckTransitions;
        
        edgesOfColours := [ List( gens, g -> [] ) ];

        # face1 and face2 are connected via edge.
        # If a generator moves face1 to face2, the edge will be counted
        # as an edge of this colour. Otherwise return fail.
        CheckTransitions := function( face1, face2, edge )
            local newEdgeCol, found, i, edgeCol, newEdgesOfColours;

            newEdgesOfColours := [];
            found := false;
            for i in [1..Length(gens)] do
                if face1^gens[i] = face2 then
                    found := true;
                    for edgeCol in edgesOfColours do
                        newEdgeCol := ShallowCopy(edgeCol);
                        newEdgeCol[i] := Union( newEdgeCol[i], [edge] );
                        Add( newEdgesOfColours, newEdgeCol );
                    od;
                fi;
            od;
            if not found then
                return fail;
            fi;

            return newEdgesOfColours;
        end;

        if IsEvenInt( Length(path) ) then
            # Closed path
            edgesOfColours := CheckTransitions( path[2], path[Length(path)], path[1] );
            if edgesOfColours = fail then
                return [];
            fi;
            for i in [2,4..Length(path)-2] do
                edgesOfColours := CheckTransitions( path[i], path[i+2], path[i+1] );
                if edgesOfColours = fail then
                    return [];
                fi;
            od;
        else
            # Open path
            edgesOfColours := CheckTransitions( path[2], path[2], path[1] );
            if edgesOfColours = fail then
                return [];
            fi;

            edgesOfColours := CheckTransitions( path[ Length(path)-1 ], path[ Length(path) - 1], path[ Length(path) ] );
            if edgesOfColours = fail then
                return [];
            fi;

            for i in [2,4..Length(path)-3] do
                edgesOfColours := CheckTransitions( path[i], path[i+2], path[i+1] );
                if edgesOfColours = fail then
                    return [];
                fi;
            od;
        fi;

        return edgesOfColours;
    end
);


# auxilliary function
# v is a face-path and gens a list of generators
# return a list with all coloured face-edge-paths that are compatible with these generators
BindGlobal("__SIMPLICIAL_ColouredFaceEdgePathsFromFacePath",function( gens, v )

    local  walks, g, w, i, j, nw, newwalks;


    walks := [[]];
    if v[Length(v)] <> v[1] then
        # transversing face edge path (see paper)
        g := Filtered( gens, j-> v[1]^j=v[1] );
        if g=[] then return []; fi;
        walks := List(g, i-> [Position(gens,i),v[1]]);
        for i in [1..Length(v)-1] do
            # g will contain all perms with cycle (v[i], v[i+1])
            g := Filtered( gens, j-> v[i]^j=v[i+1] );
            if g = [] then return []; fi;
            newwalks := [];
            # loop through all partial walks w and
            # define |g| new walks by adding the elements
            # of g to w
            for w in walks do
                for j in g do
                    nw := ShallowCopy(w);
                    Append(nw,[Position(gens,j),v[i+1]]);
                    Add(newwalks, nw );
                od;
            od;
            walks := newwalks;
        od;
        i := Length(v);
        g := Filtered( gens, j-> v[i]^j=v[i] );
        if g = [] then return []; fi;
        newwalks := [];
        # loop through all partial walks w and
        # define |g| new walks by adding the elements
        # of g to w
        for w in walks do
            for j in g do
                nw := ShallowCopy(w);
                Add(nw,Position(gens,j));
                Add(newwalks, nw );
             od;
        od;
        walks := newwalks;

    else
        # closed face path (repeating starting face at the end)
        for i in [1..Length(v)-1] do
                g := Filtered( gens, j-> v[i]^j=v[i+1] );
                if g = [] then return []; fi;
                newwalks := [];
                # loop through all partial walks w and
                # define |g| new walks by adding the elements
                # of g to w
                for w in walks do
                    for j in g do
                        nw := ShallowCopy(w);
                        Append(nw,[Position(gens,j),v[i+1]]);
                        Add(newwalks, nw );
                    od;
                od;
                walks := newwalks;
        od;
        if Length(v) = 3 then
            # we have to check in this case that we use different
            # permutations, e.g. that 1a2a1 does not occur
            walks := Filtered( walks, w -> w[1] <> w[3] );
        fi;
    fi;

    return walks;
end);

BindGlobal("__SIMPLICIAL_TestGeneratorsForFaceEdgePaths", function(gens, paths)
    local p, i, edgeCols, allColours, g, cart, colourSnippets, 
        boundedPositions, MakeHoles, possColours;
 
    cart := [];
    allColours := [];
    for p in paths do
        edgeCols := __SIMPLICIAL_EdgeColoursFromFaceEdgePath(gens, p);
        if edgeCols = [] then 
            Print("path ", p, " is inconsistent with generators", gens, "\n");
            return []; 
        else
            Add(allColours,edgeCols);
            Add( cart, [1..Length(edgeCols)]);
        fi;
    od;
    cart := Cartesian(cart);
    # Combine all lists of colours in the following fashion:
    # One colour setting around the first vertex, one colour setting around
    # the second vertex, etc,
    colourSnippets := List(cart,l->List([1..Length(l)],i->allColours[i][l[i]]));

    # Combine the snippets into complete edgeColourings
    possColours := List( colourSnippets, snipp -> # for each local colour combination
            List( [1..Length(gens)], i -> # construct a list of three lists
                    Set(Concatenation( # TODO We do this since Union does not work
                    ( List( [1..Length(snipp)], nr -> snipp[nr][i] ) ) ) ) ));


    # Check whether the edge colouring is consistent
    return Filtered( possColours, poss -> 
        Length( Intersection( poss[1], poss[2] ) ) = 0 and
        Length( Intersection( poss[1], poss[3] ) ) = 0 and
        Length( Intersection( poss[2], poss[3] )) = 0 );

end);

##  auxilliary function
## Test whether the generators match up with a list of face-paths (for
## each vertex one path is given). DON'T confuse them with face-edge-paths
BindGlobal("__SIMPLICIAL_TestGens", function(gens, paths)

            local v, i, vtx, allvertices, g, cart, colouredPaths,
            boundedPositions, MakeHoles;
 

            cart := [];
            allvertices := [];
            for v in paths do
                  vtx := __SIMPLICIAL_ColouredFaceEdgePathsFromFacePath(gens, v);
                  if vtx = [] then 
                      Print("vertex ", v, " without face-edge-path");
                      return []; 
                  else
                      Add(allvertices,vtx);
                      Add( cart, [1..Length(vtx)]);
                  fi;
            od;
            cart := Cartesian(cart);
            # Combine all lists of walks in the following fashion:
            # One walk around the first vertex, one walk around the second
            # vertex, etc,
            colouredPaths := List(cart,l->List([1..Length(l)],i->allvertices[i][l[i]]));

            boundedPositions := BoundPositions(paths);


            MakeHoles := function( path )
              local pathWithHoles,i;

              pathWithHoles := [];
              for i in [1..Length(boundedPositions)] do
                  pathWithHoles[boundedPositions[i]] := path[i];
              od;

              return pathWithHoles;
           end;
           
           return List( colouredPaths, MakeHoles );
 end);



InstallMethod( AllWildSimplicialSurfacesFromFacePath, 
"List of integers, List of pairs of integers, List of face paths",
[IsList,IsList,IsList], function(faces, edges, facepaths)

        local simpsurf, gens, allsurf, newvertices, vtx;

Print("Warning: Closed paths must repeat starting vertex!!\n");
        for vtx in facepaths do
            if vtx[1] <> vtx[Length(vtx)] then
	        if Length(vtx) <> Length(Set(vtx)) then
	       	    Error("WildSimplicialSurfacesFromFacePath: ",
                        "Facepaths can't repeat faces except at the end.");
                fi;		  
            else
                if Length(vtx)-1 <> Length(Set(vtx)) then
	       	    Error("WildSimplicialSurfacesFromFacePath: ",
                        "Facepaths can't repeat faces except at the end.");
                fi;
            fi;		  
        od;

        faces := ShallowCopy(faces);
        allsurf := [];

         
        # Now we test whether the simplicial surface we 
        # have supports a wild colouring.
        for gens in GeneratorsFromFacePairs(edges) do
            newvertices := __SIMPLICIAL_TestGens( gens, facepaths );
            for vtx in newvertices do
                if vtx <> [] then
                   # This method does not use generators or edges
                    simpsurf := WildSimplicialSurfaceByColouredFaceEdgePaths(
                                [1..Length(vtx)],faces,vtx);
                    Add( allsurf, simpsurf);
                fi;
            od;
        od;        

        return allsurf;
            
end);


## Implementation of double cover
InstallMethod(DoubleCover, "of a wild simplicial surface", 
    [IsWildSimplicialSurface], function( wild )
        local N, MapCycle, all, type, newMRType, newGens, mr, gen,
            edges, adFaces, e, i, f;

        N := Maximum(Faces(wild));

        # We need a function to convert each cycle of the involutions into
        # two cycles of the double cover
        # To do so, we replace a mirror (i,j) by (i,-j)(-i,j) and a
        # rotation (i,j) by (i,j)(-i,-j), where -x := x + N (since GAP can't
        # use negative numbers in permutations)
            
        MapCycle := function( cycle, type )
            local i,j;

            # If we have a border, it will be connected to its inverse
            if type = 0 then
                return (cycle[1], cycle[1]+N);
            fi;

            i := cycle[1];
            j := cycle[2];
            if type = 1 then # mirror
                return (i,j+N)(i+N,j);
            elif type = 2 then # rotation
                return (i,j)(i+N,j+N);
            fi;

            # We should never reach this point
            Error("Internal Error in DoubleCover, MapCycle: Invalid MR-assignment.");
        end;

        newMRType := [];
        newGens := [];
        for i in [1,2,3] do
            edges := EdgesOfColour(wild, i);
            mr := [];
            gen := ();
            for e in edges do
                adFaces := FacesOfEdges(wild)[e];
                type := MRTypeOfEdgesAsNumbers(wild)[e];
                gen := gen * MapCycle(adFaces, type);
                
                for f in adFaces do
                    mr[f] := type;
                    mr[f+N] := type;
                od;
            od;
            newMRType[i] := mr;
            newGens[i] := gen;
        od;


        # TODO is this unique??
        all := AllWildSimplicialSurfaces( newGens, newMRType);
        if Size(all) <> 1 then
            Error("DoubleCover: There is not exactly one double cover. Please contact the package administrators.");
        fi;
        return all[1];

    end
);

##
##
##		End of big (quasi-constructor) methods
##
##############################################################################
##############################################################################



#############################################################################
##
##  A Display method for simplicial surfaces
##
InstallMethod( Display, "for WildSimplicialSurfaces", [IsWildSimplicialSurface],
	function(simpsurf)
        local vtx, e, i, gens, f, mr, path, l;

        gens :=  Generators(simpsurf);
        Print("Generators = \n");
        f := Faces(simpsurf);

        for i in [ 1.. Length(gens) ] do
           e :=   Cycles(gens[i],f);
           Print( gens[i], "\n");
           mr := Filtered( e, c -> 
		MRTypeOfEdgesAsNumbers( simpsurf )[ 
			EdgeByFacesAndColour( simpsurf, c, i ) ] = 1 );
           Print("    mirrors  ", mr, "\n" );
           mr := Filtered( e, c -> 
		MRTypeOfEdgesAsNumbers( simpsurf )[ 
			EdgeByFacesAndColour( simpsurf, c, i ) ] = 2 );
           Print("    rotations ", mr, "\n" );
        od;
        
        Print("Faces = ", Faces(simpsurf), "\n");
        #e := Filtered( e , c -> Length(c) = 2);
        #Print("Edges = ", EdgesOfWildSimplicialSurface(simpsurf), "\n");

        Print("Vertices = \n");
        for vtx in Vertices(simpsurf) do
            Print("    " );
            path := ColouredFaceEdgePathOfVertex( simpsurf, vtx ); 
            l := Length(path);
            if IsOddInt(l) then Print("|"); fi;
            for i in [1..l] do
                if IsEvenInt(i) then Print(path[i]); 
                elif path[i]=1 then Print("a"); 
                elif path[i]=2 then Print("b"); 
                elif path[i]=3 then Print("c"); 
                else Error("Display: unknown entry in path");
                fi;
            od;
            if IsOddInt(l) then Print("|"); fi;
	    Print("\n");
        od;
 
        Print("Degrees = ", UnsortedDegrees(simpsurf) );
	end
);


#!	@Description
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
RedispatchOnCondition( SixFoldCover, true, [IsSimplicialSurface,IsList], 
    [IsEdgesLikeSurface and IsTriangleSurface,], 0  );
InstallMethod( SixFoldCover, "for a simplicial surface",
	[IsSimplicialSurface and IsEdgesLikeSurface and IsTriangleSurface, IsList],
	function(simpsurf, mrtype)

      local  i, e, j, ind1, ind2,f, wild,
                   cfaces, cgens, cf, img, FacesL,
                   neigh, e1, e2, Vertex, IsIncident,
                   f1, f2, sigi, cmrtype, sigtype, IsMirror,
                   arrange, otherIndices, remed, altNames;

               

      Vertex := function(e)
          return VerticesOfEdges(simpsurf)[e];
      end;

      # returns true if the edges e1, e2, e3 incident to a common vertex
      # and false else
      IsIncident := function(e1, e2, e3)

          local inter;

          inter := Intersection(Vertex(e1), Vertex(e2));
          if Size(Intersection( inter, Vertex(e3) ) ) > 0 then
              return true;
          fi;
          return false;
      end;

      # Find the faces incident to e
      FacesL := function(e)
                return FacesOfEdges(simpsurf)[e];
      end;



        # sigtype true means we are looking for  a structure
	# such that the permutation sigma_i has mr-type mrtype[i]
        sigtype := true;              
#        if Length(arg) = 2 then
#            mrtype := arg[2]; sigtype := true; 
            # the mrtype specifies the sigma_i
            if Length(mrtype) > 3 then 
                Error("SixFoldCover( <surf>[, <mrtype>, <bool>] )");
                return;
            fi;
#        elif  Length(arg) = 1 then
#            sigtype := true; # the mrtype specifies 
#            mrtype := List( [1,2,3], i-> 1 ); 
            # the default is to reflect at every position
#        else #length of arg is 3
#            mrtype := arg[2]; sigtype := arg[3];
#        fi;


        # returns true if the edge $(k, \sigma_i(k))$ should be a mirror
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
      # faces are given by the three edges incident to the face
      # Arrangements( [1,2,3], 3) are the images of the map beta in
      # definition of six-fold cover 
      #cfaces := Cartesian( Faces(simpsurf), Arrangements( [1,2,3], 3 ) );
      cfaces := [];
      for f in Faces(simpsurf) do
          Append( cfaces, List( Arrangements( EdgesOfFaces(simpsurf)[f], 3),
          a-> [f,a] ));
      od;

      # record the mrtype of the cover
      # store for every colour in [1,2,3] whether face F under
      # the permutation of that colour is a mirror or a rotation
      cmrtype := List( [1..3], j->List( cfaces, i-> 0 ));

      # now we have to compute the edges
      # Starting from (f,(e_x, e_y, e_z)) the generator sigma_1
      # maps (f,(e_x, e_y, e_z)) to (f,(e_x, e_y, e_z)) if $e_x$ is a
      # boundary edge and to (g,(e_x, e_u, e_v)) if $e_x$ is an inner
      # edge such that (f,g) are the two faces incident to e_x and
      # e_y, e_u, e_x are incident to a common vertex and
      # e_z, e_v, e_x are incident to a common vertex, if
      # (f,g) is a mirror-cycle of sigma_1 and
      # to (g,(e_x, e_v, e_u)) otherwise.

      cgens := [];
      for i in [1..3]  do
          sigi := []; # define generator sigma_i
          for j  in [1..Length(cfaces)] do
              cf := cfaces[j]; # work out the image of cf under sigi
              # e.g. cf = [1, [2, 3, 1]] means face 1, edges 2,3,1
              # if i=2 we have to map along the edge in position 2 (i.e. 3)
              # and need to find the neighbour of cf along this edge
              # cf[2][k] is the edge  along which to map
#	      k := cf[2],i);
	      # the face numbers of  the neighbouring faces
              neigh := FacesL(cf[2][i]); 
                                    
              if not cf[1] in neigh then
                  Error("cannot find neighbour of face ", cf, "\n");
              fi;
              neigh := Difference(neigh, [cf[1]] );
              if Length(neigh)=0 then
                  img := ShallowCopy(cf); # boundary edge
              else
                  neigh := neigh[1]; # the face number of the neighbour
                  img := [neigh];
                  e := EdgesOfFaces(simpsurf)[neigh]; # the edges of neigh
		  arrange := [];
		  arrange[i] := cf[2][i]; # this edge remains fixed

                  remed := Difference( e, [cf[2][i]] );
                  if Length(remed) <> 2 then Error("no matching edges"); fi;

                #
		#                 /|\
		#                / | \
		#               /  |  \
		#              e1  |   f1
		#             /    |    \
		#             \    |    /
		#              e2  |   f2
		#               \  |  /
		#                \ | /
		#                 \|/
		otherIndices := Difference([1,2,3], [i]); 
		ind1 := otherIndices[1];
		ind2 := otherIndices[2];

                e1 := cf[2][ind1];
                e2 := cf[2][ind2];

                if IsIncident( e1, cf[2][i], remed[1]) then
                  f1 := remed[1];
                  f2 := remed[2];
                else
                  f1 := remed[2];
                  f2 := remed[1];
                fi;

                if IsMirror(cf[2][i],i) then
                       # \sigma_i is mirror
                       arrange[ind1] := f1;
                       arrange[ind2] := f2;

                       cmrtype[i][j] := 1;
                else
                      # rotation
                      arrange[ind1] := f2;
                      arrange[ind2] := f1;

                      cmrtype[i][j] := 2;
                fi;
		
                img[2] := arrange;
                sigi[j] := Position( cfaces, img );
             fi;
          od;

          if PermList(sigi) = fail then 
              Info( InfoSimplicial, 1, "Surface does not exist");
              Error("Internal Error (SixfoldCover): No permutation defined.");
              return false;
          fi;
          Add( cgens, PermList(sigi) );
      od;
  
      wild := AllWildSimplicialSurfaces( cgens, cmrtype );
      if Size(wild) <> 1 then
        Error("Internal: SixfoldCover is not unique.");
      fi;

      # Set the alternative names
      altNames := rec( Faces := cfaces,
        Description := "[oldFace, [vertices of the oldFace]]");
      SetAlternativeNames( wild[1], rec( SixFoldCover := altNames ) );
      
      return wild[1];
  end
);

InstallOtherMethod( SixFoldCover, "for a simplicial surface",
	[IsSimplicialSurface],
	function( simpsurf )
		return SixFoldCover(simpsurf, [1,1,1]);
	end
);
RedispatchOnCondition( SixFoldCover, true, [IsSimplicialSurface], 
    [IsEdgesLikeSurface and IsTriangleSurface], 0  );


############################################################################
############################################################################
##
##			Start of more specialized methods from SimplicialSurface
##

##
##	Check connectivity
##
InstallMethod( IsConnected, "for a wild simplicial surface",
	[IsWildSimplicialSurface],
	function(simpsurf)
		return Length( Orbits( GroupOfWildSimplicialSurface(simpsurf), 
									Faces(simpsurf) ) ) = 1;
	end
);

##
##	Check orientability
##
#TODO how should be handle the assumption of connectivity?
InstallMethod( IsOrientable, "for a wild simplicial surface", true, 
	[ IsWildSimplicialSurface and IsPathConnected], 0,
        function(simpsurf)

        local gens, newgens, i, mrtype, MapCycle, orb, N;


        N:= Maximum(Faces(simpsurf));


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

        gens := Generators(simpsurf);
        newgens := List( gens, i-> Cycles(i, Faces(simpsurf)));


        mrtype := MRTypeOfEdgesAsNumbers(simpsurf);

        for i in [ 1 .. 3 ] do
            newgens[i] := List( newgens[i], 
                    c -> MapCycle(c,mrtype[EdgeByFacesAndColourNC(simpsurf,c,i)]));
            newgens[i] := Product( newgens[i] );
        od;

        orb := Orbits(Group(newgens));

        if Length(orb) = 1 then
            return false;
        elif Length(orb) = 2 then
            return true;
        fi;
        Error("IsOrientable: unknown orientability of wild simplicial surface");

	end
);


##
##	Snipp off ears
##
InstallMethod( SnippOffEars, "for a wild simplicial surface",
	[IsWildSimplicialSurface],
	function(simpsurf)
		local snippSimp, newColours, edge;

		# Use the method for general simplicial surfaces
		snippSimp := __SIMPLICIAL_SnippOffEarsOfSimplicialSurface(simpsurf);

		# Add the appropriate colours
		newColours := ShallowCopy( ColoursOfEdges( simpsurf ) );
		for edge in Edges(simpsurf) do
			if not edge in Edges(snippSimp) then
				Unbind( newColours[edge] );
			fi;
		od;

		return WildSimplicialSurfaceExtensionByEdgeColouringNC( snippSimp, 
															newColours );
	end
);



##
##			End of more specialized methods from SimplicialSurface
##
############################################################################
############################################################################


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
InstallOtherMethod( AllWildSimplicialSurfaces,"",[IsSimplicialSurface and IsActualSurface], function(surface)

    local gens, newcolours, wild, edgeColours, allsurf, edgesOfFaces;

        allsurf := [];

        # now we see which generating triples we can create from the edges of
        # the surface and see whether any of these can be a wild colouring
        # for the given edges. If the generic surface does not support a 
        # wild colouring, then TestGens will return an empty list.
        for gens in GeneratorsFromFacePairs( FacesOfEdges(surface) ) do
            newcolours := __SIMPLICIAL_TestGeneratorsForFaceEdgePaths( gens, List( FaceEdgePathsOfVertices(surface), i -> i[1] ) );
            # These are colours that match locally at the vertices.
            # The edge colouring of an ear might not have worked
            if not IsClosedSurface(surface) then
                edgesOfFaces := EdgesOfFaces(surface);
                newcolours := Filtered( newcolours, poss ->
                    ForAll( Faces(surface), f -> 
                        Size(Intersection(edgesOfFaces[f], poss[1]))=1 and
                        Size(Intersection(edgesOfFaces[f], poss[2]))=1 and
                        Size(Intersection(edgesOfFaces[f], poss[3]))=1 ));
            fi;
            # All coloured face-edge-paths with these generators
            for edgeColours in newcolours do
                if edgeColours <> [] then
                    if Union(edgeColours) <> Edges(surface)  then
                        Error("AllWildSimplicialSurfaces from SimplicialSurface: Internal error");
                    fi; #TODO make the internal checks only work with info-level 2

		    wild := ObjectifySimplicialSurface( 
		        WildSimplicialSurfaceType, rec(), surface);
                    SetEdgesOfColours(wild,edgeColours);

                    Add( allsurf, wild);
                fi;
            od;
 
        od;

        return allsurf;
            
end);

RedispatchOnCondition( AllWildSimplicialSurfaces, true, [IsSimplicialSurface],
    [IsActualSurface], 0 );



InstallMethod( WildIsomorphismRepresentatives, "for a list of wild simplicial surfaces",
    [IsList],
    function( wildList )
        local rep, isNew, test, old;
        
        rep := [];
        for test in wildList do
            isNew := true;
            for old in rep do
                if isNew and IsIsomorphicWildSimplicialSurface(old,test) then
                    isNew := false;
                fi;
            od;

            if isNew then
                Add(rep, test);
            fi;
        od;

        return rep;
    end
);


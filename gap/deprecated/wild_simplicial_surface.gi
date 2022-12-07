#! @DoNotReadRestOfFile

##############################################################################
##############################################################################
##
##			Start of big (quasi-constructor) methods
##
##
BindGlobal( "__SIMPLICIAL_ConvertWildLegacyIntoModern", 
	function( faces, edgeCycles, vertexPaths, gens )
    local nrCycles, totalNrCycles, edges, edgeColours, facesOfEdges, colEdgesOfFaces, edgesOfFaces, init, surf, vertices, FindEdges, edgesOfVertices, f, col, i;
	
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


# auxiliary function
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

##  auxiliary function
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

            boundedPositions := PositionsBound(paths);


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


##
##
##		End of big (quasi-constructor) methods
##
##############################################################################
##############################################################################
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



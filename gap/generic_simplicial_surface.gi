#########################################################################################
##
#W  generic_simplicial_surface.gi      Generic Simplicial Surface       Alice Niemeyer
#W																		Markus Baumeister
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
##	A generic simplicial surface consists of the following data:
##	1) The number of vertices
##	2) The number of edges
##	3) The number of faces
##	4) For each edge: A list of the two incident vertices
##	5) For each face: A list of the three indicent edges
##		The order or these three edges defines the orientation of this face.
##

DeclareInfoClass( "InfoSimplicial" );
SetInfoLevel(InfoSimplicial,1);



DeclareRepresentation("IsGenericSimplicialSurfaceRep", IsComponentObjectRep,
     ["nrOfVertices","nrOfEdges","nrOfFaces", "edges", "faces"]);

# From now on, we can do "Objectify( SimplicialSurfaceType, re )" 
# for any list re
GenericSimplicialSurfaceType := 
    NewType( SimplicialSurfaceFamily, IsGenericSimplicialSurfaceRep );

##
##  The constructor GenericSimplicialSurface ensures that the simplicial surface
##  is  stored inside a GAP object. 
##
GenericSimplicialSurface :=  function( simpsurf ) 
    
    return Objectify( GenericSimplicialSurfaceType, simpsurf );

end;


#############################################################################
##
##  The following functions only access the generic simplicial surface and
##  return known information about the generic simplicial surface <simpsurf>.
## 

#############################################################################
##
##
#!  @Description
#!  This function returns the list of faces of a generic simplicial surface.
#!  @Returns a list
#!  @Arguments simpsurf
#!
FacesOfGenericSimplicialSurface := function( simpsurf)

        if not IsGenericSimplicialSurfaceRep(simpsurf) then
            Error("usage: FacesOfGenericSimplicialSurface(simpsurf)");
            return fail;
        fi;
        return simpsurf!.faces;

end;

#############################################################################
##
##
#!  @Description
#!  This function returns the number of faces of a generic simplicial surface.
#!  @Returns an integer
#!  @Arguments simpsurf
#!
NrOfFacesOfGenericSimplicialSurface := function (simpsurf)

		if not IsGenericSimplicialSurfaceRep(simpsurf) then
            Error("usage: NrOfFacesOfGenericSimplicialSurface(simpsurf)");
            return fail;
        fi;
        return simpsurf!.nrOfFaces;

end;

#############################################################################
##
##
#!  @Description
#!  This function returns the list of edges of a generic simplicial surface.
#!  @Returns a list
#!  @Arguments simpsurf
#!
EdgesOfGenericSimplicialSurface := function( simpsurf)

        if not IsGenericSimplicialSurfaceRep(simpsurf) then
            Error("usage: EdgesOfGenericSimplicialSurface(simpsurf)");
            return fail;
        fi;
        return simpsurf!.edges;

end;

#############################################################################
##
##
#!  @Description
#!  This function returns the number of edges of a generic simplicial surface.
#!  @Returns an integer
#!  @Arguments simpsurf
#!
NrOfEdgesOfGenericSimplicialSurface := function( simpsurf)

       if not IsGenericSimplicialSurfaceRep(simpsurf) then
            Error("usage: NrOfEdgesOfGenericSimplicialSurface(simpsurf)");
            return fail;
        fi;
        return simpsurf!.edges;

end;

#############################################################################
##
##
#!  @Description
#!  This function returns the list of vertices of a  simplicial surface.
#!  @Returns a list
#!  @Arguments simpsurf
#!
VerticesOfGenericSimplicialSurface := function( simpsurf)

        if not IsGenericSimplicialSurfaceRep(simpsurf) then
            Error("usage: VerticesOfGenericSimplicialSurface(simpsurf)");
            return fail;
        fi;
        return [1..simpsurf!.nrOfVertices];

end;

#############################################################################
##
##
#!  @Description
#!  This function returns the number of vertices of a generic simplicial surface.
#!  @Returns an integer
#!  @Arguments simpsurf
#!
NrOfVerticesOfGenericSimplicialSurface := function( simpsurf)

        if not IsGenericSimplicialSurfaceRep(simpsurf) then
            Error("usage: NrOfVerticesOfGenericSimplicialSurface(simpsurf)");
            return fail;
        fi;
        return simpsurf!.nrOfVertices;

end;

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
EulerCharacteristic := function (simpsurf)

    local chi;

    if not IsGenericSimplicialSurfaceRep(simpsurf) then
        Error("usage: EulerCharacteristic(simpsurf)");
        return fail;
    fi;

    if IsBound(simpsurf!.EulerCharacteristic) then
        return simpsurf!.EulerCharacteristic;
    fi;

    chi :=    NrOfVerticesOfGenericSimplicialSurface(simpsurf)  # V
            - NrOfEdgesOfGenericSimplicialSurface(simpsurf)     # -E
            + NrOfFacesOfGenericSimplicialSurface(simpsurf);    # +F


     simpsurf!.EulerCharacteristic := chi;

     return chi;

end;


############################################################################
##
#! @Description
#! This function returns the faces of the generic simplicial surface with
#! respect to their vertices. The implicit orientation that is given
#! through the edges will be represented here as well.
#! @Returns a list of lists of integers, for each face a list of the
#! contained vertices.
#! @Arguments <simpsurf>, a generic simplicial surface
#!
FacesByVerticesOfGenericSimplicialSurface := function( simpsurf )
	local faceList, i, face,intersectingEdges,vertices,j;

	if IsBound(simpsurf!.FacesByVertices) then
        return simpsurf!.FacesByVertices;
    fi;

	faceList := [];
	for i in [1 .. NrOfFacesOfGenericSimplicialSurface(simpsurf)] do
		face := FacesOfGenericSimplicialSurface(simpsurf)[i];
		vertices := [];

		# Intersect first and last edge to obtain first vertex
		intersectingEdges := Intersection( Set( EdgesOfGenericSimplicialSurface(simpsurf)[face[1]] ),
				Set( EdgesOfGenericSimplicialSurface(simpsurf)[face[Length(face)]] ) );
		if Length(intersectingEdges) <> 1 then
       		Error("FacesByVerticesOfGenericSimplicialSurface: Edge intersection is not unique.");
		fi;
		vertices[1] := intersectingEdges[1];

		# Continue in the same way for the other edges
		for j in [2 .. Length(face)] do
			intersectingEdges := Intersection( Set( EdgesOfGenericSimplicialSurface(simpsurf)[face[j-1]] ),
				Set( EdgesOfGenericSimplicialSurface(simpsurf)[j] ) );
			if Length(intersectingEdges) <> 1 then
       			Error("FacesByVerticesOfGenericSimplicialSurface: Edge intersection is not unique.");
			fi;
			vertices[j] := intersectingEdges[1];
		od;

		faceList[i] := vertices;
	od;

	return faceList;
end;


#############################################################################
##
#!  @Description
#!  This function computes the face-degrees of the vertices of the simplicial 
#!  surface <simpsurf>.
#!  The face-degree of a vertex is the number of faces incident to the vertex.
#!  @Returns a list of integers, containing for each
#!  vertex of the simplicial suface its degree
#!  @Arguments <simpsurf>, a simplicial surface object as created 
#!  by SimplicialSurface
#!
UnsortedDegreesOfGenericSimplicialSurface := function(simpsurf)

        local degrees, i, faces,j, deg;

		if IsBound( simpsurf!.UnsortedDegrees ) then
			return simpsurf!.UnsortedDegrees;
		fi;

		degrees := [];
		faces := FacesByVerticesOfGenericSimplicialSurface(simpsurf);
		for i in [1 .. NrOfVerticesOfGenericSimplicialSurface(simpsurf)] do
			deg := 0;
			for j in [1 .. Length(faces)] do
				if i in faces[j] then
					deg := deg+1;
				fi;
			od;
			degrees[i] := deg;
		od;

        simpsurf!.UnsortedDegrees := degrees;

        return degrees;
end;

#############################################################################
##
#!  @Description
#!  This function computes the face-degrees of the vertices of the simplicial 
#!  surface <simpsurf> and returns them sorted.
#!  The face-degree of a vertex is the number of faces incident to the vertex.
#!  @Returns a list of integers in increasing order, containing for each
#!  vertex of the simplicial suface its degree
#!  @Arguments <simpsurf>, a simplicial surface object as created 
#!  by SimplicialSurface
#!
SortedDegreesOfGenericSimplicialSurface := function(simpsurf)
		local degrees;

		if IsBound( simpsurf!.SortedDegrees) then
			return simpsurf!.SortedDegrees;
		fi;

		degrees := UnsortedDegreesOfGenericSimplicialSurface( simpsurf );
		simpsurf!.SortedDegrees := Sort( degrees );
        return degrees;
end;


#############################################################################
##
#!  @Description
#!  Check if to generic simplicial surfaces are equal.
#!  @Returns true or false
#!  @Arguments <s1>, <s2>, two generic simplicial surface objects as created 
#!  by SimplicialSurface
#! equality if the generators are possibly reordered
##
InstallMethod( \=, "for two generic simplicial surfaces", true, 
  [ IsGenericSimplicialSurfaceRep, IsGenericSimplicialSurfaceRep ], 0,  function( s1, s2 )

		if NrOfVerticesOfGenericSimplicialSurface(s1) <> NrOfVerticesOfGenericSimplicialSurface(s2) then
			return false;
		fi;
		if NrOfEdgesOfGenericSimplicialSurface(s1) <> NrOfEdgesOfGenericSimplicialSurface(s2) then
			return false;
		fi;
		if NrOfFacesOfGenericSimplicialSurface(s1) <> NrOfFacesOfGenericSimplicialSurface(s2) then
			return false;
		fi;

		if EdgesOfGenericSimplicialSurface(s1) <> EdgesOfGenericSimplicialSurface(s2) then
			return false;
		fi;
		if FacesOfGenericSimplicialSurface(s1) <> FacesOfGenericSimplicialSurface(s2) then
			return false;
		fi;

        return true;

end);



#TODO current position


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

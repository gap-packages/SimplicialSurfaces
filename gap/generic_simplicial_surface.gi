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

	if IsBound(simpsurf!.facesByVertices) then
        return simpsurf!.facesByVertices;
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

	simpsurf!.facesByVertices := faceList;
	return faceList;
end;


############################################################################
##
#! @Description
#! This function returns for each edge of the generic simplicial surface
#! a set of all adjacent faces.
#! @Returns a list of sets of integers, for each edge a list of the
#! adjacent faces.
#! @Arguments <simpsurf>, a generic simplicial surface
#!
EdgesByFacesOfGenericSimplicialSurface := function( simpsurf )
	local edgeList, edge, faceSet, face;

	if IsBound( simpsurf!.edgesByFaces ) then
		return simpsurf!.edgesByFaces;
	fi;

	edgeList := [];
	for edge in [1..NrOfEdgesOfGenericSimplicialSurface(simpsurf)] do
		faceSet := [];
		for face in [1..NrOfFacesOfGenericSimplicialSurface(simpsurf)] do
			if edge in FacesOfGenericSimplicialSurface(simpsurf)[face] then
				faceSet := Union( faceSet, [face] );
			fi;
		od;
		edgeList[edge] := faceSet;
	od;

	simpsurf!.edgesByFaces := edgeList;
	return simpsurf!.edgesByFaces;
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
#!
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



#############################################################################
##
##  A Print method for generic simplicial surfaces
##

PrintGenericSimplicialSurface := function(simpsurf)

        Print("GenericSimplicialSurface( rec(\n");
        Print("nrOfVertices := ");
        Print(simpsurf!.nrOfVertices, ",\n");
        Print("nrOfEdges := ");
        Print(simpsurf!.nrOfEdges, ",\n");
        Print("nrOfFaces := ");
        Print(simpsurf!.nrOfFaces, ",\n");
        Print("edges := ");
        Print(simpsurf!.edges, ",\n");
        Print("faces := ");
        Print(simpsurf!.faces, "));\n");
end;


#############################################################################
##
##  A Display method for simplicial surfaces
##
DisplayGenericSimplicialSurface := function(simpsurf)

        Print("Number of vertices: ", simpsurf!.nrOfVertices, ",\n");
        Print("Number of edges: ", simpsurf!.nrOfEdges, ",\n");
        Print("Number of faces: ", simpsurf!.nrOfFaces, ",\n");
        Print("Edges: ", simpsurf!.edges, ",\n");
        Print("Faces: ", simpsurf!.faces);

end;

#############################################################################
##
#!  @Description
#!  Check if a generic simplicial surfaces is connected.
#!  @Returns true or false
#!  @Arguments <simpsurf>, a generic simplicial surface object as created 
#!  by SimplicialSurface
#!
##
IsConnectedSimplicialSurface := function(simpsurf)
	local faces, faceList, points, change, faceNr;

	if IsBound( simpsurf!.isConnected ) then 
		return simpsurf!.isConnected;
	fi;

	faceList := FacesByVerticesOfGenericSimplicialSurface(simpsurf);
	faces := [2..NrOfFacesOfGenericSimplicialSurface(simpsurf)];
	points := Set( faceList[1] );

	change := true;
	while change do
		change := false;

		for faceNr in faces do
			if Intersection( points, faceList[faceNr] ) <> [] then
				change := true;
				points := Union( points, faceList[faceNr] );
				faces := Difference( faces, [faceNr] );
			fi;
		od;
	od;

	simpsurf!.isConnected := IsEmpty( faces );

	return simpsurf!.isConnected;
end;


###############################################################################
##
#!  @Description
#!  This function checks whether the generic simplicial surface is an actual
#!	surface.
#!  @Returns true if it is a surface and false else.
#!  @Arguments <simpsurf> a generic simplicial surface
#!
IsActualSurfaceGenericSimplicialSurface := function( simpsurf )
	local edge, face, number, check;

	if IsBound( simpsurf!.isActualSurface ) then
		return simpsurf!.isActualSurface;
	fi;

	check := true;
	for edge in [1..NrOfEdgesOfGenericSimplicialSurface(simpsurf)] while check do
		number := 0;
		for face in [1..NrOfFacesOfGenericSimplicialSurface(simpsurf)] do
			if edge in FacesOfGenericSimplicialSurface(simpsurf)[face] then
				number := number + 1;
			fi;
		od;
		if number > 2 then
			check := false;
		fi;
	od; 
	
	simpsurf!.isActualSurface := check;
	return check;
end;


#TODO current position


###############################################################################
##
#!  @Description
#!  This function decides whether the generic simplicial surface
#!  <simpsurf> is orientable. To that end it has to be an actual surface.
#!  @Returns true if the surface is orientable and false else.
#!  @Arguments <simpsurf> a simplicial surface
#!
IsOrientableGenericSimplicialSurface := function( simpsurf )
	local edgesByFaces, facesByVertices, orientList, i, hole, found, facesToCheck, checkedFaces;

	if not IsActualSurfaceGenericSimplicialSurface(simpsurf) then
		Error( "IsOrientableGenericSimplicialSurface: not an actual surface given." );
	fi;
	if IsBound( simpsurf!.isOrientable ) then
		return simpsurf!.isOrientable;
	fi;

	edgesByFaces := EdgesByFacesOfGenericSimplicialSurface(simpsurf);
	facesByVertices := FacesByVerticesOfGenericSimplicialSurface(simpsurf);

	# Method to check if the orientation of a face is induced by that of one of its edges
	CompatibleOrientation := function( edgeByVertices, faceByVertices )
		local pos;

		pos := Position( faceByVertices, edgeByVertices[1] );
		if pos = fail then
			Error( "IsOrientableGenericSimplicialSurface: Incompatible Orientation" );
		fi;
		if pos < Length( faceByVertices ) then
			return edgeByVertices[2] = faceByVertices[pos+1];
		else
			return edgeByVertices[2] = faceByVertices[1];
		fi;
	end;

	orientable := true;
	orientList := [];
	orientList[ 1 + Length( NrOfFacesOfGenericSimplicialSurface(simpsurf) )] := 1;
	while not IsDenseList( orientList ) and orientable do
		# Find the first hole
		found := false;
		hole := 0;
		for i in [1..Length(orientList)] while not found do
			if not IsBound( orientList[i] ) then
				hole := i;
				found := true;
			fi;
		od;

		# Define the standard orientation of this face as "up"
		orientList[hole] := 1;
		facesToCheck := [hole];
		checkedFaces := [];

		while facesToCheck <> [] and orientable do
			face := facesToCheck[1];
			for edge in FacesOfGenericSimplicialSurface(simpsurf)[face] while orientable do
				neighbours := Difference( edgesByFaces[edge], [face] );	# This should be unique
				if Size( neighbours ) <> 1 then
					Error( "IsOrientableGenericSimplicialSurface: Not a proper surface.");
				fi;
				next := neighbours[1];

				# Check how these two faces act on the edge
				if CompatibleOrientation( EdgesOfGenericSimplicialSurface[edge], facesByVertices[face] ) then
					orient1 := 1;
				else
					orient1 := -1;
				fi;

				if CompatibleOrientation( EdgesOfGenericSimplicialSurface[edge], facesByVertices[next] ) then
					orient2 := 1;
				else
					orient2 := -1;
				fi;

				if orient1*orient2 = -1 then # the sides are neighbours
					if IsBound( orientList[next] ) and orientList[next] <> orientList[face] then
						orientable := false;
					else
						orientList[next] := orientList[face];
					fi;
				elif orient1*orient2 = 1 then # the sides are not neighbours
					if IsBound( orientList[next] ) and orientList[next] = orientList[face] then
						orientable := false;
					else
						orientList[next] := -1*orientList[face];
					fi;
				else
					Error( "IsOrientableGenericSimplicialSurface: Wrong definition of orientation.");
				fi;

				if not next in checkedFaces then
					facesToCheck := Union( facesToCheck, [next] );
				fi;
			od;
			facesToCheck := Difference( facesToCheck, [face] );
			checkedFaces := Union( checkedFaces, [face] );
		od;
	od;
	
	simpsurf!.isOrientable := orientable;
	return simpsurf!.isOrientable;
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



#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2018
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

InstallMethod( IsEdgeTwoColouring, 
    "for an edge coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComp)
        local edges, colours, c, i;

        edges := EdgesOfFaces( PolygonalComplex(colComp) );
        colours := List(edges, edg -> List(edg, e -> ColoursOfEdges(colComp)[e]));
        # check that each face has edges of 2 colours and that
        # these are the same for all faces
 	c := PositionsBound(colours);
        for i in c do
            if Set(colours[i]) <> Set(colours[c[1]]) then return false; fi;
        od;
        if Size(Set(colours[c[1]]))<> 2 then return false; fi;
        return true; 
    end
);

InstallMethod( IsIsoscelesColouredSurface,
    "for an edge-coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex],
    function(colComp)

    local edges, colours, c, i;
	
    if not IsEdgeColouredSimplicialSurface(colComp) then
	return false;
    fi;
               
    edges := EdgesOfFaces( PolygonalComplex(colComp) );
    colours := List(edges, edg -> List(edg, e -> ColoursOfEdges(colComp)[e]));
        # check that each face has edges of 2 colours and that
        # these are the same for all faces
    for c in colours do Sort(c); od;
    c := PositionsBound(colours);
    for i in c do
        if colours[i] <> colours[c[1]] then return false; fi;
    od;               
    return true;
    end
);

#InstallOtherMethod( IsIsoscelesColouredSurface,
#    "for an object", [IsObject], function(obj)
#        if IsEdgeColouredPolygonalComplex(obj) then
#            TryNextMethod();
#        else
#            return false;
#       fi;
#    end
#);
#######################################
##
##      ColouredEdgesOfFaces
##
InstallMethod( ColouredEdgesOfFaceNC,
    "for an edge two-coloured polygonal complex and a face",
    [IsEdgeColouredPolygonalComplex and IsEdgeTwoColouring, IsPosInt],
    function(rbComp, face)
        return ColouredEdgesOfFaces(rbComp)[face];
    end
);
    RedispatchOnCondition( ColouredEdgesOfFaceNC, true, 
        [IsEdgeColouredTwistedPolygonalComplex, IsPosInt], 
        [IsEdgeTwoColouring,], 0 );

InstallMethod( ColouredEdgesOfFace,
    "for an edge two-coloured polygonal complex and a face",
    [IsEdgeColouredPolygonalComplex and IsEdgeTwoColouring, IsPosInt],
    function(rbComp, face)
        __SIMPLICIAL_CheckFace( PolygonalComplex(rbComp), face, "ColouredEdgesOfFace" );
        return ColouredEdgesOfFaceNC(rbComp,face);
    end
);
    RedispatchOnCondition( ColouredEdgesOfFace, true, 
        [IsEdgeColouredTwistedPolygonalComplex,IsPosInt], 
        [IsEdgeTwoColouring,], 0 );

InstallMethod( ColouredEdgesOfFaces,
    "for an edge two-coloured polygonal complex",
    [IsEdgeColouredPolygonalComplex and IsEdgeTwoColouring],
    function(rbComp)
        local edges, colEdgesOfFaces, face, edgesOfCol, e;

        colEdgesOfFaces := [];
        for face in Faces( PolygonalComplex(rbComp) ) do
            edges := EdgesOfFaces(PolygonalComplex(rbComp))[face];
            edgesOfCol := [[],[]];
            for e in edges do
                Add(edgesOfCol[ ColoursOfEdges(rbComp)[e] ], e);
            od;
            colEdgesOfFaces[face] := edgesOfCol;
        od;
                
        return colEdgesOfFaces;
    end
);
    RedispatchOnCondition( ColouredEdgesOfFaces, true, 
        [IsEdgeColouredTwistedPolygonalComplex], 
        [IsEdgeTwoColouring], 0 );



InstallMethod( ApexVertexOfFace,
    [IsIsoscelesColouredSurface, IsPosInt],
    function(surf, face)

     local coledges, v;
               

     __SIMPLICIAL_CheckFace(surf, face, "ApexVertexOfFace");
     coledges := ColouredEdgesOfFace( surf, face);
     if Length(coledges[1]) = 2 then
        coledges := coledges[1];
     else 
        coledges := coledges[2];
    fi;
    v := Intersection( VerticesOfEdge(surf, coledges[1]),
                       VerticesOfEdge(surf, coledges[2]));
    return v[1];
end
);               

RedispatchOnCondition( ApexVertexOfFace, true, 
        [IsEdgeColouredTwistedPolygonalComplex,IsPosInt],
    [IsIsoscelesColouredSurface],	0 );


InstallMethod( BaseEdgeOfFace,
    [IsIsoscelesColouredSurface, IsPosInt],
    function(surf, face)

     local coledges, v;
               

     __SIMPLICIAL_CheckFace(surf, face, "BaseEdgeOfFace");
     coledges := ColouredEdgesOfFace( surf, face);
     if Length(coledges[1]) = 1 then
        return coledges[1][1];
     else 
        return coledges[2][1];
    fi;
end
);


RedispatchOnCondition( BaseEdgeOfFace, true, 
        [IsEdgeColouredTwistedPolygonalComplex,IsPosInt],
    [IsIsoscelesColouredSurface],	0 );


__SIMPLICIAL_Legfaces := function( surf, e)

               local b, m, faces, vertOfb, vertOfe, newfaces, newperm;

            m := Maximum(Faces(surf));
            faces := FacesOfEdge(surf, e);

            # if there is only one face, then we will return
            # the face itself, if the leg is adjacent to the smaller
            # base vertex and m + face otherwise
            if Length(faces) = 1 then
               b := BaseEdgeOfFace( surf, faces[1] );
               vertOfb := VerticesOfEdge(surf,b);
               vertOfe := VerticesOfEdge(surf,e);
               if Intersection(vertOfe,vertOfb)[1]=Minimum(vertOfb) then
                   return [faces[1]];
               else return [m + faces[1]];
               fi;
            fi;
               
            # now we know the edge has two faces
            newfaces := [];
            b := BaseEdgeOfFace( surf, faces[1] );
            vertOfb := VerticesOfEdge(surf,b);
            vertOfe := VerticesOfEdge(surf,e);
            if Intersection(vertOfe,vertOfb)[1]=Minimum(vertOfb) then
                  newfaces[1] := faces[1];
            else newfaces[1] :=  m + faces[1];
            fi;
            b := BaseEdgeOfFace( surf, faces[2] );
            vertOfb := VerticesOfEdge(surf,b);
            if Intersection(vertOfe,vertOfb)[1]=Minimum(vertOfb) then
                  newfaces[2] := faces[2];
            else newfaces[2] :=  m + faces[2];
            fi;

            return newfaces;

        end;


#############################################################################
##  ColourInvolutions
##
    ## TODO: unramified
InstallMethod( ColourInvolutions,
    "for an edge isosceles-coloured unramified polygonal surface",
    [IsIsoscelesColouredSurface],
    function(surf)
               local invs, cols, col, toList, edges, edge, facesOfEdge,
               newperm, legperm, baseperm, base, legs, m, b,
               verticesOfEdge, verticesOfb;

       # this function assumes without checking that e is a
       # leg edge and computes the subdivided face numbers
       # of the faces incident to e. If F is a face incident to
       # then the subdivided face number of F is either F or
       # m + F,  where m = Maximum(Faces(surf)), depending on
       # whether e is incident to the minimum or the maximum of the
       # two base vertices of F.
               
        invs := [];
        cols := EdgesOfColours(surf);
        # set the base edges and the leg edges
        if Length(cols[1])>Length(cols[2]) then
               legs  := cols[1]; #ColoursOfEdge(surf,cols[1][1]);
               base  := cols[2];
        else   legs  := cols[2];
               base  := cols[1];
        fi;

                  
        m := Maximum(Faces(surf));
        baseperm := [1..2*m];
        legperm  := [1..2*m];
        newperm  := [1..2*m];

        for edge in base do
            # Find faces of this base edge
            facesOfEdge := FacesOfEdge(surf,edge);
            verticesOfEdge := VerticesOfEdge(surf,edge);
            # Construct the new permutation
 
            if Length(facesOfEdge) = 2 then
                baseperm[ facesOfEdge[1] ] := facesOfEdge[2];
                baseperm[ facesOfEdge[2] ] := facesOfEdge[1];
                baseperm[ m+facesOfEdge[1] ] := m+facesOfEdge[2];
                baseperm[ m+facesOfEdge[2] ] := m+facesOfEdge[1];
                newperm[ facesOfEdge[1] ] := m+facesOfEdge[1];
                newperm[ m+facesOfEdge[1] ] := facesOfEdge[1];
                newperm[ facesOfEdge[2] ] := m+facesOfEdge[2];
                newperm[ m+facesOfEdge[2] ] := facesOfEdge[2];
            else
                newperm[ facesOfEdge[1] ] := m+facesOfEdge[1];
            fi;
 
        od;


        for edge in legs do
            facesOfEdge := __SIMPLICIAL_Legfaces( surf, edge);
            if Length(facesOfEdge) = 2 then
                legperm[facesOfEdge[1]] := facesOfEdge[2];
                legperm[facesOfEdge[2]] := facesOfEdge[1];
            fi;
        od;
        return [PermList(baseperm), PermList(legperm), PermList(newperm)];
    end
);
    RedispatchOnCondition( ColourInvolutions, true, 
        [IsEdgeColouredTwistedPolygonalComplex], 
        [IsEdgeTwoColouring and IsNotEdgeRamified], 0 );


#############################################################################
##
##  WildColouredSurfaceOfIsoscelesColouredSurface
##
##  Assosciated to an isosceles coloured surf is a wild coloured surface
##  whose colour involutions are the colour involutions of the isosceles
##  coloured surface.
##

InstallMethod( WildColouredSurfaceOfIsoscelesColouredSurface,
    "for an isosceles coloured surface",
    [IsIsoscelesColouredSurface],
    function ( surf)

    local cols, edges, legs, base, v, vertInFaces, vertInLegs,
           vertInBase, vertInNew, e, faces, origfaces, b, j, obj,
           coloursOfEdges, colSurf, verts;
	   
        cols := EdgesOfColours(surf);
        edges := Edges(surf);
        # set the base edges and the leg edges
        if Length(cols[1])>Length(cols[2]) then
               legs  := cols[1]; #ColoursOfEdge(surf,cols[1][1]);
               base  := cols[2];
        else   legs  := cols[2];
               base  := cols[1];
        fi;

                  
        v := Length(Vertices(surf));

        vertInFaces := [];
	vertInLegs  := [];
	vertInBase  := [];
	vertInNew   := [];
        for e in legs do
            # record the vertices of e
	    Add(vertInLegs,VerticesOfEdge(surf,e));
            faces :=  __SIMPLICIAL_Legfaces(surf,e);
            origfaces := FacesOfEdge(surf,e);
            # note that origfaces[1] corresponds to faces[1]
            b := BaseEdgeOfFace( surf, origfaces[1] );
            vertInFaces[faces[1]] := ShallowCopy(VerticesOfEdge(surf,e));
	    ## The base edge splits in two
            Add( vertInFaces[faces[1]],  v + Position(base,b));
            # record the vertices of the two new base edges
	    for j in VerticesOfEdge(surf,b) do
  	        Add( vertInBase, Set([v+ Position(base,b),j]));
	    od;
	    # The new edge has vertices, one is the new base
            # vertex, the other the apex of the face 
	    Add(vertInNew,Set([v+Position(base,b),
                               ApexVertexOfFace(surf,origfaces[1])]));
            if Length(faces) = 2 then
                b := BaseEdgeOfFace( surf, origfaces[2] );
                vertInFaces[faces[2]]:=ShallowCopy(VerticesOfEdge(surf,e));
                Add( vertInFaces[faces[2]],  v + Position(base,b));
                # record the vertices of the two new base edges
    	        for j in VerticesOfEdge(surf,b) do
  	            Add( vertInBase, Set([v+ Position(base,b),j]));
	        od;
	        # The new edge has vertices, one is the new base
                # vertex, the other the apex of the face 
	        Add(vertInNew,Set([v+Position(base,b),
                                   ApexVertexOfFace(surf,origfaces[2])]));
            fi;
        od;

        # construction of the simplicial surface
        obj := SimplicialSurfaceByVerticesInFaces(vertInFaces);
	edges := Edges(obj);
        coloursOfEdges := [];

        
	# 1 is the leg colour, 2 the base colour, 3 the new colour
	for j in [ 1 .. Length(edges) ] do
	    verts := VerticesOfEdge(obj,edges[j]);
            if verts in vertInLegs then	    
  	        coloursOfEdges[j] := 1;
            elif verts in vertInBase then
  	        coloursOfEdges[j] := 2;
	    elif verts in vertInNew then
  	        coloursOfEdges[j] := 3;
            else Error("Unknown edge");
	    fi;
	od;
	

        # construction of the wild coloured surface
        colSurf := Objectify( EdgeColouredTwistedPolygonalComplexType, rec() );
        SetColoursOfEdges(colSurf, coloursOfEdges);
#        SetLocalSymmetryOfEdgesAsNumbers(colSurf, partialLocalSym);
#        SetColouredEdgesOfFaces(colSurf, edgesOfFacesByColour);
        SetPolygonalComplex(colSurf, obj);
	SetIsEdgeColouredPolygonalComplex(colSurf, true);
	
        return  colSurf;
    
end
);


#######################################
##
##      ColouredUmbrellasOfVertices
##
InstallMethod( ColouredUmbrellaOfVertexNC,
    "for an isosceles coloured surface and a vertex",
    [IsIsoscelesColouredSurface, IsPosInt],
    function(isoscelesSurf, vertex)
        return ColouredUmbrellasOfVertices(isoscelesSurf)[vertex];
    end
);
    RedispatchOnCondition( ColouredUmbrellaOfVertexNC, true, 
        [IsEdgeColouredTwistedPolygonalComplex, IsPosInt], 
        [IsIsoscelesColouredSurface], 0 );

InstallMethod( ColouredUmbrellaOfVertex,
    "for an isosceles coloured surface and a vertex",
    [IsIsoscelesColouredSurface, IsPosInt],
    function(isoscelesSurf, vertex)
        __SIMPLICIAL_CheckVertex( PolygonalComplex(isoscelesSurf), vertex, "ColouredUmbrellaOfVertex" );
        return ColouredUmbrellaOfVertexNC(isoscelesSurf,vertex);
    end
);
    RedispatchOnCondition( ColouredUmbrellaOfVertex, true, 
        [IsEdgeColouredTwistedPolygonalComplex,IsPosInt], 
        [IsIsoscelesColouredSurface], 0 );

InstallMethod( ColouredUmbrellasOfVertices,
    "for an isosceles coloured surface",
    [IsIsoscelesColouredSurface],
    function(isoscelesSurf)
        local umb, colUmb, complex, colUmbs, v;

        complex := PolygonalComplex(isoscelesSurf);
        umb := UmbrellaPathsOfVertices( complex );
        colUmbs := [];
        for v in VerticesAttributeOfComplex(complex) do
            colUmb := Objectify( EdgeColouredEdgeFacePathType, rec() );
            SetPath( colUmb, Path(umb[v]) );
            SetAssociatedPolygonalComplex( colUmb, complex);
            SetAssociatedEdgeColouredPolygonalComplex(colUmb, isoscelesSurf);
            colUmbs[v] := colUmb;
        od;
        return colUmbs;
    end
);
RedispatchOnCondition( ColouredUmbrellasOfVertices, true,
    [IsEdgeColouredTwistedPolygonalComplex], [IsIsoscelesColouredSurface], 0);


#######################################
##
##      LocalSymmetryOfEdges
##


InstallMethod( LocalSymmetryOfEdgesAsNumbers, 
    "for an isosceles coloured simplicial surface",
    [IsIsoscelesColouredSurface],
    function(colSurf)
        local mr, surf, r, verts, faces, e1, e2, e;

        surf := PolygonalComplex(colSurf);

        mr := [];
        for e in Edges(surf) do
            if IsBoundaryEdge(surf,e) then
                mr[e] := 0; # boundary
            else
                verts := VerticesOfEdges(surf)[e];
                faces := FacesOfEdges(surf)[e];
                e1 := OtherEdgeOfVertexInFaceNC(surf,verts[1],e,faces[1]);
                e2 := OtherEdgeOfVertexInFaceNC(surf,verts[1],e,faces[2]);
                if ColoursOfEdges(colSurf)[e1] = ColoursOfEdges(colSurf)[e2] then
                    mr[e] := 1; # mirror
                else
                    mr[e] := 2; # rotation
                fi;
            fi;
        od;

        return mr;
    end
);
    RedispatchOnCondition( LocalSymmetryOfEdgesAsNumbers, true, 
        [IsEdgeColouredTwistedPolygonalComplex], 
        [IsIsoscelesColouredSurface], 0 );


InstallMethod( LocalSymmetryOfEdges, 
    "for an edge-coloured simplicial surface",
    [IsIsoscelesColouredSurface], 
    function(colSurf)
        local mr;

        mr := LocalSymmetryOfEdgesAsNumbers(colSurf);
        return List(mr, __SIMPLICIAL_LocalSymmetryNamesOfNumber );
    end
);
    RedispatchOnCondition( LocalSymmetryOfEdges, true, 
        [IsEdgeColouredTwistedPolygonalComplex], 
        [IsIsoscelesColouredSurface], 0 );

################################
##
## AllIsocelesColouredSurfaces( <surf> ) . . . find all isosceles colourings
##
## This function determines all edge colourings of a simplicial surface such
## that two edges have the same colour, representing isosceles triangles. Note
## that not all isosceles colourings are obtained by setting two colours
## equal in a wild colouring.
##
InstallOtherMethod( AllIsoscelesColouredSurfaces, "for a simplicial surface",
    [IsSimplicialSurface],
    function( surf)
	return AllIsoscelesColouredSurfaces(surf, true);
    end
);

InstallMethod( AllIsoscelesColouredSurfaces, "for a simplicial surface",
    [IsSimplicialSurface, IsBool],
            function( surf, noIsom)

            local     umb, edges, faces, u, norepeatings, vertices,  info,
              assignagree, edgeassign, TestAssign, alledgeassignments,
              isCompatible, degs, degreeassign, i, obj, coloursOfEdges,
              colEdgePos,isoscelesColSurfaces;

        alledgeassignments :=[];

    
        # we represent the two colours by "l" (leg) and "s" (base)
        # this function loops through the entries in tup and ensures
        # that between any two "s" there is an "l"
        # here <tup> represents the edges around a vertex. Note that
        # two base edges "s" cannot be next to each other
        norepeatings := function ( tup )

               local i, n;

               n := Length(tup);
               if n <= 1 then Error("norepeatings: mistake in surface"); fi;

               for i in [ 2 .. n ] do
                   if tup[i]=tup[i-1] and tup[i]="s" then return false; fi;
               od;
               return true;
        end;

        # this function chekcs whether the assignments of the edges that
        # lie in the list <setedges> agrees with the assignments to be made
        # as determined by <newassign>
        assignagree := function ( edgeassign, edges, setedges, newassign )

                local j, e;

                for e in setedges do
                    # find position j where e is stored in edges 
                    # newassign tells us at  position j what
                    # the new assignment is to be
                    j := Position( edges, e);
                    if edgeassign[e] <> newassign[j] then
                        return false;
                    fi;
                od;
                return true;
        end;

        # This function checks whether the new assignment <assign> is
        # compatible with the existing assignment <edgeassign> and if
        # so it updates <edgeassign> as a side effect
        # <v> is a vertex
        isCompatible := function( edgeassign, assign, v)

                local e, j, f, i, speichen, edges, faces; 
   
                # find edges and faces around the vertex v
                edges := EdgesAsList(umb[v]);
                if IsInnerVertex( surf, v) then
                    edges := edges{[1..Length(edges)-1]};
                fi;
                faces := FacesAsList(umb[v]);

                # check whether the extension <assign> is compatible
                # with the already chosen edge assignments
                for j in [1..Length(edges)] do
                    e := edges[j];
                    if edgeassign[e] <> 0 and edgeassign[e] <> assign[j] then
                        return false;
                    fi;
                    edgeassign[edges[j]] := assign[j];
                od;


                # once the edges around the vertex u have been set,
                # we can also assign the edges of the boundary of
                # the umbrella around the vertex v
                for f in faces do
                    # set e to the boundary vertex opposite the vertex v
                    e :=  OppositeEdgeOfVertexInTriangle( surf,v,f);
                    # find the two other edges
                    speichen  := Difference(EdgesOfFace(surf,f), [e] );
                    if edgeassign[e] <> 0 then
                        # e already has an assignment.
                        # test whether it is compatible
                        if "s" in List( speichen, i-> edgeassign[i]) then
                            if edgeassign[e] <> "l" then
                                # the assignment is incompatible
                                return false;
                            fi;
                        else
                            if edgeassign[e] <> "s" then
                                # the assignment is incompatible
                                return false;
                            fi;
                         fi;
                     else
                        # e was not yet assigned, so do it now
                        if "s" in List( speichen, i-> edgeassign[i]) then
                            edgeassign[e] := "l";
                        else
                            edgeassign[e] := "s";
                         fi;
                     fi;
                 od;
                 return true;

        end;

        # we try to complete the current assignment <edgeassign>
        # to an assignment including the umbrella around vertex u
        TestAssign := function(edgeassign, umb, u)
             local edges, allassign, setedges, assign, j, f, e, i, 
                   origedgeassign, speichen, v, filt;

            if u = 1 then
                edgeassign := [];
                for i in Edges(surf) do edgeassign[i] := 0; od;
            fi;

            if u > Length(Vertices(surf)) then
                # we have succeeded to assign all edges around all vertices
                Add(  alledgeassignments, edgeassign);
                return;
            fi;
         
            # we consider the u-th vertex v
            v := vertices[u];
            # find edges around the u-th vertex
            edges := EdgesAsList(umb[v]);
            if IsInnerVertex( surf, v ) then
               edges := edges{[1..Length(edges)-1]};
            fi;


            # find the list of  all possible edge assignments of a vertex
            # of degree EdgeDegreeOfVertex(v)
            allassign := degreeassign[Position(degs,EdgeDegreeOfVertex(surf,v))];
	    filt := function( tup )
	        if tup[1] = "l" then return true; fi;
		return tup[1]<>tup[Length(tup)];
            end;

            # for inner vertices, we have to remove assignments
	    # where the first and last edge are "s" as they are
	    # next to each other.
	    if IsInnerVertex(surf,v) then
	        allassign := Filtered( allassign, filt );
	    fi;
            # only consider compatible onesp
            setedges := Filtered( edges, e-> edgeassign[e] <> 0 );
            allassign := Filtered(allassign,
                             i->assignagree(edgeassign, edges, setedges,i)) ;

            # we make a copy of the edge-assignment as the recursion
            # will modify it
            origedgeassign := ShallowCopy(edgeassign);
            for assign in allassign do

                # we have to hand the original edge-assignment
                # to the recursion
                edgeassign := ShallowCopy(origedgeassign);

                # choose one compatible assignment
                # and update edgeassign accordingly
                # note that isCompatible will modify edgeassign
                if not isCompatible( edgeassign, assign, v) then
                    continue;
                fi;

                TestAssign( edgeassign, umb, u+1 );
            od; # for all assign

        end;

        # store all vertices
        vertices   := Vertices(surf);
        # store all umbrellas of all vertices 
        umb        :=  UmbrellaPathsOfVertices(surf);
        # initialise the colour assignment of edges
        edgeassign := [];
        for i in Edges(surf) do edgeassign[i] := 0; od;

        # work out all possible edge assignments for vertex of degree i
        degs := Set(EdgeDegreesOfVertices( surf ));
        Sort(degs);
        # degreeassign[d] lists all possible colourings of the edges
        # around a vertex of degree d.
        degreeassign := List( degs, i->
            Filtered( Tuples(["l","s"],i), j->norepeatings(j)));

        TestAssign(edgeassign, umb, 1);

        # Now we change the surfaces stored in
        # alledgeassignments into GAP objects
        isoscelesColSurfaces := [];
        for info in alledgeassignments do
            obj := Objectify( EdgeColouredTwistedPolygonalComplexType, rec() );
            if IsEdgeColouredPolygonalComplex(surf) then
                SetPolygonalComplex(obj, PolygonalComplex(surf));
            else
                SetPolygonalComplex(obj, surf);
            fi;
            SetIsIsoscelesColouredSurface(obj, true);

            colEdgePos := [];
            for i in [1..Length(info)] do
                if not IsBound(info[i]) then continue; fi;
                if info[i] = "l" then colEdgePos[i] := 1;
                elif info[i] = "s" then colEdgePos[i] := 2;
                else Error("unknown colour");
                fi;
            od;
            coloursOfEdges := [];
            for i in [1..Length(Edges(surf))] do
                coloursOfEdges[Edges(surf)[i]] := colEdgePos[Edges(surf)[i]];
            od;
            SetColoursOfEdges(obj, coloursOfEdges);

            Add( isoscelesColSurfaces, obj );
        od;
	
        if noIsom=true then
   	    return  EdgeColouredPolygonalComplexIsomorphismRepresentatives(
                isoscelesColSurfaces);
	else 
	    return isoscelesColSurfaces;
	fi;
end
);


##      End of AllIsosceles ...
##
#######################################


#############################################################################
##
##  Analysing Wild or Isosceles coloured surfaces


#############################################################################
##
##  VertexCounterByAngle ( <surf> ) . . . . for a coloured simplicial surface
##


InstallMethod( VertexCounterByAngle,
    "refined vertex counter for an edge coloured surface",
    [IsEdgeColouredSimplicialSurface],
     function (surf)
        local faceDegrees, vertex, face, faces, thisvertex, e, counter;

        counter := [];
        for vertex in Vertices(surf) do
            faces := FacesOfVertex(surf,vertex);
            thisvertex := [];
            for face in faces do
                e := OppositeEdgeOfVertexInTriangle(surf,vertex,face);
                Add(thisvertex, ColourOfEdge(surf,e));
             od;
             Add(counter, Collected(thisvertex));
        od;

        return Collected(counter);

    end)
;


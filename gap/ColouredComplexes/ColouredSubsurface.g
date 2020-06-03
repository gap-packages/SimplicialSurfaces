#! Let colSurf be an edge coloured simplicial surface. If the subcomplex
#! of colSurf induced by the faces in faceList is not a simplicial surface,
#! the function returns an uncoloured triangluar complex. If however the
#! list of faces induces a simplicial surface, then
#! ColouredSubsurface( colSurf, faceList) returns the subsurface of
#! colSurf whose faces are in the list faceList as an edge coloured
#! simplicial surface.
#!
ColouredSubsurface := function(colSurf, faceList)
    local subsurf, i, edgeCol, newEdgeCol, edges;

    subsurf := SubcomplexByFaces(colSurf, faceList);

    edgeCol := ColoursOfEdges(colSurf);
    edges   := Edges(colSurf);
    newEdgeCol := ShallowCopy(edgeCol);
    for i in [1..Length(newEdgeCol)] do
        if not edges[i] in Edges(subsurf) then
            Unbind(newEdgeCol[i]);
        fi;
    od;

    if IsWildColouredSurface(colSurf) then
        SetIsWildColouredSurface(subsurf,true);
    elif IsIsoscelesColouredSurface(subsurf) then
         SetIsIsoscelesColouredSurface(subsurf,true);
    fi;

    return EdgeColouredPolygonalComplex(subsurf, newEdgeCol);
end;

#! FreeSimplexRing( degreeSeq ) returns a  simplicial surface which is
#! a closed ring.
#! The surface has two boundaries (which may be a single vertex)
#! The degree sequence lists the degrees of the vertices along one
#! of the boundary edges.        
FreeSimplexRing := function( degreeSeq )

     local vertsInFaces, current, i, j, k, surf, degSum, colOfEdge,
        boundary, e, inner, lastEdge, nextEdge, inEdgesOfFaces, f;

    if ForAny( degreeSeq, x -> not IsPosInt(x) or x < 2 ) then
        Error("FreeSimplexRing: degrees have to be at least 2.");
    fi;

    vertsInFaces := [];
    current := Length(degreeSeq) + 1;

    for i in [1..Length(degreeSeq)] do
        if i = Length(degreeSeq) then
            j := 1;
        else
            j := i+1;
        fi;

        # define first triangle
        Add( vertsInFaces, [i,j,current] );
        for k in [3..degreeSeq[j]] do
            if j = 1 and k = degreeSeq[1] then
                # close the ring -> no need to update current
                Add( vertsInFaces, [j, current, Length(degreeSeq)+1]);
            else
                current := current + 1;
                Add( vertsInFaces, [j, current, current-1] );
            fi;
        od;
    od;

    surf := SimplicialSurfaceByVerticesInFaces(vertsInFaces);

    degSum := Sum(degreeSeq);
    if IsEvenInt( degSum - Length(degreeSeq) ) then
        # Colouring possible
        boundary := BoundaryEdges(surf);
        colOfEdge := [];
        for e in boundary do
            colOfEdge[e] := 3;
        od;

        inner := InnerEdges(surf);
        inEdgesOfFaces := List( EdgesOfFaces(surf), ed -> 
            Intersection(ed, inner) );
        lastEdge := inEdgesOfFaces[1][1];
        colOfEdge[ lastEdge ] := 1;
        for f in [1..NumberOfFaces(surf)] do
            nextEdge := Difference( inEdgesOfFaces[f], [lastEdge] )[1];
            colOfEdge[nextEdge] := 3 - colOfEdge[lastEdge];
            lastEdge := nextEdge;
        od;

        return EdgeColouredSimplicialSurface(surf, colOfEdge);
    else
        return surf;
    fi;
end;


ApexSequenceOfSimplexRing := function( siri )

        local apexseq, faces, face, apex;

        apex := function( face )
            local e;
            
            for e in EdgesOfFace(siri,face) do
                if IsBoundaryEdge( siri, e ) then
                    return OppositeVertexOfEdgeInTriangle(siri, e, face);
                fi;
            od;
        end;
        apexseq := [];
        faces := Faces( siri );
        for face in faces do
            Add(apexseq, apex(face));
        od;

        return apexseq;

end;        

#############################################################################
##
##  BaseGraph(surf) . . . the graph of the base edges
##

#! For an IsEdgeColouredSurface it determines the base graph.
#! For a WildColouredSurface it determines the graph determined
#! by the colour given as the second argument 
BaseGraph := function (arg)

        local surf, baseedges, cols, edges, e, i, j, vs;

        
        surf := arg[1];
        cols := EdgesOfColours(surf);
        if IsIsoscelesColouredSurface(surf) then
           # set the base colour
           if Length(cols[1])>Length(cols[2]) then
                  baseedges  := cols[2];
           else   baseedges  := cols[1];
           fi;
        elif Length(arg) = 2 and IsBound(cols[arg[2]]) then
            baseedges := cols[arg[2]];
        else
            Error("cannot determine base colour");
        fi;

        vertices := Set([]);
        for e in baseedges do
            vertices := Union(vertices,VerticesOfEdge( surf, e) );
        od;

        edges := List( vertices, v->[] );
        for e in baseedges do
            vs := VerticesOfEdge( surf, e);
            Add(edges[Position(vertices,vs[1])], Position(vertices,vs[2]));
            Add(edges[Position(vertices,vs[2])], Position(vertices,vs[1]));
        od;
       
        dig := Digraph( edges );
        for i in [ 1..Length(vertices) ] do
            SetDigraphVertexLabel(dig, i, vertices[i]);
        od;
        for e in baseedges do
            vs := VerticesOfEdge( surf, e);
            i := Position(vertices,vs[1]);
            j := Position(vertices,vs[2]);
            SetDigraphEdgeLabel(dig, i, j, e);
            SetDigraphEdgeLabel(dig, j, i, e);
        od;

        return dig;

end;


DrawBaseGraph := function (surf, fn)


        local pr;

        pr := rec();
        pr.faceColours :=  List( Faces(surf), f->"white");
        pr.edgeColourClassColours := [ "white", "blue"];
        pr.faceLabelsActive := false;
        # pr.edgeLabelsActive := false;

        pr := DrawSurfaceToTikz( surf, fn, pr);;

end;

DrawBaseGraphAsDigraph := function( gr)

end;

HomotophieTypeDiGraph := function(gr)

                # prue vertices of degree 1 and the
                # edges
end;                

DistancePictureGraph := function(gr,v)

                # List of neighbours of v
                # List of lists of  neighbours of v
                # ...
end;                


DihedralWalk:=function ( i, G )
    local B, R;
    B := Orbit( Group( G ), i );
    R := [ i ];
    while Size( R ) < Size( B ) do
        Append( R, [ R[Size( R )] ^ G[1] ] );
        Append( R, [ R[Size( R )] ^ G[2] ] );    od;
    return R;
end;



#############################################################################
##
#+ All neighbouring faces of the face <face> in <surf> along the edges that
## do not lie in B
##

# Diese Funktion existiert schon fast:
# Sie heisst NeighbourFaceByEdge( surf, face, edge )

NeighbourFacesByNonBase:= function ( surf, base, face )
    local edges, e;
    edges := Difference( EdgesOfFace( surf, face ), base );
    return List( e, e->NeighbourFaceByEdge( surf, face, e ));
end;



DefaultPrintRecord := function(surf)

    local pr;

    if not IsEdgeColouredPolygonalComplex(surf) then
       pr := rec();
    elif IsIsoscelesColouredSurface(surf) then
        pr := rec(  edgeColourClassColours := ["red", "blue"],
                    edgeColourClassLengths := [1.2,0.8] );;
    elif IsWildColouredSurface(surf) then
        pr := rec(  edgeColourClassColours := ["red", "blue", "green"],
                    edgeColourClassLengths := [1.3,0.9,3] );;
    else
        pr := rec();
    fi;

    pr.compileLaTeX := true;
    return pr;
 
end;

#############################################################################
##
#+  SimplexRing( <surf>, <base>, <face> ) . . . . . . . . Simplex Ring
##
##  compute a Simplex ring on face whose outer edges are in B
##
SimplexRing := function ( surf, base, face )

    local f, e,  edges, faces, inneredges, B, ve, siri, obj,  coloursOfEdges;

    faces := [face];
    edges := EdgesOfFace(surf, face);
    # the inner edges of the face <face>
    inneredges := Difference( edges, base );
    B := ShallowCopy(base);

    # we pick one edge and start walking from there
    e := inneredges[1];
    f := NeighbourFaceByEdge( surf, face, e);
    while f <> fail and f <> face do
	Add( faces, f);
	Add(B, e);
        edges := Difference(EdgesOfFace(surf, f),B);
	if Length(edges) <> 1 then
	    Error("base is not a base set for the surface");
        fi;
	e := edges[1];
        f := NeighbourFaceByEdge( surf, f, e);
	if f = fail then
	    # we hit a boundary edge, so we now have to go back
	    # to face and walk in the other direction
	    e := inneredges[2];
	    f := NeighbourFaceByEdge( surf, face, e);
	    # now we turned around. However, we will not turn around
	    # again as the edges we used are added to B
	fi;
    od;

    edges := List( faces, f-> EdgesOfFace(surf,f));
    edges := Union(edges);
    ve := [];
    for e in edges do
        ve[e] := VerticesOfEdge(surf,e);
    od;
    edges := [];
    for f in faces do
        edges[f] := EdgesOfFace(surf,f);
    od;
    siri := SimplicialSurfaceByDownwardIncidence( ve, edges);
    edges := Edges(siri);

    if IsEdgeColouredPolygonalComplex(surf) then
            obj := Objectify( EdgeColouredPolygonalComplexType, rec() );
            SetPolygonalComplex(obj, siri);

            if IsIsoscelesColouredSurface(surf) then
                SetIsIsoscelesColouredSurface(obj, true);
	    elif IsWildColouredSurface(surf) then
                SetIsWildColouredSurface(obj, true);
	    fi;

            coloursOfEdges := [];
            for e in edges do
                coloursOfEdges[e] :=
		ColoursOfEdges(surf)[e];
            od;
            SetColoursOfEdges(obj, coloursOfEdges);

            return obj;
    fi;
    return siri;

end;

FacesAsRing := function (surf, base)

    local f, e,  edges, face, faces, inneredges, B;

    face := Faces(surf)[1];
    faces := [face];
    edges := EdgesOfFace(surf, face);
    # the inner edges of the face <face>
    inneredges := Difference( edges, base );
    B := ShallowCopy(base);

    # we pick one edge and start walking from there
    e := inneredges[1];
    f := NeighbourFaceByEdge( surf, face, e);
    while f <> fail and f <> face do
	Add( faces, f);
	Add(B, e);
        edges := Difference(EdgesOfFace(surf, f),B);
	if Length(edges) <> 1 then
	    Error("base is not a base set for the surface");
        fi;
	e := edges[1];
        f := NeighbourFaceByEdge( surf, f, e);
	if f = fail then
	    # we hit a boundary edge, so we now have to go back
	    # to face and walk in the other direction
	    faces := Reversed(faces);
	    e := inneredges[2];
	    f := NeighbourFaceByEdge( surf, face, e);
	    # now we turned around. However, we will not turn around
	    # again as the edges we used are added to B
	fi;
    od;

    return faces;


end;

#BaseEdgeOfFace:=function ( surf, base, face )
#    local e;
#    e := Intersection( EdgesOfFace( surf, face ), base );
#    if Length(e) <> 1 then
#        Error("<base> is not a base set for surface");
#    fi;
#    return e[1];
#end;


BaseEdgeDegreeOfVertex:=function ( surf, base, v )
    return Size( Intersection( EdgesOfVertex( surf, v ), base ) );
end;

BaseGraph:=function(surf,B)
return List(B,i->List(B,j->Size(Intersection(VerticesOfEdge(surf,i),VerticesOfEdge(surf,j)))));
end;

BaseEdgeOfFaceByBase := function( surf, base, face)

    local e;
    
    e := Intersection(EdgesOfFace(surf,face),base);
    if Size(e) <> 1 then
        return fail;
    fi;
    return e[1];
end;    
    
ApexVertexOfFaceByBase := function( surf, base, face )

    local v, b;

    b := BaseEdgeOfFaceByBase(surf, base, face);
    if b = fail then return fail; fi;
    v := Difference( VerticesOfFace(surf, face),
                     VerticesOfEdge(surf, b )     );
    if Size(v) <> 1 then
        return fail;
    fi;

    return v[1];
end;

#! This function walks from one face of a simplex ring to the next
#! It returns a list L such that L[i] = 0 if the base edges of
#! the i-th and the (i+1)-st face do not share a vertex and 
#! L[i] = 1 if they do share a vertex.
#!
AnalyseSimplexRing := function(surf, base, face)
    local ring, boundary, ll, faces;

    # compute the simplex ring on face
    ring := SimplexRing(surf, base, face);
    faces := FacesAsRing( ring, base);
    
    # the boundary of the simplex ring
    boundary := List(faces,i->Intersection(EdgesOfFace(surf,i),base)[1]);
    ll:=Size(boundary);
    
    boundary[ll+1] := boundary[1];
    boundary := List(boundary ,i->VerticesOfEdge(surf,i));
    
    return List([1..ll],i->Size(Intersection(boundary[i],boundary[i+1])));
end;

VerSimplexRing := function(surf, base, face)
    local ring, faces, boundary, ll, spitze;

    ring:=SimplexRing(surf, base, face);
    faces := FacesAsRing( ring, base);
    boundary := List(faces,i->BaseEdgeOfFaceByBase( ring, i, base));
    ll := Size(boundary);

    spitze := List([1..ll],i->ApexVertexOfFaceByBase( surf, base, face ));
    if fail in spitze then return fail; fi;
    
    return List([1..ll],i->
    [boundary[i],VerticesOfEdge(surf,boundary[i]),spitze[i]]);
end;


NeighbourFacesByBase:= function ( surf, base, face )
    local faces, f;

    faces := FacesOfEdge( surf, BaseEdgeOfFaceByBase(surf, base, face));
    f := Difference(faces,[face]);
    if Length(f) <> 1 then return fail; fi;
    return f[1];
end;


#! For the simplex ring in surf starting at the face <face> return
#! a list of faces opposite the base

OppositeFacesOfSimplexRing := function ( surf, base, face )
    local siri, faces;

    siri :=  SimplexRing( surf, base, face );
    faces := FacesAsRing( siri, base);
    return List( faces, i-> NeighbourFacesByBase( surf, base, i ) );

end;


# This function applies a permutation <p> to a list <li>, that is, it
# permutes the entries in li according to <p>

OnList := function ( li, p )

        local i;

        if not IsPerm(p) then
            Error("OnList: <p> must be a permutation");
            return;
        fi;
    
        p := ListPerm( p );
        for i in [ Length( p ) + 1 .. Length( li ) ] do
            p[i] := i;
        od;

        return List( p, i-> li[i] );
end;



### Sollte Farbe erben
ButterflyArrangement := function( surf, BaseComp)

    local faces;

    faces := List( BaseComp, e -> FacesOfEdge( surf, e) );
    faces := Union(faces);
#    return SubcomplexByFaces(surf, faces);
    return ColouredSubsurface(surf, faces);

end;

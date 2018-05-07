#! @DoNotReadRestOfFile

# Methods to determine isomorphism between incidence graphs:
# GRAPE: GraphIsomorphism
# NautyTracesInterface: IsomorphismGraphs
# Digraphs: IsomorphismDigraphs
# for details refer to their respective documentations.
# 
# Problem: They seem to ignore the labels of the vertices..

#! @Section Group action
#! @SectionLabel Graphs_Action
#! 
#! This section uses the incidence graph of section
#! <Ref Sect="Section_Graphs_Incidence"/> to define a group action on
#! polygonal complexes.
#! Since vertices, edges and faces of a polygonal complex can share
#! labels it is not obvious how a permutation changes these labels.
#!
#! Instead the permutations acting on polygonal complexes are interpreted
#! as acting on their incidence graphs. In other words, the labels of the
#! original polygonal complex are modified:
#! @InsertChunk Graphs_LabelShift
#!

#! @BeginGroup OnPolygonalComplexes
#! @Description
#! Compute the image of <A>complex</A> under the action of <A>perm</A>.
#! To do this the permutation has to be separated into three different
#! permutations acting on vertices, edges and faces respectively.
#!
#! To describe this separation, let <E>maxVert</E> the maximal vertex label
#! and <E>maxEdge</E> be the maximal edge label.
#! * <K>ActionOnVertices</K>: For all numbers between 1 and 
#!   <E>maxVert</E> the permutation
#!   acts on the vertices of <A>complex</A>.
#! * <K>ActionOnEdges</K>: For numbers between <E>maxVert</E> + 1 and 
#!   <E>maxVert</E> + <E>maxEdge</E> the permutation acts on the edges
#!   of <A>complex</A>, after all of these numbers are shifted downwards 
#!   by <E>maxVert</E>.
#! * <K>ActionOnFaces</K>: For numbers above <E>maxVert</E> + <E>maxEdge</E>
#!   the permutation acts on the faces of <A>complex</A>, after all of the
#!   numbers are shifted downwards by <E>maxVert</E> + <E>maxEdge</E>.
#!
#! If this shift is not possible for <A>perm</A> and its inverse, <K>fail</K>
#! is returned. Since the maximal vertex and edge labels may change
#! after applying a permutation, the result of <K>DisplayAsIsomorphism</K>
#! is only guaranteed to be correct for one application of <A>perm</A>.
#!
#! TODO example and maybe restructure this section
#!
#! @Returns a polygonal complex
#! @Arguments complex, perm
DeclareOperation( "OnPolygonalComplexes", [IsPolygonalComplex, IsPerm] );
#! @Returns a list of three permutations (on vertices, edges and faces)
#! @Arguments complex, perm
DeclareOperation( "DisplayAsIsomorphism", [IsPolygonalComplex, IsPerm] );
#! @EndGroup


#######################################
##
##      Group action
##
InstallMethod( DisplayAsIsomorphism, 
    "for a polygonal complex and a permutation",
    [IsPolygonalComplex, IsPerm],
    function(complex, perm)
        local split1, split2, perms, fromList, toList, newMaxVert, newMaxEdge;

        split1 := Maximum(Vertices(complex));
        split2 := split1 + Maximum(Edges(complex));
        perms := [];

        # Start with the vertices
        fromList := [1..split1];
        toList := List( fromList, s -> s^perm );
        perms[1] := PermListList(fromList, toList);
        newMaxVert := Maximum(toList);

        # The edges
        fromList := [1..split2-split1];
        toList := List( fromList, s -> (s+split1)^perm - newMaxVert );
        if ForAny(toList, x -> not IsPosInt(x)) then
            return fail;
        fi;
        perms[2] := PermListList(fromList, toList);
        newMaxEdge := Maximum(toList);

        # The faces
        fromList := [1..LargestMovedPoint(perm)-split2];
        toList := List(fromList, s -> (s+split2)^perm - newMaxVert - newMaxEdge);
        if ForAny(toList, x -> not IsPosInt(x)) then
            return fail;
        fi;
        perms[3] := PermListList(fromList, toList);

        return perms;
    end
);
# Problem: It is not possible to shift the boundaries between the dimensions in both directions with the same permutation

InstallMethod( OnPolygonalComplexes,
    "for a polygonal complex and a permutation",
    [IsPolygonalComplex, IsPerm],
    function(complex, perm)
        local perms, vertOfEdges, facesOfEdges, e, newEdge, obj;

        perms := DisplayAsIsomorphism(complex, perm);
        if perms = fail then
            return fail;
        fi;

        vertOfEdges := [];
        facesOfEdges := [];
        for e in Edges(complex) do
            newEdge := e^perms[2];
            vertOfEdges[newEdge] := OnSets( VerticesOfEdges(complex)[e], perms[1] );
            facesOfEdges[newEdge] := OnSets( FacesOfEdges(complex)[e], perms[3] );
        od;

        obj := Objectify( PolygonalComplexType, rec() );
        SetVerticesOfEdges(obj, vertOfEdges);
        SetFacesOfEdges(obj, facesOfEdges);
        return obj;
    end
);

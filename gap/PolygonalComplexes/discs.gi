

#############################################################################
##
#F IsEssentialDisc( <disc> ) . . . . . . . . test whether <disc> is essential
##
## A simplicial surface <disc> is called an essential simplicial disc, if
## it is a connected simplicial surface of Euler Characteristic 1, no
## inner vertex has degree less than 4, no boundary vertex has degree 1,
## no inner edge connects two boundary vertices and the disc has no 3-waists.
##

InstallMethod( IsEssentialDisc, 
    "for a simplicial surface",
    [IsTwistedPolygonalComplex],
    
      function( disc )

           local bound, v, inner, innerE, e;

           if not IsSimplicialSurface(disc) then return false; fi;

           if not IsConnected(disc) then return false; fi;
           if EulerCharacteristic(disc)<>1 then return false; fi;

           bound := BoundaryVertices(disc);
           # ensure that all boundary vertices have degree at least 2
           for v in bound do
               if DegreeOfVertex(disc,v) < 2 then return false; fi;
           od;
           inner := InnerVertices(disc);
           # ensure that all inner vertices have degree at least 4
           for v in inner do
               if DegreeOfVertex(disc,v) <= 3 then return false; fi;
           od;
           innerE := InnerEdges(disc);
            # ensure that all inner edges do not have two boundary vertices
           for e in innerE do
               v := VerticesOfEdge(disc,e);
               if  v[1] in bound and v[2] in bound then return false; fi;
           od;
           # ensure that the disc has no 3-waists
           if Length(AllThreeWaistsOfComplex(disc)) > 0 then return false; fi;
           return true;
end
);



#############################################################################
##
## A relevant 2-path in an essential disc D is a pair of edges of D sharing
## exactly one vertex W such that the two edges are not adjacent to one
## common face.
## Find all relevant 2-paths up to the action of the automorphism
## group of the surface <surf>
##

BindGlobal( "__SIMPLICIAL_AllEssentialTwoPaths",
    function( surf )

        local vertices, i, t, umbti, u, relpaths, mp, twosets, isgood,
              aut, orbs, isNewInOrb, li;

        umbti := UmbrellaTipDescriptorOfSurface(surf);
        relpaths := [];

        #check if a two-set t contains two neighbouring vertices
        isgood := function(t,u)
            if IsPerm(u) then
                if t[1]^u=t[2] then return false; fi;
                if t[2]^u=t[1] then return false; fi;
            else
               if Position(u,t[1]) = Position(u,t[2]) + 1 or
                  Position(u,t[1]) = Position(u,t[2]) - 1 then
                    return false;
               fi;
            fi;
            return true;
        end;

        isNewInOrb := function(t)

            local j;

            if Length(orbs) = 0 then return true; fi;

            for j in [1 .. Length(orbs)] do
                if t in orbs[j] then return false; fi;
            od;

            return true;
        end;


        aut := AutomorphismGroupOnVertices(surf);
        orbs := [];

        for i in [1 .. Length(umbti)] do
            if IsBound(umbti[i]) then
                # Construct all 2-paths with middle vertex i
                u := umbti[i];
                if IsPerm(u) then
                    # vertex i is inner
                    mp := MovedPoints(u);
                else
                    # vertex i is a boundary vertex. 
                    mp := umbti[i];
                fi;
                # from every vertex in mp we can find a 2-path
                # to any other via i. Just remove non-relevant paths
                twosets := Combinations(mp, 2);
                twosets := Filtered(twosets, t-> isgood(t,u));
                li := List(twosets, t-> [t[1],i,t[2]]);
                for t in li do
                    if isNewInOrb(t) then
                        Add(orbs, Orbit( aut, t, OnTuples) );
                        Add(relpaths, t);
                    fi;
                od;
             fi;
        od;



        return relpaths;

end
);







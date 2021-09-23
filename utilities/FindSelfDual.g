FindSelfDual := function( d )
    local Hd, subs, orbs, F, a, b, c, R, bads, interfree,
    orb, add, o, bad, iota, ret, invOrb;

    F := FreeGroup( "a", "b", "c");
    a := F.1;; b := F.2;; c := F.3;
    R := [a^2, b^2, c^2, (a*b)^3, (a*c)^2, (b*c)^d, (b*a*c)^d ];
    Hd := F/R;

    subs := AllSubgroups(Hd);
    orbs := Orbits(Hd, subs, OnPoints);

    # Check intersection condition
    # Conjugate a with (ba) to get b
    # No need to check ac if c is checked (and we use iota later)
    bads := [ Group(Hd.1), Group(Hd.3), Group(Hd.1*Hd.2), Group(Hd.2*Hd.3) ];
    # Check with c could be removed for odd d (if necessary)
    interfree := [];
    for orb in orbs do
        add := true;
        for o in orb do
            if not add then
                break;
            fi;
            for bad in bads do
                if Size(Intersection(o,bad)) > 1 then
                    add := false;
                    break;
                fi;
            od;
        od;

        if add then
            Add(interfree, orb);
        fi;
    od;

    # Check invariance condition
    iota := GroupHomomorphismByImages(Hd,Hd, [Hd.1,Hd.2,Hd.3], [Hd.1, Hd.2, Hd.1*Hd.3]);
    ret := [];
    for orb in interfree do
        # This is independent of the concrete representative
        if Image(iota, orb[1]) in orb then;
            Add(ret, orb);
        fi;
    od;

    return [Hd, ret];
end;


InitAlphaBeta := function(d, nrFaces)
    local i, alphaChains, betaChains, baForwardChain, baBackwardChain,
        base, alphaRec, betaRec, baRec, wreath;

    alphaChains := [];
    betaChains := [];
    baForwardChain := [];
    baBackwardChain := [];

    for i in [1..nrFaces] do
        base := 6 * (i-1);

        alphaChains[base+1] := [1, base+2];
        alphaChains[base+2] := [1, base+1];
        alphaChains[base+3] := [1, base+4];
        alphaChains[base+4] := [1, base+3];
        alphaChains[base+5] := [1, base+6];
        alphaChains[base+6] := [1, base+5];

        betaChains[base+1] := [1, base+6];
        betaChains[base+2] := [1, base+3];
        betaChains[base+3] := [1, base+2];
        betaChains[base+4] := [1, base+5];
        betaChains[base+5] := [1, base+4];
        betaChains[base+6] := [1, base+1];

        baForwardChain[base+1] := [1, base+3];
        baForwardChain[base+2] := [1, base+6];
        baForwardChain[base+3] := [1, base+5];
        baForwardChain[base+4] := [1, base+2];
        baForwardChain[base+5] := [1, base+1];
        baForwardChain[base+6] := [1, base+4];

        baBackwardChain[base+1] := [1, base+5];
        baBackwardChain[base+2] := [1, base+4];
        baBackwardChain[base+3] := [1, base+1];
        baBackwardChain[base+4] := [1, base+6];
        baBackwardChain[base+5] := [1, base+3];
        baBackwardChain[base+6] := [1, base+2];
    od;

    alphaRec := rec( directed := false, max := 2, chain := alphaChains );
    betaRec := rec( directed := false, max := d, chain := betaChains );
    baRec := rec( directed := true, max := d, forward := baForwardChain, backward := baBackwardChain );
    wreath := WreathProduct( Group( (1,2)(3,6)(4,5), (1,6)(2,5)(3,4) ), SymmetricGroup(nrFaces) );
    return [alphaRec, betaRec, baRec, wreath, PermList( List( alphaRec.chain, i->i[2] ) ), PermList( List( betaRec.chain, i->i[2] ) )];
end;

InitAlphaGamma := function(d, nrFaces)
    local i, alphaChains, gammaChains, agChains, base,
        alphaRec, gammaRec, agRec, wreath;

    alphaChains := [];
    gammaChains := [];
    agChains := [];
    for i in [1..3*nrFaces/2] do
        base := 4 * (i-1);

        alphaChains[base+1] := [1, base+2];
        alphaChains[base+2] := [1, base+1];
        alphaChains[base+3] := [1, base+4];
        alphaChains[base+4] := [1, base+3];

        gammaChains[base+1] := [1, base+4];
        gammaChains[base+2] := [1, base+3];
        gammaChains[base+3] := [1, base+2];
        gammaChains[base+4] := [1, base+1];

        agChains[base+1] := [1, base+3];
        agChains[base+2] := [1, base+4];
        agChains[base+3] := [1, base+1];
        agChains[base+4] := [1, base+2];
    od;

    alphaRec := rec( directed := false, max := 3, chain := alphaChains );
    gammaRec := rec( directed := false, max := d, chain := gammaChains );
    agRec := rec( directed := false, max := d, chain := agChains );
    wreath := WreathProduct( Group( (1,2)(3,4), (1,4)(2,3) ), SymmetricGroup(3*nrFaces/2) );
    return [alphaRec, gammaRec, agRec, wreath, PermList( List( alphaRec.chain, i->i[2] ) ), PermList( List( gammaRec.chain, i->i[2] ) )];
end;

InitBetaGamma := function(d, nrFaces)
    local i, betaChains, gammaChains, gbForwardChain, gbBackwardChain,
        j, betaRec, gammaRec, gbRec, base, gen1, gen2, dih, wreath;

    betaChains := [];
    gammaChains := [];
    gbForwardChain := [];
    gbBackwardChain := [];
    for i in [1..3*nrFaces/d] do
        # Define 2d elements
        base := 2*d * (i-1);
        
        betaChains[base+1] := [1, base+2];
        betaChains[base+2] := [1, base+1];

        gammaChains[base+1] := [1, base+2*d];
        gammaChains[base+2] := [1, base+3];

        gbForwardChain[base+1] := [1, base+3];
        gbForwardChain[base+2] := [1, base+2*d];
        gbBackwardChain[base+1] := [1, base+2*d-1];
        gbBackwardChain[base+2] := [1, base+4];

        for j in [2..d-1] do
            betaChains[base+2*j-1] := [1, base+2*j];
            betaChains[base+2*j] := [1, base+2*j-1];

            gammaChains[base+2*j-1] := [1, base+2*j-2];
            gammaChains[base+2*j] := [1, base+2*j+1];

            gbForwardChain[base+2*j-1] := [1, base+2*j+1];
            gbForwardChain[base+2*j] := [1, base+2*j-2];
            gbBackwardChain[base+2*j-1] := [1, base+2*j-3];
            gbBackwardChain[base+2*j] := [1, base+2*j+2];
        od;

        betaChains[base+2*d-1] := [1, base+2*d];
        betaChains[base+2*d] := [1, base+2*d-1];

        gammaChains[base+2*d-1] := [1, base+2*d-2];
        gammaChains[base+2*d] := [1, base+1];

        gbForwardChain[base+2*d-1] := [1, base+1];
        gbForwardChain[base+2*d] := [1, base+2*d-2];
        gbBackwardChain[base+2*d-1] := [1, base+2*d-3];
        gbBackwardChain[base+2*d] := [1, base+2];
    od;

    gen1 := List( [1..2*d], i -> 2*d+1-i );
    gen2 := List( [1..2*d], i -> i+2 );
    gen2[2*d-1] := 1;
    gen2[2*d] := 2;
    dih := Group( [ PermList(gen1), PermList( gen2 ) ] );
    SetSize(dih, 2*d);
    wreath := WreathProduct(dih, SymmetricGroup(3*nrFaces/d));

    betaRec := rec( directed := false, max := 3, chain := betaChains );
    gammaRec := rec( directed := false, max := 2, chain := gammaChains );
    gbRec := rec( directed := true, max := d, forward := gbForwardChain, backward := gbBackwardChain );
    return [gammaRec, betaRec, gbRec, wreath, PermList(List(betaRec.chain, i->i[2])), PermList(List(gammaRec.chain, i->i[2]))];
end;


AddArrow := function( dirChain, i, j )
    local b, f, len;

    # Combine target i (backward[i]) with source j (forward[j])
    b := dirChain.backward[i];
    f := dirChain.forward[j];

    # Check if we identify two end of the same chain
    if b[2] = j then
        if b[1] = dirChain.max then
            # chain can be closed
            Unbind( dirChain.backward[i] );
            Unbind( dirChain.forward[j] );
            return [];
        else
            return fail;
        fi;
    fi;

    # Now we work with two different chains
    len := b[1] + f[1]; 
    if len > dirChain.max then
        # impossible to combine
        return fail;
    fi;

    # In the other case we combine the chains
    # b[2] --b[1]-> i ----> j --f[1]-> f[2]
    dirChain.forward[b[2]] := [len, f[2]];
    dirChain.backward[f[2]] := [len, b[2]];
    Unbind( dirChain.forward[j] );
    Unbind( dirChain.backward[i] );

    if len = dirChain.max then
        # Additional forced identification
        return [f[2],b[2]];
    else
        return [];
    fi;
end;

AddBiArrowDirected := function( dirChain, pair )
    local res1, res2, forcedPairs, x;

    res1 := AddArrow(dirChain, pair[1], pair[2]);
    if res1 = fail then
        return fail;
    fi;

    res2 := AddArrow(dirChain, pair[2], pair[1]);
    if res2 = fail then
        return fail;
    fi;

    forcedPairs := [];
    if res1 <> [] then
        if res1[1] <= res1[2] then
            Add(forcedPairs, res1);
        else
            Add(forcedPairs, [res1[2],res1[1]]);
        fi;
    fi;
    if res2 <> [] then
        if res2[1] = res2[2] then
            return fail;
        elif res2[1] < res2[2] then;
            Add(forcedPairs, res2);
        else
            Add(forcedPairs, [res2[2],res2[1]]);
        fi;
    fi;
    return Difference( forcedPairs, [Set(pair)] );
end;

AddBiArrowUndirected := function( chain, pair )
    local a,b, len;

    # Check if two ends of the same chain are identified
    a := chain.chain[pair[1]];
    b := chain.chain[pair[2]];
    if a[2] = pair[2] then
        # Check if the length matches
        if a[1] = chain.max then
            Unbind( chain.chain[pair[1]] );
            Unbind( chain.chain[pair[2]] );
            return [];
        else
            return fail;
        fi;
    fi;

    # Now we have two different chains
    len := a[1] + b[1];
    if len > chain.max then
        return fail;
    fi;

    chain.chain[a[2]] := [len, b[2]];
    chain.chain[b[2]] := [len, a[2]];
    Unbind(chain.chain[pair[1]]);
    Unbind(chain.chain[pair[2]]);

    if len = chain.max then
        # Additional forced identification
        if a[2] = b[2] then
            return fail; # this is impossible to fulfill
        elif a[2] < b[2] then
            return [ [a[2],b[2]] ];
        else
            return [ [b[2],a[2]] ];
        fi;
    else
        return [];
    fi;
end;

AddBiArrow := function( chain, pair )
    if chain.directed then
        return AddBiArrowDirected(chain, pair);
    else
        return AddBiArrowUndirected(chain, pair);
    fi;
end;

# chains is a list of (un)directed chains to be completed
# ids is a set of forced identifications that have to be done
# currentPerm is the current incomplete permutation
# stabiliser is the stabiliser of this permutation (used for branching)
SelfDualPermRepRecursive := function( chains, ids, currentPerm, stabiliser)
    local id, res, chain, first, i, j, sol, chainCopy, stab, orb, orbs,
        point_stab, newStab;

#    Print("     Recursion step ENTER");
    # First handle all forced identifications
    while IsBound(ids[1]) do
        id := ids[1];
        ids := ids{[2..Length(ids)]};

        for chain in chains do
            res := AddBiArrow(chain, id);
            if res = fail then
                return [];
            fi;
            currentPerm := currentPerm * (id[1],id[2]);
            Append(ids, res);
        od;
        ids := Set(ids);
    od;

#    Print("     Recursion step: forced ids handled\n");

    # Branch out if necessary (assuming the first chain is undirected)

    # Find first unused value
    first := 0;
    for i in [1..Length(chains[1].chain)] do
        if IsBound(chains[1].chain[i]) then
            first := i;
            break;
        fi;
    od;
    if first = 0 then # everything done
        return [currentPerm];
    fi;

#    Print("     Recursion step: first unused: ", first, "\n");

    # Compute the new stabiliser
    stab := stabiliser;
# While this would be the "better" stabiliser (it leads to less branching),
# the cost of computing is too high (factor of 12 for d = 6, nr = 18). The
# cost of higher branching is not significant enough to outweigh the cost
# of computing many stabiliser chains
#    stab := Stabiliser( stabiliser, currentPerm );

#    Print("     Recursion step: Recompute stabiliser\n");

    # otherwise branch out
    sol := [];
    point_stab := Stabiliser(stab,first);
    orbs := Orbits( point_stab, [first+1..Length(chains[1].chain)] );
    for orb in orbs do
        j := First(orb, k -> k > first and IsBound(chains[1].chain[k]));
        if j = fail then
            continue;
        fi;
        chainCopy := List(chains, StructuralCopy);
        
        newStab := Stabiliser(point_stab, j);
        Append(sol, SelfDualPermRepRecursive( chainCopy, [[first,j]], currentPerm, newStab ));
    od;

    return sol;
end;

SelfDualPermRepGeneral := function( d, nrFaces, type )
    local chains, beta, gamma, currentPerm, sol, stab, orbs, res, sym,
        s, trueSol, new, old, check, selfDual;

    # Check divisibility condition
    res := d mod 6;
    if res = 0 then
        if nrFaces mod (d/3) <> 0 then
            return [];
        fi;
    elif res = 1 then
        if nrFaces mod (2*d) <> 0 then
            return [];
        fi;
    elif res = 2 then
        if nrFaces mod d <> 0 then
            return [];
        fi;
    elif res = 3 then
        if nrFaces mod (2*d/3) <>  0 then
            return [];
        fi;
    elif res = 4 then
        if nrFaces mod d <> 0 then
            return [];
        fi;
    elif res = 5 then
        if nrFaces mod (2*d) <> 0 then
            return [];
        fi;
    fi;

#    Print("Divisibility checks done\n");

    if type = 1 then
        chains := InitBetaGamma(d,nrFaces);
    elif type = 2 then
        chains := InitAlphaGamma(d, nrFaces);
    else
        chains := InitAlphaBeta(d, nrFaces);
    fi;
#    beta := chains[5];
#    gamma := chains[6];
    currentPerm := ();

#    Print("Initialisation done\n");

    # The stabiliser is a wreath product of 
    # -> The automorphism group of one orbit (dihedral group of size 6, 4 or 2d)
    # -> A symmetric group permuting the orbits
    stab := chains[4];

    sol := Set( SelfDualPermRepRecursive(chains{[1,2,3]}, [], currentPerm, stab) );

#    Print("Solutions computed\n");

    # Compute isomorphism representatives
    trueSol := [];
    for s in sol do
        if type = 1 then
            check := [s,chains[5],chains[6]];
        elif type = 2 then
            check := [chains[5],s,chains[6]];
        else
            check := [chains[5],chains[6],s];
        fi;
#        check := [s,beta,gamma];
        new := true;
        for old in trueSol do
            # We only have to check the action of the stabiliser since two of the entries are stabilised by it
            if RepresentativeAction(stab, check, old, OnTuples) <> fail then
                new := false;
                break;
            fi;
        od;
        if new then
            Add(trueSol, check);
        fi;
    od;

    selfDual := [];
    for sol in trueSol do
        if RepresentativeAction(SymmetricGroup(6*nrFaces), sol, [sol[1],sol[2],sol[1]*sol[3]], OnTuples) <> fail then
            Add(selfDual,sol);
        fi;
    od;
#    Print("Isomorphism test done\n");

    return selfDual;
end;

SelfDualPermRep := function(d,nrFaces)
    return SelfDualPermRepGeneral(d,nrFaces,2);
end;

TestMethod := function(d,nrFaces)
    local r, sol;

    sol := [];
    
    r := Runtime();
    sol[1] := SelfDualPermRepGeneral(d,nrFaces,1);
    r := Runtime() - r;
    Print("Finding alpha: ", r, "\n");

    r := Runtime();
    sol[2] := SelfDualPermRepGeneral(d,nrFaces,2);
    r := Runtime() - r;
    Print("Finding beta: ", r, "\n");

    r := Runtime();
    sol[3] := SelfDualPermRepGeneral(d,nrFaces,3);
    r := Runtime() - r;
    Print("Finding gamma: ", r, "\n");

    return sol;
end;

grp := Group( 

[ (1,2)(3,4)(5,7)(6,8)(9,11)(10,12),
 (1,10)(3,9)(2,12)(4,11)(5,6)(7,8),
 (1,7)(2,3)(4,11)(5,12)(6,8)(9,10),
 (1,12)(3,9)(2,10)(4,11)(5,7)(6,8)]

        );

subgroupA5 := Subgroup(grp, 
[ (1,2)(3,4)(5,7)(6,8)(9,11)(10,12),
 (1,10)(3,9)(2,12)(4,11)(5,6)(7,8),
 (1,7)(2,3)(4,11)(5,12)(6,8)(9,10) ] );

# g sei eine Permutation
# M sei eine Matrix
PermAct := function ( M, g )
    local gi, m;

    m := Length(M);
    gi := g^-1;
    return M{ListPerm(g,m)}{ListPerm(gi,m)};

end;



# return an orbit representative and the stabilizer

BahnGramMat := function( M, G )
 
        local o;

        return Orbit( G, M, PermAct );

end;


RepresentativeGramMatrices := function ( grp, GramMatrices )

        local allorbs, i, stabs, reps;

        allorbs := Orbits( grp, GramMatrices, PermAct );
         
        reps := List( allorbs, i-> i[1] );

        stabs := List( reps, i-> Stabilizer(grp, i, PermAct ));

        return List([1..Length(reps)], i-> [reps[i],stabs[i]]);

end;

Chirality := function ( subgrp, repstab )

         return IsSubgroup( subgrp, repstab[2] );

end;
           
NrOfGeometricVertices := function( repstab )

        return Size( Set ( repstab[1] ) );

end;

PrintRepresentatives := function (subgrpA5, grp, GramMatrices, filename)

        local repstab, r, cmp;


        cmp := function( r1, r2 )

            return NrOfGeometricVertices( r1 ) <= NrOfGeometricVertices( r2 );

        end;

        repstab := RepresentativeGramMatrices(grp,GramMatrices);

        Sort( repstab, cmp);

        PrintTo(filename, "# Representatives of the Icosahedron\n");
        AppendTo(filename, "IcosahedronRepresentatives := [\n");
        

        for r in repstab do
            AppendTo( filename, "rec( \n");
            AppendTo( filename, " NrGeometricVertices := ", 
                                  NrOfGeometricVertices(r), ",\n");
            AppendTo( filename, " stabilizer := ", r[2], ",\n");
            AppendTo( filename, " chirality := ", 
                                  Chirality( subgroupA5,r), ",\n");
            AppendTo( filename, " representative := ", r[1], "),\n");
       od;

       AppendTo( filename, "]; ");
        


end;

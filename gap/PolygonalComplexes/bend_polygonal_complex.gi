#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2016
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################


InstallMethod( LocalFlags, "for a bend polygonal complex", 
    [IsBendPolygonalComplex],
    function(bendComplex)
        local res, f, i, max;

        res := [];
        for f in Faces(bendComplex) do
            max := Length( EdgesOfFaces(bendComplex)[f] );
            for i in [1..max do
                if i = 1 then
                    Add(res, [i,max]);
                else
                    Add(res, [i,i-1]);
                fi;

                if i = max then
                    Add(res, [i,1]);
                else
                    Add(res, [i,i+1]);
                fi;
            od;
        od;

        return res;
    end
);

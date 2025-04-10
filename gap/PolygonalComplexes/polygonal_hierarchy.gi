#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2025
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################


# We define a generic representation for twisted polygonal complexes
DeclareRepresentation("IsGenericTwistedPolygonalComplexRep", 
    IsTwistedPolygonalComplex and IsAttributeStoringRep, []);

# Define a generic type
BindGlobal( "TwistedPolygonalComplexType", 
    NewType( TwistedPolygonalComplexFamily, IsGenericTwistedPolygonalComplexRep ));





##
## All of the filters
## * IsTriangularComplex
## * IsPolygonalSurface
## * IsSimplicialSurface
## should act like categories
InstallOtherMethod( IsPolygonalComplex, "for an object", [IsObject],
    function(obj)
        if not IsTwistedPolygonalComplex(obj) then
            return false;
        fi;
        # Since IsPolygonalComplex is a category, the above
        # check can't change anything
        TryNextMethod();
    end
);
InstallOtherMethod( IsTriangularComplex, "for an object", [IsObject],
    function(obj)
        if not IsPolygonalComplex(obj) then
            return false;
        fi;
        # Since IsPolygonalComplex is a category, the above
        # check can't change anything
        TryNextMethod();
    end
);
InstallOtherMethod( IsPolygonalSurface, "for an object", [IsObject],
    function(obj)
        if not IsPolygonalComplex(obj) then
            return false;
        fi;
        # Since IsPolygonalComplex is a category, the above
        # check can't change anything
        TryNextMethod();
    end
);


##
InstallMethod( IsPolygonalComplex, "for a twisted polygonal complex", [IsTwistedPolygonalComplex],
    function(compl)
        return true;#REM
    end
);

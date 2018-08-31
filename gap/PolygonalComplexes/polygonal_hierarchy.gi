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


# We define a generic representation for polygonal complexes
DeclareRepresentation("IsGenericPolygonalComplexRep", 
    IsPolygonalComplex and IsAttributeStoringRep, []);

# Define a generic type
BindGlobal( "PolygonalComplexType", 
    NewType( PolygonalComplexFamily, IsGenericPolygonalComplexRep ));


# We define a generic representation for polygonal complexes
DeclareRepresentation("IsGenericBendPolygonalComplexRep", 
    IsBendPolygonalComplex and IsAttributeStoringRep, []);

# Define a generic type
BindGlobal( "BendPolygonalComplexType", 
    NewType( BendPolygonalComplexFamily, IsGenericBendPolygonalComplexRep ));



##
## All of the filters
## * IsTriangularComplex
## * IsPolygonalSurface
## * IsSimplicialSurface
## should act like categories
InstallOtherMethod( IsPolygonalComplex, "for an object", [IsObject],
    function(obj)
        if not IsVEFComplex(obj) then
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



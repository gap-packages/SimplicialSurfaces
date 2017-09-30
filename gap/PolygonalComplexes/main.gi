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

# Set up the attribute scheduler
BindGlobal( "SIMPLICIAL_ATTRIBUTE_SCHEDULER", AttributeScheduler([]) );

#TODO make this method a native part of the attribute scheduler
BindGlobal( "__SIMPLICIAL_AddPolygonalAttribute", 
    function( attr )
        InstallMethod(attr, "for a polygonal complex",
            [IsPolygonalComplex],
            function( complex )
                return ComputeProperty(SIMPLICIAL_ATTRIBUTE_SCHEDULER,
                    attr, complex);
            end);
    end
);

BindGlobal( "__SIMPLICIAL_AddRamifiedAttribute",
    function( attr )
        InstallMethod(attr, "for a ramified polygonal surface",
            [IsRamifiedPolygonalSurface],
            function( ramSurf )
                return ComputeProperty(SIMPLICIAL_ATTRIBUTE_SCHEDULER,
                    attr, ramSurf);
            end);
        RedispatchOnCondition(attr, true, [IsPolygonalComplex], 
                [IsRamifiedPolygonalSurface], 0);
        #TODO install a general error if only a polygonal complex is given
    end
);

BindGlobal( "__SIMPLICIAL_AddSurfaceAttribute",
    function( attr )
        InstallMethod(attr, "for a polygonal surface",
            [IsPolygonalSurface],
            function( surface )
                return ComputeProperty(SIMPLICIAL_ATTRIBUTE_SCHEDULER,
                    attr, surface);
            end);
        RedispatchOnCondition(attr, true, [IsPolygonalComplex],
                [IsRamifiedPolygonalSurface and IsPolygonalSurface], 0);
    end
);

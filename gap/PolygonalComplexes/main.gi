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

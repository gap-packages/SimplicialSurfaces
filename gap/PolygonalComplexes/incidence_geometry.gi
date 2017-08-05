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

InstallMethod( Vertices, "for a polygonal complex", [IsPolygonalComplex],
	function(complex)
		return VerticesAttributeOfPolygonalComplex( complex );
	end
);



# methods to compute number of vertices, edges, faces
InstallMethod( NrOfVertices, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
            return Length( Vertices(complex) );
    end
);

InstallMethod( NrOfEdges, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
            return Length( Edges(complex) );
    end
);

InstallMethod( NrOfFaces, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
            return Length( Faces(complex) );
    end
);



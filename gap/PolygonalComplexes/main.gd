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

# This is the main file for polygonal complexes. It is used for general stuff
# that should be read before the other files

# The custom info class
DeclareInfoClass( "InfoSimplicial" );


# Attribute for colour information
DeclareAttribute( "ViewInformation", IsPolygonalComplex );
DeclareAttribute( "DisplayInformation", IsPolygonalComplex );




#!	@Description
#!	Takes a surface and maps between from the faces, edges and vertices, and returns the surface
#!	under the mapping. The maps are given as lists, with the position of the list indexed by
#!	the input of the map (that is, the face/edge/vertex of the given surface) and the value at
#!	that position is the image under the map.
#!	@Arguments A polygonal surface, facemap, edgemap, vertexmap
#!	@Returns a simplicial surface
DeclareOperation( "MappingOfSurfaces", [IsPolygonalSurface, IsList, IsList, IsList]);

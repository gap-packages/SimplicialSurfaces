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

#TODO duality where combining and cutting method are described together?

# disjoint union <-> Subsurface


# Connected sum over
# * face
# * edge (where edge blows up)
# <-> Separation at two-waist or three-waist

# cut/mend edges

# These do not fit the above pattern:
# SnippOffEars
# CommonCover
# DualSurface
# AddVertexIntoEdge (and the rest of Jesse's stuf)

DeclareOperation( "SubcomplexByFaces", [IsPolygonalComplex, IsSet] );
DeclareOperation( "SubcomplexByFacesNC", [IsPolygonalComplex, IsSet] );

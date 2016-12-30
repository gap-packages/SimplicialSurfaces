


## From now on, we can do "Objectify( SimplicialSurfaceType, re )" 
## for any list re
GenericSimplicialSurfaceType := 
    NewType( SimplicialSurfaceFamily, IsGenericSimplicialSurfaceRep );

## Constructor
DeclareGlobalFunction( "GenericSimplicialSurfaceByList" );

##
##  The constructor GenericSimplicialSurface ensures that the simplicial surface
##  is stored inside a GAP object. 
##
GenericSimplicialSurface :=  function( simpsurf ) 
    
    return Objectify( GenericSimplicialSurfaceType, simpsurf );

end;

##
## Constructor that uses a list to initialize.
##
InstallGlobalFunction( GenericSimplicialSurfaceByList,
function( list )
	return GenericSimplicialSurface( rec(
		nrOfVertices := list[1],
		nrOfEdges := list[2],
		nrOfFaces := list[3],
		edges := list[4],
		faces := list[5] ) );
end
);



###############################################################################
##
#!  @Description
#!  This function removes one vertex of a generic simplicial surface
#!  <simpsurf>, along with all edges and faces that are adjacent to the vertex
#!  @Returns a generic simplicial surface without the given vertex.
#!  @Arguments <simpsurf> a generic simplicial surface, <vertex> the vertex to
#!		 be removed
#!
##
DeclareGlobalFunction( "RemoveVertexOfGenericSimplicialSurface" );





#############################################################################
##
##
#!  @Section Conversion functions for Generic Simplicial Surfaces
#!
#!
#!

DeclareGlobalFunction( "GenericSimplicialSurfaceFromFaceVertexPath" );
DeclareGlobalFunction( "FaceVertexPathFromGenericSimplicialSurface" );
DeclareGlobalFunction( "GenericSimplicialSurfaceFromWildSimplicialSurface" );

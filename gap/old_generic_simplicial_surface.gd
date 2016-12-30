


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

#############################################################################
##
#!  @Description
#!  Check if two generic simplicial surfaces are equal.
#!  @Returns true or false
#!  @Arguments <s1>, <s2>, two generic simplicial surface objects as created 
#!  by SimplicialSurface
#!
##
InstallMethod( \=, "for two generic simplicial surfaces", true, 
  [ IsGenericSimplicialSurfaceRep, IsGenericSimplicialSurfaceRep ], 0, 
		function( s1, s2 )

		if NrOfVerticesOfGenericSimplicialSurface(s1) <> 
			NrOfVerticesOfGenericSimplicialSurface(s2) then
			return false;
		fi;
		if NrOfEdgesOfGenericSimplicialSurface(s1) <> 
			NrOfEdgesOfGenericSimplicialSurface(s2) then
			return false;
		fi;
		if NrOfFacesOfGenericSimplicialSurface(s1) <> 
			NrOfFacesOfGenericSimplicialSurface(s2) then
			return false;
		fi;

		if EdgesOfGenericSimplicialSurface(s1) <> 
			EdgesOfGenericSimplicialSurface(s2) then
			return false;
		fi;
		if FacesOfGenericSimplicialSurface(s1) <> 
			FacesOfGenericSimplicialSurface(s2) then
			return false;
		fi;

        return true;

end);


#############################################################################
##
##  A Print method for generic simplicial surfaces
##

PrintGenericSimplicialSurface := function(simpsurf)

        Print("GenericSimplicialSurface( rec(\n");
        Print("nrOfVertices := ");
        Print(simpsurf!.nrOfVertices, ",\n");
        Print("nrOfEdges := ");
        Print(simpsurf!.nrOfEdges, ",\n");
        Print("nrOfFaces := ");
        Print(simpsurf!.nrOfFaces, ",\n");
        Print("edges := ");
        Print(simpsurf!.edges, ",\n");
        Print("faces := ");
        Print(simpsurf!.faces, "));\n");
end;

InstallMethod( PrintObj, "for GenericSimplicialSurface", true, 
               	[ IsGenericSimplicialSurfaceRep ], 0, 
				PrintGenericSimplicialSurface );


#############################################################################
##
##  A Display method for simplicial surfaces
##
DisplayGenericSimplicialSurface := function(simpsurf)

        Print("Number of vertices: ", simpsurf!.nrOfVertices, ",\n");
        Print("Number of edges: ", simpsurf!.nrOfEdges, ",\n");
        Print("Number of faces: ", simpsurf!.nrOfFaces, ",\n");
        Print("Edges: ", simpsurf!.edges, ",\n");
        Print("Faces: ", simpsurf!.faces);

end;

InstallMethod( Display, "for GenericSimplicialSurfaces", true, 
                   [IsGenericSimplicialSurfaceRep], 0, 
					DisplayGenericSimplicialSurface );

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

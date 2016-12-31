#############################################################################
##
#!  @Description
#!  Check if two generic simplicial surfaces are equal.
#!  @Returns true or false
#!  @Arguments <s1>, <s2>, two generic simplicial surface objects as created 
#!  by SimplicialSurface
#!
##
InstallMethod( \=, "for two generic simplicial surfaces", IsIdenticalObj, 
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


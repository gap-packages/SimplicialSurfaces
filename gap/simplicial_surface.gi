##############################################################################
##
#W  simplicial_surface.gi          Simplicial               Alice Niemeyer
#W                                                        Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Alice Niemeyer, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##
##  The functions in this file compute with simplicial surfaces.
##
##

#############################################################################
##
#!	@Description
#!	This function returns the number of vertices.
#!	@Returns an integer
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( NrOfVertices, "for a simplicial surfaces",
	[ IsSimplicialSurface ],
	function(simpsurf)
		return Length( Vertices(simpsurf) );
	end
);

#############################################################################
##
#!	@Description
#!	This function returns the number of edges.
#!	@Returns an integer
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( NrOfEdges, "for a simplicial surfaces",
	[ IsSimplicialSurface ],
	function(simpsurf)
		return Length( Edges(simpsurf) );
	end
);

#############################################################################
##
#!	@Description
#!	This function returns the number of faces.
#!	@Returns an integer
#!	@Arguments a simplicial surface object simpsurf
#!
InstallMethod( NrOfFaces, "for a simplicial surfaces",
	[ IsSimplicialSurface ],
	function(simpsurf)
		return Length( Faces(simpsurf) );
	end
);

#############################################################################
##
##
#!  @Description
#!  This function computes the Euler characteristic of a simplicial surface.
#!  The Euler characteristic is |V| - |E| + |F|, where |V| is the number of
#!  vertices, |E| is the number of edges and |F| is the number of faces.
#!  @Returns an integer, which is the Euler characteristic.
#!  @Arguments <simpsurf>, a simplicial surface object as created 
#!  by WildSimplicialSurface
#!
InstallMethod( EulerCharacteristic, "for a simplicial surface",
	[IsSimplicialSurface ],
function (simpsurf)

    local chi;

    if not IsSimplicialSurface(simpsurf) then
        Error("usage: EulerCharacteristic(simpsurf");
        return fail;
    fi;

    if IsBound(simpsurf!.EulerCharacteristic) then
        return simpsurf!.EulerCharacteristic;
    fi;

    chi :=    NrOfVertices(simpsurf)  # V
            - NrOfEdges(simpsurf)     # -E
            + NrOfFaces(simpsurf);    # +F


     simpsurf!.EulerCharacteristic := chi;

     return chi;

end);

#############################################################################
##
#!  @Description
#!	This function returns a list of integers (with holes). For each vertex-
#!	number it contains the number of faces which are incident to that vertex
#!	(the degree of the vertex).
#!  @Returns a list of integers
#!  @Arguments a simplicial surface object simpsurf
#!
InstallMethod( UnsortedDegrees, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local verticesByFaces;

		if IsBound( simpsurf!.unsortedDegrees ) then
			return simpsurf!.unsortedDegrees;
		fi;

		verticesByFaces := VerticesByFaces( simpsurf );
		simpsurf!.unsortedDegrees := List( verticesByFaces, i->Length(i) );
		return simpsurf!.unsortedDegrees;
	end
);

#############################################################################
##
#!  @Description
#!	This function returns a dense sorted list of integers that contains the 
#!	degrees of the vertices (with repetitions)
#!  @Returns a dense sorted list of integers
#!  @Arguments a simplicial surface object simpsurf
#!
InstallMethod( SortedDegrees, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local compact;

		if IsBound( simpsurf!.sortedDegrees ) then
			return simpsurf!.sortedDegrees;
		fi;

		compact := Compacted( UnsortedDegrees( simpsurf ) );
		Sort( compact );
		simpsurf!.sortedDegrees := compact;
		return compact;
	end;
 );

###############################################################################
##
#!  @Description
#!  This function returns the face-anomaly-classes of a simplicial surface.
#!	Two faces are in the same face-anomaly-class if they contain the same
#!	vertices.
#!  @Returns The face-anomaly-classes (as a list of sets)
#!  @Arguments <simpsurf> a simplicial surface
#!
InstallMethod( FaceAnomalyClasses, "for a simplicial surface",
	[IsSimplicialSurface],
	function(simpsurf)
		local facesByVertices, classes, i, found, cl, j;

		if IsBound( simpsurf!.faceAnomalyClasses ) then
			return simpsurf!.faceAnomalyClasses;
		fi;

		facesByVertices := FacesByVertices(simpsurf);
		classes := [];

		for i in [1..NrOfFaces(simpsurf)] do
			found := false;
			for j in [1..Length(classes)] do
				cl := classes[j];
				if Set( facesByVertices[i] ) = Set( facesByVertices[ cl[1] ] ) then
					classes[j] := Union( cl, [i] );
					found := true;
					break;
				fi;
			od;
			if not found then
				Append( classes, [ [i] ] );
			fi;
		od;

		simpsurf!.faceAnomalyClasses := classes;
		return simpsurf!.faceAnomalyClasses;
	end;
 );






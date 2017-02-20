LoadPackage("grape");
Read( "init.g" );
Read( "read.g" );

Read( "test.g" );


	surf := SimplicialSurfaceByVerticesInFaces( 4,4, [[1,2,3],[1,3,4],[3,2,4],[1,4,2]] );

	AdjacentVertices := function( list )
			local vertexSet, i;

			vertexSet := [ Set( [list[1], list[ Length(list) ] ] ) ];
			for i in [2..Length(list)] do
				Append( vertexSet, Set( [ list[i-1], list[i] ] ) );
			od;
			return Set(vertexSet);
		end;

#FacesByEdges

BindGlobal( "__SIMPLICIAL_IsCoordinates3D",
    function(surface, coordinates)
        local coord,i;
        if Filtered([1..Length(coordinates)],i->IsBound(coordinates[i])) <> Vertices(surface) then
            return false;
	fi;

        # Check whether all coordinates are 3D-coordinates
        for coord in coordinates do
            if not IsDenseList(coord) then
                return false;
            fi;
            if Length(coord) <> 3 then
                return false;
            fi;
        od;
        return true;
    end
);

InstallMethod( SetVertexCoordinates3D,
    "for a simplicial surface, a list of coordinates and a record",
    [IsSimplicialSurface, IsList, IsRecord],
    function(surface, coordinates, printRecord)
	if not __SIMPLICIAL_IsCoordinates3D(surface, coordinates) then
	    Error( " invalid coordinate format " );
	fi;
	return SetVertexCoordinates3DNC(surface, coordinates, printRecord);
    end
);
RedispatchOnCondition( SetVertexCoordinates3D, true, 
    [IsTwistedPolygonalComplex,IsList,IsRecord], 
    [IsSimplicialSurface, IsList], 0 );

InstallOtherMethod( SetVertexCoordinates3D,
    "for a simplicial surface and a list of coordinates",
    [IsSimplicialSurface, IsList],
    function(surface, coordinates)
	return SetVertexCoordinates3D(surface, coordinates, rec());
    end
);
RedispatchOnCondition( SetVertexCoordinates3D, true, 
    [IsTwistedPolygonalComplex,IsList], 
    [IsSimplicialSurface, IsList], 0 );

InstallMethod( SetVertexCoordinates3DNC,
    "for a simplicial surface, a list of coordinates and a record",
    [IsSimplicialSurface, IsList, IsRecord],
    function(surface, coordinates, printRecord)
	printRecord.vertexCoordinates3D := coordinates;
        return printRecord;
    end
);
RedispatchOnCondition( SetVertexCoordinates3DNC, true, 
    [IsTwistedPolygonalComplex,IsList,IsRecord], 
    [IsSimplicialSurface, IsList], 0 );
InstallOtherMethod( SetVertexCoordinates3DNC,
    "for a simplicial surface and a list of coordinates",
    [IsSimplicialSurface, IsList],
    function(surface, coordinates)
	return SetVertexCoordinates3DNC(coordinates, rec());
    end
);
RedispatchOnCondition( SetVertexCoordinates3DNC, true, 
    [IsTwistedPolygonalComplex,IsList], 
    [IsSimplicialSurface, IsList], 0 );

InstallMethod( GetVertexCoordinates3D,
    "for a simplicial surface, a vertex and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, vertex, printRecord)
	if not __SIMPLICIAL_IsCoordinates3D(surface, printRecord.vertexCoordinates3D) then
	    Error( " invalid coordinate format " );
        fi;
	return GetVertexCoordinates3DNC(surface, vertex, printRecord);
    end
);
RedispatchOnCondition(GetVertexCoordinates3D, true, [IsTwistedPolygonalComplex, IsPosInt, IsRecord],
    [IsSimplicialSurface], 0);

InstallMethod( GetVertexCoordinates3DNC,
    "for a simplicial surface, a vertex and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, vertex, printRecord)
	return 1.0*printRecord.vertexCoordinates3D[vertex];
    end
);
RedispatchOnCondition(GetVertexCoordinates3DNC, true, [IsTwistedPolygonalComplex, IsPosInt, IsRecord],
    [IsSimplicialSurface], 0);

InstallMethod( GetAllVertexCoordinates3DNC,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
	return printRecord.vertexCoordinates3D;
    end
);


InstallMethod( CalculateParametersOfInnerCircle,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
				local norm, distance, normalize, crossProd, Atan2, res, vertOfFace, P1, P2, P3, d1, d2, d3, incenter, s,face,
					radius, x, y, z, alpha, beta, gamma, normalVector, lengthNormalVector, normalVector_beta, normalVector_gamma;
				if not __SIMPLICIAL_IsCoordinates3D(surface, printRecord.vertexCoordinates3D) then
					Error( " invalid coordinate format " );
				fi;
				norm:=function(v) return Sqrt( v[1]*v[1] + v[2]*v[2] + v[3]*v[3] ); end;
				distance:=function(p,q) return norm(p-q); end;
				normalize:=function(v) return v/norm(v); end;
				crossProd:=function(v,w) return [ v[2]*w[3]-v[3]*w[2], v[3]*w[1]-v[1]*w[3], v[1]*w[2]-v[2]*w[1] ]; end;
				Atan2:=function(y,x)
					if x > 0. then
						return Atan(y/x);
					fi;
					if x < 0. then
						if y > 0. then
							return Atan(y/x)+4*Atan(1.0);
						fi;
						if y = 0. then
							return 4*Atan(1.0);
						fi;
						return Atan(y/x)-4*Atan(1.0);
					fi;
					if y > 0. then
						return 2*Atan(1.0);
					fi;
					if y < 0. then
						return -2*Atan(1.0);
					fi;
					return 0.;
				end;
				res := [];
				for face in Faces(surface) do
					vertOfFace:=VerticesOfFaces(surface)[face];
					if Length(vertOfFace) <> 3 then
						Append(res, [[]]);
						continue;
					fi;
					P1 := GetVertexCoordinates3DNC(surface, vertOfFace[1], printRecord);
					P2 := GetVertexCoordinates3DNC(surface, vertOfFace[2], printRecord);
					P3 := GetVertexCoordinates3DNC(surface, vertOfFace[3], printRecord);
					# calculate distances
					d1 := distance(P2,P3);
					d2 := distance(P1,P3);
					d3 := distance(P1,P2);
					# calculate coordinates of incenter
					incenter := ( d1*P1 + d2*P2 + d3*P3 ) / ( d1 + d2 + d3 );
					# calculate radius
					s := ( d1 + d2 + d3 ) / 2;
					radius := Sqrt( s * ( s - d1 ) * ( s - d2 ) * ( s - d3 ) ) / s;
					# calculate rotation angles (from x-y-plane)
					z := normalize(crossProd( P2-P1, P3-P1 ));
					x := normalize((P1+P2)/2 - P3);
					y := crossProd(z, x);
					alpha := Atan2(-z[2], z[3]);
					beta := Asin(z[1]);
					gamma := Atan2(-y[1], x[1]);
					# calculat rotation angles and length of normal vector
					normalVector := crossProd( P1-P2, P1-P3 );
					lengthNormalVector := 4*radius;
					normalVector_beta := Atan2(-1.0*normalVector[3], 1.0*normalVector[1]);
					normalVector_gamma := -Acos(1.0*normalVector[2]/norm(normalVector));
					res[face]:=[incenter, radius, [ alpha, beta, gamma ], [ 0., normalVector_beta, normalVector_gamma], lengthNormalVector ];
				od;
				printRecord.innerCircles := res;
				return printRecord;
    end
);
RedispatchOnCondition(CalculateParametersOfInnerCircle, true, 
    [IsTwistedPolygonalComplex, IsRecord],
    [IsSimplicialSurface], 0);

	

InstallMethod( ActivateInnerCircles,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
	local face;
	if not IsBound(printRecord.innerCircles) then
	    printRecord := CalculateParametersOfInnerCircle(surface, printRecord);
	fi;
	for face in Faces(surface) do
	    printRecord := ActivateInnerCircle(surface, face, printRecord);
	od;
        return printRecord;
    end
);
RedispatchOnCondition( ActivateInnerCircles, true, 
    [IsTwistedPolygonalComplex, IsRecord],
    [IsSimplicialSurface], 0);



InstallMethod( DeactivateInnerCircles,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
			printRecord.drawInnerCircles := [];
			return printRecord;
    end
);

InstallMethod( ActivateInnerCircle,
    "for a simplicial surface, a face and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, face, printRecord)
			if not IsBound(printRecord.innerCircles) then
				printRecord := CalculateParametersOfInnerCircle(surface, printRecord);
			fi;
			if not IsBound(printRecord.drawInnerCircles) then
				printRecord.drawInnerCircles := [];
			fi;
			printRecord.drawInnerCircles[face] := true;
			return printRecord;
    end
);

InstallMethod( DeactivateInnerCircle,
    "for a simplicial surface, a face and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, face, printRecord)
			if not IsBound(printRecord.drawInnerCircles) then
				return printRecord;
			fi;
			printRecord.drawInnerCircles[face] := false;
			return printRecord;
    end
);

InstallMethod( IsInnerCircleActive,
    "for a simplicial surface, a face and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, face, printRecord)
			if not IsBound(printRecord.innerCircles) then
					return false;
				fi;
				if not IsBound(printRecord.drawInnerCircles) or (face <= 0) then
					return false;
				fi;
				if not IsBound(printRecord.drawInnerCircles[face]) then
					return false;
				fi;
				return printRecord.drawInnerCircles[face] = true;
    end
);

InstallMethod( ActivateNormalOfInnerCircles,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
			local face;
			if not IsBound(printRecord.innerCircles) then
				printRecord := CalculateParametersOfInnerCircle(surface, printRecord);
			fi;
			for face in Faces(surface) do
				printRecord := ActivateNormalOfInnerCircle(surface, face, printRecord);
			od;
			return printRecord;
    end
);

InstallMethod( DeactivateNormalOfInnerCircles,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
			printRecord.drawNormalOfInnerCircles := [];
			return printRecord;
    end
);

InstallMethod( ActivateNormalOfInnerCircle,
    "for a simplicial surface, a face and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, face, printRecord)
			if not IsBound(printRecord.innerCircles) then
				printRecord := CalculateParametersOfInnerCircle(surface, printRecord);
			fi;
			if not IsBound(printRecord.drawNormalOfInnerCircles) then
				printRecord.drawNormalOfInnerCircles := [];
			fi;
			printRecord.drawNormalOfInnerCircles[face] := true;
			return printRecord;
    end
);

InstallMethod( DeactivateNormalOfInnerCircle,
    "for a simplicial surface, a face and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, face, printRecord)
			if not IsBound(printRecord.drawNormalOfInnerCircles) then
				return printRecord;
			fi;
			printRecord.drawNormalOfInnerCircles[face] := false;
			return printRecord;
    end
);

InstallMethod( IsNormalOfInnerCircleActive,
    "for a simplicial surface, a face and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, face, printRecord)
			if not IsBound(printRecord.innerCircles) then
					return false;
				fi;
				if not IsBound(printRecord.drawNormalOfInnerCircles) or (face <= 0) then
					return false;
				fi;
				if not IsBound(printRecord.drawNormalOfInnerCircles[face]) then
					return false;
				fi;
				return printRecord.drawNormalOfInnerCircles[face] = true;
    end
);

InstallMethod( CalculateParametersOfEdges,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
				local norm, distance, Atan2, res, vertOfEdge, P1, P2, d, mid, beta, gamma,edge;
				if not __SIMPLICIAL_IsCoordinates3D(surface, printRecord.vertexCoordinates3D) then
					Error( " invalid coordinate format " );
				fi;
				norm:=function(v) return Sqrt( v[1]*v[1] + v[2]*v[2] + v[3]*v[3] ); end;
				distance:=function(p,q) return norm(p-q); end;
				Atan2:=function(y,x)
					if x > 0. then
						return Atan(y/x);
					fi;
					if x < 0. then
						if y > 0. then
							return Atan(y/x)+4*Atan(1.0);
						fi;
						if y = 0. then
							return 4*Atan(1.0);
						fi;
						return Atan(y/x)-4*Atan(1.0);
					fi;
					if y > 0. then
						return 2*Atan(1.0);
					fi;
					if y < 0. then
						return -2*Atan(1.0);
					fi;
					return 0.;
				end;
				res := [];
				for edge in Edges(surface) do
					vertOfEdge:=VerticesOfEdges(surface)[edge];
					P1 := GetVertexCoordinates3DNC(surface, vertOfEdge[1], printRecord);
					P2 := GetVertexCoordinates3DNC(surface, vertOfEdge[2], printRecord);
					# calculate distance
					d := distance(P1,P2);
					# calculate coordinates of mid of edge
					mid := ( P1 + P2 ) / 2;
					# calculate rotation angles (from y-direction)
					beta := Atan2(-1.0*(P2[3]-P1[3]), 1.0*(P2[1]-P1[1]));
					gamma := -Acos(1.0*(P2[2]-P1[2])/d);
					res[edge]:=[mid, d, [ 0., beta, gamma ] ];
				od;
				printRecord.edges := res;
				return printRecord;
    end
);

InstallMethod( ActivateEdges,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
			if not IsBound(printRecord.edges) then
				printRecord := CalculateParametersOfEdges(surface, printRecord);
			fi;
			printRecord.drawEdges := [];
			return printRecord;
    end
);

InstallMethod( DeactivateEdges,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
			local edge;
			for edge in Edges(surface) do
				printRecord := DeactivateEdge(surface, edge, printRecord);
			od;
			return printRecord;
    end
);

InstallMethod( ActivateEdge,
    "for a simplicial surface, an edge and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, edge, printRecord)
			if not IsBound(printRecord.edges) then
				printRecord := CalculateParametersOfEdges(surface, printRecord);
			fi;
			if not IsBound(printRecord.drawEdges) then
				printRecord.drawEdges := [];
				return printRecord;
			fi;
			printRecord.drawEdges[edge] := true;
			return printRecord;
    end
);

InstallMethod( DeactivateEdge,
    "for a simplicial surface, an edge and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, edge, printRecord)
			if not IsBound(printRecord.drawEdges) then
				printRecord.drawEdges := [];
			fi;
			printRecord.drawEdges[edge] := false;
			return printRecord;
    end
);

InstallMethod( IsEdgeActive,
    "for a simplicial surface, an edge and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, edge, printRecord)
			if not IsBound(printRecord.edges) then
					return false;
				fi;
				if not IsBound(printRecord.drawEdges) then
					return true;
				fi;
				if (edge <= 0) then
					return false;
				fi;
				if not IsBound(printRecord.drawEdges[edge]) then
					return true;
				fi;
				return printRecord.drawEdges[edge] = true;
    end
);

InstallMethod( ActivateFaces,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
			printRecord.drawFaces := [];
			return printRecord;
    end
);

InstallMethod( DeactivateFaces,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
			local face;
			for face in Faces(surface) do
				printRecord := DeactivateFace(surface, face, printRecord);
			od;
			return printRecord;
    end
);

InstallMethod( ActivateFace,
    "for a simplicial surface, a face and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, face, printRecord)
			if not IsBound(printRecord.drawFaces) then
				printRecord.drawFaces := [];
				return printRecord;
			fi;
			printRecord.drawFaces[face] := true;
			return printRecord;
    end
);

InstallMethod( DeactivateFace,
    "for a simplicial surface, a face and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, face, printRecord)
			if not IsBound(printRecord.drawFaces) then
				printRecord.drawFaces := [];
			fi;
			printRecord.drawFaces[face] := false;
			return printRecord;
    end
);

InstallMethod( IsFaceActive,
    "for a simplicial surface, a face and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, face, printRecord)
				if not IsBound(printRecord.drawFaces) then
					return true;
				fi;
				if (face <= 0) then
					return false;
				fi;
				if not IsBound(printRecord.drawFaces[face]) then
					return true;
				fi;
				return printRecord.drawFaces[face] = true;
    end
);

InstallMethod( SetTransparencyJava,
    "for a simplicial surface, a face and a record",
    [IsSimplicialSurface, IsPosInt, IsFloat, IsRecord],
    function(surface, face, value, printRecord)
            if not IsBound(printRecord.FaceTransparency) then
                printRecord.FaceTransparency := [];
            fi;
            printRecord.FaceTransparency[face] := value;
            return printRecord;
    end
);

InstallMethod( RemoveTransparencyJava,
    "for a simplicial surface, a face and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, face, printRecord)
            if IsBound(printRecord.FaceTransparency[face]) then
                Unbind(printRecord.FaceTransparency[face]);
                return printRecord;
            fi;
            return printRecord;
    end
);

InstallMethod( GetTransparencyJava,
    "for a simplicial surface, a face and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, face, printRecord)
                if not IsBound(printRecord.FaceTransparency) then
                    return 1;
                fi;
                if (face <= 0) then
                    return 0;
                fi;
                if not IsBound(printRecord.FaceTransparency[face]) then
                    return 1;
                fi;
                return printRecord.FaceTransparency[face];
    end
);

InstallMethod( ActivateVertices,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
			if not IsBound(printRecord.vertexCoordinates3D) then
				Error(" The 3D-coordinates of the vertices are not set ");
			fi;
			printRecord.drawVertices := [];
			return printRecord;
    end
);

InstallMethod( DeactivateVertices,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
			local vertex;
			for vertex in Vertices(surface) do
				printRecord := DeactivateVertex(surface, vertex, printRecord);
			od;
			return printRecord;
    end
);

InstallMethod( ActivateVertex,
    "for a simplicial surface, a vertex and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, vertex, printRecord)
			if not IsBound(printRecord.vertexCoordinates3D) then
				Error(" The 3D-coordinates of the vertices are not set ");
			fi;
			if not IsBound(printRecord.drawVertices) then
				printRecord.drawVertices := [];
				return printRecord;
			fi;
			printRecord.drawVertices[vertex] := true;
			return printRecord;
    end
);

InstallMethod( DeactivateVertex,
    "for a simplicial surface, a vertex and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, vertex, printRecord)
			if not IsBound(printRecord.drawVertices) then
				printRecord.drawVertices := [];
			fi;
			printRecord.drawVertices[vertex] := false;
			return printRecord;
    end
);

InstallMethod( IsVertexActive,
    "for a simplicial surface, a vertex and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, vertex, printRecord)
			if not IsBound(printRecord.vertexCoordinates3D) then
					return false;
				fi;
				if not IsBound(printRecord.drawVertices) then
					return true;
				fi;
				if (vertex <= 0) then
					return false;
				fi;
				if not IsBound(printRecord.drawVertices[vertex]) then
					return true;
				fi;
				return printRecord.drawVertices[vertex] = true;
    end
);

InstallMethod( SetFaceColour,
    "for a simplicial surface, a face, a string and a record",
    [IsSimplicialSurface, IsPosInt, IsString, IsRecord],
    function(surface, face, colour, printRecord)
				if not IsBound(printRecord.faceColours) then
					printRecord.faceColours := [];
				fi;
				printRecord.faceColours[face] := colour;
				return printRecord;
    end
);

InstallMethod( GetFaceColour,
    "for a simplicial surface, a face and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, face, printRecord)
				local default;
				default := "0xFFFF00";
				if not IsBound(printRecord.faceColours) or (face <= 0) then
					return default;
				fi;
				if not IsBound(printRecord.faceColours[face]) then
					return default;
				fi;
				return printRecord.faceColours[face];
    end
);

InstallMethod( SetFaceColours,
    "for a simplicial surface, a list and a record",
    [IsSimplicialSurface, IsList, IsRecord],
    function(surface, faceColours, printRecord)
				printRecord.faceColours := faceColours;
				return printRecord;
    end
);

InstallMethod( GetFaceColours,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
				if not IsBound(printRecord.faceColours) then
					return [];
				fi;
				return printRecord.faceColours;
    end
);

InstallMethod( SetVertexColour,
    "for a simplicial surface, a vertex, a string and a record",
    [IsSimplicialSurface, IsPosInt, IsString, IsRecord],
    function(surface, vertex, colour, printRecord)
				if not IsBound(printRecord.vertexColours) then
					printRecord.vertexColours := [];
				fi;
				printRecord.vertexColours[vertex] := colour;
				return printRecord;
    end
);

InstallMethod( GetVertexColour,
    "for a simplicial surface, a vertex and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, vertex, printRecord)
				local default;
				default := "0xF58137";
				if not IsBound(printRecord.vertexColours) or (vertex <= 0) then
					return default;
				fi;
				if not IsBound(printRecord.vertexColours[vertex]) then
					return default;
				fi;
				return printRecord.vertexColours[vertex];
    end
);

InstallMethod( SetVertexColours,
    "for a simplicial surface, a list and a record",
    [IsSimplicialSurface, IsList, IsRecord],
    function(surface, vertexColours, printRecord)
				printRecord.vertexColours := vertexColours;
				return printRecord;
    end
);

InstallMethod( GetVertexColours,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
				if not IsBound(printRecord.vertexColours) then
					return [];
				fi;
				return printRecord.vertexColours;
    end
);

InstallMethod( SetEdgeColour,
    "for a simplicial surface, an edge, a string and a record",
    [IsSimplicialSurface, IsPosInt, IsString, IsRecord],
    function(surface, edge, colour, printRecord)
				if not IsBound(printRecord.edgeColours) then
					printRecord.edgeColours := [];
				fi;
				printRecord.edgeColours[edge] := colour;
				return printRecord;
    end
);

InstallMethod( GetEdgeColour,
    "for a simplicial surface, an edge and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, edge, printRecord)
				local default;
				default := "0xff0000";
				if not IsBound(printRecord.edgeColours) or (edge <= 0) then
					return default;
				fi;
				if not IsBound(printRecord.edgeColours[edge]) then
					return default;
				fi;
				return printRecord.edgeColours[edge];
    end
);

InstallMethod( SetEdgeColours,
    "for a simplicial surface, a list and a record",
    [IsSimplicialSurface, IsList, IsRecord],
    function(surface, edgeColours, printRecord)
				printRecord.edgeColours := edgeColours;
				return printRecord;
    end
);

InstallMethod( GetEdgeColours,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
				if not IsBound(printRecord.EdgeColours) then
					return [];
				fi;
				return printRecord.EdgeColours;
    end
);

InstallMethod( SetCircleColour,
    "for a simplicial surface, a face, a string and a record",
    [IsSimplicialSurface, IsPosInt, IsString, IsRecord],
    function(surface, face, colour, printRecord)
				if not IsBound(printRecord.circleColours) then
					printRecord.circleColours := [];
				fi;
				printRecord.circleColours[face] := colour;
				return printRecord;
    end
);

InstallMethod( GetCircleColour,
    "for a simplicial surface, a face and a record",
    [IsSimplicialSurface, IsPosInt, IsRecord],
    function(surface, face, printRecord)
				local default;
				default := "0x000000";
				if not IsBound(printRecord.circleColours) or (face <= 0) then
					return default;
				fi;
				if not IsBound(printRecord.circleColours[face]) then
					return default;
				fi;
				return printRecord.circleColours[face];
    end
);

InstallMethod( SetCircleColours,
    "for a simplicial surface, a list and a record",
    [IsSimplicialSurface, IsList, IsRecord],
    function(surface, circleColours, printRecord)
				printRecord.circleColours := circleColours;
				return printRecord;
    end
);

InstallMethod( GetCircleColours,
    "for a simplicial surface and a record",
    [IsSimplicialSurface, IsRecord],
    function(surface, printRecord)
				if not IsBound(printRecord.circleColours) then
					return [];
				fi;
				return printRecord.circleColours;
    end
);


# general method
InstallMethod( DrawSurfaceToJavaScriptCalculate,
    "for a simplicial surface, a filename and a record",
    [IsSimplicialSurface, IsString, IsRecord, IsBool],
    function(surface, fileName, printRecord, calculate)
                local file, output, template, coords, i, j, colour,
		      vertOfFace, vertOfEdge, parametersOfCircle, 
		      parametersOfEdge, temp, vertex, edge ,face,vertices,edges,
		      faces;	
	vertices:=Vertices(surface);
	edges:=Edges(surface);
	faces:=Faces(surface);

        # Make the file end with .html
        if not EndsWith( fileName, ".html" ) then
            fileName := Concatenation( fileName, ".html" );
        fi;

        # Try to open the given file
        file := Filename( DirectoryCurrent(), fileName ); #TODO allow absolute paths
        output := OutputTextFile( file, false ); # override other files
        if output = fail then
            Error(Concatenation("File ", String(file), " can't be opened.") );
        fi;
        SetPrintFormattingStatus( output, false );

                template := __SIMPLICIAL_ReadTemplateFromFile("JS_Header.html.template");
                AppendTo( output, template );

        # Set coordinates of vertices
        if not __SIMPLICIAL_IsCoordinates3D(surface, printRecord.vertexCoordinates3D) then
                    Error( " invalid coordinate format " );
                fi;
                for vertex in Vertices(surface) do
                    coords := GetVertexCoordinates3DNC(surface, vertex, printRecord);
                    AppendTo(output, "\t\tallpoints.push(new PMPoint(", coords[1], ",", coords[2], ",", coords[3], "));\n");
                od;

        # Add points to scenario
                for i in [0..(NumberOfVertices(surface)-1)] do
                    if IsVertexActive(surface, vertices[i+1], printRecord) then
                        colour := GetVertexColour(surface, vertices[i+1], printRecord);
                        if not StartsWith(colour, "0x") then
                            colour := Concatenation("\"", colour, "\"");
                        fi;
                        AppendTo(output, "\t\tvar points_material", i, " = new THREE.MeshBasicMaterial( {color: ", colour, " } );\n");
                        AppendTo(output, "\t\tpoints_material", i, ".side = THREE.DoubleSide;\n");
                        AppendTo(output, "\t\tpoints_material", i, ".transparent = true;\n");
                        AppendTo(output, "\t\t// draw a node as a sphere of radius 0.05\n");
                        AppendTo(output, "\t\tallpoints[", i, "].makesphere(0.05,points_material", i, ");\n");
                        AppendTo(output, "\t\tallpoints[", i, "].makelabel(", vertices[i+1], ");\n");
                    fi;
                od;
                template := __SIMPLICIAL_ReadTemplateFromFile("JS_associate_points_init_faces.html.template");
                AppendTo( output, template );

                # Add Faces to scenario
                for i in [1..(NumberOfFaces(surface))] do
                    if IsFaceActive(surface, faces[i], printRecord) then
                        vertOfFace := VerticesOfFaces(surface)[faces[i]];
                        colour := GetFaceColour(surface, faces[i], printRecord);
                        if not StartsWith(colour, "0x") then
                            colour := Concatenation("\"", colour, "\"");
                        fi;
                        AppendTo(output, "\t\tvar face", faces[i], " = new THREE.Geometry();\n");
                        for j in [1..3] do
                            AppendTo(output, "\t\tface", faces[i], ".vertices.push(allpoints[", Position(vertices,vertOfFace[j])-1, "\].vector);\n");
                        od;
                        AppendTo(output, "\t\tcentroids.push(computeCentroid(face", faces[i], "));\n");
                        AppendTo(output, "\t\tvar face", faces[i], "_material = new THREE.MeshBasicMaterial ({color: ", colour, ", transparent: true, opacity: ", GetTransparencyJava(surface, i, printRecord) , ",side: THREE.DoubleSide , depthWrite: true,depthTest: true, } );\n");
                        AppendTo(output, "\t\tface", faces[i], ".faces.push(new THREE.Face3(0, 1, 2 ,undefined, undefined, 0));\n");
                        AppendTo(output, "\t\tvar face", faces[i], "_obj = new THREE.Face3(0,1,2,undefined, undefined, 0);\n");
                        AppendTo(output, "\t\tobj.add( new THREE.Mesh(face", faces[i], ", face", faces[i], "_material) );\n");
                    fi;
                od;

                AppendTo(output, "\n\n");
                for face in faces do
                    if IsInnerCircleActive(surface, face, printRecord) then
                        parametersOfCircle := printRecord.innerCircles[face];
                        colour := GetCircleColour(surface, face, printRecord);
                        if not StartsWith(colour, "0x") then
                            colour := Concatenation("\"", colour, "\"");
                        fi;
                        AppendTo(output, "\t\tvar circle = Circle(", parametersOfCircle[2], ", ", parametersOfCircle[1][1], ", ",
                            parametersOfCircle[1][2], ", ", parametersOfCircle[1][3], ", ", parametersOfCircle[3][1], ", ",
                            parametersOfCircle[3][2], ", ", parametersOfCircle[3][3], ", ", colour, ");\n");
                        AppendTo(output, "\t\tobj.add(circle);\n");
                    fi;
                od;
                AppendTo(output, "\n\n");

                for face in faces do
                    if IsNormalOfInnerCircleActive(surface, face, printRecord) then
                        parametersOfCircle := printRecord.innerCircles[face];
                        colour := GetCircleColour(surface, face, printRecord);
                        if not StartsWith(colour, "0x") then
                            colour := Concatenation("\"", colour, "\"");
                        fi;
                        AppendTo(output, "\t\tvar normalVector = Edge(", parametersOfCircle[5], ", 0.002, ", parametersOfCircle[1][1], ", ",
                            parametersOfCircle[1][2], ", ", parametersOfCircle[1][3], ", ", parametersOfCircle[4][1], ", ",
                            parametersOfCircle[4][2], ", ", parametersOfCircle[4][3], ", ", colour, ");\n");
                        AppendTo(output, "\t\tobj.add(normalVector);\n");
                    fi;
                od;
                AppendTo(output, "\n\n");

                # Add Edges to scenario
                template := __SIMPLICIAL_ReadTemplateFromFile("JS_init_edges.html.template");
                AppendTo( output, template );
                if not IsBound(printRecord.edges) then
                    printRecord := CalculateParametersOfEdges(surface, printRecord);
                fi;
                if calculate then
                    printRecord := CalculateParametersOfEdges(surface, printRecord);
                fi;
                for edge in edges do
                    if IsEdgeActive(surface, edge, printRecord) then
                        parametersOfEdge := printRecord.edges[edge];
                        colour := GetEdgeColour(surface, edge, printRecord);
                        if not StartsWith(colour, "0x") then
                            colour := Concatenation("\"", colour, "\"");
                        fi;
                        if IsBound(printRecord.edgeThickness) then
	                        AppendTo(output, "\t\tvar edge = Edge(", parametersOfEdge[2], ",", printRecord.edgeThickness,",", parametersOfEdge[1][1], ", ",
	                            parametersOfEdge[1][2], ", ", parametersOfEdge[1][3], ", ", parametersOfEdge[3][1], ", ",
	                            parametersOfEdge[3][2], ", ", parametersOfEdge[3][3], ", ", colour, ");\n");
	                        AppendTo(output, "\t\tobj.add(edge);\n");
	                    else
	                    	AppendTo(output, "\t\tvar edge = Edge(", parametersOfEdge[2], ", 0.01, ", parametersOfEdge[1][1], ", ",
	                            parametersOfEdge[1][2], ", ", parametersOfEdge[1][3], ", ", parametersOfEdge[3][1], ", ",
	                            parametersOfEdge[3][2], ", ", parametersOfEdge[3][3], ", ", colour, ");\n");
	                        AppendTo(output, "\t\tobj.add(edge);\n");
	                    fi;
                    fi;
                od;

                if IsBound(printRecord.FaceTransparency) then
                    template := __SIMPLICIAL_ReadTemplateFromFile("JS_FooterFirst.html.template");
                    AppendTo( output, template );
                    for face in faces do
                        if IsBound(printRecord.FaceTransparency[face]) then
                            #face1_material.opacity = 0;
                            AppendTo(output, "\t\t\tface", face , "_material.opacity = ", printRecord.FaceTransparency[face], ";\n");
                        fi;
                    od;
                    template := __SIMPLICIAL_ReadTemplateFromFile("JS_FooterSecond.html.template");
                    AppendTo( output, template );
                else
                    template := __SIMPLICIAL_ReadTemplateFromFile("JS_Footer.html.template");
                    AppendTo( output, template );
                fi;

                CloseStream(output);
        return printRecord;
    end
);



InstallMethod( DrawSurfaceToJavaScript,
    "for a simplicial surface, a filename and a record",
    [IsSimplicialSurface, IsString, IsRecord],
    function(surface, fileName, printRecord)
        return DrawSurfaceToJavaScriptCalculate(surface,fileName,printRecord,true);
    end
);

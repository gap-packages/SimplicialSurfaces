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
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, coordinates, printRecord)
	if not __SIMPLICIAL_IsCoordinates3D(surface, coordinates) then
	    Error( " invalid coordinate format " );
	fi;
	return SetVertexCoordinates3DNC(surface, coordinates, printRecord);
    end
);
RedispatchOnCondition( SetVertexCoordinates3D, true, 
    [IsTwistedPolygonalComplex,IsList,IsRecord], 
    [IsTriangularComplex, IsList], 0 );

InstallOtherMethod( SetVertexCoordinates3D,
    "for a simplicial surface and a list of coordinates",
    [IsTriangularComplex, IsList],
    function(surface, coordinates)
	return SetVertexCoordinates3D(surface, coordinates, rec());
    end
);
RedispatchOnCondition( SetVertexCoordinates3D, true, 
    [IsTwistedPolygonalComplex,IsList], 
    [IsTriangularComplex, IsList], 0 );

InstallMethod( SetVertexCoordinates3DNC,
    "for a simplicial surface, a list of coordinates and a record",
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, coordinates, printRecord)
	printRecord.vertexCoordinates3D := coordinates;
        return printRecord;
    end
);
RedispatchOnCondition( SetVertexCoordinates3DNC, true, 
    [IsTwistedPolygonalComplex,IsList,IsRecord], 
    [IsTriangularComplex, IsList], 0 );
InstallOtherMethod( SetVertexCoordinates3DNC,
    "for a simplicial surface and a list of coordinates",
    [IsTriangularComplex, IsList],
    function(surface, coordinates)
	return SetVertexCoordinates3DNC(coordinates, rec());
    end
);
RedispatchOnCondition( SetVertexCoordinates3DNC, true, 
    [IsTwistedPolygonalComplex,IsList], 
    [IsTriangularComplex, IsList], 0 );

InstallMethod( GetVertexCoordinates3D,
    "for a simplicial surface, a vertex and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, vertex, printRecord)
	if not __SIMPLICIAL_IsCoordinates3D(surface, printRecord.vertexCoordinates3D) then
	    Error( " invalid coordinate format " );
        fi;
	return GetVertexCoordinates3DNC(surface, vertex, printRecord);
    end
);
RedispatchOnCondition(GetVertexCoordinates3D, true, [IsTwistedPolygonalComplex, IsPosInt, IsRecord],
    [IsTriangularComplex], 0);

InstallMethod( GetVertexCoordinates3DNC,
    "for a simplicial surface, a vertex and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, vertex, printRecord)
	return 1.0*printRecord.vertexCoordinates3D[vertex];
    end
);
RedispatchOnCondition(GetVertexCoordinates3DNC, true, [IsTwistedPolygonalComplex, IsPosInt, IsRecord],
    [IsTriangularComplex], 0);


InstallMethod( CalculateParametersOfInnerCircle,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
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
    [IsTriangularComplex], 0);

	

InstallMethod( ActivateInnerCircles,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
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
    [IsTriangularComplex], 0);



InstallMethod( DeactivateInnerCircles,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
			printRecord.drawInnerCircles := [];
			return printRecord;
    end
);

InstallMethod( ActivateInnerCircle,
    "for a simplicial surface, a face and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsRecord],
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
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
			printRecord.drawNormalOfInnerCircles := [];
			return printRecord;
    end
);

InstallMethod( ActivateNormalOfInnerCircle,
    "for a simplicial surface, a face and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsRecord],
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
    [IsTriangularComplex, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
			printRecord.drawFaces := [];
			return printRecord;
    end
);

InstallMethod( DeactivateFaces,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsFloat, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsRecord],
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
    [IsTriangularComplex, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsString, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, face, printRecord)
				local default;
				default := "0x049EF4";
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
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, faceColours, printRecord)
				printRecord.faceColours := faceColours;
				return printRecord;
    end
);

InstallMethod( GetFaceColours,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
    local res, i;
                res := [];
                for i in Faces(surface) do
                    res[i]:= GetFaceColour(surface, i, printRecord);
                od;

                return res;
    end
);

InstallMethod( SetVertexColour,
    "for a simplicial surface, a vertex, a string and a record",
    [IsTriangularComplex, IsPosInt, IsString, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, vertexColours, printRecord)
				printRecord.vertexColours := vertexColours;
				return printRecord;
    end
);

InstallMethod( GetVertexColours,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
        local vertexColours, i;
        vertexColours := [];
        for i in [1..Length(Vertices(surface))] do
            Add(vertexColours, GetVertexColour(surface, i, printRecord));
        od;

        return vertexColours;
    end
);

InstallMethod( SetEdgeColour,
    "for a simplicial surface, an edge, a string and a record",
    [IsTriangularComplex, IsPosInt, IsString, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, edge, printRecord)
				local default;
				default := "0x000000";
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
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, edgeColours, printRecord)
				printRecord.edgeColours := edgeColours;
				return printRecord;
    end
);

InstallMethod( GetEdgeColours,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
        local edgeColours, i;
        edgeColours := [];
        for i in [1..Length(Edges(surface))] do
            Add(edgeColours, GetEdgeColour(surface, i, printRecord));
        od;

        return edgeColours;
    end
);

InstallMethod( SetCircleColour,
    "for a simplicial surface, a face, a string and a record",
    [IsTriangularComplex, IsPosInt, IsString, IsRecord],
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
    [IsTriangularComplex, IsPosInt, IsRecord],
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
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, circleColours, printRecord)
				printRecord.circleColours := circleColours;
				return printRecord;
    end
);

InstallMethod( GetCircleColours,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
				if not IsBound(printRecord.circleColours) then
					return [];
				fi;
				return printRecord.circleColours;
    end
);

# set neccessary values for the printrecord
BindGlobal( "__SIMPLICIAL_InitializePrintRecordDrawSurfaceToJavascript",
    function(surface,printRecord)
	local edgeThickness;
	if not IsBound(printRecord.edgeThickness) then
	    printRecord.edgeThickness := 0.03;
	fi;
	

	return printRecord;
    end
);

# function to calculate the incenter of a triangle/face. Used for inner circles
# we follow the math and variable names from here: https://math.stackexchange.com/questions/740111/incenter-of-triangle-in-3d
BindGlobal( "__SIMPLICIAL_CalculateIncenter",
    function(surface,printRecord,face)
	local a, b, c, A, B, C, atemp, btemp, ctemp, incenter;

    #get the coordinates
    A := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord);
    B := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord);
    C := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord);

    atemp := B-C;
    btemp := C-A;
    ctemp := A-B;

    a := Sqrt(Float(atemp[1]^2+atemp[2]^2+atemp[3]^2));
    b := Sqrt(Float(btemp[1]^2+btemp[2]^2+btemp[3]^2));
    c := Sqrt(Float(ctemp[1]^2+ctemp[2]^2+ctemp[3]^2));

    incenter := a/(a+b+c)*A + b/(a+b+c)*B + c/(a+b+c)*C;
 
    return incenter;
    end
);

# function to calculate the inradius of a triangle/face. Used for inner circles
# we follow the math and variable names from here: https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle#Radius
BindGlobal( "__SIMPLICIAL_CalculateInradius",
    function(surface,printRecord,face)
	local a, b, c, A, B, C, atemp, btemp, ctemp, s, inradius;

    #get the coordinates
    A := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord);
    B := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord);
    C := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord);

    atemp := B-C;
    btemp := C-A;
    ctemp := A-B;

    a := Sqrt(Float(atemp[1]^2+atemp[2]^2+atemp[3]^2));
    b := Sqrt(Float(btemp[1]^2+btemp[2]^2+btemp[3]^2));
    c := Sqrt(Float(ctemp[1]^2+ctemp[2]^2+ctemp[3]^2));

    s := (a+b+c)/2;
    inradius := Sqrt(Float( ((s-a)*(s-b)*(s-c)) / s ));
 
	return inradius;
    end
);

# function to calculate the normalvector of a triangle/face. Used for normals of inner circles
# we use just the cross product of two of the defining edges, generated by the vertices
BindGlobal( "__SIMPLICIAL__CalculateNormalvector",
    function(surface,printRecord,face)
	local A, B, C, atemp, btemp, normal;

    #get the coordinates
    A := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord);
    B := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord);
    C := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord);

    atemp := C-B;
    btemp := C-A;

    normal := [];

    normal[1] := atemp[2]*btemp[3] - atemp[3]*btemp[2];
    normal[2] := atemp[3]*btemp[1] - atemp[1]*btemp[3];
    normal[3] := atemp[1]*btemp[2] - atemp[2]*btemp[1];
 
	return (1/2)*normal;
    end
);

# general method
# TODO: change name to drawcomplex... ?
InstallMethod( DrawSurfaceToJavaScriptCalculate,
    "for a simplicial surface, a filename and a record",
    [IsTriangularComplex, IsString, IsRecord, IsBool],
    function(surface, fileName, printRecord, calculate)
                local file, output, template, coords, i, j, colour,
		      vertOfFace, vertOfEdge, parametersOfCircle, 
		      parametersOfEdge, temp, vertex, edge ,face,vertices,edges,
              faceColors, addedFaceColors, uniqueFaceColors, colorPositions, color, coordinateString, edgeThickness,
		      faces, coordinateStringA, coordinateStringB, coordinateStringC, edgeVertexA, edgeVertexB, edgeColors, uniqueEdgeColors,
              incenter,inradius, normal, atemp, btemp;	
    # make sure the defaults are set
    printRecord := __SIMPLICIAL_InitializePrintRecordDrawSurfaceToJavascript(surface, printRecord);
    
    #predefine some lists
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

    AppendTo( output, __SIMPLICIAL_ReadTemplateFromFile("three_header.template") );
    AppendTo( output, __SIMPLICIAL_ReadTemplateFromFile("three_start.template") );

    # Check if surface is in 3d coords
    # TODO neccessary?
    if not __SIMPLICIAL_IsCoordinates3D(surface, printRecord.vertexCoordinates3D) then
        Error( " invalid coordinate format " );
    fi;

    # add faces to geometry by iterating over all colors
    # for each color there is a new geometry and material generated. these are then combined into a mesh and added to the root group
    faceColors := GetFaceColours(surface, printRecord);

    # generate a list of all unique colors of the faces
    uniqueFaceColors := [];
    for color in faceColors do
        if not color in uniqueFaceColors then
            Add(uniqueFaceColors, color);
        fi; 
    od;

    # for each of the unique colors add the faces to a gemeometry and generate a mesh with corresponding color from it
    # also generate a wireframe which can be made visible via the gui
    for i in [1..Length(uniqueFaceColors)] do
        color := uniqueFaceColors[i];
        if not StartsWith(color, "0x") then
            colour := Concatenation("\"", color, "\"");
        fi;

        # generate a geometry with all vertices of the faces belonging to the current face
        AppendTo(output, "\t \t \tconst geometry",i," = new THREE.BufferGeometry();\n");
        AppendTo(output, "\t \t \tconst vertices",i," = new Float32Array( [\n \t \t \t \t");

        colorPositions := Positions(faceColors, color);
        for face in colorPositions do
            if IsFaceActive(surface, face, printRecord) then
                # we assume there is always at least one active face               
                # as we can assume that all faces of a simplicial surface have exactly 3 vertices we add them to the geometry individually
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord)[1], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord)[2], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord)[3], ",\n \t \t \t \t");

                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord)[1], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord)[2], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord)[3], ",\n\t \t \t \t");

                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord)[1], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord)[2], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord)[3], ",\n\n\t \t \t \t");
            fi;
        od;
        AppendTo(output, "] ); \n\n");
        AppendTo(output, "\t \t \tgeometry",i,".setAttribute( 'position', new THREE.BufferAttribute( vertices",i,", 3 ) );\n\n");

        # generate a material with the corresponding color
        AppendTo(output, """
            const material""",i,""" = new THREE.MeshPhongMaterial({
                color: """,GetFaceColour(surface, face, printRecord),""",          
                flatShading: true,       
            });
            material""",i,""".transparent = true;
            material""",i,""".side = THREE.DoubleSide;
        """);

        # generate a mesh from the geometry and material above
        AppendTo(output, """
            const mesh""",i,""" = new THREE.Mesh( geometry""",i,""", material""",i,""" );
            mesh""",i,""".castShadow = true;                         
            mesh""",i,""".receiveShadow = true;                      
                                        
            meshRoot.add(mesh""",i,""");
        """);
    od;

    # add edges to geometry by iterating over all colors
    # for each color there is a new geometry and material generated. these are then combined into a mesh and added to the edgeRoot group
    edgeColors := GetEdgeColours(surface, printRecord);

    # generate a list of all unique colors of the faces
    uniqueEdgeColors := [];
    for color in edgeColors do
        if not color in uniqueEdgeColors then
            Add(uniqueEdgeColors, color);
        fi; 
    od;

    # for each of the unique colors add the edges to a gemeometry and generate a mesh with corresponding color from it
    # also generate a wireframe from the edges which can be made visible via the gui
    for i in [1..Length(uniqueEdgeColors)] do
        color := uniqueEdgeColors[i];
        if not StartsWith(color, "0x") then
            colour := Concatenation("\"", color, "\"");
        fi;

        edgeThickness := printRecord.edgeThickness*100;
        AppendTo(output, """
            const edgeMaterial""",i,""" = new THREE.LineBasicMaterial( {
                color: """,color,""",
                linewidth: """,edgeThickness,""",
            } );        
        """);

        AppendTo(output, "\tconst edges",i," = new Float32Array( [\n");

        colorPositions := Positions(edgeColors, color);
        for j in colorPositions do
            edge := Edges(surface)[j];
            # if IsEdgeActive(surface, edge, printRecord) then
                # generate a string with the coordinates for later use
                edgeVertexA := VerticesOfEdge(surface, edge)[1];
                edgeVertexB := VerticesOfEdge(surface, edge)[2];
                coordinateStringA := "";
                Append(coordinateStringA, String(GetVertexCoordinates3DNC(surface, edgeVertexA, printRecord)[1]));
                Append(coordinateStringA, ",");
                Append(coordinateStringA, String(GetVertexCoordinates3DNC(surface, edgeVertexA, printRecord)[2]));
                Append(coordinateStringA, ",");
                Append(coordinateStringA, String(GetVertexCoordinates3DNC(surface, edgeVertexA, printRecord)[3]));
                Append(coordinateStringA, ",");

                coordinateStringB := "";
                Append(coordinateStringB, String(GetVertexCoordinates3DNC(surface, edgeVertexB, printRecord)[1]));
                Append(coordinateStringB, ",");
                Append(coordinateStringB, String(GetVertexCoordinates3DNC(surface, edgeVertexB, printRecord)[2]));
                Append(coordinateStringB, ",");
                Append(coordinateStringB, String(GetVertexCoordinates3DNC(surface, edgeVertexB, printRecord)[3]));
                Append(coordinateStringB, ",");

                AppendTo(output, "\t \t \t",coordinateStringA,"\n \t \t \t",coordinateStringB,"\n \n");
            # fi;
        od;

        AppendTo(output, "\t \t \t]);");
        AppendTo(output, """
            const edgeGeometry""",i,""" = new THREE.BufferGeometry();
            edgeGeometry""",i,""".setAttribute( 'position', new THREE.BufferAttribute( edges""",i,""", 3 ) );

            const edgeLine""",i,""" = new THREE.LineSegments( edgeGeometry""",i,""", edgeMaterial""",i,""" );
            edgeRoot.add(edgeLine""",i,""");
        """);
        
    od;

    # add spheres and lables on all vertices if they are active
    AppendTo(output, "\n\n\t//add the vertices with lables\n \t \t \t");
    for vertex in Vertices(surface) do
        if IsVertexActive(surface, vertex, printRecord) then                
            # generate a string with the coordinates for later use
            coordinateString := "";
            Append(coordinateString, String(GetVertexCoordinates3DNC(surface, vertex, printRecord)[1]));
            Append(coordinateString, ",");
            Append(coordinateString, String(GetVertexCoordinates3DNC(surface, vertex, printRecord)[2]));
            Append(coordinateString, ",");
            Append(coordinateString, String(GetVertexCoordinates3DNC(surface, vertex, printRecord)[3]));
            Append(coordinateString, ",");

            # add spheres with radius edgeThickness around the active vertices
            AppendTo(output, "const sphereMaterial",vertex," = new THREE.MeshBasicMaterial( { color: ",GetVertexColour(surface, vertex, printRecord)," } );\n");
            AppendTo(output, "\t \t \tconst sphere",vertex," = new THREE.Mesh( sphereGeometry, sphereMaterial",vertex," );\n");
            AppendTo(output, "\t \t \tsphereRoot.add(sphere",vertex,");\n");
            AppendTo(output, "\t \t \tsphere",vertex,".position.set(",coordinateString,");\n");

            
            # generate the lable for the given vertex
            AppendTo(output, """
            const lableDiv""",vertex,""" = document.createElement( 'div' );
            lableDiv""",vertex,""".className = 'label';
            lableDiv""",vertex,""".textContent = '""",vertex,"""';
            lableDiv""",vertex,""".style.marginTop = '-1em';

            const vertexLabel""",vertex,""" = new CSS2DObject( lableDiv""",vertex,""" );
            vertexLabel""",vertex,""".position.set(""",coordinateString,""");
            sphereRoot.add( vertexLabel""",vertex,""" );

            """);
        fi;
    od;

    # generate innercircle for all (active) innercircle faces
    for face in Faces(surface) do
        if(IsInnerCircleActive(surface, face, printRecord)) then
            #TODO calculate right radius and apply
            incenter := __SIMPLICIAL_CalculateIncenter(surface, printRecord, face);
            inradius := __SIMPLICIAL_CalculateInradius(surface, printRecord, face);
            AppendTo(output, "const ringGeometry",face," = new THREE.RingGeometry(",(inradius-0.005),",",inradius,", 32);\n");
            AppendTo(output, "const ringMaterial",face," = new THREE.LineBasicMaterial( { color: ",GetCircleColour(surface, face, printRecord),", side: THREE.DoubleSide } );\n");
            AppendTo(output, "const ringMesh",face," = new THREE.Mesh(ringGeometry",face,", ringMaterial",face,");\n");

            # generate the right strings of the coordinates
            coordinateStringA := "";
            Append(coordinateStringA, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord)[1]));
            Append(coordinateStringA, ",");
            Append(coordinateStringA, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord)[2]));
            Append(coordinateStringA, ",");
            Append(coordinateStringA, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord)[3]));

            coordinateStringB := "";
            Append(coordinateStringB, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord)[1]));
            Append(coordinateStringB, ",");
            Append(coordinateStringB, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord)[2]));
            Append(coordinateStringB, ",");
            Append(coordinateStringB, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord)[3]));

            coordinateStringC := "";
            Append(coordinateStringC, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord)[1]));
            Append(coordinateStringC, ",");
            Append(coordinateStringC, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord)[2]));
            Append(coordinateStringC, ",");
            Append(coordinateStringC, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord)[3]));

            AppendTo(output, """
                //translate ring to incenter
                ringMesh""",face,""".translateX(""",incenter[1],""");
                ringMesh""",face,""".translateY(""",incenter[2],""");
                ringMesh""",face,""".translateZ(""",incenter[3],""");

                // rotate ring to right angle
                //calculations for this are done in THREE.js as there are already the right functions for generating and applying the rotation
                const A""",face,""" = new THREE.Vector3(""",coordinateStringA,""");
                const B""",face,""" = new THREE.Vector3(""",coordinateStringB,""");
                const C""",face,""" = new THREE.Vector3(""",coordinateStringC,""");

                const normalVec""",face,""" = new THREE.Vector3();
                normalVec""",face,""".crossVectors(B""",face,""".sub(A""",face,"""), C""",face,""".sub(A""",face,"""));
                normalVec""",face,""".normalize();

                //initial normal vector of ringGeometry is (0,0,1), so we use that
                const initialNormal""",face,""" = new THREE.Vector3(0,0,1);

                const quaternionRotation""",face,""" = new THREE.Quaternion();
                quaternionRotation""",face,""".setFromUnitVectors(initialNormal""",face,""", normalVec""",face,""");

                ringMesh""",face,""".setRotationFromQuaternion(quaternionRotation""",face,""");

                ringRoot.add(ringMesh""",face,""");
            """);
        fi;
    od;

    coordinateString := "";
    for face in Faces(surface) do
        if IsNormalOfInnerCircleActive(surface, face, printRecord) then
            normal := __SIMPLICIAL__CalculateNormalvector(surface, printRecord, face);
            incenter := __SIMPLICIAL_CalculateIncenter(surface, printRecord, face);

            # set the two points as incenter plus normal and incenter minus normal
            # TODO: check if the non-normalized normals generated from the face have a good length, otherwise automate
            atemp := incenter-normal;
            btemp := incenter+normal;

            # add to string for later use
            Append(coordinateString, "\t \t \t");
            Append(coordinateString, String(atemp[1]));
            Append(coordinateString, ",");
            Append(coordinateString, String(atemp[2]));
            Append(coordinateString, ",");
            Append(coordinateString, String(atemp[3]));
            Append(coordinateString, ", \n");

            Append(coordinateString, "\t \t \t");
            Append(coordinateString, String(btemp[1]));
            Append(coordinateString, ",");
            Append(coordinateString, String(btemp[2]));
            Append(coordinateString, ",");
            Append(coordinateString, String(btemp[3]));
            Append(coordinateString, ", \n \n");
        fi;
    od;
    if not coordinateString = "" then
        AppendTo(output, """
            const normalsMaterial = new THREE.LineBasicMaterial( {
                color: 0x000000,
            } );        
        """);

        AppendTo(output, "\tconst normals = new Float32Array( [\n");
        AppendTo(output, coordinateString);

        AppendTo(output, "\t \t \t]);");
        AppendTo(output, """
            const normalsGeometry = new THREE.BufferGeometry();
            normalsGeometry.setAttribute( 'position', new THREE.BufferAttribute( normals, 3 ) );

            const normalsLine = new THREE.LineSegments( normalsGeometry, normalsMaterial );
            normalsRoot.add(normalsLine);
        """);
    fi;
        

    AppendTo( output, __SIMPLICIAL_ReadTemplateFromFile("three_end.template") );
    AppendTo( output, __SIMPLICIAL_ReadTemplateFromFile("three_footer.template") );

    CloseStream(output);
    return printRecord;
    end
);



InstallMethod( DrawSurfaceToJavaScript,
    "for a simplicial surface, a filename and a record",
    [IsTriangularComplex, IsString, IsRecord],
    function(surface, fileName, printRecord)
        return DrawSurfaceToJavaScriptCalculate(surface,fileName,printRecord,true);
    end
);

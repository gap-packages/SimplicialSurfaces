
InstallMethod( SetVertexCoordiantes3DNC,
    "for a list of coordinates and a record",
    [IsDenseList, IsRecord],
    function(coordinates, printRecord)
				printRecord.vertexCoordinates3D := coordinates;
				return printRecord;
    end
);

BindGlobal( "__SIMPLICIAL_TestCoordinatesFormat",
    function(surface, coordinates)
        if Length(coordinates) <> NumberOfVertices(surface) then
          return false;
				fi;
 			if not ForAll(coordinates, IsDenseList) then
          return false;
				fi;
				return AsSet( List(coordinates, c -> Length(c))) = AsSet( [3] );
    end
);

InstallMethod( SetVertexCoordiantes3D,
    "for a polygonal complex without edge ramifications, a list of coordinates and a record",
    [IsPolygonalComplex and IsNotEdgeRamified, IsDenseList, IsRecord],
    function(surface, coordinates, printRecord)
				if not __SIMPLICIAL_TestCoordinatesFormat(surface, coordinates) then
					Error( " invalid coordinate format " );
				fi;
				return SetVertexCoordiantes3DNC(coordinates, printRecord);
    end
);

InstallOtherMethod( SetVertexCoordiantes3DNC,
    "for a list of coordinates",
    [IsDenseList],
    function(coordinates)
				return SetVertexCoordiantes3DNC(coordinates, rec());
    end
);

InstallOtherMethod( SetVertexCoordiantes3D,
    "for a polygonal complex without edge ramifications and a list of coordinates",
    [IsPolygonalComplex and IsNotEdgeRamified, IsDenseList],
    function(surface, coordinates)
				return SetVertexCoordiantes3D(surface, coordinates, rec());
    end
);

InstallMethod( GetVertexCoordiantes3DNC,
    "for a record and an index",
    [IsRecord, IsCyclotomic],
    function(printRecord, index)
				return printRecord.vertexCoordinates3D[index];
    end
);

InstallMethod( GetVertexCoordiantes3D,
    "for a polygonal complex without edge ramifications, a record and an index",
    [IsPolygonalComplex and IsNotEdgeRamified, IsRecord, IsCyclotomic],
    function(surface, printRecord, index)
				if not __SIMPLICIAL_TestCoordinatesFormat(surface, printRecord.vertexCoordinates3D) then
					Error( " invalid coordinate format " );
				fi;
				return GetVertexCoordiantes3DNC(printRecord, index);
    end
);

# general method
InstallMethod( DrawSurfaceToJavaScript, 
    "for a polygonal complex without edge ramifications, a filename and a record",
    [IsPolygonalComplex and IsNotEdgeRamified, IsString, IsRecord],
    function(surface, fileName, printRecord)
				local file, output, template, coords, i, vertOfFace, vertOfEdge;

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

				template := __SIMPLICIAL_ReadTemplateFromFile("/pkg/simplicial-surfaces/doc/JS_Header.html.template");
				AppendTo( output, template );

        # Set coordinates of vertices
        if not __SIMPLICIAL_TestCoordinatesFormat(surface, printRecord.vertexCoordinates3D) then
					Error( " invalid coordinate format " );
				fi;
				for i in [1..NumberOfVertices(surface)] do
					coords := GetVertexCoordiantes3DNC(printRecord, i);
					AppendTo(output, "\t\tallpoints.push(new PMPoint(", coords[1], ",", coords[2], ",", coords[3], "));\n");
				od;

				# Load points_material from file
				template := __SIMPLICIAL_ReadTemplateFromFile("/pkg/simplicial-surfaces/doc/JS_points_material.html.template");
				AppendTo( output, template );

        # Add points to scenario
				for i in [0..(NumberOfVertices(surface)-1)] do
					AppendTo(output, "\t\tallpoints[", i, "].makesphere(0.05,points_material);\n");
					AppendTo(output, "\t\tallpoints[", i, "].makelabel(", i+1, ");\n");
				od;
				template := __SIMPLICIAL_ReadTemplateFromFile("/pkg/simplicial-surfaces/doc/JS_associate_points_init_faces.html.template");
				AppendTo( output, template );
				for i in [0..(NumberOfVertices(surface)-1)] do
					AppendTo(output, "\t\tfaces.vertices.push(allpoints[", i, "].vector);\n");
				od;

				# Add Faces to scenario
				template := __SIMPLICIAL_ReadTemplateFromFile("/pkg/simplicial-surfaces/doc/JS_faces_material.html.template");
				AppendTo( output, template );
				for vertOfFace in VerticesOfFaces(surface) do
					AppendTo(output, "\t\tfaces.faces.push(new THREE.Face3(", vertOfFace[1]-1, ",", vertOfFace[2]-1, ",", vertOfFace[3]-1, ",undefined, undefined, 0));\n");
				od;
				template := __SIMPLICIAL_ReadTemplateFromFile("/pkg/simplicial-surfaces/doc/JS_add_faces_init_edges.html.template");
				AppendTo( output, template );

				# Add Edges to scenario
				for vertOfEdge in VerticesOfEdges(surface) do
					AppendTo(output, "\t\tvar line = new THREE.Geometry();\n");
					AppendTo(output, "\t\tline.vertices.push(allpoints[", vertOfEdge[1]-1, "].vector);\n");
					AppendTo(output, "\t\tline.vertices.push(allpoints[", vertOfEdge[2]-1, "].vector);\n");
					AppendTo(output, "\t\tobj.add(new THREE.Line(line, lines_material));\n");
				od;

				template := __SIMPLICIAL_ReadTemplateFromFile("/pkg/simplicial-surfaces/doc/JS_Footer.html.template");
				AppendTo( output, template );

				CloseStream(output);
        return printRecord;
    end
);

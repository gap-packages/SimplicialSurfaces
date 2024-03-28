#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2019
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

DeclareRepresentation( "PolygonalComplexMorphismRep", 
    IsPolygonalMorphism and IsAttributeStoringRep, [] );

  
fam := ElementsFamily( FamilyObj( [1,2,3] ) );
BindGlobal( "PolygonalComplexMorphismType",
    NewType( GeneralMappingsFamily(fam,fam), IsPolygonalMorphism and PolygonalComplexMorphismRep ) );
       




#######################################
##
##      VEF-labels
##

InstallMethod( VEFLabels, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        local res, vMax, eMax;

        vMax := Maximum( VerticesAttributeOfComplex(complex) );
        eMax := Maximum( Edges(complex) );
    
        res := ShallowCopy( VerticesAttributeOfComplex(complex) );
        Append(res, Edges(complex) + vMax );
        Append(res, Faces(complex) + vMax + eMax );

        return res;
    end
);


InstallMethod( VEFLabelsOfVertices, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        local res, v;

        res := [];
        for v in VerticesAttributeOfComplex(complex) do
            res[v] := v;
        od;
        return res;
    end
);
InstallMethod( VEFLabelsOfEdges, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        local res, e, shift;

        shift := Maximum(VerticesAttributeOfComplex(complex));
        res := [];
        for e in Edges(complex) do
            res[e] := e + shift;
        od;
        return res;
    end
);
InstallMethod( VEFLabelsOfFaces, "for a polygonal complex", [IsPolygonalComplex],
    function(complex)
        local res, f, shift;
        
        shift := Maximum(VerticesAttributeOfComplex(complex)) + Maximum(Edges(complex));
        res := [];
        for f in Faces(complex) do
            res[f] := f + shift;
        od;
        return res;
    end
);

BindGlobal( "__SIMPLICIAL_ImplementVEFLabel",
    function(pairs)
        local name, nameNC, baseName, baseFct, checkName, checkFct;

        name := Concatenation( "VEFLabelOf", pairs[1] );
        nameNC := Concatenation( name, "NC" );
        baseName := Concatenation( "VEFLabelsOf", pairs[2] );
        baseFct := ValueGlobal(baseName);
        checkName := Concatenation( "__SIMPLICIAL_Check", pairs[1] );
        checkFct := ValueGlobal( checkName );
        InstallMethod( ValueGlobal(nameNC), 
            "for a polygonal complex and a positive integer",
            [ IsPolygonalComplex, IsPosInt ],
            function(complex, el)
                return baseFct(complex)[el];
            end
        );
        InstallMethod( ValueGlobal(name),
            "for a polygonal complex and a positive integer",
            [IsPolygonalComplex, IsPosInt],
            function(complex, el)
                checkFct(complex, el, name);
                return baseFct(complex)[el];
            end
        );
    end
);

for pairs in [ ["Vertex", "Vertices"], ["Edge", "Edges"], ["Face", "Faces"] ] do
    __SIMPLICIAL_ImplementVEFLabel(pairs);
od;


InstallMethod( VertexOfVEFLabelNC, "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, label)
        return label;
    end
);
InstallMethod( VertexOfVEFLabel, "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, label)
        local res;

        res := VertexOfVEFLabelNC(complex, label);
        if res in VerticesAttributeOfComplex(complex) then
            return res;
        else
            return fail;
        fi;
    end
);

InstallMethod( EdgeOfVEFLabelNC, "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, label)
        return label - Maximum(VerticesAttributeOfComplex(complex));
    end
);
InstallMethod( EdgeOfVEFLabel, "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, label)
        local res;

        res := EdgeOfVEFLabelNC(complex, label);
        if res in Edges(complex) then
            return res;
        else
            return fail;
        fi;
    end
);

InstallMethod( FaceOfVEFLabelNC, "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, label)
        return label - Maximum(VerticesAttributeOfComplex(complex)) - Maximum(Edges(complex));
    end
);
InstallMethod( FaceOfVEFLabel, "for a polygonal complex and a positive integer",
    [IsPolygonalComplex, IsPosInt],
    function(complex, label)
        local res;

        res := FaceOfVEFLabelNC(complex, label);
        if res in Faces(complex) then
            return res;
        else
            return fail;
        fi;
    end
);


##
##      End VEF-labels
##
#######################################




#######################################
##
##      Constructions of morphisms
##

InstallMethod( PolygonalMorphismByListsNC,
    "for two polygonal complexes and three lists",
    [IsPolygonalComplex, IsPolygonalComplex, IsList, IsList, IsList],
    function(sourceComplex, rangeComplex, vertexMap, edgeMap, faceMap)
        local obj, fam;

#        fam := ElementsFamily( FamilyObj( VEFLabels(sourceComplex) ) );
#        obj := Objectify( NewType( GeneralMappingsFamily(fam, fam), IsPolygonalMorphism and PolygonalComplexMorphismRep ), rec() );
        obj := Objectify( PolygonalComplexMorphismType, rec() );
        SetSourceComplex(obj, sourceComplex);
        SetRangeComplex(obj, rangeComplex);
        SetVertexMapAsImageList(obj, vertexMap);
        SetEdgeMapAsImageList(obj, edgeMap);
        SetFaceMapAsImageList(obj, faceMap);

        return obj;
    end
);
InstallMethod( PolygonalMorphismByLists,
    "for two polygonal complexes and three lists",
    [IsPolygonalComplex, IsPolygonalComplex, IsList, IsList, IsList],
    function(sourceComplex, rangeComplex, vertexMap, edgeMap, faceMap)
        local v, e, f, vIm, eIm, fIm, rangeEdges, rangeVerts, srcEdges,
            imEdges, rngEdges, srcVertices, imVertices, v1, v2;

        # Check vertex map
        for v in VerticesAttributeOfComplex(sourceComplex) do
            if not IsBound(vertexMap[v]) then
                Error(Concatenation("PolygonalMorphismByLists: Vertex ", String(v), " has no image.\n"));
            fi;
            if not vertexMap[v] in VerticesAttributeOfComplex(rangeComplex) then
                Error(Concatenation("PolygonalMorphismByLists: Vertex ", String(v), " is not mapped to a vertex of the range complex, but to ", String(vertexMap[v]), ".\n"));
            fi;
        od;
        for v in Difference( [1..Length(vertexMap)], VerticesAttributeOfComplex(sourceComplex) ) do
            if IsBound(vertexMap[v]) then
                Error(Concatenation("PolygonalMorphismByLists: Index ", String(v), " is not a vertex of the source complex, but is mapped to ", String(vertexMap[v]), ".\n"));
            fi;
        od;

        # Check edge map
        for e in Edges(sourceComplex) do
            if not IsBound(edgeMap[e]) then
                Error(Concatenation("PolygonalMorphismByLists: Edge ", String(e), " has no image.\n"));
            fi;
            if not edgeMap[e] in Edges(rangeComplex) then
                Error(Concatenation("PolygonalMorphismByLists: Edge ", String(e), " is not mapped to an edge of the range complex, but to ", String(edgeMap[e]), ".\n"));
            fi;
        od;
        for e in Difference( [1..Length(edgeMap)], Edges(sourceComplex) ) do
            if IsBound(edgeMap[e]) then
                Error(Concatenation("PolygonalMorphismByLists: Index ", String(e), " is not an edge of the source complex, but is mapped to ", String(edgeMap[e]), ".\n"));
            fi;
        od;

        # Check face map
        for f in Faces(sourceComplex) do
            if not IsBound(faceMap[f]) then
                Error(Concatenation("PolygonalMorphismByLists: Face ", String(f), " has no image.\n"));
            fi;
            if not faceMap[f] in Faces(rangeComplex) then
                Error(Concatenation("PolygonalMorphismByLists: Face ", String(f), " is not mapped to a face of the range complex, but to ", String(faceMap[f]), ".\n"));
            fi;
        od;
        for f in Difference( [1..Length(faceMap)], Faces(sourceComplex) ) do
            if IsBound(faceMap[f]) then
                Error(Concatenation("PolygonalMorphismByLists: Index ", String(f), " is not a face of the source complex, but is mapped to ", String(faceMap[f]), ".\n"));
            fi;
        od;

        # At this point, all individual maps are single-valued and total
        # Check incidence relation

        # vertex-edge incidence
        for e in Edges(sourceComplex) do
            eIm := edgeMap[e];
            rangeVerts := VerticesOfEdges(rangeComplex)[eIm];
            for v in VerticesOfEdges(sourceComplex)[e] do
                vIm := vertexMap[v];
                if not vIm in rangeVerts then
                    Error("PolygonalMorphismByLists: In the source complex, vertex ", 
                        String(v), " is incident to edge ", String(e), 
                        ", but they are mapped to the vertex ", 
                        String(vIm), " and the edge ", String(eIm), 
                        ", which are not incident in the range complex.\n");
                fi;
            od;
            # Check whether the two incident vertices are mapped to
            # different vertices
            v1 := VerticesOfEdges(sourceComplex)[e][1];
            v2 := VerticesOfEdges(sourceComplex)[e][2];
            if vertexMap[v1] = vertexMap[v2] then
                Error("PolygonalMorphismByLists: The vertices ", String(v1), 
                    " and ", String(v2), " of the edge ", String(e), 
                    " have to be mapped to the different vertices.\n");
            fi;
        od;
        # edge-face incidence
        for f in Faces(sourceComplex) do
            fIm := faceMap[f];
            srcEdges := EdgesOfFaces(sourceComplex)[f];
            rngEdges := EdgesOfFaces(rangeComplex)[fIm];
            if Length( srcEdges ) <> Length( rngEdges ) then
                Error("PolygonalMorphismByLists: The polygon ", String(f),
                    " has ", String(Length(srcEdges)),
                    " sides, but is mapped to the polygon ", String(fIm),
                    ", which has ", String(Length(rngEdges)),
                    " sides.\n");
            fi;

            rangeEdges := EdgesOfFaces(rangeComplex)[fIm];
            for e in EdgesOfFaces(sourceComplex)[f] do
                eIm := edgeMap[e];
                if not eIm in rangeEdges then
                    Error("PolygonalMorphismByLists: In the source complex, edge ", 
                        String(e), " is incident to face ", String(f), 
                        ", but they are mapped to the edge ", 
                        String(eIm), " and the face ", String(fIm), 
                        ", which are not incident in the range complex.\n");
                fi;
            od;
            # Check whether the polygon-structure is preserved
            # We need to check that the vertices and edges are mapped to
            # different elements and that they are not mapped to a larger 
            # polygon
            imEdges := List(srcEdges, e -> edgeMap[e]);
            if Length(Set(imEdges)) < Length(srcEdges) then
                Error("PolygonalMorphismByLists: The edges ", 
                    String(srcEdges), " of the face ", String(f),
                    " have to be mapped to different edges, but are mapped to ",
                    String(imEdges), ".\n");
            fi;

            srcVertices := VerticesOfFaces(sourceComplex)[f];
            imVertices := List(srcVertices, v -> vertexMap[v]);
            if Length(Set(imVertices)) < Length(srcVertices) then
                Error("PolygonalMorphismByLists: The vertices ",
                    String(srcVertices), " of the face ", String(f),
                    " have to be mapped to different vertices, but are mapped to ",
                    String(imVertices), ".\n");
            fi;
        od;


        return PolygonalMorphismByListsNC(sourceComplex, rangeComplex, vertexMap, edgeMap, faceMap);
    end
);

RedispatchOnCondition( PolygonalMorphismByVertexImages, true, 
    [IsPolygonalComplex, IsPolygonalComplex, IsList], 
    [IsAnomalyFree, IsAnomalyFree], 0 );
RedispatchOnCondition( PolygonalMorphismByVertexImagesNC, true, 
    [IsPolygonalComplex, IsPolygonalComplex, IsList], 
    [IsAnomalyFree, IsAnomalyFree], 0 );
BindGlobal("__SIMPLICIAL_EdgeMapFromVertexMap",
    function(source, range, vertexMap)
        local edgeMap, edge, verts, newVerts, newEdge;

        edgeMap := [];
        for edge in Edges(source) do
            verts := VerticesOfEdges(source)[edge];
            newVerts := Set(vertexMap{verts});
            newEdge := Position( VerticesOfEdges(range), newVerts );
            edgeMap[edge] := newEdge;
        od;

        return edgeMap;
    end
);
BindGlobal("__SIMPLICIAL_FaceMapFromVertexMap",
    function(source, range, vertexMap)
        local faceMap, face, verts, newVerts, newFace;

        faceMap := [];
        for face in Faces(source) do
            verts := VerticesOfFaces(source)[face];
            newVerts := Set(vertexMap{verts});
            newFace := Position( VerticesOfFaces(range), newVerts );
            faceMap[face] := newFace;
        od;

        return faceMap;
    end
);
InstallMethod( PolygonalMorphismByVertexImagesNC, 
    "for two anomaly-free polygonal complexes and a list",
    [IsPolygonalComplex and IsAnomalyFree, IsPolygonalComplex and IsAnomalyFree, IsList],
    function(source, range, vertexMap)
        return PolygonalMorphismByListsNC(source, range, vertexMap,
            __SIMPLICIAL_EdgeMapFromVertexMap(source, range, vertexMap),
            __SIMPLICIAL_FaceMapFromVertexMap(source, range, vertexMap) );
    end
);
InstallMethod( PolygonalMorphismByVertexImages, 
    "for two anomaly-free polygonal complexes and a list",
    [IsPolygonalComplex and IsAnomalyFree, IsPolygonalComplex and IsAnomalyFree, IsList],
    function(source, range, vertexMap)
        # Strictly speaking, not all tests of PolygonalMorphismByLists are necessary
        return PolygonalMorphismByLists(source, range, vertexMap,
            __SIMPLICIAL_EdgeMapFromVertexMap(source, range, vertexMap),
            __SIMPLICIAL_FaceMapFromVertexMap(source, range, vertexMap) );
    end
);

InstallMethod( PolygonalIdentityMorphism, "for a polygonal complex",
    [IsPolygonalComplex],
    function( complex )
        local vMap, eMap, fMap, v, e, f;

        vMap := [];
        for v in VerticesAttributeOfComplex(complex) do
            vMap[v] := v;
        od;
        eMap := [];
        for e in Edges(complex) do
            eMap[e] := e;
        od;
        fMap := [];
        for f in Faces(complex) do
            fMap[f] := f;
        od;

        return PolygonalMorphismByListsNC(complex, complex, vMap, eMap, fMap);
    end
);


InstallMethod( CompositionMapping2, "for two polygonal morphisms",
    [IsPolygonalMorphism, IsPolygonalMorphism],
    function( second, first )
        local vMap, eMap, fMap, source, v, e, f;

        if RangeComplex(first) <> SourceComplex(second) then
            Error( "CompositionMapping2: Range of the first polygonal morphism is not equal to the source of the second polygonal morphism.");
        fi;

        source := SourceComplex( first );
        vMap := [];
        for v in VerticesAttributeOfComplex(source) do
            vMap[v] := VertexMapAsImageList(second)[VertexMapAsImageList(first)[v]];
        od;
        eMap := [];
        for e in Edges(source) do
            eMap[e] := EdgeMapAsImageList(second)[EdgeMapAsImageList(first)[e]];
        od;
        fMap := [];
        for f in Faces(source) do
            fMap[f] := FaceMapAsImageList(second)[FaceMapAsImageList(first)[f]];
        od;

        return PolygonalMorphismByListsNC(source, RangeComplex(second), vMap, eMap, fMap);
    end
);


InstallMethod( InversePolygonalMorphism, "for a bijective polygonal morphism",
    [IsPolygonalMorphism and IsBijective],
    function( isoMor )
        local newSource, newRange, newVertexMap, newEdgeMap, newFaceMap, v, e, f;

        newSource := RangeComplex(isoMor);
        newRange := SourceComplex(isoMor);

        newVertexMap := [];
        for v in VerticesAttributeOfComplex(newRange) do
            newVertexMap[ VertexMapAsImageList(isoMor)[v] ] := v;
        od;

        newEdgeMap := [];
        for e in Edges(newRange) do
            newEdgeMap[ EdgeMapAsImageList(isoMor)[e] ] := e;
        od;

        newFaceMap := [];
        for f in Faces(newRange) do
            newFaceMap[ FaceMapAsImageList(isoMor)[f] ] := f;
        od;

        return PolygonalMorphismByListsNC(newSource, newRange, newVertexMap, newEdgeMap, newFaceMap);
    end
);
RedispatchOnCondition( InversePolygonalMorphism, true, [IsPolygonalMorphism], [IsBijective], 0 );

InstallMethod( InverseGeneralMapping, "for a polygonal morphism",
    [IsPolygonalMorphism],
    function( polMor )
        if not IsBijective(polMor) then
            Error("InverseGeneralMapping: Only bijective polygonal morphisms can be inverted.");
        fi;

        return InversePolygonalMorphism(polMor);
    end
);  

##
##      End of constructions
##
#######################################


#######################################
##
##      Images and Preimages
##

InstallMethod( ImageOfVertexNC, 
    "for a polygonal morphism and a positive integer", 
    [IsPolygonalMorphism, IsPosInt],
    function(polMor, v)
        return VertexMapAsImageList(polMor)[v];
    end
);
InstallMethod( ImageOfVertex, 
    "for a polygonal morphism and a positive integer", 
    [IsPolygonalMorphism, IsPosInt],
    function(polMor, v)
        __SIMPLICIAL_CheckVertex( SourceComplex(polMor), v, "ImageOfVertex" );
        return ImageOfVertexNC(polMor, v);
    end
);


InstallMethod( ImageOfEdgeNC, 
    "for a polygonal morphism and a positive integer", 
    [IsPolygonalMorphism, IsPosInt],
    function(polMor, e)
        return EdgeMapAsImageList(polMor)[e];
    end
);
InstallMethod( ImageOfEdge, 
    "for a polygonal morphism and a positive integer", 
    [IsPolygonalMorphism, IsPosInt],
    function(polMor, e)
        __SIMPLICIAL_CheckEdge( SourceComplex(polMor), e, "ImageOfEdge" );
        return ImageOfEdgeNC(polMor, e);
    end
);


InstallMethod( ImageOfFaceNC, 
    "for a polygonal morphism and a positive integer", 
    [IsPolygonalMorphism, IsPosInt],
    function(polMor, f)
        return FaceMapAsImageList(polMor)[f];
    end
);
InstallMethod( ImageOfFace, 
    "for a polygonal morphism and a positive integer", 
    [IsPolygonalMorphism, IsPosInt],
    function(polMor, f)
        __SIMPLICIAL_CheckFace( SourceComplex(polMor), f, "ImageOfFace" );
        return ImageOfFaceNC(polMor, f);
    end
);

# Basic operation
InstallMethod( ImagesElm, "for a polygonal morphism and a positive integer",
    [IsPolygonalMorphism, IsPosInt],
    function(polMor, x)
        local source, range, vertex, edge, face, image;

        source := SourceComplex(polMor);
        range := RangeComplex(polMor);

        vertex := VertexOfVEFLabel(source, x);
        if vertex <> fail then
            image := ImageOfVertexNC(polMor, vertex);
            return [ VEFLabelOfVertexNC(range, image) ];
        fi;
        
        edge := EdgeOfVEFLabel(source, x);
        if edge <> fail then
            image := ImageOfEdgeNC(polMor, edge);
            return [ VEFLabelOfEdgeNC(range, image) ];
        fi;

        face := FaceOfVEFLabel(source, x);
        if face <> fail then
            image := ImageOfFaceNC(polMor, face);
            return [ VEFLabelOfFaceNC(range, image) ];
        fi;

        return fail;
    end
);



InstallMethod( PreImagesOfVertexNC, 
    "for a polygonal morphism and a positive integer",
    [IsPolygonalMorphism, IsPosInt],
    function(polMor, el)
        return Positions( VertexMapAsImageList(polMor), el );
    end
);
InstallMethod( PreImagesOfVertex, 
    "for a polygonal morphism and a positive integer",
    [IsPolygonalMorphism, IsPosInt],
    function(polMor, el)
        __SIMPLICIAL_CheckVertex( RangeComplex(polMor), el, "PreImagesOfVertex" );
        return PreImagesOfVertexNC(polMor, el);
    end
);


InstallMethod( PreImagesOfEdgeNC, 
    "for a polygonal morphism and a positive integer",
    [IsPolygonalMorphism, IsPosInt],
    function(polMor, el)
        return Positions( EdgeMapAsImageList(polMor), el );
    end
);
InstallMethod( PreImagesOfEdge, 
    "for a polygonal morphism and a positive integer",
    [IsPolygonalMorphism, IsPosInt],
    function(polMor, el)
        __SIMPLICIAL_CheckEdge( RangeComplex(polMor), el, "PreImagesOfEdge" );
        return PreImagesOfEdgeNC(polMor, el);
    end
);


InstallMethod( PreImagesOfFaceNC, 
    "for a polygonal morphism and a positive integer",
    [IsPolygonalMorphism, IsPosInt],
    function(polMor, el)
        return Positions( FaceMapAsImageList(polMor), el );
    end
);
InstallMethod( PreImagesOfFace, 
    "for a polygonal morphism and a positive integer",
    [IsPolygonalMorphism, IsPosInt],
    function(polMor, el)
        __SIMPLICIAL_CheckFace( RangeComplex(polMor), el, "PreImagesOfFace" );
        return PreImagesOfFaceNC(polMor, el);
    end
);

# Basic operation
InstallMethod( PreImagesElm,
    "for a polygonal morphism and a list",
    [IsPolygonalMorphism, IsList],
    function(polMor, x)
        local source, range, vertex, edge, face, image;

        source := SourceComplex(polMor);
        range := RangeComplex(polMor);

        vertex := VertexOfVEFLabel(range, x);
        if vertex <> fail then
            image := PreImagesOfVertexNC(polMor, vertex);
            return VEFLabelsOfVertices(source){image};
        fi;
        
        edge := EdgeOfVEFLabel(range, x);
        if edge <> fail then
            image := PreImagesOfEdgeNC(polMor, edge);
            return VEFLabelsOfEdges(source){image};
        fi;

        face := FaceOfVEFLabel(range, x);
        if face <> fail then
            image := PreImagesOfFaceNC(polMor, face);
            return VEFLabelsOfFaces(source){image};
        fi;

        return fail;
    end
);


##
##      End of (pre)Images
##
#######################################


#######################################
##
##      Components of morphisms
##

InstallMethod( SourceComplex, 
    "for a general polygonal morphism with SourceSurface",
    [IsGeneralPolygonalMorphism and HasSourceSurface],
    function(polMor)
        return SourceSurface(polMor);
    end
);
InstallMethod( SourceSurface, 
    "for a general polygonal morphism with SourceComplex",
    [IsGeneralPolygonalMorphism and HasSourceComplex],
    function(polMor)
        local source;

        source := SourceComplex(polMor);
        if IsPolygonalSurface(source) then
            return source;
        else
            return fail;
        fi;
    end
);

# Basic operation
InstallMethod( Source, "for a general polygonal morphism", 
    [IsGeneralPolygonalMorphism],
    function(polMor)
        return VEFLabels( SourceComplex(polMor) );
    end
);


InstallMethod( RangeComplex, 
    "for a general polygonal morphism with RangeSurface",
    [IsGeneralPolygonalMorphism and HasRangeSurface],
    function(polMor)
        return RangeSurface(polMor);
    end
);
InstallMethod( RangeSurface, 
    "for a general polygonal morphism with RangeComplex",
    [IsGeneralPolygonalMorphism and HasRangeComplex],
    function(polMor)
        local range;

        range := RangeComplex(polMor);
        if IsPolygonalSurface(range) then
            return range;
        else
            return fail;
        fi;
    end
);

# Basic operation
InstallMethod( Range, "for a general polygonal morphism", 
    [IsGeneralPolygonalMorphism],
    function(polMor)
        return VEFLabels( RangeComplex(polMor) );
    end
);


InstallMethod( VertexMapAsImageList,
    "for a polygonal morphism with SourceComplex, RangeComplex and VEFLabelMapAsImageList",
    [IsPolygonalMorphism and HasSourceComplex and HasRangeComplex and HasVEFLabelMapAsImageList],
    function(polMor)
        local vMap, source, range, v, vefLabel, vIm, vefImage;

        vMap := [];
        source := SourceComplex(polMor);
        range := RangeComplex(polMor);
        for v in VerticesAttributeOfComplex( source ) do
            vefLabel := VEFLabelsOfVertices(source)[v];
            vefImage := VEFLabelMapAsImageList(polMor)[vefLabel];
            vIm := VertexOfVEFLabel(range, vefImage);
            vMap[v] := vIm;
        od;

        return vMap;
    end
);

InstallMethod( EdgeMapAsImageList,
    "for a polygonal morphism with SourceComplex, RangeComplex and VEFLabelMapAsImageList",
    [IsPolygonalMorphism and HasSourceComplex and HasRangeComplex and HasVEFLabelMapAsImageList],
    function(polMor)
        local eMap, source, range, e, vefLabel, eIm, vefImage;

        eMap := [];
        source := SourceComplex(polMor);
        range := RangeComplex(polMor);
        for e in Edges( source ) do
            vefLabel := VEFLabelsOfEdges(source)[e];
            vefImage := VEFLabelMapAsImageList(polMor)[vefLabel];
            eIm := EdgeOfVEFLabel(range, vefImage);
            eMap[e] := eIm;
        od;

        return eMap;
    end
);

InstallMethod( FaceMapAsImageList,
    "for a polygonal morphism with SourceComplex, RangeComplex and VEFLabelMapAsImageList",
    [IsPolygonalMorphism and HasSourceComplex and HasRangeComplex and HasVEFLabelMapAsImageList],
    function(polMor)
        local fMap, source, range, f, vefLabel, fIm, vefImage;

        fMap := [];
        source := SourceComplex(polMor);
        range := RangeComplex(polMor);
        for f in Faces( source ) do
            vefLabel := VEFLabelsOfFaces(source)[f];
            vefImage := VEFLabelMapAsImageList(polMor)[vefLabel];
            fIm := FaceOfVEFLabel(range, vefImage);
            fMap[f] := fIm;
        od;

        return fMap;
    end
);


InstallMethod( VEFLabelMapAsImageList,
    "for a polygonal morphism with SourceComplex, RangeComplex, VertexMapAsImageList, EdgeMapAsImageList and FaceMapAsImageList",
    [IsPolygonalMorphism and HasSourceComplex and HasRangeComplex and HasVertexMapAsImageList and HasEdgeMapAsImageList and HasFaceMapAsImageList],
    function(polMor)
        local vefMap, v, e, f, source, range, im;

        vefMap := [];
        source := SourceComplex(polMor);
        range := RangeComplex(polMor);
        for v in VerticesAttributeOfComplex(source) do
            im := VertexMapAsImageList(polMor)[v];
            vefMap[ VEFLabelsOfVertices(source)[v] ] := VEFLabelsOfVertices(range)[im];
        od;
        for e in Edges(source) do
            im := EdgeMapAsImageList(polMor)[e];
            vefMap[ VEFLabelsOfEdges(source)[e] ] := VEFLabelsOfEdges(range)[im];
        od;
        for f in Faces(source) do
            im := FaceMapAsImageList(polMor)[f];
            vefMap[ VEFLabelsOfFaces(source)[f] ] := VEFLabelsOfFaces(range)[im];
        od;

        return vefMap;
    end
);

##
##      End of components
##
#######################################


#######################################
##
##      General methods
##
InstallMethod( \=, "for two polygonal morphisms", IsIdenticalObj,
    [IsPolygonalMorphism, IsPolygonalMorphism],
    function(mor1, mor2)
        return SourceComplex(mor1) = SourceComplex(mor2)
            and RangeComplex(mor1) = RangeComplex(mor2)
            and VEFLabelMapAsImageList(mor1) = VEFLabelMapAsImageList(mor2);
    end
);

InstallMethod( ViewString, "for a polygonal morphism", [IsPolygonalMorphism],
    function(mor)
        return "<polygonal morphism>";
    end
);

InstallMethod( String, "for a polygonal morphism", [IsPolygonalMorphism],
    function(mor)
        return Concatenation( "PolygonalMorphismByListsNC( ",
            String(SourceComplex(mor)), ", ",
            String(RangeComplex(mor)), ", ",
            String(VertexMapAsImageList(mor)), ", ",
            String(EdgeMapAsImageList(mor)), ", ",
            String(FaceMapAsImageList(mor)), ");" );
    end
);
InstallMethod( PrintObj, "for a polygonal morphism", [IsPolygonalMorphism],
    function(mor)
        Print( String(mor) );
    end
);

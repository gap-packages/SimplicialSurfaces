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

BindGlobal( "PolygonalComplexMorphismType", 
    NewType( GeneralPolygonalMorphismFamily, PolygonalComplexMorphismRep ) );




#######################################
##
##      VEF-labels
##

InstallMethod( VEFLabels, "for a VEF-complex", [IsVEFComplex],
    function(complex)
        local res, vMax, eMax;

        vMax := Maximum( VerticesAttributeOfVEFComplex(complex) );
        eMax := Maximum( Edges(complex) );
    
        res := ShallowCopy( VerticesAttributeOfVEFComplex(complex) );
        Append(res, Edges(complex) + vMax );
        Append(res, Faces(complex) + vMax + eMax );

        return res;
    end
);


InstallMethod( VEFLabelsOfVertices, "for a VEF-complex", [IsVEFComplex],
    function(complex)
        local res, v;

        res := [];
        for v in VerticesAttributeOfVEFComplex(complex) do
            res[v] := v;
        od;
        return res;
    end
);
InstallMethod( VEFLabelsOfEdges, "for a VEF-complex", [IsVEFComplex],
    function(complex)
        local res, e, shift;

        shift := Maximum(VerticesAttributeOfVEFComplex(complex));
        res := [];
        for e in Edges(complex) do
            res[e] := e + shift;
        od;
        return res;
    end
);
InstallMethod( VEFLabelsOfFaces, "for a VEF-complex", [IsVEFComplex],
    function(complex)
        local res, f, shift;
        
        shift := Maximum(VerticesAttributeOfVEFComplex(complex)) + Maximum(Edges(complex));
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
            "for a VEF-complex and a positive integer",
            [ IsVEFComplex, IsPosInt ],
            function(complex, el)
                return baseFct(complex)[el];
            end
        );
        InstallMethod( ValueGlobal(name),
            "for a VEF-complex and a positive integer",
            [IsVEFComplex, IsPosInt],
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


InstallMethod( VertexOfVEFLabelNC, "for a VEF-complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, label)
        return label;
    end
);
InstallMethod( VertexOfVEFLabel, "for a VEF-complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, label)
        local res;

        res := VertexOfVEFLabelNC(complex, label);
        if res in VerticesAttributeOfVEFComplex(complex) then
            return res;
        else
            return fail;
        fi;
    end
);

InstallMethod( EdgeOfVEFLabelNC, "for a VEF-complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, label)
        return label - Maximum(VerticesAttributeOfVEFComplex(complex));
    end
);
InstallMethod( EdgeOfVEFLabel, "for a VEF-complex and a positive integer",
    [IsVEFComplex, IsPosInt],
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

InstallMethod( FaceOfVEFLabelNC, "for a VEF-complex and a positive integer",
    [IsVEFComplex, IsPosInt],
    function(complex, label)
        return label - Maximum(VerticesAttributeOfVEFComplex(complex)) - Maximum(Edges(complex));
    end
);
InstallMethod( FaceOfVEFLabel, "for a VEF-complex and a positive integer",
    [IsVEFComplex, IsPosInt],
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
        Error("TODO");
    end
);


##
##      End of constructions
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

##
##      End of components
##
#######################################

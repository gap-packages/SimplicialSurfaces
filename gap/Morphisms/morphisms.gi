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
    IsGeneralPolygonalMorphism and IsAttributeStoringRep, [] );

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
        return VerticesAttributeOfVEFComplex(complex);
    end
);
InstallMethod( VEFLabelsOfEdges, "for a VEF-complex", [IsVEFComplex],
    function(complex)
        return Edges(complex) + Maximum(VerticesAttributeOfVEFComplex(complex));
    end
);
InstallMethod( VEFLabelsOfFaces, "for a VEF-complex", [IsVEFComplex],
    function(complex)
        return Faces(complex) + Maximum(VerticesAttributeOfVEFComplex(complex)) + Maximum(Edges(complex));
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



##
##      End VEF-labels
##
#######################################

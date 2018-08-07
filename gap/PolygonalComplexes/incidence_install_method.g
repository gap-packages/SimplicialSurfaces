#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2018
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################


## The aim of this file is to automatize the method installation for the
## diverse incidence relations
##
## We have:
## 1) Vertices, Edges, Faces
## 2) LocalFlags
## 3) LocalVertices, LocalEdges, HalfEdges
##
## The incidence relations fall in three classes:
## 1) many-of-many: For each element of one, there is a set of the other
##    These sets are not disjoint.
## 2) partition-of-unique: For each element of one, there is a set of
##    the other. These sets are disjoint.
## 3) unique-of-partition: For each element of one, there is exactly one
##    element of the other.
##
## Inverting a relation switches the name around (unique-of-partition and
## partition-of-unique are inverse of each other). Transitivity combines
## the outer parts of the names.
##
## In addition we have the issue of multiple categories for which these
## properties may be defined.


##
## Inversion methods
##

##
## Transform A_Of_B to B_Of_A (many-to-many).
##
BindGlobal( "__SIMPLICIAL_InvertIncidence_ManyOfMany", 
    function( a_labels, a_of_b, b_labels )
        local b_of_a, a, b_set, b;

        b_of_a := [];
        for a in a_labels do
            b_of_a[a] := [];
        od;
        for b in b_labels do
            for a in a_of_b[b] do
                Add( b_of_a[a], b );
            od;
        od;

        for a in a_labels do
            Sort(b_of_a[a]);
        od;
        return b_of_a;
    end
);

##
## Transform A_Of_B to B_Of_A (unique-of-partition).
##
BindGlobal( "__SIMPLICIAL_InvertIncidence_UniqueOfPartition", 
    function( a_labels, a_of_b, b_labels )
        local b_of_a, a, b_set, b;

        b_of_a := [];
        for a in a_labels do
            b_of_a[a] := [];
        od;
        for b in b_labels do
            Add( b_of_a[ a_of_b[b] ], b );
        od;

        for a in a_labels do
            Sort(b_of_a[a]);
        od;
        return b_of_a;
    end
);

##
## Transform A_Of_B to B_Of_A (partition-of-unique).
##
BindGlobal( "__SIMPLICIAL_InvertIncidence_PartitionOfUnique", 
    function( a_labels, a_of_b, b_labels )
        local b_of_a, a, b_set, b;

        b_of_a := [];
        for a in a_labels do
            b_of_a[a] := [];
        od;
        for b in b_labels do
            for a in a_of_b[b] do
                Add( b_of_a[a], b );
            od;
        od;

        for a in a_labels do
            Sort(b_of_a[a]);
        od;
        return b_of_a;
    end
);


##
## Transitivity methods
##


BindGlobal( "__SIMPLICIAL_TransitiveIncidence_ManyOfMany_SetStar",
    function( a_of_b, b_of_c, c_labels )
        local c, a_of_c, a_in_b, b_in_c, x;

        a_of_c := [];
        for c in c_labels do
            b_in_c := b_of_c[c];
            a_in_b := [];
            for x in b_in_c do
                Append(a_in_b, a_of_b[x]);
            od;
            a_of_c[c] := Set(a_in_b);
        od;

        return a_of_c;
    end
);
##
## Combine a_of_b and b_of_c to a_of_c (many-of-many + many-of-many)
##
BindGlobal( "__SIMPLICIAL_TransitiveIncidence_ManyOfMany_ManyOfMany", 
    function( a_of_b, b_of_c, c_labels )
        return __SIMPLICIAL_TransitiveIncidence_ManyOfMany_SetStar(a_of_b, b_of_c, c_labels);
    end
);
BindGlobal( "__SIMPLICIAL_TransitiveIncidence_ManyOfMany_PartitionOfUnique", 
    function( a_of_b, b_of_c, c_labels )
        return __SIMPLICIAL_TransitiveIncidence_ManyOfMany_SetStar(a_of_b, b_of_c, c_labels);
    end
);



BindGlobal( "__SIMPLICIAL_TransitiveIncidence_UniqueOfPartition_SetStar",
    function( a_of_b, b_of_c, c_labels )
        local c, a_of_c, a_in_b, b_in_c, x;

        a_of_c := [];
        for c in c_labels do
            b_in_c := b_of_c[c];
            a_in_b := [];
            for x in b_in_c do
                Add(a_in_b, a_of_b[x]);
            od;
            a_of_c[c] := Set(a_in_b);
        od;

        return a_of_c;
    end
);
##
## Combine a_of_b and b_of_c to a_of_c (unique-of-partition + many-of-many)
##
BindGlobal( "__SIMPLICIAL_TransitiveIncidence_UniqueOfPartition_ManyOfMany", 
    function( a_of_b, b_of_c, c_labels )
        return __SIMPLICIAL_TransitiveIncidence_UniqueOfPartition_SetStar(a_of_b, b_of_c, c_labels);
    end
);
BindGlobal( "__SIMPLICIAL_TransitiveIncidence_UniqueOfPartition_PartitionOfUnique", 
    function( a_of_b, b_of_c, c_labels )
        return __SIMPLICIAL_TransitiveIncidence_UniqueOfPartition_SetStar(a_of_b, b_of_c, c_labels);
    end
);

BindGlobal( "__SIMPLICIAL_TransitiveIncidence_PartitionOfUnique_SetStar",
    function( a_of_b, b_of_c, c_labels )
        local c, a_of_c, a_in_b, b_in_c, x;

        a_of_c := [];
        for c in c_labels do
            b_in_c := b_of_c[c];
            a_in_b := [];
            for x in b_in_c do
                Append(a_in_b, a_of_b[x]);
            od;
            Sort(a_in_b);
            a_of_c[c] := a_in_b;
        od;

        return a_of_c;
    end
);
##
## Combine a_of_b and b_of_c to a_of_c (partition-of-unique + many-of-many)
##
BindGlobal( "__SIMPLICIAL_TransitiveIncidence_PartitionOfUnique_ManyOfMany", 
    function( a_labels, a_of_b, b_labels, b_of_c, c_labels )
        return __SIMPLICIAL_TransitiveIncidence_PartitionOfUnique_SetStar(a_of_b, b_of_c, c_labels);
    end
);
BindGlobal( "__SIMPLICIAL_TransitiveIncidence_PartitionOfUnique_PartitionOfUnique", 
    function( a_labels, a_of_b, b_labels, b_of_c, c_labels )
        return __SIMPLICIAL_TransitiveIncidence_PartitionOfUnique_SetStar(a_of_b, b_of_c, c_labels);
    end
);


BindGlobal( "__SIMPLICIAL_TransitiveIncidence_Star_UniqueOfPartition",
    function( a_of_b, b_of_c, c_labels )
        local c, a_of_c;

        a_of_c := [];
        for c in c_labels do
            a_of_c[c] := a_of_b[ b_of_c[c] ];
        od;

        return a_of_c;
    end
);
##
## Combine a_of_b and b_of_c to a_of_c (many-of-many + unique-of-partition)
##
BindGlobal( "__SIMPLICIAL_TransitiveIncidence_ManyOfMany_UniqueOfPartition", 
    function( a_of_b, b_of_c, c_labels )
        return __SIMPLICIAL_TransitiveIncidence_Star_UniqueOfPartition(a_of_b, b_of_c, c_labels);
    end
);

##
## Combine a_of_b and b_of_c to a_of_c (unique-of-partition + unique-of-partition)
##
BindGlobal( "__SIMPLICIAL_TransitiveIncidence_UniqueOfPartition_UniqueOfPartition", 
    function( a_of_b, b_of_c, c_labels )
        return __SIMPLICIAL_TransitiveIncidence_Star_UniqueOfPartition(a_of_b, b_of_c, c_labels);
    end
);

##
## Combine a_of_b and b_of_c to a_of_c partition-of-unique + unique-of-partition)
##
BindGlobal( "__SIMPLICIAL_TransitiveIncidence_PartitionOfUnique_UniqueOfPartition", 
    function( a_of_b, b_of_c, c_labels )
        return __SIMPLICIAL_TransitiveIncidence_Star_UniqueOfPartition(a_of_b, b_of_c, c_labels);
    end
);


BindGlobal( "__SIMPLICIAL_InstallIncidenceMethods",
    function()
        local attrList, relationList, VEF, BEND, POLY, Find_category, attr, r,
            i, j, attr_A, attr_B, name, type, cat, invName, invAttr,
            invFctName, invFct, transAttr, transName, transFctName, transFct,
            attr_1, attr_2, wrapper, transTriple, ok;
            
        ## Define the different categories
        # name: Name of the category
        # cat: The category
        # add: The method to add an attribute to this category
        VEF := rec( name := "IsVEFComplex", add := __SIMPLICIAL_AddVEFAttribute, string := "VEF-complex", short := "VEF" );
        POLY := rec( name := "IsPolygonalComplex", add := __SIMPLICIAL_AddPolygonalAttribute, string := "polygonal complex", short := "POLY" );
        BEND := rec( name := "IsBendPolygonalComplex", add := __SIMPLICIAL_AddBendPolygonalAttribute, string := "bend polygonal complex", short := "BEND" );
        for r in [VEF,BEND,POLY] do
            r.cat := VALUE_GLOBAL(r.name);
        od;

        Find_category := function( lst )
            if "BEND" in lst and "POLY" in lst then
                return fail;
            fi;
            if "BEND" in lst then
                return BEND;
            fi;
            if "POLY" in lst then
                return POLY;
            fi;
            return VEF;
        end;


        ## Define the attributes
        # sing: Name of the thing in singular
        # plur: Name of the thing in plural
        # name: Attribute name
        # attr: Attribute
        # cat: Category for which the attribute is defined
        # uniqueTo: List of all attribute names such that the map from this attribute to the others is unique
        # tester: HasAttribute
        attrList := [
            rec( sing := "Vertex", plur := "Vertices", name := "VerticesAttributeOfVEFComplex", cat := "VEF" ),
            rec( sing := "Edge", plur := "Edges", cat := "VEF" ),
            rec( sing := "Face", plur := "Faces", cat := "VEF" ),
            rec( sing := "LocalFlag", plur := "LocalFlags", cat := "BEND", uniqueTo := "ALL" ),
            rec( sing := "LocalVertex", plur := "LocalVertices", cat := "BEND", uniqueTo := ["VerticesAttributeOfVEFComplex", "Faces"] ),
            rec( sing := "LocalEdge", plur := "LocalEdges", cat := "BEND", uniqueTo := ["Edges", "Faces"] ),
            rec( sing := "HalfEdge", plur := "HalfEdges", cat := "BEND", uniqueTo := ["VerticesAttributeOfVEFComplex", "Edges"] )
        ];
        for attr in attrList do
            if not IsBound(attr.name) then
                attr.name := attr.plur;
            fi;
            if not IsBound(attr.uniqueTo) then
                attr.uniqueTo := [];
            fi;
            attr.attr := VALUE_GLOBAL( attr.name );
            attr.tester := Tester(attr.attr);
        od;


        ## Initialise the attributes
        for attr in attrList do
            cat := Find_category([attr.cat]);
            cat.add(attr.attr);

            # if name is not equal to plur, implement a wrapper
            if attr.plur <> attr.name then
                wrapper := function( attr, cat )
                    InstallMethod( VALUE_GLOBAL(attr.plur), 
                        Concatenation("for a ", cat.string),
                        [ cat.cat ],
                        function(complex)
                            return attr.attr(complex);
                        end);
                end;
                wrapper(attr, cat);
            fi;
        od;


        ## Define the incidence attributes
        # name: Attribute name
        # attr: Attribute
        # type: What type of incidence is this?
        # cat: Category for which the attribute is defined
        # attr_content: The type of thing stading in the list
        # attr_index: The type of thing indexing the list
        relationList := [];
        for i in [1..Length(attrList)] do
            for j in [1..Length(attrList)] do
                if i = j then
                    continue;
                fi;
            
                # 
                attr_A := attrList[i];
                attr_B := attrList[j];
                name := Concatenation( attr_A.plur, "Of", attr_B.plur );
                attr := VALUE_GLOBAL(name);
                if attr_A.name in attr_B.uniqueTo or attr_B.uniqueTo = "ALL" then
                    type := "UniqueOfPartition";
                elif attr_B.name in attr_A.uniqueTo or attr_A.uniqueTo = "ALL" then
                    type := "PartitionOfUnique";
                else
                    type := "ManyOfMany";
                fi;
                cat := Find_category( [attr_A.cat, attr_B.cat] );

                Add( relationList, rec( name := name, attr := attr, type := type, cat := cat.short, attr_content := attr_A, attr_index := attr_B, tester := Tester(attr) ) );
            od;
        od;


        for attr in relationList do
            cat := Find_category([attr.cat]);

            # Initialise this attribute
            cat.add(attr.attr);

            # Implement implication to the content-side
            wrapper := function(attr, cat)
                if attr.type = "UniqueOfPartition" then
                    InstallMethod( attr.attr_content.attr,
                        Concatenation("for a ", cat.string, " with ", attr.name),
                        [ cat.cat and attr.tester ],
                        function(complex)
                            return Set( attr.attr(complex) );
                        end);
                else
                    InstallMethod( attr.attr_content.attr,
                        Concatenation("for a ", cat.string, " with ", attr.name),
                        [ cat.cat and attr.tester ],
                        function(complex)
                            return __SIMPLICIAL_UnionSets( attr.attr(complex) );
                        end);
                fi;
            end;
            wrapper(attr, cat);
            AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, 
                attr.attr_content.name, attr.name, [cat.name] );

            # Implement implication to the index-side
            wrapper := function(attr, cat)
                InstallMethod( attr.attr_index.attr,
                    Concatenation("for a ", cat.string, " with ", attr.name),
                    [ cat.cat and attr.tester ],
                    function(complex)
                        return __SIMPLICIAL_BoundPositions( attr.attr(complex) );
                    end);
            end;
            wrapper(attr, cat);
            AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, 
                attr.attr_index.name, attr.name, [cat.name] );


            # Implement inversion
            invName := Concatenation( attr.attr_index.plur, "Of", attr.attr_content.plur );
            invAttr := VALUE_GLOBAL(invName);
            invFctName := Concatenation( "__SIMPLICIAL_InvertIncidence_", attr.type );
            invFct := VALUE_GLOBAL(invFctName);
            wrapper := function(invAttr, invFct, attr, cat)
                InstallMethod( invAttr,
                    Concatenation("for a ", cat.string, " with ", attr.attr_content.name, " and ", attr.name, " and ", attr.attr_index.name),
                    [ cat.cat and attr.attr_content.tester and attr.tester and attr.attr_index.tester ],
                    function(complex)
                        return invFct(attr.attr_content.attr(complex), attr.attr(complex), attr.attr_index.attr(complex));
                    end);
            end;
            wrapper(invAttr,invFct, attr, cat);
            AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER, 
                invName, [attr.attr_content.name, attr.name, attr.attr_index.name], [cat.name] );


            #TODO implement VertexOfFace...
        od;

        transTriple := [
            ["Vertices", "Edges", "Faces"],
            #["Vertices", "LocalVertices", "Faces"], # Redundant by "uniqueTo"-condition
            ["Vertices", "LocalVertices", "Edges"],
            #["Edges", "LocalEdges", "Faces"], # Redundant by "uniqueTo"-condition
            ["Vertices", "LocalEdges", "Faces"],
            ["Vertices", "LocalEdges", "Edges"], #TODO LocalEdgesOfVertices are all local edges belonging to EdgesOfVertices
            ["Vertices", "Edges", "LocalEdges"],
            ["Edges", "HalfEdges", "Faces"],
            ["HalfEdges", "Edges", "Faces"],
            ["Vertices", "HalfEdges", "Faces"],
            #["Vertices", "HalfEdges", "Edges"], # Redundant by "uniqueTo"-condition
            ["Vertices", "LocalVertices", "LocalEdges"],
            ["Vertices", "LocalVertices", "HalfEdges"],
            ["Vertices", "HalfEdges", "LocalVertices"],
            ["Vertices", "HalfEdges", "LocalEdges"],
            ["LocalVertices", "LocalEdges", "Edges"], #TODO LocalVerticesOfEdge are only those bordering the edge
            ["LocalVertices", "HalfEdges", "Edges"],

            ["Edges", "LocalEdges", "HalfEdges"],
            ["HalfEdges", "Edges", "LocalEdges"],
            ["LocalEdges", "HalfEdges", "Edges"],

            ["LocalVertices", "LocalEdges", "Faces"],
            ["LocalEdges", "LocalVertices", "Faces"],
            ["HalfEdges", "LocalVertices", "Faces"],
            ["HalfEdges", "LocalEdges", "Faces"]
        ];
        Append(transTriple, List(transTriple, Reversed) );

        # Implement transitive incidence
        for i in [1..Length(relationList)] do
            for j in [1..Length(relationList)] do
                attr_1 := relationList[i];
                attr_2 := relationList[j];;
                if attr_1.attr_index.name <> attr_2.attr_content.name then
                    # can't be concatenated
                    continue;
                fi;
                if attr_1.attr_content.name = attr_2.attr_index.name then
                    continue;
                fi;

                ok := false;
                if [attr_1.attr_content.plur, attr_1.attr_index.plur, attr_2.attr_index.plur] in transTriple then
                    ok := true;
                fi;
                if attr_1.type = "PartitionOfUnique" and attr_2.type = "UniqueOfPartition" then
                    ok := true;
                fi;

                if not ok then
                    continue;
                fi;

                cat := Find_category( [attr_1.cat, attr_2.cat] );
                if cat = fail then
                    continue;
                fi;

                transName := Concatenation(attr_1.attr_content.plur, "Of", attr_2.attr_index.plur);
                transAttr := VALUE_GLOBAL(transName);
                transFctName := Concatenation( "__SIMPLICIAL_TransitiveIncidence_", attr_1.type, "_", attr_2.type );
                transFct := VALUE_GLOBAL(transFctName);
                wrapper := function( transAttr, cat, attr_1, attr_2, transFct )
                    InstallMethod( transAttr,
                        Concatenation("for a ", cat.string, " with ", attr_1.name, " and ", attr_2.name, " and ", attr_2.attr_index.name),
                        [ cat.cat and attr_1.tester and attr_2.tester and attr_2.attr_index.tester ],
                        function(complex)
                            return transFct( attr_1.attr(complex), attr_2.attr(complex), attr_2.attr_index.attr(complex) );
                        end);
                end;
                wrapper( transAttr, cat, attr_1, attr_2, transFct );
                AddPropertyIncidence( SIMPLICIAL_ATTRIBUTE_SCHEDULER,
                    transName, [ attr_1.name, attr_2.name, attr_2.attr_index.name ], [cat.name]);
            od;
        od;


    end
);
__SIMPLICIAL_InstallIncidenceMethods();


BindGlobal( "__SIMPLICIAL_BendPolygonalComplex_SufficientInformation",
    function(complex)
        VerticesOfLocalFlags(complex);
        EdgesOfLocalFlags(complex);
        FacesOfLocalFlags(complex);
        LocalVerticesOfLocalFlags(complex);
        LocalEdgesOfLocalFlags(complex);
        HalfEdgesOfLocalFlags(complex);
    end
);

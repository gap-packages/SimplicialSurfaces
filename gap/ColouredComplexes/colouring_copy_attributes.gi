

BindGlobal("__SIMPLICIAL_CopyAttributes_Colouring",
    function()
        local attrList, attr, wrapper, filtList, twistFilt, polyFilt,
            checkFilt, remFilt, filt, input, baseString,
            filtStart, firstFilt, i, stringFilt, filters;

        attrList := ATTRIBUTES; # List of all attributes
        filtList := FILTERS; # List of all filters

        twistFilt := Position(FILTERS, IsTwistedPolygonalComplex);
        polyFilt := Position(FILTERS, IsPolygonalComplex);
        checkFilt := [twistFilt, polyFilt];

        wrapper := function( attrName, stringObj, stringFilt, filt )
            local attr;
            
            attr := VALUE_GLOBAL(attrName);
            if stringFilt <> "" then
                stringFilt := Concatenation( " with ", stringFilt );
            fi;
            InstallMethod(attr, 
                Concatenation("for an ", stringObj, stringFilt, "."),
                [filt], 100, # This should be a priority method
                function(complex)
                    return attr(TwistedPolygonalComplex(complex));
                end);
        end;

        for attr in attrList do
            # Check each argument list
            for input in GET_OPER_FLAGS(attr[3]) do
                if Length(input) > 1 then
                    continue;
                fi;

                # Find all filters that have to be fulfilled for this attribute
                filters := TRUES_FLAGS(input[1]);

                if polyFilt in filters then
                    filtStart := IsEdgeColouredPolygonalComplex;
                    baseString := "EdgeColouredPolygonalComplex";
                elif twistFilt in filters then
                    filtStart := IsEdgeColouredTwistedPolygonalComplex;
                    baseString := "EdgeColouredTwistedPolygonalComplex";
                else
                    # Not an attribute to copy
                    continue;
                fi;


                remFilt := Difference( filters, checkFilt );
                if Length(remFilt) = 0 then
                    stringFilt := "";
                else
                    firstFilt := FILTERS[remFilt[1]];
                    filtStart := filtStart and firstFilt;
                    stringFilt := NAME_FUNC(firstFilt);
                fi;

                for i in [2..Length(remFilt)] do
                    filt := FILTERS[remFilt[i]];
                    filtStart := filtStart and filt;
                    stringFilt := Concatenation( stringFilt, ", ", NAME_FUNC(filt) );
                od;

                wrapper( attr[1], baseString, stringFilt, filtStart  );
            od;
        od;
    
    end
);
__SIMPLICIAL_CopyAttributes_Colouring();


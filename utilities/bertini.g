#  mpirun -np 16 bertini

# surf soll die wild simplicial surface sein,
# Laengen fuer Bertini in lengthcolours
PrintBertiniInput := function( surf , bertfile, lengthcolours)      

   local Gleichungsliste, var, polsx,polsy,polsz, pos, pos1, pos2, e, i, edge,
         obdavertices, v, v2, verts;

    var:=[]; polsx := []; polsy := []; polsz := [];
    Gleichungsliste:=[];

    for i in Vertices(surf) do
        Add(var,Concatenation("x",String(i)));
        Add(var,Concatenation("y",String(i)));
        Add(var,Concatenation("z",String(i)));
        Add(polsx,Indeterminate(Rationals,Concatenation("x",String(i))));
        Add(polsy,Indeterminate(Rationals,Concatenation("y",String(i))));
        Add(polsz,Indeterminate(Rationals,Concatenation("z",String(i))));
    od;
   
    # Take the vertices of the first face.
    # WLOG they will lie in a plane and the first in 0, 
    # the second on the positive x-axis, the last in the xy-plane
    obdavertices := VerticesOfFaces(surf)[Faces(surf)[1]];

    # origin
    v := obdavertices[1];
    pos := Position(Vertices(surf),v);

    Add(Gleichungsliste, polsx[pos] );
    Add(Gleichungsliste, polsy[pos] );
    Add(Gleichungsliste, polsz[pos] );
    # already evaluate that the first point is 0
    polsx[pos] := 0;
    polsy[pos] := 0;
    polsz[pos] := 0;

    # x-axis
    v2 := obdavertices[2];
    pos2 := Position(Vertices(surf),v2);

    Add(Gleichungsliste, polsy[pos2] );
    Add(Gleichungsliste, polsz[pos2] );

    # xy-plane
    v := obdavertices[3];
    pos := Position(Vertices(surf),v);

    Add(Gleichungsliste, polsz[pos] );

    # one edge between obdavertices[1] and v2=obdavertices[2]
    # not necessarily in face
    edge := Position(VerticesOfEdges(surf),
            Set([obdavertices[1],v2])); 


    Add(Gleichungsliste, polsx[pos2]-lengthcolours[ColoursOfEdges(surf)[edge]]);

    for e in Difference(Edges(surf),[edge]) do
        verts := VerticesOfEdges(surf)[e];
        pos1 := Position(Vertices(surf),verts[1]);
        pos2 := Position(Vertices(surf),verts[2]);
        Add(Gleichungsliste, 
                (polsx[pos1]-polsx[pos2])^2 +
                (polsy[pos1]-polsy[pos2])^2 +
                (polsz[pos1]-polsz[pos2])^2 - 
                lengthcolours[ColoursOfEdges(surf)[e]]^2);
    od;

    PrintTo(bertfile,"CONFIG\n");
    AppendTo(bertfile,"USEREGENERATION: 1;\n");

    AppendTo(bertfile,"FINALTOL: 1e-10;\n");
    AppendTo(bertfile,"END;\n\n");
    AppendTo(bertfile,"INPUT;\n");
    AppendTo(bertfile,"variable_group ");
    
    for v in var{[1..Length(var)-1]} do 
       AppendTo(bertfile, v, ", ");
    od;
    AppendTo(bertfile, var[Length(var)], ";\n");


    AppendTo(bertfile,"function ");
    
    for i in [1..Length(Gleichungsliste)-1] do 
       AppendTo(bertfile, "f",i, ", ");
    od;
    AppendTo(bertfile, "f",Length(Gleichungsliste), ";\n ");
 
    for i in [1..Length(Gleichungsliste)] do 
       AppendTo(bertfile, "f",i, " = ", Gleichungsliste[i], ";\n");
    od;


end;






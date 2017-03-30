#############################################################################
##
##    Print a surface for which a solution is known to a cmc file
##    for Brakhage's programme.
##
##

PrintFoldIn := function ( filename, surf, sol )

        local vf, ve, col, i, j;

        PrintTo(filename, NrOfVertices(surf) , " " );
        AppendTo(filename, NrOfFaces(surf) , " " );
        AppendTo(filename, NrOfEdges(surf) , "\n" );

        if Length(sol) <> 3 * NrOfVertices(surf) then
            Error("number of vertices does not match solution");
            return;
        fi;
        AppendTo(filename, "\n");

        # For each vertex print its numner, 
        # its three coordinates and then
        # a colour
        i := 1;
        for j in [ 1 .. NrOfVertices(surf) ] do
            AppendTo(filename, j ,  " " );
            AppendTo(filename, sol[i] ,  " " );
            AppendTo(filename, sol[i+1] ,  " " );
            AppendTo(filename, sol[i+2] ,  " " );
            AppendTo(filename,  " 0\n " );
            i := i + 3;
        od;
        AppendTo(filename, "\n");

        # For each face print its number, 
        # the numbers of its vertices and then
        # a colour
        vf := VerticesOfFaces(surf);
        for j in [ 1 .. NrOfFaces(surf) ] do
            AppendTo(filename, j ,  " 3 " );
            AppendTo(filename, vf[j][1] ,  " " );
            AppendTo(filename, vf[j][2] ,  " " );
            AppendTo(filename, vf[j][3] ,  "  " );
            AppendTo(filename,  " 2\n " );
        od;
        AppendTo(filename, "\n");


        ve := VerticesOfEdges(surf);
        col := ColoursOfEdges(surf);
        for j in [ 1 .. NrOfEdges(surf) ] do
            AppendTo(filename, j ,  " " );
            AppendTo(filename, ve[j][1] ,  " " );
            AppendTo(filename, ve[j][2] ,  " " );
            AppendTo(filename, col[j],  "\n" );
        od;


  end;

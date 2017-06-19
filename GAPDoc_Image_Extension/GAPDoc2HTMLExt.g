GAPDoc2HTMLProcs.Tikz := function( r, str )
    

    # First we have to generate and compile the file
    name := "IMG/_IMAGE_1"; #TODO We need a way to modify this number
    file := Filename( DirectoryCurrent(), name );
    output := OutputTextFile( file, false );
    
    SetPrintFormattingStatus(output, false);
    AppendTo( output, 
        "\\documentclass{article}\n\n",
        "\\usepackage{tikz}\n",
        "\\def\\pgfsysdriver{pgfsys-tex4ht.def}\n\n",
        "\\begin{document}\n" );
    AppendTo( output, r.content );
    AppendTo( output,
        "\\end{document}\n");

    CloseStream(output);

    # Now we have to compile this file (output will be visible);
    Exec( "htlatex", name );
    # Now we have generated an svg-file with name "name-1.svg"
    Append( str, "<img alt=\"", name, "\" src=\"", name, "-1.svg\">" );
);
end;

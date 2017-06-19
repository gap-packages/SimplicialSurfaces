GAPDoc2HTMLProcs.TikZ := function( r, str )
    local name, file, output;

    # First we have to generate and compile the file
    name := Concatenation("_IMAGE_", String(__GAPDOC_Images ));

    __GAPDOC_Images := __GAPDOC_Images + 1;

    file := Filename( DirectoryCurrent(), Concatenation(name,".tex") );
    output := OutputTextFile( file, false );

    SetPrintFormattingStatus( output, false );

    AppendTo( output, 
        "\\documentclass{article}\n\n",
        "\\usepackage{tikz}\n",
        "\\def\\pgfsysdriver{pgfsys-tex4ht.def}\n\n",
        "\\begin{document}\n" );
    AppendTo( output, r.content[1].content ); # the material is saved strangely (?)
    AppendTo( output,
        "\\end{document}\n");

    CloseStream(output);

    # Now we have to compile this file (output will be visible);
    Exec( "htlatex", name );
    # Now we have generated an svg-file with name "name-1.svg"
    Append( str, "<img alt=\"" );
    Append( str, name );
    Append( str, "\" src=\"" );
    Append( str, name );
    Append( str, "-1.svg\">\n" );
end;

# Variation for the alt-tag to also compile tikz, if necessary
GAPDoc2HTMLProcs.Alt := function(r, str)
  if GAPDoc2HTMLProcs.AltYes(r) then
    GAPDoc2HTMLContent(r, str);
  fi;
  if IsBound( r.attributes.Only ) and r.attributes.Only = "TikZ" then
    GAPDoc2HTMLProcs.TikZ(r,str);
  fi;
end;



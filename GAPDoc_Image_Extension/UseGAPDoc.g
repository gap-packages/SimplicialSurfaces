# This file explains how to use GAPDoc in a way that allows easy inclusion of images

d := ComposedXMLString( ".", "minimal_example.xml", [] );
tr := ParseTreeXMLString(d);

# Remove all previous image information
Exec( "rm _IMAGE_*" );
__SIMPLICIAL_ImageCount := 1;   #TODO right now we just number the images. It would be nice if identical images would be recognized (by md5sum maybe?);

# Now we have the XML-tree of the documentation
# We need to change the <Alt Only="TikZ">-Tags into proper GAPDoc tags
# For that we define a function that changes one node 
preProcessTikz := function( node )
    local cont, n1, n2, n3, file, output, name, htmlString, consoleString;

    if node.name = "Alt" and IsBound(node.attributes.Only) and 
        node.attributes.Only in ["TikZ","Tikz"] then

        # get the content of the tag
        cont := GetTextXMLTree(node);
        # choose a name for the image and generate it
        name := Concatenation("_IMAGE_", String(__SIMPLICIAL_ImageCount ));
        __SIMPLICIAL_ImageCount := __SIMPLICIAL_ImageCount + 1;
        file := Filename( DirectoryCurrent(), Concatenation(name,".tex") );
        output := OutputTextFile( file, false );

        SetPrintFormattingStatus( output, false );
        AppendTo( output, 
            "\\documentclass{article}\n\n",
            "\\usepackage{tikz}\n",
            "\\def\\pgfsysdriver{pgfsys-tex4ht.def}\n\n",
            "\\begin{document}\n" );
        AppendTo( output, cont );
        AppendTo( output, "\\end{document}\n");

        CloseStream(output);

        # Now we have to compile this file (output will be visible);
        Exec( "htlatex", name );
        # Now we have generated an svg-file with name "name-1.svg"

        
        # We want to include this in the LaTeX version (we only have to rewrite the alt-name);
        n1 := ShallowCopy(node);
        n1.attributes.Only := "LaTeX";

        # To include it in the HTML-version we have to use a different node
        htmlString := Concatenation(
            "<Alt Only=\"HTML\"><![CDATA[",
            "<img src=\"", name, "-1.svg\"",
            "alt=\"", name, "\"/>]]></Alt>");
        n2 := ParseTreeXMLString(htmlString);


        # Generate the text version
        consoleString := "[an image that is not shown in text version]";
        n3 := ParseTreeXMLString(consoleString);

        # Replace this node by the new nodes
        node.content := [n1,n2,n3];
        node.attributes.Only := "HTML,LaTeX,Text";
    fi;
end;

# Fortunately there already is a method to apply this function to all nodes of the tree
ApplyToNodesParseTree( tr, preProcessTikz );

# Now we let GAPDoc compile this tree

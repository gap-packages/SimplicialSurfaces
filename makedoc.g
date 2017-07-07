if fail = LoadPackage("AutoDoc", "2016.02.16") then
    Error("AutoDoc version 2016.02.16 or newer is required.");
fi;


# Because we want to allow images (especially their automated generation
# and inclusion in HTML), we need to define a preprocessing for GAPDoc
BindGlobal("__SIMPLICIAL_ImageCount",1);
MakeReadWriteGlobal("__SIMPLICIAL_ImageCount");

# We specify the documentation directory directly since we want to use it
# in our preprocessing method.
BindGlobal("__SIMPLICIAL_DocDirectory", "doc/");
# The subdirectory of the images
BindGlobal("__SIMPLICIAL_ImageSubdirectory", "_IMAGES/");

# We create both of them. Technically the doc directory would be generated
# automatically but I don't want to find out when (I can only create the 
# subdirectory after the initial directory was created)
currentDir := Filename( DirectoryCurrent(), "");
CreateDirIfMissing( Concatenation(currentDir, __SIMPLICIAL_DocDirectory) );
CreateDirIfMissing( Concatenation(currentDir, __SIMPLICIAL_DocDirectory, __SIMPLICIAL_ImageSubdirectory) );

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
        n2.name := "Alt";
        n2.attributes.Only := "HTML";


        # Generate the text version
        consoleString := "[an image that is not shown in text version]";
        n3 := ParseTreeXMLString(consoleString);
        n3.name := "Alt";
        n3.attributes.Only := "Text";

        # Replace this node by the new nodes
        node.content := [n1,n2,n3];
        node.attributes.Only := "HTML,LaTeX,Text";
    fi;
end;

# We now want to put this preprocessing within the MakeGAPDocDoc-function.
# To do so we have to redefine the original global variable and add our
# method into the code. All code that is not commented with MB is original
# GAPDoc-code.

MakeReadWriteGlobal("MakeGAPDocDoc");
UnbindGlobal("MakeGAPDocDoc"); # MB unbind this to modify it
BindGlobal("MakeGAPDocDoc", function(arg)
  local htmlspecial, path, main, files, bookname, gaproot, str, 
        r, t, l, latex, null, log, pos, h, i, j;
  htmlspecial := Filtered(arg, a-> a in ["MathML", "Tth", "MathJax"]);
  if Length(htmlspecial) > 0 then
    arg := Filtered(arg, a-> not a in ["MathML", "Tth", "MathJax"]);
  fi;
  path := arg[1];
  main := arg[2];
  files := arg[3];
  bookname := arg[4];
  if IsBound(arg[5]) then
    gaproot := arg[5];
  else
    gaproot := false;
  fi;
  # ensure that path is directory object
  if IsString(path) then
    path := Directory(path);
  fi; 
  # ensure that .xml is stripped from name of main file
  if Length(main)>3 and main{[Length(main)-3..Length(main)]} = ".xml" then
    main := main{[1..Length(main)-4]};
  fi;
  # compose the XML document
  Info(InfoGAPDoc, 1, "#I Composing XML document . . .\n");
  str := ComposedDocument("GAPDoc", path, 
                             Concatenation(main, ".xml"), files, true);
  # parse the XML document
  Info(InfoGAPDoc, 1, "#I Parsing XML document . . .\n");
  r := ParseTreeXMLString(str[1], str[2]);

  
  
  #MB precompile the images
        # Remove all previous image information
#        remPath := Concatenation("rm ", path, "_IMAGE_*");
#        Exec( remPath);
#        __SIMPLICIAL_ImageCount := 1;   #TODO right now we just number the images. It would be nice if identical images would be recognized (by md5sum maybe?);

        # Fortunately there already is a method to apply this function to all nodes of the tree
#        ApplyToNodesParseTree( r, preProcessTikz );


  # clean the result
  Info(InfoGAPDoc, 1, "#I Checking XML structure . . .\n");
  CheckAndCleanGapDocTree(r);


  # produce text version
  Info(InfoGAPDoc, 1, 
                   "#I Text version (also produces labels for hyperlinks):\n");
  t := GAPDoc2Text(r, path);
  GAPDoc2TextPrintTextFiles(t, path);
  # produce LaTeX version
  Info(InfoGAPDoc, 1, "#I Constructing LaTeX version and calling pdflatex:\n"); 
  r.bibpath := path;
  l := GAPDoc2LaTeX(r);
  Info(InfoGAPDoc, 1, "#I Writing LaTeX file, \c");
  Info(InfoGAPDoc, 2, Concatenation(main, ".tex"), "\n#I     ");
  FileString(Filename(path, Concatenation(main, ".tex")), l);
  if Filename(DirectoriesSystemPrograms(), "pdflatex") = fail then
    Info(InfoGAPDoc, 1, "\n#W WARNING: cannot find 'pdflatex', please install TeX.\n");
    Info(InfoGAPDoc, 1, "#W WARNING: will NOT produce pdf version from LaTeX file.\n");
  else
    # call latex and pdflatex (with bibtex, makeindex and dvips)
    latex := "latex -interaction=nonstopmode ";
    # sh-syntax for redirecting stderr and stdout to /dev/null
    null := " > /dev/null 2>&1 ";
    Info(InfoGAPDoc, 1, "3 x pdflatex with bibtex and makeindex, \c");
    Exec(Concatenation("sh -c \" cd ", Filename(path,""),
    "; rm -f ", main, ".aux ", main, ".pdf ", main, ".log ",
    "; pdf", latex, main, null,
    "; bibtex ", main, null,
    "; pdf", latex, main, null,
    "; makeindex ", main, null,
    "; pdf", latex, main, null,"\""));
    # check log file for errors, warning, overfull boxes
    log := Filename(path, Concatenation(main, ".log"));
    log := StringFile(log);
    if log = fail then
      Info(InfoGAPDoc, 1, "\n#W WARNING: Something wrong, don't find log file ",
                            Filename(path, Concatenation(main, ".log")), "\n");
    else
      log := SplitString(log, "\n", "");
      pos := Filtered([1..Length(log)], i-> Length(log[i]) > 0 
                                                   and log[i][1] = '!');
      if Length(pos) > 0 then
        Info(InfoGAPDoc, 1, "\n#W There were LaTeX errors:\n");
        for i in pos do
          for j in [i..Minimum(i+2, Length(log))] do
            Info(InfoGAPDoc, 1, log[j], "\n");
          od;
          Info(InfoGAPDoc, 1, "____________________\n");
        od;
      fi;
      pos := Filtered([1..Length(log)], i-> Length(log[i]) > 13 
                                       and log[i]{[1..14]} = "LaTeX Warning:");
      if Length(pos) > 0 then
        Info(InfoGAPDoc, 1, "\n#W There were LaTeX Warnings:\n");
        for i in pos do
          for j in [i..Minimum(i+2, Length(log))] do
            Info(InfoGAPDoc, 1, log[j], "\n");
          od;
          Info(InfoGAPDoc, 1, "____________________\n");
        od;
      fi;
      pos := Filtered([1..Length(log)], i-> Length(log[i]) > 7 
                                       and log[i]{[1..8]} = "Overfull");
      if Length(pos) > 0 then
        Info(InfoGAPDoc, 1, "\n#W There are overfull boxes:\n");
        for i in pos do
          Info(InfoGAPDoc, 1, log[i], "\n");
        od;
      fi;
    fi;
    # check for BibTeX warnings
    log := StringFile(Filename(path, Concatenation(main, ".blg")));
    if log <> fail then
      log := SplitString(log, "\n", "");
      log := Filtered(log, z-> PositionSublist(z, "Warning--") = 1);
      if Length(log) > 0 then
        Info(InfoGAPDoc, 1, "\n#W BibTeX had warnings:\n",
             JoinStringsWithSeparator(log, "\n"));
      fi;
    fi;
    
    if not IsExistingFile(Filename(path, Concatenation(main, ".pdf"))) then
      Info(InfoGAPDoc, 1, "\n#I ERROR: no .pdf file produced (and no .six file)");
    else
      Exec(Concatenation("sh -c \" cd ", Filename(path,""),
      "; mv ", main, ".pdf manual.pdf; ", 
      "\""));
      Info(InfoGAPDoc, 1, "\n");
      # read page number information for .six file
      Info(InfoGAPDoc, 1, "#I Writing manual.six file ... \c");
      Info(InfoGAPDoc, 2, Filename(path, "manual.six"), "\n");
      Info(InfoGAPDoc, 1, "\n");
      AddPageNumbersToSix(r, Filename(path, Concatenation(main, ".pnr")));
      # print manual.six file
      PrintSixFile(Filename(path, "manual.six"), r, bookname);
    fi;
  fi;
  # produce html version

  Info(InfoGAPDoc, 1, "#I Finally the HTML version . . .\n");
  # if MathJax version is also produced we include links to them
  if "MathJax"  in htmlspecial then
    r.LinkToMathJax := true;
  fi;
  h := GAPDoc2HTML(r, path, gaproot);
  GAPDoc2HTMLPrintHTMLFiles(h, path);
  Unbind(r.LinkToMathJax);
  if "Tth" in htmlspecial then
    Info(InfoGAPDoc, 1, 
            "#I - also HTML version with 'tth' translated formulae . . .\n");
    h := GAPDoc2HTML(r, path, gaproot, "Tth");
    GAPDoc2HTMLPrintHTMLFiles(h, path);
  fi;
  if "MathML" in htmlspecial then
    Info(InfoGAPDoc, 1, "#I - also HTML + MathML version with 'ttm' . . .\n");
    h := GAPDoc2HTML(r, path, gaproot, "MathML");
    GAPDoc2HTMLPrintHTMLFiles(h, path);
  fi;
  if "MathJax" in htmlspecial then
    Info(InfoGAPDoc, 1, "#I - also HTML version for MathJax . . .\n");
    h := GAPDoc2HTML(r, path, gaproot, "MathJax");
    GAPDoc2HTMLPrintHTMLFiles(h, path);
  fi;

  return r;
end);


# After all this preparatory work we can finally call the function to create
# the documentation

AutoDoc( rec( scaffold := rec(
                    MainPage := false,
                    gapdoc_latex_options := rec(
                        LateExtraPreamble := "\\usepackage{tikz}\n")
                    ), 
              dir := __SIMPLICIAL_DocDirectory,
	      autodoc := rec( 
                    files := [ "doc/TableOfContents.autodoc" ],
                    scan_dirs := ["doc", "gap"]) )
);

QUIT;

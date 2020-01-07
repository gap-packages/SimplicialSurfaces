if fail = LoadPackage("AutoDoc", "2019.05.20") then
    Error("AutoDoc version 2019.05.20 or newer is required.");
    QUIT_GAP(1);
fi;

if fail = LoadPackage("GAPDoc", "1.6") then
    Error("GAPDoc version 1.6 or newer is required.");
    QUIT_GAP(1);
fi;


# We generate the names automatically by a hash-function. Therefore we
# have to clean up old files periodically. To know which files have
# become obsolete, we save the current files in this global list.
BindGlobal("__SIMPLICIAL_ImageNames",[]);
MakeReadWriteGlobal("__SIMPLICIAL_ImageNames");

# We specify the documentation directory directly since we want to use it
# in our preprocessing method.
BindGlobal("__SIMPLICIAL_DocDirectory", "doc/");


# The additional LaTeX-header to make tikz-pictures
# Careful: The file TikZHeader.tex has to lie in the same directory as
# the primary documentation file and the generated image files.
BindGlobal("__SIMPLICIAL_TikZHeader", "\\input{TikZHeader.tex}\n\n" );

# We load the package since we need it for some computations in the manual
if fail = LoadPackage("SimplicialSurfaces") then
    Error("SimplicialSurfaces package has to be available.");
fi;

Exec( "pwd > _TMP_foo");   
manualposition := StringFile("_TMP_foo");
Exec("rm _TMP_foo");
RemoveCharacters(manualposition, "\n");  
manualposition := Concatenation(manualposition,"/doc/manual.pdf");
manualposition := Concatenation("You can find the image in the manual. Most probably it is here: ", manualposition);

# Now we have the XML-tree of the documentation
# We need to change the <Alt Only="TikZ">-Tags into proper GAPDoc tags
# For that we define a function that changes one node 
preProcessTikz := function( node )
    local cont, n1, n2, n3, file, output, name, htmlString, consoleString, 
        path, tmpName, tmpFile, sysDirPath, md5, out, inStream, outStream,
        hash, tmpImageName, latexString;

    if node.name = "Alt" and IsBound(node.attributes.Only) and 
        node.attributes.Only in ["TikZ","Tikz"] then

        # get the content of the tag
        cont := GetTextXMLTree(node);


        # We want to save our image in the file
        # _IMAGE_<Hash>.tex
        # (that gives _IMAGE_<Hash>-1.svg)
        #
        # This gives us the benefit of recognizing duplicates and
        # minimizing compiling time (especially if we don't change the pictures
        # between different versions of the code).
        #
        # At the same time this is problematic if we have \input-clauses inside
        # our document since a change in the referred document should be
        # reflected in a different overall image.
        #
        # To circumvent this issue, we proceed as follows:
        # 1) Write the picture into a temporary file _IMAGE_TMP.tex
        #       We use a sed-command to remove all leading whitespaces
        #       (othewise the same picture might be compiled twice).
        # 2) Call ../flatex/flatex _IMAGE_TMP.tex
        #       This creates the file _IMAGE_TMP.flt
        # 3) Calculate the hash of this file
        # 4) Check if _IMAGE_<Hash>-1.svg (and the tex-file) already exist
        #       If they do, do nothing.
        # 5) Otherwise call mv _IMAGE_TMP.tex _IMAGE_<Hash>.tex
        # 6) Compile this image via htlatex _IMAGE_<Hash>.tex
        # 7) Store the name _IMAGE_<Hash> in our list
        # 8) Include _IMAGE_<Hash>-1.svg in the HTML document

        # Step 1
        path := __SIMPLICIAL_DocDirectory;
        tmpImageName := "_IMAGE_TMP";
        tmpName := Concatenation( path, tmpImageName,  ".tex");
        tmpFile := Filename( DirectoryCurrent(), tmpName );
        output := OutputTextFile( tmpFile, false );
        SetPrintFormattingStatus( output, false );
        AppendTo( output,
            "\\nonstopmode\n",
            "\\documentclass{standalone}\n\n",
            __SIMPLICIAL_TikZHeader,
            "\\def\\pgfsysdriver{pgfsys-tex4ht.def}\n\n",
            "\\begin{document}\n");
        AppendTo( output, cont );
        AppendTo( output, "\\end{document}" );
        CloseStream(output);

        # Now we remove the leading whitespace
        Exec( "sh -c \" cd ", path, 
            "; sed 's/^[ \\t]*//g' -i ", 
            Concatenation(tmpImageName, ".tex"), "; \"" );

        # Step 2
        # TODO separate the calls to these shell-files into a function and call
        # that. Furthermore, add into the README a short test if a user has all
        # necessary capabilities (and maybe an installation for them)
        Exec( "sh -c \" cd ", path, "; ../flatex/flatex ", 
            Concatenation(tmpImageName, ".tex"), "> /dev/null; \"" );

        # Step 3
        sysDirPath := DirectoriesSystemPrograms();
        md5 := Filename( sysDirPath, "md5sum" );
        if md5 = fail then
            Error("There is no md5sum installed.");
        fi;

        inStream := InputTextNone();
        out := "";
        outStream := OutputTextString(out, true);
        Process( Directory(path), md5, inStream, outStream, [ Concatenation(tmpImageName, ".flt") ] );
        CloseStream(inStream);
        CloseStream(outStream);
        hash := SplitString( out, " " )[1];

        # Step 4
        name := Concatenation( "_IMAGE_", hash );
        if not IsExistingFile( 
            Filename( DirectoryCurrent(), 
                Concatenation( path, name, ".tex" ) ) ) or
           not IsExistingFile(
            Filename( DirectoryCurrent(),
                Concatenation( path, name, "-1.svg" )) ) or
           not IsExistingFile(
            Filename( DirectoryCurrent(),
                Concatenation( path, name, ".pdf" )) ) then
            # Either tex or svg or pdf are not there. We will write them now.

            # Step 5
            Exec( "sh -c \" cd ", path, "; mv _IMAGE_TMP.tex ", Concatenation(name, ".tex"), "; \" " );

            # Step 6
            Exec( "sh -c \" cd ", path, "; pdflatex -halt-on-error ", Concatenation(name, ".tex"), "; \" " );
            Exec( "sh -c \" cd ", path, "; htlatex ", Concatenation(name, ".tex"), "; \" " );

            # After compiling we do some post-processing on the image.
            # We will modify
            # - subscripts, since baseline-shift is not supported in Firefox
            #   (see https://stackoverflow.com/questions/12332448/subscripts-and-superscripts-in-svg)
            #   As this bug was recognized 12 years ago it is unlikely to 
            #   change in the near future. We therefore apply the suggested
            #   fix in the stackoverflow-answer.
            #   WARNING: I am just messing around on the assumption that all
            #       subscripts have the same height. If that turns out to be
            #       wrong, you have to think of a more sophisticated mechanism.
            Exec( "sh -c \" cd ", path, 
                "; sed 's/baseline-shift=\\\"sub\\\"/dy=\\\"3\\\"/g' -i ",
                Concatenation(name, "-1.svg"), ";\" ");
                # I do not really understand why there has to be so much
                # escaping but it does not work with less.
        fi;
            
        # Step 7
        Add( __SIMPLICIAL_ImageNames, name);

        # Step 8 will be done in the htmlString below
       

        # Inclusion in the LaTeX-version is centered
        latexString := Concatenation( "\n\\begin{center}\n",
            "\\includegraphics{", name, ".pdf}\n\\end{center}\n" );
        n1 := ParseTreeXMLString(latexString);
        n1.name := "Alt";
        n1.attributes.Only := "LaTeX";

        # To include it in the HTML-version we have to use a different node
        htmlString := Concatenation(
            "<Alt Only=\"HTML\"><![CDATA[",
            "<p style=\"text-align:center;\"><img src=\"", name, "-1.svg\"",
            "alt=\"", name, "\"/></p>]]></Alt>");
        n2 := ParseTreeXMLString(htmlString);
        n2.name := "Alt";
        n2.attributes.Only := "HTML";


        # Generate the text version
        consoleString := "\n[an image that is not shown in text version. ";
	consoleString := Concatenation( consoleString, manualposition);
	consoleString := Concatenation( consoleString, "]\n");
        n3 := ParseTreeXMLString(consoleString);
        n3.name := "Alt";
        n3.attributes.Only := "Text";


        # Replace this node by the new nodes
        node.content := [n1,n2,n3];
        node.attributes.Only := "HTML,LaTeX,Text";
    fi;
end;



# Now we have the XML-tree of the documentation
# We need to change the <Alt Only="JavaScript">-Tags into proper GAPDoc tags
# For that we define a function that changes one node 
preProcessJavaScript := function( node )
   	 local cont, name, path, n1, n2, n3, consoleString, htmlString, latexString, tmpImageName, tmpName;

   	if node.name = "Alt" and IsBound(node.attributes.Only) and 
        node.attributes.Only in ["JavaScript","Javascript"] then

       		# get the content of the tag
        	cont := GetTextXMLTree(node);
		cont := ReplacedString( cont, "\n", "" ); 
		cont := ReplacedString( cont, ".html", "" ); 
		path := __SIMPLICIAL_DocDirectory;
       		tmpImageName := "_IMAGE_TMP";
        	tmpName := Concatenation( path, tmpImageName,  ".tex");
		PrintTo("doc/Test.js", "var page = require('webpage').create();\n");
		AppendTo( "doc/Test.js", "page.viewportSize = { width: 1920, height: 1080 };\n");
		AppendTo( "doc/Test.js", "page.clipRect = { top: 400, left: 750, width: 375, height: 300 };\n");
		AppendTo( "doc/Test.js", Concatenation("page.open('doc/", cont, ".html', function() {\n") );
		AppendTo( "doc/Test.js", Concatenation("page.render('doc/", cont, ".png');\n") );
		AppendTo( "doc/Test.js", "phantom.exit();\n" );
		AppendTo( "doc/Test.js", "});" );
		Exec("./doc/phantomjs /doc/Test.js");
		name := cont;



       		Add( __SIMPLICIAL_ImageNames, name);


       

        	# Inclusion in the LaTeX-version is centered
        	latexString := Concatenation( "\n\\begin{center}\n", "\\includegraphics{", name, ".png}\n\\end{center}\n" );
        	n1 := ParseTreeXMLString(latexString);
        	n1.name := "Alt";
        	n1.attributes.Only := "LaTeX";

        	# To include it in the HTML-version we have to use a different node
        	htmlString := Concatenation(
            	"<Alt Only=\"HTML\"><![CDATA[",
            	"<p style=\"text-align:center;\"><img src=\"", name, "-1.png\"",
            	"alt=\"", name, "\"/></p>]]></Alt>");
        	n2 := ParseTreeXMLString(htmlString);
        	n2.name := "Alt";
        	n2.attributes.Only := "HTML";


        	# Generate the text version
        	consoleString := "\n[an image that is not shown in text version]\n";
        	n3 := ParseTreeXMLString(consoleString);
        	n3.name := "Alt";
        	n3.attributes.Only := "Text";


        	# Replace this node by the new nodes
        	node.content := [n1,n2,n3];
        	node.attributes.Only := "HTML,LaTeX,Text";

	fi;
end;



BindGlobal( "CleanImageDirectory", function(  )
    local allFiles, file;

    # First we remove the temporary files
    Exec( "sh -c \" cd ", __SIMPLICIAL_DocDirectory, "; rm --force _IMAGE_TMP*;\"" );

    # Secondly we remove all old image files
    allFiles := DirectoryContents( __SIMPLICIAL_DocDirectory );
    for file in allFiles do
        # We only do something with temporary image files
        if StartsWith( file, "_IMAGE_" ) then
            if ForAny( __SIMPLICIAL_ImageNames, n -> StartsWith(file,n) ) then
                # This is a file to an existing picture
                if not ForAny( [".tex", ".svg", ".pdf"], e -> EndsWith(file,e) ) then
                    # Does not end in one of those file extensions
                    Exec( "sh -c \" cd ", __SIMPLICIAL_DocDirectory, "; rm --force ", file, ";\"" );
                fi;
            else
                # This is an old file that can be removed
                Exec( "sh -c \" cd ", __SIMPLICIAL_DocDirectory, "; rm --force ", file, ";\"" );
            fi;
        fi;
    od;
end 
);

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
        Exec( "sh -c \" cd ", __SIMPLICIAL_DocDirectory, "; rm --force _TIKZ_*;\"" );
        __SIMPLICIAL_MANUAL_MODE := true;
        Read("gap/PolygonalComplexes/drawing.gd");
        Read("gap/Library/library_images.gd");
        Read("gap/PolygonalComplexes/distances_images.gd");
        Read("gap/ColouredComplexes/edgeColouring_images.gd");
        Read("gap/ColouredComplexes/variColouring_images.gd");
        Read("gap/Flags/flags_images.gd");
        __SIMPLICIAL_MANUAL_MODE := false;
        # Fortunately there already is a method to apply this function to all nodes of the tree
        ApplyToNodesParseTree( r, preProcessTikz );
	ApplyToNodesParseTree( r, preProcessJavaScript );

        CleanImageDirectory();


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

# Create binary and index files for the library
__SIMPLICIAL_LibraryConstructBinary();
__SIMPLICIAL_LibraryConstructIndex();

# After all this preparatory work we can finally call the function to create
# the documentation

AutoDoc( rec( scaffold := rec(
                    MainPage := false), 
              dir := __SIMPLICIAL_DocDirectory,
              extract_examples := true,
	      autodoc := rec( 
                    files := [ ],
                    scan_dirs := ["doc", "gap", "gap/PolygonalComplexes", "gap/Paths", "gap/Library", "gap/ColouredComplexes", "gap/Flags", "gap/Morphisms"]),
              gapdoc := rec(
                    files := ["doc/PolygonalStructuresDefinitions.xml", "doc/ExampleImplementations.xml"],
                    LaTeXOptions := rec( LateExtraPreamble := __SIMPLICIAL_TikZHeader )
              ))
);

QUIT;

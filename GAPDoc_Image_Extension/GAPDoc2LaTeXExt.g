# Put tikz-code into a LaTeX-file
#GAPDoc2LaTeXProcs.TikZ := function( r, str )
#    Append(str, r.content);
#    Append(str,"\n");
#end;

# We need to slightly rewrite this function to make it usable
GAPDoc2LaTeXProcs.Table := function(r, str)
  local cap;
  if (IsBound(r.attributes.Only) and r.attributes.Only <> "LaTeX" and r.attributes.Only <> "TikZ") or
     (IsBound(r.attributes.Not) and r.attributes.Not = "LaTeX") then
    return;
  fi;
  # head part of table and tabular
  if IsBound(r.attributes.Label) then
    Append(str, "\\mbox{}\\label{");
    Append(str, r.attributes.Label);
    Add(str, '}');
  fi;
  Append(str, "\\begin{center}\n\\begin{tabular}{");
  Append(str, r.attributes.Align);
  Add(str, '}');
  # the rows of the table
  GAPDoc2LaTeXContent(r, str);
  # the trailing part with caption, if given
  Append(str, "\\end{tabular}\\\\[2mm]\n");
  cap := Filtered(r.content, a-> a.name = "Caption");
  if Length(cap) > 0 then
    GAPDoc2LaTeXProcs.Caption1(cap[1], str);
  fi;
  Append(str, "\\end{center}\n\n");
end;

GAPDoc2LaTeXProcs.Alt := function(r, str)
  local take, types;
  take := false;
  if IsBound(r.attributes.Only) then
    NormalizeWhitespace(r.attributes.Only);
    types := SplitString(r.attributes.Only, "", " ,");
    if "LaTeX" in types or "BibTeX" in types or "TikZ" in types then
      take := true;
      GAPDoc2LaTeXProcs.recode := false;
    fi;
  fi;
  if IsBound(r.attributes.Not) then
    NormalizeWhitespace(r.attributes.Not);
    types := SplitString(r.attributes.Not, "", " ,");
    if not "LaTeX" in types then
      take := true;
    fi;
  fi;
  if take then
    GAPDoc2LaTeXContent(r, str);
  fi;
  GAPDoc2LaTeXProcs.recode := true;
end;

GAPDoc2LaTeXProcs.Head := StringFile( "customlatexhead.tex" );
 

# Put tikz-code into a LaTeX-file
GAPDoc2LaTeXProcs.TikZ := function( r, str )
    Append(str, r.content);
    Append(str,"\n");
end;

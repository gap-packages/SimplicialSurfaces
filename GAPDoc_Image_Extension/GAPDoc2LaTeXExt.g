# Put tikz-code into a LaTeX-file
GAPDoc2LateXProcs.TikZ := function( r, str )
    Append(str, r.content);
    Append(str,"\n");
end;

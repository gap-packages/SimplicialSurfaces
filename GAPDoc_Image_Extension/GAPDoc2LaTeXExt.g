# Put tikz-code into a LaTeX-file
GAPDoc2LateXProcs.Tikz := function( r, str )
    Append(str, r.content);
    Append(str,"\n");
end;

# a:=StringFile("gap/Flags/flags.gd");
a:=SplitString(StringFile("gap/Flags/flags.gd"), '\n');
b:=Positions(a, "#! <Alt Only=\"TikZ\">\r");
# file := Filename( DirectoryCurrent(), fileName ); #TODO allow absolute paths
# output := OutputTextFile( file, false ); # override other files
# if output = fail then
#     Error(Concatenation("File ", String(file), " can't be opened.") );
# fi;
# SetPrintFormattingStatus( output, false );
beginning := 0;

for beginning in b do
    finish := beginning;
    while not a[finish]="#! </Alt>\r" do
        # AppendTo(output, a[end]);
        Print(a[finish],"\n");
        finish := finish+1;
    od;
    # Print(start);
od;
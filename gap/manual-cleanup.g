files:=[
    "./gap/categories_families.gd",
    "./gap/ColouredComplexes/edgeColouring.gd",
    "./gap/ColouredComplexes/edgeColouring_images.gd",
    "./gap/ColouredComplexes/isoscelesColouring.gd",
    "./gap/ColouredComplexes/isoscelesColouring_images.gd",
    "./gap/ColouredComplexes/variColouring.gd",
    "./gap/ColouredComplexes/variColouring_images.gd",
    "./gap/deprecated/bend_surface.gd",
    "./gap/deprecated/coloured_simplicial_surface.gd",
    "./gap/deprecated/decorated_surface.gd",
    "./gap/deprecated/folding_complex.gd",
    "./gap/deprecated/folding_plan.gd",
    "./gap/deprecated/simplicial_surface.gd",
    "./gap/deprecated/simplicial_surface_fan.gd",
    "./gap/deprecated/simplicial_surface_identification.gd",
    "./gap/deprecated/wild_simplicial_surface.gd",
    "./gap/Flags/flags.gd",
    "./gap/Flags/flags_images.gd",
    "./gap/Library/library.gd",
    "./gap/Library/library_images.gd",
    "./gap/Morphisms/morphisms.gd",
    "./gap/Paths/dual_path.gd",
    "./gap/Paths/paths.gd",
    "./gap/PolygonalComplexes/animating.gd",
    "./gap/PolygonalComplexes/animating_images.gd",
    "./gap/PolygonalComplexes/constructors.gd",
    "./gap/PolygonalComplexes/distances.gd",
    "./gap/PolygonalComplexes/distances_images.gd",
    "./gap/PolygonalComplexes/drawing.gd",
    "./gap/PolygonalComplexes/embedding.gd",
    "./gap/PolygonalComplexes/graphs.gd",
    "./gap/PolygonalComplexes/incidence_geometry.gd",
    "./gap/PolygonalComplexes/main.gd",
    "./gap/PolygonalComplexes/modification.gd",
    "./gap/PolygonalComplexes/navigation.gd",
    "./gap/PolygonalComplexes/properties.gd",
    "./gap/PolygonalComplexes/twisted_polygonal_complex.gd",
];

for filename in files do
    file:=SplitString(StringFile(filename), '\n');
    positions:=Positions(file, "#! <Alt Only=\"TikZ\">\r");
    number := 1;    

    for i in [1..Size(positions)] do
        # get the name of the file without path or ending
        outputfilename := "doc/tikz-files/_Wrapper_";
        Append(outputfilename, SplitString(SplitString(filename, "/")[Size(SplitString(filename, "/"))] ,".")[1]);

        # generate the right directory and ending
        Append(outputfilename,"-");
        Append(outputfilename, String(i));
        Append(outputfilename, ".tex");
        Print(outputfilename,"\n");

        output := OutputTextFile( outputfilename, false ); # override other files
        if output = fail then
            Error(Concatenation("File ", String(file), " can't be opened.") );
        fi;
        SetPrintFormattingStatus( output, false );

        # put wrapper around file
        AppendTo(output, """
\nonstopmode
\documentclass{standalone}

\input{TikZHeader.tex}

\def\pgfsysdriver{pgfsys-tex4ht.def}

\begin{document}
""");

        beginning := positions[i];
        finish := beginning;
        Print("write file: ",outputfilename,"\ncontent:\n");
        while not file[finish]="#! </Alt>\r" do
            AppendTo(output, file[finish]{[3..Size(file[finish])]});
            Print(file[finish]{[3..Size(file[finish])]},"\n");
            finish := finish+1;
        od;
        AppendTo(output, file[finish]{[3..Size(file[finish])]});
        Print(file[finish]{[3..Size(file[finish])]},"\n");

        AppendTo(output, "\end{document}");

    od;
od;


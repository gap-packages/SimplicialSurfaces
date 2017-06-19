# First include the additional methods
Read("NewMake.g");
Read("GAPDoc2LaTeXExt.g");
Read("GAPDoc2HTMLExt.g");

MakeGAPDocDoc( ".", "minimal_example.xml", [], "ImageInclusion");

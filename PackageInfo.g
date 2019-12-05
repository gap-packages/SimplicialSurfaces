#
# SimplicialSurfaces: Computation with simplicial surfaces and folding processes.
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "SimplicialSurfaces",
Subtitle := "Computing with simplicial surfaces and folding processes.",
Version := "0.6",
Date := "05/12/2019", # dd/mm/yyyy format
ArchiveURL := "TODO",
ArchiveFormats := "TODO",

Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Alice",
    LastName := "Niemeyer",
    WWWHome := "http://www.math.rwth-aachen.de/~Alice.Niemeyer/",
    Email := "Alice.Niemeyer@Mathb.RWTH-Aachen.De",
    PostalAddress := "Alice Niemeyer\nLehrstuhl B für Mathematik\nRWTH Aachen\nPontdriesch 10/16\n52062 Aachen\nGERMANY\n",
    Place := "Aachen",
    Institution := "Lehrstuhl B für Mathematik, RWTH Aachen",
  ),
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Markus",
    LastName := "Baumeister",
    WWWHome := "https://markusbaumeister.github.io/",
    Email := "baumeister@mathb.rwth-aachen.de",
    PostalAddress := "Markus Baumeister\nLehrstuhl B für Mathematik\nRWTH Aachen\nPontdriesch 10/16\n52062 Aachen\nGERMANY\n",
    Place := "Aachen",
    Institution := "Lehrstuhl B für Mathematik, RWTH Aachen",
  ),
],

#SourceRepository := rec( Type := "TODO", URL := "URL" ),
#IssueTrackerURL := "TODO",
#SupportEmail := "TODO",

PackageWWWHome := "https://github.com/markusbaumeister/simplicial-surfaces",

PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL     := Concatenation( ~.PackageWWWHome, "README.md" ),
ArchiveURL     := Concatenation( ~.PackageWWWHome,
                                 "/", ~.PackageName, "-", ~.Version ),

ArchiveFormats := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "dev",

AbstractHTML   :=  "The <span class='pkgname'>SimplicialSurfaces</span> package provides functionality for working with simplicial surfaces",

PackageDoc := rec(
  BookName  := "SimplicialSurfaces",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Computation with simplicial surfaces and folding processes.",
),

Dependencies := rec(
  GAP := ">= 4.10",
  NeededOtherPackages := [ [ "Grape", ">=4.8.2" ], [ "AttributeScheduler", ">=2018.08.03" ]],
  SuggestedOtherPackages := [ [ "GAPDoc", ">= 1.6" ], ["AutoDoc", ">=2019.05.20"], [ "IO", ">=2.2" ], [ "NautyTracesInterface", ">0.1" ] ],
  ExternalConditions := [ ],
),

AvailabilityTest := function()
        return true;
    end,

#TODO TestFile := "tst/testall.g",

Keywords := [ "Simplicial" ],

AutoDoc := rec(
    TitlePage := rec(
        Copyright := Concatenation(
                    "&copyright; 2016-2020 by Alice Niemeyer and Markus Baumeister<P/>\n\n",
                    "This package may be distributed under the terms and conditions of the\n",
                    "GNU Public License Version 3 (or higher).<P/>",
                    "The primary sources for much of the covered material are:<P/>",
                    "The PhD-thesis \"Regularity Aspects for Combinatorial Simplicial Surfaces\" of Markus Baumeister<P/>",
                    "The book \"Simplicial Surfaces of Congruent Triangles\" by Alice C. Niemeyer, Wilhelm Plesken, Daniel Robertz, and Ansgar W. Strzelczyk (unpublished)<P/>"
                ),
    )
),



));


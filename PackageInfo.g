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
Subtitle := "Computation with simplicial surfaces and folding processes.",
Version := "0.1",
Date := "10/17/2017", # dd/mm/yyyy format
ArchiveURL := "TODO",
ArchiveFormats := "TODO",

Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Alice",
    LastName := "Niemeyer",
    WWWHome := "https://www.mathb.rwth-aachen.de/Mitarbeiter/niemeyer.php",
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
    WWWHome := "https://www.mathb.rwth-aachen.de/Mitarbeiter/baumeister.php",
    Email := "baumeister@mathb.rwth-aachen.de",
    PostalAddress := "Markus Baumeister\nLehrstuhl B für Mathematik\nRWTH Aachen\nPontdriesch 10/16\n52062 Aachen\nGERMANY\n",
    Place := "Aachen",
    Institution := "Lehrstuhl B für Mathematik, RWTH Aachen",
  ),
],

#SourceRepository := rec( Type := "TODO", URL := "URL" ),
#IssueTrackerURL := "TODO",
#SupportEmail := "TODO",

PackageWWWHome := "http://www.math.rwth-aachen.de/~Simplicial",

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
  GAP := ">= 4.8",
  NeededOtherPackages := [ [ "Grape", ">=4.7" ]],
  SuggestedOtherPackages := [ [ "GAPDoc", ">= 1.6" ], ["AutoDoc", ">=2017.09.08"], [ "IO", ">=2.2" ], [ "NautyTracesInterface", ">0.1" ], [ "Digraphs", ">=0.5" ] ],
  ExternalConditions := [ ],
),

AvailabilityTest := function()
        return true;
    end,

TestFile := "tst/testall.g",

Keywords := [ "Simplicial" ],

));


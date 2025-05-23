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
Version := "0.7",
Date := "11/04/2025", # dd/mm/yyyy format
License := "GPL-3.0-or-later",

Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Alice",
    LastName := "Niemeyer",
    WWWHome := "http://www.math.rwth-aachen.de/~Alice.Niemeyer/",
    Email := "Alice.Niemeyer@Mathb.RWTH-Aachen.De",
    PostalAddress := "Alice Niemeyer\nLehrstuhl für Algebra und Darstellungstheorie\nRWTH Aachen\nPontdriesch 10/16\n52062 Aachen\nGERMANY\n",
    Place := "Aachen",
    Institution := "Chair of Algebra and Representation Theory",
  ),
  rec(
    IsAuthor := true,
    IsMaintainer := false,
    FirstNames := "Markus",
    LastName := "Baumeister",
    WWWHome := "https://markusbaumeister.github.io/",
    Email := "baumeister@mathb.rwth-aachen.de",
    PostalAddress := "--",
    Place := "Aachen",
    Institution := "",
  ),
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Reymond",
    LastName := "Akpanya",
    Email := "akpanya@art.rwth-aachen.de",
    PostalAddress := "--",
    Place := "Aachen",
    Institution := "Chair of Algebra and Representation Theory",
  ),
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Tom",
    LastName := "Görtzen",
    Email := "goertzen@art.rwth-aachen.de",
    PostalAddress := "--",
    Place := "Aachen",
    Institution := "Chair of Algebra and Representation Theory",
  ),
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Meike",
    LastName := "Weiß",
    Email := "weiss@art.rwth-aachen.de",
    PostalAddress := "--",
    Place := "Aachen",
    Institution := "Chair of Algebra and Representation Theory",
  ),
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Lukas",
    LastName := "Schnelle",
    Email := "lukas.schnelle1@rwth-aachen.de",
    PostalAddress := "--",
    Place := "Aachen",
    Institution := "Chair of Algebra and Representation Theory",
  ),
    rec(
    LastName      := "GAP Team",
    FirstNames    := "The",
    IsAuthor      := false,
    IsMaintainer  := true,
    Email         := "support@gap-system.org",
  ),

],

#SourceRepository := rec( Type := "TODO", URL := "URL" ),
#IssueTrackerURL := "TODO",
#SupportEmail := "TODO",

SourceRepository := rec( Type := "git", URL := "https://github.com/gap-packages/SimplicialSurfaces" ),
PackageWWWHome := "https://github.com/gap-packages/SimplicialSurfaces",

PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL     := Concatenation( ~.PackageWWWHome, "/README.md" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
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

AbstractHTML   :=  "The <span class='pkgname'>SimplicialSurfaces</span> package provides functionality for working with simplicial surfaces and generalisations",

PackageDoc := rec(
  BookName  := "SimplicialSurfaces",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Computation with simplicial surfaces and folding processes.",
),

Dependencies := rec(
  GAP := ">= 4.12",
  NeededOtherPackages := [ [ "AttributeScheduler", ">=0.1" ], ["Digraphs", ">=1.1.1"]],
  SuggestedOtherPackages := [ [ "GAPDoc", ">= 1.6" ], ["AutoDoc", ">=2019.05.20"], [ "IO", ">=2.2" ], [ "Grape", ">=4.8.2" ],[ "NautyTracesInterface", ">=0.2" ] ],
  ExternalConditions := [ ],
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

Keywords := [ "Simplicial" ],

AutoDoc := rec(
    TitlePage := rec(
        Copyright := Concatenation(
                    "&copyright; 2016-2025 by Alice Niemeyer and Markus Baumeister<P/>\n\n",
                    "This package may be distributed under the terms and conditions of the\n",
                    "GNU Public License Version 3 (or higher).<P/>",
                    "The primary sources for much of the covered material are:<P/>",
                    "The PhD-thesis \"Regularity Aspects for Combinatorial Simplicial Surfaces\" of Markus Baumeister<P/>",
                    "The book \"Simplicial Surfaces of Congruent Triangles\" by Alice C. Niemeyer, Wilhelm Plesken, Daniel Robertz, and Ansgar W. Strzelczyk (unpublished)<P/>"
                ),
    )
),



));


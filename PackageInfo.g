SetPackageInfo( rec(
PackageName := "Simplicial",
Version := "0.0.1",
Date := "15/11/2016",
Subtitle := "working with simplicial surfaces",
ArchiveURL := "notyetknown",
ArchiveFormats := ".tar.bz2",
Persons := [
  rec(
  LastName := "Niemeyer",
  FirstNames := "Alice",
  IsAuthor := true,
  IsMaintainer := true,
  Email := "Alice.Niemeyer@Mathb.RWTH-Aachen.De",
  WWWHome := "https://www.mathb.rwth-aachen.de/Mitarbeiter/niemeyer.php",
  PostalAddress := "Alice Niemeyer\nLehrstuhl B für Mathematik\nRWTH Aachen\nPontdriesch 10/16\n52062 Aachen\nGERMANY\n",
  Place := "Aachen",
  Institution := "Lehrstuhl B für Mathematik, RWTH Aachen"
  )
],
Status := "in preparation",
README_URL := "notyetknown",
PackageInfoURL := "notyetknown", 
AbstractHTML := "The <span class='pkgname'>Simplicial</span> package provides functionality for working with simplicial surfacese",
PackageWWWHome := "http://www.math.rwth-aachen.de/~Simplicial",
PackageDoc := [
              rec(
  BookName := "Simplicial",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile := "doc/manual.pdf",
  SixFile := "doc/manual.six",
  LongTitle := "Simplicial Surfaces",
  Autoload := true
)
],
Dependencies := rec(
  GAP := "4.7",  
  NeededOtherPackages := [ ["GAPDoc", ">= 1.4"], ],
  SuggestedOtherPackages := [ ["AutoDoc"], [ "IO", ">=2.2" ] ],
  ExternalConditions := []
),
AvailabilityTest := function()
  return true;
end,
TestFile := "tst/test.tst",
Keywords := ["Simplicial"]

));


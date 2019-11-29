all: flatex/flatex doc

doc: doc/manual.six

doc/manual.six: makedoc.g \
    		PackageInfo.g \
		init.g \
		read.g \
		gap/*.gd gap/*.gi \
		gap/ColouredComplexes/*gd \
		gap/ColouredComplexes/*gi \
		gap/Flags/*.gd \
		gap/Flags/*.gi \
		gap/Library/*gd \
		gap/Library/*gi \
		gap/Paths/*gd \
		gap/Paths/*gi \
		gap/Morphisms/*gd \
		gap/Morphisms/*gi \
		gap/PolygonalComplexes/*.gd \
		gap/PolygonalComplexes/*.gi \
		doc/SimplicialSurfaces.xml \
		doc/Introduction.xml \
		doc/PolygonalStructures.xml \
		doc/PolygonalStructuresDefinitions.xml \
		doc/ExampleImplementations.xml \
		doc/ExampleApplications.xml \
		doc/Image_* \
		doc/TableOfContents.autodoc\
		doc/TikZHeader.tex
	gap.sh makedoc.g

flatex/flatex: flatex/flatex.c \
    		flatex/configure.ac \
		flatex/autogen.sh \
		flatex/Makefile.am
	cd flatex && ./autogen.sh && ./configure && make


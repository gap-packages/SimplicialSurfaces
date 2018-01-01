all: doc

doc: doc/manual.six

doc/manual.six: makedoc.g \
    		PackageInfo.g \
		gap/*.gd gap/*.gi \
		gap/PolygonalComplexes/*.gd \
		gap/PolygonalComplexes/*.gi \
		gap/Paths/*gd \
		gap/Paths/*gi \
		doc/SimplicialSurfaces.xml \
		doc/Introduction.xml \
		doc/PolygonalStructures.xml \
		doc/PolygonalStructuresDefinitions.xml \
		doc/ExampleImplementations.xml \
		doc/Image_* \
		doc/TableOfContents.autodoc\
		doc/TikZHeader.tex
	gap makedoc.g


all: doc

doc: doc/manual.six

doc/manual.six: makedoc.g \
    		PackageInfo.g \
		gap/*.gd gap/*.gi \
		doc/Introduction.xml \
		doc/TableOfContents.autodoc
	gap makedoc.g


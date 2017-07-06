all: doc

doc: doc/manual.six

doc/manual.six: makedoc.g \
    		PackageInfo.g \
		gap/*.gd gap/*.gi \
		doc/Introduction.xml
	gap makedoc.g


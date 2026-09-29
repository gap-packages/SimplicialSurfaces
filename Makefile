PKGNAME = SimplicialSurfaces
TESTFILE = tst/testall.g

# directory containing this Makefile, so 'make -f path/to/Makefile' works too
PKGDIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

GAP ?= gap
GAP_ARGS = -q --quitonbreak --packagedirs "$(PKGDIR)"

.DEFAULT_GOAL := help

help: ## show this help
	@echo "The following make targets are available:"
	@awk -F ':.*## ' '/^[a-zA-Z_-]+:.*## / { printf "  make %-8s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo
	@echo "To use a different GAP executable than '$(GAP)', set GAP, e.g.:"
	@echo "  make all GAP=/path/to/gap"
	@echo "  make all GAP=gap-4.16"

all: doc

doc: doc/manual.six

recompile-images:
	cd doc/tikz-files && ./recompile-images.sh
	$(MAKE) doc

doc/manual.six: makedoc.g \
    		PackageInfo.g \
		init.g \
		read.g \
		gap/*.gd \
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
		gap/PolygonalComplexes/*.g \
		doc/SimplicialSurfaces.xml \
		doc/Introduction.xml \
		doc/PolygonalStructures.xml \
		doc/PolygonalStructuresDefinitions.xml \
		doc/ExampleImplementations.xml \
		doc/ExampleApplications.xml \
		doc/tikz-files/Image_* \
		doc/TableOfContents.autodoc\
		doc/tikz-files/TikZHeader.tex
	cd "$(PKGDIR)" && $(GAP) $(GAP_ARGS) makedoc.g -c 'QUIT;'

.PHONY: all doc recompile-images

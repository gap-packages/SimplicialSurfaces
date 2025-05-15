The GAP 4 package  `SimplicialSurfaces`

This package provides a collection of methods for working with simplicial surfaces and their generalizations, such as polygonal complexes. It enables the construction, analysis, and modification of surfaces and complexes. Additionally, it offers tools for edge coloring and for exploring these structures from a group-theoretic perspective.

==============================

## Installation
To use this package, go into your local installation directory for GAP (often located under `~/.gap/` ), and clone this repository in the `pkg/`-subfolder:

    git clone https://github.com/gap-packages/SimplicialSurfaces.git

You also need the `Digraphs` and `AttributeScheduler` package. For installing the `AttributeScheduler` you can use the `PackageManager` or clone the repository:

    git clone https://github.com/gap-packages/AttributeScheduler

Another option for installation is the use of `PackageManager`, which will also install all the necessary dependencies:

    LoadPackage("PackageManager");
    InstallPackage("https://github.com/gap-packages/SimplicialSurfaces.git");

It is suggested that you also use the NautyTracesInterface for faster isomorphism checks:

    git clone https://github.com/gap-packages/NautyTracesInterface.git

To install NautytracesInterface you can run the `install.sh` script in the newly created NautytracesInterface directory. For more information we refer to the package itself.


For using the Package, call

  LoadPackage("SimplicialSurfaces");

to access the package inside a GAP session.

## Manual compilation

To create the manual you have to type

    make

in the main folder of the SimplicialSurfaces-package. This requires `GAPDoc` version `>= 1.6` and `AutoDoc` version `>= 2017.09.15`. These are deposited packages, so usually are shipped with your GAP installation. If you don't have those, go to the folder of your local GAP installation and clone them in the `pkg/`-subfolder:

    git clone https://github.com/frankluebeck/GAPDoc.git
    git clone https://github.com/gap-packages/AutoDoc.git

### Regenerating images
To compile the pictures, you can run the following script:

    doc/tikz-files/recompile-images.sh   

## Help
If there are any questions, don't hesitate to ask us.

If you notice any bugs, strange behaviour or want to request a feature, please use the "Issues"-Tab on GitHub. This makes sure that your contribution will not get lost in some mails and it makes managing the requests easier.

Have fun! :)

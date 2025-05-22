The GAP 4 package  `SimplicialSurfaces`
==============================

## Installation
To use this package, go into your local installation directory for GAP (often located under `/opt/gap*` ), and clone this repository in the `pkg/`-subfolder:

```
cd pkg/
git clone https://github.com/gap-packages/SimplicialSurfaces.git
```

You also need the following package:
```
git clone https://github.com/gap-packages/AttributeScheduler
```

It is suggested that you also use the NautyTracesInterface for faster isomorphism checks:
```
git clone https://github.com/gap-packages/NautyTracesInterface.git
```

To install NautytracesInterface you can run the `install.sh` script in the newly created NautytracesInterface directory. For more information we refer to the package itself.

For using the Package, call
```
LoadPackage("SimplicialSurfaces");
```
to access the package inside a GAP session.

## Manual compilation

To create the manual you have to type
```
make
```
in the main folder of the SimplicialSurfaces-package. This requires `GAPDoc` version `>= 1.6` and `AutoDoc` version `>= 2017.09.15`. These are deposited packages, so usually are shipped with your GAP installation. If you don't have those, go to the folder of your local GAP installation and type
```
cd pkg/
git clone https://github.com/frankluebeck/GAPDoc.git
git clone https://github.com/gap-packages/AutoDoc.git
```
### Regenerating images
To compile the pictures, change into the `doc/tikz-files` subdirectory
and run the `recompile-images.sh` script in it:
```
cd doc/tikz-files/
./recompile-images.sh
```    

## Help
If there are any questions, don't hesitate to ask us.

If you notice any bugs, strange behaviour or want to request a feature, please use the "Issues"-Tab on GitHub. This makes sure that your contribution will not get lost in some mails and it makes managing the requests easier.

Have fun! :)


## License
SimplicialSurfaces is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version. 
For details see the LICENSE file.

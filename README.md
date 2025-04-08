The GAP 4 package `SimplicialSurfaces'
==============================

To use this package, go into your local installation directory for GAP (often located under `/opt/gap*` ), and clone the repository in the `pkg/`-subfolder:

```cd pkg/
    git clone https://github.com/gap-packages/SimplicialSurfaces.git
```

You also need the following package:
```
    git clone https://github.com/gap-packages/AttributeScheduler
```

It is suggested that you also use the NautyTracesInterface for faster 
isomorphism checks:
```
    git clone https://github.com/gap-packages/NautyTracesInterface.git
```

To initialize it, perform the steps in the README of that package (this needs `automake` and `libtools` and probably something else that I do not know)



Then
```
        LoadPackage("SimplicialSurfaces")
```
can be used to access the package inside a GAP session.


To create the manual you have to type
```
    make
```
in the main folder of the SimplicialSurfaces-package. This requires GAPDoc version >= 1.6 and AutoDoc version >= 2017.09.15. These are deposited packages, so usually are shipped with your GAP installation. If you don't have those, go to the folder of your local GAP installation and type
```
    cd pkg/
    git clone https://github.com/frankluebeck/GAPDoc.git
    git clone https://github.com/gap-packages/AutoDoc.git
```
To compile the pictures, you also can run the following script:
```
    doc/tikz-files/recompile-images.sh
```    

If there are any questions, don't hesitate to ask us.

If you notice any bugs, strange behaviour or want to request a feature, please use the "Issues"-Tab on GitHub. This makes sure that your contribution will not get lost in some mails and it makes managing the requests easier.

Have fun! :)
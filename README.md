The GAP 4 package `SimplicialSurfaces'
==============================


There are two ways to use this package. Both start with downloading or cloning
the repository (cloning via git is preferable as you get updates more easily).

A) Go into your installation directory for GAP, then the subfolder pkg/ and
    put the SimplicialSurface-folder there. Then you can use
        LoadPackage("SimplicialSurfaces")
    to access the package inside GAP.
B) Go into the folder gap/ of the repository and use "gap play.g".
    Alternatively you can start gap from there and read "play.g".

The manual is in the folder doc/
At the current point in time it is more of a rough draft but it should be able
to explain the functionality of most methods you want to use in the immediate
future.

You can recreate the manual by typing
    make
in the main folder. This requires GAPDoc version >= 1.6. If you don't have this
one, go to your local GAP installation and type
    cd pkg/
    git clone https://github.com/frankluebeck/GAPDoc.git


If there are any questions, don't hesitate to ask.

If you notice any bugs, strange behaviour or want to request a feature,
please use the "Issues"-Tab on GitHub. This makes sure that your contribution
will not get lost in some mails and it makes managing the requests easier.



Have fun! :)


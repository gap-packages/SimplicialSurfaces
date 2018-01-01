#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2018
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

#! @DoNotReadRestOfFile
#!
#! The category <K>DualPath</K> contains the functionality that
#! <K>VertexEdgePath</K> and <K>EdgeFacePath</K> have in common.
#!

#! @Description
#! Return whether a certain object is a dual path.
#! @Arguments object
#! @Returns true or false
DeclareCategory( "IsDualPath", IsObject );

BindGlobal( "DualPathFamily", 
    NewFamily( "DualPathFamily", IsObject, IsDualPath ));

#! @Description
#! Return the complete path as list in which the entries are alternating
#! between the two types.
#! @Arguments path
#! @Returns a list of integers
DeclareAttribute( "Path", IsDualPath );


#! @Description
#! Create a new dual path that encodes the given <A>path</A>.
#! The given list has to fulfill the following properties:
#! * it only contains positive integers
#! * it has odd length
#! * it does not contain holes
#! @Arguments path
#! @Returns a dual path
DeclareOperation( "DualPath", [IsDenseList] );


#! @Description
#! Return the even entries of the <A>dualPath</A> as list.
#! @Arguments dualPath
#! @Returns a list
DeclareAttribute( "EvenPart", IsDualPath );


#! @Description
#! Return the odd entries of the <A>dualPath</A> as list.
#! @Arguments dualPath
#! @Returns a list
DeclareAttribute( "OddPart", IsDualPath );


#! @Description
#! Return whether the dual path is closed. It is closed if its
#! first and last entry coincide.
#! @Arguments dualPath
DeclareProperty( "IsClosedPath", IsDualPath );


#! @Description
#! Return whether the dual path is duplicate-free. A dual path is
#! duplicate free if no entry appears twice as even entry or as an
#! odd entry (exception: the first and last entry may be equal).
#! @Arguments dualPath
DeclareProperty( "IsDuplicateFree", IsDualPath );

#! @Description
#! If a dual path is closed and duplicate-free we can interpret the
#! even and odd part as cyclic permutations.
#! 
#! This method returns the even permutation.
#! @Arguments dualPath
#! @Returns a permutation
DeclareAttribute( "EvenPartAsPerm", IsDualPath and IsClosedPath and IsDuplicateFree );


#! @Description
#! If a dual path is closed and duplicate-free we can interpret the
#! even and odd part as cyclic permutations.
#! 
#! This method returns the odd permutation.
#! @Arguments dualPath
#! @Returns a permutation
DeclareAttribute( "OddPartAsPerm", IsDualPath and IsClosedPath and IsDuplicateFree );



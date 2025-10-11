# This file contains tests for method UmbrellaDescriptorOfSurface
# complex category

BindGlobal( "__SIMPLICIAL_Test_UmbrellaDescriptor", function()

        local surf, newsurf, umbdescriptor;

        # test the One Face
        surf := SimplicialSurfaceByVerticesInFaces( [[2,3,5] ]);
        umbdescriptor := UmbrellaDescriptorOfSurface(surf);
        newsurf :=  SimplicialSurfaceByUmbrellaDescriptor(umbdescriptor);
        SIMPLICIAL_TestAssert( IsIsomorphic(surf,newsurf) );

        # test the Janus Head
        surf := JanusHead();
        umbdescriptor := UmbrellaDescriptorOfSurface(surf, false);
        newsurf :=  SimplicialSurfaceByUmbrellaDescriptor(umbdescriptor);
        SIMPLICIAL_TestAssert( IsIsomorphic(surf,newsurf) );

        # test surface with vertex of degree 1 (three umbrellas in line)
        surf := SimplicialSurfaceByVerticesInFaces( 5,3, 
                                           [[1,2,3],[2,5,3],[2,4,5]] );
        umbdescriptor := UmbrellaDescriptorOfSurface(surf, false);
        newsurf :=  SimplicialSurfaceByUmbrellaDescriptor(umbdescriptor);
        SIMPLICIAL_TestAssert( IsIsomorphic(surf,newsurf) );

        # test the double Janus head, which has 2 ears.
        surf := SimplicialSurfaceByDownwardIncidence( 
                    [[1,3],[2,3],[1,2],[1,2],[1,4],[2,4]],
                    [[1,2,3],[1,2,4],[3,5,6],[4,5,6]] );   
        umbdescriptor := UmbrellaDescriptorOfSurface(surf, false);
        newsurf :=  SimplicialSurfaceByUmbrellaDescriptor(umbdescriptor);
        SIMPLICIAL_TestAssert( IsIsomorphic(surf,newsurf) );

        # test a surface made up out of  3 ears.
        surf := SimplicialSurfaceByDownwardIncidence( 
		[[1,2],[1,2],[1,2],[1,3],[2,3],[1,5],[2,5],[1,4],[2,4]],
                [[1,6,7],[1,4,5],[2,4,5], [2,8,9],[3,8,9],[3,6,7]] );
        umbdescriptor := UmbrellaDescriptorOfSurface(surf, false);
        newsurf :=  SimplicialSurfaceByUmbrellaDescriptor(umbdescriptor);
        SIMPLICIAL_TestAssert( IsIsomorphic(surf,newsurf) );

end);


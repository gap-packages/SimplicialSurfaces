if IsPackageMarkedForLoading("NautyTracesInterface", ">=0.2") then
	BindGlobal( "__SIMPLICIAL_Test_AllSimplicialSurfacesByEssentialButterflyInsertion", function()
		local list1, s2, list2, s3, list3;
	
		list1:=AllSimplicialSurfacesByEssentialButterflyInsertion(Octahedron());
		Assert(0, Length(list1)=1);
		Assert(0, IsIsomorphic(list1[1],SimplicialDoubleUmbrella(5)));

        # the other simplicial sphere with 8 faces
        s2:=SimplicialSurfaceByVerticesInFaces([ [ 2, 3, 4 ], [ 4, 5, 6 ], [ 1, 5, 6 ], [ 3, 4, 6 ], [ 2, 4, 5 ], [ 2, 3, 5 ], [ 1, 3, 6 ], [ 1, 3, 5 ] ]);
        list2:=AllSimplicialSurfacesByEssentialButterflyInsertion(s2);

        Assert(0,Length(list2)=4);

        s3 := SimplicialSurfaceByDownwardIncidence([ [ 1, 3 ], [ 1, 2 ], [ 2, 3 ], [ 3, 4 ], [ 1, 4 ], [ 1, 5 ], [ 1, 6 ],
                    [ 2, 6 ], [ 2, 7 ], [ 3, 7 ], [ 3, 8 ], [ 4, 8 ], [ 4, 5 ],  [ 5, 6 ],
                    [ 6, 7 ], [ 7, 8 ], [ 5, 8 ] ], [ [1, 2, 3], [1, 4, 5], [6, 7, 14], [2, 7, 8], [8, 9, 15],
                    [3, 9, 10], [10, 11, 16], [4, 11, 12], [12, 13, 17], [5, 6, 13] ]);
        list3:=AllSimplicialSurfacesByEssentialButterflyInsertion(s3);

        Assert(0,Length(list3)=4);
	end);
else
	BindGlobal( "__SIMPLICIAL_Test_AllSimplicialSurfacesByEssentialButterflyInsertion", function() end);
fi;
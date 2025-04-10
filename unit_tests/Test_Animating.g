#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2025
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

BindGlobal( "__SIMPLICIAL_Test_Animating", function()
    local oct, verticesPositions, printRecord, printRecordVert, printRecordEd, printRecordFa, printRecordTrans,
	printRecordVertCol, printRecordEdCol, printRecordFaCol, printRecordCirc, printRecordNorm;
	oct := Octahedron();

	verticesPositions := [ [ 0, 0, Sqrt(2.) ], [ 1, 1, 0 ], [ 1, -1, 0 ],
		[ -1, -1, 0 ], [ -1, 1, 0 ], [ 0, 0, -Sqrt(2.) ] ]; 
	printRecord := SetVertexCoordinates3D(oct, verticesPositions, rec());
	printRecord:=CalculateParametersOfEdges(oct,printRecord);
	
	SIMPLICIAL_TestAssert(GetVertexCoordinates3D(oct,3,printRecord)=Float([1,-1,0]));
	SIMPLICIAL_TestAssert(IsVertexActive(oct,1,printRecord)=true);
	SIMPLICIAL_TestAssert(IsEdgeActive(oct,1,printRecord)=true);
	SIMPLICIAL_TestAssert(IsFaceActive(oct,1,printRecord)=true);
	
	#vertices
	printRecordVert:=DeactivateVertices(oct, printRecord);
	SIMPLICIAL_TestAssert(printRecordVert.drawVertices=[false,false,false,false,false,false]);
	printRecordVert:=ActivateVertex(oct, 2, printRecordVert);
	printRecordVert:=ActivateVertex(oct, 6, printRecordVert);
	SIMPLICIAL_TestAssert(printRecordVert.drawVertices=[false,true,false,false,false,true]);
	SIMPLICIAL_TestAssert(IsVertexActive(oct,2,printRecord)=true);
	SIMPLICIAL_TestAssert(IsVertexActive(oct,3,printRecord)=false);
	
	#edges
	printRecordEd:=DeactivateEdges(oct, printRecord);
	SIMPLICIAL_TestAssert(printRecordEd.drawEdges=[false,false,false,false,false,false,false,false,false,false,false,false]);
	printRecordEd:=ActivateEdge(oct, 2, printRecordEd);
	printRecordEd:=ActivateEdge(oct, 6, printRecordEd);
	printRecordEd:=ActivateEdge(oct, 12, printRecordEd);
	SIMPLICIAL_TestAssert(printRecordEd.drawEdges=[false,true,false,false,false,true,false,false,false,false,false,true]);
	SIMPLICIAL_TestAssert(IsEdgeActive(oct,2,printRecord)=true);
        SIMPLICIAL_TestAssert(IsEdgeActive(oct,3,printRecord)=false);
	
	#faces
	printRecordFa:=DeactivateFaces(oct, printRecord);
	SIMPLICIAL_TestAssert(printRecordFa.drawFaces=[false,false,false,false,false,false,false,false]);
	printRecordFa:=ActivateFace(oct, 2, printRecordFa);
	printRecordFa:=ActivateFace(oct, 6, printRecordFa);
	SIMPLICIAL_TestAssert(printRecordFa.drawFaces=[false,true,false,false,false,true,false,false]);
	SIMPLICIAL_TestAssert(IsFaceActive(oct,2,printRecord)=true);
        SIMPLICIAL_TestAssert(IsFaceActive(oct,3,printRecord)=false);
	
	#Transparency
	SIMPLICIAL_TestAssert(GetTransparencyJava(oct,1,printRecord)=1);
	printRecordTrans:=SetTransparencyJava(oct,2,0.1,printRecord);
	SIMPLICIAL_TestAssert(printRecordTrans.FaceTransparency[2]=0.1);
	SIMPLICIAL_TestAssert(GetTransparencyJava(oct,2,printRecordTrans)=0.1);
	printRecordTrans:=RemoveTransparencyJava(oct,2,printRecordTrans);
	SIMPLICIAL_TestAssert(printRecordTrans.FaceTransparency=[]);

	#Colours
	printRecordVertCol:=SetVertexColour(oct,2,"red",printRecord);
	SIMPLICIAL_TestAssert(printRecordVertCol.vertexColours=[,"red"]);
	SIMPLICIAL_TestAssert(GetVertexColour(oct,2,printRecordVertCol)="red");

	printRecordEdCol:=SetEdgeColour(oct,2,"red",printRecord);
        SIMPLICIAL_TestAssert(printRecordEdCol.edgeColours=[,"red"]);
        SIMPLICIAL_TestAssert(GetEdgeColour(oct,2,printRecordEdCol)="red");

	printRecordFaCol:=SetFaceColour(oct,2,"red",printRecord);
        SIMPLICIAL_TestAssert(printRecordFaCol.faceColours=[,"red"]);
        SIMPLICIAL_TestAssert(GetFaceColour(oct,2,printRecordFaCol)="red");

	#InnerCircles
	printRecordCirc:=ActivateInnerCircles(oct,printRecord);
	SIMPLICIAL_TestAssert(printRecordCirc.drawInnerCircles=[true,true,true,true,true,true,true,true]);
	printRecordCirc:=DeactivateInnerCircle(oct,2,printRecordCirc);
	SIMPLICIAL_TestAssert(printRecordCirc.drawInnerCircles[2]=false);
	SIMPLICIAL_TestAssert(IsInnerCircleActive(oct,2,printRecord)=false);
        SIMPLICIAL_TestAssert(IsInnerCircleActive(oct,3,printRecord)=true);

	printRecordCirc:=SetCircleColour(oct,3,"green",printRecordCirc);
	SIMPLICIAL_TestAssert(printRecordCirc.circleColours=[ ,, "green" ]);
	SIMPLICIAL_TestAssert(GetCircleColour(oct,3,printRecordCirc)="green");

	#NormalInnerCircles
        printRecordNorm:=ActivateNormalOfInnerCircles(oct,printRecord);
        SIMPLICIAL_TestAssert(printRecordNorm.drawNormalOfInnerCircles=[true,true,true,true,true,true,true,true]);
        printRecordNorm:=DeactivateNormalOfInnerCircle(oct,2,printRecordNorm);
        SIMPLICIAL_TestAssert(printRecordNorm.drawNormalOfInnerCircles[2]=false);
	SIMPLICIAL_TestAssert(IsInnerCircleActive(oct,2,printRecord)=false);
        SIMPLICIAL_TestAssert(IsInnerCircleActive(oct,3,printRecord)=true);
end);

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

#! @Chapter Edge colourings
#! @ChapterLabel EdgeColouring
#! 
#! This chapter is concerned with edge-coloured polygonal complexes and in
#! particular simplicial surfaces. While it defines general functionality for
#! arbitrary edge-colourings, it lays a focus on specific edge-colourings. TODO explain better
#!

#! @Section General definition
#! @SectionLabel EdgeColouring_Definition
#!
#! This section describes how an edge-colouring is implemented in the
#! <K>SimplicialSurfaces</K>-package.
#!
#! An <K>EdgeColouredPolygonalComplex</K> 
#! (<Ref Subsect="EdgeColouredPolygonalComplex"/>) consists of:
#! * a polygonal complex, accessible by <K>PolygonalComplex</K> 
#!   (<Ref Subsect="EdgeColouring_PolygonalComplex"/>)
#! * an edge colouring, which can be accessed by 
#!   <K>ColoursOfEdges</K> (<Ref Subsect="ColoursOfEdges"/>) and
#!   <K>EdgesOfColours</K> (<Ref Subsect="EdgesOfColours"/>)
#!
#! @InsertChunk Example_Coloured_Pyramid
#!
#TODO explain this using a bigger example with two different colourings
#maybe show off the feature of using GAPs capabilities?


#! @Description
#! Check if a given object is an <K>IsEdgeColouredPolygonalComplex</K>. This
#! is the case if it consists of a polygonal complex and an edge colouring,
#! accessible by <K>PolygonalComplex</K> 
#! (<Ref Subsect="EdgeColouring_PolygonalComplex"/>) and <K>ColoursOfEdges</K> 
#! (<Ref Subsect="ColoursOfEdges"/>)
#! respectively.
#! @Arguments object
#! @Returns true or false
DeclareCategory( "IsEdgeColouredPolygonalComplex", IsObject );

BindGlobal( "EdgeColouredPolygonalComplexFamily",
    NewFamily("EdgeColouredPolygonalComplexFamily", IsObject, 
        IsEdgeColouredPolygonalComplex) );

#! @BeginGroup EdgeColouredPolygonalComplex
#! @Description
#! Construct an edge coloured polygonal complex. The edge colouring can be
#! given in one of two ways:
#! <Enum>
#!   <Item>As a list <A>colouring</A> of positive integers. For every edge
#!      <A>edge</A> in the given <A>complex</A> the entry 
#!      <A>colouring[edge]</A> contains the colour of <A>edge</A> 
#!      (we encode colours by positive integers).
#!   </Item>
#!   <Item>As a list <A>colouring</A> of sets of positive integers. For
#!      every colour <A>col</A> (the colours are described by positive
#!      integers) the entry <A>colouring[col]</A> contains the set of
#!      all edges with colour <A>col</A>.
#!   </Item>
#! </Enum>
#!
#! @InsertChunk Example_TwiceColoured_Pyramid
#!
#! The NC-version does not check whether the given <A>colouring</A> is consistent
#! with the edges of <A>complex</A>, i.e.
#! * Does every edge of <A>complex</A> appear?
#! * Is every purported edge of <A>colouring</A> an edge of <A>complex</A>?
#!
#! @Returns an <K>EdgeColouredPolygonalComplex</K>
#! @Arguments complex, colouring
DeclareOperation( "EdgeColouredPolygonalComplex", [IsPolygonalComplex, IsList] );
#! @Arguments complex, colouring
DeclareOperation( "EdgeColouredPolygonalComplexNC", [IsPolygonalComplex, IsList] );
#! @EndGroup


#! @BeginGroup EdgeColouring_PolygonalComplex
#! @Description
#! Return the underlying polygonal complex of an edge coloured polygonal
#! complex.
#!
#! For example both edge coloured pyramids from 
#! <Ref Subsect="EdgeColouredPolygonalComplex"/> have the same underlying
#! polygonal complex.
#! @BeginExampleSession
#! gap> PolygonalComplex(colPyr1) = PolygonalComplex(colPyr2);
#! true
#! @EndExampleSession
#!
#! @Returns a polygonal complex
#! @Arguments colComplex
DeclareAttribute( "PolygonalComplex", IsEdgeColouredPolygonalComplex );
#! @EndGroup


#! @BeginGroup ColoursOfEdges
#! @Description
#! The method <K>ColourOfEdge</K>(<A>colComplex</A>, <A>edge</A>) returns the
#! colour of <A>edge</A>, represented by a positive integer. The NC-version
#! does not check whether the given <A>edge</A> is an edge of the underlying
#! polygonal complex.
#!
#! The attribute <K>ColoursOfEdges</K>(<A>colComplex</A>) collects all of
#! those colours in a list that is indexed by the edge labels, i.e.
#! <K>ColoursOfEdges</K>(<A>colComplex</A>)[<A>edge</A>] 
#! = <K>ColourOfEdge</K>(<A>colComplex</A>, <A>edge</A>). All other
#! positions of this list are not bound.
#!
#! @InsertChunk Example_ColoursOfEdges_Pyramid
#!
#! @Returns a list of positive integers / a positive integer
#! @Arguments colComplex
DeclareAttribute( "ColoursOfEdges", IsEdgeColouredPolygonalComplex );
#! @Arguments colComplex, edge
DeclareOperation( "ColourOfEdge", [IsEdgeColouredPolygonalComplex, IsPosInt] );
#! @Arguments colComplex, edge
DeclareOperation( "ColourOfEdgeNC", [IsEdgeColouredPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @BeginGroup EdgesOfColours
#! @Description
#! The method <K>EdgesOfColour</K>(<A>colComplex</A>, <A>colour</A>) returns 
#! the set of all edges with colour <A>colour</A>. If a colour is not used
#! in the given edge coloured polygonal complex, the empty set is returned.
#!
#! The attribute <K>EdgesOfColours</K>(<A>colComplex</A>) collects all of
#! these sets in a list that is indexed by the colours (given as positive
#! integers), i.e. <K>EdgesOfColours</K>(<A>colComplex</A>)[<A>colour</A>]
#! = <K>EdgesOfColour</K>(<A>colComplex</A>, <A>colour</A>). All other
#! positions of this list are not bound.
#!
#! @InsertChunk Example_EdgesOfColours_Pyramid
#! 
#! @Returns a list of sets of positive integers / a set of positive integers
#! @Arguments colComplex
DeclareAttribute( "EdgesOfColours", IsEdgeColouredPolygonalComplex );
#! @Arguments colComplex, colour
DeclareOperation( "EdgesOfColour", [IsEdgeColouredPolygonalComplex, IsPosInt] );
#TODO is this the right way or should the wrong colour lead to an error?
#! @EndGroup


#! @Section Drawing edge coloured surfaces
#! @SectionLabel EdgeColouring_Drawing
#!
#! @InsertChunk Example_EdgeColouring_Drawing

#! @BeginGroup DrawSurfaceToTikz_EdgeColoured
#! @Description
#! Draw the net of the given <A>colRamSurf</A> into a tex-file (using TikZ).
#! This method extends the drawing method for ramified polygonal surfaces
#! (compare <Ref Subsect="DrawSurfaceToTikz"/>) by respecting the edge colour
#! classes of <A>colRamSurf</A>. An introduction the the usage of the 
#! additional parameters can be found at the start of section
#! <Ref Sect="Section_EdgeColouring_Drawing"/>.
#!
#! * If the given <A>fileName</A> does not end in <E>.tex</E> the ending 
#!   <E>.tex</E> will be added to it. 
#! * The given file will be overwritten without asking if it already exists.
#!   If you don't have permission to write in that file, this method will
#!   throw an error.
#! * The particulars of the drawing are determined by the 
#!   given <A>printRecord</A>. If this is not given, the default settings are 
#!   used. 
#! * The <A>printRecord</A> will be modified and returned by this method.
#!   It contains the data to recreate the drawing of the surface.
#TODO give option to draw with just the record
#! 
#! There are several parameters to change the output of this method, from 
#! cosmetic changes to exactly controlling in which order the faces are drawn.
#! For the standard parameters, see <Ref Subsect="DrawSurfaceToTikz"/>. For
#! edge coloured ramified polygonal surfaces the 
#! <E>edgeColourClass</E>-parameters are added:
#! * <E>edgeColourClassActive</E>: If this parameter is <K>false</K> the
#!   other <E>edgeColourClass</E>-parameters have no effect. By default, it
#!   is <K>true</K>.
#! * <E>edgeColourClassLengths</E>: This parameter is a list with an entry
#!   for every colour of <A>colRamSurf</A>. The entry of a colour defines 
#!   the length of all
#!   edges with this colour.
#!   This parameter overwrites <E>edgeLengths</E> as long as
#!   <E>edgeColourClassActive</E> is <K>true</K>.
#! * <E>edgeColourClassColours</E>: This parameter is a list with an entry
#!   for every colour of <A>colRamSurf</A>. The entry of a colour defines
#!   the drawing colour for all edges of this colour class.
#!   This parameter overwrites <E>edgeColours</E> as long as
#!   <E>edgeColourClassActive</E> is <K>true</K>.
#! 
#! @Returns a record
#! @Arguments colRamSurf, fileName[, printRecord]
DeclareOperation( "DrawSurfaceToTikz", [IsEdgeColouredPolygonalComplex, IsString, IsRecord] );
#! @EndGroup

#TODO Section Incidence graphs and automorphisms

#Section Rainbow colouring
    #group theoretic description: Generators, Group, VertexGroup
    #perfect colourings: MRTypeOfEdges, IsMRTypeColourInvariant
    #construction: All..., SixfoldCover, (DoubleCover);

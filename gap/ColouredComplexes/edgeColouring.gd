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
#! This chapter is concerned with edge-coloured (twisted) polygonal complexes and in
#! particular simplicial surfaces. The first section 
#! (<Ref Sect="Section_EdgeColouring_Definition"/>) deals with the definition
#! of arbitrary edge-colourings and the methods to access its colouring.
#!
#! The second section (<Ref Sect="Section_EdgeColouring_Drawing"/>) explains
#! how the drawing functionality for polygonal surfaces without edge
#! ramifications (compare
#! section <Ref Sect="Section_Embeddings_DrawTikz"/> for details) is extended
#! for edge-coloured ramified polygonal surfaces.
#!
#! Finally section <Ref Sect="Section_EdgeColouring_Isomorphism"/> deals
#! with the isomorphism problem of edge-coloured polygonal complexes.
#!

#! @Section General definition
#! @SectionLabel EdgeColouring_Definition
#!
#! This section describes how an edge-colouring is implemented in the
#! <K>SimplicialSurfaces</K>-package.
#!
#! An <K>EdgeColouredTwistedPolygonalComplex</K> 
#! (<Ref Subsect="EdgeColouredTwistedPolygonalComplex"/>) consists of:
#! * a twisted polygonal complex, accessible by <K>TwistedPolygonalComplex</K> 
#!   (<Ref Subsect="EdgeColouring_TwistedPolygonalComplex"/>)
#! * an edge colouring, which can be accessed by 
#!   <K>ColoursOfEdges</K> (<Ref Subsect="ColoursOfEdges"/>) and
#!   <K>EdgesOfColours</K> (<Ref Subsect="EdgesOfColours"/>)
#!
#! Specialisations like <K>EdgeColouredPolygonalComplex</K> and
#! <K>EdgeColouredSimplicialSurface</K> exist as well and behave
#! in the expected way.
#!
#! @InsertChunk Example_Coloured_Pyramid
#!
#TODO explain this using a bigger example with two different colourings
#maybe show off the feature of using GAPs capabilities?

#TODO mention that attributes are copied over

#! @BeginGroup IsEdgeColouredTwistedPolygonalComplex
#! @Description
#! Check if a given object is an <K>IsEdgeColouredTwistedPolygonalComplex</K>. This
#! is the case if it consists of a twisted polygonal complex and an edge colouring,
#! accessible by <K>TwistedPolygonalComplex</K> 
#! (<Ref Subsect="EdgeColouring_TwistedPolygonalComplex"/>) and <K>ColoursOfEdges</K> 
#! (<Ref Subsect="ColoursOfEdges"/>)
#! respectively.
#!
#! In addition there are some properties of the type 
#! <K>IsEdgeColoured</K><E>Thing</E> which check if
#! the underlying twisted polygonal complex fulfills <E>Thing</E>. For example
#! <K>IsEdgeColouredSimplicialSurface</K> checks if the underlying
#! polygonal complex is a simplicial surface.
#! 
#! @Arguments object
DeclareCategory( "IsEdgeColouredTwistedPolygonalComplex", IsTwistedPolygonalComplex );
#! @Arguments object
DeclareProperty( "IsEdgeColouredPolygonalComplex", IsEdgeColouredTwistedPolygonalComplex );
#! @Arguments colComplex
DeclareProperty( "IsEdgeColouredSimplicialSurface", IsEdgeColouredPolygonalComplex );
#! @EndGroup

InstallTrueMethod( IsPolygonalComplex, IsEdgeColouredPolygonalComplex );
InstallTrueMethod( IsSimplicialSurface, IsEdgeColouredSimplicialSurface );

BindGlobal( "EdgeColouredTwistedPolygonalComplexFamily",
    NewFamily("EdgeColouredTwistedPolygonalComplexFamily", IsObject, 
        IsEdgeColouredTwistedPolygonalComplex) );
BindGlobal( "EdgeColouredPolygonalComplexFamily",
    NewFamily("EdgeColouredPolygonalComplexFamily", IsObject, 
        IsEdgeColouredPolygonalComplex) );

#! @BeginGroup EdgeColouredTwistedPolygonalComplex
#! @Description
#! Construct an edge coloured (twisted) polygonal complex. The edge colouring can be
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
#! The more specific variations enforce their more restrictive type on
#! <A>complex</A>, e.g. <K>EdgeColouredSimplicialSurface</K> requires
#! <A>complex</A> to be a simplicial surface.
#!
#! Note: If the given <A>complex</A> is already edge coloured, it will be
#! stripped of this colouring first.
#!
#! @InsertChunk Example_TwiceColoured_Pyramid
#!
#! The NC-version does not check whether the given <A>colouring</A> is consistent
#! with the edges of <A>complex</A>, i.e.
#! * Does every edge of <A>complex</A> appear?
#! * Is every purported edge of <A>colouring</A> an edge of <A>complex</A>?
#!
#! @Returns an <K>EdgeColouredTwistedPolygonalComplex</K>
#! @Arguments complex, colouring
DeclareOperation( "EdgeColouredTwistedPolygonalComplex", [IsTwistedPolygonalComplex, IsList] );
#! @Arguments complex, colouring
DeclareOperation( "EdgeColouredTwistedPolygonalComplexNC", [IsTwistedPolygonalComplex, IsList] );
#! @Returns an <K>EdgeColouredPolygonalComplex</K>
#! @Arguments complex, colouring
DeclareOperation( "EdgeColouredPolygonalComplex", [IsTwistedPolygonalComplex, IsList] );
#! @Arguments complex, colouring
DeclareOperation( "EdgeColouredPolygonalComplexNC", [IsTwistedPolygonalComplex, IsList] );
#! @Returns an <K>EdgeColouredSimplicialSurface</K>
#! @Arguments surface, colouring
DeclareOperation( "EdgeColouredSimplicialSurface", [IsTwistedPolygonalComplex, IsList] );
#! @Arguments surface, colouring
DeclareOperation( "EdgeColouredSimplicialSurfaceNC", [IsTwistedPolygonalComplex, IsList] );
#! @EndGroup


#! @BeginGroup EdgeColouring_TwistedPolygonalComplex
#! @Description
#! Return the underlying twisted polygonal complex of an edge coloured 
#! twisted polygonal complex. 
#! The other variants return the same object but will
#! guarantee the more specific type.
#!
#! For example both edge coloured pyramids from 
#! <Ref Subsect="EdgeColouredTwistedPolygonalComplex"/> have the same underlying
#! polygonal complex.
#! @BeginExampleSession
#! gap> PolygonalComplex(colPyr1) = PolygonalComplex(colPyr2);
#! true
#! @EndExampleSession
#!
#! @Returns a twisted polygonal complex
#! @Arguments colComplex
DeclareAttribute( "TwistedPolygonalComplex", IsEdgeColouredTwistedPolygonalComplex );
#! @Returns a polygonal complex
#! @Arguments colComplex
DeclareAttribute( "PolygonalComplex", IsEdgeColouredPolygonalComplex );
#! @Returns a simplicial surface
#! @Arguments colComplex
DeclareAttribute( "SimplicialSurface", IsEdgeColouredSimplicialSurface );
#! @EndGroup


#! @BeginGroup ColoursOfEdges
#! @Description
#! The method <K>ColourOfEdge</K>(<A>colComplex</A>, <A>edge</A>) returns the
#! colour of <A>edge</A>, represented by a positive integer. The NC-version
#! does not check whether the given <A>edge</A> is an edge of the underlying
#! twisted polygonal complex.
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
DeclareAttribute( "ColoursOfEdges", IsEdgeColouredTwistedPolygonalComplex );
#! @Arguments colComplex, edge
DeclareOperation( "ColourOfEdge", [IsEdgeColouredTwistedPolygonalComplex, IsPosInt] );
#! @Arguments colComplex, edge
DeclareOperation( "ColourOfEdgeNC", [IsEdgeColouredTwistedPolygonalComplex, IsPosInt] );
#! @EndGroup

#! @BeginGroup EdgesOfColours
#! @Description
#! The method <K>EdgesOfColour</K>(<A>colComplex</A>, <A>colour</A>) returns 
#! the set of all edges with colour <A>colour</A>. If a colour is not used
#! in the given edge coloured twisted polygonal complex, the empty set is returned.
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
DeclareAttribute( "EdgesOfColours", IsEdgeColouredTwistedPolygonalComplex );
#! @Arguments colComplex, colour
DeclareOperation( "EdgesOfColour", [IsEdgeColouredTwistedPolygonalComplex, IsPosInt] );
#TODO is this the right way or should the wrong colour lead to an error?
#! @EndGroup


#! @Description
#! Return the set of all edge colours that are used in the given edge
#! coloured twisted polygonal complex.
#!
#! @Returns a set of positive integers
#! @Arguments colComplex
DeclareAttribute( "Colours", IsEdgeColouredTwistedPolygonalComplex );



##
## View and Display
DeclareAttribute( "ViewInformationEdgeColoured", IsEdgeColouredTwistedPolygonalComplex );
DeclareAttribute( "DisplayInformationEdgeColoured", IsEdgeColouredTwistedPolygonalComplex );


#! @Section Drawing edge coloured surfaces
#! @SectionLabel EdgeColouring_Drawing
#!
#! @InsertChunk Example_EdgeColouring_Drawing

#! @BeginGroup DrawSurfaceToTikz_EdgeColoured
#! @Description
#! Draw the net of the given <A>colRamSurf</A> into a tex-file (using TikZ).
#! This method extends the drawing method for polygonal surfaces without edge
#! ramifications
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
DeclareOperation( "DrawSurfaceToTikz", [IsEdgeColouredPolygonalComplex and IsNotEdgeRamified, IsString, IsRecord] );
#! @EndGroup


#! @Section Isomorphisms between edge-coloured polygonal complexes
#! @SectionLabel EdgeColouring_Isomorphism
#!
#! An edge-coloured polygonal complex can be completely described by the
#! incidence structure of its polygonal complex and the edge colouring.
#! These can be encoded in an extended incidence graph. To do so, we start
#! with the incidence graph from section 
#! <Ref Sect="Section_Graphs_Incidence"/> and add a vertex for each colour,
#! which is connected to all edges of this colour.
#!
#! Then the isomorphism problem can be decided if one of the following graph
#! packages is loaded:
#! @InsertChunk Graphs_Packages

#! @BeginGroup ColourIncidenceGraph
#! @Description
#! Return the colour-extended incidence graph (a coloured, undirected graph)
#! of the given edge coloured polygonal complex. It is defined as follows:
#! <List>
#!   <Item>The <E>vertices</E> are the vertices (colour 0), edges (colour 1), 
#!   faces (colour 2) and colours (colour 4) of <A>colComplex</A>. The labels
#!   are shifted in the following way:
#!      @InsertChunk Graphs_LabelShift
#!      <List>
#!          <Item>The colour labels are shifted upwards by the sum of the 
#!              maximal vertex
#!              label, the maximal edge label and the maximal face label.
#!          </Item>
#!      </List>
#!   </Item>
#!   <Item>The <E>edges</E> can be one of these:
#!      <List>
#!          <Item>Vertex-edge-pairs or edge-face-pairs such that the elements of
#!              the pair are incident in the polygonal complex of <A>colComplex</A>
#!          </Item>
#!          <Item>edge-colour-pairs such that the edge has the corresponding colour
#!              in <A>colComplex</A>.</Item>
#!      </List>
#!    </Item>
#! </List>
#! The returned graph can be given in three different formats, corresponding
#! to different graph packages:
#! @InsertChunk Graphs_Packages
#! 
#! TODO example
#! @Returns a graph as defined in the package <K>Digraphs</K>
#! @Arguments colComplex
DeclareAttribute( "ColourIncidenceDigraphsGraph", IsEdgeColouredPolygonalComplex );
#! @Returns a graph as defined in the package <K>GRAPE</K>
#! @Arguments colComplex
DeclareAttribute( "ColourIncidenceGrapeGraph", IsEdgeColouredPolygonalComplex );
#! @Returns a graph as defined in the package <K>NautyTracesInterface</K>
#! @Arguments colComplex
DeclareAttribute( "ColourIncidenceNautyGraph", IsEdgeColouredPolygonalComplex );
#! @EndGroup


#! @Description
#! Return whether the given edge coloured polygonal complexes are isomorphic.
#! They are isomorphic if their colour-extended incidence graphs
#! (compare <Ref Subsect="ColourIncidenceGraph"/>) are isomorphic. Changes
#! of the colour labels are explicitly allowed.
#!
#! For example the two colourings from 
#! <Ref Subsect="EdgeColouredTwistedPolygonalComplex"/> are not isomorphic.
#! @BeginExampleSession
#! gap> IsIsomorphicEdgeColouredPolygonalComplex(colPyr1, colPyr2);
#! false
#! @EndExampleSession
#!
#! @Returns <K>true</K> or <K>false</K>
#! @Arguments colComplex1, colComplex2
DeclareOperation( "IsIsomorphicEdgeColouredPolygonalComplex",
    [IsEdgeColouredPolygonalComplex, IsEdgeColouredPolygonalComplex]);

#! @Description
#! The method <K>EdgeColouredPolygonalComplexIsomorphismRepresentatives</K> 
#! takes a list of edge coloured polygonal
#! complexes and returns a reduced list in which no two entries are 
#! isomorphic.
#!
#! TODO example
#!
#! @Returns a list of edge coloured polygonal complexes
#! @Arguments complexList
DeclareOperation( "EdgeColouredPolygonalComplexIsomorphismRepresentatives", [IsList] );



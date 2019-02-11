#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2019
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

#! @Chapter Homomorphisms
#! @ChapterLabel Morphisms
#!
#! This chapter is concerned with morphisms between different polygonal
#! complexes (morphisms between bend polygonal complexes are not implemented
#! so far).
#!
#! A morphism between two polygonal complexes <M>(V_1,E_1,F_1)</M> and
#! <M>(V_2,E_2,F_2)</M> consists of maps <M>V_1 \to V_2</M>, <M>E_1 \to E_2</M>,
#! and <M>F_1 \to F_2</M>, such that incident elements remain incident.
#!
#! TODO: these maps can be represented as lists, or as mappings (in GAP)
#! TODO: example with constructors for the two
#!
#! TODO a lot of introduction

#idea: polygonal morphisms are maps between sets: vertices+edges+faces, where edges
# are shifted by MaxVertex and faces are shifted by MaxVertex+MaxEdge
DeclareCategory("IsGeneralPolygonalMorphism", IsNonSPGeneralMapping);
# TODO maybe add more specific properties, like IsPolygonalMorphism
# TODO are the names good? Or should we be more specific, e.g. IsPolygonalComplexMorphism, IsPolygonalSurfaceMorphism?


BindGlobal( "GeneralPolygonalMorphismFamily", 
    NewFamily( "GeneralPolygonalMorphismFamily", IsGeneralMapping, IsGeneralPolygonalMorphism ) );

#! @Section Consistent labels for vertices, edges, and faces
#! @SectionLabel Section_VEFLabels
#!
#! We have defined VEF-complexes in a way such that the labels for vertices,
#! edges, and faces do not have to be distinct. While this is more convenient
#! for the casual user, it is sometimes practical to enforce distinct labels.
#! Notably, these cases include morphisms and automorphism groups.
#!
#! The distinct label set is called <K>VEFLabels</K>:
#! @BeginGroup VEFLabels
#! @Description
#! Return the set of VEF-labels for the given VEF-complex. The
#! VEF-labels are a set of labels that distinguish vertices,
#! edges, and faces. It is constructed as follows:
#! * The vertex labels stay the same
#! * The edge labels are shifted upwards by the maximal vertex label
#! * The face labels are shifted upwards by the sum of maximal vertex
#!   label and maximal edge label
#!
#! TODO example for the section
#! @Arguments complex
#! @Returns a set of positive integers
DeclareAttribute( "VEFLabels", IsVEFComplex );
#! @EndGroup


#! @BeginGroup VEFLabelsOfVertices
#! @Description
#! The method <K>VEFLabelOfVertex</K>(<A>complex</A>, <A>vertex</A>) returns the
#! VEF-label of <A>vertex</A>. The NC-version does
#! not check whether the given <A>vertex</A> is a vertex of <A>complex</A>.
#! 
#! The attribute <K>VEFLabelsOfVertices</K>(<A>complex</A>) collects all of those
#! labels in a list that is indexed by the vertex labels, i.e.
#! <K>VEFLabelsOfOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>VEFLabelOfVertex</K>(<A>complex</A>, <A>vertex</A>).
#! All other positions of this list are not bound.
#! 
#! TODO example
#! 
#! @Returns a list of positive integers / a positive integer
#! @Arguments complex
DeclareAttribute( "VEFLabelsOfVertices", IsVEFComplex );
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfVertex", [IsVEFComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfVertexNC", [IsVEFComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup VEFLabelsOfEdges
#! @Description
#! The method <K>VEFLabelOfEdge</K>(<A>complex</A>, <A>edge</A>) returns the
#! VEF-label of <A>edge</A>. The NC-version does
#! not check whether the given <A>edge</A> is an edge of <A>complex</A>.
#! 
#! The attribute <K>VEFLabelsOfEdges</K>(<A>complex</A>) collects all of those
#! labels in a list that is indexed by the edge labels, i.e.
#! <K>VEFLabelsOfOfEdges</K>(<A>complex</A>)[<A>edge</A>] = 
#! <K>VEFLabelOfEdge</K>(<A>complex</A>, <A>edge</A>).
#! All other positions of this list are not bound.
#! 
#! TODO example
#! 
#! @Returns a list of positive integers / a positive integer
#! @Arguments complex
DeclareAttribute( "VEFLabelsOfEdges", IsVEFComplex );
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfEdge", [IsVEFComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfEdgeNC", [IsVEFComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup VEFLabelsOfFaces
#! @Description
#! The method <K>VEFLabelOfFace</K>(<A>complex</A>, <A>face</A>) returns the
#! VEF-label of <A>face</A>. The NC-version does
#! not check whether the given <A>face</A> is a face of <A>complex</A>.
#! 
#! The attribute <K>VEFLabelsOfFaces</K>(<A>complex</A>) collects all of those
#! labels in a list that is indexed by the face labels, i.e.
#! <K>VEFLabelsOfOfFaces</K>(<A>complex</A>)[<A>face</A>] = 
#! <K>VEFLabelOfFace</K>(<A>complex</A>, <A>face</A>).
#! All other positions of this list are not bound.
#! 
#! TODO example
#! 
#! @Returns a list of positive integers / a positive integer
#! @Arguments complex
DeclareAttribute( "VEFLabelsOfFaces", IsVEFComplex );
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfFace", [IsVEFComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfFaceNC", [IsVEFComplex, IsPosInt]);
#! @EndGroup

# TODO
# For a polygonal complex: maps between edges and shiftedEdges (compare graph.gi);
# For a polygonal complex: maps between faces and shiftedFaces (compare graph.gi);
# VertexOfVEFLabel
# EdgeOfVEFLabel
# FaceOfVEFLabel
# I don't like the name VEFLabel..

# How should VertexOfVEFLabel etc. work?
# all return the vertex if possible. How do they react to the following situations?
# a) Input is not in the correct range
# b) Input is not a VEF-label



#! @Section Construction of Morphisms
#! @SectionLabel Morphisms_Construction
#!
#! In this section, we give several different ways to construct morphisms
#! from scratch.

# TODO implement constructor by three lists (images of vertices, edges and faces)

# TODO implement IdentityMapping

# TODO implement InverseMapping/InverseMorphism (for appropriate...)

# TODO overload CompositionMapping2

#! @Section Elementary properties
#! @SectionLabel Morphisms_Properties

# TODO document some of the generic properties like IsInjective, IsSurjective, ...


#! @Section Images and pre-images

#TODO
# implement PreImagesOfVertex
# implement PreImagesOfEdge
# implement PreImagesOfFace


# implement ImageOfVertex (for a total and single-valued ..);
# implement ImageOfEdge (for a total and single-valued ..);
# implement ImageOfFace (for a total and single-valued ..);


#! @Section Components of a morphism

#List of TODO:
# implement VertexMapAsImageList (for single-valued);
# implement EdgeMapAsImageList (for single-valued);
# implement FaceMapAsImageList (for single-valued);

# attribute SourceComplex
# attribute SourceSurface
# attribute RangeComplex
# attribute RangeSurface


# attribute VertexMapping
# attribute EdgeMapping
# attribute FaceMapping


##########################################

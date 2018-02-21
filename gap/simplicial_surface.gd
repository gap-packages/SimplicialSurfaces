#! @DoNotReadRestOfFile


#! @Description
#! Add a vertex into an edge. This only works if there are exactly two
#! faces adjacent to the edge.
#! @Arguments simpSurf, edge
#! @Returns the modified simplicial surface
DeclareOperation( "AddVertexIntoEdge", [IsSimplicialSurface, IsPosInt] );




#! @BeginGroup
#! @Description
#! Return alist names with the following properties:
#! * For each face f the entry names[f] is a list of two integers. The first
#!   integer is the name of the upper face-side, the second one is the name
#!   of the lower face-side (with respect to the local orientation).
#! * all other entries are unbounded.
#! 
#! If a face is given in addition, the corresponding entry of this list is
#! returned. The NC-version does not throw an error if a non-face is given.
#! @Returns a list of lists of integers
#! @Arguments simpSurf
DeclareAttribute( "NamesOfFaces", IsSimplicialSurface );
#! @Arguments simpSurf, face
DeclareOperation( "NamesOfFace", [IsSimplicialSurface, IsPosInt] );
#! @Arguments simpSurf, face
DeclareOperation( "NamesOfFaceNC", [IsSimplicialSurface, IsPosInt] );
#! @EndGroup


#! @Description
#! Return the face of the simplicial surface that has the given name
#! as the name of one of its sides.
#! @Arguments simpSurf, name
#! @Returns a positive integer
DeclareOperation( "FaceByName", [IsSimplicialSurface, IsInt] );


#! @Description
#! Return whether the naming scheme for the faces is the default one,
#! meaning that the upper side of a face f is called f (a positive integer) and
#! the lower side -f (a negative integer).
#! @Arguments simpSurf
DeclareProperty( "IsFaceNamesDefault", IsSimplicialSurface );


###############################################################################
##
##
#!
#! This section contains methods that concern the internal structure of
#! simplicial surfaces. You only have to read this section if you want to
#! understand the underlying implementation better or if you want to develop
#! code that is derived from this.
#!
#! There are three unique features in the implementation of simplicial surfaces
#! that especially concern the definition of specializes simplicial surfaces:
#! - The use of a method selection graph
#! - A general methods to help defining specialized classes
#! - A guide for easier initialization
#!
#! Since the method selection graph is the most salient feature we will cover
#! it first. It derives from a simple observation: If you know either
#! VerticesOfEdges or EdgesOfVertices, you can calculate the other. If you 
#! additionally know either of EdgesOfFaces or FacesOfEdges, you can calculate
#! all six of these attributes. This could have been implemented by a lot of
#! specialized methods but the number of these methods rised exponentially
#! with the number of attributes that are connected.
#!
#! Instead we only implement methods for the ``difficult'' parts (where work
#! has to be done) and delegate the ``easy'' parts (if we can calculate B from
#! A and C from B, we can also calculate C from A) into a method selection
#! graph. If an attribute should be part of the method selection graph (which
#! it only should if you can calculate information inside the method selection
#! graph from this attribute) you have to make two modifications:
#! - There has to be a method to calculate this attribute by the method
#!   selection graph, like
#! @BeginCode TODO Including code does not work if it is read normally
#! InstallMethod( VerticesOfFaces, "for a simplicial surface", 
#!    [ IsSimplicialSurface ],
#!    function( surf )
#!        return ComputeProperty(SIMPLICIAL_METHOD_SELECTION_GRAPH, 
#!                VerticesOfFaces, surf);
#!    end
#! );
#! @EndCode
#! - For each ``difficult'' method there has to be a call that adds this 
#!   possibility into the method selection graph, like
#! @BeginCode
#! AddPropertyIncidence( SIMPLICIAL_METHOD_SELECTION_GRAPH, 
#!	"VerticesOfFaces", ["EdgesOfFaces", "VerticesOfEdges"] );
#! @EndCode
#!
#! 
#! Secondly we guarantee unique methods for specialization. To consider a 
#! specific example, imagine we want to give certain simplicial surfaces an
#! edge colouring. If one simplicial surface may have different edge colourings
#! we can't implement this as an attribute of the simplicial surface. Instead
#! we define a new type for this situation (as a subtype of 
#! SimplicialSurfaceType).
#!
#! The disadvantage of this procedure is that is becomes harder to take a
#! simplicial surface as input and add an edge colouring (type changes are
#! frowned upon in GAP). For this reason we offer a special method that does
#! just that - it copies many attributes of the simplicial surface into an
#! object of the new type.

#! @Description
#! Return the record of alternative names. This attribute is usually set by
#! some constructing operation and encodes information about the construction.
#! 
#! The returned record has one component for each alternative naming scheme.
#! Each of these components can have these three components:
#! Vertices, Edges and Faces.
#! Those are lists, which have an entry for every vertex/edge/face of the
#! simplicial surface. Every other position is unbounded.
#!
#! If this attribute was not set explicitly, it will be an empty record.
#!
#! @Arguments simpSurf
#! @Returns a record
DeclareAttribute( "AlternativeNames", IsSimplicialSurface );




#! @Description
#! Compute the maximal strip cover of a simplicial surface, given 
#! a flag (vertex, edge, face) of the surface.
#! <P/>
#! A strip is a simplicial surface where every vertex has vertex 
#! degree at most 3. Given an identification of a strip face and
#! a face of the simplicial surface, this determines a map from
#! the strip to the surface.
#! <P/>
#! A strip is maximal if no larger strip can extend this map while
#! staying injective (on the faces). This method will compute such
#! a maximal strip assuming that the strip continues along the edges 
#! of the given vertex. First the extension along the given edge
#! will be pursued. If this terminates, the other edge will be pursued.
#! <P/>
#! This method will return a list with two elements:
#! 1) An edge-face-path that corresponds to the strip.
#! 2) The subsurface that is induced by the faces in the strip
#! 
#! @Arguments surf, vertex, edge, face
#! @Returns an edge-face-path and a simplicial surface
DeclareOperation( "MaximalStripEmbedding", 
    [IsSimplicialSurface and IsEdgesLikeSurface and IsTriangleSurface,
    IsPosInt, IsPosInt, IsPosInt] );

#! @Description
#! Determine a strip development of the surface, given a flag.
#! The strip is defined as in <E>MaximalStripEmbedding</E> with the
#! difference that it will be continued until it closes completely
#! i.e. it can't be extended any further in any direction without
#! repeating itself.
#! @Arguments surf, vertex, edge, face
#! @Returns an edge-face-path and a simplicial surface
DeclareOperation( "Geodesic",
    [IsSimplicialSurface and IsEdgesLikeSurface and IsTriangleSurface,
    IsPosInt, IsPosInt, IsPosInt]);
    #TODO IsGeodesic, IsOpenGeodesic, IsClosedGeodesic (also nC)

#! @Description
#! From a geodesic (returned as in Geodesic) construct all maximal
#! strip embeddings.
DeclareOperation( "AllMaximalStripEmbeddings", [IsList] );

#! @Description
#! Return the set of all geodesics. Each geodesic is given in 
#! normal form, defined by:
#! * The smallest face is at position 2
#! * Under the first condition, the third position is minimal
#! * Under the first two conditions (only in the loop-case), the first
#!   position is minimal
#!
#! @Returns a set of edge-face-paths
#! @Arguments surface
DeclareAttribute( "Geodesics", IsSimplicialSurface and IsTriangleSurface
 and IsEdgesLikeSurface);


DeclareAttribute( "GeodesicFlagPermutation", IsSimplicialSurface );


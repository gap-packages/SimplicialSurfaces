

##
##	Declare the wild representation of simplicial surfaces that does nothing.
##
DeclareRepresentation("IsWildSimplicialSurfaceRep", IsSimplicialSurface, [ ] );
##
##	Define a type so we can use Objectify.
##
WildSimplicialSurfaceType := 
	NewType( SimplicialSurfaceFamily, IsWildSimplicialSurfaceRep );



#############################################################################
#############################################################################
##
##						Start of constructors
##
##
##	This constructor takes the following information:
##
##	The list of involutions
##	The list MR-type
##
##	This function constructs a wild simplicial surface from the generators
##	and the MR-type. It also initalises everything necessary.
InstallMethod( WildSimplicialSurfaceNC, "", [ IsList, IsList ],
	function( generators, mrType )
		local simpsurf, namesOfFaces;

		#simpsurf := TODO

		# Set the face names
		SetIsFaceNamesDefault( simpsurf, true );

		return simpsurf;
	end
);
##	This method checks if the generators and the mrType are consistent. It
##	throws error messages if necessary. Then it calls the corresponding 
##	NC-version to initialize the surface.
InstallMethod( WildSimplicialSurface, "", [ IsList, IsList ],
	function( generators, mrType )
		local namesOfFaces, f;

		#TODO check if generators and mrType are consistent

		return WildSimplicialSurfaceNC( generators, mrType );
	end
);
##
##	This constructor takes the following information:
##
##	A simplicial surface which is an actual surface
##	The list of involutions
##
##	Function to enrich a SimplicialSurface with generators
InstallMethod( WildSimplicialSurfaceNC, "",
	[ IsSimplicialSurface and IsActualSurface, IsList ],
	function( simpsurf, generators )
		local wild;

		wild := ObjectifySimplicialSurface( WildSimplicialSurfaceType, rec());
		SetGeneratorsAttributeOfWildSimplicialSurface( wild, generators );

		return wild;
	end
);
##	If it is not known that we have an actual surface, we have to check
RedispatchOnCondition( WildSimplicialSurfaceNC, true,
	[IsSimplicialSurface, IsList], [IsActualSurface,], 0 );
##	This method checks if the generators match the simplicial surface, then
##	enriches it with generators
InstallMethod( WildSimplicialSurface, "",
	[ IsSimplicialSurface and IsActualSurface, IsList ],
	function( simpsurf, generators )
		#TODO check if the generators match the simplicial surface
		return WildSimplicialSurfaceNC( simpsurf, generators);
	end
);
##	If it is not known that we have an actual surface, we have to check
RedispatchOnCondition( WildSimplicialSurface, true,
	[IsSimplicialSurface, IsList], [IsActualSurface,], 0 );
##
##							End of constructors
##
#############################################################################
#############################################################################


############################################################################
##			Write wrapper methods for attributes
##
InstallMethod( Generators, "for wild simplicial surfaces",
	[IsWildSimplicialSurface],
	function( surface )
		return GeneratorsAttributeOfWildSimplicialSurface( surface );
	end
);

#############################################################################
#############################################################################
##
##		Start of implementation for basic methods of SimplicialSurface
##
##	These methods are dependent on the specific representation (unless they
##	are not - this has to be discussed with Alice: TODO).
##

#! @Description
#! Returns the numbers of the vertices as a set. This is a basic method.
#! @Arguments a simplicial surface
#! @Returns a dense list of integers
InstallMethod( VerticesAttributeOfSimplicialSurface, 
	"for wild simplicial surfaces", [IsWildSimplicialSurfaceRep],
	function( simpsurf )
		#TODO
	end
);

#! @Description
#! Returns the numbers of the edges as a set. This is a basic method.
#! @Arguments a simplicial surface
#! @Returns a dense list of integers
InstallMethod( EdgesAttributeOfSimplicialSurface, 
	"for wild simplicial surfaces", [IsWildSimplicialSurfaceRep],
	function( simpsurf )
		#TODO
	end
);

#! @Description
#! Returns the numbers of the faces as a set. This is a basic method.
#! @Arguments a simplicial surface
#! @Returns a dense list of integers
InstallMethod( FacesAttributeOfSimplicialSurface, 
	"for wild simplicial surfaces", [IsWildSimplicialSurfaceRep],
	function( simpsurf )
		#TODO
	end
);

#!	@Description
#!	Return the vertices in terms of the edges. Return a list
#!	with holes and at the position of each vertex-number is a set of
#!	all edges that are incident to that vertex. All other positions are
#!	unbounded.
#!	Either this method or EdgesByVertices is basic.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
InstallMethod( VerticesByEdgesAttributeOfSimplicialSurface, 
	"for wild simplicial surfaces", [IsWildSimplicialSurfaceRep],
	function( simpsurf )
		#TODO
	end
);

#!	@Description
#!	Return the faces in terms of the edges. Return a list
#!	with holes and at the position of each face-number is a set of
#!	all edges that are incident to that face. All other positions are
#!	unbounded.
#!	Either this method or EdgesByFaces is basic.
#!	@Returns a list of lists of integers
#!	@Arguments a simplicial surface object simpsurf
InstallMethod( FacesByEdgesAttributeOfSimplicialSurface, 
	"for wild simplicial surfaces", [IsWildSimplicialSurfaceRep],
	function( simpsurf )
		#TODO
	end
);

#!  @Description
#!	Return a list of permutations where at the position of each face-number
#!	there is a cycle of all vertices that are incident to this face. This
#!	cycle represents the local orientation of this face. All other positions
#!	are unbounded.
#!	This method is basic.
#!  @Returns a list of permutations
#!  @Arguments a simplicial surface object simpsurf
InstallMethod( LocalOrientationAttributeOfSimplicialSurface, 
	"for wild simplicial surfaces", [IsWildSimplicialSurfaceRep],
	function( simpsurf )
		#TODO
	end
);

##
##		End of implementation for basic methods of SimplicialSurface
##
##
#############################################################################
#############################################################################


#############################################################################
##
#! @Description
#! Return the group that is generated by the generators of the wild simplicial
#! surface.
#! @Arguments a wild simplicial surface
#! @Returns a group
#!
InstallMethod( GeneratedGroupAttributeOfWildSimplicialSurface, 
	"for a wild simplicial surface", [ IsWildSimplicialSurface ],
	function(simpsurf)
		return Group( Generators(simpsurf) );
	end
);
InstallMethod( GeneratedGroup, "for a wild simplicial surface",
	[ IsWildSimplicialSurface ],
	function(simpsurf)
		return GeneratedGroupAttributeOfWildSimplicialSurface( simpsurf );
	end
);

#############################################################################
##
#! @Description Given a wild coloured simplicial surface <simpsurf>, this
#!  function determines the vertex group of the simplicial surface.
#!  The vertex group of the simplicial surface <simpsurf> is defined to be
#!  $F_3/R$, where $F_3$ is the free group on three generators and $R$ is 
#!  the set of relations given by the vertex defining paths.
#!  @Returns finitely presented group.
#!
InstallMethod( VertexGroupAttributeOfWildSimplicialSurface, 
	"for a wild simplicial surface", [ IsWildSimplicialSurface ],
	function(simpsurf)
		#TODO
	end
);
InstallMethod( VertexGroup, "for a wild simplicial surface",
	[IsWildSimplicialSurface],
	function( simpsurf )
		return VertexGroupAttributeOfWildSimplicialSurface( simpsurf );
	end
);

#############################################################################
##
#! @Description Given a wild coloured simplicial surface <simpsurf>, this
#!  function determines the mr-type of each of the edges of <simpsurf>.
#!  The mr-type of an edge of <simpsurf> is either "m" (for mirror) or 
#!  "r" (for rotation). It is defined as followed. 
#!  Suppose the edge  $e$ is incident to the vertices $v_1$ and 
#!  $v_2$ and to the two faces $F$ and $F'$. Let $x$ and $y$ be the edges of
#!  incident  incident to $F$ and $F'$ and to the same vertex $v_1$, say.
#!  Then $e$ is of type $m$ if both $x$ and $y$ have the same colour, and $e$
#!  is of type $r$ if $x$ and $y$ are different. As we assume the surface to
#!  be wild coloured, this means that the colours of the other edges incident 
#!  to $e$ and both faces $F$ and $F'$ are then also determined. As the # $'$
#!  edges of the simplicial surface are pairs of points, the mr-type of 
#!  the simplicial surface <simpsurf> can be encoded as a list of length 3. 
#!   Each of the
#!  entries is in turn  a list encoding the mr-type of all edges of a 
#!  certain colour. Suppose that mrtype[1] is the list encoding the mr-type
#!  of the red edges. Then mrtype[1][i] = 0 if the mr-type of the red edge
#!  incident to the vertex i is unknown, mrtype[1][i] = 1 if the mr-type of 
#!  the red edge incident to the vertex i is "m", and mrtype[1][i] = 2 if 
#!  the mr-type of the red edge incident to the vertex i is "r". 
#!  @Returns a list of three lists, each of which contains the 
#!  entries 0, 1 or 2.
#!  @Arguments <simpsurf>, a simplicial surface object as created 
#!  by WildSimplicialSurface
#!  @BeginExample
#! MrType(tetra);
#! @EndExample
#!
InstallMethod( MrTypeAttributeOfWildSimplicialSurface, 
	"for a wild simplicial surface", [ IsWildSimplicialSurface ],
	function(simpsurf)
		#TODO
	end
);
InstallMethod( MrType, "for a wild simplicial surface",
	[IsWildSimplicialSurface],
	function( simpsurf )
		return MrTypeAttributeOfWildSimplicialSurface( simpsurf );
	end
);
InstallMethod( MRType, "for a wild simplicial surface",
	[IsWildSimplicialSurface],
	function( simpsurf )
		return MrTypeAttributeOfWildSimplicialSurface( simpsurf );
	end
);

#!	@Description
#!   The function SixFoldCover takes as input a generic description of
#!   a simplicial surface.  The six fold cover of a simplicial surface is
#!   the following surface.
#!   If f is a face of the original face with edge numbers e_a, e_b and
#!   e_c, then the face is covered by the six faces of the form
#!   (f, e1, e2, e3), for which {e1, e2, e3}  = {e_a, e_b, e_c}.
#!   See Proposition 3.XX in the paper.
#!   @Arguments
#!
#!   If the optional argument mrtype is given, it has to be a list of length 
#!   3 and each entry has to be  $1$, or $2$. In this case the six fold cover 
#!   will treat the position $i$ for $i\in\{1,2,3\}$ of the three
#!   edges around a faces either as a   reflection (mirror), if the entry 
#!   in position $i$ of mrtype is 1, or as a rotation, if the entry in 
#!   position $i$ is 2. That is, the cover surface is generated by three
#!   transpositions $\sigma_i$ for $i=1,2,3$. For $i=1$, suppose $f$ and 
#!   $f'$ are faces of the surface surf such that the edges of $f$ are 
#!   $e_1, e_2$  and $e_3$ and the edges of $f'$ are  $e_1, e_a, e_b$ are 
#!   the edges $e_1, e_2$ and $e_a$ intersect in a common vertex and 
#!   the edges $e_1, e_3$ and $e_b$ intersect in a common vertex.
#!   For $i=1$ and  mrtype of position $1$ being  mirror (i.e. $1$), then 
#!   $$\sigma_1(f,e_1,e_2,e_3) = (f', e_1, e_a, e_b),$$ whereas if the 
#!   mrtype of position $1$ is a reflection (i.e. $2$), then 
#!   $$\sigma_1(f,e_1,e_2,e_3) = (f', e_1, e_b, e_a).$$ The definition
#!   of $\sigma_2$ and $\sigma_3$ are analogous, with $e_2$, respectively
#!   $e_3$ taking the role of the common edge $e_1.$
#!
#!   
#!   If the optional argument mredges is given, and mredges is a list of 
#!   length equal to the number of edges of the surface **surf** and an
#!   entry for an edge e is either 1 or 2. If the entry is 1 then 
#!   the six fold cover will treat the edge as a reflection (mirror) and 
#!   if the entry is 2  then the edge is treated as a rotation. 
#!
#!   The six fold cover is always a wild colourable simplicial surface.
#!   @Returns a wild coloured simplicial surface
#!   @Arguments surface, mrtype, bool
#!   if bool is true or not given, the mrtype specifies the behaviour of 
#!   the $\sigma_i$, if bool is false, the mrtype specifies the behaviour
#!   of the edges.
InstallMethod( SixFoldCover, "for a simplicial surface",
	[IsSimplicialSurface, IsList],
	function(simpsurf, mrtype)
		#TODO
	end
);
InstallOtherMethod( SixFoldCover, "for a simplicial surface",
	[IsSimplicialSurface],
	function( simpsurf )
		#TODO, probably call the method above
	end
);


############################################################################
############################################################################
##
##			Start of more specialized methods from SimplicialSurface
##

#!	@Description
#!	This function checks if a wild simplicial surface is connected.
#!	@Returns true if connected, false otherwise
#!	@Arguments a wild simplicial surface object simpsurf
#!
InstallMethod( IsConnected, "for a wild simplicial surface",
	[IsWildSimplicialSurface],
	function(simpsurf)
		return Length(Orbits(GeneratedGroup(simpsurf), Faces(simpsurf)))=1;
	end
);

#!  @Description
#!  This function decides whether the wild simplicial surface
#!  <simpsurf> is orientable.
#!  @Returns true if the surface is orientable and false else.
#!  @Arguments <simpsurf> a wild simplicial surface
#!
InstallMethod( IsOrientable, "for a wild simplicial surface",
	[IsWildSimplicialSurface],
	function(simpsurf)
		#TODO
	end
);

#!	@Description
#!	This function removes all ears of the wild simplicial surface and returns
#!	the resulting surface.
#!	@Arguments a wild simplicial surface object simpsurf
#!	@Returns a simplicial surface object
InstallMethod( SnippOffEars, "for a wild simplicial surface",
	[IsWildSimplicialSurface],
	function(simpsurf)
		#TODO
	end
);

##
##			End of more specialized methods from SimplicialSurface
##
############################################################################
############################################################################

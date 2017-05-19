#
# Bicomplexes: Bicomplexes for Abelian categories
#
# Declarations
#

#! @Chapter Bicomplexes

# our info class:
DeclareInfoClass( "InfoBicomplexes" );
SetInfoLevel( InfoBicomplexes, 1 );

####################################
#
#! @Section Categories
#
####################################

#! @Description
#!  The &GAP; category of cells in a &CAP; category of bicomplexes.
DeclareCategory( "IsCapCategoryBicomplexCell",
        IsCapCategoryCell and
        IsAttributeStoringRep );

#! @Description
#!  The &GAP; category of bicomplex objects in a &CAP; category of bicomplexes.
DeclareCategory( "IsCapCategoryBicomplexObject",
        IsCapCategoryBicomplexCell and
        IsCapCategoryObject );

#! @Description
#!  The &GAP; category of homological bicomplex objects in a &CAP; category of bicomplexes.
DeclareCategory( "IsCapCategoryHomologicalBicomplexObject",
                  IsCapCategoryBicomplexObject );

#! @Description
#!  The &GAP; category of cohomological bicomplex objects in a &CAP; category of bicomplexes.
DeclareCategory( "IsCapCategoryCohomologicalBicomplexObject",
                  IsCapCategoryBicomplexObject );

#! @Description
#!  The &GAP; category of bicomplex morphisms in a &CAP; category of bicomplexes.
DeclareCategory( "IsCapCategoryBicomplexMorphism",
        IsCapCategoryBicomplexCell and
        IsCapCategoryMorphism );

#! @Description
#!  The &GAP; category of homological bicomplex morphisms in a &CAP; category of bicomplexes.
DeclareCategory( "IsCapCategoryHomologicalBicomplexMorphism",
                  IsCapCategoryBicomplexMorphism );

#! @Description
#!  The &GAP; category of cohomological bicomplex morphisms in a &CAP; category of bicomplexes.
DeclareCategory( "IsCapCategoryCohomologicalBicomplexMorphism",
                  IsCapCategoryBicomplexMorphism );

####################################
#
#! @Section Technical stuff
#
####################################

# a central place for configurations:
DeclareGlobalVariable( "CATEGORIES_OF_BICOMPLEXES" );

DeclareGlobalVariable( "PROPAGATION_LIST_FOR_BICOMPLEX_MORPHISMS" );

DeclareGlobalFunction( "INSTALL_TODO_LIST_FOR_BICOMPLEX_MORPHISMS" );

####################################
#
#! @Section Constructors
#
####################################

#! @Description
#!  Return the bicomplex associated to the complex of complexes <A>cx</A>.
#! @Arguments cx
#! @Returns a &CAP; object
#! @Group AssociatedBicomplex_obj
DeclareAttribute( "AssociatedBicomplex",
        IsChainOrCochainComplex );

#! @Description
#!  Return the morphism of bicomplexes associated to the chain morphism
#!  between two complexes of complexes <A>mu</A>.
#! @Arguments mu
#! @Returns a &CAP; morphism
#! @Group AssociatedBicomplex_mor
DeclareAttribute( "AssociatedBicomplex",
        IsChainOrCochainMorphism );

#! @Description
#!  
#! @Arguments F, name
#! @Returns a &CAP; functor
#! @Group AssociatedBicomplex_fun
DeclareOperation( "AssociatedBicomplex",
        [ IsCapFunctor, IsString ] );

#! @Description
#!  
#! @Arguments F
#! @Group AssociatedBicomplex_fun
DeclareAttribute( "AssociatedBicomplex",
        IsCapFunctor );

#! @Description
#!  
#! @Arguments eta, name
#! @Returns a &CAP; natural transformation
#! @Group AssociatedBicomplex_ntr
DeclareOperation( "AssociatedBicomplex",
        [ IsCapNaturalTransformation, IsString ] );

#! @Description
#!  
#! @Arguments eta
#! @Group AssociatedBicomplex_ntr
DeclareAttribute( "AssociatedBicomplex",
        IsCapNaturalTransformation );

#! @Description
#!  Return the category of bicomplexes of the Abelian category <A>A</A>
#!  of complexes of complexes.
#! @Arguments A
#! @Returns a &CAP; category
#! @Group AsCategoryOfBicomplexes
DeclareAttribute( "AsCategoryOfBicomplexes",
        IsCapCategory );

####################################
#
#! @Section Attributes
#
####################################

#! @Description
#!  The category of double complexes underlying the category of bicomplexes <A>Bicx</A>.
#! @Arguments Bicx
DeclareAttribute( "UnderlyingCategoryOfComplexesOfComplexes",
        IsCapCategory );

#! @Description
#!  The complex of complexes underlying the bicomplex <A>B</A>.
#! @Arguments B
DeclareAttribute( "UnderlyingComplexOfComplexes",
        IsObject );

####################################
#
#! @Section Operations
#
####################################

DeclareOperation( "HomologicalBicomplex", [ IsChainComplex ] );
DeclareOperation( "HomologicalBicomplex", [ IsCapCategory, IsZList, IsZList ] );
DeclareOperation( "HomologicalBicomplex", [ IsCapCategory, IsFunction, IsFunction ] );

DeclareOperation( "CohomologicalBicomplex", [ IsCochainComplex ] );
DeclareOperation( "CohomologicalBicomplex", [ IsCapCategory, IsZList, IsZList ] );
DeclareOperation( "CohomologicalBicomplex", [ IsCapCategory, IsFunction, IsFunction ] );

DeclareOperation( "ObjectAt", [ IsCapCategoryBicomplexObject, IsInt, IsInt ] );
DeclareOperation( "HorizontalDifferentialAt", [ IsCapCategoryBicomplexObject, IsInt, IsInt ] );
DeclareOperation( "VerticalDifferentialAt", [ IsCapCategoryBicomplexObject, IsInt, IsInt ] );
DeclareOperation( "MorphismAt", [ IsCapCategoryBicomplexMorphism, IsInt, IsInt ] );

KeyDependentOperation( "RowAsComplex", IsCapCategoryBicomplexObject, IsInt, ReturnTrue );
KeyDependentOperation( "ColumnAsComplex", IsCapCategoryBicomplexObject, IsInt, ReturnTrue );

# Attributes to maitain bounds

DeclareAttribute( "Left_Bound",
        IsCapCategoryBicomplexCell );

DeclareAttribute( "Right_Bound",
        IsCapCategoryBicomplexCell );

DeclareAttribute( "Above_Bound",
        IsCapCategoryBicomplexCell );

DeclareAttribute( "Below_Bound",
        IsCapCategoryBicomplexCell );

DeclareAttribute( "TotalComplex", IsCapCategoryBicomplexObject );

###################################
#
#  Global functions 
#
###################################

DeclareGlobalFunction( "TODOLIST_TO_PUSH_BOUNDS_TO_BICOMPLEXES" );
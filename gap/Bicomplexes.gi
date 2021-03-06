#
# Bicomplexes: Bicomplexes for Abelian categories
#
# Implementations
#

####################################
#
# representations:
#
####################################

# Cells
DeclareRepresentation( "IsCapCategoryBicomplexCellRep",
        IsCapCategoryBicomplexCell,
        [ ] );

# Objects
DeclareRepresentation( "IsCapCategoryBicomplexObjectRep",
        IsCapCategoryBicomplexObject,
        [ ] );

DeclareRepresentation( "IsCapCategoryHomologicalBicomplexObjectRep",
        IsCapCategoryHomologicalBicomplexObject and IsCapCategoryBicomplexObjectRep,
        [ ] );

DeclareRepresentation( "IsCapCategoryCohomologicalBicomplexObjectRep",
        IsCapCategoryCohomologicalBicomplexObject and IsCapCategoryBicomplexObjectRep,
        [ ] );

# Morphisms
DeclareRepresentation( "IsCapCategoryBicomplexMorphismRep",
        IsCapCategoryBicomplexMorphism,
        [ ] );

DeclareRepresentation( "IsCapCategoryHomologicalBicomplexMorphismRep",
        IsCapCategoryHomologicalBicomplexMorphism and IsCapCategoryBicomplexMorphismRep,
        [ ] );

DeclareRepresentation( "IsCapCategoryCohomologicalBicomplexMorphismRep",
        IsCapCategoryCohomologicalBicomplexMorphism and IsCapCategoryBicomplexMorphismRep,
        [ ] );

####################################
#
# families and types:
#
####################################

# new families:
BindGlobal( "TheFamilyOfBicomplexObjects",
        NewFamily( "TheFamilyOfBicomplexObjects" ) );

BindGlobal( "TheFamilyOfHomologicalBicomplexObjects",
        NewFamily( "TheFamilyOfHomologicalBicomplexObjects" ) );

BindGlobal( "TheFamilyOfCohomologicalBicomplexObjects",
        NewFamily( "TheFamilyOfCohomologicalBicomplexObjects" ) );

BindGlobal( "TheFamilyOfBicomplexMorphisms",
        NewFamily( "TheFamilyOfBicomplexMorphisms" ) );

BindGlobal( "TheFamilyOfHomologicalBicomplexMorphisms",
        NewFamily( "TheFamilyOfHomologicalBicomplexMorphisms" ) );

BindGlobal( "TheFamilyOfCohomologicalBicomplexMorphisms",
        NewFamily( "TheFamilyOfCohomologicalBicomplexMorphisms" ) );


# new types:
BindGlobal( "TheTypeBicomplexObject",
        NewType( TheFamilyOfBicomplexObjects,
                IsCapCategoryBicomplexObjectRep ) );

BindGlobal( "TheTypeHomologicalBicomplexObject",
        NewType( TheFamilyOfHomologicalBicomplexObjects,
                IsCapCategoryHomologicalBicomplexObjectRep ) );

BindGlobal( "TheTypeCohomologicalBicomplexObject",
        NewType( TheFamilyOfCohomologicalBicomplexObjects,
                IsCapCategoryCohomologicalBicomplexObjectRep ) );

BindGlobal( "TheTypeBicomplexMorphism",
        NewType( TheFamilyOfBicomplexMorphisms,
                IsCapCategoryBicomplexMorphismRep ) );

BindGlobal( "TheTypeHomologicalBicomplexMorphism",
        NewType( TheFamilyOfHomologicalBicomplexMorphisms,
                IsCapCategoryHomologicalBicomplexMorphismRep ) );

BindGlobal( "TheTypeCohomologicalBicomplexMorphism",
        NewType( TheFamilyOfCohomologicalBicomplexMorphisms,
                IsCapCategoryCohomologicalBicomplexMorphismRep ) );

####################################
#
# methods for attributes:
#
####################################

##
InstallMethod( UnderlyingCapCategoryCell,
        "for a list",
        [ IsList ],

  L -> List( L, UnderlyingCapCategoryCell ) );

##
InstallMethod( UnderlyingCapCategoryCell,
        "fallback method for an arbitrary GAP object",
        [ IsObject ],

  IdFunc );

####################################
#
# methods for constructors:
#
####################################

##
InstallMethod( AsCategoryOfBicomplexes,
        [ IsCapCategory ],

  function( C )
    local name, BC, recnames, func, pos, create_func_bool,
          create_func_object0, create_func_object, create_func_morphism,
          create_func_universal_morphism, info, add;

    if HasName( C ) then
        name := Concatenation( Name( C ), " as bicomplexes" );
        BC := CreateCapCategory( name );
    else
        BC := CreateCapCategory( );
    fi;

    ## TODO: should be replaced later by a sync process
    if HasIsAbelianCategory( C ) then
        SetIsAbelianCategory( BC, IsAbelianCategory( C ) );
    fi;

    SetUnderlyingCategoryOfComplexesOfComplexes( BC, C );

    for name in ListKnownCategoricalProperties( C ) do
        name := ValueGlobal( name );
        Setter( name )( BC, true );
    od;

    ## TODO: remove `Primitively' for performance?
    recnames := ShallowCopy( ListPrimitivelyInstalledOperationsOfCategory( C ) );

    create_func_bool :=
      function( name )
        local oper;

        oper := ValueGlobal( name );

        return
          function( arg )
            local eval_arg;

            eval_arg := UnderlyingCapCategoryCell( arg );

            return CallFuncList( oper, eval_arg );

          end;

        end;

    ## e.g., ZeroObject
    create_func_object0 :=
      function( name )
        local oper;

        oper := ValueGlobal( name );

        return
          function( )
            local result;

            result := oper( C );

            return AssociatedBicomplexObject( result );

          end;

      end;

    ## e.g., DirectSum
    create_func_object :=
      function( name )
        local oper;

        oper := ValueGlobal( name );

        return ## a constructor for universal objects
          function( arg )
            local eval_arg, result;

            eval_arg := List( arg, UnderlyingCapCategoryCell );

            result := CallFuncList( oper, eval_arg );

            return AssociatedBicomplexObject( result );

          end;

      end;

    ## e.g., AdditionForMorphisms
    create_func_morphism :=
      function( name )
        local oper;

        oper := ValueGlobal( name );

        return
          function( arg )
            local eval_arg, result;

            eval_arg := List( arg, UnderlyingCapCategoryCell );

            result := CallFuncList( oper, eval_arg );

            return AssociatedBicomplexMorphism( result );

          end;

      end;

    ## e.g., CokernelColiftWithGivenCokernelObject
    create_func_universal_morphism :=
      function( name )
        local oper;

        oper := ValueGlobal( name );

        return
          function( arg )
            local eval_arg, result;

            eval_arg := List( arg, UnderlyingCapCategoryCell );

            result := CallFuncList( oper, eval_arg );

            return AssociatedBicomplexMorphism( result );

          end;

      end;

    for name in recnames do

        info := CAP_INTERNAL_METHOD_NAME_RECORD.(name);

        if info.return_type = "bool" then
            func := create_func_bool( name );
        elif info.return_type = "object" and info.filter_list = [ "category" ] then
            func := create_func_object0( name );
        elif info.return_type = "object" then
            func := create_func_object( name );
        elif info.return_type = "morphism" or info.return_type = "morphism_or_fail" then
            if not IsBound( info.io_type ) then
                ## if there is no io_type we cannot do anything
                continue;
            elif IsList( info.with_given_without_given_name_pair ) and
              name = info.with_given_without_given_name_pair[1] then
                ## do not install universal morphisms but their
                ## with-given-universal-object counterpart
                Add( recnames, info.with_given_without_given_name_pair[2] );
                continue;
            elif IsBound( info.universal_object ) and
              Position( recnames, info.universal_object ) = fail then
                ## add the corresponding universal object
                ## at the end of the list for its method to be installed
                Add( recnames, info.universal_object );
            fi;

            if IsList( info.with_given_without_given_name_pair ) then
                func := create_func_universal_morphism( name );
            else
                func := create_func_morphism( name );
            fi;
        else
            Error( "unkown return type of the operation ", name );
        fi;

        add := ValueGlobal( Concatenation( "Add", name ) );

        add( BC, func );

    od;

    Finalize( BC );

    IdentityFunctor( BC )!.UnderlyingFunctor := IdentityFunctor( C );

    return BC;

end );

##
InstallMethod( AssociatedBicomplexObject,
               [ IsChainOrCochainComplex ],
   function( C )
   local B, cat, type;

   cat := CapCategory( C );

   if IsChainComplexCategory( cat ) and IsChainComplexCategory( UnderlyingCategory( cat ) ) then
      type := TheTypeHomologicalBicomplexObject;
   elif IsCochainComplexCategory( cat ) and IsCochainComplexCategory( UnderlyingCategory( cat ) ) then
      type := TheTypeCohomologicalBicomplexObject;
   else
      Error( "not yet implemented" );
   fi;

   B := rec( IndicesOfTotalComplex := rec( ) );

   ObjectifyWithAttributes(
            B, type,
            UnderlyingCapCategoryCell, C
            );

   cat := AsCategoryOfBicomplexes( cat );

   Add( cat, B );

   TODOLIST_TO_PUSH_BOUNDS_TO_BICOMPLEXES( C, B );

   return B;

end );

##
InstallMethod( HomologicalBicomplex,
               [ IsChainComplex ],
    AssociatedBicomplexObject );

InstallMethod( CohomologicalBicomplex,
               [ IsCochainComplex ],
    AssociatedBicomplexObject );

##
InstallMethod( HomologicalBicomplex,
               [ IsCapCategory, IsZList, IsZList ],
    function( A, h, v )
    local chains_cat, C;

    chains_cat := ChainComplexCategory( A );
    C := ChainComplex( chains_cat, 
        MapLazy( IntegersList,
            function( i )
            local source, range, diff;
            if i mod 2 = 0 then
               source := ChainComplex( A, MapLazy( IntegersList, j -> v[ i ][ j ], 1 ) );
               range := ChainComplex( A, MapLazy( IntegersList, j-> AdditiveInverseForMorphisms( v[ i - 1 ][ j ] ), 1 ) );
            else
               source := ChainComplex( A, MapLazy( IntegersList, j -> AdditiveInverseForMorphisms( v[ i ][ j ] ), 1 ) );
               range := ChainComplex( A, MapLazy( IntegersList, j-> v[ i - 1 ][ j ], 1 ) );
            fi;
            diff := MapLazy( IntegersList, j -> h[ j ][ i ], 1 );
            return ChainMorphism( source, range, diff );
            end, 1 ) );
   return HomologicalBicomplex( C );
end );

##
InstallMethod( CohomologicalBicomplex,
               [ IsCapCategory, IsZList, IsZList ],
    function( A, h, v )
    local cochains_cat, C;

    cochains_cat := CochainComplexCategory( A );
    C := CochainComplex( cochains_cat, 
        MapLazy( IntegersList,
        function( i )
        local source, range, diff;
        if i mod 2 = 0 then
           source := CochainComplex( A, MapLazy( IntegersList, j -> v[ i ][ j ], 1 ) );
           range := CochainComplex( A, MapLazy( IntegersList, j-> AdditiveInverseForMorphisms( v[ i + 1 ][ j ] ), 1 ) );
        else
           source := CochainComplex( A, MapLazy( IntegersList, j -> AdditiveInverseForMorphisms( v[ i ][ j ] ), 1 ) );
           range := CochainComplex( A, MapLazy( IntegersList, j-> v[ i + 1 ][ j ], 1 ) );
        fi;
        diff := MapLazy( IntegersList, j -> h[ j ][ i ], 1 );
        return CochainMorphism( source, range, diff );
        end, 1 ) );
   return CohomologicalBicomplex( C );
end );

##
InstallMethod( HomologicalBicomplex,
               [ IsCapCategory, IsFunction, IsFunction ],
    function( A, H, V )
    local h, v;

    h := MapLazy( IntegersList, j -> MapLazy( IntegersList, i -> H( i, j ), 1 ), 1 );

    v := MapLazy( IntegersList, i -> MapLazy( IntegersList, j -> V( i, j ), 1 ), 1 );

    return HomologicalBicomplex( A, h, v );

end );

##
InstallMethod( CohomologicalBicomplex,
               [ IsCapCategory, IsFunction, IsFunction ],
    function( A, H, V )
    local h, v;

    h := MapLazy( IntegersList, j -> MapLazy( IntegersList, i -> H( i, j ), 1 ), 1 );

    v := MapLazy( IntegersList, i -> MapLazy( IntegersList, j -> V( i, j ), 1 ), 1 );

    return CohomologicalBicomplex( A, h, v );

end );


##
InstallOtherMethod( ObjectAt,
               [ IsCapCategoryBicomplexObject, IsInt, IsInt ],
    function( B, i, j )
       return UnderlyingCapCategoryCell( B )[ i ][ j ];
end );

##
InstallMethod( HorizontalDifferentialAt,
               [ IsCapCategoryBicomplexObject, IsInt, IsInt ],
    function( B, i, j )
    local d;
    d := UnderlyingCapCategoryCell( B )^i;
    return d[ j ];
end );

##
DeclareProperty( "IsBicomplexCategoryWithCommutativeSquares", IsCapCategory );

InstallMethod( VerticalDifferentialAt,
               [ IsCapCategoryBicomplexObject, IsInt, IsInt ],
    function( B, i, j )
    local cat;
    cat := CapCategory( B );

    if i mod 2 = 0 then
       return UnderlyingCapCategoryCell( B )[ i ]^j;
    fi;
    if HasIsBicomplexCategoryWithCommutativeSquares( cat ) and 
        IsBicomplexCategoryWithCommutativeSquares( cat ) then
        return UnderlyingCapCategoryCell( B )[ i ]^j;
    fi;
    Info( InfoBicomplexes, 2, "Additive-Inverse-For-Morphisms is called when computing vertical morphism" );
    return AdditiveInverseForMorphisms( UnderlyingCapCategoryCell( B )[ i ]^j );
end );

##
InstallMethod( VerticalCohomologyAt,
        [ IsCapCategoryBicomplexObject and IsCapCategoryCohomologicalBicomplexObject, IsInt, IsInt ],
    function( B, i, j )
    local col;
    col := ColumnAsComplex( B, i );
    return CohomologyAt( col, j );
end );

InstallMethod( GeneralizedProjectionOntoVerticalCohomologyAt, [ IsCapCategoryCohomologicalBicomplexObject, IsInt, IsInt ],
    function( B, i, j )
    local col;
    col := ColumnAsComplex( B, i );
    return GeneralizedProjectionOntoCohomologyAt( col, j );
end );

InstallMethod( GeneralizedEmbeddingOfVerticalCohomologyAt, [ IsCapCategoryCohomologicalBicomplexObject, IsInt, IsInt ],
    function( B, i, j )
    local col;
    col := ColumnAsComplex( B, i );
    return GeneralizedEmbeddingOfCohomologyAt( col, j );
end );

InstallMethod( HorizontalCohomologyAt,
        [ IsCapCategoryBicomplexObject and IsCapCategoryCohomologicalBicomplexObject, IsInt, IsInt ],
    function( B, i, j )
    local row;
    row := RowAsComplex( B, j );
    return CohomologyAt( row, i );
end );


InstallMethod( GeneralizedProjectionOntoHorizontalCohomologyAt, [ IsCapCategoryCohomologicalBicomplexObject, IsInt, IsInt ],
    function( B, i, j )
    local row;
    row := RowAsComplex( B, j );
    return GeneralizedProjectionOntoCohomologyAt( row, i );
end );

InstallMethod( GeneralizedEmbeddingOfHorizontalCohomologyAt, [ IsCapCategoryCohomologicalBicomplexObject, IsInt, IsInt ],
    function( B, i, j )
    local row;
    row := RowAsComplex( B, j );
    return GeneralizedEmbeddingOfCohomologyAt( row, i );
end );


##
InstallMethod( VerticalHomologyAt,
        [ IsCapCategoryBicomplexObject and IsCapCategoryHomologicalBicomplexObject, IsInt, IsInt ],
    function( B, i, j )
    local col;
    col := ColumnAsComplex( B, i );
    return HomologyAt( col, j );
end );

InstallMethod( GeneralizedProjectionOntoVerticalHomologyAt, [ IsCapCategoryHomologicalBicomplexObject, IsInt, IsInt ],
    function( B, i, j )
    local col;
    col := ColumnAsComplex( B, i );
    return GeneralizedProjectionOntoHomologyAt( col, j );
end );

InstallMethod( GeneralizedEmbeddingOfVerticalHomologyAt, [ IsCapCategoryHomologicalBicomplexObject, IsInt, IsInt ],
    function( B, i, j )
    local col;
    col := ColumnAsComplex( B, i );
    return GeneralizedEmbeddingOfHomologyAt( col, j );
end );

##
InstallMethod( HorizontalHomologyAt,
        [ IsCapCategoryBicomplexObject and IsCapCategoryHomologicalBicomplexObject, IsInt, IsInt ],
    function( B, i, j )
    local row;
    row := RowAsComplex( B, j );
    return HomologyAt( row, i );
end );

## Methods for Generalized Morphisms

InstallMethod( GeneralizedProjectionOntoHorizontalHomologyAt, [ IsCapCategoryHomologicalBicomplexObject, IsInt, IsInt ],
    function( B, i, j )
    local row;
    row := RowAsComplex( B, j );
    return GeneralizedProjectionOntoHomologyAt( row, i );
end );

InstallMethod( GeneralizedEmbeddingOfHorizontalHomologyAt, [ IsCapCategoryHomologicalBicomplexObject, IsInt, IsInt ],
    function( B, i, j )
    local row;
    row := RowAsComplex( B, j );
    return GeneralizedEmbeddingOfHomologyAt( row, i );
end );

##
InstallMethod( RowAsComplexOp,
               [ IsCapCategoryBicomplexObject, IsInt ],
    function( B, j )
    local C, A;
    C := UnderlyingCapCategoryCell( B );

    A := UnderlyingCategory( UnderlyingCategory( CapCategory( C ) ) );

    if IsCapCategoryHomologicalBicomplexObject( B ) then
       return ChainComplex( A, MapLazy( IntegersList, i-> HorizontalDifferentialAt( B, i, j ), 1 ) );
    else
       return CochainComplex( A, MapLazy( IntegersList, i-> HorizontalDifferentialAt( B, i, j ), 1 ) );
    fi;
end );

##
InstallMethod( ColumnAsComplexOp,
               [ IsCapCategoryBicomplexObject, IsInt ],
    function( B, i )
    local C, A;
    C := UnderlyingCapCategoryCell( B );

    A := UnderlyingCategory( UnderlyingCategory( CapCategory( C ) ) );

    if IsCapCategoryHomologicalBicomplexObject( B ) then
       return ChainComplex( A, MapLazy( IntegersList, j -> VerticalDifferentialAt( B, i, j ), 1 ) );
    else
       return CochainComplex( A, MapLazy( IntegersList, j -> VerticalDifferentialAt( B, i, j ), 1 ) );
    fi;
end );

############################################
#
# Transport bounds from com(com ) to bi com
#
############################################

InstallGlobalFunction( TODOLIST_TO_PUSH_BOUNDS_TO_BICOMPLEXES,
   function( C, B )

   AddToToDoList( ToDoListEntry( [ [ C, "FAU_BOUND" ] ], function( )
                                                         SetRight_Bound( B, ActiveUpperBound( C ) );
                                                         end ) );

   AddToToDoList( ToDoListEntry( [ [ C, "FAL_BOUND" ] ], function( )
                                                         SetLeft_Bound( B, ActiveLowerBound( C ) );
                                                         end ) );
   # This code trigers computations
   # look at the demo file in BBGG examples
   AddToToDoList( ToDoListEntry( [ [ C, "FAL_BOUND" ], [ C, "FAU_BOUND" ] ],
            function( )
            local l, ll, lu;
            if ActiveLowerBound( C ) >= ActiveUpperBound( C ) then
                        SetAbove_Bound( B, 0 );
                        SetBelow_Bound( B, 0 );
            fi;
            l := [ ActiveLowerBound( C ) + 1.. ActiveUpperBound( C ) - 1];
			if l = [ ] then
               l := [ ActiveLowerBound( C ) .. ActiveUpperBound( C ) - 1 ];
            fi;
            lu := List( l, u -> [ C[ u ], "FAU_BOUND" ] );
            ll := List( l, u -> [ C[ u ], "FAL_BOUND" ] );
            if l <> [] then
            AddToToDoList( ToDoListEntry( lu, 
                function( )
                    SetAbove_Bound( B, Maximum( List( l, u -> ActiveUpperBound( C[ u ] ) ) ) );
                end ) );
            AddToToDoList( ToDoListEntry( ll, 
                function( )
                    SetBelow_Bound( B, Minimum( List( l, u -> ActiveLowerBound( C[ u ] ) ) ) );
                end ) );
            fi;            
            end ) );

end );

######################################
#
# Bicomplex morphism
#
######################################

InstallMethod( AssociatedBicomplexMorphism,
               [ IsChainOrCochainMorphism ],
   function( phi )
   local cat, type, psi;

   cat := CapCategory( phi );

   if IsChainComplexCategory( cat ) and IsChainComplexCategory( UnderlyingCategory( cat ) ) then
      type := TheTypeHomologicalBicomplexMorphism;
   elif IsCochainComplexCategory( cat ) and IsCochainComplexCategory( UnderlyingCategory( cat ) ) then
      type := TheTypeCohomologicalBicomplexMorphism;
   else
      Error( "not yet implemented" );
   fi;

   psi := rec( );

   ObjectifyWithAttributes(
            psi, type,
            Source, AssociatedBicomplexObject( Source( phi ) ),
            Range, AssociatedBicomplexObject( Range( phi ) ),
            UnderlyingCapCategoryCell, phi
            );

   cat := AsCategoryOfBicomplexes( CapCategory( phi ) );

   AddMorphism( cat, psi );

   TODOLIST_TO_PUSH_BOUNDS_TO_BICOMPLEXES( phi, psi );

   return psi;

end );

##
InstallMethod( BicomplexMorphism,
               [ IsChainOrCochainMorphism ],
    AssociatedBicomplexMorphism );

##
InstallMethod( BicomplexMorphism,
               [ IsCapCategoryBicomplexObject, IsCapCategoryBicomplexObject, IsZList ],
    function( s, t, l )
    local ss, tt, phi;

    if not IsIdenticalObj( CapCategory( s ), CapCategory( t ) ) then
       Error( "The source and range should be in the same category" );
    fi;

    if IsCapCategoryHomologicalBicomplexObject( s ) then
       phi := ChainMorphism( UnderlyingCapCategoryCell( s ), UnderlyingCapCategoryCell( t ), l );
    else
       phi := CochainMorphism( UnderlyingCapCategoryCell( s ), UnderlyingCapCategoryCell( t ), l );
    fi;

    return AssociatedBicomplexMorphism( phi );

end );

##
InstallMethod( BicomplexMorphism,
               [ IsCapCategoryBicomplexObject, IsCapCategoryBicomplexObject, IsFunction ],
    function( s, t, f )
    local l, ss, tt, phi;

    if not IsIdenticalObj( CapCategory( s ), CapCategory( t ) ) then
       Error( "The source and range should be in the same category" );
    fi;

    l := MapLazy( IntegersList, i -> MapLazy( IntegersList, j -> f( i, j ), 1 ), 1 );

    return BicomplexMorphism( s, t, l );

end );


InstallOtherMethod( MorphismAt,
               [ IsCapCategoryBicomplexMorphism, IsInt, IsInt ],
   function( psi, i, j )
   return UnderlyingCapCategoryCell( psi )[ i ][ j ];
end );

##
InstallMethod( AssociatedBicomplexFunctor,
               [ IsCapFunctor, IsString ],
    function( F, name )
    local S, R, BF;

    S := AsCategoryOfBicomplexes( AsCapCategory( Source( F ) ) );
    R := AsCategoryOfBicomplexes( AsCapCategory( Range( F ) ) );

    BF := CapFunctor( name, S, R );

    AddObjectFunction( BF, 
        function( obj )
            return AssociatedBicomplexObject( ApplyFunctor( F, UnderlyingCapCategoryCell( obj ) ) );
        end );

    AddMorphismFunction( BF, 
        function( s, phi, r )
            return AssociatedBicomplexObject( ApplyFunctor( F, UnderlyingCapCategoryCell( phi ) ) );
        end );
        
    return BF;

end );

##
InstallMethod( AssociatedBicomplexFunctor,
               [ IsCapFunctor ],
    function( F )
    local name;
    name := Concatenation( "Associated bicomplex functor of ", Name( F ) );
    return AssociatedBicomplexFunctor( F, name );
end );

######################################
#
# Functors
#
######################################

#DeclareOperation( "CohomologicalToHomologicalBicomplexsFunctor", [ IsCapCategory, IsCapCategory ] );
InstallMethod( CohomologicalToHomologicalBicomplexsFunctor,
                [ IsCapCategory, IsCapCategory ],
    function( CohCat, HoCat )
    local A, F;

    A := UnderlyingCategoryOfComplexesOfComplexes( CohCat );
    A := UnderlyingCategory( A );
    A := UnderlyingCategory( A );

    F := CapFunctor( "Cohomological to homological bicomplexes functor", CohCat, HoCat );

    AddObjectFunction( F,
        function( CohB )
        local H, V, HB;

        H := function( i, j ) return HorizontalDifferentialAt( CohB, -i, -j ); end;
        V := function( i, j ) return VerticalDifferentialAt( CohB, -i, -j ); end;
        HB := HomologicalBicomplex( A, H, V );

        AddToToDoList( ToDoListEntry(
                [ [ CohB, "Above_Bound" ] ],
                    function( )
                    SetBelow_Bound( HB, -Above_Bound( CohB ) );
                    end ) );
        AddToToDoList( ToDoListEntry(
                [ [ CohB, "Below_Bound" ] ],
                    function( )
                    SetAbove_Bound( HB, -Below_Bound( CohB ) );
                    end ) );
        AddToToDoList( ToDoListEntry(
                [ [ CohB, "Right_Bound" ] ],
                    function( )
                    SetLeft_Bound( HB, -Right_Bound( CohB ) );
                    end ) );
        AddToToDoList( ToDoListEntry(
                [ [ CohB, "Left_Bound" ] ],
                    function( )
                    SetRight_Bound( HB, -Left_Bound( CohB ) );
                    end ) );

        return HB;

    end );

    AddMorphismFunction( F,
        function( new_source, f, new_range )
        local mor;
        mor := function( i, j ) return MorphismAt( f, -i, -j ); end;
        return BicomplexMorphism( new_source, new_range, mor );
    end );

    return F;
end );

##
InstallMethod( HomologicalToCohomologicalBicomplexsFunctor,
                [ IsCapCategory, IsCapCategory ],
    function( HoCat, CohCat )
    local A, F;

    A := UnderlyingCategoryOfComplexesOfComplexes( CohCat );
    A := UnderlyingCategory( A );
    A := UnderlyingCategory( A );

    F := CapFunctor( "Homological to cohomological bicomplexes functor",HoCat, CohCat );

    AddObjectFunction( F,
        function( HB )
        local H, V, CohB;

        H := function( i, j ) return HorizontalDifferentialAt( HB, -i, -j ); end;
        V := function( i, j ) return VerticalDifferentialAt( HB, -i, -j ); end;
        CohB := CohomologicalBicomplex( A, H, V );

        AddToToDoList( ToDoListEntry(
                [ [ HB, "Above_Bound" ] ],
                    function( )
                    SetBelow_Bound( CohB, -Above_Bound( HB ) );
                    end ) );
        AddToToDoList( ToDoListEntry(
                [ [ HB, "Below_Bound" ] ],
                    function( )
                    SetAbove_Bound( CohB, -Below_Bound( HB ) );
                    end ) );
        AddToToDoList( ToDoListEntry(
                [ [ HB, "Right_Bound" ] ],
                    function( )
                    SetLeft_Bound( CohB, -Right_Bound( HB ) );
                    end ) );
        AddToToDoList( ToDoListEntry(
                [ [ HB, "Left_Bound" ] ],
                    function( )
                    SetRight_Bound( CohB, -Left_Bound( HB ) );
                    end ) );

        return CohB;

    end );

    AddMorphismFunction( F,
        function( new_source, f, new_range )
        local mor;
        mor := function( i, j ) return MorphismAt( f, -i, -j ); end;
        return BicomplexMorphism( new_source, new_range, mor );
    end );

    return F;
end );

InstallMethod( ComplexOfComplexesToBicomplexFunctor,
        [ IsCapCategory, IsCapCategory ],
    function( complexes, bicomplexes )
    local F, obj_map, name;
    name := "Functor from Complex of complexes category to the associated Bicomplex category";
    F := CapFunctor( name, complexes, bicomplexes );
    if IsCochainComplexCategory( complexes ) then
        obj_map := CohomologicalBicomplex;
    elif IsChainComplexCategory( complexes ) then
        obj_map := HomologicalBicomplex;
    fi;

    AddObjectFunction( F,
        function( C )
        return obj_map( C );
        end );

    AddMorphismFunction( F,
        function( new_source, phi, new_range )
        return BicomplexMorphism( phi );
        end );
    return F;
end );

##
InstallMethod( ExtendFunctorToCohomologicalBicomplexCategoryFunctor,
            [ IsCapFunctor ],
    function( F )
    local functor, name;
    functor := ExtendFunctorToCochainComplexCategoryFunctor( F );
    functor := ExtendFunctorToCochainComplexCategoryFunctor( functor );
    name := Concatenation( "Extension of ", Name( F ), " to cohomological bicomplexes functor" );
    return AssociatedBicomplexFunctor( functor, name );
end );

##
InstallMethod( ExtendFunctorToHomologicalBicomplexCategoryFunctor,
            [ IsCapFunctor ],
    function( F )
    local functor, name;
    functor := ExtendFunctorToChainComplexCategoryFunctor( F );
    functor := ExtendFunctorToChainComplexCategoryFunctor( functor );
    name := Concatenation( "Extension of ", Name( F ), " to homological bicomplexes functor" );
    return AssociatedBicomplexFunctor( functor, name );
end );

InstallMethod( ComplexOfVerticalCohomologiesAtOp,
        [ IsCapCategoryCohomologicalBicomplexObject, IsInt ],
    function( B, n )
    local bicomplexes, cochains, cat, Coh, C, diffs;
    bicomplexes := CapCategory( B );
    cochains := UnderlyingCategoryOfComplexesOfComplexes( bicomplexes );
    cochains := UnderlyingCategory( cochains );
    cat := UnderlyingCategory( cochains );
    Coh := CohomologyFunctorAt( cochains, cat, n );
    C := UnderlyingCapCategoryCell( B );

    if HasIsBicomplexCategoryWithCommutativeSquares( bicomplexes ) and IsBicomplexCategoryWithCommutativeSquares( bicomplexes )then 
    diffs := MapLazy( IntegersList, 
        function( i )
        return ApplyFunctor( Coh, C^i );
        end, 1 );
    else
        diffs := MapLazy( IntegersList, 
            function( i )
            local D;
            if i mod 2 = 0 then
                D := CochainComplex( cat, MapLazy( Differentials( Range( C^i ) ), d->AdditiveInverseForMorphisms(d), 1 ) );
                D := CochainMorphism( Source( C^i ), D, Morphisms( C^i ) );
            else
                D := CochainComplex( cat, MapLazy( Differentials( Source( C^i ) ), d->AdditiveInverseForMorphisms(d), 1 ) );
                D := CochainMorphism( D, Range( C^i ), Morphisms( C^i ) );
            fi;
            return ApplyFunctor( Coh, D );
            end, 1 );
    fi;
    return CochainComplex( cat, diffs );
    ## Add to do list for the bounds
end );

InstallMethod( ComplexMorphismOfVerticalCohomologiesAtOp,
        [ IsCapCategoryCohomologicalBicomplexMorphism, IsInt ],
    function( phi, n )
    local bicomplexes, cochains, cat, Coh, C, maps, psi;
    bicomplexes := CapCategory( phi );
    cochains := UnderlyingCategoryOfComplexesOfComplexes( bicomplexes );
    cochains := UnderlyingCategory( cochains );
    cat := UnderlyingCategory( cochains );
    Coh := CohomologyFunctorAt( cochains, cat, n );
    psi := UnderlyingCapCategoryCell( phi );
    maps := MapLazy( IntegersList, function( i )
                                    local s,r, p;
                                    s := ColumnAsComplex( Source( phi ), i );
                                    r := ColumnAsComplex( Range( phi ), i );
                                    p := CochainMorphism( s, r, Morphisms( psi[ i ] ) );
                                    return ApplyFunctor( Coh, p );
                                    end, 1 );
    return CochainMorphism( ComplexOfVerticalCohomologiesAt( Source( phi ), n ),
                            ComplexOfVerticalCohomologiesAt( Range( phi ), n ), maps );

end );

InstallMethod( ComplexOfVerticalCohomologiesFunctorAtOp,
        [ IsCapCategory, IsInt ],
    function( bicomplexes, n )
    local F, cochains, name;
    cochains := UnderlyingCategoryOfComplexesOfComplexes( bicomplexes );
    cochains := UnderlyingCategory( cochains );

    name := Concatenation( " Complex of vertical cohomologies at ", String( n ), " from ", Name( bicomplexes),
    " to ", Name( cochains ) );

    F := CapFunctor( name, bicomplexes, cochains );
    AddObjectFunction( F,
        function( bicomplex )
            return ComplexOfVerticalCohomologiesAt( bicomplex, n );
        end );
    AddMorphismFunction( F,
        function( new_source, phi, new_range )
            return ComplexMorphismOfVerticalCohomologiesAt( phi, n );
        end );
    return F;
end );


InstallMethod( ComplexOfHorizontalCohomologiesAtOp,
        [ IsCapCategoryCohomologicalBicomplexObject, IsInt ],
    function( B, m )
    local bicomplexes, cochains, cat, Coh, C, diffs;
    bicomplexes := CapCategory( B );
    cochains := UnderlyingCategoryOfComplexesOfComplexes( bicomplexes );
    cochains := UnderlyingCategory( cochains );
    cat := UnderlyingCategory( cochains );
    Coh := CohomologyFunctorAt( cochains, cat, m );
    diffs := MapLazy( IntegersList, function( i )
                                    local current_source, current_range, current_mor, maps;
                                    current_source := RowAsComplex( B, i );
                                    current_range := RowAsComplex( B, i + 1 );
                                    maps := MapLazy( IntegersList, function( j )
                                                                    return VerticalDifferentialAt( B, j, i );
                                                                    end, 1 );
                                    current_mor := CochainMorphism( current_source, current_range, maps );
                                    return ApplyFunctor( Coh, current_mor );
                                    end, 1 );
    return CochainComplex( cat, diffs );
    ## Add to do list for the bounds
end );

##
InstallMethod( ComplexMorphismOfHorizontalCohomologiesAtOp,
        [ IsCapCategoryCohomologicalBicomplexMorphism, IsInt ],
    function( phi, m )
    local bicomplexes, cochains, cat, Coh, C, maps, psi;
    bicomplexes := CapCategory( phi );
    cochains := UnderlyingCategoryOfComplexesOfComplexes( bicomplexes );
    cochains := UnderlyingCategory( cochains );
    cat := UnderlyingCategory( cochains );
    Coh := CohomologyFunctorAt( cochains, cat, m );
    maps := MapLazy( IntegersList,  function( i )
                                    local current_source, current_range, current_mor, current_maps;
                                    current_source := RowAsComplex( Source( phi ), i );
                                    current_range := RowAsComplex( Range( phi ), i );
                                    current_maps := MapLazy( IntegersList,  function( j )
                                                                    return MorphismAt( phi, j, i );
                                                                    end, 1 );
                                    current_mor := CochainMorphism( current_source, current_range, current_maps );
                                    return ApplyFunctor( Coh, current_mor );
                                    end, 1 );
    return CochainMorphism( ComplexOfHorizontalCohomologiesAt( Source( phi ), m ),
                            ComplexOfHorizontalCohomologiesAt( Range( phi ), m ), maps );

end );

InstallMethod( ComplexOfHorizontalCohomologiesFunctorAtOp,
        [ IsCapCategory, IsInt ],
    function( bicomplexes, n )
    local F, cochains, name;
    cochains := UnderlyingCategoryOfComplexesOfComplexes( bicomplexes );
    cochains := UnderlyingCategory( cochains );

    name := Concatenation( " Complex of Horizontal cohomologies at ", String( n ), " from ", Name( bicomplexes),
    " to ", Name( cochains ) );

    F := CapFunctor( name, bicomplexes, cochains );
    AddObjectFunction( F,
        function( bicomplex )
            return ComplexOfHorizontalCohomologiesAt( bicomplex, n );
        end );
    AddMorphismFunction( F,
        function( new_source, phi, new_range )
            return ComplexMorphismOfHorizontalCohomologiesAt( phi, n );
        end );
    return F;
end );

##
InstallMethod( ComplexOfHorizontalHomologiesFunctorAtOp,
        [ IsCapCategory, IsInt ],
    function( ho_bicomplexes, n )
    local F, name, homological_bi_to_cohomological_bi, 
            complex_of_horizontal_cohomologies_functor, cochain_to_chain_complex,
            chains1, chains2, cochains1, cochains2, cat, coh_bicomplexes;
    chains2 := UnderlyingCategoryOfComplexesOfComplexes( ho_bicomplexes );
    chains1 := UnderlyingCategory( chains2 );
    cat := UnderlyingCategory( chains1 );
    cochains1 := CochainComplexCategory( cat );
    cochains2 := CochainComplexCategory( cochains1 );
    coh_bicomplexes := AsCategoryOfBicomplexes( cochains2 );

    homological_bi_to_cohomological_bi := HomologicalToCohomologicalBicomplexsFunctor( ho_bicomplexes, coh_bicomplexes );
    complex_of_horizontal_cohomologies_functor := ComplexOfHorizontalCohomologiesFunctorAt( coh_bicomplexes, -n );
    cochain_to_chain_complex := CochainToChainComplexFunctor( cochains1, chains1 );
    return PreCompose( [ homological_bi_to_cohomological_bi, complex_of_horizontal_cohomologies_functor, cochain_to_chain_complex ] );
end );

##
InstallMethod( ComplexOfVerticalHomologiesFunctorAtOp,
        [ IsCapCategory, IsInt ],
    function( ho_bicomplexes, n )
    local F, name, homological_bi_to_cohomological_bi, 
            complex_of_vertical_cohomologies_functor, cochain_to_chain_complex,
            chains1, chains2, cochains1, cochains2, cat, coh_bicomplexes;
    chains2 := UnderlyingCategoryOfComplexesOfComplexes( ho_bicomplexes );
    chains1 := UnderlyingCategory( chains2 );
    cat := UnderlyingCategory( chains1 );
    cochains1 := CochainComplexCategory( cat );
    cochains2 := CochainComplexCategory( cochains1 );
    coh_bicomplexes := AsCategoryOfBicomplexes( cochains2 );

    homological_bi_to_cohomological_bi := HomologicalToCohomologicalBicomplexsFunctor( ho_bicomplexes, coh_bicomplexes );
    complex_of_vertical_cohomologies_functor := ComplexOfVerticalCohomologiesFunctorAt( coh_bicomplexes, -n );
    cochain_to_chain_complex := CochainToChainComplexFunctor( cochains1, chains1 );
    return PreCompose( [ homological_bi_to_cohomological_bi, complex_of_vertical_cohomologies_functor, cochain_to_chain_complex ] );
end );

InstallMethod( IsWellDefined,
        [ IsCapCategoryBicomplexCell and IsCapCategoryCohomologicalBicomplexObject, IsInt, IsInt, IsInt, IsInt ],
    function( B, left, right, below, above )
    local i,j, cat;

    cat := CapCategory( B );
    for i in [ left .. right ] do
        for j in [ below .. above ] do

            if not IsZero( PreCompose( VerticalDifferentialAt( B, i, j - 1), VerticalDifferentialAt( B, i, j ) ) ) then
                AddToReasons( Concatenation( "IsWellDefined: The composition of vertical differntials at indeices", String(i),",",String(j), "is not zero" ) );
                return false;
            fi;

            if not IsZero( PreCompose( HorizontalDifferentialAt( B, i - 1, j ), HorizontalDifferentialAt( B, i, j ) ) ) then
                AddToReasons( Concatenation( "IsWellDefined: The composition of horizontal differntials at indeices", String(i),",",String(j), "is not zero" ) );
                return false;
            fi;

            if not IsWellDefined( ObjectAt( B, i, j ) ) then
                AddToReasons( Concatenation( "IsWellDefined: The object at indices ", String( i ), ",", String( j ), "is not well-defined." ) );
                return false;
            fi;

            if not IsWellDefined( VerticalDifferentialAt( B, i, j ) ) then
                AddToReasons( Concatenation( "IsWellDefined: The vertical diff at indices ", String( i ), ",", String( j ), "is not well-defined." ) );
                return false;
            fi;

            if not IsWellDefined( HorizontalDifferentialAt( B, i, j ) ) then
                AddToReasons( Concatenation( "IsWellDefined: The Horizontal diff at indices ", String( i ), ",", String( j ), "is not well-defined." ) );
                return false;
            fi;

            if HasIsBicomplexCategoryWithCommutativeSquares( cat ) and IsBicomplexCategoryWithCommutativeSquares( cat ) then
                if not IsCongruentForMorphisms(
                            PreCompose( VerticalDifferentialAt( B, i, j ), HorizontalDifferentialAt( B, i, j + 1 ) ),
                            PreCompose( HorizontalDifferentialAt( B, i, j ), VerticalDifferentialAt( B, i + 1, j ) ) ) then
                            AddToReasons( Concatenation( "IsWellDefined: problem at squar whose source morphisms are at indices ", String( i ), String( j ) ) );
                            return false;
                fi;
            elif not IsCongruentForMorphisms(
                        PreCompose( VerticalDifferentialAt( B, i, j ), HorizontalDifferentialAt( B, i, j + 1 ) ),
                        AdditiveInverseForMorphisms( PreCompose( HorizontalDifferentialAt( B, i, j ), VerticalDifferentialAt( B, i + 1, j ) ) ) ) then
                        AddToReasons( Concatenation( "IsWellDefined: problem at squar whose source morphisms are at indices ", String( i ), String( j ) ) );
                        return false;
            fi;
        od;
    od;
    return true;
end );

InstallMethod( IsWellDefined,
            [ IsCapCategoryBicomplexCell and IsCapCategoryCohomologicalBicomplexMorphism, IsInt, IsInt, IsInt, IsInt ],
    function( phi, left, right, below, above )
    local S, R, i, j;
    S := Source( phi );
    R := Range( phi );

    if not IsWellDefined( S, left, right, below, above ) then
        AddToReasons( "IsWellDefined: The source is not well-defined in the given interval" );
    fi;

    if not IsWellDefined( R, left, right, below, above ) then
        AddToReasons( "IsWellDefined: The range is not well-defined in the given interval" );
    fi;

    for i in [ left .. right ] do
        for j in [ below .. above ] do

            if not IsWellDefined( MorphismAt( phi, i, j ) ) then
                AddToReasons( Concatenation( "IsWellDefined: The morphism at indices ", String( i ), ",",String( j ), " is not well-defined" ) );
                return false;
            fi;

            if not IsCongruentForMorphisms(
                PreCompose( MorphismAt( phi, i, j), HorizontalDifferentialAt( R, i, j ) ),
                PreCompose( HorizontalDifferentialAt( S, i, j ), MorphismAt( phi, i + 1, j ) )
            ) then

            AddToReasons( Concatenation( "IsWellDefined: Problem at horizontal compatibility of the bicomplex morphism at indices ", String( i ),",",String( j ) ) );
            return false;

            fi;

            if not IsCongruentForMorphisms(
                PreCompose( MorphismAt( phi, i, j), VerticalDifferentialAt( R, i, j ) ),
                PreCompose( VerticalDifferentialAt( S, i, j ), MorphismAt( phi, i , j + 1 ) )
            ) then

            AddToReasons( Concatenation( "IsWellDefined: Problem at vertical compatibility of the bicomplex morphism at indices ", String( i ),",",String( j ) ) );
            return false;

            fi;
        od;
    od;

    return true;

end );

InstallMethod( IsWellDefined,
        [ IsCapCategoryBicomplexCell and IsCapCategoryHomologicalBicomplexObject, IsInt, IsInt, IsInt, IsInt ],
    function( B, left, right, below, above )
    local HoCat, cat, CohCat, convert, is_well_defined;

    HoCat := CapCategory( B );
    cat := UnderlyingCategory( UnderlyingCategory( UnderlyingCategoryOfComplexesOfComplexes( HoCat ) ) );
    CohCat := AsCategoryOfBicomplexes( CochainComplexCategory( CochainComplexCategory( cat ) ) );
    convert := HomologicalToCohomologicalBicomplexsFunctor( HoCat, CohCat );
    is_well_defined := IsWellDefined( ApplyFunctor( convert, B ), -right, -left, -above, -below );

    if is_well_defined = false then
        AddToReasons( Concatenation( "IsWellDefined: Because the corresponding cohomological bicomplex is not well-defined" ) );
    fi;

    return is_well_defined;
end );

InstallMethod( IsWellDefined,
        [ IsCapCategoryBicomplexCell and IsCapCategoryHomologicalBicomplexMorphism, IsInt, IsInt, IsInt, IsInt ],
    function( B, left, right, below, above )
    local HoCat, cat, CohCat, convert, is_well_defined;

    HoCat := CapCategory( B );
    cat := UnderlyingCategory( UnderlyingCategory( UnderlyingCategoryOfComplexesOfComplexes( HoCat ) ) );
    CohCat := AsCategoryOfBicomplexes( CochainComplexCategory( CochainComplexCategory( cat ) ) );
    convert := HomologicalToCohomologicalBicomplexsFunctor( HoCat, CohCat );
    is_well_defined := IsWellDefined( ApplyFunctor( convert, B ), -right, -left, -above, -below );
    if is_well_defined = false then
        AddToReasons( Concatenation( "IsWellDefined: Because the corresponding cohomological bicomplex morphism is not well-defined" ) );
    fi;
    return is_well_defined;
end );

InstallMethod( SupportInWindow,
    [ IsCapCategoryBicomplexObject, IsInt, IsInt, IsInt, IsInt ],
    function( B, left, right, below, above )
    local i, j;
    for j in Reversed( [ below .. above ] ) do
    for i in [ left .. right ] do
    if IsZeroForObjects( ObjectAt( B, i, j ) ) then
	Print( ". ");
    else
	Print( TextAttr.1, TextAttr.bold, ". ", TextAttr.reset );
    fi;
    od;
    Print( "  |", j, "\n" );
    od;
end );



InstallMethod( SupportInWindow,
    [ IsCapCategoryBicomplexMorphism, IsInt, IsInt, IsInt, IsInt ],
    function( phi, left, right, below, above )
    local i, j;
    for j in Reversed( [ below .. above ] ) do
    for i in [ left .. right ] do
    if IsZeroForMorphisms( MorphismAt( phi, i, j ) ) then
	Print( ". ");
    else
	Print( "* ");
    fi;
    od;
    Print( "  |", j, "\n" );
    od;
end );

InstallMethod( HorizontalCohomologySupportInWindow,
    [ IsCapCategoryBicomplexObject and IsCapCategoryCohomologicalBicomplexObject, IsInt, IsInt, IsInt, IsInt ],
    function( b, left, right, below, above )
    local i, j;
    for j in Reversed( [ below .. above ] ) do
    for i in [ left .. right ] do
    if IsZeroForObjects( HorizontalCohomologyAt( b, i, j ) ) then
	Print( ". ");
    else
	Print( "* ");
    fi;
    od;
    Print( "  |", j, "\n" );
    od;
end );

InstallMethod( VerticalCohomologySupportInWindow,
    [ IsCapCategoryBicomplexObject and IsCapCategoryCohomologicalBicomplexObject, IsInt, IsInt, IsInt, IsInt ],
    function( b, left, right, below, above )
    local i, j;
    for j in Reversed( [ below .. above ] ) do
    for i in [ left .. right ] do
    if IsZeroForObjects( VerticalCohomologyAt( b, i, j ) ) then
	Print( ". ");
    else
	Print( "* ");
    fi;
    od;
    Print( "  |", j, "\n" );
    od;
end );

InstallMethod( HorizontalHomologySupportInWindow,
    [ IsCapCategoryBicomplexObject and IsCapCategoryHomologicalBicomplexObject, IsInt, IsInt, IsInt, IsInt ],
    function( b, left, right, below, above )
    local i, j;
    for j in Reversed( [ below .. above ] ) do
    for i in [ left .. right ] do
    if IsZeroForObjects( HorizontalHomologyAt( b, i, j ) ) then
	Print( ". ");
    else
	Print( "* ");
    fi;
    od;
    Print( "  |", j, "\n" );
    od;
end );

InstallMethod( VerticalHomologySupportInWindow,
    [ IsCapCategoryBicomplexObject and IsCapCategoryHomologicalBicomplexObject, IsInt, IsInt, IsInt, IsInt ],
    function( b, left, right, below, above )
    local i, j;
    for j in Reversed( [ below .. above ] ) do
    for i in [ left .. right ] do
    if IsZeroForObjects( VerticalHomologyAt( b, i, j ) ) then
	Print( ". ");
    else
	Print( "* ");
    fi;
    od;
    Print( "  |", j, "\n" );
    od;
end );

######################################
#
# View, Display
#
######################################

InstallMethod( ViewObj,
               [ IsCapCategoryBicomplexCell ],
 function( B )

 if IsCapCategoryHomologicalBicomplexObject( B ) then
    Print( "<A homological bicomplex in " );
 elif IsCapCategoryCohomologicalBicomplexObject( B ) then
    Print( "<A cohomological bicomplex in " );
 elif IsCapCategoryHomologicalBicomplexMorphism( B ) then
    Print( "<A homological bicomplex morphism in " );
 elif IsCapCategoryCohomologicalBicomplexMorphism( B ) then
    Print( "<A cohomological bicomplex morphism in " );
 else
    Error( "Unexpected error occurred!" );
 fi;

 Print( Name( UnderlyingCategory( UnderlyingCategory( UnderlyingCategoryOfComplexesOfComplexes( CapCategory( B ) ) ) ) ) );
 Print( " concentrated in window [ " );

 if HasLeft_Bound( B ) then
    Print( Left_Bound( B ), " .. " );
 else
    Print( "-inf", " .. " );
 fi;

 if HasRight_Bound( B ) then
    Print( Right_Bound( B ), " ] x " );
 else
    Print( "inf", " ] x " );
 fi;

 Print( "[ " );
 if HasBelow_Bound( B ) then
    Print( Below_Bound( B ), " .. " );
 else
    Print( "-inf", " .. " );
 fi;

 if HasAbove_Bound( B ) then
    Print( Above_Bound( B ), " ]" );
 else
    Print( "inf", " ]" );
 fi;

 Print( ">" );
 end );

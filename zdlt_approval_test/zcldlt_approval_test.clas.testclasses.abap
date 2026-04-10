CLASS ltcl_unittest DEFINITION
  FINAL
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT
  FRIENDS zcldlt_approval_test.

  PRIVATE SECTION.
    TYPES tt_integers TYPE STANDARD TABLE OF int4 WITH EMPTY KEY.

    CONSTANTS identifier          TYPE zdlttestresult-identifier VALUE 'ZCLDLT_APPROVAL_TEST'.
    CONSTANTS returning_parameter TYPE abap_parmbind-name        VALUE 'RESULT'.

    METHODS shall_one_parameter_be_ok     FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_without_parameter_be_ok FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_two_parameters_be_ok    FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_three_parameters_be_ok  FOR TESTING RAISING cx_static_check cx_dynamic_check.

    METHODS one_parameter
      IMPORTING !number       TYPE int4
      RETURNING VALUE(result) TYPE string.

    METHODS without_a_parameter
      RETURNING VALUE(result) TYPE string.

    METHODS two_parameters
      IMPORTING number_first  TYPE int4
                number_second TYPE int4
      RETURNING VALUE(result) TYPE string.

    METHODS three_parameters
      IMPORTING number_first  TYPE int4
                number_second TYPE int4
                !text         TYPE string
      RETURNING VALUE(result) TYPE string.

    METHODS execute_test
      IMPORTING !method         TYPE zdlttestresult-method
                parameter_infos TYPE zcldlt_approval_test=>tt_param_infos
      RAISING   cx_static_check cx_dynamic_check.
ENDCLASS.

CLASS ltcl_unittest IMPLEMENTATION.
  METHOD shall_one_parameter_be_ok.
    " given
    DATA(numbers) = VALUE tt_integers( ( 5 )
                                       ( 8 ) ).

    " when + then
    execute_test( method          = 'ONE_PARAMETER'
                  parameter_infos = VALUE #( ( name   = 'NUMBER'
                                               values = VALUE #( FOR <number> IN numbers
                                                                 ( REF #( <number> ) ) ) ) ) ).
  ENDMETHOD.

  METHOD one_parameter.
    result = number.
  ENDMETHOD.

  METHOD without_a_parameter.
    result = 'without_a_parameter'.
  ENDMETHOD.

  METHOD shall_without_parameter_be_ok.
    " when + then
    execute_test( method          = 'WITHOUT_A_PARAMETER'
                  parameter_infos = VALUE #( ) ).
  ENDMETHOD.

  METHOD execute_test.
    " when + then
    DATA(test_instance) = zcldlt_approval_test=>create( identifier = identifier
                                                        method     = method ).

    cl_abap_unit_assert=>assert_bound( act = test_instance
                                       msg = 'create' ).

    DATA(test_instance_execute) = test_instance->execute( test_instance             = me
                                                          importing_parameter_infos = parameter_infos
                                                          method_name               = method
                                                          returning_parameter       = returning_parameter ).

    cl_abap_unit_assert=>assert_bound( act = test_instance_execute
                                       msg = 'execute' ).
    cl_abap_unit_assert=>assert_true( act = test_instance_execute->save_the_current_results( )
                                      msg = 'saved' ).

    SELECT COUNT( * )
        FROM zdlttestresult
        WHERE identifier = @identifier
          AND method     = @method
        INTO @DATA(count).
    DATA(combinations) = REDUCE int4( INIT sum = 1
    FOR <param> IN parameter_infos
    NEXT sum *= lines( <param>-values ) ).

    cl_abap_unit_assert=>assert_equals( exp = count
                                        act = combinations
                                        msg = 'Count DB' ).
  ENDMETHOD.

  METHOD two_parameters.
    result = number_first + number_second.
  ENDMETHOD.

  METHOD shall_two_parameters_be_ok.
    " given
    DATA(firsts) = VALUE tt_integers( ( 10 )
                                      ( 20 ) ).
    DATA(seconds) = VALUE tt_integers( ( 2 )
                                       ( 8 ) ).

    " when + then
    execute_test( method          = 'TWO_PARAMETERS'
                  parameter_infos = VALUE #( ( name   = 'NUMBER_FIRST'
                                               values = VALUE #( FOR <number> IN firsts
                                                                 ( REF #( <number> ) ) ) )
                                             ( name   = 'NUMBER_SECOND'
                                               values = VALUE #( FOR <number> IN seconds
                                                                 ( REF #( <number> ) ) ) ) ) ).
  ENDMETHOD.

  METHOD three_parameters.
    result = |{ text }: { number_first + number_second }|.
  ENDMETHOD.

  METHOD shall_three_parameters_be_ok.
    " given
    DATA(firsts) = VALUE tt_integers( ( 10 )
                                      ( 20 ) ).
    DATA(seconds) = VALUE tt_integers( ( 2 )
                                       ( 8 )
                                       ( 5 ) ).
    DATA(texts) = VALUE string_table( ( |A| )
                                      ( |E| )
                                      ( |B| )
                                      ( |Z| ) ).

    " when + then
    execute_test( method          = 'THREE_PARAMETERS'
                  parameter_infos = VALUE #( ( name   = 'NUMBER_FIRST'
                                               values = VALUE #( FOR <number> IN firsts
                                                                 ( REF #( <number> ) ) ) )
                                             ( name   = 'NUMBER_SECOND'
                                               values = VALUE #( FOR <number> IN seconds
                                                                 ( REF #( <number> ) ) ) )
                                             ( name   = 'TEXT'
                                               values = VALUE #( FOR <text> IN texts
                                                                 ( REF #( <text> ) ) ) ) ) ).
  ENDMETHOD.
ENDCLASS.

"! <p class="shorttext synchronized">Executes the acceptance tests</p>
CLASS zcldlt_acceptance_test DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_param_info,
             name   TYPE abap_parmbind-name,
             values TYPE STANDARD TABLE OF abap_parmbind-value WITH EMPTY KEY,
           END OF ts_param_info.
    TYPES tt_param_infos TYPE SORTED TABLE OF ts_param_info WITH UNIQUE KEY name.

    CLASS-METHODS create
      IMPORTING !identifier            TYPE zdlttestresult-identifier
                !method                TYPE zdlttestresult-method
      RETURNING VALUE(acceptance_test) TYPE REF TO zcldlt_acceptance_test
      RAISING   zcxdlt_parameter_initial.

    CLASS-METHODS create_by_test_result
      IMPORTING test_result            TYPE REF TO zifdlt_acceptance_test_testres
      RETURNING VALUE(acceptance_test) TYPE REF TO zcldlt_acceptance_test
      RAISING   zcxdlt_parameter_initial.

    "! <p class="shorttext synchronized"></p>
    "! Executes the testmethod.<br/>
    "! The method has to be eiter public or this class has to be a friend.<br/>
    "! The type of the returning_parameter has to be a string.
    "! @parameter test_instance             | <p class="shorttext synchronized"></p>
    "! @parameter method_name               | <p class="shorttext synchronized"></p>
    "! @parameter importing_parameter_infos | <p class="shorttext synchronized"></p>
    "! @parameter returning_parameter       | <p class="shorttext synchronized"></p>
    "! @parameter acceptance_test           | <p class="shorttext synchronized"></p>
    "! @raising   cx_dynamic_check          | <p class="shorttext synchronized"></p>
    "! @raising   cx_static_check           | <p class="shorttext synchronized"></p>
    METHODS execute
      IMPORTING test_instance             TYPE REF TO object
                method_name               TYPE clike
                importing_parameter_infos TYPE tt_param_infos OPTIONAL
                returning_parameter       TYPE abap_parmbind-name
      RETURNING VALUE(acceptance_test)    TYPE REF TO zcldlt_acceptance_test
      RAISING   cx_dynamic_check
                cx_static_check.

    "! <p class="shorttext synchronized"></p>
    "! Save the current results
    "! @parameter save  | <p class="shorttext synchronized"></p>
    "! @parameter saved | <p class="shorttext synchronized"></p>
    METHODS save_the_current_results
      IMPORTING !save        TYPE abap_bool DEFAULT abap_true
      RETURNING VALUE(saved) TYPE abap_bool.

  PRIVATE SECTION.
    TYPES: BEGIN OF ts_parameter_string,
             name  TYPE abap_parmbind-name,
             value TYPE string,
           END OF ts_parameter_string.
    TYPES tt_parameter_strings TYPE STANDARD TABLE OF ts_parameter_string WITH EMPTY KEY.

    DATA test_result TYPE REF TO zifdlt_acceptance_test_testres.

    "! <p class="shorttext synchronized"></p>
    "! Factory-Method for the test result
    "! @parameter identifier               | <p class="shorttext synchronized"></p>
    "! @parameter method                   | <p class="shorttext synchronized"></p>
    "! @parameter test_result              | <p class="shorttext synchronized"></p>
    "! @raising   zcxdlt_parameter_initial | <p class="shorttext synchronized"></p>
    CLASS-METHODS build_test_result
      IMPORTING !identifier        TYPE zdlttestresult-identifier
                !method            TYPE zdlttestresult-method
      RETURNING VALUE(test_result) TYPE REF TO zifdlt_acceptance_test_testres
      RAISING   zcxdlt_parameter_initial.

    METHODS constructor
      IMPORTING test_result TYPE REF TO zifdlt_acceptance_test_testres
      RAISING   zcxdlt_parameter_initial.

    "! <p class="shorttext synchronized"></p>
    "! Convert the parameters to a JSON string
    "! @parameter parameters  | <p class="shorttext synchronized"></p>
    "! @parameter json_string | <p class="shorttext synchronized"></p>
    METHODS convert_parameter_to_json
      IMPORTING !parameters        TYPE abap_parmbind_tab
      RETURNING VALUE(json_string) TYPE string.

    "! <p class="shorttext synchronized"></p>
    "! Executes the the method in order to check the result
    "! @parameter test_instance       | <p class="shorttext synchronized"></p>
    "! @parameter method_name         | <p class="shorttext synchronized"></p>
    "! @parameter parameters          | <p class="shorttext synchronized"></p>
    "! @parameter returning_parameter | <p class="shorttext synchronized"></p>
    "! @raising   cx_dynamic_check    | <p class="shorttext synchronized"></p>
    "! @raising   cx_static_check     | <p class="shorttext synchronized"></p>
    METHODS execute_test_method
      IMPORTING test_instance       TYPE REF TO object
                method_name         TYPE clike
                !parameters         TYPE abap_parmbind_tab
                returning_parameter TYPE abap_parmbind-name
      RAISING   cx_dynamic_check
                cx_static_check.

    "! <p class="shorttext synchronized"></p>
    "! Build the parameters
    "! @parameter name           | <p class="shorttext synchronized"></p>
    "! @parameter value          | <p class="shorttext synchronized"></p>
    "! @parameter parameters     | <p class="shorttext synchronized"></p>
    "! @parameter new_parameters | <p class="shorttext synchronized"></p>
    METHODS build_parameters
      IMPORTING !name                 TYPE abap_parmbind-name
                !value                TYPE abap_parmbind-value
                !parameters           TYPE abap_parmbind_tab OPTIONAL
      RETURNING VALUE(new_parameters) TYPE abap_parmbind_tab.

    "! <p class="shorttext synchronized"></p>
    "! Executes the testmethod of each parameter value
    "! @parameter returning_parameter | <p class="shorttext synchronized"></p>
    "! @parameter parameter_infos     | <p class="shorttext synchronized"></p>
    "! @parameter method_name         | <p class="shorttext synchronized"></p>
    "! @parameter test_instance       | <p class="shorttext synchronized"></p>
    "! @parameter previous_parameters | <p class="shorttext synchronized"></p>
    "! @parameter parameter_index     | <p class="shorttext synchronized"></p>
    "! @raising   cx_dynamic_check    | <p class="shorttext synchronized"></p>
    "! @raising   cx_static_check     | <p class="shorttext synchronized"></p>
    METHODS execute_for_parameter
      IMPORTING returning_parameter TYPE abap_parmbind-name
                parameter_infos     TYPE zcldlt_acceptance_test=>tt_param_infos
                method_name         TYPE clike
                test_instance       TYPE REF TO object
                previous_parameters TYPE abap_parmbind_tab OPTIONAL
                parameter_index     TYPE int4
      RAISING   cx_dynamic_check
                cx_static_check.

    "! <p class="shorttext synchronized"></p>
    "! Process the parameter
    "! @parameter returning_parameter | <p class="shorttext synchronized"></p>
    "! @parameter parameter_infos     | <p class="shorttext synchronized"></p>
    "! @parameter method_name         | <p class="shorttext synchronized"></p>
    "! @parameter test_instance       | <p class="shorttext synchronized"></p>
    "! @parameter previous_parameters | <p class="shorttext synchronized"></p>
    "! @parameter parameter_index     | <p class="shorttext synchronized"></p>
    "! @parameter max_parameters      | <p class="shorttext synchronized"></p>
    "! @raising   cx_dynamic_check    | <p class="shorttext synchronized"></p>
    "! @raising   cx_static_check     | <p class="shorttext synchronized"></p>
    METHODS process_parameter
      IMPORTING returning_parameter TYPE abap_parmbind-name
                parameter_infos     TYPE zcldlt_acceptance_test=>tt_param_infos
                method_name         TYPE clike
                test_instance       TYPE REF TO object
                previous_parameters TYPE abap_parmbind_tab OPTIONAL
                parameter_index     TYPE int4
                max_parameters      TYPE int4
      RAISING   cx_dynamic_check
                cx_static_check.
ENDCLASS.

CLASS zcldlt_acceptance_test IMPLEMENTATION.
  METHOD create.
    acceptance_test = NEW #(  build_test_result( identifier = identifier
                                                 method     = method ) ).
  ENDMETHOD.

  METHOD constructor.
    me->test_result = COND #( WHEN test_result IS BOUND
                              THEN test_result
                              ELSE THROW zcxdlt_parameter_initial( ) ).
  ENDMETHOD.

  METHOD build_test_result.
    test_result = NEW zcldlt_acceptance_test_testres( identifier = identifier
                                                      method     = method ).
  ENDMETHOD.

  METHOD execute.
    DATA(parameters) = lines( importing_parameter_infos ).

    IF parameters = 0.

      execute_test_method( test_instance       = test_instance
                           method_name         = method_name
                           parameters          = VALUE #( )
                           returning_parameter = returning_parameter ).

    ELSE.

      process_parameter( returning_parameter = returning_parameter
                         parameter_infos     = importing_parameter_infos
                         method_name         = method_name
                         test_instance       = test_instance
                         parameter_index     = 1
                         max_parameters      = parameters ).

    ENDIF.
    acceptance_test = me.
  ENDMETHOD.

  METHOD convert_parameter_to_json.
    DATA(parameter_strings) = VALUE tt_parameter_strings( FOR <parameter> IN parameters
                                                          WHERE ( kind <> cl_abap_objectdescr=>receiving )
                                                          ( name  = <parameter>-name
                                                            value = |{ <parameter>-value->* }| ) ).

    CALL TRANSFORMATION id
         SOURCE parameters = parameter_strings
         RESULT JSON json_string.
  ENDMETHOD.

  METHOD save_the_current_results.
    CHECK save = abap_true.

    saved = test_result->save( ).
  ENDMETHOD.

  METHOD execute_test_method.
    DATA(result) = ||.
    DATA(current_parameters) = VALUE abap_parmbind_tab( BASE parameters
                                                        ( kind  = cl_abap_objectdescr=>receiving
                                                          name  = returning_parameter
                                                          value = REF #( result ) ) ).

    CALL METHOD test_instance->(method_name)
    PARAMETER-TABLE current_parameters.

    DATA(parameter) = convert_parameter_to_json( current_parameters  ).

    cl_abap_unit_assert=>assert_equals( exp  = test_result->select_latest_result( )
                                        act  = result
                                        msg  = parameter
                                        quit = if_abap_unit_constant=>quit-no ).
    test_result->add_result( parameter = parameter
                             result    = result ).
  ENDMETHOD.

  METHOD build_parameters.
    new_parameters = VALUE #( BASE parameters
                              ( kind  = cl_abap_objectdescr=>exporting
                                name  = name
                                value = value ) ).
  ENDMETHOD.

  METHOD execute_for_parameter.
    ASSIGN parameter_infos[ parameter_index ] TO FIELD-SYMBOL(<parameter>).
    LOOP AT <parameter>-values ASSIGNING FIELD-SYMBOL(<value>).

      execute_test_method( test_instance       = test_instance
                           method_name         = method_name
                           parameters          = build_parameters( parameters = previous_parameters
                                                                   name       = <parameter>-name
                                                                   value      = <value> )
                           returning_parameter = returning_parameter ).

    ENDLOOP.
  ENDMETHOD.

  METHOD process_parameter.
    IF parameter_index = max_parameters.

      execute_for_parameter( returning_parameter = returning_parameter
                             parameter_infos     = parameter_infos
                             method_name         = method_name
                             test_instance       = test_instance
                             previous_parameters = previous_parameters
                             parameter_index     = parameter_index ).

    ELSE.

      ASSIGN parameter_infos[ parameter_index ] TO FIELD-SYMBOL(<parameter>).
      LOOP AT <parameter>-values ASSIGNING FIELD-SYMBOL(<value>).

        DATA(parameters) = build_parameters( name       = <parameter>-name
                                             value      = <value>
                                             parameters = previous_parameters ).

        process_parameter( returning_parameter = returning_parameter
                           parameter_infos     = parameter_infos
                           method_name         = method_name
                           test_instance       = test_instance
                           previous_parameters = parameters
                           parameter_index     = parameter_index + 1
                           max_parameters      = max_parameters ).

      ENDLOOP.

    ENDIF.
  ENDMETHOD.

  METHOD create_by_test_result.
    acceptance_test = NEW #( test_result ).
  ENDMETHOD.
ENDCLASS.

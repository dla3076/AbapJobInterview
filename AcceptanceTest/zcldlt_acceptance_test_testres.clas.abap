"! <p class="shorttext synchronized">Testresult for acceptance tests</p>
CLASS zcldlt_acceptance_test_testres DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zifdlt_acceptance_test_testres.

    METHODS constructor
      IMPORTING !identifier TYPE zdlttestresult-identifier
                !method     TYPE zdlttestresult-method
      RAISING   zcxdlt_parameter_initial.

  PRIVATE SECTION.
    DATA identifier   TYPE zdlttestresult-identifier.
    DATA method       TYPE zdlttestresult-method.
    DATA test_results TYPE STANDARD TABLE OF zdlttestresult WITH EMPTY KEY.

    "! <p class="shorttext synchronized"></p>
    "! Commit or rollback the changes
    "! @parameter subrc | <p class="shorttext synchronized"></p>
    "! @parameter saved | <p class="shorttext synchronized"></p>
    METHODS commit_or_rollback
      IMPORTING VALUE(subrc) TYPE sy-subrc
      RETURNING VALUE(saved) TYPE abap_bool.

    "! <p class="shorttext synchronized"></p>
    "! Delete existing values with a counter higher than the provided one
    "! @parameter last_counter | <p class="shorttext synchronized"></p>
    METHODS delete_existing_values
      IMPORTING last_counter TYPE zdlttestresult-counter.

    "! <p class="shorttext synchronized"></p>
    "! Calculate the counter
    "! @parameter counter | <p class="shorttext synchronized"></p>
    METHODS calculate_counter
      RETURNING VALUE(counter) TYPE zdlttestresult-counter.
ENDCLASS.



CLASS ZCLDLT_ACCEPTANCE_TEST_TESTRES IMPLEMENTATION.


  METHOD constructor.
    IF    identifier IS INITIAL
       OR method     IS INITIAL.

      RAISE EXCEPTION NEW zcxdlt_parameter_initial( ).

    ENDIF.
    me->identifier = identifier.
    me->method     = method.
  ENDMETHOD.


  METHOD delete_existing_values.
    DELETE FROM zdlttestresult
        WHERE identifier = @identifier
          AND method     = @method
          AND counter    > @last_counter.
    commit_or_rollback( sy-subrc ).
  ENDMETHOD.


  METHOD calculate_counter.
    counter = lines( test_results ) + 1.
  ENDMETHOD.


  METHOD zifdlt_acceptance_test_testres~save.
    CHECK test_results IS NOT INITIAL.

    MODIFY zdlttestresult FROM TABLE @test_results.
    saved = commit_or_rollback( sy-subrc ).
    delete_existing_values( lines( test_results ) ).
  ENDMETHOD.


  METHOD commit_or_rollback.
    IF subrc = 0.

      COMMIT WORK AND WAIT.
      saved = abap_true.

    ELSE.

      ROLLBACK WORK.

    ENDIF.
  ENDMETHOD.


  METHOD zifdlt_acceptance_test_testres~add_result.
    INSERT VALUE #( identifier       = identifier
                    method           = method
                    method_parameter = parameter
                    method_result    = result
                    counter          = calculate_counter( ) )
           INTO TABLE test_results.
    test_result = me.
  ENDMETHOD.


  METHOD zifdlt_acceptance_test_testres~select_latest_result.
    SELECT SINGLE method_result
        FROM zdlttestresult
        WHERE identifier = @identifier
          AND method     = @method
          AND counter    = @( calculate_counter(  ) )
        INTO @result.
  ENDMETHOD.
ENDCLASS.

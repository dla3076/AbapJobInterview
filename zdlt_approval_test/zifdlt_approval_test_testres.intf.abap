"! <p class="shorttext synchronized">Testresult for approval tests</p>
INTERFACE zifdlt_approval_test_testres
  PUBLIC.
  TYPES: BEGIN OF ts_result,
           counter TYPE int4,
           value   TYPE string,
         END OF ts_result.
  TYPES: BEGIN OF ts_result_counter,
           parameter TYPE string,
           value     TYPE string,
         END OF ts_result_counter.

  "! <p class="shorttext synchronized"></p>
  "! Add result values
  "! @parameter parameter   | <p class="shorttext synchronized"></p>
  "! @parameter result      | <p class="shorttext synchronized"></p>
  "! @parameter test_result | <p class="shorttext synchronized"></p>
  METHODS add_result
    IMPORTING !parameter         TYPE clike
              !result            TYPE clike
    RETURNING VALUE(test_result) TYPE REF TO zifdlt_approval_test_testres.

  "! <p class="shorttext synchronized"></p>
  "! Save the results
  "! @parameter saved | <p class="shorttext synchronized"></p>
  METHODS save
    RETURNING VALUE(saved) TYPE abap_bool.

  "! <p class="shorttext synchronized"></p>
  "! Select the latest result based on the counter
  "! @parameter result | <p class="shorttext synchronized"></p>
  METHODS select_latest_result
    RETURNING VALUE(result) TYPE ts_result.

  "! <p class="shorttext synchronized"></p>
  "! Select the result and the parameter based on the counter
  "! @parameter result | <p class="shorttext synchronized"></p>
  METHODS select_result_by_counter
    IMPORTING counter       TYPE ts_result-counter
    RETURNING VALUE(result) TYPE ts_result_counter.
ENDINTERFACE.

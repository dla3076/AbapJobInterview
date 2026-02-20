"! <p class="shorttext synchronized">Testresult for acceptance tests</p>
INTERFACE zifdlt_acceptance_test_testres
  PUBLIC.
  "! <p class="shorttext synchronized"></p>
  "! Add result values
  "! @parameter parameter   | <p class="shorttext synchronized"></p>
  "! @parameter result      | <p class="shorttext synchronized"></p>
  "! @parameter test_result | <p class="shorttext synchronized"></p>
  METHODS add_result
    IMPORTING !parameter         TYPE clike
              !result            TYPE clike
    RETURNING VALUE(test_result) TYPE REF TO zifdlt_acceptance_test_testres.

  "! <p class="shorttext synchronized"></p>
  "! Save the results
  "! @parameter saved | <p class="shorttext synchronized"></p>
  METHODS save
    RETURNING VALUE(saved) TYPE abap_bool.

  "! <p class="shorttext synchronized"></p>
  "! Select the latest result based on the counter
  "! @parameter result | <p class="shorttext synchronized"></p>
  METHODS select_latest_result
    RETURNING VALUE(result) TYPE string.
ENDINTERFACE.

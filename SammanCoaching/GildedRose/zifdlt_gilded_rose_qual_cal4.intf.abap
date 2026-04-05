"! <p class="shorttext synchronized">Calculate the quality</p>
INTERFACE zifdlt_gilded_rose_qual_cal4
  PUBLIC.

  METHODS calculate
    IMPORTING item                     TYPE REF TO zcldlt_gilded_rose_item
    RETURNING VALUE(quality_to_change) TYPE int4.
ENDINTERFACE.

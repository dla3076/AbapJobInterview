"! <p class="shorttext synchronized">Calculate the quality</p>
INTERFACE zifdlt_gilded_rose_qual_cal4
  PUBLIC.

  TYPES: BEGIN OF ts_item,
           sell_in TYPE int4,
           quality TYPE int4,
         END OF ts_item.

  METHODS calculate
    IMPORTING item                     TYPE ts_item
    RETURNING VALUE(quality_to_change) TYPE int4.
ENDINTERFACE.

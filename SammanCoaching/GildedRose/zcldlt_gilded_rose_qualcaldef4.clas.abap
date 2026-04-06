"! <p class="shorttext synchronized">Calculate the quality: Default variant</p>
CLASS zcldlt_gilded_rose_qualcaldef4 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zifdlt_gilded_rose_qual_cal4.

    TYPES: BEGIN OF ts_quality_change,
             default       TYPE int4,
             after_sell_in TYPE int4,
           END OF ts_quality_change.

    CLASS-DATA default_quality_change TYPE ts_quality_change READ-ONLY.

    CLASS-METHODS class_constructor.

    METHODS constructor
      IMPORTING quality_change TYPE ts_quality_change DEFAULT default_quality_change
                factor         TYPE int4              DEFAULT -1.

  PRIVATE SECTION.
    DATA quality_change TYPE ts_quality_change.
    DATA factor         TYPE int4.
ENDCLASS.

CLASS zcldlt_gilded_rose_qualcaldef4 IMPLEMENTATION.
  METHOD constructor.
    me->quality_change = quality_change.
    me->factor         = factor.
  ENDMETHOD.

  METHOD class_constructor.
    default_quality_change = VALUE #( default       = 1
                                      after_sell_in = 2 ).
  ENDMETHOD.

  METHOD zifdlt_gilded_rose_qual_cal4~calculate.
    quality_to_change = factor * COND #( WHEN item-sell_in < 0
                                         THEN quality_change-after_sell_in
                                         ELSE quality_change-default ).
  ENDMETHOD.
ENDCLASS.

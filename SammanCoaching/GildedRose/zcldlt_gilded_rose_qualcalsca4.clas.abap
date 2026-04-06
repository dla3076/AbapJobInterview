"! <p class="shorttext synchronized">Calculate the quality: Calculate with scaling and reset</p>
CLASS zcldlt_gilded_rose_qualcalsca4 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zifdlt_gilded_rose_qual_cal4.

    TYPES: BEGIN OF ts_scaling,
             sell_in_less_than TYPE int4,
             quality_to_change TYPE int4,
           END OF ts_scaling.
    TYPES tt_scalings TYPE STANDARD TABLE OF ts_scaling WITH EMPTY KEY.

    METHODS constructor
      IMPORTING scalings        TYPE tt_scalings
                default_quality TYPE int4 DEFAULT 1.

  PRIVATE SECTION.
    DATA scalings        TYPE tt_scalings.
    DATA default_quality TYPE int4.

    METHODS calculate_with_return
      IMPORTING item                     TYPE zifdlt_gilded_rose_qual_cal4=>ts_item
      RETURNING VALUE(quality_to_change) TYPE int4.

    METHODS calculate_with_if
      IMPORTING item                     TYPE zifdlt_gilded_rose_qual_cal4=>ts_item
      RETURNING VALUE(quality_to_change) TYPE int4.
ENDCLASS.

CLASS zcldlt_gilded_rose_qualcalsca4 IMPLEMENTATION.
  METHOD constructor.
    me->scalings        = scalings.
    me->default_quality = default_quality.
  ENDMETHOD.

  METHOD zifdlt_gilded_rose_qual_cal4~calculate.
    DATA(calculation_type) = abap_true.

    quality_to_change = COND #( WHEN calculation_type = abap_true
                                THEN calculate_with_return( item )
                                ELSE calculate_with_if( item ) ).
  ENDMETHOD.

  METHOD calculate_with_return.
    IF item-sell_in < 0.

      " Quality drops to 0 after the concert
      RETURN -1 * item-quality.

    ENDIF.
    LOOP AT scalings ASSIGNING FIELD-SYMBOL(<scaling>)
         WHERE sell_in_less_than > item-sell_in.

      RETURN <scaling>-quality_to_change.

    ENDLOOP.
    " Increase if there is no matching rule
    quality_to_change = default_quality.
  ENDMETHOD.

  METHOD calculate_with_if.
    IF item-sell_in < 0.

      " Quality drops to 0 after the concert
      quality_to_change = -1 * item-quality.

    ELSE.

      " Increase if there is no matching rule
      quality_to_change = default_quality.
      LOOP AT scalings ASSIGNING FIELD-SYMBOL(<scaling>)
           WHERE sell_in_less_than > item-sell_in.

        quality_to_change = <scaling>-quality_to_change.
        EXIT.

      ENDLOOP.

    ENDIF.
  ENDMETHOD.
ENDCLASS.

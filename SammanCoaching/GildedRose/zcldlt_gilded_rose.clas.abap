! <p class="shorttext synchronized">Gilded Rose kata</p>
CLASS zcldlt_gilded_rose3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES tt_items TYPE STANDARD TABLE OF REF TO zcldlt_gilded_rose_item WITH EMPTY KEY.

    CLASS-METHODS class_constructor.

    METHODS constructor
      IMPORTING it_items TYPE tt_items.

    METHODS update_quality.

  PRIVATE SECTION.
    TYPES: BEGIN OF ts_rule,
             regular_expression             TYPE string,
             quality_to_change              TYPE i,
             quality_to_change_after_sellin TYPE i,
             quality_to_change_method       TYPE c LENGTH 30,
             change_sell_in                 TYPE abap_bool,
           END OF ts_rule.

    CLASS-DATA rules TYPE STANDARD TABLE OF ts_rule WITH EMPTY KEY.

    DATA mt_items TYPE tt_items.

    METHODS change_sell_in
      IMPORTING item TYPE REF TO zcldlt_gilded_rose_item
                rule TYPE ts_rule.

    METHODS changeQuality
      IMPORTING item            TYPE REF TO zcldlt_gilded_rose_item
                qualitytochange TYPE i.

    METHODS calcualte_quality_to_change
      IMPORTING item                   TYPE REF TO zcldlt_gilded_rose_item
                rule                   TYPE ts_rule
      RETURNING VALUE(qualitytochange) TYPE i.

    METHODS calc_quality_backstage_passes
      IMPORTING item                   TYPE REF TO zcldlt_gilded_rose_item
      RETURNING VALUE(qualitytochange) TYPE i.

    METHODS update_item_by_rules
      IMPORTING item TYPE REF TO zcldlt_gilded_rose_item.
ENDCLASS.

CLASS zcldlt_gilded_rose3 IMPLEMENTATION.
  METHOD class_constructor.
    rules = VALUE #( ( regular_expression             = '^Aged\sBrie$'
                       quality_to_change              = 1
                       quality_to_change_after_sellin = 2
                       change_sell_in                 = abap_true )
                     ( regular_expression             = '^Sulfuras.*'
                       quality_to_change              = 0
                       quality_to_change_after_sellin = 0 )
                     ( regular_expression             = '^Backstage\spasses.*'
                       quality_to_change_method       = 'CALC_QUALITY_BACKSTAGE_PASSES'
                       change_sell_in                 = abap_true )
                     ( regular_expression             = '^Conjured.*'
                       quality_to_change              = -2
                       quality_to_change_after_sellin = -4
                       change_sell_in                 = abap_true )
                     " Has to be the last rule because it contains the default handling
                     ( regular_expression             = '^.*$'
                       quality_to_change              = -1
                       quality_to_change_after_sellin = -2
                       change_sell_in                 = abap_true ) ).
  ENDMETHOD.

  METHOD constructor.
    mt_items = it_items.
  ENDMETHOD.

  METHOD update_quality.
    LOOP AT mt_items ASSIGNING FIELD-SYMBOL(<item>).

      update_item_by_rules( <item> ).

    ENDLOOP.
  ENDMETHOD.

  METHOD change_sell_in.
    CHECK rule-change_sell_in = abap_true.

    item->mv_sell_in -= 1.
  ENDMETHOD.

  METHOD changeQuality.
    CHECK qualitytochange <> 0.

    item->mv_quality += qualitytochange.
    item->mv_quality  = nmin( val1 = 50
                              val2 = nmax( val1 = item->mv_quality
                                           val2 = 0 ) ).
  ENDMETHOD.

  METHOD calcualte_quality_to_change.
    IF rule-quality_to_change_method IS INITIAL.

      qualitytochange = COND #( WHEN item->mv_sell_in < 0
                                THEN rule-quality_to_change_after_sellin
                                ELSE rule-quality_to_change ).

    ELSE.

      CALL METHOD me->(rule-quality_to_change_method)
        EXPORTING
          item            = item
        RECEIVING
          qualitytochange = qualitytochange.

    ENDIF.
  ENDMETHOD.

  METHOD calc_quality_backstage_passes.
    qualityToChange = COND i( WHEN item->mv_sell_in < 0   THEN -1 * item->mv_quality
                              WHEN item->mv_sell_in <= 5  THEN 3
                              WHEN item->mv_sell_in <= 10 THEN 2
                              ELSE                             1 ).
  ENDMETHOD.

  METHOD update_item_by_rules.
    LOOP AT rules ASSIGNING FIELD-SYMBOL(<rule>).

      IF count( val  = item->mv_name
                pcre = <rule>-regular_expression ) = 1.

        change_sell_in( item = item
                        rule = <rule> ).
        changeQuality( item            = item
                       qualitytochange = calcualte_quality_to_change( item = item
                                                                      rule = <rule> ) ).
        EXIT.

      ENDIF.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

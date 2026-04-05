CLASS ltcl_unittest DEFINITION
  ABSTRACT.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING !names TYPE string_table.

  PROTECTED SECTION.
    TYPES: BEGIN OF ts_test_data,
             quality TYPE i,
             sell_in TYPE i,
           END OF ts_test_data.

    METHODS test_update_quality
      IMPORTING item_data     TYPE ts_test_data
                expected_data TYPE ts_test_data.

  PRIVATE SECTION.
    DATA names TYPE string_table.
ENDCLASS.

CLASS ltcl_unittest IMPLEMENTATION.
  METHOD constructor.
    me->names = names.
  ENDMETHOD.

  METHOD test_update_quality.
    LOOP AT names ASSIGNING FIELD-SYMBOL(<name>).

      DATA(item) = NEW zcldlt_gilded_rose_item( iv_name    = <name>
                                                iv_quality = item_data-quality
                                                iv_sell_in = item_data-sell_in ).

      " when
      NEW zcldlt_gilded_rose4( VALUE #( ( item ) )
          )->update_quality( ).

      " then
      cl_abap_unit_assert=>assert_equals( exp  = <name>
                                          act  = item->mv_name
                                          msg  = |{ <name> }: The name has changed.|
                                          quit = if_Abap_Unit_Constant=>quit-no  ).
      cl_abap_unit_assert=>assert_equals( exp  = expected_data-sell_in
                                          act  = item->mv_sell_in
                                          msg  = |{ <name> }: The sell_in is different.|
                                          quit = if_Abap_Unit_Constant=>quit-no ).
      cl_abap_unit_assert=>assert_equals( exp  = expected_data-quality
                                          act  = item->mv_quality
                                          msg  = |{ <name> }: The quality is different.|
                                          quit = if_Abap_Unit_Constant=>quit-no ).

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_unittest_sulfuras DEFINITION
  INHERITING FROM ltcl_unittest
  FINAL
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PUBLIC SECTION.
    METHODS constructor.

  PRIVATE SECTION.
    METHODS shall_not_be_changed FOR TESTING RAISING cx_static_check cx_dynamic_check.
ENDCLASS.

CLASS ltcl_unittest_sulfuras IMPLEMENTATION.
  METHOD constructor.
    super->constructor( VALUE #( ( |Sulfuras, Hand of Ragnaros| )
                                 ( |Sulfuras, other| )
                                 ( |Sulfuras| ) ) ).
  ENDMETHOD.

  METHOD shall_not_be_changed.
    test_update_quality( item_data     = VALUE #( quality = 80
                                                  sell_in = 0 )
                         expected_data = VALUE #( quality = 80
                                                  sell_in = 0 ) ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_unittest_item DEFINITION
  INHERITING FROM ltcl_unittest
  FINAL
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PUBLIC SECTION.
    METHODS constructor.

  PRIVATE SECTION.
    METHODS shall_be_decreased_by_1 FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_decreased_by_2 FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_not_be_below_0    FOR TESTING RAISING cx_static_check cx_dynamic_check.
ENDCLASS.

CLASS ltcl_unittest_item IMPLEMENTATION.
  METHOD constructor.
    super->constructor( VALUE #( ( |Another item| )
                                 ( |Test item| ) ) ).
  ENDMETHOD.

  METHOD shall_be_decreased_by_1.
    test_update_quality( item_data     = VALUE #( quality = 40
                                                  sell_in = 10 )
                         expected_data = VALUE #( quality = 39
                                                  sell_in = 9 ) ).
    test_update_quality( item_data     = VALUE #( quality = 40
                                                  sell_in = 1 )
                         expected_data = VALUE #( quality = 39
                                                  sell_in = 0 ) ).
  ENDMETHOD.

  METHOD shall_be_decreased_by_2.
    test_update_quality( item_data     = VALUE #( quality = 40
                                                  sell_in = 0 )
                         expected_data = VALUE #( quality = 38
                                                  sell_in = -1 ) ).
    test_update_quality( item_data     = VALUE #( quality = 40
                                                  sell_in = -1 )
                         expected_data = VALUE #( quality = 38
                                                  sell_in = -2 ) ).
  ENDMETHOD.

  METHOD shall_not_be_below_0.
    test_update_quality( item_data     = VALUE #( quality = 0
                                                  sell_in = 10 )
                         expected_data = VALUE #( quality = 0
                                                  sell_in = 9 ) ).
    test_update_quality( item_data     = VALUE #( quality = 0
                                                  sell_in = -1 )
                         expected_data = VALUE #( quality = 0
                                                  sell_in = -2 ) ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_unittest_aged_brie DEFINITION
  INHERITING FROM ltcl_unittest
  FINAL
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PUBLIC SECTION.
    METHODS constructor.

  PRIVATE SECTION.
    METHODS shall_be_increased_by_1 FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_increased_by_2 FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_not_be_over_50    FOR TESTING RAISING cx_static_check cx_dynamic_check.
ENDCLASS.

CLASS ltcl_unittest_aged_brie IMPLEMENTATION.
  METHOD constructor.
    super->constructor( VALUE #( ( |Aged Brie| ) ) ).
  ENDMETHOD.

  METHOD shall_be_increased_by_1.
    test_update_quality( item_data     = VALUE #( quality = 40
                                                  sell_in = 10 )
                         expected_data = VALUE #( quality = 41
                                                  sell_in = 9 ) ).
    test_update_quality( item_data     = VALUE #( quality = 40
                                                  sell_in = 1 )
                         expected_data = VALUE #( quality = 41
                                                  sell_in = 0 ) ).
  ENDMETHOD.

  METHOD shall_be_increased_by_2.
    test_update_quality( item_data     = VALUE #( quality = 40
                                                  sell_in = 0 )
                         expected_data = VALUE #( quality = 42
                                                  sell_in = -1 ) ).
    test_update_quality( item_data     = VALUE #( quality = 40
                                                  sell_in = -1 )
                         expected_data = VALUE #( quality = 42
                                                  sell_in = -2 ) ).
  ENDMETHOD.

  METHOD shall_not_be_over_50.
    test_update_quality( item_data     = VALUE #( quality = 50
                                                  sell_in = 10 )
                         expected_data = VALUE #( quality = 50
                                                  sell_in = 9 ) ).
    test_update_quality( item_data     = VALUE #( quality = 50
                                                  sell_in = -1 )
                         expected_data = VALUE #( quality = 50
                                                  sell_in = -2 ) ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_unittest_backstage_passes DEFINITION
  INHERITING FROM ltcl_unittest
  FINAL
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PUBLIC SECTION.
    METHODS constructor.

  PRIVATE SECTION.
    METHODS shall_be_increased_by_1  FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_increased_by_2  FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_increased_by_3  FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_not_be_over_50     FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_0_after_concert FOR TESTING RAISING cx_static_check cx_dynamic_check.
ENDCLASS.

CLASS ltcl_unittest_backstage_passes IMPLEMENTATION.
  METHOD constructor.
    super->constructor( VALUE #( ( |Backstage passes to a TAFKAL80ETC concert| )
                                 ( |Backstage passes to a concert| )
                                 ( |Backstage passes| ) ) ).
  ENDMETHOD.

  METHOD shall_be_increased_by_1.
    test_update_quality( item_data     = VALUE #( quality = 40
                                                  sell_in = 30 )
                         expected_data = VALUE #( quality = 41
                                                  sell_in = 29 ) ).
    test_update_quality( item_data     = VALUE #( quality = 40
                                                  sell_in = 20 )
                         expected_data = VALUE #( quality = 41
                                                  sell_in = 19 ) ).
    test_update_quality( item_data     = VALUE #( quality = 40
                                                  sell_in = 12 )
                         expected_data = VALUE #( quality = 41
                                                  sell_in = 11 ) ).
    test_update_quality( item_data     = VALUE #( quality = 42
                                                  sell_in = 11 )
                         expected_data = VALUE #( quality = 43
                                                  sell_in = 10 ) ).
  ENDMETHOD.

  METHOD shall_be_increased_by_2.
    test_update_quality( item_data     = VALUE #( quality = 44
                                                  sell_in = 10 )
                         expected_data = VALUE #( quality = 46
                                                  sell_in = 9 ) ).
    test_update_quality( item_data     = VALUE #( quality = 46
                                                  sell_in = 9 )
                         expected_data = VALUE #( quality = 48
                                                  sell_in = 8 ) ).
    test_update_quality( item_data     = VALUE #( quality = 30
                                                  sell_in = 7 )
                         expected_data = VALUE #( quality = 32
                                                  sell_in = 6 ) ).
    test_update_quality( item_data     = VALUE #( quality = 33
                                                  sell_in = 6 )
                         expected_data = VALUE #( quality = 35
                                                  sell_in = 5 ) ).
  ENDMETHOD.

  METHOD shall_not_be_over_50.
    test_update_quality( item_data     = VALUE #( quality = 50
                                                  sell_in = 20 )
                         expected_data = VALUE #( quality = 50
                                                  sell_in = 19 ) ).
  ENDMETHOD.

  METHOD shall_be_increased_by_3.
    test_update_quality( item_data     = VALUE #( quality = 39
                                                  sell_in = 5 )
                         expected_data = VALUE #( quality = 42
                                                  sell_in = 4 ) ).
    test_update_quality( item_data     = VALUE #( quality = 42
                                                  sell_in = 4 )
                         expected_data = VALUE #( quality = 45
                                                  sell_in = 3 ) ).
  ENDMETHOD.

  METHOD shall_be_0_after_concert.
    test_update_quality( item_data     = VALUE #( quality = 50
                                                  sell_in = 0 )
                         expected_data = VALUE #( quality = 0
                                                  sell_in = -1 ) ).
    test_update_quality( item_data     = VALUE #( quality = 0
                                                  sell_in = -1 )
                         expected_data = VALUE #( quality = 0
                                                  sell_in = -2 ) ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_unittest_conjured DEFINITION
  INHERITING FROM ltcl_unittest
  FINAL
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PUBLIC SECTION.
    METHODS constructor.

  PRIVATE SECTION.
    METHODS shall_be_decreased_by_2 FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_decreased_by_4 FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_not_be_below_0    FOR TESTING RAISING cx_static_check cx_dynamic_check.
ENDCLASS.

CLASS ltcl_unittest_conjured IMPLEMENTATION.
  METHOD constructor.
    super->constructor( VALUE #( ( |Conjured Mango| )
                                 ( |Conjured| ) ) ).
  ENDMETHOD.

  METHOD shall_be_decreased_by_2.
    test_update_quality( item_data     = VALUE #( quality = 40
                                                  sell_in = 10 )
                         expected_data = VALUE #( quality = 38
                                                  sell_in = 9 ) ).
    test_update_quality( item_data     = VALUE #( quality = 40
                                                  sell_in = 1 )
                         expected_data = VALUE #( quality = 38
                                                  sell_in = 0 ) ).
  ENDMETHOD.

  METHOD shall_be_decreased_by_4.
    test_update_quality( item_data     = VALUE #( quality = 40
                                                  sell_in = 0 )
                         expected_data = VALUE #( quality = 36
                                                  sell_in = -1 ) ).
    test_update_quality( item_data     = VALUE #( quality = 40
                                                  sell_in = -1 )
                         expected_data = VALUE #( quality = 36
                                                  sell_in = -2 ) ).
  ENDMETHOD.

  METHOD shall_not_be_below_0.
    test_update_quality( item_data     = VALUE #( quality = 0
                                                  sell_in = 10 )
                         expected_data = VALUE #( quality = 0
                                                  sell_in = 9 ) ).
    test_update_quality( item_data     = VALUE #( quality = 0
                                                  sell_in = -1 )
                         expected_data = VALUE #( quality = 0
                                                  sell_in = -2 ) ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_unittest DEFINITION
  ABSTRACT.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING !name TYPE string.

  PROTECTED SECTION.
    METHODS test_update_quality
      IMPORTING quality_exp TYPE i
                sell_in_exp TYPE i
                quality     TYPE i
                sell_in     TYPE i.

  PRIVATE SECTION.
    DATA name TYPE string.
ENDCLASS.

CLASS ltcl_unittest IMPLEMENTATION.
  METHOD test_update_quality.
    " given
    DATA(item) = NEW zcldlt_gilded_rose_item( iv_name    = name
                                              iv_quality = quality
                                              iv_sell_in = sell_in ).
    DATA(test_instance) = NEW zcldlt_gilded_rose( VALUE #( ( item ) ) ).

    " when
    test_instance->update_quality( ).

    " then
    cl_abap_unit_assert=>assert_equals( exp = name
                                        act = item->mv_name
                                        msg = 'Name was changed' ).
    cl_abap_unit_assert=>assert_equals( exp = quality_exp
                                        act = item->mv_quality
                                        msg = 'Quality is different' ).
    cl_abap_unit_assert=>assert_equals( exp = sell_in_exp
                                        act = item->mv_sell_in
                                        msg = 'Sell in value is different' ).
  ENDMETHOD.

  METHOD constructor.
    me->name = name.
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
    METHODS shall_increase_by_1_be_ok      FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_not_be_increased_over_50 FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_increase_by_2_be_ok      FOR TESTING RAISING cx_static_check cx_dynamic_check.
ENDCLASS.

CLASS ltcl_unittest_aged_brie IMPLEMENTATION.
  METHOD shall_increase_by_1_be_ok.
    test_update_quality( quality     = 5
                         quality_exp = 6
                         sell_in     = 5
                         sell_in_exp = 4 ).
  ENDMETHOD.

  METHOD shall_not_be_increased_over_50.
    test_update_quality( quality     = 50
                         quality_exp = 50
                         sell_in     = 5
                         sell_in_exp = 4 ).
  ENDMETHOD.

  METHOD shall_increase_by_2_be_ok.
    test_update_quality( quality     = 4
                         quality_exp = 6
                         sell_in     = 0
                         sell_in_exp = -1 ).
  ENDMETHOD.

  METHOD constructor.
    super->constructor( |Aged Brie| ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_unittest_Sulfuras DEFINITION
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
    super->constructor( |Sulfuras, Hand of Ragnaros| ).
  ENDMETHOD.

  METHOD shall_not_be_changed.
    test_update_quality( quality     = 80
                         quality_exp = 80
                         sell_in     = 0
                         sell_in_exp = 0 ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_unittest_Backstage_passes DEFINITION
  INHERITING FROM ltcl_unittest
  FINAL
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PUBLIC SECTION.
    METHODS constructor.

  PRIVATE SECTION.
    METHODS shall_increase_by_1_be_ok      FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_not_be_increased_over_50 FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_increase_by_2_be_ok      FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_increase_by_3_be_ok      FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_0_after_concert       FOR TESTING RAISING cx_static_check cx_dynamic_check.
ENDCLASS.

CLASS ltcl_unittest_backstage_passes IMPLEMENTATION.
  METHOD constructor.
    super->constructor( |Backstage passes to a TAFKAL80ETC concert| ).
  ENDMETHOD.

  METHOD shall_be_0_after_concert.
    test_update_quality( quality     = 40
                         quality_exp = 0
                         sell_in     = 0
                         sell_in_exp = -1 ).
  ENDMETHOD.

  METHOD shall_increase_by_1_be_ok.
    test_update_quality( quality     = 40
                         quality_exp = 41
                         sell_in     = 20
                         sell_in_exp = 19 ).
  ENDMETHOD.

  METHOD shall_increase_by_2_be_ok.
    test_update_quality( quality     = 8
                         quality_exp = 10
                         sell_in     = 10
                         sell_in_exp = 9 ).
  ENDMETHOD.

  METHOD shall_increase_by_3_be_ok.
    test_update_quality( quality     = 15
                         quality_exp = 18
                         sell_in     = 5
                         sell_in_exp = 4 ).
  ENDMETHOD.

  METHOD shall_not_be_increased_over_50.
    test_update_quality( quality     = 50
                         quality_exp = 50
                         sell_in     = 35
                         sell_in_exp = 34 ).
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
    METHODS shall_decrease_by_1_be_ok     FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_not_be_dereased_under_0 FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_decrease_by_2_be_ok     FOR TESTING RAISING cx_static_check cx_dynamic_check.
ENDCLASS.

CLASS ltcl_unittest_item IMPLEMENTATION.
  METHOD constructor.
    super->constructor( |Any other item| ).
  ENDMETHOD.

  METHOD shall_decrease_by_1_be_ok.
    test_update_quality( quality     = 30
                         quality_exp = 29
                         sell_in     = 35
                         sell_in_exp = 34 ).
  ENDMETHOD.

  METHOD shall_decrease_by_2_be_ok.
    test_update_quality( quality     = 23
                         quality_exp = 21
                         sell_in     = 0
                         sell_in_exp = -1 ).
  ENDMETHOD.

  METHOD shall_not_be_dereased_under_0.
    test_update_quality( quality     = 0
                         quality_exp = 0
                         sell_in     = 10
                         sell_in_exp = 9 ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_unittest_Backstagepasses1 DEFINITION
  INHERITING FROM ltcl_unittest
  FINAL
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PUBLIC SECTION.
    METHODS constructor.

  PRIVATE SECTION.
    METHODS shall_increase_by_1_be_ok      FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_not_be_increased_over_50 FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_increase_by_2_be_ok      FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_increase_by_3_be_ok      FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_0_after_concert       FOR TESTING RAISING cx_static_check cx_dynamic_check.
ENDCLASS.

CLASS ltcl_unittest_backstagepasses1 IMPLEMENTATION.
  METHOD constructor.
    super->constructor( |Backstage passes to| ).
  ENDMETHOD.

  METHOD shall_be_0_after_concert.
    test_update_quality( quality     = 40
                         quality_exp = 0
                         sell_in     = 0
                         sell_in_exp = -1 ).
  ENDMETHOD.

  METHOD shall_increase_by_1_be_ok.
    test_update_quality( quality     = 40
                         quality_exp = 41
                         sell_in     = 20
                         sell_in_exp = 19 ).
  ENDMETHOD.

  METHOD shall_increase_by_2_be_ok.
    test_update_quality( quality     = 8
                         quality_exp = 10
                         sell_in     = 10
                         sell_in_exp = 9 ).
  ENDMETHOD.

  METHOD shall_increase_by_3_be_ok.
    test_update_quality( quality     = 15
                         quality_exp = 18
                         sell_in     = 5
                         sell_in_exp = 4 ).
  ENDMETHOD.

  METHOD shall_not_be_increased_over_50.
    test_update_quality( quality     = 50
                         quality_exp = 50
                         sell_in     = 35
                         sell_in_exp = 34 ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_unittest_Sulfuras1 DEFINITION
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

CLASS ltcl_unittest_sulfuras1 IMPLEMENTATION.
  METHOD constructor.
    super->constructor( |Sulfuras Ragnaros| ).
  ENDMETHOD.

  METHOD shall_not_be_changed.
    test_update_quality( quality     = 80
                         quality_exp = 80
                         sell_in     = 0
                         sell_in_exp = 0 ).
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
    METHODS shall_decrease_by_2_be_ok     FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_not_be_dereased_under_0 FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_decrease_by_4_be_ok     FOR TESTING RAISING cx_static_check cx_dynamic_check.
ENDCLASS.

CLASS ltcl_unittest_conjured IMPLEMENTATION.
  METHOD constructor.
    super->constructor( |Conjured Mangos| ).
  ENDMETHOD.

  METHOD shall_decrease_by_2_be_ok.
    test_update_quality( quality     = 30
                         quality_exp = 28
                         sell_in     = 35
                         sell_in_exp = 34 ).
  ENDMETHOD.

  METHOD shall_decrease_by_4_be_ok.
    test_update_quality( quality     = 23
                         quality_exp = 19
                         sell_in     = 0
                         sell_in_exp = -1 ).
  ENDMETHOD.

  METHOD shall_not_be_dereased_under_0.
    test_update_quality( quality     = 0
                         quality_exp = 0
                         sell_in     = 10
                         sell_in_exp = 9 ).
  ENDMETHOD.
ENDCLASS.

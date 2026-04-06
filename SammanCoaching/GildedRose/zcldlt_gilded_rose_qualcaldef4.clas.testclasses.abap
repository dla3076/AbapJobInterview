CLASS ltcl_unittest DEFINITION
  FINAL
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PRIVATE SECTION.
    METHODS shall_be_1       FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_2       FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_5       FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_10      FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_minus_1 FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_minus_2 FOR TESTING RAISING cx_static_check cx_dynamic_check.

    METHODS test_calculate
      IMPORTING test_instance TYPE REF TO zifdlt_gilded_rose_qual_cal4
                quality_exp   TYPE i
                sell_in       TYPE i.
ENDCLASS.

CLASS ltcl_unittest IMPLEMENTATION.
  METHOD shall_be_1.
    test_calculate( test_instance = NEW zcldlt_gilded_rose_qualcaldef4( factor = 1 )
                    quality_exp   = 1
                    sell_in       = 1 ).
  ENDMETHOD.

  METHOD shall_be_10.
    test_calculate( test_instance = NEW zcldlt_gilded_rose_qualcaldef4( quality_change = VALUE #( default       = 1
                                                                                                  after_sell_in = 5 )
                                                                        factor         = 2 )
                    quality_exp   = 10
                    sell_in       = -1 ).
  ENDMETHOD.

  METHOD shall_be_2.
    test_calculate( test_instance = NEW zcldlt_gilded_rose_qualcaldef4( factor = 1 )
                    quality_exp   = 2
                    sell_in       = -1 ).
  ENDMETHOD.

  METHOD shall_be_5.
    test_calculate( test_instance = NEW zcldlt_gilded_rose_qualcaldef4( quality_change = VALUE #( default       = 5
                                                                                                  after_sell_in = 3 )
                                                                        factor         = 1 )
                    quality_exp   = 5
                    sell_in       = 1 ).
  ENDMETHOD.

  METHOD test_calculate.
    " when
    DATA(quality_act) = test_instance->calculate( VALUE #( sell_in = sell_in
                                                           quality = 50 ) ).

    " then
    cl_abap_unit_assert=>assert_equals( exp = quality_exp
                                        act = quality_act ).
  ENDMETHOD.

  METHOD shall_be_minus_1.
    test_calculate( test_instance = NEW zcldlt_gilded_rose_qualcaldef4( )
                    quality_exp   = -1
                    sell_in       = 1 ).
  ENDMETHOD.

  METHOD shall_be_minus_2.
    test_calculate( test_instance = NEW zcldlt_gilded_rose_qualcaldef4( )
                    quality_exp   = -2
                    sell_in       = -1 ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_unittest DEFINITION
  FINAL
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PRIVATE SECTION.
    METHODS shall_be_1        FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_2        FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_3        FOR TESTING RAISING cx_static_check cx_dynamic_check.
    METHODS shall_be_minus_10 FOR TESTING RAISING cx_static_check cx_dynamic_check.

    METHODS test_calculate
      IMPORTING quality_exp TYPE i
                sell_in     TYPE i.
ENDCLASS.

CLASS ltcl_unittest IMPLEMENTATION.
  METHOD shall_be_1.
    test_calculate( quality_exp = 1
                    sell_in     = 30 ).
  ENDMETHOD.

  METHOD shall_be_minus_10.
    test_calculate( quality_exp = -10
                    sell_in     = -1 ).
  ENDMETHOD.

  METHOD shall_be_2.
    test_calculate( quality_exp = 2
                    sell_in     = 9 ).
  ENDMETHOD.

  METHOD shall_be_3.
    test_calculate( quality_exp = 3
                    sell_in     = 4 ).
  ENDMETHOD.

  METHOD test_calculate.
    " when
    DATA(quality_act) = NEW zcldlt_gilded_rose_qualcalsca4( VALUE #( ( sell_in_less_than = 5
                                                                       quality_to_change = 3 )
                                                                     ( sell_in_less_than = 10
                                                                       quality_to_change = 2 ) )
        )->zifdlt_gilded_rose_qual_cal4~calculate( VALUE #( quality = 10
                                                            sell_in = sell_in ) ).

    " then
    cl_abap_unit_assert=>assert_equals( exp = quality_exp
                                        act = quality_act ).
  ENDMETHOD.
ENDCLASS.

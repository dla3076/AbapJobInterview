*& Hi and welcome to team Gilded Rose. As you know, we are a small inn with
*& a prime location in a prominent city ran by a friendly innkeeper named
*& Allison. We also buy and sell only the finest goods. Unfortunately, our
*& goods are constantly degrading in quality as they approach their sell by
*& date. We have a system in place that updates our inventory for us. It
*& was developed by a no-nonsense type named Leeroy, who has moved on to
*& new adventures. Your task is to add the new feature to our system so that
*& we can begin selling a new category of items.
*&
*& First an introduction to our system:
*&
*&  - All items have a Sell In value which denotes the number of
*&           days we have to sell the item
*&  - All items have a Quality value which denotes how valuable the item is
*&  - At the end of each day our system lowers both values for every item
*&
*& Seems pretty simple, right? Well this is where it gets interesting:
*&
*&  - Once the sell by date has passed, Quality degrades twice as fast
*&  - The Quality of an item is never negative
*&  - "Aged Brie" actually increases in Quality the older it gets
*&  - The Quality of an item is never more than 50
*&  - "Sulfuras", being a legendary item, never has to be sold or
*&           decreases in Quality
*&  - "Backstage passes", like aged brie, increases in Quality as its
*&           Sell In value approaches; Quality increases by 2 when there
*&           are 10 days or less and by 3 when there are 5 days or less
*&           but Quality drops to 0 after the concert
*&
*& We have recently signed a supplier of conjured items. This requires an
*& update to our system:
*&
*&  - "Conjured" items degrade in Quality twice as fast as normal items
*&
*& Feel free to make any changes to the Update Quality method and add any new
*& code as long as everything still works correctly. However, do not alter
*& the Item class directly or Items table attribute as those belong to the
*& goblin in the corner who will insta-rage and one-shot you as he doesn't
*& believe in shared code ownership (you can make the Update Quality method
*& and Items property static if you must, we'll cover for you).
*&
*& Just for clarification, an item can never have its Quality increase
*& above 50, however "Sulfuras" is a legendary item and as such its Quality
*& is 80 and it never alters.
"! <p class="shorttext synchronized">Gilded Rose</p>
CLASS zcldlt_gilded_rose4 DEFINITION
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
             regular_expression TYPE string,
             decrease_sell_in   TYPE int4,
             quality_calculator TYPE REF TO zifdlt_gilded_rose_qual_cal4,
           END OF ts_rule.

    CLASS-DATA rules TYPE STANDARD TABLE OF ts_rule WITH EMPTY KEY.

    CLASS-METHODS build_rules.

    DATA mt_items TYPE tt_items.

    METHODS update_item
      IMPORTING item TYPE REF TO zcldlt_gilded_rose_item.

    METHODS check_rule_to_update_item
      IMPORTING item             TYPE REF TO zcldlt_gilded_rose_item
                rule             TYPE zcldlt_gilded_rose4=>ts_rule
      RETURNING VALUE(processed) TYPE abap_bool.

    METHODS decrease_sell_in
      IMPORTING item     TYPE REF TO zcldlt_gilded_rose_item
                decrease TYPE ts_rule-decrease_sell_in.

    METHODS change_quality
      IMPORTING item              TYPE REF TO zcldlt_gilded_rose_item
                quality_to_change TYPE i.

    METHODS map_item
      IMPORTING item                    TYPE REF TO zcldlt_gilded_rose_item
      RETURNING VALUE(item_calculation) TYPE zifdlt_gilded_rose_qual_cal4=>ts_item.
ENDCLASS.

CLASS zcldlt_gilded_rose4 IMPLEMENTATION.
  METHOD class_constructor.
    build_rules( ).
  ENDMETHOD.

  METHOD constructor.
    mt_items = it_items.
  ENDMETHOD.

  METHOD update_quality.
    LOOP AT mt_items ASSIGNING FIELD-SYMBOL(<item>).

      update_item( <item> ).

    ENDLOOP.
  ENDMETHOD.

  METHOD update_item.
    LOOP AT rules ASSIGNING FIELD-SYMBOL(<rule>).

      IF check_rule_to_update_item( item = item
                                    rule = <rule> ).

        EXIT.

      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD decrease_sell_in.
    CHECK decrease > 0.

    item->mv_sell_in -= decrease.
  ENDMETHOD.

  METHOD change_quality.
    CHECK quality_to_change <> 0.

    item->mv_quality += quality_to_change.
    item->mv_quality  = nmax( val1 = 0 " The Quality of an item is never negative
                              val2 = nmin( val1 = 50 " The Quality of an item is never more than 50
                                           val2 = item->mv_quality ) ).
  ENDMETHOD.

  METHOD check_rule_to_update_item.
    CHECK count( val  = item->mv_name
                 pcre = rule-regular_expression ) = 1.

    decrease_sell_in( item     = item
                      decrease = rule-decrease_sell_in ).
    change_quality( item              = item
                    quality_to_change = rule-quality_calculator->calculate( map_item( item ) ) ).
    processed = abap_true.
  ENDMETHOD.

  METHOD build_rules.
    DATA(quality_change) = VALUE zcldlt_gilded_rose_qualcaldef4=>ts_quality_change( default       = 1
                                                                                    after_sell_in = 2 ).

    rules = VALUE #( ( regular_expression = `^Sulfuras` " Evertyhing which starts with Sulfuras
                       quality_calculator = NEW zcldlt_gilded_rose_qualcalno4( ) )
                     decrease_sell_in = 1
                     ( regular_expression = `^Backstage\spasses` " Evertyhing which starts with Backstage passes
                       quality_calculator = NEW zcldlt_gilded_rose_qualcalsca4( default_quality = quality_change-default
                                                                                scalings        = VALUE #(
                                                                                    ( sell_in_less_than = 5
                                                                                      quality_to_change = 3 )
                                                                                    ( sell_in_less_than = 10
                                                                                      quality_to_change = 2 ) ) ) )
                     ( regular_expression = `^Aged\sBrie$` " Only Aged Brie
                       quality_calculator = NEW zcldlt_gilded_rose_qualcaldef4( quality_change = quality_change
                                                                                factor         = 1 ) )
                     ( regular_expression = `^Conjured` " Evertyhing which starts with Conjured
                       quality_calculator = NEW zcldlt_gilded_rose_qualcaldef4( quality_change = quality_change
                                                                                factor         = -2 ) )
                     ( regular_expression = `^.*$` " Has to be the last one, because it's the default
                       quality_calculator = NEW zcldlt_gilded_rose_qualcaldef4( quality_change = quality_change
                                                                                factor         = -1 ) ) ).
  ENDMETHOD.

  METHOD map_item.
    item_calculation = VALUE #( sell_in = item->mv_sell_in
                                quality = item->mv_quality ).
  ENDMETHOD.
ENDCLASS.

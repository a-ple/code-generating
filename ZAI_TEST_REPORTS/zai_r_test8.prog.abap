REPORT zai_r_test8.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  PARAMETERS: p_wapos TYPE char16 OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  "" Refactored code start
  "" Replaced direct table MPOS by CDS view I_MaintenanceItemBasic
  SELECT plnty AS TaskListType, plnnr AS TaskListGroup, plnal AS TaskListGroupCounter
    FROM I_MaintenanceItemBasic
    INTO TABLE @DATA(lt_mpos)
    WHERE wapos = @p_wapos.

  IF sy-subrc = 0.
    LOOP AT lt_mpos ASSIGNING FIELD-SYMBOL(<ls_mpos>).
      DATA lt_item TYPE TABLE OF I_MaintenanceItemBasic.
      APPEND <ls_mpos> TO lt_item.
    ENDLOOP.
  ELSE.
    MESSAGE 'No data found in I_MaintenanceItemBasic view' TYPE 'I'.
  ENDIF.

  "" Unchanged code section retained
  SELECT SINGLE equipment, division, material
    FROM i_equipment INTO @DATA(ls_equipment).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in Equipment' TYPE 'I'.
  ENDIF.

  IF lt_item IS NOT INITIAL.
    "" Refactored code start
    "" Replace direct table PLKZ by CDS view I_BillOfOperations
    SELECT abdat AS LastUsageDate, abanz AS NumberOfUsages
      FROM I_BillOfOperations
      INTO TABLE @DATA(lt_plkz)
      FOR ALL ENTRIES IN @lt_item
      WHERE plnty = @lt_item-TaskListType
      AND plnnr = @lt_item-TaskListGroup
      AND plnal = @lt_item-TaskListGroupCounter.

    IF sy-subrc <> 0.
      MESSAGE 'No data found in I_BillOfOperations view' TYPE 'I'.
    ENDIF.
    "" Refactored code end
  ENDIF.

  "" Refactored code end

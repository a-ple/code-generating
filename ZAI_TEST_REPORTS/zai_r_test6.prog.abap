REPORT zai_r_test6.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  PARAMETERS: p_wapos TYPE char16 OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  "" Refactored code start
  "" Replace direct access to MPOS table with CDS view I_MaintenanceItemBasic
  SELECT TaskListType, TaskListGroup, TaskListGroupCounter
    FROM I_MaintenanceItemBasic INTO TABLE @DATA(lt_mpos)
    WHERE MaintenanceItem = @p_wapos.

  IF sy-subrc = 0.
    LOOP AT lt_mpos ASSIGNING FIELD-SYMBOL(<ls_mpos>).
      " Local internal table to collect items for later use with FOR ALL ENTRIES
      DATA lt_item TYPE TABLE OF I_MaintenanceItemBasic.
      APPEND <ls_mpos> TO lt_item.
    ENDLOOP.
  ELSE.
    MESSAGE 'No data found in Maintenance Item Basic' TYPE 'I'.
  ENDIF.

  "" Unchanged code section - retained as in original
  SELECT SINGLE equipment, division, material
    FROM i_equipment INTO @DATA(ls_equipment).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in Equipment' TYPE 'I'.
  ENDIF.

  IF lt_item IS NOT INITIAL.
    "" Refactored code start
    "" Replace direct access to PLKZ table with CDS view I_BillOfOperations
    SELECT LastUsageDate, NumberOfUsages
      FROM I_BillOfOperations INTO TABLE @DATA(lt_plkz)
      FOR ALL ENTRIES IN @lt_item
      WHERE BillOfOperationsType = @lt_item-TaskListType
      AND BillOfOperationsGroup = @lt_item-TaskListGroup
      AND BillOfOperationsVariant = @lt_item-TaskListGroupCounter.

    IF sy-subrc <> 0.
      MESSAGE 'No data found in Bill of Operations' TYPE 'I'.
    ENDIF.
    "" Refactored code end
  ENDIF.

  "" Refactored code end

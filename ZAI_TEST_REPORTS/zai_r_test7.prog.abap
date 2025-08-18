REPORT zai_r_test7.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  PARAMETERS: p_wapos TYPE char16 OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  "" Refactored code start
  "" Replace access to table MPOS by CDS view I_MaintenanceItemBasic
  SELECT plnty, plnnr, plnal
    FROM I_MaintenanceItemBasic INTO TABLE @DATA(lt_mpos)
    WHERE MaintenanceItem = @p_wapos.

  IF sy-subrc = 0.
    LOOP AT lt_mpos ASSIGNING FIELD-SYMBOL(<ls_mpos>).
      DATA lt_item TYPE TABLE OF I_MaintenanceItemBasic.
      APPEND <ls_mpos> TO lt_item.
    ENDLOOP.
  ELSE.
    MESSAGE 'No data found in MaintenanceItemBasic view' TYPE 'I'.
  ENDIF.

  "" Unchanged section retained from original report
  SELECT SINGLE equipment, division, material
    FROM i_equipment INTO @DATA(ls_equipment).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in Equipment' TYPE 'I'.
  ENDIF.

  IF lt_item IS NOT INITIAL.
    "" Refactored code start
    "" Replace access to PLKZ table with CDS view I_BillOfOperations
    SELECT abdat, abanz
      FROM I_BillOfOperations INTO TABLE @DATA(lt_plkz)
      FOR ALL ENTRIES IN @lt_item
      WHERE OperationType = @lt_item-plnty
        AND OperationNumber = @lt_item-plnnr
        AND OperationSubNumber = @lt_item-plnal.

    IF sy-subrc <> 0.
      MESSAGE 'No data found in BillOfOperations view' TYPE 'I'.
    ENDIF.
    "" Refactored code end
  ENDIF.

  "" Refactored code end

REPORT zai_r_test12.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_wapos TYPE char16 OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

*----------------------------------------------------------------*
* Changed part: Use CDS view I_MaintenanceItemBasic instead of MPOS
*----------------------------------------------------------------*
  SELECT plnty    AS TaskListType,
         plnnr    AS TaskListGroup,
         plnal    AS TaskListGroupCounter
    FROM I_MaintenanceItemBasic
    INTO TABLE @DATA(lt_mpos)
    WHERE wapos = @p_wapos.

  IF sy-subrc = 0.
    DATA lt_item TYPE TABLE OF I_MaintenanceItemBasic.
    LOOP AT lt_mpos ASSIGNING FIELD-SYMBOL(<ls_mpos>).
      APPEND <ls_mpos> TO lt_item.
    ENDLOOP.
  ELSE.
    MESSAGE 'No data found in I_MaintenanceItemBasic CDS view' TYPE 'I'.
  ENDIF.

*----------------------------------------------------------------*
* Unchanged part: SELECT SINGLE from i_equipment remains unchanged
*----------------------------------------------------------------*
  SELECT SINGLE equipment, division, material
    FROM i_equipment
    INTO @DATA(ls_equipment).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in Equipment' TYPE 'I'.
  ENDIF.

*----------------------------------------------------------------*
* Changed part: Use CDS view I_BillOfOperations instead of PLKZ
*----------------------------------------------------------------*
  IF lt_item IS NOT INITIAL.
    SELECT LastUsageDate   AS abdat,
           NumberOfUsages  AS abanz
      FROM I_BillOfOperations
      INTO TABLE @DATA(lt_plkz)
      FOR ALL ENTRIES IN @lt_item
      WHERE BillOfOperationsType   = @lt_item-TaskListType
        AND BillOfOperationsGroup  = @lt_item-TaskListGroup
        AND BillOfOperationsVariant= @lt_item-TaskListGroupCounter.

    IF sy-subrc <> 0.
      MESSAGE 'No data found in I_BillOfOperations CDS view' TYPE 'I'.
    ENDIF.
  ENDIF.

*----------------------------------------------------------------*
* Changed part: Use CDS view ZI_PRT_TEXT instead of CRTX
*----------------------------------------------------------------*
  SELECT ObjectType AS objty,
         ObjectId   AS objid,
         ChangeDateText AS aedat_text
    FROM ZI_PRT_TEXT
    INTO TABLE @DATA(lt_crtx)
    WHERE Language = 'E'.

  IF sy-subrc = 0.
*----------------------------------------------------------------*
* Changed part: Use CDS view ZI_PRT_MASTERDATA instead of CRFH
*----------------------------------------------------------------*
    SELECT MaterialNumber AS fhmar,
           DeleteIndicator AS loekz,
           SpecialStockIndicator AS steuf
      FROM ZI_PRT_MASTERDATA
      INTO TABLE @DATA(lt_crfh)
      FOR ALL ENTRIES IN @lt_crtx
      WHERE ObjectType = @lt_crtx-ObjectType
        AND ObjectId   = @lt_crtx-ObjectId.
  ENDIF.

REPORT zai_r_test11.

" SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
" PARAMETERS: p_wapos  TYPE char16 OBLIGATORY.
" SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  " Refactored SELECT statement for MPOS replaced with I_MaintenanceItemBasic CDS view
  SELECT MaintenanceItem, MaintenancePlannerGroup, MaintenancePlanningPlant, TaskListType, TaskListGroup, TaskListGroupCounter, Equipment
    FROM I_MaintenanceItemBasic
    INTO TABLE @DATA(lt_mpos)
    WHERE MaintenanceItem = @p_wapos.

  IF sy-subrc = 0.
    " Assign and process lt_mpos as per original logic
  ELSE.
    MESSAGE 'No data found in I_MaintenanceItemBasic CDS view' TYPE 'I'.
  ENDIF.

  " Refactored SELECT statement for PLKZ replaced with I_BillOfOperations CDS view
  IF lt_mpos IS NOT INITIAL.
    SELECT BillOfOperationsType, BillOfOperationsGroup, BillOfOperationsVariant, LastUsageDate, NumberOfUsages
      FROM I_BillOfOperations
      FOR ALL ENTRIES IN @lt_mpos
      WHERE BillOfOperationsType = @lt_mpos-TaskListType
        AND BillOfOperationsGroup = @lt_mpos-TaskListGroup
        AND BillOfOperationsVariant = @lt_mpos-TaskListGroupCounter
      INTO TABLE @DATA(lt_plkz).

    IF sy-subrc <> 0.
      MESSAGE 'No data found in I_BillOfOperations CDS view' TYPE 'I'.
    ENDIF.
  ENDIF.

  " Refactored SELECT statement for CRTX replaced with ZI_PRT_TEXT CDS view
  SELECT ObjectType, ObjectId, Language, ChangeDateText, ChangedByUserText, Text, TextUppercase
    FROM ZI_PRT_TEXT
    INTO TABLE @DATA(lt_crtx)
    WHERE Language = 'E'.

  IF sy-subrc <> 0.
    MESSAGE 'No data found in ZI_PRT_TEXT CDS view' TYPE 'I'.
  ENDIF.

  " Refactored SELECT statement for CRFH replaced with ZI_PRT_MASTERDATA CDS view using FOR ALL ENTRIES from lt_crtx
  IF lt_crtx IS NOT INITIAL.
    SELECT ObjectType, ObjectId, CountValue, MaterialNumber, ObjectTypeVariant, ObjectIdVariant, DeleteIndicator,
           ValidFromDate, ValidToDate, ChangeNumber, ChangedByUser, ChangedAt, ChangeName, ChangeDate, FunctionalArea,
           Status, IndicatorKzkbl, Plant, StorageLocation, BaseUnit, SpecialStockIndicator, SpecialStockReference,
           FunctionalArea1, FunctionalArea2, PlanningVersion, SchedulingType, SchedulingTypeReference, OffsetWritingOff,
           OffsetWritingOffReference, OffsetUnit, OffsetUnitReference, OffsetUnitRef, Bzoffe, BzoffeRef, Offste, Ehoffe,
           OffsteRef, Mgform, MgformRef, Ewform, EwformRef, Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
           Parameter06, ParameterUnit01, ParameterUnit02, ParameterUnit03, ParameterUnit04, ParameterUnit05, ParameterUnit06,
           ParameterValue01, ParameterValue02, ParameterValue03, ParameterValue04, ParameterValue05, ParameterValue06, Registrable
      FROM ZI_PRT_MASTERDATA
      FOR ALL ENTRIES IN @lt_crtx
      WHERE ObjectType = @lt_crtx-ObjectType
        AND ObjectId = @lt_crtx-ObjectId
      INTO TABLE @DATA(lt_crfh).
  ENDIF.

  " Further processing logic unchanged

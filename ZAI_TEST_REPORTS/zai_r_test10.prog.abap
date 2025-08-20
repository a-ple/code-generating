REPORT zai_r_test10.

" Selection screen and other unchanged code parts
* SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
* PARAMETERS: p_wapos  TYPE char16 OBLIGATORY.
* SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  " Refactored SELECT from I_MaintenanceItemBasic CDS view replacing MPOS table
  SELECT MaintenanceItem, MaintenancePlannerGroup, MaintenancePlanningPlant, TaskListType, TaskListGroup, TaskListGroupCounter, Equipment
    FROM I_MaintenanceItemBasic
    INTO TABLE @DATA(lt_item_basic)
    WHERE MaintenanceItem = @p_wapos.

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_MaintenanceItemBasic CDS view' TYPE 'I'.
  ENDIF.

  " Refactored SELECT from I_BillOfOperations CDS view replacing PLKZ table
  IF lt_item_basic IS NOT INITIAL.
    SELECT BillOfOperationsType, BillOfOperationsGroup, BillOfOperationsVariant, LastUsageDate, NumberOfUsages
      FROM I_BillOfOperations
      FOR ALL ENTRIES IN @lt_item_basic
      WHERE BillOfOperationsType = @lt_item_basic-TaskListType
        AND BillOfOperationsGroup = @lt_item_basic-TaskListGroup
        AND BillOfOperationsVariant = @lt_item_basic-TaskListGroupCounter
      INTO TABLE @DATA(lt_bill_operations).

    IF sy-subrc <> 0.
      MESSAGE 'No data found in I_BillOfOperations CDS view' TYPE 'I'.
    ENDIF.
  ENDIF.

  " Refactored SELECT from ZI_PRT_TEXT CDS view replacing CRTX table
  SELECT ObjectType, ObjectId, Language, ChangeDateText, ChangedByUserText, Text, TextUppercase
    FROM ZI_PRT_TEXT
    INTO TABLE @DATA(lt_text_data)
    WHERE Language = 'E'.

  IF sy-subrc <> 0.
    MESSAGE 'No data found in ZI_PRT_TEXT CDS view' TYPE 'I'.
  ENDIF.

  " Refactored SELECT from ZI_PRT_MASTERDATA CDS view replacing CRFH table using FOR ALL ENTRIES from lt_text_data
  IF lt_text_data IS NOT INITIAL.
    SELECT ObjectType, ObjectId, CountValue, MaterialNumber, ObjectTypeVariant, ObjectIdVariant, DeleteIndicator,
           ValidFromDate, ValidToDate, ChangeNumber, ChangedByUser, ChangedAt, ChangeName, ChangeDate, FunctionalArea,
           Status, IndicatorKzkbl, Plant, StorageLocation, BaseUnit, SpecialStockIndicator, SpecialStockReference,
           FunctionalArea1, FunctionalArea2, PlanningVersion, SchedulingType, SchedulingTypeReference, OffsetWritingOff,
           OffsetWritingOffReference, OffsetUnit, OffsetUnitReference, OffsetUnitRef, Bzoffe, BzoffeRef, Offste, Ehoffe,
           OffsteRef, Mgform, MgformRef, Ewform, EwformRef, Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
           Parameter06, ParameterUnit01, ParameterUnit02, ParameterUnit03, ParameterUnit04, ParameterUnit05, ParameterUnit06,
           ParameterValue01, ParameterValue02, ParameterValue03, ParameterValue04, ParameterValue05, ParameterValue06, Registrable
      FROM ZI_PRT_MASTERDATA
      FOR ALL ENTRIES IN @lt_text_data
      WHERE ObjectType = @lt_text_data-ObjectType
        AND ObjectId = @lt_text_data-ObjectId
      INTO TABLE @DATA(lt_master_data).
  ENDIF.

  " Further processing of lt_item_basic, lt_bill_operations, lt_text_data, lt_master_data as per existing report logic.

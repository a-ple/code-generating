REPORT zai_r_test1.

" Refactored report replacing direct table accesses with SAP standard CDS views

START-OF-SELECTION.

  " SELECT SINGLE from CDS view for MARA table replacement
  SELECT SINGLE matnr, ersda
    FROM i_mara_cds_view INTO @DATA(ls_mara).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in MARA CDS view' TYPE 'I'.
  ENDIF.

  " SELECT SINGLE from CDS view for VBAK table replacement
  SELECT SINGLE vbeln, audat, auart
    FROM i_vbak_cds_view INTO @DATA(ls_vbak).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in VBAK CDS view TYPE 'I'.
  ENDIF.

  " SELECT SINGLE from CDS view for Equipment table replacement
  SELECT SINGLE Equipment, Division, Material
    FROM i_equipment_cds_view INTO @DATA(ls_equipment).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in Equipment CDS view' TYPE 'I'.
  ENDIF.
REPORT zai_r_test1.

" Refactored report replacing direct table accesses with SAP standard CDS views

START-OF-SELECTION.

  " Refactored select from MARA replaced by standard CDS view I_MARA_CDS
  SELECT SINGLE matnr, ersda
    FROM i_mara_cds INTO @DATA(ls_mara).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in MARA CDS view' TYPE 'I'.
  ENDIF.

  " Refactored select from VBAK replaced by standard CDS view I_VBAK_CDS
  SELECT SINGLE vbeln, audat, auart
    FROM i_vbak_cds INTO @DATA(ls_vbak).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in VBAK CDS view' TYPE 'I'.
  ENDIF.

  " Refactored select from Equipment replaced by standard CDS view I_EQUIPMENT_CDS
  SELECT SINGLE Equipment, Division, Material
    FROM i_equipment_cds INTO @DATA(ls_equipment).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in Equipment CDS view' TYPE 'I'.
  ENDIF.
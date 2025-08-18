REPORT zai_r_test5.

START-OF-SELECTION.

  " Select from CDS view I_Product instead of MARA table
  SELECT SINGLE product, createdbyuser, creationdate
    FROM i_product
    INTO @DATA(ls_product).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_Product CDS view' TYPE 'I'.
  ENDIF.

  " Select from CDS view I_SalesDocumentBasic instead of VBAK table
  SELECT SINGLE salesdocument, salesdocumenttype
    FROM i_salesdocumentbasic
    INTO @DATA(ls_salesdoc)
    WHERE salesdocumentdate = @sy-datum.

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_SalesDocumentBasic CDS view' TYPE 'I'.
  ENDIF.

  " Originally querying I_Equipment, left unchanged - out of scope
  SELECT SINGLE equipment, division, material
    FROM i_equipment
    INTO @DATA(ls_equipment).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in Equipment' TYPE 'I'.
  ENDIF.

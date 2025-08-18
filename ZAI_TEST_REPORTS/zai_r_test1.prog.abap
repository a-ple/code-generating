REPORT zai_r_test1.

START-OF-SELECTION.

  " Select single record from I_Product CDS view instead of MARA table
  SELECT SINGLE ProductUUID, CreationDate
    FROM I_Product
    INTO @DATA(ls_product).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_Product CDS view' TYPE 'I'.
  ENDIF.

  " Select single record from I_SalesDocumentBasic CDS view instead of VBAK table
  SELECT SINGLE SalesDocumentID, DocumentDate
    FROM I_SalesDocumentBasic
    INTO @DATA(ls_salesdoc).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_SalesDocumentBasic CDS view TYPE 'I'.
  ENDIF.

REPORT zai_r_test1.

START-OF-SELECTION.

  " Select data from CDS view I_Product instead of MARA table
  SELECT SINGLE Product, CreationDateTime
    FROM I_Product
    INTO @DATA(ls_product).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_Product CDS view' TYPE 'I'.
  ENDIF.

  " Select data from CDS view I_SalesDocumentBasic instead of VBAK table
  SELECT SINGLE SalesDocument, CreationDate
    FROM I_SalesDocumentBasic
    INTO @DATA(ls_salesdocument).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_SalesDocumentBasic CDS view' TYPE 'I'.
  ENDIF.

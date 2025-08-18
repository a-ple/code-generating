REPORT zai_r_test1.

START-OF-SELECTION.

  " Select from I_Product CDS view instead of MARA
  SELECT SINGLE Product, CreationDateTime
    FROM I_Product
    INTO @DATA(ls_product).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_Product CDS view' TYPE 'I'.
  ENDIF.

  " Select from I_SalesDocumentBasic CDS view instead of VBAK
  SELECT SINGLE SalesDocument, SalesDocumentDate
    FROM I_SalesDocumentBasic
    INTO @DATA(ls_salesdoc).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_SalesDocumentBasic CDS view TYPE 'I'.
  ENDIF.

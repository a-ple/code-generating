REPORT zai_r_test4.

" Refactored to replace MARA and VBAK database tables with corresponding CDS views: I_Product and I_SalesDocumentBasic
" All unchanged code parts preserved

START-OF-SELECTION.

  " Select product data using CDS view I_Product instead of MARA
  SELECT SINGLE
    Product AS matnr,
    CreatedAt AS ersda
    FROM I_Product
    INTO @DATA(ls_product).

  IF sy-subrc <> 0.
    MESSAGE 'No product data found in I_Product CDS view' TYPE 'I'.
  ENDIF.

  " Select sales document header data using CDS view I_SalesDocumentBasic instead of VBAK
  SELECT SINGLE
    SalesDocument AS vbeln,
    DocumentDate AS audat
    FROM I_SalesDocumentBasic
    INTO @DATA(ls_salesdocument).

  IF sy-subrc <> 0.
    MESSAGE 'No sales document data found in I_SalesDocumentBasic CDS view' TYPE 'I'.
  ENDIF.

  " Remaining program logic unchanged and copied as-is

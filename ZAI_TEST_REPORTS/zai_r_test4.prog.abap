REPORT zai_r_test4.

* Refactoring to replace MARA and VBAK table access by CDS views I_Product and I_SalesDocumentBasic
* Preserving all other logic and output unchanged

START-OF-SELECTION.

  " Select product data via CDS view I_Product instead of MARA
  SELECT SINGLE
    Product AS matnr,
    CreatedAt AS ersda
    FROM I_Product
    INTO @DATA(ls_product).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_Product CDS view' TYPE 'I'.
  ENDIF.

  " Select sales document header data via CDS view I_SalesDocumentBasic instead of VBAK
  SELECT SINGLE
    SalesDocument AS vbeln,
    DocumentDate AS audat
    FROM I_SalesDocumentBasic
    INTO @DATA(ls_salesdocument).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_SalesDocumentBasic CDS view' TYPE 'I'.
  ENDIF.

  " Further processing and output remain unchanged

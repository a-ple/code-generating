REPORT zai_r_test3.

* Refactoring report to use CDS views I_Product and I_SalesDocumentBasic
* Replacing direct MARA and VBAK table access
* Remaining logic unchanged

START-OF-SELECTION.

  " Select product data from I_Product CDS view instead of MARA
  SELECT SINGLE
    Product AS matnr,
    CreationDate AS ersda
    FROM I_Product
    INTO @DATA(ls_product).

  IF sy-subrc <> 0.
    MESSAGE 'No product data found in I_Product' TYPE 'I'.
  ENDIF.

  " Select sales document header data from I_SalesDocumentBasic instead of VBAK
  SELECT SINGLE
    SalesDocument AS vbeln,
    SalesDocumentDate AS audat
    FROM I_SalesDocumentBasic
    INTO @DATA(ls_salesdocument).

  IF sy-subrc <> 0.
    MESSAGE 'No sales document data found in I_SalesDocumentBasic' TYPE 'I'.
  ENDIF.

  " Further processing and output remain unchanged

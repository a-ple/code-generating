REPORT zai_r_test4.

* Refactored report to use CDS views for data access
* Tables MARA and VBAK replaced by views I_Product and I_SalesDocumentBasic

START-OF-SELECTION.

  " Select product data using I_Product view instead of MARA
  SELECT SINGLE
    Product AS matnr,
    CreatedAt AS ersda
    FROM I_Product
    INTO @DATA(ls_product).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_Product view' TYPE 'I'.
  ENDIF.

  " Select sales document header using I_SalesDocumentBasic view instead of VBAK
  SELECT SINGLE
    SalesDocument AS vbeln,
    DocumentDate AS audat
    FROM I_SalesDocumentBasic
    INTO @DATA(ls_salesdocument).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_SalesDocumentBasic view TYPE 'I'.
  ENDIF.

  " Remaining business logic unchanged

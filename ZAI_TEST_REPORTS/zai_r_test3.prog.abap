REPORT zai_r_test3.

* Refactored report to use CDS views I_Product and I_SalesDocumentBasic
* Replacing direct accesses to MARA and VBAK

START-OF-SELECTION.

  " Select data from CDS view I_Product instead of MARA
  SELECT SINGLE
    Product AS matnr,
    CreationDate AS ersda
    FROM I_Product
    INTO @DATA(ls_product).

  IF sy-subrc <> 0.
    MESSAGE 'No data found for Product in I_Product view' TYPE 'I'.
  ENDIF.

  " Select data from CDS view I_SalesDocumentBasic instead of VBAK
  SELECT SINGLE
    SalesDocument AS vbeln,
    SalesDocumentDate AS audat
    FROM I_SalesDocumentBasic
    INTO @DATA(ls_salesdocument).

  IF sy-subrc <> 0.
    MESSAGE 'No data found for SalesDocument in I_SalesDocumentBasic view' TYPE 'I'.
  ENDIF.

* Further processing and output remains unchanged

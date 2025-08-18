REPORT zai_r_test3.

* Refactor to use CDS views I_Product and I_SalesDocumentBasic
* Replacing MARA and VBAK table accesses accordingly

START-OF-SELECTION.

  " Select product data from I_Product CDS view instead of MARA
  SELECT SINGLE
    Product AS matnr,
    CreationDate AS ersda
    FROM I_Product
    INTO @DATA(ls_product).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_Product CDS view' TYPE 'I'.
  ENDIF.

  " Select sales document header data from I_SalesDocumentBasic CDS view instead of VBAK
  SELECT SINGLE
    SalesDocument AS vbeln,
    SalesDocumentDate AS audat
    FROM I_SalesDocumentBasic
    INTO @DATA(ls_salesdocument).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_SalesDocumentBasic CDS view' TYPE 'I'.
  ENDIF.

  " ... Remaining report logic unchanged ...

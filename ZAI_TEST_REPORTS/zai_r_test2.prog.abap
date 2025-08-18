REPORT zai_r_test2.

* Refactored to use CDS views I_Product and I_SalesDocumentBasic
* Replacing direct table accesses MARA and VBAK accordingly
* Maintaining original business logic

START-OF-SELECTION.

  " Select product data from CDS view I_Product replacing MARA
  SELECT SINGLE
    Product AS matnr,
    CreationDate AS ersda
    FROM I_Product
    INTO @DATA(ls_product).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_Product CDS view' TYPE 'I'.
  ENDIF.

  " Select sales document header data from CDS view I_SalesDocumentBasic replacing VBAK
  SELECT SINGLE
    SalesDocument AS vbeln,
    SalesDocumentDate AS audat
    FROM I_SalesDocumentBasic
    INTO @DATA(ls_salesdocument).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_SalesDocumentBasic CDS view' TYPE 'I'.
  ENDIF.

  " Additional processing and output unchanged

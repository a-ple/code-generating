REPORT zai_r_test3.

* Refactored to use CDS views I_Product and I_SalesDocumentBasic
* Replacing direct table accesses MARA and VBAK accordingly
* Maintaining original business logic and output formatting

START-OF-SELECTION.

  " Select product data from I_Product CDS view replacing MARA
  SELECT SINGLE
    Product               AS matnr,
    CreationDate          AS ersda
    FROM I_Product
    INTO @DATA(ls_product).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_Product CDS view' TYPE 'I'.
  ENDIF.

  " Select sales document header data from I_SalesDocumentBasic CDS view replacing VBAK
  SELECT SINGLE
    SalesDocument         AS vbeln,
    SalesDocumentDate     AS audat
    FROM I_SalesDocumentBasic
    INTO @DATA(ls_salesdocument).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_SalesDocumentBasic CDS view' TYPE 'I'.
  ENDIF.

  " Further data processing and output unchanged

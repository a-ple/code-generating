*------------------------------------------------------*
* Refactored report zai_r_test1 using CDS Views        *
* Replacing MARA -> I_Product and VBAK -> I_SalesDocumentBasic *
* Preserving I_Equipment accesses                       *
*------------------------------------------------------*

" Main processing start
START-OF-SELECTION.

  " Select single product record using CDS view I_Product
  SELECT SINGLE
    product AS matnr,
    creationdate AS ersda
    FROM I_Product
    INTO @DATA(ls_product).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_Product CDS view' TYPE 'I'.
  ENDIF.

  " Select single sales document basic record using CDS view I_SalesDocumentBasic
  SELECT SINGLE
    salesdocument AS vbeln,
    salesdocumentdate AS audat
    FROM I_SalesDocumentBasic
    INTO @DATA(ls_salesdoc).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_SalesDocumentBasic CDS view TYPE 'I'.
  ENDIF.

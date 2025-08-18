REPORT zai_r_test1.

* Refactored report to use CDS views I_Product (for MARA) and I_SalesDocumentBasic (for VBAK)
* Preserving other logic and SELECT statements unchanged

START-OF-SELECTION.

  " Select product data from I_Product CDS view instead of MARA
  SELECT SINGLE
    product                  AS matnr,           " original MARA field MATNR mapped to product
    creationdate             AS ersda            " original MARA field ERSDA mapped to creationdate
    FROM I_Product
    INTO @DATA(ls_product).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_Product CDS view' TYPE 'I'.
  ENDIF.

  " Select sales document header data from I_SalesDocumentBasic CDS view instead of VBAK
  SELECT SINGLE
    salesdocument            AS vbeln,           " original VBAK field VBELN mapped to salesdocument
    salesdocumentdate        AS audat            " original VBAK field AUDAT mapped to salesdocumentdate
    FROM I_SalesDocumentBasic
    INTO @DATA(ls_salesdocument).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_SalesDocumentBasic CDS view' TYPE 'I'.
  ENDIF.

  " Further processing and output logic unchanged


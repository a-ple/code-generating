*---------------------------------------------------------------------*
* Report zai_r_test1                                                    *
* Refactored to use CDS views I_Product and I_SalesDocumentBasic      *
* Replaces direct table reads from MARA and VBAK with CDS views        *
* Maintains direct access to I_Equipment as per task requirements      *
*---------------------------------------------------------------------*

"START-OF-SELECTION is the main processing block
START-OF-SELECTION.

  " Select single product info from CDS view I_Product replacing MARA table
  SELECT SINGLE Product as matnr, CreationDate as ersda
    FROM I_Product
    INTO @DATA(ls_product).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_Product CDS view' TYPE 'I'.
  ENDIF.

  " Select single sales document basic info from CDS view I_SalesDocumentBasic replacing VBAK table
  SELECT SINGLE SalesDocument as vbeln, DocumentDate as audat, SalesDocumentType as auart
    FROM I_SalesDocumentBasic
    INTO @DATA(ls_salesdocument).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_SalesDocumentBasic CDS view' TYPE 'I'.
  ENDIF.

  " Select equipment info unchanged from I_Equipment CDS view
  SELECT SINGLE Equipment, Division, Material
    FROM I_Equipment
    INTO @DATA(ls_equipment).

  IF sy-subrc <> 0.
    MESSAGE 'No data found in I_Equipment CDS view' TYPE 'I'.
  ENDIF.

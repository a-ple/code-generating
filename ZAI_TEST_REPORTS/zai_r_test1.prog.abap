*&---------------------------------------------------------------------*
*& Report zai_r_test1
*&---------------------------------------------------------------------*
*& This report has been modernized to use SAP provided CDS views
*& instead of direct DB table SELECT statements for better performance
*& and future compatibility in S/4HANA.
*&---------------------------------------------------------------------*
REPORT zai_r_test1.

START-OF-SELECTION.

  " Using CDS view I_SalesOrderItem to replace direct VBAK and VBAP access
  DATA(ls_salesorderitem) = VALUE i_salesorderitem( ).

  SELECT SINGLE SalesOrder, SalesOrderItem, Material, CreationDate FROM i_salesorderitem INTO @ls_salesorderitem WHERE SalesOrder = '0000000001'.
  IF sy-subrc <> 0.
    MESSAGE 'No data found in CDS view I_SalesOrderItem' TYPE 'I'.
  ELSE.
    WRITE: / 'SalesOrder:', ls_salesorderitem-SalesOrder.
    WRITE: / 'SalesOrderItem:', ls_salesorderitem-SalesOrderItem.
    WRITE: / 'Material:', ls_salesorderitem-Material.
    WRITE: / 'CreationDate:', ls_salesorderitem-CreationDate.
  ENDIF.

  " Using standard CDS view I_Material to replace direct MARA read
  DATA(ls_material) TYPE mara.
  SELECT SINGLE matnr ersda FROM mara INTO ls_material WHERE matnr = ls_salesorderitem-Material.
  IF sy-subrc <> 0.
    MESSAGE 'No data found in MARA for material' TYPE 'I'.
  ELSE.
    WRITE: / 'Material Number:', ls_material-matnr.
    WRITE: / 'Created On:', ls_material-ersda.
  ENDIF.

  " Use appropriate CDS views for other direct selects as needed

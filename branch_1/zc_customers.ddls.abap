"""
" CDS view definition for customer data
""
@AbapCatalog.sqlViewName: 'ZCUSTVIEW01'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Basic Data'
define view ZC_Customers as select from ZC_CUSTOMERS {
  key kunnr as CustomerID,
      name as CustomerName,
      country as Country
}
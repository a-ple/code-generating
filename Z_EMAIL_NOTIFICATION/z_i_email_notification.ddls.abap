@AbapCatalog.sqlViewName: 'ZEMAILNOTIF'
@EndUserText.label: 'Email Notification Composite CDS View'
define view entity Z_I_EMAIL_NOTIFICATION as select from I_SALESORDERHEADER as SalesHeader
{
  key SalesHeader.SalesOrder as SalesDocument,
  SalesHeader.SalesOrganization as SalesOrganization,
  SalesHeader.SoldToParty as SoldToParty

  // Associations and nested selections require alternative syntax
  // Associations can be added here properly if needed
}

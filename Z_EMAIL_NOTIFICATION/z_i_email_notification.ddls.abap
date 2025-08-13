@AbapCatalog.sqlViewName: 'ZIEEMAILNTF'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Email Notification Composite CDS'
define view entity Z_I_EMAIL_NOTIFICATION as select from I_SALESORDER as SalesOrder
  association [0..*] to I_SALESORDERITEM as _SalesOrderItem on SalesOrder.SalesOrder = _SalesOrderItem.SalesOrder
{
  key SalesOrder.SalesOrder as SalesOrderNumber,
  SalesOrder.SalesOrganization as SalesOrganization,
  SalesOrder.SoldToParty as SoldToParty,

  _SalesOrderItem {
    key SalesOrderItem,
    MaterialNumber,
    OrderQuantity,
    DeliveryDate,

    association [0..1] to I_PRODUCT as _Product on MaterialNumber = _Product.Product
    {
      MaterialDescription,
      MaterialType
    },

    association [0..1] to I_PURCHASINGDOCUMENTITEM as _PurchasingDocumentItem on SalesOrderItem = _PurchasingDocumentItem.PurchasingDocumentItem
    {
      PurchasingDocument,
      PurchasingDocumentItem
    }
  }
}
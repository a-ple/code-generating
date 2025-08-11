@AbapCatalog.sqlViewName: 'ZEMAILNOTIF'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Email Notification Composite View'
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE

define view Z_I_EMAIL_NOTIFICATION
  as select from I_SalesOrderHeader as SalesOrder
    inner join I_SalesOrderItem as SalesOrderItem
      on SalesOrder.SalesOrder = SalesOrderItem.SalesOrder
    left outer join I_Material as Material
      on SalesOrderItem.Material = Material.Material
    left outer join I_PurchaseOrderItem as PurchaseOrderItem
      on SalesOrder.PurchaseOrder = PurchaseOrderItem.PurchaseOrder
{
  key SalesOrder.SalesOrder,
  SalesOrder.SalesDocumentType,
  SalesOrder.SalesOrganization,
  SalesOrder.DistributionChannel,
  SalesOrder.Division,
  SalesOrder.SalesDocumentDate,
  SalesOrder.SalesDocumentStatus,

  key SalesOrderItem.SalesOrderItem,
  SalesOrderItem.Material,
  SalesOrderItem.OrderQuantity,
  SalesOrderItem.OrderQuantityUnit,
  SalesOrderItem.NetAmount,

  Material.MaterialType,
  Material.MaterialGroup,

  PurchaseOrderItem.PurchaseOrder as PurchaseOrder,
  PurchaseOrderItem.PurchaseOrderItem,
  PurchaseOrderItem.Plant as PurchaseOrderPlant,
  PurchaseOrderItem.OrderQuantity as PurchaseOrderQuantity,
  PurchaseOrderItem.PurchaseOrderItemCategory
}
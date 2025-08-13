@AbapCatalog.sqlViewName: 'ZIE_MAILNOTIF'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Email Notification Composite CDS View'
define view entity Z_I_EMAIL_NOTIFICATION as select from VDM_SD_SLS.I_SALESDOCUMENT as SalesDoc
  inner join VDM_SD_SLS.I_SALESORDERITEM as SalesItem
    on SalesDoc.SalesDocument = SalesItem.SalesDocument
  left outer join VDM_MM_PUR_PD.I_MATERIALMASTER as MaterialMaster
    on SalesItem.MaterialNumber = MaterialMaster.MaterialNumber
  left outer join VDM_MM_PUR_PD.I_PURCHASINGDOCUMENTITEM as PurchasingItem
    on SalesItem.SalesDocumentItem = PurchasingItem.PurchasingDocumentItem
{
  key SalesDoc.SalesDocument as SalesDocument,
  key SalesItem.SalesDocumentItem as SalesDocumentItem,
  SalesDoc.SalesOrganization as SalesOrganization,
  SalesDoc.SoldToParty as SoldToParty,
  SalesItem.MaterialNumber as MaterialNumber,
  MaterialMaster.MaterialDescription as MaterialDescription,
  MaterialMaster.MaterialType as MaterialType,
  PurchasingItem.PurchasingDocument as PurchasingDocument,
  PurchasingItem.PurchasingDocumentItem as PurchasingDocumentItem,
  PurchasingItem.PurchaseOrderQuantity as PurchaseOrderQuantity
}
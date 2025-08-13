@AbapCatalog.sqlViewName: 'ZIE_MAILNOTIF'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Email Notification Composite CDS View'
define view entity Z_I_EMAIL_NOTIFICATION as select from VDM_SD_SLS.I_SALESDOCUMENT as SalesDoc {

  // Key fields from Sales Document header
  key SalesDoc.SalesDocument as SalesDocument,
  key SalesDoc.SalesDocumentItem as SalesDocumentItem,

  // Sales Document Header Fields
  SalesDoc.SalesOrganization as SalesOrganization,
  SalesDoc.SoldToParty as SoldToParty,

  // Association to Sales Document Item
  association [0..*] to VDM_SD_SLS.I_SALESDOCUMENTITEM as _SalesDocItem
    on SalesDoc.SalesDocument = _SalesDocItem.SalesDocument
  {
    key _SalesDocItem.SalesDocumentItem as SalesDocumentItem,
    _SalesDocItem.MaterialNumber as MaterialNumber,

    // Association to Material Master
    association [0..1] to VDM_MM_PUR_PD.I_MATERIALMASTER as _MaterialMaster
      on _SalesDocItem.MaterialNumber = _MaterialMaster.MaterialNumber
    {
      _MaterialMaster.MaterialDescription as MaterialDescription,
      _MaterialMaster.MaterialType as MaterialType
    },

    // Association to Purchasing Document Item
    association [0..1] to VDM_MM_PUR_PD.I_PURCHASINGDOCUMENTITEM as _PurchasingDocItem
      on _SalesDocItem.PurchasingDocumentItem = _PurchasingDocItem.PurchasingDocumentItem
    {
      _PurchasingDocItem.PurchasingDocument as PurchasingDocument,
      _PurchasingDocItem.PurchasingDocumentItem as PurchasingDocumentItem,
      _PurchasingDocItem.PurchaseOrderQuantity as PurchaseOrderQuantity
    }
  }
}
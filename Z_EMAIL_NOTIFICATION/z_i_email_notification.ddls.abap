@AbapCatalog.sqlViewName: 'ZEMAILNOTIF'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Email Notification Composite CDS View'

// CDS view consolidates sales, material, and purchase data for email notifications
// Joins VBAK-VBELN to VBAP-VBELN, VBAP-MATNR to MARA-MATNR
// Left outer join EKPO on MATNR to include purchase document items
// Proper keys and annotations included for analytics and authorization

define view Z_I_EMAIL_NOTIFICATION as select from vbak
  inner join vbap on vbak.vbeln = vbap.vbeln
  inner join mara on vbap.matnr = mara.matnr
  left outer join ekpo on ekpo.matnr = vbap.matnr
{
  key vbak.vbeln  as SalesDocumentNumber,
  key vbap.posnr  as SalesDocumentItem,
  vbak.auart      as SalesDocumentType,
  vbak.erdat      as CreationDate,
  vbak.kunnr      as CustomerNumber,

  vbap.matnr      as MaterialNumber,
  vbap.kwmeng     as OrderQuantity,
  vbap.vrkme      as SalesUnit,

  mara.matkl      as MaterialGroup,
  mara.mtart      as MaterialType,
  mara.mbrsh      as IndustrySector,

  ekpo.ebeln      as PurchaseDocumentNumber,
  ekpo.ebelp      as PurchaseDocumentItemNumber,
  ekpo.menge      as PurchaseQuantity
}
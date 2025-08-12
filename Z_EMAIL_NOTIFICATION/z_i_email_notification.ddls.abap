@AbapCatalog.sqlViewName: 'ZEMAILNOTIF'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Email Notification Composite CDS'

// CDS view consolidates sales, material and purchase document data to support email notifications
// Joins standard SAP tables VBAK, VBAP, MARA and EKPO with associations reflecting business keys
// Key fields: Sales Document Number and Item Number
// Annotations ensure authorization checks and usability in analytical scenarios

define view Z_I_EMAIL_NOTIFICATION as select from vbak
    inner join vbap on vbak.vbeln = vbap.vbeln
    inner join mara on vbap.matnr = mara.matnr
    left outer join ekpo on ekpo.matnr = vbap.matnr
{
  key vbak.vbeln         as SalesDocumentNumber,
  key vbap.posnr         as ItemNumber,
  vbak.auart             as SalesDocumentType,
  vbak.erdat             as CreationDate,
  vbak.kunnr             as CustomerNumber,

  vbap.matnr             as MaterialNumber,
  vbap.kwmeng            as OrderQuantity,
  vbap.vrkme             as SalesUnit,

  mara.matkl             as MaterialGroup,
  mara.mtart             as MaterialType,
  mara.mbrsh             as IndustrySector,

  ekpo.ebeln             as PurchaseDocumentNumber,
  ekpo.ebelp             as PurchaseDocumentItemNumber,
  ekpo.menge             as PurchaseQuantity
}
@AbapCatalog.sqlViewName: 'ZCRIDCV'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Custom CDS view for CRID with semantic field names'
define view entity ZC_CRID_CUSTOM as select from crid {
  key objty as ObjectType,
  key objid as ObjectId
}
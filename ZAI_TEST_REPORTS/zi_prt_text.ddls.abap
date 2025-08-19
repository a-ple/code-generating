@AbapCatalog.sqlViewName: 'ZP_RT_TXT'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Personalized texts from CRTX'
define view entity ZI_PRT_TEXT as select from crtx {
  key mandt as Client,
  key objty as ObjectType,
  key objid as ObjectId,
  key spras as Language,
  aedat as ChangedOn,
  aenam as ChangedByUser,
  ktext as Text,
  ktext_up as TextUpperCase
}
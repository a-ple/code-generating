@AbapCatalog.sqlViewName: 'ZI_PRT_TEXT'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Custom Text Data from CRTX'
define view entity ZI_PRT_TEXT as select from crtx {
  key objty   as ObjectType,
  key objid   as ObjectId,
  key spras   as Language,
      aedat_text as ChangeDateText,
      aenam_text as ChangedByUserText,
      ktext     as Text,
      ktext_up  as TextUppercase
}
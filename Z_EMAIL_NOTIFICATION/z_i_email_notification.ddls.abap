@AbapCatalog.sqlViewName: 'ZIEEMAILNTF'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for Email Attachment Data'
define view entity Z_I_EMAIL_NOTIFICATION
  with parameters
    @Environment.system: 'ABAP'
  {
    @ObjectModel.modeling.pattern: #COMPOSITION_ROOT
    @EndUserText.label: 'Email Notification Root'
    key SalesDocument: abap.char(10);
  } as select from I_SalesDocument as SalesDoc {
    key SalesDoc.SalesDocument as SalesDocument
    // Associations not allowed at root level directly without definition as composition
  }
// Note: CDS syntax does not allow association directly inside select list without from or association clause
// To implement associations correctly, consider defining them outside or using joins.
// Please consult ABAP CDS syntax for associations usage.
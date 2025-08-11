CLASS zcl_email_notification DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    " Sends an email with optional Excel attachment
    METHODS send_email
      IMPORTING
        iv_email_body TYPE string
        iv_attachment TYPE solix_tab OPTIONAL
      EXPORTING
        ev_result TYPE string.

  PRIVATE SECTION.
    " Constant test email address
    CONSTANTS c_test_email TYPE ad_smtpadr VALUE 'aliaksandr_pliavaka@email.com'.
ENDCLASS.

CLASS zcl_email_notification IMPLEMENTATION.
  METHOD send_email.
    DATA(lo_send_request) = cl_bcs=>create_persistent( ).
    DATA(lo_document) TYPE REF TO cl_document_bcs.
    DATA(lo_sender) TYPE REF TO cl_sapuser_bcs.
    DATA(lo_recipient) TYPE REF TO if_bcs_recipient.
    DATA(lo_attachment) TYPE REF TO cl_document_bcs.
    DATA(lv_subject) TYPE string VALUE 'SAP Email Notification'.

    ev_result = ''.

    TRY.
      " Create the email body document
      lo_document = cl_document_bcs=>create_document(
        i_type = 'RAW'
        i_text = iv_email_body
        i_subject = lv_subject
        i_language = sy_langu
      ).
      lo_send_request->set_document( lo_document ).

      " Set sender to SAP user
      lo_sender = cl_sapuser_bcs=>create( ).
      lo_send_request->set_sender( lo_sender ).

      " Add recipient - for testing constant email
      lo_recipient = cl_cam_address_bcs=>create_internet_address( c_test_email ).
      lo_send_request->add_recipient( lo_recipient ).

      " Attach Excel file if available
      IF iv_attachment IS NOT INITIAL.
        lo_attachment = cl_document_bcs=>create_document(
          i_type = 'XLSX'
          i_subject = |Attachment.xlsx|
          i_binary_content = iv_attachment
          i_attachment_type = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        ).
        lo_send_request->add_attachment( lo_attachment ).
      ENDIF.

      " Send the email
      lo_send_request->send( i_with_error_screen = abap_false ).

      ev_result = 'Email sent successfully.'.

    CATCH cx_bcs INTO DATA(lx_bcs).
      ev_result = |Error sending email: { lx_bcs->get_text( ) }|.
    CATCH cx_root INTO DATA(lx).
      ev_result = |Unexpected error: { lx->get_text( ) }|.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
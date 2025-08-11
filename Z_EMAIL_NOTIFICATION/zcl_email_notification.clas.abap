CLASS zcl_email_notification DEFINITION
  PUBLIC
  CREATE PUBLIC.
  PUBLIC SECTION.
    " Type for table of email recipients
    TYPES: ty_recipients TYPE TABLE OF adr6-smtp_addr WITH EMPTY KEY.

    " Constant test email address for initial unit testing
    CONSTANTS c_test_email TYPE adr6-smtp_addr VALUE 'aliaksandr_pliavaka@email.com'.

    " Send email to provided recipients with optional attachment
    METHODS send_email
      IMPORTING
        it_recipients          TYPE ty_recipients OPTIONAL
        iv_email_body          TYPE string
        iv_attachment          TYPE xstring OPTIONAL
        iv_attachment_filename TYPE string OPTIONAL.

  PRIVATE SECTION.
    " Internal method to prepare and send the email
    METHODS send_mail_message
      IMPORTING
        it_recipients          TYPE ty_recipients
        iv_email_body          TYPE string
        iv_attachment          TYPE xstring
        iv_attachment_filename TYPE string.
ENDCLASS.

CLASS zcl_email_notification IMPLEMENTATION.

  METHOD send_email.
    DATA lt_recipients TYPE ty_recipients.

    " Use static test email if no recipients provided
    IF it_recipients IS INITIAL.
      lt_recipients = VALUE ty_recipients( ( c_test_email ) ).
    ELSE.
      lt_recipients = it_recipients.
    ENDIF.

    TRY.
      send_mail_message(
        it_recipients          = lt_recipients
        iv_email_body          = iv_email_body
        iv_attachment          = iv_attachment
        iv_attachment_filename = iv_attachment_filename
      ).
    CATCH cx_bcs INTO DATA(lx_bcs).
      " Here you may implement error logging / re-raise
      RAISE EXCEPTION lx_bcs.
    ENDTRY.
  ENDMETHOD.

  METHOD send_mail_message.
    DATA(lo_send_request) = cl_bcs=>create_persistent( ).

    " Prepare email body as plain text
    DATA(lo_document) = cl_document_bcs=>create_document(
      i_type    = if_docdb_content_type=>co_text,
      i_text    = iv_email_body,
      i_subject = 'Notification Email'
    ).
    lo_send_request->set_document( lo_document ).

    " Add recipients
    LOOP AT it_recipients INTO DATA(lv_email).
      DATA(lo_recipient) = cl_cam_address_bcs=>create_internet_address( lv_email ).
      lo_send_request->add_recipient( lo_recipient ).
    ENDLOOP.

    " Add Excel attachment if present
    IF iv_attachment IS NOT INITIAL.
      " Attachment filename default
      DATA(lv_filename) = iv_attachment_filename.
      IF lv_filename IS INITIAL.
        lv_filename = 'Attachment.xlsx'.
      ENDIF.

      " Create attachment as BCS object
      DATA(lo_attachment) = cl_attachment_bcs=>create(
        i_attachment_type = if_docdb_content_type_hex=>co_mime_excel_xlsx,
        i_attachment_subject = lv_filename,
        i_att_content_hex  = iv_attachment
      ).
      lo_send_request->add_attachment( lo_attachment ).
    ENDIF.

    " Send the email in background
    lo_send_request->send( i_with_error_screen = abap_false ).
    COMMIT WORK.
  ENDMETHOD.

ENDCLASS.
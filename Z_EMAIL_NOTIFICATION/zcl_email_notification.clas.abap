CLASS zcl_email_notification DEFINITION
  PUBLIC
  CREATE PUBLIC.
  PUBLIC SECTION.
    " Types
    TYPES ty_recipients TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    " Constants
    CONSTANTS c_test_email TYPE string VALUE 'aliaksandr_pliavaka@email.com'.

    " Main method to send email
    METHODS send_email
      IMPORTING
        it_recipients          TYPE ty_recipients OPTIONAL
        iv_email_body          TYPE string
        iv_attachment_xstring  TYPE xstring OPTIONAL
        iv_attachment_filename TYPE string OPTIONAL.

  PRIVATE SECTION.
    " Fetch active recipients from DB
    METHODS prepare_recipients RETURNING VALUE(rt_recipients) TYPE ty_recipients.

    " Log email sending status and errors
    METHODS log_email_status
      IMPORTING
        it_recipients TYPE ty_recipients
        iv_status     TYPE string
        iv_message    TYPE string OPTIONAL.
ENDCLASS.

CLASS zcl_email_notification IMPLEMENTATION.

  METHOD send_email.
    DATA lt_recipients TYPE ty_recipients.

    " Determine recipients: use provided list or fallback to test email
    IF it_recipients IS INITIAL.
      lt_recipients = VALUE ty_recipients( ( c_test_email ) ).
    ELSE.
      lt_recipients = it_recipients.
    ENDIF.

    DATA(lo_send_request) = cl_bcs=>create_persistent( ).

    " Create mail message with HTML content as email body
    DATA(lo_document) = cl_bcs_mail_message=>create(
      i_html = iv_email_body
    ).
    lo_send_request->set_document( lo_document ).

    " Add recipients
    LOOP AT lt_recipients INTO DATA(lv_email).
      DATA(lo_recipient) = cl_cam_address_bcs=>create_internet_address( lv_email ).
      lo_send_request->add_recipient( lo_recipient ).
    ENDLOOP.

    " Add attachment if provided
    IF iv_attachment_xstring IS NOT INITIAL.
      DATA(lv_filename) = iv_attachment_filename.
      IF lv_filename IS INITIAL.
        lv_filename = 'Attachment.xlsx'.
      ENDIF.

      DATA(lo_attachment) = cl_attachment_bcs=>create(
        i_attachment_type = if_docdb_content_type_hex=>co_mime_excel_xlsx,
        i_attachment_subject = lv_filename,
        i_att_content_hex = iv_attachment_xstring
      ).
      lo_send_request->add_attachment( lo_attachment ).
    ENDIF.

    TRY.
      lo_send_request->send( i_with_error_screen = abap_false ).
      COMMIT WORK.
      log_email_status( it_recipients = lt_recipients iv_status = 'SUCCESS' ).
    CATCH cx_bcs INTO DATA(lx_bcs).
      log_email_status( it_recipients = lt_recipients iv_status = 'FAILURE' iv_message = lx_bcs->get_text( ) ).
      RAISE EXCEPTION lx_bcs.
    ENDTRY.

  ENDMETHOD.

  METHOD prepare_recipients.
    SELECT email_addr FROM zemail_notification_recipients
      INTO TABLE @rt_recipients
      WHERE active_flag = 'X'.
  ENDMETHOD.

  METHOD log_email_status.
    DATA lv_recipient_list TYPE string.
    LOOP AT it_recipients INTO DATA(lv_email).
      CONCATENATE lv_recipient_list lv_email ', ' INTO lv_recipient_list SEPARATED BY ''.
    ENDLOOP.

    " Logging information - replace with actual logging implementation as needed
    cl_demo_output=>write( |Email send status: { iv_status }| ).
    cl_demo_output=>write( |Recipients: { lv_recipient_list }| ).
    IF iv_message IS NOT INITIAL.
      cl_demo_output=>write( |Error Message: { iv_message }| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
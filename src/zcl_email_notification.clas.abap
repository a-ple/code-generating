CLASS zcl_email_notification DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    " Sends an email with optional Excel attachment to multiple recipients
    METHODS send_email
      IMPORTING
        iv_email_body       TYPE string
        it_recipients       TYPE STANDARD TABLE OF string
        iv_attachment_content TYPE xstring OPTIONAL
        iv_attachment_name  TYPE string OPTIONAL.
ENDCLASS.

CLASS zcl_email_notification IMPLEMENTATION.
  METHOD send_email.
    DATA(lo_send_request) = cl_bcs=>create_persistent( ).
    DATA(lo_sender) = cl_sapuser_bcs=>create( sy-uname ).
    lo_send_request->set_sender( lo_sender ).

    " Validate required email body parameter
    IF iv_email_body IS INITIAL.
      RAISE EXCEPTION TYPE cx_argument_out_of_range
        EXPORTING textid = cx_argument_out_of_range=>textid_invalid_value
                  msgid = 'ZEMAIL' msgno = '001' msgv1 = 'Email body must not be empty'.
    ENDIF.

    " For testing, use constant recipient if input is empty
    IF it_recipients IS INITIAL.
      it_recipients = VALUE #( ( 'aliaksandr_pliavaka@email.com' ) ).
    ENDIF.

    " Create the email document
    DATA(lo_document) = cl_document_bcs=>create_document(
      i_type    = 'RAW'
      i_subject = 'Notification Email'
      i_text    = iv_email_body
    ).

    " If an attachment is provided, validate and add it
    IF iv_attachment_content IS NOT INITIAL AND iv_attachment_name IS NOT INITIAL.
      IF iv_attachment_name+ strlen( iv_attachment_name ) - 5(5) NE '.xlsx'.
        RAISE EXCEPTION TYPE cx_argument_out_of_range
          EXPORTING textid = cx_argument_out_of_range=>textid_invalid_value
                    msgid = 'ZEMAIL' msgno = '002' msgv1 = 'Attachment file name must end with .xlsx'.
      ENDIF.
      DATA(lo_att_content) = cl_bcs_memorystream=>create( iv_attachment_content ).
      DATA(lo_attachment) = cl_attachment_bcs=>create(
        i_attachment_type    = if_bcs_attachment=>co_attachment_type_xlsx
        i_attachment_subject = iv_attachment_name
        i_att_content_stream = lo_att_content
      ).
      lo_document->add_attachment( lo_attachment ).
    ENDIF.

    lo_send_request->set_document( lo_document ).

    " Add all recipients
    LOOP AT it_recipients INTO DATA(lv_recipient_email).
      IF lv_recipient_email IS NOT INITIAL.
        DATA(lo_recipient) = cl_cam_address_bcs=>create_internet_address( lv_recipient_email ).
        lo_send_request->add_recipient( lo_recipient ).
      ENDIF.
    ENDLOOP.

    " Raise error if no recipients
    IF lo_send_request->get_recipient_count( ) = 0.
      RAISE EXCEPTION TYPE cx_bcs
        EXPORTING textid = cx_bcs=>textid_no_recipients.
    ENDIF.

    TRY.
      " Send the email asynchronously
      DATA(lv_sent) = lo_send_request->send( i_with_error_screen = abap_false ).
      COMMIT WORK.
    CATCH cx_bcs INTO DATA(lx_bcs).
      RAISE EXCEPTION lx_bcs.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
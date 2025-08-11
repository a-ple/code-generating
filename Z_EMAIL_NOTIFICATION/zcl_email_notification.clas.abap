CLASS zcl_email_notification DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    " Method SEND_EMAIL: sends email with optional Excel attachment to recipients
    METHODS send_email
      IMPORTING
        iv_email_body        TYPE string
        it_recipients        TYPE STANDARD TABLE OF string OPTIONAL
        iv_attachment_content TYPE xstring OPTIONAL
        iv_attachment_name   TYPE string OPTIONAL.
ENDCLASS.

CLASS zcl_email_notification IMPLEMENTATION.
  METHOD send_email.
    DATA(lo_send_request) = cl_bcs=>create_persistent( ).
    DATA(lo_sender) = cl_sapuser_bcs=>create( sy-uname ).
    lo_send_request->set_sender( lo_sender ).

    " Validate email body
    IF iv_email_body IS INITIAL.
      RAISE EXCEPTION TYPE cx_argument_out_of_range
        EXPORTING
          textid = cx_argument_out_of_range=>textid_invalid_value
          msgid  = 'ZEMAIL' msgno = '001' msgv1 = 'Email body must not be empty'.
    ENDIF.

    " During testing phase, replace recipients with constant address if missing
    IF it_recipients IS INITIAL.
      it_recipients = VALUE #( ( 'aliaksandr_pliavaka@email.com' ) ).
    ENDIF.

    " Determine attachment filename or use default
    DATA(lv_attachment_name) = iv_attachment_name.
    IF iv_attachment_content IS NOT INITIAL AND iv_attachment_name IS INITIAL.
      lv_attachment_name = 'attachment.xlsx'.
    ENDIF.

    " Validate attachment filename extension
    IF iv_attachment_content IS NOT INITIAL AND lv_attachment_name+ strlen( lv_attachment_name ) - 5(5) NE '.xlsx'.
      RAISE EXCEPTION TYPE cx_argument_out_of_range
        EXPORTING
          textid = cx_argument_out_of_range=>textid_invalid_value
          msgid  = 'ZEMAIL' msgno = '002' msgv1 = 'Attachment filename must end with .xlsx'.
    ENDIF.

    " Create email document with body
    DATA(lo_document) = cl_document_bcs=>create_document(
      i_type    = 'RAW'
      i_subject = 'Notification Email'
      i_text    = iv_email_body
    ).

    " Attach Excel file if present
    IF iv_attachment_content IS NOT INITIAL.
      DATA(lo_att_content) = cl_bcs_memorystream=>create( iv_attachment_content ).
      DATA(lo_attachment) = cl_attachment_bcs=>create(
        i_attachment_type    = if_bcs_attachment=>co_attachment_type_xlsx
        i_attachment_subject = lv_attachment_name
        i_att_content_stream = lo_att_content
      ).
      lo_document->add_attachment( lo_attachment ).
    ENDIF.

    lo_send_request->set_document( lo_document ).

    " Add recipients
    LOOP AT it_recipients INTO DATA(lv_email).
      IF lv_email IS NOT INITIAL.
        DATA(lo_recipient) = cl_cam_address_bcs=>create_internet_address( lv_email ).
        lo_send_request->add_recipient( lo_recipient ).
      ENDIF.
    ENDLOOP.

    " Check if at least one recipient exists
    IF lo_send_request->get_recipient_count( ) = 0.
      RAISE EXCEPTION TYPE cx_bcs
        EXPORTING textid = cx_bcs=>textid_no_recipients.
    ENDIF.

    TRY.
      " Send email asynchronously
      lo_send_request->send( i_with_error_screen = abap_false ).
      COMMIT WORK.
    CATCH cx_bcs INTO DATA(lx_bcs).
      RAISE EXCEPTION lx_bcs.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
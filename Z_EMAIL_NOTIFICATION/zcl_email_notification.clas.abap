CLASS zcl_email_notification DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    " Sends an email with optional Excel (.xlsx) attachments
    METHODS send_email
      IMPORTING
        iv_email_body        TYPE string
        it_attachment_files  TYPE STANDARD TABLE OF string OPTIONAL
        recipients           TYPE STANDARD TABLE OF string OPTIONAL.
ENDCLASS.

CLASS zcl_email_notification IMPLEMENTATION.
  METHOD send_email.
    DATA lo_send_request TYPE REF TO cl_bcs.
    DATA lo_sender       TYPE REF TO cl_sapuser_bcs.
    DATA lo_document     TYPE REF TO cl_document_bcs.
    DATA lo_attachment   TYPE REF TO if_bcs_attachment.
    DATA lo_att_content  TYPE REF TO cl_bcs_memorystream.
    DATA lo_recipient    TYPE REF TO if_bcsrecipient.
    DATA lv_email        TYPE string.

    " Validate email body text
    IF iv_email_body IS INITIAL.
      RAISE EXCEPTION TYPE cx_argument_out_of_range
        EXPORTING msgv1 = 'Email body must not be empty'.
    ENDIF.

    " For testing, use constant recipient if recipients are not provided
    IF recipients IS INITIAL.
      recipients = VALUE #( ( 'aliaksandr_pliavaka@email.com' ) ).
    ENDIF.

    " Create persistent send request
    lo_send_request = cl_bcs=>create_persistent( ).

    " Set sender to current SAP user
    lo_sender = cl_sapuser_bcs=>create( sy-uname ).
    lo_send_request->set_sender( lo_sender ).

    " Create mail document with email body
    lo_document = cl_document_bcs=>create_document(
      i_type    = 'RAW'
      i_subject = 'Notification Email'
      i_text    = iv_email_body
    ).

    " Attach each file in the attachment list if provided
    IF it_attachment_files IS NOT INITIAL.
      LOOP AT it_attachment_files INTO DATA(lv_file_content).
        lo_att_content = cl_bcs_memorystream=>create( lv_file_content ).
        lo_attachment = cl_attachment_bcs=>create(
          i_attachment_type    = if_bcs_attachment=>co_attachment_type_xlsx
          i_att_content_stream = lo_att_content
          i_attachment_subject = 'Attachment.xlsx' " Default name; enhancement: pass filename
        ).
        lo_document->add_attachment( lo_attachment ).
      ENDLOOP.
    ENDIF.

    lo_send_request->set_document( lo_document ).

    " Add recipients
    LOOP AT recipients INTO lv_email.
      IF lv_email IS NOT INITIAL.
        lo_recipient = cl_cam_address_bcs=>create_internet_address( lv_email ).
        lo_send_request->add_recipient( lo_recipient ).
      ENDIF.
    ENDLOOP.

    " Ensure at least one recipient
    IF lo_send_request->get_recipient_count( ) = 0.
      RAISE EXCEPTION TYPE cx_bcs
        EXPORTING msgv1 = 'No valid recipients provided'.
    ENDIF.

    TRY.
      " Send email asynchronously
      lo_send_request->send( i_with_error_screen = abap_false ).
      COMMIT WORK.
    CATCH cx_bcs INTO DATA(lx_bcs).
      " Propagate exception
      RAISE EXCEPTION lx_bcs.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
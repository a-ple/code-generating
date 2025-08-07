CLASS zcl_email_notification DEFINITION PUBLIC CREATE PUBLIC.
  
  "
  " Custom class to send email notifications with optional Excel attachments
  "
  PUBLIC SECTION.
    METHODS send_email
      IMPORTING
        iv_email_body       TYPE string
        it_attachment       TYPE solix_tab OPTIONAL
        iv_attachment_name  TYPE string OPTIONAL.
ENDCLASS.

CLASS zcl_email_notification IMPLEMENTATION.

  METHOD send_email.
    " Send email with optional Excel attachment using CL_BCS
    DATA: lo_send_request  TYPE REF TO cl_bcs,
          lo_document      TYPE REF TO cl_document_bcs,
          lo_recipient     TYPE REF TO if_recipient_bcs,
          lv_sent_to_all   TYPE os_boolean,
          lv_error_text    TYPE string.

    TRY.
        " Create persistent send request
        lo_send_request = cl_bcs=>create_persistent( ).

        " Set sender as current user
        lo_send_request->set_sender( cl_sapuser_bcs=>create( ) ).

        " For production usage: select recipients from DB table here
        " For testing, send to fixed recipient
        lo_recipient = cl_cam_address_bcs=>create_internet_address( 'aliaksandr_pliavaka@email.com' ).
        lo_send_request->add_recipient( lo_recipient ).

        " Create document with email subject and body
        lo_document = cl_document_bcs=>create_document(
                       i_type    = 'RAW'
                       i_text    = VALUE soli_tab( ( iv_email_body ) )
                       i_subject = 'Notification Email' ).

        " Attach Excel file if provided
        IF it_attachment IS NOT INITIAL.
          lo_document->add_attachment(
            i_attachment_type    = 'XLSX'
            i_attachment_subject = iv_attachment_name
            i_att_content_hex    = it_attachment ).
        ENDIF.

        lo_send_request->set_document( lo_document ).

        " Send email
        lo_send_request->send( RECEIVING sent_to_all = lv_sent_to_all ).

      CATCH cx_bcs INTO DATA(lx_bcs).
        lv_error_text = lx_bcs->get_text( ).
        MESSAGE lv_error_text TYPE 'E'.
      CATCH cx_root INTO DATA(lx_root).
        lv_error_text = lx_root->get_text( ).
        MESSAGE lv_error_text TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
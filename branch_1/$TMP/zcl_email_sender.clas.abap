CLASS zcl_email_sender DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    " Sends an email with optional attachments to recipients
    METHODS send_email
      IMPORTING
        iv_email_body    TYPE string
        it_attachments   TYPE STANDARD TABLE OF solisti1 OPTIONAL
      RAISING cx_root.
ENDCLASS.

CLASS zcl_email_sender IMPLEMENTATION.
  METHOD send_email.
    " Create persistent send request
    DATA(lo_send_request) = cl_bcs=>create_persistent( ).
    " Set sender as current SAP user
    DATA(lo_sender) = cl_sapuser_bcs=>create( ).
    lo_send_request->set_sender( lo_sender ).

    " Use constant recipient email (to be replaced with DB access later)
    DATA(lv_recipient_email) TYPE ad_smtpadr VALUE 'aliaksandr_pliavaka@email.com'.
    DATA(lo_recipient) = cl_cam_address_bcs=>create_internet_address( lv_recipient_email ).
    lo_send_request->add_recipient( lo_recipient ).

    " Create the email document with RAW type and provided body
    DATA(lo_document) = cl_document_bcs=>create_document(
      i_type = 'RAW'
      i_text = iv_email_body
      i_subject = 'Automated Email from ABAP'
    ).
    lo_send_request->set_document( lo_document ).

    " Attach files if provided
    IF it_attachments IS NOT INITIAL.
      LOOP AT it_attachments INTO DATA(ls_attachment).
        DATA(lo_attachment) = cl_sapattach_bcs=>create(
          i_attachment_type = cl_sapattach_bcs=>co_attachment_type_otf
          i_attachment_subject = 'Attachment'
          i_att_content_hex = ls_attachment
        ).
        lo_send_request->add_attachment( lo_attachment ).
      ENDLOOP.
    ENDIF.

    " Send email without error popup, raise exception if failed
    IF lo_send_request->send( i_with_error_screen = abap_false ) = abap_false.
      RAISE EXCEPTION TYPE cx_root MESSAGE 'Email sending failed'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
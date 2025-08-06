CLASS zcl_email_sender DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    " Sends email with optional attachments
    METHODS: send_email
      IMPORTING
        iv_email_body TYPE string
        it_attachments OPTIONAL TYPE STANDARD TABLE OF solisti1 WITH DEFAULT TABLE KEY.
ENDCLASS.

CLASS zcl_email_sender IMPLEMENTATION.
  METHOD send_email.
    " Local variables for BCS objects
    DATA: lo_send_request TYPE REF TO cl_bcs,
          lo_document TYPE REF TO cl_document_bcs,
          lo_sender TYPE REF TO cl_sapuser_bcs,
          lo_recipient TYPE REF TO if_recipient_bcs,
          lv_text TYPE bcsy_text,
          ls_attachment TYPE solisti1,
          lo_binary_attach TYPE REF TO cl_sapattach_bcs,
          lv_email_address TYPE ad_smtpadr VALUE 'aliaksandr_pliavaka@email.com'.

    " Create persistent send request
    lo_send_request = cl_bcs=>create_persistent( ).

    " Set sender to current SAP user
    lo_sender = cl_sapuser_bcs=>create( ).
    lo_send_request->set_sender( lo_sender ).

    " Add recipient email address (currently constant, from table later)
    lo_recipient = cl_cam_address_bcs=>create_internet_address( lv_email_address ).
    lo_send_request->add_recipient( lo_recipient ).

    " Prepare email body as RAW document
    lv_text = iv_email_body.
    lo_document = cl_document_bcs=>create_document( i_type = 'RAW'
                                                    i_text = lv_text
                                                    i_subject = 'Automated Email from ABAP' ).
    lo_send_request->set_document( lo_document ).

    " Attach files if any attachments provided
    IF it_attachments IS NOT INITIAL.
      LOOP AT it_attachments INTO ls_attachment.
        lo_binary_attach = cl_sapattach_bcs=>create( i_attachment_type = cl_sapattach_bcs=>co_attachment_type_otf
                                                     i_attachment_subject = 'Attachment'
                                                     i_att_content_hex = ls_attachment ).
        lo_send_request->add_attachment( lo_binary_attach ).
      ENDLOOP.
    ENDIF.

    " Send email without error screen and raise exception if failed
    IF lo_send_request->send( i_with_error_screen = abap_false ) = abap_false.
      RAISE EXCEPTION TYPE cx_root MESSAGE 'Email sending failed'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
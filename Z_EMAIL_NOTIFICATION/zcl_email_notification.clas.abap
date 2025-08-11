CLASS zcl_email_notification DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS send_email
      IMPORTING
        !iv_email_body TYPE string OPTIONAL
        !it_attachments TYPE string OPTIONAL
      RAISING
        cx_root.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_email_notification IMPLEMENTATION.

  METHOD send_email.
    TRY.
      DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).

      " Add test recipient
      lo_mail->add_recipient( 'aliaksandr_pliavaka@email.com' ).

      " Set email subject
      lo_mail->set_subject( 'Test Mail' ).

      " Set email body content as HTML
      lo_mail->set_main( cl_bcs_mail_textpart=>create_text_html( iv_email_body ) ).

      " Add sample attachments for demonstration
      lo_mail->add_attachment( cl_bcs_mail_textpart=>create_text_plain(
        iv_content      = 'This is a text attachment'
        iv_filename     = 'Text_Attachment.txt'
      ) ).

      lo_mail->add_attachment( cl_bcs_mail_textpart=>create_instance(
        iv_content      = '<note><to>John</to><from>Jane</from><body>My nice XML!</body></note>'
        iv_content_type = 'text/xml'
        iv_filename     = 'Text_Attachment.xml'
      ) ).

      " Send the email
      CALL METHOD lo_mail->send(
        IMPORTING et_status = DATA(lt_status)
                  ev_mail_status = DATA(lv_mail_status)
      ).

      " Additional mail status handling can be added here

    CATCH cx_bcs_mail INTO DATA(lx_mail).
      " Handle BCS mail exceptions here
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

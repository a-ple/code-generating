CLASS zcl_email_notification DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    " Main method to send email with optional Excel (.xlsx) attachment
    METHODS send_email
      IMPORTING
        iv_email_body TYPE string
        it_recipients TYPE STANDARD TABLE OF string OPTIONAL
        iv_attachment_xlsx TYPE xstring OPTIONAL.
ENDCLASS.

CLASS zcl_email_notification IMPLEMENTATION.
  METHOD send_email.
    DATA: lo_send_request TYPE REF TO cl_bcs,
          lo_document TYPE REF TO cl_document_bcs,
          lo_sender TYPE REF TO cl_sapuser_bcs,
          lo_recipient TYPE REF TO if_bcs_recipient,
          lv_subject TYPE string VALUE 'SAP Email Notification',
          lv_email TYPE string,
          lv_error TYPE string.

    " Create send request object
    lo_send_request = cl_bcs=>create_persistent( ).

    " Create document with email body (text/plain)
    lo_document = cl_document_bcs=>create_document(
      i_type = 'RAW'
      i_text = iv_email_body
      i_subject = lv_subject
      i_language = sy_langu
    ).

    lo_send_request->set_document( lo_document ).

    " Set the sender (current SAP user)
    lo_sender = cl_sapuser_bcs=>create( ).
    lo_send_request->set_sender( lo_sender ).

    " Determine recipients: use provided table or fallback to constant for testing
    IF it_recipients IS INITIAL.
      lv_email = 'aliaksandr_pliavaka@email.com'.
      lo_recipient = cl_cam_address_bcs=>create_internet_address( lv_email ).
      lo_send_request->add_recipient( lo_recipient ).
    ELSE.
      LOOP AT it_recipients INTO lv_email.
        lo_recipient = cl_cam_address_bcs=>create_internet_address( lv_email ).
        lo_send_request->add_recipient( lo_recipient ).
      ENDLOOP.
    ENDIF.

    " Attach Excel file if provided
    IF iv_attachment_xlsx IS NOT INITIAL.
      TRY.
        DATA(lo_attach) = cl_document_bcs=>create_document(
          i_type = 'XLSX'
          i_subject = |Attachment.xlsx|
          i_binary_content = iv_attachment_xlsx
          i_attachment_type = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        ).
        lo_send_request->add_attachment( lo_attach ).
      CATCH cx_root INTO DATA(lx).
        lv_error = lx->get_text( ).
        " Log or handle error
      ENDTRY.
    ENDIF.

    " Send the mail
    TRY.
      lo_send_request->send( i_with_error_screen = abap_false ).
    CATCH cx_bcs INTO DATA(lx_bcs).
      lv_error = lx_bcs->get_text( ).
      " Log or handle error
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
